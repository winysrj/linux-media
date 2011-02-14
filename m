Return-path: <mchehab@pedra>
Received: from unknown.interbgc.com ([213.240.235.226]:35041 "EHLO
	extserv.mm-sol.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1BNLDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 06:03:40 -0500
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [PATCH 1/1 v3] libv4l: Add plugin support to libv4l
Date: Mon, 14 Feb 2011 13:02:20 +0200
Message-Id: <234f9f1fbf05f602d2a079962305e050976f1c58.1297680043.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1297680043.git.ykamenov@mm-sol.com>
References: <cover.1297680043.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1297680043.git.ykamenov@mm-sol.com>
References: <cover.1297680043.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A libv4l2 plugin will sit in between libv4l2 itself and the actual
/dev/video device node a fd refers to. It will be called each time
libv4l2 wants to do an operation (read/write/ioctl) on the actual
/dev/video node in question.

Signed-off-by: Yordan Kamenov <ykamenov@mm-sol.com>
---
 lib/include/libv4l2-plugin.h                   |   36 ++++++
 lib/include/libv4lconvert.h                    |    5 +-
 lib/libv4l2/Makefile                           |    4 +-
 lib/libv4l2/libv4l2-priv.h                     |   10 ++
 lib/libv4l2/libv4l2.c                          |   90 ++++++++++----
 lib/libv4l2/v4l2-plugin.c                      |  160 ++++++++++++++++++++++++
 lib/libv4l2/v4l2convert.c                      |    9 --
 lib/libv4lconvert/control/libv4lcontrol-priv.h |    4 +
 lib/libv4lconvert/control/libv4lcontrol.c      |   35 ++++--
 lib/libv4lconvert/control/libv4lcontrol.h      |    5 +-
 lib/libv4lconvert/libv4lconvert-priv.h         |    2 +
 lib/libv4lconvert/libv4lconvert.c              |   34 ++++--
 12 files changed, 333 insertions(+), 61 deletions(-)
 create mode 100644 lib/include/libv4l2-plugin.h
 create mode 100644 lib/libv4l2/v4l2-plugin.c

diff --git a/lib/include/libv4l2-plugin.h b/lib/include/libv4l2-plugin.h
new file mode 100644
index 0000000..5cb666a
--- /dev/null
+++ b/lib/include/libv4l2-plugin.h
@@ -0,0 +1,36 @@
+/*
+* Copyright (C) 2010 Nokia Corporation <multimedia@maemo.org>
+
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU Lesser General Public License as published by
+* the Free Software Foundation; either version 2.1 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+* Lesser General Public License for more details.
+*
+* You should have received a copy of the GNU Lesser General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#ifndef __LIBV4L2_PLUGIN_H
+#define __LIBV4L2_PLUGIN_H
+
+#include <sys/types.h>
+
+/* Structure libv4l2_dev_ops holds the calls from libv4ls to video nodes.
+   They can be normal open/close/ioctl etc. or any of them may be replaced
+   with a callback by a loaded plugin.
+*/
+
+struct libv4l2_dev_ops {
+    void * (*init)(int fd);
+    int (*close)(void *dev_ops_priv);
+    int (*ioctl)(void *dev_ops_priv, int fd, unsigned long int request, void *arg);
+    ssize_t (*read)(void *dev_ops_priv, int fd, void *buffer, size_t n);
+};
+
+#endif
diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
index 0264290..351142e 100644
--- a/lib/include/libv4lconvert.h
+++ b/lib/include/libv4lconvert.h
@@ -38,6 +38,8 @@
 
 #include <linux/videodev2.h>
 
+#include "libv4l2-plugin.h"
+
 #ifdef __cplusplus
 extern "C" {
 #endif /* __cplusplus */
@@ -50,7 +52,8 @@ extern "C" {
 
 struct v4lconvert_data;
 
-LIBV4L_PUBLIC struct v4lconvert_data *v4lconvert_create(int fd);
+LIBV4L_PUBLIC struct v4lconvert_data *v4lconvert_create(int fd,
+		void *dev_ops_priv, struct libv4l2_dev_ops *dev_ops);
 LIBV4L_PUBLIC void v4lconvert_destroy(struct v4lconvert_data *data);
 
 /* When doing flipping / rotating / video-processing, only supported
diff --git a/lib/libv4l2/Makefile b/lib/libv4l2/Makefile
index d78632f..eb1c019 100644
--- a/lib/libv4l2/Makefile
+++ b/lib/libv4l2/Makefile
@@ -1,8 +1,8 @@
 override CPPFLAGS += -I../include -fvisibility=hidden
 
-LIBS_libv4l2  = -lpthread
+LIBS_libv4l2  = -lpthread -ldl
 
-V4L2_OBJS     = libv4l2.o log.o
+V4L2_OBJS     = libv4l2.o v4l2-plugin.o log.o
 V4L2CONVERT   = v4l2convert.so
 V4L2CONVERT_O = v4l2convert.o libv4l2.so
 TARGETS       = $(V4L2_LIB) libv4l2.pc
diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index 46d6103..d06a508 100644
--- a/lib/libv4l2/libv4l2-priv.h
+++ b/lib/libv4l2/libv4l2-priv.h
@@ -85,8 +85,18 @@ struct v4l2_dev_info {
 	/* buffer when doing conversion and using read() for read() */
 	int readbuf_size;
 	unsigned char *readbuf;
+	struct libv4l2_dev_ops *dev_ops;
+	/* plugin info */
+	void *plugin_library;
+	void *dev_ops_priv;
 };
 
+void v4l2_plugin_init(int fd, void **plugin_lib_ret, void **plugin_priv_ret,
+					struct libv4l2_dev_ops **dev_ops_ret);
+void v4l2_plugin_cleanup(void *plugin_priv, void *plugin_lib,
+					struct libv4l2_dev_ops *dev_ops);
+
+
 /* From log.c */
 void v4l2_log_ioctl(unsigned long int request, void *arg, int result);
 
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index ab85ea7..2b717a8 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -67,6 +67,7 @@
 #include <sys/stat.h>
 #include "libv4l2.h"
 #include "libv4l2-priv.h"
+#include "libv4l2-plugin.h"
 
 /* Note these flags are stored together with the flags passed to v4l2_fd_open()
    in v4l2_dev_info's flags member, so care should be taken that the do not
@@ -102,7 +103,8 @@ static int v4l2_request_read_buffers(int index)
 		devices[index].nreadbuffers;
 	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	req.memory = V4L2_MEMORY_MMAP;
-	result = SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS, &req);
+	result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+			devices[index].fd, VIDIOC_REQBUFS, &req);
 	if (result < 0) {
 		int saved_err = errno;
 
@@ -131,7 +133,8 @@ static void v4l2_unrequest_read_buffers(int index)
 	req.count = 0;
 	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	req.memory = V4L2_MEMORY_MMAP;
-	if (SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS, &req) < 0)
+	if (devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+			devices[index].fd, VIDIOC_REQBUFS, &req) < 0)
 		return;
 
 	devices[index].no_frames = MIN(req.count, V4L2_MAX_NO_FRAMES);
@@ -152,7 +155,8 @@ static int v4l2_map_buffers(int index)
 		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		buf.memory = V4L2_MEMORY_MMAP;
 		buf.index = i;
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_QUERYBUF, &buf);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_QUERYBUF, &buf);
 		if (result) {
 			int saved_err = errno;
 
@@ -202,7 +206,8 @@ static int v4l2_streamon(int index)
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	if (!(devices[index].flags & V4L2_STREAMON)) {
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_STREAMON, &type);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_STREAMON, &type);
 		if (result) {
 			int saved_err = errno;
 
@@ -223,7 +228,8 @@ static int v4l2_streamoff(int index)
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	if (devices[index].flags & V4L2_STREAMON) {
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_STREAMOFF, &type);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_STREAMOFF, &type);
 		if (result) {
 			int saved_err = errno;
 
@@ -252,7 +258,8 @@ static int v4l2_queue_read_buffer(int index, int buffer_index)
 	buf.type   = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	buf.memory = V4L2_MEMORY_MMAP;
 	buf.index  = buffer_index;
-	result = SYS_IOCTL(devices[index].fd, VIDIOC_QBUF, &buf);
+	result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+			devices[index].fd, VIDIOC_QBUF, &buf);
 	if (result) {
 		int saved_err = errno;
 
@@ -277,7 +284,8 @@ static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
 		return result;
 
 	do {
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_DQBUF, buf);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_DQBUF, buf);
 		if (result) {
 			if (errno != EAGAIN) {
 				int saved_err = errno;
@@ -356,7 +364,8 @@ static int v4l2_read_and_convert(int index, unsigned char *dest, int dest_size)
 	}
 
 	do {
-		result = SYS_READ(devices[index].fd, devices[index].readbuf, buf_size);
+		result = devices[index].dev_ops->read(devices[index].dev_ops_priv,
+				devices[index].fd, devices[index].readbuf, buf_size);
 		if (result <= 0) {
 			if (result && errno != EAGAIN) {
 				int saved_err = errno;
@@ -496,7 +505,8 @@ static int v4l2_buffers_mapped(int index)
 			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 			buf.memory = V4L2_MEMORY_MMAP;
 			buf.index = i;
-			if (SYS_IOCTL(devices[index].fd, VIDIOC_QUERYBUF, &buf)) {
+			if (devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+					devices[index].fd, VIDIOC_QUERYBUF, &buf)) {
 				int saved_err = errno;
 
 				V4L2_LOG_ERR("querying buffer %u: %s\n", i, strerror(errno));
@@ -561,6 +571,11 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	struct v4l2_capability cap;
 	struct v4l2_format fmt;
 	struct v4lconvert_data *convert;
+	struct libv4l2_dev_ops *dev_ops;
+	void *plugin_library;
+	void *plugin_data;
+
+	v4l2_plugin_init(fd, &plugin_library, &plugin_data, &dev_ops);
 
 	/* If no log file was set by the app, see if one was specified through the
 	   environment */
@@ -571,9 +586,10 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	}
 
 	/* check that this is an v4l2 device */
-	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap)) {
+	if (dev_ops->ioctl(plugin_data, fd, VIDIOC_QUERYCAP, &cap)) {
 		int saved_err = errno;
 
+		v4l2_plugin_cleanup(plugin_data, plugin_library, dev_ops);
 		V4L2_LOG_ERR("getting capabilities: %s\n", strerror(errno));
 		errno = saved_err;
 		return -1;
@@ -581,29 +597,38 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 
 	/* we only add functionality for video capture devices */
 	if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE) ||
-			!(cap.capabilities & (V4L2_CAP_STREAMING | V4L2_CAP_READWRITE)))
+			!(cap.capabilities & (V4L2_CAP_STREAMING | V4L2_CAP_READWRITE))) {
+		v4l2_plugin_cleanup(plugin_data, plugin_library, dev_ops);
 		return fd;
+	}
 
 	/* Get current cam format */
 	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	if (SYS_IOCTL(fd, VIDIOC_G_FMT, &fmt)) {
+	if (dev_ops->ioctl(plugin_data, fd, VIDIOC_G_FMT, &fmt)) {
 		int saved_err = errno;
 
+		v4l2_plugin_cleanup(plugin_data, plugin_library, dev_ops);
 		V4L2_LOG_ERR("getting pixformat: %s\n", strerror(errno));
 		errno = saved_err;
 		return -1;
 	}
 
 	/* init libv4lconvert */
-	convert = v4lconvert_create(fd);
-	if (!convert)
+	convert = v4lconvert_create(fd, plugin_data, dev_ops);
+	if (!convert) {
+		v4l2_plugin_cleanup(plugin_data, plugin_library, dev_ops);
 		return -1;
+	}
 
 	/* So we have a v4l2 capture device, register it in our devices array */
 	pthread_mutex_lock(&v4l2_open_mutex);
 	for (index = 0; index < V4L2_MAX_DEVICES; index++)
 		if (devices[index].fd == -1) {
 			devices[index].fd = fd;
+
+			devices[index].plugin_library = plugin_library;
+			devices[index].dev_ops_priv = plugin_data;
+			devices[index].dev_ops = dev_ops;
 			break;
 		}
 	pthread_mutex_unlock(&v4l2_open_mutex);
@@ -611,6 +636,7 @@ int v4l2_fd_open(int fd, int v4l2_flags)
 	if (index == V4L2_MAX_DEVICES) {
 		V4L2_LOG_ERR("attempting to open more then %d video devices\n",
 				V4L2_MAX_DEVICES);
+		v4l2_plugin_cleanup(plugin_data, plugin_library, dev_ops);
 		errno = EBUSY;
 		return -1;
 	}
@@ -690,6 +716,9 @@ int v4l2_close(int fd)
 	if (index == -1)
 		return SYS_CLOSE(fd);
 
+	v4l2_plugin_cleanup(devices[index].dev_ops_priv,
+			devices[index].plugin_library, devices[index].dev_ops);
+
 	/* Abuse stream_lock to stop 2 closes from racing and trying to free the
 	   resources twice */
 	pthread_mutex_lock(&devices[index].stream_lock);
@@ -808,6 +837,7 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 	va_list ap;
 	int result, index, saved_err;
 	int is_capture_request = 0, stream_needs_locking = 0;
+	void *plugin_data;
 
 	va_start(ap, request);
 	arg = va_arg(ap, void *);
@@ -817,6 +847,7 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 	if (index == -1)
 		return SYS_IOCTL(fd, request, arg);
 
+	plugin_data = devices[index].dev_ops_priv;
 	/* Appearantly the kernel and / or glibc ignore the 32 most significant bits
 	   when long = 64 bits, and some applications pass an int holding the req to
 	   ioctl, causing it to get sign extended, depending upon this behavior */
@@ -879,7 +910,7 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 	}
 
 	if (!is_capture_request) {
-		result = SYS_IOCTL(fd, request, arg);
+		result = devices[index].dev_ops->ioctl(plugin_data, fd, request, arg);
 		saved_err = errno;
 		v4l2_log_ioctl(request, arg, result);
 		errno = saved_err;
@@ -927,7 +958,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 	case VIDIOC_QUERYCAP: {
 		struct v4l2_capability *cap = arg;
 
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_QUERYCAP, cap);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_QUERYCAP, cap);
 		if (result == 0)
 			/* We always support read() as we fake it using mmap mode */
 			cap->capabilities |= V4L2_CAP_READWRITE;
