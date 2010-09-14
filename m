Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab0INWLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 18:11:30 -0400
Message-ID: <4C8FF30B.2080900@redhat.com>
Date: Tue, 14 Sep 2010 19:11:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIEt1xbpuaWFy?= <pawel@kuzniar.com.pl>
CC: linux-media@vger.kernel.org
Subject: Re: Videomed Videosmart VX-3001
References: <AANLkTinSB_ChWLnR=hQ6jAuRtgeLm0dze6f4mTy5buNt@mail.gmail.com>
In-Reply-To: <AANLkTinSB_ChWLnR=hQ6jAuRtgeLm0dze6f4mTy5buNt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-09-2010 13:19, Paweł Kuźniar escreveu:
> I've just got my hands on Videosmart VX-3001 medical video-grabber. It
> seems it has some common hardware under the hood, but I only managed
> to get dark-green screen in Cheese.  I include some of my specs,
> dmesg and lsub. Being completely green in driver development I'd like
> to get some help in figuring out  how to make it work.

Ok, yet another em28xx webcam ;)

> 
> [  177.200295] usb 1-3: new high speed USB device using ehci_hcd and address 4
> [  177.492308] Linux video capture interface: v2.00
> [  177.493907] IR NEC protocol handler initialized
> [  177.499529] IR RC5(x) protocol handler initialized
> [  177.564668] IR RC6 protocol handler initialized
> [  177.570875] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
> [  177.571060] em28xx #0: chip ID is em2860
> [  177.618639] IR JVC protocol handler initialized
> [  177.621594] IR Sony protocol handler initialized
> [  177.667519] lirc_dev: IR Remote Control driver registered, major 250
> [  177.669829] IR LIRC bridge handler initialized
> [  177.741359] em28xx #0: i2c eeprom 00: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741386] em28xx #0: i2c eeprom 10: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741409] em28xx #0: i2c eeprom 20: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741431] em28xx #0: i2c eeprom 30: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741453] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741476] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741498] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741520] em28xx #0: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741542] em28xx #0: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741564] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741586] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741608] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741630] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741652] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741674] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741696] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  177.741719] em28xx #0: EEPROM ID= 0x00000000, EEPROM hash = 0x00000000
> [  177.741724] em28xx #0: EEPROM info:

Something got wrong at I2C. It is just returning zero for everything.

> [  177.741728] em28xx #0:       No audio on board.
> [  177.741732] em28xx #0:       500mA max power
> [  177.741737] em28xx #0:       Table at 0x00, strings=0x0000, 0x0000, 0x0000
> [  177.763662] Unknown Micron Sensor 0x0000

There's no sensor 0x0000.

> [  177.763672] em28xx #0: Identified as Unknown EM2750/28xx video
> grabber (card=1)
> [  177.764416] em28xx #0: found i2c device @ 0x0 [???]
> [  177.765167] em28xx #0: found i2c device @ 0x2 [???]
> [  177.765912] em28xx #0: found i2c device @ 0x4 [???]
...
> [  177.818696] em28xx #0: found i2c device @ 0xfe [???]

See? It is returning zero for everything at the I2C bus.

> [  180.220449] 4:2:1: endpoint lacks sample rate attribute bit, cannot set.
> [  180.220561] 4:2:2: endpoint lacks sample rate attribute bit, cannot set.
> [  180.220684] 4:2:3: endpoint lacks sample rate attribute bit, cannot set.
> [  180.220808] 4:2:4: endpoint lacks sample rate attribute bit, cannot set.
> [  180.220936] 4:2:5: endpoint lacks sample rate attribute bit, cannot set.
> [  180.224764] usbcore: registered new interface driver snd-usb-audio
> [  180.311098] 4:2:2: endpoint lacks sample rate attribute bit, cannot set.
> [  180.313775] 4:2:2: endpoint lacks sample rate attribute bit, cannot set.

This also doesn't sound good.

There are a few frequencies that could be used for I2C:

#define EM28XX_I2C_FREQ_1_5_MHZ		0x03 /* bus frequency (bits [1-0]) */
#define EM28XX_I2C_FREQ_25_KHZ		0x02
#define EM28XX_I2C_FREQ_400_KHZ		0x01
#define EM28XX_I2C_FREQ_100_KHZ		0x00

In general, most hardware accept up to 100 kHz, but there are a few devices where this 
needs to be reduced to 25 kHz in order to work. We never found one em28xx-based hardware 
needing to reduce I2C speed, but it seems that you got one ;)

Eventually, this might also be caused by a device responding badly to i2c scan.


Please try the enclosed patch, forcing the driver to use card=1, by adding:
	option em28xx card=1

at /etc/modprobe (or the similar modprobe config on your distro).

This patch should reduce the bus speed to 25 kHz, hopefully giving us more information
about your device.

Cheers,
Mauro

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ffbe544..0213536 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -278,6 +278,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_SAA711X,
 		.tuner_type   = TUNER_ABSENT,
+		.i2c_speed	= EM28XX_I2C_FREQ_25_KHZ,
 		.input        = { {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = SAA7115_COMPOSITE0,
