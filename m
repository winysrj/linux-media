Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64561 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2AZJs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 04:48:26 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYE001OSGKOPL@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 09:48:24 +0000 (GMT)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LYE007OXGKN3U@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 09:48:24 +0000 (GMT)
Date: Thu, 26 Jan 2012 10:48:23 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 05/10] v4l: add buffer exporting via dmabuf
In-reply-to: <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com
Message-id: <4F212167.9090607@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,

I would like to present a simple test application used for testing 
DMABUF support in V4L2. It is used to show how support for DMABUF may 
look like in V4L2.

The test application creates a simple pipeline between two V4L2 devices. 
One of them is a capture device. The second one is an output device.

The buffers are exchanged using DMABUF mechanism. The application takes 
additional argument to setup capture's size and rotation and compose 
window on output device (controlled using VIDIOC_S_CROP).

The application was tested on s5p-tv as output and s5p-fimc as capture.
It is written in GNU99 standard

Regards,
Tomasz Stanislawski

----


#include <errno.h>
#include <fcntl.h>
#include <linux/videodev2.h>
#include <math.h>
#include <poll.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

#define ERRSTR strerror(errno)

#define BYE_ON(cond, ...) \
do { \
	if (cond) { \
		int errsv = errno; \
		fprintf(stderr, "ERROR(%s:%d) : ", \
			__FILE__, __LINE__); \
		errno = errsv; \
		fprintf(stderr,  __VA_ARGS__); \
		abort(); \
	} \
} while(0)

#define BUFFER_CNT	5

