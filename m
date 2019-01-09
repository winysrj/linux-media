Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FE2C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFEB2075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfAIL4f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:56:35 -0500
Received: from gofer.mess.org ([88.97.38.141]:57741 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbfAIL4e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 06:56:34 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 9DD4A601C6; Wed,  9 Jan 2019 11:56:33 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH] keytable: add support for iMON RSC remote pointer
Date:   Wed,  9 Jan 2019 11:56:33 +0000
Message-Id: <20190109115633.7115-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This remote has a small joystick which acts like a mouse. Support
decoding this.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/bpf_protocols/Makefile.am      |   2 +-
 utils/keytable/bpf_protocols/bpf_helpers.h    | 192 +++++++++++-------
 utils/keytable/bpf_protocols/imon_rsc.c       | 156 ++++++++++++++
 utils/keytable/rc_keymaps/imon_rsc.toml       |   2 +
 .../rc_keymaps_userspace/imon_rsc.toml        |  50 +++++
 5 files changed, 330 insertions(+), 72 deletions(-)
 create mode 100644 utils/keytable/bpf_protocols/imon_rsc.c
 create mode 100644 utils/keytable/rc_keymaps_userspace/imon_rsc.toml

diff --git a/utils/keytable/bpf_protocols/Makefile.am b/utils/keytable/bpf_protocols/Makefile.am
index d1f04cb4..123b64ec 100644
--- a/utils/keytable/bpf_protocols/Makefile.am
+++ b/utils/keytable/bpf_protocols/Makefile.am
@@ -10,7 +10,7 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
 %.o: %.c bpf_helpers.h
 	$(CLANG) $(CLANG_SYS_INCLUDES) -D__linux__ -I$(top_srcdir)/include -target bpf -O2 -c $<
 
-PROTOCOLS = grundig.o pulse_distance.o pulse_length.o rc_mm.o manchester.o xbox.o
+PROTOCOLS = grundig.o pulse_distance.o pulse_length.o rc_mm.o manchester.o xbox.o imon_rsc.o
 
 all: $(PROTOCOLS)
 
diff --git a/utils/keytable/bpf_protocols/bpf_helpers.h b/utils/keytable/bpf_protocols/bpf_helpers.h
index 8c1b8a23..6c77cf7b 100644
--- a/utils/keytable/bpf_protocols/bpf_helpers.h
+++ b/utils/keytable/bpf_protocols/bpf_helpers.h
@@ -10,129 +10,168 @@
 
 /* helper functions called from eBPF programs written in C */
 static void *(*bpf_map_lookup_elem)(void *map, void *key) =
-(void *) BPF_FUNC_map_lookup_elem;
+	(void *) BPF_FUNC_map_lookup_elem;
 static int (*bpf_map_update_elem)(void *map, void *key, void *value,
-		unsigned long long flags) =
-(void *) BPF_FUNC_map_update_elem;
+				  unsigned long long flags) =
+	(void *) BPF_FUNC_map_update_elem;
 static int (*bpf_map_delete_elem)(void *map, void *key) =
-(void *) BPF_FUNC_map_delete_elem;
+	(void *) BPF_FUNC_map_delete_elem;
+static int (*bpf_map_push_elem)(void *map, void *value,
+				unsigned long long flags) =
+	(void *) BPF_FUNC_map_push_elem;
+static int (*bpf_map_pop_elem)(void *map, void *value) =
+	(void *) BPF_FUNC_map_pop_elem;
+static int (*bpf_map_peek_elem)(void *map, void *value) =
+	(void *) BPF_FUNC_map_peek_elem;
 static int (*bpf_probe_read)(void *dst, int size, void *unsafe_ptr) =
-(void *) BPF_FUNC_probe_read;
+	(void *) BPF_FUNC_probe_read;
 static unsigned long long (*bpf_ktime_get_ns)(void) =
-(void *) BPF_FUNC_ktime_get_ns;
+	(void *) BPF_FUNC_ktime_get_ns;
 static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
-(void *) BPF_FUNC_trace_printk;
+	(void *) BPF_FUNC_trace_printk;
 static void (*bpf_tail_call)(void *ctx, void *map, int index) =
