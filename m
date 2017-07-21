Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32055 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965967AbdGUCjZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 22:39:25 -0400
Date: Fri, 21 Jul 2017 10:38:33 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        LKP <lkp@01.org>
Subject: [lkp-robot] [bisect done] f8c627fbab [   72.198669] BUG: unable to
 handle kernel NULL pointer dereference at 0000000000000011
Message-ID: <20170721023833.GF4273@yexl-desktop>
Reply-To: kernel test robot <fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2Z2K0IlrPCVsbNpk"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

commit f8c627fbabbe9ed6ae68dcfefb7519bd153a7ac0
Author:     Sean Young <sean@mess.org>
AuthorDate: Tue May 16 04:56:14 2017 -0300
Commit:     Mauro Carvalho Chehab <mchehab@s-opensource.com>
CommitDate: Tue Jun 6 07:19:10 2017 -0300

    [media] sir_ir: infinite loop in interrupt handler
    
    Since this driver does no detection of hardware, it might be used with
    a non-sir port. Escape out if we are spinning.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Sean Young <sean@mess.org>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

ae8eb443a1  [media] cec-notifier.h: handle unreachable CONFIG_CEC_CORE
f8c627fbab  [media] sir_ir: infinite loop in interrupt handler
beaec533fc  llist: clang: introduce member_address_is_nonnull()
f80addb9cf  Add linux-next specific files for 20170720
+-----------------------------------------------------------------------------------+------------+------------+------------+---------------+
|                                                                                   | ae8eb443a1 | f8c627fbab | beaec533fc | next-20170720 |
+-----------------------------------------------------------------------------------+------------+------------+------------+---------------+
| boot_successes                                                                    | 30         | 9          | 23         | 23            |
| boot_failures                                                                     | 36         | 10         |            |               |
| INFO:rcu_sched_detected_expedited_stalls_on_CPUs/tasks:{#-...}#jiffies_s:#root:#/ | 8          |            |            |               |
| INFO:rcu_sched_detected_stalls_on_CPUs/tasks                                      | 30         |            |            |               |
| BUG:unable_to_handle_kernel                                                       | 0          | 9          |            |               |
| Oops:#[##]                                                                        | 0          | 9          |            |               |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt                             | 0          | 10         |            |               |
| general_protection_fault:#[##]                                                    | 0          | 1          |            |               |
| WARNING:at_kernel/locking/lockdep.c:#__bfs                                        | 0          | 1          |            |               |
+-----------------------------------------------------------------------------------+------------+------------+------------+---------------+

[   72.192465] Key type encrypted registered
[   72.194431]   Magic number: 9:869:702
[   72.197279] genirq: Flags mismatch irq 4. 00000000 (ttyS0) vs. 00000000 (sir_ir)
[   72.198052] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.12.0-rc3-00012-gf8c627f #1
[   72.198660] platform sir_ir.0: Trapped in interrupt
[   72.198669] BUG: unable to handle kernel NULL pointer dereference at 0000000000000011
[   72.198677] IP: ir_raw_event_handle+0x11/0x25
[   72.198678] PGD 0 
[   72.198679] P4D 0 
[   72.198680] 
[   72.198683] Oops: 0000 [#1] SMP
[   72.198687] CPU: 0 PID: 65 Comm: rb_producer Not tainted 4.12.0-rc3-00012-gf8c627f #1
[   72.198689] task: ffff88001fa9e000 task.stack: ffffc900002ec000
[   72.198692] RIP: 0010:ir_raw_event_handle+0x11/0x25
[   72.198693] RSP: 0000:ffff88001e403e80 EFLAGS: 00010002
[   72.198695] RAX: 0000000000000001 RBX: ffff880016a45000 RCX: 0000000000000000
[   72.198697] RDX: ffff88001fa9e000 RSI: 0000000000000000 RDI: ffff880016a37008
[   72.198702] RBP: ffff88001e403eb8 R08: 0000000000000001 R09: 0000000000000000
[   72.198703] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   72.198705] R13: 20c49ba5e353f7cf R14: 0000000000000000 R15: ffffffff82f9bfb8
[   72.198707] FS:  0000000000000000(0000) GS:ffff88001e400000(0000) knlGS:0000000000000000
[   72.198708] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.198710] CR2: 0000000000000011 CR3: 0000000002c20000 CR4: 00000000000006f0
[   72.198714] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   72.198715] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   72.198717] Call Trace:
[   72.198718]  <IRQ>
[   72.198722]  ? sir_interrupt+0x24b/0x25f
[   72.198727]  ? sched_clock+0x9/0xd
[   72.198732]  __handle_irq_event_percpu+0x4b/0x545
[   72.198735]  handle_irq_event_percpu+0x23/0x51
[   72.198738]  handle_irq_event+0x39/0x5d
[   72.198740]  handle_edge_irq+0xde/0x19e
[   72.198742]  handle_irq+0x57/0x64
[   72.198746]  do_IRQ+0x5c/0x10f
[   72.198749]  common_interrupt+0x9d/0x9d
[   72.198754] RIP: 0010:pvclock_clocksource_read+0x21/0x129
[   72.198755] RSP: 0000:ffffc900002efdd0 EFLAGS: 00000206 ORIG_RAX: ffffffffffffffcb
[   72.198758] RAX: 00000000043966e7 RBX: ffff88001a932630 RCX: 0000000000000000
[   72.198759] RDX: 000000000000002c RSI: 0000000000000000 RDI: ffff88001e92b000
[   72.198761] RBP: ffffc900002efe00 R08: ffff88001f8d9448 R09: 0000000000000000
[   72.198762] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000006
[   72.198764] R13: ffff88001e92b000 R14: 000000000000000a R15: ffff880017b78b20
[   72.198765]  </IRQ>
[   72.198768]  kvm_sched_clock_read+0x25/0x35
[   72.198771]  sched_clock+0x9/0xd
[   72.198773]  trace_clock_local+0x10/0x19
[   72.198777]  ring_buffer_lock_reserve+0x21c/0x721
[   72.198780]  ring_buffer_producer_thread+0x11d/0x638
[   72.198784]  kthread+0x110/0x142
[   72.198787]  ? wait_to_die+0x92/0x92
[   72.198789]  ? __kthread_create_on_node+0x249/0x249
[   72.198791]  ret_from_fork+0x2a/0x40
[   72.198792] Code: c3 41 03 14 24 89 90 50 10 00 00 eb 82 31 c0 5b 41 5c 5d c3 b8 ea ff ff ff c3 0f 1f 44 00 00 48 8b 87 00 06 00 00 48 85 c0 74 13 <48> 8b 78 10 48 85 ff 74 0a 55 48 89 e5 e8 45 0c 30 ff 5d c3 0f 
[   72.198839] RIP: ir_raw_event_handle+0x11/0x25 RSP: ffff88001e403e80
[   72.198840] CR2: 0000000000000011
[   72.198845] ---[ end trace 7777188ecb4ca0fc ]---
[   72.198847] Kernel panic - not syncing: Fatal exception in interrupt

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start c0bc126f97fb929b3ae02c1c62322645d70eb408 v4.11 --
git bisect good d4c6cd157a77645b9f8bff348b57aafa551f2d79  # 12:59  G     16     0   10  11  Merge tag 'iommu-fixes-v4.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu
git bisect good eb4125dfdb1f64a5e41da8315bff48f67e5d1712  # 13:47  G     16     0   12  12  Merge tag 'for-linus-4.12b-rc5-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
git bisect  bad c8636b90a091331beb0a26c455a0c87b93aa774a  # 14:05  B      8     8    1   1  Merge branch 'ufs-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 6d53cefb18e4646fb4bf62ccb6098fb3808486df  # 15:05  G     16     0    9   9  compiler, clang: properly override 'inline' for clang
git bisect  bad cbfb74973753e109f28705f6b98c8c8cc381b047  # 18:37  B      9     7    1   1  Merge branch 'dmi-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
git bisect  bad b45edc2d02d50ba4657f29c0e2380e337d324aef  # 18:47  B      0     8   20   0  Merge branch 'for-4.12/driver-matching-fix' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good 2ab99b001dea71c25bcf34f746f5781c880151bb  # 19:42  G     17     0    9   9  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect good 63f700aab4c11d46626de3cd051dae56cf7e9056  # 20:27  G     17     0    7   7  Merge tag 'xtensa-20170612' of git://github.com/jcmvbkbc/linux-xtensa
git bisect  bad 906e0c5b9f1261b516487f37a6d35eb48426786f  # 20:40  B      0     6   18   0  Merge tag 'media/v4.12-3' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 2302e5591a4ad2d66107c75b6be170121bff5ccd  # 21:27  G     17     0    8   8  [media] cec: improve MEDIA_CEC_RC dependencies
git bisect  bad f8c627fbabbe9ed6ae68dcfefb7519bd153a7ac0  # 21:41  B      0     8   20   0  [media] sir_ir: infinite loop in interrupt handler
git bisect good ae8eb443a17331a07579bc04817accaaaa62b78e  # 22:40  G     17     0   12  12  [media] cec-notifier.h: handle unreachable CONFIG_CEC_CORE
# first bad commit: [f8c627fbabbe9ed6ae68dcfefb7519bd153a7ac0] [media] sir_ir: infinite loop in interrupt handler
git bisect good ae8eb443a17331a07579bc04817accaaaa62b78e  # 23:18  G     52     0   24  36  [media] cec-notifier.h: handle unreachable CONFIG_CEC_CORE
# extra tests with CONFIG_DEBUG_INFO_REDUCED
git bisect  bad f8c627fbabbe9ed6ae68dcfefb7519bd153a7ac0  # 23:30  B      0     6   18   0  [media] sir_ir: infinite loop in interrupt handler
# extra tests on HEAD of linus/master
git bisect good 74cbd96bc2e00f5daa805e2ebf49e998f7045062  # 00:51  G     16     0    0   0  Merge tag 'md/4.13-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/shli/md
# extra tests on tree/branch linus/master
git bisect good beaec533fc2701a28a4d667f67c9f59c6e4e0d13  # 01:11  G     17     0    0   0  llist: clang: introduce member_address_is_nonnull()
# extra tests with first bad commit reverted
git bisect good b2e15fc749e625f168f111f702770526d755dbfc  # 02:38  G     17     0   10  10  Revert "[media] sir_ir: infinite loop in interrupt handler"
# extra tests on tree/branch linux-next/master
git bisect good f80addb9cf6c71f1eb8b010dc6a8bf15bb9007e6  # 02:55  G     17     0    0   0  Add linux-next specific files for 20170720

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--2Z2K0IlrPCVsbNpk
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-quantal-lkp-hsw01-11:20170720214110:x86_64-randconfig-ne0-07020731:4.12.0-rc3-00012-gf8c627f:1.gz"
Content-Transfer-Encoding: base64

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

