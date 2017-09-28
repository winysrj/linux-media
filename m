Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:56845 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdI1JvK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:10 -0400
Received: by mail-pg0-f44.google.com with SMTP id 7so654423pgd.13
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:10 -0700 (PDT)
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
Subject: [RFC PATCH 3/9] [media] videobuf2: add support for jobs API
Date: Thu, 28 Sep 2017 18:50:21 +0900
Message-Id: <20170928095027.127173-4-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add generic support for jobs in videobuf2. When the jobs API is active,
the passing of buffers to the driver is delayed until their job is
submitted. Drivers need to call the vb2_queue_active_job_buffers()
function in order to receive the buffers corresponding to the active
job.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 33 ++++++++++++++++++++++++++++----
 include/media/videobuf2-core.h           | 16 ++++++++++++++++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 14f83cecfa92..2ac880ebe192 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -26,6 +26,7 @@
 
 #include <media/videobuf2-core.h>
 #include <media/v4l2-mc.h>
+#include <media/v4l2-job-state.h>
 
 #include <trace/events/vb2.h>
 
@@ -1304,6 +1305,22 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 }
 EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
 
+void vb2_queue_active_job_buffers(struct vb2_queue *q)
+{
+	const struct v4l2_job_state_handler *hdl = q->state_handler;
+	struct vb2_buffer *vb;
+
+	if (!q->start_streaming_called)
+		return;
+
+	list_for_each_entry(vb, &q->queued_list, queued_entry) {
+		if (!hdl || hdl->active_state == vb->job)
+			__enqueue_in_driver(vb);
+	}
+}
+EXPORT_SYMBOL_GPL(vb2_queue_active_job_buffers);
+
+
 /**
  * vb2_start_streaming() - Attempt to start streaming.
  * @q:		videobuf2 queue
@@ -1320,15 +1337,15 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	struct vb2_buffer *vb;
 	int ret;
 
+	q->start_streaming_called = 1;
+
 	/*
 	 * If any buffers were queued before streamon,
 	 * we can now pass them to driver for processing.
 	 */
-	list_for_each_entry(vb, &q->queued_list, queued_entry)
-		__enqueue_in_driver(vb);
+	vb2_queue_active_job_buffers(q);
 
 	/* Tell the driver to start streaming */
-	q->start_streaming_called = 1;
 	ret = call_qop(q, start_streaming, q,
 		       atomic_read(&q->owned_by_drv_count));
 	if (!ret)
@@ -1398,6 +1415,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	q->queued_count++;
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
+	vb->job = q->state_handler ? q->state_handler->current_state : NULL;
 
 	if (pb)
 		call_void_bufop(q, copy_timestamp, vb, pb);
@@ -1407,8 +1425,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	/*
 	 * If already streaming, give the buffer to driver for processing.
 	 * If not, the buffer will be given to driver on next streamon.
+	 *
+	 * If using the jobs API, we will give the buffer to the driver when
+	 * its job becomes active.
 	 */
-	if (q->start_streaming_called)
+	if (q->start_streaming_called && !vb->job)
 		__enqueue_in_driver(vb);
 
 	/* Fill buffer information for the userspace */
@@ -1422,6 +1443,8 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	 * then we can finally call start_streaming().
 	 */
 	if (q->streaming && !q->start_streaming_called &&
+	/* TODO potential issue: what if we have less than min_buffers_needed
+	 * in the next job? */
 	    q->queued_count >= q->min_buffers_needed) {
 		ret = vb2_start_streaming(q);
 		if (ret)
@@ -1728,6 +1751,8 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 	 * Tell driver to start streaming provided sufficient buffers
 	 * are available.
 	 */
+	/* TODO potential issue: what if we have less than min_buffers_needed
+	 * in the next job? */
 	if (q->queued_count >= q->min_buffers_needed) {
 		ret = v4l_vb2q_enable_media_source(q);
 		if (ret)
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cb97c224be73..9e172168e011 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -246,6 +246,7 @@ struct vb2_buffer {
 	unsigned int		num_planes;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 	u64			timestamp;
+	struct v4l2_job_state	*job;
 
 	/* private: internal use only
 	 *
@@ -506,6 +507,7 @@ struct vb2_queue {
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
 	const struct vb2_buf_ops	*buf_ops;
+	const struct v4l2_job_state_handler *state_handler;
 
 	void				*drv_priv;
 	unsigned int			buf_struct_size;
@@ -625,6 +627,20 @@ void vb2_discard_done(struct vb2_queue *q);
  */
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
+/**
+ * vb2_queue_active_job_buffers() - Pass all buffers for the active job to the
+ *                                  driver
+ *
+ * @q:		videobuf2 queue
+ *
+ * When using the jobs API, buffers are not passed to the driver until their
+ * job becomes active. Drivers using the jobs API are thus expected to call
+ * this function whenever a new job becomes active, so all buffers assigned
+ * to this job are passed to them.
+ */
+void vb2_queue_active_job_buffers(struct vb2_queue *q);
+
+
 /**
  * vb2_core_querybuf() - query video buffer information
  * @q:		videobuf queue
-- 
2.14.2.822.g60be5d43e6-goog
