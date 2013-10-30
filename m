Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33314 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab3J3FlS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 01:41:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] rtl28xxu: add RTL2832P + R828D support
Date: Wed, 30 Oct 2013 07:40:35 +0200
Message-Id: <1383111636-19743-3-git-send-email-crope@iki.fi>
In-Reply-To: <1383111636-19743-1-git-send-email-crope@iki.fi>
References: <1383111636-19743-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RTL2832P is version of RTL2832U with extra TS interface.
As for now, we support only integrated RTL2832 demod.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 39 +++++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  1 +
 2 files changed, 40 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c0cd084..8c600b7 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -377,6 +377,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_e4000 = {0x02c8, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
 	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_r828d = {0x0074, CMD_I2C_RD, 1, buf};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -489,6 +490,15 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 		goto found;
 	}
 
+	/* check R828D ID register; reg=00 val=69 */
+	ret = rtl28xxu_ctrl_msg(d, &req_r828d);
+	if (ret == 0 && buf[0] == 0x69) {
+		priv->tuner = TUNER_RTL2832_R828D;
+		priv->tuner_name = "R828D";
+		goto found;
+	}
+
+
 found:
 	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
 
@@ -745,6 +755,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		rtl2832_config = &rtl28xxu_rtl2832_e4000_config;
 		break;
 	case TUNER_RTL2832_R820T:
+	case TUNER_RTL2832_R828D:
 		rtl2832_config = &rtl28xxu_rtl2832_r820t_config;
 		break;
 	default:
@@ -866,6 +877,13 @@ static const struct r820t_config rtl2832u_r820t_config = {
 	.rafael_chip = CHIP_R820T,
 };
 
+static const struct r820t_config rtl2832u_r828d_config = {
+	.i2c_addr = 0x3a,
+	.xtal = 16000000,
+	.max_i2c_msg_len = 2,
+	.rafael_chip = CHIP_R828D,
+};
+
 static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -923,6 +941,27 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		break;
+	case TUNER_RTL2832_R828D:
+		/* power off mn88472 demod on GPIO0 */
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x00, 0x01);
+		if (ret)
+			goto err;
+
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x01);
+		if (ret)
+			goto err;
+
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x01, 0x01);
+		if (ret)
+			goto err;
+
+		fe = dvb_attach(r820t_attach, adap->fe[0], &d->i2c_adap,
+				&rtl2832u_r828d_config);
+
+		/* Use tuner to get the signal strength */
+		adap->fe[0]->ops.read_signal_strength =
+				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+		break;
 	default:
 		fe = NULL;
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 729b354..2142bcb 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -83,6 +83,7 @@ enum rtl28xxu_tuner {
 	TUNER_RTL2832_TDA18272,
 	TUNER_RTL2832_FC0013,
 	TUNER_RTL2832_R820T,
+	TUNER_RTL2832_R828D,
 };
 
 struct rtl28xxu_req {
-- 
1.8.3.1

