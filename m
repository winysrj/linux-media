Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:37389 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbZETAFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 20:05:20 -0400
Subject: Re: Hauppauge HVR 1110 and DVB
From: hermann pitton <hermann-pitton@arcor.de>
To: Antonio Beamud Montero <antonio.beamud@gmail.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4A128A19.40601@gmail.com>
References: <4A128A19.40601@gmail.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 01:48:49 +0200
Message-Id: <1242776929.7553.9.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio,

Am Dienstag, den 19.05.2009, 12:29 +0200 schrieb Antonio Beamud Montero:
> I have a new hauppauge hvr 1110. Trying to load the lastest modules, all 
> seems to load fine, but no dvb-t frontend is created. As I can see this 
> card isn't exactly the same hvr 1110 (hvr 1110r3) supported by v4l-dvb.
> The system reports the next info:

we moved to linux-media@vger.kernel.org

Michael Krufky has added support for these new tuners and cards and
Steven Toth for the tda10048.

But it is correct, DVB is not yet enabled on them.

Maybe Michael can give you some hints on what he is still working to do
so and if he might call for testers once.

Cheers,
Hermann


> # lspci -v
> 
> 0b:03.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 
> Video Broadcast Decoder (rev d1)
> Subsystem: Hauppauge computer works Inc. Unknown device 6707
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
> Stepping- SERR+ FastB2B-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
> Latency: 32 (21000ns min, 8000ns max)
> Interrupt: pin A routed to IRQ 114
> Region 0: Memory at fc4ff800 (32-bit, non-prefetchable) [size=2K]
> Capabilities: [40] Power Management version 2
> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 
> # dmesg
> 
> ACPI: PCI Interrupt 0000:0f:03.0[A] -> GSI 160 (level, low) -> IRQ 65
> saa7133[0]: found at 0000:0f:03.0, rev: 209, irq: 65, latency: 32, mmio: 
> 0xfc4ff800
> saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1110r3 
> [card=156,autodetected]
> saa7133[0]: board init: gpio is 40000
> saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 00 ff ff ff
> saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 08 79 5e f0 73 05 29 00
> saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 19 8d 72 07 70 73 09
> saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 72 0f 01 72
> saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 1a 00 00 00 00 00
> saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> tveeprom 0-0050: Hauppauge model 67209, rev C1F5, serial# 6191368
> tveeprom 0-0050: MAC address is 00-0D-FE-5E-79-08
> tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type 54)
> tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) 
> ATSC/DVB Digital (eeprom 0xf4)
> tveeprom 0-0050: audio processor is SAA7131 (idx 41)
> tveeprom 0-0050: decoder processor is SAA7131 (idx 35)
> tveeprom 0-0050: has radio, has IR receiver, has no IR transmitter
> saa7133[0]: hauppauge eeprom: model=67209
> tuner 0-004b: chip found @ 0x96 (saa7133[0])
> tda829x 0-004b: setting tuner address to 60
> tda18271 0-0060: creating new instance
> TDA18271HD/C2 detected @ 0-0060
> tda18271: performing RF tracking filter calibration
> tda18271: RF tracking filter calibration complete
> tda829x 0-004b: type set to tda8290+18271
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfc4ff800 irq 65 registered as card -1
> 
> Trying to load manually the saa7134-dvb module reports nothing.
> 
> The module seems to recognize the 67209LF rev C1F5 ok.
> 
> Hauppauge hvr 1110 Hardware Info:
> 
> Decoder: saa7131E/03/G
> Module: TDA10048HN 
> (http://www.ecnasiamag.com/article-10192-philipstda10048hnenablesdigitaltvviewingthroughentertainmentdevices-Asia.html)
> 
> Greetings
> 


