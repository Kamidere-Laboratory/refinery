FROM rust:1 AS builder
WORKDIR app

COPY . .
RUN cargo build -p refinery_cli --release --all-features


FROM debian:bullseye-slim AS runtime
COPY --from=builder /app/target/release/refinery /usr/local/bin

ENTRYPOINT ["/usr/local/bin/refinery"]

FROM busybox:glibc as debug

COPY --from=runtime /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libdl.so.2 /lib/
COPY --from=runtime /usr/local/bin/refinery /usr/local/bin/

FROM scratch as squash

COPY --from=debug / / 

ENTRYPOINT [ "/usr/local/bin/refinery" ]