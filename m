Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:26066 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPOVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 10:21:18 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N790032YMJGF840@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Jun 2014 10:21:16 -0400 (EDT)
Date: Mon, 16 Jun 2014 11:21:10 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
Message-id: <20140616112110.3f509262.m.chehab@samsung.com>
In-reply-to: <539E9F25.7030504@ladisch.de>
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
 <1402762571-6316-2-git-send-email-m.chehab@samsung.com>
 <539E9F25.7030504@ladisch.de>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Jun 2014 09:39:17 +0200
Clemens Ladisch <clemens@ladisch.de> escreveu:

> (CC stable dropped; this is not how to submit stable patches.)
> 
> Mauro Carvalho Chehab wrote:
> > The Auvitek 0828 chip, used on HVR950Q actually need two
> > quirks and not just one.
> >
> > The first one, already implemented, enforces that it won't have
> > channel swaps at the transfers.
> >
> > However, for TV applications, like xawtv and tvtime, another quirk
> > is needed, in order to enforce that, at least 2 URB transfer
> > intervals will be needed to fill a buffer.
> 
> > +			period = 2 * MAX_URBS * fp->maxpacksize;
> > +			min_period = period * 90 / 100;
> > +			max_period = period * 110 / 100;
> 
> I don't quite understand what you mean with "URB transfer interval".
> 
> All USB audio devices transfer packets in intervals between 125 µs and
> 1000 µs.

In this case, it uses a 1000 µs, as defined at the USB descriptor for the
au0828 devices (bInterval).

FYI, those TV devices are too limited, in terms of audio: they only provide:
	- 48 kHz rate;
	- 16 bits/sample;
	- 2 channels;
	- maxumum URB size: 256 bytes.

Its internal firmware is also too buggy. We needed to add several
workarounds at both analog and digital stream support for some
conditions that caused the chip to stop producing URBs, or made it
to cause ESHUTDOWN errors while streaming.

> MAX_URBS is a somewhat random value that is not directly derived from
> either a hardware or software constraint.

Yes, I noticed that.

> Are you trying to enforce two packets per URB?

No, I'm trying to enforce that it won't complain about underruns,
while keeping the latency constrained.

This is the same kind of fix we needed to do with em28xx-audio.c some
time ago.

In this case, I'm enforcing that the URB callback will receive 3072
samples, and that the PCM timer won't be triggered too early, e. g.
it will wait for the needed time for the URB callback to be called
twice.

> Why are you setting both a minimum and a maximum?

When I wrote em28xx patches, I did several tests with different max
latency constraints. On some cases, when it selected an odd number of
periods, we would still have some troubles. So, it sounds safer to
keep the same type of logic here.

Anyway, just setting the minimum is enough for xawtv/tvtime to work
with the default -alsa-latency parameter.

> Isn't this affected by the constraints of the playback device?

Hard to tell without having a test hardware with different constraints.
All playback hardware I currently have supports 48 kHz rate, and supports
a period size in the range of this 
The application takes those constraints into account
> 
> > Without it, buffer underruns happen when trying to syncronize the
> > audio input from au0828 and the audio playback at the default audio
> > output device.
> 
> This looks like a workaround for a userspace bug that would affect all
> USB audio devices.  What period/buffer sizes are xawtv/tvtime trying to
> use?

Both xawtv and tvtime use the same code for audio:
	http://git.linuxtv.org/cgit.cgi/xawtv3.git/tree/common/alsa_stream.c

There's an algorithm there that gets the period size form both the
capture and the playback cards, trying to find a minimum period that
would work properly for both.

It tries to enforce a choice where the max latency would be constrained.
The max latency is 30ms, by default, but the user can change it via
-alsa-latency parameter.



Regards,
Mauro
