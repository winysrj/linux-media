Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51427 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbeHJUX7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 16:23:59 -0400
Date: Sat, 11 Aug 2018 01:52:54 +0800
From: kernel test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LKP <lkp@01.org>, linux-media@vger.kernel.org
Subject: 3354b54f9f ("media: vivid: shut up warnings due to a .."):  BUG:
 unable to handle kernel paging request at ffffc90000393131
Message-ID: <5b6dd0f6.UevvLZNG23+VRrs8%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_5b6dd0f6.BT2fvZOcapeDFhz3rszcEIsJI08UJrO9//6xcxLP6e9LFQjq"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_5b6dd0f6.BT2fvZOcapeDFhz3rszcEIsJI08UJrO9//6xcxLP6e9LFQjq
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit 3354b54f9f7037a1122d3b6009aa9d39829d6843
Author:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
AuthorDate: Tue Aug 7 07:29:12 2018 -0400
Commit:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
CommitDate: Wed Aug 8 10:57:14 2018 -0400

    media: vivid: shut up warnings due to a non-trivial logic
    
    The vivid driver uses a complex logic to save one kalloc/kfree
    allocation. That non-trivial way of allocating data causes
    smatch to warn:
            drivers/media/platform/vivid/vivid-core.c:869 vivid_create_instance() warn: potentially one past the end of array 'dev->query_dv_timings_qmenu[dev->query_dv_timings_size]'
            drivers/media/platform/vivid/vivid-core.c:869 vivid_create_instance() warn: potentially one past the end of array 'dev->query_dv_timings_qmenu[dev->query_dv_timings_size]'
    
    I also needed to read the code several times in order to understand
    what it was desired there. It turns that the logic was right,
    although confusing to read.
    
    As it is doing allocations on a non-standard way, let's add some
    documentation while shutting up the false positive.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

845b978a87  media: rtl28xxu: be sure that it won't go past the array size
3354b54f9f  media: vivid: shut up warnings due to a non-trivial logic
4110b42356  Add linux-next specific files for 20180810
+------------------------------------------+------------+------------+---------------+
|                                          | 845b978a87 | 3354b54f9f | next-20180810 |
+------------------------------------------+------------+------------+---------------+
| boot_successes                           | 71         | 0          | 0             |
| boot_failures                            | 0          | 19         | 19            |
| BUG:unable_to_handle_kernel              | 0          | 17         | 19            |
| Oops:#[##]                               | 0          | 17         | 19            |
| RIP:vivid_probe                          | 0          | 17         | 19            |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 17         | 19            |
| BUG:kernel_hang_in_test_stage            | 0          | 2          |               |
+------------------------------------------+------------+------------+---------------+

