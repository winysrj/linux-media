Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbbFTHSF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2015 03:18:05 -0400
Date: Sat, 20 Jun 2015 15:17:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	LKP <lkp@01.org>
Subject: [x86/mm/pat, drivers/media/ivtv]  WARNING: CPU: 0 PID: 1 at
 drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init()
Message-ID: <20150620071756.GA10923@wfg-t540p.sh.intel.com>
Reply-To: kernel test robot <fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit 1bf1735b478008c30acaff18ec6f4a3ff211c28a
Author:     Luis R. Rodriguez <mcgrof@suse.com>
AuthorDate: Mon Jun 15 10:28:16 2015 +0200
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Thu Jun 18 11:23:41 2015 +0200

    x86/mm/pat, drivers/media/ivtv: Use arch_phys_wc_add() and require PAT disabled
    
    We are burrying direct access to MTRR code support on
    x86 in order to take advantage of PAT. In the future, we
    also want to make the default behavior of ioremap_nocache()
    to use strong UC, at which point the use of mtrr_add() on
    those systems would make write-combining void.
    
    In order to help both enable us to later make strong
    UC default and in order to phase out direct MTRR access
    code, port the driver over to the arch_phys_wc_add() API
    and annotate that the device driver requires systems to
    boot with PAT disabled, with the 'nopat' kernel parameter.
    
    This is a workable compromise given that the hardware is
    really rare these days, and perhaps only some lost souls
    stuck with obsolete hardware are expected to be using this
    feature of the device driver.
    
    Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
    Signed-off-by: Borislav Petkov <bp@suse.de>
    Acked-by: Andy Walls <awalls@md.metrocast.net>
    Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Andy Lutomirski <luto@amacapital.net>
    Cc: Antonino Daplas <adaplas@gmail.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: Borislav Petkov <bp@alien8.de>
    Cc: Brian Gerst <brgerst@gmail.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: Dave Airlie <airlied@redhat.com>
    Cc: Dave Hansen <dave.hansen@linux.intel.com>
    Cc: Denys Vlasenko <dvlasenk@redhat.com>
    Cc: Doug Ledford <dledford@redhat.com>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
    Cc: Juergen Gross <jgross@suse.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Michael S. Tsirkin <mst@redhat.com>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Roger Pau Monné <roger.pau@citrix.com>
    Cc: Stefan Bader <stefan.bader@canonical.com>
    Cc: Suresh Siddha <sbsiddha@gmail.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ville Syrjälä <syrjala@sci.fi>
    Cc: bhelgaas@google.com
    Cc: konrad.wilk@oracle.com
    Cc: linux-media@vger.kernel.org
    Cc: tomi.valkeinen@ti.com
    Cc: toshi.kani@hp.com
    Link: http://lkml.kernel.org/r/1434053994-2196-2-git-send-email-mcgrof@do-not-panic.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

+-----------------------------------------------------------+------------+------------+-----------------+
|                                                           | 957561ec0f | 1bf1735b47 | v4.1-rc8_061911 |
+-----------------------------------------------------------+------------+------------+-----------------+
| boot_successes                                            | 63         | 0          | 0               |
| boot_failures                                             | 0          | 22         | 13              |
| WARNING:at_drivers/media/pci/ivtv/ivtvfb.c:#ivtvfb_init() | 0          | 22         | 13              |
| backtrace:ivtvfb_init                                     | 0          | 22         | 13              |
| backtrace:warn_slowpath_fmt                               | 0          | 22         | 13              |
| backtrace:kernel_init_freeable                            | 0          | 22         | 13              |
+-----------------------------------------------------------+------------+------------+-----------------+

[   12.956506] ivtv: Start initialization, version 1.4.3
[   12.958238] ivtv: End initialization
[   12.959438] ------------[ cut here ]------------
[   12.974076] WARNING: CPU: 0 PID: 1 at drivers/media/pci/ivtv/ivtvfb.c:1270 ivtvfb_init+0x32/0xa3()
[   12.978017] ivtvfb needs PAT disabled, boot with nopat kernel parameter
[   12.980628] CPU: 0 PID: 1 Comm: swapper Not tainted 4.1.0-rc5-00034-g1bf1735 #2
[   12.995566] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[   12.999061]  ffffffff8d429cc8 ffff880010c5bdc8 ffffffff8cf47a88 ffff880010c5be08
[   13.001954]  ffffffff8c68e6d5 ffffffff8d977327 ffffffff8d9c6910 ffff880000139ef8
[   13.004862]  0000000000000000 ffffffff8d977327 0000000000000000 ffff880010c5be68
[   13.007636] Call Trace:
[   13.008469]  [<ffffffff8cf47a88>] dump_stack+0x19/0x1b
[   13.010185]  [<ffffffff8c68e6d5>] warn_slowpath_common+0x75/0xb0
[   13.024843]  [<ffffffff8d977327>] ? module_start+0xa4/0xa4
[   13.026876]  [<ffffffff8d977327>] ? module_start+0xa4/0xa4
[   13.029041]  [<ffffffff8c68e781>] warn_slowpath_fmt+0x41/0x50
[   13.031312]  [<ffffffff8d977359>] ivtvfb_init+0x32/0xa3
[   13.033362]  [<ffffffff8d945122>] do_one_initcall+0x19a/0x1ae
[   13.035444]  [<ffffffff8d945250>] kernel_init_freeable+0x11a/0x1a2
[   13.037434]  [<ffffffff8cf450f0>] ? rest_init+0xc0/0xc0
[   13.051468]  [<ffffffff8cf450f9>] kernel_init+0x9/0xf0
[   13.053252]  [<ffffffff8cf5e422>] ret_from_fork+0x42/0x70
[   13.055149]  [<ffffffff8cf450f0>] ? rest_init+0xc0/0xc0
[   13.057090] ---[ end trace 4c8a37b47d22b2c8 ]---
[   13.058748] Zoran MJPEG board driver version 0.10.1

