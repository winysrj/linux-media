Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36632 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbbC3Q6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 12:58:24 -0400
Received: from [192.168.1.106] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 08F212A0099
	for <linux-media@vger.kernel.org>; Mon, 30 Mar 2015 18:57:56 +0200 (CEST)
Message-ID: <551980A9.4050604@xs4all.nl>
Date: Mon, 30 Mar 2015 18:58:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCHv2] ivtv: replace crop by selection
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the old g/s_crop ioctls by the new g/s_selection ioctls.
This solves a v4l2-compliance failure, and it is something that needs
to be done anyway to eventually be able to remove the old g/s_crop
ioctl ops.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---

Changes since v1:

- add support for CROP_DEFAULTS and CROP_BOUNDS since CROPCAP is supported for
  capture.

---

 drivers/media/pci/ivtv/ivtv-ioctl.c | 115 +++++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 46 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index fa87565..683beb4 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -816,80 +816,103 @@ static int ivtv_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropca
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
-	struct yuv_playback_info *yi = &itv->yuv_info;
-	int streamtype;
-
-	streamtype = id->type;
 
-	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		return -EINVAL;
-	cropcap->bounds.top = cropcap->bounds.left = 0;
-	cropcap->bounds.width = 720;
 	if (cropcap->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		cropcap->bounds.height = itv->is_50hz ? 576 : 480;
 		cropcap->pixelaspect.numerator = itv->is_50hz ? 59 : 10;
 		cropcap->pixelaspect.denominator = itv->is_50hz ? 54 : 11;
-	} else if (streamtype == IVTV_DEC_STREAM_TYPE_YUV) {
-		if (yi->track_osd) {
-			cropcap->bounds.width = yi->osd_full_w;
-			cropcap->bounds.height = yi->osd_full_h;
-		} else {
-			cropcap->bounds.width = 720;
-			cropcap->bounds.height =
-					itv->is_out_50hz ? 576 : 480;
-		}
+	} else if (cropcap->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		cropcap->pixelaspect.numerator = itv->is_out_50hz ? 59 : 10;
 		cropcap->pixelaspect.denominator = itv->is_out_50hz ? 54 : 11;
 	} else {
-		cropcap->bounds.height = itv->is_out_50hz ? 576 : 480;
-		cropcap->pixelaspect.numerator = itv->is_out_50hz ? 59 : 10;
-		cropcap->pixelaspect.denominator = itv->is_out_50hz ? 54 : 11;
+		return -EINVAL;
 	}
-	cropcap->defrect = cropcap->bounds;
 	return 0;
 }
 
-static int ivtv_s_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
+static int ivtv_s_selection(struct file *file, void *fh,
+			    struct v4l2_selection *sel)
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
 	struct yuv_playback_info *yi = &itv->yuv_info;
-	int streamtype;
+	struct v4l2_rect r = { 0, 0, 720, 0 };
+	int streamtype = id->type;
 
-	streamtype = id->type;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    !(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
+		return -EINVAL;
 
-	if (crop->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
-		if (streamtype == IVTV_DEC_STREAM_TYPE_YUV) {
-			yi->main_rect = crop->c;
-			return 0;
-		} else {
-			if (!ivtv_vapi(itv, CX2341X_OSD_SET_FRAMEBUFFER_WINDOW, 4,
-				crop->c.width, crop->c.height, crop->c.left, crop->c.top)) {
-				itv->main_rect = crop->c;
-				return 0;
-			}
-		}
+	if (sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
+
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    !(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
+		return -EINVAL;
+
+	r.height = itv->is_out_50hz ? 576 : 480;
+	if (streamtype == IVTV_DEC_STREAM_TYPE_YUV && yi->track_osd) {
+		r.width = yi->osd_full_w;
+		r.height = yi->osd_full_h;
+	}
+	sel->r.width = clamp(sel->r.width, 16U, r.width);
+	sel->r.height = clamp(sel->r.height, 16U, r.height);
+	sel->r.left = clamp_t(unsigned, sel->r.left, 0, r.width - sel->r.width);
+	sel->r.top = clamp_t(unsigned, sel->r.top, 0, r.height - sel->r.height);
+
+	if (streamtype == IVTV_DEC_STREAM_TYPE_YUV) {
+		yi->main_rect = sel->r;
+		return 0;
+	}
+	if (!ivtv_vapi(itv, CX2341X_OSD_SET_FRAMEBUFFER_WINDOW, 4,
+			sel->r.width, sel->r.height, sel->r.left, sel->r.top)) {
+		itv->main_rect = sel->r;
+		return 0;
 	}
 	return -EINVAL;
 }
 
-static int ivtv_g_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+static int ivtv_g_selection(struct file *file, void *fh,
+			    struct v4l2_selection *sel)
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
 	struct yuv_playback_info *yi = &itv->yuv_info;
-	int streamtype;
+	struct v4l2_rect r = { 0, 0, 720, 0 };
+	int streamtype = id->type;
+
+	if (sel->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		switch (sel->target) {
+		case V4L2_SEL_TGT_CROP_DEFAULT:
+		case V4L2_SEL_TGT_CROP_BOUNDS:
+			sel->r.top = sel->r.left = 0;
+			sel->r.width = 720;
+			sel->r.height = itv->is_50hz ? 576 : 480;
+			return 0;
+		default:
+			return -EINVAL;
+		}
+	}
 
-	streamtype = id->type;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    !(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
+		return -EINVAL;
 
-	if (crop->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE:
 		if (streamtype == IVTV_DEC_STREAM_TYPE_YUV)
-			crop->c = yi->main_rect;
+			sel->r = yi->main_rect;
 		else
-			crop->c = itv->main_rect;
+			sel->r = itv->main_rect;
+		return 0;
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		r.height = itv->is_out_50hz ? 576 : 480;
+		if (streamtype == IVTV_DEC_STREAM_TYPE_YUV && yi->track_osd) {
+			r.width = yi->osd_full_w;
+			r.height = yi->osd_full_h;
+		}
+		sel->r = r;
 		return 0;
 	}
 	return -EINVAL;
@@ -1837,8 +1860,8 @@ static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_enum_output   		    = ivtv_enum_output,
 	.vidioc_enumaudout   		    = ivtv_enumaudout,
 	.vidioc_cropcap       		    = ivtv_cropcap,
-	.vidioc_s_crop       		    = ivtv_s_crop,
-	.vidioc_g_crop       		    = ivtv_g_crop,
+	.vidioc_s_selection		    = ivtv_s_selection,
+	.vidioc_g_selection		    = ivtv_g_selection,
 	.vidioc_g_input      		    = ivtv_g_input,
 	.vidioc_s_input      		    = ivtv_s_input,
 	.vidioc_g_output     		    = ivtv_g_output,
-- 
2.1.4

