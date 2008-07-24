Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KM27l-00021p-VB
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 16:48:59 +0200
Date: Thu, 24 Jul 2008 22:43:59 +0800
To: linux-dvb@linuxtv.org
Message-ID: <20080724144359.GA24649@codon.goeng.com.au>
References: <20080723170342.GA5025@codon.goeng.com.au>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080723170342.GA5025@codon.goeng.com.au>
From: Thomas Goerke <tom@goeng.com.au>
Subject: Re: [linux-dvb] Compro E800F Hybrid D/A HW2 PCIe card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have now found that the E800 card is not
supported (http://www.linuxtv.org/wiki/index.php/DVB-T_PCIe_Cards).  I
am willing to test any code and have so far patched the v4l-dvb and the
card semi-works...ie I can run the scan using local au-perth.conf file
but I am unanle to sync.

FYI - I am runnign mythbuntu 8.04.


On Thu, Jul 24, 2008 at 01:03:42AM +0800, Thomas Goerke wrote:
> I have purchased a Compro E800F Hybrid D/A HW2 PCIe card.  The chips on the card include:
>         Conexant PCIe A/V decoder: CX23885-132
>         Conexant MPEG II A/V/Encoder CX23417-11Z
>         Zarlink ZL10353 Demodulator
>         Xceiver XC3008ACQ Video Tuner
> I have tried a number of solutions including building the latest copy of v4l-dvb and using the cx23885 module with card=4 option.
> The problem I am having is that the lgdt330x module is being loaded with the cx23885, however my demodulator is the zarlink ZL10353.  I am not sure on how to proceed.  Please see below for output of lspci -vvnn.
> 
> 03:00.0 Multimedia video controller [0400]: Conexant Unknown device [14f1:8852] (rev 02)
>         Subsystem: Compro Technology, Inc. Unknown device [185b:e800]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 17
>         Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=2M]
>         Capabilities: [40] Express Endpoint IRQ 0
>                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>                 Device: Latency L0s <64ns, L1 <1us
>                 Device: AtnBtn- AtnInd- PwrInd-
>                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
>                 Link: Latency L0s <2us, L1 <4us
>                 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
>                 Link: Speed 2.5Gb/s, Width x1
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [90] Vital Product Data
>         Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>                 Address: 0000000000000000  Data: 0000
> 
> Any help appreciated.
> 
> Thanks
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
