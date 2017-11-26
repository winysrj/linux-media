Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:45865 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750873AbdKZGOK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 01:14:10 -0500
Date: Sun, 26 Nov 2017 14:14:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, lkp@01.org
Subject: [zoltrix@isa_bus_shutdown] BUG: unable to handle kernel NULL pointer
 dereference at 0000000c
Message-ID: <20171126061405.nua5hv75fcm2sdc4@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ntbecuc2mtdmjztx"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ntbecuc2mtdmjztx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

FYI this happens in mainline kernel 4.14.0-13292-g1d3b78b.
It at least dates back to 4.13.

It occurs in 1 out of 2 boots.

[   12.920044] rcu-perf:    1 writer-duration:   101 690739
[   12.920566] rcu-perf:    1 writer-duration:   102 556061
[   13.600625] radio-aimslab.0: Initialized radio card AIMSlab RadioTrack/RadioReveal on port 0x30f
[   13.601664] : Removed radio card AIMSlab RadioTrack/RadioReveal
[   16.640639] radio-aimslab.0: Initialized radio card AIMSlab RadioTrack/RadioReveal on port 0x30f
[   16.641593] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[   16.642301] IP: isa_bus_shutdown+0x6/0x20:
						isa_bus_shutdown at drivers/base/isa.c:62
[   16.642666] *pde = 00000000
[   16.642964] Oops: 0000 [#1] PREEMPT SMP
[   16.643337] CPU: 1 PID: 43 Comm: rcu_perf_shutdo Tainted: G S               4.14.0-13292-g1d3b78b #1
[   16.644234] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   16.645047] task: 4017a000 task.stack: 4032a000
[   16.645448] EIP: isa_bus_shutdown+0x6/0x20:
						isa_bus_shutdown at drivers/base/isa.c:62
[   16.645819] EFLAGS: 00210246 CPU: 1
[   16.646131] EAX: 4e7bfa00 EBX: 4e7bfa0c ECX: 4017a5e8 EDX: 00000000
[   16.646746] ESI: 43063440 EDI: 4e7bfa00 EBP: 4032bf68 ESP: 4032bf54
[   16.647363]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   16.647845] CR0: 80050033 CR2: 0000000c CR3: 03238000 CR4: 00000690
[   16.648468] Call Trace:
[   16.648715]  ? device_shutdown+0xd3/0x1a0:
						device_unlock at include/linux/device.h:1104
						 (inlined by) device_shutdown at drivers/base/core.c:2814
[   16.649092]  ? kernel_power_off+0x2d/0x60:
						kernel_power_off at kernel/reboot.c:287
[   16.649489]  ? rcu_perf_shutdown+0xa0/0xb0:
						rcu_perf_shutdown at kernel/rcu/rcuperf.c:637
[   16.649885]  ? print_dl_stats+0x20/0x20:
						autoremove_wake_function at kernel/sched/wait.c:376
[   16.650024]  ? kthread+0x101/0x130:
						kthread at kernel/kthread.c:238
[   16.650024]  ? rcu_perf_cleanup+0x320/0x320:
						rcu_perf_shutdown at kernel/rcu/rcuperf.c:627
[   16.650024]  ? kthread_delayed_work_timer_fn+0xa0/0xa0:
						kthread at kernel/kthread.c:198
[   16.650024]  ? ret_from_fork+0x19/0x30:
						ret_from_fork at arch/x86/entry/entry_32.S:299
[   16.650024] Code: 74 13 55 89 e5 8b 90 80 01 00 00 ff d1 5d c3 8d b6 00 00 00 00 31 c0 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 8b 90 88 00 00 00 <8b> 4a 0c 85 c9 74 0c 55 89 e5 8b 90 80 01 00 00 ff d1 5d c3 8d
[   16.650024] EIP: isa_bus_shutdown+0x6/0x20:
						isa_bus_shutdown at drivers/base/isa.c:62 SS:ESP: 0068:4032bf54
[   16.650024] CR2: 000000000000000c
[   16.650024] ---[ end trace 07ea2d1affc54db9 ]---
[   16.650024] Kernel panic - not syncing: Fatal exception

Attached the full dmesg, kconfig and reproduce scripts.

Thanks,
Fengguang

--ntbecuc2mtdmjztx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-vm-ivb41-yocto-i386-1:20171125115550:i386-randconfig-sb0-11100832:4.14.0-13292-g1d3b78b:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 4.14.0-13292-g1d3b78b (kbuild@lkp-wsx02) (gcc =
version 5.4.1 20171010 (Debian 5.5.0-3)) #1 SMP PREEMPT Sat Nov 25 11:29:48=
 CST 2017
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fddfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fde000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 0=
4/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fde max_arch_pfn =3D 0x100000
[    0.000000] x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC=
 =20
[    0.000000] initial memory mapped: [mem 0x00000000-0x047fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] BRK [0x03f68000, 0x03f68fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13c54000-0x13fcffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F6870 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE1628 000030 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE147C 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 00143C (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: APIC 0x0000000013FE1570 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE15F0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fde000
[    0.000000]   low ram: 0 - 13fde000
[    0.000000] kvm-clock: cpu 0, msr 0:13fdc001, primary cpu clock
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: using sched offset of 1467338557 cycles
[    0.000000] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles:=
 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] BRK [0x03f69000, 0x03f69fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000001000-0x0000000013fddfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x0000000013fddfff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000013fdd=
fff]
[    0.000000] On node 0 totalpages: 81788
[    0.000000]   Normal zone: 800 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81788 pages, LIFO batch:15
[    0.000000] Reserved but unavailable: 98 pages
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 19112604462750000 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] percpu: Embedded 19 pages/cpu @5390e000 s54236 r0 d23588 u77=
824
[    0.000000] pcpu-alloc: s54236 r0 d23588 u77824 alloc=3D19*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13910b00
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 80988
[    0.000000] Kernel command line: ip=3D::::vm-ivb41-yocto-i386-1::dhcp ro=
ot=3D/dev/ram0 user=3Dlkp job=3D/lkp/scheduled/vm-ivb41-yocto-i386-1/trinit=
y-300s-yocto-tiny-i386-2016-04-22.cgz-1d3b78bbc6e983fabb3fbf91b76339bf66e4a=
12c-20171125-65036-1j2iqyn-1.yaml ARCH=3Di386 kconfig=3Di386-randconfig-sb0=
-11100832 branch=3Dlinus/master commit=3D1d3b78bbc6e983fabb3fbf91b76339bf66=
e4a12c BOOT_IMAGE=3D/pkg/linux/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc=
6e983fabb3fbf91b76339bf66e4a12c/vmlinuz-4.14.0-13292-g1d3b78b max_uptime=3D=
1500 RESULT_ROOT=3D/result/trinity/300s/vm-ivb41-yocto-i386/yocto-tiny-i386=
-2016-04-22.cgz/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91=
b76339bf66e4a12c/1 LKP_SERVER=3Dinn debug apic=3Ddebug sysrq_always_enabled=
 rcupdate.rcu_cpu_stall_timeout=3D100 net.ifnames=3D0 printk.devkmsg=3Don p=
anic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 drbd.minor_count=3D8 systemd.log_level=3Derr igno=
re_loglevel console=3Dtty0 earlyprintk=3DttyS0,115200 console=3DttyS0,11520=
0 vga=3Dno
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 271188K/327152K available (24616K kernel code, 1264K=
 rwdata, 7908K rodata, 928K init, 13440K bss, 55964K reserved, 0K cma-reser=
ved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff0e000 - 0xfffff000   ( 964 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x547de000 - 0xff7fe000   (2736 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x53fde000   ( 319 MB)
[    0.000000]       .init : 0x4313b000 - 0x43223000   ( 928 kB)
[    0.000000]       .data : 0x4280a2da - 0x4310a0d0   (9215 kB)
[    0.000000]       .text : 0x41000000 - 0x4280a2da   (24616 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.008884] Running RCU self tests
[    0.008888] Preemptible hierarchical RCU implementation.
[    0.008890] 	RCU lockdep checking is enabled.
[    0.008891] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D2.
[    0.008893] 	RCU priority boosting: priority 1 delay 500 ms.
[    0.008895] 	RCU callback double-/use-after-free debug enabled.
[    0.008898] 	RCU CPU stall warnings timeout set to 100 (rcu_cpu_stall_ti=
meout).
[    0.008899] 	Tasks RCU enabled.
[    0.008901] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.008927] NR_IRQS: 2304, nr_irqs: 440, preallocated irqs: 16
[    0.009116] CPU 0 irqstacks, hard=3D40012000 soft=3D40014000
[    0.009119] 	Offload RCU callbacks from CPUs: .
[    0.010000] console [ttyS0] enabled
[    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.010000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.010000] ... MAX_LOCK_DEPTH:          48
[    0.010000] ... MAX_LOCKDEP_KEYS:        8191
[    0.010000] ... CLASSHASH_SIZE:          4096
[    0.010000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.010000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.010000] ... CHAINHASH_SIZE:          32768
[    0.010000]  memory used by lock dependency info: 4399 kB
[    0.010000]  per task-struct memory footprint: 1536 bytes
[    0.010000] ACPI: Core revision 20170831
[    0.010000] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.010000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 19112604467 ns
[    0.010000] hpet clockevent registered
[    0.010022] APIC: Switch to symmetric I/O mode setup
[    0.010515] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.011056] enabled ExtINT on CPU#0
[    0.012015] ENABLING IO-APIC IRQs
[    0.012350] init IO_APIC IRQs
[    0.012638]  apic 0 pin 0 not connected
[    0.013031] IOAPIC[0]: Set routing entry (0-1 -> 0xef -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.013792] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.014548] IOAPIC[0]: Set routing entry (0-3 -> 0xef -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.015301] IOAPIC[0]: Set routing entry (0-4 -> 0xef -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.016050] IOAPIC[0]: Set routing entry (0-5 -> 0xef -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.016796] IOAPIC[0]: Set routing entry (0-6 -> 0xef -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.017544] IOAPIC[0]: Set routing entry (0-7 -> 0xef -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.018295] IOAPIC[0]: Set routing entry (0-8 -> 0xef -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.019039] IOAPIC[0]: Set routing entry (0-9 -> 0xef -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.019817] IOAPIC[0]: Set routing entry (0-10 -> 0xef -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-11 -> 0xef -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-12 -> 0xef -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-13 -> 0xef -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-14 -> 0xef -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-15 -> 0xef -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.020000]  apic 0 pin 16 not connected
[    0.020000]  apic 0 pin 17 not connected
[    0.020000]  apic 0 pin 18 not connected
[    0.020000]  apic 0 pin 19 not connected
[    0.020000]  apic 0 pin 20 not connected
[    0.020000]  apic 0 pin 21 not connected
[    0.020000]  apic 0 pin 22 not connected
[    0.020000]  apic 0 pin 23 not connected
[    0.020000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.020000] tsc: Detected 2693.508 MHz processor
[    0.020000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
[    0.020005] pid_max: default: 32768 minimum: 301
[    0.020658] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.021400] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.022661] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023268] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.024403] Freeing SMP alternatives memory: 72K
[    0.026135] smpboot: Max logical packages: 2
[    0.026636] Using local APIC timer interrupts.
[    0.026636] calibrating APIC timer ...
[    0.030000] ... lapic delta =3D 6250221
[    0.030000] ... PM-Timer delta =3D 357960
[    0.030000] ... PM-Timer result ok
[    0.030000] ..... delta 6250221
[    0.030000] ..... mult: 268444947
[    0.030000] ..... calibration result: 10000353
[    0.030000] ..... CPU clock speed is 2693.5520 MHz.
[    0.030000] ..... host bus clock speed is 1000.0353 MHz.
[    0.030000] smpboot: CPU0: GenuineIntel QEMU Virtual CPU version 2.5+ (f=
amily: 0x6, model: 0x6, stepping: 0x3)
[    0.060033] Performance Events: no PMU driver, software events only.
[    0.080030] Hierarchical SRCU implementation.
[    0.120106] NMI watchdog: Perf event create on CPU 0 failed with -2
[    0.120828] NMI watchdog: Perf NMI watchdog permanently disabled
[    0.160034] smp: Bringing up secondary CPUs ...
[    0.250053] CPU 1 irqstacks, hard=3D4014a000 soft=3D4014c000
[    0.250678] x86: Booting SMP configuration:
[    0.251183] .... node  #0, CPUs:      #1
[    0.000000] Initializing CPU#1
[    0.010000] kvm-clock: cpu 1, msr 0:13fdc021, secondary cpu clock
[    0.010000] masked ExtINT on CPU#1
[    0.263956] KVM setup async PF for cpu 1
[    0.263956] kvm-stealtime: cpu 1, msr 13923b00
[    0.264932] smp: Brought up 1 node, 2 CPUs
[    0.265373] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.266886] devtmpfs: initialized
[    0.271404] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 19112604462750000 ns
[    0.272331] futex hash table entries: 512 (order: 2, 24576 bytes)
[    0.273017] xor: measuring software checksum speed
[    0.370041]    pIII_sse  :  8987.200 MB/sec
[    0.466064]    prefetch64-sse: 13313.200 MB/sec
[    0.466528] xor: using function: prefetch64-sse (13313.200 MB/sec)
[    0.467129] prandom: seed boundary self test passed
[    0.468047] prandom: 100 self tests passed
[    0.468697] regulator-dummy: Failed to create debugfs directory
[    0.469678] NET: Registered protocol family 16
[    0.471737] audit: initializing netlink subsys (disabled)
[    0.476518] audit: type=3D2000 audit(1511582109.054:1): state=3Dinitiali=
zed audit_enabled=3D0 res=3D1
[    0.476500] EISA bus registered
[    0.480039] cpuidle: using governor menu
[    0.482136] ACPI: bus type PCI registered
[    0.482734] PCI: Using configuration type 1 for base access
[    0.676588] raid6: mmxx1    gen()  4962 MB/s
[    0.846016] raid6: mmxx2    gen()  5384 MB/s
[    1.016053] raid6: sse1x1   gen()  4091 MB/s
[    1.190025] raid6: sse1x2   gen()  5041 MB/s
[    1.360011] raid6: sse2x1   gen()  8027 MB/s
[    1.530009] raid6: sse2x1   xor()  6554 MB/s
[    1.700010] raid6: sse2x2   gen() 10282 MB/s
[    1.870010] raid6: sse2x2   xor()  7410 MB/s
[    1.870484] raid6: using algorithm sse2x2 gen() 10282 MB/s
[    1.870969] raid6: .... xor() 7410 MB/s, rmw enabled
[    1.871494] raid6: using intx1 recovery algorithm
[    1.873509] ACPI: Added _OSI(Module Device)
[    1.873929] ACPI: Added _OSI(Processor Device)
[    1.874370] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.874803] ACPI: Added _OSI(Processor Aggregator Device)
[    1.878647] ACPI: Interpreter enabled
[    1.879046] ACPI: (supports S0 S5)
[    1.879390] ACPI: Using IOAPIC for interrupt routing
[    1.879868] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.880291] ACPI: Enabled 2 GPEs in block 00 to 0F
[    1.887901] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.888554] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    1.889118] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.890095] PCI host bridge to bus 0000:00
[    1.890519] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    1.891155] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    1.891792] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    1.892477] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f window]
[    1.893223] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.893786] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.894926] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.896093] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.900936] pci 0000:00:01.1: reg 0x20: [io  0xc080-0xc08f]
[    1.903271] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.903959] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.904567] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.905272] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.906169] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.907097] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.908208] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.909213] pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
[    1.912672] pci 0000:00:02.0: reg 0x10: [mem 0xfd000000-0xfdffffff pref]
[    1.916863] pci 0000:00:02.0: reg 0x18: [mem 0xfebf0000-0xfebf0fff]
[    1.924456] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.925520] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.927772] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.930016] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.936672] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.937735] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.940847] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.942975] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.948098] pci 0000:00:04.0: reg 0x20: [mem 0xfe000000-0xfe003fff 64bit=
 pref]
