Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52414 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3FCIQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 04:16:52 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNT00IM35L78230@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Jun 2013 09:16:50 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] media: Rename media_entity_remote_source to
 media_entity_remote_pad
Date: Mon, 03 Jun 2013 10:16:13 +0200
Message-id: <1370247373-11402-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function media_entity_remote_source actually returns the remote pad to
the given one, regardless if this is the source or the sink pad.
Name media_entity_remote_pad is more adequate for this function.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
Hi,

Thanks for the reviews.
This is the patch adjusted to the latest linuxtv/master branch.

Regards
Andrzej Hajda

 Documentation/media-framework.txt                |  2 +-
 drivers/media/media-entity.c                     | 13 ++++++-------
 drivers/media/platform/exynos4-is/fimc-capture.c |  6 +++---
 drivers/media/platform/exynos4-is/fimc-lite.c    |  4 ++--
 drivers/media/platform/exynos4-is/media-dev.c    |  2 +-
 drivers/media/platform/omap3isp/isp.c            |  6 +++---
 drivers/media/platform/omap3isp/ispccdc.c        |  2 +-
 drivers/media/platform/omap3isp/ispccp2.c        |  2 +-
 drivers/media/platform/omap3isp/ispcsi2.c        |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c       |  6 +++---
 drivers/media/platform/s3c-camif/camif-capture.c |  2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c  | 12 ++++++------
 include/media/media-entity.h                     |  2 +-
 13 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 77bd0a4..3702eff 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -265,7 +265,7 @@ connected to another pad through an enabled link
 	media_entity_find_link(struct media_pad *source,
 			       struct media_pad *sink);
 
-	media_entity_remote_source(struct media_pad *pad);
+	media_entity_remote_pad(struct media_pad *pad);
 
 Refer to the kerneldoc documentation for more information.
 
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e1cd132..0438209 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -560,17 +560,16 @@ media_entity_find_link(struct media_pad *source, struct media_pad *sink)
 EXPORT_SYMBOL_GPL(media_entity_find_link);
 
 /**
- * media_entity_remote_source - Find the source pad at the remote end of a link
- * @pad: Sink pad at the local end of the link
+ * media_entity_remote_pad - Find the pad at the remote end of a link
+ * @pad: Pad at the local end of the link
  *
- * Search for a remote source pad connected to the given sink pad by iterating
- * over all links originating or terminating at that pad until an enabled link
- * is found.
+ * Search for a remote pad connected to the given pad by iterating over all
+ * links originating or terminating at that pad until an enabled link is found.
  *
  * Return a pointer to the pad at the remote end of the first found enabled
  * link, or NULL if no enabled link has been found.
  */
-struct media_pad *media_entity_remote_source(struct media_pad *pad)
+struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 {
 	unsigned int i;
 
@@ -590,4 +589,4 @@ struct media_pad *media_entity_remote_source(struct media_pad *pad)
 	return NULL;
 
 }
-EXPORT_SYMBOL_GPL(media_entity_remote_source);
+EXPORT_SYMBOL_GPL(media_entity_remote_pad);
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 528f413..a8b9b06 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -773,7 +773,7 @@ static struct media_entity *fimc_pipeline_get_head(struct media_entity *me)
 	struct media_pad *pad = &me->pads[0];
 
 	while (!(pad->flags & MEDIA_PAD_FL_SOURCE)) {
-		pad = media_entity_remote_source(pad);
+		pad = media_entity_remote_pad(pad);
 		if (!pad)
 			break;
 		me = pad->entity;
@@ -845,7 +845,7 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 					return ret;
 			}
 
-			pad = media_entity_remote_source(&me->pads[sfmt.pad]);
+			pad = media_entity_remote_pad(&me->pads[sfmt.pad]);
 			if (!pad)
 				return -EINVAL;
 			me = pad->entity;