--2Z2K0IlrPCVsbNpk
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-quantal-lkp-hsw01-10:20170720224036:x86_64-randconfig-ne0-07020731:4.12.0-rc3-00011-gae8eb44:1.gz"
Content-Transfer-Encoding: base64

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

--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce-quantal-lkp-hsw01-11:20170720214110:x86_64-randconfig-ne0-07020731:4.12.0-rc3-00012-gf8c627f:1"

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
	-m 512
	-smp 2
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
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.12.0-rc3-00012-gf8c627f"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.12.0-rc3 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
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
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
CONFIG_NO_HZ_FULL_SYSIDLE=y
CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=8
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_INITRAMFS_COMPRESSION=".gz"
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
CONFIG_POSIX_TIMERS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_BPF_SYSCALL=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_ADVISE_SYSCALLS=y
# CONFIG_USERFAULTFD is not set
CONFIG_PCI_QUIRKS=y
CONFIG_MEMBARRIER=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
CONFIG_PC104=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_STATIC_KEYS_SELFTEST=y
CONFIG_UPROBES=y
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
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
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
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
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
# CONFIG_HAVE_ARCH_HASH is not set
CONFIG_ISA_BUS_API=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_ZONED=y
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_SQ=y
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
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
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
CONFIG_PADATA=y
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
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_GOLDFISH=y
CONFIG_INTEL_RDT_A=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_XEN=y
CONFIG_XEN_PV=y
CONFIG_XEN_PV_SMP=y
# CONFIG_XEN_DOM0 is not set
# CONFIG_XEN_PVHVM is not set
# CONFIG_XEN_512GB is not set
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
# CONFIG_PERF_EVENTS_INTEL_RAPL is not set
# CONFIG_PERF_EVENTS_INTEL_CSTATE is not set
# CONFIG_VM86 is not set
CONFIG_X86_VSYSCALL_EMULATION=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
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
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_DEBUGFS=y
CONFIG_CMA_AREAS=7
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ZONE_DEVICE=y
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_X86_INTEL_MPX is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_KEXEC_FILE=y
# CONFIG_KEXEC_VERIFY_SIG is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_LEGACY_VSYSCALL_NATIVE is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_SUSPEND_SKIP_SYNC=y
CONFIG_HIBERNATE_CALLBACKS=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
CONFIG_PM_GENERIC_DOMAINS=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_PM_GENERIC_DOMAINS_SLEEP=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR_CSTATE=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_TABLE_UPGRADE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
CONFIG_DPTF_POWER=y
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_ACPI_CONFIGFS=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# DesignWare PCI Core Support
#

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
CONFIG_PCI_SW_SWITCHTEC=y
CONFIG_ISA_BUS=y
# CONFIG_ISA_DMA_API is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_TCP_CONG_DCTCP=y
CONFIG_TCP_CONG_CDG=y
CONFIG_TCP_CONG_BBR=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_DCTCP is not set
# CONFIG_DEFAULT_CDG is not set
# CONFIG_DEFAULT_BBR is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
CONFIG_DEFAULT_CODEL=y
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="pfifo_fast"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
CONFIG_NET_CLS_FLOWER=y
# CONFIG_NET_CLS_MATCHALL is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_SAMPLE=y
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_ACT_VLAN=y
# CONFIG_NET_ACT_BPF is not set
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BATMAN_V is not set
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUGFS is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_MPLS is not set
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
CONFIG_NET_NCSI=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_BAYCOM_PAR is not set
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_VXCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y
CONFIG_CAN_IFI_CANFD=y
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCI=y
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_VLSI_FIR=y
CONFIG_BT=y
# CONFIG_BT_BREDR is not set
CONFIG_BT_LE=y
# CONFIG_BT_LEDS is not set
# CONFIG_BT_SELFTEST is not set
CONFIG_BT_DEBUGFS=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_INJECT_LOSS=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_AF_KCM=y
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_REG_CELLULAR_HINTS=y
CONFIG_CFG80211_REG_RELAX_NO_IR=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=y
CONFIG_NET_IFE=y
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_DEVLINK=y
CONFIG_MAY_USE_DEVLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
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
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
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
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
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
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_MT81xx_NOR=y
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
# CONFIG_SPI_INTEL_SPI_PLATFORM is not set
# CONFIG_MTD_UBI is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set
CONFIG_NVME_CORE=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_NVME_SCSI=y
CONFIG_NVME_FABRICS=y
CONFIG_NVME_FC=y
# CONFIG_NVME_TARGET is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
# CONFIG_PCI_ENDPOINT_TEST is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_IDT_89HPESX=y
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
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# SCIF Bus Driver
#
CONFIG_SCIF_BUS=y

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#
CONFIG_SCIF=y

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#
CONFIG_MIC_COSM=y