@@ -977,8 +1009,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 		}
 
 		if (devices[index].flags & V4L2_DISABLE_CONVERSION) {
-			result = SYS_IOCTL(devices[index].fd, VIDIOC_TRY_FMT,
-					dest_fmt);
+			result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+					devices[index].fd, VIDIOC_TRY_FMT, dest_fmt);
 			src_fmt = *dest_fmt;
 		} else {
 			result = v4lconvert_try_format(devices[index].convert, dest_fmt,
@@ -1018,7 +1050,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 			break;
 
 		req_pix_fmt = src_fmt.fmt.pix;
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_S_FMT, &src_fmt);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_S_FMT, &src_fmt);
 		if (result) {
 			saved_err = errno;
 			V4L2_LOG_ERR("setting pixformat: %s\n", strerror(errno));
@@ -1067,7 +1100,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 		if (req->count > V4L2_MAX_NO_FRAMES)
 			req->count = V4L2_MAX_NO_FRAMES;
 
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS, req);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_REQBUFS, req);
 		if (result < 0)
 			break;
 		result = 0; /* some drivers return the number of buffers on success */
@@ -1088,7 +1122,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 
 		/* Do a real query even when converting to let the driver fill in
 		   things like buf->field */
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_QUERYBUF, buf);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_QUERYBUF, buf);
 		if (result || !v4l2_needs_conversion(index))
 			break;
 
