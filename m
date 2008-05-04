Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JsSLm-0001ev-GR
	for linux-dvb@linuxtv.org; Sun, 04 May 2008 02:45:12 +0200
From: Andy Walls <awalls@radix.net>
To: Matthias Dahl <mldvb@mortal-soul.de>
In-Reply-To: <200805031657.00691.mldvb@mortal-soul.de>
References: <200805020849.15170.mldvb@mortal-soul.de>
	<1209734150.3475.48.camel@palomino.walls.org>
	<200805031657.00691.mldvb@mortal-soul.de>
Date: Sat, 03 May 2008 20:43:58 -0400
Message-Id: <1209861838.9347.124.camel@palomino.walls.org>
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

On Sat, 2008-05-03 at 16:56 +0200, Matthias Dahl wrote:
> Hello Andy.
> 
> On Friday 02 May 2008 15:15:50 you wrote:
> 
> > Given that your software hasn't changed, and assuming the driver code is
> > correct (for a large majority of users), then the remaining problem
> > areas I see are the card itself, the mainboard's PCI bus, and the
> > possibility of a marginal power supply.  (Can anyone else think of
> > something else?)
> 
> Perhaps. But maybe it's a combination of a few factors: is the MK3 model w/ CI 
> as widely used and tested as the older model w/ CI? Maybe a combination of my 
> hardware is triggering some hw/sw flaw.

Maybe.  Given the lspci output, you may have two separate problem, that
are now making things noticable.


> The card is brand-new and was slightly modified by KNC1 for better QAM256 
> receiption with my cable provider. The mainboard is a Asus Crosshair which is 
> pretty much top-notch. Irionically I am no gamer and still own a highend 
> gamer board but it's hard to get a decent piece of quality hardware 
> nowadays. :-( 


> The power supply should be more than enough with its 500W. ;-)

:)

> > Can you check the output of
> > # lspci -nnxxx
> > for your Host and PCI bridges and the video card?
> 
> Thanks for the tipp. That brings me to another problem that I think might be 
> related. Since I put in the new card, I am experiencing the following:
> 
>  - power on computer -> wait for kdm -> switching to console fails
> 
>    the monitor even turns off because it gets no signal. usually blindly
>    switching back to Xorg works and the screen is back.
> 
>  - rebooting the system -> everything works fine from there on
> 
> I did some more investigating and figured that the problem only occurs when 
> the system has just been powered on _and_ something is accessing the dvb-c 
> card. So powering on the machine without starting the vdr works just fine. 
> But as soon as vdr has been started, no more vt switching is possible. The 
> problem doesn't show up after a reboot- at all. This is never ever happened 
> with the old card. I checked the cabling and all but I wasn't able to figure 
> out what's the cause of this. No error msgs. Nothing.

Your DVB card is on PCI bus segment 2 and your graphics card is on bus
segment 5.  I see the DVB card is on the segment behind the PCI bridge
at 00:0e.0 since that bridge has segment 2 as its secondary bus.

> For the record, unfortunately I am using a nvidia card with the 173.08 driver 
> release. But I already did that with the old card.
> 
> I have attached the lspci output for both cases by the way.

>From lspci_powerup_with_problem:

00:00.1 RAM memory [0500]: nVidia Corporation C51 Memory Controller 0 [10de:02fa] (rev a2)
00: de 10 fa 02 00 01 20 40 a2 00 00 05 00 00 80 00
                         ^
                         |
00:0e.0 PCI bridge [0604]: nVidia Corporation MCP55 PCI bridge [10de:0370] (rev a2)
00: de 10 70 03 07 01 b0 40 a2 01 04 06 00 00 81 00
                         ^
                         |
Signaled System Errors (SERR), that's bad.

Note that this is the bridge (00:0e.0) that the DVB card is behind, and that this bridge signaled a SERR on it's primary bus segment (the side closer to the CPU/Host bridge), and not that it received a SERR on it's secondary bus segment.  That means the bridge is unhappy, and it could very well be something behind it, like the DVB card.

According to the PCI spec:

"System Error is for reporting address parity errors, data parity errors
 on the Special Cycle command, or any other system error where the
 result will be catastrophic. If an agent does not want a non-maskable
 interrupt (NMI) to be generated, a different reporting mechanism is
 required."

and a bunch of other specific conditions are mentioned as well.


