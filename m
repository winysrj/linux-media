Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaI3OFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:05:15 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/3] libv4l2: Set convert_mmap_frame_size as soon as we've a dest_fmt
Date: Tue, 30 Sep 2014 16:05:00 +0200
Message-Id: <1412085901-18528-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1412085901-18528-1-git-send-email-hdegoede@redhat.com>
References: <1412085901-18528-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need convert_mmap_frame_size well before we need the convert-mmap buffer
itself, and thus well before we call v4l2_ensure_convert_mmap_buf.

This fixes querybuf returning a length of 0 for fake buffers.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4l2/libv4l2-priv.h |  1 +
 lib/libv4l2/libv4l2.c      | 44 ++++++++++++++++++++++++--------------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index fdd5ff0..343db5e 100644
--- a/lib/libv4l2/libv4l2-priv.h
+++ b/lib/libv4l2/libv4l2-priv.h
@@ -76,6 +76,7 @@ struct v4l2_dev_info {
 	int flags;
 	int open_count;
 	int gone; /* Set to 1 when a device is detached (ENODEV encountered) */
+	long page_size;
 	/* actual format of the cam */
 	struct v4l2_format src_fmt;
 	/* fmt as seen by the application (iow after conversion) */
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 22ed984..bdfb2fe 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -84,6 +84,8 @@
 #define V4L2_MMAP_OFFSET_MAGIC      0xABCDEF00u
 
 static void v4l2_adjust_src_fmt_to_fps(int index, int fps);
+static void v4l2_set_src_and_dest_format(int index,
+		struct v4l2_format *src_fmt, struct v4l2_format *dest_fmt);
 
 static pthread_mutex_t v4l2_open_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct v4l2_dev_info devices[V4L2_MAX_DEVICES] = {
@@ -96,25 +98,10 @@ static int devices_used;
 
 static int v4l2_ensure_convert_mmap_buf(int index)
 {
-	long page_size;
-
 	if (devices[index].convert_mmap_buf != MAP_FAILED) {
 		return 0;
 	}
 
-	page_size = sysconf(_SC_PAGESIZE);
-	if (page_size < 0) {
-		int saved_err = errno;
-		V4L2_LOG_ERR("unable to retrieve page size\n");
-		errno = saved_err;
-		return -1;
-	}
-
-	/* round up to full page size */
-	devices[index].convert_mmap_frame_size =
-		(((devices[index].dest_fmt.fmt.pix.sizeimage + page_size - 1) /
-		page_size) * page_size);
-
 	devices[index].convert_mmap_buf_size =
 		devices[index].convert_mmap_frame_size * devices[index].no_frames;
 
@@ -125,7 +112,6 @@ static int v4l2_ensure_convert_mmap_buf(int index)
 			-1, 0);
 
 	if (devices[index].convert_mmap_buf == MAP_FAILED) {
-		devices[index].convert_mmap_frame_size = 0;
 		devices[index].convert_mmap_buf_size = 0;
 
 		int saved_err = errno;
@@ -673,6 +659,7 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	void *plugin_library;
 	void *dev_ops_priv;
 	const struct libv4l_dev_ops *dev_ops;
+	long page_size;
 
 	v4l2_plugin_init(fd, &plugin_library, &dev_ops_priv, &dev_ops);
 
@@ -684,6 +671,17 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 			v4l2_log_file = fopen(lfname, "w");
 	}
 
+	/* Get page_size (for mmap emulation) */
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		int saved_err = errno;
+		V4L2_LOG_ERR("unable to retrieve page size: %s\n",
+			     strerror(errno));
+		v4l2_plugin_cleanup(plugin_library, dev_ops_priv, dev_ops);
+		errno = saved_err;
+		return -1;
+	}
+
 	/* check that this is a v4l2 device */
 	if (dev_ops->ioctl(dev_ops_priv, fd, VIDIOC_QUERYCAP, &cap)) {
 		int saved_err = errno;
@@ -761,8 +759,11 @@ no_capture:
 	    (parm.parm.capture.capability & V4L2_CAP_TIMEPERFRAME))
 		devices[index].flags |= V4L2_SUPPORTS_TIMEPERFRAME;
 	devices[index].open_count = 1;
-	devices[index].src_fmt = fmt;
+	devices[index].page_size = page_size;
+	devices[index].src_fmt  = fmt;
 	devices[index].dest_fmt = fmt;
+	v4l2_set_src_and_dest_format(index, &devices[index].src_fmt,
+				     &devices[index].dest_fmt);
 
 	/* When a user does a try_fmt with the current dest_fmt and the dest_fmt
 	   is a supported one we will align the resolution (see try_fmt for why).
@@ -781,7 +782,6 @@ no_capture:
 	devices[index].convert = convert;
 	devices[index].convert_mmap_buf = MAP_FAILED;
 	devices[index].convert_mmap_buf_size = 0;
-	devices[index].convert_mmap_frame_size = 0;
 	for (i = 0; i < V4L2_MAX_NO_FRAMES; i++) {
 		devices[index].frame_pointers[i] = MAP_FAILED;
 		devices[index].frame_map_count[i] = 0;
@@ -859,7 +859,6 @@ int v4l2_close(int fd)
 		}
 		devices[index].convert_mmap_buf = MAP_FAILED;
 		devices[index].convert_mmap_buf_size = 0;
-		devices[index].convert_mmap_frame_size = 0;
 	}
 	v4lconvert_destroy(devices[index].convert);
 	free(devices[index].readbuf);
@@ -916,7 +915,6 @@ static int v4l2_check_buffer_change_ok(int index)
 			devices[index].convert_mmap_buf_size);
 	devices[index].convert_mmap_buf = MAP_FAILED;
 	devices[index].convert_mmap_buf_size = 0;
-	devices[index].convert_mmap_frame_size = 0;
 
 	if (devices[index].flags & V4L2_STREAM_CONTROLLED_BY_READ) {
 		V4L2_LOG("deactivating read-stream for settings change\n");
@@ -964,6 +962,10 @@ static void v4l2_set_src_and_dest_format(int index,
 
 	devices[index].src_fmt = *src_fmt;
 	devices[index].dest_fmt = *dest_fmt;
+	/* round up to full page size */
+	devices[index].convert_mmap_frame_size =
+		(((dest_fmt->fmt.pix.sizeimage + devices[index].page_size - 1)
+		/ devices[index].page_size) * devices[index].page_size);
 }
 
 static int v4l2_s_fmt(int index, struct v4l2_format *dest_fmt)
@@ -1275,6 +1277,8 @@ no_capture_request:
 		/* The fmt has been changed, remember the new format ... */
 		devices[index].src_fmt  = src_fmt;
 		devices[index].dest_fmt = src_fmt;
+		v4l2_set_src_and_dest_format(index, &devices[index].src_fmt,
+					     &devices[index].dest_fmt);
 		/* and try to restore the last set destination pixelformat. */
 		src_fmt.fmt.pix.pixelformat = orig_dest_pixelformat;
 		result = v4l2_s_fmt(index, &src_fmt);
-- 
2.1.0

