Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:51949 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZKVNeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 08:34:22 -0500
Message-ID: <4B093DDD.5@freemail.hu>
Date: Sun, 22 Nov 2009 14:34:21 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca sunplus: propagate error for higher level
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemial.hu>

The function usb_control_msg() can fail any time. Propagate the error to
higher level software. Do not continue sending URBs after the first error.

The change was tested with Trust 610 LCD PowerC@m Zoom in webcam mode
(USB ID 06d6:0031).

Signed-off-by: Márton Németh <nm127@freemial.hu>
---
diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/sunplus.c
--- a/linux/drivers/media/video/gspca/sunplus.c	Sat Nov 21 12:01:36 2009 +0100
+++ b/linux/drivers/media/video/gspca/sunplus.c	Sun Nov 22 14:28:16 2009 +0100
@@ -486,18 +486,19 @@
 };

 /* read <len> bytes to gspca_dev->usb_buf */
-static void reg_r(struct gspca_dev *gspca_dev,
+static int reg_r(struct gspca_dev *gspca_dev,
 		  u8 req,
 		  u16 index,
 		  u16 len)
 {
+	int ret;
 #ifdef GSPCA_DEBUG
 	if (len > USB_BUF_SZ) {
 		err("reg_r: buffer overflow");
-		return;
+		return -EINVAL;
 	}
 #endif
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_rcvctrlpipe(gspca_dev->dev, 0),
 			req,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -505,23 +506,35 @@
 			index,
 			len ? gspca_dev->usb_buf : NULL, len,
 			500);
+	if (ret < 0)
+		err("reg_r: failed to read "
+		    "req=0x%X, index=0x%X, len=%u, error=%i\n",
+		    req, index, len, ret);
+	return ret;
 }

 /* write one byte */
-static void reg_w_1(struct gspca_dev *gspca_dev,
+static int reg_w_1(struct gspca_dev *gspca_dev,
 		   u8 req,
 		   u16 value,
 		   u16 index,
 		   u16 byte)
 {
+	int ret;
+
 	gspca_dev->usb_buf[0] = byte;
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			req,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			value, index,
 			gspca_dev->usb_buf, 1,
 			500);
+	if (ret < 0)
+		err("reg_w_1: failed to write "
+		    "req=0x%X, value=0x%X, index=0x%X, byte=0x%X, error: %i\n",
+		    req, value, index, byte, ret);
+	return ret;
 }

 /* write req / index / value */
@@ -580,18 +593,18 @@
 			index,
 			gspca_dev->usb_buf, length,
 			500);
-	if (ret < 0) {
+	if (ret < 0)
 		PDEBUG(D_ERR, "reg_read err %d", ret);
-		return -1;
-	}
-	return (gspca_dev->usb_buf[1] << 8) + gspca_dev->usb_buf[0];
+	else
+		ret = (gspca_dev->usb_buf[1] << 8) + gspca_dev->usb_buf[0];
+	return ret;
 }

 static int write_vector(struct gspca_dev *gspca_dev,
 			const struct cmd *data, int ncmds)
 {
 	struct usb_device *dev = gspca_dev->dev;
-	int ret;
+	int ret = 0;

 	while (--ncmds >= 0) {
 		ret = reg_w_riv(dev, data->req, data->idx, data->val);
@@ -599,11 +612,11 @@
 			PDEBUG(D_ERR,
 			   "Register write failed for 0x%02x, 0x%04x, 0x%04x",
 				data->req, data->val, data->idx);
-			return ret;
+			break;
 		}
 		data++;
 	}
-	return 0;
+	return ret;
 }

 static int spca50x_setup_qtable(struct gspca_dev *gspca_dev,
@@ -628,42 +641,57 @@
 	return 0;
 }

-static void spca504_acknowledged_command(struct gspca_dev *gspca_dev,
+static int spca504_acknowledged_command(struct gspca_dev *gspca_dev,
 			     u8 req, u16 idx, u16 val)
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int notdone;
+	int ret;

-	reg_w_riv(dev, req, idx, val);
-	notdone = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
-	reg_w_riv(dev, req, idx, val);
+	ret = reg_w_riv(dev, req, idx, val);
+	if (0 <= ret) {
+		ret = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
+		notdone = ret;
+	}
+	if (0 <= ret)
+		ret = reg_w_riv(dev, req, idx, val);

-	PDEBUG(D_FRAM, "before wait 0x%04x", notdone);
+	if (0 <= ret)
+		PDEBUG(D_FRAM, "before wait 0x%04x", notdone);

-	msleep(200);
-	notdone = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
-	PDEBUG(D_FRAM, "after wait 0x%04x", notdone);
+	if (0 <= ret) {
+		msleep(200);
+		ret = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
+		notdone = ret;
+		PDEBUG(D_FRAM, "after wait 0x%04x", notdone);
+	}
+	return ret;
 }

