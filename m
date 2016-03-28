Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58552 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbcC1SKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 14:10:17 -0400
Date: Mon, 28 Mar 2016 15:09:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: <linux-media@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 0/2] media: Revert broken locking changes
Message-ID: <20160328150948.3efa93ee@recife.lan>
In-Reply-To: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 25 Mar 2016 00:22:42 +0200
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> Commit c38077d39c7e ("[media] media-device: get rid of the spinlock")
> introduced a deadlock in the MEDIA_IOC_ENUM_LINKS ioctl handler.
> 
> Revert the broken commit as well as another that has been merged on top, and
> let's implement a proper fix instead of half-baked hacks this time.
> 
> [ 2760.127749] INFO: task media-ctl:954 blocked for more than 120 seconds.
> [ 2760.131867]       Not tainted 4.5.0+ #357
> [ 2760.134622] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2760.139310] media-ctl       D ffffffc000086bcc     0   954    671 0x00000001
> [ 2760.143618] Call trace:
> [ 2760.145601] [<ffffffc000086bcc>] __switch_to+0x90/0xa4
> [ 2760.148941] [<ffffffc0004e6ef0>] __schedule+0x188/0x5b0
> [ 2760.152309] [<ffffffc0004e7354>] schedule+0x3c/0xa0
> [ 2760.155495] [<ffffffc0004e7768>] schedule_preempt_disabled+0x20/0x38
> [ 2760.159423] [<ffffffc0004e8d28>] __mutex_lock_slowpath+0xc4/0x148
> [ 2760.163217] [<ffffffc0004e8df0>] mutex_lock+0x44/0x5c
> [ 2760.166483] [<ffffffc0003e87d4>] find_entity+0x2c/0xac
> [ 2760.169773] [<ffffffc0003e8d34>] __media_device_enum_links+0x20/0x1dc
> [ 2760.173711] [<ffffffc0003e9718>] media_device_ioctl+0x214/0x33c
> [ 2760.177384] [<ffffffc0003e9eec>] media_ioctl+0x24/0x3c
> [ 2760.180671] [<ffffffc0001bee64>] do_vfs_ioctl+0xac/0x758
> [ 2760.184026] [<ffffffc0001bf594>] SyS_ioctl+0x84/0x98
> [ 2760.187196] [<ffffffc000085d30>] el0_svc_naked+0x24/0x28
> 
> 
> Laurent Pinchart (2):
>   Revert "[media] media-device: use kref for media_device instance"

This patch is unrelated with the above error report.

>   Revert "[media] media-device: get rid of the spinlock"

When Sakari proposed to replace the spin locks by a mutex, I was naive 
to expect that the MC won't be getting both spin_lock and mutex locks
at the same time to protect the same memory, as it seems silly...

Anyway, the fix for that is simple. I'm sending the patches in a few.

On my test scenario, I'm using a 4 CPU i7core machine with 5
endless loop processes running on it, being:

3 processes testing media-ctl -p, using this script:
	https://mchehab.fedorapeople.org/mc_stress_test_scripts/mediactl-test-loop.sh

2 processes testing mc_nextgen_test, using this script:
	https://mchehab.fedorapeople.org/mc_stress_test_scripts/mc-test-loop.sh

I ran each loop for more than 10k interactions of media-ctl and about
20k interactions of mc_nextgen_test[1], and tested wit both uvcvideo
and au0828+snd-usb-audio drivers.

[1] It looks like getting the entire topology calling G_TOPOLOGY
twice is two times faster than using the legacy ioctls (even
retrieving more information - interfaces and interface links), with
seems a good sign that the new API works better. The same behavior
happened with both uvcvideo and au0828.


Javier,

Could you please test them with OMAP3?

Thanks,
Mauro

dmesg logs of the testset, with KASAN and mutex instrumentation tests
enabled:

1) Logs before the test

