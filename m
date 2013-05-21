Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41186 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3EUIUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 04:20:14 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: enable dmabuf support
Date: Tue, 21 May 2013 10:20:11 +0200
Message-Id: <1369124411-19108-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 1cc4d64..16bef5e 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -570,6 +570,14 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
 }
 
+static int vidioc_expbuf(struct file *file, void *priv,
+			 struct v4l2_exportbuffer *eb)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
+}
+
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
@@ -618,6 +626,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_querybuf	= vidioc_querybuf,
 
 	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_expbuf		= vidioc_expbuf,
 	.vidioc_dqbuf		= vidioc_dqbuf,
 	.vidioc_create_bufs	= vidioc_create_bufs,
 
@@ -1432,7 +1441,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
 	src_vq->drv_priv = ctx;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &coda_qops;
@@ -1444,7 +1453,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
 	dst_vq->drv_priv = ctx;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &coda_qops;
-- 
1.8.2.rc2

