Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3O3uIui001631
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 23:56:18 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3O3u4EQ002824
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 23:56:05 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Gert Vervoort <gert.vervoort@hccnet.nl>
In-Reply-To: <1208726202.5682.44.camel@pc10.localdom.local>
References: <480A5CC3.6030408@pickworth.me.uk> <480B26FC.50204@hccnet.nl>
	<480B3673.3040707@pickworth.me.uk>
	<1208696771.3349.49.camel@pc10.localdom.local>
	<480B6CD8.7040702@hccnet.nl>
	<1208726202.5682.44.camel@pc10.localdom.local>
Content-Type: text/plain; charset=utf-8
Date: Thu, 24 Apr 2008 05:55:28 +0200
Message-Id: <1209009328.3402.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Am Sonntag, den 20.04.2008, 23:16 +0200 schrieb hermann pitton:
> Am Sonntag, den 20.04.2008, 18:18 +0200 schrieb Gert Vervoort:
> > hermann pitton wrote:
> > > Hi,
> > >
> > > Am Sonntag, den 20.04.2008, 13:26 +0100 schrieb Ian Pickworth:
> > >   
> > >> Gert Vervoort wrote:
> > >>     
> > >>> Ian Pickworth wrote:
> > >>>       
> > >>>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers 
> > >>>> for   the Hauppauge WinTV appear to have suffered some regression 
> > >>>> between the two kernel versions.
> > >>>>
> > >>>> The problem is that the tuner is not being detected and set correctly 
> > >>>> for either the video or the radio device on the card.
> > >>>>
> > >>>>         
> > >>> Similar issue here with a Leadtek Winfast 2000XP card. Video works, but 
> > >>> radio doesn't.
> > >>> For my card I can workaround the issue by adding the "tuner=38" option 
> > >>> to the cx88xx module.
> > >>>
> > >>>   Gert
> > >>>       
> > >> That workaround works for me as well - with "tuner=38" for cx88xx I can 
> > >> now tune to both video and radio channels.
> > >>
> > >> So it looks like its just the auto detection that has regressed in 2.6.25.
> > >>
> > >> Thanks
> > >> Regards
> > >> Ian
> > >>
> > >>
> > >>     
> > >
> > > just read this and that's good, but if all cards with eeprom detection
> > > are affected, we have a problem.
> > >
> > > I copy in what I had as reply for the previous mail so far.
> > >
> > > >From the build date I expect the released 2.6.25. One could disable
> > > tuner-simple and tda9885/6/7 support on customizing analog tuner support
> > > on this kernel, but that is not the case.
> > >
> > > Mauro did something to get the tuner type set earlier to avoid other
> > > troubles, but this looks like setting the tuner from eeprom detection
> > > fails now, since it is already set previously and a tuner callback with
> > > the correct tuner from eeprom doesn't happen.
> > >
> > > I can see something similar on saa7134 and a md7134. (card=12, tuner=38)
> > > That tuner detection from eeprom was not 100% reliable since a while,
> > > but only _sometimes_ a FMD1216ME was set instead the FM1216ME MK3.
> > >
> > > Currently this will always fail on 2.6.25 if tuner=38 is not forced.
> > >
> > > Since 2.6.25 tda9887 is out of the tuner module again, old tda9887 port
> > > and qss options against the tuner module will make it fail to load too,
> > > but this gives an error in dmesg, what is not the case here, just to
> > > note it for others.
> > >
> > > saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
> > > saa7134[3]: subsystem: 16be:0003, board: Medion 7134 [card=12,insmod option]
> > > saa7134[3]: board init: gpio is 0
> > > tuner' 5-0043: chip found @ 0x86 (saa7134[3])
> > > tda9887 5-0043: tda988[5/6/7] found
> > > All bytes are equal. It is not a TEA5767
> > > tuner' 5-0060: chip found @ 0xc0 (saa7134[3])
> > > tuner-simple 5-0060: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> > > saa7134[3]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
> > > saa7134[3]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
> > > saa7134[3]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > saa7134[3] Tuner type is 38    <----------------------
> > >
> > > saa7134[3]: registered device video3 [v4l2]
> > > saa7134[3]: registered device vbi3
> > > saa7134[3]: registered device radio2
> > >
> > > Gert, do we have more regressions for the WinFast 2000XP?
> > >
> > >   
> > With the tuner type set manual things seem to work normally.
> > Teletext does not seem to work, but when I booted into 2.6.24 again, I 
> > got the same problem. Haven't used teletext for a long time, so I can't 
> > remember the last kernel version where it did work.
> 
> Still all slots are full with saa713x stuff we recently added support
> for or needs some fixes, but yes, at least Mauro had it working on cx88.
> 
> > I did notice messages caused by the nvidia binary blob:
> > 
> > NVRM: bad caching on address 0xffff810039654000: actual 0x173 != 
> > expected 0x17b
> > NVRM: please see the README section on Cache Aliasing for more information
> > cx88[0]: video y / packed - dma channel status dump
> > cx88[0]:   cmds: initial risc: 0x1ec19000
> > cx88[0]:   cmds: cdt base    : 0x00180440
> > cx88[0]:   cmds: cdt size    : 0x0000000c
> > cx88[0]:   cmds: iq base     : 0x00180400
> > cx88[0]:   cmds: iq size     : 0x00000010
> > cx88[0]:   cmds: risc pc     : 0x1ec6c5d8
> > cx88[0]:   cmds: iq wr ptr   : 0x00000109
> > cx88[0]:   cmds: iq rd ptr   : 0x0000010d
> > cx88[0]:   cmds: cdt current : 0x00000458
> > cx88[0]:   cmds: pci target  : 0x1ec6ab80
> > cx88[0]:   cmds: line / byte : 0x00900000
> > cx88[0]:   risc0: 0x80008200 [ sync resync count=512 ]
> > cx88[0]:   risc1: 0x1c000480 [ write sol eol count=1152 ]
> > cx88[0]:   risc2: 0x1ec1a480 [ arg #1 ]
> > cx88[0]:   risc3: 0x18000280 [ write sol count=640 ]
> > cx88[0]:   iq 0: 0x1ec1ad80 [ write sol eol irq2 23 22 cnt0 resync 13 
> > count=3456 ]
> > cx88[0]:   iq 1: 0x14000200 [ arg #1 ]
> > cx88[0]:   iq 2: 0x1ec1b000 [ write sol eol irq2 23 22 cnt0 resync 13 12 
> > count=0 ]
> > cx88[0]:   iq 3: 0x1c000480 [ arg #1 ]
> > cx88[0]:   iq 4: 0x1ec1b680 [ write sol eol irq2 23 22 cnt0 resync 13 12 
> > count=1664 ]
> > cx88[0]:   iq 5: 0x18000080 [ arg #1 ]
> > cx88[0]:   iq 6: 0x1ec1bf80 [ write sol eol irq2 23 22 cnt0 resync 13 12 
> > count=3968 ]
> > cx88[0]:   iq 7: 0x14000400 [ arg #1 ]
> > cx88[0]:   iq 8: 0x1ec1c000 [ write sol eol irq2 23 22 cnt0 resync 14 
> > count=0 ]
> > cx88[0]:   iq 9: 0x1ec6a000 [ arg #1 ]
> > cx88[0]:   iq a: 0x1c000480 [ write sol eol count=1152 ]
> > cx88[0]:   iq b: 0x1ec6a700 [ arg #1 ]
> > cx88[0]:   iq c: 0x80008200 [ sync resync count=512 ]
> > cx88[0]:   iq d: 0x1c000480 [ write sol eol count=1152 ]
> > cx88[0]:   iq e: 0x1ec1a480 [ arg #1 ]
> > cx88[0]:   iq f: 0x18000280 [ write sol count=640 ]
> > cx88[0]:   iq 10: 0x00180c00 [ arg #1 ]
> > cx88[0]: fifo: 0x00180c00 -> 0x183400
> > cx88[0]: ctrl: 0x00180400 -> 0x180460
> > cx88[0]:   ptr1_reg: 0x00181680
> > cx88[0]:   ptr2_reg: 0x00180468
> > cx88[0]:   cnt1_reg: 0x00000038
> > cx88[0]:   cnt2_reg: 0x00000000
> > cx88[0]/0: [ffff810026028600/1] timeout - dma=0x1ec6c000
> > 
> > When using the xorg nv driver, these message do not occur.
> 
> On the saa7134 and ATI fglrx no issues so far, else I'm using also the
> xorg nv driver without issues.
> 
> > 
> > > OT, but do you remember on which kernel your saa7134-empress worked
> > > last? There are problems too and Frederic Cand reported a 2.6.9 working
> > > or a snapshot around that time ported. That would be odd.
> > >   
> > Can't remember at which kernel version I've used it last. Since I left 
> > Philips Research about 3 years ago, I do not have access anymore to a 
> > board with a empress MPEG-2 encoder.
> > 
> 
> Ah, thanks, didn't know that. There have been always only _very few_
> people with these cards and you did pretty much work on them.
> 
> There are currently some Creatix CTX946 around. (creatix.de) 
> They seem to come with some of the recent Medion Multimedia PCs and
> there are also some traders on ebay, with obviously substantial
> quantities, one selling them as cheap as 29€ plus shipping and declared
> as new.
> 
> The cards do already support analog and DVB-T, but I don't know yet from
> what point the driver bugs start and where the physical configuration of
> the card and encoder is not yet sufficient. The latter is very likely
> the case as well, since I have been back to 2.6.12 already.
> 
> There is also the new Behold M6 Extra now, also without safe ground for
> the encoder currently.
> 
> At least the potential mute problem Nickolay and me introduced by adding
> digital mute support for the new cards without analog audio out is
> fixed.
> 
> Mauro, Mike and all, you are aware of the just reported tuner detection
> issues. They seem to be also on current v4l-dvb.
> 
> Thanks,
> Hermann
>  
> 

Hi,

do you see the auto detection issue?

Either tell it is just nothing, what I very seriously doubt, or please
comment.

I don't like to end up on LKML again getting told that written rules
don't exist ;)

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
