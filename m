Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37126 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbAFJLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 04:11:31 -0500
Received: by mail-pd0-f169.google.com with SMTP id z10so30178639pdj.0
        for <linux-media@vger.kernel.org>; Tue, 06 Jan 2015 01:11:30 -0800 (PST)
Message-ID: <54ABA6BE.5030901@gmail.com>
Date: Tue, 06 Jan 2015 01:11:26 -0800
From: Alaganraj Sandhanam <alaganraj.sandhanam@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp Device Tree support status
References: <20140928221341.GQ2939@valkosipuli.retiisi.org.uk> <54330499.50905@gmail.com> <20141008113303.GY2939@valkosipuli.retiisi.org.uk> <5436F253.7060203@gmail.com> <20141010075112.GA2939@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141010075112.GA2939@valkosipuli.retiisi.org.uk>
Content-Type: multipart/mixed;
 boundary="------------010408010607030402030802"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010408010607030402030802
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi Sakari, Laurent,

Wish You A Happy New Year!!!

On Friday 10 October 2014 12:51 AM, Sakari Ailus wrote:
> Hi Alaganjar,
> 
> On Fri, Oct 10, 2014 at 02:08:43AM +0530, Alaganraj Sandhanam wrote:
>> Hi Sakari,
>>
>> On Wednesday 08 October 2014 05:03 PM, Sakari Ailus wrote:
>>> Hi Alaganjar,
>>>
>>> On Tue, Oct 07, 2014 at 02:37:37AM +0530, Alaganraj Sandhanam wrote:
>>>> Hi Sakari,
>>>>
>>>> Thanks for the patches.
>>>> On Monday 29 September 2014 03:43 AM, Sakari Ailus wrote:
>>>>> Hi,
>>>>>
>>>>> I managed to find some time for debugging my original omap3isp DT support
>>>>> patchset (which includes smiapp DT support as well), and found a few small
>>>>> but important bugs.
>>>>>
>>>>> The status is now that images can be captured using the Nokia N9 camera, in
>>>>> which the sensor is connected to the CSI-2 interface. Laurent confirmed that
>>>>> the parallel interface worked for him (Beagleboard, mt9p031 sensor on
>>>>> Leopard imaging's li-5m03 board).
>>>> Good news!
>>>>>
>>>>> These patches (on top of the smiapp patches I recently sent for review which
>>>>> are in much better shape) are still experimental and not ready for review. I
>>>>> continue to clean them up and post them to the list when that is done. For
>>>>> now they can be found here:
>>>>>
>>>>> <URL:http://git.linuxtv.org/cgit.cgi/sailus/media_tree.git/log/?h=rm696-043-dt>
>>>>>
>>>> I couldn't clone the repo, getting "remote corrupt" error.
>>>>
>>>> $ git remote -v
>>>> media-sakari	git://linuxtv.org/sailus/media_tree.git (fetch)
>>>> media-sakari	git://linuxtv.org/sailus/media_tree.git (push)
>>>> origin	git://linuxtv.org/media_tree.git (fetch)
>>>> origin	git://linuxtv.org/media_tree.git (push)
>>>> sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (fetch)
>>>> sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (push)
>>>>
>>>> $ git fetch media-sakari
>>>> warning: cannot parse SRV response: Message too long
>>>> remote: error: Could not read 5ea878796f0a1d9649fe43a6a09df53d3915c0ef
>>>> remote: fatal: revision walk setup failed
>>>> remote: aborting due to possible repository corruption on the remote side.
>>>> fatal: protocol error: bad pack header
>>>
>>> I'm not sure what this could be related. Can you fetch from other trees,
>>> e.g. your origin remote? Do you get the same error from the remote on
>>> vihersipuli, and by using http instead?
>>>
>> I'm able to fetch from "origin" and "vihersipuli" remotes.
>> problem with only "git://linuxtv.org/sailus/media_tree.git" remote.
> 
> Then you can get the same branch (or later) from vihersipuli. It's available
> there as well.
> 

Sorry for late response, because of some personal work I couldn't get
time to test rm696-043-dt branch.

I've beagleboard xM and MT9P031 Leopard imaging's LI-5M03 board.

Compilation step:

$ git checkout -b rm696-043-dt remotes/sakari/rm696-043-dt
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- omap2plus_defconfig
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
Enabled OMAP3ISP, MT9P031, Media controller support

$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4

Copy images to SD card
$ sudo cp -f arch/arm/boot/zImage /media/alagan/BOOT/
$ sudo cp -f arch/arm/boot/dts/omap3-beagle-xm.dtb /media/alagan/BOOT/dtbs/

Kernel is booting but getting below error
of_graph_get_next_endpoint(): no port node found in
/ocp/omap3_isp@480bc000/ports

Also device node /dev/media0 is missing and sensor not detected.

Please find log below:
U-Boot SPL 2014.07-rc3-dirty (Jun 16 2014 - 02:11:57)
SPL: Please implement spl_start_uboot() for your board
SPL: Direct Linux boot not active!
reading u-boot.img
reading u-boot.img


U-Boot 2014.07-rc3-dirty (Jun 16 2014 - 02:11:57)

OMAP36XX/37XX-GP ES1.2, CPU-OPP2, L3-200MHz, Max CPU Clock 1 Ghz
OMAP3 Beagle board + LPDDR/NAND
I2C:   ready
DRAM:  512 MiB
NAND:  0 MiB
MMC:   OMAP SD/MMC: 0
*** Warning - readenv() failed, using default environment

Beagle xM Rev C
No EEPROM on expansion board
No EEPROM on expansion board
Die ID #327c00029ff80000016849a904021023
Net:   usb_ether
Hit any key to stop autoboot:  0
mmc0 is current device
gpio: pin 173 (gpio 173) value is 0
gpio: pin 4 (gpio 4) value is 0
SD/MMC found on device 0
reading uEnv.txt
153 bytes read in 3 ms (49.8 KiB/s)
Loaded environment from uEnv.txt
Importing environment from mmc ...
Checking if lcdcmd is set ...
Checking if uenvcmd is set ...
Running default loadimage ...
reading /zImage
4583568 bytes read in 293 ms (14.9 MiB/s)
reading /dtbs/omap3-beagle-xm.dtb
62434 bytes read in 24 ms (2.5 MiB/s)
Booting from mmc ...
Kernel image @ 0x80300000 [ 0x000000 - 0x45f090 ]
## Flattened Device Tree blob at 815f0000
   Booting using the fdt blob at 0x815f0000
   Using Device Tree in place at 815f0000, end 816023e1

Starting kernel ...

[    0.498565] platform 48058000.ssi-controller: Cannot lookup hwmod 'ssi'
[    0.553863] edma-dma-engine edma-dma-engine.0: Can't allocate PaRAM
dummy slot
[    1.358947] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.386444] twl4030_keypad 48070000.i2c:twl@48:keypad: OF:
linux,keymap property not defined in /ocp/i2c@48070000/twl@48/keypad
[    1.398681] twl4030_keypad 48070000.i2c:twl@48:keypad: Failed to
build keymap
[    1.429534] of_graph_get_next_endpoint(): no port node found in
/ocp/omap3_isp@480bc000/ports
[    1.503082] omap2_set_init_voltage: unable to find boot up OPP for
vdd_mpu_iva
[    1.510711] omap2_set_init_voltage: unable to set vdd_mpu_iva
[    1.516876] omap2_set_init_voltage: unable to find boot up OPP for
vdd_core
[    1.524261] omap2_set_init_voltage: unable to set vdd_core
[    1.822723] Failed to execute /lib/systemd/systemd (error -2).
Attempting defaults...
Starting logging: OK
Starting portmap: done
Initializing random number generator... done.
Starting ALSA... /usr/sbin/alsactl: load_state:1625: No soundcards found...
done.
Starting network...
Starting sshd: OK

