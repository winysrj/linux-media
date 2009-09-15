Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbZIODJR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 23:09:17 -0400
Date: Tue, 15 Sep 2009 00:08:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Reliable work-horse capture device?
Message-ID: <20090915000841.56c24dd6@pedra.chehab.org>
In-Reply-To: <4AAEFEC9.3080405@cogweb.net>
References: <4AAEFEC9.3080405@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Mon, 14 Sep 2009 19:41:13 -0700
David Liontooth <lionteeth@cogweb.net> escreveu:

> 
> We're setting up NTSC cable television capture devices in a handfull of 
> remote locations, using four devices to capture around fifty hours a day 
> on each location. Capture is scripted and will be ongoing for several 
> years. We want to minimize the need for human intervention.
> 
> I'm looking for advice on which capture device to use.  My main 
> candidates are ivtv (WinTV PVR 500) and USB, but I've not used any of 
> the supported USB devices.
> 
> Are there USB devices that are sufficiently reliable to hold up under 
> continuous capture for years? Are the drivers robust?
> 
> I need zvbi-ntsc-cc support, so a big thanks to Michael Krufty for just 
> now adding it to em28xx. Do any other USB device chipsets have raw 
> closed captioning support?
> 
> I would also consider using the PCIe device Hauppauge WinTV-HVR-2200, 
> but I need analog support.
> 
> Appreciate any advice.

If you look for stability, the most important item is to choose a good stable
server distribution, like RHEL5. You'll be better serviced than using a desktop
distro with some new (not so stable) kernel and tools.

In terms of stability, the PCI devices are generally more reliable, and, among
all drivers, bttv is the winner, since it is the older driver, so, in thesis,
more bugs were solved on it. That's the reason why several surveillance systems
are still today based on bttv. If you need a newer hardware, then you may choose
saa7134, cx88 or ivtv devices.

I don't recommend using an USB hardware for such hard usage: it will probably
have a shorter life (since it is not as ventilated as a PCI device on a
server cabinet), and you might experience troubles after long plays. In terms
of USB with analog support, em28xx driver is the more stable, and we recently
fixed some bugs on it, related to memory consumption along the time (it used to
forget to free memory, resulting on crashes, after several stream
start/stop's). 

There's a tool at v4l2-apps/test made to stress a video driver, made by
Douglas. I suggest that you should run it with the board you'll choose to be
sure that you won't have memory garbage along driver usage.

Cheers,
Mauro
