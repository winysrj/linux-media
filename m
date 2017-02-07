Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:60963 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754124AbdBGOGq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 09:06:46 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 2/3] add libv4l-codecparsers plugin for video bitstream parsing
Date: Tue, 7 Feb 2017 15:06:26 +0100
Message-ID: <1486476387-8069-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486476387-8069-1-git-send-email-hugues.fruchet@st.com>
References: <1486476387-8069-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stateless video decoders require explicit codec specific
metadata derived from video bitstream parsing.
This plugin aims to silently convert the user provided video
bitstream to a parsed video bitstream, ie the video bitstream itself
+ additional parsing metadata which are given to the driver through the
V4L2 extended control framework.
This plugin supports several codec dependent parser backends.
Enabling of the right parser is done by intercepting the pixel format
information negotiated between user and driver (enum_fmt/try_fmt/get_fmt/s_fmt).

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac                                      |   2 +
 lib/Makefile.am                                   |   3 +-
 lib/libv4l-codecparsers/Makefile.am               |   9 +
 lib/libv4l-codecparsers/libv4l-codecparsers.pc.in |  12 +
 lib/libv4l-codecparsers/libv4l-cparsers.c         | 461 ++++++++++++++++++++++
 lib/libv4l-codecparsers/libv4l-cparsers.h         | 101 +++++
 6 files changed, 587 insertions(+), 1 deletion(-)
 create mode 100644 lib/libv4l-codecparsers/Makefile.am
 create mode 100644 lib/libv4l-codecparsers/libv4l-codecparsers.pc.in
 create mode 100644 lib/libv4l-codecparsers/libv4l-cparsers.c
 create mode 100644 lib/libv4l-codecparsers/libv4l-cparsers.h

