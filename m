Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35269 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbcFVTK4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 15:10:56 -0400
Received: by mail-qk0-f182.google.com with SMTP id c73so78732089qkg.2
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2016 12:10:56 -0700 (PDT)
Received: from mail-qk0-f180.google.com (mail-qk0-f180.google.com. [209.85.220.180])
        by smtp.gmail.com with ESMTPSA id g15sm602847qtc.17.2016.06.22.12.10.49
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jun 2016 12:10:49 -0700 (PDT)
Received: by mail-qk0-f180.google.com with SMTP id p10so78649678qke.3
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2016 12:10:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ed8ec6ca7f8f893ecbce7023c5a1153@webmail.meine-oma.de>
References: <abfe17ade84725100f405e5b1f6228b8@webmail.meine-oma.de>
 <CAAZRmGy2qezuyX=p7-Twm6ibWzsRxVh1+HvME-Lj5fCYUk6exg@mail.gmail.com> <3ed8ec6ca7f8f893ecbce7023c5a1153@webmail.meine-oma.de>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Wed, 22 Jun 2016 22:10:47 +0300
Message-ID: <CAAZRmGw+vicknw0_hdxJ8jcz4r3kLY2=oEgXs0CaqA397r-U9A@mail.gmail.com>
Subject: Re: dvb usb stick Hauppauge WinTV-soloHD
To: Thomas Stein <himbeere@meine-oma.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

Ok, the correct firmwares are there:
[  101.423697] si2168 11-0064: found a 'Silicon Labs Si2168-B40'
[  101.428693] si2168 11-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
[  101.657999] si2168 11-0064: firmware version: 4.0.11
[  101.661225] si2157 12-0060: found a 'Silicon Labs Si2157-A30'
[  101.709738] si2157 12-0060: firmware version: 3.0.5

Basically everything looks good. Does this work on a Windows computer
using the same antenna cable and the same USB tuner?

DVB-T2 support in w_scan has been evolving also, so make sure you've
got quite recent version.

I've found that dvbv5-scan does the best job when scanning for
channels. However that needs initial scan table to start with. The
initial scan tables for Berlin don't seem to contain any DVB-T2 muxes
though: https://git.linuxtv.org/dtv-scan-tables.git/tree/dvb-t/de-Berlin
This means they're probably a bit out  of date. If you know the DVB-T2
mux details, you can add them yourself and try dvbv5-scan.

Cheers,
-olli

