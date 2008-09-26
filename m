Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n2b.bullet.mail.ac4.yahoo.com ([76.13.13.72])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <albatrosmwdvb@yahoo.com>) id 1KjIUq-0008OC-2h
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 20:56:57 +0200
Date: Fri, 26 Sep 2008 11:56:21 -0700 (PDT)
From: Marek Marek <albatrosmwdvb@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <114395.53052.qm@web59909.mail.ac4.yahoo.com>
Subject: [linux-dvb] Compro VideoMate E600F analog PCIe TV/FM capture card
Reply-To: albatrosmwdvb@yahoo.com
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

I have Compro VideoMate E600F analog PCIe TV/FM capture card with MPEG II A/V Encoder. I use Gentoo 2008.0 with 2.6.25-gentoo-r7 x86_64 kernel. There's no any support for this card on the V4L/DVB repository yet, so anybody help me?

lspci -vvnn
02:00.0 Multimedia video controller [0400]: Conexant Device [14f1:8852] (rev 02)
        Subsystem: Compro Technology, Inc. Device [185b:e800]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at fd600000 (64-bit, non-prefetchable) [size=2M]
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

dmesg
cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
cx23885[0]: Your board isn't known (yet) to the driver.  You can
cx23885[0]: try to pick one of the existing card configs via
cx23885[0]: card=<n> insmod option.  Updating to the latest
cx23885[0]: version might help as well.
cx23885[0]: Here is a list of valid choices for the card=<n> insmod option:
cx23885[0]:    card=0 -> UNKNOWN/GENERIC
cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual Express
cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
CORE cx23885[0]: subsystem: 185b:e800, board: UNKNOWN/GENERIC [card=0,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfd600000
PCI: Setting latency timer of device 0000:02:00.0 to 64

Conexant CX23885-13Z PCIe A/V Decoder
Conexant CX23417-11Z MPEG II A/V Encoder
XCeive XC2028ACQ Video Tuner

Detailed specification is on http://linuxtv.org/wiki/index.php/Compro_VideoMate_E600F

Thanks for any help.

Marek Wasilow

PS: Sorry for my poor english...



      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
