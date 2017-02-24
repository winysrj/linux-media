Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:57698 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751163AbdBXS25 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 13:28:57 -0500
Subject: [WARNING: A/V UNSCANNABLE][Merge tag 'media/v4.11-1' of git] ff58d005cd:  BUG: unable to
 handle kernel NULL pointer dereference at 0000039c
Date: Sat, 25 Feb 2017 02:28:00 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKP <lkp@01.org>, linux-input@vger.kernel.org,
        linux-omap@vger.kernel.org, kernel@stlinux.com,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, wfg@linux.intel.com
Message-ID: <58b07b30.9XFLj9Hhl7F6HMc2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_58b07b30.uKO2RyuypkguSQpGoDoIOqyy3gHh6gY+cTXfAleOcYcZL8il"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_58b07b30.uKO2RyuypkguSQpGoDoIOqyy3gHh6gY+cTXfAleOcYcZL8il
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

commit ff58d005cd10fcd372787cceac547e11cf706ff6
Merge: 5ab3566 9eeb0ed
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Tue Feb 21 16:58:32 2017 -0800
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Tue Feb 21 16:58:32 2017 -0800

    Merge tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
    
    Pull media updates from Mauro Carvalho Chehab:
    
     - new drivers:
           - i.MX6 Video Data Order Adapter's (VDOA)
           - Toshiba et8ek8 5MP sensor
           - STM DELTA multi-format video decoder V4L2 driver
           - SPI connected IR LED
           - Mediatek IR remote receiver
           - ZyDAS ZD1301 DVB USB interface driver
    
     - new RC keymaps
    
     - some very old LIRC drivers got removed from staging
    
     - RC core gained support encoding IR scan codes
    
     - DVB si2168 gained support for DVBv5 statistics
    
     - lirc_sir driver ported to rc-core and promoted from staging
    
     - other bug fixes, board additions and driver improvements
    
    * tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media: (230 commits)
      [media] mtk-vcodec: fix build warnings without DEBUG
      [media] zd1301: fix building interface driver without demodulator
      [media] usbtv: add sharpness control
      [media] cxusb: Use a dma capable buffer also for reading
      [media] ttpci: address stringop overflow warning
      [media] dvb-usb-v2: avoid use-after-free
      [media] add Hama Hybrid DVB-T Stick support
      [media] et8ek8: Fix compiler / Coccinelle warnings
      [media] media: fix semicolon.cocci warnings
      [media] media: exynos4-is: add flags to dummy Exynos IS i2c adapter
      [media] v4l: of: check for unique lanes in data-lanes and clock-lanes
      [media] coda/imx-vdoa: constify structs
      [media] st-delta: debug: trace stream/frame information & summary
      [media] st-delta: add mjpeg support
      [media] st-delta: EOS (End Of Stream) support
      [media] st-delta: rpmsg ipc support
      [media] st-delta: add memory allocator helper functions
      [media] st-delta: STiH4xx multi-format video decoder v4l2 driver
      [media] MAINTAINERS: add st-delta driver
      [media] ARM: multi_v7_defconfig: enable STMicroelectronics DELTA Support
      ...

5ab356626f  Merge tag 'pinctrl-v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
9eeb0ed0f3  [media] mtk-vcodec: fix build warnings without DEBUG
ff58d005cd  Merge tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
+-------------------------------------------------------+------------+------------+------------+
|                                                       | 5ab356626f | 9eeb0ed0f3 | ff58d005cd |
+-------------------------------------------------------+------------+------------+------------+
| boot_successes                                        | 261        | 237        | 0          |
| boot_failures                                         | 5          | 0          | 26         |
| invoked_oom-killer:gfp_mask=0x                        | 1          |            |            |
| Mem-Info                                              | 1          |            |            |
| Out_of_memory:Kill_process                            | 1          |            |            |
| IP-Config:Auto-configuration_of_network_failed        | 4          |            |            |
| BUG:unable_to_handle_kernel                           | 0          | 0          | 26         |
| Oops                                                  | 0          | 0          | 26         |
| EIP:serial_ir_irq_handler                             | 0          | 0          | 26         |
| EIP:hardware_init_port                                | 0          | 0          | 26         |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 0          | 26         |
+-------------------------------------------------------+------------+------------+------------+

