Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46721 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2AZRMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 12:12:01 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYF0015C13ZNO@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 17:11:59 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYF00DS513YFN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 17:11:59 +0000 (GMT)
Date: Thu, 26 Jan 2012 18:11:51 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/3] v4l: s5p-tv: hdmi: add support for platform data
In-reply-to: <1327597912-30105-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1327597912-30105-3-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327597912-30105-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moving configuration of s5p-hdmi peripherals from driver data to
platfrom data.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/hdmi_drv.c |   38 ++++++++++++++------------------
 include/media/s5p_hdmi.h              |   35 ++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 21 deletions(-)
 create mode 100644 include/media/s5p_hdmi.h

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 8b41a04..ab3a2d3 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -30,6 +30,7 @@
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
 
+#include <media/s5p_hdmi.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
@@ -74,10 +75,6 @@ struct hdmi_device {
 	struct hdmi_resources res;
 };
 
-struct hdmi_driver_data {
-	int hdmiphy_bus;
-};
-
 struct hdmi_tg_regs {
 	u8 cmd;
 	u8 h_fsz_l;
@@ -129,23 +126,11 @@ struct hdmi_preset_conf {
 	struct v4l2_mbus_framefmt mbus_fmt;
 };
 
-/* I2C module and id for HDMIPHY */
-static struct i2c_board_info hdmiphy_info = {
-	I2C_BOARD_INFO("hdmiphy", 0x38),
-};
-
-static struct hdmi_driver_data hdmi_driver_data[] = {
-	{ .hdmiphy_bus = 3 },
-	{ .hdmiphy_bus = 8 },
-};
-
 static struct platform_device_id hdmi_driver_types[] = {
 	{
 		.name		= "s5pv210-hdmi",
-		.driver_data	= (unsigned long)&hdmi_driver_data[0],
 	}, {
 		.name		= "exynos4-hdmi",
-		.driver_data	= (unsigned long)&hdmi_driver_data[1],
 	}, {
 		/* end node */
 	}
@@ -870,11 +855,17 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	struct i2c_adapter *phy_adapter;
 	struct v4l2_subdev *sd;
 	struct hdmi_device *hdmi_dev = NULL;
-	struct hdmi_driver_data *drv_data;
+	struct s5p_hdmi_platform_data *pdata = dev->platform_data;
 	int ret;
 
 	dev_dbg(dev, "probe start\n");
 
+	if (!pdata) {
+		dev_err(dev, "platform data is missing\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+
 	hdmi_dev = kzalloc(sizeof(*hdmi_dev), GFP_KERNEL);
 	if (!hdmi_dev) {
 		dev_err(dev, "out of memory\n");
@@ -927,9 +918,14 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		goto fail_irq;
 	}
 
-	drv_data = (struct hdmi_driver_data *)
-		platform_get_device_id(pdev)->driver_data;
-	phy_adapter = i2c_get_adapter(drv_data->hdmiphy_bus);
+	/* testing if hdmiphy info is present */
+	if (!pdata->hdmiphy_info) {
+		dev_err(dev, "hdmiphy info is missing in platform data\n");
+		ret = -ENXIO;
+		goto fail_vdev;
+	}
+
+	phy_adapter = i2c_get_adapter(pdata->hdmiphy_bus);
 	if (phy_adapter == NULL) {
 		dev_err(dev, "adapter request failed\n");
 		ret = -ENXIO;
@@ -937,7 +933,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	}
 
 	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->v4l2_dev,
-		phy_adapter, &hdmiphy_info, NULL);
+		phy_adapter, pdata->hdmiphy_info, NULL);
 	/* on failure or not adapter is no longer useful */
 	i2c_put_adapter(phy_adapter);
 	if (hdmi_dev->phy_sd == NULL) {
diff --git a/include/media/s5p_hdmi.h b/include/media/s5p_hdmi.h
new file mode 100644
index 0000000..361a751
--- /dev/null
+++ b/include/media/s5p_hdmi.h
@@ -0,0 +1,35 @@
+/*
+ * Driver header for S5P HDMI chip.
+ *
+ * Copyright (c) 2011 Samsung Electronics, Co. Ltd
+ * Contact: Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef S5P_HDMI_H
+#define S5P_HDMI_H
+
+struct i2c_board_info;
+
+/**
+ * @hdmiphy_bus: controller id for HDMIPHY bus
+ * @hdmiphy_info: template for HDMIPHY I2C device
+ * @mhl_bus: controller id for MHL control bus
+ * @mhl_info: template for MHL I2C device
+ *
+ * NULL pointer for *_info fields indicates that
+ * the corresponding chip is not present
+ */
+struct s5p_hdmi_platform_data {
+	int hdmiphy_bus;
+	struct i2c_board_info *hdmiphy_info;
+	int mhl_bus;
+	struct i2c_board_info *mhl_info;
+};
+
+#endif /* S5P_HDMI_H */
+
-- 
1.7.5.4