-static void spca504A_acknowledged_command(struct gspca_dev *gspca_dev,
+static int spca504A_acknowledged_command(struct gspca_dev *gspca_dev,
 			u8 req,
 			u16 idx, u16 val, u8 stat, u8 count)
 {
 	struct usb_device *dev = gspca_dev->dev;
 	int status;
 	u8 endcode;
+	int ret;

-	reg_w_riv(dev, req, idx, val);
-	status = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
+	ret = reg_w_riv(dev, req, idx, val);
+	if (0 <= ret)
+		status = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
+	else
+		status = ret;
+
 	endcode = stat;
 	PDEBUG(D_FRAM, "Status 0x%x Need 0x%04x", status, stat);
 	if (!count)
-		return;
+		return -EINVAL;
 	count = 200;
 	while (--count > 0) {
 		msleep(10);
 		/* gsmart mini2 write a each wait setting 1 ms is enought */
-/*		reg_w_riv(dev, req, idx, val); */
+/*		ret = reg_w_riv(dev, req, idx, val); */
 		status = reg_r_12(gspca_dev, 0x01, 0x0001, 1);
 		if (status == endcode) {
 			PDEBUG(D_FRAM, "status 0x%04x after wait %d",
@@ -671,103 +699,139 @@
 				break;
 		}
 	}
+	return ret;
 }

 static int spca504B_PollingDataReady(struct gspca_dev *gspca_dev)
 {
 	int count = 10;
+	int ret = 0;

 	while (--count > 0) {
-		reg_r(gspca_dev, 0x21, 0, 1);
-		if ((gspca_dev->usb_buf[0] & 0x01) == 0)
+		ret = reg_r(gspca_dev, 0x21, 0, 1);
+		if (0 <= ret) {
+			ret = gspca_dev->usb_buf[0];
+			if ((gspca_dev->usb_buf[0] & 0x01) == 0)
+				break;
+			msleep(10);
+		} else
 			break;
-		msleep(10);
 	}
-	return gspca_dev->usb_buf[0];
+	return ret;
 }

-static void spca504B_WaitCmdStatus(struct gspca_dev *gspca_dev)
+static int spca504B_WaitCmdStatus(struct gspca_dev *gspca_dev)
 {
 	int count = 50;
+	int ret = 0;

 	while (--count > 0) {
-		reg_r(gspca_dev, 0x21, 1, 1);
-		if (gspca_dev->usb_buf[0] != 0) {
-			reg_w_1(gspca_dev, 0x21, 0, 1, 0);
-			reg_r(gspca_dev, 0x21, 1, 1);
-			spca504B_PollingDataReady(gspca_dev);
+		ret = reg_r(gspca_dev, 0x21, 1, 1);
+		if (0 <= ret) {
+			if (gspca_dev->usb_buf[0] != 0) {
+				ret = reg_w_1(gspca_dev, 0x21, 0, 1, 0);
+				if (0 <= ret)
+					ret = reg_r(gspca_dev, 0x21, 1, 1);
+				if (0 <= ret)
+					ret = spca504B_PollingDataReady(gspca_dev);
+				break;
+			}
+			msleep(10);
+		} else
 			break;
-		}
-		msleep(10);
 	}
+	return ret;
 }

-static void spca50x_GetFirmware(struct gspca_dev *gspca_dev)
+static int spca50x_GetFirmware(struct gspca_dev *gspca_dev)
 {
 	u8 *data;
+	int ret;

 	data = gspca_dev->usb_buf;
-	reg_r(gspca_dev, 0x20, 0, 5);
-	PDEBUG(D_STREAM, "FirmWare : %d %d %d %d %d ",
-		data[0], data[1], data[2], data[3], data[4]);
-	reg_r(gspca_dev, 0x23, 0, 64);
-	reg_r(gspca_dev, 0x23, 1, 64);
+	ret = reg_r(gspca_dev, 0x20, 0, 5);
+	if (0 <= ret)
+		PDEBUG(D_STREAM, "FirmWare : %d %d %d %d %d ",
+			data[0], data[1], data[2], data[3], data[4]);
+	if (0 <= ret)
+		ret = reg_r(gspca_dev, 0x23, 0, 64);
+	if (0 <= ret)
+		ret = reg_r(gspca_dev, 0x23, 1, 64);
+	return ret;
 }

-static void spca504B_SetSizeType(struct gspca_dev *gspca_dev)
+static int spca504B_SetSizeType(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
 	u8 Size;
-	int rc;
+	int ret = 0;

 	Size = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
 	switch (sd->bridge) {
 	case BRIDGE_SPCA533:
-		reg_w_riv(dev, 0x31, 0, 0);
-		spca504B_WaitCmdStatus(gspca_dev);
-		rc = spca504B_PollingDataReady(gspca_dev);
-		spca50x_GetFirmware(gspca_dev);
-		reg_w_1(gspca_dev, 0x24, 0, 8, 2);		/* type */
-		reg_r(gspca_dev, 0x24, 8, 1);
-
-		reg_w_1(gspca_dev, 0x25, 0, 4, Size);
-		reg_r(gspca_dev, 0x25, 4, 1);			/* size */
-		rc = spca504B_PollingDataReady(gspca_dev);
+		ret = reg_w_riv(dev, 0x31, 0, 0);
+		if (0 <= ret)
+			ret = spca504B_WaitCmdStatus(gspca_dev);
+		if (0 <= ret)
+			ret = spca504B_PollingDataReady(gspca_dev);
+		if (0 <= ret)
+			ret = spca50x_GetFirmware(gspca_dev);
+		if (0 <= ret)
+			ret = reg_w_1(gspca_dev, 0x24, 0, 8, 2); /* type */
+		if (0 <= ret)
+			ret = reg_r(gspca_dev, 0x24, 8, 1);
+		if (0 <= ret)
+			ret = reg_w_1(gspca_dev, 0x25, 0, 4, Size);
+		if (0 <= ret)
+			ret = reg_r(gspca_dev, 0x25, 4, 1);	/* size */
+		if (0 <= ret)
+			ret = spca504B_PollingDataReady(gspca_dev);

 		/* Init the cam width height with some values get on init ? */
-		reg_w_riv(dev, 0x31, 0, 0x04);
-		spca504B_WaitCmdStatus(gspca_dev);
-		rc = spca504B_PollingDataReady(gspca_dev);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0x31, 0, 0x04);
+		if (0 <= ret)
+			ret = spca504B_WaitCmdStatus(gspca_dev);
+		if (0 <= ret)
+			ret = spca504B_PollingDataReady(gspca_dev);
 		break;
 	default:
 /* case BRIDGE_SPCA504B: */
 /* case BRIDGE_SPCA536: */
-		reg_w_1(gspca_dev, 0x25, 0, 4, Size);
-		reg_r(gspca_dev, 0x25, 4, 1);			/* size */
-		reg_w_1(gspca_dev, 0x27, 0, 0, 6);
-		reg_r(gspca_dev, 0x27, 0, 1);			/* type */
-		rc = spca504B_PollingDataReady(gspca_dev);
+		ret = reg_w_1(gspca_dev, 0x25, 0, 4, Size);
+		if (0 <= ret)
+			ret = reg_r(gspca_dev, 0x25, 4, 1);	/* size */
+		if (0 <= ret)
+			ret = reg_w_1(gspca_dev, 0x27, 0, 0, 6);
+		if (0 <= ret)
+			ret = reg_r(gspca_dev, 0x27, 0, 1);	/* type */
+		if (0 <= ret)
+			ret = spca504B_PollingDataReady(gspca_dev);
 		break;
 	case BRIDGE_SPCA504:
 		Size += 3;
 		if (sd->subtype == AiptekMiniPenCam13) {
 			/* spca504a aiptek */
-			spca504A_acknowledged_command(gspca_dev,
+			ret = spca504A_acknowledged_command(gspca_dev,
 						0x08, Size, 0,
 						0x80 | (Size & 0x0f), 1);
-			spca504A_acknowledged_command(gspca_dev,
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
 							1, 3, 0, 0x9f, 0);
 		} else {
-			spca504_acknowledged_command(gspca_dev, 0x08, Size, 0);
+			ret = spca504_acknowledged_command(gspca_dev,
+							0x08, Size, 0);
 		}
 		break;
 	case BRIDGE_SPCA504C:
 		/* capture mode */
-		reg_w_riv(dev, 0xa0, (0x0500 | (Size & 0x0f)), 0x00);
-		reg_w_riv(dev, 0x20, 0x01, 0x0500 | (Size & 0x0f));
+		ret = reg_w_riv(dev, 0xa0, (0x0500 | (Size & 0x0f)), 0x00);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0x20, 0x01, 0x0500 | (Size & 0x0f));
 		break;
 	}
+	return ret;
 }

 static void spca504_wait_status(struct gspca_dev *gspca_dev)
@@ -783,52 +847,59 @@
 	}
 }

