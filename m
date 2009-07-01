Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:33260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZGALDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2009 07:03:08 -0400
Received: by fg-out-1718.google.com with SMTP id e12so865065fga.17
        for <linux-media@vger.kernel.org>; Wed, 01 Jul 2009 04:03:10 -0700 (PDT)
Date: Wed, 01 Jul 2009 13:03:23 +0200
To: linux-media@vger.kernel.org
Subject: Compro T750 - analog doesn't work ?
From: Samuel Rakitnican <semirocket@gmail.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=windows-1250
MIME-Version: 1.0
References: <S1752758AbZGAKNU/20090701101320Z+701@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.uwdybxcu80yj81@localhost>
In-Reply-To: <S1752758AbZGAKNU/20090701101320Z+701@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have Slackware 12.2 with it's stock kernel (2.6.27.7-smp). I haven't  
done any modifications to system. Installed version of tvtime is 1.0.2.

It asked for xc3028-v27.fw firmware file I've got it from a following link:
http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028

In tvtime Composite input is working. When I switch to Television it's  
showing blue screen with 'No signal' sign.

After I restart from Windows, last viewed channel from a Windows app  
appears in tvtime, but if I try to change or scan channels nothing happens  
(it's showing the same channel every time). If I cold start the computer  
tvtime it's showing previously mentioned 'No signal' screen.

Today (01.07.2009) I have installed latest v4l drivers using Mercurial hg,  
but the results are the same.

If it help's below is a link on a forum thread on some other guy
trying to get it work in Ubuntu with some more logs:
http://ubuntuforums.org/archive/index.php/t-1092160.html


Logs:
------------------------------------------------


::lspci -vvnnn::

00:0b.0 Multimedia controller [0480]: Philips Semiconductors  
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
         Subsystem: Compro Technology, Inc. VideoMate T750 [185b:c900]
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (21000ns min, 8000ns max)
         Interrupt: pin A routed to IRQ 19
         Region 0: Memory at dfffb800 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA  
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Kernel driver in use: saa7134
         Kernel modules: saa7134


::Kernel log in system start (pulled out only relevant to v4l)::

saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
saa7133[0]: found at 0000:00:0b.0, rev: 209, irq: 19, latency: 32, mmio:  
0xdfffb800
saa7133[0]: subsystem: 185b:c900, board: Compro VideoMate T750  
[card=139,autodetected]
saa7133[0]: board init: gpio is 84bf00
saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2 ff 01 c6 ff 05 ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-0062: chip found @ 0xc4 (saa7133[0])
xc2028 1-0062: creating new instance
xc2028 1-0062: type set to XCeive xc2028/xc3028 tuner
firmware: requesting xc3028-v27.fw
xc2028 1-0062: Loading 80 firmware images from xc3028-v27.fw, type: xc2028  
firmware, ver 2.7
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Error on line 1130: -5
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xdfffb800 irq 19 registered as card -1
xc2028 1-0062: Loading firmware for type=BASE FM (401), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Loading firmware for type=BASE FM (401), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Error on line 1130: -5
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000
.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000
.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Error on line 1130: -5
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000.
xc2028 1-0062: i2c output error: rc = -5 (should be 64)
xc2028 1-0062: -5 returned from send
xc2028 1-0062: Error -22 while loading base firmware
xc2028 1-0062: Error on line 1130: -5
