Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23671 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0CIOtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 09:49:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZ000I4DRUYK750@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Mar 2010 14:49:47 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZ000AKKRUXB7@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Mar 2010 14:49:46 +0000 (GMT)
Date: Tue, 09 Mar 2010 15:49:43 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v2 3/3] v4l: vivi: add 2- and 3-planar YCbCr422
In-reply-to: <1268146183-2018-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Message-id: <1268146183-2018-4-git-send-email-p.osciak@samsung.com>
References: <1268146183-2018-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add example 2- and 3- planar YCbCr422 formats for multi-plane
format testing.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/vivi.c |  179 +++++++++++++++++++++++++++++++++++---------
 include/linux/videodev2.h  |    3 +
 2 files changed, 147 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 37632a0..bc1ec0d 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -132,6 +132,9 @@ struct vivi_fmt {
 	char  *name;
 	u32   fourcc;          /* v4l2 format id */
 	int   depth;
+	unsigned int num_planes;
+	unsigned int plane_w_shr;
+	unsigned int plane_h_shr;
 };
 
 static struct vivi_fmt formats[] = {
@@ -139,31 +142,53 @@ static struct vivi_fmt formats[] = {
 		.name     = "4:2:2, packed, YUYV",
 		.fourcc   = V4L2_PIX_FMT_YUYV,
 		.depth    = 16,
+		.num_planes = 1,
 	},
 	{
 		.name     = "4:2:2, packed, UYVY",
 		.fourcc   = V4L2_PIX_FMT_UYVY,
 		.depth    = 16,
+		.num_planes = 1,
 	},
 	{
 		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
 		.depth    = 16,
+		.num_planes = 1,
 	},
 	{
 		.name     = "RGB565 (BE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
 		.depth    = 16,
+		.num_planes = 1,
 	},
 	{
 		.name     = "RGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
 		.depth    = 16,
+		.num_planes = 1,
 	},
 	{
 		.name     = "RGB555 (BE)",
 		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
 		.depth    = 16,
+		.num_planes = 1,
+	},
+	{
+		.name		= "YUV 4:2:2, 3-planar",
+		.fourcc		= V4L2_PIX_FMT_YUV422PM,
+		.depth		= 16,
+		.num_planes	= 3,
+		.plane_w_shr	= 1,
+		.plane_h_shr	= 0,
+	},
+	{
+		.name		= "YUV 4:2:2, 2-planar",
+		.fourcc		= V4L2_PIX_FMT_NV16M,
+		.depth		= 16,
+		.num_planes	= 2,
+		.plane_w_shr	= 1,
+		.plane_h_shr	= 0,
 	},
 };
 
