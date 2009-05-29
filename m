Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:55257 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbZE2Xn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 19:43:59 -0400
Subject: Re: Zolid Hybrid TV Tuner not working
From: hermann pitton <hermann-pitton@arcor.de>
To: Sander Pientka <cumulus0007@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200905291945.30291.cumulus0007@gmail.com>
References: <200905291648.46809.cumulus0007@gmail.com>
	 <200905291834.52700.cumulus0007@gmail.com>
	 <1243617390.6147.22.camel@pc07.localdom.local>
	 <200905291945.30291.cumulus0007@gmail.com>
Content-Type: text/plain
Date: Sat, 30 May 2009 01:37:52 +0200
Message-Id: <1243640272.6147.53.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Freitag, den 29.05.2009, 19:45 +0200 schrieb Sander Pientka:
> Op vrijdag 29 mei 2009 19:16:30 schreef u:
> > Am Freitag, den 29.05.2009, 18:34 +0200 schrieb Sander Pientka:
> > > Op vrijdag 29 mei 2009 17:42:26 schreef u:
> > > > Hi,
> > > >
> > > > Am Freitag, den 29.05.2009, 16:48 +0200 schrieb Sander Pientka:
> > > > > Hi,
> > > > > I've bought a Zolid Hyrbid TV Tuner. This card supports both
> > >
> > > analog and
> > >
> > > > > digital (DVB-T) signals, so it's hybrid. The card has the
> > >
> > > following chips
> > >
> > > > > on it:
> > > > >
> > > > > - A NXP SAA7131E/03/G
> > > > > - A NXP TDA 18271
> > > > > - A NXP TDA 10048
> > > > >
> > > > > I don't know much about tv cards, but I suppose the SAA is the
> > >
> > > video
> > >
> > > > > processor and the TDA chips convert the TV signal to a usable
> > >
> > > signal.
> > >
> > > > > The card gets detected by the saa7314 driver, but this driver
> > >
> > > identiefies
> > >
> > > > > the card as "UNKOWN/GENERIC". The card is not listed in the
> > >
> > > saa7134 card
> > >
> > > > > list. It's EEPROM is:
> > > > >
> > > > > [ 17.232053] saa7133[0]: i2c eeprom 00: 31 11 04 20 54 20 1c
> 00 43
> > >
> > > 43
> > >
> > > > > a9 1c
> > > >
> > > > -not valid for subvendor, is vendor Philips ^^^^^
> > > >
> > > > > 55 d2 b2 92
> > > > > [ 17.232080] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff [ 17.232105] saa7133[0]: i2c eeprom 20: 01
> 40 01
> > >
> > > 02
> > >
> > > > > 03 01 01 03 08 ff 00 b2 ff ff ff ff
> > > > > [ 17.232129] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff [ 17.232153] saa7133[0]: i2c eeprom 40: ff
> 35 00
> > >
> > > c0
> > >
> > > > > 96 10 03 32 21 05 ff ff ff ff ff ff
> > > > > [ 17.232177] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff [ 17.232201] saa7133[0]: i2c eeprom 60: ff
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff ff ff ff ff ff ff [ 17.232225] saa7133[0]:
> i2c
> > >
> > > eeprom
> > >
> > > > > 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 17.232249]
> > > > > saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff
> ff
> > >
> > > ff ff
> > >
> > > > > ff [ 17.232274] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff ff [ 17.232298] saa7133[0]: i2c eeprom a0:
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff ff ff ff ff ff ff ff [ 17.232321]
> saa7133[0]:
> > >
> > > i2c
> > >
> > > > > eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > >
> > > [ 17.232345]
> > >
> > > > > saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff
> ff
> > >
> > > ff ff
> > >
> > > > > ff [ 17.232370] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff ff [ 17.232393] saa7133[0]: i2c eeprom e0:
> ff ff
> > >
> > > ff
> > >
> > > > > ff ff ff ff ff ff ff ff ff ff ff ff ff [ 17.232417]
> saa7133[0]:
> > >
> > > i2c
> > >
> > > > > eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > > >
> > > > > Programs like KDETV and TVTime only show a black screen with
> some
> > > > > background noise. Scanning doesn't result a thing.
> > > > >
> > > > > I literally can't find the card anywhere: not on the V4L wiki,
> nor
> > >
> > > on
> > >
> > > > > Google.com/linux, etc. The card happens to be sold in my
> region
> > >
> > > only
> > >
> > > > > (Netherlands), so there is not much available about this card.
> > >
> > > Zolid
> > >
> > > > > sells another TV card, the Zolid Xpert TV7134, which is
> supported
> > >
> > > well by
> > >
> > > > > Linux.
> > > >
> > > > hehe, a similar card was seen first time just a few days back
> and
> > >
> > > you
> > >
> > > > file bugs against us ? ;)
> > >
> > >
> http://www.linuxtv.org/wiki/index.php/Development:_How_to_add_support_for
> > >_a
> > >
> > > >_device
> > > >
> > > > Closest currently is:
> > > >
> > > > saa7133[0]: subsystem: 0070:6707, board: Hauppauge
> WinTV-HVR1110r3
> > > > DVB-T/Hybrid [card=156,autodetected]
> > > > saa7133[0]: board init: gpio is 440100
> > > >
> > > > You can find firmware here:
> > > >
> > > > http://www.steventoth.net/linux/hvr1200
> > > >
> > > > You need the recent v4l-dvb from linuxtv.org for testing.
> > > > Don't cry, if nothing works at all or your card is burned ;)
> > > >
> > > > Cheers,
> > > > Hermann
> > >
> > > Hi Hermann,
> > > thanks for your reply! I've compiled the latest v4l-dvb and
> installed
> > > the firmware as you said. Still, the card gets detected as
> > > UNKOWN/GENERIC. Should I try the card parameters of the Hauppauge
> > > WinTV-HVR1110r3 and see if it works?
> >
> > Yes, you can give "modprobe -v saa7134 card=156" i2c_scan=1 a try.
> > The card was just added by Michael Krufky.
> >
> > modprobe -vr saa7134-dvb saa7134-alsa or
> > "make rmmod" on top of v4l-dvb previously.
> >
> > Take care, on saa7134-alsa mixers might have use count.
> > You might have to close them previously or set
> > "options saa7134 alsa=0" for next boot.
> >
> > BTW, we moved to linux-media@vger.kernel.org.
> > You can find links to archives at linuxtv.org and what was going on
> so
> > far with the HVR1110r3. Antonio Beamud had such a card last days.
> >
> > You will get some errors printed for unknown Hauppauge eeprom and I
> know
> > nothing about, if the gpio configuration has any chance to be the
> same,
> > but tuner and DVB-T demodulator seem to be at the same address.
> >
> > Cheers,
> > Hermann
> Hi,
> eveything seems to work much better now. My tuner and demodulator get
> detected now and the firmware is loaded. Kaffeine detects my card and
> lets me scan for channels, but it gives me the following message: 
> /dev/dvb/adapter0/ca0: no such device
> 
> 
> 
> and a looot of this:
> 
> 
> 
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> 
> 
> 
> so Kaffeine won't find any channel.
> 
> 
> 
> Btw, I will register for that mailing list :)

Sander,

you can post, even if not subscribed.

Here it goes out to it, that you might have some follow up.

Doesn't look such bad anymore, except all DVB-T is scrambled?

Don't think so.

Cheers,
Hermann



