Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33845 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2JDHYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:24:42 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00CTLXVK9PN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:41 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:41 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 04/14] drm: exynos: hdmi: use s5p-hdmi platform data
Date: Thu, 04 Oct 2012 21:12:42 +0530
Message-id: <1349365372-21417-5-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

The 'exynos-drm-hdmi' driver makes use of s5p-tv platform devices. Therefore
the driver should use the same platform data to prevent crashes caused by
dereferencing incorrect types.  This patch corrects the exynos-drm-hdmi driver
to the platform data from s5p-hdmi.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   55 +++++++++++++++-------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 3902917..90dce8c 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -40,6 +40,9 @@
 
 #include "exynos_hdmi.h"
 
+#include <linux/gpio.h>
+#include <media/s5p_hdmi.h>
+
 #define MAX_WIDTH		1920
 #define MAX_HEIGHT		1080
 #define get_hdmi_context(dev)	platform_get_drvdata(to_platform_device(dev))
@@ -76,8 +79,7 @@ struct hdmi_context {
 	struct hdmi_resources		res;
 	void				*parent_ctx;
 
-	void				(*cfg_hpd)(bool external);
-	int				(*get_hpd)(void);
+	int				hpd_gpio;
 };
 
 /* HDMI Version 1.3 */
@@ -2024,8 +2026,6 @@ static void hdmi_poweron(struct hdmi_context *hdata)
 
 	hdata->powered = true;
 
-	if (hdata->cfg_hpd)
-		hdata->cfg_hpd(true);
 	mutex_unlock(&hdata->hdmi_mutex);
 
 	pm_runtime_get_sync(hdata->dev);
@@ -2061,8 +2061,6 @@ static void hdmi_poweroff(struct hdmi_context *hdata)
 	pm_runtime_put_sync(hdata->dev);
 
 	mutex_lock(&hdata->hdmi_mutex);
-	if (hdata->cfg_hpd)
-		hdata->cfg_hpd(false);
 
 	hdata->powered = false;
 
@@ -2110,17 +2108,13 @@ static irqreturn_t hdmi_external_irq_thread(int irq, void *arg)
 	struct exynos_drm_hdmi_context *ctx = arg;
 	struct hdmi_context *hdata = ctx->ctx;
 
-	if (!hdata->get_hpd)
-		goto out;
-
 	mutex_lock(&hdata->hdmi_mutex);
-	hdata->hpd = hdata->get_hpd();
+	hdata->hpd = gpio_get_value(hdata->hpd_gpio);
 	mutex_unlock(&hdata->hdmi_mutex);
 
 	if (ctx->drm_dev)
 		drm_helper_hpd_irq_event(ctx->drm_dev);
 
-out:
 	return IRQ_HANDLED;
 }
 
@@ -2143,18 +2137,9 @@ static irqreturn_t hdmi_internal_irq_thread(int irq, void *arg)
 			HDMI_INTC_FLAG_HPD_PLUG);
 	}
 
-	mutex_lock(&hdata->hdmi_mutex);
-	hdata->hpd = hdmi_reg_read(hdata, HDMI_HPD_STATUS);
-	if (hdata->powered && hdata->hpd) {
-		mutex_unlock(&hdata->hdmi_mutex);
-		goto out;
-	}
-	mutex_unlock(&hdata->hdmi_mutex);
-
 	if (ctx->drm_dev)
 		drm_helper_hpd_irq_event(ctx->drm_dev);
 
-out:
 	return IRQ_HANDLED;
 }
 
@@ -2287,7 +2272,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct exynos_drm_hdmi_context *drm_hdmi_ctx;
 	struct hdmi_context *hdata;
-	struct exynos_drm_hdmi_pdata *pdata;
+	struct s5p_hdmi_platform_data *pdata;
 	struct resource *res;
 	int ret;
 	enum hdmi_type hdmi_type;
@@ -2323,8 +2308,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	hdmi_type = platform_get_device_id(pdev)->driver_data;
 	hdata->is_v13 = (hdmi_type == HDMI_TYPE13);
-	hdata->cfg_hpd = pdata->cfg_hpd;
-	hdata->get_hpd = pdata->get_hpd;
+	hdata->hpd_gpio = pdata->hpd_gpio;
 	hdata->dev = dev;
 
 	ret = hdmi_resources_init(hdata);
@@ -2342,11 +2326,17 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		goto err_resource;
 	}
 
+	ret = gpio_request(hdata->hpd_gpio, "HPD");
+	if (ret) {
+		DRM_ERROR("failed to request HPD gpio\n");
+		goto err_resource;
+	}
+
 	/* DDC i2c driver */
 	if (i2c_add_driver(&ddc_driver)) {
 		DRM_ERROR("failed to register ddc i2c driver\n");
 		ret = -ENOENT;
-		goto err_resource;
+		goto err_gpio;
 	}
 
 	hdata->ddc_port = hdmi_ddc;
@@ -2360,32 +2350,31 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	hdata->hdmiphy_port = hdmi_hdmiphy;
 
-	hdata->external_irq = platform_get_irq_byname(pdev, "external_irq");
+	hdata->external_irq = gpio_to_irq(hdata->hpd_gpio);
 	if (hdata->external_irq < 0) {
-		DRM_ERROR("failed to get platform irq\n");
+		DRM_ERROR("failed to get GPIO external irq\n");
 		ret = hdata->external_irq;
 		goto err_hdmiphy;
 	}
 
-	hdata->internal_irq = platform_get_irq_byname(pdev, "internal_irq");
+	hdata->internal_irq = platform_get_irq(pdev, 0);
 	if (hdata->internal_irq < 0) {
 		DRM_ERROR("failed to get platform internal irq\n");
 		ret = hdata->internal_irq;
 		goto err_hdmiphy;
 	}
 
+	hdata->hpd = gpio_get_value(hdata->hpd_gpio);
+
 	ret = request_threaded_irq(hdata->external_irq, NULL,
 			hdmi_external_irq_thread, IRQF_TRIGGER_RISING |
 			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			"hdmi_external", drm_hdmi_ctx);
 	if (ret) {
-		DRM_ERROR("failed to register hdmi internal interrupt\n");
+		DRM_ERROR("failed to register hdmi external interrupt\n");
 		goto err_hdmiphy;
 	}
 
-	if (hdata->cfg_hpd)
-		hdata->cfg_hpd(false);
-
 	ret = request_threaded_irq(hdata->internal_irq, NULL,
 			hdmi_internal_irq_thread, IRQF_ONESHOT,
 			"hdmi_internal", drm_hdmi_ctx);
@@ -2407,6 +2396,8 @@ err_hdmiphy:
 	i2c_del_driver(&hdmiphy_driver);
 err_ddc:
 	i2c_del_driver(&ddc_driver);
+err_gpio:
+	gpio_free(hdata->hpd_gpio);
 err_resource:
 	hdmi_resources_cleanup(hdata);
 err_data:
@@ -2426,6 +2417,8 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 	free_irq(hdata->internal_irq, hdata);
 	free_irq(hdata->external_irq, hdata);
 
+	gpio_free(hdata->hpd_gpio);
+
 	hdmi_resources_cleanup(hdata);
 
 	/* hdmiphy i2c driver */
-- 
1.7.0.4

