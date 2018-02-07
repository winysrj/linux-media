Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44696 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753344AbeBGBtU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 20:49:20 -0500
Received: by mail-pg0-f65.google.com with SMTP id r1so1872902pgn.11
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 17:49:20 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv3 17/17] media: vim2m: add request support
Date: Wed,  7 Feb 2018 10:48:21 +0900
Message-Id: <20180207014821.164536-18-acourbot@chromium.org>
In-Reply-To: <20180207014821.164536-1-acourbot@chromium.org>
References: <20180207014821.164536-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the necessary ops for supporting requests in vim2m.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vim2m.c | 55 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e0eb60310717..96dba60d3c74 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -30,6 +30,9 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
+#include <media/media-request.h>
+#include <media/media-request-mgr.h>
+#include <media/v4l2-request.h>
 
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
@@ -370,6 +373,28 @@ static void job_abort(void *priv)
 	ctx->aborting = 1;
 }
 
+static int apply_request_params(struct media_request *req,
+				 struct vim2m_ctx *ctx)
+{
+	struct media_request_entity_data *_data;
+	struct media_request_v4l2_entity_data *data;
+
+	if (!req)
+		return -EINVAL;
+
+	_data = media_request_get_entity_data(req, &ctx->dev->vfd.entity,
+					      &ctx->fh);
+	if (WARN_ON(!_data))
+		return -EINVAL;
+	data = container_of(_data, struct media_request_v4l2_entity_data, base);
+
+	v4l2_ctrl_request_setup(&data->ctrls);
+
+	data->base.applied = true;
+
+	return 0;
+}
+
 /* device_run() - prepares and starts the device
  *
  * This simulates all the immediate preparations required before starting
@@ -381,12 +406,22 @@ static void device_run(void *priv)
 	struct vim2m_ctx *ctx = priv;
 	struct vim2m_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *src_buf, *dst_buf;
+	int ret;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
+	WARN_ON(dst_buf->vb2_buf.request != NULL);
+
+	/* Apply request if needed */
+	ret = apply_request_params(src_buf->vb2_buf.request, ctx);
+	WARN_ON(ret);
+
 	device_process(ctx, src_buf, dst_buf);
 
+	/* Inform user about which request produced the destination buffer */
+	dst_buf->request_fd = src_buf->request_fd;
+
 	/* Run a timer, which simulates a hardware irq  */
 	schedule_irq(dev, ctx->transtime);
 }
@@ -841,6 +876,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
+	src_vq->allow_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -992,6 +1028,19 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= job_abort,
 };
 
+struct media_request_entity_data *vim2m_entity_data_alloc(struct media_entity *entity,
+							  void *fh)
+{
+	struct vim2m_ctx *ctx = container_of(fh, struct vim2m_ctx, fh);
+
+	return media_request_v4l2_entity_data_alloc(&ctx->hdl);
+}
+
+static const struct media_entity_request_ops vim2m_entity_req_ops = {
+	.data_alloc	= vim2m_entity_data_alloc,
+	.data_free	= media_request_v4l2_entity_data_free,
+};
+
 static int vim2m_probe(struct platform_device *pdev)
 {
 	struct vim2m_dev *dev;
@@ -1006,6 +1055,9 @@ static int vim2m_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
+	dev->mdev.req_mgr = media_request_mgr_alloc(&dev->mdev);
+	if (IS_ERR(dev->mdev.req_mgr))
+		return PTR_ERR(dev->mdev.req_mgr);
 	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
 	media_device_init(&dev->mdev);
 	dev->v4l2_dev.mdev = &dev->mdev;
@@ -1030,6 +1082,9 @@ static int vim2m_probe(struct platform_device *pdev)
 	}
 
 	video_set_drvdata(vfd, dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->vfd.entity.req_ops = &vim2m_entity_req_ops;
+#endif
 	snprintf(vfd->name, sizeof(vfd->name), "%s", vim2m_videodev.name);
 	v4l2_info(&dev->v4l2_dev,
 			"Device registered as /dev/video%d\n", vfd->num);
-- 
2.16.0.rc1.238.g530d649a79-goog
