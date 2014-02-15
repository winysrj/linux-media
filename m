Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46706 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753679AbaBOUvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 15:51:36 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v5 2/7] v4l: Use full 32 bits for buffer flags
Date: Sat, 15 Feb 2014 22:53:00 +0200
Message-Id: <1392497585-5084-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffer flags field is 32 bits but the defined only used 16. This is
fine, but as more than 16 bits will be used in the very near future, define
them as 32-bit numbers for consistency.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/io.xml |   30 ++++++++++++-------------
 include/uapi/linux/videodev2.h         |   38 +++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 8facac4..46d24b3 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -984,7 +984,7 @@ should set this to 0.</entry>
 	<tbody valign="top">
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_MAPPED</constant></entry>
-	    <entry>0x0001</entry>
+	    <entry>0x00000001</entry>
 	    <entry>The buffer resides in device memory and has been mapped
 into the application's address space, see <xref linkend="mmap" /> for details.
 Drivers set or clear this flag when the
@@ -994,7 +994,7 @@ Drivers set or clear this flag when the
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_QUEUED</constant></entry>
-	    <entry>0x0002</entry>
+	    <entry>0x00000002</entry>
 	  <entry>Internally drivers maintain two buffer queues, an
 incoming and outgoing queue. When this flag is set, the buffer is
 currently on the incoming queue. It automatically moves to the
@@ -1007,7 +1007,7 @@ cleared.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_DONE</constant></entry>
-	    <entry>0x0004</entry>
+	    <entry>0x00000004</entry>
 	    <entry>When this flag is set, the buffer is currently on
 the outgoing queue, ready to be dequeued from the driver. Drivers set
 or clear this flag when the <constant>VIDIOC_QUERYBUF</constant> ioctl
@@ -1021,7 +1021,7 @@ state, in the application domain to say so.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_ERROR</constant></entry>
-	    <entry>0x0040</entry>
+	    <entry>0x00000040</entry>
 	    <entry>When this flag is set, the buffer has been dequeued
 	    successfully, although the data might have been corrupted.
 	    This is recoverable, streaming may continue as normal and
@@ -1031,7 +1031,7 @@ state, in the application domain to say so.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_KEYFRAME</constant></entry>
-	    <entry>0x0008</entry>
+	    <entry>0x00000008</entry>
 	  <entry>Drivers set or clear this flag when calling the
 <constant>VIDIOC_DQBUF</constant> ioctl. It may be set by video
 capture devices when the buffer contains a compressed image which is a
@@ -1039,27 +1039,27 @@ key frame (or field), &ie; can be decompressed on its own.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_PFRAME</constant></entry>
-	    <entry>0x0010</entry>
+	    <entry>0x00000010</entry>
 	    <entry>Similar to <constant>V4L2_BUF_FLAG_KEYFRAME</constant>
 this flags predicted frames or fields which contain only differences to a
 previous key frame.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_BFRAME</constant></entry>
-	    <entry>0x0020</entry>
+	    <entry>0x00000020</entry>
 	    <entry>Similar to <constant>V4L2_BUF_FLAG_PFRAME</constant>
 	this is a bidirectional predicted frame or field. [ooc tbd]</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMECODE</constant></entry>
-	    <entry>0x0100</entry>
+	    <entry>0x00000100</entry>
 	    <entry>The <structfield>timecode</structfield> field is valid.
 Drivers set or clear this flag when the <constant>VIDIOC_DQBUF</constant>
 ioctl is called.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_PREPARED</constant></entry>
-	    <entry>0x0400</entry>
+	    <entry>0x00000400</entry>
 	    <entry>The buffer has been prepared for I/O and can be queued by the
 application. Drivers set or clear this flag when the
 <link linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link>, <link
@@ -1069,7 +1069,7 @@ application. Drivers set or clear this flag when the
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
-	    <entry>0x0800</entry>
+	    <entry>0x00000800</entry>
 	    <entry>Caches do not have to be invalidated for this buffer.
 Typically applications shall use this flag if the data captured in the buffer
 is not going to be touched by the CPU, instead the buffer will, probably, be
