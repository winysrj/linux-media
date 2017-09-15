Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdIOQmP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:42:15 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v1 2/3] drm: rcar-du: Add suspend resume helpers
Date: Fri, 15 Sep 2017 17:42:06 +0100
Message-Id: <199d29db89a7953f59e1eb4e91a3421336e3ed2a.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pipeline needs to ensure that the hardware is idle for suspend and
resume operations.

Implement suspend and resume functions using the DRM atomic helper
functions.

CC: dri-devel@lists.freedesktop.org

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_drv.c | 18 +++++++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_drv.h |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index 09fbceade6b1..01b91d0c169c 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -22,6 +22,7 @@
 #include <linux/wait.h>
 
 #include <drm/drmP.h>
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_gem_cma_helper.h>
@@ -267,9 +268,19 @@ static struct drm_driver rcar_du_driver = {
 static int rcar_du_pm_suspend(struct device *dev)
 {
 	struct rcar_du_device *rcdu = dev_get_drvdata(dev);
+	struct drm_atomic_state *state;
 
 	drm_kms_helper_poll_disable(rcdu->ddev);
-	/* TODO Suspend the CRTC */
+	drm_fbdev_cma_set_suspend_unlocked(rcdu->fbdev, true);
+
+	state = drm_atomic_helper_suspend(rcdu->ddev);
+	if (IS_ERR(state)) {
+		drm_fbdev_cma_set_suspend_unlocked(rcdu->fbdev, false);
+		drm_kms_helper_poll_enable(rcdu->ddev);
+		return PTR_ERR(state);
+	}
+
+	rcdu->suspend_state = state;
 
 	return 0;
 }
@@ -278,9 +289,10 @@ static int rcar_du_pm_resume(struct device *dev)
 {
 	struct rcar_du_device *rcdu = dev_get_drvdata(dev);
 
-	/* TODO Resume the CRTC */
-
+	drm_atomic_helper_resume(rcdu->ddev, rcdu->suspend_state);
+	drm_fbdev_cma_set_suspend_unlocked(rcdu->fbdev, false);
 	drm_kms_helper_poll_enable(rcdu->ddev);
+
 	return 0;
 }
 #endif
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index f8cd79488ece..f400fde65a0c 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -81,6 +81,7 @@ struct rcar_du_device {
 
 	struct drm_device *ddev;
 	struct drm_fbdev_cma *fbdev;
+	struct drm_atomic_state *suspend_state;
 
 	struct rcar_du_crtc crtcs[RCAR_DU_MAX_CRTCS];
 	unsigned int num_crtcs;
-- 
git-series 0.9.1
