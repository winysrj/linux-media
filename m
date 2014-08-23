Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59861 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbaHWPZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 11:25:08 -0400
Message-ID: <53F8B24E.2050601@iki.fi>
Date: Sat, 23 Aug 2014 18:25:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] hackrf: HackRF SDR driver
References: <1408780000-18431-1-git-send-email-crope@iki.fi> <1408780000-18431-2-git-send-email-crope@iki.fi> <53F8A5FB.3030104@xs4all.nl>
In-Reply-To: <53F8A5FB.3030104@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 08/23/2014 05:32 PM, Hans Verkuil wrote:
> Hi Antti,
>
> Thanks for this drivers, looks interesting.

Yes it is, especially as it supports transmitting (TX) too.

>
> I do have some review comments, see below...
>
> On 08/23/2014 07:46 AM, Antti Palosaari wrote:
>> V4L2 driver for HackRF SDR. Very basic version, with reduced
>> feature set. Driver implements receiver only, hardware supports
>> also transmitter.
>>
>> USB ID 1d50:6089. Model HackRF One
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/usb/Kconfig         |    3 +-
>>   drivers/media/usb/Makefile        |    3 +-
>>   drivers/media/usb/hackrf/Kconfig  |   10 +
>>   drivers/media/usb/hackrf/Makefile |    1 +
>>   drivers/media/usb/hackrf/hackrf.c | 1130 +++++++++++++++++++++++++++++++++++++
>>   5 files changed, 1145 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/media/usb/hackrf/Kconfig
>>   create mode 100644 drivers/media/usb/hackrf/Makefile
>>   create mode 100644 drivers/media/usb/hackrf/hackrf.c
>>
>> diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
>> index d6e8edc..056181f 100644
>> --- a/drivers/media/usb/Kconfig
>> +++ b/drivers/media/usb/Kconfig
>> @@ -56,8 +56,9 @@ endif
>>
>>   if MEDIA_SDR_SUPPORT
>>   	comment "Software defined radio USB devices"
>> -source "drivers/media/usb/msi2500/Kconfig"
>>   source "drivers/media/usb/airspy/Kconfig"
>> +source "drivers/media/usb/hackrf/Kconfig"
>> +source "drivers/media/usb/msi2500/Kconfig"
>>   endif
>>
>>   endif #MEDIA_USB_SUPPORT
>> diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
>> index b5b645b..6f2eb7c 100644
>> --- a/drivers/media/usb/Makefile
>> +++ b/drivers/media/usb/Makefile
>> @@ -9,8 +9,9 @@ obj-y += zr364xx/ stkwebcam/ s2255/
>>   obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
>>   obj-$(CONFIG_USB_GSPCA)         += gspca/
>>   obj-$(CONFIG_USB_PWC)           += pwc/
>> -obj-$(CONFIG_USB_MSI2500)       += msi2500/
>>   obj-$(CONFIG_USB_AIRSPY)        += airspy/
>> +obj-$(CONFIG_USB_HACKRF)        += hackrf/
>> +obj-$(CONFIG_USB_MSI2500)       += msi2500/
>>   obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
>>   obj-$(CONFIG_VIDEO_AU0828) += au0828/
>>   obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
>> diff --git a/drivers/media/usb/hackrf/Kconfig b/drivers/media/usb/hackrf/Kconfig
>> new file mode 100644
>> index 0000000..937e6f5
>> --- /dev/null
>> +++ b/drivers/media/usb/hackrf/Kconfig
>> @@ -0,0 +1,10 @@
>> +config USB_HACKRF
>> +	tristate "HackRF"
>> +	depends on VIDEO_V4L2
>> +	select VIDEOBUF2_VMALLOC
>> +	---help---
>> +	  This is a video4linux2 driver for HackRF SDR device.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called hackrf
>> +
>> diff --git a/drivers/media/usb/hackrf/Makefile b/drivers/media/usb/hackrf/Makefile
>> new file mode 100644
>> index 0000000..73064a2
>> --- /dev/null
>> +++ b/drivers/media/usb/hackrf/Makefile
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_USB_HACKRF)              += hackrf.o
>> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
>> new file mode 100644
>> index 0000000..a868cd9
>> --- /dev/null
>> +++ b/drivers/media/usb/hackrf/hackrf.c
>> @@ -0,0 +1,1130 @@
>> +/*
>> + * HackRF driver
>> + *
>> + * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>> + *
>> + *    This program is free software; you can redistribute it and/or modify
>> + *    it under the terms of the GNU General Public License as published by
>> + *    the Free Software Foundation; either version 2 of the License, or
>> + *    (at your option) any later version.
>> + *
>> + *    This program is distributed in the hope that it will be useful,
>> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *    GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/usb.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/videobuf2-vmalloc.h>
>> +
>> +/* HackRF USB API commands (from HackRF Library) */
>> +enum {
>> +	CMD_SET_TRANSCEIVER_MODE           = 0x01,
>> +	CMD_SAMPLE_RATE_SET                = 0x06,
>> +	CMD_BASEBAND_FILTER_BANDWIDTH_SET  = 0x07,
>> +	CMD_BOARD_ID_READ                  = 0x0e,
>> +	CMD_VERSION_STRING_READ            = 0x0f,
>> +	CMD_SET_FREQ                       = 0x10,
>> +	CMD_SET_LNA_GAIN                   = 0x13,
>> +	CMD_SET_VGA_GAIN                   = 0x14,
>> +};
>> +
>> +/*
>> + *       bEndpointAddress     0x81  EP 1 IN
>> + *         Transfer Type            Bulk
>> + *       wMaxPacketSize     0x0200  1x 512 bytes
>> + */
>> +#define MAX_BULK_BUFS            (6)
>> +#define BULK_BUFFER_SIZE         (128 * 512)
>> +
>> +static const struct v4l2_frequency_band bands_adc[] = {
>> +	{
>> +		.tuner = 0,
>> +		.type = V4L2_TUNER_ADC,
>> +		.index = 0,
>> +		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
>> +		.rangelow   =   200000,
>> +		.rangehigh  = 24000000,
>> +	},
>> +};
>> +
>> +static const struct v4l2_frequency_band bands_rf[] = {
>> +	{
>> +		.tuner = 1,
>> +		.type = V4L2_TUNER_RF,
>> +		.index = 0,
>> +		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
>> +		.rangelow   =          1,
>> +		.rangehigh  = 4294967294, /* max u32, hw goes over 7GHz */
>
> Interesting. Does this mean we need to look at extending to 64-bit frequencies?

64-bit value could be best, but I have to learn if that capability flag 
could be used or some other option. Have to study how much bad impact 
(error) it will cause if that 62.5 step is used lowest possible 
frequency (which is near 0 Hz ?). One possibility is allow different cap 
for different bands. For higher frequencies you go the less small step 
size matters - step size it is kinda relative to frequency used.


HackRF commandline tool lists that kind of options - to get idea what 
Linux API should/could also offer:

$ ./hackrf_transfer
receive -r and receive_wav -w options are mutually exclusive
Usage:
	-r <filename> # Receive data into file.
	-t <filename> # Transmit data from file.
	-w # Receive data into file with WAV header and automatic name.
	   # This is for SDR# compatibility and may not work with other software.
	[-f freq_hz] # Frequency in Hz [0MHz to 7250MHz].
	[-i if_freq_hz] # Intermediate Frequency (IF) in Hz [2150MHz to 2750MHz].
	[-o lo_freq_hz] # Front-end Local Oscillator (LO) frequency in Hz 
[84MHz to 5400MHz].
	[-m image_reject] # Image rejection filter selection, 0=bypass, 1=low 
pass, 2=high pass.
	[-a amp_enable] # RX/TX RF amplifier 1=Enable, 0=Disable.
	[-p antenna_enable] # Antenna port power, 1=Enable, 0=Disable.
	[-l gain_db] # RX LNA (IF) gain, 0-40dB, 8dB steps
	[-g gain_db] # RX VGA (baseband) gain, 0-62dB, 2dB steps
	[-x gain_db] # TX VGA (IF) gain, 0-47dB, 1dB steps
	[-s sample_rate_hz] # Sample rate in Hz (8/10/12.5/16/20MHz, default 
10MHz).
	[-n num_samples] # Number of samples to transfer (default is unlimited).
	[-c amplitude] # CW signal source mode, amplitude 0-127 (DC value to DAC).
	[-b baseband_filter_bw_hz] # Set baseband filter bandwidth in MHz.
	Possible values: 1.75/2.5/3.5/5/5.5/6/7/8/9/10/12/14/15/20/24/28MHz, 
default < sample_rate_hz.



>
>> +	},
>> +};
>> +
>> +/* stream formats */
>> +struct hackrf_format {
>> +	char	*name;
>> +	u32	pixelformat;
>> +	u32	buffersize;
>> +};
>> +
>> +/* format descriptions for capture and preview */
>> +static struct hackrf_format formats[] = {
>> +	{
>> +		.name		= "Complex S8",
>> +		.pixelformat	= V4L2_SDR_FMT_CS8,
>> +		.buffersize	= BULK_BUFFER_SIZE,
>> +	},
>> +};
>> +
>> +static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
>> +
>> +/* intermediate buffers with raw data from the USB device */
>> +struct hackrf_frame_buf {
>> +	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
>> +	struct list_head list;
>> +};
>> +
>> +struct hackrf {
>> +#define POWER_ON           (1 << 1)
>> +#define URB_BUF            (1 << 2)
>> +#define USB_STATE_URB_BUF  (1 << 3)
>> +	unsigned long flags;
>> +
>> +	struct device *dev;
>> +	struct usb_device *udev;
>> +	struct video_device vdev;
>> +	struct v4l2_device v4l2_dev;
>> +
>> +	/* videobuf2 queue and queued buffers list */
>> +	struct vb2_queue vb_queue;
>> +	struct list_head queued_bufs;
>> +	spinlock_t queued_bufs_lock; /* Protects queued_bufs */
>> +	unsigned sequence;	     /* Buffer sequence counter */
>> +	unsigned int vb_full;        /* vb is full and packets dropped */
>> +
>> +	/* Note if taking both locks v4l2_lock must always be locked first! */
>> +	struct mutex v4l2_lock;      /* Protects everything else */
>> +	struct mutex vb_queue_lock;  /* Protects vb_queue and capt_file */
>
> capt_file? Not sure what you mean with that.

Seems to be copy paste originally from:
drivers/media/usb/pwc/pwc.h

>
>> +
>> +	struct urb     *urb_list[MAX_BULK_BUFS];
>> +	int            buf_num;
>> +	unsigned long  buf_size;
>> +	u8             *buf_list[MAX_BULK_BUFS];
>> +	dma_addr_t     dma_addr[MAX_BULK_BUFS];
>> +	int            urbs_initialized;
>> +	int            urbs_submitted;
>> +
>> +	/* USB control message buffer */
>> +	#define BUF_SIZE 24
>> +	u8 buf[BUF_SIZE];
>> +
>> +	/* Current configuration */
>> +	unsigned int f_adc;
>> +	unsigned int f_rf;
>> +	u32 pixelformat;
>> +	u32 buffersize;
>> +
>> +	/* Controls */
>> +	struct v4l2_ctrl_handler hdl;
>> +	struct v4l2_ctrl *bandwidth_auto;
>> +	struct v4l2_ctrl *bandwidth;
>> +	struct v4l2_ctrl *lna_gain;
>> +	struct v4l2_ctrl *if_gain;
>> +
>> +	/* Sample rate calc */
>> +	unsigned long jiffies_next;
>> +	unsigned int sample;
>> +	unsigned int sample_measured;
>> +};
>> +
>> +#define hackrf_dbg_usb_control_msg(_udev, _r, _t, _v, _i, _b, _l) { \
>> +	char *_direction; \
>> +	if (_t & USB_DIR_IN) \
>> +		_direction = "<<<"; \
>> +	else \
>> +		_direction = ">>>"; \
>> +	dev_dbg(&_udev->dev, "%02x %02x %02x %02x %02x %02x %02x %02x " \
>> +			"%s %*ph\n", _t, _r, _v & 0xff, _v >> 8, _i & 0xff, \
>> +			_i >> 8, _l & 0xff, _l >> 8, _direction, _l, _b); \
>> +}
>> +
>> +/* execute firmware command */
>> +static int hackrf_ctrl_msg(struct hackrf *s, u8 request, u16 value, u16 index,
>> +		u8 *data, u16 size)
>> +{
>> +	int ret;
>> +	unsigned int pipe;
>> +	u8 requesttype;
>> +
>> +	switch (request) {
>> +	case CMD_SET_TRANSCEIVER_MODE:
>> +	case CMD_SET_FREQ:
>> +	case CMD_SAMPLE_RATE_SET:
>> +	case CMD_BASEBAND_FILTER_BANDWIDTH_SET:
>> +		pipe = usb_sndctrlpipe(s->udev, 0);
>> +		requesttype = (USB_TYPE_VENDOR | USB_DIR_OUT);
>> +		break;
>> +	case CMD_BOARD_ID_READ:
>> +	case CMD_VERSION_STRING_READ:
>> +	case CMD_SET_LNA_GAIN:
>> +	case CMD_SET_VGA_GAIN:
>> +		pipe = usb_rcvctrlpipe(s->udev, 0);
>> +		requesttype = (USB_TYPE_VENDOR | USB_DIR_IN);
>> +		break;
>> +	default:
>> +		dev_err(s->dev, "Unknown command %02x\n", request);
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	/* write request */
>> +	if (!(requesttype & USB_DIR_IN))
>> +		memcpy(s->buf, data, size);
>> +
>> +	ret = usb_control_msg(s->udev, pipe, request, requesttype, value,
>> +			index, s->buf, size, 1000);
>> +	hackrf_dbg_usb_control_msg(s->udev, request, requesttype, value,
>> +			index, s->buf, size);
>> +	if (ret < 0) {
>> +		dev_err(s->dev, "usb_control_msg() failed %d request %02x\n",
>> +				ret, request);
>> +		goto err;
>> +	}
>> +
>> +	/* read request */
>> +	if (requesttype & USB_DIR_IN)
>> +		memcpy(data, s->buf, size);
>> +
>> +	return 0;
>> +err:
>> +	return ret;
>> +}
>> +
>> +/* Private functions */
>> +static struct hackrf_frame_buf *hackrf_get_next_fill_buf(struct hackrf *s)
>> +{
>> +	unsigned long flags = 0;
>> +	struct hackrf_frame_buf *buf = NULL;
>> +
>> +	spin_lock_irqsave(&s->queued_bufs_lock, flags);
>> +	if (list_empty(&s->queued_bufs))
>> +		goto leave;
>> +
>> +	buf = list_entry(s->queued_bufs.next, struct hackrf_frame_buf, list);
>> +	list_del(&buf->list);
>> +leave:
>> +	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
>> +	return buf;
>> +}
>> +
>> +static unsigned int hackrf_convert_stream(struct hackrf *s,
>> +		void *dst, void *src, unsigned int src_len)
>> +{
>> +	memcpy(dst, src, src_len);
>> +
>> +	/* calculate sample rate and output it in 10 seconds intervals */
>> +	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
>> +		#define MSECS 10000UL
>> +		unsigned int msecs = jiffies_to_msecs(jiffies -
>> +				s->jiffies_next + msecs_to_jiffies(MSECS));
>> +		unsigned int samples = s->sample - s->sample_measured;
>> +
>> +		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
>> +		s->sample_measured = s->sample;
>> +		dev_dbg(s->dev, "slen=%u samples=%u msecs=%u sample rate=%lu\n",
>> +				src_len, samples, msecs,
>> +				samples * 1000UL / msecs);
>> +	}
>> +
>> +	/* total number of samples */
>> +	s->sample += src_len / 2;
>> +
>> +	return src_len;
>> +}
>> +
>> +/*
>> + * This gets called for the bulk stream pipe. This is done in interrupt
>> + * time, so it has to be fast, not crash, and not stall. Neat.
>> + */
>> +static void hackrf_urb_complete(struct urb *urb)
>> +{
>> +	struct hackrf *s = urb->context;
>> +	struct hackrf_frame_buf *fbuf;
>> +
>> +	dev_dbg_ratelimited(s->dev, "status=%d length=%d/%d errors=%d\n",
>> +			urb->status, urb->actual_length,
>> +			urb->transfer_buffer_length, urb->error_count);
>> +
>> +	switch (urb->status) {
>> +	case 0:             /* success */
>> +	case -ETIMEDOUT:    /* NAK */
>> +		break;
>> +	case -ECONNRESET:   /* kill */
>> +	case -ENOENT:
>> +	case -ESHUTDOWN:
>> +		return;
>> +	default:            /* error */
>> +		dev_err_ratelimited(s->dev, "URB failed %d\n", urb->status);
>> +		break;
>> +	}
>> +
>> +	if (likely(urb->actual_length > 0)) {
>> +		void *ptr;
>> +		unsigned int len;
>> +		/* get free framebuffer */
>> +		fbuf = hackrf_get_next_fill_buf(s);
>> +		if (unlikely(fbuf == NULL)) {
>> +			s->vb_full++;
>> +			dev_notice_ratelimited(s->dev,
>> +					"videobuf is full, %d packets dropped\n",
>> +					s->vb_full);
>> +			goto skip;
>> +		}
>> +
>> +		/* fill framebuffer */
>> +		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
>> +		len = hackrf_convert_stream(s, ptr, urb->transfer_buffer,
>> +				urb->actual_length);
>> +		vb2_set_plane_payload(&fbuf->vb, 0, len);
>> +		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
>> +		fbuf->vb.v4l2_buf.sequence = s->sequence++;
>> +		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
>> +	}
>> +skip:
>> +	usb_submit_urb(urb, GFP_ATOMIC);
>> +}
>> +
>> +static int hackrf_kill_urbs(struct hackrf *s)
>> +{
>> +	int i;
>> +
>> +	for (i = s->urbs_submitted - 1; i >= 0; i--) {
>> +		dev_dbg(s->dev, "kill urb=%d\n", i);
>> +		/* stop the URB */
>> +		usb_kill_urb(s->urb_list[i]);
>> +	}
>> +	s->urbs_submitted = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_submit_urbs(struct hackrf *s)
>> +{
>> +	int i, ret;
>> +
>> +	for (i = 0; i < s->urbs_initialized; i++) {
>> +		dev_dbg(s->dev, "submit urb=%d\n", i);
>> +		ret = usb_submit_urb(s->urb_list[i], GFP_ATOMIC);
>> +		if (ret) {
>> +			dev_err(s->dev, "Could not submit URB no. %d - get them all back\n",
>> +					i);
>> +			hackrf_kill_urbs(s);
>> +			return ret;
>> +		}
>> +		s->urbs_submitted++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_free_stream_bufs(struct hackrf *s)
>> +{
>> +	if (s->flags & USB_STATE_URB_BUF) {
>> +		while (s->buf_num) {
>> +			s->buf_num--;
>> +			dev_dbg(s->dev, "free buf=%d\n", s->buf_num);
>> +			usb_free_coherent(s->udev, s->buf_size,
>> +					  s->buf_list[s->buf_num],
>> +					  s->dma_addr[s->buf_num]);
>> +		}
>> +	}
>> +	s->flags &= ~USB_STATE_URB_BUF;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_alloc_stream_bufs(struct hackrf *s)
>> +{
>> +	s->buf_num = 0;
>> +	s->buf_size = BULK_BUFFER_SIZE;
>> +
>> +	dev_dbg(s->dev, "all in all I will use %u bytes for streaming\n",
>> +			MAX_BULK_BUFS * BULK_BUFFER_SIZE);
>> +
>> +	for (s->buf_num = 0; s->buf_num < MAX_BULK_BUFS; s->buf_num++) {
>> +		s->buf_list[s->buf_num] = usb_alloc_coherent(s->udev,
>> +				BULK_BUFFER_SIZE, GFP_ATOMIC,
>> +				&s->dma_addr[s->buf_num]);
>> +		if (!s->buf_list[s->buf_num]) {
>> +			dev_dbg(s->dev, "alloc buf=%d failed\n", s->buf_num);
>> +			hackrf_free_stream_bufs(s);
>> +			return -ENOMEM;
>> +		}
>> +
>> +		dev_dbg(s->dev, "alloc buf=%d %p (dma %llu)\n", s->buf_num,
>> +				s->buf_list[s->buf_num],
>> +				(long long)s->dma_addr[s->buf_num]);
>> +		s->flags |= USB_STATE_URB_BUF;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_free_urbs(struct hackrf *s)
>> +{
>> +	int i;
>> +
>> +	hackrf_kill_urbs(s);
>> +
>> +	for (i = s->urbs_initialized - 1; i >= 0; i--) {
>> +		if (s->urb_list[i]) {
>> +			dev_dbg(s->dev, "free urb=%d\n",
>> +					i);
>> +			/* free the URBs */
>> +			usb_free_urb(s->urb_list[i]);
>> +		}
>> +	}
>> +	s->urbs_initialized = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_alloc_urbs(struct hackrf *s)
>> +{
>> +	int i, j;
>> +
>> +	/* allocate the URBs */
>> +	for (i = 0; i < MAX_BULK_BUFS; i++) {
>> +		dev_dbg(s->dev, "alloc urb=%d\n", i);
>> +		s->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
>> +		if (!s->urb_list[i]) {
>> +			dev_dbg(s->dev, "failed\n");
>> +			for (j = 0; j < i; j++)
>> +				usb_free_urb(s->urb_list[j]);
>> +			return -ENOMEM;
>> +		}
>> +		usb_fill_bulk_urb(s->urb_list[i],
>> +				s->udev,
>> +				usb_rcvbulkpipe(s->udev, 0x81),
>> +				s->buf_list[i],
>> +				BULK_BUFFER_SIZE,
>> +				hackrf_urb_complete, s);
>> +
>> +		s->urb_list[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
>> +		s->urb_list[i]->transfer_dma = s->dma_addr[i];
>> +		s->urbs_initialized++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* Must be called with vb_queue_lock hold */
>> +static void hackrf_cleanup_queued_bufs(struct hackrf *s)
>> +{
>> +	unsigned long flags = 0;
>> +
>> +	dev_dbg(s->dev, "\n");
>> +
>> +	spin_lock_irqsave(&s->queued_bufs_lock, flags);
>> +	while (!list_empty(&s->queued_bufs)) {
>> +		struct hackrf_frame_buf *buf;
>> +
>> +		buf = list_entry(s->queued_bufs.next,
>> +				struct hackrf_frame_buf, list);
>> +		list_del(&buf->list);
>> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +	}
>> +	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
>> +}
>> +
>> +/* The user yanked out the cable... */
>> +static void hackrf_disconnect(struct usb_interface *intf)
>> +{
>> +	struct v4l2_device *v = usb_get_intfdata(intf);
>> +	struct hackrf *s = container_of(v, struct hackrf, v4l2_dev);
>> +
>> +	dev_dbg(s->dev, "\n");
>> +
>> +	mutex_lock(&s->vb_queue_lock);
>> +	mutex_lock(&s->v4l2_lock);
>> +	/* No need to keep the urbs around after disconnection */
>> +	s->udev = NULL;
>> +	v4l2_device_disconnect(&s->v4l2_dev);
>> +	video_unregister_device(&s->vdev);
>> +	mutex_unlock(&s->v4l2_lock);
>> +	mutex_unlock(&s->vb_queue_lock);
>> +
>> +	v4l2_device_put(&s->v4l2_dev);
>> +}
>> +
>> +/* Videobuf2 operations */
>> +static int hackrf_queue_setup(struct vb2_queue *vq,
>> +		const struct v4l2_format *fmt, unsigned int *nbuffers,
>> +		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +	struct hackrf *s = vb2_get_drv_priv(vq);
>> +
>> +	dev_dbg(s->dev, "nbuffers=%d\n", *nbuffers);
>> +
>> +	/* Need at least 8 buffers */
>> +	if (vq->num_buffers + *nbuffers < 8)
>> +		*nbuffers = 8 - vq->num_buffers;
>> +	*nplanes = 1;
>> +	sizes[0] = PAGE_ALIGN(s->buffersize);
>> +
>> +	dev_dbg(s->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
>> +	return 0;
>> +}
>> +
>> +static void hackrf_buf_queue(struct vb2_buffer *vb)
>> +{
>> +	struct hackrf *s = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct hackrf_frame_buf *buf =
>> +			container_of(vb, struct hackrf_frame_buf, vb);
>> +	unsigned long flags = 0;
>> +
>> +	/* Check the device has not disconnected between prep and queuing */
>> +	if (unlikely(!s->udev)) {
>
> This shouldn't be needed. I don't think you can ever get this situation.

OK, I will remove.

>
>> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>> +		return;
>> +	}
>> +
>> +	spin_lock_irqsave(&s->queued_bufs_lock, flags);
>> +	list_add_tail(&buf->list, &s->queued_bufs);
>> +	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
>> +}
>> +
>> +static int hackrf_start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +	struct hackrf *s = vb2_get_drv_priv(vq);
>> +	int ret;
>> +
>> +	dev_dbg(s->dev, "\n");
>> +
>> +	if (!s->udev)
>> +		return -ENODEV;
>> +
>> +	mutex_lock(&s->v4l2_lock);
>> +
>> +	set_bit(POWER_ON, &s->flags);
>> +
>> +	s->sequence = 0;
>> +
>> +	ret = hackrf_alloc_stream_bufs(s);
>> +	if (ret)
>> +		goto err;
>> +
>> +	ret = hackrf_alloc_urbs(s);
>> +	if (ret)
>> +		goto err;
>> +
>> +	ret = hackrf_submit_urbs(s);
>> +	if (ret)
>> +		goto err;
>> +
>> +	/* start hardware streaming */
>> +	ret = hackrf_ctrl_msg(s, CMD_SET_TRANSCEIVER_MODE, 1, 0, NULL, 0);
>> +	if (ret)
>> +		goto err;
>> +err:
>
> If start_streaming fails with an error, then all queued buffers need to be returned
> to vb2 with vb2_buffer_done(..., STATE_QUEUED). Note that videobuf2-core.h says in
> the start_streaming comment that it should go to STATE_DEQUEUED. This is a bug in
> the comment and the patch fixing that is waiting to be merged.

I will look that too.

>
>> +	mutex_unlock(&s->v4l2_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static void hackrf_stop_streaming(struct vb2_queue *vq)
>> +{
>> +	struct hackrf *s = vb2_get_drv_priv(vq);
>> +
>> +	dev_dbg(s->dev, "\n");
>> +
>> +	mutex_lock(&s->v4l2_lock);
>> +
>> +	/* stop hardware streaming */
>> +	hackrf_ctrl_msg(s, CMD_SET_TRANSCEIVER_MODE, 0, 0, NULL, 0);
>> +
>> +	hackrf_kill_urbs(s);
>> +	hackrf_free_urbs(s);
>> +	hackrf_free_stream_bufs(s);
>> +
>> +	hackrf_cleanup_queued_bufs(s);
>> +
>> +	clear_bit(POWER_ON, &s->flags);
>> +
>> +	mutex_unlock(&s->v4l2_lock);
>> +}
>> +
>> +static struct vb2_ops hackrf_vb2_ops = {
>> +	.queue_setup            = hackrf_queue_setup,
>> +	.buf_queue              = hackrf_buf_queue,
>> +	.start_streaming        = hackrf_start_streaming,
>> +	.stop_streaming         = hackrf_stop_streaming,
>> +	.wait_prepare           = vb2_ops_wait_prepare,
>> +	.wait_finish            = vb2_ops_wait_finish,
>> +};
>> +
>> +static int hackrf_querycap(struct file *file, void *fh,
>> +		struct v4l2_capability *cap)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +
>> +	dev_dbg(s->dev, "\n");
>> +
>> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
>> +	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
>> +	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
>> +	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
>> +			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_s_fmt_sdr_cap(struct file *file, void *priv,
>> +		struct v4l2_format *f)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +	struct vb2_queue *q = &s->vb_queue;
>> +	int i;
>> +
>> +	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
>> +			(char *)&f->fmt.sdr.pixelformat);
>
> Not necessary: with 'echo 2 >/sys/class/video4linux/swradio0/debug' you can turn on
> debugging that shows exactly the same. I would recommend dropping these debug
> messages from all the ioctl ops for that reason.

OK, I will do.

>
>> +
>> +	if (vb2_is_busy(q))
>> +		return -EBUSY;
>> +
>> +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>> +	for (i = 0; i < NUM_FORMATS; i++) {
>> +		if (f->fmt.sdr.pixelformat == formats[i].pixelformat) {
>> +			s->pixelformat = formats[i].pixelformat;
>> +			s->buffersize = formats[i].buffersize;
>> +			f->fmt.sdr.buffersize = formats[i].buffersize;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	s->pixelformat = formats[0].pixelformat;
>> +	s->buffersize = formats[0].buffersize;
>> +	f->fmt.sdr.pixelformat = formats[0].pixelformat;
>> +	f->fmt.sdr.buffersize = formats[0].buffersize;
>
> It might be cleaner if s_fmt calls try_fmt to reduce code duplication.

I will check and consider, but generally I feel more comfortable 
implement all in one function and avoid calling functions. There is 
ofcourse some turning point how many lines to duplicate...

>
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_g_fmt_sdr_cap(struct file *file, void *priv,
>> +		struct v4l2_format *f)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +
>> +	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n", (char *)&s->pixelformat);
>> +
>> +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>> +	f->fmt.sdr.pixelformat = s->pixelformat;
>> +	f->fmt.sdr.buffersize = s->buffersize;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_try_fmt_sdr_cap(struct file *file, void *priv,
>> +		struct v4l2_format *f)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +	int i;
>> +
>> +	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
>> +			(char *)&f->fmt.sdr.pixelformat);
>> +
>> +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>> +	for (i = 0; i < NUM_FORMATS; i++) {
>> +		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
>> +			f->fmt.sdr.buffersize = formats[i].buffersize;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	f->fmt.sdr.pixelformat = formats[0].pixelformat;
>> +	f->fmt.sdr.buffersize = formats[0].buffersize;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_enum_fmt_sdr_cap(struct file *file, void *priv,
>> +		struct v4l2_fmtdesc *f)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +
>> +	dev_dbg(s->dev, "index=%d\n", f->index);
>> +
>> +	if (f->index >= NUM_FORMATS)
>> +		return -EINVAL;
>> +
>> +	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
>> +	f->pixelformat = formats[f->index].pixelformat;
>> +
>> +	return 0;
>> +}
>> +
>> +static int hackrf_s_tuner(struct file *file, void *priv,
>> +		const struct v4l2_tuner *v)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +	int ret;
>> +
>> +	dev_dbg(s->dev, "index=%d\n", v->index);
>> +
>> +	if (v->index == 0)
>> +		ret = 0;
>> +	else if (v->index == 1)
>> +		ret = 0;
>> +	else
>> +		ret = -EINVAL;
>> +
>
> How about:
>
> 	return v->index > 1 ? -EINVAL : 0;
>
> Much shorter.

Few lines shorter, but that follows closely all those other related 
callbacks (like counterpart hackrf_g_tuner).

>
>> +	return ret;
>> +}
>> +
>> +static int hackrf_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +	int ret;
>> +
>> +	dev_dbg(s->dev, "index=%d\n", v->index);
>> +
>> +	if (v->index == 0) {
>> +		strlcpy(v->name, "HackRF ADC", sizeof(v->name));
>> +		v->type = V4L2_TUNER_ADC;
>> +		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
>> +		v->rangelow  = bands_adc[0].rangelow;
>> +		v->rangehigh = bands_adc[0].rangehigh;
>> +		ret = 0;
>> +	} else if (v->index == 1) {
>> +		strlcpy(v->name, "HackRF RF", sizeof(v->name));
>> +		v->type = V4L2_TUNER_RF;
>> +		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
>> +		v->rangelow  = bands_rf[0].rangelow;
>> +		v->rangehigh = bands_rf[0].rangehigh;
>> +		ret = 0;
>> +	} else {
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int hackrf_s_frequency(struct file *file, void *priv,
>> +		const struct v4l2_frequency *f)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +	int ret;
>> +	unsigned int upper, lower;
>> +	u8 buf[8];
>> +
>> +	dev_dbg(s->dev, "tuner=%d type=%d frequency=%u\n",
>> +			f->tuner, f->type, f->frequency);
>> +
>> +	if (f->tuner == 0) {
>> +		s->f_adc = clamp_t(unsigned int, f->frequency,
>> +				bands_adc[0].rangelow, bands_adc[0].rangehigh);
>> +		dev_dbg(s->dev, "ADC frequency=%u Hz\n", s->f_adc);
>> +		upper = s->f_adc;
>> +		lower = 1;
>> +		buf[0] = (upper >>  0) & 0xff;
>> +		buf[1] = (upper >>  8) & 0xff;
>> +		buf[2] = (upper >> 16) & 0xff;
>> +		buf[3] = (upper >> 24) & 0xff;
>> +		buf[4] = (lower >>  0) & 0xff;
>> +		buf[5] = (lower >>  8) & 0xff;
>> +		buf[6] = (lower >> 16) & 0xff;
>> +		buf[7] = (lower >> 24) & 0xff;
>> +		ret = hackrf_ctrl_msg(s, CMD_SAMPLE_RATE_SET, 0, 0, buf, 8);
>> +	} else if (f->tuner == 1) {
>> +		s->f_rf = clamp_t(unsigned int, f->frequency,
>> +				bands_rf[0].rangelow, bands_rf[0].rangehigh);
>> +		dev_dbg(s->dev, "RF frequency=%u Hz\n", s->f_rf);
>> +		upper = s->f_rf / 1000000;
>> +		lower = s->f_rf % 1000000;
>> +		buf[0] = (upper >>  0) & 0xff;
>> +		buf[1] = (upper >>  8) & 0xff;
>> +		buf[2] = (upper >> 16) & 0xff;
>> +		buf[3] = (upper >> 24) & 0xff;
>> +		buf[4] = (lower >>  0) & 0xff;
>> +		buf[5] = (lower >>  8) & 0xff;
>> +		buf[6] = (lower >> 16) & 0xff;
>> +		buf[7] = (lower >> 24) & 0xff;
>> +		ret = hackrf_ctrl_msg(s, CMD_SET_FREQ, 0, 0, buf, 8);
>> +	} else {
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int hackrf_g_frequency(struct file *file, void *priv,
>> +		struct v4l2_frequency *f)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +	int ret;
>> +
>> +	dev_dbg(s->dev, "tuner=%d type=%d\n", f->tuner, f->type);
>> +
>> +	if (f->tuner == 0) {
>> +		f->type = V4L2_TUNER_ADC;
>> +		f->frequency = s->f_adc;
>> +		ret = 0;
>> +	} else if (f->tuner == 1) {
>> +		f->type = V4L2_TUNER_RF;
>> +		f->frequency = s->f_rf;
>> +		ret = 0;
>> +	} else {
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int hackrf_enum_freq_bands(struct file *file, void *priv,
>> +		struct v4l2_frequency_band *band)
>> +{
>> +	struct hackrf *s = video_drvdata(file);
>> +	int ret;
>> +
>> +	dev_dbg(s->dev, "tuner=%d type=%d index=%d\n",
>> +			band->tuner, band->type, band->index);
>> +
>> +	if (band->tuner == 0) {
>> +		if (band->index >= ARRAY_SIZE(bands_adc)) {
>> +			ret = -EINVAL;
>> +		} else {
>> +			*band = bands_adc[band->index];
>> +			ret = 0;
>> +		}
>> +	} else if (band->tuner == 1) {
>> +		if (band->index >= ARRAY_SIZE(bands_rf)) {
>> +			ret = -EINVAL;
>> +		} else {
>> +			*band = bands_rf[band->index];
>> +			ret = 0;
>> +		}
>> +	} else {
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops hackrf_ioctl_ops = {
>> +	.vidioc_querycap          = hackrf_querycap,
>> +
>> +	.vidioc_s_fmt_sdr_cap     = hackrf_s_fmt_sdr_cap,
>> +	.vidioc_g_fmt_sdr_cap     = hackrf_g_fmt_sdr_cap,
>> +	.vidioc_enum_fmt_sdr_cap  = hackrf_enum_fmt_sdr_cap,
>> +	.vidioc_try_fmt_sdr_cap   = hackrf_try_fmt_sdr_cap,
>> +
>> +	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
>> +	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
>> +	.vidioc_prepare_buf       = vb2_ioctl_prepare_buf,
>> +	.vidioc_querybuf          = vb2_ioctl_querybuf,
>> +	.vidioc_qbuf              = vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf             = vb2_ioctl_dqbuf,
>> +
>> +	.vidioc_streamon          = vb2_ioctl_streamon,
>> +	.vidioc_streamoff         = vb2_ioctl_streamoff,
>> +
>> +	.vidioc_s_tuner           = hackrf_s_tuner,
>> +	.vidioc_g_tuner           = hackrf_g_tuner,
>> +
>> +	.vidioc_s_frequency       = hackrf_s_frequency,
>> +	.vidioc_g_frequency       = hackrf_g_frequency,
>> +	.vidioc_enum_freq_bands   = hackrf_enum_freq_bands,
>> +
>> +	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>> +	.vidioc_log_status        = v4l2_ctrl_log_status,
>> +};
>> +
>> +static const struct v4l2_file_operations hackrf_fops = {
>> +	.owner                    = THIS_MODULE,
>> +	.open                     = v4l2_fh_open,
>> +	.release                  = vb2_fop_release,
>> +	.read                     = vb2_fop_read,
>> +	.poll                     = vb2_fop_poll,
>> +	.mmap                     = vb2_fop_mmap,
>> +	.unlocked_ioctl           = video_ioctl2,
>> +};
>> +
>> +static struct video_device hackrf_template = {
>> +	.name                     = "HackRF One",
>> +	.release                  = video_device_release_empty,
>> +	.fops                     = &hackrf_fops,
>> +	.ioctl_ops                = &hackrf_ioctl_ops,
>> +};
>> +
>> +static void hackrf_video_release(struct v4l2_device *v)
>> +{
>> +	struct hackrf *s = container_of(v, struct hackrf, v4l2_dev);
>> +
>> +	v4l2_ctrl_handler_free(&s->hdl);
>> +	v4l2_device_unregister(&s->v4l2_dev);
>> +	kfree(s);
>> +}
>> +
>> +static int hackrf_set_bandwidth(struct hackrf *s)
>> +{
>> +	int ret, i;
>> +	u16 u16tmp, u16tmp2;
>> +	unsigned int bandwidth;
>> +
>> +	static const struct {
>> +		u32 freq;
>> +	} bandwidth_lut[] = {
>> +		{ 1750000}, /*  1.75 MHz */
>> +		{ 2500000}, /*  2.5  MHz */
>> +		{ 3500000}, /*  3.5  MHz */
>> +		{ 5000000}, /*  5    MHz */
>> +		{ 5500000}, /*  5.5  MHz */
>> +		{ 6000000}, /*  6    MHz */
>> +		{ 7000000}, /*  7    MHz */
>> +		{ 8000000}, /*  8    MHz */
>> +		{ 9000000}, /*  9    MHz */
>> +		{10000000}, /* 10    MHz */
>> +		{12000000}, /* 12    MHz */
>> +		{14000000}, /* 14    MHz */
>> +		{15000000}, /* 15    MHz */
>> +		{20000000}, /* 20    MHz */
>> +		{24000000}, /* 24    MHz */
>> +		{28000000}, /* 28    MHz */
>> +	};
>> +
>> +	dev_dbg(s->dev, "bandwidth auto=%d->%d val=%d->%d f_adc=%u\n",
>> +			s->bandwidth_auto->cur.val,
>> +			s->bandwidth_auto->val, s->bandwidth->cur.val,
>> +			s->bandwidth->val, s->f_adc);
>> +
>> +	if (s->bandwidth_auto->val == true)
>> +		bandwidth = s->f_adc;
>> +	else
>> +		bandwidth = s->bandwidth->val;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
>> +		if (bandwidth <= bandwidth_lut[i].freq) {
>> +			bandwidth = bandwidth_lut[i].freq;
>> +			break;
>> +		}
>> +	}
>> +
>> +	s->bandwidth->val = bandwidth;
>> +	s->bandwidth->cur.val = bandwidth;
>> +
>> +	dev_dbg(s->dev, "bandwidth selected=%d\n", bandwidth_lut[i].freq);
>> +
>> +	u16tmp = 0;
>> +	u16tmp |= ((bandwidth >> 0) & 0xff) << 0;
>> +	u16tmp |= ((bandwidth >> 8) & 0xff) << 8;
>> +	u16tmp2 = 0;
>> +	u16tmp2 |= ((bandwidth >> 16) & 0xff) << 0;
>> +	u16tmp2 |= ((bandwidth >> 24) & 0xff) << 8;
>> +
>> +	ret = hackrf_ctrl_msg(s, CMD_BASEBAND_FILTER_BANDWIDTH_SET,
>> +				u16tmp, u16tmp2, NULL, 0);
>> +	if (ret)
>> +		dev_dbg(s->dev, "failed=%d\n", ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int hackrf_set_lna_gain(struct hackrf *s)
>> +{
>> +	int ret;
>> +	u8 u8tmp;
>> +
>> +	dev_dbg(s->dev, "lna val=%d->%d\n",
>> +			s->lna_gain->cur.val, s->lna_gain->val);
>> +
>> +	ret = hackrf_ctrl_msg(s, CMD_SET_LNA_GAIN, 0, s->lna_gain->val,
>> +			&u8tmp, 1);
>> +	if (ret)
>> +		dev_dbg(s->dev, "failed=%d\n", ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int hackrf_set_if_gain(struct hackrf *s)
>> +{
>> +	int ret;
>> +	u8 u8tmp;
>> +
>> +	dev_dbg(s->dev, "val=%d->%d\n",
>> +			s->if_gain->cur.val, s->if_gain->val);
>> +
>> +	ret = hackrf_ctrl_msg(s, CMD_SET_VGA_GAIN, 0, s->if_gain->val,
>> +			&u8tmp, 1);
>> +	if (ret)
>> +		dev_dbg(s->dev, "failed=%d\n", ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int hackrf_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct hackrf *s = container_of(ctrl->handler, struct hackrf, hdl);
>> +	int ret;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
>> +	case V4L2_CID_RF_TUNER_BANDWIDTH:
>> +		ret = hackrf_set_bandwidth(s);
>
> I would just do:
>
> 		return hackrf_set_bandwidth(s);
>
> rather than using a local 'ret' variable.
>
>> +		break;
>> +	case  V4L2_CID_RF_TUNER_LNA_GAIN:
>> +		ret = hackrf_set_lna_gain(s);
>> +		break;
>> +	case  V4L2_CID_RF_TUNER_IF_GAIN:
>> +		ret = hackrf_set_if_gain(s);
>> +		break;
>> +	default:
>> +		dev_dbg(s->dev, "unknown ctrl: id=%d name=%s\n",
>> +				ctrl->id, ctrl->name);
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops hackrf_ctrl_ops = {
>> +	.s_ctrl = hackrf_s_ctrl,
>> +};
>> +
>> +static int hackrf_probe(struct usb_interface *intf,
>> +		const struct usb_device_id *id)
>> +{
>> +	struct hackrf *s;
>> +	int ret;
>> +	u8 u8tmp, buf[BUF_SIZE];
>> +
>> +	s = kzalloc(sizeof(*s), GFP_KERNEL);
>
> devm_kzalloc?

That is also one thing I have though many times. Personally I love to 
see code which is balanced in a way if you alloc something when you 
begin, you have to free it when you left. I recently decided to test 
devm_ for RegMap API and I am near to change it old way. There is now 
even Coverity scanner blaming me about it (not to free regmap)...


>
>> +	if (s == NULL) {
>> +		dev_err(&intf->dev, "Could not allocate memory for state\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	mutex_init(&s->v4l2_lock);
>> +	mutex_init(&s->vb_queue_lock);
>> +	spin_lock_init(&s->queued_bufs_lock);
>> +	INIT_LIST_HEAD(&s->queued_bufs);
>> +	s->dev = &intf->dev;
>> +	s->udev = interface_to_usbdev(intf);
>> +	s->f_adc = bands_adc[0].rangelow;
>> +	s->f_rf = bands_rf[0].rangelow;
>> +	s->pixelformat = formats[0].pixelformat;
>> +	s->buffersize = formats[0].buffersize;
>> +
>> +	/* Detect device */
>> +	ret = hackrf_ctrl_msg(s, CMD_BOARD_ID_READ, 0, 0, &u8tmp, 1);
>> +	if (ret == 0)
>> +		ret = hackrf_ctrl_msg(s, CMD_VERSION_STRING_READ, 0, 0,
>> +				buf, BUF_SIZE);
>> +	if (ret) {
>> +		dev_err(s->dev, "Could not detect board\n");
>> +		goto err_free_mem;
>> +	}
>> +
>> +	buf[BUF_SIZE - 1] = '\0';
>> +
>> +	dev_info(s->dev, "Board ID: %02x\n", u8tmp);
>> +	dev_info(s->dev, "Firmware version: %s\n", buf);
>> +
>> +	/* Init videobuf2 queue structure */
>> +	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
>> +	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
>> +	s->vb_queue.drv_priv = s;
>> +	s->vb_queue.buf_struct_size = sizeof(struct hackrf_frame_buf);
>> +	s->vb_queue.ops = &hackrf_vb2_ops;
>> +	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
>> +	s->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +	ret = vb2_queue_init(&s->vb_queue);
>> +	if (ret) {
>> +		dev_err(s->dev, "Could not initialize vb2 queue\n");
>> +		goto err_free_mem;
>> +	}
>> +
>> +	/* Init video_device structure */
>> +	s->vdev = hackrf_template;
>> +	s->vdev.queue = &s->vb_queue;
>> +	s->vdev.queue->lock = &s->vb_queue_lock;
>> +	video_set_drvdata(&s->vdev, s);
>> +
>> +	/* Register the v4l2_device structure */
>> +	s->v4l2_dev.release = hackrf_video_release;
>> +	ret = v4l2_device_register(&intf->dev, &s->v4l2_dev);
>> +	if (ret) {
>> +		dev_err(s->dev, "Failed to register v4l2-device (%d)\n", ret);
>> +		goto err_free_mem;
>> +	}
>> +
>> +	/* Register controls */
>> +	v4l2_ctrl_handler_init(&s->hdl, 4);
>> +	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, &hackrf_ctrl_ops,
>> +			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
>> +	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, &hackrf_ctrl_ops,
>> +			V4L2_CID_RF_TUNER_BANDWIDTH,
>> +			1750000, 28000000, 50000, 1750000);
>> +	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
>> +	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, &hackrf_ctrl_ops,
>> +			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 40, 8, 0);
>> +	s->if_gain = v4l2_ctrl_new_std(&s->hdl, &hackrf_ctrl_ops,
>> +			V4L2_CID_RF_TUNER_IF_GAIN, 0, 62, 2, 0);
>> +	if (s->hdl.error) {
>> +		ret = s->hdl.error;
>> +		dev_err(s->dev, "Could not initialize controls\n");
>> +		goto err_free_controls;
>> +	}
>> +
>> +	v4l2_ctrl_handler_setup(&s->hdl);
>> +
>> +	s->v4l2_dev.ctrl_handler = &s->hdl;
>> +	s->vdev.v4l2_dev = &s->v4l2_dev;
>> +	s->vdev.lock = &s->v4l2_lock;
>> +
>> +	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
>> +	if (ret) {
>> +		dev_err(s->dev, "Failed to register as video device (%d)\n",
>> +				ret);
>> +		goto err_unregister_v4l2_dev;
>> +	}
>> +	dev_info(s->dev, "Registered as %s\n",
>> +			video_device_node_name(&s->vdev));
>> +	dev_notice(s->dev, "SDR API is still slightly experimental and functionality changes may follow\n");
>> +	return 0;
>> +
>> +err_free_controls:
>> +	v4l2_ctrl_handler_free(&s->hdl);
>> +err_unregister_v4l2_dev:
>> +	v4l2_device_unregister(&s->v4l2_dev);
>> +err_free_mem:
>> +	kfree(s);
>> +	return ret;
>> +}
>> +
>> +/* USB device ID list */
>> +static struct usb_device_id hackrf_id_table[] = {
>> +	{ USB_DEVICE(0x1d50, 0x6089) }, /* HackRF One */
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(usb, hackrf_id_table);
>> +
>> +/* USB subsystem interface */
>> +static struct usb_driver hackrf_driver = {
>> +	.name                     = KBUILD_MODNAME,
>> +	.probe                    = hackrf_probe,
>> +	.disconnect               = hackrf_disconnect,
>> +	.id_table                 = hackrf_id_table,
>> +};
>> +
>> +module_usb_driver(hackrf_driver);
>> +
>> +MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>> +MODULE_DESCRIPTION("HackRF");
>> +MODULE_LICENSE("GPL");
>>
>
> Regards,
>
> 	Hans
>

regards
Antti

-- 
http://palosaari.fi/