#
# VOP Driver
#
CONFIG_VHOST_RING=y
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
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
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=y
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
# CONFIG_ATM_HORIZON is not set
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y

#
# Distributed Switch Architecture drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_NET_VENDOR_AGERE is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_VENDOR_AMAZON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_AQUANTIA is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_ALX=y
CONFIG_NET_VENDOR_AURORA=y
CONFIG_AURORA_NB8800=y
CONFIG_NET_CADENCE=y
CONFIG_MACB=y
CONFIG_MACB_PCI=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BCMGENET=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_TIGON3_HWMON is not set
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
# CONFIG_BNXT is not set
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_VENDOR_CAVIUM=y
CONFIG_THUNDER_NIC_PF=y
CONFIG_THUNDER_NIC_VF=y
CONFIG_THUNDER_NIC_BGX=y
CONFIG_THUNDER_NIC_RGX=y
CONFIG_LIQUIDIO=y
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
# CONFIG_CX_ECAT is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EZCHIP is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
CONFIG_VXGE=y
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RENESAS is not set
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_NET_VENDOR_SOLARFLARE is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=y
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
CONFIG_TI_CPSW_ALE=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
# CONFIG_WIZNET_BUS_INDIRECT is not set
CONFIG_WIZNET_BUS_ANY=y
# CONFIG_NET_VENDOR_SYNOPSYS is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_MDIO_DEVICE=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_MDIO_CAVIUM=y
CONFIG_MDIO_THUNDER=y
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
# CONFIG_BCM87XX_PHY is not set
CONFIG_BCM_NET_PHYLIB=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_DAVICOM_PHY is not set
# CONFIG_DP83848_PHY is not set
CONFIG_DP83867_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_LXT_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_MICROCHIP_PHY is not set
CONFIG_MICROSEMI_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_XILINX_GMII2RGMII=y
CONFIG_PLIP=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
# CONFIG_HDLC_FR is not set
# CONFIG_HDLC_PPP is not set
CONFIG_HDLC_X25=y
CONFIG_PCI200SYN=y
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_LAPBETHER=y
# CONFIG_X25_ASY is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_XEN_NETDEV_FRONTEND=y
CONFIG_VMXNET3=y
CONFIG_FUJITSU_ES=y
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
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_PEGASUS is not set
CONFIG_TABLET_SERIAL_WACOM4=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=y
# CONFIG_RMI4_SMB is not set
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
# CONFIG_RMI4_F11 is not set
CONFIG_RMI4_F12=y
# CONFIG_RMI4_F30 is not set
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_USERIO=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_FSL is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
# CONFIG_DEVPORT is not set
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_LTC4306=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_REG=y
# CONFIG_I2C_MUX_MLXCPLD is not set
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
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
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
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
CONFIG_I2C_EMEV2=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# CONFIG_I2C_CROS_EC_TUNNEL is not set
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
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=y
CONFIG_GPIO_AXP209=y
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_LYNXPOINT=y
CONFIG_GPIO_MENZ127=y
CONFIG_GPIO_MOCKUP=y
CONFIG_GPIO_VX855=y

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_104_DIO_48E=y
# CONFIG_GPIO_104_IDIO_16 is not set
CONFIG_GPIO_104_IDI_48=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_GPIO_MM=y
CONFIG_GPIO_IT87=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_WS16C48=y

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_DA9055=y
# CONFIG_GPIO_KEMPLD is not set
# CONFIG_GPIO_LP873X is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_TPS65218=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TWL6040=y

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_PCI_IDIO_16=y
CONFIG_GPIO_RDC321X=y

