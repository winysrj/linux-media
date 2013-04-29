Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab3D2Ool (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 10:44:41 -0400
Date: Mon, 29 Apr 2013 11:44:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Marcel Kulicke <marcel.kulicke@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx: Kernel panic after installing latest linuxtv.org
 modules
Message-ID: <20130429114436.71874115@redhat.com>
In-Reply-To: <5A1B4C82-6E63-4E7F-A7E2-F3FA82669C70@gmail.com>
References: <CAEV8V2CoSGOCW90usDQ=KSNoom9Y-6Yn8Jn2nOHhSvHkazer0A@mail.gmail.com>
	<20130424081522.7d0fd37e@redhat.com>
	<5A1B4C82-6E63-4E7F-A7E2-F3FA82669C70@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Apr 2013 20:29:19 +0200
Marcel Kulicke <marcel.kulicke@gmail.com> escreveu:

> Hi Mauro,
> 
> thanks a lot for taking the time to respond to my issue! 
> > Did it used to work with a previous version? If so, could you please
> > bisect to see what patch broke it?
> No, it also didn't work with the previous version, but since building
> the previous version was also a bit of a hassle, I am not so sure I got a clean module. 
> 
> > I'm not familiar enough with ARM to understand what the above actually means.
> > I would be expecting, instead, an error with the trace function stack.
> > 
> > Perhaps you need to enable some things at .config to enable it, or to run
> > ./scripts/ksymoops manually to translate the above into something useful.
> I only know the ksmoops way. Since I just read that you published a new version,
> I will try the new version and apply ksmoops there if necessary (hopefully not! :-)) 

Yes, let's hope it will work now.

> > 
> > I heard that using a 2A power adapter would work, but I don't have it
> > currently (I'm currently trying to get one). I tested also with an USB
> > hub with its own power supply. I found there two issues:
> > 
> > 	- the hub was sending power also to the Rpi, causing problems
> > there due to the other power adapter;
> > 
> > 	- the hub I used seemed to interfere at the USB isoc traffic.
> > 
> > What I'm trying to say is that perhaps this is not a driver issue at all,
> > but, instead, a problem with em28xx+demod high power consumption and Rpi.
> Sad to say, but I am using a 2A USB power adapter already. I also tried to it with a powered hub (yeah, that powered the pi as well - as you mentioned) but same oops-results. 

USB hubs can be a source of problems. The better is to not use it, if
the 2A USB power supply is enough.

> There is one other possibility. An RTL8192CU-WiFi-Module is also connected to the pi. Maybe it interferes? I will check that out as well. 

Perhaps. I would try without it as well.

> > The best way is to test the device first on a x86, to be sure that the
> > driver is OK there. Then, you need to properly address the power supply
> > needs for RPi. Only after that, check if are there at em28xx anything
> > that could be incompatible with arm.
> Will do!

Thanks!

-- 

Cheers,
Mauro
