Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:44895 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdJVRtF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Oct 2017 13:49:05 -0400
Received: by mail-qk0-f196.google.com with SMTP id r64so19519781qkc.1
        for <linux-media@vger.kernel.org>; Sun, 22 Oct 2017 10:49:04 -0700 (PDT)
MIME-Version: 1.0
From: Laurent Caumont <lcaumont2@gmail.com>
Date: Sun, 22 Oct 2017 19:49:01 +0200
Message-ID: <CACG2urxXyivORcKhgZf=acwA8ajz5UspHf8YTHEQJG=VauqHpg@mail.gmail.com>
Subject: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 / ubuntu 17.10
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

My LITE-ON DVB-T receiver doesn't work anymore with new ubuntu version.
uname -a
Linux bureau 4.13.0-16-generic #19-Ubuntu SMP Wed Oct 11 18:35:14 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux

Could you fix the Kernel crash, please ?

Thanks.

dmesg
[    0.000000] microcode: microcode updated early to revision 0xba,
date = 2017-04-09
[    0.000000] random: get_random_bytes called from
start_kernel+0x42/0x4e1 with crng_init=0
[    0.000000] Linux version 4.13.0-16-generic (buildd@lcy01-02) (gcc
version 7.2.0 (Ubuntu 7.2.0-8ubuntu2)) #19-Ubuntu SMP Wed Oct 11
18:35:14 UTC 2017 (Ubuntu 4.13.0-16.19-generic 4.13.4)
[    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-4.13.0-16-generic
root=UUID=18620d2f-e0b1-4ac9-beb0-91538ba8f2b0 ro quiet splash
vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating
point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is
960 bytes, using 'compacted' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b8305fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b8306000-0x00000000b8306fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b8307000-0x00000000b8330fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b8331000-0x00000000b83d4fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b83d5000-0x00000000b8ee5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b8ee6000-0x00000000bdb39fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bdb3a000-0x00000000bf216fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf217000-0x00000000bf263fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf264000-0x00000000bfa2afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfa2b000-0x00000000bfffefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bffff000-0x00000000bfffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000c00fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] random: fast init done
[    0.000000] SMBIOS 3.0 present.
[    0.000000] DMI: System manufacturer System Product
Name/H110I-PLUS, BIOS 0406 11/16/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   1 base 00D0000000 mask 7FF0000000 uncachable
[    0.000000]   2 base 00C8000000 mask 7FF8000000 uncachable
[    0.000000]   3 base 00C4000000 mask 7FFC000000 uncachable
[    0.000000]   4 base 00C2000000 mask 7FFE000000 uncachable
[    0.000000]   5 base 00C1000000 mask 7FFF000000 uncachable
[    0.000000]   6 base 00C0800000 mask 7FFF800000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
[    0.000000] e820: last_pfn = 0xc0000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcba0-0x000fcbaf]
mapped at [ffff8e6c000fcba0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff8e6c00096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x93f23000, 0x93f23fff] PGTABLE
[    0.000000] BRK [0x93f24000, 0x93f24fff] PGTABLE
[    0.000000] BRK [0x93f25000, 0x93f25fff] PGTABLE
[    0.000000] BRK [0x93f26000, 0x93f26fff] PGTABLE
[    0.000000] BRK [0x93f27000, 0x93f27fff] PGTABLE
[    0.000000] BRK [0x93f28000, 0x93f28fff] PGTABLE
[    0.000000] BRK [0x93f29000, 0x93f29fff] PGTABLE
[    0.000000] BRK [0x93f2a000, 0x93f2afff] PGTABLE
[    0.000000] RAMDISK: [mem 0x31993000-0x34cc0fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0580 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000BF238098 0000AC (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000BF2593B8 00010C (v05 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000BF2381E0 0211D4 (v02 ALASKA A M I
  01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x00000000BFA2AF80 000040
[    0.000000] ACPI: APIC 0x00000000BF2594C8 000084 (v03 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000BF259550 000044 (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x00000000BF259598 00009C (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000BF259638 00003C (v01 ALASKA A M I
  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BF259678 000038 (v01 ALASKA A M I
  01072009 AMI. 0005000B)
[    0.000000] ACPI: SSDT 0x00000000BF2596B0 00036D (v01 SataRe
SataTabl 00001000 INTL 20120913)
[    0.000000] ACPI: LPIT 0x00000000BF259A20 000094 (v01 INTEL  SKL
  00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x00000000BF259AB8 000248 (v02 INTEL
sensrhub 00000000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x00000000BF259D00 002BAE (v02 INTEL
PtidDevc 00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x00000000BF25C8B0 000CF3 (v02 INTEL
Ther_Rvp 00001000 INTL 20120913)
[    0.000000] ACPI: DBGP 0x00000000BF25D5A8 000034 (v01 INTEL
  00000000 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x00000000BF25D5E0 000054 (v00 INTEL
  00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x00000000BF25D638 000705 (v02 INTEL
xh_rvp08 00000000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x00000000BF25DD40 0052EA (v02 SaSsdt SaSsdt
  00003000 INTL 20120913)
[    0.000000] ACPI: UEFI 0x00000000BF263030 000042 (v01
  00000000      00000000)
[    0.000000] ACPI: SSDT 0x00000000BF263078 000E58 (v02 CpuRef
CpuSsdt  00003000 INTL 20120913)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x23bfd3000-0x23bffdfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000023bffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b8305fff]
[    0.000000]   node   0: [mem 0x00000000b8331000-0x00000000b83d4fff]
[    0.000000]   node   0: [mem 0x00000000b8ee6000-0x00000000bdb39fff]
[    0.000000]   node   0: [mem 0x00000000bffff000-0x00000000bfffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000023bffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000023bffffff]
[    0.000000] On node 0 totalpages: 2068378
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12032 pages used for memmap
[    0.000000]   DMA32 zone: 770047 pages, LIFO batch:31
[    0.000000]   Normal zone: 20224 pages used for memmap
[    0.000000]   Normal zone: 1294336 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics memory at
0x00000000c1000000-0x00000000c2ffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xb8306000-0xb8306fff]
[    0.000000] PM: Registered nosave memory: [mem 0xb8307000-0xb8330fff]
[    0.000000] PM: Registered nosave memory: [mem 0xb83d5000-0xb8ee5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdb3a000-0xbf216fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf217000-0xbf263fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf264000-0xbfa2afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfa2b000-0xbfffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xc00fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0100000-0xc0ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc1000000-0xc2ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc3000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfe010fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe011000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xc3000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff
max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4
nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 39 pages/cpu @ffff8e6e3bc00000 s119704
r8192 d31848 u524288
[    0.000000] pcpu-alloc: s119704 r8192 d31848 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 2036037
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-4.13.0-16-generic
root=UUID=18620d2f-e0b1-4ac9-beb0-91538ba8f2b0 ro quiet splash
vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8001436K/8273512K available (9281K kernel code,
2477K rwdata, 3992K rodata, 2324K init, 2384K bss, 272076K reserved,
0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 37719 entries in 148 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000]     RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000]     Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 524544, nr_irqs: 1024, preallocated irqs: 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.004000] tsc: Detected 3300.000 MHz processor
[    0.004000] Calibrating delay loop (skipped), value calculated
using timer frequency.. 6624.00 BogoMIPS (lpj=13248000)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20170531
[    0.021903] ACPI Error: [\_SB_.PCI0.XHC_.RHUB.HS11] Namespace
lookup failure, AE_NOT_FOUND (20170531/dswload-210)
[    0.021907] ACPI Exception: AE_NOT_FOUND, During name
lookup/catalog (20170531/psobject-252)
[    0.021942] ACPI Exception: AE_NOT_FOUND, (SSDT:xh_rvp08) while
loading table (20170531/tbxfload-228)
[    0.027601] ACPI Error: 1 table load failures, 7 successful
(20170531/tbxfload-246)
[    0.027631] Security Framework initialized
[    0.027633] Yama: becoming mindful.
[    0.027645] AppArmor: AppArmor initialized
[    0.028941] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.029574] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.029595] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.029615] Mountpoint-cache hash table entries: 16384 (order: 5,
131072 bytes)
[    0.029744] CPU: Physical Processor ID: 0
[    0.029744] CPU: Processor Core ID: 0
[    0.029749] mce: CPU supports 8 MCE banks
[    0.029755] CPU0: Thermal monitoring enabled (TM1)
[    0.029766] process: using mwait in idle threads
[    0.029767] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.029768] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.029832] Freeing SMP alternatives memory: 36K
[    0.030820] smpboot: Max logical packages: 2
[    0.032078] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.035251] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.074967] TSC deadline timer enabled
[    0.074972] smpboot: CPU0: Intel(R) Core(TM) i3-6300T CPU @ 3.30GHz
(family: 0x6, model: 0x5e, stepping: 0x3)
[    0.075006] Performance Events: PEBS fmt3+, Skylake events, 32-deep
LBR, full-width counters, Intel PMU driver.
[    0.075027] ... version:                4
[    0.075028] ... bit width:              48
[    0.075028] ... generic registers:      4
[    0.075028] ... value mask:             0000ffffffffffff
[    0.075029] ... max period:             00007fffffffffff
[    0.075029] ... fixed-purpose events:   3
[    0.075029] ... event mask:             000000070000000f
[    0.075054] Hierarchical SRCU implementation.
[    0.075588] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.075596] smp: Bringing up secondary CPUs ...
[    0.075637] x86: Booting SMP configuration:
[    0.075638] .... node  #0, CPUs:      #1 #2 #3
[    0.076901] smp: Brought up 1 node, 4 CPUs
[    0.076901] smpboot: Total of 4 processors activated (26496.00 BogoMIPS)
[    0.080182] devtmpfs: initialized
[    0.080182] x86/mm: Memory block size: 128MB
[    0.080427] evm: security.selinux
[    0.080428] evm: security.SMACK64
[    0.080428] evm: security.SMACK64EXEC
[    0.080428] evm: security.SMACK64TRANSMUTE
[    0.080429] evm: security.SMACK64MMAP
[    0.080429] evm: security.ima
[    0.080429] evm: security.capability
[    0.080437] PM: Registering ACPI NVS region [mem
0xb8306000-0xb8306fff] (4096 bytes)
[    0.080437] PM: Registering ACPI NVS region [mem
0xbf264000-0xbfa2afff] (8155136 bytes)
[    0.080437] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.080437] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.080437] pinctrl core: initialized pinctrl subsystem
[    0.080437] RTC time: 17:16:26, date: 10/22/17
[    0.080437] NET: Registered protocol family 16
[    0.080446] cpuidle: using governor ladder
[    0.080446] cpuidle: using governor menu
[    0.080446] PCCT header not found.
[    0.080446] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.080446] ACPI: bus type PCI registered
[    0.080446] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.080446] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.080446] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.080446] PCI: Using configuration type 1 for base access
[    0.080722] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.080722] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.080722] ACPI: Added _OSI(Module Device)
[    0.080722] ACPI: Added _OSI(Processor Device)
[    0.080722] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.080722] ACPI: Added _OSI(Processor Aggregator Device)
[    0.080722] ACPI: Executed 24 blocks of module-level executable AML code
[    0.087312] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.092138] ACPI: Dynamic OEM Table Load:
[    0.092143] ACPI: SSDT 0xFFFF8E6E31C53000 0006C3 (v02 PmRef
Cpu0Ist  00003000 INTL 20120913)
[    0.092321] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.093145] ACPI: Dynamic OEM Table Load:
[    0.093148] ACPI: SSDT 0xFFFF8E6E31DCC400 00037F (v02 PmRef
Cpu0Cst  00003001 INTL 20120913)
[    0.093802] ACPI: Dynamic OEM Table Load:
[    0.093805] ACPI: SSDT 0xFFFF8E6E31D2F800 0005AA (v02 PmRef  ApIst
  00003000 INTL 20120913)
