Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-1.dlr.de ([195.37.61.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Lukas.Orlowski@dlr.de>) id 1KAkWd-0002sQ-2S
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 13:48:00 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Mon, 23 Jun 2008 13:50:12 +0200
Message-ID: <D28FC8DB666FC448B462784151E59C05024AA87B@exbe07.intra.dlr.de>
From: <Lukas.Orlowski@dlr.de>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Getting Avermedia AverTV E506 DVB-T to work
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

Hi Community

I am struggling to enjoy DVB-T on my AverTV E506 PCMCIA card. It seams
I'm doing something terribly wrong but I cannot find the solution on my
own. I am grateful for any help provided.

What I did so far:

I'm running Gentoo with a 2.6.24-r8 kernel on my Centrino Laptop. I have
selected "Video for Linux" (nothing else, no cards, no frontends, no
chips..) as a module in my kernel configuration and compiled the
"v4l-dvb" drivers from the mercurial repository. I also have obtained
the (hopefully) correct firmware for my card.

Well when I plug the PCMCIA device in this is what dmesg shows me:

pccard: CardBus card inserted into slot 1
PCI: Enabling device 0000:04:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNKA] -> GSI 5 (level, low)
-> IRQ 5
saa7133[0]: found at 0000:04:00.0, rev: 209, irq: 5, latency: 0, mmio:
0x98000000
PCI: Setting latency timer of device 0000:04:00.0 to 64
saa7133[0]: subsystem: 1461:f436, board: AVerMedia Cardbus TV/Radio
(E506R) [card=136,autodetected]
saa7133[0]: board init: gpio is 220000
tuner' 5-0061: chip found @ 0xc2 (saa7133[0])
saa7133[0]: i2c eeprom 00: 61 14 36 f4 00 00 00 00 00 00 00 00 00 00 00
00
saa7133[0]: i2c eeprom 10: 00 ff e2 0e ff 20 ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 ff ff ff ff
ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
xc2028 5-0061: creating new instance
xc2028 5-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 5-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7
xc2028 5-0061: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
(0), id 00000000000000ff:
xc2028 5-0061: Loading firmware for type=(0), id 0000000100000007.
SCODE (20000000), id 0000000100000007:
xc2028 5-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000),
id 0000000800000007.
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0

Analog TV works with this setup, but I have no signs of DVB-T. No
/dev/dvb devices are created although the module for the Zarlink tuner
"mt352" is autoloaded when the card is inserted.

Apparently I'm missing something.

Any hints?

Best regards

Luke

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
