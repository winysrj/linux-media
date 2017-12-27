Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43185 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdL0Dkj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 22:40:39 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20171227034037epoutp034aadfa6be7d27a51fadce70f3df0b45a~ECbKiNmHi1126311263epoutp03k
        for <linux-media@vger.kernel.org>; Wed, 27 Dec 2017 03:40:37 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: linux-media@vger.kernel.org
Cc: sst2005@gmail.com, Satendra Singh Thakur <satendra.t@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>
Subject: [PATCH][v4l-utils] [DVBV5] Streaming support using videobuf2 for
 DVR and  auto-scan
Date: Wed, 27 Dec 2017 09:10:22 +0530
Message-Id: <1514346022-28940-1-git-send-email-satendra.t@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20171227034036epcas5p1c555f491254cfe61080e558e9eb6c19e@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ported an older patch (details given below) to latest v4l-utils:
 commit 6049ea8bd64f (Statically linking libdvbv5 must
 include -ludev) v4l-utils
 -Added videobuf2 code for auto-scan
-Enhanced queueing logic
--Enqueue all bufs in the begining, dequeue one buf
--Consume it, enqueue it again and so on..
-Added a common dvb-vb2 lib for following streaming APIs.
--initializatioin, deinitialization: unmap and dequeue
--enqueue buf, dequeue buf
--export buf, stream_to_file
--xioctl for repeated ioctl calling
-Added comments to functions
-This code could not be tested so far

Original patch:
https://patchwork.linuxtv.org/patch/31612/

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 include/linux/dvb/dmx.h        |  65 ++++++++-
 lib/include/libdvbv5/dvb-dev.h |   8 ++
 lib/include/libdvbv5/dvb-vb2.h | 152 ++++++++++++++++++++
 lib/libdvbv5/Makefile.am       |   2 +
 lib/libdvbv5/dvb-scan.c        |  92 ++++++++++--
 lib/libdvbv5/dvb-vb2.c         | 320 +++++++++++++++++++++++++++++++++++++++++
 utils/dvb/dvbv5-zap.c          |  31 +++-
 7 files changed, 656 insertions(+), 14 deletions(-)
 create mode 100644 lib/include/libdvbv5/dvb-vb2.h
 create mode 100644 lib/libdvbv5/dvb-vb2.c

diff --git a/include/linux/dvb/dmx.h b/include/linux/dvb/dmx.h
index 7d27bf5..3cef421 100644
--- a/include/linux/dvb/dmx.h
+++ b/include/linux/dvb/dmx.h
@@ -1,4 +1,3 @@
-/* SPDX-License-Identifier: LGPL-2.1+ WITH Linux-syscall-note */
 /*
  * dmx.h
  *
@@ -209,6 +208,64 @@ struct dmx_stc {
 	__u64 stc;
 };
 
+/**
+ * struct dmx_buffer - dmx buffer info
+ *
+ * @index:	id number of the buffer
+ * @bytesused:	number of bytes occupied by data in the buffer (payload);
+ * @offset:	for buffers with memory == DMX_MEMORY_MMAP;
+ *		offset from the start of the device memory for this plane,
+ *		(or a "cookie" that should be passed to mmap() as offset)
+ * @length:	size in bytes of the buffer
+ *
+ * Contains data exchanged by application and driver using one of the streaming
+ * I/O methods.
+ */
+struct dmx_buffer {
+	__u32			index;
+	__u32			bytesused;
+	__u32			offset;
+	__u32			length;
+	__u32			reserved[4];
+};
+
+/**
+ * struct dmx_requestbuffers - request dmx buffer information
+ *
+ * @count:	number of requested buffers,
+ * @size:	size in bytes of the requested buffer
+ *
+ * Contains data used for requesting a dmx buffer.
+ * All reserved fields must be set to zero.
+ */
+struct dmx_requestbuffers {
+	__u32			count;
+	__u32			size;
+	__u32			reserved[2];
+};
+
+/**
+ * struct dmx_exportbuffer - export of dmx buffer as DMABUF file descriptor
+ *
+ * @index:	id number of the buffer
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ *
+ * Contains data used for exporting a dmx buffer as DMABUF file descriptor.
+ * The buffer is identified by a 'cookie' returned by DMX_QUERYBUF
+ * (identical to the cookie used to mmap() the buffer to userspace). All
+ * reserved fields must be set to zero. The field reserved0 is expected to
+ * become a structure 'type' allowing an alternative layout of the structure
+ * content. Therefore this field should not be used for any other extensions.
+ */
+struct dmx_exportbuffer {
+	__u32		index;
+	__u32		flags;
+	__s32		fd;
+	__u32		reserved[5];
+};
+
 #define DMX_START                _IO('o', 41)
 #define DMX_STOP                 _IO('o', 42)
 #define DMX_SET_FILTER           _IOW('o', 43, struct dmx_sct_filter_params)
