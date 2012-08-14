Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50166 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab2HNT44 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 15:56:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] anysee: convert Kernel dev_* logging
Date: Tue, 14 Aug 2012 22:56:20 +0300
Message-Id: <1344974180-19391-2-git-send-email-crope@iki.fi>
In-Reply-To: <1344974180-19391-1-git-send-email-crope@iki.fi>
References: <1344974180-19391-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 58 ++++++++++++++++++-----------------
 drivers/media/usb/dvb-usb-v2/anysee.h | 30 ------------------
 2 files changed, 30 insertions(+), 58 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index fe2cbb4..30ae2de 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -44,12 +44,7 @@
 #include "isl6423.h"
 #include "cxd2820r.h"
 
-/* debug */
-static int dvb_usb_anysee_debug;
-module_param_named(debug, dvb_usb_anysee_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-
 static DEFINE_MUTEX(anysee_usb_mutex);
 
 static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
@@ -64,8 +59,7 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 
 	mutex_lock(&anysee_usb_mutex);
 
-	deb_xfer(">>> ");
-	debug_dump(buf, slen, deb_xfer);
+	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, slen, buf);
 
 	/* We need receive one message more after dvb_usb_generic_rw due
 	   to weird transaction flow, which is 1 x send + 2 x receive. */
@@ -92,14 +86,15 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 			&act_len, 2000);
 
 		if (ret) {
-			deb_info("%s: recv bulk message failed: %d",
-					__func__, ret);
+			dev_dbg(&d->udev->dev, "%s: recv bulk message " \
+					"failed=%d\n", __func__, ret);
 		} else {
-			deb_xfer("<<< ");
-			debug_dump(buf, rlen, deb_xfer);
+			dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
+					rlen, buf);
 
 			if (buf[63] != 0x4f)
-				deb_info("%s: cmd failed\n", __func__);
+				dev_dbg(&d->udev->dev, "%s: cmd failed\n",
+						__func__);
 
 			break;
 		}
@@ -107,7 +102,8 @@ static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 
 	if (ret) {
 		/* all retries failed, it is fatal */
-		err("%s: recv bulk message failed: %d", __func__, ret);
+		dev_err(&d->udev->dev, "%s: recv bulk message failed=%d\n",
+				KBUILD_MODNAME, ret);
 		goto error_unlock;
 	}
 
@@ -126,14 +122,14 @@ static int anysee_read_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
 	u8 buf[] = {CMD_REG_READ, reg >> 8, reg & 0xff, 0x01};
 	int ret;
 	ret = anysee_ctrl_msg(d, buf, sizeof(buf), val, 1);
-	deb_info("%s: reg:%04x val:%02x\n", __func__, reg, *val);
+	dev_dbg(&d->udev->dev, "%s: reg=%04x val=%02x\n", __func__, reg, *val);
 	return ret;
 }
 
 static int anysee_write_reg(struct dvb_usb_device *d, u16 reg, u8 val)
 {
 	u8 buf[] = {CMD_REG_WRITE, reg >> 8, reg & 0xff, 0x01, val};
-	deb_info("%s: reg:%04x val:%02x\n", __func__, reg, val);
+	dev_dbg(&d->udev->dev, "%s: reg=%04x val=%02x\n", __func__, reg, val);
 	return anysee_ctrl_msg(d, buf, sizeof(buf), NULL, 0);
 }
 
@@ -190,21 +186,22 @@ static int anysee_get_hw_info(struct dvb_usb_device *d, u8 *id)
 static int anysee_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	u8 buf[] = {CMD_STREAMING_CTRL, (u8)onoff, 0x00};
-	deb_info("%s: onoff:%02x\n", __func__, onoff);
+	dev_dbg(&fe_to_d(fe)->udev->dev, "%s: onoff=%d\n", __func__, onoff);
 	return anysee_ctrl_msg(fe_to_d(fe), buf, sizeof(buf), NULL, 0);
 }
 
 static int anysee_led_ctrl(struct dvb_usb_device *d, u8 mode, u8 interval)
 {
 	u8 buf[] = {CMD_LED_AND_IR_CTRL, 0x01, mode, interval};
-	deb_info("%s: state:%02x interval:%02x\n", __func__, mode, interval);
+	dev_dbg(&d->udev->dev, "%s: state=%d interval=%d\n", __func__,
+			mode, interval);
 	return anysee_ctrl_msg(d, buf, sizeof(buf), NULL, 0);
 }
 
 static int anysee_ir_ctrl(struct dvb_usb_device *d, u8 onoff)
 {
 	u8 buf[] = {CMD_LED_AND_IR_CTRL, 0x02, onoff};
-	deb_info("%s: onoff:%02x\n", __func__, onoff);
+	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
 	return anysee_ctrl_msg(d, buf, sizeof(buf), NULL, 0);
 }
 
