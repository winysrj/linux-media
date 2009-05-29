Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4TFluE6031598
	for <video4linux-list@redhat.com>; Fri, 29 May 2009 11:47:56 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n4TFlVu5016308
	for <video4linux-list@redhat.com>; Fri, 29 May 2009 11:47:31 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Sander Pientka <cumulus0007@gmail.com>
In-Reply-To: <200905291648.46809.cumulus0007@gmail.com>
References: <200905291648.46809.cumulus0007@gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 17:42:26 +0200
Message-Id: <1243611746.6147.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Zolid Hybrid TV Tuner not working
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

Am Freitag, den 29.05.2009, 16:48 +0200 schrieb Sander Pientka:
> Hi,
> I've bought a Zolid Hyrbid TV Tuner. This card supports both analog and 
> digital (DVB-T) signals, so it's hybrid. The card has the following chips on 
> it:
> 
>  - A NXP SAA7131E/03/G
>  - A NXP TDA 18271
>  - A NXP TDA 10048
> 
> I don't know much about tv cards, but I suppose the SAA is the video processor 
> and the TDA chips convert the TV signal to a usable signal.
> The card gets detected by the saa7314 driver, but this driver identiefies the 
> card as "UNKOWN/GENERIC". The card is not listed in the saa7134 card list. 
> It's EEPROM is:
> 
> [   17.232053] saa7133[0]: i2c eeprom 00: 31 11 04 20 54 20 1c 00 43 43 a9 1c 
-not valid for subvendor, is vendor Philips ^^^^^
> 55 d2 b2 92
> [   17.232080] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> [   17.232105] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 b2 ff 
> ff ff ff
> [   17.232129] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232153] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 03 32 21 05 ff ff ff ff 
> ff ff
> [   17.232177] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232201] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232225] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232249] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232274] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232298] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232321] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232345] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232370] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232393] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   17.232417] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> Programs like KDETV and TVTime only show a black screen with some background 
> noise. Scanning doesn't result a thing.
> 
> I literally can't find the card anywhere: not on the V4L wiki, nor on 
> Google.com/linux, etc. The card happens to be sold in my region only 
> (Netherlands), so there is not much available about this card. Zolid sells 
> another TV card, the Zolid Xpert TV7134, which is supported well by Linux.
> 

hehe, a similar card was seen first time just a few days back and you
file bugs against us ? ;)

http://www.linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device

Closest currently is:

saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1110r3 
DVB-T/Hybrid [card=156,autodetected]
saa7133[0]: board init: gpio is 440100

You can find firmware here:

http://www.steventoth.net/linux/hvr1200

You need the recent v4l-dvb from linuxtv.org for testing.
Don't cry, if nothing works at all or your card is burned ;)

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
