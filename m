Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:50854 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3JRPDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 11:03:40 -0400
Received: from svr-orw-exc-10.mgc.mentorg.com ([147.34.98.58])
	by relay1.mentorg.com with esmtp
	id 1VXBaU-0007Ih-QL from wade_farnsworth@mentor.com
	for linux-media@vger.kernel.org; Fri, 18 Oct 2013 08:03:38 -0700
Message-ID: <52614DB9.8090908@mentor.com>
Date: Fri, 18 Oct 2013 08:03:21 -0700
From: Wade Farnsworth <wade_farnsworth@mentor.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: [RFC][PATCH] v4l2-dev: Add tracepoints for QBUF and DQBUF
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

We've found this patch helpful for making some simple performance measurements on 
V4L2 systems using the standard Linux tracers (FTRACE, LTTng, etc.), and were 
wondering if the larger community would find it useful to have this in mainline as 
well.

This patch adds two tracepoints for the VIDIOC_DQBUF and VIDIOC_QBUF ioctls.  We've 
identified two ways we can use this information to measure performance, though this  
is likely not an exhaustive list:

1. Measuring the difference in timestamps between QBUF events on a display device 
   provides a throughput (framerate) measurement for the display.
2. Measuring the difference between the timestamps on a DQBUF event for a capture 
   device and a corresponding timestamp on a QBUF event on a display device provides 
   a rough approximation of the latency of that particular frame.  However, this 
   tends to only work for simple video pipelines where captured and displayed 
   frames can be correlated in such a fashion.

Comments are welcome.  If there is interest, I'll post another patch suitable
for merge.

Signed-off-by: Wade Farnsworth <wade_farnsworth@mentor.com>
---
 drivers/media/v4l2-core/v4l2-dev.c |    9 ++++++
 include/trace/events/v4l2.h        |   48 ++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/v4l2.h

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index b5aaaac..1cc1749 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -31,6 +31,10 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/v4l2.h>
+
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
 
@@ -391,6 +395,11 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	} else
 		ret = -ENOTTY;
 
+	if (cmd == VIDIOC_DQBUF)
+		trace_v4l2_dqbuf(vdev->minor, (struct v4l2_buffer *)arg);
+	else if (cmd == VIDIOC_QBUF)
+		trace_v4l2_qbuf(vdev->minor, (struct v4l2_buffer *)arg);
+
 	return ret;
 }
 
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
new file mode 100644
index 0000000..1697441
--- /dev/null
+++ b/include/trace/events/v4l2.h
@@ -0,0 +1,48 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM v4l2
+
+#if !defined(_TRACE_V4L2_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_V4L2_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(v4l2_dqbuf,
+	TP_PROTO(int minor, struct v4l2_buffer *buf),
+
+	TP_ARGS(minor, buf),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(s64, ts)
+	),
+
+	TP_fast_assign(
+		__entry->minor = minor;
+		__entry->ts = timeval_to_ns(&buf->timestamp);
+	),
+
+	TP_printk("%d [%lld]", __entry->minor, __entry->ts)
+);
+
+TRACE_EVENT(v4l2_qbuf,
+	TP_PROTO(int minor, struct v4l2_buffer *buf),
+
+	TP_ARGS(minor, buf),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(s64, ts)
+	),
+
+	TP_fast_assign(
+		__entry->minor = minor;
+		__entry->ts = timeval_to_ns(&buf->timestamp);
+	),
+
+	TP_printk("%d [%lld]", __entry->minor, __entry->ts)
+);
+
+#endif /* if !defined(_TRACE_V4L2_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.0.4

