Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab2HNUzh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 16:55:37 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7EKtbbA018728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 16:55:37 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/12] [media] move analog PCI saa7146 drivers to its own dir
Date: Tue, 14 Aug 2012 17:55:20 -0300
Message-Id: <1344977727-16319-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
References: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having them under drivers/media/video, move them
to their own directory.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/Kconfig                 |   2 +
 drivers/media/pci/Makefile                |   3 +-
 drivers/media/pci/saa7146/Kconfig         |  38 ++
 drivers/media/pci/saa7146/Makefile        |   5 +
 drivers/media/pci/saa7146/hexium_gemini.c | 430 +++++++++++++++
 drivers/media/pci/saa7146/hexium_orion.c  | 502 +++++++++++++++++
 drivers/media/pci/saa7146/mxb.c           | 886 ++++++++++++++++++++++++++++++
 drivers/media/video/Kconfig               |  38 --
 drivers/media/video/Makefile              |   3 -
 drivers/media/video/hexium_gemini.c       | 430 ---------------
 drivers/media/video/hexium_orion.c        | 502 -----------------
 drivers/media/video/mxb.c                 | 886 ------------------------------
 12 files changed, 1865 insertions(+), 1860 deletions(-)
 create mode 100644 drivers/media/pci/saa7146/Kconfig
 create mode 100644 drivers/media/pci/saa7146/Makefile
 create mode 100644 drivers/media/pci/saa7146/hexium_gemini.c
 create mode 100644 drivers/media/pci/saa7146/hexium_orion.c
 create mode 100644 drivers/media/pci/saa7146/mxb.c
 delete mode 100644 drivers/media/video/hexium_gemini.c
 delete mode 100644 drivers/media/video/hexium_orion.c
 delete mode 100644 drivers/media/video/mxb.c

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index b69cb12..e1a9e1a 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -9,6 +9,7 @@ if MEDIA_ANALOG_TV_SUPPORT
 	comment "Media capture/analog TV support"
 source "drivers/media/pci/ivtv/Kconfig"
 source "drivers/media/pci/zoran/Kconfig"
+source "drivers/media/pci/saa7146/Kconfig"
 endif
 
 if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
@@ -20,6 +21,7 @@ source "drivers/media/pci/cx88/Kconfig"
 source "drivers/media/pci/bt8xx/Kconfig"
 source "drivers/media/pci/saa7134/Kconfig"
 source "drivers/media/pci/saa7164/Kconfig"
+
 endif
 
 if MEDIA_DIGITAL_TV_SUPPORT
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index d47c222..bb71e30 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -10,7 +10,8 @@ obj-y        :=	ttpci/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
-		b2c2/
+		b2c2/		\
+		saa7146/
 
 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_ZORAN) += zoran/
