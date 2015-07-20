Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44726 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbbGTNTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:19:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] zoran: use standard core lock
Date: Mon, 20 Jul 2015 15:18:20 +0200
Message-Id: <1437398302-6211-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
References: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the standard core lock to take care of serializing ioctl calls and
to serialize file operations.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran.h        |   3 +-
 drivers/media/pci/zoran/zoran_card.c   |   6 +-
 drivers/media/pci/zoran/zoran_driver.c | 249 ++++++++-------------------------
 3 files changed, 60 insertions(+), 198 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
index 5e04008..4109775 100644
--- a/drivers/media/pci/zoran/zoran.h
+++ b/drivers/media/pci/zoran/zoran.h
@@ -280,8 +280,7 @@ struct zoran {
 	struct videocodec *codec;	/* video codec */
 	struct videocodec *vfe;	/* video front end */
 
-	struct mutex resource_lock;	/* prevent evil stuff */
-	struct mutex other_lock;	/* please merge with above */
+	struct mutex lock;	/* file ops serialize lock */
 
 	u8 initialized;		/* flag if zoran has been correctly initialized */
 	int user;		/* number of current users */
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index cec5b75..afeca42 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1049,8 +1049,9 @@ static int zr36057_init (struct zoran *zr)
 	/*
 	 *   Now add the template and register the device unit.
 	 */
-	memcpy(zr->video_dev, &zoran_template, sizeof(zoran_template));
+	*zr->video_dev = zoran_template;
 	zr->video_dev->v4l2_dev = &zr->v4l2_dev;
+	zr->video_dev->lock = &zr->lock;
 	strcpy(zr->video_dev->name, ZR_DEVNAME(zr));
 	/* It's not a mem2mem device, but you can both capture and output from
 	   one and the same device. This should really be split up into two
@@ -1220,8 +1221,7 @@ static int zoran_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	zr->id = nr;
 	snprintf(ZR_DEVNAME(zr), sizeof(ZR_DEVNAME(zr)), "MJPEG[%u]", zr->id);
 	spin_lock_init(&zr->spinlock);
-	mutex_init(&zr->resource_lock);
-	mutex_init(&zr->other_lock);
+	mutex_init(&zr->lock);
 	if (pci_enable_device(pdev))
 		goto zr_unreg;
 	zr->revision = zr->pci_dev->revision;
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 3d3a0c0..cbcb0a0 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -592,10 +592,14 @@ static int v4l_sync(struct zoran_fh *fh, int frame)
 		return -EPROTO;
 	}
 
+	mutex_unlock(&zr->lock);
 	/* wait on this buffer to get ready */
 	if (!wait_event_interruptible_timeout(zr->v4l_capq,
-		(zr->v4l_buffers.buffer[frame].state != BUZ_STATE_PEND), 10*HZ))
+		(zr->v4l_buffers.buffer[frame].state != BUZ_STATE_PEND), 10*HZ)) {
+		mutex_lock(&zr->lock);
 		return -ETIME;
+	}
+	mutex_lock(&zr->lock);
 	if (signal_pending(current))
 		return -ERESTARTSYS;
 
@@ -783,6 +787,7 @@ static int jpg_sync(struct zoran_fh *fh, struct zoran_sync *bs)
 			ZR_DEVNAME(zr), __func__);
 		return -EINVAL;
 	}