[    4.660180] input: rc-core loopback device as /devices/virtual/rc/rc0/input5
[    4.661186] evbug: Connected device: input5 (rc-core loopback device at rc-core/virtual)
[    4.662435] input: MCE IR Keyboard/Mouse (rc-loopback) as /devices/virtual/input/input6
[    4.663793] evbug: Connected device: input6 (MCE IR Keyboard/Mouse (rc-loopback) at /input0)
[    4.664940] rc rc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registered at minor = 0
[    4.666322] BUG: unable to handle kernel NULL pointer dereference at 0000039c
[    4.666675] IP: serial_ir_irq_handler+0x189/0x410
[    4.666675] *pde = 00000000 
[    4.666675] 
[    4.666675] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.666675] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.10.0-02434-gff58d00 #1
[    4.666675] task: c0068040 task.stack: c0064000
[    4.666675] EIP: serial_ir_irq_handler+0x189/0x410
[    4.666675] EFLAGS: 00210046 CPU: 0
[    4.666675] EAX: 00000000 EBX: 00000000 ECX: 000000b0 EDX: 00000000
[    4.666675] ESI: 000003f8 EDI: 00000101 EBP: c008df88 ESP: c008df44
[    4.666675]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    4.666675] CR0: 80050033 CR2: 0000039c CR3: 07ce1000 CR4: 001406d0
[    4.666675] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    4.666675] DR6: fffe0ff0 DR7: 00000400
[    4.666675] Call Trace:
[    4.666675]  <IRQ>
[    4.666675]  __handle_irq_event_percpu+0x57/0x100
[    4.666675]  ? handle_edge_irq+0x12/0x120
[    4.666675]  handle_irq_event_percpu+0x1d/0x50
[    4.666675]  handle_irq_event+0x32/0x60
[    4.666675]  handle_edge_irq+0xa5/0x120
[    4.666675]  ? handle_fasteoi_irq+0x150/0x150
[    4.666675]  handle_irq+0x9d/0xd0
[    4.666675]  </IRQ>
[    4.666675]  do_IRQ+0x5f/0x130
[    4.666675]  ? __this_cpu_preempt_check+0xf/0x20
[    4.666675]  common_interrupt+0x33/0x38
[    4.666675] EIP: hardware_init_port+0x3f/0x190
[    4.666675] EFLAGS: 00200246 CPU: 0
[    4.666675] EAX: c718990f EBX: 00000000 ECX: 00000000 EDX: 000003f9
[    4.666675] ESI: 000003f9 EDI: 000003f8 EBP: c0065d98 ESP: c0065d84
[    4.666675]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    4.666675]  ? serial_ir_suspend+0x6f/0x90
[    4.666675]  ? parport_pc_pci_probe+0x1ab/0x250
[    4.666675]  serial_ir_probe+0xbb/0x300
[    4.666675]  platform_drv_probe+0x48/0xb0
[    4.666675]  driver_probe_device+0x161/0x500
[    4.666675]  ? acpi_driver_match_device+0x36/0x50
[    4.666675]  __device_attach_driver+0x77/0x110
[    4.666675]  ? klist_next+0x82/0xf0
[    4.666675]  ? __driver_attach+0xf0/0xf0
[    4.666675]  bus_for_each_drv+0x47/0x80
[    4.666675]  __device_attach+0xb5/0x130
[    4.666675]  ? __driver_attach+0xf0/0xf0
[    4.666675]  device_initial_probe+0xd/0x10
[    4.666675]  bus_probe_device+0x77/0x80
[    4.666675]  device_add+0x37e/0x5f0
[    4.666675]  ? kobject_set_name_vargs+0x6b/0x90
[    4.666675]  platform_device_add+0xfc/0x270
[    4.666675]  serial_ir_init_module+0xa6/0x269
[    4.666675]  ? gpio_ir_recv_driver_init+0x11/0x11
[    4.666675]  do_one_initcall+0x7e/0x121
[    4.666675]  ? kernel_init_freeable+0xec/0x188
[    4.666675]  kernel_init_freeable+0x10f/0x188
[    4.666675]  ? rest_init+0x110/0x110
[    4.666675]  kernel_init+0xb/0x100
[    4.666675]  ? schedule_tail+0x20/0x80
[    4.666675]  ? rest_init+0x110/0x110
[    4.666675]  ret_from_fork+0x21/0x2c
[    4.666675] Code: 89 15 e4 0b 89 c8 84 db ba 02 00 00 00 74 08 8b 0d 2c 0c 89 c8 d3 e2 01 f2 ec 24 01 84 c0 0f 84 ce fe ff ff a1 e8 0b 89 c8 31 d2 <8b> 80 9c 03 00 00 e8 bc 80 73 ff 8b 15 c0 a8 ae c7 01 c2 b8 f0
[    4.666675] EIP: serial_ir_irq_handler+0x189/0x410 SS:ESP: 0068:c008df44
[    4.666675] CR2: 000000000000039c
[    4.666675] ---[ end trace a0c5674b0bbcdbb2 ]---
[    4.666675] Kernel panic - not syncing: Fatal exception in interrupt

git bisect start 4d6e6d452fb216ac03fbd5bd2cd2ecbecaef6160 c470abd4fde40ea6a0846a2beab642a578c0b8cd --
git bisect  bad b37df1eb72f0689451c40e1909e45dc10c699bd2  # 01:48      0-      4  Merge 'aaron/every-1G' into devel-catchup-201702240019
git bisect  bad 875de500cd5b158290f677f7d97bcf4077aa1ae6  # 04:35      0-      9  Merge 'open-channel-ssd/pblk.latest' into devel-catchup-201702240019
git bisect good 73112164c8ee37d3b00cfe81ca31ba7834cec9a8  # 04:53     22+      0  0day base guard for 'devel-catchup-201702240019'
git bisect  bad 08eaa36283eaac37e5bfb9029bda8d5a2bf7eb9a  # 11:32      0-     41  Merge 'linux-review/Matthias-Schiffer/vxlan-correctly-validate-VXLAN-ID-against-VXLAN_VID_MASK/20170223-233547' into devel-catchup-201702240019
git bisect  bad ff58d005cd10fcd372787cceac547e11cf706ff6  # 11:47      0-     12  Merge tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 2bfe01eff4307409b95859e860261d0907149b61  # 13:00     22+      2  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect good c9341ee0af4df0af8b727873ef851227345defed  # 13:08     22+      4  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security
git bisect good 5ab356626f3cf97f00280f17a52e4b5b4a13e038  # 17:56     22+      5  Merge tag 'pinctrl-v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good c62d29c81736c6f3a6a9cc6ba2f5aad1cfa6afbc  # 18:07     20+     40  [media] si2168: implement ucb statistics
git bisect good 59e34ba82aebf75ea70508a114ada1ed3ca0df7c  # 18:22     22+     24  [media] tc358743: Do not read number of CSI lanes in use from chip
git bisect good 2b2d1d403343838401af029bd29b441a414beef3  # 18:37     22+     24  [media] exynos4-is: Add missing 'of_node_put'
git bisect good 017c324242c2e9724938ef193ac6cb4ec5131778  # 19:23     22+     91  [media] st-delta: EOS (End Of Stream) support
git bisect good bed6838f0113ba72c35f14f9027f1db713ab4188  # 20:04     22+     26  [media] et8ek8: Fix compiler / Coccinelle warnings
git bisect good 3f190e3aec212fc8c61e202c51400afa7384d4bc  # 20:20     20+     22  [media] cxusb: Use a dma capable buffer also for reading
git bisect good 9165ba166cac5e8c9abda2012ea37cc3430c0b14  # 20:37     22+     25  [media] usbtv: add sharpness control
git bisect good 9eeb0ed0f30938f31a3d9135a88b9502192c18dd  # 20:48     22+      0  [media] mtk-vcodec: fix build warnings without DEBUG
# first bad commit: [ff58d005cd10fcd372787cceac547e11cf706ff6] Merge tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 5ab356626f3cf97f00280f17a52e4b5b4a13e038  # 21:01     62+      5  Merge tag 'pinctrl-v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good 9eeb0ed0f30938f31a3d9135a88b9502192c18dd  # 21:25     63+      0  [media] mtk-vcodec: fix build warnings without DEBUG
# extra tests with CONFIG_DEBUG_INFO_REDUCED
git bisect  bad ff58d005cd10fcd372787cceac547e11cf706ff6  # 00:01      0-     45  Merge tag 'media/v4.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
# extra tests on HEAD of linux-devel/devel-catchup-201702240019
git bisect  bad 4d6e6d452fb216ac03fbd5bd2cd2ecbecaef6160  # 00:01      0-     13  0day head guard for 'devel-catchup-201702240019'
# extra tests on tree/branch linus/master
git bisect  bad f1ef09fde17f9b77ca1435a5b53a28b203afb81c  # 00:14      0-     49  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
# extra tests on tree/branch linux-next/master
git bisect  bad 3e7350242c6f3d41d28e03418bd781cc1b7bad5f  # 01:30      0-     14  Add linux-next specific files for 20170224

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--=_58b07b30.uKO2RyuypkguSQpGoDoIOqyy3gHh6gY+cTXfAleOcYcZL8il
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-yocto-lkp-hsw01-72:20170224114241:i386-randconfig-h0-02232242:4.10.0-02434-gff58d00:1.gz"

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

