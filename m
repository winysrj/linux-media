Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36745 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbcFTPOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 11:14:47 -0400
Received: by mail-wm0-f51.google.com with SMTP id f126so73693102wma.1
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 08:14:46 -0700 (PDT)
MIME-Version: 1.0
From: Robert Logan <2p3rf3ct@gmail.com>
Date: Mon, 20 Jun 2016 16:06:42 +0100
Message-ID: <CAHsV9sRxgGW4S12=egP1V-1+4WEbnotphNA-MAytgfrKV3B-rw@mail.gmail.com>
Subject: bug: dvbv5-scan fails on HD transponder (dvb-s2)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Card/scan works fine picking up non-HD. Never getting any HD channels.
UK based. STB picks up all channels fine. Transponder details from
Astra-28.2E dvb-s, and matches BBC details.

On latest clone of master git repo, using only BBCHD transponder:
# Transponder 50
[CHANNEL]
        DELIVERY_SYSTEM = DVBS2
        FREQUENCY = 10847000
        POLARIZATION = VERTICAL
        SYMBOL_RATE = 23000000
        INNER_FEC = 2/3
        MODULATION = PSK/8
        INVERSION = AUTO

dvbv5-scan -f -p  -T2 -W100 -C gb BBCHD -lENHANCED -a0 -vvv:
Using LNBf ENHANCED
        Astra
        10700 to 11700 MHz
        Single LO, IF = 9750 MHz
using demux '/dev/dvb/adapter0/demux0'
Device Conexant CX24117/CX24132 (/dev/dvb/adapter0/frontend0) capabilities:
     CAN_2G_MODULATION
     CAN_FEC_1_2
     CAN_FEC_2_3
     CAN_FEC_3_4
     CAN_FEC_4_5
     CAN_FEC_5_6
     CAN_FEC_6_7
     CAN_FEC_7_8
     CAN_FEC_AUTO
     CAN_INVERSION_AUTO
     CAN_QPSK
     CAN_RECOVER
DVB API Version 5.10, Current v5 delivery system: DVBS2
Supported delivery systems:
     DVBS
    [DVBS2]
ERROR    command BANDWIDTH_HZ (5) not found during retrieve
Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable (yet).
Scanning frequency #1 10847000
frequency: 10847.00 MHz, high_band: 0
SEC: set voltage to 13V
DiSEqC TONE: OFF
L-Band frequency: 1097.00 MHz (offset = 9750.00 MHz)
FREQUENCY = 10847000
INVERSION = AUTO
SYMBOL_RATE = 23000000
INNER_FEC = 2/3
MODULATION = PSK/8
PILOT = 4294967295
ROLLOFF = AUTO
POLARIZATION = VERTICAL
STREAM_ID = 0
DELIVERY_SYSTEM = DVBS2
Status:
    CARRIER
    SIGNAL
BER: 0, Strength: 46024, SNR: 0, UCB: 0
DEBUG    Stats for STATUS = 3
DEBUG    Stats for STATUS = 3
DEBUG    Stats for STATUS = 3
DEBUG    Stats for POST BER = 0
Carrier(0x03) Signal= 70.23% C/N= 0.00% UCB= 0 postBER= 0
Status:
    CARRIER
    SIGNAL
BER: 0, Strength: 45924, SNR: 0, UCB: 0
DEBUG    Stats for STATUS = 3
DEBUG    Stats for STATUS = 3
DEBUG    Stats for POST BER = 0
Carrier(0x03) Signal= 70.08% C/N= 0.00% UCB= 0 postBER= 0
Status:
    CARRIER
    SIGNAL
BER: 0, Strength: 46024, SNR: 0, UCB: 0
DEBUG    Stats for STATUS = 3
DEBUG    Stats for STATUS = 3
DEBUG    Stats for POST BER = 0
Carrier(0x03) Signal= 70.23% C/N= 0.00% UCB= 0 postBER= 0
etc ends

lspci -vvv:
01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 04)
        Subsystem: Device 6981:8888
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f7200000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
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
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [200 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed+ WRR32+ WRR64+ WRR128-
                Ctrl:   ArbSelect=WRR64
                Status: InProgress-
                Port Arbitration Table [240] <?>
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: cx23885
        Kernel modules: cx23885
