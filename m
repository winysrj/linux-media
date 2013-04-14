Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2652 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3DNP1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 10/30] cx25821: make lots of externals static.
Date: Sun, 14 Apr 2013 17:27:06 +0200
Message-Id: <1365953246-8972-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A lot of functions and variables were external when they really can be
declared as static.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |  313 ++++++++++++++---------------
 drivers/media/pci/cx25821/cx25821-video.h |   74 -------
 drivers/media/pci/cx25821/cx25821.h       |    9 +-
 3 files changed, 153 insertions(+), 243 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 9ddc7ac..9e948ef 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -46,15 +46,13 @@ static unsigned int irq_debug;
 module_param(irq_debug, int, 0644);
 MODULE_PARM_DESC(irq_debug, "enable debug messages [IRQ handler]");
 
-unsigned int vid_limit = 16;
+static unsigned int vid_limit = 16;
 module_param(vid_limit, int, 0644);
 MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 
-static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num);
-
 #define FORMAT_FLAGS_PACKED       0x01
 
-struct cx25821_fmt formats[] = {
+static const struct cx25821_fmt formats[] = {
 	{
 		.name = "8 bpp, gray",
 		.fourcc = V4L2_PIX_FMT_GREY,
@@ -83,12 +81,7 @@ struct cx25821_fmt formats[] = {
 	},
 };
 
-int cx25821_get_format_size(void)
-{
-	return ARRAY_SIZE(formats);
-}
-
-struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
+static const struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -138,7 +131,7 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 		pr_err("%s: %d buffers handled (should be 1)\n", __func__, bc);
 }
 
-int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
+static int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 {
 	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
 		__func__, (unsigned int)norm, v4l2_norm_to_name(norm));
@@ -151,7 +144,7 @@ int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 	return 0;
 }
 
-struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
+static struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
 				       struct pci_dev *pci,
 				       const struct video_device *template,
 				       char *type)
@@ -237,7 +230,7 @@ void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
 	mutex_unlock(&dev->lock);
 }
 
-int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input)
+static int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input)
 {
 	struct v4l2_routing route;
 	memset(&route, 0, sizeof(route));
@@ -403,7 +396,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	return handled;
 }
 
-int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
+static int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		 unsigned int *size)
 {
 	struct cx25821_fh *fh = q->priv_data;
@@ -419,7 +412,7 @@ int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	return 0;
 }
 
-int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
+static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		   enum v4l2_field field)
 {
 	struct cx25821_fh *fh = q->priv_data;
@@ -546,7 +539,7 @@ fail:
 	return rc;
 }
 
-void cx25821_buffer_release(struct videobuf_queue *q,
+static void cx25821_buffer_release(struct videobuf_queue *q,
 			    struct videobuf_buffer *vb)
 {
 	struct cx25821_buffer *buf =
@@ -555,7 +548,7 @@ void cx25821_buffer_release(struct videobuf_queue *q,
 	cx25821_free_buffer(q, buf);
 }
 
-struct videobuf_queue *get_queue(struct cx25821_fh *fh)
+static struct videobuf_queue *get_queue(struct cx25821_fh *fh)
 {
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
@@ -566,7 +559,7 @@ struct videobuf_queue *get_queue(struct cx25821_fh *fh)
 	}
 }
 
-int cx25821_get_resource(struct cx25821_fh *fh, int resource)
+static int cx25821_get_resource(struct cx25821_fh *fh, int resource)
 {
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
@@ -577,7 +570,7 @@ int cx25821_get_resource(struct cx25821_fh *fh, int resource)
 	}
 }
 
-int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
+static int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct cx25821_fh *fh = file->private_data;
 
@@ -795,6 +788,70 @@ static int video_release(struct file *file)
 	return 0;
 }
 
