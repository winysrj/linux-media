Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12090 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0H2KxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 06:53:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L7W003P5U8LUA20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Sun, 29 Aug 2010 11:53:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L7W00E3JU8LBH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Sun, 29 Aug 2010 11:53:09 +0100 (BST)
Date: Sun, 29 Aug 2010 19:53:00 +0900
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/2] v4l: crossbar: add CrossBar driver
In-reply-to: <1283079180-4702-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.nazarewicz@samsung.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1283079180-4702-2-git-send-email-t.stanislaws@samsung.com>
References: <1283079180-4702-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The CrossBar driver allows to use one sensor by multiple
consumers. The CrossBar splits a single sensor V4L2 subdev
into multiple subdevs, which are registered into subdev pool.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 Documentation/video4linux/crossbar.txt |  155 +++++++++++++++
 drivers/media/video/Kconfig            |    8 +
 drivers/media/video/Makefile           |    1 +
 drivers/media/video/crossbar.c         |  339 ++++++++++++++++++++++++++++++++
 include/media/crossbar.h               |   34 ++++
 include/media/v4l2-subdev.h            |    4 +
 6 files changed, 541 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/crossbar.txt
 create mode 100644 drivers/media/video/crossbar.c
 create mode 100644 include/media/crossbar.h

Hello everyone,

On figure below a scenario with single sensor and multiple consumers
is depicted.  In order to use the same data stream by both processor,
they have to synchronize the stream properties like format, crop,
etc...  The processors communicate with camera using V4L2 subdev
interface.  At the moment there exit no infrastructure for splitting
control over single subdevice between multiple users.  The image
processor driver has to provide its own synchronization layer.  The
case becomes more complicated if every processor is controlled by
separate driver.

\--------+        +-------------------+
  sensor | --+--> | IMAGE PROCESSOR 0 | -----> MEMORY
/--------+   |    +-------------------+
             |        ^
             |        | format negotiations
             |        |
             |        v
             |    +-------------------+
             +--> | IMAGE PROCESSOR 1 | -----> MEMORY
                  +-------------------+

This patch introduces a CrossBar device that allows a single V4L
subdev to be easily shared among many consumers.  Please reffer to the
patch's body for documentation and examples.

Best regards,

Tomasz Stanislawski
Linux Platform Group
Samsung Poland R&D Center

