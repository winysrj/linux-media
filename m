Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33809 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2JDHYi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:24:38 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00CTLXVK9PN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:37 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:37 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 02/14] drm: exynos: hdmi: support for platform variants
Date: Thu, 04 Oct 2012 21:12:40 +0530
Message-id: <1349365372-21417-3-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

This patch implements check if HDMI is version 1.3 by using a driver variant
instead of platform data.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index a6aea6f..b3a802b 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2262,6 +2262,26 @@ void hdmi_attach_hdmiphy_client(struct i2c_client *hdmiphy)
 		hdmi_hdmiphy = hdmiphy;
 }
 
+enum hdmi_type {
+	HDMI_TYPE13,
+	HDMI_TYPE14,
+};
+
+static struct platform_device_id hdmi_driver_types[] = {
+	{
+		.name		= "s5pv210-hdmi",
+		.driver_data    = HDMI_TYPE13,
+	}, {
+		.name		= "exynos4-hdmi",
+		.driver_data    = HDMI_TYPE13,
+	}, {
+		.name		= "exynos4-hdmi14",
+		.driver_data    = HDMI_TYPE14,
+	}, {
+		/* end node */
+	}
+};
+
 static int __devinit hdmi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -2270,6 +2290,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	struct exynos_drm_hdmi_pdata *pdata;
 	struct resource *res;
 	int ret;
+	enum hdmi_type hdmi_type;
 
 	DRM_DEBUG_KMS("[%d]\n", __LINE__);
 
@@ -2300,7 +2321,8 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, drm_hdmi_ctx);
 
-	hdata->is_v13 = pdata->is_v13;
+	hdmi_type = platform_get_device_id(pdev)->driver_data;
+	hdata->is_v13 = (hdmi_type == HDMI_TYPE13);
 	hdata->cfg_hpd = pdata->cfg_hpd;
 	hdata->get_hpd = pdata->get_hpd;
 	hdata->dev = dev;
@@ -2447,6 +2469,7 @@ static SIMPLE_DEV_PM_OPS(hdmi_pm_ops, hdmi_suspend, hdmi_resume);
 struct platform_driver hdmi_driver = {
 	.probe		= hdmi_probe,
 	.remove		= __devexit_p(hdmi_remove),
+	.id_table = hdmi_driver_types,
 	.driver		= {
 		.name	= "exynos4-hdmi",
 		.owner	= THIS_MODULE,
-- 
1.7.0.4

