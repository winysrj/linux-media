Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8UIjVwW028571
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 14:45:31 -0400
Received: from pne-smtpout1-sn1.fre.skanova.net
	(pne-smtpout1-sn1.fre.skanova.net [81.228.11.98])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8UIjQeO002123
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 14:45:27 -0400
Message-ID: <48E273C3.5030902@gmail.com>
Date: Tue, 30 Sep 2008 20:45:23 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: m560x-driver-devel@sourceforge.net
Subject: [PATCH]Add support for the ALi m5602 usb bridge   
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

This patch adds support for the ALi m5602 usb bridge and is based on the gspca framework.
It contains code for communicating with 5 different sensors:
OmniVision OV9650, Pixel Plus PO1030, Samsung S5K83A, S5K4AA and finally Micron MT9M111.

Regards,
Erik Andrén

diff -r 24bc99070e97 linux/Documentation/video4linux/m5602.txt
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/Documentation/video4linux/m5602.txt	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,12 @@
+This document describes the ALi m5602 bridge connected
+to the following supported sensors:
+OmniVision OV9650,
+Samsung s5k83a,
+Samsung s5k4aa,
+Micron mt9m111,
+Pixel plus PO1030
+
+This driver mimics the windows drivers, which have a braindead implementation sending bayer-encoded frames at VGA resolution.
+In a perfect world we should be able to reprogram the m5602 and the connected sensor in hardware instead, supporting a range of resolutions and pixelformats
+
+Anyway, have fun and please report any bugs to m560x-driver-devel@lists.sourceforge.net
diff -r 24bc99070e97 linux/drivers/media/video/gspca/Kconfig
- --- a/linux/drivers/media/video/gspca/Kconfig	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/gspca/Kconfig	Tue Sep 30 07:57:00 2008 +0200
@@ -11,3 +11,6 @@
 
 	  To compile this driver as modules, choose M here: the
 	  modules will be called gspca_xxxx.
+
+source "drivers/media/video/gspca/m5602/Kconfig"
+
diff -r 24bc99070e97 linux/drivers/media/video/gspca/Makefile
- --- a/linux/drivers/media/video/gspca/Makefile	Mon Sep 29 05:25:40 2008 +0000
+++ b/linux/drivers/media/video/gspca/Makefile	Tue Sep 30 07:57:00 2008 +0200
@@ -27,3 +27,6 @@
 gspca_tv8532-objs := tv8532.o
 gspca_vc032x-objs := vc032x.o
 gspca_zc3xx-objs := zc3xx.o
