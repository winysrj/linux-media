Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:45061 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754529AbdLOH5O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:57:14 -0500
Received: by mail-pf0-f195.google.com with SMTP id u19so5605951pfa.12
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:57:14 -0800 (PST)
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
Subject: [RFC PATCH 9/9] media: vim2m: add request support
Date: Fri, 15 Dec 2017 16:56:25 +0900
Message-Id: <20171215075625.27028-10-acourbot@chromium.org>
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the necessary ops for supporting requests in vim2m.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vim2m.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a32e8a7950eb..ffe94ef9214d 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -30,6 +30,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
+#include <media/media-request.h>
 
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
@@ -142,6 +143,7 @@ struct vim2m_dev {
 	struct video_device	vfd;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device	mdev;
+	struct media_request_queue *req_queue;
 #endif
 
 	atomic_t		num_inst;
@@ -937,6 +939,11 @@ static int vim2m_open(struct file *file)
 		goto open_unlock;
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	v4l2_mem_ctx_request_init(ctx->fh.m2m_ctx, dev->req_queue,
+				  &dev->vfd.entity);
+#endif
+
 	v4l2_fh_add(&ctx->fh);
 	atomic_inc(&dev->num_inst);
 
@@ -992,6 +999,12 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= job_abort,
 };
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static const struct media_entity_operations vim2m_entity_ops = {
+	.process_request = v4l2_m2m_process_request,
+};
+#endif
+
 static int vim2m_probe(struct platform_device *pdev)
 {
 	struct vim2m_dev *dev;
@@ -1006,6 +1019,10 @@ static int vim2m_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
+	dev->req_queue = media_request_queue_generic_alloc(&dev->mdev);
+	if (IS_ERR(dev->req_queue))
+		return PTR_ERR(dev->req_queue);
+	dev->mdev.req_queue = dev->req_queue;
 	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
 	media_device_init(&dev->mdev);
 	dev->v4l2_dev.mdev = &dev->mdev;
@@ -1023,6 +1040,11 @@ static int vim2m_probe(struct platform_device *pdev)
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	vfd->entity.ops = &vim2m_entity_ops;
+	vfd->entity.req_ops = &media_entity_request_generic_ops;
+#endif
+
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-- 
2.15.1.504.g5279b80103-goog
