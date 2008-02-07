Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fmmailgate03.web.de ([217.72.192.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hubblest@web.de>) id 1JNEAG-0002zm-FU
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 22:20:12 +0100
From: Peter Meszmer <hubblest@web.de>
To: linux-dvb@linuxtv.org
Date: Thu, 7 Feb 2008 22:19:40 +0100
References: <47AB228E.3080303@gmail.com> <200802072013.41966.zzam@gentoo.org>
In-Reply-To: <200802072013.41966.zzam@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802072219.40759.hubblest@web.de>
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

Am Donnerstag, 7. Februar 2008 schrieben Sie:
> @Peter:
> 1. Maybe you want to start a page in the wiki dedicated to your card.
> Or should we check for similarity and merge both of these cards into one
> page?
>
> At least I am interested in the eeprom content of your card.
>
> I should request some schematics from Avermedia to maybe get gpio
> controlling correct. (Like resetting chips, ir ...)
>
> Regards
> Matthias

Hello Matthias,

the eeprom content is slightly different form the one shown on the wiki:

saa7133[0]: found at 0000:02:07.0, rev: 209, irq: 18, latency: 64, mmio: 
0xd3024000
saa7133[0]: subsystem: 1461:a7a2, board: Avermedia A700 
[card=132,autodetected]
saa7133[0]: board init: gpio is 48a00
saa7133[0]: i2c eeprom 00: 61 14 a2 a7 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: 00 01 81 af d7 09 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
DVB: registering new adapter (saa7133[0])

Writing a page in the wiki sounds interesting, but I think, I shouldn't start 
this project. So I would prefer to merge the information of both cards.

Best regards
Peter Meszmer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
