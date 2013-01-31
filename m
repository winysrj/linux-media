Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63428 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3AaQ2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 11:28:21 -0500
Received: by mail-wi0-f172.google.com with SMTP id o1so5017893wic.17
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 08:28:20 -0800 (PST)
Message-ID: <510A9A1E.9090801@googlemail.com>
Date: Thu, 31 Jan 2013 16:21:50 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

On linuxtv.org, the Hauppauge WinTV-HVR-1400 is listed as being 
supported. I've bought one, but I find that when I run the scan for 
dvb-t channels, none are found. I have tried kernels 2.6.11, 2.7.5 and 
3.8.0-rc5+ (pulled from Linus' tree today)

I know the aerial and cable are OK because, using the same cable, 
scanning with an internal PCI dvb-t card in a desktop computer finds 117 
TV and radio channels. I know the HVR-1400 expresscard is OK because, 
again using the same cable, on Windows 7 the Hauppauge TV viewing 
application also finds all those channels.

lspci -vvv gives the following information about the card:

[chris:~]$ sudo lspci -vvv
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI 
Video and Audio Decoder (rev 02)
         Subsystem: Hauppauge computer works Inc. Hauppauge WinTV 
HVR-1400 ExpressCard
         Physical Slot: 3
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin A routed to IRQ 0
         Region 0: Memory at f0e00000 (64-bit, non-prefetchable) 
[disabled] [size=2M]
         Capabilities: [40] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
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
                 No end tag found
         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 AERCap: First Error Pointer: 00, GenCap- CGenEn- 
ChkCap- ChkEn-
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

The following output from dmesg seems to show that the drivers and 
firmware are loading OK:

[   67.770876] cx23885 driver version 0.0.3 loaded
[   67.770907] cx23885[0]: cx23885_dev_setup() Memory configured for 
PCIe bridge type 885
[   67.770908] cx23885[0]: cx23885_init_tsport(portno=2)
[   67.770913] btcx: riscmem alloc [1] dma=322f3000 cpu=f22f3000 size=64
[   67.771006] CORE cx23885[0]: subsystem: 0070:8010, board: Hauppauge 
WinTV-HVR1400 [card=9,autodetected]
[   67.771007] cx23885[0]: cx23885_pci_quirks()
[   67.771011] cx23885[0]: cx23885_dev_setup() tuner_type = 0x0 
tuner_addr = 0x0 tuner_bus = 0
[   67.771012] cx23885[0]: cx23885_dev_setup() radio_type = 0x0 
radio_addr = 0x0
[   67.771012] cx23885[0]: cx23885_reset()
[   67.870121] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [VID A]
[   67.870129] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch2]
[   67.870130] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TS1 B]
[   67.870145] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch4]
[   67.870147] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch5]
[   67.870148] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TS2 C]
[   67.870164] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TV Audio]
[   67.870181] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch8]
[   67.870182] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch9]
[   67.938291] tveeprom 7-0050: full 256-byte eeprom dump:
[   67.938293] tveeprom 7-0050: 00: 20 00 13 00 00 00 00 00 2c 00 05 00 
70 00 10 80
[   67.938300] tveeprom 7-0050: 10: 50 03 05 00 04 80 00 08 0c 03 05 80 
0e 01 00 00
[   67.938306] tveeprom 7-0050: 20: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[   67.938311] tveeprom 7-0050: 30: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[   67.938317] tveeprom 7-0050: 40: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[   67.938323] tveeprom 7-0050: 50: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[   67.938329] tveeprom 7-0050: 60: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[   67.938334] tveeprom 7-0050: 70: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[   67.938340] tveeprom 7-0050: 80: 84 09 00 04 20 77 00 40 2a 5b 39 f0 
73 05 27 00
[   67.938346] tveeprom 7-0050: 90: 84 08 00 06 93 38 01 00 91 29 89 72 
07 70 73 09
[   67.938352] tveeprom 7-0050: a0: 21 7f 73 0a f4 97 72 0b 13 72 0e 01 
72 10 01 72
[   67.938358] tveeprom 7-0050: b0: 11 ff 79 0e 00 00 00 00 00 00 00 00 
00 00 00 00
[   67.938363] tveeprom 7-0050: c0: 84 09 00 04 20 77 00 40 2a 5b 39 f0 
73 05 27 00
[   67.938369] tveeprom 7-0050: d0: 84 08 00 06 93 38 01 00 91 29 89 72 
07 70 73 09
[   67.938375] tveeprom 7-0050: e0: 21 7f 73 0a f4 97 72 0b 13 72 0e 01 
72 10 01 72
[   67.938381] tveeprom 7-0050: f0: 11 ff 79 0e 00 00 00 00 00 00 00 00 
00 00 00 00
[   67.938387] tveeprom 7-0050: Tag [04] + 8 bytes: 20 77 00 40 2a 5b 39 f0
[   67.938391] tveeprom 7-0050: Tag [05] + 2 bytes: 27 00
[   67.938393] tveeprom 7-0050: Tag [06] + 7 bytes: 93 38 01 00 91 29 89
[   67.938396] tveeprom 7-0050: Tag [07] + 1 bytes: 70
[   67.938397] tveeprom 7-0050: Tag [09] + 2 bytes: 21 7f
[   67.938399] tveeprom 7-0050: Tag [0a] + 2 bytes: f4 97
[   67.938400] tveeprom 7-0050: Tag [0b] + 1 bytes: 13
[   67.938402] tveeprom 7-0050: Tag [0e] + 1 bytes: 01
[   67.938403] tveeprom 7-0050: Tag [10] + 1 bytes: 01
[   67.938405] tveeprom 7-0050: Not sure what to do with tag [10]
[   67.938405] tveeprom 7-0050: Tag [11] + 1 bytes: ff
[   67.938407] tveeprom 7-0050: Not sure what to do with tag [11]
[   67.938408] tveeprom 7-0050: Hauppauge model 80019, rev B2F1, serial# 
3758890
[   67.938410] tveeprom 7-0050: MAC address is 00:0d:fe:39:5b:2a
[   67.938411] tveeprom 7-0050: tuner model is Xceive XC3028L (idx 151, 
type 4)
[   67.938412] tveeprom 7-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   67.938414] tveeprom 7-0050: audio processor is CX23885 (idx 39)
[   67.938415] tveeprom 7-0050: decoder processor is CX23885 (idx 33)
[   67.938415] tveeprom 7-0050: has radio
[   67.938416] cx23885[0]: hauppauge eeprom: model=80019
[   67.938418] cx23885_dvb_register() allocating 1 frontend(s)
[   67.938420] cx23885[0]: cx23885 based dvb card
[   67.960655] DiB7000P: checking demod on I2C address: 18 (12)
[   67.979535] DiB7000P: gpio dir: ffff: val: 0, pwm_pos: ffff
[   67.982454] DiB7000P: setting output mode for demod f15f5000 to 0
[   68.000459] DiB7000P: using default timf
[   68.066369] xc2028: Xcv2028/3028 init called!
[   68.066372] xc2028 8-0064: creating new instance
[   68.066374] xc2028 8-0064: type set to XCeive xc2028/xc3028 tuner
[   68.066375] xc2028 8-0064: xc2028_set_config called
[   68.066379] DVB: registering new adapter (cx23885[0])
[   68.066383] cx23885 0000:02:00.0: DVB: registering adapter 0 frontend 
0 (DiBcom 7000PC)...
[   68.066567] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   68.066573] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, 
latency: 0, mmio: 0xf0400000
[   68.132928] xc2028 8-0064: request_firmware_nowait(): OK
[   68.132931] xc2028 8-0064: load_all_firmwares called
[   68.132932] xc2028 8-0064: Loading 81 firmware images from 
xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[   68.132937] xc2028 8-0064: Reading firmware type BASE F8MHZ (3), id 
0, size=9144.
[   68.132944] xc2028 8-0064: Reading firmware type BASE F8MHZ MTS (7), 
id 0, size=9030.
[   68.132950] xc2028 8-0064: Reading firmware type BASE FM (401), id 0, 
size=9054.
[   68.132955] xc2028 8-0064: Reading firmware type BASE FM INPUT1 
(c01), id 0, size=9068.
[   68.132960] xc2028 8-0064: Reading firmware type BASE (1), id 0, 
size=9132.
[   68.132965] xc2028 8-0064: Reading firmware type BASE MTS (5), id 0, 
size=9006.
[   68.132968] xc2028 8-0064: Reading firmware type (0), id 7, size=161.
[   68.132970] xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
[   68.132972] xc2028 8-0064: Reading firmware type (0), id 7, size=161.
[   68.132973] xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
[   68.132974] xc2028 8-0064: Reading firmware type (0), id 7, size=161.
[   68.132976] xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
[   68.132977] xc2028 8-0064: Reading firmware type (0), id 7, size=161.
[   68.132979] xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
[   68.132980] xc2028 8-0064: Reading firmware type (0), id e0, size=161.
[   68.132982] xc2028 8-0064: Reading firmware type MTS (4), id e0, 
size=169.
[   68.132983] xc2028 8-0064: Reading firmware type (0), id e0, size=161.
[   68.132985] xc2028 8-0064: Reading firmware type MTS (4), id e0, 
size=169.
[   68.132986] xc2028 8-0064: Reading firmware type (0), id 200000, 
size=161.
[   68.132988] xc2028 8-0064: Reading firmware type MTS (4), id 200000, 
size=169.
[   68.132989] xc2028 8-0064: Reading firmware type (0), id 4000000, 
size=161.
[   68.132991] xc2028 8-0064: Reading firmware type MTS (4), id 4000000, 
size=169.
[   68.132992] xc2028 8-0064: Reading firmware type D2633 DTV6 ATSC 
(10030), id 0, size=149.
[   68.132995] xc2028 8-0064: Reading firmware type D2620 DTV6 QAM (68), 
id 0, size=149.
[   68.132997] xc2028 8-0064: Reading firmware type D2633 DTV6 QAM (70), 
id 0, size=149.
[   68.132999] xc2028 8-0064: Reading firmware type D2620 DTV7 (88), id 
0, size=149.
[   68.133001] xc2028 8-0064: Reading firmware type D2633 DTV7 (90), id 
0, size=149.
[   68.133003] xc2028 8-0064: Reading firmware type D2620 DTV78 (108), 
id 0, size=149.
[   68.133005] xc2028 8-0064: Reading firmware type D2633 DTV78 (110), 
id 0, size=149.
[   68.133007] xc2028 8-0064: Reading firmware type D2620 DTV8 (208), id 
0, size=149.
[   68.133009] xc2028 8-0064: Reading firmware type D2633 DTV8 (210), id 
0, size=149.
[   68.133011] xc2028 8-0064: Reading firmware type FM (400), id 0, 
size=135.
[   68.133013] xc2028 8-0064: Reading firmware type (0), id 10, size=161.
[   68.133015] xc2028 8-0064: Reading firmware type MTS (4), id 10, 
size=169.
[   68.133016] xc2028 8-0064: Reading firmware type (0), id 400000, 
size=161.
[   68.133018] xc2028 8-0064: Reading firmware type (0), id 800000, 
size=161.
[   68.133019] xc2028 8-0064: Reading firmware type (0), id 8000, size=161.
[   68.133020] xc2028 8-0064: Reading firmware type LCD (1000), id 8000, 
size=161.
[   68.133022] xc2028 8-0064: Reading firmware type LCD NOGD (3000), id 
8000, size=161.
[   68.133024] xc2028 8-0064: Reading firmware type MTS (4), id 8000, 
size=169.
[   68.133026] xc2028 8-0064: Reading firmware type (0), id b700, size=161.
[   68.133027] xc2028 8-0064: Reading firmware type LCD (1000), id b700, 
size=161.
[   68.133029] xc2028 8-0064: Reading firmware type LCD NOGD (3000), id 
b700, size=161.
[   68.133031] xc2028 8-0064: Reading firmware type (0), id 2000, size=161.
[   68.133032] xc2028 8-0064: Reading firmware type MTS (4), id b700, 
size=169.
[   68.133033] xc2028 8-0064: Reading firmware type MTS LCD (1004), id 
b700, size=169.
[   68.133035] xc2028 8-0064: Reading firmware type MTS LCD NOGD (3004), 
id b700, size=169.
[   68.133037] xc2028 8-0064: Reading firmware type SCODE HAS_IF_3280 
(60000000), id 0, size=192.
[   68.133040] xc2028 8-0064: Reading firmware type SCODE HAS_IF_3300 
(60000000), id 0, size=192.
[   68.133042] xc2028 8-0064: Reading firmware type SCODE HAS_IF_3440 
(60000000), id 0, size=192.
[   68.133044] xc2028 8-0064: Reading firmware type SCODE HAS_IF_3460 
(60000000), id 0, size=192.
[   68.133046] xc2028 8-0064: Reading firmware type DTV6 ATSC OREN36 
SCODE HAS_IF_3800 (60210020), id 0, size=192.
[   68.133049] xc2028 8-0064: Reading firmware type SCODE HAS_IF_4000 
(60000000), id 0, size=192.
[   68.133051] xc2028 8-0064: Reading firmware type DTV6 ATSC TOYOTA388 
SCODE HAS_IF_4080 (60410020), id 0, size=192.
[   68.133053] xc2028 8-0064: Reading firmware type SCODE HAS_IF_4200 
(60000000), id 0, size=192.
[   68.133055] xc2028 8-0064: Reading firmware type MONO SCODE 
HAS_IF_4320 (60008000), id 8000, size=192.
[   68.133058] xc2028 8-0064: Reading firmware type SCODE HAS_IF_4450 
(60000000), id 0, size=192.
[   68.133060] xc2028 8-0064: Reading firmware type MTS LCD NOGD MONO IF 
SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[   68.133063] xc2028 8-0064: Reading firmware type DTV78 DTV8 
ZARLINK456 SCODE HAS_IF_4560 (62000300), id 0, size=192.
[   68.133066] xc2028 8-0064: Reading firmware type LCD NOGD IF SCODE 
HAS_IF_4600 (60023000), id 8000, size=192.
[   68.133069] xc2028 8-0064: Reading firmware type DTV6 QAM DTV7 
ZARLINK456 SCODE HAS_IF_4760 (620000e0), id 0, size=192.
[   68.133072] xc2028 8-0064: Reading firmware type SCODE HAS_IF_4940 
(60000000), id 0, size=192.
[   68.133074] xc2028 8-0064: Reading firmware type DTV78 DTV8 DIBCOM52 
SCODE HAS_IF_5200 (61000300), id 0, size=192.
[   68.133076] xc2028 8-0064: Reading firmware type SCODE HAS_IF_5260 
(60000000), id 0, size=192.
[   68.133078] xc2028 8-0064: Reading firmware type MONO SCODE 
HAS_IF_5320 (60008000), id 7, size=192.
[   68.133081] xc2028 8-0064: Reading firmware type DTV7 DTV8 DIBCOM52 
CHINA SCODE HAS_IF_5400 (65000280), id 0, size=192.
[   68.133084] xc2028 8-0064: Reading firmware type DTV6 ATSC OREN538 
SCODE HAS_IF_5580 (60110020), id 0, size=192.
[   68.133087] xc2028 8-0064: Reading firmware type SCODE HAS_IF_5640 
(60000000), id 7, size=192.
[   68.133089] xc2028 8-0064: Reading firmware type SCODE HAS_IF_5740 
(60000000), id 7, size=192.
[   68.133091] xc2028 8-0064: Reading firmware type SCODE HAS_IF_5900 
(60000000), id 0, size=192.
[   68.133092] xc2028 8-0064: Reading firmware type MONO SCODE 
HAS_IF_6000 (60008000), id 4c000f0, size=192.
[   68.133095] xc2028 8-0064: Reading firmware type DTV6 QAM ATSC LG60 
F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
[   68.133098] xc2028 8-0064: Reading firmware type SCODE HAS_IF_6240 
(60000000), id 10, size=192.
[   68.133100] xc2028 8-0064: Reading firmware type MONO SCODE 
HAS_IF_6320 (60008000), id 200000, size=192.
[   68.133102] xc2028 8-0064: Reading firmware type SCODE HAS_IF_6340 
(60000000), id 200000, size=192.
[   68.133104] xc2028 8-0064: Reading firmware type MONO SCODE 
HAS_IF_6500 (60008000), id 40000e0, size=192.
[   68.133107] xc2028 8-0064: Reading firmware type DTV6 ATSC ATI638 
SCODE HAS_IF_6580 (60090020), id 0, size=192.
[   68.133110] xc2028 8-0064: Reading firmware type SCODE HAS_IF_6600 
(60000000), id e0, size=192.
[   68.133112] xc2028 8-0064: Reading firmware type MONO SCODE 
HAS_IF_6680 (60008000), id e0, size=192.
[   68.133114] xc2028 8-0064: Reading firmware type DTV6 ATSC TOYOTA794 
SCODE HAS_IF_8140 (60810020), id 0, size=192.
[   68.133117] xc2028 8-0064: Reading firmware type SCODE HAS_IF_8200 
(60000000), id 0, size=192.
[   68.133119] xc2028 8-0064: Firmware files loaded.

Let me know if I can provide any additional diagnostics, but please cc 
me as I'm not subscribed.

Thanks.
