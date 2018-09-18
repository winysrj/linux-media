Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54275 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729726AbeIRUCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 16:02:23 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH 4/4] media: bpf: add bpf function to report mouse movement
Date: Tue, 18 Sep 2018 15:29:30 +0100
Message-Id: <20180918142930.6686-4-sean@mess.org>
In-Reply-To: <20180918142930.6686-1-sean@mess.org>
References: <20180918142930.6686-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some IR remotes have a directional pad or other pointer-like thing that
can be used as a mouse. Make it possible to decode these types of IR
protocols in BPF.

Cc: netdev@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/bpf-lirc.c               | 24 +++++++++++++++++++++++
 include/uapi/linux/bpf.h                  | 17 +++++++++++++++-
 tools/testing/selftests/bpf/bpf_helpers.h |  2 ++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 8b97fd1f0cea..390a722e6211 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -59,6 +59,28 @@ static const struct bpf_func_proto rc_keydown_proto = {
 	.arg4_type = ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_rc_pointer_rel, u32*, sample, s32, rel_x, s32, rel_y)
+{
+	struct ir_raw_event_ctrl *ctrl;
+
+	ctrl = container_of(sample, struct ir_raw_event_ctrl, bpf_sample);
+
+	input_report_rel(ctrl->dev->input_dev, REL_X, rel_x);
+	input_report_rel(ctrl->dev->input_dev, REL_Y, rel_y);
+	input_sync(ctrl->dev->input_dev);
+
+	return 0;
+}
+
+static const struct bpf_func_proto rc_pointer_rel_proto = {
+	.func	   = bpf_rc_pointer_rel,
+	.gpl_only  = true,
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -67,6 +89,8 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &rc_repeat_proto;
 	case BPF_FUNC_rc_keydown:
 		return &rc_keydown_proto;
+	case BPF_FUNC_rc_pointer_rel:
+		return &rc_pointer_rel_proto;
 	case BPF_FUNC_map_lookup_elem:
 		return &bpf_map_lookup_elem_proto;
 	case BPF_FUNC_map_update_elem:
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 66917a4eba27..20d6750b687c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2141,6 +2141,20 @@ union bpf_attr {
  *		request in the skb.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_rc_pointer_rel(void *ctx, s32 rel_x, s32 rel_y)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded pointer movement.
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
+ *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2226,7 +2240,8 @@ union bpf_attr {
 	FN(get_current_cgroup_id),	\
 	FN(get_local_storage),		\
 	FN(sk_select_reuseport),	\
-	FN(skb_ancestor_cgroup_id),
+	FN(skb_ancestor_cgroup_id),	\
+	FN(rc_pointer_rel),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index e4be7730222d..edda498c1231 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -143,6 +143,8 @@ static unsigned long long (*bpf_skb_cgroup_id)(void *ctx) =
 	(void *) BPF_FUNC_skb_cgroup_id;
 static unsigned long long (*bpf_skb_ancestor_cgroup_id)(void *ctx, int level) =
 	(void *) BPF_FUNC_skb_ancestor_cgroup_id;
+static int (*bpf_rc_pointer_rel)(void *ctx, int rel_x, int rel_y) =
+	(void *) BPF_FUNC_rc_pointer_rel;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
-- 
2.17.1
