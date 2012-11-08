Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55291 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2KHSN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 13:13:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: V4L2 dma-buf support test with UVC + i915 test application
Date: Thu, 08 Nov 2012 19:14:18 +0100
Message-ID: <16907395.g8mkYBicR5@avalon>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2430419.i1bCXaXd6r"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart2430419.i1bCXaXd6r
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Mauro,

Here's the application I've used to test V4L2 dma-buf support with a UVC 
webcam and an Intel GPU supported by the i915 driver.

The kernel code is available in my git tree at 

git://linuxtv.org/pinchartl/media.git devel/dma-buf-v10

(http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/devel/v4l2-
clock)

Don't forget to enable dma-buf and UVC support when compiling the kernel.

The userspace code is based on the v4l2-drm-example application written by 
Tomasz (the original code is available at 
git://git.infradead.org/users/kmpark/public-apps). I need to clean up my 
modifications to push them back to the repository, in the meantime the code is 
attached to this e-mail.

To compile the application, just run make with the KDIR variable set to the 
path to your Linux kernel tree with the dma-buf patches applied. Don't forget 
to make headers_install in the kernel tree as the Makefile will look for 
headers in $KDIR/usr.

You will need a recent version of libdrm with plane support available. 2.4.39 
should do.

The following command line will capture VGA YUYV data from the webcam and 
display it on the screen. You need to run it in a console as root without the 
X server running.

./dmabuf-sharing -M i915 -o 7:3:1600x900 -i /dev/video0 -S 640,480 -f YUYV -F 
YUYV -s 640,480@0,0 -t 640,480@0,0 -b 2

-- 
Regards,

Laurent Pinchart

--nextPart2430419.i1bCXaXd6r
Content-Disposition: attachment; filename="dmabuf-sharing.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="dmabuf-sharing.c"

/*
 * Demo application for DMA buffer sharing between V4L2 and DRM
 * Tomasz Stanislawski <t.stanislaws@samsung.com>
 *
 * Copyright 2012 Samsung Electronics Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <errno.h>
#include <fcntl.h>
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
#include <unistd.h>

#include <drm/drm.h>
#include <drm/drm_mode.h>

#include <linux/videodev2.h>

#include <xf86drm.h>
#include <xf86drmMode.h>

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

static inline int warn(const char *file, int line, const char *fmt, ...)
{
	int errsv = errno;
	va_list va;
	va_start(va, fmt);
	fprintf(stderr, "WARN(%s:%d): ", file, line);
	vfprintf(stderr, fmt, va);
	va_end(va);
	errno = errsv;
	return 1;
}

#define WARN_ON(cond, ...) \
	((cond) ? warn(__FILE__, __LINE__, __VA_ARGS__) : 0)

struct setup {
	char module[32];
	int conId;
	uint32_t crtId;
	int crtIdx;
	uint32_t planeId;
	char modestr[32];
	char video[32];
	unsigned int w, h;
	unsigned int use_wh : 1;
	unsigned int in_fourcc;
	unsigned int out_fourcc;
	unsigned int buffer_count;
	unsigned int use_crop : 1;
	unsigned int use_compose : 1;
	struct v4l2_rect crop;
	struct v4l2_rect compose;
};

struct buffer {
	unsigned int bo_handle;
	unsigned int fb_handle;
	int dbuf_fd;
};

struct stream {
	int v4lfd;
	int current_buffer;
	int buffer_count;
	struct buffer *buffer;
} stream;

static void usage(char *name)
{
	fprintf(stderr, "usage: %s [-Moisth]\n", name);
	fprintf(stderr, "\t-M <drm-module>\tset DRM module\n");
	fprintf(stderr, "\t-o <connector_id>:<crtc_id>:<mode>\tset a mode\n");
	fprintf(stderr, "\t-i <video-node>\tset video node like /dev/video*\n");
	fprintf(stderr, "\t-S <width,height>\tset input resolution\n");
	fprintf(stderr, "\t-f <fourcc>\tset input format using 4cc\n");
	fprintf(stderr, "\t-F <fourcc>\tset output format using 4cc\n");
	fprintf(stderr, "\t-s <width,height>@<left,top>\tset crop area\n");
	fprintf(stderr, "\t-t <width,height>@<left,top>\tset compose area\n");
	fprintf(stderr, "\t-b buffer_count\tset number of buffers\n");
	fprintf(stderr, "\t-h\tshow this help\n");
	fprintf(stderr, "\n\tDefault is to dump all info.\n");
}

static inline int parse_rect(char *s, struct v4l2_rect *r)
{
	return sscanf(s, "%d,%d@%d,%d", &r->width, &r->height,
		&r->top, &r->left) != 4;
}

static int parse_args(int argc, char *argv[], struct setup *s)
{
	if (argc <= 1)
		usage(argv[0]);

	int c, ret;
	memset(s, 0, sizeof(*s));

	while ((c = getopt(argc, argv, "M:o:i:S:f:F:s:t:b:h")) != -1) {
		switch (c) {
		case 'M':
			strncpy(s->module, optarg, 31);
			break;
		case 'o':
			ret = sscanf(optarg, "%u:%u:%31s", &s->conId, &s->crtId,
				s->modestr);
			if (WARN_ON(ret != 3, "incorrect mode description\n"))
				return -1;
			break;
		case 'i':
			strncpy(s->video, optarg, 31);
			break;
		case 'S':
			ret = sscanf(optarg, "%u,%u", &s->w, &s->h);
			if (WARN_ON(ret != 2, "incorrect input size\n"))
				return -1;
			s->use_wh = 1;
			break;
		case 'f':
			if (WARN_ON(strlen(optarg) != 4, "invalid fourcc\n"))
				return -1;
			s->in_fourcc = ((unsigned)optarg[0] << 0) |
				((unsigned)optarg[1] << 8) |
				((unsigned)optarg[2] << 16) |
				((unsigned)optarg[3] << 24);
			break;
		case 'F':
			if (WARN_ON(strlen(optarg) != 4, "invalid fourcc\n"))
				return -1;
			s->out_fourcc = ((unsigned)optarg[0] << 0) |
				((unsigned)optarg[1] << 8) |
				((unsigned)optarg[2] << 16) |
				((unsigned)optarg[3] << 24);
			break;
		case 's':
			ret = parse_rect(optarg, &s->crop);
			if (WARN_ON(ret, "incorrect crop area\n"))
				return -1;
			s->use_crop = 1;
			break;
		case 't':
			ret = parse_rect(optarg, &s->compose);
			if (WARN_ON(ret, "incorrect compose area\n"))
				return -1;
			s->use_compose = 1;
			break;
		case 'b':
			ret = sscanf(optarg, "%u", &s->buffer_count);
			if (WARN_ON(ret != 1, "incorrect buffer count\n"))
				return -1;
			break;
		case '?':
		case 'h':
			usage(argv[0]);
			return -1;
		}
	}

	return 0;
}

static int buffer_create(struct buffer *b, int drmfd, struct setup *s,
	uint64_t size, uint32_t pitch)
{
	struct drm_mode_create_dumb gem;
	struct drm_mode_destroy_dumb gem_destroy;
	int ret;

	memset(&gem, 0, sizeof gem);
	gem.width = s->w;
	gem.height = s->h;
	gem.bpp = 16;
	gem.size = size;
	ret = ioctl(drmfd, DRM_IOCTL_MODE_CREATE_DUMB, &gem);
	if (WARN_ON(ret, "CREATE_DUMB failed: %s\n", ERRSTR))
		return -1;
	printf("bo %u %ux%u bpp %u size %lu (%lu)\n", gem.handle, gem.width, gem.height, gem.bpp, gem.size, size);
	b->bo_handle = gem.handle;

	struct drm_prime_handle prime;
	memset(&prime, 0, sizeof prime);
	prime.handle = b->bo_handle;

	ret = ioctl(drmfd, DRM_IOCTL_PRIME_HANDLE_TO_FD, &prime);
	if (WARN_ON(ret, "PRIME_HANDLE_TO_FD failed: %s\n", ERRSTR))
		goto fail_gem;
	printf("dbuf_fd = %d\n", prime.fd);
	b->dbuf_fd = prime.fd;

	uint32_t offsets[4] = { 0 };
	uint32_t pitches[4] = { pitch };
	uint32_t bo_handles[4] = { b->bo_handle };
	unsigned int fourcc = s->out_fourcc;
	if (!fourcc)
		fourcc = s->in_fourcc;
	ret = drmModeAddFB2(drmfd, s->w, s->h, fourcc, bo_handles,
		pitches, offsets, &b->fb_handle, 0);
	if (WARN_ON(ret, "drmModeAddFB2 failed: %s\n", ERRSTR))
		goto fail_prime;

	return 0;

fail_prime:
	close(b->dbuf_fd);

fail_gem:
	memset(&gem_destroy, 0, sizeof gem_destroy);
	gem_destroy.handle = b->bo_handle,
	ret = ioctl(drmfd, DRM_IOCTL_MODE_DESTROY_DUMB, &gem_destroy);
	WARN_ON(ret, "DESTROY_DUMB failed: %s\n", ERRSTR);

	return -1;
}

static int find_mode(drmModeModeInfo *m, int drmfd, struct setup *s,
	uint32_t *con)
{
	int ret = -1;
	int i;
	drmModeRes *res = drmModeGetResources(drmfd);
	if (WARN_ON(!res, "drmModeGetResources failed: %s\n", ERRSTR))
		return -1;

	if (WARN_ON(res->count_crtcs <= 0, "drm: no crts\n"))
		goto fail_res;

	s->crtIdx = -1;

	for (i = 0; i < res->count_crtcs; ++i) {
		if (s->crtId == res->crtcs[i]) {
			s->crtIdx = i;
			break;
		}
	}

	if (WARN_ON(s->crtIdx == -1, "drm: CRTC %u not found\n", s->crtId))
		goto fail_res;

	if (WARN_ON(res->count_connectors <= 0, "drm: no connectors\n"))
		goto fail_res;

	if (WARN_ON(s->conId >= res->count_connectors, "connector %d "
		"is not supported\n", s->conId))
		goto fail_res;

	drmModeConnector *c;
	c = drmModeGetConnector(drmfd, s->conId);
	if (WARN_ON(!c, "drmModeGetConnector failed: %s\n", ERRSTR))
		goto fail_res;

	if (WARN_ON(!c->count_modes, "connector supports no mode\n"))
		goto fail_conn;

	drmModeModeInfo *found = NULL;
	for (int i = 0; i < c->count_modes; ++i)
		if (strcmp(c->modes[i].name, s->modestr) == 0)
			found = &c->modes[i];

	if (WARN_ON(!found, "mode %s not supported\n", s->modestr)) {
		fprintf(stderr, "Valid modes:");
		for (int i = 0; i < c->count_modes; ++i)
			fprintf(stderr, " %s", c->modes[i].name);
		fprintf(stderr, "\n");
		goto fail_conn;
	}

	memcpy(m, found, sizeof *found);
	if (con)
		*con = c->connector_id;
	ret = 0;

fail_conn:
	drmModeFreeConnector(c);

fail_res:
	drmModeFreeResources(res);

	return ret;
}

static int find_plane(int drmfd, struct setup *s)
{
	drmModePlaneResPtr planes;
	drmModePlanePtr plane;
	unsigned int i;
	unsigned int j;
	int ret = 0;

	planes = drmModeGetPlaneResources(drmfd);
	if (WARN_ON(!planes, "drmModeGetPlaneResources failed: %s\n", ERRSTR))
		return -1;

	for (i = 0; i < planes->count_planes; ++i) {
		plane = drmModeGetPlane(drmfd, planes->planes[i]);
		if (WARN_ON(!planes, "drmModeGetPlane failed: %s\n", ERRSTR))
			break;

		if (!(plane->possible_crtcs & (1 << s->crtIdx))) {
			drmModeFreePlane(plane);
			continue;
		}

		for (j = 0; j < plane->count_formats; ++j) {
			if (plane->formats[j] == s->out_fourcc)
				break;
		}

		if (j == plane->count_formats) {
			drmModeFreePlane(plane);
			continue;
		}

		s->planeId = plane->plane_id;
		drmModeFreePlane(plane);
		break;
	}

	if (i == planes->count_planes)
		ret = -1;

	drmModeFreePlaneResources(planes);
	return ret;
}

int main(int argc, char *argv[])
{
	int ret;
	struct setup s;

	ret = parse_args(argc, argv, &s);
	BYE_ON(ret, "failed to parse arguments\n");
	BYE_ON(s.module[0] == 0, "DRM module is missing\n");
	BYE_ON(s.video[0] == 0, "video node is missing\n");

	int drmfd = drmOpen(s.module, NULL);
	BYE_ON(drmfd < 0, "drmOpen(%s) failed: %s\n", s.module, ERRSTR);

	int v4lfd = open(s.video, O_RDWR);
	BYE_ON(v4lfd < 0, "failed to open %s: %s\n", s.video, ERRSTR);

	struct v4l2_capability caps;
	memset(&caps, 0, sizeof caps);

	ret = ioctl(v4lfd, VIDIOC_QUERYCAP, &caps);
	BYE_ON(ret, "VIDIOC_QUERYCAP failed: %s\n", ERRSTR);

	/* TODO: add single plane support */
	BYE_ON(~caps.capabilities & V4L2_CAP_VIDEO_CAPTURE,
		"video: singleplanar capture is not supported\n");

	struct v4l2_format fmt;
	memset(&fmt, 0, sizeof fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

	ret = ioctl(v4lfd, VIDIOC_G_FMT, &fmt);
	BYE_ON(ret < 0, "VIDIOC_G_FMT failed: %s\n", ERRSTR);
	printf("G_FMT(start): width = %u, height = %u, 4cc = %.4s\n",
		fmt.fmt.pix.width, fmt.fmt.pix.height,
		(char*)&fmt.fmt.pix.pixelformat);

	if (s.use_wh) {
		fmt.fmt.pix.width = s.w;
		fmt.fmt.pix.height = s.h;
	}
	if (s.in_fourcc)
		fmt.fmt.pix.pixelformat = s.in_fourcc;

	ret = ioctl(v4lfd, VIDIOC_S_FMT, &fmt);
	BYE_ON(ret < 0, "VIDIOC_S_FMT failed: %s\n", ERRSTR);

	ret = ioctl(v4lfd, VIDIOC_G_FMT, &fmt);
	BYE_ON(ret < 0, "VIDIOC_G_FMT failed: %s\n", ERRSTR);
	printf("G_FMT(final): width = %u, height = %u, 4cc = %.4s\n",
		fmt.fmt.pix.width, fmt.fmt.pix.height,
		(char*)&fmt.fmt.pix.pixelformat);

	struct v4l2_requestbuffers rqbufs;
	memset(&rqbufs, 0, sizeof(rqbufs));
	rqbufs.count = s.buffer_count;
	rqbufs.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	rqbufs.memory = V4L2_MEMORY_DMABUF;

	ret = ioctl(v4lfd, VIDIOC_REQBUFS, &rqbufs);
	BYE_ON(ret < 0, "VIDIOC_REQBUFS failed: %s\n", ERRSTR);
	BYE_ON(rqbufs.count < s.buffer_count, "video node allocated only "
		"%u of %u buffers\n", rqbufs.count, s.buffer_count);

	s.in_fourcc = fmt.fmt.pix.pixelformat;
	s.w = fmt.fmt.pix.width;
	s.h = fmt.fmt.pix.height;

	/* TODO: add support for multiplanar formats */
	struct buffer buffer[s.buffer_count];
	uint32_t size = fmt.fmt.pix.sizeimage;
	uint32_t pitch = fmt.fmt.pix.bytesperline;
	printf("size = %u pitch = %u\n", size, pitch);
	for (unsigned int i = 0; i < s.buffer_count; ++i) {
		ret = buffer_create(&buffer[i], drmfd, &s, size, pitch);
		BYE_ON(ret, "failed to create buffer%d\n", i);
	}
	printf("buffers ready\n");

	drmModeModeInfo drmmode;
	uint32_t con;
	ret = find_mode(&drmmode, drmfd, &s, &con);
	BYE_ON(ret, "failed to find valid mode\n");

	ret = find_plane(drmfd, &s);
	BYE_ON(ret, "failed to find compatible plane\n");

	for (unsigned int i = 0; i < s.buffer_count; ++i) {
		struct v4l2_buffer buf;
		memset(&buf, 0, sizeof buf);

		buf.index = i;
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = V4L2_MEMORY_DMABUF;
		buf.m.fd = buffer[i].dbuf_fd;
		ret = ioctl(v4lfd, VIDIOC_QBUF, &buf);
		BYE_ON(ret < 0, "VIDIOC_QBUF for buffer %d failed: %s (fd %u)\n",
			buf.index, ERRSTR, buffer[i].dbuf_fd);
	}

	int type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	ret = ioctl(v4lfd, VIDIOC_STREAMON, &type);
	BYE_ON(ret < 0, "STREAMON failed: %s\n", ERRSTR);

	struct pollfd fds[] = {
		{ .fd = v4lfd, .events = POLLIN },
		{ .fd = drmfd, .events = POLLIN },
	};

	/* buffer currently used by drm */
	stream.v4lfd = v4lfd;
	stream.current_buffer = -1;
	stream.buffer = buffer;

	if (!s.use_compose) {
		s.compose.left = 0;
		s.compose.top = 0;
		s.compose.width = fmt.fmt.pix.width;
		s.compose.height = fmt.fmt.pix.height;
	}

	while ((ret = poll(fds, 2, 5000)) > 0) {
		struct v4l2_buffer buf;

		/* dequeue buffer */
		memset(&buf, 0, sizeof buf);
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = V4L2_MEMORY_DMABUF;
		ret = ioctl(v4lfd, VIDIOC_DQBUF, &buf);
		BYE_ON(ret, "VIDIOC_DQBUF failed: %s\n", ERRSTR);

		ret = drmModeSetPlane(drmfd, s.planeId, s.crtId,
				      buffer[buf.index].fb_handle, 0,
				      s.compose.left, s.compose.top,
				      s.compose.width,
				      s.compose.height,
				      0, 0, s.w << 16, s.h << 16);
		BYE_ON(ret, "drmModeSetPlane failed: %s\n", ERRSTR);

		if (stream.current_buffer != -1) {
			memset(&buf, 0, sizeof buf);
			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			buf.memory = V4L2_MEMORY_DMABUF;
			buf.index = stream.current_buffer;
			buf.m.fd = stream.buffer[stream.current_buffer].dbuf_fd;

			ret = ioctl(stream.v4lfd, VIDIOC_QBUF, &buf);
			BYE_ON(ret, "VIDIOC_QBUF(index = %d) failed: %s\n",
			       stream.current_buffer, ERRSTR);
		}

		stream.current_buffer = buf.index;
	}

	return 0;
}

--nextPart2430419.i1bCXaXd6r
Content-Disposition: attachment; filename="Makefile"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-makefile; charset="UTF-8"; name="Makefile"

CROSS_COMPILE ?=
KDIR ?=

CC	:= $(CROSS_COMPILE)gcc
CFLAGS	?= -O2 -W -Wall -std=gnu99 -I$(KDIR)/usr/include -I/usr/include/libdrm
LDFLAGS	?=
LIBS	:= -lrt -ldrm

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

all: dmabuf-sharing

dmabuf-sharing: dmabuf-sharing.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

clean:
	-rm -f *.o
	-rm -f dmabuf-sharing


--nextPart2430419.i1bCXaXd6r--

