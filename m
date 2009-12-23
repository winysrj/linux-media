Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23146 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZLWKJB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 05:09:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 23 Dec 2009 11:08:53 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [EXAMPLE] S3C/S5P image rotator test application
In-reply-to: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1261562933-26987-4-git-send-email-p.osciak@samsung.com>
References: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an example application for testing the S3C/S5P rotator device.
It uses framebuffer memory for its source and destination buffers, as the
device requires them to be in contiguous memory.
Source image is read from a file passed as an argument and saved to another
file, which name is also passed as an argument.

Configurable parameters: video_node in_file, out_file, format, width, height,
                         rotation, flip

Where:
video_node: video node number
in_file/out_file: source/destination raw image data
format: 0: 420, 1: 422, 2: 565, 3: 888
width/height: dimensions of both images
rotation: 90, 180, 270
flip (when rotation==0): 1: horizontal, 2: vertical

---

--- /dev/null	2009-11-17 07:51:25.574927259 +0100
+++ rotator-dma-contig.c	2009-12-22 17:22:25.000000000 +0100
@@ -0,0 +1,375 @@
+/*
+ * Samsung S3C/S5P image rotator test application.
+ *
+ * Copyright (c) 2009 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <p.osciak@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <assert.h>
+#include <errno.h>
+#include <time.h>
+
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <stdint.h>
+
+#include <linux/fb.h>
+#include <linux/videodev2.h>
+
+#define VIDEO_DEV_NAME	"/dev/video"
+#define FB_DEV_NAME	"/dev/fb0"
+
+#define NUM_SRC_BUFS	1
+#define NUM_DST_BUFS	1
+
+#define V4L2_CID_PRIVATE_ROTATE (V4L2_CID_PRIVATE_BASE + 0)
+
+#define perror_exit(cond, func)\
+	if (cond) {\
+		fprintf(stderr, "%s:%d: ", __func__, __LINE__);\
+		perror(func);\
+		exit(EXIT_FAILURE);\
+	}
+
+#define error_exit(cond, msg)\
+	if (cond) {\
+		fprintf(stderr, "%s:%d: " msg "\n", __func__, __LINE__);\
+		exit(EXIT_FAILURE);\
+	}
+
+#define perror_ret(cond, func)\
+	if (cond) {\
+		fprintf(stderr, "%s:%d: ", __func__, __LINE__);\
+		perror(func);\
+		return ret;\
+	}
+
+#define memzero(x)\
+	memset(&(x), 0, sizeof (x));
+
+#ifdef _DEBUG
+#define debug(msg, ...)\
+	fprintf(stderr, "%s: " msg, __func__, ##__VA_ARGS__);
+#else
+#define debug(msg, ...)
+#endif
+
+struct buffer {
+	char *addr;
+	unsigned long size;
+	unsigned int index;
+};
+
+static int vid_fd, fb_fd, src_fd, dst_fd;
+static void *fb_addr, *src_addr, *dst_addr;
+static char *in_file, *out_file;
+static int width, height;
+static off_t fb_line_w, fb_buf_w, fb_size;
+static struct fb_var_screeninfo fbinfo;
+static int in_size;
+static int vid_node = 0;
+static int format, framesize, rotation, flip;
+
+static void set_rotation(int angle)
+{
+	struct v4l2_control ctrl;
+	int ret;
+
+	memzero(ctrl);
+	ctrl.id = V4L2_CID_PRIVATE_ROTATE;
+	ctrl.value = angle;
+	ret = ioctl(vid_fd, VIDIOC_S_CTRL, &ctrl);
+	perror_exit(ret != 0, "ioctl");
+}
+
+static void set_flip(int flip)
+{
+	struct v4l2_control ctrl;
+	int ret;
+
+	memzero(ctrl);
+	switch (flip) {
+	case 1:
+		ctrl.id = V4L2_CID_HFLIP;
+		break;
+	case 2:
+		ctrl.id = V4L2_CID_VFLIP;
+		break;
+	default:
+		error_exit(1, "Invalid params\n");
+	}
+
+	ctrl.value = 1;
+
+	ret = ioctl(vid_fd, VIDIOC_S_CTRL, &ctrl);
+	perror_exit(ret != 0, "ioctl");
+}
+
+static void set_fmt(uint32_t format)
+{
+	struct v4l2_format fmt;
+	int ret;
+	long page_size;
+	
+	memzero(fmt);
+	switch (format) {
+	case 0:
+		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
+		framesize = width * height * 2;
+		fb_buf_w = width * 2;
+		break;
+	case 1:
+		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
+		framesize = (width * height * 3) / 2;
+		fb_buf_w = width * 3 / 2;
+		break;
+	case 2:
+		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565X;
+		framesize = width * height * 2;
+		fb_buf_w = width * 2;
+		break;
+	case 3:
+		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_BGR32;
+		framesize = width * height * 4;
+		fb_buf_w = width * 4;
+		break;
+	default:
+		error_exit(1, "Invalid params\n");
+		break;
+	}
+
+	page_size = sysconf(_SC_PAGESIZE);
+	framesize = (framesize + page_size - 1) & ~(page_size - 1);
+	debug("Framesize: %d\n", framesize);
+
+	/* Set format for capture */
+	fmt.type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt.fmt.pix.width	= width;
+	fmt.fmt.pix.height	= height;
+	fmt.fmt.pix.field	= V4L2_FIELD_ANY;
+
+	ret = ioctl(vid_fd, VIDIOC_S_FMT, &fmt);
+	perror_exit(ret != 0, "ioctl");
+
+	/* The same format for output */
+	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	fmt.fmt.pix.width	= width;
+	fmt.fmt.pix.height	= height;
+	fmt.fmt.pix.field	= V4L2_FIELD_ANY;
+	
+	ret = ioctl(vid_fd, VIDIOC_S_FMT, &fmt);
+	perror_exit(ret != 0, "ioctl");
+}
+
+
+static void verify_caps(void)
+{
+	struct v4l2_capability cap;
+	int ret;
+
+	memzero(cap);
+	ret = ioctl(vid_fd, VIDIOC_QUERYCAP, &cap);
+	perror_exit(ret != 0, "ioctl");
+
+	if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE))
+		error_exit(1, "Device does not support capture\n");
+
+	if (!(cap.capabilities & V4L2_CAP_VIDEO_OUTPUT))
+		error_exit(1, "Device does not support output\n");
+
+	if (!(cap.capabilities & V4L2_CAP_STREAMING))
+		error_exit(1, "Device does not support streaming\n");
+}
+
+static void init_video_dev(void)
+{
+	char devname[64];
+
+	snprintf(devname, 64, "%s%d", VIDEO_DEV_NAME, vid_node);
+	vid_fd = open(devname, O_RDWR | O_NONBLOCK, 0);
+	perror_exit(vid_fd < 0, "open");
+
+	verify_caps();
+}
+
+void init_fb(void)
+{
+	int ret;
+
+	fb_fd = open(FB_DEV_NAME, O_RDWR);
+	perror_exit(fb_fd < 0, "open");
+
+	ret = ioctl(fb_fd, FBIOGET_VSCREENINFO, &fbinfo);
+	perror_exit(ret != 0, "ioctl");
+	debug("fbinfo: xres: %d, xres_virt: %d, yres: %d, yres_virt: %d\n",
+		fbinfo.xres, fbinfo.xres_virtual,
+		fbinfo.yres, fbinfo.yres_virtual);
+
+	fb_line_w = fbinfo.xres_virtual * (fbinfo.bits_per_pixel >> 3);
+	debug("fb_buf_w: %d, fb_line_w: %d\n", fb_buf_w, fb_line_w);
+	fb_size = fb_line_w * fbinfo.yres_virtual;
+
+	fb_addr = mmap(0, fb_size, PROT_WRITE | PROT_READ,
+			MAP_SHARED, fb_fd, 0);
+	perror_exit(fb_addr == MAP_FAILED, "mmap");
+}
+
+static void parse_args(int argc, char *argv[])
+{
+	if (argc != 9) {
+		fprintf(stderr, "Usage: "
+			"%s video_node in_file, out_file, format, width, "
+			"height, rotation, flip\n"
+			"rotations: 90, 180, 270;\n"
+			"flip (when rotation==0): 1 - horiz, 2 - vert\n"
+			"formats: 0: 420, 1: 422, 2: 565, 3: 888\n",
+			argv[0]);
+		error_exit(1, "Invalid number of arguments\n");
+	}
+
+	vid_node = atoi(argv[1]);
+	in_file = argv[2];
+	out_file = argv[3];
+	format = atoi(argv[4]);
+	width = atoi(argv[5]);
+	height = atoi(argv[6]);
+	rotation = atoi(argv[7]);
+	flip = atoi(argv[8]);
+}
+
+static void get_buffer(struct buffer *buf, unsigned int i)
+{
+	if ((i+1) * framesize > fb_size)
+		error_exit(1, "Framebuffer memory won't fit in the buffer\n");
+
+	buf->addr = fb_addr + i * framesize;
+	buf->size = framesize;
+}
+
+static void request_buffers(unsigned int *num_src_bufs,
+			    unsigned int *num_dst_bufs)
+{
+	struct v4l2_requestbuffers reqbuf;
+	int ret;
+
+	memzero(reqbuf);
+	reqbuf.count	= *num_src_bufs;
+	reqbuf.type	= V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	reqbuf.memory	= V4L2_MEMORY_USERPTR;
+	ret = ioctl(vid_fd, VIDIOC_REQBUFS, &reqbuf);
+	perror_exit(ret != 0, "ioctl");
+	*num_src_bufs	= reqbuf.count;
+
+
+	reqbuf.count	= *num_dst_bufs;
+	reqbuf.type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = ioctl(vid_fd, VIDIOC_REQBUFS, &reqbuf);
+	perror_exit(ret != 0, "ioctl");
+	*num_dst_bufs	= reqbuf.count;
+}
+
+static int process(struct buffer *src_buf, struct buffer *dst_buf)
+{
+	struct v4l2_buffer buf;
+	enum v4l2_buf_type type;
+	fd_set read_fds;
+	int r;
+	int ret;
+
+	memzero(buf);
+	buf.type	= V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	buf.memory	= V4L2_MEMORY_USERPTR;
+	buf.index	= src_buf->index;
+	buf.m.userptr	= (unsigned long)src_buf->addr;
+	buf.length	= src_buf->size;
+	type		= V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ret = ioctl(vid_fd, VIDIOC_QBUF, &buf);
+	perror_ret(ret, "ioctl");
+
+	buf.type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf.index	= dst_buf->index;
+	buf.m.userptr	= (unsigned long)dst_buf->addr;
+	buf.length	= dst_buf->size;
+	type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = ioctl(vid_fd, VIDIOC_QBUF, &buf);
+	perror_ret(ret, "ioctl");
+
+	ret = ioctl(vid_fd, VIDIOC_STREAMON, &type);
+	perror_ret(ret, "ioctl");
+
+	FD_ZERO(&read_fds);
+	FD_SET(vid_fd, &read_fds);
+	r = select(vid_fd + 1, &read_fds, NULL, NULL, 0);
+	perror_ret(ret, "ioctl");
+
+	ret = ioctl(vid_fd, VIDIOC_STREAMOFF, &type);
+	perror_ret(ret, "ioctl");
+
+	return 0;
+}
+
+/* Usage: video_node in_file, out_file, format, width, height, rotation, flip
+ * rotations: 90, 180, 270; flip (when rotation==0): 1 - horiz, 2 - vert
+ * formats: 0: 420, 1: 422, 2: 565, 3: 888 */
+int main(int argc, char *argv[])
+{
+	struct stat in_stat;
+	struct buffer src_buffer;
+	struct buffer dst_buffer;
+	int ret = 0;
+	unsigned int num_src_buffers = NUM_SRC_BUFS;
+	unsigned int num_dst_buffers = NUM_DST_BUFS;
+
+	parse_args(argc, argv);
+
+	src_fd = open(in_file, O_RDONLY);
+	perror_exit(src_fd < 0, in_file);
+	fstat(src_fd, &in_stat);
+	in_size = in_stat.st_size;
+	src_addr = mmap(0, in_size, PROT_READ, MAP_SHARED, src_fd, 0);
+	perror_exit(src_addr == MAP_FAILED, "mmap");
+
+	init_fb();
+
+	dst_fd = open(out_file, O_RDWR | O_TRUNC | O_CREAT,
+			S_IRUSR | S_IWUSR );
+	perror_exit(dst_fd < 0, out_file);
+	ftruncate(dst_fd, in_size);
+	dst_addr = mmap(0, in_size, PROT_WRITE, MAP_SHARED, dst_fd, 0);
+	perror_exit(dst_addr == MAP_FAILED, "mmap");
+
+	init_video_dev();
+	set_fmt(format);
+
+	if (rotation)
+		set_rotation(rotation);
+	else
+		set_flip(flip);
+
+	request_buffers(&num_src_buffers, &num_dst_buffers);
+	get_buffer(&src_buffer, 0);
+	src_buffer.index = 0;
+	get_buffer(&dst_buffer, 1);
+	dst_buffer.index = 0;
+
+	memcpy(src_buffer.addr, src_addr, framesize);
+	ret = process(&src_buffer, &dst_buffer);
+	if (ret)
+		return ret;
+
+	memcpy(dst_addr, dst_buffer.addr, framesize);
+
+	return 0;
+}
+
