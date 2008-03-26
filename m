Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QNYr7n021569
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:34:53 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QNYbAT005849
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:34:37 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Bart Michiels <michielske3@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <47E80918.2080705@gmail.com>
References: <47E80918.2080705@gmail.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 00:26:27 +0100
Message-Id: <1206573987.3912.57.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Lifeview flydvb-t duo min pci
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

Hi Bart,

Am Montag, den 24.03.2008, 21:03 +0100 schrieb Bart Michiels: 
> Hello,
> 
> I found your emailadress in the mailinglist on video4linux

thanks for your report, but better post to the lists.
We must have it there anyhow, also possible patches and if I'm in delay,
like currently, somebody else of the group might have picked it up
already.

> I have a problem with my flydvb-t duo mini pci card. It provides analog 
> tv and digital tv (dvb-t).

There is another PCI Mini seen on Asus W2 laptops with the same PCI
subsystem, but comes up with gpio init 0x50000 and has several different
bytes in the eeprom, they also seem to indicate that this one has two
tuners (DUO), but yours rather has only one (HYBRID).

> The flydvb-t duo mini pci  is an OEM model that is included in the 
> Medion MD95500 notebook from 3 years ago

Yes, remember we tried to look this up.

> It never autodetect because it is not in the saa7134 cardlist
> the ID is   5168  0307

Yes, not in saa7134-cards.c auto detection yet.

> I donwloaded the lastest sourcode of v4L on the site.
> I compiled it without changing anything and now i can get my card working.
> 
> After every reboot i have load it manually.
> 
> Sudo rmmod saa7134-alsa
> Sudo rmmod saa7134-dvb
> Sudo rmmod saa7134
> Sudo rmmod tuner
> 
> when i removed this module i load card 94
> 
> sudo modprobe saa7134 card=94 i2c_scan=1
> 
> Now my card is working but it is not very stable sometimes my linux hangs

That later by Hartmut added card has the special, to switch on a saa713x
gpio pin from analog to digital, but others don't report problems. 

> My dmesg output with my working card:
> 
> [  126.916000] saa7130/34: v4l2 driver version 0.2.14 loaded
> [  126.916000] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, 
> latency: 181, mmio: 0xb4007800
> [  126.916000] saa7133[0]: subsystem: 5168:0307, board: LifeView 
> FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB [card=94,insmod option]
> [  126.916000] saa7133[0]: board init: gpio is 10000
> [  127.068000] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 
> a9 1c 55 d2 b2 92
> [  127.068000] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 
> 01 e7 ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 
> 22 15 ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.068000] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [  127.076000] saa7133[0]: i2c scan: found device @ 0x10  [???]
tda10046 digital demodulator 
> [  127.092000] saa7133[0]: i2c scan: found device @ 0x96  [???]
analog demodulator and i2c gate for analog tuning 
> [  127.100000] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [  127.196000] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
> [  127.276000] tda829x 0-004b: setting tuner address to 61
tuner at 0x61, 7bit notation 
> [  127.340000] tda829x 0-004b: type set to tda8290+75
old not hybrid tda8275 tuner, Hmm ! 
> [  132.028000] saa7133[0]: registered device video0 [v4l2]
> [  132.028000] saa7133[0]: registered device vbi0
> [  132.028000] saa7133[0]: registered device radio0
> [  132.112000] saa7134 ALSA driver for DMA sound loaded
> [  132.112000] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 
> registered as card -2
> [  133.432000] DVB: registering new adapter (saa7133[0])
> [  133.432000] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> [  133.532000] tda1004x: setting up plls for 48MHz sampling clock
> [  135.532000] tda1004x: found firmware revision 29 -- ok
> 
> 
> 
> The dvb-t is working now but i did not test the analog part.
> 
> I also think there some errors:
> [  127.076000] saa7133[0]: i2c scan: found device @ 0x10  [???]
> [  127.092000] saa7133[0]: i2c scan: found device @ 0x96  [???]

That is OK. We need debug and reports for the analog part too.

> and on the net most card have normal gpio number , my card hasn't now
> [  126.916000] saa7133[0]: board init: gpio is 10000
> 
> Is it possible to add this card to the saa7134 driverlist?
> I really hope so.
> I already tried to add the card in the cardlist.c and in the 
> documentation and i compiled. the card is recognized but it doesn't work.
> I also tried to change the already added card 5168 3307 into 5168 0307 
> but i doens't work either.

Should work, a saa7133 device and 5168:0307 is not in use yet.

> Sounds very strange.
> I hope you or the community can do something with this information to 
> support this card too

Yes, but there is not any reason for failing auto detection, but we must
at first investigate also the analog tuning.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
