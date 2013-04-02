Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:21654 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3DBQG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:06:26 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: yhwan.joo@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 2/7] exynos4-is: Add FIMC-IS ISP I2C bus driver
Date: Tue, 02 Apr 2013 18:03:34 +0200
Message-id: <1364918619-9118-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
References: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
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

Changes since v3:
 - corrected I2C bus driver remove() function,
 - added missing EXPORT_SYMBOL() for the driver
   register/unregister API.
---
 drivers/media/platform/exynos4-is/fimc-is-i2c.c |  129 +++++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-i2c.h |   15 +++
 2 files changed, 144 insertions(+)
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-i2c.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-i2c.h

diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
new file mode 100644
index 0000000..1ec6b3c
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -0,0 +1,129 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of_i2c.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include "fimc-is-i2c.h"
+
+struct fimc_is_i2c {
+	struct i2c_adapter adapter;
+	struct clk *clock;
+};
+
+/*
+ * An empty algorithm is used as the actual I2C bus controller driver
+ * is implemented in the FIMC-IS subsystem firmware and the host CPU
+ * doesn't access the I2C bus controller.
+ */
+static const struct i2c_algorithm fimc_is_i2c_algorithm;
+
+static int fimc_is_i2c_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct fimc_is_i2c *isp_i2c;
+	struct i2c_adapter *i2c_adap;
+	int ret;
+
+	isp_i2c = devm_kzalloc(&pdev->dev, sizeof(*isp_i2c), GFP_KERNEL);
+	if (!isp_i2c)
+		return -ENOMEM;
+
+	isp_i2c->clock = devm_clk_get(&pdev->dev, "i2c_isp");
+	if (IS_ERR(isp_i2c->clock)) {
+		dev_err(&pdev->dev, "failed to get the clock\n");
+		return PTR_ERR(isp_i2c->clock);
+	}
+
+	i2c_adap = &isp_i2c->adapter;
+	i2c_adap->dev.of_node = node;
+	i2c_adap->dev.parent = &pdev->dev;
+	strlcpy(i2c_adap->name, "exynos4x12-isp-i2c", sizeof(i2c_adap->name));
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
+
+	platform_set_drvdata(pdev, isp_i2c);
+
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_enable(&i2c_adap->dev);
+
+	of_i2c_register_devices(i2c_adap);
+
+	return 0;
+}
+
+static int fimc_is_i2c_remove(struct platform_device *pdev)
+{
+	struct fimc_is_i2c *isp_i2c = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&isp_i2c->adapter.dev);
+	pm_runtime_disable(&pdev->dev);
+	i2c_del_adapter(&isp_i2c->adapter);
+
+	return 0;
+}
+
+static int fimc_is_i2c_suspend(struct device *dev)
+{
+	struct fimc_is_i2c *isp_i2c = dev_get_drvdata(dev);
+	clk_disable_unprepare(isp_i2c->clock);
+	return 0;
+}
+
+static int fimc_is_i2c_resume(struct device *dev)
+{
+	struct fimc_is_i2c *isp_i2c = dev_get_drvdata(dev);
+	return clk_prepare_enable(isp_i2c->clock);
+}
+
+UNIVERSAL_DEV_PM_OPS(fimc_is_i2c_pm_ops, fimc_is_i2c_suspend,
+		     fimc_is_i2c_resume, NULL);
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
+		.name		= "fimc-isp-i2c",
+		.owner		= THIS_MODULE,
+		.pm		= &fimc_is_i2c_pm_ops,
+	}
+};
+
+int fimc_is_register_i2c_driver(void)
+{
+	return platform_driver_register(&fimc_is_i2c_driver);
+}
+EXPORT_SYMBOL(fimc_is_register_i2c_driver);
+
+void fimc_is_unregister_i2c_driver(void)
+{
+	platform_driver_unregister(&fimc_is_i2c_driver);
+}
+EXPORT_SYMBOL(fimc_is_unregister_i2c_driver);
diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.h b/drivers/media/platform/exynos4-is/fimc-is-i2c.h
new file mode 100644
index 0000000..0d38d6b
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.h
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

