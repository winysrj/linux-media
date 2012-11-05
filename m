Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:57045 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751447Ab2KEPrp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 10:47:45 -0500
Message-ID: <5097DF9F.6080603@gmx.net>
Date: Mon, 05 Nov 2012 16:47:43 +0100
From: Andreas Nagel <andreasnagel@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
Content-Type: multipart/mixed;
 boundary="------------000909010001060303010109"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000909010001060303010109
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

in order to familiarize myself with Media Controller and V4L2 I am 
creating a small example program for capturing some frames through the 
OMAP3 ISP.
The hardware used is a TAO-3530 on a Tsunami daughterboard from 
Technexion. My video source is a standard DVD player connected to the 
daughterboards S-VIDEO port. That port itself is wired to a TVP5146 
decoder chip from TI.
A precompiled Android image with a demo app proofs, that the hardware is 
working fine.

My example program is mostly based on the following wiki page and the 
capture example in the V4L2 documentation.
http://processors.wiki.ti.com/index.php/Writing_V4L2_Media_Controller_Applications_on_Dm36x_Video_Capture

My code sets up the ISP pipeline, configures the format on all the 
subdevices pads and the actual video device. Works fine so far.
Then I passed user pointers (aquired with malloc) to the device driver 
for the capture buffers. Before issuing VIDIOC_STREAMON, I enqueue my 
buffers with VIDIOC_QBUF, which fails with errno = EIO. I don't know, 
why this is happening or where to got from here.

When using memory-mapped buffers instead, mapping the addresses to 
userspace works fine as well as VIDIOC_QBUF calls. But then 
VIDIOC_STREAMON fails with EINVAL. According to V4L documentation, 
EINVAL means
a) buffertype (V4L2_BUF_TYPE_VIDEO_CAPTURE in this case) not supported
b) no buffers have been allocated (memory mapping)
c) or enqueued yet

Because I tested V4L2_CAP_VIDEO_CAPTURE capability, I guess option a) 
does not apply. Buffers have been enqueud, so c) doesn't apply either.
What about b) ? As I chose memory-mapped buffers here, the device 
drivers manages the buffers. How can I make sure, that buffers were 
actually allocated?

And am I missing something else?

I attached my example code. If you need more information, I will provide it.

Note: I have to use the Technexion 2.6.37 kernel, which is based on the 
TI kernel. It's the only kernel that comes with the ISP driver and Media 
Controller API onboard and I guess, TI or TN included this stuff 
somehow. Normally, this shouldn't be available until 2.6.39. Sadly, I 
cannot use another kernel, because Technexion doesn't push board support 
anywhere.


Best regards,
Andreas




--------------000909010001060303010109
Content-Type: text/x-csrc;
 name="capture.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="capture.c"

