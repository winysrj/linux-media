Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4TEn75x008431
	for <video4linux-list@redhat.com>; Fri, 29 May 2009 10:49:08 -0400
Received: from smtp07.online.nl (smtp07.online.nl [194.134.42.52])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n4TEml88027184
	for <video4linux-list@redhat.com>; Fri, 29 May 2009 10:48:48 -0400
Received: from smtp07.online.nl (localhost [127.0.0.1])
	by smtp07.online.nl (Postfix) with ESMTP id 4A5A6983C2
	for <video4linux-list@redhat.com>;
	Fri, 29 May 2009 16:48:47 +0200 (CEST)
Received: from sander-desktop.localnet (unknown [83.119.175.103])
	by smtp07.online.nl (Postfix) with ESMTP
	for <video4linux-list@redhat.com>;
	Fri, 29 May 2009 16:48:47 +0200 (CEST)
From: Sander Pientka <cumulus0007@gmail.com>
To: video4linux-list@redhat.com
Date: Fri, 29 May 2009 16:48:46 +0200
MIME-Version: 1.0
Message-Id: <200905291648.46809.cumulus0007@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Subject: Zolid Hybrid TV Tuner not working
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
I've bought a Zolid Hyrbid TV Tuner. This card supports both analog and 
digital (DVB-T) signals, so it's hybrid. The card has the following chips on 
it:

 - A NXP SAA7131E/03/G
 - A NXP TDA 18271
 - A NXP TDA 10048

I don't know much about tv cards, but I suppose the SAA is the video processor 
and the TDA chips convert the TV signal to a usable signal.
The card gets detected by the saa7314 driver, but this driver identiefies the 
card as "UNKOWN/GENERIC". The card is not listed in the saa7134 card list. 
It's EEPROM is:

[   17.232053] saa7133[0]: i2c eeprom 00: 31 11 04 20 54 20 1c 00 43 43 a9 1c 
55 d2 b2 92
[   17.232080] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   17.232105] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 b2 ff 
ff ff ff
[   17.232129] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232153] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 03 32 21 05 ff ff ff ff 
ff ff
[   17.232177] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232201] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232225] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232249] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232274] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232298] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232321] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232345] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232370] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232393] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.232417] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

Programs like KDETV and TVTime only show a black screen with some background 
noise. Scanning doesn't result a thing.

I literally can't find the card anywhere: not on the V4L wiki, nor on 
Google.com/linux, etc. The card happens to be sold in my region only 
(Netherlands), so there is not much available about this card. Zolid sells 
another TV card, the Zolid Xpert TV7134, which is supported well by Linux.

For more information, please see this bug I filed: 
https://bugs.launchpad.net/bugs/373857
Does anyone know how to get this card working?
-- 
Met vriendelijke groet,
Sander Pientka
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