@@ -1146,7 +1146,7 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 
 			if (p->flags & MEDIA_PAD_FL_SINK) {
 				sink_pad = p;
-				src_pad = media_entity_remote_source(sink_pad);
+				src_pad = media_entity_remote_pad(sink_pad);
 				if (src_pad)
 					break;
 			}
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 14bb7bc..2f11ae4 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -139,7 +139,7 @@ static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
 
 	while (pad->flags & MEDIA_PAD_FL_SINK) {
 		/* source pad */
-		pad = media_entity_remote_source(pad);
+		pad = media_entity_remote_pad(pad);
 		if (pad == NULL ||
 		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
@@ -786,7 +786,7 @@ static int fimc_pipeline_validate(struct fimc_lite *fimc)
 				return -EPIPE;
 		}
 		/* Retrieve format at the source pad */
-		pad = media_entity_remote_source(pad);
+		pad = media_entity_remote_pad(pad);
 		if (pad == NULL ||
 		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 15ef8f2..396e06e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -62,7 +62,7 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 			struct media_pad *spad = &me->pads[i];
 			if (!(spad->flags & MEDIA_PAD_FL_SINK))
 				continue;
-			pad = media_entity_remote_source(spad);
+			pad = media_entity_remote_pad(spad);
 			if (pad)
 				break;
 		}
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1d7dbd5..4c4bd3d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -877,7 +877,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
 			break;
 
-		pad = media_entity_remote_source(pad);
+		pad = media_entity_remote_pad(pad);
 		if (pad == NULL ||
 		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
@@ -967,7 +967,7 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
 			break;
 
-		pad = media_entity_remote_source(pad);
+		pad = media_entity_remote_pad(pad);
 		if (pad == NULL ||
 		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
@@ -1083,7 +1083,7 @@ static int isp_pipeline_is_last(struct media_entity *me)
 	pipe = to_isp_pipeline(me);
 	if (pipe->stream_state == ISP_PIPELINE_STREAM_STOPPED)
 		return 0;
-	pad = media_entity_remote_source(&pipe->output->pad);
+	pad = media_entity_remote_pad(&pipe->output->pad);
 	return pad->entity == me;
 }
 
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 60e60aa..907a205 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1120,7 +1120,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	u32 syn_mode;
 	u32 ccdc_pattern;
 
-	pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
+	pad = media_entity_remote_pad(&ccdc->pads[CCDC_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
 	if (ccdc->input == CCDC_INPUT_PARALLEL)
 		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index c5d84c9..13982b0 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -360,7 +360,7 @@ static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
 
 	ccp2_pwr_cfg(ccp2);
 
-	pad = media_entity_remote_source(&ccp2->pads[CCP2_PAD_SINK]);
+	pad = media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
 	pdata = sensor->host_priv;
 
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 783f4b0..6db245d 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -573,7 +573,7 @@ static int csi2_configure(struct isp_csi2_device *csi2)
 	if (csi2->contexts[0].enabled || csi2->ctrl.if_enable)
 		return -EBUSY;
 
-	pad = media_entity_remote_source(&csi2->pads[CSI2_PAD_SINK]);
+	pad = media_entity_remote_pad(&csi2->pads[CSI2_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
 	pdata = sensor->host_priv;
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 8dac175..a908d00 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -219,7 +219,7 @@ isp_video_remote_subdev(struct isp_video *video, u32 *pad)
 {
 	struct media_pad *remote;
 
-	remote = media_entity_remote_source(&video->pad);
+	remote = media_entity_remote_pad(&video->pad);
 
 	if (remote == NULL ||
 	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
@@ -314,7 +314,7 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 		 * entity can be found, and stop checking the pipeline if the
 		 * source entity isn't a subdev.
 		 */
-		pad = media_entity_remote_source(pad);
+		pad = media_entity_remote_pad(pad);
 		if (pad == NULL)
 			return -EPIPE;
 
@@ -901,7 +901,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 			continue;
 
 		/* ISP entities have always sink pad == 0. Find source. */
-		source_pad = media_entity_remote_source(&ents[i]->pads[0]);
+		source_pad = media_entity_remote_pad(&ents[i]->pads[0]);
 		if (source_pad == NULL)
 			continue;
 
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 70438a0..40b298a 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -845,7 +845,7 @@ static int camif_pipeline_validate(struct camif_dev *camif)
 	int ret;
 
 	/* Retrieve format at the sensor subdev source pad */
-	pad = media_entity_remote_source(&camif->pads[0]);
+	pad = media_entity_remote_pad(&camif->pads[0]);
 	if (!pad || media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 		return -EPIPE;
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index ba913f1..cb5410b 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -39,7 +39,7 @@ static struct media_entity *vpfe_get_input_entity
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct media_pad *remote;
 
-	remote = media_entity_remote_source(&vpfe_dev->vpfe_isif.pads[0]);
+	remote = media_entity_remote_pad(&vpfe_dev->vpfe_isif.pads[0]);
 	if (remote == NULL) {
 		pr_err("Invalid media connection to isif/ccdc\n");
 		return NULL;
@@ -56,7 +56,7 @@ static int vpfe_update_current_ext_subdev(struct vpfe_video_device *video)
 	struct media_pad *remote;
 	int i;
 
-	remote = media_entity_remote_source(&vpfe_dev->vpfe_isif.pads[0]);
+	remote = media_entity_remote_pad(&vpfe_dev->vpfe_isif.pads[0]);
 	if (remote == NULL) {
 		pr_err("Invalid media connection to isif/ccdc\n");
 		return -EINVAL;
@@ -89,7 +89,7 @@ static int vpfe_update_current_ext_subdev(struct vpfe_video_device *video)
 static struct v4l2_subdev *
 vpfe_video_remote_subdev(struct vpfe_video_device *video, u32 *pad)
 {
-	struct media_pad *remote = media_entity_remote_source(&video->pad);
+	struct media_pad *remote = media_entity_remote_pad(&video->pad);
 
 	if (remote == NULL || remote->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
 		return NULL;
@@ -114,7 +114,7 @@ __vpfe_video_get_format(struct vpfe_video_device *video,
 		return -EINVAL;
 
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	remote = media_entity_remote_source(&video->pad);
+	remote = media_entity_remote_pad(&video->pad);
 	fmt.pad = remote->index;
 
 	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
@@ -245,7 +245,7 @@ static int vpfe_video_validate_pipeline(struct vpfe_pipeline *pipe)
 			return -EPIPE;
 
 		/* Retrieve the source format */
-		pad = media_entity_remote_source(pad);
+		pad = media_entity_remote_pad(pad);
 		if (pad == NULL ||
 			pad->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
@@ -667,7 +667,7 @@ static int vpfe_enum_fmt(struct file *file, void  *priv,
 		return -EINVAL;
 	}
 	/* get the remote pad */
-	remote = media_entity_remote_source(&video->pad);
+	remote = media_entity_remote_pad(&video->pad);
 	if (remote == NULL) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
 			 "invalid remote pad for video node\n");
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c16f51..4eefedc 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -132,7 +132,7 @@ int __media_entity_setup_link(struct media_link *link, u32 flags);
 int media_entity_setup_link(struct media_link *link, u32 flags);
 struct media_link *media_entity_find_link(struct media_pad *source,
 		struct media_pad *sink);
-struct media_pad *media_entity_remote_source(struct media_pad *pad);
+struct media_pad *media_entity_remote_pad(struct media_pad *pad);
 
 struct media_entity *media_entity_get(struct media_entity *entity);
 void media_entity_put(struct media_entity *entity);
-- 
1.8.1.2