+/* VIDEO IOCTLS */
+static int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				 struct v4l2_format *f)
+{
+	struct cx25821_fh *fh = priv;
+
+	f->fmt.pix.width = fh->width;
+	f->fmt.pix.height = fh->height;
+	f->fmt.pix.field = fh->vidq.field;
+	f->fmt.pix.pixelformat = fh->fmt->fourcc;
+	f->fmt.pix.bytesperline = (f->fmt.pix.width * fh->fmt->depth) >> 3;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return 0;
+}
+
+static int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_format *f)
+{
+	const struct cx25821_fmt *fmt;
+	enum v4l2_field field;
+	unsigned int maxw, maxh;
+
+	fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
+	if (NULL == fmt)
+		return -EINVAL;
+
+	field = f->fmt.pix.field;
+	maxw = 720;
+	maxh = 576;
+
+	if (V4L2_FIELD_ANY == field) {
+		if (f->fmt.pix.height > maxh / 2)
+			field = V4L2_FIELD_INTERLACED;
+		else
+			field = V4L2_FIELD_TOP;
+	}
+
+	switch (field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+		maxh = maxh / 2;
+		break;
+	case V4L2_FIELD_INTERLACED:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	f->fmt.pix.field = field;
+	if (f->fmt.pix.height < 32)
+		f->fmt.pix.height = 32;
+	if (f->fmt.pix.height > maxh)
+		f->fmt.pix.height = maxh;
+	if (f->fmt.pix.width < 48)
+		f->fmt.pix.width = 48;
+	if (f->fmt.pix.width > maxw)
+		f->fmt.pix.width = maxw;
+	f->fmt.pix.width &= ~0x03;
+	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return 0;
+}
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct cx25821_fh *fh = priv;
@@ -832,6 +889,43 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return 0;
 }
 
