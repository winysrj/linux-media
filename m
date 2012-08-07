Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2HGCsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:05 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:05 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 18/24] xc5000: reset device if encountering PLL lock failure
Date: Mon,  6 Aug 2012 22:47:08 -0400
Message-Id: <1344307634-11673-19-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's possible for the xc5000 to enter an unknown state such that all
subsequent tuning requests fail.  The only way to recover is to reset the
tuner and reload the firmware.  This problem was detected after several days
straight of issuing tuning requests every five seconds.

Reset the firmware in the event that the PLL is in an unlocked state.  This
solution was provided by the engineer at CrestaTech (the company that acquired
Xceive).

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |   58 ++++++++++++++++++++++++++++++---
 1 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 1cfaa7c..7c36465 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -62,6 +62,7 @@ struct xc5000_priv {
 	u8  radio_input;
 
 	int chip_id;
+	u16 pll_register_no;
 };
 
 /* Misc Defines */
@@ -209,16 +210,19 @@ static struct XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
 struct xc5000_fw_cfg {
 	char *name;
 	u16 size;
+	u16 pll_reg;
 };
 
 static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
 	.name = "dvb-fe-xc5000-1.6.114.fw",
 	.size = 12401,
+	.pll_reg = 0x806c,
 };
 
 static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
 	.name = "dvb-fe-xc5000c-41.024.5.fw",
 	.size = 16497,
+	.pll_reg = 0x13,
 };
 
 static inline const struct xc5000_fw_cfg *xc5000_assign_firmware(int chip_id)
@@ -232,7 +236,7 @@ static inline const struct xc5000_fw_cfg *xc5000_assign_firmware(int chip_id)
 	}
 }
 
-static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe);
+static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force);
 static int xc5000_is_firmware_loaded(struct dvb_frontend *fe);
 static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val);
 static int xc5000_TunerReset(struct dvb_frontend *fe);
@@ -617,6 +621,7 @@ static int xc5000_fwupload(struct dvb_frontend *fe)
 	int ret;
 	const struct xc5000_fw_cfg *desired_fw =
 		xc5000_assign_firmware(priv->chip_id);
+	priv->pll_register_no = desired_fw->pll_reg;
 
 	/* request the firmware, this will block and timeout */
 	printk(KERN_INFO "xc5000: waiting for firmware upload (%s)...\n",
@@ -666,6 +671,7 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	u8 hw_majorversion = 0, hw_minorversion = 0;
 	u8 fw_majorversion = 0, fw_minorversion = 0;
 	u16 fw_buildversion = 0;
+	u16 regval;
 
 	/* Wait for stats to stabilize.
 	 * Frame Lines needs two frame times after initial lock
@@ -705,6 +711,11 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	xc_get_totalgain(priv,  &totalgain);
 	dprintk(1, "*** Total gain = %d.%d dB\n", totalgain / 256,
 		(totalgain % 256) * 100 / 256);
+
+	if (priv->pll_register_no) {
+		xc5000_readreg(priv, priv->pll_register_no, &regval);
+		dprintk(1, "*** PLL lock status = 0x%04x\n", regval);
+	}
 }
 
 static int xc5000_set_params(struct dvb_frontend *fe)
@@ -715,7 +726,7 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	u32 freq = fe->dtv_property_cache.frequency;
 	u32 delsys  = fe->dtv_property_cache.delivery_system;
 
-	if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
+	if (xc_load_fw_and_init_tuner(fe, 0) != XC_RESULT_SUCCESS) {
 		dprintk(1, "Unable to load firmware and init tuner\n");
 		return -EINVAL;
 	}
@@ -842,6 +853,7 @@ static int xc5000_set_tv_freq(struct dvb_frontend *fe,
 	struct analog_parameters *params)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
+	u16 pll_lock_status;
 	int ret;
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
@@ -922,6 +934,21 @@ tune_channel:
 	if (debug)
 		xc_debug_dump(priv);
 
+	if (priv->pll_register_no != 0) {
+		msleep(20);
+		xc5000_readreg(priv, priv->pll_register_no, &pll_lock_status);
+		if (pll_lock_status > 63) {
+			/* PLL is unlocked, force reload of the firmware */
+			dprintk(1, "xc5000: PLL not locked (0x%x).  Reloading...\n",
+				pll_lock_status);
+			if (xc_load_fw_and_init_tuner(fe, 1) != XC_RESULT_SUCCESS) {
+				printk(KERN_ERR "xc5000: Unable to reload fw\n");
+				return -EREMOTEIO;
+			}
+			goto tune_channel;
+		}
+	}
+
 	return 0;
 }
 
@@ -992,7 +1019,7 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 	if (priv->i2c_props.adap == NULL)
 		return -EINVAL;
 
-	if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
+	if (xc_load_fw_and_init_tuner(fe, 0) != XC_RESULT_SUCCESS) {
 		dprintk(1, "Unable to load firmware and init tuner\n");
 		return -EINVAL;
 	}
@@ -1050,19 +1077,28 @@ static int xc5000_get_status(struct dvb_frontend *fe, u32 *status)
 	return 0;
 }
 
-static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
+static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = XC_RESULT_SUCCESS;
+	u16 pll_lock_status;
+
+	if (force || xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
+
+fw_retry:
 
-	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		ret = xc5000_fwupload(fe);
 		if (ret != XC_RESULT_SUCCESS)
 			return ret;
 
+		msleep(20);
+
 		/* Start the tuner self-calibration process */
 		ret |= xc_initialize(priv);
 
+		if (ret != XC_RESULT_SUCCESS)
+			goto fw_retry;
+
 		/* Wait for calibration to complete.
 		 * We could continue but XC5000 will clock stretch subsequent
 		 * I2C transactions until calibration is complete.  This way we
@@ -1070,6 +1106,16 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 		 */
 		xc_wait(100);
 
+		if (priv->pll_register_no) {
+			xc5000_readreg(priv, priv->pll_register_no,
+				       &pll_lock_status);
+			if (pll_lock_status > 63) {
+				/* PLL is unlocked, force reload of the firmware */
+				printk(KERN_ERR "xc5000: PLL not running after fwload.\n");
+				goto fw_retry;
+			}
+		}
+
 		/* Default to "CABLE" mode */
 		ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
 	}
@@ -1105,7 +1151,7 @@ static int xc5000_init(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	dprintk(1, "%s()\n", __func__);
 
-	if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
+	if (xc_load_fw_and_init_tuner(fe, 0) != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc5000: Unable to initialise tuner\n");
 		return -EREMOTEIO;
 	}
-- 
1.7.1