Welcome to BeagleBoard-xM
beagleboard-xm login: root
[root@beagleboard-xm ~]# ls /dev/med*
ls: /dev/med*: No such file or directory

Filesystem has yavta and media-ctl application, also verified capture
for 3.2.8(Non DT)

Am I using correct defconfig?
Please find .config file in attachment.

Can you please guide me to verify the parallel interface?

Thanks&Regards,
Alaganraj

--------------010408010607030402030802
Content-Type: text/plain; charset=UTF-8;
 name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/arm 3.17.0-rc1 Kernel Configuration
#
CONFIG_ARM=y
CONFIG_ARM_HAS_SG_CHAIN=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_ARM_DMA_USE_IOMMU=y
CONFIG_ARM_DMA_IOMMU_ALIGNMENT=8
CONFIG_MIGHT_HAVE_PCI=y
CONFIG_SYS_SUPPORTS_APM_EMULATION=y
CONFIG_HAVE_PROC_CPU=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_BANDGAP=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_VECTORS_BASE=0xffff0000
CONFIG_ARM_PATCH_PHYS_VIRT=y
CONFIG_GENERIC_BUG=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
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
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_ARCH_HAS_TICK_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_GENERIC_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_GENERIC_IDLE_POLL_SETUP=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# System Type
#
CONFIG_MMU=y
CONFIG_ARCH_MULTIPLATFORM=y
# CONFIG_ARCH_INTEGRATOR is not set
# CONFIG_ARCH_REALVIEW is not set
# CONFIG_ARCH_VERSATILE is not set
# CONFIG_ARCH_AT91 is not set
# CONFIG_ARCH_CLPS711X is not set
# CONFIG_ARCH_GEMINI is not set
# CONFIG_ARCH_EBSA110 is not set
# CONFIG_ARCH_EP93XX is not set
# CONFIG_ARCH_FOOTBRIDGE is not set
# CONFIG_ARCH_NETX is not set
# CONFIG_ARCH_IOP13XX is not set
# CONFIG_ARCH_IOP32X is not set
# CONFIG_ARCH_IOP33X is not set
# CONFIG_ARCH_IXP4XX is not set
# CONFIG_ARCH_DOVE is not set
# CONFIG_ARCH_MV78XX0 is not set
# CONFIG_ARCH_ORION5X is not set
# CONFIG_ARCH_MMP is not set
# CONFIG_ARCH_KS8695 is not set
# CONFIG_ARCH_W90X900 is not set
# CONFIG_ARCH_LPC32XX is not set
# CONFIG_ARCH_PXA is not set
# CONFIG_ARCH_MSM is not set
# CONFIG_ARCH_SHMOBILE_LEGACY is not set
# CONFIG_ARCH_RPC is not set
# CONFIG_ARCH_SA1100 is not set
# CONFIG_ARCH_S3C24XX is not set
# CONFIG_ARCH_S3C64XX is not set
# CONFIG_ARCH_DAVINCI is not set
# CONFIG_ARCH_OMAP1 is not set