#
# SPI or I2C GPIO expanders
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2405=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2406 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2438=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
# CONFIG_POWER_AVS is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_CHARGER_SBS=y
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_MAX77693=y
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_BQ25890=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ASPEED=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_I5500=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC2990=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NCT7802=y
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_LTC3815=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX20751 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHT3x is not set
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_STTS751=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA3221 is not set
CONFIG_SENSORS_TC74=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP108=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
# CONFIG_THERMAL_HWMON is not set
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
CONFIG_X86_PKG_TEMP_THERMAL=y
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# CONFIG_INTEL_PCH_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX77843 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6397=y
CONFIG_MFD_MENF21BMC=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RT5033 is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SKY81452=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_LTC3676=y
# CONFIG_REGULATOR_MAX14577 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_MT6323=y
CONFIG_REGULATOR_MT6397=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_PV88060=y
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_QCOM_SPMI is not set
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_S2MPA01 is not set
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_SKY81452 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65132 is not set
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
# CONFIG_MEDIA_CONTROLLER_DVB is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_FLASH_LED_CLASS=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_SG=y
CONFIG_VIDEOBUF2_DVB=y
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=16
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=y
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_SHARP_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_HIX5HD2 is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=y
# CONFIG_IR_FINTEK is not set
CONFIG_IR_NUVOTON=y
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=y
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=y
# CONFIG_IR_GPIO_CIR is not set
# CONFIG_IR_SERIAL is not set
CONFIG_IR_SIR=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CX25821=y
CONFIG_VIDEO_CX88=y
CONFIG_VIDEO_CX88_BLACKBIRD=y
CONFIG_VIDEO_CX88_DVB=y
CONFIG_VIDEO_CX88_MPEG=y
CONFIG_VIDEO_BT848=y
CONFIG_DVB_BT8XX=y
# CONFIG_VIDEO_SAA7134 is not set
CONFIG_VIDEO_SAA7164=y

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
# CONFIG_DVB_BUDGET_CORE is not set
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=y
# CONFIG_DVB_DM1105 is not set
CONFIG_DVB_PT1=y
CONFIG_DVB_PT3=y
CONFIG_MANTIS_CORE=y
# CONFIG_DVB_MANTIS is not set
CONFIG_DVB_HOPPER=y
# CONFIG_DVB_NGENE is not set
CONFIG_DVB_DDBRIDGE=y
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_CEC_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=y
CONFIG_RADIO_SI4713=y
CONFIG_PLATFORM_SI4713=y
CONFIG_I2C_SI4713=y
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_IR_I2C=y

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS3308=y
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_ADV7604=y
# CONFIG_VIDEO_ADV7604_CEC is not set
CONFIG_VIDEO_ADV7842=y
# CONFIG_VIDEO_ADV7842_CEC is not set
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_ADV7511 is not set
CONFIG_VIDEO_AD9389B=y
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV9650=y
CONFIG_VIDEO_MT9M111=y
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_ET8EK8 is not set

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
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

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
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
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
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_E4000 is not set
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88RS6000T=y
CONFIG_MEDIA_TUNER_TUA9001=y
# CONFIG_MEDIA_TUNER_SI2157 is not set
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set
# CONFIG_MEDIA_TUNER_MXL301RF is not set
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
CONFIG_DVB_STV6110x=y
# CONFIG_DVB_M88DS3103 is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y
CONFIG_DVB_SI2165=y
CONFIG_DVB_MN88472=y
CONFIG_DVB_MN88473=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_MT312 is not set
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_CX24117=y
CONFIG_DVB_CX24120=y
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_CXD2841ER=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y
CONFIG_DVB_SI2168=y
# CONFIG_DVB_AS102_FE is not set
CONFIG_DVB_ZD1301_DEMOD=y
# CONFIG_DVB_GP8PSK_FE is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LGDT3306A=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
# CONFIG_DVB_AU8522_DTV is not set
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=y
CONFIG_DVB_LNBH25=y
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_SP2=y
# CONFIG_DVB_LGS8GL5 is not set
# CONFIG_DVB_LGS8GXX is not set
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y
# CONFIG_DVB_HORUS3A is not set
# CONFIG_DVB_ASCOT2E is not set
CONFIG_DVB_HELENE=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_DEBUG_MM=y
CONFIG_DRM_DEBUG_MM_SELFTEST=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_FBDEV_EMULATION is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y
CONFIG_DRM_GEM_CMA_HELPER=y
CONFIG_DRM_KMS_CMA_HELPER=y
CONFIG_DRM_VM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_USERPTR=y
CONFIG_DRM_AMDGPU=y
# CONFIG_DRM_AMDGPU_SI is not set
CONFIG_DRM_AMDGPU_CIK=y
CONFIG_DRM_AMDGPU_USERPTR=y
# CONFIG_DRM_AMDGPU_GART_DEBUGFS is not set

