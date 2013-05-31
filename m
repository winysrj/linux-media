Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46895 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3EaI1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 04:27:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH v2] [media] mem2mem: add support for hardware buffered queue
Date: Fri, 31 May 2013 10:27:36 +0200
Message-Id: <1369988856-26219-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On mem2mem decoders with a hardware bitstream ringbuffer, to drain the
buffer at the end of the stream, remaining frames might need to be decoded
from the bitstream buffer without additional input buffers being provided.
To achieve this, allow a queue to be marked as buffered by the driver, and
allow scheduling of device_runs when buffered ready queues are empty.

This also allows a driver to copy input buffers into their bitstream
ringbuffer and immediately mark them as done to be dequeued.

The motivation for this patch is hardware assisted h.264 reordering support
in the coda driver. For high profile streams, the coda can hold back
out-of-order frames, causing a few mem2mem device runs in the beginning, that
don't produce any decompressed buffer at the v4l2 capture side. At the same
time, the last few frames can be decoded from the bitstream with mem2mem device
runs that don't need a new input buffer at the v4l2 output side. The decoder
command ioctl can be used to put the decoder into the ringbuffer draining
end-of-stream mode.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Removed the streamoff changes. Now the patch only allows scheduling
   device_run with empty buffered queues. The driver needs to take care
   of additional requirements, such as bitstream buffer fill level, in
   job_ready.
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 18 ++++++++++++++++--
 include/media/v4l2-mem2mem.h           |  3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 66f599f..9377000 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -196,6 +196,10 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
  * 2) at least one destination buffer has to be queued,
  * 3) streaming has to be on.
  *
+ * If a queue is buffered (for example a decoder hardware ringbuffer that has
+ * to be drained before doing streamoff), allow scheduling without v4l2 buffers
+ * on that queue.
+ *
  * There may also be additional, custom requirements. In such case the driver
  * should supply a custom callback (job_ready in v4l2_m2m_ops) that should
  * return 1 if the instance is ready.
@@ -224,14 +228,16 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 	}
 
 	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
-	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
+	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)
+	    && !m2m_ctx->out_q_ctx.buffered) {
 		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No input buffers available\n");
 		return;
 	}
 	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
-	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
+	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)
+	    && !m2m_ctx->cap_q_ctx.buffered) {
 		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
 		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
@@ -626,6 +632,14 @@ err:
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
 
+void v4l2_m2m_queue_set_buffered(struct vb2_queue *vq, bool buffered)
+{
+	struct v4l2_m2m_queue_ctx *q_ctx = container_of(vq, struct v4l2_m2m_queue_ctx, q);
+
+	q_ctx->buffered = buffered;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_queue_set_buffered);
+
 /**
  * v4l2_m2m_ctx_release() - release m2m context
  *
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index d3eef01..40aaadc 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -60,6 +60,7 @@ struct v4l2_m2m_queue_ctx {
 	struct list_head	rdy_queue;
 	spinlock_t		rdy_spinlock;
 	u8			num_rdy;
+	bool			buffered;
 };
 
 struct v4l2_m2m_ctx {
@@ -132,6 +133,8 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		void *drv_priv,
 		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));
 
+void v4l2_m2m_queue_set_buffered(struct vb2_queue *vq);
+
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 
 void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
-- 
1.8.2.rc2

