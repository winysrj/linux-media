Return-path: <linux-media-owner@vger.kernel.org>
Received: from acoma.photonsoftware.net ([65.254.60.10]:51264 "EHLO
	acoma.photonsoftware.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZGAPCx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2009 11:02:53 -0400
Received: from localhost ([127.0.0.1] helo=[127.0.0.100])
	by acoma.photonsoftware.net with esmtpa (Exim 4.69)
	(envelope-from <ldone@hubstar.net>)
	id 1MM0XX-0004lq-2L
	for linux-media@vger.kernel.org; Wed, 01 Jul 2009 15:11:59 +0100
Message-ID: <4A4B6EB3.7070207@hubstar.net>
Date: Wed, 01 Jul 2009 15:12:03 +0100
From: "ldone@hubstar.net" <ldone@hubstar.net>
Reply-To: "l d one"@hubstar.net
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [Fwd: [linux-dvb] HVR-1700 No channels found - signal locked]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

I'm having problems getting the HVR-1700 working. It seems to be
supported, but I can't get the DVB-T channels to be detected.

I'll try to summarise.

OS is SUSE 11.1
Kernel is 2.6.27.23-0.1-default
X86_64 platform.

I have tried both the latest v4l code and the default code.

System has had the following
PVR-150 - works fine
HVR-1300 - worked fine in either Analogue OR digital mode. Could not
switch back to digital once Analogue started. Channels not found. Signal
found just no channels. Fine if I use just digital mode.
Hauppauge Nova DVB-S plus - Works fine
Pinnacle PCIe Dual Hybrid Pro - no drivers
Hauppauge Nova T-Stick - works fine

Hauppauge PCIe HVR-1700 no channels found.

>From start up - thing look okay

Jun 30 23:44:09 mediacentral kernel: tda18271 1-0060: destroying instance
Jun 30 23:44:14 mediacentral kernel: cx23885 driver version 0.0.2 loaded
Jun 30 23:44:14 mediacentral kernel: cx23885 0000:03:00.0: PCI INT A ->
Link[APC5] -> GSI 16 (level, low) -> IR$
Jun 30 23:44:14 mediacentral kernel: CORE cx23885[0]: subsystem:
0070:8101, board: Hauppauge WinTV-HVR1700 [car$
Jun 30 23:44:14 mediacentral kernel: tveeprom 0-0050: Hauppauge model
81519, rev B2E9, serial# 3612252
Jun 30 23:44:14 mediacentral kernel: tveeprom 0-0050: MAC address is
00-0D-FE-37-1E-5C
Jun 30 23:44:14 mediacentral kernel: tveeprom 0-0050: tuner model is
Philips 18271_8295 (idx 149, type 54)
Jun 30 23:44:14 mediacentral kernel: tveeprom 0-0050: TV standards
PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC$
Jun 30 23:44:14 mediacentral kernel: tveeprom 0-0050: audio processor is
CX23885 (idx 39)
Jun 30 23:44:14 mediacentral kernel: tveeprom 0-0050: decoder processor
is CX23885 (idx 33)
Jun 30 23:44:14 mediacentral kernel: tveeprom 0-0050: has no radio
Jun 30 23:44:14 mediacentral kernel: cx23885[0]: hauppauge eeprom:
model=81519
Jun 30 23:44:14 mediacentral kernel: cx25840 2-0044: cx25  0-21 found @
0x88 (cx23885[0])
Jun 30 23:44:14 mediacentral kernel: firmware: requesting
v4l-cx23885-avcore-01.fw
Jun 30 23:44:15 mediacentral kernel: cx25840 2-0044: loaded
v4l-cx23885-avcore-01.fw firmware (16382 bytes)
Jun 30 23:44:15 mediacentral kernel: cx23885_dvb_register() allocating 1
frontend(s)
Jun 30 23:44:15 mediacentral kernel: cx23885[0]: cx23885 based dvb card
Jun 30 23:44:15 mediacentral kernel: tda829x 1-0042: type set to tda8295
Jun 30 23:44:15 mediacentral kernel: tda18271 1-0060: creating new instance
Jun 30 23:44:15 mediacentral kernel: TDA18271HD/C1 detected @ 1-0060
Jun 30 23:44:16 mediacentral kernel: DVB: registering new adapter
(cx23885[0])
Jun 30 23:44:16 mediacentral kernel: DVB: registering adapter 1 frontend
0 (NXP TDA10048HN DVB-T)...
Jun 30 23:44:16 mediacentral kernel: DVB: registering new adapter
(cx23885[0])
Jun 30 23:44:16 mediacentral kernel: DVB: registering adapter 1 frontend
0 (NXP TDA10048HN DVB-T)...
Jun 30 23:44:16 mediacentral kernel: cx23885_dev_checkrevision()
Hardware revision = 0xb0
Jun 30 23:44:16 mediacentral kernel: cx23885[0]/0: found at
0000:03:00.0, rev: 2, irq: 16, latency: 0, mmio: 0x$
Jun 30 23:44:16 mediacentral kernel: cx23885 0000:03:00.0: setting
latency timer to 64
Jun 30 23:44:26 mediacentral kernel: tda10048_firmware_upload: waiting
for firmware upload (dvb-fe-tda10048-1.0$
Jun 30 23:44:26 mediacentral kernel: firmware: requesting
dvb-fe-tda10048-1.0.fw
Jun 30 23:44:26 mediacentral kernel: tda10048_firmware_upload: firmware
read 24878 bytes.
Jun 30 23:44:26 mediacentral kernel: tda10048_firmware_upload: firmware
uploading
Jun 30 23:44:29 mediacentral kernel: tda10048_firmware_upload: firmware
uploaded

scan shows
using '/dev/dvb/adapter8/frontend0' and '/dev/dvb/adapter8/demux0'
initial transponder 842000000 0 3 9 1 0 0 0
initial transponder 841833000 0 3 9 1 0 0 0
initial transponder 729833000 0 2 9 3 0 0 0
initial transponder 729667000 0 2 9 3 0 0 0
initial transponder 730000000 0 2 9 3 0 0 0
initial transponder 761833000 0 2 9 3 0 0 0
initial transponder 785833000 0 3 9 1 0 0 0
initial transponder 809833000 0 3 9 1 0 0 0
initial transponder 690000000 0 3 9 1 0 0 0
>>> tune to:
842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:

Kaffeine can't tune in on this either.

I've searched everything but it doesn't seem a common problem or no
solutions forth coming. Is there anything I can try? I'm out of ideas,
and I really just want it to work out of obsession now. I don't have
windows on that system, but I wonder if it shares the same problem with
the 1300 where DVB initialisation after analogue use didn't happen right.

card info
03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 02)
        Subsystem: Hauppauge computer works Inc. Device 8101
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at dd000000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data <?>
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: cx23885
        Kernel modules: cx23885


Thanks anyone


