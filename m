Return-path: <linux-media-owner@vger.kernel.org>
Received: from sonic306-50.consmr.mail.ir2.yahoo.com ([77.238.176.236]:43361
        "EHLO sonic306-50.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751377AbdJBTe2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Oct 2017 15:34:28 -0400
Reply-To: jerry.w@tesco.net
From: jerry wood <jerry.w@sky.com>
To: linux-media@vger.kernel.org
Subject: Raspberry PI 2 & Easy cap Dmseg log
Message-ID: <e97b1f29-2bb1-782f-35da-5034c4b3b729@sky.com>
Date: Mon, 2 Oct 2017 20:30:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi  I Have 2 of these easycap devices both product the same with VLC 
"traffic cone"

Hope the log is of help

Any ideas would be welcome


Jerry

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.9.41-v7+ (dc4@dc4-XPS13-9333) (gcc 
version 4.9.3 (crosstool-NG crosstool-ng-1.22.0-88-g8460611) ) #1023 SMP 
Tue Aug 8 16:00:15 BST 2017
[    0.000000] CPU: ARMv7 Processor [410fd034] revision 4 (ARMv7), 
cr=10c5383d
[    0.000000] CPU: div instructions available: patching division code
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing 
instruction cache
[    0.000000] OF: fdt:Machine model: Raspberry Pi 3 Model B Rev 1.2
[    0.000000] cma: Reserved 8 MiB at 0x37800000
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] On node 0 totalpages: 229376
[    0.000000] free_area_init_node: node 0, pgdat 80c6eec0, node_mem_map 
b7016000
[    0.000000]   Normal zone: 2016 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 229376 pages, LIFO batch:31
[    0.000000] percpu: Embedded 14 pages/cpu @b6fd0000 s25600 r8192 
d23552 u57344
[    0.000000] pcpu-alloc: s25600 r8192 d23552 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 227360
[    0.000000] Kernel command line: 8250.nr_uarts=0 
bcm2708_fb.fbwidth=1024 bcm2708_fb.fbheight=768 bcm2708_fb.fbswap=1 
vc_mem.mem_base=0x3ec00000 vc_mem.mem_size=0x40000000  
dwc_otg.lpm_enable=0 console=ttyS0,115200 console=tty1 
root=PARTUUID=e7e36f58-02 rootfstype=ext4 elevator=deadline 
fsck.repair=yes rootwait
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000000] Memory: 887576K/917504K available (7168K kernel code, 
484K rwdata, 2012K rodata, 1024K init, 778K bss, 21736K reserved, 8192K 
cma-reserved)
[    0.000000] Virtual kernel memory layout:
                    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
                    fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
                    vmalloc : 0xb8800000 - 0xff800000   (1136 MB)
                    lowmem  : 0x80000000 - 0xb8000000   ( 896 MB)
                    modules : 0x7f000000 - 0x80000000   (  16 MB)
                      .text : 0x80008000 - 0x80800000   (8160 kB)
                      .init : 0x80b00000 - 0x80c00000   (1024 kB)
                      .data : 0x80c00000 - 0x80c79094   ( 485 kB)
                       .bss : 0x80c7b000 - 0x80d3da64   ( 779 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]     Build-time adjustment of leaf fanout to 32.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] arm_arch_timer: Architected cp15 timer(s) running at 
