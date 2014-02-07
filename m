Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45744 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752139AbaBGWtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 17:49:20 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH v4.2 3/4] v4l: Add timestamp source flags, mask and document them
Date: Sat,  8 Feb 2014 00:52:27 +0200
Message-Id: <1391813548-818-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393149.6OyBNhdFTt@avalon>
References: <1393149.6OyBNhdFTt@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices do not produce timestamps that correspond to the end of the
frame. The user space should be informed on the matter. This patch achieves
that by adding buffer flags (and a mask) for timestamp sources since more
possible timestamping points are expected than just two.

A three-bit mask is defined (V4L2_BUF_FLAG_TSTAMP_SRC_MASK) and two of the
eight possible values is are defined V4L2_BUF_FLAG_TSTAMP_SRC_EOF for end of
frame (value zero) V4L2_BUF_FLAG_TSTAMP_SRC_SOE for start of exposure (next
value).

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
since v4.1:
- Replace SOF flag by SOE flag
- Add mask for timestamp sources

 Documentation/DocBook/media/v4l/io.xml |   28 ++++++++++++++++++++++------
 drivers/media/usb/uvc/uvc_queue.c      |    3 ++-
 include/media/videobuf2-core.h         |    2 ++
 include/uapi/linux/videodev2.h         |    4 ++++
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 2c155cc..451626f 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -654,12 +654,6 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
 In that case, struct <structname>v4l2_buffer</structname> contains an array of
 plane structures.</para>
 
-      <para>For timestamp types that are sampled from the system clock
-(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
-taken after the complete frame has been received (or transmitted in
-case of video output devices). For other kinds of
-timestamps this may vary depending on the driver.</para>
-
     <table frame="none" pgwide="1" id="v4l2-buffer">
       <title>struct <structname>v4l2_buffer</structname></title>
       <tgroup cols="4">
@@ -1120,6 +1114,28 @@ in which case caches have not been used.</entry>
 	    <entry>The CAPTURE buffer timestamp has been taken from the
 	    corresponding OUTPUT buffer. This flag applies only to mem2mem devices.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant></entry>
+	    <entry>0x00070000</entry>
+	    <entry>Mask for timestamp sources below. The timestamp source
+	    defines the point of time the timestamp is taken in relation to
+	    the frame. Logical and operation between the
+	    <structfield>flags</structfield> field and
+	    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> produces the
+	    value of the timestamp source.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_EOF</constant></entry>
+	    <entry>0x00000000</entry>
+	    <entry>"End of frame." The buffer timestamp has been taken when
+	    the last pixel of the frame has been received.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_SOE</constant></entry>
+	    <entry>0x00010000</entry>
+	    <entry>"Start of exposure." The buffer timestamp has been taken
+	    when the exposure of the frame has begun.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cd962be..a9292d2 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -149,7 +149,8 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
-	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
 	ret = vb2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bef53ce..b6b992d 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -312,6 +312,8 @@ struct v4l2_fh;
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
  *		structure type, so sizeof(struct vb2_buffer) will is used
+ * @timestamp_type: Timestamp flags; V4L2_BUF_FLAGS_TIMESTAMP_* and
+ *		V4L2_BUF_FLAGS_TSTAMP_SRC_*
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
  *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
  *		to force the buffer allocation to a specific memory zone.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e9ee444..82e8661 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -695,6 +695,10 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x00000000
 #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x00002000
 #define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x00004000
+/* Timestamp sources. */
+#define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
+#define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
+#define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
1.7.10.4

