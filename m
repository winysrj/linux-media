Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:23086 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760044Ab2BJULV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 15:11:21 -0500
Received: from agathe (dslb-088-064-013-187.pools.arcor-ip.net [88.64.13.187])
	by smtp.strato.de (jimi mo53) (RZmta 27.6 DYNA|AUTH)
	with ESMTPA id 20274ao1AK7r3s for <linux-media@vger.kernel.org>;
	Fri, 10 Feb 2012 21:11:13 +0100 (MET)
Received: from localhost (agathe [127.0.0.1])
	by agathe (Postfix) with ESMTP id BDFF06065A
	for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 21:11:13 +0100 (CET)
Received: from agathe ([127.0.0.1])
	by localhost (agathe.au-79.intra [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I-bDzHf+umRz for <linux-media@vger.kernel.org>;
	Fri, 10 Feb 2012 21:11:09 +0100 (CET)
Received: from [192.168.22.124] (sixtus.au-79.intra [192.168.22.124])
	by agathe (Postfix) with ESMTP id ABDB461020
	for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 21:11:09 +0100 (CET)
Message-ID: <4F3579DD.2050008@au-79.de>
Date: Fri, 10 Feb 2012 21:11:09 +0100
From: Robert Goldner <robert@au-79.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problems with saa7134 card
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

a few days ago I got an PCI-DVB-T and Radio Capture card. Is a quite old 
(and cheap) Medion card with an ssa7134 chipset. Unfortunally the card 
is not supported by linux (kernel 3.2.5) out-of-the-box. After modprobe 
ssa7134 the following message comes by dmesg:

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0 2 17 loaded
saa7134 0000:00:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
saa7134[0]: found at 0000:00:06.0, rev: 1 irq: 17 latency: 32 mmio: 
0x4a105000
saa7134: Board is currently unknown. You might try to use the card=<nr>
saa7134: insmod option to specify which board do you have, but this is
saa7134: somewhat risky, as might damage your card. It is better to ask
saa7134: for support at linux-media@vger.kernel.org.
saa7134: The supported cards are:
saa7134: card=0 -> UNKNOWN/GENERIC
saa7134: card=1 -> Proteus Pro [philips reference design] 1131:2001
[...]
saa7134: card=12 -> Medion 7134 16be:0003 16be:5000
[...]
saa7134: card=187 -> Beholder BeholdTV 503 FM 5ace:5030
saa7134[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
[card=0,autodetected]
saa7134[0]: board init: gpio is 10020
saa7134[0]: Huh, no eeprom present (err=-5)?
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0


I also used google a litte bit and found some hints to use
modprobe ssa7134 card=12 tuner=63, but it does not look well:


saa7130/34: v4l2 driver version 0 2 17 loaded
saa7134[0]: found at 0000:00:06.0, rev: 1 irq: 17 latency: 32 mmio: 
0x4a105000
saa7134[0]: subsystem: 1131:0000, board: Medion 7134 [card=12,insmod 
option]
saa7134[0]: board init: gpio is 10020
saa7134[0]: Huh, no eeprom present (err=-5)?
EEPROM read failure
saa7134[0] Tuner type is 63
i2c-core: driver [tuner] using legacy suspend method
i2c-core: driver [tuner] using legacy resume method
tda9887 10-0043: creating new instance
tda9887 10-0043: tda988[5/6/7] found
tuner 10-0043: Tuner 74 found with type(s) Radio TV.
All bytes are equal. It is not a TEA5767
tuner 10-0060: Tuner -1 found with type(s) Radio TV.
tuner-simple 10-0060: creating new instance
tuner-simple 10-0060: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
dvb_init() allocating 1 frontend
tda10046: chip is not answering. Giving up.
saa7134[0]/dvb: frontend initialization failed


lspci:
Multimedia controller [0480]: Philips Semiconductors SAA7134/SAA7135HL 
Video Broadcast Decoder [1131:7134] (rev 01)
  lspci -d 1131:7134 -vvv
00:06.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL 
Video Broadcast Decoder (rev 01)
         Subsystem: Philips Semiconductors Behold TV 403 FM
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (3750ns min, 9500ns max)
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at 4a105000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [40] Power Management version 1
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: saa7134


Any hints?

Robert

P.S. please also cc to my address
