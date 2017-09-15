Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdIOQmO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:42:14 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v1 1/3] media: vsp1: Prevent resuming DRM pipelines
Date: Fri, 15 Sep 2017 17:42:05 +0100
Message-Id: <f15075b98a75895d65132ebf5ffb7a6b55d76ac8.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DRM pipelines utilising the VSP must stop all frame processing as part
of the suspend operation to ensure the hardware is idle. Upon resume,
the pipeline must not be started until the DU performs an atomic flush
to restore the hardware configuration and state.

Therefore the vsp1_pipeline_resume() call is not needed for DRM
pipelines, and we can disable it in this instance.

CC: linux-media@vger.kernel.org

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 962e4c304076..7604c7994c74 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -582,7 +582,13 @@ static int __maybe_unused vsp1_pm_resume(struct device *dev)
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 
 	pm_runtime_force_resume(vsp1->dev);
-	vsp1_pipelines_resume(vsp1);
+
+	/*
+	 * DRM pipelines are stopped before suspend, and will be resumed after
+	 * the DRM subsystem has reconfigured its pipeline with an atomic flush
+	 */
+	if (!vsp1->drm)
+		vsp1_pipelines_resume(vsp1);
 
 	return 0;
 }
-- 
git-series 0.9.1
