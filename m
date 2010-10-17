Return-path: <mchehab@pedra>
Received: from relay02.digicable.hu ([92.249.128.188]:57929 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab0JQOpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 10:45:10 -0400
Message-ID: <4CBB0BEF.1050005@freemail.hu>
Date: Sun, 17 Oct 2010 16:45:03 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC] gspca_sonixj: handle return values from USB subsystem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Márton Németh <nm127@freemail.hu>

The usb_control_msg() may return error at any time so it is necessary to handle
it. The error handling mechanism is taken from the pac7302.

The resulting driver was tested with hama AC-150 webcam (USB ID 0c45:6142).

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr d/drivers/media/video/gspca/sonixj.c e/drivers/media/video/gspca/sonixj.c
--- d/drivers/media/video/gspca/sonixj.c	2010-10-17 12:28:41.000000000 +0200
+++ e/drivers/media/video/gspca/sonixj.c	2010-10-17 16:28:38.000000000 +0200
@@ -1359,29 +1359,45 @@ static const u8 (*sensor_init[])[8] = {
 static void reg_r(struct gspca_dev *gspca_dev,
 		  u16 value, int len)
 {
+	int ret;
+
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
 		err("reg_r: buffer overflow");
 		return;
 	}
 #endif
-	usb_control_msg(gspca_dev->dev,
+	if (gspca_dev->usb_err < 0)
+		return;
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_rcvctrlpipe(gspca_dev->dev, 0),
 			0,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			value, 0,
 			gspca_dev->usb_buf, len,
 			500);
-	PDEBUG(D_USBI, "reg_r [%02x] -> %02x", value, gspca_dev->usb_buf[0]);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "reg_r(): "
+			"Failed to read %i registers from to 0x%x, error %i",
+			len, value, ret);
+		gspca_dev->usb_err = ret;
+	} else {
+		PDEBUG(D_USBI, "reg_r [%02x] -> %02x",
+			value, gspca_dev->usb_buf[0]);
+	}
 }

 static void reg_w1(struct gspca_dev *gspca_dev,
 		   u16 value,
 		   u8 data)
 {
+	int ret;
+
+	if (gspca_dev->usb_err < 0)
+		return;
 	PDEBUG(D_USBO, "reg_w1 [%04x] = %02x", value, data);
 	gspca_dev->usb_buf[0] = data;
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x08,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
@@ -1389,12 +1405,22 @@ static void reg_w1(struct gspca_dev *gsp
 			0,
 			gspca_dev->usb_buf, 1,
 			500);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "reg_w1(): "
+			"Failed to write register to 0x%x, error %i",
+			value, ret);
+		gspca_dev->usb_err = ret;
+	}
 }
 static void reg_w(struct gspca_dev *gspca_dev,
 			  u16 value,
 			  const u8 *buffer,
 			  int len)
 {
+	int ret;
+
+	if (gspca_dev->usb_err < 0)
+		return;
 	PDEBUG(D_USBO, "reg_w [%04x] = %02x %02x ..",
 		value, buffer[0], buffer[1]);
 #ifdef GSPCA_DEBUG
@@ -1404,20 +1430,29 @@ static void reg_w(struct gspca_dev *gspc
 	}
 #endif
 	memcpy(gspca_dev->usb_buf, buffer, len);
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x08,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			value, 0,
 			gspca_dev->usb_buf, len,
 			500);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "reg_w(): "
+			"Failed to write %i registers to 0x%x, error %i",
+			len, value, ret);
+		gspca_dev->usb_err = ret;
+	}
 }

 /* I2C write 1 byte */
 static void i2c_w1(struct gspca_dev *gspca_dev, u8 reg, u8 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;

+	if (gspca_dev->usb_err < 0)
+		return;
 	PDEBUG(D_USBO, "i2c_w1 [%02x] = %02x", reg, val);
 	switch (sd->sensor) {
 	case SENSOR_ADCM1700:
@@ -1436,7 +1471,7 @@ static void i2c_w1(struct gspca_dev *gsp
 	gspca_dev->usb_buf[5] = 0;
 	gspca_dev->usb_buf[6] = 0;
 	gspca_dev->usb_buf[7] = 0x10;
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x08,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
@@ -1444,22 +1479,37 @@ static void i2c_w1(struct gspca_dev *gsp
 			0,
 			gspca_dev->usb_buf, 8,
 			500);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "i2c_w1(): Failed to write "
+			"I2C register 0x%x, value 0x%X, error %i",
+			reg, val, ret);
+		gspca_dev->usb_err = ret;
+	}
 }

 /* I2C write 8 bytes */
 static void i2c_w8(struct gspca_dev *gspca_dev,
 		   const u8 *buffer)
 {
+	int ret;
+
+	if (gspca_dev->usb_err < 0)
+		return;
 	PDEBUG(D_USBO, "i2c_w8 [%02x] = %02x ..",
 		buffer[2], buffer[3]);
 	memcpy(gspca_dev->usb_buf, buffer, 8);
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x08,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			0x08, 0,		/* value, index */
 			gspca_dev->usb_buf, 8,
 			500);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "i2c_w8(): Failed to write "