int main(int argc, char *argv[])
{
	int ret;

	BYE_ON(argc < 3, "bad args:\n\t%s input-node output-node "
		"[w,h,rot] [left,top,w,h]\n", argv[0]);

	int f_in, f_out;

	f_in = open(argv[1], O_RDWR);
	BYE_ON(f_in < 0, "open failed: %s\n", ERRSTR);

	f_out = open(argv[2], O_RDWR);
	BYE_ON(f_out < 0, "open failed: %s\n", ERRSTR);

	/* configure desired image size */
	struct v4l2_format fmt;
	memset(&fmt, 0, sizeof fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	fmt.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_RGB565;
	int rotation = 0;
	if (argc >= 4) {
		ret = sscanf(argv[3], "%u,%u,%d",
			&fmt.fmt.pix_mp.width,
			&fmt.fmt.pix_mp.height,
			&rotation);
		BYE_ON(ret < 2, "incorrect sensor size and rotation\n");
	}

	if (rotation) {
		struct v4l2_control ctrl = {
			.id = V4L2_CID_ROTATE,
			.value = rotation,
		};
		ret = ioctl(f_in, VIDIOC_S_CTRL, &ctrl);
		BYE_ON(ret < 0, "VIDIOC_S_CTRL failed: %s\n", ERRSTR);
	}

	/* set format struct */
	ret = ioctl(f_in, VIDIOC_S_FMT, &fmt);
	BYE_ON(ret < 0, "VIDIOC_S_FMT failed: %s\n", ERRSTR);

	/* get format struct */
	ret = ioctl(f_in, VIDIOC_G_FMT, &fmt);
	BYE_ON(ret < 0, "VIDIOC_G_FMT failed: %s\n", ERRSTR);
	printf("G_FMT(f_in): width = %u, height = %u, 4cc = %.4s\n",
		fmt.fmt.pix.width, fmt.fmt.pix.height,
		(char*)&fmt.fmt.pix.pixelformat);

	if (argc >= 5) {
		struct v4l2_crop crop;
		crop.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
		ret = sscanf(argv[4], "%d,%d,%d,%d",
			&crop.c.left, &crop.c.top,
			&crop.c.width, &crop.c.height);
		BYE_ON(ret != 4, "incorrect cropping format\n");
		ret = ioctl(f_out, VIDIOC_S_CROP, &crop);
		BYE_ON(ret < 0, "VIDIOC_S_CROP failed: %s\n", ERRSTR);
	}

	/* pass input format to output */
	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(f_out, VIDIOC_S_FMT, &fmt);
	BYE_ON(ret < 0, "VIDIOC_S_FMT failed: %s\n", ERRSTR);

	/* get format struct */
	ret = ioctl(f_out, VIDIOC_G_FMT, &fmt);
	BYE_ON(ret < 0, "VIDIOC_G_FMT failed: %s\n", ERRSTR);
	printf("G_FMT(f_out): width = %u, height = %u, 4cc = %.4s\n",
		fmt.fmt.pix.width, fmt.fmt.pix.height,
		(char*)&fmt.fmt.pix.pixelformat);

	/* allocate buffers */
	struct v4l2_requestbuffers rqbufs;
	rqbufs.count = BUFFER_CNT;
	rqbufs.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	rqbufs.memory = V4L2_MEMORY_MMAP;

	ret = ioctl(f_in, VIDIOC_REQBUFS, &rqbufs);
	BYE_ON(ret < 0, "VIDIOC_REQBUFS failed: %s\n", ERRSTR);
	BYE_ON(rqbufs.count < BUFFER_CNT, "failed to get %d buffers\n", 
BUFFER_CNT);

	rqbufs.count = BUFFER_CNT;
	rqbufs.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	rqbufs.memory = V4L2_MEMORY_DMABUF;

	ret = ioctl(f_out, VIDIOC_REQBUFS, &rqbufs);
	BYE_ON(ret < 0, "VIDIOC_REQBUFS failed: %s\n", ERRSTR);
	BYE_ON(rqbufs.count < BUFFER_CNT, "failed to get %d buffers\n", 
BUFFER_CNT);

	int fd[BUFFER_CNT];
	/* buffers initalization */
	for (int i = 0; i < BUFFER_CNT; ++i) {
		struct v4l2_plane plane;
		struct v4l2_buffer buf;

		memset(&buf, 0, sizeof buf);
		memset(&plane, 0, sizeof plane);
		buf.index = i;
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
		buf.memory = V4L2_MEMORY_MMAP;
		buf.m.planes = &plane;
		buf.length = 1;

		/* get buffer properties from a driver */
		ret = ioctl(f_in, VIDIOC_QUERYBUF, &buf);
		BYE_ON(ret < 0, "VIDIOC_QUERYBUF for buffer %d failed: %s\n",
			buf.index, ERRSTR);
		BYE_ON(buf.memory != V4L2_MEMORY_MMAP, "bad memory type\n");
		BYE_ON(buf.length != 1, "non singular plane format\n");

		fd[i] = ioctl(f_in, VIDIOC_EXPBUF, &plane.m.mem_offset);
		BYE_ON(fd[i] < 0, "VIDIOC_EXPBUF failed; %s\n", ERRSTR);

		if (i < BUFFER_CNT / 2) {
			/* enqueue low-index buffers to input */
			ret = ioctl(f_in, VIDIOC_QBUF, &buf);
		} else {
			/* enqueue high-index buffers to output */
			buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
			buf.memory = V4L2_MEMORY_DMABUF;
			plane.m.fd = fd[i];
			ret = ioctl(f_out, VIDIOC_QBUF, &buf);
		}
		BYE_ON(ret < 0, "VIDIOC_QBUF for buffer %d failed: %s\n",
			buf.index, ERRSTR);
	}

	/* start streaming */
	int type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	ret = ioctl(f_in, VIDIOC_STREAMON, &type);
	BYE_ON(ret < 0, "STREAMON failed: %s\n", ERRSTR);

	type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
	ret = ioctl(f_out, VIDIOC_STREAMON, &type);
	BYE_ON(ret < 0, "STREAMON failed: %s\n", ERRSTR);

	/* setup polling */
	struct pollfd fds[2] = {
		{ .fd = f_in, .events = POLLIN },
		{ .fd = f_out, .events = POLLOUT },
	};

	while ((ret = poll(fds, 2, 5000)) > 0) {
		struct v4l2_buffer buf;
		struct v4l2_plane plane;

		memset(&buf, 0, sizeof buf);
		memset(&plane, 0, sizeof plane);
		buf.m.planes = &plane;
		buf.length = 1;

		if (fds[0].revents & POLLIN) {
			/* dequeue buffer */
			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
			buf.memory = V4L2_MEMORY_MMAP;
			ret = ioctl(f_in, VIDIOC_DQBUF, &buf);
			BYE_ON(ret, "VIDIOC_DQBUF failed: %s\n", ERRSTR);

			/* enqueue buffer */
			buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
			buf.memory = V4L2_MEMORY_DMABUF;
			plane.m.fd = fd[buf.index];
			ret = ioctl(f_out, VIDIOC_QBUF, &buf);
			BYE_ON(ret, "VIDIOC_QBUF failed: %s\n", ERRSTR);
		}
		if (fds[1].revents & POLLOUT) {
			/* dequeue buffer */
			buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
			buf.memory = V4L2_MEMORY_DMABUF;
			ret = ioctl(f_out, VIDIOC_DQBUF, &buf);
			BYE_ON(ret, "VIDIOC_DQBUF failed: %s\n", ERRSTR);

			/* enqueue buffer */
			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
			buf.memory = V4L2_MEMORY_MMAP;
			ret = ioctl(f_in, VIDIOC_QBUF, &buf);
			BYE_ON(ret, "VIDIOC_QBUF failed: %s\n", ERRSTR);
		}
	}

	BYE_ON(ret == 0, "polling timeout\n");
	BYE_ON(1, "polling stopped: %s\n", ERRSTR);

	return 0;
}
