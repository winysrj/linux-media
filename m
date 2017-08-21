Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38538 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753264AbdHUNXt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 09:23:49 -0400
Subject: Re: [PATCH 5/5] [media] cxusb: add analog mode support for Medion
 MD95700
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <6a74971c-171f-7336-065c-59cede29f624@maciej.szmigiero.name>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ea6ab30f-85d4-9afb-d545-d8743e7dd195@xs4all.nl>
Date: Mon, 21 Aug 2017 15:23:43 +0200
MIME-Version: 1.0
In-Reply-To: <6a74971c-171f-7336-065c-59cede29f624@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maciej,

On 08/10/2017 11:53 PM, Maciej S. Szmigiero wrote:
> This patch adds support for analog part of Medion 95700 in the cxusb
> driver.
> 
> What works:
> * Video capture at various sizes with sequential fields,
> * Input switching (TV Tuner, Composite, S-Video),
> * TV and radio tuning,
> * Video standard switching and auto detection,
> * Radio mode switching (stereo / mono),
> * Unplugging while capturing,
> * DVB / analog coexistence,
> * Raw BT.656 stream support.

Another scary patch :-)

A high-level question first: is any of the code in cxusb-analog medion
specific? There are a lot of cxusb_medion_ prefixes, but I wonder if that
shouldn't be cxusb_analog_.

There are some obvious code cleanups that need to take place first, such
as the huge functions with too many indentations. I would also split off
cxusb-analog.c as a separate patch.

Regards,

	Hans

