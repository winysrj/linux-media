Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57947 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab3KQURu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:17:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 2/6] v4l2: add sdr-fetch test app
Date: Sun, 17 Nov 2013 22:17:28 +0200
Message-Id: <1384719452-21744-3-git-send-email-crope@iki.fi>
In-Reply-To: <1384719452-21744-1-git-send-email-crope@iki.fi>
References: <1384719452-21744-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That simple app reads data from SDR device using libv4l2 and writes
it in float format to standard output. Stream is converted to
complex float format by libv4l.

sdr-fetch is based of v4l2grab v4l2 test app.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 contrib/test/Makefile.am |   6 +-
 contrib/test/sdr_fetch.c | 221 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 contrib/test/sdr_fetch.c

diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 80c7665..3332b63 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -7,7 +7,8 @@ noinst_PROGRAMS = \
 	v4l2grab		\
 	driver-test		\
 	stress-buffer		\
-	capture-example
+	capture-example		\
+	sdr-fetch
 
 if HAVE_X11
 noinst_PROGRAMS += pixfmt-test
@@ -45,6 +46,9 @@ stress_buffer_SOURCES = stress-buffer.c
 
 capture_example_SOURCES = capture-example.c
 
+sdr_fetch_SOURCES = sdr_fetch.c
+sdr_fetch_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
+
 ioctl-test.c: ioctl-test.h
 
 sync-with-kernel:
diff --git a/contrib/test/sdr_fetch.c b/contrib/test/sdr_fetch.c
new file mode 100644
index 0000000..477d11e
--- /dev/null
+++ b/contrib/test/sdr_fetch.c
@@ -0,0 +1,221 @@
+/*
+ * SDR fetch
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <config.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <signal.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/time.h>
+#include <sys/mman.h>
+#include <argp.h>
+#include <linux/videodev2.h>
+#include "../../lib/include/libv4l2.h"
+
+/* signal handler to stop app */
+static int running;
+
+void signal_handler(int sig)
+{
+	running = 0;
+	return;
+}
+
+#define CLEAR(x) memset(&(x), 0, sizeof(x))
+
+struct buffer {
+	void *start;
+	size_t length;
+};
+
+static void xioctl(int fh, unsigned long int request, void *arg)
+{
+	int ret;
+
+	do {
+		ret = v4l2_ioctl(fh, request, arg);
+	} while (ret == -1 && ((errno == EINTR) || (errno == EAGAIN)));
+	if (ret == -1) {
+		fprintf(stderr, "error %d, %s\n", errno, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+}
+
+static int stream(char *dev_name)
+{
+	struct v4l2_format fmt;
+	struct v4l2_buffer buf;
+	struct v4l2_requestbuffers req;
+	enum v4l2_buf_type type;
+	struct buffer *buffers;
+	struct timeval tv;
+	fd_set fds;
+	int ret, i, buffers_count, fd = -1;
+
+	fd = v4l2_open(dev_name, O_RDWR | O_NONBLOCK, 0);
+	if (fd < 0) {
+		perror("Cannot open device");
+		exit(EXIT_FAILURE);
+	}
+
+	/* ask float format from libv4l2 */
+	CLEAR(fmt);
+	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SDR_FLOAT;
+	xioctl(fd, VIDIOC_S_FMT, &fmt);
+	if (fmt.fmt.pix.pixelformat != V4L2_PIX_FMT_SDR_FLOAT) {
+		perror("Libv4l didn't accept FLOAT format");
+		exit(EXIT_FAILURE);
+	}
+
+	/* request buffers */
+	CLEAR(req);
+	req.count = 8;
+	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	req.memory = V4L2_MEMORY_MMAP;
+	xioctl(fd, VIDIOC_REQBUFS, &req);
+
+	buffers = calloc(req.count, sizeof(*buffers));
+
+	/* v4l2_mmap buffers */
+	for (buffers_count = 0; buffers_count < req.count; buffers_count++) {
+		CLEAR(buf);
+		buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		buf.memory      = V4L2_MEMORY_MMAP;
+		buf.index       = buffers_count;
+		xioctl(fd, VIDIOC_QUERYBUF, &buf);
+
+		buffers[buffers_count].length = buf.length;
+		buffers[buffers_count].start = v4l2_mmap(NULL, buf.length,
+			      PROT_READ | PROT_WRITE, MAP_SHARED,
+			      fd, buf.m.offset);
+
+		if (buffers[buffers_count].start == MAP_FAILED) {
+			perror("mmap");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	/* enqueue all memory mapped buffers */
+	for (i = 0; i < buffers_count; i++) {
+		CLEAR(buf);
+		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		buf.memory = V4L2_MEMORY_MMAP;
+		buf.index = i;
+		xioctl(fd, VIDIOC_QBUF, &buf);
+	}
+
+	/* start streaming */
+	type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	xioctl(fd, VIDIOC_STREAMON, &type);
+
+	/* data streaming */
+	while (running) {
+		/* wait data arrives from device */
+		do {
+			FD_ZERO(&fds);
+			FD_SET(fd, &fds);
+
+			/* timeout */
+			tv.tv_sec = 2;
+			tv.tv_usec = 0;
+
+			ret = select(fd + 1, &fds, NULL, NULL, &tv);
+		} while ((ret == -1 && (errno == EINTR)));
+		if (ret == -1) {
+			perror("select");
+			return errno;
+		}
+
+		CLEAR(buf);
+		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		buf.memory = V4L2_MEMORY_MMAP;
+		xioctl(fd, VIDIOC_DQBUF, &buf);
+
+		/* write data to standard output */
+		fwrite(buffers[buf.index].start, buf.bytesused, 1, stdout);
+
+		xioctl(fd, VIDIOC_QBUF, &buf);
+	}
+
+	/* stop streaming */
+	type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	xioctl(fd, VIDIOC_STREAMOFF, &type);
+
+	/* v4l2_munmap buffers */
+	for (i = buffers_count - 1; i >= 0; i--)
+		v4l2_munmap(buffers[i].start, buffers[i].length);
+
+	free(buffers);
+
+	v4l2_close(fd);
+
+	return 0;
+}
+
+const char *argp_program_version = "SDR fetch version " V4L_UTILS_VERSION;
+const char *argp_program_bug_address = "Antti Palosaari <crope@iki.fi>";
+
+static const char doc[] =
+	"\n"
+	"Reads data from SDR device using libv4l2 and writes it in float format to standard output\n";
+
+static const struct argp_option options[] = {
+	{"device",	'd',	"DEV",	0,	"SDR device (default: /dev/video0)",	0},
+	{ 0, 0, 0, 0, 0, 0 }
+};
+
+/* Static vars to store the parameters */
+static char *dev_name = "/dev/video0";
+
+static error_t parse_opt(int k, char *arg, struct argp_state *state)
+{
+	switch (k) {
+	case 'd':
+		dev_name = arg;
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+	return 0;
+}
+
+static struct argp argp = {
+	.options = options,
+	.parser = parse_opt,
+	.doc = doc,
+};
+
+int main(int argc, char **argv)
+{
+	/* arguments */
+	argp_parse(&argp, argc, argv, 0, 0, 0);
+
+	/* signal handler */
+	running = 1;
+	signal(SIGQUIT, signal_handler);
+	signal(SIGINT, signal_handler);
+
+	return stream(dev_name);
+}
-- 
1.8.4.2

