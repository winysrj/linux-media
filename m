Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54190 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaFPRQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 13:16:06 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so6132722wes.33
        for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 10:16:04 -0700 (PDT)
Message-ID: <539F2652.8030201@gmail.com>
Date: Mon, 16 Jun 2014 23:16:02 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
	alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com> <1402762571-6316-2-git-send-email-m.chehab@samsung.com> <539E9F25.7030504@ladisch.de> <20140616112110.3f509262.m.chehab@samsung.com> <539F017C.90408@gmail.com> <20140616132428.78edf63c.m.chehab@samsung.com>
In-Reply-To: <20140616132428.78edf63c.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

16.06.2014 22:24, Mauro Carvalho Chehab wrote:
> Em Mon, 16 Jun 2014 20:38:52 +0600
> "Alexander E. Patrakov" <patrakov@gmail.com> escreveu:
>
>> 16.06.2014 20:21, Mauro Carvalho Chehab wrote:
>>> Both xawtv and tvtime use the same code for audio:
>>> 	http://git.linuxtv.org/cgit.cgi/xawtv3.git/tree/common/alsa_stream.c
>>>
>>> There's an algorithm there that gets the period size form both the
>>> capture and the playback cards, trying to find a minimum period that
>>> would work properly for both.
>>
>> I don't see any adaptive resampler (similar to what module-loopback does
>> in pulseaudio) there.
>
> Are you referring to changing the sample rate? This doesn't
> affect my test scenario, as the playback interface supports the
> only PCM format/rate used by the TV card (48kHz, 16 bits/sample, stereo):
>
> Codec: Realtek ALC269VC
> Default PCM:
>      rates [0x5f0]: 32000 44100 48000 88200 96000 192000
>      bits [0xe]: 16 20 24
>      formats [0x1]: PCM

No, it doesn't. The card only pretends to give out samples at 48000 Hz, 
but, due to the imperfect quartz, actually gives them out at something 
like 48010 or 47990 Hz (if we take the Realtek's idea of 48 kHz as the 
source of truth), and that even changes slightly due to thermal issues. 
The goal here is to measure the actual sample rate and to resample from 
it to 48 kHz. The "alsaloop" program (part of alsa-utils), when compiled 
with libsamplerate, does exactly that. If GPLv2+ is OK for you, you can 
copy the code.

>> Without that, or dynamically controlling the audio
>> capture clock PLL in the tuner, xruns are unavoidable when transferring
>> data between two unrelated cards.
>
> What do you mean by dynamically controlling the audio capture clock PLL
> in the tuner? That doesn't make any sense to me.

Some chips (e.g. SAA7133) have a register that allows fine-tuning the 
actual rate at which they sample the sound (while applications still 
think that it is nominally at 32 kHz). This register is not exposed at 
the ALSA level, but exposed as the "audio_clock_tweak" parameter of the 
saa7134 module. Linux applications normally don't use this register, but 
Windows uses this register as follows.

The official TV playback application, found on the CD with drivers, 
captures samples from the card into its buffer, and plays from the other 
end of the buffer concurrently. If there are, on average for a few 
seconds, too few samples in the buffer, it means that they are consumed 
faster than they arrive, and so the SAA chip is told to produce them a 
bit faster. If they accumulate too much, the SAA chip is told to produce 
them slower. That's it.

>
> The xc5000 tuner used on this TV device doesn't provide any mechanism
> to control audio PLL. It just sends the audio samples to au0828 via a
> I2S bus. All the audio control is done by the USB bridge at au0828,
> and that is pretty much limited. The only control that au0828 accepts
> is the control of the URB buffers (e. g., number of URB packets and
> URB size).

OK, as you can't tweak the PLL, you have to resample. The idea is, 
again, simple. Record samples to a buffer if you can, and play them 
through a variable-rate resampler concurrently if you can. You can use 
poll() to figure out the "if you can" part. If samples accumulate too 
much or if the buffer becomes too empty, change the resampling ratio 
slightly in order to compensate. As I said, the code is here:

http://git.alsa-project.org/?p=alsa-utils.git;a=tree;f=alsaloop

-- 
Alexander E. Patrakov