19.20MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff 
max_cycles: 0x46d987e47, max_idle_ns: 440795202767 ns
[    0.000007] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps 
every 4398046511078ns
[    0.000023] Switching to timer-based delay loop, resolution 52ns
[    0.000299] Console: colour dummy device 80x30
[    0.001187] console [tty1] enabled
[    0.001231] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 38.40 BogoMIPS (lpj=192000)
[    0.001299] pid_max: default: 32768 minimum: 301
[    0.001633] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001675] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 
bytes)
[    0.002570] Disabling cpuset control group subsystem
[    0.002729] CPU: Testing write buffer coherency: ok
[    0.002791] ftrace: allocating 22396 entries in 66 pages
[    0.049272] CPU0: update cpu_capacity 1024
[    0.049324] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.049385] Setting up static identity map for 0x100000 - 0x100034
[    0.051250] CPU1: update cpu_capacity 1024
[    0.051257] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.051940] CPU2: update cpu_capacity 1024
[    0.051947] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.052614] CPU3: update cpu_capacity 1024
[    0.052620] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.052708] Brought up 4 CPUs
[    0.052881] SMP: Total of 4 processors activated (153.60 BogoMIPS).
[    0.052910] CPU: All CPU(s) started in HYP mode.
[    0.052936] CPU: Virtualization extensions available.
[    0.053753] devtmpfs: initialized
[    0.064819] VFP support v0.3: implementor 41 architecture 3 part 40 
variant 3 rev 4
[    0.065135] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.065197] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.065757] pinctrl core: initialized pinctrl subsystem
[    0.066673] NET: Registered protocol family 16
[    0.068947] DMA: preallocated 1024 KiB pool for atomic coherent 
allocations
[    0.077753] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 
watchpoint registers.
[    0.077801] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.077980] Serial: AMBA PL011 UART driver
[    0.079879] bcm2835-mbox 3f00b880.mailbox: mailbox enabled
[    0.080426] uart-pl011 3f201000.serial: could not find pctldev for 
node /soc/gpio@7e200000/uart0_pins, deferring probe
[    0.150098] bcm2835-dma 3f007000.dma: DMA legacy API manager at 
b880f000, dmachans=0x1
[    0.151955] SCSI subsystem initialized
[    0.152136] usbcore: registered new interface driver usbfs
[    0.152239] usbcore: registered new interface driver hub
[    0.152355] usbcore: registered new device driver usb
[    0.159075] raspberrypi-firmware soc:firmware: Attached to firmware 
from 2017-08-08 12:05
[    0.160493] clocksource: Switched to clocksource arch_sys_counter
[    0.207659] VFS: Disk quotas dquot_6.6.0
[    0.207770] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 
bytes)
[    0.207990] FS-Cache: Loaded
[    0.208259] CacheFiles: Loaded
[    0.220404] NET: Registered protocol family 2
[    0.221334] TCP established hash table entries: 8192 (order: 3, 32768 
bytes)
[    0.221471] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.221682] TCP: Hash tables configured (established 8192 bind 8192)
[    0.221795] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.221862] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.222095] NET: Registered protocol family 1
[    0.222528] RPC: Registered named UNIX socket transport module.
[    0.222560] RPC: Registered udp transport module.
[    0.222588] RPC: Registered tcp transport module.
[    0.222615] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.223566] hw perfevents: enabled with armv7_cortex_a7 PMU driver, 7 
counters available
[    0.225870] workingset: timestamp_bits=14 max_order=18 bucket_order=4
[    0.241921] FS-Cache: Netfs 'nfs' registered for caching
[    0.242916] NFS: Registering the id_resolver key type
[    0.242966] Key type id_resolver registered
[    0.242994] Key type id_legacy registered
[    0.245431] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 251)
[    0.245575] io scheduler noop registered
[    0.245606] io scheduler deadline registered (default)
[    0.245932] io scheduler cfq registered
[    0.251585] BCM2708FB: allocated DMA memory f7910000
[    0.251637] BCM2708FB: allocated DMA channel 0 @ b880f000
[    0.274143] Console: switching to colour frame buffer device 128x48
[    0.288460] bcm2835-rng 3f104000.rng: hwrng registered
[    0.288711] vc-cma: Videocore CMA driver
[    0.288826] vc-cma: vc_cma_base      = 0x00000000
[    0.288959] vc-cma: vc_cma_size      = 0x00000000 (0 MiB)
[    0.289109] vc-cma: vc_cma_initial   = 0x00000000 (0 MiB)
[    0.289454] vc-mem: phys_addr:0x00000000 mem_base=0x3ec00000 
mem_size:0x40000000(1024 MiB)
[    0.304860] brd: module loaded
[    0.313787] loop: module loaded
[    0.313910] Loading iSCSI transport class v2.0-870.
[    0.314573] usbcore: registered new interface driver smsc95xx
[    0.314747] dwc_otg: version 3.00a 10-AUG-2012 (platform bus)
[    0.542945] Core Release: 2.80a
[    0.543048] Setting default values for core params
[    0.547784] Finished setting default values for core params
[    0.752898] Using Buffer DMA mode
[    0.757516] Periodic Transfer Interrupt Enhancement - disabled
[    0.762272] Multiprocessor Interrupt Enhancement - disabled
[    0.767043] OTG VER PARAM: 0, OTG VER FLAG: 0
[    0.771780] Dedicated Tx FIFOs mode
[    0.776758] WARN::dwc_otg_hcd_init:1032: FIQ DMA bounce buffers: virt 
= 0xb7904000 dma = 0xf7904000 len=9024
[    0.781683] FIQ FSM acceleration enabled for :
                Non-periodic Split Transactions
                Periodic Split Transactions
                High-Speed Isochronous Endpoints
                Interrupt/Control Split Transaction hack enabled
