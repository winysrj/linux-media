Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1576 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaBYKQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 06/13] vivi: add support for a video overlay
Date: Tue, 25 Feb 2014 11:15:56 +0100
Message-Id: <1393323363-30058-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 330 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 328 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 49a8f89..349d61f 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -48,8 +48,9 @@
  */
 #define FPS_MAX 1000
 
-#define MAX_WIDTH 1920
+#define MAX_WIDTH  1920
 #define MAX_HEIGHT 1200
+#define MAX_CLIPS  16
 
 #define VIVI_VERSION "0.8.1"
 
@@ -173,6 +174,19 @@ static const struct vivi_fmt mplane_formats[] = {
 	},
 };
 
+static const struct vivi_fmt formats_ovl[] = {
+	{
+		.name     = "RGB565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.depth    = 16,
+	},
+	{
+		.name     = "RGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+	},
+};
+
 static const struct vivi_fmt *__get_format(u32 pixelformat)
 {
 	const struct vivi_fmt *fmt;
@@ -246,6 +260,16 @@ struct vivi_dev {
 	struct v4l2_ctrl	   *bitmask;
 	struct v4l2_ctrl	   *int_menu;
 
+	/* Overlays */
+	struct v4l2_framebuffer    fb;
+	bool			   do_overlay;
+	void			   *fb_vbase;
+	int			   overlay_top, overlay_left;
+	void			   *bitmap;
+	struct v4l2_clip	   clips[MAX_CLIPS];
+	struct v4l2_clip	   try_clips[MAX_CLIPS];
+	unsigned		   clipcount;
+
 	spinlock_t                 slock;
 	struct mutex		   mutex;
 
@@ -733,6 +757,27 @@ done:
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 }
 
+static bool valid_pix(struct vivi_dev *dev, int win_y, int win_x, int fb_y, int fb_x)
+{
+	bool valid = true;
+
+	if (dev->bitmap)
+		valid = ((__u8 *)dev->bitmap)[((dev->width + 7) / 8) * win_y + win_x / 8] & (1 << (win_x & 7));
+	if (valid && dev->clipcount) {
+		int i;
+
+		for (i = 0; i < dev->clipcount; i++) {
+			struct v4l2_rect *r = &dev->clips[i].c;
+
+			if (fb_y >= r->top && fb_y < r->top + r->height &&
+			    fb_x >= r->left && fb_x < r->left + r->width)
+				return true;
+		}
+		valid = false;
+	}
+	return valid;
+}
+
 static void vivi_thread_tick(struct vivi_dev *dev)
 {
 	struct vivi_dmaqueue *dma_q = &dev->vidq;
@@ -757,7 +802,51 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 	/* Fill buffer */
 	vivi_fillbuff(dev, buf);
 	dprintk(dev, 1, "filled buffer %p\n", buf);
+	if (dev->do_overlay && dev->fb.base) {
+		void *vbase = dev->fb_vbase;
+		void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+		unsigned stride = dev->width * dev->pixelsize;
+		bool quick = dev->bitmap == NULL && dev->clipcount == 0;
+		int x, y, w, out_x = 0;
+
+		x = dev->overlay_left;
+		w = dev->width;
+		if (x < 0) {
+			out_x = -x;
+			w = w - out_x;
+			x = 0;
+		} else {
+			w = dev->fb.fmt.width - x;
+			if (w > dev->width)
+				w = dev->width;
+		}
+		if (w <= 0)
+			goto done;
+		if (dev->overlay_top >= 0)
+			vbase += dev->overlay_top * dev->fb.fmt.bytesperline;
+		for (y = dev->overlay_top; y < dev->overlay_top + (int)dev->height; y++) {
+			if (y >= 0 && y < dev->fb.fmt.height) {
+				if (quick) {
+					memcpy(vbase + x * dev->pixelsize,
+					       vbuf + out_x * dev->pixelsize, w * dev->pixelsize);
+				} else {
+					int px;
+
+					for (px = 0; px < w; px++) {
+						if (valid_pix(dev, y - dev->overlay_top, px + out_x,
+								   y, px + x))
+							memcpy(vbase + (px + x) * dev->pixelsize,
+							       vbuf + (px + out_x) * dev->pixelsize,
+							       dev->pixelsize);
+					}
+				}
+				vbase += dev->fb.fmt.bytesperline;
+			}
+			vbuf += stride;
+		}
+	}
 
+done:
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
 }
@@ -1135,7 +1224,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", dev->v4l2_dev.name);
 	cap->device_caps = multiplanar ? V4L2_CAP_VIDEO_CAPTURE_MPLANE :
-			 V4L2_CAP_VIDEO_CAPTURE;
+			 V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY;
 	cap->device_caps |= V4L2_CAP_STREAMING  | V4L2_CAP_READWRITE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
@@ -1345,6 +1434,216 @@ static int vidioc_s_fmt_vid_cap_mplane(struct file *file, void *priv,
 	return 0;
 }
 
+static int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	const struct vivi_fmt *fmt;
+
+	if (multiplanar)
+		return -ENOTTY;
+
+	if (f->index >= ARRAY_SIZE(formats_ovl))
+		return -EINVAL;
+
+	fmt = &formats_ovl[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_window *win = &f->fmt.win;
+	unsigned clipcount = win->clipcount;
+
+	if (multiplanar)
+		return -ENOTTY;
+
+	win->w.top = dev->overlay_top;
+	win->w.left = dev->overlay_left;
+	win->w.width = dev->width;
+	win->w.height = dev->height;
+	win->field = V4L2_FIELD_INTERLACED;
+	win->clipcount = dev->clipcount;
+	if (clipcount > dev->clipcount)
+		clipcount = dev->clipcount;
+	if (dev->bitmap == NULL)
+		win->bitmap = NULL;
+	else if (win->bitmap) {
+		if (copy_to_user(win->bitmap, dev->bitmap,
+		    ((dev->width + 7) / 8) * dev->height))
+			return -EFAULT;
+	}
+	if (clipcount && win->clips) {
+		if (copy_to_user(win->clips, dev->clips,
+				 clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static bool rect_overlap(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
+{
+	/*
+	 * IF the left side of r1 is to the right of the right side of r2 OR
+	 *    the left side of r2 is to the right of the right side of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->left >= r2->left + r2->width ||
+	    r2->left >= r1->left + r1->width)
+		return false;
+	/*
+	 * IF the top side of r1 is below the bottom of r2 OR
+	 *    the top side of r2 is below the bottom of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->top >= r2->top + r2->height ||
+	    r2->top >= r1->top + r1->height)
+		return false;
+	return true;
+}
+
+static int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_window *win = &f->fmt.win;
+	int i, j;
+
+	if (multiplanar)
+		return -ENOTTY;
+
+	win->w.left = clamp_t(int, win->w.left,
+			      -dev->fb.fmt.width, dev->fb.fmt.width);
+	win->w.top = clamp_t(int, win->w.top,
+			     -dev->fb.fmt.height, dev->fb.fmt.height);
+	win->w.width = dev->width;
+	win->w.height = dev->height;
+	win->field = V4L2_FIELD_INTERLACED;
+	win->chromakey = 0;
+	win->global_alpha = 0;
+	if (win->clipcount && !win->clips)
+		win->clipcount = 0;
+	if (win->clipcount > MAX_CLIPS)
+		win->clipcount = MAX_CLIPS;
+	if (win->clipcount) {
+		if (copy_from_user(dev->try_clips, win->clips,
+				   win->clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+		for (i = 0; i < win->clipcount; i++) {
+			struct v4l2_rect *r = &dev->try_clips[i].c;
+
+			r->top = clamp_t(s32, r->top, 0, dev->fb.fmt.height - 1);
+			r->height = clamp_t(s32, r->height, 1, dev->fb.fmt.height - r->top);
+			r->left = clamp_t(u32, r->left, 0, dev->fb.fmt.width - 1);
+			r->width = clamp_t(u32, r->width, 1, dev->fb.fmt.width - r->left);
+		}
+		/*
+		 * Yeah, so sue me, it's an O(n^2) algorithm. But n is a small
+		 * number and it's typically a one-time deal.
+		 */
+		for (i = 0; i < win->clipcount - 1; i++) {
+			struct v4l2_rect *r1 = &dev->try_clips[i].c;
+
+			for (j = i + 1; j < win->clipcount; j++) {
+				struct v4l2_rect *r2 = &dev->try_clips[j].c;
+
+				if (rect_overlap(r1, r2))
+					return -EINVAL;
+			}
+		}
+		if (copy_to_user(win->clips, dev->try_clips,
+				 win->clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_window *win = &f->fmt.win;
+	int ret = vidioc_try_fmt_vid_overlay(file, priv, f);
+	unsigned bitmap_size = ((dev->width + 7) / 8) * dev->height;
+	unsigned clips_size = win->clipcount * sizeof(dev->clips[0]);
+	void *new_bitmap = NULL;
+
+	if (ret)
+		return ret;
+
+	if (win->bitmap) {
+		new_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+
+		if (new_bitmap == NULL)
+			return -ENOMEM;
+		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
+			kfree(new_bitmap);
+			return -EFAULT;
+		}
+	}
+
+	dev->overlay_top = win->w.top;
+	dev->overlay_left = win->w.left;
+	kfree(dev->bitmap);
+	dev->bitmap = new_bitmap;
+	dev->clipcount = win->clipcount;
+	if (dev->clipcount)
+		memcpy(dev->clips, dev->try_clips, clips_size);
+	return 0;
+}
+
+static int vidioc_overlay(struct file *file, void *fh, unsigned int i)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	dev->do_overlay = !!i;
+	return 0;
+}
+
+static int vidioc_g_fbuf(struct file *file, void *fh,
+				struct v4l2_framebuffer *a)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	*a = dev->fb;
+	return 0;
+}
+
+static int vidioc_s_fbuf(struct file *file, void *fh,
+				const struct v4l2_framebuffer *a)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	const struct vivi_fmt *fmt;
+	void *vbase = NULL;
+
+	if (a->fmt.width < 48 || a->fmt.height < 32)
+		return -EINVAL;
+	fmt = __get_format(a->fmt.pixelformat);
+	if (!fmt)
+		return -EINVAL;
+	if (a->fmt.bytesperline < (a->fmt.width * fmt->depth) / 8)
+		return -EINVAL;
+	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	if (a->base)
+		vbase = phys_to_virt((unsigned long)a->base);
+	dev->fb_vbase = vbase;
+	dev->fb = *a;
+	dev->overlay_left = clamp_t(int, dev->overlay_left,
+				    -dev->fb.fmt.width, dev->fb.fmt.width);
+	dev->overlay_top = clamp_t(int, dev->overlay_top,
+				   -dev->fb.fmt.height, dev->fb.fmt.height);
+	return 0;
+}
+
 static int vidioc_enum_framesizes(struct file *file, void *fh,
 					 struct v4l2_frmsizeenum *fsize)
 {
@@ -1630,6 +1929,16 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
 	.vidioc_enum_framesizes   = vidioc_enum_framesizes,
+
+	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_overlay    = vidioc_g_fmt_vid_overlay,
+	.vidioc_try_fmt_vid_overlay  = vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay    = vidioc_s_fmt_vid_overlay,
+
+	.vidioc_overlay       = vidioc_overlay,
+	.vidioc_g_fbuf        = vidioc_g_fbuf,
+	.vidioc_s_fbuf        = vidioc_s_fbuf,
+
 	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
 	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
@@ -1696,6 +2005,7 @@ static int vivi_release(void)
 		video_unregister_device(&dev->vdev);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		v4l2_ctrl_handler_free(&dev->ctrl_handler);
+		kfree(dev->bitmap);
 		kfree(dev);
 	}
 
@@ -1758,6 +2068,17 @@ static int __init vivi_create_instance(int inst)
 	v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
 	dev->v4l2_dev.ctrl_handler = hdl;
 
+	/* initialize overlay */
+	dev->fb.capability = V4L2_FBUF_CAP_BITMAP_CLIPPING |
+			     V4L2_FBUF_CAP_LIST_CLIPPING;
+	dev->fb.flags = V4L2_FBUF_FLAG_PRIMARY;
+	dev->fb.fmt.width = dev->width;
+	dev->fb.fmt.height = dev->height;
+	dev->fb.fmt.pixelformat = dev->fmt->fourcc;
+	dev->fb.fmt.bytesperline = dev->width * dev->pixelsize;
+	dev->fb.fmt.sizeimage = dev->height * dev->fb.fmt.bytesperline;
+	dev->fb.fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
+
 	/* initialize locks */
 	spin_lock_init(&dev->slock);
 
@@ -1790,6 +2111,11 @@ static int __init vivi_create_instance(int inst)
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->queue = q;
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	if (multiplanar) {
+		v4l2_disable_ioctl(vfd, VIDIOC_OVERLAY);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_FBUF);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_FBUF);
+	}
 
 	/*
 	 * Provide a mutex to v4l2 core. It will be used to protect
-- 
1.9.0

