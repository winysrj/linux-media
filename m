Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59900 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3CKTpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:45:18 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 2/8] s5p-fimc: Add FIMC-IS ISP I2C bus driver
Date: Mon, 11 Mar 2013 20:44:46 +0100
Message-id: <1363031092-29950-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the ISP I2C bus controller driver files.

Creating a standard I2C bus adapter, even if the driver doesn't
actually communicates with the hardware and it is instead used
by the ISP firmware running on the Cortex-A5, allows to use
standard hardware description in the device tree. As the sensor
would have actually had a standard V4L2 sub-device driver run
on the host CPU.

This approach allows to adapt the driver with a relatively small
effort should the Imaging Subsystem architecture change so that
the I2C bus is controlled by the host CPU, rather than the
internal FIMC-IS ARM CPU. The image sensor drivers can be
standard I2C client driver, as in case of most existing image
sensor driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-is-i2c.c |   81 +++++++++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-is-i2c.h |   15 +++++
 2 files changed, 96 insertions(+)
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-i2c.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-i2c.h

diff --git a/drivers/media/platform/s5p-fimc/fimc-is-i2c.c b/drivers/media/platform/s5p-fimc/fimc-is-i2c.c
new file mode 100644
index 0000000..d4c75dc
--- /dev/null
+++ b/drivers/media/platform/s5p-fimc/fimc-is-i2c.c
@@ -0,0 +1,81 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/module.h>
+#include <linux/of_i2c.h>
+#include <linux/platform_device.h>
+#include "fimc-is-i2c.h"
+
+/*
+ * An empty algorithm is used as the actual I2C bus controller driver
+ * is implemented in the FIMC-IS subsystem firmware and the host CPU
+ * doesn't touch the hardware.
+ */
+static const struct i2c_algorithm fimc_is_i2c_algorithm;
+
+static int fimc_is_i2c_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct i2c_adapter *i2c_adap;
+	int ret;
+
+	i2c_adap = devm_kzalloc(&pdev->dev, sizeof(*i2c_adap), GFP_KERNEL);
+
+	i2c_adap->dev.of_node = node;
+	i2c_adap->dev.parent = &pdev->dev;
+	strlcpy(i2c_adap->name, "exynos4x12-is-i2c", sizeof(i2c_adap->name));
+	i2c_adap->owner = THIS_MODULE;
+	i2c_adap->algo = &fimc_is_i2c_algorithm;
+	i2c_adap->class = I2C_CLASS_SPD;
+
+	ret = i2c_add_adapter(i2c_adap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add I2C bus %s\n",
+						node->full_name);
+		return ret;
+	}
+	of_i2c_register_devices(i2c_adap);
+
+	return 0;
+}
+
+static int fimc_is_i2c_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id fimc_is_i2c_of_match[] = {
+	{ .compatible = FIMC_IS_I2C_COMPATIBLE },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, fimc_is_i2c_of_match);
+
+static struct platform_driver fimc_is_i2c_driver = {
+	.probe		= fimc_is_i2c_probe,
+	.remove		= fimc_is_i2c_remove,
+	.driver = {
+		.of_match_table = fimc_is_i2c_of_match,
+		.name		= "fimc-is-i2c",
+		.owner		= THIS_MODULE,
+	}
+};
+
+int fimc_is_register_i2c_driver(void)
+{
+	return platform_driver_register(&fimc_is_i2c_driver);
+}
+
+void fimc_is_unregister_i2c_driver(void)
+{
+	platform_driver_unregister(&fimc_is_i2c_driver);
+}
+
diff --git a/drivers/media/platform/s5p-fimc/fimc-is-i2c.h b/drivers/media/platform/s5p-fimc/fimc-is-i2c.h
new file mode 100644
index 0000000..0d38d6b
--- /dev/null
+++ b/drivers/media/platform/s5p-fimc/fimc-is-i2c.h
@@ -0,0 +1,15 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define FIMC_IS_I2C_COMPATIBLE	"samsung,exynos4212-i2c-isp"
+
+int fimc_is_register_i2c_driver(void);
+void fimc_is_unregister_i2c_driver(void);
-- 
1.7.9.5

