Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:56237 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760088Ab3DIIrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 04:47:52 -0400
Received: by mail-qc0-f169.google.com with SMTP id t2so1360616qcq.14
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 01:47:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516193FF.50709@schinagl.nl>
References: <CAK2FuSnQxgc2hvtgb=COH0BGaJVqY5Cg=4fYWpB_BwOn8TYE_w@mail.gmail.com>
	<516193FF.50709@schinagl.nl>
Date: Tue, 9 Apr 2013 10:47:51 +0200
Message-ID: <CAK2FuSnprxO78R1u6mSVXJX7WQ0Q_nnr+3vkW7x_y2YuYwHR9Q@mail.gmail.com>
Subject: Re: No Signal with TerraTec Cinergy T PCIe dual
From: Jan Saris <jan.saris@gmail.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for your reply,
Do you only use DVB-T, or also DVB-C? Because it looks to me that
DVB-C isn't implemented, or at least giving me a lot of errors?

I use the correct front-end of adapter2 (as you can see in the log:
DELIVERY_SYSTEM = DVBC/ANNEX_A)
adapter1 is only DVB-T

What do you meen by: "Remember to set the frontend properly;
dvb-fe-tool from memory"??
To set the delevery system to DVB-C before running the dvbv5-scan??

Jan

2013/4/7 Oliver Schinagl <oliver+list@schinagl.nl>:
> On 07-04-13 12:56, Jan Saris wrote:
>>
>> Hi,
>>
>> Sinse a couple of months I'm trying to get my second DVB-C card to
>> work, but with no luck.
>> I have searched a lot around and even tried the last media_build.
>
> I have the same card and while I don't see anything wrong (you have 2 dvb-t
> devices installed right? adapter0 is something else, and the Cinergy is
> adapter1 and adapter2? Ah, yes you do say 'other dvb-c' sorry.
>
>> I am running linux 3.5.0-26-generic with the latests media_build from
>> here (http://git.linuxtv.org/media_build.git)
>>
>> For some reason the card won't get a lock. Here are my test results:
>
> Remember to set the frontend properly; dvb-fe-tool from memory (tab
> completion ftw). And remember the cinergy is dual dvb-t; but only single
> dvb-c (and single analog, but i think that is still not implemented?)
>>
>>
>> Terratec Cinergy PCIe Dual
>> dvbv5-scan -a2 -v channel2.conf
>> using demux '/dev/dvb/adapter2/demux0'
>> Device DRXK DVB-C DVB-T (/dev/dvb/adapter2/frontend0) capabilities:
>>          CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 CAN_FEC_7_8
>> CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO
>> CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_32 CAN_QAM_64
>> CAN_QAM_128 CAN_QAM_256 CAN_RECOVER CAN_TRANSMISSION_MODE_AUTO
>> DVB API Version 5.6, Current v5 delivery system: DVBC/ANNEX_A
>> Supported delivery systems: [DVBC/ANNEX_A] DVBC/ANNEX_C DVBT
>> Scanning frequency #1 304000000
>> FREQUENCY = 304000000
>> MODULATION = QAM/64
>> INVERSION = AUTO
>> SYMBOL_RATE = 6875000
>> INNER_FEC = AUTO
>> DELIVERY_SYSTEM = DVBC/ANNEX_A
>> status 00 | signal   0% | snr   0% | ber 0 | unc 119 | tune failed
>> dmesg
>> [    5.332360] cx23885_dvb_register() allocating 1 frontend(s)
>> [    5.332365] cx23885[0]: cx23885 based dvb card
>> [    5.365162] drxk: status = 0x639160d9
>> [    5.365167] drxk: detected a drx-3916k, spin A3, xtal 20.250 MHz
>> [    5.465869] DRXK driver version 0.9.4300
>> [    5.504139] drxk: frontend initialized.
>> [    5.517782] mt2063_attach: Attaching MT2063
>> [    5.517788] DVB: registering new adapter (cx23885[0])
>> [    5.517791] DVB: registering adapter 1 frontend 0 (DRXK DVB-T)...
>> [    5.518664] cx23885_dvb_register() allocating 1 frontend(s)
>> [    5.518668] cx23885[0]: cx23885 based dvb card
>> [    5.533886] drxk: status = 0x639130d9
>> [    5.533896] drxk: detected a drx-3913k, spin A3, xtal 20.250 MHz
>> [    5.617338] DRXK driver version 0.9.4300
>> [    5.650861] drxk: frontend initialized.
>> [    5.650872] mt2063_attach: Attaching MT2063
>> [    5.650876] DVB: registering new adapter (cx23885[0])
>> [    5.650878] DVB: registering adapter 2 frontend 0 (DRXK DVB-C DVB-T)...
>> [    5.651338] cx23885_dev_checkrevision() Hardware revision = 0xa5
>> [    5.651343] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 16,
>> latency: 0, mmio: 0xff400000
>> ........
>> [  153.727978] mt2063: detected a mt2063 B3
>> [  153.877050] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with
>> params:
>> [  153.877058] drxk: 02 00 00 00 10 00 05 00 03 02
>> ..........
>> [  156.989702] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with
>> params:
>> [  156.989710] drxk: 02 00 00 00 10 00 05 00 03 02
>> ..........
>> [  170.558420] mt2063: detected a mt2063 B3
>> [  170.629422] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with
>> params:
>> [  170.629430] drxk: 02 00 00 00 10 00 05 00 03 02
>> ..........
>> [  173.742057] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with
>> params:
>> [  173.742065] drxk: 02 00 00 00 10 00 05 00 03 02
>> ..........
>> [  251.314900] mt2063: detected a mt2063 B3
>> [  251.385932] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with
>> params:
>> [  251.385940] drxk: 02 00 00 00 10 00 05 00 03 02
>> ..........
>> [  254.498522] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with
>> params:
>> [  254.498530] drxk: 02 00 00 00 10 00 05 00 03 02
>> ..........
>>
>> lspci -vvv
>> 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
>> PCI Video and Audio Decoder (rev 04)
>>          Subsystem: TERRATEC Electronic GmbH Cinergy T PCIe Dual
>>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>          Latency: 0, Cache Line Size: 64 bytes
>>          Interrupt: pin A routed to IRQ 16
>>          Region 0: Memory at ff400000 (64-bit, non-prefetchable) [size=2M]
>>          Capabilities: [40] Express (v1) Endpoint, MSI 00
>>                  DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>> <64ns, L1 <1us
>>                          ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>>                  DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                          RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                          MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                  DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>> AuxPwr- TransPend-
>>                  LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <2us, L1 <4us
>>                          ClockPM- Surprise- LLActRep- BwNot-
>>                  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
>> CommClk+
>>                          ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>          Capabilities: [80] Power Management version 2
>>                  Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>          Capabilities: [90] Vital Product Data
>>                  Product Name: "
>>                  End
>>          Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>>                  Address: 0000000000000000  Data: 0000
>>          Capabilities: [100 v1] Advanced Error Reporting
>>                  UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                  UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                  UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>>                  CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
>> NonFatalErr-
>>                  CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
>> NonFatalErr-
>>                  AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
>> ChkEn-
>>          Capabilities: [200 v1] Virtual Channel
>>                  Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                  Arb:    Fixed+ WRR32+ WRR64+ WRR128-
>>                  Ctrl:   ArbSelect=WRR64
>>                  Status: InProgress-
>>                  Port Arbitration Table [240] <?>
>>                  VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
>> RejSnoopTrans-
>>                          Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
>> WRR256-
>>                          Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>>                          Status: NegoPending- InProgress-
>>          Kernel driver in use: cx23885
>>          Kernel modules: cx23885
>>
>> It says no signal, but if I put the antenna-cable in my other DVB-C
>> card and do a scan I get:
>> Philips TV-Card
>> dvbv5-scan -a0 -v channel2.conf
>> using demux '/dev/dvb/adapter0/demux0'
>> Device Philips TDA10023 DVB-C (/dev/dvb/adapter0/frontend0) capabilities:
>>          CAN_FEC_AUTO CAN_INVERSION_AUTO CAN_QAM_16 CAN_QAM_32
>> CAN_QAM_64 CAN_QAM_128 CAN_QAM_256 CAN_QPSK
>> DVB API Version 5.6, Current v5 delivery system: DVBC/ANNEX_A
>> Supported delivery systems: [DVBC/ANNEX_A] DVBC/ANNEX_C
>> Scanning frequency #1 304000000
>> FREQUENCY = 304000000
>> MODULATION = QAM/64
>> INVERSION = AUTO
>> SYMBOL_RATE = 6875000
>> INNER_FEC = AUTO
>> DELIVERY_SYSTEM = DVBC/ANNEX_A
>> status 1f | signal  97% | snr  94% | ber 1728 | unc 62194 | FE_HAS_LOCK
>>
>> Service #0 (101) Nederland 1 channel 0.1.0
>> Service #1 (102) Nederland 2 channel 0.2.1
>> Service #2 (103) Nederland 3 channel 0.3.2
>> Service #3 (8101) 100%NL channel 0.801.3
>> Service #4 (8102) Arrow Classic Rock channel 0.802.4
>> Service #5 (8103) Arrow Jazz channel 0.803.5
>> Service #6 (8104) BBC radio 1 channel 0.804.6
>> Service #7 (8105) BBC radio 2 channel 0.805.7
>> Service #8 (8106) BBC radio 3 channel 0.806.8
>> Service #9 (8107) BBC radio 4 channel 0.807.9
>> Service #10 (8108) BNR channel 0.808.10
>> Service #11 (8109) Classic FM channel 0.809.11
>> New transponder/channel found: #2: 505937920
>> New transponder/channel found: #3: 515112960
>> New transponder/channel found: #4: 524288000
>> New transponder/channel found: #5: 529530880
>> New transponder/channel found: #6: 538705920
>> New transponder/channel found: #7: 547880960
>> New transponder/channel found: #8: 557056000
>> New transponder/channel found: #9: 566231040
>> New transponder/channel found: #10: 312000000
>> New transponder/channel found: #11: 320000000
>> New transponder/channel found: #12: 328000000
>> New transponder/channel found: #13: 336000000
>> New transponder/channel found: #14: 580648960
>> New transponder/channel found: #15: 344000000
>> New transponder/channel found: #16: 352000000
>> New transponder/channel found: #17: 360000000
>> New transponder/channel found: #18: 368000000
>>
>> Does anyone know what I'm doing wrong?
>> Thanks,
>>
>> Jan Saris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
