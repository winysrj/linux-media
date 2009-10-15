Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:55605 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092AbZJOXMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 19:12:08 -0400
Subject: Re: Request driver for cards
From: hermann pitton <hermann-pitton@arcor.de>
To: Theunis Potgieter <theunis.potgieter@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <23582ca0910150225w362af3a0m69c0be862f09cb9f@mail.gmail.com>
References: <23582ca0910140629g57366f4aq4c2e07462d9f18ef@mail.gmail.com>
	 <23582ca0910150225w362af3a0m69c0be862f09cb9f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Oct 2009 01:07:05 +0200
Message-Id: <1255648025.3261.49.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Theunis,

Am Donnerstag, den 15.10.2009, 11:25 +0200 schrieb Theunis Potgieter:
> On 14/10/2009, Theunis Potgieter <theunis.potgieter@gmail.com> wrote:
> > Hi, what is the procedure to request drivers for specific new, perhaps
> >  unknown supported cards?
> >
> >  I did have a look at http://www.linuxtv.org/wiki/index.php/Main_Page
> >  but it didn't contain any information about supported cards. Neither
> >  did 2.6.30 /usr/src/linux/Documentation/dvb/cards.txt for the
> >  following brands:
> >
> >  name, site:
> >  Compro, S300 http://www.comprousa.com/en/product/s300/s300.html
> >  K-World VS-DVB-S 100/IS,
> >  http://global.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&pcid=46&ifid=16&prodid=98
> >
> >  Perhaps I shouldn't waste time if I could find a dual/twin tuner card
> >  for dvb-s or dvb-s2. Are there any recommended twin-tuner pci-e cards
> >  that is support and can actually be bought by the average consumer?
> >
> >  Thanks
> >
> I guess this answers the Kworld on 2.6.30:
> 
> /usr/src/linux/drivers/media/dvb/frontends/cx24123.c: *   Support for
> KWorld DVB-S 100 by Vadim Catana <skystar@moldova.cc>
> 
> But how would I get compro S300 support?
> 
> Is there anybody that knows of a work inprogress or completed twin
> tuner type card in either pci or pci-e format?
> 
> Thanks in advance.

for the saa7134 driver, the Compro S300 is not a twin DVB-S tuner card.
The second RF connector is only RF loop through. The card has support as
card=169 with recent code.

On saa7134 only the Creatix CTX944 (Medion Quad, card=96 www.creatix.de)
has beside two DVB-T/analog hybrid tuners also two DVB-S tuners. S2 is
not supported and one of the DVB-S tuners has only support for
transponders with 18 Volt currently. This was a problem on prior Philips
windows drivers too, but is now fixed there. Maybe we can fix it once
too.

The second part of the twin LNB supply is not connected to i2c. The
voltage must be switched by some gpio pin.

Main problems, the card is Medion OEM only, on ebay and similar between
20 - 70€, and one needs a MSI/Medion motherboard with blue or green
multi bus master capable PCI slot.

Cheers,
Hermann




