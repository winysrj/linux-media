Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.icp-qv1-irony-out1.iinet.net.au ([203.59.1.146]:45443
	"EHLO webmail.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbZGFROv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2009 13:14:51 -0400
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: linux-media@vger.kernel.org,
	'Collier Family' <judithc@bigpond.net.au>
Subject: Re: DVICO Fusion Dual Express
Reply-To: sonofzev@iinet.net.au
Date: Tue, 07 Jul 2009 01:04:51 +0800
Message-Id: <7978.1246899891@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi there

I get this error message on some of my motherboards but not all, only when
another tuner is in the machine..
I think this was IRQ sharing related. When I have it on a newer board with more
interrupts it seems to work fine

On Mon Jul  6 20:21 , "Collier Family"  sent:

>I have a Dvico Fusion Dual Express. It is unfortunately rev 4 and the 
>firmware is not correct.
>
>lspci -vv -nn
>
>04:00.0 0400: 14f1:8852 (rev 04)
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
>Step
>ping- SERR- FastB2B-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
>
>SERR- 
>        Latency: 0
>        Interrupt: pin A routed to IRQ 193
>        Region 0: Memory at 57200000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: [40] Express Endpoint IRQ 0
>                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
>ExtTag-
>                Device: Latency L0s 
>                Device: AtnBtn- AtnInd- PwrInd-
>                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
>                Link: Latency L0s 
>                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
>                Link: Speed 2.5Gb/s, Width x1
>        Capabilities: [80] Power Management version 2
>                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
>PME(D0+,D1+,D2+,D3hot
>+,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [90] Vital Product Data
>        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/0 
>Enable
>-
>                Address: 0000000000000000  Data: 0000
>
>the system recognises it 2.6.18-128.1.10.el5 using 
>video4linux-20090415-88.0.4.el5.x86_64 from atrpms
>
>I'm getting the following from firmware load
>
>Jul  6 20:18:41 localhost kernel: xc2028 1-0061: Loading firmware for 
>type=BASE F8MHZ (3), id 0000000000000000.
>Jul  6 20:18:42 localhost kernel: xc2028 1-0061: Loading firmware for 
>type=D2633 DTV7 (90), id 0000000000000000.
>Jul  6 20:18:42 localhost kernel: xc2028 1-0061: Loading SCODE for type=DTV6 
>QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 
>0000000000000000.
>Jul  6 20:18:42 localhost kernel: xc2028 1-0061: Incorrect readback of 
>firmware version.
>
>I suspect rev 4 uses different firmware.
>
>Any help would be greatly appreciated.
>
>Stephen
>
>
>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>)


