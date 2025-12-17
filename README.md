# 冬瓜TV MAX (DongguaTV Enhanced Edition)

这是一个经过全面重构和升级的现代流媒体聚合播放器，基于 Node.js 和 Vue 3 构建。相比原版，本作引入了 Netflix 风格的沉浸式 UI、TMDb 数据驱动的动态榜单、以及智能的多源聚合搜索功能。


## ✨ 核心特性 (Core Features)

### 1. 🎬 双引擎数据驱动
- **TMDb (The Movie Database)**：提供高质量的电影/剧集元数据（海报、背景图、评分、简介、演职员表）。
- **CMS 聚合源 (Maccms)**：集成 **48+** 个第三方资源站 API，自动进行**全网测速**，智能过滤失效源，确保播放流畅。

### 2. 🔍 智能搜索与聚合
- **实时流式搜索 (SSE)**：采用 Server-Sent Events 技术，搜索结果**边搜边显**，即时反馈，无需等待所有源响应。
- **智能翻译搜索**：自动检测英文标题并翻译为中文，提高中文资源站的匹配率。
- **自动分组与实时合并**：同一影片的不同线路自动聚合，新搜索到的源实时合并到已有卡片，右上角源数量实时跳动。
- **SQLite 永久缓存**：内置高性能 SQLite 数据库缓存，支持无限存储，读写速度极快，热搜词秒级响应。

### 3. 📺 沉浸式播放体验
- **影院模式**：全新设计的播放详情页，采用暗色系沉浸布局，支持剧集网格选择。
- **智能线路测速**：支持用户端直连测速和服务器代理测速，真实反映视频可用性。
- **自动故障转移**：播放失败时自动切换到下一个可用线路，无需手动操作。
- **投屏支持**：集成 DLNA/AirPlay 本地投屏功能（需浏览器支持）。

### 4. 🌏 大陆用户优化
- **IP 自动检测**：自动识别大陆用户，切换到 TMDB 反代地址。
- **一键安装脚本**：支持交互式配置 API Key、反代地址、运行端口。

### 5. 📱 多端支持
- **Android TV / 盒子**：提供专属 APK 安装包，完美适配电视遥控器操作，支持 Android TV 桌面启动 (Leanback Launcher)。
- **移动端 App**：基于现代 Web 技术封装，体验接近原生应用。
- **PWA 支持**：支持添加到主屏幕，即点即用。

### 6. 🔒 安全与访问控制
- **全局访问密码**：支持设置全局访问密码，保护您的隐私站点。
- **本地资源优先**：内置静态资源库，避免 CDN 劫持或加载缓慢，提升国内访问速度。
- **远程配置加载**：支持从远程 URL 加载 `db.json` 配置文件，方便多站点统一管理。

---

## 🎨 界面与交互升级 (UI/UX Upgrades)

相比原版，我们在 UI/UX 上做了颠覆性的改进：

| 功能区域 | 原版体验 | **MAX 版体验** |
| :--- | :--- | :--- |
| **首页视觉** | 简单的列表罗列 | **Netflix 风格 Hero 轮播**：全屏动态背景、高斯模糊遮罩、Top 10 排名特效。 |
| **导航栏** | 固定顶部 | **智能融合导航**：初始透明，滚动变黑；分类点击自动平滑滚动定位。 |
| **搜索框** | 顶部固定位置 | **动态交互搜索栏**：初始占满全屏，下滑自动吸顶并缩小为"胶囊"悬浮。 |
| **榜单浏览** | 有限的静态列表 | **无限滚动 (Infinite Scroll)**：20+ 个细分榜单，支持向右无限加载。 |
| **搜索体验** | 需等待 loading 结束 | **实时流式加载 (SSE)**：结果即时呈现，源数量实时跳动增加，拒绝枯燥等待。 |
| **线路选择** | 单一延迟显示 | **双模式测速**：区分"直连"(用户端)和"代理"(服务器端) 测速，更准确。 |
| **播放失败** | 需手动切换 | **自动故障转移**：检测播放失败后自动切换到下一可用线路。 |
| **启动体验** | 页面分块加载 | **优雅启动屏**：新增应用级启动画面，资源加载完成后丝滑过渡，拒绝白屏。 |
| **分类系统** | 仅支持搜索跳转 | **全直达榜单**：历史、冒险、综艺等分类均拥有独立的数据流榜单。 |

