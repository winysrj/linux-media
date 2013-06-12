Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:14633 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3FLIEc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 04:04:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lubomir Rintel <lkundrak@v3.sk>
Subject: Re: [PATCH] [media] usbtv: Add driver for Fushicai USBTV007 video frame grabber
Date: Wed, 12 Jun 2013 10:04:25 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <1370885934.9757.11.camel@hobbes.kokotovo> <1370886211-10112-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1370886211-10112-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121004.25680.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 10 June 2013 19:43:31 Lubomir Rintel wrote:
> Reverse-engineered driver for cheapo video digitizer, made from observations of
> Windows XP driver. The protocol is not yet completely understood, so far we
> don't provide any controls, only support a single format out of three and don't
> support the audio device.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> ---
> Changes for v2:
>     - Fix a typo in comment
>     - Make prototype register settings static const
>     - Solve parity calculation weirdness
>     - Attempt to fix interlacing
>     - Add timestamp to frames
>     - [v4l2-compliance] Set pix format priv to 0
>     - Drop usbtv_*_fmt_vid_cap code duplication
>     - [v4l2-compliance] Add vidioc_create_bufs
>     - [v4l2-compliance] Use file handle priorities
>     - Drop "Driver" from initial dev_info
> 
>  drivers/media/usb/Kconfig        |    1 +
>  drivers/media/usb/Makefile       |    1 +
>  drivers/media/usb/usbtv/Kconfig  |   10 +
>  drivers/media/usb/usbtv/Makefile |    1 +
>  drivers/media/usb/usbtv/usbtv.c  |  715 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 728 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/usb/usbtv/Kconfig
>  create mode 100644 drivers/media/usb/usbtv/Makefile
>  create mode 100644 drivers/media/usb/usbtv/usbtv.c
> 
> diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
> index 0a7d520..8e10267 100644
> --- a/drivers/media/usb/Kconfig
> +++ b/drivers/media/usb/Kconfig
> @@ -17,6 +17,7 @@ source "drivers/media/usb/zr364xx/Kconfig"
>  source "drivers/media/usb/stkwebcam/Kconfig"
>  source "drivers/media/usb/s2255/Kconfig"
>  source "drivers/media/usb/sn9c102/Kconfig"
> +source "drivers/media/usb/usbtv/Kconfig"
>  endif
>  
>  if MEDIA_ANALOG_TV_SUPPORT
> diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
> index 7f51d7e..0935f47 100644
> --- a/drivers/media/usb/Makefile
> +++ b/drivers/media/usb/Makefile
> @@ -20,3 +20,4 @@ obj-$(CONFIG_VIDEO_STK1160) += stk1160/
>  obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
>  obj-$(CONFIG_VIDEO_TM6000) += tm6000/
>  obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
> +obj-$(CONFIG_VIDEO_USBTV) += usbtv/
> diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
> new file mode 100644
> index 0000000..8864436
> --- /dev/null
> +++ b/drivers/media/usb/usbtv/Kconfig
> @@ -0,0 +1,10 @@
> +config VIDEO_USBTV
> +        tristate "USBTV007 video capture support"
> +        depends on VIDEO_DEV
> +        select VIDEOBUF2_VMALLOC
> +
> +        ---help---
> +          This is a video4linux2 driver for USBTV007 based video capture devices.
> +
> +          To compile this driver as a module, choose M here: the
> +          module will be called usbtv
> diff --git a/drivers/media/usb/usbtv/Makefile b/drivers/media/usb/usbtv/Makefile
> new file mode 100644
> index 0000000..28b872f
> --- /dev/null
> +++ b/drivers/media/usb/usbtv/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_USBTV) += usbtv.o
> diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv.c
> new file mode 100644
> index 0000000..c2a02c2
> --- /dev/null
> +++ b/drivers/media/usb/usbtv/usbtv.c
> @@ -0,0 +1,715 @@
> +/*
> + * Fushicai USBTV007 Video Grabber Driver
> + *
> + * Product web site:
> + * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
> + *
> + * Following LWN articles were very useful in construction of this driver:
> + * Video4Linux2 API series: http://lwn.net/Articles/203924/
> + * videobuf2 API explanation: http://lwn.net/Articles/447435/
> + * Thanks go to Jonathan Corbet for providing this quality documentation.
> + * He is awesome.
> + *
> + * Copyright (c) 2013 Lubomir Rintel
> + * All rights reserved.
> + * No physical hardware was harmed running Windows during the
> + * reverse-engineering activity
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions, and the following disclaimer,
> + *    without modification.
> + * 2. The name of the author may not be used to endorse or promote products
> + *    derived from this software without specific prior written permission.
> + *
> + * Alternatively, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL").
> + */
> +
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +#include <linux/version.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-vmalloc.h>
> +
> +/* Hardware. */
> +#define USBTV_VIDEO_ENDP	0x81
> +#define USBTV_BASE		0xc000
> +#define USBTV_REQUEST_REG	12
> +
> +/* Number of concurrent isochronous urbs submitted.
> + * Higher numbers was seen to overly saturate the USB bus. */
> +#define USBTV_ISOC_TRANSFERS	16
> +#define USBTV_ISOC_PACKETS	8
> +
> +#define USBTV_WIDTH		720
> +#define USBTV_HEIGHT		480
> +
> +#define USBTV_CHUNK_SIZE	256
> +#define USBTV_CHUNK		240
> +#define USBTV_CHUNKS		(USBTV_WIDTH * USBTV_HEIGHT \
> +					/ 2 / USBTV_CHUNK)
> +
> +/* Chunk header. */
> +#define USBTV_MAGIC_OK(chunk)	((be32_to_cpu(chunk[0]) & 0xff000000) \
> +							== 0x88000000)
> +#define USBTV_FRAME_ID(chunk)	((be32_to_cpu(chunk[0]) & 0x00ff0000) >> 16)
> +#define USBTV_ODD(chunk)	((be32_to_cpu(chunk[0]) & 0x0000f000) >> 15)
> +#define USBTV_CHUNK_NO(chunk)	(be32_to_cpu(chunk[0]) & 0x00000fff)
> +
> +/* A single videobuf2 frame buffer. */
> +struct usbtv_buf {
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +};
> +
> +/* Per-device structure. */
> +struct usbtv {
> +	struct device *dev;
> +	struct usb_device *udev;
> +	struct v4l2_device v4l2_dev;
> +	struct video_device vdev;
> +	struct vb2_queue vb2q;
> +	struct mutex v4l2_lock;
> +	struct mutex vb2q_lock;
> +
> +	/* List of videobuf2 buffers protected by a lock. */
> +	spinlock_t buflock;
> +	struct list_head bufs;
> +
> +	/* Number of currently processed frame, useful find
> +	 * out when a new one begins. */
> +	u32 frame_id;
> +
> +	int iso_size;
> +	unsigned int sequence;
> +	struct urb *isoc_urbs[USBTV_ISOC_TRANSFERS];
> +};
> +
> +static int usbtv_setup_capture(struct usbtv *usbtv)
> +{
> +	int ret;
> +	int pipe = usb_rcvctrlpipe(usbtv->udev, 0);
> +	int i;
> +	static const u16 protoregs[][2] = {
> +		/* These seem to enable the device. */
> +		{ USBTV_BASE + 0x0008, 0x0001 },
> +		{ USBTV_BASE + 0x01d0, 0x00ff },
> +		{ USBTV_BASE + 0x01d9, 0x0002 },
> +
> +		/* These seem to influence color parameters, such as
> +		 * brightness, etc. */
> +		{ USBTV_BASE + 0x0239, 0x0040 },
> +		{ USBTV_BASE + 0x0240, 0x0000 },
> +		{ USBTV_BASE + 0x0241, 0x0000 },
> +		{ USBTV_BASE + 0x0242, 0x0002 },
> +		{ USBTV_BASE + 0x0243, 0x0080 },
> +		{ USBTV_BASE + 0x0244, 0x0012 },
> +		{ USBTV_BASE + 0x0245, 0x0090 },
> +		{ USBTV_BASE + 0x0246, 0x0000 },
> +
> +		{ USBTV_BASE + 0x0278, 0x002d },
> +		{ USBTV_BASE + 0x0279, 0x000a },
> +		{ USBTV_BASE + 0x027a, 0x0032 },
> +		{ 0xf890, 0x000c },
> +		{ 0xf894, 0x0086 },
> +
> +		{ USBTV_BASE + 0x00ac, 0x00c0 },
> +		{ USBTV_BASE + 0x00ad, 0x0000 },
> +		{ USBTV_BASE + 0x00a2, 0x0012 },
> +		{ USBTV_BASE + 0x00a3, 0x00e0 },
> +		{ USBTV_BASE + 0x00a4, 0x0028 },
> +		{ USBTV_BASE + 0x00a5, 0x0082 },
> +		{ USBTV_BASE + 0x00a7, 0x0080 },
> +		{ USBTV_BASE + 0x0000, 0x0014 },
> +		{ USBTV_BASE + 0x0006, 0x0003 },
> +		{ USBTV_BASE + 0x0090, 0x0099 },
> +		{ USBTV_BASE + 0x0091, 0x0090 },
> +		{ USBTV_BASE + 0x0094, 0x0068 },
> +		{ USBTV_BASE + 0x0095, 0x0070 },
> +		{ USBTV_BASE + 0x009c, 0x0030 },
> +		{ USBTV_BASE + 0x009d, 0x00c0 },
> +		{ USBTV_BASE + 0x009e, 0x00e0 },
> +		{ USBTV_BASE + 0x0019, 0x0006 },
> +		{ USBTV_BASE + 0x008c, 0x00ba },
> +		{ USBTV_BASE + 0x0101, 0x00ff },
> +		{ USBTV_BASE + 0x010c, 0x00b3 },
> +		{ USBTV_BASE + 0x01b2, 0x0080 },
> +		{ USBTV_BASE + 0x01b4, 0x00a0 },
> +		{ USBTV_BASE + 0x014c, 0x00ff },
> +		{ USBTV_BASE + 0x014d, 0x00ca },
> +		{ USBTV_BASE + 0x0113, 0x0053 },
> +		{ USBTV_BASE + 0x0119, 0x008a },
> +		{ USBTV_BASE + 0x013c, 0x0003 },
> +		{ USBTV_BASE + 0x0150, 0x009c },
> +		{ USBTV_BASE + 0x0151, 0x0071 },
> +		{ USBTV_BASE + 0x0152, 0x00c6 },
> +		{ USBTV_BASE + 0x0153, 0x0084 },
> +		{ USBTV_BASE + 0x0154, 0x00bc },
> +		{ USBTV_BASE + 0x0155, 0x00a0 },
> +		{ USBTV_BASE + 0x0156, 0x00a0 },
> +		{ USBTV_BASE + 0x0157, 0x009c },
> +		{ USBTV_BASE + 0x0158, 0x001f },
> +		{ USBTV_BASE + 0x0159, 0x0006 },
> +		{ USBTV_BASE + 0x015d, 0x0000 },
> +
> +		{ USBTV_BASE + 0x0284, 0x0088 },
> +		{ USBTV_BASE + 0x0003, 0x0004 },
> +		{ USBTV_BASE + 0x001a, 0x0079 },
> +		{ USBTV_BASE + 0x0100, 0x00d3 },
> +		{ USBTV_BASE + 0x010e, 0x0068 },
> +		{ USBTV_BASE + 0x010f, 0x009c },
> +		{ USBTV_BASE + 0x0112, 0x00f0 },
> +		{ USBTV_BASE + 0x0115, 0x0015 },
> +		{ USBTV_BASE + 0x0117, 0x0000 },
> +		{ USBTV_BASE + 0x0118, 0x00fc },
> +		{ USBTV_BASE + 0x012d, 0x0004 },
> +		{ USBTV_BASE + 0x012f, 0x0008 },
> +		{ USBTV_BASE + 0x0220, 0x002e },
> +		{ USBTV_BASE + 0x0225, 0x0008 },
> +		{ USBTV_BASE + 0x024e, 0x0002 },
> +		{ USBTV_BASE + 0x024f, 0x0001 },
> +		{ USBTV_BASE + 0x0254, 0x005f },
> +		{ USBTV_BASE + 0x025a, 0x0012 },
> +		{ USBTV_BASE + 0x025b, 0x0001 },
> +		{ USBTV_BASE + 0x0263, 0x001c },
> +		{ USBTV_BASE + 0x0266, 0x0011 },
> +		{ USBTV_BASE + 0x0267, 0x0005 },
> +		{ USBTV_BASE + 0x024e, 0x0002 },
> +		{ USBTV_BASE + 0x024f, 0x0002 },
> +	};
> +
> +	for (i = 0; i < sizeof(protoregs)/sizeof(protoregs[0]); i++) {

Use the ARRAY_SIZE(protoregs) macro here.

> +		u16 index = protoregs[i][0];
> +		u16 value = protoregs[i][1];
> +
> +		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
> +			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			value, index, NULL, 0, 0);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Called for each 256-byte image chunk.
> + * First word identifies the chunk, followed by 240 words of image
> + * data and padding. */
> +static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
> +{
> +	int frame_id, odd, chunk_no;
> +	u32 *frame;
> +	struct usbtv_buf *buf;
> +	unsigned long flags;
> +
> +	/* Ignore corrupted lines. */
> +	if (!USBTV_MAGIC_OK(chunk))
> +		return;
> +	frame_id = USBTV_FRAME_ID(chunk);
> +	odd = USBTV_ODD(chunk);
> +	chunk_no = USBTV_CHUNK_NO(chunk);
> +
> +	/* Deinterlace. TODO: Use interlaced frame format. */
> +	chunk_no = (chunk_no - chunk_no % 3) * 2 + chunk_no % 3;
> +	chunk_no += !odd * 3;
> +
> +	if (chunk_no >= USBTV_CHUNKS)
> +		return;
> +
> +	/* Beginning of a frame. */
> +	if (chunk_no == 0)
> +		usbtv->frame_id = frame_id;
> +
> +	spin_lock_irqsave(&usbtv->buflock, flags);
> +	if (list_empty(&usbtv->bufs)) {
> +		/* No free buffers. Userspace likely too slow. */
> +		spin_unlock_irqrestore(&usbtv->buflock, flags);
> +		return;
> +	}
> +
> +	/* First available buffer. */
> +	buf = list_first_entry(&usbtv->bufs, struct usbtv_buf, list);
> +	frame = vb2_plane_vaddr(&buf->vb, 0);
> +
> +	/* Copy the chunk. */
> +	memcpy(&frame[chunk_no * USBTV_CHUNK], &chunk[1],
> +			USBTV_CHUNK * sizeof(chunk[1]));
> +
> +	/* Last chunk in a frame, signalling an end */
> +	if (usbtv->frame_id && chunk_no == USBTV_CHUNKS-1) {
> +		int size = vb2_plane_size(&buf->vb, 0);
> +
> +		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
> +		buf->vb.v4l2_buf.sequence = usbtv->sequence++;
> +		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
> +		vb2_set_plane_payload(&buf->vb, 0, size);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
> +		list_del(&buf->list);
> +	}
> +
> +	spin_unlock_irqrestore(&usbtv->buflock, flags);
> +}
> +
> +/* Got image data. Each packet contains a number of 256-word chunks we
> + * compose the image from. */
> +static void usbtv_iso_cb(struct urb *ip)
> +{
> +	int ret;
> +	int i;
> +	struct usbtv *usbtv = (struct usbtv *)ip->context;
> +
> +	switch (ip->status) {
> +	/* All fine. */
> +	case 0:
> +		break;
> +	/* Device disconnected or capture stopped? */
> +	case -ENODEV:
> +	case -ENOENT:
> +	case -ECONNRESET:
> +	case -ESHUTDOWN:
> +		return;
> +	/* Unknown error. Retry. */
> +	default:
> +		dev_warn(usbtv->dev, "Bad response for ISO request.\n");
> +		goto resubmit;
> +	}
> +
> +	for (i = 0; i < ip->number_of_packets; i++) {
> +		int size = ip->iso_frame_desc[i].actual_length;
> +		unsigned char *data = ip->transfer_buffer +
> +				ip->iso_frame_desc[i].offset;
> +		int offset;
> +
> +		for (offset = 0; USBTV_CHUNK_SIZE * offset < size; offset++)
> +			usbtv_image_chunk(usbtv,
> +				(u32 *)&data[USBTV_CHUNK_SIZE * offset]);
> +	}
> +
> +resubmit:
> +	ret = usb_submit_urb(ip, GFP_ATOMIC);
> +	if (ret < 0)
> +		dev_warn(usbtv->dev, "Could not resubmit ISO URB\n");
> +}
> +
> +static struct urb *usbtv_setup_iso_transfer(struct usbtv *usbtv)
> +{
> +	struct urb *ip;
> +	int size = usbtv->iso_size;
> +	int i;
> +
> +	ip = usb_alloc_urb(USBTV_ISOC_PACKETS, GFP_KERNEL);
> +	if (ip == NULL)
> +		return NULL;
> +
> +	ip->dev = usbtv->udev;
> +	ip->context = usbtv;
> +	ip->pipe = usb_rcvisocpipe(usbtv->udev, USBTV_VIDEO_ENDP);
> +	ip->interval = 1;
> +	ip->transfer_flags = URB_ISO_ASAP;
> +	ip->transfer_buffer = kzalloc(size * USBTV_ISOC_PACKETS,
> +						GFP_KERNEL);
> +	ip->complete = usbtv_iso_cb;
> +	ip->number_of_packets = USBTV_ISOC_PACKETS;
> +	ip->transfer_buffer_length = size * USBTV_ISOC_PACKETS;
> +	for (i = 0; i < USBTV_ISOC_PACKETS; i++) {
> +		ip->iso_frame_desc[i].offset = size * i;
> +		ip->iso_frame_desc[i].length = size;
> +	}
> +
> +	return ip;
> +}
> +
> +static void usbtv_stop(struct usbtv *usbtv)
> +{
> +	int i;
> +	unsigned long flags;
> +
> +	/* Cancel running transfers. */
> +	for (i = 0; i < USBTV_ISOC_TRANSFERS; i++) {
> +		struct urb *ip = usbtv->isoc_urbs[i];
> +		if (ip == NULL)
> +			continue;
> +		usb_kill_urb(ip);
> +		kfree(ip->transfer_buffer);
> +		usb_free_urb(ip);
> +		usbtv->isoc_urbs[i] = NULL;
> +	}
> +
> +	/* Return buffers to userspace. */
> +	spin_lock_irqsave(&usbtv->buflock, flags);
> +	while (!list_empty(&usbtv->bufs)) {
> +		struct usbtv_buf *buf = list_first_entry(&usbtv->bufs,
> +						struct usbtv_buf, list);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +		list_del(&buf->list);
> +	}
> +	spin_unlock_irqrestore(&usbtv->buflock, flags);
> +}
> +
> +static int usbtv_start(struct usbtv *usbtv)
> +{
> +	int i;
> +	int ret;
> +
> +	ret = usb_set_interface(usbtv->udev, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = usbtv_setup_capture(usbtv);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = usb_set_interface(usbtv->udev, 0, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < USBTV_ISOC_TRANSFERS; i++) {
> +		struct urb *ip;
> +
> +		ip = usbtv_setup_iso_transfer(usbtv);
> +		if (ip == NULL) {
> +			ret = -ENOMEM;
> +			goto start_fail;
> +		}
> +		usbtv->isoc_urbs[i] = ip;
> +
> +		ret = usb_submit_urb(ip, GFP_KERNEL);
> +		if (ret < 0)
> +			goto start_fail;
> +	}
> +
> +	return 0;
> +
> +start_fail:
> +	usbtv_stop(usbtv);
> +	return ret;
> +}
> +
> +struct usb_device_id usbtv_id_table[] = {
> +	{ USB_DEVICE(0x1b71, 0x3002) },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(usb, usbtv_id_table);
> +
> +static int usbtv_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
> +{
> +	struct usbtv *dev = video_drvdata(file);
> +
> +	strncpy(cap->driver, "usbtv", sizeof(cap->driver));
> +	strncpy(cap->card, "usbtv", sizeof(cap->card));
> +	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE;
> +	cap->device_caps |= V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int usbtv_enum_input(struct file *file, void *priv,
> +					struct v4l2_input *i)
> +{
> +	if (i->index > 0)
> +		return -EINVAL;
> +
> +	strncpy(i->name, "Composite", sizeof(i->name));
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	i->std = V4L2_STD_525_60;
> +	return 0;
> +}
> +
> +static int usbtv_enum_fmt_vid_cap(struct file *file, void  *priv,
> +					struct v4l2_fmtdesc *f)
> +{
> +	if (f->index > 0)
> +		return -EINVAL;
> +
> +	strncpy(f->description, "16 bpp YUY2, 4:2:2, packed",
> +					sizeof(f->description));
> +	f->pixelformat = V4L2_PIX_FMT_YUYV;
> +	return 0;
> +}
> +
> +static int usbtv_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_format *f)
> +{
> +	f->fmt.pix.width = USBTV_WIDTH;
> +	f->fmt.pix.height = USBTV_HEIGHT;
> +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> +	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> +	f->fmt.pix.bytesperline = USBTV_WIDTH * 2;
> +	f->fmt.pix.sizeimage = (f->fmt.pix.bytesperline * f->fmt.pix.height);
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	f->fmt.pix.priv = 0;
> +	return 0;
> +}
> +
> +static int usbtv_g_std(struct file *file, void *priv, v4l2_std_id *norm)
> +{
> +	*norm = V4L2_STD_525_60;
> +	return 0;
> +}
> +
> +static int usbtv_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int usbtv_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	if (i > 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int usbtv_s_std(struct file *file, void *priv, v4l2_std_id norm)
> +{
> +	if (norm & V4L2_STD_525_60)
> +		return 0;
> +	return -EINVAL;
> +}
> +
> +static int usbtv_queryctrl(struct file *file, void *priv,
> +				struct v4l2_queryctrl *ctrl)
> +{
> +	return -EINVAL;
> +}

First test without this op with the latest gstreamer. That should work fine.
If for some reason it is absolutely necessary to have support for this, then
create an empty v4l2_ctrl_handler struct instead (see the v4l2-controls.txt
documentation in Documention/video4linux, and in many drivers) and use that
instead.

> +
> +struct v4l2_ioctl_ops usbtv_ioctl_ops = {
> +	.vidioc_querycap = usbtv_querycap,
> +	.vidioc_enum_input = usbtv_enum_input,
> +	.vidioc_enum_fmt_vid_cap = usbtv_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap = usbtv_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap = usbtv_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = usbtv_fmt_vid_cap,
> +	.vidioc_g_std = usbtv_g_std,
> +	.vidioc_s_std = usbtv_s_std,
> +	.vidioc_g_input = usbtv_g_input,
> +	.vidioc_s_input = usbtv_s_input,
> +	.vidioc_queryctrl = usbtv_queryctrl,
> +
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +};
> +
> +struct v4l2_file_operations usbtv_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = video_ioctl2,
> +	.mmap = vb2_fop_mmap,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.read = vb2_fop_read,
> +	.poll = vb2_fop_poll,
> +};
> +
> +static int usbtv_queue_setup(struct vb2_queue *vq,
> +	const struct v4l2_format *v4l_fmt, unsigned int *nbuffers,
> +	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	if (*nbuffers == 0)
> +		*nbuffers = 8;

Why 8? That seems a rather high number. Usually this code looks like:

	if (*nbuffers < minbuffers)
		*nbuffers = minbuffers;

Also make sure you can actually capture with the given minimum number of
buffers. The current code suggests that it should work with just 1 buffer,
which seems an unlikely low number. Usually the minimum is 2 or 3 buffers.

> +	*nplanes = 1;
> +	sizes[0] = USBTV_CHUNK * USBTV_CHUNKS * sizeof(u32);
> +
> +	return 0;
> +}
> +
> +static void usbtv_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct usbtv *usbtv = vb2_get_drv_priv(vb->vb2_queue);
> +	struct usbtv_buf *buf = container_of(vb, struct usbtv_buf, vb);
> +	unsigned long flags;
> +
> +	if (usbtv->udev == NULL) {
> +		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&usbtv->buflock, flags);
> +	list_add_tail(&buf->list, &usbtv->bufs);
> +	spin_unlock_irqrestore(&usbtv->buflock, flags);
> +}
> +
> +static int usbtv_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct usbtv *usbtv = vb2_get_drv_priv(vq);
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&usbtv->v4l2_lock))
> +		return -ERESTARTSYS;

