Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:43278 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdJEKkt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 06:40:49 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Linux Media <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: i.MX6 CODA warning: vb2:   counters for queue xxx, buffer y: UNBALANCED!
Date: Thu, 05 Oct 2017 12:31:08 +0200
Message-ID: <m3zi95yjgz.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using i.MX6 CODA H.264 encoder and found a minor bug somewhere.
Not sure how it should be fixed, though.
The problem manifests itself when I configure (open, qbuf etc) the
encoder device and then close it without any start/stop streaming calls.
I'm using 2 buffers in this example:

vb2:   counters for queue b699c808, buffer 0: UNBALANCED!
vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 1 buf_finish: 1
vb2:     buf_queue: 0 buf_done: 0
vb2:     alloc: 1 put: 1 prepare: 1 finish: 0 mmap: 1
                         ^^^^^^^^^^^^^^^^^^^^
vb2:     get_userptr: 0 put_userptr: 0
vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf: 0 unmap_dmabuf: 0
vb2:     get_dmabuf: 0 num_users: 0 vaddr: 0 cookie: 0

vb2:   counters for queue b699c808, buffer 1: UNBALANCED!
vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 1 buf_finish: 1
vb2:     buf_queue: 0 buf_done: 0
vb2:     alloc: 1 put: 1 prepare: 1 finish: 0 mmap: 1
                         ^^^^^^^^^^^^^^^^^^^^
vb2:     get_userptr: 0 put_userptr: 0
vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf: 0 unmap_dmabuf: 0
vb2:     get_dmabuf: 0 num_users: 0 vaddr: 0 cookie: 0

These are H.264 (encoder "capture") buffers. Note the alloc
prepare/finish disparity.

I have investigated a bit and it seems it's some missing *buf_done()
call, probably belonging to coda_release(), but I'm not sure. Or maybe
should my program "finish" the buffers before doing close()?

Linux 4.13. I'm using CONFIG_VIDEO_ADV_DEBUG=y.
Compile with:
arm-pc-linux-gnueabihf-gcc -std=gnu99 -O2 -W -Wall -Wno-sign-compare -Wno-missing-field-initializers -D_GNU_SOURCE coda_test.c -o coda_test
Any other details are, of course, available.

Ideas?
--
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland


// -*- mode: c; c-basic-offset: 4; tab-width: 4; -*-
// coda_test.c
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <linux/videodev2.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

static inline int doioctl(int fd, unsigned long req, void *ptr)
{
	return TEMP_FAILURE_RETRY(ioctl(fd, req, ptr));
}

void *xmalloc(size_t size)
{
        void *ptr = malloc(size);
        if (!ptr) {
                printf("Unable to allocate %zu bytes of data\n", size);
				exit(1);
		}

        return ptr;
}

static void print_pixel_format(const char *name, struct v4l2_pix_format *pix)
{
	printf("%s %u x %u ", name, pix->width, pix->height);

	const char *ptr = (void*)&pix->pixelformat;
	for (int i = 0; i < 4; i++) {
		if ((ptr[i] >= 'A' && ptr[i] <= 'Z') ||
			(ptr[i] >= 'a' && ptr[i] <= 'z') ||
			(ptr[i] >= '0' && ptr[i] <= '9'))
			printf("%c", ptr[i]);
		else
			printf("?");
	}

	switch (pix->field) {
	case V4L2_FIELD_NONE:
		break;
	case V4L2_FIELD_TOP:
		printf(" top field");
		break;
	case V4L2_FIELD_BOTTOM:
		printf(" bottom field");
		break;
	case V4L2_FIELD_INTERLACED:
		printf(" interlaced");
		break;
	case V4L2_FIELD_SEQ_TB:
		printf(" top field first");
		break;
	case V4L2_FIELD_SEQ_BT:
		printf(" bottom field first");
		break;
	default:
		printf(" field %u", pix->field);
		break;
	}
	printf(" frame size %u\n", pix->sizeimage);
}

int main(void)
{
	struct {
		void *start;
		size_t length;
	} *h264_buffers = NULL;

	int fd;

	if ((fd = open("/dev/coda-encoder", O_RDWR, 0)) < 0) {
		printf("Unable to open video encoder device: %m\n");
		return -1;
	}

	struct v4l2_format encoder_fmt = {
		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
		.fmt.pix.pixelformat = V4L2_PIX_FMT_NV12,
		.fmt.pix.width = 704,
		.fmt.pix.height = 576,
		.fmt.pix.field = V4L2_FIELD_NONE,
	};
	if (doioctl(fd, VIDIOC_S_FMT, &encoder_fmt) < 0) {
		printf("Unable to set video encoder sink format\n");
		goto close_streams;
	}

	print_pixel_format("Encoder output:", &encoder_fmt.fmt.pix);

	encoder_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	if (doioctl(fd, VIDIOC_G_FMT, &encoder_fmt) < 0) {
		printf("Unable to get video encoder capture format\n");
		goto close_streams;
	}

	print_pixel_format("Encoder input:", &encoder_fmt.fmt.pix);

	// Query buffer counts
	struct v4l2_requestbuffers req = {
		.count = 2,
		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
		.memory = V4L2_MEMORY_MMAP,
	};

	if (doioctl(fd, VIDIOC_REQBUFS, &req) < 0) {
		printf("Unable to request h.264 buffer settings: %m\n");
		goto close_streams;
	}

	printf("Using %u h.264 buffers\n", req.count);
	h264_buffers = xmalloc(req.count * sizeof(h264_buffers[0]));

	sleep(1);
	for (int cnt = 0; cnt < req.count; cnt++) {
		struct v4l2_buffer buf = {
			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
			.memory = V4L2_MEMORY_MMAP,
			.index = cnt,
		};
		if (doioctl(fd, VIDIOC_QUERYBUF, &buf) < 0) {
			printf("Unable to query video encoder output buffer #%u: %m\n", cnt);
			goto close_streams;
		}

		void *ptr = mmap(NULL, buf.length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);
		if (ptr == MAP_FAILED) {
			printf("Unable to map video encoder output buffer: %m\n");
			goto close_streams;
		}
		h264_buffers[cnt].length = buf.length;
		h264_buffers[cnt].start = ptr;
		printf("mmap %p %u\n", h264_buffers[cnt].start, h264_buffers[cnt].length);
	}

	for (int cnt = 0; cnt < req.count; cnt++) {
		struct v4l2_buffer buf = {
			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
			.memory = V4L2_MEMORY_MMAP,
			.index = cnt,
		};
		if (doioctl(fd, VIDIOC_QBUF, &buf) < 0) {
			printf("Unable to queue video encoder output buffer: %m\n");
			goto close_streams;
		}
	}

close_streams:
	printf("Freeing %u h.264 buffers\n", req.count);
	sleep(1);
	for (int cnt = 0; cnt < req.count; cnt++)
		if (h264_buffers && h264_buffers[cnt].start) {
			printf("munmap %p %u\n", h264_buffers[cnt].start, h264_buffers[cnt].length);
			munmap(h264_buffers[cnt].start, h264_buffers[cnt].length);
		}
	free(h264_buffers);
	printf("Closing encoder device\n");
	sleep(1);
	close(fd);

	printf("Exiting\n");
	sleep(1);
	return -1;
}
