Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc3-s36.bay0.hotmail.com ([65.54.246.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aegyssus@hotmail.com>) id 1KfIml-0007x7-UV
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 20:26:58 +0200
Message-ID: <BLU134-DAV40A4F7A1645B9CC1B7E9FD3520@phx.gbl>
From: "Virgil Mocanu" <aegyssus@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 15 Sep 2008 14:26:20 -0400
MIME-Version: 1.0
Subject: [linux-dvb] LeadTek PxPVR2200 drivers
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

Hi,
I am just wondering if anybody succeeded to make a LeadTek PxPVR2200 work... 
It's using Conexant CX23885+CX23417 + Xceive silicon tuner.
The card is mostly sold in Eastern Europe but it is only coming with Windows 
drivers and v4l does not recognize it:
========================
cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 18 (level, low) -> IRQ 18
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
CORE cx23885[0]: subsystem: 107d:6f21, board: UNKNOWN/GENERIC 
[card=0,autodetected]
cx23885[0]: i2c bus 0 registered
tuner' 2-0061: chip found @ 0xc2 (cx23885[0])
cx23885[0]: i2c bus 1 registered
tvaudio' 3-004c: tea6420 found @ 0x98 (cx23885[0])
cx23885[0]: i2c bus 2 registered
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:07:00.0, rev: 2, irq: 18, latency: 0, mmio: 
0xfe800000
PCI: Setting latency timer of device 0000:07:00.0 to 64
========================

No video device is created for this card therefore it's totally unusable 
under Linux.
I played with the card by changing <card> option but none of them worked. I 
used the latest mercurial drivers but it did not help.

lspci -vvv returns this:
========================
07:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev 02)
        Subsystem: LeadTek Research Inc. Unknown device 6f21
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data <?>
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: cx23885
        Kernel modules: cx23885
========================

Many thanks for any suggestion,
aegyssus 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
