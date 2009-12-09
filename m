Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930AbZLISwo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 13:52:44 -0500
Message-ID: <4B1FF1FF.6000001@redhat.com>
Date: Wed, 09 Dec 2009 16:52:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 09/11] add audio support for tlg2300
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com> <1258687493-4012-2-git-send-email-shijie8@gmail.com> <1258687493-4012-3-git-send-email-shijie8@gmail.com> <1258687493-4012-4-git-send-email-shijie8@gmail.com> <1258687493-4012-5-git-send-email-shijie8@gmail.com> <1258687493-4012-6-git-send-email-shijie8@gmail.com> <1258687493-4012-7-git-send-email-shijie8@gmail.com> <1258687493-4012-8-git-send-email-shijie8@gmail.com> <1258687493-4012-9-git-send-email-shijie8@gmail.com> <1258687493-4012-10-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-10-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> The module uses ALSA for the audio, it will register
> a new card for tlg2300.

This one seems ok, but it is better to c/c alsa ML also, when adding a new
alsa module, for they to help reviewing it.

> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/media/video/tlg2300/pd-alsa.c |  379 +++++++++++++++++++++++++++++++++
>  1 files changed, 379 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tlg2300/pd-alsa.c
> 
> diff --git a/drivers/media/video/tlg2300/pd-alsa.c b/drivers/media/video/tlg2300/pd-alsa.c
> new file mode 100644
> index 0000000..54a5aaa
> --- /dev/null
> +++ b/drivers/media/video/tlg2300/pd-alsa.c
> @@ -0,0 +1,379 @@
> +#include <linux/kernel.h>
> +#include <linux/usb.h>
> +#include <linux/init.h>
> +#include <linux/sound.h>
> +#include <linux/spinlock.h>
> +#include <linux/soundcard.h>
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
> +#include <linux/proc_fs.h>
> +#include <linux/module.h>
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/pcm_params.h>
> +#include <sound/info.h>
> +#include <sound/initval.h>
> +#include <sound/control.h>
> +#include <media/v4l2-common.h>
> +#include "pd-common.h"
> +#include "vendorcmds.h"
> +
> +static void complete_handler_audio(struct urb *urb);
> +#define ANOLOG_AUDIO_ID	(0)
> +#define FM_ID		(1)
> +#define AUDIO_EP	(0x83)
> +#define AUDIO_BUF_SIZE	(512)
> +#define PERIOD_SIZE	(1024 * 8)
> +#define PERIOD_MIN	(4)
> +#define PERIOD_MAX 	PERIOD_MIN
> +
> +static struct snd_pcm_hardware snd_pd_hw_capture = {
> +	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
> +		SNDRV_PCM_INFO_MMAP           |
> +		SNDRV_PCM_INFO_INTERLEAVED |
> +		SNDRV_PCM_INFO_MMAP_VALID,
> +
> +	.formats = SNDRV_PCM_FMTBIT_S16_LE,
> +	.rates = SNDRV_PCM_RATE_48000,
> +
> +	.rate_min = 48000,
> +	.rate_max = 48000,
> +	.channels_min = 2,
> +	.channels_max = 2,
> +	.buffer_bytes_max = PERIOD_SIZE * PERIOD_MIN,
> +	.period_bytes_min = PERIOD_SIZE,
> +	.period_bytes_max = PERIOD_SIZE,
> +	.periods_min = PERIOD_MIN,
> +	.periods_max = PERIOD_MAX,
> +	/*
> +	.buffer_bytes_max = 62720 * 8,
> +	.period_bytes_min = 64,
> +	.period_bytes_max = 12544,
> +	.periods_min = 2,
> +	.periods_max = 98
> +	*/
> +};
> +
> +static int snd_pd_capture_open(struct snd_pcm_substream *substream)
> +{
> +	struct poseidon *p = snd_pcm_substream_chip(substream);
> +	struct poseidon_audio *pa = &p->audio;
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +
> +	if (!p)
> +		return -ENODEV;
> +	pa->users++;
> +	pa->card_close 		= 0;
> +	pa->capture_pcm_substream	= substream;
> +	runtime->private_data		= p;
> +
> +	runtime->hw = snd_pd_hw_capture;
> +	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
> +	usb_autopm_get_interface(p->interface);
> +	kref_get(&p->kref);
> +	return 0;
> +}
> +
> +static int snd_pd_pcm_close(struct snd_pcm_substream *substream)
> +{
> +	struct poseidon *p = snd_pcm_substream_chip(substream);
> +	struct poseidon_audio *pa = &p->audio;
> +
> +	pa->users--;
> +	pa->card_close 		= 1;
> +	kref_put(&p->kref, poseidon_delete);
> +	usb_autopm_put_interface(p->interface);
> +	return 0;
> +}
> +
> +static int snd_pd_hw_capture_params(struct snd_pcm_substream *substream,
> +					struct snd_pcm_hw_params *hw_params)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	unsigned int size;
> +
> +	size = params_buffer_bytes(hw_params);
> +	if (runtime->dma_area) {
> +		if (runtime->dma_bytes > size)
> +			return 0;
> +		vfree(runtime->dma_area);
> +	}
> +	runtime->dma_area = vmalloc(size);
> +	if (!runtime->dma_area)
> +		return -ENOMEM;
> +	else
> +		runtime->dma_bytes = size;
> +	return 0;
> +}
> +
> +static int audio_buf_free(struct poseidon *p)
> +{
> +	struct poseidon_audio *pa = &p->audio;
> +	int i;
> +
> +	for (i = 0; i < AUDIO_BUFS; i++) {
> +		struct urb *urb = pa->urb[i];
> +
> +		if (!urb)
> +			continue;
> +		usb_buffer_free(p->udev, urb->transfer_buffer_length,
> +				urb->transfer_buffer, urb->transfer_dma);
> +		usb_free_urb(urb);
> +		pa->urb[i] = NULL;
> +	}
> +	return 0;
> +}
> +
> +static int audio_buf_init(struct poseidon *p)
> +{
> +	int       i, ret;
> +	struct poseidon_audio *pa = &p->audio;
> +
> +	for (i = 0; i < AUDIO_BUFS; i++) {
> +		struct urb *urb;
> +		char *mem = NULL;
> +
> +		if (pa->urb[i])
> +			continue;
> +
> +		urb = usb_alloc_urb(0, GFP_ATOMIC);
> +		if (!urb) {
> +			ret = -ENOMEM;
> +			goto init_err;
> +		}
> +		mem = usb_buffer_alloc(p->udev, AUDIO_BUF_SIZE,
> +					GFP_ATOMIC, &urb->transfer_dma);
> +		if (!mem) {
> +			usb_free_urb(urb);
> +			goto init_err;
> +		}
> +		usb_fill_bulk_urb(urb, p->udev,
> +				usb_rcvbulkpipe(p->udev, AUDIO_EP),
> +				mem, AUDIO_BUF_SIZE,
> +				complete_handler_audio,
> +				pa);
> +		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +		pa->urb[i] = urb;
> +	}
> +	return 0;
> +
> +init_err:
> +	audio_buf_free(p);
> +	return ret;
> +}
> +
> +static int snd_pd_hw_capture_free(struct snd_pcm_substream *substream)
> +{
> +	struct poseidon *p = snd_pcm_substream_chip(substream);
> +
> +	audio_buf_free(p);
> +	return 0;
> +}
> +
> +static int snd_pd_prepare(struct snd_pcm_substream *substream)
> +{
> +	return 0;
> +}
> +
> +#define AUDIO_TRAILER_SIZE	(16)
> +static inline void handle_audio_data(struct urb *urb, int *period_elapsed)
> +{
> +	struct poseidon_audio *pa = urb->context;
> +	struct snd_pcm_runtime *runtime = pa->capture_pcm_substream->runtime;
> +
> +	int stride	= runtime->frame_bits >> 3;
> +	int len		= urb->actual_length / stride;
> +	unsigned char *cp	= urb->transfer_buffer;
> +	unsigned int oldptr	= pa->rcv_position;
> +
> +	if (urb->actual_length == AUDIO_BUF_SIZE - 4)
> +		len -= (AUDIO_TRAILER_SIZE / stride);
> +
> +	/* do the copy */
> +	if (oldptr + len >= runtime->buffer_size) {
> +		unsigned int cnt = runtime->buffer_size - oldptr;
> +
> +		memcpy(runtime->dma_area + oldptr * stride, cp, cnt * stride);
> +		memcpy(runtime->dma_area, (cp + cnt * stride),
> +					(len * stride - cnt * stride));
> +	} else
> +		memcpy(runtime->dma_area + oldptr * stride, cp, len * stride);
> +
> +	/* update the statas */
> +	snd_pcm_stream_lock(pa->capture_pcm_substream);
> +	pa->rcv_position	+= len;
> +	if (pa->rcv_position >= runtime->buffer_size)
> +		pa->rcv_position -= runtime->buffer_size;
> +
> +	pa->copied_position += (len);
> +	if (pa->copied_position >= runtime->period_size) {
> +		pa->copied_position -= runtime->period_size;
> +		*period_elapsed = 1;
> +	}
> +	snd_pcm_stream_unlock(pa->capture_pcm_substream);
> +}
> +
> +static void complete_handler_audio(struct urb *urb)
> +{
> +	struct poseidon_audio *pa = urb->context;
> +	struct snd_pcm_substream *substream = pa->capture_pcm_substream;
> +	int    period_elapsed = 0;
> +	int    ret;
> +
> +	if (1 == pa->card_close || pa->capture_stream == STREAM_OFF)
> +		return;
> +
> +	if (urb->status != 0) {
> +		/*if (urb->status == -ESHUTDOWN)*/
> +			return;
> +	}
> +
> +	if (pa->capture_stream == STREAM_ON && substream && !urb->status) {
> +		if (urb->actual_length) {
> +			handle_audio_data(urb, &period_elapsed);
> +			if (period_elapsed)
> +				snd_pcm_period_elapsed(substream);
> +		}
> +	}
> +
> +	ret = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (ret < 0)
> +		log("audio urb failed (errcod = %i)", ret);
> +	return;
> +}
> +
> +static int snd_pd_capture_trigger(struct snd_pcm_substream *substream, int cmd)
> +{
> +	struct poseidon *p = snd_pcm_substream_chip(substream);
> +	struct poseidon_audio *pa = &p->audio;
> +	int i, ret;
> +
> +	if (debug_mode)
> +		log("cmd %d\n", cmd);
> +
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_RESUME:
> +	case SNDRV_PCM_TRIGGER_START:
> +		if (audio_in_hibernate(p))
> +			return 0;
> +		if (pa->capture_stream == STREAM_ON)
> +			return 0;
> +
> +		pa->rcv_position = pa->copied_position = 0;
> +		pa->capture_stream = STREAM_ON;
> +
> +		audio_buf_init(p);
> +		for (i = 0; i < AUDIO_BUFS; i++) {
> +			ret = usb_submit_urb(pa->urb[i], GFP_KERNEL);
> +			if (ret)
> +				log("urb err : %d", ret);
> +		}
> +		return 0;
> +	case SNDRV_PCM_TRIGGER_SUSPEND:
> +	case SNDRV_PCM_TRIGGER_STOP:
> +		pa->capture_stream = STREAM_OFF;
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static snd_pcm_uframes_t
> +snd_pd_capture_pointer(struct snd_pcm_substream *substream)
> +{
> +	struct poseidon *p = snd_pcm_substream_chip(substream);
> +	struct poseidon_audio *pa = &p->audio;
> +	return pa->rcv_position;
> +}
> +
> +static struct page *snd_pcm_pd_get_page(struct snd_pcm_substream *subs,
> +					     unsigned long offset)
> +{
> +	void *pageptr = subs->runtime->dma_area + offset;
> +	return vmalloc_to_page(pageptr);
> +}
> +
> +static struct snd_pcm_ops pcm_capture_ops = {
> +	.open      = snd_pd_capture_open,
> +	.close     = snd_pd_pcm_close,
> +	.ioctl     = snd_pcm_lib_ioctl,
> +	.hw_params = snd_pd_hw_capture_params,
> +	.hw_free   = snd_pd_hw_capture_free,
> +	.prepare   = snd_pd_prepare,
> +	.trigger   = snd_pd_capture_trigger,
> +	.pointer   = snd_pd_capture_pointer,
> +	.page      = snd_pcm_pd_get_page,
> +};
> +
> +#ifdef CONFIG_PM
> +int pm_alsa_suspend(struct poseidon *p)
> +{
> +	struct poseidon_audio *pa = &p->audio;
> +	int i;
> +
> +	snd_pcm_suspend(pa->capture_pcm_substream);
> +
> +	for (i = 0; i < AUDIO_BUFS; i++)
> +		usb_kill_urb(pa->urb[i]);
> +
> +	audio_buf_free(p);
> +	return 0;
> +}
> +
> +int pm_alsa_resume(struct poseidon *p)
> +{
> +	struct poseidon_audio *pa = &p->audio;
> +
> +	if (audio_in_hibernate(p)) {
> +		pa->pm_state = 0;
> +		usb_autopm_get_interface(p->interface);
> +	}
> +	snd_pd_capture_trigger(pa->capture_pcm_substream,
> +				SNDRV_PCM_TRIGGER_START);
> +	return 0;
> +}
> +#endif
> +
> +int poseidon_audio_init(struct poseidon *p)
> +{
> +	struct poseidon_audio *pa = &p->audio;
> +	struct snd_card *card;
> +	struct snd_pcm *pcm;
> +	int ret;
> +
> +	if (audio_in_hibernate(p))
> +		return 0;
> +
> +	ret = snd_card_create(-1, "poseidon_audio", THIS_MODULE, 0, &card);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = snd_pcm_new(card, "poseidon audio", 0, 0, 1, &pcm);
> +	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &pcm_capture_ops);
> +	pcm->info_flags   = 0;
> +	pcm->private_data = p;
> +	strcpy(pcm->name, "poseidon audio capture");
> +
> +	strcpy(card->driver, "ALSA driver");
> +	strcpy(card->shortname, "poseidon Audio");
> +	strcpy(card->longname, "poseidon ALSA Audio");
> +
> +	if (snd_card_register(card)) {
> +		snd_card_free(card);
> +		return -ENOMEM;
> +	}
> +	pa->card = card;
> +	return 0;
> +}
> +
> +int poseidon_audio_free(struct poseidon *p)
> +{
> +	struct poseidon_audio *pa = &p->audio;
> +
> +	if (audio_in_hibernate(p))
> +		return 0;
> +
> +	if (pa->card)
> +		snd_card_free(pa->card);
> +	return 0;
> +}

