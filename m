Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.21]:28959 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1KCMbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 08:31:46 -0400
Received: from yoda.localnet (unknown [188.224.9.103])
	by msfrf2312.sfr.fr (SMTP Server) with ESMTP id CFDEE70000B9
	for <linux-media@vger.kernel.org>; Thu,  3 Nov 2011 13:23:14 +0100 (CET)
From: Simon MORIN <simon.g.morin@gmail.com>
To: linux-media@vger.kernel.org
Subject: Configuration problem with WinTV Nova-T
Date: Thu, 03 Nov 2011 13:22:03 +0100
Message-ID: <4488004.DuMiS5xC9F@yoda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am dealing with a configuration problem with a Hauppauge WinTV Nova-T card 
(DVB-T). When upgrading from 3.0 to 3.1 Linux kernel, I didn't changed the 
configuration of the kernel and the card stopped working with the following 
error in dmesg.

After talking on IRC (#linuxtv), it appeared that some peoples with differents 
models of card also have this problem.
After a fews days testing and finally bisecting the linux sources (from 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git), the 
problem was introduced near or at commit 
fcc8e7d8c0e228cf032de0df049a91d5d2bfd0e9 with the introduction of DVB_NET 
option.
It looks like that with my card, I need this option to be activated. It is a 
little strange as afaik, my card have no kind of networking option, it is not 
in a set-top-box but in a standard PC and I have no use of an internet access 
on my card.

Is this option really needed ? 

Thanks for your answer.

Simon

----- dmesg output : 

FDC 0 is a post-1991 82077
Linux video capture interface: v2.00
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T 
[card=18,autodetected], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
IR RC5(x) protocol handler initialized
tveeprom 5-0050: Hauppauge model 90003, rev C2B0, serial# 3620053
tveeprom 5-0050: MAC address is 00:0d:fe:37:3c:d5
tveeprom 5-0050: tuner model is Thompson DTT75105 (idx 110, type 4)
tveeprom 5-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 5-0050: audio processor is None (idx 0)
tveeprom 5-0050: decoder processor is CX882 (idx 25)
tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=90003
IR RC6 protocol handler initialized
lirc_dev: IR Remote Control driver registered, major 254 
Registered IR keymap rc-hauppauge
input: cx88 IR (Hauppauge Nova-T DVB-T as 
/devices/pci0000:00/0000:00:06.0/0000:01:07.2/rc/rc0/input4
rc0: cx88 IR (Hauppauge Nova-T DVB-T as 
/devices/pci0000:00/0000:00:06.0/0000:01:07.2/rc/rc0
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 10
cx88-mpeg driver manager 0000:01:07.2: PCI INT A -> Link[LNK2] -> GSI 10 
(level, low) -> IRQ 10
cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 10, latency: 32, mmio: 
0xfb000000
cx8800 0000:01:07.0: PCI INT A -> Link[LNK2] -> GSI 10 (level, low) -> IRQ 10
cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 10, latency: 32, mmio: 
0xfc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
IR LIRC bridge handler initialized
cx88/2: cx2388x dvb driver version 0.0.9 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
DVB: registering new adapter (cx88[0])
DVB: registering adapter 0 frontend 0 (Conexant CX22702 DVB-T)...
cx88[0]: videobuf_dvb_register_frontend failed (errno = -12)
cx88[0]/2: dvb_register failed (err = -12)
cx88[0]/2: cx8802 probe failed, err = -12


--- lspci -vvv output :
01:07.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder (rev 05)
	Subsystem: Hauppauge computer works Inc. Device 9002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
		Unknown large resource type 04, will not decode more.
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx8800
	Kernel modules: cx8800

01:07.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
and Audio Decoder [MPEG Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Nova-T DVB-T Model 909
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx88-mpeg driver manager
	Kernel modules: cx8802

01:07.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
and Audio Decoder [IR Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Nova-T DVB-T Model 909
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

