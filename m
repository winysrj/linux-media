Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:56092 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab3HGVa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 17:30:58 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Syntek webcams and out-of-tree driver
Date: Wed, 7 Aug 2013 23:30:10 +0200
Cc: linux-media@vger.kernel.org,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	syntekdriver-devel@lists.sourceforge.net
References: <201308052319.26720.linux@rainbow-software.org> <5200935E.8080003@redhat.com>
In-Reply-To: <5200935E.8080003@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201308072330.10697.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 06 August 2013 08:10:38 Hans de Goede wrote:
> Hi,
>
> On 08/05/2013 11:19 PM, Ondrej Zary wrote:
> > Hello,
> > the in-kernel stkwebcam driver (by Jaime Velasco Juan and Nicolas VIVIEN)
> > supports only two webcam types (USB IDs 0x174f:0xa311 and 0x05e1:0x0501).
> > There are many other Syntek webcam types that are not supported by this
> > driver (such as 0x174f:0x6a31 in Asus F5RL laptop).
> >
> > There is an out-of-tree GPL driver called stk11xx (by Martin Roos and
> > also Nicolas VIVIEN) at http://sourceforge.net/projects/syntekdriver/
> > which supports more webcams. It can be even compiled for the latest
> > kernels using the patch below and seems to work somehow (slow and buggy
> > but better than nothing) with the Asus F5RL.
>
> I took a quick look and there are a number of issues with this driver:
>
> 1) It conflicts usb-id wise with the new stk1160 driver (which supports
> usb-id 05e1:0408) so support for that usb-id, and any code only used for
> that id will need to be removed
>
> 2) "seems to work somehow (slow and buggy)" is not really the quality
> we aim for with in kernel drivers. We definitely will want to remove
> any usb-ids, and any code only used for those ids, where there is overlap
> with the existing stkwebcam driver, to avoid regressions
>
> 3) It does in kernel bayer decoding, this is not acceptable, it needs to
> be modified to produce buffers with raw bayer data (libv4l will take care
> of the bater decoding in userspace).
>
> 4) It is not using any of the new kernel infrastructure we have been adding
> over time, like the control-framework, videobuf2, etc. It would be best
> to convert this to a gspca sub driver (of which there are many already,
> which can serve as examples), so that it will use all the existing
> framework code.

Here's a proof of concept that this can be done. HW dependent code copied from
stk11xx and modified a bit. Userspace bayer decoding works fine - I get
correct image in cheese (or mplayer with LD_PRELOAD)!

I've also found the STK1135 datasheet!
http://wenku.baidu.com/view/028c3459be23482fb4da4c5d
https://anonfiles.com/file/3b813f8e4c848ed26aaec804e0afa092

So I can clean up the driver now.

---
 drivers/media/usb/gspca/Kconfig   |    9 +
 drivers/media/usb/gspca/Makefile  |    2 +
 drivers/media/usb/gspca/stk1135.c |  968 +++++++++++++++++++++++++++++++++++++
 3 files changed, 979 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/usb/gspca/stk1135.c

diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index 6345f93..4f0c6d5 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -338,6 +338,15 @@ config USB_GSPCA_STK014
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_stk014.
 
+config USB_GSPCA_STK1135
+	tristate "Syntek STK1135 USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on the STK1135 chip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_stk1135.
+
 config USB_GSPCA_STV0680
 	tristate "STV0680 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff --git a/drivers/media/usb/gspca/Makefile b/drivers/media/usb/gspca/Makefile
index c901da0..5855131 100644
--- a/drivers/media/usb/gspca/Makefile
+++ b/drivers/media/usb/gspca/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_USB_GSPCA_SQ905C)   += gspca_sq905c.o
 obj-$(CONFIG_USB_GSPCA_SQ930X)   += gspca_sq930x.o
 obj-$(CONFIG_USB_GSPCA_SUNPLUS)  += gspca_sunplus.o
 obj-$(CONFIG_USB_GSPCA_STK014)   += gspca_stk014.o
+obj-$(CONFIG_USB_GSPCA_STK1135)  += gspca_stk1135.o
 obj-$(CONFIG_USB_GSPCA_STV0680)  += gspca_stv0680.o
 obj-$(CONFIG_USB_GSPCA_T613)     += gspca_t613.o
 obj-$(CONFIG_USB_GSPCA_TOPRO)    += gspca_topro.o
@@ -78,6 +79,7 @@ gspca_sq905-objs    := sq905.o
 gspca_sq905c-objs   := sq905c.o
 gspca_sq930x-objs   := sq930x.o
 gspca_stk014-objs   := stk014.o
+gspca_stk1135-objs  := stk1135.o
 gspca_stv0680-objs  := stv0680.o
 gspca_sunplus-objs  := sunplus.o
 gspca_t613-objs     := t613.o
