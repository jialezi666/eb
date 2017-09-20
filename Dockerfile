FROM debian:7.11

WORKDIR /root
ADD run.sh /root
RUN chmod +x /root/run.sh
CMD ["/root/run.sh"]
