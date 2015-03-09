Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38080 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbbCIP4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:56:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 28/29] vivid: add downsampling support
Date: Mon,  9 Mar 2015 16:44:50 +0100
Message-Id: <1425915891-1017-29-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support in vivid for downsampling. Most of the changes are in
vivid_copy_buffer which needs to know about the right line widths.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c | 68 ++++++++++++++----------
 drivers/media/platform/vivid/vivid-vid-out.c     |  7 +--
 2 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 22e1784..1727f54 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -249,8 +249,9 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 	bool blank = dev->must_blank[vid_cap_buf->vb.v4l2_buf.index];
 	struct tpg_data *tpg = &dev->tpg;
 	struct vivid_buffer *vid_out_buf = NULL;
-	unsigned pixsize = tpg_g_twopixelsize(tpg, p) / 2;
-	unsigned img_width = dev->compose_cap.width;
+	unsigned vdiv = dev->fmt_out->vdownsampling[p];
+	unsigned twopixsize = tpg_g_twopixelsize(tpg, p);
+	unsigned img_width = tpg_hdiv(tpg, p, dev->compose_cap.width);
 	unsigned img_height = dev->compose_cap.height;
 	unsigned stride_cap = tpg->bytesperline[p];
 	unsigned stride_out = dev->bytesperline_out[p];
@@ -269,6 +270,7 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 	unsigned vid_overlay_fract_part = 0;
 	unsigned vid_overlay_y = 0;
 	unsigned vid_overlay_error = 0;
+	unsigned vid_cap_left = tpg_hdiv(tpg, p, dev->loop_vid_cap.left);
 	unsigned vid_cap_right;
 	bool quick;
 
@@ -287,23 +289,25 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 			      dev->bytesperline_out, dev->fmt_out_rect.height);
 	if (p < dev->fmt_out->buffers)
 		voutbuf += vid_out_buf->vb.v4l2_planes[p].data_offset;
-	voutbuf += dev->loop_vid_out.left * pixsize + dev->loop_vid_out.top * stride_out;
-	vcapbuf += dev->compose_cap.left * pixsize + dev->compose_cap.top * stride_cap;
+	voutbuf += tpg_hdiv(tpg, p, dev->loop_vid_out.left) +
+		(dev->loop_vid_out.top / vdiv) * stride_out;
+	vcapbuf += tpg_hdiv(tpg, p, dev->compose_cap.left) +
+		(dev->compose_cap.top / vdiv) * stride_cap;
 
 	if (dev->loop_vid_copy.width == 0 || dev->loop_vid_copy.height == 0) {
 		/*
 		 * If there is nothing to copy, then just fill the capture window
 		 * with black.
 		 */
-		for (y = 0; y < hmax; y++, vcapbuf += stride_cap)
-			memcpy(vcapbuf, tpg->black_line[p], img_width * pixsize);
+		for (y = 0; y < hmax / vdiv; y++, vcapbuf += stride_cap)
+			memcpy(vcapbuf, tpg->black_line[p], img_width);
 		return 0;
 	}
 
 	if (dev->overlay_out_enabled &&
 	    dev->loop_vid_overlay.width && dev->loop_vid_overlay.height) {
 		vosdbuf = dev->video_vbase;
-		vosdbuf += dev->loop_fb_copy.left * pixsize +
+		vosdbuf += (dev->loop_fb_copy.left * twopixsize) / 2 +
 			   dev->loop_fb_copy.top * stride_osd;
 		vid_overlay_int_part = dev->loop_vid_overlay.height /
 				       dev->loop_vid_overlay_cap.height;
@@ -311,12 +315,12 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 					 dev->loop_vid_overlay_cap.height;
 	}
 
-	vid_cap_right = dev->loop_vid_cap.left + dev->loop_vid_cap.width;
+	vid_cap_right = tpg_hdiv(tpg, p, dev->loop_vid_cap.left + dev->loop_vid_cap.width);
 	/* quick is true if no video scaling is needed */
 	quick = dev->loop_vid_out.width == dev->loop_vid_cap.width;
 
 	dev->cur_scaled_line = dev->loop_vid_out.height;