@@ -1115,7 +1150,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 				break;
 		}
 
-		result = SYS_IOCTL(devices[index].fd, VIDIOC_QBUF, arg);
+		result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+				devices[index].fd, VIDIOC_QBUF, arg);
 		break;
 
 	case VIDIOC_DQBUF: {
@@ -1128,7 +1164,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 		}
 
 		if (!v4l2_needs_conversion(index)) {
-			result = SYS_IOCTL(devices[index].fd, VIDIOC_DQBUF, buf);
+			result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+					devices[index].fd, VIDIOC_DQBUF, buf);
 			if (result) {
 				int saved_err = errno;
 
@@ -1187,7 +1224,7 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 		break;
 
 	default:
-		result = SYS_IOCTL(fd, request, arg);
+		result = devices[index].dev_ops->ioctl(plugin_data, fd, request, arg);
 		break;
 	}
 
@@ -1206,18 +1243,21 @@ ssize_t v4l2_read(int fd, void *dest, size_t n)
 {
 	ssize_t result;
 	int saved_errno;
+	void *plugin_data;
 	int index = v4l2_get_index(fd);
 
 	if (index == -1)
 		return SYS_READ(fd, dest, n);
 
+	plugin_data = devices[index].dev_ops_priv;
+
 	pthread_mutex_lock(&devices[index].stream_lock);
 
 	/* When not converting and the device supports read let the kernel handle
 	   it */
 	if ((devices[index].flags & V4L2_SUPPORTS_READ) &&
 			!v4l2_needs_conversion(index)) {
-		result = SYS_READ(fd, dest, n);
+		result = devices[index].dev_ops->read(plugin_data, fd, dest, n);
 		goto leave;
 	}
 
diff --git a/lib/libv4l2/v4l2-plugin.c b/lib/libv4l2/v4l2-plugin.c
new file mode 100644
index 0000000..89bffc5
--- /dev/null
+++ b/lib/libv4l2/v4l2-plugin.c
@@ -0,0 +1,160 @@
+/*
+* Copyright (C) 2010 Nokia Corporation <multimedia@maemo.org>
+
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU Lesser General Public License as published by
+* the Free Software Foundation; either version 2.1 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+* Lesser General Public License for more details.
+*
+* You should have received a copy of the GNU Lesser General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#include <stdarg.h>
+#include <dlfcn.h>
+#include <fcntl.h>
+#include <glob.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include "libv4l2.h"
+#include "libv4l2-priv.h"
+#include "libv4l2-plugin.h"
+
+/* libv4l plugin support:
+   it is provided by functions v4l2_plugin_[open,close,etc].
+
+   When open() is called libv4l dlopens files in /usr/lib[64]/libv4l/plugins
+   1 at a time and call open callback passing through the applications
+   parameters unmodified.
+
+   If a plugin is relevant for the specified device node, it can indicate so
+   by returning a value other then -1 (the actual file descriptor).
+   As soon as a plugin returns another value then -1 plugin loading stops and
+   information about it (fd and corresponding library handle) is stored. For
+   each function v4l2_[ioctl,read,close,etc] is called corresponding
+   v4l2_plugin_* function which looks if there is loaded plugin for that file
+   and call it's callbacks.
+
+   v4l2_plugin_* function indicates by it's first argument if plugin was used,
+   and if it was not then v4l2_* functions proceed with their usual behavior.
+*/
+
+#define PLUGINS_PATTERN "/usr/lib/libv4l/plugins/*.so"
+
+static void * dev_init(int fd)
+{
+	return NULL;
+}
+
+static int dev_close(void *dev_ops_priv)
+{
+	return -1;
+}
+
+static int dev_ioctl(void *dev_ops_priv, int fd, unsigned long cmd, void *arg)
+{
+	return syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd),
+			(void *)(arg));
+}
+
+static ssize_t dev_read(void *dev_ops_priv, int fd, void *buf, size_t len)
+{
+	return syscall(SYS_read, (int)(fd), (void *)(buf), (size_t)(len));
+}
+
+
+struct libv4l2_dev_ops default_operations = {
+	.init = &dev_init,
+	.close = &dev_close,
+	.ioctl = &dev_ioctl,
+	.read = &dev_read
+};
+
+void v4l2_plugin_init(int fd, void **plugin_lib_ret, void **plugin_priv_ret,
+					struct libv4l2_dev_ops **dev_ops_ret)
+{
+	char *error;
+	int glob_ret, plugin_num;
+	void *plugin_library = NULL;
+	struct libv4l2_dev_ops *libv4l2_plugin = NULL;
+	glob_t globbuf;
+
+	*dev_ops_ret = &default_operations;
+
+	glob_ret = glob(PLUGINS_PATTERN, 0, NULL, &globbuf);
+
+	if (glob_ret == GLOB_NOSPACE) {
+		*plugin_lib_ret = NULL;
+		*plugin_priv_ret = NULL;
+		return;
+	}
+
+	if (glob_ret == GLOB_ABORTED || glob_ret == GLOB_NOMATCH) {
+		*plugin_lib_ret = NULL;
+		*plugin_priv_ret = NULL;
+		goto leave;
+	}
+
+	for (plugin_num = 0; plugin_num < globbuf.gl_pathc; plugin_num++) {
+
+		V4L2_LOG("PLUGIN: dlopen(%s);\n", globbuf.gl_pathv[plugin_num]);
+
+		plugin_library = dlopen(globbuf.gl_pathv[plugin_num],
+							RTLD_LAZY);
+
+		if (!plugin_library)
+			continue;
+
+		dlerror();    /* Clear any existing error */
+		libv4l2_plugin = (struct libv4l2_dev_ops *)
+					dlsym(plugin_library, "libv4l2_plugin");
+
+		error = dlerror();
+		if (error != NULL)  {
+			V4L2_LOG_ERR("PLUGIN: dlsym failed: %s\n", error);
+			dlclose(plugin_library);
+
+			continue;
+		}
+
+		*plugin_priv_ret = NULL;
+		if (libv4l2_plugin->init)
+			*plugin_priv_ret = libv4l2_plugin->init(fd);
+
+		if (!*plugin_priv_ret) {
+			V4L2_LOG("PLUGIN: plugin open() returned NULL\n");
+			dlclose(plugin_library);
+			*plugin_lib_ret = NULL;
+			continue;
+		}
+
+		(*dev_ops_ret)->init = libv4l2_plugin->init;
+		if (libv4l2_plugin->close != NULL)
+			(*dev_ops_ret)->close = libv4l2_plugin->close;
+		if (libv4l2_plugin->ioctl != NULL)
+			(*dev_ops_ret)->ioctl = libv4l2_plugin->ioctl;
+		if (libv4l2_plugin->read != NULL)
+			(*dev_ops_ret)->read = libv4l2_plugin->read;
+
+		break;
+
+	}
+
+leave:
+	globfree(&globbuf);
+}
+
+void v4l2_plugin_cleanup(void *plugin_priv, void *plugin_lib,
+					struct libv4l2_dev_ops *dev_ops)
+{
+	if (plugin_priv) {
+		dev_ops->close(plugin_priv);
+		dlclose(plugin_lib);
+	}
+}
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index e251085..03f34ad 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -46,7 +46,6 @@
 LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 {
 	int fd;
-	struct v4l2_capability cap;
 	int v4l_device = 0;
 
 	/* check if we're opening a video4linux2 device */
@@ -76,14 +75,6 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 	if (fd == -1 || !v4l_device)
 		return fd;
 
-	/* check that this is an v4l2 device, libv4l2 only supports v4l2 devices */
-	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap))
-		return fd;
-
-	/* libv4l2 only adds functionality to capture capable devices */
-	if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE))
-		return fd;
-
 	/* Try to Register with libv4l2 (in case of failure pass the fd to the
 	   application as is) */
 	v4l2_fd_open(fd, 0);
