# ss-privoxy
[shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) v3.3.4 + [privoxy](https://www.privoxy.org/) + [gfwlist](https://github.com/gfwlist/gfwlist)

## Shadowsocks 启动参数
- `SERVER_ADDR` 服务器地址
- `SERVER_PORT` 服务器端口
- `PASSWORD` 密码
- `METHOD` 加密方式
- `TIMEOUT` 超时时长
- `LISTEN_ADDR` 监听 IP，默认监听 `1080` 端口
- `SS_ARGS` 其他可选参数

## Privoxy 配置
- `/etc/privoxy/config` [Privoxy 配置文件](https://www.privoxy.org/user-manual/config.html)，可挂载自定义配置文件替换
- 默认监听所有 IP，端口 `8118`

## 分流规则
- 默认启用 `gfwlist.action` 规则，使用 [gfwlist2privoxy](https://github.com/zfl9/gfwlist2privoxy) 转换
- 也可使用 `SS_ARGS` 参数，为 Shadowsocks 启用 [ACL 规则文件](https://github.com/ACL4SSR/ACL4SSR)

## Docker 用法
```bash
docker run -d --name ss-privoxy \
  -p 1080:1080 -p 8118:8118 \
  -e SERVER_ADDR={YOUR SERVER} \
  -e SERVER_PORT={SERVER PORT} \
  -e PASSWORD={YOUR PASSWORD} \
  -e METHOD=aes-256-gcm \
  -e TIMEOUT=300 \
  -e LISTEN_ADDR=127.0.0.1 \
  -e ARGS=-v \
  antileech/ss-privoxy
```