[    1.952533] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    1.953758] pci 0000:00:05.0: reg 0x10: [mem 0xfebf2000-0xfebf200f]
[    1.957925] pci_bus 0000:00: on NUMA node 0
[    1.959132] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.960185] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.960878] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.961622] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.962237] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.964407] SCSI subsystem initialized
[    1.964805] libata version 3.00 loaded.
[    1.965257] ACPI: bus type USB registered
[    1.965677] usbcore: registered new interface driver usbfs
[    1.966228] usbcore: registered new interface driver hub
[    1.966791] usbcore: registered new device driver usb
[    1.967364] Linux video capture interface: v2.00
[    1.967834] pps_core: LinuxPPS API ver. 1 registered
[    1.968311] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.970048] EDAC MC: Ver: 3.0.0
[    1.980070] dell_smbios: Unable to run on non-Dell system
[    1.990128] PCI: Using ACPI for IRQ routing
[    1.990540] PCI: pci_cache_line_size set to 32 bytes
[    1.991128] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.991693] e820: reserve RAM buffer [mem 0x13fde000-0x13ffffff]
[    1.992556] Bluetooth: Core ver 2.22
[    1.992924] NET: Registered protocol family 31
[    1.993369] Bluetooth: HCI device and connection manager initialized
[    1.993976] Bluetooth: HCI socket layer initialized
[    1.994440] Bluetooth: L2CAP socket layer initialized
[    1.994955] NET: Registered protocol family 8
[    1.995372] NET: Registered protocol family 20
[    1.995840] nfc: nfc_init: NFC Core ver 0.1
[    1.996270] NET: Registered protocol family 39
[    1.998360] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.999310] clocksource: Switched to clocksource kvm-clock
[    1.999890] FS-Cache: Loaded
[    1.999890] CacheFiles: Loaded
[    1.999890] pnp: PnP ACPI init
[    1.999890] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.999890] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.999890] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.999890] pnp 00:03: [dma 2]
[    1.999890] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.999890] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.999890] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.999890] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.999890] pnp: PnP ACPI: found 7 devices
[    2.033302] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    2.034243] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    2.034842] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    2.035424] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    2.036087] pci_bus 0000:00: resource 7 [mem 0x14000000-0xfebfffff windo=
w]
[    2.036885] NET: Registered protocol family 2
[    2.037641] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    2.038320] TCP bind hash table entries: 4096 (order: 5, 163840 bytes)
[    2.039135] TCP: Hash tables configured (established 4096 bind 4096)
[    2.039812] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    2.040422] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    2.041268] NET: Registered protocol family 1
[    2.041711] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.042280] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.042842] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.043455] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    2.044289] PCI: CLS 0 bytes, default 32
[    2.044808] Unpacking initramfs...
[    2.326153] Freeing initrd memory: 3568K
[    2.328269] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x26d=
349e8249, max_idle_ns: 440795288087 ns
[    2.330231] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.331175] NatSemi SCx200 Driver
[    2.331561] rcu-perf:--- Start of test: nreaders=3D0 nwriters=3D2 verbos=
e=3D1 shutdown=3D1
[    2.332296] rcu-torture: Creating rcu_perf_shutdown task
[    2.350080] rcu-torture: Creating rcu_perf_writer task
[    2.350644] rcu-perf: rcu_perf_writer task started
[    2.350669] rcu-torture: Creating rcu_perf_writer task
[    2.351051] Key type blacklist registered
[    2.351117] rcu-perf: rcu_perf_writer task started
[    2.351185] workingset: timestamp_bits=3D14 max_order=3D17 bucket_order=
=3D3
[    2.354165] zbud: loaded
[    2.355355] DLM installed
[    2.356364] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.357369] ntfs: driver 2.1.32 [Flags: R/O].
[    2.358001] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.359576] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.360217] qnx6: QNX6 filesystem 1.0.0 registered.
[    2.360798] fuse init (API version 7.26)
[    2.361590] orangefs_debugfs_init: called with debug mask: :none: :0:
[    2.362290] orangefs_init: module version upstream loaded
[    2.362952] JFS: nTxBlock =3D 2147, nTxLock =3D 17176
[    2.364192] SGI XFS with security attributes, realtime, debug enabled
[    2.366168] NILFS version 2 loaded
[    2.366505] befs: version: 0.9.3
[    2.367889] gfs2: GFS2 installed
[    2.373045] NET: Registered protocol family 38
[    2.373590] bounce: pool size: 64 pages
[    2.374058] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 247)
[    2.374769] io scheduler noop registered
[    2.375146] io scheduler deadline registered (default)
[    2.375759] io scheduler bfq registered
[    2.544933] String selftests succeeded
[    2.545344] test_string_helpers: Running tests...
[    2.546201] test_firmware: interface ready
[    2.552267] test_hash: __hash_32() has no arch implementation to test.
[    2.552937] test_hash: hash_32() has no arch implementation to test.
[    2.553544] test_hash: hash_64() has no arch implementation to test.
[    2.554152] test_hash: 33152 tests passed.
[    2.554598] test_siphash: self-tests: pass
[    2.555522] Running rhashtable test nelem=3D8, max_size=3D0, shrinking=
=3D0
[    2.556161] Test 00:
[    2.556423]   Adding 50000 keys
[    2.641160]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.672810]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.673598]   Deleting 50000 keys
[    2.715004]   Duration of test: 158275328 ns
[    2.715424] Test 01:
[    2.715691]   Adding 50000 keys
[    2.806635]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.838226]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.838990]   Deleting 50000 keys
[    2.880296]   Duration of test: 164292138 ns
[    2.880741] Test 02:
[    2.880989]   Adding 50000 keys
[    2.974590] Info: encountered resize
[    2.981373]   Traversal complete: counted=3D50378, nelems=3D50000, entri=
es=3D50000, table-jumps=3D1
[    2.982162] Test failed: Total count mismatch ^^^
[    3.012935]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    3.014167]   Deleting 50000 keys
[    3.055413]   Duration of test: 174113700 ns
[    3.055873] Test 03:
[    3.056142]   Adding 50000 keys
[    3.146706]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    3.178356]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    3.179138]   Deleting 50000 keys
[    3.220703]   Duration of test: 164254169 ns
[    3.237367] test if its possible to exceed max_size 8192: no, ok
[    3.237983] Average test time: 165233833
[    3.238362] Testing concurrent rhashtable access from 10 threads
[    5.726903] test 3125 add/delete pairs into rhlist
[    5.870229] test 3125 random rhlist add/delete operations
[    6.048078] Started 10 threads, 0 failed, rhltable test returns 0
[    6.048834] test passed
[    6.049221] test_printf: all 260 tests passed
[    6.049636] test_uuid: all 18 tests passed
[    6.050366] xz_dec_test: module loaded
[    6.050739] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
246 0' and write .xz files to it.
[    6.051774] glob: 64 self-tests passed, 0 failed
[    6.052469] rbtree testing
[    6.054905]  -> test 1 (latency of nnodes insert+delete): 6548 cycles
[    6.058351]  -> test 2 (latency of nnodes cached insert+delete): 6892 cy=
cles
[    6.059460]  -> test 3 (latency of inorder traversal): 1126 cycles
[    6.060094]  -> test 4 (latency to fetch first node)
[    6.060567]         non-cached: 19 cycles
[    6.060954]         cached: 0 cycles
[    6.087115] augmented rbtree testing
[    6.091076]  -> test 1 (latency of nnodes insert+delete): 10636 cycles
[    6.095785]  -> test 2 (latency of nnodes cached insert+delete): 9975 cy=
cles
[    6.132004] interval tree insert/remove
[    6.135878]  -> 10398 cycles
[    6.136569] interval tree search
[    6.163542]  -> 72612 cycles (2692 results)
[    6.164581] gpio_it87: no device
[    6.165727] vmlfb: initializing
[    6.166067] Could not find Carillo Ranch MCH device.
[    6.166693] hgafb: HGA card not detected.
[    6.167087] hgafb: probe of hgafb.0 failed with error -22
[    6.167715] usbcore: registered new interface driver udlfb
[    6.169025] uvesafb: failed to execute /sbin/v86d
[    6.169538] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    6.170257] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    6.170894] uvesafb: vbe_init() failed with -22
[    6.171332] uvesafb: probe of uvesafb.0 failed with error -22
[    6.171938] ipmi message handler version 39.2
[    6.172359] ipmi device interface
[    6.172702] IPMI System Interface driver.
[    6.173212] ipmi_si: Unable to find any System Interface(s)
[    6.173745] IPMI SSIF Interface driver
[    6.174135] IPMI Watchdog: driver initialized
[    6.174720] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    6.175422] ACPI: Power Button [PWRF]
[    6.176019] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    6.176716] ACPI: Power Button [PWRF]
[    6.293174] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    6.550158] HDLC line discipline maxframe=3D4096
[    6.550629] N_HDLC line discipline registered.
[    6.551053] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.551566] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.576076] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.577533] console [ttyS0] disabled
[    0.000000] Linux version 4.14.0-13292-g1d3b78b (kbuild@lkp-wsx02) (gcc =
version 5.4.1 20171010 (Debian 5.5.0-3)) #1 SMP PREEMPT Sat Nov 25 11:29:48=
 CST 2017
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fddfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fde000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 0=
4/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fde max_arch_pfn =3D 0x100000
[    0.000000] x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC=
 =20
[    0.000000] initial memory mapped: [mem 0x00000000-0x047fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] BRK [0x03f68000, 0x03f68fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13c54000-0x13fcffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F6870 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE1628 000030 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE147C 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 00143C (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: APIC 0x0000000013FE1570 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE15F0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fde000
[    0.000000]   low ram: 0 - 13fde000
[    0.000000] kvm-clock: cpu 0, msr 0:13fdc001, primary cpu clock
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: using sched offset of 1467338557 cycles
[    0.000000] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles:=
 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] BRK [0x03f69000, 0x03f69fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000001000-0x0000000013fddfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x0000000013fddfff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000013fdd=
fff]
[    0.000000] On node 0 totalpages: 81788
[    0.000000]   Normal zone: 800 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81788 pages, LIFO batch:15
[    0.000000] Reserved but unavailable: 98 pages
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 19112604462750000 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] percpu: Embedded 19 pages/cpu @5390e000 s54236 r0 d23588 u77=
824
[    0.000000] pcpu-alloc: s54236 r0 d23588 u77824 alloc=3D19*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13910b00
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 80988
[    0.000000] Kernel command line: ip=3D::::vm-ivb41-yocto-i386-1::dhcp ro=
ot=3D/dev/ram0 user=3Dlkp job=3D/lkp/scheduled/vm-ivb41-yocto-i386-1/trinit=
y-300s-yocto-tiny-i386-2016-04-22.cgz-1d3b78bbc6e983fabb3fbf91b76339bf66e4a=
12c-20171125-65036-1j2iqyn-1.yaml ARCH=3Di386 kconfig=3Di386-randconfig-sb0=
-11100832 branch=3Dlinus/master commit=3D1d3b78bbc6e983fabb3fbf91b76339bf66=
e4a12c BOOT_IMAGE=3D/pkg/linux/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc=
6e983fabb3fbf91b76339bf66e4a12c/vmlinuz-4.14.0-13292-g1d3b78b max_uptime=3D=
1500 RESULT_ROOT=3D/result/trinity/300s/vm-ivb41-yocto-i386/yocto-tiny-i386=
-2016-04-22.cgz/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91=
b76339bf66e4a12c/1 LKP_SERVER=3Dinn debug apic=3Ddebug sysrq_always_enabled=
 rcupdate.rcu_cpu_stall_timeout=3D100 net.ifnames=3D0 printk.devkmsg=3Don p=
