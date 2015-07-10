Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57714 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbbGJNtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:49:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 1/3] [media] v4l2-dev: use event class to deduplicate v4l2 trace events
Date: Fri, 10 Jul 2015 15:49:24 +0200
Message-Id: <1436536166-3307-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trace events with exactly the same parameters and trace output, such as
v4l2_qbuf and v4l2_dqbuf, are supposed to use the DECLARE_EVENT_CLASS and
DEFINE_EVENT macros instead of duplicated TRACE_EVENT macro calls.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/trace/events/v4l2.h | 160 +++++++++++++++++++++-----------------------
 1 file changed, 78 insertions(+), 82 deletions(-)

diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index 89d0497..4c88a32 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -93,90 +93,86 @@ SHOW_FIELD
 		{ V4L2_TC_USERBITS_USERDEFINED,	"USERBITS_USERDEFINED" }, \
 		{ V4L2_TC_USERBITS_8BITCHARS,	"USERBITS_8BITCHARS" })
 
-#define V4L2_TRACE_EVENT(event_name)					\
-	TRACE_EVENT(event_name,						\
-		TP_PROTO(int minor, struct v4l2_buffer *buf),		\
-									\
-		TP_ARGS(minor, buf),					\
-									\
-		TP_STRUCT__entry(					\
-			__field(int, minor)				\
-			__field(u32, index)				\
-			__field(u32, type)				\
-			__field(u32, bytesused)				\
-			__field(u32, flags)				\
-			__field(u32, field)				\
-			__field(s64, timestamp)				\
-			__field(u32, timecode_type)			\
-			__field(u32, timecode_flags)			\
-			__field(u8, timecode_frames)			\
-			__field(u8, timecode_seconds)			\
-			__field(u8, timecode_minutes)			\
-			__field(u8, timecode_hours)			\
-			__field(u8, timecode_userbits0)			\
-			__field(u8, timecode_userbits1)			\
-			__field(u8, timecode_userbits2)			\
-			__field(u8, timecode_userbits3)			\
-			__field(u32, sequence)				\
-		),							\
-									\
-		TP_fast_assign(						\
-			__entry->minor = minor;				\
-			__entry->index = buf->index;			\
-			__entry->type = buf->type;			\
-			__entry->bytesused = buf->bytesused;		\
-			__entry->flags = buf->flags;			\
-			__entry->field = buf->field;			\
-			__entry->timestamp =				\
-				timeval_to_ns(&buf->timestamp);		\
-			__entry->timecode_type = buf->timecode.type;	\
-			__entry->timecode_flags = buf->timecode.flags;	\
-			__entry->timecode_frames =			\
-				buf->timecode.frames;			\
-			__entry->timecode_seconds =			\
-				buf->timecode.seconds;			\
-			__entry->timecode_minutes =			\
-				buf->timecode.minutes;			\
-			__entry->timecode_hours = buf->timecode.hours;	\
-			__entry->timecode_userbits0 =			\
-				buf->timecode.userbits[0];		\
-			__entry->timecode_userbits1 =			\
-				buf->timecode.userbits[1];		\
-			__entry->timecode_userbits2 =			\
-				buf->timecode.userbits[2];		\
-			__entry->timecode_userbits3 =			\
-				buf->timecode.userbits[3];		\
-			__entry->sequence = buf->sequence;		\
-		),							\
-									\
-		TP_printk("minor = %d, index = %u, type = %s, "		\
-			  "bytesused = %u, flags = %s, "		\
-			  "field = %s, timestamp = %llu, timecode = { "	\
-			  "type = %s, flags = %s, frames = %u, "	\
-			  "seconds = %u, minutes = %u, hours = %u, "	\
-			  "userbits = { %u %u %u %u } }, "		\
-			  "sequence = %u", __entry->minor,		\
-			  __entry->index, show_type(__entry->type),	\
-			  __entry->bytesused,				\
-			  show_flags(__entry->flags),			\
-			  show_field(__entry->field),			\
-			  __entry->timestamp,				\
-			  show_timecode_type(__entry->timecode_type),	\
-			  show_timecode_flags(__entry->timecode_flags),	\
-			  __entry->timecode_frames,			\
-			  __entry->timecode_seconds,			\
-			  __entry->timecode_minutes,			\
-			  __entry->timecode_hours,			\
-			  __entry->timecode_userbits0,			\
-			  __entry->timecode_userbits1,			\
-			  __entry->timecode_userbits2,			\
-			  __entry->timecode_userbits3,			\
-			  __entry->sequence				\
-		)							\
+DECLARE_EVENT_CLASS(v4l2_event_class,
+	TP_PROTO(int minor, struct v4l2_buffer *buf),
+
+	TP_ARGS(minor, buf),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(u32, index)
+		__field(u32, type)
+		__field(u32, bytesused)
+		__field(u32, flags)
+		__field(u32, field)
+		__field(s64, timestamp)
+		__field(u32, timecode_type)
+		__field(u32, timecode_flags)
+		__field(u8, timecode_frames)
+		__field(u8, timecode_seconds)
+		__field(u8, timecode_minutes)
+		__field(u8, timecode_hours)
+		__field(u8, timecode_userbits0)
+		__field(u8, timecode_userbits1)
+		__field(u8, timecode_userbits2)
+		__field(u8, timecode_userbits3)
+		__field(u32, sequence)
+	),
+
+	TP_fast_assign(
+		__entry->minor = minor;
+		__entry->index = buf->index;
+		__entry->type = buf->type;
+		__entry->bytesused = buf->bytesused;
+		__entry->flags = buf->flags;
+		__entry->field = buf->field;
+		__entry->timestamp = timeval_to_ns(&buf->timestamp);
+		__entry->timecode_type = buf->timecode.type;
+		__entry->timecode_flags = buf->timecode.flags;
+		__entry->timecode_frames = buf->timecode.frames;
+		__entry->timecode_seconds = buf->timecode.seconds;
+		__entry->timecode_minutes = buf->timecode.minutes;
+		__entry->timecode_hours = buf->timecode.hours;
+		__entry->timecode_userbits0 = buf->timecode.userbits[0];
+		__entry->timecode_userbits1 = buf->timecode.userbits[1];
+		__entry->timecode_userbits2 = buf->timecode.userbits[2];
+		__entry->timecode_userbits3 = buf->timecode.userbits[3];
+		__entry->sequence = buf->sequence;
+	),
+
+	TP_printk("minor = %d, index = %u, type = %s, bytesused = %u, "
+		  "flags = %s, field = %s, timestamp = %llu, "
+		  "timecode = { type = %s, flags = %s, frames = %u, "
+		  "seconds = %u, minutes = %u, hours = %u, "
+		  "userbits = { %u %u %u %u } }, sequence = %u", __entry->minor,
+		  __entry->index, show_type(__entry->type),
+		  __entry->bytesused,
+		  show_flags(__entry->flags),
+		  show_field(__entry->field),
+		  __entry->timestamp,
+		  show_timecode_type(__entry->timecode_type),
+		  show_timecode_flags(__entry->timecode_flags),
+		  __entry->timecode_frames,
+		  __entry->timecode_seconds,
+		  __entry->timecode_minutes,
+		  __entry->timecode_hours,
+		  __entry->timecode_userbits0,
+		  __entry->timecode_userbits1,
+		  __entry->timecode_userbits2,
+		  __entry->timecode_userbits3,
+		  __entry->sequence
 	)
+)
 
-V4L2_TRACE_EVENT(v4l2_dqbuf);
-V4L2_TRACE_EVENT(v4l2_qbuf);
+DEFINE_EVENT(v4l2_event_class, v4l2_dqbuf,
+	TP_PROTO(int minor, struct v4l2_buffer *buf),
+	TP_ARGS(minor, buf)
+);
+
+DEFINE_EVENT(v4l2_event_class, v4l2_qbuf,
+	TP_PROTO(int minor, struct v4l2_buffer *buf),
+	TP_ARGS(minor, buf)
+);
 
 #endif /* if !defined(_TRACE_V4L2_H) || defined(TRACE_HEADER_MULTI_READ) */
 
-- 
2.1.4