-(void *) BPF_FUNC_tail_call;
+	(void *) BPF_FUNC_tail_call;
 static unsigned long long (*bpf_get_smp_processor_id)(void) =
-(void *) BPF_FUNC_get_smp_processor_id;
+	(void *) BPF_FUNC_get_smp_processor_id;
 static unsigned long long (*bpf_get_current_pid_tgid)(void) =
-(void *) BPF_FUNC_get_current_pid_tgid;
+	(void *) BPF_FUNC_get_current_pid_tgid;
 static unsigned long long (*bpf_get_current_uid_gid)(void) =
-(void *) BPF_FUNC_get_current_uid_gid;
+	(void *) BPF_FUNC_get_current_uid_gid;
 static int (*bpf_get_current_comm)(void *buf, int buf_size) =
-(void *) BPF_FUNC_get_current_comm;
+	(void *) BPF_FUNC_get_current_comm;
 static unsigned long long (*bpf_perf_event_read)(void *map,
-		unsigned long long flags) =
-(void *) BPF_FUNC_perf_event_read;
+						 unsigned long long flags) =
+	(void *) BPF_FUNC_perf_event_read;
 static int (*bpf_clone_redirect)(void *ctx, int ifindex, int flags) =
-(void *) BPF_FUNC_clone_redirect;
+	(void *) BPF_FUNC_clone_redirect;
 static int (*bpf_redirect)(int ifindex, int flags) =
-(void *) BPF_FUNC_redirect;
+	(void *) BPF_FUNC_redirect;
 static int (*bpf_redirect_map)(void *map, int key, int flags) =
-(void *) BPF_FUNC_redirect_map;
+	(void *) BPF_FUNC_redirect_map;
 static int (*bpf_perf_event_output)(void *ctx, void *map,
-		unsigned long long flags, void *data,
-		int size) =
-(void *) BPF_FUNC_perf_event_output;
+				    unsigned long long flags, void *data,
+				    int size) =
+	(void *) BPF_FUNC_perf_event_output;
 static int (*bpf_get_stackid)(void *ctx, void *map, int flags) =
-(void *) BPF_FUNC_get_stackid;
+	(void *) BPF_FUNC_get_stackid;
 static int (*bpf_probe_write_user)(void *dst, void *src, int size) =
-(void *) BPF_FUNC_probe_write_user;
+	(void *) BPF_FUNC_probe_write_user;
 static int (*bpf_current_task_under_cgroup)(void *map, int index) =
-(void *) BPF_FUNC_current_task_under_cgroup;
+	(void *) BPF_FUNC_current_task_under_cgroup;
 static int (*bpf_skb_get_tunnel_key)(void *ctx, void *key, int size, int flags) =
-(void *) BPF_FUNC_skb_get_tunnel_key;
+	(void *) BPF_FUNC_skb_get_tunnel_key;
 static int (*bpf_skb_set_tunnel_key)(void *ctx, void *key, int size, int flags) =
-(void *) BPF_FUNC_skb_set_tunnel_key;
+	(void *) BPF_FUNC_skb_set_tunnel_key;
 static int (*bpf_skb_get_tunnel_opt)(void *ctx, void *md, int size) =
-(void *) BPF_FUNC_skb_get_tunnel_opt;
+	(void *) BPF_FUNC_skb_get_tunnel_opt;
 static int (*bpf_skb_set_tunnel_opt)(void *ctx, void *md, int size) =
-(void *) BPF_FUNC_skb_set_tunnel_opt;
+	(void *) BPF_FUNC_skb_set_tunnel_opt;
 static unsigned long long (*bpf_get_prandom_u32)(void) =
-(void *) BPF_FUNC_get_prandom_u32;
+	(void *) BPF_FUNC_get_prandom_u32;
 static int (*bpf_xdp_adjust_head)(void *ctx, int offset) =
-(void *) BPF_FUNC_xdp_adjust_head;
+	(void *) BPF_FUNC_xdp_adjust_head;
 static int (*bpf_xdp_adjust_meta)(void *ctx, int offset) =