--=_58b07b30.uKO2RyuypkguSQpGoDoIOqyy3gHh6gY+cTXfAleOcYcZL8il
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-quantal-intel12-47:20170224131826:i386-randconfig-h0-02232242:4.10.0-02202-g5ab3566:3.gz"

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
ED34Pw7WctKkoQEACg==

--=_58b07b30.uKO2RyuypkguSQpGoDoIOqyy3gHh6gY+cTXfAleOcYcZL8il
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce-yocto-lkp-hsw01-72:20170224114241:i386-randconfig-h0-02232242:4.10.0-02434-gff58d00:1"

#!/bin/bash

kernel=$1
		initrd=yocto-trinity-i386.cgz

		wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep
	-kernel $kernel
	-initrd $initrd
	-m 256
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
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--=_58b07b30.uKO2RyuypkguSQpGoDoIOqyy3gHh6gY+cTXfAleOcYcZL8il
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-4.10.0-02434-gff58d00"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 4.10.0 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEBUG_RODATA=y
CONFIG_PGTABLE_LEVELS=2
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
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
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_KTHREAD_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_NMI_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CGROUP_PIDS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
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
CONFIG_SYSFS_SYSCALL=y
CONFIG_SYSCTL_SYSCALL=y
# CONFIG_POSIX_TIMERS is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_BPF_SYSCALL is not set
# CONFIG_SHMEM is not set
CONFIG_AIO=y
# CONFIG_ADVISE_SYSCALLS is not set
# CONFIG_USERFAULTFD is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_MEMBARRIER is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
# CONFIG_HAVE_ARCH_HASH is not set
# CONFIG_ISA_BUS_API is not set
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
# CONFIG_HAVE_ARCH_VMAP_STACK is not set

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_MODULES_TREE_LOOKUP=y
# CONFIG_BLOCK is not set
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
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_GOLDFISH is not set
# CONFIG_INTEL_RDT_A is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
CONFIG_IOSF_MBI_DEBUG=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
CONFIG_STA2X11=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
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
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
# CONFIG_PERF_EVENTS_INTEL_CSTATE is not set
CONFIG_PERF_EVENTS_AMD_POWER=y
# CONFIG_X86_LEGACY_VM86 is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
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
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_FRAME_VECTOR=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_X86_INTEL_MPX=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_SUSPEND_SKIP_SYNC=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_DPM_WATCHDOG=y
CONFIG_DPM_WATCHDOG_TIMEOUT=120
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
CONFIG_PM_GENERIC_DOMAINS=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_PM_GENERIC_DOMAINS_SLEEP=y
CONFIG_PM_GENERIC_DOMAINS_OF=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_REV_OVERRIDE_POSSIBLE is not set
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_DPTF_POWER is not set
CONFIG_ACPI_EXTLOG=y
CONFIG_PMIC_OPREGION=y
# CONFIG_CRC_PMIC_OPREGION is not set
CONFIG_XPOWER_PMIC_OPREGION=y
CONFIG_BXT_WC_PMIC_OPREGION=y
CONFIG_ACPI_CONFIGFS=y
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
# CONFIG_CPUFREQ_DT is not set
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
CONFIG_X86_LONGHAUL=y
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# PCI host controller drivers
#
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO1_PM is not set
CONFIG_OLPC_XO15_SCI=y
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_COMPAT_32=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_X86_DMA_REMAP=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
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
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_NL802154_EXPERIMENTAL=y
CONFIG_IEEE802154_SOCKET=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
CONFIG_VIRTIO_VSOCKETS=y
CONFIG_VIRTIO_VSOCKETS_COMMON=y
CONFIG_NETLINK_DIAG=y
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=y
CONFIG_MPLS_IPTUNNEL=y
# CONFIG_HSR is not set
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
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=y
CONFIG_BAYCOM_EPP=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_GRCAN=y
CONFIG_PCH_CAN=y
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
# CONFIG_CAN_CC770_PLATFORM is not set
CONFIG_CAN_IFI_CANFD=y
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_SOFTING is not set

