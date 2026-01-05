/**
 * apply-geckoview.js
 * 
 * 这个脚本在 npm install 后运行，将 @web-media/capacitor-geckoview 的内容
 * 复制到 @capacitor/android 目录，使 Capacitor 使用 GeckoView 而不是系统 WebView。
 * 
 * 注意：使用 AGP 7.4.2，不需要 namespace patching。
 */

const fs = require('fs');
const path = require('path');

const GECKOVIEW_PATH = path.join(__dirname, '..', 'node_modules', '@web-media', 'capacitor-geckoview');
const CAPACITOR_ANDROID_PATH = path.join(__dirname, '..', 'node_modules', '@capacitor', 'android');

console.log('🦎 Applying GeckoView to Capacitor Android...');

// 检查 GeckoView 插件是否存在
if (!fs.existsSync(GECKOVIEW_PATH)) {
    console.log('⚠️ @web-media/capacitor-geckoview not found, skipping...');
    process.exit(0);
}

// 检查 Capacitor Android 是否存在
if (!fs.existsSync(CAPACITOR_ANDROID_PATH)) {
    console.log('⚠️ @capacitor/android not found, skipping...');
    process.exit(0);
}

// 递归复制目录
function copyDir(src, dest) {
    if (!fs.existsSync(dest)) {
        fs.mkdirSync(dest, { recursive: true });
    }

    const entries = fs.readdirSync(src, { withFileTypes: true });

    for (const entry of entries) {
        const srcPath = path.join(src, entry.name);
        const destPath = path.join(dest, entry.name);

        if (entry.isDirectory()) {
            copyDir(srcPath, destPath);
        } else {
            fs.copyFileSync(srcPath, destPath);
        }
    }
}

try {
    // 复制 capacitor 目录 (核心 Android 代码)
    const geckoCapacitorDir = path.join(GECKOVIEW_PATH, 'capacitor');
    const targetCapacitorDir = path.join(CAPACITOR_ANDROID_PATH, 'capacitor');

    if (fs.existsSync(geckoCapacitorDir)) {
        console.log('  Copying GeckoView capacitor module...');
        copyDir(geckoCapacitorDir, targetCapacitorDir);
        console.log('✅ GeckoView applied successfully!');
        console.log('   GeckoView source:', geckoCapacitorDir);
        console.log('   Target:', targetCapacitorDir);
    } else {
        console.log('⚠️ GeckoView capacitor directory not found at:', geckoCapacitorDir);
        console.log('   Checking available contents...');
        if (fs.existsSync(GECKOVIEW_PATH)) {
            console.log('   Available:', fs.readdirSync(GECKOVIEW_PATH).join(', '));
        }
    }
} catch (error) {
    console.error('❌ Error applying GeckoView:', error.message);
    // 不要失败，让构建继续
    process.exit(0);
}
