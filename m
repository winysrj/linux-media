Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [212.57.247.218] (helo=mail.glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1KZmor-0006wM-Dp
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 15:18:17 +0200
From: "Michael J. Curtis" <michael.curtis@glcweb.co.uk>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Sun, 31 Aug 2008 14:17:42 +0100
Message-ID: <3C276393607085468A28782D978BA5EE71D2BA8176@w2k8svr1.glcdomain8.local>
Content-Language: en-US
MIME-Version: 1.0
Subject: [linux-dvb] Compro S350/S300 Tuner
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

Hi all

Has anyone discovered the tuner for the above?

Is there anyone that has got this card to work?

Seems like the card is correctly identified but the tuner is not?

ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
saa7134[0]: found at 0000:02:07.0, rev: 1, irq: 17, latency: 84, mmio: 0xfdffe000
saa7134[0]: subsystem: 185b:c900, board: Compro Videomate DVB-T300 [card=70,autodetected]
saa7134[0]: board init: gpio is 843f00
input: saa7134 IR (Compro Videomate DV as /class/input/input6
saa7134[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
saa7134[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: 00 00 00 00 4f e7 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 2-0068: chip found @ 0xd0 (saa7134[0])
tuner' 2-0068: tuner type not set
tuner' 2-0068: tuner type not set
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0

Any help will be appreciated

Regards


Michael Curtis

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
