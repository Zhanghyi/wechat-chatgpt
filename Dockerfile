FROM python:3
WORKDIR /app
ARG POETRY_VERSION=1.2.2
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/cache/apk/* && \
    pip3 install --no-cache-dir poetry && \
    rm -rf ~/.cache/
COPY package*.json ./
COPY pyproject.toml ./
COPY poetry.lock ./
# Install dependencies
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN mkdir ~/.pip && echo '[global]\n index-url = https://pypi.tuna.tsinghua.edu.cn/simple\n[install]\n trusted-host = pypi.tuna.tsinghua.edu.cn' >> ~/.pip/pip.conf && \
    poetry install && npm config set registry https://registry.npm.taobao.org/ && npm install && rm -rf ~/.npm/
COPY . .
CMD ["npm", "run", "dev"]
