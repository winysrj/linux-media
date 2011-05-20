Return-path: <mchehab@pedra>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:26964 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203Ab1ETLPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 07:15:08 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev
 =?iso-8859-1?q?registration=09function?=
Date: Fri, 20 May 2011 13:14:42 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	michael.jones@matrix-vision.de
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com> <201105201152.17414.hansverk@cisco.com> <201105201212.24046.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105201212.24046.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201314.42836.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, May 20, 2011 12:12:23 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 20 May 2011 11:52:17 Hans Verkuil wrote:
> > On Friday, May 20, 2011 11:37:24 Laurent Pinchart wrote:
> > > On Friday 20 May 2011 11:19:48 Hans Verkuil wrote:
> > > > On Friday, May 20, 2011 11:05:00 Laurent Pinchart wrote:
> 
> [snip]
> 
> > > > > My idea was to use bus notifiers to delay the bridge/host device
> > > > > initialization. The bridge probe() function would pre-initialize the
> > > > > bridge and register notifiers. The driver would then wait until all
> > > > > subdevs are properly registered, and then proceed from to register
> > > > > V4L2 devices from the bus notifier callback (or possible a work
> > > > > queue). There would be no nested probe() calls.
> > > > 
> > > > Would it be an option to create a new platform bus for the subdevs?
> > > > That would have its own lock. It makes sense from a hierarchical point
> > > > of view, but I'm not certain about the amount of work involved.
> > > 
> > > Do you mean a subdev-platform bus for platform subdevs, or a V4L2 subdev
> > > bus for all subdevs ? The first option is possible, but it looks more
> > > like a hack to me. If the subdev really is a platform device, it should be
> > > handled by the platform bus.
> > 
> > The first. So you have a 'top-level' platform device that wants to load
> > platform subdevs (probably representing internal IP blocks). So it would
> > create its own platform bus that is used to probe those platform subdevs.
> > 
> > It is similar to e.g. an I2C device that has internal I2C busses: you would
> > also create nested busses there.
> > 
> > BTW, why do these platform subdevs have to be on the platform bus? Why not
> > have standalone subdev drivers that are not on any bus? That's for example
> > what ivtv does for the internal GPIO audio subdev.
> 
> There's some misunderstanging here. Internal IP blocks don't need to sit on 
> any bus. The host/bridge driver can create subdevs for those blocks directly, 
> as it doesn't need to load a separate driver.
> 
> The issue comes from external subdevs that offer little control or even none 
> at all. The best example is an FPGA that will feed video data to the bridge in 
> a fixed format without any mean of control, or with just an on/off control 
> through a GPIO. Support for such subdevices need to be handled by a separate 
> driver, so we need a way to load it at runtime. I'm not sure on what bus that 
> driver should sit.
> 
> > > I don't think the second option is possible, I2C and SPI subdevs need to
> > > sit on an I2C or SPI bus (I could be mistaken though, there's at least
> > > one example of a logical bus type in the kernel with the HID bus).
> > > 
> > > Let's also not forget about sub-sub-devices. We need to handle them at
> > > some point as well.
> > 
> > Sub-sub-devices are not a problem by themselves. They are only a problem if
> > they on the same bus.
> > 
> > > This being said, I think that the use of platform devices to solve the
> > > initial problem can also be considered a hack as well. What we really need
> > > is a way to handle subdevs that can't be controlled at all (a video source
> > > that continuously delivers data for instance), or that can be controlled
> > > through GPIO. What bus should we use for a bus-less subdev ? And for
> > > GPIO-based subdevs, should we create a GPIO bus ?
> > 
> > It is perfectly possible to have bus-less subdevs. See ivtv (I think there
> > are one or two other examples as well).
> 
> But how can we handle bus-less subdevs for embedded devices, where the host 
> (e.g. OMAP3 ISP) doesn't know about the external subdevs (e.g. FPGA controlled 
> by a couple of GPIOs) ?
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

I remembered that we had to do something similar and I found the patch below.
This was the result of some private discussions with Vaibhav Hiremath from TI.

It almost certainly doesn't apply to the current kernel, but it is clear
what happens.

We are actually using this with the dm6467 capture driver.

Hope this might at least give some ideas.

Regards,

	Hans

From: Mats Randgaard <mats.randgaard@cisco.com>
Subject: [PATCH 6/6] FPGA subdevice driver
Date: Thu,  2 Dec 2010 08:40:10 +0100

