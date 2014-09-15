Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62510 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaIOGsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:48:47 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00CW9K997G40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:48:45 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 08/17] [media] s5p-mfc: check mfc bus ctrl before reset
Date: Mon, 15 Sep 2014 12:13:03 +0530
Message-id: <1410763393-12183-9-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

during reset sequence, it is advisable to follow the below
sequence, in order to avoid unexpected behavior from MFC
. set SFR 0x7110 MFC_BUS_RESET_CTRL 0x1
  // wait for REQ_STATUS to be 1
. get SFR 0x7110 MFC_BUS_RESET_CTRL 0x3
  // reset now

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h  |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |   25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 51cb2dd..83e01f3 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -71,6 +71,7 @@
 #define S5P_FIMV_R2H_CMD_ENC_BUFFER_FUL_RET_V6	16
 #define S5P_FIMV_R2H_CMD_ERR_RET_V6		32
 
+#define S5P_FIMV_MFC_BUS_RESET_CTRL            0x7110
 #define S5P_FIMV_FW_VERSION_V6			0xf000
 
 #define S5P_FIMV_INSTANCE_ID_V6			0xf008
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 39258f3..24d5252 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -128,6 +128,25 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 	return 0;
 }
 
+int s5p_mfc_bus_reset(struct s5p_mfc_dev *dev)
+{
+	unsigned int status;
+	unsigned long timeout;
+
+	/* Reset */
+	mfc_write(dev, 0x1, S5P_FIMV_MFC_BUS_RESET_CTRL);
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+	/* Check bus status */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while resetting MFC.\n");
+			return -EIO;
+		}
+		status = mfc_read(dev, S5P_FIMV_MFC_BUS_RESET_CTRL);
+	} while ((status & 0x2) == 0);
+	return 0;
+}
+
 /* Reset the device */
 int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 {
@@ -146,11 +165,15 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 		for (i = 0; i < S5P_FIMV_REG_CLEAR_COUNT_V6; i++)
 			mfc_write(dev, 0, S5P_FIMV_REG_CLEAR_BEGIN_V6 + (i*4));
 
+		/* check bus reset control before reset */
+		if (dev->risc_on)
+			if (s5p_mfc_bus_reset(dev))
+				return -EIO;
 		/* Reset
 		 * set RISC_ON to 0 during power_on & wake_up.
 		 * V6 needs RISC_ON set to 0 during reset also.
 		 */
-		if ((!dev->risc_on) || (!IS_MFCV7(dev)))
+		if ((!dev->risc_on) || (!IS_MFCV7_PLUS(dev)))
 			mfc_write(dev, 0, S5P_FIMV_RISC_ON_V6);
 
 		mfc_write(dev, 0x1FFF, S5P_FIMV_MFC_RESET_V6);
-- 
1.7.3.rc2