-(void *) BPF_FUNC_xdp_adjust_meta;
+	(void *) BPF_FUNC_xdp_adjust_meta;
+static int (*bpf_get_socket_cookie)(void *ctx) =
+	(void *) BPF_FUNC_get_socket_cookie;
 static int (*bpf_setsockopt)(void *ctx, int level, int optname, void *optval,
-		int optlen) =
-(void *) BPF_FUNC_setsockopt;
+			     int optlen) =
+	(void *) BPF_FUNC_setsockopt;
 static int (*bpf_getsockopt)(void *ctx, int level, int optname, void *optval,
-		int optlen) =
-(void *) BPF_FUNC_getsockopt;
+			     int optlen) =
+	(void *) BPF_FUNC_getsockopt;
 static int (*bpf_sock_ops_cb_flags_set)(void *ctx, int flags) =
-(void *) BPF_FUNC_sock_ops_cb_flags_set;
+	(void *) BPF_FUNC_sock_ops_cb_flags_set;
 static int (*bpf_sk_redirect_map)(void *ctx, void *map, int key, int flags) =
-(void *) BPF_FUNC_sk_redirect_map;
+	(void *) BPF_FUNC_sk_redirect_map;
 static int (*bpf_sk_redirect_hash)(void *ctx, void *map, void *key, int flags) =
-(void *) BPF_FUNC_sk_redirect_hash;
+	(void *) BPF_FUNC_sk_redirect_hash;
 static int (*bpf_sock_map_update)(void *map, void *key, void *value,
-		unsigned long long flags) =
-(void *) BPF_FUNC_sock_map_update;
+				  unsigned long long flags) =
+	(void *) BPF_FUNC_sock_map_update;
 static int (*bpf_sock_hash_update)(void *map, void *key, void *value,
-		unsigned long long flags) =
-(void *) BPF_FUNC_sock_hash_update;
+				   unsigned long long flags) =
+	(void *) BPF_FUNC_sock_hash_update;
 static int (*bpf_perf_event_read_value)(void *map, unsigned long long flags,
-		void *buf, unsigned int buf_size) =
-(void *) BPF_FUNC_perf_event_read_value;
+					void *buf, unsigned int buf_size) =
+	(void *) BPF_FUNC_perf_event_read_value;
 static int (*bpf_perf_prog_read_value)(void *ctx, void *buf,
-		unsigned int buf_size) =
-(void *) BPF_FUNC_perf_prog_read_value;
+				       unsigned int buf_size) =
+	(void *) BPF_FUNC_perf_prog_read_value;
 static int (*bpf_override_return)(void *ctx, unsigned long rc) =
-(void *) BPF_FUNC_override_return;
+	(void *) BPF_FUNC_override_return;
 static int (*bpf_msg_redirect_map)(void *ctx, void *map, int key, int flags) =
-(void *) BPF_FUNC_msg_redirect_map;
+	(void *) BPF_FUNC_msg_redirect_map;
 static int (*bpf_msg_redirect_hash)(void *ctx,
-		void *map, void *key, int flags) =
-(void *) BPF_FUNC_msg_redirect_hash;
+				    void *map, void *key, int flags) =
+	(void *) BPF_FUNC_msg_redirect_hash;
 static int (*bpf_msg_apply_bytes)(void *ctx, int len) =
-(void *) BPF_FUNC_msg_apply_bytes;
+	(void *) BPF_FUNC_msg_apply_bytes;
 static int (*bpf_msg_cork_bytes)(void *ctx, int len) =
-(void *) BPF_FUNC_msg_cork_bytes;
+	(void *) BPF_FUNC_msg_cork_bytes;
 static int (*bpf_msg_pull_data)(void *ctx, int start, int end, int flags) =
-(void *) BPF_FUNC_msg_pull_data;
+	(void *) BPF_FUNC_msg_pull_data;
+static int (*bpf_msg_push_data)(void *ctx, int start, int end, int flags) =
+	(void *) BPF_FUNC_msg_push_data;
+static int (*bpf_msg_pop_data)(void *ctx, int start, int cut, int flags) =
+	(void *) BPF_FUNC_msg_pop_data;
 static int (*bpf_bind)(void *ctx, void *addr, int addr_len) =