-static void spca504B_setQtable(struct gspca_dev *gspca_dev)
+static int spca504B_setQtable(struct gspca_dev *gspca_dev)
 {
-	reg_w_1(gspca_dev, 0x26, 0, 0, 3);
-	reg_r(gspca_dev, 0x26, 0, 1);
-	spca504B_PollingDataReady(gspca_dev);
+	int ret;
+	ret = reg_w_1(gspca_dev, 0x26, 0, 0, 3);
+	if (0 <= ret)
+		ret = reg_r(gspca_dev, 0x26, 0, 1);
+	if (0 <= ret)
+		ret = spca504B_PollingDataReady(gspca_dev);
+	return ret;
 }

-static void setbrightness(struct gspca_dev *gspca_dev)
+static int setbrightness(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
 	u16 reg;

 	reg = sd->bridge == BRIDGE_SPCA536 ? 0x20f0 : 0x21a7;
-	reg_w_riv(dev, 0x00, reg, sd->brightness);
+	return reg_w_riv(dev, 0x00, reg, sd->brightness);
 }

-static void setcontrast(struct gspca_dev *gspca_dev)
+static int setcontrast(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
 	u16 reg;

 	reg = sd->bridge == BRIDGE_SPCA536 ? 0x20f1 : 0x21a8;
-	reg_w_riv(dev, 0x00, reg, sd->contrast);
+	return reg_w_riv(dev, 0x00, reg, sd->contrast);
 }

