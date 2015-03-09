Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58896 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbbCIP4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:56:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 27/29] vivid: add support for single buffer planar formats
Date: Mon,  9 Mar 2015 16:44:49 +0100
Message-Id: <1425915891-1017-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make vivid aware of the difference of planes and buffers. Note that
this does not yet add support for hor/vert downsampled formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h        |  2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c | 54 ++++++++++++------
 drivers/media/platform/vivid/vivid-vid-cap.c     | 58 ++++++++++----------
 drivers/media/platform/vivid/vivid-vid-common.c  |  2 +-
 drivers/media/platform/vivid/vivid-vid-out.c     | 70 ++++++++++++++----------
 5 files changed, 106 insertions(+), 80 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index bcefd19..9e15aee 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -334,7 +334,7 @@ struct vivid_dev {
 	u32				ycbcr_enc_out;
 	u32				quantization_out;
 	u32				service_set_out;
-	u32				bytesperline_out[TPG_MAX_PLANES];
+	unsigned			bytesperline_out[TPG_MAX_PLANES];
 	unsigned			tv_field_out;
 	unsigned			tv_audio_output;
 	bool				vbi_out_have_wss;
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 9976d45..22e1784 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -229,6 +229,20 @@ static void vivid_precalc_copy_rects(struct vivid_dev *dev)
 		dev->loop_vid_overlay_cap.left, dev->loop_vid_overlay_cap.top);
 }
 
+static void *plane_vaddr(struct tpg_data *tpg, struct vivid_buffer *buf,
+			 unsigned p, unsigned bpl[TPG_MAX_PLANES], unsigned h)
+{
+	unsigned i;
+	void *vbuf;
+
+	if (p == 0 || tpg_g_buffers(tpg) > 1)
+		return vb2_plane_vaddr(&buf->vb, p);
+	vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	for (i = 0; i < p; i++)
+		vbuf += bpl[i] * h / tpg->vdownsampling[i];
+	return vbuf;
+}
+
 static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 		struct vivid_buffer *vid_cap_buf)
 {
@@ -269,8 +283,10 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 
 	vid_cap_buf->vb.v4l2_buf.field = vid_out_buf->vb.v4l2_buf.field;
 
-	voutbuf = vb2_plane_vaddr(&vid_out_buf->vb, p) +
-				  vid_out_buf->vb.v4l2_planes[p].data_offset;
+	voutbuf = plane_vaddr(tpg, vid_out_buf, p,
+			      dev->bytesperline_out, dev->fmt_out_rect.height);
+	if (p < dev->fmt_out->buffers)
+		voutbuf += vid_out_buf->vb.v4l2_planes[p].data_offset;
 	voutbuf += dev->loop_vid_out.left * pixsize + dev->loop_vid_out.top * stride_out;
 	vcapbuf += dev->compose_cap.left * pixsize + dev->compose_cap.top * stride_cap;
 
@@ -395,6 +411,7 @@ update_vid_out_y:
 
 static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
+	struct tpg_data *tpg = &dev->tpg;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_cap) ? 2 : 1;
 	unsigned line_height = 16 / factor;
 	bool is_tv = vivid_is_sdtv_cap(dev);
@@ -436,28 +453,29 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	} else {
 		buf->vb.v4l2_buf.field = dev->field_cap;
 	}
