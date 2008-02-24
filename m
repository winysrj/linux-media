Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp4.global.net.uk ([80.189.92.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <grahamlucking@madasafish.com>) id 1JTFE7-00007S-3a
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 12:41:03 +0100
Received: from gr.189.162.229.dial.global.net.uk ([80.189.162.229])
	by smtp4.global.net.uk with esmtp (Exim 4.42) id 1JTFE2-00026e-LB
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 11:40:59 +0000
From: Graham Lucking <grahamlucking@madasafish.com>
To: linux-dvb@linuxtv.org
Date: Sun, 24 Feb 2008 11:41:27 +0000
Message-Id: <1203853287.7074.18.camel@graham-desktop>
Mime-Version: 1.0
Subject: [linux-dvb] Compro E700
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

Hi

I have a Compro E700 that is using electricity to no useful purpose. I
am new to linux but I would like to help. You ask for information. This
is what I can give. Hope I am not wasting you efforts.

regards 

Graham Lucking

Compro E700 Dual DVB-T PCI-E TV card
Ubuntu 7:10  Harware information = Device manager

82801H (ICH8 Family) PCI Epress Port 3
unknown (0x0720)


	
Device tab for unknown (0x0720) contains this:

Vendor  Micronas Semiconductor Holdings AG
Device	Unknown (0x0720)

PCI tab for unknown (0x0720) contains this:

Vendor:  Micronas Semiconductor Holdings AG
Product: Unknown (0x0720)
OEM Vendor: Compro technology, Inc.
OEM Product: Unknown (0x0720)

Advance tab for unknown (0x0720) contains this:

Key			Type	Value
info.bus		string	pci
info.parent string	/org/freedesktop/HAL/devices/pci_8086_2843
info.product		string	unknown (0x0720)
info.subsystem          string pci
info.udi	 string	/org/freedesktop/HAL/devices/pci_18c3_720
info.vendor		string	Micronas Semiconductor Holdings AG
linux.hotplug_type init	2(0x2)
linux.subsystem		string	pci
linux.sysfs_path string	/sys/devices/pci0000:00/0000:001c.2/000:04:00.0
pci.device_class int	4(0x4)
pci.device_protocol 	int	0(0x0)
pci.device_subclass 	int	0(0x0)
pci.linux.sysfs_path
string /sys/devices/pci0000:00/0000:001c.2/000:04:00.0
pci.product_id		int	1824 (0x720)
pci.subsys_product_id	int	61440 (0xf000)
pci.subsys_vendor string  Compro technology, Inc.
pci.subsys_vendir_id	int	6235 (0x185b)
pci.vendor		string	Micronas Semiconductor Holdings AG
pci.vendor_id		int	6339 (0x18c3)

	dmesg gives this information

[   26.246879] PCI: Bridge: 0000:00:1c.0
[   26.246880]   IO window: disabled.
[   26.246884]   MEM window: disabled.
[   26.246886]   PREFETCH window: dfe00000-dfefffff
[   26.246890] PCI: Bridge: 0000:00:1c.2
[   26.246891]   IO window: disabled.
[   26.246895]   MEM window: fe900000-fe9fffff
[   26.246897]   PREFETCH window: disabled.
[   26.246901] PCI: Bridge: 0000:00:1c.4
[   26.246903]   IO window: a000-afff
[   26.246906]   MEM window: fe800000-fe8fffff
[   26.246909]   PREFETCH window: disabled.
[   26.246912] PCI: Bridge: 0000:00:1c.5
[   26.246914]   IO window: 9000-9fff
[   26.246918]   MEM window: fe700000-fe7fffff
[   26.246920]   PREFETCH window: disabled.

[   26.246943] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   26.246947] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   26.246960] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   26.246963] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   26.246977] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level,
low) -> IRQ 17
[   26.246980] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   26.246993] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level,
low) -> IRQ 16
[   26.246997] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   26.247010] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level,
low) -> IRQ 18

[   27.041970] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   27.041995] assign_interrupt_mode Found MSI capability
[   27.041997] Allocate Port Service[0000:00:01.0:pcie00]
[   27.042052] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   27.042084] assign_interrupt_mode Found MSI capability
[   27.042085] Allocate Port Service[0000:00:1c.0:pcie00]
[   27.042107] Allocate Port Service[0000:00:1c.0:pcie02]
[   27.042164] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   27.042196] assign_interrupt_mode Found MSI capability
[   27.042198] Allocate Port Service[0000:00:1c.2:pcie00]
[   27.042221] Allocate Port Service[0000:00:1c.2:pcie02]
[   27.042280] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   27.042312] assign_interrupt_mode Found MSI capability
[   27.042313] Allocate Port Service[0000:00:1c.4:pcie00]
[   27.042334] Allocate Port Service[0000:00:1c.4:pcie02]
[   27.042394] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[   27.042426] assign_interrupt_mode Found MSI capability
[   27.042427] Allocate Port Service[0000:00:1c.5:pcie00]
[   27.042450] Allocate Port Service[0000:00:1c.5:pcie02]

	lspci -vvn gives this information

00:1c.2 0604: 8086:2843 (rev 02) (prog-if 00 [Normal decode])
   	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
    	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
      	Latency: 0, Cache Line Size: 32 bytes
       	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
      	Memory behind bridge: fe900000-fe9fffff
       	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
       	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
       	Capabilities: <access denied>
	
04:00.0 0400: 18c3:0720
        Subsystem: 185b:f000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 15
        Region 0: Memory at fe9f0000 (32-bit, non-prefetchable)
[size=64K]
        Region 1: Memory at fe9e0000 (64-bit, non-prefetchable)
[size=64K]
        Capabilities: <access denied>

End of information



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
