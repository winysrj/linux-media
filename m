Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59924 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaJULHn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:43 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 05/13] [media] s5p-mfc: keep RISC ON during reset for V7/V8
Date: Tue, 21 Oct 2014 16:36:59 +0530
Message-Id: <1413889627-8431-6-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kiran AVND <avnd.kiran@samsung.com>

Reset sequence for MFC V7 and V8 do not need RISC_ON
to be set to 0, while for MFC V6 it is still needed.

Also, remove a couple of register settings during Reset
which are not needed from V6 onwards.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   25 ++++++++++++++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 3e41ca1..5b0c334 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -340,6 +340,7 @@ struct s5p_mfc_dev {
 	struct s5p_mfc_hw_cmds *mfc_cmds;
 	const struct s5p_mfc_regs *mfc_regs;
 	enum s5p_mfc_fw_ver fw_ver;
+	bool risc_on; /* indicates if RISC is on or off */
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 0c885a8..f5bb6b2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -139,12 +139,6 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 	mfc_debug_enter();
 
 	if (IS_MFCV6_PLUS(dev)) {
-		/* Reset IP */
-		/*  except RISC, reset */
-		mfc_write(dev, 0xFEE, S5P_FIMV_MFC_RESET_V6);
-		/*  reset release */
-		mfc_write(dev, 0x0, S5P_FIMV_MFC_RESET_V6);
-
 		/* Zero Initialization of MFC registers */
 		mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD_V6);
 		mfc_write(dev, 0, S5P_FIMV_HOST2RISC_CMD_V6);
@@ -153,8 +147,13 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 		for (i = 0; i < S5P_FIMV_REG_CLEAR_COUNT_V6; i++)
 			mfc_write(dev, 0, S5P_FIMV_REG_CLEAR_BEGIN_V6 + (i*4));
 
-		/* Reset */
-		mfc_write(dev, 0, S5P_FIMV_RISC_ON_V6);
+		/* Reset
+		 * set RISC_ON to 0 during power_on & wake_up.
+		 * V6 needs RISC_ON set to 0 during reset also.
+		 */
+		if ((!dev->risc_on) || (!IS_MFCV7(dev)))
+			mfc_write(dev, 0, S5P_FIMV_RISC_ON_V6);
+
 		mfc_write(dev, 0x1FFF, S5P_FIMV_MFC_RESET_V6);
 		mfc_write(dev, 0, S5P_FIMV_MFC_RESET_V6);
 	} else {
@@ -226,6 +225,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	/* 0. MFC reset */
 	mfc_debug(2, "MFC reset..\n");
 	s5p_mfc_clock_on();
+	dev->risc_on = 0;
 	ret = s5p_mfc_reset(dev);
 	if (ret) {
 		mfc_err("Failed to reset MFC - timeout\n");
@@ -238,8 +238,10 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clear_cmds(dev);
 	/* 3. Release reset signal to the RISC */
 	s5p_mfc_clean_dev_int_flags(dev);
-	if (IS_MFCV6_PLUS(dev))
+	if (IS_MFCV6_PLUS(dev)) {
+		dev->risc_on = 1;
 		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
+	}
 	else
 		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Will now wait for completion of firmware transfer\n");
@@ -336,6 +338,7 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 	/* 0. MFC reset */
 	mfc_debug(2, "MFC reset..\n");
 	s5p_mfc_clock_on();
+	dev->risc_on = 0;
 	ret = s5p_mfc_reset(dev);
 	if (ret) {
 		mfc_err("Failed to reset MFC - timeout\n");
@@ -354,8 +357,10 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 		return ret;
 	}
 	/* 4. Release reset signal to the RISC */
-	if (IS_MFCV6_PLUS(dev))
+	if (IS_MFCV6_PLUS(dev)) {
+		dev->risc_on = 1;
 		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
+	}
 	else
 		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Ok, now will write a command to wakeup the system\n");
-- 
1.7.9.5

