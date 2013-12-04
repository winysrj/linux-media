Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3LDA40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:26 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5AC5B35AD2
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:38 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/25] v4l: omap4iss: Restrict line lengths to 80 characters where possible
Date: Wed,  4 Dec 2013 01:56:03 +0100
Message-Id: <1386118585-12449-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csiphy.c  |  6 ++-
 drivers/staging/media/omap4iss/iss_ipipeif.c | 63 ++++++++++++++++------------
 drivers/staging/media/omap4iss/iss_resizer.c | 47 ++++++++++++---------
 drivers/staging/media/omap4iss/iss_video.c   | 11 +++--
 4 files changed, 74 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index e0d0247..25e6f89 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -178,7 +178,8 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 		if (lanes->data[i].pos == 0)
 			continue;
 
-		if (lanes->data[i].pol > 1 || lanes->data[i].pos > (csi2->phy->max_data_lanes + 1))
+		if (lanes->data[i].pol > 1 ||
+		    lanes->data[i].pos > (csi2->phy->max_data_lanes + 1))
 			return -EINVAL;
 
 		if (used_lanes & (1 << lanes->data[i].pos))
@@ -188,7 +189,8 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 		csi2->phy->used_data_lanes++;
 	}
 
-	if (lanes->clk.pol > 1 || lanes->clk.pos > (csi2->phy->max_data_lanes + 1))
+	if (lanes->clk.pol > 1 ||
+	    lanes->clk.pos > (csi2->phy->max_data_lanes + 1))
 		return -EINVAL;
 
 	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index acc6005..eee6891 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -23,10 +23,6 @@
 #include "iss_regs.h"
 #include "iss_ipipeif.h"
 