[  248.812686] serial_ir serial_ir.0: use 'setserial /dev/ttySX uart none'
[  248.817736] serial_ir serial_ir.0: or compile the serial port driver as module and
[  248.823158] serial_ir serial_ir.0: make sure this module is loaded first
[  248.828672] serial_ir: probe of serial_ir.0 failed with error -16
[  248.834846] vivid-000: using single planar format API
[  248.847809] BUG: unable to handle kernel paging request at ffffc90000393131
[  248.848015] PGD 1a043067 P4D 1a043067 PUD 1a044067 PMD 19423067 PTE 0
[  248.848015] Oops: 0002 [#1] DEBUG_PAGEALLOC KASAN
[  248.848015] CPU: 0 PID: 1 Comm: swapper Not tainted 4.18.0-rc2-00394-g3354b54 #1
[  248.848015] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[  248.848015] RIP: 0010:vivid_probe+0x1834/0x38f0
[  248.848015] Code: 49 8b 9f 30 52 00 00 be 00 01 00 00 48 89 df e8 02 80 b1 fe 48 8b 05 6b d8 5c 01 48 8d 7b 08 48 c7 c6 a0 66 76 95 48 83 e7 f8 <48> 89 03 48 8b 05 4a d9 5c 01 48 89 83 f8 00 00 00 48 29 fb 8d 8b 
[  248.848015] RSP: 0000:ffff88001a097a90 EFLAGS: 00010282
[  248.848015] RAX: 00ffffffffffff00 RBX: ffffc90000393131 RCX: ffffffff94198e2e
[  248.848015] RDX: 0000000000000001 RSI: ffffffff957666a0 RDI: ffffc90000393138
[  248.848015] RBP: 0000000000000000 R08: fffff52000072647 R09: fffff52000072647
[  248.848015] R10: 0000000000000000 R11: fffff52000072646 R12: ffff880017ac0248
[  248.848015] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880017ac0240
[  248.848015] FS:  0000000000000000(0000) GS:ffffffff9607b000(0000) knlGS:0000000000000000
[  248.848015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  248.848015] CR2: ffffc90000393131 CR3: 000000000d825001 CR4: 00000000001606f0
[  248.848015] Call Trace:
[  248.848015]  ? vivid_dev_release+0xc0/0xc0
[  248.848015]  ? acpi_dev_pm_attach+0x27/0xd0
[  248.848015]  platform_drv_probe+0x4b/0xb0
[  248.848015]  driver_probe_device+0x33c/0x470
[  248.848015]  __driver_attach+0x12e/0x130
[  248.848015]  ? driver_probe_device+0x470/0x470
[  248.848015]  bus_for_each_dev+0xf4/0x150
[  248.848015]  ? lock_downgrade+0x2e0/0x2e0
[  248.848015]  ? bus_remove_file+0x70/0x70
[  248.848015]  bus_add_driver+0x271/0x300
[  248.848015]  ? set_debug_rodata+0xc/0xc
[  248.848015]  driver_register+0xca/0x1b0
[  248.848015]  ? saa7146_vv_init_module+0x3/0x3
[  248.848015]  vivid_init+0x1f/0x39
[  248.848015]  do_one_initcall+0xc0/0x1c1
[  248.848015]  ? start_kernel+0x4fd/0x4fd
[  248.848015]  ? lock_downgrade+0x2e0/0x2e0
[  248.848015]  kernel_init_freeable+0x19c/0x236
[  248.848015]  ? rest_init+0xe0/0xe0
[  248.848015]  kernel_init+0xa/0x120
[  248.848015]  ? rest_init+0xe0/0xe0
[  248.848015]  ret_from_fork+0x1f/0x30
[  248.848015] CR2: ffffc90000393131
[  248.848015] ---[ end trace f4cdabe70826edee ]---
[  248.848015] RIP: 0010:vivid_probe+0x1834/0x38f0

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start 1c2f2531cf8b25cd291c356e734d1db2f290ba8a 1ffaddd029c867d134a1dde39f540dcc8c52e274 --
git bisect good 36241ec9b56bd446bd742b57b657620d68aaa33a  # 19:40  G     10     0    0   0  Merge remote-tracking branch 'hwmon-staging/hwmon-next'
git bisect  bad 9380f4dcadc21d0af1bed88d66eab0afa44b387c  # 19:56  B      0     1   15   0  Merge remote-tracking branch 'vfio/next'
git bisect  bad 4b4bd9befef4b2f4867c00168ada4223d68d3f86  # 20:18  B      0     1   15   0  Merge remote-tracking branch 'sunxi-drm/sunxi-drm/for-next'
git bisect  bad 438e21624bf224a4be6d2f1dc7f1edb4a95716d0  # 20:37  B      0     1   15   0  Merge remote-tracking branch 'netfilter-next/master'
git bisect  bad 56588d3bea1fa94d24ef8b7ff606fec281d9caf8  # 21:00  B      0     1   15   0  Merge remote-tracking branch 'thermal/next'
git bisect  bad 61ccc9929e2ac336e54241662f81f10689b41f80  # 21:20  B      0     2   16   0  Merge remote-tracking branch 'v4l-dvb/master'
git bisect good 65949c111072500a09709cfc3c9796b58acdf6be  # 21:49  G     10     0    0   0  Merge remote-tracking branch 'jc_docs/docs-next'
git bisect good 5f43f90a99ade6db0c05e2bb45883256649c9164  # 22:14  G     10     0    0   0  media: venus: hfi: handle buffer output2 type as well
git bisect good 3153dfe2914bec728cab9a5c9d7b2ec71d714d9c  # 22:39  G     10     0    1   1  media: ddbridge/sx8: disable automatic PLS code search
git bisect good ad1363c05a7d65ce6d4c5dca1fdec823b58d6e8b  # 23:09  G     11     0    0   0  media: omap2: omapfb: fix ifnullfree.cocci warnings
git bisect good d81469d2b77553b281b9b59eadd995309728f506  # 23:34  G     10     0    0   0  media: sh_veu: convert to SPDX identifiers
git bisect good 845b978a871bff3707eee611b32e4be0b9a94dd2  # 23:50  G     11     0    1   1  media: rtl28xxu: be sure that it won't go past the array size
git bisect  bad 484f9b372dd8da6a4a9867ebcd10e5c2b21ab478  # 00:04  B      0     3   17   0  media: mt9v111: Fix build error with no VIDEO_V4L2_SUBDEV_API
git bisect  bad 3fcb3c836ef413d3fc848288b308eb655e08d853  # 00:27  B      0     2   16   0  media: tuner-xc2028: don't use casts for printing sizes
git bisect  bad 40e431112c63296a6130810ab62a5fe73953f074  # 00:44  B      0     1   15   0  media: cleanup fall-through comments
git bisect  bad 3354b54f9f7037a1122d3b6009aa9d39829d6843  # 00:49  B      0    17   53   2  media: vivid: shut up warnings due to a non-trivial logic
# first bad commit: [3354b54f9f7037a1122d3b6009aa9d39829d6843] media: vivid: shut up warnings due to a non-trivial logic
git bisect good 845b978a871bff3707eee611b32e4be0b9a94dd2  # 01:00  G     32     0    0   1  media: rtl28xxu: be sure that it won't go past the array size
# extra tests on HEAD of linux-next/master
git bisect  bad 1c2f2531cf8b25cd291c356e734d1db2f290ba8a  # 01:01  B      0    25   61   0  Add linux-next specific files for 20180809
# extra tests on tree/branch linux-next/master
git bisect  bad 4110b42356f3f8e237659eb85b0ec1f479044cdf  # 01:22  B      0     2   16   0  Add linux-next specific files for 20180810
# extra tests with first bad commit reverted
git bisect good 415916742e95b589052e8486d8a9ebee8e54da9c  # 01:52  G     11     0    0   0  Revert "media: vivid: shut up warnings due to a non-trivial logic"

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--=_5b6dd0f6.BT2fvZOcapeDFhz3rszcEIsJI08UJrO9//6xcxLP6e9LFQjq
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-yocto-ivb41-102:20180810094315:x86_64-randconfig-s4-08100617:4.18.0-rc2-00394-g3354b54:1.gz"

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

--=_5b6dd0f6.BT2fvZOcapeDFhz3rszcEIsJI08UJrO9//6xcxLP6e9LFQjq
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-yocto-vp-52:20180810234939:x86_64-randconfig-s4-08100617:4.18.0-rc2-00393-g845b978:2.gz"

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
BczcAnZuAZcKvHr77vbNb159wgWffnp6plv5Y3BLZ159crG7w1zogkzoYPPwsvi31dP73c3N
5//wdLt7wP9XD/RLWgks/j79TV+gQz1uF6/vn2i5ebV7zedN/y/fKsVJLjdXf6UCtwua0NLf
T7cPC0l/b7Fg2S12eFI+v9s90/Eb+kvQT+loAaD28+tt+S1mCQVJereB1f3F4w5f0uf3q+fN
D9v7q8W100LsntaN7y6wVrq/W2x365cr+v7xebNYr552b/jNje6H2jzScoo7/pvDzvb57W57
veIfPr/ev3lHC/br+5FC8pRC6pRC+pRC5pRC9pRC7lghurvXtIJ4et4mH9dPDzernxY0GOGG
3N5TF6LRDuT4q9++egXM5G6LbvxIt/zNa+ogrx9Xt9Qxfni5uyqQ8NXd9eYNda7iVq8e6LD4
TP3+8S/L1c371U9Py9Tpt+Rr8/KwpYfokj4sqfdjqXtzs0SnuH95fkN989Un1P0ur/dYDjy9
ocMH6tzPby/p/G9vn67e3N/RV3zeCzrx0/3+GUvol4e6Mne318uyL77hb199cn//8FR+vrlf
bZd0KWigNwonuL99eK6+oVNuH9fby9vru/vH5YbW2s9vAl8PPcdbmn5eLW9273Y3b3aPj68+
ub66wwKGvuUvX32yub97uqf78vz8E3narR5vfkpXgG/+S3xOU0aFq2zYNb59d7V6Qw5vaYb7
yeP7V5+sH1d3mx/e3FzfvfxIj+mPz69vV2C2X33yL99++93y9998+a9fv3n98PbqNZu8TiPA
BZXa0gn211cXT+aCpvdCOOlfX202F/51sR1hFbxc7/faC7/b7WiNudZqZ9Y7sY6raLZb9frd
LZz+9eLojob+lsI93j3uL59+eHkG/UItSv3p7/7+/9KY9+f/9f1//93iInWuBX2XPv35M/r6
1f8HQJ/Kw/weAgA=

--=_5b6dd0f6.BT2fvZOcapeDFhz3rszcEIsJI08UJrO9//6xcxLP6e9LFQjq
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce-yocto-ivb41-102:20180810094315:x86_64-randconfig-s4-08100617:4.18.0-rc2-00394-g3354b54:1"

#!/bin/bash

kernel=$1
initrd=yocto-trinity-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/yocto/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 512
	-smp 1
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
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
	rcuperf.shutdown=0
)