+static int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm)
+{
+	if (tvnorm == V4L2_STD_PAL_BG) {
+		if (width == 352 || width == 720)
+			return 1;
+		else
+			return 0;
+	}
+
+	if (tvnorm == V4L2_STD_NTSC_M) {
+		if (width == 320 || width == 352 || width == 720)
+			return 1;
+		else
+			return 0;
+	}
+	return 0;
+}
+
+static int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm)
+{
+	if (tvnorm == V4L2_STD_PAL_BG) {
+		if (height == 576 || height == 288)
+			return 1;
+		else
+			return 0;
+	}
+
+	if (tvnorm == V4L2_STD_NTSC_M) {
+		if (height == 480 || height == 240)
+			return 1;
+		else
+			return 0;
+	}
+
+	return 0;
+}
+
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
@@ -918,89 +1012,8 @@ static int vidioc_log_status(struct file *file, void *priv)
 	return 0;
 }
 
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			struct v4l2_control *ctl)
-{
-	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	int err;
-
-	if (fh) {
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	}
-
-	return cx25821_set_control(dev, ctl, fh->channel_id);
-}
-
-/* VIDEO IOCTLS */
-int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-				 struct v4l2_format *f)
-{
-	struct cx25821_fh *fh = priv;
-
-	f->fmt.pix.width = fh->width;
-	f->fmt.pix.height = fh->height;
-	f->fmt.pix.field = fh->vidq.field;
-	f->fmt.pix.pixelformat = fh->fmt->fourcc;
-	f->fmt.pix.bytesperline = (f->fmt.pix.width * fh->fmt->depth) >> 3;
-	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
-
-	return 0;
-}
-
-int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-				   struct v4l2_format *f)
-{
-	struct cx25821_fmt *fmt;
-	enum v4l2_field field;
-	unsigned int maxw, maxh;
-
-	fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
-	if (NULL == fmt)
-		return -EINVAL;
-
-	field = f->fmt.pix.field;
-	maxw = 720;
-	maxh = 576;
-
-	if (V4L2_FIELD_ANY == field) {
-		if (f->fmt.pix.height > maxh / 2)
-			field = V4L2_FIELD_INTERLACED;
-		else
-			field = V4L2_FIELD_TOP;
-	}
-
-	switch (field) {
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-		maxh = maxh / 2;
-		break;
-	case V4L2_FIELD_INTERLACED:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	f->fmt.pix.field = field;
-	if (f->fmt.pix.height < 32)
-		f->fmt.pix.height = 32;
-	if (f->fmt.pix.height > maxh)
-		f->fmt.pix.height = maxh;
-	if (f->fmt.pix.width < 48)
-		f->fmt.pix.width = 48;
-	if (f->fmt.pix.width > maxw)
-		f->fmt.pix.width = maxw;
-	f->fmt.pix.width &= ~0x03;
-	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
-	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
-
-	return 0;
-}
 
-int cx25821_vidioc_querycap(struct file *file, void *priv,
+static int cx25821_vidioc_querycap(struct file *file, void *priv,
 			    struct v4l2_capability *cap)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
@@ -1020,7 +1033,7 @@ int cx25821_vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+static int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_fmtdesc *f)
 {
 	if (unlikely(f->index >= ARRAY_SIZE(formats)))
@@ -1032,27 +1045,27 @@ int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-int cx25821_vidioc_reqbufs(struct file *file, void *priv,
+static int cx25821_vidioc_reqbufs(struct file *file, void *priv,
 			   struct v4l2_requestbuffers *p)
 {
 	struct cx25821_fh *fh = priv;
 	return videobuf_reqbufs(get_queue(fh), p);
 }
 
-int cx25821_vidioc_querybuf(struct file *file, void *priv,
+static int cx25821_vidioc_querybuf(struct file *file, void *priv,
 			    struct v4l2_buffer *p)
 {
 	struct cx25821_fh *fh = priv;
 	return videobuf_querybuf(get_queue(fh), p);
 }
 
-int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+static int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	struct cx25821_fh *fh = priv;
 	return videobuf_qbuf(get_queue(fh), p);
 }
 
-int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
+static int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;
 	struct cx25821_fh *fh = f;
@@ -1062,7 +1075,7 @@ int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
 	return 0;
 }
 
-int cx25821_vidioc_s_priority(struct file *file, void *f,
+static int cx25821_vidioc_s_priority(struct file *file, void *f,
 			      enum v4l2_priority prio)
 {
 	struct cx25821_fh *fh = f;
@@ -1072,7 +1085,7 @@ int cx25821_vidioc_s_priority(struct file *file, void *f,
 			prio);
 }
 
-int cx25821_vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
+static int cx25821_vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 
@@ -1107,18 +1120,20 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 	return 0;
 }
 
-int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i)
+static int cx25821_vidioc_enum_input(struct file *file, void *priv,
+			      struct v4l2_input *i)
 {
 	static const char * const iname[] = {
 		[CX25821_VMUX_COMPOSITE] = "Composite",
 		[CX25821_VMUX_SVIDEO] = "S-Video",
 		[CX25821_VMUX_DEBUG] = "for debug only",
 	};
+	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	unsigned int n;
 	dprintk(1, "%s()\n", __func__);
 
 	n = i->index;
-	if (n >= 2)
+	if (n >= CX25821_NR_INPUT)
 		return -EINVAL;
 
 	if (0 == INPUT(n)->type)
@@ -1131,15 +1146,7 @@ int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i)
 	return 0;
 }
 
-int cx25821_vidioc_enum_input(struct file *file, void *priv,
-			      struct v4l2_input *i)
-{
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	dprintk(1, "%s()\n", __func__);
-	return cx25821_enum_input(dev, i);
-}
-
-int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+static int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 
@@ -1148,7 +1155,7 @@ int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
-int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
+static int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
@@ -1262,7 +1269,7 @@ static int cx25821_ctrl_query(struct v4l2_queryctrl *qctrl)
 	return 0;
 }
 
-int cx25821_vidioc_queryctrl(struct file *file, void *priv,
+static int cx25821_vidioc_queryctrl(struct file *file, void *priv,
 		     struct v4l2_queryctrl *qctrl)
 {
 	return cx25821_ctrl_query(qctrl);
@@ -1281,7 +1288,7 @@ static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
 	return NULL;
 }
 
-int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
+static int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
 			  struct v4l2_control *ctl)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
