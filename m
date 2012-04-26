Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22178 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2DZNtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 09:49:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M330060NAFEFU30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Apr 2012 14:50:02 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M330090OAF3E5@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Apr 2012 14:49:52 +0100 (BST)
Date: Thu, 26 Apr 2012 15:49:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH FOR v3.4 2/2] s5p-fimc: Correct memory allocation for
 VIDIOC_CREATE_BUFS
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335448192-26725-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The commit 3b4c34aac7abea4754059084d0eef667a1993ac8
"s5p-fimc: Add support for VIDIOC_PREPARE_BUF/CREATE_BUFS ioctls"
added a handler for VIDIOC_CREATE_BUFS ioctl, but the queue_setup
callback wasn't updated to properly interpret the pixel format.
In this conditions memory corruption may happen with VIDIOC_CREATE_BUFS.
Update the queue_setup op to fix this.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   31 +++++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 ++--
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 02bbfd7..58a16db 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -248,28 +248,37 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 }
 
-static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
-{
-	if (!fr || plane >= fr->fmt->memplanes)
-		return 0;
-	return fr->f_width * fr->f_height * fr->fmt->depth[plane] / 8;
-}
-
-static int queue_setup(struct vb2_queue *vq,  const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
+	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_ctx *ctx = vq->drv_priv;
-	struct fimc_fmt *fmt = ctx->d_frame.fmt;
+	struct fimc_frame *frame = &ctx->d_frame;
+	struct fimc_fmt *fmt = frame->fmt;
+	unsigned long wh;
 	int i;
 
-	if (!fmt)
+	if (pfmt) {
+		pixm = &pfmt->fmt.pix_mp;
+		fmt = fimc_find_format(&pixm->pixelformat, NULL,
+				       FMT_FLAGS_CAM | FMT_FLAGS_M2M, -1);
+		wh = pixm->width * pixm->height;
+	} else {
+		wh = frame->f_width * frame->f_height;
+	}
+
+	if (fmt == NULL)
 		return -EINVAL;
 
 	*num_planes = fmt->memplanes;
 
 	for (i = 0; i < fmt->memplanes; i++) {
-		sizes[i] = get_plane_size(&ctx->d_frame, i);
+		unsigned int size = (wh * fmt->depth[i]) / 8;
+		if (pixm)
+			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		else
+			sizes[i] = size;
 		allocators[i] = ctx->fimc_dev->alloc_ctx;
 	}
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 7b90a89..38b0b3a 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1007,14 +1007,14 @@ static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
  * @mask: the color flags to match
  * @index: offset in the fimc_formats array, ignored if negative
  */
-struct fimc_fmt *fimc_find_format(u32 *pixelformat, u32 *mbus_code,
+struct fimc_fmt *fimc_find_format(const u32 *pixelformat, const u32 *mbus_code,
 				  unsigned int mask, int index)
 {
 	struct fimc_fmt *fmt, *def_fmt = NULL;
 	unsigned int i;
 	int id = 0;
 
-	if (index >= ARRAY_SIZE(fimc_formats))
+	if (index >= (int)ARRAY_SIZE(fimc_formats))
 		return NULL;
 
 	for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 193e8f6..7afabb0 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -710,7 +710,7 @@ void fimc_alpha_ctrl_update(struct fimc_ctx *ctx);
 int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f);
 void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 			       struct v4l2_pix_format_mplane *pix);
-struct fimc_fmt *fimc_find_format(u32 *pixelformat, u32 *mbus_code,
+struct fimc_fmt *fimc_find_format(const u32 *pixelformat, const u32 *mbus_code,
 				  unsigned int mask, int index);
 
 int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
-- 
1.7.10

