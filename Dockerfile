from alpine

run apk add --no-cache gcc libc-dev make curl linux-headers pcre-dev openssl-dev \
 && cd /tmp \
 && curl -sL http://nginx.org/download/nginx-1.11.1.tar.gz | tar zx \
 && cd /tmp/nginx* \
 && ./configure \
     --with-cc-opt="-static -static-libgcc" --with-ld-opt="-static" --prefix=/var/lib/nginx \
     --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx/nginx.pid \
     --lock-path=/run/nginx/nginx.lock --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
     --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
     --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
     --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
     --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
     --user=nginx --group=nginx --with-ipv6 --with-file-aio --with-pcre-jit \
     --with-http_stub_status_module --with-http_gzip_static_module --with-http_v2_module \
     --with-http_auth_request_module --with-http_sub_module \
 && make -j8 \
 && make install \
 && cd / \
 && apk del gcc libc-dev make curl linux-headers pcre-dev openssl-dev \
 && rm -rf /tmp/* /var/cache/apk/*

run addgroup -S nginx \
 && adduser -g nginx -S -D nginx \
 && mkdir -p /var/lib/nginx/tmp \
 && install -d -o nginx -g nginx /var/lib/nginx/tmp/client_body

add nginx.conf /etc/nginx/nginx.conf

add demo /var/lib/nginx/html/traefik/demo.sh
add cloud-config.yml /var/lib/nginx/html/traefik/cloud-config.yml
add Dockerfile /var/lib/nginx/html/traefik/Dockerfile
add nginx.conf /var/lib/nginx/html/traefik/nginx.conf
add entrypoint /var/lib/nginx/html/traefik/entrypoint

entrypoint ["nginx"]
add entrypoint /usr/local/bin/nginx
