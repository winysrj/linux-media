Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51497 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 29/66] rtl28xxu: use platform data config for rtl2832 demod
Date: Tue, 23 Dec 2014 22:49:22 +0200
Message-Id: <1419367799-14263-29-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use platform data configuration for rtl2832 demod driver. Old
configuration are still left as it is used for rtl2832_sdr driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 38 +++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 3d619de..25c885f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -637,6 +637,32 @@ err:
 	return ret;
 }
 
+static const struct rtl2832_platform_data rtl2832_fc0012_platform_data = {
+	.clk = 28800000,
+	.tuner = TUNER_RTL2832_FC0012
+};
+
+static const struct rtl2832_platform_data rtl2832_fc0013_platform_data = {
+	.clk = 28800000,
+	.tuner = TUNER_RTL2832_FC0013
+};
+
+static const struct rtl2832_platform_data rtl2832_tua9001_platform_data = {
+	.clk = 28800000,
+	.tuner = TUNER_RTL2832_TUA9001,
+};
+
+static const struct rtl2832_platform_data rtl2832_e4000_platform_data = {
+	.clk = 28800000,
+	.tuner = TUNER_RTL2832_E4000,
+};
+
+static const struct rtl2832_platform_data rtl2832_r820t_platform_data = {
+	.clk = 28800000,
+	.tuner = TUNER_RTL2832_R820T,
+};
+
+/* TODO: these are redundant information for rtl2832_sdr driver */
 static const struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
@@ -793,24 +819,24 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 	switch (priv->tuner) {
 	case TUNER_RTL2832_FC0012:
-		pdata->config = &rtl28xxu_rtl2832_fc0012_config;
+		*pdata = rtl2832_fc0012_platform_data;
 		break;
 	case TUNER_RTL2832_FC0013:
-		pdata->config = &rtl28xxu_rtl2832_fc0013_config;
+		*pdata = rtl2832_fc0013_platform_data;
 		break;
 	case TUNER_RTL2832_FC2580:
 		/* FIXME: do not abuse fc0012 settings */
-		pdata->config = &rtl28xxu_rtl2832_fc0012_config;
+		*pdata = rtl2832_fc0012_platform_data;
 		break;
 	case TUNER_RTL2832_TUA9001:
-		pdata->config = &rtl28xxu_rtl2832_tua9001_config;
+		*pdata = rtl2832_tua9001_platform_data;
 		break;
 	case TUNER_RTL2832_E4000:
-		pdata->config = &rtl28xxu_rtl2832_e4000_config;
+		*pdata = rtl2832_e4000_platform_data;
 		break;
 	case TUNER_RTL2832_R820T:
 	case TUNER_RTL2832_R828D:
-		pdata->config = &rtl28xxu_rtl2832_r820t_config;
+		*pdata = rtl2832_r820t_platform_data;
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
-- 
http://palosaari.fi/