#
# ACP (Audio CoProcessor) Configuration
#
CONFIG_DRM_AMD_ACP=y
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_DRM_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_ANALOGIX_ANX78XX=y
# CONFIG_DRM_HISI_HIBMC is not set
CONFIG_DRM_TINYDRM=y
CONFIG_DRM_LEGACY=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_I810=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
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
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_INTEL=y
# CONFIG_FB_INTEL_DEBUG is not set
# CONFIG_FB_INTEL_I2C is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_FB_SM712=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_PM8941_WLED=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_SKY81452=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_BACKLIGHT_ARCXCNN=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
# CONFIG_HID_ASUS is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CMEDIA=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_HID_LOGITECH_HIDPP=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MAYFLASH=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTI=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_UDRAW_PS3 is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
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
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set

#
# USB Power Delivery and Type-C drivers
#
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_MT6323=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_MENF21BMC=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_USER=y
CONFIG_LEDS_NIC78BX=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_LEDS_TRIGGER_PANIC=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
CONFIG_EDAC_IE31200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=y
# CONFIG_EDAC_PND2 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_ABB5ZES3=y
CONFIG_RTC_DRV_ABX80X=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8010=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV8803=y
# CONFIG_RTC_DRV_S5M is not set

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MT6397=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_CHARLCD=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_PRUSS=y
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_PCI_LEGACY is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_INPUT=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_HYPERV_TSCPAGE is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=y
# CONFIG_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_HAVE_VPMU=y
CONFIG_STAGING=y
CONFIG_COMEDI=y
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=y
CONFIG_COMEDI_PCL724=y
# CONFIG_COMEDI_PCL726 is not set
CONFIG_COMEDI_PCL730=y
# CONFIG_COMEDI_PCL812 is not set
# CONFIG_COMEDI_PCL816 is not set
# CONFIG_COMEDI_PCL818 is not set
# CONFIG_COMEDI_PCM3724 is not set
# CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
CONFIG_COMEDI_AMPLC_PC236_ISA=y
# CONFIG_COMEDI_AMPLC_PC263_ISA is not set
CONFIG_COMEDI_RTI800=y
CONFIG_COMEDI_RTI802=y
CONFIG_COMEDI_DAC02=y
CONFIG_COMEDI_DAS16M1=y
CONFIG_COMEDI_DAS08_ISA=y
CONFIG_COMEDI_DAS16=y
# CONFIG_COMEDI_DAS800 is not set
CONFIG_COMEDI_DAS1800=y
CONFIG_COMEDI_DAS6402=y
CONFIG_COMEDI_DT2801=y
CONFIG_COMEDI_DT2811=y
CONFIG_COMEDI_DT2814=y
# CONFIG_COMEDI_DT2815 is not set
CONFIG_COMEDI_DT2817=y
# CONFIG_COMEDI_DT282X is not set
# CONFIG_COMEDI_DMM32AT is not set
CONFIG_COMEDI_FL512=y
CONFIG_COMEDI_AIO_AIO12_8=y
CONFIG_COMEDI_AIO_IIRO_16=y
CONFIG_COMEDI_II_PCI20KC=y
CONFIG_COMEDI_C6XDIGIO=y
CONFIG_COMEDI_MPC624=y
CONFIG_COMEDI_ADQ12B=y
CONFIG_COMEDI_NI_AT_A2150=y
CONFIG_COMEDI_NI_AT_AO=y
# CONFIG_COMEDI_NI_ATMIO is not set
CONFIG_COMEDI_NI_ATMIO16D=y
CONFIG_COMEDI_NI_LABPC_ISA=y
# CONFIG_COMEDI_PCMAD is not set
CONFIG_COMEDI_PCMDA12=y
CONFIG_COMEDI_PCMMIO=y
CONFIG_COMEDI_PCMUIO=y
CONFIG_COMEDI_MULTIQ3=y
CONFIG_COMEDI_S526=y
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_8254=y
CONFIG_COMEDI_8255=y
# CONFIG_COMEDI_8255_SA is not set
CONFIG_COMEDI_KCOMEDILIB=y
CONFIG_COMEDI_AMPLC_PC236=y
CONFIG_COMEDI_DAS08=y
CONFIG_COMEDI_NI_LABPC=y
CONFIG_RTS5208=y
# CONFIG_FB_SM750 is not set
CONFIG_FB_XGI=y

