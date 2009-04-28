Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f105.google.com ([209.85.221.105])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <smspillaz@gmail.com>) id 1Lynfw-0007OI-U9
	for linux-dvb@linuxtv.org; Tue, 28 Apr 2009 15:48:45 +0200
Received: by qyk3 with SMTP id 3so1161695qyk.3
	for <linux-dvb@linuxtv.org>; Tue, 28 Apr 2009 06:48:09 -0700 (PDT)
MIME-Version: 1.0
From: Sam Spilsbury <smspillaz@gmail.com>
Date: Tue, 28 Apr 2009 21:47:49 +0800
Message-ID: <5e20e5fc0904280647o7862f0e6r5175d73a9c8ad340@mail.gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] ASUS 'My Cinema Europa Hybrid' (P7131 DVB-T) [SAA7134]
	Firmware oddities
Reply-To: linux-media@vger.kernel.org
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

Hi everyone,

So It's my first time to LinuxTV hacking, debugging etc, so I
apologize if I've failed to provide anything essential.

Anyways, I've just bought a ASUS 'My Cinema Europa Hybrid' (P7131
DVB-T) which has the Phillips saa7131 chipset in it (supported by the
saa7131 module et al). There is a problem getting the firmware in this
card to boot correctly - I may have the wrong card number and I cannot
use i2c because it detects it as UNKNOWN/GENERIC (i.e type 0) which
doesn't work.

According to /usr/share/doc/linux/video4linux etc my card number
should be either 78, 111 or 112. Specifying card=x seems to make the
module somewhat recognize the card, and even though I have the
firmware - it won't actually boot. This is shown by the fact that all
dvb operations essentially just time out and the fact that I cannot
scan channels in software like tvtime. I might be wrong though.

Here is relevant output which might assist in helping the problem:

==== dmesg log ====c

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
0xeb007000
saa7134[0]: subsystem: 1043:4847, board: ASUSTeK P7131 Dual
[card=78,insmod option]
saa7134[0]: board init: gpio is 200000
input: saa7134 IR (ASUSTeK P7131 Dual) as
/devices/pci0000:00/0000:00:09.0/input/input7
tuner' 3-0043: chip found @ 0x86 (saa7134[0])
tda9887 3-0043: creating new instance
tda9887 3-0043: tda988[5/6/7] found
saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
DVB: registering new adapter (saa7134[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: trying to boot from eeprom
tda1004x: found firmware revision 26 -- ok
saa7134[0]/dvb: could not access tda8290 I2C gate
tda827x_probe_version: could not read from tuner at addr: 0xc2

===== Relevant bits of lspci =====

00:09.0 Multimedia controller: Philips Semiconductors
SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
	Subsystem: ASUSTeK Computer Inc. Device 4847
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (21000ns min, 8000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at eb007000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Kernel driver in use: saa7134
	Kernel modules: saa7134


Any help would be greatly appreciated however I understand if this
isn't a fixable issue. If so it would be nice to know where I could
buy (online) TV Tuner cards with a composite input, are the old PCI
type and of course work well with Linux (Fedora 10 at least).

Thanks in advance,

Sam

-- 
Sam Spilsbury

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
