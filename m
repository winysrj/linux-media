Return-path: <linux-media-owner@vger.kernel.org>
Received: from antispam.unina.it ([192.132.34.50]:51801 "EHLO brc1.unina.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934183AbdD1Lk1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:40:27 -0400
Received: from smtp1.unina.it (smtp1.unina.it [192.132.34.61]) by brc1.unina.it with ESMTP id ZH2UHwRJfTvWkCGZ (version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for <linux-media@vger.kernel.org>; Fri, 28 Apr 2017 13:23:24 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Giuseppe Toscano <giuseppe.toscano@unina.it>
Subject: em28xx module: misidentified card
Message-ID: <5b093b1a-6251-b35e-190c-431fb00eb771@unina.it>
Date: Fri, 28 Apr 2017 13:22:54 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------40C4E9FA5335B47336A6B795"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------40C4E9FA5335B47336A6B795
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

I am trying to use eMPIA Technology, Inc. GrabBeeX+ Video Encoder 
(card=21) but the em28xx driver erroneously identifies it as 
EM2860/SAA711X Reference Design (card = 19).
Attached the output of lsusb and dmesg.

Best regards,

Giuseppe Toscano
-- 
Dipartimento di Ingegneria Chimica, dei Materiali e della Produzione
Industriale (DICMaPI)
Università degli Studi di Napoli Federico II
Piazzale Tecchio 80
I-80125 Napoli, Italy
tel. +39-081-76-82278

--------------40C4E9FA5335B47336A6B795
Content-Type: text/plain; charset=UTF-8;
 name="dmesg_output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_output.txt"

[    0.000000] Linux version 4.8.0-49-generic (buildd@lcy01-26) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) ) #52~16.04.1-Ubuntu SMP Thu Apr 20 10:55:59 UTC 2017 (Ubuntu 4.8.0-49.52~16.04.1-generic 4.8.17)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.8.0-49-generic root=UUID=35ec5c90-3658-4eee-b92a-842317fe4870 ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfeaffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfeb0000-0x00000000bfec9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfeca000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Acer TravelMate 6592/TravelMate 6592, BIOS V1.41    01/07/08
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 13C000000 mask FFC000000 uncachable
[    0.000000]   2 base 000000000 mask F00000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] total RAM covered: 4031M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 5  	lose cover RAM: 0G
[    0.000000] e820: update [mem 0xbff00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbfeb0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f70e0-0x000f70ef] mapped at [ffffa142800f70e0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffffa14280098000] 98000 size 24576
[    0.000000] BRK [0x2283b000, 0x2283bfff] PGTABLE
[    0.000000] BRK [0x2283c000, 0x2283cfff] PGTABLE
[    0.000000] BRK [0x2283d000, 0x2283dfff] PGTABLE
[    0.000000] BRK [0x2283e000, 0x2283efff] PGTABLE
[    0.000000] BRK [0x2283f000, 0x2283ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x33302000-0x35978fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F7040 000024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 0x00000000BFEBCEC1 000094 (v01 ACRSYS ACRPRDCT 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000BFEC6B87 0000F4 (v03 INTEL  CRESTLNE 06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT 0x00000000BFEBE3ED 008726 (v02 INTEL  CRESTLNE 06040000 INTL 20050624)
[    0.000000] ACPI: FACS 0x00000000BFEC9FC0 000040
[    0.000000] ACPI: FACS 0x00000000BFEC9FC0 000040
[    0.000000] ACPI: HPET 0x00000000BFEC6C7B 000038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 0x00000000BFEC6CB3 00003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA 0x00000000BFEC6CEF 000032 (v01 Intel   CRESTLN 06040000      00005A52)
[    0.000000] ACPI: TMOR 0x00000000BFEC6D21 000026 (v01 PTLTD           06040000 PTL  00000003)
[    0.000000] ACPI: APIC 0x00000000BFEC6D47 000068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: SLIC 0x00000000BFEC6DAF 000176 (v01 ACRSYS ACRPRDCT 06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000BFEC6F25 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 0x00000000BFEC6F4D 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: ASF! 0x00000000BFEC6F9D 000063 (v16   CETP     CETP 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 0x00000000BFEBE0F8 0002F5 (v01 SataRe SataAhci 00001000 INTL 20050624)
[    0.000000] ACPI: SSDT 0x00000000BFEBD4E1 00025F (v01 PmRef  Cpu0Tst  00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 0x00000000BFEBD43B 0000A6 (v01 PmRef  Cpu1Tst  00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 0x00000000BFEBCF55 0004E6 (v01 PmRef  CpuPm    00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013bffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13bff8000-0x13bffcfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000013bffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bfeaffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000013bffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000013bffffff]
[    0.000000] On node 0 totalpages: 1031757
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12219 pages used for memmap
[    0.000000]   DMA32 zone: 782000 pages, LIFO batch:31
[    0.000000]   Normal zone: 3840 pages used for memmap
[    0.000000]   Normal zone: 245760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000d1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d2000-0x000d3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d4000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfeb0000-0xbfec9fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfeca000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed13fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffffa143bbc00000 s107864 r8192 d31400 u1048576
[    0.000000] pcpu-alloc: s107864 r8192 d31400 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1015613
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.8.0-49-generic root=UUID=35ec5c90-3658-4eee-b92a-842317fe4870 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3936680K/4127028K available (8829K kernel code, 1441K rwdata, 3836K rodata, 1548K init, 1296K bss, 190348K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:33024 nr_irqs:440 16
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1995.061 MHz processor
[    0.004013] Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.12 BogoMIPS (lpj=7980244)
[    0.004017] pid_max: default: 32768 minimum: 301
[    0.004035] ACPI: Core revision 20160422
[    0.013287] ACPI: 5 ACPI AML tables successfully acquired and loaded

[    0.013330] Security Framework initialized
[    0.013333] Yama: becoming mindful.
[    0.013354] AppArmor: AppArmor initialized
[    0.013703] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.016170] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.017530] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.017540] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.018045] CPU: Physical Processor ID: 0
[    0.018046] CPU: Processor Core ID: 0
[    0.018048] mce: CPU supports 6 MCE banks
[    0.018063] process: using mwait in idle threads
[    0.018069] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.018070] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.018485] Freeing SMP alternatives memory: 32K (ffffffffbe0ed000 - ffffffffbe0f5000)
[    0.022523] ftrace: allocating 33453 entries in 131 pages
[    0.032137] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.032138] smpboot: Max logical packages: 1
[    0.032576] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076000] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz (family: 0x6, model: 0xf, stepping: 0xa)
[    0.076000] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.076000] core: PEBS disabled due to CPU errata
[    0.076000] ... version:                2
[    0.076000] ... bit width:              40
[    0.076000] ... generic registers:      2
[    0.076000] ... value mask:             000000ffffffffff
[    0.076000] ... max period:             000000007fffffff
[    0.076000] ... fixed-purpose events:   3
[    0.076000] ... event mask:             0000000700000003
[    0.076000] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.076000] x86: Booting SMP configuration:
[    0.076000] .... node  #0, CPUs:      #1
[    0.076077] x86: Booted up 1 node, 2 CPUs
[    0.076077] smpboot: Total of 2 processors activated (7980.24 BogoMIPS)
[    0.078327] devtmpfs: initialized
[    0.078327] x86/mm: Memory block size: 128MB
[    0.082679] evm: security.selinux
[    0.082680] evm: security.SMACK64
[    0.082681] evm: security.SMACK64EXEC
[    0.082682] evm: security.SMACK64TRANSMUTE
[    0.082683] evm: security.SMACK64MMAP
[    0.082684] evm: security.ima
[    0.082684] evm: security.capability
[    0.082720] PM: Registering ACPI NVS region [mem 0xbfeb0000-0xbfec9fff] (106496 bytes)
[    0.082720] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.082720] pinctrl core: initialized pinctrl subsystem
[    0.082720] RTC time: 10:56:44, date: 04/28/17
[    0.082720] NET: Registered protocol family 16
[    0.092005] cpuidle: using governor ladder
[    0.108004] cpuidle: using governor menu
[    0.108006] PCCT header not found.
[    0.108046] Simple Boot Flag at 0x36 set to 0x1
[    0.108057] ACPI: bus type PCI registered
[    0.108058] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.108148] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.108150] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.108169] PCI: Using configuration type 1 for base access
[    0.128048] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.128108] ACPI: Added _OSI(Module Device)
[    0.128109] ACPI: Added _OSI(Processor Device)
[    0.128110] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.128111] ACPI: Added _OSI(Processor Aggregator Device)
[    0.148012] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.170343] ACPI: Dynamic OEM Table Load:
[    0.170351] ACPI: SSDT 0xFFFFA143B6548C00 00027A (v01 PmRef  Cpu0Ist  00003000 INTL 20050624)
[    0.170926] ACPI: Dynamic OEM Table Load:
[    0.170933] ACPI: SSDT 0xFFFFA143B65A1800 0005F1 (v01 PmRef  Cpu0Cst  00003001 INTL 20050624)
[    0.171564] ACPI: Dynamic OEM Table Load:
[    0.171571] ACPI: SSDT 0xFFFFA143B6484A00 0000C8 (v01 PmRef  Cpu1Ist  00003000 INTL 20050624)
[    0.172084] ACPI: Dynamic OEM Table Load:
[    0.172090] ACPI: SSDT 0xFFFFA143B657F3C0 000085 (v01 PmRef  Cpu1Cst  00003000 INTL 20050624)
[    0.172935] ACPI : EC: EC started
[    0.173039] ACPI: Interpreter enabled
[    0.173061] ACPI: (supports S0 S3 S4 S5)
[    0.173062] ACPI: Using IOAPIC for interrupt routing
[    0.173088] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.174755] acpi SADDLEST:00: ACPI dock station (docks/bays count: 1)
[    0.180402] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.181080] ACPI: Power Resource [FN00] (off)
[    0.181947] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.181952] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.181957] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.182553] PCI host bridge to bus 0000:00
[    0.182556] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.182558] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.182560] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.182562] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.182564] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.182565] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.182567] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff window]
[    0.182569] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff window]
[    0.182571] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff window]
[    0.182573] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.182583] pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
[    0.182726] pci 0000:00:01.0: [8086:2a01] type 01 class 0x060400
[    0.182777] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.182930] pci 0000:00:19.0: [8086:1049] type 00 class 0x020000
[    0.182954] pci 0000:00:19.0: reg 0x10: [mem 0xfc400000-0xfc41ffff]
[    0.182967] pci 0000:00:19.0: reg 0x14: [mem 0xfc425000-0xfc425fff]
[    0.182979] pci 0000:00:19.0: reg 0x18: [io  0x1840-0x185f]
[    0.183071] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.183151] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.183213] pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
[    0.183274] pci 0000:00:1a.0: reg 0x20: [io  0x1860-0x187f]
[    0.183380] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.183438] pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
[    0.183500] pci 0000:00:1a.1: reg 0x20: [io  0x1880-0x189f]
[    0.183604] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.183675] pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
[    0.183699] pci 0000:00:1a.7: reg 0x10: [mem 0xfc426c00-0xfc426fff]
[    0.183815] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.183940] pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
[    0.183966] pci 0000:00:1b.0: reg 0x10: [mem 0xfc420000-0xfc423fff 64bit]
[    0.184088] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.184152] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.184219] pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
[    0.184335] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.184460] pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
[    0.184577] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.184704] pci 0000:00:1c.2: [8086:2843] type 01 class 0x060400
[    0.184822] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.184947] pci 0000:00:1c.3: [8086:2845] type 01 class 0x060400
[    0.185062] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.185186] pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
[    0.185248] pci 0000:00:1d.0: reg 0x20: [io  0x18a0-0x18bf]
[    0.185354] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.185414] pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
[    0.185476] pci 0000:00:1d.1: reg 0x20: [io  0x18c0-0x18df]
[    0.185580] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.185639] pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
[    0.185701] pci 0000:00:1d.2: reg 0x20: [io  0x18e0-0x18ff]
[    0.185846] pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
[    0.185870] pci 0000:00:1d.7: reg 0x10: [mem 0xfc427000-0xfc4273ff]
[    0.185985] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.186043] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.186107] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.186282] pci 0000:00:1f.0: [8086:2811] type 00 class 0x060100
[    0.186398] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.186404] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.186409] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0400 (mask 0003)
[    0.186412] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 007f)
[    0.186416] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0300 (mask 005f)
[    0.186553] pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
[    0.186572] pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]
[    0.186584] pci 0000:00:1f.1: reg 0x14: [io  0x0000-0x0003]
[    0.186597] pci 0000:00:1f.1: reg 0x18: [io  0x0000-0x0007]
[    0.186609] pci 0000:00:1f.1: reg 0x1c: [io  0x0000-0x0003]
[    0.186622] pci 0000:00:1f.1: reg 0x20: [io  0x1830-0x183f]
[    0.186651] pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.186653] pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.186654] pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.186656] pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.186772] pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
[    0.186796] pci 0000:00:1f.2: reg 0x10: [io  0x1c48-0x1c4f]
[    0.186808] pci 0000:00:1f.2: reg 0x14: [io  0x1c1c-0x1c1f]
[    0.186821] pci 0000:00:1f.2: reg 0x18: [io  0x1c40-0x1c47]
[    0.186833] pci 0000:00:1f.2: reg 0x1c: [io  0x1c18-0x1c1b]
[    0.186845] pci 0000:00:1f.2: reg 0x20: [io  0x1c20-0x1c3f]
[    0.186858] pci 0000:00:1f.2: reg 0x24: [mem 0xfc426000-0xfc4267ff]
[    0.186924] pci 0000:00:1f.2: PME# supported from D3hot
[    0.187040] pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
[    0.187058] pci 0000:00:1f.3: reg 0x10: [mem 0x00000000-0x000000ff]
[    0.187103] pci 0000:00:1f.3: reg 0x20: [io  0x1c60-0x1c7f]
[    0.187308] pci 0000:01:00.0: [1002:94c8] type 00 class 0x030000
[    0.187328] pci 0000:01:00.0: reg 0x10: [mem 0xf0000000-0xf3ffffff pref]
[    0.187340] pci 0000:01:00.0: reg 0x14: [io  0x2000-0x20ff]
[    0.187353] pci 0000:01:00.0: reg 0x18: [mem 0xfc000000-0xfc00ffff]
[    0.187397] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.187459] pci 0000:01:00.0: supports D1 D2
[    0.196017] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.196021] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.196024] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfc0fffff]
[    0.196028] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.196116] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.196121] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.196126] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.196134] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf5ffffff 64bit pref]
[    0.196217] pci 0000:00:1c.1: PCI bridge to [bus 04-05]
[    0.196222] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.196227] pci 0000:00:1c.1:   bridge window [mem 0xd6000000-0xd7ffffff]
[    0.196235] pci 0000:00:1c.1:   bridge window [mem 0xde000000-0xdfffffff 64bit pref]
[    0.196376] pci 0000:06:00.0: [8086:4229] type 00 class 0x028000
[    0.196433] pci 0000:06:00.0: reg 0x10: [mem 0xfa000000-0xfa001fff 64bit]
[    0.196680] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.196745] pci 0000:06:00.0: System wakeup disabled by ACPI
[    0.208047] pci 0000:00:1c.2: PCI bridge to [bus 06-07]
[    0.208052] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
[    0.208057] pci 0000:00:1c.2:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.208065] pci 0000:00:1c.2:   bridge window [mem 0xf6000000-0xf7ffffff 64bit pref]
[    0.208166] acpiphp: Slot [1] registered
[    0.208172] pci 0000:00:1c.3: PCI bridge to [bus 08-09]
[    0.208177] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
[    0.208182] pci 0000:00:1c.3:   bridge window [mem 0xd2000000-0xd3ffffff]
[    0.208190] pci 0000:00:1c.3:   bridge window [mem 0xda000000-0xdbffffff 64bit pref]
[    0.208299] pci 0000:0a:04.0: [1217:00f7] type 00 class 0x0c0010
[    0.208320] pci 0000:0a:04.0: reg 0x10: [mem 0xfc101000-0xfc101fff]
[    0.208334] pci 0000:0a:04.0: reg 0x14: [mem 0xfc100000-0xfc1007ff]
[    0.208430] pci 0000:0a:04.0: supports D1 D2
[    0.208432] pci 0000:0a:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208516] pci 0000:0a:04.1: [1217:7175] type 02 class 0x060700
[    0.208535] pci 0000:0a:04.1: reg 0x10: [mem 0xfc102000-0xfc102fff]
[    0.208578] pci 0000:0a:04.1: supports D1 D2
[    0.208580] pci 0000:0a:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208661] pci 0000:0a:04.2: [1217:7120] type 00 class 0x080500
[    0.208681] pci 0000:0a:04.2: reg 0x10: [mem 0xfc109000-0xfc1090ff]
[    0.208774] pci 0000:0a:04.2: supports D1 D2
[    0.208776] pci 0000:0a:04.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208859] pci 0000:0a:04.3: [1217:7130] type 00 class 0x018000
[    0.208879] pci 0000:0a:04.3: reg 0x10: [mem 0xfc103000-0xfc103fff]
[    0.208976] pci 0000:0a:04.3: supports D1 D2
[    0.208978] pci 0000:0a:04.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.209067] pci 0000:0a:05.0: [1217:6972] type 02 class 0x060700
[    0.209090] pci 0000:0a:05.0: reg 0x10: [mem 0xfc108000-0xfc108fff]
[    0.209132] pci 0000:0a:05.0: supports D1 D2
[    0.209134] pci 0000:0a:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.209163] pci 0000:0a:05.0: System wakeup disabled by ACPI
[    0.209227] pci 0000:0a:07.0: [104c:8024] type 00 class 0x0c0010
[    0.209251] pci 0000:0a:07.0: reg 0x10: [mem 0xfc100800-0xfc100fff]
[    0.209264] pci 0000:0a:07.0: reg 0x14: [mem 0xfc104000-0xfc107fff]
[    0.209365] pci 0000:0a:07.0: supports D1 D2
[    0.209366] pci 0000:0a:07.0: PME# supported from D0 D1 D2 D3hot
[    0.209475] pci 0000:00:1e.0: PCI bridge to [bus 0a-0c] (subtractive decode)
[    0.209483] pci 0000:00:1e.0:   bridge window [mem 0xfc100000-0xfc1fffff]
[    0.209492] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    0.209494] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.209496] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.209498] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff window] (subtractive decode)
[    0.209500] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff window] (subtractive decode)
[    0.209501] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff window] (subtractive decode)
[    0.209503] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff window] (subtractive decode)
[    0.209505] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff window] (subtractive decode)
[    0.209507] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff window] (subtractive decode)
[    0.209511] pci 0000:0a:04.1: bridge configuration invalid ([bus 00-00]), reconfiguring
[    0.209521] pci 0000:0a:05.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    0.209582] pci_bus 0000:0b: busn_res: can not insert [bus 0b-ff] under [bus 0a-0c] (conflicts with (null) [bus 0a-0c])
[    0.209587] pci_bus 0000:0b: busn_res: [bus 0b-ff] end is updated to 0b
[    0.209644] pci_bus 0000:0c: busn_res: can not insert [bus 0c-ff] under [bus 0a-0c] (conflicts with (null) [bus 0a-0c])
[    0.209648] pci_bus 0000:0c: busn_res: [bus 0c-ff] end is updated to 0f
[    0.209651] pci_bus 0000:0c: busn_res: can not insert [bus 0c-0f] under [bus 0a-0c] (conflicts with (null) [bus 0a-0c])
[    0.209655] pci_bus 0000:0c: [bus 0c-0f] partially hidden behind transparent bridge 0000:0a [bus 0a-0c]
[    0.209659] pci 0000:00:1e.0: bridge has subordinate 0c but max busn 0f
[    0.209878] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 *7 10 12 14 15)
[    0.209950] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.210019] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.210087] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.210155] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.210223] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.210290] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.210357] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.211826] ACPI: Enabled 4 GPEs in block 00 to 1F
[    0.211998] ACPI : EC: EC stopped
[    1.536053] ACPI : EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    1.536053] ACPI : EC: EC started
[    1.536322] SCSI subsystem initialized
[    1.536936] libata version 3.00 loaded.
[    1.536936] vgaarb: setting as boot device: PCI:0000:01:00.0
[    1.536936] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.536936] vgaarb: loaded
[    1.536936] vgaarb: bridge control possible 0000:01:00.0
[    1.536936] ACPI: bus type USB registered
[    1.536936] usbcore: registered new interface driver usbfs
[    1.536936] usbcore: registered new interface driver hub
[    1.536936] usbcore: registered new device driver usb
[    1.536936] PCI: Using ACPI for IRQ routing
[    1.550848] PCI: pci_cache_line_size set to 64 bytes
[    1.550994] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    1.550996] e820: reserve RAM buffer [mem 0xbfeb0000-0xbfffffff]
[    1.551149] NetLabel: Initializing
[    1.551150] NetLabel:  domain hash size = 128
[    1.551151] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.551172] NetLabel:  unlabeled traffic allowed by default
[    1.551199] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.551199] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.551199] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.553007] clocksource: Switched to clocksource hpet
[    1.566297] VFS: Disk quotas dquot_6.6.0
[    1.566327] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.566497] AppArmor: AppArmor Filesystem Enabled
[    1.566588] pnp: PnP ACPI init
[    1.566876] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.566879] system 00:00: [mem 0xfed14000-0xfed17fff] has been reserved
[    1.566881] system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.566883] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.566885] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    1.566887] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.566890] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.566895] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.567355] system 00:01: [mem 0xfed00000-0xfed003ff] has been reserved
[    1.567359] system 00:01: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    1.567449] system 00:02: [io  0x0400-0x0401] has been reserved
[    1.567451] system 00:02: [io  0x01f8-0x0273] has been reserved
[    1.567453] system 00:02: [io  0x0680-0x069f] has been reserved
[    1.567455] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.567458] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.567460] system 00:02: [io  0x1180-0x11bf] has been reserved
[    1.567462] system 00:02: [io  0x1640-0x164f] has been reserved
[    1.567464] system 00:02: [io  0xfe00] has been reserved
[    1.567468] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.567513] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.567869] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.568200] pnp 00:05: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    1.568255] pnp 00:06: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    1.568296] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.568336] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.568418] pnp: PnP ACPI: found 9 devices
[    1.575957] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    1.576043] pci 0000:0a:04.1: res[13]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576045] pci 0000:0a:04.1: res[14]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576048] pci 0000:0a:05.0: res[13]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576050] pci 0000:0a:05.0: res[14]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576053] pci 0000:00:1e.0: bridge window [io  0x1000-0x0fff] to [bus 0a-0c] add_size 1000
[    1.576062] pci 0000:00:1e.0: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    1.576064] pci 0000:00:1e.0: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    1.576069] pci 0000:00:1e.0: BAR 13: assigned [io  0x7000-0x7fff]
[    1.576074] pci 0000:00:1f.3: BAR 0: assigned [mem 0xc0000000-0xc00000ff]
[    1.576081] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc020000-0xfc03ffff pref]
[    1.576084] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.576086] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    1.576090] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfc0fffff]
[    1.576093] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    1.576099] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    1.576102] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.576108] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf9ffffff]
[    1.576113] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf5ffffff 64bit pref]
[    1.576122] pci 0000:00:1c.1: PCI bridge to [bus 04-05]
[    1.576125] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.576130] pci 0000:00:1c.1:   bridge window [mem 0xd6000000-0xd7ffffff]
[    1.576135] pci 0000:00:1c.1:   bridge window [mem 0xde000000-0xdfffffff 64bit pref]
[    1.576144] pci 0000:00:1c.2: PCI bridge to [bus 06-07]
[    1.576146] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
[    1.576152] pci 0000:00:1c.2:   bridge window [mem 0xfa000000-0xfbffffff]
[    1.576157] pci 0000:00:1c.2:   bridge window [mem 0xf6000000-0xf7ffffff 64bit pref]
[    1.576165] pci 0000:00:1c.3: PCI bridge to [bus 08-09]
[    1.576168] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
[    1.576174] pci 0000:00:1c.3:   bridge window [mem 0xd2000000-0xd3ffffff]
[    1.576179] pci 0000:00:1c.3:   bridge window [mem 0xda000000-0xdbffffff 64bit pref]
[    1.576191] pci 0000:0a:04.1: res[15]=[mem 0x04000000-0x03ffffff pref] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576193] pci 0000:0a:04.1: res[15]=[mem 0x04000000-0x07ffffff pref] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576195] pci 0000:0a:04.1: res[16]=[mem 0x04000000-0x03ffffff] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576198] pci 0000:0a:04.1: res[16]=[mem 0x04000000-0x07ffffff] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576200] pci 0000:0a:05.0: res[15]=[mem 0x04000000-0x03ffffff pref] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576202] pci 0000:0a:05.0: res[15]=[mem 0x04000000-0x07ffffff pref] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576204] pci 0000:0a:05.0: res[16]=[mem 0x04000000-0x03ffffff] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576207] pci 0000:0a:05.0: res[16]=[mem 0x04000000-0x07ffffff] res_to_dev_res add_size 4000000 min_align 4000000
[    1.576209] pci 0000:0a:04.1: res[13]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576211] pci 0000:0a:04.1: res[13]=[io  0x0100-0x01ff] res_to_dev_res add_size 100 min_align 100
[    1.576213] pci 0000:0a:04.1: res[14]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576215] pci 0000:0a:04.1: res[14]=[io  0x0100-0x01ff] res_to_dev_res add_size 100 min_align 100
[    1.576217] pci 0000:0a:05.0: res[13]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576219] pci 0000:0a:05.0: res[13]=[io  0x0100-0x01ff] res_to_dev_res add_size 100 min_align 100
[    1.576221] pci 0000:0a:05.0: res[14]=[io  0x0100-0x00ff] res_to_dev_res add_size 100 min_align 100
[    1.576223] pci 0000:0a:05.0: res[14]=[io  0x0100-0x01ff] res_to_dev_res add_size 100 min_align 100
[    1.576228] pci 0000:0a:04.1: BAR 15: assigned [mem 0xc4000000-0xc7ffffff pref]
[    1.576233] pci 0000:0a:04.1: BAR 16: assigned [mem 0xc8000000-0xcbffffff]
[    1.576237] pci 0000:0a:05.0: BAR 15: assigned [mem 0xcc000000-0xcfffffff pref]
[    1.576245] pci 0000:0a:05.0: BAR 16: no space for [mem size 0x04000000]
[    1.576247] pci 0000:0a:05.0: BAR 16: failed to assign [mem size 0x04000000]
[    1.576250] pci 0000:0a:04.1: BAR 13: assigned [io  0x7000-0x70ff]
[    1.576252] pci 0000:0a:04.1: BAR 14: assigned [io  0x7400-0x74ff]
[    1.576254] pci 0000:0a:05.0: BAR 13: assigned [io  0x7800-0x78ff]
[    1.576256] pci 0000:0a:05.0: BAR 14: assigned [io  0x7c00-0x7cff]
[    1.576261] pci 0000:0a:05.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    1.576265] pci 0000:0a:05.0: BAR 15: assigned [mem 0xc8000000-0xcbffffff pref]
[    1.576269] pci 0000:0a:04.1: BAR 16: assigned [mem 0xcc000000-0xcfffffff]
[    1.576277] pci 0000:0a:04.1: BAR 15: no space for [mem size 0x04000000 pref]
[    1.576279] pci 0000:0a:04.1: BAR 15: failed to assign [mem size 0x04000000 pref]
[    1.576282] pci 0000:0a:04.1: CardBus bridge to [bus 0b]
[    1.576284] pci 0000:0a:04.1:   bridge window [io  0x7000-0x70ff]
[    1.576288] pci 0000:0a:04.1:   bridge window [io  0x7400-0x74ff]
[    1.576294] pci 0000:0a:04.1:   bridge window [mem 0xcc000000-0xcfffffff]
[    1.576299] pci 0000:0a:05.0: CardBus bridge to [bus 0c-0f]
[    1.576301] pci 0000:0a:05.0:   bridge window [io  0x7800-0x78ff]
[    1.576306] pci 0000:0a:05.0:   bridge window [io  0x7c00-0x7cff]
[    1.576311] pci 0000:0a:05.0:   bridge window [mem 0xc8000000-0xcbffffff pref]
[    1.576316] pci 0000:0a:05.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    1.576321] pci 0000:00:1e.0: PCI bridge to [bus 0a-0c]
[    1.576324] pci 0000:00:1e.0:   bridge window [io  0x7000-0x7fff]
[    1.576331] pci 0000:00:1e.0:   bridge window [mem 0xfc100000-0xfc1fffff]
[    1.576343] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    1.576345] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    1.576347] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.576349] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff window]
[    1.576351] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff window]
[    1.576352] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff window]
[    1.576354] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xdfffffff window]
[    1.576356] pci_bus 0000:00: resource 11 [mem 0xf0000000-0xfebfffff window]
[    1.576358] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff window]
[    1.576360] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.576362] pci_bus 0000:01: resource 1 [mem 0xfc000000-0xfc0fffff]
[    1.576364] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
[    1.576366] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.576368] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xf9ffffff]
[    1.576369] pci_bus 0000:02: resource 2 [mem 0xf4000000-0xf5ffffff 64bit pref]
[    1.576371] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
[    1.576373] pci_bus 0000:04: resource 1 [mem 0xd6000000-0xd7ffffff]
[    1.576375] pci_bus 0000:04: resource 2 [mem 0xde000000-0xdfffffff 64bit pref]
[    1.576377] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    1.576378] pci_bus 0000:06: resource 1 [mem 0xfa000000-0xfbffffff]
[    1.576380] pci_bus 0000:06: resource 2 [mem 0xf6000000-0xf7ffffff 64bit pref]
[    1.576382] pci_bus 0000:08: resource 0 [io  0x6000-0x6fff]
[    1.576384] pci_bus 0000:08: resource 1 [mem 0xd2000000-0xd3ffffff]
[    1.576386] pci_bus 0000:08: resource 2 [mem 0xda000000-0xdbffffff 64bit pref]
[    1.576388] pci_bus 0000:0a: resource 0 [io  0x7000-0x7fff]
[    1.576389] pci_bus 0000:0a: resource 1 [mem 0xfc100000-0xfc1fffff]
[    1.576391] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7 window]
[    1.576393] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff window]
[    1.576395] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.576397] pci_bus 0000:0a: resource 7 [mem 0x000d4000-0x000d7fff window]
[    1.576399] pci_bus 0000:0a: resource 8 [mem 0x000d8000-0x000dbfff window]
[    1.576401] pci_bus 0000:0a: resource 9 [mem 0x000dc000-0x000dffff window]
[    1.576403] pci_bus 0000:0a: resource 10 [mem 0xc0000000-0xdfffffff window]
[    1.576405] pci_bus 0000:0a: resource 11 [mem 0xf0000000-0xfebfffff window]
[    1.576407] pci_bus 0000:0a: resource 12 [mem 0xfed40000-0xfed44fff window]
[    1.576409] pci_bus 0000:0b: resource 0 [io  0x7000-0x70ff]
[    1.576411] pci_bus 0000:0b: resource 1 [io  0x7400-0x74ff]
[    1.576412] pci_bus 0000:0b: resource 3 [mem 0xcc000000-0xcfffffff]
[    1.576414] pci_bus 0000:0c: resource 0 [io  0x7800-0x78ff]
[    1.576416] pci_bus 0000:0c: resource 1 [io  0x7c00-0x7cff]
[    1.576418] pci_bus 0000:0c: resource 2 [mem 0xc8000000-0xcbffffff pref]
[    1.576420] pci_bus 0000:0c: resource 3 [mem 0xc4000000-0xc7ffffff]
[    1.576460] NET: Registered protocol family 2
[    1.576700] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    1.576844] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    1.577063] TCP: Hash tables configured (established 32768 bind 32768)
[    1.577128] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.577159] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.577230] NET: Registered protocol family 1
[    1.579254] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    1.579321] PCI: CLS 64 bytes, default 64
[    1.579384] Unpacking initramfs...
[    2.439717] Freeing initrd memory: 39388K (ffffa142b3302000 - ffffa142b5979000)
[    2.439725] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.439727] software IO TLB [mem 0xbbeb0000-0xbfeb0000] (64MB) mapped at [ffffa1433beb0000-ffffa1433feaffff]
[    2.439996] Scanning for low memory corruption every 60 seconds
[    2.440550] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.440585] audit: initializing netlink subsys (disabled)
[    2.440620] audit: type=2000 audit(1493377006.440:1): initialized
[    2.441083] Initialise system trusted keyrings
[    2.441216] workingset: timestamp_bits=40 max_order=20 bucket_order=0
[    2.444077] zbud: loaded
[    2.444729] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.445059] fuse init (API version 7.25)
[    2.445282] Allocating IMA blacklist keyring.
[    2.447118] Key type asymmetric registered
[    2.447120] Asymmetric key parser 'x509' registered
[    2.447184] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
[    2.447229] io scheduler noop registered
[    2.447230] io scheduler deadline registered (default)
[    2.447242] io scheduler cfq registered
[    2.448867] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.448875] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.448930] vesafb: mode is 800x600x32, linelength=3200, pages=0
[    2.448930] vesafb: scrolling: redraw
[    2.448932] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    2.448950] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc59c80800000, using 1920k, total 1920k
[    2.449086] Console: switching to colour frame buffer device 100x37
[    2.449104] fb0: VESA VGA frame buffer device
[    2.449124] intel_idle: does not run on family 6 model 15
[    2.449302] ACPI: AC Adapter [ADP0] (on-line)
[    2.449401] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    2.449405] ACPI: Sleep Button [SLPB]
[    2.449470] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    2.449491] ACPI: Lid Switch [LID]
[    2.449551] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    2.449554] ACPI: Power Button [PWRB]
[    2.449614] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    2.449616] ACPI: Power Button [PWRF]
[    2.450067] Monitor-Mwait will be used to enter C-1 state
[    2.450072] Monitor-Mwait will be used to enter C-2 state
[    2.450076] Monitor-Mwait will be used to enter C-3 state
[    2.450079] tsc: Marking TSC unstable due to TSC halts in idle
[    2.452070] thermal LNXTHERM:00: registered as thermal_zone0
[    2.452072] ACPI: Thermal Zone [TZ00] (57 C)
[    2.452245] thermal LNXTHERM:01: registered as thermal_zone1
[    2.452246] ACPI: Thermal Zone [TZVR] (54 C)
[    2.452412] thermal LNXTHERM:02: registered as thermal_zone2
[    2.452413] ACPI: Thermal Zone [TZVL] (47 C)
[    2.452577] thermal LNXTHERM:03: registered as thermal_zone3
[    2.452579] ACPI: Thermal Zone [TZ01] (47 C)
[    2.452625] GHES: HEST is not enabled!
[    2.452888] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.473647] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.476470] Linux agpgart interface v0.103
[    2.492873] ACPI: Battery Slot [BAT0] (battery present)
[    2.492932] ACPI: Battery Slot [BAT1] (battery absent)
[    2.556290] tpm_tis 00:06: 1.2 TPM (device-id 0xB, rev-id 16)
[    2.636348] tpm tpm0: [Hardware Error]: Adjusting reported timeouts: A 750->750000us B 2000->2000000us C 750->750000us D 750->750000us
[    2.716330] tpm tpm0: Adjusting TPM timeout parameters.
[    2.796334] tpm tpm0: [Firmware Bug]: TPM interrupt not working, polling instead
[    2.876345] tpm tpm0: [Hardware Error]: Adjusting reported timeouts: A 750->750000us B 2000->2000000us C 750->750000us D 750->750000us
[    2.956331] tpm tpm0: Adjusting TPM timeout parameters.
[    3.456197] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x3983e9c1dfd, max_idle_ns: 881590646202 ns
[    3.791685] loop: module loaded
[    3.791864] ata_piix 0000:00:1f.1: version 2.13
[    3.792955] scsi host0: ata_piix
[    3.793159] scsi host1: ata_piix
[    3.793224] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1830 irq 14
[    3.793225] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1838 irq 15
[    3.793358] libphy: Fixed MDIO Bus: probed
[    3.793360] tun: Universal TUN/TAP device driver, 1.6
[    3.793361] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.793407] PPP generic driver version 2.4.2
[    3.793470] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.793474] ehci-pci: EHCI PCI platform driver
[    3.793682] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    3.793690] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    3.793713] ehci-pci 0000:00:1a.7: debug port 1
[    3.797631] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    3.797648] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfc426c00
[    3.812253] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.812363] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.812367] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.812370] usb usb1: Product: EHCI Host Controller
[    3.812373] usb usb1: Manufacturer: Linux 4.8.0-49-generic ehci_hcd
[    3.812376] usb usb1: SerialNumber: 0000:00:1a.7
[    3.812613] hub 1-0:1.0: USB hub found
[    3.812621] hub 1-0:1.0: 4 ports detected
[    3.813016] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    3.813022] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    3.813042] ehci-pci 0000:00:1d.7: debug port 1
[    3.816948] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    3.816961] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfc427000
[    3.832196] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.832292] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.832295] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.832299] usb usb2: Product: EHCI Host Controller
[    3.832302] usb usb2: Manufacturer: Linux 4.8.0-49-generic ehci_hcd
[    3.832305] usb usb2: SerialNumber: 0000:00:1d.7
[    3.832549] hub 2-0:1.0: USB hub found
[    3.832558] hub 2-0:1.0: 6 ports detected
[    3.832860] ehci-platform: EHCI generic platform driver
[    3.832881] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.832883] ohci-pci: OHCI PCI platform driver
[    3.832898] ohci-platform: OHCI generic platform driver
[    3.832910] uhci_hcd: USB Universal Host Controller Interface driver
[    3.833069] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.833075] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.833085] uhci_hcd 0000:00:1a.0: detected 2 ports
[    3.833121] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001860
[    3.833182] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.833184] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.833186] usb usb3: Product: UHCI Host Controller
[    3.833188] usb usb3: Manufacturer: Linux 4.8.0-49-generic uhci_hcd
[    3.833190] usb usb3: SerialNumber: 0000:00:1a.0
[    3.833372] hub 3-0:1.0: USB hub found
[    3.833380] hub 3-0:1.0: 2 ports detected
[    3.833663] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.833669] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.833678] uhci_hcd 0000:00:1a.1: detected 2 ports
[    3.833712] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    3.833769] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.833771] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.833772] usb usb4: Product: UHCI Host Controller
[    3.833774] usb usb4: Manufacturer: Linux 4.8.0-49-generic uhci_hcd
[    3.833776] usb usb4: SerialNumber: 0000:00:1a.1
[    3.833940] hub 4-0:1.0: USB hub found
[    3.833948] hub 4-0:1.0: 2 ports detected
[    3.834218] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.834224] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    3.834234] uhci_hcd 0000:00:1d.0: detected 2 ports
[    3.834260] uhci_hcd 0000:00:1d.0: irq 23, io base 0x000018a0
[    3.834317] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.834319] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.834321] usb usb5: Product: UHCI Host Controller
[    3.834323] usb usb5: Manufacturer: Linux 4.8.0-49-generic uhci_hcd
[    3.834324] usb usb5: SerialNumber: 0000:00:1d.0
[    3.834485] hub 5-0:1.0: USB hub found
[    3.834492] hub 5-0:1.0: 2 ports detected
[    3.834767] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.834773] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    3.834782] uhci_hcd 0000:00:1d.1: detected 2 ports
[    3.834818] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018c0
[    3.834877] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.834879] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.834880] usb usb6: Product: UHCI Host Controller
[    3.834882] usb usb6: Manufacturer: Linux 4.8.0-49-generic uhci_hcd
[    3.834884] usb usb6: SerialNumber: 0000:00:1d.1
[    3.835052] hub 6-0:1.0: USB hub found
[    3.835062] hub 6-0:1.0: 2 ports detected
[    3.835338] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.835344] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    3.835353] uhci_hcd 0000:00:1d.2: detected 2 ports
[    3.835379] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
[    3.835435] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.835437] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.835439] usb usb7: Product: UHCI Host Controller
[    3.835440] usb usb7: Manufacturer: Linux 4.8.0-49-generic uhci_hcd
[    3.835442] usb usb7: SerialNumber: 0000:00:1d.2
[    3.835607] hub 7-0:1.0: USB hub found
[    3.835614] hub 7-0:1.0: 2 ports detected
[    3.835821] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.840243] i8042: Detected active multiplexing controller, rev 1.1
[    3.843205] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.843209] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.843255] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.843299] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.843340] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.843581] mousedev: PS/2 mouse device common for all mice
[    3.843926] rtc_cmos 00:03: RTC can wake from S4
[    3.844159] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.844195] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.844204] i2c /dev entries driver
[    3.844287] device-mapper: uevent: version 1.0.3
[    3.844415] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    3.844473] ledtrig-cpu: registered to indicate activity on CPUs
[    3.845004] NET: Registered protocol family 10
[    3.845323] NET: Registered protocol family 17
[    3.845332] Key type dns_resolver registered
[    3.845568] microcode: sig=0x6fa, pf=0x80, revision=0x91
[    3.845643] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.845868] registered taskstats version 1
[    3.845873] Loading compiled-in X.509 certificates
[    3.850036] Loaded X.509 cert 'Build time autogenerated kernel key: 2dfbf108cf5cc1a4cb9675099e53cc52c1ef4808'
[    3.850068] zswap: loaded using pool lzo/zbud
[    3.867009] Key type big_key registered
[    3.869314] Key type trusted registered
[    3.871583] Key type encrypted registered
[    3.871586] AppArmor: AppArmor sha1 policy hashing enabled
[    3.884292] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    3.984151] random: fast init done
[    4.000811] ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WP03, max UDMA/33
[    4.024458] ata1.01: configured for UDMA/33
[    4.030135] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WP03 PQ: 0 ANSI: 5
[    4.055509] sr 0:0:1:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.055512] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.055793] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    4.055925] sr 0:0:1:0: Attached scsi generic sg0 type 5
[    4.140196] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    4.160036] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    4.297232] usb 1-1: New USB device found, idVendor=064e, idProduct=a101
[    4.297236] usb 1-1: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    4.297239] usb 1-1: Product: Acer CrystalEye webcam
[    4.297242] usb 1-1: Manufacturer: SuYin
[    4.297245] usb 1-1: SerialNumber: CN0314-OV03-VA-R02.00.00
[    4.308440] usb 2-1: New USB device found, idVendor=eb1a, idProduct=2821
[    4.308444] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.564116] usb 6-1: new low-speed USB device number 2 using uhci_hcd
[    4.576246] evm: HMAC attrs: 0x1
[    4.576947]   Magic number: 13:43:933
[    4.577152] rtc_cmos 00:03: setting system clock to 2017-04-28 10:56:49 UTC (1493377009)
[    4.577812] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.577813] EDD information not available.
[    4.577892] PM: Hibernation image not present or could not be loaded.
[    4.579786] Freeing unused kernel memory: 1548K (ffffffffbdf6a000 - ffffffffbe0ed000)
[    4.579787] Write protecting the kernel read-only data: 14336k
[    4.580735] Freeing unused kernel memory: 1396K (ffffa142a1ea3000 - ffffa142a2000000)
[    4.581656] Freeing unused kernel memory: 260K (ffffa142a23bf000 - ffffa142a2400000)
[    4.592306] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    4.673844] [drm] Initialized drm 1.1.0 20060810
[    4.674216] pps_core: LinuxPPS API ver. 1 registered
[    4.674218] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    4.685830] PTP clock support registered
[    4.692834] wmi: Mapper loaded
[    4.692911] [Firmware Bug]: ACPI(EVGA) defines _DOD but not _DOS
[    4.692960] ACPI: Video Device [EVGA] (multi-head: yes  rom: no  post: no)
[    4.696817] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    4.698375] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    4.698376] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    4.698672] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.731985] sdhci: Secure Digital Host Controller Interface driver
[    4.731987] sdhci: Copyright(c) Pierre Ossman
[    4.737320] sdhci-pci 0000:0a:04.2: SDHCI controller found [1217:7120] (rev 1)
[    4.737340] pci 0000:00:1e.0: enabling device (0004 -> 0007)
[    4.737367] sdhci-pci 0000:0a:04.2: enabling device (0000 -> 0002)
[    4.744503] mmc0: SDHCI controller on PCI [0000:0a:04.2] using PIO
[    4.751100] usb 6-1: New USB device found, idVendor=046d, idProduct=c05a
[    4.751103] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.751106] usb 6-1: Product: USB Optical Mouse
[    4.751107] usb 6-1: Manufacturer: Logitech
[    4.754085] [drm] radeon kernel modesetting enabled.
[    4.757403] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    4.757405] AMD IOMMUv2 functionality not available on this system
[    4.764051] CRAT table not found
[    4.764052] Finished initializing topology ret=0
[    4.764064] kfd kfd: Initialized module
[    4.764303] checking generic (f0000000 1e0000) vs hw (f0000000 4000000)
[    4.764304] fb: switching to radeondrmfb from VESA VGA
[    4.764341] Console: switching to colour dummy device 80x25
[    4.765699] [drm] initializing kernel modesetting (RV610 0x1002:0x94C8 0x1025:0x011A 0x00).
[    4.765713] [drm] register mmio base: 0xFC000000
[    4.765714] [drm] register mmio size: 65536
[    4.765812] ATOM BIOS: Pantanal
[    4.765837] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
[    4.765839] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 0x000000002FFFFFFF
[    4.765841] [drm] Detected VRAM RAM=256M, BAR=64M
[    4.765842] [drm] RAM width 64bits DDR
[    4.767738] [TTM] Zone  kernel: Available graphics memory: 1989652 kiB
[    4.767740] [TTM] Initializing pool allocator
[    4.767747] [TTM] Initializing DMA pool allocator
[    4.767781] [drm] radeon: 256M of VRAM memory ready
[    4.767782] [drm] radeon: 512M of GTT memory ready.
[    4.767805] [drm] Loading RV610 Microcode
[    4.767893] [drm] radeon: power management initialized
[    4.767972] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    4.778255] acpi device:03: registered as cooling_device3
[    4.778330] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input9
[    4.779211] [drm] PCIE GART of 512M enabled (table at 0x0000000000142000).
[    4.779270] radeon 0000:01:00.0: WB enabled
[    4.779274] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000010000c00 and cpu addr 0xffffa143ae7e2c00
[    4.779802] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x00000000000521d0 and cpu addr 0xffffc59c808121d0
[    4.779804] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.779805] [drm] Driver supports precise vblank timestamp query.
[    4.779806] radeon 0000:01:00.0: radeon: MSI limited to 32-bit
[    4.779857] radeon 0000:01:00.0: radeon: using MSI.
[    4.779895] [drm] radeon: irq initialized.
[    4.804204] firewire_ohci 0000:0a:04.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x10
[    4.811870] [drm] ring test on 0 succeeded in 1 usecs
[    4.873616] firewire_ohci 0000:0a:07.0: added OHCI v1.10 device as card 1, 4 IR + 8 IT contexts, quirks 0x2
[    4.986598] [drm] ring test on 5 succeeded in 1 usecs
[    4.986607] [drm] UVD initialized successfully.
[    4.987123] [drm] ib test on ring 0 succeeded in 0 usecs
[    5.004405] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:a0:d1:a3:53:a5
[    5.004407] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.004448] e1000e 0000:00:19.0 eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
[    5.004618] ahci 0000:00:1f.2: version 3.0
[    5.004975] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    5.004978] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    5.005809] scsi host2: ahci
[    5.005954] scsi host3: ahci
[    5.006084] scsi host4: ahci
[    5.006163] ata3: SATA max UDMA/133 abar m2048@0xfc426000 port 0xfc426100 irq 31
[    5.006167] ata4: SATA max UDMA/133 abar m2048@0xfc426000 port 0xfc426180 irq 31
[    5.006172] ata5: SATA max UDMA/133 abar m2048@0xfc426000 port 0xfc426200 irq 31
[    5.141821] e1000e 0000:00:19.0 enp0s25: renamed from eth0
[    5.142352] hidraw: raw HID events driver (C) Jiri Kosina
[    5.157475] usbcore: registered new interface driver usbhid
[    5.157477] usbhid: USB HID core driver
[    5.159724] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/0003:046D:C05A.0001/input/input14
[    5.159914] hid-generic 0003:046D:C05A.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.1-1/input0
[    5.312280] firewire_core 0000:0a:04.0: created device fw0: GUID 00a0d1a0d1a353a6, S400
[    5.320109] ata5: SATA link down (SStatus 0 SControl 300)
[    5.320146] ata4: SATA link down (SStatus 0 SControl 300)
[    5.376376] firewire_core 0000:0a:07.0: created device fw1: GUID 00a0d1a0d1a353a5, S400
[    5.500121] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.500812] ata3.00: unexpected _GTF length (8)
[    5.512058] usb 7-2: new full-speed USB device number 2 using uhci_hcd
[    5.557030] psmouse serio4: synaptics: Touchpad model: 1, fw: 6.3, id: 0x9280b1, caps: 0xa04793/0x304000/0x0/0x0, board id: 0, fw id: 254899
[    5.557041] psmouse serio4: synaptics: serio: Synaptics pass-through port at isa0060/serio4/input0
[    5.594645] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input13
[    5.664127] [drm] ib test on ring 5 succeeded
[    5.665399] [drm] Radeon Display Connectors
[    5.665401] [drm] Connector 0:
[    5.665401] [drm]   VGA-1
[    5.665403] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    5.665404] [drm]   Encoders:
[    5.665405] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.665406] [drm] Connector 1:
[    5.665407] [drm]   HDMI-A-1
[    5.665407] [drm]   HPD1
[    5.665409] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    5.665410] [drm]   Encoders:
[    5.665410] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[    5.665411] [drm] Connector 2:
[    5.665412] [drm]   LVDS-1
[    5.665413] [drm]   DDC: 0xac0 0xac0 0xac4 0xac4 0xac8 0xac8 0xacc 0xacc
[    5.665414] [drm]   Encoders:
[    5.665415] [drm]     LCD1: INTERNAL_LVTM1
[    5.665416] [drm] Connector 3:
[    5.665417] [drm]   DIN-1
[    5.665417] [drm]   Encoders:
[    5.665418] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    5.824679] ata3.00: ATA-7: TOSHIBA MK1637GSX, DL050J, max UDMA/100
[    5.824682] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    5.825722] ata3.00: unexpected _GTF length (8)
[    5.826045] ata3.00: configured for UDMA/100
[    5.826346] scsi 2:0:0:0: Direct-Access     ATA      TOSHIBA MK1637GS 0J   PQ: 0 ANSI: 5
[    5.860496] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    5.860523] sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    5.860618] sd 2:0:0:0: [sda] Write Protect is off
[    5.860621] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.860696] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.909122] usb 7-2: New USB device found, idVendor=147e, idProduct=2016
[    5.909126] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.909129] usb 7-2: Product: Fingerprint Sensor   
[    5.909132] usb 7-2: Manufacturer: TouchStrip        
[    5.944685]  sda: sda1 sda2 sda3 < sda5 sda6 > sda4
[    5.945566] sd 2:0:0:0: [sda] Attached SCSI disk
[    6.166051] [drm] fb mappable at 0xF0243000
[    6.166053] [drm] vram apper at 0xF0000000
[    6.166054] [drm] size 4096000
[    6.166055] [drm] fb depth is 24
[    6.166056] [drm]    pitch is 5120
[    6.166206] fbcon: radeondrmfb (fb0) is primary device
[    6.166302] Console: switching to colour frame buffer device 160x50
[    6.166336] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    6.180092] [drm] Initialized radeon 2.46.0 20080528 for 0000:01:00.0 on minor 0
[    7.248253] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    7.339021] input: PS/2 Generic Mouse as /devices/platform/i8042/serio4/serio5/input/input15
[    8.337107] random: crng init done
[    9.058811] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
[    9.058965] systemd[1]: Detected architecture x86-64.
[    9.072950] systemd[1]: Set hostname to <GT-TravelMate-6592G>.
[   11.422604] systemd[1]: Reached target Remote File Systems (Pre).
[   11.422790] systemd[1]: Created slice System Slice.
[   11.422823] systemd[1]: Reached target Remote File Systems.
[   11.422880] systemd[1]: Listening on fsck to fsckd communication Socket.
[   11.422930] systemd[1]: Listening on Syslog Socket.
[   11.422977] systemd[1]: Listening on Journal Socket (/dev/log).
[   11.423035] systemd[1]: Listening on Journal Socket.
[   12.386953] lp: driver loaded but no devices found
[   12.483870] ppdev: user-space parallel port driver
[   12.541372] parport_pc 00:05: [io  0x0378-0x037f]
[   12.541377] parport_pc 00:05: [io  0x0778-0x077f]
[   12.541554] parport_pc 00:05: [io  0x0278-0x027f]
[   12.541557] parport_pc 00:05: [io  0x0678-0x067f]
[   12.541729] parport_pc 00:05: [io  0x03bc-0x03bf]
[   12.541732] parport_pc 00:05: [io  0x07bc-0x07bf]
[   12.541902] parport_pc 00:05: unable to assign resources
[   12.541909] parport_pc: probe of 00:05 failed with error -16
[   12.699838] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.114368] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   13.545743] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   15.553479] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
[   15.728484] systemd-journald[242]: Received request to flush runtime journal from PID 1
[   16.134695] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   16.393111] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102F conflicts with OpRegion 0x0000000000001000-0x000000000000107F (\PMIO) (20160422/utaddress-255)
[   16.393119] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   16.393125] ACPI Warning: SystemIO range 0x00000000000011B0-0x00000000000011BF conflicts with OpRegion 0x0000000000001180-0x00000000000011BB (\GPIO) (20160422/utaddress-255)
[   16.393129] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   16.393130] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011AF conflicts with OpRegion 0x0000000000001180-0x00000000000011BB (\GPIO) (20160422/utaddress-255)
[   16.393135] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   16.393135] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   16.688534] yenta_cardbus 0000:0a:04.1: enabling device (0080 -> 0083)
[   16.688644] yenta_cardbus 0000:0a:04.1: CardBus bridge found [1025:011a]
[   16.688686] yenta_cardbus 0000:0a:04.1: CardBus bridge to [bus 0b]
[   16.688688] yenta_cardbus 0000:0a:04.1:   bridge window [io  0x7000-0x70ff]
[   16.688697] yenta_cardbus 0000:0a:04.1:   bridge window [io  0x7400-0x74ff]
[   16.688707] yenta_cardbus 0000:0a:04.1:   bridge window [mem 0xc0400000-0xc07fffff]
[   16.688716] yenta_cardbus 0000:0a:04.1:   bridge window [mem 0xcc000000-0xcfffffff]
[   16.824954] yenta_cardbus 0000:0a:04.1: ISA IRQ mask 0x0000, PCI irq 20
[   16.824960] yenta_cardbus 0000:0a:04.1: Socket status: 30000410
[   16.824966] yenta_cardbus 0000:0a:04.1: pcmcia: parent PCI bridge window: [io  0x7000-0x7fff]
[   16.824968] yenta_cardbus 0000:0a:04.1: pcmcia: parent PCI bridge window: [mem 0xfc100000-0xfc1fffff]
[   16.824971] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfc100000-0xfc1fffff:
[   16.824975]  excluding 0xfc100000-0xfc10ffff
[   16.825814] yenta_cardbus 0000:0a:05.0: CardBus bridge found [1025:011a]
[   16.825853] yenta_cardbus 0000:0a:05.0: O2: enabling read prefetch/write burst. If you experience problems or performance issues, use the yenta_socket parameter 'o2_speedup=off'
[   16.960989] yenta_cardbus 0000:0a:05.0: ISA IRQ mask 0x04b0, PCI irq 21
[   16.960995] yenta_cardbus 0000:0a:05.0: Socket status: 30000006
[   16.960999] pci_bus 0000:0a: Raising subordinate bus# of parent bus (#0a) from #0c to #0f
[   16.961008] yenta_cardbus 0000:0a:05.0: pcmcia: parent PCI bridge window: [io  0x7000-0x7fff]
[   16.961010] yenta_cardbus 0000:0a:05.0: pcmcia: parent PCI bridge window: [mem 0xfc100000-0xfc1fffff]
[   16.961013] pcmcia_socket pcmcia_socket1: cs: memory probe 0xfc100000-0xfc1fffff:
[   16.961017]  excluding 0xfc100000-0xfc10ffff
[   17.389229] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC268: line_outs=1 (0x15/0x0/0x0/0x0/0x0) type:speaker
[   17.389233] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   17.389235] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   17.389237] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   17.389239] snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x1e/0x0
[   17.389241] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   17.389243] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x19
[   17.389246] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x18
[   17.389247] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[   17.405067] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
[   17.405069] iwl4965: Copyright(c) 2003-2011 Intel Corporation
[   17.405142] iwl4965 0000:06:00.0: can't disable ASPM; OS doesn't have ASPM control
[   17.405339] iwl4965 0000:06:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[   17.429055] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   17.429151] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[   17.429240] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[   17.448212] iwl4965 0000:06:00.0: device EEPROM VER=0x36, CALIB=0x5
[   17.453403] iwl4965 0000:06:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
[   17.653646] iwl4965 0000:06:00.0: loaded firmware version 228.61.2.24
[   17.740064] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
[   17.740070] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfc110000-0xfc1fffff:
[   17.762266]  excluding 0xfc1fe000-0xfc20bfff
[   17.763033] pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 20)
[   17.857155] ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
[   17.979784] intel_powerclamp: No package C-state available
[   17.987864] media: Linux media interface: v0.10
[   18.036730] Linux video capture interface: v2.00
[   18.326750] em28xx: New device   @ 480 Mbps (eb1a:2821, interface 0, class 0)
[   18.326753] em28xx: Video interface 0 found: bulk isoc
[   18.327597] uvcvideo: Found UVC 1.00 device Acer CrystalEye webcam (064e:a101)
[   18.327639] em28xx: chip ID is em2710/2820
[   18.330249] uvcvideo 1-1:1.0: Entity type for entity Extension 4 was not initialized!
[   18.330255] uvcvideo 1-1:1.0: Entity type for entity Processing 3 was not initialized!
[   18.330259] uvcvideo 1-1:1.0: Entity type for entity Camera 1 was not initialized!
[   18.330399] input: Acer CrystalEye webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input19
[   18.330494] usbcore: registered new interface driver uvcvideo
[   18.330495] USB Video Class driver (1.1.1)
[   18.432946] em2710/2820 #0: board has no eeprom
[   18.512202] em2710/2820 #0: No sensor detected
[   18.526402] em2710/2820 #0: found i2c device @ 0x4a on bus 0 [saa7113h]
[   18.562657] em2710/2820 #0: Your board has no unique USB ID.
[   18.562665] em2710/2820 #0: A hint were successfully done, based on i2c devicelist hash.
[   18.562669] em2710/2820 #0: This method is not 100% failproof.
[   18.562672] em2710/2820 #0: If the board were missdetected, please email this log to:
[   18.562675] em2710/2820 #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
[   18.562678] em2710/2820 #0: Board detected as EM2860/SAA711X Reference Design
[   18.652068] em2710/2820 #0: Identified as EM2860/SAA711X Reference Design (card=19)
[   18.652072] em2710/2820 #0: analog set to isoc mode.
[   18.652299] em28xx audio device (eb1a:2821): interface 1, class 1
[   18.652326] em28xx audio device (eb1a:2821): interface 2, class 1
[   18.652363] usbcore: registered new interface driver em28xx
[   18.689833] em2710/2820 #0: Registering V4L2 extension
[   18.773262] usbcore: registered new interface driver snd-usb-audio
[   19.311767] saa7115 5-0025: saa7113 found @ 0x4a (em2710/2820 #0)
[   19.628347] pcmcia_socket pcmcia_socket1: cs: memory probe 0x0c0000-0x0fffff:
[   19.628349] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
[   19.628359]  excluding
[   19.628359]  excluding 0xc0000-0xd7fff
[   19.628361]  0xc0000-0xd3fff
[   19.628367]  0xe0000-0xfffff
[   19.628370]  0xe0000-0xfffff
[   19.628388] pcmcia_socket pcmcia_socket1: cs: memory probe 0xa0000000-0xa0ffffff:
[   19.628390] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
[   19.628401]  excluding 0xa0000000-0xa0ffffff
[   19.628403]  excluding

[   19.628405]  0xa0000000-0xa0ffffff
[   19.628422] pcmcia_socket pcmcia_socket1: cs: memory probe 0x60000000-0x60ffffff:
[   19.628424] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
[   19.628435]  excluding 0x60000000-0x60ffffff
[   19.628437]  excluding 0x60000000-0x60ffffff
[   19.747644] acer_wmi: Acer Laptop ACPI-WMI Extras
[   19.748284] acer_wmi: Function bitmap for Communication Device: 0x17
[   19.748676] input: Acer BMA150 accelerometer as /devices/virtual/input/input20
[   19.760572] iwl4965 0000:06:00.0 wlp6s0: renamed from wlan0
[   19.859246] iwl4965 0000:06:00.0: RF_KILL bit toggled to disable radio.
[   20.372296] em2710/2820 #0: Config register raw data: 0x10
[   20.404163] em2710/2820 #0: AC97 vendor ID = 0xffffffff
[   20.420169] em2710/2820 #0: AC97 features = 0x6a90
[   20.420171] em2710/2820 #0: Empia 202 AC97 audio processor detected
[   22.257947] Adding 4157436k swap on /dev/sda6.  Priority:-1 extents:1 across:4157436k FS
[   23.560235] em2710/2820 #0: V4L2 video device registered as video1
[   23.560239] em2710/2820 #0: V4L2 extension successfully initialized
[   23.560242] em28xx: Registered (Em28xx v4l2 Extension) extension
[   23.719223] em2710/2820 #0: Registering snapshot button...
[   23.719306] input: em28xx snapshot button as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/input/input21
[   23.719370] em2710/2820 #0: Remote control support is not available for this card.
[   23.719371] em28xx: Registered (Em28xx Input Extension) extension
[   24.940334] audit: type=1400 audit(1493377029.860:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/sbin/dhclient" pid=737 comm="apparmor_parser"
[   24.940344] audit: type=1400 audit(1493377029.860:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=737 comm="apparmor_parser"
[   24.940351] audit: type=1400 audit(1493377029.860:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=737 comm="apparmor_parser"
[   24.940358] audit: type=1400 audit(1493377029.860:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=737 comm="apparmor_parser"
[   24.971429] audit: type=1400 audit(1493377029.888:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/lightdm/lightdm-guest-session" pid=736 comm="apparmor_parser"
[   24.971440] audit: type=1400 audit(1493377029.888:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/lightdm/lightdm-guest-session//chromium" pid=736 comm="apparmor_parser"
[   25.064546] audit: type=1400 audit(1493377029.984:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince" pid=738 comm="apparmor_parser"
[   25.064559] audit: type=1400 audit(1493377029.984:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince//sanitized_helper" pid=738 comm="apparmor_parser"
[   25.064566] audit: type=1400 audit(1493377029.984:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince-previewer" pid=738 comm="apparmor_parser"
[   25.064573] audit: type=1400 audit(1493377029.984:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince-previewer//sanitized_helper" pid=738 comm="apparmor_parser"
[   38.087686] IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
[   38.544396] IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
[   38.594150] IPv6: ADDRCONF(NETDEV_UP): wlp6s0: link is not ready
[   39.359518] audit_printk_skb: 36 callbacks suppressed
[   39.359520] audit: type=1400 audit(1493377044.280:24): apparmor="DENIED" operation="open" profile="/usr/sbin/mysqld" name="/proc/998/status" pid=998 comm="mysqld" requested_mask="r" denied_mask="r" fsuid=124 ouid=124
[   39.359562] audit: type=1400 audit(1493377044.280:25): apparmor="DENIED" operation="open" profile="/usr/sbin/mysqld" name="/sys/devices/system/node/" pid=998 comm="mysqld" requested_mask="r" denied_mask="r" fsuid=124 ouid=0
[   39.359624] audit: type=1400 audit(1493377044.280:26): apparmor="DENIED" operation="open" profile="/usr/sbin/mysqld" name="/proc/998/status" pid=998 comm="mysqld" requested_mask="r" denied_mask="r" fsuid=124 ouid=124
[   39.848979] e1000e: enp0s25 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   39.849094] e1000e 0000:00:19.0 enp0s25: 10/100 speed: disabling TSO
[   39.849134] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s25: link becomes ready
[   43.842211] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=23499 PROTO=UDP SPT=56375 DPT=8612 LEN=24 
[   50.925323] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=43459 PROTO=UDP SPT=52276 DPT=8612 LEN=24 
[   58.008793] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=37056 PROTO=UDP SPT=61737 DPT=8612 LEN=24 
[   62.519313] [UFW BLOCK] IN=enp0s25 OUT= MAC=00:a0:d1:a3:53:a5:00:15:2c:5a:b0:40:08:00 SRC=123.207.0.221 DST=143.225.238.73 LEN=40 TOS=0x00 PREC=0x00 TTL=235 ID=63686 PROTO=TCP SPT=46259 DPT=23 WINDOW=1024 RES=0x00 SYN URGP=0 
[   65.092674] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=11930 PROTO=UDP SPT=59369 DPT=8612 LEN=24 
[   67.632553] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=11267 PROTO=2 
[   72.174624] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=7375 PROTO=UDP SPT=61658 DPT=8612 LEN=24 
[   79.259110] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=42709 PROTO=UDP SPT=64175 DPT=8612 LEN=24 
[   86.343357] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=6062 PROTO=UDP SPT=54791 DPT=8612 LEN=24 
[   86.711847] [UFW BLOCK] IN=enp0s25 OUT= MAC=00:a0:d1:a3:53:a5:00:15:2c:5a:b0:40:08:00 SRC=191.54.102.229 DST=143.225.238.73 LEN=44 TOS=0x00 PREC=0x00 TTL=42 ID=38832 PROTO=TCP SPT=41458 DPT=23 WINDOW=46050 RES=0x00 SYN URGP=0 
[   93.426150] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=57999 PROTO=UDP SPT=53995 DPT=8612 LEN=24 
[  100.509841] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=65199 PROTO=UDP SPT=53914 DPT=8612 LEN=24 
[  107.594074] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=212 PROTO=UDP SPT=60193 DPT=8612 LEN=24 
[  127.664045] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=14132 PROTO=2 
[  150.095506] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=58359 PROTO=UDP SPT=55740 DPT=8612 LEN=24 
[  164.264040] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=27594 PROTO=UDP SPT=50771 DPT=8612 LEN=24 
[  185.514591] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=47956 PROTO=UDP SPT=57828 DPT=8612 LEN=24 
[  206.763831] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=43537 PROTO=UDP SPT=58358 DPT=8612 LEN=24 
[  227.002613] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=35948 PROTO=UDP SPT=65186 DPT=8612 LEN=24 
[  228.297023] guvcview[1902]: segfault at 10 ip 00007fda40e21d44 sp 00007fff9324dad0 error 4 in libpthread-2.23.so[7fda40e18000+18000]
[  247.679116] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=19683 PROTO=2 
[  269.499100] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=54530 PROTO=UDP SPT=50275 DPT=8612 LEN=24 
[  290.747830] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=38267 PROTO=UDP SPT=58800 DPT=8612 LEN=24 
[  304.913091] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=6968 PROTO=UDP SPT=58945 DPT=8612 LEN=24 
[  326.162270] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=46440 PROTO=UDP SPT=49452 DPT=8612 LEN=24 
[  347.410154] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=4138 PROTO=UDP SPT=52359 DPT=8612 LEN=24 
[  367.710367] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=25409 PROTO=2 
[  387.819457] perf: interrupt took too long (2507 > 2500), lowering kernel.perf_event_max_sample_rate to 79750
[  389.913249] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=36780 PROTO=UDP SPT=58466 DPT=8612 LEN=24 
[  404.081127] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=52634 PROTO=UDP SPT=55898 DPT=8612 LEN=24 
[  425.330522] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=13553 PROTO=UDP SPT=55225 DPT=8612 LEN=24 
[  446.579222] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=20140 PROTO=UDP SPT=62337 DPT=8612 LEN=24 
[  467.831008] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=57822 PROTO=UDP SPT=57187 DPT=8612 LEN=24 
[  487.741230] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=30871 PROTO=2 
[  510.329784] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=26562 PROTO=UDP SPT=58735 DPT=8612 LEN=24 
[  524.493740] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=22940 PROTO=UDP SPT=52466 DPT=8612 LEN=24 
[  540.709938] perf: interrupt took too long (3145 > 3133), lowering kernel.perf_event_max_sample_rate to 63500
[  545.740255] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=45372 PROTO=UDP SPT=50657 DPT=8612 LEN=24 
[  566.988460] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=54902 PROTO=UDP SPT=57836 DPT=8612 LEN=24 
[  588.237216] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=45577 PROTO=UDP SPT=50654 DPT=8612 LEN=24 
[  607.782409] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=36489 PROTO=2 
[  630.737852] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=41817 PROTO=UDP SPT=56892 DPT=8612 LEN=24 
[  644.905939] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=41779 PROTO=UDP SPT=64998 DPT=8612 LEN=24 
[  666.156170] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=60228 PROTO=UDP SPT=51419 DPT=8612 LEN=24 
[  687.406340] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=30996 PROTO=UDP SPT=54079 DPT=8612 LEN=24 
[  708.655698] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=2865 PROTO=UDP SPT=52807 DPT=8612 LEN=24 
[  727.799786] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=42012 PROTO=2 
[  750.142239] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=1700 PROTO=UDP SPT=60042 DPT=8612 LEN=24 
[  764.308113] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=25563 PROTO=UDP SPT=52125 DPT=8612 LEN=24 
[  785.558081] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=22769 PROTO=UDP SPT=50608 DPT=8612 LEN=24 
[  806.806717] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=40092 PROTO=UDP SPT=56317 DPT=8612 LEN=24 
[  828.054870] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=33508 PROTO=UDP SPT=62059 DPT=8612 LEN=24 
[  847.834899] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=47563 PROTO=2 
[  870.555705] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=27026 PROTO=UDP SPT=62004 DPT=8612 LEN=24 
[  884.722242] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=38618 PROTO=UDP SPT=55306 DPT=8612 LEN=24 
[  905.971837] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=57951 PROTO=UDP SPT=59453 DPT=8612 LEN=24 
[  927.219863] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=5144 PROTO=UDP SPT=56401 DPT=8612 LEN=24 
[  948.472252] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=14144 PROTO=UDP SPT=62659 DPT=8612 LEN=24 
[  967.866028] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=53342 PROTO=2 
[  983.889495] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=29040 PROTO=UDP SPT=56931 DPT=8612 LEN=24 
[ 1005.140568] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=61469 PROTO=UDP SPT=54358 DPT=8612 LEN=24 
[ 1026.391504] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=61047 PROTO=UDP SPT=53225 DPT=8612 LEN=24 
[ 1047.639027] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=38775 PROTO=UDP SPT=50301 DPT=8612 LEN=24 
[ 1068.891069] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:26:08:00:95:f4:08:00 SRC=143.225.238.9 DST=224.0.0.1 LEN=44 TOS=0x00 PREC=0x00 TTL=1 ID=10619 PROTO=UDP SPT=50944 DPT=8612 LEN=24 
[ 1087.897375] [UFW BLOCK] IN=enp0s25 OUT= MAC=01:00:5e:00:00:01:00:15:2c:5a:b0:40:08:00 SRC=143.225.238.65 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=58754 PROTO=2 

--------------40C4E9FA5335B47336A6B795
Content-Type: text/plain; charset=UTF-8;
 name="lsusb_output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb_output.txt"

Bus 002 Device 002: ID eb1a:2821 eMPIA Technology, Inc. 
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 007 Device 002: ID 147e:2016 Upek Biometric Touchchip/Touchstrip Fingerprint Sensor
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 002: ID 046d:c05a Logitech, Inc. M90/M100 Optical Mouse
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 064e:a101 Suyin Corp. Acer CrystalEye Webcam
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

--------------40C4E9FA5335B47336A6B795--
