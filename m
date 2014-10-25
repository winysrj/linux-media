Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc3s19.hotmail.com ([65.55.116.94]:54575 "EHLO
	BLU004-OMC3S19.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbaJYURg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Oct 2014 16:17:36 -0400
Message-ID: <BLU437-SMTP74F4D6277B11F3F5F92D16BA900@phx.gbl>
From: Michael Krufky <mkrufky@hotmail.com>
To: linux-media <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/3] xc5000: add IF output level control
Date: Sat, 25 Oct 2014 16:17:22 -0400
In-Reply-To: <1414268243-29514-1-git-send-email-mkrufky@linuxtv.org>
References: <1414268243-29514-1-git-send-email-mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Richard Vollkommer <linux@hauppauge.com>

Adds control of the IF output level to the xc5000 tuner
configuration structure.  Increases the IF level to the
demodulator to fix failure to lock and picture breakup
issues (with the au8522 demodulator, in the case of the
Hauppauge HVR950Q).

This patch works with all XC5000 firmware versions.

Signed-off-by: Richard Vollkommer <linux@hauppauge.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>
---
 drivers/media/tuners/xc5000.c         | 14 +++++++++++++-
 drivers/media/tuners/xc5000.h         |  1 +
 drivers/media/usb/au0828/au0828-dvb.c |  2 ++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index fafff4c..cd55110 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -62,6 +62,7 @@ struct xc5000_priv {
 	unsigned int mode;
 	u8  rf_mode;
 	u8  radio_input;
+	u16  output_amp;
 
 	int chip_id;
 	u16 pll_register_no;
@@ -744,7 +745,9 @@ static int xc5000_tune_digital(struct dvb_frontend *fe)
 		return -EIO;
 	}
 
-	xc_write_reg(priv, XREG_OUTPUT_AMP, 0x8a);
+	dprintk(1, "%s() setting OUTPUT_AMP to 0x%x\n",
+		__func__, priv->output_amp);
+	xc_write_reg(priv, XREG_OUTPUT_AMP, priv->output_amp);
 
 	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
 
@@ -1358,6 +1361,9 @@ static int xc5000_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	if (p->radio_input)
 		priv->radio_input = p->radio_input;
 
+	if (p->output_amp)
+		priv->output_amp = p->output_amp;
+
 	return 0;
 }
 
@@ -1438,6 +1444,12 @@ struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 		   it can be overridden if this is a hybrid driver */
 		priv->chip_id = (cfg->chip_id) ? cfg->chip_id : 0;
 
+	/* don't override output_amp if it's already been set
+	   unless explicitly specified */
+	if ((priv->output_amp == 0) || (cfg->output_amp))
+		/* use default output_amp value if none specified */
+		priv->output_amp = (cfg->output_amp) ? cfg->output_amp : 0x8a;
+
 	/* Check if firmware has been loaded. It is possible that another
 	   instance of the driver has loaded the firmware.
 	 */
diff --git a/drivers/media/tuners/xc5000.h b/drivers/media/tuners/xc5000.h
index 7245cae..6aa534f 100644
--- a/drivers/media/tuners/xc5000.h
+++ b/drivers/media/tuners/xc5000.h
@@ -36,6 +36,7 @@ struct xc5000_config {
 	u32  if_khz;
 	u8   radio_input;
 	u16  xtal_khz;
+	u16  output_amp;
 
 	int chip_id;
 };
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 00ab156..c267d76 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -88,12 +88,14 @@ static struct xc5000_config hauppauge_xc5000a_config = {
 	.i2c_address      = 0x61,
 	.if_khz           = 6000,
 	.chip_id          = XC5000A,
+	.output_amp       = 0x8f,
 };
 
 static struct xc5000_config hauppauge_xc5000c_config = {
 	.i2c_address      = 0x61,
 	.if_khz           = 6000,
 	.chip_id          = XC5000C,
+	.output_amp       = 0x8f,
 };
 
 static struct mxl5007t_config mxl5007t_hvr950q_config = {
-- 
1.9.1