[    0.094151] ACPI: Dynamic OEM Table Load:
[    0.094153] ACPI: SSDT 0xFFFF8E6E31DCBE00 000119 (v02 PmRef  ApCst
  00003000 INTL 20120913)
[    0.096805] ACPI: Interpreter enabled
[    0.096833] ACPI: (supports S0 S3 S4 S5)
[    0.096834] ACPI: Using IOAPIC for interrupt routing
[    0.096860] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.097459] ACPI: Enabled 7 GPEs in block 00 to 7F
[    0.099204] ACPI: Power Resource [PG00] (on)
[    0.099489] ACPI: Power Resource [PG01] (on)
[    0.099739] ACPI: Power Resource [PG02] (on)
[    0.101647] ACPI: Power Resource [WRST] (off)
[    0.101915] ACPI: Power Resource [WRST] (off)
[    0.102181] ACPI: Power Resource [WRST] (off)
[    0.102442] ACPI: Power Resource [WRST] (off)
[    0.102706] ACPI: Power Resource [WRST] (off)
[    0.102971] ACPI: Power Resource [WRST] (off)
[    0.103233] ACPI: Power Resource [WRST] (off)
[    0.103497] ACPI: Power Resource [WRST] (off)
[    0.103763] ACPI: Power Resource [WRST] (off)
[    0.104037] ACPI: Power Resource [WRST] (off)
[    0.104308] ACPI: Power Resource [WRST] (off)
[    0.104568] ACPI: Power Resource [WRST] (off)
[    0.104830] ACPI: Power Resource [WRST] (off)
[    0.105090] ACPI: Power Resource [WRST] (off)
[    0.105353] ACPI: Power Resource [WRST] (off)
[    0.105614] ACPI: Power Resource [WRST] (off)
[    0.105875] ACPI: Power Resource [WRST] (off)
[    0.106135] ACPI: Power Resource [WRST] (off)
[    0.106396] ACPI: Power Resource [WRST] (off)
[    0.106658] ACPI: Power Resource [WRST] (off)
[    0.114942] ACPI: Power Resource [FN00] (off)
[    0.114986] ACPI: Power Resource [FN01] (off)
[    0.115029] ACPI: Power Resource [FN02] (off)
[    0.115073] ACPI: Power Resource [FN03] (off)
[    0.115115] ACPI: Power Resource [FN04] (off)
[    0.115964] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.115968] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.115991] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.116464] PCI host bridge to bus 0000:00
[    0.116466] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.116466] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.116467] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff window]
[    0.116468] pci_bus 0000:00: root bus resource [mem
0xc3000000-0xf7ffffff window]
[    0.116468] pci_bus 0000:00: root bus resource [mem
0xfd000000-0xfe7fffff window]
[    0.116469] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.116475] pci 0000:00:00.0: [8086:190f] type 00 class 0x060000
[    0.116707] pci 0000:00:02.0: [8086:1912] type 00 class 0x030000
[    0.116714] pci 0000:00:02.0: reg 0x10: [mem 0xf6000000-0xf6ffffff 64bit]
[    0.116718] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff
64bit pref]
[    0.116720] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.116866] pci 0000:00:14.0: [8086:a12f] type 00 class 0x0c0330
[    0.116886] pci 0000:00:14.0: reg 0x10: [mem 0xf7110000-0xf711ffff 64bit]
[    0.116946] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.117062] pci 0000:00:16.0: [8086:a13a] type 00 class 0x078000
[    0.117085] pci 0000:00:16.0: reg 0x10: [mem 0xf712d000-0xf712dfff 64bit]
[    0.117148] pci 0000:00:16.0: PME# supported from D3hot
[    0.117261] pci 0000:00:17.0: [8086:a102] type 00 class 0x010601
[    0.117276] pci 0000:00:17.0: reg 0x10: [mem 0xf7128000-0xf7129fff]
[    0.117282] pci 0000:00:17.0: reg 0x14: [mem 0xf712c000-0xf712c0ff]
[    0.117289] pci 0000:00:17.0: reg 0x18: [io  0xf090-0xf097]
[    0.117295] pci 0000:00:17.0: reg 0x1c: [io  0xf080-0xf083]
[    0.117301] pci 0000:00:17.0: reg 0x20: [io  0xf060-0xf07f]
[    0.117307] pci 0000:00:17.0: reg 0x24: [mem 0xf712b000-0xf712b7ff]
[    0.117343] pci 0000:00:17.0: PME# supported from D3hot
[    0.117443] pci 0000:00:1c.0: [8086:a114] type 01 class 0x060400
[    0.117505] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.117633] pci 0000:00:1d.0: [8086:a118] type 01 class 0x060400
[    0.117686] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.117788] pci 0000:00:1d.1: [8086:a119] type 01 class 0x060400
[    0.117845] pci 0000:00:1d.1: PME# supported from D0 D3hot D3cold
[    0.117972] pci 0000:00:1f.0: [8086:a143] type 00 class 0x060100
[    0.118159] pci 0000:00:1f.2: [8086:a121] type 00 class 0x058000
[    0.118173] pci 0000:00:1f.2: reg 0x10: [mem 0xf7124000-0xf7127fff]
[    0.118307] pci 0000:00:1f.3: [8086:a170] type 00 class 0x040300
[    0.118333] pci 0000:00:1f.3: reg 0x10: [mem 0xf7120000-0xf7123fff 64bit]
[    0.118362] pci 0000:00:1f.3: reg 0x20: [mem 0xf7100000-0xf710ffff 64bit]
[    0.118408] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.118546] pci 0000:00:1f.4: [8086:a123] type 00 class 0x0c0500
[    0.118605] pci 0000:00:1f.4: reg 0x10: [mem 0xf712a000-0xf712a0ff 64bit]
[    0.118674] pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[    0.118874] acpiphp: Slot [1] registered
[    0.118882] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.118925] acpiphp: Slot [1-1] registered
[    0.118927] pci 0000:00:1d.0: PCI bridge to [bus 02]
[    0.118980] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.119007] pci 0000:03:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.119031] pci 0000:03:00.0: reg 0x18: [mem 0xf7004000-0xf7004fff 64bit]
[    0.119046] pci 0000:03:00.0: reg 0x20: [mem 0xf7000000-0xf7003fff 64bit]
[    0.119132] pci 0000:03:00.0: supports D1 D2
[    0.119132] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.119209] pci 0000:00:1d.1: PCI bridge to [bus 03]
[    0.119211] pci 0000:00:1d.1:   bridge window [io  0xe000-0xefff]
[    0.119213] pci 0000:00:1d.1:   bridge window [mem 0xf7000000-0xf70fffff]
[    0.120681] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.120716] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.120750] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    0.120784] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    0.120818] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    0.120852] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    0.120886] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    0.120919] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    0.121383] SCSI subsystem initialized
[    0.121402] libata version 3.00 loaded.
[    0.121402] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.121402] pci 0000:00:02.0: vgaarb: VGA device added:
decodes=io+mem,owns=io+mem,locks=none
[    0.121402] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.121402] vgaarb: loaded
[    0.121402] ACPI: bus type USB registered
[    0.121402] usbcore: registered new interface driver usbfs
[    0.121402] usbcore: registered new interface driver hub
[    0.121402] usbcore: registered new device driver usb
[    0.121402] EDAC MC: Ver: 3.0.0
[    0.121402] PCI: Using ACPI for IRQ routing
[    0.128256] PCI: pci_cache_line_size set to 64 bytes
[    0.128291] e820: reserve RAM buffer [mem 0x0009c800-0x0009ffff]
[    0.128292] e820: reserve RAM buffer [mem 0xb8306000-0xbbffffff]
[    0.128293] e820: reserve RAM buffer [mem 0xb83d5000-0xbbffffff]
[    0.128293] e820: reserve RAM buffer [mem 0xbdb3a000-0xbfffffff]
[    0.128341] NetLabel: Initializing
[    0.128341] NetLabel:  domain hash size = 128
[    0.128342] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.128351] NetLabel:  unlabeled traffic allowed by default
[    0.128359] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.128359] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.130119] clocksource: Switched to clocksource hpet
[    0.134705] VFS: Disk quotas dquot_6.6.0
[    0.134716] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.134774] AppArmor: AppArmor Filesystem Enabled
[    0.134795] pnp: PnP ACPI init
[    0.134946] system 00:00: [io  0x0290-0x029f] has been reserved
[    0.134949] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.135203] pnp 00:01: [dma 0 disabled]
[    0.135230] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.135269] pnp 00:02: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    0.135374] system 00:03: [io  0x0680-0x069f] has been reserved
[    0.135375] system 00:03: [io  0xffff] has been reserved
[    0.135376] system 00:03: [io  0xffff] has been reserved
[    0.135377] system 00:03: [io  0xffff] has been reserved
[    0.135377] system 00:03: [io  0x1800-0x18fe] has been reserved
[    0.135379] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.135381] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.135438] system 00:04: [io  0x0800-0x087f] has been reserved
[    0.135439] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.135454] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.135474] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.135475] system 00:06: Plug and Play ACPI device, IDs INT3f0d
PNP0c02 (active)
[    0.135620] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.135621] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.135622] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.135623] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.135624] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.135625] system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.135626] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.135626] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.135627] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.135628] system 00:07: [mem 0xf7fc0000-0xf7fdffff] has been reserved
[    0.135629] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.135652] system 00:08: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.135653] system 00:08: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.135654] system 00:08: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.135654] system 00:08: [mem 0xfe000000-0xfe01ffff] could not be reserved
[    0.135655] system 00:08: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.135656] system 00:08: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.135657] system 00:08: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.135658] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.135857] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    0.135859] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.136636] system 00:0a: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.136637] system 00:0a: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.136638] system 00:0a: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.136639] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.137221] pnp: PnP ACPI: found 11 devices
[    0.144715] clocksource: acpi_pm: mask: 0xffffff max_cycles:
0xffffff, max_idle_ns: 2085701024 ns
[    0.144724] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to
[bus 01] add_size 1000
[    0.144726] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
add_align 100000
[    0.144727] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff] to [bus 01] add_size 200000 add_align 100000
[    0.144732] pci 0000:00:1d.0: bridge window [io  0x1000-0x0fff] to
[bus 02] add_size 1000
[    0.144733] pci 0000:00:1d.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
add_align 100000
[    0.144733] pci 0000:00:1d.0: bridge window [mem
0x00100000-0x000fffff] to [bus 02] add_size 200000 add_align 100000
[    0.144742] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc3000000-0xc31fffff]
[    0.144745] pci 0000:00:1c.0: BAR 15: assigned [mem
0xc3200000-0xc33fffff 64bit pref]
[    0.144746] pci 0000:00:1d.0: BAR 14: assigned [mem 0xc3400000-0xc35fffff]
[    0.144748] pci 0000:00:1d.0: BAR 15: assigned [mem
0xc3600000-0xc37fffff 64bit pref]
[    0.144749] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.144750] pci 0000:00:1d.0: BAR 13: assigned [io  0x3000-0x3fff]
[    0.144752] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.144754] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.144757] pci 0000:00:1c.0:   bridge window [mem 0xc3000000-0xc31fffff]
[    0.144760] pci 0000:00:1c.0:   bridge window [mem
0xc3200000-0xc33fffff 64bit pref]
[    0.144763] pci 0000:00:1d.0: PCI bridge to [bus 02]
[    0.144765] pci 0000:00:1d.0:   bridge window [io  0x3000-0x3fff]
[    0.144767] pci 0000:00:1d.0:   bridge window [mem 0xc3400000-0xc35fffff]
[    0.144769] pci 0000:00:1d.0:   bridge window [mem
0xc3600000-0xc37fffff 64bit pref]
[    0.144773] pci 0000:00:1d.1: PCI bridge to [bus 03]
[    0.144774] pci 0000:00:1d.1:   bridge window [io  0xe000-0xefff]
[    0.144776] pci 0000:00:1d.1:   bridge window [mem 0xf7000000-0xf70fffff]
[    0.144782] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.144783] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.144783] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.144784] pci_bus 0000:00: resource 7 [mem 0xc3000000-0xf7ffffff window]
[    0.144785] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff window]
[    0.144785] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.144786] pci_bus 0000:01: resource 1 [mem 0xc3000000-0xc31fffff]
[    0.144787] pci_bus 0000:01: resource 2 [mem 0xc3200000-0xc33fffff
64bit pref]
[    0.144787] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.144788] pci_bus 0000:02: resource 1 [mem 0xc3400000-0xc35fffff]
[    0.144788] pci_bus 0000:02: resource 2 [mem 0xc3600000-0xc37fffff
64bit pref]
[    0.144789] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.144790] pci_bus 0000:03: resource 1 [mem 0xf7000000-0xf70fffff]
[    0.144880] NET: Registered protocol family 2
[    0.145002] TCP established hash table entries: 65536 (order: 7,
524288 bytes)
[    0.145092] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.145219] TCP: Hash tables configured (established 65536 bind 65536)
[    0.145238] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.145257] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.145292] NET: Registered protocol family 1
[    0.145299] pci 0000:00:02.0: Video device with shadowed ROM at
[mem 0x000c0000-0x000dffff]
[    0.146339] PCI: CLS 0 bytes, default 64
[    0.146359] Unpacking initramfs...
[    0.710075] Freeing initrd memory: 52408K
[    0.710082] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.710084] software IO TLB [mem 0xb9b3a000-0xbdb3a000] (64MB)
mapped at [ffff8e6cb9b3a000-ffff8e6cbdb39fff]
[    0.710252] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x2fbd93f9e57, max_idle_ns: 440795263784 ns
[    0.710355] Scanning for low memory corruption every 60 seconds
[    0.710589] audit: initializing netlink subsys (disabled)
[    0.710633] audit: type=2000 audit(1508692586.710:1):
state=initialized audit_enabled=0 res=1
[    0.710886] Initialise system trusted keyrings
[    0.710892] Key type blacklist registered
[    0.710945] workingset: timestamp_bits=36 max_order=21 bucket_order=0
[    0.711645] zbud: loaded
[    0.711880] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.712065] fuse init (API version 7.26)
[    0.714363] Key type asymmetric registered
[    0.714364] Asymmetric key parser 'x509' registered
[    0.714399] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 247)
[    0.714439] io scheduler noop registered
[    0.714439] io scheduler deadline registered
[    0.714455] io scheduler cfq registered (default)
[    0.714873] vesafb: mode is 1920x1080x32, linelength=7680, pages=0
[    0.714873] vesafb: scrolling: redraw
[    0.714874] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.714880] vesafb: framebuffer at 0xe0000000, mapped to
0xffff9de641800000, using 8128k, total 8128k
[    0.714951] Console: switching to colour frame buffer device 240x67
[    0.714967] fb0: VESA VGA frame buffer device
[    0.714973] intel_idle: MWAIT substates: 0x142120
[    0.714974] intel_idle: v0.4.1 model 0x5E
[    0.715112] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.715203] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.715211] ACPI: Sleep Button [SLPB]
[    0.715229] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.715237] ACPI: Power Button [PWRB]
[    0.715253] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.715307] ACPI: Power Button [PWRF]
[    0.715705] (NULL device *): hwmon_device_register() is deprecated.
Please convert the driver to use hwmon_device_register_with_info().
[    0.715797] thermal LNXTHERM:00: registered as thermal_zone0
[    0.715798] ACPI: Thermal Zone [TZ00] (28 C)
[    0.715878] thermal LNXTHERM:01: registered as thermal_zone1
[    0.715878] ACPI: Thermal Zone [TZ01] (30 C)
[    0.715897] GHES: HEST is not enabled!
[    0.715970] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.736804] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
is a 16550A
[    0.738891] Linux agpgart interface v0.103
[    0.740185] loop: module loaded
[    0.740268] libphy: Fixed MDIO Bus: probed
[    0.740268] tun: Universal TUN/TAP device driver, 1.6
[    0.740338] PPP generic driver version 2.4.2
[    0.740416] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.740417] ehci-pci: EHCI PCI platform driver
[    0.740421] ehci-platform: EHCI generic platform driver
[    0.740426] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.740427] ohci-pci: OHCI PCI platform driver
[    0.740430] ohci-platform: OHCI generic platform driver
[    0.740433] uhci_hcd: USB Universal Host Controller Interface driver
[    0.740527] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.740530] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 1
[    0.741611] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci
version 0x100 quirks 0x00109810
[    0.741615] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.741679] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.741679] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.741680] usb usb1: Product: xHCI Host Controller
[    0.741681] usb usb1: Manufacturer: Linux 4.13.0-16-generic xhci-hcd
[    0.741681] usb usb1: SerialNumber: 0000:00:14.0
[    0.741789] hub 1-0:1.0: USB hub found
[    0.741800] hub 1-0:1.0: 10 ports detected
[    0.741933] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.741935] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 2
[    0.741952] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    0.741953] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.741953] usb usb2: Product: xHCI Host Controller
[    0.741954] usb usb2: Manufacturer: Linux 4.13.0-16-generic xhci-hcd
[    0.741955] usb usb2: SerialNumber: 0000:00:14.0
[    0.742065] hub 2-0:1.0: USB hub found
[    0.742071] hub 2-0:1.0: 4 ports detected
[    0.742190] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.742191] i8042: PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
[    0.742915] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.743053] mousedev: PS/2 mouse device common for all mice
[    0.743392] rtc_cmos 00:05: RTC can wake from S4
[    0.743795] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.743874] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes
nvram, hpet irqs
[    0.743876] i2c /dev entries driver
[    0.743902] device-mapper: uevent: version 1.0.3
[    0.743967] device-mapper: ioctl: 4.36.0-ioctl (2017-06-09)
initialised: dm-devel@redhat.com
[    0.743969] intel_pstate: Intel P-state driver initializing
[    0.744343] intel_pstate: HWP enabled
[    0.744458] ledtrig-cpu: registered to indicate activity on CPUs
[    0.744904] NET: Registered protocol family 10
[    0.747994] Segment Routing with IPv6
[    0.748028] NET: Registered protocol family 17
[    0.748035] Key type dns_resolver registered
[    0.748268] RAS: Correctable Errors collector initialized.
[    0.748285] microcode: sig=0x506e3, pf=0x2, revision=0xba
[    0.748396] microcode: Microcode Update Driver: v2.2.
[    0.748401] sched_clock: Marking stable (748394234, 0)->(750057455, -1663221)
[    0.748720] registered taskstats version 1
[    0.748725] Loading compiled-in X.509 certificates
[    0.750277] Loaded X.509 cert 'Build time autogenerated kernel key:
04409fd30ffab3ce9d2178c508b3c866d61d9a62'
[    0.750287] zswap: loaded using pool lzo/zbud
[    0.751715] Key type big_key registered
[    0.751717] Key type trusted registered
[    0.752886] Key type encrypted registered
[    0.752888] AppArmor: AppArmor sha1 policy hashing enabled
[    0.752889] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
[    0.752909] evm: HMAC attrs: 0x1
[    0.753411]   Magic number: 5:202:290
[    0.753428] tty tty23: hash matches
[    0.753627] rtc_cmos 00:05: setting system clock to 2017-10-22
17:16:26 UTC (1508692586)
[    0.753702] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.753703] EDD information not available.
[    0.753729] PM: Hibernation image not present or could not be loaded.
[    0.755116] Freeing unused kernel memory: 2324K
[    0.755117] Write protecting the kernel read-only data: 14336k
[    0.755327] Freeing unused kernel memory: 948K
[    0.755469] Freeing unused kernel memory: 104K
[    0.756571] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    0.765799] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    0.799733] hidraw: raw HID events driver (C) Jiri Kosina
[    0.833537] ahci 0000:00:17.0: version 3.0
[    0.837996] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.838002] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    0.849034] r8169 0000:03:00.0 eth0: RTL8168h/8111h at
0xffff9de640c95000, 9c:5c:8e:7c:b7:07, XID 14100800 IRQ 122
[    0.849035] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    0.850133] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 4 ports 6
Gbps 0xf impl SATA mode
[    0.850135] ahci 0000:00:17.0: flags: 64bit ncq sntf led clo only
pio slum part ems deso sadm sds apst
[    0.850168] r8169 0000:03:00.0 enp3s0: renamed from eth0
[    0.884626] scsi host0: ahci
[    0.884745] scsi host1: ahci
[    0.884827] scsi host2: ahci
[    0.884903] scsi host3: ahci
[    0.884925] ata1: SATA max UDMA/133 abar m2048@0xf712b000 port
0xf712b100 irq 121
[    0.884927] ata2: SATA max UDMA/133 abar m2048@0xf712b000 port
0xf712b180 irq 121
[    0.884928] ata3: SATA max UDMA/133 abar m2048@0xf712b000 port
0xf712b200 irq 121
[    0.884929] ata4: SATA max UDMA/133 abar m2048@0xf712b000 port
0xf712b280 irq 121
[    0.887608] [drm] Memory usable by graphics device = 4096M
[    0.887610] checking generic (e0000000 7f0000) vs hw (e0000000 10000000)
[    0.887610] fb: switching to inteldrmfb from VESA VGA
[    0.887624] Console: switching to colour dummy device 80x25
[    0.887675] [drm] Replacing VGA console driver
[    0.893875] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.893875] [drm] Driver supports precise vblank timestamp query.
[    0.900444] [drm] Finished loading DMC firmware
i915/skl_dmc_ver1_26.bin (v1.26)
[    0.901220] i915 0000:00:02.0: vgaarb: changed VGA decodes:
olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.902476] [drm] Initialized i915 1.6.0 20170619 for 0000:00:02.0 on minor 0
[    0.903679] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.903845] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    1.014980] fbcon: inteldrmfb (fb0) is primary device
[    1.015021] Console: switching to colour frame buffer device 240x67
[    1.015038] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.068132] usb 1-2: new low-speed USB device number 2 using xhci_hcd
[    1.200984] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.201005] ata1: SATA link down (SStatus 4 SControl 300)
[    1.201048] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.201079] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.203029] ata2.00: ATAPI: TSSTcorp BDDVDW SN-506BB, SB00, max UDMA/100
[    1.203319] ata4.00: ATA-8: WDC WD10EADS-00M2B0, 01.00A01, max UDMA/133
[    1.203320] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.203968] ata2.00: configured for UDMA/100
[    1.205736] ata4.00: configured for UDMA/133
[    1.211199] scsi 1:0:0:0: CD-ROM            TSSTcorp BDDVDW
SN-506BB  SB00 PQ: 0 ANSI: 5
[    1.212191] ata3.00: ATA-9: Corsair Force LE SSD, SAFC12.1, max UDMA/133
[    1.212192] ata3.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.212393] ata3.00: configured for UDMA/133
[    1.214290] usb 1-2: New USB device found, idVendor=1997, idProduct=1221
[    1.214291] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.214292] usb 1-2: Product: Mini Keybo
[    1.214292] usb 1-2: Manufacturer: Riite
[    1.233036] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer
dvd-ram cd/rw xa/form2 cdda tray
[    1.233037] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.233178] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.233258] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    1.233458] scsi 2:0:0:0: Direct-Access     ATA      Corsair Force
LE 12.1 PQ: 0 ANSI: 5
[    1.276228] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.276364] sd 2:0:0:0: [sda] 468862128 512-byte logical blocks:
(240 GB/224 GiB)
[    1.276389] sd 2:0:0:0: [sda] Write Protect is off
[    1.276390] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.276408] scsi 3:0:0:0: Direct-Access     ATA      WDC
WD10EADS-00M 0A01 PQ: 0 ANSI: 5
[    1.276438] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.277513]  sda: sda1 sda2 < sda5 sda6 >
[    1.278187] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.320230] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.320346] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/932 GiB)
[    1.320375] sd 3:0:0:0: [sdb] Write Protect is off
[    1.320376] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.320452] sd 3:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.332111] usb 2-3: new SuperSpeed USB device number 2 using xhci_hcd
[    1.353180] usb 2-3: New USB device found, idVendor=0bc2, idProduct=61b5
[    1.353181] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.353181] usb 2-3: Product: M3
[    1.353182] usb 2-3: Manufacturer: Seagate
[    1.353183] usb 2-3: SerialNumber: NM12PV1T
[    1.388169]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
[    1.388858] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.472063] usb 1-5: new low-speed USB device number 3 using xhci_hcd
[    1.617206] usb 1-5: New USB device found, idVendor=1bcf, idProduct=0007
[    1.617207] usb 1-5: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.617208] usb 1-5: Product: USB Optical Mouse
[    1.728280] clocksource: Switched to clocksource tsc
[    1.732137] usb 2-4: new SuperSpeed USB device number 3 using xhci_hcd
[    1.752790] usb 2-4: New USB device found, idVendor=1058, idProduct=10b8
[    1.752791] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[    1.752792] usb 2-4: Product: Elements 10B8
[    1.752793] usb 2-4: Manufacturer: Western Digital
[    1.752793] usb 2-4: SerialNumber: 575838314133345931343131
[    1.755393] usb-storage 2-4:1.0: USB Mass Storage device detected
[    1.755451] scsi host4: usb-storage 2-4:1.0
[    1.755497] usbcore: registered new interface driver usb-storage
[    1.757991] scsi host5: uas
[    1.758027] usbcore: registered new interface driver uas
[    1.758328] scsi 5:0:0:0: Direct-Access     Seagate  M3
  0707 PQ: 0 ANSI: 6