git bisect start 1e5a271153487afd411894cfcbebed348c56e251 0f57d86787d8b1076ea8f9cbdddda2a46d534a27 --
git bisect good cfe18bb129d434b5229366eef876f076e9143bf4  # 16:20     22+      0  Merge 'pm/bleeding-edge' into devel-hourly-2015061911
git bisect  bad 062f9e0508bcab8d6a7f0ad64c2970dfd17fe4a0  # 16:25      0-     20  Merge 'tip/x86/mm' into devel-hourly-2015061911
git bisect good af6ae74ccfa5cb1d5688fb56b1dd6992a75d23fc  # 16:31     22+      2  Merge 'yinghai/for-pci-v4.1-rc8' into devel-hourly-2015061911
git bisect good 88dfb6767f528a66dd73b809afc87422f0628690  # 16:36     22+      0  Merge 'nfs/bugfixes' into devel-hourly-2015061911
git bisect good a7e50b0489e76438b0d3f9a17029ff4e11fd4e97  # 16:47     22+      0  Merge 'tip/timers/core' into devel-hourly-2015061911
git bisect good 6f5000ba3def9da5bcf360ecea9d0dd9598e5ac7  # 16:50     22+      0  Merge 'jolsa-perf/perf/per_thread' into devel-hourly-2015061911
git bisect good fbe7193aa4787f27c84216d130ab877efc310d57  # 16:55     20+      0  x86/mm/pat: Export pat_enabled()
git bisect good d838270e2516db11084bed4e294017eb7b646a75  # 17:00     21+      0  x86/mm, asm-generic: Add ioremap_wt() for creating Write-Through mappings
git bisect good 35a5a10411d87e24b46a7a9dda8d08ef9961b783  # 17:07     21+      0  x86/mm/pat: Extend set_page_memtype() to support Write-Through type
git bisect good 957561ec0fa8a701f60ca6a0f40cc46f5c554920  # 17:15     22+      0  drivers/block/pmem: Map NVDIMM in Write-Through mode
git bisect  bad 7ea402d01cb68224972dde3ae68bd41131b1c3a1  # 17:27      0-     13  x86/mm/pat, drivers/infiniband/ipath: Use arch_phys_wc_add() and require PAT disabled
git bisect  bad 1bf1735b478008c30acaff18ec6f4a3ff211c28a  # 17:31      0-     12  x86/mm/pat, drivers/media/ivtv: Use arch_phys_wc_add() and require PAT disabled
# first bad commit: [1bf1735b478008c30acaff18ec6f4a3ff211c28a] x86/mm/pat, drivers/media/ivtv: Use arch_phys_wc_add() and require PAT disabled
git bisect good 957561ec0fa8a701f60ca6a0f40cc46f5c554920  # 17:35     63+      0  drivers/block/pmem: Map NVDIMM in Write-Through mode
# extra tests with DEBUG_INFO
git bisect  bad 1bf1735b478008c30acaff18ec6f4a3ff211c28a  # 17:40      0-      2  x86/mm/pat, drivers/media/ivtv: Use arch_phys_wc_add() and require PAT disabled
# extra tests on HEAD of linux-devel/devel-hourly-2015061911
git bisect  bad 1e5a271153487afd411894cfcbebed348c56e251  # 17:40      0-     13  0day head guard for 'devel-hourly-2015061911'
# extra tests on tree/branch next/master
git bisect  bad c1ce6ea24e13fcdb61c75d7bb24377d11478b3c4  # 17:52      0-     66  Add linux-next specific files for 20150619
# extra tests with first bad commit reverted
git bisect good 9025feea072ddf7e82da7c400193202e8c06e867  # 18:19     66+      0  Revert "x86/mm/pat, drivers/media/ivtv: Use arch_phys_wc_add() and require PAT disabled"
# extra tests on tree/branch linus/master
git bisect good e640a280ccb9c448a3d9d522ea730ce00efa8cf0  # 18:23     63+      0  Merge branch 'i2c/for-current' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
# extra tests on tree/branch next/master
git bisect  bad c1ce6ea24e13fcdb61c75d7bb24377d11478b3c4  # 18:23      0-     66  Add linux-next specific files for 20150619


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu kvm64
	-kernel $kernel
	-initrd $initrd
	-m 300
	-smp 2
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	systemd.log_level=err
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-intel12-45:20150619173143:x86_64-randconfig-n0-06191536:4.1.0-rc5-00034-g1bf1735:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 4.1.0-rc5-00034-g1bf1735 (kbuild@lkp-ib03) (gc=
c version 4.9.2 (Debian 4.9.2-10) ) #2 Fri Jun 19 17:29:32 CST 2015
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 systemd.log_level=3Derr debug apic=3Ddebug sysrq_always_enabled rcupdate.r=
cu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dp=
anic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run=
-queue/kvm/x86_64-randconfig-n0-06191536/linux-devel:devel-hourly-201506191=
1:1bf1735b478008c30acaff18ec6f4a3ff211c28a:bisect-linux-3/.vmlinuz-1bf1735b=
478008c30acaff18ec6f4a3ff211c28a-20150619172952-15-intel12 branch=3Dlinux-d=
evel/devel-hourly-2015061911 BOOT_IMAGE=3D/pkg/linux/x86_64-randconfig-n0-0=
6191536/gcc-4.9/1bf1735b478008c30acaff18ec6f4a3ff211c28a/vmlinuz-4.1.0-rc5-=
00034-g1bf1735 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000012bdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000012be0000-0x0000000012bfffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x12be0 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT=
 =20
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0e80-0x000f0e8f] mapped at =
[ffff8800000f0e80]
[    0.000000]   mpc: f0e90-f0fac
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0e514000, 0x0e514fff] PGTABLE
[    0.000000] BRK [0x0e515000, 0x0e515fff] PGTABLE
[    0.000000] BRK [0x0e516000, 0x0e516fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11200000-0x113fffff]
[    0.000000]  [mem 0x11200000-0x113fffff] page 4k
[    0.000000] BRK [0x0e517000, 0x0e517fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x111fffff]
[    0.000000]  [mem 0x00100000-0x111fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11400000-0x12bdffff]
[    0.000000]  [mem 0x11400000-0x12bdffff] page 4k
[    0.000000] BRK [0x0e518000, 0x0e518fff] PGTABLE
[    0.000000] BRK [0x0e519000, 0x0e519fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x11525000-0x12bd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C60 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000012BE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000012BE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000012BE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000012BE0000 000040
[    0.000000] ACPI: SSDT 0x0000000012BE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000012BE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000012BE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:12bdf001, primary cpu clock
[    0.000000] clocksource kvm-clock: mask: 0xffffffffffffffff max_cycles: =
0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x0000000012bdffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x0000000012bdffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000012bdf=
fff]
[    0.000000] On node 0 totalpages: 76670
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 994 pages used for memmap
[    0.000000]   DMA32 zone: 72672 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr d629880
[    0.000000] e820: [mem 0x12c00000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource refined-jiffies: mask: 0xffffffff max_cycles: 0x=
ffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 75599
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 systemd.log_level=3Derr debug apic=3Ddebug sysrq_always_enabled rcu=
pdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watch=
dog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS=
0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-te=
sts/run-queue/kvm/x86_64-randconfig-n0-06191536/linux-devel:devel-hourly-20=
15061911:1bf1735b478008c30acaff18ec6f4a3ff211c28a:bisect-linux-3/.vmlinuz-1=
bf1735b478008c30acaff18ec6f4a3ff211c28a-20150619172952-15-intel12 branch=3D=
linux-devel/devel-hourly-2015061911 BOOT_IMAGE=3D/pkg/linux/x86_64-randconf=
ig-n0-06191536/gcc-4.9/1bf1735b478008c30acaff18ec6f4a3ff211c28a/vmlinuz-4.1=
=2E0-rc5-00034-g1bf1735 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 244660K/306680K available (9607K kernel code, 3338K =
rwdata, 4464K rodata, 840K init, 11252K bss, 62020K reserved, 0K cma-reserv=
ed)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] clocksource hpet: mask: 0xffffffff max_cycles: 0xffffffff, m=
ax_idle_ns: 19112604467 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2926.328 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5852.65 Bogo=
MIPS (lpj=3D2926328)
[    0.003521] pid_max: default: 32768 minimum: 301
[    0.004017] ACPI: Core revision 20150410
[    0.018627] ACPI: All ACPI Tables successfully acquired
[    0.019813] Security Framework initialized
[    0.020011] Yama: becoming mindful.
[    0.021041] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.022012] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.024498] mce: CPU supports 10 MCE banks
[    0.025010] mce: unknown CPU type - not enabling MCE support
[    0.026008] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027008] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.028008] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.036552] Performance Events: no PMU driver, software events only.
[    0.041197] enabled ExtINT on CPU#0
[    0.043830] ENABLING IO-APIC IRQs
[    0.044030] init IO_APIC IRQs
[    0.045008]  apic 0 pin 0 not connected
[    0.046059] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.047042] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.049049] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.050052] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.051039] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.052053] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.053070] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.054041] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.055050] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.056038] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.057058] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.059050] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.060054] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.061050] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.063057] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.065018] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.066052]  apic 0 pin 16 not connected
[    0.067005]  apic 0 pin 17 not connected
[    0.068005]  apic 0 pin 18 not connected
[    0.069009]  apic 0 pin 19 not connected
[    0.070009]  apic 0 pin 20 not connected
[    0.071005]  apic 0 pin 21 not connected
[    0.072005]  apic 0 pin 22 not connected
[    0.073005]  apic 0 pin 23 not connected
[    0.074212] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.075007] Using local APIC timer interrupts.
[    0.075007] calibrating APIC timer ...
[    0.077000] ... lapic delta =3D 11249852
[    0.077000] ... PM-Timer delta =3D 644310
[    0.077000] APIC calibration not consistent with PM-Timer: 179ms instead=
 of 100ms
