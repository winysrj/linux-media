Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46440 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbaLWVQL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:16:11 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 65/66] rtl28xxu: correct reg access routine name prefixes
Date: Tue, 23 Dec 2014 22:49:58 +0200
Message-Id: <1419367799-14263-65-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use rtl28xxu_ prefix for all register access routine names.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 100 ++++++++++++++++----------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 23ded77..d88f799 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -62,7 +62,7 @@ err:
 	return ret;
 }
 
-static int rtl28xx_wr_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
+static int rtl28xxu_wr_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 {
 	struct rtl28xxu_req req;
 
@@ -80,7 +80,7 @@ static int rtl28xx_wr_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 	return rtl28xxu_ctrl_msg(d, &req);
 }
 
-static int rtl2831_rd_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
+static int rtl28xxu_rd_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 {
 	struct rtl28xxu_req req;
 
@@ -98,17 +98,17 @@ static int rtl2831_rd_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 	return rtl28xxu_ctrl_msg(d, &req);
 }
 
-static int rtl28xx_wr_reg(struct dvb_usb_device *d, u16 reg, u8 val)
+static int rtl28xxu_wr_reg(struct dvb_usb_device *d, u16 reg, u8 val)
 {
-	return rtl28xx_wr_regs(d, reg, &val, 1);
+	return rtl28xxu_wr_regs(d, reg, &val, 1);
 }
 
-static int rtl28xx_rd_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
+static int rtl28xxu_rd_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
 {
-	return rtl2831_rd_regs(d, reg, val, 1);
+	return rtl28xxu_rd_regs(d, reg, val, 1);
 }
 
-static int rtl28xx_wr_reg_mask(struct dvb_usb_device *d, u16 reg, u8 val,
+static int rtl28xxu_wr_reg_mask(struct dvb_usb_device *d, u16 reg, u8 val,
 		u8 mask)
 {
 	int ret;
@@ -116,7 +116,7 @@ static int rtl28xx_wr_reg_mask(struct dvb_usb_device *d, u16 reg, u8 val,
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = rtl28xx_rd_reg(d, reg, &tmp);
+		ret = rtl28xxu_rd_reg(d, reg, &tmp);
 		if (ret)
 			return ret;
 
@@ -125,7 +125,7 @@ static int rtl28xx_wr_reg_mask(struct dvb_usb_device *d, u16 reg, u8 val,
 		val |= tmp;
 	}
 
-	return rtl28xx_wr_reg(d, reg, val);
+	return rtl28xxu_wr_reg(d, reg, val);
 }
 
 /* I2C */
@@ -274,12 +274,12 @@ static int rtl2831u_read_config(struct dvb_usb_device *d)
 	 */
 
 	/* GPIO direction */
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, 0x0a);
+	ret = rtl28xxu_wr_reg(d, SYS_GPIO_DIR, 0x0a);
 	if (ret)
 		goto err;
 
 	/* enable as output GPIO0, GPIO2, GPIO4 */
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, 0x15);
+	ret = rtl28xxu_wr_reg(d, SYS_GPIO_OUT_EN, 0x15);
 	if (ret)
 		goto err;
 
@@ -361,11 +361,11 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	dev_dbg(&d->intf->dev, "\n");
 
 	/* enable GPIO3 and GPIO6 as output */
-	ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x40);
+	ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x40);
 	if (ret)
 		goto err;
 
-	ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x48, 0x48);
+	ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x48, 0x48);
 	if (ret)
 		goto err;
 
@@ -483,15 +483,15 @@ tuner_found:
 	/* probe slave demod */
 	if (dev->tuner == TUNER_RTL2832_R828D) {
 		/* power on MN88472 demod on GPIO0 */
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x01, 0x01);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x01, 0x01);
 		if (ret)
 			goto err;
 
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x01);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x01);
 		if (ret)
 			goto err;
 
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x01, 0x01);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x01, 0x01);
 		if (ret)
 			goto err;
 
@@ -679,7 +679,7 @@ static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 	switch (cmd) {
 	case FC_FE_CALLBACK_VHF_ENABLE:
 		/* set output values */
-		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		ret = rtl28xxu_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
 		if (ret)
 			goto err;
 
@@ -689,7 +689,7 @@ static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 			val |= 0x40; /* set GPIO6 high */
 
 
-		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		ret = rtl28xxu_wr_reg(d, SYS_GPIO_OUT_VAL, val);
 		if (ret)
 			goto err;
 		break;
@@ -724,7 +724,7 @@ static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
 		else
 			val = (0 << 4);
 
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, val, 0x10);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, val, 0x10);
 		if (ret)
 			goto err;
 		break;