diff --git a/lib/libv4lconvert/control/libv4lcontrol-priv.h b/lib/libv4lconvert/control/libv4lcontrol-priv.h
index 22cdf34..1259e6b 100644
--- a/lib/libv4lconvert/control/libv4lcontrol-priv.h
+++ b/lib/libv4lconvert/control/libv4lcontrol-priv.h
@@ -22,6 +22,8 @@
 #ifndef __LIBV4LCONTROL_PRIV_H
 #define __LIBV4LCONTROL_PRIV_H
 
+#include "libv4l2-plugin.h"
+
 #define V4LCONTROL_SHM_SIZE 4096
 
 #define V4LCONTROL_SUPPORTS_NEXT_CTRL 0x01
@@ -37,6 +39,8 @@ struct v4lcontrol_data {
 	unsigned int *shm_values; /* shared memory control value store */
 	unsigned int old_values[V4LCONTROL_COUNT]; /* for controls_changed() */
 	const struct v4lcontrol_flags_info *flags_info;
+	struct libv4l2_dev_ops *dev_ops;
+	void *dev_ops_priv;
 };
 
 struct v4lcontrol_flags_info {
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 6a09d38..2ef642c 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -701,7 +701,8 @@ static void v4lcontrol_get_flags_from_db(struct v4lcontrol_data *data,
 		}
 }
 
-struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
+struct v4lcontrol_data *v4lcontrol_create(int fd, void *dev_ops_priv,
+		struct libv4l2_dev_ops *dev_ops, int always_needs_conversion)
 {
 	int shm_fd;
 	int i, rc, got_usb_ids, init = 0;
@@ -721,10 +722,12 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
 	}
 
 	data->fd = fd;
+	data->dev_ops = dev_ops;
+	data->dev_ops_priv = dev_ops_priv;
 
 	/* Check if the driver has indicated some form of flipping is needed */
-	if ((SYS_IOCTL(data->fd, VIDIOC_G_INPUT, &input.index) == 0) &&
-			(SYS_IOCTL(data->fd, VIDIOC_ENUMINPUT, &input) == 0)) {
+	if ((data->dev_ops->ioctl(data->dev_ops_priv, data->fd, VIDIOC_G_INPUT, &input.index) == 0) &&
+			(data->dev_ops->ioctl(data->dev_ops_priv, data->fd, VIDIOC_ENUMINPUT, &input) == 0)) {
 		if (input.status & V4L2_IN_ST_HFLIP)
 			data->flags |= V4LCONTROL_HFLIPPED;
 		if (input.status & V4L2_IN_ST_VFLIP)
@@ -741,7 +744,8 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
 		data->flags = strtol(s, NULL, 0);
 
 	ctrl.id = V4L2_CTRL_FLAG_NEXT_CTRL;
-	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &ctrl) == 0)
+	if (data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+			VIDIOC_QUERYCTRL, &ctrl) == 0)
 		data->priv_flags |= V4LCONTROL_SUPPORTS_NEXT_CTRL;
 
 	/* If the device always needs conversion, we can add fake controls at no cost
@@ -749,7 +753,8 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
 	if (always_needs_conversion || v4lcontrol_needs_conversion(data)) {
 		for (i = 0; i < V4LCONTROL_AUTO_ENABLE_COUNT; i++) {
 			ctrl.id = fake_controls[i].id;
-			rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &ctrl);
+			rc = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+					VIDIOC_QUERYCTRL, &ctrl);
 			if (rc == -1 || (rc == 0 && (ctrl.flags & V4L2_CTRL_FLAG_DISABLED)))
 				data->controls |= 1 << i;
 		}
@@ -761,17 +766,20 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
 	   different sensors with / without autogain or the necessary controls. */
 	while (data->flags & V4LCONTROL_WANTS_AUTOGAIN) {
 		ctrl.id = V4L2_CID_AUTOGAIN;
-		rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &ctrl);
+		rc = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+				VIDIOC_QUERYCTRL, &ctrl);
 		if (rc == 0 && !(ctrl.flags & V4L2_CTRL_FLAG_DISABLED))
 			break;
 
 		ctrl.id = V4L2_CID_EXPOSURE;