[    0.000000] microcode: microcode updated early to revision 0x22, date = 2015-09-11
[    0.000000] Linux version 4.5.0+ (mchehab@silver) (gcc version 5.3.1 20160307 (Debian 5.3.1-11) ) #65 SMP Thu Mar 24 13:50:44 BRT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.5.0+ root=/dev/mapper/silver--vg-root ro quiet console=tty0 console=ttyUSB0,115200n8 loglevel=7
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Supporting XSAVE feature 0x01: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x02: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x04: 'AVX registers'
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009cf6bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000009cf6c000-0x000000009d431fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009d432000-0x00000000a2296fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a2297000-0x00000000a2351fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a2352000-0x00000000a2377fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000a2378000-0x00000000a2ca7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a2ca8000-0x00000000a2ffefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a2fff000-0x00000000a2ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a3800000-0x00000000a7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000456ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x457000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7F80000000 write-back
[    0.000000]   1 base 0080000000 mask 7FE0000000 write-back
[    0.000000]   2 base 00A0000000 mask 7FFE000000 write-back
[    0.000000]   3 base 00A2000000 mask 7FFF000000 write-back
[    0.000000]   4 base 0100000000 mask 7F00000000 write-back
[    0.000000]   5 base 0200000000 mask 7E00000000 write-back
[    0.000000]   6 base 0400000000 mask 7F80000000 write-back
[    0.000000]   7 base 0460000000 mask 7FE0000000 uncachable
[    0.000000]   8 base 0458000000 mask 7FF8000000 uncachable
[    0.000000]   9 base 0457000000 mask 7FFF000000 uncachable
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: update [mem 0xa3000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xa3000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcb60-0x000fcb6f] mapped at [ffff8800000fcb60]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x0456c000, 0x0456cfff] PGTABLE
[    0.000000] BRK [0x0456d000, 0x0456dfff] PGTABLE
[    0.000000] BRK [0x0456e000, 0x0456efff] PGTABLE
[    0.000000] BRK [0x0456f000, 0x0456ffff] PGTABLE
[    0.000000] BRK [0x04570000, 0x04570fff] PGTABLE
[    0.000000] BRK [0x04571000, 0x04571fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35796000-0x36bc2fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F05B0 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000A2359090 00009C (v01 INTEL  NUC5i7RY 0000015E AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000A236F040 00010C (v05 INTEL  NUC5i7RY 0000015E AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000A23591B8 015E82 (v02 INTEL  NUC5i7RY 0000015E INTL 20120913)
[    0.000000] ACPI: FACS 0x00000000A2CA6F80 000040
[    0.000000] ACPI: APIC 0x00000000A236F150 000084 (v03 INTEL  NUC5i7RY 0000015E AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000A236F1D8 000044 (v01 INTEL  NUC5i7RY 0000015E AMI  00010013)
[    0.000000] ACPI: FIDT 0x00000000A236F220 00009C (v01 INTEL  NUC5i7RY 0000015E AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000A236F2C0 00003C (v01 INTEL  NUC5i7RY 0000015E MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000A236F300 000038 (v01 INTEL  NUC5i7RY 0000015E AMI. 0005000B)
[    0.000000] ACPI: SSDT 0x00000000A236F338 000315 (v01 INTEL  NUC5i7RY 0000015E INTL 20120913)
[    0.000000] ACPI: UEFI 0x00000000A236F650 000042 (v01 INTEL  NUC5i7RY 0000015E      00000000)
[    0.000000] ACPI: LPIT 0x00000000A236F698 000094 (v01 INTEL  NUC5i7RY 0000015E      00000000)
[    0.000000] ACPI: SSDT 0x00000000A236F730 000C7D (v02 INTEL  NUC5i7RY 0000015E INTL 20120913)
[    0.000000] ACPI: ASF! 0x00000000A23703B0 0000A0 (v32 INTEL  NUC5i7RY 0000015E TFSM 000F4240)
[    0.000000] ACPI: SSDT 0x00000000A2370450 000539 (v02 INTEL  NUC5i7RY 0000015E INTL 20120913)
[    0.000000] ACPI: SSDT 0x00000000A2370990 000B74 (v02 INTEL  NUC5i7RY 0000015E INTL 20120913)
[    0.000000] ACPI: SSDT 0x00000000A2371508 005AFE (v02 INTEL  NUC5i7RY 0000015E INTL 20120913)
[    0.000000] ACPI: DMAR 0x00000000A2377008 0000D4 (v01 INTEL  NUC5i7RY 0000015E INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000456ffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x456ff8000-0x456ffcfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000000456ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000009cf6bfff]
[    0.000000]   node   0: [mem 0x000000009d432000-0x00000000a2296fff]
[    0.000000]   node   0: [mem 0x00000000a2fff000-0x00000000a2ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000000456ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000456ffffff]
[    0.000000] On node 0 totalpages: 4164973
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10296 pages used for memmap
[    0.000000]   DMA32 zone: 658898 pages, LIFO batch:31
[    0.000000]   Normal zone: 54720 pages used for memmap
[    0.000000]   Normal zone: 3502080 pages, LIFO batch:31
[    0.000000] [ffffed00145ffe00-ffffed00145fffff] potential offnode page_structs
[    0.000000] kasan: KernelAddressSanitizer initialized
[    0.000000] Reserving Intel graphics stolen memory at 0xa4000000-0xa7ffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x0])
[    0.000000] ACPI: NMI not connected to LINT 1!
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x0])
[    0.000000] ACPI: NMI not connected to LINT 1!
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x0])
[    0.000000] ACPI: NMI not connected to LINT 1!
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl edge lint[0x44])
[    0.000000] ACPI: NMI not connected to LINT 1!
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
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
[    0.000000] PM: Registered nosave memory: [mem 0x9cf6c000-0x9d431fff]
[    0.000000] PM: Registered nosave memory: [mem 0xa2297000-0xa2351fff]
[    0.000000] PM: Registered nosave memory: [mem 0xa2352000-0xa2377fff]
[    0.000000] PM: Registered nosave memory: [mem 0xa2378000-0xa2ca7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xa2ca8000-0xa2ffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xa3000000-0xa37fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xa3800000-0xa7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xa8000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xa8000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 42 pages/cpu @ffff8803c6800000 s132168 r8192 d31672 u524288
[    0.000000] pcpu-alloc: s132168 r8192 d31672 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 4099872
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.5.0+ root=/dev/mapper/silver--vg-root ro quiet console=tty0 console=ttyUSB0,115200n8 loglevel=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 14157516K/16659892K available (19257K kernel code, 3849K rwdata, 4552K rodata, 2352K init, 21828K bss, 2502376K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Running RCU self tests
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=4
[    0.000000] NR_IRQS:33024 nr_irqs:728 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3092.752 MHz processor
[    0.000080] Calibrating delay loop (skipped), value calculated using timer frequency.. 6185.50 BogoMIPS (lpj=12371008)
[    0.000203] pid_max: default: 32768 minimum: 301
[    0.000511] ACPI: Core revision 20160108
[    1.403483] ACPI: 6 ACPI AML tables successfully acquired and loaded

[    1.404579] Security Framework initialized
[    1.404639] Yama: becoming mindful.
[    1.404779] AppArmor: AppArmor disabled by boot time parameter
[    1.406490] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    1.410078] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    1.411812] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    1.411972] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    1.417763] CPU: Physical Processor ID: 0
[    1.417822] CPU: Processor Core ID: 0
[    1.417883] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    1.417944] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    1.418010] mce: CPU supports 7 MCE banks
[    1.418151] CPU0: Thermal monitoring enabled (TM1)
[    1.418227] process: using mwait in idle threads
[    1.418289] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    1.418351] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    1.418908] Freeing SMP alternatives memory: 24K (ffffffff83013000 - ffffffff83019000)
[    1.434329] ftrace: allocating 24519 entries in 96 pages
[    1.445180] smpboot: Max logical packages: 1
[    1.445250] DMAR: Host address width 39
[    1.445310] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    1.445563] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 7e1ff0505e
[    1.445644] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    1.445868] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c20660462 ecap f010da
[    1.445946] DMAR: RMRR base: 0x000000a2efa000 end: 0x000000a2f09fff
[    1.446046] DMAR: RMRR base: 0x000000a3800000 end: 0x000000a7ffffff
[    1.446146] DMAR: ANDD device: 2 name: \_SB.PCI0.SDHC
[    1.446208] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    1.446271] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    1.446332] DMAR-IR: x2apic is disabled because BIOS sets x2apic opt out bit.
[    1.446384] DMAR-IR: Use 'intremap=no_x2apic_optout' to override the BIOS setting.
[    1.447090] DMAR-IR: Enabled IRQ remapping in xapic mode
[    1.447154] x2apic: IRQ remapping doesn't support X2APIC mode
[    1.451030] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.490794] TSC deadline timer enabled
[    1.490799] smpboot: CPU0: Intel(R) Core(TM) i7-5557U CPU @ 3.10GHz (family: 0x6, model: 0x3d, stepping: 0x4)
[    1.491068] Performance Events: PEBS fmt2+, 16-deep LBR, Broadwell events, full-width counters, Intel PMU driver.
[    1.491375] ... version:                3
[    1.491434] ... bit width:              48
[    1.491492] ... generic registers:      4
[    1.491550] ... value mask:             0000ffffffffffff
[    1.491610] ... max period:             0000ffffffffffff
[    1.491671] ... fixed-purpose events:   3
[    1.491728] ... event mask:             000000070000000f
[    1.497062] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.499411] x86: Booting SMP configuration:
[    1.499473] .... node  #0, CPUs:      #1 #2 #3
[    1.925831] x86: Booted up 1 node, 4 CPUs
[    1.925946] smpboot: Total of 4 processors activated (24775.52 BogoMIPS)
[    1.935714] devtmpfs: initialized
[    1.939585] x86/mm: Memory block size: 128MB
[    2.093253] PM: Registering ACPI NVS region [mem 0xa2378000-0xa2ca7fff] (9633792 bytes)
[    2.132793] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    2.133866] pinctrl core: initialized pinctrl subsystem
[    2.138350] NET: Registered protocol family 16
[    2.167636] cpuidle: using governor ladder
[    2.178828] cpuidle: using governor menu
[    2.179717] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    2.179816] ACPI: bus type PCI registered
[    2.183138] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    2.183223] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    2.183373] PCI: Using configuration type 1 for base access
[    2.267073] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    2.267139] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.275275] ACPI: Added _OSI(Module Device)
[    2.275338] ACPI: Added _OSI(Processor Device)
[    2.275398] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.275458] ACPI: Added _OSI(Processor Aggregator Device)
[    2.412562] ACPI: Executed 18 blocks of module-level executable AML code
[    3.109306] ACPI: Dynamic OEM Table Load:
[    3.109464] ACPI: SSDT 0xFFFF8803C49C4370 0003D3 (v02 PmRef  Cpu0Cst  00003001 INTL 20120913)
[    3.150133] ACPI: Dynamic OEM Table Load:
[    3.150288] ACPI: SSDT 0xFFFF8803C49DD2B0 0005AA (v02 PmRef  ApIst    00003000 INTL 20120913)
[    3.234144] ACPI: Dynamic OEM Table Load:
[    3.234300] ACPI: SSDT 0xFFFF8803C22E1320 000119 (v02 PmRef  ApCst    00003000 INTL 20120913)
[    3.368021] ACPI: Interpreter enabled
[    3.368594] ACPI: (supports S0 S3 S4 S5)
[    3.368656] ACPI: Using IOAPIC for interrupt routing
[    3.370140] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    3.685296] ACPI: Power Resource [PG00] (on)
[    3.737236] ACPI: Power Resource [PG01] (on)
[    3.802537] ACPI: Power Resource [PG02] (on)
[    4.060694] ACPI: Power Resource [WRST] (off)
[    4.111232] ACPI: Power Resource [WRST] (off)
[    4.149818] ACPI: Power Resource [WRST] (off)
[    4.189239] ACPI: Power Resource [WRST] (off)
[    4.239934] ACPI: Power Resource [WRST] (off)
[    4.278999] ACPI: Power Resource [WRST] (off)
[    4.322759] ACPI: Power Resource [WRST] (off)
[    4.361456] ACPI: Power Resource [WRST] (off)
[    5.391716] ACPI: Power Resource [FN00] (off)
[    5.401797] ACPI: Power Resource [FN01] (off)
[    5.412201] ACPI: Power Resource [FN02] (off)
[    5.422277] ACPI: Power Resource [FN03] (off)
[    5.432358] ACPI: Power Resource [FN04] (off)
[    5.557706] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    5.557878] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.583604] \_SB_.PCI0 (33DB4D5B-1FF7-401C-9657-7441C03DD766): _OSC invalid UUID
[    5.583619] _OSC request data: 1 1f 0
[    5.583638] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    5.661582] PCI host bridge to bus 0000:00
[    5.661680] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    5.661779] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    5.661876] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    5.661987] pci_bus 0000:00: root bus resource [mem 0xa8000000-0xdfffffff window]
[    5.662097] pci_bus 0000:00: root bus resource [mem 0xfe000000-0xfe113fff window]
[    5.662208] pci_bus 0000:00: root bus resource [bus 00-3e]
[    5.662466] pci 0000:00:00.0: [8086:1604] type 00 class 0x060000
[    5.672636] pci 0000:00:02.0: [8086:162b] type 00 class 0x030000
[    5.672653] pci 0000:00:02.0: reg 0x10: [mem 0xa9000000-0xa9ffffff 64bit]
[    5.672663] pci 0000:00:02.0: reg 0x18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    5.672670] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    5.686414] pci 0000:00:03.0: [8086:160c] type 00 class 0x040300
[    5.686430] pci 0000:00:03.0: reg 0x10: [mem 0xaa134000-0xaa137fff 64bit]
[    5.702103] pci 0000:00:14.0: [8086:9cb1] type 00 class 0x0c0330
[    5.702128] pci 0000:00:14.0: reg 0x10: [mem 0xaa120000-0xaa12ffff 64bit]
[    5.702449] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    5.711218] pci 0000:00:14.0: System wakeup disabled by ACPI
[    5.715509] pci 0000:00:16.0: [8086:9cba] type 00 class 0x078000
[    5.715535] pci 0000:00:16.0: reg 0x10: [mem 0xaa13d000-0xaa13d01f 64bit]
[    5.715860] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    5.735371] pci 0000:00:19.0: [8086:15a3] type 00 class 0x020000
[    5.735392] pci 0000:00:19.0: reg 0x10: [mem 0xaa100000-0xaa11ffff]
[    5.735401] pci 0000:00:19.0: reg 0x14: [mem 0xaa13b000-0xaa13bfff]
[    5.735411] pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
[    5.735723] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    5.744335] pci 0000:00:19.0: System wakeup disabled by ACPI
[    5.748639] pci 0000:00:1b.0: [8086:9ca0] type 00 class 0x040300
[    5.748663] pci 0000:00:1b.0: reg 0x10: [mem 0xaa130000-0xaa133fff 64bit]
[    5.748976] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    5.761412] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    5.765723] pci 0000:00:1c.0: [8086:9c90] type 01 class 0x060400
[    5.766102] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    5.789461] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    5.793770] pci 0000:00:1c.3: [8086:9c96] type 01 class 0x060400
[    5.794153] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    5.812109] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    5.816403] pci 0000:00:1d.0: [8086:9ca6] type 00 class 0x0c0320
[    5.816428] pci 0000:00:1d.0: reg 0x10: [mem 0xaa13a000-0xaa13a3ff]
[    5.816777] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    5.825371] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    5.829650] pci 0000:00:1f.0: [8086:9cc3] type 00 class 0x060100
[    5.840625] pci 0000:00:1f.2: [8086:9c83] type 00 class 0x010601
[    5.840643] pci 0000:00:1f.2: reg 0x10: [io  0x30d0-0x30d7]
[    5.841540] pci 0000:00:1f.2: reg 0x14: [io  0x30c0-0x30c3]
[    5.841549] pci 0000:00:1f.2: reg 0x18: [io  0x30b0-0x30b7]
[    5.841557] pci 0000:00:1f.2: reg 0x1c: [io  0x30a0-0x30a3]
[    5.841566] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
[    5.841575] pci 0000:00:1f.2: reg 0x24: [mem 0xaa139000-0xaa1397ff]
[    5.841859] pci 0000:00:1f.2: PME# supported from D3hot
[    5.853300] pci 0000:00:1f.3: [8086:9ca2] type 00 class 0x0c0500
[    5.853319] pci 0000:00:1f.3: reg 0x10: [mem 0xaa138000-0xaa1380ff 64bit]
[    5.853343] pci 0000:00:1f.3: reg 0x20: [io  0x3040-0x305f]
[    5.867047] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    5.870381] pci 0000:02:00.0: [8086:095a] type 00 class 0x028000
[    5.870475] pci 0000:02:00.0: reg 0x10: [mem 0xaa000000-0xaa001fff 64bit]
[    5.871683] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    5.880337] pci 0000:02:00.0: System wakeup disabled by ACPI
[    5.893647] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    5.893721] pci 0000:00:1c.3:   bridge window [mem 0xaa000000-0xaa0fffff]
[    6.003575] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    6.011345] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    6.019008] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    6.026579] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    6.034202] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    6.041723] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    6.049429] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 10 11 12 14 15)
[    6.057064] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    6.099672] ACPI: Enabled 4 GPEs in block 00 to 7F
[    6.103492] vgaarb: setting as boot device: PCI:0000:00:02.0
[    6.103558] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    6.103644] vgaarb: loaded
[    6.103701] vgaarb: bridge control possible 0000:00:02.0
[    6.107738] ACPI: bus type USB registered
[    6.110012] usbcore: registered new interface driver usbfs
[    6.111339] usbcore: registered new interface driver hub
[    6.112270] usbcore: registered new device driver usb
[    6.117131] PCI: Using ACPI for IRQ routing
[    6.119138] PCI: pci_cache_line_size set to 64 bytes
[    6.119557] e820: reserve RAM buffer [mem 0x0009c800-0x0009ffff]
[    6.119618] e820: reserve RAM buffer [mem 0x9cf6c000-0x9fffffff]
[    6.119668] e820: reserve RAM buffer [mem 0xa2297000-0xa3ffffff]
[    6.119702] e820: reserve RAM buffer [mem 0xa3000000-0xa3ffffff]
[    6.119754] e820: reserve RAM buffer [mem 0x457000000-0x457ffffff]
[    6.129020] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    6.129413] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    6.131618] clocksource: Switched to clocksource hpet
[    6.423784] VFS: Disk quotas dquot_6.6.0
[    6.424385] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    6.429218] pnp: PnP ACPI init
[    6.440964] system 00:00: [io  0x0a00-0x0a0f] has been reserved
[    6.441115] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.461206] pnp 00:01: Plug and Play ACPI device, IDs NTN0530 (active)
[    6.466216] system 00:02: [io  0x0680-0x069f] has been reserved
[    6.466347] system 00:02: [io  0xffff] has been reserved
[    6.466473] system 00:02: [io  0xffff] has been reserved
[    6.466600] system 00:02: [io  0xffff] has been reserved
[    6.466749] system 00:02: [io  0x1800-0x18fe] could not be reserved
[    6.466877] system 00:02: [io  0x164e-0x164f] has been reserved
[    6.466946] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.470139] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.473637] system 00:04: [io  0x1854-0x1857] has been reserved
[    6.473707] system 00:04: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    6.493530] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    6.493661] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    6.493790] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    6.493919] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    6.494047] system 00:05: [mem 0xf8000000-0xfbffffff] has been reserved
[    6.494175] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    6.494324] system 00:05: [mem 0xfed90000-0xfed93fff] could not be reserved
[    6.494453] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    6.494584] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    6.494734] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    6.494863] system 00:05: [mem 0xa8010000-0xa801ffff] has been reserved
[    6.494994] system 00:05: [mem 0xa8000000-0xa800ffff] has been reserved
[    6.495065] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.544788] system 00:06: [mem 0xfe104000-0xfe104fff] has been reserved
[    6.544921] system 00:06: [mem 0xfe106000-0xfe106fff] has been reserved
[    6.545049] system 00:06: [mem 0xfe112000-0xfe112fff] has been reserved
[    6.545178] system 00:06: [mem 0xfe111000-0xfe111007] has been reserved
[    6.545306] system 00:06: [mem 0xfe111014-0xfe111fff] has been reserved
[    6.545378] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.586787] pnp: PnP ACPI: found 7 devices
[    6.706788] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    6.706936] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    6.707017] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    6.707088] pci 0000:00:1c.3:   bridge window [mem 0xaa000000-0xaa0fffff]
[    6.707167] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    6.707169] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    6.707171] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    6.707173] pci_bus 0000:00: resource 7 [mem 0xa8000000-0xdfffffff window]
[    6.707176] pci_bus 0000:00: resource 8 [mem 0xfe000000-0xfe113fff window]
[    6.707178] pci_bus 0000:02: resource 1 [mem 0xaa000000-0xaa0fffff]
[    6.708495] NET: Registered protocol family 2
[    6.712558] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    6.713436] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    6.718105] TCP: Hash tables configured (established 131072 bind 65536)
[    6.718832] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
[    6.720126] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes)
[    6.723065] NET: Registered protocol family 1
[    6.723316] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    6.776113] PCI: CLS 0 bytes, default 64
[    6.777485] Unpacking initramfs...
[    7.303890] Freeing initrd memory: 20660K (ffff880035796000 - ffff880036bc3000)
[    7.305171] DMAR: ACPI device "INT3436:00" under DMAR at fed91000 as 00:17.0
[    7.305314] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    7.305381] software IO TLB [mem 0x9e297000-0xa2297000] (64MB) mapped at [ffff88009e297000-ffff8800a2296fff]
[    7.306208] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360 ms ovfl timer
[    7.306289] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    7.306350] RAPL PMU: hw unit of domain package 2^-14 Joules
[    7.306412] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    7.306472] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    7.326916] futex hash table entries: 1024 (order: 5, 131072 bytes)
[    7.327428] audit: initializing netlink subsys (disabled)
[    7.327898] audit: type=2000 audit(1459183020.300:1): initialized
[    7.352196] workingset: timestamp_bits=38 max_order=22 bucket_order=0
[    7.541075] kasan: WARNING: KASAN doesn't support memory hot-add
[    7.541143] kasan: Memory hot-add will be disabled
[    7.572526] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    7.573338] io scheduler noop registered
[    7.573451] io scheduler deadline registered
[    7.581467] io scheduler cfq registered (default)
[    7.604447] intel_idle: MWAIT substates: 0x11142120
[    7.604450] intel_idle: v0.4 model 0x3D
[    7.604452] intel_idle: lapic_timer_reliable_states 0xffffffff
[    7.653487] GHES: HEST is not enabled!
[    7.657389] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.700275] Linux agpgart interface v0.103
[    7.703930] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    7.703999] AMD IOMMUv2 functionality not available on this system
[    7.754939] usbcore: registered new interface driver usbserial
[    7.755557] usbcore: registered new interface driver usbserial_generic
[    7.756410] usbserial: USB Serial support registered for generic
[    7.757066] usbcore: registered new interface driver pl2303
[    7.757689] usbserial: USB Serial support registered for pl2303
[    7.759393] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    7.765986] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.766247] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.771208] mousedev: PS/2 mouse device common for all mice
[    7.772436] rtc_cmos 00:03: RTC can wake from S4
[    7.776505] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    7.776776] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    7.777188] Intel P-state driver initializing.
[    7.782873] ledtrig-cpu: registered to indicate activity on CPUs
[    7.827586] NET: Registered protocol family 10
[    7.840408] mip6: Mobile IPv6
[    7.840512] NET: Registered protocol family 17
[    7.840672] mpls_gso: MPLS GSO support
[    7.853468] microcode: CPU0 sig=0x306d4, pf=0x40, revision=0x22
[    7.853691] microcode: CPU1 sig=0x306d4, pf=0x40, revision=0x22
[    7.853934] microcode: CPU2 sig=0x306d4, pf=0x40, revision=0x22
[    7.854149] microcode: CPU3 sig=0x306d4, pf=0x40, revision=0x22
[    7.855758] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.862250] registered taskstats version 1
[    7.871566] zswap: default zpool zbud not available
[    7.871631] zswap: pool creation failed
[    7.873955] kmemleak: Kernel memory leak detector initialized
[    7.873962] kmemleak: Automatic memory scanning thread started
[    7.910246] rtc_cmos 00:03: setting system clock to 2016-03-28 16:37:01 UTC (1459183021)
[    7.915617] PM: Hibernation image not present or could not be loaded.
[    7.917200] Freeing unused kernel memory: 2352K (ffffffff82dc7000 - ffffffff83013000)
[    7.917281] Write protecting the kernel read-only data: 26624k
[    7.918164] Freeing unused kernel memory: 1116K (ffff8800022e9000 - ffff880002400000)
[    7.922291] Freeing unused kernel memory: 1592K (ffff880002872000 - ffff880002a00000)
[    8.031860] random: systemd-udevd urandom read with 10 bits of entropy available
[    8.307806] tsc: Refined TSC clocksource calibration: 3092.840 MHz
[    8.307876] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2c94dc1ce7d, max_idle_ns: 440795323863 ns
[    8.717211] hidraw: raw HID events driver (C) Jiri Kosina
[    8.825323] sdhci: Secure Digital Host Controller Interface driver
[    8.825398] sdhci: Copyright(c) Pierre Ossman
[    9.009103] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.010534] pps_core: LinuxPPS API ver. 1 registered
[    9.010602] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    9.041019] ehci-pci: EHCI PCI platform driver
[    9.055813] PTP clock support registered
[    9.076648] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    9.076723] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    9.087297] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    9.088928] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    9.089434] ehci-pci 0000:00:1d.0: debug port 2
[    9.094485] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    9.096558] ehci-pci 0000:00:1d.0: irq 23, io mem 0xaa13a000
[    9.108242] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    9.122469] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    9.122544] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.122631] usb usb1: Product: EHCI Host Controller
[    9.122699] usb usb1: Manufacturer: Linux 4.5.0+ ehci_hcd
[    9.122768] usb usb1: SerialNumber: 0000:00:1d.0
[    9.149692] SCSI subsystem initialized
[    9.165536] hub 1-0:1.0: USB hub found
[    9.166839] hub 1-0:1.0: 2 ports detected
[    9.193722] libata version 3.00 loaded.
[    9.309620] clocksource: Switched to clocksource tsc
[    9.320765] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    9.323826] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    9.332642] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    9.332744] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    9.350565] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    9.350645] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.350732] usb usb2: Product: xHCI Host Controller
[    9.350800] usb usb2: Manufacturer: Linux 4.5.0+ xhci-hcd
[    9.350869] usb usb2: SerialNumber: 0000:00:14.0
[    9.449742] thermal LNXTHERM:00: registered as thermal_zone0
[    9.449820] ACPI: Thermal Zone [TZ00] (28 C)
[    9.490967] hub 2-0:1.0: USB hub found
[    9.494409] hub 2-0:1.0: 11 ports detected
[    9.552222] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    9.615298] thermal LNXTHERM:01: registered as thermal_zone1
[    9.615367] ACPI: Thermal Zone [TZ01] (30 C)
[   10.413327] usb 1-1: New USB device found, idVendor=8087, idProduct=8001
[   10.413395] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   10.423297] hub 1-1:1.0: USB hub found
[   10.423780] hub 1-1:1.0: 8 ports detected
[   10.510208] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   10.510469] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[   10.513645] usb usb3: New USB device found, idVendor=1d6b, idProduct=0003
[   10.513712] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.513789] usb usb3: Product: xHCI Host Controller
[   10.513848] usb usb3: Manufacturer: Linux 4.5.0+ xhci-hcd
[   10.513908] usb usb3: SerialNumber: 0000:00:14.0
[   10.535754] hub 3-0:1.0: USB hub found
[   10.536381] hub 3-0:1.0: 4 ports detected
[   10.783778] usb 2-3: new high-speed USB device number 2 using xhci_hcd
[   10.891808] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   10.970473] usb 2-3: New USB device found, idVendor=05e3, idProduct=0608
[   10.970543] usb 2-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   10.970610] usb 2-3: Product: USB2.0 Hub
[   10.980788] hub 2-3:1.0: USB hub found
[   10.981558] hub 2-3:1.0: 4 ports detected
[   11.083102] e1000e 0000:00:19.0 eth0: registered PHC clock
[   11.083170] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) b8:ae:ed:76:45:4a
[   11.083250] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[   11.083337] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[   11.083903] ahci 0000:00:1f.2: version 3.0
[   11.092780] e1000e 0000:00:19.0 enp0s25: renamed from eth0
[   11.113038] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x8 impl SATA mode
[   11.113124] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
[   11.163812] usb 2-7: new full-speed USB device number 3 using xhci_hcd
[   11.239669] scsi host0: ahci
[   11.266578] scsi host1: ahci
[   11.281561] scsi host2: ahci
[   11.296328] usb 2-7: New USB device found, idVendor=8087, idProduct=0a2a
[   11.296397] usb 2-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   11.298672] scsi host3: ahci
[   11.311511] ata1: DUMMY
[   11.311570] ata2: DUMMY
[   11.311625] ata3: DUMMY
[   11.311682] ata4: SATA max UDMA/133 abar m2048@0xaa139000 port 0xaa139280 irq 44
[   11.363832] usb 2-3.1: new high-speed USB device number 4 using xhci_hcd
[   11.454423] usb 2-3.1: New USB device found, idVendor=05e3, idProduct=0608
[   11.454493] usb 2-3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   11.454573] usb 2-3.1: Product: USB2.0 Hub
[   11.463053] hub 2-3.1:1.0: USB hub found
[   11.463794] hub 2-3.1:1.0: 4 ports detected
[   11.551819] usb 2-3.3: new full-speed USB device number 5 using xhci_hcd
[   11.622888] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   11.635938] ata4.00: ATA-9: BIWIN SSD, N1126F, max UDMA/133
[   11.636004] ata4.00: 500118192 sectors, multi 2: LBA48 NCQ (depth 31/32), AA
[   11.645247] usb 2-3.3: New USB device found, idVendor=046d, idProduct=c52b
[   11.645316] usb 2-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.645395] usb 2-3.3: Product: USB Receiver
[   11.645454] usb 2-3.3: Manufacturer: Logitech
[   11.651558] ata4.00: configured for UDMA/133
[   11.663590] scsi 3:0:0:0: Direct-Access     ATA      BIWIN SSD        6F   PQ: 0 ANSI: 5
[   11.739830] usb 2-3.4: new high-speed USB device number 6 using xhci_hcd
[   11.766497] sd 3:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[   11.769125] sd 3:0:0:0: [sda] Write Protect is off
[   11.769190] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   11.769792] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.783648]  sda: sda1 sda2 < sda5 >
[   11.803107] sd 3:0:0:0: [sda] Attached SCSI disk
[   11.829628] usb 2-3.4: New USB device found, idVendor=0409, idProduct=005a
[   11.829700] usb 2-3.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   11.853104] hub 2-3.4:1.0: USB hub found
[   11.854264] hub 2-3.4:1.0: 3 ports detected
[   11.904074] usb 2-3.1.1: new full-speed USB device number 7 using xhci_hcd
[   11.918090] usbcore: registered new interface driver usbhid
[   11.918163] usbhid: USB HID core driver
[   11.950747] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.3/2-3.3:1.0/0003:046D:C52B.0001/input/input3
[   11.994246] usb 2-3.1.1: New USB device found, idVendor=067b, idProduct=2303
[   11.994319] usb 2-3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.994398] usb 2-3.1.1: Product: USB-Serial Controller
[   11.994459] usb 2-3.1.1: Manufacturer: Prolific Technology Inc.
[   12.010314] pl2303 2-3.1.1:1.0: pl2303 converter detected
[   12.026648] usb 2-3.1.1: pl2303 converter now attached to ttyUSB0
[   12.032086] console [ttyUSB0] enabled
[   12.043347] hid-generic 0003:046D:C52B.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:14.0-3.3/input0
[   12.052735] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.3/2-3.3:1.1/0003:046D:C52B.0002/input/input4
[   12.111833] usb 2-3.1.2: new high-speed USB device number 8 using xhci_hcd
[   12.121270] hid-generic 0003:046D:C52B.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:14.0-3.3/input1
[   12.134055] hid-generic 0003:046D:C52B.0003: hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-3.3/input2
[   12.224309] usb 2-3.1.2: New USB device found, idVendor=2040, idProduct=7200
[   12.224383] usb 2-3.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=10
[   12.224464] usb 2-3.1.2: Product: WinTV HVR-950
[   12.224525] usb 2-3.1.2: Manufacturer: Hauppauge
[   12.224586] usb 2-3.1.2: SerialNumber: 4035199481
[   12.296997] usb 2-3.4.2: new high-speed USB device number 9 using xhci_hcd
[   12.478030] device-mapper: uevent: version 1.0.3
[   12.490103] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
[   12.501774] usb 2-3.4.2: New USB device found, idVendor=0ac8, idProduct=3330
[   12.501856] usb 2-3.4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   12.501944] usb 2-3.4.2: Product: Sirius USB2.0 Camera
[   12.502832] usb 2-3.4.2: Manufacturer: Vimicro Corp.
[   12.639859] usb 2-3.4.3: new full-speed USB device number 10 using xhci_hcd
[   12.748120] usb 2-3.4.3: New USB device found, idVendor=0d8c, idProduct=0126
[   12.748532] usb 2-3.4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   12.748941] usb 2-3.4.3: Product: USB Audio Device
[   12.749431] usb 2-3.4.3: Manufacturer: C-Media Electronics Inc.
[   12.806709] input: C-Media Electronics Inc. USB Audio Device as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.4/2-3.4.3/2-3.4.3:1.2/0003:0D8C:0126.0004/input/input5
[   12.865872] hid-generic 0003:0D8C:0126.0004: input,hidraw3: USB HID v1.00 Device [C-Media Electronics Inc. USB Audio Device] on usb-0000:00:14.0-3.4.3/input2
[   12.909289] PM: Starting manual resume from disk
[   12.909585] PM: Hibernation image partition 254:1 present
[   12.909587] PM: Looking for hibernation image.
[   12.910262] PM: Image not found (code -22)
[   12.910266] PM: Hibernation image not present or could not be loaded.
[   13.353678] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   17.549090] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input6
[   17.549485] ACPI: Sleep Button [SLPB]
[   17.576203] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input7
[   17.576803] ACPI: Power Button [PWRB]
[   17.601056] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input8
[   17.601825] ACPI: Power Button [PWRF]
[   18.623802] [drm] Initialized drm 1.1.0 20060810
[   19.225604] sd 3:0:0:0: Attached scsi generic sg0 type 0
[   19.274723] random: nonblocking pool is initialized
[   19.320429] input: PC Speaker as /devices/platform/pcspkr/input/input9
[   19.367691] Bluetooth: Core ver 2.21
[   19.378840] NET: Registered protocol family 31
[   19.379276] Bluetooth: HCI device and connection manager initialized
[   19.380075] Bluetooth: HCI socket layer initialized
[   19.394111] Bluetooth: L2CAP socket layer initialized
[   19.395465] Bluetooth: SCO socket layer initialized
[   19.434995] ACPI Warning: SystemIO range 0x0000000000003040-0x000000000000305F conflicts with OpRegion 0x0000000000003040-0x000000000000304F (\_SB.PCI0.SBUS.SMBI) (20160108/utaddress-255)
[   19.437138] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.770388] media: Linux media interface: v0.10
[   19.999827] usbcore: registered new interface driver btusb
[   20.031766] Bluetooth: hci0: read Intel version: 370810011003110e20
[   20.032196] Bluetooth: hci0: Intel device is already patched. patch num: 20
[   20.038919] Linux video capture interface: v2.00
[   20.231335] snd_hda_codec_realtek hdaudioC1D0: autoconfig for ALC283: line_outs=1 (0x21/0x0/0x0/0x0/0x0) type:hp
[   20.231977] snd_hda_codec_realtek hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   20.232073] snd_hda_codec_realtek hdaudioC1D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   20.232161] snd_hda_codec_realtek hdaudioC1D0:    mono: mono_out=0x0
[   20.232231] snd_hda_codec_realtek hdaudioC1D0:    inputs:
[   20.232303] snd_hda_codec_realtek hdaudioC1D0:      Mic=0x19
[   20.346456] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[   20.398466] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[   20.412891] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[   20.493296] uvcvideo: Found UVC 1.00 device Sirius USB2.0 Camera (0ac8:3330)
[   20.542275] uvcvideo 2-3.4.2:1.0: Entity type for entity Processing 2 was not initialized!
[   20.549769] uvcvideo 2-3.4.2:1.0: Entity type for entity Camera 1 was not initialized!
[   20.550606] uvcvideo 2-3.4.2:1.0: Entity type for entity Extension 4 was not initialized!
[   20.607246] AVX2 version of gcm_enc/dec engaged.
[   20.607804] AES CTR mode by8 optimization enabled
[   20.614859] input: Sirius USB2.0 Camera as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.4/2-3.4.2/2-3.4.2:1.0/input/input14
[   20.647681] usbcore: registered new interface driver uvcvideo
[   20.648265] USB Video Class driver (1.1.1)
[   20.758073] [drm] Memory usable by graphics device = 4096M
[   20.759435] [drm] Replacing VGA console driver
[   20.789236] Console: switching to colour dummy device 80x25
[   21.024398] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   21.025010] [drm] Driver supports precise vblank timestamp query.
[   21.031475] IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
[   21.220170] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   21.567592] iTCO_vendor_support: vendor-support=0
[   21.602836] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   21.605645] iTCO_wdt: Found a Wildcat Point_LP TCO device (Version=2, TCOBASE=0x1860)
[   21.673313] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   21.731078] fbcon: inteldrmfb (fb0) is primary device
[   22.133660] Console: switching to colour frame buffer device 240x67
[   22.159785] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   22.603140] intel_rapl: Found RAPL domain package
[   22.603743] intel_rapl: Found RAPL domain core
[   22.604329] intel_rapl: Found RAPL domain uncore
[   22.604897] intel_rapl: Found RAPL domain dram
[   23.153221] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   23.176815] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input15
[   23.195116] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   23.195484] [drm] Initialized i915 1.6.0 20151218 for 0000:00:02.0 on minor 0
[   23.353872] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input16
[   23.365393] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input17
[   23.372530] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input18
[   23.506448] e1000e: enp0s25 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   23.506995] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s25: link becomes ready
[   25.793775] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[   26.970761] Adding 31731708k swap on /dev/mapper/silver--vg-swap_1.  Priority:-1 extents:1 across:31731708k SSFS
[   27.730309] lp: driver loaded but no devices found
[   27.830563] ppdev: user-space parallel port driver
[   28.226073] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[   28.261515] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[   28.317880] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[   28.350198] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[   28.386613] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   28.440270] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
[   30.052978] e1000e 0000:00:19.0 enp0s25: changing MTU from 1500 to 1460
[   33.734401] e1000e: enp0s25 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   43.112070] systemd-logind[2583]: New seat seat0.
[   43.145137] systemd-logind[2583]: Watching system buttons on /dev/input/event5 (Power Button)
[   43.146749] systemd-logind[2583]: Watching system buttons on /dev/input/event11 (Video Bus)
[   43.148252] systemd-logind[2583]: Watching system buttons on /dev/input/event4 (Power Button)
[   43.151667] systemd-logind[2583]: Watching system buttons on /dev/input/event3 (Sleep Button)
[   45.570118] systemd-logind[2583]: Failed to start user service, ignoring: Unknown unit: user@116.service
[   45.767764] systemd-logind[2583]: New session c1 of user lightdm.
[   48.621637] systemd-logind[2583]: Failed to start user service, ignoring: Unknown unit: user@1000.service
[   48.805825] systemd-logind[2583]: New session 2 of user mchehab.
[   48.939639] systemd-logind[2583]: New session 1 of user mchehab.
[   49.062243] systemd-logind[2583]: New session 3 of user mchehab.
[   49.173207] systemd-logind[2583]: New session 4 of user mchehab.
[   49.280896] systemd-logind[2583]: New session 5 of user mchehab.
[   49.385536] systemd-logind[2583]: New session 6 of user mchehab.
[   49.488729] systemd-logind[2583]: New session 7 of user mchehab.
[   49.605143] systemd-logind[2583]: New session 8 of user mchehab.