-static void setcolors(struct gspca_dev *gspca_dev)
+static int setcolors(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
 	u16 reg;

 	reg = sd->bridge == BRIDGE_SPCA536 ? 0x20f6 : 0x21ae;
-	reg_w_riv(dev, 0x00, reg, sd->colors);
+	return reg_w_riv(dev, 0x00, reg, sd->colors);
 }

-static void init_ctl_reg(struct gspca_dev *gspca_dev)
+static int init_ctl_reg(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
 	int pollreg = 1;
+	int ret;

-	setbrightness(gspca_dev);
-	setcontrast(gspca_dev);
-	setcolors(gspca_dev);
+	ret = setbrightness(gspca_dev);
+	if (0 <= ret)
+		ret = setcontrast(gspca_dev);
+	if (0 <= ret)
+		ret = setcolors(gspca_dev);

 	switch (sd->bridge) {
 	case BRIDGE_SPCA504:
@@ -838,18 +909,25 @@
 	default:
 /*	case BRIDGE_SPCA533: */
 /*	case BRIDGE_SPCA504B: */
-		reg_w_riv(dev, 0, 0x00, 0x21ad);	/* hue */
-		reg_w_riv(dev, 0, 0x01, 0x21ac);	/* sat/hue */
-		reg_w_riv(dev, 0, 0x00, 0x21a3);	/* gamma */
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x00, 0x21ad);	/* hue */
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x01, 0x21ac);	/* sat/hue */
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x00, 0x21a3);	/* gamma */
 		break;
 	case BRIDGE_SPCA536:
-		reg_w_riv(dev, 0, 0x40, 0x20f5);
-		reg_w_riv(dev, 0, 0x01, 0x20f4);
-		reg_w_riv(dev, 0, 0x00, 0x2089);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x40, 0x20f5);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x01, 0x20f4);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x00, 0x2089);
 		break;
 	}
 	if (pollreg)
-		spca504B_PollingDataReady(gspca_dev);
+		ret = spca504B_PollingDataReady(gspca_dev);
+	return ret;
 }

 /* this function is called at probe time */
@@ -858,6 +936,7 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct cam *cam;
+	int ret = 0;

 	cam = &gspca_dev->cam;

