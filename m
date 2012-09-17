Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58636 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab2IQU6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:58:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/7] rtl28xxu: masked reg write
Date: Mon, 17 Sep 2012 23:58:07 +0300
Message-Id: <1347915492-24924-2-git-send-email-crope@iki.fi>
In-Reply-To: <1347915492-24924-1-git-send-email-crope@iki.fi>
References: <1347915492-24924-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement masked register write and use it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 83 ++++++++++++++-------------------
 1 file changed, 36 insertions(+), 47 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index ca77e62..a1fe982 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -130,6 +130,26 @@ static int rtl28xx_rd_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
 	return rtl2831_rd_regs(d, reg, val, 1);
 }
 
+static int rtl28xx_wr_reg_mask(struct dvb_usb_device *d, u16 reg, u8 val,
+		u8 mask)
+{
+	int ret;
+	u8 tmp;
+
+	/* no need for read if whole reg is written */
+	if (mask != 0xff) {
+		ret = rtl28xx_rd_reg(d, reg, &tmp);
+		if (ret)
+			return ret;
+
+		val &= mask;
+		tmp &= ~mask;
+		val |= tmp;
+	}
+
+	return rtl28xx_wr_reg(d, reg, val);
+}
+
 /* I2C */
 static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	int num)
@@ -258,7 +278,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 {
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	int ret;
-	u8 buf[2], val;
+	u8 buf[2];
 	/* open RTL2832U/RTL2832 I2C gate */
 	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x18"};
 	/* close RTL2832U/RTL2832 I2C gate */
@@ -277,24 +297,12 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
+	/* enable GPIO3 and GPIO6 as output */
+	ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x40);
 	if (ret)
 		goto err;
 
-	val &= 0xbf;
-
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, val);
-	if (ret)
-		goto err;
-
-	/* enable as output GPIO3 and GPIO6 */
-	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
-	if (ret)
-		goto err;
-
-	val |= 0x48;
-
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
+	ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x48, 0x48);
 	if (ret)
 		goto err;
 
@@ -611,29 +619,25 @@ static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
 	 * RXEN    GPIO1
 	 */
 
-	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
-	if (ret < 0)
-		goto err;
-
 	switch (cmd) {
 	case TUA9001_CMD_RESETN:
 		if (arg)
-			val |= (1 << 4);
+			val = (1 << 4);
 		else
-			val &= ~(1 << 4);
+			val = (0 << 4);
 
-		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
-		if (ret < 0)
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, val, 0x10);
+		if (ret)
 			goto err;
 		break;
 	case TUA9001_CMD_RXEN:
 		if (arg)
-			val |= (1 << 1);
+			val = (1 << 1);
 		else
-			val &= ~(1 << 1);
+			val = (0 << 1);
 
-		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
-		if (ret < 0)
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, val, 0x02);
+		if (ret)
 			goto err;
 		break;
 	}
@@ -821,7 +825,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	struct dvb_frontend *fe;
-	u8 val;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -854,26 +857,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case TUNER_RTL2832_TUA9001:
 		/* enable GPIO1 and GPIO4 as output */
-		ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
-		if (ret < 0)
-			goto err;
-
-		val &= ~(1 << 1);
-		val &= ~(1 << 4);
-
-		ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, val);
-		if (ret < 0)
-			goto err;
-
-		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
-		if (ret < 0)
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x12);
+		if (ret)
 			goto err;
 
-		val |= (1 << 1);
-		val |= (1 << 4);
-
-		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
-		if (ret < 0)
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x12, 0x12);
+		if (ret)
 			goto err;
 
 		fe = dvb_attach(tua9001_attach, adap->fe[0], &d->i2c_adap,
-- 
1.7.11.4

