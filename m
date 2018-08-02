Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50356 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbeHBWmK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 18:42:10 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 6/6] selftests: media_tests: Add a memory-to-memory concurrent stress test
Date: Thu,  2 Aug 2018 17:48:50 -0300
Message-Id: <20180802204850.31633-7-ezequiel@collabora.com>
In-Reply-To: <20180802204850.31633-1-ezequiel@collabora.com>
References: <20180802204850.31633-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a test for the memory-to-memory framework, to exercise the
scheduling of concurrent jobs, using multiple contexts.

This test needs to be run using the vim2m virtual driver,
and so needs no hardware.

While here, rework the media_tests suite in order to make it
useful for automatic tools. Those tests that need human intervention
are now separated from those that can run automatically, needing
only virtual drivers to work.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../testing/selftests/media_tests/.gitignore  |   1 +
 tools/testing/selftests/media_tests/Makefile  |   5 +-
 .../selftests/media_tests/m2m_job_test.c      | 287 ++++++++++++++++++
 .../selftests/media_tests/m2m_job_test.sh     |  32 ++
 4 files changed, 324 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/media_tests/m2m_job_test.c
 create mode 100755 tools/testing/selftests/media_tests/m2m_job_test.sh

diff --git a/tools/testing/selftests/media_tests/.gitignore b/tools/testing/selftests/media_tests/.gitignore
index 8745eba39012..71c6508348ce 100644
--- a/tools/testing/selftests/media_tests/.gitignore
+++ b/tools/testing/selftests/media_tests/.gitignore
@@ -1,3 +1,4 @@
 media_device_test
 media_device_open
 video_device_test
+m2m_job_test
diff --git a/tools/testing/selftests/media_tests/Makefile b/tools/testing/selftests/media_tests/Makefile
index 60826d7d37d4..d25d4c3eb7d2 100644
--- a/tools/testing/selftests/media_tests/Makefile
+++ b/tools/testing/selftests/media_tests/Makefile
@@ -1,6 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 CFLAGS += -I../ -I../../../../usr/include/
-TEST_GEN_PROGS := media_device_test media_device_open video_device_test
+TEST_GEN_PROGS_EXTENDED := media_device_test media_device_open video_device_test m2m_job_test
+TEST_PROGS := m2m_job_test.sh
 
 include ../lib.mk
