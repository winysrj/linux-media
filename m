Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2JDHZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:11 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00LFOXWSZVQ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:58 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:57 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 13/14] drm: exynos: hdmi: add support for exynos5 hdmi
Date: Thu, 04 Oct 2012 21:12:51 +0530
Message-id: <1349365372-21417-14-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for exynos5 hdmi with device tree enabled.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   83 ++++++++++++++++++++++++++++++++--
 1 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 89e798b..5caf49f 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -32,6 +32,9 @@
 #include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
+#include <linux/io.h>
+#include <linux/of_gpio.h>
+#include <plat/gpio-cfg.h>
 
 #include <drm/exynos_drm.h>
 
@@ -2250,6 +2253,41 @@ void hdmi_attach_hdmiphy_client(struct i2c_client *hdmiphy)
 		hdmi_hdmiphy = hdmiphy;
 }
 
+#ifdef CONFIG_OF
+static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
+					(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct s5p_hdmi_platform_data *pd;
+	enum of_gpio_flags flags;
+	u32 value;
+
+	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		DRM_ERROR("memory allocation for pdata failed\n");
+		goto err_data;
+	}
+
+	if (!of_find_property(np, "hpd-gpio", &value)) {
+		DRM_ERROR("no hpd gpio property found\n");
+		goto err_data;
+	}
+
+	pd->hpd_gpio = of_get_named_gpio_flags(np, "hpd-gpio", 0, &flags);
+
+	return pd;
+
+err_data:
+	return NULL;
+}
+#else
+static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
+					(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static struct platform_device_id hdmi_driver_types[] = {
 	{
 		.name		= "s5pv210-hdmi",
@@ -2259,7 +2297,19 @@ static struct platform_device_id hdmi_driver_types[] = {
 		.driver_data    = HDMI_TYPE13,
 	}, {
 		.name		= "exynos4-hdmi14",
-		.driver_data    = HDMI_TYPE14,
+		.driver_data	= HDMI_TYPE14,
+	}, {
+		.name		= "exynos5-hdmi",
+		.driver_data	= HDMI_TYPE14,
+	}, {
+		/* end node */
+	}
+};
+
+static struct of_device_id hdmi_match_types[] = {
+	{
+		.compatible = "samsung,exynos5-hdmi",
+		.data	= (void	*)HDMI_TYPE14,
 	}, {
 		/* end node */
 	}
@@ -2276,7 +2326,16 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	DRM_DEBUG_KMS("[%d]\n", __LINE__);
 
-	pdata = pdev->dev.platform_data;
+	if (pdev->dev.of_node) {
+		pdata = drm_hdmi_dt_parse_pdata(dev);
+		if (IS_ERR(pdata)) {
+			DRM_ERROR("failed to parse dt\n");
+			return PTR_ERR(pdata);
+		}
+	} else {
+		pdata = pdev->dev.platform_data;
+	}
+
 	if (!pdata) {
 		DRM_ERROR("no platform data specified\n");
 		return -EINVAL;
@@ -2303,18 +2362,33 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, drm_hdmi_ctx);
 
-	hdata->type = (enum hdmi_type)platform_get_device_id
+	if (dev->of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(of_match_ptr(hdmi_match_types),
+					pdev->dev.of_node);
+		hdata->type = (enum hdmi_type)match->data;
+	} else {
+		hdata->type = (enum hdmi_type)platform_get_device_id
 					(pdev)->driver_data;
+	}
+
 	hdata->hpd_gpio = pdata->hpd_gpio;
 	hdata->dev = dev;
 
 	ret = hdmi_resources_init(hdata);
+
 	if (ret) {
 		ret = -EINVAL;
+		DRM_ERROR("hdmi_resources_init failed\n");
 		goto err_data;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		DRM_ERROR("failed to find registers\n");
+		ret = -ENOENT;
+		goto err_resource;
+	}
 
 	hdata->regs = devm_request_and_ioremap(&pdev->dev, res);
 	if (!hdata->regs) {
@@ -2462,8 +2536,9 @@ struct platform_driver hdmi_driver = {
 	.remove		= __devexit_p(hdmi_remove),
 	.id_table = hdmi_driver_types,
 	.driver		= {
-		.name	= "exynos4-hdmi",
+		.name	= "exynos-hdmi",
 		.owner	= THIS_MODULE,
 		.pm	= &hdmi_pm_ops,
+		.of_match_table = hdmi_match_types,
 	},
 };
-- 
1.7.0.4

