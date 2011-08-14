Return-path: <linux-media-owner@vger.kernel.org>
Received: from nschwmtas05p.mx.bigpond.com ([61.9.189.149]:17984 "EHLO
	nschwmtas05p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab1HNXXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 19:23:41 -0400
Received: from nschwotgx01p.mx.bigpond.com ([121.214.104.126])
          by nschwmtas05p.mx.bigpond.com with ESMTP
          id <20110814232338.LXMI13174.nschwmtas05p.mx.bigpond.com@nschwotgx01p.mx.bigpond.com>
          for <linux-media@vger.kernel.org>;
          Sun, 14 Aug 2011 23:23:38 +0000
Received: from max.localnet ([121.214.104.126])
          by nschwotgx01p.mx.bigpond.com with ESMTP
          id <20110814232338.DUZM2024.nschwotgx01p.mx.bigpond.com@max.localnet>
          for <linux-media@vger.kernel.org>;
          Sun, 14 Aug 2011 23:23:38 +0000
To: linux-media@vger.kernel.org
Subject: Re: How to git and build HVR-2200 drivers from Kernel labs ?
From: Declan Mullen <declan.mullen@bigpond.com>
Date: Mon, 15 Aug 2011 09:23:44 +1000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108150923.44824.declan.mullen@bigpond.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 August 2011 22:14:48 you wrote:
> On Sun, Aug 14, 2011 at 5:21 AM, Declan Mullen
> 
> <declan.mullen@bigpond.com> wrote:
> > Hi
> > 
> > I've got a 8940 edition of a Hauppauge HVR-2200. The driver is called
> > saa7164. The versions included in my OS (mythbuntu 10.10 x86 32bit,
> > kernel 2.6.35-30) and from linuxtv.org are too old to recognise the 8940
> > edition. Posts #124 to #128 in the "Hauppauge HVR-2200 Tuner Install
> > Guide" topic
> > (http://www.pcmediacenter.com.au/forum/topic/37541-hauppauge-hvr-2200-tun
> > er- install-guide/page__view__findpost__p__321195) document my efforts
> > with those versions.
> > 
> > So I wish to use the latest stable drivers from the driver maintainers,
> > ie http://kernellabs.com/gitweb/?p=stoth/saa7164-stable.git;a=summary
> > 
> > Problem is, I don't know git and I don't know how I'm suppose to git,
> > build and install it.
> > 
> > Taking a guess I've tried:
> >  git clone git://kernellabs.com/stoth/saa7164-stable.git
> >  cd saa7164-stable
> >  make menuconfig
> >  make
> > 
> > However I suspect these are not the optimum steps, as it seems to have
> > downloaded and built much more than just the saa7164 drivers. The git
> > pulled down nearly 1GB (which seems a lot) and the resultant menuconfig
> > produced a very big ".config".
> > 
> > Am I doing the right steps or should I be doing something else to git,
> > build and install  the latest drivers ?
> > 
> > Thanks,
> > Declan
> 
> Hello Declan,
> 
> Blame Mauro and the other LinuxTV developers for moving to Git.  When
> we had HG you could do just the v4l-dvb stack and apply it to your
> existing kernel.  Now you have to suck down the *entire* kernel, and
> there's no easy way to separate out just the v4l-dvb stuff (like the
> saa7164 driver).  The net effect is it's that much harder for
> end-users to try out new drivers, and even harder still for developers
> to maintain drivers out-of-tree.
> 
> All that said, Ubuntu 10.10 deviates very little in terms of the
> saa7164 driver.  What you have is probably already identical to what's
> in the kernellabs.com tree.
> 
> And yes, PAL support is broken even in the kernellabs tree, so if that
> was your motivation then updating to the current KL stable tree won't
> help you.
> 
> Cheers,
> 
> Devin

Many thanks for the clarification about git.

The only reason why I'm attempting to use a newer saa7164 driver is 
because the driver in my ubuntu 10.10 (2.6.35-30, x86 32bit) doesn't 
recognise the 8940 edition of my HVR-2200  (and doesn't support the
 "card=9" option that I believe is specifically for the 8940 edition). 

Example dmesg output:
  $ dmesg | grep saa7
  [   18.367431] saa7164 driver loaded
  [   18.367467] saa7164 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  [   18.367472] saa7164[0]: Your board isn't known (yet) to the driver.
  [   18.367473] saa7164[0]: Try to pick one of the existing card configs via
  [   18.367474] saa7164[0]: card=<n> insmod option.  Updating to the latest
  [   18.367475] saa7164[0]: version might help as well.
  [   18.367684] saa7164[0]: Here are valid choices for the card=<n> insmod option:
  [   18.367739] saa7164[0]:    card=0 -> Unknown
  [   18.367789] saa7164[0]:    card=1 -> Generic Rev2
  [   18.367840] saa7164[0]:    card=2 -> Generic Rev3
  [   18.367891] saa7164[0]:    card=3 -> Hauppauge WinTV-HVR2250
  [   18.367943] saa7164[0]:    card=4 -> Hauppauge WinTV-HVR2200
  [   18.367995] saa7164[0]:    card=5 -> Hauppauge WinTV-HVR2200
  [   18.368059] saa7164[0]:    card=6 -> Hauppauge WinTV-HVR2200
  [   18.368112] saa7164[0]:    card=7 -> Hauppauge WinTV-HVR2250
  [   18.368164] saa7164[0]:    card=8 -> Hauppauge WinTV-HVR2250
  [   18.369142] CORE saa7164[0]: subsystem: 0070:8940, board: Unknown [card=0,autodetected]
  [   18.369147] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 16, latency: 0, mmio: 0xfd400000
  [   18.369152] saa7164 0000:02:00.0: setting latency timer to 64
  [   18.369162] saa7164_initdev() Unsupported board detected, registering without firmware

To get this 8940 card working with my ubuntu 10.10 system, 
what would you recommend I try ?

Should I be trying to extract the new driver from what the above
git and makes, ie just copy into place the new saa7164.ko file ?
Or should my existing driver work if i use the card=4 option ?

Thanks,
Declan