@@ -734,7 +734,7 @@ static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
 		else
 			val = (0 << 1);
 
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, val, 0x02);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, val, 0x02);
 		if (ret)
 			goto err;
 		break;
@@ -1109,11 +1109,11 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case TUNER_RTL2832_TUA9001:
 		/* enable GPIO1 and GPIO4 as output */
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x12);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x12);
 		if (ret)
 			goto err;
 
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x12, 0x12);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x12, 0x12);
 		if (ret)
 			goto err;
 
@@ -1234,23 +1234,23 @@ static int rtl28xxu_init(struct dvb_usb_device *d)
 	dev_dbg(&d->intf->dev, "\n");
 
 	/* init USB endpoints */
-	ret = rtl28xx_rd_reg(d, USB_SYSCTL_0, &val);
+	ret = rtl28xxu_rd_reg(d, USB_SYSCTL_0, &val);
 	if (ret)
 		goto err;
 
 	/* enable DMA and Full Packet Mode*/
 	val |= 0x09;
-	ret = rtl28xx_wr_reg(d, USB_SYSCTL_0, val);
+	ret = rtl28xxu_wr_reg(d, USB_SYSCTL_0, val);
 	if (ret)
 		goto err;
 
 	/* set EPA maximum packet size to 0x0200 */
-	ret = rtl28xx_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
+	ret = rtl28xxu_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
 	if (ret)
 		goto err;
 
 	/* change EPA FIFO length */
-	ret = rtl28xx_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
+	ret = rtl28xxu_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
 	if (ret)
 		goto err;
 
@@ -1268,12 +1268,12 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	dev_dbg(&d->intf->dev, "onoff=%d\n", onoff);
 
 	/* demod adc */
-	ret = rtl28xx_rd_reg(d, SYS_SYS0, &sys0);
+	ret = rtl28xxu_rd_reg(d, SYS_SYS0, &sys0);
 	if (ret)
 		goto err;
 
 	/* tuner power, read GPIOs */
-	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &gpio);
+	ret = rtl28xxu_rd_reg(d, SYS_GPIO_OUT_VAL, &gpio);
 	if (ret)
 		goto err;
 
@@ -1299,17 +1299,17 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	dev_dbg(&d->intf->dev, "WR SYS0=%02x GPIO_OUT_VAL=%02x\n", sys0, gpio);
 
 	/* demod adc */
-	ret = rtl28xx_wr_reg(d, SYS_SYS0, sys0);
+	ret = rtl28xxu_wr_reg(d, SYS_SYS0, sys0);
 	if (ret)
 		goto err;
 
 	/* tuner power, write GPIOs */
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, gpio);
+	ret = rtl28xxu_wr_reg(d, SYS_GPIO_OUT_VAL, gpio);
 	if (ret)
 		goto err;
 
 	/* streaming EP: stall & reset */
-	ret = rtl28xx_wr_regs(d, USB_EPA_CTL, epa_ctl, 2);
+	ret = rtl28xxu_wr_regs(d, USB_EPA_CTL, epa_ctl, 2);
 	if (ret)
 		goto err;
 
@@ -1330,27 +1330,27 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 	if (onoff) {
 		/* GPIO3=1, GPIO4=0 */
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x08, 0x18);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x08, 0x18);
 		if (ret)
 			goto err;
 
 		/* suspend? */
-		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL1, 0x00, 0x10);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_DEMOD_CTL1, 0x00, 0x10);
 		if (ret)
 			goto err;
 
 		/* enable PLL */
-		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x80, 0x80);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_DEMOD_CTL, 0x80, 0x80);
 		if (ret)
 			goto err;
 
 		/* disable reset */
-		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x20, 0x20);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_DEMOD_CTL, 0x20, 0x20);
 		if (ret)
 			goto err;
 
 		/* streaming EP: clear stall & reset */
-		ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x00\x00", 2);
+		ret = rtl28xxu_wr_regs(d, USB_EPA_CTL, "\x00\x00", 2);
 		if (ret)
 			goto err;
 
