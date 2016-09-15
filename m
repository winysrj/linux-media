Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52515 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbcIOVK0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 17:10:26 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH] v4l: vsp1: Disable VYUY on Gen3
Date: Fri, 16 Sep 2016 00:11:00 +0300
Message-Id: <1473973860-19516-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VYUY format isn't supported on Gen3 hardware, disable it.

Gen2 hardware supports VYUY in practice even though the documentation
doesn't advertise it, so keep it for Gen2 devices.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c   | 2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  | 8 +++++++-
 drivers/media/platform/vsp1/vsp1_pipe.h  | 3 ++-
 drivers/media/platform/vsp1/vsp1_video.c | 4 ++--
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 832286975e71..54795b5e5a8a 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -286,7 +286,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	/* Store the format, stride, memory buffer address, crop and compose
 	 * rectangles and Z-order position and for the input.
 	 */
-	fmtinfo = vsp1_get_format_info(cfg->pixelformat);
+	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
 	if (!fmtinfo) {
 		dev_dbg(vsp1->dev, "Unsupport pixel format %08x for RPF\n",
 			cfg->pixelformat);
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 474de82165d8..78b6184f91ce 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -138,15 +138,21 @@ static const struct vsp1_format_info vsp1_video_formats[] = {
 
 /*
  * vsp1_get_format_info - Retrieve format information for a 4CC
+ * @vsp1: the VSP1 device
  * @fourcc: the format 4CC
  *
  * Return a pointer to the format information structure corresponding to the
  * given V4L2 format 4CC, or NULL if no corresponding format can be found.
  */
-const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc)
+const struct vsp1_format_info *vsp1_get_format_info(struct vsp1_device *vsp1,
+						    u32 fourcc)
 {
 	unsigned int i;
 
+	/* Special case, the VYUY format is supported on Gen2 only. */
+	if (vsp1->info->gen != 2 && fourcc == V4L2_PIX_FMT_VYUY)
+		return NULL;
+
 	for (i = 0; i < ARRAY_SIZE(vsp1_video_formats); ++i) {
 		const struct vsp1_format_info *info = &vsp1_video_formats[i];
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index f15b697ad999..ac4ad2655551 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -130,6 +130,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
 void vsp1_pipelines_resume(struct vsp1_device *vsp1);
 
-const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc);
+const struct vsp1_format_info *vsp1_get_format_info(struct vsp1_device *vsp1,
+						    u32 fourcc);
 
 #endif /* __VSP1_PIPE_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 15d08cb50bd1..e773d3d30df2 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -117,9 +117,9 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	/* Retrieve format information and select the default format if the
 	 * requested format isn't supported.
 	 */
-	info = vsp1_get_format_info(pix->pixelformat);
+	info = vsp1_get_format_info(video->vsp1, pix->pixelformat);
 	if (info == NULL)
-		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
+		info = vsp1_get_format_info(video->vsp1, VSP1_VIDEO_DEF_FORMAT);
 
 	pix->pixelformat = info->fourcc;
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
-- 
Regards,

Laurent Pinchart