@@ -227,4 +284,10 @@ typedef enum dmx_ts_pes dmx_pes_type_t;
 typedef struct dmx_filter dmx_filter_t;
 
 
+#define DMX_REQBUFS              _IOWR('o', 60, struct dmx_requestbuffers)
+#define DMX_QUERYBUF             _IOWR('o', 61, struct dmx_buffer)
+#define DMX_EXPBUF               _IOWR('o', 62, struct dmx_exportbuffer)
+#define DMX_QBUF                 _IOWR('o', 63, struct dmx_buffer)
+#define DMX_DQBUF                _IOWR('o', 64, struct dmx_buffer)
+
 #endif /* _DVBDMX_H_ */
diff --git a/lib/include/libdvbv5/dvb-dev.h b/lib/include/libdvbv5/dvb-dev.h
index 6dbd2ae..221d87b 100644
--- a/lib/include/libdvbv5/dvb-dev.h
+++ b/lib/include/libdvbv5/dvb-dev.h
@@ -309,6 +309,14 @@ struct dvb_open_descriptor *dvb_dev_open(struct dvb_device *dvb,
  * closed.
  */
 void dvb_dev_close(struct dvb_open_descriptor *open_dev);
+/**
+ * @brief Gets open file descriptor of a dvb device
+ * @ingroup dvb_device
+ *
+ * @param open_dev	Points to the struct dvb_open_descriptor
+ * @return Retuns fd on success, -1 otherwise.
+ */
+int dvb_dev_get_fd(struct dvb_open_descriptor *open_dev);
 
 /**
  * @brief returns fd from a local device
diff --git a/lib/include/libdvbv5/dvb-vb2.h b/lib/include/libdvbv5/dvb-vb2.h
new file mode 100644
index 0000000..efcafcc
--- /dev/null
+++ b/lib/include/libdvbv5/dvb-vb2.h
@@ -0,0 +1,152 @@
+/*
+ * Copyright (c) 2017-2018 - Mauro Carvalho Chehab
+ * Copyright (c) 2017-2018 - Junghak Sung <jh1009.sung@samsung.com>
+ * Copyright (c) 2017-2018 - Satendra Singh Thakur <satendra.t@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation version 2.1 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ */
+#ifndef _LIBVB2_H
+#define _LIBVB2_H
+
+#include <stdint.h>
+#include <linux/dvb/dmx.h>
+
+/**
+ * @file dvb-vb2.h
+ * @ingroup frontend_scan
+ * @brief Provides interfaces to videobuf2 streaming for DVB.
+ * @copyright GNU Lesser General Public License version 2.1 (LGPLv2.1)
+ * @author Satendra Singh Thakur
+ *
+ * @par Bug Report
+ * Please submit bug reports and patches to linux-media@vger.kernel.org
+ */
+
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define memzero(x) memset(&(x), 0, sizeof(x))
+
+/**Max count of the buffers*/
+#define MAX_STREAM_BUF_CNT	10
+
+#ifndef PERROR
+#define PERROR(fmt, args...)	\
+	fprintf(stderr, fmt, ## args)
+#endif
+
+/**
+ * struct stream_ctx - Streaming context
+ *
+ * @param in_fd		File descriptor of streaming device
+ * @param out_fd	File descriptor of output file
+ * @param buf_cnt	Count of the buffers to be queued/dequeued
+ * @param buf_size	Size of one such buffer
+ * @param buf		Pointer to array of buffers
+ * @param buf_flags	Array of boolean flags corresponding to buffers
+ * @param exp_fd	Array of file descriptors of exported buffers
+ * @param error		Error flag
+ */
+struct stream_ctx {
+	int in_fd;
+	int out_fd;
+	int buf_cnt;
+	int buf_size;
+	unsigned char *buf[MAX_STREAM_BUF_CNT];
+	int buf_flag[MAX_STREAM_BUF_CNT];
+	int exp_fd[MAX_STREAM_BUF_CNT];
+	int error;
+};
+/**
+ * stream_qbuf - Enqueues a buffer specified by index n
+ *
+ * @param sc		Context for streaming management
+ *			Pointer to &struct stream_ctx
+ * @param idx		Index of the buffer
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_qbuf(struct stream_ctx *sc, int idx);
+
+/**
+ * sream_dqbuf - Dequeues a buffer specified by buf argument
+ *
+ * @param sc		Context for streaming management
+ *			Pointer to &struct stream_ctx
+ * @param buf		Pointer to &struct dmx_buffer
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_dqbuf(struct stream_ctx *sc, struct dmx_buffer *buf);
+/**
+ * sream_expbuf - Exports a buffer specified by buf argument
+ *
+ * @param sc		Context for streaming management
+ *			Pointer to &struct stream_ctx
+ * @param idx		Index of the buffer
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_expbuf(struct stream_ctx *sc, int idx);
+/**
+ * stream_init - Requests number of buffers from memory
+ * Gets pointer to the buffers from driver, mmaps those buffers
+ * and stores them in an array
+ * Also, optionally exports those buffers
+ *
+ * @param sc		Context for streaming management
+ * @param in_fd		File descriptor of the streaming device
+ * @param buf_size	Size of the buffer
+ * @param buf_cnt	Number of buffers
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_init(struct stream_ctx *sc, int in_fd, int buf_size, int buf_cnt);
+
+/**
+ * @struct dvb_table_filter
+ * @brief De-initiazes streaming
+ * @ingroup frontend_scan
+ *
+ * @param sc		Pointer to &struct stream_ctx
+ */
+void stream_deinit(struct stream_ctx *sc);
+/**
+ * stream_to_file - Implements enqueue and dequeue logic
+ * First enqueues all the available buffers then dequeues
+ * one buffer, again enqueues it and so on.
+ *
+ * @param in_fd		File descriptor of the streaming device
+ * @param out_fd	File descriptor of output file
+ * @param timeout	Timeout in seconds
+ * @param dbg_level	Debug flag
+ * @param exit_flag	Flag to exit
+ *
+ * @return void
+ */
+void stream_to_file(int in_fd, int out_fd, int timeout, int dbg_level,
+			int *exit_flag);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index e65066e..45405c2 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -13,6 +13,7 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/dvb-frontend.h \
 	../include/libdvbv5/dvb-fe.h \
 	../include/libdvbv5/dvb-sat.h \
+	../include/libdvbv5/dvb-vb2.h \
 	../include/libdvbv5/dvb-scan.h \
 	../include/libdvbv5/dvb-log.h \
 	../include/libdvbv5/descriptors.h \
@@ -77,6 +78,7 @@ libdvbv5_la_SOURCES = \
 	dvb-file.c	 \
 	dvb-v5-std.c	 \
 	dvb-sat.c	 \
+	dvb-vb2.c	 \
 	dvb-scan.c	 \
 	descriptors.c	 \
 	tables/header.c		\
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 7ff8ba4..560b874 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -74,6 +74,20 @@
 
 # define N_(string) string
 
+/**Videobuf2 streaming
+ * Comment VB2 macro to disable the streaming code
+ */
+#define VB2
+
+#ifdef VB2
+#include <sys/mman.h>
+#include <libdvbv5/dvb-vb2.h>
+#define STREAM_BUF_CNT (4)
+#define STREAM_BUF_SIZ (DVB_MAX_PAYLOAD_PACKET_SIZE)
+
+struct stream_ctx sc = {0,};
+#endif
+
 static int dvb_poll(struct dvb_v5_fe_parms_priv *parms, int fd, unsigned int seconds)
 {
 	fd_set set;
@@ -317,7 +331,8 @@ int dvb_read_sections(struct dvb_v5_fe_parms *__p, int dmx_fd,
 	if (parms->p.verbose)
 		dvb_log(_("%s: waiting for table ID 0x%02x, program ID 0x%02x"),
 			__func__, sect->tid, sect->pid);
-
+#ifdef VB2
+#else
 	buf = calloc(DVB_MAX_PAYLOAD_PACKET_SIZE, 1);
 	if (!buf) {
 		dvb_logerr(_("%s: out of memory"), __func__);
@@ -325,7 +340,7 @@ int dvb_read_sections(struct dvb_v5_fe_parms *__p, int dmx_fd,
 		dvb_table_filter_free(sect);
 		return -1;
 	}
-
+#endif
 
 	do {
 		int available;
@@ -345,7 +360,23 @@ int dvb_read_sections(struct dvb_v5_fe_parms *__p, int dmx_fd,
 			ret = -1;
 			break;
 		}
+#ifdef VB2
+		struct dmx_buffer b;
+		memset(&b, 0, sizeof(b));
+
+		ret = stream_dqbuf(&sc, &b);
+		if (ret < 0) {
+			sc.error = 1;
+			break;
+		}
+		else {
+			sc.buf_flag[b.index] = 0;
+			buf = sc.buf[b.index];
+			buf_length = b.bytesused;
+		}
+#else
 		buf_length = read(dmx_fd, buf, DVB_MAX_PAYLOAD_PACKET_SIZE);
+#endif
 
 		if (!buf_length) {
 			dvb_logerr(_("%s: buf returned an empty buffer"), __func__);
@@ -366,8 +397,24 @@ int dvb_read_sections(struct dvb_v5_fe_parms *__p, int dmx_fd,
 		}
 
 		ret = dvb_parse_section(parms, sect, buf, buf_length);
+#ifdef VB2
+		/**enqueue the buffer again*/
+		if (!ret) {
+			if (stream_qbuf(&sc, b.index) < 0) { 
+				sc.error = 1;
+				break;
+			}
+			else 
+				sc.buf_flag[b.index] = 1;
+		}
+		
+#endif
 	} while (!ret);
+
+#ifdef VB2
+#else
 	free(buf);
+#endif
 	dvb_dmx_stop(dmx_fd);
 	dvb_table_filter_free(sect);
 
@@ -445,9 +492,22 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 
 	struct dvb_v5_descriptors *dvb_scan_handler;
 
+#ifdef VB2
+	rc = stream_init(&sc, dmx_fd, STREAM_BUF_SIZ, STREAM_BUF_CNT);
+	if (rc < 0) {
+		PERROR("stream_init failed: error %d, %s\n", 
+				errno, strerror(errno));
+		/** We dont know what failed during stream_init 
+		 * reqbufs, mmap or  qbuf. We will call stream_deinit
+		 * to delete the mapping which might have been created
+		 */
+		goto ret_null;
+	}
+#endif
+
 	dvb_scan_handler = dvb_scan_alloc_handler_table(delivery_system);
 	if (!dvb_scan_handler)
-		return NULL;
+		goto ret_null;
 
 	if (!timeout_multiply)
 		timeout_multiply = 1;
@@ -501,11 +561,11 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 			      (void **)&dvb_scan_handler->pat,
 			      pat_pmt_time * timeout_multiply);
 	if (parms->p.abort)
-		return dvb_scan_handler;
+		goto ret_handler;
 	if (rc < 0) {
 		dvb_logerr(_("error while waiting for PAT table"));
 		dvb_scan_free_handler_table(dvb_scan_handler);
-		return NULL;
+		goto ret_null;
 	}
 	if (parms->p.verbose)
 		dvb_table_pat_print(&parms->p, dvb_scan_handler->pat);
@@ -517,7 +577,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 				      (void **)&dvb_scan_handler->vct,
 				      vct_time * timeout_multiply);
 		if (parms->p.abort)
-			return dvb_scan_handler;
+			goto ret_handler;
 		if (rc < 0)
 			dvb_logerr(_("error while waiting for VCT table"));
 		else if (parms->p.verbose)
@@ -547,7 +607,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 				      pat_pmt_time * timeout_multiply);
 		if (parms->p.abort) {
 			dvb_scan_handler->num_program = num_pmt + 1;
-			return dvb_scan_handler;
+			goto ret_handler;
 		}
 		if (rc < 0) {
 			dvb_logerr(_("error while reading the PMT table for service 0x%04x"),
@@ -568,7 +628,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 			      (void **)&dvb_scan_handler->nit,
 			      nit_time * timeout_multiply);
 	if (parms->p.abort)
-		return dvb_scan_handler;
+		goto ret_handler;
 	if (rc < 0)
 		dvb_logerr(_("error while reading the NIT table"));
 	else if (parms->p.verbose)
@@ -581,7 +641,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 				(void **)&dvb_scan_handler->sdt,
 				sdt_time * timeout_multiply);
 		if (parms->p.abort)
-			return dvb_scan_handler;
+			goto ret_handler;
 		if (rc < 0)
 			dvb_logerr(_("error while reading the SDT table"));
 		else if (parms->p.verbose)
@@ -597,7 +657,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 				      (void **)&dvb_scan_handler->nit,
 				      nit_time * timeout_multiply);
 		if (parms->p.abort)
-			return dvb_scan_handler;
+			goto ret_handler;
 		if (rc < 0)
 			dvb_logerr(_("error while reading the NIT table"));
 		else if (parms->p.verbose)
@@ -608,13 +668,23 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *__p,
 				(void **)&dvb_scan_handler->sdt,
 				sdt_time * timeout_multiply);
 		if (parms->p.abort)
-			return dvb_scan_handler;
+			goto ret_handler;
 		if (rc < 0)
 			dvb_logerr(_("error while reading the SDT table"));
 		else if (parms->p.verbose)
 			dvb_table_sdt_print(&parms->p, dvb_scan_handler->sdt);
 	}
 
