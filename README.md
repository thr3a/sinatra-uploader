# sinatra-uploader

## 概要
[Sinatraを使って画像アップローダーを作る](http://thr3a.hatenablog.com/entry/20150622/1434948383)のサンプル

## 実行例
```
git clone https://github.com/thr3a/sinatra-uploader.git
cd sinatra-uploader
bundle
bundle exec rake db:migrate
bundle exec rackup -o 0.0.0.0 -p 9393
```