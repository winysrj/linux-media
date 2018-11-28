Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52892 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727828AbeK1Tin (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 14:38:43 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH for v4.20 3/5] vb2: keep a reference to the request until dqbuf
Date: Wed, 28 Nov 2018 09:37:45 +0100
Message-Id: <20181128083747.18530-4-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
References: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

When vb2_buffer_done is called the buffer is unbound from the
request and put. The media_request_object_put also 'put's the
request reference. If the application has already closed the
request fd, then that means that the request reference at that
point goes to 0 and the whole request is released.

This means that the control handler associated with the request is
also freed and that causes this kernel oops:

[174705.995401] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:908
[174705.995411] in_atomic(): 1, irqs_disabled(): 1, pid: 28071, name: vivid-000-vid-o
[174705.995416] 2 locks held by vivid-000-vid-o/28071:
[174705.995420]  #0: 000000001ea3a232 (&dev->mutex#3){....}, at: vivid_thread_vid_out+0x3f5/0x550 [vivid]
[174705.995447]  #1: 00000000e30a0d1e (&(&q->done_lock)->rlock){....}, at: vb2_buffer_done+0x92/0x1d0 [videobuf2_common]
[174705.995460] Preemption disabled at:
[174705.995461] [<0000000000000000>]           (null)
[174705.995472] CPU: 11 PID: 28071 Comm: vivid-000-vid-o Tainted: G        W         4.20.0-rc1-test-no #88
[174705.995476] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
[174705.995481] Call Trace:
[174705.995500]  dump_stack+0x46/0x60
[174705.995512]  ___might_sleep.cold.79+0xe1/0xf1
[174705.995523]  __mutex_lock+0x50/0x8f0
[174705.995531]  ? find_held_lock+0x2d/0x90
[174705.995536]  ? find_held_lock+0x2d/0x90
[174705.995542]  ? find_held_lock+0x2d/0x90
[174705.995564]  ? v4l2_ctrl_handler_free.part.13+0x44/0x1d0 [videodev]
[174705.995576]  v4l2_ctrl_handler_free.part.13+0x44/0x1d0 [videodev]
[174705.995590]  v4l2_ctrl_request_release+0x1c/0x30 [videodev]
[174705.995600]  media_request_clean+0x64/0xe0 [media]
[174705.995609]  media_request_release+0x19/0x40 [media]
[174705.995617]  vb2_buffer_done+0xef/0x1d0 [videobuf2_common]
[174705.995630]  vivid_thread_vid_out+0x2c1/0x550 [vivid]
[174705.995645]  ? vivid_stop_generating_vid_cap+0x1c0/0x1c0 [vivid]
[174705.995653]  kthread+0x113/0x130
[174705.995659]  ? kthread_park+0x80/0x80
[174705.995667]  ret_from_fork+0x35/0x40

The vb2_buffer_done function can be called from interrupt context, so
anything that sleeps is not allowed.

The solution is to increment the request refcount when the buffer is
queued and decrement it when the buffer is dequeued. Releasing the
request is fine if that happens from VIDIOC_DQBUF.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/common/videobuf2/videobuf2-core.c   | 38 ++++++++++++++++---
 include/media/videobuf2-core.h                |  2 +
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 77e2bfe5e722..86a12b335aac 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1360,8 +1360,12 @@ static void vb2_req_release(struct media_request_object *obj)
 {
 	struct vb2_buffer *vb = container_of(obj, struct vb2_buffer, req_obj);
 
-	if (vb->state == VB2_BUF_STATE_IN_REQUEST)
+	if (vb->state == VB2_BUF_STATE_IN_REQUEST) {
 		vb->state = VB2_BUF_STATE_DEQUEUED;
+		if (vb->request)
+			media_request_put(vb->request);
+		vb->request = NULL;
+	}
 }
 
 static const struct media_request_object_ops vb2_core_req_ops = {
@@ -1529,6 +1533,18 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 			return ret;
 
 		vb->state = VB2_BUF_STATE_IN_REQUEST;
+
+		/*
+		 * Increment the refcount and store the request.
+		 * The request refcount is decremented again when the
+		 * buffer is dequeued. This is to prevent vb2_buffer_done()
+		 * from freeing the request from interrupt context, which can
+		 * happen if the application closed the request fd after
+		 * queueing the request.
+		 */
+		media_request_get(req);
+		vb->request = req;
+
 		/* Fill buffer information for the userspace */
 		if (pb) {
 			call_void_bufop(q, copy_timestamp, vb, pb);
@@ -1750,10 +1766,6 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
 			vb->planes[i].dbuf_mapped = 0;
 		}
-	if (vb->req_obj.req) {
-		media_request_object_unbind(&vb->req_obj);
-		media_request_object_put(&vb->req_obj);
-	}
 	call_void_bufop(q, init_buffer, vb);
 }
 
@@ -1798,6 +1810,14 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
+	if (WARN_ON(vb->req_obj.req)) {
+		media_request_object_unbind(&vb->req_obj);
+		media_request_object_put(&vb->req_obj);
+	}
+	if (vb->request)
+		media_request_put(vb->request);
+	vb->request = NULL;
+
 	dprintk(2, "dqbuf of buffer %d, with state %d\n",
 			vb->index, vb->state);
 
@@ -1904,6 +1924,14 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 			vb->prepared = false;
 		}
 		__vb2_dqbuf(vb);
+
+		if (vb->req_obj.req) {
+			media_request_object_unbind(&vb->req_obj);
+			media_request_object_put(&vb->req_obj);
+		}
+		if (vb->request)
+			media_request_put(vb->request);
+		vb->request = NULL;
 	}
 }
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index e86981d615ae..4a737b2c610b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -239,6 +239,7 @@ struct vb2_queue;
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue.
  * @timestamp:		frame timestamp in ns.
+ * @request:		the request this buffer is associated with.
  * @req_obj:		used to bind this buffer to a request. This
  *			request object has a refcount.
  */
@@ -249,6 +250,7 @@ struct vb2_buffer {
 	unsigned int		memory;
 	unsigned int		num_planes;
 	u64			timestamp;
+	struct media_request	*request;
 	struct media_request_object	req_obj;
 
 	/* private: internal use only
-- 
2.19.1
