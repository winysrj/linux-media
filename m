Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:54255 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbZKYWMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 17:12:19 -0500
Subject: Re: Tuner drivers
From: hermann pitton <hermann-pitton@arcor.de>
To: rulet1@meta.ua
Cc: linux-media@vger.kernel.org
In-Reply-To: <46842.95.132.81.101.1259175646.metamail@webmail.meta.ua>
References: <1258292980.3235.14.camel@pc07.localdom.local>
	 <58364.95.133.222.95.1258298152.metamail@webmail.meta.ua>
	 <1258314943.3276.3.camel@pc07.localdom.local>
	 <46842.95.132.81.101.1259175646.metamail@webmail.meta.ua>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 23:11:24 +0100
Message-Id: <1259187084.3335.48.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 25.11.2009, 21:00 +0200 schrieb rulet1@meta.ua:
> >
> > Am Sonntag, den 15.11.2009, 17:15 +0200 schrieb rulet1@meta.ua:
> >> > Hi,
> >> >
> >> > Am Sonntag, den 15.11.2009, 14:42 +0200 schrieb rulet1@meta.ua:
> >> >> How to do that?:
> >> >>
> >> >> "You are forced to use saa7134-alsa dma sound"
> >> >>
> >> >
> >> > a problem is that I can't tell for sure which analog TV standard you
> >> > currently use in the Ukraine, either it is still SECAM DK or you
> >> changed
> >> > to some PAL already.
> >> >
> >> > Try to get the details, also about the sound system.
> >> >
> >> > If it is still SECAM DK, you need to force the option "secam=DK".
> >> >
> >> > With "audio_debug=1" you can see if the drivers finds the pilots, the
> >> > first sound carrier and the second carrier and also the stereo system
> >> in
> >> > use. This counts also for PAL standards.
> >> >
> >> > This way you can already see if the driver can lock on the audio
> >> > carriers in "dmesg" without hearing anything yet.
> >> >
> >> > Then saa7134-alsa should provide TV sound on your card.
> >> > http://linuxtv.org/wiki/index.php/Saa7134-alsa
> >> >
> >> > Cheers,
> >> > Hermann
> >> >
> >> >
> >> >
> >> > Where to put the option "secam=DK" on Ubuntu 9.10?
> >> >
> >
> > Don't have it, but would guess /etc/modprobe.d or use a
> > deprecated /etc/modprobe.conf and "depmod -a" or close all mixers using
> > saa7134, "modprobe -vr saa7134-alsa" and "modprobe saa7134 secam=DK".
> >
> > Hermann

> >
> Forget about it, this tuner is just not for Linux...

sorry, sounds pretty frustrated.

But I have no other choice, as to assume for now, that this card with
that tuner is tested by those who did contribute it for sound too, like
more than about 150 other such cards in this driver.

We should have support for global analog TV sound on such, SECAM types
need to be forced by user is the only extra that might hit you.

No other single report for failing TV sound since years now.

Eventually possible scenarios:

1. You have a different card with the same PCI subsystem as the known
   one, but we don't know about that yet. Unlikely for AverMedia.

2. you have a card with saa7133 chip, which can't decode PAL/SECAM
   sound. Should not be available on any shelve in Europe.

Debug route is: first have debug=1 for tda827x and tda8290. You reported
already to have a picture from tuner, so this will report the tuner
"locked" and we can skip that. Then saa7134 audio_debug=1 should report
the TV audio system in use and detected. If detected, audio routing from
tuner is correct and the rest is to properly use saa7134-alsa, since
your card has no analog audio out connected.  

For TV stereo sound decoding capable chips TV sound amux is always TV.

The saa7135 and saa7131e can do it globally, the saa7134 would need
extra chips for System-M/NTSC alike and the saa7133 for PAL/SECAM.

This was always mentioned in the reference designs as a possibility, but
until today no device is known to do such in reality on saa7134 and
saa7133.

Sorry, we don't have any dmesg/logs for it on the lists, but Mauro was
working on the NEC IRQ remote support and most likely has verified
working TV sound at least for System-M, maybe on a saa7133, but I would
expect a saa7131e. (Needs more digging)

Cheers,
Hermann











