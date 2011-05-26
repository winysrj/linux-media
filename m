Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60616 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab1EZIv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 04:51:58 -0400
Received: by wya21 with SMTP id 21so320392wya.19
        for <linux-media@vger.kernel.org>; Thu, 26 May 2011 01:51:57 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <BANLkTiksN_+12hdQFOQ9+bS5LBU+QSR4cA@mail.gmail.com>
Date: Thu, 26 May 2011 10:51:53 +0200
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz
Content-Transfer-Encoding: 8BIT
Message-Id: <07EF42D6-0587-4F35-8431-E03B9994F9B5@beagleboard.org>
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com> <F50AF7E4-DCBA-4FC9-971A-ADF01F342FEF@beagleboard.org> <BANLkTiksN_+12hdQFOQ9+bS5LBU+QSR4cA@mail.gmail.com>
To: Javier Martin <javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 26 mei 2011, om 09:24 heeft Javier Martin het volgende geschreven:

> Hi Koen,
> 
> On 25 May 2011 15:38, Koen Kooi <koen@beagleboard.org> wrote:
>> 
>> Op 25 mei 2011, om 13:16 heeft Javier Martin het volgende geschreven:
>> 
>>> It includes several fixes pointed out by Laurent Pinchart. However,
>>> the BUG which shows artifacts in the image (horizontal lines) still
>>> persists. It won't happen if 1v8 regulator is not disabled (i.e.
>>> comment line where it is disabled in function "mt9p031_power_off").
>>> I know there can be some other details to fix but I would like someone
>>> could help in the power management issue.
>> 
>> I tried this + your beagle patch on 2.6.39 and both ISP and sensor being builtin to the kernel, I get the following:
>> 
>> root@beagleboardxMC:~# media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1 ], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> Resetting all links to inactive
>> Setting up link 16:0 -> 5:0 [1]
>> Setting up link 5:1 -> 6:0 [1]
>> 
>> root@beagleboardxMC:~# media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3  ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>> Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
>> Format set: SGRBG12 320x240
>> Setting up format SGRBG12 320x240 on pad OMAP3 ISP CCDC/0
>> Format set: SGRBG12 320x240
>> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
>> Format set: SGRBG8 320x240
>> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
>> Format set: SGRBG8 320x240
>> 
>> oot@beagleboardxMC:~# yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F  `media-ctl -e "OMAP3 ISP CCDC output"`
>> Device /dev/video2 opened.
>> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
>> Video format set: SGRBG8 (47425247) 320x240 buffer size 76800
>> Video format: SGRBG8 (47425247) 320x240 buffer size 76800
>> 4 buffers requested.
>> length: 76800 offset: 0
>> Buffer 0 mapped at address 0x4030d000.
>> length: 76800 offset: 77824
>> Buffer 1 mapped at address 0x40330000.
>> length: 76800 offset: 155648
>> Buffer 2 mapped at address 0x4042d000.
>> length: 76800 offset: 233472
>> Buffer 3 mapped at address 0x40502000.
>> [ 4131.459930] omap3isp omap3isp: CCDC won't become idle!
> 
> Please, test it again using new RFC v3 I've just submitted.

Slightly better:

Video format: SGRBG8 (47425247) 320x240 buffer size 76800
4 buffers requested.
length: 76800 offset: 0
Buffer 0 mapped at address 0x401d1000.
length: 76800 offset: 77824
Buffer 1 mapped at address 0x40266000.
length: 76800 offset: 155648
Buffer 2 mapped at address 0x402c6000.
length: 76800 offset: 233472
Buffer 3 mapped at address 0x4036e000.
0 (0) [-] 4294967295 76800 bytes 110.899139 1306398890.364593 0.001 fps
1 (1) [-] 4294967295 76800 bytes 111.128997 1306398890.594421 4.351 fps
[  111.214019] omap3isp omap3isp: CCDC won't become idle!


> I have personally tested it against kernel 2.6.39 with the following
> .config file:

And with that config:

[    4.250244] VFS: Cannot open root device "mmcblk0p2" or unknown-block(179,2)
[    4.257720] Please append a correct "root=" boot option; here are the available partitions:
[    4.266540] b300         7977472 mmcblk0  driver: mmcblk
[    4.272125]   b301           72261 mmcblk0p1 00000000-0000-0000-0000-000000000mmcblk0p1
[    4.280578]   b302         7903980 mmcblk0p2 00000000-0000-0000-0000-000000000mmcblk0p2
[    4.289031] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(179,2)

Which is the good old kernel-mux-is-broken problem again, after turning off kernel-mux:

0 (0) [-] 4294967295 76800 bytes 29.186920 1306399517.283752 0.001 fps
1 (1) [-] 4294967295 76800 bytes 29.416778 1306399517.513580 4.351 fps
2 (2) [-] 4294967295 76800 bytes 29.528137 1306399517.624938 8.980 fps
[   29.616943] omap3isp omap3isp: CCDC won't become idle!

So that seems to be the same as with my config. How do I view the files yavta dumps?

All done on a xM revision C

regards,

Koen