#
# Multiple platform selection
#

#
# CPU Core family selection
#
CONFIG_ARCH_MULTI_V6=y
CONFIG_ARCH_MULTI_V7=y
CONFIG_ARCH_MULTI_V6_V7=y
# CONFIG_ARCH_MULTI_CPU_AUTO is not set
# CONFIG_ARCH_VIRT is not set
# CONFIG_ARCH_MVEBU is not set
# CONFIG_ARCH_BCM is not set
# CONFIG_ARCH_BERLIN is not set
# CONFIG_ARCH_CNS3XXX is not set
# CONFIG_ARCH_HIGHBANK is not set
# CONFIG_ARCH_HISI is not set
# CONFIG_ARCH_KEYSTONE is not set
# CONFIG_ARCH_MXC is not set
# CONFIG_ARCH_MEDIATEK is not set

#
# TI OMAP Common Features
#

#
# OMAP Feature Selections
#
CONFIG_POWER_AVS_OMAP=y
CONFIG_POWER_AVS_OMAP_CLASS3=y
CONFIG_OMAP_RESET_CLOCKS=y
CONFIG_OMAP_MUX=y
CONFIG_OMAP_MUX_DEBUG=y
CONFIG_OMAP_MUX_WARNINGS=y
CONFIG_OMAP_32K_TIMER=y
# CONFIG_OMAP3_L2_AUX_SECURE_SAVE_RESTORE is not set
CONFIG_OMAP_DM_TIMER=y
CONFIG_OMAP_PM_NOOP=y
CONFIG_MACH_OMAP_GENERIC=y

#
# TI OMAP/AM/DM/DRA Family
#
CONFIG_ARCH_OMAP=y
CONFIG_ARCH_OMAP2=y
CONFIG_ARCH_OMAP3=y
CONFIG_ARCH_OMAP4=y
CONFIG_SOC_OMAP5=y
CONFIG_SOC_AM33XX=y
CONFIG_SOC_AM43XX=y
CONFIG_SOC_DRA7XX=y
CONFIG_ARCH_OMAP2PLUS=y