"${kvm[@]}" -append "${append[*]}"

--=_5b6dd0f6.BT2fvZOcapeDFhz3rszcEIsJI08UJrO9//6xcxLP6e9LFQjq
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-4.18.0-rc2-00394-g3354b54"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.18.0-rc2 Kernel Configuration
#

#
# Compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
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
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=70300
CONFIG_CLANG_VERSION=0
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
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
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TINY_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
CONFIG_CGROUP_RDMA=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
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
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
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
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
CONFIG_SYSTEM_DATA_VERIFICATION=y
# CONFIG_PROFILING is not set
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_STATIC_KEYS_SELFTEST=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_CLK=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_GCC_PLUGIN_STRUCTLEAK=y
CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_ISA_BUS_API=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
# CONFIG_REFCOUNT_FULL is not set

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_ZONED is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
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
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_MQ_IOSCHED_DEADLINE is not set
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
# CONFIG_RETPOLINE is not set
CONFIG_INTEL_RDT=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
CONFIG_IOSF_MBI_DEBUG=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_XEN_PVH=y
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_JAILHOUSE_GUEST=y
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_NR_CPUS_RANGE_BEGIN=1
CONFIG_NR_CPUS_RANGE_END=1
CONFIG_NR_CPUS_DEFAULT=1
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
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
# CONFIG_PERF_EVENTS_INTEL_RAPL is not set
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
CONFIG_PERF_EVENTS_AMD_POWER=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_X86_5LEVEL is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_GENERIC_GUP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_Z3FOLD=y
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_ZONE_DEVICE=y
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_PERCPU_STATS=y
# CONFIG_GUP_BENCHMARK is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
# CONFIG_X86_PMEM_LEGACY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_UMIP=y
CONFIG_X86_INTEL_MPX=y
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0x0
CONFIG_COMPAT_VDSO=y
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
CONFIG_PM_GENERIC_DOMAINS=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_PM_GENERIC_DOMAINS_SLEEP=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
CONFIG_DPTF_POWER=y
CONFIG_ACPI_WATCHDOG=y
CONFIG_PMIC_OPREGION=y
CONFIG_CRC_PMIC_OPREGION=y
CONFIG_CHT_WC_PMIC_OPREGION=y
CONFIG_CHT_DC_TI_PMIC_OPREGION=y
CONFIG_ACPI_CONFIGFS=y
CONFIG_TPS68470_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_PCI_PF_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#

#
# DesignWare PCI Core Support
#

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y
CONFIG_RAPIDIO_CHMAN=y
# CONFIG_RAPIDIO_MPORT_CDEV is not set

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_RXS_GEN3=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_XDP_SOCKETS=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_LOG_NETDEV is not set
# CONFIG_NF_TABLES is not set
# CONFIG_NETFILTER_XTABLES is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_SOCKET_IPV4 is not set
# CONFIG_NF_TPROXY_IPV4 is not set
# CONFIG_NF_DUP_IPV4 is not set
# CONFIG_NF_LOG_ARP is not set
# CONFIG_NF_LOG_IPV4 is not set
# CONFIG_NF_REJECT_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_SOCKET_IPV6 is not set
# CONFIG_NF_TPROXY_IPV6 is not set
# CONFIG_NF_DUP_IPV6 is not set
# CONFIG_NF_REJECT_IPV6 is not set
# CONFIG_NF_LOG_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=y
CONFIG_IEEE802154_NL802154_EXPERIMENTAL=y
CONFIG_IEEE802154_SOCKET=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BATMAN_V is not set
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_BATMAN_ADV_DEBUGFS is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_NET_NSH is not set
CONFIG_HSR=y
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_NET_NCSI is not set
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_BT=y
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_LEDS is not set
CONFIG_BT_SELFTEST=y
# CONFIG_BT_SELFTEST_ECDH is not set
CONFIG_BT_SELFTEST_SMP=y
CONFIG_BT_DEBUGFS=y

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=y
CONFIG_BT_BCM=y
CONFIG_BT_QCA=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_SERDEV=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_NOKIA=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIUART_INTEL=y
CONFIG_BT_HCIUART_BCM=y
CONFIG_BT_HCIUART_QCA=y
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIUART_MRVL is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
CONFIG_MAC80211_STA_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_OCB_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_XEN=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_TRF7970A is not set
# CONFIG_NFC_MEI_PHY is not set
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544_I2C is not set
CONFIG_NFC_PN533=y
CONFIG_NFC_PN533_I2C=y
# CONFIG_NFC_MICROREAD_I2C is not set
CONFIG_NFC_ST21NFCA=y
CONFIG_NFC_ST21NFCA_I2C=y
CONFIG_NFC_ST95HF=y
# CONFIG_PSAMPLE is not set
CONFIG_NET_IFE=y
# CONFIG_LWTUNNEL is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_FAILOVER=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_W1=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_VIRTIO_BLK=y
CONFIG_VIRTIO_BLK_SCSI=y
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y

