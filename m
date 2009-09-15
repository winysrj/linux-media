Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:48284 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZIOE1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 00:27:50 -0400
Subject: Re: Reliable work-horse capture device?
From: hermann pitton <hermann-pitton@arcor.de>
To: David Liontooth <lionteeth@cogweb.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <4AAF11EC.3040800@cogweb.net>
References: <4AAEFEC9.3080405@cogweb.net>
	 <20090915000841.56c24dd6@pedra.chehab.org>  <4AAF11EC.3040800@cogweb.net>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 06:21:41 +0200
Message-Id: <1252988501.3250.62.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 14.09.2009, 21:02 -0700 schrieb David Liontooth:
> Mauro Carvalho Chehab wrote:
> > Hi David,
> >
> > Em Mon, 14 Sep 2009 19:41:13 -0700
> > David Liontooth <lionteeth@cogweb.net> escreveu:
> >
> >   
> >> We're setting up NTSC cable television capture devices in a handfull of 
> >> remote locations, using four devices to capture around fifty hours a day 
> >> on each location. Capture is scripted and will be ongoing for several 
> >> years. We want to minimize the need for human intervention.
> >>
> >> I'm looking for advice on which capture device to use.  My main 
> >> candidates are ivtv (WinTV PVR 500) and USB, but I've not used any of 
> >> the supported USB devices.
> >>
> >> Are there USB devices that are sufficiently reliable to hold up under 
> >> continuous capture for years? Are the drivers robust?
> >>
> >> I need zvbi-ntsc-cc support, so a big thanks to Michael Krufty for just 
> >> now adding it to em28xx. Do any other USB device chipsets have raw 
> >> closed captioning support?
> >>
> >> I would also consider using the PCIe device Hauppauge WinTV-HVR-2200, 
> >> but I need analog support.
> >>
> >> Appreciate any advice.
> >>     
> >
> > If you look for stability, the most important item is to choose a good stable
> > server distribution, like RHEL5. You'll be better serviced than using a desktop
> > distro with some new (not so stable) kernel and tools.
> >
> > In terms of stability, the PCI devices are generally more reliable, and, among
> > all drivers, bttv is the winner, since it is the older driver, so, in thesis,
> > more bugs were solved on it. That's the reason why several surveillance systems
> > are still today based on bttv. If you need a newer hardware, then you may choose
> > saa7134, cx88 or ivtv devices.
> >
> > I don't recommend using an USB hardware for such hard usage: it will probably
> > have a shorter life (since it is not as ventilated as a PCI device on a
> > server cabinet), and you might experience troubles after long plays. In terms
> > of USB with analog support, em28xx driver is the more stable, and we recently
> > fixed some bugs on it, related to memory consumption along the time (it used to
> > forget to free memory, resulting on crashes, after several stream
> > start/stop's). 
> >
> > There's a tool at v4l2-apps/test made to stress a video driver, made by
> > Douglas. I suggest that you should run it with the board you'll choose to be
> > sure that you won't have memory garbage along driver usage.
> >
> > Cheers,
> > Mauro
> >   
> Thank you, Mauro! I much appreciate the advice.
> 
> I also see I misattributed the zvbi-ntsc-cc support for em28xx -- kudos 
> goes to Devin Heitmueller for great work on this.
> 
> As for the ventilation issue for USB devices, that may not be a serious 
> obstacle. If the USB sticks such as Hauppauge HVR-950 have reliable 
> components, we could strip the plastic casing and mount the unit next to 
> a fan inside the case.
> 
> Memory leaks would be a serious problem on the other hand; thank you for 
> pointing to the stress test.
> 
> I would be happy to use bttv, but I can't find cards. I also need to 
> grab audio off the PCI bus, which only some bttv cards support.
> 
> We've been using saa7135 cards for several years with relatively few 
> incidents, but they occasionally drop audio.
> I've been unable to find any pattern in the audio drops, so I haven't 
> reported it -- I have no way to reproduce the error, but it happens 
> regularly, affecting between 3 and 5% of recordings. Audio will 
> sometimes drop in the middle of a recording and then resume, or else 
> work fine on the next recording.

Hi Dave,

hmm, losing audio on three to five percent of the recordings is a lot!

When we started to talk to each other, we had only saa7134 PAL/SECAM
devices over here.

That has changed a lot, but still no System-M here.

The kernel thread detecting audio on saa7133/35/31e behaves different
from the one on saa7134.

But if you let it run with audio_debug=1, you should have something in
the logs when losing the audio. The kernel audio detection thread must
have been started without success or id find the right thing again. I
would assume caused by a weaker signal in between.

Do you know about the insmod option audio_ddep?

It is pretty hidden and I almost must look it up myself in the code.

Cheers,
Hermann

> Our fallback is ivtv. I was hoping to use USB so that we could get 
> blades instead of 3U cases; it's also getting hard to find good 
> motherboards with four PCI slots.
> 
> Cheers,
> Dave
> 


