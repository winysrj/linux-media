Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:43181 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbeAZGDE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 01:03:04 -0500
Received: by mail-pg0-f68.google.com with SMTP id n17so6611521pgf.10
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 22:03:04 -0800 (PST)
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
Subject: [RFC PATCH 8/8] media: vim2m: add request support
Date: Fri, 26 Jan 2018 15:02:16 +0900
Message-Id: <20180126060216.147918-9-acourbot@chromium.org>
In-Reply-To: <20180126060216.147918-1-acourbot@chromium.org>
References: <20180126060216.147918-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the necessary ops for supporting requests in vim2m.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vim2m.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a32e8a7950eb..1ddbad5eb569 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -30,6 +30,8 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
+#include <media/media-request.h>
+#include <media/media-request-mgr.h>
 
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
@@ -370,6 +372,24 @@ static void job_abort(void *priv)
 	ctx->aborting = 1;
 }
 
+static void apply_request_params(struct media_request *req,
+				 struct vim2m_ctx *ctx)
+{
+	struct media_request_entity_data *data;
+
+	if (!req)
+		return;
+
+	data = media_request_get_entity_data(req, &ctx->dev->vfd.entity,
+					     &ctx->fh);
+	if (WARN_ON(!data))
+		return;
+
+	/* apply controls here */
+
+	data->applied = true;
+}
+
 /* device_run() - prepares and starts the device
  *
  * This simulates all the immediate preparations required before starting
@@ -385,8 +405,15 @@ static void device_run(void *priv)
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
+	/* Apply request if needed */
+	apply_request_params(src_buf->vb2_buf.request, ctx);
+	WARN_ON(dst_buf->vb2_buf.request != NULL);
+
 	device_process(ctx, src_buf, dst_buf);
 
+	/* Inform user about which request produced the destination buffer */
+	dst_buf->request_fd = src_buf->request_fd;
+
 	/* Run a timer, which simulates a hardware irq  */
 	schedule_irq(dev, ctx->transtime);
 }
@@ -841,6 +868,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
+	src_vq->allow_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1006,6 +1034,9 @@ static int vim2m_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
+	dev->mdev.req_mgr = media_request_mgr_alloc(&dev->mdev);
+	if (IS_ERR(dev->mdev.req_mgr))
+		return PTR_ERR(dev->mdev.req_mgr);
 	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
 	media_device_init(&dev->mdev);
 	dev->v4l2_dev.mdev = &dev->mdev;
-- 
2.16.0.rc1.238.g530d649a79-goog
