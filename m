Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53784 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2BTTov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 14:44:51 -0500
Received: by bkcjm19 with SMTP id jm19so4819608bkc.19
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 11:44:50 -0800 (PST)
Message-ID: <4F42A2B1.6070204@uni-bielefeld.de>
Date: Mon, 20 Feb 2012 20:44:49 +0100
From: Robert Abel <abel@uni-bielefeld.de>
Reply-To: abel@uni-bielefeld.de
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH][libv4l] Miscellaneous Comment Fixes
Content-Type: multipart/mixed;
 boundary="------------040609030104000101060100"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040609030104000101060100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I found some minor spelling/grammar issues in the comments of libv4l. I
fixed the most irksome to me in the patch below.

Regards,

Robert

--------------040609030104000101060100
Content-Type: text/plain;
 name="0002-misc_comment_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-misc_comment_fix.patch"

diff -Naur a/lib/libv4lconvert/bayer.c b/lib/libv4lconvert/bayer.c
--- a/lib/libv4lconvert/bayer.c	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4lconvert/bayer.c	2012-02-20 20:17:36.741026768 +0100
@@ -25,7 +25,7 @@
  *
  * Note that the original bayer.c in libdc1394 supports many different
  * bayer decode algorithms, for lib4lconvert the one in this file has been
- * chosen (and optimized a bit) and the other algorithm's have been removed,
+ * chosen (and optimized a bit) and the other algorithms have been removed,
  * see bayer.c from libdc1394 for all supported algorithms
  */

diff -Naur a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
--- a/lib/libv4l2/libv4l2.c	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4l2/libv4l2.c	2012-02-20 20:06:49.171363269 +0100
@@ -45,14 +45,14 @@
 
    This also means that libv4l2 may not use any of the regular functions
    it mimics, as for example open could be a symbol in v4l2convert.so, which
-   in turn will call v4l2_open, so therefor v4l2_open (for example) may not
+   in turn will call v4l2_open, so therefore v4l2_open (for example) may not
    use the regular open()!
 
    Another important note: libv4l2 does conversion for capture usage only, if
    any calls are made which are passed a v4l2_buffer or v4l2_format with a
    v4l2_buf_type which is different from V4L2_BUF_TYPE_VIDEO_CAPTURE, then
    the v4l2_ methods behave exactly the same as their regular counterparts.
-   When modifications are made, one should be carefull that this behavior is
+   When modifications are made, one should be careful that this behavior is
    preserved.
  */
 #include <errno.h>
@@ -99,7 +99,7 @@
 	struct v4l2_requestbuffers req;
 
 	/* Note we re-request the buffers if they are already requested as the format
-	   and thus the needed buffersize may have changed. */
+	   and thus the needed buffer size may have changed. */
 	req.count = (devices[index].no_frames) ? devices[index].no_frames :
 		devices[index].nreadbuffers;
 	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -235,7 +235,7 @@
 		}
 		devices[index].flags &= ~V4L2_STREAMON;
 
-		/* Stream off also unqueues all our buffers! */
+		/* Stream off also dequeues all our buffers! */
 		devices[index].frame_queued = 0;
 	}
 
@@ -466,7 +466,7 @@
 	if (result)
 		return result;
 
-	/* No need to unqueue our buffers, streamoff does that for us */
+	/* No need to dequeue our buffers, streamoff does that for us */
 
 	v4l2_unmap_buffers(index);
 
@@ -584,7 +584,7 @@
 			v4l2_log_file = fopen(lfname, "w");
 	}
 
-	/* check that this is an v4l2 device */
+	/* check that this is a v4l2 device */
 	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap)) {
 		int saved_err = errno;
 
@@ -608,7 +608,7 @@
 		return -1;
 	}
 
-	/* Check for framerate setting support */
+	/* Check for frame rate setting support */
 	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	if (SYS_IOCTL(fd, VIDIOC_G_PARM, &parm))
 		parm.type = 0;
@@ -678,8 +678,8 @@
 		devices_used = index + 1;
 
 	/* Note we always tell v4lconvert to optimize src fmt selection for
-	   our default fps, the only exception is the app explictly selecting
-	   a framerate using the S_PARM ioctl after a S_FMT */
+	   our default fps, the only exception is the app explicitly selecting
+	   a frame rate using the S_PARM ioctl after a S_FMT */
 	v4lconvert_set_fps(devices[index].convert, V4L2_DEFAULT_FPS);
 	v4l2_update_fps(index, &parm);
 
@@ -742,12 +742,12 @@
 	devices[index].readbuf_size = 0;
 
 	/* Remove the fd from our list of managed fds before closing it, because as
-	   soon as we've done the actual close the fd maybe returned by an open in
+	   soon as we've done the actual close, the fd maybe returned by an open() in
 	   another thread and we don't want to intercept calls to this new fd. */
 	devices[index].fd = -1;
 
 	/* Since we've marked the fd as no longer used, and freed the resources,
-	   redo the close in case it was interrupted */
+	   re-do the close in case it was interrupted */
 	do {
 		result = SYS_CLOSE(fd);
 	} while (result == -1 && errno == EINTR);
@@ -933,7 +933,7 @@
 	if (index == -1)
 		return SYS_IOCTL(fd, request, arg);
 
-	/* Appearantly the kernel and / or glibc ignore the 32 most significant bits
+	/* Apparently the kernel and / or glibc ignore the 32 most significant bits
 	   when long = 64 bits, and some applications pass an int holding the req to
 	   ioctl, causing it to get sign extended, depending upon this behavior */
 	request = (unsigned int)request;
