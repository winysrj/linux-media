Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m44KM2Bv021230
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 16:22:02 -0400
Received: from mailout05.t-online.de (mailout05.t-online.de [194.25.134.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m44KLoGE022529
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 16:21:51 -0400
Message-ID: <481E1AD3.2060304@t-online.de>
Date: Sun, 04 May 2008 22:21:39 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Emilio Lazo Zaia <emiliolazozaia@gmail.com>
References: <88771.83842.qm@web83107.mail.mud.yahoo.com>	<1209512868.5699.32.camel@palomino.walls.org>
	<1209863718.546.24.camel@localhost.localdomain>
In-Reply-To: <1209863718.546.24.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hi, Emilio

Emilio Lazo Zaia schrieb:
> Hi Andy, Marc and all list members! Thanks for your answers!
> 
> El mar, 29-04-2008 a las 19:47 -0400, Andy Walls escribió:
>> Emilio,
>>
>> This card is handled by the saa7134, module, not the ivtv module, so
>> newi2c doesn't apply.
> 
> Yes Andy, I know! I'm trying with saa7134 and have tested all cards
> listed in kernel source's CARDLIST.saa7134 and all these reported "Huh,
> no eeprom present". After that I've tested with all tuners listed in
> CARDLIST.tuner with the same card=56 parameter and the results were
> similar: the same "no eeprom" message and a blue screen in TV input
> mode.
> 
>> "err=-5" is -EIO, referring to an I2C bus error with the i2c bus of the
>> saa7133.
>> With the saa7134 module "/sbin/modinfo" has two interesting options:
>> i2c_scan and i2c_debug which you may wish to try.
> 
> With this two options, I have these interesting messages in kernel log:
> 
>> Apr 29 22:47:20 uqbar kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: found at 0000:06:00.0, rev: 209, irq: 17, latency: 64, mmio: 0x54000000
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: subsystem: 1131:0000, board: Avermedia AVerTV 307 [card=56,insmod option]
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: board init: gpio is e2c0c4
>> Apr 29 22:47:20 uqbar kernel: input: saa7134 IR (Avermedia AVerTV 30 as /class/input/input14
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < a0 ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: Huh, no eeprom present (err=-5)?
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
>> .
>> .
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 97 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c scan: found device @ 0x96  [???]
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
>> .
>> .
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 01 02 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 00 00 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 07 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 97 =00 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 01 04 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 00 00 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 96 07 >
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < 97 =7b >
>> Apr 29 22:47:20 uqbar kernel: tuner 0-004b: chip found @ 0x96 (saa7133[0])
>> Apr 29 22:47:20 uqbar kernel: tuner i2c attach [addr=0x4b,client=(tuner unset)]
>> Apr 29 22:47:20 uqbar kernel: tuner-simple 0-004b: type set to 2 (Philips NTSC (FI1236,FM1236 and compatibles))
>> Apr 29 22:47:20 uqbar kernel: tuner 0-004b: type set to Philips NTSC (FI123
>> Apr 29 22:47:20 uqbar kernel: tuner-simple 0-004b: type set to 2 (Philips NTSC (FI1236,FM1236 and compatibles))
>> Apr 29 22:47:20 uqbar kernel: tuner 0-004b: type set to Philips NTSC (FI123
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
>> .
>> .
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: registered device video0 [v4l2]
>> Apr 29 22:47:20 uqbar kernel: saa7133[0]: registered device vbi0
>> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 1b 6f 8e 90 >
>> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 1b 6f 8e 90 >
>> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 1b dc 8e 90 >
>> Apr 29 22:47:21 uqbar last message repeated 2 times
>> Apr 29 22:47:21 uqbar kernel: saa7133[0]: i2c xfer: < 96 8e a0 07 b0 >
>>
> 
> Card is found at 0x96, but what tuner and card number combination may
> work for this card? What other debugging information can I supply to add
> this card to the list of supported cards in saa7134 module?
> 
> Thanks! Regards.
> 
There are many saa713x based cards without eeprom. It stores the vendor ID and
- in many cases - the board configuration. For you this means
- you need to find out the configuration the hard way
   * identify the chips on the card
   * find the input configuration by try and error
- You will always need to force the card type with a card=xxx option, there is
   no way to automatically identify the card.

So please have a close look at the card and write down all chip types. Is there
a metal box with the antenna connector on the card? What is its type?

Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
