Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2JDHZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:07 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00LFOXWSZVQ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:50 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:50 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 09/14] drm: exynos: hdmi: add support for platform variants
 for mixer
Date: Thu, 04 Oct 2012 21:12:47 +0530
Message-id: <1349365372-21417-10-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the support for multiple mixer versions avaialble in
various platform variants. Version is passed as a driver data field
instead of paltform data.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_mixer.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 8a43ee1..e312fb1 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -73,6 +73,11 @@ struct mixer_resources {
 	struct clk		*sclk_dac;
 };
 
+enum mixer_version_id {
+	MXR_VER_0_0_0_16,
+	MXR_VER_16_0_33_0,
+};
+
 struct mixer_context {
 	struct device		*dev;
 	int			pipe;
@@ -83,6 +88,11 @@ struct mixer_context {
 	struct mutex		mixer_mutex;
 	struct mixer_resources	mixer_res;
 	struct hdmi_win_data	win_data[MIXER_WIN_NR];
+	enum mixer_version_id	mxr_ver;
+};
+
+struct mixer_drv_data {
+	enum mixer_version_id	version;
 };
 
 static const u8 filter_y_horiz_tap8[] = {
@@ -1023,11 +1033,25 @@ fail:
 	return ret;
 }
 
+static struct mixer_drv_data exynos4_mxr_drv_data = {
+	.version = MXR_VER_0_0_0_16,
+};
+
+static struct platform_device_id mixer_driver_types[] = {
+	{
+		.name		= "s5p-mixer",
+		.driver_data	= (unsigned long)&exynos4_mxr_drv_data,
+	}, {
+		/* end node */
+	}
+};
+
 static int __devinit mixer_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct exynos_drm_hdmi_context *drm_hdmi_ctx;
 	struct mixer_context *ctx;
+	struct mixer_drv_data *drv;
 	int ret;
 
 	dev_info(dev, "probe start\n");
@@ -1047,8 +1071,11 @@ static int __devinit mixer_probe(struct platform_device *pdev)
 
 	mutex_init(&ctx->mixer_mutex);
 
+	drv = (struct mixer_drv_data *)platform_get_device_id(
+			pdev)->driver_data;
 	ctx->dev = &pdev->dev;
 	drm_hdmi_ctx->ctx = (void *)ctx;
+	ctx->mxr_ver = drv->version;
 
 	platform_set_drvdata(pdev, drm_hdmi_ctx);
 
@@ -1101,4 +1128,5 @@ struct platform_driver mixer_driver = {
 	},
 	.probe = mixer_probe,
 	.remove = __devexit_p(mixer_remove),
+	.id_table	= mixer_driver_types,
 };
-- 
1.7.0.4

