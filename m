Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.60]:3253 "EHLO
        out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbeEQHOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 03:14:04 -0400
Received: from anon.gotu.dk (unknown [128.76.197.190])
        (Authenticated sender: gotu.dk@noip-smtp)
        by smtp-auth.no-ip.com (Postfix) with ESMTPA id EEAD5281
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 00:07:23 -0700 (PDT)
Received: from mkjlap (mkjlap.gotu.lan [172.18.134.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by anon.gotu.dk (Postfix) with ESMTPSA id 42D2760063
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 09:07:22 +0200 (CEST)
From: mkj@gotu.dk (Martin =?utf-8?Q?Kj=C3=A6r_J=C3=B8rgensen?=)
To: linux-media@vger.kernel.org
Subject: Webcam produces error on Dell XPS 9370, but seems to work
Date: Thu, 17 May 2018 09:07:21 +0200
Message-ID: <877eo269qu.fsf@mkjlap.gotu.lan>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using my webcom on my Dell XPS 9370, running latest Debian buster/sid
produces a error in dmesg when running guvcview, though it seems the camera
works fine from a user perspective.

Full dmesg is:

[    0.000000] Linux version 4.16.0-1-amd64 (debian-kernel@lists.debian.org) (gcc version 7.3.0 (Debian 7.3.0-17)) #1 SMP Debian 4.16.5-1 (2018-04-29)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.16.0-1-amd64 root=UUID=8f621675-b0e5-4ac7-8ef1-604cb643d57d ro loglevel=0
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000002d6d8fff] usable
[    0.000000] BIOS-e820: [mem 0x000000002d6d9000-0x000000002d6d9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000002d6da000-0x000000002d6dafff] reserved
[    0.000000] BIOS-e820: [mem 0x000000002d6db000-0x000000003ecdcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000003ecdd000-0x000000003f09afff] reserved
[    0.000000] BIOS-e820: [mem 0x000000003f09b000-0x000000003f0e7fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000003f0e8000-0x000000003f79ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000003f7a0000-0x000000003ff26fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000003ff27000-0x000000003fffefff] type 20
[    0.000000] BIOS-e820: [mem 0x000000003ffff000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x0000000047ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000048000000-0x0000000048dfffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000048e00000-0x000000004f7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000004ae7fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.40 by American Megatrends
[    0.000000] efi:  ACPI=0x3f0ab000  ACPI 2.0=0x3f0ab000  SMBIOS=0xf0000  SMBIOS 3.0=0xf0020  ESRT=0x3fdd9018  MEMATTR=0x3c2a1298 
[    0.000000] secureboot: Secure boot could not be determined (mode 0)
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: Dell Inc. XPS 13 9370/0F6P3V, BIOS 1.3.2 05/07/2018
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x4ae800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask 7F80000000 uncachable
[    0.000000]   1 base 0060000000 mask 7FE0000000 uncachable
[    0.000000]   2 base 0050000000 mask 7FF0000000 uncachable
[    0.000000]   3 base 004C000000 mask 7FFC000000 uncachable
[    0.000000]   4 base 004B000000 mask 7FFF000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: last_pfn = 0x48e00 max_arch_pfn = 0x400000000
[    0.000000] esrt: Reserving ESRT space from 0x000000003fdd9018 to 0x000000003fdd9050.
[    0.000000] Base memory trampoline at [        (ptrval)] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x15e2c000, 0x15e2cfff] PGTABLE
[    0.000000] BRK [0x15e2d000, 0x15e2dfff] PGTABLE
[    0.000000] BRK [0x15e2e000, 0x15e2efff] PGTABLE
[    0.000000] BRK [0x15e2f000, 0x15e2ffff] PGTABLE
[    0.000000] BRK [0x15e30000, 0x15e30fff] PGTABLE
[    0.000000] BRK [0x15e31000, 0x15e31fff] PGTABLE
[    0.000000] BRK [0x15e32000, 0x15e32fff] PGTABLE
[    0.000000] BRK [0x15e33000, 0x15e33fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3351f000-0x35a86fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000003F0AB000 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x000000003F0AB0C0 0000FC (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000003F0D19A8 00010C (v05 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x000000003F0AB248 02675D (v02 DELL   CBX3     01072009 INTL 20160422)
[    0.000000] ACPI: FACS 0x000000003F79D180 000040
[    0.000000] ACPI: APIC 0x000000003F0D1AB8 0000BC (v03 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000003F0D1B78 000044 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x000000003F0D1BC0 0000AC (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000003F0D1C70 00003C (v01 DELL   CBX3     01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x000000003F0D1CB0 000038 (v01 DELL   CBX3     01072009 AMI. 0005000B)
[    0.000000] ACPI: SSDT 0x000000003F0D1CE8 000359 (v01 SataRe SataTabl 00001000 INTL 20160422)
[    0.000000] ACPI: BOOT 0x000000003F0D2048 000028 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x000000003F0D2070 0012DE (v02 SaSsdt SaSsdt   00003000 INTL 20160422)
[    0.000000] ACPI: HPET 0x000000003F0D3350 000038 (v01 INTEL  KBL-ULT  00000001 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000003F0D3388 000CEF (v02 INTEL  xh_rvp07 00000000 INTL 20160422)
[    0.000000] ACPI: UEFI 0x000000003F0D4078 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: SSDT 0x000000003F0D40C0 0017AE (v02 CpuRef CpuSsdt  00003000 INTL 20160422)
[    0.000000] ACPI: LPIT 0x000000003F0D5870 000094 (v01 INTEL  KBL-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000003F0D5908 000161 (v02 INTEL  HdaDsp   00000000 INTL 20160422)
[    0.000000] ACPI: SSDT 0x000000003F0D5A70 00029F (v02 INTEL  sensrhub 00000000 INTL 20160422)
[    0.000000] ACPI: SSDT 0x000000003F0D5D10 003002 (v02 INTEL  PtidDevc 00001000 INTL 20160422)
[    0.000000] ACPI: SSDT 0x000000003F0D8D18 000517 (v02 INTEL  TbtTypeC 00000000 INTL 20160422)
[    0.000000] ACPI: DBGP 0x000000003F0D9230 000034 (v01 INTEL           00000002 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x000000003F0D9268 000054 (v00 INTEL           00000002 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000003F0D92C0 000801 (v02 INTEL  UsbCTabl 00001000 INTL 20160422)
[    0.000000] ACPI: SSDT 0x000000003F0D9AC8 00CFC3 (v02 DptfTa DptfTabl 00001000 INTL 20160422)
[    0.000000] ACPI: NHLT 0x000000003F0E6A90 00002D (v00 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: BGRT 0x000000003F0E6AC0 000038 (v00                 01072009 AMI  00010013)
[    0.000000] ACPI: TPM2 0x000000003F0E6AF8 000034 (v03 DELL   CBX3     00000001 AMI  00000000)
[    0.000000] ACPI: ASF! 0x000000003F0E6B30 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: DMAR 0x000000003F0E6BD0 0000F0 (v01 INTEL  KBL      00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000004ae7fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x4ae7fa000-0x4ae7fefff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x00000004ae7fffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000002d6d8fff]
[    0.000000]   node   0: [mem 0x000000002d6db000-0x000000003ecdcfff]
[    0.000000]   node   0: [mem 0x000000003ffff000-0x000000003fffffff]
[    0.000000]   node   0: [mem 0x0000000048000000-0x0000000048dfffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x00000004ae7fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x00000004ae7fffff]
[    0.000000] On node 0 totalpages: 4121208
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4012 pages used for memmap
[    0.000000]   DMA32 zone: 256732 pages, LIFO batch:31
[    0.000000]   Normal zone: 60320 pages used for memmap
[    0.000000]   Normal zone: 3860480 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 99 pages
[    0.000000] Reserving Intel graphics memory at [mem 0x4b800000-0x4f7fffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x2d6d9000-0x2d6d9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x2d6da000-0x2d6dafff]
[    0.000000] PM: Registered nosave memory: [mem 0x3ecdd000-0x3f09afff]
[    0.000000] PM: Registered nosave memory: [mem 0x3f09b000-0x3f0e7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x3f0e8000-0x3f79ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x3f7a0000-0x3ff26fff]
[    0.000000] PM: Registered nosave memory: [mem 0x3ff27000-0x3fffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x47ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x48e00000-0x4f7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x4f800000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfe010fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe011000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x4f800000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x94/0x478 with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 44 pages/cpu @        (ptrval) s142296 r8192 d29736 u262144
[    0.000000] pcpu-alloc: s142296 r8192 d29736 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 4056790
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.16.0-1-amd64 root=UUID=8f621675-b0e5-4ac7-8ef1-604cb643d57d ro loglevel=0
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16051092K/16484832K available (10252K kernel code, 1182K rwdata, 3124K rodata, 1524K init, 688K bss, 433740K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] ftrace: allocating 29904 entries in 117 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS: 33024, nr_irqs: 2048, preallocated irqs: 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180105
[    0.000000] ACPI: 11 ACPI AML tables successfully acquired and loaded
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.004000] APIC: Switch to symmetric I/O mode setup
[    0.004000] DMAR: Host address width 39
[    0.004000] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.004000] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 19e2ff0505e
[    0.004000] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.004000] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
[    0.004000] DMAR: RMRR base: 0x0000003edb6000 end: 0x0000003edd5fff
[    0.004000] DMAR: RMRR base: 0x0000004b000000 end: 0x0000004f7fffff
[    0.004000] DMAR: ANDD device: 1 name: \_SB.PCI0.I2C0
[    0.004000] DMAR: ANDD device: 2 name: \_SB.PCI0.I2C1
[    0.004000] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.004000] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.004000] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.004000] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.004000] x2apic enabled
[    0.004000] Switched APIC routing to cluster x2apic.
[    0.008000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.028000] tsc: Detected 2000.000 MHz processor
[    0.028000] tsc: Detected 1992.000 MHz TSC
[    0.028000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x396d519840e, max_idle_ns: 881590569543 ns
[    0.028000] Calibrating delay loop (skipped), value calculated using timer frequency.. 3984.00 BogoMIPS (lpj=7968000)
[    0.028000] pid_max: default: 32768 minimum: 301
[    0.028000] Security Framework initialized
[    0.028000] Yama: disabled by default; enable with sysctl kernel.yama.*
[    0.028000] AppArmor: AppArmor initialized
[    0.028000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.033096] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.033138] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.033196] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.033355] CPU: Physical Processor ID: 0
[    0.033356] CPU: Processor Core ID: 0
[    0.033360] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.033360] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.033365] mce: CPU supports 10 MCE banks
[    0.033373] CPU0: Thermal monitoring enabled (TM1)
[    0.033387] process: using mwait in idle threads
[    0.033390] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.033390] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.033391] Spectre V2 : Mitigation: Full generic retpoline
[    0.033391] Spectre V2 : Spectre v2 mitigation: Filling RSB on context switch
[    0.033392] Spectre V2 : Spectre v2 mitigation: Enabling Indirect Branch Prediction Barrier
[    0.033392] Spectre V2 : Enabling Restricted Speculation for firmware calls
[    0.033469] Freeing SMP alternatives memory: 28K
[    0.035570] TSC deadline timer enabled
[    0.035574] smpboot: CPU0: Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz (family: 0x6, model: 0x8e, stepping: 0xa)
[    0.035616] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.035645] ... version:                4
[    0.035646] ... bit width:              48
[    0.035646] ... generic registers:      4
[    0.035646] ... value mask:             0000ffffffffffff
[    0.035647] ... max period:             00007fffffffffff
[    0.035647] ... fixed-purpose events:   3
[    0.035647] ... event mask:             000000070000000f
[    0.035674] Hierarchical SRCU implementation.
[    0.036000] smp: Bringing up secondary CPUs ...
[    0.036000] x86: Booting SMP configuration:
[    0.036000] .... node  #0, CPUs:      #1
[    0.036000] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.036000]  #2 #3 #4 #5 #6 #7
[    0.036451] smp: Brought up 1 node, 8 CPUs
[    0.036451] smpboot: Max logical packages: 1
[    0.036451] smpboot: Total of 8 processors activated (31872.00 BogoMIPS)
[    0.040427] devtmpfs: initialized
[    0.040427] x86/mm: Memory block size: 128MB
[    0.040832] PM: Registering ACPI NVS region [mem 0x2d6d9000-0x2d6d9fff] (4096 bytes)
[    0.040832] PM: Registering ACPI NVS region [mem 0x3f0e8000-0x3f79ffff] (7045120 bytes)
[    0.040832] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.040832] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.040832] pinctrl core: initialized pinctrl subsystem
[    0.040832] NET: Registered protocol family 16
[    0.040832] audit: initializing netlink subsys (disabled)
[    0.040832] audit: type=2000 audit(1526536718.040:1): state=initialized audit_enabled=0 res=1
[    0.040832] cpuidle: using governor ladder
[    0.040832] cpuidle: using governor menu
[    0.040832] Simple Boot Flag at 0x47 set to 0x80
[    0.040832] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.040832] ACPI: bus type PCI registered
[    0.040832] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.040832] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.040832] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.040832] PCI: Using configuration type 1 for base access
[    0.040832] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.040832] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.040832] ACPI: Added _OSI(Module Device)
[    0.040832] ACPI: Added _OSI(Processor Device)
[    0.040832] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.040832] ACPI: Added _OSI(Processor Aggregator Device)
[    0.045050] ACPI BIOS Error (bug): Failure looking up [\_SB.PCI0.RP04.PXSX._SB.PCI0.RP05.PXSX], AE_NOT_FOUND (20180105/dswload2-194)
[    0.045054] ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20180105/psobject-252)
[    0.045055] ACPI Error: Method parse/execution failed \_SB.PCI0.RP04.PXSX, AE_NOT_FOUND (20180105/psparse-550)
[    0.045280] ACPI BIOS Error (bug): Failure looking up [\_SB.PCI0.RP08.PXSX._SB.PCI0.RP09.PXSX], AE_NOT_FOUND (20180105/dswload2-194)
[    0.045282] ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20180105/psobject-252)
[    0.045283] ACPI Error: Method parse/execution failed \_SB.PCI0.RP08.PXSX, AE_NOT_FOUND (20180105/psparse-550)
[    0.046096] ACPI: Executed 49 blocks of module-level executable AML code
[    0.118940] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.123676] ACPI: Dynamic OEM Table Load:
[    0.123685] ACPI: SSDT 0xFFFF8CFB5B83F800 0005CD (v02 PmRef  Cpu0Ist  00003000 INTL 20160422)
[    0.123990] ACPI: Executed 1 blocks of module-level executable AML code
[    0.124106] ACPI: \_PR_.PR00: _OSC native thermal LVT Acked
[    0.125399] ACPI: Dynamic OEM Table Load:
[    0.125406] ACPI: SSDT 0xFFFF8CFB5BBBAC00 0003FF (v02 PmRef  Cpu0Cst  00003001 INTL 20160422)
[    0.125684] ACPI: Executed 1 blocks of module-level executable AML code
[    0.125917] ACPI: Dynamic OEM Table Load:
[    0.125922] ACPI: SSDT 0xFFFF8CFB5B829900 0000BA (v02 PmRef  Cpu0Hwp  00003000 INTL 20160422)
[    0.126169] ACPI: Executed 1 blocks of module-level executable AML code
[    0.126329] ACPI: Dynamic OEM Table Load:
[    0.126335] ACPI: SSDT 0xFFFF8CFB5B838800 000628 (v02 PmRef  HwpLvt   00003000 INTL 20160422)
[    0.126578] ACPI: Executed 1 blocks of module-level executable AML code
[    0.127191] ACPI: Dynamic OEM Table Load:
[    0.127204] ACPI: SSDT 0xFFFF8CFB5BB95000 000D14 (v02 PmRef  ApIst    00003000 INTL 20160422)
[    0.128147] ACPI: Executed 1 blocks of module-level executable AML code
[    0.128383] ACPI: Dynamic OEM Table Load:
[    0.128389] ACPI: SSDT 0xFFFF8CFB5BBB8000 000317 (v02 PmRef  ApHwp    00003000 INTL 20160422)
[    0.128706] ACPI: Executed 1 blocks of module-level executable AML code
[    0.128956] ACPI: Dynamic OEM Table Load:
[    0.128962] ACPI: SSDT 0xFFFF8CFB5BBBD800 00030A (v02 PmRef  ApCst    00003000 INTL 20160422)
[    0.129280] ACPI: Executed 1 blocks of module-level executable AML code
[    0.132739] ACPI: EC: EC started
[    0.132739] ACPI: EC: interrupt blocked
[    0.144153] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as first EC
[    0.144154] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x6e, EC_CMD/EC_SC=0x934, EC_DATA=0x930
[    0.144156] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions
[    0.144156] ACPI: Interpreter enabled
[    0.144201] ACPI: (supports S0 S3 S4 S5)
[    0.144202] ACPI: Using IOAPIC for interrupt routing
[    0.144238] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.144782] ACPI: GPE 0x42 active on init
[    0.144798] ACPI: GPE 0x61 active on init
[    0.144826] ACPI: Enabled 8 GPEs in block 00 to 7F
[    0.176151] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.176151] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.176151] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME AER]
[    0.176151] acpi PNP0A08:00: _OSC: OS now controls [PCIeCapability]
[    0.176151] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.176224] PCI host bridge to bus 0000:00
[    0.176226] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.176227] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.176228] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.176228] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
[    0.176229] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
[    0.176230] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
[    0.176231] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    0.176232] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.176232] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.176233] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.176234] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.176235] pci_bus 0000:00: root bus resource [mem 0x4f800000-0xdfffffff window]
[    0.176235] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7fffff window]
[    0.176237] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.176243] pci 0000:00:00.0: [8086:5914] type 00 class 0x060000
[    0.176342] pci 0000:00:02.0: [8086:5917] type 00 class 0x030000
[    0.176351] pci 0000:00:02.0: reg 0x10: [mem 0xdb000000-0xdbffffff 64bit]
[    0.176356] pci 0000:00:02.0: reg 0x18: [mem 0x50000000-0x5fffffff 64bit pref]
[    0.176359] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.176371] pci 0000:00:02.0: BAR 2: assigned to efifb
[    0.176454] pci 0000:00:04.0: [8086:1903] type 00 class 0x118000
[    0.176465] pci 0000:00:04.0: reg 0x10: [mem 0xdc420000-0xdc427fff 64bit]
[    0.176621] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
[    0.176641] pci 0000:00:14.0: reg 0x10: [mem 0xdc410000-0xdc41ffff 64bit]
[    0.176700] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.176828] pci 0000:00:14.2: [8086:9d31] type 00 class 0x118000
[    0.176847] pci 0000:00:14.2: reg 0x10: [mem 0xdc434000-0xdc434fff 64bit]
[    0.177033] pci 0000:00:15.0: [8086:9d60] type 00 class 0x118000
[    0.177197] pci 0000:00:15.0: reg 0x10: [mem 0xdc433000-0xdc433fff 64bit]
[    0.177403] pci 0000:00:15.1: [8086:9d61] type 00 class 0x118000
[    0.177478] pci 0000:00:15.1: reg 0x10: [mem 0xdc432000-0xdc432fff 64bit]
[    0.177752] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
[    0.177768] pci 0000:00:16.0: reg 0x10: [mem 0xdc431000-0xdc431fff 64bit]
[    0.177811] pci 0000:00:16.0: PME# supported from D3hot
[    0.177939] pci 0000:00:1c.0: [8086:9d10] type 01 class 0x060400
[    0.178004] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.180097] pci 0000:00:1c.2: [8086:9d12] type 01 class 0x060400
[    0.180162] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.180269] pci 0000:00:1c.4: [8086:9d14] type 01 class 0x060400
[    0.180323] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.180429] pci 0000:00:1d.0: [8086:9d18] type 01 class 0x060400
[    0.180484] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.180622] pci 0000:00:1f.0: [8086:9d4e] type 00 class 0x060100
[    0.180764] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
[    0.180775] pci 0000:00:1f.2: reg 0x10: [mem 0xdc42c000-0xdc42ffff]
[    0.180888] pci 0000:00:1f.3: [8086:9d71] type 00 class 0x040380
[    0.180911] pci 0000:00:1f.3: reg 0x10: [mem 0xdc428000-0xdc42bfff 64bit]
[    0.180933] pci 0000:00:1f.3: reg 0x20: [mem 0xdc400000-0xdc40ffff 64bit]
[    0.180973] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.181128] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
[    0.181189] pci 0000:00:1f.4: reg 0x10: [mem 0xdc430000-0xdc4300ff 64bit]
[    0.181259] pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[    0.181751] pci 0000:01:00.0: [10ec:525a] type 00 class 0xff0000
[    0.181779] pci 0000:01:00.0: reg 0x14: [mem 0xdc300000-0xdc300fff]
[    0.181872] pci 0000:01:00.0: supports D1 D2
[    0.181873] pci 0000:01:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.192354] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.192359] pci 0000:00:1c.0:   bridge window [mem 0xdc300000-0xdc3fffff]
[    0.192721] pci 0000:02:00.0: [168c:003e] type 00 class 0x028000
[    0.193056] pci 0000:02:00.0: reg 0x10: [mem 0xdc000000-0xdc1fffff 64bit]
[    0.194273] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.204312] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.204317] pci 0000:00:1c.2:   bridge window [mem 0xdc000000-0xdc1fffff]
[    0.204436] pci 0000:03:00.0: [8086:15d3] type 01 class 0x060400
[    0.204497] pci 0000:03:00.0: enabling Extended Tags
[    0.204580] pci 0000:03:00.0: supports D1 D2
[    0.204582] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.204682] pci 0000:00:1c.4: PCI bridge to [bus 03-6d]
[    0.204687] pci 0000:00:1c.4:   bridge window [mem 0xac000000-0xda0fffff]
[    0.204692] pci 0000:00:1c.4:   bridge window [mem 0x60000000-0xa9ffffff 64bit pref]
[    0.204786] pci 0000:04:00.0: [8086:15d3] type 01 class 0x060400
[    0.204849] pci 0000:04:00.0: enabling Extended Tags
[    0.204935] pci 0000:04:00.0: supports D1 D2
[    0.204937] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.205026] pci 0000:04:01.0: [8086:15d3] type 01 class 0x060400
[    0.205090] pci 0000:04:01.0: enabling Extended Tags
[    0.205173] pci 0000:04:01.0: supports D1 D2
[    0.205174] pci 0000:04:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.205260] pci 0000:04:02.0: [8086:15d3] type 01 class 0x060400
[    0.205324] pci 0000:04:02.0: enabling Extended Tags
[    0.205406] pci 0000:04:02.0: supports D1 D2
[    0.205408] pci 0000:04:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.205507] pci 0000:04:04.0: [8086:15d3] type 01 class 0x060400
[    0.205571] pci 0000:04:04.0: enabling Extended Tags
[    0.205654] pci 0000:04:04.0: supports D1 D2
[    0.205655] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.205761] pci 0000:03:00.0: PCI bridge to [bus 04-6d]
[    0.205770] pci 0000:03:00.0:   bridge window [mem 0xac000000-0xda0fffff]
[    0.205778] pci 0000:03:00.0:   bridge window [mem 0x60000000-0xa9ffffff 64bit pref]
[    0.205824] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.205834] pci 0000:04:00.0:   bridge window [mem 0xda000000-0xda0fffff]
[    0.205889] pci 0000:04:01.0: PCI bridge to [bus 06-38]
[    0.205899] pci 0000:04:01.0:   bridge window [mem 0xac000000-0xc3efffff]
[    0.205906] pci 0000:04:01.0:   bridge window [mem 0x60000000-0x7fffffff 64bit pref]
[    0.205963] pci 0000:04:02.0: PCI bridge to [bus 39]
[    0.205973] pci 0000:04:02.0:   bridge window [mem 0xc3f00000-0xc3ffffff]
[    0.206025] pci 0000:04:04.0: PCI bridge to [bus 3a-6d]
[    0.206034] pci 0000:04:04.0:   bridge window [mem 0xc4000000-0xd9ffffff]
[    0.206041] pci 0000:04:04.0:   bridge window [mem 0x80000000-0xa9ffffff 64bit pref]
[    0.206252] pci 0000:6e:00.0: [1179:0116] type 00 class 0x010802
[    0.206285] pci 0000:6e:00.0: reg 0x10: [mem 0xdc200000-0xdc203fff 64bit]
[    0.216049] pci 0000:00:1d.0: PCI bridge to [bus 6e]
[    0.216054] pci 0000:00:1d.0:   bridge window [mem 0xdc200000-0xdc2fffff]
[    0.217604] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.217604] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.217604] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.217604] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.217604] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.217604] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.217604] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.217604] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.228229] ACPI BIOS Error (bug): Failure looking up [^^PCI0.RP05.PXSX.WIST], AE_NOT_FOUND (20180105/psargs-364)
[    0.228234] ACPI Error: Method parse/execution failed \_SB.PEPD._DSM, AE_NOT_FOUND (20180105/psparse-550)
[    0.232727] ACPI: EC: interrupt unblocked
[    0.232732] ACPI: EC: event unblocked
[    0.232751] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x6e, EC_CMD/EC_SC=0x934, EC_DATA=0x930
[    0.232752] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions and events
[    0.232959] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.232959] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.232959] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.232959] vgaarb: loaded
[    0.232959] pps_core: LinuxPPS API ver. 1 registered
[    0.232959] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.232959] PTP clock support registered
[    0.232959] EDAC MC: Ver: 3.0.0
[    0.232966] Registered efivars operations
[    0.264047] PCI: Using ACPI for IRQ routing
[    0.285138] PCI: pci_cache_line_size set to 64 bytes
[    0.286097] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.286099] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.286099] e820: reserve RAM buffer [mem 0x2d6d9000-0x2fffffff]
[    0.286100] e820: reserve RAM buffer [mem 0x3ecdd000-0x3fffffff]
[    0.286101] e820: reserve RAM buffer [mem 0x48e00000-0x4bffffff]
[    0.286101] e820: reserve RAM buffer [mem 0x4ae800000-0x4afffffff]
[    0.286164] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.286164] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.288012] clocksource: Switched to clocksource tsc-early
[    0.294502] VFS: Disk quotas dquot_6.6.0
[    0.294512] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.294592] AppArmor: AppArmor Filesystem Enabled
[    0.294599] pnp: PnP ACPI init
[    0.294752] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.294753] system 00:00: [io  0xffff] has been reserved
[    0.294754] system 00:00: [io  0xffff] has been reserved
[    0.294755] system 00:00: [io  0xffff] has been reserved
[    0.294756] system 00:00: [io  0x1800-0x18fe] has been reserved
[    0.294757] system 00:00: [io  0x164e-0x164f] has been reserved
[    0.294760] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.294826] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.294847] system 00:02: [io  0x1854-0x1857] has been reserved
[    0.294849] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.294926] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.294943] pnp 00:04: Plug and Play ACPI device, IDs DLL07e6 PNP0f13 (active)
[    0.295083] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.295084] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.295085] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.295086] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.295087] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.295088] system 00:05: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.295089] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.295090] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    0.295091] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.295092] system 00:05: [mem 0xdffe0000-0xdfffffff] has been reserved
[    0.295094] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.295117] system 00:06: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.295118] system 00:06: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.295119] system 00:06: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.295120] system 00:06: [mem 0xfe000000-0xfe01ffff] could not be reserved
[    0.295121] system 00:06: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.295122] system 00:06: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.295123] system 00:06: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.295125] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.295328] system 00:07: [io  0xff00-0xfffe] has been reserved
[    0.295330] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.296030] system 00:08: [mem 0xfe029000-0xfe029fff] has been reserved
[    0.296031] system 00:08: [mem 0xfe028000-0xfe028fff] has been reserved
[    0.296033] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.306741] pnp: PnP ACPI: found 9 devices
[    0.312435] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.312469] pci 0000:04:01.0: bridge window [io  0x1000-0x0fff] to [bus 06-38] add_size 1000
[    0.312478] pci 0000:04:02.0: bridge window [io  0x1000-0x0fff] to [bus 39] add_size 1000
[    0.312480] pci 0000:04:02.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 39] add_size 200000 add_align 100000
[    0.312489] pci 0000:04:04.0: bridge window [io  0x1000-0x0fff] to [bus 3a-6d] add_size 1000
[    0.312498] pci 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04-6d] add_size 3000
[    0.312504] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 03-6d] add_size 3000
[    0.312513] pci 0000:00:1c.4: BAR 13: assigned [io  0x2000-0x4fff]
[    0.312515] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.312521] pci 0000:00:1c.0:   bridge window [mem 0xdc300000-0xdc3fffff]
[    0.312527] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.312530] pci 0000:00:1c.2:   bridge window [mem 0xdc000000-0xdc1fffff]
[    0.312537] pci 0000:03:00.0: BAR 13: assigned [io  0x2000-0x4fff]
[    0.312541] pci 0000:04:02.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.312542] pci 0000:04:02.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.312544] pci 0000:04:01.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.312545] pci 0000:04:02.0: BAR 13: assigned [io  0x3000-0x3fff]
[    0.312546] pci 0000:04:04.0: BAR 13: assigned [io  0x4000-0x4fff]
[    0.312549] pci 0000:04:02.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.312550] pci 0000:04:02.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.312551] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.312556] pci 0000:04:00.0:   bridge window [mem 0xda000000-0xda0fffff]
[    0.312564] pci 0000:04:01.0: PCI bridge to [bus 06-38]
[    0.312567] pci 0000:04:01.0:   bridge window [io  0x2000-0x2fff]
[    0.312571] pci 0000:04:01.0:   bridge window [mem 0xac000000-0xc3efffff]
[    0.312575] pci 0000:04:01.0:   bridge window [mem 0x60000000-0x7fffffff 64bit pref]
[    0.312581] pci 0000:04:02.0: PCI bridge to [bus 39]
[    0.312583] pci 0000:04:02.0:   bridge window [io  0x3000-0x3fff]
[    0.312588] pci 0000:04:02.0:   bridge window [mem 0xc3f00000-0xc3ffffff]
[    0.312596] pci 0000:04:04.0: PCI bridge to [bus 3a-6d]
[    0.312598] pci 0000:04:04.0:   bridge window [io  0x4000-0x4fff]
[    0.312603] pci 0000:04:04.0:   bridge window [mem 0xc4000000-0xd9ffffff]
[    0.312607] pci 0000:04:04.0:   bridge window [mem 0x80000000-0xa9ffffff 64bit pref]
[    0.312612] pci 0000:03:00.0: PCI bridge to [bus 04-6d]
[    0.312615] pci 0000:03:00.0:   bridge window [io  0x2000-0x4fff]
[    0.312619] pci 0000:03:00.0:   bridge window [mem 0xac000000-0xda0fffff]
[    0.312623] pci 0000:03:00.0:   bridge window [mem 0x60000000-0xa9ffffff 64bit pref]
[    0.312628] pci 0000:00:1c.4: PCI bridge to [bus 03-6d]
[    0.312630] pci 0000:00:1c.4:   bridge window [io  0x2000-0x4fff]
[    0.312633] pci 0000:00:1c.4:   bridge window [mem 0xac000000-0xda0fffff]
[    0.312636] pci 0000:00:1c.4:   bridge window [mem 0x60000000-0xa9ffffff 64bit pref]
[    0.312640] pci 0000:00:1d.0: PCI bridge to [bus 6e]
[    0.312643] pci 0000:00:1d.0:   bridge window [mem 0xdc200000-0xdc2fffff]
[    0.312649] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.312651] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.312652] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.312653] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
[    0.312654] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
[    0.312655] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
[    0.312657] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
[    0.312658] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
[    0.312659] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
[    0.312660] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
[    0.312661] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
[    0.312662] pci_bus 0000:00: resource 15 [mem 0x4f800000-0xdfffffff window]
[    0.312663] pci_bus 0000:00: resource 16 [mem 0xfd000000-0xfe7fffff window]
[    0.312665] pci_bus 0000:01: resource 1 [mem 0xdc300000-0xdc3fffff]
[    0.312666] pci_bus 0000:02: resource 1 [mem 0xdc000000-0xdc1fffff]
[    0.312667] pci_bus 0000:03: resource 0 [io  0x2000-0x4fff]
[    0.312668] pci_bus 0000:03: resource 1 [mem 0xac000000-0xda0fffff]
[    0.312669] pci_bus 0000:03: resource 2 [mem 0x60000000-0xa9ffffff 64bit pref]
[    0.312671] pci_bus 0000:04: resource 0 [io  0x2000-0x4fff]
[    0.312672] pci_bus 0000:04: resource 1 [mem 0xac000000-0xda0fffff]
[    0.312673] pci_bus 0000:04: resource 2 [mem 0x60000000-0xa9ffffff 64bit pref]
[    0.312674] pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
[    0.312675] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
[    0.312676] pci_bus 0000:06: resource 1 [mem 0xac000000-0xc3efffff]
[    0.312677] pci_bus 0000:06: resource 2 [mem 0x60000000-0x7fffffff 64bit pref]
[    0.312678] pci_bus 0000:39: resource 0 [io  0x3000-0x3fff]
[    0.312680] pci_bus 0000:39: resource 1 [mem 0xc3f00000-0xc3ffffff]
[    0.312681] pci_bus 0000:3a: resource 0 [io  0x4000-0x4fff]
[    0.312682] pci_bus 0000:3a: resource 1 [mem 0xc4000000-0xd9ffffff]
[    0.312683] pci_bus 0000:3a: resource 2 [mem 0x80000000-0xa9ffffff 64bit pref]
[    0.312684] pci_bus 0000:6e: resource 1 [mem 0xdc200000-0xdc2fffff]
[    0.312826] NET: Registered protocol family 2
[    0.312940] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes)
[    0.312993] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.313178] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.313360] TCP: Hash tables configured (established 131072 bind 65536)
[    0.313392] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.313434] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.313522] NET: Registered protocol family 1
[    0.313531] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.314243] PCI: CLS 128 bytes, default 64
[    0.314279] Unpacking initramfs...
[    0.725457] Freeing initrd memory: 38304K
[    0.725592] DMAR: ACPI device "device:75" under DMAR at fed91000 as 00:15.0
[    0.725594] DMAR: ACPI device "device:76" under DMAR at fed91000 as 00:15.1
[    0.725608] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.725610] software IO TLB [mem 0x373fb000-0x3b3fb000] (64MB) mapped at [        (ptrval)-        (ptrval)]
[    0.725648] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x396d519840e, max_idle_ns: 881590569543 ns
[    0.725668] clocksource: Switched to clocksource tsc
[    0.726183] Initialise system trusted keyrings
[    0.726228] workingset: timestamp_bits=40 max_order=22 bucket_order=0
[    0.726958] zbud: loaded
[    0.902844] Key type asymmetric registered
[    0.902844] Asymmetric key parser 'x509' registered
[    0.902864] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
[    0.902882] io scheduler noop registered
[    0.902883] io scheduler deadline registered
[    0.902921] io scheduler cfq registered (default)
[    0.902921] io scheduler mq-deadline registered
[    0.903481] pcieport 0000:03:00.0: enabling device (0006 -> 0007)
[    0.903787] pcieport 0000:04:01.0: enabling device (0006 -> 0007)
[    0.903927] pcieport 0000:04:02.0: enabling device (0006 -> 0007)
[    0.904085] pcieport 0000:04:04.0: enabling device (0006 -> 0007)
[    0.904235] efifb: probing for efifb
[    0.904244] efifb: framebuffer at 0x50000000, using 32448k, total 32448k
[    0.904244] efifb: mode is 3840x2160x32, linelength=15360, pages=1
[    0.904245] efifb: scrolling: redraw
[    0.904246] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.914678] Console: switching to colour frame buffer device 480x135
[    0.925039] fb0: EFI VGA frame buffer device
[    0.925053] intel_idle: MWAIT substates: 0x11142120
[    0.925053] intel_idle: v0.4.1 model 0x8E
[    0.925278] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.926119] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.926441] Linux agpgart interface v0.103
[    0.926467] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    0.926467] AMD IOMMUv2 functionality not available on this system
[    0.926772] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.927162] i8042: Warning: Keylock active
[    0.928506] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.928508] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.928561] mousedev: PS/2 mouse device common for all mice
[    0.928596] rtc_cmos 00:01: RTC can wake from S4
[    0.929079] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    0.929187] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.929192] intel_pstate: Intel P-state driver initializing
[    0.929384] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.930679] intel_pstate: HWP enabled
[    0.930711] ledtrig-cpu: registered to indicate activity on CPUs
[    0.931047] NET: Registered protocol family 10
[    0.934601] Segment Routing with IPv6
[    0.934614] mip6: Mobile IPv6
[    0.934615] NET: Registered protocol family 17
[    0.934617] mpls_gso: MPLS GSO support
[    0.935050] microcode: sig=0x806ea, pf=0x80, revision=0x84
[    0.935257] microcode: Microcode Update Driver: v2.2.
[    0.935263] sched_clock: Marking stable (935254636, 0)->(1029541642, -94287006)
[    0.935808] registered taskstats version 1
[    0.935809] Loading compiled-in X.509 certificates
[    0.958980] Loaded X.509 cert 'secure-boot-test-key-lfaraone: 97c1b25cddf9873ca78a58f3d73bf727d2cf78ff'
[    0.959110] Loaded X.509 cert 'Debian Project: Ben Hutchings: 008a018dca80932630'
[    0.959121] zswap: loaded using pool lzo/zbud
[    0.959309] AppArmor: AppArmor sha1 policy hashing enabled
[    0.960662] rtc_cmos 00:01: setting system clock to 2018-05-17 05:58:39 UTC (1526536719)
[    0.961749] Freeing unused kernel memory: 1524K
[    0.961749] Write protecting the kernel read-only data: 16384k
[    0.962243] Freeing unused kernel memory: 2008K
[    0.963257] Freeing unused kernel memory: 972K
[    0.965852] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    0.965852] x86/mm: Checking user space page tables
[    0.968381] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.038549] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    1.038628] ACPI: Lid Switch [LID0]
[    1.038684] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    1.038862] ACPI: Power Button [PBTN]
[    1.038924] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input4
[    1.038936] ACPI: Sleep Button [SBTN]
[    1.038997] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    1.039014] ACPI: Power Button [PWRF]
[    1.046031] hidraw: raw HID events driver (C) Jiri Kosina
[    1.049973] rtsx_pci 0000:01:00.0: enabling device (0000 -> 0002)
[    1.051382] thermal LNXTHERM:00: registered as thermal_zone0
[    1.051383] ACPI: Thermal Zone [THM] (25 C)
[    1.053228] ACPI: bus type USB registered
[    1.053269] usbcore: registered new interface driver usbfs
[    1.053275] usbcore: registered new interface driver hub
[    1.053312] usbcore: registered new device driver usb
[    1.058670] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    1.058732] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    1.062162] cryptd: max_cpu_qlen set to 1000
[    1.063385] AVX2 version of gcm_enc/dec engaged.
[    1.063386] AES CTR mode by8 optimization enabled
[    1.065512] nvme nvme0: pci function 0000:6e:00.0
[    1.072167] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.072173] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.073247] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00109810
[    1.073251] xhci_hcd 0000:00:14.0: cache line size of 128 is not supported
[    1.073434] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.073436] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.073439] usb usb1: Product: xHCI Host Controller
[    1.073440] usb usb1: Manufacturer: Linux 4.16.0-1-amd64 xhci-hcd
[    1.073441] usb usb1: SerialNumber: 0000:00:14.0
[    1.073535] hub 1-0:1.0: USB hub found
[    1.073552] hub 1-0:1.0: 12 ports detected
[    1.074237] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.074239] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.074283] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.074285] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.074286] usb usb2: Product: xHCI Host Controller
[    1.074287] usb usb2: Manufacturer: Linux 4.16.0-1-amd64 xhci-hcd
[    1.074288] usb usb2: SerialNumber: 0000:00:14.0
[    1.074362] hub 2-0:1.0: USB hub found
[    1.074373] hub 2-0:1.0: 6 ports detected
[    1.074532] usb: port power management may be unreliable
[    1.091435] checking generic (50000000 1fb0000) vs hw (50000000 10000000)
[    1.091436] fb: switching to inteldrmfb from EFI VGA
[    1.091452] Console: switching to colour dummy device 80x25
[    1.091511] [drm] Replacing VGA console driver
[    1.092366] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.092367] [drm] Driver supports precise vblank timestamp query.
[    1.092761] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.092797] i915 0000:00:02.0: firmware: direct-loading firmware i915/kbl_dmc_ver1_04.bin
[    1.093215] [drm] Finished loading DMC firmware i915/kbl_dmc_ver1_04.bin (v1.4)
[    1.101125] [drm] Initialized i915 1.6.0 20171222 for 0000:00:02.0 on minor 0
[    1.112201] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.112934] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    1.119793] fbcon: inteldrmfb (fb0) is primary device
[    1.288384]  nvme0n1: p1 p2 p3 p4
[    1.299505] random: fast init done
[    1.408087] usb 1-5: new high-speed USB device number 2 using xhci_hcd
[    1.602269] usb 1-5: New USB device found, idVendor=0bda, idProduct=58f4
[    1.602273] usb 1-5: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    1.602275] usb 1-5: Product: Integrated_Webcam_HD
[    1.602278] usb 1-5: Manufacturer: CN0FFMHCLOG0081JBD0MA00
[    1.602280] usb 1-5: SerialNumber: 200901010001
[    1.732187] usb 1-7: new full-speed USB device number 3 using xhci_hcd
[    1.847672] psmouse serio1: synaptics: queried max coordinates: x [..5666], y [..4734]
[    1.876202] psmouse serio1: synaptics: queried min coordinates: x [1276..], y [1118..]
[    1.876210] psmouse serio1: synaptics: The touchpad can support a better bus than the too old PS/2 protocol. Make sure MOUSE_PS2_SYNAPTICS_SMBUS and RMI4_SMB are enabled to get a better touchpad experience.
[    1.881294] usb 1-7: New USB device found, idVendor=0489, idProduct=e0a2
[    1.881298] usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.930239] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.2, id: 0x1e2a1, caps: 0xf00323/0x840300/0x12e800/0x0, board id: 3038, fw id: 2375007
[    1.964099] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
[    2.244395] Console: switching to colour frame buffer device 480x135
[    2.300625] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.476045] raid6: sse2x1   gen() 14123 MB/s
[    2.544049] raid6: sse2x1   xor() 10492 MB/s
[    2.612046] raid6: sse2x2   gen() 17688 MB/s
[    2.680045] raid6: sse2x2   xor() 12070 MB/s
[    2.748045] raid6: sse2x4   gen() 20567 MB/s
[    2.816038] raid6: sse2x4   xor() 12792 MB/s
[    2.884039] raid6: avx2x1   gen() 28768 MB/s
[    2.952047] raid6: avx2x1   xor() 19971 MB/s
[    3.020040] raid6: avx2x2   gen() 34713 MB/s
[    3.088048] raid6: avx2x2   xor() 22079 MB/s
[    3.156041] raid6: avx2x4   gen() 40079 MB/s
[    3.224040] raid6: avx2x4   xor() 24125 MB/s
[    3.224041] raid6: using algorithm avx2x4 gen() 40079 MB/s
[    3.224041] raid6: .... xor() 24125 MB/s, rmw enabled
[    3.224042] raid6: using avx2x2 recovery algorithm
[    3.226460] xor: automatically using best checksumming function   avx       
[    3.242857] Btrfs loaded, crc32c=crc32c-intel
[    3.262142] BTRFS: device fsid 5b1313f8-6984-48d0-84c2-2d8a793b35e7 devid 1 transid 2958 /dev/nvme0n1p4
[    3.404114] EXT4-fs (nvme0n1p2): mounted filesystem with ordered data mode. Opts: (null)
[    3.687576] systemd[1]: systemd 238 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
[    3.704513] systemd[1]: Detected architecture x86-64.
[    3.707149] systemd[1]: Set hostname to <mkjlap>.
[    3.953384] random: systemd: uninitialized urandom read (16 bytes read)
[    3.953506] systemd[1]: Listening on initctl Compatibility Named Pipe.
[    3.954025] random: systemd: uninitialized urandom read (16 bytes read)
[    3.954146] systemd[1]: Listening on LVM2 metadata daemon socket.
[    3.954512] random: systemd: uninitialized urandom read (16 bytes read)
[    3.956947] systemd[1]: Created slice system-wpa_supplicant.slice.
[    3.957296] random: systemd: uninitialized urandom read (16 bytes read)
[    3.957389] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    3.957735] random: systemd: uninitialized urandom read (16 bytes read)
[    3.957808] systemd[1]: Listening on udev Kernel Socket.
[    3.958113] random: systemd: uninitialized urandom read (16 bytes read)
[    3.958634] systemd[1]: Created slice User and Session Slice.
[    3.959029] random: systemd: uninitialized urandom read (16 bytes read)
[    3.959101] systemd[1]: Listening on Journal Audit Socket.
[    3.959411] random: systemd: uninitialized urandom read (16 bytes read)
[    3.959639] random: systemd: uninitialized urandom read (16 bytes read)
[    3.959937] random: systemd: uninitialized urandom read (16 bytes read)
[    3.997331] EXT4-fs (nvme0n1p2): re-mounted. Opts: discard,errors=remount-ro
[    3.997705] lp: driver loaded but no devices found
[    3.999338] ppdev: user-space parallel port driver
[    4.006374] RPC: Registered named UNIX socket transport module.
[    4.006375] RPC: Registered udp transport module.
[    4.006375] RPC: Registered tcp transport module.
[    4.006376] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.016254] drbd: initialized. Version: 8.4.10 (api:1/proto:86-101)
[    4.016255] drbd: srcversion: A48A7BC6657B70D2F41F96E 
[    4.016256] drbd: registered as block device major 147
[    4.078052] systemd-journald[348]: Received request to flush runtime journal from PID 1
[    4.120450] ACPI: AC Adapter [AC] (off-line)
[    4.120626] input: Intel HID events as /devices/platform/INT33D5:00/input/input8
[    4.123505] random: crng init done
[    4.183897] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0xFC, rev-id 1)
[    4.189257] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    4.190964] media: Linux media interface: v0.10
[    4.195693] Linux video capture interface: v2.00
[    4.204710] intel-lpss 0000:00:15.0: enabling device (0000 -> 0002)
[    4.207457] idma64 idma64.0: Found Intel integrated DMA 64-bit
[    4.212317] uvcvideo: Found UVC 1.00 device Integrated_Webcam_HD (0bda:58f4)
[    4.214394] uvcvideo 1-5:1.0: Entity type for entity Extension 4 was not initialized!
[    4.214395] uvcvideo 1-5:1.0: Entity type for entity Extension 7 was not initialized!
[    4.214397] uvcvideo 1-5:1.0: Entity type for entity Processing 2 was not initialized!
[    4.214399] uvcvideo 1-5:1.0: Entity type for entity Camera 1 was not initialized!
[    4.214457] input: Integrated_Webcam_HD: Integrate as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/input/input9
[    4.215014] uvcvideo: Unknown video format 00000032-0002-0010-8000-00aa00389b71
[    4.215019] uvcvideo: Found UVC 1.00 device Integrated_Webcam_HD (0bda:58f4)
[    4.216857] uvcvideo: Unable to create debugfs 1-2 directory.
[    4.216924] uvcvideo 1-5:1.2: Entity type for entity Extension 10 was not initialized!
[    4.216926] uvcvideo 1-5:1.2: Entity type for entity Extension 12 was not initialized!
[    4.216927] uvcvideo 1-5:1.2: Entity type for entity Processing 9 was not initialized!
[    4.216929] uvcvideo 1-5:1.2: Entity type for entity Camera 11 was not initialized!
[    4.216986] input: Integrated_Webcam_HD: Integrate as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.2/input/input10
[    4.217041] usbcore: registered new interface driver uvcvideo
[    4.217042] USB Video Class driver (1.1.1)
[    4.220827] wmi_bus wmi_bus-PNP0C14:01: WQBC data block query control method not found
[    4.220899] ioremap error for 0x3f781000-0x3f782000, requested 0x2, got 0x0
[    4.220913] ucsi_acpi: probe of USBC000:00 failed with error -12
[    4.236653] iTCO_vendor_support: vendor-support=0
[    4.237117] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    4.237249] iTCO_wdt: Found a Intel PCH TCO device (Version=4, TCOBASE=0x0400)
[    4.237340] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.242881] device-mapper: uevent: version 1.0.3
[    4.242952] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
[    4.250411] Bluetooth: Core ver 2.22
[    4.250421] NET: Registered protocol family 31
[    4.250422] Bluetooth: HCI device and connection manager initialized
[    4.250424] Bluetooth: HCI socket layer initialized
[    4.250426] Bluetooth: L2CAP socket layer initialized
[    4.250429] Bluetooth: SCO socket layer initialized
[    4.252727] ath10k_pci 0000:02:00.0: enabling device (0000 -> 0002)
[    4.254672] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
[    4.261982] BTRFS info (device nvme0n1p4): enabling ssd optimizations
[    4.261984] BTRFS info (device nvme0n1p4): disk space caching is enabled
[    4.261985] BTRFS info (device nvme0n1p4): has skinny extents
[    4.262468] EFI Variables Facility v0.08 2004-May-17
[    4.264270] usbcore: registered new interface driver btusb
[    4.296606] pstore: using zlib compression
[    4.296615] pstore: Registered efi as persistent store backend
[    4.300688] input: PC Speaker as /devices/platform/pcspkr/input/input11
[    4.315108] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
[    4.315109] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    4.315110] RAPL PMU: hw unit of domain package 2^-14 Joules
[    4.315110] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    4.315110] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    4.315111] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    4.354393] ACPI: Battery Slot [BAT0] (battery present)
[    4.355338] intel_rapl: Found RAPL domain package
[    4.355339] intel_rapl: Found RAPL domain core
[    4.355340] intel_rapl: Found RAPL domain uncore
[    4.355340] intel_rapl: Found RAPL domain dram
[    4.370330] i2c_hid i2c-ELAN24EE:00: i2c-ELAN24EE:00 supply vdd not found, using dummy regulator
[    4.413391] intel-lpss 0000:00:15.1: enabling device (0000 -> 0002)
[    4.413611] idma64 idma64.1: Found Intel integrated DMA 64-bit
[    4.433215] i2c_hid i2c-DELL07E6:00: i2c-DELL07E6:00 supply vdd not found, using dummy regulator
[    4.457244] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.507203] proc_thermal 0000:00:04.0: enabling device (0000 -> 0002)
[    4.534582] ath10k_pci 0000:02:00.0: firmware: failed to load ath10k/pre-cal-pci-0000:02:00.0.bin (-2)
[    4.534583] firmware_class: See https://wiki.debian.org/Firmware for information about missing firmware
[    4.534587] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/pre-cal-pci-0000:02:00.0.bin failed with error -2
[    4.534615] ath10k_pci 0000:02:00.0: firmware: failed to load ath10k/cal-pci-0000:02:00.0.bin (-2)
[    4.534616] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/cal-pci-0000:02:00.0.bin failed with error -2
[    4.536293] ath10k_pci 0000:02:00.0: firmware: direct-loading firmware ath10k/QCA6174/hw3.0/firmware-6.bin
[    4.536299] ath10k_pci 0000:02:00.0: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 1a56:143a
[    4.536301] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 0 tracing 0 dfs 0 testmode 0
[    4.536730] ath10k_pci 0000:02:00.0: firmware ver WLAN.RM.4.4.1-00079-QCARMSWPZ-1 api 6 features wowlan,ignore-otp crc32 fd869beb
[    4.538053] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[    4.556919] snd_hda_intel 0000:00:1f.3: enabling device (0000 -> 0002)
[    4.557211] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[    4.566532] input: Dell WMI hotkeys as /devices/platform/PNP0C14:01/wmi_bus/wmi_bus-PNP0C14:01/9DBB5994-A997-11DA-B012-B622A1EF5492/input/input12
[    4.585033] snd_hda_codec_realtek hdaudioC1D0: autoconfig for ALC3271: line_outs=1 (0x17/0x0/0x0/0x0/0x0) type:speaker
[    4.585036] snd_hda_codec_realtek hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.585037] snd_hda_codec_realtek hdaudioC1D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    4.585038] snd_hda_codec_realtek hdaudioC1D0:    mono: mono_out=0x0
[    4.585039] snd_hda_codec_realtek hdaudioC1D0:    inputs:
[    4.585040] snd_hda_codec_realtek hdaudioC1D0:      Headset Mic=0x19
[    4.585041] snd_hda_codec_realtek hdaudioC1D0:      Headphone Mic=0x1b
[    4.585043] snd_hda_codec_realtek hdaudioC1D0:      Internal Mic=0x12
[    4.595605] input: ELAN24EE:00 04F3:24EE as /devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-7/i2c-ELAN24EE:00/0018:04F3:24EE.0001/input/input13
[    4.595693] hid-generic 0018:04F3:24EE.0001: input,hidraw0: I2C HID v1.00 Device [ELAN24EE:00 04F3:24EE] on i2c-ELAN24EE:00
[    4.596732] input: DELL07E6:00 06CB:76AF as /devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-8/i2c-DELL07E6:00/0018:06CB:76AF.0002/input/input14
[    4.597343] hid-generic 0018:06CB:76AF.0002: input,hidraw1: I2C HID v1.00 Mouse [DELL07E6:00 06CB:76AF] on i2c-DELL07E6:00
[    4.603426] ath10k_pci 0000:02:00.0: firmware: direct-loading firmware ath10k/QCA6174/hw3.0/board-2.bin
[    4.603769] ath10k_pci 0000:02:00.0: board_file api 2 bmi_id N/A crc32 20d869c3
[    4.641157] input: HDA Intel PCH Headphone Mic as /devices/pci0000:00/0000:00:1f.3/sound/card1/input15
[    4.648086] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card1/input16
[    4.648152] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card1/input17
[    4.648236] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card1/input18
[    4.688112] input: HDA Intel PCH HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:1f.3/sound/card1/input19
[    4.688188] input: HDA Intel PCH HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:1f.3/sound/card1/input20
[    4.696635] input: ELAN24EE:00 04F3:24EE as /devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-7/i2c-ELAN24EE:00/0018:04F3:24EE.0001/input/input21
[    4.696723] hid-multitouch 0018:04F3:24EE.0001: input,hidraw0: I2C HID v1.00 Device [ELAN24EE:00 04F3:24EE] on i2c-ELAN24EE:00
[    4.704793] input: DELL07E6:00 06CB:76AF Touchpad as /devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-8/i2c-DELL07E6:00/0018:06CB:76AF.0002/input/input27
[    4.704878] hid-multitouch 0018:06CB:76AF.0002: input,hidraw1: I2C HID v1.00 Mouse [DELL07E6:00 06CB:76AF] on i2c-DELL07E6:00
[    5.128950] pcieport 0000:04:00.0: Refused to change power state, currently in D3
[    5.132241] pci_bus 0000:05: busn_res: [bus 05] is released
[    5.132306] pci_bus 0000:06: busn_res: [bus 06-38] is released
[    5.132380] pci_bus 0000:39: busn_res: [bus 39] is released
[    5.132437] pci_bus 0000:3a: busn_res: [bus 3a-6d] is released
[    5.132482] pci_bus 0000:04: busn_res: [bus 04-6d] is released
[    5.225345] ath10k_pci 0000:02:00.0: Unknown eventid: 118809
[    5.228085] ath10k_pci 0000:02:00.0: Unknown eventid: 90118
[    5.228671] ath10k_pci 0000:02:00.0: htt-ver 3.47 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
[    5.311375] ath: EEPROM regdomain: 0x6c
[    5.311377] ath: EEPROM indicates we should expect a direct regpair map
[    5.311381] ath: Country alpha2 being used: 00
[    5.311382] ath: Regpair used: 0x6c
[    5.320154] ath10k_pci 0000:02:00.0 wlp2s0: renamed from wlan0
[    6.080501] ath10k_pci 0000:02:00.0: Unknown eventid: 118809
[    6.083529] ath10k_pci 0000:02:00.0: Unknown eventid: 90118
[    6.135426] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   48.965613] NET: Registered protocol family 38
[   49.182290] EXT4-fs (dm-0): mounted filesystem with writeback data mode. Opts: discard,data=writeback
[   49.621853] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   49.621854] Bluetooth: BNEP filters: protocol multicast
[   49.621857] Bluetooth: BNEP socket layer initialized
[   54.749417] wlp2s0: authenticate with e8:94:f6:27:48:97
[   54.811919] wlp2s0: send auth to e8:94:f6:27:48:97 (try 1/3)
[   54.813815] wlp2s0: authenticated
[   54.816252] wlp2s0: associate with e8:94:f6:27:48:97 (try 1/3)
[   54.818070] wlp2s0: RX AssocResp from e8:94:f6:27:48:97 (capab=0x11 status=0 aid=2)
[   54.820647] wlp2s0: associated
[   54.847597] ath: EEPROM regdomain: 0x80d0
[   54.847599] ath: EEPROM indicates we should expect a country code
[   54.847601] ath: doing EEPROM country->regdmn map search
[   54.847603] ath: country maps to regdmn code: 0x37
[   54.847605] ath: Country alpha2 being used: DK
[   54.847606] ath: Regpair used: 0x37
[   54.847609] ath: regdomain 0x80d0 dynamically updated by country IE
[   54.847655] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[   61.401931] Bluetooth: RFCOMM TTY layer initialized
[   61.401940] Bluetooth: RFCOMM socket layer initialized
[   61.401944] Bluetooth: RFCOMM ver 1.11
[   68.171002] audit: type=1400 audit(1526536786.703:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="docker-default" pid=1160 comm="apparmor_parser"
[   68.201084] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   68.202402] Bridge firewalling registered
[   68.270397] Initializing XFRM netlink socket
[   68.311617] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
[  399.265159] PM: suspend entry (s2idle)
[  399.265164] PM: Syncing filesystems ... done.
[  399.270365] (NULL device *): firmware: direct-loading firmware i915/kbl_dmc_ver1_04.bin
[  399.270380] Freezing user space processes ... (elapsed 0.003 seconds) done.
[  399.274061] OOM killer disabled.
[  399.274062] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[  399.274876] Suspending console(s) (use no_console_suspend to debug)
[  399.275283] wlp2s0: deauthenticating from e8:94:f6:27:48:97 by local choice (Reason: 3=DEAUTH_LEAVING)
[  399.695128] psmouse serio1: Failed to disable mouse on isa0060/serio1
[ 2024.773182] ACPI: button: The lid device is not compliant to SW_LID.
[ 2025.402140] ath10k_pci 0000:02:00.0: Unknown eventid: 118809
[ 2025.405135] ath10k_pci 0000:02:00.0: Unknown eventid: 90118
[ 2025.495999] OOM killer enabled.
[ 2025.496001] Restarting tasks ... done.
[ 2025.852045] PM: suspend exit
[ 2030.444712] wlp2s0: authenticate with e8:94:f6:27:48:97
[ 2030.506642] wlp2s0: send auth to e8:94:f6:27:48:97 (try 1/3)
[ 2030.513697] wlp2s0: authenticated
[ 2030.515585] wlp2s0: associate with e8:94:f6:27:48:97 (try 1/3)
[ 2030.516710] wlp2s0: RX AssocResp from e8:94:f6:27:48:97 (capab=0x11 status=0 aid=2)
[ 2030.519923] wlp2s0: associated
[ 2030.526842] ath: EEPROM regdomain: 0x80d0
[ 2030.526843] ath: EEPROM indicates we should expect a country code
[ 2030.526844] ath: doing EEPROM country->regdmn map search
[ 2030.526845] ath: country maps to regdmn code: 0x37
[ 2030.526845] ath: Country alpha2 being used: DK
[ 2030.526846] ath: Regpair used: 0x37
[ 2030.526847] ath: regdomain 0x80d0 dynamically updated by country IE
[ 3086.766558] ------------[ cut here ]------------
[ 3086.766563] Unknown pixelformat 0x00000000
[ 3086.766660] WARNING: CPU: 4 PID: 2509 at /build/linux-hny3SU/linux-4.16.5/drivers/media/v4l2-core/v4l2-ioctl.c:1296 v4l_enum_fmt+0x10dc/0x13f0 [videodev]
[ 3086.766662] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc rfcomm ctr ccm devlink ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter cmac bnep binfmt_misc dm_crypt algif_skcipher af_alg arc4 snd_hda_codec_hdmi hid_multitouch hid_generic snd_hda_codec_realtek snd_soc_skl snd_hda_codec_generic snd_soc_skl_ipc snd_hda_ext_core snd_soc_sst_dsp snd_soc_sst_ipc snd_soc_acpi wmi_bmof dell_wmi snd_soc_core snd_compress dell_laptop dell_smbios dell_wmi_descriptor dcdbas intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate
[ 3086.766755]  intel_uncore intel_rapl_perf snd_hda_intel nls_ascii pcspkr snd_hda_codec nls_cp437 joydev efi_pstore snd_hda_core snd_hwdep vfat serio_raw fat snd_pcm btusb efivars snd_timer btrtl btbcm ath10k_pci btintel snd ath10k_core soundcore bluetooth dm_mod ath tpm_crb iTCO_wdt iTCO_vendor_support uvcvideo mac80211 videobuf2_vmalloc videobuf2_memops idma64 videobuf2_v4l2 drbg rtsx_pci_ms videobuf2_common cfg80211 memstick ansi_cprng videodev mei_me ecdh_generic ucsi_acpi typec_ucsi media rfkill intel_lpss_pci processor_thermal_device mei shpchp intel_lpss intel_soc_dts_iosf intel_pch_thermal typec wmi battery tpm_tis int3400_thermal acpi_thermal_rel tpm_tis_core int3403_thermal int340x_thermal_zone tpm intel_hid rng_core sparse_keymap evdev ac acpi_pad drbd lru_cache libcrc32c parport_pc sunrpc
[ 3086.766865]  ppdev lp parport efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb btrfs crc32c_generic xor zstd_decompress zstd_compress xxhash raid6_pq crc32c_intel rtsx_pci_sdmmc mmc_core i915 nvme aesni_intel aes_x86_64 i2c_algo_bit crypto_simd xhci_pci drm_kms_helper cryptd glue_helper psmouse xhci_hcd nvme_core i2c_i801 rtsx_pci usbcore drm i2c_hid usb_common thermal hid video button
[ 3086.766939] CPU: 4 PID: 2509 Comm: guvcview Not tainted 4.16.0-1-amd64 #1 Debian 4.16.5-1
[ 3086.766942] Hardware name: Dell Inc. XPS 13 9370/0F6P3V, BIOS 1.3.2 05/07/2018
[ 3086.766956] RIP: 0010:v4l_enum_fmt+0x10dc/0x13f0 [videodev]
[ 3086.766959] RSP: 0018:ffffa5178523bc90 EFLAGS: 00010282
[ 3086.766963] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
[ 3086.766967] RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff8cfb6e516730
[ 3086.766969] RBP: ffffa5178523bd98 R08: 00000000000003cc R09: 0000000000000000
[ 3086.766972] R10: ffff8cfb512a1c00 R11: 0000000000000001 R12: ffff8cfb29358b00
[ 3086.766975] R13: ffffffffc0ec4980 R14: ffff8cfb512a1c00 R15: ffff8cfb29358b00
[ 3086.766980] FS:  00007ff3f1e25b40(0000) GS:ffff8cfb6e500000(0000) knlGS:0000000000000000
[ 3086.766983] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3086.766986] CR2: 000055b47bc45fb8 CR3: 00000004142a6006 CR4: 00000000003606e0
[ 3086.766989] Call Trace:
[ 3086.767009]  __video_do_ioctl+0x36e/0x380 [videodev]
[ 3086.767024]  video_usercopy+0x198/0x5b0 [videodev]
[ 3086.767037]  ? copy_overflow+0x20/0x20 [videodev]
[ 3086.767049]  ? __handle_mm_fault+0xa14/0x1220
[ 3086.767061]  v4l2_ioctl+0xc1/0xe0 [videodev]
[ 3086.767070]  do_vfs_ioctl+0xa4/0x630
[ 3086.767078]  ? handle_mm_fault+0xdc/0x210
[ 3086.767085]  SyS_ioctl+0x74/0x80
[ 3086.767094]  do_syscall_64+0x6c/0x130
[ 3086.767102]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 3086.767107] RIP: 0033:0x7ff3ee35c8f9
[ 3086.767110] RSP: 002b:00007ffc6ee41c98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3086.767115] RAX: ffffffffffffffda RBX: 00007ffc6ee41d00 RCX: 00007ff3ee35c8f9
[ 3086.767118] RDX: 00007ffc6ee41d00 RSI: 00000000c0405602 RDI: 0000000000000004
[ 3086.767121] RBP: 0000000000000000 R08: 00007ff3ee6200c0 R09: 0000000000000000
[ 3086.767124] R10: 000055b47bc42600 R11: 0000000000000246 R12: 000055b47bc4dfd0
[ 3086.767126] R13: 00007ffc6ee41cd0 R14: 00007ffc6ee41cd0 R15: 000055b47bc42600
[ 3086.767130] Code: c7 c6 cd d5 c4 c0 e9 01 f0 ff ff 3d 4d 54 32 31 48 c7 c6 70 c9 c4 c0 0f 84 ef ef ff ff 89 c6 48 c7 c7 22 d6 c4 c0 e8 24 b0 03 d2 <0f> 0b 80 7d 0c 00 0f 85 f1 ef ff ff 8b 45 2c 48 c7 c1 35 c9 c4 
[ 3086.767222] ---[ end trace 4f427f29912a4574 ]---

/Martin
