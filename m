Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m441FV75031606
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 21:15:31 -0400
Received: from rs25s9.datacenter.cha.cantv.net
	(rs25s9.datacenter.cha.cantv.net [200.44.33.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m441FJ6m029432
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 21:15:19 -0400
From: Emilio Lazo Zaia <emiliolazozaia@gmail.com>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1209512868.5699.32.camel@palomino.walls.org>
References: <88771.83842.qm@web83107.mail.mud.yahoo.com>
	<1209512868.5699.32.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 03 May 2008 20:45:17 -0430
Message-Id: <1209863718.546.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: MCE TV Philips 7135 Cardbus don't work
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

Hi Andy, Marc and all list members! Thanks for your answers!

El mar, 29-04-2008 a las 19:47 -0400, Andy Walls escribió:
> Emilio,
> 
> This card is handled by the saa7134, module, not the ivtv module, so
> newi2c doesn't apply.

Yes Andy, I know! I'm trying with saa7134 and have tested all cards
listed in kernel source's CARDLIST.saa7134 and all these reported "Huh,
no eeprom present". After that I've tested with all tuners listed in
CARDLIST.tuner with the same card=56 parameter and the results were
similar: the same "no eeprom" message and a blue screen in TV input
mode.

> "err=-5" is -EIO, referring to an I2C bus error with the i2c bus of the
> saa7133.
> With the saa7134 module "/sbin/modinfo" has two interesting options:
> i2c_scan and i2c_debug which you may wish to try.

With this two options, I have these interesting messages in kernel log:

> Apr 29 22:47:20 uqbar kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: found at 0000:06:00.0, rev: 209, irq: 17, latency: 64, mmio: 0x54000000
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: subsystem: 1131:0000, board: Avermedia AVerTV 307 [card=56,insmod option]
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: board init: gpio is e2c0c4
> Apr 29 22:47:20 uqbar kernel: input: saa7134 IR (Avermedia AVerTV 30 as /class/input/input14
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < a0 ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: Huh, no eeprom present (err=-5)?
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
> .
> .
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 97 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c scan: found device @ 0x96  [???]
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
> .
> .
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 01 02 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 00 00 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 07 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 97 =00 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 01 04 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 00 00 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 07 >
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 97 =7b >
> Apr 29 22:47:20 uqbar kernel: tuner 0-004b: chip found @ 0x96 (saa7133[0])
> Apr 29 22:47:20 uqbar kernel: tuner i2c attach [addr=0x4b,client=(tuner unset)]
> Apr 29 22:47:20 uqbar kernel: tuner-simple 0-004b: type set to 2 (Philips NTSC (FI1236,FM1236 and compatibles))
> Apr 29 22:47:20 uqbar kernel: tuner 0-004b: type set to Philips NTSC (FI123
> Apr 29 22:47:20 uqbar kernel: tuner-simple 0-004b: type set to 2 (Philips NTSC (FI1236,FM1236 and compatibles))
> Apr 29 22:47:20 uqbar kernel: tuner 0-004b: type set to Philips NTSC (FI123
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
> .
> .
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: registered device video0 [v4l2]
> Apr 29 22:47:20 uqbar kernel: saa7133[0]: registered device vbi0
> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 1b 6f 8e 90 >
> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 1b 6f 8e 90 >
> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 1b dc 8e 90 >
> Apr 29 22:47:21 uqbar last message repeated 2 times
> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 8e a0 07 b0 >
> 

Card is found at 0x96, but what tuner and card number combination may
work for this card? What other debugging information can I supply to add
this card to the list of supported cards in saa7134 module?

Thanks! Regards.

-- 
Emilio Lazo Zaia <emiliolazozaia@gmail.com>

Escuela de Física
Universidad Central de Venezuela


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