@@ -867,16 +946,18 @@
 	if (sd->subtype == AiptekMiniPenCam13) {
 /* try to get the firmware as some cam answer 2.0.1.2.2
  * and should be a spca504b then overwrite that setting */
-		reg_r(gspca_dev, 0x20, 0, 1);
-		switch (gspca_dev->usb_buf[0]) {
-		case 1:
-			break;		/* (right bridge/subtype) */
-		case 2:
-			sd->bridge = BRIDGE_SPCA504B;
-			sd->subtype = 0;
-			break;
-		default:
-			return -ENODEV;
+		ret = reg_r(gspca_dev, 0x20, 0, 1);
+		if (0 <= ret) {
+			switch (gspca_dev->usb_buf[0]) {
+			case 1:
+				break;		/* (right bridge/subtype) */
+			case 2:
+				sd->bridge = BRIDGE_SPCA504B;
+				sd->subtype = 0;
+				break;
+			default:
+				ret = -ENODEV;
+			}
 		}
 	}

@@ -905,7 +986,9 @@
 	sd->colors = COLOR_DEF;
 	sd->autogain = AUTOGAIN_DEF;
 	sd->quality = QUALITY_DEF;
-	return 0;
+	if (ret < 0)
+		ret = 0;
+	return ret;
 }

 /* this function is called at probe and resume time */
@@ -913,49 +996,65 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
-	int i, err_code;
+	int i;
 	u8 info[6];
+	int ret = 0;

 	switch (sd->bridge) {
 	case BRIDGE_SPCA504B:
-		reg_w_riv(dev, 0x1d, 0x00, 0);
-		reg_w_riv(dev, 0, 0x01, 0x2306);
-		reg_w_riv(dev, 0, 0x00, 0x0d04);
-		reg_w_riv(dev, 0, 0x00, 0x2000);
-		reg_w_riv(dev, 0, 0x13, 0x2301);
-		reg_w_riv(dev, 0, 0x00, 0x2306);
+		ret = reg_w_riv(dev, 0x1d, 0x00, 0);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x01, 0x2306);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x00, 0x0d04);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x00, 0x2000);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x13, 0x2301);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x00, 0x2306);
 		/* fall thru */
 	case BRIDGE_SPCA533:
-		spca504B_PollingDataReady(gspca_dev);
-		spca50x_GetFirmware(gspca_dev);
+		ret = spca504B_PollingDataReady(gspca_dev);
+		if (0 <= ret)
+			ret = spca50x_GetFirmware(gspca_dev);
 		break;
 	case BRIDGE_SPCA536:
-		spca50x_GetFirmware(gspca_dev);
-		reg_r(gspca_dev, 0x00, 0x5002, 1);
-		reg_w_1(gspca_dev, 0x24, 0, 0, 0);
-		reg_r(gspca_dev, 0x24, 0, 1);
-		spca504B_PollingDataReady(gspca_dev);
-		reg_w_riv(dev, 0x34, 0, 0);
-		spca504B_WaitCmdStatus(gspca_dev);
+		ret = spca50x_GetFirmware(gspca_dev);
+		if (0 <= ret)
+			ret = reg_r(gspca_dev, 0x00, 0x5002, 1);
+		if (0 <= ret)
+			ret = reg_w_1(gspca_dev, 0x24, 0, 0, 0);
+		if (0 <= ret)
+			ret = reg_r(gspca_dev, 0x24, 0, 1);
+		if (0 <= ret)
+			ret = spca504B_PollingDataReady(gspca_dev);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0x34, 0, 0);
+		if (0 <= ret)
+			ret = spca504B_WaitCmdStatus(gspca_dev);
 		break;
 	case BRIDGE_SPCA504C:	/* pccam600 */
 		PDEBUG(D_STREAM, "Opening SPCA504 (PC-CAM 600)");
-		reg_w_riv(dev, 0xe0, 0x0000, 0x0000);
-		reg_w_riv(dev, 0xe0, 0x0000, 0x0001);	/* reset */
+		ret = reg_w_riv(dev, 0xe0, 0x0000, 0x0000);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0xe0, 0x0000, 0x0001); /* reset */
 		spca504_wait_status(gspca_dev);
