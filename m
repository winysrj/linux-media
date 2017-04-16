Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33417 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756258AbdDPR7f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:59:35 -0400
Received: by mail-wm0-f45.google.com with SMTP id y18so5955090wmh.0
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:59:34 -0700 (PDT)
Subject: Re: em28xx i2c writing error
To: Anders Eriksson <aeriksson2@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <CAGncdOYtM3PkJWDcBdSdONY8VbP5gDccBO777=j+ARQFXQMJBw@mail.gmail.com>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <9d37686e-9095-2eaa-72f2-18295a28eb7d@googlemail.com>
Date: Sun, 16 Apr 2017 19:59:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAGncdOYtM3PkJWDcBdSdONY8VbP5gDccBO777=j+ARQFXQMJBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 15.04.2017 um 20:28 schrieb Anders Eriksson:
> Hi Mauro,
>
> I've two devices using this driver, and whenever I have them both in
> use I eventually (between 10K and 100K secs uptime) i2c write errors
> such as in the log below. If only have one of the devices in use, the
> machine is stable.
>
> The machine never recovers from the error.
>
> All help apreciated.
> -Anders
>
>
>
> [    0.000000] Booting Linux on physical CPU 0xf00
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 4.4.15-v7+ (dc4@dc4-XPS13-9333) (gcc
> version 4.9.3 (crosstool-NG crosstool-ng-1.22.0-88-g8460611) ) #897
> SMP Tue Jul 12 18:42:55 BST 2016
> [    0.000000] CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=10c5387d
> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
> instruction cache
> [    0.000000] Machine model: Raspberry Pi 2 Model B Rev 1.1
> [    0.000000] cma: Reserved 8 MiB at 0x3a800000
> [    0.000000] Memory policy: Data cache writealloc
> [    0.000000] On node 0 totalpages: 241664
> [    0.000000] free_area_init_node: node 0, pgdat 808c0e00,
> node_mem_map b9fa6000
> [    0.000000]   Normal zone: 2124 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 241664 pages, LIFO batch:31
> [    0.000000] [bcm2709_smp_init_cpus] enter (9520->f3003010)
> [    0.000000] [bcm2709_smp_init_cpus] ncores=4
> [    0.000000] PERCPU: Embedded 13 pages/cpu @b9f62000 s22592 r8192
> d22464 u53248
> [    0.000000] pcpu-alloc: s22592 r8192 d22464 u53248 alloc=13*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> Total pages: 239540
> [    0.000000] Kernel command line: dma.dmachans=0x7f35
> bcm2708_fb.fbwidth=656 bcm2708_fb.fbheight=416
> bcm2709.boardrev=0xa01041 bcm2709.serial=0x9aa48012
> smsc95xx.macaddr=B8:27:EB:A4:80:12 bcm2708_fb.fbswap=1
> bcm2709.uart_clock=48000000 bcm2709.disk_led_gpio=47
> bcm2709.disk_led_active_low=0 vc_mem.mem_base=0x3dc00000
> vc_mem.mem_size=0x3f000000  root=/dev/mmcblk0p4 smsc95xx.turbo_mode=N
> rootdelay=2 console=ttyAMA0,115200 console=tty0 kgdboc=ttyAMA0,115200
> init=/usr/lib/systemd/systemd ro
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Memory: 939080K/966656K available (6344K kernel code,
> 432K rwdata, 1712K rodata, 476K init, 764K bss, 19384K reserved, 8192K
> cma-reserved)
> [    0.000000] Virtual kernel memory layout:
>                    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>                    fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
>                    vmalloc : 0xbb800000 - 0xff800000   (1088 MB)
>                    lowmem  : 0x80000000 - 0xbb000000   ( 944 MB)
>                    modules : 0x7f000000 - 0x80000000   (  16 MB)
>                      .text : 0x80008000 - 0x807e6470   (8058 kB)
>                      .init : 0x807e7000 - 0x8085e000   ( 476 kB)
>                      .data : 0x8085e000 - 0x808ca108   ( 433 kB)
>                       .bss : 0x808cd000 - 0x8098c1ac   ( 765 kB)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  Build-time adjustment of leaf fanout to 32.
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] Architected cp15 timer(s) running at 19.20MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff
> max_cycles: 0x46d987e47, max_idle_ns: 440795202767 ns
> [    0.000011] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps
> every 4398046511078ns
> [    0.000032] Switching to timer-based delay loop, resolution 52ns
> [    0.000353] Console: colour dummy device 80x30
> [    0.001539] console [tty0] enabled
> [    0.001591] Calibrating delay loop (skipped), value calculated
> using timer frequency.. 38.40 BogoMIPS (lpj=192000)
> [    0.001667] pid_max: default: 32768 minimum: 301
> [    0.002077] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.002128] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.003338] Disabling cpuset control group subsystem
> [    0.003423] Initializing cgroup subsys io
> [    0.003483] Initializing cgroup subsys memory
> [    0.003563] Initializing cgroup subsys devices
> [    0.003615] Initializing cgroup subsys freezer
> [    0.003665] Initializing cgroup subsys net_cls
> [    0.003764] CPU: Testing write buffer coherency: ok
> [    0.003878] ftrace: allocating 21209 entries in 63 pages
> [    0.056189] CPU0: update cpu_capacity 1024
> [    0.056269] CPU0: thread -1, cpu 0, socket 15, mpidr 80000f00
> [    0.056306] [bcm2709_smp_prepare_cpus] enter
> [    0.056463] Setting up static identity map for 0x8240 - 0x8274
> [    0.058860] [bcm2709_boot_secondary] cpu:1 started (0) 18
> [    0.059298] [bcm2709_secondary_init] enter cpu:1
> [    0.059356] CPU1: update cpu_capacity 1024
> [    0.059364] CPU1: thread -1, cpu 1, socket 15, mpidr 80000f01
> [    0.059943] [bcm2709_boot_secondary] cpu:2 started (0) 17
> [    0.060295] [bcm2709_secondary_init] enter cpu:2
> [    0.060328] CPU2: update cpu_capacity 1024
> [    0.060335] CPU2: thread -1, cpu 2, socket 15, mpidr 80000f02
> [    0.060883] [bcm2709_boot_secondary] cpu:3 started (0) 18
> [    0.061137] [bcm2709_secondary_init] enter cpu:3
> [    0.061167] CPU3: update cpu_capacity 1024
> [    0.061174] CPU3: thread -1, cpu 3, socket 15, mpidr 80000f03
> [    0.061264] Brought up 4 CPUs
> [    0.061375] SMP: Total of 4 processors activated (153.60 BogoMIPS).
> [    0.061408] CPU: All CPU(s) started in HYP mode.
> [    0.061437] CPU: Virtualization extensions available.
> [    0.062364] devtmpfs: initialized
> [    0.075166] VFP support v0.3: implementor 41 architecture 2 part 30
> variant 7 rev 5
> [    0.075713] clocksource: jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 19112604462750000 ns
> [    0.076747] pinctrl core: initialized pinctrl subsystem
> [    0.077575] NET: Registered protocol family 16
> [    0.083361] DMA: preallocated 4096 KiB pool for atomic coherent allocations
> [    0.091589] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4
> watchpoint registers.
> [    0.091652] hw-breakpoint: maximum watchpoint size is 8 bytes.
> [    0.091884] Serial: AMBA PL011 UART driver
> [    0.092251] 3f201000.uart: ttyAMA0 at MMIO 0x3f201000 (irq = 87,
> base_baud = 0) is a PL011 rev2
> [    0.596795] console [ttyAMA0] enabled
> [    0.601103] bcm2835-mbox 3f00b880.mailbox: mailbox enabled
> [    0.680457] bcm2835-dma 3f007000.dma: DMA legacy API manager at
> f3007000, dmachans=0x1
> [    0.689191] SCSI subsystem initialized
> [    0.693202] usbcore: registered new interface driver usbfs
> [    0.698854] usbcore: registered new interface driver hub
> [    0.704340] usbcore: registered new device driver usb
> [    0.719519] raspberrypi-firmware soc:firmware: Attached to firmware
> from 2017-01-12 16:26
> [    0.755260] clocksource: Switched to clocksource arch_sys_counter
> [    0.814512] FS-Cache: Loaded
> [    0.817856] CacheFiles: Loaded
> [    0.837339] NET: Registered protocol family 2
> [    0.842977] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
> [    0.850256] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.856936] TCP: Hash tables configured (established 8192 bind 8192)
> [    0.863461] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.869491] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.876221] NET: Registered protocol family 1
> [    0.881082] RPC: Registered named UNIX socket transport module.
> [    0.887081] RPC: Registered udp transport module.
> [    0.891808] RPC: Registered tcp transport module.
> [    0.896553] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.904399] hw perfevents: enabled with armv7_cortex_a7 PMU driver,
> 5 counters available
> [    0.914282] futex hash table entries: 1024 (order: 4, 65536 bytes)
> [    0.936767] VFS: Disk quotas dquot_6.6.0
> [    0.941136] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.950937] FS-Cache: Netfs 'nfs' registered for caching
> [    0.957468] NFS: Registering the id_resolver key type
> [    0.962612] Key type id_resolver registered
> [    0.966852] Key type id_legacy registered
> [    0.974175] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 252)
> [    0.981862] io scheduler noop registered
> [    0.985854] io scheduler deadline registered
> [    0.990215] io scheduler cfq registered (default)
> [    0.997919] BCM2708FB: allocated DMA memory fac00000
> [    1.002951] BCM2708FB: allocated DMA channel 0 @ f3007000
> [    1.014322] Console: switching to colour frame buffer device 82x26
> [    1.026354] KGDB: Registered I/O driver kgdboc
> [    2.085077] bcm2835-rng 3f104000.rng: hwrng registered
> [    2.092059] vc-cma: Videocore CMA driver
> [    2.097678] vc-cma: vc_cma_base      = 0x00000000
> [    2.103982] vc-cma: vc_cma_size      = 0x00000000 (0 MiB)
> [    2.110935] vc-cma: vc_cma_initial   = 0x00000000 (0 MiB)
> [    2.118131] vc-mem: phys_addr:0x00000000 mem_base=0x3dc00000
> mem_size:0x3f000000(1008 MiB)
> [    2.149794] brd: module loaded
> [    2.165602] loop: module loaded
> [    2.171318] vchiq: vchiq_init_state: slot_zero = 0xbac80000, is_master = 0
> [    2.181484] Loading iSCSI transport class v2.0-870.
> [    2.188857] usbcore: registered new interface driver smsc95xx
> [    2.196211] dwc_otg: version 3.00a 10-AUG-2012 (platform bus)
> [    2.403829] Core Release: 2.80a
> [    2.408439] Setting default values for core params
> [    2.414730] Finished setting default values for core params
> [    2.622293] Using Buffer DMA mode
> [    2.627121] Periodic Transfer Interrupt Enhancement - disabled
> [    2.634508] Multiprocessor Interrupt Enhancement - disabled
> [    2.641647] OTG VER PARAM: 0, OTG VER FLAG: 0
> [    2.647556] Dedicated Tx FIFOs mode
> [    2.652968] WARN::dwc_otg_hcd_init:1047: FIQ DMA bounce buffers:
> virt = 0xbac14000 dma = 0xfac14000 len=9024
> [    2.666024] FIQ FSM acceleration enabled for :
>                Non-periodic Split Transactions
>                Periodic Split Transactions
>                High-Speed Isochronous Endpoints
>                Interrupt/Control Split Transaction hack enabled
> [    2.696383] dwc_otg: Microframe scheduler enabled
> [    2.696461] WARN::hcd_init_fiq:413: FIQ on core 1 at 0x80446aa0
> [    2.704033] WARN::hcd_init_fiq:414: FIQ ASM at 0x80446e10 length 36
> [    2.711908] WARN::hcd_init_fiq:439: MPHI regs_base at 0xbb87e000
> [    2.719547] dwc_otg 3f980000.usb: DWC OTG Controller
> [    2.726134] dwc_otg 3f980000.usb: new USB bus registered, assigned
> bus number 1
> [    2.735070] dwc_otg 3f980000.usb: irq 62, io mem 0x00000000
> [    2.742263] Init: Port Power? op_state=1
> [    2.747748] Init: Power Port (0)
> [    2.752758] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.761150] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.769959] usb usb1: Product: DWC OTG Controller
> [    2.776216] usb usb1: Manufacturer: Linux 4.4.15-v7+ dwc_otg_hcd
> [    2.783765] usb usb1: SerialNumber: 3f980000.usb
> [    2.790998] hub 1-0:1.0: USB hub found
> [    2.796308] hub 1-0:1.0: 1 port detected
> [    2.802468] dwc_otg: FIQ enabled
> [    2.802482] dwc_otg: NAK holdoff enabled
> [    2.802491] dwc_otg: FIQ split-transaction FSM enabled
> [    2.802532] Module dwc_common_port init
> [    2.802873] usbcore: registered new interface driver usb-storage
> [    2.810732] mousedev: PS/2 mouse device common for all mice
> [    2.818708] bcm2835-cpufreq: min=600000 max=900000
> [    2.825369] sdhci: Secure Digital Host Controller Interface driver
> [    2.833089] sdhci: Copyright(c) Pierre Ossman
> [    2.839361] sdhost: log_buf @ bac13000 (fac13000)
> [    2.925302] mmc0: sdhost-bcm2835 loaded - DMA enabled (>1)
> [    2.932626] sdhci-pltfm: SDHCI platform and OF driver helper
> [    2.940600] ledtrig-cpu: registered to indicate activity on CPUs
> [    2.948423] hidraw: raw HID events driver (C) Jiri Kosina
> [    2.955660] usbcore: registered new interface driver usbhid
> [    2.962790] usbhid: USB HID core driver
> [    2.968864] Initializing XFRM netlink socket
> [    2.974721] NET: Registered protocol family 17
> [    2.980874] Key type dns_resolver registered
> [    2.987212] Registering SWP/SWPB emulation handler
> [    2.992794] mmc0: host does not support reading read-only switch,
> assuming write-enable
> [    2.994903] mmc0: new high speed SDHC card at address 59b4
> [    2.995926] mmcblk0: mmc0:59b4 USD   7.51 GiB
> [    3.005312]  mmcblk0: p1 p2 p3 p4
> [    3.022795] Indeed it is in host mode hprt0 = 00021501
> [    3.030624] registered taskstats version 1
> [    3.036634] vc-sm: Videocore shared memory driver
> [    3.042917] [vc_sm_connected_init]: start
> [    3.049253] [vc_sm_connected_init]: end - returning 0
> [    3.056253] of_cfs_init
> [    3.060295] of_cfs_init: OK
> [    3.065562] Waiting 2 sec before mounting root device...
> [    3.205302] usb 1-1: new high-speed USB device number 2 using dwc_otg
> [    3.205480] Indeed it is in host mode hprt0 = 00001101
> [    3.405636] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
> [    3.413891] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    3.423553] hub 1-1:1.0: USB hub found
> [    3.428998] hub 1-1:1.0: 5 ports detected
> [    3.715296] usb 1-1.1: new high-speed USB device number 3 using dwc_otg
> [    3.835616] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
> [    3.844059] usb 1-1.1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    3.855838] smsc95xx v1.0.4
> [    3.919555] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at
> usb-3f980000.usb-1.1, smsc95xx USB 2.0 Ethernet, b8:27:eb:a4:80:12
> [    4.025295] usb 1-1.4: new high-speed USB device number 4 using dwc_otg
> [    4.145824] usb 1-1.4: New USB device found, idVendor=1a40, idProduct=0201
> [    4.154353] usb 1-1.4: New USB device strings: Mfr=0, Product=1,
> SerialNumber=0
> [    4.163343] usb 1-1.4: Product: USB 2.0 Hub [MTT]
> [    4.170629] hub 1-1.4:1.0: USB hub found
> [    4.176361] hub 1-1.4:1.0: 7 ports detected
> [    4.275296] usb 1-1.5: new high-speed USB device number 5 using dwc_otg
> [    4.395668] usb 1-1.5: New USB device found, idVendor=0409, idProduct=005a
> [    4.404290] usb 1-1.5: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    4.414246] hub 1-1.5:1.0: USB hub found
> [    4.420082] hub 1-1.5:1.0: 4 ports detected
> [    4.485310] usb 1-1.4.2: new high-speed USB device number 6 using dwc_otg
> [    4.606205] usb 1-1.4.2: New USB device found, idVendor=2013, idProduct=024f
> [    4.614941] usb 1-1.4.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    4.625773] usb 1-1.4.2: Product: PCTV 290e
> [    4.631628] usb 1-1.4.2: Manufacturer: PCTV Systems
> [    4.638193] usb 1-1.4.2: SerialNumber: 00000010VKB7
> [    4.725298] usb 1-1.5.1: new high-speed USB device number 7 using dwc_otg
> [    4.845620] usb 1-1.5.1: New USB device found, idVendor=0409, idProduct=005a
> [    4.854279] usb 1-1.5.1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    4.865669] hub 1-1.5.1:1.0: USB hub found
> [    4.871431] hub 1-1.5.1:1.0: 4 ports detected
> [    4.955295] usb 1-1.5.4: new high-speed USB device number 8 using dwc_otg
> [    5.075812] usb 1-1.5.4: New USB device found, idVendor=0409, idProduct=005a
> [    5.078766] EXT4-fs (mmcblk0p4): couldn't mount as ext3 due to
> feature incompatibilities
> [    5.079667] EXT4-fs (mmcblk0p4): couldn't mount as ext2 due to
> feature incompatibilities
> [    5.081778] EXT4-fs (mmcblk0p4): INFO: recovery required on
> readonly filesystem
> [    5.081785] EXT4-fs (mmcblk0p4): write access will be enabled during recovery
> [    5.125400] usb 1-1.5.4: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    5.137594] hub 1-1.5.4:1.0: USB hub found
> [    5.143642] hub 1-1.5.4:1.0: 4 ports detected
> [    5.195300] usb 1-1.5.1.1: new high-speed USB device number 9 using dwc_otg
> [    5.316192] usb 1-1.5.1.1: New USB device found, idVendor=2013,
> idProduct=025f
> [    5.325353] usb 1-1.5.1.1: New USB device strings: Mfr=3,
> Product=1, SerialNumber=2
> [    5.336653] usb 1-1.5.1.1: Product: PCTV 292e
> [    5.342858] usb 1-1.5.1.1: Manufacturer: PCTV
> [    5.349021] usb 1-1.5.1.1: SerialNumber: 0011412129
> [    5.435310] usb 1-1.5.4.1: new full-speed USB device number 10 using dwc_otg
> [    5.559146] usb 1-1.5.4.1: New USB device found, idVendor=0403,
> idProduct=6001
> [    5.568270] usb 1-1.5.4.1: New USB device strings: Mfr=1,
> Product=2, SerialNumber=3
> [    5.579479] usb 1-1.5.4.1: Product: Smartreader2 plus
> [    5.586329] usb 1-1.5.4.1: Manufacturer: Argolis BV
> [    5.592905] usb 1-1.5.4.1: SerialNumber:
> [    5.655311] usb 1-1.5.1.2: new full-speed USB device number 11 using dwc_otg
> [    5.794180] usb 1-1.5.1.2: New USB device found, idVendor=1781,
> idProduct=0c31
> [    5.803114] usb 1-1.5.1.2: New USB device strings: Mfr=1,
> Product=2, SerialNumber=3
> [    5.813891] usb 1-1.5.1.2: Product: TellStick Duo
> [    5.820202] usb 1-1.5.1.2: Manufacturer: Telldus
> [    5.826427] usb 1-1.5.1.2: SerialNumber: A703AJYN
> [    5.885317] usb 1-1.5.4.4: new high-speed USB device number 12 using dwc_otg
> [    6.006822] usb 1-1.5.4.4: New USB device found, idVendor=04e8,
> idProduct=61b5
> [    6.015768] usb 1-1.5.4.4: New USB device strings: Mfr=1,
> Product=2, SerialNumber=3
> [    6.026482] usb 1-1.5.4.4: Product: Samsung M3 Portable
> [    6.033310] usb 1-1.5.4.4: Manufacturer: Samsung M3 Portable
> [    6.040618] usb 1-1.5.4.4: SerialNumber: 0A247DF106000060
> [    6.050626] usb-storage 1-1.5.4.4:1.0: USB Mass Storage device detected
> [    6.059997] scsi host0: usb-storage 1-1.5.4.4:1.0
> [    6.105356] usb 1-1.5.1.3: new high-speed USB device number 13 using dwc_otg
> [    6.226204] usb 1-1.5.1.3: New USB device found, idVendor=152d,
> idProduct=2329
> [    6.235086] usb 1-1.5.1.3: New USB device strings: Mfr=1,
> Product=2, SerialNumber=5
> [    6.246040] usb 1-1.5.1.3: Product: USB to ATA/ATAPI bridge
> [    6.253314] usb 1-1.5.1.3: Manufacturer: JMicron
> [    6.259609] usb 1-1.5.1.3: SerialNumber: 66E49349
> [    6.267420] usb-storage 1-1.5.1.3:1.0: USB Mass Storage device detected
> [    6.276088] usb-storage 1-1.5.1.3:1.0: Quirks match for vid 152d
> pid 2329: 8020
> [    6.285175] scsi host1: usb-storage 1-1.5.1.3:1.0
> [    6.316102] EXT4-fs (mmcblk0p4): recovery complete
> [    6.372517] EXT4-fs (mmcblk0p4): mounted filesystem with ordered
> data mode. Opts: (null)
> [    6.384104] VFS: Mounted root (ext4 filesystem) readonly on device 179:4.
> [    6.393638] devtmpfs: mounted
> [    6.399172] Freeing unused kernel memory: 476K (807e7000 - 8085e000)
> [    6.798985] NET: Registered protocol family 10
> [    6.822700] random: systemd urandom read with 91 bits of entropy available
> [    6.857946] systemd[1]: systemd 228 running in system mode. (+PAM
> -AUDIT -SELINUX +IMA -APPARMOR +SMACK -SYSVINIT +UTMP -LIBCRYPTSETUP
> -GCRYPT +GNUTLS -ACL -XZ +LZ4 +SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
> [    6.882472] systemd[1]: Detected architecture arm.
> [    6.897293] systemd[1]: Set hostname to <rpi2.lan>.
> [    7.066503] scsi 0:0:0:0: Direct-Access     Samsung  M3 Portable
>   1404 PQ: 0 ANSI: 6
> [    7.078692] uart-pl011 3f201000.uart: no DMA platform data
> [    7.088016] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks:
> (2.00 TB/1.82 TiB)
> [    7.100832] sd 0:0:0:0: [sda] Write Protect is off
> [    7.107665] sd 0:0:0:0: [sda] Mode Sense: 33 00 00 08
> [    7.108963] sd 0:0:0:0: [sda] No Caching mode page found
> [    7.116231] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [    7.286626] scsi 1:0:0:0: Direct-Access     ST950032 5AS
>   0002 PQ: 0 ANSI: 2 CCS
> [    7.302447] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks:
> (500 GB/466 GiB)
> [    7.314646] sd 1:0:0:0: [sdb] Write Protect is off
> [    7.321376] sd 1:0:0:0: [sdb] Mode Sense: 28 00 00 00
> [    7.322104] sd 1:0:0:0: [sdb] No Caching mode page found
> [    7.329277] sd 1:0:0:0: [sdb] Assuming drive cache: write through
> [    7.377621]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> [    7.389588] sd 0:0:0:0: [sda] Attached SCSI disk
> [    7.948691] systemd[1]: rpc-svcgssd.service: Cannot add dependency
> job, ignoring: Unit rpc-svcgssd.service failed to load: No such file
> or directory.
> [    7.966054] systemd[1]: rpc-gssd.service: Cannot add dependency
> job, ignoring: Unit rpc-gssd.service failed to load: No such file or
> directory.
> [    7.982846] systemd[1]: gssproxy.service: Cannot add dependency
> job, ignoring: Unit gssproxy.service failed to load: No such file or
> directory.
> [    8.000199] systemd[1]: display-manager.service: Cannot add
> dependency job, ignoring: Unit display-manager.service failed to load:
> No such file or directory.
> [    8.042572] systemd[1]: Started Forward Password Requests to Wall
> Directory Watch.
> [    8.060866] systemd[1]: Created slice User and Session Slice.
> [    8.072099] systemd[1]: Listening on Network Service Netlink Socket.
> [    8.086111] systemd[1]: Created slice System Slice.
> [    8.096900] systemd[1]: Created slice system-getty.slice.
> [    8.108199] systemd[1]: Created slice system-systemd\x2dfsck.slice.
> [    8.119569] systemd[1]: Reached target Host and Network Name Lookups.
> [    8.131877] systemd[1]: Set up automount Arbitrary Executable File
> Formats File System Automount Point.
> [    8.148462] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
> [    8.160707] systemd[1]: Listening on Journal Socket.
> [    8.205800] systemd[1]: Mounting NFSD configuration filesystem...
> [    8.227594] systemd[1]: Mounting Temporary Directory...
> [    8.244348] systemd[1]: Mounting Debug File System...
> [    8.329141] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    8.336622] systemd[1]: Starting Apply Kernel Variables...
> [    8.355160] systemd[1]: Starting Create list of required static
> device nodes for the current kernel...
> [    8.374963] systemd[1]: Created slice system-serial\x2dgetty.slice.
> [    8.389358] systemd[1]: Set up automount var-tmp.automount.
> [    8.400550] systemd[1]: Listening on Journal Socket (/dev/log).
> [    8.416301] systemd[1]: Starting Journal Service...
> [    8.431330] systemd[1]: Mounting POSIX Message Queue File System...
> [    8.443806] systemd[1]: Listening on udev Kernel Socket.
> [    8.461486] systemd[1]: Set up automount var-lib-machines.automount.
> [    8.472921] systemd[1]: Reached target Remote File Systems.
> [    8.484929] systemd[1]: Set up automount var-lib-timeshift.automount.
> [    8.496667] systemd[1]: Listening on udev Control Socket.
> [    8.536219] systemd[1]: Starting File System Check on Root Device...
> [    8.552853] systemd[1]: Mounting Configuration File System...
> [    8.574947] systemd[1]: Set up automount var-lib-media.automount.
> [    8.586649] systemd[1]: Started Dispatch Password Requests to
> Console Directory Watch.
> [    8.601816] systemd[1]: Reached target Paths.
> [    8.613920] systemd[1]: Set up automount home.automount.
> [    8.649134] systemd[1]: Mounting RPC Pipe File System...
> [    8.667404] systemd[1]: var-cache.automount: Directory /var/cache
> to mount over is not empty, mounting anyway.
> [    8.682874] systemd[1]: Set up automount var-cache.automount.
> [    8.699554] systemd[1]: Starting Setup Virtual Console...
> [    8.712784] systemd[1]: Set up automount usr-src.automount.
> [    8.726611] systemd[1]: Created slice Virtual Machine and Container Slice.
> [    8.738565] systemd[1]: Reached target Slices.
> [    8.760905] systemd[1]: Mounted RPC Pipe File System.
> [    8.771255] systemd[1]: Mounted NFSD configuration filesystem.
> [    8.782621] systemd[1]: Mounted Debug File System.
> [    8.791943] systemd[1]: Mounted Configuration File System.
> [    8.802011] systemd[1]: Mounted POSIX Message Queue File System.
> [    8.812401] systemd[1]: Mounted Temporary Directory.
> [    8.822162] systemd[1]: Started Journal Service.
> [    9.263793]  sdb: sdb1
> [    9.271037] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    9.694113] EXT4-fs (mmcblk0p4): re-mounted. Opts: user_xattr
> [   10.166020] systemd-journald[140]: Received request to flush
> runtime journal from PID 1
> [   10.203916] systemd-journald[140]: File
> /var/log/journal/18e841ae3401834bac9a7b7f552c54e2/system.journal
> corrupted or uncleanly shut down, renaming and replacing.
> [   10.954714] random: nonblocking pool is initialized
> [   11.377094] bcm2835-wdt 3f100000.watchdog: Broadcom BCM2835 watchdog timer
> [   11.405582] gpiomem-bcm2835 3f200000.gpiomem: Initialised:
> Registers at 0x3f200000
> [   11.601586] media: Linux media interface: v0.10
> [   11.647655] usbcore: registered new interface driver usbserial
> [   11.662050] usbcore: registered new interface driver usbserial_generic
> [   11.662189] usbserial: USB Serial support registered for generic
> [   11.684888] Linux video capture interface: v2.00
> [   11.703982] usbcore: registered new interface driver ftdi_sio
> [   11.712179] usbserial: USB Serial support registered for FTDI USB
> Serial Device
> [   11.722709] ftdi_sio 1-1.5.4.1:1.0: FTDI USB Serial Device converter detected
> [   11.723148] usb 1-1.5.4.1: Detected FT232BM
> [   11.744651] usb 1-1.5.4.1: FTDI USB Serial Device converter now
> attached to ttyUSB0
> [   11.818055] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
> (2013:024f, interface 0, class 0)
> [   11.831398] em28xx: DVB interface 0 found: isoc
> [   11.848328] em28xx: chip ID is em28174
> [   11.883110] Adding 538620k swap on /dev/mmcblk0p2.  Priority:-1
> extents:1 across:538620k SSFS
> [   12.200358] em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x11372abd
> [   12.209152] em28174 #0: EEPROM info:
> [   12.214596] em28174 #0:      microcode start address = 0x0004, boot
> configuration = 0x01
> [   12.251740] em28174 #0:      No audio on board.
> [   12.257883] em28174 #0:      500mA max power
> [   12.257899] em28174 #0:      Table at offset 0x39, strings=0x1aa0,
> 0x14ba, 0x1ace
> [   12.259264] em28174 #0: Identified as PCTV nanoStick T2 290e (card=78)
> [   12.259277] em28174 #0: dvb set to isoc mode.
> [   12.259551] em28xx: New device PCTV PCTV 292e @ 480 Mbps
> (2013:025f, interface 0, class 0)
> [   12.259570] em28xx: DVB interface 0 found: isoc
> [   12.266130] em28xx: chip ID is em28178
> [   12.345535] EXT4-fs (mmcblk0p3): mounted filesystem with ordered
> data mode. Opts: user_xattr
> [   12.596838] EXT4-fs (sdb1): mounted filesystem with ordered data
> mode. Opts: (null)
> [   13.762980] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28)
> initialised: dm-devel@redhat.com
> [   14.274644] em28178 #1: EEPROM ID = 26 00 01 00, EEPROM hash = 0x1f10fa04
> [   14.282826] em28178 #1: EEPROM info:
> [   14.287783] em28178 #1:      microcode start address = 0x0004, boot
> configuration = 0x01
> [   14.306006] em28178 #1:      AC97 audio (5 sample rates)
> [   14.312539] em28178 #1:      500mA max power
> [   14.318047] em28178 #1:      Table at offset 0x27, strings=0x146a,
> 0x1888, 0x0a7e
> [   14.328176] em28178 #1: Identified as PCTV tripleStick (292e) (card=94)
> [   14.336473] em28178 #1: dvb set to isoc mode.
> [   14.342834] usbcore: registered new interface driver em28xx
> [   14.357340] em28174 #0: Binding DVB extension
> [   14.399266] tda18271 4-0060: creating new instance
> [   14.410570] TDA18271HD/C2 detected @ 4-0060
> [   14.756558] DVB: registering new adapter (em28174 #0)
> [   14.763268] usb 1-1.4.2: DVB: registering adapter 0 frontend 0
> (Sony CXD2820R)...
> [   14.776195] em28174 #0: DVB extension successfully initialized
> [   14.783876] em28178 #1: Binding DVB extension
> [   14.808283] i2c i2c-6: Added multiplexed i2c bus 7
> [   14.814868] si2168 6-0064: Silicon Labs Si2168 successfully attached
> [   14.837222] si2157 7-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   14.848606] DVB: registering new adapter (em28178 #1)
> [   14.855800] usb 1-1.5.1.1: DVB: registering adapter 1 frontend 0
> (Silicon Labs Si2168)...
> [   14.869703] em28178 #1: DVB extension successfully initialized
> [   14.877665] em28xx: Registered (Em28xx dvb Extension) extension
> [   14.906455] em28174 #0: Registering input extension
> [   14.945534] Registered IR keymap rc-pinnacle-pctv-hd
> [   14.953096] input: em28xx IR (em28174 #0) as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.4/1-1.4.2/rc/rc0/input0
> [   14.967517] rc0: em28xx IR (em28174 #0) as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.4/1-1.4.2/rc/rc0
> [   14.981732] em28174 #0: Input extension successfully initalized
> [   14.989777] em28178 #1: Registering input extension
> [   14.997418] Registered IR keymap rc-pinnacle-pctv-hd
> [   15.005221] input: em28xx IR (em28178 #1) as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1.1/rc/rc1/input1
> [   15.022477] rc1: em28xx IR (em28178 #1) as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1.1/rc/rc1
> [   15.038312] em28178 #1: Input extension successfully initalized
> [   15.038320] em28xx: Registered (Em28xx Input Extension) extension
> [   18.625037] EXT4-fs (dm-5): mounted filesystem with ordered data
> mode. Opts: (null)
> [   18.904147] EXT4-fs (dm-7): mounted filesystem with ordered data
> mode. Opts: (null)
> [   19.763065] EXT4-fs (dm-3): mounted filesystem with ordered data
> mode. Opts: (null)
> [   20.155434] EXT4-fs (dm-6): mounted filesystem with ordered data
> mode. Opts: (null)
> [   21.584845] bridge: automatic filtering via arp/ip/ip6tables has
> been deprecated. Update your scripts to load br_netfilter if you need
> this.
> [   21.655413] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
> [   21.669877] IPv6: ADDRCONF(NETDEV_UP): veth-osc: link is not ready
> [   21.684691] device veth-osc-br entered promiscuous mode
> [   21.696320] IPv6: ADDRCONF(NETDEV_UP): veth-tvh: link is not ready
> [   21.709793] device veth-tvh-br entered promiscuous mode
> [   21.723481] device eth0 entered promiscuous mode
> [   21.743625] br0: port 1(veth-osc-br) entered forwarding state
> [   21.751066] br0: port 1(veth-osc-br) entered forwarding state
> [   21.758830] IPv6: ADDRCONF(NETDEV_CHANGE): veth-osc: link becomes ready
> [   21.767316] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
> [   21.783393] br0: port 2(veth-tvh-br) entered forwarding state
> [   21.790818] br0: port 2(veth-tvh-br) entered forwarding state
> [   21.799774] IPv6: ADDRCONF(NETDEV_CHANGE): veth-tvh: link becomes ready
> [   21.870702] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup
> [   21.880090] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   23.020289] IPv6: ADDRCONF(NETDEV_UP): vb-openhab: link is not ready
> [   23.030581] device vb-openhab entered promiscuous mode
> [   23.402973] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   23.412488] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex,
> lpa 0xC5E1
> [   23.424304] br0: port 3(eth0) entered forwarding state
> [   23.431389] br0: port 3(eth0) entered forwarding state
> [   26.209158] EXT4-fs (dm-3): re-mounted. Opts: (null)
> [   29.226801] IPv6: ADDRCONF(NETDEV_CHANGE): vb-openhab: link becomes ready
> [   29.233971] br0: port 4(vb-openhab) entered forwarding state
> [   29.239905] br0: port 4(vb-openhab) entered forwarding state
> [   29.738038] EXT4-fs (dm-0): mounted filesystem with ordered data
> mode. Opts: (null)
> [   29.904337] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> recovery directory
> [   29.918177] NFSD: starting 90-second grace period (net 808b7000)
> [   30.001379] IPv6: ADDRCONF(NETDEV_UP): vb-revproxy: link is not ready
> [   30.010142] device vb-revproxy entered promiscuous mode
> [   30.015858] br0: port 5(vb-revproxy) entered forwarding state
> [   30.021887] br0: port 5(vb-revproxy) entered forwarding state
> [   30.225566] br0: port 5(vb-revproxy) entered disabled state
> [   31.579047] EXT4-fs (dm-4): mounted filesystem with writeback data
> mode. Opts: data=writeback
> [   31.773077] IPv6: ADDRCONF(NETDEV_UP): vb-work: link is not ready
> [   31.781629] device vb-work entered promiscuous mode
> [   32.839859] si2168 6-0064: found a 'Silicon Labs Si2168-B40'
> [   32.860644] si2168 6-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [   33.266380] si2168 6-0064: firmware version: 4.0.11
> [   33.279683] si2157 7-0060: found a 'Silicon Labs Si2157-A30'
> [   33.339553] si2157 7-0060: firmware version: 3.0.5
> [   33.347268] usb 1-1.5.1.1: DVB: adapter 1 frontend 0 frequency 0
> out of range (55000000..862000000)
> [   33.717806] tda18271: performing RF tracking filter calibration
> [   33.989991] EXT4-fs (dm-3): re-mounted. Opts: (null)
> [   35.714673] EXT4-fs (dm-3): re-mounted. Opts: (null)
> [   36.652848] tda18271: RF tracking filter calibration complete
> [   36.662836] usb 1-1.4.2: DVB: adapter 0 frontend 0 frequency 0 out
> of range (45000000..864000000)
> [   36.765318] br0: port 1(veth-osc-br) entered forwarding state
> [   36.805327] br0: port 2(veth-tvh-br) entered forwarding state
> [   38.445319] br0: port 3(eth0) entered forwarding state
> [   38.974621] IPv6: ADDRCONF(NETDEV_CHANGE): vb-revproxy: link becomes ready
> [   38.984401] br0: port 5(vb-revproxy) entered forwarding state
> [   39.003046] br0: port 5(vb-revproxy) entered forwarding state
> [   44.285322] br0: port 4(vb-openhab) entered forwarding state
> [   45.607032] IPv6: ADDRCONF(NETDEV_CHANGE): vb-work: link becomes ready
> [   45.616358] br0: port 6(vb-work) entered forwarding state
> [   45.634769] br0: port 6(vb-work) entered forwarding state
> [   54.045274] br0: port 5(vb-revproxy) entered forwarding state
> [   60.645283] br0: port 6(vb-work) entered forwarding state
Did you skip any lines here ? Any usb related messages ?

> [93038.637557] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93038.737581] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
-5 is -EIO, which means the errors occure at usb level (line 176 in
em28xx-core.c)
However, the actual error returned by usb_control_msg() might be
different, because it is passed through usb_translate_errors().

Hth,
Frank

> [93038.746399] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93039.247560] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93039.447579] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93039.647559] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93039.847564] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93040.047567] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93040.157570] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93040.165915] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93041.047583] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93041.167571] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93041.175973] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93042.047587] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93042.177582] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93042.185886] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93043.047590] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93043.187592] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93043.195868] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93044.047593] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93044.197589] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93044.205925] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93045.047597] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93045.207593] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93045.215996] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93046.117605] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93046.217617] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93046.226038] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93047.127686] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93048.127607] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93049.127649] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93050.127623] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93051.127653] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93052.127661] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93053.127629] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93054.127676] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93055.127642] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93055.567657] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93055.627642] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93055.635697] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93055.737670] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93055.745838] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93055.767696] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93055.937644] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93055.945765] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93056.357654] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93056.365873] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93056.557660] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93056.565881] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93056.767668] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93056.957643] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93056.965832] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93057.167651] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93057.175940] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93057.367717] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93057.376095] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93057.777671] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93057.877684] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93057.886233] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93057.987666] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93057.996402] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93058.187711] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93058.196628] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93058.787667] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93058.797684] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93058.806676] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93059.007688] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93059.016688] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93059.117682] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93059.126734] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93059.617670] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93059.626716] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93059.787721] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93059.827708] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93059.836680] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93060.027687] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93060.036769] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93060.437671] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93060.446730] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93060.637691] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93060.646762] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93060.787678] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93061.247687] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93061.256728] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93061.457707] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93061.466757] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93061.787676] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93062.067704] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93062.076679] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93062.277708] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93062.286757] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93062.787684] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93062.887741] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93062.896722] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93063.097697] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93063.106681] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93063.707702] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93063.716684] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93063.787713] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93063.917702] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93063.926670] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93064.527694] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93064.536728] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93064.727715] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93064.736761] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93064.787702] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93065.337687] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93065.346584] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93065.547711] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93065.556702] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93065.787716] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93066.157718] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93066.166619] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93066.367727] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93066.376707] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93066.787692] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93066.977718] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93066.986601] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93067.187761] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93067.196740] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93067.787706] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93067.797724] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93067.806628] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93068.007766] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93068.016675] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93068.617717] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93068.626697] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93068.787718] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93068.827782] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93068.836721] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93069.437700] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93069.437758] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93069.537875] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93069.547209] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93069.787818] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93070.137740] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93070.146672] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93070.337717] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93070.346726] i2c i2c-4: cxd2820r: i2c rd failed=-5 reg=10 len=1
> [93070.567756] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93070.576794] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93070.587886] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93070.767728] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93070.776740] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=00 len=1
> [93070.787804] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93070.967719] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93070.976604] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=00 len=1
> [93071.377727] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93071.386766] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93071.577712] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93071.586734] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=00 len=1
> [93071.797738] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
> [93071.977728] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93071.986610] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=00 len=1
> [93072.187722] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93072.196762] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=85 len=1
> [93072.387752] em28174 #0: writing to i2c device at 0xd8 failed (error=-5)
> [93072.396784] i2c i2c-4: cxd2820r: i2c wr failed=-5 reg=00 len=1
> [93072.807813] em28178 #1: writing to i2c device at 0xc8 failed (error=-5)
