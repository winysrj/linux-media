Return-path: <mchehab@localhost>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48742 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1GFJYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 05:24:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNW003X8NGHD120@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 10:24:18 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNW001OGNGGBE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 10:24:17 +0100 (BST)
Date: Wed, 06 Jul 2011 11:24:13 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/2] libv4l2: add implicit conversion from single- to
 multi-plane api
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, mchehab@redhat.com, pawel@osciak.com,
	hdegoede@redhat.com
Message-id: <1309944253-11703-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This patch add implicit conversion of single plane variant of ioctl to
multiplane variant. The conversion is performed only in case if a driver
implements only mplane api. The conversion is done by substituting SYS_IOCTL
with a wrapper that converts single plane call to their mplane analogs.
Function v4l2_fd_open was revised to work correctly with the wrapper.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 lib/libv4l2/libv4l2.c                  |  227 ++++++++++++++++++++++++++++----
 lib/libv4lconvert/libv4lsyscall-priv.h |    5 +-
 2 files changed, 205 insertions(+), 27 deletions(-)

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 4de382e..6af9f8c 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -57,6 +57,7 @@
  */
 #include <errno.h>
 #include <stdarg.h>
+#include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
@@ -79,6 +80,7 @@
 #define V4L2_STREAM_TOUCHED		0x2000
 #define V4L2_USE_READ_FOR_READ		0x4000
 #define V4L2_SUPPORTS_TIMEPERFRAME	0x8000
+#define V4L2_CONVERT2MPLANE		0x00010000
 
 #define V4L2_MMAP_OFFSET_MAGIC      0xABCDEF00u
 
@@ -93,6 +95,165 @@ static struct v4l2_dev_info devices[V4L2_MAX_DEVICES] = {
 };
 static int devices_used;
 
