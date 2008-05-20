Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailfe11.tele2.at ([212.247.155.71] helo=swip.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gosi@aon.at>) id 1JyYKb-0007Nm-A4
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 22:21:10 +0200
Received: from monchichi.dyndns.org (account cxu-944-dwd@tele2.at
	[91.129.33.165] verified)
	by mailfe11.swip.net (CommuniGate Pro SMTP 5.1.13)
	with ESMTPA id 773174691 for linux-dvb@linuxtv.org;
	Tue, 20 May 2008 22:20:35 +0200
From: Georg Wolfram <gosi@aon.at>
To: linux-dvb@linuxtv.org
Date: Tue, 20 May 2008 22:20:34 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805202220.34991.gosi@aon.at>
Subject: [linux-dvb] Avermedia AverTv Hybrid A16AR + FM PCI / radio does not
	work
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

Hi all,

I'm trying to get the radio part of my tv-card working, but without luck so 
far.

I have tried several programs (radio, kradio, fmtools), but none of them can 
find a radio station when scanning and stay mute when tuned to a station 
manually. My hardware setup seems to be ok, because radio is working in this 
other OS.

I have found messages (also on this list) from other users of this card having 
the same problem, but no solution. So what is the current state of affair in 
this case? How should i continue?

Dvb-t on the other hand works flawlessly. 

Thanks and greetings,

Georg

dmesg output:
--- cut ---
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 20 (level, low) -> IRQ 22
saa7134[0]: found at 0000:03:00.0, rev: 1, irq: 22, latency: 32, mmio: 
0xf2004000
saa7134[0]: subsystem: 1461:2c00, board: AVerMedia TV Hybrid A16AR 
[card=99,autodetected]
saa7134[0]: board init: gpio is 2a600
input: saa7134 IR (AVerMedia TV Hybrid as /class/input/input5
saa7134[0]: i2c eeprom 00: 61 14 00 2c 00 00 00 00 00 00 00 00 00 00 00 00
saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 02 02 03 03 01 08 ff 00 a3 ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 32 00 c0 86 1e ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-0043: chip found @ 0x86 (saa7134[0])
tda9887 1-0043: tda988[5/6/7] found @ 0x43 (tuner)
tuner 1-0060: TEA5767 detected.
tuner 1-0060: chip found @ 0xc0 (saa7134[0])
tuner 1-0060: type set to 62 (Philips TEA5767HN FM Radio)
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
DVB: registering new adapter (saa7134[0]).
DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
--- cut ---


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