diff --git a/drivers/media/pci/saa7146/Kconfig b/drivers/media/pci/saa7146/Kconfig
new file mode 100644
index 0000000..8923b76
--- /dev/null
+++ b/drivers/media/pci/saa7146/Kconfig
@@ -0,0 +1,38 @@
+config VIDEO_HEXIUM_GEMINI
+	tristate "Hexium Gemini frame grabber"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	---help---
+	  This is a video4linux driver for the Hexium Gemini frame
+	  grabber card by Hexium. Please note that the Gemini Dual
+	  card is *not* fully supported.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hexium_gemini.
+
+config VIDEO_HEXIUM_ORION
+	tristate "Hexium HV-PCI6 and Orion frame grabber"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	---help---
+	  This is a video4linux driver for the Hexium HV-PCI6 and
+	  Orion frame grabber cards by Hexium.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hexium_orion.
+
+config VIDEO_MXB
+	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
+	depends on PCI && VIDEO_V4L2 && I2C
+	select VIDEO_SAA7146_VV
+	select VIDEO_TUNER
+	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
+	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
+	---help---
+	  This is a video4linux driver for the 'Multimedia eXtension Board'
+	  TV card by Siemens-Nixdorf.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mxb.
diff --git a/drivers/media/pci/saa7146/Makefile b/drivers/media/pci/saa7146/Makefile
new file mode 100644
index 0000000..362a38b
--- /dev/null
+++ b/drivers/media/pci/saa7146/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_VIDEO_MXB) += mxb.o
+obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
+obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
+
+ccflags-y += -I$(srctree)/drivers/media/video
diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
new file mode 100644
index 0000000..366434f
--- /dev/null
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -0,0 +1,430 @@
+/*
+    hexium_gemini.c - v4l2 driver for Hexium Gemini frame grabber cards
+
+    Visit http://www.mihu.de/linux/saa7146/ and follow the link
+    to "hexium" for further details about this card.
+
+    Copyright (C) 2003 Michael Hunold <michael@mihu.de>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define DEBUG_VARIABLE debug
+
+#include <media/saa7146_vv.h>
+#include <linux/module.h>
+
+static int debug;
+module_param(debug, int, 0);
+MODULE_PARM_DESC(debug, "debug verbosity");
+
+/* global variables */
+static int hexium_num;
+
+#define HEXIUM_GEMINI			4
+#define HEXIUM_GEMINI_DUAL		5
+
+#define HEXIUM_INPUTS	9
+static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
+	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+};
+
+#define HEXIUM_AUDIOS	0
+
+struct hexium_data
+{
+	s8 adr;
+	u8 byte;
+};
+
+#define HEXIUM_GEMINI_V_1_0		1
+#define HEXIUM_GEMINI_DUAL_V_1_0	2
+
+struct hexium
+{
+	int type;
+
+	struct video_device	*video_dev;
+	struct i2c_adapter	i2c_adapter;
+
+	int 		cur_input;	/* current input */
+	v4l2_std_id 	cur_std;	/* current standard */
+};
+
+/* Samsung KS0127B decoder default registers */
+static u8 hexium_ks0127b[0x100]={
+/*00*/ 0x00,0x52,0x30,0x40,0x01,0x0C,0x2A,0x10,
+/*08*/ 0x00,0x00,0x00,0x60,0x00,0x00,0x0F,0x06,
+/*10*/ 0x00,0x00,0xE4,0xC0,0x00,0x00,0x00,0x00,
+/*18*/ 0x14,0x9B,0xFE,0xFF,0xFC,0xFF,0x03,0x22,
+/*20*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*28*/ 0x00,0x00,0x00,0x00,0x00,0x2C,0x9B,0x00,
+/*30*/ 0x00,0x00,0x10,0x80,0x80,0x10,0x80,0x80,
+/*38*/ 0x01,0x04,0x00,0x00,0x00,0x29,0xC0,0x00,
+/*40*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*48*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*50*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*58*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*60*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*68*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*70*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*78*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*80*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*88*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*90*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*98*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*A0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*A8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*B0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*B8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*C0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*C8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*D0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*D8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*E0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*E8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*F0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
+/*F8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
+};
+
+static struct hexium_data hexium_pal[] = {
+	{ 0x01, 0x52 }, { 0x12, 0x64 }, { 0x2D, 0x2C }, { 0x2E, 0x9B }, { -1 , 0xFF }
+};
+
+static struct hexium_data hexium_ntsc[] = {
+	{ 0x01, 0x53 }, { 0x12, 0x04 }, { 0x2D, 0x23 }, { 0x2E, 0x81 }, { -1 , 0xFF }
+};
+
+static struct hexium_data hexium_secam[] = {
+	{ 0x01, 0x52 }, { 0x12, 0x64 }, { 0x2D, 0x2C }, { 0x2E, 0x9B }, { -1 , 0xFF }
+};
+
+static struct hexium_data hexium_input_select[] = {
+	{ 0x02, 0x60 },
+	{ 0x02, 0x64 },
+	{ 0x02, 0x61 },
+	{ 0x02, 0x65 },
+	{ 0x02, 0x62 },
+	{ 0x02, 0x66 },
+	{ 0x02, 0x68 },
+	{ 0x02, 0x69 },
+	{ 0x02, 0x6A },
+};
+
+/* fixme: h_offset = 0 for Hexium Gemini *Dual*, which
+   are currently *not* supported*/
+static struct saa7146_standard hexium_standards[] = {
+	{
+		.name	= "PAL", 	.id	= V4L2_STD_PAL,
+		.v_offset	= 28,	.v_field 	= 288,
+		.h_offset	= 1,	.h_pixels 	= 680,
+		.v_max_out	= 576,	.h_max_out	= 768,
+	}, {
+		.name	= "NTSC", 	.id	= V4L2_STD_NTSC,
+		.v_offset	= 28,	.v_field 	= 240,
+		.h_offset	= 1,	.h_pixels 	= 640,
+		.v_max_out	= 480,	.h_max_out	= 640,
+	}, {
+		.name	= "SECAM", 	.id	= V4L2_STD_SECAM,
+		.v_offset	= 28,	.v_field 	= 288,
+		.h_offset	= 1,	.h_pixels 	= 720,
+		.v_max_out	= 576,	.h_max_out	= 768,
+	}
+};
+
+/* bring hardware to a sane state. this has to be done, just in case someone
+   wants to capture from this device before it has been properly initialized.
+   the capture engine would badly fail, because no valid signal arrives on the
+   saa7146, thus leading to timeouts and stuff. */
+static int hexium_init_done(struct saa7146_dev *dev)
+{
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+	union i2c_smbus_data data;
+	int i = 0;
+
+	DEB_D("hexium_init_done called\n");
+
+	/* initialize the helper ics to useful values */
+	for (i = 0; i < sizeof(hexium_ks0127b); i++) {
+		data.byte = hexium_ks0127b[i];
+		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, i, I2C_SMBUS_BYTE_DATA, &data)) {
+			pr_err("hexium_init_done() failed for address 0x%02x\n",
+			       i);
+		}
+	}
+
+	return 0;
+}
+
+static int hexium_set_input(struct hexium *hexium, int input)
+{
+	union i2c_smbus_data data;
+
+	DEB_D("\n");
+
+	data.byte = hexium_input_select[input].byte;
+	if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, hexium_input_select[input].adr, I2C_SMBUS_BYTE_DATA, &data)) {
+		return -1;
+	}
+
+	return 0;
+}
+
+static int hexium_set_standard(struct hexium *hexium, struct hexium_data *vdec)
+{
+	union i2c_smbus_data data;
+	int i = 0;
+
+	DEB_D("\n");
+
+	while (vdec[i].adr != -1) {
+		data.byte = vdec[i].byte;
+		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, vdec[i].adr, I2C_SMBUS_BYTE_DATA, &data)) {
+			pr_err("hexium_init_done: hexium_set_standard() failed for address 0x%02x\n",
+			       i);
+			return -1;
+		}
+		i++;
+	}
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+{
+	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
+
+	if (i->index >= HEXIUM_INPUTS)
+		return -EINVAL;
+
+	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
+
+	DEB_D("v4l2_ioctl: VIDIOC_ENUMINPUT %d\n", i->index);
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *fh, unsigned int *input)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	*input = hexium->cur_input;
+
+	DEB_D("VIDIOC_G_INPUT: %d\n", *input);
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	DEB_EE("VIDIOC_S_INPUT %d\n", input);
+
+	if (input >= HEXIUM_INPUTS)
+		return -EINVAL;
+
+	hexium->cur_input = input;
+	hexium_set_input(hexium, input);
+	return 0;
+}
+
+static struct saa7146_ext_vv vv_data;
+
+/* this function only gets called when the probing was successful */
+static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
+{
+	struct hexium *hexium;
+	int ret;
+
+	DEB_EE("\n");
+
+	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
+	if (NULL == hexium) {
+		pr_err("not enough kernel memory in hexium_attach()\n");
+		return -ENOMEM;
+	}
+	dev->ext_priv = hexium;
+
+	/* enable i2c-port pins */
+	saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
+
+	hexium->i2c_adapter = (struct i2c_adapter) {
+		.name = "hexium gemini",
+	};
+	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
+	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
+		DEB_S("cannot register i2c-device. skipping.\n");
+		kfree(hexium);
+		return -EFAULT;
+	}
+
+	/*  set HWControl GPIO number 2 */
+	saa7146_setgpio(dev, 2, SAA7146_GPIO_OUTHI);
+
+	saa7146_write(dev, DD1_INIT, 0x07000700);
+	saa7146_write(dev, DD1_STREAM_B, 0x00000000);
+	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
+
+	/* the rest */
+	hexium->cur_input = 0;
+	hexium_init_done(dev);
+
+	hexium_set_standard(hexium, hexium_pal);
+	hexium->cur_std = V4L2_STD_PAL;
+
+	hexium_set_input(hexium, 0);
+	hexium->cur_input = 0;
+
+	saa7146_vv_init(dev, &vv_data);
+
+	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
+	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
+	ret = saa7146_register_device(&hexium->video_dev, dev, "hexium gemini", VFL_TYPE_GRABBER);
+	if (ret < 0) {
+		pr_err("cannot register capture v4l2 device. skipping.\n");
+		return ret;
+	}
+
+	pr_info("found 'hexium gemini' frame grabber-%d\n", hexium_num);
+	hexium_num++;
+
+	return 0;
+}
+
+static int hexium_detach(struct saa7146_dev *dev)
+{
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	DEB_EE("dev:%p\n", dev);
+
+	saa7146_unregister_device(&hexium->video_dev, dev);
+	saa7146_vv_release(dev);
+
+	hexium_num--;
+
+	i2c_del_adapter(&hexium->i2c_adapter);
+	kfree(hexium);
+	return 0;
+}
+
+static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *std)
+{
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	if (V4L2_STD_PAL == std->id) {
+		hexium_set_standard(hexium, hexium_pal);
+		hexium->cur_std = V4L2_STD_PAL;
+		return 0;
+	} else if (V4L2_STD_NTSC == std->id) {
+		hexium_set_standard(hexium, hexium_ntsc);
+		hexium->cur_std = V4L2_STD_NTSC;
+		return 0;
+	} else if (V4L2_STD_SECAM == std->id) {
+		hexium_set_standard(hexium, hexium_secam);
+		hexium->cur_std = V4L2_STD_SECAM;
+		return 0;
+	}
+
+	return -1;
+}
+
+static struct saa7146_extension hexium_extension;
+
+static struct saa7146_pci_extension_data hexium_gemini_4bnc = {
+	.ext_priv = "Hexium Gemini (4 BNC)",
+	.ext = &hexium_extension,
+};
+
+static struct saa7146_pci_extension_data hexium_gemini_dual_4bnc = {
+	.ext_priv = "Hexium Gemini Dual (4 BNC)",
+	.ext = &hexium_extension,
+};
+
+static struct pci_device_id pci_tbl[] = {
+	{
+	 .vendor = PCI_VENDOR_ID_PHILIPS,
+	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
+	 .subvendor = 0x17c8,
+	 .subdevice = 0x2401,
+	 .driver_data = (unsigned long) &hexium_gemini_4bnc,
+	 },
+	{
+	 .vendor = PCI_VENDOR_ID_PHILIPS,
+	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
+	 .subvendor = 0x17c8,
+	 .subdevice = 0x2402,
+	 .driver_data = (unsigned long) &hexium_gemini_dual_4bnc,
+	 },
+	{
+	 .vendor = 0,
+	 }
+};
+
+MODULE_DEVICE_TABLE(pci, pci_tbl);
+
+static struct saa7146_ext_vv vv_data = {
+	.inputs = HEXIUM_INPUTS,
+	.capabilities = 0,
+	.stds = &hexium_standards[0],
+	.num_stds = sizeof(hexium_standards) / sizeof(struct saa7146_standard),
+	.std_callback = &std_callback,
+};
+
+static struct saa7146_extension hexium_extension = {
+	.name = "hexium gemini",
+	.flags = SAA7146_USE_I2C_IRQ,
+
+	.pci_tbl = &pci_tbl[0],
+	.module = THIS_MODULE,
+
+	.attach = hexium_attach,
+	.detach = hexium_detach,
+
+	.irq_mask = 0,
+	.irq_func = NULL,
+};
+
+static int __init hexium_init_module(void)
+{
+	if (0 != saa7146_register_extension(&hexium_extension)) {
+		DEB_S("failed to register extension\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __exit hexium_cleanup_module(void)
+{
+	saa7146_unregister_extension(&hexium_extension);
+}
+
+module_init(hexium_init_module);
+module_exit(hexium_cleanup_module);
+
+MODULE_DESCRIPTION("video4linux-2 driver for Hexium Gemini frame grabber cards");
+MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
new file mode 100644
index 0000000..a1eb26d
--- /dev/null
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -0,0 +1,502 @@
+/*
+    hexium_orion.c - v4l2 driver for the Hexium Orion frame grabber cards
+
+    Visit http://www.mihu.de/linux/saa7146/ and follow the link
+    to "hexium" for further details about this card.
+
+    Copyright (C) 2003 Michael Hunold <michael@mihu.de>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define DEBUG_VARIABLE debug
+
+#include <media/saa7146_vv.h>
+#include <linux/module.h>
+
+static int debug;
+module_param(debug, int, 0);
+MODULE_PARM_DESC(debug, "debug verbosity");
+
+/* global variables */
+static int hexium_num;
+
+#define HEXIUM_HV_PCI6_ORION		1
+#define HEXIUM_ORION_1SVHS_3BNC		2
+#define HEXIUM_ORION_4BNC		3
+
+#define HEXIUM_INPUTS	9
+static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
+	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+};
+
+#define HEXIUM_AUDIOS	0
+
+struct hexium_data
+{
+	s8 adr;
+	u8 byte;
+};
+
+struct hexium
+{
+	int type;
+	struct video_device	*video_dev;
+	struct i2c_adapter	i2c_adapter;
+
+	int cur_input;	/* current input */
+};
+
+/* Philips SAA7110 decoder default registers */
+static u8 hexium_saa7110[53]={
+/*00*/ 0x4C,0x3C,0x0D,0xEF,0xBD,0xF0,0x00,0x00,
+/*08*/ 0xF8,0xF8,0x60,0x60,0x40,0x86,0x18,0x90,
+/*10*/ 0x00,0x2C,0x40,0x46,0x42,0x1A,0xFF,0xDA,
+/*18*/ 0xF0,0x8B,0x00,0x00,0x00,0x00,0x00,0x00,
+/*20*/ 0xD9,0x17,0x40,0x41,0x80,0x41,0x80,0x4F,
+/*28*/ 0xFE,0x01,0x0F,0x0F,0x03,0x01,0x81,0x03,
+/*30*/ 0x44,0x75,0x01,0x8C,0x03
+};
+
+static struct {
+	struct hexium_data data[8];
+} hexium_input_select[] = {
+{
+	{ /* cvbs 1 */
+		{ 0x06, 0x00 },
+		{ 0x20, 0xD9 },
+		{ 0x21, 0x17 }, // 0x16,
+		{ 0x22, 0x40 },
+		{ 0x2C, 0x03 },
+		{ 0x30, 0x44 },
+		{ 0x31, 0x75 }, // ??
+		{ 0x21, 0x16 }, // 0x03,
+	}
+}, {
+	{ /* cvbs 2 */
+		{ 0x06, 0x00 },
+		{ 0x20, 0x78 },
+		{ 0x21, 0x07 }, // 0x03,
+		{ 0x22, 0xD2 },
+		{ 0x2C, 0x83 },
+		{ 0x30, 0x60 },
+		{ 0x31, 0xB5 }, // ?
+		{ 0x21, 0x03 },
+	}
+}, {
+	{ /* cvbs 3 */
+		{ 0x06, 0x00 },
+		{ 0x20, 0xBA },
+		{ 0x21, 0x07 }, // 0x05,
+		{ 0x22, 0x91 },
+		{ 0x2C, 0x03 },
+		{ 0x30, 0x60 },
+		{ 0x31, 0xB5 }, // ??
+		{ 0x21, 0x05 }, // 0x03,
+	}
+}, {
+	{ /* cvbs 4 */
+		{ 0x06, 0x00 },
+		{ 0x20, 0xD8 },
+		{ 0x21, 0x17 }, // 0x16,
+		{ 0x22, 0x40 },
+		{ 0x2C, 0x03 },
+		{ 0x30, 0x44 },
+		{ 0x31, 0x75 }, // ??
+		{ 0x21, 0x16 }, // 0x03,
+	}
+}, {
+	{ /* cvbs 5 */
+		{ 0x06, 0x00 },
+		{ 0x20, 0xB8 },
+		{ 0x21, 0x07 }, // 0x05,
+		{ 0x22, 0x91 },
+		{ 0x2C, 0x03 },
+		{ 0x30, 0x60 },
+		{ 0x31, 0xB5 }, // ??
+		{ 0x21, 0x05 }, // 0x03,
+	}
+}, {
+	{ /* cvbs 6 */
+		{ 0x06, 0x00 },
+		{ 0x20, 0x7C },
+		{ 0x21, 0x07 }, // 0x03
+		{ 0x22, 0xD2 },
+		{ 0x2C, 0x83 },
+		{ 0x30, 0x60 },
+		{ 0x31, 0xB5 }, // ??
+		{ 0x21, 0x03 },
+	}
+}, {
+	{ /* y/c 1 */
+		{ 0x06, 0x80 },
+		{ 0x20, 0x59 },
+		{ 0x21, 0x17 },
+		{ 0x22, 0x42 },
+		{ 0x2C, 0xA3 },
+		{ 0x30, 0x44 },
+		{ 0x31, 0x75 },
+		{ 0x21, 0x12 },
+	}
+}, {
+	{ /* y/c 2 */
+		{ 0x06, 0x80 },
+		{ 0x20, 0x9A },
+		{ 0x21, 0x17 },
+		{ 0x22, 0xB1 },
+		{ 0x2C, 0x13 },
+		{ 0x30, 0x60 },
+		{ 0x31, 0xB5 },
+		{ 0x21, 0x14 },
+	}
+}, {
+	{ /* y/c 3 */
+		{ 0x06, 0x80 },
+		{ 0x20, 0x3C },
+		{ 0x21, 0x27 },
+		{ 0x22, 0xC1 },
+		{ 0x2C, 0x23 },
+		{ 0x30, 0x44 },
+		{ 0x31, 0x75 },
+		{ 0x21, 0x21 },
+	}
+}
+};
+
+static struct saa7146_standard hexium_standards[] = {
+	{
+		.name	= "PAL", 	.id	= V4L2_STD_PAL,
+		.v_offset	= 16,	.v_field 	= 288,
+		.h_offset	= 1,	.h_pixels 	= 680,
+		.v_max_out	= 576,	.h_max_out	= 768,
+	}, {
+		.name	= "NTSC", 	.id	= V4L2_STD_NTSC,
+		.v_offset	= 16,	.v_field 	= 240,
+		.h_offset	= 1,	.h_pixels 	= 640,
+		.v_max_out	= 480,	.h_max_out	= 640,
+	}, {
+		.name	= "SECAM", 	.id	= V4L2_STD_SECAM,
+		.v_offset	= 16,	.v_field 	= 288,
+		.h_offset	= 1,	.h_pixels 	= 720,
+		.v_max_out	= 576,	.h_max_out	= 768,
+	}
+};
+
+/* this is only called for old HV-PCI6/Orion cards
+   without eeprom */
+static int hexium_probe(struct saa7146_dev *dev)
+{
+	struct hexium *hexium = NULL;
+	union i2c_smbus_data data;
+	int err = 0;
+
+	DEB_EE("\n");
+
+	/* there are no hexium orion cards with revision 0 saa7146s */
+	if (0 == dev->revision) {
+		return -EFAULT;
+	}
+
+	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
+	if (NULL == hexium) {
+		pr_err("hexium_probe: not enough kernel memory\n");
+		return -ENOMEM;
+	}
+
+	/* enable i2c-port pins */
+	saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
+
+	saa7146_write(dev, DD1_INIT, 0x01000100);
+	saa7146_write(dev, DD1_STREAM_B, 0x00000000);
+	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
+
+	hexium->i2c_adapter = (struct i2c_adapter) {
+		.name = "hexium orion",
+	};
+	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
+	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
+		DEB_S("cannot register i2c-device. skipping.\n");
+		kfree(hexium);
+		return -EFAULT;
+	}
+
+	/* set SAA7110 control GPIO 0 */
+	saa7146_setgpio(dev, 0, SAA7146_GPIO_OUTHI);
+	/*  set HWControl GPIO number 2 */
+	saa7146_setgpio(dev, 2, SAA7146_GPIO_OUTHI);
+
+	mdelay(10);
+
+	/* detect newer Hexium Orion cards by subsystem ids */
+	if (0x17c8 == dev->pci->subsystem_vendor && 0x0101 == dev->pci->subsystem_device) {
+		pr_info("device is a Hexium Orion w/ 1 SVHS + 3 BNC inputs\n");
+		/* we store the pointer in our private data field */
+		dev->ext_priv = hexium;
+		hexium->type = HEXIUM_ORION_1SVHS_3BNC;
+		return 0;
+	}
+
+	if (0x17c8 == dev->pci->subsystem_vendor && 0x2101 == dev->pci->subsystem_device) {
+		pr_info("device is a Hexium Orion w/ 4 BNC inputs\n");
+		/* we store the pointer in our private data field */
+		dev->ext_priv = hexium;
+		hexium->type = HEXIUM_ORION_4BNC;
+		return 0;
+	}
+
+	/* check if this is an old hexium Orion card by looking at
+	   a saa7110 at address 0x4e */
+	if (0 == (err = i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_READ, 0x00, I2C_SMBUS_BYTE_DATA, &data))) {
+		pr_info("device is a Hexium HV-PCI6/Orion (old)\n");
+		/* we store the pointer in our private data field */
+		dev->ext_priv = hexium;
+		hexium->type = HEXIUM_HV_PCI6_ORION;
+		return 0;
+	}
+
+	i2c_del_adapter(&hexium->i2c_adapter);
+	kfree(hexium);
+	return -EFAULT;
+}
+
+/* bring hardware to a sane state. this has to be done, just in case someone
+   wants to capture from this device before it has been properly initialized.
+   the capture engine would badly fail, because no valid signal arrives on the
+   saa7146, thus leading to timeouts and stuff. */
+static int hexium_init_done(struct saa7146_dev *dev)
+{
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+	union i2c_smbus_data data;
+	int i = 0;
+
+	DEB_D("hexium_init_done called\n");
+
+	/* initialize the helper ics to useful values */
+	for (i = 0; i < sizeof(hexium_saa7110); i++) {
+		data.byte = hexium_saa7110[i];
+		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_WRITE, i, I2C_SMBUS_BYTE_DATA, &data)) {
+			pr_err("failed for address 0x%02x\n", i);
+		}
+	}
+
+	return 0;
+}
+
+static int hexium_set_input(struct hexium *hexium, int input)
+{
+	union i2c_smbus_data data;
+	int i = 0;
+
+	DEB_D("\n");
+
+	for (i = 0; i < 8; i++) {
+		int adr = hexium_input_select[input].data[i].adr;
+		data.byte = hexium_input_select[input].data[i].byte;
+		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_WRITE, adr, I2C_SMBUS_BYTE_DATA, &data)) {
+			return -1;
+		}
+		pr_debug("%d: 0x%02x => 0x%02x\n", input, adr, data.byte);
+	}
+
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+{
+	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
+
+	if (i->index >= HEXIUM_INPUTS)
+		return -EINVAL;
+
+	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
+
+	DEB_D("v4l2_ioctl: VIDIOC_ENUMINPUT %d\n", i->index);
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *fh, unsigned int *input)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	*input = hexium->cur_input;
+
+	DEB_D("VIDIOC_G_INPUT: %d\n", *input);
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	if (input >= HEXIUM_INPUTS)
+		return -EINVAL;
+
+	hexium->cur_input = input;
+	hexium_set_input(hexium, input);
+
+	return 0;
+}
+
+static struct saa7146_ext_vv vv_data;
+
+/* this function only gets called when the probing was successful */
+static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
+{
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	DEB_EE("\n");
+
+	saa7146_vv_init(dev, &vv_data);
+	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
+	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
+	if (0 != saa7146_register_device(&hexium->video_dev, dev, "hexium orion", VFL_TYPE_GRABBER)) {
+		pr_err("cannot register capture v4l2 device. skipping.\n");
+		return -1;
+	}
+
+	pr_err("found 'hexium orion' frame grabber-%d\n", hexium_num);
+	hexium_num++;
+
+	/* the rest */
+	hexium->cur_input = 0;
+	hexium_init_done(dev);
+
+	return 0;
+}
+
+static int hexium_detach(struct saa7146_dev *dev)
+{
+	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+
+	DEB_EE("dev:%p\n", dev);
+
+	saa7146_unregister_device(&hexium->video_dev, dev);
+	saa7146_vv_release(dev);
+
+	hexium_num--;
+
+	i2c_del_adapter(&hexium->i2c_adapter);
+	kfree(hexium);
+	return 0;
+}
+
+static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *std)
+{
+	return 0;
+}
+
+static struct saa7146_extension extension;
+
+static struct saa7146_pci_extension_data hexium_hv_pci6 = {
+	.ext_priv = "Hexium HV-PCI6 / Orion",
+	.ext = &extension,
+};
+
+static struct saa7146_pci_extension_data hexium_orion_1svhs_3bnc = {
+	.ext_priv = "Hexium HV-PCI6 / Orion (1 SVHS/3 BNC)",
+	.ext = &extension,
+};
+
+static struct saa7146_pci_extension_data hexium_orion_4bnc = {
+	.ext_priv = "Hexium HV-PCI6 / Orion (4 BNC)",
+	.ext = &extension,
+};
+
+static struct pci_device_id pci_tbl[] = {
+	{
+	 .vendor = PCI_VENDOR_ID_PHILIPS,
+	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
+	 .subvendor = 0x0000,
+	 .subdevice = 0x0000,
+	 .driver_data = (unsigned long) &hexium_hv_pci6,
+	 },
+	{
+	 .vendor = PCI_VENDOR_ID_PHILIPS,
+	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
+	 .subvendor = 0x17c8,
+	 .subdevice = 0x0101,
+	 .driver_data = (unsigned long) &hexium_orion_1svhs_3bnc,
+	 },
+	{
+	 .vendor = PCI_VENDOR_ID_PHILIPS,
+	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
+	 .subvendor = 0x17c8,
+	 .subdevice = 0x2101,
+	 .driver_data = (unsigned long) &hexium_orion_4bnc,
+	 },
+	{
+	 .vendor = 0,
+	 }
+};
+
+MODULE_DEVICE_TABLE(pci, pci_tbl);
+
+static struct saa7146_ext_vv vv_data = {
+	.inputs = HEXIUM_INPUTS,
+	.capabilities = 0,
+	.stds = &hexium_standards[0],
+	.num_stds = sizeof(hexium_standards) / sizeof(struct saa7146_standard),
+	.std_callback = &std_callback,
+};
+
+static struct saa7146_extension extension = {
+	.name = "hexium HV-PCI6 Orion",
+	.flags = 0,		// SAA7146_USE_I2C_IRQ,
+
+	.pci_tbl = &pci_tbl[0],
+	.module = THIS_MODULE,
+
+	.probe = hexium_probe,
+	.attach = hexium_attach,
+	.detach = hexium_detach,
+
+	.irq_mask = 0,
+	.irq_func = NULL,
+};
+
+static int __init hexium_init_module(void)
+{
+	if (0 != saa7146_register_extension(&extension)) {
+		DEB_S("failed to register extension\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __exit hexium_cleanup_module(void)
+{
+	saa7146_unregister_extension(&extension);
+}
+
+module_init(hexium_init_module);
+module_exit(hexium_cleanup_module);
+
+MODULE_DESCRIPTION("video4linux-2 driver for Hexium Orion frame grabber cards");
+MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
new file mode 100644
index 0000000..b520a45
--- /dev/null
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -0,0 +1,886 @@
+/*
+    mxb - v4l2 driver for the Multimedia eXtension Board
+
+    Copyright (C) 1998-2006 Michael Hunold <michael@mihu.de>
+
+    Visit http://www.themm.net/~mihu/linux/saa7146/mxb.html 
+    for further details about this card.
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define DEBUG_VARIABLE debug
+
+#include <media/saa7146_vv.h>
+#include <media/tuner.h>
+#include <media/v4l2-common.h>
+#include <media/saa7115.h>
+#include <linux/module.h>
+
+#include "tea6415c.h"
+#include "tea6420.h"
+
+#define MXB_AUDIOS	6
+
+#define I2C_SAA7111A  0x24
+#define	I2C_TDA9840   0x42
+#define	I2C_TEA6415C  0x43
+#define	I2C_TEA6420_1 0x4c
+#define	I2C_TEA6420_2 0x4d
+#define	I2C_TUNER     0x60
+
+#define MXB_BOARD_CAN_DO_VBI(dev)   (dev->revision != 0)
+
+/* global variable */
+static int mxb_num;
+
+/* initial frequence the tuner will be tuned to.
+   in verden (lower saxony, germany) 4148 is a
+   channel called "phoenix" */
+static int freq = 4148;
+module_param(freq, int, 0644);
+MODULE_PARM_DESC(freq, "initial frequency the tuner will be tuned to while setup");
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
+
+#define MXB_INPUTS 4
+enum { TUNER, AUX1, AUX3, AUX3_YC };
+
+static struct v4l2_input mxb_inputs[MXB_INPUTS] = {
+	{ TUNER,   "Tuner",          V4L2_INPUT_TYPE_TUNER,  0x3f, 0,
+		V4L2_STD_PAL_BG | V4L2_STD_PAL_I, 0, V4L2_IN_CAP_STD },
+	{ AUX1,	   "AUX1",           V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
+		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ AUX3,	   "AUX3 Composite", V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
+		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ AUX3_YC, "AUX3 S-Video",   V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
+		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+};
+
+/* this array holds the information, which port of the saa7146 each
+   input actually uses. the mxb uses port 0 for every input */
+static struct {
+	int hps_source;
+	int hps_sync;
+} input_port_selection[MXB_INPUTS] = {
+	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
+	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
+	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
+	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
+};
+
+/* this array holds the information of the audio source (mxb_audios),
+   which has to be switched corresponding to the video source (mxb_channels) */
+static int video_audio_connect[MXB_INPUTS] =
+	{ 0, 1, 3, 3 };
+
+struct mxb_routing {
+	u32 input;
+	u32 output;
+};
+
+/* these are the available audio sources, which can switched
+   to the line- and cd-output individually */
+static struct v4l2_audio mxb_audios[MXB_AUDIOS] = {
+	    {
+		.index	= 0,
+		.name	= "Tuner",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 1,
+		.name	= "AUX1",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 2,
+		.name	= "AUX2",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 3,
+		.name	= "AUX3",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 4,
+		.name	= "Radio (X9)",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 5,
+		.name	= "CD-ROM (X10)",
+		.capability = V4L2_AUDCAP_STEREO,
+	}
+};
+
+/* These are the necessary input-output-pins for bringing one audio source
+   (see above) to the CD-output. Note that gain is set to 0 in this table. */
+static struct mxb_routing TEA6420_cd[MXB_AUDIOS + 1][2] = {
+	{ { 1, 1 }, { 1, 1 } },	/* Tuner */
+	{ { 5, 1 }, { 6, 1 } },	/* AUX 1 */
+	{ { 4, 1 }, { 6, 1 } },	/* AUX 2 */
+	{ { 3, 1 }, { 6, 1 } },	/* AUX 3 */
+	{ { 1, 1 }, { 3, 1 } },	/* Radio */
+	{ { 1, 1 }, { 2, 1 } },	/* CD-Rom */
+	{ { 6, 1 }, { 6, 1 } }	/* Mute */
+};
+
+/* These are the necessary input-output-pins for bringing one audio source
+   (see above) to the line-output. Note that gain is set to 0 in this table. */
+static struct mxb_routing TEA6420_line[MXB_AUDIOS + 1][2] = {
+	{ { 2, 3 }, { 1, 2 } },
+	{ { 5, 3 }, { 6, 2 } },
+	{ { 4, 3 }, { 6, 2 } },
+	{ { 3, 3 }, { 6, 2 } },
+	{ { 2, 3 }, { 3, 2 } },
+	{ { 2, 3 }, { 2, 2 } },
+	{ { 6, 3 }, { 6, 2 } }	/* Mute */
+};
+
+struct mxb
+{
+	struct video_device	*video_dev;
+	struct video_device	*vbi_dev;
+
+	struct i2c_adapter	i2c_adapter;
+
+	struct v4l2_subdev	*saa7111a;
+	struct v4l2_subdev	*tda9840;
+	struct v4l2_subdev	*tea6415c;
+	struct v4l2_subdev	*tuner;
+	struct v4l2_subdev	*tea6420_1;
+	struct v4l2_subdev	*tea6420_2;
+
+	int	cur_mode;	/* current audio mode (mono, stereo, ...) */
+	int	cur_input;	/* current input */
+	int	cur_audinput;	/* current audio input */
+	int	cur_mute;	/* current mute status */
+	struct v4l2_frequency	cur_freq;	/* current frequency the tuner is tuned to */
+};
+
+#define saa7111a_call(mxb, o, f, args...) \
+	v4l2_subdev_call(mxb->saa7111a, o, f, ##args)
+#define tda9840_call(mxb, o, f, args...) \
+	v4l2_subdev_call(mxb->tda9840, o, f, ##args)
+#define tea6415c_call(mxb, o, f, args...) \
+	v4l2_subdev_call(mxb->tea6415c, o, f, ##args)
+#define tuner_call(mxb, o, f, args...) \
+	v4l2_subdev_call(mxb->tuner, o, f, ##args)
+#define call_all(dev, o, f, args...) \
+	v4l2_device_call_until_err(&dev->v4l2_dev, 0, o, f, ##args)
+
+static void mxb_update_audmode(struct mxb *mxb)
+{
+	struct v4l2_tuner t = {
+		.audmode = mxb->cur_mode,
+	};
+
+	tda9840_call(mxb, tuner, s_tuner, &t);
+}
+
+static inline void tea6420_route(struct mxb *mxb, int idx)
+{
+	v4l2_subdev_call(mxb->tea6420_1, audio, s_routing,
+		TEA6420_cd[idx][0].input, TEA6420_cd[idx][0].output, 0);
+	v4l2_subdev_call(mxb->tea6420_2, audio, s_routing,
+		TEA6420_cd[idx][1].input, TEA6420_cd[idx][1].output, 0);
+	v4l2_subdev_call(mxb->tea6420_1, audio, s_routing,
+		TEA6420_line[idx][0].input, TEA6420_line[idx][0].output, 0);
+	v4l2_subdev_call(mxb->tea6420_2, audio, s_routing,
+		TEA6420_line[idx][1].input, TEA6420_line[idx][1].output, 0);
+}
+
+static struct saa7146_extension extension;
+
+static int mxb_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct saa7146_dev *dev = container_of(ctrl->handler,
+				struct saa7146_dev, ctrl_handler);
+	struct mxb *mxb = dev->ext_priv;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		mxb->cur_mute = ctrl->val;
+		/* switch the audio-source */
+		tea6420_route(mxb, ctrl->val ? 6 :
+				video_audio_connect[mxb->cur_input]);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops mxb_ctrl_ops = {
+	.s_ctrl = mxb_s_ctrl,
+};
+
+static int mxb_probe(struct saa7146_dev *dev)
+{
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+	struct mxb *mxb = NULL;
+
+	v4l2_ctrl_new_std(hdl, &mxb_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	if (hdl->error)
+		return hdl->error;
+	mxb = kzalloc(sizeof(struct mxb), GFP_KERNEL);
+	if (mxb == NULL) {
+		DEB_D("not enough kernel memory\n");
+		return -ENOMEM;
+	}
+
+
+	snprintf(mxb->i2c_adapter.name, sizeof(mxb->i2c_adapter.name), "mxb%d", mxb_num);
+
+	saa7146_i2c_adapter_prepare(dev, &mxb->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
+	if (i2c_add_adapter(&mxb->i2c_adapter) < 0) {
+		DEB_S("cannot register i2c-device. skipping.\n");
+		kfree(mxb);
+		return -EFAULT;
+	}
+
+	mxb->saa7111a = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
+			"saa7111", I2C_SAA7111A, NULL);
+	mxb->tea6420_1 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
+			"tea6420", I2C_TEA6420_1, NULL);
+	mxb->tea6420_2 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
+			"tea6420", I2C_TEA6420_2, NULL);
+	mxb->tea6415c = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
+			"tea6415c", I2C_TEA6415C, NULL);
+	mxb->tda9840 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
+			"tda9840", I2C_TDA9840, NULL);
+	mxb->tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
+			"tuner", I2C_TUNER, NULL);
+
+	/* check if all devices are present */
+	if (!mxb->tea6420_1 || !mxb->tea6420_2 || !mxb->tea6415c ||
+	    !mxb->tda9840 || !mxb->saa7111a || !mxb->tuner) {
+		pr_err("did not find all i2c devices. aborting\n");
+		i2c_del_adapter(&mxb->i2c_adapter);
+		kfree(mxb);
+		return -ENODEV;
+	}
+
+	/* all devices are present, probe was successful */
+
+	/* we store the pointer in our private data field */
+	dev->ext_priv = mxb;
+
+	v4l2_ctrl_handler_setup(hdl);
+
+	return 0;
+}
+
+/* some init data for the saa7740, the so-called 'sound arena module'.
+   there are no specs available, so we simply use some init values */
+static struct {
+	int	length;
+	char	data[9];
+} mxb_saa7740_init[] = {
+	{ 3, { 0x80, 0x00, 0x00 } },{ 3, { 0x80, 0x89, 0x00 } },
+	{ 3, { 0x80, 0xb0, 0x0a } },{ 3, { 0x00, 0x00, 0x00 } },
+	{ 3, { 0x49, 0x00, 0x00 } },{ 3, { 0x4a, 0x00, 0x00 } },
+	{ 3, { 0x4b, 0x00, 0x00 } },{ 3, { 0x4c, 0x00, 0x00 } },
+	{ 3, { 0x4d, 0x00, 0x00 } },{ 3, { 0x4e, 0x00, 0x00 } },
+	{ 3, { 0x4f, 0x00, 0x00 } },{ 3, { 0x50, 0x00, 0x00 } },
+	{ 3, { 0x51, 0x00, 0x00 } },{ 3, { 0x52, 0x00, 0x00 } },
+	{ 3, { 0x53, 0x00, 0x00 } },{ 3, { 0x54, 0x00, 0x00 } },
+	{ 3, { 0x55, 0x00, 0x00 } },{ 3, { 0x56, 0x00, 0x00 } },
+	{ 3, { 0x57, 0x00, 0x00 } },{ 3, { 0x58, 0x00, 0x00 } },
+	{ 3, { 0x59, 0x00, 0x00 } },{ 3, { 0x5a, 0x00, 0x00 } },
+	{ 3, { 0x5b, 0x00, 0x00 } },{ 3, { 0x5c, 0x00, 0x00 } },
+	{ 3, { 0x5d, 0x00, 0x00 } },{ 3, { 0x5e, 0x00, 0x00 } },
+	{ 3, { 0x5f, 0x00, 0x00 } },{ 3, { 0x60, 0x00, 0x00 } },
+	{ 3, { 0x61, 0x00, 0x00 } },{ 3, { 0x62, 0x00, 0x00 } },
+	{ 3, { 0x63, 0x00, 0x00 } },{ 3, { 0x64, 0x00, 0x00 } },
+	{ 3, { 0x65, 0x00, 0x00 } },{ 3, { 0x66, 0x00, 0x00 } },
+	{ 3, { 0x67, 0x00, 0x00 } },{ 3, { 0x68, 0x00, 0x00 } },
+	{ 3, { 0x69, 0x00, 0x00 } },{ 3, { 0x6a, 0x00, 0x00 } },
+	{ 3, { 0x6b, 0x00, 0x00 } },{ 3, { 0x6c, 0x00, 0x00 } },
+	{ 3, { 0x6d, 0x00, 0x00 } },{ 3, { 0x6e, 0x00, 0x00 } },
+	{ 3, { 0x6f, 0x00, 0x00 } },{ 3, { 0x70, 0x00, 0x00 } },
+	{ 3, { 0x71, 0x00, 0x00 } },{ 3, { 0x72, 0x00, 0x00 } },
+	{ 3, { 0x73, 0x00, 0x00 } },{ 3, { 0x74, 0x00, 0x00 } },
+	{ 3, { 0x75, 0x00, 0x00 } },{ 3, { 0x76, 0x00, 0x00 } },
+	{ 3, { 0x77, 0x00, 0x00 } },{ 3, { 0x41, 0x00, 0x42 } },
+	{ 3, { 0x42, 0x10, 0x42 } },{ 3, { 0x43, 0x20, 0x42 } },
+	{ 3, { 0x44, 0x30, 0x42 } },{ 3, { 0x45, 0x00, 0x01 } },
+	{ 3, { 0x46, 0x00, 0x01 } },{ 3, { 0x47, 0x00, 0x01 } },
+	{ 3, { 0x48, 0x00, 0x01 } },
+	{ 9, { 0x01, 0x03, 0xc5, 0x5c, 0x7a, 0x85, 0x01, 0x00, 0x54 } },
+	{ 9, { 0x21, 0x03, 0xc5, 0x5c, 0x7a, 0x85, 0x01, 0x00, 0x54 } },
+	{ 9, { 0x09, 0x0b, 0xb4, 0x6b, 0x74, 0x85, 0x95, 0x00, 0x34 } },
+	{ 9, { 0x29, 0x0b, 0xb4, 0x6b, 0x74, 0x85, 0x95, 0x00, 0x34 } },
+	{ 9, { 0x11, 0x17, 0x43, 0x62, 0x68, 0x89, 0xd1, 0xff, 0xb0 } },
+	{ 9, { 0x31, 0x17, 0x43, 0x62, 0x68, 0x89, 0xd1, 0xff, 0xb0 } },
+	{ 9, { 0x19, 0x20, 0x62, 0x51, 0x5a, 0x95, 0x19, 0x01, 0x50 } },
+	{ 9, { 0x39, 0x20, 0x62, 0x51, 0x5a, 0x95, 0x19, 0x01, 0x50 } },
+	{ 9, { 0x05, 0x3e, 0xd2, 0x69, 0x4e, 0x9a, 0x51, 0x00, 0xf0 } },
+	{ 9, { 0x25, 0x3e, 0xd2, 0x69, 0x4e, 0x9a, 0x51, 0x00, 0xf0 } },
+	{ 9, { 0x0d, 0x3d, 0xa1, 0x40, 0x7d, 0x9f, 0x29, 0xfe, 0x14 } },
+	{ 9, { 0x2d, 0x3d, 0xa1, 0x40, 0x7d, 0x9f, 0x29, 0xfe, 0x14 } },
+	{ 9, { 0x15, 0x73, 0xa1, 0x50, 0x5d, 0xa6, 0xf5, 0xfe, 0x38 } },
+	{ 9, { 0x35, 0x73, 0xa1, 0x50, 0x5d, 0xa6, 0xf5, 0xfe, 0x38 } },
+	{ 9, { 0x1d, 0xed, 0xd0, 0x68, 0x29, 0xb4, 0xe1, 0x00, 0xb8 } },
+	{ 9, { 0x3d, 0xed, 0xd0, 0x68, 0x29, 0xb4, 0xe1, 0x00, 0xb8 } },
+	{ 3, { 0x80, 0xb3, 0x0a } },
+	{-1, { 0 } }
+};
+
+/* bring hardware to a sane state. this has to be done, just in case someone
+   wants to capture from this device before it has been properly initialized.
+   the capture engine would badly fail, because no valid signal arrives on the
+   saa7146, thus leading to timeouts and stuff. */
+static int mxb_init_done(struct saa7146_dev* dev)
+{
+	struct mxb* mxb = (struct mxb*)dev->ext_priv;
+	struct i2c_msg msg;
+	struct tuner_setup tun_setup;
+	v4l2_std_id std = V4L2_STD_PAL_BG;
+
+	int i = 0, err = 0;
+
+	/* mute audio on tea6420s */
+	tea6420_route(mxb, 6);
+
+	/* select video mode in saa7111a */
+	saa7111a_call(mxb, core, s_std, std);
+
+	/* select tuner-output on saa7111a */
+	i = 0;
+	saa7111a_call(mxb, video, s_routing, SAA7115_COMPOSITE0,
+		SAA7111_FMT_CCIR, 0);
+
+	/* select a tuner type */
+	tun_setup.mode_mask = T_ANALOG_TV;
+	tun_setup.addr = ADDR_UNSET;
+	tun_setup.type = TUNER_PHILIPS_PAL;
+	tuner_call(mxb, tuner, s_type_addr, &tun_setup);
+	/* tune in some frequency on tuner */
+	mxb->cur_freq.tuner = 0;
+	mxb->cur_freq.type = V4L2_TUNER_ANALOG_TV;
+	mxb->cur_freq.frequency = freq;
+	tuner_call(mxb, tuner, s_frequency, &mxb->cur_freq);
+
+	/* set a default video standard */
+	/* These two gpio calls set the GPIO pins that control the tda9820 */
+	saa7146_write(dev, GPIO_CTRL, 0x00404050);
+	saa7111a_call(mxb, core, s_gpio, 1);
+	saa7111a_call(mxb, core, s_std, std);
+	tuner_call(mxb, core, s_std, std);
+
+	/* switch to tuner-channel on tea6415c */
+	tea6415c_call(mxb, video, s_routing, 3, 17, 0);
+
+	/* select tuner-output on multicable on tea6415c */
+	tea6415c_call(mxb, video, s_routing, 3, 13, 0);
+
+	/* the rest for mxb */
+	mxb->cur_input = 0;
+	mxb->cur_audinput = video_audio_connect[mxb->cur_input];
+	mxb->cur_mute = 1;
+
+	mxb->cur_mode = V4L2_TUNER_MODE_STEREO;
+	mxb_update_audmode(mxb);
+
+	/* check if the saa7740 (aka 'sound arena module') is present
+	   on the mxb. if so, we must initialize it. due to lack of
+	   informations about the saa7740, the values were reverse
+	   engineered. */
+	msg.addr = 0x1b;
+	msg.flags = 0;
+	msg.len = mxb_saa7740_init[0].length;
+	msg.buf = &mxb_saa7740_init[0].data[0];
+
+	err = i2c_transfer(&mxb->i2c_adapter, &msg, 1);
+	if (err == 1) {
+		/* the sound arena module is a pos, that's probably the reason
+		   philips refuses to hand out a datasheet for the saa7740...
+		   it seems to screw up the i2c bus, so we disable fast irq
+		   based i2c transactions here and rely on the slow and safe
+		   polling method ... */
+		extension.flags &= ~SAA7146_USE_I2C_IRQ;
+		for (i = 1; ; i++) {
+			if (-1 == mxb_saa7740_init[i].length)
+				break;
+
+			msg.len = mxb_saa7740_init[i].length;
+			msg.buf = &mxb_saa7740_init[i].data[0];
+			err = i2c_transfer(&mxb->i2c_adapter, &msg, 1);
+			if (err != 1) {
+				DEB_D("failed to initialize 'sound arena module'\n");
+				goto err;
+			}
+		}
+		pr_info("'sound arena module' detected\n");
+	}
+err:
+	/* the rest for saa7146: you should definitely set some basic values
+	   for the input-port handling of the saa7146. */
+
+	/* ext->saa has been filled by the core driver */
+
+	/* some stuff is done via variables */
+	saa7146_set_hps_source_and_sync(dev, input_port_selection[mxb->cur_input].hps_source,
+			input_port_selection[mxb->cur_input].hps_sync);
+
+	/* some stuff is done via direct write to the registers */
+
+	/* this is ugly, but because of the fact that this is completely
+	   hardware dependend, it should be done directly... */
+	saa7146_write(dev, DD1_STREAM_B,	0x00000000);
+	saa7146_write(dev, DD1_INIT,		0x02000200);
+	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
+
+	return 0;
+}
+
+/* interrupt-handler. this gets called when irq_mask is != 0.
+   it must clear the interrupt-bits in irq_mask it has handled */
+/*
+void mxb_irq_bh(struct saa7146_dev* dev, u32* irq_mask)
+{
+	struct mxb* mxb = (struct mxb*)dev->ext_priv;
+}
+*/
+
+static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+{
+	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
+	if (i->index >= MXB_INPUTS)
+		return -EINVAL;
+	memcpy(i, &mxb_inputs[i->index], sizeof(struct v4l2_input));
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+	*i = mxb->cur_input;
+
+	DEB_EE("VIDIOC_G_INPUT %d\n", *i);
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+	int err = 0;
+	int i = 0;
+
+	DEB_EE("VIDIOC_S_INPUT %d\n", input);
+
+	if (input >= MXB_INPUTS)
+		return -EINVAL;
+
+	mxb->cur_input = input;
+
+	saa7146_set_hps_source_and_sync(dev, input_port_selection[input].hps_source,
+			input_port_selection[input].hps_sync);
+
+	/* prepare switching of tea6415c and saa7111a;
+	   have a look at the 'background'-file for further informations  */
+	switch (input) {
+	case TUNER:
+		i = SAA7115_COMPOSITE0;
+
+		err = tea6415c_call(mxb, video, s_routing, 3, 17, 0);
+
+		/* connect tuner-output always to multicable */
+		if (!err)
+			err = tea6415c_call(mxb, video, s_routing, 3, 13, 0);
+		break;
+	case AUX3_YC:
+		/* nothing to be done here. aux3_yc is
+		   directly connected to the saa711a */
+		i = SAA7115_SVIDEO1;
+		break;
+	case AUX3:
+		/* nothing to be done here. aux3 is
+		   directly connected to the saa711a */
+		i = SAA7115_COMPOSITE1;
+		break;
+	case AUX1:
+		i = SAA7115_COMPOSITE0;
+		err = tea6415c_call(mxb, video, s_routing, 1, 17, 0);
+		break;
+	}
+
+	if (err)
+		return err;
+
+	/* switch video in saa7111a */
+	if (saa7111a_call(mxb, video, s_routing, i, SAA7111_FMT_CCIR, 0))
+		pr_err("VIDIOC_S_INPUT: could not address saa7111a\n");
+
+	mxb->cur_audinput = video_audio_connect[input];
+	/* switch the audio-source only if necessary */
+	if (0 == mxb->cur_mute)
+		tea6420_route(mxb, mxb->cur_audinput);
+	if (mxb->cur_audinput == 0)
+		mxb_update_audmode(mxb);
+
+	return 0;
+}
+
+static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
+	if (t->index) {
+		DEB_D("VIDIOC_G_TUNER: channel %d does not have a tuner attached\n",
+		      t->index);
+		return -EINVAL;
+	}
+
+	DEB_EE("VIDIOC_G_TUNER: %d\n", t->index);
+
+	memset(t, 0, sizeof(*t));
+	strlcpy(t->name, "TV Tuner", sizeof(t->name));
+	t->type = V4L2_TUNER_ANALOG_TV;
+	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO |
+			V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
+	t->audmode = mxb->cur_mode;
+	return call_all(dev, tuner, g_tuner, t);
+}
+
+static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
+	if (t->index) {
+		DEB_D("VIDIOC_S_TUNER: channel %d does not have a tuner attached\n",
+		      t->index);
+		return -EINVAL;
+	}
+
+	mxb->cur_mode = t->audmode;
+	return call_all(dev, tuner, s_tuner, t);
+}
+
+static int vidioc_querystd(struct file *file, void *fh, v4l2_std_id *norm)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+
+	return call_all(dev, video, querystd, norm);
+}
+
+static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency *f)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
+	if (f->tuner)
+		return -EINVAL;
+	*f = mxb->cur_freq;
+
+	DEB_EE("VIDIOC_G_FREQ: freq:0x%08x\n", mxb->cur_freq.frequency);
+	return 0;
+}
+
+static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency *f)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+	struct saa7146_vv *vv = dev->vv_data;
+
+	if (f->tuner)
+		return -EINVAL;
+
+	if (V4L2_TUNER_ANALOG_TV != f->type)
+		return -EINVAL;
+
+	DEB_EE("VIDIOC_S_FREQUENCY: freq:0x%08x\n", mxb->cur_freq.frequency);
+
+	/* tune in desired frequency */
+	tuner_call(mxb, tuner, s_frequency, f);
+	/* let the tuner subdev clamp the frequency to the tuner range */
+	tuner_call(mxb, tuner, g_frequency, f);
+	mxb->cur_freq = *f;
+	if (mxb->cur_audinput == 0)
+		mxb_update_audmode(mxb);
+
+	if (mxb->cur_input)
+		return 0;
+
+	/* hack: changing the frequency should invalidate the vbi-counter (=> alevt) */
+	spin_lock(&dev->slock);
+	vv->vbi_fieldcount = 0;
+	spin_unlock(&dev->slock);
+
+	return 0;
+}
+
+static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	if (a->index >= MXB_AUDIOS)
+		return -EINVAL;
+	*a = mxb_audios[a->index];
+	return 0;
+}
+
+static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
+	DEB_EE("VIDIOC_G_AUDIO\n");
+	*a = mxb_audios[mxb->cur_audinput];
+	return 0;
+}
+
+static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
+	DEB_D("VIDIOC_S_AUDIO %d\n", a->index);
+	if (mxb_inputs[mxb->cur_input].audioset & (1 << a->index)) {
+		if (mxb->cur_audinput != a->index) {
+			mxb->cur_audinput = a->index;
+			tea6420_route(mxb, a->index);
+			if (mxb->cur_audinput == 0)
+				mxb_update_audmode(mxb);
+		}
+		return 0;
+	}
+	return -EINVAL;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int vidioc_g_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (v4l2_chip_match_host(&reg->match)) {
+		reg->val = saa7146_read(dev, reg->reg);
+		reg->size = 4;
+		return 0;
+	}
+	call_all(dev, core, g_register, reg);
+	return 0;
+}
+
+static int vidioc_s_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (v4l2_chip_match_host(&reg->match)) {
+		saa7146_write(dev, reg->reg, reg->val);
+		reg->size = 4;
+		return 0;
+	}
+	return call_all(dev, core, s_register, reg);
+}
+#endif
+
+static struct saa7146_ext_vv vv_data;
+
+/* this function only gets called when the probing was successful */
+static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
+{
+	struct mxb *mxb;
+
+	DEB_EE("dev:%p\n", dev);
+
+	saa7146_vv_init(dev, &vv_data);
+	if (mxb_probe(dev)) {
+		saa7146_vv_release(dev);
+		return -1;
+	}
+	mxb = (struct mxb *)dev->ext_priv;
+
+	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
+	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
+	vv_data.vid_ops.vidioc_querystd = vidioc_querystd;
+	vv_data.vid_ops.vidioc_g_tuner = vidioc_g_tuner;
+	vv_data.vid_ops.vidioc_s_tuner = vidioc_s_tuner;
+	vv_data.vid_ops.vidioc_g_frequency = vidioc_g_frequency;
+	vv_data.vid_ops.vidioc_s_frequency = vidioc_s_frequency;
+	vv_data.vid_ops.vidioc_enumaudio = vidioc_enumaudio;
+	vv_data.vid_ops.vidioc_g_audio = vidioc_g_audio;
+	vv_data.vid_ops.vidioc_s_audio = vidioc_s_audio;
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	vv_data.vid_ops.vidioc_g_register = vidioc_g_register;
+	vv_data.vid_ops.vidioc_s_register = vidioc_s_register;
+#endif
+	if (saa7146_register_device(&mxb->video_dev, dev, "mxb", VFL_TYPE_GRABBER)) {
+		ERR("cannot register capture v4l2 device. skipping.\n");
+		saa7146_vv_release(dev);
+		return -1;
+	}
+
+	/* initialization stuff (vbi) (only for revision > 0 and for extensions which want it)*/
+	if (MXB_BOARD_CAN_DO_VBI(dev)) {
+		if (saa7146_register_device(&mxb->vbi_dev, dev, "mxb", VFL_TYPE_VBI)) {
+			ERR("cannot register vbi v4l2 device. skipping.\n");
+		}
+	}
+
+	pr_info("found Multimedia eXtension Board #%d\n", mxb_num);
+
+	mxb_num++;
+	mxb_init_done(dev);
+	return 0;
+}
+
+static int mxb_detach(struct saa7146_dev *dev)
+{
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
+	DEB_EE("dev:%p\n", dev);
+
+	/* mute audio on tea6420s */
+	tea6420_route(mxb, 6);
+
+	saa7146_unregister_device(&mxb->video_dev,dev);
+	if (MXB_BOARD_CAN_DO_VBI(dev))
+		saa7146_unregister_device(&mxb->vbi_dev, dev);
+	saa7146_vv_release(dev);
+
+	mxb_num--;
+
+	i2c_del_adapter(&mxb->i2c_adapter);
+	kfree(mxb);
+
+	return 0;
+}
+
+static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *standard)
+{
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
+	if (V4L2_STD_PAL_I == standard->id) {
+		v4l2_std_id std = V4L2_STD_PAL_I;
+
+		DEB_D("VIDIOC_S_STD: setting mxb for PAL_I\n");
+		/* These two gpio calls set the GPIO pins that control the tda9820 */
+		saa7146_write(dev, GPIO_CTRL, 0x00404050);
+		saa7111a_call(mxb, core, s_gpio, 0);
+		saa7111a_call(mxb, core, s_std, std);
+		if (mxb->cur_input == 0)
+			tuner_call(mxb, core, s_std, std);
+	} else {
+		v4l2_std_id std = V4L2_STD_PAL_BG;
+
+		if (mxb->cur_input)
+			std = standard->id;
+		DEB_D("VIDIOC_S_STD: setting mxb for PAL/NTSC/SECAM\n");
+		/* These two gpio calls set the GPIO pins that control the tda9820 */
+		saa7146_write(dev, GPIO_CTRL, 0x00404050);
+		saa7111a_call(mxb, core, s_gpio, 1);
+		saa7111a_call(mxb, core, s_std, std);
+		if (mxb->cur_input == 0)
+			tuner_call(mxb, core, s_std, std);
+	}
+	return 0;
+}
+
+static struct saa7146_standard standard[] = {
+	{
+		.name	= "PAL-BG", 	.id	= V4L2_STD_PAL_BG,
+		.v_offset	= 0x17,	.v_field 	= 288,
+		.h_offset	= 0x14,	.h_pixels 	= 680,
+		.v_max_out	= 576,	.h_max_out	= 768,
+	}, {
+		.name	= "PAL-I", 	.id	= V4L2_STD_PAL_I,
+		.v_offset	= 0x17,	.v_field 	= 288,
+		.h_offset	= 0x14,	.h_pixels 	= 680,
+		.v_max_out	= 576,	.h_max_out	= 768,
+	}, {
+		.name	= "NTSC", 	.id	= V4L2_STD_NTSC,
+		.v_offset	= 0x16,	.v_field 	= 240,
+		.h_offset	= 0x06,	.h_pixels 	= 708,
+		.v_max_out	= 480,	.h_max_out	= 640,
+	}, {
+		.name	= "SECAM", 	.id	= V4L2_STD_SECAM,
+		.v_offset	= 0x14,	.v_field 	= 288,
+		.h_offset	= 0x14,	.h_pixels 	= 720,
+		.v_max_out	= 576,	.h_max_out	= 768,
+	}
+};
+
+static struct saa7146_pci_extension_data mxb = {
+	.ext_priv = "Multimedia eXtension Board",
+	.ext = &extension,
+};
+
+static struct pci_device_id pci_tbl[] = {
+	{
+		.vendor    = PCI_VENDOR_ID_PHILIPS,
+		.device	   = PCI_DEVICE_ID_PHILIPS_SAA7146,
+		.subvendor = 0x0000,
+		.subdevice = 0x0000,
+		.driver_data = (unsigned long)&mxb,
+	}, {
+		.vendor	= 0,
+	}
+};
+
+MODULE_DEVICE_TABLE(pci, pci_tbl);
+
+static struct saa7146_ext_vv vv_data = {
+	.inputs		= MXB_INPUTS,
+	.capabilities	= V4L2_CAP_TUNER | V4L2_CAP_VBI_CAPTURE | V4L2_CAP_AUDIO,
+	.stds		= &standard[0],
+	.num_stds	= sizeof(standard)/sizeof(struct saa7146_standard),
+	.std_callback	= &std_callback,
+};
+
+static struct saa7146_extension extension = {
+	.name		= "Multimedia eXtension Board",
+	.flags		= SAA7146_USE_I2C_IRQ,
+
+	.pci_tbl	= &pci_tbl[0],
+	.module		= THIS_MODULE,
+
+	.attach		= mxb_attach,
+	.detach		= mxb_detach,
+
+	.irq_mask	= 0,
+	.irq_func	= NULL,
+};
+
+static int __init mxb_init_module(void)
+{
+	if (saa7146_register_extension(&extension)) {
+		DEB_S("failed to register extension\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __exit mxb_cleanup_module(void)
+{
+	saa7146_unregister_extension(&extension);
+}
+
+module_init(mxb_init_module);
+module_exit(mxb_cleanup_module);
+
+MODULE_DESCRIPTION("video4linux-2 driver for the Siemens-Nixdorf 'Multimedia eXtension board'");
+MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index a837194..4d79dfd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -619,29 +619,6 @@ menuconfig V4L_PCI_DRIVERS
 
 if V4L_PCI_DRIVERS
 
-config VIDEO_HEXIUM_GEMINI
-	tristate "Hexium Gemini frame grabber"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	---help---
-	  This is a video4linux driver for the Hexium Gemini frame
-	  grabber card by Hexium. Please note that the Gemini Dual
-	  card is *not* fully supported.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hexium_gemini.
-
-config VIDEO_HEXIUM_ORION
-	tristate "Hexium HV-PCI6 and Orion frame grabber"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	---help---
-	  This is a video4linux driver for the Hexium HV-PCI6 and
-	  Orion frame grabber cards by Hexium.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hexium_orion.
-
 config VIDEO_MEYE
 	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
 	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
@@ -656,21 +633,6 @@ config VIDEO_MEYE
 	  To compile this driver as a module, choose M here: the
 	  module will be called meye.
 
-config VIDEO_MXB
-	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
-	depends on PCI && VIDEO_V4L2 && I2C
-	select VIDEO_SAA7146_VV
-	select VIDEO_TUNER
-	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
-	---help---
-	  This is a video4linux driver for the 'Multimedia eXtension Board'
-	  TV card by Siemens-Nixdorf.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called mxb.
 
 
 config STA2X11_VIP
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 322a159..8df694d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -93,9 +93,6 @@ obj-$(CONFIG_VIDEO_W9966) += w9966.o
 obj-$(CONFIG_VIDEO_PMS) += pms.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_MEYE) += meye.o
-obj-$(CONFIG_VIDEO_MXB) += mxb.o
-obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
-obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
deleted file mode 100644
index 366434f..0000000
--- a/drivers/media/video/hexium_gemini.c
+++ /dev/null
@@ -1,430 +0,0 @@
-/*
-    hexium_gemini.c - v4l2 driver for Hexium Gemini frame grabber cards
-
-    Visit http://www.mihu.de/linux/saa7146/ and follow the link
-    to "hexium" for further details about this card.
-
-    Copyright (C) 2003 Michael Hunold <michael@mihu.de>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG_VARIABLE debug
-
-#include <media/saa7146_vv.h>
-#include <linux/module.h>
-
-static int debug;
-module_param(debug, int, 0);
-MODULE_PARM_DESC(debug, "debug verbosity");
-
-/* global variables */
-static int hexium_num;
-
-#define HEXIUM_GEMINI			4
-#define HEXIUM_GEMINI_DUAL		5
-
-#define HEXIUM_INPUTS	9
-static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
-	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-};
-
-#define HEXIUM_AUDIOS	0
-
-struct hexium_data
-{
-	s8 adr;
-	u8 byte;
-};
-
-#define HEXIUM_GEMINI_V_1_0		1
-#define HEXIUM_GEMINI_DUAL_V_1_0	2
-
-struct hexium
-{
-	int type;
-
-	struct video_device	*video_dev;
-	struct i2c_adapter	i2c_adapter;
-
-	int 		cur_input;	/* current input */
-	v4l2_std_id 	cur_std;	/* current standard */
-};
-
-/* Samsung KS0127B decoder default registers */
-static u8 hexium_ks0127b[0x100]={
-/*00*/ 0x00,0x52,0x30,0x40,0x01,0x0C,0x2A,0x10,
-/*08*/ 0x00,0x00,0x00,0x60,0x00,0x00,0x0F,0x06,
-/*10*/ 0x00,0x00,0xE4,0xC0,0x00,0x00,0x00,0x00,
-/*18*/ 0x14,0x9B,0xFE,0xFF,0xFC,0xFF,0x03,0x22,
-/*20*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*28*/ 0x00,0x00,0x00,0x00,0x00,0x2C,0x9B,0x00,
-/*30*/ 0x00,0x00,0x10,0x80,0x80,0x10,0x80,0x80,
-/*38*/ 0x01,0x04,0x00,0x00,0x00,0x29,0xC0,0x00,
-/*40*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*48*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*50*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*58*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*60*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*68*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*70*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*78*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*80*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*88*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*90*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*98*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*A0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*A8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*B0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*B8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*C0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*C8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*D0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*D8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*E0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*E8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*F0*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-/*F8*/ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
-};
-
-static struct hexium_data hexium_pal[] = {
-	{ 0x01, 0x52 }, { 0x12, 0x64 }, { 0x2D, 0x2C }, { 0x2E, 0x9B }, { -1 , 0xFF }
-};
-
-static struct hexium_data hexium_ntsc[] = {
-	{ 0x01, 0x53 }, { 0x12, 0x04 }, { 0x2D, 0x23 }, { 0x2E, 0x81 }, { -1 , 0xFF }
-};
-
-static struct hexium_data hexium_secam[] = {
-	{ 0x01, 0x52 }, { 0x12, 0x64 }, { 0x2D, 0x2C }, { 0x2E, 0x9B }, { -1 , 0xFF }
-};
-
-static struct hexium_data hexium_input_select[] = {
-	{ 0x02, 0x60 },
-	{ 0x02, 0x64 },
-	{ 0x02, 0x61 },
-	{ 0x02, 0x65 },
-	{ 0x02, 0x62 },
-	{ 0x02, 0x66 },
-	{ 0x02, 0x68 },
-	{ 0x02, 0x69 },
-	{ 0x02, 0x6A },
-};
-
-/* fixme: h_offset = 0 for Hexium Gemini *Dual*, which
-   are currently *not* supported*/
-static struct saa7146_standard hexium_standards[] = {
-	{
-		.name	= "PAL", 	.id	= V4L2_STD_PAL,
-		.v_offset	= 28,	.v_field 	= 288,
-		.h_offset	= 1,	.h_pixels 	= 680,
-		.v_max_out	= 576,	.h_max_out	= 768,
-	}, {
-		.name	= "NTSC", 	.id	= V4L2_STD_NTSC,
-		.v_offset	= 28,	.v_field 	= 240,
-		.h_offset	= 1,	.h_pixels 	= 640,
-		.v_max_out	= 480,	.h_max_out	= 640,
-	}, {
-		.name	= "SECAM", 	.id	= V4L2_STD_SECAM,
-		.v_offset	= 28,	.v_field 	= 288,
-		.h_offset	= 1,	.h_pixels 	= 720,
-		.v_max_out	= 576,	.h_max_out	= 768,
-	}
-};
-
-/* bring hardware to a sane state. this has to be done, just in case someone
-   wants to capture from this device before it has been properly initialized.
-   the capture engine would badly fail, because no valid signal arrives on the
-   saa7146, thus leading to timeouts and stuff. */
-static int hexium_init_done(struct saa7146_dev *dev)
-{
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-	union i2c_smbus_data data;
-	int i = 0;
-
-	DEB_D("hexium_init_done called\n");
-
-	/* initialize the helper ics to useful values */
-	for (i = 0; i < sizeof(hexium_ks0127b); i++) {
-		data.byte = hexium_ks0127b[i];
-		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, i, I2C_SMBUS_BYTE_DATA, &data)) {
-			pr_err("hexium_init_done() failed for address 0x%02x\n",
-			       i);
-		}
-	}
-
-	return 0;
-}
-
-static int hexium_set_input(struct hexium *hexium, int input)
-{
-	union i2c_smbus_data data;
-
-	DEB_D("\n");
-
-	data.byte = hexium_input_select[input].byte;
-	if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, hexium_input_select[input].adr, I2C_SMBUS_BYTE_DATA, &data)) {
-		return -1;
-	}
-
-	return 0;
-}
-
-static int hexium_set_standard(struct hexium *hexium, struct hexium_data *vdec)
-{
-	union i2c_smbus_data data;
-	int i = 0;
-
-	DEB_D("\n");
-
-	while (vdec[i].adr != -1) {
-		data.byte = vdec[i].byte;
-		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, vdec[i].adr, I2C_SMBUS_BYTE_DATA, &data)) {
-			pr_err("hexium_init_done: hexium_set_standard() failed for address 0x%02x\n",
-			       i);
-			return -1;
-		}
-		i++;
-	}
-	return 0;
-}
-
-static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
-{
-	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
-
-	if (i->index >= HEXIUM_INPUTS)
-		return -EINVAL;
-
-	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
-
-	DEB_D("v4l2_ioctl: VIDIOC_ENUMINPUT %d\n", i->index);
-	return 0;
-}
-
-static int vidioc_g_input(struct file *file, void *fh, unsigned int *input)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	*input = hexium->cur_input;
-
-	DEB_D("VIDIOC_G_INPUT: %d\n", *input);
-	return 0;
-}
-
-static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	DEB_EE("VIDIOC_S_INPUT %d\n", input);
-
-	if (input >= HEXIUM_INPUTS)
-		return -EINVAL;
-
-	hexium->cur_input = input;
-	hexium_set_input(hexium, input);
-	return 0;
-}
-
-static struct saa7146_ext_vv vv_data;
-
-/* this function only gets called when the probing was successful */
-static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
-{
-	struct hexium *hexium;
-	int ret;
-
-	DEB_EE("\n");
-
-	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
-	if (NULL == hexium) {
-		pr_err("not enough kernel memory in hexium_attach()\n");
-		return -ENOMEM;
-	}
-	dev->ext_priv = hexium;
-
-	/* enable i2c-port pins */
-	saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
-
-	hexium->i2c_adapter = (struct i2c_adapter) {
-		.name = "hexium gemini",
-	};
-	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
-	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
-		DEB_S("cannot register i2c-device. skipping.\n");
-		kfree(hexium);
-		return -EFAULT;
-	}
-
-	/*  set HWControl GPIO number 2 */
-	saa7146_setgpio(dev, 2, SAA7146_GPIO_OUTHI);
-
-	saa7146_write(dev, DD1_INIT, 0x07000700);
-	saa7146_write(dev, DD1_STREAM_B, 0x00000000);
-	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
-
-	/* the rest */
-	hexium->cur_input = 0;
-	hexium_init_done(dev);
-
-	hexium_set_standard(hexium, hexium_pal);
-	hexium->cur_std = V4L2_STD_PAL;
-
-	hexium_set_input(hexium, 0);
-	hexium->cur_input = 0;
-
-	saa7146_vv_init(dev, &vv_data);
-
-	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
-	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
-	ret = saa7146_register_device(&hexium->video_dev, dev, "hexium gemini", VFL_TYPE_GRABBER);
-	if (ret < 0) {
-		pr_err("cannot register capture v4l2 device. skipping.\n");
-		return ret;
-	}
-
-	pr_info("found 'hexium gemini' frame grabber-%d\n", hexium_num);
-	hexium_num++;
-
-	return 0;
-}
-
-static int hexium_detach(struct saa7146_dev *dev)
-{
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	DEB_EE("dev:%p\n", dev);
-
-	saa7146_unregister_device(&hexium->video_dev, dev);
-	saa7146_vv_release(dev);
-
-	hexium_num--;
-
-	i2c_del_adapter(&hexium->i2c_adapter);
-	kfree(hexium);
-	return 0;
-}
-
-static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *std)
-{
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	if (V4L2_STD_PAL == std->id) {
-		hexium_set_standard(hexium, hexium_pal);
-		hexium->cur_std = V4L2_STD_PAL;
-		return 0;
-	} else if (V4L2_STD_NTSC == std->id) {
-		hexium_set_standard(hexium, hexium_ntsc);
-		hexium->cur_std = V4L2_STD_NTSC;
-		return 0;
-	} else if (V4L2_STD_SECAM == std->id) {
-		hexium_set_standard(hexium, hexium_secam);
-		hexium->cur_std = V4L2_STD_SECAM;
-		return 0;
-	}
-
-	return -1;
-}
-
-static struct saa7146_extension hexium_extension;
-
-static struct saa7146_pci_extension_data hexium_gemini_4bnc = {
-	.ext_priv = "Hexium Gemini (4 BNC)",
-	.ext = &hexium_extension,
-};
-
-static struct saa7146_pci_extension_data hexium_gemini_dual_4bnc = {
-	.ext_priv = "Hexium Gemini Dual (4 BNC)",
-	.ext = &hexium_extension,
-};
-
-static struct pci_device_id pci_tbl[] = {
-	{
-	 .vendor = PCI_VENDOR_ID_PHILIPS,
-	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
-	 .subvendor = 0x17c8,
-	 .subdevice = 0x2401,
-	 .driver_data = (unsigned long) &hexium_gemini_4bnc,
-	 },
-	{
-	 .vendor = PCI_VENDOR_ID_PHILIPS,
-	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
-	 .subvendor = 0x17c8,
-	 .subdevice = 0x2402,
-	 .driver_data = (unsigned long) &hexium_gemini_dual_4bnc,
-	 },
-	{
-	 .vendor = 0,
-	 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci_tbl);
-
-static struct saa7146_ext_vv vv_data = {
-	.inputs = HEXIUM_INPUTS,
-	.capabilities = 0,
-	.stds = &hexium_standards[0],
-	.num_stds = sizeof(hexium_standards) / sizeof(struct saa7146_standard),
-	.std_callback = &std_callback,
-};
-
-static struct saa7146_extension hexium_extension = {
-	.name = "hexium gemini",
-	.flags = SAA7146_USE_I2C_IRQ,
-
-	.pci_tbl = &pci_tbl[0],
-	.module = THIS_MODULE,
-
-	.attach = hexium_attach,
-	.detach = hexium_detach,
-
-	.irq_mask = 0,
-	.irq_func = NULL,
-};
-
-static int __init hexium_init_module(void)
-{
-	if (0 != saa7146_register_extension(&hexium_extension)) {
-		DEB_S("failed to register extension\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void __exit hexium_cleanup_module(void)
-{
-	saa7146_unregister_extension(&hexium_extension);
-}
-
-module_init(hexium_init_module);
-module_exit(hexium_cleanup_module);
-
-MODULE_DESCRIPTION("video4linux-2 driver for Hexium Gemini frame grabber cards");
-MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
deleted file mode 100644
index a1eb26d..0000000
--- a/drivers/media/video/hexium_orion.c
+++ /dev/null
@@ -1,502 +0,0 @@
-/*
-    hexium_orion.c - v4l2 driver for the Hexium Orion frame grabber cards
-
-    Visit http://www.mihu.de/linux/saa7146/ and follow the link
-    to "hexium" for further details about this card.
-
-    Copyright (C) 2003 Michael Hunold <michael@mihu.de>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG_VARIABLE debug
-
-#include <media/saa7146_vv.h>
-#include <linux/module.h>
-
-static int debug;
-module_param(debug, int, 0);
-MODULE_PARM_DESC(debug, "debug verbosity");
-
-/* global variables */
-static int hexium_num;
-
-#define HEXIUM_HV_PCI6_ORION		1
-#define HEXIUM_ORION_1SVHS_3BNC		2
-#define HEXIUM_ORION_4BNC		3
-
-#define HEXIUM_INPUTS	9
-static struct v4l2_input hexium_inputs[HEXIUM_INPUTS] = {
-	{ 0, "CVBS 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 1, "CVBS 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 2, "CVBS 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 3, "CVBS 4",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 4, "CVBS 5",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 5, "CVBS 6",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 6, "Y/C 1",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 7, "Y/C 2",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ 8, "Y/C 3",	V4L2_INPUT_TYPE_CAMERA,	0, 0, V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-};
-
-#define HEXIUM_AUDIOS	0
-
-struct hexium_data
-{
-	s8 adr;
-	u8 byte;
-};
-
-struct hexium
-{
-	int type;
-	struct video_device	*video_dev;
-	struct i2c_adapter	i2c_adapter;
-
-	int cur_input;	/* current input */
-};
-
-/* Philips SAA7110 decoder default registers */
-static u8 hexium_saa7110[53]={
-/*00*/ 0x4C,0x3C,0x0D,0xEF,0xBD,0xF0,0x00,0x00,
-/*08*/ 0xF8,0xF8,0x60,0x60,0x40,0x86,0x18,0x90,
-/*10*/ 0x00,0x2C,0x40,0x46,0x42,0x1A,0xFF,0xDA,
-/*18*/ 0xF0,0x8B,0x00,0x00,0x00,0x00,0x00,0x00,
-/*20*/ 0xD9,0x17,0x40,0x41,0x80,0x41,0x80,0x4F,
-/*28*/ 0xFE,0x01,0x0F,0x0F,0x03,0x01,0x81,0x03,
-/*30*/ 0x44,0x75,0x01,0x8C,0x03
-};
-
-static struct {
-	struct hexium_data data[8];
-} hexium_input_select[] = {
-{
-	{ /* cvbs 1 */
-		{ 0x06, 0x00 },
-		{ 0x20, 0xD9 },
-		{ 0x21, 0x17 }, // 0x16,
-		{ 0x22, 0x40 },
-		{ 0x2C, 0x03 },
-		{ 0x30, 0x44 },
-		{ 0x31, 0x75 }, // ??
-		{ 0x21, 0x16 }, // 0x03,
-	}
-}, {
-	{ /* cvbs 2 */
-		{ 0x06, 0x00 },
-		{ 0x20, 0x78 },
-		{ 0x21, 0x07 }, // 0x03,
-		{ 0x22, 0xD2 },
-		{ 0x2C, 0x83 },
-		{ 0x30, 0x60 },
-		{ 0x31, 0xB5 }, // ?
-		{ 0x21, 0x03 },
-	}
-}, {
-	{ /* cvbs 3 */
-		{ 0x06, 0x00 },
-		{ 0x20, 0xBA },
-		{ 0x21, 0x07 }, // 0x05,
-		{ 0x22, 0x91 },
-		{ 0x2C, 0x03 },
-		{ 0x30, 0x60 },
-		{ 0x31, 0xB5 }, // ??
-		{ 0x21, 0x05 }, // 0x03,
-	}
-}, {
-	{ /* cvbs 4 */
-		{ 0x06, 0x00 },
-		{ 0x20, 0xD8 },
-		{ 0x21, 0x17 }, // 0x16,
-		{ 0x22, 0x40 },
-		{ 0x2C, 0x03 },
-		{ 0x30, 0x44 },
-		{ 0x31, 0x75 }, // ??
-		{ 0x21, 0x16 }, // 0x03,
-	}
-}, {
-	{ /* cvbs 5 */
-		{ 0x06, 0x00 },
-		{ 0x20, 0xB8 },
-		{ 0x21, 0x07 }, // 0x05,
-		{ 0x22, 0x91 },
-		{ 0x2C, 0x03 },
-		{ 0x30, 0x60 },
-		{ 0x31, 0xB5 }, // ??
-		{ 0x21, 0x05 }, // 0x03,
-	}
-}, {
-	{ /* cvbs 6 */
-		{ 0x06, 0x00 },
-		{ 0x20, 0x7C },
-		{ 0x21, 0x07 }, // 0x03
-		{ 0x22, 0xD2 },
-		{ 0x2C, 0x83 },
-		{ 0x30, 0x60 },
-		{ 0x31, 0xB5 }, // ??
-		{ 0x21, 0x03 },
-	}
-}, {
-	{ /* y/c 1 */
-		{ 0x06, 0x80 },
-		{ 0x20, 0x59 },
-		{ 0x21, 0x17 },
-		{ 0x22, 0x42 },
-		{ 0x2C, 0xA3 },
-		{ 0x30, 0x44 },
-		{ 0x31, 0x75 },
-		{ 0x21, 0x12 },
-	}
-}, {
-	{ /* y/c 2 */
-		{ 0x06, 0x80 },
-		{ 0x20, 0x9A },
-		{ 0x21, 0x17 },
-		{ 0x22, 0xB1 },
-		{ 0x2C, 0x13 },
-		{ 0x30, 0x60 },
-		{ 0x31, 0xB5 },
-		{ 0x21, 0x14 },
-	}
-}, {
-	{ /* y/c 3 */
-		{ 0x06, 0x80 },
-		{ 0x20, 0x3C },
-		{ 0x21, 0x27 },
-		{ 0x22, 0xC1 },
-		{ 0x2C, 0x23 },
-		{ 0x30, 0x44 },
-		{ 0x31, 0x75 },
-		{ 0x21, 0x21 },
-	}
-}
-};
-
-static struct saa7146_standard hexium_standards[] = {
-	{
-		.name	= "PAL", 	.id	= V4L2_STD_PAL,
-		.v_offset	= 16,	.v_field 	= 288,
-		.h_offset	= 1,	.h_pixels 	= 680,
-		.v_max_out	= 576,	.h_max_out	= 768,
-	}, {
-		.name	= "NTSC", 	.id	= V4L2_STD_NTSC,
-		.v_offset	= 16,	.v_field 	= 240,
-		.h_offset	= 1,	.h_pixels 	= 640,
-		.v_max_out	= 480,	.h_max_out	= 640,
-	}, {
-		.name	= "SECAM", 	.id	= V4L2_STD_SECAM,
-		.v_offset	= 16,	.v_field 	= 288,
-		.h_offset	= 1,	.h_pixels 	= 720,
-		.v_max_out	= 576,	.h_max_out	= 768,
-	}
-};
-
-/* this is only called for old HV-PCI6/Orion cards
-   without eeprom */
-static int hexium_probe(struct saa7146_dev *dev)
-{
-	struct hexium *hexium = NULL;
-	union i2c_smbus_data data;
-	int err = 0;
-
-	DEB_EE("\n");
-
-	/* there are no hexium orion cards with revision 0 saa7146s */
-	if (0 == dev->revision) {
-		return -EFAULT;
-	}
-
-	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
-	if (NULL == hexium) {
-		pr_err("hexium_probe: not enough kernel memory\n");
-		return -ENOMEM;
-	}
-
-	/* enable i2c-port pins */
-	saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
-
-	saa7146_write(dev, DD1_INIT, 0x01000100);
-	saa7146_write(dev, DD1_STREAM_B, 0x00000000);
-	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
-
-	hexium->i2c_adapter = (struct i2c_adapter) {
-		.name = "hexium orion",
-	};
-	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
-	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
-		DEB_S("cannot register i2c-device. skipping.\n");
-		kfree(hexium);
-		return -EFAULT;
-	}
-
-	/* set SAA7110 control GPIO 0 */
-	saa7146_setgpio(dev, 0, SAA7146_GPIO_OUTHI);
-	/*  set HWControl GPIO number 2 */
-	saa7146_setgpio(dev, 2, SAA7146_GPIO_OUTHI);
-
-	mdelay(10);
-
-	/* detect newer Hexium Orion cards by subsystem ids */
-	if (0x17c8 == dev->pci->subsystem_vendor && 0x0101 == dev->pci->subsystem_device) {
-		pr_info("device is a Hexium Orion w/ 1 SVHS + 3 BNC inputs\n");
-		/* we store the pointer in our private data field */
-		dev->ext_priv = hexium;
-		hexium->type = HEXIUM_ORION_1SVHS_3BNC;
-		return 0;
-	}
-
-	if (0x17c8 == dev->pci->subsystem_vendor && 0x2101 == dev->pci->subsystem_device) {
-		pr_info("device is a Hexium Orion w/ 4 BNC inputs\n");
-		/* we store the pointer in our private data field */
-		dev->ext_priv = hexium;
-		hexium->type = HEXIUM_ORION_4BNC;
-		return 0;
-	}
-
-	/* check if this is an old hexium Orion card by looking at
-	   a saa7110 at address 0x4e */
-	if (0 == (err = i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_READ, 0x00, I2C_SMBUS_BYTE_DATA, &data))) {
-		pr_info("device is a Hexium HV-PCI6/Orion (old)\n");
-		/* we store the pointer in our private data field */
-		dev->ext_priv = hexium;
-		hexium->type = HEXIUM_HV_PCI6_ORION;
-		return 0;
-	}
-
-	i2c_del_adapter(&hexium->i2c_adapter);
-	kfree(hexium);
-	return -EFAULT;
-}
-
-/* bring hardware to a sane state. this has to be done, just in case someone
-   wants to capture from this device before it has been properly initialized.
-   the capture engine would badly fail, because no valid signal arrives on the
-   saa7146, thus leading to timeouts and stuff. */
-static int hexium_init_done(struct saa7146_dev *dev)
-{
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-	union i2c_smbus_data data;
-	int i = 0;
-
-	DEB_D("hexium_init_done called\n");
-
-	/* initialize the helper ics to useful values */
-	for (i = 0; i < sizeof(hexium_saa7110); i++) {
-		data.byte = hexium_saa7110[i];
-		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_WRITE, i, I2C_SMBUS_BYTE_DATA, &data)) {
-			pr_err("failed for address 0x%02x\n", i);
-		}
-	}
-
-	return 0;
-}
-
-static int hexium_set_input(struct hexium *hexium, int input)
-{
-	union i2c_smbus_data data;
-	int i = 0;
-
-	DEB_D("\n");
-
-	for (i = 0; i < 8; i++) {
-		int adr = hexium_input_select[input].data[i].adr;
-		data.byte = hexium_input_select[input].data[i].byte;
-		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_WRITE, adr, I2C_SMBUS_BYTE_DATA, &data)) {
-			return -1;
-		}
-		pr_debug("%d: 0x%02x => 0x%02x\n", input, adr, data.byte);
-	}
-
-	return 0;
-}
-
-static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
-{
-	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
-
-	if (i->index >= HEXIUM_INPUTS)
-		return -EINVAL;
-
-	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
-
-	DEB_D("v4l2_ioctl: VIDIOC_ENUMINPUT %d\n", i->index);
-	return 0;
-}
-
-static int vidioc_g_input(struct file *file, void *fh, unsigned int *input)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	*input = hexium->cur_input;
-
-	DEB_D("VIDIOC_G_INPUT: %d\n", *input);
-	return 0;
-}
-
-static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	if (input >= HEXIUM_INPUTS)
-		return -EINVAL;
-
-	hexium->cur_input = input;
-	hexium_set_input(hexium, input);
-
-	return 0;
-}
-
-static struct saa7146_ext_vv vv_data;
-
-/* this function only gets called when the probing was successful */
-static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
-{
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	DEB_EE("\n");
-
-	saa7146_vv_init(dev, &vv_data);
-	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
-	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
-	if (0 != saa7146_register_device(&hexium->video_dev, dev, "hexium orion", VFL_TYPE_GRABBER)) {
-		pr_err("cannot register capture v4l2 device. skipping.\n");
-		return -1;
-	}
-
-	pr_err("found 'hexium orion' frame grabber-%d\n", hexium_num);
-	hexium_num++;
-
-	/* the rest */
-	hexium->cur_input = 0;
-	hexium_init_done(dev);
-
-	return 0;
-}
-
-static int hexium_detach(struct saa7146_dev *dev)
-{
-	struct hexium *hexium = (struct hexium *) dev->ext_priv;
-
-	DEB_EE("dev:%p\n", dev);
-
-	saa7146_unregister_device(&hexium->video_dev, dev);
-	saa7146_vv_release(dev);
-
-	hexium_num--;
-
-	i2c_del_adapter(&hexium->i2c_adapter);
-	kfree(hexium);
-	return 0;
-}
-
-static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *std)
-{
-	return 0;
-}
-
-static struct saa7146_extension extension;
-
-static struct saa7146_pci_extension_data hexium_hv_pci6 = {
-	.ext_priv = "Hexium HV-PCI6 / Orion",
-	.ext = &extension,
-};
-
-static struct saa7146_pci_extension_data hexium_orion_1svhs_3bnc = {
-	.ext_priv = "Hexium HV-PCI6 / Orion (1 SVHS/3 BNC)",
-	.ext = &extension,
-};
-
-static struct saa7146_pci_extension_data hexium_orion_4bnc = {
-	.ext_priv = "Hexium HV-PCI6 / Orion (4 BNC)",
-	.ext = &extension,
-};
-
-static struct pci_device_id pci_tbl[] = {
-	{
-	 .vendor = PCI_VENDOR_ID_PHILIPS,
-	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
-	 .subvendor = 0x0000,
-	 .subdevice = 0x0000,
-	 .driver_data = (unsigned long) &hexium_hv_pci6,
-	 },
-	{
-	 .vendor = PCI_VENDOR_ID_PHILIPS,
-	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
-	 .subvendor = 0x17c8,
-	 .subdevice = 0x0101,
-	 .driver_data = (unsigned long) &hexium_orion_1svhs_3bnc,
-	 },
-	{
-	 .vendor = PCI_VENDOR_ID_PHILIPS,
-	 .device = PCI_DEVICE_ID_PHILIPS_SAA7146,
-	 .subvendor = 0x17c8,
-	 .subdevice = 0x2101,
-	 .driver_data = (unsigned long) &hexium_orion_4bnc,
-	 },
-	{
-	 .vendor = 0,
-	 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci_tbl);
-
-static struct saa7146_ext_vv vv_data = {
-	.inputs = HEXIUM_INPUTS,
-	.capabilities = 0,
-	.stds = &hexium_standards[0],
-	.num_stds = sizeof(hexium_standards) / sizeof(struct saa7146_standard),
-	.std_callback = &std_callback,
-};
-
-static struct saa7146_extension extension = {
-	.name = "hexium HV-PCI6 Orion",
-	.flags = 0,		// SAA7146_USE_I2C_IRQ,
-
-	.pci_tbl = &pci_tbl[0],
-	.module = THIS_MODULE,
-
-	.probe = hexium_probe,
-	.attach = hexium_attach,
-	.detach = hexium_detach,
-
-	.irq_mask = 0,
-	.irq_func = NULL,
-};
-
-static int __init hexium_init_module(void)
-{
-	if (0 != saa7146_register_extension(&extension)) {
-		DEB_S("failed to register extension\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void __exit hexium_cleanup_module(void)
-{
-	saa7146_unregister_extension(&extension);
-}
-
-module_init(hexium_init_module);
-module_exit(hexium_cleanup_module);
-
-MODULE_DESCRIPTION("video4linux-2 driver for Hexium Orion frame grabber cards");
-MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
deleted file mode 100644
index b520a45..0000000
--- a/drivers/media/video/mxb.c
+++ /dev/null
@@ -1,886 +0,0 @@
-/*
-    mxb - v4l2 driver for the Multimedia eXtension Board
-
-    Copyright (C) 1998-2006 Michael Hunold <michael@mihu.de>
-
-    Visit http://www.themm.net/~mihu/linux/saa7146/mxb.html 
-    for further details about this card.
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG_VARIABLE debug
-
-#include <media/saa7146_vv.h>
-#include <media/tuner.h>
-#include <media/v4l2-common.h>
-#include <media/saa7115.h>
-#include <linux/module.h>
-
-#include "tea6415c.h"
-#include "tea6420.h"
-
-#define MXB_AUDIOS	6
-
-#define I2C_SAA7111A  0x24
-#define	I2C_TDA9840   0x42
-#define	I2C_TEA6415C  0x43
-#define	I2C_TEA6420_1 0x4c
-#define	I2C_TEA6420_2 0x4d
-#define	I2C_TUNER     0x60
-
-#define MXB_BOARD_CAN_DO_VBI(dev)   (dev->revision != 0)
-
-/* global variable */
-static int mxb_num;
-
-/* initial frequence the tuner will be tuned to.
-   in verden (lower saxony, germany) 4148 is a
-   channel called "phoenix" */
-static int freq = 4148;
-module_param(freq, int, 0644);
-MODULE_PARM_DESC(freq, "initial frequency the tuner will be tuned to while setup");
-
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
-
-#define MXB_INPUTS 4
-enum { TUNER, AUX1, AUX3, AUX3_YC };
-
-static struct v4l2_input mxb_inputs[MXB_INPUTS] = {
-	{ TUNER,   "Tuner",          V4L2_INPUT_TYPE_TUNER,  0x3f, 0,
-		V4L2_STD_PAL_BG | V4L2_STD_PAL_I, 0, V4L2_IN_CAP_STD },
-	{ AUX1,	   "AUX1",           V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
-		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ AUX3,	   "AUX3 Composite", V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
-		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-	{ AUX3_YC, "AUX3 S-Video",   V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
-		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
-};
-
-/* this array holds the information, which port of the saa7146 each
-   input actually uses. the mxb uses port 0 for every input */
-static struct {
-	int hps_source;
-	int hps_sync;
-} input_port_selection[MXB_INPUTS] = {
-	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
-	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
-	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
-	{ SAA7146_HPS_SOURCE_PORT_A, SAA7146_HPS_SYNC_PORT_A },
-};
-
-/* this array holds the information of the audio source (mxb_audios),
-   which has to be switched corresponding to the video source (mxb_channels) */
-static int video_audio_connect[MXB_INPUTS] =
-	{ 0, 1, 3, 3 };
-
-struct mxb_routing {
-	u32 input;
-	u32 output;
-};
-
-/* these are the available audio sources, which can switched
-   to the line- and cd-output individually */
-static struct v4l2_audio mxb_audios[MXB_AUDIOS] = {
-	    {
-		.index	= 0,
-		.name	= "Tuner",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 1,
-		.name	= "AUX1",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 2,
-		.name	= "AUX2",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 3,
-		.name	= "AUX3",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 4,
-		.name	= "Radio (X9)",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 5,
-		.name	= "CD-ROM (X10)",
-		.capability = V4L2_AUDCAP_STEREO,
-	}
-};
-
-/* These are the necessary input-output-pins for bringing one audio source
-   (see above) to the CD-output. Note that gain is set to 0 in this table. */
-static struct mxb_routing TEA6420_cd[MXB_AUDIOS + 1][2] = {
-	{ { 1, 1 }, { 1, 1 } },	/* Tuner */
-	{ { 5, 1 }, { 6, 1 } },	/* AUX 1 */
-	{ { 4, 1 }, { 6, 1 } },	/* AUX 2 */
-	{ { 3, 1 }, { 6, 1 } },	/* AUX 3 */
-	{ { 1, 1 }, { 3, 1 } },	/* Radio */
-	{ { 1, 1 }, { 2, 1 } },	/* CD-Rom */
-	{ { 6, 1 }, { 6, 1 } }	/* Mute */
-};
-
-/* These are the necessary input-output-pins for bringing one audio source
-   (see above) to the line-output. Note that gain is set to 0 in this table. */
-static struct mxb_routing TEA6420_line[MXB_AUDIOS + 1][2] = {
-	{ { 2, 3 }, { 1, 2 } },
-	{ { 5, 3 }, { 6, 2 } },
-	{ { 4, 3 }, { 6, 2 } },
-	{ { 3, 3 }, { 6, 2 } },
-	{ { 2, 3 }, { 3, 2 } },
-	{ { 2, 3 }, { 2, 2 } },
-	{ { 6, 3 }, { 6, 2 } }	/* Mute */
-};
-
-struct mxb
-{
-	struct video_device	*video_dev;
-	struct video_device	*vbi_dev;
-
-	struct i2c_adapter	i2c_adapter;
-
-	struct v4l2_subdev	*saa7111a;
-	struct v4l2_subdev	*tda9840;
-	struct v4l2_subdev	*tea6415c;
-	struct v4l2_subdev	*tuner;
-	struct v4l2_subdev	*tea6420_1;
-	struct v4l2_subdev	*tea6420_2;
-
-	int	cur_mode;	/* current audio mode (mono, stereo, ...) */
-	int	cur_input;	/* current input */
-	int	cur_audinput;	/* current audio input */
-	int	cur_mute;	/* current mute status */
-	struct v4l2_frequency	cur_freq;	/* current frequency the tuner is tuned to */
-};
-
-#define saa7111a_call(mxb, o, f, args...) \
-	v4l2_subdev_call(mxb->saa7111a, o, f, ##args)
-#define tda9840_call(mxb, o, f, args...) \
-	v4l2_subdev_call(mxb->tda9840, o, f, ##args)
-#define tea6415c_call(mxb, o, f, args...) \
-	v4l2_subdev_call(mxb->tea6415c, o, f, ##args)
-#define tuner_call(mxb, o, f, args...) \
-	v4l2_subdev_call(mxb->tuner, o, f, ##args)
-#define call_all(dev, o, f, args...) \
-	v4l2_device_call_until_err(&dev->v4l2_dev, 0, o, f, ##args)
-
-static void mxb_update_audmode(struct mxb *mxb)
-{
-	struct v4l2_tuner t = {
-		.audmode = mxb->cur_mode,
-	};
-
-	tda9840_call(mxb, tuner, s_tuner, &t);
-}
-
-static inline void tea6420_route(struct mxb *mxb, int idx)
-{
-	v4l2_subdev_call(mxb->tea6420_1, audio, s_routing,
-		TEA6420_cd[idx][0].input, TEA6420_cd[idx][0].output, 0);
-	v4l2_subdev_call(mxb->tea6420_2, audio, s_routing,
-		TEA6420_cd[idx][1].input, TEA6420_cd[idx][1].output, 0);
-	v4l2_subdev_call(mxb->tea6420_1, audio, s_routing,
-		TEA6420_line[idx][0].input, TEA6420_line[idx][0].output, 0);
-	v4l2_subdev_call(mxb->tea6420_2, audio, s_routing,
-		TEA6420_line[idx][1].input, TEA6420_line[idx][1].output, 0);
-}
-
-static struct saa7146_extension extension;
-
-static int mxb_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct saa7146_dev *dev = container_of(ctrl->handler,
-				struct saa7146_dev, ctrl_handler);
-	struct mxb *mxb = dev->ext_priv;
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		mxb->cur_mute = ctrl->val;
-		/* switch the audio-source */
-		tea6420_route(mxb, ctrl->val ? 6 :
-				video_audio_connect[mxb->cur_input]);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static const struct v4l2_ctrl_ops mxb_ctrl_ops = {
-	.s_ctrl = mxb_s_ctrl,
-};
-
-static int mxb_probe(struct saa7146_dev *dev)
-{
-	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
-	struct mxb *mxb = NULL;
-
-	v4l2_ctrl_new_std(hdl, &mxb_ctrl_ops,
-			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
-	if (hdl->error)
-		return hdl->error;
-	mxb = kzalloc(sizeof(struct mxb), GFP_KERNEL);
-	if (mxb == NULL) {
-		DEB_D("not enough kernel memory\n");
-		return -ENOMEM;
-	}
-
-
-	snprintf(mxb->i2c_adapter.name, sizeof(mxb->i2c_adapter.name), "mxb%d", mxb_num);
-
-	saa7146_i2c_adapter_prepare(dev, &mxb->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
-	if (i2c_add_adapter(&mxb->i2c_adapter) < 0) {
-		DEB_S("cannot register i2c-device. skipping.\n");
-		kfree(mxb);
-		return -EFAULT;
-	}
-
-	mxb->saa7111a = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"saa7111", I2C_SAA7111A, NULL);
-	mxb->tea6420_1 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tea6420", I2C_TEA6420_1, NULL);
-	mxb->tea6420_2 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tea6420", I2C_TEA6420_2, NULL);
-	mxb->tea6415c = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tea6415c", I2C_TEA6415C, NULL);
-	mxb->tda9840 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tda9840", I2C_TDA9840, NULL);
-	mxb->tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tuner", I2C_TUNER, NULL);
-
-	/* check if all devices are present */
-	if (!mxb->tea6420_1 || !mxb->tea6420_2 || !mxb->tea6415c ||
-	    !mxb->tda9840 || !mxb->saa7111a || !mxb->tuner) {
-		pr_err("did not find all i2c devices. aborting\n");
-		i2c_del_adapter(&mxb->i2c_adapter);
-		kfree(mxb);
-		return -ENODEV;
-	}
-
-	/* all devices are present, probe was successful */
-
-	/* we store the pointer in our private data field */
-	dev->ext_priv = mxb;
-
-	v4l2_ctrl_handler_setup(hdl);
-
-	return 0;
-}
-
-/* some init data for the saa7740, the so-called 'sound arena module'.
-   there are no specs available, so we simply use some init values */
-static struct {
-	int	length;
-	char	data[9];
-} mxb_saa7740_init[] = {
-	{ 3, { 0x80, 0x00, 0x00 } },{ 3, { 0x80, 0x89, 0x00 } },
-	{ 3, { 0x80, 0xb0, 0x0a } },{ 3, { 0x00, 0x00, 0x00 } },
-	{ 3, { 0x49, 0x00, 0x00 } },{ 3, { 0x4a, 0x00, 0x00 } },
-	{ 3, { 0x4b, 0x00, 0x00 } },{ 3, { 0x4c, 0x00, 0x00 } },
-	{ 3, { 0x4d, 0x00, 0x00 } },{ 3, { 0x4e, 0x00, 0x00 } },
-	{ 3, { 0x4f, 0x00, 0x00 } },{ 3, { 0x50, 0x00, 0x00 } },
-	{ 3, { 0x51, 0x00, 0x00 } },{ 3, { 0x52, 0x00, 0x00 } },
-	{ 3, { 0x53, 0x00, 0x00 } },{ 3, { 0x54, 0x00, 0x00 } },
-	{ 3, { 0x55, 0x00, 0x00 } },{ 3, { 0x56, 0x00, 0x00 } },
-	{ 3, { 0x57, 0x00, 0x00 } },{ 3, { 0x58, 0x00, 0x00 } },
-	{ 3, { 0x59, 0x00, 0x00 } },{ 3, { 0x5a, 0x00, 0x00 } },
-	{ 3, { 0x5b, 0x00, 0x00 } },{ 3, { 0x5c, 0x00, 0x00 } },
-	{ 3, { 0x5d, 0x00, 0x00 } },{ 3, { 0x5e, 0x00, 0x00 } },
-	{ 3, { 0x5f, 0x00, 0x00 } },{ 3, { 0x60, 0x00, 0x00 } },
-	{ 3, { 0x61, 0x00, 0x00 } },{ 3, { 0x62, 0x00, 0x00 } },
-	{ 3, { 0x63, 0x00, 0x00 } },{ 3, { 0x64, 0x00, 0x00 } },
-	{ 3, { 0x65, 0x00, 0x00 } },{ 3, { 0x66, 0x00, 0x00 } },
-	{ 3, { 0x67, 0x00, 0x00 } },{ 3, { 0x68, 0x00, 0x00 } },
-	{ 3, { 0x69, 0x00, 0x00 } },{ 3, { 0x6a, 0x00, 0x00 } },
-	{ 3, { 0x6b, 0x00, 0x00 } },{ 3, { 0x6c, 0x00, 0x00 } },
-	{ 3, { 0x6d, 0x00, 0x00 } },{ 3, { 0x6e, 0x00, 0x00 } },
-	{ 3, { 0x6f, 0x00, 0x00 } },{ 3, { 0x70, 0x00, 0x00 } },
-	{ 3, { 0x71, 0x00, 0x00 } },{ 3, { 0x72, 0x00, 0x00 } },
-	{ 3, { 0x73, 0x00, 0x00 } },{ 3, { 0x74, 0x00, 0x00 } },
-	{ 3, { 0x75, 0x00, 0x00 } },{ 3, { 0x76, 0x00, 0x00 } },
-	{ 3, { 0x77, 0x00, 0x00 } },{ 3, { 0x41, 0x00, 0x42 } },
-	{ 3, { 0x42, 0x10, 0x42 } },{ 3, { 0x43, 0x20, 0x42 } },
-	{ 3, { 0x44, 0x30, 0x42 } },{ 3, { 0x45, 0x00, 0x01 } },
-	{ 3, { 0x46, 0x00, 0x01 } },{ 3, { 0x47, 0x00, 0x01 } },
-	{ 3, { 0x48, 0x00, 0x01 } },
-	{ 9, { 0x01, 0x03, 0xc5, 0x5c, 0x7a, 0x85, 0x01, 0x00, 0x54 } },
-	{ 9, { 0x21, 0x03, 0xc5, 0x5c, 0x7a, 0x85, 0x01, 0x00, 0x54 } },
-	{ 9, { 0x09, 0x0b, 0xb4, 0x6b, 0x74, 0x85, 0x95, 0x00, 0x34 } },
-	{ 9, { 0x29, 0x0b, 0xb4, 0x6b, 0x74, 0x85, 0x95, 0x00, 0x34 } },
-	{ 9, { 0x11, 0x17, 0x43, 0x62, 0x68, 0x89, 0xd1, 0xff, 0xb0 } },
-	{ 9, { 0x31, 0x17, 0x43, 0x62, 0x68, 0x89, 0xd1, 0xff, 0xb0 } },
-	{ 9, { 0x19, 0x20, 0x62, 0x51, 0x5a, 0x95, 0x19, 0x01, 0x50 } },
-	{ 9, { 0x39, 0x20, 0x62, 0x51, 0x5a, 0x95, 0x19, 0x01, 0x50 } },
-	{ 9, { 0x05, 0x3e, 0xd2, 0x69, 0x4e, 0x9a, 0x51, 0x00, 0xf0 } },
-	{ 9, { 0x25, 0x3e, 0xd2, 0x69, 0x4e, 0x9a, 0x51, 0x00, 0xf0 } },
-	{ 9, { 0x0d, 0x3d, 0xa1, 0x40, 0x7d, 0x9f, 0x29, 0xfe, 0x14 } },
-	{ 9, { 0x2d, 0x3d, 0xa1, 0x40, 0x7d, 0x9f, 0x29, 0xfe, 0x14 } },
-	{ 9, { 0x15, 0x73, 0xa1, 0x50, 0x5d, 0xa6, 0xf5, 0xfe, 0x38 } },
-	{ 9, { 0x35, 0x73, 0xa1, 0x50, 0x5d, 0xa6, 0xf5, 0xfe, 0x38 } },
-	{ 9, { 0x1d, 0xed, 0xd0, 0x68, 0x29, 0xb4, 0xe1, 0x00, 0xb8 } },
-	{ 9, { 0x3d, 0xed, 0xd0, 0x68, 0x29, 0xb4, 0xe1, 0x00, 0xb8 } },
-	{ 3, { 0x80, 0xb3, 0x0a } },
-	{-1, { 0 } }
-};
-
-/* bring hardware to a sane state. this has to be done, just in case someone
-   wants to capture from this device before it has been properly initialized.
-   the capture engine would badly fail, because no valid signal arrives on the
-   saa7146, thus leading to timeouts and stuff. */
-static int mxb_init_done(struct saa7146_dev* dev)
-{
-	struct mxb* mxb = (struct mxb*)dev->ext_priv;
-	struct i2c_msg msg;
-	struct tuner_setup tun_setup;
-	v4l2_std_id std = V4L2_STD_PAL_BG;
-
-	int i = 0, err = 0;
-
-	/* mute audio on tea6420s */
-	tea6420_route(mxb, 6);
-
-	/* select video mode in saa7111a */
-	saa7111a_call(mxb, core, s_std, std);
-
-	/* select tuner-output on saa7111a */
-	i = 0;
-	saa7111a_call(mxb, video, s_routing, SAA7115_COMPOSITE0,
-		SAA7111_FMT_CCIR, 0);
-
-	/* select a tuner type */
-	tun_setup.mode_mask = T_ANALOG_TV;
-	tun_setup.addr = ADDR_UNSET;
-	tun_setup.type = TUNER_PHILIPS_PAL;
-	tuner_call(mxb, tuner, s_type_addr, &tun_setup);
-	/* tune in some frequency on tuner */
-	mxb->cur_freq.tuner = 0;
-	mxb->cur_freq.type = V4L2_TUNER_ANALOG_TV;
-	mxb->cur_freq.frequency = freq;
-	tuner_call(mxb, tuner, s_frequency, &mxb->cur_freq);
-
-	/* set a default video standard */
-	/* These two gpio calls set the GPIO pins that control the tda9820 */
-	saa7146_write(dev, GPIO_CTRL, 0x00404050);
-	saa7111a_call(mxb, core, s_gpio, 1);
-	saa7111a_call(mxb, core, s_std, std);
-	tuner_call(mxb, core, s_std, std);
-
-	/* switch to tuner-channel on tea6415c */
-	tea6415c_call(mxb, video, s_routing, 3, 17, 0);
-
-	/* select tuner-output on multicable on tea6415c */
-	tea6415c_call(mxb, video, s_routing, 3, 13, 0);
-
-	/* the rest for mxb */
-	mxb->cur_input = 0;
-	mxb->cur_audinput = video_audio_connect[mxb->cur_input];
-	mxb->cur_mute = 1;
-
-	mxb->cur_mode = V4L2_TUNER_MODE_STEREO;
-	mxb_update_audmode(mxb);
-
-	/* check if the saa7740 (aka 'sound arena module') is present
-	   on the mxb. if so, we must initialize it. due to lack of
-	   informations about the saa7740, the values were reverse
-	   engineered. */
-	msg.addr = 0x1b;
-	msg.flags = 0;
-	msg.len = mxb_saa7740_init[0].length;
-	msg.buf = &mxb_saa7740_init[0].data[0];
-
-	err = i2c_transfer(&mxb->i2c_adapter, &msg, 1);
-	if (err == 1) {
-		/* the sound arena module is a pos, that's probably the reason
-		   philips refuses to hand out a datasheet for the saa7740...
-		   it seems to screw up the i2c bus, so we disable fast irq
-		   based i2c transactions here and rely on the slow and safe
-		   polling method ... */
-		extension.flags &= ~SAA7146_USE_I2C_IRQ;
-		for (i = 1; ; i++) {
-			if (-1 == mxb_saa7740_init[i].length)
-				break;
-
-			msg.len = mxb_saa7740_init[i].length;
-			msg.buf = &mxb_saa7740_init[i].data[0];
-			err = i2c_transfer(&mxb->i2c_adapter, &msg, 1);
-			if (err != 1) {
-				DEB_D("failed to initialize 'sound arena module'\n");
-				goto err;
-			}
-		}
-		pr_info("'sound arena module' detected\n");
-	}
-err:
-	/* the rest for saa7146: you should definitely set some basic values
-	   for the input-port handling of the saa7146. */
-
-	/* ext->saa has been filled by the core driver */
-
-	/* some stuff is done via variables */
-	saa7146_set_hps_source_and_sync(dev, input_port_selection[mxb->cur_input].hps_source,
-			input_port_selection[mxb->cur_input].hps_sync);
-
-	/* some stuff is done via direct write to the registers */
-
-	/* this is ugly, but because of the fact that this is completely
-	   hardware dependend, it should be done directly... */
-	saa7146_write(dev, DD1_STREAM_B,	0x00000000);
-	saa7146_write(dev, DD1_INIT,		0x02000200);
-	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
-
-	return 0;
-}
-
-/* interrupt-handler. this gets called when irq_mask is != 0.
-   it must clear the interrupt-bits in irq_mask it has handled */
-/*
-void mxb_irq_bh(struct saa7146_dev* dev, u32* irq_mask)
-{
-	struct mxb* mxb = (struct mxb*)dev->ext_priv;
-}
-*/
-
-static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
-{
-	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
-	if (i->index >= MXB_INPUTS)
-		return -EINVAL;
-	memcpy(i, &mxb_inputs[i->index], sizeof(struct v4l2_input));
-	return 0;
-}
-
-static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-	*i = mxb->cur_input;
-
-	DEB_EE("VIDIOC_G_INPUT %d\n", *i);
-	return 0;
-}
-
-static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-	int err = 0;
-	int i = 0;
-
-	DEB_EE("VIDIOC_S_INPUT %d\n", input);
-
-	if (input >= MXB_INPUTS)
-		return -EINVAL;
-
-	mxb->cur_input = input;
-
-	saa7146_set_hps_source_and_sync(dev, input_port_selection[input].hps_source,
-			input_port_selection[input].hps_sync);
-
-	/* prepare switching of tea6415c and saa7111a;
-	   have a look at the 'background'-file for further informations  */
-	switch (input) {
-	case TUNER:
-		i = SAA7115_COMPOSITE0;
-
-		err = tea6415c_call(mxb, video, s_routing, 3, 17, 0);
-
-		/* connect tuner-output always to multicable */
-		if (!err)
-			err = tea6415c_call(mxb, video, s_routing, 3, 13, 0);
-		break;
-	case AUX3_YC:
-		/* nothing to be done here. aux3_yc is
-		   directly connected to the saa711a */
-		i = SAA7115_SVIDEO1;
-		break;
-	case AUX3:
-		/* nothing to be done here. aux3 is
-		   directly connected to the saa711a */
-		i = SAA7115_COMPOSITE1;
-		break;
-	case AUX1:
-		i = SAA7115_COMPOSITE0;
-		err = tea6415c_call(mxb, video, s_routing, 1, 17, 0);
-		break;
-	}
-
-	if (err)
-		return err;
-
-	/* switch video in saa7111a */
-	if (saa7111a_call(mxb, video, s_routing, i, SAA7111_FMT_CCIR, 0))
-		pr_err("VIDIOC_S_INPUT: could not address saa7111a\n");
-
-	mxb->cur_audinput = video_audio_connect[input];
-	/* switch the audio-source only if necessary */
-	if (0 == mxb->cur_mute)
-		tea6420_route(mxb, mxb->cur_audinput);
-	if (mxb->cur_audinput == 0)
-		mxb_update_audmode(mxb);
-
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	if (t->index) {
-		DEB_D("VIDIOC_G_TUNER: channel %d does not have a tuner attached\n",
-		      t->index);
-		return -EINVAL;
-	}
-
-	DEB_EE("VIDIOC_G_TUNER: %d\n", t->index);
-
-	memset(t, 0, sizeof(*t));
-	strlcpy(t->name, "TV Tuner", sizeof(t->name));
-	t->type = V4L2_TUNER_ANALOG_TV;
-	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO |
-			V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
-	t->audmode = mxb->cur_mode;
-	return call_all(dev, tuner, g_tuner, t);
-}
-
-static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	if (t->index) {
-		DEB_D("VIDIOC_S_TUNER: channel %d does not have a tuner attached\n",
-		      t->index);
-		return -EINVAL;
-	}
-
-	mxb->cur_mode = t->audmode;
-	return call_all(dev, tuner, s_tuner, t);
-}
-
-static int vidioc_querystd(struct file *file, void *fh, v4l2_std_id *norm)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-
-	return call_all(dev, video, querystd, norm);
-}
-
-static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency *f)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	if (f->tuner)
-		return -EINVAL;
-	*f = mxb->cur_freq;
-
-	DEB_EE("VIDIOC_G_FREQ: freq:0x%08x\n", mxb->cur_freq.frequency);
-	return 0;
-}
-
-static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency *f)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-	struct saa7146_vv *vv = dev->vv_data;
-
-	if (f->tuner)
-		return -EINVAL;
-
-	if (V4L2_TUNER_ANALOG_TV != f->type)
-		return -EINVAL;
-
-	DEB_EE("VIDIOC_S_FREQUENCY: freq:0x%08x\n", mxb->cur_freq.frequency);
-
-	/* tune in desired frequency */
-	tuner_call(mxb, tuner, s_frequency, f);
-	/* let the tuner subdev clamp the frequency to the tuner range */
-	tuner_call(mxb, tuner, g_frequency, f);
-	mxb->cur_freq = *f;
-	if (mxb->cur_audinput == 0)
-		mxb_update_audmode(mxb);
-
-	if (mxb->cur_input)
-		return 0;
-
-	/* hack: changing the frequency should invalidate the vbi-counter (=> alevt) */
-	spin_lock(&dev->slock);
-	vv->vbi_fieldcount = 0;
-	spin_unlock(&dev->slock);
-
-	return 0;
-}
-
-static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
-{
-	if (a->index >= MXB_AUDIOS)
-		return -EINVAL;
-	*a = mxb_audios[a->index];
-	return 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	DEB_EE("VIDIOC_G_AUDIO\n");
-	*a = mxb_audios[mxb->cur_audinput];
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	DEB_D("VIDIOC_S_AUDIO %d\n", a->index);
-	if (mxb_inputs[mxb->cur_input].audioset & (1 << a->index)) {
-		if (mxb->cur_audinput != a->index) {
-			mxb->cur_audinput = a->index;
-			tea6420_route(mxb, a->index);
-			if (mxb->cur_audinput == 0)
-				mxb_update_audmode(mxb);
-		}
-		return 0;
-	}
-	return -EINVAL;
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int vidioc_g_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (v4l2_chip_match_host(&reg->match)) {
-		reg->val = saa7146_read(dev, reg->reg);
-		reg->size = 4;
-		return 0;
-	}
-	call_all(dev, core, g_register, reg);
-	return 0;
-}
-
-static int vidioc_s_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (v4l2_chip_match_host(&reg->match)) {
-		saa7146_write(dev, reg->reg, reg->val);
-		reg->size = 4;
-		return 0;
-	}
-	return call_all(dev, core, s_register, reg);
-}
-#endif
-
-static struct saa7146_ext_vv vv_data;
-
-/* this function only gets called when the probing was successful */
-static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
-{
-	struct mxb *mxb;
-
-	DEB_EE("dev:%p\n", dev);
-
-	saa7146_vv_init(dev, &vv_data);
-	if (mxb_probe(dev)) {
-		saa7146_vv_release(dev);
-		return -1;
-	}
-	mxb = (struct mxb *)dev->ext_priv;
-
-	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
-	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
-	vv_data.vid_ops.vidioc_querystd = vidioc_querystd;
-	vv_data.vid_ops.vidioc_g_tuner = vidioc_g_tuner;
-	vv_data.vid_ops.vidioc_s_tuner = vidioc_s_tuner;
-	vv_data.vid_ops.vidioc_g_frequency = vidioc_g_frequency;
-	vv_data.vid_ops.vidioc_s_frequency = vidioc_s_frequency;
-	vv_data.vid_ops.vidioc_enumaudio = vidioc_enumaudio;
-	vv_data.vid_ops.vidioc_g_audio = vidioc_g_audio;
-	vv_data.vid_ops.vidioc_s_audio = vidioc_s_audio;
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	vv_data.vid_ops.vidioc_g_register = vidioc_g_register;
-	vv_data.vid_ops.vidioc_s_register = vidioc_s_register;
-#endif
-	if (saa7146_register_device(&mxb->video_dev, dev, "mxb", VFL_TYPE_GRABBER)) {
-		ERR("cannot register capture v4l2 device. skipping.\n");
-		saa7146_vv_release(dev);
-		return -1;
-	}
-
-	/* initialization stuff (vbi) (only for revision > 0 and for extensions which want it)*/
-	if (MXB_BOARD_CAN_DO_VBI(dev)) {
-		if (saa7146_register_device(&mxb->vbi_dev, dev, "mxb", VFL_TYPE_VBI)) {
-			ERR("cannot register vbi v4l2 device. skipping.\n");
-		}
-	}
-
-	pr_info("found Multimedia eXtension Board #%d\n", mxb_num);
-
-	mxb_num++;
-	mxb_init_done(dev);
-	return 0;
-}
-
-static int mxb_detach(struct saa7146_dev *dev)
-{
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	DEB_EE("dev:%p\n", dev);
-
-	/* mute audio on tea6420s */
-	tea6420_route(mxb, 6);
-
-	saa7146_unregister_device(&mxb->video_dev,dev);
-	if (MXB_BOARD_CAN_DO_VBI(dev))
-		saa7146_unregister_device(&mxb->vbi_dev, dev);
-	saa7146_vv_release(dev);
-
-	mxb_num--;
-
-	i2c_del_adapter(&mxb->i2c_adapter);
-	kfree(mxb);
-
-	return 0;
-}
-
-static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *standard)
-{
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	if (V4L2_STD_PAL_I == standard->id) {
-		v4l2_std_id std = V4L2_STD_PAL_I;
-
-		DEB_D("VIDIOC_S_STD: setting mxb for PAL_I\n");
-		/* These two gpio calls set the GPIO pins that control the tda9820 */
-		saa7146_write(dev, GPIO_CTRL, 0x00404050);
-		saa7111a_call(mxb, core, s_gpio, 0);
-		saa7111a_call(mxb, core, s_std, std);
-		if (mxb->cur_input == 0)
-			tuner_call(mxb, core, s_std, std);
-	} else {
-		v4l2_std_id std = V4L2_STD_PAL_BG;
-
-		if (mxb->cur_input)
-			std = standard->id;
-		DEB_D("VIDIOC_S_STD: setting mxb for PAL/NTSC/SECAM\n");
-		/* These two gpio calls set the GPIO pins that control the tda9820 */
-		saa7146_write(dev, GPIO_CTRL, 0x00404050);
-		saa7111a_call(mxb, core, s_gpio, 1);
-		saa7111a_call(mxb, core, s_std, std);
-		if (mxb->cur_input == 0)
-			tuner_call(mxb, core, s_std, std);
-	}
-	return 0;
-}
-
-static struct saa7146_standard standard[] = {
-	{
-		.name	= "PAL-BG", 	.id	= V4L2_STD_PAL_BG,
-		.v_offset	= 0x17,	.v_field 	= 288,
-		.h_offset	= 0x14,	.h_pixels 	= 680,
-		.v_max_out	= 576,	.h_max_out	= 768,
-	}, {
-		.name	= "PAL-I", 	.id	= V4L2_STD_PAL_I,
-		.v_offset	= 0x17,	.v_field 	= 288,
-		.h_offset	= 0x14,	.h_pixels 	= 680,
-		.v_max_out	= 576,	.h_max_out	= 768,
-	}, {
-		.name	= "NTSC", 	.id	= V4L2_STD_NTSC,
-		.v_offset	= 0x16,	.v_field 	= 240,
-		.h_offset	= 0x06,	.h_pixels 	= 708,
-		.v_max_out	= 480,	.h_max_out	= 640,
-	}, {
-		.name	= "SECAM", 	.id	= V4L2_STD_SECAM,
-		.v_offset	= 0x14,	.v_field 	= 288,
-		.h_offset	= 0x14,	.h_pixels 	= 720,
-		.v_max_out	= 576,	.h_max_out	= 768,
-	}
-};
-
-static struct saa7146_pci_extension_data mxb = {
-	.ext_priv = "Multimedia eXtension Board",
-	.ext = &extension,
-};
-
-static struct pci_device_id pci_tbl[] = {
-	{
-		.vendor    = PCI_VENDOR_ID_PHILIPS,
-		.device	   = PCI_DEVICE_ID_PHILIPS_SAA7146,
-		.subvendor = 0x0000,
-		.subdevice = 0x0000,
-		.driver_data = (unsigned long)&mxb,
-	}, {
-		.vendor	= 0,
-	}
-};
-
-MODULE_DEVICE_TABLE(pci, pci_tbl);
-
-static struct saa7146_ext_vv vv_data = {
-	.inputs		= MXB_INPUTS,
-	.capabilities	= V4L2_CAP_TUNER | V4L2_CAP_VBI_CAPTURE | V4L2_CAP_AUDIO,
-	.stds		= &standard[0],
-	.num_stds	= sizeof(standard)/sizeof(struct saa7146_standard),
-	.std_callback	= &std_callback,
-};
-
-static struct saa7146_extension extension = {
-	.name		= "Multimedia eXtension Board",
-	.flags		= SAA7146_USE_I2C_IRQ,
-
-	.pci_tbl	= &pci_tbl[0],
-	.module		= THIS_MODULE,
-
-	.attach		= mxb_attach,
-	.detach		= mxb_detach,
-
-	.irq_mask	= 0,
-	.irq_func	= NULL,
-};
-
-static int __init mxb_init_module(void)
-{
-	if (saa7146_register_extension(&extension)) {
-		DEB_S("failed to register extension\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void __exit mxb_cleanup_module(void)
-{
-	saa7146_unregister_extension(&extension);
-}
-
-module_init(mxb_init_module);
-module_exit(mxb_cleanup_module);
-
-MODULE_DESCRIPTION("video4linux-2 driver for the Siemens-Nixdorf 'Multimedia eXtension board'");
-MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
-MODULE_LICENSE("GPL");
-- 
1.7.11.2

