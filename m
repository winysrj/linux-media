Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36712 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbaAIIRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jan 2014 03:17:16 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 95D2620B62
	for <linux-media@vger.kernel.org>; Thu,  9 Jan 2014 03:17:15 -0500 (EST)
Message-ID: <52CE5B09.6070203@ladisch.de>
Date: Thu, 09 Jan 2014 09:17:13 +0100
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
	linux-usb@vger.kernel.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [alsa-devel] Fw: Isochronous transfer error on USB3
References: <20140108164800.70ea4169@samsung.com>
In-Reply-To: <20140108164800.70ea4169@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> I'm getting an weird behavior with em28xx, especially when the device
> is connected into an audio port.
>
> 	http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/em28xx-v4l2-v6:/drivers/media/usb/em28xx/em28xx-audio.c
>
> What happens is that, when I require xawtv3 to use any latency lower
> than 65 ms, the audio doesn't work, as it gets lots of underruns per
> second.

The driver uses five URBs with 64 frames each, so of course it
will not be able to properly handle periods smaller than that.

> FYI, em28xx works at a 48000 KHz sampling rate, and its PM capture Hw
> is described as:
>
> static struct snd_pcm_hardware snd_em28xx_hw_capture = {
> 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
> 		SNDRV_PCM_INFO_MMAP           |
> 		SNDRV_PCM_INFO_INTERLEAVED    |
> 		SNDRV_PCM_INFO_BATCH	      |
> 		SNDRV_PCM_INFO_MMAP_VALID,
>
> 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
>
> 	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,

This should be just SNDRV_PCM_RATE_48000.

> 	.period_bytes_min = 64,		/* 12544/2, */

This is wrong (if the driver doesn't install other constraints on the
period length, like the USB audio class driver does).


Regards,
Clemens