@@ -1359,17 +1359,17 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 			goto err;
 	} else {
 		/* GPIO4=1 */
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x10, 0x10);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x10, 0x10);
 		if (ret)
 			goto err;
 
 		/* disable PLL */
-		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x00, 0x80);
+		ret = rtl28xxu_wr_reg_mask(d, SYS_DEMOD_CTL, 0x00, 0x80);
 		if (ret)
 			goto err;
 
 		/* streaming EP: set stall & reset */
-		ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x10\x02", 2);
+		ret = rtl28xxu_wr_regs(d, USB_EPA_CTL, "\x10\x02", 2);
 		if (ret)
 			goto err;
 	}
@@ -1409,7 +1409,7 @@ static int rtl28xxu_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 	else
 		val = 0x00; /* disable ADC */
 
-	ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, val, 0x48);
+	ret = rtl28xxu_wr_reg_mask(d, SYS_DEMOD_CTL, val, 0x48);
 	if (ret)
 		goto err;
 
@@ -1453,7 +1453,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 	/* init remote controller */
 	if (!dev->rc_active) {
 		for (i = 0; i < ARRAY_SIZE(rc_nec_tab); i++) {
-			ret = rtl28xx_wr_reg(d, rc_nec_tab[i].reg,
+			ret = rtl28xxu_wr_reg(d, rc_nec_tab[i].reg,
 					rc_nec_tab[i].val);
 			if (ret)
 				goto err;
@@ -1461,7 +1461,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		dev->rc_active = true;
 	}
 
-	ret = rtl2831_rd_regs(d, SYS_IRRC_RP, buf, 5);
+	ret = rtl28xxu_rd_regs(d, SYS_IRRC_RP, buf, 5);
 	if (ret)
 		goto err;
 
@@ -1483,12 +1483,12 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 
 		rc_keydown(d->rc_dev, RC_TYPE_NEC, rc_code, 0);
 
-		ret = rtl28xx_wr_reg(d, SYS_IRRC_SR, 1);
+		ret = rtl28xxu_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
 			goto err;
 
 		/* repeated intentionally to avoid extra keypress */
-		ret = rtl28xx_wr_reg(d, SYS_IRRC_SR, 1);
+		ret = rtl28xxu_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
 			goto err;
 	}
@@ -1544,7 +1544,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		};
 
 		for (i = 0; i < ARRAY_SIZE(init_tab); i++) {
-			ret = rtl28xx_wr_reg_mask(d, init_tab[i].reg,
+			ret = rtl28xxu_wr_reg_mask(d, init_tab[i].reg,
 					init_tab[i].val, init_tab[i].mask);
 			if (ret)
 				goto err;
@@ -1553,27 +1553,27 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		dev->rc_active = true;
 	}
 
-	ret = rtl28xx_rd_reg(d, IR_RX_IF, &buf[0]);
+	ret = rtl28xxu_rd_reg(d, IR_RX_IF, &buf[0]);
 	if (ret)
 		goto err;
 
 	if (buf[0] != 0x83)
 		goto exit;
 
-	ret = rtl28xx_rd_reg(d, IR_RX_BC, &buf[0]);
+	ret = rtl28xxu_rd_reg(d, IR_RX_BC, &buf[0]);
 	if (ret)
 		goto err;
 
 	len = buf[0];
 
 	/* read raw code from hw */
-	ret = rtl2831_rd_regs(d, IR_RX_BUF, buf, len);
+	ret = rtl28xxu_rd_regs(d, IR_RX_BUF, buf, len);
 	if (ret)
 		goto err;
 
 	/* let hw receive new code */
 	for (i = 0; i < ARRAY_SIZE(refresh_tab); i++) {
-		ret = rtl28xx_wr_reg_mask(d, refresh_tab[i].reg,
+		ret = rtl28xxu_wr_reg_mask(d, refresh_tab[i].reg,
 				refresh_tab[i].val, refresh_tab[i].mask);
 		if (ret)
 			goto err;
@@ -1603,7 +1603,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 {
 	/* disable IR interrupts in order to avoid SDR sample loss */
 	if (rtl28xxu_disable_rc)
-		return rtl28xx_wr_reg(d, IR_RX_IE, 0x00);
+		return rtl28xxu_wr_reg(d, IR_RX_IE, 0x00);
 
 	/* load empty to enable rc */
 	if (!rc->map_name)
-- 
http://palosaari.fi/