[    0.077000] APIC delta adjusted to PM-Timer: 6249987 (11249852)
[    0.077000] TSC delta adjusted to PM-Timer: 292631930 (526731588)
[    0.077000] ..... delta 6249987
[    0.077000] ..... mult: 268434897
[    0.077000] ..... calibration result: 999997
[    0.077000] ..... CPU clock speed is 2926.0319 MHz.
[    0.077000] ..... host bus clock speed is 999.0997 MHz.
[    0.078255] devtmpfs: initialized
[    0.082203] clocksource jiffies: mask: 0xffffffff max_cycles: 0xffffffff=
, max_idle_ns: 1911260446275000 ns
[    0.083208] prandom: seed boundary self test passed
[    0.086169] prandom: 100 self tests passed
[    0.088672] NET: Registered protocol family 16
[    0.091096] cpuidle: using governor ladder
[    0.092010] cpuidle: using governor menu
[    0.096399] ACPI: bus type PCI registered
[    0.098062] PCI: Using configuration type 1 for base access
[    0.155922] ACPI: Added _OSI(Module Device)
[    0.156014] ACPI: Added _OSI(Processor Device)
[    0.157007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.158006] ACPI: Added _OSI(Processor Aggregator Device)
[    0.162395] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.170584] ACPI: Interpreter enabled
[    0.171034] ACPI: (supports S0 S5)
[    0.172005] ACPI: Using IOAPIC for interrupt routing
[    0.173137] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.198138] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.199023] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.200049] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.202036] PCI host bridge to bus 0000:00
[    0.203009] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.204015] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.205012] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff window]
[    0.206010] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff window]
[    0.207008] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf window]
[    0.209007] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff window]
[    0.210007] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    0.211011] pci_bus 0000:00: root bus resource [mem 0x12c00000-0xfebffff=
f window]
[    0.212113] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.214326] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.216676] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.229013] pci 0000:00:01.1: reg 0x20: [io  0xc200-0xc20f]
[    0.235075] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.236013] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.237006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.238006] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.239794] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.241127] pci 0000:00:01.3: can't claim BAR 13 [io  0x0600-0x063f]: ad=
dress conflict with ACPI PM1a_EVT_BLK [io  0x0600-0x0603]
[    0.242033] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.244608] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.247030] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.250031] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.262029] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.264074] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.267014] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.270015] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.281015] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.283172] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.287016] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.290015] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.303975] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.306017] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.309012] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.322610] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.325017] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.328016] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.343229] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.346017] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.349016] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.361849] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.364016] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.367016] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.379125] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.382016] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.386013] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.399902] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.402016] pci 0000:00:0a.0: reg 0x10: [io  0xc1c0-0xc1ff]
[    0.405016] pci 0000:00:0a.0: reg 0x14: [mem 0xfebf7000-0xfebf7fff]
[    0.419470] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.423014] pci 0000:00:0b.0: reg 0x10: [mem 0xfebf8000-0xfebf800f]
[    0.441090] pci_bus 0000:00: on NUMA node 0
[    0.444691] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.446251] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.448741] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.450515] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.451795] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.455000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.458467] media: Linux media interface: v0.10
[    0.459087] Linux video capture interface: v2.00
[    0.460171] EDAC MC: Ver: 3.0.0
[    0.462889] PCI: Using ACPI for IRQ routing
[    0.463007] PCI: pci_cache_line_size set to 64 bytes
[    0.464447] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.465015] e820: reserve RAM buffer [mem 0x12be0000-0x13ffffff]
[    0.467532] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.468150] Switched to clocksource kvm-clock
[    0.469837] pnp: PnP ACPI init
[    0.477660] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.480683] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.483255] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.498407] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.500547] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.503183] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.505279] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.507937] pnp 00:03: [dma 2]
[    0.509411] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.514448] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.529849] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.532171] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.535311] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.538870] pnp: PnP ACPI: found 6 devices
[    0.550266] clocksource acpi_pm: mask: 0xffffff max_cycles: 0xffffff, ma=
x_idle_ns: 2085701024 ns
[    0.556889] pci 0000:00:01.3: BAR 13: [io  size 0x0040] has bogus alignm=
ent
[    0.561648] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.564888] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff window]
[    0.568561] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff window]
[    0.574025] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf window]
[    0.576308] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff window]
[    0.580855] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff windo=
w]
[    0.585980] pci_bus 0000:00: resource 10 [mem 0x12c00000-0xfebfffff wind=
ow]
[    0.588234] NET: Registered protocol family 1
[    0.592270] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.607367] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.609207] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.611211] pci 0000:00:02.0: Video device with shadowed ROM
[    0.613180] PCI: CLS 0 bytes, default 64
[    0.614714] Unpacking initramfs...
[    3.232749] debug: unmapping init [mem 0xffff880011525000-0xffff880012bd=
7fff]
[    3.242039] Machine check injector initialized
[    3.246934] Scanning for low memory corruption every 60 seconds
[    3.258269] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    3.264797] PCLMULQDQ-NI instructions are not detected.
[    3.268108] AVX or AES-NI instructions are not detected.
[    3.272213] AVX instructions are not detected.
[    3.275837] AVX2 or AES-NI instructions are not detected.
[    3.279973] AVX2 instructions are not detected.
[    3.283651] spin_lock-torture:--- Start of test [debug]: nwriters_stress=
=3D2 nreaders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D=
3 stutter=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.296910] spin_lock-torture: Creating torture_shuffle task
[    3.301344] spin_lock-torture: Creating torture_stutter task
[    3.306083] spin_lock-torture: torture_shuffle task started
[    3.309895] spin_lock-torture: torture_stutter task started
[    3.314579] spin_lock-torture: Creating lock_torture_writer task
[    3.316925] spin_lock-torture: Creating lock_torture_writer task
[    3.321509] spin_lock-torture: lock_torture_writer task started
[    3.326185] spin_lock-torture: lock_torture_writer task started
[    3.330624] spin_lock-torture: Creating lock_torture_stats task
[    3.338983] spin_lock-torture: lock_torture_stats task started
[    3.343693] futex hash table entries: 256 (order: 2, 24576 bytes)
[    3.349676] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.356390] page_owner is disabled
[    3.357967] zpool: loaded
[    3.362246] zbud: loaded
[    3.363446] VFS: Disk quotas dquot_6.6.0
[    3.364845] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    3.374198] start plist test
[    3.389193] end plist test
[    3.393251] test_string_helpers: Running tests...
[    3.395839] test_firmware: interface ready
[    3.420784] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    3.425615] crc32: self tests passed, processed 225944 bytes in 9332677 =
nsec
[    3.440929] crc32c: CRC_LE_BITS =3D 1
[    3.446654] crc32c: self tests passed, processed 225944 bytes in 6174253=
 nsec