[    1.788217] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    1.788726] sd 5:0:0:0: [sdc] 3907029167 512-byte logical blocks:
(2.00 TB/1.82 TiB)
[    1.788727] sd 5:0:0:0: [sdc] 4096-byte physical blocks
[    1.788865] sd 5:0:0:0: [sdc] Write Protect is off
[    1.788865] sd 5:0:0:0: [sdc] Mode Sense: 53 00 00 08
[    1.789131] sd 5:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.792826]  sdc: sdc1
[    1.794170] sd 5:0:0:0: [sdc] Attached SCSI disk
[    1.872076] usb 1-6: new full-speed USB device number 4 using xhci_hcd
[    2.014842] usb 1-6: New USB device found, idVendor=0a4d, idProduct=129d
[    2.014843] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.014844] usb 1-6: Product: Keystation Mini 32
[    2.014845] usb 1-6: Manufacturer: Keystation Mini 32
[    2.132057] usb 1-7: new full-speed USB device number 5 using xhci_hcd
[    2.272992] usb 1-7: New USB device found, idVendor=046d, idProduct=08a2
[    2.272994] usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.392110] usb 1-8: new high-speed USB device number 6 using xhci_hcd
[    2.545047] usb 1-8: New USB device found, idVendor=04ca, idProduct=f001
[    2.545048] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.545049] usb 1-8: Product: TvTUNER
[    2.545050] usb 1-8: Manufacturer: SKGZ
[    2.545050] usb 1-8: SerialNumber: TMP63R1454
[    2.556909] usbcore: registered new interface driver usbhid
[    2.556910] usbhid: USB HID core driver
[    2.557969] input: Riite Mini Keybo as
/devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:1997:1221.0001/input/input5
[    2.616259] hid-generic 0003:1997:1221.0001: input,hidraw0: USB HID
v1.00 Keyboard [Riite Mini Keybo] on usb-0000:00:14.0-2/input0
[    2.616367] input: Riite Mini Keybo as
/devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:1997:1221.0002/input/input6
[    2.676165] hid-generic 0003:1997:1221.0002: input,hidraw1: USB HID
v1.00 Mouse [Riite Mini Keybo] on usb-0000:00:14.0-2/input1
[    2.676227] input: USB Optical Mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/0003:1BCF:0007.0003/input/input7
[    2.676298] hid-generic 0003:1BCF:0007.0003: input,hiddev0,hidraw2:
USB HID v1.10 Mouse [USB Optical Mouse] on usb-0000:00:14.0-5/input0
[    2.784355] scsi 4:0:0:0: Direct-Access     WD       Elements 10B8
  1007 PQ: 0 ANSI: 6
