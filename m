Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A8CC04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 13:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD48208E7
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 13:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DD48208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbeLFNBG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 08:01:06 -0500
Received: from gofer.mess.org ([88.97.38.141]:41033 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbeLFNBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 08:01:05 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id D863F607A9; Thu,  6 Dec 2018 13:01:03 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roman Gushchin <guro@fb.com>, Martin KaFai Lau <kafai@fb.com>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3] media: bpf: add bpf function to report mouse movement
Date:   Thu,  6 Dec 2018 13:01:03 +0000
Message-Id: <20181206130103.751-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some IR remotes have a directional pad or other pointer-like thing that
can be used as a mouse. Make it possible to decode these types of IR
protocols in BPF.

Cc: netdev@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/bpf-lirc.c                   | 24 +++++++
 include/uapi/linux/bpf.h                      | 17 ++++-
 tools/include/uapi/linux/bpf.h                | 18 ++++-
 tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
 .../testing/selftests/bpf/test_lirc_mode2.sh  |  3 +-
 .../selftests/bpf/test_lirc_mode2_kern.c      |  3 +
 .../selftests/bpf/test_lirc_mode2_user.c      | 65 +++++++++++++------
 7 files changed, 109 insertions(+), 23 deletions(-)

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
index a84fd232d934..fe3c90cf6484 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2298,6 +2298,20 @@ union bpf_attr {
  *		payload and/or *pop* value being to large.
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
@@ -2391,7 +2405,8 @@ union bpf_attr {
 	FN(map_pop_elem),		\
 	FN(map_peek_elem),		\
 	FN(msg_push_data),		\
-	FN(msg_pop_data),
+	FN(msg_pop_data),		\
+	FN(rc_pointer_rel),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 16263e8827fc..9c5bf9be75af 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2295,9 +2295,22 @@ union bpf_attr {
  *		if possible. Other errors can occur if input parameters are
  *		invalid either due to *start* byte not being valid part of msg
  *		payload and/or *pop* value being to large.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_rc_pointer_rel(void *ctx, s32 rel_x, s32 rel_y)
+ *	Description
+ *		This helper is used in programs implementing IR decoding, to
+ *		report a successfully decoded pointer movement.
+ *
+ *		The *ctx* should point to the lirc sample as passed into
+ *		the program.
  *
+ *		This helper is only available is the kernel was compiled with
+ *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
+ *		"**y**".
  *	Return
- *		0 on success, or a negative erro in case of failure.
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2391,7 +2404,8 @@ union bpf_attr {
 	FN(map_pop_elem),		\
 	FN(map_peek_elem),		\
 	FN(msg_push_data),		\
-	FN(msg_pop_data),
+	FN(msg_pop_data),		\
+	FN(rc_pointer_rel),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 7b69519a09b1..04c060e8f10a 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -170,6 +170,8 @@ static int (*bpf_skb_vlan_push)(void *ctx, __be16 vlan_proto, __u16 vlan_tci) =
 	(void *) BPF_FUNC_skb_vlan_push;
 static int (*bpf_skb_vlan_pop)(void *ctx) =
 	(void *) BPF_FUNC_skb_vlan_pop;
+static int (*bpf_rc_pointer_rel)(void *ctx, int rel_x, int rel_y) =
+	(void *) BPF_FUNC_rc_pointer_rel;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/test_lirc_mode2.sh b/tools/testing/selftests/bpf/test_lirc_mode2.sh
index 677686198df3..ec4e15948e40 100755
--- a/tools/testing/selftests/bpf/test_lirc_mode2.sh
+++ b/tools/testing/selftests/bpf/test_lirc_mode2.sh
@@ -21,13 +21,14 @@ do
 	if grep -q DRV_NAME=rc-loopback $i/uevent
 	then
 		LIRCDEV=$(grep DEVNAME= $i/lirc*/uevent | sed sQDEVNAME=Q/dev/Q)
+		INPUTDEV=$(grep DEVNAME= $i/input*/event*/uevent | sed sQDEVNAME=Q/dev/Q)
 	fi
 done
 
 if [ -n $LIRCDEV ];
 then
 	TYPE=lirc_mode2
-	./test_lirc_mode2_user $LIRCDEV
+	./test_lirc_mode2_user $LIRCDEV $INPUTDEV
 	ret=$?
 	if [ $ret -ne 0 ]; then
 		echo -e ${RED}"FAIL: $TYPE"${NC}
diff --git a/tools/testing/selftests/bpf/test_lirc_mode2_kern.c b/tools/testing/selftests/bpf/test_lirc_mode2_kern.c
index ba26855563a5..4147130cc3b7 100644
--- a/tools/testing/selftests/bpf/test_lirc_mode2_kern.c
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_kern.c
@@ -15,6 +15,9 @@ int bpf_decoder(unsigned int *sample)
 
 		if (duration & 0x10000)
 			bpf_rc_keydown(sample, 0x40, duration & 0xffff, 0);
+		if (duration & 0x20000)
+			bpf_rc_pointer_rel(sample, (duration >> 8) & 0xff,
+					   duration & 0xff);
 	}
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/test_lirc_mode2_user.c b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
index d470d63c33db..fb5fd6841ef3 100644
--- a/tools/testing/selftests/bpf/test_lirc_mode2_user.c
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
@@ -29,6 +29,7 @@
 
 #include <linux/bpf.h>
 #include <linux/lirc.h>
+#include <linux/input.h>
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -47,12 +48,13 @@
 int main(int argc, char **argv)
 {
 	struct bpf_object *obj;
-	int ret, lircfd, progfd, mode;
-	int testir = 0x1dead;
+	int ret, lircfd, progfd, inputfd;
+	int testir1 = 0x1dead;
+	int testir2 = 0x20101;
 	u32 prog_ids[10], prog_flags[10], prog_cnt;
 
-	if (argc != 2) {
-		printf("Usage: %s /dev/lircN\n", argv[0]);
+	if (argc != 3) {
+		printf("Usage: %s /dev/lircN /dev/input/eventM\n", argv[0]);
 		return 2;
 	}
 
@@ -76,9 +78,9 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	mode = LIRC_MODE_SCANCODE;
-	if (ioctl(lircfd, LIRC_SET_REC_MODE, &mode)) {
-		printf("failed to set rec mode: %m\n");
+	inputfd = open(argv[2], O_RDONLY | O_NONBLOCK);
+	if (inputfd == -1) {
+		printf("failed to open input device %s: %m\n", argv[1]);
 		return 1;
 	}
 
@@ -102,29 +104,54 @@ int main(int argc, char **argv)
 	}
 
 	/* Write raw IR */
-	ret = write(lircfd, &testir, sizeof(testir));
-	if (ret != sizeof(testir)) {
+	ret = write(lircfd, &testir1, sizeof(testir1));
+	if (ret != sizeof(testir1)) {
 		printf("Failed to send test IR message: %m\n");
 		return 1;
 	}
 
-	struct pollfd pfd = { .fd = lircfd, .events = POLLIN };
-	struct lirc_scancode lsc;
+	struct pollfd pfd = { .fd = inputfd, .events = POLLIN };
+	struct input_event event;
 
-	poll(&pfd, 1, 100);
+	for (;;) {
+		poll(&pfd, 1, 100);
 
-	/* Read decoded IR */
-	ret = read(lircfd, &lsc, sizeof(lsc));
-	if (ret != sizeof(lsc)) {
-		printf("Failed to read decoded IR: %m\n");
-		return 1;
+		/* Read decoded IR */
+		ret = read(inputfd, &event, sizeof(event));
+		if (ret != sizeof(event)) {
+			printf("Failed to read decoded IR: %m\n");
+			return 1;
+		}
+
+		if (event.type == EV_MSC && event.code == MSC_SCAN &&
+		    event.value == 0xdead) {
+			break;
+		}
 	}
 
-	if (lsc.scancode != 0xdead || lsc.rc_proto != 64) {
-		printf("Incorrect scancode decoded\n");
+	/* Write raw IR */
+	ret = write(lircfd, &testir2, sizeof(testir2));
+	if (ret != sizeof(testir2)) {
+		printf("Failed to send test IR message: %m\n");
 		return 1;
 	}
 
+	for (;;) {
+		poll(&pfd, 1, 100);
+
+		/* Read decoded IR */
+		ret = read(inputfd, &event, sizeof(event));
+		if (ret != sizeof(event)) {
+			printf("Failed to read decoded IR: %m\n");
+			return 1;
+		}
+
+		if (event.type == EV_REL && event.code == REL_Y &&
+		    event.value == 1 ) {
+			break;
+		}
+	}
+
 	prog_cnt = 10;
 	ret = bpf_prog_query(lircfd, BPF_LIRC_MODE2, 0, prog_flags, prog_ids,
 			     &prog_cnt);
-- 
2.19.2