/*
 * capture.c
 *
 *  Created on: 29.10.2012
 *      Author: andreas
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <linux/media.h>
#include <linux/v4l2-subdev.h>
#include <string.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/mman.h>


#include "capture.h"

#define CLEAR(x) memset(&x, 0, sizeof(x))

int main(void) {

	/*
	 * Open media device.
	 */
	int media_fd = open(DEVNODE_ISP, O_RDWR);
	if (media_fd < 0) {
		puts("Can't open media device.");
		return -1;
	}

	/*
	 * Get the required entities.
	 */
	entities_t entities;
	CLEAR(entities);

	if (get_entities(media_fd, &entities) != 0) {
		puts("Required entity IDs could not be determined.");
		return -1;
	}

	/*
	 * Connect tvp --> ccdc
	 */
	struct media_link_desc link;
	CLEAR(link);

	link.flags |= MEDIA_LINK_FLAG_ENABLED;
	link.source.entity = entities.tvp514x;
	link.source.index = PAD_TVP514X;
	link.source.flags = MEDIA_PAD_FLAG_OUTPUT;
	link.sink.entity = entities.ccdc;
	link.sink.index = PAD_CCDC_SINK;
	link.sink.flags = MEDIA_PAD_FLAG_INPUT;

	if (ioctl(media_fd, MEDIA_IOC_SETUP_LINK, &link) == 0) {
		puts("tvp --> ccdc: enabled");
	}
	else {
		printf("Error setting up link [tvp --> ccdc]. Error %d, %s.\n", errno, strerror(errno));
		return -1;
	}

	/*
	 * Connect ccdc --> ccdc_output
	 */
	CLEAR(link);

	link.flags |= MEDIA_LINK_FLAG_ENABLED;
	link.source.entity = entities.ccdc;
	link.source.index = PAD_CCDC_SOURCE;
	link.source.flags = MEDIA_PAD_FLAG_OUTPUT;
	link.sink.entity = entities.ccdc_out;
	link.sink.index = PAD_CCDC_OUTPUT;
	link.sink.flags = MEDIA_PAD_FLAG_INPUT;

	if (ioctl(media_fd, MEDIA_IOC_SETUP_LINK, &link) == 0) {
		puts("ccdc --> ccdc-out: enabled");
	}
	else {
		printf(	"Error setting up link [ccdc --> ccdc-out]. Error %d, %s.\n",
				errno,
				strerror(errno));
		return -1;
	}

	/*
	 * Open capture device
	 */
	int video_fd = open(DEVNODE_CCDC_OUT, O_RDWR | O_NONBLOCK, 0);
	if (video_fd < 0) {
		puts("Can't open capture device.");
		return -1;
	}

	/*
	 * Check some capabilities.
	 */
	struct v4l2_capability cap;
	printf("Checking device capabilites...");
	if (ioctl(video_fd, VIDIOC_QUERYCAP, &cap) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
	}
	else {
		puts("ok.");
		printf(	"Device %s is a video capture device... %s\n",
				DEVNODE_CCDC_OUT,
				cap.capabilities & V4L2_CAP_VIDEO_CAPTURE ? "yes" : "no");

		printf(	"Device %s supports streaming... %s\n",
				DEVNODE_CCDC_OUT,
				cap.capabilities & V4L2_CAP_STREAMING ? "yes" : "no");
	}

	/*
	 * Setting camera as input
	 */
	struct v4l2_input input;
	CLEAR(input);
	input.type = V4L2_INPUT_TYPE_CAMERA;
	input.index = 70;		// required for the tvp514x decoder chip

	printf("Setting camera input... ");
	if (-1 == ioctl(video_fd, VIDIOC_S_INPUT, &input.index)) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
		return -1;
	}
	else {
		puts("ok.");
	}

	/*
	 * Set format on TVP output pad.
	 */
	int tvp_fd = open(DEVNODE_TVP514X, O_RDWR);
	if (tvp_fd < 0) {
		puts("Can't open tvp device.");
		return -1;
	}

	struct v4l2_subdev_format fmt;
	CLEAR(fmt);

	fmt.pad = PAD_TVP514X;
	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
	fmt.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
	fmt.format.width = WIDTH;
	fmt.format.height = HEIGHT;
	fmt.format.field = V4L2_FIELD_INTERLACED;

	printf("Setting format on TVP subdev... ");
	if (ioctl(tvp_fd, VIDIOC_SUBDEV_S_FMT, &fmt) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
		return -1;
	}
	else {
		puts("ok.");
	}

	/*
	 * Set format on CCDC input pad.
	 */
	int ccdc_fd = open(DEVNODE_CCDC, O_RDWR);
	if (ccdc_fd < 0) {
		puts("Can't open CCDC subdev.");
		return -1;
	}

	CLEAR(fmt);
	fmt.pad = PAD_CCDC_SINK;
	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
	fmt.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
	fmt.format.width = WIDTH;
	fmt.format.height = HEIGHT;
	fmt.format.field = V4L2_FIELD_INTERLACED;

	printf("Setting format on CCDC sink pad... ");
	if (ioctl(ccdc_fd, VIDIOC_SUBDEV_S_FMT, &fmt) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
		return -1;
	}
	else {
		puts("ok.");
	}

	/*
	 * Set format on CCDC output pad.
	 */
	CLEAR(fmt);
	fmt.pad = PAD_CCDC_SOURCE;
	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
	fmt.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
	fmt.format.width = WIDTH;
	fmt.format.height = HEIGHT;
	fmt.format.colorspace = V4L2_COLORSPACE_SMPTE170M; // <-- ITU BT.601
	fmt.format.field = V4L2_FIELD_INTERLACED;

	printf("Setting format on CCDC source pad... ");
	if (ioctl(ccdc_fd, VIDIOC_SUBDEV_S_FMT, &fmt) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
		return -1;
	}
	else {
		puts("ok.");
	}

	/*
	 * Set format on video node
	 */
	struct v4l2_format fmtx;
	CLEAR(fmtx);
	fmtx.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	fmtx.fmt.pix.width = WIDTH;
	fmtx.fmt.pix.height = HEIGHT;
	fmtx.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
	fmtx.fmt.pix.field = V4L2_FIELD_INTERLACED;

	printf("Setting format on video node... ");
	if (ioctl(video_fd, VIDIOC_S_FMT, &fmtx) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
		return -1;
	}
	else {
		puts("ok.");
	}

	/*
	 * Get pitch (bytes per line).
	 */
	printf("Getting pitch... ");
	if (ioctl(video_fd, VIDIOC_G_FMT, &fmtx) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
		return -1;
	}
	else {
		printf("%d Bytes.\n", fmtx.fmt.pix.bytesperline);
	}

	/*
	 * Request buffers.
	 */
	enum v4l2_memory io_method = V4L2_MEMORY_MMAP;

	struct v4l2_requestbuffers req;
	CLEAR(req);
	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	req.count = NUM_BUFS;
	req.memory = io_method;

	printf("Request buffers (%s)... ", io_method == V4L2_MEMORY_MMAP ? "memory-mapped" : "userptr");
	if (ioctl(video_fd, VIDIOC_REQBUFS, &req) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
		return -1;
	}
	else {
		printf("ok. Got %d buffers.\n", req.count);
	}

	/*
	 * Query buffers (because of memory mapping).
	 */
	void *capture_buffers[NUM_BUFS];

	int i;
	for (i = 0; i < NUM_BUFS; i++) {
		struct v4l2_buffer buf;
		CLEAR(buf);

		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = io_method;
		buf.index = i;

		printf("Querying buffer %d... ", i);
		if (ioctl(video_fd, VIDIOC_QUERYBUF, &buf) != 0) {
			printf("failed. Error %d (%s).\n", errno, strerror(errno));
			break;
		}
		else {
			puts("ok.");
		}

		capture_buffers[i] = mmap(	NULL,
									buf.length,
									PROT_READ | PROT_WRITE,
									MAP_SHARED,
									video_fd,
									buf.m.offset);

		printf("Mapping of buffer %d... ", i);
		if (MAP_FAILED == capture_buffers[i]) {
			puts("failed.");
			return -1;
		}
		else {
			puts("ok.");
		}
	}

	/*
	 * Queue buffers
	 */
	for (i = 0; i < NUM_BUFS; i++) {

		struct v4l2_buffer buf;
		CLEAR(buf);

		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = io_method;
		buf.index = i;

		printf("Enqueuing buffer %d... ", i);
		if (ioctl(video_fd, VIDIOC_QBUF, &buf) != 0) {
			printf("failed. Error %d (%s).\n", errno, strerror(errno));
			return -1;
		}
		else {
			puts("ok.");
		}
	}

	/*
	 * Start streaming
	 */
	enum v4l2_buf_type type;
	CLEAR(type);

	type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	printf("Start streaming... ");
	if (ioctl(video_fd, VIDIOC_STREAMON, &type) != 0) {
		printf("failed. Error %d (%s).\n", errno, strerror(errno));
	}
	else {
		puts("ok.");
	}

	return 0;
}