+ret_null:
+#ifdef VB2
+	stream_deinit(&sc);
+#endif
+	return NULL;
+
+ret_handler:
+#ifdef VB2
+	stream_deinit(&sc);
+#endif
 	return dvb_scan_handler;
 }
 
diff --git a/lib/libdvbv5/dvb-vb2.c b/lib/libdvbv5/dvb-vb2.c
new file mode 100644
index 0000000..4f317a0
--- /dev/null
+++ b/lib/libdvbv5/dvb-vb2.c
@@ -0,0 +1,320 @@
+/*
+ * Copyright (c) 2017-2018 - Mauro Carvalho Chehab
+ * Copyright (c) 2017-2018 - Junghak Sung <jh1009.sung@samsung.com> 
+ * Copyright (c) 2017-2018 - Satendra Singh Thakur <satendra.t@samsung.com>
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation version 2.1 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ */
+
+/******************************************************************************
+ * Implements videobuf2 streaming APIs for DVB
+ *****************************************************************************/
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <stdlib.h>
+#include <sys/time.h>
+
+#include <config.h>
+
+#include <sys/mman.h>
+#include <libdvbv5/dvb-vb2.h>
+
+/**These 2 params are for DVR*/
+#define STREAM_BUF_CNT (10)
+#define STREAM_BUF_SIZ (188*1024)
+/*Sleep time for retry, in case ioctl fails*/
+#define SLEEP_US	1000
+
+static inline int xioctl(int fd, unsigned long int cmd, void *arg)
+{
+	int ret;							
+	struct timespec stime, etime;					
+	long long etimell = 0, stimell = 0;
+	clock_gettime(CLOCK_MONOTONIC, &stime);			
+	do {								
+		ret = ioctl(fd, cmd, arg);
+		if (ret < 0 && (errno == EINTR || errno == EAGAIN)) {					
+			clock_gettime(CLOCK_MONOTONIC, &etime);			
+			etimell = (long long) etime.tv_sec * 1000000000 +
+					etime.tv_nsec;
+			stimell = (long long) (stime.tv_sec + 1 /*1 sec wait*/)
+					* 1000000000 + stime.tv_nsec;
+			if (etimell > stimell)
+				break;
+				/*wait for some time to prevent cpu hogging*/
+				usleep(SLEEP_US);						
+				continue;
+		}
+		else
+			break;
+	} while (1);							
+									
+        return ret;
+}
+
+
+/**
+ * stream_qbuf - Enqueues a buffer specified by index
+ *
+ * @param sc		Context for streaming management
+ *			Pointer to &struct stream_ctx
+ * @param idx		Index of the buffer
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_qbuf(struct stream_ctx *sc, int idx)
+{
+	struct dmx_buffer buf;
+	int ret;
+
+	memzero(buf);
+	buf.index = idx;
+
+	ret = xioctl(sc->in_fd, DMX_QBUF, &buf);
+	if (ret < 0) {
+		PERROR("DMX_QBUF failed: error=%d", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+/**
+ * stream_dqbuf - Dequeues a buffer specified by index
+ *
+ * @param sc		Context for streaming management
+ *			Pointer to &struct stream_ctx
+ * @param buf		Pointer to &struct dmx_buffer
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_dqbuf(struct stream_ctx *sc, struct dmx_buffer *buf)
+{
+	int ret;
+
+	ret = xioctl(sc->in_fd, DMX_DQBUF, buf);
+	if (ret < 0) {
+		PERROR("DMX_DQBUF failed: error=%d", ret);
+		return ret;
+	}
+
+	return ret;
+}
+/**
+ * sream_expbuf - Exports a buffer specified by buf argument
+ *
+ * @param sc		Context for streaming management
+ *			Pointer to &struct stream_ctx
+ * @param idx		Buffer index
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_expbuf(struct stream_ctx *sc, int idx)
+{
+	int ret;
+	struct dmx_exportbuffer exp;
+	memzero(exp);
+	exp.index = idx;
+	ret = ioctl(sc->in_fd, DMX_EXPBUF, &exp);
+	if (ret) {
+		PERROR("DMX_EXPBUF failed: buf=%d error=%d", idx, ret);
+		return ret;
+	}
+	sc->exp_fd[idx] = exp.fd;
+	fprintf(stderr, "Export buffer %d (fd=%d)\n",
+			idx, sc->exp_fd[idx]);
+	return ret;
+}
+/**
+ * stream_init - Requests number of buffers from memory
+ * Gets pointer to the buffers from driver, mmaps those buffers
+ * and stores them in an array
+ * Also, optionally exports those buffers
+ *
+ * @param sc		Context for streaming management
+ * @param in_fd		File descriptor of the streaming device
+ * @param buf_size	Size of the buffer
+ * @param buf_cnt	Count of the buffers
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+int stream_init(struct stream_ctx *sc, int in_fd, int buf_size, int buf_cnt)
+{
+	struct dmx_requestbuffers req;
+	struct dmx_buffer buf;
+	int ret;
+	int i;
+
+	memset(sc, 0, sizeof(struct stream_ctx));
+	sc->in_fd = in_fd;
+	sc->buf_size = buf_size;
+	sc->buf_cnt = buf_cnt;
+
+	memzero(req);
+	req.count = sc->buf_cnt;
+	req.size = sc->buf_size;
+
+	ret = xioctl(in_fd, DMX_REQBUFS, &req);
+	if (ret) {
+		PERROR("DMX_REQBUFS failed: error=%d", ret);
+		return ret;
+	}
+
+	if (sc->buf_cnt != req.count) {
+		PERROR("buf_cnt %d -> %d changed !!!\n",
+				sc->buf_cnt, req.count);
+		sc->buf_cnt = req.count;
+	}
+
+	for (i = 0; i < sc->buf_cnt; i++) {
+		memzero(buf);
+		buf.index = i;
+
+		ret = xioctl(in_fd, DMX_QUERYBUF, &buf);
+		if (ret) {
+			PERROR("DMX_QUERYBUF failed: buf=%d error=%d", i, ret);
+			return ret;
+		}
+
+		sc->buf[i] = mmap(NULL, buf.length,
+					PROT_READ | PROT_WRITE, MAP_SHARED,
+					in_fd, buf.offset);
+
+		if (sc->buf[i] == MAP_FAILED) {
+			PERROR("Failed to MMAP buffer %d", i);
+			return -1;
+		}
+		/**enqueue the buffers*/	
+		ret = stream_qbuf(sc, i);
+		if (ret) {
+			PERROR("stream_qbuf failed: buf=%d error=%d", i, ret);
+			return ret;
+		}
+		
+		sc->buf_flag[i] = 1;
+	}
+
+	return 0;
+}
+
+/**
+ * stream_deinit - Dequeues and unmaps the buffers
+ *
+ * @param sc - Context for streaming management
+ *
+ * @return At return, it returns a negative value if error or
+ * zero on success.
+ */
+void stream_deinit(struct stream_ctx *sc)
+{
+	struct dmx_buffer buf;
+	int ret;
+	int i;
+
+	for (i = 0; i < sc->buf_cnt; i++) {
+		memzero(buf);
+		buf.index = i;
+		
+		if (sc->buf_flag[i]) {
+			ret = stream_dqbuf(sc, &buf);
+			if (ret) {
+				PERROR("stream_dqbuf failed: buf=%d error=%d",
+					 i, ret);
+			}
+		}
+		ret = munmap(sc->buf[i], sc->buf_size);
+		if (ret) {
+			PERROR("munmap failed: buf=%d error=%d", i, ret);
+		}
+
+	}
+
+	return;
+}
+
+/**
+ * stream_to_file - Implements enqueue and dequeue logic
+ * First enqueues all the available buffers then dequeues
+ * one buffer, again enqueues it and so on.
+ *
+ * @param in_fd		File descriptor of the streaming device
+ * @param out_fd	File descriptor of output file
+ * @param timeout	Timeout in seconds
+ * @param dbg_level	Debug flag
+ * @param exit_flag	Flag to exit
+ *
+ * @return void
+ */
+void stream_to_file(int in_fd, int out_fd, int timeout, int dbg_level,
+			int *exit_flag)
+{
+	struct stream_ctx sc;
+	int ret;
+	long long int rc = 0LL;
+
+	ret = stream_init(&sc, in_fd, STREAM_BUF_CNT, STREAM_BUF_SIZ);
+	if (ret < 0) {
+		PERROR("[%s] Failed to setup buffers!!!", __func__);
+		sc.error = 1;
+		return;
+	}
+	fprintf(stderr, "start streaming!!!\n");
+
+	while (!*exit_flag  && !sc.error) {
+		/* dequeue the buffer */
+		struct dmx_buffer b;
+		
+		memzero(b);
+		ret = stream_dqbuf(&sc, &b);
+		if (ret < 0) {
+			sc.error = 1;
+			break;
+		}
+		else {
+			sc.buf_flag[b.index] = 0;
+			ret = write(sc.out_fd, sc.buf[b.index],
+					b.bytesused);
+			if (ret < 0) {
+				PERROR("Write failed err=%d", ret);
+				break;
+			} else
+				rc += b.bytesused;
+		}
+
+		/* enqueue the buffer */
+		ret = stream_qbuf(&sc, b.index);
+		if (ret < 0)
+			sc.error = 1;
+		else
+			sc.buf_flag[b.index] = 1;
+	}
+	if (dbg_level < 2) {
+		fprintf(stderr, "copied %lld bytes (%lld Kbytes/sec)\n", rc,
+			rc / (1024 * timeout));
+	}
+	stream_deinit(&sc);
+}
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 5567736..148da38 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -33,6 +33,7 @@
 #include <signal.h>
 #include <argp.h>
 #include <sys/time.h>
