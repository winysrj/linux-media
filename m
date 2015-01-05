Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50758 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbbAEWio (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 17:38:44 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so4256236wiv.11
        for <linux-media@vger.kernel.org>; Mon, 05 Jan 2015 14:38:43 -0800 (PST)
From: Haim Daniel <haimdaniel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Haim Daniel <haim.daniel@gmail.com>
Subject: [PATCH] [media] [pvrusb2]: remove dead retry cmd code
Date: Tue,  6 Jan 2015 00:38:38 +0200
Message-Id: <1420497518-10375-1-git-send-email-haim.daniel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case a command is timed out, current flow sets the retry_flag
and does nothing.

Signed-off-by: Haim Daniel <haim.daniel@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
index f7702ae..02028aa 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
@@ -145,8 +145,6 @@ static int pvr2_encoder_cmd(void *ctxt,
 			    u32 *argp)
 {
 	unsigned int poll_count;
-	unsigned int try_count = 0;
-	int retry_flag;
 	int ret = 0;
 	unsigned int idx;
 	/* These sizes look to be limited by the FX2 firmware implementation */
@@ -213,8 +211,6 @@ static int pvr2_encoder_cmd(void *ctxt,
 			break;
 		}
 
-		retry_flag = 0;
-		try_count++;
 		ret = 0;
 		wrData[0] = 0;
 		wrData[1] = cmd;
@@ -245,11 +241,9 @@ static int pvr2_encoder_cmd(void *ctxt,
 			}
 			if (rdData[0] && (poll_count < 1000)) continue;
 			if (!rdData[0]) {
-				retry_flag = !0;
 				pvr2_trace(
 					PVR2_TRACE_ERROR_LEGS,
-					"Encoder timed out waiting for us"
-					"; arranging to retry");
+					"Encoder timed out waiting for us");
 			} else {
 				pvr2_trace(
 					PVR2_TRACE_ERROR_LEGS,
@@ -269,13 +263,6 @@ static int pvr2_encoder_cmd(void *ctxt,
 			ret = -EBUSY;
 			break;
 		}
-		if (retry_flag) {
-			if (try_count < 20) continue;
-			pvr2_trace(
-				PVR2_TRACE_ERROR_LEGS,
-				"Too many retries...");
-			ret = -EBUSY;
-		}
 		if (ret) {
 			del_timer_sync(&hdw->encoder_run_timer);
 			hdw->state_encoder_ok = 0;
-- 
1.9.3