@@ -1310,7 +1317,7 @@ int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
 	return 0;
 }
 
-int cx25821_set_control(struct cx25821_dev *dev,
+static int cx25821_set_control(struct cx25821_dev *dev,
 			struct v4l2_control *ctl, int chan_num)
 {
 	int err;
@@ -1360,6 +1367,23 @@ int cx25821_set_control(struct cx25821_dev *dev,
 	return err;
 }
 
+static int vidioc_s_ctrl(struct file *file, void *priv,
+			struct v4l2_control *ctl)
+{
+	struct cx25821_fh *fh = priv;
+	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	int err;
+
+	if (fh) {
+		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
+				      fh->prio);
+		if (0 != err)
+			return err;
+	}
+
+	return cx25821_set_control(dev, ctl, fh->channel_id);
+}
+
 static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num)
 {
 	struct v4l2_control ctrl;
@@ -1372,7 +1396,7 @@ static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num)
 	}
 }
 
-int cx25821_vidioc_cropcap(struct file *file, void *priv,
+static int cx25821_vidioc_cropcap(struct file *file, void *priv,
 			   struct v4l2_cropcap *cropcap)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
@@ -1391,7 +1415,7 @@ int cx25821_vidioc_cropcap(struct file *file, void *priv,
 	return 0;
 }
 
-int cx25821_vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
+static int cx25821_vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	struct cx25821_fh *fh = priv;
@@ -1407,49 +1431,12 @@ int cx25821_vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop
 	return -EINVAL;
 }
 
-int cx25821_vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
+static int cx25821_vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 {
 	/* cx25821_vidioc_g_crop not supported */
 	return -EINVAL;
 }
 
-int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm)
-{
-	if (tvnorm == V4L2_STD_PAL_BG) {
-		if (width == 352 || width == 720)
-			return 1;
-		else
-			return 0;
-	}
-
-	if (tvnorm == V4L2_STD_NTSC_M) {
-		if (width == 320 || width == 352 || width == 720)
-			return 1;
-		else
-			return 0;
-	}
-	return 0;
-}
-
-int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm)
-{
-	if (tvnorm == V4L2_STD_PAL_BG) {
-		if (height == 576 || height == 288)
-			return 1;
-		else
-			return 0;
-	}
-
-	if (tvnorm == V4L2_STD_NTSC_M) {
-		if (height == 480 || height == 240)
-			return 1;
-		else
-			return 0;
-	}
-
-	return 0;
-}
-
 static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 505b7f0..9d70020 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -63,97 +63,23 @@ do {									\
 #define MEDUSA_READ		    910
 #define MEDUSA_WRITE		    911
 
-extern unsigned int vid_limit;
-
 #define FORMAT_FLAGS_PACKED       0x01
-extern struct cx25821_fmt formats[];
-extern struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc);
-extern struct cx25821_data timeout_data[MAX_VID_CHANNEL_NUM];
-
 extern void cx25821_video_wakeup(struct cx25821_dev *dev,
 				 struct cx25821_dmaqueue *q, u32 count);
 
-extern int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm);
-
 extern int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
 			   unsigned int bit);
 extern int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit);
 extern int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit);
 extern void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
 			     unsigned int bits);
-extern int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input);
 extern int cx25821_start_video_dma(struct cx25821_dev *dev,
 				   struct cx25821_dmaqueue *q,
 				   struct cx25821_buffer *buf,
 				   const struct sram_channel *channel);
 
-extern int cx25821_set_scale(struct cx25821_dev *dev, unsigned int width,
-			     unsigned int height, enum v4l2_field field);
 extern int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status);
 extern void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num);
 extern int cx25821_video_register(struct cx25821_dev *dev);
