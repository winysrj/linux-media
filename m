Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1L9m69-0001Gj-5y
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 20:48:54 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: xweber.alex@googlemail.com
In-Reply-To: <493AF18D.6010400@googlemail.com>
References: <493AC65E.3010900@googlemail.com> <493AF18D.6010400@googlemail.com>
Date: Mon, 08 Dec 2008 20:43:55 +0100
Message-Id: <1228765435.2587.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

Hi Alex,

Am Samstag, den 06.12.2008, 22:41 +0100 schrieb Alexander Weber: 
> Hi again,
> 
> now i modified the saa7134 as described here:
> 
> http://www.spinics.net/lists/linux-dvb/msg27720.html
> 
> 
> the output in loading modified saa7134 with card=138:
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: found at 0000:08:04.0, rev: 209, irq: 22, latency: 64, mmio: 
> 0xfc006800
> saa7133[0]: subsystem: 1461:e836, board: Avermedia M115 [card=138,insmod 
> option]
> saa7133[0]: board init: gpio is a400000
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
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> dvb_init() allocating 1 frontend
> mt352_read_register: readreg error (reg=127, ret==-5)
> 
> 
> Alex
> 

just a note.

The supported Avermedia hybrid cards have 1e (>>1, 0x0f) in the eeprom
for the digital channel decoder after c2/0x61 for the tuner address.
Yours 00 and the i2c_scan revealed only a device at 0x82.

We fail here for the mt352 at 1e >> 1 and it could be something else or
it is at least not in a minimum power state.

Also 0x82 at the i2c_scan could be the hardware mpeg encoder announced
on these devices. Else, crawling the web, seemingly nothing new since
two years back. The same fuzzy picture only and no details.

Tuner 65 in the eeprom is for all the same and should be the XCeive
3028.

>From the Avermedia cards with XCeive 3028 only card=137 is left to test.
It uses gpio21 to get the tuner out of reset, but you seem to have tried
it already and that will fail on the mt352 as well.

I did not find any details about the mpeg encoder and its adress yet,
but had something in the past and think it is from NEC.


Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
