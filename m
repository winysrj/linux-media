Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17402 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaIOGsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:48:55 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00JWQK9I7V60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:48:54 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 10/17] [media] s5p-mfc: modify mfc wakeup sequence for V8
Date: Mon, 15 Sep 2014 12:13:05 +0530
Message-id: <1410763393-12183-11-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arun Mankuzhi <arun.m@samsung.com>

>From MFC V8, the MFC wakeup sequence has changed.
MFC wakeup command has to be sent after the host receives
firmware load complete status from risc.

Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |   78 +++++++++++++++++++-----
 1 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 24d5252..8531c72 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -352,6 +352,58 @@ int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
 	return ret;
 }
 
+static int s5p_mfc_v8_wait_wakeup(struct s5p_mfc_dev *dev)
+{
+	int ret;
+
+	/* Release reset signal to the RISC */
+	dev->risc_on = 1;
+	mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
+
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_FW_STATUS_RET)) {
+		mfc_err("Failed to reset MFCV8\n");
+		return -EIO;
+	}
+	mfc_debug(2, "Write command to wakeup MFCV8\n");
+	ret = s5p_mfc_hw_call(dev->mfc_cmds, wakeup_cmd, dev);
+	if (ret) {
+		mfc_err("Failed to send command to MFCV8 - timeout\n");
+		return ret;
+	}
+
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
+		mfc_err("Failed to wakeup MFC\n");
+		return -EIO;
+	}
+	return ret;
+}
+
+static int s5p_mfc_wait_wakeup(struct s5p_mfc_dev *dev)
+{
+	int ret;
+
+	/* Send MFC wakeup command */
+	ret = s5p_mfc_hw_call(dev->mfc_cmds, wakeup_cmd, dev);
+	if (ret) {
+		mfc_err("Failed to send command to MFC - timeout\n");
+		return ret;
+	}
+
+	/* Release reset signal to the RISC */
+	if (IS_MFCV6_PLUS(dev)) {
+		dev->risc_on = 1;
+		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
+	} else {
+		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
+	}
+
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
+		mfc_err("Failed to wakeup MFC\n");
+		return -EIO;
+	}
+	return ret;
+}
+
 int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 {
 	int ret;
@@ -364,6 +416,7 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 	ret = s5p_mfc_reset(dev);
 	if (ret) {
 		mfc_err("Failed to reset MFC - timeout\n");
+		s5p_mfc_clock_off();
 		return ret;
 	}
 	mfc_debug(2, "Done MFC reset..\n");
@@ -372,25 +425,16 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 	/* 2. Initialize registers of channel I/F */
 	s5p_mfc_clear_cmds(dev);
 	s5p_mfc_clean_dev_int_flags(dev);
-	/* 3. Initialize firmware */
-	ret = s5p_mfc_hw_call(dev->mfc_cmds, wakeup_cmd, dev);
-	if (ret) {
-		mfc_err("Failed to send command to MFC - timeout\n");
-		return ret;
-	}
-	/* 4. Release reset signal to the RISC */
-	if (IS_MFCV6_PLUS(dev)) {
-		dev->risc_on = 1;
-		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
-	}
+	/* 3. Send MFC wakeup command and wait for completion*/
+	if (IS_MFCV8(dev))
+		ret = s5p_mfc_v8_wait_wakeup(dev);
 	else
-		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
-	mfc_debug(2, "Ok, now will write a command to wakeup the system\n");
-	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
-		mfc_err("Failed to load firmware\n");
-		return -EIO;
-	}
+		ret = s5p_mfc_wait_wakeup(dev);
+
 	s5p_mfc_clock_off();
+	if (ret)
+		return ret;
+
 	dev->int_cond = 0;
 	if (dev->int_err != 0 || dev->int_type !=
 						S5P_MFC_R2H_CMD_WAKEUP_RET) {
-- 
1.7.3.rc2