anic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 drbd.minor_count=3D8 systemd.log_level=3Derr igno=
re_loglevel console=3Dtty0 earlyprintk=3DttyS0,115200 console=3DttyS0,11520=
0 vga=3Dno
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 271188K/327152K available (24616K kernel code, 1264K=
 rwdata, 7908K rodata, 928K init, 13440K bss, 55964K reserved, 0K cma-reser=
ved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff0e000 - 0xfffff000   ( 964 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x547de000 - 0xff7fe000   (2736 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x53fde000   ( 319 MB)
[    0.000000]       .init : 0x4313b000 - 0x43223000   ( 928 kB)
[    0.000000]       .data : 0x4280a2da - 0x4310a0d0   (9215 kB)
[    0.000000]       .text : 0x41000000 - 0x4280a2da   (24616 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.008884] Running RCU self tests
[    0.008888] Preemptible hierarchical RCU implementation.
[    0.008890] 	RCU lockdep checking is enabled.
[    0.008891] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D2.
[    0.008893] 	RCU priority boosting: priority 1 delay 500 ms.
[    0.008895] 	RCU callback double-/use-after-free debug enabled.
[    0.008898] 	RCU CPU stall warnings timeout set to 100 (rcu_cpu_stall_ti=
meout).
[    0.008899] 	Tasks RCU enabled.
[    0.008901] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.008927] NR_IRQS: 2304, nr_irqs: 440, preallocated irqs: 16
[    0.009116] CPU 0 irqstacks, hard=3D40012000 soft=3D40014000
[    0.009119] 	Offload RCU callbacks from CPUs: .
[    0.010000] console [ttyS0] enabled
[    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.010000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.010000] ... MAX_LOCK_DEPTH:          48
[    0.010000] ... MAX_LOCKDEP_KEYS:        8191
[    0.010000] ... CLASSHASH_SIZE:          4096
[    0.010000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.010000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.010000] ... CHAINHASH_SIZE:          32768
[    0.010000]  memory used by lock dependency info: 4399 kB
[    0.010000]  per task-struct memory footprint: 1536 bytes
[    0.010000] ACPI: Core revision 20170831
[    0.010000] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.010000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 19112604467 ns
[    0.010000] hpet clockevent registered
[    0.010022] APIC: Switch to symmetric I/O mode setup
[    0.010515] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.011056] enabled ExtINT on CPU#0
[    0.012015] ENABLING IO-APIC IRQs
[    0.012350] init IO_APIC IRQs
[    0.012638]  apic 0 pin 0 not connected
[    0.013031] IOAPIC[0]: Set routing entry (0-1 -> 0xef -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.013792] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.014548] IOAPIC[0]: Set routing entry (0-3 -> 0xef -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.015301] IOAPIC[0]: Set routing entry (0-4 -> 0xef -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.016050] IOAPIC[0]: Set routing entry (0-5 -> 0xef -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.016796] IOAPIC[0]: Set routing entry (0-6 -> 0xef -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.017544] IOAPIC[0]: Set routing entry (0-7 -> 0xef -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.018295] IOAPIC[0]: Set routing entry (0-8 -> 0xef -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.019039] IOAPIC[0]: Set routing entry (0-9 -> 0xef -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.019817] IOAPIC[0]: Set routing entry (0-10 -> 0xef -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-11 -> 0xef -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-12 -> 0xef -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-13 -> 0xef -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-14 -> 0xef -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.020000] IOAPIC[0]: Set routing entry (0-15 -> 0xef -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.020000]  apic 0 pin 16 not connected
[    0.020000]  apic 0 pin 17 not connected
[    0.020000]  apic 0 pin 18 not connected
[    0.020000]  apic 0 pin 19 not connected
[    0.020000]  apic 0 pin 20 not connected
[    0.020000]  apic 0 pin 21 not connected
[    0.020000]  apic 0 pin 22 not connected
[    0.020000]  apic 0 pin 23 not connected
[    0.020000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.020000] tsc: Detected 2693.508 MHz processor
[    0.020000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D26935080)
[    0.020005] pid_max: default: 32768 minimum: 301
[    0.020658] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.021400] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.022661] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023268] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.024403] Freeing SMP alternatives memory: 72K
[    0.026135] smpboot: Max logical packages: 2
[    0.026636] Using local APIC timer interrupts.
[    0.026636] calibrating APIC timer ...
[    0.030000] ... lapic delta =3D 6250221
[    0.030000] ... PM-Timer delta =3D 357960
[    0.030000] ... PM-Timer result ok
[    0.030000] ..... delta 6250221
[    0.030000] ..... mult: 268444947
[    0.030000] ..... calibration result: 10000353
[    0.030000] ..... CPU clock speed is 2693.5520 MHz.
[    0.030000] ..... host bus clock speed is 1000.0353 MHz.
[    0.030000] smpboot: CPU0: GenuineIntel QEMU Virtual CPU version 2.5+ (f=
amily: 0x6, model: 0x6, stepping: 0x3)
[    0.060033] Performance Events: no PMU driver, software events only.
[    0.080030] Hierarchical SRCU implementation.
[    0.120106] NMI watchdog: Perf event create on CPU 0 failed with -2
[    0.120828] NMI watchdog: Perf NMI watchdog permanently disabled
[    0.160034] smp: Bringing up secondary CPUs ...
[    0.250053] CPU 1 irqstacks, hard=3D4014a000 soft=3D4014c000
[    0.250678] x86: Booting SMP configuration:
[    0.251183] .... node  #0, CPUs:      #1
[    0.000000] Initializing CPU#1
[    0.010000] kvm-clock: cpu 1, msr 0:13fdc021, secondary cpu clock
[    0.010000] masked ExtINT on CPU#1
[    0.263956] KVM setup async PF for cpu 1
[    0.263956] kvm-stealtime: cpu 1, msr 13923b00
[    0.264932] smp: Brought up 1 node, 2 CPUs
[    0.265373] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.266886] devtmpfs: initialized
[    0.271404] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 19112604462750000 ns
[    0.272331] futex hash table entries: 512 (order: 2, 24576 bytes)
[    0.273017] xor: measuring software checksum speed
[    0.370041]    pIII_sse  :  8987.200 MB/sec
[    0.466064]    prefetch64-sse: 13313.200 MB/sec
[    0.466528] xor: using function: prefetch64-sse (13313.200 MB/sec)
[    0.467129] prandom: seed boundary self test passed
[    0.468047] prandom: 100 self tests passed
[    0.468697] regulator-dummy: Failed to create debugfs directory
[    0.469678] NET: Registered protocol family 16
[    0.471737] audit: initializing netlink subsys (disabled)
[    0.476518] audit: type=3D2000 audit(1511582109.054:1): state=3Dinitiali=
zed audit_enabled=3D0 res=3D1
[    0.476500] EISA bus registered
[    0.480039] cpuidle: using governor menu
[    0.482136] ACPI: bus type PCI registered
[    0.482734] PCI: Using configuration type 1 for base access
[    0.676588] raid6: mmxx1    gen()  4962 MB/s
[    0.846016] raid6: mmxx2    gen()  5384 MB/s
[    1.016053] raid6: sse1x1   gen()  4091 MB/s
[    1.190025] raid6: sse1x2   gen()  5041 MB/s
[    1.360011] raid6: sse2x1   gen()  8027 MB/s
[    1.530009] raid6: sse2x1   xor()  6554 MB/s
[    1.700010] raid6: sse2x2   gen() 10282 MB/s
[    1.870010] raid6: sse2x2   xor()  7410 MB/s
[    1.870484] raid6: using algorithm sse2x2 gen() 10282 MB/s
[    1.870969] raid6: .... xor() 7410 MB/s, rmw enabled
[    1.871494] raid6: using intx1 recovery algorithm
[    1.873509] ACPI: Added _OSI(Module Device)
[    1.873929] ACPI: Added _OSI(Processor Device)
[    1.874370] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.874803] ACPI: Added _OSI(Processor Aggregator Device)
[    1.878647] ACPI: Interpreter enabled
[    1.879046] ACPI: (supports S0 S5)
[    1.879390] ACPI: Using IOAPIC for interrupt routing
[    1.879868] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.880291] ACPI: Enabled 2 GPEs in block 00 to 0F
[    1.887901] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.888554] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    1.889118] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.890095] PCI host bridge to bus 0000:00
[    1.890519] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    1.891155] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    1.891792] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    1.892477] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f window]
[    1.893223] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.893786] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.894926] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.896093] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.900936] pci 0000:00:01.1: reg 0x20: [io  0xc080-0xc08f]
[    1.903271] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.903959] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.904567] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.905272] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.906169] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.907097] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.908208] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.909213] pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
[    1.912672] pci 0000:00:02.0: reg 0x10: [mem 0xfd000000-0xfdffffff pref]
[    1.916863] pci 0000:00:02.0: reg 0x18: [mem 0xfebf0000-0xfebf0fff]
[    1.924456] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.925520] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.927772] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.930016] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.936672] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.937735] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.940847] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.942975] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.948098] pci 0000:00:04.0: reg 0x20: [mem 0xfe000000-0xfe003fff 64bit=
 pref]
[    1.952533] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    1.953758] pci 0000:00:05.0: reg 0x10: [mem 0xfebf2000-0xfebf200f]
[    1.957925] pci_bus 0000:00: on NUMA node 0
[    1.959132] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.960185] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.960878] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.961622] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.962237] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.964407] SCSI subsystem initialized
[    1.964805] libata version 3.00 loaded.
[    1.965257] ACPI: bus type USB registered
[    1.965677] usbcore: registered new interface driver usbfs
[    1.966228] usbcore: registered new interface driver hub
[    1.966791] usbcore: registered new device driver usb
[    1.967364] Linux video capture interface: v2.00
[    1.967834] pps_core: LinuxPPS API ver. 1 registered
[    1.968311] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.970048] EDAC MC: Ver: 3.0.0
[    1.980070] dell_smbios: Unable to run on non-Dell system
[    1.990128] PCI: Using ACPI for IRQ routing
[    1.990540] PCI: pci_cache_line_size set to 32 bytes
[    1.991128] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.991693] e820: reserve RAM buffer [mem 0x13fde000-0x13ffffff]
[    1.992556] Bluetooth: Core ver 2.22
[    1.992924] NET: Registered protocol family 31
[    1.993369] Bluetooth: HCI device and connection manager initialized
[    1.993976] Bluetooth: HCI socket layer initialized
[    1.994440] Bluetooth: L2CAP socket layer initialized
[    1.994955] NET: Registered protocol family 8
[    1.995372] NET: Registered protocol family 20
[    1.995840] nfc: nfc_init: NFC Core ver 0.1
[    1.996270] NET: Registered protocol family 39
[    1.998360] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.999310] clocksource: Switched to clocksource kvm-clock
[    1.999890] FS-Cache: Loaded
[    1.999890] CacheFiles: Loaded
[    1.999890] pnp: PnP ACPI init
[    1.999890] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.999890] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.999890] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.999890] pnp 00:03: [dma 2]
[    1.999890] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.999890] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.999890] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.999890] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.999890] pnp: PnP ACPI: found 7 devices
[    2.033302] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    2.034243] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    2.034842] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    2.035424] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    2.036087] pci_bus 0000:00: resource 7 [mem 0x14000000-0xfebfffff windo=
w]
[    2.036885] NET: Registered protocol family 2
[    2.037641] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    2.038320] TCP bind hash table entries: 4096 (order: 5, 163840 bytes)
[    2.039135] TCP: Hash tables configured (established 4096 bind 4096)
[    2.039812] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    2.040422] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    2.041268] NET: Registered protocol family 1
[    2.041711] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.042280] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.042842] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.043455] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    2.044289] PCI: CLS 0 bytes, default 32
[    2.044808] Unpacking initramfs...
[    2.326153] Freeing initrd memory: 3568K
[    2.328269] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x26d=
349e8249, max_idle_ns: 440795288087 ns
[    2.330231] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.331175] NatSemi SCx200 Driver
[    2.331561] rcu-perf:--- Start of test: nreaders=3D0 nwriters=3D2 verbos=
e=3D1 shutdown=3D1
[    2.332296] rcu-torture: Creating rcu_perf_shutdown task
[    2.350080] rcu-torture: Creating rcu_perf_writer task
[    2.350644] rcu-perf: rcu_perf_writer task started
[    2.350669] rcu-torture: Creating rcu_perf_writer task
[    2.351051] Key type blacklist registered
[    2.351117] rcu-perf: rcu_perf_writer task started
[    2.351185] workingset: timestamp_bits=3D14 max_order=3D17 bucket_order=
=3D3
[    2.354165] zbud: loaded
[    2.355355] DLM installed
[    2.356364] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.357369] ntfs: driver 2.1.32 [Flags: R/O].
[    2.358001] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.359576] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.360217] qnx6: QNX6 filesystem 1.0.0 registered.
[    2.360798] fuse init (API version 7.26)
[    2.361590] orangefs_debugfs_init: called with debug mask: :none: :0:
[    2.362290] orangefs_init: module version upstream loaded
[    2.362952] JFS: nTxBlock =3D 2147, nTxLock =3D 17176
[    2.364192] SGI XFS with security attributes, realtime, debug enabled
[    2.366168] NILFS version 2 loaded
[    2.366505] befs: version: 0.9.3
[    2.367889] gfs2: GFS2 installed
[    2.373045] NET: Registered protocol family 38
[    2.373590] bounce: pool size: 64 pages
[    2.374058] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 247)
[    2.374769] io scheduler noop registered
[    2.375146] io scheduler deadline registered (default)
[    2.375759] io scheduler bfq registered
[    2.544933] String selftests succeeded
[    2.545344] test_string_helpers: Running tests...
[    2.546201] test_firmware: interface ready
[    2.552267] test_hash: __hash_32() has no arch implementation to test.
[    2.552937] test_hash: hash_32() has no arch implementation to test.
[    2.553544] test_hash: hash_64() has no arch implementation to test.
[    2.554152] test_hash: 33152 tests passed.
[    2.554598] test_siphash: self-tests: pass
[    2.555522] Running rhashtable test nelem=3D8, max_size=3D0, shrinking=
=3D0
[    2.556161] Test 00:
[    2.556423]   Adding 50000 keys
[    2.641160]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.672810]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.673598]   Deleting 50000 keys
[    2.715004]   Duration of test: 158275328 ns
[    2.715424] Test 01:
[    2.715691]   Adding 50000 keys
[    2.806635]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.838226]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    2.838990]   Deleting 50000 keys
[    2.880296]   Duration of test: 164292138 ns
[    2.880741] Test 02:
[    2.880989]   Adding 50000 keys
[    2.974590] Info: encountered resize
[    2.981373]   Traversal complete: counted=3D50378, nelems=3D50000, entri=
es=3D50000, table-jumps=3D1
[    2.982162] Test failed: Total count mismatch ^^^
[    3.012935]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    3.014167]   Deleting 50000 keys
[    3.055413]   Duration of test: 174113700 ns
[    3.055873] Test 03:
[    3.056142]   Adding 50000 keys
[    3.146706]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    3.178356]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[    3.179138]   Deleting 50000 keys
[    3.220703]   Duration of test: 164254169 ns
[    3.237367] test if its possible to exceed max_size 8192: no, ok
[    3.237983] Average test time: 165233833
[    3.238362] Testing concurrent rhashtable access from 10 threads
[    5.726903] test 3125 add/delete pairs into rhlist
[    5.870229] test 3125 random rhlist add/delete operations
[    6.048078] Started 10 threads, 0 failed, rhltable test returns 0
[    6.048834] test passed
[    6.049221] test_printf: all 260 tests passed
[    6.049636] test_uuid: all 18 tests passed
[    6.050366] xz_dec_test: module loaded
[    6.050739] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
246 0' and write .xz files to it.
[    6.051774] glob: 64 self-tests passed, 0 failed
[    6.052469] rbtree testing
[    6.054905]  -> test 1 (latency of nnodes insert+delete): 6548 cycles
[    6.058351]  -> test 2 (latency of nnodes cached insert+delete): 6892 cy=
cles
[    6.059460]  -> test 3 (latency of inorder traversal): 1126 cycles
[    6.060094]  -> test 4 (latency to fetch first node)
[    6.060567]         non-cached: 19 cycles
[    6.060954]         cached: 0 cycles
[    6.087115] augmented rbtree testing
[    6.091076]  -> test 1 (latency of nnodes insert+delete): 10636 cycles
[    6.095785]  -> test 2 (latency of nnodes cached insert+delete): 9975 cy=
cles
[    6.132004] interval tree insert/remove
[    6.135878]  -> 10398 cycles
[    6.136569] interval tree search
[    6.163542]  -> 72612 cycles (2692 results)
[    6.164581] gpio_it87: no device
[    6.165727] vmlfb: initializing
[    6.166067] Could not find Carillo Ranch MCH device.
[    6.166693] hgafb: HGA card not detected.
[    6.167087] hgafb: probe of hgafb.0 failed with error -22
[    6.167715] usbcore: registered new interface driver udlfb
[    6.169025] uvesafb: failed to execute /sbin/v86d
[    6.169538] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    6.170257] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    6.170894] uvesafb: vbe_init() failed with -22
[    6.171332] uvesafb: probe of uvesafb.0 failed with error -22
[    6.171938] ipmi message handler version 39.2
[    6.172359] ipmi device interface
[    6.172702] IPMI System Interface driver.
[    6.173212] ipmi_si: Unable to find any System Interface(s)
[    6.173745] IPMI SSIF Interface driver
[    6.174135] IPMI Watchdog: driver initialized
[    6.174720] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    6.175422] ACPI: Power Button [PWRF]
[    6.176019] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    6.176716] ACPI: Power Button [PWRF]
[    6.293174] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    6.550158] HDLC line discipline maxframe=3D4096
[    6.550629] N_HDLC line discipline registered.
[    6.551053] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.551566] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.576076] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.577533] console [ttyS0] disabled
[    6.601769] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.858437] console [ttyS0] enabled
[    6.882889] 00:06: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200) =
is a 16550A
[    6.908152] 00:06: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200) =
is a 16550A
[    6.910417] Cyclades driver 2.6
[    6.931022] RocketPort device driver module, version 2.09, 12-June-2003
[    6.931773] No rocketport ports found; unloading driver
[    6.932296] SyncLink MultiPort driver $Revision: 4.38 $
[    6.937063] SyncLink MultiPort driver $Revision: 4.38 $, tty major#239
[    6.937729] SyncLink serial driver $Revision: 4.38 $
[    6.942323] SyncLink serial driver $Revision: 4.38 $, tty major#238
[    6.943054] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    6.943796] ac.o: No PCI boards found.
[    6.944153] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    6.944825] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    6.945489] Non-volatile memory driver v1.3
[    6.946100] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    6.946592] smapi::smapi_init, ERROR invalid usSmapiID
[    6.947081] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    6.947971] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    6.948645] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.949237] Linux agpgart interface v0.103
[    6.949817] SyncLink PC Card driver $Revision: 4.34 $, tty major#236
[    6.950520] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    6.952040] [drm] amdgpu kernel modesetting enabled.
[    6.952613] usbcore: registered new interface driver udl
[    6.953543] dummy-irq: no IRQ given.  Use irq=3DN
[    6.954234] Guest personality initialized and is inactive
[    6.954857] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D56)
[    6.955484] Initialized host personality
[    6.956274] usbcore: registered new interface driver viperboard
[    6.956901] usbcore: registered new interface driver pn533_usb
[    6.957479] usbcore: registered new interface driver nfcmrvl
[    6.958021] NCI uart driver 'nfcmrvl_uart [0]' registered
[    6.958565] Uniform Multi-Platform E-IDE driver
[    6.959794] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    6.960806] Loading iSCSI transport class v2.0-870.
[    6.982219] fnic: Cisco FCoE HBA Driver, ver 1.6.0.34
[    6.982859] fnic: Successfully Initialized Trace Buffer
[    6.983456] fnic: Successfully Initialized FC_CTLR Trace Buffer
[    6.984544] snic:SNIC Driver is supported only for x86_64 platforms!
[    6.985169] snic:Cisco SCSI NIC Driver, ver 0.0.1.18
[    6.986373] bnx2fc: QLogic FCoE Driver bnx2fc v2.11.8 (October 15, 2015)
[    6.997697] iscsi: registered transport (tcp)
[    6.998282] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    6.998835] Detecting Adaptec I2O RAID controllers...
[    7.000480] Adaptec aacraid driver 1.2.1[50834]-custom
[    7.001012] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.001935] scsi: <fdomain> Detection failed (no card)
[    7.002514] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 10.00.00.02-k.
[    7.003582] iscsi: registered transport (qla4xxx)
[    7.004146] QLogic iSCSI HBA Driver
[    7.004481] QLogic BR-series BFA FC/FCOE SCSI driver - version: 3.2.25.1
[    7.005153] csiostor: Chelsio FCoE driver 1.0.0-ko
[    7.742094] megasas: 07.703.05.00-rc1
[    7.742541] mpt3sas version 17.100.00.00 loaded
[    7.743329] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    7.744073] ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 (March=
 14, 2017)
