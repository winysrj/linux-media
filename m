Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43090 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaBMMcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 07:32:11 -0500
Received: by mail-pd0-f179.google.com with SMTP id fp1so10111331pdb.10
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 04:32:10 -0800 (PST)
Received: from gmail.com (static-50-53-32-160.bvtn.or.frontiernet.net. [50.53.32.160])
        by mx.google.com with ESMTPSA id pe3sm6117417pbc.23.2014.02.13.04.32.07
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 13 Feb 2014 04:32:09 -0800 (PST)
Date: Thu, 13 Feb 2014 04:32:11 -0800
From: Todd Brandt <todd.eric.brandt@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] gspca_amscope: AmScope MT1000 camera driver
Message-ID: <20140213123210.GA31631@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, I'm working on adding a new GSPCA driver for the AmScope MT1000
series microscope camera and I'm having a bit of trouble. The patch below
is my work-in-progress. I can succesfully get a video stream from the device
at 1280x1024 (the default) and can set the exposure value, but I seem to be
having trouble with data corruption while retrieving the image data. I'm sure
I'll figure it out eventually but any suggestions would be appreciated.

I retrieve the frames as the camera sends them out through a bulk DMA
transfer into the URB's transfer buffer. The data should come out as
(1280 * 1024) each time but it's always a few kilobytes shy of that 
number. The missing data appears to be at random points in the image
and occurs at roughly 32kb intervals. The resulting image looks like it's
been cut into horizontal ribbons with about 1/10 of the image missing at
the bottom.

Here's what the image should look like (from windows):
http://imgur.com/fFXyB9c

Here's how it currently looks with my WIP driver:
http://imgur.com/sLDMKbx

I'm assuming this is because I'm losing some of the packets at the USB
layer, but I don't really know where to look to fix it. I've tried tweaking
the URB buffer to all different sizes and I find that anything less than
32Kb makes the ribbon effect worse, so I'm keeping it large. Has anyone seen
this behavior before, and if so, is it a problem with my gspca config, the
device, or something further down in the USB layer?

This is the lsusb -vv output:

Bus 001 Device 004: ID 0547:92a0 Anchor Chips, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0547 Anchor Chips, Inc.
  idProduct          0x92a0 
  bcdDevice            0.00
  iManufacturer           1 DO3THINK
  iProduct                2 10M USBCam
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0


Signed-off-by: Todd Brandt <todd.eric.brandt@gmail.com>
---
 drivers/media/usb/gspca/Kconfig   |   9 ++
 drivers/media/usb/gspca/Makefile  |   2 +
 drivers/media/usb/gspca/amscope.c | 317 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 328 insertions(+)

diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index 4f0c6d5..320d225 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -21,6 +21,15 @@ source "drivers/media/usb/gspca/m5602/Kconfig"
 source "drivers/media/usb/gspca/stv06xx/Kconfig"
 source "drivers/media/usb/gspca/gl860/Kconfig"
 
+config USB_GSPCA_AMSCOPE
+	tristate "AmScope USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for AmScope series cameras
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_amscope.
+
 config USB_GSPCA_BENQ
 	tristate "Benq USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff --git a/drivers/media/usb/gspca/Makefile b/drivers/media/usb/gspca/Makefile
index 5855131..7fd7ddb 100644
--- a/drivers/media/usb/gspca/Makefile
+++ b/drivers/media/usb/gspca/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_USB_GSPCA)          += gspca_main.o
+obj-$(CONFIG_USB_GSPCA_AMSCOPE)  += gspca_amscope.o
 obj-$(CONFIG_USB_GSPCA_BENQ)     += gspca_benq.o
 obj-$(CONFIG_USB_GSPCA_CONEX)    += gspca_conex.o
 obj-$(CONFIG_USB_GSPCA_CPIA1)    += gspca_cpia1.o
@@ -45,6 +46,7 @@ obj-$(CONFIG_USB_GSPCA_XIRLINK_CIT) += gspca_xirlink_cit.o
 obj-$(CONFIG_USB_GSPCA_ZC3XX)    += gspca_zc3xx.o
 
 gspca_main-objs     := gspca.o autogain_functions.o
+gspca_amscope-objs  := amscope.o
 gspca_benq-objs     := benq.o
 gspca_conex-objs    := conex.o
 gspca_cpia1-objs    := cpia1.o
