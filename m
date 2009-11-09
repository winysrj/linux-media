Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA9KcXVp003623
	for <video4linux-list@redhat.com>; Mon, 9 Nov 2009 15:38:33 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nA9KcUXK002969
	for <video4linux-list@redhat.com>; Mon, 9 Nov 2009 15:38:32 -0500
Message-ID: <4AF87D5D.5090205@gmx.net>
Date: Mon, 09 Nov 2009 21:36:45 +0100
From: Roland Egli <roland.egli@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Terratec Cinergy 600 TV MK3: Problem with Radio/RDS
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

Hi all

I have the TV card "Terratec Cinergy 600 TV MK3" with SAA7134HL. The 
tuner is a Philips FM1216ME/H-3 and there is an additional RDS decoder 
SAA6588T.

For loading the module I use
$ modprobe saa7134 card=48 tuner=38

TV works fine, but I have a problem with the radio. The sound is very 
noisy, not stereo and there is as well no RDS reception (saa6588 module 
is loaded as well).

The following infos go to the log:
Nov  9 21:33:52 oslo kernel: [ 1667.403249] saa7130/34: v4l2 driver 
version 0.2.15 loaded
Nov  9 21:33:52 oslo kernel: [ 1667.403319] saa7134[0]: found at 
0000:02:0b.0, rev: 1, irq: 23, latency: 64, mmio: 0xfeaff400
Nov  9 21:33:52 oslo kernel: [ 1667.403330] saa7134[0]: subsystem: 
153b:1158, board: Terratec Cinergy 600 TV MK3 [card=48,insmod option]
Nov  9 21:33:52 oslo kernel: [ 1667.403365] saa7134[0]: board init: gpio 
is 50000
Nov  9 21:33:52 oslo kernel: [ 1667.403483] input: saa7134 IR (Terratec 
Cinergy 60 as /devices/pci0000:00/0000:00:1e.0/0000:02:0b.0/input/input7
Nov  9 21:33:52 oslo kernel: [ 1667.403567] IRQ 23/saa7134[0]: 
IRQF_DISABLED is not guaranteed on shared IRQs
Nov  9 21:33:52 oslo kernel: [ 1667.559198] saa7134[0]: i2c eeprom 00: 
3b 15 58 11 ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559225] saa7134[0]: i2c eeprom 10: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559251] saa7134[0]: i2c eeprom 20: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559276] saa7134[0]: i2c eeprom 30: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559300] saa7134[0]: i2c eeprom 40: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559326] saa7134[0]: i2c eeprom 50: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559351] saa7134[0]: i2c eeprom 60: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559376] saa7134[0]: i2c eeprom 70: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559400] saa7134[0]: i2c eeprom 80: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559425] saa7134[0]: i2c eeprom 90: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559450] saa7134[0]: i2c eeprom a0: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559475] saa7134[0]: i2c eeprom b0: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559500] saa7134[0]: i2c eeprom c0: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559524] saa7134[0]: i2c eeprom d0: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559549] saa7134[0]: i2c eeprom e0: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559574] saa7134[0]: i2c eeprom f0: 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Nov  9 21:33:52 oslo kernel: [ 1667.559602] i2c-adapter i2c-0: Invalid 
7-bit address 0x7a
Nov  9 21:33:52 oslo kernel: [ 1667.592173] tuner 0-0043: chip found @ 
0x86 (saa7134[0])
Nov  9 21:33:52 oslo kernel: [ 1667.592284] tda9887 0-0043: creating new 
instance
Nov  9 21:33:52 oslo kernel: [ 1667.592287] tda9887 0-0043: 
tda988[5/6/7] found
Nov  9 21:33:52 oslo kernel: [ 1667.632092] All bytes are equal. It is 
not a TEA5767
Nov  9 21:33:52 oslo kernel: [ 1667.632309] tuner 0-0060: chip found @ 
0xc0 (saa7134[0])
Nov  9 21:33:52 oslo kernel: [ 1667.646672] tuner-simple 0-0060: 
creating new instance
Nov  9 21:33:52 oslo kernel: [ 1667.646680] tuner-simple 0-0060: type 
set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
Nov  9 21:33:52 oslo kernel: [ 1667.736118] saa6588 0-0010: saa6588 
found @ 0x20 (saa7134[0])
Nov  9 21:33:52 oslo kernel: [ 1667.744073] saa7134[0]: found RDS decoder
Nov  9 21:33:52 oslo kernel: [ 1667.752207] saa7134[0]: registered 
device video1 [v4l2]
Nov  9 21:33:52 oslo kernel: [ 1667.752276] saa7134[0]: registered 
device vbi0
Nov  9 21:33:52 oslo kernel: [ 1667.752337] saa7134[0]: registered 
device radio0
Nov  9 21:33:52 oslo kernel: [ 1667.768981] saa7134 ALSA driver for DMA 
sound loaded
Nov  9 21:33:52 oslo kernel: [ 1667.769069] IRQ 23/saa7134[0]: 
IRQF_DISABLED is not guaranteed on shared IRQs
Nov  9 21:33:52 oslo kernel: [ 1667.769109] saa7134[0]/alsa: saa7134[0] 
at 0xfeaff400 irq 23 registered as card -2

Does anyone have an idea about the reason for this problem or even 
better a solution?
Does anyone use the same card without problem?

Many thanks in advance.
Roland


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
