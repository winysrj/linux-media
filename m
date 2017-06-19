Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56905 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdFSRBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:01:32 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v5 05/12] [media] vimc: common: Add vimc_link_validate
Date: Mon, 19 Jun 2017 14:00:14 -0300
Message-Id: <1497891629-1562-6-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
References: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All links will be checked in the same way. Adding a helper function for
that

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v5: None
Changes in v4:
[media] vimc: common: Add vimc_link_validate
	- remove vimc_fmt_pix_to_mbus(), replaced by
	v4l2_fill_mbus_format()
	- remove EXPORT_SYMBOL(vimc_link_validate), not necessary in
	this patch, moved to submodules patch
	- Fix multi-line comment style
	- If colorspace is set to DEFAULT, then assume all the other
	colorimetry parameters are also DEFAULT

Changes in v3:
[media] vimc: common: Add vimc_link_validate
	- this is a new patch in the series

Changes in v2: None


---
 drivers/media/platform/vimc/vimc-capture.c |  78 +++----------------
 drivers/media/platform/vimc/vimc-common.c  | 121 ++++++++++++++++++++++++++++-
 drivers/media/platform/vimc/vimc-common.h  |  14 ++++
 3 files changed, 145 insertions(+), 68 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 93f6a09..5bdecd1 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -64,6 +64,15 @@ static int vimc_cap_querycap(struct file *file, void *priv,
 	return 0;
 }
 
+static void vimc_cap_get_format(struct vimc_ent_device *ved,
+				struct v4l2_pix_format *fmt)
+{
+	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
+						    ved);
+
+	*fmt = vcap->format;
+}
+
 static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
@@ -231,74 +240,8 @@ static const struct vb2_ops vimc_cap_qops = {
 	.wait_finish		= vb2_ops_wait_finish,
 };
 
-/*
- * NOTE: this function is a copy of v4l2_subdev_link_validate_get_format
- * maybe the v4l2 function should be public
- */
-static int vimc_cap_v4l2_subdev_link_validate_get_format(struct media_pad *pad,
-						struct v4l2_subdev_format *fmt)
-{
-	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
-
-	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	fmt->pad = pad->index;
-
-	return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
-}
-
-static int vimc_cap_link_validate(struct media_link *link)
-{
-	struct v4l2_subdev_format source_fmt;
-	const struct vimc_pix_map *vpix;
-	struct vimc_cap_device *vcap = container_of(link->sink->entity,
-						    struct vimc_cap_device,
-						    vdev.entity);
-	struct v4l2_pix_format *sink_fmt = &vcap->format;
-	int ret;
-
-	/*
-	 * if it is a raw node from vimc-core, ignore the link for now
-	 * TODO: remove this when there are no more raw nodes in the
-	 * core and return error instead
-	 */
-	if (link->source->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
-		return 0;
-
-	/* Get the the format of the subdev */
-	ret = vimc_cap_v4l2_subdev_link_validate_get_format(link->source,
-							    &source_fmt);
-	if (ret)
-		return ret;
-
-	dev_dbg(vcap->vdev.v4l2_dev->dev,
-		"%s: link validate formats src:%dx%d %d sink:%dx%d %d\n",
-		vcap->vdev.name,
-		source_fmt.format.width, source_fmt.format.height,
-		source_fmt.format.code,
-		sink_fmt->width, sink_fmt->height,
-		sink_fmt->pixelformat);
-
-	/* The width, height and code must match. */
-	vpix = vimc_pix_map_by_pixelformat(sink_fmt->pixelformat);
-	if (source_fmt.format.width != sink_fmt->width
-	    || source_fmt.format.height != sink_fmt->height
-	    || vpix->code != source_fmt.format.code)
-		return -EPIPE;
-
-	/*
-	 * The field order must match, or the sink field order must be NONE
-	 * to support interlaced hardware connected to bridges that support
-	 * progressive formats only.
-	 */
-	if (source_fmt.format.field != sink_fmt->field &&
-	    sink_fmt->field != V4L2_FIELD_NONE)
-		return -EPIPE;
-
-	return 0;
-}
-
 static const struct media_entity_operations vimc_cap_mops = {
-	.link_validate		= vimc_cap_link_validate,
+	.link_validate		= vimc_link_validate,
 };
 
 static void vimc_cap_destroy(struct vimc_ent_device *ved)
@@ -434,6 +377,7 @@ struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
 	vcap->ved.destroy = vimc_cap_destroy;
 	vcap->ved.ent = &vcap->vdev.entity;
 	vcap->ved.process_frame = vimc_cap_process_frame;
+	vcap->ved.vdev_get_format = vimc_cap_get_format;
 
 	/* Initialize the video_device struct */
 	vdev = &vcap->vdev;
diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index f809a9d..6ad77fd 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -252,8 +252,127 @@ int vimc_pipeline_s_stream(struct media_entity *ent, int enable)
 	return 0;
 }
 
