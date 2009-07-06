Return-path: <linux-media-owner@vger.kernel.org>
Received: from nschwqsrv03p.mx.bigpond.com ([61.9.189.237]:40530 "EHLO
	nschwqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbZGFKsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2009 06:48:23 -0400
Received: from nschwotgx01p.mx.bigpond.com ([124.183.155.229])
          by nschwmtas04p.mx.bigpond.com with ESMTP
          id <20090706102116.YHMI2030.nschwmtas04p.mx.bigpond.com@nschwotgx01p.mx.bigpond.com>
          for <linux-media@vger.kernel.org>; Mon, 6 Jul 2009 10:21:16 +0000
Received: from 9CMDW1S ([124.183.155.229]) by nschwotgx01p.mx.bigpond.com
          with SMTP
          id <20090706102115.LAAK12022.nschwotgx01p.mx.bigpond.com@9CMDW1S>
          for <linux-media@vger.kernel.org>; Mon, 6 Jul 2009 10:21:15 +0000
Message-ID: <6AA752628FE8450481603E1B34A9F54F@ap.panavision.com>
From: "Collier Family" <judithc@bigpond.net.au>
To: <linux-media@vger.kernel.org>
References: <ecc841d80907060142y29a7c7au136574d1cfc392c8@mail.gmail.com>
Subject: DVICO Fusion Dual Express
Date: Mon, 6 Jul 2009 20:21:15 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Dvico Fusion Dual Express. It is unfortunately rev 4 and the 
firmware is not correct.

lspci -vv -nn

04:00.0 0400: 14f1:8852 (rev 04)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Step
ping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 193
        Region 0: Memory at 57200000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <2us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot
+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/0 
Enable
-
                Address: 0000000000000000  Data: 0000

the system recognises it 2.6.18-128.1.10.el5 using 
video4linux-20090415-88.0.4.el5.x86_64 from atrpms

I'm getting the following from firmware load

Jul  6 20:18:41 localhost kernel: xc2028 1-0061: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
Jul  6 20:18:42 localhost kernel: xc2028 1-0061: Loading firmware for 
type=D2633 DTV7 (90), id 0000000000000000.
Jul  6 20:18:42 localhost kernel: xc2028 1-0061: Loading SCODE for type=DTV6 
QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 
0000000000000000.
Jul  6 20:18:42 localhost kernel: xc2028 1-0061: Incorrect readback of 
firmware version.

I suspect rev 4 uses different firmware.

Any help would be greatly appreciated.

Stephen





