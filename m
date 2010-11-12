Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:57454 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751712Ab0KLHlU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 02:41:20 -0500
Message-ID: <4CDCEF9D.3000701@gmx.de>
Date: Fri, 12 Nov 2010 08:41:17 +0100
From: =?ISO-8859-15?Q?Daniel_P=E4=DFler?= <paessler@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: no DVB-T with AVerMedia M115S
References: <4CB85FB3.6020509@gmx.de>
In-Reply-To: <4CB85FB3.6020509@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Is really no one able to tell me, if there is any chance to get this
card working?
And if so, i have to buy a new card, so can someone at least recommend a
mini-PCI card which is known to to work (only DVB-T needed)?


Thanks,

Daniel

Am 15.10.2010 16:05, schrieb Daniel Päßler:
>  Hi,
> 
> i own a mini-PCI card builtin in a Sony Vaio VGN-AR71ZU Notebook.
> After searching the web it looks like this is a AVerMedia M115S (maybe
> the S stands for Sony?), which is somehow different to an ordinary M115.
> Is there any chance to get DVB-T working with this card? It seems, that
> the tuner is the problem, but i don't know how to find out the type of
> the tuner.
> 
> 
> lspci -vvvnn gives this:
> 
> 08:04.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>     Subsystem: Avermedia Technologies Inc Device [1461:e836]
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 64
>     Interrupt: pin A routed to IRQ 22
>     Region 0: Memory at fc006800 (32-bit, non-prefetchable) [size=2K]
>     Capabilities: [40] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>     Kernel driver in use: saa7134
>     Kernel modules: saa7134
> 
> 
> and dmesg with the actual checkout of v4l gives this:
> 
> saa7130/34: v4l2 driver version 0.2.16 loaded
> saa7133[0]: found at 0000:08:04.0, rev: 209, irq: 22, latency: 64, mmio:
> 0xfc006800
> saa7133[0]: subsystem: 1461:e836, board: UNKNOWN/GENERIC
> [card=0,autodetected]
> saa7133[0]: board init: gpio is effffff
> saa7133[0]/core: hwinit1
> saa7133[0]: i2c xfer: < a0 00 >
> saa7133[0]: i2c xfer: < a1 =61 =14 =36 =e8 =00 =00 =00 =00 =00 =00 =00
> =00 =00 =00 =00 =00 =ff =ff =ff =ff =ff =20 =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =01 =40 =01 =02 =02 =01 =01 =03 =08 =ff =00 =00 =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =65 =00 =ff =c2 =00 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =0d =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
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
> saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 03 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 05 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 07 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 09 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 0b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 0d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 0f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 11 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 13 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 15 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 17 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 19 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 1b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 1d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 1f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 21 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 23 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 25 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 27 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 29 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 2b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 2d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 2f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 31 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 33 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 35 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 37 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 39 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 3b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 3d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 3f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 41 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 43 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 45 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 47 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 49 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 4b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 4d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 4f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 51 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 53 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 55 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 57 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 59 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 5b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 5d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 5f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 61 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 63 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 65 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 67 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 69 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 6b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 6d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 6f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 71 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 73 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 75 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 77 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 79 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 7b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 7d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 7f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 81 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 83 >
> saa7133[0]: i2c scan: found device @ 0x82  [???]
> saa7133[0]: i2c xfer: < 85 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 87 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 89 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 8b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 8d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 91 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 93 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 97 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a1 >
> saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < a9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ab ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ad ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < af ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < b9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < bb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < bd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < bf ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < cb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < cd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < cf ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < d9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < db ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < dd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < df ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < e9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < eb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ed ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ef ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f1 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f3 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f7 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < f9 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < fb ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < fd ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
> saa7133[0]/ir: No I2C IR support for board 0
> saa7133[0]/core: hwinit2
> saa7133[0]/audio: sound IF not in use, skipping scan
> saa7133[0]: registered device video1 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: dsp access error
> saa7133[0] vbi (UNKNOWN/GENERIC: VIDIOC_QUERYCAP
> saa7133[0] video (UNKNOWN/GENER: VIDIOC_QUERYCAP
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfc006800 irq 22 registered as card -1
> 
> 
> 
> Thanks in advance,
> 
> Daniel

