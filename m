Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:13695 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3EaQrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:47:53 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO007U29BR9LN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:47:52 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [REVIEW PATCH 3/7] exynos4-is: Remove unused code
Date: Fri, 31 May 2013 18:47:01 +0200
Message-id: <1370018825-13088-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
References: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused macros and fields of struct fimc_is_video.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp.h  |   13 +------------
 drivers/media/platform/exynos4-is/media-dev.h |    8 --------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index 800aba7..f5c802c 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -118,7 +118,6 @@ struct fimc_is_video {
 	unsigned int		frame_count;
 	unsigned int		reqbufs_count;
 	int			streaming;
-	unsigned long		payload[FIMC_ISP_MAX_PLANES];
 	const struct fimc_fmt	*format;
 };
 
@@ -128,15 +127,9 @@ struct fimc_is_video {
  * @alloc_ctx: videobuf2 memory allocator context
  * @subdev: ISP v4l2_subdev
  * @subdev_pads: the ISP subdev media pads
- * @ctrl_handler: v4l2 controls handler
  * @test_pattern: test pattern controls
- * @pipeline: video capture pipeline data structure
+ * @ctrls: v4l2 controls structure
  * @video_lock: mutex serializing video device and the subdev operations
- * @fmt: pointer to color format description structure
- * @payload: image size in bytes (w x h x bpp)
- * @inp_frame: camera input frame structure
- * @out_frame: DMA output frame structure
- * @source_subdev_grp_id: group id of remote source subdev
  * @cac_margin_x: horizontal CAC margin in pixels
  * @cac_margin_y: vertical CAC margin in pixels
  * @state: driver state flags
@@ -154,10 +147,6 @@ struct fimc_isp {
 	struct mutex			video_lock;
 	struct mutex			subdev_lock;
 
-	struct fimc_isp_frame		inp_frame;
-	struct fimc_isp_frame		out_frame;
-	unsigned int			source_subdev_grp_id;
-
 	unsigned int			cac_margin_x;
 	unsigned int			cac_margin_y;
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index a704eea..62599fd 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -133,14 +133,6 @@ struct fimc_md {
 	struct list_head pipelines;
 };
 
-#define is_subdev_pad(pad) (pad == NULL || \
-	media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
-
-#define me_subtype(me) \
-	((me->type) & (MEDIA_ENT_TYPE_MASK | MEDIA_ENT_SUBTYPE_MASK))
-
-#define subdev_has_devnode(__sd) (__sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE)
-
 static inline
 struct fimc_sensor_info *source_to_sensor_info(struct fimc_source_info *si)
 {
-- 
1.7.9.5

