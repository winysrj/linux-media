Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40075 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729787AbeGMOpH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 10:45:07 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        VDR User <user.vdr@gmail.com>
Subject: [PATCH v3 2/5] keytable: add bpf protocols
Date: Fri, 13 Jul 2018 15:30:08 +0100
Message-Id: <780750fd4953d0ce17c4baa826d475a127283610.1531491416.git.sean@mess.org>
In-Reply-To: <cover.1531491415.git.sean@mess.org>
References: <cover.1531491415.git.sean@mess.org>
In-Reply-To: <cover.1531491415.git.sean@mess.org>
References: <cover.1531491415.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a few BPF protocols and infrastructure for building them.

Signed-off-by: Sean Young <sean@mess.org>
---
 configure.ac                                  |   4 +
 utils/keytable/Makefile.am                    |   4 +
 utils/keytable/bpf_protocols/Makefile.am      |  21 ++
 utils/keytable/bpf_protocols/bpf_helpers.h    | 315 ++++++++++++++++++
 utils/keytable/bpf_protocols/grundig.c        | 126 +++++++
 utils/keytable/bpf_protocols/manchester.c     | 167 ++++++++++
 utils/keytable/bpf_protocols/pulse_distance.c | 156 +++++++++
 utils/keytable/bpf_protocols/pulse_length.c   | 152 +++++++++
 utils/keytable/bpf_protocols/rc_mm.c          | 139 ++++++++
 v4l-utils.spec.in                             |   2 +-
 10 files changed, 1085 insertions(+), 1 deletion(-)
 create mode 100644 utils/keytable/bpf_protocols/Makefile.am
 create mode 100644 utils/keytable/bpf_protocols/bpf_helpers.h
 create mode 100644 utils/keytable/bpf_protocols/grundig.c
 create mode 100644 utils/keytable/bpf_protocols/manchester.c
 create mode 100644 utils/keytable/bpf_protocols/pulse_distance.c
 create mode 100644 utils/keytable/bpf_protocols/pulse_length.c
 create mode 100644 utils/keytable/bpf_protocols/rc_mm.c