+			"I2C registers, error %i", ret);
+		gspca_dev->usb_err = ret;
+	}
 	msleep(2);
 }

@@ -1915,7 +1965,7 @@ static int sd_init(struct gspca_dev *gsp

 	gspca_dev->ctrl_dis = ctrl_dis[sd->sensor];

-	return 0;
+	return gspca_dev->usb_err;
 }

 static u32 setexposure(struct gspca_dev *gspca_dev,
@@ -2289,6 +2339,7 @@ static void setjpegqual(struct gspca_dev
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, sc;
+	int ret;

 	if (sd->jpegqual < 50)
 		sc = 5000 / sd->jpegqual;
@@ -2300,23 +2351,35 @@ static void setjpegqual(struct gspca_dev
 	for (i = 0; i < 64; i++)
 		gspca_dev->usb_buf[i] =
 			(jpeg_head[JPEG_QT0_OFFSET + i] * sc + 50) / 100;
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x08,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			0x0100, 0,
 			gspca_dev->usb_buf, 64,
 			500);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "setjpegqual(): Failed to set JPEG quality, "
+			"error %i", ret);
+		gspca_dev->usb_err = ret;
+		return;
+	}
 	for (i = 0; i < 64; i++)
 		gspca_dev->usb_buf[i] =
 			(jpeg_head[JPEG_QT1_OFFSET + i] * sc + 50) / 100;
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0x08,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			0x0140, 0,
 			gspca_dev->usb_buf, 64,
 			500);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "setjpegqual(): Failed to set JPEG quality, "
+			"error %i", ret);
+		gspca_dev->usb_err = ret;
+		return;
+	}

 	sd->reg18 ^= 0x40;
 	reg_w1(gspca_dev, 0x18, sd->reg18);
@@ -2591,7 +2654,7 @@ static int sd_start(struct gspca_dev *gs
 	setcolors(gspca_dev);
 	setautogain(gspca_dev);
 	setfreq(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static void sd_stopN(struct gspca_dev *gspca_dev)
@@ -2754,7 +2817,7 @@ static int sd_setbrightness(struct gspca
 	sd->brightness = val;
 	if (gspca_dev->streaming)
 		setbrightness(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2772,7 +2835,7 @@ static int sd_setcontrast(struct gspca_d
 	sd->contrast = val;
 	if (gspca_dev->streaming)
 		setcontrast(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2790,7 +2853,7 @@ static int sd_setcolors(struct gspca_dev
 	sd->colors = val;
 	if (gspca_dev->streaming)
 		setcolors(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2808,7 +2871,7 @@ static int sd_setblue_balance(struct gsp
 	sd->blue = val;
 	if (gspca_dev->streaming)
 		setredblue(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getblue_balance(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2826,7 +2889,7 @@ static int sd_setred_balance(struct gspc
 	sd->red = val;
 	if (gspca_dev->streaming)
 		setredblue(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getred_balance(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2844,7 +2907,7 @@ static int sd_setgamma(struct gspca_dev
 	sd->gamma = val;
 	if (gspca_dev->streaming)
 		setgamma(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getgamma(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2862,7 +2925,7 @@ static int sd_setautogain(struct gspca_d
 	sd->autogain = val;
 	if (gspca_dev->streaming)
 		setautogain(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2880,7 +2943,7 @@ static int sd_setsharpness(struct gspca_
 	sd->sharpness = val;
 	if (gspca_dev->streaming)
 		setsharpness(sd);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getsharpness(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2898,7 +2961,7 @@ static int sd_setvflip(struct gspca_dev
 	sd->vflip = val;
 	if (gspca_dev->streaming)
 		sethvflip(sd);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2916,7 +2979,7 @@ static int sd_sethflip(struct gspca_dev
 	sd->hflip = val;
 	if (gspca_dev->streaming)
 		sethvflip(sd);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2934,7 +2997,7 @@ static int sd_setinfrared(struct gspca_d
 	sd->infrared = val;
 	if (gspca_dev->streaming)
 		setinfrared(sd);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getinfrared(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2952,7 +3015,7 @@ static int sd_setfreq(struct gspca_dev *
 	sd->freq = val;
 	if (gspca_dev->streaming)
 		setfreq(gspca_dev);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val)
@@ -2976,7 +3039,7 @@ static int sd_set_jcomp(struct gspca_dev
 		sd->quality = jcomp->quality;
 	if (gspca_dev->streaming)
 		jpeg_set_qual(sd->jpeg_hdr, sd->quality);
-	return 0;
+	return gspca_dev->usb_err;
 }

 static int sd_get_jcomp(struct gspca_dev *gspca_dev,
