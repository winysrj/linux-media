Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:62556 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZAOC7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 21:59:46 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so1041169ewy.13
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2009 18:59:45 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: moinejf@free.fr
Subject: [PATCH 2/2] gspca: Add MR97310A driver
Date: Wed, 14 Jan 2009 20:59:41 -0600
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901142059.41383.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Kyle Guinn <elyk03@gmail.com>
# Date 1231906280 21600
# Node ID 09bce1e0dcac5bc99a2762288d879db9361377bc
# Parent  1bf7a4403e5f1cd10f12a69a9d9239f1bf4a58b6
gspca: Add MR97310A driver

From: Kyle Guinn <elyk03@gmail.com>

This patch adds support for USB webcams based on the MR97310A chip.  It was
tested with an Aiptek PenCam VGA+ webcam.

Priority: normal

Signed-off-by: Kyle Guinn <elyk03@gmail.com>

diff --git a/linux/Documentation/video4linux/gspca.txt b/linux/Documentation/video4linux/gspca.txt
--- a/linux/Documentation/video4linux/gspca.txt
+++ b/linux/Documentation/video4linux/gspca.txt
@@ -193,6 +193,7 @@
 spca500		08ca:0103	Aiptek PocketDV
 sunplus		08ca:0104	Aiptek PocketDVII 1.3
 sunplus		08ca:0106	Aiptek Pocket DV3100+
+mr97310a	08ca:0111	Aiptek PenCam VGA+
 sunplus		08ca:2008	Aiptek Mini PenCam 2 M
 sunplus		08ca:2010	Aiptek PocketCam 3M
 sunplus		08ca:2016	Aiptek PocketCam 2 Mega
diff --git a/linux/drivers/media/video/gspca/Kconfig b/linux/drivers/media/video/gspca/Kconfig
--- a/linux/drivers/media/video/gspca/Kconfig
+++ b/linux/drivers/media/video/gspca/Kconfig
@@ -55,6 +55,15 @@
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_mars.
+
+config USB_GSPCA_MR97310A
+	tristate "Mars-Semi MR97310A USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on the MR97310A chip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_mr97310a.
 
 config USB_GSPCA_OV519
 	tristate "OV519 USB Camera Driver"