@@ -1078,7 +1078,7 @@ passed on to a DMA-capable hardware unit for further processing or output.
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
-	    <entry>0x1000</entry>
+	    <entry>0x00001000</entry>
 	    <entry>Caches do not have to be cleaned for this buffer.
 Typically applications shall use this flag for output buffers if the data
 in this buffer has not been created by the CPU but by some DMA-capable unit,
@@ -1086,7 +1086,7 @@ in which case caches have not been used.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
-	    <entry>0xe000</entry>
+	    <entry>0x0000e000</entry>
 	    <entry>Mask for timestamp types below. To test the
 	    timestamp type, mask out bits not belonging to timestamp
 	    type by performing a logical and operation with buffer
@@ -1094,7 +1094,7 @@ in which case caches have not been used.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN</constant></entry>
-	    <entry>0x0000</entry>
+	    <entry>0x00000000</entry>
 	    <entry>Unknown timestamp type. This type is used by
 	    drivers before Linux 3.9 and may be either monotonic (see
 	    below) or realtime (wall clock). Monotonic clock has been
@@ -1107,7 +1107,7 @@ in which case caches have not been used.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC</constant></entry>
-	    <entry>0x2000</entry>
+	    <entry>0x00002000</entry>
 	    <entry>The buffer timestamp has been taken from the
 	    <constant>CLOCK_MONOTONIC</constant> clock. To access the
 	    same clock outside V4L2, use
@@ -1115,7 +1115,7 @@ in which case caches have not been used.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
-	    <entry>0x4000</entry>
+	    <entry>0x00004000</entry>
 	    <entry>The CAPTURE buffer timestamp has been taken from the
 	    corresponding OUTPUT buffer. This flag applies only to mem2mem devices.</entry>
 	  </row>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 6ae7bbe..e9ee444 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -669,24 +669,32 @@ struct v4l2_buffer {
 };
 
 /*  Flags for 'flags' field */
-#define V4L2_BUF_FLAG_MAPPED	0x0001  /* Buffer is mapped (flag) */
-#define V4L2_BUF_FLAG_QUEUED	0x0002	/* Buffer is queued for processing */
-#define V4L2_BUF_FLAG_DONE	0x0004	/* Buffer is ready */
-#define V4L2_BUF_FLAG_KEYFRAME	0x0008	/* Image is a keyframe (I-frame) */
-#define V4L2_BUF_FLAG_PFRAME	0x0010	/* Image is a P-frame */
-#define V4L2_BUF_FLAG_BFRAME	0x0020	/* Image is a B-frame */
+/* Buffer is mapped (flag) */
+#define V4L2_BUF_FLAG_MAPPED			0x00000001
+/* Buffer is queued for processing */
+#define V4L2_BUF_FLAG_QUEUED			0x00000002
+/* Buffer is ready */
+#define V4L2_BUF_FLAG_DONE			0x00000004
+/* Image is a keyframe (I-frame) */
+#define V4L2_BUF_FLAG_KEYFRAME			0x00000008
+/* Image is a P-frame */
+#define V4L2_BUF_FLAG_PFRAME			0x00000010
+/* Image is a B-frame */
+#define V4L2_BUF_FLAG_BFRAME			0x00000020
 /* Buffer is ready, but the data contained within is corrupted. */
-#define V4L2_BUF_FLAG_ERROR	0x0040
-#define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
-#define V4L2_BUF_FLAG_PREPARED	0x0400	/* Buffer is prepared for queuing */
+#define V4L2_BUF_FLAG_ERROR			0x00000040
+/* timecode field is valid */
+#define V4L2_BUF_FLAG_TIMECODE			0x00000100
+/* Buffer is prepared for queuing */
+#define V4L2_BUF_FLAG_PREPARED			0x00000400
 /* Cache handling flags */
-#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
-#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
+#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x00000800
+#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x00001000
 /* Timestamp type */
-#define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
-#define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
-#define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
-#define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x4000
+#define V4L2_BUF_FLAG_TIMESTAMP_MASK		0x0000e000
+#define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x00000000
+#define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x00002000
+#define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x00004000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
1.7.10.4

