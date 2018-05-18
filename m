Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46193 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752214AbeEROHf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:07:35 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH v4 3/3] bpf: add selftest for lirc_mode2 type program
Date: Fri, 18 May 2018 15:07:30 +0100
Message-Id: <7e961c6fcea8130e8cb69849cd64077fed6e835a.1526651592.git.sean@mess.org>
In-Reply-To: <cover.1526651592.git.sean@mess.org>
References: <cover.1526651592.git.sean@mess.org>
In-Reply-To: <cover.1526651592.git.sean@mess.org>
References: <cover.1526651592.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is simple test over rc-loopback.

Signed-off-by: Sean Young <sean@mess.org>
---
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |  53 ++++-
 tools/include/uapi/linux/lirc.h               | 217 ++++++++++++++++++
 tools/lib/bpf/libbpf.c                        |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   6 +
 .../testing/selftests/bpf/test_lirc_mode2.sh  |  28 +++
 .../selftests/bpf/test_lirc_mode2_kern.c      |  23 ++
 .../selftests/bpf/test_lirc_mode2_user.c      | 154 +++++++++++++
 9 files changed, 487 insertions(+), 4 deletions(-)
 create mode 100644 tools/include/uapi/linux/lirc.h
 create mode 100755 tools/testing/selftests/bpf/test_lirc_mode2.sh
 create mode 100644 tools/testing/selftests/bpf/test_lirc_mode2_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_lirc_mode2_user.c

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9bdfdf2d3fbe..07f1ace39a46 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -71,6 +71,7 @@ static const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_SK_MSG]		= "sk_msg",
 	[BPF_PROG_TYPE_RAW_TRACEPOINT]	= "raw_tracepoint",
 	[BPF_PROG_TYPE_CGROUP_SOCK_ADDR] = "cgroup_sock_addr",
