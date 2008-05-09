Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JuJV5-0007zW-71
	for linux-dvb@linuxtv.org; Fri, 09 May 2008 05:42:30 +0200
From: Andy Walls <awalls@radix.net>
To: Matthias Dahl <mldvb@mortal-soul.de>
In-Reply-To: <200805081929.16409.mldvb@mortal-soul.de>
References: <200805020849.15170.mldvb@mortal-soul.de>
	<200805031657.00691.mldvb@mortal-soul.de>
	<1209861838.9347.124.camel@palomino.walls.org>
	<200805081929.16409.mldvb@mortal-soul.de>
Date: Thu, 08 May 2008 23:41:33 -0400
Message-Id: <1210304493.12356.30.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KNC1 DVB-C (MK3) w/ CI causes i2c_timeouts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, 2008-05-08 at 19:29 +0200, Matthias Dahl wrote:
> Hi Andy.
> 
> Sorry for the delay but I was having some hw trouble and other things kept me 
> quite busy as well (studies).
> 
> On Sunday 04 May 2008 02:43:58 you wrote:
> 
> > Maybe.  Given the lspci output, you may have two separate problem, that
> > are now making things noticable.
> 
> Well I fixed the issue with the vt switch not working right after a cold 
> start. I updated the motherboard's bios to its latest revision (after which 
> it was basically brain-dead but that's a different story and fixed now -g-) 
> and the issue is gone for good. Strange as it may seem...

A buggy BIOS or bad ESCD data doesn't seem strange now that you mention
it.

> > That means the bridge is unhappy, and it could very well be something behind
> > it, like the DVB card. 
> 
> I tested it with the old card- it's the same there: the PCI bridge reports the 
> error condition after a cold start and those are gone after a simple reboot.
> 
> The error from the memory controller seems strange but I doubt its really an 
> issue. The memory works just fine and I also tested both dimms seperately. It 
> also happens without the dvb card. Besides I find it strange that I get 6 
> memory controllers and one unnumbered one reported. Something can't be right 
> with that data, can it?

Most likely the ascii label given to the devices by lspci is wrong.  The
lspci command reports things from a static database which may not be
perfect as nVidia may have reused id's on functions within a highly
integrated device.  Those controllers appear to all be functions of one
highly integrated chip.  A block diagram from nVidia literature on the
chipset would probably make things clear.


> > The prefetchable addr limit upper 32 bits differ
> > on the PCI Bridge that the DVB card is behind.
> > Also no SERR is reported by this bridge any longer.
> 
> What's responsible for setting the appropriate value? Maybe that's a clue.

The BIOS is probably responsible for basic setup of the motherboard to
get disks and usb controllers working.  Additional setup is done by the
pci drivers in the linux kernel, if I'm reading the source correctly.
Although it looks like linux may leave bridge configurations alone under
some conditions.


> One other thing. Is the tda10023 module reporting the real BER and UNC values? 
> The reason I ask is with the new card I get a constant BER and UNC of 0 with 
> QAM256 modulated channels even though there are still artefacts due to 
> transmission errors. On the other hand, if those values are correct maybe the 
> stream gets corrupted due to some other issues.

You may have complete MPEG TS packet erasures being introduced somewhere
before or after your digital tuner.  I'd think the tuner hardware
wouldn't count those as bit errors, unless it made the packet erasure
itself.

If your cable provider gets a channel via some other digital feed
subject to errors before passing it to you, then his transmission to you
may be "cleaned up" and sent without error, but his original reception
of the program may have experienced errors.


> BTW I have increased the card's latency to 64. So far I haven't had any of 
> those timeouts but I will have to do some more testing this weekend to see if 
> it's really fixed.

Cool.


>  I actually hoped those timeouts were causing the stream 
> corruptions... well... can't be because I had those issues today and no 
> timeouts.
> 
> If you have any other ideas what I could try to get to the bottom of this, 
> please let me know. Thanks a lot in advance...!

Watch the same digital channel on a dedicated television set at the same
time you watch it on your computer.  That way you can test the
hypothesis that the artifacts are introduced by your cable provider and
not in transmission to your home or playback on your computer hardware.

-Andy

> Have a nice weekend,
> matthew.
> 
> PS. I have attached some more lspci output.




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