diff --git a/linux/drivers/media/video/gspca/Makefile b/linux/drivers/media/video/gspca/Makefile
--- a/linux/drivers/media/video/gspca/Makefile
+++ b/linux/drivers/media/video/gspca/Makefile
@@ -1,50 +1,52 @@
-obj-$(CONFIG_USB_GSPCA)		+= gspca_main.o
-obj-$(CONFIG_USB_GSPCA_CONEX)	+= gspca_conex.o
-obj-$(CONFIG_USB_GSPCA_ETOMS)	+= gspca_etoms.o
-obj-$(CONFIG_USB_GSPCA_FINEPIX)	+= gspca_finepix.o
-obj-$(CONFIG_USB_GSPCA_MARS)	+= gspca_mars.o
-obj-$(CONFIG_USB_GSPCA_OV519)	+= gspca_ov519.o
-obj-$(CONFIG_USB_GSPCA_OV534)	+= gspca_ov534.o
-obj-$(CONFIG_USB_GSPCA_PAC207)	+= gspca_pac207.o
-obj-$(CONFIG_USB_GSPCA_PAC7311) += gspca_pac7311.o
-obj-$(CONFIG_USB_GSPCA_SONIXB)	+= gspca_sonixb.o
-obj-$(CONFIG_USB_GSPCA_SONIXJ)	+= gspca_sonixj.o
-obj-$(CONFIG_USB_GSPCA_SPCA500) += gspca_spca500.o
-obj-$(CONFIG_USB_GSPCA_SPCA501) += gspca_spca501.o
-obj-$(CONFIG_USB_GSPCA_SPCA505) += gspca_spca505.o
-obj-$(CONFIG_USB_GSPCA_SPCA506) += gspca_spca506.o
-obj-$(CONFIG_USB_GSPCA_SPCA508) += gspca_spca508.o
-obj-$(CONFIG_USB_GSPCA_SPCA561) += gspca_spca561.o
-obj-$(CONFIG_USB_GSPCA_SUNPLUS) += gspca_sunplus.o
-obj-$(CONFIG_USB_GSPCA_STK014)	+= gspca_stk014.o
-obj-$(CONFIG_USB_GSPCA_T613)	+= gspca_t613.o
-obj-$(CONFIG_USB_GSPCA_TV8532)	+= gspca_tv8532.o
-obj-$(CONFIG_USB_GSPCA_VC032X)	+= gspca_vc032x.o
-obj-$(CONFIG_USB_GSPCA_ZC3XX)	+= gspca_zc3xx.o
+obj-$(CONFIG_USB_GSPCA)          += gspca_main.o
+obj-$(CONFIG_USB_GSPCA_CONEX)    += gspca_conex.o
+obj-$(CONFIG_USB_GSPCA_ETOMS)    += gspca_etoms.o
+obj-$(CONFIG_USB_GSPCA_FINEPIX)  += gspca_finepix.o
+obj-$(CONFIG_USB_GSPCA_MARS)     += gspca_mars.o
+obj-$(CONFIG_USB_GSPCA_MR97310A) += gspca_mr97310a.o
+obj-$(CONFIG_USB_GSPCA_OV519)    += gspca_ov519.o
+obj-$(CONFIG_USB_GSPCA_OV534)    += gspca_ov534.o
+obj-$(CONFIG_USB_GSPCA_PAC207)   += gspca_pac207.o
+obj-$(CONFIG_USB_GSPCA_PAC7311)  += gspca_pac7311.o
+obj-$(CONFIG_USB_GSPCA_SONIXB)   += gspca_sonixb.o
+obj-$(CONFIG_USB_GSPCA_SONIXJ)   += gspca_sonixj.o
+obj-$(CONFIG_USB_GSPCA_SPCA500)  += gspca_spca500.o
+obj-$(CONFIG_USB_GSPCA_SPCA501)  += gspca_spca501.o
+obj-$(CONFIG_USB_GSPCA_SPCA505)  += gspca_spca505.o
+obj-$(CONFIG_USB_GSPCA_SPCA506)  += gspca_spca506.o
+obj-$(CONFIG_USB_GSPCA_SPCA508)  += gspca_spca508.o
+obj-$(CONFIG_USB_GSPCA_SPCA561)  += gspca_spca561.o
+obj-$(CONFIG_USB_GSPCA_SUNPLUS)  += gspca_sunplus.o
+obj-$(CONFIG_USB_GSPCA_STK014)   += gspca_stk014.o
+obj-$(CONFIG_USB_GSPCA_T613)     += gspca_t613.o
+obj-$(CONFIG_USB_GSPCA_TV8532)   += gspca_tv8532.o
+obj-$(CONFIG_USB_GSPCA_VC032X)   += gspca_vc032x.o
+obj-$(CONFIG_USB_GSPCA_ZC3XX)    += gspca_zc3xx.o
 
