Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:46065 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab0BLSWf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 13:22:35 -0500
Received: from kabelnet-194-166.juropnet.hu ([91.147.194.166])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1Ng07F-0005Bn-KA
	for linux-media@vger.kernel.org; Fri, 12 Feb 2010 19:19:53 +0100
Message-ID: <4B759D44.6090100@mailbox.hu>
Date: Fri, 12 Feb 2010 19:26:12 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu> <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu> <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>
In-Reply-To: <4B745781.2020408@mailbox.hu>
Content-Type: multipart/mixed;
 boundary="------------010102070808030704000208"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010102070808030704000208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here is another patch, with a few minor changes. It depends on the
previously posted patches, so those should be applied first.

--------------010102070808030704000208
Content-Type: text/x-patch;
 name="xc4000-3-28f5eca12bb0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000-3-28f5eca12bb0.patch"

diff -r -d -N -U4 v4l-dvb-28f5eca12bb0.old/linux/drivers/media/common/tuners/xc4000.c v4l-dvb-28f5eca12bb0/linux/drivers/media/common/tuners/xc4000.c
--- v4l-dvb-28f5eca12bb0.old/linux/drivers/media/common/tuners/xc4000.c	2010-02-12 19:14:24.000000000 +0100
+++ v4l-dvb-28f5eca12bb0/linux/drivers/media/common/tuners/xc4000.c	2010-02-12 19:20:35.000000000 +0100
@@ -256,8 +256,9 @@
 };
 
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val);
 static int xc4000_TunerReset(struct dvb_frontend *fe);
+static void xc_debug_dump(struct xc4000_priv *priv);
 
 static int xc_send_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
 {
 	struct i2c_msg msg = { .addr = priv->i2c_props.addr,
@@ -332,12 +333,14 @@
 		(i2c_sequence[index + 1] != 0xFF)) {
 		len = i2c_sequence[index] * 256 + i2c_sequence[index+1];
 		if (len == 0x0000) {
 			/* RESET command */
-			result = xc4000_TunerReset(fe);
 			index += 2;
+#if 0			/* not needed, as already called by check_firmware() */
+			result = xc4000_TunerReset(fe);
 			if (result != XC_RESULT_SUCCESS)
 				return result;
+#endif
 		} else if (len & 0x8000) {
 			/* WAIT command */
 			xc_wait(len & 0x7FFF);
 			index += 2;
@@ -472,14 +475,8 @@
 
 	return 0;
 }
 
-/* WAS THERE
-static int xc_get_buildversion(struct xc4000_priv *priv, u16 *buildrev)
-{
-	return xc4000_readreg(priv, XREG_BUILD, buildrev);
-}*/
-
 static int xc_get_hsync_freq(struct xc4000_priv *priv, u32 *hsync_freq_hz)
 {
 	u16 regData;
 	int result;
@@ -516,14 +513,12 @@
 	}
 	return lockState;
 }
 
-#define XC_TUNE_ANALOG  0
-#define XC_TUNE_DIGITAL 1
-static int xc_tune_channel(struct xc4000_priv *priv, u32 freq_hz, int mode)
+static int xc_tune_channel(struct xc4000_priv *priv, u32 freq_hz)
 {
-	int found = 0;
-	int result = 0;
+	int	found = 1;
+	int	result;
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
 	/* Don't complain when the request fails because of i2c stretching */
@@ -533,13 +528,23 @@
 
 	if (result != XC_RESULT_SUCCESS)
 		return 0;
 
-	if (mode == XC_TUNE_ANALOG) {
-		if (WaitForLock(priv) == 1)
-			found = 1;
+	/* wait for lock only in analog TV mode */
+	if ((priv->cur_fw.type & (FM | DTV6 | DTV7 | DTV78 | DTV8)) == 0) {
+		if (WaitForLock(priv) == 0)
+			found = 0;
 	}
 
+	/* Wait for stats to stabilize.
+	 * Frame Lines needs two frame times after initial lock
+	 * before it is valid.
+	 */
+	xc_wait(debug ? 100 : 10);
+
+	if (debug)
+		xc_debug_dump(priv);
+
 	return found;
 }
 
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val)
@@ -1108,17 +1113,8 @@
 	u16	quality;
 	u8	hw_majorversion = 0, hw_minorversion = 0;
 	u8	fw_majorversion = 0, fw_minorversion = 0;
 
-	if (!(priv->cur_fw.type & BASE))
-		return;
-
-	/* Wait for stats to stabilize.
-	 * Frame Lines needs two frame times after initial lock
-	 * before it is valid.
-	 */
-	xc_wait(100);
-
 	xc_get_ADC_Envelope(priv, &adc_envelope);
 	dprintk(1, "*** ADC envelope (0-1023) = %d\n", adc_envelope);
 
 	xc_get_frequency_error(priv, &freq_error_hz);
@@ -1269,12 +1265,10 @@
 			/* goto fail; */
 		}
 	}
 