-(void *) BPF_FUNC_bind;
+	(void *) BPF_FUNC_bind;
 static int (*bpf_xdp_adjust_tail)(void *ctx, int offset) =
-(void *) BPF_FUNC_xdp_adjust_tail;
+	(void *) BPF_FUNC_xdp_adjust_tail;
 static int (*bpf_skb_get_xfrm_state)(void *ctx, int index, void *state,
-		int size, int flags) =
-(void *) BPF_FUNC_skb_get_xfrm_state;
+				     int size, int flags) =
+	(void *) BPF_FUNC_skb_get_xfrm_state;
+static int (*bpf_sk_select_reuseport)(void *ctx, void *map, void *key, __u32 flags) =
+	(void *) BPF_FUNC_sk_select_reuseport;
 static int (*bpf_get_stack)(void *ctx, void *buf, int size, int flags) =
-(void *) BPF_FUNC_get_stack;
+	(void *) BPF_FUNC_get_stack;
 static int (*bpf_fib_lookup)(void *ctx, struct bpf_fib_lookup *params,
-		int plen, __u32 flags) =
-(void *) BPF_FUNC_fib_lookup;
+			     int plen, __u32 flags) =
+	(void *) BPF_FUNC_fib_lookup;
 static int (*bpf_lwt_push_encap)(void *ctx, unsigned int type, void *hdr,
-		unsigned int len) =
-(void *) BPF_FUNC_lwt_push_encap;
+				 unsigned int len) =
+	(void *) BPF_FUNC_lwt_push_encap;
 static int (*bpf_lwt_seg6_store_bytes)(void *ctx, unsigned int offset,
-		void *from, unsigned int len) =
-(void *) BPF_FUNC_lwt_seg6_store_bytes;
+				       void *from, unsigned int len) =
+	(void *) BPF_FUNC_lwt_seg6_store_bytes;
 static int (*bpf_lwt_seg6_action)(void *ctx, unsigned int action, void *param,
-		unsigned int param_len) =
-(void *) BPF_FUNC_lwt_seg6_action;
+				  unsigned int param_len) =
+	(void *) BPF_FUNC_lwt_seg6_action;
 static int (*bpf_lwt_seg6_adjust_srh)(void *ctx, unsigned int offset,
-		unsigned int len) =
-(void *) BPF_FUNC_lwt_seg6_adjust_srh;
+				      unsigned int len) =
+	(void *) BPF_FUNC_lwt_seg6_adjust_srh;
 static int (*bpf_rc_repeat)(void *ctx) =
-(void *) BPF_FUNC_rc_repeat;
+	(void *) BPF_FUNC_rc_repeat;
 static int (*bpf_rc_keydown)(void *ctx, unsigned int protocol,
-		unsigned long long scancode, unsigned int toggle) =
-(void *) BPF_FUNC_rc_keydown;
+			     unsigned long long scancode, unsigned int toggle) =
+	(void *) BPF_FUNC_rc_keydown;
 static unsigned long long (*bpf_get_current_cgroup_id)(void) =
