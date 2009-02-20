Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eyal@eyal.emu.id.au>) id 1LaRz5-0008GB-1L
	for linux-dvb@linuxtv.org; Fri, 20 Feb 2009 10:47:54 +0100
Received: from e4.eyal.emu.id.au (really [192.168.3.4]) by eyal.emu.id.au
	via in.smtpd with esmtp
	id <m1LaRxr-001IKIC@eyal.emu.id.au> (Debian Smail3.2.0.115)
	for <linux-dvb@linuxtv.org>; Fri, 20 Feb 2009 20:46:35 +1100 (EST)
Message-ID: <499E7BF9.3060200@eyal.emu.id.au>
Date: Fri, 20 Feb 2009 20:46:33 +1100
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
MIME-Version: 1.0
To: list linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] AverTV Duo Hybrid PCI-E
Reply-To: linux-media@vger.kernel.org
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

I have this card and want to use the two DVB-T tuners. The machine runs F10/x86_64.

Which driver(s) handle(s) this card? I understood that it uses the saa7162.
I downloaded and built the package (work in progress) but it did not detect a thing.

Below are some relevant details and I am game to try and get it going as the machine
is not yet commissioned.

TIA

lspci
=====
01:00.0 Multimedia controller: Philips Semiconductors Pinnacle PCTV 3010iX Dual Analog + DVB-T (VT8251 Ultra VLINK Controller) (rev 01)
         Subsystem: Avermedia Technologies Inc Device 011c
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at f3000000 (64-bit, non-prefetchable) [size=1M]
         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ Count=1/32 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [50] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
                         ClockPM- Suprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
         Capabilities: [74] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Vendor Specific Information <?>
         Capabilities: [100] Vendor Specific Information <?>

lshal
=====
udi = '/org/freedesktop/Hal/devices/pci_1131_7162'
   info.parent = '/org/freedesktop/Hal/devices/pci_8086_29c1'  (string)
   info.product = 'Unknown (0x7162)'  (string)
   info.subsystem = 'pci'  (string)
   info.udi = '/org/freedesktop/Hal/devices/pci_1131_7162'  (string)
   info.vendor = 'Philips Semiconductors'  (string)
   linux.hotplug_type = 2  (0x2)  (int)
   linux.subsystem = 'pci'  (string)
   linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0'  (string)
   pci.device_class = 4  (0x4)  (int)
   pci.device_protocol = 0  (0x0)  (int)
   pci.device_subclass = 128  (0x80)  (int)
   pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0'  (string)
   pci.product_id = 29026  (0x7162)  (int)
   pci.subsys_product_id = 284  (0x11c)  (int)
   pci.subsys_vendor = 'Avermedia Technologies Inc'  (string)
   pci.subsys_vendor_id = 5217  (0x1461)  (int)
   pci.vendor = 'Philips Semiconductors'  (string)
   pci.vendor_id = 4401  (0x1131)  (int)
-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