> 
> #
> # Automatically generated make config: don't edit
> # Linux/arm 2.6.39-rc6 Kernel Configuration
> # Thu May  5 11:44:15 2011
> #
> CONFIG_ARM=y
> CONFIG_SYS_SUPPORTS_APM_EMULATION=y
> CONFIG_HAVE_SCHED_CLOCK=y
> CONFIG_GENERIC_GPIO=y
> # CONFIG_ARCH_USES_GETTIMEOFFSET is not set
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_HAVE_PROC_CPU=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_HARDIRQS_SW_RESEND=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_RWSEM_GENERIC_SPINLOCK=y
> CONFIG_ARCH_HAS_CPUFREQ=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_VECTORS_BASE=0xffff0000
> # CONFIG_ARM_PATCH_PHYS_VIRT is not set
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_HAVE_IRQ_WORK=y
> CONFIG_IRQ_WORK=y
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> # CONFIG_FHANDLE is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_HAVE_SPARSE_IRQ=y
> CONFIG_GENERIC_IRQ_SHOW=y
> # CONFIG_SPARSE_IRQ is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=32
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_RCU_FAST_NO_HZ is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=16
> # CONFIG_CGROUPS is not set
> # CONFIG_NAMESPACES is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_EXPERT=y
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_EXTRA_PASS=y
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_USE_VMALLOC=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_PERF_COUNTERS is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_COMPAT_BRK=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> CONFIG_OPROFILE=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_KPROBES=y
> CONFIG_KRETPROBES=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_CLK=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_FORCE_LOAD=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> CONFIG_INLINE_SPIN_UNLOCK=y
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> CONFIG_INLINE_READ_UNLOCK=y
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> CONFIG_INLINE_WRITE_UNLOCK=y
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> CONFIG_FREEZER=y
> 
> #
> # System Type
> #
> CONFIG_MMU=y
> # CONFIG_ARCH_INTEGRATOR is not set
> # CONFIG_ARCH_REALVIEW is not set
> # CONFIG_ARCH_VERSATILE is not set
> # CONFIG_ARCH_VEXPRESS is not set
> # CONFIG_ARCH_AT91 is not set
> # CONFIG_ARCH_BCMRING is not set
> # CONFIG_ARCH_CLPS711X is not set
> # CONFIG_ARCH_CNS3XXX is not set
> # CONFIG_ARCH_GEMINI is not set
> # CONFIG_ARCH_EBSA110 is not set
> # CONFIG_ARCH_EP93XX is not set
> # CONFIG_ARCH_FOOTBRIDGE is not set
> # CONFIG_ARCH_MXC is not set
> # CONFIG_ARCH_MXS is not set
> # CONFIG_ARCH_STMP3XXX is not set
> # CONFIG_ARCH_NETX is not set
> # CONFIG_ARCH_H720X is not set
> # CONFIG_ARCH_IOP13XX is not set
> # CONFIG_ARCH_IOP32X is not set
> # CONFIG_ARCH_IOP33X is not set
> # CONFIG_ARCH_IXP23XX is not set
> # CONFIG_ARCH_IXP2000 is not set
> # CONFIG_ARCH_IXP4XX is not set
> # CONFIG_ARCH_DOVE is not set
> # CONFIG_ARCH_KIRKWOOD is not set
> # CONFIG_ARCH_LOKI is not set
> # CONFIG_ARCH_LPC32XX is not set
> # CONFIG_ARCH_MV78XX0 is not set
> # CONFIG_ARCH_ORION5X is not set
> # CONFIG_ARCH_MMP is not set
> # CONFIG_ARCH_KS8695 is not set
> # CONFIG_ARCH_NS9XXX is not set
> # CONFIG_ARCH_W90X900 is not set
> # CONFIG_ARCH_NUC93X is not set
> # CONFIG_ARCH_TEGRA is not set
> # CONFIG_ARCH_PNX4008 is not set
> # CONFIG_ARCH_PXA is not set
> # CONFIG_ARCH_MSM is not set
> # CONFIG_ARCH_SHMOBILE is not set
> # CONFIG_ARCH_RPC is not set
> # CONFIG_ARCH_SA1100 is not set
> # CONFIG_ARCH_S3C2410 is not set
> # CONFIG_ARCH_S3C64XX is not set
> # CONFIG_ARCH_S5P64X0 is not set
> # CONFIG_ARCH_S5P6442 is not set
> # CONFIG_ARCH_S5PC100 is not set
> # CONFIG_ARCH_S5PV210 is not set
> # CONFIG_ARCH_EXYNOS4 is not set
> # CONFIG_ARCH_SHARK is not set
> # CONFIG_ARCH_TCC_926 is not set
> # CONFIG_ARCH_U300 is not set
> # CONFIG_ARCH_U8500 is not set
> # CONFIG_ARCH_NOMADIK is not set
> # CONFIG_ARCH_DAVINCI is not set
> CONFIG_ARCH_OMAP=y
> # CONFIG_PLAT_SPEAR is not set
> # CONFIG_ARCH_VT8500 is not set
> # CONFIG_GPIO_PCA953X is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> 
> #
> # TI OMAP Common Features
> #
> CONFIG_ARCH_OMAP_OTG=y
> # CONFIG_ARCH_OMAP1 is not set
> CONFIG_ARCH_OMAP2PLUS=y
> 
> #
> # OMAP Feature Selections
> #
> CONFIG_OMAP_DEBUG_DEVICES=y
> # CONFIG_OMAP_SMARTREFLEX is not set
> # CONFIG_OMAP_RESET_CLOCKS is not set
> CONFIG_OMAP_MUX=y
> CONFIG_OMAP_MUX_DEBUG=y
> CONFIG_OMAP_MUX_WARNINGS=y
> CONFIG_OMAP_MCBSP=y
> # CONFIG_OMAP_MBOX_FWK is not set
> CONFIG_OMAP_IOMMU=y
> # CONFIG_OMAP_IOMMU_DEBUG is not set
> CONFIG_OMAP_32K_TIMER=y
> # CONFIG_OMAP3_L2_AUX_SECURE_SAVE_RESTORE is not set
> CONFIG_OMAP_32K_TIMER_HZ=128
> CONFIG_OMAP_DM_TIMER=y
> # CONFIG_OMAP_PM_NONE is not set
> CONFIG_OMAP_PM_NOOP=y
> CONFIG_MACH_OMAP_GENERIC=y
> 
> #
> # TI OMAP2/3/4 Specific Features
> #
> CONFIG_ARCH_OMAP2PLUS_TYPICAL=y
> CONFIG_ARCH_OMAP2=y
> CONFIG_ARCH_OMAP3=y
> CONFIG_ARCH_OMAP4=y
> 
> #
> # OMAP Core Type
> #
> CONFIG_SOC_OMAP2420=y
> CONFIG_SOC_OMAP2430=y
> CONFIG_SOC_OMAP3430=y
> CONFIG_SOC_OMAPTI816X=y
> CONFIG_OMAP_PACKAGE_ZAF=y
> CONFIG_OMAP_PACKAGE_ZAC=y
> CONFIG_OMAP_PACKAGE_CBB=y
> CONFIG_OMAP_PACKAGE_CUS=y
> CONFIG_OMAP_PACKAGE_CBP=y
> CONFIG_OMAP_PACKAGE_CBL=y
> CONFIG_OMAP_PACKAGE_CBS=y
> 
> #
> # OMAP Board Type
> #
> CONFIG_MACH_OMAP2_TUSB6010=y
> CONFIG_MACH_OMAP_H4=y
> CONFIG_MACH_OMAP_APOLLON=y
> CONFIG_MACH_OMAP_2430SDP=y
> CONFIG_MACH_OMAP3_BEAGLE=y
> CONFIG_MACH_DEVKIT8000=y
> CONFIG_MACH_OMAP_LDP=y
> CONFIG_MACH_OMAP3530_LV_SOM=y
> CONFIG_MACH_OMAP3_TORPEDO=y
> CONFIG_MACH_OVERO=y
> CONFIG_MACH_OMAP3EVM=y
> CONFIG_MACH_OMAP3517EVM=y
> # CONFIG_MACH_CRANEBOARD is not set
> CONFIG_MACH_OMAP3_PANDORA=y
> CONFIG_MACH_OMAP3_TOUCHBOOK=y
> CONFIG_MACH_OMAP_3430SDP=y
> CONFIG_MACH_NOKIA_N800=y
> CONFIG_MACH_NOKIA_N810=y
> CONFIG_MACH_NOKIA_N810_WIMAX=y
> CONFIG_MACH_NOKIA_N8X0=y
> CONFIG_MACH_NOKIA_RM680=y
> CONFIG_MACH_NOKIA_RX51=y
> CONFIG_MACH_OMAP_ZOOM2=y
> CONFIG_MACH_OMAP_ZOOM3=y
> CONFIG_MACH_CM_T35=y
> CONFIG_MACH_CM_T3517=y
> CONFIG_MACH_IGEP0020=y
> CONFIG_MACH_IGEP0030=y
> CONFIG_MACH_SBC3530=y
> CONFIG_MACH_OMAP_3630SDP=y
> CONFIG_MACH_TI8168EVM=y
> CONFIG_MACH_OMAP_4430SDP=y
> CONFIG_MACH_OMAP4_PANDA=y
> # CONFIG_OMAP3_EMU is not set
> # CONFIG_OMAP3_SDRC_AC_TIMING is not set
> 
> #
> # System MMU
> #
> 
> #
> # Processor Type
> #
> CONFIG_CPU_V6=y
> CONFIG_CPU_V7=y
> CONFIG_CPU_32v6=y
> CONFIG_CPU_32v6K=y
> CONFIG_CPU_32v7=y
> CONFIG_CPU_ABRT_EV6=y
> CONFIG_CPU_ABRT_EV7=y
> CONFIG_CPU_PABRT_V6=y
> CONFIG_CPU_PABRT_V7=y
> CONFIG_CPU_CACHE_V6=y
> CONFIG_CPU_CACHE_V7=y
> CONFIG_CPU_CACHE_VIPT=y
> CONFIG_CPU_COPY_V6=y
> CONFIG_CPU_TLB_V6=y
> CONFIG_CPU_TLB_V7=y
> CONFIG_CPU_HAS_ASID=y
> CONFIG_CPU_CP15=y
> CONFIG_CPU_CP15_MMU=y
> CONFIG_CPU_USE_DOMAINS=y
> 
> #
> # Processor Features
> #
> CONFIG_ARM_THUMB=y
> CONFIG_ARM_THUMBEE=y
> # CONFIG_CPU_ICACHE_DISABLE is not set
> # CONFIG_CPU_DCACHE_DISABLE is not set
> # CONFIG_CPU_BPREDICT_DISABLE is not set
> CONFIG_OUTER_CACHE=y
> CONFIG_OUTER_CACHE_SYNC=y
> CONFIG_CACHE_L2X0=y
> CONFIG_ARM_L1_CACHE_SHIFT=5
> CONFIG_ARM_DMA_MEM_BUFFERABLE=y
> CONFIG_ARM_ERRATA_411920=y
> # CONFIG_ARM_ERRATA_430973 is not set
> # CONFIG_ARM_ERRATA_458693 is not set
> # CONFIG_ARM_ERRATA_460075 is not set
> # CONFIG_ARM_ERRATA_742230 is not set
> # CONFIG_ARM_ERRATA_742231 is not set
> CONFIG_PL310_ERRATA_588369=y
> CONFIG_ARM_ERRATA_720789=y
> CONFIG_PL310_ERRATA_727915=y
> # CONFIG_ARM_ERRATA_743622 is not set
> # CONFIG_ARM_ERRATA_751472 is not set
> # CONFIG_ARM_ERRATA_754322 is not set
> # CONFIG_ARM_ERRATA_754327 is not set
> CONFIG_ARM_GIC=y
> 
> #
> # Bus support
> #
> # CONFIG_PCI_SYSCALL is not set
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> # CONFIG_PCCARD is not set
> 
> #
> # Kernel Features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> CONFIG_SMP_ON_UP=y
> CONFIG_HAVE_ARM_SCU=y
> CONFIG_HAVE_ARM_TWD=y
> CONFIG_VMSPLIT_3G=y
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_NR_CPUS=2
> CONFIG_HOTPLUG_CPU=y
> CONFIG_LOCAL_TIMERS=y
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_HZ=128
> CONFIG_AEABI=y
> CONFIG_OABI_COMPAT=y
> CONFIG_ARCH_HAS_HOLES_MEMORYMODEL=y
> # CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
> # CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
> # CONFIG_HIGHMEM is not set
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_COMPACTION is not set
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_FORCE_MAX_ZONEORDER=11
> CONFIG_LEDS=y
> CONFIG_ALIGNMENT_TRAP=y
> # CONFIG_UACCESS_WITH_MEMCPY is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_DEPRECATED_PARAM_STRUCT is not set
> 
> #
> # Boot options
> #
> CONFIG_ZBOOT_ROM_TEXT=0x0
> CONFIG_ZBOOT_ROM_BSS=0x0
> CONFIG_CMDLINE="root=/dev/mmcblk0p2 rootwait console=ttyO2,115200"
> # CONFIG_CMDLINE_FORCE is not set
> # CONFIG_XIP_KERNEL is not set
> CONFIG_KEXEC=y
> CONFIG_ATAGS_PROC=y
> # CONFIG_CRASH_DUMP is not set
> # CONFIG_AUTO_ZRELADDR is not set
> 
> #
> # CPU Power Management
> #
> # CONFIG_CPU_FREQ is not set
> # CONFIG_CPU_IDLE is not set
> 
> #
> # Floating point emulation
> #
> 
> #
> # At least one emulation must be selected
> #
> CONFIG_FPE_NWFPE=y
> # CONFIG_FPE_NWFPE_XP is not set
> # CONFIG_FPE_FASTFPE is not set
> CONFIG_VFP=y
> CONFIG_VFPv3=y
> CONFIG_NEON=y
> 
> #
> # Userspace binary formats
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=y
> 
> #
> # Power management options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> # CONFIG_PM_VERBOSE is not set
> # CONFIG_PM_ADVANCED_DEBUG is not set
> # CONFIG_PM_TEST_SUSPEND is not set
> CONFIG_CAN_PM_TRACE=y
> # CONFIG_APM_EMULATION is not set
> CONFIG_ARCH_HAS_OPP=y
> CONFIG_PM_OPP=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=y
> # CONFIG_XFRM_SUB_POLICY is not set
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_NET_KEY=y
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_PNP=y
> CONFIG_IP_PNP_DHCP=y
> CONFIG_IP_PNP_BOOTP=y
> CONFIG_IP_PNP_RARP=y
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE_DEMUX is not set
> # CONFIG_IP_MROUTE is not set
> # CONFIG_ARPD is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> # CONFIG_INET_TUNNEL is not set
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> # CONFIG_IPV6 is not set
> # CONFIG_NETLABEL is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> 
> #
> # Core Netfilter Configuration
> #
> # CONFIG_NETFILTER_NETLINK_QUEUE is not set
> # CONFIG_NETFILTER_NETLINK_LOG is not set
> # CONFIG_NF_CONNTRACK is not set
> # CONFIG_NETFILTER_XTABLES is not set
> # CONFIG_IP_VS is not set
> 
> #
> # IP: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV4 is not set
> # CONFIG_IP_NF_QUEUE is not set
> # CONFIG_IP_NF_IPTABLES is not set
> # CONFIG_IP_NF_ARPTABLES is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_NET_TCPPROBE is not set
> # CONFIG_NET_DROP_MONITOR is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> CONFIG_BT=m
> # CONFIG_BT_L2CAP is not set
> # CONFIG_BT_SCO is not set
> 
> #
> # Bluetooth device drivers
> #
> # CONFIG_BT_HCIBTUSB is not set
> # CONFIG_BT_HCIBTSDIO is not set
> CONFIG_BT_HCIUART=m
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> # CONFIG_BT_HCIUART_ATH3K is not set
> CONFIG_BT_HCIUART_LL=y
> CONFIG_BT_HCIBCM203X=m
> CONFIG_BT_HCIBPA10X=m
> # CONFIG_BT_HCIBFUSB is not set
> # CONFIG_BT_HCIVHCI is not set
> # CONFIG_BT_MRVL is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_WEXT_SPY=y
> CONFIG_CFG80211=m
> # CONFIG_NL80211_TESTMODE is not set
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> # CONFIG_CFG80211_REG_DEBUG is not set
> CONFIG_CFG80211_DEFAULT_PS=y
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> CONFIG_CFG80211_WEXT=y
> CONFIG_WIRELESS_EXT_SYSFS=y
> CONFIG_LIB80211=m
> # CONFIG_LIB80211_DEBUG is not set
> CONFIG_MAC80211=m
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_PID=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> CONFIG_MAC80211_RC_DEFAULT_PID=y
> # CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
> CONFIG_MAC80211_RC_DEFAULT="pid"
> # CONFIG_MAC80211_MESH is not set
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> CONFIG_MTD=y
> # CONFIG_MTD_DEBUG is not set
> # CONFIG_MTD_TESTS is not set
> CONFIG_MTD_PARTITIONS=y
> # CONFIG_MTD_REDBOOT_PARTS is not set
> CONFIG_MTD_CMDLINE_PARTS=y
> # CONFIG_MTD_AFS_PARTS is not set
> # CONFIG_MTD_AR7_PARTS is not set
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_CHAR=y
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=y
> # CONFIG_FTL is not set
> # CONFIG_NFTL is not set
> # CONFIG_INFTL is not set
> # CONFIG_RFD_FTL is not set
> # CONFIG_SSFDC is not set
> # CONFIG_SM_FTL is not set
> CONFIG_MTD_OOPS=y
> # CONFIG_MTD_SWAP is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> # CONFIG_MTD_JEDECPROBE is not set
> CONFIG_MTD_GEN_PROBE=y
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=y
> # CONFIG_MTD_CFI_AMDSTD is not set
> # CONFIG_MTD_CFI_STAA is not set
> CONFIG_MTD_CFI_UTIL=y
> # CONFIG_MTD_RAM is not set
> # CONFIG_MTD_ROM is not set
> # CONFIG_MTD_ABSENT is not set
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> # CONFIG_MTD_PHYSMAP is not set
> # CONFIG_MTD_ARM_INTEGRATOR is not set
> # CONFIG_MTD_PLATRAM is not set
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_DATAFLASH is not set
> # CONFIG_MTD_M25P80 is not set
> # CONFIG_MTD_SST25L is not set
> # CONFIG_MTD_SLRAM is not set
> # CONFIG_MTD_PHRAM is not set
> # CONFIG_MTD_MTDRAM is not set
> # CONFIG_MTD_BLOCK2MTD is not set
> 
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOC2000 is not set
> # CONFIG_MTD_DOC2001 is not set
> # CONFIG_MTD_DOC2001PLUS is not set
> CONFIG_MTD_NAND_ECC=y
> # CONFIG_MTD_NAND_ECC_SMC is not set
> CONFIG_MTD_NAND=y
> # CONFIG_MTD_NAND_VERIFY_WRITE is not set
> # CONFIG_MTD_NAND_ECC_BCH is not set
> # CONFIG_MTD_SM_COMMON is not set
> # CONFIG_MTD_NAND_MUSEUM_IDS is not set
> # CONFIG_MTD_NAND_GPIO is not set
> CONFIG_MTD_NAND_OMAP2=y
> CONFIG_MTD_NAND_IDS=y
> # CONFIG_MTD_NAND_DISKONCHIP is not set
> # CONFIG_MTD_NAND_NANDSIM is not set
> # CONFIG_MTD_NAND_PLATFORM is not set
> # CONFIG_MTD_ALAUDA is not set
> CONFIG_MTD_ONENAND=y
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> # CONFIG_MTD_ONENAND_GENERIC is not set
> CONFIG_MTD_ONENAND_OMAP2=y
> # CONFIG_MTD_ONENAND_OTP is not set
> # CONFIG_MTD_ONENAND_2X_PROGRAM is not set
> # CONFIG_MTD_ONENAND_SIM is not set
> 
> #
> # LPDDR flash memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_RESERVE=1
> # CONFIG_MTD_UBI_GLUEBI is not set
> # CONFIG_MTD_UBI_DEBUG is not set
> # CONFIG_PARPORT is not set
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_DRBD is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=16384
> # CONFIG_BLK_DEV_XIP is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_MG_DISK is not set
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_MISC_DEVICES is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_MULTI_LUN=y
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> # CONFIG_ISCSI_TCP is not set
> # CONFIG_ISCSI_BOOT_SYSFS is not set
> # CONFIG_LIBFC is not set
> # CONFIG_LIBFCOE is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> # CONFIG_ATA is not set
> CONFIG_MD=y
> # CONFIG_BLK_DEV_MD is not set
> # CONFIG_BLK_DEV_DM is not set
> # CONFIG_TARGET_CORE is not set
> CONFIG_NETDEVICES=y
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
> CONFIG_MII=y
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> # CONFIG_LXT_PHY is not set
> # CONFIG_CICADA_PHY is not set
> # CONFIG_VITESSE_PHY is not set
> CONFIG_SMSC_PHY=y
> # CONFIG_BROADCOM_PHY is not set
> # CONFIG_BCM63XX_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> # CONFIG_NATIONAL_PHY is not set
> # CONFIG_STE10XP is not set
> # CONFIG_LSI_ET1011C_PHY is not set
> # CONFIG_MICREL_PHY is not set
> # CONFIG_FIXED_PHY is not set
> # CONFIG_MDIO_BITBANG is not set
> CONFIG_NET_ETHERNET=y
> # CONFIG_AX88796 is not set
> CONFIG_SMC91X=y
> # CONFIG_TI_DAVINCI_EMAC is not set
> # CONFIG_TI_DAVINCI_MDIO is not set
> # CONFIG_TI_DAVINCI_CPDMA is not set
> # CONFIG_DM9000 is not set
> # CONFIG_ENC28J60 is not set
> # CONFIG_ETHOC is not set
> # CONFIG_SMC911X is not set
> CONFIG_SMSC911X=y
> # CONFIG_SMSC911X_ARCH_HOOKS is not set
> # CONFIG_DNET is not set
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
> # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
> # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
> # CONFIG_B44 is not set
> CONFIG_KS8851=y
> CONFIG_KS8851_MLL=y
> # CONFIG_FTMAC100 is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_STMMAC_ETH is not set
> CONFIG_NETDEV_10000=y
> CONFIG_WLAN=y
> # CONFIG_LIBERTAS_THINFIRM is not set
> # CONFIG_AT76C50X_USB is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_MAC80211_HWSIM is not set
> # CONFIG_ATH_COMMON is not set
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_IWM is not set
> CONFIG_LIBERTAS=m
> CONFIG_LIBERTAS_USB=m
> CONFIG_LIBERTAS_SDIO=m
> # CONFIG_LIBERTAS_SPI is not set
> CONFIG_LIBERTAS_DEBUG=y
> # CONFIG_LIBERTAS_MESH is not set
> # CONFIG_P54_COMMON is not set
> # CONFIG_RT2X00 is not set
> # CONFIG_RTL8192CU is not set
> # CONFIG_WL1251 is not set
> # CONFIG_WL12XX_MENU is not set
> # CONFIG_ZD1211RW is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> CONFIG_USB_USBNET=y
> CONFIG_USB_NET_AX8817X=y
> CONFIG_USB_NET_CDCETHER=y
> # CONFIG_USB_NET_CDC_EEM is not set
> CONFIG_USB_NET_CDC_NCM=y
> # CONFIG_USB_NET_DM9601 is not set
> # CONFIG_USB_NET_SMSC75XX is not set
> CONFIG_USB_NET_SMSC95XX=y
> # CONFIG_USB_NET_GL620A is not set
> # CONFIG_USB_NET_NET1080 is not set
> # CONFIG_USB_NET_PLUSB is not set
> # CONFIG_USB_NET_MCS7830 is not set
> # CONFIG_USB_NET_RNDIS_HOST is not set
> # CONFIG_USB_NET_CDC_SUBSET is not set
> # CONFIG_USB_NET_ZAURUS is not set
> # CONFIG_USB_NET_CX82310_ETH is not set
> # CONFIG_USB_NET_INT51X1 is not set
> # CONFIG_USB_IPHETH is not set
> # CONFIG_USB_SIERRA_NET is not set
> # CONFIG_USB_VL600 is not set
> # CONFIG_WAN is not set
> 
> #
> # CAIF transport drivers
> #
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> CONFIG_KEYBOARD_GPIO=y
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_OMAP is not set
> # CONFIG_KEYBOARD_OMAP4 is not set
> CONFIG_KEYBOARD_TWL4030=y
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_GPIO is not set
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_ADS7846=y
> # CONFIG_TOUCHSCREEN_AD7877 is not set
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> # CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
> # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
> # CONFIG_TOUCHSCREEN_EETI is not set
> # CONFIG_TOUCHSCREEN_FUJITSU is not set
> # CONFIG_TOUCHSCREEN_GUNZE is not set
> # CONFIG_TOUCHSCREEN_ELO is not set
> # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> # CONFIG_TOUCHSCREEN_MTOUCH is not set
> # CONFIG_TOUCHSCREEN_INEXIO is not set
> # CONFIG_TOUCHSCREEN_MK712 is not set
> # CONFIG_TOUCHSCREEN_PENMOUNT is not set
> # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
> # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
> # CONFIG_TOUCHSCREEN_TSC2005 is not set
> # CONFIG_TOUCHSCREEN_TSC2007 is not set
> # CONFIG_TOUCHSCREEN_W90X900 is not set
> # CONFIG_TOUCHSCREEN_ST1232 is not set
> # CONFIG_TOUCHSCREEN_TPS6507X is not set
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_ATI_REMOTE is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_TWL4030_PWRBUTTON=y
> # CONFIG_INPUT_TWL4030_VIBRA is not set
> # CONFIG_INPUT_UINPUT is not set
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_N_GSM is not set
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> CONFIG_SERIAL_8250_RSA=y
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> # CONFIG_SERIAL_MAX3107 is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_OMAP=y
> CONFIG_SERIAL_OMAP_CONSOLE=y
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_IFX6X60 is not set
> # CONFIG_TTY_PRINTK is not set
> # CONFIG_HVC_DCC is not set
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_OMAP=y
> # CONFIG_R3964 is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_TCG_TPM is not set
> # CONFIG_RAMOOPS is not set
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE is not set
> # CONFIG_I2C_GPIO is not set
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_OMAP=y
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> # CONFIG_SPI_ALTERA is not set
> # CONFIG_SPI_BITBANG is not set
> # CONFIG_SPI_GPIO is not set
> # CONFIG_SPI_OC_TINY is not set
> CONFIG_SPI_OMAP24XX=y
> # CONFIG_SPI_PXA2XX_PCI is not set
> # CONFIG_SPI_XILINX is not set
> # CONFIG_SPI_DESIGNWARE is not set
> 
> #
> # SPI Protocol Masters
> #
> # CONFIG_SPI_SPIDEV is not set
> # CONFIG_SPI_TLE62X0 is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> CONFIG_ARCH_REQUIRE_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_SYSFS=y
> 
> #
> # Memory mapped GPIO expanders:
> #
> # CONFIG_GPIO_BASIC_MMIO is not set
> # CONFIG_GPIO_IT8761E is not set
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_MAX7300 is not set
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCF857X is not set
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_TWL4030=y
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> # CONFIG_GPIO_MCP23S08 is not set
> # CONFIG_GPIO_MC33880 is not set
> # CONFIG_GPIO_74X164 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_W1=y
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_DS2490 is not set
> # CONFIG_W1_MASTER_DS2482 is not set
> # CONFIG_W1_MASTER_DS1WM is not set
> # CONFIG_W1_MASTER_GPIO is not set
> # CONFIG_HDQ_MASTER_OMAP is not set
> 
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> # CONFIG_W1_SLAVE_SMEM is not set
> # CONFIG_W1_SLAVE_DS2423 is not set
> # CONFIG_W1_SLAVE_DS2431 is not set
> # CONFIG_W1_SLAVE_DS2433 is not set
> # CONFIG_W1_SLAVE_DS2760 is not set
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_BQ20Z75 is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_ISP1704 is not set
> # CONFIG_CHARGER_TWL4030 is not set
> # CONFIG_CHARGER_GPIO is not set
> CONFIG_HWMON=y
> # CONFIG_HWMON_VID is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADCXX is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7411 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS620 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_GPIO_FAN is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM70 is not set
> # CONFIG_SENSORS_LM73 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4151 is not set
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4261 is not set
> # CONFIG_SENSORS_LM95241 is not set
> # CONFIG_SENSORS_MAX1111 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> # CONFIG_SENSORS_SHT15 is not set
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_EMC1403 is not set
> # CONFIG_SENSORS_EMC2103 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_SCH5627 is not set
> # CONFIG_SENSORS_ADS1015 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_ADS7871 is not set
> # CONFIG_SENSORS_AMC6821 is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83795 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_THERMAL is not set
> CONFIG_WATCHDOG=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> # CONFIG_SOFT_WATCHDOG is not set
> # CONFIG_MPCORE_WATCHDOG is not set
> CONFIG_OMAP_WATCHDOG=y
> CONFIG_TWL4030_WATCHDOG=y
> # CONFIG_MAX63XX_WATCHDOG is not set
> 
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_MFD_SUPPORT=y
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_MFD_ASIC3 is not set
> # CONFIG_HTC_EGPIO is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> CONFIG_MENELAUS=y
> CONFIG_TWL4030_CORE=y
> # CONFIG_TWL4030_MADC is not set
> CONFIG_TWL4030_POWER=y
> # CONFIG_TWL4030_CODEC is not set
> # CONFIG_TWL6030_PWM is not set
> # CONFIG_MFD_STMPE is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_T7L66XB is not set
> # CONFIG_MFD_TC6387XB is not set
> # CONFIG_MFD_TC6393XB is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM831X_SPI is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_MC13XXX is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_EZX_PCAP is not set
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_OMAP_USB_HOST=y
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> # CONFIG_REGULATOR_DUMMY is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> # CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
> # CONFIG_REGULATOR_BQ24022 is not set
> # CONFIG_REGULATOR_MAX1586 is not set
> # CONFIG_REGULATOR_MAX8649 is not set
> # CONFIG_REGULATOR_MAX8660 is not set
> # CONFIG_REGULATOR_MAX8952 is not set
> CONFIG_REGULATOR_TWL4030=y
> # CONFIG_REGULATOR_LP3971 is not set
> # CONFIG_REGULATOR_LP3972 is not set
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> # CONFIG_REGULATOR_ISL6271A is not set
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_TPS6524X is not set
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> CONFIG_MEDIA_CONTROLLER=y
> CONFIG_VIDEO_DEV=y
> CONFIG_VIDEO_V4L2_COMMON=y
> CONFIG_VIDEO_V4L2_SUBDEV_API=y
> # CONFIG_DVB_CORE is not set
> CONFIG_VIDEO_MEDIA=y
> 
> #
> # Multimedia drivers
> #
> CONFIG_RC_CORE=y
> CONFIG_LIRC=y
> CONFIG_RC_MAP=y
> CONFIG_IR_NEC_DECODER=y
> CONFIG_IR_RC5_DECODER=y
> CONFIG_IR_RC6_DECODER=y
> CONFIG_IR_JVC_DECODER=y
> CONFIG_IR_SONY_DECODER=y
> CONFIG_IR_RC5_SZ_DECODER=y
> CONFIG_IR_LIRC_CODEC=y
> # CONFIG_IR_IMON is not set
> # CONFIG_IR_MCEUSB is not set
> # CONFIG_IR_STREAMZAP is not set
> # CONFIG_RC_LOOPBACK is not set
> # CONFIG_MEDIA_ATTACH is not set
> CONFIG_MEDIA_TUNER=y
> CONFIG_MEDIA_TUNER_CUSTOMISE=y
> 
> #
> # Customize TV tuners
> #
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_MT2060=m
> CONFIG_MEDIA_TUNER_MT2266=m
> CONFIG_MEDIA_TUNER_MT2131=m
> CONFIG_MEDIA_TUNER_QT1010=m
> CONFIG_MEDIA_TUNER_XC2028=m
> CONFIG_MEDIA_TUNER_XC5000=m
> CONFIG_MEDIA_TUNER_MXL5005S=m
> CONFIG_MEDIA_TUNER_MXL5007T=m
> CONFIG_MEDIA_TUNER_MC44S803=m
> CONFIG_MEDIA_TUNER_MAX2165=m
> CONFIG_MEDIA_TUNER_TDA18218=m
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEOBUF_GEN=y
> CONFIG_VIDEOBUF_DMA_CONTIG=y
> CONFIG_VIDEO_CAPTURE_DRIVERS=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> # CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
> # CONFIG_VIDEO_IR_I2C is not set
> 
> #
> # Encoders/decoders and other helper chips
> #
> 
> #
> # Audio decoders
> #
> # CONFIG_VIDEO_TVAUDIO is not set
> # CONFIG_VIDEO_TDA7432 is not set
> # CONFIG_VIDEO_TDA9840 is not set
> # CONFIG_VIDEO_TEA6415C is not set
> # CONFIG_VIDEO_TEA6420 is not set
> # CONFIG_VIDEO_MSP3400 is not set
> # CONFIG_VIDEO_CS5345 is not set
> # CONFIG_VIDEO_CS53L32A is not set
> # CONFIG_VIDEO_M52790 is not set
> # CONFIG_VIDEO_TLV320AIC23B is not set
> # CONFIG_VIDEO_WM8775 is not set
> # CONFIG_VIDEO_WM8739 is not set
> # CONFIG_VIDEO_VP27SMPX is not set
> 
> #
> # RDS decoders
> #
> # CONFIG_VIDEO_SAA6588 is not set
> 
> #
> # Video decoders
> #
> # CONFIG_VIDEO_ADV7180 is not set
> # CONFIG_VIDEO_BT819 is not set
> # CONFIG_VIDEO_BT856 is not set
> # CONFIG_VIDEO_BT866 is not set
> # CONFIG_VIDEO_KS0127 is not set
> # CONFIG_VIDEO_OV7670 is not set
> CONFIG_VIDEO_MT9P031=y
> # CONFIG_VIDEO_MT9V011 is not set
> # CONFIG_VIDEO_TCM825X is not set
> # CONFIG_VIDEO_SAA7110 is not set
> # CONFIG_VIDEO_SAA711X is not set
> # CONFIG_VIDEO_SAA717X is not set
> # CONFIG_VIDEO_SAA7191 is not set
> # CONFIG_VIDEO_TVP514X is not set
> # CONFIG_VIDEO_TVP5150 is not set
> # CONFIG_VIDEO_TVP7002 is not set
> # CONFIG_VIDEO_VPX3220 is not set
> 
> #
> # Video and audio decoders
> #
> # CONFIG_VIDEO_CX25840 is not set
> 
> #
> # MPEG video encoders
> #
> # CONFIG_VIDEO_CX2341X is not set
> 
> #
> # Video encoders
> #
> # CONFIG_VIDEO_SAA7127 is not set
> # CONFIG_VIDEO_SAA7185 is not set
> # CONFIG_VIDEO_ADV7170 is not set
> # CONFIG_VIDEO_ADV7175 is not set
> # CONFIG_VIDEO_THS7303 is not set
> # CONFIG_VIDEO_ADV7343 is not set
> # CONFIG_VIDEO_AK881X is not set
> 
> #
> # Video improvement chips
> #
> # CONFIG_VIDEO_UPD64031A is not set
> # CONFIG_VIDEO_UPD64083 is not set
> # CONFIG_VIDEO_VIVI is not set
> # CONFIG_VIDEO_VPFE_CAPTURE is not set
> CONFIG_VIDEO_OMAP2_VOUT=y
> # CONFIG_VIDEO_CPIA2 is not set
> # CONFIG_VIDEO_TIMBERDALE is not set
> # CONFIG_VIDEO_SR030PC30 is not set
> # CONFIG_VIDEO_NOON010PC30 is not set
> CONFIG_VIDEO_OMAP3=y
> CONFIG_VIDEO_OMAP3_DEBUG=y
> # CONFIG_SOC_CAMERA is not set
> # CONFIG_VIDEO_OMAP2 is not set
> # CONFIG_V4L_USB_DRIVERS is not set
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
> # CONFIG_RADIO_ADAPTERS is not set
> 
> #
> # Graphics support
> #
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> # CONFIG_FB_DDC is not set
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_FB_CFB_COPYAREA=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_WMT_GE_ROPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_UVESA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_FB_OMAP_LCD_VGA=y
> # CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
> CONFIG_OMAP2_VRAM=y
> CONFIG_OMAP2_VRFB=y
> CONFIG_OMAP2_DSS=y
> CONFIG_OMAP2_VRAM_SIZE=0
> CONFIG_OMAP2_DSS_DEBUG_SUPPORT=y
> # CONFIG_OMAP2_DSS_COLLECT_IRQ_STATS is not set
> CONFIG_OMAP2_DSS_DPI=y
> CONFIG_OMAP2_DSS_RFBI=y
> CONFIG_OMAP2_DSS_VENC=y
> CONFIG_OMAP4_DSS_HDMI=y
> CONFIG_OMAP2_DSS_SDI=y
> CONFIG_OMAP2_DSS_DSI=y
> # CONFIG_OMAP2_DSS_USE_DSI_PLL is not set
> # CONFIG_OMAP2_DSS_FAKE_VSYNC is not set
> CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=0
> CONFIG_FB_OMAP2=m
> CONFIG_FB_OMAP2_DEBUG_SUPPORT=y
> CONFIG_FB_OMAP2_NUM_FBS=3
> 
> #
> # OMAP2/3 Display Device Drivers
> #
> CONFIG_PANEL_GENERIC_DPI=m
> # CONFIG_PANEL_LGPHILIPS_LB035Q02 is not set
> CONFIG_PANEL_SHARP_LS037V7DW01=m
> CONFIG_PANEL_NEC_NL8048HL11_01B=m
> CONFIG_PANEL_TAAL=m
> CONFIG_PANEL_TPO_TD043MTEA1=m
> CONFIG_PANEL_ACX565AKM=m
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> # CONFIG_LCD_L4F00242T03 is not set
> # CONFIG_LCD_LMS283GF05 is not set
> # CONFIG_LCD_LTV350QV is not set
> # CONFIG_LCD_TDO24M is not set
> # CONFIG_LCD_VGG2432A4 is not set
> CONFIG_LCD_PLATFORM=y
> # CONFIG_LCD_S6E63M0 is not set
> # CONFIG_LCD_LD9040 is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> # CONFIG_BACKLIGHT_ADP8860 is not set
> 
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=y
> 
> #
> # Display hardware drivers
> #
> 
> #
> # Console display driver support
> #
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> CONFIG_FONTS=y
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_FONT_6x11 is not set
> # CONFIG_FONT_7x14 is not set
> # CONFIG_FONT_PEARL_8x8 is not set
> # CONFIG_FONT_ACORN_8x8 is not set
> # CONFIG_FONT_MINI_4x6 is not set
> # CONFIG_FONT_SUN8x16 is not set
> # CONFIG_FONT_SUN12x22 is not set
> # CONFIG_FONT_10x18 is not set
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> # CONFIG_SOUND is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HIDRAW is not set
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=y
> # CONFIG_HID_PID is not set
> # CONFIG_USB_HIDDEV is not set
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_3M_PCT is not set
> # CONFIG_HID_A4TECH is not set
> # CONFIG_HID_ACRUX is not set
> # CONFIG_HID_APPLE is not set
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CANDO is not set
> # CONFIG_HID_CHERRY is not set
> # CONFIG_HID_CHICONY is not set
> # CONFIG_HID_CYPRESS is not set
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_EZKEY is not set
> # CONFIG_HID_KEYTOUCH is not set
> # CONFIG_HID_KYE is not set
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_TWINHAN is not set
> # CONFIG_HID_KENSINGTON is not set
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LOGITECH is not set
> # CONFIG_HID_MICROSOFT is not set
> # CONFIG_HID_MOSART is not set
> # CONFIG_HID_MONTEREY is not set
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_QUANTA is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_ROCCAT_ARVO is not set
> # CONFIG_HID_ROCCAT_KONE is not set
> # CONFIG_HID_ROCCAT_KONEPLUS is not set
> # CONFIG_HID_ROCCAT_KOVAPLUS is not set
> # CONFIG_HID_ROCCAT_PYRA is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SONY is not set
> # CONFIG_HID_STANTUM is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> CONFIG_USB_DEBUG=y
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> CONFIG_USB_DEVICE_CLASS=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> CONFIG_USB_MON=y
> CONFIG_USB_WUSB=y
> # CONFIG_USB_WUSB_CBAF is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_HCD_OMAP=y
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_HWA_HCD is not set
> CONFIG_USB_MUSB_HDRC=y
> CONFIG_USB_MUSB_TUSB6010=y
> # CONFIG_USB_MUSB_OMAP2PLUS is not set
> # CONFIG_USB_MUSB_AM35X is not set
> CONFIG_USB_MUSB_HOST=y
> # CONFIG_USB_MUSB_PERIPHERAL is not set
> # CONFIG_USB_MUSB_OTG is not set
> CONFIG_USB_MUSB_HDRC_HCD=y
> CONFIG_MUSB_PIO_ONLY=y
> # CONFIG_USB_MUSB_DEBUG is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> # CONFIG_USB_PRINTER is not set
> CONFIG_USB_WDM=y
> # CONFIG_USB_TMC is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_REALTEK is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> # CONFIG_USB_UAS is not set
> CONFIG_USB_LIBUSUAL=y
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> CONFIG_USB_TEST=y
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_GADGET=y
> CONFIG_USB_GADGET_DEBUG_FILES=y
> CONFIG_USB_GADGET_DEBUG_FS=y
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_SELECTED=y
> CONFIG_USB_GADGET_FUSB300=y
> CONFIG_USB_FUSB300=y
> # CONFIG_USB_GADGET_OMAP is not set
> # CONFIG_USB_GADGET_R8A66597 is not set
> # CONFIG_USB_GADGET_PXA_U2O is not set
> # CONFIG_USB_GADGET_M66592 is not set
> # CONFIG_USB_GADGET_DUMMY_HCD is not set
> CONFIG_USB_GADGET_DUALSPEED=y
> CONFIG_USB_ZERO=m
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_G_NCM is not set
> # CONFIG_USB_GADGETFS is not set
> # CONFIG_USB_FUNCTIONFS is not set
> # CONFIG_USB_FILE_STORAGE is not set
> # CONFIG_USB_MASS_STORAGE is not set
> # CONFIG_USB_G_SERIAL is not set
> # CONFIG_USB_G_PRINTER is not set
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_MULTI is not set
> # CONFIG_USB_G_HID is not set
> # CONFIG_USB_G_DBGP is not set
> # CONFIG_USB_G_WEBCAM is not set
> 
> #
> # OTG and related infrastructure
> #
> CONFIG_USB_OTG_UTILS=y
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_ISP1301_OMAP is not set
> # CONFIG_USB_ULPI is not set
> CONFIG_TWL4030_USB=y
> CONFIG_TWL6030_USB=y
> CONFIG_NOP_USB_XCEIV=y
> CONFIG_UWB=y
> CONFIG_UWB_HWA=y
> # CONFIG_UWB_I1480U is not set
> CONFIG_MMC=y
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_UNSAFE_RESUME=y
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=y
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> CONFIG_SDIO_UART=y
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_SDHCI is not set
> CONFIG_MMC_OMAP=y
> CONFIG_MMC_OMAP_HS=y
> # CONFIG_MMC_SPI is not set
> # CONFIG_MMC_DW is not set
> # CONFIG_MMC_USHC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_NFC_DEVICES is not set
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> CONFIG_RTC_DRV_TWL92330=y
> CONFIG_RTC_DRV_TWL4030=y
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> 
> #
> # SPI RTC drivers
> #
> # CONFIG_RTC_DRV_M41T94 is not set
> # CONFIG_RTC_DRV_DS1305 is not set
> # CONFIG_RTC_DRV_DS1390 is not set
> # CONFIG_RTC_DRV_MAX6902 is not set
> # CONFIG_RTC_DRV_R9701 is not set
> # CONFIG_RTC_DRV_RS5C348 is not set
> # CONFIG_RTC_DRV_DS3234 is not set
> # CONFIG_RTC_DRV_PCF2123 is not set
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> # CONFIG_STAGING is not set
> CONFIG_CLKDEV_LOOKUP=y
> # CONFIG_HWSPINLOCK is not set
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> # CONFIG_EXT3_FS_XATTR is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> CONFIG_JFFS2_FS=y
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> # CONFIG_JFFS2_FS_WBUF_VERIFY is not set
> CONFIG_JFFS2_SUMMARY=y
> CONFIG_JFFS2_FS_XATTR=y
> CONFIG_JFFS2_FS_POSIX_ACL=y
> CONFIG_JFFS2_FS_SECURITY=y
> CONFIG_JFFS2_COMPRESSION_OPTIONS=y
> CONFIG_JFFS2_ZLIB=y
> CONFIG_JFFS2_LZO=y
> CONFIG_JFFS2_RTIME=y
> CONFIG_JFFS2_RUBIN=y
> # CONFIG_JFFS2_CMODE_NONE is not set
> CONFIG_JFFS2_CMODE_PRIORITY=y
> # CONFIG_JFFS2_CMODE_SIZE is not set
> # CONFIG_JFFS2_CMODE_FAVOURLZO is not set
> CONFIG_UBIFS_FS=y
> # CONFIG_UBIFS_FS_XATTR is not set
> # CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
> CONFIG_UBIFS_FS_LZO=y
> CONFIG_UBIFS_FS_ZLIB=y
> # CONFIG_UBIFS_FS_DEBUG is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=y
> # CONFIG_SQUASHFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=y
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> # CONFIG_NFS_V4_1 is not set
> CONFIG_ROOT_NFS=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> # CONFIG_NFS_USE_NEW_IDMAPPER is not set
> # CONFIG_NFSD is not set
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> CONFIG_SUNRPC_GSS=y
> # CONFIG_CEPH_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> # CONFIG_BSD_DISKLABEL is not set
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_UTF8 is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> # CONFIG_DEBUG_KERNEL is not set
> # CONFIG_HARDLOCKUP_DETECTOR is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_STACKTRACE=y
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_MEMORY_INIT is not set
> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> # CONFIG_LKDTM is not set
> # CONFIG_SYSCTL_SYSCALL_CHECK is not set
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_ENABLE_DEFAULT_TRACERS is not set
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_KPROBE_EVENT=y
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_ARM_UNWIND=y
> # CONFIG_DEBUG_USER is not set
> # CONFIG_OC_ETM is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> # CONFIG_SECURITYFS is not set
> # CONFIG_SECURITY_NETWORK is not set
> # CONFIG_SECURITY_PATH is not set
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> # CONFIG_IMA is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> # CONFIG_CRYPTO_CRYPTD is not set
> # CONFIG_CRYPTO_AUTHENC is not set
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=m
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_HMAC is not set
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_GHASH is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=m
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> # CONFIG_CRYPTO_ZLIB is not set
> CONFIG_CRYPTO_LZO=y
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_OMAP_SHAM is not set
> # CONFIG_CRYPTO_DEV_OMAP_AES is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_LAST_BIT=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CPU_RMAP=y
> CONFIG_NLATTR=y
> CONFIG_GENERIC_ATOMIC64=y
> CONFIG_AVERAGE=y
> 
> 
> 
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com

