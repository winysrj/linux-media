Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:21598 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAILaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 06:30:05 -0500
Date: Thu, 09 Jan 2014 09:29:57 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Hans de Goede <hdegoede@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	alsa-devel@alsa-project.org, linux-usb@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [alsa-devel] Fw: Isochronous transfer error on USB3
Message-id: <20140109092957.58092c3f@samsung.com>
In-reply-to: <52CE5B09.6070203@ladisch.de>
References: <20140108164800.70ea4169@samsung.com> <52CE5B09.6070203@ladisch.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 09 Jan 2014 09:17:13 +0100
Clemens Ladisch <clemens@ladisch.de> escreveu:

> Mauro Carvalho Chehab wrote:
> > I'm getting an weird behavior with em28xx, especially when the device
> > is connected into an audio port.
> >
> > 	http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/em28xx-v4l2-v6:/drivers/media/usb/em28xx/em28xx-audio.c
> >
> > What happens is that, when I require xawtv3 to use any latency lower
> > than 65 ms, the audio doesn't work, as it gets lots of underruns per
> > second.
> 
> The driver uses five URBs with 64 frames each, so of course it
> will not be able to properly handle periods smaller than that.
> 
> > FYI, em28xx works at a 48000 KHz sampling rate, and its PM capture Hw
> > is described as:
> >
> > static struct snd_pcm_hardware snd_em28xx_hw_capture = {
> > 	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
> > 		SNDRV_PCM_INFO_MMAP           |
> > 		SNDRV_PCM_INFO_INTERLEAVED    |
> > 		SNDRV_PCM_INFO_BATCH	      |
> > 		SNDRV_PCM_INFO_MMAP_VALID,
> >
> > 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
> >
> > 	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,
> 
> This should be just SNDRV_PCM_RATE_48000.

Ok.

> 
> > 	.period_bytes_min = 64,		/* 12544/2, */
> 
> This is wrong (if the driver doesn't install other constraints on the
> period length, like the USB audio class driver does).

Ok, how should it be estimated? Those values here were simply glued from
the USB audio class driver a long time ago without a further analysis.

I changed it to 188 (the minimum URB size I experimentally noticed with
the current settings) and it is now working fine with both xHCI and EHCI.

Regards,
Mauro
