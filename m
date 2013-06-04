Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58481 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3FDV4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Rodrigo Tartajo <rtarty@gmail.com>
Subject: =?yes?q?=5BPATCH=202/7=5D=20rtl28xxu=3A=20reimplement=20rtl2832u=20remote=20controller?=
Date: Wed,  5 Jun 2013 00:54:58 +0300
Message-Id: <1370382903-21332-3-git-send-email-crope@iki.fi>
In-Reply-To: <1370382903-21332-1-git-send-email-crope@iki.fi>
References: <1370382903-21332-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Rodrigo for original implementation!

Cc: Rodrigo Tartajo <rtarty@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 152 ++++++++++++--------------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   9 +-
 2 files changed, 58 insertions(+), 103 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index e592662..4167011 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1114,17 +1114,6 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret)
 			goto err;
 	} else {
-		/* demod_ctl_1 */
-		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
-		if (ret)
-			goto err;
-
-		val |= 0x0c;
-
-		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL1, val);
-		if (ret)
-			goto err;
-
 		/* set output values */
 		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
 		if (ret)
@@ -1249,72 +1238,44 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 #if IS_ENABLED(CONFIG_RC_CORE)
 static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
-#define TICSAT38KHZTONS(x) ((x) * (1000000000/38000))
-	int ret, i;
+	int ret, i, len;
 	struct rtl28xxu_priv *priv = d->priv;
+	struct ir_raw_event ev;
 	u8 buf[128];
-	int len;
-	struct ir_raw_event ev; //encode single ir event (pulse or space)
-	struct rtl28xxu_xreg_val rc_sys_init_tab[] = {
-		{ SYS_DEMOD_CTL1,   OP_AND, 0xfb },
-		{ SYS_DEMOD_CTL1,   OP_AND, 0xf7 },
-		{ USB_CTRL,         OP_OR , 0x20 },
-		{ SYS_SYS1,         OP_AND, 0xf7 },
-		{ SYS_GPIO_OUT_EN,  OP_OR , 0x08 },
-		{ SYS_GPIO_OUT_VAL, OP_OR , 0x08 },
-	}; // system hard init
-	struct rtl28xxu_reg_val rc_init_tab[] = {
-		{ IR_RX_CTRL,             0x20 },
-		{ IR_RX_BUF_CTRL,         0x80 },
-		{ IR_RX_IF,               0xff },
-		{ IR_RX_IE,               0xff },
-		{ IR_MAX_DURATION0,       0xd0 },
-		{ IR_MAX_DURATION1,       0x07 },
-		{ IR_IDLE_LEN0,           0xc0 },
-		{ IR_IDLE_LEN1,           0x00 },
-		{ IR_GLITCH_LEN,          0x03 },
-		{ IR_RX_CLK,              0x09 },
-		{ IR_RX_CFG,              0x1c },
-		{ IR_MAX_H_TOL_LEN,       0x1e },
-		{ IR_MAX_L_TOL_LEN,       0x1e },
-		{ IR_RX_CTRL,             0x80 },
-	}; // hard init
-	struct rtl28xxu_reg_val rc_reinit_tab[] = {
-		{ IR_RX_CTRL,     0x20 },
-		{ IR_RX_BUF_CTRL, 0x80 },
-		{ IR_RX_IF,       0xff },
-		{ IR_RX_IE,       0xff },
-		{ IR_RX_CTRL,     0x80 },
-	}; // reinit IR
-	struct rtl28xxu_reg_val rc_clear_tab[] = {
-		{ IR_RX_IF,       0x03 },
-		{ IR_RX_BUF_CTRL, 0x80 },
-		{ IR_RX_CTRL,     0x80 },
-	}; // clear reception
+	static const struct rtl28xxu_reg_val_mask refresh_tab[] = {
+		{IR_RX_IF,               0x03, 0xff},
+		{IR_RX_BUF_CTRL,         0x80, 0xff},
+		{IR_RX_CTRL,             0x80, 0xff},
+	};
 
 	/* init remote controller */
 	if (!priv->rc_active) {
-		for (i = 0; i < ARRAY_SIZE(rc_sys_init_tab); i++) {
-			ret = rtl28xx_rd_reg(d, rc_sys_init_tab[i].reg, &buf[0]);
-			if (ret)
-				goto err;
-			if (rc_sys_init_tab[i].op == OP_AND) {
-				buf[0] &= rc_sys_init_tab[i].mask;
-			}
-			else {//OP_OR
-				buf[0] |= rc_sys_init_tab[i].mask;
-			}
-			ret = rtl28xx_wr_reg(d, rc_sys_init_tab[i].reg,
-					buf[0]);
-			if (ret)
-				goto err;
-		}
-		for (i = 0; i < ARRAY_SIZE(rc_init_tab); i++) {
-			ret = rtl28xx_wr_reg(d, rc_init_tab[i].reg,
-					rc_init_tab[i].val);
+		static const struct rtl28xxu_reg_val_mask init_tab[] = {
+			{SYS_DEMOD_CTL1,         0x00, 0x04},
+			{SYS_DEMOD_CTL1,         0x00, 0x08},
+			{USB_CTRL,               0x20, 0x20},
+			{SYS_GPIO_DIR,           0x00, 0x08},
+			{SYS_GPIO_OUT_EN,        0x08, 0x08},
+			{SYS_GPIO_OUT_VAL,       0x08, 0x08},
+			{IR_MAX_DURATION0,       0xd0, 0xff},
+			{IR_MAX_DURATION1,       0x07, 0xff},
+			{IR_IDLE_LEN0,           0xc0, 0xff},
+			{IR_IDLE_LEN1,           0x00, 0xff},
+			{IR_GLITCH_LEN,          0x03, 0xff},
+			{IR_RX_CLK,              0x09, 0xff},
+			{IR_RX_CFG,              0x1c, 0xff},
+			{IR_MAX_H_TOL_LEN,       0x1e, 0xff},
+			{IR_MAX_L_TOL_LEN,       0x1e, 0xff},
+			{IR_RX_CTRL,             0x80, 0xff},
+		};
+
+		for (i = 0; i < ARRAY_SIZE(init_tab); i++) {
+			ret = rtl28xx_wr_reg_mask(d, init_tab[i].reg,
+					init_tab[i].val, init_tab[i].mask);
 			if (ret)
 				goto err;
 		}
+
 		priv->rc_active = true;
 	}
 
@@ -1323,57 +1284,56 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[0] != 0x83)
-		goto err;
+		goto exit;
 
 	ret = rtl28xx_rd_reg(d, IR_RX_BC, &buf[0]);
 	if (ret)
 		goto err;
 
 	len = buf[0];
