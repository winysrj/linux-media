Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43483 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbbCFKSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 05:18:35 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Peter Seiderer <ps.report@gmx.net>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 1/5] [media] videodev2: Add V4L2_BUF_FLAG_LAST
Date: Fri,  6 Mar 2015 11:18:26 +0100
Message-Id: <1425637110-12100-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1425637110-12100-1-git-send-email-p.zabel@pengutronix.de>
References: <1425637110-12100-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

This v4l2_buffer flag can be used by drivers to mark a capture buffer
as the last generated buffer, for example after a V4L2_DEC_CMD_STOP
command was issued.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
 - Made V4L2_BUF_FLAG_LAST known to trace events
---
 Documentation/DocBook/media/v4l/io.xml | 10 ++++++++++
 include/trace/events/v4l2.h            |  3 ++-
 include/uapi/linux/videodev2.h         |  2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 1c17f80..f3b8bc0 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1129,6 +1129,16 @@ in this buffer has not been created by the CPU but by some DMA-capable unit,
 in which case caches have not been used.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_LAST</constant></entry>
+	    <entry>0x00100000</entry>
+	    <entry>Last buffer produced by the hardware. mem2mem codec drivers
+set this flag on the capture queue for the last buffer when the
+<link linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link> or
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called. After the
+queue is drained, the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will
+not block anymore, but return an &EPIPE;.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
 	    <entry>0x0000e000</entry>
 	    <entry>Mask for timestamp types below. To test the
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index b9bb1f2..32c33aa 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -58,7 +58,8 @@
 		{ V4L2_BUF_FLAG_TIMESTAMP_MASK,	     "TIMESTAMP_MASK" },      \
 		{ V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN,   "TIMESTAMP_UNKNOWN" },   \
 		{ V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC, "TIMESTAMP_MONOTONIC" }, \
-		{ V4L2_BUF_FLAG_TIMESTAMP_COPY,	     "TIMESTAMP_COPY" })
+		{ V4L2_BUF_FLAG_TIMESTAMP_COPY,	     "TIMESTAMP_COPY" },      \
+		{ V4L2_BUF_FLAG_LAST,                "LAST" })
 
 #define show_timecode_flags(flags)					  \
 	__print_flags(flags, "|",					  \
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..c642c10 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -809,6 +809,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
+/* mem2mem encoder/decoder */
+#define V4L2_BUF_FLAG_LAST			0x00100000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
2.1.4