@@ -524,9 +521,11 @@ static int anysee_read_config(struct dvb_usb_device *d)
 	if (ret)
 		goto error;
 
-	/* Meaning of these info bytes are guessed. */
-	info("firmware version:%d.%d hardware id:%d",
-		hw_info[1], hw_info[2], hw_info[0]);
+	/*
+	 * Meaning of these info bytes are guessed.
+	 */
+	dev_info(&d->udev->dev, "%s: firmware version %d.%d hardware id %d\n",
+			KBUILD_MODNAME, hw_info[1], hw_info[2], hw_info[0]);
 
 	state->hw = hw_info[0];
 error:
@@ -545,8 +544,7 @@ static int anysee_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 	struct anysee_state *state = fe_to_priv(fe);
 	struct dvb_usb_device *d = fe_to_d(fe);
 	int ret;
-
-	deb_info("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
+	dev_dbg(&d->udev->dev, "%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
 
 	/* no frontend sleep control */
 	if (onoff == 0)
@@ -728,7 +726,8 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 		tmp = 0;
 		ret = i2c_transfer(&d->i2c_adap, msg, 2);
 		if (ret == 2 && tmp == 0xc7)
-			deb_info("%s: TDA18212 found\n", __func__);
+			dev_dbg(&d->udev->dev, "%s: TDA18212 found\n",
+					__func__);
 		else
 			tmp = 0;
 
@@ -885,8 +884,10 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 	if (!adap->fe[0]) {
 		/* we have no frontend :-( */
 		ret = -ENODEV;
-		err("Unsupported Anysee version. " \
-			"Please report the <linux-media@vger.kernel.org>.");
+		dev_err(&d->udev->dev, "%s: Unsupported Anysee version. " \
+				"Please report the " \
+				"<linux-media@vger.kernel.org>.\n",
+				KBUILD_MODNAME);
 	}
 error:
 	return ret;
@@ -898,7 +899,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct dvb_frontend *fe;
 	int ret;
-	deb_info("%s: adap=%d\n", __func__, adap->id);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	switch (state->hw) {
 	case ANYSEE_HW_507T: /* 2 */
@@ -1037,7 +1038,8 @@ static int anysee_rc_query(struct dvb_usb_device *d)
 		return ret;
 
 	if (ircode[0]) {
-		deb_rc("%s: key pressed %02x\n", __func__, ircode[1]);
+		dev_dbg(&d->udev->dev, "%s: key pressed %02x\n", __func__,
+				ircode[1]);
 		rc_keydown(d->rc_dev, 0x08 << 8 | ircode[1], 0);
 	}
 
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
index 834dc12..4ab4676 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.h
+++ b/drivers/media/usb/dvb-usb-v2/anysee.h
@@ -38,36 +38,6 @@
 #include "dvb_usb.h"
 #include "dvb_ca_en50221.h"
 
-#ifdef CONFIG_DVB_USB_DEBUG
-#define dprintk(var, level, args...) \
-	do { if ((var & level)) printk(args); } while (0)
-#define debug_dump(b, l, func) {\
-	int loop_; \
-	for (loop_ = 0; loop_ < l; loop_++) \
-		func("%02x ", b[loop_]); \
-	func("\n");\
-}
-#define DVB_USB_DEBUG_STATUS
-#else
-#define dprintk(args...)
-#define debug_dump(b, l, func)
-#define DVB_USB_DEBUG_STATUS " (debugging is not enabled)"
-#endif
-
-#define deb_info(args...) dprintk(dvb_usb_anysee_debug, 0x01, args)
-#define deb_xfer(args...) dprintk(dvb_usb_anysee_debug, 0x02, args)
-#define deb_rc(args...)   dprintk(dvb_usb_anysee_debug, 0x04, args)
-#define deb_reg(args...)  dprintk(dvb_usb_anysee_debug, 0x08, args)
-#define deb_i2c(args...)  dprintk(dvb_usb_anysee_debug, 0x10, args)
-#define deb_fw(args...)   dprintk(dvb_usb_anysee_debug, 0x20, args)
-
-#undef err
-#define err(format, arg...)  printk(KERN_ERR     DVB_USB_LOG_PREFIX ": " format "\n" , ## arg)
-#undef info
-#define info(format, arg...) printk(KERN_INFO    DVB_USB_LOG_PREFIX ": " format "\n" , ## arg)
-#undef warn
-#define warn(format, arg...) printk(KERN_WARNING DVB_USB_LOG_PREFIX ": " format "\n" , ## arg)
-
 enum cmd {
 	CMD_I2C_READ            = 0x33,
 	CMD_I2C_WRITE           = 0x31,
-- 
1.7.11.2

