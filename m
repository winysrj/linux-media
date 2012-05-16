Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47036 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab2EPWP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 18:15:29 -0400
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linus-media@vger.kernel.org
Cc: crope@iki.fi, pomidorabelisima@gmail.com,
	Thomas Mair <thomas.mair86@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 3/5] rtl28xxu: renamed rtl2831_rd/rtl2831_wr to rtl28xx_rd/rtl28xx_wr
Date: Thu, 17 May 2012 00:13:38 +0200
Message-Id: <1337206420-23810-4-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com>
References: <1>
 <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/rtl28xxu.c |  102 +++++++++++++++++-----------------
 1 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index bb66771..6817ef7 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -83,7 +83,7 @@ err:
 	return ret;
 }
 
-static int rtl2831_wr_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
+static int rtl28xx_wr_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 {
 	struct rtl28xxu_req req;
 
@@ -119,12 +119,12 @@ static int rtl2831_rd_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 	return rtl28xxu_ctrl_msg(d, &req);
 }
 
-static int rtl2831_wr_reg(struct dvb_usb_device *d, u16 reg, u8 val)
+static int rtl28xx_wr_reg(struct dvb_usb_device *d, u16 reg, u8 val)
 {
-	return rtl2831_wr_regs(d, reg, &val, 1);
+	return rtl28xx_wr_regs(d, reg, &val, 1);
 }
 
-static int rtl2831_rd_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
+static int rtl28xx_rd_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
 {
 	return rtl2831_rd_regs(d, reg, val, 1);
 }
@@ -311,12 +311,12 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 	 */
 
 	/* GPIO direction */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_DIR, 0x0a);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_DIR, 0x0a);
 	if (ret)
 		goto err;
 
 	/* enable as output GPIO0, GPIO2, GPIO4 */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
 	if (ret)
 		goto err;
 
@@ -399,7 +399,7 @@ static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 	switch (cmd) {
 	case FC_FE_CALLBACK_VHF_ENABLE:
 		/* set output values */
-		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
 		if (ret)
 			goto err;
 
@@ -409,7 +409,7 @@ static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 			val |= 0x40; /* set GPIO6 high */
 
 
-		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
 		if (ret)
 			goto err;
 		break;
@@ -504,25 +504,25 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	deb_info("%s:\n", __func__);
 
 
-	ret = rtl2831_rd_reg(adap->dev, SYS_GPIO_DIR, &val);
+	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_DIR, &val);
 	if (ret)
 		goto err;
 
 	val &= 0xbf;
 
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_DIR, val);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_DIR, val);
 	if (ret)
 		goto err;
 
 
 	/* enable as output GPIO3 and GPIO6*/
-	ret = rtl2831_rd_reg(adap->dev, SYS_GPIO_OUT_EN, &val);
+	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_OUT_EN, &val);
 	if (ret)
 		goto err;
 
 	val |= 0x48;
 
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, val);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_EN, val);
 	if (ret)
 		goto err;
 
@@ -773,7 +773,7 @@ static int rtl2831u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
 
 	deb_info("%s: onoff=%d\n", __func__, onoff);
 
-	ret = rtl2831_rd_reg(adap->dev, SYS_GPIO_OUT_VAL, &gpio);
+	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_OUT_VAL, &gpio);
 	if (ret)
 		goto err;
 
@@ -787,11 +787,11 @@ static int rtl2831u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
 		gpio &= (~0x04); /* LED off */
 	}
 
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, gpio);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, gpio);
 	if (ret)
 		goto err;
 
-	ret = rtl2831_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
+	ret = rtl28xx_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
 	if (ret)
 		goto err;
 
@@ -817,7 +817,7 @@ static int rtl2832u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
 		buf[1] = 0x02; /* reset EPA */
 	}
 
-	ret = rtl2831_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
+	ret = rtl28xx_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
 	if (ret)
 		goto err;
 
@@ -835,12 +835,12 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	deb_info("%s: onoff=%d\n", __func__, onoff);
 
 	/* demod adc */
-	ret = rtl2831_rd_reg(d, SYS_SYS0, &sys0);
+	ret = rtl28xx_rd_reg(d, SYS_SYS0, &sys0);
 	if (ret)
 		goto err;
 
 	/* tuner power, read GPIOs */
-	ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &gpio);
+	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &gpio);
 	if (ret)
 		goto err;
 
@@ -860,12 +860,12 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	deb_info("%s: WR SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__, sys0, gpio);
 
 	/* demod adc */
-	ret = rtl2831_wr_reg(d, SYS_SYS0, sys0);
+	ret = rtl28xx_wr_reg(d, SYS_SYS0, sys0);
 	if (ret)
 		goto err;
 
 	/* tuner power, write GPIOs */
-	ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, gpio);
+	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, gpio);
 	if (ret)
 		goto err;
 
@@ -884,107 +884,107 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 	if (onoff) {
 		/* set output values */
-		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
 		if (ret)
 			goto err;
 
 		val |= 0x08;
 		val &= 0xef;
 
-		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
 		if (ret)
 			goto err;
 
 		/* demod_ctl_1 */
-		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL1, &val);
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
 		if (ret)
 			goto err;
 
 		val &= 0xef;
 