#
# TI OMAP2/3/4 Specific Features
#
CONFIG_ARCH_OMAP2PLUS_TYPICAL=y
CONFIG_SOC_HAS_OMAP2_SDRC=y
CONFIG_SOC_HAS_REALTIME_COUNTER=y

#
# OMAP Core Type
#
CONFIG_SOC_OMAP2420=y
CONFIG_SOC_OMAP2430=y
CONFIG_SOC_OMAP3430=y
CONFIG_SOC_TI81XX=y
CONFIG_OMAP_PACKAGE_CBB=y
CONFIG_OMAP_PACKAGE_CUS=y

#
# OMAP Legacy Platform Data Board Type
#
CONFIG_MACH_OMAP2_TUSB6010=y
CONFIG_MACH_OMAP3_BEAGLE=y
CONFIG_MACH_DEVKIT8000=y
CONFIG_MACH_OMAP_LDP=y
CONFIG_MACH_OMAP3530_LV_SOM=y
CONFIG_MACH_OMAP3_TORPEDO=y
CONFIG_MACH_OVERO=y
CONFIG_MACH_OMAP3517EVM=y
# CONFIG_MACH_CRANEBOARD is not set
CONFIG_MACH_OMAP3_PANDORA=y
CONFIG_MACH_TOUCHBOOK=y
CONFIG_MACH_OMAP_3430SDP=y
CONFIG_MACH_NOKIA_N810=y
CONFIG_MACH_NOKIA_N810_WIMAX=y
CONFIG_MACH_NOKIA_N8X0=y
CONFIG_MACH_NOKIA_RX51=y
CONFIG_MACH_CM_T35=y
CONFIG_MACH_CM_T3517=y
CONFIG_MACH_CM_T3730=y
CONFIG_MACH_SBC3530=y
CONFIG_MACH_TI8168EVM=y
CONFIG_MACH_TI8148EVM=y
# CONFIG_OMAP3_EMU is not set
# CONFIG_OMAP3_SDRC_AC_TIMING is not set
# CONFIG_ARCH_PICOXCELL is not set
# CONFIG_ARCH_QCOM is not set
# CONFIG_ARCH_ROCKCHIP is not set
# CONFIG_ARCH_SOCFPGA is not set
# CONFIG_PLAT_SPEAR is not set
# CONFIG_ARCH_STI is not set
# CONFIG_ARCH_S5PV210 is not set
# CONFIG_ARCH_EXYNOS is not set
# CONFIG_ARCH_SHMOBILE_MULTI is not set
# CONFIG_ARCH_SUNXI is not set
# CONFIG_ARCH_SIRF is not set
# CONFIG_ARCH_TEGRA is not set
# CONFIG_ARCH_U8500 is not set
# CONFIG_ARCH_VEXPRESS is not set
# CONFIG_ARCH_WM8750 is not set
# CONFIG_ARCH_WM8850 is not set
# CONFIG_ARCH_ZYNQ is not set

#
# Processor Type
#
CONFIG_CPU_V6=y
CONFIG_CPU_V6K=y
CONFIG_CPU_V7=y
CONFIG_CPU_32v6=y
CONFIG_CPU_32v6K=y
CONFIG_CPU_32v7=y
CONFIG_CPU_ABRT_EV6=y
CONFIG_CPU_ABRT_EV7=y
CONFIG_CPU_PABRT_V6=y
CONFIG_CPU_PABRT_V7=y
CONFIG_CPU_CACHE_V6=y
CONFIG_CPU_CACHE_V7=y
CONFIG_CPU_CACHE_VIPT=y
CONFIG_CPU_COPY_V6=y
CONFIG_CPU_TLB_V6=y
CONFIG_CPU_TLB_V7=y
CONFIG_CPU_HAS_ASID=y
CONFIG_CPU_CP15=y
CONFIG_CPU_CP15_MMU=y

