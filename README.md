Hướng dẫn cái đặt website siêu nhanh. Vuepress

## Chuẩn bị
* Môi trường cài đặt VPS CentOS-7.
* Node.js 10
* Yarn Classic
* Thao tác với quyền sudo
## Cài đặt cơ bản
* Chạy lệnh `curl` sau để thêm kho lưu trữ NodeSource vào hệ thống của bạn:
```
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
```

* Khi kho lưu trữ được bật, hãy cài đặt Node.js và npm bằng cách:
```
sudo yum install nodejs -y
```

Kiểm tra lại cài đặt node.js:
```
[root@hd vuepress]# node --version
v10.24.1
[root@hd vuepress]# npm --version
6.14.12
```

Khi lưu trữ chính thức của Yarn được duy trì nhất quán và cung cấp phiên bản cập nhật mới nhất. Để bật kho lưu trữ yarn và nhập khóa GPG của kho lưu trữ, thực hiện lệnh sau:
```
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
```

* Cài đặt yarn bằng cách chạy lệnh:
```
sudo yum install yarn -y
```

Kiểm tra cài đặt yarn version:
```
[root@hd vuepress]# yarn --version
1.22.5
```
## Bắt đầu tạo web
### Cài đặt
Tạo một project có tên là **vuepress**:

```
mkdir vuepress
cd vuepress
yarn init
```

* Cài đặt vuepress và vuepress-theme-meteorlxy:
```
npm install vuepress vuepress-theme-meteorlxy
```

hoặc lệnh sau:
```
yarn add -D vuepress vuepress-theme-meteorlxy
```
* Tạo tài liệu đầu tiên của bạn:
```
mkdir docs && echo '# Hello VuePress' > docs/README.md
```
* Thêm script sau vào file package.json, tên của thư mục chứa các dữ liệu gốc:
```
{
  "scripts": {
    "vuepress:dev": "vuepress dev <src>",
    "vuepress:build": "vuepress build <src> --dest dist"
  }
}
```
Ví dụ mình đang đặt tất cả dữ liệu tại thư mục **docs** thì thực hiện tệp `package.json` như sau:
```
{
  "name": "vuepress-docs2",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "vuepress:dev": "vuepress dev docs",
    "vuepress:build": "vuepress build docs --dest dist"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "vuepress": "^1.8.2"
  }
}

```

Chạy lệnh sau:
```
yarn vuepress:dev
```

Tạo thư mục /vuepress/docs tệp cấu hình. Cấu trúc như sau:
```
vuepress
├── docs
│   ├── README.md
│   └── .vuepress
│       └── config.js
│       └── dir1
│           └── content1.md
│           └── content2.md
│           └── content3.md
│           └── content4.md
│           └── contact.md
│           └── support.md
│           └── README.md
└── node_modules
└── package.json
└── yarn.lock
```

Cấu hình file config.js

```cd ~/vuepress/docs
mkdir .vuepress
vi config.js
```
Thêm các thành phần cấu hình sau vào:
```

module.exports = {
    title: 'Logo-Tiêu đề Web',// tiêu đề
    path: '/',// Tại đây nó gọi ra file README.md tại thư mục docs
    port: 80,// Port được sử dụng
    description: 'pay to best',
    themeConfig: {
        smoothScroll: true,
        searchPlaceholder: 'Search...', //Chữ nền bên trong ô tìm kiếm

        //Tạo nav
        nav: [
            { text: 'Link', link: 'onedata.vn', target: '_blank' }
        ],
        sidebarDepth: 0, //default: 1, trích dẫn đến h2, =0 vô hiệu hóa liên kết tiêu đề ở sidebar
        //displayAllHeaders: true,
        //activeHeaderLinks: false,
        sidebar: [
            {
                title: 'side1', //Phần này sẽ được hiện thị ở sidebar
                collapsable: false, //buộc bên trong luôn trích dẫn 
                children: [
                    '/dir/content1', // sẽ gọi ra file content1.md ở thư mục web, tương tự với các content bên dưới
                    '/dir/content2',
                    '/dir/content3',
                    '/dir/content4',
                ],
            },
            {
                //initialOpenGroupIndex: -1,  //Xác định index của nhóm con được mở ban đầu
                title: 'Liên hệ',
                path: '/dir/contact',            
            },
            {
                title: 'Hỗ trợ',
                path: '/dir/support'
            }
        ]
    }
}
```


Khi thực hiện lệnh `yarn vuepress:dev` thì nodejs sẽ chạy nền Foreground trong Linux, tức nghĩa nó sẽ chiếm cửa sổ dòng lệnh. Đến khi hoàn thành. Vậy khi bạn thoát khỏi phiên thì nó sẽ không sử dụng web.


Thực hiện lệnh sau để chạy như một dịch vụ:

`vi /etc/systemd/system/vuepress.service`

Thêm vào file vừa tạo các lệnh sau:
```
[Unit]
Description= env vuepress
After=network.target

[Service]
PermissionsStartOnly=True
User=root
Group=root
WorkingDirectory=/root/docsnapthe247/
ExecStart=/usr/bin/yarn run vuepress:dev
Restart=on-failure
[Install]
WantedBy=multi-user.target
```

Thực hiện các lệnh sau:
```
systemctl daemon-reload
systemctl start vuepress
systemctl enable vuepress
```

Kiểm tra xem dịch vụ đang hoạt động:

```
[root@centos7 ~]# systemctl status vuepress
● vuepress.service - env vuepress
   Loaded: loaded (/etc/systemd/system/vuepress.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-07-15 13:38:08 +07; 1h 45min ago
 Main PID: 12109 (node)
   CGroup: /system.slice/vuepress.service
           ├─12109 node /usr/bin/yarn run dev
           └─12120 /usr/bin/node /root/docsnapthe247/node_modules/.bin/vu...

```