---

## 🛠️ 技术栈 (Tech Stack)

| 类别 | 技术 |
|------|------|
| **Frontend** | Vue.js 3 (CDN), Bootstrap 5, FontAwesome 6, DPlayer, HLS.js |
| **Backend** | Node.js, Express, Axios |
| **Data Sources** | TMDb API v3, 48+ Maccms CMS APIs |
| **Deployment** | Docker, Vercel, PM2, 宝塔面板 |
| **Cache** | Flexible: SQLite (Recommended), JSON File, or Memory |
| **Proxy** | Cloudflare Workers (for China users) |

---

## 🔧 前置准备

### 1. ⚠️ 配置采集源 (重要)

本项目**不包含**任何内置的影视资源接口。在运行项目前（或运行后），您必须自行添加合法的 Maccms V10 (JSON格式) 接口才能搜索和播放视频。

**配置方法：**
所有的采集源配置均存储在根目录的 `db.json` 文件中。

1.  项目初次运行时会自动生成 `db.json`（如果未生成，可以手动创建或使用模板）。
2.  打开 `db.json`，找到 `sites` 数组。
3.  填入您找到的采集接口信息：

```json
{
  "sites": [
    {
      "key": "unique_key1",       // 唯一标识符（英文字母，不可重复）
      "name": "站点名称1",         // 显示在界面的名称
      "api": "https://...",      // Maccms V10/JSON 接口地址
      "active": true             // 是否启用 (true/false)
    },
    {
      "key": "unique_key2",       // 唯一标识符（英文字母，不可重复）
      "name": "站点名称2",         // 显示在界面的名称
      "api": "https://...",      // Maccms V10/JSON 接口地址
      "active": true             // 是否启用 (true/false)
    }
  ]
}
```
4.  保存文件并**重启服务**。

### 2. 获取 TMDb API Key (必需)
本项目依赖 **The Movie Database (TMDb)** 提供影视元数据。

