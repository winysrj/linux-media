Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3KD6wIa029210
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 09:06:58 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3KD6id3004684
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 09:06:45 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: ian@pickworth.me.uk
In-Reply-To: <480B3673.3040707@pickworth.me.uk>
References: <480A5CC3.6030408@pickworth.me.uk> <480B26FC.50204@hccnet.nl>
	<480B3673.3040707@pickworth.me.uk>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 15:06:11 +0200
Message-Id: <1208696771.3349.49.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Gert Vervoort <gert.vervoort@hccnet.nl>
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

Hi,

Am Sonntag, den 20.04.2008, 13:26 +0100 schrieb Ian Pickworth:
> Gert Vervoort wrote:
> > Ian Pickworth wrote:
> >> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers 
> >> for   the Hauppauge WinTV appear to have suffered some regression 
> >> between the two kernel versions.
> >>
> >> The problem is that the tuner is not being detected and set correctly 
> >> for either the video or the radio device on the card.
> >>
> > Similar issue here with a Leadtek Winfast 2000XP card. Video works, but 
> > radio doesn't.
> > For my card I can workaround the issue by adding the "tuner=38" option 
> > to the cx88xx module.
> > 
> >   Gert
> 
> That workaround works for me as well - with "tuner=38" for cx88xx I can 
> now tune to both video and radio channels.
> 
> So it looks like its just the auto detection that has regressed in 2.6.25.
> 
> Thanks
> Regards
> Ian
> 
> 

just read this and that's good, but if all cards with eeprom detection
are affected, we have a problem.

I copy in what I had as reply for the previous mail so far.

>From the build date I expect the released 2.6.25. One could disable
tuner-simple and tda9885/6/7 support on customizing analog tuner support
on this kernel, but that is not the case.

Mauro did something to get the tuner type set earlier to avoid other
troubles, but this looks like setting the tuner from eeprom detection
fails now, since it is already set previously and a tuner callback with
the correct tuner from eeprom doesn't happen.

I can see something similar on saa7134 and a md7134. (card=12, tuner=38)
That tuner detection from eeprom was not 100% reliable since a while,
but only _sometimes_ a FMD1216ME was set instead the FM1216ME MK3.

Currently this will always fail on 2.6.25 if tuner=38 is not forced.

Since 2.6.25 tda9887 is out of the tuner module again, old tda9887 port
and qss options against the tuner module will make it fail to load too,
but this gives an error in dmesg, what is not the case here, just to
note it for others.

saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 16be:0003, board: Medion 7134 [card=12,insmod option]
saa7134[3]: board init: gpio is 0
tuner' 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: tda988[5/6/7] found
All bytes are equal. It is not a TEA5767
tuner' 5-0060: chip found @ 0xc0 (saa7134[3])
tuner-simple 5-0060: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[3]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
saa7134[3]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
saa7134[3]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3] Tuner type is 38    <----------------------

saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2

Gert, do we have more regressions for the WinFast 2000XP?

OT, but do you remember on which kernel your saa7134-empress worked
last? There are problems too and Frederic Cand reported a 2.6.9 working
or a snapshot around that time ported. That would be odd.

Cheers,
Hermann





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