@@ -361,6 +386,8 @@ static void precalculate_bars(struct vivi_fh *fh)
 		switch (fh->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
 		case V4L2_PIX_FMT_UYVY:
+		case V4L2_PIX_FMT_YUV422PM:
+		case V4L2_PIX_FMT_NV16M:
 			is_yuv = 1;
 			break;
 		case V4L2_PIX_FMT_RGB565:
@@ -410,6 +437,8 @@ static void gen_twopix(struct vivi_fh *fh, unsigned char *buf, int colorpos)
 
 		switch (fh->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
+		case V4L2_PIX_FMT_YUV422PM:
+		case V4L2_PIX_FMT_NV16M:
 			switch (color) {
 			case 0:
 			case 2:
@@ -558,30 +587,58 @@ end:
 static void vivi_fillbuff(struct vivi_fh *fh, struct vivi_buffer *buf)
 {
 	struct vivi_dev *dev = fh->dev;
-	int h , pos = 0;
+	int i, x, h, curr_plane = 0, pos = 0;
 	int hmax  = buf->vb.height;
 	int wmax  = buf->vb.width;
 	struct timeval ts;
-	char *tmpbuf;
-	void *vbuf = videobuf_to_vmalloc(&buf->vb);
+	char *tmpbuf, *p_tmpbuf;
+	char *vbuf[VIDEO_MAX_PLANES];
+
+	for (i = 0; i < fh->fmt->num_planes; ++i) {
+		vbuf[i] = videobuf_plane_to_vmalloc(&buf->vb, i);
+		if (!vbuf[i]) {
+			dprintk(dev, 1, "Failed acquiring vaddr for a plane\n");
+			return;
+		}
+	}
 
-	if (!vbuf)
-		return;
+	if (fh->fmt->num_planes > 1) {
+		tmpbuf = kmalloc(wmax * 2, GFP_ATOMIC);
+		if (!tmpbuf)
+			return;
+
+		for (h = 0; h < hmax; h++) {
+			gen_line(fh, tmpbuf, 0, wmax, hmax, h, dev->mv_count,
+				 dev->timestr);
+			p_tmpbuf = tmpbuf;
+
+			for (x = 0; x < wmax; ++x) {
+				*(vbuf[0]++) = *p_tmpbuf++;
+				*(vbuf[curr_plane + 1]++) = *p_tmpbuf++;
+				if (V4L2_PIX_FMT_YUV422PM == fh->fmt->fourcc)
+					curr_plane = !curr_plane;
+			}
+		}
 
-	tmpbuf = kmalloc(wmax * 2, GFP_ATOMIC);
-	if (!tmpbuf)
-		return;
+		dev->mv_count++;
 
-	for (h = 0; h < hmax; h++) {
-		gen_line(fh, tmpbuf, 0, wmax, hmax, h, dev->mv_count,
-			 dev->timestr);
-		memcpy(vbuf + pos, tmpbuf, wmax * 2);
-		pos += wmax*2;
-	}
+		kfree(tmpbuf);
+	} else {
+		tmpbuf = kmalloc(wmax * 2, GFP_ATOMIC);
+		if (!tmpbuf)
+			return;
+
+		for (h = 0; h < hmax; h++) {
+			gen_line(fh, tmpbuf, 0, wmax, hmax, h, dev->mv_count,
+				 dev->timestr);
+			memcpy(vbuf[0] + pos, tmpbuf, wmax * 2);
+			pos += wmax*2;
+		}
 
-	dev->mv_count++;
+		dev->mv_count++;
 
-	kfree(tmpbuf);
+		kfree(tmpbuf);
+	}
 
 	/* Updates stream time */
 
@@ -708,8 +765,6 @@ static int vivi_start_thread(struct vivi_fh *fh)
 	dma_q->frame = 0;
 	dma_q->ini_jiffies = jiffies;
 
-	dprintk(dev, 1, "%s\n", __func__);
-
 	dma_q->kthread = kthread_run(vivi_thread, fh, "vivi");
 
 	if (IS_ERR(dma_q->kthread)) {
@@ -719,7 +774,6 @@ static int vivi_start_thread(struct vivi_fh *fh)
 	/* Wakes thread */
 	wake_up_interruptible(&dma_q->wq);
 
-	dprintk(dev, 1, "returning from %s\n", __func__);
 	return 0;
 }
 
@@ -738,22 +792,66 @@ static void vivi_stop_thread(struct vivi_dmaqueue  *dma_q)
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
-static int
-buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
+static unsigned long get_plane_size(struct vivi_fh *fh, unsigned int plane)
 {
-	struct vivi_fh  *fh = vq->priv_data;
-	struct vivi_dev *dev  = fh->dev;
+	unsigned long plane_size = 0;
+
+	if (plane >= fh->fmt->num_planes)
+		return 0;
+
+	if (1 == fh->fmt->num_planes) {
+		plane_size = fh->width * fh->height * 2;
+	} else {
+		if (0 == plane) {
+			plane_size = fh->width * fh->height;
+		} else {
+			plane_size = (fh->width >> 1) * fh->height;
+			if (2 == fh->fmt->num_planes)
+				plane_size *= 2;
+		}
+	}
+
+	return plane_size;
+}
+static int buffer_negotiate(struct videobuf_queue *vq, unsigned int *buf_count,
+			    unsigned int *plane_count)
+{
+	struct vivi_fh *fh	= vq->priv_data;
+	struct vivi_dev *dev	= fh->dev;
+	unsigned int buf_size	= 0;
+	unsigned int i;
+
+	*plane_count = fh->fmt->num_planes;
+
+	if (0 == *buf_count)
+		*buf_count = 32;
+
+	for (i = 0; i < fh->fmt->num_planes; ++i)
+		buf_size += get_plane_size(fh, i);
+
+	while (buf_size * *buf_count > vid_limit * 1024 * 1024)
+		(*buf_count)--;
+
+	dprintk(dev, 1, "%s, buffer count=%d, plane count=%d\n",
+			__func__, *buf_count, *plane_count);
 
-	*size = fh->width*fh->height*2;
+	return 0;
+}
 
-	if (0 == *count)
-		*count = 32;
+static int buffer_setup_plane(struct videobuf_queue *vq, unsigned int plane,
+			      unsigned int *plane_size)
+{
+	struct vivi_fh *fh	= vq->priv_data;
+	struct vivi_dev *dev	= fh->dev;
 
-	while (*size * *count > vid_limit * 1024 * 1024)
-		(*count)--;
+	if (plane >= fh->fmt->num_planes) {
+		dprintk(dev, 1, "%s, invalid plane=%d\n", __func__, plane);
+		return -EINVAL;
+	}
 
-	dprintk(dev, 1, "%s, count=%d, size=%d\n", __func__,
-		*count, *size);
+	*plane_size = get_plane_size(fh, plane);
+	dprintk(dev, 1, "%s, plane=%d, size=%d\n",
+		__func__, plane, *plane_size);
 
 	return 0;
 }
@@ -783,6 +881,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	struct vivi_dev    *dev = fh->dev;
 	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
 	int rc;
+	unsigned int i;
 
 	dprintk(dev, 1, "%s, field=%d\n", __func__, field);
 
@@ -792,9 +891,17 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	    fh->height < 32 || fh->height > norm_maxh())
 		return -EINVAL;
 
-	buf->vb.size = fh->width*fh->height*2;
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
-		return -EINVAL;
+	for (i = 0; i < fh->fmt->num_planes; ++i) {
+		buf->vb.planes[i].size = get_plane_size(fh, i);
+
+		if (0 != buf->vb.planes[i].baddr
+		    && buf->vb.planes[i].bsize < buf->vb.planes[i].size) {
+			dprintk(dev, 1, "%s, invalid plane %u size: (%d<%lu)\n",
+				__func__, i, buf->vb.planes[i].bsize,
+				buf->vb.planes[i].size);
+			return -EINVAL;
+		}
+	}
 
 	/* These properties only change when queue is idle, see s_fmt */
 	buf->fmt       = fh->fmt;
@@ -846,7 +953,8 @@ static void buffer_release(struct videobuf_queue *vq,
 }
 
 static struct videobuf_queue_ops vivi_video_qops = {
-	.buf_setup      = buffer_setup,
+	.buf_negotiate  = buffer_negotiate,
+	.buf_setup_plane = buffer_setup_plane,
 	.buf_prepare    = buffer_prepare,
 	.buf_queue      = buffer_queue,
 	.buf_release    = buffer_release,
@@ -948,8 +1056,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vivi_fh *fh = priv;
 	struct videobuf_queue *q = &fh->vb_vidq;
+	int ret;
 
-	int ret = vidioc_try_fmt_vid_cap(file, fh, f);
+	ret = vidioc_try_fmt_vid_cap(file, fh, f);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index bf3f33d..fbce9d7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -314,6 +314,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_UYVY    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */
 #define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
 #define V4L2_PIX_FMT_YUV422P v4l2_fourcc('4', '2', '2', 'P') /* 16  YVU422 planar */
+#define V4L2_PIX_FMT_YUV422PM v4l2_fourcc('4', '2', '2', 'M') /* 16 YUV422 multiplane */
+
 #define V4L2_PIX_FMT_YUV411P v4l2_fourcc('4', '1', '1', 'P') /* 16  YVU411 planar */
 #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
 #define V4L2_PIX_FMT_YUV444  v4l2_fourcc('Y', '4', '4', '4') /* 16  xxxxyyyy uuuuvvvv */
@@ -329,6 +331,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
 #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2', '1') /* 12  Y/CrCb 4:2:0  */
 #define V4L2_PIX_FMT_NV16    v4l2_fourcc('N', 'V', '1', '6') /* 16  Y/CbCr 4:2:2  */
+#define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/CbCr multiplane 4:2:2 */
 #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
 
 /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
-- 
1.7.0.31.g1df487