diff --git a/drivers/media/usb/gspca/stk1135.c b/drivers/media/usb/gspca/stk1135.c
new file mode 100644
index 0000000..ce17202
--- /dev/null
+++ b/drivers/media/usb/gspca/stk1135.c
@@ -0,0 +1,968 @@
+/*
+ * Syntek STK1135 subdriver
+ *
+ * Copyright (c) 2013 Ondrej Zary
+ *
+ * Based on Syntekdriver by Nicolas VIVIEN:
+ *   http://syntekdriver.sourceforge.net
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define MODULE_NAME "stk1135"
+
+#include "gspca.h"
+
+MODULE_AUTHOR("Ondrej Zary");
+MODULE_DESCRIPTION("Syntek STK1135 USB Camera Driver");
+MODULE_LICENSE("GPL");
+
+
+/* specific webcam descriptor */
+struct sd {
+	struct gspca_dev gspca_dev;	/* !! must be the first item */
+};
+
+static const struct v4l2_pix_format stk1135_modes[] = {
+	{640, 480, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 0},
+};
+
+/* -- read a register -- */
+static u8 reg_r(struct gspca_dev *gspca_dev, __u16 index)
+{
+	struct usb_device *dev = gspca_dev->dev;
+	int ret;
+
+	if (gspca_dev->usb_err < 0)
+		return 0;
+	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
+			0x00,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0x00,
+			index,
+			gspca_dev->usb_buf, 1,
+			500);
+
+	printk("reg_r 0x%x=0x%02x\n", index, gspca_dev->usb_buf[0]);
+	if (ret < 0) {
+		pr_err("reg_r 0x%x err %d\n", index, ret);
+		gspca_dev->usb_err = ret;
+		return 0;
+	}
+
+	return gspca_dev->usb_buf[0];
+}
+
+/* -- write a register -- */
+static void reg_w(struct gspca_dev *gspca_dev, __u16 index, __u8 value)
+{
+	int ret;
+	struct usb_device *dev = gspca_dev->dev;
+
+	if (gspca_dev->usb_err < 0)
+		return;
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			0x01,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			value,
+			index,
+			NULL,
+			0,
+			500);
+	printk("reg_w 0x%x:=0x%02x\n", index, value);
+	if (ret < 0) {
+		pr_err("reg_w 0x%x err %d\n", index, ret);
+		gspca_dev->usb_err = ret;
+	}
+}
+
+/* this function is called at probe time */
+static int sd_config(struct gspca_dev *gspca_dev,
+			const struct usb_device_id *id)
+{
+	gspca_dev->cam.cam_mode = stk1135_modes;
+	gspca_dev->cam.nmodes = ARRAY_SIZE(stk1135_modes);
+	return 0;
+}
+
+int dev_stk11xx_check_device(struct gspca_dev *gspca_dev, int nbr)
+{
+	int i;
+	int value;
+
+	for (i=0; i<nbr; i++) {
+		value = reg_r(gspca_dev, 0x201);
+		
+		if (value == 0x00) {
+		}
+		else if ((value == 0x11) || (value == 0x14)) {
+		}
+		else if ((value == 0x30) || (value == 0x31)) {
+		}
+		else if ((value == 0x51)) {
+		}
+		else if ((value == 0x70) || (value == 0x71)) {
+		}
+		else if ((value == 0x91)) {
+		}
+		else if (value == 0x01) {
+			return 1;
+		}
+		else if ((value == 0x04) || (value == 0x05))
+			return 1;
+		else if (value == 0x15) 
+			return 1;
+		else {
+			pr_err("Check device return error (0x0201 = %02X) !\n", value);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+int dev_stk6a31_sensor_settings(struct gspca_dev *gspca_dev)
+{
+	int i;
+	int retok;
+
+	int asize;
+	static const int values_204[] = {
+		0xf0, 0xf1, 0x0d, 0xf1, 0x0d, 0xf1, 0xf0, 0xf1, 0x35, 0xf1,
+		0xf0, 0xf1, 0x06, 0xf1, 0xf0, 0xf1, 0xdd, 0xf1, 0xf0, 0xf1,
+		0x1f, 0xf1, 0x20, 0xf1, 0x21, 0xf1, 0x22, 0xf1, 0x23, 0xf1,
+		0x24, 0xf1, 0x28, 0xf1, 0x29, 0xf1, 0x5e, 0xf1, 0x5f, 0xf1, 
+		0x60, 0xf1, 0xef, 0xf1, 0xf2, 0xf1, 0x02, 0xf1, 0x03, 0xf1,
+		0x04, 0xf1, 0x09, 0xf1, 0x0a, 0xf1, 0x0b, 0xf1, 0x0c, 0xf1,
+		0x0d, 0xf1, 0x0e, 0xf1, 0x0f, 0xf1, 0x10, 0xf1, 0x11, 0xf1, 
+		0x15, 0xf1, 0x16, 0xf1, 0x17, 0xf1, 0x18, 0xf1, 0x19, 0xf1,
+		0x1a, 0xf1, 0x1b, 0xf1, 0x1c, 0xf1, 0x1d, 0xf1, 0x1e, 0xf1,
+		0xf0, 0xf1, 0x06, 0xf1, 0x06, 0xf1, 0xf0, 0xf1, 0x80, 0xf1,
+		0x81, 0xf1, 0x82, 0xf1, 0x83, 0xf1, 0x84, 0xf1, 0x85, 0xf1,
+		0x86, 0xf1, 0x87, 0xf1, 0x88, 0xf1, 0x89, 0xf1, 0x8a, 0xf1, 
+		0x8b, 0xf1, 0x8c, 0xf1, 0x8d, 0xf1, 0x8e, 0xf1, 0x8f, 0xf1,
+		0x90, 0xf1, 0x91, 0xf1, 0x92, 0xf1, 0x93, 0xf1, 0x94, 0xf1,
+		0x95, 0xf1, 0xb6, 0xf1, 0xb7, 0xf1, 0xb8, 0xf1, 0xb9, 0xf1,
+		0xba, 0xf1, 0xbb, 0xf1, 0xbc, 0xf1, 0xbd, 0xf1, 0xbe, 0xf1,
+		0xbf, 0xf1, 0xc0, 0xf1, 0xc1, 0xf1, 0xc2, 0xf1, 0xc3, 0xf1,
+		0xc4, 0xf1, 0x06, 0xf1, 0xf0, 0xf1, 0x53, 0xf1, 0x54, 0xf1,
+		0x55, 0xf1, 0x56, 0xf1, 0x57, 0xf1, 0x58, 0xf1, 0xdc, 0xf1,
+		0xdd, 0xf1, 0xde, 0xf1, 0xdf, 0xf1, 0xe0, 0xf1, 0xe1, 0xf1,
+		0xf0, 0xf1, 0xa7, 0xf1, 0xaa, 0xf1, 0x3a, 0xf1, 0xa1, 0xf1,
+		0xa4, 0xf1, 0x9b, 0xf1, 0x08, 0xf1, 0xf0, 0xf1, 0x2f, 0xf1,
+		0x9c, 0xf1, 0xd2, 0xf1, 0xcc, 0xf1, 0xcb, 0xf1, 0x2e, 0xf1,
+		0x67, 0xf1, 0xf0, 0xf1, 0x65, 0xf1, 0x66, 0xf1, 0x67, 0xf1,
+		0x65, 0xf1, 0xf0, 0xf1, 0x05, 0xf1, 0x07, 0xf1, 0xf0, 0xf1,
+		0x39, 0xf1, 0x3b, 0xf1, 0x3a, 0xf1, 0x3c, 0xf1, 0x57, 0xf1,
+		0x58, 0xf1, 0x59, 0xf1, 0x5a, 0xf1, 0x5c, 0xf1, 0x5d, 0xf1,
+		0x64, 0xf1, 0xf0, 0xf1, 0x5b, 0xf1, 0xf0, 0xf1, 0x36, 0xf1,
+		0x37, 0xf1, 0xf0, 0xf1, 0x08, 0xf1
+	};
+	static const int values_205[] = {
+		0x00, 0x00, 0x00, 0x0b, 0x00, 0x08, 0x00, 0x00, 0x00, 0x22,
+		0x00, 0x01, 0x70, 0x0e, 0x00, 0x02, 0x18, 0xe0, 0x00, 0x02,
+		0x01, 0x80, 0xc8, 0x14, 0x80, 0x80, 0xa0, 0x78, 0xa0, 0x78,
+		0x5f, 0x20, 0xea, 0x02, 0x86, 0x7a, 0x59, 0x4c, 0x4d, 0x51,
+		0x00, 0x02, 0x00, 0x08, 0x00, 0x00, 0x00, 0xee, 0x39, 0x23,
+		0x07, 0x24, 0x00, 0xcd, 0x00, 0x93, 0x00, 0x04, 0x00, 0x5c,
+		0x00, 0xd9, 0x00, 0x53, 0x00, 0x08, 0x00, 0x91, 0x00, 0xcf,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x01, 0xf0, 0x0e, 0x70, 0x0e, 0x00, 0x01, 0x00, 0x07,
+		0xde, 0x13, 0xeb, 0xe2, 0x00, 0xf6, 0xe1, 0x14, 0xea, 0xdd,
+		0xfd, 0xf6, 0xe5, 0x11, 0xed, 0xe6, 0xfb, 0xf7, 0xd6, 0x13, 
+		0xed, 0xec, 0xf9, 0xf2, 0x00, 0x00, 0xd8, 0x15, 0xe9, 0xea, 
+		0xf9, 0xf1, 0x00, 0x02, 0xde, 0x10, 0xef, 0xef, 0xfb, 0xf4,
+		0x00, 0x02, 0x0e, 0x06, 0x27, 0x13, 0x11, 0x06, 0x27, 0x13,
+		0x0c, 0x03, 0x2a, 0x0f, 0x12, 0x08, 0x1a, 0x16, 0x00, 0x22,
+		0x15, 0x0a, 0x1c, 0x1a, 0x00, 0x2d, 0x11, 0x09, 0x14, 0x14,
+		0x00, 0x2a, 0x74, 0x0e, 0x00, 0x01, 0x0b, 0x03, 0x47, 0x22,
+		0xac, 0x82, 0xda, 0xc7, 0xf5, 0xe9, 0xff, 0x00, 0x0b, 0x03,
+		0x47, 0x22, 0xac, 0x82, 0xda, 0xc7, 0xf5, 0xe9, 0xff, 0x00,
+		0x00, 0x01, 0x02, 0x80, 0x01, 0xe0, 0x43, 0x00, 0x05, 0x00,
+		0x04, 0x00, 0x43, 0x00, 0x01, 0x80, 0x00, 0x02, 0xd1, 0x00,
+		0xd1, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x01, 0x0c, 0x3c,
+		0x10, 0x10, 0x00, 0x00, 0xa0, 0x00, 0x20, 0x03, 0x05, 0x01,
+		0x20, 0x00, 0x00, 0x00, 0x01, 0xb8, 0x00, 0xd8, 0x00, 0x02,
+		0x06, 0xc0, 0x04, 0x0e, 0x06, 0xc0, 0x05, 0x64, 0x02, 0x08,
+		0x02, 0x71, 0x02, 0x09, 0x02, 0x71, 0x12, 0x0d, 0x17, 0x12,
+		0x5e, 0x1c, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02, 0x78, 0x10,
+		0x83, 0x04, 0x00, 0x00, 0x00, 0x21
+	};
+
+
+	asize = ARRAY_SIZE(values_204);
+
+	for(i=0; i<asize; i++) {
+		reg_r(gspca_dev, 0x02ff);
+		reg_w(gspca_dev, 0x02ff, 0x00);
+
+		reg_w(gspca_dev, 0x0203, 0xba);
+
+		reg_w(gspca_dev, 0x0204, values_204[i]);
+		reg_w(gspca_dev, 0x0205, values_205[i]);
+		reg_w(gspca_dev, 0x0200, 0x01);
+
+		retok = dev_stk11xx_check_device(gspca_dev, 500);
+
+		if (retok != 1) {
+			pr_err("Load default sensor settings fail !\n");
+			return -1;
+		}
+
+		reg_w(gspca_dev, 0x02ff, 0x00);
+	}
+
+	retok = dev_stk11xx_check_device(gspca_dev, 500);
+
+	return 0;
+}
+
+
+int dev_stk6a31_configure_device(struct gspca_dev *gspca_dev, int step)
+{
+	//     0,    1,    2,    3,    4,    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,   15,   16
+	static const int values_001B[] = {
+		0x03, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07
+	};
+	static const int values_001C[] = {
+		0x02, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06
+	};
+	static const int values_0202[] = {
+		0x0a, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x0a, 0x1e, 0x1f, 0x1f, 0x1f, 0x1f
+	};
+	static const int values_0110[] = {
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	static const int values_0112[] = {
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	static const int values_0114[] = {
+		0x80, 0x80, 0x80, 0x80, 0x00, 0xbe, 0x80, 0x80, 0x00, 0x80, 0x80, 0x80, 0x00, 0x80, 0x80, 0x80, 0x80
+	};
+	static const int values_0115[] = {
+		0x02, 0x02, 0x02, 0x02, 0x05, 0x02, 0x02, 0x02, 0x00, 0x02, 0x02, 0x02, 0x05, 0x02, 0x02, 0x02, 0x02
+	};
+	static const int values_0116[] = {
+		0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe9, 0xe0, 0xe0, 0x00, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
+	};
+	static const int values_0117[] = {
+		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
+	};
+	static const int values_0100[] = {
+		0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
+	};
+
+
+	pr_debug("dev_stk6a31_configure_device : %d\n", step);
+
+	reg_w(gspca_dev, 0x0000, 0x24);
+	reg_w(gspca_dev, 0x0002, 0x78);
+	reg_w(gspca_dev, 0x0003, 0x80);
+	reg_w(gspca_dev, 0x0005, 0x00);
+	
+	reg_w(gspca_dev, 0x0007, 0x03);
+	reg_w(gspca_dev, 0x000d, 0x00);
+	reg_w(gspca_dev, 0x000f, 0x02);
+	reg_w(gspca_dev, 0x0300, 0x12);
+	reg_w(gspca_dev, 0x0350, 0x41);
+	
+	reg_w(gspca_dev, 0x0351, 0x00);
+	reg_w(gspca_dev, 0x0352, 0x00);
+	reg_w(gspca_dev, 0x0353, 0x00);
+	reg_w(gspca_dev, 0x0018, 0x10);
+	reg_w(gspca_dev, 0x0019, 0x00);
+	
+	reg_w(gspca_dev, 0x001b, values_001B[step]);
+	reg_w(gspca_dev, 0x001c, values_001C[step]);
+	reg_w(gspca_dev, 0x0300, 0x80);
+	reg_w(gspca_dev, 0x001a, 0x04);
+	reg_w(gspca_dev, 0x0202, values_0202[step]);
+	
+	reg_w(gspca_dev, 0x0110, values_0110[step]);
+	reg_w(gspca_dev, 0x0111, 0x00);
+	reg_w(gspca_dev, 0x0112, values_0112[step]);
+	reg_w(gspca_dev, 0x0113, 0x00);
+	reg_w(gspca_dev, 0x0114, values_0114[step]);
+	
+	reg_w(gspca_dev, 0x0115, values_0115[step]);
+	reg_w(gspca_dev, 0x0116, values_0116[step]);
+	reg_w(gspca_dev, 0x0117, values_0117[step]);
+
+	reg_r(gspca_dev, 0x0100);
+	reg_w(gspca_dev, 0x0100, values_0100[step]);
+
+//	reg_w(gspca_dev, 0x0200, 0x80); 
+//	reg_w(gspca_dev, 0x0200, 0x00); 
+	reg_w(gspca_dev, 0x02ff, 0x00); 
+
+
+	switch (step) {
+		case 0:
+			reg_w(gspca_dev, 0x0203, 0x22); 
+
+			reg_w(gspca_dev, 0x0204, 0x27); 
+			reg_w(gspca_dev, 0x0205, 0xa5); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+	
+		case 1:
+			reg_w(gspca_dev, 0x0203, 0x60); 
+
+			reg_w(gspca_dev, 0x0204, 0x12); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+			reg_w(gspca_dev, 0x0204, 0x13); 
+			reg_w(gspca_dev, 0x0205, 0xbf); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 2:
+			reg_w(gspca_dev, 0x0203, 0x42); 
+
+			reg_w(gspca_dev, 0x0204, 0x12); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+			reg_w(gspca_dev, 0x0204, 0x24); 
+			reg_w(gspca_dev, 0x0205, 0xa5); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 3:
+			reg_w(gspca_dev, 0x0203, 0x42); 
+
+			reg_w(gspca_dev, 0x0204, 0x12); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+			reg_w(gspca_dev, 0x0204, 0x13); 
+			reg_w(gspca_dev, 0x0205, 0xe0); 
+			reg_w(gspca_dev, 0x0204, 0x24); 
+			reg_w(gspca_dev, 0x0205, 0xa5); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 4:
+			reg_w(gspca_dev, 0x0203, 0x42); 
+
+			reg_w(gspca_dev, 0x0204, 0x12); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+			reg_w(gspca_dev, 0x0204, 0x13); 
+			reg_w(gspca_dev, 0x0205, 0xbf); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 5:
+			reg_w(gspca_dev, 0x0203, 0x60); 
+
+			reg_w(gspca_dev, 0x0204, 0x12); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+			reg_w(gspca_dev, 0x0204, 0x13); 
+			reg_w(gspca_dev, 0x0205, 0xff); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 6:
+			reg_w(gspca_dev, 0x0203, 0x60); 
+
+			reg_w(gspca_dev, 0x0204, 0x12); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+			reg_w(gspca_dev, 0x0204, 0x13); 
+			reg_w(gspca_dev, 0x0205, 0xb7); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 7:
+			reg_w(gspca_dev, 0x0203, 0x60); 
+
+			reg_w(gspca_dev, 0x0204, 0x12); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+			reg_w(gspca_dev, 0x0204, 0x13); 
+			reg_w(gspca_dev, 0x0205, 0xb7); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 8:
+			reg_w(gspca_dev, 0x0203, 0x60); 
+
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+
+			reg_w(gspca_dev, 0x0203, 0x60); 
+			reg_w(gspca_dev, 0x0204, 0xff); 
+			reg_w(gspca_dev, 0x0205, 0x01); 
+			reg_w(gspca_dev, 0x0200, 0x01); 
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+
+			reg_w(gspca_dev, 0x0203, 0x60); 
+			reg_w(gspca_dev, 0x0208, 0x0a); 
+			reg_w(gspca_dev, 0x0200, 0x20); 
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+
+			reg_w(gspca_dev, 0x0203, 0x60); 
+			reg_w(gspca_dev, 0x0208, 0x0b); 
+			reg_w(gspca_dev, 0x0200, 0x20); 
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+
+			reg_w(gspca_dev, 0x0203, 0x60); 
+			reg_w(gspca_dev, 0x0208, 0x1c); 
+			reg_w(gspca_dev, 0x0200, 0x20); 
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+
+			reg_w(gspca_dev, 0x0203, 0x60); 
+			reg_w(gspca_dev, 0x0208, 0x1d); 
+			reg_w(gspca_dev, 0x0200, 0x20); 
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00); 
+
+			break;
+
+		case 9:
+			reg_w(gspca_dev, 0x0203, 0xdc); 
+
+			reg_w(gspca_dev, 0x0204, 0x15); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 10:
+			reg_w(gspca_dev, 0x0203, 0xec); 
+
+			reg_w(gspca_dev, 0x0204, 0x15); 
+			reg_w(gspca_dev, 0x0205, 0x80); 
+
+			reg_w(gspca_dev, 0x0200, 0x05); 
+
+			break;
+
+		case 11:
+			reg_w(gspca_dev, 0x0203, 0xba); 
+
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			reg_w(gspca_dev, 0x0203, 0xba); 
+
+			reg_w(gspca_dev, 0x0208, 0x00);
+			reg_w(gspca_dev, 0x0200, 0x20);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			break;
+
+		case 12:
+			reg_w(gspca_dev, 0x0203, 0xba); 
+
+			reg_w(gspca_dev, 0x0204, 0xf0); 
+			reg_w(gspca_dev, 0x0205, 0x00); 
+			reg_w(gspca_dev, 0x0200, 0x05);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_w(gspca_dev, 0x0204, 0xf1); 
+			reg_w(gspca_dev, 0x0205, 0x00); 
+			reg_w(gspca_dev, 0x0200, 0x05);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			reg_w(gspca_dev, 0x0203, 0xba); 
+			reg_w(gspca_dev, 0x0208, 0x00);
+			reg_w(gspca_dev, 0x0200, 0x20);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			reg_w(gspca_dev, 0x0203, 0xba); 
+			reg_w(gspca_dev, 0x0208, 0xf1);
+			reg_w(gspca_dev, 0x0200, 0x20);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			break;
+
+		case 13:
+			reg_w(gspca_dev, 0x0203, 0xba); 
+
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			reg_w(gspca_dev, 0x0203, 0xba); 
+			reg_w(gspca_dev, 0x0208, 0x00);
+			reg_w(gspca_dev, 0x0200, 0x20);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			reg_w(gspca_dev, 0x0203, 0xba); 
+			reg_w(gspca_dev, 0x0208, 0xf1);
+			reg_w(gspca_dev, 0x0200, 0x20);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			break;
+
+		case 14:
+			reg_w(gspca_dev, 0x0203, 0xba); 
+
+			reg_w(gspca_dev, 0x0204, 0x01); 
+			reg_w(gspca_dev, 0x0205, 0x00); 
+			reg_w(gspca_dev, 0x0200, 0x05); 
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_w(gspca_dev, 0x0204, 0xf1); 
+			reg_w(gspca_dev, 0x0205, 0x00); 
+			reg_w(gspca_dev, 0x0200, 0x05); 
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			reg_w(gspca_dev, 0x0203, 0xba); 
+			reg_w(gspca_dev, 0x0208, 0x00);
+			reg_w(gspca_dev, 0x0200, 0x20);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+			reg_r(gspca_dev, 0x02ff);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			reg_w(gspca_dev, 0x0203, 0xba); 
+			reg_w(gspca_dev, 0x0208, 0xf1);
+			reg_w(gspca_dev, 0x0200, 0x20);
+			dev_stk11xx_check_device(gspca_dev, 500);
+			reg_r(gspca_dev, 0x0209);
+			reg_w(gspca_dev, 0x02ff, 0x00);
+
+			break;
+
+		case 15:
+			reg_w(gspca_dev, 0x0203, 0xba); 
+
+			dev_stk6a31_sensor_settings(gspca_dev);
+
+			reg_w(gspca_dev, 0x0200, 0x80);
+			reg_w(gspca_dev, 0x0200, 0x00);
+			reg_w(gspca_dev, 0x02ff, 0x01);
+			reg_w(gspca_dev, 0x0203, 0xa0);
+
+
+			break;
+
+		case 16:
+			reg_w(gspca_dev, 0x0203, 0xba); 
+
+			dev_stk6a31_sensor_settings(gspca_dev);
+
+			break;
+	}
+	
+	return 0;
+}
+
+int dev_stk6a31_camera_wake(struct gspca_dev *gspca_dev)
+{
+	reg_r(gspca_dev, 0x0104);
+	reg_r(gspca_dev, 0x0105);
+	reg_r(gspca_dev, 0x0106);
+
+	reg_w(gspca_dev, 0x0100, 0x21);
+	reg_w(gspca_dev, 0x0116, 0x00);
+	reg_w(gspca_dev, 0x0117, 0x00);
+	reg_w(gspca_dev, 0x0018, 0x00);
+
+	reg_r(gspca_dev, 0x0000);
+	reg_w(gspca_dev, 0x0000, 0x49);
+
+	return 0;
+}
+
+static int stk1135_set_feature(struct gspca_dev *gspca_dev, int index)
+{
+	int result;
+	struct usb_device *dev = gspca_dev->dev;
+
+	result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			USB_REQ_SET_FEATURE,
+			USB_TYPE_STANDARD | USB_DIR_OUT | USB_RECIP_DEVICE,
+			USB_DEVICE_REMOTE_WAKEUP,
+			index,
+			NULL,
+			0,
+			500);
+	
+	if (result < 0)
+		pr_err("SET FEATURE fail !\n");
+	else 
+		pr_debug("SET FEATURE\n");
+
+	return result;
+}
+
+int dev_stk6a31_camera_settings(struct gspca_dev *gspca_dev)
+{
+	int i;
+
+	int asize;
+	static const int values_204[] = {
+		0xf0, 0xf1, 0x2e, 0xf1, 0xf0, 0xf1, 0x5b, 0xf1, 0xf0, 0xf1, 0x36, 0xf1, 0x37, 0xf1, 0xf0, 0xf1, 0x08, 0xf1
+	};
+	static const int values_205[] = {
+		0x00, 0x02, 0x0c, 0x3c, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02, 0x78, 0x10, 0x83, 0x04, 0x00, 0x00, 0x00, 0x21
+	};
+
+
+	asize = ARRAY_SIZE(values_204);
+
+	// Contrast register
+	for (i=0; i<asize; i++) {
+		reg_r(gspca_dev, 0x02ff);
+		reg_w(gspca_dev, 0x02ff, 0x00);
+
+		reg_w(gspca_dev, 0x0204, values_204[i]);
+		reg_w(gspca_dev, 0x0205, values_205[i]);
+
+		reg_w(gspca_dev, 0x0200, 0x01);
+		dev_stk11xx_check_device(gspca_dev, 500);
+		reg_w(gspca_dev, 0x02ff, 0x00);
+	}
+
+	return 0;
+}
+
+int dev_stk6a31_reconf_camera(struct gspca_dev *gspca_dev)
+{
+	dev_stk6a31_configure_device(gspca_dev, 16);
+
+	dev_stk6a31_camera_settings(gspca_dev);
+
+	return 0;
+}
+
+/** 
+ * @param dev Device structure
+ * 
+ * @returns 0 if all is OK
+ *
+ * @brief This function initializes the device for the stream.
+ *
+ * It's the start. This function has to be called at first, before
+ * enabling the video stream.
+ */
+int dev_stk6a31_init_camera(struct gspca_dev *gspca_dev)
+{
+//	int retok;
+//	int value;
+
+	dev_stk6a31_camera_wake(gspca_dev);
+
+	stk1135_set_feature(gspca_dev, 0);
+
+	dev_stk6a31_camera_wake(gspca_dev);
+
+	reg_w(gspca_dev, 0x0000, 0xe0);
+	reg_w(gspca_dev, 0x0002, 0xf8);
+	reg_w(gspca_dev, 0x0002, 0x78);
+	reg_w(gspca_dev, 0x0000, 0x20);
+
+	dev_stk6a31_configure_device(gspca_dev, 15);
+
+//	dev_stk11xx_camera_off(dev); is this:
+	usb_set_interface(gspca_dev->dev, 0, 0);
+
+	return 0;
+}
+
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	reg_w(gspca_dev, 0x0000, 0xe0);
+	reg_w(gspca_dev, 0x0002, 0xf8);
+	reg_w(gspca_dev, 0x0002, 0x78);
+	reg_w(gspca_dev, 0x0000, 0x20);
+
+	dev_stk6a31_configure_device(gspca_dev, 0);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 1);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 2);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 3);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 4);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 5);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 6);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 7);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 8);
+
+	dev_stk6a31_configure_device(gspca_dev, 9);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 10);
+	dev_stk11xx_check_device(gspca_dev, 65);
+	reg_w(gspca_dev, 0x0200, 0x08);
+
+	dev_stk6a31_configure_device(gspca_dev, 11);
+
+	dev_stk6a31_configure_device(gspca_dev, 12);
+
+	dev_stk6a31_configure_device(gspca_dev, 13);
+
+	dev_stk6a31_configure_device(gspca_dev, 14);
+
+	dev_stk6a31_camera_wake(gspca_dev);
+
+	stk1135_set_feature(gspca_dev, 0);
+
+	return gspca_dev->usb_err;
+}
+
+/* -- start the camera -- */
+
+int dev_stk6a31_start_stream(struct gspca_dev *gspca_dev)
+{
+	int value_116, value_117;
+
+	reg_r(gspca_dev, 0x0114); // read 0x80
+	reg_r(gspca_dev, 0x0115); // read 0x02
+
+	value_116 = reg_r(gspca_dev, 0x0116);
+	value_117 = reg_r(gspca_dev, 0x0117);
+
+	reg_w(gspca_dev, 0x0116, 0x00);
+	reg_w(gspca_dev, 0x0117, 0x00);
+
+	reg_r(gspca_dev, 0x0100); // read 0x21
+	reg_w(gspca_dev, 0x0100, 0xa0);
+
+	reg_w(gspca_dev, 0x0116, value_116);
+	reg_w(gspca_dev, 0x0117, value_117);
+
+	return 0;
+}
+
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret, value;
+
+	/* work on alternate 1 */
+//	usb_set_interface(gspca_dev->dev, gspca_dev->iface, 1);
+
+//	ret = usb_set_interface(gspca_dev->dev,
+//					gspca_dev->iface,
+//					gspca_dev->alt);
+//	if (ret < 0) {
+//		pr_err("set intf %d %d failed\n",
+//		       gspca_dev->iface, gspca_dev->alt);
+//		gspca_dev->usb_err = ret;
+//		goto out;
+//	}
+	dev_stk6a31_init_camera(gspca_dev);
+//	camera_on(gspca_dev); is:
+	usb_set_interface(gspca_dev->dev, 0, 5);
+	dev_stk6a31_reconf_camera(gspca_dev);
+	dev_stk6a31_start_stream(gspca_dev);
+	dev_stk6a31_camera_settings(gspca_dev);
+
+
+	if (gspca_dev->usb_err >= 0)
+		PDEBUG(D_STREAM, "camera started alt: 0x%02x",
+				gspca_dev->alt);
+out:
+	return gspca_dev->usb_err;
+}
+
+static void sd_stopN(struct gspca_dev *gspca_dev)
+{
+	struct usb_device *dev = gspca_dev->dev;
+
+	usb_set_interface(dev, gspca_dev->iface, 1);
+	PDEBUG(D_STREAM, "camera stopped");
+}
+
+static void sd_pkt_scan(struct gspca_dev *gspca_dev,
+			u8 *data,			/* isoc packet */
+			int len)			/* iso packet length */
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int i, skip;
+
+	printk("pkt: len=%d\n", len);
+//	for (i = 0; i < len; i++)
+//		printk("%02x ", data[i]);
+//	printk("\n");
+
+	if (len > 4) {
+		/* skip header */
+		skip = 4;
+		if (data[0] & 0x80)
+			skip = 8;
+		if (gspca_dev->last_packet_type == LAST_PACKET) {
+			printk("first\n");
+			gspca_frame_add(gspca_dev, FIRST_PACKET, data + skip, len - skip);
+		} else {
+			printk("inter\n");
+			gspca_frame_add(gspca_dev, INTER_PACKET, data + skip, len - skip);
+		}
+	}
+
+	if (len == 4 && gspca_dev->last_packet_type != LAST_PACKET) {
+		printk("last\n");
+		gspca_frame_add(gspca_dev, LAST_PACKET, data, 0);
+	}
+}
+
+static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct gspca_dev *gspca_dev =
+		container_of(ctrl->handler, struct gspca_dev, ctrl_handler);
+
+	gspca_dev->usb_err = 0;
+
+	if (!gspca_dev->streaming)
+		return 0;
+
+	return gspca_dev->usb_err;
+}
+
+static const struct v4l2_ctrl_ops sd_ctrl_ops = {
+	.s_ctrl = sd_s_ctrl,
+};
+
+static int sd_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct v4l2_ctrl_handler *hdl = &gspca_dev->ctrl_handler;
+
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
+	v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 127);
+	v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 127);
+	v4l2_ctrl_new_std_menu(hdl, &sd_ctrl_ops,
+			V4L2_CID_POWER_LINE_FREQUENCY,
+			V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 1,
+			V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
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
+//	.init_controls = sd_init_controls,
+	.start = sd_start,
+	.stopN = sd_stopN,
+	.pkt_scan = sd_pkt_scan,
+};
+
+/* -- module initialisation -- */
+static const struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x174f, 0x6a31)},
+	{}
+};
+MODULE_DEVICE_TABLE(usb, device_table);
+
+/* -- device connect -- */
+static int sd_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
+				THIS_MODULE);
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
+	.reset_resume = gspca_resume,
+#endif
+};
+
+module_usb_driver(sd_driver);
-- 
Ondrej Zary
