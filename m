Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:36068 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbeEOFfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 01:35:39 -0400
MIME-Version: 1.0
In-Reply-To: <1c8efa5dca5a8b97b81946b38044f826d12b8f50.1526331777.git.sean@mess.org>
References: <cover.1526331777.git.sean@mess.org> <1c8efa5dca5a8b97b81946b38044f826d12b8f50.1526331777.git.sean@mess.org>
From: Y Song <ys114321@gmail.com>
Date: Mon, 14 May 2018 22:34:57 -0700
Message-ID: <CAH3MdRXGnRFcPKhkjgSXNwGUBL-KbCTqOq3tVx6kLNY7d=FOig@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] samples/bpf: an example of a raw IR decoder
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 14, 2018 at 2:11 PM, Sean Young <sean@mess.org> wrote:
> This implements the grundig-16 IR protocol.
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  samples/bpf/Makefile                      |   4 +
>  samples/bpf/bpf_load.c                    |   9 +-
>  samples/bpf/grundig_decoder_kern.c        | 112 ++++++++++++++++++++++
>  samples/bpf/grundig_decoder_user.c        |  54 +++++++++++
>  tools/bpf/bpftool/prog.c                  |   1 +
>  tools/include/uapi/linux/bpf.h            |  17 +++-
>  tools/testing/selftests/bpf/bpf_helpers.h |   6 ++
>  7 files changed, 200 insertions(+), 3 deletions(-)
>  create mode 100644 samples/bpf/grundig_decoder_kern.c
>  create mode 100644 samples/bpf/grundig_decoder_user.c
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 4d6a6edd4bf6..c6fa111f103a 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -44,6 +44,7 @@ hostprogs-y += xdp_monitor
>  hostprogs-y += xdp_rxq_info
>  hostprogs-y += syscall_tp
>  hostprogs-y += cpustat
> +hostprogs-y += grundig_decoder
>
>  # Libbpf dependencies
>  LIBBPF := ../../tools/lib/bpf/bpf.o ../../tools/lib/bpf/nlattr.o
> @@ -95,6 +96,7 @@ xdp_monitor-objs := bpf_load.o $(LIBBPF) xdp_monitor_user.o
>  xdp_rxq_info-objs := bpf_load.o $(LIBBPF) xdp_rxq_info_user.o
>  syscall_tp-objs := bpf_load.o $(LIBBPF) syscall_tp_user.o
>  cpustat-objs := bpf_load.o $(LIBBPF) cpustat_user.o
> +grundig_decoder-objs := bpf_load.o $(LIBBPF) grundig_decoder_user.o
>
>  # Tell kbuild to always build the programs
>  always := $(hostprogs-y)
> @@ -148,6 +150,7 @@ always += xdp_rxq_info_kern.o
>  always += xdp2skb_meta_kern.o
>  always += syscall_tp_kern.o
>  always += cpustat_kern.o
> +always += grundig_decoder_kern.o
>
>  HOSTCFLAGS += -I$(objtree)/usr/include
>  HOSTCFLAGS += -I$(srctree)/tools/lib/
> @@ -193,6 +196,7 @@ HOSTLOADLIBES_xdp_monitor += -lelf
>  HOSTLOADLIBES_xdp_rxq_info += -lelf
>  HOSTLOADLIBES_syscall_tp += -lelf
>  HOSTLOADLIBES_cpustat += -lelf
> +HOSTLOADLIBES_grundig_decoder += -lelf
>
>  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
>  #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
> index bebe4188b4b3..0fd389e95bb9 100644
> --- a/samples/bpf/bpf_load.c
> +++ b/samples/bpf/bpf_load.c
> @@ -69,6 +69,7 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
>         bool is_sockops = strncmp(event, "sockops", 7) == 0;
>         bool is_sk_skb = strncmp(event, "sk_skb", 6) == 0;
>         bool is_sk_msg = strncmp(event, "sk_msg", 6) == 0;
> +       bool is_ir_decoder = strncmp(event, "ir_decoder", 10) == 0;
>         size_t insns_cnt = size / sizeof(struct bpf_insn);
>         enum bpf_prog_type prog_type;
>         char buf[256];
> @@ -102,6 +103,8 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
>                 prog_type = BPF_PROG_TYPE_SK_SKB;
>         } else if (is_sk_msg) {
>                 prog_type = BPF_PROG_TYPE_SK_MSG;
> +       } else if (is_ir_decoder) {
> +               prog_type = BPF_PROG_TYPE_RAWIR_DECODER;
>         } else {
>                 printf("Unknown event '%s'\n", event);
>                 return -1;
> @@ -116,7 +119,8 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
>
>         prog_fd[prog_cnt++] = fd;
>
> -       if (is_xdp || is_perf_event || is_cgroup_skb || is_cgroup_sk)
> +       if (is_xdp || is_perf_event || is_cgroup_skb || is_cgroup_sk ||
> +           is_ir_decoder)
>                 return 0;
>
>         if (is_socket || is_sockops || is_sk_skb || is_sk_msg) {
> @@ -607,7 +611,8 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
>                     memcmp(shname, "cgroup/", 7) == 0 ||
>                     memcmp(shname, "sockops", 7) == 0 ||
>                     memcmp(shname, "sk_skb", 6) == 0 ||
> -                   memcmp(shname, "sk_msg", 6) == 0) {
> +                   memcmp(shname, "sk_msg", 6) == 0 ||
> +                   memcmp(shname, "ir_decoder", 10) == 0) {
>                         ret = load_and_attach(shname, data->d_buf,
>                                               data->d_size);
>                         if (ret != 0)
> diff --git a/samples/bpf/grundig_decoder_kern.c b/samples/bpf/grundig_decoder_kern.c
> new file mode 100644
> index 000000000000..c80f2c9cc69a
> --- /dev/null
> +++ b/samples/bpf/grundig_decoder_kern.c
> @@ -0,0 +1,112 @@
> +
> +#include <uapi/linux/bpf.h>
> +#include <uapi/linux/bpf_rcdev.h>
> +#include "bpf_helpers.h"
> +#include <linux/version.h>
> +
> +enum grundig_state {
> +       STATE_INACTIVE,
> +       STATE_HEADER_SPACE,
> +       STATE_LEADING_PULSE,
> +       STATE_BITS_SPACE,
> +       STATE_BITS_PULSE,
> +};
> +
> +struct decoder_state {
> +       u32 bits;
> +       enum grundig_state state;
> +       u32 count;
> +       u32 last_space;
> +};
> +
> +struct bpf_map_def SEC("maps") decoder_state_map = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(u32),
> +       .value_size = sizeof(struct decoder_state),
> +       .max_entries = 1,
> +};
> +
> +#define US_TO_NS(t) 1000*(t)
> +static inline bool eq_margin(unsigned d1, unsigned d2, unsigned margin)
> +{
> +       return ((d1 > (d2 - margin)) && (d1 < (d2 + margin)));
> +}
> +
> +SEC("ir_decoder/grundig_decoder")
> +int bpf_decoder(struct ir_raw_event *raw)
> +{
> +       u32 key = 0;
> +       struct decoder_state init = {};
> +
> +       struct decoder_state *s = bpf_map_lookup_elem(&decoder_state_map, &key);
> +
> +       if (!s)
> +               s = &init;
> +
> +       if (raw->carrier_report) {
> +               // ignore
> +       } else if (raw->reset) {
> +               s->state = STATE_INACTIVE;
> +       } else if (s->state == STATE_INACTIVE) {
> +               if (raw->pulse && eq_margin(US_TO_NS(900), raw->duration, US_TO_NS(100))) {
> +                       s->bits = 0;
> +                       s->state = STATE_HEADER_SPACE;
> +                       s->count = 0;
> +               }
> +       } else if (s->state == STATE_HEADER_SPACE) {
> +               if (!raw->pulse && eq_margin(US_TO_NS(2900), raw->duration, US_TO_NS(200)))
> +                       s->state = STATE_LEADING_PULSE;
> +               else
> +                       s->state = STATE_INACTIVE;
> +       } else if (s->state == STATE_LEADING_PULSE) {
> +               if (raw->pulse && eq_margin(US_TO_NS(1300), raw->duration, US_TO_NS(100)))
> +                       s->state = STATE_BITS_SPACE;
> +               else
> +                       s->state = STATE_INACTIVE;
> +       } else if (s->state == STATE_BITS_SPACE) {
> +               s->last_space = raw->duration;
> +               s->state = STATE_BITS_PULSE;
> +       } else if (s->state == STATE_BITS_PULSE) {
> +               int t = -1;
> +               if (eq_margin(s->last_space, US_TO_NS(472), US_TO_NS(150)) &&
> +                   eq_margin(raw->duration, US_TO_NS(583), US_TO_NS(150)))
> +                       t = 0;
> +               if (eq_margin(s->last_space, US_TO_NS(1139), US_TO_NS(150)) &&
> +                   eq_margin(raw->duration, US_TO_NS(583), US_TO_NS(150)))
> +                       t = 1;
> +               if (eq_margin(s->last_space, US_TO_NS(1806), US_TO_NS(150)) &&
> +                   eq_margin(raw->duration, US_TO_NS(583), US_TO_NS(150)))
> +                       t = 2;
> +               if (eq_margin(s->last_space, US_TO_NS(2200), US_TO_NS(150)) &&
> +                   eq_margin(raw->duration, US_TO_NS(1139), US_TO_NS(150)))
> +                       t = 3;
> +               if (t < 0) {
> +                       s->state = STATE_INACTIVE;
> +               } else {
> +                       s->bits <<= 2;
> +                       switch (t) {
> +                       case 3: s->bits |= 0; break;
> +                       case 2: s->bits |= 3; break;
> +                       case 1: s->bits |= 2; break;
> +                       case 0: s->bits |= 1; break;
> +                       }
> +                       s->count += 2;
> +                       if (s->count == 16) {
> +                               bpf_rc_keydown(raw, 0x40, s->bits, 0);
> +                               s->state = STATE_INACTIVE;
> +                       } else {
> +                               s->state = STATE_BITS_SPACE;
> +                       }
> +               }
> +       }
> +
> +       if (s == &init)
> +               bpf_map_update_elem(&decoder_state_map, &key, s, BPF_NOEXIST);
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> +
> +u32 _version SEC("version") = LINUX_VERSION_CODE;
> +
> diff --git a/samples/bpf/grundig_decoder_user.c b/samples/bpf/grundig_decoder_user.c
> new file mode 100644
> index 000000000000..61e8ee5f73ee
> --- /dev/null
> +++ b/samples/bpf/grundig_decoder_user.c
> @@ -0,0 +1,54 @@
> +
> +#include <linux/bpf.h>
> +#include <assert.h>
> +#include <errno.h>
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <libgen.h>
> +#include <sys/resource.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +
> +#include "bpf_load.h"
> +#include "bpf_util.h"
> +#include "libbpf.h"
> +
> +int main(int argc, char **argv)
> +{
> +       char filename[256];
> +       int ret, lircfd;
> +
> +       if (argc != 2) {
> +               printf("Usage: %s /dev/lircN\n", argv[0]);

Looks like the test requires /dev/lircN device. Is there any easy way
to test it?

Also, looks like the program does not depend on any kernel headers,
maybe it can be
moved to tools/testing/selftests/bpf/? There are testbot to run those
tests regularly.

> +               return 2;
> +       }
> +
> +       snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> +
> +       if (load_bpf_file(filename)) {
> +               printf("%s", bpf_log_buf);
> +               return 1;
> +       }
> +
> +       lircfd = open(argv[1], O_RDWR);
> +       if (lircfd == -1) {
> +               printf("failed to open lirc device %s: %m\n", argv[1]);
> +               return 1;
> +       }
> +
> +       ret = bpf_prog_attach(prog_fd[0], lircfd, BPF_RAWIR_DECODER, 0);
> +       if (ret) {
> +               printf("Failed to attach bpf to lirc device: %m\n");
> +               return 1;
> +       }
> +
> +       printf("Grundig IR decoder loaded and attached. Hit any key to stop\n");
> +       getchar();
> +
> +       return 0;
> +}
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index f7a810897eac..ae1c26df212d 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -68,6 +68,7 @@ static const char * const prog_type_name[] = {
>         [BPF_PROG_TYPE_SOCK_OPS]        = "sock_ops",
>         [BPF_PROG_TYPE_SK_SKB]          = "sk_skb",
>         [BPF_PROG_TYPE_CGROUP_DEVICE]   = "cgroup_device",
> +       [BPF_PROG_TYPE_RAWIR_DECODER]   = "ir_decoder",
>  };
>
>  static void print_boot_time(__u64 nsecs, char *buf, unsigned int size)
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index c5ec89732a8d..d9740599adf6 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -137,6 +137,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_SK_MSG,
>         BPF_PROG_TYPE_RAW_TRACEPOINT,
>         BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
> +       BPF_PROG_TYPE_RAWIR_DECODER,
>  };
>
>  enum bpf_attach_type {
> @@ -154,6 +155,7 @@ enum bpf_attach_type {
>         BPF_CGROUP_INET6_CONNECT,
>         BPF_CGROUP_INET4_POST_BIND,
>         BPF_CGROUP_INET6_POST_BIND,
> +       BPF_RAWIR_DECODER,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -755,6 +757,17 @@ union bpf_attr {
>   *     @addr: pointer to struct sockaddr to bind socket to
>   *     @addr_len: length of sockaddr structure
>   *     Return: 0 on success or negative error code
> + *
> + * int bpf_rc_keydown(ctx, protocol, scancode, toggle)
> + *     Report decoded scancode with toggle value
> + *     @ctx: pointer to ctx
> + *     @protocol: decoded protocol
> + *     @scancode: decoded scancode
> + *     @toggle: set to 1 if button was toggled, else 0
> + *
> + * int bpf_rc_repeat(ctx)
> + *     Repeat the last decoded scancode
> + *     @ctx: pointer to ctx
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -821,7 +834,9 @@ union bpf_attr {
>         FN(msg_apply_bytes),            \
>         FN(msg_cork_bytes),             \
>         FN(msg_pull_data),              \
> -       FN(bind),
> +       FN(bind),                       \
> +       FN(rc_repeat),                  \
> +       FN(rc_keydown),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index d8223d99f96d..4bf23d3dfc33 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -96,6 +96,12 @@ static int (*bpf_msg_pull_data)(void *ctx, int start, int end, int flags) =
>         (void *) BPF_FUNC_msg_pull_data;
>  static int (*bpf_bind)(void *ctx, void *addr, int addr_len) =
>         (void *) BPF_FUNC_bind;
> +static int (*bpf_rc_repeat)(void *ctx) =
> +       (void *) BPF_FUNC_rc_repeat;
> +static int (*bpf_rc_keydown)(void *ctx, unsigned protocol, unsigned scancode,
> +                            unsigned toggle) =
> +       (void *) BPF_FUNC_rc_keydown;
> +
>
>  /* llvm builtin functions that eBPF C program may use to
>   * emit BPF_LD_ABS and BPF_LD_IND instructions
> --
> 2.17.0
>