#
# CAN SPI interfaces
#
CONFIG_CAN_MCP251X=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

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
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
# CONFIG_BT is not set
# CONFIG_STREAM_PARSER is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
# CONFIG_DST_CACHE is not set
CONFIG_NET_DEVLINK=y
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
# CONFIG_STANDALONE is not set
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_OF_PARTS is not set
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
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
CONFIG_MTD_MAP_BANK_WIDTH_8=y
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_PHYSMAP_OF=y
CONFIG_MTD_PHYSMAP_OF_VERSATILE=y
# CONFIG_MTD_PHYSMAP_OF_GEMINI is not set
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_PCI=y
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_DT=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
# CONFIG_MTD_NAND_GPIO is not set
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_NAND_HISI504=y
# CONFIG_MTD_NAND_MTK is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_SPI_NOR is not set
# CONFIG_MTD_UBI is not set
CONFIG_OF=y
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

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
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_LANAI=y
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=y
# CONFIG_ATM_ZATM_DEBUG is not set
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
CONFIG_ATM_HE_USE_SUNI=y
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#

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
# CONFIG_AMD_XGBE_HAVE_ECC is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CAVIUM=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
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
# CONFIG_EZCHIP_NPS_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
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
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_MVNETA_BM is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
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
# CONFIG_QCA7000 is not set
# CONFIG_QCOM_EMAC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_SYNOPSYS_DWC_ETH_QOS is not set
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
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
CONFIG_NET_SB1000=y
# CONFIG_PHYLIB is not set
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
# CONFIG_WLAN_VENDOR_ADMTEK is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K_PCI=y
# CONFIG_WLAN_VENDOR_ATMEL is not set
# CONFIG_WLAN_VENDOR_BROADCOM is not set
CONFIG_WLAN_VENDOR_CISCO=y
CONFIG_WLAN_VENDOR_INTEL=y
CONFIG_WLAN_VENDOR_INTERSIL=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
CONFIG_HOSTAP_PLX=y
# CONFIG_HOSTAP_PCI is not set
CONFIG_PRISM54=y
# CONFIG_WLAN_VENDOR_MARVELL is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_WLAN_VENDOR_REALTEK is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_WLAN_VENDOR_ST is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WLAN_VENDOR_ZYDAS is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_FUJITSU_ES=y
# CONFIG_ISDN is not set

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
# CONFIG_KEYBOARD_ADC is not set
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
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
# CONFIG_MOUSE_PS2_OLPC is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_ELAN_I2C is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_AR1021_I2C=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8318 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_EGALAX=y
CONFIG_TOUCHSCREEN_EGALAX_SERIAL=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GOODIX=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_EKTF2127=y
CONFIG_TOUCHSCREEN_ELAN=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MELFAS_MIP4=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_IMX6UL_TSC is not set
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_UCB1400 is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WDT87XX_I2C=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC200X_CORE=y
CONFIG_TOUCHSCREEN_TSC2004=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
CONFIG_TOUCHSCREEN_SIS_I2C=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_SURFACE3_SPI=y
CONFIG_TOUCHSCREEN_SX8654=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_COLIBRI_VF50 is not set
CONFIG_TOUCHSCREEN_ROHM_BU21023=y
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SPI is not set
CONFIG_RMI4_SMB=y
# CONFIG_RMI4_F03 is not set
# CONFIG_RMI4_F11 is not set
# CONFIG_RMI4_F12 is not set
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
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
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_APBPS2 is not set
# CONFIG_SERIO_OLPC_APSP is not set
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
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVMEM is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
# CONFIG_SERIAL_8250_PNP is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_FSL is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
# CONFIG_SERIAL_8250_LPSS is not set
# CONFIG_SERIAL_8250_MID is not set
CONFIG_SERIAL_8250_MOXA=y
CONFIG_SERIAL_OF_PLATFORM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_SC16IS7XX_CORE=y
CONFIG_SERIAL_SC16IS7XX=y
CONFIG_SERIAL_SC16IS7XX_I2C=y
# CONFIG_SERIAL_SC16IS7XX_SPI is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_CONEXANT_DIGICOLOR=y
# CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_SPI=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_CRB=y
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_OF=y

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
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_MUX_PINCTRL is not set
CONFIG_I2C_MUX_REG=y
# CONFIG_I2C_DEMUX_PINCTRL is not set
CONFIG_I2C_MUX_MLXCPLD=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
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
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
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
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_EMEV2=y
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
# CONFIG_I2C_RK3X is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SLAVE=y
# CONFIG_I2C_SLAVE_EEPROM is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_AXI_SPI_ENGINE=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_CADENCE=y
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_LIB=y
CONFIG_SPI_FSL_SPI=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_ROCKCHIP=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

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
CONFIG_HSI_CHAR=y

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

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_GENERIC_PINCTRL_GROUPS=y
CONFIG_PINMUX=y
CONFIG_GENERIC_PINMUX_FUNCTIONS=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AS3722 is not set
CONFIG_PINCTRL_AMD=y
CONFIG_PINCTRL_SINGLE=y
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_MAX77620=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_PINCTRL_CHERRYVIEW=y
CONFIG_PINCTRL_INTEL=y
CONFIG_PINCTRL_BROXTON=y
# CONFIG_PINCTRL_GEMINILAKE is not set
CONFIG_PINCTRL_SUNRISEPOINT=y
# CONFIG_PINCTRL_TI_IODELAY is not set
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
CONFIG_GPIO_ALTERA=y
CONFIG_GPIO_AMDPT=y
CONFIG_GPIO_AXP209=y
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_GRGPIO=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_LYNXPOINT=y
CONFIG_GPIO_MOCKUP=y
CONFIG_GPIO_STA2X11=y
# CONFIG_GPIO_SYSCON is not set
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_XILINX=y

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_IT87 is not set
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_SCH311X is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_ADNP=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_CRYSTAL_COVE=y
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_DA9052=y
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_KEMPLD=y
CONFIG_GPIO_LP873X=y
CONFIG_GPIO_MAX77620=y
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TPS65086 is not set
CONFIG_GPIO_TPS65218=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_UCB1400 is not set
# CONFIG_GPIO_WHISKEY_COVE is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8994=y

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_RDC321X is not set
CONFIG_GPIO_SODAVILLE=y