-gspca_main-objs			:= gspca.o
-gspca_conex-objs		:= conex.o
-gspca_etoms-objs		:= etoms.o
-gspca_finepix-objs		:= finepix.o
-gspca_mars-objs			:= mars.o
-gspca_ov519-objs		:= ov519.o
-gspca_ov534-objs		:= ov534.o
-gspca_pac207-objs		:= pac207.o
-gspca_pac7311-objs		:= pac7311.o
-gspca_sonixb-objs		:= sonixb.o
-gspca_sonixj-objs		:= sonixj.o
-gspca_spca500-objs		:= spca500.o
-gspca_spca501-objs		:= spca501.o
-gspca_spca505-objs		:= spca505.o
-gspca_spca506-objs		:= spca506.o
-gspca_spca508-objs		:= spca508.o
-gspca_spca561-objs		:= spca561.o
-gspca_stk014-objs		:= stk014.o
-gspca_sunplus-objs		:= sunplus.o
-gspca_t613-objs			:= t613.o
-gspca_tv8532-objs		:= tv8532.o
-gspca_vc032x-objs		:= vc032x.o
-gspca_zc3xx-objs		:= zc3xx.o
+gspca_main-objs     := gspca.o
+gspca_conex-objs    := conex.o
+gspca_etoms-objs    := etoms.o
+gspca_finepix-objs  := finepix.o
+gspca_mars-objs     := mars.o
+gspca_mr97310a-objs := mr97310a.o
+gspca_ov519-objs    := ov519.o
+gspca_ov534-objs    := ov534.o
+gspca_pac207-objs   := pac207.o
+gspca_pac7311-objs  := pac7311.o
+gspca_sonixb-objs   := sonixb.o
+gspca_sonixj-objs   := sonixj.o
+gspca_spca500-objs  := spca500.o
+gspca_spca501-objs  := spca501.o
+gspca_spca505-objs  := spca505.o
+gspca_spca506-objs  := spca506.o
+gspca_spca508-objs  := spca508.o
+gspca_spca561-objs  := spca561.o
+gspca_stk014-objs   := stk014.o
+gspca_sunplus-objs  := sunplus.o
+gspca_t613-objs     := t613.o
+gspca_tv8532-objs   := tv8532.o
+gspca_vc032x-objs   := vc032x.o
+gspca_zc3xx-objs    := zc3xx.o
 
-obj-$(CONFIG_USB_M5602)		+= m5602/
-obj-$(CONFIG_USB_STV06XX) 	+= stv06xx/
+obj-$(CONFIG_USB_M5602)   += m5602/
+obj-$(CONFIG_USB_STV06XX) += stv06xx/
diff --git a/linux/drivers/media/video/gspca/gspca.c b/linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c
+++ b/linux/drivers/media/video/gspca/gspca.c
@@ -332,6 +332,7 @@
 	case V4L2_PIX_FMT_JPEG:
 	case V4L2_PIX_FMT_SPCA561:
 	case V4L2_PIX_FMT_PAC207:
+	case V4L2_PIX_FMT_MR97310A:
 		return 1;
 	}
 	return 0;