+	[BPF_PROG_TYPE_LIRC_MODE2]	= "lirc_mode2",
 };
 
 static void print_boot_time(__u64 nsecs, char *buf, unsigned int size)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d94d333a8225..8227832b713e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -141,6 +141,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SK_MSG,
 	BPF_PROG_TYPE_RAW_TRACEPOINT,
 	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	BPF_PROG_TYPE_LIRC_MODE2,
 };
 
 enum bpf_attach_type {
@@ -158,6 +159,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_CONNECT,
 	BPF_CGROUP_INET4_POST_BIND,
 	BPF_CGROUP_INET6_POST_BIND,
+	BPF_LIRC_MODE2,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1902,6 +1904,53 @@ union bpf_attr {
  *		egress otherwise). This is the only flag supported for now.
  *	Return
  *		**SK_PASS** on success, or **SK_DROP** on error.
+ *
+ * int bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded key press with *scancode*,
+ *		*toggle* value in the given *protocol*. The scancode will be
+ *		translated to a keycode using the rc keymap, and reported as
+ *		an input key down event. After a period a key up event is
+ *		generated. This period can be extended by calling either
+ *		**bpf_rc_keydown** () with the same values, or calling
+ *		**bpf_rc_repeat** ().
+ *
+ *		Some protocols include a toggle bit, in case the button
+ *		was released and pressed again between consecutive scancodes
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
+ *
+ *		The *protocol* is the decoded protocol number (see
+ *		**enum rc_proto** for some predefined values).
+ *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
+ *
+ *	Return
+ *		0
+ *
+ * int bpf_rc_repeat(void *ctx)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded repeat key message. This delays
+ *		the generation of a key up event for previously generated
+ *		key down event.
+ *
+ *		Some IR protocols like NEC have a special IR message for
+ *		repeating last button, for when a button is held down.
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
+ *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
+ *
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -1976,7 +2025,9 @@ union bpf_attr {
 	FN(fib_lookup),			\
 	FN(sock_hash_update),		\
 	FN(msg_redirect_hash),		\
-	FN(sk_redirect_hash),
+	FN(sk_redirect_hash),		\
+	FN(rc_repeat),			\
+	FN(rc_keydown),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/include/uapi/linux/lirc.h b/tools/include/uapi/linux/lirc.h
new file mode 100644
index 000000000000..f189931042a7
--- /dev/null
+++ b/tools/include/uapi/linux/lirc.h
@@ -0,0 +1,217 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * lirc.h - linux infrared remote control header file
+ * last modified 2010/07/13 by Jarod Wilson
+ */
+
+#ifndef _LINUX_LIRC_H
+#define _LINUX_LIRC_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define PULSE_BIT       0x01000000
+#define PULSE_MASK      0x00FFFFFF
+
+#define LIRC_MODE2_SPACE     0x00000000
+#define LIRC_MODE2_PULSE     0x01000000
+#define LIRC_MODE2_FREQUENCY 0x02000000
+#define LIRC_MODE2_TIMEOUT   0x03000000
+
+#define LIRC_VALUE_MASK      0x00FFFFFF
+#define LIRC_MODE2_MASK      0xFF000000
+
+#define LIRC_SPACE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_SPACE)
+#define LIRC_PULSE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_PULSE)
+#define LIRC_FREQUENCY(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_FREQUENCY)
+#define LIRC_TIMEOUT(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_TIMEOUT)
+
+#define LIRC_VALUE(val) ((val)&LIRC_VALUE_MASK)
+#define LIRC_MODE2(val) ((val)&LIRC_MODE2_MASK)
+
+#define LIRC_IS_SPACE(val) (LIRC_MODE2(val) == LIRC_MODE2_SPACE)
+#define LIRC_IS_PULSE(val) (LIRC_MODE2(val) == LIRC_MODE2_PULSE)
+#define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
+#define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
+
+/* used heavily by lirc userspace */
+#define lirc_t int
+
+/*** lirc compatible hardware features ***/
+
+#define LIRC_MODE2SEND(x) (x)
+#define LIRC_SEND2MODE(x) (x)
+#define LIRC_MODE2REC(x) ((x) << 16)
+#define LIRC_REC2MODE(x) ((x) >> 16)
+
+#define LIRC_MODE_RAW                  0x00000001
+#define LIRC_MODE_PULSE                0x00000002
+#define LIRC_MODE_MODE2                0x00000004
+#define LIRC_MODE_SCANCODE             0x00000008
+#define LIRC_MODE_LIRCCODE             0x00000010
+
+
+#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
+#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
+#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_SEND_MASK             0x0000003f
+
+#define LIRC_CAN_SET_SEND_CARRIER      0x00000100
+#define LIRC_CAN_SET_SEND_DUTY_CYCLE   0x00000200
+#define LIRC_CAN_SET_TRANSMITTER_MASK  0x00000400
+
+#define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
+#define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
+#define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
+#define LIRC_CAN_REC_SCANCODE          LIRC_MODE2REC(LIRC_MODE_SCANCODE)
+#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
+
+#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
+#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
+
+#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
+#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
+#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
+#define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
+#define LIRC_CAN_SET_REC_FILTER           0x08000000
+
+#define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_USE_WIDEBAND_RECEIVER    0x04000000
+
+#define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
+#define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
+
+#define LIRC_CAN_NOTIFY_DECODE            0x01000000
+
+/*** IOCTL commands for lirc driver ***/
+
+#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
+
+#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
+#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
+#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
+
+#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
+#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
+
+/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
+#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
+
+#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
+#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
+/* Note: these can reset the according pulse_width */
+#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
+#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
+#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
+#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
+
+/*
+ * when a timeout != 0 is set the driver will send a
+ * LIRC_MODE2_TIMEOUT data packet, otherwise LIRC_MODE2_TIMEOUT is
+ * never sent, timeout is disabled by default
+ */
+#define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
+
+/* 1 enables, 0 disables timeout reports in MODE2 */
+#define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
+
+/*
+ * if enabled from the next key press on the driver will send
+ * LIRC_MODE2_FREQUENCY packets
+ */
+#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
+
+/*
+ * to set a range use LIRC_SET_REC_CARRIER_RANGE with the
+ * lower bound first and later LIRC_SET_REC_CARRIER with the upper bound
+ */
+#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
+
+#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
+
+/*
+ * struct lirc_scancode - decoded scancode with protocol for use with
+ *	LIRC_MODE_SCANCODE
+ *
+ * @timestamp: Timestamp in nanoseconds using CLOCK_MONOTONIC when IR
+ *	was decoded.
+ * @flags: should be 0 for transmit. When receiving scancodes,
+ *	LIRC_SCANCODE_FLAG_TOGGLE or LIRC_SCANCODE_FLAG_REPEAT can be set
+ *	depending on the protocol
+ * @rc_proto: see enum rc_proto
+ * @keycode: the translated keycode. Set to 0 for transmit.
+ * @scancode: the scancode received or to be sent
+ */
+struct lirc_scancode {
+	__u64	timestamp;
+	__u16	flags;
+	__u16	rc_proto;
+	__u32	keycode;
+	__u64	scancode;
+};
+
+/* Set if the toggle bit of rc-5 or rc-6 is enabled */
+#define LIRC_SCANCODE_FLAG_TOGGLE	1
+/* Set if this is a nec or sanyo repeat */
+#define LIRC_SCANCODE_FLAG_REPEAT	2
+
+/**
+ * enum rc_proto - the Remote Controller protocol
+ *
+ * @RC_PROTO_UNKNOWN: Protocol not known
+ * @RC_PROTO_OTHER: Protocol known but proprietary
+ * @RC_PROTO_RC5: Philips RC5 protocol
+ * @RC_PROTO_RC5X_20: Philips RC5x 20 bit protocol
+ * @RC_PROTO_RC5_SZ: StreamZap variant of RC5
+ * @RC_PROTO_JVC: JVC protocol
+ * @RC_PROTO_SONY12: Sony 12 bit protocol
+ * @RC_PROTO_SONY15: Sony 15 bit protocol
+ * @RC_PROTO_SONY20: Sony 20 bit protocol
+ * @RC_PROTO_NEC: NEC protocol
+ * @RC_PROTO_NECX: Extended NEC protocol
+ * @RC_PROTO_NEC32: NEC 32 bit protocol
+ * @RC_PROTO_SANYO: Sanyo protocol
+ * @RC_PROTO_MCIR2_KBD: RC6-ish MCE keyboard
+ * @RC_PROTO_MCIR2_MSE: RC6-ish MCE mouse
+ * @RC_PROTO_RC6_0: Philips RC6-0-16 protocol
+ * @RC_PROTO_RC6_6A_20: Philips RC6-6A-20 protocol
+ * @RC_PROTO_RC6_6A_24: Philips RC6-6A-24 protocol
+ * @RC_PROTO_RC6_6A_32: Philips RC6-6A-32 protocol
+ * @RC_PROTO_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
+ * @RC_PROTO_SHARP: Sharp protocol
+ * @RC_PROTO_XMP: XMP protocol
+ * @RC_PROTO_CEC: CEC protocol
+ * @RC_PROTO_IMON: iMon Pad protocol
+ */
+enum rc_proto {
+	RC_PROTO_UNKNOWN	= 0,
+	RC_PROTO_OTHER		= 1,
+	RC_PROTO_RC5		= 2,
+	RC_PROTO_RC5X_20	= 3,
+	RC_PROTO_RC5_SZ		= 4,
+	RC_PROTO_JVC		= 5,
+	RC_PROTO_SONY12		= 6,
+	RC_PROTO_SONY15		= 7,
+	RC_PROTO_SONY20		= 8,
+	RC_PROTO_NEC		= 9,
+	RC_PROTO_NECX		= 10,
+	RC_PROTO_NEC32		= 11,
+	RC_PROTO_SANYO		= 12,
+	RC_PROTO_MCIR2_KBD	= 13,
+	RC_PROTO_MCIR2_MSE	= 14,
+	RC_PROTO_RC6_0		= 15,
+	RC_PROTO_RC6_6A_20	= 16,
+	RC_PROTO_RC6_6A_24	= 17,
+	RC_PROTO_RC6_6A_32	= 18,
+	RC_PROTO_RC6_MCE	= 19,
+	RC_PROTO_SHARP		= 20,
+	RC_PROTO_XMP		= 21,
+	RC_PROTO_CEC		= 22,
+	RC_PROTO_IMON		= 23,
+};
+
+#endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3dbe217bf23e..01e514479f6b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1461,6 +1461,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_SK_MSG:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+	case BPF_PROG_TYPE_LIRC_MODE2:
 		return false;
 	case BPF_PROG_TYPE_UNSPEC:
 	case BPF_PROG_TYPE_KPROBE:
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1eb0fa2aba92..ee6d49f18be5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -24,7 +24,7 @@ urandom_read: urandom_read.c
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
-	test_sock test_btf test_sockmap
+	test_sock test_btf test_sockmap test_lirc_mode2_user
 
 TEST_GEN_FILES = test_pkt_access.o test_xdp.o test_l4lb.o test_tcp_estats.o test_obj_id.o \
 	test_pkt_md_access.o test_xdp_redirect.o test_xdp_meta.o sockmap_parse_prog.o     \
@@ -33,7 +33,8 @@ TEST_GEN_FILES = test_pkt_access.o test_xdp.o test_l4lb.o test_tcp_estats.o test
 	sample_map_ret0.o test_tcpbpf_kern.o test_stacktrace_build_id.o \
 	sockmap_tcp_msg_prog.o connect4_prog.o connect6_prog.o test_adjust_tail.o \
 	test_btf_haskv.o test_btf_nokv.o test_sockmap_kern.o test_tunnel_kern.o \
-	test_get_stack_rawtp.o test_sockmap_kern.o test_sockhash_kern.o
+	test_get_stack_rawtp.o test_sockmap_kern.o test_sockhash_kern.o \
+	test_lirc_mode2_kern.o
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
@@ -42,7 +43,8 @@ TEST_PROGS := test_kmod.sh \
 	test_xdp_meta.sh \
 	test_offload.py \
 	test_sock_addr.sh \
-	test_tunnel.sh
+	test_tunnel.sh \
+	test_lirc_mode2.sh
 
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 8f143dfb3700..a6864827ed34 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -114,6 +114,12 @@ static int (*bpf_get_stack)(void *ctx, void *buf, int size, int flags) =
 static int (*bpf_fib_lookup)(void *ctx, struct bpf_fib_lookup *params,
 			     int plen, __u32 flags) =
 	(void *) BPF_FUNC_fib_lookup;
+static int (*bpf_rc_repeat)(void *ctx) =
+	(void *) BPF_FUNC_rc_repeat;
+static int (*bpf_rc_keydown)(void *ctx, unsigned int protocol,
+			     unsigned long long scancode, unsigned int toggle) =
+	(void *) BPF_FUNC_rc_keydown;
+
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/test_lirc_mode2.sh b/tools/testing/selftests/bpf/test_lirc_mode2.sh
new file mode 100755
index 000000000000..ce2e15e4f976
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_lirc_mode2.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
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
+	TYPE=lirc_mode2
+	./test_lirc_mode2_user $LIRCDEV
+	ret=$?
+	if [ $ret -ne 0 ]; then
+		echo -e ${RED}"FAIL: $TYPE"${NC}
+	else
+		echo -e ${GREEN}"PASS: $TYPE"${NC}
+	fi
+fi
diff --git a/tools/testing/selftests/bpf/test_lirc_mode2_kern.c b/tools/testing/selftests/bpf/test_lirc_mode2_kern.c
new file mode 100644
index 000000000000..ba26855563a5
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_kern.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+// test ir decoder
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/bpf.h>
+#include <linux/lirc.h>
+#include "bpf_helpers.h"
+
+SEC("lirc_mode2")
+int bpf_decoder(unsigned int *sample)
+{
+	if (LIRC_IS_PULSE(*sample)) {
+		unsigned int duration = LIRC_VALUE(*sample);
+
+		if (duration & 0x10000)
+			bpf_rc_keydown(sample, 0x40, duration & 0xffff, 0);
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_lirc_mode2_user.c b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
new file mode 100644
index 000000000000..bd77688c8277
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+// test ir decoder
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+// A lirc chardev is a device representing a consumer IR (cir) device which
+// can receive infrared signals from remote control (and/or transmit IR)
+//
+// IR is sent as a series of pulses and space somewhat like morse code. The
+// BPF program can decode this into scancodes so that rc-core can translate
+// this into input key codes using the rc keymap
+//
+// This test works by sending IR over rc-loopback, so the IR is processed by
+// BPF and then decoded into scancodes. The/ lirc chardev must be the one
+// associated with rc-loopback, see the output of ir-keytable(1)".
+//
+// The following CONFIG options must be enabled for the test to succeed:
+// CONFIG_RC_CORE=y
+// CONFIG_BPF_RAWIR_EVENT=y
+// CONFIG_RC_LOOPBACK=y
+
+// Steps:
+// 1. Open the /dev/lircN device for rc-loopback (given on command line)
+// 2. Attach bpf_lirc_mode2 program which decodes some IR.
+// 3. Send some IR to the same IR device; since it is loopback, this will
+//    end up in the bpf program
+// 4. bpf program should decode IR and report keycode
+// 5. We can read keycode from same /dev/lirc device
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
+	ret = bpf_prog_load("test_lirc_mode2_kern.o",
+			    BPF_PROG_TYPE_LIRC_MODE2, &obj, &progfd);
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
+	ret = bpf_prog_detach2(progfd, lircfd, BPF_LIRC_MODE2);
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
+	ret = bpf_prog_query(lircfd, BPF_LIRC_MODE2, 0, prog_flags, prog_ids,
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
+	ret = bpf_prog_attach(progfd, lircfd, BPF_LIRC_MODE2, 0);
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
+	ret = bpf_prog_query(lircfd, BPF_LIRC_MODE2, 0, prog_flags, prog_ids,
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
+	ret = bpf_prog_detach2(progfd, lircfd, BPF_LIRC_MODE2);
+	if (ret) {
+		printf("bpf_prog_detach2: returned %m\n");
+		return 1;
+	}
+
+	return 0;
+}
-- 
2.17.0
