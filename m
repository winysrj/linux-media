Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37082 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaJULHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:52 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 06/13] [media] s5p-mfc: check mfc bus ctrl before reset
Date: Tue, 21 Oct 2014 16:37:00 +0530
Message-Id: <1413889627-8431-7-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kiran AVND <avnd.kiran@samsung.com>

during reset sequence, it is advisable to follow the below
sequence, in order to avoid unexpected behavior from MFC
. set SFR 0x7110 MFC_BUS_RESET_CTRL 0x1
  // wait for REQ_STATUS to be 1
. get SFR 0x7110 MFC_BUS_RESET_CTRL 0x3
  // reset now

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h  |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |   25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

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
index f5bb6b2..0d3661b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -129,6 +129,25 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
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
@@ -147,11 +166,15 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
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
1.7.9.5