#
# SPI GPIO expanders
#
# CONFIG_GPIO_74X164 is not set
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_PISOSR=y

#
# SPI or I2C GPIO expanders
#
CONFIG_GPIO_MCP23S08=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
# CONFIG_POWER_AVS is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_ACT8945A is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
# CONFIG_CHARGER_SBS is not set
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=y
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_DA9052=y
# CONFIG_AXP288_FUEL_GAUGE is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_TWL4030_MADC is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_DETECTOR_MAX14656 is not set
# CONFIG_CHARGER_MAX77693 is not set
CONFIG_CHARGER_MAX8997=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_CHARGER_TPS65217=y
CONFIG_BATTERY_GAUGE_LTC2941=y
CONFIG_BATTERY_RT5033=y
CONFIG_CHARGER_RT9455=y
CONFIG_AXP20X_POWER=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DELL_SMM=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_I5500=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX31722=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_TC654=y
# CONFIG_SENSORS_MENF21BMC_HWMON is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT7802 is not set
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_LTC2978_REGULATOR=y
CONFIG_SENSORS_LTC3815=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX20751=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_PWM_FAN is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHT3x=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_STTS751 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_INA3221=y
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP108=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_OF is not set
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_POWER_ALLOCATOR=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_MAX77620_THERMAL=y
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_X86_PKG_TEMP_THERMAL is not set
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=y
CONFIG_ACPI_THERMAL_REL=y
CONFIG_INT3406_THERMAL=y
# CONFIG_INTEL_BXT_PMIC_THERMAL is not set
# CONFIG_INTEL_PCH_THERMAL is not set
# CONFIG_GENERIC_ADC_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_PCI=y
# CONFIG_BCMA_SFLASH is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_ACT8945A=y
CONFIG_MFD_AS3711=y
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_ATMEL_FLEXCOM=y
CONFIG_MFD_ATMEL_HLCDC=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=y
CONFIG_MFD_DA9063=y
# CONFIG_MFD_DA9150 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_MFD_HI6421_PMIC=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
CONFIG_INTEL_SOC_PMIC=y
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77620=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX77843 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6397=y
CONFIG_MFD_MENF21BMC=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_UCB1400_CORE=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RT5033=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_RK808 is not set
CONFIG_MFD_RN5T618=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SKY81452=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_STA2X11=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_CS47L24=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8998=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_ACT8945A=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AS3722=y
# CONFIG_REGULATOR_AXP20X is not set
# CONFIG_REGULATOR_BCM590XX is not set
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9062=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_HI6421=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP873X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX77620 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_MT6323=y
CONFIG_REGULATOR_MT6397=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_PV88060=y
CONFIG_REGULATOR_PV88080=y
# CONFIG_REGULATOR_PV88090 is not set
CONFIG_REGULATOR_PWM=y
CONFIG_REGULATOR_RN5T618=y
# CONFIG_REGULATOR_RT5033 is not set
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_SKY81452=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65086=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS65218 is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_MEDIA_CEC_DEBUG=y
CONFIG_MEDIA_CEC_EDID=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_SHARP_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
CONFIG_IR_HIX5HD2=y
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
CONFIG_IR_FINTEK=y
CONFIG_IR_NUVOTON=y
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_SPI is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=y
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=y
CONFIG_IR_SERIAL=y
CONFIG_IR_SERIAL_TRANSMITTER=y
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Tools to develop new frontends
#

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y
CONFIG_DRM_GEM_CMA_HELPER=y
CONFIG_DRM_KMS_CMA_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_USERPTR is not set
CONFIG_DRM_AMDGPU=y
CONFIG_DRM_AMDGPU_SI=y
# CONFIG_DRM_AMDGPU_CIK is not set
CONFIG_DRM_AMDGPU_USERPTR=y
# CONFIG_DRM_AMDGPU_GART_DEBUGFS is not set