diff --git a/drivers/media/usb/gspca/amscope.c b/drivers/media/usb/gspca/amscope.c
new file mode 100644
index 0000000..04df71e
--- /dev/null
+++ b/drivers/media/usb/gspca/amscope.c
@@ -0,0 +1,317 @@
+/*
+ * AmScope series microscope camera driver
+ *
+ * Todd Brandt <todd.eric.brandt@gmail.com>
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
+ *
+ */
+#define MODULE_NAME "amscope"
+#define DEBUG 1
+
+#include "gspca.h"
+
+MODULE_AUTHOR("Todd Brandt <todd.eric.brandt@gmail.com>");
+MODULE_DESCRIPTION("AmScope USB Camera Driver");
+MODULE_LICENSE("GPL");
+
+#define BULK_SIZE (20 * 16384)
+
+/* specific webcam descriptor */
+struct sd {
+	struct gspca_dev gspca_dev;	/* !! must be the first item */
+	unsigned int count;
+};
+
+static const struct v4l2_pix_format vga_mode[] = {
+/*
+	{640, 480,
+		V4L2_PIX_FMT_SGRBG8,
+		V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480,
+		.colorspace = V4L2_COLORSPACE_SRGB},
+*/
+	{1280, 1024,
+		V4L2_PIX_FMT_SGRBG8,
+		V4L2_FIELD_NONE,
+		.bytesperline = 1280,
+		.sizeimage = 1280 * 1024,
+		.colorspace = V4L2_COLORSPACE_SRGB},
+/*
+	{3856, 2764,
+		V4L2_PIX_FMT_GREY,
+		V4L2_FIELD_NONE,
+		.bytesperline = 3856,
+		.sizeimage = 3856 * 2764,
+		.colorspace = V4L2_COLORSPACE_SRGB},
+*/
+};
+
+static int usb_dev_write(struct gspca_dev *gspca_dev,
+		u8 request, u16 value, u16 index, u16 length)
+{
+	int rc;
+
+	rc = usb_control_msg(gspca_dev->dev,
+		usb_sndctrlpipe(gspca_dev->dev, 0), request,
+		USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		value, index, gspca_dev->usb_buf, length, 500);
+
+	return rc;
+}
+
+static int usb_dev_read(struct gspca_dev *gspca_dev,
+		u8 request, u16 value, u16 index, u16 length)
+{
+	int rc;
+
+	memset(gspca_dev->usb_buf, 0, length);
+	rc = usb_control_msg(gspca_dev->dev,
+		usb_rcvctrlpipe(gspca_dev->dev, 0), request,
+		USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		value, index, gspca_dev->usb_buf, length, 500);
+
+	return rc;
+}
+
+/* called at probe time (after sd_probe) */
+static int sd_config(struct gspca_dev *gspca_dev,
+		     const struct usb_device_id *id)
+{
+	struct cam *cam = &gspca_dev->cam;
+
+	pr_devel("sd_config, Vendor=%04x, Product=%04x",
+		id->idVendor, id->idProduct);
+
+	cam->cam_mode = vga_mode;
+	cam->nmodes = ARRAY_SIZE(vga_mode);
+	cam->no_urb_create = 0;
+	cam->bulk_nurbs = 1;
+	cam->bulk_size = BULK_SIZE;
+	cam->bulk = 1;
+
+	return 0;
+}
+
+/* called at probe (after sd_config), and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	return 0;
+}
+
+static void setexposure(struct gspca_dev *gspca_dev, s32 val)
+{
+	if (val < 0)
+		val = 0;
+	else if (val > 0xf0)
+		val = 0xf0;
+
+	/* exposure (0x1800 - 0x18f0) */
+	usb_dev_write(gspca_dev, 0x9, 0x1800+val, 1, 0);
+}
+
+/* -- start the camera -- */
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+#if 0
+	__u8 *b = gspca_dev->usb_buf;
+	__u8 data[160], data2[136];
+	u16 idx;
+#endif
+	pr_devel("sd_start");
+	sd->count = 0;
+
+	usb_dev_write(gspca_dev, 0x2, 0x1, 0xf, 0);
+#if 0
+	for (idx = 0; idx < 0xa0; idx += 2) {
+		usb_dev_read(gspca_dev, 0x11, 0, idx, 3);
+		data[idx] = b[0];
+		data[idx + 1] = b[1];
+	}
+	usb_dev_read(gspca_dev, 0xa, 0x17a0, 0x16a0, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x16a0, 0x16a3, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x16a0, 0x16a4, 1);
+#endif
+	usb_dev_write(gspca_dev, 0x9, 0, 0, 0);
+	usb_dev_read(gspca_dev, 0xa, 0x16a0, 0x16a4, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1580, 0x14e4, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1bbd, 0x14e8, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1630, 0x14e6, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1ead, 0x14ea, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1563, 0x27e0, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a0, 0x13a0, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17b0, 0x13a4, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x12a0, 0x14ec, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1460, 0x14ee, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x13f1, 0x14e0, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1cf4, 0x14e2, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a0, 0x16a4, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a1, 0x16a4, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a0, 0x16a0, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a2, 0x14a4, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x1788, 0x14a6, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a5, 0x14a0, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a1, 0x14a2, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17aa, 0x14a8, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a2, 0x14aa, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x8778, 0x27ba, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x17a0, 0x16a4, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x16a0, 0x16a0, 1);
+	usb_dev_read(gspca_dev, 0xa, 0x18c0, 0x27b2, 1);
+#if 0
+	usb_dev_read(gspca_dev, 0x11, 0, 0x24c0, 3);
+	usb_dev_read(gspca_dev, 0x11, 0, 0x24cc, 3);
+	usb_dev_read(gspca_dev, 0x11, 0, 0x24ce, 3);
+	for (idx = 0; idx < 0x88; idx += 2) {
+		usb_dev_read(gspca_dev, 0x11, 0, idx + 0x2820, 3);
+		data2[idx] = b[0];
+		data2[idx + 1] = b[1];
+	}
+#endif
+	usb_dev_write(gspca_dev, 0x3, 0x1, 0xe, 0);
+	return 0;
+}
+
+static void sd_stopN(struct gspca_dev *gspca_dev)
+{
+	pr_devel("sd_stop");
+	usb_dev_write(gspca_dev, 0x2, 0x0, 0xf, 0);
+	usb_dev_write(gspca_dev, 0x3, 0x0, 0xe, 0);
+}
+
+static void sd_pkt_scan(struct gspca_dev *gspca_dev,
+			u8 *data, /* bulk URB data */
+			int len)  /* bulk URB data length */
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+#if 0
+	size_t sizeimage = vga_mode[gspca_dev->curr_mode].sizeimage;
+	int packet_type;
+
+	pr_devel("packet: %d", len);
+	if (sd->count <= 0) {
+		packet_type = FIRST_PACKET;
+		sd->count += len;
+	} else if (sd->count + len >= sizeimage) {
+		len = sizeimage - sd->count;
+		packet_type = LAST_PACKET;
+		sd->count = 0;
+	} else {
+		packet_type = INTER_PACKET;
+		sd->count += len;
+	}
+#else
+	int packet_type = INTER_PACKET;
+
+	if (len == BULK_SIZE) {
+		if (sd->count <= 0)
+			packet_type = FIRST_PACKET;
+		sd->count++;
+	} else {
+		pr_devel("frame: %d, %d", sd->count, len);
+		sd->count = 0;
+		packet_type = LAST_PACKET;
+	}
+#endif
+	gspca_frame_add(gspca_dev, packet_type, data, len);
+}
+
+static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct gspca_dev *gspca_dev =
+		container_of(ctrl->handler, struct gspca_dev, ctrl_handler);
+
+	pr_devel("sd_s_ctrl");
+	gspca_dev->usb_err = 0;
+
+	if (!gspca_dev->streaming)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_EXPOSURE:
+		pr_devel("set exposure %x", ctrl->val);
+		setexposure(gspca_dev, ctrl->val);
+		break;
+	}
+
+	return gspca_dev->usb_err;
+}
+
+static const struct v4l2_ctrl_ops sd_ctrl_ops = {
+	.s_ctrl = sd_s_ctrl,
+};
+
+/* called at probe (after sd_init) */
+static int sd_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct v4l2_ctrl_handler *hdl = &gspca_dev->ctrl_handler;
+	pr_devel("sd_init_controls");
+
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 2);
+
+	v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 0xf0, 1, 0x5a);
+
+	if (hdl->error) {
+		pr_err("Could not initialize controls\n");
+		return hdl->error;
+	}
+	return 0;
+}
+
+/* sub-driver description */
+static const struct sd_desc sd_desc = {
+	.name = MODULE_NAME,
+	.config = sd_config,
+	.init = sd_init,
+	.init_controls = sd_init_controls,
+	.start = sd_start,
+	.stopN = sd_stopN,
+	.pkt_scan = sd_pkt_scan,
+};
+
+/* supported device list */
+static const struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x0547, 0x92a0)}, /* AmScope MT1000 */
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, device_table);
+
+/* -- device connect -- */
+static int sd_probe(struct usb_interface *intf,
+		    const struct usb_device_id *id)
+{
+	pr_devel("sd_probe, alt=%d, vendor=%04x, product=%04x",
+		intf->num_altsetting, id->idVendor, id->idProduct);
+	return gspca_dev_probe(intf, id, &sd_desc,
+		sizeof(struct sd), THIS_MODULE);
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
+module_usb_driver(sd_driver);