-	for (y = 0; y < hmax; y++, vcapbuf += stride_cap) {
+	for (y = 0; y < hmax; y += vdiv, vcapbuf += stride_cap) {
 		/* osdline is true if this line requires overlay blending */
 		bool osdline = vosdbuf && y >= dev->loop_vid_overlay_cap.top &&
 			  y < dev->loop_vid_overlay_cap.top + dev->loop_vid_overlay_cap.height;
@@ -327,34 +331,34 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 		 */
 		if (y < dev->loop_vid_cap.top ||
 		    y >= dev->loop_vid_cap.top + dev->loop_vid_cap.height) {
-			memcpy(vcapbuf, tpg->black_line[p], img_width * pixsize);
+			memcpy(vcapbuf, tpg->black_line[p], img_width);
 			continue;
 		}
 
 		/* fill the left border with black */
 		if (dev->loop_vid_cap.left)
-			memcpy(vcapbuf, tpg->black_line[p], dev->loop_vid_cap.left * pixsize);
+			memcpy(vcapbuf, tpg->black_line[p], vid_cap_left);
 
 		/* fill the right border with black */
 		if (vid_cap_right < img_width)
-			memcpy(vcapbuf + vid_cap_right * pixsize,
-				tpg->black_line[p], (img_width - vid_cap_right) * pixsize);
+			memcpy(vcapbuf + vid_cap_right, tpg->black_line[p],
+				img_width - vid_cap_right);
 
 		if (quick && !osdline) {
-			memcpy(vcapbuf + dev->loop_vid_cap.left * pixsize,
+			memcpy(vcapbuf + vid_cap_left,
 			       voutbuf + vid_out_y * stride_out,
-			       dev->loop_vid_cap.width * pixsize);
+			       tpg_hdiv(tpg, p, dev->loop_vid_cap.width));
 			goto update_vid_out_y;
 		}
 		if (dev->cur_scaled_line == vid_out_y) {
-			memcpy(vcapbuf + dev->loop_vid_cap.left * pixsize,
-			       dev->scaled_line,
-			       dev->loop_vid_cap.width * pixsize);
+			memcpy(vcapbuf + vid_cap_left, dev->scaled_line,
+			       tpg_hdiv(tpg, p, dev->loop_vid_cap.width));
 			goto update_vid_out_y;
 		}
 		if (!osdline) {
 			scale_line(voutbuf + vid_out_y * stride_out, dev->scaled_line,
-				dev->loop_vid_out.width, dev->loop_vid_cap.width,
+				tpg_hdiv(tpg, p, dev->loop_vid_out.width),
+				tpg_hdiv(tpg, p, dev->loop_vid_cap.width),
 				tpg_g_twopixelsize(tpg, p));
 		} else {
 			/*
@@ -362,7 +366,8 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 			 * loop_vid_overlay rectangle.
 			 */
 			unsigned offset =
-				(dev->loop_vid_overlay.left - dev->loop_vid_copy.left) * pixsize;
+				((dev->loop_vid_overlay.left - dev->loop_vid_copy.left) *
+				 twopixsize) / 2;
 			u8 *osd = vosdbuf + vid_overlay_y * stride_osd;
 
 			scale_line(voutbuf + vid_out_y * stride_out, dev->blended_line,
@@ -372,18 +377,17 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 				blend_line(dev, vid_overlay_y + dev->loop_vid_overlay.top,
 					   dev->loop_vid_overlay.left,
 					   dev->blended_line + offset, osd,
-					   dev->loop_vid_overlay.width, pixsize);
+					   dev->loop_vid_overlay.width, twopixsize / 2);
 			else
 				memcpy(dev->blended_line + offset,
-				       osd, dev->loop_vid_overlay.width * pixsize);
+				       osd, (dev->loop_vid_overlay.width * twopixsize) / 2);
 			scale_line(dev->blended_line, dev->scaled_line,
 					dev->loop_vid_copy.width, dev->loop_vid_cap.width,
 					tpg_g_twopixelsize(tpg, p));
 		}
 		dev->cur_scaled_line = vid_out_y;
-		memcpy(vcapbuf + dev->loop_vid_cap.left * pixsize,
-		       dev->scaled_line,
-		       dev->loop_vid_cap.width * pixsize);
+		memcpy(vcapbuf + vid_cap_left, dev->scaled_line,
+		       tpg_hdiv(tpg, p, dev->loop_vid_cap.width));
 
 update_vid_out_y:
 		if (osdline) {
@@ -396,16 +400,16 @@ update_vid_out_y:
 		}
 		vid_out_y += vid_out_int_part;
 		vid_out_error += vid_out_fract_part;
-		if (vid_out_error >= dev->loop_vid_cap.height) {
-			vid_out_error -= dev->loop_vid_cap.height;
+		if (vid_out_error >= dev->loop_vid_cap.height / vdiv) {
+			vid_out_error -= dev->loop_vid_cap.height / vdiv;
 			vid_out_y++;
 		}
 	}
 
 	if (!blank)
 		return 0;
-	for (; y < img_height; y++, vcapbuf += stride_cap)
-		memcpy(vcapbuf, tpg->contrast_line[p], img_width * pixsize);
+	for (; y < img_height; y += vdiv, vcapbuf += stride_cap)
+		memcpy(vcapbuf, tpg->contrast_line[p], img_width);
 	return 0;
 }
 
@@ -604,6 +608,12 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 	bool quick = dev->bitmap_cap == NULL && dev->clipcount_cap == 0;
 	int x, y, w, out_x = 0;
 
+	/*
+	 * Overlay support is only supported for formats that have a twopixelsize
+	 * that's >= 2. Warn and bail out if that's not the case.
+	 */
+	if (WARN_ON(pixsize == 0))
+		return;
 	if ((dev->overlay_cap_field == V4L2_FIELD_TOP ||
 	     dev->overlay_cap_field == V4L2_FIELD_BOTTOM) &&
 	    dev->overlay_cap_field != buf->vb.v4l2_buf.field)
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 69fd382..917cc69 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -43,7 +43,7 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	unsigned p;
 
 	for (p = vfmt->buffers; p < vfmt->planes; p++)
-		size += dev->bytesperline_out[p] * h;
+		size += dev->bytesperline_out[p] * h / vfmt->vdownsampling[p];
 
 	if (dev->field_out == V4L2_FIELD_ALTERNATE) {
 		/*
@@ -329,7 +329,8 @@ int vivid_g_fmt_vid_out(struct file *file, void *priv,
 	for (p = fmt->buffers; p < fmt->planes; p++) {
 		unsigned stride = dev->bytesperline_out[p];
 
-		mp->plane_fmt[0].sizeimage += stride * mp->height;
+		mp->plane_fmt[0].sizeimage +=
+			(stride * mp->height) / fmt->vdownsampling[p];
 	}
 	return 0;
 }
@@ -403,7 +404,7 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 	}
 	for (p = fmt->buffers; p < fmt->planes; p++)
 		pfmt[0].sizeimage += (pfmt[0].bytesperline * fmt->bit_depth[p]) /
-				     fmt->bit_depth[0];
+				     (fmt->bit_depth[0] * fmt->vdownsampling[p]);
 	mp->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
 	mp->quantization = V4L2_QUANTIZATION_DEFAULT;
 	if (vivid_is_svid_out(dev)) {
-- 
2.1.4