1.  注册账户：访问 [Create Account](https://www.themoviedb.org/signup) 注册并登录。
2.  申请 API：访问 [API Settings](https://www.themoviedb.org/settings/api)，点击 **"Create"** 或 **"click here"** 申请。
3.  填写信息：应用类型选择 **"Developer"**，简单填写用途（如 "Personal learning project"）。
4.  获取 Key：申请通过后，复制 **"API Key (v3 auth)"** 备用。

### 3. 大陆用户：部署 TMDB 反代 (可选)

由于 TMDB 在大陆无法直接访问，需要配置反向代理以正常显示海报和影视信息。

#### 方案一：部署 Cloudflare Workers 反代 (推荐)

1.  **登录 Cloudflare**
    - 访问 [Cloudflare Dashboard](https://dash.cloudflare.com/)
    - 选择左侧菜单 **"Workers & Pages"** → **"Create application"** → **"Create Worker"**

2.  **部署反代代码**
    - 给 Worker 取名（如 `tmdb-proxy`），点击 **Deploy**
    - 部署后点击 **"Edit code"**
    - 复制 `cloudflare-tmdb-proxy.js` 文件内容，粘贴到编辑器
    - 点击 **"Save and Deploy"**

3.  **获取 Worker URL**
    部署成功后获得 URL，如：`https://tmdb-proxy.your-name.workers.dev`

4.  **稍后在安装时配置**
    在 `.env` 文件中添加：
    ```env
    TMDB_PROXY_URL=https://tmdb-proxy.your-name.workers.dev
    ```

#### 方案二：使用自建 Nginx 反代

```nginx
location /tmdb-api/ {
    proxy_pass https://api.themoviedb.org/;
    proxy_set_header Host api.themoviedb.org;
}

location /tmdb-image/ {
    proxy_pass https://image.tmdb.org/;
    proxy_set_header Host image.tmdb.org;
}
```

### 4. 🔒 安全配置与远程加载 (高级)

为了保护您的站点或统一管理配置，可以使用以下高级功能：

#### 全局访问密码
在 `.env` 文件中设置 `ACCESS_PASSWORD` 即可开启全局密码保护。开启后，用户访问任何页面都需要输入密码。
```env
ACCESS_PASSWORD=your_secure_password
```

#### 远程配置文件 (db.json)
如果您有多个站点或希望远程更新配置，可以让服务器读取远程的 `db.json` 文件。
在 `.env` 文件中设置：
```env
# 远程 JSON 文件地址 (需支持 GET 请求)
REMOTE_DB_URL=https://example.com/my-config/db.json
```
> **注意**：
> 1. 配置 `REMOTE_DB_URL` 后，系统会自动优先尝试从该 URL 获取配置。
> 2. 会有 5 分钟的内存缓存，避免频繁请求远程服务器。
> 3. 如果远程获取失败，会自动降级使用本地的 `db.json` 文件。

---

## 📦 安装与运行 (Installation)

### 🚀 一键安装脚本 (推荐)

适用于 Ubuntu/Debian/CentOS 系统，自动安装所有依赖并配置服务。

```bash
# 下载并运行一键安装脚本
curl -fsSL https://raw.githubusercontent.com/ednovas/dongguaTV/main/install.sh | bash
```

或者手动下载后运行：
```bash
wget https://raw.githubusercontent.com/ednovas/dongguaTV/main/install.sh
chmod +x install.sh
./install.sh
```

脚本会引导您输入：
- TMDB API Key (必填)
- TMDB 反代地址 (可选，大陆用户需要)
- 运行端口 (默认 3000)
- 运行端口 (默认 3000)
- 安装目录 (默认 /opt/dongguaTV)

> **提示**：安装完成后，您可以随时编辑安装目录下的 `.env` 文件，修改 `CACHE_TYPE` 来切换缓存模式（需要重启服务）。

---

### 手动本地运行

#### 1. 安装 Node.js (v18+)

**Ubuntu/Debian:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**CentOS/RHEL:**
```bash
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
```

**macOS (使用 Homebrew):**
```bash
brew install node@18
```

**Windows:**
下载安装包：https://nodejs.org/

验证安装：
```bash
node -v  # 应显示 v18.x.x
npm -v   # 应显示 9.x.x 或更高
```

#### 2. 安装编译工具 (可选)
如果您计划使用 `sqlite` 作为缓存（默认推荐），则必须安装编译工具。如果不使用 SQLite (如使用 `json` 或 `memory` 模式)，可跳过此步。

**Ubuntu/Debian:**
```bash
sudo apt-get install -y build-essential python3
```

**CentOS/RHEL:**
```bash
sudo yum groupinstall -y "Development Tools"
sudo yum install -y python3
```

**macOS:**
```bash
xcode-select --install
```

#### 3. 安装项目依赖
```bash
npm install
```

#### 4. 配置环境变量
复制 `.env.example` 为 `.env`，并配置如下信息：
```env
# TMDb API Key (必填)
TMDB_API_KEY=your_api_key_here

# 可选：自定义端口 (默认 3000)
PORT=3000

# 可选：大陆用户 TMDB 反代地址 (详见下方说明)
TMDB_PROXY_URL=

# 可选：缓存类型 ('json', 'sqlite', 'memory', 'none') - 默认 json
CACHE_TYPE=json

# 可选：访问密码 (设置后需要密码才能访问)
ACCESS_PASSWORD=

# 可选：远程配置文件地址
REMOTE_DB_URL=
```

#### 5. 启动服务
```bash
node server.js
```

#### 6. 访问
打开浏览器访问 `http://localhost:3000`

---

## 🚀 部署 (Deployment)

### 🐳 Docker 部署 (推荐)

#### 环境变量说明

| 变量名 | 必填 | 说明 |
|--------|------|------|
| `TMDB_API_KEY` | ✅ 是 | TMDb API 密钥，用于获取影视信息 |
| `CACHE_TYPE` | ❌ 否 | 缓存类型: `json`(默认), `sqlite`, `memory`, `none` |
| `TMDB_PROXY_URL` | ❌ 否 | TMDB 反代地址，大陆用户需要配置 |
| `PORT` | ❌ 否 | 服务端口，默认 3000 |
| `ACCESS_PASSWORD` | ❌ 否 | 访问密码，保护站点不被公开访问 |
| `REMOTE_DB_URL` | ❌ 否 | 远程 `db.json` 地址，用于统一配置管理 |

#### 方案一：使用现有镜像（最快）
无需构建，一行命令直接运行。

```bash
# 基础启动 (请替换 TMDB_API_KEY)
docker run -d -p 3000:3000 \
  -e TMDB_API_KEY="your_api_key_here" \
  --name donggua-tv \
  --restart unless-stopped \
  ghcr.io/ednovas/dongguatv:latest

```bash
# 1. ⚠️ 重要：先创建文件，防止 Docker 将其识别为目录
touch db.json cache.db
# 如果是 Windows PowerShell:
# New-Item -ItemType File -Name db.json -Force
# New-Item -ItemType File -Name cache.db -Force

# 2. 写入默认配置 (可选，如果不写则为空)
echo '{"sites":[]}' > db.json

# 3. 完整配置启动
docker run -d -p 3000:3000 \
  -e TMDB_API_KEY="your_api_key_here" \
  -e TMDB_PROXY_URL="https://tmdb-proxy.your-name.workers.dev" \
  -v $(pwd)/db.json:/app/db.json \
  -v $(pwd)/cache.db:/app/cache.db \
  --name donggua-tv \
  --restart unless-stopped \
  ghcr.io/ednovas/dongguatv:latest
```

> **🔴 常见错误警告**：如果启动失败且日志报错 `EISDIR: illegal operation on a directory`，说明您没有先创建 `db.json` 文件，Docker 自动创建了同名文件夹。请删除该文件夹 (`rm -rf db.json`) 并重新执行上述 `touch` 命令创建文件。


> **注意**：如果不挂载 `-v` 卷，您的站点配置(db.json)和缓存(cache.db)将在容器重启后丢失。请确保当前目录下有 `db.json` 文件（如果没有，第一次运行后可以从容器内复制出来）。

#### 方案二：本地构建
如果您想自己修改代码或重新构建镜像：

1.  **构建镜像**
    ```bash
    docker build -t donggua-tv .
    ```
2.  **运行容器**
    ```bash
    docker run -d -p 3000:3000 \
      -e TMDB_API_KEY="your_api_key_here" \
      -e TMDB_PROXY_URL="https://tmdb-proxy.your-name.workers.dev" \
      --name donggua-tv \
      --restart unless-stopped \
      donggua-tv
    ```

#### 方案三：Docker Compose
如果您更喜欢使用 Compose 管理：

1.  创建 `docker-compose.yml` 文件：
    ```yaml
    version: '3'
    services:
      donggua-tv:
        image: ghcr.io/ednovas/dongguatv:latest
        container_name: donggua-tv
        ports:
          - "3000:3000"
        environment:
          - TMDB_API_KEY=your_api_key_here
          - TMDB_PROXY_URL=https://tmdb-proxy.your-name.workers.dev
        volumes:
          - ./db.json:/app/db.json
          - ./cache.db:/app/cache.db
        restart: unless-stopped
    ```
    ```
2.  **启动**
    ```bash
    # 同样需要先创建文件，防止挂载成目录
    touch db.json cache.db
    
    # 启动服务
    docker-compose up -d
    ```

### ▲ Vercel 部署
适合零成本快速上线。
*注意：部署完成后，请务必在 Vercel 控制台的 **Settings -> Environment Variables** 中添加 `TMDB_API_KEY`。*

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fednovas%2FdongguaTV&env=TMDB_API_KEY,ACCESS_PASSWORD,TMDB_PROXY_URL,REMOTE_DB_URL)

*(请确保先将本项目fork到您自己的 GitHub 仓库，点击上方按钮即可一键导入部署)*

### 🖥️ Linux 服务器命令行部署 (PM2)
适合常规 VPS (Ubuntu/CentOS/Debian)。

1.  **环境准备**
    ```bash
    # 安装 Node.js (v18+)
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    
    # 安装 PM2 进程管理器
    npm install -g pm2
    ```

2.  **获取代码与运行**
    ```bash
    git clone https://github.com/ednovas/dongguaTV.git
    cd dongguaTV
    npm install
    
    # 配置环境变量
    cp .env.example .env
    # 编辑 .env文件填入您的 TMDB_API_KEY
    nano .env
    
    # 使用 PM2 启动服务
    pm2 start server.js --name "donggua-tv"
    
    # 设置开机自启
    pm2 save && pm2 startup
    ```

### 🏰 宝塔面板 (aaPanel) 部署
可视化管理，不需要懂代码。

1.  在 **软件商店** 搜索并安装 **Node.js版本管理器** (建议选择 v18+)。
2.  **⚠️ 重要：安装编译工具** (better-sqlite3 需要)：
    *   登录 SSH 终端。
    *   执行安装命令：
        ```bash
        # CentOS/RedHat
        sudo yum groupinstall "Development Tools" -y
        sudo yum install python3 -y

        # Ubuntu/Debian
        sudo apt-get install build-essential python3 -y
        ```
3.  在 **网站** -> **Node项目** -> **添加Node项目**。
    *   **项目目录**：选择上传代码的文件夹 (例如 `/www/wwwroot/dongguaTV`)。
    *   **启动选项**：`server.js`。
    *   **项目端口**：`3000`。
3.  **配置环境变量**：
    *   在 **文件** 栏目进入项目目录。
    *   将 `.env.example` 重命名为 `.env`。
    *   编辑 `.env` 文件，配置以下内容：
    ```env
    # 必填：TMDb API Key
    TMDB_API_KEY=your_api_key_here
    
    # 可选：运行端口
    PORT=3000

    # 可选：缓存类型 ('json', 'sqlite', 'memory', 'none')
    CACHE_TYPE=json
    
    # 可选：大陆用户 TMDB 反代地址
    # 如果您的服务器在大陆，请参考"大陆用户配置"章节部署反代
    TMDB_PROXY_URL=https://tmdb-proxy.your-name.workers.dev
    ```
    *   保存后回到 **Node项目** 列表，点击 **重启** 服务。
4.  点击 **映射/绑定域名**，输入您的域名 (如 `movie.example.com`)。
5.  访问域名即可使用。

### 🤖 Android APP 构建 (GitHub Actions)

本项目配置了自动化构建流程，您可以轻松编译自己的 Android 客户端。

1.  **Fork 本仓库** 到您的 GitHub 账号。
2.  **提交 Tag**：
    每当您推送一个以 `v` 开头的 Tag (例如 `v1.0.0`) 到仓库时，GitHub Actions 会自动触发构建。
    ```bash
    git tag v1.0.0
    git push origin v1.0.0
    ```
3.  **下载 APK**：
    构建完成后，在 GitHub 仓库的 **"Releases"** 页面即可下载生成的 `.apk` 安装包。
    *此 APK 包含完整的电视端 (Android TV) 适配。*





---

## 💾 数据维护与备份

本项目的核心数据存储在以下两个文件中，建议定期备份：

1.  **`db.json`**：存储所有的采集源配置信息（重要）。
2.  **`cache.db`** (SQLite模式)：存储搜索结果和详情的数据库文件。
3.  **`cache_search.json` / `cache_detail.json`** (JSON模式)：存储缓存的 JSON 文件。

### 备份命令示例
```bash
# 备份到当前用户的 backup 目录
mkdir -p ~/backup
cp /opt/dongguaTV/db.json ~/backup/
# 如果使用 SQLite
[ -f /opt/dongguaTV/cache.db ] && cp /opt/dongguaTV/cache.db ~/backup/
# 如果使用 JSON
[ -f /opt/dongguaTV/cache_search.json ] && cp /opt/dongguaTV/cache_search.json ~/backup/
```

### 清理缓存
```bash
# SQLite 模式
rm /opt/dongguaTV/cache.db

# JSON 模式
rm /opt/dongguaTV/cache_*.json

# 重启服务生效
pm2 restart donggua-tv
```

---

## 📝 贡献与致谢

本项目由 **kk爱吃王哥呆阿龟头** 设计编写， **ednovas** 优化了功能和部署流程。
数据由 **TMDb** 和各式 **Maccms** API 提供。


## ⚠️ 免责声明 (Disclaimer)

1.  **仅供学习交流**：本项目仅作为 Node.js 和 Vue 3 的学习练手项目开源，旨在展示前后端交互、数据聚合与 UI 设计技术。
2.  **API 说明**：本项目**不内置**任何有效的影视资源采集接口。README 或代码演示中可能出现的 API 地址仅为占位符或示例，不保证可用性。
3.  **自行配置**：使用者需自行寻找合法的 Maccms V10/JSON 格式的采集接口，并遵守相关法律法规。
4.  **内容无关**：开发者不存储、不发布、不参与任何视频内容的制作与传播，对用户配置的内容不承担任何责任。

---

*Enjoy your movie night! 🍿*