//int allocate_cmem_buffers(buf_info_t *bufs) {
//	void *pool;
//
//	CMEM_AllocParams cParams;
//	CMEM_init();
//
//	cParams.type = CMEM_POOL;
//	cParams.flags = CMEM_NONCACHED;
//	cParams.alignment = 32;
//	pool = CMEM_allocPool(0, &cParams);
//	if (pool == NULL ) {
//		puts("Failed to allocate CMEM pool.");
//		return -1;
//	}
//
//	int i;
//	for (i = 0; i < NUM_BUFS; i++) {
////		bufs[i]->user_addr = CMEM_alloc(BUFSIZ, &cParams);
////		if (!bufs[i]->user_addr) {
////			puts("Error allocating cmem buffer.");
////			return -1;
////		}
////		bufs[i]->phy_addr = CMEM_getPhys(bufs[i].user_addr);
////		if (bufs[i]->phy_addr == 0){
////			puts("Error getting physical address.");
////			return -1;
////		}
//		printf("Buffer %d allocated.\n", i);
//
//	}
//
//	return 0;
//}

int get_entities(int media_fd, entities_t *e) {
	/*
	 * This function will determine the entity ids of the needed subdevices.
	 * If all devices are found, it returns 0. In any other case non-zero.
	 */
	int count = 20;

	/*
	 * Set success count to number of integers in struct.
	 * If all entities are found, this count will be 0, indiciating success.
	 */
	int success = sizeof(entities_t) / sizeof(int);

	struct media_entity_desc entity[count];
	int ret;
	int index;
	for (index = 0; index < count; index++) {
		memset(&entity[index], 0, sizeof(struct media_entity_desc));
		entity[index].id = index | MEDIA_ENTITY_ID_FLAG_NEXT;

		ret = ioctl(media_fd, MEDIA_IOC_ENUM_ENTITIES, &entity[index]);
		if (ret < 0) {
			if (errno == EINVAL)
				break;
		}
		else {
			printf("[%2d] %s\t\t", entity[index].id, entity[index].name);

			if (!strcmp(entity[index].name, ENTITY_CCDC_OUT_NAME)) {
				e->ccdc_out = entity[index].id;
				success--;
				puts("(selected)");
			}
			else if (!strcmp(entity[index].name, ENTITY_TVP514X_NAME)) {
				e->tvp514x = entity[index].id;
				success--;
				puts("(selected)");
			}
			else if (!strcmp(entity[index].name, ENTITY_CCDC_NAME)) {
				e->ccdc = entity[index].id;
				success--;
				puts("(selected)");
			}
			else
				puts("");
		}

		/* Break loop, if all devices are found. */
		if (success == 0)
			break;

	}

	return success;
}

