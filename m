Return-path: <mchehab@pedra>
Received: from imr-da02.mx.aol.com ([205.188.105.144]:38967 "EHLO
	imr-da02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1CFOc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 09:32:58 -0500
Received: from mtaout-mb03.r1000.mx.aol.com (mtaout-mb03.r1000.mx.aol.com [172.29.41.67])
	by imr-da02.mx.aol.com (8.14.1/8.14.1) with ESMTP id p26EWqUe008361
	for <linux-media@vger.kernel.org>; Sun, 6 Mar 2011 09:32:52 -0500
Received: from [192.168.1.150] (unknown [190.191.125.22])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-mb03.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 2043EE0000E8
	for <linux-media@vger.kernel.org>; Sun,  6 Mar 2011 09:32:51 -0500 (EST)
Message-ID: <4D739AF6.3000203@netscape.net>
Date: Sun, 06 Mar 2011 11:32:22 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: analog sound on Mygica X8506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all

First of all, please if I'm on the wrong list tell me which is correct.

I bought a new TV-card "MyGica X8507" if I set it up as DMB-TH Mygica
X8506 "card 22" analog TV I can see but not hear.
Can you help me to configure this card so I can listen?
I hope that soon this support and can also see digital television.


Thanks in advance

____________________________________________________________________

http://www.linuxtv.org/wiki/index.php/Geniatech/MyGica_X8507_PCI-Express_Hybrid_Card
____________________________________________________________________
dmesg

[    8.769368] Linux video capture interface: v2.00
[    8.782879] cx23885 driver version 0.0.2 loaded
[    8.784037] cx23885 0000:02:00.0: PCI INT A -> GSI 19 (level, low) ->
IRQ 19
[    8.784041] cx23885[0]/0: cx23885_dev_setup() Memory configured for
PCIe bridge type 885
[    8.784043] cx23885[0]/0: cx23885_init_tsport(portno=1)
[    8.784223] CORE cx23885[0]: subsystem: 14f1:8502, board: Mygica
X8506 DMB-TH [card=22,insmod option]
[    8.784226] cx23885[0]/0: cx23885_pci_quirks()
[    8.784230] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x4c
tuner_addr = 0x61
[    8.784233] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0
radio_addr = 0x0
[    8.784235] cx23885[0]/0: cx23885_reset()
[    8.892926] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [VID A]
[    8.892930] cx23885[0]/0: cx23885_sram_channel_setup() Erasing
channel [ch2]
[    8.892932] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS1 B]
[    8.892935] cx23885[0]/0: cx23885_sram_channel_setup() Erasing
channel [ch4]
[    8.892937] cx23885[0]/0: cx23885_sram_channel_setup() Erasing
channel [ch5]
[    8.892939] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS2 C]
[    8.892953] cx23885[0]/0: cx23885_sram_channel_setup() Erasing
channel [ch7]
[    8.892955] cx23885[0]/0: cx23885_sram_channel_setup() Erasing
channel [ch8]
[    8.892957] cx23885[0]/0: cx23885_sram_channel_setup() Erasing
channel [ch9]
[    9.131075] cx23885[0]: scan bus 0:
[    9.133467] cx23885[0]: i2c scan: found device @ 0x20  [???]
[    9.138377] cx23885[0]: i2c scan: found device @ 0x66  [???]
[    9.144733] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
[    9.144876] cx23885[0]: i2c scan: found device @ 0xa2  [???]
[    9.146071] cx23885[0]: i2c scan: found device @ 0xa4  [???]
[    9.146214] cx23885[0]: i2c scan: found device @ 0xa6  [???]
[    9.146355] cx23885[0]: i2c scan: found device @ 0xa8  [???]
[    9.146496] cx23885[0]: i2c scan: found device @ 0xaa  [???]
[    9.146637] cx23885[0]: i2c scan: found device @ 0xac  [???]
[    9.146778] cx23885[0]: i2c scan: found device @ 0xae  [???]
[    9.152627] cx23885[0]: scan bus 1:
[    9.168325] cx23885[0]: i2c scan: found device @ 0xc2
[tuner/mt2131/tda8275/xc5000/xc3028]
[    9.173738] cx23885[0]: scan bus 2:
[    9.184143] cx23885[0]: i2c scan: found device @ 0x66  [???]
[    9.184795] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
[    9.185099] cx23885[0]: i2c scan: found device @ 0x98  [???]
[    9.292405] cx25840 5-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[    9.302242] cx25840 5-0044: firmware: requesting v4l-cx23885-avcore-01.fw
[   10.374232] cx25840 5-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[   10.380657] cx23885[0]/0: cx23885_video_register()
[   10.382438] tuner 4-0061: chip found @ 0xc2 (cx23885[0])
[   10.553069] xc5000 4-0061: creating new instance
[   10.553766] xc5000: Successfully identified at address 0x61
[   10.553768] xc5000: Firmware has not been loaded previously
[   10.553770] cx23885[0]/0: cx23885_vdev_init()
[   10.553828] cx23885[0]/0: registered device video1 [v4l2]
[   10.553831] cx23885[0]/0: cx23885_set_tvnorm(norm = 0x00001000) name:
[NTSC-M]
[   10.559271] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.6.114.fw)...
[   10.559274] cx23885 0000:02:00.0: firmware: requesting
dvb-fe-xc5000-1.6.114.fw
[   10.692589] xc5000: firmware read 12401 bytes.
[   10.692591] xc5000: firmware uploading...
[   12.066004] xc5000: firmware upload complete...
[   12.707015] cx23885[0]/0: cx23885_set_control() calling
cx25840(VIDIOC_S_CTRL) (disabled - no action)
[   12.707017] cx23885[0]/0: cx23885_set_control() calling
cx25840(VIDIOC_S_CTRL) (disabled - no action)
[   12.707019] cx23885[0]/0: cx23885_set_control() calling
cx25840(VIDIOC_S_CTRL) (disabled - no action)
[   12.707022] cx23885[0]/0: cx23885_set_control() calling
cx25840(VIDIOC_S_CTRL) (disabled - no action)
[   12.707024] cx23885[0]/0: cx23885_set_control() calling
cx25840(VIDIOC_S_CTRL) (disabled - no action)
[   12.707026] cx23885[0]/0: cx23885_set_control() calling
cx25840(VIDIOC_S_CTRL) (disabled - no action)
[   12.707029] cx23885[0]/0: cx23885_video_mux() video_mux: 0 [vmux=2,
gpio=0x0,0x0,0x0,0x0]
[   12.711091] cx23885_dvb_register() allocating 1 frontend(s)
[   12.711094] cx23885[0]: cx23885 based dvb card
[   12.750805] xc5000 4-0061: attaching existing instance
[   12.751535] xc5000: Successfully identified at address 0x61
[   12.751536] xc5000: Firmware has been loaded previously
[   12.751540] DVB: registering new adapter (cx23885[0])
[   12.751544] DVB: registering adapter 0 frontend 0 (Legend Silicon
LGS8913/LGS8GXX DMB-TH)...
[   12.751815] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   12.751824] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19,
latency: 0, mmio: 0xfd600000
[   12.751831] cx23885 0000:02:00.0: setting latency timer to 64
[   12.751836] IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   12.754419] cx23885[0]/0: open dev=video1 radio=0 type=vid-cap
[   12.754424] cx23885[0]/0: post videobuf_queue_init()
[   19.342718] cx23885[0]/0: open dev=video1 radio=0 type=vid-cap
[   19.342723] cx23885[0]/0: post videobuf_queue_init()


____________________________________________________________________

lspci -vvvnn

02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
        Subsystem: Conexant Systems, Inc. Device [14f1:8502]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at fd600000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data
                Product Name: "
                End
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [200 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed+ WRR32+ WRR64+ WRR128-
                Ctrl:   ArbSelect=WRR64
                Status: InProgress-
                Port Arbitration Table [240] <?>
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: cx23885


Thanks in advance

-- 
Dona tu voz
http://www.voxforge.org/es