#
# ACP (Audio CoProcessor) Configuration
#
CONFIG_DRM_AMD_ACP=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_DRM_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# CONFIG_DRM_DUMB_VGA_DAC is not set
# CONFIG_DRM_NXP_PTN3460 is not set
# CONFIG_DRM_PARADE_PS8622 is not set
# CONFIG_DRM_SIL_SII8620 is not set
# CONFIG_DRM_SII902X is not set
# CONFIG_DRM_TOSHIBA_TC358767 is not set
# CONFIG_DRM_TI_TFP410 is not set
CONFIG_DRM_I2C_ADV7511=y
CONFIG_DRM_I2C_ADV7511_AUDIO=y
CONFIG_DRM_I2C_ADV7533=y
CONFIG_DRM_ARCPGU=y
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_MXSFB is not set
# CONFIG_DRM_LEGACY is not set

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
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
CONFIG_FB_SSD1307=y
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MAX8925 is not set
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_PM8941_WLED=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_OT200 is not set
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_SKY81452=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_PCM_ELD=y
CONFIG_SND_PCM_IEC958=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_PCM_TIMER is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_PROC_FS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA_CORE=y
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_EXT_CORE=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_SPI is not set
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_AC97_BUS=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
# CONFIG_SND_SOC_AMD_ACP is not set
CONFIG_SND_ATMEL_SOC=y
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
CONFIG_SND_SOC_FSL_SAI=y
CONFIG_SND_SOC_FSL_SSI=y
CONFIG_SND_SOC_FSL_SPDIF=y
# CONFIG_SND_SOC_FSL_ESAI is not set
CONFIG_SND_SOC_IMX_AUDMUX=y
CONFIG_SND_SOC_IMG=y
CONFIG_SND_SOC_IMG_I2S_IN=y
CONFIG_SND_SOC_IMG_I2S_OUT=y
# CONFIG_SND_SOC_IMG_PARALLEL_OUT is not set
# CONFIG_SND_SOC_IMG_SPDIF_IN is not set
# CONFIG_SND_SOC_IMG_SPDIF_OUT is not set
CONFIG_SND_SOC_IMG_PISTACHIO_INTERNAL_DAC=y
CONFIG_SND_SST_MFLD_PLATFORM=y
CONFIG_SND_SST_IPC=y
CONFIG_SND_SST_IPC_ACPI=y
CONFIG_SND_SOC_INTEL_SST=y
CONFIG_SND_SOC_INTEL_SST_ACPI=y
CONFIG_SND_SOC_INTEL_SST_MATCH=y
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH=y
# CONFIG_SND_SOC_INTEL_BXT_RT298_MACH is not set
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=y
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=y
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=y
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=y
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=y
CONFIG_SND_SOC_INTEL_SKYLAKE=y
# CONFIG_SND_SOC_INTEL_SKL_RT286_MACH is not set
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_SSM4567_MACH=y
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_MAX98357A_MACH=y
# CONFIG_SND_SOC_XTFPGA_I2S is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_AC97_CODEC=y
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_ADAU7002=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4554=y
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4642 is not set
CONFIG_SND_SOC_AK5386=y
# CONFIG_SND_SOC_ALC5623 is not set
CONFIG_SND_SOC_BT_SCO=y
CONFIG_SND_SOC_CS35L32=y
# CONFIG_SND_SOC_CS35L33 is not set
CONFIG_SND_SOC_CS35L34=y
CONFIG_SND_SOC_CS42L42=y
# CONFIG_SND_SOC_CS42L51_I2C is not set
CONFIG_SND_SOC_CS42L52=y
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
CONFIG_SND_SOC_CS4265=y
CONFIG_SND_SOC_CS4270=y
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
CONFIG_SND_SOC_CS4349=y
CONFIG_SND_SOC_CS53L30=y
CONFIG_SND_SOC_DA7219=y
CONFIG_SND_SOC_DMIC=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_ES8328=y
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDMI=y
CONFIG_SND_SOC_INNO_RK3036=y
CONFIG_SND_SOC_MAX98090=y
CONFIG_SND_SOC_MAX98357A=y
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
CONFIG_SND_SOC_PCM179X=y
# CONFIG_SND_SOC_PCM179X_I2C is not set
CONFIG_SND_SOC_PCM179X_SPI=y
CONFIG_SND_SOC_PCM3168A=y
# CONFIG_SND_SOC_PCM3168A_I2C is not set
CONFIG_SND_SOC_PCM3168A_SPI=y
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
# CONFIG_SND_SOC_PCM512x_SPI is not set
CONFIG_SND_SOC_RL6231=y
CONFIG_SND_SOC_RT5616=y
CONFIG_SND_SOC_RT5631=y
CONFIG_SND_SOC_RT5640=y
CONFIG_SND_SOC_RT5645=y
CONFIG_SND_SOC_RT5651=y
CONFIG_SND_SOC_RT5670=y
# CONFIG_SND_SOC_RT5677_SPI is not set
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
# CONFIG_SND_SOC_SPDIF is not set
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_SSM2602_SPI=y
CONFIG_SND_SOC_SSM2602_I2C=y
CONFIG_SND_SOC_SSM4567=y
# CONFIG_SND_SOC_STA32X is not set
CONFIG_SND_SOC_STA350=y
CONFIG_SND_SOC_STI_SAS=y
CONFIG_SND_SOC_TAS2552=y
# CONFIG_SND_SOC_TAS5086 is not set
CONFIG_SND_SOC_TAS571X=y
# CONFIG_SND_SOC_TAS5720 is not set
CONFIG_SND_SOC_TFA9879=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC23_I2C=y
CONFIG_SND_SOC_TLV320AIC23_SPI=y
CONFIG_SND_SOC_TLV320AIC31XX=y
# CONFIG_SND_SOC_TLV320AIC3X is not set
CONFIG_SND_SOC_TS3A227E=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
# CONFIG_SND_SOC_WM8731 is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
# CONFIG_SND_SOC_WM8770 is not set
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8804_I2C=y
CONFIG_SND_SOC_WM8804_SPI=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8960=y
# CONFIG_SND_SOC_WM8962 is not set
CONFIG_SND_SOC_WM8974=y
CONFIG_SND_SOC_WM8978=y
# CONFIG_SND_SOC_WM8985 is not set
CONFIG_SND_SOC_NAU8810=y
CONFIG_SND_SOC_NAU8825=y
# CONFIG_SND_SOC_TPA6130A2 is not set
CONFIG_SND_SIMPLE_CARD_UTILS=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SND_SIMPLE_SCU_CARD is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_AAT1290=y
CONFIG_LEDS_BCM6328=y
CONFIG_LEDS_BCM6358=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP3952=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8860 is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_MAX77693=y
# CONFIG_LEDS_MAX8997 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_MENF21BMC=y
# CONFIG_LEDS_KTD2692 is not set
CONFIG_LEDS_IS31FL319X=y
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
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_MTD=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_IE31200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
# CONFIG_EDAC_I7CORE is not set
CONFIG_EDAC_I82860=y
CONFIG_EDAC_R82600=y
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
# CONFIG_IMG_ASCII_LCD is not set
CONFIG_HT16K33=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_INPUT=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_SMBIOS is not set
CONFIG_DELL_WMI_AIO=y
CONFIG_DELL_SMO8800=y
# CONFIG_DELL_RBTN is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
CONFIG_TC1100_WMI=y
CONFIG_HP_ACCEL=y
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
CONFIG_INTEL_MENLOW=y
CONFIG_ASUS_WIRELESS=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_TOSHIBA_HAPS=y
CONFIG_TOSHIBA_WMI=y
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_HID_EVENT is not set
CONFIG_INTEL_VBTN=y
CONFIG_INTEL_IPS=y
CONFIG_INTEL_PMC_CORE=y
# CONFIG_IBM_RTL is not set
CONFIG_XO1_RFKILL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
# CONFIG_PVPANIC is not set
CONFIG_INTEL_PMC_IPC=y
CONFIG_INTEL_BXTWC_PMIC_TMU=y
CONFIG_SURFACE_PRO3_BUTTON=y
CONFIG_INTEL_PUNIT_IPC=y
CONFIG_MLX_CPLD_PLATFORM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI514=y
# CONFIG_COMMON_CLK_SI570 is not set
CONFIG_COMMON_CLK_CDCE706=y
CONFIG_COMMON_CLK_CDCE925=y
# CONFIG_COMMON_CLK_CS2000_CP is not set
CONFIG_COMMON_CLK_S2MPS11=y
# CONFIG_COMMON_CLK_NXP is not set
CONFIG_COMMON_CLK_PWM=y
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set
CONFIG_COMMON_CLK_MEDIATEK=y
CONFIG_COMMON_CLK_MT2701=y
# CONFIG_COMMON_CLK_MT2701_MMSYS is not set
# CONFIG_COMMON_CLK_MT2701_IMGSYS is not set
CONFIG_COMMON_CLK_MT2701_VDECSYS=y
CONFIG_COMMON_CLK_MT2701_HIFSYS=y
# CONFIG_COMMON_CLK_MT2701_ETHSYS is not set
CONFIG_COMMON_CLK_MT2701_BDPSYS=y

