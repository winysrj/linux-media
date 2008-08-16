Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7G50ZJL004209
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 01:00:35 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7G50VrQ031839
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 01:00:31 -0400
Received: by wr-out-0506.google.com with SMTP id c49so1324174wra.19
	for <video4linux-list@redhat.com>; Fri, 15 Aug 2008 22:00:31 -0700 (PDT)
Date: Sat, 16 Aug 2008 00:00:23 -0500
To: video4linux-list@redhat.com
Message-ID: <20080816050023.GB30725@thumper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
From: majortrips@gmail.com
Subject: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

Adds suport for OmniVision OV534 based cameras:
 - Hercules Blog Webcam
 - Hercules Dualpix HD Webcam
 - Sony HD PS3 Eye (SLEH 00201)

Currently only supports 640x480 YUYV non-interlaced output.

Signed-off-by: Mark Ferrell <majortrips@gmail.com>
---
diff --git a/linux/Documentation/video4linux/ov534.txt b/linux/Documentation/video4linux/ov534.txt
new file mode 100644
--- /dev/null
+++ b/linux/Documentation/video4linux/ov534.txt
@@ -0,0 +1,30 @@
+OmniVision OV534 USB2.0 Camera driver.
+Written by Mark Ferrell <majortrips--a.t--gmail.com>
+
+The OV534 is the chipset used by the Hercules Blog Webcam and Hercules Dualpix
+HD Webcam.  A variation of this chip, the ov538, is used Sony's HD PS3 Eye
+(SLEH 00201).  There is currently no known public information about what is
+different between the ov534 and the ov538.
+
+The original code for initializating the camera and retrieving an image from it
+was written by Jim Paris on ps2dev.org and submitted under the GPL.  It is my
+understanding that Jim sniffed the USB traffic to see what the Playstation3 was
+sending to the camera to initialize it and to start/stop captures.
+
+The V4L interface of the driver was based on the vivi driver with the only
+functionality changes being the addition of USB support, the addition of Jim's
+control code, and a rewrite of the buffer fill code to pull directly from the
+camera.
+
+The ov534 outputs frames in YUYV format, non-interlaced, at 640x480. This
+format does not yet have wide support among user-land applications.  Though at
+the time of this writing xawtv was known to work correctly.
+
+Online information about the ov534 claims that it is capable of handling
+320x240 resolutions as well as supporting JPEG compression, but the commands to
+toggle the size and compression are currently unknown.
+
+If you use the camera with Xawtv you need to force the output resolution to
+640x480 with the geometry command. i.e. xawtv -geometry 640x480
+
+Good Luck
diff --git a/linux/drivers/media/video/Kconfig b/linux/drivers/media/video/Kconfig
--- a/linux/drivers/media/video/Kconfig
+++ b/linux/drivers/media/video/Kconfig
@@ -970,6 +970,17 @@ config USB_S2255
 	  Say Y here if you want support for the Sensoray 2255 USB device.
 	  This driver can be compiled as a module, called s2255drv.
 
+config USB_OV534
+	tristate "USB OV534 Camera support"
+	depends on VIDEO_V4L2
+	select VIDEOBUF_VMALLOC
+	default n
+	help
+	  Say Y here if you want support for OV534 based USB cameras.
+	  Hercules Blog Webcam, Hercules Dualpix HD Webcam, and the
+	  Sony HD Eye for PS3 (SLEH 00201).
+	  This driver can be compiled as a module, called ov534.
+
 endif # V4L_USB_DRIVERS
 
 endif # VIDEO_CAPTURE_DRIVERS
diff --git a/linux/drivers/media/video/Makefile b/linux/drivers/media/video/Makefile
--- a/linux/drivers/media/video/Makefile
+++ b/linux/drivers/media/video/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 
 obj-$(CONFIG_USB_DABUSB)        += dabusb.o
 obj-$(CONFIG_USB_OV511)         += ov511.o
+obj-$(CONFIG_USB_OV534)		+= ov534.o
 obj-$(CONFIG_USB_SE401)         += se401.o
 obj-$(CONFIG_USB_STV680)        += stv680.o
 obj-$(CONFIG_USB_W9968CF)       += w9968cf.o
