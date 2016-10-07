Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:45914 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S936513AbcJGRA0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 13:00:26 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 1/3] add a libv4l plugin for st-delta video decoder
Date: Fri, 7 Oct 2016 19:00:16 +0200
Message-ID: <1475859618-829-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1475859618-829-1-git-send-email-hugues.fruchet@st.com>
References: <1475859618-829-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ST DELTA video decoder is a frame API based decoder
which requires headers metadata in addition to compressed
video bitstream data.
This libv4l plugin aims to abstract DELTA frame API under
usual stream API, so compatibility with existing V4L2-based
frameworks such as GStreamer is ensured.
To do so, S_FMT(OUTPUT) call is intercepted to detect the format
of video bitstream and so select the right parser to be used.
REQBUFS/QUERYBUF(OUTPUT) calls are intercepted in order to mmap each
buffer containing video bitstream to be parsed and associate to each
buffer a metadata space where to store the corresponding headers.
QBUF(OUTPUT) call is then intercepted to get the metadata headers
by parsing input buffer and send those metadata to V4L2 kernel
driver using V4L2 control & request API.

Change-Id: I524e1e4a5746c7a678a1cdbc5dac56af16f7c863
signed-off-by: Tiphaine Inguere <tifaine.inguere@st.com>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac                        |   2 +
 lib/Makefile.am                     |   3 +-
 lib/libv4l-delta/Makefile.am        |   9 +
 lib/libv4l-delta/libv4l-delta.c     | 344 ++++++++++++++++++++++++++++++++++++
 lib/libv4l-delta/libv4l-delta.h     |  97 ++++++++++
 lib/libv4l-delta/libv4l-delta.pc.in |  12 ++
 6 files changed, 466 insertions(+), 1 deletion(-)
 create mode 100644 lib/libv4l-delta/Makefile.am
 create mode 100644 lib/libv4l-delta/libv4l-delta.c
 create mode 100644 lib/libv4l-delta/libv4l-delta.h
 create mode 100644 lib/libv4l-delta/libv4l-delta.pc.in

