Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8662 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3EFJeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 05:34:36 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 1/2] v4l2-leddev: added LED class support for V4L2 flash
 subdevices
Date: Mon, 06 May 2013 11:33:47 +0200
Message-id: <1367832828-30771-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
References: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds helper functions for exposing V4L2 flash
subdevice as LED class device. For such device there will be
created appropriate entry in <sysfs>/class/leds/ directory with
standard LED class attributes and attributes corresponding
to V4L2 flash controls exposed by the subdevice.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/Kconfig       |    7 +
 drivers/media/v4l2-core/Makefile      |    1 +
 drivers/media/v4l2-core/v4l2-leddev.c |  269 +++++++++++++++++++++++++++++++++
 include/media/v4l2-leddev.h           |   49 ++++++
 4 files changed, 326 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-leddev.c
 create mode 100644 include/media/v4l2-leddev.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 8c05565..c32b7f2 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -35,6 +35,13 @@ config V4L2_MEM2MEM_DEV
         tristate
         depends on VIDEOBUF2_CORE
 
+# Used by drivers that need v4l2-leddev.ko
+config V4L2_LEDDEV
+	tristate "LED support for V4L2 flash subdevices"
+	depends on VIDEO_V4L2 && LEDS_CLASS
+	---help---
+	  This option enables LED class support for V4L2 flash devices.
+
 # Used by drivers that need Videobuf modules
 config VIDEOBUF_GEN
 	tristate
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index aa50c46..2906c7c 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
+obj-$(CONFIG_V4L2_LEDDEV) += v4l2-leddev.o
 
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
diff --git a/drivers/media/v4l2-core/v4l2-leddev.c b/drivers/media/v4l2-core/v4l2-leddev.c
new file mode 100644
index 0000000..f41885e
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-leddev.c
@@ -0,0 +1,269 @@
+/*
+ * V4L2 API for exposing flash subdevs as LED class devices
+ *
+ * Copyright (C) 2013, Samsung Electronics Co., Ltd.
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-leddev.h>
+
+struct v4l2_leddev_attr {
+	u32 ctrl_id;
+	u8 name[32];
+	struct device_attribute dattr;
+};
+
+struct v4l2_leddev_attr *to_v4l2_leddev_attr(struct device_attribute *da)
+{
+	return container_of(da, struct v4l2_leddev_attr, dattr);
+}
+
+struct v4l2_leddev *to_v4l2_leddev(struct led_classdev *cdev)
+{
+	return container_of(cdev, struct v4l2_leddev, cdev);
+}
+
+static void v4l2_leddev_brightness_set(struct led_classdev *cdev,
+				       enum led_brightness value)
+{
+	struct v4l2_ext_control ctrls[2] = {
+		{
+			.id = V4L2_CID_FLASH_LED_MODE,
+			.value = value ? V4L2_FLASH_LED_MODE_TORCH
+				       : V4L2_FLASH_LED_MODE_NONE,
+		},
+		{
+			.id = V4L2_CID_FLASH_TORCH_INTENSITY,
+			.value = value
+		}
+
+	};
+	struct v4l2_ext_controls ext_ctrls = {
+		.ctrl_class = V4L2_CTRL_CLASS_FLASH,
+		.controls = ctrls,
+		.count = value ? 2 : 1,
+	};
+	struct v4l2_leddev *ld = to_v4l2_leddev(cdev);
+
+	v4l2_subdev_s_ext_ctrls(ld->sd, &ext_ctrls);
+}
+
+static enum led_brightness v4l2_leddev_brightness_get(struct led_classdev *cdev)
+{
+	struct v4l2_ext_control ctrls[2] = {
+		{
+			.id = V4L2_CID_FLASH_LED_MODE,
+		},
+		{
+			.id = V4L2_CID_FLASH_TORCH_INTENSITY,
+		},
+
+	};
+	struct v4l2_ext_controls ext_ctrls = {
+		.ctrl_class = V4L2_CTRL_CLASS_FLASH,
+		.controls = ctrls,
+		.count = 2,
+	};
+	struct v4l2_leddev *ld = to_v4l2_leddev(cdev);
+	int ret;
+
+	ret = v4l2_subdev_g_ext_ctrls(ld->sd, &ext_ctrls);
+
+	if (ret || ctrls[0].value != V4L2_FLASH_LED_MODE_TORCH)
+		return 0;
+
+	return ctrls[1].value;
+}
+
+static ssize_t v4l2_leddev_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *cdev = dev_get_drvdata(dev);
+	struct v4l2_leddev *ld = to_v4l2_leddev(cdev);
+	struct v4l2_leddev_attr *ldattr = to_v4l2_leddev_attr(attr);
+	struct v4l2_ext_control ctrl = {
+		.id = ldattr->ctrl_id,
+	};
+	struct v4l2_ext_controls ext_ctrls = {
+		.ctrl_class = V4L2_CTRL_CLASS_FLASH,
+		.controls = &ctrl,
+		.count = 1,
+	};
+	int ret;
+
+	ret = v4l2_subdev_g_ext_ctrls(ld->sd, &ext_ctrls);
+	if (ret)
+		return 0;
+
+	return sprintf(buf, "%d\n", ctrl.value);
+}
+
+static ssize_t v4l2_leddev_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t size)
+{
+	struct led_classdev *cdev = dev_get_drvdata(dev);
+	struct v4l2_leddev *ld = to_v4l2_leddev(cdev);
+	struct v4l2_leddev_attr *ldattr = to_v4l2_leddev_attr(attr);
+	struct v4l2_ext_control ctrl = {
+		.id = ldattr->ctrl_id,
+	};
+	struct v4l2_ext_controls ext_ctrls = {
+		.ctrl_class = V4L2_CTRL_CLASS_FLASH,
+		.controls = &ctrl,
+		.count = 1,
+	};
+	int ret;
+
+	ret = kstrtos32(buf, 0, &ctrl.value);
+	if (!ret)
+		ret = v4l2_subdev_s_ext_ctrls(ld->sd, &ext_ctrls);
+
+	return ret ? 0 : size;
+}
+
+static int v4l2_leddev_ctrls_count(struct v4l2_leddev *ld)
+{
+	struct v4l2_queryctrl qc = {
+		.id = V4L2_CID_FLASH_CLASS | V4L2_CTRL_FLAG_NEXT_CTRL,
+	};
+	int n = 0;
+
+	while (v4l2_queryctrl(ld->sd->ctrl_handler, &qc) == 0) {
+		if (V4L2_CTRL_ID2CLASS (qc.id) != V4L2_CTRL_CLASS_FLASH)
+			break;
+		++n;
+		qc.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
+	}
+	return n;
+}
+
+static int v4l2_leddev_create_attrs(struct v4l2_leddev *ld)
+{
+	struct v4l2_queryctrl qc = {
+		.id = V4L2_CID_FLASH_CLASS | V4L2_CTRL_FLAG_NEXT_CTRL,
+	};
+	int i = 0;
+	int ret;
+
+	ld->attr_count = v4l2_leddev_ctrls_count(ld);
+	ld->attrs = kzalloc(sizeof(*ld->attrs) * ld->attr_count, GFP_KERNEL);
+	if (!ld->attrs)
+		return -ENOMEM;
+
+	while (v4l2_queryctrl(ld->sd->ctrl_handler, &qc) == 0) {
+		struct v4l2_leddev_attr *attr = &ld->attrs[i];
+		if (V4L2_CTRL_ID2CLASS (qc.id) != V4L2_CTRL_CLASS_FLASH)
+			break;
+
+		attr->ctrl_id = qc.id;
+		strncpy(attr->name, qc.name, sizeof(attr->name));
+		attr->dattr.attr.name = attr->name;
+		if (!(qc.flags & V4L2_CTRL_FLAG_READ_ONLY)) {
+			attr->dattr.store = v4l2_leddev_store;
+			attr->dattr.attr.mode |= 0220;
+		}
+		if (!(qc.flags & V4L2_CTRL_FLAG_WRITE_ONLY)) {
+			attr->dattr.show = v4l2_leddev_show;
+			attr->dattr.attr.mode |= 0444;
+		}
+		v4l2_info(ld->sd, "creating attr %s(%d/%d)\n", attr->name, i,
+			  ld->attr_count);
+		ret = device_create_file(ld->cdev.dev, &attr->dattr);
+		if (!ret) {
+			if (++i == ld->attr_count)
+				break;
+		} else {
+			v4l2_err(ld->sd, "error creating attr %s (%d)\n",
+				 attr->name, ret);
+		}
+
+		qc.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
+	}
+	ld->attr_count = i;
+	return 0;
+}
+
+static void v4l2_leddev_remove_attrs(struct v4l2_leddev *ld)
+{
+	int i;
+
+	for (i = ld->attr_count - 1; i >= 0; --i)
+		device_remove_file(ld->cdev.dev, &ld->attrs[i].dattr);
+
+	kfree(ld->attrs);
+	ld->attrs = NULL;
+	ld->attr_count = 0;
+}
+
+static int v4l2_leddev_get_max_brightness(struct v4l2_leddev *ld)
+{
+	struct v4l2_queryctrl qc = {
+		.id = V4L2_CID_FLASH_TORCH_INTENSITY,
+	};
+	int ret;
+
+	ret = v4l2_queryctrl(ld->sd->ctrl_handler, &qc);
+	if (ret) {
+		v4l2_err(ld->sd, "cannot query torch intensity (%d)\n", ret);
+		return 0;
+	}
+	return qc.maximum;
+}
+
+int v4l2_leddev_register(struct device *dev, struct v4l2_leddev *ld)
+{
+	int ret;
+
+	if (!ld->sd) {
+		dev_err(dev, "cannot register leddev without subdev provided\n");
+		return -EINVAL;
+	}
+	if (!ld->cdev.name)
+		ld->cdev.name = ld->sd->name;
+	if (!ld->cdev.max_brightness)
+		ld->cdev.max_brightness = v4l2_leddev_get_max_brightness(ld);
+	if (!ld->cdev.brightness_set)
+		ld->cdev.brightness_set = v4l2_leddev_brightness_set;
+	if (!ld->cdev.brightness_get)
+		ld->cdev.brightness_get = v4l2_leddev_brightness_get;
+
+	ret = led_classdev_register(dev, &ld->cdev);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_leddev_create_attrs(ld);
+	if (ret < 0)
+		led_classdev_unregister(&ld->cdev);
+
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_leddev_register);
+
+void v4l2_leddev_unregister(struct v4l2_leddev *ld)
+{
+	v4l2_leddev_remove_attrs(ld);
+	led_classdev_unregister(&ld->cdev);
+}
+EXPORT_SYMBOL(v4l2_leddev_unregister);
+
+MODULE_AUTHOR("Andrzej Hajda <a.hajda@samsung.com>");
+MODULE_DESCRIPTION("V4L2 API for exposing flash subdevs as LED class devices");
+MODULE_LICENSE("GPL");
diff --git a/include/media/v4l2-leddev.h b/include/media/v4l2-leddev.h
new file mode 100644
index 0000000..384b71f
--- /dev/null
+++ b/include/media/v4l2-leddev.h
@@ -0,0 +1,49 @@
+/*
+ * V4L2 API for exposing flash subdevs as led class devices
+ *
+ * Copyright (C) 2013, Samsung Electronics Co., Ltd.
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _V4L2_LEDDEV_H
+#define _V4L2_LEDDEV_H
+
+#include <linux/device.h>
+#include <linux/leds.h>
+#include <media/v4l2-subdev.h>
+
+struct v4l2_leddev_attr;
+
+struct v4l2_leddev {
+	struct v4l2_subdev *sd;
+	struct led_classdev cdev;
+	int attr_count;
+	struct v4l2_leddev_attr *attrs;
+};
+
+#ifdef CONFIG_V4L2_LEDDEV
+
+int v4l2_leddev_register(struct device *dev, struct v4l2_leddev *ld);
+void v4l2_leddev_unregister(struct v4l2_leddev *ld);
+
+#else
+
+#define v4l2_leddev_register(dev, ld) (0)
+#define v4l2_leddev_unregister(ld) (void)
+
+#endif
+
+#endif /* _V4L2_LEDDEV_H */
-- 
1.7.10.4

