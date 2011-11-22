Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1KVF06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 00:26:58 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so8242144iag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 21:26:57 -0800 (PST)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: mingchen@quicinc.com, hverkuil@xs4all.nl,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH v1 1/2] media: Add app_offset field to the v4l2_plane structure
Date: Mon, 21 Nov 2011 21:26:36 -0800
Message-Id: <1321939597-6239-2-git-send-email-pawel@osciak.com>
In-Reply-To: <1321939597-6239-1-git-send-email-pawel@osciak.com>
References: <1321939597-6239-1-git-send-email-pawel@osciak.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

app_offset allows the userspace to reserve memory at the beginning of a
plane that will not be touched by the kernel or hardware.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 Documentation/DocBook/media/v4l/io.xml    |   21 ++++++++++++++++++++-
 drivers/media/video/v4l2-compat-ioctl32.c |   11 ++++++++---
 drivers/media/video/v4l2-ioctl.c          |   10 ++++++----
 include/linux/videodev2.h                 |   18 ++++++++++++++++--
 4 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 3f47df1..dce648a 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -750,11 +750,30 @@ should set this to 0.</entry>
 	    <entry><structfield>data_offset</structfield></entry>
 	    <entry></entry>
 	    <entry>Offset in bytes to video data in the plane, if applicable.
+	      This offset can be used to indicate that the data in the plane
+	      is preceded by additional metadata, such as headers, specific to
+	      the current format.
+	      If app_offset != 0, this memory comes after the memory reserved
+	      with app_offset and start of data = app_offset + data_offset.
+	      This offset can be set by either drivers/hardware (for CAPTURE
+	      buffers) or userspace (for OUTPUT types).
 	    </entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved[11]</structfield></entry>
+	    <entry><structfield>app_offset</structfield></entry>
+	    <entry></entry>
+	    <entry>Offset in the plane to the beginning of memory usable by
+	      the driver/hardware. Applications may use this field
+	      to reserve memory at the beginning of the plane for own
+	      use. Neither drivers nor hardware should ever write to
+	      the plane before this offset (with the exception of
+	      zeroing on allocation, if performed by kernel).
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved[10]</structfield></entry>
 	    <entry></entry>
 	    <entry>Reserved for future use. Should be zeroed by an
 	    application.</entry>
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index c68531b..9e51e05 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -307,7 +307,8 @@ struct v4l2_plane32 {
 		compat_long_t	userptr;
 	} m;
 	__u32			data_offset;
-	__u32			reserved[11];
+	__u32			app_offset;
+	__u32			reserved[10];
 };
 
 struct v4l2_buffer32 {
@@ -338,9 +339,11 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 	void __user *up_pln;
 	compat_long_t p;
 
+	/* bytesused and length */
 	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
+		/* data_offset and app_offset */
 		copy_in_user(&up->data_offset, &up32->data_offset,
-				sizeof(__u32)))
+				2 * sizeof(__u32)))
 		return -EFAULT;
 
 	if (memory == V4L2_MEMORY_USERPTR) {
@@ -361,9 +364,11 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
 				enum v4l2_memory memory)
 {
+	/* bytesused and length */
 	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
+		/* data_offset and app_offset */
 		copy_in_user(&up32->data_offset, &up->data_offset,
-				sizeof(__u32)))
+				2 * sizeof(__u32)))
 		return -EFAULT;
 
 	/* For MMAP, driver might've set up the offset, so copy it back.
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index e1da8fc..7cc9193 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -332,10 +332,12 @@ static void dbgbuf(unsigned int cmd, struct video_device *vfd,
 	if (V4L2_TYPE_IS_MULTIPLANAR(p->type) && p->m.planes) {
 		for (i = 0; i < p->length; ++i) {
 			plane = &p->m.planes[i];
-			dbgarg2("plane %d: bytesused=%d, data_offset=0x%08x "
-				"offset/userptr=0x%08lx, length=%d\n",
-				i, plane->bytesused, plane->data_offset,
-				plane->m.userptr, plane->length);
+			dbgarg2("plane %d: bytesused=%d, app_offset=0x%08x, "
+				" data_offset=0x%08x, offset/userptr=0x%08lx, "
+				" length=%d\n",
+				i, plane->bytesused, plane->app_offset,
+				plane->data_offset, plane->m.userptr,
+				plane->length);
 		}
 	} else {
 		dbgarg2("bytesused=%d, offset/userptr=0x%08lx, length=%d\n",
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..e3f31e7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -575,7 +575,20 @@ struct v4l2_requestbuffers {
  * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
  *			pointing to this plane
  * @data_offset:	offset in the plane to the start of data; usually 0,
- *			unless there is a header in front of the data
+ *			unless there is a header in front of the data;
+ *			memory reserved using this offset can be filled by
+ *			userspace (for OUTPUT types) or driver/hardware (for
+ *			CAPTURE);
+ *			if app_offset != 0, data_offset should be added to it,
+ *			i.e. start of data = app_offset + data_offset and
+ *			header data (reserved with data_offset) comes AFTER
+ *			app-reserved data (app_offset);
+ * @app_offset:		offset in the plane to the beginning of memory usable by
+ *			the driver/hardware; applications may use this field
+ *			to reserve memory at the beginning of the plane for own
+ *			use; neither drivers nor hardware should ever write to
+ *			the plane before this offset (with the exception of
+ *			zeroing on allocation, if performed by kernel);
  *
  * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
  * with two planes can have one plane for Y, and another for interleaved CbCr
@@ -590,7 +603,8 @@ struct v4l2_plane {
 		unsigned long	userptr;
 	} m;
 	__u32			data_offset;
-	__u32			reserved[11];
+	__u32			app_offset;
+	__u32			reserved[10];
 };
 
 /**
-- 
1.7.7.3

