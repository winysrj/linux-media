Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39371 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbbC3Hxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 03:53:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: awalls@md.metrocast.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] ivtv: disable fbuf support if ivtvfb isn't loaded
Date: Mon, 30 Mar 2015 09:53:11 +0200
Message-Id: <1427701991-19875-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1427701991-19875-1-git-send-email-hverkuil@xs4all.nl>
References: <1427701991-19875-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Disable all fbuf-related functionality if ivtvfb isn't loaded. This
caused various v4l2-compliance failures.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c   | 36 +++++++++++++++++++++++++----------
 drivers/media/pci/ivtv/ivtv-streams.c |  6 ++++--
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 5a707ad..e893b77 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -448,9 +448,12 @@ static int ivtv_g_fmt_vid_out(struct file *file, void *fh, struct v4l2_format *f
 static int ivtv_g_fmt_vid_out_overlay(struct file *file, void *fh, struct v4l2_format *fmt)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
+	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 	struct v4l2_window *winfmt = &fmt->fmt.win;
 
-	if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
+	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+		return -EINVAL;
+	if (!itv->osd_video_pbase)
 		return -EINVAL;
 	winfmt->chromakey = itv->osd_chroma_key;
 	winfmt->global_alpha = itv->osd_global_alpha;
@@ -555,10 +558,13 @@ static int ivtv_try_fmt_vid_out(struct file *file, void *fh, struct v4l2_format
 static int ivtv_try_fmt_vid_out_overlay(struct file *file, void *fh, struct v4l2_format *fmt)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
+	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 	u32 chromakey = fmt->fmt.win.chromakey;
 	u8 global_alpha = fmt->fmt.win.global_alpha;
 
-	if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
+	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+		return -EINVAL;
+	if (!itv->osd_video_pbase)
 		return -EINVAL;
 	ivtv_g_fmt_vid_out_overlay(file, fh, fmt);
 	fmt->fmt.win.chromakey = chromakey;
@@ -741,6 +747,11 @@ static int ivtv_querycap(struct file *file, void *fh, struct v4l2_capability *vc
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info), "PCI:%s", pci_name(itv->pdev));
 	vcap->capabilities = itv->v4l2_cap | V4L2_CAP_DEVICE_CAPS;
 	vcap->device_caps = s->caps;
+	if ((s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY) &&
+	    !itv->osd_video_pbase) {
+		vcap->capabilities &= ~V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+		vcap->device_caps &= ~V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+	}
 	return 0;
 }
 
@@ -1350,6 +1361,7 @@ static int ivtv_try_encoder_cmd(struct file *file, void *fh, struct v4l2_encoder
 static int ivtv_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
+	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 	u32 data[CX2341X_MBOX_MAX_DATA];
 	struct yuv_playback_info *yi = &itv->yuv_info;
 
@@ -1373,10 +1385,10 @@ static int ivtv_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
 		0,
 	};
 
-	if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
-		return -EINVAL;
+	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+		return -ENOTTY;
 	if (!itv->osd_video_pbase)
-		return -EINVAL;
+		return -ENOTTY;
 
 	fb->capability = V4L2_FBUF_CAP_EXTERNOVERLAY | V4L2_FBUF_CAP_CHROMAKEY |
 		V4L2_FBUF_CAP_GLOBAL_ALPHA;
@@ -1437,12 +1449,13 @@ static int ivtv_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffe
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
+	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 	struct yuv_playback_info *yi = &itv->yuv_info;
 
-	if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
-		return -EINVAL;
+	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+		return -ENOTTY;
 	if (!itv->osd_video_pbase)
-		return -EINVAL;
+		return -ENOTTY;
 
 	itv->osd_global_alpha_state = (fb->flags & V4L2_FBUF_FLAG_GLOBAL_ALPHA) != 0;
 	itv->osd_local_alpha_state =
@@ -1457,9 +1470,12 @@ static int ivtv_overlay(struct file *file, void *fh, unsigned int on)
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
+	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 
-	if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
-		return -EINVAL;
+	if (!(s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY))
+		return -ENOTTY;
+	if (!itv->osd_video_pbase)
+		return -ENOTTY;
 
 	ivtv_vapi(itv, CX2341X_OSD_SET_STATE, 1, on != 0);
 
diff --git a/drivers/media/pci/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
index cfb61f2..d27c6df 100644
--- a/drivers/media/pci/ivtv/ivtv-streams.c
+++ b/drivers/media/pci/ivtv/ivtv-streams.c
@@ -130,7 +130,8 @@ static struct {
 		"decoder MPG",
 		VFL_TYPE_GRABBER, IVTV_V4L2_DEC_MPG_OFFSET,
 		PCI_DMA_TODEVICE, 0,
-		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
+		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
+		V4L2_CAP_VIDEO_OUTPUT_OVERLAY,
 		&ivtv_v4l2_dec_fops
 	},
 	{	/* IVTV_DEC_STREAM_TYPE_VBI */
@@ -151,7 +152,8 @@ static struct {
 		"decoder YUV",
 		VFL_TYPE_GRABBER, IVTV_V4L2_DEC_YUV_OFFSET,
 		PCI_DMA_TODEVICE, 0,
-		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
+		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
+		V4L2_CAP_VIDEO_OUTPUT_OVERLAY,
 		&ivtv_v4l2_dec_fops
 	}
 };
-- 
2.1.4