+static int v4l2_get_index(int fd);
+
+#define SYS_DO_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+int v4l2_ioctl_mp(int fd, unsigned long cmd, void *arg)
+{
+	int ret;
+	int index = v4l2_get_index(fd);
+
+	/* skipping if no mplane convertion is needed */
+	if (index == -1 || !(devices[index].flags & V4L2_CONVERT2MPLANE))
+		return SYS_DO_IOCTL(fd, cmd, arg);
+
+	switch (cmd) {
+	case VIDIOC_QUERYCAP: {
+		struct v4l2_capability *cap = arg;
+		ret = SYS_DO_IOCTL(fd, cmd, cap);
+		if (ret)
+			return ret;
+		if (cap->capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
+			cap->capabilities |= V4L2_CAP_VIDEO_CAPTURE;
+		return 0;
+	}
+	case VIDIOC_TRY_FMT:
+	case VIDIOC_S_FMT: {
+		/* convert single planar structs to mplane structs */
+		struct v4l2_format fmt = {0};
+		struct v4l2_format *old = arg;
+
+		fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		fmt.fmt.pix_mp.width = old->fmt.pix.width;
+		fmt.fmt.pix_mp.height = old->fmt.pix.height;
+		fmt.fmt.pix_mp.pixelformat = old->fmt.pix.pixelformat;
+		fmt.fmt.pix_mp.field = old->fmt.pix.field;
+		fmt.fmt.pix_mp.colorspace = old->fmt.pix.colorspace;
+		fmt.fmt.pix_mp.num_planes = 1;
+		fmt.fmt.pix_mp.plane_fmt[0].bytesperline = old->fmt.pix.bytesperline;
+		fmt.fmt.pix_mp.plane_fmt[0].sizeimage = old->fmt.pix.sizeimage;
+
+		ret = SYS_DO_IOCTL(fd, cmd, &fmt);
+		if (ret)
+			return ret;
+
+		old->fmt.pix.width = fmt.fmt.pix_mp.width;
+		old->fmt.pix.height = fmt.fmt.pix_mp.height;
+		old->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
+		old->fmt.pix.field = fmt.fmt.pix_mp.field;
+		old->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
+		old->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+		old->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+
+		return 0;
+	}
+	case VIDIOC_G_FMT: {
+		struct v4l2_format fmt = { 0 };
+		struct v4l2_format *old = arg;
+
+		fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		ret = SYS_DO_IOCTL(fd, cmd, &fmt);
+		if (ret)
+			return ret;
+		/* cannot return multiplane format to singleplane app */
+		if (fmt.fmt.pix_mp.num_planes > 1) {
+			errno = -EBUSY;
+			return -1;
+		}
+		old->fmt.pix.width = fmt.fmt.pix_mp.width;
+		old->fmt.pix.height = fmt.fmt.pix_mp.height;
+		old->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
+		old->fmt.pix.field = fmt.fmt.pix_mp.field;
+		old->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
+		old->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
+		old->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
+
+		return 0;
+	}
+	case VIDIOC_ENUM_FMT: {
+		struct v4l2_fmtdesc *fmtdesc = arg;
+
+		fmtdesc->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		ret = SYS_DO_IOCTL(fd, cmd, fmtdesc);
+		fmtdesc->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+		return ret;
+	}
+	case VIDIOC_S_PARM:
+	case VIDIOC_G_PARM: {
+		struct v4l2_streamparm *parm = arg;
+
+		parm->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		ret = SYS_DO_IOCTL(fd, cmd, parm);
+		parm->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		return ret;
+	}
+	case VIDIOC_STREAMON:
+	case VIDIOC_STREAMOFF: {
+		int type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+
+		return SYS_DO_IOCTL(fd, cmd, &type);
+	}
+	case VIDIOC_CROPCAP: {
+		struct v4l2_cropcap *cropcap = arg;
+
+		cropcap->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		ret = SYS_DO_IOCTL(fd, cmd, cropcap);
+		cropcap->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		return ret;
+	}
+	case VIDIOC_S_CROP:
+	case VIDIOC_G_CROP: {
+		struct v4l2_crop *crop = arg;
+
+		crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		ret = SYS_DO_IOCTL(fd, cmd, crop);
+		crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		return ret;
+	}
+	case VIDIOC_REQBUFS: {
+		struct v4l2_requestbuffers *rq = arg;
+
+		rq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		ret = SYS_DO_IOCTL(fd, cmd, rq);
+		rq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		return ret;
+	}
+	case VIDIOC_QBUF:
+	case VIDIOC_DQBUF:
+	case VIDIOC_QUERYBUF: {
+		struct v4l2_buffer buf;
+		struct v4l2_buffer *old = arg;
+		struct v4l2_plane plane = { 0 };
+
+		memcpy(&buf, old, sizeof buf);
+		memcpy(&plane.m, &old->m, sizeof old->m);
+		plane.length = old->length;
+		plane.bytesused = old->bytesused;
+
+		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		buf.m.planes = &plane;
+		buf.length = 1;
+
+		ret = SYS_DO_IOCTL(fd, cmd, &buf);
+		if (ret)
+			return ret;
+
+		memcpy(old, &buf, sizeof buf);
+		old->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		memcpy(&old->m, &plane.m, sizeof plane.m);
+		old->length = plane.length;
+		old->bytesused = plane.bytesused;
+		return 0;
+	}
+
+	} /* switch brace */
+
+	/* handling not mplane ioctl */
+	return SYS_DO_IOCTL(fd, cmd, arg);
+}
 
 static int v4l2_request_read_buffers(int index)
 {
@@ -586,7 +747,7 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	}
 
 	/* check that this is an v4l2 device */
-	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap)) {
+	if (SYS_DO_IOCTL(fd, VIDIOC_QUERYCAP, &cap)) {
 		int saved_err = errno;
 
 		V4L2_LOG_ERR("getting capabilities: %s\n", strerror(errno));
@@ -595,35 +756,21 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	}
 
 	/* we only add functionality for video capture devices */
-	if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE) ||
-			!(cap.capabilities & (V4L2_CAP_STREAMING | V4L2_CAP_READWRITE)))
+	if (!(cap.capabilities &
+		(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_CAPTURE_MPLANE)))
 		return fd;
 
