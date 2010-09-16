Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IPA6D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 20:58:03 -0400
Date: Wed, 15 Sep 2010 21:56:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/8] V4L/DVB: bttv-driver: document functions using
 mutex_lock
Message-ID: <20100915215636.60a2bed0@pedra>
In-Reply-To: <cover.1284597566.git.mchehab@redhat.com>
References: <cover.1284597566.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are a few ancillary static routines used by ioctl functions
that takes bttv lock internally. As we'll be adding the same lock
for all ioctl's that need, we need to properly document them, to
avoid doing double locks

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 38c7f78..fcafe2f 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -842,7 +842,7 @@ static const struct v4l2_queryctrl *ctrl_by_id(int id)
 			 RESOURCE_OVERLAY)
 
 static
-int check_alloc_btres(struct bttv *btv, struct bttv_fh *fh, int bit)
+int check_alloc_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bit)
 {
 	int xbits; /* mutual exclusive resources */
 
@@ -935,7 +935,7 @@ disclaim_video_lines(struct bttv *btv)
 }
 
 static
-void free_btres(struct bttv *btv, struct bttv_fh *fh, int bits)
+void free_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bits)
 {
 	if ((fh->resources & bits) != bits) {
 		/* trying to free ressources not allocated by us ... */
@@ -1682,7 +1682,7 @@ bttv_switch_overlay(struct bttv *btv, struct bttv_fh *fh,
 		kfree(old);
 	}
 	if (NULL == new)
-		free_btres(btv,fh,RESOURCE_OVERLAY);
+		free_btres_lock(btv,fh,RESOURCE_OVERLAY);
 	dprintk("switch_overlay: done\n");
 	return retval;
 }
@@ -2124,7 +2124,7 @@ bttv_crop_adjust	(struct bttv_crop *             c,
    also adjust the current cropping parameters to get closer to the
    desired image size. */
 static int
-limit_scaled_size       (struct bttv_fh *               fh,
+limit_scaled_size_lock       (struct bttv_fh *               fh,
 			 __s32 *                        width,
 			 __s32 *                        height,
 			 enum v4l2_field                field,
@@ -2238,7 +2238,7 @@ limit_scaled_size       (struct bttv_fh *               fh,
    may also adjust the current cropping parameters to get closer
    to the desired window size. */
 static int
-verify_window		(struct bttv_fh *               fh,
+verify_window_lock		(struct bttv_fh *               fh,
 			 struct v4l2_window *           win,
 			 int                            adjust_size,
 			 int                            adjust_crop)
@@ -2292,7 +2292,7 @@ verify_window		(struct bttv_fh *               fh,
 	win->w.width -= win->w.left & ~width_mask;
 	win->w.left = (win->w.left - width_mask - 1) & width_mask;
 
-	rc = limit_scaled_size(fh, &win->w.width, &win->w.height,
+	rc = limit_scaled_size_lock(fh, &win->w.width, &win->w.height,
 			       field, width_mask,
 			       /* width_bias: round down */ 0,
 			       adjust_size, adjust_crop);
@@ -2303,7 +2303,7 @@ verify_window		(struct bttv_fh *               fh,
 	return 0;
 }
 
-static int setup_window(struct bttv_fh *fh, struct bttv *btv,
+static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
 			struct v4l2_window *win, int fixup)
 {
 	struct v4l2_clip *clips = NULL;
@@ -2313,7 +2313,7 @@ static int setup_window(struct bttv_fh *fh, struct bttv *btv,
 		return -EINVAL;
 	if (!(fh->ovfmt->flags & FORMAT_FLAGS_PACKED))
 		return -EINVAL;
-	retval = verify_window(fh, win,
+	retval = verify_window_lock(fh, win,
 			       /* adjust_size */ fixup,
 			       /* adjust_crop */ fixup);
 	if (0 != retval)
@@ -2516,7 +2516,7 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
 	width = f->fmt.pix.width;
 	height = f->fmt.pix.height;
 
-	rc = limit_scaled_size(fh, &width, &height, field,
+	rc = limit_scaled_size_lock(fh, &width, &height, field,
 			       /* width_mask: 4 pixels */ ~3,
 			       /* width_bias: nearest */ 2,
 			       /* adjust_size */ 1,
@@ -2536,7 +2536,7 @@ static int bttv_try_fmt_vid_overlay(struct file *file, void *priv,
 {
 	struct bttv_fh *fh = priv;
 
-	return verify_window(fh, &f->fmt.win,
+	return verify_window_lock(fh, &f->fmt.win,
 			/* adjust_size */ 1,
 			/* adjust_crop */ 0);
 }
@@ -2563,7 +2563,7 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
 	height = f->fmt.pix.height;
 	field = f->fmt.pix.field;
 
-	retval = limit_scaled_size(fh, &width, &height, f->fmt.pix.field,
+	retval = limit_scaled_size_lock(fh, &width, &height, f->fmt.pix.field,
 			       /* width_mask: 4 pixels */ ~3,
 			       /* width_bias: nearest */ 2,
 			       /* adjust_size */ 1,
@@ -2601,7 +2601,7 @@ static int bttv_s_fmt_vid_overlay(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	return setup_window(fh, btv, &f->fmt.win, 1);
+	return setup_window_lock(fh, btv, &f->fmt.win, 1);
 }
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -2742,7 +2742,7 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
 		}
 	}
 
-	if (!check_alloc_btres(btv, fh, RESOURCE_OVERLAY))
+	if (!check_alloc_btres_lock(btv, fh, RESOURCE_OVERLAY))
 		return -EBUSY;
 
 	mutex_lock(&fh->cap.vb_lock);
@@ -2785,7 +2785,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
 		__s32 width = fb->fmt.width;
 		__s32 height = fb->fmt.height;
 
-		retval = limit_scaled_size(fh, &width, &height,
+		retval = limit_scaled_size_lock(fh, &width, &height,
 					   V4L2_FIELD_INTERLACED,
 					   /* width_mask */ ~3,
 					   /* width_bias */ 2,
@@ -2852,7 +2852,7 @@ static int bttv_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 	struct bttv *btv = fh->btv;
 	int res = bttv_resource(fh);
 
-	if (!check_alloc_btres(btv, fh, res))
+	if (!check_alloc_btres_lock(btv, fh, res))
 		return -EBUSY;
 
 	return videobuf_qbuf(bttv_queue(fh), b);
@@ -2872,7 +2872,7 @@ static int bttv_streamon(struct file *file, void *priv,
 	struct bttv *btv = fh->btv;
 	int res = bttv_resource(fh);
 
-	if (!check_alloc_btres(btv, fh, res))
+	if (!check_alloc_btres_lock(btv, fh, res))
 		return -EBUSY;
 	return videobuf_streamon(bttv_queue(fh));
 }
@@ -2890,7 +2890,7 @@ static int bttv_streamoff(struct file *file, void *priv,
 	retval = videobuf_streamoff(bttv_queue(fh));
 	if (retval < 0)
 		return retval;
-	free_btres(btv, fh, res);
+	free_btres_lock(btv, fh, res);
 	return 0;
 }
 
@@ -3030,7 +3030,7 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
 
 	/* Make sure tvnorm, vbi_end and the current cropping
 	   parameters remain consistent until we're done. Note
-	   read() may change vbi_end in check_alloc_btres(). */
+	   read() may change vbi_end in check_alloc_btres_lock(). */
 	mutex_lock(&btv->lock);
 
 	retval = -EBUSY;
@@ -3128,17 +3128,17 @@ static ssize_t bttv_read(struct file *file, char __user *data,
 
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (!check_alloc_btres(fh->btv, fh, RESOURCE_VIDEO_READ)) {
+		if (!check_alloc_btres_lock(fh->btv, fh, RESOURCE_VIDEO_READ)) {
 			/* VIDEO_READ in use by another fh,
 			   or VIDEO_STREAM by any fh. */
 			return -EBUSY;
 		}
 		retval = videobuf_read_one(&fh->cap, data, count, ppos,
 					   file->f_flags & O_NONBLOCK);
-		free_btres(fh->btv, fh, RESOURCE_VIDEO_READ);
+		free_btres_lock(fh->btv, fh, RESOURCE_VIDEO_READ);
 		break;
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (!check_alloc_btres(fh->btv,fh,RESOURCE_VBI))
+		if (!check_alloc_btres_lock(fh->btv,fh,RESOURCE_VBI))
 			return -EBUSY;
 		retval = videobuf_read_stream(&fh->vbi, data, count, ppos, 1,
 					      file->f_flags & O_NONBLOCK);
@@ -3157,7 +3157,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	unsigned int rc = POLLERR;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
-		if (!check_alloc_btres(fh->btv,fh,RESOURCE_VBI))
+		if (!check_alloc_btres_lock(fh->btv,fh,RESOURCE_VBI))
 			return POLLERR;
 		return videobuf_poll_stream(file, &fh->vbi, wait);
 	}
@@ -3288,20 +3288,20 @@ static int bttv_release(struct file *file)
 	/* stop video capture */
 	if (check_btres(fh, RESOURCE_VIDEO_STREAM)) {
 		videobuf_streamoff(&fh->cap);
-		free_btres(btv,fh,RESOURCE_VIDEO_STREAM);
+		free_btres_lock(btv,fh,RESOURCE_VIDEO_STREAM);
 	}
 	if (fh->cap.read_buf) {
 		buffer_release(&fh->cap,fh->cap.read_buf);
 		kfree(fh->cap.read_buf);
 	}
 	if (check_btres(fh, RESOURCE_VIDEO_READ)) {
-		free_btres(btv, fh, RESOURCE_VIDEO_READ);
+		free_btres_lock(btv, fh, RESOURCE_VIDEO_READ);
 	}
 
 	/* stop vbi capture */
 	if (check_btres(fh, RESOURCE_VBI)) {
 		videobuf_stop(&fh->vbi);
-		free_btres(btv,fh,RESOURCE_VBI);
+		free_btres_lock(btv,fh,RESOURCE_VBI);
 	}
 
 	/* free stuff */
-- 
1.7.1


