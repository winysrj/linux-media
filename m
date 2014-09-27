Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41048 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaI0NjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Sep 2014 09:39:05 -0400
Received: by mail-pa0-f47.google.com with SMTP id rd3so4318472pab.6
        for <linux-media@vger.kernel.org>; Sat, 27 Sep 2014 06:39:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 27 Sep 2014 09:39:03 -0400
Message-ID: <CABOsP2PxAN8DdEpE9rqQoL+PaVQtbkJ8PQLen=ePSRqycN-=cQ@mail.gmail.com>
Subject: osprey 100e cards?
From: Michael Di Domenico <mdidomenico4@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently purchased an osprey 100e card to use on my rhel 6.5 linux
machine.  a card does show up in lspci.  however, i don't seem to get
a /dev/video driver.  when the cx23885 driver loads it tells me it
cannot recognize the card.  i tried putting card=82 and card=83 when i
load the driver, but doesn't seem to help.

Googling around didn't seem to pull anything specific to fix the
issue, any insights into what might be wrong.  As i understood it the
Osprey cards were well supported under linux, so i'm not sure what's
wrong

thanks

lspci

02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8
PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 04)

lspci -vvn -s 02:00.0

02:00.0 0400: 14f1:8880 (rev 04)
    Subsystem: 1576:0100
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 34
    Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <2us, L1 <4us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] Vital Product Data
        Product Name: "
        End
    Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 4168
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover+ Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [200 v1] Virtual Channel
        Caps:    LPEVC=1 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32+ WRR64+ WRR128-
        Ctrl:    ArbSelect=WRR64
        Status:    InProgress-
        Port Arbitration Table [240] <?>
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable- ID=1 ArbSelect=Fixed TC/VC=00
            Status:    NegoPending- InProgress-
    Kernel driver in use: cx23885
    Kernel modules: cx23885


modprobe cx23885 debug=10

dmesg output

cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 887
cx23885[0]: Your board isn't known (yet) to the driver.
cx23885[0]: Try to pick one of the existing card configs via
cx23885[0]: card=<n> insmod option.  Updating to the latest
cx23885[0]: version might help as well.
cx23885[0]: Here is a list of valid choices for the card=<n> insmod option:
cx23885[0]:    card=0 -> UNKNOWN/GENERIC
...snipped...
CORE cx23885[0]: subsystem: 1576:0100, board: UNKNOWN/GENERIC
[card=0,autodetected]
cx23885[0]/0: cx23885_pci_quirks()
cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0
cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0
cx23885[0]/0: cx23885_reset()
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]
cx23885[0]/0: cx23885_sram_channel_setup() 0x000107b0 <- 0x00000040
cx23885[0]/0: cx23885_sram_channel_setup() 0x000107c0 <- 0x00000b80
cx23885[0]/0: cx23885_sram_channel_setup() 0x000107d0 <- 0x000016c0
cx23885[0]/0: [bridge 887] sram setup VID A: bpl=2880 lines=3
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010870 <- 0x00005000
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010880 <- 0x000052f0
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010890 <- 0x000055e0
cx23885[0]/0: cx23885_sram_channel_setup() 0x000108a0 <- 0x000058d0
cx23885[0]/0: cx23885_sram_channel_setup() 0x000108b0 <- 0x00005bc0
cx23885[0]/0: [bridge 887] sram setup TS1 B: bpl=752 lines=5
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
cx23885[0]/0: cx23885_sram_channel_setup() 0x000108d0 <- 0x00006000
cx23885[0]/0: cx23885_sram_channel_setup() 0x000108e0 <- 0x000062f0
cx23885[0]/0: cx23885_sram_channel_setup() 0x000108f0 <- 0x000065e0
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010900 <- 0x000068d0
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010910 <- 0x00006bc0
cx23885[0]/0: [bridge 887] sram setup TS2 C: bpl=752 lines=5
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
cx23885_dev_checkrevision() Hardware revision = 0xd0
cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 17, latency: 0,
mmio: 0xf7800000
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 34 for MSI/MSI-X