[    4.093443] crc32_combine: 8373 self tests passed
[    4.248140] tsc: Refined TSC clocksource calibration: 2926.327 MHz
[    4.254042] clocksource tsc: mask: 0xffffffffffffffff max_cycles: 0x2a2e=
6992e26, max_idle_ns: 440795340657 ns
[    4.729929] crc32c_combine: 8373 self tests passed
[    4.731534] rbtree testing -> 78861 cycles
[    7.647537] augmented rbtree testing -> 106323 cycles
[   11.643990] rivafb_setup START
[   11.645981] nvidiafb_setup START
[   11.666349] no IO addresses supplied
[   11.667503] hgafb: HGA card not detected.
[   11.668440] hgafb: probe of hgafb.0 failed with error -22
[   11.670136] ipmi message handler version 39.2
[   11.671164] IPMI System Interface driver.
[   11.672245] ipmi_si: Adding default-specified kcs state machine
[   11.695146] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   11.697954] ipmi_si: Interface detection failed
[   11.698952] ipmi_si: Adding default-specified smic state machine
[   11.700544] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   11.703124] ipmi_si: Interface detection failed
[   11.704487] ipmi_si: Adding default-specified bt state machine
[   11.706231] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   11.721814] ipmi_si: Interface detection failed
[   11.723239] ipmi_si: Unable to find any System Interface(s)
[   11.725031] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   11.727714] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   11.729603] ACPI: Power Button [PWRF]
[   11.989906] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   12.080662] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   12.085818] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   12.105917] ac.o: No PCI boards found.
[   12.107344] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   12.110104] Non-volatile memory driver v1.3
[   12.112190] Linux agpgart interface v0.103
[   12.122963] [drm] Initialized drm 1.1.0 20060810
[   12.133311] [drm] radeon kernel modesetting enabled.
[   12.137375] [TTM] Zone  kernel: Available graphics memory: 122330 kiB
[   12.168500] [TTM] Initializing pool allocator
[   12.170034] [TTM] Initializing DMA pool allocator
[   12.173419] [drm] fb mappable at 0xFC000000
[   12.174730] [drm] vram aper at 0xFC000000
[   12.176030] [drm] size 33554432
[   12.177085] [drm] fb depth is 24
[   12.196292] [drm]    pitch is 3072
[   12.198720] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[   12.200824] cirrus 0000:00:02.0: registered panic notifier
[   12.202593] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[   12.218982] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   12.221802] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   12.224575] c2port c2port0: C2 port uc added
[   12.225828] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   12.230650] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   12.244793] platform physmap-flash.0: failed to claim resource 0
[   12.246797] slram: not enough parameters.
[   12.247901] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[   12.250027] pmc551: not detected
[   12.324354] No valid DiskOnChip devices found
[   12.325750] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   12.341621] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   12.344510] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   12.347589] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   12.350810] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   12.360939] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   12.363873] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[   12.365661] nand: Toshiba NAND 128MiB 1,8V 8-bit
[   12.373833] nand: 128 MiB, SLC, erase size: 16 KiB, page size: 512, OOB =
size: 16
[   12.376657] flash size: 128 MiB
[   12.377701] page size: 512 bytes
[   12.384836] OOB area size: 16 bytes
[   12.402664] sector size: 16 KiB
[   12.403881] pages number: 262144
[   12.405074] pages per sector: 32
[   12.406239] bus width: 8
[   12.407207] bits in sector size: 14
[   12.408586] bits in page size: 9
[   12.409909] bits in OOB size: 4
[   12.411172] flash size with OOB: 135168 KiB
[   12.414298] page address bytes: 4
[   12.419443] sector address bytes: 3
[   12.420579] options: 0x42
[   12.424379] Scanning device for bad blocks
[   12.524736] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   12.526580] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[   12.530949] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   12.535208] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.536720] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.816438] mousedev: PS/2 mouse device common for all mice
[   12.824580] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   12.851807] mk712: device not present
[   12.867701] i2c /dev entries driver
[   12.869458] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[   12.915719] i2c-parport-light: adapter type unspecified
[   12.917890] Error: Driver 'adv7511' is already registered, aborting...
[   12.921744] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[   12.924307] saa7146: register extension 'av7110'
[   12.926101] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[   12.930379] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH
[   12.933227] saa7146: register extension 'Multimedia eXtension Board'
[   12.952560] saa7146: register extension 'hexium HV-PCI6 Orion'
[   12.954644] saa7146: register extension 'hexium gemini'
[   12.956506] ivtv: Start initialization, version 1.4.3
[   12.958238] ivtv: End initialization
[   12.959438] ------------[ cut here ]------------
[   12.974076] WARNING: CPU: 0 PID: 1 at drivers/media/pci/ivtv/ivtvfb.c:12=
70 ivtvfb_init+0x32/0xa3()
[   12.978017] ivtvfb needs PAT disabled, boot with nopat kernel parameter
[   12.980628] CPU: 0 PID: 1 Comm: swapper Not tainted 4.1.0-rc5-00034-g1bf=
1735 #2
[   12.995566] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[   12.999061]  ffffffff8d429cc8 ffff880010c5bdc8 ffffffff8cf47a88 ffff8800=
10c5be08
[   13.001954]  ffffffff8c68e6d5 ffffffff8d977327 ffffffff8d9c6910 ffff8800=
00139ef8
[   13.004862]  0000000000000000 ffffffff8d977327 0000000000000000 ffff8800=
10c5be68
[   13.007636] Call Trace:
[   13.008469]  [<ffffffff8cf47a88>] dump_stack+0x19/0x1b
[   13.010185]  [<ffffffff8c68e6d5>] warn_slowpath_common+0x75/0xb0
[   13.024843]  [<ffffffff8d977327>] ? module_start+0xa4/0xa4
[   13.026876]  [<ffffffff8d977327>] ? module_start+0xa4/0xa4
[   13.029041]  [<ffffffff8c68e781>] warn_slowpath_fmt+0x41/0x50
[   13.031312]  [<ffffffff8d977359>] ivtvfb_init+0x32/0xa3
[   13.033362]  [<ffffffff8d945122>] do_one_initcall+0x19a/0x1ae
[   13.035444]  [<ffffffff8d945250>] kernel_init_freeable+0x11a/0x1a2
[   13.037434]  [<ffffffff8cf450f0>] ? rest_init+0xc0/0xc0
[   13.051468]  [<ffffffff8cf450f9>] kernel_init+0x9/0xf0
[   13.053252]  [<ffffffff8cf5e422>] ret_from_fork+0x42/0x70
[   13.055149]  [<ffffffff8cf450f0>] ? rest_init+0xc0/0xc0
[   13.057090] ---[ end trace 4c8a37b47d22b2c8 ]---
[   13.058748] Zoran MJPEG board driver version 0.10.1
[   13.060744] Linux video codec intermediate layer: v0.2
[   13.062842] cx18:  Start initialization, version 1.5.1
[   13.064849] cx18:  End initialization
[   13.066235] cx25821: driver version 0.0.106 loaded
[   13.082411] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   13.083943] Driver for 1-wire Dallas network protocol.
[   13.085468] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   13.401771] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   13.406818] hdaps: supported laptop not found!
[   13.408361] hdaps: driver init failed (ret=3D-19)!
[   13.409939] cros_ec_lpc: unsupported system.
[   13.413729]  fake-fmc-carrier: mezzanine 0
[   13.427796]       Manufacturer: fake-vendor
[   13.429331]       Product name: fake-design-for-testing
[   13.431496] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   13.433439] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[   13.435419] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   13.437802] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   13.443293] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   13.454091] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   13.461514] oprofile: using timer interrupt.
[   13.465841] mce: Unable to init device /dev/mcelog (rc: -5)
[   13.477393] ... APIC ID:      00000000 (0)
[   13.478018] ... APIC VERSION: 01050014
[   13.478018] 000000000000000000000000000000000000000000000000000000000000=
0000
[   13.478018] 000000000e20000000000000000000000000000000000000000000000000=
0000
[   13.478018] 000000000000000000000000000000000000000000000000000000000000=
8000
[   13.478018]=20
[   13.510522] number of MP IRQ sources: 15.
[   13.511948] number of IO-APIC #0 registers: 24.
[   13.515223] testing the IO APIC.......................
[   13.526003] IO APIC #0......
[   13.527095] .... register #00: 00000000
[   13.536689] .......    : physical APIC id: 00
[   13.538391] .......    : Delivery Type: 0
[   13.539943] .......    : LTS          : 0
[   13.541533] .... register #01: 00170011
[   13.543056] .......     : max redirection entries: 17
[   13.544959] .......     : PRQ implemented: 0
[   13.553126] .......     : IO APIC version: 11
[   13.554697] .... register #02: 00000000
[   13.556022] .......     : arbitration: 00
[   13.557607] .... IRQ redirection table:
[   13.563383] 1    0    0   0   0    0    0    00
[   13.564996] 0    0    0   0   0    1    1    31
[   13.566538] 0    0    0   0   0    1    1    30
[   13.568647] 0    0    0   0   0    1    1    33
[   13.575474] 1    0    0   0   0    1    1    34
[   13.576889] 1    1    0   0   0    1    1    35
[   13.578431] 0    0    0   0   0    1    1    36
[   13.579854] 0    0    0   0   0    1    1    37
[   13.593645] 0    0    0   0   0    1    1    38
[   13.595067] 0    1    0   0   0    1    1    39
[   13.596506] 1    1    0   0   0    1    1    3A
[   13.598010] 1    1    0   0   0    1    1    3B
[   13.599521] 0    0    0   0   0    1    1    3C
[   13.601112] 0    0    0   0   0    1    1    3D
[   13.602704] 0    0    0   0   0    1    1    3E
[   13.604480] 0    0    0   0   0    1    1    3F
[   13.606259] 1    0    0   0   0    0    0    00
[   13.607985] 1    0    0   0   0    0    0    00
[   13.615511] 1    0    0   0   0    0    0    00
[   13.617179] 1    0    0   0   0    0    0    00
[   13.618908] 1    0    0   0   0    0    0    00
[   13.620547] 1    0    0   0   0    0    0    00
[   13.634411] 1    0    0   0   0    0    0    00
[   13.635746] 1    0    0   0   0    0    0    00
[   13.637064] IRQ to pin mappings:
[   13.638093] IRQ0 -> 0:2
[   13.638987] IRQ1 -> 0:1
[   13.639901] IRQ3 -> 0:3
[   13.640817] IRQ4 -> 0:4
[   13.641805] IRQ5 -> 0:5
[   13.642883] IRQ6 -> 0:6
[   13.643939] IRQ7 -> 0:7
[   13.645054] IRQ8 -> 0:8
[   13.646104] IRQ9 -> 0:9
[   13.647183] IRQ10 -> 0:10
[   13.648342] IRQ11 -> 0:11
[   13.649509] IRQ12 -> 0:12
[   13.663046] IRQ13 -> 0:13
[   13.663905] IRQ14 -> 0:14
[   13.664751] IRQ15 -> 0:15
[   13.665584] .................................... done.
[   13.670607] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   13.677492] RIO: rio_register_scan for mport_id=3D-1
[   13.694823] debug: unmapping init [mem 0xffffffff8d944000-0xffffffff8da1=
5fff]
[   13.696268] Write protecting the kernel read-only data: 16384k
[   13.697936] debug: unmapping init [mem 0xffff88000cf64000-0xffff88000cff=
ffff]
[   13.699604] debug: unmapping init [mem 0xffff88000d45c000-0xffff88000d5f=
ffff]
[   13.726565] random: init urandom read with 6 bits of entropy available
mountall: Event failed
[   14.030741] init: Failed to create pty - disabling logging for job
[   14.053590] init: Temporary process spawn error: No space left on device
udevd[175]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LNX=
SYSTM:': No such file or directory
udevd[177]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LNX=
SYBUS:': No such file or directory
udevd[182]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv input:b0=
019v0000p0001e0000-e0,1,k74,ramlsfw': No such file or directory
udevd[181]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LNX=
SYBUS:': No such file or directory
udevd[184]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
08086d00001237sv00001AF4sd00001100bc06sc00i00': No such file or directory
udevd[185]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LNX=
CPU:': No such file or directory
udevd[186]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LNX=
CPU:': No such file or directory
udevd[187]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0103:': No such file or directory
udevd[197]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0C0F:': No such file or directory
udevd[199]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
08086d00007000sv00001AF4sd00001100bc06sc01i00': No such file or directory
udevd[202]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0C0F:': No such file or directory
udevd[198]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0C0F:': No such file or directory
udevd[200]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
08086d00007010sv00001AF4sd00001100bc01sc01i80': No such file or directory
udevd[201]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0C0F:': No such file or directory
udevd[203]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0A03:': No such file or directory
udevd[196]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0A06:': No such file or directory
udevd[209]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
01AF4d00001001sv00001AF4sd00000002bc01sc00i00': No such file or directory
udevd[210]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
01AF4d00001001sv00001AF4sd00000002bc01sc00i00': No such file or directory
udevd[213]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
01AF4d00001001sv00001AF4sd00000002bc01sc00i00': No such file or directory
udevd[217]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0C0F:': No such file or directory
udevd[223]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
01AF4d00001001sv00001AF4sd00000002bc01sc00i00': No such file or directory
udevd[224]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0103:': No such file or directory
udevd[225]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platform=
:dell_rbu': No such file or directory
udevd[226]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platform=
:i5k_amb': No such file or directory
udevd[227]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
08086d0000100Esv00001AF4sd00001100bc02sc00i00': No such file or directory
udevd[228]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
01AF4d00001001sv00001AF4sd00000002bc01sc00i00': No such file or directory
udevd[229]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
01AF4d00001001sv00001AF4sd00000002bc01sc00i00': No such file or directory
udevd[222]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
01AF4d00001001sv00001AF4sd00000002bc01sc00i00': No such file or directory
udevd[230]: failed to execute '/sbin/modprobe' '/sbin/modprobe -q fbcon': N=
o such file or directory
udevd[231]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platform=
:hgafb': No such file or directory
udevd[234]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platform=
:platform-framebuffer': No such file or directory
udevd[235]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv input:b0=
011v0002p0006e0000-e0,1,2,k110,111,112,113,114,r0,1,6,8,amlsfw': No such fi=
le or directory
udevd[236]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv input:b0=
011v0001p0001eAB41-e0,1,4,11,14,k71,72,73,74,75,76,77,79,7A,7B,7C,7D,7E,7F,=
80,8C,8E,8F,9B,9C,9D,9E,9F,A3,A4,A5,A6,AC,AD,B7,B8,B9,D9,E2,ram4,l0,1,2,sfw=
': No such file or directory
udevd[237]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv dmi:bvnS=
eaBIOS:bvr1.7.5-20140531_083030-gandalf:bd04/01/2014:svnQEMU:pnStandardPC(i=
440FX+PIIX,1996):pvrpc-i440fx-2.1:cvnQEMU:ct1:cvrpc-i440fx-2.1:': No such f=
ile or directory
udevd[232]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v000=
08086d000025ABsv00001AF4sd00001100bc08sc80i00': No such file or directory
udevd[241]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platform=
:pcspkr': No such file or directory
udevd[247]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0A06:': No such file or directory
udevd[273]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:APP=
0001:': No such file or directory
udevd[274]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0303:': No such file or directory
udevd[278]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0F13:': No such file or directory
udevd[276]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0501:': No such file or directory
udevd[277]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0700:': No such file or directory
udevd[275]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0400:': No such file or directory
udevd[280]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0B00:': No such file or directory
udevd[279]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:QEM=
U0001:': No such file or directory
udevd[286]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PNP=
0501:': No such file or directory
Kernel tests: Boot OK!
Kernel tests: Boot OK!
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (64bit:274 32bit:312) as to be disab=
led.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked 64-bit syscall get_robust_list (274) as deactivated.
[init] Marked 32-bit syscall get_robust_list (312) as deactivated.
[init] 32-bit syscalls: 350 enabled, 1 disabled.  64-bit syscalls: 313 enab=
led, 1 disabled.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 359
[main] Main thread is alive.
[main] Setsockopt(1 22 2505000 a6) on fd 6 [1:5:1]
[main] Setsockopt(1 1d 2505000 57) on fd 7 [1:1:1]
[main] Setsockopt(1 28 2505000 24) on fd 8 [1:5:1]
[main] Setsockopt(1 24 2505000 4) on fd 9 [1:1:1]
[main] Setsockopt(1 a 2505000 4) on fd 11 [1:5:1]
[main] Setsockopt(10e 4 2505000 99) on fd 12 [16:2:16]
[main] Setsockopt(1 28 2505000 4d) on fd 13 [1:5:1]
[main] Setsockopt(1 2c 2505000 1f) on fd 14 [1:1:1]
[main] Setsockopt(1 9 2505000 4) on fd 16 [1:2:1]
[main] Setsockopt(1 b 2505000 4) on fd 17 [1:2:1]
[main] Setsockopt(1 2f 2505000 4) on fd 18 [1:2:1]
[main] Setsockopt(1 5 2505000 4) on fd 19 [1:2:1]
[main] Setsockopt(1 29 2505000 4) on fd 20 [1:5:1]
[main] Setsockopt(1 1d 2505000 9e) on fd 21 [1:2:1]
[main] Setsockopt(1 8 2505000 4) on fd 22 [1:5:1]
[main] Setsockopt(1 a 2505000 4) on fd 23 [1:2:1]
[main] Setsockopt(1 24 2505000 4) on fd 24 [1:2:1]
[main] Setsockopt(1 2e 2505000 4) on fd 25 [1:2:1]
[main] Setsockopt(1 f 2505000 4) on fd 26 [1:2:1]
[main] Setsockopt(1 2d 2505000 4) on fd 29 [1:2:1]
[main] Setsockopt(1 2 2505000 28) on fd 31 [1:5:1]
[main] Setsockopt(1 2d 2505000 4) on fd 35 [1:1:1]
[main] Setsockopt(1 7 2505000 4) on fd 36 [1:5:1]
[main] Setsockopt(10e 3 2505000 4) on fd 37 [16:3:16]
[main] Setsockopt(1 2f 2505000 c) on fd 38 [1:5:1]
[main] Setsockopt(1 f 2505000 4) on fd 39 [16:3:16]
[main] Setsockopt(1 12 2505000 1f) on fd 40 [1:2:1]
[main] Setsockopt(1 2 2505000 67) on fd 42 [1:5:1]
[main] Setsockopt(1 1 2505000 b8) on fd 43 [1:2:1]
[main] Setsockopt(1 c 2505000 22) on fd 44 [1:5:1]
[main] Setsockopt(1 22 2505000 e3) on fd 45 [1:5:1]
[main] Setsockopt(1 8 2505000 4) on fd 46 [1:2:1]
[main] Setsockopt(1 12 2505000 5d) on fd 47 [1:5:1]
[main] Setsockopt(1 28 2505000 4) on fd 48 [16:3:2]
[main] Setsockopt(1 6 2505000 4) on fd 50 [1:1:1]
[main] Setsockopt(1 12 2505000 df) on fd 52 [1:1:1]
[main] Setsockopt(1 8 2505000 f3) on fd 54 [1:5:1]
[main] Setsockopt(1 9 2505000 4) on fd 57 [1:5:1]
[main] Setsockopt(1 2d 2505000 a) on fd 58 [1:1:1]
[main] Setsockopt(1 2c 2505000 3d) on fd 59 [1:5:1]
[main] Setsockopt(1 f 2505000 b6) on fd 60 [1:2:1]
[main] Setsockopt(1 f 2505000 3f) on fd 62 [1:2:1]
[main] Setsockopt(1 25 2505000 b1) on fd 63 [16:2:2]
[main] Setsockopt(1 20 2505000 4) on fd 64 [1:5:1]
[main] Setsockopt(1 28 2505000 58) on fd 65 [1:1:1]
[main] Setsockopt(1 8 2505000 28) on fd 66 [1:2:1]
[main] Setsockopt(1 21 2505000 c8) on fd 70 [1:2:1]
[main] Setsockopt(1 b 2505000 7a) on fd 73 [1:2:1]
[main] Setsockopt(1 b 2505000 4) on fd 77 [16:3:16]
[main] Setsockopt(1 10 2505000 75) on fd 79 [16:3:4]
[main] Setsockopt(1 10 2505000 4) on fd 81 [1:5:1]
[main] Setsockopt(10e 4 2505000 4) on fd 82 [16:3:2]
[main] Setsockopt(10e 5 0 2) on fd 85 [16:2:4]
[main] Setsockopt(1 29 2505000 59) on fd 88 [1:1:1]
[main] Setsockopt(10e 3 2505000 f4) on fd 89 [16:3:15]
[main] Setsockopt(1 25 2505000 4) on fd 90 [1:1:1]
[main] Setsockopt(1 20 2505000 4) on fd 92 [1:1:1]
[main] Setsockopt(1 7 2505000 4) on fd 93 [1:5:1]
[main] Setsockopt(10e 5 2505000 4) on fd 95 [16:2:4]
[main] Setsockopt(1 2f 2505000 4) on fd 96 [1:5:1]
[main] Setsockopt(1 24 2505000 8e) on fd 97 [1:2:1]
[main] Setsockopt(1 25 2505000 4) on fd 99 [1:2:1]
[main] Setsockopt(1 e 2505000 1c) on fd 100 [1:2:1]
[main] Setsockopt(1 2 2505000 4) on fd 101 [16:2:0]
[main] Setsockopt(1 c 2505000 6) on fd 104 [16:2:15]
[main] Setsockopt(10e 4 2505000 4) on fd 107 [16:3:15]
[main] Setsockopt(1 e 2505000 4) on fd 109 [16:2:4]
[main] Setsockopt(1 2a 2505000 1d) on fd 110 [1:2:1]
[main] Setsockopt(1 20 2505000 b2) on fd 112 [1:1:1]
[main] Setsockopt(1 25 2505000 4) on fd 114 [1:2:1]
[main] Setsockopt(10e 4 2505000 fa) on fd 115 [16:2:0]
[main] Setsockopt(1 8 2505000 ba) on fd 116 [1:2:1]
[main] Setsockopt(1 e 2505000 60) on fd 117 [1:1:1]
[main] Setsockopt(1 7 2505000 a0) on fd 118 [1:5:1]
[main] Setsockopt(1 2f 2505000 30) on fd 119 [1:1:1]
[main] Setsockopt(1 28 2505000 eb) on fd 121 [16:3:0]
[main] Setsockopt(1 2 2505000 4) on fd 123 [1:1:1]
[main] Setsockopt(1 b 2505000 20) on fd 124 [1:2:1]
[main] Setsockopt(1 25 2505000 fa) on fd 125 [16:3:16]
[main] Setsockopt(1 2d 2505000 4) on fd 126 [1:1:1]
[main] Setsockopt(10e 3 2505000 4) on fd 127 [16:2:16]
[main] Setsockopt(1 d 2505000 8) on fd 130 [1:1:1]
[main] Setsockopt(1 5 2505000 4) on fd 138 [1:5:1]
[main] Setsockopt(1 29 2505000 3f) on fd 141 [1:5:1]
[main] Setsockopt(10e 3 2505000 3f) on fd 142 [16:3:4]
[main] Setsockopt(1 2c 2505000 4) on fd 143 [1:2:1]
[main] Setsockopt(10e 3 2505000 32) on fd 144 [16:3:4]
[main] Setsockopt(1 2 2505000 4) on fd 146 [1:1:1]
[main] Setsockopt(1 d 2505000 8) on fd 147 [1:1:1]
[main] Setsockopt(1 d 2505000 8) on fd 148 [1:5:1]
[main] Setsockopt(10e 5 2505000 4) on fd 149 [16:3:16]
[main] Setsockopt(1 21 2505000 4) on fd 150 [1:1:1]
[main] Setsockopt(1 7 2505000 4) on fd 151 [16:3:0]
[main] Setsockopt(1 1d 2505000 4) on fd 153 [1:1:1]
[main] Setsockopt(1 22 2505000 e6) on fd 154 [16:3:4]
[main] Setsockopt(10e 3 2505000 ab) on fd 156 [16:3:16]
[main] Setsockopt(1 2e 2505000 4) on fd 157 [1:1:1]
[main] Setsockopt(1 9 2505000 95) on fd 158 [16:2:0]
[main] Setsockopt(1 1 2505000 32) on fd 159 [1:1:1]
[main] Setsockopt(1 23 2505000 4) on fd 160 [1:1:1]
[main] Setsockopt(1 22 2505000 fe) on fd 162 [1:5:1]
[main] Setsockopt(1 20 2505000 c7) on fd 163 [16:3:15]
[main] Setsockopt(1 5 2505000 4) on fd 164 [1:1:1]
[main] Setsockopt(10e 4 2505000 4) on fd 166 [16:3:0]
[main] Setsockopt(10e 5 2505000 4d) on fd 169 [16:2:16]
[main] Setsockopt(1 1 2505000 4) on fd 171 [1:5:1]
[main] Setsockopt(10e 4 2505000 b9) on fd 173 [16:3:16]
[main] Setsockopt(1 1 2505000 4) on fd 175 [16:2:2]
[main] Setsockopt(1 d 2505000 8) on fd 176 [1:5:1]
[main] Setsockopt(10e 5 2505000 28) on fd 183 [16:2:4]
[main] Setsockopt(1 22 2505000 a) on fd 184 [1:2:1]
[main] Setsockopt(1 22 2505000 4) on fd 185 [1:1:1]
[main] Setsockopt(1 7 2505000 30) on fd 187 [1:1:1]
[main] Setsockopt(1 2a 2505000 4) on fd 190 [1:2:1]
[main] Setsockopt(1 2 2505000 50) on fd 192 [1:2:1]
[main] Setsockopt(1 2b 2505000 4) on fd 194 [1:1:1]
[main] Setsockopt(1 29 2505000 f0) on fd 195 [1:5:1]
[main] Setsockopt(1 c 2505000 f8) on fd 197 [1:2:1]
[main] Setsockopt(1 a 2505000 22) on fd 198 [1:5:1]
[main] Setsockopt(1 24 2505000 4) on fd 199 [1:2:1]
[main] Setsockopt(1 22 2505000 b3) on fd 200 [1:5:1]
[main] Setsockopt(1 23 2505000 4) on fd 201 [16:2:15]
[main] Setsockopt(1 6 2505000 c) on fd 202 [1:1:1]
[main] Setsockopt(1 6 2505000 a8) on fd 203 [1:2:1]
[main] Setsockopt(1 6 2505000 61) on fd 206 [1:2:1]
[main] Setsockopt(1 a 2505000 e4) on fd 207 [1:5:1]
[main] Setsockopt(10e 2 2505000 cd) on fd 208 [16:2:15]
[main] Setsockopt(1 2 2505000 4) on fd 209 [1:1:1]
[main] Setsockopt(1 28 2505000 4) on fd 211 [1:1:1]
[main] Setsockopt(10e 5 2505000 4) on fd 212 [16:3:16]
[main] Setsockopt(1 2a 2505000 18) on fd 213 [1:5:1]
[main] Setsockopt(1 25 2505000 9c) on fd 214 [1:1:1]
[main] Setsockopt(1 2c 2505000 f8) on fd 215 [1:1:1]
[main] Setsockopt(1 21 2505000 4) on fd 216 [1:5:1]
[main] Setsockopt(1 25 2505000 4) on fd 217 [1:2:1]
[main] Setsockopt(1 12 2505000 4) on fd 218 [1:5:1]
[main] Setsockopt(1 25 2505000 4d) on fd 219 [1:2:1]
[main] Setsockopt(1 e 2505000 4) on fd 220 [1:2:1]
[main] Setsockopt(10e 3 2505000 4) on fd 221 [16:2:0]
[main] Setsockopt(1 21 2505000 4) on fd 222 [1:1:1]
[main] Setsockopt(10e 1 2505000 4) on fd 224 [16:2:16]
[main] Setsockopt(1 6 2505000 4d) on fd 230 [1:2:1]
[main] Setsockopt(1 24 2505000 dc) on fd 231 [1:1:1]
[main] Setsockopt(1 25 2505000 4) on fd 232 [1:1:1]
[main] Setsockopt(1 8 2505000 90) on fd 233 [16:2:0]
[main] Setsockopt(1 b 2505000 37) on fd 236 [1:5:1]
[main] Setsockopt(1 e 2505000 4) on fd 237 [16:2:15]
[main] Setsockopt(1 22 2505000 8e) on fd 238 [1:5:1]
[main] Setsockopt(1 25 2505000 b7) on fd 239 [1:2:1]
[main] Setsockopt(1 f 2505000 78) on fd 242 [1:5:1]
[main] Setsockopt(1 7 2505000 4) on fd 243 [1:1:1]
[main] Setsockopt(1 c 2505000 eb) on fd 248 [1:2:1]
[main] Setsockopt(1 6 2505000 21) on fd 249 [1:2:1]
[main] Setsockopt(1 24 2505000 4) on fd 250 [1:5:1]
[main] Setsockopt(1 20 2505000 4f) on fd 251 [1:1:1]
[main] Setsockopt(1 2e 2505000 4) on fd 252 [1:2:1]
[main] Setsockopt(1 c 2505000 4) on fd 253 [1:2:1]
[main] Setsockopt(10e 5 2505000 34) on fd 255 [16:3:16]
[main] Setsockopt(1 25 2505000 4) on fd 257 [1:1:1]
[main] Setsockopt(1 6 2505000 4) on fd 258 [1:5:1]
[main] Setsockopt(1 d 2505000 8) on fd 259 [16:2:2]
[main] Setsockopt(1 2a 2505000 4) on fd 260 [1:5:1]
[main] Setsockopt(1 28 2505000 a0) on fd 263 [1:1:1]
[main] Setsockopt(1 9 2505000 4) on fd 266 [1:1:1]
[main] Setsockopt(1 2c 2505000 4) on fd 270 [16:2:2]
[main] Setsockopt(1 1d 2505000 4) on fd 272 [1:1:1]
[main] Setsockopt(10e 5 2505000 f4) on fd 275 [16:2:0]
[main] Setsockopt(1 22 2505000 fa) on fd 278 [1:2:1]
[main] Setsockopt(1 28 2505000 4) on fd 281 [1:2:1]
[main] Setsockopt(1 6 2505000 4) on fd 282 [1:2:1]
[main] Setsockopt(1 e 2505000 f4) on fd 283 [1:2:1]
[main] Setsockopt(1 c 2505000 4) on fd 284 [1:5:1]
[main] Setsockopt(1 12 2505000 4) on fd 285 [1:1:1]
[main] Setsockopt(1 2 2505000 4) on fd 287 [1:1:1]
[main] Setsockopt(10e 5 2505000 33) on fd 290 [16:3:16]
[main] Setsockopt(1 f 2505000 4) on fd 292 [1:2:1]
[main] Setsockopt(1 2f 2505000 4) on fd 294 [1:2:1]
[main] Setsockopt(1 20 2505000 4) on fd 295 [1:1:1]
[main] Setsockopt(10e 5 2505000 4) on fd 297 [16:2:16]
[main] Setsockopt(1 23 2505000 4) on fd 298 [1:1:1]
[main] Setsockopt(1 12 2505000 a0) on fd 299 [1:5:1]
[main] Setsockopt(1 29 2505000 90) on fd 302 [1:1:1]
[main] Setsockopt(1 8 2505000 4) on fd 303 [1:5:1]
[main] Setsockopt(1 2d 2505000 4) on fd 304 [1:1:1]
[main] Setsockopt(1 8 2505000 31) on fd 305 [1:1:1]
[main] Setsockopt(1 2e 2505000 4) on fd 308 [1:5:1]
[main] Setsockopt(1 e 2505000 8b) on fd 309 [1:2:1]
[main] Setsockopt(1 2f 2505000 4) on fd 310 [1:1:1]
[main] Setsockopt(1 21 2505000 4) on fd 311 [1:1:1]
[main] Setsockopt(10e 1 2505000 4) on fd 312 [16:2:4]
[main] Setsockopt(1 e 2505000 ba) on fd 313 [1:2:1]
[main] Setsockopt(1 a 2505000 45) on fd 314 [1:1:1]
[main] Setsockopt(1 1d 2505000 d4) on fd 315 [1:5:1]
[main] Setsockopt(1 23 2505000 4) on fd 316 [1:5:1]
[main] Setsockopt(10e 5 2505000 f8) on fd 317 [16:2:15]
[main] Setsockopt(1 28 2505000 c6) on fd 318 [1:2:1]
[main] Setsockopt(1 e 2505000 ac) on fd 323 [1:2:1]
[main] Setsockopt(1 5 2505000 4) on fd 324 [1:5:1]
[main] Setsockopt(1 2e 2505000 4) on fd 327 [1:2:1]
[main] Setsockopt(1 2e 2505000 99) on fd 328 [1:1:1]
[main] Setsockopt(1 29 2505000 53) on fd 329 [1:5:1]
[main] Setsockopt(10e 5 2505000 1a) on fd 331 [16:2:15]
[main] Setsockopt(1 d 2505000 8) on fd 333 [16:2:2]
[main] Setsockopt(1 2f 2505000 45) on fd 334 [1:1:1]
[main] Setsockopt(1 29 2505000 4) on fd 337 [1:2:1]
[main] Setsockopt(1 2b 2505000 90) on fd 339 [1:1:1]
[main] Setsockopt(1 22 2505000 96) on fd 340 [1:2:1]
[main] Setsockopt(1 24 2505000 35) on fd 341 [1:1:1]
[main] Setsockopt(1 2c 2505000 4) on fd 344 [1:1:1]
[main] Setsockopt(1 29 2505000 18) on fd 345 [16:2:2]
[main] Setsockopt(1 2a 2505000 c2) on fd 346 [1:5:1]
[main] Setsockopt(1 23 2505000 4) on fd 347 [1:2:1]
[main] Setsockopt(1 21 2505000 e2) on fd 348 [1:2:1]
[main] Setsockopt(1 20 2505000 53) on fd 349 [1:5:1]
[main] Setsockopt(1 1 2505000 4) on fd 351 [16:3:16]
[main] Setsockopt(1 10 2505000 4) on fd 352 [1:5:1]
[main] Setsockopt(1 29 2505000 ff) on fd 353 [1:1:1]
[main] Setsockopt(1 28 2505000 1b) on fd 355 [16:3:16]
[main] Setsockopt(1 1d 2505000 51) on fd 356 [1:5:1]
[main] Setsockopt(1 22 2505000 f8) on fd 357 [1:2:1]
[main] Setsockopt(1 f 2505000 4) on fd 360 [1:5:1]
[main] Setsockopt(1 2c 2505000 6c) on fd 361 [1:2:1]
[main] Setsockopt(1 2 2505000 4) on fd 365 [1:1:1]
[main] Setsockopt(1 1 2505000 4) on fd 366 [1:2:1]
[main] Setsockopt(1 7 2505000 8) on fd 367 [1:1:1]
[main] Setsockopt(1 b 2505000 60) on fd 371 [1:5:1]
[main] Setsockopt(1 23 2505000 8) on fd 372 [1:2:1]
[main] Setsockopt(1 1 2505000 4) on fd 377 [1:1:1]
[main] Setsockopt(1 c 2505000 e6) on fd 378 [1:5:1]
[main] Setsockopt(1 12 2505000 9e) on fd 379 [1:2:1]
[main] Setsockopt(1 12 2505000 4) on fd 380 [1:5:1]
[main] 375 sockets created based on info from socket cachefile.
[main] Generating file descriptors
[main] Added 298 filenames from /dev
[main] Added 7146 filenames from /proc
[main] Added 12639 filenames from /sys
[child0:361] set_mempolicy (238) returned ENOSYS, marking as inactive.
[child0:361] io_setup (206) returned ENOSYS, marking as inactive.
[child0:361] mq_timedsend (242) returned ENOSYS, marking as inactive.
[child0:361] uid changed! Was: 0, now 1
Bailing main loop. Exit reason: UID changed.
[watchdog] [359] Watchdog exiting
[init]=20
Ran 41 syscalls. Successes: 13  Failures: 28
[   63.343052] Writes:  Total: 2  Max/Min: 0/0   Fail: 0=20
error: 'rc.local' exited outside the expected code flow.
umount: /run/lock: not mounted
 * Will now restart