#
# Processor Features
#
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARM_THUMB=y
CONFIG_ARM_THUMBEE=y
CONFIG_ARM_VIRT_EXT=y
CONFIG_SWP_EMULATE=y
# CONFIG_CPU_ICACHE_DISABLE is not set
# CONFIG_CPU_DCACHE_DISABLE is not set
# CONFIG_CPU_BPREDICT_DISABLE is not set
CONFIG_KUSER_HELPERS=y
CONFIG_DMA_CACHE_RWFO=y
CONFIG_OUTER_CACHE=y
CONFIG_OUTER_CACHE_SYNC=y
CONFIG_MIGHT_HAVE_CACHE_L2X0=y
CONFIG_CACHE_L2X0=y
CONFIG_PL310_ERRATA_588369=y
CONFIG_PL310_ERRATA_727915=y
# CONFIG_PL310_ERRATA_753970 is not set
# CONFIG_PL310_ERRATA_769419 is not set
CONFIG_ARM_L1_CACHE_SHIFT_6=y
CONFIG_ARM_L1_CACHE_SHIFT=6
CONFIG_ARM_DMA_MEM_BUFFERABLE=y
CONFIG_MULTI_IRQ_HANDLER=y
# CONFIG_ARM_ERRATA_326103 is not set
CONFIG_ARM_ERRATA_411920=y
# CONFIG_ARM_ERRATA_430973 is not set
# CONFIG_ARM_ERRATA_643719 is not set
CONFIG_ARM_ERRATA_720789=y
CONFIG_ARM_ERRATA_754322=y
# CONFIG_ARM_ERRATA_754327 is not set
# CONFIG_ARM_ERRATA_364296 is not set
# CONFIG_ARM_ERRATA_764369 is not set
CONFIG_ARM_ERRATA_775420=y
CONFIG_ARM_ERRATA_798181=y
# CONFIG_ARM_ERRATA_773022 is not set
CONFIG_TI_PRIV_EDMA=y

#
# Bus support
#
# CONFIG_PCI is not set
# CONFIG_PCI_SYSCALL is not set
# CONFIG_PCCARD is not set

#
# Kernel Features
#
CONFIG_HAVE_SMP=y
CONFIG_SMP=y
CONFIG_SMP_ON_UP=y
CONFIG_ARM_CPU_TOPOLOGY=y
# CONFIG_SCHED_MC is not set
# CONFIG_SCHED_SMT is not set
CONFIG_HAVE_ARM_SCU=y
CONFIG_HAVE_ARM_ARCH_TIMER=y
CONFIG_HAVE_ARM_TWD=y
# CONFIG_MCPM is not set
# CONFIG_BIG_LITTLE is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_NR_CPUS=2
CONFIG_HOTPLUG_CPU=y
# CONFIG_ARM_PSCI is not set
CONFIG_ARCH_NR_GPIO=512
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_HZ_FIXED=0
CONFIG_HZ_100=y
# CONFIG_HZ_200 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_500 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_AEABI=y
# CONFIG_OABI_COMPAT is not set
CONFIG_ARCH_HAS_HOLES_MEMORYMODEL=y
# CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
CONFIG_HAVE_ARCH_PFN_VALID=y
CONFIG_HIGHMEM=y
# CONFIG_HIGHPTE is not set
CONFIG_HW_PERF_EVENTS=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_AREAS=7
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FORCE_MAX_ZONEORDER=12
CONFIG_ALIGNMENT_TRAP=y
# CONFIG_UACCESS_WITH_MEMCPY is not set
# CONFIG_SECCOMP is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y

#
# Boot options
#
CONFIG_USE_OF=y
CONFIG_ATAGS=y
# CONFIG_DEPRECATED_PARAM_STRUCT is not set
CONFIG_ZBOOT_ROM_TEXT=0x0
CONFIG_ZBOOT_ROM_BSS=0x0
CONFIG_ARM_APPENDED_DTB=y
CONFIG_ARM_ATAG_DTB_COMPAT=y
CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER=y
# CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND is not set
CONFIG_CMDLINE="root=/dev/mmcblk0p2 rootwait console=ttyO2,115200"
CONFIG_CMDLINE_FROM_BOOTLOADER=y
# CONFIG_CMDLINE_EXTEND is not set
# CONFIG_CMDLINE_FORCE is not set
CONFIG_KEXEC=y
CONFIG_ATAGS_PROC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_AUTO_ZRELADDR=y

#
# CPU Power Management
#

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

#
# ARM CPU Idle Drivers
#
CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED=y

#
# Floating point emulation
#

#
# At least one emulation must be selected
#
CONFIG_VFP=y
CONFIG_VFPv3=y
CONFIG_NEON=y
# CONFIG_KERNEL_MODE_NEON is not set

#
# Userspace binary formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y