-		if (sd->subtype == LogitechClickSmart420)
-			write_vector(gspca_dev,
-				spca504A_clicksmart420_open_data,
-				ARRAY_SIZE(spca504A_clicksmart420_open_data));
-		else
-			write_vector(gspca_dev, spca504_pccam600_open_data,
-				ARRAY_SIZE(spca504_pccam600_open_data));
-		err_code = spca50x_setup_qtable(gspca_dev,
+		if (sd->subtype == LogitechClickSmart420) {
+			if (0 <= ret)
+				ret = write_vector(gspca_dev,
+				  spca504A_clicksmart420_open_data,
+				  ARRAY_SIZE(spca504A_clicksmart420_open_data));
+		} else {
+			if (0 <= ret)
+				ret = write_vector(gspca_dev,
+				  spca504_pccam600_open_data,
+				  ARRAY_SIZE(spca504_pccam600_open_data));
+		}
+		ret = spca50x_setup_qtable(gspca_dev,
 						qtable_creative_pccam);
-		if (err_code < 0) {
+		if (ret < 0)
 			PDEBUG(D_ERR|D_STREAM, "spca50x_setup_qtable failed");
-			return err_code;
-		}
 		break;
 	default:
 /*	case BRIDGE_SPCA504: */
@@ -971,41 +1070,51 @@
 				info[3], info[4], info[5]);
 			/* spca504a aiptek */
 			/* Set AE AWB Banding Type 3-> 50Hz 2-> 60Hz */
-			spca504A_acknowledged_command(gspca_dev, 0x24,
+			ret = spca504A_acknowledged_command(gspca_dev, 0x24,
 							8, 3, 0x9e, 1);
 			/* Twice sequencial need status 0xff->0x9e->0x9d */
-			spca504A_acknowledged_command(gspca_dev, 0x24,
-							8, 3, 0x9e, 0);
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+					0x24, 8, 3, 0x9e, 0);

-			spca504A_acknowledged_command(gspca_dev, 0x24,
-							0, 0, 0x9d, 1);
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+					0x24, 0, 0, 0x9d, 1);
 			/******************************/
 			/* spca504a aiptek */
-			spca504A_acknowledged_command(gspca_dev, 0x08,
-							6, 0, 0x86, 1);
-/*			reg_write (dev, 0, 0x2000, 0); */
-/*			reg_write (dev, 0, 0x2883, 1); */
-/*			spca504A_acknowledged_command (gspca_dev, 0x08,
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+					0x08, 6, 0, 0x86, 1);
+/*			ret = reg_write (dev, 0, 0x2000, 0); */
+/*			ret = reg_write (dev, 0, 0x2883, 1); */
+/*			ret = spca504A_acknowledged_command (gspca_dev, 0x08,
 							6, 0, 0x86, 1); */
-/*			spca504A_acknowledged_command (gspca_dev, 0x24,
+/*			ret = spca504A_acknowledged_command (gspca_dev, 0x24,
 							0, 0, 0x9D, 1); */
-			reg_w_riv(dev, 0x00, 0x270c, 0x05); /* L92 sno1t.txt */
-			reg_w_riv(dev, 0x00, 0x2310, 0x05);
-			spca504A_acknowledged_command(gspca_dev, 0x01,
-							0x0f, 0, 0xff, 0);
+			if (0 <= ret)
+				ret = reg_w_riv(dev, 0x00, 0x270c, 0x05);
+							/* L92 sno1t.txt */
+			if (0 <= ret)
+				ret = reg_w_riv(dev, 0x00, 0x2310, 0x05);
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+						0x01, 0x0f, 0, 0xff, 0);
 		}
 		/* setup qtable */
-		reg_w_riv(dev, 0, 0x2000, 0);
-		reg_w_riv(dev, 0, 0x2883, 1);
-		err_code = spca50x_setup_qtable(gspca_dev,
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0, 0x2000, 0);
+		if (0 <= ret)
+			reg_w_riv(dev, 0, 0x2883, 1);
+		if (0 <= ret)
+			ret = spca50x_setup_qtable(gspca_dev,
 						qtable_spca504_default);
-		if (err_code < 0) {
+		if (ret < 0)
 			PDEBUG(D_ERR, "spca50x_setup_qtable failed");
-			return err_code;
-		}
 		break;
 	}
-	return 0;
+	if (0 <= ret)
+		ret = 0;
+	return ret;
 }

 static int sd_start(struct gspca_dev *gspca_dev)
@@ -1015,6 +1124,7 @@
 	int enable;
 	int i;
 	u8 info[6];
+	int ret = 0;

 	/* create the JPEG header */
 	sd->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
@@ -1025,8 +1135,9 @@
 	jpeg_set_qual(sd->jpeg_hdr, sd->quality);

 	if (sd->bridge == BRIDGE_SPCA504B)