[   74.839559] spin_lock-torture: Unscheduled system shutdown detected
[   74.843263] reboot: Restarting system

Elapsed time: 100
qemu-system-x86_64 -enable-kvm -cpu kvm64 -kernel /pkg/linux/x86_64-randcon=
fig-n0-06191536/gcc-4.9/1bf1735b478008c30acaff18ec6f4a3ff211c28a/vmlinuz-4.=
1.0-rc5-00034-g1bf1735 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115=
200 systemd.log_level=3Derr debug apic=3Ddebug sysrq_always_enabled rcupdat=
e.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests=
/run-queue/kvm/x86_64-randconfig-n0-06191536/linux-devel:devel-hourly-20150=
61911:1bf1735b478008c30acaff18ec6f4a3ff211c28a:bisect-linux-3/.vmlinuz-1bf1=
735b478008c30acaff18ec6f4a3ff211c28a-20150619172952-15-intel12 branch=3Dlin=
ux-devel/devel-hourly-2015061911 BOOT_IMAGE=3D/pkg/linux/x86_64-randconfig-=
n0-06191536/gcc-4.9/1bf1735b478008c30acaff18ec6f4a3ff211c28a/vmlinuz-4.1.0-=
rc5-00034-g1bf1735 drbd.minor_count=3D8'  -initrd /osimage/quantal/quantal-=
core-x86_64.cgz -m 300 -smp 2 -device e1000,netdev=3Dnet0 -netdev user,id=
=3Dnet0 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltim=
e -drive file=3D/fs/KVM/disk0-quantal-intel12-45,media=3Ddisk,if=3Dvirtio -=
drive file=3D/fs/KVM/disk1-quantal-intel12-45,media=3Ddisk,if=3Dvirtio -dri=
ve file=3D/fs/KVM/disk2-quantal-intel12-45,media=3Ddisk,if=3Dvirtio -drive =
file=3D/fs/KVM/disk3-quantal-intel12-45,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/KVM/disk4-quantal-intel12-45,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/KVM/disk5-quantal-intel12-45,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/KVM/disk6-quantal-intel12-45,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm=
/kboot/pid-quantal-intel12-45 -serial file:/dev/shm/kboot/serial-quantal-in=
tel12-45 -daemonize -display none -monitor null=20

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.1.0-rc5-00034-g1bf1735"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.1.0-rc5 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_GENERIC_MSI_IRQ=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
CONFIG_SRCU=y
# CONFIG_TASKS_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_KTHREAD_PRIO=0
# CONFIG_RCU_EXPEDITE_BOOT is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
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
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_ADVISE_SYSCALLS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
CONFIG_IOSF_MBI_DEBUG=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_UP_LATE_INIT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_CMA_DEBUGFS=y
CONFIG_CMA_AREAS=7
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_PMEM_LEGACY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
# CONFIG_MTD_PCMCIA is not set
CONFIG_MTD_GPIO_ADDR=y
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_GPIO=y
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_NAND_HISI504=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_FOCALTECH is not set
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_ELAN_I2C=y
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_SERIAL_WACOM4=y
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_PCAP is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_SX8654=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
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
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVMEM=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
# CONFIG_IPMI_SSIF is not set
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_CRB is not set
# CONFIG_TCG_TIS_ST33ZP24 is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
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
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_CADENCE=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
# CONFIG_PPS is not set

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y