#
# NVME Support
#
CONFIG_NVME_CORE=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_NVME_MULTIPATH is not set
CONFIG_NVME_FABRICS=y
CONFIG_NVME_FC=y
# CONFIG_NVME_TARGET is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_EEPROM_IDT_89HPESX=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
CONFIG_VOP_BUS=y

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
CONFIG_VOP=y
CONFIG_VHOST_RING=y
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
# CONFIG_MISC_RTSX_PCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_NET is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGB_DCA=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
# CONFIG_IXGBE_DCB is not set
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_NI=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_ALE is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_MDIO_DEVICE is not set
# CONFIG_PHYLIB is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH6KL is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT76x2E is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
CONFIG_RTL_CARDS=y
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PEARL_PCIE is not set
# CONFIG_MAC80211_HWSIM is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_THUNDERBOLT_NET is not set
# CONFIG_HYPERV_NET is not set
# CONFIG_NETDEVSIM is not set
# CONFIG_NET_FAILOVER is not set
# CONFIG_ISDN is not set
CONFIG_NVM=y
# CONFIG_NVM_DEBUG is not set
# CONFIG_NVM_PBLK is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_LEDS is not set
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADC=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_DLINK_DIR685=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_SAMSUNG is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TM2_TOUCHKEY=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_PSXPAD_SPI=y
# CONFIG_JOYSTICK_PSXPAD_SPI_FF is not set
# CONFIG_JOYSTICK_PXRC is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_ATMEL_MXT_T37=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CHIPONE_ICN8505=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX_SERIAL=y
CONFIG_TOUCHSCREEN_EXC3000=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
CONFIG_TOUCHSCREEN_HIDEEP=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_S6SY761=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
CONFIG_TOUCHSCREEN_ELAN=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WDT87XX_I2C=y
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC200X_CORE=y
# CONFIG_TOUCHSCREEN_TSC2004 is not set
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_PCAP=y
# CONFIG_TOUCHSCREEN_RM_TS is not set
CONFIG_TOUCHSCREEN_SILEAD=y
CONFIG_TOUCHSCREEN_SIS_I2C=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMFTS=y
CONFIG_TOUCHSCREEN_SURFACE3_SPI=y
# CONFIG_TOUCHSCREEN_SX8654 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZET6223=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_TOUCHSCREEN_ROHM_BU21023=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_DECODER=y
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_REGULATOR_HAPTIC=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PALMAS_PWRBUTTON=y
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_DA9063_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_ADXL34X_SPI=y
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set
# CONFIG_INPUT_XEN_KBDDEV_FRONTEND is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
CONFIG_INPUT_SOC_BUTTON_ARRAY=y
CONFIG_INPUT_DRV260X_HAPTICS=y
CONFIG_INPUT_DRV2665_HAPTICS=y
CONFIG_INPUT_DRV2667_HAPTICS=y
CONFIG_INPUT_RAVE_SP_PWRBUTTON=y
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
CONFIG_RMI4_SPI=y
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
# CONFIG_RMI4_F30 is not set
CONFIG_RMI4_F34=y
CONFIG_RMI4_F54=y
CONFIG_RMI4_F55=y

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
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_HYPERV_KEYBOARD=y
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVMEM is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y
CONFIG_SERIAL_8250_RT288X=y
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_DEV_BUS=y
CONFIG_SERIAL_DEV_CTRL_TTYPORT=y
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_SPI=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
CONFIG_TCG_TIS_ST33ZP24_SPI=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_LTC4306=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_MUX_REG=y
# CONFIG_I2C_MUX_MLXCPLD is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_CHT_WC=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
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
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_EMEV2 is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_GPIO_FAULT_INJECTOR is not set
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=y
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
# CONFIG_SPI_AXI_SPI_ENGINE is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_ROCKCHIP is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_KVM=y
CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
CONFIG_PINCTRL_MCP23S08=y
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_PINCTRL_CHERRYVIEW=y
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_BROXTON is not set
CONFIG_PINCTRL_CANNONLAKE=y
CONFIG_PINCTRL_CEDARFORK=y
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_LEWISBURG is not set
CONFIG_PINCTRL_SUNRISEPOINT=y
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_LYNXPOINT=y
CONFIG_GPIO_MB86S7X=y
CONFIG_GPIO_MOCKUP=y
# CONFIG_GPIO_VX855 is not set

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_WINBOND=y
# CONFIG_GPIO_WS16C48 is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_TPIC2810 is not set