+	mutex_unlock(&zr->lock);
 	if (!wait_event_interruptible_timeout(zr->jpg_capq,
 			(zr->jpg_que_tail != zr->jpg_dma_tail ||
 			 zr->jpg_dma_tail == zr->jpg_dma_head),
@@ -793,6 +798,7 @@ static int jpg_sync(struct zoran_fh *fh, struct zoran_sync *bs)
 		udelay(1);
 		zr->codec->control(zr->codec, CODEC_G_STATUS,
 					   sizeof(isr), &isr);
+		mutex_lock(&zr->lock);
 		dprintk(1,
 			KERN_ERR
 			"%s: %s - timeout: codec isr=0x%02x\n",
@@ -801,6 +807,7 @@ static int jpg_sync(struct zoran_fh *fh, struct zoran_sync *bs)
 		return -ETIME;
 
 	}
+	mutex_lock(&zr->lock);
 	if (signal_pending(current))
 		return -ERESTARTSYS;
 
@@ -911,7 +918,7 @@ static int zoran_open(struct file *file)
 	dprintk(2, KERN_INFO "%s: %s(%s, pid=[%d]), users(-)=%d\n",
 		ZR_DEVNAME(zr), __func__, current->comm, task_pid_nr(current), zr->user + 1);
 
-	mutex_lock(&zr->other_lock);
+	mutex_lock(&zr->lock);
 
 	if (zr->user >= 2048) {
 		dprintk(1, KERN_ERR "%s: too many users (%d) on device\n",
@@ -946,8 +953,6 @@ static int zoran_open(struct file *file)
 	if (zr->user++ == 0)
 		first_open = 1;
 
-	/*mutex_unlock(&zr->resource_lock);*/
-
 	/* default setup - TODO: look at flags */
 	if (first_open) {	/* First device open */
 		zr36057_restart(zr);
@@ -961,14 +966,14 @@ static int zoran_open(struct file *file)
 	file->private_data = fh;
 	fh->zr = zr;
 	zoran_open_init_session(fh);
-	mutex_unlock(&zr->other_lock);
+	mutex_unlock(&zr->lock);
 
 	return 0;
 
 fail_fh:
 	kfree(fh);
 fail_unlock:
-	mutex_unlock(&zr->other_lock);
+	mutex_unlock(&zr->lock);
 
 	dprintk(2, KERN_INFO "%s: open failed (%d), users(-)=%d\n",
 		ZR_DEVNAME(zr), res, zr->user);
@@ -987,7 +992,7 @@ zoran_close(struct file  *file)
 
 	/* kernel locks (fs/device.c), so don't do that ourselves
 	 * (prevents deadlocks) */
-	mutex_lock(&zr->other_lock);
+	mutex_lock(&zr->lock);
 
 	zoran_close_end_session(fh);
 
@@ -1021,9 +1026,8 @@ zoran_close(struct file  *file)
 			encoder_call(zr, video, s_routing, 2, 0, 0);
 		}
 	}
-	mutex_unlock(&zr->other_lock);
+	mutex_unlock(&zr->lock);
 
-	file->private_data = NULL;
 	kfree(fh->overlay_mask);
 	kfree(fh);
 
@@ -1559,9 +1563,6 @@ static int zoran_g_fmt_vid_out(struct file *file, void *__fh,
 					struct v4l2_format *fmt)
 {
 	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
-
-	mutex_lock(&zr->resource_lock);
 
 	fmt->fmt.pix.width = fh->jpg_settings.img_width / fh->jpg_settings.HorDcm;
 	fmt->fmt.pix.height = fh->jpg_settings.img_height * 2 /
@@ -1577,7 +1578,6 @@ static int zoran_g_fmt_vid_out(struct file *file, void *__fh,
 	fmt->fmt.pix.bytesperline = 0;
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
-	mutex_unlock(&zr->resource_lock);
 	return 0;
 }
 
@@ -1590,7 +1590,6 @@ static int zoran_g_fmt_vid_cap(struct file *file, void *__fh,
 	if (fh->map_mode != ZORAN_MAP_MODE_RAW)
 		return zoran_g_fmt_vid_out(file, fh, fmt);
 
-	mutex_lock(&zr->resource_lock);
 	fmt->fmt.pix.width = fh->v4l_settings.width;
 	fmt->fmt.pix.height = fh->v4l_settings.height;
 	fmt->fmt.pix.sizeimage = fh->v4l_settings.bytesperline *
@@ -1602,7 +1601,6 @@ static int zoran_g_fmt_vid_cap(struct file *file, void *__fh,
 		fmt->fmt.pix.field = V4L2_FIELD_INTERLACED;
 	else
 		fmt->fmt.pix.field = V4L2_FIELD_TOP;
-	mutex_unlock(&zr->resource_lock);
 	return 0;
 }
 
@@ -1612,8 +1610,6 @@ static int zoran_g_fmt_vid_overlay(struct file *file, void *__fh,
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	mutex_lock(&zr->resource_lock);
-
 	fmt->fmt.win.w.left = fh->overlay_settings.x;
 	fmt->fmt.win.w.top = fh->overlay_settings.y;
 	fmt->fmt.win.w.width = fh->overlay_settings.width;
@@ -1623,7 +1619,6 @@ static int zoran_g_fmt_vid_overlay(struct file *file, void *__fh,
 	else
 		fmt->fmt.win.field = V4L2_FIELD_TOP;
 
-	mutex_unlock(&zr->resource_lock);
 	return 0;
 }
 
@@ -1633,8 +1628,6 @@ static int zoran_try_fmt_vid_overlay(struct file *file, void *__fh,
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	mutex_lock(&zr->resource_lock);
-
 	if (fmt->fmt.win.w.width > BUZ_MAX_WIDTH)
 		fmt->fmt.win.w.width = BUZ_MAX_WIDTH;
 	if (fmt->fmt.win.w.width < BUZ_MIN_WIDTH)
@@ -1644,7 +1637,6 @@ static int zoran_try_fmt_vid_overlay(struct file *file, void *__fh,
 	if (fmt->fmt.win.w.height < BUZ_MIN_HEIGHT)
 		fmt->fmt.win.w.height = BUZ_MIN_HEIGHT;
 
-	mutex_unlock(&zr->resource_lock);
 	return 0;
 }
 
@@ -1659,7 +1651,6 @@ static int zoran_try_fmt_vid_out(struct file *file, void *__fh,
 	if (fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 
-	mutex_lock(&zr->resource_lock);
 	settings = fh->jpg_settings;
 
 	/* we actually need to set 'real' parameters now */
@@ -1694,7 +1685,7 @@ static int zoran_try_fmt_vid_out(struct file *file, void *__fh,
 	/* check */
 	res = zoran_check_jpg_settings(zr, &settings, 1);
 	if (res)
-		goto tryfmt_unlock_and_return;
+		return res;
 
 	/* tell the user what we actually did */
 	fmt->fmt.pix.width = settings.img_width / settings.HorDcm;
@@ -1710,8 +1701,6 @@ static int zoran_try_fmt_vid_out(struct file *file, void *__fh,
 	fmt->fmt.pix.sizeimage = zoran_v4l2_calc_bufsize(&settings);
 	fmt->fmt.pix.bytesperline = 0;
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-tryfmt_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -1726,23 +1715,17 @@ static int zoran_try_fmt_vid_cap(struct file *file, void *__fh,
 	if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_MJPEG)
 		return zoran_try_fmt_vid_out(file, fh, fmt);
 
-	mutex_lock(&zr->resource_lock);
-
 	for (i = 0; i < NUM_FORMATS; i++)
 		if (zoran_formats[i].fourcc == fmt->fmt.pix.pixelformat)
 			break;
 
-	if (i == NUM_FORMATS) {
-		mutex_unlock(&zr->resource_lock);
+	if (i == NUM_FORMATS)
 		return -EINVAL;
-	}
 
 	bpp = DIV_ROUND_UP(zoran_formats[i].depth, 8);
 	v4l_bound_align_image(
 		&fmt->fmt.pix.width, BUZ_MIN_WIDTH, BUZ_MAX_WIDTH, bpp == 2 ? 1 : 2,
 		&fmt->fmt.pix.height, BUZ_MIN_HEIGHT, BUZ_MAX_HEIGHT, 0, 0);
-	mutex_unlock(&zr->resource_lock);
-
 	return 0;
 }
 
@@ -1750,7 +1733,6 @@ static int zoran_s_fmt_vid_overlay(struct file *file, void *__fh,
 					struct v4l2_format *fmt)
 {
 	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
 	int res;
 
 	dprintk(3, "x=%d, y=%d, w=%d, h=%d, cnt=%d, map=0x%p\n",
@@ -1759,12 +1741,10 @@ static int zoran_s_fmt_vid_overlay(struct file *file, void *__fh,
 			fmt->fmt.win.w.height,
 			fmt->fmt.win.clipcount,
 			fmt->fmt.win.bitmap);
-	mutex_lock(&zr->resource_lock);
 	res = setup_window(fh, fmt->fmt.win.w.left, fmt->fmt.win.w.top,
 			   fmt->fmt.win.w.width, fmt->fmt.win.w.height,
 			   (struct v4l2_clip __user *)fmt->fmt.win.clips,
 			   fmt->fmt.win.clipcount, fmt->fmt.win.bitmap);
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -1784,13 +1764,11 @@ static int zoran_s_fmt_vid_out(struct file *file, void *__fh,
 	if (fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 
-	mutex_lock(&zr->resource_lock);
-
 	if (fh->buffers.allocated) {
 		dprintk(1, KERN_ERR "%s: VIDIOC_S_FMT - cannot change capture mode\n",
 			ZR_DEVNAME(zr));
 		res = -EBUSY;
-		goto sfmtjpg_unlock_and_return;
+		return res;
 	}
 
 	settings = fh->jpg_settings;
@@ -1827,7 +1805,7 @@ static int zoran_s_fmt_vid_out(struct file *file, void *__fh,
 	/* check */
 	res = zoran_check_jpg_settings(zr, &settings, 0);
 	if (res)
-		goto sfmtjpg_unlock_and_return;
+		return res;
 
 	/* it's ok, so set them */
 	fh->jpg_settings = settings;
@@ -1848,9 +1826,6 @@ static int zoran_s_fmt_vid_out(struct file *file, void *__fh,
 	fmt->fmt.pix.bytesperline = 0;
 	fmt->fmt.pix.sizeimage = fh->buffers.buffer_size;
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-
-sfmtjpg_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -1874,14 +1849,12 @@ static int zoran_s_fmt_vid_cap(struct file *file, void *__fh,
 		return -EINVAL;
 	}
 
-	mutex_lock(&zr->resource_lock);
-
 	if ((fh->map_mode != ZORAN_MAP_MODE_RAW && fh->buffers.allocated) ||
 	    fh->buffers.active != ZORAN_FREE) {
 		dprintk(1, KERN_ERR "%s: VIDIOC_S_FMT - cannot change capture mode\n",
 				ZR_DEVNAME(zr));
 		res = -EBUSY;
-		goto sfmtv4l_unlock_and_return;
+		return res;
 	}
 	if (fmt->fmt.pix.height > BUZ_MAX_HEIGHT)
 		fmt->fmt.pix.height = BUZ_MAX_HEIGHT;
@@ -1893,7 +1866,7 @@ static int zoran_s_fmt_vid_cap(struct file *file, void *__fh,
 	res = zoran_v4l_set_format(fh, fmt->fmt.pix.width, fmt->fmt.pix.height,
 				   &zoran_formats[i]);
 	if (res)
-		goto sfmtv4l_unlock_and_return;
+		return res;
 
 	/* tell the user the results/missing stuff */
 	fmt->fmt.pix.bytesperline = fh->v4l_settings.bytesperline;
@@ -1903,9 +1876,6 @@ static int zoran_s_fmt_vid_cap(struct file *file, void *__fh,
 		fmt->fmt.pix.field = V4L2_FIELD_INTERLACED;
 	else
 		fmt->fmt.pix.field = V4L2_FIELD_TOP;
-
-sfmtv4l_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -1916,14 +1886,12 @@ static int zoran_g_fbuf(struct file *file, void *__fh,
 	struct zoran *zr = fh->zr;
 
 	memset(fb, 0, sizeof(*fb));
-	mutex_lock(&zr->resource_lock);
 	fb->base = zr->vbuf_base;
 	fb->fmt.width = zr->vbuf_width;
 	fb->fmt.height = zr->vbuf_height;
 	if (zr->overlay_settings.format)
 		fb->fmt.pixelformat = fh->overlay_settings.format->fourcc;
 	fb->fmt.bytesperline = zr->vbuf_bytesperline;
-	mutex_unlock(&zr->resource_lock);
 	fb->fmt.colorspace = V4L2_COLORSPACE_SRGB;
 	fb->fmt.field = V4L2_FIELD_INTERLACED;
 	fb->capability = V4L2_FBUF_CAP_LIST_CLIPPING;
@@ -1949,10 +1917,8 @@ static int zoran_s_fbuf(struct file *file, void *__fh,
 		return -EINVAL;
 	}
 
-	mutex_lock(&zr->resource_lock);
 	res = setup_fbuffer(fh, fb->base, &zoran_formats[i], fb->fmt.width,
 			    fb->fmt.height, fb->fmt.bytesperline);
-	mutex_unlock(&zr->resource_lock);
 
 	return res;
 }
@@ -1960,12 +1926,9 @@ static int zoran_s_fbuf(struct file *file, void *__fh,
 static int zoran_overlay(struct file *file, void *__fh, unsigned int on)
 {
 	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
 	int res;
 
-	mutex_lock(&zr->resource_lock);
 	res = setup_overlay(fh, on);
-	mutex_unlock(&zr->resource_lock);
 
 	return res;
 }
@@ -1989,14 +1952,13 @@ static int zoran_reqbufs(struct file *file, void *__fh, struct v4l2_requestbuffe
 	if (req->count == 0)
 		return zoran_streamoff(file, fh, req->type);
 
-	mutex_lock(&zr->resource_lock);
 	if (fh->buffers.allocated) {
 		dprintk(2,
 				KERN_ERR
 				"%s: VIDIOC_REQBUFS - buffers already allocated\n",
 				ZR_DEVNAME(zr));
 		res = -EBUSY;
-		goto v4l2reqbuf_unlock_and_return;
+		return res;
 	}
 
 	if (fh->map_mode == ZORAN_MAP_MODE_RAW &&
@@ -2013,7 +1975,7 @@ static int zoran_reqbufs(struct file *file, void *__fh, struct v4l2_requestbuffe
 
 		if (v4l_fbuffer_alloc(fh)) {
 			res = -ENOMEM;
-			goto v4l2reqbuf_unlock_and_return;
+			return res;
 		}
 	} else if (fh->map_mode == ZORAN_MAP_MODE_JPG_REC ||
 		   fh->map_mode == ZORAN_MAP_MODE_JPG_PLAY) {
@@ -2030,7 +1992,7 @@ static int zoran_reqbufs(struct file *file, void *__fh, struct v4l2_requestbuffe
 
 		if (jpg_fbuffer_alloc(fh)) {
 			res = -ENOMEM;
-			goto v4l2reqbuf_unlock_and_return;
+			return res;
 		}
 	} else {
 		dprintk(1,
@@ -2038,23 +2000,17 @@ static int zoran_reqbufs(struct file *file, void *__fh, struct v4l2_requestbuffe
 				"%s: VIDIOC_REQBUFS - unknown type %d\n",
 				ZR_DEVNAME(zr), req->type);
 		res = -EINVAL;
-		goto v4l2reqbuf_unlock_and_return;
+		return res;
 	}
-v4l2reqbuf_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
 static int zoran_querybuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 {
 	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
 	int res;
 
-	mutex_lock(&zr->resource_lock);
 	res = zoran_v4l2_buffer_status(fh, buf, buf->index);
-	mutex_unlock(&zr->resource_lock);
 
 	return res;
 }
@@ -2065,8 +2021,6 @@ static int zoran_qbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 	struct zoran *zr = fh->zr;
 	int res = 0, codec_mode, buf_type;
 
-	mutex_lock(&zr->resource_lock);
-
 	switch (fh->map_mode) {
 	case ZORAN_MAP_MODE_RAW:
 		if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
@@ -2074,12 +2028,12 @@ static int zoran_qbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 				"%s: VIDIOC_QBUF - invalid buf->type=%d for map_mode=%d\n",
 				ZR_DEVNAME(zr), buf->type, fh->map_mode);
 			res = -EINVAL;
-			goto qbuf_unlock_and_return;
+			return res;
 		}
 
 		res = zoran_v4l_queue_frame(fh, buf->index);
 		if (res)
-			goto qbuf_unlock_and_return;
+			return res;
 		if (!zr->v4l_memgrab_active && fh->buffers.active == ZORAN_LOCKED)
 			zr36057_set_memgrab(zr, 1);
 		break;
@@ -2099,12 +2053,12 @@ static int zoran_qbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 				"%s: VIDIOC_QBUF - invalid buf->type=%d for map_mode=%d\n",
 				ZR_DEVNAME(zr), buf->type, fh->map_mode);
 			res = -EINVAL;
-			goto qbuf_unlock_and_return;
+			return res;
 		}
 
 		res = zoran_jpg_queue_frame(fh, buf->index, codec_mode);
 		if (res != 0)
-			goto qbuf_unlock_and_return;
+			return res;
 		if (zr->codec_mode == BUZ_MODE_IDLE &&
 		    fh->buffers.active == ZORAN_LOCKED)
 			zr36057_enable_jpg(zr, codec_mode);
@@ -2118,9 +2072,6 @@ static int zoran_qbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 		res = -EINVAL;
 		break;
 	}
-qbuf_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -2130,8 +2081,6 @@ static int zoran_dqbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 	struct zoran *zr = fh->zr;
 	int res = 0, buf_type, num = -1;	/* compiler borks here (?) */
 
-	mutex_lock(&zr->resource_lock);
-
 	switch (fh->map_mode) {
 	case ZORAN_MAP_MODE_RAW:
 		if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
@@ -2139,18 +2088,18 @@ static int zoran_dqbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 				"%s: VIDIOC_QBUF - invalid buf->type=%d for map_mode=%d\n",
 				ZR_DEVNAME(zr), buf->type, fh->map_mode);
 			res = -EINVAL;
-			goto dqbuf_unlock_and_return;
+			return res;
 		}
 
 		num = zr->v4l_pend[zr->v4l_sync_tail & V4L_MASK_FRAME];
 		if (file->f_flags & O_NONBLOCK &&
 		    zr->v4l_buffers.buffer[num].state != BUZ_STATE_DONE) {
 			res = -EAGAIN;
-			goto dqbuf_unlock_and_return;
+			return res;
 		}
 		res = v4l_sync(fh, num);
 		if (res)
-			goto dqbuf_unlock_and_return;
+			return res;
 		zr->v4l_sync_tail++;
 		res = zoran_v4l2_buffer_status(fh, buf, num);
 		break;
@@ -2170,7 +2119,7 @@ static int zoran_dqbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 				"%s: VIDIOC_QBUF - invalid buf->type=%d for map_mode=%d\n",
 				ZR_DEVNAME(zr), buf->type, fh->map_mode);
 			res = -EINVAL;
-			goto dqbuf_unlock_and_return;
+			return res;
 		}
 
 		num = zr->jpg_pend[zr->jpg_que_tail & BUZ_MASK_FRAME];
@@ -2178,12 +2127,12 @@ static int zoran_dqbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 		if (file->f_flags & O_NONBLOCK &&
 		    zr->jpg_buffers.buffer[num].state != BUZ_STATE_DONE) {
 			res = -EAGAIN;
-			goto dqbuf_unlock_and_return;
+			return res;
 		}
 		bs.frame = 0; /* suppress compiler warning */
 		res = jpg_sync(fh, &bs);
 		if (res)
-			goto dqbuf_unlock_and_return;
+			return res;
 		res = zoran_v4l2_buffer_status(fh, buf, bs.frame);
 		break;
 	}
@@ -2195,9 +2144,6 @@ static int zoran_dqbuf(struct file *file, void *__fh, struct v4l2_buffer *buf)
 		res = -EINVAL;
 		break;
 	}
-dqbuf_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -2207,14 +2153,12 @@ static int zoran_streamon(struct file *file, void *__fh, enum v4l2_buf_type type
 	struct zoran *zr = fh->zr;
 	int res = 0;
 
-	mutex_lock(&zr->resource_lock);
-
 	switch (fh->map_mode) {
 	case ZORAN_MAP_MODE_RAW:	/* raw capture */
 		if (zr->v4l_buffers.active != ZORAN_ACTIVE ||
 		    fh->buffers.active != ZORAN_ACTIVE) {
 			res = -EBUSY;
-			goto strmon_unlock_and_return;
+			return res;
 		}
 
 		zr->v4l_buffers.active = fh->buffers.active = ZORAN_LOCKED;
@@ -2233,7 +2177,7 @@ static int zoran_streamon(struct file *file, void *__fh, enum v4l2_buf_type type
 		if (zr->jpg_buffers.active != ZORAN_ACTIVE ||
 		    fh->buffers.active != ZORAN_ACTIVE) {
 			res = -EBUSY;
-			goto strmon_unlock_and_return;
+			return res;
 		}
 
 		zr->jpg_buffers.active = fh->buffers.active = ZORAN_LOCKED;
@@ -2252,9 +2196,6 @@ static int zoran_streamon(struct file *file, void *__fh, enum v4l2_buf_type type
 		res = -EINVAL;
 		break;
 	}
-strmon_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -2265,17 +2206,15 @@ static int zoran_streamoff(struct file *file, void *__fh, enum v4l2_buf_type typ
 	int i, res = 0;
 	unsigned long flags;
 
-	mutex_lock(&zr->resource_lock);
-
 	switch (fh->map_mode) {
 	case ZORAN_MAP_MODE_RAW:	/* raw capture */
 		if (fh->buffers.active == ZORAN_FREE &&
 		    zr->v4l_buffers.active != ZORAN_FREE) {
 			res = -EPERM;	/* stay off other's settings! */
-			goto strmoff_unlock_and_return;
+			return res;
 		}
 		if (zr->v4l_buffers.active == ZORAN_FREE)
-			goto strmoff_unlock_and_return;
+			return res;
 
 		spin_lock_irqsave(&zr->spinlock, flags);
 		/* unload capture */
@@ -2303,17 +2242,17 @@ static int zoran_streamoff(struct file *file, void *__fh, enum v4l2_buf_type typ
 		if (fh->buffers.active == ZORAN_FREE &&
 		    zr->jpg_buffers.active != ZORAN_FREE) {
 			res = -EPERM;	/* stay off other's settings! */
-			goto strmoff_unlock_and_return;
+			return res;
 		}
 		if (zr->jpg_buffers.active == ZORAN_FREE)
-			goto strmoff_unlock_and_return;
+			return res;
 
 		res = jpg_qbuf(fh, -1,
 			     (fh->map_mode == ZORAN_MAP_MODE_JPG_REC) ?
 			     BUZ_MODE_MOTION_COMPRESS :
 			     BUZ_MODE_MOTION_DECOMPRESS);
 		if (res)
-			goto strmoff_unlock_and_return;
+			return res;
 		break;
 	default:
 		dprintk(1, KERN_ERR
@@ -2322,9 +2261,6 @@ static int zoran_streamoff(struct file *file, void *__fh, enum v4l2_buf_type typ
 		res = -EINVAL;
 		break;
 	}
-strmoff_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -2354,9 +2290,7 @@ static int zoran_g_ctrl(struct file *file, void *__fh, struct v4l2_control *ctrl
 	    ctrl->id > V4L2_CID_HUE)
 		return -EINVAL;
 
-	mutex_lock(&zr->resource_lock);
 	decoder_call(zr, core, g_ctrl, ctrl);
-	mutex_unlock(&zr->resource_lock);
 
 	return 0;
 }
@@ -2371,9 +2305,7 @@ static int zoran_s_ctrl(struct file *file, void *__fh, struct v4l2_control *ctrl
 	    ctrl->id > V4L2_CID_HUE)
 		return -EINVAL;
 
-	mutex_lock(&zr->resource_lock);
 	decoder_call(zr, core, s_ctrl, ctrl);
-	mutex_unlock(&zr->resource_lock);
 
 	return 0;
 }
@@ -2383,9 +2315,7 @@ static int zoran_g_std(struct file *file, void *__fh, v4l2_std_id *std)
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	mutex_lock(&zr->resource_lock);
 	*std = zr->norm;
-	mutex_unlock(&zr->resource_lock);
 	return 0;
 }
 
@@ -2395,14 +2325,11 @@ static int zoran_s_std(struct file *file, void *__fh, v4l2_std_id std)
 	struct zoran *zr = fh->zr;
 	int res = 0;
 
-	mutex_lock(&zr->resource_lock);
 	res = zoran_set_norm(zr, std);
 	if (res)
-		goto sstd_unlock_and_return;
+		return res;
 
 	res = wait_grab_pending(zr);
-sstd_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -2421,9 +2348,7 @@ static int zoran_enum_input(struct file *file, void *__fh,
 	inp->std = V4L2_STD_ALL;
 
 	/* Get status of video decoder */
-	mutex_lock(&zr->resource_lock);
 	decoder_call(zr, video, g_input_status, &inp->status);
-	mutex_unlock(&zr->resource_lock);
 	return 0;
 }
 
@@ -2432,9 +2357,7 @@ static int zoran_g_input(struct file *file, void *__fh, unsigned int *input)
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	mutex_lock(&zr->resource_lock);
 	*input = zr->input;
-	mutex_unlock(&zr->resource_lock);
 
 	return 0;
 }
@@ -2445,15 +2368,12 @@ static int zoran_s_input(struct file *file, void *__fh, unsigned int input)
 	struct zoran *zr = fh->zr;
 	int res;
 
-	mutex_lock(&zr->resource_lock);
 	res = zoran_set_input(zr, input);
 	if (res)
-		goto sinput_unlock_and_return;
+		return res;
 
 	/* Make sure the changes come into effect */
 	res = wait_grab_pending(zr);
-sinput_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -2496,8 +2416,6 @@ static int zoran_cropcap(struct file *file, void *__fh,
 	memset(cropcap, 0, sizeof(*cropcap));
 	cropcap->type = type;
 
-	mutex_lock(&zr->resource_lock);
-
 	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 	    (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
 	     fh->map_mode == ZORAN_MAP_MODE_RAW)) {
@@ -2505,7 +2423,7 @@ static int zoran_cropcap(struct file *file, void *__fh,
 			"%s: VIDIOC_CROPCAP - subcapture only supported for compressed capture\n",
 			ZR_DEVNAME(zr));
 		res = -EINVAL;
-		goto cropcap_unlock_and_return;
+		return res;
 	}
 
 	cropcap->bounds.top = cropcap->bounds.left = 0;
@@ -2514,8 +2432,6 @@ static int zoran_cropcap(struct file *file, void *__fh,
 	cropcap->defrect.top = cropcap->defrect.left = 0;
 	cropcap->defrect.width = BUZ_MIN_WIDTH;
 	cropcap->defrect.height = BUZ_MIN_HEIGHT;
-cropcap_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -2528,8 +2444,6 @@ static int zoran_g_crop(struct file *file, void *__fh, struct v4l2_crop *crop)
 	memset(crop, 0, sizeof(*crop));
 	crop->type = type;
 
-	mutex_lock(&zr->resource_lock);
-
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 	    (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
 	     fh->map_mode == ZORAN_MAP_MODE_RAW)) {
@@ -2538,17 +2452,13 @@ static int zoran_g_crop(struct file *file, void *__fh, struct v4l2_crop *crop)
 			"%s: VIDIOC_G_CROP - subcapture only supported for compressed capture\n",
 			ZR_DEVNAME(zr));
 		res = -EINVAL;
-		goto gcrop_unlock_and_return;
+		return res;
 	}
 
 	crop->c.top = fh->jpg_settings.img_y;
 	crop->c.left = fh->jpg_settings.img_x;
 	crop->c.width = fh->jpg_settings.img_width;
 	crop->c.height = fh->jpg_settings.img_height;
-
-gcrop_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -2561,14 +2471,12 @@ static int zoran_s_crop(struct file *file, void *__fh, const struct v4l2_crop *c
 
 	settings = fh->jpg_settings;
 
-	mutex_lock(&zr->resource_lock);
-
 	if (fh->buffers.allocated) {
 		dprintk(1, KERN_ERR
 			"%s: VIDIOC_S_CROP - cannot change settings while active\n",
 			ZR_DEVNAME(zr));
 		res = -EBUSY;
-		goto scrop_unlock_and_return;
+		return res;
 	}
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
@@ -2578,7 +2486,7 @@ static int zoran_s_crop(struct file *file, void *__fh, const struct v4l2_crop *c
 			"%s: VIDIOC_G_CROP - subcapture only supported for compressed capture\n",
 			ZR_DEVNAME(zr));
 		res = -EINVAL;
-		goto scrop_unlock_and_return;
+		return res;
 	}
 
 	/* move into a form that we understand */
@@ -2590,13 +2498,10 @@ static int zoran_s_crop(struct file *file, void *__fh, const struct v4l2_crop *c
 	/* check validity */
 	res = zoran_check_jpg_settings(zr, &settings, 0);
 	if (res)
-		goto scrop_unlock_and_return;
+		return res;
 
 	/* accept */
 	fh->jpg_settings = settings;
-
-scrop_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
 	return res;
 }
 
@@ -2604,11 +2509,8 @@ static int zoran_g_jpegcomp(struct file *file, void *__fh,
 					struct v4l2_jpegcompression *params)
 {
 	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
 	memset(params, 0, sizeof(*params));
 
-	mutex_lock(&zr->resource_lock);
-
 	params->quality = fh->jpg_settings.jpg_comp.quality;
 	params->APPn = fh->jpg_settings.jpg_comp.APPn;
 	memcpy(params->APP_data,
@@ -2622,8 +2524,6 @@ static int zoran_g_jpegcomp(struct file *file, void *__fh,
 	params->jpeg_markers =
 	    fh->jpg_settings.jpg_comp.jpeg_markers;
 
-	mutex_unlock(&zr->resource_lock);
-
 	return 0;
 }
 
@@ -2639,26 +2539,21 @@ static int zoran_s_jpegcomp(struct file *file, void *__fh,
 
 	settings.jpg_comp = *params;
 
-	mutex_lock(&zr->resource_lock);
-
 	if (fh->buffers.active != ZORAN_FREE) {
 		dprintk(1, KERN_WARNING
 			"%s: VIDIOC_S_JPEGCOMP called while in playback/capture mode\n",
 			ZR_DEVNAME(zr));
 		res = -EBUSY;
-		goto sjpegc_unlock_and_return;
+		return res;
 	}
 
 	res = zoran_check_jpg_settings(zr, &settings, 0);
 	if (res)
-		goto sjpegc_unlock_and_return;
+		return res;
 	if (!fh->buffers.allocated)
 		fh->buffers.buffer_size =
 			zoran_v4l2_calc_bufsize(&fh->jpg_settings);
 	fh->jpg_settings.jpg_comp = settings.jpg_comp;
-sjpegc_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -2679,8 +2574,6 @@ zoran_poll (struct file *file,
 	 * if no buffers queued or so, return POLLNVAL
 	 */
 
-	mutex_lock(&zr->resource_lock);
-
 	switch (fh->map_mode) {
 	case ZORAN_MAP_MODE_RAW:
 		poll_wait(file, &zr->v4l_capq, wait);
@@ -2735,8 +2628,6 @@ zoran_poll (struct file *file,
 		res = POLLNVAL;
 	}
 
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -2768,9 +2659,6 @@ zoran_vm_close (struct vm_area_struct *vma)
 	struct zoran *zr = fh->zr;
 	int i;
 
-	if (!atomic_dec_and_mutex_lock(&map->count, &zr->resource_lock))
-		return;
-
 	dprintk(3, KERN_INFO "%s: %s - munmap(%s)\n", ZR_DEVNAME(zr),
 		__func__, mode_name(fh->map_mode));
 
@@ -2783,7 +2671,6 @@ zoran_vm_close (struct vm_area_struct *vma)
 	/* Any buffers still mapped? */
 	for (i = 0; i < fh->buffers.num_buffers; i++) {
 		if (fh->buffers.buffer[i].map) {
-			mutex_unlock(&zr->resource_lock);
 			return;
 		}
 	}
@@ -2791,7 +2678,6 @@ zoran_vm_close (struct vm_area_struct *vma)
 	dprintk(3, KERN_INFO "%s: %s - free %s buffers\n", ZR_DEVNAME(zr),
 		__func__, mode_name(fh->map_mode));
 
-
 	if (fh->map_mode == ZORAN_MAP_MODE_RAW) {
 		if (fh->buffers.active != ZORAN_FREE) {
 			unsigned long flags;
@@ -2811,8 +2697,6 @@ zoran_vm_close (struct vm_area_struct *vma)
 		}
 		jpg_fbuffer_free(fh);
 	}
-
-	mutex_unlock(&zr->resource_lock);
 }
 
 static const struct vm_operations_struct zoran_vm_ops = {
@@ -2848,15 +2732,13 @@ zoran_mmap (struct file           *file,
 		return -EINVAL;
 	}
 
-	mutex_lock(&zr->resource_lock);
-
 	if (!fh->buffers.allocated) {
 		dprintk(1,
 			KERN_ERR
 			"%s: %s(%s) - buffers not yet allocated\n",
 			ZR_DEVNAME(zr), __func__, mode_name(fh->map_mode));
 		res = -ENOMEM;
-		goto mmap_unlock_and_return;
+		return res;
 	}
 
 	first = offset / fh->buffers.buffer_size;
@@ -2872,7 +2754,7 @@ zoran_mmap (struct file           *file,
 			fh->buffers.buffer_size,
 			fh->buffers.num_buffers);
 		res = -EINVAL;
-		goto mmap_unlock_and_return;
+		return res;
 	}
 
 	/* Check if any buffers are already mapped */
@@ -2883,7 +2765,7 @@ zoran_mmap (struct file           *file,
 				"%s: %s(%s) - buffer %d already mapped\n",
 				ZR_DEVNAME(zr), __func__, mode_name(fh->map_mode), i);
 			res = -EBUSY;
-			goto mmap_unlock_and_return;
+			return res;
 		}
 	}
 
@@ -2891,7 +2773,7 @@ zoran_mmap (struct file           *file,
 	map = kmalloc(sizeof(struct zoran_mapping), GFP_KERNEL);
 	if (!map) {
 		res = -ENOMEM;
-		goto mmap_unlock_and_return;
+		return res;
 	}
 	map->fh = fh;
 	atomic_set(&map->count, 1);
@@ -2913,7 +2795,7 @@ zoran_mmap (struct file           *file,
 					"%s: %s(V4L) - remap_pfn_range failed\n",
 					ZR_DEVNAME(zr), __func__);
 				res = -EAGAIN;
-				goto mmap_unlock_and_return;
+				return res;
 			}
 			size -= todo;
 			start += todo;
@@ -2945,7 +2827,7 @@ zoran_mmap (struct file           *file,
 						"%s: %s(V4L) - remap_pfn_range failed\n",
 						ZR_DEVNAME(zr), __func__);
 					res = -EAGAIN;
-					goto mmap_unlock_and_return;
+					return res;
 				}
 				size -= todo;
 				start += todo;
@@ -2961,10 +2843,6 @@ zoran_mmap (struct file           *file,
 
 		}
 	}
-
-mmap_unlock_and_return:
-	mutex_unlock(&zr->resource_lock);
-
 	return res;
 }
 
@@ -3009,26 +2887,11 @@ static const struct v4l2_ioctl_ops zoran_ioctl_ops = {
 	.vidioc_g_ctrl       		    = zoran_g_ctrl,
 };
 
-/* please use zr->resource_lock consistently and kill this wrapper */
-static long zoran_ioctl(struct file *file, unsigned int cmd,
-			unsigned long arg)
-{
-	struct zoran_fh *fh = file->private_data;
-	struct zoran *zr = fh->zr;
-	int ret;
-
-	mutex_lock(&zr->other_lock);
-	ret = video_ioctl2(file, cmd, arg);
-	mutex_unlock(&zr->other_lock);
-
-	return ret;
-}
-
 static const struct v4l2_file_operations zoran_fops = {
 	.owner = THIS_MODULE,
 	.open = zoran_open,
 	.release = zoran_close,
-	.unlocked_ioctl = zoran_ioctl,
+	.unlocked_ioctl = video_ioctl2,
 	.mmap = zoran_mmap,
 	.poll = zoran_poll,
 };
-- 
2.1.4