-		spca504B_setQtable(gspca_dev);
-	spca504B_SetSizeType(gspca_dev);
+		ret = spca504B_setQtable(gspca_dev);
+	if (0 <= ret)
+		ret = spca504B_SetSizeType(gspca_dev);
 	switch (sd->bridge) {
 	default:
 /*	case BRIDGE_SPCA504B: */
@@ -1036,15 +1147,21 @@
 		case MegapixV4:
 		case LogitechClickSmart820:
 		case MegaImageVI:
-			reg_w_riv(dev, 0xf0, 0, 0);
-			spca504B_WaitCmdStatus(gspca_dev);
-			reg_r(gspca_dev, 0xf0, 4, 0);
-			spca504B_WaitCmdStatus(gspca_dev);
+			if (0 <= ret)
+				ret = reg_w_riv(dev, 0xf0, 0, 0);
+			if (0 <= ret)
+				ret = spca504B_WaitCmdStatus(gspca_dev);
+			if (0 <= ret)
+				ret = reg_r(gspca_dev, 0xf0, 4, 0);
+			if (0 <= ret)
+				ret = spca504B_WaitCmdStatus(gspca_dev);
 			break;
 		default:
-			reg_w_riv(dev, 0x31, 0, 0x04);
-			spca504B_WaitCmdStatus(gspca_dev);
-			spca504B_PollingDataReady(gspca_dev);
+			ret = reg_w_riv(dev, 0x31, 0, 0x04);
+			if (0 <= ret)
+				ret = spca504B_WaitCmdStatus(gspca_dev);
+			if (0 <= ret)
+				ret = spca504B_PollingDataReady(gspca_dev);
 			break;
 		}
 		break;
@@ -1059,15 +1176,18 @@
 				info[3], info[4], info[5]);
 			/* spca504a aiptek */
 			/* Set AE AWB Banding Type 3-> 50Hz 2-> 60Hz */
-			spca504A_acknowledged_command(gspca_dev, 0x24,
+			ret = spca504A_acknowledged_command(gspca_dev, 0x24,
 							8, 3, 0x9e, 1);
 			/* Twice sequencial need status 0xff->0x9e->0x9d */
-			spca504A_acknowledged_command(gspca_dev, 0x24,
-							8, 3, 0x9e, 0);
-			spca504A_acknowledged_command(gspca_dev, 0x24,
-							0, 0, 0x9d, 1);
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+					0x24, 8, 3, 0x9e, 0);
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+					0x24, 0, 0, 0x9d, 1);
 		} else {
-			spca504_acknowledged_command(gspca_dev, 0x24, 8, 3);
+			ret = spca504_acknowledged_command(gspca_dev,
+					0x24, 8, 3);
 			for (i = 0; i < 6; i++)
 				info[i] = reg_r_1(gspca_dev, i);
 			PDEBUG(D_STREAM,
@@ -1075,65 +1195,92 @@
 				" Should be 1,0,2,2,0,0",
 				info[0], info[1], info[2],
 				info[3], info[4], info[5]);
-			spca504_acknowledged_command(gspca_dev, 0x24, 8, 3);
-			spca504_acknowledged_command(gspca_dev, 0x24, 0, 0);
+			if (0 <= ret)
+				ret = spca504_acknowledged_command(gspca_dev,
+						0x24, 8, 3);
+			if (0 <= ret)
+				ret = spca504_acknowledged_command(gspca_dev,
+						0x24, 0, 0);
 		}
-		spca504B_SetSizeType(gspca_dev);
-		reg_w_riv(dev, 0x00, 0x270c, 0x05);	/* L92 sno1t.txt */
-		reg_w_riv(dev, 0x00, 0x2310, 0x05);
+		if (0 <= ret)
+			ret = spca504B_SetSizeType(gspca_dev);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0x00, 0x270c, 0x05);
+							/* L92 sno1t.txt */
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0x00, 0x2310, 0x05);
 		break;
 	case BRIDGE_SPCA504C:
 		if (sd->subtype == LogitechClickSmart420) {
-			write_vector(gspca_dev,
-				spca504A_clicksmart420_init_data,
-				ARRAY_SIZE(spca504A_clicksmart420_init_data));
+			if (0 <= ret)
+				ret = write_vector(gspca_dev,
+				  spca504A_clicksmart420_init_data,
+				  ARRAY_SIZE(spca504A_clicksmart420_init_data));
 		} else {
-			write_vector(gspca_dev, spca504_pccam600_init_data,
-				ARRAY_SIZE(spca504_pccam600_init_data));
+			if (0 <= ret)
+				ret = write_vector(gspca_dev,
+				  spca504_pccam600_init_data,
+				  ARRAY_SIZE(spca504_pccam600_init_data));
 		}
 		enable = (sd->autogain ? 0x04 : 0x01);