#
# Power management options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_APM_EMULATION is not set
CONFIG_PM_OPP=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_CPU_PM=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARM_CPU_SUSPEND=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_NET_IP_TUNNEL is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_UDP_TUNNEL is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_TABLES is not set
# CONFIG_NETFILTER_XTABLES is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_LOG_ARP is not set
# CONFIG_NF_LOG_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
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
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_TI_HECC is not set
# CONFIG_CAN_FLEXCAN is not set
# CONFIG_CAN_GRCAN is not set
# CONFIG_CAN_RCAR is not set
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
# CONFIG_CAN_CC770 is not set

#
# CAN SPI interfaces
#
# CONFIG_CAN_MCP251X is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_SOC_BUS=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
# CONFIG_BRCMSTB_GISB_ARB is not set
CONFIG_OMAP_OCP2SCP=y
CONFIG_OMAP_INTERCONNECT=y
# CONFIG_ARM_CCI is not set
# CONFIG_ARM_CCN is not set
# CONFIG_VEXPRESS_CONFIG is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AFS_PARTS is not set
CONFIG_MTD_OF_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
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
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_PHYSMAP_OF is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_OMAP2=y
# CONFIG_MTD_NAND_OMAP_BCH is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OMAP2=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_LPDDR2_NVM is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_DTC=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_MTD=y
CONFIG_OF_RESERVED_MEM=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MG_DISK is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_BMP085_SPI is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_SPI is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set

#
# Intel MIC Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NLMON is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_XGENE is not set
CONFIG_NET_VENDOR_ARC=y
# CONFIG_ARC_EMAC is not set
CONFIG_NET_CADENCE=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CIRRUS=y
# CONFIG_CS89x0 is not set
# CONFIG_DM9000 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_FARADAY=y
# CONFIG_FTMAC100 is not set
# CONFIG_FTGMAC100 is not set
CONFIG_NET_VENDOR_HISILICON=y
# CONFIG_HIX5HD2_GMAC is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
CONFIG_KS8851=y
CONFIG_KS8851_MLL=y
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_AX88796 is not set
# CONFIG_ETHOC is not set
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_SMC91X=y
# CONFIG_SMC911X is not set
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_DAVINCI_EMAC is not set
CONFIG_TI_DAVINCI_MDIO=y
CONFIG_TI_DAVINCI_CPDMA=y
CONFIG_TI_CPSW_PHY_SEL=y
CONFIG_TI_CPSW=y
# CONFIG_TI_CPTS is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
# CONFIG_AMD_XGBE_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BUS_MUX_GPIO is not set
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8187 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_ATH_CARDS is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_SDIO=m
# CONFIG_LIBERTAS_SPI is not set
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CU is not set
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
CONFIG_WL12XX=m
CONFIG_WL18XX=m
CONFIG_WLCORE=m
CONFIG_WLCORE_SPI=m
CONFIG_WLCORE_SDIO=m
CONFIG_WILINK_PLATFORM_DATA=y
# CONFIG_ZD1211RW is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_USB=m
# CONFIG_CW1200 is not set
# CONFIG_RSI_91X is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
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
# CONFIG_INPUT_EVBUG is not set

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
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
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
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP1106 is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_OF_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_TWL6040_VIBRA is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_SOC_BUTTON_ARRAY is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_SERIO_APBPS2 is not set
# CONFIG_GAMEPORT is not set

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
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_EM is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_EARLYCON_ARM_SEMIHOST is not set
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_SERIAL_OMAP=y
CONFIG_SERIAL_OMAP_CONSOLE=y
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_HVC_DCC is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_OMAP=y
CONFIG_HW_RANDOM_OMAP3_ROM=y
# CONFIG_R3964 is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_OMAP=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RK3X is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
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
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_FSL_SPI is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_OMAP24XX=y
# CONFIG_SPI_TI_QSPI is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

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
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_BCM281XX is not set
CONFIG_PINCTRL_SINGLE=y
# CONFIG_PINCTRL_PALMAS is not set
CONFIG_ARCH_HAVE_CUSTOM_GPIO_H=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EM is not set
# CONFIG_GPIO_ZEVIO is not set
CONFIG_GPIO_OMAP=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_SYSCON is not set
# CONFIG_GPIO_GRGPIO is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS65910 is not set
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set
# CONFIG_HDQ_MASTER_OMAP is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2406 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Texas Instruments thermal drivers
#
CONFIG_TI_SOC_THERMAL=y
CONFIG_OMAP4_THERMAL=y
CONFIG_OMAP5_THERMAL=y
CONFIG_DRA752_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_GPIO_WATCHDOG is not set
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
CONFIG_OMAP_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_AS3722 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_ASIC3 is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_EGPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_PM8921_CORE is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_POWER=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MENELAUS=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_T7L66XB is not set
# CONFIG_MFD_TC6387XB is not set
# CONFIG_MFD_TC6393XB is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_DA9211 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LTC3589 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PBIAS=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TI_ABB=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS65218=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_DM6446_CCDC is not set
# CONFIG_VIDEO_OMAP2_VOUT is not set
CONFIG_VIDEO_OMAP3=y
CONFIG_VIDEO_OMAP3_DEBUG=y
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_APTINA_PLL=y
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M032 is not set
CONFIG_VIDEO_MT9P031=y
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_SMIAPP is not set
# CONFIG_VIDEO_S5C73M3 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_AS3645A is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_UVESA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_DA8XX is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_OMAP2_VRFB=y
CONFIG_OMAP2_DSS_INIT=y
CONFIG_OMAP2_DSS=m
# CONFIG_OMAP2_DSS_DEBUG is not set
# CONFIG_OMAP2_DSS_DEBUGFS is not set
CONFIG_OMAP2_DSS_DPI=y
CONFIG_OMAP2_DSS_VENC=y
CONFIG_OMAP2_DSS_HDMI_COMMON=y
CONFIG_OMAP4_DSS_HDMI=y
# CONFIG_OMAP5_DSS_HDMI is not set
CONFIG_OMAP2_DSS_SDI=y
CONFIG_OMAP2_DSS_DSI=y
CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=0
CONFIG_OMAP2_DSS_SLEEP_AFTER_VENC_RESET=y
CONFIG_FB_OMAP2=m
CONFIG_FB_OMAP2_DEBUG_SUPPORT=y
CONFIG_FB_OMAP2_NUM_FBS=3