#
# MFD GPIO expanders
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_CRYSTAL_COVE=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_KEMPLD=y
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_PALMAS=y
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS65910=y
# CONFIG_GPIO_TPS68470 is not set
CONFIG_GPIO_UCB1400=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_PCI_IDIO_16=y
CONFIG_GPIO_PCIE_IDIO_24=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders
#
CONFIG_GPIO_MAX3191X=y
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_PISOSR=y
# CONFIG_GPIO_XRA1403 is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2405=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2406 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2805 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2438 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_DS28E17=y
# CONFIG_POWER_AVS is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_CHARGER_SBS is not set
CONFIG_MANAGER_SBS=y
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=y
# CONFIG_BATTERY_BQ27XXX_HDQ is not set
# CONFIG_BATTERY_BQ27XXX_DT_UPDATES_NVM is not set
CONFIG_BATTERY_DA9030=y
CONFIG_CHARGER_DA9150=y
CONFIG_BATTERY_DA9150=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_MAX1721X=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_LTC3651=y
CONFIG_CHARGER_MAX77693=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ25890=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_RT5033 is not set
CONFIG_CHARGER_RT9455=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DELL_SMM=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_FTSTEUTATES=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_I5500=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC2990=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX31722=y
CONFIG_SENSORS_MAX6621=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MAX31790=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NCT7802=y
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_IR35221 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_LTC2978_REGULATOR=y
CONFIG_SENSORS_LTC3815=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX20751 is not set
CONFIG_SENSORS_MAX31785=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_TPS40422=y
# CONFIG_SENSORS_TPS53679 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHT3x=y
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA3221 is not set
CONFIG_SENSORS_TC74=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP108=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83773G=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_WM8350 is not set
CONFIG_SENSORS_XGENE=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_STATISTICS=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_POWER_ALLOCATOR=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_X86_PKG_TEMP_THERMAL=y
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=y
CONFIG_ACPI_THERMAL_REL=y
CONFIG_INT3406_THERMAL=y
# CONFIG_INTEL_PCH_THERMAL is not set
CONFIG_GENERIC_ADC_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
CONFIG_DA9063_WATCHDOG=y
CONFIG_WDAT_WDT=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_ZIIRAVE_WATCHDOG=y
CONFIG_RAVE_SP_WATCHDOG=y
# CONFIG_CADENCE_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_RETU_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_KEMPLD_WDT=y
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_INTEL_MEI_WDT=y
# CONFIG_NI903X_WDT is not set
CONFIG_NIC7018_WDT=y
CONFIG_MEN_A21_WDT=y
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# Watchdog Pretimeout Governors
#
CONFIG_WATCHDOG_PRETIMEOUT_GOV=y
CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP=y
# CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC is not set
CONFIG_WATCHDOG_PRETIMEOUT_GOV_NOOP=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_PANIC=y
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9062 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_DA9150=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_INTEL_SOC_PMIC=y
# CONFIG_INTEL_SOC_PMIC_BXTWC is not set
CONFIG_INTEL_SOC_PMIC_CHTWC=y
CONFIG_INTEL_SOC_PMIC_CHTDC_TI=y
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RT5033=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SKY81452=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_TI_LMU is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS68470=y
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_CS47L24 is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8998=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_RAVE_SP_CORE=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PG86X=y
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_REGULATOR_BCM590XX is not set
CONFIG_REGULATOR_DA903X=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_LTC3676 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_MT6311 is not set
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_PV88060=y
# CONFIG_REGULATOR_PV88080 is not set
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_RT5033 is not set
# CONFIG_REGULATOR_SKY81452 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65086 is not set
# CONFIG_REGULATOR_TPS65132 is not set
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_CEC_CORE=y
CONFIG_CEC_NOTIFIER=y
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_LIRC=y
# CONFIG_BPF_LIRC_MODE2 is not set
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=y
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
CONFIG_IR_FINTEK=y
CONFIG_IR_NUVOTON=y
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=y
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_SERIAL=y
# CONFIG_IR_SERIAL_TRANSMITTER is not set
# CONFIG_IR_SIR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_CEC_RC is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_VIDEO_PCI_SKELETON is not set
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
# CONFIG_DVB_DYNAMIC_MINORS is not set
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
CONFIG_DVB_ULE_DEBUG=y

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_VIDEO_SOLO6X10=y
CONFIG_VIDEO_TW5864=y
CONFIG_VIDEO_TW68=y
CONFIG_VIDEO_TW686X=y

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=y
# CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
CONFIG_VIDEO_IVTV_ALSA=y
# CONFIG_VIDEO_FB_IVTV is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=y
CONFIG_VIDEO_DT3155=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CX18_ALSA=y
CONFIG_VIDEO_CX23885=y
CONFIG_MEDIA_ALTERA_CI=y
CONFIG_VIDEO_CX25821=y
# CONFIG_VIDEO_CX25821_ALSA is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA7134 is not set
CONFIG_VIDEO_SAA7164=y

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_PLUTO2=y
# CONFIG_DVB_DM1105 is not set
# CONFIG_DVB_PT1 is not set
CONFIG_DVB_PT3=y
# CONFIG_MANTIS_CORE is not set
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y
CONFIG_DVB_SMIPCIE=y
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
CONFIG_VIDEO_SH_VEU=y
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVID=y
CONFIG_VIDEO_VIVID_CEC=y
CONFIG_VIDEO_VIVID_MAX_DEVS=64
# CONFIG_VIDEO_VIM2M is not set
CONFIG_DVB_PLATFORM_DRIVERS=y

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=y
# CONFIG_RADIO_SI4713 is not set
CONFIG_RADIO_MAXIRADIO=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_V4L2=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEOBUF2_DMA_SG=y
CONFIG_VIDEOBUF2_DVB=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_VIDEO_V4L2_TPG=y

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS3308=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y