> What does not work yet:
> * Audio,
> * VBI,
> * Picture controls.
> 
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> ---
>  drivers/media/usb/dvb-usb/Kconfig        |    8 +-
>  drivers/media/usb/dvb-usb/Makefile       |    2 +-
>  drivers/media/usb/dvb-usb/cxusb-analog.c | 1867 ++++++++++++++++++++++++++++++
>  drivers/media/usb/dvb-usb/cxusb.c        |  453 +++++++-
>  drivers/media/usb/dvb-usb/cxusb.h        |  137 +++
>  drivers/media/usb/dvb-usb/dvb-usb-dvb.c  |   20 +-
>  drivers/media/usb/dvb-usb/dvb-usb-init.c |   13 +
>  drivers/media/usb/dvb-usb/dvb-usb.h      |    8 +
>  8 files changed, 2449 insertions(+), 59 deletions(-)
>  create mode 100644 drivers/media/usb/dvb-usb/cxusb-analog.c
> 
> diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
> index 959fa09dfd92..ba941069ae3b 100644
> --- a/drivers/media/usb/dvb-usb/Kconfig
> +++ b/drivers/media/usb/dvb-usb/Kconfig
> @@ -118,7 +118,9 @@ config DVB_USB_UMT_010
>  
>  config DVB_USB_CXUSB
>  	tristate "Conexant USB2.0 hybrid reference design support"
> -	depends on DVB_USB
> +	depends on DVB_USB && VIDEO_V4L2
> +	select VIDEO_CX25840
> +	select VIDEOBUF2_VMALLOC
>  	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_CX22702 if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
> @@ -136,8 +138,8 @@ config DVB_USB_CXUSB
>  	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
>  	help
>  	  Say Y here to support the Conexant USB2.0 hybrid reference design.
> -	  Currently, only DVB and ATSC modes are supported, analog mode
> -	  shall be added in the future. Devices that require this module:
> +	  DVB and ATSC modes are supported, with basic analog mode support
> +	  for Medion MD95700. Devices that require this module:
>  
>  	  Medion MD95700 hybrid USB2.0 device.
>  	  DViCO FusionHDTV (Bluebird) USB2.0 devices
> diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
> index 3b3f32b426d1..24d222e9acc7 100644
> --- a/drivers/media/usb/dvb-usb/Makefile
> +++ b/drivers/media/usb/dvb-usb/Makefile
> @@ -40,7 +40,7 @@ obj-$(CONFIG_DVB_USB_M920X) += dvb-usb-m920x.o
>  dvb-usb-digitv-objs := digitv.o
>  obj-$(CONFIG_DVB_USB_DIGITV) += dvb-usb-digitv.o
>  
> -dvb-usb-cxusb-objs := cxusb.o
> +dvb-usb-cxusb-objs := cxusb.o cxusb-analog.o
>  obj-$(CONFIG_DVB_USB_CXUSB) += dvb-usb-cxusb.o
>  
>  dvb-usb-ttusb2-objs := ttusb2.o
> diff --git a/drivers/media/usb/dvb-usb/cxusb-analog.c b/drivers/media/usb/dvb-usb/cxusb-analog.c
> new file mode 100644
> index 000000000000..473d3f06145f
> --- /dev/null
> +++ b/drivers/media/usb/dvb-usb/cxusb-analog.c
> @@ -0,0 +1,1867 @@
> +/* DVB USB compliant linux driver for Conexant USB reference design -
> + * (analog part).
> + *
> + * Copyright (C) 2011, 2017 Maciej S. Szmigiero (mail@maciej.szmigiero.name)
> + *
> + * TODO:
> + *  * audio support,
> + *  * finish radio support (requires audio of course),
> + *  * VBI support,
> + *  * controls support
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/timekeeping.h>
> +#include <linux/vmalloc.h>
> +#include <media/drv-intf/cx25840.h>
> +#include <media/tuner.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-v4l2.h>
> +#include <media/videobuf2-vmalloc.h>
> +
> +#include "cxusb.h"
> +
> +static int cxusb_medion_v_queue_setup(struct vb2_queue *q,
> +				      unsigned int *num_buffers,
> +				      unsigned int *num_planes,
> +				      unsigned int sizes[],
> +				      struct device *alloc_devs[])
> +{
> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	unsigned int size = cxdev->raw_mode ?
> +		CXUSB_VIDEO_MAX_FRAME_SIZE :
> +		cxdev->width * cxdev->height * 2;
> +
> +	if (*num_planes > 0) {
> +		if (*num_planes != 1)
> +			return -EINVAL;
> +
> +		if (sizes[0] < size)
> +			return -EINVAL;
> +	} else {
> +		*num_planes = 1;
> +		sizes[0] = size;
> +	}
> +
> +	if (q->num_buffers + *num_buffers < 6)
> +		*num_buffers = 6 - q->num_buffers;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_v_buf_init(struct vb2_buffer *vb)
> +{
> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	cxusb_vprintk(dvbdev, OPS, "buffer init\n");
> +
> +	if (cxdev->raw_mode) {
> +		if (vb2_plane_size(vb, 0) < CXUSB_VIDEO_MAX_FRAME_SIZE)
> +			return -ENOMEM;
> +	} else {
> +		if (vb2_plane_size(vb, 0) < cxdev->width * cxdev->height * 2)
> +			return -ENOMEM;
> +	}
> +
> +	cxusb_vprintk(dvbdev, OPS, "buffer OK\n");
> +
> +	return 0;
> +}
> +
> +static void cxusb_auxbuf_init(struct cxusb_medion_auxbuf *auxbuf,
> +			      u8 *buf, unsigned int len)
> +{
> +	auxbuf->buf = buf;
> +	auxbuf->len = len;
> +	auxbuf->paylen = 0;
> +}
> +
> +static void cxusb_auxbuf_head_trim(struct dvb_usb_device *dvbdev,
> +				   struct cxusb_medion_auxbuf *auxbuf,
> +				   unsigned int pos)
> +{
> +	if (pos == 0)
> +		return;
> +
> +	if (WARN_ON(pos > auxbuf->paylen))
> +		return;
> +
> +	cxusb_vprintk(dvbdev, AUXB,
> +		      "trimming auxbuf len by %u to %u\n",
> +		      pos, auxbuf->paylen - pos);
> +
> +	memmove(auxbuf->buf, auxbuf->buf + pos, auxbuf->paylen - pos);
> +	auxbuf->paylen -= pos;
> +}
> +
> +static unsigned int cxusb_auxbuf_paylen(struct cxusb_medion_auxbuf *auxbuf)
> +{
> +	return auxbuf->paylen;
> +}
> +
> +static bool cxusb_auxbuf_make_space(struct dvb_usb_device *dvbdev,
> +				    struct cxusb_medion_auxbuf *auxbuf,
> +				    unsigned int howmuch)
> +{
> +	unsigned int freespace;
> +
> +	if (WARN_ON(howmuch >= auxbuf->len))
> +		howmuch = auxbuf->len - 1;
> +
> +	freespace = auxbuf->len -
> +		cxusb_auxbuf_paylen(auxbuf);
> +
> +	cxusb_vprintk(dvbdev, AUXB, "freespace is %u\n", freespace);
> +
> +	if (freespace >= howmuch)
> +		return true;
> +
> +	howmuch -= freespace;
> +
> +	cxusb_vprintk(dvbdev, AUXB, "will overwrite %u bytes of buffer\n",
> +		      howmuch);
> +
> +	cxusb_auxbuf_head_trim(dvbdev, auxbuf, howmuch);
> +
> +	return false;
> +}
> +
> +/* returns false if some data was overwritten */
> +static bool cxusb_auxbuf_append_urb(struct dvb_usb_device *dvbdev,
> +				    struct cxusb_medion_auxbuf *auxbuf,
> +				    struct urb *urb,
> +				    unsigned int len)
> +{
> +	int i;
> +	bool ret;
> +
> +	ret = cxusb_auxbuf_make_space(dvbdev, auxbuf, len);
> +
> +	for (i = 0; i < urb->number_of_packets; i++) {
> +		unsigned int to_copy;
> +
> +		to_copy = urb->iso_frame_desc[i].actual_length;
> +
> +		if (to_copy == 0)
> +			continue;
> +
> +		memcpy(auxbuf->buf + auxbuf->paylen, urb->transfer_buffer +
> +		       urb->iso_frame_desc[i].offset, to_copy);
> +
> +		auxbuf->paylen += to_copy;
> +	}
> +
> +	return ret;
> +}
> +
> +static bool cxusb_auxbuf_copy(struct cxusb_medion_auxbuf *auxbuf,
> +			      unsigned int pos, unsigned char *dest,
> +			      unsigned int len)
> +{
> +	if (pos+len > auxbuf->paylen)
> +		return false;
> +
> +	memcpy(dest, auxbuf->buf + pos, len);
> +
> +	return true;
> +}
> +
> +static unsigned int cxusb_auxbuf_advance(struct cxusb_medion_auxbuf *auxbuf,
> +					 unsigned int pos,
> +					 unsigned int increment)
> +{
> +	return pos + increment;
> +}
> +
> +static unsigned int cxusb_auxbuf_begin(struct cxusb_medion_auxbuf *auxbuf)
> +{
> +	return 0;
> +}
> +
> +static bool cxusb_auxbuf_isend(struct cxusb_medion_auxbuf *auxbuf,
> +			       unsigned int pos)
> +{
> +	return pos >= auxbuf->paylen;
> +}
> +
> +static bool cxusb_medion_copy_field(struct dvb_usb_device *dvbdev,
> +				    struct cxusb_medion_auxbuf *auxbuf,
> +				    struct cxusb_bt656_params *bt656,
> +				    bool firstfield,
> +				    unsigned int maxlines,
> +				    unsigned int maxlinesamples)
> +{
> +	while (bt656->line < maxlines &&
> +	       !cxusb_auxbuf_isend(auxbuf, bt656->pos)) {
> +
> +		unsigned char val;
> +
> +		if (!cxusb_auxbuf_copy(auxbuf, bt656->pos, &val, 1))
> +			return false;
> +
> +		if ((char)val == CXUSB_BT656_COMMON[0]) {
> +			char buf[3];
> +
> +			if (!cxusb_auxbuf_copy(auxbuf, bt656->pos + 1,
> +					       buf, 3))
> +				return false;
> +
> +			if (buf[0] != (CXUSB_BT656_COMMON)[1] ||
> +			    buf[1] != (CXUSB_BT656_COMMON)[2])
> +				goto normal_sample;
> +
> +			if (bt656->line != 0 && (!!firstfield !=
> +						 ((buf[2] & CXUSB_FIELD_MASK)
> +						  == CXUSB_FIELD_1))) {
> +				if (bt656->fmode == LINE_SAMPLES) {
> +					cxusb_vprintk(dvbdev, BT656,
> +						      "field %c after line %u field change\n",
> +						      firstfield ? '1' : '2',
> +						      bt656->line);
> +
> +					if (bt656->buf != NULL &&
> +						maxlinesamples -
> +						bt656->linesamples > 0) {
> +
> +						memset(bt656->buf, 0,
> +							maxlinesamples -
> +							bt656->linesamples);
> +
> +						bt656->buf +=
> +							maxlinesamples -
> +							bt656->linesamples;
> +
> +						cxusb_vprintk(dvbdev, BT656,
> +							      "field %c line %u %u samples still remaining (of %u)\n",
> +							      firstfield ?
> +							      '1' : '2',
> +							      bt656->line,
> +							      maxlinesamples -
> +							      bt656->
> +							      linesamples,
> +							      maxlinesamples);
> +					}
> +
> +					bt656->line++;
> +				}
> +
> +				if (maxlines - bt656->line > 0 &&
> +					bt656->buf != NULL) {
> +					memset(bt656->buf, 0,
> +						(maxlines - bt656->line)
> +						* maxlinesamples);
> +
> +					bt656->buf +=
> +						(maxlines - bt656->line)
> +						* maxlinesamples;
> +
> +					cxusb_vprintk(dvbdev, BT656,
> +						      "field %c %u lines still remaining (of %u)\n",
> +						      firstfield ? '1' : '2',
> +						      maxlines - bt656->line,
> +						      maxlines);
> +				}
> +
> +				return true;
> +			}
> +
> +			if (bt656->fmode == START_SEARCH) {
> +				if ((buf[2] & CXUSB_SEAV_MASK) ==
> +				    CXUSB_SEAV_SAV &&
> +				    (!!firstfield == ((buf[2] &
> +						       CXUSB_FIELD_MASK)
> +						      == CXUSB_FIELD_1))) {
> +
> +					if ((buf[2] & CXUSB_VBI_MASK) ==
> +					    CXUSB_VBI_OFF) {
> +						cxusb_vprintk(dvbdev,
> +							      BT656,
> +							      "line start @ pos %x\n",
> +							      bt656->pos);
> +
> +						bt656->linesamples = 0;
> +						bt656->fmode = LINE_SAMPLES;
> +					} else {
> +						cxusb_vprintk(dvbdev,
> +							      BT656,
> +							      "VBI start @ pos %x\n",
> +							      bt656->pos);
> +
> +						bt656->fmode = VBI_SAMPLES;
> +					}
> +				}
> +
> +				bt656->pos =
> +					cxusb_auxbuf_advance(auxbuf,
> +							     bt656->pos, 4);
> +				continue;
> +			} else if (bt656->fmode == LINE_SAMPLES) {
> +				if ((buf[2] & CXUSB_SEAV_MASK) ==
> +				    CXUSB_SEAV_SAV)
> +					cxusb_vprintk(dvbdev, BT656,
> +						      "SAV in line samples @ line %u, pos %x\n",
> +						      bt656->line, bt656->pos);
> +
> +				if (bt656->buf != NULL && maxlinesamples -
> +				    bt656->linesamples > 0) {
> +
> +					memset(bt656->buf, 0,
> +					       maxlinesamples -
> +					       bt656->linesamples);
> +					bt656->buf += maxlinesamples -
> +						bt656->linesamples;
> +
> +					cxusb_vprintk(dvbdev, BT656,
> +						      "field %c line %u %u samples still remaining (of %u)\n",
> +						      firstfield ? '1' : '2',
> +						      bt656->line,
> +						      maxlinesamples -
> +						      bt656->linesamples,
> +						      maxlinesamples);
> +				}
> +
> +
> +				bt656->fmode = START_SEARCH;
> +				bt656->line++;
> +				continue;
> +			} else if (bt656->fmode == VBI_SAMPLES) {
> +				if ((buf[2] & CXUSB_SEAV_MASK) ==
> +				    CXUSB_SEAV_SAV)
> +					cxusb_vprintk(dvbdev, BT656,
> +						      "SAV in VBI samples @ pos %x\n",
> +						      bt656->pos);
> +
> +				bt656->fmode = START_SEARCH;
> +				continue;
> +			}
> +
> +			bt656->pos =
> +				cxusb_auxbuf_advance(auxbuf, bt656->pos, 4);
> +			continue;
> +		}
> +
> +normal_sample:
> +		if (bt656->fmode == START_SEARCH && bt656->line != 0) {
> +			unsigned char buf[64];
> +			unsigned int idx;
> +			unsigned int tocheck = min(sizeof(buf),
> +						   max(sizeof(buf),
> +						       maxlinesamples / 4));
> +
> +			if (!cxusb_auxbuf_copy(auxbuf, bt656->pos + 1,
> +					       buf, tocheck)) {
> +				bt656->pos =
> +					cxusb_auxbuf_advance(auxbuf,
> +							     bt656->pos, 1);
> +				continue;
> +			}
> +
> +			for (idx = 0; idx <= tocheck - 3; idx++)
> +				if (memcmp(buf + idx, CXUSB_BT656_COMMON, 3)
> +				    == 0)
> +					break;
> +
> +			if (idx <= tocheck - 3) {
> +				bt656->pos =
> +					cxusb_auxbuf_advance(auxbuf,
> +							     bt656->pos, 1);
> +				continue;
> +			}
> +
> +			cxusb_vprintk(dvbdev, BT656,
> +				      "line %u early start, pos %x\n",
> +				      bt656->line, bt656->pos);
> +
> +			bt656->linesamples = 0;
> +			bt656->fmode = LINE_SAMPLES;
> +			continue;
> +		} else if (bt656->fmode == LINE_SAMPLES) {
> +			if (bt656->buf != NULL)
> +				*(bt656->buf++) = val;
> +
> +			bt656->linesamples++;
> +			bt656->pos =
> +				cxusb_auxbuf_advance(auxbuf,
> +						     bt656->pos, 1);
> +
> +			if (bt656->linesamples >= maxlinesamples) {
> +				bt656->fmode = START_SEARCH;
> +				bt656->line++;
> +			}
> +
> +			continue;
> +		}
> +		/* TODO: copy VBI samples */
> +
> +		bt656->pos =
> +			cxusb_auxbuf_advance(auxbuf,
> +					     bt656->pos, 1);
> +	}
> +
> +	if (bt656->line < maxlines) {
> +		cxusb_vprintk(dvbdev, BT656, "end of buffer, pos = %u\n",
> +			      bt656->pos);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void cxusb_medion_v_complete_work(struct work_struct *work)
> +{
> +	struct cxusb_medion_dev *cxdev = container_of(work,
> +						      struct cxusb_medion_dev,
> +						      urbwork);
> +	struct dvb_usb_device *dvbdev = cxdev->dvbdev;
> +	struct urb *urb;
> +	int ret;
> +	unsigned int i, urbn;
> +
> +	mutex_lock(cxdev->videodev->lock);
> +
> +	cxusb_vprintk(dvbdev, URB, "worker called, streaming = %d\n",
> +		      (int)cxdev->streaming);
> +
> +	if (!cxdev->streaming)
> +		goto unlock;
> +
> +	urbn = cxdev->nexturb;
> +	if (test_bit(urbn, &cxdev->urbcomplete)) {
> +		urb = cxdev->streamurbs[urbn];
> +		clear_bit(urbn, &cxdev->urbcomplete);
> +
> +		cxdev->nexturb++;
> +		cxdev->nexturb %= CXUSB_VIDEO_URBS;
> +	} else {
> +		for (i = 0, urbn++; i < CXUSB_VIDEO_URBS - 1; i++, urbn++) {
> +			urbn %= CXUSB_VIDEO_URBS;
> +			if (test_bit(urbn, &cxdev->urbcomplete)) {
> +				urb = cxdev->streamurbs[urbn];
> +				clear_bit(urbn, &cxdev->urbcomplete);
> +				break;
> +			}
> +		}
> +
> +		if (i >= CXUSB_VIDEO_URBS - 1) {
> +			cxusb_vprintk(dvbdev, URB,
> +				      "URB worker called but no URB ready\n");
> +			goto unlock;
> +		}
> +
> +		cxusb_vprintk(dvbdev, URB,
> +			      "out-of-order URB: expected %u but %u is ready\n",
> +			      cxdev->nexturb, urbn);
> +
> +		cxdev->nexturb = urbn + 1;
> +		cxdev->nexturb %= CXUSB_VIDEO_URBS;
> +	}
> +
> +	cxusb_vprintk(dvbdev, URB, "URB %u status = %d\n", urbn, urb->status);
> +
> +	if (urb->status == 0 || urb->status == -EXDEV) {
> +		int i;
> +		unsigned long len = 0;
> +
> +		for (i = 0; i < urb->number_of_packets; i++)
> +			len += urb->iso_frame_desc[i].actual_length;
> +
> +		cxusb_vprintk(dvbdev, URB, "URB %u data len = %lu\n",
> +			      urbn, len);
> +
> +		if (len == 0)
> +			goto resubmit;
> +
> +		if (cxdev->raw_mode) {
> +			u8 *buf;
> +			struct cxusb_medion_vbuffer *vbuf;
> +
> +			if (list_empty(&cxdev->buflist)) {
> +				dev_warn(&dvbdev->udev->dev,
> +					 "no free buffers\n");
> +
> +				goto resubmit;
> +			}
> +
> +			vbuf = list_first_entry(&cxdev->buflist,
> +						struct cxusb_medion_vbuffer,
> +						list);
> +			list_del(&vbuf->list);
> +
> +			vbuf->vb2.timestamp = ktime_get_ns();
> +
> +			buf = vb2_plane_vaddr(&vbuf->vb2, 0);
> +
> +			for (i = 0; i < urb->number_of_packets; i++) {
> +				memcpy(buf, urb->transfer_buffer +
> +				       urb->iso_frame_desc[i].offset,
> +				       urb->iso_frame_desc[i].actual_length);
> +
> +				buf += urb->iso_frame_desc[i].actual_length;
> +			}
> +
> +			vb2_set_plane_payload(&vbuf->vb2, 0, len);
> +
> +			vb2_buffer_done(&vbuf->vb2, VB2_BUF_STATE_DONE);
> +		} else {
> +			struct cxusb_bt656_params *bt656 = &cxdev->bt656;
> +			bool reset;
> +
> +			cxusb_vprintk(dvbdev, URB, "appending urb\n");
> +
> +			/*
> +			 * append new data to circ. buffer
> +			 * overwrite old data if necessary
> +			 */
> +			reset = !cxusb_auxbuf_append_urb(dvbdev,
> +							 &cxdev->auxbuf, urb,
> +							 len);
> +
> +			/*
> +			 * if this is a new frame
> +			 * fetch a buffer from list
> +			 */
> +			if (bt656->mode == NEW_FRAME) {
> +				if (!list_empty(&cxdev->buflist)) {
> +					cxdev->vbuf = list_first_entry(
> +						&cxdev->buflist,
> +						struct cxusb_medion_vbuffer,
> +						list);
> +					list_del(&cxdev->vbuf->list);
> +
> +					cxdev->vbuf->vb2.timestamp =
> +						ktime_get_ns();
> +				} else
> +					dev_warn(&dvbdev->udev->dev,
> +						 "no free buffers\n");
> +			}
> +
> +			if (bt656->mode == NEW_FRAME || reset) {
> +				bt656->pos =
> +					cxusb_auxbuf_begin(&cxdev->auxbuf);
> +				bt656->mode = FIRST_FIELD;
> +				bt656->fmode = START_SEARCH;
> +				bt656->line = 0;
> +
> +				if (cxdev->vbuf != NULL)
> +					bt656->buf = vb2_plane_vaddr(
> +						&cxdev->vbuf->vb2, 0);
> +			}
> +
> +			cxusb_vprintk(dvbdev, URB, "auxbuf payload len %u",
> +				      cxusb_auxbuf_paylen(&cxdev->auxbuf));
> +
> +			if (bt656->mode == FIRST_FIELD) {
> +				cxusb_vprintk(dvbdev, URB,
> +					      "copying field 1\n");
> +
> +				if (!cxusb_medion_copy_field(
> +					    dvbdev, &cxdev->auxbuf,
> +					    bt656, true,
> +					    cxdev->height / 2,
> +					    cxdev->width * 2))
> +					goto resubmit;
> +
> +
> +				/*
> +				 * do not trim buffer there in case
> +				 * we need to reset search later
> +				 */
> +
> +				bt656->mode = SECOND_FIELD;
> +				bt656->fmode = START_SEARCH;
> +				bt656->line = 0;
> +			}
> +
> +			if (bt656->mode == SECOND_FIELD) {
> +				cxusb_vprintk(dvbdev, URB,
> +					"copying field 2\n");
> +
> +				if (!cxusb_medion_copy_field(
> +						dvbdev, &cxdev->auxbuf,
> +						bt656, false,
> +						cxdev->height / 2,
> +						cxdev->width * 2))
> +					goto resubmit;
> +
> +				cxusb_auxbuf_head_trim(dvbdev,
> +						       &cxdev->auxbuf,
> +						       bt656->pos);
> +
> +				bt656->mode = NEW_FRAME;
> +
> +				if (cxdev->vbuf != NULL) {
> +					vb2_set_plane_payload(
> +						&cxdev->vbuf->vb2, 0,
> +						cxdev->width *
> +						cxdev->height * 2);
> +
> +					vb2_buffer_done(&cxdev->vbuf->vb2,
> +							VB2_BUF_STATE_DONE);
> +
> +					cxdev->vbuf = NULL;
> +					cxdev->bt656.buf = NULL;
> +
> +					cxusb_vprintk(dvbdev, URB,
> +						      "frame done\n");
> +				} else
> +					cxusb_vprintk(dvbdev, URB,
> +						      "frame skipped\n");
> +			}
> +		}
> +	}
> +
> +resubmit:
> +	cxusb_vprintk(dvbdev, URB, "URB %u submit\n", urbn);
> +
> +	ret = usb_submit_urb(urb, GFP_KERNEL);
> +	if (ret != 0)
> +		dev_err(&dvbdev->udev->dev,
> +			"unable to submit URB (%d), you'll have to restart streaming\n",
> +			ret);
> +
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
> +		if (test_bit(i, &cxdev->urbcomplete)) {
> +			schedule_work(&cxdev->urbwork);
> +			break;
> +		}
> +
> +unlock:
> +	mutex_unlock(cxdev->videodev->lock);
> +}
> +
> +static void cxusb_medion_v_complete(struct urb *u)
> +{
> +	struct dvb_usb_device *dvbdev = u->context;
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	unsigned int i;
> +
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
> +		if (cxdev->streamurbs[i] == u)
> +			break;
> +
> +	if (i >= CXUSB_VIDEO_URBS) {
> +		dev_err(&dvbdev->udev->dev,
> +			"complete on unknown URB\n");
> +		return;
> +	}
> +
> +	cxusb_vprintk(dvbdev, URB, "URB %d complete\n", i);
> +
> +	set_bit(i, &cxdev->urbcomplete);
> +	schedule_work(&cxdev->urbwork);
> +}
> +
> +static bool cxusb_medion_stream_busy(struct cxusb_medion_dev *cxdev)
> +{
> +	int i;
> +
> +	if (cxdev->streaming)
> +		return true;
> +
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
> +		/*
> +		 * not streaming but URB is still active -
> +		 * stream is being stopped
> +		 */
> +		if (cxdev->streamurbs[i] != NULL)
> +			return true;
> +
> +	return false;
> +}
> +
> +static void cxusb_medion_return_buffers(struct cxusb_medion_dev *cxdev,
> +					bool requeue)
> +{
> +	struct cxusb_medion_vbuffer *vbuf, *vbuf_tmp;
> +
> +	list_for_each_entry_safe(vbuf, vbuf_tmp, &cxdev->buflist,
> +				 list) {
> +		list_del(&vbuf->list);
> +		vb2_buffer_done(&vbuf->vb2, requeue ? VB2_BUF_STATE_QUEUED :
> +				VB2_BUF_STATE_ERROR);
> +	}
> +
> +	if (cxdev->vbuf != NULL) {
> +		vb2_buffer_done(&cxdev->vbuf->vb2, requeue ?
> +				VB2_BUF_STATE_QUEUED :
> +				VB2_BUF_STATE_ERROR);
> +
> +		cxdev->vbuf = NULL;
> +		cxdev->bt656.buf = NULL;
> +	}
> +}
> +
> +static int cxusb_medion_v_start_streaming(struct vb2_queue *q,
> +					  unsigned int count)
> +{
> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	u8 streamon_params[2] = { 0x03, 0x00 };
> +	int npackets, i;
> +	int ret;
> +
> +	cxusb_vprintk(dvbdev, OPS, "should start streaming\n");
> +
> +	/* already streaming */
> +	if (cxdev->streaming)
> +		return 0;
> +
> +	if (cxusb_medion_stream_busy(cxdev)) {
> +		ret = -EBUSY;
> +		goto ret_retbufs;
> +	}
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, video, s_stream, 1);
> +	if (ret != 0) {
> +		dev_err(&dvbdev->udev->dev,
> +			"unable to start stream (%d)\n", ret);
> +		goto ret_retbufs;
> +	}
> +
> +	ret = cxusb_ctrl_msg(dvbdev, CMD_STREAMING_ON, streamon_params, 2,
> +			     NULL, 0);
> +	if (ret != 0) {
> +		dev_err(&dvbdev->udev->dev,
> +			"unable to start streaming (%d)\n", ret);
> +		goto ret_unstream_cx;
> +	}
> +
> +	if (cxdev->raw_mode)
> +		npackets = CXUSB_VIDEO_MAX_FRAME_PKTS;
> +	else {
> +		u8 *buf;
> +		unsigned int urblen, auxbuflen;
> +
> +		/* has to be less than full frame size */
> +		urblen = (cxdev->width * 2 + 4 + 4) * cxdev->height;
> +		npackets = urblen / CXUSB_VIDEO_PKT_SIZE;
> +		urblen = npackets * CXUSB_VIDEO_PKT_SIZE;
> +
> +		auxbuflen = (cxdev->width * 2 + 4 + 4) *
> +			(cxdev->height + 50 /* VBI lines */) + urblen;
> +
> +		buf = vmalloc(auxbuflen);
> +		if (buf == NULL) {
> +			dev_err(&dvbdev->udev->dev,
> +				"cannot allocate auxiliary buffer of %u bytes\n",
> +				auxbuflen);
> +			ret = -ENOMEM;
> +			goto ret_unstream_md;
> +		}
> +
> +		cxusb_auxbuf_init(&cxdev->auxbuf, buf, auxbuflen);
> +	}
> +
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++) {
> +		int framen;
> +		u8 *streambuf;
> +		struct urb *surb;
> +
> +		streambuf = kmalloc(npackets * CXUSB_VIDEO_PKT_SIZE,
> +				    GFP_KERNEL);
> +		if (streambuf == NULL) {
> +			if (i == 0) {
> +				dev_err(&dvbdev->udev->dev,
> +					"cannot allocate stream buffer\n");
> +				ret = -ENOMEM;
> +				goto ret_freeab;
> +			} else
> +				break;
> +		}
> +
> +		surb = usb_alloc_urb(npackets, GFP_KERNEL);
> +		if (surb == NULL) {
> +			dev_err(&dvbdev->udev->dev,
> +				"cannot allocate URB %d\n", i);
> +
> +			kfree(streambuf);
> +			ret = -ENOMEM;
> +			goto ret_freeu;
> +		}
> +
> +		cxdev->streamurbs[i] = surb;
> +		surb->dev = dvbdev->udev;
> +		surb->context = dvbdev;
> +		surb->pipe = usb_rcvisocpipe(dvbdev->udev, 2);
> +
> +		surb->interval = 1;
> +		surb->transfer_flags = URB_ISO_ASAP;
> +
> +		surb->transfer_buffer = streambuf;
> +
> +		surb->complete = cxusb_medion_v_complete;
> +		surb->number_of_packets = npackets;
> +		surb->transfer_buffer_length = npackets * CXUSB_VIDEO_PKT_SIZE;
> +
> +		for (framen = 0; framen < npackets; framen++) {
> +			surb->iso_frame_desc[framen].offset =
> +				CXUSB_VIDEO_PKT_SIZE * framen;
> +
> +			surb->iso_frame_desc[framen].length =
> +				CXUSB_VIDEO_PKT_SIZE;
> +		}
> +	}
> +
> +	cxdev->urbcomplete = 0;
> +	cxdev->nexturb = 0;
> +	cxdev->vbuf = NULL;
> +	cxdev->bt656.mode = NEW_FRAME;
> +	cxdev->bt656.buf = NULL;
> +
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
> +		if (cxdev->streamurbs[i] != NULL) {
> +			ret = usb_submit_urb(cxdev->streamurbs[i],
> +					GFP_KERNEL);
> +			if (ret != 0)
> +				dev_err(&dvbdev->udev->dev,
> +					"URB %d submission failed (%d)\n", i,
> +					ret);
> +		}
> +
> +	cxdev->streaming = true;
> +
> +	return 0;
> +
> +ret_freeu:
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
> +		if (cxdev->streamurbs[i] != NULL) {
> +			kfree(cxdev->streamurbs[i]->transfer_buffer);
> +			usb_free_urb(cxdev->streamurbs[i]);
> +			cxdev->streamurbs[i] = NULL;
> +		}
> +
> +ret_freeab:
> +	if (!cxdev->raw_mode)
> +		vfree(cxdev->auxbuf.buf);
> +
> +ret_unstream_md:
> +	cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
> +
> +ret_unstream_cx:
> +	v4l2_subdev_call(cxdev->cx25840, video, s_stream, 0);
> +
> +ret_retbufs:
> +	cxusb_medion_return_buffers(cxdev, true);
> +
> +	return ret;
> +}
> +
> +static void cxusb_medion_v_stop_streaming(struct vb2_queue *q)
> +{
> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int i, ret;
> +
> +	cxusb_vprintk(dvbdev, OPS, "should stop streaming\n");
> +
> +	if (!cxdev->streaming)
> +		return;
> +
> +	cxdev->streaming = false;
> +
> +	cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, video, s_stream, 0);
> +	if (ret != 0)
> +		dev_err(&dvbdev->udev->dev, "unable to stop stream (%d)\n",
> +			ret);
> +
> +	/* let URB completion run */
> +	mutex_unlock(cxdev->videodev->lock);
> +
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
> +		if (cxdev->streamurbs[i] != NULL)
> +			usb_kill_urb(cxdev->streamurbs[i]);
> +
> +	flush_work(&cxdev->urbwork);
> +
> +	mutex_lock(cxdev->videodev->lock);
> +
> +	/* free transfer buffer and URB */
> +	if (!cxdev->raw_mode)
> +		vfree(cxdev->auxbuf.buf);
> +
> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
> +		if (cxdev->streamurbs[i] != NULL) {
> +			kfree(cxdev->streamurbs[i]->transfer_buffer);
> +			usb_free_urb(cxdev->streamurbs[i]);
> +			cxdev->streamurbs[i] = NULL;
> +		}
> +
> +	cxusb_medion_return_buffers(cxdev, false);
> +}
> +
> +static void cxusub_medion_v_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct cxusb_medion_vbuffer *vbuf =
> +		container_of(vb, struct cxusb_medion_vbuffer, vb2);
> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	/* cxusb_vprintk(dvbdev, OPS, "mmmm.. fresh buffer...\n"); */
> +
> +	list_add_tail(&vbuf->list, &cxdev->buflist);
> +}
> +
> +static void cxusub_medion_v_wait_prepare(struct vb2_queue *q)
> +{
> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	mutex_unlock(cxdev->videodev->lock);
> +}
> +
> +static void cxusub_medion_v_wait_finish(struct vb2_queue *q)
> +{
> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	mutex_lock(cxdev->videodev->lock);
> +}
> +
> +static const struct vb2_ops cxdev_video_qops = {
> +	.queue_setup = cxusb_medion_v_queue_setup,
> +	.buf_init = cxusb_medion_v_buf_init,
> +	.start_streaming = cxusb_medion_v_start_streaming,
> +	.stop_streaming = cxusb_medion_v_stop_streaming,
> +	.buf_queue = cxusub_medion_v_buf_queue,
> +	.wait_prepare = cxusub_medion_v_wait_prepare,
> +	.wait_finish = cxusub_medion_v_wait_finish
> +};
> +
> +static int cxusb_medion_v_querycap(struct file *file, void *fh,
> +				   struct v4l2_capability *cap)
> +{
> +	const __u32 videocaps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
> +		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
> +	const __u32 radiocaps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct video_device *vdev = video_devdata(file);
> +
> +	strncpy(cap->driver, dvbdev->udev->dev.driver->name,
> +		sizeof(cap->driver) - 1);
> +	strcpy(cap->card, "Medion 95700");
> +	usb_make_path(dvbdev->udev, cap->bus_info, sizeof(cap->bus_info));
> +
> +	if (vdev->vfl_type == VFL_TYPE_GRABBER)
> +		cap->device_caps = videocaps;
> +	else
> +		cap->device_caps = radiocaps;
> +
> +	cap->capabilities = videocaps | radiocaps | V4L2_CAP_DEVICE_CAPS;
> +
> +	memset(cap->reserved, 0, sizeof(cap->reserved));
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_v_enum_fmt_vid_cap(struct file *file, void *fh,
> +					   struct v4l2_fmtdesc *f)
> +{
> +	if (f->index != 0)
> +		return -EINVAL;
> +
> +	f->flags = 0;
> +	strcpy(f->description, "YUV 4:2:2");
> +	f->pixelformat = V4L2_PIX_FMT_UYVY;
> +	memset(f->reserved, 0, sizeof(f->reserved));
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_g_fmt_vid_cap(struct file *file, void *fh,
> +				      struct v4l2_format *f)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	f->fmt.pix.width = cxdev->width;
> +	f->fmt.pix.height = cxdev->height;
> +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
> +	f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
> +	f->fmt.pix.bytesperline = cxdev->raw_mode ? 0 : cxdev->width * 2;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	f->fmt.pix.sizeimage =
> +		cxdev->raw_mode ? CXUSB_VIDEO_MAX_FRAME_SIZE :
> +		f->fmt.pix.bytesperline * f->fmt.pix.height;
> +	f->fmt.pix.priv = 0;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_g_parm(struct file *file, void *fh,
> +			       struct v4l2_streamparm *param)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	memset(&param->parm.capture, 0, sizeof(param->parm.capture));
> +
> +	if (cxdev->raw_mode)
> +		param->parm.capture.extendedmode |=
> +			CXUSB_EXTENDEDMODE_CAPTURE_RAW;
> +
> +	param->parm.capture.readbuffers = 1;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_s_parm(struct file *file, void *fh,
> +			       struct v4l2_streamparm *param)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	bool want_raw;
> +
> +	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	want_raw = param->parm.capture.extendedmode &
> +		CXUSB_EXTENDEDMODE_CAPTURE_RAW;
> +
> +	if (want_raw != cxdev->raw_mode) {
> +		if (cxusb_medion_stream_busy(cxdev) ||
> +		    vb2_is_busy(&cxdev->videoqueue))
> +			return -EBUSY;
> +
> +		cxdev->raw_mode = want_raw;
> +	}
> +
> +	param->parm.capture.readbuffers = 1;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_try_s_fmt_vid_cap(struct file *file,
> +					  struct v4l2_format *f,
> +					  bool isset)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	struct v4l2_subdev_format subfmt;
> +	int ret;
> +
> +	if (isset && (cxusb_medion_stream_busy(cxdev) ||
> +		      vb2_is_busy(&cxdev->videoqueue)))
> +		return -EBUSY;
> +
> +	memset(&subfmt, 0, sizeof(subfmt));
> +	subfmt.which = isset ? V4L2_SUBDEV_FORMAT_ACTIVE :
> +		V4L2_SUBDEV_FORMAT_TRY;
> +	subfmt.format.width = f->fmt.pix.width & ~1;
> +	subfmt.format.height = f->fmt.pix.height & ~1;
> +	subfmt.format.code = MEDIA_BUS_FMT_FIXED;
> +	subfmt.format.field = V4L2_FIELD_SEQ_TB;
> +	subfmt.format.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt, NULL, &subfmt);
> +	if (ret != 0) {
> +		if (ret != -ERANGE)
> +			return ret;
> +
> +		/* try some common formats */
> +		subfmt.format.width = 720;
> +		subfmt.format.height = 576;
> +		ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt, NULL,
> +				       &subfmt);
> +		if (ret != 0) {
> +			if (ret != -ERANGE)
> +				return ret;
> +
> +			subfmt.format.width = 640;
> +			subfmt.format.height = 480;
> +			ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt,
> +					       NULL, &subfmt);
> +			if (ret != 0)
> +				return ret;
> +		}
> +	}
> +
> +	f->fmt.pix.width = subfmt.format.width;
> +	f->fmt.pix.height = subfmt.format.height;
> +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
> +	f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
> +	f->fmt.pix.bytesperline = cxdev->raw_mode ? 0 : f->fmt.pix.width * 2;
> +	f->fmt.pix.sizeimage =
> +		cxdev->raw_mode ? CXUSB_VIDEO_MAX_FRAME_SIZE :
> +		f->fmt.pix.bytesperline * f->fmt.pix.height;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	f->fmt.pix.priv = 0;
> +
> +	if (isset) {
> +		cxdev->width = f->fmt.pix.width;
> +		cxdev->height = f->fmt.pix.height;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_try_fmt_vid_cap(struct file *file, void *fh,
> +					struct v4l2_format *f)
> +{
> +	return cxusb_medion_try_s_fmt_vid_cap(file, f, false);
> +}
> +
> +static int cxusb_medion_s_fmt_vid_cap(struct file *file, void *fh,
> +				      struct v4l2_format *f)
> +{
> +	return cxusb_medion_try_s_fmt_vid_cap(file, f, true);
> +}
> +
> +static const struct {
> +	struct v4l2_input input;
> +	u32 inputcfg;
> +} cxusb_medion_inputs[] = {
> +	{ .input = { .name = "TV tuner", .type = V4L2_INPUT_TYPE_TUNER,
> +		     .tuner = 0, .std = V4L2_STD_PAL },
> +	  .inputcfg = CX25840_COMPOSITE2, },
> +
> +	{  .input = { .name = "Composite", .type = V4L2_INPUT_TYPE_CAMERA,
> +		     .std = V4L2_STD_ALL },
> +	   .inputcfg = CX25840_COMPOSITE1, },
> +
> +	{  .input = { .name = "S-Video", .type = V4L2_INPUT_TYPE_CAMERA,
> +		      .std = V4L2_STD_ALL },
> +	   .inputcfg = CX25840_SVIDEO_LUMA3 | CX25840_SVIDEO_CHROMA4 }
> +};
> +
> +#define CXUSB_INPUT_CNT ARRAY_SIZE(cxusb_medion_inputs)
> +
> +static int cxusb_medion_enum_input(struct file *file, void *fh,
> +				   struct v4l2_input *inp)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	u32 index = inp->index;
> +
> +	if (index >= CXUSB_INPUT_CNT)
> +		return -EINVAL;
> +
> +	*inp = cxusb_medion_inputs[index].input;
> +	inp->index = index;
> +	inp->capabilities |= V4L2_IN_CAP_STD;
> +
> +	if (index == cxdev->input) {
> +		int ret;
> +		u32 status = 0;
> +
> +		ret = v4l2_subdev_call(cxdev->cx25840, video, g_input_status,
> +				       &status);
> +		if (ret != 0)
> +			dev_warn(&dvbdev->udev->dev,
> +				 "cx25840 input status query failed (%d)\n",
> +				 ret);
> +		else
> +			inp->status = status;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_g_input(struct file *file, void *fh,
> +				unsigned int *i)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	*i = cxdev->input;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_s_input(struct file *file, void *fh,
> +				unsigned int i)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int ret;
> +
> +	if (i >= CXUSB_INPUT_CNT)
> +		return -EINVAL;
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, video, s_routing,
> +			       cxusb_medion_inputs[i].inputcfg, 0, 0);
> +	if (ret != 0)
> +		return ret;
> +
> +	cxdev->input = i;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_g_tuner(struct file *file, void *fh,
> +				struct v4l2_tuner *tuner)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	struct video_device *vdev = video_devdata(file);
> +	int ret;
> +
> +	if (tuner->index != 0)
> +		return -EINVAL;
> +
> +	if (vdev->vfl_type == VFL_TYPE_GRABBER)
> +		tuner->type = V4L2_TUNER_ANALOG_TV;
> +	else
> +		tuner->type = V4L2_TUNER_RADIO;
> +
> +	tuner->capability = 0;
> +	tuner->afc = 0;
> +
> +	/*
> +	 * fills:
> +	 * always: capability (static), rangelow (static), rangehigh (static)
> +	 * radio mode: afc (may fail silently), rxsubchans (static), audmode
> +	 */
> +	ret = v4l2_subdev_call(cxdev->tda9887, tuner, g_tuner, tuner);
> +	if (ret != 0)
> +		return ret;
> +
> +	/*
> +	 * fills:
> +	 * always: capability (static), rangelow (static), rangehigh (static)
> +	 * radio mode: rxsubchans (always stereo), audmode,
> +	 * signal (might be wrong)
> +	 */
> +	ret = v4l2_subdev_call(cxdev->tuner, tuner, g_tuner, tuner);
> +	if (ret != 0)
> +		return ret;
> +
> +	tuner->signal = 0;
> +
> +	/*
> +	 * fills: TV mode: capability, rxsubchans, audmode, signal
> +	 */
> +	ret = v4l2_subdev_call(cxdev->cx25840, tuner, g_tuner, tuner);
> +	if (ret != 0)
> +		return ret;
> +
> +	if (vdev->vfl_type == VFL_TYPE_GRABBER)
> +		strcpy(tuner->name, "TV tuner");
> +	else
> +		strcpy(tuner->name, "Radio tuner");
> +
> +	memset(tuner->reserved, 0, sizeof(tuner->reserved));
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_s_tuner(struct file *file, void *fh,
> +				const struct v4l2_tuner *tuner)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	struct video_device *vdev = video_devdata(file);
> +	int ret;
> +
> +	if (tuner->index != 0)
> +		return -EINVAL;
> +
> +	ret = v4l2_subdev_call(cxdev->tda9887, tuner, s_tuner, tuner);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = v4l2_subdev_call(cxdev->tuner, tuner, s_tuner, tuner);
> +	if (ret != 0)
> +		return ret;
> +
> +	/*
> +	 * make sure that cx25840 is in a correct TV / radio mode,
> +	 * since calls above may have changed it for tuner / IF demod
> +	 */
> +	if (vdev->vfl_type == VFL_TYPE_GRABBER)
> +		v4l2_subdev_call(cxdev->cx25840, video, s_std, cxdev->norm);
> +	else
> +		v4l2_subdev_call(cxdev->cx25840, tuner, s_radio);
> +
> +	return v4l2_subdev_call(cxdev->cx25840, tuner, s_tuner, tuner);
> +}
> +
> +static int cxusb_medion_g_frequency(struct file *file, void *fh,
> +				    struct v4l2_frequency *freq)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	if (freq->tuner != 0)
> +		return -EINVAL;
> +
> +	return v4l2_subdev_call(cxdev->tuner, tuner, g_frequency, freq);
> +}
> +
> +static int cxusb_medion_s_frequency(struct file *file, void *fh,
> +				    const struct v4l2_frequency *freq)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	struct video_device *vdev = video_devdata(file);
> +	int ret;
> +
> +	if (freq->tuner != 0)
> +		return -EINVAL;
> +
> +	ret = v4l2_subdev_call(cxdev->tda9887, tuner, s_frequency, freq);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = v4l2_subdev_call(cxdev->tuner, tuner, s_frequency, freq);
> +	if (ret != 0)
> +		return ret;
> +
> +	/*
> +	 * make sure that cx25840 is in a correct TV / radio mode,
> +	 * since calls above may have changed it for tuner / IF demod
> +	 */
> +	if (vdev->vfl_type == VFL_TYPE_GRABBER)
> +		v4l2_subdev_call(cxdev->cx25840, video, s_std, cxdev->norm);
> +	else
> +		v4l2_subdev_call(cxdev->cx25840, tuner, s_radio);
> +
> +	return v4l2_subdev_call(cxdev->cx25840, tuner, s_frequency, freq);
> +}
> +
> +static int cxusb_medion_g_std(struct file *file, void *fh,
> +			      v4l2_std_id *norm)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int ret;
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, video, g_std, norm);
> +	if (ret != 0) {
> +		cxusb_vprintk(dvbdev, OPS, "cannot get standard for input %u\n",
> +			      (unsigned int)cxdev->input);
> +
> +		return ret;
> +	}
> +
> +	cxusb_vprintk(dvbdev, OPS,
> +		      "current standard for input %u is %lx\n",
> +		      (unsigned int)cxdev->input,
> +		      (unsigned long)*norm);
> +
> +	if (cxdev->input == 0)
> +		/*
> +		 * make sure we don't have improper std bits set
> +		 * for TV tuner (could happen when no signal was
> +		 * present yet after reset)
> +		 */
> +		*norm &= V4L2_STD_PAL;
> +
> +	if (*norm == V4L2_STD_UNKNOWN)
> +		return -ENODATA;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_s_std(struct file *file, void *fh,
> +			      v4l2_std_id norm)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int ret;
> +
> +	cxusb_vprintk(dvbdev, OPS,
> +		      "trying to set standard for input %u to %lx\n",
> +		      (unsigned int)cxdev->input,
> +		      (unsigned long)norm);
> +
> +	/* on composite or S-Video any std is acceptable */
> +	if (cxdev->input != 0) {
> +		ret = v4l2_subdev_call(cxdev->cx25840, video, s_std, norm);
> +		if (ret)
> +			return ret;
> +
> +		goto ret_savenorm;
> +	}
> +
> +	/* TV tuner is only able to demodulate PAL */
> +	if ((norm & ~V4L2_STD_PAL) != 0)
> +		return -EINVAL;
> +
> +	/* no autodetection support */
> +	if (norm == 0)
> +		return -EINVAL;
> +
> +	ret = v4l2_subdev_call(cxdev->tda9887, video, s_std, norm);
> +	if (ret != 0) {
> +		dev_err(&dvbdev->udev->dev,
> +			"tda9887 norm setup failed (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret = v4l2_subdev_call(cxdev->tuner, video, s_std, norm);
> +	if (ret != 0) {
> +		dev_err(&dvbdev->udev->dev,
> +			"tuner norm setup failed (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, video, s_std, norm);
> +	if (ret != 0) {
> +		dev_err(&dvbdev->udev->dev,
> +			"cx25840 norm setup failed (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +ret_savenorm:
> +	cxdev->norm = norm;
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_log_status(struct file *file, void *fh)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	v4l2_device_call_all(&cxdev->v4l2dev, 0, core, log_status);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops cxusb_video_ioctl = {
> +	.vidioc_querycap = cxusb_medion_v_querycap,
> +	.vidioc_enum_fmt_vid_cap = cxusb_medion_v_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap = cxusb_medion_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = cxusb_medion_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap = cxusb_medion_try_fmt_vid_cap,
> +	.vidioc_enum_input = cxusb_medion_enum_input,
> +	.vidioc_g_input = cxusb_medion_g_input,
> +	.vidioc_s_input = cxusb_medion_s_input,
> +	.vidioc_g_parm = cxusb_medion_g_parm,
> +	.vidioc_s_parm = cxusb_medion_s_parm,
> +	.vidioc_g_tuner = cxusb_medion_g_tuner,
> +	.vidioc_s_tuner = cxusb_medion_s_tuner,
> +	.vidioc_g_frequency = cxusb_medion_g_frequency,
> +	.vidioc_s_frequency = cxusb_medion_s_frequency,
> +	.vidioc_g_std = cxusb_medion_g_std,
> +	.vidioc_s_std = cxusb_medion_s_std,
> +	.vidioc_log_status = cxusb_medion_log_status,
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff
> +};
> +
> +static const struct v4l2_ioctl_ops cxusb_radio_ioctl = {
> +	.vidioc_querycap = cxusb_medion_v_querycap,
> +	.vidioc_g_tuner = cxusb_medion_g_tuner,
> +	.vidioc_s_tuner = cxusb_medion_s_tuner,
> +	.vidioc_g_frequency = cxusb_medion_g_frequency,
> +	.vidioc_s_frequency = cxusb_medion_s_frequency,
> +	.vidioc_log_status = cxusb_medion_log_status
> +};
> +
> +/*
> + * in principle, this should be const, but s_io_pin_config is declared
> + * to take non-const, and gcc complains
> + */
> +static struct v4l2_subdev_io_pin_config cxusub_medion_pin_config[] = {
> +	{ .pin = CX25840_PIN_DVALID_PRGM0, .function = CX25840_PAD_DEFAULT,
> +	  .strength = CX25840_PIN_DRIVE_MEDIUM },
> +	{ .pin = CX25840_PIN_PLL_CLK_PRGM7, .function = CX25840_PAD_AUX_PLL },
> +	{ .pin = CX25840_PIN_HRESET_PRGM2, .function = CX25840_PAD_ACTIVE,
> +	  .strength = CX25840_PIN_DRIVE_MEDIUM }
> +};
> +
> +int cxusb_medion_analog_init(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	u8 tuner_analog_msg_data[] = { 0x9c, 0x60, 0x85, 0x54 };
> +	struct i2c_msg tuner_analog_msg = { .addr = 0x61, .flags = 0,
> +					    .buf = tuner_analog_msg_data,
> +					    .len =
> +					    sizeof(tuner_analog_msg_data) };
> +	struct v4l2_subdev_format subfmt;
> +	int ret;
> +
> +	/* switch tuner to analog mode so IF demod will become accessible */
> +	ret = i2c_transfer(&dvbdev->i2c_adap, &tuner_analog_msg, 1);
> +	if (ret != 1)
> +		dev_warn(&dvbdev->udev->dev,
> +			 "tuner analog switch failed (%d)\n", ret);
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, core, load_fw);
> +	if (ret != 0)
> +		dev_warn(&dvbdev->udev->dev,
> +			 "cx25840 fw load failed (%d)\n", ret);
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, video, s_routing,
> +			       CX25840_COMPOSITE1, 0,
> +			       CX25840_VCONFIG_FMT_BT656 |
> +			       CX25840_VCONFIG_RES_8BIT |
> +			       CX25840_VCONFIG_VBIRAW_DISABLED |
> +			       CX25840_VCONFIG_ANCDATA_DISABLED |
> +			       CX25840_VCONFIG_ACTIVE_COMPOSITE |
> +			       CX25840_VCONFIG_VALID_ANDACTIVE |
> +			       CX25840_VCONFIG_HRESETW_NORMAL |
> +			       CX25840_VCONFIG_CLKGATE_NONE |
> +			       CX25840_VCONFIG_DCMODE_DWORDS);
> +	if (ret != 0)
> +		dev_warn(&dvbdev->udev->dev,
> +			 "cx25840 mode set failed (%d)\n", ret);
> +
> +	/* composite */
> +	cxdev->input = 1;
> +	cxdev->norm = 0;
> +
> +	/* TODO: setup audio samples insertion */
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, core, s_io_pin_config,
> +			       sizeof(cxusub_medion_pin_config) /
> +			       sizeof(cxusub_medion_pin_config[0]),
> +			       cxusub_medion_pin_config);
> +	if (ret != 0)
> +		dev_warn(&dvbdev->udev->dev,
> +			"cx25840 pin config failed (%d)\n", ret);
> +
> +	/* make sure that we aren't in radio mode */
> +	v4l2_subdev_call(cxdev->tda9887, video, s_std, V4L2_STD_PAL);
> +	v4l2_subdev_call(cxdev->tuner, video, s_std, V4L2_STD_PAL);
> +	v4l2_subdev_call(cxdev->cx25840, video, s_std, cxdev->norm);
> +
> +	memset(&subfmt, 0, sizeof(subfmt));
> +	subfmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	subfmt.format.width = cxdev->width;
> +	subfmt.format.height = cxdev->height;
> +	subfmt.format.code = MEDIA_BUS_FMT_FIXED;
> +	subfmt.format.field = V4L2_FIELD_SEQ_TB;
> +	subfmt.format.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +	ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt, NULL, &subfmt);
> +	if (ret != 0) {
> +		subfmt.format.width = 640;
> +		subfmt.format.height = 480;
> +		ret = v4l2_subdev_call(cxdev->cx25840, pad, set_fmt, NULL,
> +				       &subfmt);
> +		if (ret != 0)
> +			dev_warn(&dvbdev->udev->dev,
> +				 "cx25840 format set failed (%d)\n", ret);
> +	}
> +
> +	if (ret == 0) {
> +		cxdev->width = subfmt.format.width;
> +		cxdev->height = subfmt.format.height;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cxusb_videoradio_open(struct file *f)
> +{
> +	struct dvb_usb_device *dvbdev = video_drvdata(f);
> +	int ret;
> +
> +	/*
> +	 * no locking needed since this call only modifies analog
> +	 * state if there are no other analog handles currenly
> +	 * opened so ops done via them cannot create a conflict
> +	 */
> +	ret = cxusb_medion_get(dvbdev, CXUSB_OPEN_ANALOG);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = v4l2_fh_open(f);
> +	if (ret != 0)
> +		goto ret_release;
> +
> +	cxusb_vprintk(dvbdev, OPS, "got open\n");
> +
> +	return 0;
> +
> +ret_release:
> +	cxusb_medion_put(dvbdev);
> +
> +	return ret;
> +}
> +
> +static int cxusb_videoradio_release(struct file *f)
> +{
> +	struct video_device *vdev = video_devdata(f);
> +	struct dvb_usb_device *dvbdev = video_drvdata(f);
> +	int ret;
> +
> +	cxusb_vprintk(dvbdev, OPS, "got release\n");
> +
> +	if (vdev->vfl_type == VFL_TYPE_GRABBER)
> +		ret = vb2_fop_release(f);
> +	else
> +		ret = v4l2_fh_release(f);
> +
> +	cxusb_medion_put(dvbdev);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations cxusb_video_fops = {
> +	.owner = THIS_MODULE,
> +	.read = vb2_fop_read,
> +	.poll = vb2_fop_poll,
> +	.unlocked_ioctl = video_ioctl2,
> +	.mmap = vb2_fop_mmap,
> +	.open = cxusb_videoradio_open,
> +	.release = cxusb_videoradio_release
> +};
> +
> +static const struct v4l2_file_operations cxusb_radio_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = video_ioctl2,
> +	.open = cxusb_videoradio_open,
> +	.release = cxusb_videoradio_release
> +};
> +
> +static void cxusb_medion_v4l2_release(struct v4l2_device *v4l2_dev)
> +{
> +	struct cxusb_medion_dev *cxdev =
> +		container_of(v4l2_dev, struct cxusb_medion_dev, v4l2dev);
> +	struct dvb_usb_device *dvbdev = cxdev->dvbdev;
> +
> +	cxusb_vprintk(dvbdev, OPS, "v4l2 device release\n");
> +
> +	v4l2_device_unregister(&cxdev->v4l2dev);
> +
> +	mutex_destroy(&cxdev->dev_lock);
> +
> +	while (completion_done(&cxdev->v4l2_release))
> +		schedule();
> +
> +	complete(&cxdev->v4l2_release);
> +}
> +
> +static void cxusb_medion_videodev_release(struct video_device *vdev)
> +{
> +	struct dvb_usb_device *dvbdev = video_get_drvdata(vdev);
> +
> +	cxusb_vprintk(dvbdev, OPS, "video device release\n");
> +
> +	vb2_queue_release(vdev->queue);
> +
> +	video_device_release(vdev);
> +}
> +
> +static int cxusb_medion_register_analog_video(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int ret;
> +
> +	cxdev->videoqueue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	cxdev->videoqueue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
> +	cxdev->videoqueue.ops = &cxdev_video_qops;
> +	cxdev->videoqueue.mem_ops = &vb2_vmalloc_memops;
> +	cxdev->videoqueue.drv_priv = dvbdev;
> +	cxdev->videoqueue.buf_struct_size =
> +		sizeof(struct cxusb_medion_vbuffer);
> +	cxdev->videoqueue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +
> +	ret = vb2_queue_init(&cxdev->videoqueue);
> +	if (ret) {
> +		dev_err(&dvbdev->udev->dev,
> +			"video queue init failed, ret = %d\n", ret);
> +		return ret;
> +	}
> +
> +	cxdev->videodev = video_device_alloc();
> +	if (cxdev->videodev == NULL) {
> +		dev_err(&dvbdev->udev->dev, "video device alloc failed\n");
> +		ret = -ENOMEM;
> +		goto ret_qrelease;
> +	}
> +
> +	cxdev->videodev->fops = &cxusb_video_fops;
> +	cxdev->videodev->v4l2_dev = &cxdev->v4l2dev;
> +	cxdev->videodev->queue = &cxdev->videoqueue;
> +	strcpy(cxdev->videodev->name, "cxusb");
> +	cxdev->videodev->vfl_dir = VFL_DIR_RX;
> +	cxdev->videodev->ioctl_ops = &cxusb_video_ioctl;
> +	cxdev->videodev->tvnorms = V4L2_STD_ALL;
> +	cxdev->videodev->release = cxusb_medion_videodev_release;
> +	cxdev->videodev->lock = &cxdev->dev_lock;
> +	video_set_drvdata(cxdev->videodev, dvbdev);
> +
> +	ret = video_register_device(cxdev->videodev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(&dvbdev->udev->dev,
> +			"video device register failed, ret = %d\n", ret);
> +		goto ret_vrelease;
> +	}
> +
> +	return 0;
> +
> +ret_vrelease:
> +	video_device_release(cxdev->videodev);
> +
> +ret_qrelease:
> +	vb2_queue_release(&cxdev->videoqueue);
> +
> +	return ret;
> +}
> +
> +static int cxusb_medion_register_analog_radio(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int ret;
> +
> +	cxdev->radiodev = video_device_alloc();
> +	if (cxdev->radiodev == NULL) {
> +		dev_err(&dvbdev->udev->dev, "radio device alloc failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	cxdev->radiodev->fops = &cxusb_radio_fops;
> +	cxdev->radiodev->v4l2_dev = &cxdev->v4l2dev;
> +	strcpy(cxdev->radiodev->name, "cxusb");
> +	cxdev->radiodev->vfl_dir = VFL_DIR_RX;
> +	cxdev->radiodev->ioctl_ops = &cxusb_radio_ioctl;
> +	cxdev->radiodev->release = video_device_release;
> +	cxdev->radiodev->lock = &cxdev->dev_lock;
> +	video_set_drvdata(cxdev->radiodev, dvbdev);
> +
> +	ret = video_register_device(cxdev->radiodev, VFL_TYPE_RADIO, -1);
> +	if (ret) {
> +		dev_err(&dvbdev->udev->dev,
> +			"radio device register failed, ret = %d\n", ret);
> +		video_device_release(cxdev->radiodev);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_register_analog_subdevs(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	struct tuner_setup tun_setup;
> +	struct i2c_board_info cx25840_board;
> +	struct cx25840_platform_data cx25840_platform;
> +
> +	/* attach capture chip */
> +	memset(&cx25840_platform, 0, sizeof(cx25840_platform));
> +	cx25840_platform.generic_mode = 1;
> +
> +	memset(&cx25840_board, 0, sizeof(cx25840_board));
> +	strcpy(cx25840_board.type, "cx25840");
> +	cx25840_board.addr = 0x44;
> +	cx25840_board.platform_data = &cx25840_platform;
> +
> +	cxdev->cx25840 = v4l2_i2c_new_subdev_board(&cxdev->v4l2dev,
> +						   &dvbdev->i2c_adap,
> +						   &cx25840_board, NULL);
> +	if (cxdev->cx25840 == NULL) {
> +		dev_err(&dvbdev->udev->dev, "cx25840 not found\n");
> +		return -ENODEV;
> +	}
> +
> +	/* attach analog tuner */
> +	cxdev->tuner = v4l2_i2c_new_subdev(&cxdev->v4l2dev,
> +					   &dvbdev->i2c_adap,
> +					   "tuner", 0x61, NULL);
> +	if (cxdev->tuner == NULL) {
> +		dev_err(&dvbdev->udev->dev, "tuner not found\n");
> +		return -ENODEV;
> +	}
> +
> +	/* configure it */
> +	memset(&tun_setup, 0, sizeof(tun_setup));
> +	tun_setup.addr = 0x61;
> +	tun_setup.type = TUNER_PHILIPS_FMD1216ME_MK3;
> +	tun_setup.mode_mask = T_RADIO | T_ANALOG_TV;
> +	v4l2_subdev_call(cxdev->tuner, tuner, s_type_addr, &tun_setup);
> +
> +	/* attach IF demod */
> +	cxdev->tda9887 = v4l2_i2c_new_subdev(&cxdev->v4l2dev,
> +					     &dvbdev->i2c_adap,
> +					     "tuner", 0x43, NULL);
> +	if (cxdev->tda9887 == NULL) {
> +		dev_err(&dvbdev->udev->dev, "tda9887 not found\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +int cxusb_medion_register_analog(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int ret;
> +
> +	mutex_init(&cxdev->dev_lock);
> +
> +	init_completion(&cxdev->v4l2_release);
> +
> +	cxdev->v4l2dev.release = cxusb_medion_v4l2_release;
> +
> +	ret = v4l2_device_register(&dvbdev->udev->dev, &cxdev->v4l2dev);
> +	if (ret != 0) {
> +		dev_err(&dvbdev->udev->dev,
> +			"V4L2 device registration failed, ret = %d\n", ret);
> +		mutex_destroy(&cxdev->dev_lock);
> +		return ret;
> +	}
> +
> +	ret = cxusb_medion_register_analog_subdevs(dvbdev);
> +	if (ret)
> +		goto ret_unregister;
> +
> +	INIT_WORK(&cxdev->urbwork, cxusb_medion_v_complete_work);
> +	INIT_LIST_HEAD(&cxdev->buflist);
> +
> +	cxdev->width = 320;
> +	cxdev->height = 240;
> +
> +	ret = cxusb_medion_register_analog_video(dvbdev);
> +	if (ret)
> +		goto ret_unregister;
> +
> +	ret = cxusb_medion_register_analog_radio(dvbdev);
> +	if (ret)
> +		goto ret_vunreg;
> +
> +	return 0;
> +
> +ret_vunreg:
> +	video_unregister_device(cxdev->videodev);
> +
> +ret_unregister:
> +	v4l2_device_put(&cxdev->v4l2dev);
> +	wait_for_completion(&cxdev->v4l2_release);
> +
> +	return ret;
> +}
> +
> +void cxusb_medion_unregister_analog(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	cxusb_vprintk(dvbdev, OPS, "unregistering analog\n");
> +
> +	video_unregister_device(cxdev->radiodev);
> +	video_unregister_device(cxdev->videodev);
> +
> +	v4l2_device_put(&cxdev->v4l2dev);
> +	wait_for_completion(&cxdev->v4l2_release);
> +
> +	cxusb_vprintk(dvbdev, OPS, "analog unregistered\n");
> +}
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index 99a3f3625944..db03b64308ab 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -11,11 +11,11 @@
>   * design, so it can be reused for the "analogue-only" device (if it will
>   * appear at all).
>   *
> - * TODO: Use the cx25840-driver for the analogue part
>   *
>   * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@posteo.de)
>   * Copyright (C) 2006 Michael Krufky (mkrufky@linuxtv.org)
>   * Copyright (C) 2006, 2007 Chris Pascoe (c.pascoe@itee.uq.edu.au)
> + * Copyright (C) 2011, 2017 Maciej S. Szmigiero (mail@maciej.szmigiero.name)
>   *
>   *   This program is free software; you can redistribute it and/or modify it
>   *   under the terms of the GNU General Public License as published by the Free
> @@ -24,8 +24,11 @@
>   * see Documentation/dvb/README.dvb-usb for more information
>   */
>  #include <media/tuner.h>
> -#include <linux/vmalloc.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/vmalloc.h>
>  
>  #include "cxusb.h"
>  
> @@ -46,17 +49,46 @@
>  #include "si2157.h"
>  
>  /* debug */
> -static int dvb_usb_cxusb_debug;
> +int dvb_usb_cxusb_debug;
>  module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
> -MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
> +MODULE_PARM_DESC(debug, "set debugging level (see cxusb.h)."
> +		 DVB_USB_DEBUG_STATUS);
>  
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
> -#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug, 0x03, args)
> -#define deb_i2c(args...)    dprintk(dvb_usb_cxusb_debug, 0x02, args)
> +#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug, CXUSB_DBG_MISC, args)
> +#define deb_i2c(args...)    dprintk(dvb_usb_cxusb_debug, CXUSB_DBG_I2C, args)
> +
> +enum cxusb_table_index {
> +	MEDION_MD95700,
> +	DVICO_BLUEBIRD_LG064F_COLD,
> +	DVICO_BLUEBIRD_LG064F_WARM,
> +	DVICO_BLUEBIRD_DUAL_1_COLD,
> +	DVICO_BLUEBIRD_DUAL_1_WARM,
> +	DVICO_BLUEBIRD_LGZ201_COLD,
> +	DVICO_BLUEBIRD_LGZ201_WARM,
> +	DVICO_BLUEBIRD_TH7579_COLD,
> +	DVICO_BLUEBIRD_TH7579_WARM,
> +	DIGITALNOW_BLUEBIRD_DUAL_1_COLD,
> +	DIGITALNOW_BLUEBIRD_DUAL_1_WARM,
> +	DVICO_BLUEBIRD_DUAL_2_COLD,
> +	DVICO_BLUEBIRD_DUAL_2_WARM,
> +	DVICO_BLUEBIRD_DUAL_4,
> +	DVICO_BLUEBIRD_DVB_T_NANO_2,
> +	DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM,
> +	AVERMEDIA_VOLAR_A868R,
> +	DVICO_BLUEBIRD_DUAL_4_REV_2,
> +	CONEXANT_D680_DMB,
> +	MYGICA_D689,
> +	MYGICA_T230,
> +	MYGICA_T230C,
> +	NR__cxusb_table_index
> +};
> +
> +static struct usb_device_id cxusb_table[];
>  
> -static int cxusb_ctrl_msg(struct dvb_usb_device *d,
> -			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
> +int cxusb_ctrl_msg(struct dvb_usb_device *d,
> +		   u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
>  {
>  	struct cxusb_state *st = d->priv;
>  	int ret;
> @@ -88,7 +120,8 @@ static void cxusb_gpio_tuner(struct dvb_usb_device *d, int onoff)
>  	struct cxusb_state *st = d->priv;
>  	u8 o[2], i;
>  
> -	if (st->gpio_write_state[GPIO_TUNER] == onoff)
> +	if (st->gpio_write_state[GPIO_TUNER] == onoff &&
> +	    !st->gpio_write_refresh[GPIO_TUNER])
>  		return;
>  
>  	o[0] = GPIO_TUNER;
> @@ -99,6 +132,7 @@ static void cxusb_gpio_tuner(struct dvb_usb_device *d, int onoff)
>  		deb_info("gpio_write failed.\n");
>  
>  	st->gpio_write_state[GPIO_TUNER] = onoff;
> +	st->gpio_write_refresh[GPIO_TUNER] = false;
>  }
>  
>  static int cxusb_bluebird_gpio_rw(struct dvb_usb_device *d, u8 changemask,
> @@ -258,7 +292,7 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  
>  static u32 cxusb_i2c_func(struct i2c_adapter *adapter)
>  {
> -	return I2C_FUNC_I2C;
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
>  }
>  
>  static struct i2c_algorithm cxusb_i2c_algo = {
> @@ -266,15 +300,48 @@ static struct i2c_algorithm cxusb_i2c_algo = {
>  	.functionality = cxusb_i2c_func,
>  };
>  
> -static int cxusb_power_ctrl(struct dvb_usb_device *d, int onoff)
> +static int _cxusb_power_ctrl(struct dvb_usb_device *d, int onoff)
>  {
>  	u8 b = 0;
> +
> +	deb_info("setting power %s\n", onoff ? "ON" : "OFF");
> +
>  	if (onoff)
>  		return cxusb_ctrl_msg(d, CMD_POWER_ON, &b, 1, NULL, 0);
>  	else
>  		return cxusb_ctrl_msg(d, CMD_POWER_OFF, &b, 1, NULL, 0);
>  }
>  
> +static int cxusb_power_ctrl(struct dvb_usb_device *d, int onoff)
> +{
> +	bool is_medion = d->props.devices[0].warm_ids[0] ==
> +		&cxusb_table[MEDION_MD95700];
> +	int ret;
> +
> +	if (is_medion && !onoff) {
> +		struct cxusb_medion_dev *cxdev = d->priv;
> +
> +		mutex_lock(&cxdev->open_lock);
> +
> +		if (cxdev->open_type == CXUSB_OPEN_ANALOG) {
> +			deb_info("preventing DVB core from setting power OFF while we are in analog mode\n");
> +			ret = -EBUSY;
> +			goto ret_unlock;
> +		}
> +	}
> +
> +	ret = _cxusb_power_ctrl(d, onoff);
> +
> +ret_unlock:
> +	if (is_medion && !onoff) {
> +		struct cxusb_medion_dev *cxdev = d->priv;
> +
> +		mutex_unlock(&cxdev->open_lock);
> +	}
> +
> +	return ret;
> +}
> +
>  static int cxusb_aver_power_ctrl(struct dvb_usb_device *d, int onoff)
>  {
>  	int ret;
> @@ -351,11 +418,26 @@ static int cxusb_d680_dmb_power_ctrl(struct dvb_usb_device *d, int onoff)
>  
>  static int cxusb_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  {
> +	struct dvb_usb_device *dvbdev = adap->dev;
> +	bool is_medion = dvbdev->props.devices[0].warm_ids[0] ==
> +		&cxusb_table[MEDION_MD95700];
>  	u8 buf[2] = { 0x03, 0x00 };
> +
> +	if (is_medion && onoff) {
> +		int ret;
> +
> +		ret = cxusb_medion_get(dvbdev, CXUSB_OPEN_DIGITAL);
> +		if (ret != 0)
> +			return ret;
> +	}
> +
>  	if (onoff)
> -		cxusb_ctrl_msg(adap->dev, CMD_STREAMING_ON, buf, 2, NULL, 0);
> +		cxusb_ctrl_msg(dvbdev, CMD_STREAMING_ON, buf, 2, NULL, 0);
>  	else
> -		cxusb_ctrl_msg(adap->dev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
> +		cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
> +
> +	if (is_medion && !onoff)
> +		cxusb_medion_put(dvbdev);
>  
>  	return 0;
>  }
> @@ -630,9 +712,21 @@ static struct max2165_config mygica_d689_max2165_cfg = {
>  /* Callbacks for DVB USB */
>  static int cxusb_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
>  {
> +	struct dvb_usb_device *dvbdev = adap->dev;
> +	bool is_medion = dvbdev->props.devices[0].warm_ids[0] ==
> +		&cxusb_table[MEDION_MD95700];
> +
>  	dvb_attach(simple_tuner_attach, adap->fe_adap[0].fe,
> -		   &adap->dev->i2c_adap, 0x61,
> +		   &dvbdev->i2c_adap, 0x61,
>  		   TUNER_PHILIPS_FMD1216ME_MK3);
> +
> +	if (is_medion && adap->fe_adap[0].fe != NULL)
> +		/*
> +		 * make sure that DVB core won't put to sleep (reset, really)
> +		 * tuner when we might be open in analog mode
> +		 */
> +		adap->fe_adap[0].fe->ops.tuner_ops.sleep = NULL;
> +
>  	return 0;
>  }
>  
> @@ -734,20 +828,105 @@ static int cxusb_mygica_d689_tuner_attach(struct dvb_usb_adapter *adap)
>  	return (fe == NULL) ? -EIO : 0;
>  }
>  
> -static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
> +static int cxusb_medion_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
>  {
> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> +	struct dvb_usb_device *dvbdev = adap->dev;
> +
> +	if (acquire)
> +		return cxusb_medion_get(dvbdev, CXUSB_OPEN_DIGITAL);
> +
> +	cxusb_medion_put(dvbdev);
> +
> +	return 0;
> +}
> +
> +static int cxusb_medion_set_mode(struct dvb_usb_device *dvbdev, bool digital)
> +{
> +	struct cxusb_state *st = dvbdev->priv;
> +	int ret;
>  	u8 b;
> -	if (usb_set_interface(adap->dev->udev, 0, 6) < 0)
> -		err("set interface failed");
> +	unsigned int i;
> +
> +	/*
> +	 * switching mode while doing an I2C transaction often causes
> +	 * the device to crash
> +	 */
> +	mutex_lock(&dvbdev->i2c_mutex);
> +
> +	if (digital) {
> +		ret = usb_set_interface(dvbdev->udev, 0, 6);
> +		if (ret != 0) {
> +			dev_err(&dvbdev->udev->dev,
> +				"digital interface selection failed (%d)\n",
> +				ret);
> +			goto ret_unlock;
> +		}
> +	} else {
> +		ret = usb_set_interface(dvbdev->udev, 0, 1);
> +		if (ret != 0) {
> +			dev_err(&dvbdev->udev->dev,
> +				"analog interface selection failed (%d)\n",
> +				ret);
> +			goto ret_unlock;
> +		}
> +	}
>  
> -	cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, &b, 1);
> +	/* pipes need to be cleared after setting interface */
> +	ret = usb_clear_halt(dvbdev->udev, usb_rcvbulkpipe(dvbdev->udev, 1));
> +	if (ret != 0)
> +		dev_warn(&dvbdev->udev->dev,
> +			 "clear halt on IN pipe failed (%d)\n",
> +			 ret);
> +
> +	ret = usb_clear_halt(dvbdev->udev, usb_sndbulkpipe(dvbdev->udev, 1));
> +	if (ret != 0)
> +		dev_warn(&dvbdev->udev->dev,
> +			 "clear halt on OUT pipe failed (%d)\n",
> +			 ret);
> +
> +	ret = cxusb_ctrl_msg(dvbdev, digital ? CMD_DIGITAL : CMD_ANALOG,
> +			     NULL, 0, &b, 1);
> +	if (ret != 0) {
> +		dev_err(&dvbdev->udev->dev, "mode switch failed (%d)\n",
> +			ret);
> +		goto ret_unlock;
> +	}
> +
> +	/* mode switch seems to reset GPIO states */
> +	for (i = 0; i < ARRAY_SIZE(st->gpio_write_refresh); i++)
> +		st->gpio_write_refresh[i] = true;
> +
> +ret_unlock:
> +	mutex_unlock(&dvbdev->i2c_mutex);
> +
> +	return ret;
> +}
> +
> +static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
> +{
> +	struct dvb_usb_device *dvbdev = adap->dev;
> +	bool is_medion = dvbdev->props.devices[0].warm_ids[0] ==
> +		&cxusb_table[MEDION_MD95700];
> +
> +	if (is_medion) {
> +		int ret;
> +
> +		ret = cxusb_medion_set_mode(dvbdev, true);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	adap->fe_adap[0].fe = dvb_attach(cx22702_attach, &cxusb_cx22702_config,
> -					 &adap->dev->i2c_adap);
> -	if ((adap->fe_adap[0].fe) != NULL)
> -		return 0;
> +					 &dvbdev->i2c_adap);
> +	if (adap->fe_adap[0].fe == NULL)
> +		return -EIO;
>  
> -	return -EIO;
> +	if (is_medion)
> +		adap->fe_adap[0].fe->ops.ts_bus_ctrl =
> +			cxusb_medion_fe_ts_bus_ctrl;
> +
> +	return 0;
>  }
>  
>  static int cxusb_lgdt3303_frontend_attach(struct dvb_usb_adapter *adap)
> @@ -1383,6 +1562,101 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
>  	return -EINVAL;
>  }
>  
> +int cxusb_medion_get(struct dvb_usb_device *dvbdev,
> +		     enum cxusb_open_type open_type)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +	int ret = 0;
> +
> +	mutex_lock(&cxdev->open_lock);
> +
> +	if (WARN_ON((cxdev->open_type == CXUSB_OPEN_INIT ||
> +		     cxdev->open_type == CXUSB_OPEN_NONE) &&
> +		    cxdev->open_ctr != 0)) {
> +		ret = -EINVAL;
> +		goto ret_unlock;
> +	}
> +
> +	if (cxdev->open_type == CXUSB_OPEN_INIT) {
> +		ret = -EAGAIN;
> +		goto ret_unlock;
> +	}
> +
> +	if (cxdev->open_ctr == 0) {
> +		if (cxdev->open_type != open_type) {
> +			deb_info("will acquire and switch to %s\n",
> +				 open_type == CXUSB_OPEN_ANALOG ?
> +				 "analog" : "digital");
> +
> +			if (open_type == CXUSB_OPEN_ANALOG) {
> +				ret = _cxusb_power_ctrl(dvbdev, 1);
> +				if (ret != 0)
> +					dev_warn(&dvbdev->udev->dev,
> +						 "powerup for analog switch failed (%d)\n",
> +						 ret);
> +
> +				ret = cxusb_medion_set_mode(dvbdev, false);
> +				if (ret != 0)
> +					goto ret_unlock;
> +
> +				ret = cxusb_medion_analog_init(dvbdev);
> +				if (ret != 0)
> +					goto ret_unlock;
> +			} else { /* digital */
> +				ret = _cxusb_power_ctrl(dvbdev, 1);
> +				if (ret != 0)
> +					dev_warn(&dvbdev->udev->dev,
> +						 "powerup for digital switch failed (%d)\n",
> +						 ret);
> +
> +				ret = cxusb_medion_set_mode(dvbdev, true);
> +				if (ret != 0)
> +					goto ret_unlock;
> +			}
> +
> +			cxdev->open_type = open_type;
> +		} else
> +			deb_info("reacquired idle %s\n",
> +				 open_type == CXUSB_OPEN_ANALOG ?
> +				 "analog" : "digital");
> +
> +		cxdev->open_ctr = 1;
> +	} else if (cxdev->open_type == open_type) {
> +		cxdev->open_ctr++;
> +		deb_info("acquired %s\n", open_type == CXUSB_OPEN_ANALOG ?
> +			 "analog" : "digital");
> +	} else
> +		ret = -EBUSY;
> +
> +ret_unlock:
> +	mutex_unlock(&cxdev->open_lock);
> +
> +	return ret;
> +}
> +
> +void cxusb_medion_put(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	mutex_lock(&cxdev->open_lock);
> +
> +	if (cxdev->open_type == CXUSB_OPEN_INIT) {
> +		WARN_ON(cxdev->open_ctr != 0);
> +		cxdev->open_type = CXUSB_OPEN_NONE;
> +		goto unlock;
> +	}
> +
> +	if (!WARN_ON(cxdev->open_ctr < 1)) {
> +		cxdev->open_ctr--;
> +
> +		deb_info("release %s\n", cxdev->open_type ==
> +			 CXUSB_OPEN_ANALOG ? "analog" : "digital");
> +	}
> +
> +unlock:
> +	mutex_unlock(&cxdev->open_lock);
> +}
> +
>  /* DVB USB Driver stuff */
>  static struct dvb_usb_device_properties cxusb_medion_properties;
>  static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties;
> @@ -1399,12 +1673,101 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
>  static struct dvb_usb_device_properties cxusb_mygica_t230_properties;
>  static struct dvb_usb_device_properties cxusb_mygica_t230c_properties;
>  
> +static int cxusb_medion_priv_init(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	cxdev->dvbdev = dvbdev;
> +	cxdev->open_type = CXUSB_OPEN_INIT;
> +	mutex_init(&cxdev->open_lock);
> +
> +	return 0;
> +}
> +
> +static void cxusb_medion_priv_destroy(struct dvb_usb_device *dvbdev)
> +{
> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
> +
> +	mutex_destroy(&cxdev->open_lock);
> +}
> +
> +static bool cxusb_medion_check_altsetting(struct usb_host_interface *as)
> +{
> +	unsigned int ctr;
> +
> +	for (ctr = 0; ctr < as->desc.bNumEndpoints; ctr++) {
> +		if ((as->endpoint[ctr].desc.bEndpointAddress &
> +		     USB_ENDPOINT_NUMBER_MASK) != 2)
> +			continue;
> +
> +		if (as->endpoint[ctr].desc.bEndpointAddress & USB_DIR_IN &&
> +		    ((as->endpoint[ctr].desc.bmAttributes &
> +		      USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_ISOC))
> +			return true;
> +
> +		break;
> +	}
> +
> +	return false;
> +}
> +
> +static bool cxusb_medion_check_intf(struct usb_interface *intf)
> +{
> +	unsigned int ctr;
> +
> +	if (intf->num_altsetting < 2) {
> +		dev_err(intf->usb_dev, "no alternate interface");
> +
> +		return false;
> +	}
> +
> +	for (ctr = 0; ctr < intf->num_altsetting; ctr++) {
> +		if (intf->altsetting[ctr].desc.bAlternateSetting != 1)
> +			continue;
> +
> +		if (cxusb_medion_check_altsetting(&intf->altsetting[ctr]))
> +			return true;
> +
> +		break;
> +	}
> +
> +	dev_err(intf->usb_dev, "no iso interface");
> +
> +	return false;
> +}
> +
>  static int cxusb_probe(struct usb_interface *intf,
>  		       const struct usb_device_id *id)
>  {
> +	struct dvb_usb_device *dvbdev;
> +	int ret;
> +
> +	/* Medion 95700 */
>  	if (0 == dvb_usb_device_init(intf, &cxusb_medion_properties,
> -				     THIS_MODULE, NULL, adapter_nr) ||
> -	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_properties,
> +				     THIS_MODULE, &dvbdev, adapter_nr)) {
> +		if (!cxusb_medion_check_intf(intf)) {
> +			ret = -ENODEV;
> +			goto ret_uninit;
> +		}
> +
> +		_cxusb_power_ctrl(dvbdev, 1);
> +		ret = cxusb_medion_set_mode(dvbdev, false);
> +		if (ret)
> +			goto ret_uninit;
> +
> +		ret = cxusb_medion_register_analog(dvbdev);
> +
> +		cxusb_medion_set_mode(dvbdev, true);
> +		_cxusb_power_ctrl(dvbdev, 0);
> +
> +		if (ret != 0)
> +			goto ret_uninit;
> +
> +		/* release device from INIT mode to normal operation */
> +		cxusb_medion_put(dvbdev);
> +
> +		return 0;
> +	} else if (0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_properties,
>  				     THIS_MODULE, NULL, adapter_nr) ||
>  	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dee1601_properties,
>  				     THIS_MODULE, NULL, adapter_nr) ||
> @@ -1436,6 +1799,11 @@ static int cxusb_probe(struct usb_interface *intf,
>  		return 0;
>  
>  	return -EINVAL;
> +
> +ret_uninit:
> +	dvb_usb_device_exit(intf);
> +
> +	return ret;
>  }
>  
>  static void cxusb_disconnect(struct usb_interface *intf)
> @@ -1444,6 +1812,9 @@ static void cxusb_disconnect(struct usb_interface *intf)
>  	struct cxusb_state *st = d->priv;
>  	struct i2c_client *client;
>  
> +	if (d->props.devices[0].warm_ids[0] == &cxusb_table[MEDION_MD95700])
> +		cxusb_medion_unregister_analog(d);
> +
>  	/* remove I2C client for tuner */
>  	client = st->i2c_client_tuner;
>  	if (client) {
> @@ -1461,32 +1832,6 @@ static void cxusb_disconnect(struct usb_interface *intf)
>  	dvb_usb_device_exit(intf);
>  }
>  
> -enum cxusb_table_index {
> -	MEDION_MD95700,
> -	DVICO_BLUEBIRD_LG064F_COLD,
> -	DVICO_BLUEBIRD_LG064F_WARM,
> -	DVICO_BLUEBIRD_DUAL_1_COLD,
> -	DVICO_BLUEBIRD_DUAL_1_WARM,
> -	DVICO_BLUEBIRD_LGZ201_COLD,
> -	DVICO_BLUEBIRD_LGZ201_WARM,
> -	DVICO_BLUEBIRD_TH7579_COLD,
> -	DVICO_BLUEBIRD_TH7579_WARM,
> -	DIGITALNOW_BLUEBIRD_DUAL_1_COLD,
> -	DIGITALNOW_BLUEBIRD_DUAL_1_WARM,
> -	DVICO_BLUEBIRD_DUAL_2_COLD,
> -	DVICO_BLUEBIRD_DUAL_2_WARM,
> -	DVICO_BLUEBIRD_DUAL_4,
> -	DVICO_BLUEBIRD_DVB_T_NANO_2,
> -	DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM,
> -	AVERMEDIA_VOLAR_A868R,
> -	DVICO_BLUEBIRD_DUAL_4_REV_2,
> -	CONEXANT_D680_DMB,
> -	MYGICA_D689,
> -	MYGICA_T230,
> -	MYGICA_T230C,
> -	NR__cxusb_table_index
> -};
> -
>  static struct usb_device_id cxusb_table[NR__cxusb_table_index + 1] = {
>  	[MEDION_MD95700] = {
>  		USB_DEVICE(USB_VID_MEDION, USB_PID_MEDION_MD95700)
> @@ -1563,13 +1908,16 @@ static struct dvb_usb_device_properties cxusb_medion_properties = {
>  
>  	.usb_ctrl = CYPRESS_FX2,
>  
> -	.size_of_priv     = sizeof(struct cxusb_state),
> +	.size_of_priv     = sizeof(struct cxusb_medion_dev),
> +	.priv_init        = cxusb_medion_priv_init,
> +	.priv_destroy     = cxusb_medion_priv_destroy,
>  
>  	.num_adapters = 1,
>  	.adapter = {
>  		{
>  		.num_frontends = 1,
>  		.fe = {{
> +			.caps = DVB_USB_ADAP_STREAMING_CTRL_NO_URB,
>  			.streaming_ctrl   = cxusb_streaming_ctrl,
>  			.frontend_attach  = cxusb_cx22702_frontend_attach,
>  			.tuner_attach     = cxusb_fmd1216me_tuner_attach,
> @@ -2330,6 +2678,7 @@ module_usb_driver(cxusb_driver);
>  MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
>  MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
>  MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
> +MODULE_AUTHOR("Maciej S. Szmigiero <mail@maciej.szmigiero.name>");
>  MODULE_DESCRIPTION("Driver for Conexant USB2.0 hybrid reference design");
> -MODULE_VERSION("1.0-alpha");
> +MODULE_VERSION("1.0-beta");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
> index 66429d7f69b5..1cead0fb533e 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.h
> +++ b/drivers/media/usb/dvb-usb/cxusb.h
> @@ -1,9 +1,28 @@
>  #ifndef _DVB_USB_CXUSB_H_
>  #define _DVB_USB_CXUSB_H_
>  
> +#include <linux/completion.h>
> +#include <linux/i2c.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/usb.h>
> +#include <linux/workqueue.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-core.h>
> +
>  #define DVB_USB_LOG_PREFIX "cxusb"
>  #include "dvb-usb.h"
>  
> +#define CXUSB_VIDEO_URBS (5)
> +
> +#define CXUSB_VIDEO_PKT_SIZE 3030
> +#define CXUSB_VIDEO_MAX_FRAME_PKTS 346
> +#define CXUSB_VIDEO_MAX_FRAME_SIZE (CXUSB_VIDEO_MAX_FRAME_PKTS * \
> +					CXUSB_VIDEO_PKT_SIZE)
> +
>  /* usb commands - some of it are guesses, don't have a reference yet */
>  #define CMD_BLUEBIRD_GPIO_RW 0x05
>  
> @@ -28,11 +47,26 @@
>  #define CMD_ANALOG        0x50
>  #define CMD_DIGITAL       0x51
>  
> +#define CXUSB_BT656_COMMON "\xff\x00\x00"
> +
> +#define CXUSB_FIELD_MASK (0x40)
> +#define CXUSB_FIELD_1 (0)
> +#define CXUSB_FIELD_2 (0x40)
> +
> +#define CXUSB_SEAV_MASK (0x10)
> +#define CXUSB_SEAV_EAV (0x10)
> +#define CXUSB_SEAV_SAV (0)
> +
> +#define CXUSB_VBI_MASK (0x20)
> +#define CXUSB_VBI_ON (0x20)
> +#define CXUSB_VBI_OFF (0)
> +
>  /* Max transfer size done by I2C transfer functions */
>  #define MAX_XFER_SIZE  80
>  
>  struct cxusb_state {
>  	u8 gpio_write_state[3];
> +	bool gpio_write_refresh[3];
>  	struct i2c_client *i2c_client_demod;
>  	struct i2c_client *i2c_client_tuner;
>  
> @@ -44,4 +78,107 @@ struct cxusb_state {
>  		enum fe_status *status);
>  };
>  
> +enum cxusb_open_type {
> +	CXUSB_OPEN_INIT, CXUSB_OPEN_NONE,
> +	CXUSB_OPEN_ANALOG, CXUSB_OPEN_DIGITAL
> +};
> +
> +struct cxusb_medion_auxbuf {
> +	u8 *buf;
> +	unsigned int len;
> +	unsigned int paylen;
> +};
> +
> +enum cxusb_bt656_mode {
> +	NEW_FRAME, FIRST_FIELD, SECOND_FIELD
> +};
> +
> +enum cxusb_bt656_fmode {
> +	START_SEARCH, LINE_SAMPLES, VBI_SAMPLES
> +};
> +
> +struct cxusb_bt656_params {
> +	enum cxusb_bt656_mode mode;
> +	enum cxusb_bt656_fmode fmode;
> +	unsigned int pos;
> +	unsigned int line;
> +	unsigned int linesamples;
> +	u8 *buf;
> +};
> +
> +struct cxusb_medion_dev {
> +	/* has to be the first one */
> +	struct cxusb_state state;
> +
> +	struct dvb_usb_device *dvbdev;
> +
> +	struct v4l2_device v4l2dev;
> +	struct v4l2_subdev *cx25840;
> +	struct v4l2_subdev *tuner;
> +	struct v4l2_subdev *tda9887;
> +	struct video_device *videodev, *radiodev;
> +	struct mutex dev_lock;
> +
> +	enum cxusb_open_type open_type;
> +	unsigned int open_ctr;
> +	struct mutex open_lock;
> +
> +	struct vb2_queue videoqueue;
> +	u32 input;
> +	bool streaming;
> +	u32 width, height;
> +	bool raw_mode;
> +	struct cxusb_medion_auxbuf auxbuf;
> +	v4l2_std_id norm;
> +
> +	struct urb *streamurbs[CXUSB_VIDEO_URBS];
> +	unsigned long urbcomplete;
> +	struct work_struct urbwork;
> +	unsigned int nexturb;
> +
> +	struct cxusb_bt656_params bt656;
> +	struct cxusb_medion_vbuffer *vbuf;
> +
> +	struct list_head buflist;
> +
> +	struct completion v4l2_release;
> +};
> +
> +struct cxusb_medion_vbuffer {
> +	struct vb2_buffer vb2;
> +	struct list_head list;
> +};
> +
> +/* Capture streaming parameters extendedmode field flags */
> +#define CXUSB_EXTENDEDMODE_CAPTURE_RAW 1
> +
> +/* defines for "debug" module parameter */
> +#define CXUSB_DBG_RC BIT(0)
> +#define CXUSB_DBG_I2C BIT(1)
> +#define CXUSB_DBG_MISC BIT(2)
> +#define CXUSB_DBG_BT656 BIT(3)
> +#define CXUSB_DBG_URB BIT(4)
> +#define CXUSB_DBG_OPS BIT(5)
> +#define CXUSB_DBG_AUXB BIT(6)
> +
> +extern int dvb_usb_cxusb_debug;
> +
> +#define cxusb_vprintk(dvbdev, lvl, ...) do {				\
> +		struct cxusb_medion_dev *_cxdev = (dvbdev)->priv;	\
> +		if (dvb_usb_cxusb_debug & CXUSB_DBG_##lvl)		\
> +			v4l2_printk(KERN_DEBUG,			\
> +				    &_cxdev->v4l2dev, __VA_ARGS__);	\
> +	} while (0)
> +
> +int cxusb_ctrl_msg(struct dvb_usb_device *d,
> +		   u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen);
> +
> +int cxusb_medion_analog_init(struct dvb_usb_device *dvbdev);
> +int cxusb_medion_register_analog(struct dvb_usb_device *dvbdev);
> +void cxusb_medion_unregister_analog(struct dvb_usb_device *dvbdev);
> +
> +int cxusb_medion_get(struct dvb_usb_device *dvbdev,
> +		     enum cxusb_open_type open_type);
> +void cxusb_medion_put(struct dvb_usb_device *dvbdev);
> +
>  #endif
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> index e5675da286cb..d7d388b7b311 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> @@ -14,6 +14,7 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>  {
>  	struct dvb_usb_adapter *adap = dvbdmxfeed->demux->priv;
>  	int newfeedcount, ret;
> +	bool streaming_ctrl_no_urb;
>  
>  	if (adap == NULL)
>  		return -ENODEV;
> @@ -23,12 +24,16 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>  		return -EINVAL;
>  	}
>  
> +	streaming_ctrl_no_urb = adap->props.fe[adap->active_fe].caps &
> +		DVB_USB_ADAP_STREAMING_CTRL_NO_URB;
>  	newfeedcount = adap->feedcount + (onoff ? 1 : -1);
>  
>  	/* stop feed before setting a new pid if there will be no pid anymore */
>  	if (newfeedcount == 0) {
>  		deb_ts("stop feeding\n");
> -		usb_urb_kill(&adap->fe_adap[adap->active_fe].stream);
> +
> +		if (streaming_ctrl_no_urb)
> +			usb_urb_kill(&adap->fe_adap[adap->active_fe].stream);
>  
>  		if (adap->props.fe[adap->active_fe].streaming_ctrl != NULL) {
>  			ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
> @@ -37,6 +42,9 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>  				return ret;
>  			}
>  		}
> +
> +		if (!streaming_ctrl_no_urb)
> +			usb_urb_kill(&adap->fe_adap[adap->active_fe].stream);
>  	}
>  
>  	adap->feedcount = newfeedcount;
> @@ -55,8 +63,10 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>  	 * for reception.
>  	 */
>  	if (adap->feedcount == onoff && adap->feedcount > 0) {
> -		deb_ts("submitting all URBs\n");
> -		usb_urb_submit(&adap->fe_adap[adap->active_fe].stream);
> +		if (!streaming_ctrl_no_urb) {
> +			deb_ts("submitting all URBs early\n");
> +			usb_urb_submit(&adap->fe_adap[adap->active_fe].stream);
> +		}
>  
>  		deb_ts("controlling pid parser\n");
>  		if (adap->props.fe[adap->active_fe].caps & DVB_USB_ADAP_HAS_PID_FILTER &&
> @@ -79,6 +89,10 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>  			}
>  		}
>  
> +		if (streaming_ctrl_no_urb) {
> +			deb_ts("submitting all URBs late\n");
> +			usb_urb_submit(&adap->fe_adap[adap->active_fe].stream);
> +		}
>  	}
>  	return 0;
>  }
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
> index 84308569e7dc..9746266c9e35 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
> @@ -133,6 +133,10 @@ static int dvb_usb_exit(struct dvb_usb_device *d)
>  	dvb_usb_i2c_exit(d);
>  	deb_info("state should be zero now: %x\n", d->state);
>  	d->state = DVB_USB_STATE_INIT;
> +
> +	if (d->priv != NULL && d->props.priv_destroy != NULL)
> +		d->props.priv_destroy(d);
> +
>  	kfree(d->priv);
>  	kfree(d);
>  	return 0;
> @@ -154,6 +158,15 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
>  			err("no memory for priv in 'struct dvb_usb_device'");
>  			return -ENOMEM;
>  		}
> +
> +		if (d->props.priv_init != NULL) {
> +			ret = d->props.priv_init(d);
> +			if (ret != 0) {
> +				kfree(d->priv);
> +				d->priv = NULL;
> +				return ret;
> +			}
> +		}
>  	}
>  
>  	/* check the capabilities and set appropriate variables */
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
> index 67f898b6f6d0..0254ecfbd4c6 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/usb/dvb-usb/dvb-usb.h
> @@ -142,6 +142,7 @@ struct dvb_usb_adapter_fe_properties {
>  #define DVB_USB_ADAP_NEED_PID_FILTERING           0x04
>  #define DVB_USB_ADAP_RECEIVES_204_BYTE_TS         0x08
>  #define DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD         0x10
> +#define DVB_USB_ADAP_STREAMING_CTRL_NO_URB        0x20
>  	int caps;
>  	int pid_filter_count;
>  
> @@ -232,6 +233,11 @@ enum dvb_usb_mode {
>   *
>   * @size_of_priv: how many bytes shall be allocated for the private field
>   *  of struct dvb_usb_device.
> + * @priv_init: optional callback to initialize the variable that private field
> + * of struct dvb_usb_device has pointer to just after it had been allocated and
> + * zeroed.
> + * @priv_destroy: just like priv_init, only called before deallocating
> + * the memory pointed by private field of struct dvb_usb_device.
>   *
>   * @power_ctrl: called to enable/disable power of the device.
>   * @read_mac_address: called to read the MAC address of the device.
> @@ -273,6 +279,8 @@ struct dvb_usb_device_properties {
>  	int        no_reconnect;
>  
>  	int size_of_priv;
> +	int (*priv_init)(struct dvb_usb_device *);
> +	void (*priv_destroy)(struct dvb_usb_device *);
>  
>  	int num_adapters;
>  	struct dvb_usb_adapter_properties adapter[MAX_NO_OF_ADAPTER_PER_DEVICE];
> 
