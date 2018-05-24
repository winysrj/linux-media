Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56674 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033131AbeEXUhJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:37:09 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 11/20] dvb-core: Provide lock for vb2_queue
Date: Thu, 24 May 2018 17:35:11 -0300
Message-Id: <20180524203520.1598-12-ezequiel@collabora.com>
In-Reply-To: <20180524203520.1598-1-ezequiel@collabora.com>
References: <20180524203520.1598-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the vb2 context mutex to protect the vb2_queue.
This allows to replace the ad-hoc wait_{prepare, finish}
with vb2_ops_wait_{prepare, finish}.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/dvb-core/dvb_vb2.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index b811adf88afa..cd3ea44f0ae9 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -107,31 +107,14 @@ static void _stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&ctx->slock, flags);
 }
 
-static void _dmxdev_lock(struct vb2_queue *vq)
-{
-	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
-
-	mutex_lock(&ctx->mutex);
-	dprintk(3, "[%s]\n", ctx->name);
-}
-
-static void _dmxdev_unlock(struct vb2_queue *vq)
-{
-	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
-
-	if (mutex_is_locked(&ctx->mutex))
-		mutex_unlock(&ctx->mutex);
-	dprintk(3, "[%s]\n", ctx->name);
-}
-
 static const struct vb2_ops dvb_vb2_qops = {
 	.queue_setup		= _queue_setup,
 	.buf_prepare		= _buffer_prepare,
 	.buf_queue		= _buffer_queue,
 	.start_streaming	= _start_streaming,
 	.stop_streaming		= _stop_streaming,
-	.wait_prepare		= _dmxdev_unlock,
-	.wait_finish		= _dmxdev_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static void _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
@@ -183,6 +166,7 @@ int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int nonblocking)
 	q->mem_ops = &vb2_vmalloc_memops;
 	q->buf_ops = &dvb_vb2_buf_ops;
 	q->num_buffers = 0;
+	q->lock = &ctx->mutex;
 	ret = vb2_core_queue_init(q);
 	if (ret) {
 		ctx->state = DVB_VB2_STATE_NONE;
-- 
2.16.3
