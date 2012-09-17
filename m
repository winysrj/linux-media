Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35463 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab2IQU6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:58:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/7] rtl28xxu: use proper config for e4000 tuner
Date: Mon, 17 Sep 2012 23:58:12 +0300
Message-Id: <1347915492-24924-7-git-send-email-crope@iki.fi>
In-Reply-To: <1347915492-24924-1-git-send-email-crope@iki.fi>
References: <1347915492-24924-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not abuse anymore fc0012 tuner config.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index dd2a788..843eeaf 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -583,6 +583,12 @@ static struct rtl2832_config rtl28xxu_rtl2832_tua9001_config = {
 	.tuner = TUNER_RTL2832_TUA9001,
 };
 
+static struct rtl2832_config rtl28xxu_rtl2832_e4000_config = {
+	.i2c_addr = 0x10, /* 0x20 */
+	.xtal = 28800000,
+	.tuner = TUNER_RTL2832_E4000,
+};
+
 static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -720,8 +726,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		rtl2832_config = &rtl28xxu_rtl2832_tua9001_config;
 		break;
 	case TUNER_RTL2832_E4000:
-		/* FIXME: do not abuse fc0012 settings */
-		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		rtl2832_config = &rtl28xxu_rtl2832_e4000_config;
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
-- 
1.7.11.4

