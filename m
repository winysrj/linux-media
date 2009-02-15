Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:53514 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbZBOXZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 18:25:50 -0500
Subject: Re: [linux-dvb] Philips saa7131e chip on Asus
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <1234696814.4997fa6ea906c@mail.bluebottle.com>
References: <1234696814.4997fa6ea906c@mail.bluebottle.com>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 00:25:54 +0100
Message-Id: <1234740354.13023.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

Am Sonntag, den 15.02.2009, 11:20 +0000 schrieb Kevin:
> Hi, is there anyone who can please give me a hand, after months reading and trying things out, I still cannot make this work.
> I have an Asus Wifi tv card which came with my P5WD2 board. This card is shown as 'Asus Tiger Analog Tv Card' in xp and works well in that os.  Looking at the physical card I can see these writings on the chips and tuners (looks like it has 2)
> Philips saa7131E
> D33005   CE4403
> TN05211   SB0780 (don't know if these might help)
> I am trying to make it work on Ubuntu 8.10 (32 bit) (also tried on 64 bit---nothing)
> After  a brand new installation and updates to the kernel source and headers, my Kernel is 2.6.27.
> I also installed the latest Mercurial and also copied firmware drivers (tda10046)  to the /lib/firmware folder. 
> 
> lspci shows this;
> 01:01.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d0)
> 
> sudo lspci -v shows this
> 01:01.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d0)
> 	Subsystem: ASUSTeK Computer Inc. Device 818c
> 	Flags: bus master, medium devsel, latency 64, IRQ 22
> 	Memory at e7edb800 (32-bit, non-prefetchable) [size=2K]
> 	Capabilities: [40] Power Management version 2
> 	Kernel driver in use: saa7134
> 	Kernel modules: saa7134
> 
> The device being shown as 818c is not like any other Asus dual card I have read about.
> Looks like the card is being found but it is not being autodetected, dmesg is showing it as card=0.  I am manually forcing card numbers in /etc/modprobe.d/options file.  I have tried all the Asus card numbers there are in the cardlist but still did not manage to scan any channel.
> I have only one connection to the card and it;s from cable tv.
> 
> Sorry if I took too long, tried to give as much info as possible, and please excuse me if this is the wrong place were to put this request, if it is can you kindly guide me where I may ask for help.  TIA
> 

unfortunately I can only confirm your observations.

We tried on this one already during the very beginning of the analog TV
support for the tda8275a in October 2005, but without success.

As far I remember, the tuner finally did take all initialization
sequences and should be ready for analog TV, but we never saw a "lock"
on a signal reported with tuner debug=1.

My last idea on it was, that there must me at least some undiscovered
antenna RF input switching, but might be wrong and even more
complicated.

Should be on archives like marcs under ASUS WIFI-TV in the subject.

Can't tell, if for example regspy.exe from DScaler (deinterlace.sf.net)
for gpio settings can lead any further in this case.

Cheers,
Hermann




