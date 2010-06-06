Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:38200 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab0FFXGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 19:06:45 -0400
Subject: Re: correction:  success
From: hermann pitton <hermann-pitton@arcor.de>
To: Alexander Apostolatos <Alexander.Apostolatos@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100604115716.327290@gmx.net>
References: <20100604015932.212640@gmx.net>
	 <1275626370.3140.5.camel@pc07.localdom.local>
	 <20100604115716.327290@gmx.net>
Content-Type: text/plain
Date: Mon, 07 Jun 2010 01:01:59 +0200
Message-Id: <1275865319.3164.71.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexander,

Am Freitag, den 04.06.2010, 13:57 +0200 schrieb Alexander Apostolatos:
> -------- Original-Nachricht --------
> > Datum: Fri, 04 Jun 2010 06:39:30 +0200
> > Von: hermann pitton <hermann-pitton@arcor.de>
> > An: Alexander Apostolatos <Alexander.Apostolatos@gmx.de>
> > CC: linux-media@vger.kernel.org
> > Betreff: Re: success
> 
> > Hi,
> > 
> > Am Freitag, den 04.06.2010, 03:59 +0200 schrieb Alexander Apostolatos:
> > > Hi, had success in activating analog tuner in:
> > > 
> > > http://linuxtv.org/wiki/index.php/DVB-T_PCI_Cards
> > > Philips TV/Radio Card CTX918, (Medion 7134), PCI 
> > > 
> > > In my case, device is labeled:
> > > MEDION
> > > Type: TV-Tuner 7134
> > > V.92 Data/Fax Modem
> > > Rev: CTX918_V2 DVB-T/TV
> > > P/N: 20024179
> > > 
> > > 
> > > Label on tuner (other side of PCB) offers info on tuner type:
> > > Label reads:
> > > 3139 147 22491c#
> > > FMD1216ME/I H-3
> > > SV21 6438

mine is SV21 0437. Guess you have 0438 and both should work as tuner=63.

> > > Made in INONESIA
> > 
> > > So I suppose tuner=78 is the compatible type for FMD1216ME/I H-3,
> > > 
> > > NOT tuner=63 as detected by system. Please check and alter if
> > applicable.
> > > 
> > > Suspect different Hardware revs come with identical hardware ID's.
> > > Will provide additional info if told hot to obtain (hardware ID or
> > whatever), but have to take a nap right now. It's 4 in the morning.
> > 
> > I have such stuff with some known flaws, easily to circumvent.
> > 
> > The CTX918 V2 needs to be in the original dual bus master capable blue
> > MSI/Medion PCI slot.
> > 
> > Else, it can become very tricky.
> > 
> > Cheers,
> > Hermann
> > 
> 
> Hermann, thanks for the reply. 
> I knew of the blue slot from the manufacturer's website, so the device always was in the blue slot.

Good, that is most important.

> However, I have to correct myself. I double checked last night, instead of having a nap and it turned out, that there are preconditions involved for the function of the card:
> 
> in my case, the card works only after provoking a segfault by loading with card=97 Tuner=38 and running eg. tvtime.
> After the ensuing segfault, a modprobe with card=12 and everyone of tuner 38, 63 and 78 yields a working device as it seems.
> 
> This means that after a segfault, the drive works with the parameters passed by autodetect. I have too look into that, find out what exactly the segfault does. However I have a bit of a learning curve to get there.
> 
> I'm currently running ubuntu lucid live and I have to look at the behaviour when installed.
> 
> If You'd like to share Your experiences with the card, especially the easily to convent problems, I'd be very grateful. Especially if it involves getting how to get DVB (T) to work or how to enable dma sound instead of using an audio cable.
> 
> Your's
> 
> Alex

On current kernels the tuner by default is only enabled for DVB-T. 

There are some special bits in tuner core code to enable it for analog
mode, which currently don't come through in the init sequences on first
load.

You will notice in "dmesg" that the analog IF demodulator tda9887 is
missing. You must reload the driver once and it will be there.

You might set options saa7134 alsa=0 in /etc/modprobe.d/saa7134.conf,
else on recent distros the audio daemons might hold use count on
saa7134-alsa and you can't "modprobe -vr saa7134-dvb", which also
unloads saa7134.

On the wiki should be some instructions for saa7134-alsa usage.
http://www.linuxtv.org/wiki/index.php/Saa7134-alsa

On radio autoscan does not work, since the tuner does not provide a
stereo detection bit, but sound is good stereo. Radio sound is better
with audio cable in the red connector.

Cheers,
Hermann








