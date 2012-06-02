Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61524 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2FBPdI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 11:33:08 -0400
Received: by yenm10 with SMTP id m10so2394989yen.19
        for <linux-media@vger.kernel.org>; Sat, 02 Jun 2012 08:33:06 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [RFC/PATCH v2] media: Add stk1160 new driver
Date: Sat,  2 Jun 2012 12:32:49 -0300
Message-Id: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver adds support for stk1160 usb bridge as used in some
video/audio usb capture devices.
It is a complete rewrite of staging/media/easycap driver and
it's expected as a future replacement.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
As of today testing has been performed using both vlc and mplayer
on a gentoo machine, including hot unplug and on-the-fly standard
change using a device with 1-cvs and 1-audio output.
However more testing is underway with another device and/or another
distribution.

Support for multiple input devices is a missing feature.
Alsa sound support is a missing feature. (I'm working on both)

As this is my first complete driver,
the patch (obviously) intended as RFC only.
Any comments/reviews of *any* kind will be greatly appreciated.

This new version tries to solve the issues pointed out by
Hans Verkuil and Sylwester Nawrocki (thanks to both!)

Changes from v1:
  * Use media control framework
  * Register video device as the last thing
  * Use v4l_device release to release all resources
  * Add explicit locking for file operations
  * Add vb2 buffer sanity check
  * Minor style cleanups

---
 drivers/media/video/Kconfig                 |    2 +
 drivers/media/video/Makefile                |    1 +
 drivers/media/video/stk1160/Kconfig         |   11 +
 drivers/media/video/stk1160/Makefile        |    6 +
 drivers/media/video/stk1160/stk1160-core.c  |  449 ++++++++++++++
 drivers/media/video/stk1160/stk1160-i2c.c   |  302 ++++++++++
 drivers/media/video/stk1160/stk1160-reg.h   |   78 +++
 drivers/media/video/stk1160/stk1160-v4l.c   |  852 +++++++++++++++++++++++++++
 drivers/media/video/stk1160/stk1160-video.c |  507 ++++++++++++++++
 drivers/media/video/stk1160/stk1160.h       |  185 ++++++
 10 files changed, 2393 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/stk1160/Kconfig
 create mode 100644 drivers/media/video/stk1160/Makefile
 create mode 100644 drivers/media/video/stk1160/stk1160-core.c
 create mode 100644 drivers/media/video/stk1160/stk1160-i2c.c
 create mode 100644 drivers/media/video/stk1160/stk1160-reg.h
 create mode 100644 drivers/media/video/stk1160/stk1160-v4l.c
 create mode 100644 drivers/media/video/stk1160/stk1160-video.c
 create mode 100644 drivers/media/video/stk1160/stk1160.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 99937c9..8d94d56 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -661,6 +661,8 @@ source "drivers/media/video/hdpvr/Kconfig"
 
 source "drivers/media/video/em28xx/Kconfig"
 
+source "drivers/media/video/stk1160/Kconfig"
+
 source "drivers/media/video/tlg2300/Kconfig"
 
 source "drivers/media/video/cx231xx/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index d209de0..7698b25 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -125,6 +125,7 @@ obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
 obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
+obj-$(CONFIG_VIDEO_STK1160) += stk1160/
 
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
diff --git a/drivers/media/video/stk1160/Kconfig b/drivers/media/video/stk1160/Kconfig
new file mode 100644
index 0000000..d481b8e
--- /dev/null
+++ b/drivers/media/video/stk1160/Kconfig
@@ -0,0 +1,11 @@
+config VIDEO_STK1160
+	tristate "STK1160 USB video capture support"
+	depends on VIDEO_DEV && I2C && EASYCAP!=m && EASYCAP!=y
+	select VIDEOBUF2_VMALLOC
+	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
+
+	---help---
+	  This is a video4linux driver for STK1160 based video capture devices
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stk1160
diff --git a/drivers/media/video/stk1160/Makefile b/drivers/media/video/stk1160/Makefile
new file mode 100644
index 0000000..30ca209
--- /dev/null
+++ b/drivers/media/video/stk1160/Makefile
@@ -0,0 +1,6 @@
+stk1160-y := stk1160-core.o stk1160-v4l.o stk1160-video.o stk1160-i2c.o
+
+obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
+
+ccflags-y += -Wall
+ccflags-y += -Idrivers/media/video
diff --git a/drivers/media/video/stk1160/stk1160-core.c b/drivers/media/video/stk1160/stk1160-core.c
new file mode 100644
index 0000000..b638363
--- /dev/null
+++ b/drivers/media/video/stk1160/stk1160-core.c
@@ -0,0 +1,449 @@
+/*
+ * STK1160 driver
+ *
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ * Based on Easycap driver by R.M. Thomas
+ *	Copyright (C) 2010 R.M. Thomas
+ *	<rmthomas--a.t--sciolus.org>
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
+ * TODO:
+ * 1) Should I dealloc buffers when stop or only on disconnect?
+ *   See em28xx patch about memory fragmentation.
+ *   (Perhaps allow a parameter to control this)
+ *
+ * 2) Add debug v4l2 ioctl.
+ *
+ * 3) How about framesize and frameinterval v4l2 ioctl?
+ *
+ * 4) Replace pr_xxx for dev_xxx. Perhaps will have to use device_{get/put}.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+
+#include <linux/usb.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <media/saa7115.h>
+
+#include "stk1160.h"
+#include "stk1160-reg.h"
+
+static unsigned int input;
+module_param(input, int, 0644);
+MODULE_PARM_DESC(input, "Set default input");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ezequiel Garcia");
+MODULE_DESCRIPTION("STK1160 driver");
+
+/* Devices supported by this driver */
+static struct usb_device_id stk1160_id_table[] = {
+	{ USB_DEVICE(0x05e1, 0x0408) },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, stk1160_id_table);
+
+/* saa7113 I2C address */
+static unsigned short saa7113_addrs[] = {
+	0x4a >> 1,
+	I2C_CLIENT_END
+};
+
+/*
+ * Read/Write stk registers
+ */
+int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
+{
+	int ret;
+
+	*value = 0;
+	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
+			0x00,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0x00,
+			reg,
+			value,
+			sizeof(u8),
+			HZ);
+	if (ret < 0) {
+		stk1160_err("read failed on reg 0x%x (%d)\n",
+			reg, ret);
+		return ret;
+	}
+	return 0;
+}
+
+int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
+{
+	int ret;
+
+	ret =  usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
+			0x01,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			value,
+			reg,
+			NULL,
+			0,
+			HZ);
+	if (ret < 0) {
+		stk1160_err("write failed on reg 0x%x (%d)\n",
+			reg, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/* TODO: We should break this into pieces */
+void stk1160_reg_reset(struct stk1160 *dev)
+{
+	int i;
+
+	static struct regval ctl[] = {
+		{STK1160_GCTRL,   0x0080},
+		{STK1160_GCTRL+2, 0x0000},
+		{STK1160_GCTRL+1, 0x0003},
+		{STK1160_GCTRL+3, 0x0080},
+
+		{STK1160_RMCTL+1, 0x0000},
+		{STK1160_RMCTL+3, 0x0002},
+
+		{STK1160_PLLSO,   0x0010},
+		{STK1160_PLLSO+1, 0x0000},
+		{STK1160_PLLSO+2, 0x0014},
+		{STK1160_PLLSO+3, 0x000E},
+
+		{STK1160_PLLFD,   0x0046},
+
+		/* Timing generator setup */
+		{STK1160_TIGEN,   0x0012},
+		{STK1160_TICTL,   0x002D},
+		{STK1160_TICTL+1, 0x0001},
+		{STK1160_TICTL+2, 0x0000},
+		{STK1160_TICTL+3, 0x0000},
+		{STK1160_TIGEN,   0x0080},
+
+		{0xffff, 0xffff}
+	};
+
+#if 0
+	switch (dev->ctl_input) {
+	case 0:
+		stk1160_write_reg(dev, STK1160_GCTRL, 0x98);
+		break;
+	case 1:
+		stk1160_write_reg(dev, STK1160_GCTRL, 0x90);
+		break;
+	case 2:
+		stk1160_write_reg(dev, STK1160_GCTRL, 0x88);
+		break;
+	case 3:
+		stk1160_write_reg(dev, STK1160_GCTRL, 0x80);
+		break;
+	}
+#endif
+
+	for (i = 0; ctl[i].reg != 0xffff; i++)
+		stk1160_write_reg(dev, ctl[i].reg, ctl[i].val);
+}
+
+static void stk1160_release(struct v4l2_device *v4l2_dev)
+{
+	struct stk1160 *dev = container_of(v4l2_dev, struct stk1160, v4l2_dev);
+
+	stk1160_info("releasing all resources\n");
+
+	stk1160_i2c_unregister(dev);
+
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev->alt_max_pkt_size);
+	kfree(dev);
+}
+
+/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
+#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
+
+/*
+ * Scan usb interface and populate max_pkt_size array
+ * with information on each alternate setting.
+ * The array should be allocated by the caller.
+ */
+static int stk1160_scan_usb(struct usb_interface *intf, struct usb_device *udev,
+		unsigned int *max_pkt_size)
+{
+	int i, e, sizedescr, size, ifnum, inputnum;
+	const struct usb_endpoint_descriptor *desc;
+
+	bool has_video = false, has_audio = false;
+	char *speed;
+
+	ifnum = intf->altsetting[0].desc.bInterfaceNumber;
+
+	/* Get endpoints */
+	for (i = 0; i < intf->num_altsetting; i++) {
+
+		for (e = 0; e < intf->altsetting[i].desc.bNumEndpoints; e++) {
+
+			/* This isn't clear enough, at least to me */
+			desc = &intf->altsetting[i].endpoint[e].desc;
+			sizedescr = le16_to_cpu(desc->wMaxPacketSize);
+			size = sizedescr & 0x7ff;
+
+			if (udev->speed == USB_SPEED_HIGH)
+				size = size * hb_mult(sizedescr);
+
+			if (usb_endpoint_xfer_isoc(desc) &&
+			    usb_endpoint_dir_in(desc)) {
+				switch (desc->bEndpointAddress) {
+				case STK1160_EP_AUDIO:
+					has_audio = true;
+					break;
+				case STK1160_EP_VIDEO:
+					has_video = true;
+					max_pkt_size[i] = size;
+					break;
+				}
+			}
+		}
+	}
+
+	/* Is this even possible? */
+	if (!(has_audio || has_video)) {
+		dev_err(&udev->dev, "no audio or video endpoints found\n");
+		return -ENODEV;
+	}
+
+	switch (udev->speed) {
+	case USB_SPEED_LOW:
+		speed = "1.5";
+		break;
+	case USB_SPEED_UNKNOWN:
+	case USB_SPEED_FULL:
+		speed = "12";
+		break;
+	case USB_SPEED_HIGH:
+		speed = "480";
+		break;
+	default:
+		speed = "unknown";
+	}
+
+	dev_info(&udev->dev, "New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
+		udev->manufacturer ? udev->manufacturer : "",
+		udev->product ? udev->product : "",
+		speed,
+		le16_to_cpu(udev->descriptor.idVendor),
+		le16_to_cpu(udev->descriptor.idProduct),
+		ifnum,
+		intf->altsetting->desc.bInterfaceNumber);
+
+	if (has_audio)
+		dev_info(&udev->dev, "audio vendor class interface %d found\n",
+				ifnum);
+
+	/* TODO: Check if inputnum shows relevant information */
+	if (has_video)
+		dev_info(&udev->dev, "video interface %d found, %d inputs\n",
+				ifnum, inputnum);
+
+	/*
+	 * Make sure we have 480 Mbps of bandwidth, otherwise things like
+	 * video stream wouldn't likely work, since 12 Mbps is generally
+	 * not enough even for most streams.
+	 */
+	if (udev->speed != USB_SPEED_HIGH) {
+		dev_err(&udev->dev, "must be connected to a high-speed USB 2.0 port\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int stk1160_probe(struct usb_interface *interface,
+		const struct usb_device_id *id)
+{
+	int ifnum;
+	int rc = 0;
+
+	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
+	struct usb_device *udev;
+	struct stk1160 *dev;
+
+	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
+	udev = interface_to_usbdev(interface);
+
+	/* Don't register audio interfaces */
+	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
+		/* Why spit an error message? */
+		stk1160_err("audio device (%04x:%04x): interface %i, class %i\n",
+			le16_to_cpu(udev->descriptor.idVendor),
+			le16_to_cpu(udev->descriptor.idProduct),
+			ifnum,
+			interface->altsetting[0].desc.bInterfaceClass);
+		return -ENODEV;
+	}
+
+	/* Alloc an array for all possible max_pkt_size */
+	alt_max_pkt_size = kmalloc(sizeof(alt_max_pkt_size[0]) *
+			interface->num_altsetting, GFP_KERNEL);
+	if (alt_max_pkt_size == NULL)
+		return -ENOMEM;
+
+	/*
+	 * Scan usb posibilities and populate alt_max_pkt_size array.
+	 * Also, check if device speed is fast enough.
+	 */
+	rc = stk1160_scan_usb(interface, udev, alt_max_pkt_size);
+	if (rc < 0) {
+		kfree(alt_max_pkt_size);
+		return rc;
+	}
+
+	dev = kzalloc(sizeof(struct stk1160), GFP_KERNEL);
+	if (dev == NULL) {
+		kfree(alt_max_pkt_size);
+		return -ENOMEM;
+	}
+
+	dev->alt_max_pkt_size = alt_max_pkt_size;
+	dev->udev = udev;
+	dev->num_alt = interface->num_altsetting;
+	dev->ctl_input = input;
+
+	/* We save struct device for debug purposes only */
+	dev->dev = &interface->dev;
+
+	usb_set_intfdata(interface, dev);
+
+	/* initialize videobuf2 stuff */
+	rc = stk1160_vb2_setup(dev);
+	if (rc < 0)
+		goto free_err;
+
+	/*
+	 * There is no need to take any locks here in probe
+	 * because we register the device node as the *last* thing.
+	 */
+	spin_lock_init(&dev->buf_lock);
+	mutex_init(&dev->v4l_lock);
+
+	rc = v4l2_ctrl_handler_init(&dev->ctrl_handler, 0);
+	if (rc) {
+		stk1160_err("v4l2_ctrl_handler_init failed (%d)\n", rc);
+		goto free_err;
+	}
+
+	/*
+	 * We obtain a v4l2_dev but defer
+	 * registration of video device node as the last thing.
+	 * There is no need to set the name if we give a device struct
+	 */
+	dev->v4l2_dev.release = stk1160_release;
+	dev->v4l2_dev.ctrl_handler = &dev->ctrl_handler;
+	rc = v4l2_device_register(dev->dev, &dev->v4l2_dev);
+	if (rc) {
+		stk1160_err("v4l2_device_register failed (%d)\n", rc);
+		goto free_ctrl;
+	}
+
+	rc = stk1160_i2c_register(dev);
+	if (rc < 0)
+		goto unreg_v4l2;
+
+	/*
+	 * To the best of my knowledge stk1160 boards only have
+	 * saa7113, but it doesn't hurt to support them all.
+	 */
+	dev->sd_saa7115 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		"saa7115_auto", 0, saa7113_addrs);
+
+	stk1160_info("driver ver %s successfully loaded\n",
+		STK1160_VERSION);
+
+	/* i2c reset saa711x */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
+				0, 0, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+
+	/* reset stk1160 to default values */
+	stk1160_reg_reset(dev);
+
+	rc = stk1160_video_register(dev);
+	if (rc < 0)
+		goto unreg_i2c;
+
+	return 0;
+
+unreg_i2c:
+	stk1160_i2c_unregister(dev);
+unreg_v4l2:
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_ctrl:
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+free_err:
+	kfree(alt_max_pkt_size);
+	kfree(dev);
+
+	return rc;
+}
+
+/*
+ * TODO: What happens if device gets diconnected while probing?
+ */
+static void stk1160_disconnect(struct usb_interface *interface)
+{
+	struct stk1160 *dev;
+
+	dev = usb_get_intfdata(interface);
+	usb_set_intfdata(interface, NULL);
+
+	/*
+	 * Wait until all current v4l2 operation are finished
+	 * then deallocate resources
+	 */
+	mutex_lock(&dev->v4l_lock);
+
+	stk1160_stop_streaming(dev, false);
+
+	video_unregister_device(&dev->vdev);
+	v4l2_device_disconnect(&dev->v4l2_dev);
+
+	/* This way current users can detect device is gone */
+	dev->udev = NULL;
+
+	mutex_unlock(&dev->v4l_lock);
+
+	/*
+	 * This calls stk1160_release if it's the last reference.
+	 * therwise, release is posponed until there are no users left.
+	 */
+	v4l2_device_put(&dev->v4l2_dev);
+}
+
+static struct usb_driver stk1160_usb_driver = {
+	.name = "stk1160",
+	.id_table = stk1160_id_table,
+	.probe = stk1160_probe,
+	.disconnect = stk1160_disconnect,
+};
+
+module_usb_driver(stk1160_usb_driver);
diff --git a/drivers/media/video/stk1160/stk1160-i2c.c b/drivers/media/video/stk1160/stk1160-i2c.c
new file mode 100644
index 0000000..879517c
--- /dev/null
+++ b/drivers/media/video/stk1160/stk1160-i2c.c
@@ -0,0 +1,302 @@
+/*
+ * STK1160 driver
+ *
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ * Based on Easycap driver by R.M. Thomas
+ *	Copyright (C) 2010 R.M. Thomas
+ *	<rmthomas--a.t--sciolus.org>
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
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/i2c.h>
+
+#include "stk1160.h"
+#include "stk1160-reg.h"
+
+static unsigned int i2c_debug;
+module_param(i2c_debug, int, 0644);
+MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
+
+#define dprintk_i2c(fmt, args...)				\
+do {								\
+	if (i2c_debug)						\
+		printk(KERN_DEBUG fmt, ##args);			\
+} while (0)
+
+static int stk1160_i2c_write_reg(struct stk1160 *dev, u8 addr,
+		u8 reg, u8 value)
+{
+	int rc, timeout;
+	u8 flag;
+
+	/* Set serial device address */
+	rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
+	if (rc < 0)
+		return rc;
+
+	/* Set i2c device register sub-address */
+	rc = stk1160_write_reg(dev, STK1160_SBUSW_WA, reg);
+	if (rc < 0)
+		return rc;
+
+	/* Set i2c device register value */
+	rc = stk1160_write_reg(dev, STK1160_SBUSW_WD, value);
+	if (rc < 0)
+		return rc;
+
+	/* Start write now */
+	rc = stk1160_write_reg(dev, STK1160_SICTL, 0x01);
+	if (rc < 0)
+		return rc;
+
+	/* Wait until Write Finish bit is set */
+	for (timeout = 100; timeout > 0;
+	     timeout -= 20) {
+		stk1160_read_reg(dev, STK1160_SICTL+1, &flag);
+		/* write done? */
+		if (flag & 0x04)
+			break;
+
+		msleep(20);
+	}
+
+	if (timeout == 0)
+		/* return EBUSY, or EFAULT, or what ? */
+		return -EIO;
+
+	return 0;
+}
+
+static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
+		u8 reg, u8 *value)
+{
+	int rc, timeout;
+	u8 flag;
+
+	/* Set serial device address */
+	rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
+	if (rc < 0)
+		return rc;
+
+	/* Set i2c device register sub-address */
+	rc = stk1160_write_reg(dev, STK1160_SBUSR_RA, reg);
+	if (rc < 0)
+		return rc;
+
+	/* Start read now */
+	rc = stk1160_write_reg(dev, STK1160_SICTL, 0x20);
+	if (rc < 0)
+		return rc;
+
+	/* Wait until Read Finish bit is set */
+	for (timeout = 100; timeout > 0;
+	     timeout -= 20) {
+		stk1160_read_reg(dev, STK1160_SICTL+1, &flag);
+		/* read done? */
+		if (flag & 0x01)
+			break;
+
+		msleep(20);
+	}
+
+	if (timeout == 0)
+		/* return EBUSY, or EFAULT, or what ? */
+		return -EIO;
+
+	stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+/*
+ * stk1160_i2c_check_for_device()
+ * check if there is a i2c_device at the supplied address
+ */
+static int stk1160_i2c_check_for_device(struct stk1160 *dev,
+		unsigned char addr)
+{
+	int rc, write_timeout;
+	u8 flag;
+
+	/* Set serial device address */
+	rc = stk1160_write_reg(dev, STK1160_SICTL_SDA, addr);
+	if (rc < 0)
+		return rc;
+
+	/* Set device sub-address, we'll chip version reg */
+	rc = stk1160_write_reg(dev, STK1160_SBUSR_RA, 0x00);
+	if (rc < 0)
+		return rc;
+
+	/* Start read now */
+	rc = stk1160_write_reg(dev, STK1160_SICTL, 0x20);
+	if (rc < 0)
+		return rc;
+
+	/* Wait until Read Finish bit is set */
+	for (write_timeout = 40; write_timeout > 0;
+	     write_timeout -= 20) {
+		stk1160_read_reg(dev, STK1160_SICTL+1, &flag);
+		if (flag & 0x01)
+			return 0;
+
+		msleep(20);
+	}
+
+	return -ENODEV;
+}
+
+/*
+ * stk1160_i2c_xfer()
+ * the main i2c transfer function
+ */
+static int stk1160_i2c_xfer(struct i2c_adapter *i2c_adap,
+			   struct i2c_msg msgs[], int num)
+{
+	struct stk1160 *dev = i2c_adap->algo_data;
+	int addr, rc, i;
+
+	for (i = 0; i < num; i++) {
+		addr = msgs[i].addr << 1;
+		dprintk_i2c("%s: addr=%x", __func__, addr);
+
+		if (!msgs[i].len) {
+			/* no len: check only for device presence */
+			rc = stk1160_i2c_check_for_device(dev, addr);
+			if (rc < 0) {
+				dprintk_i2c(" no device\n");
+				return rc;
+			}
+
+		} else if (msgs[i].flags & I2C_M_RD) {
+			/* read request without preceding register selection */
+			dprintk_i2c(" subaddr not selected");
+			rc = -EOPNOTSUPP;
+			goto err;
+
+		} else if (i + 1 < num && msgs[i].len <= 2 &&
+			   (msgs[i + 1].flags & I2C_M_RD) &&
+			   msgs[i].addr == msgs[i + 1].addr) {
+
+			if (msgs[i].len != 1 || msgs[i + 1].len != 1) {
+				dprintk_i2c(" len not supported");
+				rc = -EOPNOTSUPP;
+				goto err;
+			}
+
+			dprintk_i2c(" subaddr=%x", msgs[i].buf[0]);
+
+			rc = stk1160_i2c_read_reg(dev, addr, msgs[i].buf[0],
+				msgs[i + 1].buf);
+
+			dprintk_i2c(" read=%x", *msgs[i + 1].buf);
+
+			/* consumed two msgs, so we skip one of them */
+			i++;
+
+		} else {
+			if (msgs[i].len != 2) {
+				dprintk_i2c(" len not supported");
+				rc = -EOPNOTSUPP;
+				goto err;
+			}
+
+			dprintk_i2c(" subaddr=%x write=%x",
+				msgs[i].buf[0],  msgs[i].buf[1]);
+
+			rc = stk1160_i2c_write_reg(dev, addr, msgs[i].buf[0],
+				msgs[i].buf[1]);
+		}
+
+		if (rc < 0)
+			goto err;
+		dprintk_i2c(" OK\n");
+	}
+
+	return num;
+err:
+	dprintk_i2c(" ERROR: %d\n", rc);
+	return num;
+}
+
+/*
+ * functionality(), what da heck is this?
+ */
+static u32 functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm algo = {
+	.master_xfer   = stk1160_i2c_xfer,
+	.functionality = functionality,
+};
+
+static struct i2c_adapter adap_template = {
+	.owner = THIS_MODULE,
+	.name = "stk1160",
+	.algo = &algo,
+};
+
+static struct i2c_client client_template = {
+	.name = "stk1160 internal",
+};
+
+/*
+ * stk1160_i2c_register()
+ * register i2c bus
+ */
+int stk1160_i2c_register(struct stk1160 *dev)
+{
+	int rc;
+
+	dev->i2c_adap = adap_template;
+	dev->i2c_adap.dev.parent = dev->dev;
+	strcpy(dev->i2c_adap.name, "stk1160");
+	dev->i2c_adap.algo_data = dev;
+
+	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
+
+	rc = i2c_add_adapter(&dev->i2c_adap);
+	if (rc < 0) {
+		stk1160_err("cannot add i2c adapter (%d)\n", rc);
+		return rc;
+	}
+
+	dev->i2c_client = client_template;
+	dev->i2c_client.adapter = &dev->i2c_adap;
+
+	/* Set i2c clock divider device address */
+	stk1160_write_reg(dev, STK1160_SICTL_CD,  0x0f);
+
+	/* ??? */
+	stk1160_write_reg(dev, STK1160_ASIC + 3,  0x00);
+
+	return 0;
+}
+
+/*
+ * stk1160_i2c_unregister()
+ * unregister i2c_bus
+ */
+int stk1160_i2c_unregister(struct stk1160 *dev)
+{
+	i2c_del_adapter(&dev->i2c_adap);
+	return 0;
+}
diff --git a/drivers/media/video/stk1160/stk1160-reg.h b/drivers/media/video/stk1160/stk1160-reg.h
new file mode 100644
index 0000000..99cc155
--- /dev/null
+++ b/drivers/media/video/stk1160/stk1160-reg.h
@@ -0,0 +1,78 @@
+/*
+ * STK1160 driver
+ *
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ * Based on Easycap driver by R.M. Thomas
+ *	Copyright (C) 2010 R.M. Thomas
+ *	<rmthomas--a.t--sciolus.org>
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
+ */
+
+/* GPIO Control */
+#define STK1160_GCTRL			0x000
+
+/* Remote Wakup Control */
+#define STK1160_RMCTL			0x00C
+
+/*
+ * Decoder Control Register:
+ * This byte controls capture start/stop
+ * with bit #7 (0x?? OR 0x80 to activate).
+ */
+#define STK1160_DCTRL			0x100
+
+/* Capture Frame Start Position */
+#define STK116_CFSPO			0x110
+#define STK116_CFSPO_STX_L		0x110
+#define STK116_CFSPO_STX_H		0x111
+#define STK116_CFSPO_STY_L		0x112
+#define STK116_CFSPO_STY_H		0x113
+
+/* Capture Frame End Position */
+#define STK116_CFEPO			0x114
+#define STK116_CFEPO_ENX_L		0x114
+#define STK116_CFEPO_ENX_H		0x115
+#define STK116_CFEPO_ENY_L		0x116
+#define STK116_CFEPO_ENY_H		0x117
+
+/* Serial Interface Control  */
+#define STK1160_SICTL			0x200
+#define STK1160_SICTL_CD		0x202
+#define STK1160_SICTL_SDA		0x203
+
+/* Serial Bus Write */
+#define STK1160_SBUSW			0x204
+#define STK1160_SBUSW_WA		0x204
+#define STK1160_SBUSW_WD		0x205
+
+/* Serial Bus Read */
+#define STK1160_SBUSR			0x208
+#define STK1160_SBUSR_RA		0x208
+#define STK1160_SBUSR_RD		0x209
+
+/* Alternate Serial Inteface Control */
+#define STK1160_ASIC			0x2FC
+
+/* PLL Select Options */
+#define STK1160_PLLSO			0x018
+
+/* PLL Frequency Divider */
+#define STK1160_PLLFD			0x01C
+
+/* Timing Generator */
+#define STK1160_TIGEN			0x300
+
+/* Timing Control Parameter */
+#define STK1160_TICTL			0x350
diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/video/stk1160/stk1160-v4l.c
new file mode 100644
index 0000000..67c1b2b
--- /dev/null
+++ b/drivers/media/video/stk1160/stk1160-v4l.c
@@ -0,0 +1,852 @@
+/*
+ * STK1160 driver
+ *
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ * Based on Easycap driver by R.M. Thomas
+ *	Copyright (C) 2010 R.M. Thomas
+ *	<rmthomas--a.t--sciolus.org>
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
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/videobuf2-vmalloc.h>
+
+#include <media/saa7115.h>
+
+#include "stk1160.h"
+#include "stk1160-reg.h"
+
+static unsigned int vidioc_debug;
+module_param(vidioc_debug, int, 0644);
+MODULE_PARM_DESC(vidioc_debug, "enable debug messages [vidioc]");
+
+/* supported video standards */
+static struct stk1160_fmt format[] = {
+	{
+		.name     = "16 bpp YUY2, 4:2:2, packed",
+		.fourcc   = V4L2_PIX_FMT_UYVY,
+		.depth    = 16,
+	}
+};
+
+static void stk1160_set_std(struct stk1160 *dev)
+{
+	int i;
+
+	static struct regval std525[] = {
+
+		/* 720x480 */
+
+		/* Frame start */
+		{STK116_CFSPO_STX_L, 0x0000},
+		{STK116_CFSPO_STX_H, 0x0000},
+		{STK116_CFSPO_STY_L, 0x0003},
+		{STK116_CFSPO_STY_H, 0x0000},
+
+		/* Frame end */
+		{STK116_CFEPO_ENX_L, 0x05a0},
+		{STK116_CFEPO_ENX_H, 0x0005},
+		{STK116_CFEPO_ENY_L, 0x00f3},
+		{STK116_CFEPO_ENY_H, 0x0000},
+
+		{0xffff, 0xffff}
+	};
+
+	static struct regval std625[] = {
+
+		/* 720x576 */
+
+		/* TODO: Each line of frame has some junk at the end */
+		/* Frame start */
+		{STK116_CFSPO,   0x0000},
+		{STK116_CFSPO+1, 0x0000},
+		{STK116_CFSPO+2, 0x0001},
+		{STK116_CFSPO+3, 0x0000},
+
+		/* Frame end */
+		{STK116_CFEPO,   0x05a0},
+		{STK116_CFEPO+1, 0x0005},
+		{STK116_CFEPO+2, 0x0121},
+		{STK116_CFEPO+3, 0x0001},
+
+		{0xffff, 0xffff}
+	};
+
+	if (dev->vdev.current_norm & V4L2_STD_525_60) {
+		stk1160_dbg("registers to NTSC like standard\n");
+		for (i = 0; std525[i].reg != 0xffff; i++)
+			stk1160_write_reg(dev, std525[i].reg, std525[i].val);
+	} else if (dev->vdev.current_norm & V4L2_STD_625_50) {
+		stk1160_dbg("registers to PAL like standard\n");
+		for (i = 0; std625[i].reg != 0xffff; i++)
+			stk1160_write_reg(dev, std625[i].reg, std625[i].val);
+	} else {
+		BUG();
+	}
+
+}
+
+static int stk1160_set_alternate(struct stk1160 *dev)
+{
+	int i, prev_alt = dev->alt;
+	unsigned int min_pkt_size;
+
+	/*
+	 * If we don't set right alternate,
+	 * then we will get a green screen with junk.
+	 */
+	min_pkt_size = STK1160_MIN_PKT_SIZE;
+
+	for (i = 0; i < dev->num_alt; i++) {
+		/* stop when the selected alt setting offers enough bandwidth */
+		if (dev->alt_max_pkt_size[i] >= min_pkt_size) {
+			dev->alt = i;
+			break;
+		/*
+		 * otherwise make sure that we end up with the maximum bandwidth
+		 * because the min_pkt_size equation might be wrong...
+		 */
+		} else if (dev->alt_max_pkt_size[i] >
+			   dev->alt_max_pkt_size[dev->alt])
+			dev->alt = i;
+	}
+
+	stk1160_dbg("setting alternate %d\n", dev->alt);
+
+	if (dev->alt != prev_alt) {
+		stk1160_dbg("minimum isoc packet size: %u (alt=%d)\n",
+				min_pkt_size, dev->alt);
+		dev->max_pkt_size = dev->alt_max_pkt_size[dev->alt];
+		stk1160_dbg("setting alt %d with wMaxPacketSize=%u\n",
+			       dev->alt, dev->max_pkt_size);
+		usb_set_interface(dev->udev, 0, dev->alt);
+	}
+	return 0;
+}
+
+static bool stk1160_acquire_owner(struct stk1160 *dev, struct file *file)
+{
+	/* If there is an owner and it's not this filehandle */
+	if (dev->fh_owner != NULL && dev->fh_owner != file)
+		return false;
+
+	/* We are the owner of this queue and queue operations */
+	dev->fh_owner = file;
+
+	return true;
+}
+
+static void stk1160_drop_owner(struct stk1160 *dev)
+{
+	dev->fh_owner = NULL;
+}
+
+static bool stk1160_is_owner(struct stk1160 *dev, struct file *file)
+{
+	return dev->fh_owner == file;
+}
+
+static int stk1160_start_streaming(struct stk1160 *dev)
+{
+	int i, rc;
+
+	/* Check device presence */
+	if (!dev->udev)
+		return -ENODEV;
+
+	/*
+	 * For some reason it is mandatory to set alternate *first*
+	 * and only *then* initialize isoc urbs.
+	 * Someone please explain me why ;)
+	 */
+	rc = stk1160_set_alternate(dev);
+	if (rc < 0)
+		return rc;
+
+	/* If we haven't allocated any isoc urbs */
+	if (!dev->isoc_ctl.num_bufs) {
+		rc = stk1160_init_isoc(dev);
+		if (rc < 0)
+			return rc;
+	}
+
+	/* submit urbs and enables IRQ */
+	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+		rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_KERNEL);
+		if (rc) {
+			stk1160_err("cannot submit urb[%d] (%d)\n", i, rc);
+			stk1160_uninit_isoc(dev);
+			return rc;
+		}
+	}
+
+	/* Start saa711x */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
+
+	/* Start stk1160 */
+	stk1160_write_reg(dev, STK1160_DCTRL, 0xb3);
+	stk1160_write_reg(dev, STK1160_DCTRL+3, 0x00);
+
+	stk1160_dbg("streaming started\n");
+
+	return 0;
+}
+
+int stk1160_stop_streaming(struct stk1160 *dev, bool connected)
+{
+	struct stk1160_buffer *buf;
+	unsigned long flags = 0;
+
+	stk1160_uninit_isoc(dev);
+
+	/* If the device is physically plugged */
+	if (connected && dev->udev) {
+
+		/* set alternate 0 */
+		dev->alt = 0;
+		stk1160_info("setting alternate %d\n", dev->alt);
+		usb_set_interface(dev->udev, 0, 0);
+
+		/* Stop stk1160 */
+		stk1160_write_reg(dev, STK1160_DCTRL, 0x00);
+		stk1160_write_reg(dev, STK1160_DCTRL+3, 0x00);
+
+		/* Stop saa711x */
+		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	}
+
+	/* Release all active buffers */
+	spin_lock_irqsave(&dev->buf_lock, flags);
+	while (!list_empty(&dev->avail_bufs)) {
+		buf = list_first_entry(&dev->avail_bufs,
+			struct stk1160_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		stk1160_info("buffer [%p/%d] aborted\n",
+				buf, buf->vb.v4l2_buf.index);
+	}
+	spin_unlock_irqrestore(&dev->buf_lock, flags);
+
+	stk1160_dbg("streaming stopped\n");
+	return 0;
+}
+
+/* fops */
+static ssize_t stk1160_read(struct file *file,
+	char __user *data, size_t count, loff_t *ppos)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	mutex_lock(&dev->v4l_lock);
+	/*
+	 * Read operation is emulated by videobuf2.
+	 * When vb2 calls reqbufs it acquires ownership of queue.
+	 * When the transfer is done, vb2 calls reqbufs with zero count,
+	 * dropping ownership.
+	 */
+	rc = vb2_read(&dev->vb_vidq, data, count, ppos,
+			file->f_flags & O_NONBLOCK);
+
+	mutex_unlock(&dev->v4l_lock);
+	return rc;
+}
+
+static unsigned int
+stk1160_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	mutex_lock(&dev->v4l_lock);
+	rc = vb2_poll(&dev->vb_vidq, file, wait);
+	mutex_unlock(&dev->v4l_lock);
+
+	return rc;
+}
+
+static int stk1160_close(struct file *file)
+{
+	struct stk1160 *dev = video_drvdata(file);
+
+	mutex_lock(&dev->v4l_lock);
+	/*
+	 * If this is the owner handle we stop
+	 * streaming to free/dequeue all buffers.
+	 * Also, we drop ownership.
+	 */
+	if (stk1160_is_owner(dev, file)) {
+		vb2_queue_release(&dev->vb_vidq);
+		stk1160_drop_owner(dev);
+	}
+	mutex_unlock(&dev->v4l_lock);
+
+	return v4l2_fh_release(file);
+}
+
+static int stk1160_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	stk1160_dbg("vma=0x%08lx\n", (unsigned long)vma);
+
+	/* TODO: Lock or trylock? */
+	mutex_lock(&dev->v4l_lock);
+	rc = vb2_mmap(&dev->vb_vidq, vma);
+	mutex_unlock(&dev->v4l_lock);
+
+	stk1160_dbg("vma start=0x%08lx, size=%ld (%d)\n",
+		(unsigned long)vma->vm_start,
+		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start,
+		rc);
+	return rc;
+}
+
+static struct v4l2_file_operations stk1160_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = stk1160_close,
+	.read = stk1160_read,
+	.poll = stk1160_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = stk1160_mmap,
+};
+
+/*
+ * vb2 ioctls
+ */
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	if (!stk1160_acquire_owner(dev, file))
+		return -EBUSY;
+
+	rc = vb2_reqbufs(&dev->vb_vidq, p);
+
+	/*
+	 * If reqbufs has been called with count == 0
+	 * it means the owner is releasing the queue,
+	 * thus dropping ownership.
+	 */
+	if (p->count == 0)
+		stk1160_drop_owner(dev);
+
+	return rc;
+}
+
+static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	if (!stk1160_is_owner(dev, file))
+		return -EBUSY;
+
+	rc = vb2_querybuf(&dev->vb_vidq, p);
+
+	return rc;
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	if (!stk1160_is_owner(dev, file))
+		return -EBUSY;
+
+	rc = vb2_qbuf(&dev->vb_vidq, p);
+
+	return rc;
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	if (!stk1160_is_owner(dev, file))
+		return -EBUSY;
+
+	rc = vb2_dqbuf(&dev->vb_vidq, p, file->f_flags & O_NONBLOCK);
+
+	return rc;
+}
+
+static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	if (!stk1160_is_owner(dev, file))
+		return -EBUSY;
+
+	rc = vb2_streamon(&dev->vb_vidq, i);
+
+	return rc;
+}
+
+static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	int rc;
+
+	if (!stk1160_is_owner(dev, file))
+		return -EBUSY;
+
+	rc =  vb2_streamoff(&dev->vb_vidq, i);
+
+	return rc;
+}
+
+/*
+ * vidioc ioctls
+ */
+static int vidioc_querycap(struct file *file,
+		void *priv, struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "stk1160");
+	strcpy(cap->card, "stk1160");
+	cap->capabilities =
+		V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_STREAMING |
+		V4L2_CAP_READWRITE;
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
+		struct v4l2_fmtdesc *f)
+{
+	if (f->index != 0)
+		return -EINVAL;
+
+	strlcpy(f->description, format[f->index].name, sizeof(f->description));
+	f->pixelformat = format[f->index].fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct stk1160 *dev = video_drvdata(file);
+
+	f->fmt.pix.width = dev->width;
+	f->fmt.pix.height = dev->height;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.pixelformat = dev->fmt->fourcc;
+	f->fmt.pix.bytesperline = dev->width * 2;
+	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct stk1160 *dev = video_drvdata(file);
+
+	if (f->fmt.pix.pixelformat != format[0].fourcc) {
+		stk1160_err("fourcc format 0x%08x invalid\n",
+			f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	/*
+	 * User can't choose size at his own will,
+	 * so we just return him the current size chosen
+	 * at standard selection.
+	 * TODO: Implement frame scaling?
+	 */
+
+	f->fmt.pix.width = dev->width;
+	f->fmt.pix.height = dev->height;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.bytesperline = dev->width * 2;
+	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_vidq;
+	int rc;
+
+	if (!stk1160_acquire_owner(dev, file))
+		return -EBUSY;
+
+	rc = vidioc_try_fmt_vid_cap(file, priv, f);
+	if (rc < 0)
+		return rc;
+
+	if (vb2_is_streaming(q)) {
+		stk1160_err("device busy\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
+	return 0;
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_vidq;
+
+	if (!stk1160_acquire_owner(dev, file))
+		return -EBUSY;
+
+	if (vb2_is_streaming(q)) {
+		stk1160_err("device busy\n");
+		return -EBUSY;
+	}
+
+	/* Check device presence */
+	if (!dev->udev)
+		return -ENODEV;
+
+	/* This is taken from saa7115 video decoder */
+	if (dev->vdev.current_norm & V4L2_STD_525_60) {
+		dev->width = 720;
+		dev->height = 480;
+	} else if (dev->vdev.current_norm & V4L2_STD_625_50) {
+		dev->width = 720;
+		dev->height = 576;
+	} else {
+		stk1160_err("invalid standard\n");
+		return -EINVAL;
+	}
+
+	/* We need to set this now, before we call stk1160_set_std */
+	dev->vdev.current_norm = *norm;
+
+	stk1160_set_std(dev);
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
+			dev->vdev.current_norm);
+
+	return 0;
+}
+
+/* FIXME: Extend support for other inputs */
+static int vidioc_enum_input(struct file *file, void *priv,
+				struct v4l2_input *i)
+{
+	struct stk1160 *dev = video_drvdata(file);
+
+	if (i->index > 0)
+		return -EINVAL;
+
+	sprintf(i->name, "Composite%d", i->index);
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->std = dev->vdev.tvnorms;
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	struct stk1160 *dev = video_drvdata(file);
+	*i = dev->ctl_input;
+	return 0;
+}
+
+/* FIXME: Extend support for other inputs */
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	struct stk1160 *dev = video_drvdata(file);
+
+	if (!stk1160_acquire_owner(dev, file))
+		return -EBUSY;
+
+	if (i > 0)
+		return -EINVAL;
+
+	/*
+	 * Right now we only support one input
+	 * This is the next feature we'll implement.
+	 */
+#if 0
+	dev->ctl_input = i;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
+		dev->ctl_input, 0, 0);
+
+	switch (dev->ctl_input) {
+	case 1:
+		stk1160_write_reg(dev, 0x0000, 0x0098);
+		break;
+	case 2:
+		stk1160_write_reg(dev, 0x0000, 0x0090);
+		break;
+	case 3:
+		stk1160_write_reg(dev, 0x0000, 0x0088);
+		break;
+	case 4:
+		stk1160_write_reg(dev, 0x0000, 0x0080);
+		break;
+	}
+	stk1160_write_reg(dev, 0x0002, 0x0078 /* 0x0093 */);
+#endif
+
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *fh,
+				 struct v4l2_frmsizeenum *fsize)
+{
+	/* TODO: Is this needed? */
+	return -EINVAL;
+}
+
+static int vidioc_enum_frameintervals(struct file *file, void *fh,
+				  struct v4l2_frmivalenum *fival)
+{
+	/* TODO: Is this needed? */
+	return -EINVAL;
+}
+
+static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
+	.vidioc_querystd      = vidioc_querystd,
+	.vidioc_g_std         = NULL, /* don't worry v4l handles this */
+	.vidioc_s_std         = vidioc_s_std,
+	.vidioc_enum_input    = vidioc_enum_input,
+	.vidioc_g_input       = vidioc_g_input,
+	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+
+	/* vb2 takes care of these */
+	.vidioc_reqbufs       = vidioc_reqbufs,
+	.vidioc_querybuf      = vidioc_querybuf,
+	.vidioc_qbuf          = vidioc_qbuf,
+	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_streamon      = vidioc_streamon,
+	.vidioc_streamoff     = vidioc_streamoff,
+
+	/* TODO: Add debug ioctls: s/g_register, log_status, etc */
+};
+
+/********************************************************************/
+
+/*
+ * Videobuf2 operations
+ */
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct stk1160 *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
+
+	size = dev->width * dev->height * 2;
+
+	/*
+	 * Here we can change the number of buffers being requested.
+	 * So, we set a minimum and a maximum like this:
+	 */
+	*nbuffers = clamp_t(unsigned int, *nbuffers,
+			STK1160_MIN_VIDEO_BUFFERS, STK1160_MAX_VIDEO_BUFFERS);
+
+	/* This means a packed colorformat */
+	*nplanes = 1;
+
+	sizes[0] = size;
+
+	stk1160_info("%s: buffer count %d, each %ld bytes\n",
+			__func__, *nbuffers, size);
+
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	unsigned long flags = 0;
+	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct stk1160_buffer *buf =
+		container_of(vb, struct stk1160_buffer, vb);
+
+	spin_lock_irqsave(&dev->buf_lock, flags);
+	if (!dev->udev) {
+		/*
+		 * If the device is disconnected return the buffer to userspace
+		 * directly. The next QBUF call will fail with -ENODEV.
+		 */
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	} else {
+
+		buf->mem = vb2_plane_vaddr(vb, 0);
+		buf->length = vb2_plane_size(vb, 0);
+		buf->bytesused = 0;
+		buf->pos = 0;
+
+		/*
+		 * If buffer length is different from expected then we return
+		 * the buffer to userspace directly.
+		 */
+		if (buf->length != dev->width * dev->height * 2)
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		else
+			list_add_tail(&buf->list, &dev->avail_bufs);
+
+	}
+	spin_unlock_irqrestore(&dev->buf_lock, flags);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct stk1160 *dev = vb2_get_drv_priv(vq);
+	int rc;
+
+	rc = stk1160_start_streaming(dev);
+
+	return rc;
+}
+
+/* abort streaming and wait for last buffer */
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct stk1160 *dev = vb2_get_drv_priv(vq);
+	int rc;
+
+	rc = stk1160_stop_streaming(dev, true);
+
+	return rc;
+}
+
+static void stk1160_lock(struct vb2_queue *vq)
+{
+	struct stk1160 *dev = vb2_get_drv_priv(vq);
+	mutex_lock(&dev->v4l_lock);
+}
+
+static void stk1160_unlock(struct vb2_queue *vq)
+{
+	struct stk1160 *dev = vb2_get_drv_priv(vq);
+	mutex_unlock(&dev->v4l_lock);
+}
+
+static struct vb2_ops stk1160_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= stk1160_unlock,
+	.wait_finish		= stk1160_lock,
+};
+
+static struct video_device v4l_template = {
+	.name = "stk1160",
+	.tvnorms = V4L2_STD_525_60 | V4L2_STD_625_50,
+	.fops = &stk1160_fops,
+	.ioctl_ops = &stk1160_ioctl_ops,
+	.release = video_device_release_empty,
+};
+
+/********************************************************************/
+
+int stk1160_vb2_setup(struct stk1160 *dev)
+{
+	int rc;
+	struct vb2_queue *q;
+
+	q = &dev->vb_vidq;
+	memset(q, 0, sizeof(dev->vb_vidq));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct stk1160_buffer);
+	q->ops = &stk1160_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+
+	rc = vb2_queue_init(q);
+	if (rc < 0)
+		return rc;
+
+	/* initialize video dma queue */
+	INIT_LIST_HEAD(&dev->avail_bufs);
+
+	return 0;
+}
+
+int stk1160_video_register(struct stk1160 *dev)
+{
+	int rc;
+
+	/* Initialize video_device with a template structure */
+	dev->vdev = v4l_template;
+	dev->vdev.debug = vidioc_debug;
+
+	/*
+	 * Provide a mutex to v4l2 core.
+	 * It will be used to protect *only* v4l2 ioctls.
+	 */
+	dev->vdev.lock = &dev->v4l_lock;
+
+	/* This will be used to set video_device parent */
+	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+
+	/* NTSC is default. Could be any other, but has to match
+	 * with video_device current_norm field */
+	dev->vdev.current_norm = V4L2_STD_NTSC_M;
+	dev->width = 720;
+	dev->height = 480;
+
+	/* set default format */
+	dev->fmt = &format[0];
+	stk1160_set_std(dev);
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
+			dev->vdev.current_norm);
+
+	video_set_drvdata(&dev->vdev, dev);
+	rc = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
+	if (rc < 0) {
+		stk1160_err("video_register_device failed (%d)\n", rc);
+		return rc;
+	}
+
+	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
+		  video_device_node_name(&dev->vdev));
+
+	return 0;
+}
diff --git a/drivers/media/video/stk1160/stk1160-video.c b/drivers/media/video/stk1160/stk1160-video.c
new file mode 100644
index 0000000..3a74550
--- /dev/null
+++ b/drivers/media/video/stk1160/stk1160-video.c
@@ -0,0 +1,507 @@
+/*
+ * STK1160 driver
+ *
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ * Based on Easycap driver by R.M. Thomas
+ *	Copyright (C) 2010 R.M. Thomas
+ *	<rmthomas--a.t--sciolus.org>
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
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/slab.h>
+#include <linux/ratelimit.h>
+
+#include "stk1160.h"
+
+static unsigned int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "enable debug messages");
+
+static inline void print_err_status(struct stk1160 *dev,
+				     int packet, int status)
+{
+	char *errmsg = "Unknown";
+
+	switch (status) {
+	case -ENOENT:
+		errmsg = "unlinked synchronuously";
+		break;
+	case -ECONNRESET:
+		errmsg = "unlinked asynchronuously";
+		break;
+	case -ENOSR:
+		errmsg = "Buffer error (overrun)";
+		break;
+	case -EPIPE:
+		errmsg = "Stalled (device not responding)";
+		break;
+	case -EOVERFLOW:
+		errmsg = "Babble (bad cable?)";
+		break;
+	case -EPROTO:
+		errmsg = "Bit-stuff error (bad cable?)";
+		break;
+	case -EILSEQ:
+		errmsg = "CRC/Timeout (could be anything)";
+		break;
+	case -ETIME:
+		errmsg = "Device does not respond";
+		break;
+	}
+
+	if (packet < 0)
+		printk_ratelimited(KERN_WARNING "URB status %d [%s].\n",
+				status, errmsg);
+	else
+		printk_ratelimited(KERN_INFO "URB packet %d, status %d [%s].\n",
+			       packet, status, errmsg);
+}
+
+static inline
+struct stk1160_buffer *stk1160_next_buffer(struct stk1160 *dev)
+{
+	struct stk1160_buffer *buf = NULL;
+	unsigned long flags = 0;
+
+	/* Current buffer must be NULL when this functions gets called */
+	BUG_ON(dev->isoc_ctl.buf);
+
+	spin_lock_irqsave(&dev->buf_lock, flags);
+	if (!list_empty(&dev->avail_bufs)) {
+		buf = list_first_entry(&dev->avail_bufs,
+				struct stk1160_buffer, list);
+		list_del(&buf->list);
+	}
+	spin_unlock_irqrestore(&dev->buf_lock, flags);
+
+	return buf;
+}
+
+static inline
+void stk1160_buffer_done(struct stk1160 *dev)
+{
+	struct stk1160_buffer *buf = dev->isoc_ctl.buf;
+
+	dev->field_count++;
+
+	buf->vb.v4l2_buf.sequence = dev->field_count >> 1;
+	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	buf->vb.v4l2_buf.bytesused = buf->bytesused;
+	do_gettimeofday(&buf->vb.v4l2_buf.timestamp);
+
+	vb2_set_plane_payload(&buf->vb, 0, buf->bytesused);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+
+	dev->isoc_ctl.buf = NULL;
+}
+
+static inline
+void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
+{
+	int linesdone, lineoff, lencopy;
+	int bytesperline = dev->width * 2;
+	struct stk1160_buffer *buf = dev->isoc_ctl.buf;
+	u8 *dst = buf->mem;
+	int remain;
+
+	/*
+	 * TODO: These stk1160_dbg are very spammy!
+	 * We should 1) check why we are getting them
+	 * and 2) add ratelimit.
+	 *
+	 * UPDATE: One of the reasons (the only one?) for getting these
+	 * is incorrect standard (mismatch between expected and configured).
+	 * So perhaps, we could add a counter for errors. When the counter
+	 * reaches some value, we simply stop streaming.
+	 */
+
+	/* Sanity check */
+	if (buf->mem == NULL || buf->length == 0) {
+		stk1160_dbg("copy skipped: null buffer\n");
+		return;
+	}
+
+	len -= 4;
+	src += 4;
+
+	remain = len;
+
+	linesdone = buf->pos / bytesperline;
+	lineoff = buf->pos % bytesperline; /* offset in current line */
+
+	if (!buf->odd)
+		dst += bytesperline;
+
+	/* Multiply linesdone by two, to take account of the other field */
+	dst += linesdone * bytesperline * 2 + lineoff;
+
+	/* Copy the remaining of current line */
+	if (remain < (bytesperline - lineoff))
+		lencopy = remain;
+	else
+		lencopy = bytesperline - lineoff;
+
+	/*
+	 * Check if we have enough space left in the buffer.
+	 * In that case, we force loop exit after copy.
+	 */
+	if (lencopy > buf->bytesused - buf->length) {
+		lencopy = buf->bytesused - buf->length;
+		remain = lencopy;
+	}
+
+	/* Let the bug hunt begin! sanity checks! */
+	if (lencopy < 0) {
+		stk1160_dbg("copy skipped: negative lencopy\n");
+		return;
+	}
+
+	if (buf->pos > buf->length) {
+		stk1160_dbg("copy skipped: pos > length\n");
+		return;
+	}
+
+	if (buf->pos + lencopy > buf->length) {
+		stk1160_dbg("copy skipped: pos + lencopy > length\n");
+		return;
+	}
+
+	if ((unsigned long)dst + lencopy >
+		(unsigned long)buf->mem + buf->length) {
+
+		stk1160_dbg("copy skipped: dst + lencopy > mem + length\n");
+		return;
+	}
+
+	if (lencopy > len) {
+		stk1160_dbg("copy skipped: lencopy > len)\n");
+		return;
+	}
+
+	if ((unsigned long)dst > (unsigned long)buf->mem + buf->length) {
+		stk1160_dbg("copy skipped: dst > mem + length\n");
+		return;
+	}
+
+	/* Crash was found here */
+	memcpy(dst, src, lencopy);
+
+	buf->bytesused += lencopy;
+	buf->pos += lencopy;
+	remain -= lencopy;
+
+	/* Copy current field line by line, interlacing with the other field */
+	while (remain > 0) {
+
+		dst += lencopy + bytesperline;
+		src += lencopy;
+
+		/* Copy one line at a time */
+		if (remain < bytesperline)
+			lencopy = remain;
+		else
+			lencopy = bytesperline;
+
+		/*
+		 * Check if we have enough space left in the buffer.
+		 * In that case, we force loop exit after copy.
+		 */
+		if (lencopy > buf->bytesused - buf->length) {
+			lencopy = buf->bytesused - buf->length;
+			remain = lencopy;
+		}
+
+		/* Let the bug hunt begin! sanity checks */
+		if (lencopy <= 0) {
+			stk1160_dbg("copy skipped: negative lencopy\n");
+			return;
+		}
+
+		if (buf->pos > buf->length) {
+			stk1160_dbg("copy skipped: pos > length\n");
+			return;
+		}
+
+		if (buf->pos + lencopy > buf->length) {
+			stk1160_dbg("copy skipped: pos + lencopy > length\n");
+			return;
+		}
+
+		if ((unsigned long)dst + lencopy >
+			(unsigned long)buf->mem + buf->length) {
+			stk1160_dbg("copy skipped: dst + lencopy > mem + length\n");
+			return;
+		}
+
+		if (lencopy > len) {
+			stk1160_dbg("copy skipped: lencopy > len)\n");
+			return;
+		}
+
+		memcpy(dst, src, lencopy);
+		remain -= lencopy;
+
+		buf->bytesused += lencopy;
+		buf->pos += lencopy;
+	}
+
+	if (remain != 0)
+		stk1160_dbg("remain should be null, instead of %d\n", remain);
+}
+
+/*
+ * Controls the isoc copy of each urb packet
+ */
+static void stk1160_process_isoc(struct stk1160 *dev, struct urb *urb)
+{
+	int i, len, status;
+	u8 *p;
+
+	if (!dev) {
+		stk1160_warn("%s called with null device\n", __func__);
+		return;
+	}
+
+	if (urb->status < 0) {
+		/* Print status and drop current packet (or field?) */
+		print_err_status(dev, -1, urb->status);
+		return;
+	}
+
+	for (i = 0; i < urb->number_of_packets; i++) {
+		status = urb->iso_frame_desc[i].status;
+		if (status < 0) {
+			print_err_status(dev, i, status);
+			continue;
+		}
+
+		/* Get packet actual length and pointer to data */
+		p = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		len = urb->iso_frame_desc[i].actual_length;
+
+		/* Empty packet */
+		if (len <= 4)
+			continue;
+
+		/*
+		 * An 8-byte packet sequence means end of field.
+		 * So if we don't have any packet, we start receiving one now
+		 * and if we do have a packet, then we are done with it.
+		 *
+		 * These end of field packets are always 0xc0 or 0x80,
+		 * but not always 8-byte long so we don't check packet length.
+		 */
+		if (p[0] == 0xc0) {
+
+			/*
+			 * If first byte is 0xc0 then we received
+			 * second field, and frame has ended.
+			 */
+			if (dev->isoc_ctl.buf != NULL)
+				stk1160_buffer_done(dev);
+
+			dev->isoc_ctl.buf = stk1160_next_buffer(dev);
+			if (dev->isoc_ctl.buf == NULL)
+				return;
+		}
+
+		/*
+		 * If we don't have a buffer here, then it means we
+		 * haven't found the start mark sequence.
+		 */
+		if (dev->isoc_ctl.buf == NULL)
+			continue;
+
+		if (p[0] == 0xc0 || p[0] == 0x80) {
+
+			/* We set next packet parity and
+			 * continue to get next one
+			 */
+			dev->isoc_ctl.buf->odd = *p & 0x40;
+			dev->isoc_ctl.buf->pos = 0;
+			continue;
+		}
+
+		stk1160_copy_video(dev, p, len);
+	}
+}
+
+
+/*
+ * IRQ callback, called by URB callback
+ */
+static void stk1160_isoc_irq(struct urb *urb)
+{
+	int i, rc;
+	struct stk1160 *dev = urb->context;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ECONNRESET:   /* kill */
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* TODO: check uvc driver: he frees the queue here */
+		return;
+	default:
+		stk1160_err("urb error! status %d\n", urb->status);
+		return;
+	}
+
+	stk1160_process_isoc(dev, urb);
+
+	/* Reset urb buffers */
+	for (i = 0; i < urb->number_of_packets; i++) {
+		urb->iso_frame_desc[i].status = 0;
+		urb->iso_frame_desc[i].actual_length = 0;
+	}
+
+	rc = usb_submit_urb(urb, GFP_ATOMIC);
+	if (rc)
+		stk1160_err("urb re-submit failed (%d)\n", rc);
+}
+
+/*
+ * Deallocate URBs
+ * This function can't be called in atomic context
+ */
+void stk1160_uninit_isoc(struct stk1160 *dev)
+{
+	struct urb *urb;
+	int i;
+
+	stk1160_dbg("killing urbs...\n");
+
+	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+
+		urb = dev->isoc_ctl.urb[i];
+		if (urb) {
+			/* To kill urbs we can't be in atomic context */
+			usb_kill_urb(urb);
+
+			if (dev->isoc_ctl.transfer_buffer[i]) {
+#ifndef CONFIG_DMA_NONCOHERENT
+				usb_free_coherent(dev->udev,
+					urb->transfer_buffer_length,
+					dev->isoc_ctl.transfer_buffer[i],
+					urb->transfer_dma);
+#else
+				kfree(dev->isoc_ctl.transfer_buffer[i]);
+#endif
+			}
+			usb_free_urb(urb);
+			dev->isoc_ctl.urb[i] = NULL;
+		}
+		dev->isoc_ctl.transfer_buffer[i] = NULL;
+	}
+
+	kfree(dev->isoc_ctl.urb);
+	kfree(dev->isoc_ctl.transfer_buffer);
+
+	dev->isoc_ctl.urb = NULL;
+	dev->isoc_ctl.transfer_buffer = NULL;
+	dev->isoc_ctl.num_bufs = 0;
+
+	stk1160_dbg("all urbs killed\n");
+}
+
+/*
+ * Allocate URBs
+ */
+int stk1160_init_isoc(struct stk1160 *dev)
+{
+	struct urb *urb;
+	int i, j, k, sb_size, max_packets, num_bufs;
+
+	num_bufs = STK1160_NUM_BUFS;
+	max_packets = STK1160_NUM_PACKETS;
+	sb_size = max_packets * dev->max_pkt_size;
+
+	dev->isoc_ctl.buf = NULL;
+	dev->isoc_ctl.max_pkt_size = dev->max_pkt_size;
+	dev->isoc_ctl.urb = kzalloc(sizeof(void *)*num_bufs, GFP_KERNEL);
+	if (!dev->isoc_ctl.urb) {
+		stk1160_err("out of memory for urb array\n");
+		return -ENOMEM;
+	}
+
+	dev->isoc_ctl.transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
+					      GFP_KERNEL);
+	if (!dev->isoc_ctl.transfer_buffer) {
+		stk1160_err("out of memory for usb transfers\n");
+		kfree(dev->isoc_ctl.urb);
+		return -ENOMEM;
+	}
+
+	/* allocate urbs and transfer buffers */
+	for (i = 0; i < num_bufs; i++) {
+
+		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
+		if (!urb) {
+			stk1160_err("cannot alloc urb[%d]\n", i);
+			stk1160_uninit_isoc(dev);
+			return -ENOMEM;
+		}
+		dev->isoc_ctl.urb[i] = urb;
+
+#ifndef CONFIG_DMA_NONCOHERENT
+		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->udev,
+			sb_size, GFP_KERNEL, &urb->transfer_dma);
+#else
+		dev->isoc_ctl.transfer_buffer[i] = kmalloc(sb_size, GFP_KERNEL);
+#endif
+		if (!dev->isoc_ctl.transfer_buffer[i]) {
+			stk1160_err("cannot alloc %d bytes for tx buffer\n",
+				sb_size);
+			stk1160_uninit_isoc(dev);
+			return -ENOMEM;
+		}
+		memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);
+
+		/*
+		 * FIXME: Where can I get the endpoint?
+		 */
+		urb->dev = dev->udev;
+		urb->pipe = usb_rcvisocpipe(dev->udev, STK1160_EP_VIDEO);
+		urb->transfer_buffer = dev->isoc_ctl.transfer_buffer[i];
+		urb->transfer_buffer_length = sb_size;
+		urb->complete = stk1160_isoc_irq;
+		urb->context = dev;
+		urb->interval = 1;
+		urb->start_frame = 0;
+		urb->number_of_packets = max_packets;
+#ifndef CONFIG_DMA_NONCOHERENT
+		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+#else
+		urb->transfer_flags = URB_ISO_ASAP;
+#endif
+
+		k = 0;
+		for (j = 0; j < max_packets; j++) {
+			urb->iso_frame_desc[j].offset = k;
+			urb->iso_frame_desc[j].length =
+					dev->isoc_ctl.max_pkt_size;
+			k += dev->isoc_ctl.max_pkt_size;
+		}
+	}
+
+	/* At last we can say we have some buffers */
+	dev->isoc_ctl.num_bufs = num_bufs;
+
+	return 0;
+}
+
diff --git a/drivers/media/video/stk1160/stk1160.h b/drivers/media/video/stk1160/stk1160.h
new file mode 100644
index 0000000..67148de
--- /dev/null
+++ b/drivers/media/video/stk1160/stk1160.h
@@ -0,0 +1,185 @@
+/*
+ * STK1160 driver
+ *
+ * Copyright (C) 2012 Ezequiel Garcia
+ * <elezegarcia--a.t--gmail.com>
+ *
+ * Based on Easycap driver by R.M. Thomas
+ *	Copyright (C) 2010 R.M. Thomas
+ *	<rmthomas--a.t--sciolus.org>
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
+ */
+
+#include <linux/i2c.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+
+#define STK1160_VERSION		"0.9.2"
+#define STK1160_VERSION_NUM	0x000902
+
+/* TODO: Decide on number of packets for each buffer */
+#define STK1160_NUM_PACKETS 64
+
+/* Number of buffers for isoc transfers */
+#define STK1160_NUM_BUFS 16 /* TODO */
+
+/* TODO: This endpoint address should be retrieved */
+#define STK1160_EP_VIDEO 0x82
+#define STK1160_EP_AUDIO 0x81
+
+/* Max and min video buffers */
+#define STK1160_MIN_VIDEO_BUFFERS 8
+#define STK1160_MAX_VIDEO_BUFFERS 32
+
+#define STK1160_MIN_PKT_SIZE 3072
+
+/* TODO: Print helpers
+ * I could use dev_xxx, pr_xxx, v4l2_xxx or printk.
+ * However, there isn't a solid consensus on which
+ * new drivers should use.
+ *
+ */
+#define DEBUG
+#ifdef DEBUG
+#define stk1160_dbg(fmt, args...) \
+	printk(KERN_DEBUG "stk1160: " fmt,  ## args)
+#else
+#define stk1160_dbg(fmt, args...)
+#endif
+
+#define stk1160_info(fmt, args...) \
+	pr_info("stk1160: " fmt, ## args)
+
+#define stk1160_warn(fmt, args...) \
+	pr_warn("stk1160: " fmt, ## args)
+
+#define stk1160_err(fmt, args...) \
+	pr_err("stk1160: " fmt, ## args)
+
+/* Buffer for one video frame */
+struct stk1160_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer vb;
+	struct list_head list;
+
+	void *mem;
+	unsigned int length;		/* buffer length */
+	unsigned int bytesused;		/* bytes written */
+	int odd;			/* current oddity */
+
+	/*
+	 * Since we interlace two fields per frame,
+	 * this is different from bytesused.
+	 */
+	unsigned int pos;		/* current pos inside buffer */
+};
+
+struct stk1160_isoc_ctl {
+	/* max packet size of isoc transaction */
+	int max_pkt_size;
+
+	/* number of allocated urbs */
+	int num_bufs;
+
+	/* urb for isoc transfers */
+	struct urb **urb;
+
+	/* transfer buffers for isoc transfer */
+	char **transfer_buffer;
+
+	/* current buffer */
+	struct stk1160_buffer *buf;
+};
+
+struct stk1160_fmt {
+	char  *name;
+	u32   fourcc;          /* v4l2 format id */
+	int   depth;
+};
+
+struct stk1160 {
+	struct v4l2_device v4l2_dev;
+	struct video_device vdev;
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	struct device *dev;
+	struct usb_device *udev;
+
+	/* saa7115 subdev */
+	struct v4l2_subdev *sd_saa7115;
+
+	/* isoc control struct */
+	struct list_head avail_bufs;
+
+	/* video capture */
+	struct vb2_queue vb_vidq;
+
+	/* max packet size of isoc transaction */
+	int max_pkt_size;
+	/* array of wMaxPacketSize */
+	unsigned int *alt_max_pkt_size;
+	/* alternate */
+	int alt;
+	/* Number of alternative settings */
+	int num_alt;
+
+	struct stk1160_isoc_ctl isoc_ctl;
+	char urb_buf[255];	 /* urb control msg buffer */
+
+	/* frame properties */
+	int width;		  /* current frame width */
+	int height;		  /* current frame height */
+	unsigned int ctl_input;	  /* selected input */
+	struct stk1160_fmt *fmt;  /* selected format */
+
+	unsigned int field_count; /* not sure ??? */
+	enum v4l2_field field;    /* also not sure :/ */
+
+	/* i2c i/o */
+	struct i2c_adapter i2c_adap;
+	struct i2c_client i2c_client;
+
+	struct mutex v4l_lock;
+	spinlock_t buf_lock;
+
+	struct file *fh_owner;	/* filehandle ownership */
+};
+
+struct regval {
+	u16 reg;
+	u16 val;
+};
+
+/* Provided by stk1160-v4l.c */
+int stk1160_vb2_setup(struct stk1160 *cap);
+int stk1160_video_register(struct stk1160 *cap);
+void stk1160_video_unregister(struct stk1160 *cap);
+int stk1160_stop_streaming(struct stk1160 *cap, bool connected);
+
+/* Provided by stk1160-video.c */
+void stk1160_uninit_isoc(struct stk1160 *cap);
+int stk1160_init_isoc(struct stk1160 *cap);
+
+/* Provided by stk1160-i2c.c */
+int stk1160_i2c_register(struct stk1160 *cap);
+int stk1160_i2c_unregister(struct stk1160 *cap);
+
+/* Provided by stk1160-core.c */
+void stk1160_reg_reset(struct stk1160 *dev);
+int stk1160_read_reg(struct stk1160 *cap, u16 reg, u8 *value);
+int stk1160_write_reg(struct stk1160 *cap, u16 reg, u16 value);
+int stk1160_write_regs_req(struct stk1160 *dev, u8 req, u16 reg,
+		char *buf, int len);
+int stk1160_read_reg_req_len(struct stk1160 *dev, u8 req, u16 reg,
+		char *buf, int len);
-- 
1.7.3.4

