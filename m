Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.woosh.co.nz ([202.74.207.2] helo=mail2.woosh.co.nz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wayneandholly@woosh.co.nz>) id 1JsNen-0004AX-RN
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 21:44:31 +0200
Received: from speedy (203-211-106-230.ue.woosh.co.nz [203.211.106.230]) by
	woosh.co.nz
	(Rockliffe SMTPRA 6.1.22) with ESMTP id <B0116619277@mail2.woosh.co.nz>
	for <linux-dvb@linuxtv.org>; Sun, 4 May 2008 07:43:51 +1200
From: "Wayne and Holly" <wayneandholly@woosh.co.nz>
To: <linux-dvb@linuxtv.org>
Date: Sun, 4 May 2008 07:43:37 +1200
Message-ID: <000101c8ad55$fb1d0e70$fd01a8c0@speedy>
MIME-Version: 1.0
In-Reply-To: <000001c8ad55$c1dd7280$fd01a8c0@speedy>
Subject: Re: [linux-dvb] Geniatech DVB-S Digistar
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

I'll try again,
Is anyone using the subject card without any problems?  I read a handful
of articles stating that the card was supported in Linux out of the box,
but my playback is unwatchable.  I doubt it is my system as a 2.1GHz
dual core CPU and 4GB DDR2 should be overkill.  I was surprised to see
"Conextant Unknown Device [14f1:0084]" for the lspci subsystem
considering it is supported by the cx88 module but don't know if this is
an issue.  I'm guessing I may need to change some of my settings but
have not been able to find any documentation that gives any clues for
where to start.

Here is my lspci -vvn output:

01:06.0 0400: 14f1:8800 (rev 05)
Subsystem: 14f1:0084
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
Latency: 20 (5000ns min, 13750ns max), Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
Capabilities: [44] Vital Product Data
Capabilities: [4c] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:06.2 0480: 14f1:8802 (rev 05)
Subsystem: 14f1:0084
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
Capabilities: [4c] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Cheers
Wayne



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