-	tpg_s_field(&dev->tpg, buf->vb.v4l2_buf.field,
+	tpg_s_field(tpg, buf->vb.v4l2_buf.field,
 		    dev->field_cap == V4L2_FIELD_ALTERNATE);
-	tpg_s_perc_fill_blank(&dev->tpg, dev->must_blank[buf->vb.v4l2_buf.index]);
+	tpg_s_perc_fill_blank(tpg, dev->must_blank[buf->vb.v4l2_buf.index]);
 
 	vivid_precalc_copy_rects(dev);
 
-	for (p = 0; p < tpg_g_planes(&dev->tpg); p++) {
-		void *vbuf = vb2_plane_vaddr(&buf->vb, p);
+	for (p = 0; p < tpg_g_planes(tpg); p++) {
+		void *vbuf = plane_vaddr(tpg, buf, p,
+					 tpg->bytesperline, tpg->buf_height);
 
 		/*
 		 * The first plane of a multiplanar format has a non-zero
 		 * data_offset. This helps testing whether the application
 		 * correctly supports non-zero data offsets.
 		 */
-		if (dev->fmt_cap->data_offset[p]) {
+		if (p < tpg_g_buffers(tpg) && dev->fmt_cap->data_offset[p]) {
 			memset(vbuf, dev->fmt_cap->data_offset[p] & 0xff,
 			       dev->fmt_cap->data_offset[p]);
 			vbuf += dev->fmt_cap->data_offset[p];
 		}
-		tpg_calc_text_basep(&dev->tpg, basep, p, vbuf);
+		tpg_calc_text_basep(tpg, basep, p, vbuf);
 		if (!is_loop || vivid_copy_buffer(dev, p, vbuf, buf))
-			tpg_fillbuffer(&dev->tpg, vivid_get_std_cap(dev), p, vbuf);
+			tpg_fill_plane_buffer(tpg, vivid_get_std_cap(dev), p, vbuf);
 	}
 	dev->must_blank[buf->vb.v4l2_buf.index] = false;
 
@@ -476,12 +494,12 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 				(dev->field_cap == V4L2_FIELD_ALTERNATE) ?
 					(buf->vb.v4l2_buf.field == V4L2_FIELD_TOP ?
 					 " top" : " bottom") : "");
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 	}
 	if (dev->osd_mode == 0) {
 		snprintf(str, sizeof(str), " %dx%d, input %d ",
 				dev->src_rect.width, dev->src_rect.height, dev->input);
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 
 		gain = v4l2_ctrl_g_ctrl(dev->gain);
 		mutex_lock(dev->ctrl_hdl_user_vid.lock);
@@ -491,38 +509,38 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 			dev->contrast->cur.val,
 			dev->saturation->cur.val,
 			dev->hue->cur.val);
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		snprintf(str, sizeof(str),
 			" autogain %d, gain %3d, alpha 0x%02x ",
 			dev->autogain->cur.val, gain, dev->alpha->cur.val);
 		mutex_unlock(dev->ctrl_hdl_user_vid.lock);
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		mutex_lock(dev->ctrl_hdl_user_aud.lock);
 		snprintf(str, sizeof(str),
 			" volume %3d, mute %d ",
 			dev->volume->cur.val, dev->mute->cur.val);
 		mutex_unlock(dev->ctrl_hdl_user_aud.lock);
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		mutex_lock(dev->ctrl_hdl_user_gen.lock);
 		snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
 			dev->int32->cur.val,
 			*dev->int64->p_cur.p_s64,
 			dev->bitmask->cur.val);
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		snprintf(str, sizeof(str), " boolean %d, menu %s, string \"%s\" ",
 			dev->boolean->cur.val,
 			dev->menu->qmenu[dev->menu->cur.val],
 			dev->string->p_cur.p_char);
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		snprintf(str, sizeof(str), " integer_menu %lld, value %d ",
 			dev->int_menu->qmenu_int[dev->int_menu->cur.val],
 			dev->int_menu->cur.val);
 		mutex_unlock(dev->ctrl_hdl_user_gen.lock);
-		tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		if (dev->button_pressed) {
 			dev->button_pressed--;
 			snprintf(str, sizeof(str), " button pressed!");
-			tpg_gen_text(&dev->tpg, basep, line++ * line_height, 16, str);
+			tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		}
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 4d50961..1d9ea2d 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -100,7 +100,7 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 		       unsigned sizes[], void *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
-	unsigned planes = tpg_g_planes(&dev->tpg);
+	unsigned buffers = tpg_g_buffers(&dev->tpg);
 	unsigned h = dev->fmt_cap_rect.height;
 	unsigned p;
 
@@ -133,39 +133,36 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 		mp = &fmt->fmt.pix_mp;
 		/*
 		 * Check if the number of planes in the specified format match
-		 * the number of planes in the current format. You can't mix that.
+		 * the number of buffers in the current format. You can't mix that.
 		 */
-		if (mp->num_planes != planes)
+		if (mp->num_planes != buffers)
 			return -EINVAL;
 		vfmt = vivid_get_format(dev, mp->pixelformat);
