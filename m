Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <legrandluc@gmail.com>) id 1LAiuW-0004HG-4S
	for linux-dvb@linuxtv.org; Thu, 11 Dec 2008 11:36:50 +0100
Received: by rv-out-0506.google.com with SMTP id b25so813416rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 11 Dec 2008 02:36:42 -0800 (PST)
Message-ID: <9f2475180812110236k24526291q9d117c379c498d1e@mail.gmail.com>
Date: Thu, 11 Dec 2008 11:36:42 +0100
From: "luc legrand" <legrandluc@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <493AC65E.3010900@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <493AC65E.3010900@googlemail.com>
Subject: Re: [linux-dvb] saa7134 with Avermedia M115S hybrid card
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi !

I suppose that this card (avermedia M115S) is really close to avermedia M115.
I have an avermedia M115.
I was unable to get this hardware running with v4l-dvb driver from
linuxtv neither analogic, nor dvb-t.
But it worked very well with the driver from Markus Rechberger at mcentral.de.
Last time I tried, it was with a kernel 2.6.25 and
v4l-dvb-experimental from markus Rechberger.
Maybe you can give it a try ?
Good luck.

Luc

2008/12/6 Alexander Weber <xweber.alex@googlemail.com>:
> Hi,
>
> there has been some mails before for getting this piece of hardware up
> and running. I'll did some attempts to fire it up but without success.
> Since Hermann already (thank you!) to a email before I will post the
> continuing story now here to the list, since it is a much better place.
>
> To that card:
> its a hybrid dvb-t card (tested that within windows) with a analogue
> radio part.
>
> Doing a closer .inf file from the original driver:
>
> as "device" its mentioned a "7133" and i would guess its a SAA7133 which
> makes some sense...
>
> An interesting line is:
> ; Setting FM radio of the Silicon tuner via SIF (GPIO 21 in use/ 5.5MHz)
> ; Dennis 20050415 for XC3028 FM Radio IF
> HKR, "Audio", "FM Radio IF",0x00010001,0xDEEAAB
>
> so the tuner should be a XC3028 and thats may be the reason why its
> called "hybrid" card. A analogue part for the radio and the digital
> dvb-t part.
>
> The main problem: the tuner does not "fire up". There is no visible
> attempt in dmesg output that a tuner or firmware is loaded or requested.
>
> to the force:
> HKR, "Parameters", "ForceTunerOn", 0x00010001, 1
>
> how can i manually force this here?
>
> To i2c - again the .inf file reads:
> ; I2C Device settings
> HKR, "I2C Devices", "Number of I2C Devices",0x00010001,1
> HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x65,0x00,0x00,0x00 ;
> Tuner ID
> HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC0,0x00,0x00,0x00 ;
> Tuner slave addr.
> HKR, "I2C Devices", "Device 0, Data3",0x00010001,0xC2,0x00,0x00,0x00 ;
> HKR, "I2C Devices", "Device 0, Data4",0x00010001,0x1E,0x00,0x00,0x00 ;
>
> So maybe that give anybody of you a idea how to use that.
>
> modprobe saa7134 with...
>
> ...card=136 i2c-scan=1
>
> saa7133[0]: i2c scan: found device @ 0x82  [???]
> saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> mt352_read_register: readreg error (reg=127, ret==-5)
>
>
> i have never come that far, that a radio was registered - but still now
> tuner request shows up.
>
>
> ...card=115 i2c-scan=1
> saa7133[0]: i2c scan: found device @ 0x82  [???]
> saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
>
> ......card=138 i2c-scan=1
> same as above
>
> TIA
> Alex
>
> PS: here the output from
> ...card=115 i2c-scan=1 video-debug=1 i2c-debug=1 irq-debug=1 core-debug=1
>
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: found at 0000:08:04.0, rev: 209, irq: 22, latency: 64, mmio:
> 0xfc006800
> saa7133[0]: subsystem: 1461:e836, board: Sabrent PCMCIA TV-PCB05
> [card=115,insmod option]
> saa7133[0]: board init: gpio is effffff
> saa7133[0]/core: hwinit1
> saa7133[0]: i2c xfer: < 20 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 96 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ca ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < cc ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ce ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d0 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d2 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d4 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d6 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d8 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < da ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < dc ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a0 00 >
> saa7133[0]: i2c xfer: < a1 =61 =14 =36 =e8 =00 =00 =00 =00 =00 =00 =00
> =00 =00 =00 =00 =00 =ff =ff =ff =ff =ff =20 =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =01 =40 =01 =02 =02 =01 =01 =03 =08 =ff =00 =00 =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =65 =00 =ff =c2 =00 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =0d =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
> saa7133[0]: i2c eeprom 00: 61 14 36 e8 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 00 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 00 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: 0d ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 03 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 05 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 07 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 09 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 0b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 0d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 0f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 11 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 13 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 15 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 17 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 19 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 1b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 1d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 1f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 21 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 23 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 25 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 27 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 29 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 2b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 2d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 2f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 31 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 33 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 35 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 37 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 39 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 3b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 3d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 3f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 41 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 43 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 45 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 47 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 49 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 4b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 4d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 4f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 51 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 53 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 55 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 57 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 59 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 5b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 5d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 5f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 61 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 63 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 65 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 67 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 69 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 6b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 6d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 6f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 71 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 73 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 75 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 77 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 79 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 7b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 7d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 7f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 81 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 83 >
> saa7133[0]: i2c scan: found device @ 0x82  [???]
> saa7133[0]: i2c xfer: < 85 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 87 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 89 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 8b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 8d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 91 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 93 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 97 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a1 >
> saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ab ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ad ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < af ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < bb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < bd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < bf ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < cb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < cd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < cf ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < db ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < dd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < df ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < eb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ed ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ef ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < fb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < fd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
> saa7133[0]/core: hwinit2
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_QUERYCAP
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOCGCAP
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_QUERYCAP
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_G_FBUF
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_ENUMINPUT
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_ENUMINPUT
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_ENUMINPUT
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_ENUMINPUT
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_ENUMINPUT
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_ENUM_FMT
> saa7133[0] vbi (Sabrent PCMCIA : VIDIOC_TRY_FMT
> saa7133[0] video (Sabrent PCMCI: VIDIOC_QUERYCAP
> saa7133[0] video (Sabrent PCMCI: VIDIOCGCAP
> saa7133[0] video (Sabrent PCMCI: VIDIOC_QUERYCAP
> saa7133[0] video (Sabrent PCMCI: VIDIOC_G_FBUF
> saa7133[0] video (Sabrent PCMCI: VIDIOC_ENUMINPUT
> saa7133[0] video (Sabrent PCMCI: VIDIOC_ENUMINPUT
> saa7133[0] video (Sabrent PCMCI: VIDIOC_ENUMINPUT
> saa7133[0] video (Sabrent PCMCI: VIDIOC_ENUMINPUT
> saa7133[0] video (Sabrent PCMCI: VIDIOC_ENUMINPUT
> saa7133[0] video (Sabrent PCMCI: VIDIOC_ENUM_FMT
> saa7133[0] video (Sabrent PCMCI: VIDIOC_TRY_FMT
>
>
>
>
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
