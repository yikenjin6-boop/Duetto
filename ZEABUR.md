# 用手机部署 Duetto

这是独立的听歌服务。部署完成后，在手机上配置网易云账号和自己的模型接口。

## 1. 仓库已准备好

你的仓库是 https://github.com/yikenjin6-boop/Duetto 。

这个部署版本在原项目上增加了 `Dockerfile`、`.dockerignore`、健康检查和首页入口。直接进行下一步即可。

## 2. 新建 Zeabur 服务

在现有 Zeabur 项目里点 **添加服务 → GitHub**，选择自己的 `Duetto` 仓库。若列表里找不到，在 **Configure GitHub** 中给 Zeabur 开放这个仓库的访问权限。

使用仓库根目录与 `main` 分支。Zeabur 会自动读取根目录的 `Dockerfile`，使用 Node 24；无需填写前端构建命令。启动命令已经设为 `node server/index.mjs`。

该服务默认监听 `4183`，健康检查地址为 `/api/health`。在变量页确认以下两个值：

| 变量 | 值 |
| --- | --- |
| `PORT` | `4183` |
| `DUETTO_DATA_DIR` | `/data` |

## 3. 先挂持久化磁盘

进入这个新服务的 **Volumes → Mount Volumes**：

| 字段 | 填写内容 |
| --- | --- |
| Volume ID | `duetto-data` |
| Mount Directory | `/data` |

**挂好磁盘后，再设置 PIN、登录网易云和使用播放器。** Zeabur 首次挂载会替换该目录原有内容；所以首次配置必须放在挂载之后。

这个目录保存 PIN、设置、网易云登录状态和 SQLite 听歌档案。Dockerfile 指定保存目录本身并不会创建 Zeabur 持久化磁盘，必须完成上述挂载。

## 4. 打开和首次配置

在网络/域名页面生成 HTTPS 域名。部署显示 **Running** 后打开域名，会进入 `/pkg/index.html`。

1. 设门禁 PIN（至少 4 位）。新设备打开时输入同一 PIN。
2. **曲库 → 扫码登录**，按页面提示登录网易云。
3. **一起听 → 模型设置**，填写自己的 OpenAI 兼容接口地址、API Key 和模型名，再填写双方昵称与人设。分析模型可以先留空。
4. 搜索并手动播放一首歌，确认音源可用，再让 AI 选歌或切歌。
5. iPhone Safari 的分享菜单中点 **添加到主屏幕**。

音乐能否完整播放取决于网易云账号权限、歌曲版权和部署地区的音源访问情况。AI 真正分析音频还需要支持音频输入的模型；普通聊天模型仍可按歌词和聊天内容选歌。

## 5. 检查保存与后续更新

设好昵称并产生一条听歌记录后，在 Zeabur 重启这个新服务。重新打开后，确认仍使用原 PIN、昵称与听歌记录。重启时有短暂中断属于挂载磁盘服务的正常行为。

以后更新代码时继续使用同一个服务、同一块 `/data` 磁盘。模型 Key 在 Duetto 页面填写即可，不要写入 GitHub 仓库。

## 参考

- 原项目使用说明：https://github.com/avisforevelyn/Duetto/blob/main/GUIDE.md
- Zeabur GitHub 部署：https://zeabur.com/docs/en-US/deploy/methods/github-integration
- Zeabur Dockerfile：https://zeabur.com/docs/en-US/deploy/methods/dockerfile
- Zeabur 持久化磁盘：https://zeabur.com/docs/en-US/data-management/volumes
