Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4655 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab2EKHzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 07/16] saa7146: move overlay information from saa7146_fh into saa7146_vv
Date: Fri, 11 May 2012 09:55:01 +0200
Message-Id: <544273cc7db08c175a581ec0f6b116a00499131f.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is global information, not per-filehandle information.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c  |   10 +++++++++
 drivers/media/common/saa7146_hlp.c   |   23 +++++++++++----------
 drivers/media/common/saa7146_video.c |   37 ++++++++++++++++++----------------
 include/media/saa7146_vv.h           |    5 +----
 4 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 734ea6c..05818ec 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -436,6 +436,7 @@ static const struct v4l2_ctrl_ops saa7146_ctrl_ops = {
 int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 {
 	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+	struct v4l2_pix_format *fmt;
 	struct saa7146_vv *vv;
 	int err;
 
@@ -496,6 +497,15 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
 		saa7146_vbi_uops.init(dev,vv);
 
+	fmt = &vv->ov_fb.fmt;
+	fmt->width = vv->standard->h_max_out;
+	fmt->height = vv->standard->v_max_out;
+	fmt->pixelformat = V4L2_PIX_FMT_RGB565;
+	fmt->bytesperline = 2 * fmt->width;
+	fmt->sizeimage = fmt->bytesperline * fmt->height;
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	vv->ov_fb.capability = V4L2_FBUF_CAP_LIST_CLIPPING;
+	vv->ov_fb.flags = V4L2_FBUF_FLAG_PRIMARY;
 	dev->vv_data = vv;
 	dev->vv_callback = &vv_callback;
 
diff --git a/drivers/media/common/saa7146_hlp.c b/drivers/media/common/saa7146_hlp.c
index bc1f545..be746d1 100644
--- a/drivers/media/common/saa7146_hlp.c
+++ b/drivers/media/common/saa7146_hlp.c
@@ -343,9 +343,9 @@ static void calculate_clipping_registers_rect(struct saa7146_dev *dev, struct sa
 	struct saa7146_vv *vv = dev->vv_data;
 	__le32 *clipping = vv->d_clipping.cpu_addr;
 
-	int width = fh->ov.win.w.width;
-	int height =  fh->ov.win.w.height;
-	int clipcount = fh->ov.nclips;
+	int width = vv->ov.win.w.width;
+	int height =  vv->ov.win.w.height;
+	int clipcount = vv->ov.nclips;
 
 	u32 line_list[32];
 	u32 pixel_list[32];
@@ -365,10 +365,10 @@ static void calculate_clipping_registers_rect(struct saa7146_dev *dev, struct sa
 	for(i = 0; i < clipcount; i++) {
 		int l = 0, r = 0, t = 0, b = 0;
 
-		x[i] = fh->ov.clips[i].c.left;
-		y[i] = fh->ov.clips[i].c.top;
-		w[i] = fh->ov.clips[i].c.width;
-		h[i] = fh->ov.clips[i].c.height;
+		x[i] = vv->ov.clips[i].c.left;
+		y[i] = vv->ov.clips[i].c.top;
+		w[i] = vv->ov.clips[i].c.width;
+		h[i] = vv->ov.clips[i].c.height;
 
 		if( w[i] < 0) {
 			x[i] += w[i]; w[i] = -w[i];
@@ -485,13 +485,14 @@ static void saa7146_disable_clipping(struct saa7146_dev *dev)
 static void saa7146_set_clipping_rect(struct saa7146_fh *fh)
 {
 	struct saa7146_dev *dev = fh->dev;
-	enum v4l2_field field = fh->ov.win.field;
+	struct saa7146_vv *vv = dev->vv_data;
+	enum v4l2_field field = vv->ov.win.field;
 	struct	saa7146_video_dma vdma2;
 	u32 clip_format;
 	u32 arbtr_ctrl;
 
 	/* check clipcount, disable clipping if clipcount == 0*/
-	if( fh->ov.nclips == 0 ) {
+	if (vv->ov.nclips == 0) {
 		saa7146_disable_clipping(dev);
 		return;
 	}
@@ -651,8 +652,8 @@ int saa7146_enable_overlay(struct saa7146_fh *fh)
 	struct saa7146_dev *dev = fh->dev;
 	struct saa7146_vv *vv = dev->vv_data;
 
-	saa7146_set_window(dev, fh->ov.win.w.width, fh->ov.win.w.height, fh->ov.win.field);
-	saa7146_set_position(dev, fh->ov.win.w.left, fh->ov.win.w.top, fh->ov.win.w.height, fh->ov.win.field, vv->ov_fmt->pixelformat);
+	saa7146_set_window(dev, vv->ov.win.w.width, vv->ov.win.w.height, vv->ov.win.field);
+	saa7146_set_position(dev, vv->ov.win.w.left, vv->ov.win.w.top, vv->ov.win.w.height, vv->ov.win.field, vv->ov_fmt->pixelformat);
 	saa7146_set_output_format(dev, vv->ov_fmt->trans);
 	saa7146_set_clipping_rect(fh);
 
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 8818e66..e1b639b 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -112,8 +112,8 @@ int saa7146_start_preview(struct saa7146_fh *fh)
 
 	DEB_EE("dev:%p, fh:%p\n", dev, fh);
 
-	/* check if we have overlay informations */
-	if( NULL == fh->ov.fh ) {
+	/* check if we have overlay information */
+	if (vv->ov.fh == NULL) {
 		DEB_D("no overlay data available. try S_FMT first.\n");
 		return -EAGAIN;
 	}
@@ -139,19 +139,18 @@ int saa7146_start_preview(struct saa7146_fh *fh)
 		return -EBUSY;
 	}
 
-	fmt.fmt.win = fh->ov.win;
+	fmt.fmt.win = vv->ov.win;
 	err = vidioc_try_fmt_vid_overlay(NULL, fh, &fmt);
 	if (0 != err) {
 		saa7146_res_free(vv->video_fh, RESOURCE_DMA1_HPS|RESOURCE_DMA2_CLP);
 		return -EBUSY;
 	}
-	fh->ov.win = fmt.fmt.win;
-	vv->ov_data = &fh->ov;
+	vv->ov.win = fmt.fmt.win;
 
 	DEB_D("%dx%d+%d+%d %s field=%s\n",
-	      fh->ov.win.w.width, fh->ov.win.w.height,
-	      fh->ov.win.w.left, fh->ov.win.w.top,
-	      vv->ov_fmt->name, v4l2_field_names[fh->ov.win.field]);
+	      vv->ov.win.w.width, vv->ov.win.w.height,
+	      vv->ov.win.w.left, vv->ov.win.w.top,
+	      vv->ov_fmt->name, v4l2_field_names[vv->ov.win.field]);
 
 	if (0 != (ret = saa7146_enable_overlay(fh))) {
 		DEB_D("enabling overlay failed: %d\n", ret);
@@ -468,6 +467,7 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *f
 
 	*fb = vv->ov_fb;
 	fb->capability = V4L2_FBUF_CAP_LIST_CLIPPING;
+	fb->flags = V4L2_FBUF_FLAG_PRIMARY;
 	return 0;
 }
 
@@ -601,7 +601,10 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format
 
 static int vidioc_g_fmt_vid_overlay(struct file *file, void *fh, struct v4l2_format *f)
 {
-	f->fmt.win = ((struct saa7146_fh *)fh)->ov.win;
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct saa7146_vv *vv = dev->vv_data;
+
+	f->fmt.win = vv->ov.win;
 	return 0;
 }
 
@@ -768,17 +771,17 @@ static int vidioc_s_fmt_vid_overlay(struct file *file, void *__fh, struct v4l2_f
 	err = vidioc_try_fmt_vid_overlay(file, fh, f);
 	if (0 != err)
 		return err;
-	fh->ov.win    = f->fmt.win;
-	fh->ov.nclips = f->fmt.win.clipcount;
-	if (fh->ov.nclips > 16)
-		fh->ov.nclips = 16;
-	if (copy_from_user(fh->ov.clips, f->fmt.win.clips,
-				sizeof(struct v4l2_clip) * fh->ov.nclips)) {
+	vv->ov.win    = f->fmt.win;
+	vv->ov.nclips = f->fmt.win.clipcount;
+	if (vv->ov.nclips > 16)
+		vv->ov.nclips = 16;
+	if (copy_from_user(vv->ov.clips, f->fmt.win.clips,
+				sizeof(struct v4l2_clip) * vv->ov.nclips)) {
 		return -EFAULT;
 	}
 
-	/* fh->ov.fh is used to indicate that we have valid overlay informations, too */
-	fh->ov.fh = fh;
+	/* vv->ov.fh is used to indicate that we have valid overlay informations, too */
+	vv->ov.fh = fh;
 
 	/* check if our current overlay is active */
 	if (IS_OVERLAY_ACTIVE(fh) != 0) {
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index b4761ed..feb444b 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -88,9 +88,6 @@ struct saa7146_fh {
 	/* if this is a vbi or capture open */
 	enum v4l2_buf_type	type;
 
-	/* video overlay */
-	struct saa7146_overlay	ov;
-
 	/* video capture */
 	struct videobuf_queue	video_q;
 	struct v4l2_pix_format	video_fmt;
@@ -119,9 +116,9 @@ struct saa7146_vv
 	struct saa7146_fh		*video_fh;
 
 	/* video overlay */
+	struct saa7146_overlay		ov;
 	struct v4l2_framebuffer		ov_fb;
 	struct saa7146_format		*ov_fmt;
-	struct saa7146_overlay		*ov_data;
 	struct saa7146_fh		*ov_suspend;
 
 	/* video capture */
-- 
1.7.10

