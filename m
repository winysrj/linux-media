Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:47488 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZIROns (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 10:43:48 -0400
Message-ID: <4AB39AE8.2040502@ladisch.de>
Date: Fri, 18 Sep 2009 16:36:24 +0200
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <cooloney@kernel.org>,
	Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/3] USB gadget: audio class function driver
References: <200909181225.57212.laurent.pinchart@ideasonboard.com> <200909181226.50056.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200909181226.50056.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> +snd_uac_pcm_open(struct snd_pcm_substream *substream, int stream)
> ...
> +	substream->runtime->hw = stream == SNDRV_PCM_STREAM_PLAYBACK
> +			       ? snd_uac_playback_hw
> +			       : snd_uac_capture_hw;
> +	substream->runtime->hw.rate_min = uac->rate;
> +	substream->runtime->hw.rate_max = uac->rate;

The .rates bit mask is supposed to be consistent with the min/max
values; you can use the snd_pcm_rate_to_rate_bit() helper function for
this.

> +snd_uac_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
> ...
> +		spin_lock_irqsave(&subs->lock, flags);
> +		subs->streaming = 1;
> +		spin_unlock_irqrestore(&subs->lock, flags);

The trigger callback is guaranteed to be called with interrupts
disabled; you can use spin_lock/spin_unlock here.

> +int __init uac_audio_init(struct uac_device *uac)
> ...
> +	static int dev = 0;
> ...
> +	ret = snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,

Usually, drivers use index/id module parameters for these parameters.
But if you don't (which is possible), you don't need to count up the
dev variable.

> +uac_audio_encode(struct snd_uac_substream *subs, struct usb_request *req)
> ...
> +	if (!subs->streaming) {
> +		spin_unlock_irqrestore(&subs->lock, flags);
> +		req->length = 0;
> +		return;
> +	}
> +
> +	/* TODO Handle buffer underruns. */

The ALSA framework handles buffer underruns by stopping the stream.
AFAICS this will result in the gadget returning empty packets.

It is also possible for the application (not the driver) to configure
the ALSA PCM device to continue streaming, so that the device plays
either the old contents of the buffer or silence.

The driver doesn't actually get much of an opportunity to handle this.

> +uac_audio_complete(struct usb_ep *ep, struct usb_request *req)
> ...
> +	switch (req->status) {
> +	case 0:
> +		break;
> +
> +	case -ECONNRESET:
> +	case -ESHUTDOWN:
> +		goto requeue;
> +
> +	default:
> +		INFO(uac->func.config->cdev, "AS request completed with "
> +			"status %d.\n", req->status);
> +		goto requeue;
> +	}
> +
> +	uac_audio_encode(subs, req);

Shouldn't the device continue to send packets even if an isochronous
transfer failed?

> +uac_audio_pump(struct uac_device *uac)
> ...
> +	/* FIXME TODO Race between uac_audio_pump and requests completion
> +	 * handler ???
> +	 */

Indeed.  But I guess uac_audio_pump() is called when starting a stream
when you don't yet have any completions?

The USB audio host driver copies samples from the ALSA buffer to the
request buffers only in the request completion handler; streaming gets
started with a bunch of silence packets.  This also has the consequence
that data gets taken out of the buffer at a constant rate.


Best regards,
Clemens