#
# Camera sensor devices
#

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

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_M88RS6000T=y
CONFIG_MEDIA_TUNER_SI2157=y
CONFIG_MEDIA_TUNER_MXL301RF=y
CONFIG_MEDIA_TUNER_QM1D1C0042=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV0910=y
CONFIG_DVB_STV6110x=y
CONFIG_DVB_STV6111=y
CONFIG_DVB_MXL5XX=y
CONFIG_DVB_M88DS3103=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y
CONFIG_DVB_SI2165=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_CX24117=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2841ER=y
CONFIG_DVB_SI2168=y

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_MB86A20S=y

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_TUNER_DIB0070=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBH25=y
CONFIG_DVB_LNBP21=y
CONFIG_DVB_A8293=y

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_DEBUG_MM=y
CONFIG_DRM_DEBUG_SELFTEST=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y
CONFIG_DRM_GEM_CMA_HELPER=y
CONFIG_DRM_KMS_CMA_HELPER=y
CONFIG_DRM_VM=y
CONFIG_DRM_SCHED=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_I2C_NXP_TDA9950=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_USERPTR is not set
CONFIG_DRM_AMDGPU=y
CONFIG_DRM_AMDGPU_SI=y
# CONFIG_DRM_AMDGPU_CIK is not set
CONFIG_DRM_AMDGPU_USERPTR=y
CONFIG_DRM_AMDGPU_GART_DEBUGFS=y

#
# ACP (Audio CoProcessor) Configuration
#
CONFIG_DRM_AMD_ACP=y

#
# Display Engine Configuration
#
# CONFIG_DRM_AMD_DC is not set

#
# AMD Library routines
#
CONFIG_CHASH=y
CONFIG_CHASH_STATS=y
CONFIG_CHASH_SELFTEST=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_NOUVEAU_DEBUG_MMU=y
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_ALPHA_SUPPORT=y
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_VGEM=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN=y
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_ANALOGIX_ANX78XX=y
# CONFIG_HSA_AMD is not set
CONFIG_DRM_HISI_HIBMC=y
CONFIG_DRM_TINYDRM=y
CONFIG_TINYDRM_MIPI_DBI=y
# CONFIG_TINYDRM_ILI9225 is not set
CONFIG_TINYDRM_MI0283QT=y
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
CONFIG_DRM_XEN=y
CONFIG_DRM_XEN_FRONTEND=y
CONFIG_DRM_LEGACY=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SM501=y
# CONFIG_FB_IBM_GXT4500 is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_XEN_FBDEV_FRONTEND is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_HYPERV is not set
CONFIG_FB_SIMPLE=y
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_PM8941_WLED=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_SKY81452 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_BACKLIGHT_ARCXCNN is not set
# CONFIG_BACKLIGHT_RAVE_SP is not set
CONFIG_VGASTATE=y
CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQ_DEVICE=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
# CONFIG_SND_OSSEMUL is not set
CONFIG_SND_PCM_TIMER=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_SEQ_MIDI_EVENT=y
CONFIG_SND_SEQ_MIDI=y
CONFIG_SND_SEQ_MIDI_EMUL=y
CONFIG_SND_SEQ_VIRMIDI=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL3_LIB_SEQ=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=y
CONFIG_SND_ASIHPI=y
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=y
# CONFIG_SND_AU8820 is not set
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=y
# CONFIG_SND_GINA20 is not set
CONFIG_SND_LAYLA20=y
# CONFIG_SND_DARLA24 is not set
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
CONFIG_SND_ECHO3G=y
CONFIG_SND_INDIGO=y
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
CONFIG_SND_INDIGOIOX=y
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1_SEQ=y
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
CONFIG_SND_FM801=y
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=y
# CONFIG_SND_LOLA is not set
CONFIG_SND_LX6464ES=y
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=y
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=y

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_SPI is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_SOC is not set
CONFIG_SND_X86=y
CONFIG_HDMI_LPE_AUDIO=y
CONFIG_SND_SYNTH_EMUX=y
# CONFIG_SND_XEN_FRONTEND is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_ASUS=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CMEDIA is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GEMBIRD=y
# CONFIG_HID_GFRM is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_ITE=y
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_HID_LOGITECH_HIDPP=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTI=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEAM is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_HYPERV_MOUSE is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=y
CONFIG_HID_ALPS=y

#
# I2C HID support
#
CONFIG_I2C_HID=y

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_PCI=y

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_APU=y
CONFIG_LEDS_AS3645A=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_LM3601X=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP3952=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA955X_GPIO=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_TLC591XX=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_LEDS_TRIGGER_PANIC=y
CONFIG_LEDS_TRIGGER_NETDEV=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=y
CONFIG_INTEL_IOATDMA=y
CONFIG_QCOM_HIDMA_MGMT=y
CONFIG_QCOM_HIDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VBOXGUEST=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_TSCPAGE=y
CONFIG_HYPERV_UTILS=y
CONFIG_HYPERV_BALLOON=y

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SCRUB_PAGES is not set
CONFIG_XEN_DEV_EVTCHN=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACER_WIRELESS=y
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_SMBIOS=y
CONFIG_DELL_SMBIOS_WMI=y
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_DESCRIPTOR=y
# CONFIG_DELL_WMI_AIO is not set
CONFIG_DELL_WMI_LED=y
CONFIG_DELL_SMO8800=y
CONFIG_DELL_RBTN=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_TABLET=y
CONFIG_AMILO_RFKILL=y
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WIRELESS=y
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_SURFACE3_WMI=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=y
CONFIG_EEEPC_WMI=y
CONFIG_ASUS_WIRELESS=y
CONFIG_ACPI_WMI=y
# CONFIG_WMI_BMOF is not set
CONFIG_INTEL_WMI_THUNDERBOLT=y
# CONFIG_MSI_WMI is not set
CONFIG_PEAQ_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_TOSHIBA_HAPS is not set
CONFIG_TOSHIBA_WMI=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_HID_EVENT=y
# CONFIG_INTEL_VBTN is not set
CONFIG_INTEL_IPS=y
CONFIG_INTEL_PMC_CORE=y
CONFIG_IBM_RTL=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_INTEL_PMC_IPC=y
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_SURFACE_3_BUTTON is not set
CONFIG_INTEL_PUNIT_IPC=y
CONFIG_INTEL_TELEMETRY=y
CONFIG_MLX_PLATFORM=y
CONFIG_SILEAD_DMI=y
CONFIG_INTEL_CHTDC_TI_PWRBTN=y
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_WM831X=y
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
CONFIG_COMMON_CLK_CDCE706=y
# CONFIG_COMMON_CLK_CS2000_CP is not set
CONFIG_COMMON_CLK_PALMAS=y
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_PCC=y
CONFIG_ALTERA_MBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set