+static int vimc_get_mbus_format(struct media_pad *pad,
+				struct v4l2_subdev_format *fmt)
+{
+	if (is_media_entity_v4l2_subdev(pad->entity)) {
+		struct v4l2_subdev *sd =
+			media_entity_to_v4l2_subdev(pad->entity);
+		int ret;
+
+		fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		fmt->pad = pad->index;
+
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
+		if (ret)
+			return ret;
+
+	} else if (is_media_entity_v4l2_video_device(pad->entity)) {
+		struct video_device *vdev = container_of(pad->entity,
+							 struct video_device,
+							 entity);
+		struct vimc_ent_device *ved = video_get_drvdata(vdev);
+		const struct vimc_pix_map *vpix;
+		struct v4l2_pix_format vdev_fmt;
+
+		if (!ved->vdev_get_format)
+			return -ENOIOCTLCMD;
+
+		ved->vdev_get_format(ved, &vdev_fmt);
+		vpix = vimc_pix_map_by_pixelformat(vdev_fmt.pixelformat);
+		v4l2_fill_mbus_format(&fmt->format, &vdev_fmt, vpix->code);
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int vimc_link_validate(struct media_link *link)
+{
+	struct v4l2_subdev_format source_fmt, sink_fmt;
+	int ret;
+
+	/*
+	 * if it is a raw node from vimc-core, ignore the link for now
+	 * TODO: remove this when there are no more raw nodes in the
+	 * core and return error instead
+	 */
+	if (link->source->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
+		return 0;
+
+	ret = vimc_get_mbus_format(link->source, &source_fmt);
+	if (ret)
+		return ret;
+
+	ret = vimc_get_mbus_format(link->sink, &sink_fmt);
+	if (ret)
+		return ret;
+
+	pr_info("vimc link validate: "
+		"%s:src:%dx%d (0x%x, %d, %d, %d, %d) "
+		"%s:snk:%dx%d (0x%x, %d, %d, %d, %d)\n",
+		/* src */
+		link->source->entity->name,
+		source_fmt.format.width, source_fmt.format.height,
+		source_fmt.format.code, source_fmt.format.colorspace,
+		source_fmt.format.quantization, source_fmt.format.xfer_func,
+		source_fmt.format.ycbcr_enc,
+		/* sink */
+		link->sink->entity->name,
+		sink_fmt.format.width, sink_fmt.format.height,
+		sink_fmt.format.code, sink_fmt.format.colorspace,
+		sink_fmt.format.quantization, sink_fmt.format.xfer_func,
+		sink_fmt.format.ycbcr_enc);
+
+	/* The width, height and code must match. */
+	if (source_fmt.format.width != sink_fmt.format.width
+	    || source_fmt.format.height != sink_fmt.format.height
+	    || source_fmt.format.code != sink_fmt.format.code)
+		return -EPIPE;
+
+	/*
+	 * The field order must match, or the sink field order must be NONE
+	 * to support interlaced hardware connected to bridges that support
+	 * progressive formats only.
+	 */
+	if (source_fmt.format.field != sink_fmt.format.field &&
+	    sink_fmt.format.field != V4L2_FIELD_NONE)
+		return -EPIPE;
+
+	/*
+	 * If colorspace is DEFAULT, then assume all the colorimetry is also
+	 * DEFAULT, return 0 to skip comparing the other colorimetry parameters
+	 */
+	if (source_fmt.format.colorspace == V4L2_COLORSPACE_DEFAULT
+	    || sink_fmt.format.colorspace == V4L2_COLORSPACE_DEFAULT)
+		return 0;
+
+	/* Colorspace must match. */
+	if (source_fmt.format.colorspace != sink_fmt.format.colorspace)
+		return -EPIPE;
+
+	/* Colorimetry must match if they are not set to DEFAULT */
+	if (source_fmt.format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
+	    && sink_fmt.format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
+	    && source_fmt.format.ycbcr_enc != sink_fmt.format.ycbcr_enc)
+		return -EPIPE;
+
+	if (source_fmt.format.quantization != V4L2_QUANTIZATION_DEFAULT
+	    && sink_fmt.format.quantization != V4L2_QUANTIZATION_DEFAULT
+	    && source_fmt.format.quantization != sink_fmt.format.quantization)
+		return -EPIPE;
+
+	if (source_fmt.format.xfer_func != V4L2_XFER_FUNC_DEFAULT
+	    && sink_fmt.format.xfer_func != V4L2_XFER_FUNC_DEFAULT
+	    && source_fmt.format.xfer_func != sink_fmt.format.xfer_func)
+		return -EPIPE;
+
+	return 0;
+}
+
 static const struct media_entity_operations vimc_ent_sd_mops = {
-	.link_validate = v4l2_subdev_link_validate,
+	.link_validate = vimc_link_validate,
 };
 
 int vimc_ent_sd_register(struct vimc_ent_device *ved,
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 73e7e94..60ebde2 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -45,6 +45,9 @@ struct vimc_pix_map {
  * @pads:		the list of pads of the node
  * @destroy:		callback to destroy the node
  * @process_frame:	callback send a frame to that node
+ * @vdev_get_format:	callback that returns the current format a pad, used
+ *			only when is_media_entity_v4l2_video_device(ent) returns
+ *			true
  *
  * Each node of the topology must create a vimc_ent_device struct. Depending on
  * the node it will be of an instance of v4l2_subdev or video_device struct
@@ -60,6 +63,8 @@ struct vimc_ent_device {
 	void (*destroy)(struct vimc_ent_device *);
 	void (*process_frame)(struct vimc_ent_device *ved,
 			      struct media_pad *sink, const void *frame);
+	void (*vdev_get_format)(struct vimc_ent_device *ved,
+			      struct v4l2_pix_format *fmt);
 };
 
 /**
@@ -160,4 +165,13 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 void vimc_ent_sd_unregister(struct vimc_ent_device *ved,
 			    struct v4l2_subdev *sd);
 
+/**
+ * vimc_link_validate - validates a media link
+ *
+ * @link: pointer to &struct media_link
+ *
+ * This function calls validates if a media link is valid for streaming.
+ */
+int vimc_link_validate(struct media_link *link);
+
 #endif
-- 
2.7.4
