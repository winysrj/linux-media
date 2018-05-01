Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53371 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753874AbeEAJA5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 05:00:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv12 PATCH 26/29] vim2m: support requests
Date: Tue,  1 May 2018 11:00:48 +0200
Message-Id: <20180501090051.9321-27-hverkuil@xs4all.nl>
In-Reply-To: <20180501090051.9321-1-hverkuil@xs4all.nl>
References: <20180501090051.9321-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for requests to vim2m.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a1b0bb08668d..b6a20905beaf 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -387,8 +387,26 @@ static void device_run(void *priv)
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
+	/* Apply request controls if needed */
+	if (src_buf->vb2_buf.req_obj.req)
+		v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
+					&ctx->hdl);
+	if (dst_buf->vb2_buf.req_obj.req &&
+	    dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
+		v4l2_ctrl_request_setup(dst_buf->vb2_buf.req_obj.req,
+					&ctx->hdl);
+
 	device_process(ctx, src_buf, dst_buf);
 
+	/* Complete request controls if needed */
+	if (src_buf->vb2_buf.req_obj.req)
+		v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
+					&ctx->hdl);
+	if (dst_buf->vb2_buf.req_obj.req &&
+	    dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
+		v4l2_ctrl_request_complete(dst_buf->vb2_buf.req_obj.req,
+					&ctx->hdl);
+
 	/* Run a timer, which simulates a hardware irq  */
 	schedule_irq(dev, ctx->transtime);
 }
@@ -823,6 +841,8 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		if (vbuf == NULL)
 			return;
+		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
+					   &ctx->hdl);
 		spin_lock_irqsave(&ctx->dev->irqlock, flags);
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
@@ -1003,6 +1023,11 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= job_abort,
 };
 
+static const struct media_device_ops m2m_media_ops = {
+	.req_validate = vb2_request_validate,
+	.req_queue = vb2_m2m_request_queue,
+};
+
 static int vim2m_probe(struct platform_device *pdev)
 {
 	struct vim2m_dev *dev;
@@ -1027,6 +1052,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	dev->mdev.dev = &pdev->dev;
 	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
 	media_device_init(&dev->mdev);
+	dev->mdev.ops = &m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
 	dev->pad[0].flags = MEDIA_PAD_FL_SINK;
 	dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
-- 
2.17.0
