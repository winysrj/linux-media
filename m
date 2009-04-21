Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s5.bay0.hotmail.com ([65.54.246.205]:7941 "EHLO
	bay0-omc3-s5.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZDUEee convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 00:34:34 -0400
Message-ID: <BAY102-W449F03E9EBE1B3BB2CDEDECF770@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <stoth@linuxtv.org>, <pghben@yahoo.com>
CC: <linux-media@vger.kernel.org>, <mchehab@infradead.org>
Subject: RE: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
Date: Mon, 20 Apr 2009 23:34:33 -0500
In-Reply-To: <49ED269F.9030603@linuxtv.org>
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
  <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
  <1240245715.5388.126.camel@mountainboyzlinux0>
 <49ECA8DD.9090708@linuxtv.org>
  <1240249684.5388.146.camel@mountainboyzlinux0>
 <49ECBCF0.3060806@linuxtv.org>
  <1240255677.5388.153.camel@mountainboyzlinux0>
 <49ECD553.9090707@linuxtv.org>
  <1240259904.5388.178.camel@mountainboyzlinux0>
 <49ECEEA3.6010203@linuxtv.org>
  <1240265172.5388.184.camel@mountainboyzlinux0>
 <49ED269F.9030603@linuxtv.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I tried updating it just a few minutes ago.  After a restart, I tried using the card.  I still get no lights on the card and get no lock on any channels.  with MCE in windows I get about 6 channels at my location, all with very good signal strength.  


Here is my output from lspci -vnn followed by the out put from dmesg.  I am sorry it is so long, I wanted to include it all in case you see something I missed.


 lspci -vnn
00:00.0 Host bridge [0600]: ATI Technologies Inc RS690 Host Bridge [1002:7910]
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64

00:01.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx) [1002:7912]
    Flags: bus master, 66MHz, medium devsel, latency 64
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
    I/O behind bridge: 00009000-00009fff
    Memory behind bridge: f8200000-f83fffff
    Prefetchable memory behind bridge: 00000000f0000000-00000000f7ffffff
    Capabilities: 
    Kernel modules: shpchp

00:05.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 1) [1002:7915]
    Flags: bus master, fast devsel, latency 0
    Bus: primary=00, secondary=0b, subordinate=10, sec-latency=0
    Memory behind bridge: f8000000-f81fffff
    Capabilities: 
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:06.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 2) [1002:7916]
    Flags: bus master, fast devsel, latency 0
    Bus: primary=00, secondary=11, subordinate=11, sec-latency=0
    I/O behind bridge: 0000a000-0000afff
    Memory behind bridge: f8500000-f85fffff
    Prefetchable memory behind bridge: 00000000f8700000-00000000f87fffff
    Capabilities: 
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:07.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 3) [1002:7917]
    Flags: bus master, fast devsel, latency 0
    Bus: primary=00, secondary=17, subordinate=17, sec-latency=0
    Memory behind bridge: f8400000-f84fffff
    Capabilities: 
    Kernel driver in use: pcieport-driver
    Kernel modules: shpchp

00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5 SATA [1002:4380] (prog-if 01)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 22
    I/O ports at 8440 [size=8]
    I/O ports at 8434 [size=4]
    I/O ports at 8438 [size=8]
    I/O ports at 8430 [size=4]
    I/O ports at 8400 [size=16]
    Memory at f8909000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: 
    Kernel driver in use: ahci
    Kernel modules: ahci

00:13.0 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI0) [1002:4387] (prog-if 10)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
    Memory at f8904000 (32-bit, non-prefetchable) [size=4K]
    Kernel driver in use: ohci_hcd
    Kernel modules: ohci-hcd

00:13.1 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI1) [1002:4388] (prog-if 10)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
    Memory at f8905000 (32-bit, non-prefetchable) [size=4K]
    Kernel driver in use: ohci_hcd
    Kernel modules: ohci-hcd

00:13.2 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI2) [1002:4389] (prog-if 10)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
    Memory at f8906000 (32-bit, non-prefetchable) [size=4K]
    Kernel driver in use: ohci_hcd
    Kernel modules: ohci-hcd

00:13.3 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI3) [1002:438a] (prog-if 10)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
    Memory at f8907000 (32-bit, non-prefetchable) [size=4K]
    Kernel driver in use: ohci_hcd
    Kernel modules: ohci-hcd

00:13.4 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI4) [1002:438b] (prog-if 10)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 18
    Memory at f8908000 (32-bit, non-prefetchable) [size=4K]
    Kernel driver in use: ohci_hcd
    Kernel modules: ohci-hcd

00:13.5 USB Controller [0c03]: ATI Technologies Inc SB600 USB Controller (EHCI) [1002:4386] (prog-if 20)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
    Memory at f8909400 (32-bit, non-prefetchable) [size=256]
    Capabilities: 
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller [1002:4385] (rev 14)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: 66MHz, medium devsel
    I/O ports at 8410 [size=16]
    Capabilities: 
    Kernel driver in use: piix4_smbus
    Kernel modules: i2c-piix4

00:14.1 IDE interface [0101]: ATI Technologies Inc SB600 IDE [1002:438c] (prog-if 8a [Master SecP PriP])
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
    I/O ports at 01f0 [size=8]
    I/O ports at 03f4 [size=1]
    I/O ports at 0170 [size=8]
    I/O ports at 0374 [size=1]
    I/O ports at 8420 [size=16]
    Kernel driver in use: pata_atiixp
    Kernel modules: ata_generic, pata_acpi, pata_atiixp

00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383]
    Subsystem: Toshiba America Info Systems Device [1179:ff08]
    Flags: bus master, slow devsel, latency 64, IRQ 16
    Memory at f8900000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: 
    Kernel driver in use: HDA Intel
    Kernel modules: snd-hda-intel

00:14.3 ISA bridge [0601]: ATI Technologies Inc SB600 PCI to LPC Bridge [1002:438d]
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI Bridge [1002:4384] (prog-if 01)
    Flags: bus master, 66MHz, medium devsel, latency 64
    Bus: primary=00, secondary=1d, subordinate=21, sec-latency=64
    I/O behind bridge: 00002000-00002fff
    Memory behind bridge: f8600000-f86fffff
    Prefetchable memory behind bridge: 20000000-23ffffff

00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
    Flags: fast devsel
    Capabilities: 

00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
    Flags: fast devsel

00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
    Flags: fast devsel

00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
    Flags: fast devsel
    Capabilities: 
    Kernel driver in use: k8temp
    Kernel modules: k8temp

01:05.0 VGA compatible controller [0300]: ATI Technologies Inc RS690M [Radeon X1200 Series] [1002:791f]
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, fast devsel, latency 64, IRQ 18
    Memory at f0000000 (64-bit, prefetchable) [size=128M]
    Memory at f8300000 (64-bit, non-prefetchable) [size=64K]
    I/O ports at 9000 [size=256]
    Memory at f8200000 (32-bit, non-prefetchable) [size=1M]
    Capabilities: 