diff --git a/Documentation/video4linux/crossbar.txt b/Documentation/video4linux/crossbar.txt
new file mode 100644
index 0000000..a7cff97
--- /dev/null
+++ b/Documentation/video4linux/crossbar.txt
@@ -0,0 +1,155 @@
+
+     MECHANICS of CROSSBAR
+
+1. Introduction.
+
+The Crossbar driver allows to split single V4L2 subdev (called the base) for
+sensor device into multiple subdevs (outputs). It is useful when multiple
+processing devices are connected to one sensor device. The crossbar allows to
+synchronize sensor configuration and stream data simultaneously.  Moreover, the
+crossbar provides management of subdevs context. The context consists of power
+and streaming state. Additionally state of each output subdev is kept.
+
+2. CrossBar internal variables.
+
+2.1. State counters for CrossBar instance.
+
+The variable power_cnt (stream_cnt) contains number of power (stream) enabling
+events. Calling s_power(..., 1) is an example of such events.  Only the first
+call to s_power(..., 1) is passed to the base subdevice.  Every time one of
+output subdevs calls s_power(..., 0) then power_cnt is decreased. When it
+reaches zero then call s_power(..., 0) is passed to the base subdevice.
+
+2.2. State flags for output subdevs.
+
+Every output subdev is enhanced with two types of flags. The software flags
+sw_flag mark that given subdev called a set-property function. Currently calls
+to s_fmt, s_ctrl, s_parm and s_mbus_fmt are tracked. Every property is marked
+by different bit. The second type of flags are hardware flags hw_flag. This
+flags mark that the property was successfully passes to base subdev.
+
+3. Streaming management.
+
+The streaming management is more complicated than power. The control system is
+based on following assumptions:
+
+	- it is not possible to change stream properties (like format, crop,
+	etc.) while streaming is on
+
+	- all drivers that use output subdevs must be notified that properties
+	of streaming were changed before starting streaming
+
+3.1. Management in no streaming state.
+
+All calls that setup streaming properties are passed to base subdev. Therefore
+both sw_flag and hw_flag for given output subdev are set. Passing property to
+base subdev erased previous configuration. So the hw_flag in all other output
+subdevs are cleared.
+
+3.2. Management in streaming state.
+
+This phase is started after the first output subdevice successfully calls
+s_stream(..., 1).  It is not possible to change any streaming property while
+streaming is on.  However it is not mandatory for a base subdev to accept
+configuration delivered in argument of set-property function (like s_fmt). The
+base subdev is allowed to change it. Therefore all s_{property} commands are
+implicitly changed to g_{property} commands by Crossbar. The family of
+g_{property} callback are used to acquire current configuration of the driver.
+For example, assume that at given time streaming in resolution 640x480 is
+executed. One of output devices have not started streaming yet. It tries to
+set resolution to 320x200 by calling s_fmt. The call succeeds but the
+resolution in function argument is changed to 640x480. The driver that uses
+output subdev must check and react adequately to new resolution. The driver is
+informed about the current property value therefore the flag in hw_flag is
+set.
+
+3.3. Starting streaming.
+
+Starting streaming is only possible if all enabled flags in sw_flag are also
+enabled in hw_flag. Otherwise the s_stream returns -EAGAIN error. This error
+informs that old configuration was lost and that it has to be refreshed. The
+driver has to execute all previous calls from s_{property} family in order to
+synchronize with current state of the base subdev. Please, note that values in
+argument of the call may be modified as described in point 3.2.
+
+4. Usage example.
+
+4.1. Configuring platform data.
+
+The code below defines an instance of CrossBar, which takes a subdev named
+"camera" with id 0 from the named subdev pool. The subdev changed into three
+new subdevs named "camera-crossbar0" and "camera-crossbar1" and "camera-crossbar2".
+
+#include <media/crossbar.h>
+static struct platform_device device_crossbar0 = {
+       .name           = CB_DEVICE_NAME,
+       .id             = 0,
+       .dev = {
+	       .platform_data = & (struct cb_platform_data) {
+		       .base_name = "camera",
+		       .output_fmt = "camera-crossbar%u", .output_cnt = 3,
+	       }
+       },
+};
+
+static struct platform_device *devices[] __initdata = {
+	... other platform devices, the driver that creates "camera" subdev
+	    must be loaded before crossbar ...
+	&device_crossbar0,
+};
+
+4.2. Usage of crossbar in the driver.
+
+Code below describes very simple subroutines for starting streaming from subdev
+that is shared between three driver instances. The instances are recognized
+by function argument id.
+
+struct v4l2_subdev *sd[3];
+
+int init(int id)
+{
+	/* acquiring subdev */
+	char buf[32];
+	sprintf(buf, "camera-crossbar%d", id);
+	sd[id] = v4l2_subdev_pool_get(buf);
+	v4l2_subdev_call(sd[id], core, s_power, 1);
+	return 0;
+}
+
+int deinit(int id)
+{
+	v4l2_subdev_call(sd[id], core, s_power, 0);
+	v4l2_subdev_pool_put(sd[i]);
+	return 0;
+}
+
+int sync_property(int id)
+{
+	struct v4l2_crop crop;
+	struct v4l2_format fmt;
+	... setting initial values of format and crop ...
+	v4l2_subdev_call(sd[i], video, s_fmt, &fmt);
+	... processing data in variable fmt ...
+	v4l2_subdev_call(sd[i], video, s_crop, &crop);
+	... processing data in variable crop ...
+	return 0;
+}
+
+
+int start_streaming(int id)
+{
+	int ret = 0;
+	do {
+		sync_property(id);
+		ret = (v4l2_subdev_call(sd[id], video, s_stream, 1);
+	} while (ret == -EAGAIN);
+	return ret;
+}
+
+int stop_streaming(int id)
+{
+	v4l2_subdev_call(sd[id], video, s_stream, 0);
+	return 0;
+}
+
+
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e968944..3a8fda8 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -903,6 +903,14 @@ config VIDEO_OMAP2
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
 
+config VIDEO_CROSSBAR
+	tristate "CrossBar interface"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select V4L2_SUBDEV_POOL
+	help
+	  CrossBar driver, allows configurable connetion between single sensor
+	  and multiple data consumers.
+
 config VIDEO_MX2_HOSTSUPPORT
         bool
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 40f98fb..6ec9458 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -149,6 +149,7 @@ obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
+obj-$(CONFIG_VIDEO_CROSSBAR)	+= crossbar.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
 obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
diff --git a/drivers/media/video/crossbar.c b/drivers/media/video/crossbar.c
new file mode 100644
index 0000000..8437372
--- /dev/null
+++ b/drivers/media/video/crossbar.c
@@ -0,0 +1,339 @@
+/*
+ * Samsung CrossBar interface driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include <media/crossbar.h>
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+
+#include <media/v4l2-subdev.h>
+
+MODULE_AUTHOR("Tomasz Stanislawski, t.stanislaws@samsung.com");
+MODULE_DESCRIPTION("Samsung CrossBar");
+MODULE_LICENSE("GPL");
+
+/** flags for marking subdev property */
+enum cb_sw_flag {
+	CBFL_FMT = 1,
+	CBFL_CTRL = 2,
+	CBFL_PARM = 4,
+	CBFL_MBUS_FMT = 8,
+};
+
+/** CrossBar internal structures and state */
+struct crossbar {
+	/** lock protecting access to subdev fields */
+	struct mutex lock;
+	/** original subdev callbacks from I2C device */
+	struct v4l2_subdev *sd_base;
+	/** number of output subdevs */
+	unsigned output_cnt;
+	/** output subdevs */
+	struct v4l2_subdev sd_output[CB_MAX_OUTPUTS];
+	/** subdev was-set flags */
+	u8 sw_flag[CB_MAX_OUTPUTS];
+	/** subdev in-hardware flags */
+	u8 hw_flag[CB_MAX_OUTPUTS];
+	/** number of power_on events */
+	int power_cnt;
+	/** number of stream on events */
+	int stream_cnt;
+};
+
+static int __devinit cb_setup_subdevs(struct device *dev, struct crossbar *cb,
+	char *fmt, unsigned cnt);
+
+static int __devinit cb_probe(struct platform_device *pdev)
+{
+	struct cb_platform_data *pdata;
+	struct crossbar *cb;
+	struct device *dev;
+	int ret = 0;
+
+	if (WARN_ON(pdev == NULL))
+		return -EINVAL;
+
+	pdata = pdev->dev.platform_data;
+	if (WARN_ON(pdata == NULL))
+		return -EINVAL;
+
+	dev = &pdev->dev;
+
+	dev_dbg(dev, "probing subdev %s\n", pdata->base_name);
+
+	cb = kzalloc(sizeof *cb, GFP_KERNEL);
+	if (cb == NULL) {
+		dev_err(dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	mutex_init(&cb->lock);
+
+	cb->sd_base = v4l2_subdev_pool_get(pdata->base_name);
+	WARN(!cb->sd_base, "base subdev %s not found\n", pdata->base_name);
+	if (!cb->sd_base)
+		return -ENODEV;
+
+	ret = cb_setup_subdevs(dev, cb, pdata->output_fmt, pdata->output_cnt);
+	if (ret) {
+		dev_err(dev, "could not create output subdevs\n");
+		kfree(cb);
+		return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, cb);
+
+	/* TODO: add support for V4L2 device notify */
+	dev_dbg(dev, "probe successful\n");
+
+	return 0;
+}
+
+static int __devexit cb_remove(struct platform_device *pdev)
+{
+	struct crossbar *cb = platform_get_drvdata(pdev);
+	int i;
+
+	if (WARN_ON(cb == NULL))
+		return -EINVAL;
+
+	platform_set_drvdata(pdev, NULL);
+	v4l2_subdev_pool_put(cb->sd_base);
+
+	/* cleaning all subdev */
+	for (i = 0; i < cb->output_cnt; ++i)
+		v4l2_subdev_pool_unregister(&cb->sd_output[i]);
+
+	kfree(cb);
+	dev_dbg(&pdev->dev, "removed\n");
+
+	return 0;
+}
+
+static struct platform_driver cb_driver __refdata = {
+	.probe = cb_probe,
+	.remove = __devexit_p(cb_remove),
+	.driver = {
+		.name = CB_DEVICE_NAME,
+		.owner = THIS_MODULE,
+	}
+};
+
+static char banner[] __initdata = KERN_INFO \
+	"Samsung CrossBar interface driver, (c) 2010 Samsung Electronics\n";
+
+static int __init cb_init(void)
+{
+	u32 ret;
+	printk(banner);
+
+	ret = platform_driver_register(&cb_driver);
+	if (ret != 0) {
+		printk(KERN_ERR "CrossBar platform driver register failed\n");
+		return -1;
+	}
+	return 0;
+}
+module_init(cb_init);
+
+static void __exit cb_exit(void)
+{
+	platform_driver_unregister(&cb_driver);
+}
+module_exit(cb_exit);
+
+static struct v4l2_subdev_ops cb_subdev_ops;
+
+static int __devinit cb_setup_subdevs(struct device *dev, struct crossbar *cb,
+	char *fmt, unsigned cnt)
+{
+	int ret;
+	unsigned i;
+	WARN(cnt > CB_MAX_OUTPUTS, "crossbar supports only %u output subdevs\n",
+		CB_MAX_OUTPUTS);
+	cnt = min(cnt, CB_MAX_OUTPUTS);
+	for (i = 0; i < cnt; ++i) {
+		struct v4l2_subdev *sd;
+		sd = &cb->sd_output[i];
+		/* setting callbacks */
+		v4l2_subdev_init(sd, &cb_subdev_ops);
+		v4l2_set_subdevdata(sd, cb);
+		/*
+		 * taking subdev will increase reference count of
+		 * owner module. Therefore crossbar module will
+		 * not be unloaded until all of its subdevs are
+		 * freed
+		 */
+		sd->owner = THIS_MODULE;
+		snprintf(sd->name, V4L2_SUBDEV_NAME_SIZE, fmt, i);
+		ret = v4l2_subdev_pool_register(sd, THIS_MODULE);
+		if (ret) {
+			dev_err(dev, "failed to register subdev %s\n",
+				sd->name);
+			goto error;
+		}
+	}
+	cb->output_cnt = cnt;
+	return 0;
+error:
+	/* unregistering already registered subdevices */
+	while (i-- > 0)
+		v4l2_subdev_pool_unregister(&cb->sd_output[i]);
+	return ret;
+}
+
+/* acquiring the CrossBar instance, generation of basic debugs */
+static struct crossbar *__cb_prologue(struct v4l2_subdev *sd, const char *func)
+{
+	struct crossbar *cb = v4l2_get_subdevdata(sd);
+	mutex_lock(&cb->lock);
+	printk(KERN_DEBUG "%s(sd->name = %s)\n", func, sd->name);
+	return cb;
+}
+
+/* releasing the CrossBar instance, generation of basic debugs */
+static void __cb_epilogue(struct v4l2_subdev *sd, const char *func)
+{
+	struct crossbar *cb = v4l2_get_subdevdata(sd);
+	int idx = sd - cb->sd_output;
+	printk(KERN_DEBUG "%s(%s) - HW(%02x) SW(%02x)\n",
+		func, sd->name, cb->hw_flag[idx], cb->sw_flag[idx]);
+	printk(KERN_DEBUG "%s(%s) - power(%d) stream(%d)\n",
+		func, sd->name, cb->power_cnt, cb->stream_cnt);
+	mutex_unlock(&cb->lock);
+}
+
+/* templates for call transparent for both master and slave */
+#define CBCALL_PASS1(ops, func, type1) \
+static int cb_ ## ops ## _ ## func(struct v4l2_subdev *sd, type1 arg1) \
+{ \
+	struct crossbar *cb = __cb_prologue(sd, __func__); \
+	int ret; \
+	ret = v4l2_subdev_call(cb->sd_base, ops, func, arg1); \
+	__cb_epilogue(sd, __func__); \
+	return ret; \
+}
+
+/* template for callback where set operation is proxyed to get */
+#define CBCALL_SET1(ops, suffix, flag, type1) \
+static int cb_ ## ops ## _s_ ## suffix(struct v4l2_subdev *sd, type1 arg1) \
+{ \
+	struct crossbar *cb =  __cb_prologue(sd, __func__); \
+	int ret = 0; \
+	int idx = sd - cb->sd_output; \
+	cb->sw_flag[idx] |= flag; \
+	if (cb->stream_cnt > 0) { \
+		ret = v4l2_subdev_call(cb->sd_base, ops, g_ ## suffix, arg1); \
+		cb->hw_flag[idx] |= flag; \
+	} else { \
+		ret = v4l2_subdev_call(cb->sd_base, ops, s_ ## suffix, arg1); \
+		if (ret == 0) { \
+			unsigned i; \
+			for (i = 0; i < cb->output_cnt; ++i) \
+				cb->hw_flag[i] &= ~flag; \
+			cb->hw_flag[idx] |= flag; \
+		} \
+	} \
+	__cb_epilogue(sd, __func__); \
+	return ret; \
+}
+
+CBCALL_PASS1(core, g_ctrl, struct v4l2_control *)
+CBCALL_SET1(core, ctrl, CBFL_CTRL, struct v4l2_control *)
+
+static int cb_core_s_power(struct v4l2_subdev *sd, int en)
+{
+	struct crossbar *cb = __cb_prologue(sd, __func__);
+	int ret = 0;
+	int idx = sd - cb->sd_output;
+	if (en && cb->power_cnt == 0)
+		ret = v4l2_subdev_call(cb->sd_base, core, s_power, 1);
+	if (!en && cb->power_cnt == 1)
+		ret = v4l2_subdev_call(cb->sd_base, core, s_power, 0);
+	if (ret == 0 || ret == -ENOIOCTLCMD) {
+		/* power status change erases all configuration */
+		cb->hw_flag[idx] = 0;
+		cb->sw_flag[idx] = 0;
+		cb->power_cnt += en ? 1 : -1;
+	}
+	__cb_epilogue(sd, __func__); \
+	return ret;
+}
+
+static struct v4l2_subdev_core_ops cb_core_ops = {
+	.g_ctrl  = cb_core_g_ctrl,
+	.s_ctrl  = cb_core_s_ctrl,
+	.s_power = cb_core_s_power,
+};
+
+CBCALL_PASS1(video, enum_fmt, struct v4l2_fmtdesc *)
+CBCALL_PASS1(video, g_fmt, struct v4l2_format *)
+CBCALL_SET1(video, fmt, CBFL_FMT, struct v4l2_format *)
+CBCALL_PASS1(video, g_mbus_fmt, struct v4l2_mbus_framefmt *)
+CBCALL_SET1(video, mbus_fmt, CBFL_MBUS_FMT, struct v4l2_mbus_framefmt *)
+CBCALL_PASS1(video, cropcap, struct v4l2_cropcap *)
+
+static int cb_video_s_stream(struct v4l2_subdev *sd, int en)
+{
+	struct crossbar *cb = __cb_prologue(sd, __func__);
+	int ret = 0;
+	int idx = sd - cb->sd_output;
+	int hw_flags, sw_flags;
+	if (en) {
+		sw_flags = cb->sw_flag[idx];
+		hw_flags = cb->hw_flag[idx];
+		if ((sw_flags & hw_flags) != sw_flags) {
+			ret = -EAGAIN;
+			goto cleanup;
+		}
+		if (cb->stream_cnt == 0)
+			ret = v4l2_subdev_call(cb->sd_base, video, s_stream, 1);
+		if (ret == 0 || ret == -ENOIOCTLCMD)
+			++cb->stream_cnt;
+	} else {
+		if (cb->stream_cnt == 1)
+			ret = v4l2_subdev_call(cb->sd_base, video, s_stream, 0);
+		if (ret == 0 || ret == -ENOIOCTLCMD)
+			--cb->stream_cnt;
+	}
+cleanup:
+	__cb_epilogue(sd, __func__); \
+	return ret;
+}
+
+static struct v4l2_subdev_video_ops cb_video_ops = {
+	.enum_fmt   = cb_video_enum_fmt,
+	.g_fmt      = cb_video_g_fmt,
+	.s_fmt      = cb_video_s_fmt,
+	.s_mbus_fmt = cb_video_s_mbus_fmt,
+	.g_mbus_fmt = cb_video_g_mbus_fmt,
+	.s_stream   = cb_video_s_stream,
+	.cropcap    = cb_video_cropcap,
+};
+
+static struct v4l2_subdev_ops cb_subdev_ops = {
+	.core = &cb_core_ops,
+	.video = &cb_video_ops,
+};
+
diff --git a/include/media/crossbar.h b/include/media/crossbar.h
new file mode 100644
index 0000000..6c74438
--- /dev/null
+++ b/include/media/crossbar.h
@@ -0,0 +1,34 @@
+/* linux/include/media/crossbar.h
+ *
+ * Platform header file for CrossBar driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CROSSBAR_H_
+#define CROSSBAR_H_
+
+/** maximal number of output subdev for single crossbar instance */
+#define CB_MAX_OUTPUTS 3U
+
+/** name of crossbar device */
+#define CB_DEVICE_NAME "samsung-crossbar"
+
+/** configuration of CrossBar device */
+struct cb_platform_data {
+	/** name of subdev to be split */
+	char *base_name;
+	/** format for name of output subdevs, must contain single %u */
+	char *output_fmt;
+	/** number of output subdevs */
+	unsigned output_cnt;
+};
+
+#endif /* CROSSBAR_H_ */
+
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0c44b4f..d2a93ed 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -248,6 +248,10 @@ struct v4l2_subdev_audio_ops {
    try_mbus_fmt: try to set a pixel format on a video data source
 
    s_mbus_fmt: set a pixel format on a video data source
+
+   s_stream: starts data processing in device,
+	error -EAGAIN is returned if device configuration was lost, the driver
+	must repeat all previous calls like s_* except s_power and s_stream
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
-- 
1.7.1

