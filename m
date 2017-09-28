Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:49933 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752749AbdI1JvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:22 -0400
Received: by mail-pg0-f45.google.com with SMTP id v13so93978pgq.6
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:22 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 7/9] [media] vim2m: add jobs API support
Date: Thu, 28 Sep 2017 18:50:25 +0900
Message-Id: <20170928095027.127173-8-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for jobs in vim2m, using the generic state handler.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/vim2m.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 970b9b6dab25..aff21d53d898 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -31,6 +31,8 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
+#include <media/v4l2-job-generic.h>
+
 MODULE_DESCRIPTION("Virtual device for mem2mem framework testing");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
@@ -155,6 +157,7 @@ struct vim2m_ctx {
 	struct vim2m_dev	*dev;
 
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_generic_state_handler state;
 
 	/* Processed buffers in this transaction */
 	u8			num_processed;
@@ -877,6 +880,15 @@ static const struct v4l2_ctrl_config vim2m_ctrl_trans_num_bufs = {
 	.step = 1,
 };
 
+static void vim2m_process_active_job(struct v4l2_job_state_handler *hdl)
+{
+	struct vim2m_ctx *ctx = container_of(hdl, struct vim2m_ctx, state.base);
+
+	vb2_queue_active_job_buffers(&ctx->fh.m2m_ctx->cap_q_ctx.q);
+	vb2_queue_active_job_buffers(&ctx->fh.m2m_ctx->out_q_ctx.q);
+	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
+}
+
 /*
  * File operations
  */
@@ -886,6 +898,7 @@ static int vim2m_open(struct file *file)
 	struct vim2m_ctx *ctx = NULL;
 	struct v4l2_ctrl_handler *hdl;
 	int rc = 0;
+	int ret;
 
 	if (mutex_lock_interruptible(&dev->dev_mutex))
 		return -ERESTARTSYS;
@@ -913,6 +926,15 @@ static int vim2m_open(struct file *file)
 	ctx->fh.ctrl_handler = hdl;
 	v4l2_ctrl_handler_setup(hdl);
 
+	ret = v4l2_job_generic_init(&ctx->state, vim2m_process_active_job,
+				    &ctx->fh, NULL);
+	if (ret) {
+		v4l2_ctrl_handler_free(hdl);
+		v4l2_fh_exit(&ctx->fh);
+		kfree(ctx);
+		goto open_unlock;
+	}
+
 	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
 	ctx->q_data[V4L2_M2M_SRC].width = 640;
 	ctx->q_data[V4L2_M2M_SRC].height = 480;
@@ -934,6 +956,8 @@ static int vim2m_open(struct file *file)
 		goto open_unlock;
 	}
 
+	v4l2_mem_ctx_job_init(ctx->fh.m2m_ctx, &ctx->state.base);
+
 	v4l2_fh_add(&ctx->fh);
 	atomic_inc(&dev->num_inst);
 
-- 
2.14.2.822.g60be5d43e6-goog
