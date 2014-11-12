Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43032 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbaKLEXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:23:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] rtl28xxu: enable demod ADC only when needed
Date: Wed, 12 Nov 2014 06:23:05 +0200
Message-Id: <1415766190-24482-4-git-send-email-crope@iki.fi>
In-Reply-To: <1415766190-24482-1-git-send-email-crope@iki.fi>
References: <1415766190-24482-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable integrated demod ADC only when demod is used. Keep integrated
demod ADC disabled when external demod is used. This fixes corrupted
stream in a case external demod was used.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 37 ++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 27b1e03..5ea52c7 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1201,13 +1201,6 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret)
 			goto err;
 
-		mdelay(5);
-
-		/* enable ADC */
-		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x48, 0x48);
-		if (ret)
-			goto err;
-
 		/* streaming EP: clear stall & reset */
 		ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x00\x00", 2);
 		if (ret)
@@ -1222,11 +1215,6 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret)
 			goto err;
 
-		/* disable ADC */
-		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x00, 0x48);
-		if (ret)
-			goto err;
-
 		/* disable PLL */
 		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x00, 0x80);
 		if (ret)
@@ -1244,6 +1232,30 @@ err:
 	return ret;
 }
 
+static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	int ret;
+	u8 val;
+
+	dev_dbg(&d->udev->dev, "%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
+
+	/* control internal demod ADC */
+	if (fe->id == 0 && onoff)
+		val = 0x48; /* enable ADC */
+	else
+		val = 0x00; /* disable ADC */
+
+	ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, val, 0x48);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
 #if IS_ENABLED(CONFIG_RC_CORE)
 static int rtl2831u_rc_query(struct dvb_usb_device *d)
 {
@@ -1467,6 +1479,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.size_of_priv = sizeof(struct rtl28xxu_priv),
 
 	.power_ctrl = rtl2832u_power_ctrl,
+	.frontend_ctrl = rtl2832u_frontend_ctrl,
 	.i2c_algo = &rtl28xxu_i2c_algo,
 	.read_config = rtl2832u_read_config,
 	.frontend_attach = rtl2832u_frontend_attach,
-- 
http://palosaari.fi/

