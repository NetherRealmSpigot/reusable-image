FROM ghcr.io/netherrealmspigot/postgres-nanoid:16-alpine-nightly

RUN apk --no-cache add bash
RUN bash <<EOS
set -ex

apk --no-cache add git make gcc musl-dev postgresql16-dev clang19 llvm19
git clone https://github.com/pgEdge/snowflake.git
cd snowflake
USE_PGXS=1 make
USE_PGXS=1 make install
cd ..
apk del git make gcc musl-dev postgresql16-dev clang19 llvm19
rm -rf snowflake

EOS