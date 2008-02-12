Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp7-g19.free.fr ([212.27.42.64])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <didli@freesurf.fr>) id 1JOwk0-00028q-7Q
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 16:08:12 +0100
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 66300322830
	for <linux-dvb@linuxtv.org>; Tue, 12 Feb 2008 16:07:08 +0100 (CET)
Received: from [192.168.0.110] (fom78-1-88-178-68-136.fbx.proxad.net
	[88.178.68.136])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 2FBF33227F5
	for <linux-dvb@linuxtv.org>; Tue, 12 Feb 2008 16:07:08 +0100 (CET)
Message-ID: <47B1B61B.5010502@freesurf.fr>
Date: Tue, 12 Feb 2008 16:07:07 +0100
From: didli <didli@freesurf.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Any News for Avermedia Hybryd Express card A577 ?
	[didli]
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

http://www.avermedia.com/EN/Default.aspx?TYPE=vipplayercard.htm&PT=product&tv_TCAT_POS=0&PID=4710710671853&CATNO0=D&CATNO1=D2&CNT=1
------------------------
sudo lspci -vvxxx :

03:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev 02)
    Subsystem: Avermedia Technologies Inc Unknown device c039
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Interrupt: pin A routed to IRQ 0
    Region 0: Memory at d8000000 (64-bit, non-prefetchable) [disabled] 
[size=2M]
    Capabilities: [40] Express Endpoint IRQ 0
        Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
        Device: Latency L0s <64ns, L1 <1us
        Device: AtnBtn- AtnInd- PwrInd-
        Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
        Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
        Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
        Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
        Link: Latency L0s <2us, L1 <4us
        Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
        Link: Speed 2.5Gb/s, Width x1
    Capabilities: [80] Power Management version 2
        Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] Vital Product Data
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
00: f1 14 52 88 00 00 10 00 02 00 00 04 00 00 00 00
10: 04 00 00 d8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 61 14 39 c0
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
40: 10 80 01 00 00 00 04 05 10 28 0a 00 11 5c 01 00
50: 00 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 90 22 7e 00 00 00 00 00 00 00 00 00 00 00 00
90: 03 a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