This subdevice driver can be used with custom made subdevices (e.g. FPGA's) that
need some or no configuration. The driver calls functions specified in the board
definition file.

Signed-off-by: Mats Randgaard <mats.randgaard@cisco.com>
---
 arch/arm/mach-davinci/board-dm646x-evm.c   |   38 +++++++++++
 drivers/media/video/Kconfig                |    8 ++
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/davinci/vpif_capture.c |   21 ++++--
 drivers/media/video/fpga_subdev.c          |   97 ++++++++++++++++++++++++++++
 include/media/fpga_subdev.h                |   44 +++++++++++++
 6 files changed, 203 insertions(+), 6 deletions(-)
 create mode 100644 drivers/media/video/fpga_subdev.c
 create mode 100644 include/media/fpga_subdev.h

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index f6ac9ba..458f593 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -25,6 +25,7 @@
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pcf857x.h>
 
+#include <media/fpga_subdev.h>
 #include <media/tvp514x.h>
 
 #include <linux/mtd/mtd.h>
@@ -485,12 +486,14 @@ static int set_vpif_clock(int mux_mode, int hd)
 }
 
 static struct vpif_subdev_info dm646x_vpif_subdev[] = {
+#if 0
 	{
 		.name	= "adv7343",
 		.board_info = {
 			I2C_BOARD_INFO("adv7343", 0x2a),
 		},
 	},
+#endif
 	{
 		.name	= "ths7303",
 		.board_info = {
@@ -595,10 +598,43 @@ static struct tvp514x_platform_data tvp5146_pdata = {
 	.vs_polarity = 1
 };
 
+int dm646x_subdev_s_power(struct fpga_subdev_platform_data *pdata,
+		struct v4l2_subdev *sd, int on)
+{
+	printk(KERN_DEBUG "%s: Power %s\n", __func__, on ? "on" : "off");
+
+	return 0;
+}
+
+int dm646x_subdev_s_stream(struct fpga_subdev_platform_data *pdata,
+		struct v4l2_subdev *sd, int enable)
+{
+	printk(KERN_DEBUG "%s: Stream %s\n", __func__,
+			enable ? "enabled" : "disabled");
+
+	return 0;
+}
+
+static struct fpga_subdev_ops dm646x_subdev_ops = {
+	.s_stream = dm646x_subdev_s_stream,
+	.s_power = dm646x_subdev_s_power,
+};
+
+struct fpga_subdev_platform_data dm646x_subdev_pdata = {
+	.ops = &dm646x_subdev_ops,
+};
+
 #define TVP514X_STD_ALL (V4L2_STD_NTSC | V4L2_STD_PAL)
 
 static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 	{
+		.name	= "fpga_subdev",
+		.board_info = {
+			.platform_data = &dm646x_subdev_pdata,
+		},
+	},
+#if 0
+	{
 		.name	= TVP5147_CH0,
 		.board_info = {
 			I2C_BOARD_INFO("tvp5146", 0x5d),
@@ -630,6 +666,7 @@ static struct vpif_subdev_info vpif_capture_sdev_info[] = {
 			.fid_pol = 0,
 		},
 	},
+#endif
 };
 
 static const struct vpif_input dm6467_ch0_inputs[] = {
@@ -669,6 +706,7 @@ static struct vpif_capture_config dm646x_vpif_capture_cfg = {
 		.inputs = dm6467_ch1_inputs,
 		.input_count = ARRAY_SIZE(dm6467_ch1_inputs),
 	},
+	.card_name = "DM646x EVM",
 };
 
 static void __init evm_init_video(void)
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f6e4d04..49335b0 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -114,6 +114,14 @@ config VIDEO_IR_I2C
 menu "Encoders/decoders and other helper chips"
 	depends on !VIDEO_HELPER_CHIPS_AUTO
 
+config VIDEO_FPGA_SUBDEV
+	tristate "Subdevice for custom made chips"
+	depends on VIDEO_V4L2
+	---help---
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fpga-subdev.
+
 comment "Audio decoders"
 
 config VIDEO_TVAUDIO
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 40f98fb..3ce4434 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
 # And now the v4l2 drivers:
 
+obj-$(CONFIG_VIDEO_FPGA_SUBDEV) += fpga_subdev.o
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_ZORAN) += zoran/
 obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 14b9adb..1305c66 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -38,6 +38,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/fpga_subdev.h>
 
 #include "vpif_capture.h"
 #include "vpif.h"
@@ -2319,12 +2320,20 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	for (i = 0; i < subdev_count; i++) {
 		subdevdata = &config->subdev_info[i];
-		vpif_obj.sd[i] =
-			v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
-						  i2c_adap,
-						  subdevdata->name,
-						  &subdevdata->board_info,
-						  NULL);
+		if (subdevdata->board_info.addr) {
+			/* i2c device */
+			vpif_obj.sd[i] =
+				v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
+						i2c_adap,
+						NULL,
+						&subdevdata->board_info,
+						NULL);
+		} else {
+			/* custom platform device */
+			vpif_obj.sd[i] =
+				fpga_subdev_init(&vpif_obj.v4l2_dev,
+						subdevdata->board_info.platform_data);
+		}
 
 		if (!vpif_obj.sd[i]) {
 			vpif_err("Error registering v4l2 subdevice\n");
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 14b9adb..1305c66 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/version.h>
 #include <linux/slab.h>
+#include <media/fpga_subdev.h>
 
 #include <asm/irq.h>
 #include <asm/page.h>
@@ -1739,7 +1742,7 @@
 	/* Allocate memory for six channel objects */
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		vpif_obj.dev[i] =
-		    kmalloc(sizeof(struct channel_obj), GFP_KERNEL);
+		    kzalloc(sizeof(struct channel_obj), GFP_KERNEL);
 		/* If memory allocation fails, return error */
 		if (!vpif_obj.dev[i]) {
 			free_channel_objects_index = i;
@@ -1897,10 +1900,18 @@
 	}
 
 	for (i = 0; i < subdev_count; i++) {
-		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
+		if (subdevdata[i].board_info.addr) {
+			/* i2c device */
+			vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
 						i2c_adap, subdevdata[i].name,
 						&subdevdata[i].board_info,
 						NULL);
+		} else {
+			/* custom platform device */
+			vpif_obj.sd[i] =
+				fpga_subdev_init(&vpif_obj.v4l2_dev,
+						subdevdata[i].board_info.platform_data);
+		}
 		if (!vpif_obj.sd[i]) {
 			vpif_err("Error registering v4l2 subdevice\n");
 			goto probe_subdev_out;
diff --git a/drivers/media/video/fpga_subdev.c b/drivers/media/video/fpga_subdev.c
new file mode 100644
index 0000000..b57fe81
--- /dev/null
+++ b/drivers/media/video/fpga_subdev.c
@@ -0,0 +1,97 @@
+/*
+ * This subdevice driver can be used with custom made subdevices (e.g. FPGA's)
+ * that need some or no configuration. The driver calls functions specified in
+ * the board definition file.
+ *
+ * Copyright (C) 2010 Cisco Systems AS
+ * Author: Mats Randgaard <mats.randgaard@cisco.com>
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <media/fpga_subdev.h>
+#include <media/v4l2-device.h>
+
+MODULE_DESCRIPTION("FPGA subdevice");
+MODULE_AUTHOR("Mats Randgaard <mats.randgaard@cisco.com>");
+MODULE_LICENSE("GPL");
+
+/* Debug functions */
+static int debug;
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Debug level (0-2)");
+
+static int fpga_subdev_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct fpga_subdev_platform_data *pdata = v4l2_get_subdevdata(sd);
+
+	if (!pdata || !pdata->ops || !pdata->ops->s_power)
+		return -ENOIOCTLCMD;
+
+	return pdata->ops->s_power(pdata, sd, on);
+}
+
+static int fpga_subdev_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct fpga_subdev_platform_data *pdata = v4l2_get_subdevdata(sd);
+
+	if (!pdata || !pdata->ops || !pdata->ops->s_stream)
+		return -ENOIOCTLCMD;
+
+	return pdata->ops->s_stream(pdata, sd, enable);
+}
+
+static const struct v4l2_subdev_core_ops fpga_subdev_core_ops = {
+	.s_power = fpga_subdev_s_power,
+};
+
+static const struct v4l2_subdev_video_ops fpga_subdev_video_ops = {
+	.s_stream = fpga_subdev_s_stream,
+};
+
+static const struct v4l2_subdev_ops fpga_subdev_ops = {
+	.core = &fpga_subdev_core_ops,
+	.video = &fpga_subdev_video_ops,
+};
+
+
+struct v4l2_subdev *fpga_subdev_init(struct v4l2_device *v4l2_dev,
+		struct fpga_subdev_platform_data *platform_data)
+{
+	struct v4l2_subdev *sd;
+
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	if (!sd) {
+		v4l2_err(v4l2_dev, "unable to allocate memory for subdevice\n");
+		return NULL;
+	}
+
+	v4l2_subdev_init(sd, &fpga_subdev_ops);
+
+	v4l2_set_subdevdata(sd, platform_data);
+
+	snprintf(sd->name, sizeof(sd->name), "%s fpga-subdev", v4l2_dev->name);
+
+	if (v4l2_device_register_subdev(v4l2_dev, sd)) {
+		kfree(sd);
+		v4l2_err(v4l2_dev, "unable to register v4l2 device\n");
+		return NULL;
+	}
+
+	v4l2_info(sd, "%s driver registered\n", sd->name);
+
+	return sd;
+}
diff --git a/include/media/fpga_subdev.h b/include/media/fpga_subdev.h
new file mode 100644
index 0000000..0651c05
--- /dev/null
+++ b/include/media/fpga_subdev.h
@@ -0,0 +1,44 @@
+/*
+ * This subdevice driver can be used with custom made subdevices (e.g. FPGA's)
+ * that need some or no configuration. The driver calls functions specified in
+ * the board definition file.
+ *
+ * Copyright (C) 2010 Cisco Systems AS
+ * Author: Mats Randgaard <mats.randgaard@cisco.com>
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _FPGA_SUBDEV_H_
+#define _FPGA_SUBDEV_H_
+
+#include <media/v4l2-subdev.h>
+
+struct fpga_subdev_platform_data;
+
+struct fpga_subdev_ops {
+	int (*s_stream)(struct fpga_subdev_platform_data *pdata,
+			struct v4l2_subdev *sd, int enable);
+	int (*s_power)(struct fpga_subdev_platform_data *pdata,
+			struct v4l2_subdev *sd, int on);
+};
+
+struct fpga_subdev_platform_data {
+	void *priv;
+	struct fpga_subdev_ops *ops;
+};
+
+struct v4l2_subdev *fpga_subdev_init(struct v4l2_device *v4l2_dev,
+		struct fpga_subdev_platform_data *platform_data);
+#endif
-- 
1.7.1