--------------000909010001060303010109
Content-Type: text/x-chdr;
 name="capture.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="capture.h"

/*
 * capture.h
 *
 *  Created on: 30.10.2012
 *      Author: andreas
 */

#ifndef CAPTURE_H_
#define CAPTURE_H_

#define ENTITY_CCDC_NAME "OMAP3 ISP CCDC"
#define ENTITY_CCDC_OUT_NAME "OMAP3 ISP CCDC output"
#define ENTITY_TVP514X_NAME "tvp514x 2-005d"

#define DEVNODE_CCDC "/dev/v4l-subdev2"
#define DEVNODE_CCDC_OUT "/dev/video2"
#define DEVNODE_TVP514X "/dev/v4l-subdev8"
#define DEVNODE_ISP "/dev/media0"

#define PAD_TVP514X 0
#define PAD_CCDC_SINK 0
#define PAD_CCDC_SOURCE 1
#define PAD_CCDC_OUTPUT 0

#define WIDTH 720
#define HEIGHT 576

#define NUM_BUFS 4
#define BUFSIZE WIDTH*HEIGHT*2



/*
 * Holds the entity ids of the specified devices.
 * Only integers here!!
 */
typedef struct entities {
	int tvp514x;
	int ccdc;
	int ccdc_out;
} entities_t;

typedef struct buf_info {
	void *user_addr;
	unsigned long phy_addr;
} buf_info_t;



//int allocate_cmem_buffers(buf_info_t *bufs);
int get_entities(int media_fd, entities_t *e);

#endif /* CAPTURE_H_ */

--------------000909010001060303010109--
