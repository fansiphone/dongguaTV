// Service Worker with Image Caching for dongguaTV
const CACHE_VERSION = 'v4';
const STATIC_CACHE = 'donggua-static-' + CACHE_VERSION;
const IMAGE_CACHE = 'donggua-images-' + CACHE_VERSION;

// 静态资源（应用核心文件）
const STATIC_URLS = [
    './',
    './index.html',
    './manifest.json',
    './icon.png',
    './libs/css/bootstrap.min.css',
    './libs/css/animate.min.css',
    './libs/css/fontawesome.min.css',
    './libs/js/vue.global.prod.min.js',
    './libs/js/bootstrap.bundle.min.js',
    './libs/js/hls.min.js',
    './libs/js/DPlayer.min.js'
];

// 图片缓存配置
const IMAGE_HOSTS = [
    'image.tmdb.org',
    'i.tmdb.org'
];

// 图片缓存最大数量（防止缓存无限增长）
// 500张缓存估算占用 30MB 空间
const MAX_IMAGE_CACHE = 500;

self.addEventListener('install', event => {
    console.log('[SW] Installing...');
    event.waitUntil(
        caches.open(STATIC_CACHE)
            .then(cache => {
                console.log('[SW] Caching static assets');
                return cache.addAll(STATIC_URLS);
            })
    );
    self.skipWaiting();
});

self.addEventListener('activate', event => {
    console.log('[SW] Activating...');
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    // 删除旧版本缓存
                    if (cacheName !== STATIC_CACHE && cacheName !== IMAGE_CACHE) {
                        console.log('[SW] Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => self.clients.claim())
    );
});

self.addEventListener('fetch', event => {
    const url = new URL(event.request.url);

    // 策略1：TMDB 图片 (包含官方域名和本地反代) - Cache First
    if (IMAGE_HOSTS.some(host => url.hostname.includes(host)) || url.pathname.startsWith('/api/tmdb-image')) {
        event.respondWith(handleImageRequest(event.request));
        return;
    }

    // 策略2：静态资源 - Cache First
    if (STATIC_URLS.some(staticUrl => event.request.url.includes(staticUrl))) {
        event.respondWith(
            caches.match(event.request).then(cached => {
                return cached || fetch(event.request);
            })
        );
        return;
    }

    // 策略3：其他请求 - Network First
    event.respondWith(
        fetch(event.request)
            .then(response => {
                // 只缓存同源请求
                if (response && response.status === 200 && url.origin === self.location.origin) {
                    const responseToCache = response.clone();
                    caches.open(STATIC_CACHE).then(cache => {
                        cache.put(event.request, responseToCache);
                    });
                }
                return response;
            })
            .catch(() => caches.match(event.request))
    );
});

// 图片请求处理 - Cache First 策略
async function handleImageRequest(request) {
    const cache = await caches.open(IMAGE_CACHE);

    // 1. 尝试从缓存获取
    const cached = await cache.match(request);
    if (cached) {
        console.log('[SW] Image from cache:', request.url.substring(0, 60) + '...');
        return cached;
    }

    // 2. 从网络获取并缓存
    try {
        const response = await fetch(request);
        if (response && response.status === 200) {
            // 缓存图片
            cache.put(request, response.clone());
            // 清理过多的缓存
            trimImageCache(cache);
            console.log('[SW] Image cached:', request.url.substring(0, 60) + '...');
        }
        return response;
    } catch (error) {
        console.error('[SW] Image fetch failed:', error);
        // 返回占位图
        return new Response(
            '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="450"><rect fill="#333" width="300" height="450"/><text fill="#666" x="50%" y="50%" text-anchor="middle" dy=".3em" font-size="16">加载失败</text></svg>',
            { headers: { 'Content-Type': 'image/svg+xml' } }
        );
    }
}

// 清理过多的图片缓存
async function trimImageCache(cache) {
    const keys = await cache.keys();
    if (keys.length > MAX_IMAGE_CACHE) {
        // 删除最早的缓存（FIFO）
        const deleteCount = keys.length - MAX_IMAGE_CACHE;
        console.log(`[SW] Trimming ${deleteCount} old cached images`);
        for (let i = 0; i < deleteCount; i++) {
            await cache.delete(keys[i]);
        }
    }
}

// 监听消息（可选：手动清理缓存）
self.addEventListener('message', event => {
    if (event.data === 'clearImageCache') {
        caches.delete(IMAGE_CACHE).then(() => {
            console.log('[SW] Image cache cleared');
        });
    }
});