diff --git a/linux/drivers/media/video/gspca/mr97310a.c b/linux/drivers/media/video/gspca/mr97310a.c
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/video/gspca/mr97310a.c
@@ -0,0 +1,390 @@
+/*
+ * Mars MR97310A library
+ *
+ * Copyright (C) 2009 Kyle Guinn <elyk03@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#define MODULE_NAME "mr97310a"
+
+#include "gspca.h"
+
+MODULE_AUTHOR("Kyle Guinn <elyk03@gmail.com>");
+MODULE_DESCRIPTION("GSPCA/Mars-Semi MR97310A USB Camera Driver");
+MODULE_LICENSE("GPL");
+
+/* specific webcam descriptor */
+struct sd {
+	struct gspca_dev gspca_dev;  /* !! must be the first item */
+
+	u8 sof_read;
+	u8 header_read;
+};
+
+/* V4L2 controls supported by the driver */
+static struct ctrl sd_ctrls[] = {
+};
+
+static struct v4l2_pix_format vga_mode[] = {
+	{160, 120, V4L2_PIX_FMT_MR97310A, V4L2_FIELD_NONE,
+		.bytesperline = 160,
+		.sizeimage = 160 * 120,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 4},
+	{176, 144, V4L2_PIX_FMT_MR97310A, V4L2_FIELD_NONE,
+		.bytesperline = 176,
+		.sizeimage = 176 * 144,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 3},
+	{320, 240, V4L2_PIX_FMT_MR97310A, V4L2_FIELD_NONE,
+		.bytesperline = 320,
+		.sizeimage = 320 * 240,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 2},
+	{352, 288, V4L2_PIX_FMT_MR97310A, V4L2_FIELD_NONE,
+		.bytesperline = 352,
+		.sizeimage = 352 * 288,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 1},
+	{640, 480, V4L2_PIX_FMT_MR97310A, V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 0},
+};
+
+/* the bytes to write are in gspca_dev->usb_buf */
+static int reg_w(struct gspca_dev *gspca_dev,
+		 __u16 index, int len)
+{
+	int rc;
+
+	rc = usb_bulk_msg(gspca_dev->dev,
+			  usb_sndbulkpipe(gspca_dev->dev, 4),
+			  gspca_dev->usb_buf, len, 0, 500);
+	if (rc < 0)
+		PDEBUG(D_ERR, "reg write [%02x] error %d", index, rc);
+	return rc;
+}
+
+/* this function is called at probe time */
+static int sd_config(struct gspca_dev *gspca_dev,
+		     const struct usb_device_id *id)
+{
+	struct cam *cam;
+
+	cam = &gspca_dev->cam;
+	cam->epaddr = 0x01;
+	cam->cam_mode = vga_mode;
+	cam->nmodes = ARRAY_SIZE(vga_mode);
+	return 0;
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	return 0;
+}
+
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	__u8 *data = gspca_dev->usb_buf;
+	int err_code;
+	int intpipe;
+
+	PDEBUG(D_STREAM, "camera start, iface %d, alt 8", gspca_dev->iface);
+	err_code = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 8);
+	if (err_code < 0) {
+		PDEBUG(D_ERR|D_STREAM, "Set packet size: set interface error");
+		return err_code;
+	}
+
+	/* Note:  register descriptions guessed from MR97113A driver */
+
+	data[0] = 0x01;
+	data[1] = 0x01;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x00;
+	data[1] = 0x0d;
+	data[2] = 0x01;
+	data[5] = 0x2b;
+	data[7] = 0x00;
+	data[9] = 0x50;  /* reg 8, no scale down */
+	data[10] = 0xc0;
+
+	switch (gspca_dev->width) {
+	case 160:
+		data[9] |= 0x0c;  /* reg 8, 4:1 scale down */
+		/* fall thru */
+	case 320:
+		data[9] |= 0x04;  /* reg 8, 2:1 scale down */
+		/* fall thru */
+	case 640:
+	default:
+		data[3] = 0x50;  /* reg 2, H size */
+		data[4] = 0x78;  /* reg 3, V size */
+		data[6] = 0x04;  /* reg 5, H start */
+		data[8] = 0x03;  /* reg 7, V start */
+		break;
+
+	case 176:
+		data[9] |= 0x04;  /* reg 8, 2:1 scale down */
+		/* fall thru */
+	case 352:
+		data[3] = 0x2c;  /* reg 2, H size */
+		data[4] = 0x48;  /* reg 3, V size */
+		data[6] = 0x94;  /* reg 5, H start */
+		data[8] = 0x63;  /* reg 7, V start */
+		break;
+	}
+
+	err_code = reg_w(gspca_dev, data[0], 11);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x0a;
+	data[1] = 0x80;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x14;
+	data[1] = 0x0a;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x1b;
+	data[1] = 0x00;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x15;
+	data[1] = 0x16;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x16;
+	data[1] = 0x10;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x17;
+	data[1] = 0x3a;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x18;
+	data[1] = 0x68;
+	err_code = reg_w(gspca_dev, data[0], 2);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x1f;
+	data[1] = 0x00;
+	data[2] = 0x02;
+	data[3] = 0x06;
+	data[4] = 0x59;
+	data[5] = 0x0c;
+	data[6] = 0x16;
+	data[7] = 0x00;
+	data[8] = 0x07;
+	data[9] = 0x00;
+	data[10] = 0x01;
+	err_code = reg_w(gspca_dev, data[0], 11);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x1f;
+	data[1] = 0x04;
+	data[2] = 0x11;
+	data[3] = 0x01;
+	err_code = reg_w(gspca_dev, data[0], 4);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x1f;
+	data[1] = 0x00;
+	data[2] = 0x0a;
+	data[3] = 0x00;
+	data[4] = 0x01;
+	data[5] = 0x00;
+	data[6] = 0x00;
+	data[7] = 0x01;
+	data[8] = 0x00;
+	data[9] = 0x0a;
+	err_code = reg_w(gspca_dev, data[0], 10);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x1f;
+	data[1] = 0x04;
+	data[2] = 0x11;
+	data[3] = 0x01;
+	err_code = reg_w(gspca_dev, data[0], 4);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x1f;
+	data[1] = 0x00;
+	data[2] = 0x12;
+	data[3] = 0x00;
+	data[4] = 0x63;
+	data[5] = 0x00;
+	data[6] = 0x70;
+	data[7] = 0x00;
+	data[8] = 0x01;
+	err_code = reg_w(gspca_dev, data[0], 10);
+	if (err_code < 0)
+		return err_code;
+
+	data[0] = 0x1f;
+	data[1] = 0x04;
+	data[2] = 0x11;
+	data[3] = 0x01;
+	err_code = reg_w(gspca_dev, data[0], 4);
+	if (err_code < 0)
+		return err_code;
+
+	sd->sof_read = 0;
+
+	intpipe = usb_sndintpipe(gspca_dev->dev, 0);
+	err_code = usb_clear_halt(gspca_dev->dev, intpipe);
+
+	data[0] = 0x00;
+	data[1] = 0x4d;  /* ISOC transfering enable... */
+	reg_w(gspca_dev, data[0], 2);
+	return err_code;
+}
+
+static void sd_stopN(struct gspca_dev *gspca_dev)
+{
+	int result;
+
+	gspca_dev->usb_buf[0] = 1;
+	gspca_dev->usb_buf[1] = 0;
+	result = reg_w(gspca_dev, gspca_dev->usb_buf[0], 2);
+	if (result < 0)
+		PDEBUG(D_ERR, "Camera Stop failed");
+}
+
+/* Include pac common sof detection functions */
+#include "pac_common.h"
+
+static void sd_pkt_scan(struct gspca_dev *gspca_dev,
+			struct gspca_frame *frame,    /* target */
+			__u8 *data,                   /* isoc packet */
+			int len)                      /* iso packet length */
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	unsigned char *sof;
+
+	sof = pac_find_sof(gspca_dev, data, len);
+	if (sof) {
+		int n;
+
+		/* finish decoding current frame */
+		n = sof - data;
+		if (n > sizeof pac_sof_marker)
+			n -= sizeof pac_sof_marker;
+		else
+			n = 0;
+		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
+					data, n);
+		sd->header_read = 0;
+		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
+		len -= sof - data;
+		data = sof;
+	}
+	if (sd->header_read < 7) {
+		int needed;
+
+		/* skip the rest of the header */
+		needed = 7 - sd->header_read;
+		if (len <= needed) {
+			sd->header_read += len;
+			return;
+		}
+		data += needed;
+		len -= needed;
+		sd->header_read = 7;
+	}
+
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
+}
+
+/* sub-driver description */
+static const struct sd_desc sd_desc = {
+	.name = MODULE_NAME,
+	.ctrls = sd_ctrls,
+	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.config = sd_config,
+	.init = sd_init,
+	.start = sd_start,
+	.stopN = sd_stopN,
+	.pkt_scan = sd_pkt_scan,
+};
+
+/* -- module initialisation -- */
+static const __devinitdata struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x08ca, 0x0111)},
+	{}
+};
+MODULE_DEVICE_TABLE(usb, device_table);
+
+/* -- device connect -- */
+static int sd_probe(struct usb_interface *intf,
+		    const struct usb_device_id *id)
+{
+	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
+			       THIS_MODULE);
+}
+
+static struct usb_driver sd_driver = {
+	.name = MODULE_NAME,
+	.id_table = device_table,
+	.probe = sd_probe,
+	.disconnect = gspca_disconnect,
+#ifdef CONFIG_PM
+	.suspend = gspca_suspend,
+	.resume = gspca_resume,
+#endif
+};
+
+/* -- module insert / remove -- */
+static int __init sd_mod_init(void)
+{
+	if (usb_register(&sd_driver) < 0)
+		return -1;
+	PDEBUG(D_PROBE, "registered");
+	return 0;
+}
+static void __exit sd_mod_exit(void)
+{
+	usb_deregister(&sd_driver);
+	PDEBUG(D_PROBE, "deregistered");
+}
+
+module_init(sd_mod_init);
+module_exit(sd_mod_exit);