+
+obj-$(CONFIG_USB_M5602)         += m5602/
+
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/Kconfig
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/Kconfig	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,11 @@
+config USB_M5602
+	tristate "USB ALi m5602 Webcam support"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on the ALi m5602 connected
+	  to various image sensors.
+
+	  See <file:Documentation/video4linux/m5602.txt> for more info.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca-m5602.
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/Makefile
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/Makefile	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,8 @@
+obj-$(CONFIG_USB_M5602) += gspca_m5602.o
+
+gspca_m5602-objs := m5602_core.o \
+		    m5602_ov9650.o \
+		    m5602_mt9m111.o \
+		    m5602_po1030.o \
+		    m5602_s5k83a.o \
+		    m5602_s5k4aa.o
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_bridge.h
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_bridge.h	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,180 @@
+/*
+ * USB Driver for ALi m5602 based webcams
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef M5602_BRIDGE_H_
+#define M5602_BRIDGE_H_
+
+#include "gspca.h"
+
+#define MODULE_NAME "ALi m5602"
+
+/*****************************************************************************/
+
+#undef PDEBUG
+#undef info
+#undef err
+
+#define err(format, arg...) printk(KERN_ERR KBUILD_MODNAME ": " \
+	format "\n" , ## arg)
+#define info(format, arg...) printk(KERN_INFO KBUILD_MODNAME ": " \
+	format "\n" , ## arg)
+
+/* Debug parameters */
+#define DBG_INIT 0x1
+#define DBG_PROBE 0x2
+#define DBG_V4L2 0x4
+#define DBG_TRACE 0x8
+#define DBG_DATA 0x10
+#define DBG_V4L2_CID 0x20
+#define DBG_GSPCA 0x40
+
+#define PDEBUG(level, fmt, args...) \
+	do { \
+		if (debug & level)     \
+			info("[%s:%d] " fmt, __func__, __LINE__ , \
+			## args); \
+	} while (0)
+
+/*****************************************************************************/
+
+#define M5602_XB_SENSOR_TYPE 0x00
+#define M5602_XB_SENSOR_CTRL 0x01
+#define M5602_XB_LINE_OF_FRAME_H 0x02
+#define M5602_XB_LINE_OF_FRAME_L 0x03
+#define M5602_XB_PIX_OF_LINE_H 0x04
+#define M5602_XB_PIX_OF_LINE_L 0x05
+#define M5602_XB_VSYNC_PARA 0x06
+#define M5602_XB_HSYNC_PARA 0x07
+#define M5602_XB_TEST_MODE_1 0x08
+#define M5602_XB_TEST_MODE_2 0x09
+#define M5602_XB_SIG_INI 0x0a
+#define M5602_XB_DS_PARA 0x0e
+#define M5602_XB_TRIG_PARA 0x0f
+#define M5602_XB_CLK_PD 0x10
+#define M5602_XB_MCU_CLK_CTRL 0x12
+#define M5602_XB_MCU_CLK_DIV 0x13
+#define M5602_XB_SEN_CLK_CTRL 0x14
+#define M5602_XB_SEN_CLK_DIV 0x15
+#define M5602_XB_AUD_CLK_CTRL 0x16
+#define M5602_XB_AUD_CLK_DIV 0x17
+#define M5602_XB_DEVCTR1 0x41
+#define M5602_XB_EPSETR0 0x42
+#define M5602_XB_EPAFCTR 0x47
+#define M5602_XB_EPBFCTR 0x49
+#define M5602_XB_EPEFCTR 0x4f
+#define M5602_XB_TEST_REG 0x53
+#define M5602_XB_ALT2SIZE 0x54
+#define M5602_XB_ALT3SIZE 0x55
+#define M5602_XB_OBSFRAME 0x56
+#define M5602_XB_PWR_CTL 0x59
+#define M5602_XB_ADC_CTRL 0x60
+#define M5602_XB_ADC_DATA 0x61
+#define M5602_XB_MISC_CTRL 0x62
+#define M5602_XB_SNAPSHOT 0x63
+#define M5602_XB_SCRATCH_1 0x64
+#define M5602_XB_SCRATCH_2 0x65
+#define M5602_XB_SCRATCH_3 0x66
+#define M5602_XB_SCRATCH_4 0x67
+#define M5602_XB_I2C_CTRL 0x68
+#define M5602_XB_I2C_CLK_DIV 0x69
+#define M5602_XB_I2C_DEV_ADDR 0x6a
+#define M5602_XB_I2C_REG_ADDR 0x6b
+#define M5602_XB_I2C_DATA 0x6c
+#define M5602_XB_I2C_STATUS 0x6d
+#define M5602_XB_GPIO_DAT_H 0x70
+#define M5602_XB_GPIO_DAT_L 0x71
+#define M5602_XB_GPIO_DIR_H 0x72
+#define M5602_XB_GPIO_DIR_L 0x73
+#define M5602_XB_GPIO_EN_H 0x74
+#define M5602_XB_GPIO_EN_L 0x75
+#define M5602_XB_GPIO_DAT 0x76
+#define M5602_XB_GPIO_DIR 0x77
+#define M5602_XB_MISC_CTL 0x70
+
+#define I2C_BUSY 0x80
+
+/*****************************************************************************/
+
+/* Driver info */
+#define DRIVER_AUTHOR "ALi m5602 Linux Driver Project"
+#define DRIVER_DESC "ALi m5602 webcam driver"
+
+#define M5602_ISOC_ENDPOINT_ADDR 0x81
+#define M5602_INTR_ENDPOINT_ADDR 0x82
+
+#define M5602_MAX_FRAMES	32
+#define M5602_URBS		2
+#define M5602_ISOC_PACKETS	14
+
+#define M5602_URB_TIMEOUT	msecs_to_jiffies(2 * M5602_ISOC_PACKETS)
+#define M5602_URB_MSG_TIMEOUT   5000
+#define M5602_FRAME_TIMEOUT	2
+
+/*****************************************************************************/
+
+/* A skeleton used for sending messages to the m5602 bridge */
+static const unsigned char bridge_urb_skeleton[] = {
+	0x13, 0x00, 0x81, 0x00
+};
+
+/* A skeleton used for sending messages to the sensor */
+static const unsigned char sensor_urb_skeleton[] = {
+	0x23, M5602_XB_GPIO_EN_H, 0x81, 0x06,
+	0x23, M5602_XB_MISC_CTRL, 0x81, 0x80,
+	0x13, M5602_XB_I2C_DEV_ADDR, 0x81, 0x00,
+	0x13, M5602_XB_I2C_REG_ADDR, 0x81, 0x00,
+	0x13, M5602_XB_I2C_DATA, 0x81, 0x00,
+	0x13, M5602_XB_I2C_CTRL, 0x81, 0x11
+};
+
+/* m5602 device descriptor, currently it just wraps the m5602_camera struct */
+struct sd {
+	struct gspca_dev gspca_dev;
+
+	/* The name of the m5602 camera */
+	char *name;
+
+	/* A pointer to the currently connected sensor */
+	struct m5602_sensor *sensor;
+
+	/* The current frame's id, used to detect frame boundaries */
+	u8 frame_id;
+
+	/* The current frame count */
+	u32 frame_count;
+};
+
+int m5602_read_bridge(
+	struct sd *sd, u8 address, u8 *i2c_data);
+
+int m5602_write_bridge(
+	struct sd *sd, u8 address, u8 i2c_data);
+
+int m5602_configure(struct gspca_dev *gspca_dev,
+			   const struct usb_device_id *id);
+
+int m5602_init(struct gspca_dev *gspca_dev);
+
+void m5602_start_transfer(struct gspca_dev *gspca_dev);
+
+void m5602_stop_transfer(struct gspca_dev *gspca_dev);
+
+void m5602_urb_complete(struct gspca_dev *gspca_dev, struct gspca_frame *frame,
+			__u8 *data, int len);
+
+#endif
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_core.c
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_core.c	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,321 @@
+/*
+ * USB Driver for ALi m5602 based webcams
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include "m5602_ov9650.h"
+#include "m5602_mt9m111.h"
+#include "m5602_po1030.h"
+#include "m5602_s5k83a.h"
+#include "m5602_s5k4aa.h"
+
+/* Kernel module parameters */
+int force_sensor = 0;
+int dump_bridge;
+int dump_sensor;
+unsigned int debug;
+
+static const __devinitdata struct usb_device_id m5602_table[] = {
+	{USB_DEVICE(0x0402, 0x5602)},
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, m5602_table);
+
+/* sub-driver description, the ctrl and nctrl is filled at probe time */
+static struct sd_desc sd_desc = {
+	.name		= MODULE_NAME,
+	.config		= m5602_configure,
+	.init		= m5602_init,
+	.start		= m5602_start_transfer,
+	.stopN		= m5602_stop_transfer,
+	.pkt_scan	= m5602_urb_complete
+};
+
+/* Reads a byte from the m5602 */
+int m5602_read_bridge(struct sd *sd, u8 address, u8 *i2c_data)
+{
+	int err;
+	struct usb_device *udev = sd->gspca_dev.dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	err = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+			      0x04, 0xc0, 0x14,
+			      0x8100 + address, buf,
+			      1, M5602_URB_MSG_TIMEOUT);
+	*i2c_data = buf[0];
+
+	PDEBUG(DBG_TRACE, "Reading bridge register 0x%x containing 0x%x",
+	       address, *i2c_data);
+
+	/* usb_control_msg(...) returns the number of bytes sent upon success,
+	mask that and return zero upon success instead*/
+	return (err < 0) ? err : 0;
+}
+
+/* Writes a byte to to the m5602 */
+int m5602_write_bridge(struct sd *sd, u8 address, u8 i2c_data)
+{
+	int err;
+	struct usb_device *udev = sd->gspca_dev.dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	PDEBUG(DBG_TRACE, "Writing bridge register 0x%x with 0x%x",
+	       address, i2c_data);
+
+	memcpy(buf, bridge_urb_skeleton,
+	       sizeof(bridge_urb_skeleton));
+	buf[1] = address;
+	buf[3] = i2c_data;
+
+	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+				0x04, 0x40, 0x19,
+				0x0000, buf,
+				4, M5602_URB_MSG_TIMEOUT);
+
+	/* usb_control_msg(...) returns the number of bytes sent upon success,
+	   mask that and return zero upon success instead */
+	return (err < 0) ? err : 0;
+}
+
+/* Dump all the registers of the m5602 bridge,
+   unfortunately this breaks the camera until it's power cycled */
+static void m5602_dump_bridge(struct sd *sd)
+{
+	int i;
+	for (i = 0; i < 0x80; i++) {
+		unsigned char val = 0;
+		m5602_read_bridge(sd, i, &val);
+		info("ALi m5602 address 0x%x contains 0x%x", i, val);
+	}
+	info("Warning: The camera probably won't work until it's power cycled");
+}
+
+int m5602_probe_sensor(struct sd *sd)
+{
+	/* Try the po1030 */
+	sd->sensor = &po1030;
+	if (!sd->sensor->probe(sd)) {
+		sd_desc.ctrls = po1030.ctrls;
+		sd_desc.nctrls = po1030.nctrls;
+		return 0;
+	}
+
+	/* Try the mt9m111 sensor */
+	sd->sensor = &mt9m111;
+	if (!sd->sensor->probe(sd)) {
+		sd_desc.ctrls = mt9m111.ctrls;
+		sd_desc.nctrls = mt9m111.nctrls;
+		return 0;
+	}
+
+	/* Try the s5k4aa */
+	sd->sensor = &s5k4aa;
+	if (!sd->sensor->probe(sd)) {
+		sd_desc.ctrls = s5k4aa.ctrls;
+		sd_desc.nctrls = s5k4aa.nctrls;
+		return 0;
+	}
+
+	/* Try the ov9650 */
+	sd->sensor = &ov9650;
+	if (!sd->sensor->probe(sd)) {
+		sd_desc.ctrls = ov9650.ctrls;
+		sd_desc.nctrls = ov9650.nctrls;
+		return 0;
+	}
+
+	/* Try the s5k83a */
+	sd->sensor = &s5k83a;
+	if (!sd->sensor->probe(sd)) {
+		sd_desc.ctrls = s5k83a.ctrls;
+		sd_desc.nctrls = s5k83a.nctrls;
+		return 0;
+	}
+
+
+	/* More sensor probe function goes here */
+	info("Failed to find a sensor");
+	sd->sensor = NULL;
+	return -ENODEV;
+}
+
+int m5602_init(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int err;
+
+	PDEBUG(DBG_TRACE, "Initializing ALi m5602 webcam");
+	/* Run the init sequence */
+	err = sd->sensor->init(sd);
+
+	return err;
+}
+
+void m5602_start_transfer(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	/* Send start command to the camera */
+	const u8 buffer[4] = {0x13, 0xf9, 0x0f, 0x01};
+	memcpy(buf, buffer, sizeof(buffer));
+	usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
+			0x04, 0x40, 0x19, 0x0000, buf,
+			4, M5602_URB_MSG_TIMEOUT);
+
+	PDEBUG(DBG_V4L2, "Transfer started");
+}
+
+void m5602_urb_complete(struct gspca_dev *gspca_dev, struct gspca_frame *frame,
+			__u8 *data, int len)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (len < 6) {
+		PDEBUG(DBG_DATA, "Packet is less than 6 bytes");
+		return;
+	}
+
+	/* Frame delimiter: ff xx xx xx ff ff */
+	if (data[0] == 0xff && data[4] == 0xff && data[5] == 0xff &&
+	    data[2] != sd->frame_id) {
+		PDEBUG(DBG_DATA, "Frame delimiter detected");
+		sd->frame_id = data[2];
+
+		/* Remove the extra fluff appended on each header */
+		data += 6;
+		len -= 6;
+
+		/* Complete the last frame (if any) */
+		frame = gspca_frame_add(gspca_dev, LAST_PACKET,
+					frame, data, 0);
+
+		/* Create a new frame */
+		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, len);
+
+		PDEBUG(DBG_V4L2, "Starting new frame. First urb contained %d",
+		       len);
+
+	} else {
+		int cur_frame_len = frame->data_end - frame->data;
+
+		/* Remove urb header */
+		data += 4;
+		len -= 4;
+
+		if (cur_frame_len + len <= frame->v4l2_buf.length) {
+			PDEBUG(DBG_DATA, "Continuing frame copying %d bytes",
+			       len);
+
+			gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+					data, len);
+		} else if (frame->v4l2_buf.length - cur_frame_len > 0) {
+			/* Add the remaining data up to frame size */
+			gspca_frame_add(gspca_dev, INTER_PACKET, frame, data,
+					frame->v4l2_buf.length - cur_frame_len);
+		}
+	}
+}
+
+void m5602_stop_transfer(struct gspca_dev *gspca_dev)
+{
+	/* Is there are a command to stop a data transfer? */
+}
+
+/* this function is called at probe time */
+int m5602_configure(struct gspca_dev *gspca_dev,
+			   const struct usb_device_id *id)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct cam *cam;
+	int err;
+
+	PDEBUG(DBG_GSPCA, "m5602_configure start");
+	cam = &gspca_dev->cam;
+	cam->epaddr = M5602_ISOC_ENDPOINT_ADDR;
+
+	if (dump_bridge)
+		m5602_dump_bridge(sd);
+
+	/* Probe sensor */
+	err = m5602_probe_sensor(sd);
+	if (err)
+		goto fail;
+
+	PDEBUG(DBG_GSPCA, "m5602_configure end");
+	return 0;
+
+fail:
+	PDEBUG(DBG_GSPCA, "m5602_configure failed");
+	cam->cam_mode = NULL;
+	cam->nmodes = 0;
+
+	return err;
+}
+
+static int m5602_probe(struct usb_interface *intf,
+		       const struct usb_device_id *id)
+{
+	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
+			       THIS_MODULE);
+}
+
+static struct usb_driver sd_driver = {
+	.name = MODULE_NAME,
+	.id_table = m5602_table,
+	.probe = m5602_probe,
+#ifdef CONFIG_PM
+	.suspend = gspca_suspend,
+	.resume = gspca_resume,
+#endif
+	.disconnect = gspca_disconnect
+};
+
+/* -- module insert / remove -- */
+static int __init mod_m5602_init(void)
+{
+	if (usb_register(&sd_driver) < 0)
+		return -1;
+	PDEBUG(D_PROBE, "m5602 module registered");
+	return 0;
+}
+static void __exit mod_m5602_exit(void)
+{
+	usb_deregister(&sd_driver);
+	PDEBUG(D_PROBE, "m5602 module deregistered");
+}
+
+module_init(mod_m5602_init);
+module_exit(mod_m5602_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "toggles debug on/off");
+
+module_param(force_sensor, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(force_sensor,
+		"force detection of sensor, "
+		"1 = OV9650, 2 = S5K83A, 3 = S5K4AA, 4 = MT9M111, 5 = PO1030");
+
+module_param(dump_bridge, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(dump_bridge, "Dumps all usb bridge registers at startup");
+
+module_param(dump_sensor, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(dump_sensor, "Dumps all usb sensor registers "
+		"at startup providing a sensor is found");
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_mt9m111.c
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_mt9m111.c	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,343 @@
+/*
+ * Driver for the mt9m111 sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include "m5602_mt9m111.h"
+
+int mt9m111_probe(struct sd *sd)
+{
+	u8 data[2] = {0x00, 0x00};
+	int i;
+
+	if (force_sensor) {
+		if (force_sensor == MT9M111_SENSOR) {
+			info("Forcing a %s sensor", mt9m111.name);
+			goto sensor_found;
+		}
+		/* If we want to force another sensor, don't try to probe this
+		 * one */
+		return -ENODEV;
+	}
+
+	info("Probing for a mt9m111 sensor");
+
+	/* Do the preinit */
+	for (i = 0; i < ARRAY_SIZE(preinit_mt9m111); i++) {
+		if (preinit_mt9m111[i][0] == BRIDGE) {
+			m5602_write_bridge(sd,
+				preinit_mt9m111[i][1],
+				preinit_mt9m111[i][2]);
+		} else {
+			data[0] = preinit_mt9m111[i][2];
+			data[1] = preinit_mt9m111[i][3];
+			mt9m111_write_sensor(sd,
+				preinit_mt9m111[i][1], data, 2);
+		}
+	}
+
+	if (mt9m111_read_sensor(sd, MT9M111_SC_CHIPVER, data, 2))
+		return -ENODEV;
+
+	if ((data[0] == 0x14) && (data[1] == 0x3a)) {
+		info("Detected a mt9m111 sensor");
+		goto sensor_found;
+	}
+
+	return -ENODEV;
+
+sensor_found:
+	sd->gspca_dev.cam.cam_mode = mt9m111.modes;
+	sd->gspca_dev.cam.nmodes = mt9m111.nmodes;
+	return 0;
+}
+
+int mt9m111_init(struct sd *sd)
+{
+	int i, err;
+
+	/* Init the sensor */
+	for (i = 0; i < ARRAY_SIZE(init_mt9m111); i++) {
+		u8 data[2];
+
+		if (init_mt9m111[i][0] == BRIDGE) {
+			err = m5602_write_bridge(sd,
+				init_mt9m111[i][1],
+				init_mt9m111[i][2]);
+		} else {
+			data[0] = init_mt9m111[i][2];
+			data[1] = init_mt9m111[i][3];
+			err = mt9m111_write_sensor(sd,
+				init_mt9m111[i][1], data, 2);
+		}
+	}
+
+	if (dump_sensor)
+		mt9m111_dump_registers(sd);
+
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_power_down(struct sd *sd)
+{
+	return 0;
+}
+
+int mt9m111_get_vflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 data[2] = {0x00, 0x00};
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = mt9m111_read_sensor(sd, MT9M111_SC_R_MODE_CONTEXT_B,
+				  data, 2);
+	*val = data[0] & MT9M111_RMB_MIRROR_ROWS;
+	PDEBUG(DBG_V4L2_CID, "Read vertical flip %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 data[2] = {0x00, 0x00};
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set vertical flip to %d", val);
+
+	/* Set the correct page map */
+	err = mt9m111_write_sensor(sd, MT9M111_PAGE_MAP, data, 2);
+	if (err < 0)
+		goto out;
+
+	err = mt9m111_read_sensor(sd, MT9M111_SC_R_MODE_CONTEXT_B, data, 2);
+	if (err < 0)
+		goto out;
+
+	data[0] = (data[0] & 0xfe) | val;
+	err = mt9m111_write_sensor(sd, MT9M111_SC_R_MODE_CONTEXT_B,
+				   data, 2);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_get_hflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 data[2] = {0x00, 0x00};
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = mt9m111_read_sensor(sd, MT9M111_SC_R_MODE_CONTEXT_B,
+				  data, 2);
+	*val = data[0] & MT9M111_RMB_MIRROR_COLS;
+	PDEBUG(DBG_V4L2_CID, "Read horizontal flip %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 data[2] = {0x00, 0x00};
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set horizontal flip to %d", val);
+
+	/* Set the correct page map */
+	err = mt9m111_write_sensor(sd, MT9M111_PAGE_MAP, data, 2);
+	if (err < 0)
+		goto out;
+
+	err = mt9m111_read_sensor(sd, MT9M111_SC_R_MODE_CONTEXT_B, data, 2);
+	if (err < 0)
+		goto out;
+
+	data[0] = (data[0] & 0xfd) | ((val << 1) & 0x02);
+	err = mt9m111_write_sensor(sd, MT9M111_SC_R_MODE_CONTEXT_B,
+					data, 2);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err, tmp;
+	u8 data[2] = {0x00, 0x00};
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = mt9m111_read_sensor(sd, MT9M111_SC_GLOBAL_GAIN, data, 2);
+	tmp = ((data[1] << 8) | data[0]);
+
+	*val = ((tmp & (1 << 10)) * 2) |
+	      ((tmp & (1 <<  9)) * 2) |
+	      ((tmp & (1 <<  8)) * 2) |
+	       (tmp & 0x7f);
+
+	PDEBUG(DBG_V4L2_CID, "Read gain %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_set_gain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err, tmp;
+	u8 data[2] = {0x00, 0x00};
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	/* Set the correct page map */
+	err = mt9m111_write_sensor(sd, MT9M111_PAGE_MAP, data, 2);
+	if (err < 0)
+		goto out;
+
+	if (val >= INITIAL_MAX_GAIN * 2 * 2 * 2)
+		return -EINVAL;
+
+	if ((val >= INITIAL_MAX_GAIN * 2 * 2) &&
+	    (val < (INITIAL_MAX_GAIN - 1) * 2 * 2 * 2))
+		tmp = (1 << 10) | (val << 9) |
+				(val << 8) | (val / 8);
+	else if ((val >= INITIAL_MAX_GAIN * 2) &&
+		 (val <  INITIAL_MAX_GAIN * 2 * 2))
+		tmp = (1 << 9) | (1 << 8) | (val / 4);
+	else if ((val >= INITIAL_MAX_GAIN) &&
+		 (val < INITIAL_MAX_GAIN * 2))
+		tmp = (1 << 8) | (val / 2);
+	else
+		tmp = val;
+
+	data[1] = (tmp & 0xff00) >> 8;
+	data[0] = (tmp & 0xff);
+	PDEBUG(DBG_V4L2_CID, "tmp=%d, data[1]=%d, data[0]=%d", tmp,
+	       data[1], data[0]);
+
+	err = mt9m111_write_sensor(sd, MT9M111_SC_GLOBAL_GAIN,
+				   data, 2);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_read_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len) {
+	int err, i;
+
+	do {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_STATUS, i2c_data);
+	} while ((*i2c_data & I2C_BUSY) && !err);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_DEV_ADDR,
+				 sd->sensor->i2c_slave_id);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_REG_ADDR, address);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_CTRL, 0x1a);
+	if (err < 0)
+		goto out;
+
+	for (i = 0; i < len && !err; i++) {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
+
+		PDEBUG(DBG_TRACE, "Reading sensor register "
+		       "0x%x contains 0x%x ", address, *i2c_data);
+	}
+out:
+	return (err < 0) ? err : 0;
+}
+
+int mt9m111_write_sensor(struct sd *sd, const u8 address,
+				u8 *i2c_data, const u8 len)
+{
+	int err, i;
+	u8 *p;
+	struct usb_device *udev = sd->gspca_dev.dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	/* No sensor with a data width larger
+	   than 16 bits has yet been seen, nor with 0 :p*/
+	if (len > 2 || !len)
+		return -EINVAL;
+
+	memcpy(buf, sensor_urb_skeleton,
+	       sizeof(sensor_urb_skeleton));
+
+	buf[11] = sd->sensor->i2c_slave_id;
+	buf[15] = address;
+
+	p = buf + 16;
+
+	/* Copy a four byte write sequence for each byte to be written to */
+	for (i = 0; i < len; i++) {
+		memcpy(p, sensor_urb_skeleton + 16, 4);
+		p[3] = i2c_data[i];
+		p += 4;
+		PDEBUG(DBG_TRACE, "Writing sensor register 0x%x with 0x%x",
+		       address, i2c_data[i]);
+	}
+
+	/* Copy the tailer */
+	memcpy(p, sensor_urb_skeleton + 20, 4);
+
+	/* Set the total length */
+	p[3] = 0x10 + len;
+
+	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			      0x04, 0x40, 0x19,
+			      0x0000, buf,
+			      20 + len * 4, M5602_URB_MSG_TIMEOUT);
+
+	return (err < 0) ? err : 0;
+}
+
+void mt9m111_dump_registers(struct sd *sd)
+{
+	u8 address, value[2] = {0x00, 0x00};
+
+	info("Dumping the mt9m111 register state");
+
+	info("Dumping the mt9m111 sensor core registers");
+	value[1] = MT9M111_SENSOR_CORE;
+	mt9m111_write_sensor(sd, MT9M111_PAGE_MAP, value, 2);
+	for (address = 0; address < 0xff; address++) {
+		mt9m111_read_sensor(sd, address, value, 2);
+		info("register 0x%x contains 0x%x%x",
+		     address, value[0], value[1]);
+	}
+
+	info("Dumping the mt9m111 color pipeline registers");
+	value[1] = MT9M111_COLORPIPE;
+	mt9m111_write_sensor(sd, MT9M111_PAGE_MAP, value, 2);
+	for (address = 0; address < 0xff; address++) {
+		mt9m111_read_sensor(sd, address, value, 2);
+		info("register 0x%x contains 0x%x%x",
+		     address, value[0], value[1]);
+	}
+
+	info("Dumping the mt9m111 camera control registers");
+	value[1] = MT9M111_CAMERA_CONTROL;
+	mt9m111_write_sensor(sd, MT9M111_PAGE_MAP, value, 2);
+	for (address = 0; address < 0xff; address++) {
+		mt9m111_read_sensor(sd, address, value, 2);
+		info("register 0x%x contains 0x%x%x",
+		     address, value[0], value[1]);
+	}
+
+	info("mt9m111 register state dump complete");
+}
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_mt9m111.h
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_mt9m111.h	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,1020 @@
+/*
+ * Driver for the mt9m111 sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * Some defines taken from the mt9m111 sensor driver
+ * Copyright (C) 2008, Robert Jarzmik <robert.jarzmik@free.fr>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef M5602_MT9M111_H_
+#define M5602_MT9M111_H_
+
+#include "m5602_sensor.h"
+
+/*****************************************************************************/
+
+#define MT9M111_SC_CHIPVER			0x00
+#define MT9M111_SC_ROWSTART			0x01
+#define MT9M111_SC_COLSTART			0x02
+#define MT9M111_SC_WINDOW_HEIGHT		0x03
+#define MT9M111_SC_WINDOW_WIDTH			0x04
+#define MT9M111_SC_HBLANK_CONTEXT_B		0x05
+#define MT9M111_SC_VBLANK_CONTEXT_B		0x06
+#define MT9M111_SC_HBLANK_CONTEXT_A		0x07
+#define MT9M111_SC_VBLANK_CONTEXT_A		0x08
+#define MT9M111_SC_SHUTTER_WIDTH		0x09
+#define MT9M111_SC_ROW_SPEED			0x0a
+
+#define MT9M111_SC_EXTRA_DELAY			0x0b
+#define MT9M111_SC_SHUTTER_DELAY		0x0c
+#define MT9M111_SC_RESET			0x0d
+#define MT9M111_SC_R_MODE_CONTEXT_B		0x20
+#define MT9M111_SC_R_MODE_CONTEXT_A		0x21
+#define MT9M111_SC_FLASH_CONTROL		0x23
+#define MT9M111_SC_GREEN_1_GAIN			0x2b
+#define MT9M111_SC_BLUE_GAIN			0x2c
+#define MT9M111_SC_RED_GAIN			0x2d
+#define MT9M111_SC_GREEN_2_GAIN			0x2e
+#define MT9M111_SC_GLOBAL_GAIN			0x2f
+
+#define MT9M111_RMB_MIRROR_ROWS			(1 << 0)
+#define MT9M111_RMB_MIRROR_COLS			(1 << 1)
+
+#define MT9M111_CONTEXT_CONTROL			0xc8
+#define MT9M111_PAGE_MAP			0xf0
+#define MT9M111_BYTEWISE_ADDRESS		0xf1
+
+#define MT9M111_CP_OPERATING_MODE_CTL		0x06
+#define MT9M111_CP_LUMA_OFFSET			0x34
+#define MT9M111_CP_LUMA_CLIP			0x35
+#define MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A 0x3a
+#define MT9M111_CP_LENS_CORRECTION_1		0x3b
+#define MT9M111_CP_DEFECT_CORR_CONTEXT_A	0x4c
+#define MT9M111_CP_DEFECT_CORR_CONTEXT_B	0x4d
+#define MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B 0x9b
+#define MT9M111_CP_GLOBAL_CLK_CONTROL		0xb3
+
+#define MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18   0x65
+#define MT9M111_CC_AWB_PARAMETER_7		0x28
+
+#define MT9M111_SENSOR_CORE			0x00
+#define MT9M111_COLORPIPE			0x01
+#define MT9M111_CAMERA_CONTROL			0x02
+
+#define INITIAL_MAX_GAIN			64
+#define DEFAULT_GAIN 				283
+
+/*****************************************************************************/
+
+/* Kernel module parameters */
+extern int force_sensor;
+extern int dump_sensor;
+extern unsigned int debug;
+
+int mt9m111_probe(struct sd *sd);
+int mt9m111_init(struct sd *sd);
+int mt9m111_power_down(struct sd *sd);
+
+int mt9m111_read_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len);
+
+int mt9m111_write_sensor(struct sd *sd, const u8 address,
+			 u8 *i2c_data, const u8 len);
+
+void mt9m111_dump_registers(struct sd *sd);
+
+int mt9m111_set_vflip(struct gspca_dev *gspca_dev, __s32 val);
+int mt9m111_get_vflip(struct gspca_dev *gspca_dev, __s32 *val);
+int mt9m111_get_hflip(struct gspca_dev *gspca_dev, __s32 *val);
+int mt9m111_set_hflip(struct gspca_dev *gspca_dev, __s32 val);
+int mt9m111_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
+int mt9m111_set_gain(struct gspca_dev *gspca_dev, __s32 val);
+
+static struct m5602_sensor mt9m111 = {
+	.name = "MT9M111",
+
+	.i2c_slave_id = 0xba,
+
+	.probe = mt9m111_probe,
+	.init = mt9m111_init,
+	.power_down = mt9m111_power_down,
+
+	.read_sensor = mt9m111_read_sensor,
+	.write_sensor = mt9m111_write_sensor,
+
+	.nctrls = 3,
+	.ctrls = {
+	{
+		{
+			.id		= V4L2_CID_VFLIP,
+			.type           = V4L2_CTRL_TYPE_BOOLEAN,
+			.name           = "vertical flip",
+			.minimum        = 0,
+			.maximum        = 1,
+			.step           = 1,
+			.default_value  = 0
+		},
+		.set = mt9m111_set_vflip,
+		.get = mt9m111_get_vflip
+	}, {
+		{
+			.id             = V4L2_CID_HFLIP,
+			.type           = V4L2_CTRL_TYPE_BOOLEAN,
+			.name           = "horizontal flip",
+			.minimum        = 0,
+			.maximum        = 1,
+			.step           = 1,
+			.default_value  = 0
+		},
+		.set = mt9m111_set_hflip,
+		.get = mt9m111_get_hflip
+	}, {
+		{
+			.id             = V4L2_CID_GAIN,
+			.type           = V4L2_CTRL_TYPE_INTEGER,
+			.name           = "gain",
+			.minimum        = 0,
+			.maximum        = (INITIAL_MAX_GAIN - 1) * 2 * 2 * 2,
+			.step           = 1,
+			.default_value  = DEFAULT_GAIN,
+			.flags          = V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = mt9m111_set_hflip,
+		.get = mt9m111_get_hflip
+	}
+	},
+
+	.nmodes = 1,
+	.modes = {
+	{
+		M5602_DEFAULT_FRAME_WIDTH,
+		M5602_DEFAULT_FRAME_HEIGHT,
+		V4L2_PIX_FMT_SBGGR8,
+		V4L2_FIELD_NONE,
+		.sizeimage =
+			M5602_DEFAULT_FRAME_WIDTH * M5602_DEFAULT_FRAME_HEIGHT,
+		.bytesperline = M5602_DEFAULT_FRAME_WIDTH,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 1
+	}
+	}
+};
+
+static const unsigned char preinit_mt9m111[][4] =
+{
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0xff, 0xf7},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00}
+};
+
+static const unsigned char init_mt9m111[][4] =
+{
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0xff, 0xff},
+	{SENSOR, MT9M111_SC_RESET, 0xff, 0xff},
+	{SENSOR, MT9M111_SC_RESET, 0xff, 0xde},
+	{SENSOR, MT9M111_SC_RESET, 0xff, 0xff},
+	{SENSOR, MT9M111_SC_RESET, 0xff, 0xf7},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xb3, 0x00},
+
+	{SENSOR, MT9M111_CP_GLOBAL_CLK_CONTROL, 0xff, 0xff},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x05},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_OPERATING_MODE_CTL, 0x00, 0x10},
+	{SENSOR, MT9M111_CP_LENS_CORRECTION_1, 0x04, 0x2a},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_A, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_B, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_LUMA_OFFSET, 0x00, 0x00},
+	{SENSOR, MT9M111_CP_LUMA_CLIP, 0xff, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A, 0x14, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B, 0x14, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xcd, 0x00},
+
+	{SENSOR, 0xcd, 0x00, 0x0e},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xd0, 0x00},
+	{SENSOR, 0xd0, 0x00, 0x40},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x02},
+	{SENSOR, MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x07},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x03},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+	{SENSOR, 0x33, 0x03, 0x49},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+
+	{SENSOR, 0x33, 0x03, 0x49},
+	{SENSOR, 0x34, 0xc0, 0x19},
+	{SENSOR, 0x3f, 0x20, 0x20},
+	{SENSOR, 0x40, 0x20, 0x20},
+	{SENSOR, 0x5a, 0xc0, 0x0a},
+	{SENSOR, 0x70, 0x7b, 0x0a},
+	{SENSOR, 0x71, 0xff, 0x00},
+	{SENSOR, 0x72, 0x19, 0x0e},
+	{SENSOR, 0x73, 0x18, 0x0f},
+	{SENSOR, 0x74, 0x57, 0x32},
+	{SENSOR, 0x75, 0x56, 0x34},
+	{SENSOR, 0x76, 0x73, 0x35},
+	{SENSOR, 0x77, 0x30, 0x12},
+	{SENSOR, 0x78, 0x79, 0x02},
+	{SENSOR, 0x79, 0x75, 0x06},
+	{SENSOR, 0x7a, 0x77, 0x0a},
+	{SENSOR, 0x7b, 0x78, 0x09},
+	{SENSOR, 0x7c, 0x7d, 0x06},
+	{SENSOR, 0x7d, 0x31, 0x10},
+	{SENSOR, 0x7e, 0x00, 0x7e},
+	{SENSOR, 0x80, 0x59, 0x04},
+	{SENSOR, 0x81, 0x59, 0x04},
+	{SENSOR, 0x82, 0x57, 0x0a},
+	{SENSOR, 0x83, 0x58, 0x0b},
+	{SENSOR, 0x84, 0x47, 0x0c},
+	{SENSOR, 0x85, 0x48, 0x0e},
+	{SENSOR, 0x86, 0x5b, 0x02},
+	{SENSOR, 0x87, 0x00, 0x5c},
+	{SENSOR, MT9M111_CONTEXT_CONTROL, 0x00, 0x08},
+	{SENSOR, 0x60, 0x00, 0x80},
+	{SENSOR, 0x61, 0x00, 0x00},
+	{SENSOR, 0x62, 0x00, 0x00},
+	{SENSOR, 0x63, 0x00, 0x00},
+	{SENSOR, 0x64, 0x00, 0x00},
+
+	{SENSOR, MT9M111_SC_ROWSTART, 0x00, 0x0d},
+	{SENSOR, MT9M111_SC_COLSTART, 0x00, 0x18},
+	{SENSOR, MT9M111_SC_WINDOW_HEIGHT, 0x04, 0x04},
+	{SENSOR, MT9M111_SC_WINDOW_WIDTH, 0x05, 0x08},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_B, 0x01, 0x38},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_B, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_A, 0x01, 0x38},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_A, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_B, 0x01, 0x03},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_A, 0x01, 0x03},
+	{SENSOR, 0x30, 0x04, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x05, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x07, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xa0, 0x00},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_SHUTTER_WIDTH, 0x01, 0xf4},
+	{SENSOR, MT9M111_SC_GLOBAL_GAIN, 0x00, 0xea},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x05, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x07, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x09},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x0c},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x04},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xb3, 0x00},
+	{SENSOR, MT9M111_CP_GLOBAL_CLK_CONTROL, 0x00, 0x03},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x05},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_OPERATING_MODE_CTL, 0x00, 0x10},
+	{SENSOR, MT9M111_CP_LENS_CORRECTION_1, 0x04, 0x2a},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_A, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_B, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_LUMA_OFFSET, 0x00, 0x00},
+	{SENSOR, MT9M111_CP_LUMA_CLIP, 0xff, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A, 0x14, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B, 0x14, 0x00},
+
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xcd, 0x00},
+	{SENSOR, 0xcd, 0x00, 0x0e},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xd0, 0x00},
+	{SENSOR, 0xd0, 0x00, 0x40},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x02},
+	{SENSOR, MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x07},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x03},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+	{SENSOR, 0x33, 0x03, 0x49},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+
+	{SENSOR, 0x33, 0x03, 0x49},
+	{SENSOR, 0x34, 0xc0, 0x19},
+	{SENSOR, 0x3f, 0x20, 0x20},
+	{SENSOR, 0x40, 0x20, 0x20},
+	{SENSOR, 0x5a, 0xc0, 0x0a},
+	{SENSOR, 0x70, 0x7b, 0x0a},
+	{SENSOR, 0x71, 0xff, 0x00},
+	{SENSOR, 0x72, 0x19, 0x0e},
+	{SENSOR, 0x73, 0x18, 0x0f},
+	{SENSOR, 0x74, 0x57, 0x32},
+	{SENSOR, 0x75, 0x56, 0x34},
+	{SENSOR, 0x76, 0x73, 0x35},
+	{SENSOR, 0x77, 0x30, 0x12},
+	{SENSOR, 0x78, 0x79, 0x02},
+	{SENSOR, 0x79, 0x75, 0x06},
+	{SENSOR, 0x7a, 0x77, 0x0a},
+	{SENSOR, 0x7b, 0x78, 0x09},
+	{SENSOR, 0x7c, 0x7d, 0x06},
+	{SENSOR, 0x7d, 0x31, 0x10},
+	{SENSOR, 0x7e, 0x00, 0x7e},
+	{SENSOR, 0x80, 0x59, 0x04},
+	{SENSOR, 0x81, 0x59, 0x04},
+	{SENSOR, 0x82, 0x57, 0x0a},
+	{SENSOR, 0x83, 0x58, 0x0b},
+	{SENSOR, 0x84, 0x47, 0x0c},
+	{SENSOR, 0x85, 0x48, 0x0e},
+	{SENSOR, 0x86, 0x5b, 0x02},
+	{SENSOR, 0x87, 0x00, 0x5c},
+	{SENSOR, MT9M111_CONTEXT_CONTROL, 0x00, 0x08},
+	{SENSOR, 0x60, 0x00, 0x80},
+	{SENSOR, 0x61, 0x00, 0x00},
+	{SENSOR, 0x62, 0x00, 0x00},
+	{SENSOR, 0x63, 0x00, 0x00},
+	{SENSOR, 0x64, 0x00, 0x00},
+
+	{SENSOR, MT9M111_SC_ROWSTART, 0x00, 0x0d},
+	{SENSOR, MT9M111_SC_COLSTART, 0x00, 0x18},
+	{SENSOR, MT9M111_SC_WINDOW_HEIGHT, 0x04, 0x04},
+	{SENSOR, MT9M111_SC_WINDOW_WIDTH, 0x05, 0x08},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_B, 0x01, 0x38},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_B, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_A, 0x01, 0x38},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_A, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_B, 0x01, 0x03},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_A, 0x01, 0x03},
+	{SENSOR, 0x30, 0x04, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x05, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x07, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xa0, 0x00},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_SHUTTER_WIDTH, 0x01, 0xf4},
+	{SENSOR, MT9M111_SC_GLOBAL_GAIN, 0x00, 0xea},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x09},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x0c},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x04},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xb3, 0x00},
+	{SENSOR, MT9M111_CP_GLOBAL_CLK_CONTROL, 0x00, 0x03},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x05},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_OPERATING_MODE_CTL, 0x00, 0x10},
+	{SENSOR, MT9M111_CP_LENS_CORRECTION_1, 0x04, 0x2a},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_A, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_B, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_LUMA_OFFSET, 0x00, 0x00},
+	{SENSOR, MT9M111_CP_LUMA_CLIP, 0xff, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A, 0x14, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B, 0x14, 0x00},
+
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xcd, 0x00},
+	{SENSOR, 0xcd, 0x00, 0x0e},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xd0, 0x00},
+	{SENSOR, 0xd0, 0x00, 0x40},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x02},
+	{SENSOR, MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x07},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x03},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+	{SENSOR, 0x33, 0x03, 0x49},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+
+	{SENSOR, 0x33, 0x03, 0x49},
+	{SENSOR, 0x34, 0xc0, 0x19},
+	{SENSOR, 0x3f, 0x20, 0x20},
+	{SENSOR, 0x40, 0x20, 0x20},
+	{SENSOR, 0x5a, 0xc0, 0x0a},
+	{SENSOR, 0x70, 0x7b, 0x0a},
+	{SENSOR, 0x71, 0xff, 0x00},
+	{SENSOR, 0x72, 0x19, 0x0e},
+	{SENSOR, 0x73, 0x18, 0x0f},
+	{SENSOR, 0x74, 0x57, 0x32},
+	{SENSOR, 0x75, 0x56, 0x34},
+	{SENSOR, 0x76, 0x73, 0x35},
+	{SENSOR, 0x77, 0x30, 0x12},
+	{SENSOR, 0x78, 0x79, 0x02},
+	{SENSOR, 0x79, 0x75, 0x06},
+	{SENSOR, 0x7a, 0x77, 0x0a},
+	{SENSOR, 0x7b, 0x78, 0x09},
+	{SENSOR, 0x7c, 0x7d, 0x06},
+	{SENSOR, 0x7d, 0x31, 0x10},
+	{SENSOR, 0x7e, 0x00, 0x7e},
+	{SENSOR, 0x80, 0x59, 0x04},
+	{SENSOR, 0x81, 0x59, 0x04},
+	{SENSOR, 0x82, 0x57, 0x0a},
+	{SENSOR, 0x83, 0x58, 0x0b},
+	{SENSOR, 0x84, 0x47, 0x0c},
+	{SENSOR, 0x85, 0x48, 0x0e},
+	{SENSOR, 0x86, 0x5b, 0x02},
+	{SENSOR, 0x87, 0x00, 0x5c},
+	{SENSOR, MT9M111_CONTEXT_CONTROL, 0x00, 0x08},
+	{SENSOR, 0x60, 0x00, 0x80},
+	{SENSOR, 0x61, 0x00, 0x00},
+	{SENSOR, 0x62, 0x00, 0x00},
+	{SENSOR, 0x63, 0x00, 0x00},
+	{SENSOR, 0x64, 0x00, 0x00},
+
+	{SENSOR, MT9M111_SC_ROWSTART, 0x00, 0x0d},
+	{SENSOR, MT9M111_SC_COLSTART, 0x00, 0x18},
+	{SENSOR, MT9M111_SC_WINDOW_HEIGHT, 0x04, 0x04},
+	{SENSOR, MT9M111_SC_WINDOW_WIDTH, 0x05, 0x08},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_B, 0x01, 0x38},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_B, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_A, 0x01, 0x38},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_A, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_B, 0x01, 0x03},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_A, 0x01, 0x03},
+	{SENSOR, 0x30, 0x04, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x04, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x05, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x07, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xa0, 0x00},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_SHUTTER_WIDTH, 0x01, 0xf4},
+	{SENSOR, MT9M111_SC_GLOBAL_GAIN, 0x00, 0xea},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x09},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x0c},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x04},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xb3, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_CP_GLOBAL_CLK_CONTROL, 0x00, 0x03},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x05},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_OPERATING_MODE_CTL, 0x00, 0x10},
+	{SENSOR, MT9M111_CP_LENS_CORRECTION_1, 0x04, 0x2a},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_A, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_B, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_LUMA_OFFSET, 0x00, 0x00},
+	{SENSOR, MT9M111_CP_LUMA_CLIP, 0xff, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A, 0x14, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B, 0x14, 0x00},
+
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xcd, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, 0xcd, 0x00, 0x0e},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xd0, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, 0xd0, 0x00, 0x40},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x02},
+	{SENSOR, MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x07},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x03},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, 0x33, 0x03, 0x49},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+
+	{SENSOR, 0x33, 0x03, 0x49},
+	{SENSOR, 0x34, 0xc0, 0x19},
+	{SENSOR, 0x3f, 0x20, 0x20},
+	{SENSOR, 0x40, 0x20, 0x20},
+	{SENSOR, 0x5a, 0xc0, 0x0a},
+	{SENSOR, 0x70, 0x7b, 0x0a},
+	{SENSOR, 0x71, 0xff, 0x00},
+	{SENSOR, 0x72, 0x19, 0x0e},
+	{SENSOR, 0x73, 0x18, 0x0f},
+	{SENSOR, 0x74, 0x57, 0x32},
+	{SENSOR, 0x75, 0x56, 0x34},
+	{SENSOR, 0x76, 0x73, 0x35},
+	{SENSOR, 0x77, 0x30, 0x12},
+	{SENSOR, 0x78, 0x79, 0x02},
+	{SENSOR, 0x79, 0x75, 0x06},
+	{SENSOR, 0x7a, 0x77, 0x0a},
+	{SENSOR, 0x7b, 0x78, 0x09},
+	{SENSOR, 0x7c, 0x7d, 0x06},
+	{SENSOR, 0x7d, 0x31, 0x10},
+	{SENSOR, 0x7e, 0x00, 0x7e},
+	{SENSOR, 0x80, 0x59, 0x04},
+	{SENSOR, 0x81, 0x59, 0x04},
+	{SENSOR, 0x82, 0x57, 0x0a},
+	{SENSOR, 0x83, 0x58, 0x0b},
+	{SENSOR, 0x84, 0x47, 0x0c},
+	{SENSOR, 0x85, 0x48, 0x0e},
+	{SENSOR, 0x86, 0x5b, 0x02},
+	{SENSOR, 0x87, 0x00, 0x5c},
+	{SENSOR, MT9M111_CONTEXT_CONTROL, 0x00, 0x08},
+	{SENSOR, 0x60, 0x00, 0x80},
+	{SENSOR, 0x61, 0x00, 0x00},
+	{SENSOR, 0x62, 0x00, 0x00},
+	{SENSOR, 0x63, 0x00, 0x00},
+	{SENSOR, 0x64, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_ROWSTART, 0x00, 0x0d},
+	{SENSOR, MT9M111_SC_COLSTART, 0x00, 0x12},
+	{SENSOR, MT9M111_SC_WINDOW_HEIGHT, 0x04, 0x00},
+	{SENSOR, MT9M111_SC_WINDOW_WIDTH, 0x05, 0x10},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_B, 0x01, 0x60},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_B, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_A, 0x01, 0x60},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_A, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_B, 0x01, 0x0f},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_A, 0x01, 0x0f},
+	{SENSOR, 0x30, 0x04, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe3, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x87, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, MT9M111_SC_SHUTTER_WIDTH, 0x01, 0x90},
+	{SENSOR, MT9M111_SC_GLOBAL_GAIN, 0x00, 0xe6},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x09},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x0c},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x04},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xb3, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_CP_GLOBAL_CLK_CONTROL, 0x00, 0x03},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3e, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x07, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x0b, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a, 0x00},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x05},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x29},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_SC_RESET, 0x00, 0x08},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_OPERATING_MODE_CTL, 0x00, 0x10},
+	{SENSOR, MT9M111_CP_LENS_CORRECTION_1, 0x04, 0x2a},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_A, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_DEFECT_CORR_CONTEXT_B, 0x00, 0x01},
+	{SENSOR, MT9M111_CP_LUMA_OFFSET, 0x00, 0x00},
+	{SENSOR, MT9M111_CP_LUMA_CLIP, 0xff, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_A, 0x14, 0x00},
+	{SENSOR, MT9M111_CP_OUTPUT_FORMAT_CTL2_CONTEXT_B, 0x14, 0x00},
+
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xcd, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, 0xcd, 0x00, 0x0e},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0xd0, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, 0xd0, 0x00, 0x40},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x02},
+	{SENSOR, MT9M111_CC_AUTO_EXPOSURE_PARAMETER_18, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x07},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x28, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, MT9M111_CC_AWB_PARAMETER_7, 0xef, 0x03},
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+	{SENSOR, 0x33, 0x03, 0x49},
+	{BRIDGE, M5602_XB_I2C_DEV_ADDR, 0xba, 0x00},
+	{BRIDGE, M5602_XB_I2C_REG_ADDR, 0x33, 0x00},
+	{BRIDGE, M5602_XB_I2C_CTRL, 0x1a, 0x00},
+
+	{SENSOR, 0x33, 0x03, 0x49},
+	{SENSOR, 0x34, 0xc0, 0x19},
+	{SENSOR, 0x3f, 0x20, 0x20},
+	{SENSOR, 0x40, 0x20, 0x20},
+	{SENSOR, 0x5a, 0xc0, 0x0a},
+	{SENSOR, 0x70, 0x7b, 0x0a},
+	{SENSOR, 0x71, 0xff, 0x00},
+	{SENSOR, 0x72, 0x19, 0x0e},
+	{SENSOR, 0x73, 0x18, 0x0f},
+	{SENSOR, 0x74, 0x57, 0x32},
+	{SENSOR, 0x75, 0x56, 0x34},
+	{SENSOR, 0x76, 0x73, 0x35},
+	{SENSOR, 0x77, 0x30, 0x12},
+	{SENSOR, 0x78, 0x79, 0x02},
+	{SENSOR, 0x79, 0x75, 0x06},
+	{SENSOR, 0x7a, 0x77, 0x0a},
+	{SENSOR, 0x7b, 0x78, 0x09},
+	{SENSOR, 0x7c, 0x7d, 0x06},
+	{SENSOR, 0x7d, 0x31, 0x10},
+	{SENSOR, 0x7e, 0x00, 0x7e},
+	{SENSOR, 0x80, 0x59, 0x04},
+	{SENSOR, 0x81, 0x59, 0x04},
+	{SENSOR, 0x82, 0x57, 0x0a},
+	{SENSOR, 0x83, 0x58, 0x0b},
+	{SENSOR, 0x84, 0x47, 0x0c},
+	{SENSOR, 0x85, 0x48, 0x0e},
+	{SENSOR, 0x86, 0x5b, 0x02},
+	{SENSOR, 0x87, 0x00, 0x5c},
+	{SENSOR, MT9M111_CONTEXT_CONTROL, 0x00, 0x08},
+	{SENSOR, 0x60, 0x00, 0x80},
+	{SENSOR, 0x61, 0x00, 0x00},
+	{SENSOR, 0x62, 0x00, 0x00},
+	{SENSOR, 0x63, 0x00, 0x00},
+	{SENSOR, 0x64, 0x00, 0x00},
+
+	{SENSOR, MT9M111_SC_ROWSTART, 0x00, 0x0d},
+	{SENSOR, MT9M111_SC_COLSTART, 0x00, 0x12},
+	{SENSOR, MT9M111_SC_WINDOW_HEIGHT, 0x04, 0x00},
+	{SENSOR, MT9M111_SC_WINDOW_WIDTH, 0x05, 0x10},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_B, 0x01, 0x60},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_B, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_HBLANK_CONTEXT_A, 0x01, 0x60},
+	{SENSOR, MT9M111_SC_VBLANK_CONTEXT_A, 0x00, 0x11},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_B, 0x01, 0x0f},
+	{SENSOR, MT9M111_SC_R_MODE_CONTEXT_A, 0x01, 0x0f},
+	{SENSOR, 0x30, 0x04, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe0, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x7f, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, MT9M111_PAGE_MAP, 0x00, 0x00},
+	/* Set number of blank rows chosen to 400 */
+	{SENSOR, MT9M111_SC_SHUTTER_WIDTH, 0x01, 0x90},
+	/* Set the global gain to 283 (of 512) */
+	{SENSOR, MT9M111_SC_GLOBAL_GAIN, 0x03, 0x63}
+};
+
+#endif
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_ov9650.c
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_ov9650.c	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,544 @@
+/*
+ * Driver for the ov9650 sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include "m5602_ov9650.h"
+
+int ov9650_read_sensor(struct sd *sd, const u8 address,
+		      u8 *i2c_data, const u8 len)
+{
+	int err, i;
+
+	/* The ov9650 registers have a max depth of one byte */
+	if (len > 1 || !len)
+		return -EINVAL;
+
+	do {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_STATUS, i2c_data);
+	} while ((*i2c_data & I2C_BUSY) && !err);
+
+	m5602_write_bridge(sd, M5602_XB_I2C_DEV_ADDR,
+			   ov9650.i2c_slave_id);
+	m5602_write_bridge(sd, M5602_XB_I2C_REG_ADDR, address);
+	m5602_write_bridge(sd, M5602_XB_I2C_CTRL, 0x10 + len);
+	m5602_write_bridge(sd, M5602_XB_I2C_CTRL, 0x08);
+
+	for (i = 0; i < len; i++) {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
+
+		PDEBUG(DBG_TRACE, "Reading sensor register "
+				"0x%x containing 0x%x ", address, *i2c_data);
+	}
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_write_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len)
+{
+	int err, i;
+	u8 *p;
+	struct usb_device *udev = sd->gspca_dev.dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	/* The ov9650 only supports one byte writes */
+	if (len > 1 || !len)
+		return -EINVAL;
+
+	memcpy(buf, sensor_urb_skeleton,
+	       sizeof(sensor_urb_skeleton));
+
+	buf[11] = sd->sensor->i2c_slave_id;
+	buf[15] = address;
+
+	/* Special case larger sensor writes */
+	p = buf + 16;
+
+	/* Copy a four byte write sequence for each byte to be written to */
+	for (i = 0; i < len; i++) {
+		memcpy(p, sensor_urb_skeleton + 16, 4);
+		p[3] = i2c_data[i];
+		p += 4;
+		PDEBUG(DBG_TRACE, "Writing sensor register 0x%x with 0x%x",
+		       address, i2c_data[i]);
+	}
+
+	/* Copy the tailer */
+	memcpy(p, sensor_urb_skeleton + 20, 4);
+
+	/* Set the total length */
+	p[3] = 0x10 + len;
+
+	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			      0x04, 0x40, 0x19,
+			      0x0000, buf,
+			      20 + len * 4, M5602_URB_MSG_TIMEOUT);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_probe(struct sd *sd)
+{
+	u8 prod_id = 0, ver_id = 0, i;
+
+	if (force_sensor) {
+		if (force_sensor == OV9650_SENSOR) {
+			info("Forcing an %s sensor", ov9650.name);
+			goto sensor_found;
+		}
+		/* If we want to force another sensor,
+		   don't try to probe this one */
+		return -ENODEV;
+	}
+
+	info("Probing for an ov9650 sensor");
+
+	/* Run the pre-init to actually probe the unit */
+	for (i = 0; i < ARRAY_SIZE(preinit_ov9650); i++) {
+		u8 data = preinit_ov9650[i][2];
+		if (preinit_ov9650[i][0] == SENSOR)
+			ov9650_write_sensor(sd,
+					    preinit_ov9650[i][1], &data, 1);
+		else
+			m5602_write_bridge(sd, preinit_ov9650[i][1], data);
+	}
+
+	if (ov9650_read_sensor(sd, OV9650_PID, &prod_id, 1))
+		return -ENODEV;
+
+	if (ov9650_read_sensor(sd, OV9650_VER, &ver_id, 1))
+		return -ENODEV;
+
+	if ((prod_id == 0x96) && (ver_id == 0x52)) {
+		info("Detected an ov9650 sensor");
+		goto sensor_found;
+	}
+
+	return -ENODEV;
+
+sensor_found:
+	sd->gspca_dev.cam.cam_mode = ov9650.modes;
+	sd->gspca_dev.cam.nmodes = ov9650.nmodes;
+	return 0;
+}
+
+int ov9650_init(struct sd *sd)
+{
+	int i, err = 0;
+	u8 data;
+
+	if (dump_sensor)
+		ov9650_dump_registers(sd);
+
+	for (i = 0; i < ARRAY_SIZE(init_ov9650) && !err; i++) {
+		data = init_ov9650[i][2];
+		if (init_ov9650[i][0] == SENSOR)
+			err = ov9650_write_sensor(sd, init_ov9650[i][1],
+						  &data, 1);
+		else
+			err = m5602_write_bridge(sd, init_ov9650[i][1], data);
+	}
+
+	if (!err && dmi_check_system(ov9650_flip_dmi_table)) {
+		info("vflip quirk active");
+		data = 0x30;
+		err = ov9650_write_sensor(sd, OV9650_MVFP, &data, 1);
+	}
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_power_down(struct sd *sd)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(power_down_ov9650); i++) {
+		u8 data = power_down_ov9650[i][2];
+		if (power_down_ov9650[i][0] == SENSOR)
+			ov9650_write_sensor(sd,
+					    power_down_ov9650[i][1], &data, 1);
+		else
+			m5602_write_bridge(sd, power_down_ov9650[i][1], data);
+	}
+
+	return 0;
+}
+
+int ov9650_get_exposure(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	err = ov9650_read_sensor(sd, OV9650_COM1, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+	*val = i2c_data & 0x03;
+
+	err = ov9650_read_sensor(sd, OV9650_AECH, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+	*val |= (i2c_data << 2);
+
+	err = ov9650_read_sensor(sd, OV9650_AECHM, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+	*val |= (i2c_data & 0x3f) << 10;
+
+	PDEBUG(DBG_V4L2_CID, "Read exposure %d", *val);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	PDEBUG(DBG_V4L2_CID, "Set exposure to %d",
+	       val & 0xffff);
+
+	/* The 6 MSBs */
+	i2c_data = (val >> 10) & 0x3f;
+	err = ov9650_write_sensor(sd, OV9650_AECHM,
+				  &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	/* The 8 middle bits */
+	i2c_data = (val >> 2) & 0xff;
+	err = ov9650_write_sensor(sd, OV9650_AECH,
+				  &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	/* The 2 LSBs */
+	i2c_data = val & 0x03;
+	err = ov9650_write_sensor(sd, OV9650_COM1, &i2c_data, 1);
+
+out:
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	ov9650_read_sensor(sd, OV9650_VREF, &i2c_data, 1);
+	*val = (i2c_data & 0x03) << 8;
+
+	err = ov9650_read_sensor(sd, OV9650_GAIN, &i2c_data, 1);
+	*val |= i2c_data;
+	PDEBUG(DBG_V4L2_CID, "Read gain %d", *val);
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_gain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	/* The 2 MSB */
+	/* Read the OV9650_VREF register first to avoid
+	   corrupting the VREF high and low bits */
+	ov9650_read_sensor(sd, OV9650_VREF, &i2c_data, 1);
+	/* Mask away all uninteresting bits */
+	i2c_data = ((val & 0x0300) >> 2) |
+			(i2c_data & 0x3F);
+	err = ov9650_write_sensor(sd, OV9650_VREF, &i2c_data, 1);
+
+	/* The 8 LSBs */
+	i2c_data = val & 0xff;
+	err = ov9650_write_sensor(sd, OV9650_GAIN, &i2c_data, 1);
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_red_balance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = ov9650_read_sensor(sd, OV9650_RED, &i2c_data, 1);
+	*val = i2c_data;
+
+	PDEBUG(DBG_V4L2_CID, "Read red gain %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set red gain to %d",
+			     val & 0xff);
+
+	i2c_data = val & 0xff;
+	err = ov9650_write_sensor(sd, OV9650_RED, &i2c_data, 1);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_blue_balance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = ov9650_read_sensor(sd, OV9650_BLUE, &i2c_data, 1);
+	*val = i2c_data;
+
+	PDEBUG(DBG_V4L2_CID, "Read blue gain %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set blue gain to %d",
+	       val & 0xff);
+
+	i2c_data = val & 0xff;
+	err = ov9650_write_sensor(sd, OV9650_BLUE, &i2c_data, 1);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_hflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = ov9650_read_sensor(sd, OV9650_MVFP, &i2c_data, 1);
+	if (dmi_check_system(ov9650_flip_dmi_table))
+		*val = ((i2c_data & OV9650_HFLIP) >> 5) ? 0 : 1;
+	else
+		*val = (i2c_data & OV9650_HFLIP) >> 5;
+	PDEBUG(DBG_V4L2_CID, "Read horizontal flip %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set horizontal flip to %d", val);
+	err = ov9650_read_sensor(sd, OV9650_MVFP, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	if (dmi_check_system(ov9650_flip_dmi_table))
+		i2c_data = ((i2c_data & 0xdf) |
+				(((val ? 0 : 1) & 0x01) << 5));
+	else
+		i2c_data = ((i2c_data & 0xdf) |
+				((val & 0x01) << 5));
+
+	err = ov9650_write_sensor(sd, OV9650_MVFP, &i2c_data, 1);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_vflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = ov9650_read_sensor(sd, OV9650_MVFP, &i2c_data, 1);
+	if (dmi_check_system(ov9650_flip_dmi_table))
+		*val = ((i2c_data & 0x10) >> 4) ? 0 : 1;
+	else
+		*val = (i2c_data & 0x10) >> 4;
+	PDEBUG(DBG_V4L2_CID, "Read vertical flip %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set vertical flip to %d", val);
+	err = ov9650_read_sensor(sd, OV9650_MVFP, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	if (dmi_check_system(ov9650_flip_dmi_table))
+		i2c_data = ((i2c_data & 0xef) |
+				(((val ? 0 : 1) & 0x01) << 4));
+	else
+		i2c_data = ((i2c_data & 0xef) |
+				((val & 0x01) << 4));
+
+	err = ov9650_write_sensor(sd, OV9650_MVFP, &i2c_data, 1);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_brightness(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = ov9650_read_sensor(sd, OV9650_VREF, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+	*val = (i2c_data & 0x03) << 8;
+
+	err = ov9650_read_sensor(sd, OV9650_GAIN, &i2c_data, 1);
+	*val |= i2c_data;
+	PDEBUG(DBG_V4L2_CID, "Read gain %d", *val);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_brightness(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set gain to %d", val & 0x3ff);
+
+	/* Read the OV9650_VREF register first to avoid
+		corrupting the VREF high and low bits */
+	err = ov9650_read_sensor(sd, OV9650_VREF, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	/* Mask away all uninteresting bits */
+	i2c_data = ((val & 0x0300) >> 2) | (i2c_data & 0x3F);
+	err = ov9650_write_sensor(sd, OV9650_VREF, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	/* The 8 LSBs */
+	i2c_data = val & 0xff;
+	err = ov9650_write_sensor(sd, OV9650_GAIN, &i2c_data, 1);
+
+out:
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_auto_white_balance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = ov9650_read_sensor(sd, OV9650_COM8, &i2c_data, 1);
+	*val = (i2c_data & OV9650_AWB_EN) >> 1;
+	PDEBUG(DBG_V4L2_CID, "Read auto white balance %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_auto_white_balance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set auto white balance to %d", val);
+	err = ov9650_read_sensor(sd, OV9650_COM8, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	i2c_data = ((i2c_data & 0xfd) | ((val & 0x01) << 1));
+	err = ov9650_write_sensor(sd, OV9650_COM8, &i2c_data, 1);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_get_auto_gain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = ov9650_read_sensor(sd, OV9650_COM8, &i2c_data, 1);
+	*val = (i2c_data & OV9650_AGC_EN) >> 2;
+	PDEBUG(DBG_V4L2_CID, "Read auto gain control %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int ov9650_set_auto_gain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 i2c_data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	PDEBUG(DBG_V4L2_CID, "Set auto gain control to %d", val);
+	err = ov9650_read_sensor(sd, OV9650_COM8, &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	i2c_data = ((i2c_data & 0xfb) | ((val & 0x01) << 2));
+	err = ov9650_write_sensor(sd, OV9650_COM8, &i2c_data, 1);
+out:
+	return (err < 0) ? err : 0;
+}
+
+void ov9650_dump_registers(struct sd *sd)
+{
+	int address;
+	info("Dumping the ov9650 register state");
+	for (address = 0; address < 0xa9; address++) {
+		u8 value;
+		ov9650_read_sensor(sd, address, &value, 1);
+		info("register 0x%x contains 0x%x",
+		     address, value);
+	}
+
+	info("ov9650 register state dump complete");
+
+	info("Probing for which registers that are read/write");
+	for (address = 0; address < 0xff; address++) {
+		u8 old_value, ctrl_value;
+		u8 test_value[2] = {0xff, 0xff};
+
+		ov9650_read_sensor(sd, address, &old_value, 1);
+		ov9650_write_sensor(sd, address, test_value, 1);
+		ov9650_read_sensor(sd, address, &ctrl_value, 1);
+
+		if (ctrl_value == test_value[0])
+			info("register 0x%x is writeable", address);
+		else
+			info("register 0x%x is read only", address);
+
+		/* Restore original value */
+		ov9650_write_sensor(sd, address, &old_value, 1);
+	}
+}
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_ov9650.h
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_ov9650.h	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,501 @@
+/*
+ * Driver for the ov9650 sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef M5602_OV9650_H_
+#define M5602_OV9650_H_
+
+#include <linux/dmi.h>
+
+#include "m5602_sensor.h"
+
+/*****************************************************************************/
+
+#define OV9650_GAIN			0x00
+#define OV9650_BLUE			0x01
+#define OV9650_RED			0x02
+#define OV9650_VREF			0x03
+#define OV9650_COM1			0x04
+#define OV9650_BAVE			0x05
+#define OV9650_GEAVE			0x06
+#define OV9650_RSVD7			0x07
+#define OV9650_PID			0x0a
+#define OV9650_VER			0x0b
+#define OV9650_COM3			0x0c
+#define OV9650_COM5			0x0e
+#define OV9650_COM6			0x0f
+#define OV9650_AECH			0x10
+#define OV9650_CLKRC			0x11
+#define OV9650_COM7			0x12
+#define OV9650_COM8			0x13
+#define OV9650_COM9			0x14
+#define OV9650_COM10			0x15
+#define OV9650_RSVD16			0x16
+#define OV9650_HSTART			0x17
+#define OV9650_HSTOP			0x18
+#define OV9650_VSTRT			0x19
+#define OV9650_VSTOP			0x1a
+#define OV9650_PSHFT			0x1b
+#define OV9650_MVFP			0x1e
+#define OV9650_AEW			0x24
+#define OV9650_AEB			0x25
+#define OV9650_VPT			0x26
+#define OV9650_BBIAS			0x27
+#define OV9650_GbBIAS			0x28
+#define OV9650_Gr_COM			0x29
+#define OV9650_RBIAS			0x2c
+#define OV9650_HREF			0x32
+#define OV9650_CHLF			0x33
+#define OV9650_ARBLM			0x34
+#define OV9650_RSVD35			0x35
+#define OV9650_RSVD36			0x36
+#define OV9650_ADC			0x37
+#define OV9650_ACOM38			0x38
+#define OV9650_OFON			0x39
+#define OV9650_TSLB			0x3a
+#define OV9650_COM12			0x3c
+#define OV9650_COM13			0x3d
+#define OV9650_COM15			0x40
+#define OV9650_COM16			0x41
+#define OV9650_LCC1			0x62
+#define OV9650_LCC2			0x63
+#define OV9650_LCC3			0x64
+#define OV9650_LCC4			0x65
+#define OV9650_LCC5			0x66
+#define OV9650_HV			0x69
+#define OV9650_DBLV			0x6b
+#define OV9650_COM21			0x8b
+#define OV9650_COM22			0x8c
+#define OV9650_COM24			0x8e
+#define OV9650_DBLC1			0x8f
+#define OV9650_RSVD94			0x94
+#define OV9650_RSVD95			0x95
+#define OV9650_RSVD96			0x96
+#define OV9650_LCCFB			0x9d
+#define OV9650_LCCFR			0x9e
+#define OV9650_AECHM			0xa1
+#define OV9650_COM26			0xa5
+#define OV9650_ACOMA8			0xa8
+#define OV9650_ACOMA9			0xa9
+
+#define OV9650_REGISTER_RESET		(1 << 7)
+#define OV9650_VGA_SELECT		(1 << 6)
+#define OV9650_RGB_SELECT		(1 << 2)
+#define OV9650_RAW_RGB_SELECT		(1 << 0)
+
+#define OV9650_FAST_AGC_AEC		(1 << 7)
+#define OV9650_AEC_UNLIM_STEP_SIZE	(1 << 6)
+#define OV9650_BANDING			(1 << 5)
+#define OV9650_AGC_EN			(1 << 2)
+#define OV9650_AWB_EN			(1 << 1)
+#define OV9650_AEC_EN			(1 << 0)
+
+#define OV9650_VARIOPIXEL		(1 << 2)
+#define OV9650_SYSTEM_CLK_SEL		(1 << 7)
+#define OV9650_SLAM_MODE 		(1 << 4)
+
+#define OV9650_VFLIP			(1 << 4)
+#define OV9650_HFLIP			(1 << 5)
+
+#define GAIN_DEFAULT			0x14
+#define RED_GAIN_DEFAULT		0x70
+#define BLUE_GAIN_DEFAULT		0x20
+#define EXPOSURE_DEFAULT		0x5003
+
+/*****************************************************************************/
+
+/* Kernel module parameters */
+extern int force_sensor;
+extern int dump_sensor;
+extern unsigned int debug;
+
+int ov9650_probe(struct sd *sd);
+int ov9650_init(struct sd *sd);
+int ov9650_power_down(struct sd *sd);
+
+int ov9650_read_sensor(struct sd *sd, const u8 address,
+		       u8 *i2c_data, const u8 len);
+int ov9650_write_sensor(struct sd *sd, const u8 address,
+		       u8 *i2c_data, const u8 len);
+
+void ov9650_dump_registers(struct sd *sd);
+
+int ov9650_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_gain(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_red_balance(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_red_balance(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_blue_balance(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_hflip(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_hflip(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_vflip(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_vflip(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_brightness(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_brightness(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_auto_white_balance(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_auto_white_balance(struct gspca_dev *gspca_dev, __s32 val);
+int ov9650_get_auto_gain(struct gspca_dev *gspca_dev, __s32 *val);
+int ov9650_set_auto_gain(struct gspca_dev *gspca_dev, __s32 val);
+
+static struct m5602_sensor ov9650 = {
+	.name = "OV9650",
+	.i2c_slave_id = 0x60,
+	.probe = ov9650_probe,
+	.init = ov9650_init,
+	.power_down = ov9650_power_down,
+	.read_sensor = ov9650_read_sensor,
+	.write_sensor = ov9650_write_sensor,
+
+	.nctrls = 8,
+	.ctrls = {
+	{
+		{
+			.id		= V4L2_CID_EXPOSURE,
+			.type		= V4L2_CTRL_TYPE_INTEGER,
+			.name		= "exposure",
+			.minimum	= 0x00,
+			.maximum	= 0xffff,
+			.step		= 0x1,
+			.default_value 	= EXPOSURE_DEFAULT,
+			.flags         	= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = ov9650_set_exposure,
+		.get = ov9650_get_exposure
+	}, {
+		{
+			.id		= V4L2_CID_GAIN,
+			.type		= V4L2_CTRL_TYPE_INTEGER,
+			.name		= "gain",
+			.minimum	= 0x00,
+			.maximum	= 0x3ff,
+			.step		= 0x1,
+			.default_value	= GAIN_DEFAULT,
+			.flags		= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = ov9650_set_gain,
+		.get = ov9650_get_gain
+	}, {
+		{
+			.type 		= V4L2_CTRL_TYPE_INTEGER,
+			.name 		= "red balance",
+			.minimum 	= 0x00,
+			.maximum 	= 0xff,
+			.step 		= 0x1,
+			.default_value 	= RED_GAIN_DEFAULT,
+			.flags         	= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = ov9650_set_red_balance,
+		.get = ov9650_get_red_balance
+	}, {
+		{
+			.type 		= V4L2_CTRL_TYPE_INTEGER,
+			.name 		= "blue balance",
+			.minimum 	= 0x00,
+			.maximum 	= 0xff,
+			.step 		= 0x1,
+			.default_value 	= BLUE_GAIN_DEFAULT,
+			.flags         	= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = ov9650_set_blue_balance,
+		.get = ov9650_get_blue_balance
+	}, {
+		{
+			.id 		= V4L2_CID_HFLIP,
+			.type 		= V4L2_CTRL_TYPE_BOOLEAN,
+			.name 		= "horizontal flip",
+			.minimum 	= 0,
+			.maximum 	= 1,
+			.step 		= 1,
+			.default_value 	= 0
+		},
+		.set = ov9650_set_hflip,
+		.get = ov9650_get_hflip
+	}, {
+		{
+			.id 		= V4L2_CID_VFLIP,
+			.type 		= V4L2_CTRL_TYPE_BOOLEAN,
+			.name 		= "vertical flip",
+			.minimum 	= 0,
+			.maximum 	= 1,
+			.step 		= 1,
+			.default_value 	= 0
+		},
+		.set = ov9650_set_vflip,
+		.get = ov9650_get_vflip
+	}, {
+		{
+			.id 		= V4L2_CID_AUTO_WHITE_BALANCE,
+			.type 		= V4L2_CTRL_TYPE_BOOLEAN,
+			.name 		= "auto white balance",
+			.minimum 	= 0,
+			.maximum 	= 1,
+			.step 		= 1,
+			.default_value 	= 0
+		},
+		.set = ov9650_set_auto_white_balance,
+		.get = ov9650_get_auto_white_balance
+	}, {
+		{
+			.id 		= V4L2_CID_AUTOGAIN,
+			.type 		= V4L2_CTRL_TYPE_BOOLEAN,
+			.name 		= "auto gain control",
+			.minimum 	= 0,
+			.maximum 	= 1,
+			.step 		= 1,
+			.default_value 	= 0
+		},
+		.set = ov9650_set_auto_gain,
+		.get = ov9650_get_auto_gain
+	}
+	},
+
+	.nmodes = 1,
+	.modes = {
+	{
+		M5602_DEFAULT_FRAME_WIDTH,
+		M5602_DEFAULT_FRAME_HEIGHT,
+		V4L2_PIX_FMT_SBGGR8,
+		V4L2_FIELD_NONE,
+		.sizeimage =
+			M5602_DEFAULT_FRAME_WIDTH * M5602_DEFAULT_FRAME_HEIGHT,
+		.bytesperline = M5602_DEFAULT_FRAME_WIDTH,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 1
+	}
+	}
+};
+
+static const unsigned char preinit_ov9650[][3] =
+{
+	/* [INITCAM] */
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a},
+	/* Reset chip */
+	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
+	/* Enable double clock */
+	{SENSOR, OV9650_CLKRC, 0x80},
+	/* Do something out of spec with the power */
+	{SENSOR, OV9650_OFON, 0x40}
+};
+
+static const unsigned char init_ov9650[][3] =
+{
+	/* [INITCAM] */
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x0a},
+	/* Reset chip */
+	{SENSOR, OV9650_COM7, OV9650_REGISTER_RESET},
+	/* Enable double clock */
+	{SENSOR, OV9650_CLKRC, 0x80},
+	/* Do something out of spec with the power */
+	{SENSOR, OV9650_OFON, 0x40},
+
+	/* Set QQVGA */
+	{SENSOR, OV9650_COM1, 0x20},
+	/* Set fast AGC/AEC algorithm with unlimited step size */
+	{SENSOR, OV9650_COM8, OV9650_FAST_AGC_AEC |
+			      OV9650_AEC_UNLIM_STEP_SIZE |
+			      OV9650_AWB_EN | OV9650_AGC_EN},
+
+	{SENSOR, OV9650_CHLF, 0x10},
+	{SENSOR, OV9650_ARBLM, 0xbf},
+	{SENSOR, OV9650_ACOM38, 0x81},
+	/* Turn off color matrix coefficient double option */
+	{SENSOR, OV9650_COM16, 0x00},
+		/* Enable color matrix for RGB/YUV, Delay Y channel,
+	set output Y/UV delay to 1 */
+	{SENSOR, OV9650_COM13, 0x19},
+	/* Enable digital BLC, Set output mode to U Y V Y */
+	{SENSOR, OV9650_TSLB, 0x0c},
+	/* Limit the AGC/AEC stable upper region */
+	{SENSOR, OV9650_COM24, 0x00},
+	/* Enable HREF and some out of spec things */
+	{SENSOR, OV9650_COM12, 0x73},
+		/* Set all DBLC offset signs to positive and
+	do some out of spec stuff */
+	{SENSOR, OV9650_DBLC1, 0xdf},
+	{SENSOR, OV9650_COM21, 0x06},
+	{SENSOR, OV9650_RSVD35, 0x91},
+	/* Necessary, no camera stream without it */
+	{SENSOR, OV9650_RSVD16, 0x06},
+	{SENSOR, OV9650_RSVD94, 0x99},
+	{SENSOR, OV9650_RSVD95, 0x99},
+	{SENSOR, OV9650_RSVD96, 0x04},
+	/* Enable full range output */
+	{SENSOR, OV9650_COM15, 0x0},
+		/* Enable HREF at optical black, enable ADBLC bias,
+	enable ADBLC, reset timings at format change */
+	{SENSOR, OV9650_COM6, 0x4b},
+	/* Subtract 32 from the B channel bias */
+	{SENSOR, OV9650_BBIAS, 0xa0},
+	/* Subtract 32 from the Gb channel bias */
+	{SENSOR, OV9650_GbBIAS, 0xa0},
+	/* Do not bypass the analog BLC and to some out of spec stuff */
+	{SENSOR, OV9650_Gr_COM, 0x00},
+	/* Subtract 32 from the R channel bias */
+	{SENSOR, OV9650_RBIAS, 0xa0},
+	/* Subtract 32 from the R channel bias */
+	{SENSOR, OV9650_RBIAS, 0x0},
+	{SENSOR, OV9650_COM26, 0x80},
+	{SENSOR, OV9650_ACOMA9, 0x98},
+	/* Set the AGC/AEC stable region upper limit */
+	{SENSOR, OV9650_AEW, 0x68},
+	/* Set the AGC/AEC stable region lower limit */
+	{SENSOR, OV9650_AEB, 0x5c},
+	/* Set the high and low limit nibbles to 3 */
+	{SENSOR, OV9650_VPT, 0xc3},
+		/* Set the Automatic Gain Ceiling (AGC) to 128x,
+	drop VSYNC at frame drop,
+	limit exposure timing,
+	drop frame when the AEC step is larger than the exposure gap */
+	{SENSOR, OV9650_COM9, 0x6e},
+	/* Set VSYNC negative, Set RESET to SLHS (slave mode horizontal sync)
+	and set PWDN to SLVS (slave mode vertical sync) */
+	{SENSOR, OV9650_COM10, 0x42},
+	/* Set horizontal column start high to default value */
+	{SENSOR, OV9650_HSTART, 0x1a},
+	/* Set horizontal column end */
+	{SENSOR, OV9650_HSTOP, 0xbf},
+	/* Complementing register to the two writes above */
+	{SENSOR, OV9650_HREF, 0xb2},
+	/* Set vertical row start high bits */
+	{SENSOR, OV9650_VSTRT, 0x02},
+	/* Set vertical row end low bits */
+	{SENSOR, OV9650_VSTOP, 0x7e},
+	/* Set complementing vertical frame control */
+	{SENSOR, OV9650_VREF, 0x10},
+	/* Set raw RGB output format with VGA resolution */
+	{SENSOR, OV9650_COM7, OV9650_VGA_SELECT |
+			      OV9650_RGB_SELECT |
+			      OV9650_RAW_RGB_SELECT},
+	{SENSOR, OV9650_ADC, 0x04},
+	{SENSOR, OV9650_HV, 0x40},
+	/* Enable denoise, and white-pixel erase */
+	{SENSOR, OV9650_COM22, 0x23},
+
+	/* Set the high bits of the exposure value */
+	{SENSOR, OV9650_AECH, ((EXPOSURE_DEFAULT & 0xff00) >> 8)},
+
+	/* Set the low bits of the exposure value */
+	{SENSOR, OV9650_COM1, (EXPOSURE_DEFAULT & 0xff)},
+	{SENSOR, OV9650_GAIN, GAIN_DEFAULT},
+	{SENSOR, OV9650_BLUE, BLUE_GAIN_DEFAULT},
+	{SENSOR, OV9650_RED, RED_GAIN_DEFAULT},
+
+	{SENSOR, OV9650_COM3, OV9650_VARIOPIXEL},
+	{SENSOR, OV9650_COM5, OV9650_SYSTEM_CLK_SEL},
+
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x82},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_L, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_L, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x09},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe0},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x5e},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0xde}
+};
+
+static const unsigned char power_down_ov9650[][3] =
+{
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{SENSOR, OV9650_COM7, 0x80},
+	{SENSOR, OV9650_OFON, 0xf4},
+	{SENSOR, OV9650_MVFP, 0x80},
+	{SENSOR, OV9650_DBLV, 0x3f},
+	{SENSOR, OV9650_RSVD36, 0x49},
+	{SENSOR, OV9650_COM7, 0x05},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0}
+};
+
+/* Vertically and horizontally flips the image if matched, needed for machines
+   where the sensor is mounted upside down */
+static const struct dmi_system_id ov9650_flip_dmi_table[] = {
+	{
+		.ident = "ASUS A6VC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "A6VC")
+		}
+	},
+	{
+		.ident = "ASUS A6VM",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "A6VM")
+		}
+	},
+	{
+		.ident = "ASUS A6JC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "A6JC")
+		}
+	},
+	{
+		.ident = "ASUS A6Kt",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "A6Kt")
+		}
+	},
+	{ }
+};
+
+#endif
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_po1030.c
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_po1030.c	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,334 @@
+/*
+ * Driver for the po1030 sensor
+ *
+ * Copyright (c) 2008 Erik Andrén
+ * Copyright (c) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (c) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include "m5602_po1030.h"
+
+int po1030_probe(struct sd *sd)
+{
+	u8 prod_id = 0, ver_id = 0, i;
+
+	if (force_sensor) {
+		if (force_sensor == PO1030_SENSOR) {
+			info("Forcing a %s sensor", po1030.name);
+			goto sensor_found;
+		}
+		/* If we want to force another sensor, don't try to probe this
+		 * one */
+		return -ENODEV;
+	}
+
+	info("Probing for a po1030 sensor");
+
+	/* Run the pre-init to actually probe the unit */
+	for (i = 0; i < ARRAY_SIZE(preinit_po1030); i++) {
+		u8 data = preinit_po1030[i][2];
+		if (preinit_po1030[i][0] == SENSOR)
+			po1030_write_sensor(sd,
+				preinit_po1030[i][1], &data, 1);
+		else
+			m5602_write_bridge(sd, preinit_po1030[i][1], data);
+	}
+
+	if (po1030_read_sensor(sd, 0x3, &prod_id, 1))
+		return -ENODEV;
+
+	if (po1030_read_sensor(sd, 0x4, &ver_id, 1))
+		return -ENODEV;
+
+	if ((prod_id == 0x02) && (ver_id == 0xef)) {
+		info("Detected a po1030 sensor");
+		goto sensor_found;
+	}
+	return -ENODEV;
+
+sensor_found:
+	sd->gspca_dev.cam.cam_mode = po1030.modes;
+	sd->gspca_dev.cam.nmodes = po1030.nmodes;
+	return 0;
+}
+
+int po1030_read_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len)
+{
+	int err, i;
+
+	do {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_STATUS, i2c_data);
+	} while ((*i2c_data & I2C_BUSY) && !err);
+
+	m5602_write_bridge(sd, M5602_XB_I2C_DEV_ADDR,
+			   sd->sensor->i2c_slave_id);
+	m5602_write_bridge(sd, M5602_XB_I2C_REG_ADDR, address);
+	m5602_write_bridge(sd, M5602_XB_I2C_CTRL, 0x10 + len);
+	m5602_write_bridge(sd, M5602_XB_I2C_CTRL, 0x08);
+
+	for (i = 0; i < len; i++) {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
+
+		PDEBUG(DBG_TRACE, "Reading sensor register "
+				"0x%x containing 0x%x ", address, *i2c_data);
+	}
+	return (err < 0) ? err : 0;
+}
+
+int po1030_write_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len)
+{
+	int err, i;
+	u8 *p;
+	struct usb_device *udev = sd->gspca_dev.dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	/* The po1030 only supports one byte writes */
+	if (len > 1 || !len)
+		return -EINVAL;
+
+	memcpy(buf, sensor_urb_skeleton, sizeof(sensor_urb_skeleton));
+
+	buf[11] = sd->sensor->i2c_slave_id;
+	buf[15] = address;
+
+	p = buf + 16;
+
+	/* Copy a four byte write sequence for each byte to be written to */
+	for (i = 0; i < len; i++) {
+		memcpy(p, sensor_urb_skeleton + 16, 4);
+		p[3] = i2c_data[i];
+		p += 4;
+		PDEBUG(DBG_TRACE, "Writing sensor register 0x%x with 0x%x",
+		       address, i2c_data[i]);
+	}
+
+	/* Copy the footer */
+	memcpy(p, sensor_urb_skeleton + 20, 4);
+
+	/* Set the total length */
+	p[3] = 0x10 + len;
+
+	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			      0x04, 0x40, 0x19,
+			      0x0000, buf,
+			      20 + len * 4, M5602_URB_MSG_TIMEOUT);
+
+	return (err < 0) ? err : 0;
+}
+
+int po1030_init(struct sd *sd)
+{
+	int i, err = 0;
+
+	/* Init the sensor */
+	for (i = 0; i < ARRAY_SIZE(init_po1030); i++) {
+		u8 data[2] = {0x00, 0x00};
+
+		switch (init_po1030[i][0]) {
+		case BRIDGE:
+			err = m5602_write_bridge(sd,
+				init_po1030[i][1],
+				init_po1030[i][2]);
+			break;
+
+		case SENSOR:
+			data[0] = init_po1030[i][2];
+			err = po1030_write_sensor(sd,
+				init_po1030[i][1], data, 1);
+			break;
+
+		case SENSOR_LONG:
+			data[0] = init_po1030[i][2];
+			data[1] = init_po1030[i][3];
+			err = po1030_write_sensor(sd,
+				init_po1030[i][1], data, 2);
+			break;
+		default:
+			info("Invalid stream command, exiting init");
+			return -EINVAL;
+		}
+	}
+
+	if (dump_sensor)
+		po1030_dump_registers(sd);
+
+	return (err < 0) ? err : 0;
+}
+
+int po1030_get_exposure(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	err = po1030_read_sensor(sd, PO1030_REG_INTEGLINES_H,
+				 &i2c_data, 1);
+	if (err < 0)
+		goto out;
+	*val = (i2c_data << 8);
+
+	err = po1030_read_sensor(sd, PO1030_REG_INTEGLINES_M,
+				 &i2c_data, 1);
+	*val |= i2c_data;
+
+	PDEBUG(DBG_V4L2_CID, "Exposure read as %d", *val);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int po1030_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	PDEBUG(DBG_V4L2, "Set exposure to %d", val & 0xffff);
+
+	i2c_data = ((val & 0xff00) >> 8);
+	PDEBUG(DBG_V4L2, "Set exposure to high byte to 0x%x",
+	       i2c_data);
+
+	err = po1030_write_sensor(sd, PO1030_REG_INTEGLINES_H,
+				  &i2c_data, 1);
+	if (err < 0)
+		goto out;
+
+	i2c_data = (val & 0xff);
+	PDEBUG(DBG_V4L2, "Set exposure to low byte to 0x%x",
+	       i2c_data);
+	err = po1030_write_sensor(sd, PO1030_REG_INTEGLINES_M,
+				  &i2c_data, 1);
+
+out:
+	return (err < 0) ? err : 0;
+}
+
+int po1030_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	err = po1030_read_sensor(sd, PO1030_REG_GLOBALGAIN,
+				 &i2c_data, 1);
+	*val = i2c_data;
+	PDEBUG(DBG_V4L2_CID, "Read global gain %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int po1030_set_gain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	i2c_data = val & 0xff;
+	PDEBUG(DBG_V4L2, "Set global gain to %d", i2c_data);
+	err = po1030_write_sensor(sd, PO1030_REG_GLOBALGAIN,
+				  &i2c_data, 1);
+	return (err < 0) ? err : 0;
+}
+
+int po1030_get_red_balance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	err = po1030_read_sensor(sd, PO1030_REG_RED_GAIN,
+				 &i2c_data, 1);
+	*val = i2c_data;
+	PDEBUG(DBG_V4L2_CID, "Read red gain %d", *val);
+	return (err < 0) ? err : 0;
+}
+
+int po1030_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	i2c_data = val & 0xff;
+	PDEBUG(DBG_V4L2, "Set red gain to %d", i2c_data);
+	err = po1030_write_sensor(sd, PO1030_REG_RED_GAIN,
+				  &i2c_data, 1);
+	return (err < 0) ? err : 0;
+}
+
+int po1030_get_blue_balance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+
+	err = po1030_read_sensor(sd, PO1030_REG_BLUE_GAIN,
+				 &i2c_data, 1);
+	*val = i2c_data;
+	PDEBUG(DBG_V4L2_CID, "Read blue gain %d", *val);
+
+	return (err < 0) ? err : 0;
+}
+
+int po1030_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 i2c_data;
+	int err;
+	i2c_data = val & 0xff;
+	PDEBUG(DBG_V4L2, "Set blue gain to %d", i2c_data);
+	err = po1030_write_sensor(sd, PO1030_REG_BLUE_GAIN,
+				  &i2c_data, 1);
+
+	return (err < 0) ? err : 0;
+}
+
+int po1030_power_down(struct sd *sd)
+{
+	return 0;
+}
+
+void po1030_dump_registers(struct sd *sd)
+{
+	int address;
+	u8 value = 0;
+
+	info("Dumping the po1030 sensor core registers");
+	for (address = 0; address < 0x7f; address++) {
+		po1030_read_sensor(sd, address, &value, 1);
+		info("register 0x%x contains 0x%x",
+		     address, value);
+	}
+
+	info("po1030 register state dump complete");
+
+	info("Probing for which registers that are read/write");
+	for (address = 0; address < 0xff; address++) {
+		u8 old_value, ctrl_value;
+		u8 test_value[2] = {0xff, 0xff};
+
+		po1030_read_sensor(sd, address, &old_value, 1);
+		po1030_write_sensor(sd, address, test_value, 1);
+		po1030_read_sensor(sd, address, &ctrl_value, 1);
+
+		if (ctrl_value == test_value[0])
+			info("register 0x%x is writeable", address);
+		else
+			info("register 0x%x is read only", address);
+
+		/* Restore original value */
+		po1030_write_sensor(sd, address, &old_value, 1);
+	}
+}
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_po1030.h
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_po1030.h	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,478 @@
+/*
+ * Driver for the po1030 sensor.
+ * This is probably a pixel plus sensor but we haven't identified it yet
+ *
+ * Copyright (c) 2008 Erik Andrén
+ * Copyright (c) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (c) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * Register defines taken from Pascal Stangs Proxycon Armlib
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef M5602_PO1030_H_
+#define M5602_PO1030_H_
+
+#include "m5602_sensor.h"
+
+/*****************************************************************************/
+
+#define PO1030_REG_DEVID_H		0x00
+#define PO1030_REG_DEVID_L		0x01
+#define PO1030_REG_FRAMEWIDTH_H		0x04
+#define PO1030_REG_FRAMEWIDTH_L		0x05
+#define PO1030_REG_FRAMEHEIGHT_H	0x06
+#define PO1030_REG_FRAMEHEIGHT_L	0x07
+#define PO1030_REG_WINDOWX_H		0x08
+#define PO1030_REG_WINDOWX_L		0x09
+#define PO1030_REG_WINDOWY_H		0x0a
+#define PO1030_REG_WINDOWY_L		0x0b
+#define PO1030_REG_WINDOWWIDTH_H	0x0c
+#define PO1030_REG_WINDOWWIDTH_L	0x0d
+#define PO1030_REG_WINDOWHEIGHT_H	0x0e
+#define PO1030_REG_WINDOWHEIGHT_L	0x0f
+
+#define PO1030_REG_GLOBALIBIAS		0x12
+#define PO1030_REG_PIXELIBIAS		0x13
+
+#define PO1030_REG_GLOBALGAIN		0x15
+#define PO1030_REG_RED_GAIN		0x16
+#define PO1030_REG_GREEN_1_GAIN		0x17
+#define PO1030_REG_BLUE_GAIN		0x18
+#define PO1030_REG_GREEN_2_GAIN		0x19
+
+#define PO1030_REG_INTEGLINES_H		0x1a
+#define PO1030_REG_INTEGLINES_M		0x1b
+#define PO1030_REG_INTEGLINES_L		0x1c
+
+#define PO1030_REG_CONTROL1		0x1d
+#define PO1030_REG_CONTROL2		0x1e
+#define PO1030_REG_CONTROL3		0x1f
+#define PO1030_REG_CONTROL4		0x20
+
+#define PO1030_REG_PERIOD50_H		0x23
+#define PO1030_REG_PERIOD50_L		0x24
+#define PO1030_REG_PERIOD60_H		0x25
+#define PO1030_REG_PERIOD60_L		0x26
+#define PO1030_REG_REGCLK167		0x27
+#define PO1030_REG_DELTA50		0x28
+#define PO1030_REG_DELTA60		0x29
+
+#define PO1030_REG_ADCOFFSET		0x2c
+
+/* Gamma Correction Coeffs */
+#define PO1030_REG_GC0			0x2d
+#define PO1030_REG_GC1			0x2e
+#define PO1030_REG_GC2			0x2f
+#define PO1030_REG_GC3			0x30
+#define PO1030_REG_GC4			0x31
+#define PO1030_REG_GC5			0x32
+#define PO1030_REG_GC6			0x33
+#define PO1030_REG_GC7			0x34
+
+/* Color Transform Matrix */
+#define PO1030_REG_CT0			0x35
+#define PO1030_REG_CT1			0x36
+#define PO1030_REG_CT2			0x37
+#define PO1030_REG_CT3			0x38
+#define PO1030_REG_CT4			0x39
+#define PO1030_REG_CT5			0x3a
+#define PO1030_REG_CT6			0x3b
+#define PO1030_REG_CT7			0x3c
+#define PO1030_REG_CT8			0x3d
+
+#define PO1030_REG_AUTOCTRL1		0x3e
+#define PO1030_REG_AUTOCTRL2		0x3f
+
+#define PO1030_REG_YTARGET		0x40
+#define PO1030_REG_GLOBALGAINMIN	0x41
+#define PO1030_REG_GLOBALGAINMAX	0x42
+
+/* Output format control */
+#define PO1030_REG_OUTFORMCTRL1		0x5a
+#define PO1030_REG_OUTFORMCTRL2		0x5b
+#define PO1030_REG_OUTFORMCTRL3		0x5c
+#define PO1030_REG_OUTFORMCTRL4		0x5d
+#define PO1030_REG_OUTFORMCTRL5		0x5e
+
+/* Imaging coefficients */
+#define PO1030_REG_YBRIGHT		0x73
+#define PO1030_REG_YCONTRAST		0x74
+#define PO1030_REG_YSATURATION		0x75
+
+/*****************************************************************************/
+
+#define PO1030_GLOBAL_GAIN_DEFAULT	0x12
+#define PO1030_EXPOSURE_DEFAULT		0xf0ff
+#define PO1030_BLUE_GAIN_DEFAULT 	0x40
+#define PO1030_RED_GAIN_DEFAULT 	0x40
+
+/*****************************************************************************/
+
+/* Kernel module parameters */
+extern int force_sensor;
+extern int dump_sensor;
+extern unsigned int debug;
+
+int po1030_probe(struct sd *sd);
+int po1030_init(struct sd *sd);
+int po1030_power_down(struct sd *sd);
+
+void po1030_dump_registers(struct sd *sd);
+
+int po1030_read_sensor(struct sd *sd, const u8 address,
+			      u8 *i2c_data, const u8 len);
+int po1030_write_sensor(struct sd *sd, const u8 address,
+			       u8 *i2c_data, const u8 len);
+
+int po1030_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
+int po1030_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
+int po1030_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
+int po1030_set_gain(struct gspca_dev *gspca_dev, __s32 val);
+int po1030_get_red_balance(struct gspca_dev *gspca_dev, __s32 *val);
+int po1030_set_red_balance(struct gspca_dev *gspca_dev, __s32 val);
+int po1030_get_blue_balance(struct gspca_dev *gspca_dev, __s32 *val);
+int po1030_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val);
+
+static struct m5602_sensor po1030 = {
+	.name = "PO1030",
+
+	.i2c_slave_id = 0xdc,
+
+	.probe = po1030_probe,
+	.init = po1030_init,
+	.power_down = po1030_power_down,
+
+	.nctrls = 4,
+	.ctrls = {
+	{
+		{
+			.id 		= V4L2_CID_GAIN,
+			.type 		= V4L2_CTRL_TYPE_INTEGER,
+			.name 		= "gain",
+			.minimum 	= 0x00,
+			.maximum 	= 0xff,
+			.step 		= 0x1,
+			.default_value 	= PO1030_GLOBAL_GAIN_DEFAULT,
+			.flags         	= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = po1030_set_gain,
+		.get = po1030_get_gain
+	}, {
+		{
+			.id 		= V4L2_CID_EXPOSURE,
+			.type 		= V4L2_CTRL_TYPE_INTEGER,
+			.name 		= "exposure",
+			.minimum 	= 0x00,
+			.maximum 	= 0xffff,
+			.step 		= 0x1,
+			.default_value 	= PO1030_EXPOSURE_DEFAULT,
+			.flags         	= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = po1030_set_exposure,
+		.get = po1030_get_exposure
+	}, {
+		{
+			.id 		= V4L2_CID_RED_BALANCE,
+			.type 		= V4L2_CTRL_TYPE_INTEGER,
+			.name 		= "red balance",
+			.minimum 	= 0x00,
+			.maximum 	= 0xff,
+			.step 		= 0x1,
+			.default_value 	= PO1030_RED_GAIN_DEFAULT,
+			.flags         	= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = po1030_set_red_balance,
+		.get = po1030_get_red_balance
+	}, {
+		{
+			.id 		= V4L2_CID_BLUE_BALANCE,
+			.type 		= V4L2_CTRL_TYPE_INTEGER,
+			.name 		= "blue balance",
+			.minimum 	= 0x00,
+			.maximum 	= 0xff,
+			.step 		= 0x1,
+			.default_value 	= PO1030_BLUE_GAIN_DEFAULT,
+			.flags         	= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = po1030_set_blue_balance,
+		.get = po1030_get_blue_balance
+	}
+	},
+	.nmodes = 1,
+	.modes = {
+	{
+		M5602_DEFAULT_FRAME_WIDTH,
+		M5602_DEFAULT_FRAME_HEIGHT,
+		V4L2_PIX_FMT_SBGGR8,
+		V4L2_FIELD_NONE,
+		.sizeimage =
+			M5602_DEFAULT_FRAME_WIDTH * M5602_DEFAULT_FRAME_HEIGHT,
+		.bytesperline = M5602_DEFAULT_FRAME_WIDTH,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 1
+	}
+	}
+};
+
+static const unsigned char preinit_po1030[][3] =
+{
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+
+	{SENSOR, PO1030_REG_AUTOCTRL2, 0x24},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x02},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xec},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x87},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00},
+
+	{SENSOR, PO1030_REG_AUTOCTRL2, 0x24},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00}
+};
+
+static const unsigned char init_po1030[][4] =
+{
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0},
+	/*sequence 1*/
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d},
+
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	/*end of sequence 1*/
+
+	/*sequence 2 (same as stop sequence)*/
+	{SENSOR, PO1030_REG_AUTOCTRL2, 0x24},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	/*end of sequence 2*/
+
+	/*sequence 5*/
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x02},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xec},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x87},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00},
+	/*end of sequence 5*/
+
+	/*sequence 2 stop */
+	{SENSOR, PO1030_REG_AUTOCTRL2, 0x24},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x04},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x02},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x04},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	/*end of sequence 2 stop */
+
+/* ---------------------------------
+ * end of init - begin of start
+ * --------------------------------- */
+
+	/*sequence 3*/
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	/*end of sequence 3*/
+	/*sequence 4*/
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x05},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00},
+
+	{SENSOR, PO1030_REG_AUTOCTRL2, 0x04},
+
+	/* Set the width to 751 */
+	{SENSOR, PO1030_REG_FRAMEWIDTH_H, 0x02},
+	{SENSOR, PO1030_REG_FRAMEWIDTH_L, 0xef},
+
+	/* Set the height to 540 */
+	{SENSOR, PO1030_REG_FRAMEHEIGHT_H, 0x02},
+	{SENSOR, PO1030_REG_FRAMEHEIGHT_L, 0x1c},
+
+	/* Set the x window to 1 */
+	{SENSOR, PO1030_REG_WINDOWX_H, 0x00},
+	{SENSOR, PO1030_REG_WINDOWX_L, 0x01},
+
+	/* Set the y window to 1 */
+	{SENSOR, PO1030_REG_WINDOWY_H, 0x00},
+	{SENSOR, PO1030_REG_WINDOWX_L, 0x01},
+
+	{SENSOR, PO1030_REG_WINDOWWIDTH_H, 0x02},
+	{SENSOR, PO1030_REG_WINDOWWIDTH_L, 0x87},
+	{SENSOR, PO1030_REG_WINDOWHEIGHT_H, 0x01},
+	{SENSOR, PO1030_REG_WINDOWHEIGHT_L, 0xe3},
+
+	{SENSOR, PO1030_REG_OUTFORMCTRL2, 0x04},
+	{SENSOR, PO1030_REG_OUTFORMCTRL2, 0x04},
+	{SENSOR, PO1030_REG_AUTOCTRL1, 0x08},
+	{SENSOR, PO1030_REG_CONTROL2, 0x03},
+	{SENSOR, 0x21, 0x90},
+	{SENSOR, PO1030_REG_YTARGET, 0x60},
+	{SENSOR, 0x59, 0x13},
+	{SENSOR, PO1030_REG_OUTFORMCTRL1, 0x40},
+	{SENSOR, 0x5f, 0x00},
+	{SENSOR, 0x60, 0x80},
+	{SENSOR, 0x78, 0x14},
+	{SENSOR, 0x6f, 0x01},
+	{SENSOR, PO1030_REG_CONTROL1, 0x18},
+	{SENSOR, PO1030_REG_GLOBALGAINMAX, 0x14},
+	{SENSOR, 0x63, 0x38},
+	{SENSOR, 0x64, 0x38},
+	{SENSOR, PO1030_REG_CONTROL1, 0x58},
+	{SENSOR, PO1030_REG_RED_GAIN, 0x30},
+	{SENSOR, PO1030_REG_GREEN_1_GAIN, 0x30},
+	{SENSOR, PO1030_REG_BLUE_GAIN, 0x30},
+	{SENSOR, PO1030_REG_GREEN_2_GAIN, 0x30},
+	{SENSOR, PO1030_REG_GC0, 0x10},
+	{SENSOR, PO1030_REG_GC1, 0x20},
+	{SENSOR, PO1030_REG_GC2, 0x40},
+	{SENSOR, PO1030_REG_GC3, 0x60},
+	{SENSOR, PO1030_REG_GC4, 0x80},
+	{SENSOR, PO1030_REG_GC5, 0xa0},
+	{SENSOR, PO1030_REG_GC6, 0xc0},
+	{SENSOR, PO1030_REG_GC7, 0xff},
+	/*end of sequence 4*/
+	/*sequence 5*/
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0c},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x02},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xec},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x7e},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00},
+	/*end of sequence 5*/
+
+	/*sequence 6*/
+	/* Changing 40 in f0 the image becomes green in bayer mode and red in
+	 * rgb mode */
+	{SENSOR, PO1030_REG_RED_GAIN, PO1030_RED_GAIN_DEFAULT},
+	/* in changing 40 in f0 the image becomes green in bayer mode and red in
+	 * rgb mode */
+	{SENSOR, PO1030_REG_BLUE_GAIN, PO1030_BLUE_GAIN_DEFAULT},
+
+	/* with a very low lighted environment increase the exposure but
+	 * decrease the FPS (Frame Per Second) */
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0},
+
+	/* Controls high exposure more than SENSOR_LOW_EXPOSURE, use only in
+	 * low lighted environment (f0 is more than ff ?)*/
+	{SENSOR, PO1030_REG_INTEGLINES_H, ((PO1030_EXPOSURE_DEFAULT >> 2)
+		& 0xff)},
+
+	/* Controls middle exposure, use only in high lighted environment */
+	{SENSOR, PO1030_REG_INTEGLINES_M, PO1030_EXPOSURE_DEFAULT & 0xff},
+
+	/* Controls clarity (not sure) */
+	{SENSOR, PO1030_REG_INTEGLINES_L, 0x00},
+	/* Controls gain (the image is more lighted) */
+	{SENSOR, PO1030_REG_GLOBALGAIN, PO1030_GLOBAL_GAIN_DEFAULT},
+
+	/* Sets the width */
+	{SENSOR, PO1030_REG_FRAMEWIDTH_H, 0x02},
+	{SENSOR, PO1030_REG_FRAMEWIDTH_L, 0xef}
+	/*end of sequence 6*/
+};
+
+#endif
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,460 @@
+/*
+ * Driver for the s5k4aa sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include "m5602_s5k4aa.h"
+
+int s5k4aa_probe(struct sd *sd)
+{
+	u8 prod_id[6] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	const u8 expected_prod_id[6] = {0x00, 0x10, 0x00, 0x4b, 0x33, 0x75};
+	int i, err = 0;
+
+	if (force_sensor) {
+		if (force_sensor == S5K4AA_SENSOR) {
+			info("Forcing a %s sensor", s5k4aa.name);
+			goto sensor_found;
+		}
+		/* If we want to force another sensor, don't try to probe this
+		 * one */
+		return -ENODEV;
+	}
+
+	info("Probing for a s5k4aa sensor");
+
+	/* Preinit the sensor */
+	for (i = 0; i < ARRAY_SIZE(preinit_s5k4aa) && !err; i++) {
+		u8 data[2] = {0x00, 0x00};
+
+		switch (preinit_s5k4aa[i][0]) {
+		case BRIDGE:
+			err = m5602_write_bridge(sd,
+						 preinit_s5k4aa[i][1],
+						 preinit_s5k4aa[i][2]);
+			break;
+
+		case SENSOR:
+			data[0] = preinit_s5k4aa[i][2];
+			err = s5k4aa_write_sensor(sd,
+						  preinit_s5k4aa[i][1],
+						  data, 1);
+			break;
+
+		case SENSOR_LONG:
+			data[0] = preinit_s5k4aa[i][2];
+			data[1] = preinit_s5k4aa[i][3];
+			err = s5k4aa_write_sensor(sd,
+						  preinit_s5k4aa[i][1],
+						  data, 2);
+			break;
+		default:
+			info("Invalid stream command, exiting init");
+			return -EINVAL;
+		}
+	}
+
+	/* Test some registers, but we don't know their exact meaning yet */
+	if (s5k4aa_read_sensor(sd, 0x00, prod_id, sizeof(prod_id)))
+		return -ENODEV;
+
+	if (memcmp(prod_id, expected_prod_id, sizeof(prod_id)))
+		return -ENODEV;
+	else
+		info("Detected a s5k4aa sensor");
+sensor_found:
+	sd->gspca_dev.cam.cam_mode = s5k4aa.modes;
+	sd->gspca_dev.cam.nmodes = s5k4aa.nmodes;
+	return 0;
+}
+
+int s5k4aa_read_sensor(struct sd *sd, const u8 address,
+		       u8 *i2c_data, const u8 len)
+{
+	int err, i;
+
+	do {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_STATUS, i2c_data);
+	} while ((*i2c_data & I2C_BUSY) && !err);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_DEV_ADDR,
+				 sd->sensor->i2c_slave_id);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_REG_ADDR, address);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_CTRL, 0x18 + len);
+	if (err < 0)
+		goto out;
+
+	do {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_STATUS, i2c_data);
+	} while ((*i2c_data & I2C_BUSY) && !err);
+	if (err < 0)
+		goto out;
+
+	for (i = 0; (i < len) & !err; i++) {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
+
+		PDEBUG(DBG_TRACE, "Reading sensor register "
+				  "0x%x containing 0x%x ", address, *i2c_data);
+	}
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_write_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len)
+{
+	int err, i;
+	u8 *p;
+	struct usb_device *udev = sd->gspca_dev.dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	/* No sensor with a data width larger than 16 bits has yet been seen */
+	if (len > 2 || !len)
+		return -EINVAL;
+
+	memcpy(buf, sensor_urb_skeleton,
+	       sizeof(sensor_urb_skeleton));
+
+	buf[11] = sd->sensor->i2c_slave_id;
+	buf[15] = address;
+
+	/* Special case larger sensor writes */
+	p = buf + 16;
+
+	/* Copy a four byte write sequence for each byte to be written to */
+	for (i = 0; i < len; i++) {
+		memcpy(p, sensor_urb_skeleton + 16, 4);
+		p[3] = i2c_data[i];
+		p += 4;
+		PDEBUG(DBG_TRACE, "Writing sensor register 0x%x with 0x%x",
+		       address, i2c_data[i]);
+	}
+
+	/* Copy the tailer */
+	memcpy(p, sensor_urb_skeleton + 20, 4);
+
+	/* Set the total length */
+	p[3] = 0x10 + len;
+
+	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			      0x04, 0x40, 0x19,
+			      0x0000, buf,
+			      20 + len * 4, M5602_URB_MSG_TIMEOUT);
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_init(struct sd *sd)
+{
+	int i, err = 0;
+
+	for (i = 0; i < ARRAY_SIZE(init_s5k4aa) && !err; i++) {
+		u8 data[2] = {0x00, 0x00};
+
+		switch (init_s5k4aa[i][0]) {
+		case BRIDGE:
+			err = m5602_write_bridge(sd,
+				init_s5k4aa[i][1],
+				init_s5k4aa[i][2]);
+			break;
+
+		case SENSOR:
+			data[0] = init_s5k4aa[i][2];
+			err = s5k4aa_write_sensor(sd,
+				init_s5k4aa[i][1], data, 1);
+			break;
+
+		case SENSOR_LONG:
+			data[0] = init_s5k4aa[i][2];
+			data[1] = init_s5k4aa[i][3];
+			err = s5k4aa_write_sensor(sd,
+				init_s5k4aa[i][1], data, 2);
+			break;
+		default:
+			info("Invalid stream command, exiting init");
+			return -EINVAL;
+		}
+	}
+
+	if (dump_sensor)
+		s5k4aa_dump_registers(sd);
+
+	if (!err && dmi_check_system(s5k4aa_vflip_dmi_table)) {
+		u8 data = 0x02;
+		info("vertical flip quirk active");
+		s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+		s5k4aa_read_sensor(sd, S5K4AA_READ_MODE, &data, 1);
+		data |= S5K4AA_RM_V_FLIP;
+		data &= ~S5K4AA_RM_H_FLIP;
+		s5k4aa_write_sensor(sd, S5K4AA_READ_MODE, &data, 1);
+
+		/* Decrement COLSTART to preserve color order (BGGR) */
+		s5k4aa_read_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
+		data--;
+		s5k4aa_write_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
+
+		/* Increment ROWSTART to preserve color order (BGGR) */
+		s5k4aa_read_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
+		data++;
+		s5k4aa_write_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
+	}
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_power_down(struct sd *sd)
+{
+	return 0;
+}
+
+int s5k4aa_get_exposure(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+
+	err = s5k4aa_read_sensor(sd, S5K4AA_EXPOSURE_HI, &data, 1);
+	if (err < 0)
+		goto out;
+
+	*val = data << 8;
+	err = s5k4aa_read_sensor(sd, S5K4AA_EXPOSURE_LO, &data, 1);
+	*val |= data;
+	PDEBUG(DBG_V4L2_CID, "Read exposure %d", *val);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	PDEBUG(DBG_V4L2_CID, "Set exposure to %d", val);
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+	data = (val >> 8) & 0xff;
+	err = s5k4aa_write_sensor(sd, S5K4AA_EXPOSURE_HI, &data, 1);
+	if (err < 0)
+		goto out;
+	data = val & 0xff;
+	err = s5k4aa_write_sensor(sd, S5K4AA_EXPOSURE_LO, &data, 1);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_get_vflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+
+	err = s5k4aa_read_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	*val = (data & S5K4AA_RM_V_FLIP) >> 7;
+	PDEBUG(DBG_V4L2_CID, "Read vertical flip %d", *val);
+
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	PDEBUG(DBG_V4L2_CID, "Set vertical flip to %d", val);
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+	err = s5k4aa_write_sensor(sd, S5K4AA_READ_MODE, &data, 1);
+	if (err < 0)
+		goto out;
+	data = ((data & ~S5K4AA_RM_V_FLIP)
+			| ((val & 0x01) << 7));
+	err = s5k4aa_write_sensor(sd, S5K4AA_READ_MODE, &data, 1);
+	if (err < 0)
+		goto out;
+
+	if (val) {
+		err = s5k4aa_read_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
+		if (err < 0)
+			goto out;
+
+		data++;
+		err = s5k4aa_write_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
+	} else {
+		err = s5k4aa_read_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
+		if (err < 0)
+			goto out;
+
+		data--;
+		err = s5k4aa_write_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
+	}
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_get_hflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+
+	err = s5k4aa_read_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	*val = (data & S5K4AA_RM_H_FLIP) >> 6;
+	PDEBUG(DBG_V4L2_CID, "Read horizontal flip %d", *val);
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	PDEBUG(DBG_V4L2_CID, "Set horizontal flip to %d",
+	       val);
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+	err = s5k4aa_write_sensor(sd, S5K4AA_READ_MODE, &data, 1);
+	if (err < 0)
+		goto out;
+
+	data = ((data & ~S5K4AA_RM_H_FLIP) | ((val & 0x01) << 6));
+	err = s5k4aa_write_sensor(sd, S5K4AA_READ_MODE, &data, 1);
+	if (err < 0)
+		goto out;
+
+	if (val) {
+		err = s5k4aa_read_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
+		if (err < 0)
+			goto out;
+		data++;
+		err = s5k4aa_write_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
+		if (err < 0)
+			goto out;
+	} else {
+		err = s5k4aa_read_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
+		if (err < 0)
+			goto out;
+		data--;
+		err = s5k4aa_write_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
+	}
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+
+	err = s5k4aa_read_sensor(sd, S5K4AA_GAIN_2, &data, 1);
+	*val = data;
+	PDEBUG(DBG_V4L2_CID, "Read gain %d", *val);
+
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k4aa_set_gain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = S5K4AA_PAGE_MAP_2;
+	int err;
+
+	PDEBUG(DBG_V4L2_CID, "Set gain to %d", val);
+	err = s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &data, 1);
+	if (err < 0)
+		goto out;
+
+	data = val & 0xff;
+	err = s5k4aa_write_sensor(sd, S5K4AA_GAIN_2, &data, 1);
+
+out:
+	return (err < 0) ? err : 0;
+}
+
+void s5k4aa_dump_registers(struct sd *sd)
+{
+	int address;
+	u8 page, old_page;
+	s5k4aa_read_sensor(sd, S5K4AA_PAGE_MAP, &old_page, 1);
+	for (page = 0; page < 16; page++) {
+		s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &page, 1);
+		info("Dumping the s5k4aa register state for page 0x%x", page);
+		for (address = 0; address <= 0xff; address++) {
+			u8 value = 0;
+			s5k4aa_read_sensor(sd, address, &value, 1);
+			info("register 0x%x contains 0x%x",
+			     address, value);
+		}
+	}
+	info("s5k4aa register state dump complete");
+
+	for (page = 0; page < 16; page++) {
+		s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &page, 1);
+		info("Probing for which registers that are "
+		     "read/write for page 0x%x", page);
+		for (address = 0; address <= 0xff; address++) {
+			u8 old_value, ctrl_value, test_value = 0xff;
+
+			s5k4aa_read_sensor(sd, address, &old_value, 1);
+			s5k4aa_write_sensor(sd, address, &test_value, 1);
+			s5k4aa_read_sensor(sd, address, &ctrl_value, 1);
+
+			if (ctrl_value == test_value)
+				info("register 0x%x is writeable", address);
+			else
+				info("register 0x%x is read only", address);
+
+			/* Restore original value */
+			s5k4aa_write_sensor(sd, address, &old_value, 1);
+		}
+	}
+	info("Read/write register probing complete");
+	s5k4aa_write_sensor(sd, S5K4AA_PAGE_MAP, &old_page, 1);
+}
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.h
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.h	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,368 @@
+/*
+ * Driver for the s5k4aa sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef M5602_S5K4AA_H_
+#define M5602_S5K4AA_H_
+
+#include <linux/dmi.h>
+
+#include "m5602_sensor.h"
+
+/*****************************************************************************/
+
+#define S5K4AA_PAGE_MAP			0xec
+
+#define S5K4AA_PAGE_MAP_0		0x00
+#define S5K4AA_PAGE_MAP_1		0x01
+#define S5K4AA_PAGE_MAP_2		0x02
+
+/* Sensor register definitions for page 0x02 */
+#define S5K4AA_READ_MODE		0x03
+#define S5K4AA_ROWSTART_HI		0x04
+#define S5K4AA_ROWSTART_LO		0x05
+#define S5K4AA_COLSTART_HI		0x06
+#define S5K4AA_COLSTART_LO		0x07
+#define S5K4AA_WINDOW_HEIGHT_HI		0x08
+#define S5K4AA_WINDOW_HEIGHT_LO		0x09
+#define S5K4AA_WINDOW_WIDTH_HI		0x0a
+#define S5K4AA_WINDOW_WIDTH_LO		0x0b
+#define S5K4AA_GLOBAL_GAIN__		0x0f /* Only a guess ATM !!! */
+#define S5K4AA_H_BLANK_HI__		0x1d /* Only a guess ATM !!! sync lost
+						if too low, reduces frame rate
+						if too high */
+#define S5K4AA_H_BLANK_LO__		0x1e /* Only a guess ATM !!! */
+#define S5K4AA_EXPOSURE_HI		0x17
+#define S5K4AA_EXPOSURE_LO		0x18
+#define S5K4AA_GAIN_1			0x1f /* (digital?) gain : 5 bits */
+#define S5K4AA_GAIN_2			0x20 /* (analogue?) gain : 7 bits */
+
+#define S5K4AA_RM_ROW_SKIP_4X		0x08
+#define S5K4AA_RM_ROW_SKIP_2X		0x04
+#define S5K4AA_RM_COL_SKIP_4X		0x02
+#define S5K4AA_RM_COL_SKIP_2X		0x01
+#define S5K4AA_RM_H_FLIP		0x40
+#define S5K4AA_RM_V_FLIP		0x80
+
+/*****************************************************************************/
+
+/* Kernel module parameters */
+extern int force_sensor;
+extern int dump_sensor;
+extern unsigned int debug;
+
+int s5k4aa_probe(struct sd *sd);
+int s5k4aa_init(struct sd *sd);
+int s5k4aa_power_down(struct sd *sd);
+
+void s5k4aa_dump_registers(struct sd *sd);
+
+int s5k4aa_read_sensor(struct sd *sd, const u8 address,
+		       u8 *i2c_data, const u8 len);
+int s5k4aa_write_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len);
+
+int s5k4aa_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
+int s5k4aa_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
+int s5k4aa_get_vflip(struct gspca_dev *gspca_dev, __s32 *val);
+int s5k4aa_set_vflip(struct gspca_dev *gspca_dev, __s32 val);
+int s5k4aa_get_hflip(struct gspca_dev *gspca_dev, __s32 *val);
+int s5k4aa_set_hflip(struct gspca_dev *gspca_dev, __s32 val);
+int s5k4aa_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
+int s5k4aa_set_gain(struct gspca_dev *gspca_dev, __s32 val);
+
+static struct m5602_sensor s5k4aa = {
+	.name = "S5K4AA",
+	.probe = s5k4aa_probe,
+	.init = s5k4aa_init,
+	.power_down = s5k4aa_power_down,
+	.read_sensor = s5k4aa_read_sensor,
+	.write_sensor = s5k4aa_write_sensor,
+	.i2c_slave_id = 0x5a,
+	.nctrls = 4,
+	.ctrls = {
+	{
+		{
+			.id 		= V4L2_CID_VFLIP,
+			.type 		= V4L2_CTRL_TYPE_BOOLEAN,
+			.name 		= "vertical flip",
+			.minimum 	= 0,
+			.maximum 	= 1,
+			.step 		= 1,
+			.default_value 	= 0
+		},
+		.set = s5k4aa_set_vflip,
+		.get = s5k4aa_get_vflip
+
+	}, {
+		{
+			.id 		= V4L2_CID_HFLIP,
+			.type 		= V4L2_CTRL_TYPE_BOOLEAN,
+			.name 		= "horizontal flip",
+			.minimum 	= 0,
+			.maximum 	= 1,
+			.step 		= 1,
+			.default_value 	= 0
+		},
+		.set = s5k4aa_set_hflip,
+		.get = s5k4aa_get_hflip
+
+	}, {
+		{
+			.id		= V4L2_CID_GAIN,
+			.type		= V4L2_CTRL_TYPE_INTEGER,
+			.name		= "Gain",
+			.minimum	= 0,
+			.maximum	= 127,
+			.step		= 1,
+			.default_value	= 0xa0,
+			.flags		= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = s5k4aa_set_gain,
+		.get = s5k4aa_get_gain
+	}, {
+		{
+			.id		= V4L2_CID_EXPOSURE,
+			.type		= V4L2_CTRL_TYPE_INTEGER,
+			.name		= "Exposure",
+			.minimum	= 13,
+			.maximum	= 0xfff,
+			.step		= 1,
+			.default_value	= 0x100,
+			.flags		= V4L2_CTRL_FLAG_SLIDER
+		},
+		.set = s5k4aa_set_exposure,
+		.get = s5k4aa_get_exposure
+	}
+	},
+
+	.nmodes = 1,
+	.modes = {
+	{
+		M5602_DEFAULT_FRAME_WIDTH,
+		M5602_DEFAULT_FRAME_HEIGHT,
+		V4L2_PIX_FMT_SBGGR8,
+		V4L2_FIELD_NONE,
+		.sizeimage =
+			M5602_DEFAULT_FRAME_WIDTH * M5602_DEFAULT_FRAME_HEIGHT,
+		.bytesperline = M5602_DEFAULT_FRAME_WIDTH,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 1
+	}
+	}
+};
+
+static const unsigned char preinit_s5k4aa[][4] =
+{
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08, 0x00},
+
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x14, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x1c, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
+
+	{SENSOR, S5K4AA_PAGE_MAP, 0x00, 0x00}
+};
+
+static const unsigned char init_s5k4aa[][4] =
+{
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08, 0x00},
+
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x14, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x1c, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
+
+	{SENSOR, S5K4AA_PAGE_MAP, 0x07, 0x00},
+	{SENSOR, 0x36, 0x01, 0x00},
+	{SENSOR, S5K4AA_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, 0x7b, 0xff, 0x00},
+	{SENSOR, S5K4AA_PAGE_MAP, 0x02, 0x00},
+	{SENSOR, 0x0c, 0x05, 0x00},
+	{SENSOR, 0x02, 0x0e, 0x00},
+	{SENSOR, S5K4AA_GAIN_1, 0x0f, 0x00},
+	{SENSOR, S5K4AA_GAIN_2, 0x00, 0x00},
+	{SENSOR, S5K4AA_GLOBAL_GAIN__, 0x01, 0x00},
+	{SENSOR, 0x11, 0x00, 0x00},
+	{SENSOR, 0x12, 0x00, 0x00},
+	{SENSOR, S5K4AA_PAGE_MAP, 0x02, 0x00},
+	{SENSOR, S5K4AA_READ_MODE, 0xa0, 0x00},
+	{SENSOR, 0x37, 0x00, 0x00},
+	{SENSOR, S5K4AA_ROWSTART_HI, 0x00, 0x00},
+	{SENSOR, S5K4AA_ROWSTART_LO, 0x2a, 0x00},
+	{SENSOR, S5K4AA_COLSTART_HI, 0x00, 0x00},
+	{SENSOR, S5K4AA_COLSTART_LO, 0x0b, 0x00},
+	{SENSOR, S5K4AA_WINDOW_HEIGHT_HI, 0x03, 0x00},
+	{SENSOR, S5K4AA_WINDOW_HEIGHT_LO, 0xc4, 0x00},
+	{SENSOR, S5K4AA_WINDOW_WIDTH_HI, 0x05, 0x00},
+	{SENSOR, S5K4AA_WINDOW_WIDTH_LO, 0x08, 0x00},
+	{SENSOR, S5K4AA_H_BLANK_HI__, 0x00, 0x00},
+	{SENSOR, S5K4AA_H_BLANK_LO__, 0x48, 0x00},
+	{SENSOR, S5K4AA_EXPOSURE_HI, 0x00, 0x00},
+	{SENSOR, S5K4AA_EXPOSURE_LO, 0x43, 0x00},
+	{SENSOR, 0x11, 0x04, 0x00},
+	{SENSOR, 0x12, 0xc3, 0x00},
+	{SENSOR, S5K4AA_PAGE_MAP, 0x02, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x08, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	/* VSYNC_PARA, VSYNC_PARA : img height 480 = 0x01e0 */
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe0, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	/* HSYNC_PARA, HSYNC_PARA : img width 640 = 0x0280 */
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x80, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xa0, 0x00}, /* 48 MHz */
+
+	{SENSOR, S5K4AA_PAGE_MAP, 0x02, 0x00},
+	{SENSOR, S5K4AA_READ_MODE, S5K4AA_RM_H_FLIP | S5K4AA_RM_ROW_SKIP_2X
+		| S5K4AA_RM_COL_SKIP_2X, 0x00},
+	/* 0x37 : Fix image stability when light is too bright and improves
+	 * image quality in 640x480, but worsens it in 1280x1024 */
+	{SENSOR, 0x37, 0x01, 0x00},
+	/* ROWSTART_HI, ROWSTART_LO : 10 + (1024-960)/2 = 42 = 0x002a */
+	{SENSOR, S5K4AA_ROWSTART_HI, 0x00, 0x00},
+	{SENSOR, S5K4AA_ROWSTART_LO, 0x2a, 0x00},
+	{SENSOR, S5K4AA_COLSTART_HI, 0x00, 0x00},
+	{SENSOR, S5K4AA_COLSTART_LO, 0x0c, 0x00},
+	/* window_height_hi, window_height_lo : 960 = 0x03c0 */
+	{SENSOR, S5K4AA_WINDOW_HEIGHT_HI, 0x03, 0x00},
+	{SENSOR, S5K4AA_WINDOW_HEIGHT_LO, 0xc0, 0x00},
+	/* window_width_hi, window_width_lo : 1280 = 0x0500 */
+	{SENSOR, S5K4AA_WINDOW_WIDTH_HI, 0x05, 0x00},
+	{SENSOR, S5K4AA_WINDOW_WIDTH_LO, 0x00, 0x00},
+	{SENSOR, S5K4AA_H_BLANK_HI__, 0x00, 0x00},
+	{SENSOR, S5K4AA_H_BLANK_LO__, 0xa8, 0x00}, /* helps to sync... */
+	{SENSOR, S5K4AA_EXPOSURE_HI, 0x01, 0x00},
+	{SENSOR, S5K4AA_EXPOSURE_LO, 0x00, 0x00},
+	{SENSOR, 0x11, 0x04, 0x00},
+	{SENSOR, 0x12, 0xc3, 0x00},
+	{SENSOR, S5K4AA_PAGE_MAP, 0x02, 0x00},
+	{SENSOR, 0x02, 0x0e, 0x00},
+	{SENSOR_LONG, S5K4AA_GLOBAL_GAIN__, 0x0f, 0x00},
+	{SENSOR, S5K4AA_GAIN_1, 0x0b, 0x00},
+	{SENSOR, S5K4AA_GAIN_2, 0xa0, 0x00}
+};
+
+static const struct dmi_system_id s5k4aa_vflip_dmi_table[] = {
+	{
+		.ident = "Fujitsu-Siemens Amilo Xa 2528",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xa 2528")
+		}
+	},
+	{
+		.ident = "Fujitsu-Siemens Amilo Xi 2550",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xi 2550")
+		}
+	},
+		{
+		.ident = "MSI GX700",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GX700"),
+			DMI_MATCH(DMI_BIOS_DATE, "07/26/2007")
+		}
+	},
+	{ }
+};
+
+#endif
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_s5k83a.c
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_s5k83a.c	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,331 @@
+/*
+ * Driver for the s5k83a sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include "m5602_s5k83a.h"
+
+int s5k83a_probe(struct sd *sd)
+{
+	u8 prod_id = 0, ver_id = 0;
+	int i, err = 0;
+
+	if (force_sensor) {
+		if (force_sensor == S5K83A_SENSOR) {
+			info("Forcing a %s sensor", s5k83a.name);
+			goto sensor_found;
+		}
+		/* If we want to force another sensor, don't try to probe this
+		 * one */
+		return -ENODEV;
+	}
+
+	info("Probing for a s5k83a sensor");
+
+	/* Preinit the sensor */
+	for (i = 0; i < ARRAY_SIZE(preinit_s5k83a) && !err; i++) {
+		u8 data[2] = {preinit_s5k83a[i][2], preinit_s5k83a[i][3]};
+		if (preinit_s5k83a[i][0] == SENSOR)
+			err = s5k83a_write_sensor(sd, preinit_s5k83a[i][1],
+				data, 2);
+		else
+			err = m5602_write_bridge(sd, preinit_s5k83a[i][1],
+				data[0]);
+	}
+
+	/* We don't know what register (if any) that contain the product id
+	 * Just pick the first addresses that seem to produce the same results
+	 * on multiple machines */
+	if (s5k83a_read_sensor(sd, 0x00, &prod_id, 1))
+		return -ENODEV;
+
+	if (s5k83a_read_sensor(sd, 0x01, &ver_id, 1))
+		return -ENODEV;
+
+	if ((prod_id == 0xff) || (ver_id == 0xff))
+		return -ENODEV;
+	else
+		info("Detected a s5k83a sensor");
+
+sensor_found:
+	sd->gspca_dev.cam.cam_mode = s5k83a.modes;
+	sd->gspca_dev.cam.nmodes = s5k83a.nmodes;
+	return 0;
+}
+
+int s5k83a_read_sensor(struct sd *sd, const u8 address,
+			      u8 *i2c_data, const u8 len)
+{
+	int err, i;
+
+	do {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_STATUS, i2c_data);
+	} while ((*i2c_data & I2C_BUSY) && !err);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_DEV_ADDR,
+				 sd->sensor->i2c_slave_id);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_REG_ADDR, address);
+	if (err < 0)
+		goto out;
+
+	err = m5602_write_bridge(sd, M5602_XB_I2C_CTRL, 0x18 + len);
+	if (err < 0)
+		goto out;
+
+	do {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_STATUS, i2c_data);
+	} while ((*i2c_data & I2C_BUSY) && !err);
+
+	if (err < 0)
+		goto out;
+	for (i = 0; i < len && !len; i++) {
+		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
+
+		PDEBUG(DBG_TRACE, "Reading sensor register "
+				  "0x%x containing 0x%x ", address, *i2c_data);
+	}
+
+out:
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_write_sensor(struct sd *sd, const u8 address,
+			       u8 *i2c_data, const u8 len)
+{
+	int err, i;
+	u8 *p;
+	struct usb_device *udev = sd->gspca_dev.dev;
+	__u8 *buf = sd->gspca_dev.usb_buf;
+
+	/* No sensor with a data width larger than 16 bits has yet been seen */
+	if (len > 2 || !len)
+		return -EINVAL;
+
+	memcpy(buf, sensor_urb_skeleton,
+	       sizeof(sensor_urb_skeleton));
+
+	buf[11] = sd->sensor->i2c_slave_id;
+	buf[15] = address;
+
+	/* Special case larger sensor writes */
+	p = buf + 16;
+
+	/* Copy a four byte write sequence for each byte to be written to */
+	for (i = 0; i < len; i++) {
+		memcpy(p, sensor_urb_skeleton + 16, 4);
+		p[3] = i2c_data[i];
+		p += 4;
+		PDEBUG(DBG_TRACE, "Writing sensor register 0x%x with 0x%x",
+		       address, i2c_data[i]);
+	}
+
+	/* Copy the tailer */
+	memcpy(p, sensor_urb_skeleton + 20, 4);
+
+	/* Set the total length */
+	p[3] = 0x10 + len;
+
+	err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			      0x04, 0x40, 0x19,
+			      0x0000, buf,
+			      20 + len * 4, M5602_URB_MSG_TIMEOUT);
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_init(struct sd *sd)
+{
+	int i, err = 0;
+
+	for (i = 0; i < ARRAY_SIZE(init_s5k83a) && !err; i++) {
+		u8 data[2] = {0x00, 0x00};
+
+		switch (init_s5k83a[i][0]) {
+		case BRIDGE:
+			err = m5602_write_bridge(sd,
+					init_s5k83a[i][1],
+					init_s5k83a[i][2]);
+			break;
+
+		case SENSOR:
+			data[0] = init_s5k83a[i][2];
+			err = s5k83a_write_sensor(sd,
+				init_s5k83a[i][1], data, 1);
+			break;
+
+		case SENSOR_LONG:
+			data[0] = init_s5k83a[i][2];
+			data[1] = init_s5k83a[i][3];
+			err = s5k83a_write_sensor(sd,
+				init_s5k83a[i][1], data, 2);
+			break;
+		default:
+			info("Invalid stream command, exiting init");
+			return -EINVAL;
+		}
+	}
+
+	if (dump_sensor)
+		s5k83a_dump_registers(sd);
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_power_down(struct sd *sd)
+{
+	return 0;
+}
+
+void s5k83a_dump_registers(struct sd *sd)
+{
+	int address;
+	u8 page, old_page;
+	s5k83a_read_sensor(sd, S5K83A_PAGE_MAP, &old_page, 1);
+
+	for (page = 0; page < 16; page++) {
+		s5k83a_write_sensor(sd, S5K83A_PAGE_MAP, &page, 1);
+		info("Dumping the s5k83a register state for page 0x%x", page);
+		for (address = 0; address <= 0xff; address++) {
+			u8 val = 0;
+			s5k83a_read_sensor(sd, address, &val, 1);
+			info("register 0x%x contains 0x%x",
+			     address, val);
+		}
+	}
+	info("s5k83a register state dump complete");
+
+	for (page = 0; page < 16; page++) {
+		s5k83a_write_sensor(sd, S5K83A_PAGE_MAP, &page, 1);
+		info("Probing for which registers that are read/write "
+		      "for page 0x%x", page);
+		for (address = 0; address <= 0xff; address++) {
+			u8 old_val, ctrl_val, test_val = 0xff;
+
+			s5k83a_read_sensor(sd, address, &old_val, 1);
+			s5k83a_write_sensor(sd, address, &test_val, 1);
+			s5k83a_read_sensor(sd, address, &ctrl_val, 1);
+
+			if (ctrl_val == test_val)
+				info("register 0x%x is writeable", address);
+			else
+				info("register 0x%x is read only", address);
+
+			/* Restore original val */
+			s5k83a_write_sensor(sd, address, &old_val, 1);
+		}
+	}
+	info("Read/write register probing complete");
+	s5k83a_write_sensor(sd, S5K83A_PAGE_MAP, &old_page, 1);
+}
+
+int s5k83a_get_brightness(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 data[2];
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = s5k83a_read_sensor(sd, S5K83A_BRIGHTNESS, data, 2);
+	data[1] = data[1] << 1;
+	*val = data[1];
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_set_brightness(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 data[2];
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	data[0] = 0x00;
+	data[1] = 0x20;
+	err = s5k83a_write_sensor(sd, 0x14, data, 2);
+	if (err < 0)
+		return err;
+
+	data[0] = 0x01;
+	data[1] = 0x00;
+	err = s5k83a_write_sensor(sd, 0x0d, data, 2);
+	if (err < 0)
+		return err;
+
+	/* FIXME: This is not sane, we need to figure out the composition
+		  of these registers */
+	data[0] = val >> 3; /* brightness, high 5 bits */
+	data[1] = val >> 1; /* brightness, high 7 bits */
+	err = s5k83a_write_sensor(sd, S5K83A_BRIGHTNESS, data, 2);
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_get_whiteness(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 data;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = s5k83a_read_sensor(sd, S5K83A_WHITENESS, &data, 1);
+
+	*val = data;
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_set_whiteness(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err;
+	u8 data[1];
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	data[0] = val;
+	err = s5k83a_write_sensor(sd, S5K83A_WHITENESS, data, 1);
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	int err;
+	u8 data[2];
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	err = s5k83a_read_sensor(sd, S5K83A_GAIN, data, 2);
+
+	data[1] = data[1] & 0x3f;
+	if (data[1] > S5K83A_MAXIMUM_GAIN)
+		data[1] = S5K83A_MAXIMUM_GAIN;
+
+	*val = data[1];
+
+	return (err < 0) ? err : 0;
+}
+
+int s5k83a_set_gain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	int err = 0;
+	u8 data[2];
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	data[0] = 0;
+	data[1] = val;
+	err = s5k83a_write_sensor(sd, S5K83A_GAIN, data, 2);
+
+	return (err < 0) ? err : 0;
+}
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_s5k83a.h
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_s5k83a.h	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,444 @@
+/*
+ * Driver for the s5k83a sensor
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef M5602_S5K83A_H_
+#define M5602_S5K83A_H_
+
+#include "m5602_sensor.h"
+
+#define S5K83A_PAGE_MAP			0xec
+#define S5K83A_GAIN			0x18
+#define S5K83A_WHITENESS		0x0a
+#define S5K83A_BRIGHTNESS 		0x1b
+
+#define S5K83A_DEFAULT_BRIGHTNESS	0x71
+#define S5K83A_DEFAULT_WHITENESS	0x7e
+#define S5K83A_DEFAULT_GAIN		0x00
+#define S5K83A_MAXIMUM_GAIN		0x3c
+
+/*****************************************************************************/
+
+/* Kernel module parameters */
+extern int force_sensor;
+extern int dump_sensor;
+extern unsigned int debug;
+
+
+int s5k83a_probe(struct sd *sd);
+int s5k83a_init(struct sd *sd);
+int s5k83a_power_down(struct sd *sd);
+
+void s5k83a_dump_registers(struct sd *sd);
+
+int s5k83a_read_sensor(struct sd *sd, const u8 address,
+		       u8 *i2c_data, const u8 len);
+int s5k83a_write_sensor(struct sd *sd, const u8 address,
+			u8 *i2c_data, const u8 len);
+
+int s5k83a_set_brightness(struct gspca_dev *gspca_dev, __s32 val);
+int s5k83a_get_brightness(struct gspca_dev *gspca_dev, __s32 *val);
+int s5k83a_set_whiteness(struct gspca_dev *gspca_dev, __s32 val);
+int s5k83a_get_whiteness(struct gspca_dev *gspca_dev, __s32 *val);
+int s5k83a_set_gain(struct gspca_dev *gspca_dev, __s32 val);
+int s5k83a_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
+
+static struct m5602_sensor s5k83a = {
+	.name = "S5K83A",
+	.probe = s5k83a_probe,
+	.init = s5k83a_init,
+	.power_down = s5k83a_power_down,
+	.read_sensor = s5k83a_read_sensor,
+	.write_sensor = s5k83a_write_sensor,
+	.i2c_slave_id = 0x5a,
+	.nctrls = 3,
+	.ctrls = {
+	{
+		{
+			.id = V4L2_CID_BRIGHTNESS,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "brightness",
+			.minimum = 0x00,
+			.maximum = 0xff,
+			.step = 0x01,
+			.default_value = S5K83A_DEFAULT_BRIGHTNESS,
+			.flags = V4L2_CTRL_FLAG_SLIDER
+		},
+			.set = s5k83a_set_brightness,
+			.get = s5k83a_get_brightness
+
+	}, {
+		{
+			.id = V4L2_CID_WHITENESS,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "whiteness",
+			.minimum = 0x00,
+			.maximum = 0xff,
+			.step = 0x01,
+			.default_value = S5K83A_DEFAULT_WHITENESS,
+			.flags = V4L2_CTRL_FLAG_SLIDER
+		},
+			.set = s5k83a_set_whiteness,
+			.get = s5k83a_get_whiteness,
+	}, {
+		{
+			.id = V4L2_CID_GAIN,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "gain",
+			.minimum = 0x00,
+			.maximum = S5K83A_MAXIMUM_GAIN,
+			.step = 0x01,
+			.default_value = S5K83A_DEFAULT_GAIN,
+			.flags = V4L2_CTRL_FLAG_SLIDER
+		},
+			.set = s5k83a_set_gain,
+			.get = s5k83a_get_gain
+	}
+	},
+	.nmodes = 1,
+	.modes = {
+	{
+		M5602_DEFAULT_FRAME_WIDTH,
+		M5602_DEFAULT_FRAME_HEIGHT,
+		V4L2_PIX_FMT_SBGGR8,
+		V4L2_FIELD_NONE,
+		.sizeimage =
+			M5602_DEFAULT_FRAME_WIDTH * M5602_DEFAULT_FRAME_HEIGHT,
+		.bytesperline = M5602_DEFAULT_FRAME_WIDTH,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 1
+
+	}
+	}
+};
+
+static const unsigned char preinit_s5k83a[][4] =
+{
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x0d, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_CTRL, 0x00, 0x00},
+
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x1c, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
+
+	{SENSOR, S5K83A_PAGE_MAP, 0x00, 0x00}
+};
+
+/* This could probably be considerably shortened.
+   I don't have the hardware to experiment with it, patches welcome
+*/
+static const unsigned char init_s5k83a[][4] =
+{
+	{SENSOR, S5K83A_PAGE_MAP, 0x04, 0x00},
+	{SENSOR, 0xaf, 0x01, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, 0x7b, 0xff, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR, 0x01, 0x50, 0x00},
+	{SENSOR, 0x12, 0x20, 0x00},
+	{SENSOR, 0x17, 0x40, 0x00},
+	{SENSOR, S5K83A_BRIGHTNESS, 0x0f, 0x00},
+	{SENSOR, 0x1c, 0x00, 0x00},
+	{SENSOR, 0x02, 0x70, 0x00},
+	{SENSOR, 0x03, 0x0b, 0x00},
+	{SENSOR, 0x04, 0xf0, 0x00},
+	{SENSOR, 0x05, 0x0b, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe4, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x87, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR, 0x06, 0x71, 0x00},
+	{SENSOR, 0x07, 0xe8, 0x00},
+	{SENSOR, 0x08, 0x02, 0x00},
+	{SENSOR, 0x09, 0x88, 0x00},
+	{SENSOR, 0x14, 0x00, 0x00},
+	{SENSOR, 0x15, 0x20, 0x00},
+	{SENSOR, 0x19, 0x00, 0x00},
+	{SENSOR, 0x1a, 0x98, 0x00},
+	{SENSOR, 0x0f, 0x02, 0x00},
+	{SENSOR, 0x10, 0xe5, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR_LONG, 0x14, 0x00, 0x20},
+	{SENSOR_LONG, 0x0d, 0x00, 0x7d},
+	{SENSOR_LONG, 0x1b, 0x0d, 0x05},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe4, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x87, 0x00},
+
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x1c, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
+
+	{SENSOR, S5K83A_PAGE_MAP, 0x04, 0x00},
+	{SENSOR, 0xaf, 0x01, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	/* ff ( init value )is very dark) || 71 and f0 better */
+	{SENSOR, 0x7b, 0xff, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR, 0x01, 0x50, 0x00},
+	{SENSOR, 0x12, 0x20, 0x00},
+	{SENSOR, 0x17, 0x40, 0x00},
+	{SENSOR, S5K83A_BRIGHTNESS, 0x0f, 0x00},
+	{SENSOR, 0x1c, 0x00, 0x00},
+	{SENSOR, 0x02, 0x70, 0x00},
+	/* some values like 0x10 give a blue-purple image */
+	{SENSOR, 0x03, 0x0b, 0x00},
+	{SENSOR, 0x04, 0xf0, 0x00},
+	{SENSOR, 0x05, 0x0b, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	/* under 80 don't work, highter depend on value */
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe4, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x7f, 0x00},
+
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR, 0x06, 0x71, 0x00},
+	{SENSOR, 0x07, 0xe8, 0x00},
+	{SENSOR, 0x08, 0x02, 0x00},
+	{SENSOR, 0x09, 0x88, 0x00},
+	{SENSOR, 0x14, 0x00, 0x00},
+	{SENSOR, 0x15, 0x20, 0x00},
+	{SENSOR, 0x19, 0x00, 0x00},
+	{SENSOR, 0x1a, 0x98, 0x00},
+	{SENSOR, 0x0f, 0x02, 0x00},
+	{SENSOR, 0x10, 0xe5, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR_LONG, 0x14, 0x00, 0x20},
+	{SENSOR_LONG, 0x0d, 0x00, 0x7d},
+	{SENSOR_LONG, 0x1b, 0x0d, 0x05},
+
+	/* The following sequence is useless after a clean boot
+	   but is necessary after resume from suspend */
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x08, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x3f, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_L, 0xff, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0x80, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_DIV, 0x02, 0x00},
+	{BRIDGE, M5602_XB_MCU_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xf0, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR, 0x1d, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT, 0x1c, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DIR_H, 0x06, 0x00},
+	{BRIDGE, M5602_XB_GPIO_DAT_H, 0x00, 0x00},
+	{BRIDGE, M5602_XB_GPIO_EN_L, 0x00, 0x00},
+	{BRIDGE, M5602_XB_I2C_CLK_DIV, 0x20, 0x00},
+
+	{SENSOR, S5K83A_PAGE_MAP, 0x04, 0x00},
+	{SENSOR, 0xaf, 0x01, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x00, 0x00},
+	{SENSOR, 0x7b, 0xff, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR, 0x01, 0x50, 0x00},
+	{SENSOR, 0x12, 0x20, 0x00},
+	{SENSOR, 0x17, 0x40, 0x00},
+	{SENSOR, S5K83A_BRIGHTNESS, 0x0f, 0x00},
+	{SENSOR, 0x1c, 0x00, 0x00},
+	{SENSOR, 0x02, 0x70, 0x00},
+	{SENSOR, 0x03, 0x0b, 0x00},
+	{SENSOR, 0x04, 0xf0, 0x00},
+	{SENSOR, 0x05, 0x0b, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x06, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+	{BRIDGE, M5602_XB_ADC_CTRL, 0xc0, 0x00},
+	{BRIDGE, M5602_XB_SENSOR_TYPE, 0x09, 0x00},
+	{BRIDGE, M5602_XB_LINE_OF_FRAME_H, 0x81, 0x00},
+	{BRIDGE, M5602_XB_PIX_OF_LINE_H, 0x82, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x01, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0xe4, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_VSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x00, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x02, 0x00},
+	{BRIDGE, M5602_XB_HSYNC_PARA, 0x7f, 0x00},
+	{BRIDGE, M5602_XB_SIG_INI, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_DIV, 0x00, 0x00},
+	{BRIDGE, M5602_XB_SEN_CLK_CTRL, 0xb0, 0x00},
+
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR, 0x06, 0x71, 0x00},
+	{SENSOR, 0x07, 0xe8, 0x00},
+	{SENSOR, 0x08, 0x02, 0x00},
+	{SENSOR, 0x09, 0x88, 0x00},
+	{SENSOR, 0x14, 0x00, 0x00},
+	{SENSOR, 0x15, 0x20, 0x00},
+	{SENSOR, 0x19, 0x00, 0x00},
+	{SENSOR, 0x1a, 0x98, 0x00},
+	{SENSOR, 0x0f, 0x02, 0x00},
+
+	{SENSOR, 0x10, 0xe5, 0x00},
+	{SENSOR, S5K83A_PAGE_MAP, 0x05, 0x00},
+	{SENSOR_LONG, 0x14, 0x00, 0x20},
+	{SENSOR_LONG, 0x0d, 0x00, 0x7d},
+	{SENSOR_LONG, 0x1b, 0x0d, 0x05},
+
+	/* normal colors
+	   (this is value after boot, but after tries can be different) */
+	{SENSOR, 0x00, 0x06, 0x00},
+
+	/* set default brightness */
+	{SENSOR_LONG, 0x14, 0x00, 0x20},
+	{SENSOR_LONG, 0x0d, 0x01, 0x00},
+	{SENSOR_LONG, 0x1b, S5K83A_DEFAULT_BRIGHTNESS >> 3,
+			    S5K83A_DEFAULT_BRIGHTNESS >> 1},
+
+	/* set default whiteness */
+	{SENSOR, S5K83A_WHITENESS, S5K83A_DEFAULT_WHITENESS, 0x00},
+
+	/* set default gain */
+	{SENSOR_LONG, 0x18, 0x00, S5K83A_DEFAULT_GAIN}
+};
+
+#endif
diff -r 24bc99070e97 linux/drivers/media/video/gspca/m5602/m5602_sensor.h
- --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/m5602/m5602_sensor.h	Tue Sep 30 07:57:00 2008 +0200
@@ -0,0 +1,76 @@
+/*
+ * USB Driver for ALi m5602 based webcams
+ *
+ * Copyright (C) 2008 Erik Andrén
+ * Copyright (C) 2007 Ilyes Gouta. Based on the m5603x Linux Driver Project.
+ * Copyright (C) 2005 m5603x Linux Driver Project <m5602@x3ng.com.br>
+ *
+ * Portions of code to USB interface and ALi driver software,
+ * Copyright (c) 2006 Willem Duinker
+ * v4l2 interface modeled after the V4L2 driver
+ * for SN9C10x PC Camera Controllers
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef M5602_SENSOR_H_
+#define M5602_SENSOR_H_
+
+#include "m5602_bridge.h"
+
+#define M5602_DEFAULT_FRAME_WIDTH  640
+#define M5602_DEFAULT_FRAME_HEIGHT 480
+
+#define M5602_MAX_CTRLS		(V4L2_CID_LASTP1 - V4L2_CID_BASE + 10)
+
+/* Enumerates all supported sensors */
+enum sensors {
+	OV9650_SENSOR	= 1,
+	S5K83A_SENSOR	= 2,
+	S5K4AA_SENSOR	= 3,
+	MT9M111_SENSOR	= 4,
+	PO1030_SENSOR	= 5
+};
+
+/* Enumerates all possible instruction types */
+enum instruction {
+	BRIDGE,
+	SENSOR,
+	SENSOR_LONG
+};
+
+struct m5602_sensor {
+	/* Defines the name of a sensor */
+	char name[32];
+
+	/* What i2c address the sensor is connected to */
+	u8 i2c_slave_id;
+
+	/* Probes if the sensor is connected */
+	int (*probe)(struct sd *sd);
+
+	/* Performs a initialization sequence */
+	int (*init)(struct sd *sd);
+
+	/* Performs a power down sequence */
+	int (*power_down)(struct sd *sd);
+
+	/* Reads a sensor register */
+	int (*read_sensor)(struct sd *sd, const u8 address,
+	      u8 *i2c_data, const u8 len);
+
+	/* Writes to a sensor register */
+	int (*write_sensor)(struct sd *sd, const u8 address,
+	      u8 *i2c_data, const u8 len);
+
+	int nctrls;
+	struct ctrl ctrls[M5602_MAX_CTRLS];
+
+	char nmodes;
+	struct v4l2_pix_format modes[];
+};
+
+#endif
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI4nK0N7qBt+4UG0ERAtiXAJ41pnsFbGqkSRN8lhNXHLep4jZyAACfWt+K
uXZohQmvdNpKU4+hMrtQnFs=
=9nbn
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