-		rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &ctrl);
+		rc = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+				VIDIOC_QUERYCTRL, &ctrl);
 		if (rc != 0 || (ctrl.flags & V4L2_CTRL_FLAG_DISABLED))
 			break;
 
 		ctrl.id = V4L2_CID_GAIN;
-		rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &ctrl);
+		rc = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+				VIDIOC_QUERYCTRL, &ctrl);
 		if (rc != 0 || (ctrl.flags & V4L2_CTRL_FLAG_DISABLED))
 			break;
 
@@ -788,7 +796,7 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
 	if (data->controls == 0)
 		return data; /* No need to create a shared memory segment */
 
-	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap)) {
+	if (data->dev_ops->ioctl(data->dev_ops_priv, fd, VIDIOC_QUERYCAP, &cap)) {
 		perror("libv4lcontrol: error querying device capabilities");
 		goto error;
 	}
@@ -974,7 +982,8 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data *data, void *arg)
 		}
 
 	/* find out what the kernel driver would respond. */
-	retval = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, arg);
+	retval = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+			VIDIOC_QUERYCTRL, arg);
 
 	if ((data->priv_flags & V4LCONTROL_SUPPORTS_NEXT_CTRL) &&
 			(orig_id & V4L2_CTRL_FLAG_NEXT_CTRL)) {
@@ -1011,7 +1020,8 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *data, void *arg)
 			return 0;
 		}
 
