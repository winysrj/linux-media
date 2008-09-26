Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rhebok.le.ac.uk ([143.210.16.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jgm11@leicester.ac.uk>) id 1KjADu-0005ei-Vg
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 12:06:57 +0200
Received: from exp-cas2.le.ac.uk ([143.210.133.104]:2004
	helo=exp-cas2.cfs.le.ac.uk) by rhebok.le.ac.uk with esmtp (Exim 4.63)
	(envelope-from <jgm11@leicester.ac.uk>) id 1KjADr-0001Zc-89
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 11:06:51 +0100
From: "Mitchell, J.G." <jgm11@leicester.ac.uk>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Fri, 26 Sep 2008 11:02:11 +0100
Message-ID: <8477EDDA0355EC429DA077A1FB414E2E1C5FF01D24@EXC-MBX1.cfs.le.ac.uk>
References: <8477EDDA0355EC429DA077A1FB414E2E1C5FF01D23@EXC-MBX1.cfs.le.ac.uk>,
	<1222392226.4589.49.camel@pc10.localdom.local>
In-Reply-To: <1222392226.4589.49.camel@pc10.localdom.local>
Content-Language: en-GB
MIME-Version: 1.0
Subject: Re: [linux-dvb] Leadtek DTV1000s Development Help
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

I loaded the module and this is the result from my dmesg.log file. I have tried to strip out things that are irrelevant!

i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
Linux video capture interface: v2.00
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 32, mmio: 0xfdeff000
saa7130[0]: subsystem: 107d:6655, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7130[0]: board init: gpio is 22000
saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
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

So it finds it and attaches it to video0 from the looks of this log. I am assuming that the SAA is an analog tuner, or maybe a composite video input? How would I go about testing to see if this driver is interacting correctly with my card?

Regards,
Jack.
________________________________________
From: hermann pitton [hermann-pitton@arcor.de]
Sent: 26 September 2008 02:23
To: Mitchell, J.G.
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek DTV1000s Development Help

Am Freitag, den 26.09.2008, 02:02 +0100 schrieb Mitchell, J.G.:
> Hello Everyone,
>
> I bought this card some months back now and I did a bit of research to find out to my dissapointment that it is not supported under Linux. However, I am about to embark on an Embedded Systems Engineering degree and I thought that maybe, developing a device driver for this card would be a good start? Now I have found that this card incorporates the SAA7130, TDA10048 and TDA18271.
>
> I currently run ArchLinux and have some programming experience, I am reading a couple of books at the moment such as Programming Embedded Systems and C Programming (K&R) so I have a good base to work from and can refer to the books if i need some technical help.
>
> At the moment I am at a loss to where to start, would somebody be able to point me in the right direction to start working on this project?
>
> Regards,
> Jack.
>

Hi Jack,

you have some new combinations here.

To load the saa7134 with i2c_scan=1 could be a start.

"modinfo saa7134"

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
