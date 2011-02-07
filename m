Return-path: <mchehab@pedra>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49114 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751318Ab1BGQBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 11:01:24 -0500
Date: Mon, 7 Feb 2011 16:01:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: matti.j.aaltonen@nokia.com, alsa-devel@alsa-project.org,
	lrg@slimlogic.co.uk, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
Message-ID: <20110207160120.GO10564@opensource.wolfsonmicro.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
 <4D4FDED0.7070008@redhat.com>
 <20110207120234.GE10564@opensource.wolfsonmicro.com>
 <4D4FEA03.7090109@redhat.com>
 <20110207131045.GG10564@opensource.wolfsonmicro.com>
 <4D4FF821.4010701@redhat.com>
 <1297087744.15320.56.camel@masi.mnp.nokia.com>
 <4D501656.5000309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D501656.5000309@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 07, 2011 at 01:57:10PM -0200, Mauro Carvalho Chehab wrote:
> Em 07-02-2011 12:09, Matti J. Aaltonen escreveu:

> > Both children depend on the MFD driver for I/O and the codec also
> > depends on the presence of the radio-wl1273 driver because without the
> > v4l2 part nothing can be done...

> I think that the better would be to move the audio part (sound/soc/codecs/wl1273.c)
> as drivers/media/radio/wl1273/wl1273-alsa.c. Is there any problem on moving it, or
> the alsa driver is also tightly coupled on the rest of the sound/soc stuff?

As I said in my previous e-mail it's tightly coupled.

> I remember that, in the past, there were someone that proposed to move /sound into
> /media/sound, and move some common stuff between them into /media/common.

This is the first embedded audio driver that's had interface with media
stuff, the driver situation for embedded audio is very different to that
for PCs.  Embedded audio subsystems are tightly coupled integrations of
many different devices, the sound card userspace sees is produced by
coordinating the actions of several different drivers.

> Btw, there are(where?) some problems between -alsa and -media subsystems: basically, 
> the audio core needs to be initialized before the drivers. However, this sometimes
> don't happen (I can't remember the exact situation - perhaps builtin compilations?),
> but we ended by needing to explicitly delaying the init of some drivers with:
> 	late_initcall(saa7134_alsa_init); 
> To avoid some OOPS conditions.

This isn't a problem for embedded audio, instantiation of the cards is
deferred until all the components for the card have registered with the
core so nothing will happen until dependencies are satisfied, though it
is a problem with the wl1273 driver as it currently stands due to the
lack of a functional MFD.