-		reg_w_riv(dev, 0x0c, 0x0000, enable);	/* auto exposure */
-		reg_w_riv(dev, 0xb0, 0x0000, enable);	/* auto whiteness */
+		ret = reg_w_riv(dev, 0x0c, 0x0000, enable); /* auto exposure */
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0xb0, 0x0000, enable);
+							/* auto whiteness */

 		/* set default exposure compensation and whiteness balance */
-		reg_w_riv(dev, 0x30, 0x0001, 800);	/* ~ 20 fps */
-		reg_w_riv(dev, 0x30, 0x0002, 1600);
-		spca504B_SetSizeType(gspca_dev);
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0x30, 0x0001, 800); /* ~ 20 fps */
+		if (0 <= ret)
+			ret = reg_w_riv(dev, 0x30, 0x0002, 1600);
+		if (0 <= ret)
+			ret = spca504B_SetSizeType(gspca_dev);
 		break;
 	}
-	init_ctl_reg(gspca_dev);
-	return 0;
+	if (0 <= ret)
+		ret = init_ctl_reg(gspca_dev);
+	if (0 < ret)
+		ret = 0;
+	return ret;
 }

 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct usb_device *dev = gspca_dev->dev;
+	int ret;

 	switch (sd->bridge) {
 	default:
 /*	case BRIDGE_SPCA533: */
 /*	case BRIDGE_SPCA536: */
 /*	case BRIDGE_SPCA504B: */
-		reg_w_riv(dev, 0x31, 0, 0);
-		spca504B_WaitCmdStatus(gspca_dev);
-		spca504B_PollingDataReady(gspca_dev);
+		ret = reg_w_riv(dev, 0x31, 0, 0);
+		if (0 <= ret)
+			ret = spca504B_WaitCmdStatus(gspca_dev);
+		if (0 <= ret)
+			ret = spca504B_PollingDataReady(gspca_dev);
 		break;
 	case BRIDGE_SPCA504:
 	case BRIDGE_SPCA504C:
-		reg_w_riv(dev, 0x00, 0x2000, 0x0000);
+		ret = reg_w_riv(dev, 0x00, 0x2000, 0x0000);

 		if (sd->subtype == AiptekMiniPenCam13) {
 			/* spca504a aiptek */
-/*			spca504A_acknowledged_command(gspca_dev, 0x08,
+/*			ret = spca504A_acknowledged_command(gspca_dev, 0x08,
 							 6, 0, 0x86, 1); */
-			spca504A_acknowledged_command(gspca_dev, 0x24,
-							0x00, 0x00, 0x9d, 1);
-			spca504A_acknowledged_command(gspca_dev, 0x01,
-							0x0f, 0x00, 0xff, 1);
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+						0x24, 0x00, 0x00, 0x9d, 1);
+			if (0 <= ret)
+				ret = spca504A_acknowledged_command(gspca_dev,
+						0x01, 0x0f, 0x00, 0xff, 1);
 		} else {
-			spca504_acknowledged_command(gspca_dev, 0x24, 0, 0);
-			reg_w_riv(dev, 0x01, 0x000f, 0x0000);
+			if (0 <= ret)
+				ret = spca504_acknowledged_command(gspca_dev,
+						0x24, 0, 0);
+			if (0 <= ret)
+				ret = reg_w_riv(dev, 0x01, 0x000f, 0x0000);
 		}
 		break;
 	}
@@ -1243,11 +1390,14 @@
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret = 0;

 	sd->brightness = val;
 	if (gspca_dev->streaming)
-		setbrightness(gspca_dev);
-	return 0;
+		ret = setbrightness(gspca_dev);
+	if (0 <= ret)
+		ret = 0;
+	return ret;
 }

 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
@@ -1444,10 +1594,9 @@
 {
 	int ret;
 	ret = usb_register(&sd_driver);
-	if (ret < 0)
-		return ret;
-	PDEBUG(D_PROBE, "registered");
-	return 0;
+	if (0 <= ret)
+		PDEBUG(D_PROBE, "registered");
+	return ret;
 }
 static void __exit sd_mod_exit(void)
 {
