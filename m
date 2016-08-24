Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32931 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbcHXKY0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:24:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id o80so1968196wme.0
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 03:24:25 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH] cec-compliance: fix Device OSD Transfer tests
Date: Wed, 24 Aug 2016 12:24:05 +0200
Message-Id: <1472034245-13683-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove a check for whether the first Set OSD String test applies, since this
test itself is used to determine whether the others apply. This bug
caused the tests to never be run.

Also fix the test for Set OSD String where the default display control
operand is given. In this case, when in interactive mode, we should wait for
at least 20 s and ask the user if there was any change (according to the CEC
1.4b CTS).

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-compliance/cec-test.cpp | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/utils/cec-compliance/cec-test.cpp b/utils/cec-compliance/cec-test.cpp
index 5fac04a..20d818f 100644
--- a/utils/cec-compliance/cec-test.cpp
+++ b/utils/cec-compliance/cec-test.cpp
@@ -354,16 +354,13 @@ static struct remote_subtest device_osd_transfer_subtests[] = {
 
 static int osd_string_set_default(struct node *node, unsigned me, unsigned la, bool interactive)
 {
-	if (!node->remote[la].has_osd)
-		return NOTAPPLICABLE;
-
 	struct cec_msg msg = { };
 	char osd[14];
 	bool unsuitable = false;
 
 	sprintf(osd, "Rept %x from %x", la, me);
 
-	interactive_info(true, "You should see \"%s\" appear on the screen for approximately one second.", osd);
+	interactive_info(true, "You should see \"%s\" appear on the screen", osd);
 	cec_msg_init(&msg, me, la);
 	cec_msg_set_osd_string(&msg, CEC_OP_DISP_CTL_DEFAULT, osd);
 	fail_on_test(!transmit_timeout(node, &msg));
@@ -380,18 +377,17 @@ static int osd_string_set_default(struct node *node, unsigned me, unsigned la, b
 		warn("The device is in an unsuitable state or cannot display the complete message.\n");
 		unsuitable = true;
 	}
-
-	cec_msg_init(&msg, me, la);
-	cec_msg_set_osd_string(&msg, CEC_OP_DISP_CTL_CLEAR, "");
-	fail_on_test(!transmit_timeout(node, &msg, 250));
-	fail_on_test(cec_msg_status_is_abort(&msg));
-	fail_on_test(!unsuitable && interactive && !question("Did the string appear?"));
-
 	node->remote[la].has_osd = true;
-	if (interactive)
-		return 0;
-	else
+	if (!interactive)
 		return PRESUMED_OK;
+
+	/* The CEC 1.4b CTS specifies that one should wait at least 20 seconds for the
+	   string to be cleared on the remote device */
+	interactive_info(true, "Waiting 20s for OSD string to be cleared on the remote device");
+	sleep(20);
+	fail_on_test(!unsuitable && interactive && !question("Did the string appear and then disappear?"));
+
+	return 0;
 }
 
 static int osd_string_set_until_clear(struct node *node, unsigned me, unsigned la, bool interactive)
@@ -411,7 +407,7 @@ static int osd_string_set_until_clear(struct node *node, unsigned me, unsigned l
 	cec_msg_init(&msg, me, la);
 	cec_msg_set_osd_string(&msg, CEC_OP_DISP_CTL_UNTIL_CLEARED, osd);
 	fail_on_test(!transmit(node, &msg));
-	if (cec_msg_status_is_abort(&msg) && abort_reason(&msg) != CEC_OP_ABORT_UNRECOGNIZED_OP) {
+	if (cec_msg_status_is_abort(&msg) && !unrecognized_op(&msg)) {
 		warn("The device is in an unsuitable state or cannot display the complete message.\n");
 		unsuitable = true;
 	}
-- 
2.7.4

