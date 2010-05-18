Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0ERH3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 03:29:54 -0400
Received: by fxm10 with SMTP id 10so709270fxm.19
        for <linux-media@vger.kernel.org>; Tue, 18 May 2010 00:29:52 -0700 (PDT)
Date: Tue, 18 May 2010 17:30:11 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bee Hock Goh <beehock@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] xc5000, rework xc_write_reg
Message-ID: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/KP8fppPsPsOu1YiOn7s9qaC"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/KP8fppPsPsOu1YiOn7s9qaC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Rework xc_write_reg function for correct read register of the xc5000.
It is very useful for tm6000.

Tested for tm6000 and for saa7134 works well.

diff -r 8f5129efe974 linux/drivers/media/common/tuners/xc5000.c
--- a/linux/drivers/media/common/tuners/xc5000.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/media/common/tuners/xc5000.c	Tue May 18 11:14:55 2010 +1000
@@ -232,6 +232,26 @@
 	return 0;
 }
 
+static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
+{
+	u8 buf[2] = { reg >> 8, reg & 0xff };
+	u8 bval[2] = { 0, 0 };
+	struct i2c_msg msg[2] = {
+		{ .addr = priv->i2c_props.addr,
+			.flags = 0, .buf = &buf[0], .len = 2 },
+		{ .addr = priv->i2c_props.addr,
+			.flags = I2C_M_RD, .buf = &bval[0], .len = 2 },
+	};
+
+	if (i2c_transfer(priv->i2c_props.adap, msg, 2) != 2) {
+		printk(KERN_WARNING "xc5000: I2C read failed\n");
+		return -EREMOTEIO;
+	}
+
+	*val = (bval[0] << 8) | bval[1];
+	return XC_RESULT_SUCCESS;
+}
+
 static void xc_wait(int wait_ms)
 {
 	msleep(wait_ms);
@@ -275,20 +295,14 @@
 	if (result == XC_RESULT_SUCCESS) {
 		/* wait for busy flag to clear */
 		while ((WatchDogTimer > 0) && (result == XC_RESULT_SUCCESS)) {
-			buf[0] = 0;
-			buf[1] = XREG_BUSY;
-
-			result = xc_send_i2c_data(priv, buf, 2);
+			result = xc5000_readreg(priv, XREG_BUSY, buf);
 			if (result == XC_RESULT_SUCCESS) {
-				result = xc_read_i2c_data(priv, buf, 2);
-				if (result == XC_RESULT_SUCCESS) {
-					if ((buf[0] == 0) && (buf[1] == 0)) {
-						/* busy flag cleared */
+				if ((buf[0] == 0) && (buf[1] == 0)) {
+					/* busy flag cleared */
 					break;
-					} else {
-						xc_wait(5); /* wait 5 ms */
-						WatchDogTimer--;
-					}
+				} else {
+					xc_wait(5); /* wait 5 ms */
+					WatchDogTimer--;
 				}
 			}
 		}
@@ -534,25 +548,6 @@
 	return found;
 }
 
-static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
-{
-	u8 buf[2] = { reg >> 8, reg & 0xff };
-	u8 bval[2] = { 0, 0 };
-	struct i2c_msg msg[2] = {
-		{ .addr = priv->i2c_props.addr,
-			.flags = 0, .buf = &buf[0], .len = 2 },
-		{ .addr = priv->i2c_props.addr,
-			.flags = I2C_M_RD, .buf = &bval[0], .len = 2 },
-	};
-
-	if (i2c_transfer(priv->i2c_props.adap, msg, 2) != 2) {
-		printk(KERN_WARNING "xc5000: I2C read failed\n");
-		return -EREMOTEIO;
-	}
-
-	*val = (bval[0] << 8) | bval[1];
-	return XC_RESULT_SUCCESS;
-}
 
 static int xc5000_fwupload(struct dvb_frontend *fe)
 {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/KP8fppPsPsOu1YiOn7s9qaC
Content-Type: text/x-patch; name=xc5000_write_read.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xc5000_write_read.patch

diff -r 8f5129efe974 linux/drivers/media/common/tuners/xc5000.c
--- a/linux/drivers/media/common/tuners/xc5000.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/media/common/tuners/xc5000.c	Tue May 18 11:14:55 2010 +1000
@@ -232,6 +232,26 @@
 	return 0;
 }
 
+static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
+{
+	u8 buf[2] = { reg >> 8, reg & 0xff };
+	u8 bval[2] = { 0, 0 };
+	struct i2c_msg msg[2] = {
+		{ .addr = priv->i2c_props.addr,
+			.flags = 0, .buf = &buf[0], .len = 2 },
+		{ .addr = priv->i2c_props.addr,
+			.flags = I2C_M_RD, .buf = &bval[0], .len = 2 },
+	};
+
+	if (i2c_transfer(priv->i2c_props.adap, msg, 2) != 2) {
+		printk(KERN_WARNING "xc5000: I2C read failed\n");
+		return -EREMOTEIO;
+	}
+
+	*val = (bval[0] << 8) | bval[1];
+	return XC_RESULT_SUCCESS;
+}
+
 static void xc_wait(int wait_ms)
 {
 	msleep(wait_ms);
@@ -275,20 +295,14 @@
 	if (result == XC_RESULT_SUCCESS) {
 		/* wait for busy flag to clear */
 		while ((WatchDogTimer > 0) && (result == XC_RESULT_SUCCESS)) {
-			buf[0] = 0;
-			buf[1] = XREG_BUSY;
-
-			result = xc_send_i2c_data(priv, buf, 2);
+			result = xc5000_readreg(priv, XREG_BUSY, buf);
 			if (result == XC_RESULT_SUCCESS) {
-				result = xc_read_i2c_data(priv, buf, 2);
-				if (result == XC_RESULT_SUCCESS) {
-					if ((buf[0] == 0) && (buf[1] == 0)) {
-						/* busy flag cleared */
+				if ((buf[0] == 0) && (buf[1] == 0)) {
+					/* busy flag cleared */
 					break;
-					} else {
-						xc_wait(5); /* wait 5 ms */
-						WatchDogTimer--;
-					}
+				} else {
+					xc_wait(5); /* wait 5 ms */
+					WatchDogTimer--;
 				}
 			}
 		}
@@ -534,25 +548,6 @@
 	return found;
 }
 
-static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
-{
-	u8 buf[2] = { reg >> 8, reg & 0xff };
-	u8 bval[2] = { 0, 0 };
-	struct i2c_msg msg[2] = {
-		{ .addr = priv->i2c_props.addr,
-			.flags = 0, .buf = &buf[0], .len = 2 },
-		{ .addr = priv->i2c_props.addr,
-			.flags = I2C_M_RD, .buf = &bval[0], .len = 2 },
-	};
-
-	if (i2c_transfer(priv->i2c_props.adap, msg, 2) != 2) {
-		printk(KERN_WARNING "xc5000: I2C read failed\n");
-		return -EREMOTEIO;
-	}
-
-	*val = (bval[0] << 8) | bval[1];
-	return XC_RESULT_SUCCESS;
-}
 
 static int xc5000_fwupload(struct dvb_frontend *fe)
 {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/KP8fppPsPsOu1YiOn7s9qaC--