Tests with uvcvideo start here. No Logs

[ 2810.631533] perf interrupt took too long (2507 > 2500), lowering kernel.perf_event_max_sample_rate to 50000

Here, I removed the UVC camera and plugged/modprobed au0828 and
snd-usb-audio.

[ 4181.746551] usb 2-3.4: USB disconnect, device number 6
[ 4181.746995] usb 2-3.4.2: USB disconnect, device number 9
[ 4181.856699] usb 2-3.4.3: USB disconnect, device number 10
[ 4194.955545] usbcore: registered new interface driver snd-usb-audio
[ 4196.597456] au0828: au0828 driver loaded
[ 4197.002537] au0828: i2c bus registered
[ 4199.336991] tveeprom 5-0050: Hauppauge model 72001, rev E1H3, serial# 4035199481
[ 4199.338475] tveeprom 5-0050: MAC address is 00:0d:fe:84:41:f9
[ 4199.339570] tveeprom 5-0050: tuner model is Xceive XC5000C (idx 173, type 88)
[ 4199.341470] tveeprom 5-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
[ 4199.343494] tveeprom 5-0050: audio processor is AU8522 (idx 44)
[ 4199.344972] tveeprom 5-0050: decoder processor is AU8522 (idx 42)
[ 4199.344977] tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
[ 4199.344981] au0828: hauppauge_eeprom: hauppauge eeprom: model=72001
[ 4199.465565] au8522 5-0047: creating new instance
[ 4199.466299] au8522_decoder creating new instance...
[ 4199.591514] tuner 5-0061: Setting mode_mask to 0x06
[ 4199.591521] tuner 5-0061: tuner 0x61: Tuner type absent
[ 4199.591526] tuner 5-0061: Tuner -1 found with type(s) Radio TV.
[ 4199.592413] tuner 5-0061: Calling set_type_addr for type=88, addr=0x61, mode=0x04, config=ffffffffa124c100
[ 4199.592418] tuner 5-0061: defining GPIO callback
[ 4199.671018] xc5000 5-0061: creating new instance
[ 4199.727330] xc5000: Successfully identified at address 0x61
[ 4199.727900] xc5000: Firmware has not been loaded previously
[ 4199.729060] tuner 5-0061: type set to Xceive XC5000
[ 4199.729065] tuner 5-0061: au0828 tuner I2C addr 0xc2 with type 88 used for 0x04
[ 4204.346972] au8522 5-0047: attaching existing instance
[ 4204.393226] xc5000 5-0061: attaching existing instance
[ 4204.417679] xc5000: Successfully identified at address 0x61
[ 4204.418172] xc5000: Firmware has not been loaded previously
[ 4204.418894] DVB: registering new adapter (au0828)
[ 4204.419787] usb 2-3.1.2: DVB: registering adapter 0 frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
[ 4204.422812] dvb_create_media_entity: media entity 'Auvitek AU8522 QAM/8VSB Frontend' registered.
[ 4204.553450] dvb_create_media_entity: media entity 'dvb-demux' registered.
[ 4207.052441] IR keymap rc-hauppauge not found
[ 4207.053179] Registered IR keymap rc-empty
[ 4207.111712] input: au0828 IR (Hauppauge HVR950Q) as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.1/2-3.1.2/rc/rc0/input19
[ 4207.131353] ir-keytable[26869]: segfault at 0 ip 0000000000402270 sp 00007fff7210c980 error 4 in ir-keytable[400000+8000]
[ 4207.243072] rc rc0: au0828 IR (Hauppauge HVR950Q) as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.1/2-3.1.2/rc/rc0
[ 4207.256532] au0828: Remote controller au0828 IR (Hauppauge HVR950Q) initalized
[ 4207.257693] au0828: Registered device AU0828 [Hauppauge HVR950Q]
[ 4207.270852] usbcore: registered new interface driver au0828
[ 4207.295191] lirc_dev: IR Remote Control driver registered, major 243 
[ 4207.308157] tuner 5-0061: Putting tuner to sleep
[ 4207.336184] rc rc0: lirc_dev: driver ir-lirc-codec (au0828-input) registered at minor = 0
[ 4207.336624] IR LIRC bridge handler initialized

And here, I started the tests with au0828+snd-usb-audio drivers.
Again, no logs.




