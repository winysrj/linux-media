Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp057.webpack.hosteurope.de ([80.237.132.64]:48194 "EHLO
        wp057.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbeKPFL1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 00:11:27 -0500
Subject: Re: TechnoTrend CT2-4500 remote not working
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
References: <236ee34e-3052-f511-36c4-5dd48c6b433b@mknetz.de>
 <20181111214536.q2mplhfb5luzl5mg@gofer.mess.org>
 <64464af6-a85e-b03a-27e6-42cea34424d8@mknetz.de>
 <20181114230736.x4uigczm45slcgdr@gofer.mess.org>
From: "martin.konopka@mknetz.de" <martin.konopka@mknetz.de>
Message-ID: <9e2205c8-50f7-06de-f1e5-8946258f6a91@mknetz.de>
Date: Thu, 15 Nov 2018 20:02:20 +0100
MIME-Version: 1.0
In-Reply-To: <20181114230736.x4uigczm45slcgdr@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean,

Am 15.11.2018 um 00:07 schrieb Sean Young:

>>
>> I turned on dynamic debug and got the following messages in the kernel log:
>>
>> [  837.160992] rc rc0: get_key_fusionhdtv: ff ff ff ff
>> [  837.263927] rc rc0: ir_key_poll
>> [  837.264528] rc rc0: get_key_fusionhdtv: ff ff ff ff
>> [  837.367840] rc rc0: ir_key_poll
>> [  837.368441] rc rc0: get_key_fusionhdtv: ff ff ff ff
>>
>> Pressing a key on the remote did not change the pattern. I rechecked the
>> connection of the IR receiver to the card but it was firmly plugged in.
> 
> Hmm, either the IR signal is not getting to the device, or this is not
> where the IR is reported. I guess also the firmware could be incorrect
> or out of date.

I have obtained the latest firmware from http://www.dvbsky.net/Support_linux.html

si2168 6-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
si2168 6-0064: firmware version: B 4.0.25

The firmware is now newer than before (4.0.11), but I still get no output with dynamic debugging.

> 
> Certainly a logic analyser would help here to see if the signal is arriving,
> and where it goes (e.g. directly to a gpio pin).

Currently, I do not have a logic analyser at hand.

> 
> What's the output of the lspci -vvv? Maybe it's reported via gpio and not
> i2c.

The output of lspci -vvv:

17:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 04)
	Subsystem: Technotrend Systemtechnik GmbH TT-budget CT2-4500 CI
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: Memory at fe000000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset- SlotPowerLimit 26.000W
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data
		Product Name: "
		End
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [200 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32+ WRR64+ WRR128-
		Ctrl:	ArbSelect=WRR64
		Status:	InProgress-
		Port Arbitration Table [240] <?>
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Kernel driver in use: cx23885
	Kernel modules: cx23885


Regards,

Martin