-static struct v4l2_mbus_framefmt *
-__ipipeif_get_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh,
-		  unsigned int pad, enum v4l2_subdev_format_whence which);
-
 static const unsigned int ipipeif_fmts[] = {
 	V4L2_MBUS_FMT_SGRBG10_1X10,
 	V4L2_MBUS_FMT_SRGGB10_1X10,
@@ -274,7 +270,8 @@ static void ipipeif_isif0_isr(struct iss_ipipeif_device *ipipeif)
  */
 void omap4iss_ipipeif_isr(struct iss_ipipeif_device *ipipeif, u32 events)
 {
-	if (omap4iss_module_sync_is_stopping(&ipipeif->wait, &ipipeif->stopping))
+	if (omap4iss_module_sync_is_stopping(&ipipeif->wait,
+					     &ipipeif->stopping))
 		return;
 
 	if (events & ISP5_IRQ_ISIF0)
@@ -285,7 +282,8 @@ void omap4iss_ipipeif_isr(struct iss_ipipeif_device *ipipeif, u32 events)
  * ISP video operations
  */
 
-static int ipipeif_video_queue(struct iss_video *video, struct iss_buffer *buffer)
+static int ipipeif_video_queue(struct iss_video *video,
+			       struct iss_buffer *buffer)
 {
 	struct iss_ipipeif_device *ipipeif = container_of(video,
 				struct iss_ipipeif_device, video_out);
@@ -385,8 +383,9 @@ static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static struct v4l2_mbus_framefmt *
-__ipipeif_get_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh,
-		  unsigned int pad, enum v4l2_subdev_format_whence which)
+__ipipeif_get_format(struct iss_ipipeif_device *ipipeif,
+		     struct v4l2_subdev_fh *fh, unsigned int pad,
+		     enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
 		return v4l2_subdev_get_try_format(fh, pad);
@@ -402,9 +401,10 @@ __ipipeif_get_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *
  * @fmt: Format
  */
 static void
-ipipeif_try_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh,
-		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
-		enum v4l2_subdev_format_whence which)
+ipipeif_try_format(struct iss_ipipeif_device *ipipeif,
+		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_mbus_framefmt *fmt,
+		   enum v4l2_subdev_format_whence which)
 {
 	struct v4l2_mbus_framefmt *format;
 	unsigned int width = fmt->width;
@@ -413,8 +413,8 @@ ipipeif_try_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh
 
 	switch (pad) {
 	case IPIPEIF_PAD_SINK:
-		/* TODO: If the IPIPEIF output formatter pad is connected directly
-		 * to the resizer, only YUV formats can be used.
+		/* TODO: If the IPIPEIF output formatter pad is connected
+		 * directly to the resizer, only YUV formats can be used.
 		 */
 		for (i = 0; i < ARRAY_SIZE(ipipeif_fmts); i++) {
 			if (fmt->code == ipipeif_fmts[i])
@@ -431,7 +431,8 @@ ipipeif_try_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh
 		break;
 
 	case IPIPEIF_PAD_SOURCE_ISIF_SF:
-		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK, which);
+		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK,
+					      which);
 		memcpy(fmt, format, sizeof(*fmt));
 
 		/* The data formatter truncates the number of horizontal output
@@ -445,7 +446,8 @@ ipipeif_try_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh
 		break;
 
 	case IPIPEIF_PAD_SOURCE_VP:
-		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK, which);
+		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK,
+					      which);
 		memcpy(fmt, format, sizeof(*fmt));
 
 		fmt->width = clamp_t(u32, width, 32, fmt->width);
@@ -514,7 +516,8 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipeif_try_format(ipipeif, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -524,7 +527,8 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipeif_try_format(ipipeif, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -578,14 +582,16 @@ static int ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == IPIPEIF_PAD_SINK) {
-		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_ISIF_SF,
-					   fmt->which);
+		format = __ipipeif_get_format(ipipeif, fh,
+					      IPIPEIF_PAD_SOURCE_ISIF_SF,
+					      fmt->which);
 		*format = fmt->format;
-		ipipeif_try_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_ISIF_SF, format,
-				fmt->which);
+		ipipeif_try_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_ISIF_SF,
+				   format, fmt->which);
 
-		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_VP,
-					   fmt->which);
+		format = __ipipeif_get_format(ipipeif, fh,
+					      IPIPEIF_PAD_SOURCE_VP,
+					      fmt->which);
 		*format = fmt->format;
 		ipipeif_try_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_VP, format,
 				fmt->which);
@@ -594,7 +600,8 @@ static int ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int ipipeif_link_validate(struct v4l2_subdev *sd, struct media_link *link,
+static int ipipeif_link_validate(struct v4l2_subdev *sd,
+				 struct media_link *link,
 				 struct v4l2_subdev_format *source_fmt,
 				 struct v4l2_subdev_format *sink_fmt)
 {
@@ -618,7 +625,8 @@ static int ipipeif_link_validate(struct v4l2_subdev *sd, struct media_link *link
  * formats are initialized on the file handle. Otherwise active formats are
  * initialized on the device.
  */
-static int ipipeif_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+static int ipipeif_init_formats(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_subdev_format format;
 
@@ -778,8 +786,9 @@ static int ipipeif_init_entities(struct iss_ipipeif_device *ipipeif)
 		return ret;
 
 	/* Connect the IPIPEIF subdev to the video node. */
-	ret = media_entity_create_link(&ipipeif->subdev.entity, IPIPEIF_PAD_SOURCE_ISIF_SF,
-			&ipipeif->video_out.video.entity, 0, 0);
+	ret = media_entity_create_link(&ipipeif->subdev.entity,
+				       IPIPEIF_PAD_SOURCE_ISIF_SF,
+				       &ipipeif->video_out.video.entity, 0, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index e5a3a8cf..08b2505 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -23,10 +23,6 @@
 #include "iss_regs.h"
 #include "iss_resizer.h"
 
-static struct v4l2_mbus_framefmt *
-__resizer_get_format(struct iss_resizer_device *resizer, struct v4l2_subdev_fh *fh,
-		  unsigned int pad, enum v4l2_subdev_format_whence which);
-
 static const unsigned int resizer_fmts[] = {
 	V4L2_MBUS_FMT_UYVY8_1X16,
 	V4L2_MBUS_FMT_YUYV8_1X16,
@@ -329,7 +325,8 @@ void omap4iss_resizer_isr(struct iss_resizer_device *resizer, u32 events)
 		pipe->error = true;
 	}
 
-	if (omap4iss_module_sync_is_stopping(&resizer->wait, &resizer->stopping))
+	if (omap4iss_module_sync_is_stopping(&resizer->wait,
+					     &resizer->stopping))
 		return;
 
 	if (events & ISP5_IRQ_RSZ_INT_DMA)
@@ -340,7 +337,8 @@ void omap4iss_resizer_isr(struct iss_resizer_device *resizer, u32 events)
  * ISS video operations
  */
 
-static int resizer_video_queue(struct iss_video *video, struct iss_buffer *buffer)
+static int resizer_video_queue(struct iss_video *video,
+			       struct iss_buffer *buffer)
 {
 	struct iss_resizer_device *resizer = container_of(video,
 				struct iss_resizer_device, video_out);
@@ -453,8 +451,9 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static struct v4l2_mbus_framefmt *
-__resizer_get_format(struct iss_resizer_device *resizer, struct v4l2_subdev_fh *fh,
-		  unsigned int pad, enum v4l2_subdev_format_whence which)
+__resizer_get_format(struct iss_resizer_device *resizer,
+		     struct v4l2_subdev_fh *fh, unsigned int pad,
+		     enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
 		return v4l2_subdev_get_try_format(fh, pad);
@@ -470,9 +469,10 @@ __resizer_get_format(struct iss_resizer_device *resizer, struct v4l2_subdev_fh *
  * @fmt: Format
  */
 static void
-resizer_try_format(struct iss_resizer_device *resizer, struct v4l2_subdev_fh *fh,
-		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
-		enum v4l2_subdev_format_whence which)
+resizer_try_format(struct iss_resizer_device *resizer,
+		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_mbus_framefmt *fmt,
+		   enum v4l2_subdev_format_whence which)
 {
 	enum v4l2_mbus_pixelcode pixelcode;
 	struct v4l2_mbus_framefmt *format;
@@ -498,7 +498,8 @@ resizer_try_format(struct iss_resizer_device *resizer, struct v4l2_subdev_fh *fh
 
 	case RESIZER_PAD_SOURCE_MEM:
 		pixelcode = fmt->code;
-		format = __resizer_get_format(resizer, fh, RESIZER_PAD_SINK, which);
+		format = __resizer_get_format(resizer, fh, RESIZER_PAD_SINK,
+					      which);
 		memcpy(fmt, format, sizeof(*fmt));
 
 		if ((pixelcode == V4L2_MBUS_FMT_YUYV8_1_5X8) &&
@@ -586,7 +587,8 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	resizer_try_format(resizer, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(resizer, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -596,7 +598,8 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	resizer_try_format(resizer, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(resizer, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -650,8 +653,9 @@ static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == RESIZER_PAD_SINK) {
-		format = __resizer_get_format(resizer, fh, RESIZER_PAD_SOURCE_MEM,
-					   fmt->which);
+		format = __resizer_get_format(resizer, fh,
+					      RESIZER_PAD_SOURCE_MEM,
+					      fmt->which);
 		*format = fmt->format;
 		resizer_try_format(resizer, fh, RESIZER_PAD_SOURCE_MEM, format,
 				fmt->which);
@@ -660,7 +664,8 @@ static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int resizer_link_validate(struct v4l2_subdev *sd, struct media_link *link,
+static int resizer_link_validate(struct v4l2_subdev *sd,
+				 struct media_link *link,
 				 struct v4l2_subdev_format *source_fmt,
 				 struct v4l2_subdev_format *sink_fmt)
 {
@@ -684,7 +689,8 @@ static int resizer_link_validate(struct v4l2_subdev *sd, struct media_link *link
  * formats are initialized on the file handle. Otherwise active formats are
  * initialized on the device.
  */
-static int resizer_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+static int resizer_init_formats(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_subdev_format format;
 
@@ -833,8 +839,9 @@ static int resizer_init_entities(struct iss_resizer_device *resizer)
 		return ret;
 
 	/* Connect the RESIZER subdev to the video node. */
-	ret = media_entity_create_link(&resizer->subdev.entity, RESIZER_PAD_SOURCE_MEM,
-			&resizer->video_out.video.entity, 0, 0);
+	ret = media_entity_create_link(&resizer->subdev.entity,
+				       RESIZER_PAD_SOURCE_MEM,
+				       &resizer->video_out.video.entity, 0, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 3e543d9..0a7137b 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -282,7 +282,8 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
  * Video queue operations
  */
 
-static int iss_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int iss_video_queue_setup(struct vb2_queue *vq,
+				 const struct v4l2_format *fmt,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -298,7 +299,7 @@ static int iss_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format
 
 	alloc_ctxs[0] = video->alloc_ctx;
 
-	*count = min(*count, (unsigned int)(video->capture_mem / PAGE_ALIGN(sizes[0])));
+	*count = min(*count, video->capture_mem / PAGE_ALIGN(sizes[0]));
 
 	return 0;
 }
@@ -425,11 +426,13 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	 * first, so the input number might lag behind by 1 in some cases.
 	 */
 	if (video == pipe->output && !pipe->do_propagation)
-		buf->vb.v4l2_buf.sequence = atomic_inc_return(&pipe->frame_number);
+		buf->vb.v4l2_buf.sequence =
+			atomic_inc_return(&pipe->frame_number);
 	else
 		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
 
-	vb2_buffer_done(&buf->vb, pipe->error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb, pipe->error ?
+			VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 	pipe->error = false;
 
 	spin_lock_irqsave(&video->qlock, flags);
-- 
1.8.3.2

