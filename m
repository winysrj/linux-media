Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33859 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2JDHZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:03 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00CTLXVK9PN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:59 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:59 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 14/14] drm: exynos: hdmi: remove drm common hdmi platform
 data struct
Date: Thu, 04 Oct 2012 21:12:52 +0530
Message-id: <1349365372-21417-15-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

exynos-drm-hdmi need context pointers from hdmi and mixer. These
pointers were expected from the plf data. Cleaned this dependency
by exporting i/f which are called by hdmi, mixer driver probes
for setting their context.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c |   51 +++++++++++++++--------------
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h |    2 +
 drivers/gpu/drm/exynos/exynos_hdmi.c     |    3 ++
 drivers/gpu/drm/exynos/exynos_mixer.c    |    3 ++
 include/drm/exynos_drm.h                 |   14 --------
 5 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_hdmi.c b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
index 0584132..85304c4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
@@ -29,6 +29,11 @@
 #define get_ctx_from_subdrv(subdrv)	container_of(subdrv,\
 					struct drm_hdmi_context, subdrv);
 
+/* Common hdmi subdrv needs to access the hdmi and mixer though context.
+* These should be initialied by the repective drivers */
+static struct exynos_drm_hdmi_context *hdmi_ctx;
+static struct exynos_drm_hdmi_context *mixer_ctx;
+
 /* these callback points shoud be set by specific drivers. */
 static struct exynos_hdmi_ops *hdmi_ops;
 static struct exynos_mixer_ops *mixer_ops;
@@ -41,6 +46,18 @@ struct drm_hdmi_context {
 	bool	enabled[MIXER_WIN_NR];
 };
 
+void exynos_hdmi_drv_attach(struct exynos_drm_hdmi_context *ctx)
+{
+	if (ctx)
+		hdmi_ctx = ctx;
+}
+
+void exynos_mixer_drv_attach(struct exynos_drm_hdmi_context *ctx)
+{
+	if (ctx)
+		mixer_ctx = ctx;
+}
+
 void exynos_hdmi_ops_register(struct exynos_hdmi_ops *ops)
 {
 	DRM_DEBUG_KMS("%s\n", __FILE__);
@@ -303,46 +320,30 @@ static int hdmi_subdrv_probe(struct drm_device *drm_dev,
 {
 	struct exynos_drm_subdrv *subdrv = to_subdrv(dev);
 	struct drm_hdmi_context *ctx;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos_drm_common_hdmi_pd *pd;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	pd = pdev->dev.platform_data;
-
-	if (!pd) {
-		DRM_DEBUG_KMS("platform data is null.\n");
+	if (!hdmi_ctx) {
+		DRM_ERROR("hdmi context not initialized.\n");
 		return -EFAULT;
 	}
 
-	if (!pd->hdmi_dev) {
-		DRM_DEBUG_KMS("hdmi device is null.\n");
-		return -EFAULT;
-	}
-
-	if (!pd->mixer_dev) {
-		DRM_DEBUG_KMS("mixer device is null.\n");
+	if (!mixer_ctx) {
+		DRM_ERROR("mixer context not initialized.\n");
 		return -EFAULT;
 	}
 
 	ctx = get_ctx_from_subdrv(subdrv);
 
-	ctx->hdmi_ctx = (struct exynos_drm_hdmi_context *)
-				to_context(pd->hdmi_dev);
-	if (!ctx->hdmi_ctx) {
-		DRM_DEBUG_KMS("hdmi context is null.\n");
+	if (!ctx) {
+		DRM_ERROR("no drm hdmi context.\n");
 		return -EFAULT;
 	}
 
-	ctx->hdmi_ctx->drm_dev = drm_dev;
-
-	ctx->mixer_ctx = (struct exynos_drm_hdmi_context *)
-				to_context(pd->mixer_dev);
-	if (!ctx->mixer_ctx) {
-		DRM_DEBUG_KMS("mixer context is null.\n");
-		return -EFAULT;
-	}
+	ctx->hdmi_ctx = hdmi_ctx;
+	ctx->mixer_ctx = mixer_ctx;
 
+	ctx->hdmi_ctx->drm_dev = drm_dev;
 	ctx->mixer_ctx->drm_dev = drm_dev;
 
 	return 0;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_hdmi.h b/drivers/gpu/drm/exynos/exynos_drm_hdmi.h
index d9f9e9f..2da5ffd 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_hdmi.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_hdmi.h
@@ -73,6 +73,8 @@ struct exynos_mixer_ops {
 	void (*win_disable)(void *ctx, int zpos);
 };
 
+void exynos_hdmi_drv_attach(struct exynos_drm_hdmi_context *ctx);
+void exynos_mixer_drv_attach(struct exynos_drm_hdmi_context *ctx);
 void exynos_hdmi_ops_register(struct exynos_hdmi_ops *ops);
 void exynos_mixer_ops_register(struct exynos_mixer_ops *ops);
 #endif
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 5caf49f..e6b784d 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2454,6 +2454,9 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
+	/* Attach HDMI Driver to common hdmi. */
+	exynos_hdmi_drv_attach(drm_hdmi_ctx);
+
 	/* register specific callbacks to common hdmi. */
 	exynos_hdmi_ops_register(&hdmi_ops);
 
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 39d2b95..1a319e4 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1171,6 +1171,9 @@ static int __devinit mixer_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* attach mixer driver to common hdmi. */
+	exynos_mixer_drv_attach(drm_hdmi_ctx);
+
 	/* register specific callback point to common hdmi. */
 	exynos_mixer_ops_register(&mixer_ops);
 
diff --git a/include/drm/exynos_drm.h b/include/drm/exynos_drm.h
index 8bdd49a..8ac4079 100644
--- a/include/drm/exynos_drm.h
+++ b/include/drm/exynos_drm.h
@@ -240,19 +240,5 @@ struct exynos_drm_fimd_pdata {
 	unsigned int			bpp;
 };
 
-/**
- * Platform Specific Structure for DRM based HDMI.
- *
- * @hdmi_dev: device point to specific hdmi driver.
- * @mixer_dev: device point to specific mixer driver.
- *
- * this structure is used for common hdmi driver and each device object
- * would be used to access specific device driver(hdmi or mixer driver)
- */
-struct exynos_drm_common_hdmi_pd {
-	struct device *hdmi_dev;
-	struct device *mixer_dev;
-};
-
 #endif	/* __KERNEL__ */
 #endif	/* _EXYNOS_DRM_H_ */
-- 
1.7.0.4