#
# Hardware Spinlock drivers
#

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
CONFIG_PCC=y
CONFIG_ALTERA_MBOX=y
CONFIG_MAILBOX_TEST=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#

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
# CONFIG_SUNXI_SRAM is not set
CONFIG_SOC_TI=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
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
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_ARIZONA=y
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX3355=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_QCOM_SPMI_MISC is not set
CONFIG_EXTCON_RT8973A=y
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
CONFIG_IIO_SW_TRIGGER=y
CONFIG_IIO_TRIGGERED_EVENT=y

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_BMA220=y
CONFIG_BMC150_ACCEL=y
CONFIG_BMC150_ACCEL_I2C=y
CONFIG_BMC150_ACCEL_SPI=y
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
CONFIG_DMARD06=y
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
# CONFIG_KXSD9 is not set
CONFIG_KXCJK1013=y
CONFIG_MC3230=y
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
CONFIG_MMA7660=y
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
CONFIG_AD7291=y
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
CONFIG_AD7766=y
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7887=y
CONFIG_AD7923=y
CONFIG_AD799X=y
CONFIG_AXP288_ADC=y
# CONFIG_CC10001_ADC is not set
# CONFIG_ENVELOPE_DETECTOR is not set
CONFIG_HI8435=y
CONFIG_LTC2485=y
CONFIG_MAX1027=y
CONFIG_MAX1363=y
# CONFIG_MCP320X is not set
CONFIG_MCP3422=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_ADC0832=y
CONFIG_TI_ADC12138=y
# CONFIG_TI_ADC128S052 is not set
CONFIG_TI_ADC161S626=y
CONFIG_TI_ADS8688=y
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL4030_MADC=y
CONFIG_TWL6030_GPADC=y
CONFIG_VF610_ADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
CONFIG_IAQCORE=y
CONFIG_VZ89X=y

#
# Hid Sensor IIO Common
#
CONFIG_IIO_MS_SENSORS_I2C=y

#
# SSP Sensor Common
#
CONFIG_IIO_SSP_SENSORS_COMMONS=y
CONFIG_IIO_SSP_SENSORHUB=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Counters
#

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
# CONFIG_AD5380 is not set
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
CONFIG_AD5592R_BASE=y
CONFIG_AD5592R=y
CONFIG_AD5593R=y
CONFIG_AD5504=y
CONFIG_AD5624R_SPI=y
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
CONFIG_AD5761=y
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
CONFIG_AD8801=y
CONFIG_DPOT_DAC=y
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MAX5821 is not set
CONFIG_MCP4725=y
# CONFIG_MCP4922 is not set
# CONFIG_VF610_DAC is not set

#
# IIO dummy driver
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
CONFIG_MPU3050=y
CONFIG_MPU3050_I2C=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4403=y
CONFIG_AFE4404=y
# CONFIG_MAX30100 is not set