-		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL1, val);
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL1, val);
 		if (ret)
 			goto err;
 
 		/* demod control */
 		/* PLL enable */
-		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
 		if (ret)
 			goto err;
 
 		/* bit 7 to 1 */
 		val |= 0x80;
 
-		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
 		if (ret)
 			goto err;
 
 		/* demod HW reset */
-		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
 		if (ret)
 			goto err;
 		/* bit 5 to 0 */
 		val &= 0xdf;
 
-		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
 		if (ret)
 			goto err;
 
-		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
 		if (ret)
 			goto err;
 
 		val |= 0x20;
 
-		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
 		if (ret)
 			goto err;
 
 		mdelay(5);
 
 		/*enable ADC_Q and ADC_I */
-		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
 		if (ret)
 			goto err;
 
 		val |= 0x48;
 
-		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
 		if (ret)
 			goto err;
 
 
 	} else {
 		/* demod_ctl_1 */
-		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL1, &val);
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
 		if (ret)
 			goto err;
 
 		val |= 0x0c;
 
-		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL1, val);
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL1, val);
 		if (ret)
 			goto err;
 
 		/* set output values */
-		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
 		if (ret)
 				goto err;
 
 		val |= 0x10;
 
-		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
 		if (ret)
 			goto err;
 
 		/* demod control */
-		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
 		if (ret)
 			goto err;
 
 		val &= 0x37;
 
-		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
 		if (ret)
 			goto err;
 
@@ -1023,7 +1023,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 	/* init remote controller */
 	if (!priv->rc_active) {
 		for (i = 0; i < ARRAY_SIZE(rc_nec_tab); i++) {
-			ret = rtl2831_wr_reg(d, rc_nec_tab[i].reg,
+			ret = rtl28xx_wr_reg(d, rc_nec_tab[i].reg,
 					rc_nec_tab[i].val);
 			if (ret)
 				goto err;
@@ -1053,12 +1053,12 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 
 		rc_keydown(d->rc_dev, rc_code, 0);
 
-		ret = rtl2831_wr_reg(d, SYS_IRRC_SR, 1);
+		ret = rtl28xx_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
 			goto err;
 
 		/* repeated intentionally to avoid extra keypress */
-		ret = rtl2831_wr_reg(d, SYS_IRRC_SR, 1);
+		ret = rtl28xx_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
 			goto err;
 	}
@@ -1095,7 +1095,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 	/* init remote controller */
 	if (!priv->rc_active) {
 		for (i = 0; i < ARRAY_SIZE(rc_nec_tab); i++) {
-			ret = rtl2831_wr_reg(d, rc_nec_tab[i].reg,
+			ret = rtl28xx_wr_reg(d, rc_nec_tab[i].reg,
 					rc_nec_tab[i].val);
 			if (ret)
 				goto err;
@@ -1103,14 +1103,14 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		priv->rc_active = true;
 	}
 
-	ret = rtl2831_rd_reg(d, IR_RX_IF, &buf[0]);
+	ret = rtl28xx_rd_reg(d, IR_RX_IF, &buf[0]);
 	if (ret)
 		goto err;
 
 	if (buf[0] != 0x83)
 		goto exit;
 
-	ret = rtl2831_rd_reg(d, IR_RX_BC, &buf[0]);
+	ret = rtl28xx_rd_reg(d, IR_RX_BC, &buf[0]);
 	if (ret)
 		goto err;
 
@@ -1119,9 +1119,9 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 
 	/* TODO: pass raw IR to Kernel IR decoder */
 
-	ret = rtl2831_wr_reg(d, IR_RX_IF, 0x03);
-	ret = rtl2831_wr_reg(d, IR_RX_BUF_CTRL, 0x80);
-	ret = rtl2831_wr_reg(d, IR_RX_CTRL, 0x80);
+	ret = rtl28xx_wr_reg(d, IR_RX_IF, 0x03);
+	ret = rtl28xx_wr_reg(d, IR_RX_BUF_CTRL, 0x80);
+	ret = rtl28xx_wr_reg(d, IR_RX_CTRL, 0x80);
 
 exit:
 	return ret;
@@ -1301,23 +1301,23 @@ static int rtl28xxu_probe(struct usb_interface *intf,
 
 
 	/* init USB endpoints */
-	ret = rtl2831_rd_reg(d, USB_SYSCTL_0, &val);
+	ret = rtl28xx_rd_reg(d, USB_SYSCTL_0, &val);
 	if (ret)
 			goto err;
 
 	/* enable DMA and Full Packet Mode*/
 	val |= 0x09;
-	ret = rtl2831_wr_reg(d, USB_SYSCTL_0, val);
+	ret = rtl28xx_wr_reg(d, USB_SYSCTL_0, val);
 	if (ret)
 		goto err;
 
 	/* set EPA maximum packet size to 0x0200 */
-	ret = rtl2831_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
+	ret = rtl28xx_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
 	if (ret)
 		goto err;
 
 	/* change EPA FIFO length */
-	ret = rtl2831_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
+	ret = rtl28xx_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
 	if (ret)
 		goto err;
 
-- 
1.7.7.6