-(void *) BPF_FUNC_get_current_cgroup_id;
+	(void *) BPF_FUNC_get_current_cgroup_id;
+static void *(*bpf_get_local_storage)(void *map, unsigned long long flags) =
+	(void *) BPF_FUNC_get_local_storage;
+static unsigned long long (*bpf_skb_cgroup_id)(void *ctx) =
+	(void *) BPF_FUNC_skb_cgroup_id;
+static unsigned long long (*bpf_skb_ancestor_cgroup_id)(void *ctx, int level) =
+	(void *) BPF_FUNC_skb_ancestor_cgroup_id;
+static struct bpf_sock *(*bpf_sk_lookup_tcp)(void *ctx,
+					     struct bpf_sock_tuple *tuple,
+					     int size, unsigned long long netns_id,
+					     unsigned long long flags) =
+	(void *) BPF_FUNC_sk_lookup_tcp;
+static struct bpf_sock *(*bpf_sk_lookup_udp)(void *ctx,
+					     struct bpf_sock_tuple *tuple,
+					     int size, unsigned long long netns_id,
+					     unsigned long long flags) =
+	(void *) BPF_FUNC_sk_lookup_udp;
+static int (*bpf_sk_release)(struct bpf_sock *sk) =
+	(void *) BPF_FUNC_sk_release;
+static int (*bpf_skb_vlan_push)(void *ctx, __be16 vlan_proto, __u16 vlan_tci) =
+	(void *) BPF_FUNC_skb_vlan_push;
+static int (*bpf_skb_vlan_pop)(void *ctx) =
+	(void *) BPF_FUNC_skb_vlan_pop;
+static int (*bpf_rc_pointer_rel)(void *ctx, int rel_x, int rel_y) =
+	(void *) BPF_FUNC_rc_pointer_rel;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
@@ -158,8 +197,19 @@ struct bpf_map_def {
 	unsigned int numa_node;
 };
 
