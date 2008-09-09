Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx.neterion.com ([72.1.205.142] helo=owa.neterion.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrbois@magma.ca>) id 1Kd18C-0005h6-8J
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 13:11:38 +0200
Message-ID: <48C659C5.8000902@magma.ca>
Date: Tue, 09 Sep 2008 07:11:01 -0400
From: Patrick Boisvenue <patrbois@magma.ca>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
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

I cannot get my new HVR-1500Q to work at all even though it's recognized 
as such.  The best I was able to figure out was it does not like the 
eeprom.  After enabling the debug mode on tveeprom, I got the following 
when loading cx23885:

cx23885 driver version 0.0.1 loaded
cx23885 0000:05:00.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
CORE cx23885[0]: subsystem: 0070:7790, board: Hauppauge WinTV-HVR1500Q 
[card=5,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 1-0050: full 256-byte eeprom dump:
tveeprom 1-0050: 00: 20 00 13 00 00 00 00 00 2c 00 05 00 70 00 90 77
tveeprom 1-0050: 10: 50 03 05 00 04 80 00 08 0c 03 05 80 0e 01 00 00
tveeprom 1-0050: 20: 78 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 1-0050: c0: 84 09 00 04 20 77 00 40 ec 66 25 f0 73 05 27 00
tveeprom 1-0050: d0: 84 08 00 06 fb 2c 01 00 90 29 95 72 07 70 73 09
tveeprom 1-0050: e0: 21 7f 73 0a 88 96 72 0b 13 72 10 01 72 11 ff 79
tveeprom 1-0050: f0: dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: Encountered bad packet header [ff]. Corrupt or not a 
Hauppauge eeprom.
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=0
cx23885[0]: cx23885 based dvb card
xc5000: Successfully identified at address 0x61
xc5000: Firmware has not been loaded previously
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 19, latency: 0, mmio: 
0xd4000000
PCI: Setting latency timer of device 0000:05:00.0 to 64

Did a hg pull -u http://linuxtv.org/hg/v4l-dvb earlier today so running 
off recent codebase.

Any suggestions,
...Patrick


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