diff --git a/configure.ac b/configure.ac
index f326972..af38e6d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,6 +17,7 @@ AC_CONFIG_FILES([Makefile
 	lib/libdvbv5/Makefile
 	lib/libv4l2rds/Makefile
 	lib/libv4l-mplane/Makefile
+	lib/libv4l-codecparsers/Makefile
 
 	utils/Makefile
 	utils/libv4l2util/Makefile
@@ -56,6 +57,7 @@ AC_CONFIG_FILES([Makefile
 	lib/libv4lconvert/libv4lconvert.pc
 	lib/libv4l1/libv4l1.pc
 	lib/libv4l2/libv4l2.pc
+	lib/libv4l-codecparsers/libv4l-codecparsers.pc
 	lib/libdvbv5/libdvbv5.pc
 	lib/libv4l2rds/libv4l2rds.pc
 	utils/media-ctl/libmediactl.pc
diff --git a/lib/Makefile.am b/lib/Makefile.am
index a105c95..3aa8564 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -3,7 +3,8 @@ SUBDIRS = \
 	libv4l2 \
 	libv4l1 \
 	libv4l2rds \
-	libv4l-mplane
+	libv4l-mplane \
+	libv4l-codecparsers
 
 if WITH_LIBDVBV5
 SUBDIRS += \
diff --git a/lib/libv4l-codecparsers/Makefile.am b/lib/libv4l-codecparsers/Makefile.am
new file mode 100644
index 0000000..a9d6c8b
--- /dev/null
+++ b/lib/libv4l-codecparsers/Makefile.am
@@ -0,0 +1,9 @@
+if WITH_V4L_PLUGINS
+libv4l2plugin_LTLIBRARIES = libv4l-codecparsers.la
+endif
+
+libv4l_codecparsers_la_SOURCES = libv4l-cparsers.c libv4l-cparsers.h
+
+libv4l_codecparsers_la_CPPFLAGS = $(CFLAG_VISIBILITY) -I$(top_srcdir)/lib/libv4l2/ -I$(top_srcdir)/lib/libv4lconvert/
+libv4l_codecparsers_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
+libv4l_codecparsers_la_LIBADD = ../libv4l2/libv4l2.la
diff --git a/lib/libv4l-codecparsers/libv4l-codecparsers.pc.in b/lib/libv4l-codecparsers/libv4l-codecparsers.pc.in
new file mode 100644
index 0000000..ea367ee
--- /dev/null
+++ b/lib/libv4l-codecparsers/libv4l-codecparsers.pc.in
@@ -0,0 +1,12 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+includedir=@includedir@
+libdir=@libdir@
+
+Name: libv4l-codecparsers
+Description: v4l2 library to parse video bitstream, needed by stateless video decoders
+Version: @PACKAGE_VERSION@
+Requires.private: libv4l-gst
+Libs: -L${libdir} -lv4l2
+Libs.private: -lpthread
+Cflags: -I${includedir}
diff --git a/lib/libv4l-codecparsers/libv4l-cparsers.c b/lib/libv4l-codecparsers/libv4l-cparsers.c
new file mode 100644
index 0000000..af59f50
--- /dev/null
+++ b/lib/libv4l-codecparsers/libv4l-cparsers.c
@@ -0,0 +1,461 @@
+/*
+ * libv4l-cparsers.c
+ *
+ * Copyright (C) STMicroelectronics SA 2017
+ * Authors: Hugues Fruchet <hugues.fruchet@st.com>
+ *          Tifaine Inguere <tifaine.inguere@st.com>
+ *          for STMicroelectronics.
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
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "libv4l2.h"
+#include "libv4l2-priv.h"
+#include "libv4l-plugin.h"
+#include "libv4lsyscall-priv.h"
+
+#include "libv4l-cparsers.h"
+
+#if HAVE_VISIBILITY
+#define PLUGIN_PUBLIC __attribute__ ((visibility("default")))
+#else
+#define PLUGIN_PUBLIC
+#endif
+
+/* available parsers */
+const struct meta_parser *parsers[] = {
+};
+
+static void *plugin_init(int fd)
+{
+	struct cparsers_plugin *cparsers = NULL;
+	struct v4l2_capability cap;
+	int ret;
+	unsigned int i;
+	struct v4l2_fmtdesc fmt;
+	bool found = false;
+
+	/* check if device needs cparsers plugin */
+	memset(&cap, 0, sizeof(cap));
+	ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap);
+	if (ret)
+		return NULL;
+
+	if (!(cap.capabilities & V4L2_CAP_VIDEO_M2M))
+		return NULL;
+
+	memset(&fmt, 0, sizeof(fmt));
+	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	while (SYS_IOCTL(fd, VIDIOC_ENUM_FMT, &fmt) >= 0) {
+		for (i = 0; i < (sizeof(parsers) / sizeof(parsers[0])); i++) {
+			if (parsers[i]->parsedformat == fmt.pixelformat) {
+				V4L2_LOG("%s: %s device matches %s parser for conversion %4.4s=>%4.4s(%s)\n",
+					 __func__, cap.driver, parsers[i]->name,
+					 (char *)&parsers[i]->streamformat,
+					 (char *)&fmt.pixelformat,
+					 fmt.description);
+				found = true;
+				break;
+			}
+		}
+		fmt.index++;
+	}
+
+	if (!found)
+		return NULL;
+
+	V4L2_LOG("%s: %s device needs libv4l-codecparsers plugin\n",
+		 __func__, cap.driver);
+
+	/* allocate and initialize private data */
+	cparsers = calloc(1, sizeof(struct cparsers_plugin));
+	if (!cparsers) {
+		V4L2_LOG_ERR("%s: couldn't allocate memory\n", __func__);
+		return NULL;
+	}
+
+	/* store driver name (debug purpose) */
+	memcpy(cparsers->driver_name, cap.driver, sizeof(cparsers->driver_name));
+
+	return cparsers;
+}
+
+static void plugin_close(void *dev_ops_priv)
+{
+	struct cparsers_plugin *cparsers = dev_ops_priv;
+	unsigned int i, j;
+
+	if (!cparsers)
+		return;
+
+	if (!cparsers->aus) {
+		free(cparsers);
+		return;
+	}
+
+	for (i = 0; i < cparsers->nb_of_aus; i++) {
+		struct cparsers_au *au = &cparsers->aus[i];
+
+		/* unmap AU */
+		if (au->addr)
+			SYS_MUNMAP(au->addr, au->size);
+
+		/* free metadata */
+		for (j = 0; j < au->nb_of_metas; j++)
+			if (au->metas_store[j].ptr)
+				free(au->metas_store[j].ptr);
+	}
+
+	free(cparsers->aus);
+	free(cparsers);
+}
+
+static int enum_fmt(struct cparsers_plugin *cparsers, int fd,
+		    unsigned long int cmd, struct v4l2_fmtdesc *fmtdesc)
+{
+	unsigned int i;
+	int ret = 0;
+	__u32 driver_format;
+
+	if (!fmtdesc)
+		return -EINVAL;
+
+	ret = SYS_IOCTL(fd, cmd, fmtdesc);
+	if (ret)
+		return ret;
+
+	if (fmtdesc->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return 0;
+
+	/*
+	 * check if driver enumerate a parsers' supported
+	 * pixel format, in that case override with stream
+	 * format so that conversion is transparent for user
+	 */
+	driver_format = fmtdesc->pixelformat;
+	for (i = 0; i < (sizeof(parsers) / sizeof(parsers[0])); i++) {
+		if (parsers[i]->parsedformat == driver_format) {
+			V4L2_LOG("%s: %s parser available, override format %4.4s with %4.4s\n",
+				 __func__, parsers[i]->name,
+				 (char *)&driver_format,
+				 (char *)&parsers[i]->streamformat);
+			fmtdesc->pixelformat = parsers[i]->streamformat;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int try_fmt(struct cparsers_plugin *cparsers, int fd,
+		   unsigned long int cmd, struct v4l2_format *format)
+{
+	unsigned int i;
+	int ret = 0;
+	__u32 requested_format;
+
+	if (!format)
+		return -EINVAL;
+
+	/*
+	 * check if user request for a parsers' supported
+	 * pixel format, in that case override with parsed
+	 * format supported by driver
+	 */
+	requested_format = format->fmt.pix.pixelformat;
+	if (format->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		for (i = 0; i < (sizeof(parsers) / sizeof(parsers[0])); i++) {
+			if (parsers[i]->streamformat == requested_format) {
+				V4L2_LOG("%s: %s parser available, override format %4.4s with %4.4s\n",
+					 __func__, parsers[i]->name,
+					 (char *)&requested_format,
+					 (char *)&parsers[i]->parsedformat);
+				format->fmt.pix.pixelformat = parsers[i]->parsedformat;
+				break;
+			}
+		}
+
+	ret = SYS_IOCTL(fd, cmd, format);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+static int g_fmt(struct cparsers_plugin *cparsers, int fd,
+		 unsigned long int cmd, struct v4l2_format *format)
+{
+	unsigned int i;
+	int ret = 0;
+	__u32 driver_format;
+
+	if (!format)
+		return -EINVAL;
+
+	ret = SYS_IOCTL(fd, cmd, format);
+	if (ret)
+		return ret;
+
+	driver_format = format->fmt.pix.pixelformat;
+
+	/*
+	 * check if driver returns a parsers' supported
+	 * pixel format, in that case override with stream
+	 * format so that conversion is transparent for user
+	 */
+	if (format->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		for (i = 0; i < (sizeof(parsers) / sizeof(parsers[0])); i++) {
+			if (parsers[i]->parsedformat == driver_format) {
+				V4L2_LOG("%s: %s parser available, override format %4.4s with %4.4s\n",
+					 __func__, parsers[i]->name,
+					 (char *)&driver_format,
+					 (char *)&parsers[i]->streamformat);
+				format->fmt.pix.pixelformat = parsers[i]->streamformat;
+				break;
+			}
+		}
+
+	return ret;
+}
+
+static int s_fmt(struct cparsers_plugin *cparsers, int fd,
+		 unsigned long int cmd, struct v4l2_format *format)
+{
+	unsigned int i;
+	int ret = 0;
+	__u32 requested_format;
+	bool parser_enabled = false;
+
+	if (!format)
+		return -EINVAL;
+
+	/*
+	 * check if user request for a parsers' supported
+	 * pixel format, in that case override with parsed
+	 * format supported by driver
+	 */
+	requested_format = format->fmt.pix.pixelformat;
+	if (format->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		for (i = 0; i < (sizeof(parsers) / sizeof(parsers[0])); i++) {
+			if (parsers[i]->streamformat == requested_format) {
+				V4L2_LOG("%s: %s parser available, override format %4.4s with %4.4s\n",
+					 __func__, parsers[i]->name,
+					 (char *)&requested_format,
+					 (char *)&parsers[i]->parsedformat);
+				format->fmt.pix.pixelformat = parsers[i]->parsedformat;
+				parser_enabled = true;
+				break;
+			}
+		}
+
+	ret = SYS_IOCTL(fd, cmd, format);
+	if (ret)
+		return ret;
+
+	if (!parser_enabled)
+		return ret;
+
+	/*
+	 * we have now a parser candidate and
+	 * S_FMT is successful on driver side,
+	 * let's selects this parser for this instance
+	 */
+	cparsers->parser = parsers[i];
+	/* override format, so that conversion is transparent for user */
+	format->fmt.pix.pixelformat = requested_format;
+
+	V4L2_LOG("%s: %s parser is now selected for device %s\n",
+		 __func__, cparsers->parser->name, cparsers->driver_name);
+
+	return ret;
+}
+
+static int reqbufs(struct cparsers_plugin *cparsers, int fd,
+		   unsigned long int cmd,
+		   struct v4l2_requestbuffers *requestbuffers)
+{
+	int ret;
+
+	if (!requestbuffers)
+		return -EINVAL;
+
+	ret = SYS_IOCTL(fd, cmd, requestbuffers);
+	if (ret)
+		return ret;
+
+	if (cparsers->parser &&
+	    (requestbuffers->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (requestbuffers->count > 0)) {
+		/* intercept REQBUFS(OUTPUT) to know the nb of buffers to mmap */
+
+		/* allocates the set of buffer info */
+		cparsers->aus =
+		    calloc(requestbuffers->count,
+			   sizeof(struct cparsers_au));
+
+		cparsers->nb_of_aus = requestbuffers->count;
+	}
+
+	return ret;
+}
+
+static int querybuf(struct cparsers_plugin *cparsers, int fd,
+		    unsigned long int cmd, struct v4l2_buffer *buffer)
+{
+	int ret;
+	const struct meta_parser *parser = cparsers->parser;
+	unsigned int i;
+
+	if (!buffer)
+		return -EINVAL;
+
+	ret = SYS_IOCTL(fd, cmd, buffer);
+	if (ret)
+		return ret;
+
+	if (parser &&
+	    (buffer->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (buffer->length > 0)) {
+		/* intercept QUERYBUF(OUTPUT) to mmap access unit & allocate metadata */
+
+		struct cparsers_au *au =
+		    &cparsers->aus[buffer->index];
+		void *vaddr;
+
+		/* user stream buffer memory mapping */
+		au->size = buffer->length;
+		vaddr = (void *)SYS_MMAP(NULL, buffer->length,
+					 PROT_READ | PROT_WRITE, MAP_SHARED, fd,
+					 buffer->m.offset);
+		if (vaddr == MAP_FAILED) {
+			V4L2_LOG_ERR("%s: failed to map AU\n", __func__);
+			return -EINVAL;
+		}
+		au->addr = vaddr;
+
+		au->nb_of_metas = parser->nb_of_metas;
+		if (au->nb_of_metas > CPARSERS_MAX_METAS) {
+			V4L2_LOG_ERR("%s: not enough room for metas (%d > %d), please increase CPARSERS_MAX_METAS\n",
+				     __func__,
+				     au->nb_of_metas,
+				     CPARSERS_MAX_METAS);
+			return -EINVAL;
+		}
+
+		for (i = 0; i < au->nb_of_metas; i++) {
+			au->metas_store[i] = parser->metas_store[i];
+			/* allocate the set of metadata */
+			vaddr = calloc(1, au->metas_store[i].size);
+			if (!vaddr) {
+				V4L2_LOG_ERR("%s: couldn't allocate metadata memory plugin\n", __func__);
+				return -ENOMEM;
+			}
+			au->metas_store[i].ptr = vaddr;
+		}
+	}
+
+	return ret;
+}
+
+static int qbuf(struct cparsers_plugin *cparsers, int fd, unsigned long int cmd,
+		struct v4l2_buffer *buffer)
+{
+	struct v4l2_ext_controls ctrls;
+	int ret = 0;
+	unsigned int found = 0;
+	const struct meta_parser *parser = cparsers->parser;
+	unsigned int nb_of_metas = 0;
+	struct v4l2_ext_control metas[CPARSERS_MAX_METAS];
+
+	if (!buffer)
+		return -EINVAL;
+
+	if (parser &&
+	    (buffer->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    (buffer->bytesused > 0) &&
+	    cparsers->aus &&
+	    (buffer->index < cparsers->nb_of_aus)) {
+		struct cparsers_au *au = &cparsers->aus[buffer->index];
+
+		au->bytesused = buffer->bytesused;
+		nb_of_metas = 0;
+		memset(metas, 0, sizeof(metas));
+		found = parser->parse_metas(au, metas, &nb_of_metas);
+		if (!found) {
+			V4L2_LOG_WARN("%s: no header found within %d bytes input stream\n",
+				      __func__, au->bytesused);
+			return 0;
+		}
+
+		/* call CTRL with metas */
+		memset(&ctrls, 0, sizeof(ctrls));
+		ctrls.controls = metas;
+		ctrls.count = nb_of_metas;
+
+		ret = SYS_IOCTL(fd, VIDIOC_S_EXT_CTRLS, &ctrls);
+		if (ret)
+			return ret;
+	}
+
+	/* call QBUF */
+	ret = SYS_IOCTL(fd, cmd, buffer);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+static int plugin_ioctl(void *dev_ops_priv, int fd,
+			unsigned long int cmd, void *arg)
+{
+	struct cparsers_plugin *cparsers = dev_ops_priv;
+
+	switch (cmd) {
+	case VIDIOC_ENUM_FMT:
+		return enum_fmt(cparsers, fd, cmd, arg);
+	case VIDIOC_TRY_FMT:
+		return try_fmt(cparsers, fd, cmd, arg);
+	case VIDIOC_G_FMT:
+		return g_fmt(cparsers, fd, cmd, arg);
+	case VIDIOC_S_FMT:
+		return s_fmt(cparsers, fd, cmd, arg);
+	case VIDIOC_REQBUFS:
+		return reqbufs(cparsers, fd, cmd, arg);
+	case VIDIOC_QUERYBUF:
+		return querybuf(cparsers, fd, cmd, arg);
+	case VIDIOC_QBUF:
+		return qbuf(cparsers, fd, cmd, arg);
+	default:
+		return SYS_IOCTL(fd, cmd, arg);
+	}
+}
+
+PLUGIN_PUBLIC const struct libv4l_dev_ops libv4l2_plugin = {
+	.init = &plugin_init,
+	.close = &plugin_close,
+	.ioctl = &plugin_ioctl,
+};
+
diff --git a/lib/libv4l-codecparsers/libv4l-cparsers.h b/lib/libv4l-codecparsers/libv4l-cparsers.h
new file mode 100644
index 0000000..3f0d7dd
--- /dev/null
+++ b/lib/libv4l-codecparsers/libv4l-cparsers.h
@@ -0,0 +1,101 @@
+/*
+ * libv4l-cparsers.h
+ *
+ * Copyright (C) STMicroelectronics SA 2017
+ * Authors: Hugues Fruchet <hugues.fruchet@st.com>
+ *          Tifaine Inguere <tifaine.inguere@st.com>
+ *          for STMicroelectronics.
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
+#ifndef LIBV4L_CPARSERS_H
+#define LIBV4L_CPARSERS_H
+
+#include <stdio.h>
+#include <linux/videodev2.h>
+
+#define CPARSERS_MAX_METAS 10
+
+/*
+ * struct cparsers_au - access unit structure, associating
+ * a single compressed video bitstream chunk with its possible
+ * parsing metadata.
+ *
+ * @addr:		virtual address of the access unit data
+ * @size:		allocated size in bytes of the access unit data
+ * @bytesused:		size in bytes of the valid data within the access unit
+ * @metas_store:	set of all possible metadata controls
+ *			that can be encountered in this access unit
+ *			with their control structure allocated
+ *			in "ptr" field.
+ * @nb_of_metas:	number of meta in store
+ */
+struct cparsers_au {
+	void *addr;
+	unsigned int size;
+	unsigned int bytesused;
+	struct v4l2_ext_control metas_store[CPARSERS_MAX_METAS];
+	unsigned int nb_of_metas;
+};
+
+/*
+ * struct meta_parser - parser structure, one per parser instance
+ *
+ * @name:		name of parser
+ * @streamformat:	compressed format of input video stream
+ * @parsedformat:	parsed compressed format output by parser
+ * @metas_store:	set of meta controls supported by this parser
+ *			(control identifier / control structure size)
+ * @nb_of_metas:	number of meta in store
+ */
+struct meta_parser {
+	const char *name;
+	__u32 streamformat;
+	__u32 parsedformat;
+	const struct v4l2_ext_control *metas_store;
+	unsigned int nb_of_metas;
+
+	/*
+	 * parse_metas() - parse the given access unit and output
+	 * the associated set of metadata.
+	 *
+	 * @au:		(in) access unit to parse
+	 * @metas:	(in/out) set of parsed metadata actually
+	 *		encountered after parsing the input access unit.
+	 * @nb_of_metas:(in/out) number of metadata parsed
+	 */
+	unsigned int (*parse_metas)(struct cparsers_au *au,
+				    struct v4l2_ext_control *metas,
+				    unsigned int *nb_of_metas);
+};
+
+/*
+ * struct cparsers_plugin - plugin structure, one per plugin instance
+ *
+ * @driver_name: keep track of driver name which needs parser
+ * @parser: the parser backend wich decodes the metadata from stream
+ * @aus: set of au struct
+ * @nb_of_aus: number of au created by the ioctl command reqbufs
+ */
+struct cparsers_plugin {
+	__u8 driver_name[16];
+	const struct meta_parser *parser;
+	struct cparsers_au *aus;
+	unsigned int nb_of_aus;
+};
+
+#endif /* LIBV4L_CPARSERS_H */
+
-- 
1.9.1

