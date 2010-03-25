Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:56339 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab0CYT0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Mar 2010 15:26:31 -0400
Subject: Re: Which of my 3 video capture devices will work best with my PC?
From: hermann pitton <hermann-pitton@arcor.de>
To: Serge Pontejos <jeepster.goons@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1269471975.6885.54.camel@pc07.localdom.local>
References: <dfbf38831003241545s48e717c6i366599fd705c221c@mail.gmail.com>
	 <1269471975.6885.54.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Thu, 25 Mar 2010 20:18:51 +0100
Message-Id: <1269544731.3273.8.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Serge,

Am Donnerstag, den 25.03.2010, 00:06 +0100 schrieb hermann pitton:
> Am Mittwoch, den 24.03.2010, 16:45 -0600 schrieb Serge Pontejos:
> > Greetings all...
> > 
> > I'm interested in doing video transfer from VCR to PC and want to know
> > which of the 3 capture devices I have has the best chance of working
> > with my setup? I have 3 different symptoms happening with each.
> > 
> > My PC setup:
> > Ubuntu Karmic 9.10/2.6.31-20 generic
> > Socket 754 AMD Sempron 3000+ with passive cooling (non AMD64)
> > Biostar MB with Nforce3 250Gb chipset
> > NV31 GPU (Geforce FX5600 Ultra 128MB) using Nvidia 196 driver
> > 1GB PC3200 DDR RAM
> > 34GB SCSI coupled to a Adaptec 19160 card
> > Soundblaster Audigy
> > dvd+-R floppy etc etc.
> > 
> > The devices in question:
> > 
> > USB: Dazzle Digital Photo Maker, using a USBvision driver recognized
> > as a Global Village GV-7000)
> > 
> > --This one recognizes and I can display video but if I try to record
> > in either xawtv or Kdenlive the program crashes.
> > 
> > PCI: Hauppauge WinTV model 38101
> > --When installed it shows /dev/video0 when I do an ls, but I don't get
> > a signal with either composite or coax input.   I tried following
> > steps from this link http://howtoubuntu.org/?p=20 but it didn't change
> > a thing...
> > 
> > PCI: Aurora Systems Fuse previously used on a Mac
> > --This card picks up the ZR36067 driver, but it's saying it can't
> > initialize the i2c bus. Thus, no /dev/video* shows
> > 
> > Let me know which I should focus on and then I'll show the query dumps.
> 
> I guess you don't get any dog out of the hut with such offers.
> 
> ;)

please always provide us with the relevant dmesg output also for cards
with trouble.

Maybe we can fix them or at least others are informed about the issues
too.

The bttv WinTV model 38101 might be just a new revision and maybe the
tuner is just missing in tveeprom?

Old ones.

bttv0: Bt878 (rev 17) at 0000:05:04.0, irq: 18, latency: 66, mmio: 0xf8400000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 0-0050: Hauppauge model 38101, rev B410, serial# 1993042
tveeprom 0-0050: tuner model is Philips FI1236 MK2 (idx 10, type 2)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is None (idx 0)
tveeprom 0-0050: has no radio
bttv0: Hauppauge eeprom indicates model#38101

and

bttv0: Bt878 (rev 17) at 0000:05:04.0, irq: 18, latency: 66, mmio: 0xf8400000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 0-0050: Hauppauge model 38101, rev B426, serial# 1890608
tveeprom 0-0050: tuner model is Temic 4036FY5 (idx 26, type 8)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is None (idx 0)
tveeprom 0-0050: has no radio
bttv0: Hauppauge eeprom indicates model#38101

Cheers,
Hermann



