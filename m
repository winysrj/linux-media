Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4CAC43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE872083D
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbfB1Mfu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 07:35:50 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49757 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731594AbfB1Mfu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 07:35:50 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zKuggBTbGLMwIzKuhgcTAM; Thu, 28 Feb 2019 13:35:47 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 2/2] vb2: drop VB2_BUF_STATE_REQUEUEING
Date:   Thu, 28 Feb 2019 13:35:46 +0100
Message-Id: <20190228123546.76270-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190228123546.76270-1-hverkuil-cisco@xs4all.nl>
References: <20190228123546.76270-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGDv3lcSAipOMnayQFgYMK638BjNGZdIQd+bZqjuP6AHmgsbUC3VOc9VrS5P5yDMoF2q/N2DOutNH3mN4VMPGA8spYfXmtg7hVr45lDuUipg8K7KU332
 YlpaY/kfvFMymu61xX1L6Sm8eRL/ScnJmYoFlSrOiroK49krdR1KxXcBSFWXSvHtvUAhimywX7NavCz6SI32hoxcRivdwIEhCkdo59a8h181w6aLyvF/Nc0b
 CwrpSj7VKXtDqLn7oxjDoy2LYY4c1wkqSd9IonEp4bEfU9grL2i1qG4eD0VUlWqo
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The last user of this state has been converted, so we can now drop
this. Requeueing causes the queue to become unordered, which causes
problems with requests and (in the future) fences.

Since it is no longer needed, just get rid of this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/common/videobuf2/videobuf2-core.c   | 15 +++----------
 .../media/common/videobuf2/videobuf2-v4l2.c   |  1 -
 include/media/videobuf2-core.h                | 21 ++++++-------------
 3 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 15b6b9c0a2e4..678a31a2b549 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -915,8 +915,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 
 	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
 		    state != VB2_BUF_STATE_ERROR &&
-		    state != VB2_BUF_STATE_QUEUED &&
-		    state != VB2_BUF_STATE_REQUEUEING))
+		    state != VB2_BUF_STATE_QUEUED))
 		state = VB2_BUF_STATE_ERROR;
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -929,8 +928,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->index, state);
 
-	if (state != VB2_BUF_STATE_QUEUED &&
-	    state != VB2_BUF_STATE_REQUEUEING) {
+	if (state != VB2_BUF_STATE_QUEUED) {
 		/* sync buffers */
 		for (plane = 0; plane < vb->num_planes; ++plane)
 			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
@@ -938,8 +936,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	}
 
 	spin_lock_irqsave(&q->done_lock, flags);
-	if (state == VB2_BUF_STATE_QUEUED ||
-	    state == VB2_BUF_STATE_REQUEUEING) {
+	if (state == VB2_BUF_STATE_QUEUED) {
 		vb->state = VB2_BUF_STATE_QUEUED;
 	} else {
 		/* Add the buffer to the done buffers list */
@@ -949,8 +946,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	atomic_dec(&q->owned_by_drv_count);
 
 	if (state != VB2_BUF_STATE_QUEUED && vb->req_obj.req) {
-		/* This is not supported at the moment */
-		WARN_ON(state == VB2_BUF_STATE_REQUEUEING);
 		media_request_object_unbind(&vb->req_obj);
 		media_request_object_put(&vb->req_obj);
 	}
@@ -962,10 +957,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	switch (state) {
 	case VB2_BUF_STATE_QUEUED:
 		return;
-	case VB2_BUF_STATE_REQUEUEING:
-		if (q->start_streaming_called)
-			__enqueue_in_driver(vb);
-		return;
 	default:
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index d09dee20e421..74d3abf33b50 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -543,7 +543,6 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 		break;
 	case VB2_BUF_STATE_PREPARING:
 	case VB2_BUF_STATE_DEQUEUED:
-	case VB2_BUF_STATE_REQUEUEING:
 		/* nothing */
 		break;
 	}
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a844abcae71e..0f8d2b5cf22b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -207,7 +207,6 @@ enum vb2_io_modes {
  * @VB2_BUF_STATE_IN_REQUEST:	buffer is queued in media request.
  * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf.
  * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver.
- * @VB2_BUF_STATE_REQUEUEING:	re-queue a buffer to the driver.
  * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
  *				in a hardware operation.
  * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
@@ -221,7 +220,6 @@ enum vb2_buffer_state {
 	VB2_BUF_STATE_IN_REQUEST,
 	VB2_BUF_STATE_PREPARING,
 	VB2_BUF_STATE_QUEUED,
-	VB2_BUF_STATE_REQUEUEING,
 	VB2_BUF_STATE_ACTIVE,
 	VB2_BUF_STATE_DONE,
 	VB2_BUF_STATE_ERROR,
@@ -384,10 +382,10 @@ struct vb2_buffer {
  *			driver can return an error if hardware fails, in that
  *			case all buffers that have been already given by
  *			the @buf_queue callback are to be returned by the driver
- *			by calling vb2_buffer_done() with %VB2_BUF_STATE_QUEUED
- *			or %VB2_BUF_STATE_REQUEUEING. If you need a minimum
- *			number of buffers before you can start streaming, then
- *			set &vb2_queue->min_buffers_needed. If that is non-zero
+ *			by calling vb2_buffer_done() with %VB2_BUF_STATE_QUEUED.
+ *			If you need a minimum number of buffers before you can
+ *			start streaming, then set
+ *			&vb2_queue->min_buffers_needed. If that is non-zero
  *			then @start_streaming won't be called until at least
  *			that many buffers have been queued up by userspace.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
@@ -648,9 +646,7 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
  * @state:	state of the buffer, as defined by &enum vb2_buffer_state.
  *		Either %VB2_BUF_STATE_DONE if the operation finished
  *		successfully, %VB2_BUF_STATE_ERROR if the operation finished
- *		with an error or any of %VB2_BUF_STATE_QUEUED or
- *		%VB2_BUF_STATE_REQUEUEING if the driver wants to
- *		requeue buffers (see below).
+ *		with an error or %VB2_BUF_STATE_QUEUED.
  *
  * This function should be called by the driver after a hardware operation on
  * a buffer is finished and the buffer may be returned to userspace. The driver
@@ -661,12 +657,7 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
  * While streaming a buffer can only be returned in state DONE or ERROR.
  * The &vb2_ops->start_streaming op can also return them in case the DMA engine
  * cannot be started for some reason. In that case the buffers should be
- * returned with state QUEUED or REQUEUEING to put them back into the queue.
- *
- * %VB2_BUF_STATE_REQUEUEING is like %VB2_BUF_STATE_QUEUED, but it also calls
- * &vb2_ops->buf_queue to queue buffers back to the driver. Note that calling
- * vb2_buffer_done(..., VB2_BUF_STATE_REQUEUEING) from interrupt context will
- * result in &vb2_ops->buf_queue being called in interrupt context as well.
+ * returned with state QUEUED to put them back into the queue.
  */
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 
-- 
2.20.1