-	return SYS_IOCTL(data->fd, VIDIOC_G_CTRL, arg);
+	return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+			VIDIOC_G_CTRL, arg);
 }
 
 int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
@@ -1032,7 +1042,8 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
 			return 0;
 		}
 
-	return SYS_IOCTL(data->fd, VIDIOC_S_CTRL, arg);
+	return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+			VIDIOC_S_CTRL, arg);
 }
 
 int v4lcontrol_get_flags(struct v4lcontrol_data *data)
diff --git a/lib/libv4lconvert/control/libv4lcontrol.h b/lib/libv4lconvert/control/libv4lcontrol.h
index 974e97a..1c09546 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.h
+++ b/lib/libv4lconvert/control/libv4lcontrol.h
@@ -22,6 +22,8 @@
 #ifndef __LIBV4LCONTROL_H
 #define __LIBV4LCONTROL_H
 
+#include "libv4l2-plugin.h"
+
 /* Flags */
 #define V4LCONTROL_HFLIPPED              0x01
 #define V4LCONTROL_VFLIPPED              0x02
@@ -47,7 +49,8 @@ enum {
 
 struct v4lcontrol_data;
 
-struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion);
+struct v4lcontrol_data *v4lcontrol_create(int fd, void *dev_ops_priv,
+		struct libv4l2_dev_ops *dev_ops, int always_needs_conversion);
 void v4lcontrol_destroy(struct v4lcontrol_data *data);
 
 /* Functions used by v4lprocessing to get the control state */
diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index d8fe899..edc118b 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -65,6 +65,8 @@ struct v4lconvert_data {
 	unsigned char *convert_pixfmt_buf;
 	struct v4lcontrol_data *control;
 	struct v4lprocessing_data *processing;
+	struct libv4l2_dev_ops *dev_ops;
+	void *dev_ops_priv;
 
 	/* Data for external decompression helpers code */
 	pid_t decompress_pid;
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 0d8b29f..f6e0327 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -91,7 +91,8 @@ static const int v4lconvert_crop_res[][2] = {
 	{ 176, 144 },
 };
 
-struct v4lconvert_data *v4lconvert_create(int fd)
+struct v4lconvert_data *v4lconvert_create(int fd, void *dev_ops_priv,
+		struct libv4l2_dev_ops *dev_ops)
 {
 	int i, j;
 	struct v4lconvert_data *data = calloc(1, sizeof(struct v4lconvert_data));
@@ -107,6 +108,8 @@ struct v4lconvert_data *v4lconvert_create(int fd)
 	}
 
 	data->fd = fd;
+	data->dev_ops = dev_ops;
+	data->dev_ops_priv = dev_ops_priv;
 	data->decompress_pid = -1;
 
 	/* Check supported formats */
@@ -115,7 +118,7 @@ struct v4lconvert_data *v4lconvert_create(int fd)
 
 		fmt.index = i;
 
-		if (SYS_IOCTL(data->fd, VIDIOC_ENUM_FMT, &fmt))
+		if (data->dev_ops->ioctl(data->dev_ops_priv, data->fd, VIDIOC_ENUM_FMT, &fmt))
 			break;
 
 		for (j = 0; j < ARRAY_SIZE(supported_src_pixfmts); j++)
@@ -134,7 +137,8 @@ struct v4lconvert_data *v4lconvert_create(int fd)
 	data->no_formats = i;
 
 	/* Check if this cam has any special flags */
-	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCAP, &cap) == 0) {
+	if (data->dev_ops->ioctl(data->dev_ops_priv,
+					data->fd, VIDIOC_QUERYCAP, &cap) == 0) {
 		if (!strcmp((char *)cap.driver, "uvcvideo"))
 			data->flags |= V4LCONVERT_IS_UVC;
 
@@ -142,7 +146,8 @@ struct v4lconvert_data *v4lconvert_create(int fd)
 			always_needs_conversion = 0;
 	}
 
-	data->control = v4lcontrol_create(fd, always_needs_conversion);
+	data->control = v4lcontrol_create(fd, dev_ops_priv, dev_ops,
+						always_needs_conversion);
 	if (!data->control) {
 		free(data);
 		return NULL;
@@ -205,7 +210,8 @@ int v4lconvert_enum_fmt(struct v4lconvert_data *data, struct v4l2_fmtdesc *fmt)
 	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
 			(!v4lconvert_supported_dst_fmt_only(data) &&
 			 fmt->index < data->no_formats))
-		return SYS_IOCTL(data->fd, VIDIOC_ENUM_FMT, fmt);
+		return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+						VIDIOC_ENUM_FMT, fmt);
 
 	for (i = 0; i < ARRAY_SIZE(supported_dst_pixfmts); i++)
 		if (v4lconvert_supported_dst_fmt_only(data) ||
@@ -313,7 +319,8 @@ static int v4lconvert_do_try_format(struct v4lconvert_data *data,
 		try_fmt = *dest_fmt;
 		try_fmt.fmt.pix.pixelformat = supported_src_pixfmts[i].fmt;
 
-		if (!SYS_IOCTL(data->fd, VIDIOC_TRY_FMT, &try_fmt)) {
+		if (!data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+						VIDIOC_TRY_FMT, &try_fmt)) {
 			if (try_fmt.fmt.pix.pixelformat == supported_src_pixfmts[i].fmt) {
 				int size_x_diff = abs((int)try_fmt.fmt.pix.width -
 						(int)dest_fmt->fmt.pix.width);
@@ -381,7 +388,8 @@ int v4lconvert_try_format(struct v4lconvert_data *data,
 	if (!v4lconvert_supported_dst_format(dest_fmt->fmt.pix.pixelformat) ||
 			dest_fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
 			v4lconvert_do_try_format(data, &try_dest, &try_src)) {
-		result = SYS_IOCTL(data->fd, VIDIOC_TRY_FMT, dest_fmt);
+		result = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+							VIDIOC_TRY_FMT, dest_fmt);
 		if (src_fmt)
 			*src_fmt = *dest_fmt;
 		return result;
@@ -1236,7 +1244,8 @@ static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
 
 	for (i = 0; ; i++) {
 		frmsize.index = i;
-		if (SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMESIZES, &frmsize))
+		if (data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+					VIDIOC_ENUM_FRAMESIZES, &frmsize))
 			break;
 
 		/* We got a framesize, check we don't have the same one already */
@@ -1296,7 +1305,8 @@ int v4lconvert_enum_framesizes(struct v4lconvert_data *data,
 			errno = EINVAL;
 			return -1;
 		}
-		return SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMESIZES, frmsize);
+		return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+						VIDIOC_ENUM_FRAMESIZES, frmsize);
 	}
 
 	if (frmsize->index >= data->no_framesizes) {
@@ -1332,7 +1342,8 @@ int v4lconvert_enum_frameintervals(struct v4lconvert_data *data,
 			errno = EINVAL;
 			return -1;
 		}
-		res = SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMEINTERVALS, frmival);
+		res = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+				VIDIOC_ENUM_FRAMEINTERVALS, frmival);
 		if (res)
 			V4LCONVERT_ERR("%s\n", strerror(errno));
 		return res;
@@ -1377,7 +1388,8 @@ int v4lconvert_enum_frameintervals(struct v4lconvert_data *data,
 	frmival->pixel_format = src_fmt.fmt.pix.pixelformat;
 	frmival->width = src_fmt.fmt.pix.width;
 	frmival->height = src_fmt.fmt.pix.height;
-	res = SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMEINTERVALS, frmival);
+	res = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+			VIDIOC_ENUM_FRAMEINTERVALS, frmival);
 	if (res) {
 		int dest_pixfmt = dest_fmt.fmt.pix.pixelformat;
 		int src_pixfmt  = src_fmt.fmt.pix.pixelformat;
-- 
1.7.3.1

