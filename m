Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59695 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbeEPVEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 17:04:45 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>
Subject: [PATCH v3 2/2] bpf: add selftest for rawir_event type program
Date: Wed, 16 May 2018 22:04:41 +0100
Message-Id: <78945f2bf82e9f16695f72bed3930d1302d38e29.1526504511.git.sean@mess.org>
In-Reply-To: <cover.1526504511.git.sean@mess.org>
References: <cover.1526504511.git.sean@mess.org>
In-Reply-To: <cover.1526504511.git.sean@mess.org>
References: <cover.1526504511.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is simple test over rc-loopback.

Signed-off-by: Sean Young <sean@mess.org>
---
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |  57 +++++++-
 tools/lib/bpf/libbpf.c                        |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   6 +
 tools/testing/selftests/bpf/test_rawir.sh     |  37 +++++
 .../selftests/bpf/test_rawir_event_kern.c     |  26 ++++
 .../selftests/bpf/test_rawir_event_user.c     | 130 ++++++++++++++++++
 8 files changed, 261 insertions(+), 5 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_rawir.sh
 create mode 100644 tools/testing/selftests/bpf/test_rawir_event_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_rawir_event_user.c

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9bdfdf2d3fbe..8889a4ee8577 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -71,6 +71,7 @@ static const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_SK_MSG]		= "sk_msg",
 	[BPF_PROG_TYPE_RAW_TRACEPOINT]	= "raw_tracepoint",
 	[BPF_PROG_TYPE_CGROUP_SOCK_ADDR] = "cgroup_sock_addr",
+	[BPF_PROG_TYPE_RAWIR_EVENT]	= "rawir_event",
 };
 
 static void print_boot_time(__u64 nsecs, char *buf, unsigned int size)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1205d86a7a29..243e141e8a5b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -141,6 +141,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_RAW_TRACEPOINT,
 	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	BPF_PROG_TYPE_RAWIR_EVENT,
 };
 
 enum bpf_attach_type {
@@ -158,6 +159,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_CONNECT,
 	BPF_CGROUP_INET4_POST_BIND,
 	BPF_CGROUP_INET6_POST_BIND,
+	BPF_RAWIR_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1829,7 +1831,6 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- *
  * int bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int plen, u32 flags)
  *	Description
  *		Do FIB lookup in kernel tables using parameters in *params*.
