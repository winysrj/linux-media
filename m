Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35368 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab2IQC1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 22:27:25 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] af9035: implement TUA9001 GPIOs correctly
Date: Mon, 17 Sep 2012 05:26:56 +0300
Message-Id: <1347848817-18607-2-git-send-email-crope@iki.fi>
In-Reply-To: <1347848817-18607-1-git-send-email-crope@iki.fi>
References: <1347848817-18607-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 65 ++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 89cc901..84b3b27 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -583,6 +583,52 @@ err:
 	return ret;
 }
 
+static int af9035_tua9001_tuner_callback(struct dvb_usb_device *d,
+		int cmd, int arg)
+{
+	int ret;
+	u8 val;
+
+	dev_dbg(&d->udev->dev, "%s: cmd=%d arg=%d\n", __func__, cmd, arg);
+
+	/*
+	 * CEN     always enabled by hardware wiring
+	 * RESETN  GPIOT3
+	 * RXEN    GPIOT2
+	 */
+
+	switch (cmd) {
+	case TUA9001_CMD_RESETN:
+		if (arg)
+			val = 0x00;
+		else
+			val = 0x01;
+
+		ret = af9035_wr_reg_mask(d, 0x00d8e7, val, 0x01);
+		if (ret < 0)
+			goto err;
+		break;
+	case TUA9001_CMD_RXEN:
+		if (arg)
+			val = 0x01;
+		else
+			val = 0x00;
+
+		ret = af9035_wr_reg_mask(d, 0x00d8eb, val, 0x01);
+		if (ret < 0)
+			goto err;
+		break;
+	}
+
+	return 0;
+
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
+
 static int af9035_fc0011_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -655,6 +701,8 @@ static int af9035_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 	switch (state->af9033_config[0].tuner) {
 	case AF9033_TUNER_FC0011:
 		return af9035_fc0011_tuner_callback(d, cmd, arg);
+	case AF9033_TUNER_TUA9001:
+		return af9035_tua9001_tuner_callback(d, cmd, arg);
 	default:
 		break;
 	}
@@ -779,23 +827,6 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		if (ret < 0)
 			goto err;
 
-		/* reset tuner */
-		ret = af9035_wr_reg_mask(d, 0x00d8e7, 0x00, 0x01);
-		if (ret < 0)
-			goto err;
-
-		usleep_range(2000, 20000);
-
-		ret = af9035_wr_reg_mask(d, 0x00d8e7, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
-
-		/* activate tuner RX */
-		/* TODO: use callback for TUA9001 RXEN */
-		ret = af9035_wr_reg_mask(d, 0x00d8eb, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
-
 		/* attach tuner */
 		fe = dvb_attach(tua9001_attach, adap->fe[0],
 				&d->i2c_adap, &af9035_tua9001_config);
-- 
1.7.11.4