[    2.784383] [drm] RC6 on
[    2.784509] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    2.784641] sd 4:0:0:0: [sdd] 3906963456 512-byte logical blocks:
(2.00 TB/1.82 TiB)
[    2.784845] sd 4:0:0:0: [sdd] Write Protect is off
[    2.784846] sd 4:0:0:0: [sdd] Mode Sense: 47 00 10 08
[    2.785048] sd 4:0:0:0: [sdd] No Caching mode page found
[    2.785050] sd 4:0:0:0: [sdd] Assuming drive cache: write through
[    2.786062]  sdd: sdd1
[    2.786865] sd 4:0:0:0: [sdd] Attached SCSI disk
[    2.886723] WARN_ON(crtc->config->scaler_state.scaler_id < 0)
[    2.886735] ------------[ cut here ]------------
[    2.886761] WARNING: CPU: 0 PID: 262 at
/build/linux-XO_uEE/linux-4.13.0/drivers/gpu/drm/i915/intel_display.c:4755
skylake_pfit_enable+0xe6/0xf0 [i915]
[    2.886761] Modules linked in: dm_mirror dm_region_hash dm_log
hid_generic usbhid uas usb_storage i915 mxm_wmi i2c_algo_bit
drm_kms_helper r8169 syscopyarea sysfillrect mii sysimgblt fb_sys_fops
drm ahci libahci wmi video pinctrl_sunrisepoint pinctrl_intel i2c_hid
hid
[    2.886771] CPU: 0 PID: 262 Comm: plymouthd Not tainted
4.13.0-16-generic #19-Ubuntu
[    2.886771] Hardware name: System manufacturer System Product
Name/H110I-PLUS, BIOS 0406 11/16/2015
[    2.886772] task: ffff8e6e276dc740 task.stack: ffff9de64132c000
[    2.886788] RIP: 0010:skylake_pfit_enable+0xe6/0xf0 [i915]
[    2.886789] RSP: 0018:ffff9de64132f910 EFLAGS: 00010282
[    2.886790] RAX: 0000000000000031 RBX: ffff8e6e31d5d000 RCX: ffffffffba05fcc8
[    2.886790] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000247
[    2.886791] RBP: ffff9de64132f930 R08: 0000000000000031 R09: 00000000000002e8
[    2.886791] R10: ffff8e6e26d8a988 R11: 0000000000000000 R12: ffff8e6e26d88000
[    2.886792] R13: ffff8e6e26d88000 R14: 00000000fffffffd R15: ffff8e6e323ee800
[    2.886793] FS:  00007ff22e6a6b80(0000) GS:ffff8e6e3bc00000(0000)
knlGS:0000000000000000
[    2.886793] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.886794] CR2: 0000555d9ef9d290 CR3: 0000000227bfc000 CR4: 00000000003406f0
[    2.886794] Call Trace:
[    2.886811]  haswell_crtc_enable+0x1d9/0x820 [i915]
[    2.886825]  intel_update_crtc+0x4b/0xe0 [i915]
[    2.886838]  skl_update_crtcs+0x1ca/0x290 [i915]
[    2.886850]  intel_atomic_commit_tail+0x254/0xf90 [i915]
[    2.886852]  ? __schedule+0x293/0x890
[    2.886864]  intel_atomic_commit+0x3d5/0x490 [i915]
[    2.886873]  ? drm_atomic_check_only+0x37b/0x540 [drm]
[    2.886879]  drm_atomic_commit+0x4b/0x50 [drm]
[    2.886884]  drm_atomic_helper_set_config+0x68/0x90 [drm_kms_helper]
[    2.886890]  __drm_mode_set_config_internal+0x65/0x110 [drm]
[    2.886895]  drm_mode_setcrtc+0x479/0x630 [drm]
[    2.886897]  ? ww_mutex_unlock+0x26/0x30
[    2.886901]  ? drm_mode_getcrtc+0x180/0x180 [drm]
[    2.886906]  drm_ioctl_kernel+0x5d/0xb0 [drm]
[    2.886910]  drm_ioctl+0x31b/0x3d0 [drm]
[    2.886914]  ? drm_mode_getcrtc+0x180/0x180 [drm]
[    2.886916]  ? new_sync_read+0xde/0x130
[    2.886918]  do_vfs_ioctl+0xa5/0x610
[    2.886919]  ? vfs_read+0x115/0x130
[    2.886920]  SyS_ioctl+0x79/0x90
[    2.886922]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[    2.886922] RIP: 0033:0x7ff22dd82ea7
[    2.886923] RSP: 002b:00007ffe7cf09a18 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[    2.886924] RAX: ffffffffffffffda RBX: 000055f7852f73a0 RCX: 00007ff22dd82ea7
[    2.886924] RDX: 00007ffe7cf09a50 RSI: 00000000c06864a2 RDI: 0000000000000009
[    2.886925] RBP: 0000000000000002 R08: 0000000000000000 R09: 000055f785303500
[    2.886925] R10: 000055f785302fc0 R11: 0000000000000246 R12: 00007ffe7cf09e30
[    2.886925] R13: 00000000ffffffff R14: 0000000000000000 R15: 00007ff22e4872d0
[    2.886926] Code: 06 74 81 06 00 41 ff 94 24 f8 06 00 00 5b 41 5c
41 5d 41 5e 5d c3 f3 c3 48 c7 c6 a8 34 3e c0 48 c7 c7 db 05 3d c0 e8
2b c6 fd f8 <0f> ff eb de 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 83 8f
30 37
[    2.886942] ---[ end trace 5721f5dfb92a50e9 ]---
[    2.908604] [drm:pipe_config_err [i915]] *ERROR* mismatch in
output_types (expected 0x00000400, found 0x00000080)
[    2.908624] [drm:pipe_config_err [i915]] *ERROR* mismatch in
pch_pfit.enabled (expected 1, found 0)
[    2.908640] [drm:pipe_config_err [i915]] *ERROR* mismatch in
pch_pfit.size (expected 0x07800438, found 0x00000000)
[    2.908654] [drm:pipe_config_err [i915]] *ERROR* mismatch in
pixel_rate (expected 270000, found 148499)
[    2.908668] [drm:pipe_config_err [i915]] *ERROR* mismatch in
base.adjusted_mode.crtc_clock (expected 270000, found 148499)
[    2.908669] pipe state doesn't match!
[    2.908676] ------------[ cut here ]------------
[    2.908692] WARNING: CPU: 2 PID: 262 at
/build/linux-XO_uEE/linux-4.13.0/drivers/gpu/drm/i915/intel_display.c:12273
intel_atomic_commit_tail+0xdb1/0xf90 [i915]
[    2.908692] Modules linked in: dm_mirror dm_region_hash dm_log
hid_generic usbhid uas usb_storage i915 mxm_wmi i2c_algo_bit
drm_kms_helper r8169 syscopyarea sysfillrect mii sysimgblt fb_sys_fops
drm ahci libahci wmi video pinctrl_sunrisepoint pinctrl_intel i2c_hid
hid
[    2.908700] CPU: 2 PID: 262 Comm: plymouthd Tainted: G        W
  4.13.0-16-generic #19-Ubuntu