@@ -1020,7 +1020,7 @@
 
 	if (stream_needs_locking) {
 		pthread_mutex_lock(&devices[index].stream_lock);
-		/* If this is the first stream related ioctl, and we should only allow
+		/* If this is the first stream-related ioctl, and we should only allow
 		   libv4lconvert supported destination formats (so that it can do flipping,
 		   processing, etc.) and the current destination format is not supported,
 		   try setting the format to RGB24 (which is a supported dest. format). */
@@ -1282,7 +1282,7 @@
 		struct v4l2_streamparm *parm = arg;
 
 		/* See if libv4lconvert wishes to use a different src_fmt
-		   for the new framerate and set that first */
+		   for the new frame rate and set that first */
 		if ((devices[index].flags & V4L2_SUPPORTS_TIMEPERFRAME) &&
 		    parm->parm.capture.timeperframe.numerator != 0) {
 			int fps = parm->parm.capture.timeperframe.denominator;
@@ -1390,7 +1390,7 @@
 
 	pthread_mutex_lock(&devices[index].stream_lock);
 
-	/* When not converting and the device supports read let the kernel handle
+	/* When not converting and the device supports read(), let the kernel handle
 	   it */
 	if ((devices[index].flags & V4L2_SUPPORTS_READ) &&
 			!v4l2_needs_conversion(index)) {
@@ -1401,7 +1401,7 @@
 	/* Since we need to do conversion try to use mmap (streaming) mode under
 	   the hood as that safes a memcpy for each frame read.
 
-	   Note sometimes this will fail as some drivers (atleast gspca) do not allow
+	   Note sometimes this will fail as some drivers (at least gspca) do not allow
 	   switching from read mode to mmap mode and they assume read() mode if a
 	   select or poll() is done before any buffers are requested. So using mmap
 	   mode under the hood will fail if a select() or poll() is done before the
@@ -1447,8 +1447,8 @@
 
 	index = v4l2_get_index(fd);
 	if (index == -1 ||
-			/* Check if the mmap data matches our answer to QUERY_BUF, if it doesn't
-			   let the kernel handle it (to allow for mmap based non capture use) */
+			/* Check if the mmap data matches our answer to QUERY_BUF. If it doesn't,
+			   let the kernel handle it (to allow for mmap-based non capture use) */
 			start || length != V4L2_FRAME_BUF_SIZE ||
 			((unsigned int)offset & ~0xFFu) != V4L2_MMAP_OFFSET_MAGIC) {
 		if (index != -1)
@@ -1526,7 +1526,7 @@
 
 			buffer_index = (start - devices[index].convert_mmap_buf) / length;
 
-			/* Redo our checks now that we have the lock, things may have changed */
+			/* Re-do our checks now that we have the lock, things may have changed */
 			if (devices[index].convert_mmap_buf != MAP_FAILED &&
 					start >= devices[index].convert_mmap_buf &&
 					(start - devices[index].convert_mmap_buf) % length == 0 &&
diff -Naur a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
--- a/lib/libv4l2/libv4l2-priv.h	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4l2/libv4l2-priv.h	2012-02-20 20:08:44.181008973 +0100
@@ -67,7 +67,7 @@
 	int fd;
 	int flags;
 	int open_count;
-	/* actually format of the cam */
+	/* actual format of the cam */
 	struct v4l2_format src_fmt;
 	/* fmt as seen by the application (iow after conversion) */
 	struct v4l2_format dest_fmt;
diff -Naur a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
--- a/lib/libv4l2/v4l2convert.c	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4l2/v4l2convert.c	2012-02-20 20:07:39.251019853 +0100
@@ -51,7 +51,7 @@
 
 	/* check if we're opening a video4linux2 device */
 	if (!strncmp(file, "/dev/video", 10) || !strncmp(file, "/dev/v4l/", 9)) {
-		/* Some apps open the device read only, but we need rw rights as the
+		/* Some apps open the device read-only, but we need rw rights as the
 		   buffers *MUST* be mapped rw */
 		oflag = (oflag & ~O_ACCMODE) | O_RDWR;
 		v4l_device = 1;
@@ -76,7 +76,7 @@
 	if (fd == -1 || !v4l_device)
 		return fd;
 
-	/* check that this is an v4l2 device, libv4l2 only supports v4l2 devices */
+	/* check that this is a v4l2 device, libv4l2 only supports v4l2 devices */
 	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap))
 		return fd;
 
diff -Naur a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
--- a/lib/libv4lconvert/libv4lconvert.c	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4lconvert/libv4lconvert.c	2012-02-16 11:41:45.301387267 +0100
@@ -395,7 +395,7 @@
 		    supported_src_pixfmts[i].fmt)
 			continue;
 
-		/* Did we get a better match then before? */
+		/* Did we get a better match than before? */
 		size_x_diff = (int)try_fmt.fmt.pix.width -
 			      (int)dest_fmt->fmt.pix.width;
 		size_y_diff = (int)try_fmt.fmt.pix.height -
@@ -471,7 +471,7 @@
 	/* In case of a non exact resolution match, try again with a slightly larger
 	   resolution as some weird devices are not able to crop of the number of
 	   extra (border) pixels most sensors have compared to standard resolutions,
-	   which we will then just crop of in software */
+	   which we will then just crop off in software */
 	if (try_dest.fmt.pix.width != desired_width ||
 			try_dest.fmt.pix.height != desired_height) {
 		try2_dest = *dest_fmt;


--------------040609030104000101060100--
