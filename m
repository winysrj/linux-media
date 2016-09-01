Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:39384 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933292AbcIALrV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 07:47:21 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/3] exynos4-is: Add missing entity function initialization
Date: Thu, 01 Sep 2016 13:47:05 +0200
Message-id: <1472730427-17821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Suppresses following warnings:

s5p-fimc-md camera: Entity type for entity FIMC.0 was not initialized!
s5p-fimc-md camera: Entity type for entity FIMC.1 was not initialized!
s5p-fimc-md camera: Entity type for entity s5p-mipi-csis.0 was not initialized!
s5p-fimc-md camera: Entity type for entity s5p-mipi-csis.1 was not initialized!
s5p-fimc-md camera: Entity type for entity FIMC-LITE.0 was not initialized!
s5p-fimc-md camera: Entity type for entity FIMC-LITE.1 was not initialized!
s5p-fimc-md camera: Entity type for entity FIMC-IS-ISP was not initialized!

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c | 1 +
 drivers/media/platform/exynos4-is/fimc-isp.c     | 1 +
 drivers/media/platform/exynos4-is/fimc-lite.c    | 1 +
 drivers/media/platform/exynos4-is/mipi-csis.c    | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index fdec499..5bea9dd 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1796,6 +1796,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	vid_cap->wb_fmt.code = fmt->mbus_code;
 
 	vid_cap->vd_pad.flags = MEDIA_PAD_FL_SINK;
+	vfd->entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
 	ret = media_entity_pads_init(&vfd->entity, 1, &vid_cap->vd_pad);
 	if (ret)
 		goto err_free_ctx;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 293b807..8efe916 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -705,6 +705,7 @@ int fimc_isp_subdev_create(struct fimc_isp *isp)
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	snprintf(sd->name, sizeof(sd->name), "FIMC-IS-ISP");
 
+	sd->entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
 	isp->subdev_pads[FIMC_ISP_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	isp->subdev_pads[FIMC_ISP_SD_PAD_SRC_FIFO].flags = MEDIA_PAD_FL_SOURCE;
 	isp->subdev_pads[FIMC_ISP_SD_PAD_SRC_DMA].flags = MEDIA_PAD_FL_SOURCE;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index a0f149f..e1c99e1 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1432,6 +1432,7 @@ static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
 
 	sd->ctrl_handler = handler;
 	sd->internal_ops = &fimc_lite_subdev_internal_ops;
+	sd->entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
 	sd->entity.ops = &fimc_lite_subdev_media_ops;
 	sd->owner = THIS_MODULE;
 	v4l2_set_subdevdata(sd, fimc);
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 86e681d..befd9fc 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -853,6 +853,7 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	state->format.width = S5PCSIS_DEF_PIX_WIDTH;
 	state->format.height = S5PCSIS_DEF_PIX_HEIGHT;
 
+	state->sd.entity.function = MEDIA_ENT_F_IO_V4L;
 	state->pads[CSIS_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	state->pads[CSIS_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&state->sd.entity,
-- 
1.9.1