#
# OMAP Display Device Drivers (new device model)
#
CONFIG_DISPLAY_ENCODER_TFP410=m
CONFIG_DISPLAY_ENCODER_TPD12S015=m
CONFIG_DISPLAY_CONNECTOR_DVI=m
CONFIG_DISPLAY_CONNECTOR_HDMI=m
# CONFIG_DISPLAY_CONNECTOR_ANALOG_TV is not set
CONFIG_DISPLAY_PANEL_DPI=m
# CONFIG_DISPLAY_PANEL_DSI_CM is not set
# CONFIG_DISPLAY_PANEL_SONY_ACX565AKM is not set
# CONFIG_DISPLAY_PANEL_LGPHILIPS_LB035Q02 is not set
# CONFIG_DISPLAY_PANEL_SHARP_LS037V7DW01 is not set
# CONFIG_DISPLAY_PANEL_TPO_TD028TTEC1 is not set
# CONFIG_DISPLAY_PANEL_TPO_TD043MTEA1 is not set
# CONFIG_DISPLAY_PANEL_NEC_NL8048HL11 is not set
# CONFIG_FB_SSD1307 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_DMAENGINE_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# HD-Audio
#
CONFIG_SND_ARM=y
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_BCD2000 is not set
CONFIG_SND_SOC=m
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_EDMA_SOC is not set
# CONFIG_SND_DAVINCI_SOC_MCASP is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
CONFIG_SND_OMAP_SOC=m
CONFIG_SND_OMAP_SOC_DMIC=m
CONFIG_SND_OMAP_SOC_MCBSP=m
CONFIG_SND_OMAP_SOC_MCPDM=m
# CONFIG_SND_OMAP_SOC_N810 is not set
# CONFIG_SND_OMAP_SOC_RX51 is not set
# CONFIG_SND_OMAP_SOC_AM3517EVM is not set
CONFIG_SND_OMAP_SOC_OMAP_TWL4030=m
CONFIG_SND_OMAP_SOC_OMAP_ABE_TWL6040=m
# CONFIG_SND_OMAP_SOC_OMAP_HDMI is not set
CONFIG_SND_OMAP_SOC_OMAP3_PANDORA=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271 is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
CONFIG_SND_SOC_DMIC=m
# CONFIG_SND_SOC_HDMI_CODEC is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1792A is not set
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC3X is not set
CONFIG_SND_SOC_TWL4030=m
CONFIG_SND_SOC_TWL6040=m
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731 is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8804 is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_TPA6130A2 is not set
# CONFIG_SND_SIMPLE_CARD is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_GT683R is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_OTG_FSM is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=m

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_DWC3_HOST_USB3_LPM_ENABLE is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_ULPI is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_SS_LB=m
# CONFIG_USB_CONFIGFS is not set
CONFIG_USB_ZERO=m
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_OMAP=y
CONFIG_MMC_OMAP_HS=y
# CONFIG_MMC_DW is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_HYM8563 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL92330=y
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS65910 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set
# CONFIG_RTC_DRV_MCP795 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_OMAP=y
# CONFIG_RTC_DRV_SNVS is not set
# CONFIG_RTC_DRV_XGENE is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
CONFIG_TI_EDMA=y
CONFIG_DMA_OMAP=y
# CONFIG_TI_CPPI41 is not set
# CONFIG_FSL_EDMA is not set
# CONFIG_NBPFAXI_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set

