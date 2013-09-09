Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45020 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab3IINH7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 09:07:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VJ1C5-0001dw-QI
	for linux-media@vger.kernel.org; Mon, 09 Sep 2013 15:07:54 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 Sep 2013 15:07:53 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 Sep 2013 15:07:53 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: ov3640 sensor -> CCDC won't become idle!
Date: Mon, 9 Sep 2013 13:07:33 +0000 (UTC)
Message-ID: <loom.20130909T145536-271@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

as the subject says I got a problem with the ccdc.

My pipeline is: sensor -> ccdc -> memory

By doing some research I found a appropriate answer from Laurent:

"The OMAP3 ISP is quite picky about its input signals and doesn't gracefully 
handle missing or extra sync pulses for instance. A "CCDC won't become idle!" 
message usually indicates that the CCDC received a frame of unexpected size 
(this can happen if the sensor stops in the middle of a frame for instance), 
or that the driver had no time to process the end of frame interrupt before 
the next frame arrived (either because of an unsually long interrupt delay on 
the system, or because of too low vertical blanking)."

That sounds logical, but whatever I do nothing works for me. 

Can anyone who had that problem share what you did to solve that problem?
Or does anyone have a hint for me how to solve this?



root@overo2:~/media_test/bin# sudo ./media-ctl -v -r -l '"ov3640
3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC
output":0[1]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

root@overo2:~/media_test/bin# sudo ./media-ctl -v -V '"ov3640 3-003c":0 [Y8
2048x1536 (32,20)/2048x1536], "OMAP3 ISP CCDC":1 [Y8 2048x1536]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Setting up selection target 0 rectangle (32,20)/2048x1536 on pad ov3640 3-003c/0
Selection rectangle set: (32,20)/2040x1536
Setting up format Y8 2048x1536 on pad ov3640 3-003c/0
Format set: Y8 2040x1536
Setting up format Y8 2040x1536 on pad OMAP3 ISP CCDC/0
Format set: Y8 2040x1536
Setting up format Y8 2048x1536 on pad OMAP3 ISP CCDC/1
Format set: Y8 2032x1536

root@overo2:~/yavta-HEAD-d9b7cfc# sudo ./yavta -p -f Y8 -s 2032x1536 -n 4
--skip 3 --capture=13 --file=image  /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: Y8 (59455247) 2032x1536 (stride 2048) buffer size 3145728
Video format: Y8 (59455247) 2032x1536 (stride 2048) buffer size 3145728
4 buffers requested.
length: 3145728 offset: 0 timestamp type: unknown
Buffer 0 mapped at address 0xb6b36000.
length: 3145728 offset: 3145728 timestamp type: unknown
Buffer 1 mapped at address 0xb6836000.
length: 3145728 offset: 6291456 timestamp type: unknown
Buffer 2 mapped at address 0xb6536000.
length: 3145728 offset: 9437184 timestamp type: unknown
Buffer 3 mapped at address 0xb6236000.
Press enter to start capture


