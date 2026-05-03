FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf # not needed because you are overriding it with COPY
COPY nginx/nginx.conf /etc/nginx/nginx.conf # theoretically, this is not required either  because you are suppose to override this with mount in docker compose
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
