Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([195.168.3.45]:58614 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaHFFyy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Aug 2014 01:54:54 -0400
Message-ID: <1407303961.26078.1.camel@v3.sk>
Subject: Re: [PATCH 2/2] usbtv: add audio support
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Federico Simoncelli <federico.simoncelli@gmail.com>,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	hans.verkuil@cisco.com, Federico Simoncelli <fsimonce@redhat.com>
Date: Wed, 06 Aug 2014 07:46:01 +0200
In-Reply-To: <20140204062211.082cabe2@samsung.com>
References: <1389132802-31200-1-git-send-email-federico.simoncelli@gmail.com>
	 <1389132802-31200-2-git-send-email-federico.simoncelli@gmail.com>
	 <20140204062211.082cabe2@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, 2014-02-04 at 06:22 -0200, Mauro Carvalho Chehab wrote:
> Em Tue,  7 Jan 2014 23:13:22 +0100
> Federico Simoncelli <federico.simoncelli@gmail.com> escreveu:
> 
> > From: Federico Simoncelli <fsimonce@redhat.com>
> > 
> > Signed-off-by: Federico Simoncelli <fsimonce@redhat.com>
> > Tested-by: Lubomir Rintel <lkundrak@v3.sk>
> > ---
> >  drivers/media/usb/usbtv/Makefile      |   3 +-
> >  drivers/media/usb/usbtv/usbtv-audio.c | 384 ++++++++++++++++++++++++++++++++++
> >  drivers/media/usb/usbtv/usbtv-core.c  |  16 +-
> >  drivers/media/usb/usbtv/usbtv-video.c |   9 +-
> >  drivers/media/usb/usbtv/usbtv.h       |  21 +-
> >  5 files changed, 423 insertions(+), 10 deletions(-)
> >  create mode 100644 drivers/media/usb/usbtv/usbtv-audio.c
> > 
> > diff --git a/drivers/media/usb/usbtv/Makefile b/drivers/media/usb/usbtv/Makefile
> > index 775316a..f555cf8 100644
> > --- a/drivers/media/usb/usbtv/Makefile
> > +++ b/drivers/media/usb/usbtv/Makefile
> > @@ -1,4 +1,5 @@
> >  usbtv-y := usbtv-core.o \
> > -	usbtv-video.o
> > +	usbtv-video.o \
> > +	usbtv-audio.o
> >  
> >  obj-$(CONFIG_VIDEO_USBTV) += usbtv.o
> > diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbtv/usbtv-audio.c
> > new file mode 100644
> > index 0000000..3acc52c
> > --- /dev/null
> > +++ b/drivers/media/usb/usbtv/usbtv-audio.c
> > @@ -0,0 +1,384 @@
> > +/*
> > + * Fushicai USBTV007 Audio-Video Grabber Driver
> > + *
> > + * Product web site:
> > + * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
> > + *
> > + * Copyright (c) 2013 Federico Simoncelli
> > + * All rights reserved.
> > + * No physical hardware was harmed running Windows during the
> > + * reverse-engineering activity
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions
> > + * are met:
> > + * 1. Redistributions of source code must retain the above copyright
> > + *    notice, this list of conditions, and the following disclaimer,
> > + *    without modification.
> > + * 2. The name of the author may not be used to endorse or promote products
> > + *    derived from this software without specific prior written permission.
> > + *
> > + * Alternatively, this software may be distributed under the terms of the
> > + * GNU General Public License ("GPL").
> > + */
> > +
> > +#include <sound/core.h>
> > +#include <sound/initval.h>
> > +#include <sound/ac97_codec.h>
> > +#include <sound/pcm_params.h>
> > +
> > +#include "usbtv.h"
> > +
> > +static struct snd_pcm_hardware snd_usbtv_digital_hw = {
> > +	.info = SNDRV_PCM_INFO_BATCH |
> > +		SNDRV_PCM_INFO_MMAP |
> > +		SNDRV_PCM_INFO_INTERLEAVED |
> > +		SNDRV_PCM_INFO_BLOCK_TRANSFER |
> > +		SNDRV_PCM_INFO_MMAP_VALID,
> > +	.formats = SNDRV_PCM_FMTBIT_S16_LE,
> > +	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,
> 
> No, the above is wrong. It should be, instead:
> 
> 	.rates = SNDRV_PCM_RATE_48000,
> 
> > +	.rate_min = 48000,
> > +	.rate_max = 48000,
> > +	.channels_min = 2,
> > +	.channels_max = 2,
> 
> > +	.period_bytes_min = 64,
> > +	.period_bytes_max = 12544,
> 
> The above is likely wrong too, as it seems that you're using a fixed
> number of URBs and a fixed URB size.
> 
> An invalid period size can cause bad audio artifacts. Basically, you need
> to estimate/check how many URBs you're receiving per second, and what's
> their size, in order to fill these.
> 
> I did such review on one of the drivers, at:
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/em28xx
> 
> In particular, I suggest you to take a look on those patches:
> 	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/1b3fd2d342667005855deae74200195695433259
> 	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/49677aef90de7834e7bb4b0adf95c3342c2c8668
> 	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/a02b9c238b408f69fc78d528b549b85001df98b8
> 
> As it provides a way to dynamically fill it in runtime, showing the
> calculus to estimate those values.

This is a bit different situation, it seems. The hardware, weirdly, uses
bulk transfers for sound data, thus there's essentially no chance of
bandwidth control and the little chance to do anything about the
latency.

The only thing we could possibly tune is the maximum size of the bulk
packet. Is that correct? Would that be a good idea?

> > +	.periods_min = 2,
> > +	.periods_max = 98,
> > +	.buffer_bytes_max = 62720 * 8, /* value in usbaudio.c */
> > +};
> > +
> > +static int snd_usbtv_pcm_open(struct snd_pcm_substream *substream)
> > +{
> > +	struct usbtv *chip = snd_pcm_substream_chip(substream);
> > +	struct snd_pcm_runtime *runtime = substream->runtime;
> > +
> > +	chip->snd_substream = substream;
> > +	runtime->hw = snd_usbtv_digital_hw;
> > +
> > +	return 0;
> > +}
> > +
> > +static int snd_usbtv_pcm_close(struct snd_pcm_substream *substream)
> > +{
> > +	struct usbtv *chip = snd_pcm_substream_chip(substream);
> > +
> > +	if (atomic_read(&chip->snd_stream)) {
> > +		atomic_set(&chip->snd_stream, 0);
> > +		schedule_work(&chip->snd_trigger);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int snd_usbtv_hw_params(struct snd_pcm_substream *substream,
> > +		struct snd_pcm_hw_params *hw_params)
> > +{
> > +	int rv;
> > +	struct usbtv *chip = snd_pcm_substream_chip(substream);
> > +
> > +	rv = snd_pcm_lib_malloc_pages(substream,
> > +		params_buffer_bytes(hw_params));
> > +
> > +	if (rv < 0) {
> > +		dev_warn(chip->dev, "pcm audio buffer allocation failure %i\n",
> > +			rv);
> > +		return rv;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int snd_usbtv_hw_free(struct snd_pcm_substream *substream)
> > +{
> > +	snd_pcm_lib_free_pages(substream);
> > +	return 0;
> > +}
> > +
> > +static int snd_usbtv_prepare(struct snd_pcm_substream *substream)
> > +{
> > +	struct usbtv *chip = snd_pcm_substream_chip(substream);
> > +
> > +	chip->snd_buffer_pos = 0;
> > +	chip->snd_period_pos = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +static void usbtv_audio_urb_received(struct urb *urb)
> > +{
> > +	struct usbtv *chip = urb->context;
> > +	struct snd_pcm_substream *substream = chip->snd_substream;
> > +	struct snd_pcm_runtime *runtime = substream->runtime;
> > +	size_t i, frame_bytes, chunk_length, buffer_pos, period_pos;
> > +	int period_elapsed;
> > +	void *urb_current;
> > +
> > +	switch (urb->status) {
> > +	case 0:
> > +	case -ETIMEDOUT:
> > +		break;
> > +	case -ENOENT:
> > +	case -EPROTO:
> > +	case -ECONNRESET:
> > +	case -ESHUTDOWN:
> > +		return;
> > +	default:
> > +		dev_warn(chip->dev, "unknown audio urb status %i\n",
> > +			urb->status);
> > +	}
> > +
> > +	if (!atomic_read(&chip->snd_stream))
> > +		return;
> > +
> > +	frame_bytes = runtime->frame_bits >> 3;
> > +	chunk_length = USBTV_CHUNK / frame_bytes;
> > +
> > +	buffer_pos = chip->snd_buffer_pos;
> > +	period_pos = chip->snd_period_pos;
> > +	period_elapsed = 0;
> > +
> > +	for (i = 0; i < urb->actual_length; i += USBTV_CHUNK_SIZE) {
> > +		urb_current = urb->transfer_buffer + i + USBTV_AUDIO_HDRSIZE;
> > +
> > +		if (buffer_pos + chunk_length >= runtime->buffer_size) {
> > +			size_t cnt = (runtime->buffer_size - buffer_pos) *
> > +				frame_bytes;
> > +			memcpy(runtime->dma_area + buffer_pos * frame_bytes,
> > +				urb_current, cnt);
> > +			memcpy(runtime->dma_area, urb_current + cnt,
> > +				chunk_length * frame_bytes - cnt);
> > +		} else {
> > +			memcpy(runtime->dma_area + buffer_pos * frame_bytes,
> > +				urb_current, chunk_length * frame_bytes);
> > +		}
> > +
> > +		buffer_pos += chunk_length;
> > +		period_pos += chunk_length;
> > +
> > +		if (buffer_pos >= runtime->buffer_size)
> > +			buffer_pos -= runtime->buffer_size;
> > +
> > +		if (period_pos >= runtime->period_size) {
> > +			period_pos -= runtime->period_size;
> > +			period_elapsed = 1;
> > +		}
> > +	}
> > +
> > +	snd_pcm_stream_lock(substream);
> > +
> > +	chip->snd_buffer_pos = buffer_pos;
> > +	chip->snd_period_pos = period_pos;
> > +
> > +	snd_pcm_stream_unlock(substream);
> > +
> > +	if (period_elapsed)
> > +		snd_pcm_period_elapsed(substream);
> > +
> > +	usb_submit_urb(urb, GFP_ATOMIC);
> > +}
> > +
> > +static int usbtv_audio_start(struct usbtv *chip)
> > +{
> > +	unsigned int pipe;
> > +	static const u16 setup[][2] = {
> > +		/* These seem to enable the device. */
> > +		{ USBTV_BASE + 0x0008, 0x0001 },
> > +		{ USBTV_BASE + 0x01d0, 0x00ff },
> > +		{ USBTV_BASE + 0x01d9, 0x0002 },
> > +
> > +		{ USBTV_BASE + 0x01da, 0x0013 },
> > +		{ USBTV_BASE + 0x01db, 0x0012 },
> > +		{ USBTV_BASE + 0x01e9, 0x0002 },
> > +		{ USBTV_BASE + 0x01ec, 0x006c },
> > +		{ USBTV_BASE + 0x0294, 0x0020 },
> > +		{ USBTV_BASE + 0x0255, 0x00cf },
> > +		{ USBTV_BASE + 0x0256, 0x0020 },
> > +		{ USBTV_BASE + 0x01eb, 0x0030 },
> > +		{ USBTV_BASE + 0x027d, 0x00a6 },
> > +		{ USBTV_BASE + 0x0280, 0x0011 },
> > +		{ USBTV_BASE + 0x0281, 0x0040 },
> > +		{ USBTV_BASE + 0x0282, 0x0011 },
> > +		{ USBTV_BASE + 0x0283, 0x0040 },
> > +		{ 0xf891, 0x0010 },
> > +
> > +		/* this sets the input from composite */
> > +		{ USBTV_BASE + 0x0284, 0x00aa },
> > +	};
> > +
> > +	chip->snd_bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
> > +	if (chip->snd_bulk_urb == NULL)
> > +		goto err_alloc_urb;
> > +
> > +	pipe = usb_rcvbulkpipe(chip->udev, USBTV_AUDIO_ENDP);
> > +
> > +	chip->snd_bulk_urb->transfer_buffer = kzalloc(
> > +		USBTV_AUDIO_URBSIZE, GFP_KERNEL);
> > +	if (chip->snd_bulk_urb->transfer_buffer == NULL)
> > +		goto err_transfer_buffer;
> > +
> > +	usb_fill_bulk_urb(chip->snd_bulk_urb, chip->udev, pipe,
> > +		chip->snd_bulk_urb->transfer_buffer, USBTV_AUDIO_URBSIZE,
> > +		usbtv_audio_urb_received, chip);
> > +
> > +	/* starting the stream */
> > +	usbtv_set_regs(chip, setup, ARRAY_SIZE(setup));
> > +
> > +	usb_clear_halt(chip->udev, pipe);
> > +	usb_submit_urb(chip->snd_bulk_urb, GFP_ATOMIC);
> > +
> > +	return 0;
> > +
> > +err_transfer_buffer:
> > +	usb_free_urb(chip->snd_bulk_urb);
> > +	chip->snd_bulk_urb = NULL;
> > +
> > +err_alloc_urb:
> > +	return -ENOMEM;
> > +}
> > +
> > +static int usbtv_audio_stop(struct usbtv *chip)
> > +{
> > +	static const u16 setup[][2] = {
> > +	/* The original windows driver sometimes sends also:
> > +	 *   { USBTV_BASE + 0x00a2, 0x0013 }
> > +	 * but it seems useless and its real effects are untested at
> > +	 * the moment.
> > +	 */
> > +		{ USBTV_BASE + 0x027d, 0x0000 },
> > +		{ USBTV_BASE + 0x0280, 0x0010 },
> > +		{ USBTV_BASE + 0x0282, 0x0010 },
> > +	};
> > +
> > +	if (chip->snd_bulk_urb) {
> > +		usb_kill_urb(chip->snd_bulk_urb);
> > +		kfree(chip->snd_bulk_urb->transfer_buffer);
> > +		usb_free_urb(chip->snd_bulk_urb);
> > +		chip->snd_bulk_urb = NULL;
> > +	}
> > +
> > +	usbtv_set_regs(chip, setup, ARRAY_SIZE(setup));
> > +
> > +	return 0;
> > +}
> > +
> > +void usbtv_audio_suspend(struct usbtv *usbtv)
> > +{
> > +	if (atomic_read(&usbtv->snd_stream) && usbtv->snd_bulk_urb)
> > +		usb_kill_urb(usbtv->snd_bulk_urb);
> > +}
> > +
> > +void usbtv_audio_resume(struct usbtv *usbtv)
> > +{
> > +	if (atomic_read(&usbtv->snd_stream) && usbtv->snd_bulk_urb)
> > +		usb_submit_urb(usbtv->snd_bulk_urb, GFP_ATOMIC);
> > +}
> > +
> > +static void snd_usbtv_trigger(struct work_struct *work)
> > +{
> > +	struct usbtv *chip = container_of(work, struct usbtv, snd_trigger);
> > +
> > +	if (atomic_read(&chip->snd_stream))
> > +		usbtv_audio_start(chip);
> > +	else
> > +		usbtv_audio_stop(chip);
> > +}
> > +
> > +static int snd_usbtv_card_trigger(struct snd_pcm_substream *substream, int cmd)
> > +{
> > +	struct usbtv *chip = snd_pcm_substream_chip(substream);
> > +
> > +	switch (cmd) {
> > +	case SNDRV_PCM_TRIGGER_START:
> > +	case SNDRV_PCM_TRIGGER_RESUME:
> > +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> > +		atomic_set(&chip->snd_stream, 1);
> > +		break;
> > +	case SNDRV_PCM_TRIGGER_STOP:
> > +	case SNDRV_PCM_TRIGGER_SUSPEND:
> > +	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> > +		atomic_set(&chip->snd_stream, 0);
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	schedule_work(&chip->snd_trigger);
> > +
> > +	return 0;
> > +}
> > +
> > +static snd_pcm_uframes_t snd_usbtv_pointer(struct snd_pcm_substream *substream)
> > +{
> > +	struct usbtv *chip = snd_pcm_substream_chip(substream);
> > +	return chip->snd_buffer_pos;
> > +}
> > +
> > +static struct snd_pcm_ops snd_usbtv_pcm_ops = {
> > +	.open = snd_usbtv_pcm_open,
> > +	.close = snd_usbtv_pcm_close,
> > +	.ioctl = snd_pcm_lib_ioctl,
> > +	.hw_params = snd_usbtv_hw_params,
> > +	.hw_free = snd_usbtv_hw_free,
> > +	.prepare = snd_usbtv_prepare,
> > +	.trigger = snd_usbtv_card_trigger,
> > +	.pointer = snd_usbtv_pointer,
> > +};
> > +
> > +int usbtv_audio_init(struct usbtv *usbtv)
> > +{
> > +	int rv;
> > +	struct snd_card *card;
> > +	struct snd_pcm *pcm;
> > +
> > +	INIT_WORK(&usbtv->snd_trigger, snd_usbtv_trigger);
> > +	atomic_set(&usbtv->snd_stream, 0);
> > +
> > +	rv = snd_card_create(SNDRV_DEFAULT_IDX1, "usbtv", THIS_MODULE, 0,
> > +		&card);
> > +	if (rv < 0)
> > +		return rv;
> > +
> > +	strlcpy(card->driver, usbtv->dev->driver->name, sizeof(card->driver));
> > +	strlcpy(card->shortname, "usbtv", sizeof(card->shortname));
> > +	snprintf(card->longname, sizeof(card->longname),
> > +		"USBTV Audio at bus %d device %d", usbtv->udev->bus->busnum,
> > +		usbtv->udev->devnum);
> > +
> > +	snd_card_set_dev(card, usbtv->dev);
> > +
> > +	usbtv->snd = card;
> > +
> > +	rv = snd_pcm_new(card, "USBTV Audio", 0, 0, 1, &pcm);
> > +	if (rv < 0)
> > +		goto err;
> > +
> > +	strlcpy(pcm->name, "USBTV Audio Input", sizeof(pcm->name));
> > +	pcm->info_flags = 0;
> > +	pcm->private_data = usbtv;
> > +
> > +	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_usbtv_pcm_ops);
> > +	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_CONTINUOUS,
> > +		snd_dma_continuous_data(GFP_KERNEL), USBTV_AUDIO_BUFFER,
> > +		USBTV_AUDIO_BUFFER);
> > +
> > +	rv = snd_card_register(card);
> > +	if (rv)
> > +		goto err;
> > +
> > +	return 0;
> > +
> > +err:
> > +	usbtv->snd = NULL;
> > +	snd_card_free(card);
> > +
> > +	return rv;
> > +}
> > +
> > +void usbtv_audio_free(struct usbtv *usbtv)
> > +{
> > +	if (usbtv->snd && usbtv->udev) {
> > +		snd_card_free(usbtv->snd);
> > +		usbtv->snd = NULL;
> > +	}
> > +}
> > diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
> > index e89e48b..bdc920c 100644
> > --- a/drivers/media/usb/usbtv/usbtv-core.c
> > +++ b/drivers/media/usb/usbtv/usbtv-core.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Fushicai USBTV007 Video Grabber Driver
> > + * Fushicai USBTV007 Audio-Video Grabber Driver
> >   *
> >   * Product web site:
> >   * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
> > @@ -86,12 +86,19 @@ static int usbtv_probe(struct usb_interface *intf,
> >  	if (ret < 0)
> >  		goto usbtv_video_fail;
> >  
> > +	ret = usbtv_audio_init(usbtv);
> > +	if (ret < 0)
> > +		goto usbtv_audio_fail;
> > +
> >  	/* for simplicity we exploit the v4l2_device reference counting */
> >  	v4l2_device_get(&usbtv->v4l2_dev);
> >  
> > -	dev_info(dev, "Fushicai USBTV007 Video Grabber\n");
> > +	dev_info(dev, "Fushicai USBTV007 Audio-Video Grabber\n");
> >  	return 0;
> >  
> > +usbtv_audio_fail:
> > +	usbtv_video_free(usbtv);
> > +
> >  usbtv_video_fail:
> >  	kfree(usbtv);
> >  
> > @@ -106,6 +113,7 @@ static void usbtv_disconnect(struct usb_interface *intf)
> >  	if (!usbtv)
> >  		return;
> >  
> > +	usbtv_audio_free(usbtv);
> >  	usbtv_video_free(usbtv);
> >  
> >  	usb_put_dev(usbtv->udev);
> > @@ -122,8 +130,8 @@ struct usb_device_id usbtv_id_table[] = {
> >  };
> >  MODULE_DEVICE_TABLE(usb, usbtv_id_table);
> >  
> > -MODULE_AUTHOR("Lubomir Rintel");
> > -MODULE_DESCRIPTION("Fushicai USBTV007 Video Grabber Driver");
> > +MODULE_AUTHOR("Lubomir Rintel, Federico Simoncelli");
> > +MODULE_DESCRIPTION("Fushicai USBTV007 Audio-Video Grabber Driver");
> >  MODULE_LICENSE("Dual BSD/GPL");
> >  
> >  struct usb_driver usbtv_usb_driver = {
> > diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> > index 496bc2e..da604fa 100644
> > --- a/drivers/media/usb/usbtv/usbtv-video.c
> > +++ b/drivers/media/usb/usbtv/usbtv-video.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Fushicai USBTV007 Video Grabber Driver
> > + * Fushicai USBTV007 Audio-Video Grabber Driver
> >   *
> >   * Product web site:
> >   * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
> > @@ -79,7 +79,6 @@ static int usbtv_select_input(struct usbtv *usbtv, int input)
> >  		{ USBTV_BASE + 0x011f, 0x00f2 },
> >  		{ USBTV_BASE + 0x0127, 0x0060 },
> >  		{ USBTV_BASE + 0x00ae, 0x0010 },
> > -		{ USBTV_BASE + 0x0284, 0x00aa },
> >  		{ USBTV_BASE + 0x0239, 0x0060 },
> >  	};
> >  
> > @@ -88,7 +87,6 @@ static int usbtv_select_input(struct usbtv *usbtv, int input)
> >  		{ USBTV_BASE + 0x011f, 0x00ff },
> >  		{ USBTV_BASE + 0x0127, 0x0060 },
> >  		{ USBTV_BASE + 0x00ae, 0x0030 },
> > -		{ USBTV_BASE + 0x0284, 0x0088 },
> >  		{ USBTV_BASE + 0x0239, 0x0060 },
> >  	};
> >  
> > @@ -225,7 +223,6 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
> >  		{ USBTV_BASE + 0x0159, 0x0006 },
> >  		{ USBTV_BASE + 0x015d, 0x0000 },
> >  
> > -		{ USBTV_BASE + 0x0284, 0x0088 },
> >  		{ USBTV_BASE + 0x0003, 0x0004 },
> >  		{ USBTV_BASE + 0x0100, 0x00d3 },
> >  		{ USBTV_BASE + 0x0115, 0x0015 },
> > @@ -434,6 +431,8 @@ static int usbtv_start(struct usbtv *usbtv)
> >  	int i;
> >  	int ret;
> >  
> > +	usbtv_audio_suspend(usbtv);
> > +
> >  	ret = usb_set_interface(usbtv->udev, 0, 0);
> >  	if (ret < 0)
> >  		return ret;
> > @@ -446,6 +445,8 @@ static int usbtv_start(struct usbtv *usbtv)
> >  	if (ret < 0)
> >  		return ret;
> >  
> > +	usbtv_audio_resume(usbtv);
> > +
> >  	for (i = 0; i < USBTV_ISOC_TRANSFERS; i++) {
> >  		struct urb *ip;
> >  
> > diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
> > index 536343d..8cb69ea 100644
> > --- a/drivers/media/usb/usbtv/usbtv.h
> > +++ b/drivers/media/usb/usbtv/usbtv.h
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Fushicai USBTV007 Video Grabber Driver
> > + * Fushicai USBTV007 Audio-Video Grabber Driver
> >   *
> >   * Copyright (c) 2013 Lubomir Rintel
> >   * All rights reserved.
> > @@ -27,6 +27,7 @@
> >  
> >  /* Hardware. */
> >  #define USBTV_VIDEO_ENDP	0x81
> > +#define USBTV_AUDIO_ENDP	0x83
> >  #define USBTV_BASE		0xc000
> >  #define USBTV_REQUEST_REG	12
> >  
> > @@ -38,6 +39,10 @@
> >  #define USBTV_CHUNK_SIZE	256
> >  #define USBTV_CHUNK		240
> >  
> > +#define USBTV_AUDIO_URBSIZE	20480
> > +#define USBTV_AUDIO_HDRSIZE	4
> > +#define USBTV_AUDIO_BUFFER	65536
> > +
> >  /* Chunk header. */
> >  #define USBTV_MAGIC_OK(chunk)	((be32_to_cpu(chunk[0]) & 0xff000000) \
> >  							== 0x88000000)
> > @@ -90,9 +95,23 @@ struct usbtv {
> >  	int iso_size;
> >  	unsigned int sequence;
> >  	struct urb *isoc_urbs[USBTV_ISOC_TRANSFERS];
> > +
> > +	/* audio */
> > +	struct snd_card *snd;
> > +	struct snd_pcm_substream *snd_substream;
> > +	atomic_t snd_stream;
> > +	struct work_struct snd_trigger;
> > +	struct urb *snd_bulk_urb;
> > +	size_t snd_buffer_pos;
> > +	size_t snd_period_pos;
> >  };
> >  
> >  int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size);
> >  
> >  int usbtv_video_init(struct usbtv *usbtv);
> >  void usbtv_video_free(struct usbtv *usbtv);
> > +
> > +int usbtv_audio_init(struct usbtv *usbtv);
> > +void usbtv_audio_free(struct usbtv *usbtv);
> > +void usbtv_audio_suspend(struct usbtv *usbtv);
> > +void usbtv_audio_resume(struct usbtv *usbtv);

Thank you,
Lubo

