Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55423 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0BVQKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:10:25 -0500
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KY9000UY3L8KK@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:21 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KY9009QD3L8O0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:20 +0000 (GMT)
Date: Mon, 22 Feb 2010 17:10:10 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [EXAMPLE v1] Test application for multiplane vivi driver.
In-reply-to: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, m-karicheri2@ti.com
Message-id: <1266855010-2198-6-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an example application for testing muliplane buffer V4L2 extensions
with the vivi driver.

---
--- /dev/null	2010-02-15 07:42:03.265396000 +0100
+++ vivi-mplane.c	2010-02-22 16:58:19.925762651 +0100
@@ -0,0 +1,582 @@
+/*
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
+#define NUM_DST_BUFS	4
+
+enum io_method {
+	IO_METHOD_MMAP,
+	IO_METHOD_USERPTR,
+};
+
+#define perror_exit(cond, func)\
+	if (cond) {\
+		fprintf(stderr, "%s:%d: ", __func__, __LINE__);\
+		perror(func);\
+		exit(EXIT_FAILURE);\
+	}
+
+#define error_exit(cond, msg, ...)\
+	if (cond) {\
+		fprintf(stderr, "%s:%d: " msg "\n",\
+			__func__, __LINE__, ##__VA_ARGS__);\
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
+#define error(msg)	fprintf(stderr, "%s:%d: " msg "\n", __func__, __LINE__);
+
+#define _DEBUG
+#ifdef _DEBUG
+#define debug(msg, ...)\
+	fprintf(stderr, "%s: " msg, __func__, ##__VA_ARGS__);
+#else
+#define debug(msg, ...)
+#endif
+
+#define PAGE_ALIGN(addr)	(((addr) + page_size - 1) & ~(page_size -1))
+
+enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+enum format {
+	FMT_422,
+	FMT_565,
+	FMT_422P,
+};
+
+struct buffer {
+	char			*addr[VIDEO_MAX_PLANES];
+	unsigned long		size[VIDEO_MAX_PLANES];
+	unsigned int		num_planes;
+	unsigned int		index;
+	enum format		fmt;
+	unsigned int		width;
+	unsigned int		height;
+	enum v4l2_buf_type	type;
+};
+
+static int vid_fd, fb_fd;
+static void *fb_addr, *fb_alloc_ptr;
+static int width = 200, height = 200;
+static off_t fb_line_w, fb_buf_w, fb_size, fb_pix_dist;
+static struct fb_var_screeninfo fbinfo;
+static int vid_node;
+static int framesize;
+static enum format format;
+static int num_planes;
+static long page_size;
+enum io_method io_method;
+enum v4l2_memory memory;
+
+static void set_fmt(enum format format)
+{
+	struct v4l2_format fmt;
+	int ret;
+
+	memzero(fmt);
+	switch (format) {
+	case FMT_422:
+		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
+		fb_buf_w = 2;
+		break;
+	case FMT_565:
+		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565X;
+		fb_buf_w = 2;
+		break;
+	case FMT_422P:
+		if (2 == num_planes)
+			fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_NV16M;
+		else if (3 == num_planes)
+			fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422PM;
+		else
+			error_exit(1, "Invalid format/planes combination\n");
+		fb_buf_w = 1;
+		break;
+	default:
+		error_exit(1, "Invalid params\n");
+		break;
+	}
+
+	debug("Selected fourcc: %d\n", fmt.fmt.pix.pixelformat);
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
+	width = fmt.fmt.pix.width;
+	height = fmt.fmt.pix.height;
+	fb_buf_w *= width;
+	framesize = PAGE_ALIGN(fmt.fmt.pix.sizeimage);
+	debug("Framesize: %d\n", framesize);
+
+	switch (io_method) {
+	case IO_METHOD_MMAP:
+		if (num_planes == 1)
+			memory	= V4L2_MEMORY_MMAP;
+		else
+			memory	= V4L2_MEMORY_MULTI_MMAP;
+		break;
+	case IO_METHOD_USERPTR:
+		if (num_planes == 1)
+			memory	= V4L2_MEMORY_USERPTR;
+		else
+			memory	= V4L2_MEMORY_MULTI_USERPTR;
+		break;
+	default:
+		error_exit(1, "Invalid io method\n");
+	}
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
+static void init_fb(void)
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
+	fb_pix_dist = fbinfo.bits_per_pixel >> 3;
+	fb_line_w = fbinfo.xres_virtual * fb_pix_dist;
+	debug("fb_buf_w: %ld, fb_line_w: %ld\n", fb_buf_w, fb_line_w);
+	fb_size = fb_line_w * fbinfo.yres_virtual;
+
+	fb_addr = fb_alloc_ptr = mmap(0, fb_size, PROT_WRITE | PROT_READ,
+				      MAP_SHARED, fb_fd, 0);
+	perror_exit(fb_addr == MAP_FAILED, "mmap");
+}
+
+static void parse_args(int argc, char *argv[])
+{
+	if (argc != 5) {
+		fprintf(stderr, "Usage: "
+			"%s video_node io_method format num_planes \n"
+			"io methods: mmap, userptr \n"
+			"formats: 0: 422, 1: 565, 2: 422P\n",
+			argv[0]);
+		error_exit(1, "Invalid number of arguments\n");
+	}
+
+	vid_node = atoi(argv[1]);
+	io_method = atoi(argv[2]);
+	format = atoi(argv[3]);
+	num_planes = atoi(argv[4]);
+
+	debug("vid_node: %d, format: %d, num_planes: %d\n",
+		vid_node, format, num_planes);
+}
+
+static void alloc_buffer(struct buffer *buf)
+{
+	buf->addr[0] = fb_alloc_ptr;
+
+	switch(num_planes) {
+	case 1:
+		buf->size[0] = framesize;
+		break;
+	case 2:
+		if (FMT_422 != format)
+			error_exit(1, "Unsupported format for this number "
+					"of planes\n");
+		buf->size[0] = PAGE_ALIGN(width * height);
+		buf->addr[1] = buf->addr[0] + buf->size[0];
+		buf->size[1] = PAGE_ALIGN(width * height);
+		break;
+	case 3:
+		if (FMT_422 != format)
+			error_exit(1, "Unsupported format for this number "
+					"of planes\n");
+		buf->size[0] = PAGE_ALIGN(width * height);
+		buf->addr[1] = buf->addr[0] + buf->size[0];
+		buf->size[1] = PAGE_ALIGN(width * height / 2);
+		buf->addr[2] = buf->addr[1] + buf->size[1];
+		buf->size[2] = buf->size[1];
+		break;
+	default:
+		error_exit(1, "Unsupported number of planes\n");
+		break;
+	}
+
+	buf->fmt = format;
+	buf->width = width;
+	buf->height = height;
+	buf->num_planes = num_planes;
+	buf->type = type;
+
+	fb_alloc_ptr = buf->addr[num_planes - 1] + buf->size[num_planes - 1];
+	if (fb_alloc_ptr > fb_addr + fb_size)
+		error_exit(1, "Out of fb memory\n");
+}
+
+static void request_buffers(unsigned int *num_bufs, enum v4l2_buf_type type)
+{
+	struct v4l2_requestbuffers reqbuf;
+	int ret;
+
+	memzero(reqbuf);
+
+	reqbuf.memory = memory;
+
+	reqbuf.count	= *num_bufs;
+	reqbuf.type	= type;
+	ret = ioctl(vid_fd, VIDIOC_REQBUFS, &reqbuf);
+	perror_exit(ret != 0, "ioctl");
+	*num_bufs	= reqbuf.count;
+}
+
+static void display(struct buffer *buf,
+		    unsigned int start_x, unsigned int start_y)
+{
+	char *p_buf, *p_fb;
+	int curr_y;
+	unsigned int i, pl_h, pl_w;
+
+	p_fb = fb_addr + start_y * fb_line_w + start_x;// * fb_pix_dist;
+	p_buf = buf->addr[0];
+
+	debug("fb_buf_w: %ld, fb_line_w: %ld\n", fb_buf_w, fb_line_w);
+
+	if (1 == buf->num_planes) {
+		for (curr_y = 0; curr_y < buf->height; ++curr_y) {
+			memcpy(p_fb, p_buf, fb_buf_w);
+			p_fb += fb_line_w;
+			p_buf += fb_buf_w;
+		}
+	} else {
+		/* 0th plane */
+		for (curr_y = 0; curr_y < buf->height; ++curr_y) {
+			memcpy(p_fb, p_buf, buf->width);
+			p_fb += fb_line_w;
+			p_buf += buf->width;
+		}
+
+		if (buf->num_planes == 2) {
+			pl_w = buf->width;
+			pl_h = buf->height;
+		} else if (buf->num_planes == 3) {
+			pl_w = buf->width / 2;
+			pl_h = buf->height;
+		} else {
+			debug("Cannot display more than 3 planes\n");
+			return;
+		}
+
+		for (i = 1; i < buf->num_planes; ++i) {
+			p_buf = buf->addr[i];
+			for (curr_y = 0; curr_y < pl_h; ++curr_y) {
+				memcpy(p_fb, p_buf, pl_w);
+				p_fb += fb_line_w;
+				p_buf += pl_w;
+			}
+		}
+	}
+}
+
+static void setup_userptr(struct buffer *buffers, int num_buffers)
+{
+	int i;
+
+	for (i = 0; i < num_buffers; ++i) {
+		alloc_buffer(&buffers[i]);
+
+		buffers[i].index = i;
+		buffers[i].type = type;
+		buffers[i].num_planes = num_planes;
+		buffers[i].width = width;
+		buffers[i].height = height;
+	}
+}
+
+static void setup_mmap(struct buffer *buffers, int num_buffers)
+{
+	struct v4l2_buffer buf;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	int ret;
+	int i, j;
+
+	for (i = 0; i < num_buffers; ++i) {
+		memzero(buf);
+
+		if (V4L2_MEMORY_MULTI_MMAP == memory) {
+			buf.memory = memory;
+			buf.m.planes = planes;
+			buf.length = num_planes;
+		}
+		buffers[i].index = buf.index = i;
+		buffers[i].type = buf.type = type;
+		buffers[i].num_planes = num_planes;
+		buffers[i].width = width;
+		buffers[i].height = height;
+
+		ret = ioctl(vid_fd, VIDIOC_QUERYBUF, &buf);
+		perror_exit(ret != 0, "ioctl");
+
+		if (V4L2_MEMORY_MULTI_MMAP == memory) {
+			if (buf.length != num_planes)
+				error_exit(1, "Driver requires %d planes, "
+					       "expected %d\n",
+						buf.length, num_planes);
+
+			for (j = 0; j < buf.length; ++j) {
+				buffers[i].size[j] = buf.m.planes[j].length;
+				buffers[i].addr[j] = mmap(NULL, buffers[i].size[j],
+							  PROT_READ | PROT_WRITE,
+							  MAP_SHARED, vid_fd,
+							  buf.m.planes[j].m.offset);
+				perror_exit(MAP_FAILED == buffers[i].addr[j], "mmap");
+			}
+		} else if (V4L2_MEMORY_MMAP == memory) {
+			buffers[i].size[0] = buf.length;
+			buffers[i].addr[0] = mmap(NULL, buffers[i].size[0],
+						  PROT_READ | PROT_WRITE,
+						  MAP_SHARED, vid_fd,
+						  buf.m.offset);
+			perror_exit(MAP_FAILED == buffers[i].addr[0], "mmap");
+		}
+
+	}
+}
+
+static int get_frame(void)
+{
+	struct v4l2_buffer v4l2_buf;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+
+	memzero(v4l2_buf);
+
+	switch (io_method) {
+	case IO_METHOD_MMAP:
+		v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		v4l2_buf.memory = memory;
+		if (V4L2_MEMORY_MULTI_MMAP == memory) {
+			v4l2_buf.m.planes = planes;
+			v4l2_buf.length = num_planes;
+		}
+
+		if (-1 == ioctl (vid_fd, VIDIOC_DQBUF, &v4l2_buf)) {
+			switch (errno) {
+			case EAGAIN:
+				return 0;
+			case EIO:
+				/* Could ignore EIO, see spec. */
+				/* fall through */
+			default:
+				perror_exit(1, "ioctl");
+			}
+		}
+		return v4l2_buf.index;
+
+	case IO_METHOD_USERPTR:
+		v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		v4l2_buf.memory = memory;
+		if (V4L2_MEMORY_MULTI_USERPTR == memory) {
+			v4l2_buf.m.planes = planes;
+			v4l2_buf.length = num_planes;
+		}
+
+		if (-1 == ioctl (vid_fd, VIDIOC_DQBUF, &v4l2_buf)) {
+			switch (errno) {
+			case EAGAIN:
+				return 0;
+			case EIO:
+				/* Could ignore EIO, see spec. */
+				/* fall through */
+			default:
+				perror_exit(1, "ioctl");
+			}
+		}
+		return v4l2_buf.index;
+	default:
+		return -1;
+	}
+}
+
+void put_frame(struct buffer *buf)
+{
+	struct v4l2_buffer v4l2_buf;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	int ret, i;
+
+	memzero(v4l2_buf);
+
+	switch (io_method) {
+	case IO_METHOD_MMAP:
+		v4l2_buf.type = buf->type;
+		v4l2_buf.memory = memory;
+		v4l2_buf.index = buf->index;
+
+		if (V4L2_MEMORY_MULTI_MMAP == memory) {
+			v4l2_buf.m.planes = planes;
+			v4l2_buf.length = num_planes;
+		}
+
+		ret = ioctl(vid_fd, VIDIOC_QBUF, &v4l2_buf);
+		perror_exit(ret != 0, "ioctl");
+		break;
+
+	case IO_METHOD_USERPTR:
+		v4l2_buf.type = buf->type;
+		v4l2_buf.memory = memory;
+		v4l2_buf.index = buf->index;
+
+		if (V4L2_MEMORY_USERPTR == memory) {
+			v4l2_buf.m.userptr = (unsigned long)buf->addr[0];
+			v4l2_buf.length = buf->size[0];
+		} else if (V4L2_MEMORY_MULTI_USERPTR == memory) {
+			v4l2_buf.m.planes = planes;
+			v4l2_buf.length = num_planes;
+
+			for (i = 0; i < num_planes; ++i) {
+				v4l2_buf.m.planes[i].m.userptr =
+					(unsigned long)buf->addr[i];
+				v4l2_buf.m.planes[i].length = buf->size[i];
+			}
+		}
+
+		ret = ioctl(vid_fd, VIDIOC_QBUF, &v4l2_buf);
+		perror_exit(ret != 0, "ioctl");
+		break;
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct buffer dst_buffers[VIDEO_MAX_FRAME];
+	int ret = 0;
+	unsigned int num_dst_buffers = NUM_DST_BUFS;
+	unsigned int count = 10;
+	unsigned int i;
+	int index;
+
+	parse_args(argc, argv);
+
+	page_size = sysconf(_SC_PAGESIZE);
+
+	init_fb();
+
+	init_video_dev();
+	set_fmt(format);
+
+	request_buffers(&num_dst_buffers, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	if (IO_METHOD_MMAP == io_method) {
+		setup_mmap(dst_buffers, num_dst_buffers);
+	} else if (IO_METHOD_USERPTR == io_method) {
+		setup_userptr(dst_buffers, num_dst_buffers);
+	}
+
+	for (i = 0; i < num_dst_buffers; ++i)
+		put_frame(&dst_buffers[i]);
+
+	ret = ioctl(vid_fd, VIDIOC_STREAMON, &type);
+	perror_exit(0 != ret, "ioctl");
+
+	while (count-- > 0) {
+		for (;;) {
+			fd_set fds;
+			struct timeval tv;
+			int r;
+
+			FD_ZERO(&fds);
+			FD_SET(vid_fd, &fds);
+
+			tv.tv_sec = 2;
+			tv.tv_usec = 0;
+
+			r = select(vid_fd + 1, &fds, NULL, NULL, &tv);
+
+			if (-1 == r) {
+				if (EINTR == errno)
+					continue;
+				else
+					perror_exit(1, "select");
+			}
+
+			if (0 == r) {
+				error_exit(1, "timeout!\n");
+			}
+
+			break;
+		}
+
+		index = get_frame();
+		if (index < 0 || index >= num_dst_buffers)
+			error_exit(1, "Invalid index %d\n", index);
+		display(&dst_buffers[index], 0, 0);
+		put_frame(&dst_buffers[index]);
+	}
+	if (ret)
+		return ret;
+
+	return 0;
+}
