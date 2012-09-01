Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52017 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab2IANzT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 09:55:19 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	poma <pomidorabelisima@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl28xxu: correct usb_clear_halt() usage
Date: Sat,  1 Sep 2012 16:54:43 +0300
Message-Id: <1346507683-3621-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not allowed to call usb_clear_halt() after urbs are submitted.
That causes oops sometimes. Move whole streaming_ctrl() logic to
power_ctrl() in order to avoid wrong usb_clear_halt() use. Also,
configuring streaming endpoint in streaming_ctrl() sounds like a
little bit wrong as it is aimed for control stream gate.

Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 55 +++++++++++++++------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index e29fca2..7d11c5d 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -825,37 +825,10 @@ err:
 	return ret;
 }
 
-static int rtl28xxu_streaming_ctrl(struct dvb_frontend *fe , int onoff)
-{
-	int ret;
-	u8 buf[2];
-	struct dvb_usb_device *d = fe_to_d(fe);
-
-	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
-
-	if (onoff) {
-		buf[0] = 0x00;
-		buf[1] = 0x00;
-		usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
-	} else {
-		buf[0] = 0x10; /* stall EPA */
-		buf[1] = 0x02; /* reset EPA */
-	}
-
-	ret = rtl28xx_wr_regs(d, USB_EPA_CTL, buf, 2);
-	if (ret)
-		goto err;
-
-	return ret;
-err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
 static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
-	u8 gpio, sys0;
+	u8 gpio, sys0, epa_ctl[2];
 
 	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
 
@@ -878,11 +851,15 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		gpio |= 0x04; /* GPIO2 = 1, LED on */
 		sys0 = sys0 & 0x0f;
 		sys0 |= 0xe0;
+		epa_ctl[0] = 0x00; /* clear stall */
+		epa_ctl[1] = 0x00; /* clear reset */
 	} else {
 		gpio &= (~0x01); /* GPIO0 = 0 */
 		gpio |= 0x10; /* GPIO4 = 1 */
 		gpio &= (~0x04); /* GPIO2 = 1, LED off */
 		sys0 = sys0 & (~0xc0);
+		epa_ctl[0] = 0x10; /* set stall */
+		epa_ctl[1] = 0x02; /* set reset */
 	}
 
 	dev_dbg(&d->udev->dev, "%s: WR SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__,
@@ -898,6 +875,14 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	if (ret)
 		goto err;
 
+	/* streaming EP: stall & reset */
+	ret = rtl28xx_wr_regs(d, USB_EPA_CTL, epa_ctl, 2);
+	if (ret)
+		goto err;
+
+	if (onoff)
+		usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
+
 	return ret;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
@@ -972,6 +957,14 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 			goto err;
 
 
+		/* streaming EP: clear stall & reset */
+		ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x00\x00", 2);
+		if (ret)
+			goto err;
+
+		ret = usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
+		if (ret)
+			goto err;
 	} else {
 		/* demod_ctl_1 */
 		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
@@ -1006,6 +999,10 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret)
 			goto err;
 
+		/* streaming EP: set stall & reset */
+		ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x10\x02", 2);
+		if (ret)
+			goto err;
 	}
 
 	return ret;
@@ -1182,7 +1179,6 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 	.tuner_attach = rtl2831u_tuner_attach,
 	.init = rtl28xxu_init,
 	.get_rc_config = rtl2831u_get_rc_config,
-	.streaming_ctrl = rtl28xxu_streaming_ctrl,
 
 	.num_adapters = 1,
 	.adapter = {
@@ -1204,7 +1200,6 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.tuner_attach = rtl2832u_tuner_attach,
 	.init = rtl28xxu_init,
 	.get_rc_config = rtl2832u_get_rc_config,
-	.streaming_ctrl = rtl28xxu_streaming_ctrl,
 
 	.num_adapters = 1,
 	.adapter = {
-- 
1.7.11.4

