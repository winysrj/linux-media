Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:34822 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab3DUACn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 20:02:43 -0400
Received: by mail-we0-f178.google.com with SMTP id z53so4788434wey.23
        for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 17:02:42 -0700 (PDT)
Message-ID: <51732C84.1080806@gmail.com>
Date: Sun, 21 Apr 2013 02:02:12 +0200
From: Rodrigo Tartajo <rtarty@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] rtl2832u: restore ir remote control support.
Content-Type: multipart/mixed;
 boundary="------------050706080200080908060004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050706080200080908060004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,
This patch uses the driver from openpli[1] as a template to restore the remote control support.
I had to divert from the original to use the in kernel rc protocol decoder. The key repetition does,
not seem to work but I cant find the problem in the driver. As a raw rc provider, no key table is 
hardcoded.

Rodrigo.

[1]: https://aur.archlinux.org/packages/dvb-usb-rtl2832u-openpli/?comments=all


Signed-off-by: Rodrigo Tartajo <rtarty@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h  |  2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 83 ++++++++++++++++++++++++++++-----
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h | 11 +++++
 3 files changed, 83 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 658c6d4..399916b 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -140,7 +140,7 @@ struct dvb_usb_rc {
 	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
 	int (*query) (struct dvb_usb_device *d);
 	unsigned int interval;
-	const enum rc_driver_type driver_type;
+	enum rc_driver_type driver_type;
 	bool bulk_mode;
 };
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 3d128a5..f74bff2 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1215,11 +1215,21 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 #if IS_ENABLED(CONFIG_RC_CORE)
 static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
+#define TICSAT38KHZTONS(x) ((x) * (1000000000/38000))
 	int ret, i;
 	struct rtl28xxu_priv *priv = d->priv;
 	u8 buf[128];
 	int len;
