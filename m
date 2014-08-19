Return-path: <linux-media-owner@vger.kernel.org>
Received: from dehamd003.servertools24.de ([31.47.254.18]:49702 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbaHSNxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 09:53:43 -0400
Message-ID: <53F356E4.30602@ladisch.de>
Date: Tue, 19 Aug 2014 15:53:40 +0200
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Federico Simoncelli <federico.simoncelli@gmail.com>
CC: Lubomir Rintel <lkundrak@v3.sk>, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Federico Simoncelli <fsimonce@redhat.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [alsa-devel] [PATCH] usbtv: add audio support
References: <1407303961.26078.1.camel@v3.sk>
	<1407793342-18540-1-git-send-email-federico.simoncelli@gmail.com>
In-Reply-To: <1407793342-18540-1-git-send-email-federico.simoncelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Federico Simoncelli wrote:
> +++ b/drivers/media/usb/usbtv/usbtv-audio.c
> ...
> +#include <sound/ac97_codec.h>

What do you need this header for?

> +static struct snd_pcm_hardware snd_usbtv_digital_hw = {
> +	...
> +	.period_bytes_min = 11059,
> +	.period_bytes_max = 13516,
> +	.periods_max = 98,
> +	.buffer_bytes_max = 62720 * 8, /* value in usbaudio.c */

Where do these values come from?  (There is no "usbaudio.c" file.)

> +static int snd_usbtv_pcm_close(struct snd_pcm_substream *substream)
> +{
> +	if (atomic_read(&chip->snd_stream)) {
> +		atomic_set(&chip->snd_stream, 0);

Doing _two_ atomic operations is racy.

You probably want a function like test_and_clear_bit().

> +		schedule_work(&chip->snd_trigger);

The device must be closed when the .close callback returns.

> +static void usbtv_audio_urb_received(struct urb *urb)
> +{
> +	struct usbtv *chip = urb->context;
> +	struct snd_pcm_substream *substream = chip->snd_substream;
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	size_t i, frame_bytes, chunk_length, buffer_pos, period_pos;
> +	int period_elapsed;
> +	void *urb_current;
> +
> +	if (!atomic_read(&chip->snd_stream))
> +		return;

And what if the device is closed in the middle of this function?

> +	snd_pcm_stream_lock(substream);
> +
> +	chip->snd_buffer_pos = buffer_pos;
> +	chip->snd_period_pos = period_pos;
> +
> +	snd_pcm_stream_unlock(substream);

What is the purpose of this lock (besides introducing the
chance of a deadlock)?

> +static int usbtv_audio_start(struct usbtv *chip)
> +{
> ...
> +	chip->snd_bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (chip->snd_bulk_urb == NULL)
> +		goto err_alloc_urb;
> +
> +	pipe = usb_rcvbulkpipe(chip->udev, USBTV_AUDIO_ENDP);
> +
> +	chip->snd_bulk_urb->transfer_buffer = kzalloc(

Mapping this buffer repeatedly is inefficient.
Better use usb_alloc_coherent().

> +		USBTV_AUDIO_URBSIZE, GFP_KERNEL);
> +	if (chip->snd_bulk_urb->transfer_buffer == NULL)
> +		goto err_transfer_buffer;
> +
> +	usb_fill_bulk_urb(chip->snd_bulk_urb, chip->udev, pipe,
> +		chip->snd_bulk_urb->transfer_buffer, USBTV_AUDIO_URBSIZE,
> +		usbtv_audio_urb_received, chip);
> +
> +	/* starting the stream */
> +	usbtv_set_regs(chip, setup, ARRAY_SIZE(setup));
> +
> +	usb_clear_halt(chip->udev, pipe);

Allocating resources should be done in the .hw_params and/or .prepare
callbacks.  The .trigger callback should do as little as possible.

> +	usb_submit_urb(chip->snd_bulk_urb, GFP_ATOMIC);

For this single call, you don't need a workqueue.

> +static int usbtv_audio_stop(struct usbtv *chip)
> +{
> ...
> +	if (chip->snd_bulk_urb) {
> +		usb_kill_urb(chip->snd_bulk_urb);
> +		kfree(chip->snd_bulk_urb->transfer_buffer);
> +		usb_free_urb(chip->snd_bulk_urb);
> +		chip->snd_bulk_urb = NULL;
> +	}
> +
> +	usbtv_set_regs(chip, setup, ARRAY_SIZE(setup));

Freeing resources should be done in the .hw_free and .close callbacks.

> +void usbtv_audio_suspend(struct usbtv *usbtv)
> +{
> +	if (atomic_read(&usbtv->snd_stream) && usbtv->snd_bulk_urb)

Both tests are racy.

> +static int snd_usbtv_card_trigger(struct snd_pcm_substream *substream, int cmd)
> +...
> +	case SNDRV_PCM_TRIGGER_RESUME:

This driver does not actually support resuming a PCM device from the
position where it stopped playing.

> +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:

This driver does not actually support pausing a PCM device.
You must at least set the correct SNDRC_PCM_INFO_ flags.

> +int usbtv_audio_init(struct usbtv *usbtv)
> +	...
> +	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_CONTINUOUS,
> +		snd_dma_continuous_data(GFP_KERNEL), USBTV_AUDIO_BUFFER,
> +		USBTV_AUDIO_BUFFER);

You are not doing DMA to the ALSA buffer, so there is no need for it to
be physically contiguous.  Better use a vmalloc()-ed buffer.

> +++ b/drivers/media/usb/usbtv/usbtv.h
> +#define USBTV_AUDIO_URBSIZE	20480
> +#define USBTV_AUDIO_BUFFER	65536

Where do these values come from?

> @@ -91,9 +96,23 @@ struct usbtv {
> +	size_t snd_buffer_pos;
> +	size_t snd_period_pos;

Why size_t?


Regards,
Clemens
