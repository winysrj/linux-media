Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36414 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757283AbcHWIXw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 04:23:52 -0400
Received: by mail-wm0-f67.google.com with SMTP id i138so16936431wmf.3
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2016 01:23:51 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCHv2] cec-compliance: improve One Touch Play tests wrt. CTS 1.4b
Date: Tue, 23 Aug 2016 10:10:44 +0200
Message-Id: <1471939844-22502-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This improves the One Touch Play tests to make them more in line with
the HDMI 1.4b Compliance Test Specification. Probing for Image View On
and Text View On is separated out and always performed, and in
interactive mode, there are now separate tests for waking up upon
receiving Image/Text View On, and changing to the correct input when
receiving Image/Text View On (followed by Active Source)

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-compliance/cec-test-power.cpp | 100 +++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 33 deletions(-)

diff --git a/utils/cec-compliance/cec-test-power.cpp b/utils/cec-compliance/cec-test-power.cpp
index e88e338..920ab69 100644
--- a/utils/cec-compliance/cec-test-power.cpp
+++ b/utils/cec-compliance/cec-test-power.cpp
@@ -61,7 +61,8 @@ bool util_interactive_ensure_power_state(struct node *node, unsigned me, unsigne
 			return true;
 		else
 			announce("The device reported power status %s.", power_status2s(pwr));
-		fail_on_test(!question("Retry?"));
+		if (!question("Retry?"))
+			return false;
 	}
 
 	return true;
@@ -116,45 +117,50 @@ const unsigned power_status_subtests_size = ARRAY_SIZE(power_status_subtests);
 
 /* One Touch Play */
 
-static int one_touch_play_image_view_on(struct node *node, unsigned me, unsigned la, bool interactive)
+static int one_touch_play_view_on(struct node *node, unsigned me, unsigned la, bool interactive,
+				  __u8 opcode)
 {
 	struct cec_msg msg = {};
 
-	fail_on_test(!util_interactive_ensure_power_state(node, me, la, interactive, CEC_OP_POWER_STATUS_STANDBY));
-
 	cec_msg_init(&msg, me, la);
-	cec_msg_image_view_on(&msg);
+	if (opcode == CEC_MSG_IMAGE_VIEW_ON)
+		cec_msg_image_view_on(&msg);
+	else if (opcode == CEC_MSG_TEXT_VIEW_ON)
+		cec_msg_text_view_on(&msg);
 	fail_on_test(!transmit_timeout(node, &msg));
 	fail_on_test(is_tv(la, node->remote[la].prim_type) && unrecognized_op(&msg));
 	if (refused(&msg))
 		return REFUSED;
 	if (cec_msg_status_is_abort(&msg))
 		return PRESUMED_OK;
-	fail_on_test(interactive && !question("Did the TV turn on?"));
-	node->remote[la].has_image_view_on = true;
+	if (opcode == CEC_MSG_IMAGE_VIEW_ON)
+		node->remote[la].has_image_view_on = true;
+	else if (opcode == CEC_MSG_TEXT_VIEW_ON)
+		node->remote[la].has_text_view_on = true;
 
-	if (interactive)
-		return 0;
-	else
-		return PRESUMED_OK;
+	return 0;
+}
+
+static int one_touch_play_image_view_on(struct node *node, unsigned me, unsigned la, bool interactive)
+{
+	return one_touch_play_view_on(node, me, la, interactive, CEC_MSG_IMAGE_VIEW_ON);
 }
 
 static int one_touch_play_text_view_on(struct node *node, unsigned me, unsigned la, bool interactive)
 {
-	struct cec_msg msg = {};
+	return one_touch_play_view_on(node, me, la, interactive, CEC_MSG_TEXT_VIEW_ON);
+}
 