-		for (p = 0; p < planes; p++) {
+		for (p = 0; p < buffers; p++) {
 			sizes[p] = mp->plane_fmt[p].sizeimage;
-			if (sizes[0] < tpg_g_bytesperline(&dev->tpg, 0) * h +
+			if (sizes[p] < tpg_g_line_width(&dev->tpg, p) * h +
 							vfmt->data_offset[p])
 				return -EINVAL;
 		}
 	} else {
-		for (p = 0; p < planes; p++)
-			sizes[p] = tpg_g_bytesperline(&dev->tpg, p) * h +
+		for (p = 0; p < buffers; p++)
+			sizes[p] = tpg_g_line_width(&dev->tpg, p) * h +
 					dev->fmt_cap->data_offset[p];
 	}
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
 
-	*nplanes = planes;
+	*nplanes = buffers;
 
 	/*
 	 * videobuf2-vmalloc allocator is context-less so no need to set
 	 * alloc_ctxs array.
 	 */
 
-	if (planes == 2)
-		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
-			*nbuffers, sizes[0], sizes[1]);
-	else
-		dprintk(dev, 1, "%s, count=%d, size=%u\n", __func__,
-			*nbuffers, sizes[0]);
+	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
+	for (p = 0; p < buffers; p++)
+		dprintk(dev, 1, "%s: size[%u]=%u\n", __func__, p, sizes[p]);
 
 	return 0;
 }
@@ -174,7 +171,7 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
-	unsigned planes = tpg_g_planes(&dev->tpg);
+	unsigned buffers = tpg_g_buffers(&dev->tpg);
 	unsigned p;
 
 	dprintk(dev, 1, "%s\n", __func__);
@@ -190,8 +187,8 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 		dev->buf_prepare_error = false;
 		return -EINVAL;
 	}
