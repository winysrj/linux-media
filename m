Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:21568 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbeEUIzW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:22 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 32/36] vim2m: support requests
Date: Mon, 21 May 2018 11:54:57 +0300
Message-Id: <20180521085501.16861-33-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for requests to vim2m.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a1b0bb08668d3..7c86c711a4cd4 100644
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
@@ -823,12 +841,21 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		if (vbuf == NULL)
 			return;
+		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
+					   &ctx->hdl);
 		spin_lock_irqsave(&ctx->dev->irqlock, flags);
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
 	}
 }
 
+static void vim2m_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
+}
+
 static const struct vb2_ops vim2m_qops = {
 	.queue_setup	 = vim2m_queue_setup,
 	.buf_prepare	 = vim2m_buf_prepare,
@@ -837,6 +864,7 @@ static const struct vb2_ops vim2m_qops = {
 	.stop_streaming  = vim2m_stop_streaming,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
+	.buf_request_complete = vim2m_buf_request_complete,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
@@ -1003,6 +1031,11 @@ static const struct v4l2_m2m_ops m2m_ops = {
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
@@ -1027,6 +1060,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	dev->mdev.dev = &pdev->dev;
 	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
 	media_device_init(&dev->mdev);
+	dev->mdev.ops = &m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
 	dev->pad[0].flags = MEDIA_PAD_FL_SINK;
 	dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
-- 
2.11.0
