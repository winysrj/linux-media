Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <chrivers@iversen-net.dk>) id 1OdpZ9-0002HR-Fo
	for linux-dvb@linuxtv.org; Tue, 27 Jul 2010 21:11:52 +0200
Received: from mail.sikkerhed.org ([78.109.215.82])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OdpZ8-00024E-2a; Tue, 27 Jul 2010 21:11:51 +0200
Received: from localhost (mailscan.sikkerhed.org [78.109.215.84])
	by mail.sikkerhed.org (Postfix) with ESMTP id 2161216317
	for <linux-dvb@linuxtv.org>; Tue, 27 Jul 2010 21:11:49 +0200 (CEST)
Received: from mail.sikkerhed.org ([78.109.215.82])
	by localhost (mailscan.sikkerhed.org [78.109.215.84]) (amavisd-new,
	port 10024) with LMTP id IGJIjB3kgmoP for <linux-dvb@linuxtv.org>;
	Tue, 27 Jul 2010 21:11:41 +0200 (CEST)
Received: from [10.0.0.7] (boreas.sikkerhed.org [130.225.166.200])
	by mail.sikkerhed.org (Postfix) with ESMTPSA id 9E54C16309
	for <linux-dvb@linuxtv.org>; Tue, 27 Jul 2010 21:11:41 +0200 (CEST)
Message-ID: <4C4F2F6D.9000008@iversen-net.dk>
Date: Tue, 27 Jul 2010 21:11:41 +0200
From: Christian Iversen <chrivers@iversen-net.dk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Unknown CX23885 device
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hey Linux-DVB people

I'm trying to make an as-of-yet unsupported CX23885 device work in Linux.

I've tested that the device is not supported using the newest snapshot
of the DVB drivers. They did support a bunch of extra devices compared
to the standard ubuntu driver, but to no avail.

This is what I know about the device:

### physical description ###

The device is a small mini-PCIe device currently installed in my
Thinkpad T61p notebook. It did not originate there, but I managed to 
fit it in.

It has an "Avermedia" logo on top, but no other discernable markings. 

I've tried removing the chip cover, but I can't see any other major chips
than the cx23885. I can take a second look, if I know what to look for.

### pci info ###

$ sudo lspci -s 02:00.0 -vv
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 02)
        Subsystem: Avermedia Technologies Inc Device c139
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at d7a00000 (64-bit, non-prefetchable) [size=2M]
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
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: cx23885
        Kernel modules: cx23885


I've tried several different card=X settings for "modprobe cx23885", and a few of them 
result in creation of /dev/dvb devices, but none of them really seem towork.

What can I try for a next step?

-- 
Med venlig hilsen
Christian Iversen

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