-	for (p = 0; p < planes; p++) {
-		size = tpg_g_bytesperline(&dev->tpg, p) * dev->fmt_cap_rect.height +
+	for (p = 0; p < buffers; p++) {
+		size = tpg_g_line_width(&dev->tpg, p) * dev->fmt_cap_rect.height +
 			dev->fmt_cap->data_offset[p];
 
 		if (vb2_plane_size(vb, p) < size) {
@@ -532,11 +529,11 @@ int vivid_g_fmt_vid_cap(struct file *file, void *priv,
 	mp->colorspace   = vivid_colorspace_cap(dev);
 	mp->ycbcr_enc    = vivid_ycbcr_enc_cap(dev);
 	mp->quantization = vivid_quantization_cap(dev);
-	mp->num_planes = dev->fmt_cap->planes;
+	mp->num_planes = dev->fmt_cap->buffers;
 	for (p = 0; p < mp->num_planes; p++) {
 		mp->plane_fmt[p].bytesperline = tpg_g_bytesperline(&dev->tpg, p);
 		mp->plane_fmt[p].sizeimage =
-			mp->plane_fmt[p].bytesperline * mp->height +
+			tpg_g_line_width(&dev->tpg, p) * mp->height +
 			dev->fmt_cap->data_offset[p];
 	}
 	return 0;
@@ -602,18 +599,19 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 
 	/* This driver supports custom bytesperline values */
 
-	/* Calculate the minimum supported bytesperline value */
-	bytesperline = (mp->width * fmt->bit_depth[0]) >> 3;
-	/* Calculate the maximum supported bytesperline value */
-	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->bit_depth[0]) >> 3;
-	mp->num_planes = fmt->planes;
+	mp->num_planes = fmt->buffers;
 	for (p = 0; p < mp->num_planes; p++) {
+		/* Calculate the minimum supported bytesperline value */
+		bytesperline = (mp->width * fmt->bit_depth[p]) >> 3;
+		/* Calculate the maximum supported bytesperline value */
+		max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->bit_depth[p]) >> 3;
+
 		if (pfmt[p].bytesperline > max_bpl)
 			pfmt[p].bytesperline = max_bpl;
 		if (pfmt[p].bytesperline < bytesperline)
 			pfmt[p].bytesperline = bytesperline;
-		pfmt[p].sizeimage = pfmt[p].bytesperline * mp->height +
-			fmt->data_offset[p];
+		pfmt[p].sizeimage = tpg_calc_line_width(&dev->tpg, p, pfmt[p].bytesperline) *
+			mp->height + fmt->data_offset[p];
 		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
 	}
 	mp->colorspace = vivid_colorspace_cap(dev);
@@ -633,6 +631,7 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
 	struct vb2_queue *q = &dev->vb_vid_cap_q;
 	int ret = vivid_try_fmt_vid_cap(file, priv, f);
 	unsigned factor = 1;
+	unsigned p;
 	unsigned i;
 
 	if (ret < 0)
@@ -735,16 +734,15 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->fmt_cap_rect.width = mp->width;
 	dev->fmt_cap_rect.height = mp->height;
 	tpg_s_buf_height(&dev->tpg, mp->height);
-	tpg_s_bytesperline(&dev->tpg, 0, mp->plane_fmt[0].bytesperline);
-	if (tpg_g_planes(&dev->tpg) > 1)
-		tpg_s_bytesperline(&dev->tpg, 1, mp->plane_fmt[1].bytesperline);
+	tpg_s_fourcc(&dev->tpg, dev->fmt_cap->fourcc);
+	for (p = 0; p < tpg_g_buffers(&dev->tpg); p++)
+		tpg_s_bytesperline(&dev->tpg, p, mp->plane_fmt[p].bytesperline);
 	dev->field_cap = mp->field;
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
 		tpg_s_field(&dev->tpg, V4L2_FIELD_TOP, true);
 	else
 		tpg_s_field(&dev->tpg, dev->field_cap, false);
 	tpg_s_crop_compose(&dev->tpg, &dev->crop_cap, &dev->compose_cap);
-	tpg_s_fourcc(&dev->tpg, dev->fmt_cap->fourcc);
 	if (vivid_is_sdtv_cap(dev))
 		dev->tv_field_cap = mp->field;
 	tpg_update_mv_step(&dev->tpg);
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 7a02aef..0f93fea 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -234,7 +234,7 @@ const struct vivid_fmt *vivid_get_format(struct vivid_dev *dev, u32 pixelformat)
 	for (k = 0; k < ARRAY_SIZE(vivid_formats); k++) {
 		fmt = &vivid_formats[k];
 		if (fmt->fourcc == pixelformat)
-			if (fmt->planes == 1 || dev->multiplanar)
+			if (fmt->buffers == 1 || dev->multiplanar)
 				return fmt;
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 17b026b..69fd382 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -36,9 +36,14 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 		       unsigned sizes[], void *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
-	unsigned planes = dev->fmt_out->planes;
+	const struct vivid_fmt *vfmt = dev->fmt_out;
+	unsigned planes = vfmt->buffers;
 	unsigned h = dev->fmt_out_rect.height;
 	unsigned size = dev->bytesperline_out[0] * h;
+	unsigned p;
+
+	for (p = vfmt->buffers; p < vfmt->planes; p++)
+		size += dev->bytesperline_out[p] * h;
 
 	if (dev->field_out == V4L2_FIELD_ALTERNATE) {
 		/*
@@ -74,21 +79,16 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 		if (mp->num_planes != planes)
 			return -EINVAL;
 		sizes[0] = mp->plane_fmt[0].sizeimage;
-		if (planes == 2) {
-			sizes[1] = mp->plane_fmt[1].sizeimage;
-			if (sizes[0] < dev->bytesperline_out[0] * h ||
-			    sizes[1] < dev->bytesperline_out[1] * h)
-				return -EINVAL;
-		} else if (sizes[0] < size) {
+		if (sizes[0] < size)
 			return -EINVAL;
+		for (p = 1; p < planes; p++) {
+			sizes[p] = mp->plane_fmt[p].sizeimage;
+			if (sizes[p] < dev->bytesperline_out[p] * h)
+				return -EINVAL;
 		}
 	} else {
-		if (planes == 2) {
-			sizes[0] = dev->bytesperline_out[0] * h;
-			sizes[1] = dev->bytesperline_out[1] * h;
-		} else {
-			sizes[0] = size;
-		}
+		for (p = 0; p < planes; p++)
+			sizes[p] = p ? dev->bytesperline_out[p] * h : size;
 	}
 
 	if (vq->num_buffers + *nbuffers < 2)
@@ -101,12 +101,9 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	 * alloc_ctxs array.
 	 */
 
-	if (planes == 2)
-		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
-			*nbuffers, sizes[0], sizes[1]);
-	else
-		dprintk(dev, 1, "%s, count=%d, size=%u\n", __func__,
-			*nbuffers, sizes[0]);
+	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
+	for (p = 0; p < planes; p++)
+		dprintk(dev, 1, "%s: size[%u]=%u\n", __func__, p, sizes[p]);
 	return 0;
 }
 
@@ -114,7 +111,7 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
-	unsigned planes = dev->fmt_out->planes;
+	unsigned planes = dev->fmt_out->buffers;
 	unsigned p;
 
 	dprintk(dev, 1, "%s\n", __func__);
@@ -220,7 +217,7 @@ const struct vb2_ops vivid_vid_out_qops = {
 void vivid_update_format_out(struct vivid_dev *dev)
 {
 	struct v4l2_bt_timings *bt = &dev->dv_timings_out.bt;
-	unsigned size;
+	unsigned size, p;
 
 	switch (dev->output_type[dev->output]) {
 	case SVID:
@@ -267,9 +264,9 @@ void vivid_update_format_out(struct vivid_dev *dev)
 	if (V4L2_FIELD_HAS_T_OR_B(dev->field_out))
 		dev->crop_out.height /= 2;
 	dev->fmt_out_rect = dev->crop_out;
-	dev->bytesperline_out[0] = (dev->sink_rect.width * dev->fmt_out->bit_depth[0]) / 8;
-	if (dev->fmt_out->planes == 2)
-		dev->bytesperline_out[1] = (dev->sink_rect.width * dev->fmt_out->bit_depth[0]) / 8;
+	for (p = 0; p < dev->fmt_out->planes; p++)
+		dev->bytesperline_out[p] =
+			(dev->sink_rect.width * dev->fmt_out->bit_depth[p]) / 8;
 }
 
 /* Map the field to something that is valid for the current output */
@@ -313,21 +310,27 @@ int vivid_g_fmt_vid_out(struct file *file, void *priv,
 {
 	struct vivid_dev *dev = video_drvdata(file);
 	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	const struct vivid_fmt *fmt = dev->fmt_out;
 	unsigned p;
 
 	mp->width        = dev->fmt_out_rect.width;
 	mp->height       = dev->fmt_out_rect.height;
 	mp->field        = dev->field_out;
-	mp->pixelformat  = dev->fmt_out->fourcc;
+	mp->pixelformat  = fmt->fourcc;
 	mp->colorspace   = dev->colorspace_out;
 	mp->ycbcr_enc    = dev->ycbcr_enc_out;
 	mp->quantization = dev->quantization_out;
-	mp->num_planes = dev->fmt_out->planes;
+	mp->num_planes = fmt->buffers;
 	for (p = 0; p < mp->num_planes; p++) {
 		mp->plane_fmt[p].bytesperline = dev->bytesperline_out[p];
 		mp->plane_fmt[p].sizeimage =
 			mp->plane_fmt[p].bytesperline * mp->height;
 	}
+	for (p = fmt->buffers; p < fmt->planes; p++) {
+		unsigned stride = dev->bytesperline_out[p];
+
+		mp->plane_fmt[0].sizeimage += stride * mp->height;
+	}
 	return 0;
 }
 
@@ -389,7 +392,7 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 	bytesperline = (mp->width * fmt->bit_depth[0]) >> 3;
 	/* Calculate the maximum supported bytesperline value */
 	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->bit_depth[0]) >> 3;
-	mp->num_planes = fmt->planes;
+	mp->num_planes = fmt->buffers;
 	for (p = 0; p < mp->num_planes; p++) {
 		if (pfmt[p].bytesperline > max_bpl)
 			pfmt[p].bytesperline = max_bpl;
@@ -398,6 +401,9 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 		pfmt[p].sizeimage = pfmt[p].bytesperline * mp->height;
 		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
 	}
+	for (p = fmt->buffers; p < fmt->planes; p++)
+		pfmt[0].sizeimage += (pfmt[0].bytesperline * fmt->bit_depth[p]) /
+				     fmt->bit_depth[0];
 	mp->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
 	mp->quantization = V4L2_QUANTIZATION_DEFAULT;
 	if (vivid_is_svid_out(dev)) {
@@ -429,6 +435,7 @@ int vivid_s_fmt_vid_out(struct file *file, void *priv,
 	struct vb2_queue *q = &dev->vb_vid_out_q;
 	int ret = vivid_try_fmt_vid_out(file, priv, f);
 	unsigned factor = 1;
+	unsigned p;
 
 	if (ret < 0)
 		return ret;
@@ -524,9 +531,12 @@ int vivid_s_fmt_vid_out(struct file *file, void *priv,
 
 	dev->fmt_out_rect.width = mp->width;
 	dev->fmt_out_rect.height = mp->height;
-	dev->bytesperline_out[0] = mp->plane_fmt[0].bytesperline;
-	if (mp->num_planes > 1)
-		dev->bytesperline_out[1] = mp->plane_fmt[1].bytesperline;
+	for (p = 0; p < mp->num_planes; p++)
+		dev->bytesperline_out[p] = mp->plane_fmt[p].bytesperline;
+	for (p = dev->fmt_out->buffers; p < dev->fmt_out->planes; p++)
+		dev->bytesperline_out[p] =
+			(dev->bytesperline_out[0] * dev->fmt_out->bit_depth[p]) /
+			dev->fmt_out->bit_depth[0];
 	dev->field_out = mp->field;
 	if (vivid_is_svid_out(dev))
 		dev->tv_field_out = mp->field;
-- 
2.1.4