-	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
+	xc_tune_channel(priv, priv->freq_hz);
 
-	if (debug)
-		xc_debug_dump(priv);
 	ret = 0;
 
 fail:
 	mutex_unlock(&priv->lock);
@@ -1470,12 +1464,10 @@
 			goto fail;
 		}
 	}
 
-	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
+	xc_tune_channel(priv, priv->freq_hz);
 
-	if (debug)
-		xc_debug_dump(priv);
 	ret = 0;
 
 fail:
 	mutex_unlock(&priv->lock);
@@ -1549,9 +1541,9 @@
 
 	mutex_lock(&priv->lock);
 
 	/* Avoid firmware reload on slow devices */
-	if (!no_poweroff && priv->cur_fw.type != XC_POWERED_DOWN) {
+	if (!no_poweroff && (priv->cur_fw.type & BASE) != 0) {
 		/* force reset and firmware reload */
 		priv->cur_fw.type = XC_POWERED_DOWN;
 
 		if (xc_write_reg(priv, XREG_POWER_DOWN, 0)
@@ -1560,8 +1552,9 @@
 			       "xc4000: %s() unable to shutdown tuner\n",
 			       __func__);
 			ret = -EREMOTEIO;
 		}
+		xc_wait(20);
 	}
 
 	mutex_unlock(&priv->lock);
 
@@ -1638,9 +1631,10 @@
 
 	instance = hybrid_tuner_request_state(struct xc4000_priv, priv,
 					      hybrid_tuner_instance_list,
 					      i2c, cfg->i2c_address, "xc4000");
-	priv->card_type = cfg->card_type;
+	if (cfg->card_type != XC4000_CARD_GENERIC)
+		priv->card_type = cfg->card_type;
 	switch (instance) {
 	case 0:
 		goto fail;
 		break;
@@ -1703,12 +1697,21 @@
 
 	memcpy(&fe->ops.tuner_ops, &xc4000_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 
+	if (instance == 1) {
+		int	ret;
+		mutex_lock(&priv->lock);
+		ret = xc4000_fwupload(fe);
+		mutex_unlock(&priv->lock);
+		if (ret != XC_RESULT_SUCCESS)
+			goto fail2;
+	}
+
 	return fe;
 fail:
 	mutex_unlock(&xc4000_list_mutex);
-
+fail2:
 	xc4000_release(fe);
 	return NULL;
 }
 EXPORT_SYMBOL(xc4000_attach);
diff -r -d -N -U4 v4l-dvb-28f5eca12bb0.old/linux/drivers/media/video/tuner-core.c v4l-dvb-28f5eca12bb0/linux/drivers/media/video/tuner-core.c
--- v4l-dvb-28f5eca12bb0.old/linux/drivers/media/video/tuner-core.c	2010-02-12 19:14:07.000000000 +0100
+++ v4l-dvb-28f5eca12bb0/linux/drivers/media/video/tuner-core.c	2010-02-12 19:15:07.000000000 +0100
@@ -441,8 +441,9 @@
 		break;
 	}
 	case TUNER_XC4000:
 	{
+		xc4000_cfg.card_type	  = XC4000_CARD_GENERIC;
 		xc4000_cfg.i2c_address	  = t->i2c->addr;
 		/* if_khz will be set when the digital dvb_attach() occurs */
 		xc4000_cfg.if_khz	  = 0;
 		if (!dvb_attach(xc4000_attach,

--------------010102070808030704000208--
