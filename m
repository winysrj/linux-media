Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64106 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab0LTRkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 12:40:10 -0500
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LDQ00DIZMETD3@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Dec 2010 17:40:05 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDQ0081VMETIS@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Dec 2010 17:40:05 +0000 (GMT)
Date: Mon, 20 Dec 2010 18:39:25 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] v4l: mem2mem_testdev: remove BKL usage
In-reply-to: <201012181231.27198.hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Message-id: <1292866765-21163-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <201012181231.27198.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Remove usage of BKL by usign per-device mutex.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/mem2mem_testdev.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 3b19f5b..c179041 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -524,7 +524,6 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 {
 	struct m2mtest_q_data *q_data;
 	struct videobuf_queue *vq;
-	int ret = 0;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 	if (!vq)
@@ -534,12 +533,9 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 	if (!q_data)
 		return -EINVAL;
 
-	mutex_lock(&vq->vb_lock);
-
 	if (videobuf_queue_is_busy(vq)) {
 		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
-		ret = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	q_data->fmt		= find_format(f);
@@ -553,9 +549,7 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
 		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
 
-out:
-	mutex_unlock(&vq->vb_lock);
-	return ret;
+	return 0;
 }
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
@@ -845,10 +839,12 @@ static void queue_init(void *priv, struct videobuf_queue *vq,
 		       enum v4l2_buf_type type)
 {
 	struct m2mtest_ctx *ctx = priv;
+	struct m2mtest_dev *dev = ctx->dev;
 
-	videobuf_queue_vmalloc_init(vq, &m2mtest_qops, ctx->dev->v4l2_dev.dev,
-				    &ctx->dev->irqlock, type, V4L2_FIELD_NONE,
-				    sizeof(struct m2mtest_buffer), priv, NULL);
+	videobuf_queue_vmalloc_init(vq, &m2mtest_qops, dev->v4l2_dev.dev,
+				    &dev->irqlock, type, V4L2_FIELD_NONE,
+				    sizeof(struct m2mtest_buffer), priv,
+				    &dev->dev_mutex);
 }
 
 
@@ -920,7 +916,7 @@ static const struct v4l2_file_operations m2mtest_fops = {
 	.open		= m2mtest_open,
 	.release	= m2mtest_release,
 	.poll		= m2mtest_poll,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.mmap		= m2mtest_mmap,
 };
 
@@ -965,6 +961,7 @@ static int m2mtest_probe(struct platform_device *pdev)
 	}
 
 	*vfd = m2mtest_videodev;
+	vfd->lock = &dev->dev_mutex;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
-- 
1.7.1.569.g6f426

