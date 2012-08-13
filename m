Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59524 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab2HMC16 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 22:27:58 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] rtl28xxu: generalize streaming control
Date: Mon, 13 Aug 2012 05:27:08 +0300
Message-Id: <1344824828-2207-2-git-send-email-crope@iki.fi>
In-Reply-To: <1344824828-2207-1-git-send-email-crope@iki.fi>
References: <1344824828-2207-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move rtl2831u LED from streaming control to power control. It
changes LED behavior slightly but who cares :)
After that same streaming control can be used for both rtl2831u
and rtl2832u.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb-v2/rtl28xxu.c | 44 ++++-----------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/rtl28xxu.c b/drivers/media/dvb/dvb-usb-v2/rtl28xxu.c
index 493d531..a2d1e5b 100644
--- a/drivers/media/dvb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb-v2/rtl28xxu.c
@@ -823,43 +823,7 @@ err:
 	return ret;
 }
 
-static int rtl2831u_streaming_ctrl(struct dvb_frontend *fe , int onoff)
-{
-	int ret;
-	u8 buf[2], gpio;
-	struct dvb_usb_device *d = fe_to_d(fe);
-
-	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
-
-	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &gpio);
-	if (ret)
-		goto err;
-
-	if (onoff) {
-		buf[0] = 0x00;
-		buf[1] = 0x00;
-		gpio |= 0x04; /* LED on */
-	} else {
-		buf[0] = 0x10; /* stall EPA */
-		buf[1] = 0x02; /* reset EPA */
-		gpio &= (~0x04); /* LED off */
-	}
-
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, gpio);
-	if (ret)
-		goto err;
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
-static int rtl2832u_streaming_ctrl(struct dvb_frontend *fe , int onoff)
+static int rtl28xxu_streaming_ctrl(struct dvb_frontend *fe , int onoff)
 {
 	int ret;
 	u8 buf[2];
@@ -908,11 +872,13 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	if (onoff) {
 		gpio |= 0x01; /* GPIO0 = 1 */
 		gpio &= (~0x10); /* GPIO4 = 0 */
+		gpio |= 0x04; /* GPIO2 = 1, LED on */
 		sys0 = sys0 & 0x0f;
 		sys0 |= 0xe0;
 	} else {
 		gpio &= (~0x01); /* GPIO0 = 0 */
 		gpio |= 0x10; /* GPIO4 = 1 */
+		gpio &= (~0x04); /* GPIO2 = 1, LED off */
 		sys0 = sys0 & (~0xc0);
 	}
 
@@ -1224,7 +1190,7 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 	.tuner_attach = rtl2831u_tuner_attach,
 	.init = rtl28xxu_init,
 	.get_rc_config = rtl2831u_get_rc_config,
-	.streaming_ctrl = rtl2831u_streaming_ctrl,
+	.streaming_ctrl = rtl28xxu_streaming_ctrl,
 
 	.num_adapters = 1,
 	.adapter = {
@@ -1246,7 +1212,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.tuner_attach = rtl2832u_tuner_attach,
 	.init = rtl28xxu_init,
 	.get_rc_config = rtl2832u_get_rc_config,
-	.streaming_ctrl = rtl2832u_streaming_ctrl,
+	.streaming_ctrl = rtl28xxu_streaming_ctrl,
 
 	.num_adapters = 1,
 	.adapter = {
-- 
1.7.11.2

