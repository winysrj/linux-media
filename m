Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:58572 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbeCHM0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 07:26:52 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 2/3] media: vb2-core: document the REQUEUEING state
Date: Thu,  8 Mar 2018 13:26:21 +0100
Message-Id: <1520511982-985-2-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1520511982-985-1-git-send-email-luca@lucaceresoli.net>
References: <1520511982-985-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VB2_BUF_STATE_REQUEUEING is accepted by vb2_buffer_done() but not
documented, so add it along with notes about calls in interrupt
context.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>

---
Changes v1 -> v2: none.
---
 include/media/videobuf2-core.h | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f1a479060f9e..f20000887d3c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -358,12 +358,12 @@ struct vb2_buffer {
  *			driver can return an error if hardware fails, in that
  *			case all buffers that have been already given by
  *			the @buf_queue callback are to be returned by the driver
- *			by calling vb2_buffer_done() with %VB2_BUF_STATE_QUEUED.
- *			If you need a minimum number of buffers before you can
- *			start streaming, then set
- *			&vb2_queue->min_buffers_needed. If that is non-zero then
- *			@start_streaming won't be called until at least that
- *			many buffers have been queued up by userspace.
+ *			by calling vb2_buffer_done() with %VB2_BUF_STATE_QUEUED
+ *			or %VB2_BUF_STATE_REQUEUEING. If you need a minimum
+ *			number of buffers before you can start streaming, then
+ *			set &vb2_queue->min_buffers_needed. If that is non-zero
+ *			then @start_streaming won't be called until at least
+ *			that many buffers have been queued up by userspace.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
  *			finish and give back all buffers it got from &buf_queue
@@ -601,8 +601,9 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
  * @state:	state of the buffer, as defined by &enum vb2_buffer_state.
  *		Either %VB2_BUF_STATE_DONE if the operation finished
  *		successfully, %VB2_BUF_STATE_ERROR if the operation finished
- *		with an error or %VB2_BUF_STATE_QUEUED if the driver wants to
- *		requeue buffers.
+ *		with an error or any of %VB2_BUF_STATE_QUEUED or
+ *		%VB2_BUF_STATE_REQUEUEING if the driver wants to
+ *		requeue buffers (see below).
  *
  * This function should be called by the driver after a hardware operation on
  * a buffer is finished and the buffer may be returned to userspace. The driver
@@ -613,7 +614,12 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
  * While streaming a buffer can only be returned in state DONE or ERROR.
  * The &vb2_ops->start_streaming op can also return them in case the DMA engine
  * cannot be started for some reason. In that case the buffers should be
- * returned with state QUEUED to put them back into the queue.
+ * returned with state QUEUED or REQUEUEING to put them back into the queue.
+ *
+ * %VB2_BUF_STATE_REQUEUEING is like %VB2_BUF_STATE_QUEUED, but it also calls
+ * &vb2_ops->buf_queue to queue buffers back to the driver. Note that calling
+ * vb2_buffer_done(..., VB2_BUF_STATE_REQUEUEING) from interrupt context will
+ * result in &vb2_ops->buf_queue being called in interrupt context as well.
  */
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 
-- 
2.7.4