0b:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
    Subsystem: Hauppauge computer works Inc. Device [0070:7717]
    Flags: bus master, fast devsel, latency 0, IRQ 17
    Memory at f8000000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: 
    Kernel driver in use: cx23885
    Kernel modules: cx23885

11:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller [10ec:8136] (rev 01)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, fast devsel, latency 0, IRQ 2300
    I/O ports at a000 [size=256]
    Memory at f8500000 (64-bit, non-prefetchable) [size=4K]
    [virtual] Expansion ROM at f8700000 [disabled] [size=128K]
    Capabilities: 
    Kernel driver in use: r8169
    Kernel modules: r8169

17:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
    Subsystem: Askey Computer Corp. Device [144f:7128]
    Flags: bus master, fast devsel, latency 0, IRQ 19
    Memory at f8400000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: 
    Kernel driver in use: ndiswrapper
    Kernel modules: ath_pci

1d:04.0 CardBus bridge [0607]: Texas Instruments PCIxx12 Cardbus Controller [104c:8039]
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, medium devsel, latency 168, IRQ 20
    Memory at f8604000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=1d, secondary=1e, subordinate=21, sec-latency=176
    Memory window 0: 20000000-23fff000 (prefetchable)
    Memory window 1: 24000000-27fff000
    I/O window 0: 00002000-000020ff
    I/O window 1: 00002400-000024ff
    16-bit legacy interface ports at 0001
    Kernel driver in use: yenta_cardbus
    Kernel modules: yenta_socket

1d:04.1 FireWire (IEEE 1394) [0c00]: Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller [104c:803a] (prog-if 10)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, medium devsel, latency 64, IRQ 21
    Memory at f8606000 (32-bit, non-prefetchable) [size=2K]
    Memory at f8600000 (32-bit, non-prefetchable) [size=16K]
    Capabilities: 
    Kernel driver in use: ohci1394
    Kernel modules: ohci1394

1d:04.2 Mass storage controller [0180]: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD) [104c:803b]
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, medium devsel, latency 64, IRQ 22
    Memory at f8605000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: 
    Kernel driver in use: tifm_7xx1
    Kernel modules: tifm_7xx1

1d:04.3 SD Host controller [0805]: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller [104c:803c] (prog-if 01)
    Subsystem: Toshiba America Info Systems Device [1179:ff00]
    Flags: bus master, medium devsel, latency 64, IRQ 22
    Memory at f8606800 (32-bit, non-prefetchable) [size=256]
    Capabilities: 
    Kernel driver in use: sdhci-pci
    Kernel modules: sdhci-pci


dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.27-14-generic (buildd@yellow) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #1 SMP Fri Mar 13 19:54:51 UTC 2009 (Ubuntu 2.6.27-14.30-generic)
[    0.000000] Command line: root=UUID=8d821240-ec00-40c1-bd73-cebd72066c6d ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000d7e70000 (usable)
[    0.000000]  BIOS-e820: 00000000d7e70000 - 00000000d7e83000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d7e83000 - 00000000d7e85000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d7e85000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xd7e70 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00d7e00000 page 2M
[    0.000000]  00d7e00000 - 00d7e70000 page 4k
[    0.000000] kernel direct mapping tables up to d7e70000 @ 8000-e000
[    0.000000] last_map_addr: d7e70000 end: d7e70000
[    0.000000] init_memory_mapping
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ c000-12000
[    0.000000] last_map_addr: 120000000 end: 120000000
[    0.000000] RAMDISK: 377a7000 - 37feff51
[    0.000000] ACPI: RSDP 000F7260, 0024 (r2 TOSCPL)
[    0.000000] ACPI: XSDT D7E7AA18, 0064 (r1 TOSCPL TOSCPL00  6040000  LTP        0)
[    0.000000] ACPI: FACP D7E828F7, 00F4 (r3 TOSCPL Herring   6040000 ATI     F4240)
[    0.000000] ACPI: DSDT D7E7AA7C, 7E7B (r1 TOSCPL    SB600  6040000 MSFT  3000000)
[    0.000000] ACPI: FACS D7E84FC0, 0040
[    0.000000] ACPI: TCPA D7E82A5F, 0032 (r2 TOSCPL           6040000 PTEC        0)
[    0.000000] ACPI: SLIC D7E82A91, 0176 (r1 TOSCPL TOSCPL00  6040000 LOHR        0)
[    0.000000] ACPI: SSDT D7E82C07, 0206 (r1 PTLTD  POWERNOW  6040000  LTP        1)
[    0.000000] ACPI: APIC D7E82E0D, 0054 (r1 PTLTD       APIC    6040000  LTP        0)
[    0.000000] ACPI: MCFG D7E82E61, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
[    0.000000] ACPI: HPET D7E82E9D, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
[    0.000000] ACPI: ASF! D7E82ED5, 012B (r32    DMA AMDTBL    6040000 PTL         1)
[    0.000000] ACPI: DMI detected: Toshiba
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
[    0.000000]   bootmap [000000000000d000 -  0000000000030fff] pages 24
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00008bbf5c]    TEXT DATA BSS ==> [0000200000 - 00008bbf5c]
[    0.000000]   #3 [00377a7000 - 0037feff51]          RAMDISK ==> [00377a7000 - 0037feff51]
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #6 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
[    0.000000] found SMP MP-table at [ffff8800000f7300] 000f7300
[    0.000000]  [ffffe20000000000-ffffe200047fffff] PMD -> [ffff880028200000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000d7e70
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1015309
[    0.000000]   DMA zone: 2102 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 863920 pages, LIFO batch:31
[    0.000000]   Normal zone: 129024 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x43538310 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000d7e70000 - 00000000d7e83000
[    0.000000] PM: Registered nosave memory: 00000000d7e83000 - 00000000d7e85000
[    0.000000] PM: Registered nosave memory: 00000000d7e85000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
[    0.000000] PERCPU: Allocating 64928 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 995046
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=8d821240-ec00-40c1-bd73-cebd72066c6d ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PMTIMER calibration value
[    0.000000] Detected 1895.242 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 264000000 size 32 MB
[    0.004000] Aperture beyond 4GB. Ignoring.
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.004000] Memory: 3916456k/4718592k available (3119k kernel code, 144780k reserved, 1577k data, 540k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004009] Calibrating delay loop (skipped), value calculated using timer frequency.. 3790.48 BogoMIPS (lpj=7580968)
[    0.004039] Security Framework initialized
[    0.004046] SELinux:  Disabled at boot.
[    0.004062] AppArmor: AppArmor initialized
[    0.004478] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.007476] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008765] Mount-cache hash table entries: 256
[    0.008970] Initializing cgroup subsys ns
[    0.008975] Initializing cgroup subsys cpuacct
[    0.008977] Initializing cgroup subsys memory
[    0.008995] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.008997] CPU: L2 Cache: 512K (64 bytes/line)
[    0.009000] CPU 0/0 -> Node 0
[    0.009002] tseg: 00d7f00000
[    0.009003] CPU: Physical Processor ID: 0
[    0.009005] CPU: Processor Core ID: 0
[    0.009016] using C1E aware idle routine
[    0.010508] ACPI: Core revision 20080609
[    0.013485] ACPI: Checking initramfs for custom DSDT
[    0.412470] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.416026] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.416026] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.416026] ..... (found apic 0 pin 0) ...
[    0.459113] ....... works.
[    0.459115] CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02
[    0.459120] Using local APIC timer interrupts.
[    0.460030] APIC timer calibration result 12468701
[    0.460032] Detected 12.468 MHz APIC timer.
[    0.460218] Booting processor 1/1 ip 6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 3790.53 BogoMIPS (lpj=7581060)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] System has AMD C1E enabled
[    0.004000] Switch to broadcast mode on CPU1
[    0.548294] CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02
[    0.548309] Brought up 2 CPUs
[    0.548312] Total of 2 processors activated (7581.01 BogoMIPS).
[    0.548360] CPU0 attaching sched-domain:
[    0.548363]  domain 0: span 0-1 level CPU
[    0.548366]   groups: 0 1
[    0.548370]   domain 1: span 0-1 level NODE
[    0.548372]    groups: 0-1
[    0.548377] CPU1 attaching sched-domain:
[    0.548379]  domain 0: span 0-1 level CPU
[    0.548381]   groups: 1 0
[    0.548384]   domain 1: span 0-1 level NODE
[    0.548386]    groups: 0-1
[    0.548493] Switch to broadcast mode on CPU0
[    0.548493] net_namespace: 1552 bytes
[    0.548493] Booting paravirtualized kernel on bare hardware
[    0.548493] Time: 23:13:12  Date: 04/20/09
[    0.548493] NET: Registered protocol family 16
[    0.548493] node 0 link 0: io port [1000, fffff]
[    0.548493] TOM: 00000000e0000000 aka 3584M
[    0.548493] node 0 link 0: mmio [f8300000, ffffffff]
[    0.548493] node 0 link 0: mmio [f8200000, f82fffff]
[    0.548493] node 0 link 0: mmio [f8000000, f81fffff]
[    0.548493] node 0 link 0: mmio [f0000000, f7ffffff]
[    0.548493] node 0 link 0: mmio [a0000, bffff]
[    0.548493] node 0 link 0: mmio [f0000000, efffffff]
[    0.548493] node 0 link 0: mmio [e0000000, efffffff]
[    0.548493] node 0 link 0: mmio [e0000000, dfffffff]
[    0.548493] TOM2: 0000000120000000 aka 4608M
[    0.548493] bus: [00,ff] on node 0 link 0
[    0.548493] bus: 00 index 0 io port: [0, ffff]
[    0.548493] bus: 00 index 1 mmio: [e0000000, ffffffff]
[    0.548493] bus: 00 index 2 mmio: [a0000, bffff]
[    0.548493] bus: 00 index 3 mmio: [120000000, fcffffffff]
[    0.548493] ACPI: bus type pci registered
[    0.548493] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 29
[    0.548493] PCI: MCFG area at e0000000 reserved in E820
[    0.549734] PCI: Using MMCONFIG at e0000000 - e1dfffff
[    0.549736] PCI: Using configuration type 1 for base access
[    0.553392] ACPI: EC: Look up EC in DSDT
[    0.556579] ACPI Error (evregion-0315): No handler for Region [ERAM] (ffff88011fa37d80) [EmbeddedControl] [20080609]
[    0.556586] ACPI Error (exfldio-0291): Region EmbeddedControl(3) has no handler [20080609]
[    0.556592] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.HTEV] (Node ffff88011fa355c0), AE_NOT_EXIST
[    0.556638] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.LPC0.EC0_._REG] (Node ffff88011fa3d960), AE_NOT_EXIST
[    0.559370] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.560695] ACPI: Interpreter enabled
[    0.560698] ACPI: (supports S0 S3 S4 S5)
[    0.560716] ACPI: Using IOAPIC for interrupt routing
[    0.564063] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.640577] ACPI: EC: GPE = 0x13, I/O: command/status = 0x66, data = 0x62
[    0.640577] ACPI: EC: driver started in interrupt mode
[    0.640577] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.640577] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.640577] pci 0000:00:05.0: PME# disabled
[    0.640577] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.640577] pci 0000:00:06.0: PME# disabled
[    0.640577] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.640577] pci 0000:00:07.0: PME# disabled
[    0.640577] PCI: 0000:00:12.0 reg 10 io port: [8440, 8447]
[    0.640577] PCI: 0000:00:12.0 reg 14 io port: [8434, 8437]
[    0.640577] PCI: 0000:00:12.0 reg 18 io port: [8438, 843f]
[    0.640577] PCI: 0000:00:12.0 reg 1c io port: [8430, 8433]
[    0.640577] PCI: 0000:00:12.0 reg 20 io port: [8400, 840f]
[    0.640577] PCI: 0000:00:12.0 reg 24 32bit mmio: [f8909000, f89093ff]
[    0.640577] pci 0000:00:12.0: set SATA to AHCI mode
[    0.640577] PCI: 0000:00:13.0 reg 10 32bit mmio: [f8904000, f8904fff]
[    0.640577] PCI: 0000:00:13.1 reg 10 32bit mmio: [f8905000, f8905fff]
[    0.640577] PCI: 0000:00:13.2 reg 10 32bit mmio: [f8906000, f8906fff]
[    0.640577] PCI: 0000:00:13.3 reg 10 32bit mmio: [f8907000, f8907fff]
[    0.640577] PCI: 0000:00:13.4 reg 10 32bit mmio: [f8908000, f8908fff]
[    0.640654] PCI: 0000:00:13.5 reg 10 32bit mmio: [f8909400, f89094ff]
[    0.640717] pci 0000:00:13.5: supports D1
[    0.640719] pci 0000:00:13.5: supports D2
[    0.640721] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.640725] pci 0000:00:13.5: PME# disabled
[    0.640757] PCI: 0000:00:14.0 reg 10 io port: [8410, 841f]
[    0.640828] PCI: 0000:00:14.1 reg 10 io port: [1f0, 1f7]
[    0.640835] PCI: 0000:00:14.1 reg 14 io port: [3f4, 3f7]
[    0.640842] PCI: 0000:00:14.1 reg 18 io port: [0, 7]
[    0.640849] PCI: 0000:00:14.1 reg 1c io port: [0, 3]
[    0.640857] PCI: 0000:00:14.1 reg 20 io port: [8420, 842f]
[    0.640912] PCI: 0000:00:14.2 reg 10 64bit mmio: [f8900000, f8903fff]
[    0.640964] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.640968] pci 0000:00:14.2: PME# disabled
[    0.641158] PCI: 0000:01:05.0 reg 10 64bit mmio: [f0000000, f7ffffff]
[    0.641164] PCI: 0000:01:05.0 reg 18 64bit mmio: [f8300000, f830ffff]
[    0.641168] PCI: 0000:01:05.0 reg 20 io port: [9000, 90ff]
[    0.641172] PCI: 0000:01:05.0 reg 24 32bit mmio: [f8200000, f82fffff]
[    0.641186] pci 0000:01:05.0: supports D1
[    0.641188] pci 0000:01:05.0: supports D2
[    0.641203] PCI: bridge 0000:00:01.0 io port: [9000, 9fff]
[    0.641206] PCI: bridge 0000:00:01.0 32bit mmio: [f8200000, f83fffff]
[    0.641210] PCI: bridge 0000:00:01.0 64bit mmio pref: [f0000000, f7ffffff]
[    0.641262] PCI: 0000:0b:00.0 reg 10 64bit mmio: [f8000000, f81fffff]
[    0.641366] pci 0000:0b:00.0: supports D1
[    0.641367] pci 0000:0b:00.0: supports D2
[    0.641369] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot
[    0.641375] pci 0000:0b:00.0: PME# disabled
[    0.641422] PCI: bridge 0000:00:05.0 32bit mmio: [f8000000, f81fffff]
[    0.641470] PCI: 0000:11:00.0 reg 10 io port: [a000, a0ff]
[    0.641488] PCI: 0000:11:00.0 reg 18 64bit mmio: [f8500000, f8500fff]
[    0.641506] PCI: 0000:11:00.0 reg 30 32bit mmio: [0, 1ffff]
[    0.641552] pci 0000:11:00.0: supports D1
[    0.641554] pci 0000:11:00.0: supports D2
[    0.641556] pci 0000:11:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.641561] pci 0000:11:00.0: PME# disabled
[    0.641607] PCI: bridge 0000:00:06.0 io port: [a000, afff]
[    0.641610] PCI: bridge 0000:00:06.0 32bit mmio: [f8500000, f85fffff]
[    0.641652] PCI: 0000:17:00.0 reg 10 64bit mmio: [f8400000, f840ffff]
[    0.641762] PCI: bridge 0000:00:07.0 32bit mmio: [f8400000, f84fffff]
[    0.641816] PCI: 0000:1d:04.0 reg 10 32bit mmio: [f8604000, f8604fff]
[    0.641850] pci 0000:1d:04.0: supports D1
[    0.641851] pci 0000:1d:04.0: supports D2
[    0.641853] pci 0000:1d:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.641859] pci 0000:1d:04.0: PME# disabled
[    0.641899] PCI: 0000:1d:04.1 reg 10 32bit mmio: [f8606000, f86067ff]
[    0.641908] PCI: 0000:1d:04.1 reg 14 32bit mmio: [f8600000, f8603fff]
[    0.641977] pci 0000:1d:04.1: supports D1
[    0.641978] pci 0000:1d:04.1: supports D2
[    0.641980] pci 0000:1d:04.1: PME# supported from D0 D1 D2 D3hot
[    0.641986] pci 0000:1d:04.1: PME# disabled
[    0.642025] PCI: 0000:1d:04.2 reg 10 32bit mmio: [f8605000, f8605fff]
[    0.642097] pci 0000:1d:04.2: supports D1
[    0.642099] pci 0000:1d:04.2: supports D2
[    0.642100] pci 0000:1d:04.2: PME# supported from D0 D1 D2 D3hot
[    0.642106] pci 0000:1d:04.2: PME# disabled
[    0.642145] PCI: 0000:1d:04.3 reg 10 32bit mmio: [f8606800, f86068ff]
[    0.642217] pci 0000:1d:04.3: supports D1
[    0.642219] pci 0000:1d:04.3: supports D2
[    0.642221] pci 0000:1d:04.3: PME# supported from D0 D1 D2 D3hot
[    0.642226] pci 0000:1d:04.3: PME# disabled
[    0.642279] pci 0000:00:14.4: transparent bridge
[    0.642286] PCI: bridge 0000:00:14.4 32bit mmio: [f8600000, f86fffff]
[    0.642332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.642628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    0.642628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.642628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB7_._PRT]
[    0.642628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BB5_._PRT]
[    0.642628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.642628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.652202] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
[    0.652389] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
[    0.652573] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
[    0.652756] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
[    0.652938] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
[    0.653120] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
[    0.653302] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
[    0.653486] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
[    0.653581] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.653581] pnp: PnP ACPI init
[    0.653581] ACPI: bus type pnp registered
[    0.684249] pnp: PnP ACPI: found 11 devices
[    0.684252] ACPI: ACPI bus type pnp unregistered
[    0.688068] PCI: Using ACPI for IRQ routing
[    0.696042] NET: Registered protocol family 8
[    0.696045] NET: Registered protocol family 20
[    0.700041] NetLabel: Initializing
[    0.700041] NetLabel:  domain hash size = 128
[    0.700041] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.700058] NetLabel:  unlabeled traffic allowed by default
[    0.700191] PCI-DMA: Disabling AGP.
[    0.700343] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.700343] PCI-DMA: using GART IOMMU.
[    0.700343] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.700714] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.700721] hpet0: 4 32-bit timers, 14318180 Hz
[    0.703074] tracer: 1286 pages allocated for 65536 entries of 80 bytes
[    0.703077]    actual entries 65586
[    0.703208] AppArmor: AppArmor Filesystem Enabled
[    0.703239] ACPI: RTC can wake from S4
[    0.704052] Switched to high resolution mode on CPU 0
[    0.704066] Switched to high resolution mode on CPU 1
[    0.713056] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.713059] system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.713073] system 00:08: ioport range 0x1080-0x1080 has been reserved
[    0.713076] system 00:08: ioport range 0x220-0x22f has been reserved
[    0.713079] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.713082] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.713085] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.713088] system 00:08: ioport range 0x530-0x537 has been reserved
[    0.713091] system 00:08: ioport range 0xc00-0xc01 has been reserved
[    0.713094] system 00:08: ioport range 0xc14-0xc14 has been reserved
[    0.713097] system 00:08: ioport range 0xc50-0xc52 has been reserved
[    0.713100] system 00:08: ioport range 0xc6c-0xc6c has been reserved
[    0.713103] system 00:08: ioport range 0xc6f-0xc6f has been reserved
[    0.713106] system 00:08: ioport range 0xcd0-0xcd1 has been reserved
[    0.713109] system 00:08: ioport range 0xcd2-0xcd3 has been reserved
[    0.713112] system 00:08: ioport range 0xcd4-0xcd5 has been reserved
[    0.713116] system 00:08: ioport range 0xcd6-0xcd7 has been reserved
[    0.713119] system 00:08: ioport range 0xcd8-0xcdf has been reserved
[    0.713122] system 00:08: ioport range 0x8000-0x805f has been reserved
[    0.713125] system 00:08: ioport range 0xf40-0xf47 has been reserved
[    0.713128] system 00:08: ioport range 0x87f-0x87f has been reserved
[    0.713131] system 00:08: ioport range 0xfd60-0xfddf has been reserved
[    0.713139] system 00:09: iomem range 0xe0000-0xfffff could not be reserved
[    0.713143] system 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.718583] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.718586] pci 0000:00:01.0:   IO window: 0x9000-0x9fff
[    0.718590] pci 0000:00:01.0:   MEM window: 0xf8200000-0xf83fffff
[    0.718594] pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
[    0.718599] pci 0000:00:05.0: PCI bridge, secondary bus 0000:0b
[    0.718601] pci 0000:00:05.0:   IO window: disabled
[    0.718604] pci 0000:00:05.0:   MEM window: 0xf8000000-0xf81fffff
[    0.718607] pci 0000:00:05.0:   PREFETCH window: disabled
[    0.718612] pci 0000:00:06.0: PCI bridge, secondary bus 0000:11
[    0.718615] pci 0000:00:06.0:   IO window: 0xa000-0xafff
[    0.718619] pci 0000:00:06.0:   MEM window: 0xf8500000-0xf85fffff
[    0.718622] pci 0000:00:06.0:   PREFETCH window: 0x000000f8700000-0x000000f87fffff
[    0.718627] pci 0000:00:07.0: PCI bridge, secondary bus 0000:17
[    0.718629] pci 0000:00:07.0:   IO window: disabled
[    0.718632] pci 0000:00:07.0:   MEM window: 0xf8400000-0xf84fffff
[    0.718635] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.718642] pci 0000:1d:04.0: CardBus bridge, secondary bus 0000:1e
[    0.718645] pci 0000:1d:04.0:   IO window: 0x002000-0x0020ff
[    0.718653] pci 0000:1d:04.0:   IO window: 0x002400-0x0024ff
[    0.718659] pci 0000:1d:04.0:   PREFETCH window: 0x120000000-0x123ffffff
[    0.718665] pci 0000:1d:04.0:   MEM window: 0x124000000-0x127ffffff
[    0.718670] pci 0000:00:14.4: PCI bridge, secondary bus 0000:1d
[    0.718674] pci 0000:00:14.4:   IO window: 0x2000-0x2fff
[    0.718680] pci 0000:00:14.4:   MEM window: 0xf8600000-0xf86fffff
[    0.718685] pci 0000:00:14.4:   PREFETCH window: 0x00000120000000-0x00000123ffffff
[    0.718704] pci 0000:00:05.0: setting latency timer to 64
[    0.718710] pci 0000:00:06.0: setting latency timer to 64
[    0.718716] pci 0000:00:07.0: setting latency timer to 64
[    0.718738] pci 0000:1d:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.718745] bus: 00 index 0 io port: [0, ffff]
[    0.718747] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.718749] bus: 01 index 0 io port: [9000, 9fff]
[    0.718752] bus: 01 index 1 mmio: [f8200000, f83fffff]
[    0.718754] bus: 01 index 2 mmio: [f0000000, f7ffffff]
[    0.718757] bus: 01 index 3 mmio: [0, 0]
[    0.718759] bus: 0b index 0 mmio: [0, 0]
[    0.718761] bus: 0b index 1 mmio: [f8000000, f81fffff]
[    0.718763] bus: 0b index 2 mmio: [0, 0]
[    0.718765] bus: 0b index 3 mmio: [0, 0]
[    0.718767] bus: 11 index 0 io port: [a000, afff]
[    0.718769] bus: 11 index 1 mmio: [f8500000, f85fffff]
[    0.718772] bus: 11 index 2 mmio: [f8700000, f87fffff]
[    0.718774] bus: 11 index 3 mmio: [0, 0]
[    0.718776] bus: 17 index 0 mmio: [0, 0]
[    0.718778] bus: 17 index 1 mmio: [f8400000, f84fffff]
[    0.718780] bus: 17 index 2 mmio: [0, 0]
[    0.718782] bus: 17 index 3 mmio: [0, 0]
[    0.718784] bus: 1d index 0 io port: [2000, 2fff]
[    0.718787] bus: 1d index 1 mmio: [f8600000, f86fffff]
[    0.718789] bus: 1d index 2 mmio: [120000000, 123ffffff]
[    0.718791] bus: 1d index 3 io port: [0, ffff]
[    0.718793] bus: 1d index 4 mmio: [0, ffffffffffffffff]
[    0.718796] bus: 1e index 0 io port: [2000, 20ff]
[    0.718798] bus: 1e index 1 io port: [2400, 24ff]
[    0.718800] bus: 1e index 2 mmio: [120000000, 123ffffff]
[    0.718803] bus: 1e index 3 mmio: [124000000, 127ffffff]
[    0.718818] NET: Registered protocol family 2
[    0.757198] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.758805] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.763575] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.764196] TCP: Hash tables configured (established 524288 bind 65536)
[    0.764199] TCP reno registered
[    0.773130] NET: Registered protocol family 1
[    0.773268] checking if image is initramfs... it is
[    1.543436] Freeing initrd memory: 8483k freed
[    1.550304] audit: initializing netlink socket (disabled)
[    1.550319] type=2000 audit(1240269191.548:1): initialized
[    1.556745] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.560636] VFS: Disk quotas dquot_6.5.1
[    1.560764] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.560912] msgmni has been set to 7665
[    1.561078] io scheduler noop registered
[    1.561081] io scheduler anticipatory registered
[    1.561083] io scheduler deadline registered
[    1.561275] io scheduler cfq registered (default)
[    1.561386] pci 0000:01:05.0: Boot video device
[    1.561555] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    1.561576] pcieport-driver 0000:00:05.0: found MSI capability
[    1.561601] pci_express 0000:00:05.0:pcie00: allocate port service
[    1.561682] pci_express 0000:00:05.0:pcie02: allocate port service
[    1.561751] pci_express 0000:00:05.0:pcie03: allocate port service
[    1.561856] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    1.561877] pcieport-driver 0000:00:06.0: found MSI capability
[    1.561897] pci_express 0000:00:06.0:pcie00: allocate port service
[    1.561969] pci_express 0000:00:06.0:pcie03: allocate port service
[    1.562074] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    1.562094] pcieport-driver 0000:00:07.0: found MSI capability
[    1.562114] pci_express 0000:00:07.0:pcie00: allocate port service
[    1.562186] pci_express 0000:00:07.0:pcie03: allocate port service
[    1.618691] hpet_resources: 0xfed00000 is busy
[    1.618808] Linux agpgart interface v0.103
[    1.618813] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.622529] brd: module loaded
[    1.622638] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    1.622833] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    1.658528] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.658538] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.673194] mice: PS/2 mouse device common for all mice
[    1.673378] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.673406] rtc0: alarms up to one month, hpet irqs
[    1.673465] cpuidle: using governor ladder
[    1.673468] cpuidle: using governor menu
[    1.673888] TCP cubic registered
[    1.674198] registered taskstats version 1
[    1.674371]   Magic number: 5:100:252
[    1.674403] tty ttyw8: hash matches
[    1.674411] tty ttytb: hash matches
[    1.674537] rtc_cmos 00:04: setting system clock to 2009-04-20 23:13:13 UTC (1240269193)
[    1.674541] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.674543] EDD information not available.
[    1.674597] Freeing unused kernel memory: 540k freed
[    1.674875] Write protecting the kernel read-only data: 4356k
[    1.696081] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.892212] fuse init (API version 7.9)
[    2.008019] ACPI: processor limited to max C-state 1
[    2.008125] processor ACPI0007:00: registered as cooling_device0
[    2.008131] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.008241] processor ACPI0007:01: registered as cooling_device1
[    2.395488] usbcore: registered new interface driver usbfs
[    2.395519] usbcore: registered new interface driver hub
[    2.404241] usbcore: registered new device driver usb
[    2.404418] No dock devices found.
[    2.407277] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.407294] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    2.407353] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    2.407397] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[    2.407417] ehci_hcd 0000:00:13.5: debug port 1
[    2.407440] ehci_hcd 0000:00:13.5: irq 19, io mem 0xf8909400
[    2.416034] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.416210] usb usb1: configuration #1 chosen from 1 choice
[    2.416239] hub 1-0:1.0: USB hub found
[    2.416250] hub 1-0:1.0: 10 ports detected
[    2.425638] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.443426] SCSI subsystem initialized
[    2.491863] libata version 3.00 loaded.
[    2.520389] ahci 0000:00:12.0: version 3.0
[    2.520416] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.520447] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    2.520545] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.520549] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pmp pio slum part 
[    2.520929] scsi0 : ahci
[    2.521070] scsi1 : ahci
[    2.521138] scsi2 : ahci
[    2.521211] scsi3 : ahci
[    2.521353] ata1: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909100 irq 22
[    2.521357] ata2: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909180 irq 22
[    2.521361] ata3: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909200 irq 22
[    2.521365] ata4: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909280 irq 22
[    3.228042] ata1: softreset failed (device not ready)
[    3.228049] ata1: failed due to HW bug, retry pmp=0
[    3.392051] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.763590] ata1.00: ATA-8: TOSHIBA MK1646GSX, LB113M, max UDMA/100
[    3.763595] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.763606] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    3.764443] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    3.764447] ata1.00: configured for UDMA/100
[    4.100055] ata2: SATA link down (SStatus 0 SControl 300)
[    4.436051] ata3: SATA link down (SStatus 0 SControl 300)
[    4.772050] ata4: SATA link down (SStatus 0 SControl 300)
[    4.788152] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5
[    4.788298] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.788317] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    4.788351] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    4.788391] ohci_hcd 0000:00:13.0: irq 16, io mem 0xf8904000
[    4.844205] usb usb2: configuration #1 chosen from 1 choice
[    4.844235] hub 2-0:1.0: USB hub found
[    4.844251] hub 2-0:1.0: 2 ports detected
[    4.948311] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.948329] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    4.948361] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    4.948391] ohci_hcd 0000:00:13.1: irq 17, io mem 0xf8905000
[    5.004212] usb usb3: configuration #1 chosen from 1 choice
[    5.004245] hub 3-0:1.0: USB hub found
[    5.004262] hub 3-0:1.0: 2 ports detected
[    5.108292] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.108311] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    5.108343] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    5.108372] ohci_hcd 0000:00:13.2: irq 18, io mem 0xf8906000
[    5.164176] usb usb4: configuration #1 chosen from 1 choice
[    5.164212] hub 4-0:1.0: USB hub found
[    5.164228] hub 4-0:1.0: 2 ports detected
[    5.271461] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.271483] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    5.271533] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    5.271558] ohci_hcd 0000:00:13.3: irq 17, io mem 0xf8907000
[    5.324218] usb usb5: configuration #1 chosen from 1 choice
[    5.324258] hub 5-0:1.0: USB hub found
[    5.324275] hub 5-0:1.0: 2 ports detected
[    5.428259] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.428276] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    5.428306] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    5.428326] ohci_hcd 0000:00:13.4: irq 18, io mem 0xf8908000
[    5.484185] usb usb6: configuration #1 chosen from 1 choice
[    5.484222] hub 6-0:1.0: USB hub found
[    5.484239] hub 6-0:1.0: 2 ports detected
[    5.589673] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.589693] r8169 0000:11:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.589713] r8169 0000:11:00.0: setting latency timer to 64
[    5.590095] eth0: RTL8101e at 0xffffc20000652000, 00:1e:ec:00:9e:6a, XID 34200000 IRQ 2300
[    5.594240] ohci1394 0000:1d:04.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.644045] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[f8606000-f86067ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    5.644538] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    5.650273] pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.650326] pata_acpi 0000:00:14.1: setting latency timer to 64
[    5.653700] scsi4 : pata_atiixp
[    5.653802] scsi5 : pata_atiixp
[    5.654956] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8420 irq 14
[    5.654959] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8428 irq 15
[    5.680414] Driver 'sd' needs updating - please use bus_type methods
[    5.680561] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    5.680579] sd 0:0:0:0: [sda] Write Protect is off
[    5.680583] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.680611] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.680696] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    5.680711] sd 0:0:0:0: [sda] Write Protect is off
[    5.680714] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.680741] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.680745]  sda: sda1 sda2 sda3 sda4 <ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WT03, max UDMA/33
[    5.829860]  sda5ata5.00: configured for UDMA/33
[    5.844764]  sda6>
[    5.845051] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.991247] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WT03 PQ: 0 ANSI: 5
[    5.991441] scsi 4:0:0:0: Attached scsi generic sg1 type 5
[    6.012734] Driver 'sr' needs updating - please use bus_type methods
[    6.016750] sr0: scsi3-mmc drive: 31x/31x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.016756] Uniform CD-ROM driver Revision: 3.20
[    6.016894] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    6.401580] PM: Starting manual resume from disk
[    6.401585] PM: Resume from partition 8:5
[    6.401587] PM: Checking hibernation image.
[    6.401744] PM: Resume from disk failed.
[    6.421888] EXT3-fs: INFO: recovery required on readonly filesystem.
[    6.421892] EXT3-fs: write access will be enabled during recovery.
[    6.921354] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f81c2404ccc]
[    8.577603] kjournald starting.  Commit interval 5 seconds
[    8.577637] EXT3-fs: sda3: orphan cleanup on readonly fs
[    8.577647] ext3_orphan_cleanup: deleting unreferenced inode 444179
[    8.577687] ext3_orphan_cleanup: deleting unreferenced inode 439784
[    8.577698] ext3_orphan_cleanup: deleting unreferenced inode 439783
[    8.577707] ext3_orphan_cleanup: deleting unreferenced inode 439782
[    8.577717] ext3_orphan_cleanup: deleting unreferenced inode 439781
[    8.577739] ext3_orphan_cleanup: deleting unreferenced inode 439780
[    8.577747] EXT3-fs: sda3: 6 orphan inodes deleted
[    8.577749] EXT3-fs: recovery complete.
[    8.580585] EXT3-fs: mounted filesystem with ordered data mode.
[   14.681501] udevd version 124 started
[   14.986120] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   14.989378] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   15.033399] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   15.065040] ACPI: Power Button (FF) [PWRF]
[   15.065192] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
[   15.065299] ACPI: Lid Switch [LID]
[   15.065377] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[   15.097034] ACPI: Power Button (CM) [PWRB]
[   15.275966] ACPI: AC Adapter [ACAD] (off-line)
[   15.387726] acpi device:29: registered as cooling_device2
[   15.388040] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:26/device:27/input/input5
[   15.405058] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[   15.702114] ACPI: Battery Slot [BAT1] (battery present)
[   15.845326] ndiswrapper version 1.53 loaded (smp=yes, preempt=no)
[   16.360880] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   16.472872] ndiswrapper (link_pe_images:575): fixing KI_USER_SHARED_DATA address in the driver
[   16.475401] ndiswrapper: driver net5211 (,06/21/2007,5.3.0.56) loaded
[   16.475911] ndiswrapper 0000:17:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   16.475972] ndiswrapper (ZwClose:2198): closing handle 0x0 not implemented
[   16.476216] ndiswrapper 0000:17:00.0: setting latency timer to 64
[   16.889164] ndiswrapper: using IRQ 19
[   17.076016] sdhci: Secure Digital Host Controller Interface driver
[   17.076020] sdhci: Copyright(c) Pierre Ossman
[   17.092683] wlan0: ethernet device 00:1b:9e:95:c8:cd using serialized NDIS driver: net5211, version: 0x50003, NDIS version: 0x501, vendor: 'NDIS Network Adapter', 168C:001C.5.conf
[   17.097167] wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK; AES/CCMP with WPA, WPA2, WPA2PSK
[   17.099640] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8410, revision 0
[   17.107736] tifm_7xx1 0000:1d:04.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   17.107904] usbcore: registered new interface driver ndiswrapper
[   17.110786] sdhci-pci 0000:1d:04.3: SDHCI controller found [104c:803c] (rev 0)
[   17.110808] sdhci-pci 0000:1d:04.3: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   17.110946] mmc0: SDHCI controller on PCI [0000:1d:04.3] using DMA
[   17.271489] Linux video capture interface: v2.00
[   17.311607] Yenta: CardBus bridge found at 0000:1d:04.0 [1179:ff00]
[   17.311634] Yenta: Enabling burst memory read transactions
[   17.311640] Yenta: Using CSCINT to route CSC interrupts to PCI
[   17.311642] Yenta: Routing CardBus interrupts to PCI
[   17.311648] Yenta TI: socket 0000:1d:04.0, mfunc 0x10a01b22, devctl 0x64
[   17.358239] cx23885 driver version 0.0.1 loaded
[   17.542187] Yenta: ISA IRQ mask 0x0cf8, PCI irq 20
[   17.542196] Socket status: 30000006
[   17.542199] Yenta: Raising subordinate bus# of parent bus (#1d) from #1e to #21
[   17.542205] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   17.542232] pcmcia: parent PCI bridge Memory window: 0xf8600000 - 0xf86fffff
[   17.542235] pcmcia: parent PCI bridge Memory window: 0x120000000 - 0x123ffffff
[   17.542719] cx23885 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   17.542853] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge WinTV-HVR1500 [card=6,autodetected]
[   17.661614] cx23885[0]: i2c bus 0 registered
[   17.661660] cx23885[0]: i2c bus 1 registered
[   17.661694] cx23885[0]: i2c bus 2 registered
[   17.689053] tveeprom 1-0050: Hauppauge model 77001, rev D4C0, serial# 2396878
[   17.689057] tveeprom 1-0050: MAC address is 00-0D-FE-24-92-CE
[   17.689060] tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[   17.689063] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
[   17.689066] tveeprom 1-0050: audio processor is CX23885 (idx 39)
[   17.689068] tveeprom 1-0050: decoder processor is CX23885 (idx 33)
[   17.689071] tveeprom 1-0050: has no radio
[   17.689073] cx23885[0]: hauppauge eeprom: model=77001
[   17.689076] cx23885[0]: cx23885 based dvb card
[   17.918553] xc2028 2-0061: creating new instance
[   17.918558] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   17.918565] DVB: registering new adapter (cx23885[0])
[   17.918569] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[   17.919872] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   17.919882] cx23885[0]/0: found at 0000:0b:00.0, rev: 2, irq: 17, latency: 0, mmio: 0xf8000000
[   17.919894] cx23885 0000:0b:00.0: setting latency timer to 64
[   17.919963] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.956401] hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...
[   18.075253] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x9280b1, caps: 0xa04713/0x204000
[   18.166061] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   19.730909] lp: driver loaded but no devices found
[   19.933960] Adding 578300k swap on /dev/sda5.  Priority:-1 extents:1 across:578300k
[   19.940008] APIC error on CPU1: 00(40)
[   19.940022] APIC error on CPU0: 00(40)
[   19.977189] EXT3 FS on sda3, internal journal
[   20.397865] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   20.406405] SGI XFS Quota Management subsystem
[   20.461046] XFS mounting filesystem sda6
[   20.649173] Starting XFS recovery on filesystem: sda6 (logdev: internal)
[   20.780024] Ending XFS recovery on filesystem: sda6 (logdev: internal)
[   21.226414] type=1505 audit(1240287212.748:2): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=4294
[   21.226657] type=1505 audit(1240287212.748:3): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4294
[   21.274081] type=1505 audit(1240287212.796:4): operation="profile_load" name="/usr/sbin/mysqld" name2="default" pid=4298
[   21.448332] ip_tables: (C) 2000-2006 Netfilter Core Team
[   22.259563] ACPI: WMI: Mapper loaded
[   23.270250] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   23.643403] NET: Registered protocol family 10
[   23.643940] lo: Disabled Privacy Extensions
[   25.427602] ppdev: user-space parallel port driver
[   34.220319] Bluetooth: Core ver 2.13
[   34.222054] NET: Registered protocol family 31
[   34.222060] Bluetooth: HCI device and connection manager initialized
[   34.222065] Bluetooth: HCI socket layer initialized
[   34.234743] Bluetooth: L2CAP ver 2.11
[   34.234751] Bluetooth: L2CAP socket layer initialized
[   34.246425] Bluetooth: SCO (Voice Link) ver 0.6
[   34.246431] Bluetooth: SCO socket layer initialized
[   34.258551] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   34.258561] Bluetooth: BNEP filters: protocol multicast
[   34.277070] Bridge firewalling registered
[   34.646589] Bluetooth: RFCOMM socket layer initialized
[   34.646615] Bluetooth: RFCOMM TTY layer initialized
[   34.646618] Bluetooth: RFCOMM ver 1.10
[   36.472560] pci 0000:01:05.0: power state changed by ACPI to D0
[   36.472584] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   36.645723] [drm] Initialized drm 1.1.0 20060810
[   36.666189] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   37.221713] [drm] Setting GART location based on new memory map
[   37.222190] [drm] Loading RS690 Microcode
[   37.222211] [drm] Num pipes: 1
[   37.222219] [drm] writeback test succeeded in 1 usecs
[   37.388570] lirc_dev: IR Remote Control driver registered, major 61 
[   37.406598] usbcore: registered new interface driver lirc_mceusb
[   37.408244] lirc_mceusb: USB Microsoft IR Transceiver Driver v0.2
[   38.785694] r8169: eth0: link down
[   38.786692] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   38.788877] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   38.818846] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   38.929073] NET: Registered protocol family 17
[   48.925025] wlan0: no IPv6 routers present
[   49.097755] CPU0 attaching NULL sched-domain.
[   49.097773] CPU1 attaching NULL sched-domain.
[   49.113093] CPU0 attaching sched-domain:
[   49.113100]  domain 0: span 0-1 level MC
[   49.113103]   groups: 0 1
[   49.113109]   domain 1: span 0-1 level CPU
[   49.113111]    groups: 0-1
[   49.113114]    domain 2: span 0-1 level NODE
[   49.113116]     groups: 0-1
[   49.113121] CPU1 attaching sched-domain:
[   49.113123]  domain 0: span 0-1 level MC
[   49.113125]   groups: 1 0
[   49.113129]   domain 1: span 0-1 level CPU
[   49.113131]    groups: 0-1
[   49.113133]    domain 2: span 0-1 level NODE
[   49.113135]     groups: 0-1
[   49.192612] CPU0 attaching NULL sched-domain.
[   49.192629] CPU1 attaching NULL sched-domain.
[   49.242778] CPU0 attaching sched-domain:
[   49.242788]  domain 0: span 0-1 level MC
[   49.242792]   groups: 0 1
[   49.242798]   domain 1: span 0-1 level CPU
[   49.242800]    groups: 0-1
[   49.242803]    domain 2: span 0-1 level NODE
[   49.242806]     groups: 0-1
[   49.242815] CPU1 attaching sched-domain:
[   49.242817]  domain 0: span 0-1 level MC
[   49.242819]   groups: 1 0
[   49.242824]   domain 1: span 0-1 level CPU
[   49.242826]    groups: 0-1
[   49.242829]    domain 2: span 0-1 level NODE
[   49.242831]     groups: 0-1
[   78.503582] [drm] Num pipes: 1
[   80.433006] [drm] Setting GART location based on new memory map
[   80.433944] [drm] Loading RS690 Microcode
[   80.433973] [drm] Num pipes: 1
[   80.433980] [drm] writeback test succeeded in 1 usecs
[   83.257418] hda-intel: Invalid position buffer, using LPIB read method instead.
[   93.991835] CPU0 attaching NULL sched-domain.
[   93.991850] CPU1 attaching NULL sched-domain.
[   94.012146] CPU0 attaching sched-domain:
[   94.012155]  domain 0: span 0-1 level MC
[   94.012158]   groups: 0 1
[   94.012163]   domain 1: span 0-1 level CPU
[   94.012166]    groups: 0-1
[   94.012168]    domain 2: span 0-1 level NODE
[   94.012172]     groups: 0-1
[   94.012179] CPU1 attaching sched-domain:
[   94.012181]  domain 0: span 0-1 level MC
[   94.012183]   groups: 1 0
[   94.012186]   domain 1: span 0-1 level CPU
[   94.012188]    groups: 0-1
[   94.012191]    domain 2: span 0-1 level NODE
[   94.012193]     groups: 0-1
[   94.297067] CPU0 attaching NULL sched-domain.
[   94.297088] CPU1 attaching NULL sched-domain.
[   94.324122] CPU0 attaching sched-domain:
[   94.324132]  domain 0: span 0-1 level MC
[   94.324136]   groups: 0 1
[   94.324140]   domain 1: span 0-1 level CPU
[   94.324144]    groups: 0-1
[   94.324147]    domain 2: span 0-1 level NODE
[   94.324149]     groups: 0-1
[   94.324156] CPU1 attaching sched-domain:
[   94.324158]  domain 0: span 0-1 level MC
[   94.324160]   groups: 1 0
[   94.324163]   domain 1: span 0-1 level CPU
[   94.324165]    groups: 0-1
[   94.324168]    domain 2: span 0-1 level NODE
[   94.324170]     groups: 0-1
[  142.948484] firmware: requesting xc3028-v27.fw
[  143.023849] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  143.044033] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[  144.026078] xc2028 2-0061: Loading firmware for type=D2633 DTV6 ATSC (10030), id 0000000000000000.
[  379.604161] DVB: frontend 0 frequency 863000000 out of range (54000000..858000000)
[  379.604994] DVB: frontend 0 frequency 869000000 out of range (54000000..858000000)
[  379.606274] DVB: frontend 0 frequency 875000000 out of range (54000000..858000000)
[  379.607641] DVB: frontend 0 frequency 881000000 out of range (54000000..858000000)
[  379.609031] DVB: frontend 0 frequency 887000000 out of range (54000000..858000000)
[  496.916014] APIC error on CPU1: 40(40)
[  496.916019] APIC error on CPU0: 40(40)
[  523.836015] APIC error on CPU0: 40(40)
[  523.836023] APIC error on CPU1: 40(40)
[  552.809543] CPU0 attaching NULL sched-domain.
[  552.809564] CPU1 attaching NULL sched-domain.
[  552.841088] CPU0 attaching sched-domain:
[  552.841095]  domain 0: span 0-1 level CPU
[  552.841097]   groups: 0 1
[  552.841102]   domain 1: span 0-1 level NODE
[  552.841105]    groups: 0-1
[  552.841110] CPU1 attaching sched-domain:
[  552.841112]  domain 0: span 0-1 level CPU
[  552.841114]   groups: 1 0
[  552.841117]   domain 1: span 0-1 level NODE
[  552.841120]    groups: 0-1




----------------------------------------
> Date: Mon, 20 Apr 2009 21:51:27 -0400
> From: stoth@linuxtv.org
> Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
> To: pghben@yahoo.com
> CC: linux-media@vger.kernel.org; mchehab@infradead.org
>
>>
>> If there is anything I can do that will help you find the bug, please
>> let me know..
>
> The issue is fixed.
>
> http://linuxtv.org/hg/~stoth/cx23885-hvr1500/rev/7853c00870e1
>
> It's locking OK for me now. If you can clone, built and test - thus confirm the
> fix - that would be great.
>
> Build instructions on the wiki:
>
> http://linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers
>
> Thanks,
>
> - Steve
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Rediscover Hotmail®: Now available on your iPhone or BlackBerry
http://windowslive.com/RediscoverHotmail?ocid=TXT_TAGLM_WL_HM_Rediscover_Mobile2_042009