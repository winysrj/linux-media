Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f18.google.com ([209.85.220.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <blackwhiteeagle@googlemail.com>) id 1LChSk-0003ni-PH
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 22:28:20 +0100
Received: by fxm11 with SMTP id 11so883519fxm.17
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 13:27:45 -0800 (PST)
Message-ID: <49481D64.3030606@googlemail.com>
Date: Tue, 16 Dec 2008 22:28:04 +0100
From: BlackWhiteEagle <blackwhiteeagle@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] SAA7130HL Tuner: SU1278/SHA - STV0299B doesn't work
 anymore with the saa7134 (_dvb) module
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

Hello,
i've bought some months ago a Sattelite-Card called FlyDVB-S with an
empty EEPROM!
Chip: SAA7130HL
Tuner: SU1278/SHA
In the tuner is a STV0299B (atmel 306 24c02n SI27 and tda8060ts)

The eeprom is empty (all bytes with FF) so i had to force to load the
driver with:
modprobe saa7134 card=128

It worked fine after a kernel update to 2.6.27.9
The snapshot version from linuxtv.org made the same problem.
modprobe saa7134 card=97 doesn't work. The frontend can't be initialized?!

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7130[0]: found at 0000:00:0b.0, rev: 1, irq: 18, latency: 32, mmio:
0xdfffdc00
saa7130[0]: subsystem: 0000:0000, board: LifeView FlyDVB-S /Acorp
TV134DS [card=97,insmod option]
saa7130[0]: board init: gpio is 0
input: saa7134 IR (LifeView FlyDVB-S / as /class/input/input7
tuner' 4-0068: chip found @ 0xd0 (saa7130[0])
saa7130[0]: i2c eeprom 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
dvb_init() allocating 1 frontend
saa7130[0]/dvb: frontend initialization failed

Flashing the eeprom with these two blocks and a reboot doesn't work
006851000354201C004343A91C55D2B29220FF860FFF20FFFFFFFFFFFFFFFFFFFF0140010303FF010308FF0128FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1D00C0FF1C01F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

00424E000354201C004343A91C55D2B29220FF860FFF20FFFFFFFFFFFFFFFFFFFF0140010303FF010308FF01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1D00C0FF1C01F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

Any ideas?
Thanks!
Maze'

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