#
# Speakup console speech
#
CONFIG_STAGING_MEDIA=y
CONFIG_I2C_BCM2048=y
CONFIG_DVB_CXD2099=y

#
# Android
#
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_GOLDFISH_AUDIO=y
# CONFIG_MTD_GOLDFISH_NAND is not set
# CONFIG_DGNC is not set
CONFIG_GS_FPGABOOT=y
CONFIG_CRYPTO_SKEIN=y
CONFIG_UNISYSSPAR=y
CONFIG_UNISYS_VISORBUS=y
CONFIG_UNISYS_VISORNIC=y
CONFIG_UNISYS_VISORINPUT=y
# CONFIG_UNISYS_VISORHBA is not set
CONFIG_MOST=y
CONFIG_MOSTCORE=y
CONFIG_AIM_CDEV=y
CONFIG_AIM_NETWORK=y
CONFIG_AIM_V4L2=y
CONFIG_HDM_DIM2=y
CONFIG_HDM_I2C=y
CONFIG_GREYBUS=y
CONFIG_GREYBUS_AUDIO=y
CONFIG_GREYBUS_BOOTROM=y
CONFIG_GREYBUS_HID=y
CONFIG_GREYBUS_LIGHT=y
CONFIG_GREYBUS_LOG=y
# CONFIG_GREYBUS_LOOPBACK is not set
CONFIG_GREYBUS_POWER=y
# CONFIG_GREYBUS_RAW is not set
CONFIG_GREYBUS_VIBRATOR=y
# CONFIG_GREYBUS_BRIDGED_PHY is not set

