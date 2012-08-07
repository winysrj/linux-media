Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab2HGCr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:57 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:57 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 11/24] xc5000: don't invoke auto calibration unless we really did reset tuner
Date: Mon,  6 Aug 2012 22:47:01 -0400
Message-Id: <1344307634-11673-12-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code invokes the auto calibration of the tuner whenever the
init routine is called (whenever the DVB frontend opens the device).
However we should really only be invoking the calibration if we actually
did reset the device and reload the firmware.

Rework the routine to only do calibration if reset and firmware load was
performed.  Also because the called function is now a no-op if the firmware
is already loaded, the caller no longer needs to invoke is_firmware_loaded().

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |   40 +++++++++++++++------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index a7fa17e..1cfaa7c 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -715,11 +715,9 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	u32 freq = fe->dtv_property_cache.frequency;
 	u32 delsys  = fe->dtv_property_cache.delivery_system;
 
-	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
-		if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
-			dprintk(1, "Unable to load firmware and init tuner\n");
-			return -EINVAL;
-		}
+	if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
+		dprintk(1, "Unable to load firmware and init tuner\n");
+		return -EINVAL;
 	}
 
 	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, freq);
@@ -994,11 +992,9 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 	if (priv->i2c_props.adap == NULL)
 		return -EINVAL;
 
-	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
-		if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
-			dprintk(1, "Unable to load firmware and init tuner\n");
-			return -EINVAL;
-		}
+	if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
+		dprintk(1, "Unable to load firmware and init tuner\n");
+		return -EINVAL;
 	}
 
 	switch (params->mode) {
@@ -1057,26 +1053,26 @@ static int xc5000_get_status(struct dvb_frontend *fe, u32 *status)
 static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	int ret = 0;
+	int ret = XC_RESULT_SUCCESS;
 
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		ret = xc5000_fwupload(fe);
 		if (ret != XC_RESULT_SUCCESS)
 			return ret;
-	}
 
-	/* Start the tuner self-calibration process */
-	ret |= xc_initialize(priv);
+		/* Start the tuner self-calibration process */
+		ret |= xc_initialize(priv);
 
-	/* Wait for calibration to complete.
-	 * We could continue but XC5000 will clock stretch subsequent
-	 * I2C transactions until calibration is complete.  This way we
-	 * don't have to rely on clock stretching working.
-	 */
-	xc_wait(100);
+		/* Wait for calibration to complete.
+		 * We could continue but XC5000 will clock stretch subsequent
+		 * I2C transactions until calibration is complete.  This way we
+		 * don't have to rely on clock stretching working.
+		 */
+		xc_wait(100);
 
-	/* Default to "CABLE" mode */
-	ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
+		/* Default to "CABLE" mode */
+		ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
+	}
 
 	return ret;
 }
-- 
1.7.1

