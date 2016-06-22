Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw.informatik.uni-stuttgart.de ([129.69.211.42]:51348 "EHLO
	mx3.informatik.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbcFVMNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 08:13:09 -0400
Received: from ipvsmail.informatik.uni-stuttgart.de (hermes.informatik.uni-stuttgart.de [129.69.216.250])
	by mx3.informatik.uni-stuttgart.de (Postfix) with ESMTP id 63E90C0171
	for <linux-media@vger.kernel.org>; Wed, 22 Jun 2016 13:36:23 +0200 (CEST)
Received: from [192.168.178.56] (HSI-KBW-109-192-114-015.hsi6.kabel-badenwuerttemberg.de [109.192.114.15])
	by ipvsmail.informatik.uni-stuttgart.de (Postfix) with ESMTPSA id 58603E96
	for <linux-media@vger.kernel.org>; Wed, 22 Jun 2016 13:36:23 +0200 (CEST)
From: Florian Lindner <mailinglists@xgm.de>
To: linux-media@vger.kernel.org
Subject: Problems with Si2168 DVB-C card (cx23885)
Message-ID: <10ab0033-763e-94d8-f638-716c5b2507e8@ipvs.uni-stuttgart.de>
Date: Wed, 22 Jun 2016 13:36:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I bought a TechnoTrend TT-budget CT2-4500 [1,2] DVB-C card and connected
it to my cable, using no CI. A TV connected on the same cable is
working, but the card is not.

I have installed the driver package from openelec [3,4] which includes
all firmware (Version 1 and 2) mentioned in [5] (according to
linuxtv.org my card is an OEM version of the DVB Sky T980C).

The outputs look ok to me:

$ dmesg | grep -i dvb
[   75.856005] cx23885_dvb_register() allocating 1 frontend(s)
[   75.856006] cx23885[0]: cx23885 based dvb card
[   75.995381] DVB: registering new adapter (cx23885[0])
[   75.995388] cx23885 0000:03:00.0: DVB: registering adapter 0 frontend
0 (Silicon Labs Si2168)...

$ lspci | grep -i cx23885
03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 04)

$ ls /dev/dvb/adapter0/
ca0  demux0  dvr0  frontend0  net0

$ lspci -vvvnn
03:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 04)
        Subsystem: Technotrend Systemtechnik GmbH TT-budget CT2-4500 CI
[13c2:3013]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at df000000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
SlotPowerLimit 10.000W
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
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
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
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
        Kernel modules: cx23885

$ dvb-fe-tool -d DVBC/ANNEX_A
Changing delivery system to: DVBC/ANNEX_A

prints these messages to the journal:

kernel: si2168 8-0064: found a 'Silicon Labs Si2168-B40'
kernel: si2168 8-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
kernel: si2168 8-0064: firmware version: 4.0.19
kernel: si2157 10-0060: found a 'Silicon Labs Si2157-A30'
kernel: si2157 10-0060: firmware version: 3.0.5


$ dvb-fe-tool
Device Silicon Labs Si2168 (/dev/dvb/adapter0/frontend0) capabilities:
     CAN_2G_MODULATION
     CAN_FEC_1_2
     CAN_FEC_2_3
     CAN_FEC_3_4
     CAN_FEC_5_6
     CAN_FEC_7_8
     CAN_FEC_AUTO
     CAN_GUARD_INTERVAL_AUTO
     CAN_HIERARCHY_AUTO
     CAN_INVERSION_AUTO
     CAN_MULTISTREAM
     CAN_MUTE_TS
     CAN_QAM_16
     CAN_QAM_32
     CAN_QAM_64
     CAN_QAM_128
     CAN_QAM_256
     CAN_QAM_AUTO
     CAN_QPSK
     CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.10, Current v5 delivery system: DVBC/ANNEX_A
Supported delivery systems:
     DVBT
     DVBT2
    [DVBC/ANNEX_A]



However dvb-fe-tool --femon says it has no signal:

$ dvb-fe-tool --femon
       (0x00) Signal= 0,00dBm
[...going on...]


and wx_scan finds no channels

$ w_scan -f c -c DE
w_scan -f c -c DE
w_scan version 20141122 (compiled for DVB API 5.10)
using settings for GERMANY
DVB cable
DVB-C
scan type CABLE, channellist 7
output format vdr-2.0
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
        /dev/dvb/adapter0/frontend0 -> CABLE "Silicon Labs Si2168": very
good :-))

Using CABLE frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.10
frontend 'Silicon Labs Si2168' supports
INVERSION_AUTO
QAM_AUTO
FEC_AUTO
FREQ (42.00MHz ... 870.00MHz)
SRATE (1.000MSym/s ... 7.200MSym/s)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
73000: sr6900 (time: 00:00.019) sr6875 (time: 00:01.529)
[...]


Distribution is Arch. Kernel version is 4.6.2.



As a (possible unrelated) side not: the remote also does not work.

Next step for me would be to use a Windows machine to test the card.

Although, it seems everything is fine, except that there is no signal.

Thanks for any advice!
Florian


[1] http://www.technotrend.eu/2984/TT-budget_CT2-4500_CI.html
[2] https://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_CT2-4500_CI
[3] https://github.com/OpenELEC/dvb-firmware/tree/master/firmware
[4] https://aur.archlinux.org/packages/openelec-dvb-firmware/
[5] https://www.linuxtv.org/wiki/index.php/DVBSky_T980C