#
# USB Power Delivery and Type-C drivers
#
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_PMC_ATOM=y
# CONFIG_GOLDFISH_BUS is not set
# CONFIG_GOLDFISH_PIPE is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y
CONFIG_CROS_EC_CHARDEV=y
CONFIG_CROS_EC_LPC=y
CONFIG_CROS_EC_PROTO=y
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_CDCE706=y
CONFIG_COMMON_CLK_CS2000_CP=y
# CONFIG_COMMON_CLK_S2MPS11 is not set
# CONFIG_CLK_TWL6040 is not set
# CONFIG_COMMON_CLK_NXP is not set
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set

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
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IOVA=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#

#
# i.MX SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
CONFIG_SOC_ZTE=y
CONFIG_ZX2967_PM_DOMAINS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y
CONFIG_DEVFREQ_GOV_PASSIVE=y

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX3355=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_QCOM_SPMI_MISC=y
CONFIG_EXTCON_RT8973A=y
# CONFIG_EXTCON_SM5502 is not set
# CONFIG_EXTCON_USB_GPIO is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=y
CONFIG_NTB_AMD=y
CONFIG_NTB_INTEL=y
# CONFIG_NTB_PINGPONG is not set
CONFIG_NTB_TOOL=y
CONFIG_NTB_PERF=y
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
CONFIG_PHY_PXA_28NM_USB2=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
CONFIG_MCB_LPC=y

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_LIBNVDIMM=y
# CONFIG_BLK_DEV_PMEM is not set
CONFIG_ND_BLK=y
# CONFIG_BTT is not set
# CONFIG_NVDIMM_PFN is not set
CONFIG_DAX=y
CONFIG_NVMEM=y
CONFIG_STM=y
# CONFIG_STM_DUMMY is not set
CONFIG_STM_SOURCE_CONSOLE=y
CONFIG_STM_SOURCE_HEARTBEAT=y
# CONFIG_STM_SOURCE_FTRACE is not set
CONFIG_INTEL_TH=y
CONFIG_INTEL_TH_PCI=y
CONFIG_INTEL_TH_GTH=y
# CONFIG_INTEL_TH_STH is not set
# CONFIG_INTEL_TH_MSU is not set
# CONFIG_INTEL_TH_PTI is not set
CONFIG_INTEL_TH_DEBUG=y

