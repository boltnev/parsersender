#!/usr/bin/env awk
#
# log_format  main  '$remote_addr|$time_local|$msec|$request|'
#                   'st=$status|$body_bytes_sent|$http_referer|'
#                   '$http_user_agent|host=$scheme://$http_host|'
#                   'rt=$upstream_response_time|utime=$sent_http_x_request_clock|urt=$sent_http_x_request_time|'
#                   'rtt=$request_time|xcst=$sent_http_x_cache|'
#                   'cst=$upstream_cache_status|ust=$upstream_status|'
#                   'usaddr=$upstream_addr|gzr=$gzip_ratio|'
#                   'geo=$geoip_city_country_code:$geoip_region_name|fwd=$turbo_proxy:$http_x_forwarded_for';
#
#
BEGIN{FS="|"}
NF==20{
    # преобразуем дату к упорядоченому виду, чтобы можно было потом сравнивать
    # имена файлов
    datetime = substr($2, 1, 19)
    gsub(/\:|\//, "_", datetime)
    sub("Jan", "01",  datetime)
    sub("Feb", "02",  datetime)
    sub("Mar", "03",  datetime)
    sub("Apr", "04",  datetime)
    sub("May", "05",  datetime)
    sub("Jun", "06",  datetime)
    sub("Jul", "07",  datetime)
    sub("Aug", "08",  datetime)
    sub("Sep", "09",  datetime)
    sub("Oct", "10",  datetime)
    sub("Nov", "11",  datetime)
    sub("Dec", "12",  datetime)
    year = substr(datetime, 7, 4)
    month = substr(datetime, 4, 2)
    day = substr(datetime, 1, 2)
    minute = substr(datetime, 11)
    new_outfile = prefix "_" year "_" month "_" day "_" minute ".log"
    if(outfile == "") outfile = new_outfile

    if(new_outfile > outfile){
        close(outfile)
        print(outfile)
        outfile = new_outfile
    }
    urlfield = $4
    # GET url HTTP1.1
    method = substr(urlfield, 1, index(urlfield, " ")-1)
    http = substr(urlfield, length(urlfield)-7)
    url = substr(urlfield, length(method)+2, length(urlfield)-length(method)-length(http)-2)
    printf("%s|%s |%s|%s|%s|%s|\"%s\"|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n",
           year "-" month "-" day,                   # date|
           year "-" month "-" day " " substr($2, 11, 7),                   # datetime|
           $1,                   # remote_addr|
           $3,                   # timestamp|
           method,               # method|
           http,                 # http_version|
           url,                  # url|
           substr($5, 4),        # status|
           $6,                   # body_bytes_sent|
           $7,                   # referer|
           $8,                   # user_agent|
           substr($9, 6),        # host|
           substr($10, 4),       # rt|
           substr($13, 5),       # rtt|
           substr($16, 5),       # ust|
           substr($17, 8),       # usaddr|
           substr($19, 5, 2),    # geo country
           substr($19, 8)) >> outfile  # geo region
}
