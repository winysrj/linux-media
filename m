Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab2HGCsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:06 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:06 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 19/24] xc5000: add support for firmware load check and init status
Date: Mon,  6 Aug 2012 22:47:09 -0400
Message-Id: <1344307634-11673-20-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The xc5000c and newer versions of the xc5000a firmware need minor revisions
to their initialization process.  Add support for validating the firmware
was properly loaded, as well as checking the init status after initialization.

Based on advice from CrestaTech support as well as xc5000 datasheet v2.3.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |   39 ++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 7c36465..3e5f8cd 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -63,6 +63,8 @@ struct xc5000_priv {
 
 	int chip_id;
 	u16 pll_register_no;
+	u8 init_status_supported;
+	u8 fw_checksum_supported;
 };
 
 /* Misc Defines */
@@ -113,6 +115,8 @@ struct xc5000_priv {
 #define XREG_BUSY         0x09
 #define XREG_BUILD        0x0D
 #define XREG_TOTALGAIN    0x0F
+#define XREG_FW_CHECKSUM  0x12
+#define XREG_INIT_STATUS  0x13
 
 /*
    Basic firmware description. This will remain with
@@ -211,6 +215,8 @@ struct xc5000_fw_cfg {
 	char *name;
 	u16 size;
 	u16 pll_reg;
+	u8 init_status_supported;
+	u8 fw_checksum_supported;
 };
 
 static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
@@ -223,6 +229,8 @@ static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
 	.name = "dvb-fe-xc5000c-41.024.5.fw",
 	.size = 16497,
 	.pll_reg = 0x13,
+	.init_status_supported = 1,
+	.fw_checksum_supported = 1,
 };
 
 static inline const struct xc5000_fw_cfg *xc5000_assign_firmware(int chip_id)
@@ -622,6 +630,8 @@ static int xc5000_fwupload(struct dvb_frontend *fe)
 	const struct xc5000_fw_cfg *desired_fw =
 		xc5000_assign_firmware(priv->chip_id);
 	priv->pll_register_no = desired_fw->pll_reg;
+	priv->init_status_supported = desired_fw->init_status_supported;
+	priv->fw_checksum_supported = desired_fw->fw_checksum_supported;
 
 	/* request the firmware, this will block and timeout */
 	printk(KERN_INFO "xc5000: waiting for firmware upload (%s)...\n",
@@ -1082,6 +1092,7 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = XC_RESULT_SUCCESS;
 	u16 pll_lock_status;
+	u16 fw_ck;
 
 	if (force || xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 
@@ -1093,6 +1104,21 @@ fw_retry:
 
 		msleep(20);
 
+		if (priv->fw_checksum_supported) {
+			if (xc5000_readreg(priv, XREG_FW_CHECKSUM, &fw_ck)
+			    != XC_RESULT_SUCCESS) {
+				dprintk(1, "%s() FW checksum reading failed.\n",
+					__func__);
+				goto fw_retry;
+			}
+
+			if (fw_ck == 0) {
+				dprintk(1, "%s() FW checksum failed = 0x%04x\n",
+					__func__, fw_ck);
+				goto fw_retry;
+			}
+		}
+
 		/* Start the tuner self-calibration process */
 		ret |= xc_initialize(priv);
 
@@ -1106,6 +1132,19 @@ fw_retry:
 		 */
 		xc_wait(100);
 
+		if (priv->init_status_supported) {
+			if (xc5000_readreg(priv, XREG_INIT_STATUS, &fw_ck) != XC_RESULT_SUCCESS) {
+				dprintk(1, "%s() FW failed reading init status.\n",
+					__func__);
+				goto fw_retry;
+			}
+
+			if (fw_ck == 0) {
+				dprintk(1, "%s() FW init status failed = 0x%04x\n", __func__, fw_ck);
+				goto fw_retry;
+			}
+		}
+
 		if (priv->pll_register_no) {
 			xc5000_readreg(priv, priv->pll_register_no,
 				       &pll_lock_status);
-- 
1.7.1