+static int one_touch_play_view_on_wakeup(struct node *node, unsigned me, unsigned la, bool interactive,
+					 __u8 opcode)
+{
 	fail_on_test(!util_interactive_ensure_power_state(node, me, la, interactive, CEC_OP_POWER_STATUS_STANDBY));
 
-	cec_msg_init(&msg, me, la);
-	cec_msg_text_view_on(&msg);
-	fail_on_test(!transmit_timeout(node, &msg));
-	fail_on_test(is_tv(la, node->remote[la].prim_type) && unrecognized_op(&msg));
-	if (refused(&msg))
-		return REFUSED;
-	if (cec_msg_status_is_abort(&msg))
-		return PRESUMED_OK;
+	int ret = one_touch_play_view_on(node, me, la, interactive, opcode);
+
+	if (ret && ret != PRESUMED_OK)
+		return ret;
 	fail_on_test(interactive && !question("Did the TV turn on?"));
-	node->remote[la].has_text_view_on = true;
 
 	if (interactive)
 		return 0;
@@ -162,21 +168,32 @@ static int one_touch_play_text_view_on(struct node *node, unsigned me, unsigned
 		return PRESUMED_OK;
 }
 
-static int one_touch_play_active_source(struct node *node, unsigned me, unsigned la, bool interactive)
+static int one_touch_play_image_view_on_wakeup(struct node *node, unsigned me, unsigned la, bool interactive)
 {
-	struct cec_msg msg = {};
+	if (!interactive || !node->remote[la].has_image_view_on)
+		return NOTAPPLICABLE;
+	return one_touch_play_view_on_wakeup(node, me, la, interactive, CEC_MSG_IMAGE_VIEW_ON);
+}
 
-	while (interactive) {
-		__u8 pwr;
+static int one_touch_play_text_view_on_wakeup(struct node *node, unsigned me, unsigned la, bool interactive)
+{
+	if (!interactive || !node->remote[la].has_text_view_on)
+		return NOTAPPLICABLE;
+	return one_touch_play_view_on_wakeup(node, me, la, interactive, CEC_MSG_TEXT_VIEW_ON);
+}
 
-		interactive_info(true, "Please switch the TV to another source.");
-		fail_on_test(!get_power_status(node, me, la, pwr));
-		if (pwr == CEC_OP_POWER_STATUS_ON)
-			break;
-		announce("The device reported power status %s.", power_status2s(pwr));
-		fail_on_test(!question("Retry?"));
-	}
+static int one_touch_play_view_on_change(struct node *node, unsigned me, unsigned la, bool interactive,
+					 __u8 opcode)
+{
+	struct cec_msg msg = {};
+	int ret;
+
+	fail_on_test(!util_interactive_ensure_power_state(node, me, la, interactive, CEC_OP_POWER_STATUS_ON));
 
+	interactive_info(true, "Please switch the TV to another source.");
+	ret = one_touch_play_view_on(node, me, la, interactive, opcode);
+	if (ret && ret != PRESUMED_OK)
+		return ret;
 	cec_msg_init(&msg, me, la);
 	cec_msg_active_source(&msg, node->phys_addr);
 	fail_on_test(!transmit_timeout(node, &msg));
@@ -188,6 +205,20 @@ static int one_touch_play_active_source(struct node *node, unsigned me, unsigned
 		return PRESUMED_OK;
 }
 
+static int one_touch_play_image_view_on_change(struct node *node, unsigned me, unsigned la, bool interactive)
+{
+	if (!interactive || !node->remote[la].has_text_view_on)
+		return NOTAPPLICABLE;
+	return one_touch_play_view_on_change(node, me, la, interactive, CEC_MSG_IMAGE_VIEW_ON);
+}
+
+static int one_touch_play_text_view_on_change(struct node *node, unsigned me, unsigned la, bool interactive)
+{
+	if (!interactive || !node->remote[la].has_text_view_on)
+		return NOTAPPLICABLE;
+	return one_touch_play_view_on_change(node, me, la, interactive, CEC_MSG_TEXT_VIEW_ON);
+}
+
 static int one_touch_play_req_active_source(struct node *node, unsigned me, unsigned la, bool interactive)
 {
 	struct cec_msg msg = {};
@@ -205,7 +236,10 @@ static int one_touch_play_req_active_source(struct node *node, unsigned me, unsi
 struct remote_subtest one_touch_play_subtests[] = {
 	{ "Image View On", CEC_LOG_ADDR_MASK_TV, one_touch_play_image_view_on },
 	{ "Text View On", CEC_LOG_ADDR_MASK_TV, one_touch_play_text_view_on },
-	{ "Active Source", CEC_LOG_ADDR_MASK_TV | CEC_LOG_ADDR_MASK_UNREGISTERED, one_touch_play_active_source },
+	{ "Wakeup on Image View On", CEC_LOG_ADDR_MASK_TV, one_touch_play_image_view_on_wakeup },
+	{ "Wakeup Text View On", CEC_LOG_ADDR_MASK_TV, one_touch_play_text_view_on_wakeup },
+	{ "Input change on Image View On", CEC_LOG_ADDR_MASK_TV, one_touch_play_image_view_on_change },
+	{ "Input change on Text View On", CEC_LOG_ADDR_MASK_TV, one_touch_play_text_view_on_change },
 	{ "Request Active Source", (__u16)~CEC_LOG_ADDR_MASK_TV, one_touch_play_req_active_source },
 };
 
-- 
2.7.4

