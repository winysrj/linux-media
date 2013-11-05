Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65413 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3KEMN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 07:13:56 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v12 07/12] [media] exynos5-fimc-is: Add sensor interface
Date: Tue,  5 Nov 2013 17:43:24 +0530
Message-Id: <1383653610-11835-8-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
References: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors to be used with fimc-is are exclusively controlled
by the fimc-is firmware. This minimal sensor driver provides
the required info for the firmware to configure the sensors
sitting on I2C bus.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |   45 ++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |   65 ++++++++++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.c b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
new file mode 100644
index 0000000..475f1c3
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.c
@@ -0,0 +1,45 @@
+/*
+ * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "fimc-is-sensor.h"
+
+static const struct sensor_drv_data s5k6a3_drvdata = {
+	.id		= FIMC_IS_SENSOR_ID_S5K6A3,
+	.open_timeout	= S5K6A3_OPEN_TIMEOUT,
+	.setfile_name	= "exynos5_s5k6a3_setfile.bin",
+};
+
+static const struct sensor_drv_data s5k4e5_drvdata = {
+	.id		= FIMC_IS_SENSOR_ID_S5K4E5,
+	.open_timeout	= S5K4E5_OPEN_TIMEOUT,
+	.setfile_name	= "exynos5_s5k4e5_setfile.bin",
+};
+
+static const struct of_device_id fimc_is_sensor_of_ids[] = {
+	{
+		.compatible	= "samsung,s5k6a3",
+		.data		= &s5k6a3_drvdata,
+	},
+	{
+		.compatible	= "samsung,s5k4e5",
+		.data		= &s5k4e5_drvdata,
+	},
+	{  }
+};
+
+const struct sensor_drv_data *exynos5_is_sensor_get_drvdata(
+			struct device_node *node)
+{
+	const struct of_device_id *of_id;
+
+	of_id = of_match_node(fimc_is_sensor_of_ids, node);
+	return of_id ? of_id->data : NULL;
+}
diff --git a/drivers/media/platform/exynos5-is/fimc-is-sensor.h b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
new file mode 100644
index 0000000..0ba5733
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-sensor.h
@@ -0,0 +1,65 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_SENSOR_H_
+#define FIMC_IS_SENSOR_H_
+
+#include <linux/of.h>
+#include <linux/types.h>
+
+#define S5K6A3_OPEN_TIMEOUT		2000 /* ms */
+#define S5K6A3_SENSOR_WIDTH		1392
+#define S5K6A3_SENSOR_HEIGHT		1392
+
+#define S5K4E5_OPEN_TIMEOUT		2000 /* ms */
+#define S5K4E5_SENSOR_WIDTH		2560
+#define S5K4E5_SENSOR_HEIGHT		1920
+
+#define SENSOR_WIDTH_PADDING		16
+#define SENSOR_HEIGHT_PADDING		10
+
+enum fimc_is_sensor_id {
+	FIMC_IS_SENSOR_ID_S5K3H2 = 1,
+	FIMC_IS_SENSOR_ID_S5K6A3,
+	FIMC_IS_SENSOR_ID_S5K4E5,
+	FIMC_IS_SENSOR_ID_S5K3H7,
+	FIMC_IS_SENSOR_ID_CUSTOM,
+	FIMC_IS_SENSOR_ID_END
+};
+
+struct sensor_drv_data {
+	enum fimc_is_sensor_id id;
+	/* sensor open timeout in ms */
+	unsigned short open_timeout;
+	char *setfile_name;
+};
+
+/**
+ * struct fimc_is_sensor - fimc-is sensor data structure
+ * @drvdata: a pointer to the sensor's parameters data structure
+ * @i2c_bus: ISP I2C bus index (0...1)
+ * @width: sensor active width
+ * @height: sensor active height
+ * @pixel_width: sensor effective pixel width (width + padding)
+ * @pixel_height: sensor effective pixel height (height + padding)
+ */
+struct fimc_is_sensor {
+	const struct sensor_drv_data *drvdata;
+	unsigned int i2c_bus;
+	unsigned int width;
+	unsigned int height;
+	unsigned int pixel_width;
+	unsigned int pixel_height;
+};
+
+const struct sensor_drv_data *exynos5_is_sensor_get_drvdata(
+			struct device_node *node);
+
+#endif /* FIMC_IS_SENSOR_H_ */
-- 
1.7.9.5