[    0.805398] dwc_otg: Microframe scheduler enabled
[    0.805447] WARN::hcd_init_fiq:459: FIQ on core 1 at 0x8058f7fc
[    0.810330] WARN::hcd_init_fiq:460: FIQ ASM at 0x8058fb6c length 36
[    0.815200] WARN::hcd_init_fiq:486: MPHI regs_base at 0xb887a000
[    0.820047] dwc_otg 3f980000.usb: DWC OTG Controller
[    0.824825] dwc_otg 3f980000.usb: new USB bus registered, assigned 
bus number 1
[    0.829591] dwc_otg 3f980000.usb: irq 62, io mem 0x00000000
[    0.834321] Init: Port Power? op_state=1
[    0.838953] Init: Power Port (0)
[    0.843746] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.848520] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.853276] usb usb1: Product: DWC OTG Controller
[    0.857917] usb usb1: Manufacturer: Linux 4.9.41-v7+ dwc_otg_hcd
[    0.862620] usb usb1: SerialNumber: 3f980000.usb
[    0.868130] hub 1-0:1.0: USB hub found
[    0.872903] hub 1-0:1.0: 1 port detected
[    0.878227] dwc_otg: FIQ enabled
[    0.878231] dwc_otg: NAK holdoff enabled
[    0.878235] dwc_otg: FIQ split-transaction FSM enabled
[    0.878248] Module dwc_common_port init
[    0.878489] usbcore: registered new interface driver usb-storage
[    0.883493] mousedev: PS/2 mouse device common for all mice
[    0.889202] bcm2835-wdt 3f100000.watchdog: Broadcom BCM2835 watchdog 
timer
[    0.894262] bcm2835-cpufreq: min=600000 max=1200000
[    0.899394] sdhci: Secure Digital Host Controller Interface driver
[    0.904237] sdhci: Copyright(c) Pierre Ossman
[    0.909380] sdhost-bcm2835 3f202000.sdhost: could not get clk, 
deferring probe
[    0.916610] mmc-bcm2835 3f300000.mmc: could not get clk, deferring probe
[    0.921726] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.929301] ledtrig-cpu: registered to indicate activity on CPUs
[    0.934532] hidraw: raw HID events driver (C) Jiri Kosina
[    0.939773] usbcore: registered new interface driver usbhid
[    0.944824] usbhid: USB HID core driver
[    0.950634] vchiq: vchiq_init_state: slot_zero = 0xb7980000, 
is_master = 0
[    0.957438] Initializing XFRM netlink socket
[    0.962580] NET: Registered protocol family 17
[    0.967746] Key type dns_resolver registered
[    0.973149] Registering SWP/SWPB emulation handler
[    0.978850] registered taskstats version 1
[    0.984160] vc-sm: Videocore shared memory driver
[    0.989106] [vc_sm_connected_init]: start
[    0.994541] [vc_sm_connected_init]: end - returning 0
[    1.005254] 3f201000.serial: ttyAMA0 at MMIO 0x3f201000 (irq = 87, 
base_baud = 0) is a PL011 rev2
[    1.011752] sdhost: log_buf @ b7907000 (f7907000)
[    1.090516] mmc0: sdhost-bcm2835 loaded - DMA enabled (>1)
[    1.097683] mmc-bcm2835 3f300000.mmc: mmc_debug:0 mmc_debug2:0
[    1.102710] mmc-bcm2835 3f300000.mmc: DMA channel allocated
[    1.150674] Indeed it is in host mode hprt0 = 00021501
[    1.215799] of_cfs_init
[    1.220903] of_cfs_init: OK
[    1.226089] mmc0: host does not support reading read-only switch, 
assuming write-enable
[    1.226246] Waiting for root device PARTUUID=e7e36f58-02...
[    1.238136] mmc0: new high speed SDHC card at address 59b4
[    1.243264] random: fast init done
[    1.248570] mmcblk0: mmc0:59b4 NCard 29.5 GiB
[    1.255198]  mmcblk0: p1 p2
[    1.264211] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    1.270782] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    1.277219] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    1.284840] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    1.350525] usb 1-1: new high-speed USB device number 2 using dwc_otg
[    1.354761] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data 
mode. Opts: (null)
[    1.354808] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
[    1.355809] devtmpfs: mounted
[    1.370572] Indeed it is in host mode hprt0 = 00001101
[    1.372030] Freeing unused kernel memory: 1024K (80b00000 - 80c00000)
[    1.470663] mmc1: new high speed SDIO card at address 0001
[    1.610813] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
[    1.615872] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    1.621750] hub 1-1:1.0: USB hub found
[    1.626740] hub 1-1:1.0: 5 ports detected
[    1.917616] systemd[1]: System time before build time, advancing clock.
[    1.950536] usb 1-1.1: new high-speed USB device number 3 using dwc_otg
[    2.059004] NET: Registered protocol family 10
[    2.075056] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.080864] usb 1-1.1: New USB device found, idVendor=0424, 
idProduct=ec00
[    2.085824] usb 1-1.1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    2.093595] smsc95xx v1.0.5
[    2.120338] systemd[1]: systemd 232 running in system mode. (+PAM 
+AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP 
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    2.131752] systemd[1]: Detected architecture arm.
[    2.155565] systemd[1]: Set hostname to <raspberrypi>.
[    2.194624] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at 
usb-3f980000.usb-1.1, smsc95xx USB 2.0 Ethernet, b8:27:eb:bd:7c:1d
[    2.300535] usb 1-1.2: new low-speed USB device number 4 using dwc_otg
[    2.497313] usb 1-1.2: New USB device found, idVendor=04d9, 
idProduct=a01c
[    2.503012] usb 1-1.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    2.508629] usb 1-1.2: Product: Wireless USB Device
[    2.514215] usb 1-1.2: Manufacturer: HOLTEK
[    2.550732] input: HOLTEK Wireless USB Device as 
/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.0/0003:04D9:A01C.0001/input/input0
[    2.631308] hid-generic 0003:04D9:A01C.0001: input,hidraw0: USB HID 
v1.10 Keyboard [HOLTEK Wireless USB Device] on usb-3f980000.usb-1.2/input0
[    2.705210] input: HOLTEK Wireless USB Device as 
/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/1-1.2:1.1/0003:04D9:A01C.0002/input/input1
[    2.769548] systemd[1]: Listening on udev Kernel Socket.
[    2.781100] hid-generic 0003:04D9:A01C.0002: input,hidraw1: USB HID 
v1.10 Mouse [HOLTEK Wireless USB Device] on usb-3f980000.usb-1.2/input1
[    2.798319] systemd[1]: Listening on /dev/initctl Compatibility Named 
Pipe.
[    2.814089] systemd[1]: Created slice User and Session Slice.
[    2.829184] systemd[1]: Listening on udev Control Socket.
[    2.844270] systemd[1]: Started Forward Password Requests to Wall 
Directory Watch.
[    2.859519] systemd[1]: Listening on Journal Socket.
[    2.874721] systemd[1]: Listening on fsck to fsckd communication Socket.
[    2.880546] usb 1-1.3: new low-speed USB device number 5 using dwc_otg
[    2.995626] i2c /dev entries driver
[    3.024278] usb 1-1.3: New USB device found, idVendor=0603, 
idProduct=0002
[    3.024288] usb 1-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    3.024295] usb 1-1.3: Product: USB Composite Device
[    3.024302] usb 1-1.3: Manufacturer: SINO WEALTH
[    3.059510] input: SINO WEALTH USB Composite Device as 
/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.0/0003:0603:0002.0003/input/input2
[    3.121606] hid-generic 0003:0603:0002.0003: input,hidraw2: USB HID 
v1.10 Keyboard [SINO WEALTH USB Composite Device] on 
usb-3f980000.usb-1.3/input0
[    3.155349] input: SINO WEALTH USB Composite Device as 
/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.1/0003:0603:0002.0004/input/input3
[    3.221445] hid-generic 0003:0603:0002.0004: input,hiddev0,hidraw3: 
USB HID v1.10 Mouse [SINO WEALTH USB Composite Device] on 
usb-3f980000.usb-1.3/input1
[    3.320628] usb 1-1.4: new high-speed USB device number 6 using dwc_otg
[    3.462602] usb 1-1.4: New USB device found, idVendor=2109, 
idProduct=2812
[    3.462618] usb 1-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    3.462626] usb 1-1.4: Product: USB2.0 Hub
[    3.462633] usb 1-1.4: Manufacturer: VIA Labs, Inc.
[    3.463476] hub 1-1.4:1.0: USB hub found
[    3.463715] hub 1-1.4:1.0: 4 ports detected
[    3.621023] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[    3.737324] systemd-journald[140]: Received request to flush runtime 
journal from PID 1
[    3.810650] usb 1-1.4.1: new high-speed USB device number 7 using dwc_otg
[    3.950996] usb 1-1.4.1: New USB device found, idVendor=eb1a, 
idProduct=2861
[    3.951011] usb 1-1.4.1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    4.060610] usb 1-1.4.4: new high-speed USB device number 8 using dwc_otg
[    4.203112] usb 1-1.4.4: New USB device found, idVendor=2109, 
idProduct=2812
[    4.203128] usb 1-1.4.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    4.203136] usb 1-1.4.4: Product: USB2.0 Hub
[    4.203144] usb 1-1.4.4: Manufacturer: VIA Labs, Inc.
[    4.204140] hub 1-1.4.4:1.0: USB hub found
[    4.204400] hub 1-1.4.4:1.0: 4 ports detected
[    4.441420] media: Linux media interface: v0.10
[    4.466798] Linux video capture interface: v2.00
[    4.490243] em28xx: New device   @ 480 Mbps (eb1a:2861, interface 0, 
class 0)
[    4.490256] em28xx: Video interface 0 found: isoc
[    4.491824] em28xx: chip ID is em2860
[    4.652235] em2860 #0: board has no eeprom
[    4.800605] em2860 #0: No sensor detected
[    4.809326] em2860 #0: found i2c device @ 0x4a on bus 0 [saa7113h]
[    4.831386] em2860 #0: Your board has no unique USB ID.
[    4.831391] em2860 #0: A hint were successfully done, based on i2c 
devicelist hash.
[    4.831396] em2860 #0: This method is not 100% failproof.
[    4.831401] em2860 #0: If the board were missdetected, please email 
this log to:
[    4.831405] em2860 #0:     V4L Mailing List <linux-media@vger.kernel.org>
[    4.831410] em2860 #0: Board detected as EM2860/SAA711X Reference Design
[    4.970521] em2860 #0: Identified as EM2860/SAA711X Reference Design 
(card=19)
[    4.970528] em2860 #0: analog set to isoc mode.
[    4.971735] em28xx audio device (eb1a:2861): interface 1, class 1
[    4.971794] em28xx audio device (eb1a:2861): interface 2, class 1
[    4.972580] usbcore: registered new interface driver em28xx
[    5.011173] em2860 #0: Registering V4L2 extension
[    5.046197] usbcore: registered new interface driver snd-usb-audio
[    5.099404] gpiomem-bcm2835 3f200000.gpiomem: Initialised: Registers 
at 0x3f200000
[    5.271623] usbcore: registered new interface driver brcmfmac
[    5.434629] brcmfmac: Firmware version = wl0: Aug  7 2017 00:46:29 
version 7.45.41.46 (r666254 CY) FWID 01-f8a78378
[    5.991148] saa7115 3-0025: saa7113 found @ 0x4a (em2860 #0)
[    6.772817] uart-pl011 3f201000.serial: no DMA platform data
[    7.330208] Adding 102396k swap on /var/swap.  Priority:-1 extents:1 
across:102396k SSFS
[    7.330980] em2860 #0: Config register raw data: 0x10
[    7.390967] em2860 #0: AC97 vendor ID = 0x83847652
[    7.420723] em2860 #0: AC97 features = 0x6a90
[    7.420734] em2860 #0: Sigmatel audio processor detected (stac 9752)
[    7.443810] random: crng init done
[    7.851763] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    7.851791] brcmfmac: power management disabled
[    8.312706] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote 
wakeup
[    8.312934] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.845737] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   11.649103] Bluetooth: Core ver 2.22
[   11.649202] NET: Registered protocol family 31
[   11.649208] Bluetooth: HCI device and connection manager initialized
[   11.649228] Bluetooth: HCI socket layer initialized
[   11.649244] Bluetooth: L2CAP socket layer initialized
[   11.649276] Bluetooth: SCO socket layer initialized
[   11.661107] warning: process `colord-sane' used the deprecated sysctl 
system call with
[   11.661118] 8.
[   11.661124] 1.
[   11.661128] 2.

[   11.667133] Bluetooth: HCI UART driver ver 2.3
[   11.667146] Bluetooth: HCI UART protocol H4 registered
[   11.667151] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   11.667328] Bluetooth: HCI UART protocol Broadcom registered
[   11.821693] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   11.821703] Bluetooth: BNEP filters: protocol multicast
[   11.821717] Bluetooth: BNEP socket layer initialized
[   11.894161] Bluetooth: RFCOMM TTY layer initialized
[   11.894185] Bluetooth: RFCOMM socket layer initialized
[   11.894215] Bluetooth: RFCOMM ver 1.11
[   13.403020] em2860 #0: V4L2 video device registered as video0
[   13.403033] em2860 #0: V4L2 VBI device registered as vbi0
[   13.403047] em2860 #0: V4L2 extension successfully initialized
[   13.403057] em28xx: Registered (Em28xx v4l2 Extension) extension
[   13.454358] em2860 #0: Registering snapshot button...
[   13.454732] input: em28xx snapshot button as 
/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.4/1-1.4.1/input/input4
[   13.455073] em2860 #0: Remote control support is not available for 
this card.
[   13.455080] em28xx: Registered (Em28xx Input Extension) extension
[   15.363845] fuse init (API version 7.26)


.