+#define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
+	struct ____btf_map_##name {				\
+		type_key key;					\
+		type_val value;					\
+	};							\
+	struct ____btf_map_##name				\
+	__attribute__ ((section(".maps." #name), used))		\
+		____btf_map_##name = { }
+
 static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
 	(void *) BPF_FUNC_skb_load_bytes;
+static int (*bpf_skb_load_bytes_relative)(void *ctx, int off, void *to, int len, __u32 start_header) =
+	(void *) BPF_FUNC_skb_load_bytes_relative;
 static int (*bpf_skb_store_bytes)(void *ctx, int off, void *from, int len, int flags) =
 	(void *) BPF_FUNC_skb_store_bytes;
 static int (*bpf_l3_csum_replace)(void *ctx, int off, int from, int to, int flags) =
diff --git a/utils/keytable/bpf_protocols/imon_rsc.c b/utils/keytable/bpf_protocols/imon_rsc.c
new file mode 100644
index 00000000..6aaf6126
--- /dev/null
+++ b/utils/keytable/bpf_protocols/imon_rsc.c
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
+	STATE_BITS_SPACE,
+	STATE_BITS_PULSE,
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
+
+#define BPF_PARAM(x) (int)(&(x))
+
+static inline int eq_margin(unsigned d1, unsigned d2)
+{
+	return ((d1 > (d2 - BPF_PARAM(margin))) && (d1 < (d2 + BPF_PARAM(margin))));
+}
+
+SEC("imon_rsc")
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
+		if (!pulse && eq_margin(4500, duration))
+			s->state = STATE_BITS_PULSE;
+		else if (!pulse && eq_margin(2250, duration))
+			s->state = STATE_BITS_PULSE;
+		else if (!pulse && eq_margin(1875, duration))
+			s->state = STATE_BITS_PULSE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_INACTIVE:
+		if (pulse && eq_margin(9000, duration)) {
+			s->bits = 0;
+			s->state = STATE_HEADER_SPACE;
+			s->count = 0;
+			break;
+		}
+		if (pulse && eq_margin(2000, duration)) {
+			s->state = STATE_HEADER_SPACE;
+			s->bits = 0;
+			s->count = 0;
+			break;
+		}
+		break;
+	case STATE_BITS_PULSE:
+		if (pulse && eq_margin(625, duration))
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
+		if (duration > 10000) {
+			if (s->count == 0) {
+				bpf_rc_repeat(sample);
+			} else if (s->count == 4) {
+				int x = 0, y = 0;
+				switch (s->bits) {
+				case 0: x = 0;   y = -16; break;
+				case 8: x = 0;   y =  16; break;
+				case 4: x = 16;  y =  0;  break;
+				case 12: x = -16; y =  0;  break;
+
+				case 2: x = 16;  y = -16; break;
+				case 10: x = -16; y =  16; break;
+				case 6: x = 16;  y =  16; break;
+				case 14: x = -16; y = -16; break;
+
+				case  1: x = 16;  y = -8; break;
+				case  9: x = -16; y =  8; break;
+				case  5: x = 8;  y =  16; break;
+				case 13: x = -8; y = -16; break;
+
+				case 3: x = 8;  y = -16; break;
+				case 11: x = -8; y =  16; break;
+				case 7: x = 16;  y =  8; break;
+				case 15: x = -16; y = -8; break;
+				}
+				bpf_rc_pointer_rel(sample, x, y);
+			} else if (s->count == 32) {
+				unsigned int scancode =
+					((s->bits & 0x0000ff) << 16) |
+					 (s->bits & 0x00ff00) |
+					((s->bits & 0xff0000) >> 16);
+				bpf_rc_keydown(sample, RC_PROTO_NECX, scancode, 0);
+			}
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		if (eq_margin(1700, duration))
+			s->bits |= 1 << s->count;
+		else if (!eq_margin(625, duration)) {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+		s->count++;
+		s->state = STATE_BITS_PULSE;
+		break;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/utils/keytable/rc_keymaps/imon_rsc.toml b/utils/keytable/rc_keymaps/imon_rsc.toml
index ace34860..4f20a54e 100644
--- a/utils/keytable/rc_keymaps/imon_rsc.toml
+++ b/utils/keytable/rc_keymaps/imon_rsc.toml
@@ -46,3 +46,5 @@ variant = "necx"
 0x801052 = "KEY_REWIND"
 0x801053 = "KEY_FASTFORWARD"
 0x801089 = "KEY_ZOOM"
+[[protocols]]
+protocol = "imon_rsc"
diff --git a/utils/keytable/rc_keymaps_userspace/imon_rsc.toml b/utils/keytable/rc_keymaps_userspace/imon_rsc.toml
new file mode 100644
index 00000000..4f20a54e
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/imon_rsc.toml
@@ -0,0 +1,50 @@
+[[protocols]]
+name = "imon_rsc"
+protocol = "nec"
+variant = "necx"
+[protocols.scancodes]
+0x801010 = "KEY_EXIT"
+0x80102f = "KEY_POWER"
+0x80104a = "KEY_SCREENSAVER"
+0x801049 = "KEY_TIME"
+0x801054 = "KEY_NUMERIC_1"
+0x801055 = "KEY_NUMERIC_2"
+0x801056 = "KEY_NUMERIC_3"
+0x801057 = "KEY_NUMERIC_4"
+0x801058 = "KEY_NUMERIC_5"
+0x801059 = "KEY_NUMERIC_6"
+0x80105a = "KEY_NUMERIC_7"
+0x80105b = "KEY_NUMERIC_8"
+0x80105c = "KEY_NUMERIC_9"
+0x801081 = "KEY_SCREEN"
+0x80105d = "KEY_NUMERIC_0"
+0x801082 = "KEY_MAX"
+0x801048 = "KEY_ESC"
+0x80104b = "KEY_MEDIA"
+0x801083 = "KEY_MENU"
+0x801045 = "KEY_APPSELECT"
+0x801084 = "KEY_STOP"
+0x801046 = "KEY_CYCLEWINDOWS"
+0x801085 = "KEY_BACKSPACE"
+0x801086 = "KEY_KEYBOARD"
+0x801087 = "KEY_SPACE"
+0x80101e = "KEY_RESERVED"
+0x801098 = "BTN_0"
+0x80101f = "KEY_TAB"
+0x80101b = "BTN_LEFT"
+0x80101d = "BTN_RIGHT"
+0x801016 = "BTN_MIDDLE"
+0x801088 = "KEY_MUTE"
+0x80105e = "KEY_VOLUMEDOWN"
+0x80105f = "KEY_VOLUMEUP"
+0x80104c = "KEY_PLAY"
+0x80104d = "KEY_PAUSE"
+0x80104f = "KEY_EJECTCD"
+0x801050 = "KEY_PREVIOUS"
+0x801051 = "KEY_NEXT"
+0x80104e = "KEY_STOP"
+0x801052 = "KEY_REWIND"
+0x801053 = "KEY_FASTFORWARD"
+0x801089 = "KEY_ZOOM"
+[[protocols]]
+protocol = "imon_rsc"
-- 
2.20.1