#
# Rpmsg drivers
#
CONFIG_RPMSG=y
CONFIG_RPMSG_CHAR=y
CONFIG_RPMSG_QCOM_GLINK_NATIVE=y
CONFIG_RPMSG_QCOM_GLINK_RPM=y
CONFIG_RPMSG_VIRTIO=y
# CONFIG_SOUNDWIRE is not set

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
CONFIG_SOC_TI=y

#
# Xilinx SoC drivers
#
CONFIG_XILINX_VCU=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_BUFFER_HW_CONSUMER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set

#
# Accelerometers
#
CONFIG_ADIS16201=y
# CONFIG_ADIS16209 is not set
# CONFIG_BMA180 is not set
CONFIG_BMA220=y
CONFIG_BMC150_ACCEL=y
CONFIG_BMC150_ACCEL_I2C=y
CONFIG_BMC150_ACCEL_SPI=y
CONFIG_DA280=y
CONFIG_DA311=y
# CONFIG_DMARD09 is not set
CONFIG_DMARD10=y
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_CROS_EC_ACCEL_LEGACY=y
# CONFIG_KXSD9 is not set
CONFIG_KXCJK1013=y
CONFIG_MC3230=y
CONFIG_MMA7455=y
CONFIG_MMA7455_I2C=y
CONFIG_MMA7455_SPI=y
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
CONFIG_MMA9551_CORE=y
# CONFIG_MMA9551 is not set
CONFIG_MMA9553=y
# CONFIG_MXC4005 is not set
CONFIG_MXC6255=y
# CONFIG_SCA3000 is not set
CONFIG_STK8312=y
CONFIG_STK8BA50=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7291 is not set
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7766=y
CONFIG_AD7791=y
CONFIG_AD7793=y
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
CONFIG_AD799X=y
CONFIG_CC10001_ADC=y
CONFIG_DA9150_GPADC=y
# CONFIG_HI8435 is not set
CONFIG_HX711=y
# CONFIG_LP8788_ADC is not set
CONFIG_LTC2471=y
CONFIG_LTC2485=y
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
CONFIG_MAX11100=y
CONFIG_MAX1118=y
CONFIG_MAX1363=y
CONFIG_MAX9611=y
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_NAU7802 is not set
# CONFIG_PALMAS_GPADC is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_ADC0832=y
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC12138 is not set
CONFIG_TI_ADC108S102=y
CONFIG_TI_ADC128S052=y
CONFIG_TI_ADC161S626=y
CONFIG_TI_ADS7950=y
CONFIG_TI_TLC4541=y

#
# Analog Front Ends
#

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=y
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
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
# CONFIG_IIO_SSP_SENSORHUB is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Counters
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5421=y
CONFIG_AD5446=y
CONFIG_AD5449=y
CONFIG_AD5592R_BASE=y
CONFIG_AD5592R=y
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_LTC2632=y
CONFIG_AD5686=y
CONFIG_AD5686_SPI=y
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
CONFIG_AD5761=y
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
# CONFIG_AD8801 is not set
# CONFIG_DS4424 is not set
CONFIG_M62332=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
CONFIG_TI_DAC5571=y

#
# IIO dummy driver
#

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_MPU3050=y
CONFIG_MPU3050_I2C=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4403=y
# CONFIG_AFE4404 is not set
CONFIG_MAX30100=y
CONFIG_MAX30102=y

#
# Humidity sensors
#
CONFIG_AM2315=y
CONFIG_DHT11=y
CONFIG_HDC100X=y
CONFIG_HID_SENSOR_HUMIDITY=y
# CONFIG_HTS221 is not set
CONFIG_HTU21=y
# CONFIG_SI7005 is not set
CONFIG_SI7020=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
CONFIG_BMI160=y
CONFIG_BMI160_I2C=y
CONFIG_BMI160_SPI=y
CONFIG_KMX61=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=y
CONFIG_INV_MPU6050_SPI=y
CONFIG_IIO_ST_LSM6DSX=y
CONFIG_IIO_ST_LSM6DSX_I2C=y
CONFIG_IIO_ST_LSM6DSX_SPI=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
CONFIG_ADJD_S311=y
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
CONFIG_APDS9960=y
CONFIG_BH1750=y
CONFIG_BH1780=y
# CONFIG_CM32181 is not set
CONFIG_CM3232=y
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_ISL29125 is not set
CONFIG_HID_SENSOR_ALS=y
# CONFIG_HID_SENSOR_PROX is not set
CONFIG_JSA1212=y
# CONFIG_RPR0521 is not set
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=y
CONFIG_LV0104CS=y
CONFIG_MAX44000=y
# CONFIG_OPT3001 is not set
CONFIG_PA12203001=y
CONFIG_SI1145=y
CONFIG_STK3310=y
CONFIG_ST_UVIS25=y
CONFIG_ST_UVIS25_I2C=y
CONFIG_ST_UVIS25_SPI=y
CONFIG_TCS3414=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL2583=y
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VEML6070 is not set
CONFIG_VL6180=y
CONFIG_ZOPT2201=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_AK09911=y
CONFIG_BMC150_MAGN=y
# CONFIG_BMC150_MAGN_I2C is not set
CONFIG_BMC150_MAGN_SPI=y
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_MMC35240 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y
CONFIG_SENSORS_HMC5843_SPI=y