diff --git a/configure.ac b/configure.ac
index 08f5a4c5..10f8628b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,6 +23,7 @@ AC_CONFIG_FILES([Makefile
 	utils/libmedia_dev/Makefile
 	utils/dvb/Makefile
 	utils/keytable/Makefile
+	utils/keytable/bpf_protocols/Makefile
 	utils/ir-ctl/Makefile
 	utils/cx18-ctl/Makefile
 	utils/ivtv-ctl/Makefile
@@ -172,11 +173,14 @@ AC_SUBST([LIBELF_CFLAGS])
 AC_SUBST([LIBELF_LIBS])
 AM_CONDITIONAL([HAVE_LIBELF], [test x$libelf_pkgconfig = xyes])
 if test "x$libelf_pkgconfig" = "xyes"; then
+  AC_CHECK_PROG([CLANG], clang, clang)
   AC_DEFINE([HAVE_LIBELF], [1], [libelf library is present])
 else
   AC_MSG_WARN(libelf library not available)
 fi
 
+AM_CONDITIONAL([BPF_PROTOCOLS], [test x$CLANG = xclang])
+
 AS_IF([test "x$x11_pkgconfig" = xyes],
       [PKG_CHECK_MODULES(GL, [gl], [gl_pkgconfig=yes], [gl_pkgconfig=no])], [gl_pkgconfig=no])
 AC_SUBST([GL_CFLAGS])
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index ad251915..b500e2f2 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -13,6 +13,10 @@ endif
 ir_keytable_LDADD = @LIBINTL@
 ir_keytable_LDFLAGS = $(ARGP_LIBS) $(LIBELF_LIBS)
 
+if BPF_PROTOCOLS
+SUBDIRS = bpf_protocols
+endif
+
 EXTRA_DIST = 70-infrared.rules rc_keymaps rc_keymaps_userspace gen_keytables.pl ir-keytable.1 rc_maps.cfg
 
 # custom target
diff --git a/utils/keytable/bpf_protocols/Makefile.am b/utils/keytable/bpf_protocols/Makefile.am
new file mode 100644
index 00000000..5e4b3d67
--- /dev/null
+++ b/utils/keytable/bpf_protocols/Makefile.am
@@ -0,0 +1,21 @@
+# Get Clang's default includes on this system, as opposed to those seen by
+# '-target bpf'. This fixes "missing" files on some architectures/distros,
+# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
+#
+# Use '-idirafter': Don't interfere with include mechanics except where the
+# build would have failed anyways.
+CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
+        | sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
+
+%.o: %.c
+	$(CLANG) $(CLANG_SYS_INCLUDES) -I$(top_srcdir)/include -target bpf -O2 -c $<
+
+PROTOCOLS = grundig.o pulse_distance.o pulse_length.o rc_mm.o manchester.o
+
+all: $(PROTOCOLS)
+
+# custom target
+install-data-local:
+	$(install_sh) -d "$(DESTDIR)$(keytableuserdir)/protocols"
+	$(install_sh) -d "$(DESTDIR)$(keytablesystemdir)/protocols"
+	$(install_sh) $(PROTOCOLS) "$(DESTDIR)$(keytablesystemdir)/protocols"
diff --git a/utils/keytable/bpf_protocols/bpf_helpers.h b/utils/keytable/bpf_protocols/bpf_helpers.h
new file mode 100644
index 00000000..8c1b8a23
--- /dev/null
+++ b/utils/keytable/bpf_protocols/bpf_helpers.h
@@ -0,0 +1,315 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BPF_HELPERS_H
+#define __BPF_HELPERS_H
+
+/* helper macro to place programs, maps, license in
+ * different sections in elf_bpf file. Section names
+ * are interpreted by elf_bpf loader
+ */
+#define SEC(NAME) __attribute__((section(NAME), used))
+
+/* helper functions called from eBPF programs written in C */
+static void *(*bpf_map_lookup_elem)(void *map, void *key) =
+(void *) BPF_FUNC_map_lookup_elem;
+static int (*bpf_map_update_elem)(void *map, void *key, void *value,
+		unsigned long long flags) =
+(void *) BPF_FUNC_map_update_elem;
+static int (*bpf_map_delete_elem)(void *map, void *key) =
+(void *) BPF_FUNC_map_delete_elem;
+static int (*bpf_probe_read)(void *dst, int size, void *unsafe_ptr) =
+(void *) BPF_FUNC_probe_read;
+static unsigned long long (*bpf_ktime_get_ns)(void) =
+(void *) BPF_FUNC_ktime_get_ns;
+static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
+(void *) BPF_FUNC_trace_printk;
+static void (*bpf_tail_call)(void *ctx, void *map, int index) =
+(void *) BPF_FUNC_tail_call;
+static unsigned long long (*bpf_get_smp_processor_id)(void) =
+(void *) BPF_FUNC_get_smp_processor_id;
+static unsigned long long (*bpf_get_current_pid_tgid)(void) =
+(void *) BPF_FUNC_get_current_pid_tgid;
+static unsigned long long (*bpf_get_current_uid_gid)(void) =
+(void *) BPF_FUNC_get_current_uid_gid;
+static int (*bpf_get_current_comm)(void *buf, int buf_size) =
+(void *) BPF_FUNC_get_current_comm;
+static unsigned long long (*bpf_perf_event_read)(void *map,
+		unsigned long long flags) =
+(void *) BPF_FUNC_perf_event_read;
+static int (*bpf_clone_redirect)(void *ctx, int ifindex, int flags) =
+(void *) BPF_FUNC_clone_redirect;
+static int (*bpf_redirect)(int ifindex, int flags) =
+(void *) BPF_FUNC_redirect;
+static int (*bpf_redirect_map)(void *map, int key, int flags) =
+(void *) BPF_FUNC_redirect_map;
+static int (*bpf_perf_event_output)(void *ctx, void *map,
+		unsigned long long flags, void *data,
+		int size) =
+(void *) BPF_FUNC_perf_event_output;
+static int (*bpf_get_stackid)(void *ctx, void *map, int flags) =
+(void *) BPF_FUNC_get_stackid;
+static int (*bpf_probe_write_user)(void *dst, void *src, int size) =
+(void *) BPF_FUNC_probe_write_user;
+static int (*bpf_current_task_under_cgroup)(void *map, int index) =
+(void *) BPF_FUNC_current_task_under_cgroup;
+static int (*bpf_skb_get_tunnel_key)(void *ctx, void *key, int size, int flags) =
+(void *) BPF_FUNC_skb_get_tunnel_key;
+static int (*bpf_skb_set_tunnel_key)(void *ctx, void *key, int size, int flags) =
+(void *) BPF_FUNC_skb_set_tunnel_key;
+static int (*bpf_skb_get_tunnel_opt)(void *ctx, void *md, int size) =
+(void *) BPF_FUNC_skb_get_tunnel_opt;
+static int (*bpf_skb_set_tunnel_opt)(void *ctx, void *md, int size) =
+(void *) BPF_FUNC_skb_set_tunnel_opt;
+static unsigned long long (*bpf_get_prandom_u32)(void) =
+(void *) BPF_FUNC_get_prandom_u32;
+static int (*bpf_xdp_adjust_head)(void *ctx, int offset) =
+(void *) BPF_FUNC_xdp_adjust_head;
+static int (*bpf_xdp_adjust_meta)(void *ctx, int offset) =
+(void *) BPF_FUNC_xdp_adjust_meta;
+static int (*bpf_setsockopt)(void *ctx, int level, int optname, void *optval,
+		int optlen) =
+(void *) BPF_FUNC_setsockopt;
+static int (*bpf_getsockopt)(void *ctx, int level, int optname, void *optval,
+		int optlen) =
+(void *) BPF_FUNC_getsockopt;
+static int (*bpf_sock_ops_cb_flags_set)(void *ctx, int flags) =
+(void *) BPF_FUNC_sock_ops_cb_flags_set;
+static int (*bpf_sk_redirect_map)(void *ctx, void *map, int key, int flags) =
+(void *) BPF_FUNC_sk_redirect_map;
+static int (*bpf_sk_redirect_hash)(void *ctx, void *map, void *key, int flags) =
+(void *) BPF_FUNC_sk_redirect_hash;
+static int (*bpf_sock_map_update)(void *map, void *key, void *value,
+		unsigned long long flags) =
+(void *) BPF_FUNC_sock_map_update;
+static int (*bpf_sock_hash_update)(void *map, void *key, void *value,
+		unsigned long long flags) =
+(void *) BPF_FUNC_sock_hash_update;
+static int (*bpf_perf_event_read_value)(void *map, unsigned long long flags,
+		void *buf, unsigned int buf_size) =
+(void *) BPF_FUNC_perf_event_read_value;
+static int (*bpf_perf_prog_read_value)(void *ctx, void *buf,
+		unsigned int buf_size) =
+(void *) BPF_FUNC_perf_prog_read_value;
+static int (*bpf_override_return)(void *ctx, unsigned long rc) =
+(void *) BPF_FUNC_override_return;
+static int (*bpf_msg_redirect_map)(void *ctx, void *map, int key, int flags) =
+(void *) BPF_FUNC_msg_redirect_map;
+static int (*bpf_msg_redirect_hash)(void *ctx,
+		void *map, void *key, int flags) =
+(void *) BPF_FUNC_msg_redirect_hash;
+static int (*bpf_msg_apply_bytes)(void *ctx, int len) =
+(void *) BPF_FUNC_msg_apply_bytes;
+static int (*bpf_msg_cork_bytes)(void *ctx, int len) =
+(void *) BPF_FUNC_msg_cork_bytes;
+static int (*bpf_msg_pull_data)(void *ctx, int start, int end, int flags) =
+(void *) BPF_FUNC_msg_pull_data;
+static int (*bpf_bind)(void *ctx, void *addr, int addr_len) =
+(void *) BPF_FUNC_bind;
+static int (*bpf_xdp_adjust_tail)(void *ctx, int offset) =
+(void *) BPF_FUNC_xdp_adjust_tail;
+static int (*bpf_skb_get_xfrm_state)(void *ctx, int index, void *state,
+		int size, int flags) =
+(void *) BPF_FUNC_skb_get_xfrm_state;
+static int (*bpf_get_stack)(void *ctx, void *buf, int size, int flags) =
+(void *) BPF_FUNC_get_stack;
+static int (*bpf_fib_lookup)(void *ctx, struct bpf_fib_lookup *params,
+		int plen, __u32 flags) =
+(void *) BPF_FUNC_fib_lookup;
+static int (*bpf_lwt_push_encap)(void *ctx, unsigned int type, void *hdr,
+		unsigned int len) =
+(void *) BPF_FUNC_lwt_push_encap;
+static int (*bpf_lwt_seg6_store_bytes)(void *ctx, unsigned int offset,
+		void *from, unsigned int len) =
+(void *) BPF_FUNC_lwt_seg6_store_bytes;
+static int (*bpf_lwt_seg6_action)(void *ctx, unsigned int action, void *param,
+		unsigned int param_len) =
+(void *) BPF_FUNC_lwt_seg6_action;
+static int (*bpf_lwt_seg6_adjust_srh)(void *ctx, unsigned int offset,
+		unsigned int len) =
+(void *) BPF_FUNC_lwt_seg6_adjust_srh;
+static int (*bpf_rc_repeat)(void *ctx) =
+(void *) BPF_FUNC_rc_repeat;
+static int (*bpf_rc_keydown)(void *ctx, unsigned int protocol,
+		unsigned long long scancode, unsigned int toggle) =
+(void *) BPF_FUNC_rc_keydown;
+static unsigned long long (*bpf_get_current_cgroup_id)(void) =
+(void *) BPF_FUNC_get_current_cgroup_id;
+
+/* llvm builtin functions that eBPF C program may use to
+ * emit BPF_LD_ABS and BPF_LD_IND instructions
+ */
+struct sk_buff;
+unsigned long long load_byte(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.byte");
+unsigned long long load_half(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.half");
+unsigned long long load_word(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.word");
+
+/* a helper structure used by eBPF C program
+ * to describe map attributes to elf_bpf loader
+ */
+struct bpf_map_def {
+	unsigned int type;
+	unsigned int key_size;
+	unsigned int value_size;
+	unsigned int max_entries;
+	unsigned int map_flags;
+	unsigned int inner_map_idx;
+	unsigned int numa_node;
+};
+
+static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
+	(void *) BPF_FUNC_skb_load_bytes;
+static int (*bpf_skb_store_bytes)(void *ctx, int off, void *from, int len, int flags) =
+	(void *) BPF_FUNC_skb_store_bytes;
+static int (*bpf_l3_csum_replace)(void *ctx, int off, int from, int to, int flags) =
+	(void *) BPF_FUNC_l3_csum_replace;
+static int (*bpf_l4_csum_replace)(void *ctx, int off, int from, int to, int flags) =
+	(void *) BPF_FUNC_l4_csum_replace;
+static int (*bpf_csum_diff)(void *from, int from_size, void *to, int to_size, int seed) =
+	(void *) BPF_FUNC_csum_diff;
+static int (*bpf_skb_under_cgroup)(void *ctx, void *map, int index) =
+	(void *) BPF_FUNC_skb_under_cgroup;
+static int (*bpf_skb_change_head)(void *, int len, int flags) =
+	(void *) BPF_FUNC_skb_change_head;
+static int (*bpf_skb_pull_data)(void *, int len) =
+	(void *) BPF_FUNC_skb_pull_data;
+
+/* Scan the ARCH passed in from ARCH env variable (see Makefile) */
+#if defined(__TARGET_ARCH_x86)
+	#define bpf_target_x86
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_s930x)
+	#define bpf_target_s930x
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_arm64)
+	#define bpf_target_arm64
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_mips)
+	#define bpf_target_mips
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_powerpc)
+	#define bpf_target_powerpc
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_sparc)
+	#define bpf_target_sparc
+	#define bpf_target_defined
+#else
+	#undef bpf_target_defined
+#endif
+
+/* Fall back to what the compiler says */
+#ifndef bpf_target_defined
+#if defined(__x86_64__)
+	#define bpf_target_x86
+#elif defined(__s390x__)
+	#define bpf_target_s930x
+#elif defined(__aarch64__)
+	#define bpf_target_arm64
+#elif defined(__mips__)
+	#define bpf_target_mips
+#elif defined(__powerpc__)
+	#define bpf_target_powerpc
+#elif defined(__sparc__)
+	#define bpf_target_sparc
+#endif
+#endif
+
+#if defined(bpf_target_x86)
+
+#define PT_REGS_PARM1(x) ((x)->di)
+#define PT_REGS_PARM2(x) ((x)->si)
+#define PT_REGS_PARM3(x) ((x)->dx)
+#define PT_REGS_PARM4(x) ((x)->cx)
+#define PT_REGS_PARM5(x) ((x)->r8)
+#define PT_REGS_RET(x) ((x)->sp)
+#define PT_REGS_FP(x) ((x)->bp)
+#define PT_REGS_RC(x) ((x)->ax)
+#define PT_REGS_SP(x) ((x)->sp)
+#define PT_REGS_IP(x) ((x)->ip)
+
+#elif defined(bpf_target_s390x)
+
+#define PT_REGS_PARM1(x) ((x)->gprs[2])
+#define PT_REGS_PARM2(x) ((x)->gprs[3])
+#define PT_REGS_PARM3(x) ((x)->gprs[4])
+#define PT_REGS_PARM4(x) ((x)->gprs[5])
+#define PT_REGS_PARM5(x) ((x)->gprs[6])
+#define PT_REGS_RET(x) ((x)->gprs[14])
+#define PT_REGS_FP(x) ((x)->gprs[11]) /* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_RC(x) ((x)->gprs[2])
+#define PT_REGS_SP(x) ((x)->gprs[15])
+#define PT_REGS_IP(x) ((x)->psw.addr)
+
+#elif defined(bpf_target_arm64)
+
+#define PT_REGS_PARM1(x) ((x)->regs[0])
+#define PT_REGS_PARM2(x) ((x)->regs[1])
+#define PT_REGS_PARM3(x) ((x)->regs[2])
+#define PT_REGS_PARM4(x) ((x)->regs[3])
+#define PT_REGS_PARM5(x) ((x)->regs[4])
+#define PT_REGS_RET(x) ((x)->regs[30])
+#define PT_REGS_FP(x) ((x)->regs[29]) /* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_RC(x) ((x)->regs[0])
+#define PT_REGS_SP(x) ((x)->sp)
+#define PT_REGS_IP(x) ((x)->pc)
+
+#elif defined(bpf_target_mips)
+
+#define PT_REGS_PARM1(x) ((x)->regs[4])
+#define PT_REGS_PARM2(x) ((x)->regs[5])
+#define PT_REGS_PARM3(x) ((x)->regs[6])
+#define PT_REGS_PARM4(x) ((x)->regs[7])
+#define PT_REGS_PARM5(x) ((x)->regs[8])
+#define PT_REGS_RET(x) ((x)->regs[31])
+#define PT_REGS_FP(x) ((x)->regs[30]) /* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_RC(x) ((x)->regs[1])
+#define PT_REGS_SP(x) ((x)->regs[29])
+#define PT_REGS_IP(x) ((x)->cp0_epc)
+
+#elif defined(bpf_target_powerpc)
+
+#define PT_REGS_PARM1(x) ((x)->gpr[3])
+#define PT_REGS_PARM2(x) ((x)->gpr[4])
+#define PT_REGS_PARM3(x) ((x)->gpr[5])
+#define PT_REGS_PARM4(x) ((x)->gpr[6])
+#define PT_REGS_PARM5(x) ((x)->gpr[7])
+#define PT_REGS_RC(x) ((x)->gpr[3])
+#define PT_REGS_SP(x) ((x)->sp)
+#define PT_REGS_IP(x) ((x)->nip)
+
+#elif defined(bpf_target_sparc)
+
+#define PT_REGS_PARM1(x) ((x)->u_regs[UREG_I0])
+#define PT_REGS_PARM2(x) ((x)->u_regs[UREG_I1])
+#define PT_REGS_PARM3(x) ((x)->u_regs[UREG_I2])
+#define PT_REGS_PARM4(x) ((x)->u_regs[UREG_I3])
+#define PT_REGS_PARM5(x) ((x)->u_regs[UREG_I4])
+#define PT_REGS_RET(x) ((x)->u_regs[UREG_I7])
+#define PT_REGS_RC(x) ((x)->u_regs[UREG_I0])
+#define PT_REGS_SP(x) ((x)->u_regs[UREG_FP])
+
+/* Should this also be a bpf_target check for the sparc case? */
+#if defined(__arch64__)
+#define PT_REGS_IP(x) ((x)->tpc)
+#else
+#define PT_REGS_IP(x) ((x)->pc)
+#endif
+
+#endif
+
+#ifdef bpf_target_powerpc
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = (ctx)->link; })
+#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
+#elif bpf_target_sparc
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = PT_REGS_RET(ctx); })
+#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
+#else
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({				\
+		bpf_probe_read(&(ip), sizeof(ip), (void *)PT_REGS_RET(ctx)); })
+#define BPF_KRETPROBE_READ_RET_IP(ip, ctx)	({				\
+		bpf_probe_read(&(ip), sizeof(ip),				\
+				(void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
+#endif
+
+#endif
diff --git a/utils/keytable/bpf_protocols/grundig.c b/utils/keytable/bpf_protocols/grundig.c
new file mode 100644
index 00000000..4d8cc4b9
--- /dev/null
+++ b/utils/keytable/bpf_protocols/grundig.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/lirc.h>
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+enum grundig_state {
+	STATE_INACTIVE,
+	STATE_HEADER_SPACE,
+	STATE_LEADING_PULSE,
+	STATE_BITS_SPACE,
+	STATE_BITS_PULSE,
+};
+
+struct decoder_state {
+	unsigned int bits;
+	enum grundig_state state;
+	unsigned int count;
+	unsigned int last_space;
+};
+
+struct bpf_map_def SEC("maps") decoder_state_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(unsigned int),
+	.value_size = sizeof(struct decoder_state),
+	.max_entries = 1,
+};
+
+static inline int eq_margin(unsigned d1, unsigned d2, unsigned margin)
+{
+	return ((d1 > (d2 - margin)) && (d1 < (d2 + margin)));
+}
+
+// These values can be overridden in the rc_keymap toml
+//
+// We abuse elf relocations. We cast the address of these variables to
+// an int, so that the compiler emits a mov immediate for the address
+// but uses it as an int. The bpf loader replaces the relocation with the
+// actual value (either overridden or taken from the data segment).
+int header_pulse = 900;
+int header_space = 2900;
+int leader_pulse = 1300;
+
+#define BPF_PARAM(x) (int)(&(x))
+
+SEC("grundig")
+int bpf_decoder(unsigned int *sample)
+{
+	unsigned int key = 0;
+	struct decoder_state *s = bpf_map_lookup_elem(&decoder_state_map, &key);
+
+	if (!s)
+		return 0;
+
+	switch (*sample & LIRC_MODE2_MASK) {
+	case LIRC_MODE2_SPACE:
+	case LIRC_MODE2_PULSE:
+	case LIRC_MODE2_TIMEOUT:
+		break;
+	default:
+		// not a timing events
+		return 0;
+	}
+
+	int duration = LIRC_VALUE(*sample);
+
+	if (s->state == STATE_INACTIVE) {
+		if (LIRC_IS_PULSE(*sample) && eq_margin(BPF_PARAM(header_pulse), duration, 100)) {
+			s->bits = 0;
+			s->state = STATE_HEADER_SPACE;
+			s->count = 0;
+		}
+	} else if (s->state == STATE_HEADER_SPACE) {
+		if (LIRC_IS_SPACE(*sample) && eq_margin(BPF_PARAM(header_space), duration, 200))
+			s->state = STATE_LEADING_PULSE;
+		else
+			s->state = STATE_INACTIVE;
+	} else if (s->state == STATE_LEADING_PULSE) {
+		if (LIRC_IS_PULSE(*sample) && eq_margin(BPF_PARAM(leader_pulse), duration, 100))
+			s->state = STATE_BITS_SPACE;
+		else
+			s->state = STATE_INACTIVE;
+	} else if (s->state == STATE_BITS_SPACE) {
+		s->last_space = duration;
+		s->state = STATE_BITS_PULSE;
+	} else if (s->state == STATE_BITS_PULSE) {
+		int t = -1;
+		if (eq_margin(s->last_space, (472), (150)) &&
+		    eq_margin(duration, (583), (150)))
+			t = 0;
+		if (eq_margin(s->last_space, (1139), (150)) &&
+		    eq_margin(duration, (583), (150)))
+			t = 1;
+		if (eq_margin(s->last_space, (1806), (150)) &&
+		    eq_margin(duration, (583), (150)))
+			t = 2;
+		if (eq_margin(s->last_space, (2200), (150)) &&
+		    eq_margin(duration, (1139), (150)))
+			t = 3;
+		if (t < 0) {
+			s->state = STATE_INACTIVE;
+		} else {
+			s->bits <<= 2;
+			switch (t) {
+			case 3: s->bits |= 0; break;
+			case 2: s->bits |= 3; break;
+			case 1: s->bits |= 2; break;
+			case 0: s->bits |= 1; break;
+			}
+			s->count += 2;
+			if (s->count == 16) {
+				bpf_rc_keydown(sample, 0x40, s->bits, 0);
+				s->state = STATE_INACTIVE;
+			} else {
+				s->state = STATE_BITS_SPACE;
+			}
+		}
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/utils/keytable/bpf_protocols/manchester.c b/utils/keytable/bpf_protocols/manchester.c
new file mode 100644
index 00000000..03dd88d8
--- /dev/null
+++ b/utils/keytable/bpf_protocols/manchester.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/lirc.h>
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+struct decoder_state {
+	unsigned int state;
+	unsigned int count;
+	unsigned long bits;
+};
+
+struct bpf_map_def SEC("maps") decoder_state_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(unsigned int),
+	.value_size = sizeof(struct decoder_state),
+	.max_entries = 1,
+};
+
+// These values can be overridden in the rc_keymap toml
+//
+// We abuse elf relocations. We cast the address of these variables to
+// an int, so that the compiler emits a mov immediate for the address
+// but uses it as an int. The bpf loader replaces the relocation with the
+// actual value (either overridden or taken from the data segment).
+//
+// See:
+// http://clearwater.com.au/code/rc5
+int margin = 200;
+int header_pulse = 0;
+int header_space = 0;
+int zero_pulse = 888;
+int zero_space = 888;
+int one_pulse = 888;
+int one_space = 888;
+int toggle_bit = 100;
+int bits = 14;
+int scancode_mask = 0;
+int rc_protocol = 66;
+
+#define BPF_PARAM(x) (int)(&(x))
+
+static inline int eq_margin(unsigned d1, unsigned d2)
+{
+	return ((d1 > (d2 - BPF_PARAM(margin))) && (d1 < (d2 + BPF_PARAM(margin))));
+}
+
+#define STATE_INACTIVE 0
+#define STATE_HEADER   1
+#define STATE_START1   2
+#define STATE_MID1     3
+#define STATE_MID0     4
+#define STATE_START0   5
+
+static int emitBit(unsigned int *sample, struct decoder_state *s, int bit, int state)
+{
+	s->bits <<= 1;
+	s->bits |= bit;
+	s->count++;
+
+	if (s->count == BPF_PARAM(bits)) {
+		unsigned int toggle = 0;
+		unsigned long mask = BPF_PARAM(scancode_mask);
+		if (BPF_PARAM(toggle_bit) < BPF_PARAM(bits)) {
+			unsigned int tmask = 1 << BPF_PARAM(toggle_bit);
+			if (s->bits & tmask)
+				toggle = 1;
+			mask |= tmask;
+		}
+
+		bpf_rc_keydown(sample, BPF_PARAM(rc_protocol), s->bits & ~mask,
+			       toggle);
+		state = STATE_INACTIVE;
+	}
+
+	return state;
+}
+
+SEC("manchester")
+int bpf_decoder(unsigned int *sample)
+{
+	unsigned int key = 0;
+	struct decoder_state *s = bpf_map_lookup_elem(&decoder_state_map, &key);
+	if (!s)
+		return 0;
+
+	switch (*sample & LIRC_MODE2_MASK) {
+	case LIRC_MODE2_SPACE:
+	case LIRC_MODE2_PULSE:
+	case LIRC_MODE2_TIMEOUT:
+		break;
+	default:
+		// not a timing events
+		return 0;
+	}
+
+	int duration = LIRC_VALUE(*sample);
+	int pulse = LIRC_IS_PULSE(*sample);
+
+	unsigned int newState = s->state;
+
+	switch (s->state) {
+	case STATE_INACTIVE:
+		if (BPF_PARAM(header_pulse)) {
+			if (pulse &&
+			    eq_margin(BPF_PARAM(header_pulse), duration)) {
+				s->state = STATE_HEADER;
+			}
+			break;
+		}
+		/* pass through */
+	case STATE_HEADER:
+		if (BPF_PARAM(header_space)) {
+			if (!pulse &&
+			    eq_margin(BPF_PARAM(header_space), duration)) {
+				s->state = STATE_MID1;
+			}
+			break;
+		}
+		s->bits = 0;
+		s->count = 0;
+		/* pass through */
+	case STATE_MID1:
+		if (!pulse)
+			break;
+
+		if (eq_margin(BPF_PARAM(one_pulse), duration))
+			newState = emitBit(sample, s, 1, STATE_START1);
+		else if (eq_margin(BPF_PARAM(one_pulse) +
+				   BPF_PARAM(zero_pulse), duration))
+			newState = emitBit(sample, s, 1, STATE_MID0);
+		break;
+	case STATE_MID0:
+		if (pulse)
+			break;
+
+		if (eq_margin(BPF_PARAM(zero_space), duration))
+			newState = emitBit(sample, s, 0, STATE_START0);
+		else if (eq_margin(BPF_PARAM(zero_space) +
+				   BPF_PARAM(one_space), duration))
+			newState = emitBit(sample, s, 0, STATE_MID1);
+		break;
+	case STATE_START1:
+		if (!pulse && eq_margin(BPF_PARAM(zero_space), duration))
+			newState = STATE_MID1;
+		break;
+	case STATE_START0:
+		if (pulse && eq_margin(BPF_PARAM(one_pulse), duration))
+			newState = STATE_MID0;
+		break;
+	}
+
+	//char fmt[] = "state:%d newState:%d event:%d\n";
+	//bpf_trace_printk(fmt, sizeof(fmt), s->state, newState, event);
+
+	if (newState == s->state)
+		s->state = STATE_INACTIVE;
+	else
+		s->state = newState;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/utils/keytable/bpf_protocols/pulse_distance.c b/utils/keytable/bpf_protocols/pulse_distance.c
new file mode 100644
index 00000000..9e9ea4ad
--- /dev/null
+++ b/utils/keytable/bpf_protocols/pulse_distance.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/lirc.h>
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+enum state {
+	STATE_INACTIVE,
+	STATE_HEADER_SPACE,
+	STATE_REPEAT_SPACE,
+	STATE_BITS_SPACE,
+	STATE_BITS_PULSE,
+	STATE_TRAILER,
+};
+
+struct decoder_state {
+	unsigned long bits;
+	enum state state;
+	unsigned int count;
+};
+
+struct bpf_map_def SEC("maps") decoder_state_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(unsigned int),
+	.value_size = sizeof(struct decoder_state),
+	.max_entries = 1,
+};
+
+// These values can be overridden in the rc_keymap toml
+//
+// We abuse elf relocations. We cast the address of these variables to
+// an int, so that the compiler emits a mov immediate for the address
+// but uses it as an int. The bpf loader replaces the relocation with the
+// actual value (either overridden or taken from the data segment).
+int margin = 200;
+int header_pulse = 2125;
+int header_space = 1875;
+int repeat_pulse = 0;
+int repeat_space = 0;
+int bit_pulse = 625;
+int bit_0_space = 375;
+int bit_1_space = 1625;
+int trailer_pulse = 625;
+int bits = 4;
+int reverse = 0;
+int header_optional = 0;
+int rc_protocol = 64;
+
+#define BPF_PARAM(x) (int)(&(x))
+
+static inline int eq_margin(unsigned d1, unsigned d2)
+{
+	return ((d1 > (d2 - BPF_PARAM(margin))) && (d1 < (d2 + BPF_PARAM(margin))));
+}
+
+SEC("pulse_distance")
+int bpf_decoder(unsigned int *sample)
+{
+	unsigned int key = 0;
+	struct decoder_state *s = bpf_map_lookup_elem(&decoder_state_map, &key);
+
+	if (!s)
+		return 0;
+
+	switch (*sample & LIRC_MODE2_MASK) {
+	case LIRC_MODE2_SPACE:
+	case LIRC_MODE2_PULSE:
+	case LIRC_MODE2_TIMEOUT:
+		break;
+	default:
+		// not a timing events
+		return 0;
+	}
+
+	int duration = LIRC_VALUE(*sample);
+	int pulse = LIRC_IS_PULSE(*sample);
+
+	switch (s->state) {
+	case STATE_HEADER_SPACE:
+		if (!pulse && eq_margin(BPF_PARAM(header_space), duration))
+			s->state = STATE_BITS_PULSE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_REPEAT_SPACE:
+		if (!pulse && eq_margin(BPF_PARAM(repeat_space), duration))
+			s->state = STATE_TRAILER;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_INACTIVE:
+		if (pulse && eq_margin(BPF_PARAM(header_pulse), duration)) {
+			s->bits = 0;
+			s->state = STATE_HEADER_SPACE;
+			s->count = 0;
+			break;
+		}
+		if (pulse && BPF_PARAM(repeat_pulse) > 0 &&
+		    eq_margin(BPF_PARAM(repeat_pulse), duration)) {
+			s->state = STATE_REPEAT_SPACE;
+			s->count = 0;
+			break;
+		}
+		if (!BPF_PARAM(header_optional))
+			break;
+		/* pass through */
+	case STATE_BITS_PULSE:
+		if (pulse && eq_margin(BPF_PARAM(bit_pulse), duration))
+			s->state = STATE_BITS_SPACE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_BITS_SPACE:
+		if (pulse) {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		unsigned long set_bit = 1;
+
+		if (BPF_PARAM(reverse))
+			set_bit <<= s->count;
+		else
+			s->bits <<= 1;
+
+		if (eq_margin(BPF_PARAM(bit_1_space), duration))
+			s->bits |= set_bit;
+		else if (!eq_margin(BPF_PARAM(bit_0_space), duration)) {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		s->count++;
+		if (s->count == BPF_PARAM(bits))
+			s->state = STATE_TRAILER;
+		else
+			s->state = STATE_BITS_PULSE;
+		break;
+	case STATE_TRAILER:
+		if (pulse && eq_margin(BPF_PARAM(trailer_pulse), duration)) {
+			if (s->count == 0)
+				bpf_rc_repeat(sample);
+			else
+				bpf_rc_keydown(sample, BPF_PARAM(rc_protocol), s->bits, 0);
+		}
+
+		s->state = STATE_INACTIVE;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/utils/keytable/bpf_protocols/pulse_length.c b/utils/keytable/bpf_protocols/pulse_length.c
new file mode 100644
index 00000000..e33f0899
--- /dev/null
+++ b/utils/keytable/bpf_protocols/pulse_length.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/lirc.h>
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+enum state {
+	STATE_INACTIVE,
+	STATE_HEADER_SPACE,
+	STATE_REPEAT_SPACE,
+	STATE_BITS_SPACE,
+	STATE_BITS_PULSE,
+	STATE_TRAILER,
+};
+
+struct decoder_state {
+	unsigned long bits;
+	enum state state;
+	unsigned int count;
+};
+
+struct bpf_map_def SEC("maps") decoder_state_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(unsigned int),
+	.value_size = sizeof(struct decoder_state),
+	.max_entries = 1,
+};
+
+// These values can be overridden in the rc_keymap toml
+//
+// We abuse elf relocations. We cast the address of these variables to
+// an int, so that the compiler emits a mov immediate for the address
+// but uses it as an int. The bpf loader replaces the relocation with the
+// actual value (either overridden or taken from the data segment).
+int margin = 200;
+int header_pulse = 2125;
+int header_space = 1875;
+int repeat_pulse = 0;
+int repeat_space = 0;
+int bit_space = 625;
+int bit_0_pulse = 375;
+int bit_1_pulse = 1625;
+int trailer_pulse = 0;
+int bits = 4;
+int reverse = 0;
+int header_optional = 0;
+int rc_protocol = 67;
+
+#define BPF_PARAM(x) (int)(&(x))
+
+static inline int eq_margin(unsigned d1, unsigned d2)
+{
+	return ((d1 > (d2 - BPF_PARAM(margin))) && (d1 < (d2 + BPF_PARAM(margin))));
+}
+
+SEC("pulse_length")
+int bpf_decoder(unsigned int *sample)
+{
+	unsigned int key = 0;
+	struct decoder_state *s = bpf_map_lookup_elem(&decoder_state_map, &key);
+
+	if (!s)
+		return 0;
+
+	switch (*sample & LIRC_MODE2_MASK) {
+	case LIRC_MODE2_SPACE:
+	case LIRC_MODE2_PULSE:
+	case LIRC_MODE2_TIMEOUT:
+		break;
+	default:
+		// not a timing events
+		return 0;
+	}
+
+	int duration = LIRC_VALUE(*sample);
+	int pulse = LIRC_IS_PULSE(*sample);
+
+	switch (s->state) {
+	case STATE_HEADER_SPACE:
+		if (!pulse && eq_margin(BPF_PARAM(header_space), duration))
+			s->state = STATE_BITS_PULSE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_REPEAT_SPACE:
+		if (!pulse && eq_margin(BPF_PARAM(repeat_space), duration))
+			s->state = STATE_TRAILER;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_INACTIVE:
+		if (pulse && eq_margin(BPF_PARAM(header_pulse), duration)) {
+			s->bits = 0;
+			s->state = STATE_HEADER_SPACE;
+			s->count = 0;
+			break;
+		}
+		if (pulse && BPF_PARAM(repeat_pulse) > 0 &&
+		    eq_margin(BPF_PARAM(repeat_pulse), duration)) {
+			s->state = STATE_REPEAT_SPACE;
+			s->count = 0;
+			break;
+		}
+		if (!BPF_PARAM(header_optional))
+			break;
+		/* pass through */
+	case STATE_BITS_PULSE:
+		if (!pulse)
+			break;
+
+		unsigned long set_bit = 1;
+
+		if (BPF_PARAM(reverse))
+			set_bit <<= s->count;
+		else
+			s->bits <<= 1;
+
+		if (eq_margin(BPF_PARAM(bit_1_pulse), duration))
+			s->bits |= set_bit;
+		else if (!eq_margin(BPF_PARAM(bit_0_pulse), duration)) {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		s->count++;
+		if (s->count == BPF_PARAM(bits)) {
+			bpf_rc_keydown(sample, BPF_PARAM(rc_protocol), s->bits, 0);
+			s->state = STATE_INACTIVE;
+		} else {
+			s->state = STATE_BITS_SPACE;
+		}
+		break;
+	case STATE_BITS_SPACE:
+		if (!pulse && eq_margin(BPF_PARAM(bit_space), duration))
+			s->state = STATE_BITS_PULSE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_TRAILER:
+		if (pulse && eq_margin(BPF_PARAM(trailer_pulse), duration))
+			bpf_rc_repeat(sample);
+
+		s->state = STATE_INACTIVE;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/utils/keytable/bpf_protocols/rc_mm.c b/utils/keytable/bpf_protocols/rc_mm.c
new file mode 100644
index 00000000..034d39b9
--- /dev/null
+++ b/utils/keytable/bpf_protocols/rc_mm.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/lirc.h>
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+enum state {
+	STATE_INACTIVE,
+	STATE_HEADER_SPACE,
+	STATE_BITS_SPACE,
+	STATE_BITS_PULSE,
+	STATE_TRAILER,
+};
+
+struct decoder_state {
+	unsigned int bits;
+	enum state state;
+	unsigned int count;
+};
+
+struct bpf_map_def SEC("maps") decoder_state_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(unsigned int),
+	.value_size = sizeof(struct decoder_state),
+	.max_entries = 1,
+};
+
+// These values can be overridden in the rc_keymap toml
+//
+// We abuse elf relocations. We cast the address of these variables to
+// an int, so that the compiler emits a mov immediate for the address
+// but uses it as an int. The bpf loader replaces the relocation with the
+// actual value (either overridden or taken from the data segment).
+//
+// This is why they should be accessed through the BPF_PARAM() macro.
+
+#define BPF_PARAM(x) (int)(&(x))
+
+int margin = 100;
+int header_pulse = 417;
+int header_space = 278;
+int bit_pulse = 167;
+int bit_0_space = 278;
+int bit_1_space = 444;
+int bit_2_space = 611;
+int bit_3_space = 778;
+int trailer = 167;
+int bits = 8;
+int rc_protocol = 65;
+
+static inline int eq_margin(unsigned d1, unsigned d2)
+{
+	return ((d1 > (d2 - BPF_PARAM(margin))) && (d1 < (d2 + BPF_PARAM(margin))));
+}
+
+SEC("rc_mm")
+int bpf_decoder(unsigned int *sample)
+{
+	unsigned int key = 0;
+	struct decoder_state *s = bpf_map_lookup_elem(&decoder_state_map, &key);
+	if (!s)
+		return 0;
+
+	switch (*sample & LIRC_MODE2_MASK) {
+	case LIRC_MODE2_SPACE:
+	case LIRC_MODE2_PULSE:
+	case LIRC_MODE2_TIMEOUT:
+		break;
+	default:
+		// not a timing events
+		return 0;
+	}
+
+	int duration = LIRC_VALUE(*sample);
+
+	switch (s->state) {
+	case STATE_INACTIVE:
+		if (LIRC_IS_PULSE(*sample) && eq_margin(BPF_PARAM(header_pulse), duration)) {
+			s->state = STATE_HEADER_SPACE;
+			s->bits = 0;
+			s->count = 0;
+		}
+		break;
+	case STATE_HEADER_SPACE:
+		if (LIRC_IS_SPACE(*sample) && eq_margin(BPF_PARAM(header_space), duration))
+			s->state = STATE_BITS_PULSE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_BITS_PULSE:
+		if (LIRC_IS_PULSE(*sample) && eq_margin(BPF_PARAM(bit_pulse), duration)) {
+			s->state = STATE_BITS_SPACE;
+		} else {
+			s->state = STATE_INACTIVE;
+		}
+		break;
+	case STATE_BITS_SPACE:
+		if (!LIRC_IS_SPACE(*sample)) {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		s->bits <<= 2;
+
+		if (eq_margin(BPF_PARAM(bit_0_space), duration)) {
+			s->bits |= 0;
+		} else if (eq_margin(BPF_PARAM(bit_1_space), duration)) {
+			s->bits |= 1;
+		} else if (eq_margin(BPF_PARAM(bit_2_space), duration)) {
+			s->bits |= 2;
+		} else if (eq_margin(BPF_PARAM(bit_3_space), duration)) {
+			s->bits |= 3;
+		} else {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		s->count += 2;
+		if (s->count >= BPF_PARAM(bits)) {
+			s->state = STATE_TRAILER;
+		} else {
+			s->state = STATE_BITS_PULSE;
+		}
+		break;
+	case STATE_TRAILER:
+		if (LIRC_IS_PULSE(*sample) && eq_margin(BPF_PARAM(trailer), duration))
+			bpf_rc_keydown(sample, BPF_PARAM(rc_protocol), s->bits, 0);
+
+		s->state = STATE_INACTIVE;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+
diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
index f7be08b3..e8203124 100644
--- a/v4l-utils.spec.in
+++ b/v4l-utils.spec.in
@@ -10,7 +10,7 @@ Source0:        http://linuxtv.org/downloads/v4l-utils/v4l-utils-%{version}.tar.
 Source1:        qv4l2.desktop
 Source2:        qv4l2.svg
 BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
-BuildRequires:  qt4-devel libsysfs-devel kernel-headers desktop-file-utils elfutils-libelf-devel
+BuildRequires:  qt4-devel libsysfs-devel kernel-headers desktop-file-utils elfutils-libelf-devel clang
 # For /etc/udev/rules.d ownership
 Requires:       udev
 Requires:       libv4l = %{version}-%{release}
-- 
2.17.1