-	struct rtl28xxu_reg_val rc_nec_tab[] = {
+	struct ir_raw_event ev; //encode single ir event (pulse or space)
+	struct rtl28xxu_xreg_val rc_sys_init_tab[] = {
+		{ SYS_DEMOD_CTL1,   OP_AND, 0xfb },
+		{ SYS_DEMOD_CTL1,   OP_AND, 0xf7 },
+		{ USB_CTRL,         OP_OR , 0x20 },
+		{ SYS_SYS1,         OP_AND, 0xf7 },
+		{ SYS_GPIO_OUT_EN,  OP_OR , 0x08 },
+		{ SYS_GPIO_OUT_VAL, OP_OR , 0x08 },
+	}; // system hard init
+	struct rtl28xxu_reg_val rc_init_tab[] = {
 		{ IR_RX_CTRL,             0x20 },
 		{ IR_RX_BUF_CTRL,         0x80 },
 		{ IR_RX_IF,               0xff },
@@ -1234,13 +1244,40 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		{ IR_MAX_H_TOL_LEN,       0x1e },
 		{ IR_MAX_L_TOL_LEN,       0x1e },
 		{ IR_RX_CTRL,             0x80 },
-	};
+	}; // hard init
+	struct rtl28xxu_reg_val rc_reinit_tab[] = {
+		{ IR_RX_CTRL,     0x20 },
+		{ IR_RX_BUF_CTRL, 0x80 },
+		{ IR_RX_IF,       0xff },
+		{ IR_RX_IE,       0xff },
+		{ IR_RX_CTRL,     0x80 },
+	}; // reinit IR
+	struct rtl28xxu_reg_val rc_clear_tab[] = {
+		{ IR_RX_IF,       0x03 },
+		{ IR_RX_BUF_CTRL, 0x80 },
+		{ IR_RX_CTRL,     0x80 },
+	}; // clear reception
 
 	/* init remote controller */
 	if (!priv->rc_active) {
-		for (i = 0; i < ARRAY_SIZE(rc_nec_tab); i++) {
-			ret = rtl28xx_wr_reg(d, rc_nec_tab[i].reg,
-					rc_nec_tab[i].val);
+		for (i = 0; i < ARRAY_SIZE(rc_sys_init_tab); i++) {
+			ret = rtl28xx_rd_reg(d, rc_sys_init_tab[i].reg, &buf[0]);
+			if (ret)
+				goto err;
+			if (rc_sys_init_tab[i].op == OP_AND) {
+				buf[0] &= rc_sys_init_tab[i].mask;
+			}
+			else {//OP_OR
+				buf[0] |= rc_sys_init_tab[i].mask;
+			}
+			ret = rtl28xx_wr_reg(d, rc_sys_init_tab[i].reg,
+					buf[0]);
+			if (ret)
+				goto err;
+		}
+		for (i = 0; i < ARRAY_SIZE(rc_init_tab); i++) {
+			ret = rtl28xx_wr_reg(d, rc_init_tab[i].reg,
+					rc_init_tab[i].val);
 			if (ret)
 				goto err;
 		}
@@ -1252,7 +1289,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		goto err;
 
 	if (buf[0] != 0x83)
-		goto exit;
+		goto err;
 
 	ret = rtl28xx_rd_reg(d, IR_RX_BC, &buf[0]);
 	if (ret)
@@ -1261,26 +1298,48 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 	len = buf[0];
 	ret = rtl2831_rd_regs(d, IR_RX_BUF, buf, len);
 
-	/* TODO: pass raw IR to Kernel IR decoder */
+	/* pass raw IR to Kernel IR decoder */
+	init_ir_raw_event(&ev);
+	ir_raw_event_reset(d->rc_dev);
+	ev.pulse=1;
+	for(i=0; true; ++i) { // conver count to time
+		if (i >= len || !(buf[i] & 0x80) != !(ev.pulse)) {//end or transition pulse/space: flush
+			ir_raw_event_store(d->rc_dev, &ev);
+			ev.duration = 0;
+		}
+		if (i >= len)
+			break;
+		ev.pulse = buf[i] >> 7;
+		ev.duration += TICSAT38KHZTONS(((u32)(buf[i] & 0x7F)) << 1);
+	}
+	ir_raw_event_handle(d->rc_dev);
 
-	ret = rtl28xx_wr_reg(d, IR_RX_IF, 0x03);
-	ret = rtl28xx_wr_reg(d, IR_RX_BUF_CTRL, 0x80);
-	ret = rtl28xx_wr_reg(d, IR_RX_CTRL, 0x80);
+	for (i = 0; i < ARRAY_SIZE(rc_clear_tab); i++) {
+		ret = rtl28xx_wr_reg(d, rc_clear_tab[i].reg,
+				rc_clear_tab[i].val);
+		if (ret)
+			goto err;
+	}
 
-exit:
 	return ret;
 err:
+	for (i = 0; i < ARRAY_SIZE(rc_reinit_tab); i++) {
+		ret = rtl28xx_wr_reg(d, rc_reinit_tab[i].reg,
+				rc_reinit_tab[i].val);
+	}
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
+#undef TICSAT38KHZTONS
 }
 
 static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 		struct dvb_usb_rc *rc)
 {
 	rc->map_name = RC_MAP_EMPTY;
-	rc->allowed_protos = RC_BIT_NEC;
+	rc->allowed_protos = RC_BIT_ALL;
 	rc->query = rtl2832u_rc_query;
 	rc->interval = 400;
+	rc->driver_type = RC_DRIVER_IR_RAW;
 
 	return 0;
 }
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 2f3af2d..ac2c2d6 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -96,6 +96,17 @@ struct rtl28xxu_reg_val {
 	u8 val;
 };
 
+enum OP{
+	OP_AND	=0,
+	OP_OR
+};
+
+struct rtl28xxu_xreg_val {
+	u16 reg;
+	u8 op;
+	u8 mask;
+};
+
 /*
  * memory map
  *
-- 
1.8.1.5


--------------050706080200080908060004
Content-Type: text/plain; charset=UTF-8;
 name="Parte del mensaje adjunto"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Parte del mensaje adjunto"


--------------050706080200080908060004--