-extern int cx25821_get_format_size(void);
-
-extern int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
-				unsigned int *size);
-extern int cx25821_buffer_prepare(struct videobuf_queue *q,
-				  struct videobuf_buffer *vb,
-				  enum v4l2_field field);
-extern void cx25821_buffer_release(struct videobuf_queue *q,
-				   struct videobuf_buffer *vb);
-extern struct videobuf_queue *get_queue(struct cx25821_fh *fh);
-extern int cx25821_get_resource(struct cx25821_fh *fh, int resource);
-extern int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma);
-extern int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-					  struct v4l2_format *f);
-extern int cx25821_vidioc_querycap(struct file *file, void *priv,
-				   struct v4l2_capability *cap);
-extern int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
-					   struct v4l2_fmtdesc *f);
-extern int cx25821_vidioc_reqbufs(struct file *file, void *priv,
-				  struct v4l2_requestbuffers *p);
-extern int cx25821_vidioc_querybuf(struct file *file, void *priv,
-				   struct v4l2_buffer *p);
-extern int cx25821_vidioc_qbuf(struct file *file, void *priv,
-			       struct v4l2_buffer *p);
-extern int cx25821_vidioc_s_std(struct file *file, void *priv,
-				v4l2_std_id tvnorms);
-extern int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i);
-extern int cx25821_vidioc_enum_input(struct file *file, void *priv,
-				     struct v4l2_input *i);
-extern int cx25821_vidioc_g_input(struct file *file, void *priv,
-				  unsigned int *i);
-extern int cx25821_vidioc_s_input(struct file *file, void *priv,
-				  unsigned int i);
-extern int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
-				 struct v4l2_control *ctl);
-extern int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-					struct v4l2_format *f);
-extern int cx25821_vidioc_g_register(struct file *file, void *fh,
-				     struct v4l2_dbg_register *reg);
-extern int cx25821_vidioc_s_register(struct file *file, void *fh,
-				     const struct v4l2_dbg_register *reg);
-
-extern int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm);
-extern int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm);
-
-extern int cx25821_vidioc_g_priority(struct file *file, void *f,
-				     enum v4l2_priority *p);
-extern int cx25821_vidioc_s_priority(struct file *file, void *f,
-				     enum v4l2_priority prio);
-
-extern int cx25821_vidioc_queryctrl(struct file *file, void *priv,
-				    struct v4l2_queryctrl *qctrl);
-extern int cx25821_set_control(struct cx25821_dev *dev,
-			       struct v4l2_control *ctrl, int chan_num);
-
-extern int cx25821_vidioc_cropcap(struct file *file, void *fh,
-				  struct v4l2_cropcap *cropcap);
-extern int cx25821_vidioc_s_crop(struct file *file, void *priv,
-				 const struct v4l2_crop *crop);
-extern int cx25821_vidioc_g_crop(struct file *file, void *priv,
-				 struct v4l2_crop *crop);
 
-extern int cx25821_vidioc_querystd(struct file *file, void *priv,
-				   v4l2_std_id *norm);
 #endif
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 195b004..033993f 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -127,7 +127,7 @@ struct cx25821_fh {
 	enum v4l2_priority prio;
 
 	/* video capture */
-	struct cx25821_fmt *fmt;
+	const struct cx25821_fmt *fmt;
 	unsigned int width, height;
 	int channel_id;
 	struct videobuf_queue vidq;
@@ -152,7 +152,7 @@ struct cx25821_buffer {
 	/* cx25821 specific */
 	unsigned int bpl;
 	struct btcx_riscmem risc;
-	struct cx25821_fmt *fmt;
+	const struct cx25821_fmt *fmt;
 	u32 count;
 };
 
@@ -565,8 +565,5 @@ extern int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 					       unsigned int bpl, u32 risc);
 extern void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel,
 				     u32 format);
-extern struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
-					      struct pci_dev *pci,
-					      const struct video_device *template,
-					      char *type);
+
 #endif
-- 
1.7.10.4