[    2.908701] Hardware name: System manufacturer System Product
Name/H110I-PLUS, BIOS 0406 11/16/2015
[    2.908701] task: ffff8e6e276dc740 task.stack: ffff9de64132c000
[    2.908716] RIP: 0010:intel_atomic_commit_tail+0xdb1/0xf90 [i915]
[    2.908716] RSP: 0018:ffff9de64132fa90 EFLAGS: 00010286
[    2.908717] RAX: 0000000000000019 RBX: ffff8e6e26d88310 RCX: ffffffffba05fcc8
[    2.908718] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000247
[    2.908718] RBP: ffff9de64132fb48 R08: 0000000000000001 R09: 000000000000031e
[    2.908718] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8e6e31c54800
[    2.908719] R13: ffff8e6e31d5d000 R14: ffff8e6e323ee800 R15: ffff8e6e26d88308
[    2.908720] FS:  00007ff22e6a6b80(0000) GS:ffff8e6e3bd00000(0000)
knlGS:0000000000000000
[    2.908720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.908721] CR2: 000055ded0ab1ac0 CR3: 0000000227bfc000 CR4: 00000000003406e0
[    2.908721] Call Trace:
[    2.908724]  ? wait_woken+0x80/0x80
[    2.908738]  intel_atomic_commit+0x3d5/0x490 [i915]
[    2.908746]  ? drm_atomic_check_only+0x37b/0x540 [drm]
[    2.908752]  drm_atomic_commit+0x4b/0x50 [drm]
[    2.908756]  drm_atomic_helper_set_config+0x68/0x90 [drm_kms_helper]
[    2.908762]  __drm_mode_set_config_internal+0x65/0x110 [drm]
[    2.908768]  drm_mode_setcrtc+0x479/0x630 [drm]
[    2.908770]  ? ww_mutex_unlock+0x26/0x30
[    2.908775]  ? drm_mode_getcrtc+0x180/0x180 [drm]
[    2.908780]  drm_ioctl_kernel+0x5d/0xb0 [drm]
[    2.908784]  drm_ioctl+0x31b/0x3d0 [drm]
[    2.908789]  ? drm_mode_getcrtc+0x180/0x180 [drm]
[    2.908790]  ? new_sync_read+0xde/0x130
[    2.908792]  do_vfs_ioctl+0xa5/0x610
[    2.908793]  ? vfs_read+0x115/0x130
[    2.908794]  SyS_ioctl+0x79/0x90
[    2.908795]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[    2.908796] RIP: 0033:0x7ff22dd82ea7
[    2.908797] RSP: 002b:00007ffe7cf09a18 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[    2.908797] RAX: ffffffffffffffda RBX: 000055f7852f73a0 RCX: 00007ff22dd82ea7
[    2.908798] RDX: 00007ffe7cf09a50 RSI: 00000000c06864a2 RDI: 0000000000000009
[    2.908798] RBP: 0000000000000002 R08: 0000000000000000 R09: 000055f785303500
[    2.908799] R10: 000055f785302fc0 R11: 0000000000000246 R12: 00007ffe7cf09e30
[    2.908799] R13: 00000000ffffffff R14: 0000000000000000 R15: 00007ff22e4872d0
[    2.908800] Code: 40 53 3e c0 e8 f2 c6 fc f8 0f ff 0f b6 8d 60 ff
ff ff 44 0f b6 85 70 ff ff ff e9 00 fd ff ff 48 c7 c7 fe 0d 3d c0 e8
d0 c6 fc f8 <0f> ff e9 73 f8 ff ff 48 8d 7d 80 31 f6 e8 dd 13 fb f8 48
69 c3
[    2.908816] ---[ end trace 5721f5dfb92a50ea ]---
[    3.346278] random: crng init done
[    3.600030] raid6: sse2x1   gen() 11636 MB/s
[    3.648030] raid6: sse2x1   xor()  8402 MB/s
[    3.696032] raid6: sse2x2   gen() 14187 MB/s
[    3.744032] raid6: sse2x2   xor()  9580 MB/s
[    3.792030] raid6: sse2x4   gen() 16408 MB/s
[    3.840028] raid6: sse2x4   xor()  9986 MB/s
[    3.888033] raid6: avx2x1   gen() 22623 MB/s
[    3.936032] raid6: avx2x1   xor() 15971 MB/s
[    3.984028] raid6: avx2x2   gen() 27528 MB/s
[    4.032028] raid6: avx2x2   xor() 17504 MB/s
[    4.080038] raid6: avx2x4   gen() 31112 MB/s
[    4.128032] raid6: avx2x4   xor() 18637 MB/s
[    4.128034] raid6: using algorithm avx2x4 gen() 31112 MB/s
[    4.128035] raid6: .... xor() 18637 MB/s, rmw enabled
[    4.128035] raid6: using avx2x2 recovery algorithm
[    4.128765] xor: automatically using best checksumming function   avx
[    4.138461] Btrfs loaded, crc32c=crc32c-intel
[   10.180013] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[   10.322828] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.328901] systemd[1]: systemd 234 running in system mode. (+PAM
+AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2
+IDN default-hierarchy=hybrid)
[   10.328993] systemd[1]: Detected architecture x86-64.
[   10.329272] systemd[1]: Set hostname to <bureau>.
[   10.442883] systemd[1]: Created slice System Slice.
[   10.442971] systemd[1]: Created slice User and Session Slice.
[   10.442980] systemd[1]: Reached target Slices.
[   10.443000] systemd[1]: Listening on udev Kernel Socket.
[   10.443117] systemd[1]: Set up automount Arbitrary Executable File
Formats File System Automount Point.
[   10.443453] systemd[1]: Mounting POSIX Message Queue File System...
[   10.443508] systemd[1]: Listening on LVM2 metadata daemon socket.
[   10.467443] lp: driver loaded but no devices found
[   10.470114] ppdev: user-space parallel port driver
[   10.543667] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   10.558709] systemd-journald[353]: Received request to flush
runtime journal from PID 1
[   10.709846] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.719474] Bluetooth: Core ver 2.22
[   10.719484] NET: Registered protocol family 31
[   10.719485] Bluetooth: HCI device and connection manager initialized
[   10.719487] Bluetooth: HCI socket layer initialized
[   10.719488] Bluetooth: L2CAP socket layer initialized
[   10.719491] Bluetooth: SCO socket layer initialized
[   10.729085] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[   10.758010] Bluetooth: HCI UART driver ver 2.3
[   10.758012] Bluetooth: HCI UART protocol H4 registered
[   10.758013] Bluetooth: HCI UART protocol BCSP registered
[   10.758025] Bluetooth: HCI UART protocol LL registered
[   10.758025] Bluetooth: HCI UART protocol ATH3K registered
[   10.758026] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   10.758590] Bluetooth: HCI UART protocol Intel registered
[   10.758603] Bluetooth: HCI UART protocol Broadcom registered
[   10.758604] Bluetooth: HCI UART protocol QCA registered
[   10.758604] Bluetooth: HCI UART protocol AG6XX registered
[   10.758605] Bluetooth: HCI UART protocol Marvell registered
[   10.816350] media: Linux media interface: v0.10
[   10.839056] asus_wmi: ASUS WMI generic driver loaded
[   10.841002] asus_wmi: Initialization: 0x0
[   10.841025] asus_wmi: BIOS WMI version: 0.9
[   10.841062] asus_wmi: SFUN value: 0x0
[   10.841391] input: Eee PC WMI hotkeys as
/devices/platform/eeepc-wmi/input/input8
[   10.842771] asus_wmi: Number of fans: 1
[   10.843597] Linux video capture interface: v2.00
[   10.852180] gspca_main: v2.14.0 registered
[   10.854210] gspca_main: gspca_zc3xx-2.14.0 probing 046d:08a2
[   10.865118] dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
[   10.865208] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   10.869232] dvbdev: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
[   10.876172] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops
i915_audio_component_bind_ops [i915])
[   10.910608] snd_hda_codec_realtek hdaudioC0D0: autoconfig for
ALC887-VD: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   10.910610] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0
(0x0/0x0/0x0/0x0/0x0)
[   10.910611] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1
(0x1b/0x0/0x0/0x0/0x0)
[   10.910612] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   10.910613] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   10.910618] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[   10.910619] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[   10.910620] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[   10.930772] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters,
655360 ms ovfl timer
[   10.930773] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[   10.930774] RAPL PMU: hw unit of domain package 2^-14 Joules
[   10.930775] RAPL PMU: hw unit of domain dram 2^-14 Joules
[   10.930775] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[   10.930776] RAPL PMU: hw unit of domain psys 2^-14 Joules
[   10.933000] input: HDA Intel PCH Front Mic as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input9
[   10.933045] input: HDA Intel PCH Rear Mic as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input10
[   10.933086] input: HDA Intel PCH Line as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input11
[   10.933124] input: HDA Intel PCH Line Out as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input12
[   10.933172] input: HDA Intel PCH Front Headphone as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input13
[   10.933209] input: HDA Intel PCH HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input14
[   10.933245] input: HDA Intel PCH HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input15
[   10.933286] input: HDA Intel PCH HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:1f.3/sound/card0/input16
[   10.942038] AVX2 version of gcm_enc/dec engaged.
[   10.942039] AES CTR mode by8 optimization enabled
[   10.962789] Adding 16777212k swap on /mnt/swapfile.  Priority:-1
extents:151 across:26951676k SSFS
[   11.034845] intel_rapl: Found RAPL domain package
[   11.034846] intel_rapl: Found RAPL domain core
[   11.034847] intel_rapl: Found RAPL domain uncore
[   11.034848] intel_rapl: Found RAPL domain dram
[   11.088463] EXT4-fs (sda6): mounted filesystem with ordered data
mode. Opts: (null)
[   11.211297] audit: type=1400 audit(1508692596.957:2):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="/snap/core/2898/usr/lib/snapd/snap-confine" pid=858
comm="apparmor_parser"
[   11.211300] audit: type=1400 audit(1508692596.957:3):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="/snap/core/2898/usr/lib/snapd/snap-confine//mount-namespace-capture-helper"
pid=858 comm="apparmor_parser"
[   11.212160] audit: type=1400 audit(1508692596.958:4):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="/snap/core/2844/usr/lib/snapd/snap-confine" pid=857
comm="apparmor_parser"
[   11.212163] audit: type=1400 audit(1508692596.958:5):
apparmor="STATUS" operation="profile_load" profile="unconfined"
name="/sn