#
# FPGA Configuration Support
#
CONFIG_FPGA=y
CONFIG_ALTERA_PR_IP_CORE=y

#
# FSI support
#
CONFIG_FSI=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_FW_CFG_SYSFS is not set
CONFIG_GOOGLE_FIRMWARE=y
CONFIG_GOOGLE_COREBOOT_TABLE=y
CONFIG_GOOGLE_COREBOOT_TABLE_ACPI=y
# CONFIG_GOOGLE_MEMCONSOLE_COREBOOT is not set
CONFIG_GOOGLE_VPD=y
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
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
# CONFIG_F2FS_FS is not set
CONFIG_FS_DAX=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
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
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
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
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
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
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_STACK_VALIDATION is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_PAGE_REF=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_ARCH_HAS_KCOV=y
# CONFIG_KCOV is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHED_INFO is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT=y
CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT_DELAY=3
# CONFIG_RCU_TORTURE_TEST_SLOW_INIT is not set
CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP=y
CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP_DELAY=3
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_RCU_EQS_DEBUG=y
CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_HWLAT_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_HIST_TRIGGERS is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_TRACE_ENUM_MAP_FILE=y
CONFIG_TRACING_EVENTS_GPIO=y

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_TEST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_HEXDUMP=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
CONFIG_TEST_PRINTF=y
CONFIG_TEST_BITMAP=y
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=y
# CONFIG_TEST_HASH is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
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
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP_CORE is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_WX is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
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
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_ENTRY=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
CONFIG_PUNIT_ATOM_DEBUG=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
# CONFIG_SECURITY_WRITABLE_HOOKS is not set
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_APPARMOR_DEBUG=y
CONFIG_SECURITY_APPARMOR_DEBUG_ASSERTS=y
CONFIG_SECURITY_APPARMOR_DEBUG_MESSAGES=y
CONFIG_SECURITY_LOADPIN=y
CONFIG_SECURITY_LOADPIN_ENABLED=y
# CONFIG_SECURITY_YAMA is not set
# CONFIG_INTEGRITY is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y
CONFIG_CRYPTO_ENGINE=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=y
CONFIG_CRYPTO_SEQIV=y
# CONFIG_CRYPTO_ECHAINIV is not set

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
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_POLY1305_X86_64=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA1_MB=y
CONFIG_CRYPTO_SHA256_MB=y
CONFIG_CRYPTO_SHA512_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_842=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC is not set
CONFIG_CRYPTO_DEV_CCP=y
# CONFIG_CRYPTO_DEV_CCP_DD is not set
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_CRYPTO_DEV_QAT_C3XXX=y
CONFIG_CRYPTO_DEV_QAT_C62X=y
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=y
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=y
CONFIG_CRYPTO_DEV_QAT_C62XVF=y
CONFIG_CRYPTO_DEV_VIRTIO=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS7_MESSAGE_PARSER is not set

#
# Certificates for signature checking
#
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
CONFIG_BINARY_PRINTF=y

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
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
# CONFIG_DMA_VIRT_OPS is not set
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_SG_SPLIT is not set
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y
CONFIG_PRIME_NUMBERS=y

--2Z2K0IlrPCVsbNpk--
