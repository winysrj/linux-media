Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JP2LH-0005wP-Mz
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 22:07:03 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: Peter Meszmer <hubblest@web.de>
Date: Tue, 12 Feb 2008 22:06:29 +0100
References: <47AB228E.3080303@gmail.com> <200802072013.41966.zzam@gentoo.org>
	<200802072219.40759.hubblest@web.de>
In-Reply-To: <200802072219.40759.hubblest@web.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802122206.30369.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AVerMedia DVB-S Hybrid+FM and DVB-S Pro [A700]
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thursday 07 February 2008, you wrote:
> Am Donnerstag, 7. Februar 2008 schrieben Sie:
> > @Peter:
> > 1. Maybe you want to start a page in the wiki dedicated to your card.
> > Or should we check for similarity and merge both of these cards into one
> > page?
> >
> > At least I am interested in the eeprom content of your card.
> >
> > I should request some schematics from Avermedia to maybe get gpio
> > controlling correct. (Like resetting chips, ir ...)
> >
> > Regards
> > Matthias
>
> Hello Matthias,
>
> the eeprom content is slightly different form the one shown on the wiki:
>
> saa7133[0]: found at 0000:02:07.0, rev: 209, irq: 18, latency: 64, mmio:
> 0xd3024000
> saa7133[0]: subsystem: 1461:a7a2, board: Avermedia A700
> [card=132,autodetected]
> saa7133[0]: board init: gpio is 48a00
> saa7133[0]: i2c eeprom 00: 61 14 a2 a7 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: 00 01 81 af d7 09 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> DVB: registering new adapter (saa7133[0])
>
I added this to the wiki-page about A700:
http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)

Maybe we should rename the page to AverMedia_AverTV_DVB-S_A700 or anything 
similar.

* Could you load saa7134 module of unpatched driver, but with parameter 
i2c_scan=1.
* lspci -vvnn also should be interesting
* If you have a camera, could you do a picture, so we can get info about the 
used analog tuner. I guess it is some XC30??. But to get it running you 
should contact video4linux mailinglist.


Regards
Matthias

-- 
Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