diff --git a/linux/drivers/media/video/ov534.c b/linux/drivers/media/video/ov534.c
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/video/ov534.c
@@ -0,0 +1,1411 @@
+/*
+ * OmniVision OV534 USB Camera driver
+ *
+ * Cameras:
+ *	Hercules Blog Webcam
+ *	Hercules Dualpix HD Webcam
+ *	Sony HD Eye for PS3 (SLEH 00201)
+ *
+ * Copyright (c) 2008  Mark Ferrell <majortrips--a.t--gmail.com>
+ *
+ * Camera control based on eye.c by Jim Paris <jim--a.t--jtan.com>
+ *
+ * V4L2 code based on vivi.c, see original file for credits.
+ *	
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/usb.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/proc_fs.h>
+#include <linux/highmem.h>
+#include <linux/videodev2.h>
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+/* Include V4L1 specific functions. Should be removed soon */
+#include <linux/videodev.h>
+#endif
+#include <media/videobuf-vmalloc.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+
+#define OV534_MODULE_NAME	"ov534"
+#define OV534_MODULE_DESC	"OmniVision OV534"
+#define OV534_AUTHOR		"Mark Ferrell"
+
+#define OV534_MAJOR_VERSION	0
+#define OV534_MINOR_VERSION	0
+#define OV534_RELEASE		5
+#define OV534_VERSION	KERNEL_VERSION(OV534_MAJOR_VERSION, OV534_MINOR_VERSION, OV534_RELEASE)
+
+#define OV534_REG_ADDRESS	0xf1   /* ? */
+#define OV534_REG_SUBADDR	0xf2
+#define OV534_REG_WRITE		0xf3
+#define OV534_REG_READ		0xf4
+#define OV534_REG_OPERATION	0xf5
+#define OV534_REG_STATUS	0xf6
+
+#define OV534_OP_WRITE_3	0x37
+#define OV534_OP_WRITE_2	0x33
+#define OV534_OP_READ_2		0xf9
+
+/* Wake up at about 30 fps */
+#define CTRL_TIMEOUT 500
+#define WAKE_NUMERATOR 30
+#define WAKE_DENOMINATOR 1001
+
+
+/* globals */
+static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
+static struct video_device ov534;	/* Video device */
+static int video_nr = -1;		/* /dev/videoN, -1 for autodetect */
+
+/* module params */
+module_param_named(debug, ov534.debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level [0-4]");
+
+/* supported controls */
+static struct v4l2_queryctrl ov534_qctrl[] = {
+	{
+		.id            = V4L2_CID_AUDIO_VOLUME,
+		.name          = "Volume",
+		.minimum       = 0,
+		.maximum       = 65535,
+		.step          = 65535/100,
+		.default_value = 65535,
+		.flags         = 0,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+	}, {
+		.id            = V4L2_CID_BRIGHTNESS,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Brightness",
+		.minimum       = 0,
+		.maximum       = 255,
+		.step          = 1,
+		.default_value = 127,
+		.flags         = 0,
+	}, {
+		.id            = V4L2_CID_CONTRAST,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Contrast",
+		.minimum       = 0,
+		.maximum       = 255,
+		.step          = 0x1,
+		.default_value = 0x10,
+		.flags         = 0,
+	}, {
+		.id            = V4L2_CID_SATURATION,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Saturation",
+		.minimum       = 0,
+		.maximum       = 255,
+		.step          = 0x1,
+		.default_value = 127,
+		.flags         = 0,
+	}, {
+		.id            = V4L2_CID_HUE,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Hue",
+		.minimum       = -128,
+		.maximum       = 127,
+		.step          = 0x1,
+		.default_value = 0,
+		.flags         = 0,
+	}
+};
+
+static int qctl_regs[ARRAY_SIZE(ov534_qctrl)];
+#define PDEBUG(level, fmt, args...) \
+	if (ov534.debug >= level) info("[%s:%d] " fmt, __PRETTY_FUNCTION__, __LINE__ , ## args)
+
+static struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x06f8, 0x3002)},	/* Hercules Blog Webcam */
+	{USB_DEVICE(0x06f8, 0x3003)},	/* Hercules Dualpix HD Weblog */
+	{USB_DEVICE(0x1415, 0x2000)},	/* Sony HD Eye for PS3 (SLEH 00201) */
+	{}			/* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, device_table);
+
+struct ov534_fmt {
+	char		*name;
+	u32		fourcc;
+	int		depth;
+	enum v4l2_field field;
+};
+
+static struct ov534_fmt format[] = {
+	{ .name		= "4:2:2, packed, YUYV",
+	  .fourcc	= V4L2_PIX_FMT_YUYV,
+	  .depth	= 16,
+	  .field	= V4L2_FIELD_NONE,
+	},
+};
+
+struct ov534_buffer {
+	struct videobuf_buffer	vb;
+	struct ov534_fmt	*fmt;
+};
+
+struct ov534_dmaqueue {
+	struct list_head	active;
+
+	/* thread for generating video stream*/
+	struct task_struct	*kthread;
+	wait_queue_head_t	wq;
+	/* Counters to control fps rate */
+	int			frame;
+	int			ini_jiffies;
+};
+
+static LIST_HEAD(ov534_devlist);
+
+struct ov534_dev {
+	struct list_head	ov534_devlist;
+
+	spinlock_t		slock;
+	struct mutex		mutex;
+
+	int			users;
+
+	/* various device info */
+	struct video_device	*vfd;
+	struct usb_device	*udev;
+	struct usb_interface	*interface;
+	struct ov534_dmaqueue	vidq;
+
+	/* Several counters */
+	int			h, m, s, ms;
+	unsigned long		jiffies;
+	char			timestr[13];
+
+};
+
+struct ov534_fh {
+	struct ov534_dev	*dev;
+
+	/* video capture */
+	struct ov534_fmt	*fmt;
+	unsigned int		width, height;
+	struct videobuf_queue	vb_vidq;
+
+	enum v4l2_buf_type	type;
+};
+
+
+/* ------------------------------------------------------------------
+	Camera operations
+   ------------------------------------------------------------------*/
+
+static void ov534_reg_write(struct usb_device *udev, u16 reg, u16 val)
+{
+	u16 data = val;
+	int ret;
+
+	PDEBUG(2, "reg=0x%04x, val=0%04x", reg, val);
+	ret = usb_control_msg(udev,
+			      usb_sndctrlpipe(udev, 0),
+			      0x1,
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0x0, reg, &data, 1, CTRL_TIMEOUT);
+	if (ret < 0)
+		PDEBUG(1, "write failed");
+}
+
+static u16 ov534_reg_read(struct usb_device *udev, u16 reg)
+{
+	u16 data;
+	int ret;
+
+	ret = usb_control_msg(udev,
+			      usb_rcvctrlpipe(udev, 0),
+			      0x1,
+			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0x0, reg, &data, 1, CTRL_TIMEOUT);
+	PDEBUG(2, "reg=0x%04x, data=0x%04x", reg, data);
+	if (ret < 0)
+		PDEBUG(1, "read failed");
+	return data;
+}
+
+static void ov534_reg_verify_write(struct usb_device *udev, u16 reg, u16 val)
+{
+	u16 data;
+
+	ov534_reg_write(udev, reg, val);
+	data = ov534_reg_read(udev, reg);
+	if (data != val) {
+		PDEBUG(1, "unexpected result from read: 0x%04x != 0x%04x",
+		       val, data);
+	}
+}
+
+/* Two bits control LED: 0x21 bit 7 and 0x23 bit 7. 
+ * (direction and output)? */
+static void ov534_set_led(struct usb_device *udev, int status)
+{
+	u16 data;
+
+	PDEBUG(2, "led status: %d", status);
+
+	data = ov534_reg_read(udev, 0x21);
+	data |= 0x80;
+	ov534_reg_write(udev, 0x21, data);
+
+	data = ov534_reg_read(udev, 0x23);
+	if (status) {
+		data |=  0x80;
+	} else  {
+		data &= ~(0x80);
+	}
+	ov534_reg_write(udev, 0x23, data);
+}
+
+static int sccb_check_status(struct usb_device *udev)
+{
+	u16 data;
+	int i;
+
+	for (i = 0; i < 5; i++) {
+		data = ov534_reg_read(udev, OV534_REG_STATUS);
+		switch (data & 0xFF) {
+			case 0x00: return 1;
+			case 0x04: return 0;
+			case 0x03: break;
+			default:
+				PDEBUG(1, "sccb status 0x%02x, attempt %d/5\n",
+			       		data, i+1);
+		}
+	}
+	return 0;
+}
+
+static void sccb_reg_write(struct usb_device *udev, u16 reg, u16 val)
+{
+	PDEBUG(2, "reg: 0x%04x, val: 0x%04x", reg, val);
+	ov534_reg_write(udev, OV534_REG_SUBADDR, reg);
+	ov534_reg_write(udev, OV534_REG_WRITE, val);
+	ov534_reg_write(udev, OV534_REG_OPERATION, OV534_OP_WRITE_3);
+
+	if (!sccb_check_status(udev)) {
+		PDEBUG(1, "sccb_reg_write failed");
+	}
+}
+
+static void ov534_setup(struct usb_device *udev)
+{
+	ov534_reg_verify_write(udev, 0xe7, 0x3a);
+
+	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
+	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
+	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
+	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x42);
+
+	ov534_reg_verify_write(udev, 0xc2,0x0c);
+	ov534_reg_verify_write(udev, 0x88,0xf8);
+	ov534_reg_verify_write(udev, 0xc3,0x69);
+	ov534_reg_verify_write(udev, 0x89,0xff);
+	ov534_reg_verify_write(udev, 0x76,0x03);
+	ov534_reg_verify_write(udev, 0x92,0x01);
+	ov534_reg_verify_write(udev, 0x93,0x18);
+	ov534_reg_verify_write(udev, 0x94,0x10);
+	ov534_reg_verify_write(udev, 0x95,0x10);
+	ov534_reg_verify_write(udev, 0xe2,0x00);
+	ov534_reg_verify_write(udev, 0xe7,0x3e);
+
+	ov534_reg_write(udev, 0x1c,0x0a);
+	ov534_reg_write(udev, 0x1d,0x22);
+	ov534_reg_write(udev, 0x1d,0x06);
+
+	ov534_reg_verify_write(udev, 0x96,0x00);
+
+	ov534_reg_write(udev, 0x97,0x20);
+	ov534_reg_write(udev, 0x97,0x20);
+	ov534_reg_write(udev, 0x97,0x20);
+	ov534_reg_write(udev, 0x97,0x0a);
+	ov534_reg_write(udev, 0x97,0x3f);
+	ov534_reg_write(udev, 0x97,0x4a);
+	ov534_reg_write(udev, 0x97,0x20);
+	ov534_reg_write(udev, 0x97,0x15);
+	ov534_reg_write(udev, 0x97,0x0b);
+
+	ov534_reg_verify_write(udev, 0x8e,0x40);
+	ov534_reg_verify_write(udev, 0x1f,0x81);
+	ov534_reg_verify_write(udev, 0x34,0x05);
+	ov534_reg_verify_write(udev, 0xe3,0x04);
+	ov534_reg_verify_write(udev, 0x88,0x00);
+	ov534_reg_verify_write(udev, 0x89,0x00);
+	ov534_reg_verify_write(udev, 0x76,0x00);
+	ov534_reg_verify_write(udev, 0xe7,0x2e);
+	ov534_reg_verify_write(udev, 0x31,0xf9);
+	ov534_reg_verify_write(udev, 0x25,0x42);
+	ov534_reg_verify_write(udev, 0x21,0xf0);
+
+	ov534_reg_write(udev, 0x1c,0x00);
+	ov534_reg_write(udev, 0x1d,0x40);
+	ov534_reg_write(udev, 0x1d,0x02);
+	ov534_reg_write(udev, 0x1d,0x00);
+	ov534_reg_write(udev, 0x1d,0x02);
+	ov534_reg_write(udev, 0x1d,0x57);
+	ov534_reg_write(udev, 0x1d,0xff);
+
+	ov534_reg_verify_write(udev, 0x8d,0x1c);
+	ov534_reg_verify_write(udev, 0x8e,0x80);
+	ov534_reg_verify_write(udev, 0xe5,0x04);
+
+	ov534_set_led(udev, 1);
+
+	sccb_reg_write(udev, 0x12,0x80);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x11,0x01);
+
+	ov534_set_led(udev, 0);
+
+	sccb_reg_write(udev, 0x3d,0x03);
+	sccb_reg_write(udev, 0x17,0x26);
+	sccb_reg_write(udev, 0x18,0xa0);
+	sccb_reg_write(udev, 0x19,0x07);
+	sccb_reg_write(udev, 0x1a,0xf0);
+	sccb_reg_write(udev, 0x32,0x00);
+	sccb_reg_write(udev, 0x29,0xa0);
+	sccb_reg_write(udev, 0x2c,0xf0);
+	sccb_reg_write(udev, 0x65,0x20);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x42,0x7f);
+	sccb_reg_write(udev, 0x63,0xe0);
+	sccb_reg_write(udev, 0x64,0xff);
+	sccb_reg_write(udev, 0x66,0x00);
+	sccb_reg_write(udev, 0x13,0xf0);
+	sccb_reg_write(udev, 0x0d,0x41);
+	sccb_reg_write(udev, 0x0f,0xc5);
+	sccb_reg_write(udev, 0x14,0x11);
+
+	ov534_set_led(udev, 1);
+
+	sccb_reg_write(udev, 0x22,0x7f);
+	sccb_reg_write(udev, 0x23,0x03);
+	sccb_reg_write(udev, 0x24,0x40);
+	sccb_reg_write(udev, 0x25,0x30);
+	sccb_reg_write(udev, 0x26,0xa1);
+	sccb_reg_write(udev, 0x2a,0x00);
+	sccb_reg_write(udev, 0x2b,0x00);
+	sccb_reg_write(udev, 0x6b,0xaa);
+	sccb_reg_write(udev, 0x13,0xff);
+
+	ov534_set_led(udev, 0);
+
+	sccb_reg_write(udev, 0x90,0x05);
+	sccb_reg_write(udev, 0x91,0x01);
+	sccb_reg_write(udev, 0x92,0x03);
+	sccb_reg_write(udev, 0x93,0x00);
+	sccb_reg_write(udev, 0x94,0x60);
+	sccb_reg_write(udev, 0x95,0x3c);
+	sccb_reg_write(udev, 0x96,0x24);
+	sccb_reg_write(udev, 0x97,0x1e);
+	sccb_reg_write(udev, 0x98,0x62);
+	sccb_reg_write(udev, 0x99,0x80);
+	sccb_reg_write(udev, 0x9a,0x1e);
+	sccb_reg_write(udev, 0x9b,0x08);
+	sccb_reg_write(udev, 0x9c,0x20);
+	sccb_reg_write(udev, 0x9e,0x81);
+
+	ov534_set_led(udev, 1);
+
+	sccb_reg_write(udev, 0xa6,0x04);
+	sccb_reg_write(udev, 0x7e,0x0c);
+	sccb_reg_write(udev, 0x7f,0x16);
+	sccb_reg_write(udev, 0x80,0x2a);
+	sccb_reg_write(udev, 0x81,0x4e);
+	sccb_reg_write(udev, 0x82,0x61);
+	sccb_reg_write(udev, 0x83,0x6f);
+	sccb_reg_write(udev, 0x84,0x7b);
+	sccb_reg_write(udev, 0x85,0x86);
+	sccb_reg_write(udev, 0x86,0x8e);
+	sccb_reg_write(udev, 0x87,0x97);
+	sccb_reg_write(udev, 0x88,0xa4);
+	sccb_reg_write(udev, 0x89,0xaf);
+	sccb_reg_write(udev, 0x8a,0xc5);
+	sccb_reg_write(udev, 0x8b,0xd7);
+	sccb_reg_write(udev, 0x8c,0xe8);
+	sccb_reg_write(udev, 0x8d,0x20);
+
+	sccb_reg_write(udev, 0x0c,0x90);
+
+
+	ov534_reg_verify_write(udev, 0xc0,0x50);
+	ov534_reg_verify_write(udev, 0xc1,0x3c);
+	ov534_reg_verify_write(udev, 0xc2,0x0c);
+
+	ov534_set_led(udev, 1);
+
+	sccb_reg_write(udev, 0x2b,0x00);
+	sccb_reg_write(udev, 0x22,0x7f);
+	sccb_reg_write(udev, 0x23,0x03);
+	sccb_reg_write(udev, 0x11,0x01);
+	sccb_reg_write(udev, 0x0c,0xd0);
+	sccb_reg_write(udev, 0x64,0xff);
+	sccb_reg_write(udev, 0x0d,0x41);
+
+	sccb_reg_write(udev, 0x14,0x41);
+	sccb_reg_write(udev, 0x0e,0xcd);
+	sccb_reg_write(udev, 0xac,0xbf);
+	sccb_reg_write(udev, 0x8e,0x00);
+	sccb_reg_write(udev, 0x0c,0xd0);
+
+	ov534_reg_write(udev, 0xe0,0x09);
+	ov534_set_led(udev, 0);
+}
+
+
+/* ------------------------------------------------------------------
+	DMA and thread functions
+   ------------------------------------------------------------------*/
+
+static void ov534_fillbuff(struct ov534_dev *dev, struct ov534_buffer *buf)
+{
+	int size  = ((buf->vb.height * buf->vb.width * 16) >> 3) - 4;
+	struct timeval ts;
+	unsigned char *tmpbuf;
+	void *vbuf = videobuf_to_vmalloc(&buf->vb);
+	int ret, len;
+
+	if (!vbuf)
+		return;
+
+	tmpbuf = kmalloc(size + 4, GFP_ATOMIC);
+	if (!tmpbuf)
+		return;
+
+	PDEBUG(2, "reading frame, size=%d", size);
+	ov534_reg_write(dev->udev, 0xe0, 0x00);
+	ret = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, 0x1),
+			   tmpbuf, size, &len, CTRL_TIMEOUT);
+	ov534_reg_write(dev->udev, 0xe0, 0x09);
+	if (ret < 0) {
+		PDEBUG(1, "error reading bulk msg (%d)", ret);
+	} else {
+		PDEBUG(2, "read=%d, expected=%d", len, size);
+	}
+
+	memcpy(vbuf, tmpbuf, size);
+
+	kfree(tmpbuf);
+
+	/* Updates stream time */
+
+	dev->ms += jiffies_to_msecs(jiffies-dev->jiffies);
+	dev->jiffies = jiffies;
+	if (dev->ms >= 1000) {
+		dev->ms -= 1000;
+		dev->s++;
+		if (dev->s >= 60) {
+			dev->s -= 60;
+			dev->m++;
+			if (dev->m > 60) {
+				dev->m -= 60;
+				dev->h++;
+				if (dev->h > 24)
+					dev->h -= 24;
+			}
+		}
+	}
+	sprintf(dev->timestr, "%02d:%02d:%02d:%03d",
+			dev->h, dev->m, dev->s, dev->ms);
+
+	PDEBUG(2, "ov534 fill at %s: Buffer 0x%08lx size=%d",
+			dev->timestr, (unsigned long)tmpbuf, size);
+
+	/* Advice that buffer was filled */
+	buf->vb.field_count++;
+	do_gettimeofday(&ts);
+	buf->vb.ts = ts;
+	buf->vb.state = VIDEOBUF_DONE;
+}
+
+
+static void ov534_thread_tick(struct ov534_fh *fh)
+{
+	struct ov534_buffer *buf;
+	struct ov534_dev *dev = fh->dev;
+	struct ov534_dmaqueue *dma_q = &dev->vidq;
+
+	unsigned long flags = 0;
+
+	PDEBUG(3, "Thread tick");
+
+	spin_lock_irqsave(&dev->slock, flags);
+	if (list_empty(&dma_q->active)) {
+		PDEBUG(1, "No active queue to serve");
+		goto unlock;
+	}
+
+	buf = list_entry(dma_q->active.next,
+			 struct ov534_buffer, vb.queue);
+
+	/* Nobody is waiting on this buffer, return */
+	if (!waitqueue_active(&buf->vb.done))
+		goto unlock;
+
+	list_del(&buf->vb.queue);
+
+	do_gettimeofday(&buf->vb.ts);
+
+	/* Fill buffer */
+	ov534_fillbuff(dev, buf);
+	PDEBUG(2, "filled buffer %p", buf);
+
+	wake_up(&buf->vb.done);
+	PDEBUG(2, "[%p/%d] wakeup", buf, buf->vb. i);
+unlock:
+	spin_unlock_irqrestore(&dev->slock, flags);
+	return;
+}
+
+#define frames_to_ms(frames)					\
+	((frames * WAKE_NUMERATOR * 1000) / WAKE_DENOMINATOR)
+
+static void ov534_sleep(struct ov534_fh *fh)
+{
+	struct ov534_dev *dev = fh->dev;
+	struct ov534_dmaqueue *dma_q = &dev->vidq;
+	int timeout;
+	DECLARE_WAITQUEUE(wait, current);
+
+	PDEBUG(2, "dma_q=0x%08lx\n", (unsigned long)dma_q);
+
+	add_wait_queue(&dma_q->wq, &wait);
+	if (kthread_should_stop())
+		goto stop_task;
+
+	/* Calculate time to wake up */
+	timeout = msecs_to_jiffies(frames_to_ms(1));
+
+	ov534_thread_tick(fh);
+
+	schedule_timeout_interruptible(timeout);
+
+stop_task:
+	remove_wait_queue(&dma_q->wq, &wait);
+	try_to_freeze();
+}
+
+static int ov534_thread(void *data)
+{
+	struct ov534_fh  *fh = data;
+
+	PDEBUG(3, "thread started\n");
+
+	set_freezable();
+
+	for (;;) {
+		ov534_sleep(fh);
+
+		if (kthread_should_stop())
+			break;
+	}
+	PDEBUG(3, "thread: exit\n");
+	return 0;
+}
+
+static int ov534_start_thread(struct ov534_fh *fh)
+{
+	struct ov534_dev *dev = fh->dev;
+	struct ov534_dmaqueue *dma_q = &dev->vidq;
+
+	dma_q->frame = 0;
+	dma_q->ini_jiffies = jiffies;
+
+	PDEBUG(3, "begin");
+
+	dma_q->kthread = kthread_run(ov534_thread, fh, "ov534");
+
+	if (IS_ERR(dma_q->kthread)) {
+		printk(KERN_ERR "ov534: kernel_thread() failed\n");
+		return PTR_ERR(dma_q->kthread);
+	}
+	/* Wakes thread */
+	wake_up_interruptible(&dma_q->wq);
+
+	PDEBUG(3, "end");
+	return 0;
+}
+
+static void ov534_stop_thread(struct ov534_dmaqueue  *dma_q)
+{
+	PDEBUG(3, "begin");
+	/* shutdown control thread */
+	if (dma_q->kthread) {
+		kthread_stop(dma_q->kthread);
+		dma_q->kthread = NULL;
+	}
+	PDEBUG(3, "end");
+}
+
+/* ------------------------------------------------------------------
+	Videobuf operations
+   ------------------------------------------------------------------*/
+
+static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
+			unsigned int *size)
+{
+	struct ov534_fh *fh = vq->priv_data;
+
+	*size = (fh->height * fh->width * fh->fmt->depth) >> 3;
+
+	if (*count == 0)
+		*count = 32;
+
+	while (*size * *count > vid_limit * 1024 * 1024)
+		(*count)--;
+
+	PDEBUG(2, "count=%d, size=%d", *count, *size);
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct ov534_buffer *buf)
+{
+	PDEBUG(3, "begin");
+	PDEBUG(2, "state=%i", buf->vb.state);
+
+	if (in_interrupt())
+		BUG();
+
+	videobuf_vmalloc_free(&buf->vb);
+	PDEBUG(2, "freed");
+	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+
+	PDEBUG(3, "end");
+}
+
+static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
+				enum v4l2_field field)
+{
+	struct ov534_fh     *fh  = vq->priv_data;
+	struct ov534_buffer *buf = container_of(vb,struct ov534_buffer,vb);
+	int rc, init_buffer = 0;
+
+	PDEBUG(2, "field=%d", field);
+	BUG_ON(NULL == fh->fmt);
+
+	if (fh->width != 640 || fh->height != 480)
+		return -EINVAL;
+	buf->vb.size = (fh->height * fh->width * fh->fmt->depth) >> 3;
+
+	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
+		return -EINVAL;
+
+	if (buf->fmt       != fh->fmt    ||
+	    buf->vb.width  != fh->width  ||
+	    buf->vb.height != fh->height ||
+	buf->vb.field  != field) {
+		buf->fmt       = fh->fmt;
+		buf->vb.width  = fh->width;
+		buf->vb.height = fh->height;
+		buf->vb.field  = field;
+		init_buffer = 1;
+	}
+
+	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
+		rc = videobuf_iolock(vq, &buf->vb, NULL);
+		if (rc < 0)
+			goto fail;
+	}
+
+	buf->vb.state = VIDEOBUF_PREPARED;
+
+	return 0;
+
+fail:
+	free_buffer(vq, buf);
+	return rc;
+}
+
+static void
+buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+	struct ov534_buffer *buf = container_of(vb,struct ov534_buffer,vb);
+	struct ov534_fh *fh = vq->priv_data;
+	struct ov534_dev *dev = fh->dev;
+	struct ov534_dmaqueue *vidq = &dev->vidq;
+
+	PDEBUG(3, "begin");
+
+	buf->vb.state = VIDEOBUF_QUEUED;
+	list_add_tail(&buf->vb.queue, &vidq->active);
+
+	PDEBUG(3, "end");
+}
+
+static void buffer_release(struct videobuf_queue *vq,
+				struct videobuf_buffer *vb)
+{
+	struct ov534_buffer   *buf  = container_of(vb,struct ov534_buffer,vb);
+
+	PDEBUG(3, "begin");
+	free_buffer(vq, buf);
+	PDEBUG(3, "end");
+}
+
+static struct videobuf_queue_ops ov534_video_qops = {
+	.buf_setup      = buffer_setup,
+	.buf_prepare    = buffer_prepare,
+	.buf_queue      = buffer_queue,
+	.buf_release    = buffer_release,
+};
+
+
+/* ------------------------------------------------------------------
+	IOCTL vidioc handling
+   ------------------------------------------------------------------*/
+
+static int vidioc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, OV534_MODULE_NAME);
+	cap->version = OV534_VERSION;
+	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE	|
+				V4L2_CAP_STREAMING	|
+				V4L2_CAP_READWRITE;
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_fmtdesc *f)
+{
+	if (f->index >= (sizeof(format) / sizeof(struct ov534_fmt)))
+		return -EINVAL;
+
+	strlcpy(f->description,format[f->index].name,sizeof(f->description));
+	f->pixelformat = format[f->index].fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct ov534_fh	*fh = priv;
+
+	f->fmt.pix.width	= fh->width;
+	f->fmt.pix.height	= fh->height;
+	f->fmt.pix.field	= fh->vb_vidq.field;
+	f->fmt.pix.pixelformat	= fh->fmt->fourcc;
+	f->fmt.pix.bytesperline =
+		(f->fmt.pix.width * fh->fmt->depth) >> 3;
+	f->fmt.pix.sizeimage	=
+		f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct ov534_fmt *fmt = NULL;
+	int len = sizeof(format) / sizeof(struct ov534_fmt);
+	int i = 0;
+
+	for (i = 0; i < len; i++) {
+		if (format[i].fourcc == f->fmt.pix.pixelformat)
+			fmt = &format[i];
+	}
+
+	if (fmt == NULL) {
+		PDEBUG(2, "Fourcc format (0x%08x) invalid",
+		       f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	if (f->fmt.pix.field != fmt->field &&
+	    f->fmt.pix.field != V4L2_FIELD_ANY) {
+		PDEBUG(1,"Field type invalid.");
+		return -EINVAL;
+	}
+
+	f->fmt.pix.pixelformat = fmt->fourcc;
+	f->fmt.pix.field = fmt->field;
+	f->fmt.pix.width = 640;
+	f->fmt.pix.height = 480;
+	f->fmt.pix.bytesperline =
+		(f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.sizeimage =
+		f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct ov534_fh		*fh = priv;
+	struct videobuf_queue *q = &fh->vb_vidq;
+	int len = sizeof(format) / sizeof(struct ov534_fmt);
+	int i = 0;
+
+	int ret = vidioc_try_fmt_vid_cap(file, fh, f);
+	if (ret < 0)
+		return (ret);
+
+	mutex_lock(&q->vb_lock);
+
+	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
+		PDEBUG(1, "queue busy");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	for (i = 0; i < len; i++) {
+		if (format[i].fourcc == f->fmt.pix.pixelformat)
+			fh->fmt = &format[i];
+	}
+
+	fh->width		= f->fmt.pix.width;
+	fh->height		= f->fmt.pix.height;
+	fh->vb_vidq.field	= f->fmt.pix.field;
+	fh->type		= f->type;
+
+	ret = 0;
+out:
+	mutex_unlock(&q->vb_lock);
+
+	return (ret);
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+				struct v4l2_requestbuffers *p)
+{
+	struct ov534_fh  *fh = priv;
+
+	return (videobuf_reqbufs(&fh->vb_vidq, p));
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+				struct v4l2_buffer *p)
+{
+	struct ov534_fh  *fh = priv;
+
+	return (videobuf_querybuf(&fh->vb_vidq, p));
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct ov534_fh  *fh = priv;
+
+	return (videobuf_qbuf(&fh->vb_vidq, p));
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct ov534_fh  *fh = priv;
+
+	return (videobuf_dqbuf(&fh->vb_vidq, p,
+				file->f_flags & O_NONBLOCK));
+}
+
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
+{
+	struct ov534_fh  *fh = priv;
+
+	return videobuf_cgmbuf(&fh->vb_vidq, mbuf, 8);
+}
+#endif
+
+static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct video_device *vdf = video_devdata(file);
+	struct ov534_dev *dev;
+	struct ov534_fh  *fh = priv;
+
+	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (i != fh->type)
+		return -EINVAL;
+
+	if (vdf == NULL)
+		return -ENODEV;
+	dev = video_get_drvdata(vdf);
+
+	ov534_set_led(dev->udev, 1);
+
+	return videobuf_streamon(&fh->vb_vidq);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct video_device *vdf = video_devdata(file);
+	struct ov534_dev *dev;
+	struct ov534_fh  *fh = priv;
+
+	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (i != fh->type)
+		return -EINVAL;
+
+	if (vdf == NULL)
+		return -ENODEV;
+	dev = video_get_drvdata(vdf);
+
+	ov534_set_led(dev->udev, 0);
+
+	return videobuf_streamoff(&fh->vb_vidq);
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
+{
+	return 0;
+}
+
+/* only one input */
+static int vidioc_enum_input(struct file *file, void *priv,
+				struct v4l2_input *inp)
+{
+	if (inp->index != 0)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std = V4L2_STD_525_60;
+	strcpy(inp->name, "Camera");
+
+	return (0);
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+
+	return (0);
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+
+	return (0);
+}
+
+static int vidioc_queryctrl(struct file *file, void *priv,
+				struct v4l2_queryctrl *qc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ov534_qctrl); i++)
+		if (qc->id && qc->id == ov534_qctrl[i].id) {
+			memcpy(qc, &(ov534_qctrl[i]),
+				sizeof(*qc));
+			return (0);
+		}
+
+	return -EINVAL;
+}
+
+static int vidioc_g_ctrl(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ov534_qctrl); i++)
+		if (ctrl->id == ov534_qctrl[i].id) {
+			ctrl->value = qctl_regs[i];
+			return (0);
+		}
+
+	return -EINVAL;
+}
+
+static int vidioc_s_ctrl(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ov534_qctrl); i++)
+		if (ctrl->id == ov534_qctrl[i].id) {
+			if (ctrl->value <
+				ov534_qctrl[i].minimum
+				|| ctrl->value >
+				ov534_qctrl[i].maximum) {
+					return (-ERANGE);
+				}
+			qctl_regs[i] = ctrl->value;
+			return (0);
+		}
+	return -EINVAL;
+}
+
+static const struct v4l2_ioctl_ops ov534_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+	.vidioc_s_std		= vidioc_s_std,
+	.vidioc_enum_input	= vidioc_enum_input,
+	.vidioc_g_input		= vidioc_g_input,
+	.vidioc_s_input		= vidioc_s_input,
+	.vidioc_queryctrl	= vidioc_queryctrl,
+	.vidioc_g_ctrl		= vidioc_g_ctrl,
+	.vidioc_s_ctrl		= vidioc_s_ctrl,
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+	.vidiocgmbuf		= vidiocgmbuf,
+#endif
+};
+
+
+/* ------------------------------------------------------------------
+	File operations for the device
+   ------------------------------------------------------------------*/
+
+static int ov534_open(struct inode *inode, struct file *file)
+{
+	int minor = iminor(inode);
+	struct ov534_dev *dev;
+	struct ov534_fh *fh = NULL;
+	int i;
+	int retval = 0;
+
+	printk(KERN_DEBUG "ov534: open called (minor=%d)\n", minor);
+
+	lock_kernel();
+	list_for_each_entry(dev, &ov534_devlist, ov534_devlist)
+		if (dev->vfd->minor == minor)
+			goto found;
+	unlock_kernel();
+	return -ENODEV;
+
+found:
+	mutex_lock(&dev->mutex);
+	dev->users++;
+
+	if (dev->users > 1) {
+		dev->users--;
+		retval = -EBUSY;
+		goto unlock;
+	}
+
+	PDEBUG(2, "open minor=%d type=%s users=%d\n", minor,
+		v4l2_type_names[V4L2_BUF_TYPE_VIDEO_CAPTURE], dev->users);
+
+	/* allocate + initialize per filehandle data */
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (NULL == fh) {
+		dev->users--;
+		retval = -ENOMEM;
+		goto unlock;
+	}
+unlock:
+	mutex_unlock(&dev->mutex);
+	if (retval) {
+		unlock_kernel();
+		return retval;
+	}
+
+	file->private_data = fh;
+	fh->dev      = dev;
+
+	fh->type     = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fh->fmt      = &format[0];
+	fh->width    = 640;
+	fh->height   = 480;
+
+	/* Put all controls at a sane state */
+	for (i = 0; i < ARRAY_SIZE(ov534_qctrl); i++)
+		qctl_regs[i] = ov534_qctrl[i].default_value;
+
+	/* Resets frame counters */
+	dev->h = 0;
+	dev->m = 0;
+	dev->s = 0;
+	dev->ms = 0;
+	dev->jiffies = jiffies;
+
+	sprintf(dev->timestr,"%02d:%02d:%02d:%03d",
+			dev->h, dev->m, dev->s, dev->ms);
+
+	videobuf_queue_vmalloc_init(&fh->vb_vidq, &ov534_video_qops,
+			NULL, &dev->slock, fh->type, fh->fmt->field,
+			sizeof(struct ov534_buffer), fh);
+
+	ov534_start_thread(fh);
+	unlock_kernel();
+
+	return 0;
+}
+
+static ssize_t
+ov534_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
+{
+	struct ov534_fh        *fh = file->private_data;
+
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		return videobuf_read_stream(&fh->vb_vidq, data, count, ppos, 0,
+					file->f_flags & O_NONBLOCK);
+	}
+	return 0;
+}
+
+static unsigned int
+ov534_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct ov534_fh        *fh = file->private_data;
+	struct videobuf_queue *q = &fh->vb_vidq;
+
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
+		return POLLERR;
+
+	return videobuf_poll_stream(file, q, wait);
+}
+
+static int ov534_close(struct inode *inode, struct file *file)
+{
+	struct ov534_fh         *fh = file->private_data;
+	struct ov534_dev *dev       = fh->dev;
+	struct ov534_dmaqueue *vidq = &dev->vidq;
+
+	int minor = iminor(inode);
+
+	ov534_stop_thread(vidq);
+	videobuf_stop(&fh->vb_vidq);
+	videobuf_mmap_free(&fh->vb_vidq);
+
+	kfree(fh);
+
+	mutex_lock(&dev->mutex);
+	dev->users--;
+	mutex_unlock(&dev->mutex);
+
+	PDEBUG(2, "ov534: close called (minor=%d, users=%d)", minor,dev->users);
+
+	return 0;
+}
+
+static int ov534_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct ov534_fh        *fh = file->private_data;
+	int ret;
+
+	PDEBUG (2, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
+
+	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+
+	PDEBUG (2, "vma start=0x%08lx, size=%ld, ret=%d\n",
+		(unsigned long)vma->vm_start,
+		(unsigned long)vma->vm_end-(unsigned long)vma->vm_start,
+		ret);
+
+	return ret;
+}
+
+static struct file_operations ov534_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ov534_open,
+	.release	= ov534_close,
+	.read		= ov534_read,
+	.poll		= ov534_poll,
+	.mmap		= ov534_mmap,
+	.ioctl		= video_ioctl2,
+	.compat_ioctl	= v4l_compat_ioctl32,
+	.llseek		= no_llseek,
+};
+
+
+static struct video_device ov534_template = {
+	.name		= OV534_MODULE_NAME,
+	.fops		= &ov534_fops,
+	.ioctl_ops 	= &ov534_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release,
+
+	.tvnorms		= V4L2_STD_525_60,
+	.current_norm		= V4L2_STD_NTSC_M,
+};
+
+
+/*******************/
+/* USB integration */
+/*******************/
+
+static int ov534_probe(struct usb_interface *intf,
+			 const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct ov534_dev *dev;
+	char *desc;
+	int err;
+
+	info(OV534_MODULE_DESC " compatible webcam detected");
+
+	switch (udev->descriptor.idVendor) {
+	case 0x06f8:
+		switch (udev->descriptor.idProduct) {
+		case 0x3002:
+			desc = "Hercules Blog Webcam";
+			break;
+		case 0x3003:
+			desc = "Hercules Dualpix HD Webcam";
+			break;
+		default:
+			return -ENODEV;
+		}
+		break;
+	case 0x1415:
+		switch (udev->descriptor.idProduct) {
+		case 0x2000:
+			desc = "Sony HD Eye for PS3 (SLEH 00201)";
+			break;
+		default:
+			return -ENODEV;
+		}
+		break;
+	default:
+		return -ENODEV;
+	}
+	info("%04x:%04x %s found", udev->descriptor.idVendor,
+		udev->descriptor.idProduct, desc);
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL)
+		return -ENOMEM;
+
+	list_add_tail(&dev->ov534_devlist,&ov534_devlist);
+
+	/* init video dma queues */
+	INIT_LIST_HEAD(&dev->vidq.active);
+	init_waitqueue_head(&dev->vidq.wq);
+
+	/* init locks */
+	spin_lock_init(&dev->slock);
+	mutex_init(&dev->mutex);
+
+	dev->vfd = video_device_alloc();
+	if (dev->vfd == NULL) {
+		kfree(dev);
+		return -ENOMEM;
+	}
+	memcpy(dev->vfd, &ov534_template, sizeof(ov534_template));
+
+	video_set_drvdata(dev->vfd, dev);
+	if (ov534.debug > 3)
+		dev->vfd->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
+
+	dev->udev = udev;
+
+	err = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
+
+	if (err) {
+		info("video_register_device failed");
+		video_device_release(dev->vfd);
+		kfree(dev->vfd);
+		kfree(dev);
+		return err;
+	}
+
+	usb_set_intfdata(intf, dev);
+
+	ov534_setup(udev);	
+
+	info(OV534_MODULE_NAME " controlling video device %d", dev->vfd->minor);
+	return 0;
+}
+
+static void ov534_disconnect(struct usb_interface *intf)
+{
+	struct ov534_dev *dev = usb_get_intfdata(intf);
+
+	list_del(&dev->ov534_devlist);
+
+	usb_set_intfdata(intf, NULL);
+	dev_set_drvdata(&intf->dev, NULL);
+
+	info(OV534_MODULE_NAME " webcam unplugged");
+	if (dev->vfd) {
+		if (-1 != dev->vfd->minor) {
+			video_unregister_device(dev->vfd);
+			printk(KERN_INFO "%s: /dev/video%d unregistered.\n",
+				OV534_MODULE_NAME, dev->vfd->minor);
+		} else {
+			video_device_release(dev->vfd);
+			printk(KERN_INFO "%s: /dev/video%d released.\n",
+				OV534_MODULE_NAME, dev->vfd->minor);
+		}
+	}
+
+	dev->vfd = NULL;
+
+	kfree(dev);
+}
+
+
+/**********************/
+/* Module integration */
+/**********************/
+
+static struct usb_driver ov534_driver = {
+	.name = "ov534",
+	.probe = ov534_probe,
+	.disconnect = ov534_disconnect,
+	.id_table = device_table
+};
+
+
+static int __init ov534_init(void)
+{
+	int retval;
+	retval = usb_register(&ov534_driver);
+	if (retval)
+		info("usb_register failed!");
+	else
+		info("%s v%d.%d.%d module loaded",
+			OV534_MODULE_NAME,
+			OV534_MAJOR_VERSION,
+			OV534_MINOR_VERSION,
+			OV534_RELEASE);
+	return retval;
+}
+
+
+static void __exit ov534_exit(void)
+{
+	info(OV534_MODULE_NAME " module unloaded");
+	usb_deregister(&ov534_driver);
+}
+
+
+module_init(ov534_init);
+module_exit(ov534_exit);
+
+MODULE_AUTHOR(OV534_AUTHOR);
+MODULE_DESCRIPTION(OV534_MODULE_DESC);
+MODULE_LICENSE("GPL");

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
