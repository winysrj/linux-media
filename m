Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:30287 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPS7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 14:59:16 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7900I09ZER2PA0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Jun 2014 14:59:15 -0400 (EDT)
Date: Mon, 16 Jun 2014 15:59:09 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
	alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
Message-id: <20140616155909.20acc269.m.chehab@samsung.com>
In-reply-to: <539F2652.8030201@gmail.com>
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
 <1402762571-6316-2-git-send-email-m.chehab@samsung.com>
 <539E9F25.7030504@ladisch.de> <20140616112110.3f509262.m.chehab@samsung.com>
 <539F017C.90408@gmail.com> <20140616132428.78edf63c.m.chehab@samsung.com>
 <539F2652.8030201@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Jun 2014 23:16:02 +0600
"Alexander E. Patrakov" <patrakov@gmail.com> escreveu:

> 16.06.2014 22:24, Mauro Carvalho Chehab wrote:
> > Em Mon, 16 Jun 2014 20:38:52 +0600
> > "Alexander E. Patrakov" <patrakov@gmail.com> escreveu:
> >
> >> 16.06.2014 20:21, Mauro Carvalho Chehab wrote:
> >>> Both xawtv and tvtime use the same code for audio:
> >>> 	http://git.linuxtv.org/cgit.cgi/xawtv3.git/tree/common/alsa_stream.c
> >>>
> >>> There's an algorithm there that gets the period size form both the
> >>> capture and the playback cards, trying to find a minimum period that
> >>> would work properly for both.
> >>
> >> I don't see any adaptive resampler (similar to what module-loopback does
> >> in pulseaudio) there.
> >
> > Are you referring to changing the sample rate? This doesn't
> > affect my test scenario, as the playback interface supports the
> > only PCM format/rate used by the TV card (48kHz, 16 bits/sample, stereo):
> >
> > Codec: Realtek ALC269VC
> > Default PCM:
> >      rates [0x5f0]: 32000 44100 48000 88200 96000 192000
> >      bits [0xe]: 16 20 24
> >      formats [0x1]: PCM
> 
> No, it doesn't. The card only pretends to give out samples at 48000 Hz, 
> but, due to the imperfect quartz, actually gives them out at something 
> like 48010 or 47990 Hz (if we take the Realtek's idea of 48 kHz as the 
> source of truth), and that even changes slightly due to thermal issues. 
> The goal here is to measure the actual sample rate and to resample from 
> it to 48 kHz. 

I see. Well, you're talking about a xrun that would happen after several
seconds, and caused by a clock drift between capture and playback xtals.

The issue we're facing happens dozen of times a second, and it is caused
by something else: despiste what period_size says, with this board, the
sampling period is not continuous.

The reason for that is simple: 1ms is the minimal interval for this
board can feed interrupts, and the minimal period size = 192 bytes
(as anything lower than 192 bytes would cause data to be dropped).

As the maximum limit per URB transfer is 3072 bytes (12 URB packs,
with 256 bytes each), we have:

	Period time = (num_bytes + 191) / 192 ms

For num_bytes between 192 and 3072.

After 3072, the URB endpoint will always use 3072 bytes per URB
transfer, with takes 16 ms to be filled.

So, the period time is given by:
	Period time = (num_bytes / 3072) * 16 ms

In other words, the period ranges from 1 to 16 ms, in 1ms step,
up to 3072 bytes. After that, the period is always multiple of
16 ms.

Trying to set it to any value between 17 ms and 31 ms causes xruns,
because the buffer will only be filled the next time the URB callback
is called (and this happens on every 16 ms).

That's what happens with xawtv currently: while the hardware has a
16ms-multiple constraint for the period size, but as there's no 
constraints at the ALSA Kernel code enforcing a period size 
multiple of 16 ms, xawtv will set it to its default latency (30 ms).

That works fine for the first transfer, but it gets an underrun
before the second one. So, we have about 30 underruns per second.

There's nothing that can be done on userspace, as the 16 ms multiple
request is specific to this card. Other cards use different URB
constraints, as different maxsize and/or different number of URBs
would result on a different period size.

So, changing it in userspace from one card breaks for the others.

> The "alsaloop" program (part of alsa-utils), when compiled 
> with libsamplerate, does exactly that. If GPLv2+ is OK for you, you can 
> copy the code.

After having this big xrun issue fixed, I'll look into it. I need
to check if xawtv/tvtime license is GPLv2.

> >> Without that, or dynamically controlling the audio
> >> capture clock PLL in the tuner, xruns are unavoidable when transferring
> >> data between two unrelated cards.
> >
> > What do you mean by dynamically controlling the audio capture clock PLL
> > in the tuner? That doesn't make any sense to me.
> 
> Some chips (e.g. SAA7133) have a register that allows fine-tuning the 
> actual rate at which they sample the sound (while applications still 
> think that it is nominally at 32 kHz). This register is not exposed at 
> the ALSA level, but exposed as the "audio_clock_tweak" parameter of the 
> saa7134 module. Linux applications normally don't use this register, but 
> Windows uses this register as follows.
> 
> The official TV playback application, found on the CD with drivers, 
> captures samples from the card into its buffer, and plays from the other 
> end of the buffer concurrently. If there are, on average for a few 
> seconds, too few samples in the buffer, it means that they are consumed 
> faster than they arrive, and so the SAA chip is told to produce them a 
> bit faster. If they accumulate too much, the SAA chip is told to produce 
> them slower. That's it.

Ok. Well, xc5000 (with does the audio sampling) doesn't have it, AFAIKT.

> >
> > The xc5000 tuner used on this TV device doesn't provide any mechanism
> > to control audio PLL. It just sends the audio samples to au0828 via a
> > I2S bus. All the audio control is done by the USB bridge at au0828,
> > and that is pretty much limited. The only control that au0828 accepts
> > is the control of the URB buffers (e. g., number of URB packets and
> > URB size).
> 
> OK, as you can't tweak the PLL, you have to resample. The idea is, 
> again, simple. Record samples to a buffer if you can, and play them 
> through a variable-rate resampler concurrently if you can. You can use 
> poll() to figure out the "if you can" part. If samples accumulate too 
> much or if the buffer becomes too empty, change the resampling ratio 
> slightly in order to compensate. As I said, the code is here:
> 
> http://git.alsa-project.org/?p=alsa-utils.git;a=tree;f=alsaloop
> 

Ok, I'll look into it after fixing this issue.

Regards,
Mauro
