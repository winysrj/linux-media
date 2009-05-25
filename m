Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34945 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZEYMKK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 08:10:10 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1M8Z0E-00032U-IG
	for linux-media@vger.kernel.org; Mon, 25 May 2009 12:10:04 +0000
Received: from host91-9-dynamic.18-87-r.retail.telecomitalia.it ([host91-9-dynamic.18-87-r.retail.telecomitalia.it])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 25 May 2009 12:10:02 +0000
Received: from vcovito by host91-9-dynamic.18-87-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 25 May 2009 12:10:02 +0000
To: linux-media@vger.kernel.org
From: Vito <vcovito@libero.it>
Subject: Re: TW6800 based video capture boards (updates)
Date: Mon, 25 May 2009 11:55:17 +0000 (UTC)
Message-ID: <loom.20090525T113704-857@post.gmane.org>
References: <20080525020028.GA22425@ska.dandreoli.com> <20080526073959.5a624288@gaivota> <20090104151427.GA4683@tilt.dandreoli.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Domenico Andreoli <cavokz <at> gmail.com> writes:

> 
> Hi,
> 
> On Mon, May 26, 2008 at 07:39:59AM -0300, Mauro Carvalho Chehab wrote:
> > On Sun, 25 May 2008 04:00:28 +0200, Domenico Andreoli <cavokz <at>
gmail.com> wrote:
> > >
> > >   I have some shining boards based on Techwell TW6802 and a "working"
> > > V4L2 driver provided by the producer. Ah.. I have also the specs of
> > > those TW6802 chips. Everything has been purchased by my employer.
> > > 
> > > Now I am eager to publish everything but I can't right now. My employer
> > > would not understand and I would be in a difficult position. He already
> > > knows that those drivers are based on GPL software and then _are_ GPL
> > > at all the effects but he still needs to completely understand how it
> > > works. Those guys are always happy to use Linux for free but at the
> > > time of giving anything back...
> > > 
> > > To make the long story short, I want to rewrite them. So, how do
> > > you judge my (legal) position? Yes, you are not a lawyer but I would
> > > appreciate any related advice anyway ;)
> > 
> > I think this will depend if you have a signed NDA or not, and what are their
> > terms. Better to consult a lawyer ;)
> 
> I finally got the clearance few weeks ago :)
> 
> > > Since I am a kernel newbie I am expecting to receive lots of "leave
> > > V4L2 to expert coders..." but I will try anyway. You are warned :)
> > 
> > Just do your work and submit us the code. We'll analyse it and point for
> > issues, if needed ;) If you have any doubts about V4L2, I can help you.
> 
> The new driver, named tw68xx, is able to capture video only.  My wish
> is to make it stable and production ready as soon as possible.
> 
> So at the beginning no audio, no TS, no VBI and no overlay are
> supported. These functionalities would be added with time, boards
> and users.
> 
> I am already collecting people willing to help writing and test stuff :)
> 
> > Please, always c/c v4l ML when submitting your driver[1]. You may also c/c
> > other lists, like LKML. This will allow people to review it.
> 
> I plan to publish it for a first revision by the end of January.
> 
> Currently it is an external module and I would maintain that way until
> it is ready for the merge to the Linus' tree. This way I have not to
> follow a specific tree. Would it be ok for reviewers?
> 
> cheers,
> Domenico
> 
> -----[ Domenico Andreoli, aka cavok
>  --[ http://www.dandreoli.com/gpgkey.asc
>    ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Hi all.
I've bought a Provideo 16 in capture PCI-Experess card for my own DVR solution.
http://www.provideo.com.tw/DVRCARD_PV988.htm
This card have 8 TW6805 chip installed.
I've installed the card in a PC with Fedora Core 9 Linux OS
With this kernel.

[root@alinux]# uname -a
Linux apelle 2.6.27.15-78.2.23.fc9.i686 #1 SMP Wed Feb 11 23:53:07 EST 2009 i686
i686 i386 GNU/Linux
The matter is that the kernel don't recognize my card, (see lspci later)

I've compiled successfully the techwell tw6800.ko driver from
http://gitorious.org/tw68 
and inserted it:
[root@alinux]# dmesg
...
tw6800: tw6800 v4l2 driver version 0.0.0 loaded

But however the lspci don't recognize my card:

[root@alinux]# lspci -v
....
04:00.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 5
	Memory at deefc000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:00.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 5
	Memory at deefc400 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

04:01.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deefc800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:01.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deefcc00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

04:02.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deefd000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:02.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deefd400 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

04:03.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 15
	Memory at deefd800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:03.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 15
	Memory at deefdc00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

04:04.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 5
	Memory at deefe000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:04.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 5
	Memory at deefe400 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

04:05.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deefe800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:05.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deefec00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

04:06.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deeff000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:06.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at deeff400 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

04:07.0 Multimedia video controller: JumpTec h, GMBH Unknown device 6804 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 15
	Memory at deeff800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [44] Power Management version 2

04:07.1 Multimedia controller: JumpTec h, GMBH Unknown device 6805 (rev 10)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 15
	Memory at deeffc00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 2

There is some possibility that this card can work in some manner?
Can you help me?.
Very very compliments for all your work.
Bye.
Vito.