#
# MFD GPIO expanders
#
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_CRYSTAL_COVE=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2406 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX77693=y
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_MENF21BMC_HWMON=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NCT7802 is not set
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_BANG_BANG=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set
# CONFIG_INT340X_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_DA9150=y
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
CONFIG_INTEL_SOC_PMIC=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX77843 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RT5033=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_RN5T618=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SKY81452=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_DA9211 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_PCAP=y
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_PWM is not set
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_RN5T618=y
CONFIG_REGULATOR_RT5033=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_SKY81452 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_SG=y
CONFIG_VIDEOBUF2_DVB=y
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=y
CONFIG_VIDEO_FB_IVTV=y
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
CONFIG_VIDEO_ZORAN_ZR36060=y
# CONFIG_VIDEO_ZORAN_BUZ is not set
CONFIG_VIDEO_ZORAN_DC10=y
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_MXB=y
CONFIG_VIDEO_TW68=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CX25821=y
# CONFIG_VIDEO_CX88 is not set
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=y
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
# CONFIG_DVB_AV7110_OSD is not set
# CONFIG_DVB_BUDGET_CORE is not set
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=y
CONFIG_DVB_DM1105=y
# CONFIG_DVB_PT1 is not set
CONFIG_DVB_PT3=y
CONFIG_MANTIS_CORE=y
CONFIG_DVB_MANTIS=y
# CONFIG_DVB_HOPPER is not set
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y
CONFIG_DVB_SMIPCIE=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_IR_I2C=y