-	/* Get current cam format */
-	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	if (SYS_IOCTL(fd, VIDIOC_G_FMT, &fmt)) {
-		int saved_err = errno;
-
-		V4L2_LOG_ERR("getting pixformat: %s\n", strerror(errno));
-		errno = saved_err;
-		return -1;
-	}
-
-	/* Check for framerate setting support */
-	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	if (SYS_IOCTL(fd, VIDIOC_G_PARM, &parm))
-		parm.type = 0;
-
-	/* init libv4lconvert */
-	convert = v4lconvert_create(fd);
-	if (!convert)
-		return -1;
+	/* we only add functionality for video streaming and read/write devices */
+	if (!(cap.capabilities & (V4L2_CAP_STREAMING | V4L2_CAP_READWRITE)))
+		return fd;
 
 	/* So we have a v4l2 capture device, register it in our devices array */
 	pthread_mutex_lock(&v4l2_open_mutex);
 	for (index = 0; index < V4L2_MAX_DEVICES; index++)
 		if (devices[index].fd == -1) {
 			devices[index].fd = fd;
+			if (index >= devices_used)
+				devices_used = index + 1;
 			break;
 		}
 	pthread_mutex_unlock(&v4l2_open_mutex);
@@ -636,6 +783,31 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	}
 
 	devices[index].flags = v4l2_flags;
+	/* enabling conversion for driver that supports only multiplanar api */
+	if ((cap.capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE) &&
+		!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE))
+		devices[index].flags |= V4L2_CONVERT2MPLANE;
+
+	/* Get current cam format */
+	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	if (SYS_IOCTL(fd, VIDIOC_G_FMT, &fmt)) {
+		int saved_err = errno;
+
+		V4L2_LOG_ERR("getting pixformat: %s\n", strerror(errno));
+		errno = saved_err;
+		goto fail;
+	}
+
+	/* Check for framerate setting support */
+	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	if (SYS_IOCTL(fd, VIDIOC_G_PARM, &parm))
+		parm.type = 0;
+
+	/* init libv4lconvert */
+	convert = v4lconvert_create(fd);
+	if (!convert)
+		goto fail;
+
 	if (cap.capabilities & V4L2_CAP_READWRITE)
 		devices[index].flags |= V4L2_SUPPORTS_READ;
 	if (!(cap.capabilities & V4L2_CAP_STREAMING)) {
@@ -677,9 +849,6 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	devices[index].readbuf = NULL;
 	devices[index].readbuf_size = 0;
 
-	if (index >= devices_used)
-		devices_used = index + 1;
-
 	/* Note we always tell v4lconvert to optimize src fmt selection for
 	   our default fps, the only exception is the app explictly selecting
 	   a framerate using the S_PARM ioctl after a S_FMT */
@@ -689,6 +858,14 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	V4L2_LOG("open: %d\n", fd);
 
 	return fd;
+
+fail:
+	/* unregister device */
+	pthread_mutex_lock(&v4l2_open_mutex);
+	devices[index].fd = -1;
+	pthread_mutex_unlock(&v4l2_open_mutex);
+
+	return -1;
 }
 
 /* Is this an fd for which we are emulating v4l1 ? */
diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index 87028ef..9aaf20e 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -72,12 +72,13 @@ typedef off_t __off_t;
 
 #ifndef CONFIG_SYS_WRAPPER
 
+int v4l2_ioctl_mp(int fd, unsigned long cmd, void *arg) __attribute__ ((visibility("default")));
+
 #define SYS_OPEN(file, oflag, mode) \
 	syscall(SYS_open, (const char *)(file), (int)(oflag), (mode_t)(mode))
 #define SYS_CLOSE(fd) \
 	syscall(SYS_close, (int)(fd))
-#define SYS_IOCTL(fd, cmd, arg) \
-	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+#define SYS_IOCTL(fd, cmd, arg) v4l2_ioctl_mp(fd, cmd, arg)
 #define SYS_READ(fd, buf, len) \
 	syscall(SYS_read, (int)(fd), (void *)(buf), (size_t)(len));
 #define SYS_WRITE(fd, buf, len) \
-- 
1.7.5.4