#
# Humidity sensors
#
CONFIG_AM2315=y
CONFIG_DHT11=y
CONFIG_HDC100X=y
# CONFIG_HTS221 is not set
CONFIG_HTU21=y
# CONFIG_SI7005 is not set
CONFIG_SI7020=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
CONFIG_KMX61=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=y
CONFIG_INV_MPU6050_SPI=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ACPI_ALS=y
CONFIG_ADJD_S311=y
CONFIG_AL3320A=y
CONFIG_APDS9300=y
CONFIG_APDS9960=y
CONFIG_BH1750=y
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
CONFIG_CM3232=y
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_ISL29125=y
CONFIG_JSA1212=y
# CONFIG_RPR0521 is not set
CONFIG_LTR501=y
CONFIG_MAX44000=y
CONFIG_OPT3001=y
CONFIG_PA12203001=y
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
CONFIG_TCS3414=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL2583=y
CONFIG_TSL4531=y
CONFIG_US5182D=y
CONFIG_VCNL4000=y
CONFIG_VEML6070=y

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
CONFIG_AK8975=y
# CONFIG_AK09911 is not set
CONFIG_BMC150_MAGN=y
CONFIG_BMC150_MAGN_I2C=y
CONFIG_BMC150_MAGN_SPI=y
# CONFIG_MAG3110 is not set
CONFIG_MMC35240=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y
CONFIG_SENSORS_HMC5843_SPI=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
# CONFIG_IIO_HRTIMER_TRIGGER is not set
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_TIGHTLOOP_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Digital potentiometers
#
CONFIG_DS1803=y
CONFIG_MAX5487=y
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
CONFIG_TPL0102=y

#
# Digital potentiostats
#
CONFIG_LMP91000=y

#
# Pressure sensors
#
CONFIG_ABP060MG=y
# CONFIG_BMP280 is not set
# CONFIG_HP03 is not set
CONFIG_MPL115=y
CONFIG_MPL115_I2C=y
CONFIG_MPL115_SPI=y
CONFIG_MPL3115=y
# CONFIG_MS5611 is not set
CONFIG_MS5637=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
CONFIG_T5403=y
# CONFIG_HP206C is not set
CONFIG_ZPA2326=y
CONFIG_ZPA2326_I2C=y
CONFIG_ZPA2326_SPI=y

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Proximity sensors
#
CONFIG_LIDAR_LITE_V2=y
CONFIG_SX9500=y

#
# Temperature sensors
#
CONFIG_MAXIM_THERMOCOUPLE=y
# CONFIG_MLX90614 is not set
# CONFIG_TMP006 is not set
CONFIG_TSYS01=y
CONFIG_TSYS02D=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_ATMEL_HLCDC_PWM=y
# CONFIG_PWM_CRC is not set
CONFIG_PWM_FSL_FTM=y
CONFIG_PWM_LPSS=y
CONFIG_PWM_LPSS_PCI=y
# CONFIG_PWM_LPSS_PLATFORM is not set
CONFIG_PWM_PCA9685=y
CONFIG_PWM_STMPE=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_ATH79 is not set
# CONFIG_RESET_BERLIN is not set
# CONFIG_RESET_LPC18XX is not set
# CONFIG_RESET_MESON is not set
# CONFIG_RESET_PISTACHIO is not set
# CONFIG_RESET_SOCFPGA is not set
# CONFIG_RESET_STM32 is not set
# CONFIG_RESET_SUNXI is not set
CONFIG_TI_SYSCON_RESET=y
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
CONFIG_PHY_PXA_28NM_USB2=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_MCE_AMD_INJ is not set
CONFIG_THUNDERBOLT=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_NVMEM=y
# CONFIG_STM is not set
CONFIG_INTEL_TH=y
# CONFIG_INTEL_TH_PCI is not set
CONFIG_INTEL_TH_GTH=y
CONFIG_INTEL_TH_MSU=y
CONFIG_INTEL_TH_PTI=y
# CONFIG_INTEL_TH_DEBUG is not set

#
# FPGA Configuration Support
#
# CONFIG_FPGA is not set

#
# Firmware Drivers
#
# CONFIG_ARM_SCPI_PROTOCOL is not set
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set
CONFIG_EFI_ESRT=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
CONFIG_UEFI_CPER=y
CONFIG_EFI_DEV_PATH_PARSER=y

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
# CONFIG_MANDATORY_FILE_LOCKING is not set
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
# CONFIG_JFFS2_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_ZLIB_COMPRESS is not set
CONFIG_PSTORE_LZO_COMPRESS=y
# CONFIG_PSTORE_LZ4_COMPRESS is not set
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_PMSG is not set
CONFIG_PSTORE_RAM=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
CONFIG_PAGE_POISONING=y
# CONFIG_PAGE_POISONING_NO_SANITY is not set
# CONFIG_PAGE_POISONING_ZERO is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_REFCOUNT is not set
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
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHED_INFO is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_DEBUG_TIMEKEEPING is not set
CONFIG_DEBUG_PREEMPT=y

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
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_PERF_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
CONFIG_CPU_HOTPLUG_STATE_CONTROL=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_FUTEX=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
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

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_TEST_PRINTF=y
# CONFIG_TEST_BITMAP is not set
CONFIG_TEST_UUID=y
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_TEST_HASH=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_FIRMWARE is not set
CONFIG_TEST_UDELAY=y
CONFIG_MEMTEST=y
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
CONFIG_UBSAN=y
# CONFIG_UBSAN_SANITIZE_ALL is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_NULL=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_EFI=y
CONFIG_X86_PTDUMP_CORE=y
CONFIG_X86_PTDUMP=y
# CONFIG_EFI_PGT_DUMP is not set
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_WX is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_ENTRY=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
CONFIG_PUNIT_ATOM_DEBUG=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HAVE_ARCH_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY is not set
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
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_MCRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
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
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_842 is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

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
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set

#
# Certificates for signature checking
#
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
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
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
# CONFIG_SG_SPLIT is not set
# CONFIG_SG_POOL is not set
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_STACKDEPOT=y

--=_58b07b30.uKO2RyuypkguSQpGoDoIOqyy3gHh6gY+cTXfAleOcYcZL8il--