#
# SOC (System On Chip) specific Drivers
#
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI570 is not set
# CONFIG_CLK_TWL6040 is not set
# CONFIG_COMMON_CLK_PALMAS is not set
# CONFIG_COMMON_CLK_QCOM is not set

#
# Hardware Spinlock drivers
#
# CONFIG_HWSPINLOCK_OMAP is not set

#
# Clock Source drivers
#
CONFIG_CLKSRC_OF=y
CONFIG_CLKSRC_MMIO=y
CONFIG_ARM_ARCH_TIMER=y
CONFIG_ARM_ARCH_TIMER_EVTSTREAM=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_CLKSRC_VERSATILE is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y
CONFIG_OMAP_IOMMU=y
# CONFIG_OMAP_IOMMU_DEBUG is not set

#
# Remoteproc drivers
#
# CONFIG_OMAP_REMOTEPROC is not set
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_PALMAS=y
# CONFIG_EXTCON_SM5502 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC=y
CONFIG_IRQ_CROSSBAR=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_OMAP_USB2=y
CONFIG_TI_PIPE3=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_ST_SPEAR1310_MIPHY is not set
# CONFIG_PHY_ST_SPEAR1340_MIPHY is not set
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

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
# CONFIG_DEBUG_LOCKDEP is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_ENABLE_DEFAULT_TRACERS is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_ARM_PTDUMP is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_ARM_UNWIND=y
CONFIG_DEBUG_USER=y
CONFIG_DEBUG_LL=y
# CONFIG_DEBUG_OMAP2UART1 is not set
# CONFIG_DEBUG_OMAP2UART2 is not set
# CONFIG_DEBUG_OMAP2UART3 is not set
CONFIG_DEBUG_OMAP3UART3=y
# CONFIG_DEBUG_OMAP4UART3 is not set
# CONFIG_DEBUG_OMAP3UART4 is not set
# CONFIG_DEBUG_OMAP4UART4 is not set
# CONFIG_DEBUG_TI81XXUART1 is not set
# CONFIG_DEBUG_TI81XXUART2 is not set
# CONFIG_DEBUG_TI81XXUART3 is not set
# CONFIG_DEBUG_AM33XXUART1 is not set
# CONFIG_DEBUG_ZOOM_UART is not set
# CONFIG_DEBUG_ICEDCC is not set
# CONFIG_DEBUG_SEMIHOSTING is not set
# CONFIG_DEBUG_LL_UART_8250 is not set
# CONFIG_DEBUG_LL_UART_PL01X is not set
CONFIG_DEBUG_OMAP2PLUS_UART=y
CONFIG_DEBUG_LL_INCLUDE="debug/omap2plus.S"
# CONFIG_DEBUG_UART_PL01X is not set
# CONFIG_DEBUG_UART_8250 is not set
CONFIG_UNCOMPRESS_INCLUDE="debug/uncompress.h"
CONFIG_EARLY_PRINTK=y
# CONFIG_ARM_KPROBES_TEST is not set
# CONFIG_PID_IN_CONTEXTIDR is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_ARM is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_ARM is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_OMAP_SHAM is not set
# CONFIG_CRYPTO_DEV_OMAP_AES is not set
# CONFIG_CRYPTO_DEV_OMAP_DES is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
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
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_GENERIC_ATOMIC64=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_LIBFDT=y
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
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_ARCH_HAS_SG_CHAIN=y
# CONFIG_VIRTUALIZATION is not set

--------------010408010607030402030802--