#
# Multiplexers
#

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
CONFIG_HID_SENSOR_DEVICE_ROTATION=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Digital potentiometers
#
CONFIG_AD5272=y
CONFIG_DS1803=y
CONFIG_MAX5481=y
CONFIG_MAX5487=y
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
CONFIG_MCP4531=y
CONFIG_TPL0102=y

#
# Digital potentiostats
#
CONFIG_LMP91000=y

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_BMP280 is not set
CONFIG_HID_SENSOR_PRESS=y
CONFIG_HP03=y
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
CONFIG_MPL3115=y
CONFIG_MS5611=y
CONFIG_MS5611_I2C=y
CONFIG_MS5611_SPI=y
CONFIG_MS5637=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
CONFIG_T5403=y
CONFIG_HP206C=y
CONFIG_ZPA2326=y
CONFIG_ZPA2326_I2C=y
CONFIG_ZPA2326_SPI=y

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Proximity and distance sensors
#
CONFIG_LIDAR_LITE_V2=y
CONFIG_RFD77402=y
CONFIG_SRF04=y
CONFIG_SX9500=y
# CONFIG_SRF08 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S1200=y

#
# Temperature sensors
#
CONFIG_MAXIM_THERMOCOUPLE=y
CONFIG_HID_SENSOR_TEMP=y
CONFIG_MLX90614=y
CONFIG_MLX90632=y
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
CONFIG_TSYS01=y
CONFIG_TSYS02D=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_RESET_TI_SYSCON=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_LIBNVDIMM is not set
# CONFIG_DAX is not set
CONFIG_NVMEM=y
CONFIG_RAVE_SP_EEPROM=y

#
# HW tracing support
#
# CONFIG_STM is not set
CONFIG_INTEL_TH=y
# CONFIG_INTEL_TH_PCI is not set
# CONFIG_INTEL_TH_ACPI is not set
CONFIG_INTEL_TH_GTH=y
# CONFIG_INTEL_TH_MSU is not set
# CONFIG_INTEL_TH_PTI is not set
# CONFIG_INTEL_TH_DEBUG is not set
# CONFIG_FPGA is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
CONFIG_SLIMBUS=y
CONFIG_SLIM_QCOM_CTRL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_GOOGLE_FIRMWARE=y
CONFIG_GOOGLE_COREBOOT_TABLE=y
CONFIG_GOOGLE_COREBOOT_TABLE_ACPI=y
CONFIG_GOOGLE_MEMCONSOLE=y
CONFIG_GOOGLE_MEMCONSOLE_X86_LEGACY=y
CONFIG_GOOGLE_FRAMEBUFFER_COREBOOT=y
CONFIG_GOOGLE_MEMCONSOLE_COREBOOT=y
CONFIG_GOOGLE_VPD=y

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_ENCRYPTION is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_BTRFS_FS_REF_VERIFY is not set
CONFIG_NILFS2_FS=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FS_ENCRYPTION is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
# CONFIG_MANDATORY_FILE_LOCKING is not set
CONFIG_FS_ENCRYPTION=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y

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
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_STACK_VALIDATION=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_KASAN=y
# CONFIG_KASAN_EXTRA is not set
CONFIG_KASAN_OUTLINE=y
# CONFIG_KASAN_INLINE is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
CONFIG_KCOV=y
# CONFIG_KCOV_INSTRUMENT_ALL is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
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

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_WW_MUTEX_SELFTEST=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
# CONFIG_MEMTEST is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
CONFIG_X86_PTDUMP_CORE=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_WX=y
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_FPU is not set
CONFIG_PUNIT_ATOM_DEBUG=y
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_COMPAT=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_PAGE_TABLE_ISOLATION is not set
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_LOADPIN=y
# CONFIG_SECURITY_LOADPIN_ENABLED is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_WRITE_POLICY=y
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_EVM is not set
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y
CONFIG_CRYPTO_ENGINE=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_AEGIS128=y
CONFIG_CRYPTO_AEGIS128L=y
CONFIG_CRYPTO_AEGIS256=y
CONFIG_CRYPTO_AEGIS128_AESNI_SSE2=y
CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2=y
# CONFIG_CRYPTO_AEGIS256_AESNI_SSE2 is not set
CONFIG_CRYPTO_MORUS640=y
# CONFIG_CRYPTO_MORUS640_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280 is not set
CONFIG_CRYPTO_MORUS1280_GLUE=y
CONFIG_CRYPTO_MORUS1280_SSE2=y
CONFIG_CRYPTO_MORUS1280_AVX2=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_POLY1305_X86_64=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA1_MB=y
CONFIG_CRYPTO_SHA256_MB=y
CONFIG_CRYPTO_SHA512_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_CHACHA20=y
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_SM4=y
CONFIG_CRYPTO_SPECK=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_842=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=y
CONFIG_CRYPTO_DEV_SP_PSP=y
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_CRYPTO_DEV_QAT_C3XXX=y
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=y
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
CONFIG_CRYPTO_DEV_QAT_C62XVF=y
CONFIG_CRYPTO_DEV_VIRTIO=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
CONFIG_PKCS7_TEST_KEY=y
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_XXHASH=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
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
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_DIRECT_OPS=y
CONFIG_SWIOTLB=y
CONFIG_SGL_ALLOC=y
CONFIG_IOMMU_HELPER=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_6x10 is not set
CONFIG_FONT_10x18=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y
CONFIG_PRIME_NUMBERS=y
CONFIG_STRING_SELFTEST=y

--=_5b6dd0f6.BT2fvZOcapeDFhz3rszcEIsJI08UJrO9//6xcxLP6e9LFQjq--
