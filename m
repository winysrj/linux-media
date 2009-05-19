Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4JAV1f1024347
	for <video4linux-list@redhat.com>; Tue, 19 May 2009 06:31:01 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4JAToCV028349
	for <video4linux-list@redhat.com>; Tue, 19 May 2009 06:29:50 -0400
Received: by yw-out-2324.google.com with SMTP id 3so2727146ywj.81
	for <video4linux-list@redhat.com>; Tue, 19 May 2009 03:29:50 -0700 (PDT)
Message-ID: <4A128A19.40601@gmail.com>
Date: Tue, 19 May 2009 12:29:45 +0200
From: Antonio Beamud Montero <antonio.beamud@gmail.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Hauppauge HVR 1110 and DVB
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have a new hauppauge hvr 1110. Trying to load the lastest modules, all 
seems to load fine, but no dvb-t frontend is created. As I can see this 
card isn't exactly the same hvr 1110 (hvr 1110r3) supported by v4l-dvb.
The system reports the next info:

# lspci -v

0b:03.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 
Video Broadcast Decoder (rev d1)
Subsystem: Hauppauge computer works Inc. Unknown device 6707
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
Latency: 32 (21000ns min, 8000ns max)
Interrupt: pin A routed to IRQ 114
Region 0: Memory at fc4ff800 (32-bit, non-prefetchable) [size=2K]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=1 PME-

# dmesg

ACPI: PCI Interrupt 0000:0f:03.0[A] -> GSI 160 (level, low) -> IRQ 65
saa7133[0]: found at 0000:0f:03.0, rev: 209, irq: 65, latency: 32, mmio: 
0xfc4ff800
saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1110r3 
[card=156,autodetected]
saa7133[0]: board init: gpio is 40000
saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 00 ff ff ff
saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 08 79 5e f0 73 05 29 00
saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 19 8d 72 07 70 73 09
saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 72 0f 01 72
saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 1a 00 00 00 00 00
saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 0-0050: Hauppauge model 67209, rev C1F5, serial# 6191368
tveeprom 0-0050: MAC address is 00-0D-FE-5E-79-08
tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type 54)
tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) 
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 0-0050: audio processor is SAA7131 (idx 41)
tveeprom 0-0050: decoder processor is SAA7131 (idx 35)
tveeprom 0-0050: has radio, has IR receiver, has no IR transmitter
saa7133[0]: hauppauge eeprom: model=67209
tuner 0-004b: chip found @ 0x96 (saa7133[0])
tda829x 0-004b: setting tuner address to 60
tda18271 0-0060: creating new instance
TDA18271HD/C2 detected @ 0-0060
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete
tda829x 0-004b: type set to tda8290+18271
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfc4ff800 irq 65 registered as card -1

Trying to load manually the saa7134-dvb module reports nothing.

The module seems to recognize the 67209LF rev C1F5 ok.

Hauppauge hvr 1110 Hardware Info:

Decoder: saa7131E/03/G
Module: TDA10048HN 
(http://www.ecnasiamag.com/article-10192-philipstda10048hnenablesdigitaltvviewingthroughentertainmentdevices-Asia.html)

Greetings


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