#
# Encoders, decoders, sensors and other helper chips
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
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_ADV7604=y
# CONFIG_VIDEO_ADV7842 is not set
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_ADV7511=y
CONFIG_VIDEO_AD9389B=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV9650 is not set
CONFIG_VIDEO_S5K4ECGX=y
# CONFIG_VIDEO_S5K5BAF is not set
CONFIG_VIDEO_S5C73M3=y

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
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MSI001 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88RS6000T=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_SI2157=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y
CONFIG_MEDIA_TUNER_MXL301RF=y
CONFIG_MEDIA_TUNER_QM1D1C0042=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
CONFIG_DVB_TDA18271C2DD=y
# CONFIG_DVB_SI2165 is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=y
# CONFIG_DVB_MT312 is not set
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=y
# CONFIG_DVB_CX24116 is not set
# CONFIG_DVB_CX24117 is not set
CONFIG_DVB_SI21XX=y
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=y
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=y
# CONFIG_DVB_TDA10048 is not set
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
# CONFIG_DVB_HD29L2 is not set
# CONFIG_DVB_STV0367 is not set
# CONFIG_DVB_CXD2820R is not set
# CONFIG_DVB_AS102_FE is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LGDT3306A=y
# CONFIG_DVB_LG2160 is not set
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
# CONFIG_DVB_DIB8000 is not set
# CONFIG_DVB_MB86A20S is not set

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_DRX39XYJ is not set
CONFIG_DVB_LNBP21=y
# CONFIG_DVB_LNBP22 is not set
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
# CONFIG_DVB_A8293 is not set
CONFIG_DVB_SP2=y
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=y
# CONFIG_DVB_IX2505V is not set
# CONFIG_DVB_M88RS2000 is not set
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_ADV7511=y
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_USERPTR=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I810=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VGEM=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SM501=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_SKY81452=y
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_HIDPP=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PICOLCD_CIR is not set
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MMC_TOSHIBA_PCI=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_MENF21BMC=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_PM8941_WLED is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_IE31200 is not set
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_HSU_DMA=y
CONFIG_HSU_DMA_PCI=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y
# CONFIG_CROS_EC_CHARDEV is not set
CONFIG_CROS_EC_LPC=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_PCC is not set
CONFIG_ALTERA_MBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_SOC_TI is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_RT8973A is not set
# CONFIG_EXTCON_SM5502 is not set
CONFIG_EXTCON_USB_GPIO=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=y
CONFIG_PWM_LPSS_PCI=y
# CONFIG_PWM_LPSS_PLATFORM is not set
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_OVERLAY_FS=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_DEBUG_TIMEKEEPING is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_HEXDUMP is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
# CONFIG_TEST_UDELAY is not set
# CONFIG_MEMTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA1_MB=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_KVM_COMPAT=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_INTERVAL_TREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--45Z9DzgjV8m4Oswq--
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