Why would you need to take the v4l2_lock here? vb2q_lock is already held
which is sufficient.

> +	if (usbtv->udev == NULL) {
> +		mutex_unlock(&usbtv->v4l2_lock);
> +		return -ENODEV;
> +	}
> +
> +	ret = usbtv_start(usbtv);
> +	mutex_unlock(&usbtv->v4l2_lock);
> +	return ret;
> +}
> +
> +static int usbtv_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct usbtv *usbtv = vb2_get_drv_priv(vq);
> +
> +	if (mutex_lock_interruptible(&usbtv->v4l2_lock))
> +		return -ERESTARTSYS;

Ditto.

> +	if (usbtv->udev == NULL) {
> +		mutex_unlock(&usbtv->v4l2_lock);
> +		return -ENODEV;
> +	}
> +
> +	usbtv_stop(usbtv);
> +	mutex_unlock(&usbtv->v4l2_lock);
> +	return 0;
> +}
> +
> +struct vb2_ops usbtv_vb2_ops = {
> +	.queue_setup = usbtv_queue_setup,
> +	.buf_queue = usbtv_buf_queue,
> +	.start_streaming = usbtv_start_streaming,
> +	.stop_streaming = usbtv_stop_streaming,
> +};
> +
> +static void usbtv_release(struct v4l2_device *v4l2_dev)
> +{
> +	struct usbtv *usbtv = container_of(v4l2_dev, struct usbtv, v4l2_dev);
> +
> +	v4l2_device_unregister(&usbtv->v4l2_dev);
> +	vb2_queue_release(&usbtv->vb2q);
> +	kfree(usbtv);
> +}
> +
> +static int usbtv_probe(struct usb_interface *intf,
> +	const struct usb_device_id *id)
> +{
> +	int ret;
> +	int size;
> +	struct device *dev = &intf->dev;
> +	struct usbtv *usbtv;
> +
> +	/* Checks that the device is what we think it is. */
> +	if (intf->num_altsetting != 2)
> +		return -ENODEV;
> +	if (intf->altsetting[1].desc.bNumEndpoints != 4)
> +		return -ENODEV;
> +
> +	/* Packet size is split into 11 bits of base size and count of
> +	 * extra multiplies of it.*/
> +	size = usb_endpoint_maxp(&intf->altsetting[1].endpoint[0].desc);
> +	size = (size & 0x07ff) * (((size & 0x1800) >> 11) + 1);
> +
> +	/* Device structure */
> +	usbtv = kzalloc(sizeof(struct usbtv), GFP_KERNEL);
> +	if (usbtv == NULL)
> +		return -ENOMEM;
> +	usbtv->dev = dev;
> +	usbtv->udev = usb_get_dev(interface_to_usbdev(intf));
> +	usbtv->iso_size = size;
> +	spin_lock_init(&usbtv->buflock);
> +	mutex_init(&usbtv->v4l2_lock);
> +	mutex_init(&usbtv->vb2q_lock);
> +	INIT_LIST_HEAD(&usbtv->bufs);
> +
> +	/* videobuf2 structure */
> +	usbtv->vb2q.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	usbtv->vb2q.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
> +	usbtv->vb2q.drv_priv = usbtv;
> +	usbtv->vb2q.buf_struct_size = sizeof(struct usbtv_buf);
> +	usbtv->vb2q.ops = &usbtv_vb2_ops;
> +	usbtv->vb2q.mem_ops = &vb2_vmalloc_memops;
> +	usbtv->vb2q.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	usbtv->vb2q.lock = &usbtv->vb2q_lock;
> +	ret = vb2_queue_init(&usbtv->vb2q);
> +	if (ret < 0) {
> +		dev_warn(dev, "Could not initialize videobuf2 queue\n");
> +		goto usbtv_fail;
> +	}
> +
> +	/* v4l2 structure */
> +	usbtv->v4l2_dev.release = usbtv_release;
> +	ret = v4l2_device_register(dev, &usbtv->v4l2_dev);
> +	if (ret < 0) {
> +		dev_warn(dev, "Could not register v4l2 device\n");
> +		goto v4l2_fail;
> +	}
> +
> +	usb_set_intfdata(intf, usbtv);
> +
> +	/* Video structure */
> +	strncpy(usbtv->vdev.name, "usbtv", sizeof(usbtv->vdev.name));
> +	usbtv->vdev.v4l2_dev = &usbtv->v4l2_dev;
> +	usbtv->vdev.release = video_device_release_empty;
> +	usbtv->vdev.fops = &usbtv_fops;
> +	usbtv->vdev.ioctl_ops = &usbtv_ioctl_ops;
> +	usbtv->vdev.tvnorms = V4L2_STD_525_60;
> +	usbtv->vdev.queue = &usbtv->vb2q;
> +	usbtv->vdev.lock = &usbtv->v4l2_lock;
> +	set_bit(V4L2_FL_USE_FH_PRIO, &usbtv->vdev.flags);
> +	ret = video_register_device(&usbtv->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_warn(dev, "Could not register video device\n");
> +		goto vdev_fail;
> +	}
> +	video_set_drvdata(&usbtv->vdev, usbtv);

This should go before video_register_device. Applications can start accessing
the video node right after video_register_device, and if drvdata is not yet
set then nasty things can happen.

> +
> +	dev_info(dev, "Fushicai USBTV007 Video Grabber\n");
> +	return 0;
> +
> +vdev_fail:
> +	v4l2_device_unregister(&usbtv->v4l2_dev);
> +v4l2_fail:
> +	vb2_queue_release(&usbtv->vb2q);
> +usbtv_fail:
> +	kfree(usbtv);
> +
> +	return ret;
> +}
> +
> +static void usbtv_disconnect(struct usb_interface *intf)
> +{
> +	struct usbtv *usbtv = usb_get_intfdata(intf);
> +
> +	mutex_lock(&usbtv->vb2q_lock);
> +	mutex_lock(&usbtv->v4l2_lock);
> +
> +	usbtv_stop(usbtv);
> +	usb_set_intfdata(intf, NULL);
> +	video_unregister_device(&usbtv->vdev);
> +	v4l2_device_disconnect(&usbtv->v4l2_dev);
> +	usb_put_dev(usbtv->udev);
> +	usbtv->udev = NULL;
> +
> +	mutex_unlock(&usbtv->v4l2_lock);
> +	mutex_unlock(&usbtv->vb2q_lock);
> +
> +	v4l2_device_put(&usbtv->v4l2_dev);
> +}
> +
> +MODULE_AUTHOR("Lubomir Rintel");
> +MODULE_DESCRIPTION("Fushicai USBTV007 Video Grabber Driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> +
> +struct usb_driver usbtv_usb_driver = {
> +	.name = "usbtv",
> +	.id_table = usbtv_id_table,
> +	.probe = usbtv_probe,
> +	.disconnect = usbtv_disconnect,
> +};
> +
> +module_usb_driver(usbtv_usb_driver);
> 

Regards,

	Hans