root@overo2:~/yavta-HEAD-d9b7cfc# dmesg
[    0.000000] Booting Linux on physical CPU 0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0 (linuxentwickler@linuxentwickler-OEM)
(gcc version 4.3.3 (GCC) ) #43 PREEMPT Mon Sep 9 11:53:31 CEST 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
instruction cache
[    0.000000] Machine: Gumstix Overo
[    0.000000] Reserving 12582912 bytes SDRAM for VRAM
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 53248
[    0.000000] free_area_init_node: node 0, pgdat c07159e4, node_mem_map
c07af000
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 52736 pages, LIFO batch:15
[    0.000000] OMAP3630 ES1.2 (l2cache iva sgx neon isp 192mhz_clk )
[    0.000000] Clocking rate (Crystal/Core/MPU): 26.0/332/600 MHz
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 52736
[    0.000000] Kernel command line: mem=93M@0x80000000 mem=128M@0x88000000
console=ttyO2,115200n8 vram=12M omapfb.mode=dvi:1024x768MR-16@60
omapfb.debug=y omapdss.def_disp=dvi root=/dev/mmcblk0p2 rw rootfstype=ext3
rootwait
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] allocated 524288 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want
memory cgroups
[    0.000000] Memory: 93MB 115MB = 208MB total
[    0.000000] Memory: 202572k/202572k available, 23732k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc067fff0   (6624 kB)
[    0.000000]       .init : 0xc0680000 - 0xc06bbdc0   ( 240 kB)
[    0.000000]       .data : 0xc06bc000 - 0xc0723a68   ( 415 kB)
[    0.000000]        .bss : 0xc0723a8c - 0xc07ae6ec   ( 556 kB)
[    0.000000] NR_IRQS:474
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 4.0) with 96
interrupts
[    0.000000] Total of 96 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps
every 131071999ms
[    0.000000] OMAP clocksource: 32k_counter at 32768 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.000244] Calibrating delay loop... 597.64 BogoMIPS (lpj=2334720)
[    0.039123] pid_max: default: 32768 minimum: 301
[    0.039306] Security Framework initialized
[    0.039428] Mount-cache hash table entries: 512
[    0.040222] Initializing cgroup subsys debug
[    0.040252] Initializing cgroup subsys cpuacct
[    0.040252] Initializing cgroup subsys memory
[    0.040313] Initializing cgroup subsys devices
[    0.040344] Initializing cgroup subsys freezer
[    0.040344] Initializing cgroup subsys perf_event
[    0.040466] CPU: Testing write buffer coherency: ok
[    0.040771] Setting up static identity map for 0x80490d60 - 0x80490db8
[    0.045043] devtmpfs: initialized
[    0.049926] dummy: 
[    0.050323] NET: Registered protocol family 16
[    0.050750] GPMC revision 5.0
[    0.050781] gpmc: irq-20 could not claim: err -22
[    0.052398] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
[    0.052490] OMAP GPIO hardware version 2.5
[    0.052703] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
[    0.052978] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
[    0.053253] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
[    0.053527] gpiochip_add: registered GPIOs 128 to 159 on device: gpio
[    0.053802] gpiochip_add: registered GPIOs 160 to 191 on device: gpio
[    0.054626] TOM OVERO INIT ##########
[    0.054870] omap_mux_init: Add partition: #1: core, flags: 0
[    0.059844] _omap_mux_get_by_name: Could not find signal uart4_rx.uart4_rx
[    0.065643] Reprogramming SDRC clock to 332000000 Hz
[    0.065673] dpll3_m2_clk rate change failed: -22
[    0.065673] Found NAND on CS0
[    0.065673] Registering NAND on CS0
[    0.066925]  usbhs_omap: alias fck already exists
[    0.067626] TOM OVERO CAMERA INIT ##########
[    0.067779] TOM OVERO CAMERA INIT DONE ##########
[    0.074462] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.077362]  omap-mcbsp.2: alias fck already exists
[    0.077545]  omap-mcbsp.3: alias fck already exists
[    0.078491] OMAP DMA hardware revision 5.0
[    0.086578] bio: create slab <bio-0> at 0
[    0.087341] fixed-dummy: 
[    0.087432] reg-fixed-voltage reg-fixed-voltage.0: fixed-dummy supplying 0uV
[    0.087615] vads7846: override min_uV, 1 -> 3300000
[    0.087646] vads7846: override max_uV, 2147483647 -> 3300000
[    0.087677] vads7846: 3300 mV 
[    0.087738] reg-fixed-voltage reg-fixed-voltage.1: vads7846 supplying
3300000uV
[    0.088470] SCSI subsystem initialized
[    0.088775] usbcore: registered new interface driver usbfs
[    0.088897] usbcore: registered new interface driver hub
[    0.089141] usbcore: registered new device driver usb
[    0.089599] omap_i2c omap_i2c.1: bus 1 rev1.4.0 at 2600 kHz
[    0.092346] twl 1-0048: PIH (irq 7) chaining IRQs 320..328
[    0.092468] twl 1-0048: power (irq 325) chaining IRQs 328..335
[    0.093109] twl4030_gpio twl4030_gpio: gpio (irq 320) chaining IRQs 336..353
[    0.093444] gpiochip_add: registered GPIOs 192 to 211 on device: twl4030
[    0.094299] VUSB1V5: override min_uV, 1 -> 1500000
[    0.094329] VUSB1V5: override max_uV, 2147483647 -> 1500000
[    0.094329] VUSB1V5: 1500 mV normal standby
[    0.094818] VUSB1V8: override min_uV, 1 -> 1800000
[    0.094848] VUSB1V8: override max_uV, 2147483647 -> 1800000
[    0.094879] VUSB1V8: 1800 mV normal standby
[    0.095306] VUSB3V1: override min_uV, 1 -> 3100000
[    0.095306] VUSB3V1: override max_uV, 2147483647 -> 3100000
[    0.095336] VUSB3V1: 3100 mV normal standby
[    0.096893] twl4030_usb twl4030_usb: HW_CONDITIONS 0x10/16; link 0
[    0.097137] twl4030_usb twl4030_usb: Initialized TWL4030 USB module
[    0.097656] vdd_mpu_iva: 600 <--> 1450 mV normal 
[    0.098114] vdd_core: 600 <--> 1450 mV normal 
[    0.098632] VMMC1: 1850 <--> 3150 mV at 3000 mV normal standby
[    0.099182] VDAC: 1800 mV normal standby
[    0.099731] VDVI: 1800 mV normal standby
[    0.100219] omap_i2c omap_i2c.3: bus 3 rev1.4.0 at 400 kHz
[    0.101013] omap-iommu omap-iommu.0: isp registered
[    0.101226] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    0.102233] Switching to clocksource 32k_counter
[    0.130187] usbhs_omap usbhs_omap: xclk60mhsp2_ck set parentfailed error:-22
[    0.131042] NET: Registered protocol family 2
[    0.131378] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.131958] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.132171] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
[    0.132263] TCP: Hash tables configured (established 8192 bind 8192)
[    0.132293] TCP: reno registered
[    0.132293] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.132324] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.132659] NET: Registered protocol family 1
[    0.133239] RPC: Registered named UNIX socket transport module.
[    0.133270] RPC: Registered udp transport module.
[    0.133270] RPC: Registered tcp transport module.
[    0.133300] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.136047] audit: initializing netlink socket (disabled)
[    0.136108] type=2000 audit(0.132:1): initialized
[    0.137695] VFS: Disk quotas dquot_6.5.2
[    0.137786] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.138183] NFS: Registering the id_resolver key type
[    0.138244] Key type id_resolver registered
[    0.138732] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.139495] fuse init (API version 7.19)
[    0.140014] msgmni has been set to 395
[    0.142089] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    0.142120] io scheduler noop registered
[    0.142120] io scheduler deadline registered (default)
[    0.142974] OMAP DSS rev 2.0
[    0.146301] omap_uart.0: ttyO0 at MMIO 0x4806a000 (irq = 72) is a OMAP UART0
[    0.146789] omap_uart.1: ttyO1 at MMIO 0x4806c000 (irq = 73) is a OMAP UART1
[    0.147247] omap_uart.2: ttyO2 at MMIO 0x49020000 (irq = 74) is a OMAP UART2
[    0.838134] console [ttyO2] enabled
[    0.842254] omap_uart.3: ttyO3 at MMIO 0x49042000 (irq = 80) is a OMAP UART3
[    0.858276] brd: module loaded
[    0.865966] loop: module loaded
[    0.871551] twl4030_madc twl4030_madc: clk disabled, enabling
[    0.879730] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xbc (Micron
NAND 512MiB 1,8V 16-bit), page size: 2048, OOB size: 64
[    0.892517] Creating 5 MTD partitions on "omap2-nand.0":
[    0.898071] 0x000000000000-0x000000080000 : "xloader"
[    0.905120] 0x000000080000-0x000000240000 : "uboot"
[    0.912811] 0x000000240000-0x000000280000 : "uboot environment"
[    0.920318] 0x000000280000-0x000000680000 : "linux"
[    0.929840] 0x000000680000-0x000020000000 : "rootfs"
[    1.360931] smsc911x: Driver version 2008-10-21
[    1.367584] smsc911x-mdio: probed
[    1.371276] smsc911x smsc911x.0: eth0: attached PHY driver [Generic PHY]
(mii_bus:phy_addr=smsc911x-0:01, irq=-1)
[    1.382202] smsc911x smsc911x.0: eth0: MAC Address: 00:15:c9:28:fb:53
[    1.388977] smsc911x: Driver version 2008-10-21
[    1.394317] usbcore: registered new interface driver asix
[    1.400115] usbcore: registered new interface driver cdc_ether
[    1.406311] usbcore: registered new interface driver cdc_ncm
[    1.412567] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.419433] ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
[    1.419616] ehci-omap.0 supply hsusb1 not found, using dummy regulator
[    2.430511] ehci-omap ehci-omap.0: phy reset operation timed out
[    2.430541] ehci-omap ehci-omap.0: reset hcs_params 0x1313 dbg=0 cc=1
pcc=3 ordered ports=3
[    2.430572] ehci-omap ehci-omap.0: reset hcc_params 0016 thresh 1 uframes
256/512/1024 park
[    2.430603] ehci-omap ehci-omap.0: reset command 0080b02  park=3
ithresh=8 period=1024 Reset HALT
[    2.430633] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
[    2.436859] ehci-omap ehci-omap.0: new USB bus registered, assigned bus
number 1
[    2.444732] ehci-omap ehci-omap.0: park 0
[    2.444763] ehci-omap ehci-omap.0: irq 77, io mem 0x48064800
[    2.450744] ehci-omap ehci-omap.0: init command 0010005 (park)=0
ithresh=1 period=512 RUN
[    2.461791] ehci-omap ehci-omap.0: USB 2.0 started, EHCI 1.00
[    2.467987] usb usb1: default language 0x0409
[    2.468017] usb usb1: udev 1, busnum 1, minor = 0
[    2.468048] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.475158] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.482727] usb usb1: Product: OMAP-EHCI Host Controller
[    2.488281] usb usb1: Manufacturer: Linux 3.5.0 ehci_hcd
[    2.493865] usb usb1: SerialNumber: ehci-omap.0
[    2.499176] usb usb1: usb_probe_device
[    2.499176] usb usb1: configuration #1 chosen from 1 choice
[    2.499237] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.499420] hub 1-0:1.0: usb_probe_interface
[    2.499450] hub 1-0:1.0: usb_probe_interface - got id
[    2.499450] hub 1-0:1.0: USB hub found
[    2.503448] hub 1-0:1.0: 3 ports detected
[    2.507629] hub 1-0:1.0: standalone hub
[    2.507629] hub 1-0:1.0: individual port power switching
[    2.507659] hub 1-0:1.0: individual port over-current protection
[    2.507659] hub 1-0:1.0: power on to power good time: 20ms
[    2.507690] hub 1-0:1.0: local power source is good
[    2.507720] hub 1-0:1.0: enabling power on all ports
[    2.508026] ehci-omap ehci-omap.0: ...powerup ports...
[    2.532287] Initializing USB Mass Storage driver...
[    2.537536] usbcore: registered new interface driver usb-storage
[    2.543853] USB Mass Storage support registered.
[    2.548706] musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)
[    2.560974] twl4030_usb twl4030_usb: twl4030_phy_resume
[    2.561218] musb-hdrc: ConfigData=0xde (UTMI-8, dyn FIFOs, bulk combine,
bulk split, HB-ISO Rx, HB-ISO Tx, SoftConn)
[    2.561248] musb-hdrc: MHDRC RTL version 1.800 
[    2.561248] musb-hdrc: setup fifo_mode 4
[    2.561279] musb-hdrc: 28/31 max ep, 16384/16384 memory
[    2.561737] musb-hdrc musb-hdrc: USB OTG mode controller at fa0ab000
using DMA, IRQ 92
[    2.572143] twl4030_usb twl4030_usb: twl4030_phy_suspend
[    2.572692] mousedev: PS/2 mouse device common for all mice
[    2.579315] twl_rtc twl_rtc: Enabling TWL-RTC
[    2.586639] twl_rtc twl_rtc: rtc core: registered twl_rtc as rtc0
[    2.593933] i2c /dev entries driver
[    2.599151] cpuidle: using governor ladder
[    2.603607] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[    2.603698] cpuidle: using governor menu
[    2.608337] omap_hsmmc omap_hsmmc.0: Failed to get debounce clk
[    2.614715] omap_hsmmc.0 supply vmmc_aux not found, using dummy regulator
[    2.993255] omap_hsmmc omap_hsmmc.1: Failed to get debounce clk
[    2.999542] omap_hsmmc.1 supply vmmc not found, using dummy regulator
[    3.007446] omap_hsmmc.1 supply vmmc_aux not found, using dummy regulator
[    3.016876] omap_hsmmc omap_hsmmc.1: could not set regulator OCR (-22)
[    3.023895] omap_hsmmc omap_hsmmc.1: could not set regulator OCR (-22)
[    3.071655] Registered led device: overo:red:gpio21
[    3.071807] Registered led device: overo:blue:gpio22
[    3.072540] Registered led device: overo:blue:COM
[    3.074127] usbcore: registered new interface driver usbhid
[    3.080108] usbhid: USB HID core driver
[    3.085235] usbcore: registered new interface driver snd-usb-audio
[    3.093109] overo SoC init
[    3.096160] soc-audio soc-audio: ASoC machine overo should use
snd_soc_register_card()
[    3.173583] twl4030-codec twl4030-codec: ASoC: Failed to create Capture
debugfs file
[    3.186553] asoc: twl4030-hifi <-> omap-mcbsp.2 mapping ok
[    3.197357] oprofile: hardware counters not available
[    3.202819] oprofile: using timer interrupt.
[    3.207366] mmc0: host does not support reading read-only switch.
assuming write-enable.
[    3.216400] TCP: cubic registered
[    3.219909] NET: Registered protocol family 17
[    3.224609] NET: Registered protocol family 15
[    3.229583] Key type dns_resolver registered
[    3.234313] mmc0: new high speed SDHC card at address e624
[    3.240417] VFP support v0.3: implementor 41 architecture 3 part 30
variant c rev 3
[    3.250915] mmcblk0: mmc0:e624 SU04G 3.69 GiB 
[    3.259918] ThumbEE CPU extension supported.
[    3.264404] sr_init: No PMIC hook to init smartreflex
[    3.269927] smartreflex smartreflex.0: omap_sr_probe: SmartReflex driver
initialized
[    3.278259] smartreflex smartreflex.1: omap_sr_probe: SmartReflex driver
initialized
[    3.286621]  mmcblk0: p1 p2
[    3.296997] clock: disabling unused clocks to save power
[    3.307830] registered taskstats version 1
[    3.312927] OMAPFB: omapfb_init
[    3.313110] OMAPFB: omapfb_probe
[    3.313232] fbcvt: 1024x768@60: CVT Name - .786M3-R
[    3.318481] OMAPFB: create 3 framebuffers
[    3.318511] OMAPFB: fb_infos allocated
[    3.318511] OMAPFB: allocating 1572864 bytes for fb 0
[    3.328643] OMAPFB: allocated VRAM paddr 8f400000, vaddr d0a00000
[    3.328674] OMAPFB: region0 phys 8f400000 virt d0a00000 size=1572864
[    3.328674] OMAPFB: region1 phys 00000000 virt   (null) size=0
[    3.328704] OMAPFB: region2 phys 00000000 virt   (null) size=0
[    3.328704] OMAPFB: fbmems allocated
[    3.328704] OMAPFB: check_fb_var 0
[    3.328735] OMAPFB: max frame size 1572864, line size 2048
[    3.328735] OMAPFB: xres = 1024, yres = 768, vxres = 1024, vyres = 768
[    3.328765] OMAPFB: set_fb_fix
[    3.328765] OMAPFB: fb_infos initialized
[    3.329467] OMAPFB: set_par(0)
[    3.329467] OMAPFB: set_fb_fix
[    3.329467] OMAPFB: apply_changes, fb 0, ovl 0
[    3.329498] OMAPFB: setup_overlay 0, posx 0, posy 0, outw 1024, outh 768
[    3.329498] OMAPFB: paddr 8f400000
[    3.329589] OMAPFB: pan_display(0)
[    3.329620] OMAPFB: setcmap
[    3.329620] OMAPFB: setcmap
[    3.339477] Console: switching to colour frame buffer device 128x48
[    3.339508] OMAPFB: pan_display(0)
[    3.339508] OMAPFB: setcmap
[    3.349304] OMAPFB: setcmap
[    3.356445] OMAPFB: framebuffers registered
[    3.356475] OMAPFB: apply_changes, fb 0, ovl 0
[    3.356475] OMAPFB: setup_overlay 0, posx 0, posy 0, outw 1024, outh 768
[    3.356475] OMAPFB: paddr 8f400000
[    3.356506] OMAPFB: apply_changes, fb 1, ovl 1
[    3.356506] OMAPFB: apply_changes, fb 2, ovl 2
[    3.356536] OMAPFB: create_framebuffers done
[    3.356567] OMAPFB: mgr->apply'ed
[    3.359069] OMAPFB: create sysfs for fbs
[    3.359100] OMAPFB: create sysfs for fbs
[    3.359649] VDAC: incomplete constraints, leaving on
[    3.367095] twl_rtc twl_rtc: setting system clock to 2000-01-01 00:00:33
UTC (946684833)
[    3.375701] ALSA device list:
[    3.378845]   #0: overo
[    4.745574] EXT3-fs (mmcblk0p2): warning: mounting fs with errors,
running e2fsck is recommended
[    4.754821] kjournald starting.  Commit interval 5 seconds
[    4.763580] EXT3-fs (mmcblk0p2): using internal journal
[    4.771972] EXT3-fs (mmcblk0p2): recovery complete
[    4.777008] EXT3-fs (mmcblk0p2): mounted filesystem with writeback data mode
[    4.784454] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    4.796386] devtmpfs: mounted
[    4.800079] Freeing init memory: 236K
[    5.009033] hub 1-0:1.0: hub_suspend
[    5.009094] usb usb1: bus auto-suspend, wakeup 1
[    5.009094] ehci-omap ehci-omap.0: suspend root hub
[    5.234069] OMAPFB: pan_display(0)
[    5.234069] OMAPFB: setcmap
[    5.234069] OMAPFB: setcmap
[    5.252929] OMAPFB: user mmap region start 8f400000, len 1572864, off
8f400000
[    5.602050] udevd (96): /proc/96/oom_adj is deprecated, please use
/proc/96/oom_score_adj instead.
[    6.074401] Linux media interface: v0.10
[    6.240020] ads7846 spi1.0: touchscreen, irq 210
[    6.458099] ads7846 spi1.0: no device detected, test read result was
0x00000FFF
[    6.497283] Linux video capture interface: v2.00
[    7.348510] omap3isp supply VDD_CSIPHY1 not found, using dummy regulator
[    7.850219] omap3isp supply VDD_CSIPHY2 not found, using dummy regulator
[    8.360656] omap3isp omap3isp: Revision 15.0 found
[    8.365783] omap-iommu omap-iommu.0: isp: version 1.1
[    8.913238] TOM v4l2_device_register_subdev SD: OMAP3 ISP CCP2 ENT: OMAP3
ISP CCP2 ##########
[    9.198394] TOM VID REG IN -1 ##########
[    9.202514] TOM VID REG OUT 0 ##########
[    9.322601] TOM v4l2_device_register_subdev SD: OMAP3 ISP CSI2a ENT:
OMAP3 ISP CSI2a ##########
[    9.335906] TOM VID REG IN -1 ##########
[    9.340911] TOM VID REG OUT 1 ##########
[    9.350982] TOM v4l2_device_register_subdev SD: OMAP3 ISP CCDC ENT: OMAP3
ISP CCDC ##########
[    9.362274] TOM VID REG IN -1 ##########
[    9.366394] TOM VID REG OUT 2 ##########
[    9.377746] TOM v4l2_device_register_subdev SD: OMAP3 ISP preview ENT:
OMAP3 ISP preview ##########
[    9.387329] TOM VID REG IN -1 ##########
[    9.396301] TOM VID REG OUT 3 ##########
[    9.403167] TOM VID REG IN -1 ##########
[    9.408752] TOM VID REG OUT 4 ##########
[    9.421081] TOM v4l2_device_register_subdev SD: OMAP3 ISP resizer ENT:
OMAP3 ISP resizer ##########
[    9.436859] TOM VID REG IN -1 ##########
[    9.441101] TOM VID REG OUT 5 ##########
[    9.447753] TOM VID REG IN -1 ##########
[    9.451934] TOM VID REG OUT 6 ##########
[    9.456726] TOM v4l2_device_register_subdev SD: OMAP3 ISP AEWB ENT: OMAP3
ISP AEWB ##########
[    9.465698] TOM v4l2_device_register_subdev SD: OMAP3 ISP AF ENT: OMAP3
ISP AF ##########
[    9.474273] TOM v4l2_device_register_subdev SD: OMAP3 ISP histogram ENT:
OMAP3 ISP histogram ##########
[    9.531951] 3-003c supply avdd not found, using dummy regulator
[    9.549041] 3-003c supply dvdd not found, using dummy regulator
[    9.555328] 3-003c supply dovdd not found, using dummy regulator
[    9.570648] gpio_request: gpio-98 (ov3640) status -16
[    9.571014] TOM v4l2_device_register_subdev SD: ov3640 3-003c ENT: ov3640
3-003c ##########
[    9.599273] ov3640 3-003c: OV3640 found, product ID 0x364c
[    9.599304] TOM_SD_NAME_ORI: OMAP3 ISP CCP2 ##########
[    9.613464] TOM VID REG IN -1 ##########
[    9.618316] TOM VID REG OUT 0 ##########
[    9.624237] TOM_SD_NAME_ORI: v4l-subdev0 ##########
[    9.631683] TOM_SD_NAME_ORI: OMAP3 ISP CSI2a ##########
[    9.637695] TOM VID REG IN -1 ##########
[    9.644042] TOM VID REG OUT 1 ##########
[    9.652709] TOM_SD_NAME_ORI: v4l-subdev1 ##########
[    9.658630] TOM_SD_NAME_ORI: OMAP3 ISP CCDC ##########
[    9.664520] TOM VID REG IN -1 ##########
[    9.669067] TOM VID REG OUT 2 ##########
[    9.674804] TOM_SD_NAME_ORI: v4l-subdev2 ##########
[    9.680694] TOM_SD_NAME_ORI: OMAP3 ISP preview ##########
[    9.686828] TOM VID REG IN -1 ##########
[    9.691406] TOM VID REG OUT 3 ##########
[    9.698883] TOM_SD_NAME_ORI: v4l-subdev3 ##########
[    9.704559] TOM_SD_NAME_ORI: OMAP3 ISP resizer ##########
[    9.710632] TOM VID REG IN -1 ##########
[    9.715148] TOM VID REG OUT 4 ##########
[    9.720764] TOM_SD_NAME_ORI: v4l-subdev4 ##########
[    9.726348] TOM_SD_NAME_ORI: OMAP3 ISP AEWB ##########
[    9.732177] TOM VID REG IN -1 ##########
[    9.736755] TOM VID REG OUT 5 ##########
[    9.742309] TOM_SD_NAME_ORI: v4l-subdev5 ##########
[    9.749664] TOM_SD_NAME_ORI: OMAP3 ISP AF ##########
[    9.755371] TOM VID REG IN -1 ##########
[    9.759887] TOM VID REG OUT 6 ##########
[    9.765472] TOM_SD_NAME_ORI: v4l-subdev6 ##########
[    9.771118] TOM_SD_NAME_ORI: OMAP3 ISP histogram ##########
[    9.777374] TOM VID REG IN -1 ##########
[    9.781829] TOM VID REG OUT 7 ##########
[    9.787384] TOM_SD_NAME_ORI: v4l-subdev7 ##########
[    9.792999] TOM_SD_NAME_ORI: ov3640 3-003c ##########
[    9.798736] TOM VID REG IN -1 ##########
[    9.804992] TOM VID REG OUT 8 ##########
[    9.810729] TOM_SD_NAME_ORI: v4l-subdev8 ##########
[    9.937255] TOM isp_video_querycap ##########
[    9.982666] TOM isp_video_querycap ##########
[    9.988525] TOM isp_video_querycap ##########
[    9.997039] TOM isp_video_querycap ##########
[   10.005249] TOM isp_video_querycap ##########
[   10.014739] TOM isp_video_querycap ##########
[   10.019775] TOM isp_video_querycap ##########
[   10.761474] alignment: ignoring faults is unsafe on this CPU.  Defaulting
to fixup mode.
[   11.839141] NET: Registered protocol family 10
[   13.921081] smsc911x smsc911x.0: eth2: SMSC911x/921x identified at
0xd0816000, IRQ: 272
[   13.985595] IPv6: eth2: IPv6 duplicate address fe80::215:c9ff:fe28:fb53
detected!
[   14.001953] netlink: 33 bytes leftover after parsing attributes.
[   14.008270] netlink: 33 bytes leftover after parsing attributes.
[   14.015289] netlink: 33 bytes leftover after parsing attributes.
[   15.368682] zeroconf calls setitimer() with new_value NULL pointer.
Misfeature support will be removed
[   21.505828] TOM isp_video_querycap ##########
[   21.526824] TOM isp_video_querycap ##########
[   21.542358] TOM isp_video_querycap ##########
[   21.554229] TOM isp_video_querycap ##########
[   21.559875] TOM isp_video_querycap ##########
[   21.577972] TOM isp_video_querycap ##########
[   21.594299] TOM isp_video_querycap ##########
[   33.173492] OMAPFB: check_var(0)
[   33.173492] OMAPFB: check_fb_var 0
[   33.173522] OMAPFB: max frame size 1572864, line size 2048
[   33.173522] OMAPFB: can't fit FB into memory, reducing y
[   33.173522] OMAPFB: xres = 1024, yres = 768, vxres = 1024, vyres = 768
[   33.173553] OMAPFB: set_par(0)
[   33.173553] OMAPFB: set_fb_fix
[   33.173553] OMAPFB: apply_changes, fb 0, ovl 0
[   33.173553] OMAPFB: setup_overlay 0, posx 0, posy 0, outw 1024, outh 768
[   33.173583] OMAPFB: paddr 8f400000
[   33.173645] OMAPFB: pan_display(0)
[   33.173645] OMAPFB: setcmap
[   34.134246] OMAPFB: setcmap
[   34.134307] OMAPFB: pan_display(0)
[   34.134307] OMAPFB: setcmap
[   34.134338] OMAPFB: setcmap
[   34.213775] OMAPFB: ioctl GET_CAPS
[   34.213928] OMAPFB: ioctl QUERY_MEM
[   34.216461] OMAPFB: user mmap region start 8f400000, len 1572864, off
8f400000
[   34.242553] OMAPFB: ioctl QUERY_PLANE
[   34.242584] OMAPFB: ioctl SETUP_PLANE
[   34.242584] OMAPFB: omapfb_setup_plane
[   34.242614] OMAPFB: setup_overlay 0, posx 0, posy 0, outw 1024, outh 768
[   34.242614] OMAPFB: paddr 8f400000
[   34.245727] OMAPFB: ioctl QUERY_PLANE
[   34.245758] OMAPFB: ioctl SETUP_PLANE
[   34.245758] OMAPFB: omapfb_setup_plane
[   34.245758] omapdss OVERLAY error: check_overlay: paddr cannot be 0
[   34.253906] omapdss OVERLAY error: check_overlay: paddr cannot be 0
[   34.261108] omapfb omapfb: setup_plane failed
[   34.265808] OMAPFB: ioctl failed: -22
[   97.679321] TOM SENS ov3640_set_format 8193 ##########
[  119.385772] TOM isp_video_querycap ##########
[  119.392303] TOM isp_video_set_format ##########
[  119.397979] TOM isp_video_pix_to_mbus ##########
[  119.402832] TOM isp_video_mbus_to_pix ##########
[  119.409576] TOM isp_video_get_format ##########
[  119.416046] TOM isp_video_reqbuf ##########
[  119.421325] TOM omap3isp_video_queue_reqbufs ##########
[  119.446380] TOM omap3isp_video_queue_reqbufs DONE##########
[  119.454833] TOM isp_video_querybuf ##########
[  119.459381] TOM omap3isp_video_queue_querybuf ##########
[  119.468139] TOM omap3isp_video_queue_querybuf DONE ##########
[  119.476257] TOM omap3isp_video_queue_mmap ##########
[  119.485870] TOM omap3isp_video_queue_mmap DONE ##########
[  119.493286] TOM isp_video_querybuf ##########
[  119.497894] TOM omap3isp_video_queue_querybuf ##########
[  119.504699] TOM omap3isp_video_queue_querybuf DONE ##########
[  119.512329] TOM omap3isp_video_queue_mmap ##########
[  119.521911] TOM omap3isp_video_queue_mmap DONE ##########
[  119.529266] TOM isp_video_querybuf ##########
[  119.534759] TOM omap3isp_video_queue_querybuf ##########
[  119.541015] TOM omap3isp_video_queue_querybuf DONE ##########
[  119.548767] TOM omap3isp_video_queue_mmap ##########
[  119.558410] TOM omap3isp_video_queue_mmap DONE ##########
[  119.565917] TOM isp_video_querybuf ##########
[  119.571411] TOM omap3isp_video_queue_querybuf ##########
[  119.577667] TOM omap3isp_video_queue_querybuf DONE ##########
[  119.585754] TOM omap3isp_video_queue_mmap ##########
[  119.595245] TOM omap3isp_video_queue_mmap DONE ##########
[  119.602569] TOM isp_video_qbuf ##########
[  119.606842] TOM omap3isp_video_queue_qbuf ##########
[  119.623260] TOM omap3isp_video_queue_qbuf DONE ##########
[  119.630035] TOM isp_video_qbuf ##########
[  119.634887] TOM omap3isp_video_queue_qbuf ##########
[  119.650634] TOM omap3isp_video_queue_qbuf DONE ##########
[  119.657409] TOM isp_video_qbuf ##########
[  119.661590] TOM omap3isp_video_queue_qbuf ##########
[  119.677673] TOM omap3isp_video_queue_qbuf DONE ##########
[  119.684539] TOM isp_video_qbuf ##########
[  119.689331] TOM omap3isp_video_queue_qbuf ##########
[  119.705078] TOM omap3isp_video_queue_qbuf DONE ##########
[  137.918395] TOM isp_video_streamon ##########
[  137.933563] TOM isp_video_streamon 1 ##########
[  137.940032] TOM isp_video_streamon 2 ##########
[  137.946075] TOM SENS ov3640_get_format ##########
[  137.952728] TOM isp_video_streamon 3 ##########
[  137.957458] TOM isp_video_check_format ##########
[  137.963531] TOM isp_video_mbus_to_pix ##########
[  137.969238] TOM isp_video_check_format 1 ##########
[  137.974334] TOM isp_video_check_format DONE ##########
[  137.980682] TOM isp_video_streamon 4 ##########
[  137.988281] TOM isp_video_streamon 5 ##########
[  137.994079] TOM isp_video_streamon 6 ##########
[  137.999816] TOM omap3isp_video_queue_streamon ##########
[  138.008697] TOM omap3isp_video_queue_streamon DONE##########
[  138.015502] TOM isp_video_streamon 7 ##########
[  138.020263] TOM SENS ov3640_get_format ##########
[  138.026214] TOM SENS ov3640_set_stream ##########
[  138.033020] ov3640 3-003c: Register 0x3012 written 0x000080 read 0x000000
[  138.093383] TOM void ccdc_vd1_isr ##########
[  138.142913] TOM isp_video_streamon 8 ##########
[  138.148559] TOM isp_video_streamon DONE ##########
[  138.153839] TOM isp_video_dqbuf ##########
[  138.159210] TOM omap3isp_video_queue_dqbuf ##########
[  138.167358] TOM omap3isp_video_queue_dqbuf temp 1 ##########
[  138.174774] TOM omap3isp_video_queue_dqbuf temp 1,5 ##########
[  138.181671] TOM isp_video_buffer_wait ##########
[  138.187164] TOM isp_video_buffer_wait temp ##########
[  138.215698] TOM void ccdc_vd0_isr ##########
[  138.220153] TOM ccdc_isr_buffer ##########
[  138.224426] TOM ccdc_isr_buffer 1 ##########
[  138.228881] TOM ccdc_isr_buffer 2 ##########
[  138.233337] TOM ccdc_isr_buffer 3 ##########
[  138.240234] TOM ccdc_isr_buffer ERROR 3 ##########
[  138.245269] omap3isp omap3isp: CCDC won't become idle!
[  138.250610] TOM void ccdc_vd0_isr DONE ##########
[  157.756805] TOM void ccdc_vd1_isr ##########
[  158.221801] TOM void ccdc_vd0_isr ##########
[  158.226287] TOM ccdc_isr_buffer ##########
[  158.230560] TOM ccdc_isr_buffer 1 ##########
[  158.234985] TOM ccdc_isr_buffer 2 ##########
[  158.239440] TOM ccdc_isr_buffer 3 ##########
[  158.246337] TOM ccdc_isr_buffer ERROR 3 ##########
[  158.251373] omap3isp omap3isp: CCDC won't become idle!
[  158.256713] TOM void ccdc_vd0_isr DONE ##########
[  179.058990] TOM void ccdc_vd1_isr ##########
[  179.541320] TOM void ccdc_vd0_isr ##########
[  179.545806] TOM ccdc_isr_buffer ##########
[  179.550079] TOM ccdc_isr_buffer 1 ##########
[  179.554504] TOM ccdc_isr_buffer 2 ##########
[  179.558959] TOM ccdc_isr_buffer 3 ##########
[  179.565887] TOM ccdc_isr_buffer ERROR 3 ##########
[  179.570892] omap3isp omap3isp: CCDC won't become idle!
[  179.576232] TOM void ccdc_vd0_isr DONE ##########
[  200.361114] TOM void ccdc_vd1_isr ##########
[  200.860809] TOM void ccdc_vd0_isr ##########
[  200.865295] TOM ccdc_isr_buffer ##########
[  200.869567] TOM ccdc_isr_buffer 1 ##########
[  200.873992] TOM ccdc_isr_buffer 2 ##########
[  200.878448] TOM ccdc_isr_buffer 3 ##########
[  200.885345] TOM ccdc_isr_buffer ERROR 3 ##########
[  200.890380] omap3isp omap3isp: CCDC won't become idle!
[  200.895721] TOM void ccdc_vd0_isr DONE ##########
[  221.937011] TOM void ccdc_vd1_isr ##########
[  222.180297] TOM void ccdc_vd0_isr ##########
[  222.184753] TOM ccdc_isr_buffer ##########
[  222.189025] TOM ccdc_isr_buffer 1 ##########
[  222.193481] TOM ccdc_isr_buffer 2 ##########
[  222.197937] TOM ccdc_isr_buffer 3 ##########
[  222.204833] TOM ccdc_isr_buffer ERROR 3 ##########
[  222.209838] omap3isp omap3isp: CCDC won't become idle!
[  222.215209] TOM void ccdc_vd0_isr DONE ##########
[  243.256469] TOM void ccdc_vd1_isr ##########
[  243.499786] TOM void ccdc_vd0_isr ##########
[  243.504272] TOM ccdc_isr_buffer ##########
[  243.508544] TOM ccdc_isr_buffer 1 ##########
[  243.513000] TOM ccdc_isr_buffer 2 ##########
[  243.517456] TOM ccdc_isr_buffer 3 ##########
[  243.524353] TOM ccdc_isr_buffer ERROR 3 ##########
[  243.529357] omap3isp omap3isp: CCDC won't become idle!
[  243.534729] TOM void ccdc_vd0_isr DONE ##########
[  264.575866] TOM void ccdc_vd1_isr ##########
[  264.819213] TOM void ccdc_vd0_isr ##########
[  264.823669] TOM ccdc_isr_buffer ##########
[  264.827941] TOM ccdc_isr_buffer 1 ##########
[  264.832397] TOM ccdc_isr_buffer 2 ##########
[  264.836853] TOM ccdc_isr_buffer 3 ##########
[  264.843749] TOM ccdc_isr_buffer ERROR 3 ##########
[  264.848754] omap3isp omap3isp: CCDC won't become idle!
[  264.854125] TOM void ccdc_vd0_isr DONE ##########
[  285.895294] TOM void ccdc_vd1_isr ##########
[  286.129241] TOM void ccdc_vd0_isr ##########
[  286.133728] TOM ccdc_isr_buffer ##########
[  286.138000] TOM ccdc_isr_buffer 1 ##########
[  286.142456] TOM ccdc_isr_buffer 2 ##########
[  286.146881] TOM ccdc_isr_buffer 3 ##########
[  286.153778] TOM ccdc_isr_buffer ERROR 3 ##########
[  286.158782] omap3isp omap3isp: CCDC won't become idle!
[  286.164154] TOM void ccdc_vd0_isr DONE ##########
[  307.214782] TOM void ccdc_vd1_isr ##########
[  307.431335] TOM void ccdc_vd0_isr ##########
[  307.435821] TOM ccdc_isr_buffer ##########
[  307.440093] TOM ccdc_isr_buffer 1 ##########
[  307.444549] TOM ccdc_isr_buffer 2 ##########
[  307.449005] TOM ccdc_isr_buffer 3 ##########
[  307.455902] TOM ccdc_isr_buffer ERROR 3 ##########
[  307.460906] omap3isp omap3isp: CCDC won't become idle!
[  307.466278] TOM void ccdc_vd0_isr DONE ##########
[  328.534149] TOM void ccdc_vd1_isr ##########
[  328.733398] TOM void ccdc_vd0_isr ##########
[  328.737854] TOM ccdc_isr_buffer ##########
[  328.742126] TOM ccdc_isr_buffer 1 ##########
[  328.746582] TOM ccdc_isr_buffer 2 ##########
[  328.751037] TOM ccdc_isr_buffer 3 ##########
[  328.757934] TOM ccdc_isr_buffer ERROR 3 ##########
[  328.762939] omap3isp omap3isp: CCDC won't become idle!
[  328.768280] TOM void ccdc_vd0_isr DONE ##########
[  349.853576] TOM void ccdc_vd1_isr ##########
[  350.035430] TOM void ccdc_vd0_isr ##########
[  350.039916] TOM ccdc_isr_buffer ##########
[  350.044189] TOM ccdc_isr_buffer 1 ##########
[  350.048645] TOM ccdc_isr_buffer 2 ##########
[  350.053100] TOM ccdc_isr_buffer 3 ##########
[  350.059997] TOM ccdc_isr_buffer ERROR 3 ##########
[  350.065002] omap3isp omap3isp: CCDC won't become idle!
[  350.070373] TOM void ccdc_vd0_isr DONE ##########
[  371.172943] TOM void ccdc_vd1_isr ##########
[  371.337524] TOM void ccdc_vd0_isr ##########
[  371.342010] TOM ccdc_isr_buffer ##########
[  371.346252] TOM ccdc_isr_buffer 1 ##########
[  371.350708] TOM ccdc_isr_buffer 2 ##########
[  371.355163] TOM ccdc_isr_buffer 3 ##########
[  371.362060] TOM ccdc_isr_buffer ERROR 3 ##########
[  371.367065] omap3isp omap3isp: CCDC won't become idle!
[  371.372436] TOM void ccdc_vd0_isr DONE ##########
[  392.492340] TOM void ccdc_vd1_isr ##########
[  392.913238] TOM void ccdc_vd0_isr ##########
[  392.917694] TOM ccdc_isr_buffer ##########
[  392.921966] TOM ccdc_isr_buffer 1 ##########
[  392.926422] TOM ccdc_isr_buffer 2 ##########
[  392.930877] TOM ccdc_isr_buffer 3 ##########
[  392.937774] TOM ccdc_isr_buffer ERROR 3 ##########
[  392.942779] omap3isp omap3isp: CCDC won't become idle!
[  392.948150] TOM void ccdc_vd0_isr DONE ##########
[  413.811737] TOM void ccdc_vd1_isr ##########
[  414.232635] TOM void ccdc_vd0_isr ##########
[  414.237121] TOM ccdc_isr_buffer ##########
[  414.241394] TOM ccdc_isr_buffer 1 ##########
[  414.245819] TOM ccdc_isr_buffer 2 ##########
[  414.250274] TOM ccdc_isr_buffer 3 ##########
[  414.257171] TOM ccdc_isr_buffer ERROR 3 ##########
[  414.262176] omap3isp omap3isp: CCDC won't become idle!
[  414.267547] TOM void ccdc_vd0_isr DONE ##########



