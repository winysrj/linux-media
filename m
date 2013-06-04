Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33228 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab3FDV4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/7] rtl28xxu: use masked reg write where possible
Date: Wed,  5 Jun 2013 00:55:03 +0300
Message-Id: <1370382903-21332-8-git-send-email-crope@iki.fi>
In-Reply-To: <1370382903-21332-1-git-send-email-crope@iki.fi>
References: <1370382903-21332-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use masked register write inside rtl2832u_power_ctrl().

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 72 ++++++++-------------------------
 1 file changed, 16 insertions(+), 56 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 04da6be..6f5a3d0 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1041,67 +1041,34 @@ err:
 static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
-	u8 val;
 
 	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
 
 	if (onoff) {
-		/* set output values */
-		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
-		if (ret)
-			goto err;
-
-		val |= 0x08;
-		val &= 0xef;
-
-		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
-		if (ret)
-			goto err;
-
-		/* demod_ctl_1 */
-		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
-		if (ret)
-			goto err;
-
-		val &= 0xef;
-
-		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL1, val);
-		if (ret)
-			goto err;
-
-		/* demod control */
-		/* PLL enable */
-		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		/* GPIO3=1, GPIO4=0 */
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x08, 0x18);
 		if (ret)
 			goto err;
 
-		/* bit 7 to 1 */
-		val |= 0x80;
-
-		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		/* suspend? */
+		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL1, 0x00, 0x10);
 		if (ret)
 			goto err;
 
-		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		/* enable PLL */
+		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x80, 0x80);
 		if (ret)
 			goto err;
 
-		val |= 0x20;
-
-		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		/* disable reset */
+		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x20, 0x20);
 		if (ret)
 			goto err;
 
 		mdelay(5);
 
-		/*enable ADC_Q and ADC_I */
-		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
-		if (ret)
-			goto err;
-
-		val |= 0x48;
-
-		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		/* enable ADC */
+		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x48, 0x48);
 		if (ret)
 			goto err;
 
@@ -1114,25 +1081,18 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret)
 			goto err;
 	} else {
-		/* set output values */
-		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
-		if (ret)
-				goto err;
-
-		val |= 0x10;
-
-		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		/* GPIO4=1 */
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x10, 0x10);
 		if (ret)
 			goto err;
 
-		/* demod control */
-		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		/* disable ADC */
+		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x00, 0x48);
 		if (ret)
 			goto err;
 
-		val &= 0x37;
-
-		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		/* disable PLL */
+		ret = rtl28xx_wr_reg_mask(d, SYS_DEMOD_CTL, 0x00, 0x80);
 		if (ret)
 			goto err;
 
-- 
1.7.11.7

