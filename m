Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46372 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750754AbaBWKib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 05:38:31 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com
Subject: [PATCH v5.2 3/7] v4l: Add timestamp source flags, mask and document them
Date: Sun, 23 Feb 2014 12:40:34 +0200
Message-Id: <1393152034-21336-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <53071CFA.5060503@iki.fi>
References: <53071CFA.5060503@iki.fi>
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
since v5.1:
- Remove the note on timestamp inaccuracy from SOE timestamps.
- Add ..."or transmitted" for EOF timestamps.
- Correct language related to valid buffer types and SOE timestamps.

 Documentation/DocBook/media/v4l/io.xml   |   36 +++++++++++++++++++++++++-----
 drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
 include/media/videobuf2-core.h           |    2 ++
 include/uapi/linux/videodev2.h           |    4 ++++
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 46d24b3..d44401c 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -653,12 +653,6 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
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
@@ -1119,6 +1113,36 @@ in which case caches have not been used.</entry>
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
+	    <entry>End Of Frame. The buffer timestamp has been taken
+	    when the last pixel of the frame has been received or the
+	    last pixel of the frame has been transmitted. In practice,
+	    software generated timestamps will typically be read from
+	    the clock a small amount of time after the last pixel has
+	    been received or transmitten, depending on the system and
+	    other activity in it.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_SOE</constant></entry>
+	    <entry>0x00010000</entry>
+	    <entry>Start Of Exposure. The buffer timestamp has been
+	    taken when the exposure of the frame has begun. This is
+	    only valid for the
+	    <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> buffer
+	    type.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5a5fb7f..6e314b0 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2195,7 +2195,9 @@ int vb2_queue_init(struct vb2_queue *q)
 	    WARN_ON(!q->io_modes)	  ||
 	    WARN_ON(!q->ops->queue_setup) ||
 	    WARN_ON(!q->ops->buf_queue)   ||
-	    WARN_ON(q->timestamp_type & ~V4L2_BUF_FLAG_TIMESTAMP_MASK))
+	    WARN_ON(q->timestamp_type &
+		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
+		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
 		return -EINVAL;
 
 	/* Warn that the driver should choose an appropriate timestamp type */
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

