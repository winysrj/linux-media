Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51301 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbFYKBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 06:01:51 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] [media] videobuf2: add trace events
Date: Thu, 25 Jun 2015 12:01:27 +0200
Message-Id: <1435226487-24863-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add videobuf2 specific vb2_qbuf and vb2_dqbuf trace events that mirror the
v4l2_qbuf and v4l2_dqbuf trace events, only they include additional
information about queue fill state and are emitted right before the buffer
is enqueued in the driver or userspace is woken up. This allows to make
sense of the timeline of trace events in combination with others that might
be triggered by __enqueue_in_driver.

Also two new trace events vb2_buf_queue and vb2_buf_done are added,
allowing to trace the handover between videobuf2 framework and driver.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/v4l2-core/videobuf2-core.c | 11 ++++
 include/trace/events/v4l2.h              | 99 ++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 93b3154..b866a6b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -30,6 +30,8 @@
 #include <media/v4l2-common.h>
 #include <media/videobuf2-core.h>
 
+#include <trace/events/v4l2.h>
+
 static int debug;
 module_param(debug, int, 0644);
 
@@ -1207,6 +1209,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
+	trace_vb2_buf_done(q, vb);
+
 	if (state == VB2_BUF_STATE_QUEUED) {
 		if (q->start_streaming_called)
 			__enqueue_in_driver(vb);
@@ -1629,6 +1633,8 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->owned_by_drv_count);
 
+	trace_vb2_buf_queue(q, vb);
+
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
 		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
@@ -1878,6 +1884,8 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 			vb->v4l2_buf.timecode = b->timecode;
 	}
 
+	trace_vb2_qbuf(q, vb);
+
 	/*
 	 * If already streaming, give the buffer to driver for processing.
 	 * If not, the buffer will be given to driver on next streamon.
@@ -2123,6 +2131,9 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
 	q->queued_count--;
+
+	trace_vb2_dqbuf(q, vb);
+
 	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
 	    vb->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
 		q->last_buffer_dequeued = true;
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index 89d0497..3d15cf1 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -175,9 +175,108 @@ SHOW_FIELD
 		)							\
 	)
 
+#define VB2_TRACE_EVENT(event_name)					\
+	TRACE_EVENT(event_name,						\
+		TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),	\
+									\
+		TP_ARGS(q, vb),						\
+									\
+		TP_STRUCT__entry(					\
+			__field(int, minor)				\
+			__field(u32, queued_count)			\
+			__field(int, owned_by_drv_count)		\
+			__field(u32, index)				\
+			__field(u32, type)				\
+			__field(u32, bytesused)				\
+			__field(u32, flags)				\
+			__field(u32, field)				\
+			__field(s64, timestamp)				\
+			__field(u32, timecode_type)			\
+			__field(u32, timecode_flags)			\
+			__field(u8, timecode_frames)			\
+			__field(u8, timecode_seconds)			\
+			__field(u8, timecode_minutes)			\
+			__field(u8, timecode_hours)			\
+			__field(u8, timecode_userbits0)			\
+			__field(u8, timecode_userbits1)			\
+			__field(u8, timecode_userbits2)			\
+			__field(u8, timecode_userbits3)			\
+			__field(u32, sequence)				\
+		),							\
+									\
+		TP_fast_assign(						\
+			__entry->minor = q->owner ?			\
+				q->owner->vdev->minor : -1;		\
+			__entry->queued_count = q->queued_count;	\
+			__entry->owned_by_drv_count =			\
+				atomic_read(&q->owned_by_drv_count);	\
+			__entry->index = vb->v4l2_buf.index;		\
+			__entry->type = vb->v4l2_buf.type;		\
+			__entry->bytesused = vb->v4l2_buf.bytesused;	\
+			__entry->flags = vb->v4l2_buf.flags;		\
+			__entry->field = vb->v4l2_buf.field;		\
+			__entry->timestamp =				\
+				timeval_to_ns(&vb->v4l2_buf.timestamp);	\
+			__entry->timecode_type =			\
+				vb->v4l2_buf.timecode.type;		\
+			__entry->timecode_flags =			\
+				vb->v4l2_buf.timecode.flags;		\
+			__entry->timecode_frames =			\
+				vb->v4l2_buf.timecode.frames;		\
+			__entry->timecode_seconds =			\
+				vb->v4l2_buf.timecode.seconds;		\
+			__entry->timecode_minutes =			\
+				vb->v4l2_buf.timecode.minutes;		\
+			__entry->timecode_hours =			\
+				vb->v4l2_buf.timecode.hours;		\
+			__entry->timecode_userbits0 =			\
+				vb->v4l2_buf.timecode.userbits[0];	\
+			__entry->timecode_userbits1 =			\
+				vb->v4l2_buf.timecode.userbits[1];	\
+			__entry->timecode_userbits2 =			\
+				vb->v4l2_buf.timecode.userbits[2];	\
+			__entry->timecode_userbits3 =			\
+				vb->v4l2_buf.timecode.userbits[3];	\
+			__entry->sequence = vb->v4l2_buf.sequence;	\
+		),							\
+									\
+		TP_printk("minor = %d, queued = %u, owned_by_drv = %d "	\
+			  "index = %u, type = %s, "			\
+			  "bytesused = %u, flags = %s, "		\
+			  "field = %s, timestamp = %llu, timecode = { "	\
+			  "type = %s, flags = %s, frames = %u, "	\
+			  "seconds = %u, minutes = %u, hours = %u, "	\
+			  "userbits = { %u %u %u %u } }, "		\
+			  "sequence = %u", __entry->minor,		\
+			  __entry->queued_count,			\
+			  __entry->owned_by_drv_count,			\
+			  __entry->index, show_type(__entry->type),	\
+			  __entry->bytesused,				\
+			  show_flags(__entry->flags),			\
+			  show_field(__entry->field),			\
+			  __entry->timestamp,				\
+			  show_timecode_type(__entry->timecode_type),	\
+			  show_timecode_flags(__entry->timecode_flags),	\
+			  __entry->timecode_frames,			\
+			  __entry->timecode_seconds,			\
+			  __entry->timecode_minutes,			\
+			  __entry->timecode_hours,			\
+			  __entry->timecode_userbits0,			\
+			  __entry->timecode_userbits1,			\
+			  __entry->timecode_userbits2,			\
+			  __entry->timecode_userbits3,			\
+			  __entry->sequence				\
+		)							\
+	)
+
 V4L2_TRACE_EVENT(v4l2_dqbuf);
 V4L2_TRACE_EVENT(v4l2_qbuf);
 
+VB2_TRACE_EVENT(vb2_buf_done);
+VB2_TRACE_EVENT(vb2_buf_queue);
+VB2_TRACE_EVENT(vb2_dqbuf);
+VB2_TRACE_EVENT(vb2_qbuf);
+
 #endif /* if !defined(_TRACE_V4L2_H) || defined(TRACE_HEADER_MULTI_READ) */
 
 /* This part must be outside protection */
-- 
2.1.4