+#include <sys/mman.h>
 
 #include <config.h>
 
@@ -55,6 +56,7 @@
 #include "libdvbv5/dvb-scan.h"
 #include "libdvbv5/header.h"
 #include "libdvbv5/countries.h"
+#include "libdvbv5/dvb-vb2.h"
 
 #define CHANNEL_FILE	"channels.conf"
 #define PROGRAM_NAME	"dvbv5-zap"
@@ -72,6 +74,7 @@ struct arguments {
 	unsigned n_apid, n_vpid, all_pids;
 	enum dvb_file_formats input_format, output_format;
 	unsigned traffic_monitor, low_traffic, non_human, port;
+	unsigned int streaming;
 	char *search, *server;
 	const char *cc;
 
@@ -94,6 +97,7 @@ static const struct argp_option options[] = {
 	{"pat",		'p', NULL,			0, N_("add pat and pmt to TS recording (implies -r)"), 0},
 	{"all-pids",	'P', NULL,			0, N_("don't filter any pids. Instead, outputs all of them"), 0 },
 	{"record",	'r', NULL,			0, N_("set up /dev/dvb/adapterX/dvr0 for TS recording"), 0},
+	{"streaming",	'R', NULL,			0, N_("uses streaming I/O for TS recording"), 0},
 	{"silence",	's', NULL,			0, N_("increases silence (can be used more than once)"), 0},
 	{"sat_number",	'S', N_("satellite_number"),	0, N_("satellite number. If not specified, disable DISEqC"), 0},
 	{"timeout",	't', N_("seconds"),		0, N_("timeout for zapping and for recording"), 0},
@@ -493,6 +497,7 @@ static void get_show_stats(struct arguments *args,
 	} while (!timeout_flag && loop);
 }
 
+
 #define BUFLEN (188 * 256)
 static void copy_to_file(struct dvb_open_descriptor *in_fd, int out_fd,
 			 int timeout, int silent)
@@ -551,6 +556,10 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 	case 'r':
 		args->dvr = 1;
 		break;
+	case 'R':
+		args->dvr = 1;
+		args->streaming = 1;
+		break;
 	case 'p':
 		args->rec_psi = 1;
 		break;
@@ -1083,14 +1092,32 @@ int main(int argc, char **argv)
 			get_show_stats(&args, parms, 0);
 
 		if (file_fd >= 0) {
-			dvr_fd = dvb_dev_open(dvb, args.dvr_dev, O_RDONLY);
+			int flag, fd;
+
+			if (args.streaming)
+				flag = O_RDWR;
+			else
+				flag = O_RDONLY;
+
+			dvr_fd = dvb_dev_open(dvb, args.dvr_dev, flag);
 			if (!dvr_fd) {
 				ERROR("failed opening '%s'", args.dvr_dev);
 				goto err;
 			}
 			if (!timeout_flag)
 				fprintf(stderr, _("Record to file '%s' started\n"), args.filename);
-			copy_to_file(dvr_fd, file_fd, args.timeout, args.silent);
+			if (args.streaming) {
+				fd = dvb_dev_get_fd(dvr_fd);
+				if (fd < 0) {
+					ERROR("Invalid fd for '%s'",
+						args.dvr_dev);
+					goto err;
+				}
+				stream_to_file(fd, file_fd, args.timeout,
+						args.silent, &timeout_flag);
+			} else
+				copy_to_file(dvr_fd, file_fd, args.timeout,
+						args.silent);
 		} else if (args.server && args.port) {
 			struct stat st;
 			if (stat(args.dvr_pipe, &st) == -1) {
-- 
2.7.4