@@ -1856,6 +1857,7 @@ union bpf_attr {
  *             Egress device index on success, 0 if packet needs to continue
  *             up the stack for further processing or a negative error in case
  *             of failure.
+ *
  * int bpf_sock_hash_update(struct bpf_sock_ops_kern *skops, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
@@ -1902,6 +1904,35 @@ union bpf_attr {
  *		egress otherwise). This is the only flag supported for now.
  *	Return
  *		**SK_PASS** on success, or **SK_DROP** on error.
+ *
+ * int bpf_rc_keydown(void *ctx, u32 protocol, u32 scancode, u32 toggle)
+ *	Description
+ *		Report decoded scancode with toggle value. For use in
+ *		BPF_PROG_TYPE_RAWIR_EVENT, to report a successfully
+ *		decoded scancode. This is will generate a keydown event,
+ *		and a keyup event once the scancode is no longer repeated.
+ *
+ *		*ctx* pointer to bpf_rawir_event, *protocol* is decoded
+ *		protocol (see RC_PROTO_* enum).
+ *
+ *		Some protocols include a toggle bit, in case the button
+ *		was released and pressed again between consecutive scancodes,
+ *		copy this bit into *toggle* if it exists, else set to 0.
+ *
+ *     Return
+ *		Always return 0 (for now)
+ *
+ * int bpf_rc_repeat(void *ctx)
+ *	Description
+ *		Repeat the last decoded scancode; some IR protocols like
+ *		NEC have a special IR message for repeat last button,
+ *		in case user is holding a button down; the scancode is
+ *		not repeated.
+ *
+ *		*ctx* pointer to bpf_rawir_event.
+ *
+ *     Return
+ *		Always return 0 (for now)
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -1976,7 +2007,9 @@ union bpf_attr {
 	FN(fib_lookup),			\
 	FN(sock_hash_update),		\
 	FN(msg_redirect_hash),		\
-	FN(sk_redirect_hash),
+	FN(sk_redirect_hash),		\
+	FN(rc_repeat),			\
+	FN(rc_keydown),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -2043,6 +2076,26 @@ enum bpf_hdr_start_off {
 	BPF_HDR_START_NET,
 };
 
+/*
+ * user accessible mirror of in-kernel ir_raw_event
+ */
+#define BPF_RAWIR_EVENT_SPACE		0
+#define BPF_RAWIR_EVENT_PULSE		1
+#define BPF_RAWIR_EVENT_TIMEOUT		2
+#define BPF_RAWIR_EVENT_RESET		3
+#define BPF_RAWIR_EVENT_CARRIER		4
+#define BPF_RAWIR_EVENT_DUTY_CYCLE	5
+
+struct bpf_rawir_event {
+	union {
+		__u32	duration;
+		__u32	carrier;
+		__u32	duty_cycle;
+	};
+
+	__u32	type;
+};
+
 /* user accessible mirror of in-kernel sk_buff.
  * new fields can only be added to the end of this structure
  */
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index df54c4c9e48a..372269e9053d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1455,6 +1455,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_SK_MSG:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+	case BPF_PROG_TYPE_RAWIR_EVENT:
 		return false;
 	case BPF_PROG_TYPE_UNSPEC:
 	case BPF_PROG_TYPE_KPROBE:
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1eb0fa2aba92..b84e36d05d34 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -24,7 +24,7 @@ urandom_read: urandom_read.c
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
-	test_sock test_btf test_sockmap
+	test_sock test_btf test_sockmap test_rawir_event_user
 
 TEST_GEN_FILES = test_pkt_access.o test_xdp.o test_l4lb.o test_tcp_estats.o test_obj_id.o \
 	test_pkt_md_access.o test_xdp_redirect.o test_xdp_meta.o sockmap_parse_prog.o     \
@@ -33,7 +33,8 @@ TEST_GEN_FILES = test_pkt_access.o test_xdp.o test_l4lb.o test_tcp_estats.o test
 	sample_map_ret0.o test_tcpbpf_kern.o test_stacktrace_build_id.o \
 	sockmap_tcp_msg_prog.o connect4_prog.o connect6_prog.o test_adjust_tail.o \
 	test_btf_haskv.o test_btf_nokv.o test_sockmap_kern.o test_tunnel_kern.o \
-	test_get_stack_rawtp.o test_sockmap_kern.o test_sockhash_kern.o
+	test_get_stack_rawtp.o test_sockmap_kern.o test_sockhash_kern.o \
+	test_rawir_event_kern.o
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
@@ -42,7 +43,8 @@ TEST_PROGS := test_kmod.sh \
 	test_xdp_meta.sh \
 	test_offload.py \
 	test_sock_addr.sh \
-	test_tunnel.sh
+	test_tunnel.sh \
+	test_rawir.sh
 
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 8f143dfb3700..26d89b7f9841 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -114,6 +114,12 @@ static int (*bpf_get_stack)(void *ctx, void *buf, int size, int flags) =
 static int (*bpf_fib_lookup)(void *ctx, struct bpf_fib_lookup *params,
 			     int plen, __u32 flags) =
 	(void *) BPF_FUNC_fib_lookup;
+static int (*bpf_rc_repeat)(void *ctx) =
+	(void *) BPF_FUNC_rc_repeat;
+static int (*bpf_rc_keydown)(void *ctx, unsigned int protocol,
+			     unsigned int scancode, unsigned int toggle) =
+	(void *) BPF_FUNC_rc_keydown;
+
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/test_rawir.sh b/tools/testing/selftests/bpf/test_rawir.sh
new file mode 100755
index 000000000000..0aa77b043ee1
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_rawir.sh
@@ -0,0 +1,37 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test bpf_rawir_event over rc-loopback. Steps for the test:
+#
+# 1. Find the /dev/lircN device for rc-loopback
+# 2. Attach bpf_rawir_event program which decodes some IR.
+# 3. Send some IR to the same IR device; since it is loopback, this will
+#    end up in the bpf program
+# 4. bpf program should decode IR and report keycode
+# 5. We can read keycode from same /dev/lirc device
+
+GREEN='\033[0;92m'
+RED='\033[0;31m'
+NC='\033[0m' # No Color
+
+modprobe rc-loopback
+
+for i in /sys/class/rc/rc*
+do
+	if grep -q DRV_NAME=rc-loopback $i/uevent
+	then
+		LIRCDEV=$(grep DEVNAME= $i/lirc*/uevent | sed sQDEVNAME=Q/dev/Q)
+	fi
+done
+
+if [ -n $LIRCDEV ];
+then
+	TYPE=rawir_event
+	./test_rawir_event_user $LIRCDEV
+	ret=$?
+	if [ $ret -ne 0 ]; then
+		echo -e ${RED}"FAIL: $TYPE"${NC}
+	else
+		echo -e ${GREEN}"PASS: $TYPE"${NC}
+	fi
+fi
diff --git a/tools/testing/selftests/bpf/test_rawir_event_kern.c b/tools/testing/selftests/bpf/test_rawir_event_kern.c
new file mode 100644
index 000000000000..33ba5d30af62
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_rawir_event_kern.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+// test ir decoder
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+SEC("rawir_event")
+int bpf_decoder(struct bpf_rawir_event *e)
+{
+	if (e->type == BPF_RAWIR_EVENT_PULSE) {
+		/*
+		 * The lirc interface is microseconds, but here we receive
+		 * nanoseconds.
+		 */
+		int microseconds = e->duration / 1000;
+
+		if (microseconds & 0x10000)
+			bpf_rc_keydown(e, 0x40, microseconds & 0xffff, 0);
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_rawir_event_user.c b/tools/testing/selftests/bpf/test_rawir_event_user.c
new file mode 100644
index 000000000000..c3d7f2c68033
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_rawir_event_user.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+// test ir decoder
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/bpf.h>
+#include <linux/lirc.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <poll.h>
+#include <libgen.h>
+#include <sys/resource.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+int main(int argc, char **argv)
+{
+	struct bpf_object *obj;
+	int ret, lircfd, progfd, mode;
+	int testir = 0x1dead;
+	u32 prog_ids[10], prog_flags[10], prog_cnt;
+
+	if (argc != 2) {
+		printf("Usage: %s /dev/lircN\n", argv[0]);
+		return 2;
+	}
+
+	ret = bpf_prog_load("test_rawir_event_kern.o",
+			    BPF_PROG_TYPE_RAWIR_EVENT, &obj, &progfd);
+	if (ret) {
+		printf("Failed to load bpf program\n");
+		return 1;
+	}
+
+	lircfd = open(argv[1], O_RDWR | O_NONBLOCK);
+	if (lircfd == -1) {
+		printf("failed to open lirc device %s: %m\n", argv[1]);
+		return 1;
+	}
+
+	/* Let's try detach it before it was ever attached */
+	ret = bpf_prog_detach2(progfd, lircfd, BPF_RAWIR_EVENT);
+	if (ret != -1 || errno != ENOENT) {
+		printf("bpf_prog_detach2 not attached should fail: %m\n");
+		return 1;
+	}
+
+	mode = LIRC_MODE_SCANCODE;
+	if (ioctl(lircfd, LIRC_SET_REC_MODE, &mode)) {
+		printf("failed to set rec mode: %m\n");
+		return 1;
+	}
+
+	prog_cnt = 10;
+	ret = bpf_prog_query(lircfd, BPF_RAWIR_EVENT, 0, prog_flags, prog_ids,
+			     &prog_cnt);
+	if (ret) {
+		printf("Failed to query bpf programs on lirc device: %m\n");
+		return 1;
+	}
+
+	if (prog_cnt != 0) {
+		printf("Expected nothing to be attached\n");
+		return 1;
+	}
+
+	ret = bpf_prog_attach(progfd, lircfd, BPF_RAWIR_EVENT, 0);
+	if (ret) {
+		printf("Failed to attach bpf to lirc device: %m\n");
+		return 1;
+	}
+
+	/* Write raw IR */
+	ret = write(lircfd, &testir, sizeof(testir));
+	if (ret != sizeof(testir)) {
+		printf("Failed to send test IR message: %m\n");
+		return 1;
+	}
+
+	struct pollfd pfd = { .fd = lircfd, .events = POLLIN };
+	struct lirc_scancode lsc;
+
+	poll(&pfd, 1, 100);
+
+	/* Read decoded IR */
+	ret = read(lircfd, &lsc, sizeof(lsc));
+	if (ret != sizeof(lsc)) {
+		printf("Failed to read decoded IR: %m\n");
+		return 1;
+	}
+
+	if (lsc.scancode != 0xdead || lsc.rc_proto != 64) {
+		printf("Incorrect scancode decoded\n");
+		return 1;
+	}
+
+	prog_cnt = 10;
+	ret = bpf_prog_query(lircfd, BPF_RAWIR_EVENT, 0, prog_flags, prog_ids,
+			     &prog_cnt);
+	if (ret) {
+		printf("Failed to query bpf programs on lirc device: %m\n");
+		return 1;
+	}
+
+	if (prog_cnt != 1) {
+		printf("Expected one program to be attached\n");
+		return 1;
+	}
+
+	/* Let's try detaching it now it is actually attached */
+	ret = bpf_prog_detach2(progfd, lircfd, BPF_RAWIR_EVENT);
+	if (ret) {
+		printf("bpf_prog_detach2: returned %m\n");
+		return 1;
+	}
+
+	return 0;
+}
-- 
2.17.0