-	ret = rtl2831_rd_regs(d, IR_RX_BUF, buf, len);
 
-	/* pass raw IR to Kernel IR decoder */
-	init_ir_raw_event(&ev);
-	ir_raw_event_reset(d->rc_dev);
-	ev.pulse=1;
-	for(i=0; true; ++i) { // conver count to time
-		if (i >= len || !(buf[i] & 0x80) != !(ev.pulse)) {//end or transition pulse/space: flush
-			ir_raw_event_store(d->rc_dev, &ev);
-			ev.duration = 0;
-		}
-		if (i >= len)
-			break;
-		ev.pulse = buf[i] >> 7;
-		ev.duration += TICSAT38KHZTONS(((u32)(buf[i] & 0x7F)) << 1);
-	}
-	ir_raw_event_handle(d->rc_dev);
+	/* read raw code from hw */
+	ret = rtl2831_rd_regs(d, IR_RX_BUF, buf, len);
+	if (ret)
+		goto err;
 
-	for (i = 0; i < ARRAY_SIZE(rc_clear_tab); i++) {
-		ret = rtl28xx_wr_reg(d, rc_clear_tab[i].reg,
-				rc_clear_tab[i].val);
+	/* let hw receive new code */
+	for (i = 0; i < ARRAY_SIZE(refresh_tab); i++) {
+		ret = rtl28xx_wr_reg_mask(d, refresh_tab[i].reg,
+				refresh_tab[i].val, refresh_tab[i].mask);
 		if (ret)
 			goto err;
 	}
 
+	/* pass data to Kernel IR decoder */
+	init_ir_raw_event(&ev);
+
+	for (i = 0; i < len; i++) {
+		ev.pulse = buf[i] >> 7;
+		ev.duration = 50800 * (buf[i] & 0x7f);
+		ir_raw_event_store_with_filter(d->rc_dev, &ev);
+	}
+
+	/* 'flush' ir_raw_event_store_with_filter() */
+	ir_raw_event_set_idle(d->rc_dev, true);
+	ir_raw_event_handle(d->rc_dev);
+exit:
 	return ret;
 err:
-	for (i = 0; i < ARRAY_SIZE(rc_reinit_tab); i++) {
-		ret = rtl28xx_wr_reg(d, rc_reinit_tab[i].reg,
-				rc_reinit_tab[i].val);
-	}
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
-#undef TICSAT38KHZTONS
 }
 
 static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 		struct dvb_usb_rc *rc)
 {
-	rc->map_name = RC_MAP_EMPTY;
+	/* load empty to enable rc */
+	if (!rc->map_name)
+		rc->map_name = RC_MAP_EMPTY;
 	rc->allowed_protos = RC_BIT_ALL;
+	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->query = rtl2832u_rc_query;
 	rc->interval = 400;
-	rc->driver_type = RC_DRIVER_IR_RAW;
 
 	return 0;
 }
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 0177b38..729b354 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -97,14 +97,9 @@ struct rtl28xxu_reg_val {
 	u8 val;
 };
 
-enum OP{
-	OP_AND	=0,
-	OP_OR
-};
-
-struct rtl28xxu_xreg_val {
+struct rtl28xxu_reg_val_mask {
 	u16 reg;
-	u8 op;
+	u8 val;
 	u8 mask;
 };
 
-- 
1.7.11.7