diff --git a/configure.ac b/configure.ac
index 84199a3..bb656fd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -18,6 +18,7 @@ AC_CONFIG_FILES([Makefile
 	lib/libv4l2rds/Makefile
 	lib/libv4l-mplane/Makefile
 	lib/libv4l-hva/Makefile
+	lib/libv4l-delta/Makefile
 
 	utils/Makefile
 	utils/libv4l2util/Makefile
@@ -43,6 +44,7 @@ AC_CONFIG_FILES([Makefile
 	lib/libv4lconvert/libv4lconvert.pc
 	lib/libv4l1/libv4l1.pc
 	lib/libv4l2/libv4l2.pc
+	lib/libv4l-delta/libv4l-delta.pc
 	lib/libdvbv5/libdvbv5.pc
 	lib/libv4l2rds/libv4l2rds.pc
 	utils/media-ctl/libmediactl.pc
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 38914bb..cf5ce03 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -3,10 +3,11 @@ SUBDIRS = \
 	libv4l2 \
 	libv4l1 \
 	libv4l2rds \
+	libv4l-delta \
 	libv4l-mplane \
 	libv4l-hva
 
 if LINUX_OS
 SUBDIRS += \
 	libdvbv5
-endif
+endif
\ No newline at end of file
diff --git a/lib/libv4l-delta/Makefile.am b/lib/libv4l-delta/Makefile.am
new file mode 100644
index 0000000..0ec1dd7
--- /dev/null
+++ b/lib/libv4l-delta/Makefile.am
@@ -0,0 +1,9 @@
+if WITH_V4L_PLUGINS
+libv4l2plugin_LTLIBRARIES = libv4l-delta.la
+endif
+
+libv4l_delta_la_SOURCES = libv4l-delta.c libv4l-delta.h
+
+libv4l_delta_la_CPPFLAGS = $(CFLAG_VISIBILITY)
+libv4l_delta_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
+libv4l_delta_la_LIBADD = ../libv4l2/libv4l2.la
diff --git a/lib/libv4l-delta/libv4l-delta.c b/lib/libv4l-delta/libv4l-delta.c
new file mode 100644
index 0000000..aa33e94
--- /dev/null
+++ b/lib/libv4l-delta/libv4l-delta.c
@@ -0,0 +1,344 @@
+/*
+ * libv4l-delta.c
+ *
+ * Copyright (C) STMicroelectronics SA 2016
+ * Authors: Tifaine Inguere <tifaine.inguere@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ *          for STMicroelectronics.
+ */
+
+/*
+ *             (C) 2012 Mauro Carvalho Chehab
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
+ */
+
+#include <config.h>
+#include <errno.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../libv4lconvert/libv4lsyscall-priv.h"
+#include "libv4l-plugin.h"
+#include "libv4l-delta.h"
+
+#if HAVE_VISIBILITY
+#define PLUGIN_PUBLIC __attribute__ ((visibility("default")))
+#else
+#define PLUGIN_PUBLIC
+#endif
+
+
+#define type_to_str(type) ((type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ? "OUTPUT" : \
+	((type == V4L2_BUF_TYPE_VIDEO_CAPTURE) ? "CAPTURE" : "?"))
+
+/* available metadata builders */
+const struct delta_metadata *delta_meta[] = {
+
+};
+
+static void *delta_plugin_init(int fd)
+{
+	struct delta_plugin *delta = NULL;
+	struct v4l2_capability cap;
+	int ret;
+
+	DELTA_LOG_DEBUG("> %s\n", __func__);
+
+	/* check if device needs delta plugin */
+	memset(&cap, 0, sizeof(cap));
+	ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap);
+	if (ret) {
+		DELTA_LOG_ERR("%s: failed to query video capabilities\n",
+			      __func__);
+		goto out;
+	}
+
+	if (strstr((const char *)cap.driver, (const char *)DELTA_NAME) == NULL) {
+		DELTA_LOG_INFO("%s: the %s device doesn't need the DELTA libv4l"
+			       " plugin\n", __func__, cap.driver);
+		goto out;
+	}
+
+	DELTA_LOG_INFO("%s: the %s device needs the DELTA libv4l plugin\n",
+		       __func__, cap.driver);
+
+	/* allocate and initialize private data */
+	delta = calloc(1, sizeof(struct delta_plugin));
+	if (!delta) {
+		DELTA_LOG_ERR
+		    ("%s: couldn't allocate memory for the DELTA libv4l"
+		     " plugin\n", __func__);
+		goto out;
+	}
+
+out:
+	DELTA_LOG_DEBUG("< %s: delta %p\n", __func__, delta);
+	return delta;
+}
+
+static void delta_plugin_close(void *dev_ops_priv)
+{
+	struct delta_plugin *delta = dev_ops_priv;
+	unsigned int i;
+
+	DELTA_LOG_DEBUG("> %s: delta %p\n", __func__, delta);
+
+	DELTA_LOG_INFO("%s: close the DELTA libv4l plugin\n", __func__);
+
+	if (delta != NULL) {
+		struct delta_buffer_info *buf_info = delta->buffer_info;
+
+		if (buf_info) {
+			for (i = 0; i < delta->buffer_nb; i++) {
+				/* unmap AU */
+				if (buf_info[i].au_addr)
+					SYS_MUNMAP(buf_info[i].au_addr,
+						   buf_info[i].au_size);
+
+				/* free metadata */
+				if (buf_info[i].meta)
+					free(buf_info[i].meta);
+			}
+
+			free(buf_info);
+		}
+
+		free(delta);
+	}
+
+	DELTA_LOG_DEBUG("< %s\n", __func__);
+	return;
+}
+
+static int delta_s_fmt(struct delta_plugin *delta, int fd,
+				       unsigned long int cmd, struct v4l2_format *format)
+{
+	unsigned int i;
+	int ret = -EINVAL;
+
+	DELTA_LOG_DEBUG("> %s: set format on %s data stream\n", __func__,
+			type_to_str(format->type));
+
+	ret = SYS_IOCTL(fd, cmd, format);
+	if (ret) {
+		DELTA_LOG_ERR("%s: failed to set format on %s data stream\n",
+			      __func__, type_to_str(format->type));
+		goto out;
+	}
+
+	/* Intercept latest successful S_FMT(OUTPUT)
+	 * to select the right metadata parser backend
+	 */
+	if (format->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		for (i = 0; i < (sizeof(delta_meta) / sizeof(delta_meta[0])); i++) {
+			if (delta_meta[i]->stream_format == format->fmt.pix.pixelformat) {
+				delta->meta = delta_meta[i];
+				DELTA_LOG_INFO("%s: %s metadata parser selected\n",
+					       __func__, delta->meta->name);
+				ret = 0;
+				break;
+			}
+		}
+
+out:
+	DELTA_LOG_DEBUG("< %s\n", __func__);
+	return ret;
+}
+
+static int delta_reqbufs(struct delta_plugin *delta, int fd,
+						 unsigned long int cmd,
+						 struct v4l2_requestbuffers *requestbuffers)
+{
+	int ret;
+
+	DELTA_LOG_DEBUG("> %s: request buffers on %s data stream\n",
+			__func__, type_to_str(requestbuffers->type));
+
+	ret = SYS_IOCTL(fd, cmd, requestbuffers);
+	if (ret) {
+		DELTA_LOG_ERR
+		    ("%s failed to request buffers on %s data stream\n",
+		     __func__, type_to_str(requestbuffers->type));
+	}
+
+	if (delta->meta &&
+	    (requestbuffers->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (requestbuffers->count > 0)) {
+		/* Intercept REQBUFS(OUTPUT) to know the nb of buffers to mmap */
+
+		/* Allocates buffer info */
+		delta->buffer_info =
+		    calloc(requestbuffers->count,
+			   sizeof(struct delta_buffer_info));
+
+		delta->buffer_nb = requestbuffers->count;
+	}
+
+out:
+	DELTA_LOG_DEBUG("< %s\n", __func__);
+	return ret;
+}
+
+static int delta_querybuf(struct delta_plugin *delta, int fd,
+						  unsigned long int cmd, struct v4l2_buffer *buffer)
+{
+	int ret;
+
+	DELTA_LOG_DEBUG("> %s: query buffer on %s data stream\n", __func__,
+			type_to_str(buffer->type));
+
+	ret = SYS_IOCTL(fd, cmd, buffer);
+	if (ret) {
+		DELTA_LOG_ERR("%s: failed to query buffer on %s data stream\n",
+			      __func__, type_to_str(buffer->type));
+		goto out;
+	}
+
+	if (delta->meta &&
+	    (buffer->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (buffer->length > 0)) {
+		/* Intercept QUERYBUF(OUTPUT) to mmap access unit & allocate metadata */
+
+		struct delta_buffer_info *buf_info =
+		    &delta->buffer_info[buffer->index];
+		void *vaddr;
+
+		/* AU memory mapping */
+		buf_info->au_size = buffer->length;
+		vaddr = (void *)SYS_MMAP(NULL, buffer->length,
+					 PROT_READ | PROT_WRITE, MAP_SHARED, fd,
+					 buffer->m.offset);
+		if (vaddr == MAP_FAILED) {
+			DELTA_LOG_ERR("%s: failed to map AU\n", __func__);
+			ret = -EINVAL;
+			goto out;
+		}
+		buf_info->au_addr = vaddr;
+
+		/* Allocate metadata */
+		vaddr = calloc(1, delta->meta->meta_size);
+		if (!delta) {
+			DELTA_LOG_ERR
+			    ("%s: couldn't allocate metadata memory"
+			     " plugin\n", __func__);
+			goto out;
+		}
+		buf_info->meta = vaddr;
+	}
+
+out:
+	DELTA_LOG_DEBUG("< %s\n", __func__);
+	return ret;
+}
+
+static int delta_qbuf(struct delta_plugin *delta, int fd, unsigned long int cmd,
+				      struct v4l2_buffer *buffer)
+{
+	struct delta_buffer_info *buf_info =
+		&delta->buffer_info[buffer->index];
+	struct v4l2_ext_control ctrl;
+	struct v4l2_ext_controls ctrls;
+	int ret = 0;
+	void *au_addr;
+	unsigned int au_size;
+	unsigned int found = 0;
+
+	DELTA_LOG_DEBUG("> %s: queue buffer on %s data stream\n", __func__,
+			type_to_str(buffer->type));
+
+	au_addr = buf_info->au_addr;
+	au_size = buffer->bytesused;
+
+	if (delta->meta &&
+	    (buffer->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (au_size > 0)) {
+		found = delta->meta->decode_header(au_addr, au_size,
+										   buf_info->meta);
+		if (!found) {
+			DELTA_LOG_DEBUG("%s: no header found within %d bytes input stream\n",
+					__func__, au_size);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/* Call CTRL with meta */
+		memset(&ctrl, 0, sizeof(ctrl));
+		ctrl.id = V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR;
+		ctrl.ptr = buf_info->meta;
+		ctrl.size = delta->meta->meta_size;
+
+		memset(&ctrls, 0, sizeof(ctrls));
+		ctrls.controls = &ctrl;
+		ctrls.count = 1;
+		ctrls.request = buffer->index + 1;/* Request API usage to be confimed */
+		ret = SYS_IOCTL(fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+		if (ret) {
+			DELTA_LOG_ERR("%s: failed to set meta external control\n",
+				      __func__);
+			goto out;
+		}
+
+		/* Link this meta to its data buffer */
+		buffer->request = buffer->index + 1;/* Request API usage to be confimed */
+	}
+
+	/* Call QBUF */
+	ret = SYS_IOCTL(fd, cmd, buffer);
+	if (ret) {
+		DELTA_LOG_ERR("%s: failed to queue buffer on %s data"
+			      " stream\n", __func__,
+			      type_to_str(buffer->type));
+		goto out;
+	}
+
+out:
+	DELTA_LOG_DEBUG("< %s\n", __func__);
+	return ret;
+}
+
+static int delta_plugin_ioctl(void *dev_ops_priv, int fd,
+						      unsigned long int cmd, void *arg)
+{
+	struct delta_plugin *delta = dev_ops_priv;
+
+	switch (cmd) {
+	case VIDIOC_S_FMT:
+		DELTA_LOG_DEBUG("> %s: VIDIOC_S_FMT\n", __func__);
+		return delta_s_fmt(delta, fd, cmd, arg);
+	case VIDIOC_REQBUFS:
+		DELTA_LOG_DEBUG("> %s: VIDIOC_REQBUFS\n", __func__);
+		return delta_reqbufs(delta, fd, cmd, arg);
+	case VIDIOC_QUERYBUF:
+		DELTA_LOG_DEBUG("> %s: VIDIOC_QUERYBUF\n", __func__);
+		return delta_querybuf(delta, fd, cmd, arg);
+	case VIDIOC_QBUF:
+		DELTA_LOG_DEBUG("> %s: VIDIOC_QBUF\n", __func__);
+		return delta_qbuf(delta, fd, cmd, arg);
+	default:
+		return SYS_IOCTL(fd, cmd, arg);
+	}
+}
+
+PLUGIN_PUBLIC const struct libv4l_dev_ops libv4l2_plugin = {
+	.init = &delta_plugin_init,
+	.close = &delta_plugin_close,
+	.ioctl = &delta_plugin_ioctl,
+};
diff --git a/lib/libv4l-delta/libv4l-delta.h b/lib/libv4l-delta/libv4l-delta.h
new file mode 100644
index 0000000..805d31d
--- /dev/null
+++ b/lib/libv4l-delta/libv4l-delta.h
@@ -0,0 +1,97 @@
+/*
+ * libv4l-delta.h
+ *
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Tifaine Inguere <tifaine.inguere@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ */
+
+#ifndef LIBV4L_DELTA_H
+#define LIBV4L_DELTA_H
+
+#include <stdio.h>
+#include <linux/videodev2.h>
+
+#define DELTA_NAME	"st-delta"
+
+#define DELTA_LOG_ERR(...) \
+	do { \
+		fprintf(stderr, "libv4l2: error " __VA_ARGS__); \
+	} while (0)
+
+#define DELTA_LOG_WARN(...) \
+	do { \
+		fprintf(stderr, "libv4l2: warning " __VA_ARGS__); \
+	} while (0)
+
+#define DELTA_LOG_INFO(...) \
+	do { \
+		fprintf(stdout, "libv4l2: info " __VA_ARGS__); \
+	} while (0)
+
+struct delta_metadata {
+	const char *name;
+	unsigned int stream_format;
+	unsigned int meta_size;
+
+	/**
+	 * decode_header() - decode the header of a single access unit
+	 * @au_addr: (in) access unit address
+	 * @au_size: (in) access unit size
+	 * @meta: (in/out) metadata
+	 *
+	 * Decode the header of the given access unit. The retrieved
+	 * information (metadata) is stored in meta
+	 */
+	unsigned int (*decode_header) (void *au_addr, unsigned int au_size, void *meta);
+};
+
+/**
+ * struct delta_buffer_info
+ *
+ * @au_addr: virtual address of the access unit data
+ * @au_size: size in bytes of the access unit data
+ * @meta:    metadata
+ *
+ * This structure contains the informations about the data to transfer to the
+ * hw device.
+ *
+ * */
+struct delta_buffer_info {
+	void *au_addr;
+	unsigned int au_size;
+	void *meta;
+};
+
+/**
+ * struct delta_plugin
+ *
+ * @meta: the access for the functions of header parsing through the
+ *          delta_metadata struct
+ * @buffer_info: a pointer on a buffer_info struct
+ * @buffer_nb: number of buffer_info created by the ioctl command reqbufs
+ *
+ * This structure is used throught the calls to the ioctl delta commands
+ * It is used to keep in memory informations concerning the allocated buffers
+ * to better control the data and metadata flux
+ *
+ * */
+struct delta_plugin {
+	const struct delta_metadata *meta;
+	struct delta_buffer_info *buffer_info;
+	unsigned int buffer_nb;
+};
+
+#endif /* LIBV4L_DELTA_H */
+
+/*enable or disable the debug trace*/
+//#define HAVE_TRACE
+
+#ifdef HAVE_TRACE
+#define DELTA_LOG_DEBUG(...) \
+	do { \
+		fprintf(stdout, "libv4l2: debug " __VA_ARGS__); \
+	} while (0)
+#else
+#define DELTA_LOG_DEBUG(...)
+#endif
diff --git a/lib/libv4l-delta/libv4l-delta.pc.in b/lib/libv4l-delta/libv4l-delta.pc.in
new file mode 100644
index 0000000..2b2ed68
--- /dev/null
+++ b/lib/libv4l-delta/libv4l-delta.pc.in
@@ -0,0 +1,12 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+includedir=@includedir@
+libdir=@libdir@
+
+Name: libv4l-delta
+Description: v4l2 device access library, plugin for delta device
+Version: @PACKAGE_VERSION@
+Requires.private: libv4l-gst
+Libs: -L${libdir} -lv4l2
+Libs.private: -lpthread
+Cflags: -I${includedir}
-- 
1.9.1