+
+LDLIBS += -lpthread
diff --git a/tools/testing/selftests/media_tests/m2m_job_test.c b/tools/testing/selftests/media_tests/m2m_job_test.c
new file mode 100644
index 000000000000..5800269567e6
--- /dev/null
+++ b/tools/testing/selftests/media_tests/m2m_job_test.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Copyright (c) Collabora, Ltd.
+
+/*
+ * This file adds a test for the memory-to-memory
+ * framework.
+ *
+ * This test opens a user specified video device and then
+ * queues concurrent jobs. The jobs are totally dummy,
+ * its purpose is only to verify that each of the queued
+ * jobs is run, and is run only once.
+ *
+ * The vim2m driver is needed in order to run the test.
+ *
+ * Usage:
+ *      ./m2m-job-test -d /dev/videoX
+ */
+
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <time.h>
+#include <pthread.h>
+#include <poll.h>
+
+#include <linux/videodev2.h>
+
+#include "../kselftest.h"
+
+#define V4L2_CID_TRANS_TIME_MSEC        (V4L2_CID_USER_BASE + 0x1000)
+#define V4L2_CID_TRANS_NUM_BUFS         (V4L2_CID_USER_BASE + 0x1001)
+
+#define MAX_TRANS_TIME_MSEC 500
+#define MAX_COUNT 50
+#define MAX_BUFFERS 5
+#define W 10
+#define H 10
+
+#ifndef DEBUG
+#define dprintf(fmt, arg...)			\
+	do {					\
+	} while (0)
+#else
+#define dprintf(fmt, arg...) printf(fmt, ## arg)
+#endif
+
+static char video_device[256];
+static int thread_count;
+
+struct context {
+	int vfd;
+	unsigned int width;
+	unsigned int height;
+	int buffers;
+};
+
+static int req_src_buf(struct context *ctx, int buffers)
+{
+	struct v4l2_requestbuffers reqbuf;
+	struct v4l2_buffer buf;
+	int i, ret;
+
+	memset(&reqbuf, 0, sizeof(reqbuf));
+	memset(&buf, 0, sizeof(buf));
+
+	reqbuf.count	= buffers;
+	reqbuf.type	= V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	reqbuf.memory	= V4L2_MEMORY_MMAP;
+	ret = ioctl(ctx->vfd, VIDIOC_REQBUFS, &reqbuf);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < buffers; i++) {
+		buf.type	= V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		buf.memory	= V4L2_MEMORY_MMAP;
+		buf.index	= i;
+		ret = ioctl(ctx->vfd, VIDIOC_QUERYBUF, &buf);
+		if (ret)
+			return ret;
+		buf.bytesused = W*H*2;
+		ret = ioctl(ctx->vfd, VIDIOC_QBUF, &buf);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int req_dst_buf(struct context *ctx, int buffers)
+{
+	struct v4l2_requestbuffers reqbuf;
+	struct v4l2_buffer buf;
+	int i, ret;
+
+	memset(&reqbuf, 0, sizeof(reqbuf));
+	memset(&buf, 0, sizeof(buf));
+
+	reqbuf.count	= buffers;
+	reqbuf.type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	reqbuf.memory	= V4L2_MEMORY_MMAP;
+
+	ret = ioctl(ctx->vfd, VIDIOC_REQBUFS, &reqbuf);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < buffers; i++) {
+		buf.type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		buf.memory	= V4L2_MEMORY_MMAP;
+		buf.index	= i;
+		ret = ioctl(ctx->vfd, VIDIOC_QUERYBUF, &buf);
+		if (ret)
+			return ret;
+		ret = ioctl(ctx->vfd, VIDIOC_QBUF, &buf);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int streamon(struct context *ctx)
+{
+	enum v4l2_buf_type type;
+	int ret;
+
+	type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ret = ioctl(ctx->vfd, VIDIOC_STREAMON, &type);
+	if (ret)
+		return ret;
+
+	type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = ioctl(ctx->vfd, VIDIOC_STREAMON, &type);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+static int dqbuf(struct context *ctx)
+{
+	struct v4l2_buffer buf;
+	int i, ret, timeout;
+
+	struct pollfd fds[] = {
+		{ .fd = ctx->vfd, .events = POLLIN },
+	};
+
+	for (i = 0; i < ctx->buffers; i++) {
+		timeout = (MAX_TRANS_TIME_MSEC + 10) * thread_count * 2;
+		ret = poll(fds, 1, timeout);
+		if (-1 == ret) {
+			if (errno == EINTR)
+				continue;
+			return -1;
+		}
+
+		if (ret == 0) {
+			dprintf("%s: timeout on %p\n", __func__, ctx);
+			return -1;
+		}
+
+		dprintf("%s: event on %p\n", __func__, ctx);
+
+		memset(&buf, 0, sizeof(buf));
+		buf.type	= V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		buf.memory	= V4L2_MEMORY_MMAP;
+		buf.index	= i;
+		ret = ioctl(ctx->vfd, VIDIOC_DQBUF, &buf);
+		if (ret) {
+			dprintf("%s: VIDIOC_DQBUF failed %p\n", __func__, ctx);
+			return ret;
+		}
+
+		memset(&buf, 0, sizeof(buf));
+		buf.type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		buf.memory	= V4L2_MEMORY_MMAP;
+		buf.index	= i;
+		ret = ioctl(ctx->vfd, VIDIOC_DQBUF, &buf);
+		if (ret) {
+			dprintf("%s: VIDIOC_DQBUF failed %p\n", __func__, ctx);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void *job(void *arg)
+{
+	struct context *ctx = (struct context *)arg;
+
+	dprintf("%s: %p running\n", __func__, ctx);
+
+	assert(streamon(ctx) == 0);
+	assert(dqbuf(ctx) == 0);
+	assert(dqbuf(ctx) != 0);
+	close(ctx->vfd);
+
+	dprintf("%s: %p done\n", __func__, ctx);
+	return NULL;
+}
+
+static void init(struct context *ctx)
+{
+	struct v4l2_ext_controls ext_ctrls;
+	struct v4l2_ext_control ctrls[2];
+	struct v4l2_capability cap;
+	int ret, buffers;
+
+	memset(ctx, 0, sizeof(*ctx));
+
+	ctx->vfd = open(video_device, O_RDWR | O_NONBLOCK, 0);
+	ctx->width = W;
+	ctx->height = H;
+	assert(ctx->vfd >= 0);
+
+	ret = ioctl(ctx->vfd, VIDIOC_QUERYCAP, &cap);
+	assert(ret == 0);
+	assert(cap.device_caps & V4L2_CAP_VIDEO_M2M);
+	if (strcmp((const char *)cap.driver, "vim2m") != 0)
+		ksft_exit_skip("Please run the test as root - Exiting.\n");
+
+	ctrls[0].id = V4L2_CID_TRANS_TIME_MSEC;
+	ctrls[0].value = rand() % MAX_TRANS_TIME_MSEC + 10;
+	ctrls[1].id =  V4L2_CID_TRANS_NUM_BUFS;
+	ctrls[1].value = 1;
+
+	memset(&ext_ctrls, 0, sizeof(ext_ctrls));
+	ext_ctrls.count = 2;
+	ext_ctrls.controls = ctrls;
+	ret = ioctl(ctx->vfd, VIDIOC_S_EXT_CTRLS, &ext_ctrls);
+	assert(ret == 0);
+
+	buffers = rand() % MAX_BUFFERS + 1;
+	assert(req_src_buf(ctx, buffers) == 0);
+	assert(req_dst_buf(ctx, buffers) == 0);
+	ctx->buffers = buffers;
+}
+
+int main(int argc, char * const argv[])
+{
+	int i, opt;
+
+	if (argc < 2) {
+		printf("Usage: %s [-d </dev/videoX>]\n", argv[0]);
+		exit(-1);
+	}
+
+	/* Process arguments */
+	while ((opt = getopt(argc, argv, "d:")) != -1) {
+		switch (opt) {
+		case 'd':
+			strncpy(video_device, optarg, sizeof(video_device) - 1);
+			video_device[sizeof(video_device)-1] = '\0';
+			break;
+		default:
+			printf("Usage: %s [-d </dev/videoX>]\n", argv[0]);
+			exit(-1);
+		}
+	}
+
+	/* Generate random number of interations */
+	srand((unsigned int) time(NULL));
+	thread_count = rand() % MAX_COUNT + 1;
+
+	pthread_t in_thread[thread_count];
+	struct context ctx[thread_count];
+
+	printf("Running %d threads\n", thread_count);
+
+	for (i = 0; i < thread_count; i++)
+		init(&ctx[i]);
+
+	for (i = 0; i < thread_count; i++)
+		pthread_create(&in_thread[i], NULL, job, &ctx[i]);
+
+	for (i = 0; i < thread_count; i++)
+		pthread_join(in_thread[i], NULL);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/media_tests/m2m_job_test.sh b/tools/testing/selftests/media_tests/m2m_job_test.sh
new file mode 100755
index 000000000000..59777a7ac7d8
--- /dev/null
+++ b/tools/testing/selftests/media_tests/m2m_job_test.sh
@@ -0,0 +1,32 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+TCID="media_device"
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+echo "-------------------"
+echo "running media tests"
+echo "-------------------"
+
+# Not needed, but does not hurt to have it
+shopt -s nullglob
+
+v4l=/sys/class/video4linux
+
+if [ ! -d $v4l ]; then
+        echo "$TCID : video4linux support not present"
+        exit $ksft_skip
+fi
+
+if [ -z `ls $v4l` ]; then
+	echo "$TCID : no video4linux drivers loaded, vim2m is needed"
+	exit $ksft_skip
+fi
+
+for f in $v4l/*; do
+	dev_node=/dev/`basename $f`
+	if [ -c $dev_node ]; then
+		./m2m_job_test -d $dev_node
+	fi
+done
-- 
2.18.0