In the file lspci_after_reboot-working, only the 00:00.1 RAM Controller
device still shows a SERR.  Since this memory controller is reporting
SERRs, you might have a genuine memory problem somewhere or a device
trying to access the memory might have a problem.


I also notice these differences in the lspci before and after data:

00:0e.0 PCI bridge [0604]: nVidia Corporation MCP55 PCI bridge [10de:0370] (|  00:0e.0 PCI bridge [0604]: nVidia Corporation MCP55 PCI bridge [10de:0370] (
00: de 10 70 03 07 01 b0 40 a2 01 04 06 00 00 81 00                         |  00: de 10 70 03 07 01 b0 00 a2 01 04 06 00 00 81 00                         
10: 00 00 00 00 00 00 00 00 00 02 02 20 f0 00 80 02                         |  10: 00 00 00 00 00 00 00 00 00 02 02 20 f0 00 80 02
20: f0 fd f0 fd f0 ff 00 00 00 00 00 00 00 00 00 00                         |  20: f0 fd f0 fd f0 ff 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 b8 00 00 00 00 00 00 00 ff 00 04 0e                         |  30: 00 00 00 00 b8 00 00 00 00 00 00 00 ff 00 04 0a                         
                                                  ^                                                                              ^ 
                                                  |                                                                              |       
The prefetchable addr limit upper 32 bits differ -+------------------------------------------------------------------------------+
on the PCI Bridge that the DVB card is behind.
Also no SERR is reported by this bridge any longer.


05:00.0 VGA compatible controller [0300]: nVidia Corporation Device [10de:04|  05:00.0 VGA compatible controller [0300]: nVidia Corporation Device [10de:04
00: de 10 00 04 07 00 10 00 a1 00 00 03 00 00 00 00                         |  00: de 10 00 04 07 00 10 00 a1 00 00 03 00 00 00 00
10: 00 00 00 fa 0c 00 00 e0 00 00 00 00 04 00 00 f8                         |  10: 00 00 00 fa 0c 00 00 e0 00 00 00 00 04 00 00 f8
20: 00 00 00 00 01 9c 00 00 00 00 00 00 62 14 50 09                         |  20: 00 00 00 00 01 9c 00 00 00 00 00 00 62 14 50 09
30: 00 00 00 00 60 00 00 00 00 00 00 00 0b 01 00 00                         |  30: 00 00 fe fb 60 00 00 00 00 00 00 00 0b 01 00 00
          ^^^^^                                                                          ^^^^^
            |                                                                              |
            +------------------------------------------------------------------------------+
The Expansion ROM base address is actually set for the video card after
reboot.  That must make a difference for using VTs.
 

So, on power up, accessing the DVB card causes the bridge it's behind to
gripe.  Sounds like you might have a bad card or bridge or card
connector.  You may want to see if that bridge is happy with the old DVB
card installed instead.

You also have a memory controller that is consistently not happy.  You
may want to check your memory.  You may also want to see if that memory
controller is happy with the old DVB card installed instead.

Regards,
Andy

> 
> > Also could you look at the latency timer of all the PCI devices on the
> > bus?  Values that are very high (e.g. nVidia likes to use 248) and
> > values less than or equal to 32 (n.b. 0 is OK for some bridge devices)
> > can cause problems.
> 
> Due the fact that I only have the knc one card in the machine and everything 
> else is either on board or on PCI-E, the latency is 0 everywhere except for 
> the knc one card, there it's 32.
> 
> > Tweaking PCI bus latency timers with "setpci" may resolve your problems.
> 
> I'll give that a shot too. I really would like to set the latency when the 
> module is being loaded. Unfortunately there is no module parameter for that 
> so I'll have a look through the sources and hard wire to 64 which should be 
> plenty.


> > I believe this is a log message from an error condition.  The EEPROM on
> > the i2c bus on the card was not able to be read properly.
> > (See: linux/drivers/media/dvb/ttpci/ttpci-eeprom.c)
> 
> That also happened with the old card so I guess that's okay.
> 
> BTW. I switched to kernel 2.6.25.1 and in-tree dvb but no change at least on 
> the "boot up" problem. For the original problem, I'll have an eye on it.
> 
> Sometimes I really wonder why I chose to study computer science. Life could be 
> so much easier. ;-)
> 
> If anyone has some more ideas or things I could try... :-)
> 
> Thanks a lot,
> matthew.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
