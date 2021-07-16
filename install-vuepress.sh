#!/bin/bash 


cat /etc/os-release* |grep 'ubuntu' > /dev/null 2>&1 && OS='Ubuntu'
cat /etc/os-release* |grep 'centos' > /dev/null 2>&1 && OS='CentOS' 
echo $OS

if [ "$OS"="CentOS" ]
then
install_vuepress 
fi

install_vuepress(){
yum update -y
yum groupinstall "Development Tools" -y
yum install python3-devel -y
yum install python3 -y
yum install python3-pip -y
pip3 install virtualenv
yum install -y git curl
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
sudo yum install yarn -y
cd ~
mkdir vuepress-demo
cd vuepress-demo
npm init --yes # or #yarn init --yes
npm install vuepress@1.8.2 --save-dev #or #yarn add -D vuepress vuepress-theme-meteorlxy
yarn add -D vuepress
mkdir docs && echo -e "
# Hello VuePress
This is called by docs/REAMDE.md" > docs/README.md

cp ~/vuepress-demo/package.json ~/vuepress-demo/package.json.bak

# Chỉnh sửa file cấu hình

awk 'NR==8{print "   , \n    \"vuepress:dev\": \"vuepress dev docs\",\n    \"vuepress:build\": \"vuepress build docs --dest dist\""}1' ~/vuepress-demo/package.json.bak > ~/vuepress-demo/package.json
# npm run vuepress:dev
cd ~/vuepress-demo/docs
mkdir .vuepress && cd .vuepress
echo "

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
                title: 'Sidebar1- Hướng dẫn', //Phần này sẽ được hiện thị ở sidebar
                collapsable: false, //buộc bên trong luôn trích dẫn 
                children: [
                    '/dir/content1', // sẽ gọi ra file content1.md ở thư mục web, tương tự với các content bên dưới
                    '/dir/content2',
                    '/dir/content3',
                    '/dir/content4'
                ]
            },
            {
                //initialOpenGroupIndex: -1,  //Xác định index của nhóm con được mở ban đầu
                title: 'Liên hệ',
                path: '/dir/contact'        
            },
            {
                title: 'Hỗ trợ',
                path: '/dir/support'
            }
        ]
    }
}


" > config.js

cd ~ && cd vuepress && mkdir dir1 && cd dir1
git clone https://github.com/huydv398/Note-Vuepress
cd Note-Vuepress/ && mv dir/ ~/vuepress-demo/docs/

cd ~/vuepress-demo


echo "
[Unit]
Description= env vuepress
After=network.target

[Service]
PermissionsStartOnly=True
User=root
Group=root
WorkingDirectory=/root/vuepress-demo/
ExecStart=/usr/bin/yarn run vuepress:dev
Restart=on-failure
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/vuepress.service

virtualenv env -p python3.6
source env/bin/activate
systemctl daemon-reload
systemctl start vuepress
systemctl enable vuepress
systemctl status vuepress

Echo "Hoàn tất cài đặt Vuepress trên môi trường Linux" && sleep5
}