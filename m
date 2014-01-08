Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59238 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751565AbaAHUOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 15:14:14 -0500
Date: Wed, 8 Jan 2014 15:14:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Hans de Goede <hdegoede@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
	<alsa-devel@alsa-project.org>, <linux-usb@vger.kernel.org>
Subject: Re: Fw: Isochronous transfer error on USB3
In-Reply-To: <20140108164800.70ea4169@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1401081508210.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 8 Jan 2014, Mauro Carvalho Chehab wrote:

> Hi Hans/Takashi,
> 
> I'm getting an weird behavior with em28xx, especially when the device
> is connected into an audio port.
> 
> I'm using, on my tests, an em28xx HVR-950 device, using this tree:
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/em28xx-v4l2-v6
> Where the alsa driver is at:
> 	http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/em28xx-v4l2-v6:/drivers/media/usb/em28xx/em28xx-audio.c
> 
> I'm testing it with xawtv3 (http://git.linuxtv.org/xawtv3.git). The
> ALSA userspace code there is at:
> 	http://git.linuxtv.org/xawtv3.git/blob/HEAD:/common/alsa_stream.c
> 
> What happens is that, when I require xawtv3 to use any latency lower 
> than 65 ms, the audio doesn't work, as it gets lots of underruns per
> second. 
> 
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
> 
> 	.rate_min = 48000,
> 	.rate_max = 48000,
> 	.channels_min = 2,
> 	.channels_max = 2,
> 	.buffer_bytes_max = 62720 * 8,	/* just about the value in usbaudio.c */
> 	.period_bytes_min = 64,		/* 12544/2, */
> 	.period_bytes_max = 12544,
> 	.periods_min = 2,
> 	.periods_max = 98,		/* 12544, */
> };
> 
> On my tests, I experimentally discovered that the minimal latency to
> avoid ALSA library underruns is:
> 	- 65ms when using xHCI;
> 	- 25ms when using EHCI.
> 
> Any latency lower than that causes lots of overruns. Very high
> latency also causes overruns (but on a lower rate, as the period
> is bigger).
> 
> I'm wandering if is there anything that could be done either at Kernel
> side or at userspace side to automatically get some configuration that
> works as-is, without requiring the user to play with the latency parameter
> by hand.
> 
> The alsa-info data is enclosed.
> 
> Thank you!
> Mauro
> 
> PS.: I'm still trying to understand why the minimal allowed latency is
> different when using xHCI, but I suspect that it is because it uses a
> different urb->interval than EHCI.

You may be able to answer some of these questions by collecting usbmon 
traces (see Documentation/usb/usbmon.txt).  That would help pinpoint 
sources of latency and tell you the actual URB intervals.

25 ms to avoid underruns seems pretty large.  Other people, using audio 
only (no video), find that EHCI can work well with latencies as low as 
2 ms or so.  (That's using 3.13-rc, which includes some changes in the 
snd-usb-audio driver.)

Alan Stern