[    7.744862] RocketRAID 3xxx/4xxx Controller driver v1.10.0
[    7.745430] stex: Promise SuperTrak EX Driver version: 6.02.0000.01
[    7.746127] QLogic NetXtreme II iSCSI Driver bnx2i v2.7.10.1 (Jul 16, 20=
14)
[    7.746875] iscsi: registered transport (bnx2i)
[    7.758260] iscsi: registered transport (be2iscsi)
[    7.758763] In beiscsi_module_init, tt=3D430844e0
[    7.759266] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    7.760126] VMware PVSCSI driver - version 1.0.7.0-k
[    7.760625] st: Version 20160209, fixed bufsize 32768, s/g segs 256
[    7.761269] osst :I: Tape driver with OnStream support version 0.99.4
[    7.761269] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.765981] scsi host0: scsi_debug: version 1.86 [20160430]
[    7.765981]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statistics=
=3D0
[    7.767897] scsi host0: scsi_debug: version 1.86 [20160430]
[    7.767897]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statistics=
=3D0
[    7.769468] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
86 PQ: 0 ANSI: 7
[    7.770899] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    7.772051] SSFDC read-only Flash Translation layer
[    7.782697] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    7.783405] device id =3D 2440
[    7.783747] device id =3D 2480
[    7.784027] device id =3D 24c0
[    7.784320] device id =3D 24d0
[    7.784609] device id =3D 25a1
[    7.784907] device id =3D 2670
[    7.785261] platform physmap-flash.0: failed to claim resource 0: [mem 0=
x08000000-0x07ffffff]
[    7.786060] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    7.786709] slram: not enough parameters.
[    7.787097] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    7.787786] pmc551: not detected
[    7.789407] ftl_cs: FTL header not found.
[    7.791117] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.791995] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.792869] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.793849] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.794716] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.795575] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    7.796491] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    7.797139] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    7.797570] nand: 128 MiB, SLC, erase size: 16 KiB, page size: 512, OOB =
size: 16
[    7.798246] flash size: 128 MiB
[    7.798547] page size: 512 bytes
[    7.798886] OOB area size: 16 bytes
[    7.799220] sector size: 16 KiB
[    7.799501] pages number: 262144
[    7.799819] pages per sector: 32
[    7.800198] bus width: 8
[    7.800455] bits in sector size: 14
[    7.800800] bits in page size: 9
[    7.801133] bits in OOB size: 4
[    7.801414] flash size with OOB: 135168 KiB
[    7.801789] page address bytes: 4
[    7.802085] sector address bytes: 3
[    7.802396] options: 0x42
[    7.803583] Scanning device for bad blocks
[    7.819865] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    7.820538] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    7.825992] ftl_cs: FTL header not found.
[    7.826766] [nandsim] warning: CONFIG_MTD_PARTITIONED_MASTER must be ena=
bled to expose debugfs stuff
[    7.827738] LocalTalk card not found; 220 =3D ff, 240 =3D ff.
[    7.828882] libphy: Fixed MDIO Bus: probed
[    7.829765] arcnet: arcnet loaded
[    7.830141] arcnet:rfc1201: RFC1201 "standard" (`a') encapsulation suppo=
rt loaded
[    7.830837] arcnet:arc_rawmode: raw mode (`r') encapsulation support loa=
ded
[    7.831467] arcnet:capmode: cap mode (`c') encapsulation support loaded
[    7.832087] arcnet:com90xx: COM90xx chipset support
[    8.133143] S3: No ARCnet cards found.
[    8.133592] arcnet:com90io: COM90xx IO-mapped mode support (by David Woo=
dhouse et el.)
[    8.134336] arcnet:com90io: E-mail me if you actually test this driver, =
please!
[    8.135022] (unnamed net_device) (uninitialized): No autoprobe for IO ma=
pped cards; you must specify the base address!
[    8.136055] arcnet:arc_rimi: RIM I (entirely mem-mapped) support
[    8.136608] arcnet:arc_rimi: E-mail me if you actually test the RIM I dr=
iver, please!
[    8.137307] arcnet:arc_rimi: Given: node 00h, shmem 0h, irq 0
[    8.137827] arcnet:arc_rimi: No autoprobe for RIM I; you must specify th=
e shmem and irq!
[    8.138561] arcnet:com20020_isa: COM20020 ISA support (by David Woodhous=
e et al.)
[    8.139291] (unnamed net_device) (uninitialized): No autoprobe (yet) for=
 IO mapped cards; you must specify the base address!
[    8.140531] vcan: Virtual CAN interface driver
[    8.140964] vxcan: Virtual CAN Tunnel driver
[    8.141370] slcan: serial line CAN interface driver
[    8.141831] slcan: 10 dynamic interface channels.
[    8.142292] CAN device driver interface
[    8.142649] usbcore: registered new interface driver kvaser_usb
[    8.143216] usbcore: registered new interface driver usb_8dev
[    8.143795] cc770: CAN netdevice driver
[    8.144150] cc770_isa: insufficient parameters supplied
[    8.181752] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    8.182326] Copyright (c) 2007 Atheros Corporation.
[    8.182921] cnic: QLogic cnicDriver v2.5.22 (July 20, 2015)
[    8.183580] bnx2x: QLogic 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2=
x 1.712.30-0 (2014/02/10)
[    8.194836] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    8.195434] e100: Copyright(c) 1999-2006 Intel Corporation
[    8.195974] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    8.196645] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    8.313368] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    8.702395] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    8.703160] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    9.412487] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    9.413265] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    9.413922] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    9.414513] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    9.415126] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.=
0-k
[    9.415766] igb: Copyright (c) 2007-2014 Intel Corporation.
[    9.416318] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 5.1.0-k
[    9.417078] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
[    9.417918] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 2.1.14-k
[    9.418761] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
[    9.429519] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    9.430274] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    9.430848] i40evf: Intel(R) 40-10 Gigabit Virtual Function Network Driv=
er - version 3.0.1-k
[    9.431608] Copyright (c) 2013 - 2015 Intel Corporation.
[    9.432279] Intel(R) Ethernet Switch Host Interface Driver - version 0.2=
2.1-k
[    9.432981] Copyright(c) 2013 - 2017 Intel Corporation.
[    9.443643] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    9.454816] nfp: NFP PCIe Driver, Copyright (C) 2014-2017 Netronome Syst=
ems
[    9.455529] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    9.456253] tlan: ThunderLAN driver v1.17
[    9.456655] tlan: 0 devices installed, PCI: 0  EISA: 0
[    9.457199] PPP generic driver version 2.4.2
[    9.457825] PPP BSD Compression module registered
[    9.458276] PPP Deflate Compression module registered
[    9.458775] PPP MPPE Compression module registered
[    9.459229] NET: Registered protocol family 24
[    9.459642] PPTP driver version 0.8.5
[    9.460138] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    9.460809] usbcore: registered new interface driver catc
[    9.461302] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    9.461992] usbcore: registered new interface driver pegasus
[    9.462505] usbcore: registered new interface driver r8152
[    9.463040] usbcore: registered new interface driver lan78xx
[    9.463573] usbcore: registered new interface driver asix
[    9.464114] usbcore: registered new interface driver cdc_ether
[    9.464701] usbcore: registered new interface driver dm9601
[    9.465260] usbcore: registered new interface driver sr9700
[    9.465796] usbcore: registered new interface driver smsc75xx
[    9.466315] usbcore: registered new interface driver smsc95xx
[    9.466904] usbcore: registered new interface driver gl620a
[    9.467434] usbcore: registered new interface driver net1080
[    9.467952] usbcore: registered new interface driver plusb
[    9.468508] usbcore: registered new interface driver cdc_subset
[    9.469053] usbcore: registered new interface driver zaurus
[    9.469556] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    9.470315] usbcore: registered new interface driver ipheth
[    9.470865] usbcore: registered new interface driver cdc_ncm
[    9.471399] usbcore: registered new interface driver huawei_cdc_ncm
[    9.472054] usbcore: registered new interface driver lg-vl600
[    9.472624] usbcore: registered new interface driver cdc_mbim
[    9.473147] usbcore: registered new interface driver ch9200
[    9.484390] Intel ISA PCIC probe:=20
[    9.484450] not found.
[    9.485092] Databook TCIC-2 PCMCIA probe:=20
[    9.485115] not found.
[    9.486075] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.486649] ohci-pci: OHCI PCI platform driver
[    9.487120] ohci-platform: OHCI generic platform driver
[    9.487601] uhci_hcd: USB Universal Host Controller Interface driver
[    9.488380] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    9.489055] Warning! fotg210_hcd should always be loaded before uhci_hcd=
 and ohci_hcd, not after
[    9.489955] usbcore: registered new interface driver cdc_acm
[    9.490566] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    9.491345] usbcore: registered new interface driver cdc_wdm
[    9.491913] usbcore: registered new interface driver usbtmc
[    9.492454] usbcore: registered new interface driver mdc800
[    9.493066] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    9.493758] usbcore: registered new interface driver adutux
[    9.494277] usbcore: registered new interface driver appledisplay
[    9.494907] usbcore: registered new interface driver cypress_cy7c63
[    9.495473] usbcore: registered new interface driver cytherm
[    9.496064] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    9.496757] ftdi_elan: driver ftdi-elan
[    9.497173] usbcore: registered new interface driver ftdi-elan
[    9.497722] usbcore: registered new interface driver idmouse
[    9.498237] usbcore: registered new interface driver iowarrior
[    9.498787] usbcore: registered new interface driver ldusb
[    9.499302] usbcore: registered new interface driver legousbtower
[    9.499880] usbcore: registered new interface driver rio500
[    9.500495] usbcore: registered new interface driver usbtest
[    9.501149] usbcore: registered new interface driver trancevibrator
[    9.501767] usbcore: registered new interface driver usbsevseg
[    9.502398] usbcore: registered new interface driver chaoskey
[    9.502945] usbcore: registered new interface driver lvs
[    9.503567] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    9.504383] dummy_hcd dummy_hcd.0: Dummy host controller
[    9.504960] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    9.505892] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    9.506507] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    9.507188] usb usb1: Product: Dummy host controller
[    9.507655] usb usb1: Manufacturer: Linux 4.14.0-13292-g1d3b78b dummy_hcd
[    9.508348] usb usb1: SerialNumber: dummy_hcd.0
[    9.509398] hub 1-0:1.0: USB hub found
[    9.509875] hub 1-0:1.0: 1 port detected
[    9.510481] hub 1-0:1.0: USB hub found
[    9.510885] hub 1-0:1.0: 1 port detected
[    9.511641] hub 1-0:1.0: USB hub found
[    9.512052] hub 1-0:1.0: 1 port detected
[    9.512505] hub 1-0:1.0: USB hub found
[    9.512877] hub 1-0:1.0: 1 port detected
[    9.513331] dummy_hcd dummy_hcd.0: remove, state 1
[    9.513855] usb usb1: USB disconnect, device number 1
[    9.514981] dummy_hcd dummy_hcd.0: stopped
[    9.515399] dummy_hcd dummy_hcd.0: USB bus 1 deregistered
[    9.515898] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    9.516617] dummy_hcd dummy_hcd.0: Dummy host controller
[    9.517174] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    9.517949] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    9.518593] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    9.519301] usb usb1: Product: Dummy host controller
[    9.519817] usb usb1: Manufacturer: Linux 4.14.0-13292-g1d3b78b dummy_hcd
[    9.520493] usb usb1: SerialNumber: dummy_hcd.0
[    9.521224] hub 1-0:1.0: USB hub found
[    9.521622] hub 1-0:1.0: 1 port detected
[    9.522082] hub 1-0:1.0: USB hub found
[    9.522470] hub 1-0:1.0: 1 port detected
[    9.523101] hub 1-0:1.0: USB hub found
[    9.523489] hub 1-0:1.0: 1 port detected
[    9.523935] hub 1-0:1.0: USB hub found
[    9.524344] hub 1-0:1.0: 1 port detected
[    9.525278] udc dummy_udc.0: releasing 'dummy_udc.0'
[    9.526007] userial_init: registered 4 ttyGS* devices
[    9.526554] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    9.528114] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.528773] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.573811] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2
[    9.575958] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input3
[    9.576929] rtc_cmos 00:00: RTC can wake from S4
[    9.577824] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    9.578505] rtc_cmos 00:00: alarms up to one day, y3k, 114 bytes nvram, =
hpet irqs
[    9.579353] rtc_cmos 00:00: RTC can wake from S4
[    9.579974] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc1
[    9.580712] rtc_cmos 00:00: alarms up to one day, y3k, 114 bytes nvram, =
hpet irqs
[    9.581848] rtc-test rtc-test.0: rtc core: registered test as rtc2
[    9.582479] rtc-test rtc-test.0: rtc core: registered test as rtc2
[    9.583162] rtc-test rtc-test.1: rtc core: registered test as rtc3
[    9.583779] rtc-test rtc-test.1: rtc core: registered test as rtc3
[    9.584509] i2c /dev entries driver
[    9.585041] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[   10.061290] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[   10.540384] usbcore: registered new interface driver i2c-diolan-u2c
[   10.541007] i2c-parport-light: adapter type unspecified
[   10.541510] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[   10.542304] usbcore: registered new interface driver i2c-tiny-usb
[   10.542895] isa i2c-pca-isa.0: Please specify I/O base
[   10.544579] radio-aztech.0: Initialized radio card Aztech Radio on port =
0x350
[   10.545470] : Removed radio card Aztech Radio
[   10.546345] radio-aztech.0: Initialized radio card Aztech Radio on port =
0x350
[   10.547296] radio-typhoon.0: Initialized radio card Typhoon Radio on por=
t 0x316
[   10.548117] : Removed radio card Typhoon Radio
[   10.548751] radio-typhoon.0: Initialized radio card Typhoon Radio on por=
t 0x316
[   10.549757] radio-terratec.0: Initialized radio card TerraTec ActiveRadi=
o on port 0x590
[   10.550681] : Removed radio card TerraTec ActiveRadio
[   10.551444] radio-terratec.0: Initialized radio card TerraTec ActiveRadi=
o on port 0x590
[   10.552262] usbcore: registered new interface driver radioshark
[   10.552841] usbcore: registered new interface driver radioshark2
[   12.653189] rcu-perf: rcu_perf_writer 0 has 100 measurements
[   12.653198] rcu-perf: rcu_perf_writer 1 has 100 measurements
[   12.760043] rcu-perf: Test complete
[   12.760473] rcu-perf:!!! All grace periods expedited, no normal ones to =
measure!
[   12.761204] rcu-torture: Stopping rcu_perf_writer task
[   12.761778] rcu-torture: Stopping rcu_perf_writer
[   12.762317] rcu-perf: writer 0 gps: 100
[   12.762718] rcu-torture: Stopping rcu_perf_writer task
[   12.763224] rcu-torture: Stopping rcu_perf_writer
[   12.763670] rcu-perf: writer 1 gps: 102
[   12.764041] rcu-perf: start: 12650036888 end: 12653142994 duration: 3106=
106 gps: 202 batches: 0
[   12.764856] rcu-perf:    0 writer-duration:     0 88698
[   12.780050] rcu-perf:    0 writer-duration:     1 35843
[   12.780570] rcu-perf:    0 writer-duration:     2 108438
[   12.781062] rcu-perf:    0 writer-duration:     3 24022
[   12.781557] rcu-perf:    0 writer-duration:     4 22688
[   12.782059] rcu-perf:    0 writer-duration:     5 43292
[   12.782532] rcu-perf:    0 writer-duration:     6 27009
[   12.783034] rcu-perf:    0 writer-duration:     7 19430
[   12.783510] rcu-perf:    0 writer-duration:     8 39965
[   12.784004] rcu-perf:    0 writer-duration:     9 24738
[   12.784504] rcu-perf:    0 writer-duration:    10 19326
[   12.784983] rcu-perf:    0 writer-duration:    11 39655
[   12.785476] rcu-perf:    0 writer-duration:    12 24553
[   12.785977] rcu-perf:    0 writer-duration:    13 19184
[   12.786466] rcu-perf:    0 writer-duration:    14 39386
[   12.786992] rcu-perf:    0 writer-duration:    15 26461
[   12.787464] rcu-perf:    0 writer-duration:    16 28134
[   12.787938] rcu-perf:    0 writer-duration:    17 27438
[   12.788449] rcu-perf:    0 writer-duration:    18 20480
[   12.788923] rcu-perf:    0 writer-duration:    19 68062
[   12.789393] rcu-perf:    0 writer-duration:    20 25922
[   12.789889] rcu-perf:    0 writer-duration:    21 20424
[   12.790417] rcu-perf:    0 writer-duration:    22 41337
[   12.790924] rcu-perf:    0 writer-duration:    23 25223
[   12.791401] rcu-perf:    0 writer-duration:    24 19362
[   12.791881] rcu-perf:    0 writer-duration:    25 40878
[   12.792393] rcu-perf:    0 writer-duration:    26 25325
[   12.792896] rcu-perf:    0 writer-duration:    27 19640
[   12.793383] rcu-perf:    0 writer-duration:    28 40424
[   12.793858] rcu-perf:    0 writer-duration:    29 25243
[   12.794329] rcu-perf:    0 writer-duration:    30 35085
[   12.794841] rcu-perf:    0 writer-duration:    31 39880
[   12.795310] rcu-perf:    0 writer-duration:    32 24325
[   12.795784] rcu-perf:    0 writer-duration:    33 18680
[   12.796278] rcu-perf:    0 writer-duration:    34 39316
[   12.796769] rcu-perf:    0 writer-duration:    35 24212
[   12.797237] rcu-perf:    0 writer-duration:    36 18745
[   12.797754] rcu-perf:    0 writer-duration:    37 39205
[   12.798222] rcu-perf:    0 writer-duration:    38 24285
[   12.798696] rcu-perf:    0 writer-duration:    39 18542
[   12.799212] rcu-perf:    0 writer-duration:    40 39382
[   12.799721] rcu-perf:    0 writer-duration:    41 24108
[   12.800239] rcu-perf:    0 writer-duration:    42 18687
[   12.800740] rcu-perf:    0 writer-duration:    43 39775
[   12.801207] rcu-perf:    0 writer-duration:    44 24401
[   12.801725] rcu-perf:    0 writer-duration:    45 18979
[   12.802199] rcu-perf:    0 writer-duration:    46 39234
[   12.802676] rcu-perf:    0 writer-duration:    47 24381
[   12.803169] rcu-perf:    0 writer-duration:    48 18546
[   12.803639] rcu-perf:    0 writer-duration:    49 39526
[   12.804139] rcu-perf:    0 writer-duration:    50 28881
[   12.804630] rcu-perf:    0 writer-duration:    51 19690
[   12.805105] rcu-perf:    0 writer-duration:    52 39722
[   12.805576] rcu-perf:    0 writer-duration:    53 24183
[   12.806053] rcu-perf:    0 writer-duration:    54 18824
[   12.806524] rcu-perf:    0 writer-duration:    55 39183
[   12.807024] rcu-perf:    0 writer-duration:    56 24326
[   12.807497] rcu-perf:    0 writer-duration:    57 18724
[   12.807971] rcu-perf:    0 writer-duration:    58 39875
[   12.808481] rcu-perf:    0 writer-duration:    59 24585
[   12.808956] rcu-perf:    0 writer-duration:    60 18844
[   12.809451] rcu-perf:    0 writer-duration:    61 38953
[   12.809970] rcu-perf:    0 writer-duration:    62 49631
[   12.810487] rcu-perf:    0 writer-duration:    63 30941
[   12.810994] rcu-perf:    0 writer-duration:    64 40965
[   12.811464] rcu-perf:    0 writer-duration:    65 25908
[   12.811939] rcu-perf:    0 writer-duration:    66 19359
[   12.812448] rcu-perf:    0 writer-duration:    67 40341
[   12.812923] rcu-perf:    0 writer-duration:    68 25098
[   12.813433] rcu-perf:    0 writer-duration:    69 19349
[   12.813914] rcu-perf:    0 writer-duration:    70 40382
[   12.814386] rcu-perf:    0 writer-duration:    71 25220
[   12.814881] rcu-perf:    0 writer-duration:    72 39839
[   12.815350] rcu-perf:    0 writer-duration:    73 37043
[   12.815823] rcu-perf:    0 writer-duration:    74 24594
[   12.816333] rcu-perf:    0 writer-duration:    75 18678
[   12.816819] rcu-perf:    0 writer-duration:    76 39230
[   12.817308] rcu-perf:    0 writer-duration:    77 24214
[   12.817806] rcu-perf:    0 writer-duration:    78 18616
[   12.818279] rcu-perf:    0 writer-duration:    79 39470
[   12.818754] rcu-perf:    0 writer-duration:    80 24502
[   12.819251] rcu-perf:    0 writer-duration:    81 18728
[   12.819743] rcu-perf:    0 writer-duration:    82 39095
[   12.820243] rcu-perf:    0 writer-duration:    83 24259
[   12.820741] rcu-perf:    0 writer-duration:    84 24020
[   12.821213] rcu-perf:    0 writer-duration:    85 39791
[   12.821733] rcu-perf:    0 writer-duration:    86 24555
[   12.822205] rcu-perf:    0 writer-duration:    87 18724
[   12.822680] rcu-perf:    0 writer-duration:    88 39694
[   12.823172] rcu-perf:    0 writer-duration:    89 24618
[   12.823643] rcu-perf:    0 writer-duration:    90 18728
[   12.824139] rcu-perf:    0 writer-duration:    91 39112
[   12.824630] rcu-perf:    0 writer-duration:    92 24467
[   12.825107] rcu-perf:    0 writer-duration:    93 18688
[   12.825578] rcu-perf:    0 writer-duration:    94 39090
[   12.826051] rcu-perf:    0 writer-duration:    95 24255
[   12.826541] rcu-perf:    0 writer-duration:    96 18762
[   12.827063] rcu-perf:    0 writer-duration:    97 54955
[   12.827537] rcu-perf:    0 writer-duration:    98 25120
[   12.828030] rcu-perf:    0 writer-duration:    99 19470
[   12.828525] rcu-perf:    0 writer-duration:   100 40750
[   12.840056] rcu-perf:    1 writer-duration:     0 116465
[   12.860043] rcu-perf:    1 writer-duration:     1 88424
[   12.860555] rcu-perf:    1 writer-duration:     2 27910
[   12.861037] rcu-perf:    1 writer-duration:     3 42102
[   12.861531] rcu-perf:    1 writer-duration:     4 26318
[   12.862033] rcu-perf:    1 writer-duration:     5 21367
[   12.862505] rcu-perf:    1 writer-duration:     6 42095
[   12.863008] rcu-perf:    1 writer-duration:     7 24864
[   12.863475] rcu-perf:    1 writer-duration:     8 19294
[   12.863977] rcu-perf:    1 writer-duration:     9 39728
[   12.864473] rcu-perf:    1 writer-duration:    10 24699
[   12.864948] rcu-perf:    1 writer-duration:    11 19106
[   12.865446] rcu-perf:    1 writer-duration:    12 39618
[   12.865942] rcu-perf:    1 writer-duration:    13 24511
[   12.866432] rcu-perf:    1 writer-duration:    14 34015
[   12.866947] rcu-perf:    1 writer-duration:    15 26341
[   12.867417] rcu-perf:    1 writer-duration:    16 57206
[   12.867898] rcu-perf:    1 writer-duration:    17 25197
[   12.868407] rcu-perf:    1 writer-duration:    18 50547
[   12.868882] rcu-perf:    1 writer-duration:    19 38762
[   12.869370] rcu-perf:    1 writer-duration:    20 25782
[   12.869889] rcu-perf:    1 writer-duration:    21 19616
[   12.870399] rcu-perf:    1 writer-duration:    22 40498
[   12.870905] rcu-perf:    1 writer-duration:    23 25380
[   12.871376] rcu-perf:    1 writer-duration:    24 19549
[   12.871851] rcu-perf:    1 writer-duration:    25 40624
[   12.872372] rcu-perf:    1 writer-duration:    26 25147
[   12.872850] rcu-perf:    1 writer-duration:    27 19500
[   12.873322] rcu-perf:    1 writer-duration:    28 41005
[   12.873799] rcu-perf:    1 writer-duration:    29 40312
[   12.874272] rcu-perf:    1 writer-duration:    30 18770
[   12.874749] rcu-perf:    1 writer-duration:    31 39090
[   12.875252] rcu-perf:    1 writer-duration:    32 24422
[   12.875730] rcu-perf:    1 writer-duration:    33 18924
[   12.876225] rcu-perf:    1 writer-duration:    34 38986
[   12.876720] rcu-perf:    1 writer-duration:    35 24289
[   12.877193] rcu-perf:    1 writer-duration:    36 18837
[   12.877671] rcu-perf:    1 writer-duration:    37 38973
[   12.878146] rcu-perf:    1 writer-duration:    38 24363
[   12.878617] rcu-perf:    1 writer-duration:    39 18993
[   12.879116] rcu-perf:    1 writer-duration:    40 38691
[   12.879589] rcu-perf:    1 writer-duration:    41 24836
[   12.880104] rcu-perf:    1 writer-duration:    42 18834
[   12.880599] rcu-perf:    1 writer-duration:    43 39417
[   12.881071] rcu-perf:    1 writer-duration:    44 24390
[   12.881566] rcu-perf:    1 writer-duration:    45 18848
[   12.882058] rcu-perf:    1 writer-duration:    46 39029
[   12.882525] rcu-perf:    1 writer-duration:    47 24461
[   12.883042] rcu-perf:    1 writer-duration:    48 18844
[   12.883546] rcu-perf:    1 writer-duration:    49 44870
[   12.884042] rcu-perf:    1 writer-duration:    50 24605
[   12.884536] rcu-perf:    1 writer-duration:    51 18923
[   12.885012] rcu-perf:    1 writer-duration:    52 39144
[   12.885505] rcu-perf:    1 writer-duration:    53 24370
[   12.886006] rcu-perf:    1 writer-duration:    54 18703
[   12.886478] rcu-perf:    1 writer-duration:    55 39065
[   12.886974] rcu-perf:    1 writer-duration:    56 24837
[   12.887446] rcu-perf:    1 writer-duration:    57 18891
[   12.887918] rcu-perf:    1 writer-duration:    58 39501
[   12.888427] rcu-perf:    1 writer-duration:    59 24061
[   12.888901] rcu-perf:    1 writer-duration:    60 18870
[   12.889369] rcu-perf:    1 writer-duration:    61 76502
[   12.889863] rcu-perf:    1 writer-duration:    62 25068
[   12.890371] rcu-perf:    1 writer-duration:    63 20055
[   12.890880] rcu-perf:    1 writer-duration:    64 41388
[   12.891355] rcu-perf:    1 writer-duration:    65 24881
[   12.891834] rcu-perf:    1 writer-duration:    66 19359
[   12.892349] rcu-perf:    1 writer-duration:    67 40535
[   12.892825] rcu-perf:    1 writer-duration:    68 24935
[   12.893324] rcu-perf:    1 writer-duration:    69 19494
[   12.893845] rcu-perf:    1 writer-duration:    70 57418
[   12.894341] rcu-perf:    1 writer-duration:    71 25143
[   12.894840] rcu-perf:    1 writer-duration:    72 19306
[   12.895318] rcu-perf:    1 writer-duration:    73 39438
[   12.895797] rcu-perf:    1 writer-duration:    74 24232
[   12.896298] rcu-perf:    1 writer-duration:    75 18951
[   12.896792] rcu-perf:    1 writer-duration:    76 38996
[   12.897281] rcu-perf:    1 writer-duration:    77 24321
[   12.897784] rcu-perf:    1 writer-duration:    78 18932
[   12.898259] rcu-perf:    1 writer-duration:    79 39267
[   12.898737] rcu-perf:    1 writer-duration:    80 24285
[   12.899237] rcu-perf:    1 writer-duration:    81 18768
[   12.899732] rcu-perf:    1 writer-duration:    82 43864
[   12.900228] rcu-perf:    1 writer-duration:    83 24859
[   12.900724] rcu-perf:    1 writer-duration:    84 19290
[   12.901198] rcu-perf:    1 writer-duration:    85 39457
[   12.901675] rcu-perf:    1 writer-duration:    86 24452
[   12.902144] rcu-perf:    1 writer-duration:    87 19147
[   12.902615] rcu-perf:    1 writer-duration:    88 39452
[   12.903110] rcu-perf:    1 writer-duration:    89 24289
[   12.903585] rcu-perf:    1 writer-duration:    90 18643
[   12.904083] rcu-perf:    1 writer-duration:    91 39223
[   12.904577] rcu-perf:    1 writer-duration:    92 24245
[   12.905050] rcu-perf:    1 writer-duration:    93 18825
[   12.905545] rcu-perf:    1 writer-duration:    94 39094
[   12.906042] rcu-perf:    1 writer-duration:    95 24316
[   12.906531] rcu-perf:    1 writer-duration:    96 34521
[   12.907057] rcu-perf:    1 writer-duration:    97 40728
[   12.907530] rcu-perf:    1 writer-duration:    98 25303
[   12.908024] rcu-perf:    1 writer-duration:    99 19400
[   12.908521] rcu-perf:    1 writer-duration:   100 43259
[   12.920044] rcu-perf:    1 writer-duration:   101 690739
[   12.920566] rcu-perf:    1 writer-duration:   102 556061
[   13.600625] radio-aimslab.0: Initialized radio card AIMSlab RadioTrack/R=
adioReveal on port 0x30f
[   13.601664] : Removed radio card AIMSlab RadioTrack/RadioReveal
[   16.640639] radio-aimslab.0: Initialized radio card AIMSlab RadioTrack/R=
adioReveal on port 0x30f
[   16.641593] BUG: unable to handle kernel NULL pointer dereference at 000=
0000c
[   16.642301] IP: isa_bus_shutdown+0x6/0x20
[   16.642666] *pde =3D 00000000=20
[   16.642964] Oops: 0000 [#1] PREEMPT SMP
[   16.643337] CPU: 1 PID: 43 Comm: rcu_perf_shutdo Tainted: G S           =
    4.14.0-13292-g1d3b78b #1
[   16.644234] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.10.2-1 04/01/2014
[   16.645047] task: 4017a000 task.stack: 4032a000
[   16.645448] EIP: isa_bus_shutdown+0x6/0x20
[   16.645819] EFLAGS: 00210246 CPU: 1
[   16.646131] EAX: 4e7bfa00 EBX: 4e7bfa0c ECX: 4017a5e8 EDX: 00000000
[   16.646746] ESI: 43063440 EDI: 4e7bfa00 EBP: 4032bf68 ESP: 4032bf54
[   16.647363]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   16.647845] CR0: 80050033 CR2: 0000000c CR3: 03238000 CR4: 00000690
[   16.648468] Call Trace:
[   16.648715]  ? device_shutdown+0xd3/0x1a0
[   16.649092]  ? kernel_power_off+0x2d/0x60
[   16.649489]  ? rcu_perf_shutdown+0xa0/0xb0
[   16.649885]  ? print_dl_stats+0x20/0x20
[   16.650024]  ? kthread+0x101/0x130
[   16.650024]  ? rcu_perf_cleanup+0x320/0x320
[   16.650024]  ? kthread_delayed_work_timer_fn+0xa0/0xa0
[   16.650024]  ? ret_from_fork+0x19/0x30
[   16.650024] Code: 74 13 55 89 e5 8b 90 80 01 00 00 ff d1 5d c3 8d b6 00 =
00 00 00 31 c0 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 8b 90 88 00 00 00 =
<8b> 4a 0c 85 c9 74 0c 55 89 e5 8b 90 80 01 00 00 ff d1 5d c3 8d
[   16.650024] EIP: isa_bus_shutdown+0x6/0x20 SS:ESP: 0068:4032bf54
[   16.650024] CR2: 000000000000000c
[   16.650024] ---[ end trace 07ea2d1affc54db9 ]---
[   16.650024] Kernel panic - not syncing: Fatal exception
[   16.650024] Kernel Offset: disabled

Elapsed time: 20

#!/bin/bash

# To reproduce,
# 1) save job-script and this script (both are attached in 0day report emai=
l)
# 2) run this script with your compiled kernel and optional env $INSTALL_MO=
D_PATH

kernel=3D$1

initrds=3D(
	/osimage/yocto/yocto-tiny-i386-2016-04-22.cgz
	/lkp/lkp/lkp-i386.cgz
	/osimage/deps/debian-x86_64-2016-08-31.cgz/run-ipconfig.i386_2016-09-03.cgz
	/osimage/pkg/debian-x86_64-2016-08-31.cgz/trinity-static-i386-x86_64-6ddab=
fd2_2017-11-10.cgz
)

HTTP_PREFIX=3Dhttps://github.com/0day-ci/lkp-qemu/raw/master
wget --timestamping "${initrds[@]/#/$HTTP_PREFIX}"

{
	cat "${initrds[@]//*\//}"
	[[ $INSTALL_MOD_PATH ]] && (
		cd "$INSTALL_MOD_PATH"
		find lib | cpio -o -H newc --quiet | gzip
	)
	echo  job-script | cpio -o -H newc --quiet | gzip
} > initrd.img

qemu-img create -f qcow2 disk-vm-ivb41-yocto-i386-1-0 256G

kvm=3D(
	qemu-system-i386
	-enable-kvm
	-kernel $kernel
	-initrd initrd.img
	-m 320
	-smp 2
	-device e1000,netdev=3Dnet0
	-netdev user,id=3Dnet0
	-boot order=3Dnc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=3Dlocaltime
	-drive file=3Ddisk-vm-ivb41-yocto-i386-1-0,media=3Ddisk,if=3Dvirtio
	-serial stdio
	-display none
	-monitor null
)

append=3D(
	ip=3D::::vm-ivb41-yocto-i386-1::dhcp
	root=3D/dev/ram0
	user=3Dlkp
	job=3D/job-script
	ARCH=3Di386
	kconfig=3Di386-randconfig-sb0-11100832
	branch=3Dlinus/master
	commit=3D1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c
	BOOT_IMAGE=3D/pkg/linux/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983f=
abb3fbf91b76339bf66e4a12c/vmlinuz-4.14.0-13292-g1d3b78b
	max_uptime=3D1500
	RESULT_ROOT=3D/result/trinity/300s/vm-ivb41-yocto-i386/yocto-tiny-i386-201=
6-04-22.cgz/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b763=
39bf66e4a12c/1
	result_service=3Dtmpfs
	debug
	apic=3Ddebug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=3D100
	net.ifnames=3D0
	printk.devkmsg=3Don
	panic=3D-1
	softlockup_panic=3D1
	nmi_watchdog=3Dpanic
	oops=3Dpanic
	load_ramdisk=3D2
	prompt_ramdisk=3D0
	drbd.minor_count=3D8
	systemd.log_level=3Derr
	ignore_loglevel
	console=3Dtty0
	earlyprintk=3DttyS0,115200
	console=3DttyS0,115200
	vga=3Dnormal
	rw
	drbd.minor_count=3D8
)

"${kvm[@]}" -append "${append[*]}"

--ntbecuc2mtdmjztx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 4.14.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_BITS_MAX=16
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=2
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_CPU_ISOLATION is not set

#
# RCU Subsystem
#
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_BPF is not set
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
# CONFIG_MEMBARRIER is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
# CONFIG_USERFAULTFD is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
CONFIG_SLUB_MEMCG_SYSFS_ON=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
# CONFIG_PROFILING is not set
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_STATIC_KEYS_SELFTEST=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_THIN_ARCHIVES=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
# CONFIG_HAVE_ARCH_HASH is not set
CONFIG_ISA_BUS_API=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
# CONFIG_HAVE_ARCH_VMAP_STACK is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
# CONFIG_REFCOUNT_FULL is not set

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_ZONED=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y
# CONFIG_BLK_WBT is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
# CONFIG_MQ_IOSCHED_DEADLINE is not set
# CONFIG_MQ_IOSCHED_KYBER is not set
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
CONFIG_GOLDFISH=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
CONFIG_IOSF_MBI_DEBUG=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_QUEUED_LOCK_STAT is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_M486=y
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_L1_CACHE_SHIFT=4
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_F00F_BUG=y
CONFIG_X86_INVD_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_AMD_POWER=y
# CONFIG_X86_LEGACY_VM86 is not set
# CONFIG_VM86 is not set
# CONFIG_X86_16BIT is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_GENERIC_GUP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_ARCH_WANTS_THP_SWAP is not set
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_IDLE_PAGE_TRACKING is not set
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_CPUFREQ_DT=y
CONFIG_CPUFREQ_DT_PLATDEV=y
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
# CONFIG_PCIE_DPC is not set
CONFIG_PCIE_PTM=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# DesignWare PCI Core Support
#
CONFIG_PCIE_DW=y
CONFIG_PCIE_DW_HOST=y
CONFIG_PCIE_DW_PLAT=y

#
# PCI host controller drivers
#

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_I82365=y
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_COMPAT_32=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
# CONFIG_SMC is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INET_RAW_DIAG=y
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_MEDIA_IB=y
# CONFIG_TIPC_MEDIA_UDP is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
# CONFIG_L2TP_ETH is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
# CONFIG_IEEE802154_SOCKET is not set
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BATMAN_V is not set
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUGFS is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_DIAG=y
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=y
CONFIG_NET_NSH=y
CONFIG_HSR=y
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
CONFIG_NET_NCSI=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_VXCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_CAN_GRCAN is not set
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
# CONFIG_CAN_CC770_PLATFORM is not set
CONFIG_CAN_IFI_CANFD=y
CONFIG_CAN_M_CAN=y
CONFIG_CAN_PEAK_PCIEFD=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=y
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_8DEV_USB=y
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_BT=y
# CONFIG_BT_BREDR is not set
CONFIG_BT_LE=y
CONFIG_BT_LEDS=y
CONFIG_BT_SELFTEST=y
CONFIG_BT_SELFTEST_ECDH=y
CONFIG_BT_SELFTEST_SMP=y
# CONFIG_BT_DEBUGFS is not set

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=y
CONFIG_BT_RTL=y
CONFIG_BT_QCA=y
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIBTUSB_BCM is not set
CONFIG_BT_HCIBTUSB_RTL=y
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_3WIRE=y
# CONFIG_BT_HCIUART_INTEL is not set
CONFIG_BT_HCIUART_QCA=y
CONFIG_BT_HCIUART_AG6XX=y
# CONFIG_BT_HCIUART_MRVL is not set
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_ATH3K=y
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_INJECT_LOSS=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_AF_KCM=y
CONFIG_STREAM_PARSER=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_UART=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PORT100 is not set
# CONFIG_NFC_FDP is not set
CONFIG_NFC_PN533=y
CONFIG_NFC_PN533_USB=y
# CONFIG_NFC_PN533_I2C is not set
CONFIG_NFC_MRVL=y
CONFIG_NFC_MRVL_USB=y
CONFIG_NFC_MRVL_UART=y
CONFIG_NFC_MRVL_I2C=y
# CONFIG_NFC_ST_NCI_I2C is not set
# CONFIG_NFC_NXP_NCI is not set
CONFIG_NFC_S3FWRN5=y
CONFIG_NFC_S3FWRN5_I2C=y
# CONFIG_PSAMPLE is not set
CONFIG_NET_IFE=y
# CONFIG_LWTUNNEL is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPMI=y
CONFIG_REGMAP_W1=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# Partition parsers
#

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_PHYSMAP_OF is not set
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_DT=y
# CONFIG_MTD_NAND_GPIO is not set
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
# CONFIG_MTD_MT81xx_NOR is not set
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
# CONFIG_SPI_INTEL_SPI_PCI is not set
# CONFIG_SPI_INTEL_SPI_PLATFORM is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_DTC=y
CONFIG_OF=y
CONFIG_OF_UNITTEST=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_KOBJ=y
# CONFIG_OF_DYNAMIC is not set
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_RESOLVE=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_NVME_MULTIPATH is not set
CONFIG_NVME_FABRICS=y
CONFIG_NVME_RDMA=y
# CONFIG_NVME_FC is not set
CONFIG_NVME_TARGET=y
CONFIG_NVME_TARGET_LOOP=y
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_PCI_ENDPOINT_TEST=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#

#
# SCIF Bus Driver
#

#
# VOP Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
# CONFIG_CXL_LIB is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
# CONFIG_SCSI_AHA1740 is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_SMARTPQI=y
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
CONFIG_SCSI_UFS_DWC_TC_PLATFORM=y
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_FLASHPOINT=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_SNIC=y
# CONFIG_SCSI_SNIC_DEBUG_FS is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_CHELSIO_FCOE=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_AHCI_CEVA=y
CONFIG_AHCI_QORIQ=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
# CONFIG_MD_CLUSTER is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_ARCNET_COM20020_CS=y
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=y
CONFIG_3C515=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
# CONFIG_NET_VENDOR_ALACRITECH is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_ALTERA_TSE=y
# CONFIG_NET_VENDOR_AMAZON is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_AURORA=y
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_CADENCE=y
CONFIG_MACB=y
CONFIG_MACB_USE_HWSTAMP=y
CONFIG_MACB_PCI=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BCMGENET=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_TIGON3_HWMON=y
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=y
# CONFIG_BNXT_SRIOV is not set
# CONFIG_BNXT_FLOWER_OFFLOAD is not set
CONFIG_BNXT_DCB=y
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_CX_ECAT=y
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
# CONFIG_EZCHIP_NPS_MANAGEMENT_ENET is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_HINIC=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
# CONFIG_IGB_HWMON is not set
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
CONFIG_IXGBE=y
# CONFIG_IXGBE_HWMON is not set
CONFIG_IXGBE_DCB=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
CONFIG_I40EVF=y
CONFIG_FM10K=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
CONFIG_MLX4_CORE_GEN2=y
# CONFIG_MLX5_CORE is not set
CONFIG_MLXSW_CORE=y
CONFIG_MLXSW_CORE_HWMON=y
# CONFIG_MLXSW_CORE_THERMAL is not set
CONFIG_MLXSW_PCI=y
CONFIG_MLXSW_I2C=y
CONFIG_MLXSW_SWITCHIB=y
# CONFIG_MLXSW_SWITCHX2 is not set
CONFIG_MLXSW_MINIMAL=y
CONFIG_MLXFW=y
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NFP=y
# CONFIG_NFP_APP_FLOWER is not set
CONFIG_NFP_DEBUG=y
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_ROCKER is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_NET_VENDOR_SOLARFLARE is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_ALE is not set
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_BCM_UNIMAC=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_BUS_MUX_GPIO is not set
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
# CONFIG_MDIO_GPIO is not set
CONFIG_MDIO_HISI_FEMAC=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
CONFIG_LED_TRIGGER_PHY=y

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=y
CONFIG_AQUANTIA_PHY=y
CONFIG_AT803X_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_BCM_NET_PHYLIB=y
CONFIG_BROADCOM_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_DP83822_PHY is not set
CONFIG_DP83848_PHY=y
CONFIG_DP83867_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_INTEL_XWAY_PHY=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_MARVELL_10G_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_MICROCHIP_PHY=y
CONFIG_MICROSEMI_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_TERANETICS_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_XILINX_GMII2RGMII=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOATM is not set
CONFIG_PPPOE=y
CONFIG_PPTP=y
CONFIG_PPPOL2TP=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_LAN78XX=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SR9700=y
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_IPHETH=y
# CONFIG_USB_SIERRA_NET is not set
CONFIG_USB_VL600=y
CONFIG_USB_NET_CH9200=y
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_THUNDERBOLT_NET is not set
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_SERIO_APBPS2 is not set
# CONFIG_SERIO_OLPC_APSP is not set
CONFIG_SERIO_GPIO_PS2=y
CONFIG_USERIO=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_GOLDFISH_TTY=y
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_FINTEK=y
CONFIG_SERIAL_8250_CONSOLE=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_EXAR is not set
# CONFIG_SERIAL_8250_CS is not set
# CONFIG_SERIAL_8250_MEN_MCB is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_ASPEED_VUART is not set
# CONFIG_SERIAL_8250_FSL is not set
CONFIG_SERIAL_8250_DW=y
CONFIG_SERIAL_8250_RT288X=y
# CONFIG_SERIAL_8250_LPSS is not set
# CONFIG_SERIAL_8250_MID is not set
CONFIG_SERIAL_8250_MOXA=y
CONFIG_SERIAL_OF_PLATFORM=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_UARTLITE_NR_UARTS=1
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_CONEXANT_DIGICOLOR=y
CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE=y
CONFIG_SERIAL_MEN_Z135=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PROC_INTERFACE=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_SCR24X=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_CRB is not set
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
CONFIG_TELCLOCK=y
# CONFIG_DEVPORT is not set
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=y
# CONFIG_XILLYBUS_OF is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_GPMUX=y
CONFIG_I2C_MUX_LTC4306=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_MUX_REG=y
CONFIG_I2C_MUX_MLXCPLD=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_EMEV2=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RK3X=y
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SLAVE=y
# CONFIG_I2C_SLAVE_EEPROM is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
# CONFIG_PINCTRL is not set
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
CONFIG_GPIO_ALTERA=y
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_AXP209=y
# CONFIG_GPIO_DWAPB is not set
CONFIG_GPIO_FTGPIO010=y
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_GRGPIO is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_MB86S7X is not set
CONFIG_GPIO_MENZ127=y
# CONFIG_GPIO_MOCKUP is not set
CONFIG_GPIO_SYSCON=y
CONFIG_GPIO_VX855=y
CONFIG_GPIO_XILINX=y

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_IT87=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_WS16C48 is not set

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_BD9571MWV=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_KEMPLD=y
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS65218=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_PCI_IDIO_16=y
CONFIG_GPIO_RDC321X=y
CONFIG_GPIO_SODAVILLE=y

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2405 is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2406 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2805=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2438=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_DS28E17 is not set
CONFIG_POWER_AVS=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_LEGO_EV3 is not set
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_CHARGER_DA9150=y
CONFIG_BATTERY_DA9150=y
CONFIG_CHARGER_AXP20X=y
CONFIG_BATTERY_AXP20X=y
CONFIG_AXP20X_POWER=y
CONFIG_AXP288_CHARGER=y
CONFIG_AXP288_FUEL_GAUGE=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_BATTERY_MAX1721X=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_LP8788 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_LTC3651 is not set
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_DETECTOR_MAX14656 is not set
# CONFIG_CHARGER_MAX77693 is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24257=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_CHARGER_RT9455=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ASPEED=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DELL_SMM=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_I5500=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC2990=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6621 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_MENF21BMC_HWMON is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT7802 is not set
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_PWM_FAN=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHT3x is not set
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_INA3221=y
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP108=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_OF is not set
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_POWER_ALLOCATOR=y
# CONFIG_CLOCK_THERMAL is not set
CONFIG_DEVFREQ_THERMAL=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_DA9062_THERMAL is not set
# CONFIG_X86_PKG_TEMP_THERMAL is not set
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# CONFIG_INTEL_PCH_THERMAL is not set
CONFIG_QCOM_SPMI_TEMP_ALARM=y
# CONFIG_GENERIC_ADC_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_PCI=y
# CONFIG_BCMA_SFLASH is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_ACT8945A is not set
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_ATMEL_FLEXCOM=y
# CONFIG_MFD_ATMEL_HLCDC is not set
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_BD9571MWV=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_DA9150=y
# CONFIG_MFD_DLN2 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_MFD_HI6421_PMIC is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77620 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6397=y
CONFIG_MFD_MENF21BMC=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_RK808=y
# CONFIG_MFD_RN5T618 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SKY81452=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_TI_LMU=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS68470 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TI_LP87565 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_REGULATOR_AXP20X is not set
# CONFIG_REGULATOR_BD9571MWV is not set
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9062=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LM363X=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_MT6311=y
# CONFIG_REGULATOR_MT6323 is not set
# CONFIG_REGULATOR_MT6397 is not set
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_PV88060 is not set
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_PWM is not set
CONFIG_REGULATOR_QCOM_SPMI=y
CONFIG_REGULATOR_RK808=y
# CONFIG_REGULATOR_SKY81452 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65086 is not set
# CONFIG_REGULATOR_TPS65132 is not set
CONFIG_REGULATOR_TPS65218=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_VCTRL=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_FWNODE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
CONFIG_USB_DSBR=y
CONFIG_RADIO_MAXIRADIO=y
CONFIG_RADIO_SHARK=y
CONFIG_RADIO_SHARK2=y
CONFIG_USB_KEENE=y
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_TIMBERDALE is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_V4L_RADIO_ISA_DRIVERS=y
CONFIG_RADIO_ISA=y
# CONFIG_RADIO_CADET is not set
CONFIG_RADIO_RTRACK=y
CONFIG_RADIO_RTRACK_PORT=30f
# CONFIG_RADIO_RTRACK2 is not set
CONFIG_RADIO_AZTECH=y
CONFIG_RADIO_AZTECH_PORT=350
CONFIG_RADIO_GEMTEK=y
CONFIG_RADIO_GEMTEK_PORT=34c
# CONFIG_RADIO_GEMTEK_PROBE is not set
# CONFIG_RADIO_SF16FMI is not set
# CONFIG_RADIO_SF16FMR2 is not set
CONFIG_RADIO_TERRATEC=y
CONFIG_RADIO_TRUST=y
CONFIG_RADIO_TRUST_PORT=350
CONFIG_RADIO_TYPHOON=y
CONFIG_RADIO_TYPHOON_PORT=316
CONFIG_RADIO_TYPHOON_MUTEFREQ=87500
CONFIG_RADIO_ZOLTRIX=y
CONFIG_RADIO_ZOLTRIX_PORT=20c
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
# CONFIG_VIDEO_IR_I2C is not set

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS3308=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=y
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9M111=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#

#
# SPI helper chips
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88RS6000T=y
CONFIG_MEDIA_TUNER_TUA9001=y
# CONFIG_MEDIA_TUNER_SI2157 is not set
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y
# CONFIG_MEDIA_TUNER_MXL301RF is not set
# CONFIG_MEDIA_TUNER_QM1D1C0042 is not set

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
CONFIG_DRM_DEBUG_MM=y
# CONFIG_DRM_DEBUG_MM_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_FBDEV_EMULATION is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y
CONFIG_DRM_GEM_CMA_HELPER=y
CONFIG_DRM_KMS_CMA_HELPER=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_AMDGPU=y
CONFIG_DRM_AMDGPU_SI=y
# CONFIG_DRM_AMDGPU_CIK is not set
CONFIG_DRM_AMDGPU_USERPTR=y
CONFIG_DRM_AMDGPU_GART_DEBUGFS=y

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_AMD_ACP is not set

#
# Display Engine Configuration
#
CONFIG_DRM_AMD_DC=y
# CONFIG_DRM_AMD_DC_PRE_VEGA is not set
# CONFIG_DRM_AMD_DC_FBC is not set
# CONFIG_DRM_AMD_DC_DCN1_0 is not set
# CONFIG_DEBUG_KERNEL_DC is not set

#
# AMD Library routines
#
CONFIG_CHASH=y
# CONFIG_CHASH_STATS is not set
# CONFIG_CHASH_SELFTEST is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_ALPHA_SUPPORT=y
# CONFIG_DRM_I915_CAPTURE_ERROR is not set
# CONFIG_DRM_I915_USERPTR is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
CONFIG_DRM_I915_SELFTEST=y
CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS=y
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_VGEM is not set
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_RCAR_DW_HDMI is not set
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_PANEL_LVDS=y
CONFIG_DRM_PANEL_SIMPLE=y
CONFIG_DRM_PANEL_INNOLUX_P079ZCA=y
CONFIG_DRM_PANEL_JDI_LT070ME05000=y
# CONFIG_DRM_PANEL_ORISETECH_OTM8009A is not set
CONFIG_DRM_PANEL_PANASONIC_VVX10F034N00=y
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
CONFIG_DRM_PANEL_SAMSUNG_S6E3HA2=y
# CONFIG_DRM_PANEL_SAMSUNG_S6E63J0X03 is not set
# CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0 is not set
# CONFIG_DRM_PANEL_SEIKO_43WVF1G is not set
CONFIG_DRM_PANEL_SHARP_LQ101R1SX01=y
CONFIG_DRM_PANEL_SHARP_LS043T1LE01=y
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
CONFIG_DRM_DUMB_VGA_DAC=y
CONFIG_DRM_LVDS_ENCODER=y
# CONFIG_DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW is not set
CONFIG_DRM_NXP_PTN3460=y
CONFIG_DRM_PARADE_PS8622=y
CONFIG_DRM_SIL_SII8620=y
CONFIG_DRM_SII902X=y
# CONFIG_DRM_SII9234 is not set
CONFIG_DRM_TOSHIBA_TC358767=y
CONFIG_DRM_TI_TFP410=y
# CONFIG_DRM_I2C_ADV7511 is not set
# CONFIG_DRM_ARCPGU is not set
# CONFIG_DRM_HISI_HIBMC is not set
CONFIG_DRM_MXS=y
CONFIG_DRM_MXSFB=y
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_LEGACY is not set
# CONFIG_DRM_LIB_RANDOM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
CONFIG_FB_IBM_GXT4500=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
CONFIG_FB_SSD1307=y
CONFIG_FB_SM712=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_PM8941_WLED=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_SKY81452=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_BACKLIGHT_ARCXCNN=y
CONFIG_VGASTATE=y
CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_BETOP_FF=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CORSAIR=y
CONFIG_HID_CMEDIA=y
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_GT683R=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_ITE is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LED is not set
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_HID_LOGITECH_HIDPP=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MAYFLASH=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTI is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PENMOUNT is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_RETRODE=y
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_UDRAW_PS3 is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=y
CONFIG_HID_ALPS=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=y

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
# CONFIG_USB_DWC2_PERIPHERAL is not set
# CONFIG_USB_DWC2_DUAL_ROLE is not set
CONFIG_USB_DWC2_PCI=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_CHIPIDEA is not set
CONFIG_USB_ISP1760=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1760_HOST_ROLE=y
# CONFIG_USB_ISP1760_GADGET_ROLE is not set
# CONFIG_USB_ISP1760_DUAL_ROLE is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_HSIC_USB4604=y
CONFIG_USB_LINK_LAYER_TEST=y
CONFIG_USB_CHAOSKEY=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_TAHVO_USB=y
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
CONFIG_U_SERIAL_CONSOLE=y

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=y
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=y
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=y
# CONFIG_USB_SNP_UDC_PLAT is not set
CONFIG_USB_M66592=y
CONFIG_USB_BDC_UDC=y

#
# Platform Support
#
CONFIG_USB_BDC_PCI=y
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
CONFIG_USB_GADGET_XILINX=y
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_F_SS_LB=y
CONFIG_USB_U_SERIAL=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_EEM=y
CONFIG_USB_F_MASS_STORAGE=y
CONFIG_USB_F_FS=y
CONFIG_USB_F_HID=y
CONFIG_USB_CONFIGFS=y
# CONFIG_USB_CONFIGFS_SERIAL is not set
CONFIG_USB_CONFIGFS_ACM=y
# CONFIG_USB_CONFIGFS_OBEX is not set
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
CONFIG_USB_CONFIGFS_EEM=y
CONFIG_USB_CONFIGFS_MASS_STORAGE=y
CONFIG_USB_CONFIGFS_F_LB_SS=y
CONFIG_USB_CONFIGFS_F_FS=y
CONFIG_USB_CONFIGFS_F_HID=y
# CONFIG_USB_CONFIGFS_F_UVC is not set
# CONFIG_USB_CONFIGFS_F_PRINTER is not set

#
# USB Power Delivery and Type-C drivers
#
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_ACPI is not set
# CONFIG_TYPEC_TPS6598X is not set
CONFIG_USB_LED_TRIG=y
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_PWRSEQ_EMMC=y
CONFIG_PWRSEQ_SIMPLE=y
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_OF_ARASAN=y
CONFIG_MMC_SDHCI_OF_AT91=y
CONFIG_MMC_SDHCI_CADENCE=y
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
CONFIG_MMC_USDHI6ROL0=y
# CONFIG_MMC_REALTEK_PCI is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
CONFIG_MMC_MTK=y
CONFIG_MMC_SDHCI_XENON=y
# CONFIG_MMC_SDHCI_OMAP is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_BCM6328=y
CONFIG_LEDS_BCM6358=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_MT6323=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_MENF21BMC=y
# CONFIG_LEDS_IS31FL319X is not set
CONFIG_LEDS_IS31FL32XX=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_SYSCON is not set
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_DISK=y
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
# CONFIG_INFINIBAND_EXP_USER_ACCESS is not set
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_I40IW=y
CONFIG_MLX4_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_ISER=y
CONFIG_RDMA_RXE=y
CONFIG_INFINIBAND_BNXT_RE=y
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_AMD76X=y
# CONFIG_EDAC_E7XXX is not set
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_IE31200 is not set
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
# CONFIG_RTC_NVMEM is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_ABB5ZES3 is not set
CONFIG_RTC_DRV_ABX80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1307_HWMON=y
CONFIG_RTC_DRV_DS1307_CENTURY=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_HYM8563=y
# CONFIG_RTC_DRV_LP8788 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RK808=y
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF85063=y
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_PALMAS is not set
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV8803=y

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_DS3232_HWMON=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_DA9055 is not set
# CONFIG_RTC_DRV_DA9063 is not set
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_ZYNQMP=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_SNVS is not set
CONFIG_RTC_DRV_MT6397=y
# CONFIG_RTC_DRV_R7301 is not set

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
CONFIG_ALTERA_MSGDMA=y
# CONFIG_FSL_EDMA is not set
CONFIG_INTEL_IDMA64=y
CONFIG_PCH_DMA=y
CONFIG_TIMB_DMA=y
CONFIG_QCOM_HIDMA_MGMT=y
CONFIG_QCOM_HIDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_PRUSS=y
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_PCI_LEGACY is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_HYPERV_TSCPAGE is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_SMBIOS=y
# CONFIG_DELL_SMBIOS_SMM is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ASUS_WIRELESS is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_CHT_INT33FE is not set
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_VBTN is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_INTEL_PUNIT_IPC=y
# CONFIG_MLX_CPLD_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_GOLDFISH_BUS is not set
# CONFIG_GOLDFISH_PIPE is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_WM831X=y
CONFIG_CLK_HSDK=y
# CONFIG_COMMON_CLK_RK808 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI514 is not set
CONFIG_COMMON_CLK_SI570=y
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CDCE925 is not set
CONFIG_COMMON_CLK_CS2000_CP=y
CONFIG_CLK_TWL6040=y
# CONFIG_COMMON_CLK_NXP is not set
CONFIG_COMMON_CLK_PALMAS=y
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set
# CONFIG_COMMON_CLK_VC5 is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_PLATFORM_MHU=y
# CONFIG_PCC is not set
CONFIG_ALTERA_MBOX=y
CONFIG_MAILBOX_TEST=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# CONFIG_INTEL_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#

#
# Broadcom SoC drivers
#

#
# i.MX SoC drivers
#

#
# Qualcomm SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_AXP288=y
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX3355=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
# CONFIG_EXTCON_RT8973A is not set
CONFIG_EXTCON_SM5502=y
CONFIG_EXTCON_USB_GPIO=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=y
# CONFIG_IIO_SW_TRIGGER is not set

#
# Accelerometers
#
# CONFIG_ADXL345_I2C is not set
# CONFIG_BMA180 is not set
CONFIG_BMC150_ACCEL=y
CONFIG_BMC150_ACCEL_I2C=y
CONFIG_DA280=y
CONFIG_DA311=y
# CONFIG_DMARD06 is not set
# CONFIG_DMARD09 is not set
CONFIG_DMARD10=y
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_IIO_CROS_EC_ACCEL_LEGACY is not set
CONFIG_KXSD9=y
# CONFIG_KXSD9_I2C is not set
CONFIG_KXCJK1013=y
# CONFIG_MC3230 is not set
CONFIG_MMA7455=y
CONFIG_MMA7455_I2C=y
CONFIG_MMA7660=y
CONFIG_MMA8452=y
CONFIG_MMA9551_CORE=y
CONFIG_MMA9551=y
# CONFIG_MMA9553 is not set
# CONFIG_MXC4005 is not set
CONFIG_MXC6255=y
# CONFIG_STK8312 is not set
CONFIG_STK8BA50=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD799X=y
CONFIG_AXP20X_ADC=y
CONFIG_AXP288_ADC=y
# CONFIG_CC10001_ADC is not set
CONFIG_DA9150_GPADC=y
# CONFIG_ENVELOPE_DETECTOR is not set
CONFIG_HX711=y
CONFIG_INA2XX_ADC=y
CONFIG_LP8788_ADC=y
CONFIG_LTC2471=y
# CONFIG_LTC2485 is not set
# CONFIG_LTC2497 is not set
CONFIG_MAX1363=y
CONFIG_MAX9611=y
# CONFIG_MCP3422 is not set
# CONFIG_MEN_Z188_ADC is not set
# CONFIG_NAU7802 is not set
CONFIG_PALMAS_GPADC=y
CONFIG_QCOM_VADC_COMMON=y
# CONFIG_QCOM_SPMI_IADC is not set
CONFIG_QCOM_SPMI_VADC=y
CONFIG_TI_ADC081C=y
# CONFIG_TI_ADS1015 is not set
CONFIG_TI_AM335X_ADC=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_TWL6030_GPADC is not set
CONFIG_VF610_ADC=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_CCS811 is not set
CONFIG_IAQCORE=y
CONFIG_VZ89X=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_MS_SENSORS_I2C=y

#
# SSP Sensor Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Counters
#

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
CONFIG_AD5446=y
CONFIG_AD5592R_BASE=y
CONFIG_AD5593R=y
# CONFIG_CIO_DAC is not set
CONFIG_DPOT_DAC=y
# CONFIG_DS4424 is not set
# CONFIG_M62332 is not set
CONFIG_MAX517=y
CONFIG_MAX5821=y
CONFIG_MCP4725=y
CONFIG_VF610_DAC=y

#
# IIO dummy driver
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_BMG160 is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_MPU3050_I2C is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4404=y
CONFIG_MAX30100=y
# CONFIG_MAX30102 is not set

#
# Humidity sensors
#
CONFIG_AM2315=y
CONFIG_DHT11=y
# CONFIG_HDC100X is not set
CONFIG_HID_SENSOR_HUMIDITY=y
# CONFIG_HTS221 is not set
CONFIG_HTU21=y
CONFIG_SI7005=y
# CONFIG_SI7020 is not set

#
# Inertial measurement units
#
# CONFIG_BMI160_I2C is not set
CONFIG_KMX61=y
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_IIO_ST_LSM6DSX is not set

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
CONFIG_ADJD_S311=y
CONFIG_AL3320A=y
CONFIG_APDS9300=y
# CONFIG_APDS9960 is not set
CONFIG_BH1750=y
CONFIG_BH1780=y
# CONFIG_CM32181 is not set
CONFIG_CM3232=y
# CONFIG_CM3323 is not set
# CONFIG_CM3605 is not set
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_SENSORS_ISL29018=y
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_ISL29125=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_HID_SENSOR_PROX=y
CONFIG_JSA1212=y
# CONFIG_RPR0521 is not set
# CONFIG_LTR501 is not set
# CONFIG_MAX44000 is not set
# CONFIG_OPT3001 is not set
# CONFIG_PA12203001 is not set
CONFIG_SI1145=y
CONFIG_STK3310=y
CONFIG_TCS3414=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL2583=y
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
CONFIG_VCNL4000=y
CONFIG_VEML6070=y
CONFIG_VL6180=y

#
# Magnetometer sensors
#
CONFIG_AK8974=y
CONFIG_AK8975=y
# CONFIG_AK09911 is not set
# CONFIG_BMC150_MAGN_I2C is not set
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_MMC35240=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
# CONFIG_SENSORS_HMC5843_I2C is not set

#
# Multiplexers
#
CONFIG_IIO_MUX=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y
CONFIG_HID_SENSOR_DEVICE_ROTATION=y

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Digital potentiometers
#
# CONFIG_DS1803 is not set
CONFIG_MCP4531=y
CONFIG_TPL0102=y

#
# Digital potentiostats
#
CONFIG_LMP91000=y

#
# Pressure sensors
#
CONFIG_ABP060MG=y
CONFIG_BMP280=y
CONFIG_BMP280_I2C=y
# CONFIG_HID_SENSOR_PRESS is not set
# CONFIG_HP03 is not set
CONFIG_MPL115=y
CONFIG_MPL115_I2C=y
# CONFIG_MPL3115 is not set
CONFIG_MS5611=y
CONFIG_MS5611_I2C=y
CONFIG_MS5637=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
# CONFIG_T5403 is not set
CONFIG_HP206C=y
CONFIG_ZPA2326=y
CONFIG_ZPA2326_I2C=y

#
# Lightning sensors
#

#
# Proximity and distance sensors
#
CONFIG_LIDAR_LITE_V2=y
# CONFIG_RFD77402 is not set
CONFIG_SRF04=y
# CONFIG_SX9500 is not set
CONFIG_SRF08=y

#
# Temperature sensors
#
CONFIG_HID_SENSOR_TEMP=y
# CONFIG_MLX90614 is not set
CONFIG_TMP006=y
CONFIG_TMP007=y
CONFIG_TSYS01=y
CONFIG_TSYS02D=y
CONFIG_NTB=y
CONFIG_NTB_IDT=y
# CONFIG_NTB_SWITCHTEC is not set
CONFIG_NTB_PINGPONG=y
# CONFIG_NTB_TOOL is not set
CONFIG_NTB_PERF=y
CONFIG_NTB_TRANSPORT=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set
CONFIG_VME_FAKE=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_FSL_FTM=y
# CONFIG_PWM_LP3943 is not set
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set
# CONFIG_PWM_STMPE is not set
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y

#
# IRQ chip support
#
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_ATH79 is not set
# CONFIG_RESET_AXS10X is not set
# CONFIG_RESET_BERLIN is not set
# CONFIG_RESET_IMX7 is not set
# CONFIG_RESET_LANTIQ is not set
# CONFIG_RESET_LPC18XX is not set
# CONFIG_RESET_MESON is not set
# CONFIG_RESET_PISTACHIO is not set
# CONFIG_RESET_SIMPLE is not set
# CONFIG_RESET_SUNXI is not set
CONFIG_RESET_TI_SYSCON=y
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_PXA_28NM_HSIC=y
CONFIG_PHY_PXA_28NM_USB2=y
# CONFIG_PHY_CPCAP_USB is not set
CONFIG_PHY_SAMSUNG_USB2=y
# CONFIG_PHY_EXYNOS4210_USB2 is not set
# CONFIG_PHY_EXYNOS4X12_USB2 is not set
# CONFIG_PHY_EXYNOS5250_USB2 is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_MCB_LPC=y

#
# Performance monitor support
#
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_DAX=y
CONFIG_DEV_DAX=y
CONFIG_NVMEM=y
CONFIG_STM=y
# CONFIG_STM_DUMMY is not set
CONFIG_STM_SOURCE_CONSOLE=y
CONFIG_STM_SOURCE_HEARTBEAT=y
CONFIG_INTEL_TH=y
CONFIG_INTEL_TH_PCI=y
CONFIG_INTEL_TH_GTH=y
CONFIG_INTEL_TH_STH=y
CONFIG_INTEL_TH_MSU=y
CONFIG_INTEL_TH_PTI=y
CONFIG_INTEL_TH_DEBUG=y
# CONFIG_FPGA is not set

#
# FSI support
#
# CONFIG_FSI is not set
CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
# CONFIG_MUX_ADG792A is not set
# CONFIG_MUX_GPIO is not set
CONFIG_MUX_MMIO=y
CONFIG_PM_OPP=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set
# CONFIG_EFI_DEV_PATH_PARSER is not set

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_ENCRYPTION is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
# CONFIG_XFS_ONLINE_SCRUB is not set
CONFIG_XFS_DEBUG=y
# CONFIG_XFS_ASSERT_FATAL is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_DLM is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_BTRFS_FS_REF_VERIFY is not set
CONFIG_NILFS2_FS=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_F2FS_FAULT_INJECTION=y
CONFIG_FS_DAX=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_OVERLAY_FS=y
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_INDEX is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_FAT_DEFAULT_UTF8=y
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
CONFIG_JFFS2_CMODE_SIZE=y
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_ATIME_SUPPORT is not set
# CONFIG_UBIFS_FS_ENCRYPTION is not set
CONFIG_UBIFS_FS_SECURITY=y
CONFIG_CRAMFS=y
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZ4=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_ZLIB_COMPRESS is not set
# CONFIG_PSTORE_LZO_COMPRESS is not set
CONFIG_PSTORE_LZ4_COMPRESS=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_WQ_WATCHDOG=y
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_LOCKDEP_CROSSRELEASE=y
CONFIG_LOCKDEP_COMPLETIONS=y
# CONFIG_BOOTPARAM_LOCKDEP_CROSSRELEASE_FULLSTACK is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
CONFIG_WARN_ALL_UNSEEDED_RANDOM=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_PERF_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAIL_FUTEX=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_TEST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_HEXDUMP is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=y
# CONFIG_TEST_BITMAP is not set
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=y
CONFIG_TEST_HASH=y
# CONFIG_TEST_FIND_BIT is not set
CONFIG_TEST_FIRMWARE=y
# CONFIG_TEST_SYSCTL is not set
CONFIG_TEST_UDELAY=y
CONFIG_MEMTEST=y
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
CONFIG_IO_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP_CORE=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
CONFIG_PUNIT_ATOM_DEBUG=y
CONFIG_UNWINDER_FRAME_POINTER=y
# CONFIG_UNWINDER_GUESS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
# CONFIG_FORTIFY_SOURCE is not set
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_SIMD=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_KEYWRAP=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_USER_API_RNG is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST=y
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC4=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_XXHASH=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
CONFIG_DMA_VIRT_OPS=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_LIBFDT=y
# CONFIG_SG_SPLIT is not set
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y
CONFIG_PRIME_NUMBERS=y
CONFIG_STRING_SELFTEST=y

--ntbecuc2mtdmjztx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='trinity'
	export testcase='trinity'
	export runtime=300
	export job_origin='/lkp/lkp/src/allot/rand/vm-ivb41-yocto-i386/trinity.yaml'
	export testbox='vm-ivb41-yocto-i386-1'
	export tbox_group='vm-ivb41-yocto-i386'
	export kconfig='i386-randconfig-sb0-11100832'
	export compiler='gcc-5'
	export queue='rand'
	export branch='linus/master'
	export commit='1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c'
	export repeat_to=2
	export submit_id='5a18e8bd0b9a93fe0ccd7cf9'
	export job_file='/lkp/scheduled/vm-ivb41-yocto-i386-1/trinity-300s-yocto-tiny-i386-2016-04-22.cgz-1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c-20171125-65036-1j2iqyn-1.yaml'
	export id='f1efeb7675cdd56079a4ae51740e878536377394'
	export model='qemu-system-i386 -enable-kvm'
	export nr_vm=32
	export nr_cpu=2
	export memory='320M'
	export rootfs='yocto-tiny-i386-2016-04-22.cgz'
	export swap_partitions='/dev/vda'
	export need_kconfig='CONFIG_KVM_GUEST=y'
	export enqueue_time='2017-11-25 11:51:25 +0800'
	export _id='5a18e8bd0b9a93fe0ccd7cfa'
	export _rt='/result/trinity/300s/vm-ivb41-yocto-i386/yocto-tiny-i386-2016-04-22.cgz/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c'
	export user='lkp'
	export kernel='/pkg/linux/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c/vmlinuz-4.14.0-13292-g1d3b78b'
	export result_root='/result/trinity/300s/vm-ivb41-yocto-i386/yocto-tiny-i386-2016-04-22.cgz/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c/1'
	export dequeue_time='2017-11-25 11:54:27 +0800'
	export LKP_SERVER='inn'
	export max_uptime=1500
	export initrd='/osimage/yocto/yocto-tiny-i386-2016-04-22.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/scheduled/vm-ivb41-yocto-i386-1/trinity-300s-yocto-tiny-i386-2016-04-22.cgz-1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c-20171125-65036-1j2iqyn-1.yaml
ARCH=i386
kconfig=i386-randconfig-sb0-11100832
branch=linus/master
commit=1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c
BOOT_IMAGE=/pkg/linux/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c/vmlinuz-4.14.0-13292-g1d3b78b
max_uptime=1500
RESULT_ROOT=/result/trinity/300s/vm-ivb41-yocto-i386/yocto-tiny-i386-2016-04-22.cgz/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c/1
LKP_SERVER=inn
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export bm_initrd='/osimage/deps/debian-x86_64-2016-08-31.cgz/run-ipconfig.i386_2016-09-03.cgz,/osimage/pkg/debian-x86_64-2016-08-31.cgz/trinity-static-i386-x86_64-6ddabfd2_2017-11-10.cgz'
	export lkp_initrd='/lkp/lkp/lkp-i386.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export job_initrd='/lkp/scheduled/vm-ivb41-yocto-i386-1/trinity-300s-yocto-tiny-i386-2016-04-22.cgz-1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c-20171125-65036-1j2iqyn-1.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test $LKP_SRC/tests/wrapper trinity
}

extract_stats()
{
	$LKP_SRC/stats/wrapper kmsg

	$LKP_SRC/stats/wrapper time trinity.time
	$LKP_SRC/stats/wrapper time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper last_state
}

"$@"

--ntbecuc2mtdmjztx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce-vm-ivb41-yocto-i386-1:20171125115550:i386-randconfig-sb0-11100832:4.14.0-13292-g1d3b78b:1"

#!/bin/bash

# To reproduce,
# 1) save job-script and this script (both are attached in 0day report email)
# 2) run this script with your compiled kernel and optional env $INSTALL_MOD_PATH

kernel=$1

initrds=(
	/osimage/yocto/yocto-tiny-i386-2016-04-22.cgz
	/lkp/lkp/lkp-i386.cgz
	/osimage/deps/debian-x86_64-2016-08-31.cgz/run-ipconfig.i386_2016-09-03.cgz
	/osimage/pkg/debian-x86_64-2016-08-31.cgz/trinity-static-i386-x86_64-6ddabfd2_2017-11-10.cgz
)

HTTP_PREFIX=https://github.com/0day-ci/lkp-qemu/raw/master
wget --timestamping "${initrds[@]/#/$HTTP_PREFIX}"

{
	cat "${initrds[@]//*\//}"
	[[ $INSTALL_MOD_PATH ]] && (
		cd "$INSTALL_MOD_PATH"
		find lib | cpio -o -H newc --quiet | gzip
	)
	echo  job-script | cpio -o -H newc --quiet | gzip
} > initrd.img

qemu-img create -f qcow2 disk-vm-ivb41-yocto-i386-1-0 256G

kvm=(
	qemu-system-i386
	-enable-kvm
	-kernel $kernel
	-initrd initrd.img
	-m 320
	-smp 2
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-drive file=disk-vm-ivb41-yocto-i386-1-0,media=disk,if=virtio
	-serial stdio
	-display none
	-monitor null
)

append=(
	ip=::::vm-ivb41-yocto-i386-1::dhcp
	root=/dev/ram0
	user=lkp
	job=/job-script
	ARCH=i386
	kconfig=i386-randconfig-sb0-11100832
	branch=linus/master
	commit=1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c
	BOOT_IMAGE=/pkg/linux/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c/vmlinuz-4.14.0-13292-g1d3b78b
	max_uptime=1500
	RESULT_ROOT=/result/trinity/300s/vm-ivb41-yocto-i386/yocto-tiny-i386-2016-04-22.cgz/i386-randconfig-sb0-11100832/gcc-5/1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c/1
	result_service=tmpfs
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	console=tty0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--ntbecuc2mtdmjztx--