On 18 June 2016 at 20:17, Thomas Stein <himbeere@meine-oma.de> wrote:
> Hi Olli.
>
> Thanks for your answer.
>
> Here we go.
>
> [    0.000000] Linux version 4.6.2 (root@rather) (gcc version 5.3.0 (Gentoo
> 5.3.0 p1.0, pie-0.6.5) ) #3 SMP Sat Jun 18 13:34:40 CEST 2016
> [    0.000000] Command line: BOOT_IMAGE=/kernel-4.6.2 root=/dev/sda3 ro
> net.ifnames=0
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point
> registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832
> bytes, using 'standard' format.
> [    0.000000] x86/fpu: Using 'eager' FPU context switches.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ce20ffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000ce210000-0x00000000dcd3efff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000dcd3f000-0x00000000dce7efff] ACPI
> NVS
> [    0.000000] BIOS-e820: [mem 0x00000000dce7f000-0x00000000dcefefff] ACPI
> data
> [    0.000000] BIOS-e820: [mem 0x00000000dceff000-0x00000000dfa0ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fe101000-0x00000000fe112fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f5fffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.7 present.
> [    0.000000] DMI: LENOVO 20A7005MGE/20A7005MGE, BIOS GRET46WW (1.23 )
> 11/04/2015
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x21f600 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00E0000000 mask 7FE0000000 uncachable
> [    0.000000]   1 base 00DE000000 mask 7FFE000000 uncachable
> [    0.000000]   2 base 00DD000000 mask 7FFF000000 uncachable
> [    0.000000]   3 base 00DCF00000 mask 7FFFF00000 uncachable
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
> [    0.000000] e820: last_pfn = 0xce210 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f0100-0x000f010f] mapped at
> [ffff8800000f0100]
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] BRK [0x02101000, 0x02101fff] PGTABLE
> [    0.000000] BRK [0x02102000, 0x02102fff] PGTABLE
> [    0.000000] BRK [0x02103000, 0x02103fff] PGTABLE
> [    0.000000] BRK [0x02104000, 0x02104fff] PGTABLE
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000F0120 000024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT 0x00000000DCEFE170 0000C4 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: FACP 0x00000000DCEF8000 00010C (v05 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: DSDT 0x00000000DCEDF000 013476 (v01 LENOVO TP-GR
> 00001230 INTL 20120711)
> [    0.000000] ACPI: FACS 0x00000000DCE6A000 000040
> [    0.000000] ACPI: SLIC 0x00000000DCEFD000 000176 (v01 LENOVO TP-GR
> 00001230 PTEC 00000001)
> [    0.000000] ACPI: ASF! 0x00000000DCEFC000 0000A5 (v32 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: DBGP 0x00000000DCEFB000 000034 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: ECDT 0x00000000DCEFA000 000052 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: HPET 0x00000000DCEF7000 000038 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: APIC 0x00000000DCEF6000 000098 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: MCFG 0x00000000DCEF5000 00003C (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: SSDT 0x00000000DCEF4000 000033 (v01 LENOVO TP-SSDT1
> 00000100 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x00000000DCEF3000 000486 (v01 LENOVO TP-SSDT2
> 00000200 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x00000000DCEDE000 0009CB (v01 LENOVO SataAhci
> 00001000 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x00000000DCEDD000 0007F5 (v01 LENOVO Cpu0Ist
> 00003000 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x00000000DCEDC000 000AD8 (v01 LENOVO CpuPm
> 00003000 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x00000000DCEDA000 00125C (v01 LENOVO SaSsdt
> 00003000 INTL 20120711)
> [    0.000000] ACPI: UEFI 0x00000000DCED9000 000042 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: MSDM 0x00000000DCE44000 000055 (v03 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: BATB 0x00000000DCED8000 000046 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: FPDT 0x00000000DCED7000 000064 (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: UEFI 0x00000000DCED6000 0002CE (v01 LENOVO TP-GR
> 00001230 PTEC 00000002)
> [    0.000000] ACPI: SSDT 0x00000000DCED5000 00047F (v01 LENOVO IsctTabl
> 00001000 INTL 20120711)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000021f5fffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000ce20ffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000021f5fffff]
> [    0.000000] Initmem setup node 0 [mem
> 0x0000000000001000-0x000000021f5fffff]
> [    0.000000] On node 0 totalpages: 2021292
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 13129 pages used for memmap
> [    0.000000]   DMA32 zone: 840208 pages, LIFO batch:31
> [    0.000000]   Normal zone: 18392 pages used for memmap
> [    0.000000]   Normal zone: 1177088 pages, LIFO batch:31
> [    0.000000] Reserving Intel graphics stolen memory at
> 0xdda00000-0xdf9fffff
> [    0.000000] ACPI: PM-Timer IO Port: 0x1808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
> 0-39
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xce210000-0xdcd3efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdcd3f000-0xdce7efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdce7f000-0xdcefefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdceff000-0xdfa0ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdfa10000-0xf7ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfe100fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfe101000-0xfe112fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfe113000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
> [    0.000000] e820: [mem 0xdfa10000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 1910969940391419 ns
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8
> nr_node_ids:1
> [    0.000000] percpu: Embedded 32 pages/cpu @ffff88021f200000 s91288 r8192
> d31592 u262144
> [    0.000000] pcpu-alloc: s91288 r8192 d31592 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
> pages: 1989686
> [    0.000000] Kernel command line: BOOT_IMAGE=/kernel-4.6.2 root=/dev/sda3
> ro net.ifnames=0
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608
> bytes)
> [    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304
> bytes)
> [    0.000000] Memory: 7861144K/8085168K available (8993K kernel code, 1099K
> rwdata, 2768K rodata, 1084K init, 844K bss, 224024K reserved, 0K
> cma-reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  Build-time adjustment of leaf fanout to 64.
> [    0.000000] NR_IRQS:4352 nr_irqs:760 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff,
> max_idle_ns: 133484882848 ns
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 2294.638 MHz processor
> [    0.000003] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 4589.27 BogoMIPS (lpj=2294638)
> [    0.000196] pid_max: default: 32768 minimum: 301
> [    0.000292] ACPI: Core revision 20160108
> [    0.021433] ACPI: 8 ACPI AML tables successfully acquired and loaded
>
> [    0.021689] Security Framework initialized
> [    0.021789] Mount-cache hash table entries: 16384 (order: 5, 131072
> bytes)
> [    0.021890] Mountpoint-cache hash table entries: 16384 (order: 5, 131072
> bytes)
> [    0.022281] CPU: Physical Processor ID: 0
> [    0.022373] CPU: Processor Core ID: 0
> [    0.022467] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.022564] ENERGY_PERF_BIAS: View and update with
> x86_energy_perf_policy(8)
> [    0.022676] mce: CPU supports 7 MCE banks
> [    0.022783] CPU0: Thermal monitoring enabled (TM1)
> [    0.022887] process: using mwait in idle threads
> [    0.022983] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> [    0.023080] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> [    0.023758] Freeing SMP alternatives memory: 36K (ffffffff82023000 -
> ffffffff8202c000)
> [    0.032425] smpboot: Max logical packages: 4
> [    0.032521] smpboot: APIC(0) Converting physical 0 to logical package
> 0
> [    0.033235] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.043337] TSC deadline timer enabled
> [    0.043341] smpboot: CPU0: Intel(R) Core(TM) i5-4200U CPU @ 1.60GHz
> (family: 0x6, model: 0x45, stepping: 0x1)
> [    0.043632] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events,
> full-width counters, Intel PMU driver.
> [    0.044008] ... version:                3
> [    0.044102] ... bit width:              48
> [    0.044194] ... generic registers:      4
> [    0.044287] ... value mask:             0000ffffffffffff
> [    0.044384] ... max period:             0000ffffffffffff
> [    0.044481] ... fixed-purpose events:   3
> [    0.044573] ... event mask:             000000070000000f
> [    0.045021] x86: Booting SMP configuration:
> [    0.046155] .... node  #0, CPUs:      #1 #2 #3
> [    0.232523] x86: Booted up 1 node, 4 CPUs
> [    0.232705] smpboot: Total of 4 processors activated (18376.56 BogoMIPS)
> [    0.238513] devtmpfs: initialized
> [    0.238861] PM: Registering ACPI NVS region [mem 0xdcd3f000-0xdce7efff]
> (1310720 bytes)
> [    0.239128] kworker/u16:0 (29) used greatest stack depth: 14280 bytes
> left
> [    0.239130] clocksource: jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 1911260446275000 ns
> [    0.239257] RTC time: 19:01:15, date: 06/18/16
> [    0.239394] NET: Registered protocol family 16
> [    0.244260] cpuidle: using governor ladder
> [    0.250272] cpuidle: using governor menu
> [    0.250438] ACPI FADT declares the system doesn't support PCIe ASPM, so
> disable it
> [    0.250584] ACPI: bus type PCI registered
> [    0.250845] PCI: Using configuration type 1 for base access
> [    0.250990] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
> [    0.254230] kworker/u16:2 (278) used greatest stack depth: 14184 bytes
> left
> [    0.254429] kworker/u16:1 (290) used greatest stack depth: 14160 bytes
> left
> [    0.259563] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.259852] ACPI: Added _OSI(Module Device)
> [    0.259948] ACPI: Added _OSI(Processor Device)
> [    0.260043] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.260139] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.260523] ACPI : EC: EC description table is found, configuring boot EC
> [    0.260640] ACPI : EC: EC started
> [    0.268034] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.270402] ACPI: Dynamic OEM Table Load:
> [    0.270590] ACPI: SSDT 0xFFFF880215F52800 000436 (v01 PmRef  Cpu0Cst
> 00003001 INTL 20120711)
> [    0.271758] ACPI: Dynamic OEM Table Load:
> [    0.271943] ACPI: SSDT 0xFFFF880215F53000 0005AA (v01 PmRef  ApIst
> 00003000 INTL 20120711)
> [    0.273168] ACPI: Dynamic OEM Table Load:
> [    0.273351] ACPI: SSDT 0xFFFF8800C9F61800 000119 (v01 PmRef  ApCst
> 00003000 INTL 20120711)
> [    0.275037] ACPI: Interpreter enabled
> [    0.275160] ACPI: (supports S0 S3 S4 S5)
> [    0.275255] ACPI: Using IOAPIC for interrupt routing
> [    0.275385] PCI: Using host bridge windows from ACPI; if necessary, use
> "pci=nocrs" and report a bug
> [    0.278879] ACPI: Power Resource [PUBS] (on)
> [    0.284147] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.284743] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11)
> [    0.285327] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.285914] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 9 10 11)
> [    0.286499] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.287066] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0,
> disabled.
> [    0.287777] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.288359] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 9 10 11)
> [    0.288961] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
> [    0.289067] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments
> MSI]
> [    0.289241] acpi PNP0A08:00: _OSC: not requesting OS control; OS requires
> [ExtendedConfig ASPM ClockPM MSI]
> [    0.289450] PCI host bridge to bus 0000:00
> [    0.289547] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> [    0.289653] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> [    0.289756] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff
> window]
> [    0.289900] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff
> window]
> [    0.290045] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff
> window]
> [    0.290190] pci_bus 0000:00: root bus resource [bus 00-3f]
> [    0.290295] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
> [    0.290406] pci 0000:00:02.0: [8086:0a16] type 00 class 0x030000
> [    0.290423] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
> [    0.290432] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit
> pref]
> [    0.290438] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
> [    0.290540] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
> [    0.290551] pci 0000:00:03.0: reg 0x10: [mem 0xf0530000-0xf0533fff 64bit]
> [    0.290680] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
> [    0.290699] pci 0000:00:14.0: reg 0x10: [mem 0xf0520000-0xf052ffff 64bit]
> [    0.290766] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.290805] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.290951] pci 0000:00:16.0: [8086:9c3a] type 00 class 0x078000
> [    0.290970] pci 0000:00:16.0: reg 0x10: [mem 0xf0539000-0xf053901f 64bit]
> [    0.291039] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.291123] pci 0000:00:19.0: [8086:1559] type 00 class 0x020000
> [    0.291139] pci 0000:00:19.0: reg 0x10: [mem 0xf0500000-0xf051ffff]
> [    0.291148] pci 0000:00:19.0: reg 0x14: [mem 0xf053e000-0xf053efff]
> [    0.291157] pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
> [    0.291218] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.291256] pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.291402] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
> [    0.291418] pci 0000:00:1b.0: reg 0x10: [mem 0xf0534000-0xf0537fff 64bit]
> [    0.291488] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.291568] pci 0000:00:1c.0: [8086:9c1a] type 01 class 0x060400
> [    0.291644] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.291781] pci 0000:00:1c.1: [8086:9c14] type 01 class 0x060400
> [    0.291858] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.291936] pci 0000:00:1c.1: System wakeup disabled by ACPI
> [    0.292088] pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
> [    0.292108] pci 0000:00:1d.0: reg 0x10: [mem 0xf053d000-0xf053d3ff]
> [    0.292202] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.292242] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.292387] pci 0000:00:1f.0: [8086:9c43] type 00 class 0x060100
> [    0.292578] pci 0000:00:1f.2: [8086:9c03] type 00 class 0x010601
> [    0.292593] pci 0000:00:1f.2: reg 0x10: [io  0x30a8-0x30af]
> [    0.292601] pci 0000:00:1f.2: reg 0x14: [io  0x30b4-0x30b7]
> [    0.292609] pci 0000:00:1f.2: reg 0x18: [io  0x30a0-0x30a7]
> [    0.292617] pci 0000:00:1f.2: reg 0x1c: [io  0x30b0-0x30b3]
> [    0.292625] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
> [    0.292634] pci 0000:00:1f.2: reg 0x24: [mem 0xf053c000-0xf053c7ff]
> [    0.292677] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.292752] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
> [    0.292767] pci 0000:00:1f.3: reg 0x10: [mem 0xf0538000-0xf05380ff 64bit]
> [    0.292789] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
> [    0.292925] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.293235] pci 0000:03:00.0: [8086:08b2] type 00 class 0x028000
> [    0.293319] pci 0000:03:00.0: reg 0x10: [mem 0xf0400000-0xf0401fff 64bit]
> [    0.293685] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.295818] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.295919] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf04fffff]
> [    0.295938] pci_bus 0000:00: on NUMA node 0
> [    0.296986] ACPI: Enabled 4 GPEs in block 00 to 7F
> [    0.297271] ACPI : EC: GPE = 0x25, I/O: command/status = 0x66, data =
> 0x62
> [    0.297481] vgaarb: setting as boot device: PCI:0000:00:02.0
> [    0.297582] vgaarb: device added:
> PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.297734] vgaarb: loaded
> [    0.297825] vgaarb: bridge control possible 0000:00:02.0
> [    0.298025] SCSI subsystem initialized
> [    0.298181] libata version 3.00 loaded.
> [    0.298196] ACPI: bus type USB registered
> [    0.298327] usbcore: registered new interface driver usbfs
> [    0.298446] usbcore: registered new interface driver hub
> [    0.298571] usbcore: registered new device driver usb
> [    0.298708] Linux video capture interface: v2.00
> [    0.298844] pps_core: LinuxPPS API ver. 1 registered
> [    0.298942] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo
> Giometti <giometti@linux.it>
> [    0.299097] PTP clock support registered
> [    0.299269] Advanced Linux Sound Architecture Driver Initialized.
> [    0.299386] PCI: Using ACPI for IRQ routing
> [    0.299513] PCI: pci_cache_line_size set to 64 bytes
> [    0.299823] Expanded resource reserved due to conflict with PCI Bus
> 0000:00
> [    0.299925] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
> [    0.299928] e820: reserve RAM buffer [mem 0xce210000-0xcfffffff]
> [    0.299930] e820: reserve RAM buffer [mem 0x21f600000-0x21fffffff]
> [    0.300102] Bluetooth: Core ver 2.21
> [    0.300204] NET: Registered protocol family 31
> [    0.300300] Bluetooth: HCI device and connection manager initialized
> [    0.300401] Bluetooth: HCI socket layer initialized
> [    0.300500] Bluetooth: L2CAP socket layer initialized
> [    0.300601] Bluetooth: SCO socket layer initialized
> [    0.300834] NetLabel: Initializing
> [    0.300930] NetLabel:  domain hash size = 128
> [    0.301023] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.301135] NetLabel:  unlabeled traffic allowed by default
> [    0.301332] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.301794] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.303929] clocksource: Switched to clocksource hpet
> [    0.310841] VFS: Disk quotas dquot_6.6.0
> [    0.310968] VFS: Dquot-cache hash table entries: 512 (order 0, 4096
> bytes)
> [    0.311222] pnp: PnP ACPI init
> [    0.311820] system 00:00: [mem 0x00000000-0x0009ffff] could not be
> reserved
> [    0.311936] system 00:00: [mem 0x000c0000-0x000c3fff] could not be
> reserved
> [    0.312037] system 00:00: [mem 0x000c4000-0x000c7fff] could not be
> reserved
> [    0.312138] system 00:00: [mem 0x000c8000-0x000cbfff] could not be
> reserved
> [    0.312239] system 00:00: [mem 0x000cc000-0x000cffff] could not be
> reserved
> [    0.312340] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
> [    0.312441] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
> [    0.312541] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
> [    0.312641] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
> [    0.312741] system 00:00: [mem 0x000e0000-0x000e3fff] could not be
> reserved
> [    0.312842] system 00:00: [mem 0x000e4000-0x000e7fff] could not be
> reserved
> [    0.312952] system 00:00: [mem 0x000e8000-0x000ebfff] could not be
> reserved
> [    0.313053] system 00:00: [mem 0x000ec000-0x000effff] could not be
> reserved
> [    0.313154] system 00:00: [mem 0x000f0000-0x000fffff] could not be
> reserved
> [    0.313255] system 00:00: [mem 0x00100000-0xdf9fffff] could not be
> reserved
> [    0.313356] system 00:00: [mem 0xfec00000-0xffffffff] could not be
> reserved
> [    0.313461] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.313610] pnp 00:01: [Firmware Bug]: PNP resource [mem
> 0xfed10000-0xfed13fff] covers only part of 0000:00:00.0 Intel MCH; extending
> to [mem 0xfed10000-0xfed17fff]
> [    0.313842] system 00:01: [io  0x1800-0x189f] could not be reserved
> [    0.313955] system 00:01: [io  0x0800-0x087f] has been reserved
> [    0.314055] system 00:01: [io  0x0880-0x08ff] has been reserved
> [    0.314154] system 00:01: [io  0x0900-0x097f] has been reserved
> [    0.314253] system 00:01: [io  0x0980-0x09ff] has been reserved
> [    0.314352] system 00:01: [io  0x0a00-0x0a7f] has been reserved
> [    0.314450] system 00:01: [io  0x0a80-0x0aff] has been reserved
> [    0.314549] system 00:01: [io  0x0b00-0x0b7f] has been reserved
> [    0.314647] system 00:01: [io  0x0b80-0x0bff] has been reserved
> [    0.314746] system 00:01: [io  0x15e0-0x15ef] has been reserved
> [    0.314844] system 00:01: [io  0x1600-0x167f] has been reserved
> [    0.314951] system 00:01: [io  0x1640-0x165f] has been reserved
> [    0.315051] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.315153] system 00:01: [mem 0x00000000-0x00000fff] could not be
> reserved
> [    0.315254] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.315354] system 00:01: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.315455] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.315555] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.315655] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
> [    0.315756] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.315858] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.315937] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.315968] pnp 00:03: Plug and Play ACPI device, IDs LEN0071 PNP0303
> (active)
> [    0.315995] pnp 00:04: Plug and Play ACPI device, IDs LEN0034 PNP0f13
> (active)
> [    0.316527] system 00:05: [mem 0xfe106000-0xfe106fff] has been reserved
> [    0.316631] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.316683] pnp: PnP ACPI: found 6 devices
> [    0.323875] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff,
> max_idle_ns: 2085701024 ns
> [    0.324057] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus
> 02] add_size 1000
> [    0.324061] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff
> 64bit pref] to [bus 02] add_size 200000 add_align 100000
> [    0.324064] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff]
> to [bus 02] add_size 200000 add_align 100000
> [    0.324079] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff]
> res_to_dev_res add_size 200000 min_align 100000
> [    0.324081] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x002fffff]
> res_to_dev_res add_size 200000 min_align 100000
> [    0.324084] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit
> pref] res_to_dev_res add_size 200000 min_align 100000
> [    0.324086] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x002fffff 64bit
> pref] res_to_dev_res add_size 200000 min_align 100000
> [    0.324088] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] res_to_dev_res
> add_size 1000 min_align 1000
> [    0.324091] pci 0000:00:1c.0: res[7]=[io  0x1000-0x1fff] res_to_dev_res
> add_size 1000 min_align 1000
> [    0.324096] pci 0000:00:1c.0: BAR 8: assigned [mem 0xdfb00000-0xdfcfffff]
> [    0.324203] pci 0000:00:1c.0: BAR 9: assigned [mem 0xdfd00000-0xdfefffff
> 64bit pref]
> [    0.324351] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
> [    0.324453] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.324552] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.324654] pci 0000:00:1c.0:   bridge window [mem 0xdfb00000-0xdfcfffff]
> [    0.324758] pci 0000:00:1c.0:   bridge window [mem 0xdfd00000-0xdfefffff
> 64bit pref]
> [    0.324908] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.325017] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf04fffff]
> [    0.325126] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> [    0.325128] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> [    0.325131] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff
> window]
> [    0.325133] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff
> window]
> [    0.325135] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff
> window]
> [    0.325137] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
> [    0.325139] pci_bus 0000:02: resource 1 [mem 0xdfb00000-0xdfcfffff]
> [    0.325141] pci_bus 0000:02: resource 2 [mem 0xdfd00000-0xdfefffff 64bit
> pref]
> [    0.325143] pci_bus 0000:03: resource 1 [mem 0xf0400000-0xf04fffff]
> [    0.325183] NET: Registered protocol family 2
> [    0.325470] TCP established hash table entries: 65536 (order: 7, 524288
> bytes)
> [    0.325725] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.325988] TCP: Hash tables configured (established 65536 bind 65536)
> [    0.326114] UDP hash table entries: 4096 (order: 5, 131072 bytes)
> [    0.326238] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
> [    0.326419] NET: Registered protocol family 1
> [    0.326594] RPC: Registered named UNIX socket transport module.
> [    0.326696] RPC: Registered udp transport module.
> [    0.326790] RPC: Registered tcp transport module.
> [    0.326885] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.327064] pci 0000:00:02.0: Video device with shadowed ROM at [mem
> 0x000c0000-0x000dffff]
> [    0.327700] PCI: CLS 64 bytes, default 64
> [    0.327729] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.327832] software IO TLB [mem 0xca210000-0xce210000] (64MB) mapped at
> [ffff8800ca210000-ffff8800ce20ffff]
> [    0.328082] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360
> ms ovfl timer
> [    0.329310] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
> [    0.329408] RAPL PMU: hw unit of domain package 2^-14 Joules
> [    0.329504] RAPL PMU: hw unit of domain dram 2^-14 Joules
> [    0.329601] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
> [    0.330119] Scanning for low memory corruption every 60 seconds
> [    0.330598] futex hash table entries: 2048 (order: 5, 131072 bytes)
> [    0.330737] audit: initializing netlink subsys (disabled)
> [    0.330844] audit: type=2000 audit(1466276474.314:1): initialized
> [    0.331567] workingset: timestamp_bits=60 max_order=21 bucket_order=0
> [    0.335140] NFS: Registering the id_resolver key type
> [    0.335246] Key type id_resolver registered
> [    0.335342] Key type id_legacy registered
> [    0.335501] fuse init (API version 7.24)
> [    0.336731] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 251)
> [    0.336885] io scheduler noop registered
> [    0.337038] io scheduler deadline registered
> [    0.337177] io scheduler cfq registered (default)
> [    0.337649] intel_idle: MWAIT substates: 0x11142120
> [    0.337652] intel_idle: v0.4.1 model 0x45
> [    0.337924] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.338106] ACPI: AC Adapter [AC] (on-line)
> [    0.338281] input: Lid Switch as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> [    0.338560] ACPI: Lid Switch [LID]
> [    0.338697] input: Sleep Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
> [    0.338852] ACPI: Sleep Button [SLPB]
> [    0.339076] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    0.339229] ACPI: Power Button [PWRF]
> [    0.340623] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.340724] ACPI: Thermal Zone [THM0] (45 C)
> [    0.340893] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.341643] Non-volatile memory driver v1.3
> [    0.341812] Linux agpgart interface v0.103
> [    0.341990] [drm] Initialized drm 1.1.0 20060810
> [    0.342731] [drm] Memory usable by graphics device = 2048M
> [    0.342883] [drm] Replacing VGA console driver
> [    0.344095] Console: switching to colour dummy device 80x25
> [    0.349322] ACPI: Battery Slot [BAT0] (battery present)
> [    0.350072] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    0.350078] [drm] Driver supports precise vblank timestamp query.
> [    0.350404] vgaarb: device changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    0.389347] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    0.389938] input: Video Bus as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
> [    0.389997] [drm] Initialized i915 1.6.0 20160229 for 0000:00:02.0 on
> minor 0
> [    0.391982] loop: module loaded
> [    0.392110] ahci 0000:00:1f.2: version 3.0
> [    0.402379] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 3 ports 6 Gbps 0x1
> impl SATA mode
> [    0.402393] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum
> part deso sadm sds apst
> [    0.402925] scsi host0: ahci
> [    0.403073] scsi host1: ahci
> [    0.403179] scsi host2: ahci
> [    0.403233] ata1: SATA max UDMA/133 abar m2048@0xf053c000 port 0xf053c100
> irq 41
> [    0.403240] ata2: DUMMY
> [    0.403244] ata3: DUMMY
> [    0.403383] e1000: Intel(R) PRO/1000 Network Driver - version
> 7.3.21-k8-NAPI
> [    0.403389] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    0.403412] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [    0.403417] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    0.403584] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set
> to dynamic conservative mode
> [    0.566997] fbcon: inteldrmfb (fb0) is primary device
> [    0.706983] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    0.719971] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
> succeeded
> [    0.719974] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK)
> filtered out
> [    0.722129] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES)
> succeeded
> [    0.727893] ata1.00: supports DRM functions and may not be fully
> accessible
> [    0.730026] ata1.00: ATA-9: INTEL SSDSCKGF180A4L, LSTi, max UDMA/133
> [    0.730029] ata1.00: 351651888 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    0.750022] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
> succeeded
> [    0.750024] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK)
> filtered out
> [    0.752120] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES)
> succeeded
> [    0.757897] ata1.00: supports DRM functions and may not be fully
> accessible
> [    0.767970] ata1.00: configured for UDMA/133
> [    0.826761] e1000e 0000:00:19.0 eth0: registered PHC clock
> [    0.826763] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1)
> 54:ee:75:07:92:a9
> [    0.826764] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network
> Connection
> [    0.826801] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No:
> 1000FF-0FF
> [    0.826834] igb: Intel(R) Gigabit Ethernet Network Driver - version
> 5.3.0-k
> [    0.826834] igb: Copyright (c) 2007-2014 Intel Corporation.
> [    0.826858] igbvf: Intel(R) Gigabit Virtual Function Network Driver -
> version 2.0.2-k
> [    0.826858] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
> [    0.826973] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.826976] ehci-pci: EHCI PCI platform driver
> [    0.827128] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    0.827182] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus
> number 1
> [    0.827195] ehci-pci 0000:00:1d.0: debug port 2
> [    0.831108] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    0.831122] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf053d000
> [    0.837021] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    0.837071] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.837072] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.837074] usb usb1: Product: EHCI Host Controller
> [    0.837075] usb usb1: Manufacturer: Linux 4.6.2 ehci_hcd
> [    0.837076] usb usb1: SerialNumber: 0000:00:1d.0
> [    0.837271] hub 1-0:1.0: USB hub found
> [    0.837279] hub 1-0:1.0: 3 ports detected
> [    0.837469] ehci-platform: EHCI generic platform driver
> [    0.837496] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.837512] ohci-pci: OHCI PCI platform driver
> [    0.837537] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.837680] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.837736] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
> number 2
> [    0.838822] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version
> 0x100 quirks 0x0004b810
> [    0.838827] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    0.838910] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.838911] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.838912] usb usb2: Product: xHCI Host Controller
> [    0.838913] usb usb2: Manufacturer: Linux 4.6.2 xhci-hcd
> [    0.838914] usb usb2: SerialNumber: 0000:00:14.0
> [    0.839063] hub 2-0:1.0: USB hub found
> [    0.839077] hub 2-0:1.0: 9 ports detected
> [    0.841021] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.841068] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
> number 3
> [    0.841107] usb usb3: New USB device found, idVendor=1d6b, idProduct=0003
> [    0.841108] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.841110] usb usb3: Product: xHCI Host Controller
> [    0.841111] usb usb3: Manufacturer: Linux 4.6.2 xhci-hcd
> [    0.841112] usb usb3: SerialNumber: 0000:00:14.0
> [    0.841243] hub 3-0:1.0: USB hub found
> [    0.841254] hub 3-0:1.0: 4 ports detected
> [    0.842267] usbcore: registered new interface driver usblp
> [    0.842305] usbcore: registered new interface driver usb-storage
> [    0.842355] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at
> 0x60,0x64 irq 1,12
> [    0.844196] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.844200] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.844360] mousedev: PS/2 mouse device common for all mice
> [    0.844656] rtc_cmos 00:02: RTC can wake from S4
> [    0.844821] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    0.844848] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram,
> hpet irqs
> [    0.845003] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> [    0.845876] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input4
> [    0.846822] IR NEC protocol handler initialized
> [    0.846826] IR RC5(x/sz) protocol handler initialized
> [    0.846829] IR RC6 protocol handler initialized
> [    0.846833] IR JVC protocol handler initialized
> [    0.846836] IR Sony protocol handler initialized
> [    0.846840] IR SANYO protocol handler initialized
> [    0.846843] IR Sharp protocol handler initialized
> [    0.846847] IR MCE Keyboard/mouse protocol handler initialized
> [    0.846850] IR XMP protocol handler initialized
> [    0.846875] usbcore: registered new interface driver uvcvideo
> [    0.846876] USB Video Class driver (1.1.1)
> [    0.847024] Bluetooth: HCI UART driver ver 2.3
> [    0.847026] Bluetooth: HCI UART protocol H4 registered
> [    0.847026] Bluetooth: HCI UART protocol BCSP registered
> [    0.847027] Bluetooth: HCI UART protocol LL registered
> [    0.847028] Bluetooth: HCI UART protocol ATH3K registered
> [    0.847028] Bluetooth: HCI UART protocol Three-wire (H5) registered
> [    0.847048] usbcore: registered new interface driver btusb
> [    0.847088] hidraw: raw HID events driver (C) Jiri Kosina
> [    0.847332] usbcore: registered new interface driver usbhid
> [    0.847333] usbhid: USB HID core driver
> [    0.847613] Netfilter messages via NETLINK v0.30.
> [    0.847630] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
> [    0.847986] Initializing XFRM netlink socket
> [    0.847994] NET: Registered protocol family 17
> [    0.848034] Bluetooth: RFCOMM TTY layer initialized
> [    0.848037] Bluetooth: RFCOMM socket layer initialized
> [    0.848041] Bluetooth: RFCOMM ver 1.11
> [    0.848048] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [    0.848052] Bluetooth: HIDP socket layer initialized
> [    0.848083] Key type dns_resolver registered
> [    0.848373] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x1c
> [    0.848382] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x1c
> [    0.848394] microcode: CPU2 sig=0x40651, pf=0x40, revision=0x1c
> [    0.848404] microcode: CPU3 sig=0x40651, pf=0x40, revision=0x1c
> [    0.848441] microcode: Microcode Update Driver: v2.01
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    0.848652] registered taskstats version 1
> [    0.849234]   Magic number: 4:330:41
> [    0.849250] bdi 7:6: hash matches
> [    1.139039] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    1.194038] usb 2-4: new high-speed USB device number 2 using xhci_hcd
> [    1.253766] usb 1-1: New USB device found, idVendor=8087, idProduct=8000
> [    1.253768] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    1.254036] hub 1-1:1.0: USB hub found
> [    1.254260] hub 1-1:1.0: 8 ports detected
> [    1.329990] psmouse serio1: synaptics: queried max coordinates: x
> [..5112], y [..3834]
> [    1.330000] tsc: Refined TSC clocksource calibration: 2294.686 MHz
> [    1.330002] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
> 0x211399552f8, max_idle_ns: 440795292447 ns
> [    1.363006] psmouse serio1: synaptics: queried min coordinates: x
> [1024..], y [1024..]
> [    1.363011] psmouse serio1: synaptics: quirked min/max coordinates: x
> [1024..5112], y [2024..4832]
> [    1.365412] usb 2-4: New USB device found, idVendor=1199, idProduct=a001
> [    1.365414] usb 2-4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    1.365415] usb 2-4: Product: Sierra Wireless EM7345 4G LTE
> [    1.365417] usb 2-4: Manufacturer: Sierra Wireless Inc.
> [    1.365418] usb 2-4: SerialNumber: 013937000496677
> [    1.425952] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id:
> 0x1e2b1, caps: 0xd002a3/0x940300/0x127c00/0x0, board id: 2668, fw id:
> 1545510
> [    1.425980] psmouse serio1: synaptics: serio: Synaptics pass-through port
> at isa0060/serio1/input0
> [    1.467198] input: SynPS/2 Synaptics TouchPad as
> /devices/platform/i8042/serio1/input/input6
> [    1.530046] usb 1-1.8: new high-speed USB device number 3 using ehci-pci
> [    1.530963] usb 2-6: new full-speed USB device number 3 using xhci_hcd
> [    1.640531] usb 1-1.8: New USB device found, idVendor=04f2,
> idProduct=b3f5
> [    1.640534] usb 1-1.8: New USB device strings: Mfr=3, Product=1,
> SerialNumber=2
> [    1.640535] usb 1-1.8: Product: Integrated Camera
> [    1.640536] usb 1-1.8: Manufacturer: Chicony Electronics Co.,Ltd.
> [    1.640537] usb 1-1.8: SerialNumber: 0x0001
> [    1.642187] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b3f5)
> [    1.643866] input: Integrated Camera as
> /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.8/1-1.8:1.0/input/input8
> [    1.697658] usb 2-6: New USB device found, idVendor=138a, idProduct=0017
> [    1.697660] usb 2-6: New USB device strings: Mfr=0, Product=0,
> SerialNumber=1
> [    1.697661] usb 2-6: SerialNumber: 78916408f2b4
> [    1.851001] usb 2-7: new full-speed USB device number 4 using xhci_hcd
> [    2.002995] Console: switching to colour frame buffer device 320x90
> [    2.016156] usb 2-7: New USB device found, idVendor=8087, idProduct=07dc
> [    2.016159] usb 2-7: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    2.029636] Bluetooth: hci0: read Intel version: 370710018002030d00
> [    2.029651] bluetooth hci0: Direct firmware load for
> intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq failed with error -2
> [    2.029653] Bluetooth: hci0 failed to open Intel firmware file:
> intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq(-2)
> [    2.029661] bluetooth hci0: Direct firmware load for
> intel/ibt-hw-37.7.bseq failed with error -2
> [    2.029662] Bluetooth: hci0 failed to open default Intel fw file:
> intel/ibt-hw-37.7.bseq
> [    2.117813] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e,
> buttons: 3/3
> [    2.162388] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    2.164476] console [netcon0] enabled
> [    2.166461] netconsole: network logging started
> [    2.169571] PM: Hibernation image not present or could not be loaded.
> [    2.169576] ALSA device list:
> [    2.171571]   No soundcards found.
> [    2.175327] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSCKGF18
> LSTi PQ: 0 ANSI: 5
> [    2.190402] sd 0:0:0:0: [sda] 351651888 512-byte logical blocks: (180
> GB/168 GiB)
> [    2.190411] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    2.196003] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    2.199406] sd 0:0:0:0: [sda] Write Protect is off
> [    2.202721] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.202761] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    2.208859]  sda: sda1 sda2 sda3
> [    2.210887] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.330247] clocksource: Switched to clocksource tsc
> [    2.334213] input: TPPS/2 IBM TrackPoint as
> /devices/platform/i8042/serio1/serio2/input/input7
> [    2.416442] EXT4-fs (sda3): couldn't mount as ext3 due to feature
> incompatibilities
> [    2.425152] EXT4-fs (sda3): mounted filesystem with ordered data mode.
> Opts: (null)
> [    2.426963] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
> [    2.428912] devtmpfs: mounted
> [    2.431403] Freeing unused kernel memory: 1084K (ffffffff81f14000 -
> ffffffff82023000)
> [    2.432636] Write protecting the kernel read-only data: 14336k
> [    2.434250] Freeing unused kernel memory: 1228K (ffff8800018cd000 -
> ffff880001a00000)
> [    2.438522] Freeing unused kernel memory: 1328K (ffff880001cb4000 -
> ffff880001e00000)
> [    2.493209] setfont (1160) used greatest stack depth: 13656 bytes left
> [    2.522615] init-early.sh (1159) used greatest stack depth: 13048 bytes
> left
> [    2.903608] systemd-udevd[1373]: starting version 218
> [    2.907958] systemd-udevd[1373]: Network interface NamePolicy= disabled
> on kernel command line, ignoring.
> [    2.908114] random: systemd-udevd urandom read with 38 bits of entropy
> available
> [    3.016335] thinkpad_acpi: ThinkPad ACPI Extras v0.25
> [    3.016339] thinkpad_acpi: http://ibm-acpi.sf.net/
> [    3.016341] thinkpad_acpi: ThinkPad BIOS GRET46WW (1.23 ), EC unknown
> [    3.016342] thinkpad_acpi: Lenovo ThinkPad X1 Carbon 2nd, model
> 20A7005MGE
> [    3.017094] thinkpad_acpi: unknown version of the HKEY interface: 0x200
> [    3.017097] thinkpad_acpi: please report this to
> ibm-acpi-devel@lists.sourceforge.net
> [    3.017105] thinkpad_acpi: radio switch found; radios are enabled
> [    3.017121] thinkpad_acpi: This ThinkPad has standard ACPI backlight
> brightness control, supported by the ACPI video driver
> [    3.017122] thinkpad_acpi: Disabling thinkpad-acpi brightness events by
> default...
> [    3.018688] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is
> unblocked
> [    3.019369] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is
> unblocked
> [    3.019849] systemd-udevd[1374]: Network interface NamePolicy= disabled
> on kernel command line, ignoring.
> [    3.020801] thinkpad_acpi: warning: userspace override of important
> firmware LEDs is enabled
> [    3.022038] input: ThinkPad Extra Buttons as
> /devices/platform/thinkpad_acpi/input/input9
> [    3.022538] systemd-udevd (1407) used greatest stack depth: 12944 bytes
> left
> [    3.046029] Intel(R) Wireless WiFi driver for Linux
> [    3.046032] Copyright(c) 2003- 2015 Intel Corporation
> [    3.049928] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops
> 0xffffffff81a84050)
> [    3.061421] iwlwifi 0000:03:00.0: loaded firmware version 17.265642.0
> op_mode iwlmvm
> [    3.064140] snd_hda_codec_generic hdaudioC1D0: autoconfig for Generic:
> line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
> [    3.064145] snd_hda_codec_generic hdaudioC1D0:    speaker_outs=0
> (0x0/0x0/0x0/0x0/0x0)
> [    3.064148] snd_hda_codec_generic hdaudioC1D0:    hp_outs=1
> (0x15/0x0/0x0/0x0/0x0)
> [    3.064150] snd_hda_codec_generic hdaudioC1D0:    mono: mono_out=0x0
> [    3.064151] snd_hda_codec_generic hdaudioC1D0:    inputs:
> [    3.064154] snd_hda_codec_generic hdaudioC1D0:      Mic=0x1a
> [    3.064156] snd_hda_codec_generic hdaudioC1D0:      Internal Mic=0x12
> [    3.068860] input: HDA Intel PCH Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
> [    3.068965] snd_hda_intel 0000:00:03.0: Too many HDMI devices
> [    3.068969] snd_hda_intel 0000:00:03.0: Consider building the kernel with
> CONFIG_SND_DYNAMIC_MINORS=y
> [    3.069120] input: HDA Intel PCH Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
> [    3.069343] iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC
> 7260, REV=0x144
> [    3.069833] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
> [    3.070499] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
> [    3.071665] input: HDA Intel HDMI HDMI/DP,pcm=3 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input12
> [    3.072275] input: HDA Intel HDMI HDMI/DP,pcm=7 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input13
> [    3.072467] input: HDA Intel HDMI HDMI/DP as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input14
> [    3.091091] cdc_ncm 2-4:1.0: MAC-Address: ff:ff:ff:ff:ff:ff
> [    3.091096] cdc_ncm 2-4:1.0: setting rx_max = 16384
> [    3.091872] cdc_ncm 2-4:1.0 usb0: register 'cdc_ncm' at
> usb-0000:00:14.0-4, CDC NCM, ff:ff:ff:ff:ff:ff
> [    3.091903] usbcore: registered new interface driver cdc_ncm
> [    3.277887] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> [    3.438586] EXT4-fs (sda3): re-mounted. Opts: (null)
> [    3.528197] Adding 2097148k swap on /dev/sda2.  Priority:-1 extents:1
> across:2097148k SS
> [    5.869460] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
> [    5.870078] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
> [    6.062495] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
> [    6.063115] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
> [    6.092691] ip (2349) used greatest stack depth: 12192 bytes left
> [    8.685944] random: nonblocking pool is initialized
> [    9.368752] wlan0: authenticate with e4:f4:c6:0a:bb:8b
> [    9.372797] wlan0: send auth to e4:f4:c6:0a:bb:8b (try 1/3)
> [    9.373419] wlan0: authenticated
> [    9.374132] wlan0: associate with e4:f4:c6:0a:bb:8b (try 1/3)
> [    9.375186] wlan0: RX AssocResp from e4:f4:c6:0a:bb:8b (capab=0x1011
> status=0 aid=1)
> [    9.376508] wlan0: associated
> [   55.030187] usb 2-2: new high-speed USB device number 5 using xhci_hcd
> [   55.194925] usb 2-2: New USB device found, idVendor=2040, idProduct=0264
> [   55.194934] usb 2-2: New USB device strings: Mfr=3, Product=1,
> SerialNumber=2
> [   55.194939] usb 2-2: Product: soloHD
> [   55.194942] usb 2-2: Manufacturer: HCW
> [   55.194945] usb 2-2: SerialNumber: 0011548565
> [   55.386950] em28xx: New device HCW soloHD @ 480 Mbps (2040:0264,
> interface 0, class 0)
> [   55.386956] em28xx: DVB interface 0 found: isoc
> [   55.387013] em28xx: chip ID is em28178
> [   57.321297] em28178 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0xcce4cb04
> [   57.321304] em28178 #0: EEPROM info:
> [   57.321307] em28178 #0:      microcode start address = 0x0004, boot
> configuration = 0x01
> [   57.328249] em28178 #0:      AC97 audio (5 sample rates)
> [   57.328256] em28178 #0:      500mA max power
> [   57.328260] em28178 #0:      Table at offset 0x27, strings=0x0e6a,
> 0x1888, 0x087e
> [   57.328360] em28178 #0: Identified as PCTV tripleStick (292e) (card=94)
> [   57.328366] em28178 #0: dvb set to isoc mode.
> [   57.328423] usbcore: registered new interface driver em28xx
> [   57.335752] em28178 #0: Binding DVB extension
> [   57.338179] i2c i2c-11: Added multiplexed i2c bus 12
> [   57.338185] si2168 11-0064: Silicon Labs Si2168 successfully attached
> [   57.340481] si2157 12-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   57.340490] DVB: registering new adapter (em28178 #0)
> [   57.340494] usb 2-2: DVB: registering adapter 0 frontend 0 (Silicon Labs
> Si2168)...
> [   57.340896] em28178 #0: DVB extension successfully initialized
> [   57.340901] em28xx: Registered (Em28xx dvb Extension) extension
> [   57.343406] em28178 #0: Registering input extension
> [   57.343526] Registered IR keymap rc-pinnacle-pctv-hd
> [   57.343608] input: em28xx IR (em28178 #0) as
> /devices/pci0000:00/0000:00:14.0/usb2/2-2/rc/rc0/input15
> [   57.343680] rc rc0: em28xx IR (em28178 #0) as
> /devices/pci0000:00/0000:00:14.0/usb2/2-2/rc/rc0
> [   57.343787] em28178 #0: Input extension successfully initalized
> [   57.343789] em28xx: Registered (Em28xx Input Extension) extension
> [  101.423697] si2168 11-0064: found a 'Silicon Labs Si2168-B40'
> [  101.428693] si2168 11-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [  101.657999] si2168 11-0064: firmware version: 4.0.11
> [  101.661225] si2157 12-0060: found a 'Silicon Labs Si2157-A30'
> [  101.709738] si2157 12-0060: firmware version: 3.0.5
>
>
> Another thing. At the end of w_scan i get:
>
> tune to: QAM_16   f = 778000 kHz I999B8C23D0T8G8Y0 (8468:12297:2305) (time:
> 05:43.352)
>         service = 1-2-3.tv (MEDIA BROADCAST)
>         service = RTLNITRO (MEDIA BROADCAST)
>         service = TLC (MEDIA BROADCAST)
>         service = JuweloSK (MEDIA BROADCAST)
> tune to: QAM_AUTO f = 650000 kHz I999B8C999D999T32G16Y999P0
> (8468:12352:16481) (time: 05:57.355)
> ----------no signal----------
> tune to: QAM_AUTO f = 650000 kHz I999B8C999D999T999G999Y999P0
> (8468:12352:16481) (time: 06:03.441)  (no signal)
> ----------no signal----------
> tune to: QAM_AUTO f = 642000 kHz I999B8C0D0T32G16Y0P1 (8468:12352:16497)
> (time: 06:09.478)
>         updating transponder:
>            (QAM_AUTO f = 650000 kHz I999B8C999D999T999G999Y999P0
> (8468:12352:16481)) 0x0000
>         to (QAM_AUTO f = 650000 kHz I999B8C0D0T32G16Y0P0 (8468:12352:16481))
> 0x4004
>         service = ssu (Harmonic)
>         service = multithek dvb-t (Internet) (Media Broadcast)
> tune to: QAM_64   f = 578000 kHz I999B8C23D0T8G4Y0 (8468:12348:15361) (time:
> 06:25.355)
> ----------no signal----------
> tune to: QAM_AUTO f = 578000 kHz I999B8C999D0T999G999Y0 (8468:12348:15361)
> (time: 06:31.436)  (no signal)
> ----------no signal----------
> tune to: QAM_16   f = 730000 kHz I999B8C34D0T8G4Y0 (8468:12361:18689) (time:
> 06:37.533)
> ----------no signal----------
> tune to: QAM_AUTO f = 730000 kHz I999B8C999D0T999G999Y0 (8468:12361:18689)
> (time: 06:43.620)  (no signal)
> ----------no signal----------
> tune to: QAM_16   f = 762000 kHz I999B8C23D0T8G4Y0 (8468:12368:20481) (time:
> 06:49.706)
> ----------no signal----------
> tune to: QAM_AUTO f = 762000 kHz I999B8C999D0T999G999Y0 (8468:12368:20481)
> (time: 06:55.793)  (no signal)
> ----------no signal----------
> retrying with center_frequency = 514000000
> tune to: QAM_16   f = 514000 kHz I999B8C23D0T8G4Y0 (8468:12306:4609) (time:
> 07:01.879)
> ----------no signal----------
> tune to: QAM_AUTO f = 514000 kHz I999B8C999D0T999G999Y0 (8468:12306:4609)
> (time: 07:07.964)  (no signal)
> ----------no signal----------
> tune to: QAM_64   f = 474000 kHz I999B8C23D0T8G4Y0 (8468:12346:14849) (time:
> 07:14.051)
> ----------no signal----------
> tune to: QAM_AUTO f = 474000 kHz I999B8C999D0T999G999Y0 (8468:12346:14849)
> (time: 07:20.138)  (no signal)
> ----------no signal----------
> (time: 07:26.222) dumping lists (57 services)
>
> Is that helping?
>
> thanks again.
>
> t.
>
>
>
> On 2016-06-18 18:56, Olli Salonen wrote:
>>
>> Hi Thomas,
>>
>> Please reboot your PC, run w_scan and then send the full output of
>> dmesg command. Maybe the driver has printed something in the logs that
>> can help us narrow the cause.
>>
>> Cheers,
>> -olli
>>
>> On 18 June 2016 at 18:55, Thomas Stein <himbeere@meine-oma.de> wrote:
>>>
>>> Hello.
>>>
>>> I'm trying to get a dvb usb stick Hauppauge WinTV-soloHD running. I saw
>>> there is general support already in the kernel.
>>>
>>> https://git.linuxtv.org/media_tree.git/commit/?id=1efc21701d94ed0c5b91467b042bed8b8becd5cc
>>>
>>> I'm able to use this device for dvb-t but not dvb-t2. I'm living in
>>> berlin
>>> so it should work. w_scan is scanning dvb-t2 and seems
>>> to find channels:
>>>
>>> Scanning DVB-T2...
>>> Scanning 7MHz frequencies...
>>> 177500: (time: 02:17.828)
>>> 184500: (time: 02:19.828)
>>> 191500: (time: 02:21.876)
>>> 198500: (time: 02:23.924)
>>> 205500: (time: 02:25.971)
>>> 212500: (time: 02:27.971)
>>> 219500: (time: 02:30.021)
>>> 226500: (time: 02:32.071)
>>> Scanning 8MHz frequencies...
>>> 474000: (time: 02:34.120)
>>> 482000: (time: 02:36.121)
>>> 490000: (time: 02:38.169)
>>> 498000: (time: 02:40.219)
>>> 506000: skipped (already known transponder)
>>> 514000: (time: 02:42.268)
>>> 522000: skipped (already known transponder)
>>> 530000: (time: 02:44.318)
>>> 538000: (time: 02:46.368)
>>> 546000: (time: 02:48.417)
>>> 554000: (time: 02:50.417)
>>> 562000: (time: 02:52.467)
>>> 570000: skipped (already known transponder)
>>> 578000: (time: 02:54.467)
>>> 586000: (time: 02:56.469)
>>> 594000: (time: 02:58.469)
>>> 602000: (time: 03:00.518)
>>> 610000: (time: 03:02.567)
>>> 618000: skipped (already known transponder)
>>> 626000: (time: 03:04.617)
>>> 634000: (time: 03:06.617)
>>> 642000: (time: 03:08.667)         signal ok:    QAM_AUTO f = 642000 kHz
>>> I999B8C999D999T999G999Y999P0 (0:0:0)
>>>         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 (0:0:0) :
>>> updating transport_stream_id: -> (0:0:16481)
>>>         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0 (0:0:16481)
>>> :
>>> updating network_id -> (0:12352:16481)
>>>         QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0
>>> (0:12352:16481)
>>> : updating original_network_id -> (8468:12352:16481)
>>>         updating transponder:
>>>            (QAM_AUTO f = 642000 kHz I999B8C999D999T999G999Y999P0
>>> (8468:12352:16481)) 0x0000
>>>         to (QAM_AUTO f = 650000 kHz I999B8C999D999T32G16Y999P0
>>> (8468:12352:16481)) 0x4004
>>>         new transponder: (QAM_AUTO f = 642000 kHz I999B8C0D0T32G16Y0P1
>>> (8468:12352:16497)) 0x4004
>>> 650000: skipped (already known transponder)
>>> 658000: skipped (already known transponder)
>>> 666000: (time: 03:10.382)
>>> 674000: (time: 03:12.429)
>>> 682000: skipped (already known transponder)
>>> 690000: (time: 03:14.476)
>>> 698000: (time: 03:16.528)
>>> 706000: skipped (already known transponder)
>>> 714000: (time: 03:18.575)
>>> 722000: (time: 03:20.623)
>>> 730000: (time: 03:22.669)
>>> 738000: (time: 03:24.716)
>>> 746000: (time: 03:26.764)
>>> 754000: skipped (already known transponder)
>>> 762000: (time: 03:28.811)
>>> 770000: (time: 03:30.860)
>>> 778000: skipped (already known transponder)
>>> 786000: (time: 03:32.908)
>>> 794000: (time: 03:34.953)
>>> 802000: (time: 03:36.999)
>>> 810000: (time: 03:39.045)
>>> 818000: (time: 03:41.045)
>>> 826000: (time: 03:43.091)
>>> 834000: (time: 03:45.137)
>>> 842000: (time: 03:47.185)
>>> 850000: (time: 03:49.231)
>>> 858000: (time: 03:51.277)
>>>
>>> So the question is, what is going wrong? When i start vlc with dvb-t2
>>> channels file for berlin i get:
>>>
>>> [00007f7e0c01a0e8] ts demux error: cannot peek
>>>
>>> Any hints appreciated.
>>>
>>> cheers
>>> t.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
