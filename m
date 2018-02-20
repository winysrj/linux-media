Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34116 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbeBTEpf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:35 -0500
Received: by mail-pf0-f196.google.com with SMTP id g17so3017316pfh.1
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:35 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 19/21] media: vim2m: add request support
Date: Tue, 20 Feb 2018 13:44:23 +0900
Message-Id: <20180220044425.169493-20-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the necessary ops for supporting requests in vim2m.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/Kconfig |  1 +
 drivers/media/platform/vim2m.c | 75 ++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 614fbef08ddc..09be0b5f9afe 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -534,6 +534,7 @@ source "drivers/media/platform/vivid/Kconfig"
 config VIDEO_VIM2M
 	tristate "Virtual Memory-to-Memory Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
+	select MEDIA_REQUEST_API
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
 	default n
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 065483e62db4..02793dd9a330 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -30,6 +30,8 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
+#include <media/v4l2-request.h>
+#include <media/videobuf2-v4l2.h>
 
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
@@ -148,6 +150,8 @@ struct vim2m_dev {
 	struct timer_list	timer;
 
 	struct v4l2_m2m_dev	*m2m_dev;
+
+	struct v4l2_request_mgr req_mgr;
 };
 
 struct vim2m_ctx {
@@ -155,6 +159,7 @@ struct vim2m_ctx {
 	struct vim2m_dev	*dev;
 
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_request_entity req_entity;
 
 	/* Processed buffers in this transaction */
 	u8			num_processed;
@@ -367,6 +372,24 @@ static void job_abort(void *priv)
 	ctx->aborting = 1;
 }
 
+static int apply_request_params(struct media_request *req,
+				struct vim2m_ctx *ctx)
+{
+	struct v4l2_request_entity_data *data;
+
+	if (!req)
+		return -EINVAL;
+
+	data = to_v4l2_entity_data(media_request_get_entity_data(req,
+							&ctx->req_entity.base));
+	if (WARN_ON(IS_ERR(data)))
+		return PTR_ERR(data);
+
+	v4l2_ctrl_request_setup(&data->ctrls);
+
+	return 0;
+}
+
 /* device_run() - prepares and starts the device
  *
  * This simulates all the immediate preparations required before starting
@@ -382,6 +405,19 @@ static void device_run(void *priv)
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
+	WARN_ON(dst_buf->vb2_buf.request != NULL &&
+		dst_buf->vb2_buf.request != src_buf->vb2_buf.request);
+
+	/* Apply request if needed */
+	if (src_buf->vb2_buf.request) {
+		int ret = apply_request_params(src_buf->vb2_buf.request, ctx);
+		if (ret) {
+			dprintk(dev, "error applying request parameters: %d\n",
+				ret);
+			return;
+		}
+	}
+
 	device_process(ctx, src_buf, dst_buf);
 
 	/* Run a timer, which simulates a hardware irq  */
@@ -393,6 +429,7 @@ static void device_isr(struct timer_list *t)
 	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t, timer);
 	struct vim2m_ctx *curr_ctx;
 	struct vb2_v4l2_buffer *src_vb, *dst_vb;
+	struct media_request *req;
 	unsigned long flags;
 
 	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
@@ -404,6 +441,7 @@ static void device_isr(struct timer_list *t)
 
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
+	req = src_vb->vb2_buf.request;
 
 	curr_ctx->num_processed++;
 
@@ -411,6 +449,8 @@ static void device_isr(struct timer_list *t)
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
 	spin_unlock_irqrestore(&vim2m_dev->irqlock, flags);
+	if (req)
+		media_request_entity_complete(req, &curr_ctx->req_entity.base);
 
 	if (curr_ctx->num_processed == curr_ctx->translen
 	    || curr_ctx->aborting) {
@@ -838,6 +878,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
+	src_vq->allow_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -851,6 +892,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->dev_mutex;
+	dst_vq->allow_requests = true;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -877,6 +919,31 @@ static const struct v4l2_ctrl_config vim2m_ctrl_trans_num_bufs = {
 	.step = 1,
 };
 
+struct media_request_entity_data *
+vim2m_entity_data_alloc(struct media_request *req,
+			struct media_request_entity *entity)
+{
+	struct vim2m_ctx *ctx;
+
+	ctx = container_of(entity, struct vim2m_ctx, req_entity.base);
+	return v4l2_request_entity_data_alloc(req, &ctx->hdl);
+}
+
+static int vim2m_request_submit(struct media_request *req,
+				struct media_request_entity_data *_data)
+{
+	struct v4l2_request_entity_data *data;
+
+	data = to_v4l2_entity_data(_data);
+	return vb2_request_submit(data);
+}
+
+static const struct media_request_entity_ops vim2m_request_entity_ops = {
+	.data_alloc	= vim2m_entity_data_alloc,
+	.data_free	= v4l2_request_entity_data_free,
+	.submit		= vim2m_request_submit,
+};
+
 /*
  * File operations
  */
@@ -900,6 +967,9 @@ static int vim2m_open(struct file *file)
 	ctx->dev = dev;
 	hdl = &ctx->hdl;
 	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_request_entity_init(&ctx->req_entity, &vim2m_request_entity_ops,
+				 &ctx->dev->vfd);
+	ctx->fh.entity = &ctx->req_entity.base;
 	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
@@ -999,6 +1069,9 @@ static int vim2m_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
+	v4l2_request_mgr_init(&dev->req_mgr, &dev->vfd,
+			      &v4l2_request_ops);
+
 	spin_lock_init(&dev->irqlock);
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
@@ -1012,6 +1085,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	vfd = &dev->vfd;
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->req_mgr = &dev->req_mgr.base;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
@@ -1054,6 +1128,7 @@ static int vim2m_remove(struct platform_device *pdev)
 	del_timer_sync(&dev->timer);
 	video_unregister_device(&dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_request_mgr_free(&dev->req_mgr);
 
 	return 0;
 }
-- 
2.16.1.291.g4437f3f132-goog
