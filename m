Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50294 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752380AbcLPMI1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 07:08:27 -0500
Date: Fri, 16 Dec 2016 13:44:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Greg KH <greg@kroah.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Message-ID: <20161216114443.GI16630@valkosipuli.retiisi.org.uk>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
 <3043978.ViByGAdkJL@avalon>
 <20161215103734.716a0619@vento.lan>
 <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com>
 <20161215105716.30186ff5@vento.lan>
 <20161215134438.GA28343@kroah.com>
 <20161215120706.6cbed1de@vento.lan>
 <20161216082124.GG16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gdTfX7fkYsEEjebm"
Content-Disposition: inline
In-Reply-To: <20161216082124.GG16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

On Fri, Dec 16, 2016 at 10:21:25AM +0200, Sakari Ailus wrote:
...
> At least some of the issues the patches claim to fix are really not fixed
> either. They are just made slightly less likely to accidentally stumble
> upon.

I couldn't immediately trigger this with the current mainline kernel as the
remaining time window isn't very large. However making this trivial-looking
change:

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index f2772ba..6ec4125 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -32,6 +32,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -128,6 +129,8 @@ __media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg,
        if (!media_devnode_is_registered(devnode))
                return -EIO;
 
+       msleep(1000);
+
        return ioctl_func(filp, cmd, arg);
 }
 
And calling MEDIA_IOC_ENUM_ENTITIES (for instance) in a loop (v4l-utils):

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 1fd6525..5be3cea 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -522,7 +522,7 @@ static int media_enum_entities(struct media_device *media)
 		entity->fd = -1;
 		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
 		entity->media = media;
-
+while (1)
 		ret = ioctl(media->fd, MEDIA_IOC_ENUM_ENTITIES, &entity->info);
 		if (ret < 0) {
 			ret = errno != EINVAL ? -errno : 0;


And then unbinding the omap3-isp driver will immediately produce this. The
same would take place on any driver implementing the Media controller
interface. What happens there is that the memory backing the media device
has been released while the IOCTL call was in progress. This can happen
because device removal and IOCTL calls are not serialised nor the media
device is reference counted --- the latter of which I believe is the right
thing to do:

[  105.756408] Unable to handle kernel NULL pointer dereference at virtual address 00000140
[  105.756561] pgd = eda94000
[  105.756591] [00000140] *pgd=adaf8831, *pte=00000000, *ppte=00000000
[  105.756683] Internal error: Oops: 17 [#1] PREEMPT ARM
[  105.756744] Modules linked in: smiapp smiapp_pll omap3_isp videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core v4l2_common videodev media
[  105.756927] CPU: 0 PID: 2276 Comm: media-ctl Not tainted 4.9.0-rc6-00494-g9244e38-dirty #830
[  105.757019] Hardware name: Generic OMAP36xx (Flattened Device Tree)
[  105.757080] task: ed970380 task.stack: eda5e000
[  105.757141] PC is at __lock_acquire+0x94/0x1868
[  105.757202] LR is at lock_acquire+0x70/0x90
[  105.757263] pc : [<c015e9a8>]    lr : [<c01601ec>]    psr: 20000093
               sp : eda5fcc0  ip : eda5e000  fp : 00000000
[  105.757354] r10: 00000001  r9 : 00000000  r8 : 0002715c
[  105.757415] r7 : 00000140  r6 : 00000001  r5 : 60000013  r4 : ed970380
[  105.757476] r3 : 00000001  r2 : 00000001  r1 : 00000000  r0 : 00000140
[  105.757537] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  105.757629] Control: 10c5387d  Table: ada94019  DAC: 00000051
[  105.757690] Process media-ctl (pid: 2276, stack limit = 0xeda5e208)
[  105.757751] Stack: (0xeda5fcc0 to 0xeda60000)
[  105.757812] fcc0: ed970868 00000001 a409df10 c355d08b c0c75714 c01602f4 60000013 00000001
[  105.757904] fce0: ee1c9514 c0839b48 ee1c9518 effed360 ed970868 60000013 c0833e74 c0839b48
[  105.757995] fd00: effed360 effed360 c0e9166c ee1c951c ee1c9518 00000000 60000013 00000001
[  105.758087] fd20: 00000000 0002715c eda5e000 00000000 00000000 c01601ec 00000001 00000000
[  105.758178] fd40: 00000000 bf000e78 00000000 00000000 0000010c bf000e78 ed970380 c04ed214
[  105.758270] fd60: 00000001 00000000 bf000e78 c015aa50 ed9703b0 ed9703b0 c0830d50 00000000
[  105.758361] fd80: ed970848 c0830d60 ed970380 ed970380 c0830d60 c01602f4 c0e76744 00000051
[  105.758483] fda0: eda5fdd0 00000000 0002715c eda5fdd0 bf002e28 c1007c01 00000000 0002715c
[  105.758575] fdc0: eda5e000 00000000 00000000 bf000e78 00000001 50414d4f 53492033 43432050
[  105.758666] fde0: 00003250 00000000 00000000 00000000 00000000 00020000 00000000 00000000
[  105.758758] fe00: 00000000 00010002 00000000 00000000 00000000 00000000 00000051 00000007
[  105.758850] fe20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.758941] fe40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759033] fe60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759124] fe80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759216] fea0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759307] fec0: 00000000 00000000 00000000 00000000 ed967c80 bf000ddc ed967c80 0002715c
[  105.759399] fee0: c1007c01 00000003 00000000 bf001808 0002715c ed967c80 00000003 ed9fece0
[  105.759490] ff00: 00000003 c01ea4c4 0002715c c01eb4a8 00000000 00000000 c01fba18 ffffffff
[  105.759582] ff20: 00000001 00000000 ee84f010 ed89e440 00000000 ee2654e8 00000010 c01dacdc
[  105.759674] ff40: 00000000 00000000 00000000 ed89e538 ed8a2b50 ed9707a0 ed970380 00000000
[  105.759765] ff60: eda5ff7c eda5ff84 ed967c80 ed967c80 0002715c c1007c01 00000003 eda5e000
[  105.759857] ff80: 00000000 c01eb560 0002715c 00027008 00000000 00000036 c0107d84 eda5e000
[  105.759948] ffa0: 00000000 c0107be0 0002715c 00027008 00000003 c1007c01 0002715c 80000000
[  105.760070] ffc0: 0002715c 00027008 00000000 00000036 00027158 00000000 b6f71000 00000000
[  105.760162] ffe0: 00026b08 be9cf85c 000126a4 b6eaaa5c 20000010 00000003 fda7fddf fdbdffba
[  105.760253] [<c015e9a8>] (__lock_acquire) from [<c01601ec>] (lock_acquire+0x70/0x90)
[  105.760375] [<c01601ec>] (lock_acquire) from [<c04ed214>] (mutex_lock_nested+0x54/0x3f4)
[  105.760528] [<c04ed214>] (mutex_lock_nested) from [<bf000e78>] (media_device_ioctl+0x9c/0x120 [media])
[  105.760681] [<bf000e78>] (media_device_ioctl [media]) from [<bf001808>] (media_ioctl+0x54/0x60 [media])
[  105.760803] [<bf001808>] (media_ioctl [media]) from [<c01ea4c4>] (vfs_ioctl+0x18/0x30)
[  105.760894] [<c01ea4c4>] (vfs_ioctl) from [<c01eb4a8>] (do_vfs_ioctl+0x90c/0x974)
[  105.760986] [<c01eb4a8>] (do_vfs_ioctl) from [<c01eb560>] (SyS_ioctl+0x50/0x6c)
[  105.761108] [<c01eb560>] (SyS_ioctl) from [<c0107be0>] (ret_fast_syscall+0x0/0x1c)
[  105.761199] Code: e59f3f58 e593300c e3530000 0a000003 (e5972000) 
[  105.761260] ---[ end trace bdb47e9a97e34f03 ]---

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.9.0-rc6-00494-g9244e38-dirty (sakke@lanttu) (gcc version 4.4.5 (Debian 4.4.5-8) ) #830 PREEMPT Fri Dec 16 13:05:56 EET 2016
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] OF: fdt:Machine model: Nokia N9
[    0.000000] Memory policy: Data cache writeback
[    0.000000] On node 0 totalpages: 261632
[    0.000000] free_area_init_node: node 0, pgdat c0862d18, node_mem_map ef7f9000
[    0.000000]   Normal zone: 1536 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 196608 pages, LIFO batch:31
[    0.000000]   HighMem zone: 65024 pages, LIFO batch:15
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] OMAP3630 ES1.2 (l2cache iva sgx neon isp 192mhz_clk)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096
[    0.000000] Kernel command line: ip=192.168.1.130::192.168.1.129:::usb0:off root=/dev/nfs nfsroot=192.168.1.129:/scratch/rootfs/laiskiainen rootdelay=5 rw console=tty0 console=ttyS0,115200n8 musb_core.debug=1 musb_hdrc.debug=2 musb.debug=3 loglevel=8
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 1020796K/1046528K available (4096K kernel code, 423K rwdata, 1520K rodata, 1024K init, 8748K bss, 25732K reserved, 0K cma-reserved, 260096K highmem)
[    0.000000] Virtual kernel memory layout:
                   vector  : 0xffff0000 - 0xffff1000   (   4 kB)
                   fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
                   vmalloc : 0xf0800000 - 0xff800000   ( 240 MB)
                   lowmem  : 0xc0000000 - 0xf0000000   ( 768 MB)
                   pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
                   modules : 0xbf000000 - 0xbfe00000   (  14 MB)
                     .text : 0xc0008000 - 0xc0500000   (5088 kB)
                     .init : 0xc0700000 - 0xc0800000   (1024 kB)
                     .data : 0xc0800000 - 0xc0869ee0   ( 424 kB)
                      .bss : 0xc086b000 - 0xc10f60ac   (8749 kB)
[    0.000000] Running RCU self tests
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Build-time adjustment of leaf fanout to 32.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 4.0) with 96 interrupts
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] Clocking rate (Crystal/Core/MPU): 38.4/390/600 MHz
[    0.000000] OMAP clockevent source: timer1 at 32768 Hz
[    0.000000] clocksource: 32k_counter: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 58327039986419 ns
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 65535999984741ns
[    0.000030] OMAP clocksource: 32k_counter at 32768 Hz
[    0.001953] Console: colour dummy device 80x30
[    0.007110] console [tty0] enabled
[    0.007171] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.007232] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.007293] ... MAX_LOCK_DEPTH:          48
[    0.007354] ... MAX_LOCKDEP_KEYS:        8191
[    0.007385] ... CLASSHASH_SIZE:          4096
[    0.007446] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.007476] ... MAX_LOCKDEP_CHAINS:      65536
[    0.007537] ... CHAINHASH_SIZE:          32768
[    0.007598]  memory used by lock dependency info: 5167 kB
[    0.007629]  per task-struct memory footprint: 1536 bytes
[    0.012420] kmemleak: Early log buffer exceeded (5729), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.012603] Calibrating delay loop... 594.73 BogoMIPS (lpj=2973696)
[    0.055450] pid_max: default: 32768 minimum: 301
[    0.056091] Security Framework initialized
[    0.056365] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.056457] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.062133] CPU: Testing write buffer coherency: ok
[    0.064300] Setting up static identity map for 0x80100000 - 0x80100058
[    0.077606] devtmpfs: initialized
[    0.282196] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
[    0.285186] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.285888] pinctrl core: initialized pinctrl subsystem
[    0.303436] NET: Registered protocol family 16
[    0.305480] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.393951] omap_hwmod: mcbsp2_sidetone using broken dt data from mcbsp
[    0.396606] omap_hwmod: mcbsp3_sidetone using broken dt data from mcbsp
[    0.554779] cpuidle: using governor ladder
[    0.584381] cpuidle: using governor menu
[    0.586700] Reprogramming SDRC clock to 390400000 Hz
[    0.622039] gpio gpiochip0: (gpio): added GPIO chardev (254:0)
[    0.626495] gpiochip_setup_dev: registered GPIOs 0 to 31 on device: gpiochip0 (gpio)
[    0.640045] OMAP GPIO hardware version 2.5
[    0.643524] gpio gpiochip1: (gpio): added GPIO chardev (254:1)
[    0.647644] gpiochip_setup_dev: registered GPIOs 32 to 63 on device: gpiochip1 (gpio)
[    0.663696] gpio gpiochip2: (gpio): added GPIO chardev (254:2)
[    0.667083] gpiochip_setup_dev: registered GPIOs 64 to 95 on device: gpiochip2 (gpio)
[    0.683013] gpio gpiochip3: (gpio): added GPIO chardev (254:3)
[    0.686523] gpiochip_setup_dev: registered GPIOs 96 to 127 on device: gpiochip3 (gpio)
[    0.702575] gpio gpiochip4: (gpio): added GPIO chardev (254:4)
[    0.705993] gpiochip_setup_dev: registered GPIOs 128 to 159 on device: gpiochip4 (gpio)
[    0.721832] gpio gpiochip5: (gpio): added GPIO chardev (254:5)
[    0.725341] gpiochip_setup_dev: registered GPIOs 160 to 191 on device: gpiochip5 (gpio)
[    0.803131] omap-gpmc 6e000000.gpmc: GPMC revision 5.0
[    0.803466] gpmc_mem_init: disabling cs 0 mapped at 0x0-0x1000000
[    0.803649] gpiochip_find_base: found new base at 508
[    0.803771] gpio gpiochip6: (omap-gpmc): added GPIO chardev (254:6)
[    0.807403] gpiochip_setup_dev: registered GPIOs 508 to 511 on device: gpiochip6 (omap-gpmc)
[    0.831420] omap4_sram_init:Unable to allocate sram needed to handle errata I688
[    0.831542] omap4_sram_init:Unable to get sram pool needed to handle errata I688
[    0.834442] Reserving DMA channels 0 and 1 for HS ROM code
[    0.834533] OMAP DMA hardware revision 5.0
[    1.004791] of_get_named_gpiod_flags: parsed 'gpio' property of node '/fixedregulator0[0]' - status (0)
[    1.008300] of_get_named_gpiod_flags: parsed 'gpio' property of node '/fixedregulator2[0]' - status (0)
[    1.021636] omap-iommu 480bd400.mmu: 480bd400.mmu registered
[    1.026275] usbcore: registered new interface driver usbfs
[    1.027130] usbcore: registered new interface driver hub
[    1.028350] usbcore: registered new device driver usb
[    1.039947] omap_i2c 48070000.i2c: bus 0 rev4.4 at 2900 kHz
[    1.045410] omap_i2c 48072000.i2c: bus 1 rev4.4 at 400 kHz
[    1.050048] omap_i2c 48060000.i2c: bus 2 rev4.4 at 400 kHz
[    1.066101] clocksource: Switched to clocksource 32k_counter
[    1.199737] NET: Registered protocol family 2
[    1.204895] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    1.205200] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    1.210479] TCP: Hash tables configured (established 8192 bind 8192)
[    1.212127] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    1.212799] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    1.214843] NET: Registered protocol family 1
[    1.218505] RPC: Registered named UNIX socket transport module.
[    1.218597] RPC: Registered udp transport module.
[    1.218658] RPC: Registered tcp transport module.
[    1.218688] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.236053] futex hash table entries: 256 (order: 1, 11264 bytes)
[    1.238006] workingset: timestamp_bits=30 max_order=18 bucket_order=0
[    1.250549] bounce: pool size: 64 pages
[    1.250793] io scheduler noop registered
[    1.250854] io scheduler deadline registered
[    1.251068] io scheduler cfq registered (default)
[    1.254730] pinctrl-single 48002030.pinmux: 284 pins at pa fa002030 size 568
[    1.255828] pinctrl-single 48002a00.pinmux: 46 pins at pa fa002a00 size 92
[    1.258605] pinctrl-single 480025a0.pinmux: 46 pins at pa fa0025a0 size 92
[    1.267852] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.285034] omap_uart 4806a000.serial: no wakeirq for uart0
[    1.285156] of_get_named_gpiod_flags: can't parse 'rts-gpio' property of node '/ocp@68000000/serial@4806a000[0]'
[    1.287597] 4806a000.serial: ttyO0 at MMIO 0x4806a000 (irq = 88, base_baud = 3000000) is a OMAP UART0
[    1.291290] omap_uart 4806c000.serial: no wakeirq for uart1
[    1.291381] of_get_named_gpiod_flags: can't parse 'rts-gpio' property of node '/ocp@68000000/serial@4806c000[0]'
[    1.292175] 4806c000.serial: ttyO1 at MMIO 0x4806c000 (irq = 89, base_baud = 3000000) is a OMAP UART1
[    1.295654] omap_uart 49020000.serial: no wakeirq for uart2
[    1.295745] of_get_named_gpiod_flags: can't parse 'rts-gpio' property of node '/ocp@68000000/serial@49020000[0]'
[    1.296600] 49020000.serial: ttyO2 at MMIO 0x49020000 (irq = 90, base_baud = 3000000) is a OMAP UART2
[    1.300354] omap_uart 49042000.serial: no wakeirq for uart3
[    1.300476] of_get_named_gpiod_flags: can't parse 'rts-gpio' property of node '/ocp@68000000/serial@49042000[0]'
[    1.301269] 49042000.serial: ttyO3 at MMIO 0x49042000 (irq = 96, base_baud = 3000000) is a OMAP UART3
[    1.359130] twl 0-0048: PIH (irq 23) chaining IRQs 336..344
[    1.359741] twl 0-0048: power (irq 341) chaining IRQs 344..351
[    1.376525] random: fast init done
[    1.429595] vmmc2: Bringing 2800000uV into 3000000-3000000uV
[    1.472198] twl4030_gpio twl4030-gpio: gpio (irq 336) chaining IRQs 352..369
[    1.472900] gpiochip_find_base: found new base at 490
[    1.472991] gpio gpiochip7: (twl4030): added GPIO chardev (254:7)
[    1.475769] gpiochip_setup_dev: registered GPIOs 490 to 507 on device: gpiochip7 (twl4030)
[    1.557403] twl4030_usb 48070000.i2c:twl@48:twl4030-usb: Initialized TWL4030 USB module
[    1.600402] musb-hdrc musb-hdrc.0.auto: MUSB HDRC host driver
[    1.605224] musb-hdrc musb-hdrc.0.auto: new USB bus registered, assigned bus number 1
[    1.617126] hub 1-0:1.0: USB hub found
[    1.617828] hub 1-0:1.0: 1 port detected
[    1.643218] udc musb-hdrc.0.auto: registering UDC driver [g_ether]
[    1.643768] using random self ethernet address
[    1.643829] using random host ethernet address
[    1.643951] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/c0857960
[    1.644195] g_ether gadget: adding 'cdc_ethernet'/eeca7f00 to config 'CDC Ethernet (ECM)'/c0857960
[    1.650878] usb0: HOST MAC fa:bf:c4:9f:79:5c
[    1.652374] usb0: MAC c2:16:47:78:17:05
[    1.652587] g_ether gadget: CDC Ethernet: dual speed IN/ep1in OUT/ep1out NOTIFY/ep2in
[    1.652679] g_ether gadget: cfg 1/c0857960 speeds: high full
[    1.652740] g_ether gadget:   interface 0 = cdc_ethernet/eeca7f00
[    1.652801] g_ether gadget:   interface 1 = cdc_ethernet/eeca7f00
[    1.652893] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    1.652954] g_ether gadget: g_ether ready
[    1.658691] mousedev: PS/2 mouse device common for all mice
[    1.661560] twl4030_keypad 48070000.i2c:twl@48:keypad: OF: linux,keymap property not defined in /ocp@68000000/i2c@48070000/twl@48/keypad
[    1.661712] twl4030_keypad 48070000.i2c:twl@48:keypad: Failed to build keymap
[    1.661865] twl4030_keypad: probe of 48070000.i2c:twl@48:keypad failed with error -2
[    1.670135] input: twl4030_pwrbutton as /devices/platform/68000000.ocp/48070000.i2c/i2c-0/0-0048/48070000.i2c:twl@48:pwrbutton/input/input1
[    1.675292] twl_rtc 48070000.i2c:twl@48:rtc: Enabling TWL-RTC
[    1.682678] twl_rtc 48070000.i2c:twl@48:rtc: rtc core: registered 48070000.i2c:twl@48 as rtc0
[    1.684326] i2c /dev entries driver
[    1.692596] Driver for 1-wire Dallas network protocol.
[    1.704498] omap_wdt: OMAP Watchdog Timer Rev 0x31: initial timeout 60 sec
[    1.714324] omap_hsmmc 480b4000.mmc: GPIO lookup for consumer cd
[    1.714447] omap_hsmmc 480b4000.mmc: using device tree for GPIO lookup
[    1.714508] of_get_named_gpiod_flags: can't parse 'cd-gpios' property of node '/ocp@68000000/mmc@480b4000[0]'
[    1.714630] of_get_named_gpiod_flags: can't parse 'cd-gpio' property of node '/ocp@68000000/mmc@480b4000[0]'
[    1.714721] omap_hsmmc 480b4000.mmc: using lookup tables for GPIO lookup
[    1.714935] omap_hsmmc 480b4000.mmc: lookup for GPIO cd failed
[    1.715026] omap_hsmmc 480b4000.mmc: GPIO lookup for consumer wp
[    1.715118] omap_hsmmc 480b4000.mmc: using device tree for GPIO lookup
[    1.715179] of_get_named_gpiod_flags: can't parse 'wp-gpios' property of node '/ocp@68000000/mmc@480b4000[0]'
[    1.715270] of_get_named_gpiod_flags: can't parse 'wp-gpio' property of node '/ocp@68000000/mmc@480b4000[0]'
[    1.715393] omap_hsmmc 480b4000.mmc: using lookup tables for GPIO lookup
[    1.715454] omap_hsmmc 480b4000.mmc: lookup for GPIO wp failed
[    1.718139] omap_hsmmc 480b4000.mmc: RX DMA channel request failed
[    1.740539] FPGA DOWNLOAD --->
[    1.740600] FPGA image file name: xlinx_fpga_firmware.bit
[    1.742218] GPIO INIT FAIL!!
[    1.746093] Initializing XFRM netlink socket
[    1.746704] NET: Registered protocol family 17
[    1.746948] NET: Registered protocol family 15
[    1.747558] Key type dns_resolver registered
[    1.748168] omap2_set_init_voltage: unable to find boot up OPP for vdd_mpu_iva
[    1.748260] omap2_set_init_voltage: unable to set vdd_mpu_iva
[    1.748352] omap2_set_init_voltage: unable to find boot up OPP for vdd_core
[    1.748413] omap2_set_init_voltage: unable to set vdd_core
[    1.868743] twl_rtc 48070000.i2c:twl@48:rtc: setting system clock to 2016-12-16 11:47:32 UTC (1481888852)
[    1.872192] usb0: eth_open
[    2.162048] g_ether gadget: high-speed config #1: CDC Ethernet (ECM)
[    2.162322] g_ether gadget: init ecm
[    2.162384] g_ether gadget: notify connect false
[    2.163452] g_ether gadget: activate ecm
[    2.163848] usb0: qlen 10
[    2.163940] g_ether gadget: ecm_open
[    2.164062] usb0: eth_start
[    2.164886] g_ether gadget: packet filter 0c
[    2.164947] g_ether gadget: ecm req21.43 v000c i0000 l0
[    2.196624] IP-Config: Guessing netmask 255.255.255.0
[    2.196716] IP-Config: Complete:
[    2.196777]      device=usb0, hwaddr=c2:16:47:78:17:05, ipaddr=192.168.1.130, mask=255.255.255.0, gw=192.168.1.129
[    2.196868]      host=192.168.1.130, domain=, nis-domain=(none)
[    2.196929]      bootserver=255.255.255.255, rootserver=192.168.1.129, rootpath=
[    2.198852] VEMMC: disabling
[    2.198913] VWLAN: disabling
[    2.199554] vaux1: disabling
[    2.201324] vmmc1: disabling
[    2.201934] vmmc2: disabling
[    2.202514] vpll2: disabling
[    2.205230] Waiting 5 sec before mounting root device...
[    2.264862] g_ether gadget: packet filter 0e
[    2.264953] g_ether gadget: ecm req21.43 v000e i0000 l0
[    2.265136] g_ether gadget: packet filter 0e
[    2.265197] g_ether gadget: ecm req21.43 v000e i0000 l0
[    7.308624] VFS: Mounted root (nfs filesystem) on device 0:14.
[    7.311492] devtmpfs: mounted
[    7.314849] Freeing unused kernel memory: 1024K (c0700000 - c0800000)
[   10.908508] random: crng init done
[   90.905456] systemd-logind[2167]: Watching system buttons on /dev/input/event0 (twl4030_pwrbutton)
[   90.906097] systemd-logind[2167]: New seat seat0.
[   90.994140] systemd-logind[2167]: Failed to start user service, ignoring: Unknown unit: user@1000.service
[   91.020202] systemd-logind[2167]: New session c1 of user sailus.
[   92.451293] systemd-logind[2167]: New session c2 of user sailus.
[   95.002410] systemd-logind[2167]: Failed to start user service, ignoring: Unknown unit: user@0.service
[   95.014801] systemd-logind[2167]: New session c3 of user root.
[   96.710968] media: Linux media interface: v0.10
[   97.472167] Linux video capture interface: v2.00
[   98.979431] omap3isp 480bc000.isp: parsing endpoint /ocp@68000000/isp@480bc000/ports/port@2/endpoint, interface 2
[   98.979522] omap3isp 480bc000.isp: clock lane polarity 1, pos 2
[   98.979583] omap3isp 480bc000.isp: data lane 0 polarity 1, pos 1
[   98.979644] omap3isp 480bc000.isp: data lane 1 polarity 1, pos 3
[   98.981414] omap3isp 480bc000.isp: Revision 15.0 found
[   98.984558] iommu: Adding device 480bc000.isp to group 0
[   98.985809] omap-iommu 480bd400.mmu: 480bd400.mmu: version 1.1
[   98.996704] omap3isp 480bc000.isp: hist: DMA channel request failed, using PIO
[   98.996856] omap3isp 480bc000.isp: Media device initialized
[   98.996917] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP CCP2 was not initialized!
[   98.997558] omap3isp 480bc000.isp: media_gobj_create id 1: entity 'OMAP3 ISP CCP2'
[   98.997680] omap3isp 480bc000.isp: media_gobj_create id 2: sink pad 'OMAP3 ISP CCP2':0
[   98.997772] omap3isp 480bc000.isp: media_gobj_create id 3: source pad 'OMAP3 ISP CCP2':1
[   99.017211] omap3isp 480bc000.isp: media_gobj_create id 4: entity 'OMAP3 ISP CCP2 input'
[   99.017364] omap3isp 480bc000.isp: media_gobj_create id 5: source pad 'OMAP3 ISP CCP2 input':0
[   99.017486] omap3isp 480bc000.isp: media_gobj_create id 6: intf_devnode v4l-video - major: 81, minor: 0
[   99.017578] omap3isp 480bc000.isp: media_gobj_create id 7: interface link id 6 ==> id 4
[   99.017669] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP CSI2a was not initialized!
[   99.017822] omap3isp 480bc000.isp: media_gobj_create id 8: entity 'OMAP3 ISP CSI2a'
[   99.017913] omap3isp 480bc000.isp: media_gobj_create id 9: sink pad 'OMAP3 ISP CSI2a':0
[   99.018005] omap3isp 480bc000.isp: media_gobj_create id 10: source pad 'OMAP3 ISP CSI2a':1
[   99.035339] omap3isp 480bc000.isp: media_gobj_create id 11: entity 'OMAP3 ISP CSI2a output'
[   99.035461] omap3isp 480bc000.isp: media_gobj_create id 12: sink pad 'OMAP3 ISP CSI2a output':0
[   99.035583] omap3isp 480bc000.isp: media_gobj_create id 13: intf_devnode v4l-video - major: 81, minor: 1
[   99.035705] omap3isp 480bc000.isp: media_gobj_create id 14: interface link id 13 ==> id 11
[   99.035797] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP CCDC was not initialized!
[   99.035919] omap3isp 480bc000.isp: media_gobj_create id 15: entity 'OMAP3 ISP CCDC'
[   99.036010] omap3isp 480bc000.isp: media_gobj_create id 16: sink pad 'OMAP3 ISP CCDC':0
[   99.036102] omap3isp 480bc000.isp: media_gobj_create id 17: source pad 'OMAP3 ISP CCDC':1
[   99.046569] omap3isp 480bc000.isp: media_gobj_create id 18: source pad 'OMAP3 ISP CCDC':2
[   99.050018] omap3isp 480bc000.isp: media_gobj_create id 19: entity 'OMAP3 ISP CCDC output'
[   99.050140] omap3isp 480bc000.isp: media_gobj_create id 20: sink pad 'OMAP3 ISP CCDC output':0
[   99.050262] omap3isp 480bc000.isp: media_gobj_create id 21: intf_devnode v4l-video - major: 81, minor: 2
[   99.050354] omap3isp 480bc000.isp: media_gobj_create id 22: interface link id 21 ==> id 19
[   99.050476] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP preview was not initialized!
[   99.050598] omap3isp 480bc000.isp: media_gobj_create id 23: entity 'OMAP3 ISP preview'
[   99.050689] omap3isp 480bc000.isp: media_gobj_create id 24: sink pad 'OMAP3 ISP preview':0
[   99.050781] omap3isp 480bc000.isp: media_gobj_create id 25: source pad 'OMAP3 ISP preview':1
[   99.073944] omap3isp 480bc000.isp: media_gobj_create id 26: entity 'OMAP3 ISP preview input'
[   99.074066] omap3isp 480bc000.isp: media_gobj_create id 27: source pad 'OMAP3 ISP preview input':0
[   99.074188] omap3isp 480bc000.isp: media_gobj_create id 28: intf_devnode v4l-video - major: 81, minor: 3
[   99.074310] omap3isp 480bc000.isp: media_gobj_create id 29: interface link id 28 ==> id 26
[   99.075836] omap3isp 480bc000.isp: media_gobj_create id 30: entity 'OMAP3 ISP preview output'
[   99.075958] omap3isp 480bc000.isp: media_gobj_create id 31: sink pad 'OMAP3 ISP preview output':0
[   99.076080] omap3isp 480bc000.isp: media_gobj_create id 32: intf_devnode v4l-video - major: 81, minor: 4
[   99.076171] omap3isp 480bc000.isp: media_gobj_create id 33: interface link id 32 ==> id 30
[   99.077819] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP resizer was not initialized!
[   99.077972] omap3isp 480bc000.isp: media_gobj_create id 34: entity 'OMAP3 ISP resizer'
[   99.078063] omap3isp 480bc000.isp: media_gobj_create id 35: sink pad 'OMAP3 ISP resizer':0
[   99.078155] omap3isp 480bc000.isp: media_gobj_create id 36: source pad 'OMAP3 ISP resizer':1
[   99.095001] omap3isp 480bc000.isp: media_gobj_create id 37: entity 'OMAP3 ISP resizer input'
[   99.095153] omap3isp 480bc000.isp: media_gobj_create id 38: source pad 'OMAP3 ISP resizer input':0
[   99.095245] omap3isp 480bc000.isp: media_gobj_create id 39: intf_devnode v4l-video - major: 81, minor: 5
[   99.095367] omap3isp 480bc000.isp: media_gobj_create id 40: interface link id 39 ==> id 37
[   99.117553] omap3isp 480bc000.isp: media_gobj_create id 41: entity 'OMAP3 ISP resizer output'
[   99.117706] omap3isp 480bc000.isp: media_gobj_create id 42: sink pad 'OMAP3 ISP resizer output':0
[   99.117797] omap3isp 480bc000.isp: media_gobj_create id 43: intf_devnode v4l-video - major: 81, minor: 6
[   99.117919] omap3isp 480bc000.isp: media_gobj_create id 44: interface link id 43 ==> id 41
[   99.118011] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP AEWB was not initialized!
[   99.118164] omap3isp 480bc000.isp: media_gobj_create id 45: entity 'OMAP3 ISP AEWB'
[   99.118255] omap3isp 480bc000.isp: media_gobj_create id 46: sink pad 'OMAP3 ISP AEWB':0
[   99.118347] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP AF was not initialized!
[   99.118469] omap3isp 480bc000.isp: media_gobj_create id 47: entity 'OMAP3 ISP AF'
[   99.118560] omap3isp 480bc000.isp: media_gobj_create id 48: sink pad 'OMAP3 ISP AF':0
[   99.118682] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP histogram was not initialized!
[   99.118804] omap3isp 480bc000.isp: media_gobj_create id 49: entity 'OMAP3 ISP histogram'
[   99.118896] omap3isp 480bc000.isp: media_gobj_create id 50: sink pad 'OMAP3 ISP histogram':0
[   99.119018] omap3isp 480bc000.isp: media_gobj_create id 51: data link id 10 ==> id 12
[   99.119110] omap3isp 480bc000.isp: media_gobj_create id 52: data link id 10 ==> id 12
[   99.119201] omap3isp 480bc000.isp: media_gobj_create id 53: data link id 5 ==> id 2
[   99.119293] omap3isp 480bc000.isp: media_gobj_create id 54: data link id 5 ==> id 2
[   99.119384] omap3isp 480bc000.isp: media_gobj_create id 55: data link id 17 ==> id 20
[   99.119506] omap3isp 480bc000.isp: media_gobj_create id 56: data link id 17 ==> id 20
[   99.119598] omap3isp 480bc000.isp: media_gobj_create id 57: data link id 27 ==> id 24
[   99.119689] omap3isp 480bc000.isp: media_gobj_create id 58: data link id 27 ==> id 24
[   99.119781] omap3isp 480bc000.isp: media_gobj_create id 59: data link id 25 ==> id 31
[   99.119903] omap3isp 480bc000.isp: media_gobj_create id 60: data link id 25 ==> id 31
[   99.119995] omap3isp 480bc000.isp: media_gobj_create id 61: data link id 38 ==> id 35
[   99.120086] omap3isp 480bc000.isp: media_gobj_create id 62: data link id 38 ==> id 35
[   99.120178] omap3isp 480bc000.isp: media_gobj_create id 63: data link id 36 ==> id 42
[   99.120300] omap3isp 480bc000.isp: media_gobj_create id 64: data link id 36 ==> id 42
[   99.120391] omap3isp 480bc000.isp: media_gobj_create id 65: data link id 10 ==> id 16
[   99.120483] omap3isp 480bc000.isp: media_gobj_create id 66: data link id 10 ==> id 16
[   99.120574] omap3isp 480bc000.isp: media_gobj_create id 67: data link id 3 ==> id 16
[   99.120666] omap3isp 480bc000.isp: media_gobj_create id 68: data link id 3 ==> id 16
[   99.120758] omap3isp 480bc000.isp: media_gobj_create id 69: data link id 18 ==> id 24
[   99.120880] omap3isp 480bc000.isp: media_gobj_create id 70: data link id 18 ==> id 24
[   99.120971] omap3isp 480bc000.isp: media_gobj_create id 71: data link id 17 ==> id 35
[   99.121063] omap3isp 480bc000.isp: media_gobj_create id 72: data link id 17 ==> id 35
[   99.121154] omap3isp 480bc000.isp: media_gobj_create id 73: data link id 25 ==> id 35
[   99.121246] omap3isp 480bc000.isp: media_gobj_create id 74: data link id 25 ==> id 35
[   99.121368] omap3isp 480bc000.isp: media_gobj_create id 75: data link id 18 ==> id 46
[   99.121459] omap3isp 480bc000.isp: media_gobj_create id 76: data link id 18 ==> id 46
[   99.121551] omap3isp 480bc000.isp: media_gobj_create id 77: data link id 18 ==> id 48
[   99.121643] omap3isp 480bc000.isp: media_gobj_create id 78: data link id 18 ==> id 48
[   99.121765] omap3isp 480bc000.isp: media_gobj_create id 79: data link id 18 ==> id 50
[   99.121856] omap3isp 480bc000.isp: media_gobj_create id 80: data link id 18 ==> id 50
[  100.080444] smiapp 1-0010: lanes 2
[  100.080535] smiapp 1-0010: nvm 1024, clk 9600000, csi 2
[  100.080627] smiapp 1-0010: freq 0: 199200000
[  100.080688] smiapp 1-0010: freq 1: 210000000
[  100.080749] smiapp 1-0010: freq 2: 499200000
[  100.082061] omap3isp 480bc000.isp: isp_xclk_set_rate: cam_xclka set to 9600000 Hz (div 18)
[  100.082183] smiapp 1-0010: GPIO lookup for consumer xshutdown
[  100.082275] smiapp 1-0010: using device tree for GPIO lookup
[  100.082336] of_get_named_gpiod_flags: can't parse 'xshutdown-gpios' property of node '/ocp@68000000/i2c@48072000/camera@10[0]'
[  100.082458] of_get_named_gpiod_flags: can't parse 'xshutdown-gpio' property of node '/ocp@68000000/i2c@48072000/camera@10[0]'
[  100.082550] smiapp 1-0010: using lookup tables for GPIO lookup
[  100.082641] smiapp 1-0010: lookup for GPIO xshutdown failed
[  100.133239] smiapp 1-0010: module 0x0c-0x560f
[  100.133361] smiapp 1-0010: module revision 0x03-0x04 date 11-05-31
[  100.133422] smiapp 1-0010: sensor 0x0c-0x0905
[  100.133483] smiapp 1-0010: sensor revision 0x02 firmware version 0x00
[  100.133544] smiapp 1-0010: smia version 10 smiapp version 08
[  100.133636] smiapp 1-0010: the sensor is called jt8ew9, ident 0c560f03
[  100.134094] smiapp 1-0010: 0x00020080 "analogue_gain_capability" = 0, 0x0
[  100.134643] smiapp 1-0010: 0x00020084 "analogue_gain_code_min" = 68, 0x44
[  100.135162] smiapp 1-0010: 0x00020086 "analogue_gain_code_max" = 544, 0x220
[  100.135681] smiapp 1-0010: 0x00010802 "ths_zero_min" = 104, 0x68
[  100.136169] smiapp 1-0010: 0x00010804 "tclk_trail_min" = 64, 0x40
[  100.138183] smiapp 1-0010: 0x00021000 "integration_time_capability" = 0, 0x0
[  100.138702] smiapp 1-0010: 0x00021004 "coarse_integration_time_min" = 0, 0x0
[  100.139190] smiapp 1-0010: 0x00021006 "coarse_integration_time_max_margin" = 8, 0x8
[  100.139739] smiapp 1-0010: 0x00021008 "fine_integration_time_min" = 0, 0x0
[  100.140228] smiapp 1-0010: 0x0002100a "fine_integration_time_max_margin" = 0, 0x0
[  100.140747] smiapp 1-0010: 0x00021080 "digital_gain_capability" = 1, 0x1
[  100.141265] smiapp 1-0010: 0x00021084 "digital_gain_min" = 0, 0x0
[  100.141754] smiapp 1-0010: 0x00021086 "digital_gain_max" = 1023, 0x3ff
[  100.142272] smiapp 1-0010: 0x01041100 "min_ext_clk_freq_hz" = 6000000, 0x5b8d80
[  100.142852] smiapp 1-0010: 0x01041104 "max_ext_clk_freq_hz" = 27000000, 0x19bfcc0
[  100.143371] smiapp 1-0010: 0x00021108 "min_pre_pll_clk_div" = 1, 0x1
[  100.143859] smiapp 1-0010: 0x0002110a "max_pre_pll_clk_div" = 2, 0x2
[  100.144378] smiapp 1-0010: 0x0104110c "min_pll_ip_freq_hz" = 5000000, 0x4c4b40
[  100.144927] smiapp 1-0010: 0x01041110 "max_pll_ip_freq_hz" = 27000000, 0x19bfcc0
[  100.145446] smiapp 1-0010: 0x00021114 "min_pll_multiplier" = 36, 0x24
[  100.145965] smiapp 1-0010: 0x00021116 "max_pll_multiplier" = 400, 0x190
[  100.148284] smiapp 1-0010: 0x01041118 "min_pll_op_freq_hz" = 1000000000, 0x3b9aca00
[  100.148864] smiapp 1-0010: 0x0104111c "max_pll_op_freq_hz" = 2000000000, 0x77359400
[  100.149414] smiapp 1-0010: 0x00021120 "min_vt_sys_clk_div" = 1, 0x1
[  100.149902] smiapp 1-0010: 0x00021122 "max_vt_sys_clk_div" = 12, 0xc
[  100.150451] smiapp 1-0010: 0x01041124 "min_vt_sys_clk_freq_hz" = 83329994, 0x4f783ca
[  100.151000] smiapp 1-0010: 0x01041128 "max_vt_sys_clk_freq_hz" = 2000000000, 0x77359400
[  100.151550] smiapp 1-0010: 0x0104112c "min_vt_pix_clk_freq_hz" = 40000000, 0x2625a00
[  100.152130] smiapp 1-0010: 0x01041130 "max_vt_pix_clk_freq_hz" = 262000000, 0xf9dcd80
[  100.152648] smiapp 1-0010: 0x00021134 "min_vt_pix_clk_div" = 2, 0x2
[  100.153137] smiapp 1-0010: 0x00021136 "max_vt_pix_clk_div" = 12, 0xc
[  100.153625] smiapp 1-0010: 0x00021140 "min_frame_length_lines" = 192, 0xc0
[  100.154113] smiapp 1-0010: 0x00021142 "max_frame_length_lines" = 65535, 0xffff
[  100.154632] smiapp 1-0010: 0x00021144 "min_line_length_pck" = 2008, 0x7d8
[  100.155151] smiapp 1-0010: 0x00021146 "max_line_length_pck" = 16382, 0x3ffe
[  100.155639] smiapp 1-0010: 0x00021148 "min_line_blanking_pck" = 200, 0xc8
[  100.156127] smiapp 1-0010: 0x0002114a "min_frame_blanking_lines" = 40, 0x28
[  100.158386] smiapp 1-0010: 0x0001114c "min_line_length_pck_step_size" = 2, 0x2
[  100.158935] smiapp 1-0010: 0x00021160 "min_op_sys_clk_div" = 1, 0x1
[  100.159454] smiapp 1-0010: 0x00021162 "max_op_sys_clk_div" = 12, 0xc
[  100.159973] smiapp 1-0010: 0x01041164 "min_op_sys_clk_freq_hz" = 400000000, 0x17d78400
[  100.160552] smiapp 1-0010: 0x01041168 "max_op_sys_clk_freq_hz" = 2000000000, 0x77359400
[  100.161071] smiapp 1-0010: 0x0002116c "min_op_pix_clk_div" = 6, 0x6
[  100.161590] smiapp 1-0010: 0x0002116e "max_op_pix_clk_div" = 10, 0xa
[  100.162109] smiapp 1-0010: 0x01041170 "min_op_pix_clk_freq_hz" = 50000000, 0x2faf080
[  100.162658] smiapp 1-0010: 0x01041174 "max_op_pix_clk_freq_hz" = 250000000, 0xee6b280
[  100.163177] smiapp 1-0010: 0x00021180 "x_addr_min" = 0, 0x0
[  100.163696] smiapp 1-0010: 0x00021182 "y_addr_min" = 0, 0x0
[  100.164184] smiapp 1-0010: 0x00021184 "x_addr_max" = 3599, 0xe0f
[  100.164672] smiapp 1-0010: 0x00021186 "y_addr_max" = 2463, 0x99f
[  100.165161] smiapp 1-0010: 0x00021188 "min_x_output_size" = 184, 0xb8
[  100.165649] smiapp 1-0010: 0x0002118a "min_y_output_size" = 152, 0x98
[  100.166168] smiapp 1-0010: 0x0002118c "max_x_output_size" = 3576, 0xdf8
[  100.168182] smiapp 1-0010: 0x0002118e "max_y_output_size" = 2464, 0x9a0
[  100.168701] smiapp 1-0010: 0x000211c0 "min_even_inc" = 1, 0x1
[  100.169219] smiapp 1-0010: 0x000211c2 "max_even_inc" = 1, 0x1
[  100.169708] smiapp 1-0010: 0x000211c4 "min_odd_inc" = 1, 0x1
[  100.170196] smiapp 1-0010: 0x000211c6 "max_odd_inc" = 1, 0x1
[  100.170684] smiapp 1-0010: 0x00021200 "scaling_capability" = 2, 0x2
[  100.171173] smiapp 1-0010: 0x00021204 "scaler_m_min" = 16, 0x10
[  100.171691] smiapp 1-0010: 0x00021206 "scaler_m_max" = 255, 0xff
[  100.172180] smiapp 1-0010: 0x00021208 "scaler_n_min" = 16, 0x10
[  100.172668] smiapp 1-0010: 0x0002120a "scaler_n_max" = 16, 0x10
[  100.173156] smiapp 1-0010: 0x0002120c "spatial_sampling_capability" = 3, 0x3
[  100.173675] smiapp 1-0010: 0x0001120e "digital_crop_capability" = 1, 0x1
[  100.174163] smiapp 1-0010: 0x00021300 "compression_capability" = 1, 0x1
[  100.174682] smiapp 1-0010: 0x00011502 "fifo_support_capability" = 1, 0x1
[  100.175170] smiapp 1-0010: 0x00011600 "dphy_ctrl_capability" = 30, 0x1e
[  100.175659] smiapp 1-0010: 0x00011601 "csi_lane_mode_capability" = 3, 0x3
[  100.176177] smiapp 1-0010: 0x00011602 "csi_signalling_mode_capability" = 7, 0x7
[  100.178192] smiapp 1-0010: 0x00011603 "fast_standby_capability" = 1, 0x1
[  100.178741] smiapp 1-0010: 0x00011604 "cci_address_control_capability" = 1, 0x1
[  100.179290] smiapp 1-0010: 0x00041608 "max_per_lane_bitrate_1_lane_mode_mbps" = 65536000, 0x3e80000
[  100.179870] smiapp 1-0010: 0x0004160c "max_per_lane_bitrate_2_lane_mode_mbps" = 65536000, 0x3e80000
[  100.180419] smiapp 1-0010: 0x00041610 "max_per_lane_bitrate_3_lane_mode_mbps" = 0, 0x0
[  100.180969] smiapp 1-0010: 0x00041614 "max_per_lane_bitrate_4_lane_mode_mbps" = 0, 0x0
[  100.181518] smiapp 1-0010: 0x00011618 "temp_sensor_capability" = 0, 0x0
[  100.182006] smiapp 1-0010: 0x00021700 "min_frame_length_lines_bin" = 192, 0xc0
[  100.182525] smiapp 1-0010: 0x00021702 "max_frame_length_lines_bin" = 65535, 0xffff
[  100.183044] smiapp 1-0010: 0x00021704 "min_line_length_pck_bin" = 1104, 0x450
[  100.183563] smiapp 1-0010: 0x00021706 "max_line_length_pck_bin" = 16382, 0x3ffe
[  100.184082] smiapp 1-0010: 0x00021708 "min_line_blanking_pck_bin" = 200, 0xc8
[  100.184570] smiapp 1-0010: 0x0002170a "fine_integration_time_min_bin" = 0, 0x0
[  100.185089] smiapp 1-0010: 0x0002170c "fine_integration_time_max_margin_bin" = 0, 0x0
[  100.185638] smiapp 1-0010: 0x00011710 "binning_capability" = 1, 0x1
[  100.186126] smiapp 1-0010: 0x00011711 "binning_weighting_capability" = 5, 0x5
[  100.188018] smiapp 1-0010: 0x00011800 "data_transfer_if_capability" = 13, 0xd
[  100.188568] smiapp 1-0010: 0x00011900 "shading_correction_capability" = 0, 0x0
[  100.189086] smiapp 1-0010: 0x00011901 "green_imbalance_capability" = 0, 0x0
[  100.189575] smiapp 1-0010: 0x00011902 "black_level_capability" = 0, 0x0
[  100.190093] smiapp 1-0010: 0x00011903 "module_specific_correction_capability" = 0, 0x0
[  100.190612] smiapp 1-0010: 0x00021904 "defect_correction_capability" = 865, 0x361
[  100.191131] smiapp 1-0010: 0x00021906 "defect_correction_capability_2" = 0, 0x0
[  100.191650] smiapp 1-0010: 0x00011980 "edof_capability" = 0, 0x0
[  100.192138] smiapp 1-0010: 0x00011987 "colour_feedback_capability" = 0, 0x0
[  100.192657] smiapp 1-0010: 0x000119c0 "estimation_mode_capability" = 0, 0x0
[  100.193145] smiapp 1-0010: 0x000119c1 "estimation_zone_capability" = 0, 0x0
[  100.193634] smiapp 1-0010: 0x00021a00 "capability_trdy_min" = 0, 0x0
[  100.194152] smiapp 1-0010: 0x00011a02 "flash_mode_capability" = 3, 0x3
[  100.194641] smiapp 1-0010: 0x00011b04 "actuator_capability" = 4, 0x4
[  100.195129] smiapp 1-0010: 0x00011c00 "bracketing_lut_capability_1" = 3, 0x3
[  100.195648] smiapp 1-0010: 0x00011c01 "bracketing_lut_capability_2" = 0, 0x0
[  100.196136] smiapp 1-0010: 0x00020088 "analogue_gain_code_step" = 1, 0x1
[  100.198455] smiapp 1-0010: format_model_type 2 byte
[  100.199005] smiapp 1-0010: 0x00020042 visible pixels: 3576 columns (pixelcode 5)
[  100.199523] smiapp 1-0010: 0x00020044 embedded pixels: 2 rows (pixelcode 1)
[  100.200012] smiapp 1-0010: 0x00020046 visible pixels: 2464 rows (pixelcode 5)
[  100.200103] smiapp 1-0010: embedded data from lines 0 to 2
[  100.200164] smiapp 1-0010: image data starts at line 2
[  100.200225] smiapp 1-0010: quirk: 0x00020084 "analogue_gain_code_min" = 59, 0x3b
[  100.200317] smiapp 1-0010: quirk: 0x00020086 "analogue_gain_code_max" = 6000, 0x1770
[  100.201263] smiapp 1-0010: binning 2x1
[  100.201721] smiapp 1-0010: binning 3x1
[  100.202209] smiapp 1-0010: binning 4x1
[  100.202697] smiapp 1-0010: binning 5x1
[  100.203186] smiapp 1-0010: binning 6x1
[  100.203674] smiapp 1-0010: binning 7x1
[  100.204132] smiapp 1-0010: binning 8x1
[  100.204620] smiapp 1-0010: binning 1x2
[  100.205108] smiapp 1-0010: binning 2x2
[  100.205596] smiapp 1-0010: binning 3x2
[  100.206085] smiapp 1-0010: binning 4x2
[  100.210601] smiapp 1-0010: binning 5x2
[  100.211029] smiapp 1-0010: binning 6x2
[  100.211547] smiapp 1-0010: binning 7x2
[  100.212036] smiapp 1-0010: binning 8x2
[  100.212310] smiapp 1-0010: profile 2
[  100.213531] smiapp 1-0010: data_format_model_type 1
[  100.214080] smiapp 1-0010: pixel order 0 (GRBG)
[  100.214569] smiapp 1-0010: 0: bpp 8, compressed 8
[  100.214660] smiapp 1-0010: jolly good! 20
[  100.215148] smiapp 1-0010: 1: bpp 10, compressed 10
[  100.215209] smiapp 1-0010: jolly good! 12
[  100.215698] smiapp 1-0010: 2: bpp 10, compressed 8
[  100.215759] smiapp 1-0010: jolly good! 16
[  100.217773] smiapp 1-0010: 3: bpp 10, compressed 6
[  100.218353] smiapp 1-0010: 4: bpp 0, compressed 0
[  100.218872] smiapp 1-0010: 5: bpp 0, compressed 0
[  100.219360] smiapp 1-0010: 6: bpp 0, compressed 0
[  100.219848] smiapp 1-0010: 7: bpp 0, compressed 0
[  100.219970] smiapp 1-0010: link freq 199200000 Hz, bpp 10 ok
[  100.220062] smiapp 1-0010: link freq 210000000 Hz, bpp 10 ok
[  100.220123] smiapp 1-0010: link freq 499200000 Hz, bpp 10 ok
[  100.220184] smiapp 1-0010: link freq 199200000 Hz, bpp 8 ok
[  100.220275] smiapp 1-0010: link freq 210000000 Hz, bpp 8 ok
[  100.220336] smiapp 1-0010: link freq 499200000 Hz, bpp 8 ok
[  100.220397] smiapp 1-0010: link freq 199200000 Hz, bpp 8 ok
[  100.220489] smiapp 1-0010: link freq 210000000 Hz, bpp 8 ok
[  100.220550] smiapp 1-0010: link freq 499200000 Hz, bpp 8 ok
[  100.220611] smiapp 1-0010: flip 0
[  100.220672] smiapp 1-0010: new pixel order GRBG
[  100.221679] smiapp 1-0010: 0x00021700 "min_frame_length_lines_bin" = 192, 0xc0
[  100.222229] smiapp 1-0010: 0x00021702 "max_frame_length_lines_bin" = 65535, 0xffff
[  100.222747] smiapp 1-0010: 0x00021704 "min_line_length_pck_bin" = 1104, 0x450
[  100.223266] smiapp 1-0010: 0x00021706 "max_line_length_pck_bin" = 16382, 0x3ffe
[  100.223785] smiapp 1-0010: 0x00021708 "min_line_blanking_pck_bin" = 200, 0xc8
[  100.224273] smiapp 1-0010: 0x0002170a "fine_integration_time_min_bin" = 0, 0x0
[  100.224822] smiapp 1-0010: 0x0002170c "fine_integration_time_max_margin_bin" = 0, 0x0
[  100.225555] smiapp 1-0010: vblank		40
[  100.225616] smiapp 1-0010: hblank		200
[  100.225677] smiapp 1-0010: real timeperframe	100/837
[  100.225769] omap3isp 480bc000.isp: Entity type for entity jt8ew9 scaler 1-0010 was not initialized!
[  100.226074] omap3isp 480bc000.isp: media_gobj_create id 81: entity 'jt8ew9 scaler 1-0010'
[  100.226165] omap3isp 480bc000.isp: media_gobj_create id 82: sink pad 'jt8ew9 scaler 1-0010':0
[  100.228637] omap3isp 480bc000.isp: media_gobj_create id 83: source pad 'jt8ew9 scaler 1-0010':1
[  100.228729] omap3isp 480bc000.isp: Entity type for entity jt8ew9 binner 1-0010 was not initialized!
[  100.228881] omap3isp 480bc000.isp: media_gobj_create id 84: entity 'jt8ew9 binner 1-0010'
[  100.228973] omap3isp 480bc000.isp: media_gobj_create id 85: sink pad 'jt8ew9 binner 1-0010':0
[  100.229095] omap3isp 480bc000.isp: media_gobj_create id 86: source pad 'jt8ew9 binner 1-0010':1
[  100.229278] omap3isp 480bc000.isp: media_gobj_create id 87: data link id 86 ==> id 82
[  100.229370] omap3isp 480bc000.isp: media_gobj_create id 88: data link id 86 ==> id 82
[  100.229522] omap3isp 480bc000.isp: media_gobj_create id 89: entity 'jt8ew9 pixel_array 1-0010'
[  100.229614] omap3isp 480bc000.isp: media_gobj_create id 90: source pad 'jt8ew9 pixel_array 1-0010':0
[  100.229705] omap3isp 480bc000.isp: media_gobj_create id 91: data link id 90 ==> id 85
[  100.229827] omap3isp 480bc000.isp: media_gobj_create id 92: data link id 90 ==> id 85
[  100.229919] omap3isp 480bc000.isp: media_gobj_create id 93: data link id 83 ==> id 9
[  100.230102] omap3isp 480bc000.isp: media_gobj_create id 94: data link id 83 ==> id 9
[  100.240844] omap3isp 480bc000.isp: media_gobj_create id 95: intf_devnode v4l-subdev - major: 81, minor: 7
[  100.241027] omap3isp 480bc000.isp: media_gobj_create id 96: interface link id 95 ==> id 1
[  100.242675] omap3isp 480bc000.isp: media_gobj_create id 97: intf_devnode v4l-subdev - major: 81, minor: 8
[  100.242797] omap3isp 480bc000.isp: media_gobj_create id 98: interface link id 97 ==> id 8
[  100.256774] omap3isp 480bc000.isp: media_gobj_create id 99: intf_devnode v4l-subdev - major: 81, minor: 9
[  100.256927] omap3isp 480bc000.isp: media_gobj_create id 100: interface link id 99 ==> id 15
[  100.267517] omap3isp 480bc000.isp: media_gobj_create id 101: intf_devnode v4l-subdev - major: 81, minor: 10
[  100.267669] omap3isp 480bc000.isp: media_gobj_create id 102: interface link id 101 ==> id 23
[  100.277679] omap3isp 480bc000.isp: media_gobj_create id 103: intf_devnode v4l-subdev - major: 81, minor: 11
[  100.277832] omap3isp 480bc000.isp: media_gobj_create id 104: interface link id 103 ==> id 34
[  100.279418] omap3isp 480bc000.isp: media_gobj_create id 105: intf_devnode v4l-subdev - major: 81, minor: 12
[  100.279541] omap3isp 480bc000.isp: media_gobj_create id 106: interface link id 105 ==> id 45
[  100.281005] omap3isp 480bc000.isp: media_gobj_create id 107: intf_devnode v4l-subdev - major: 81, minor: 13
[  100.281127] omap3isp 480bc000.isp: media_gobj_create id 108: interface link id 107 ==> id 47
[  100.287719] omap3isp 480bc000.isp: media_gobj_create id 109: intf_devnode v4l-subdev - major: 81, minor: 14
[  100.287841] omap3isp 480bc000.isp: media_gobj_create id 110: interface link id 109 ==> id 49
[  100.293731] omap3isp 480bc000.isp: media_gobj_create id 111: intf_devnode v4l-subdev - major: 81, minor: 15
[  100.293884] omap3isp 480bc000.isp: media_gobj_create id 112: interface link id 111 ==> id 84
[  100.306762] omap3isp 480bc000.isp: media_gobj_create id 113: intf_devnode v4l-subdev - major: 81, minor: 16
[  100.306915] omap3isp 480bc000.isp: media_gobj_create id 114: interface link id 113 ==> id 89
[  100.317626] omap3isp 480bc000.isp: media_gobj_create id 115: intf_devnode v4l-subdev - major: 81, minor: 17
[  100.317779] omap3isp 480bc000.isp: media_gobj_create id 116: interface link id 115 ==> id 81
[  100.322357] omap3isp 480bc000.isp: Media device registered
[  104.372009] omap3isp 480bc000.isp: media_gobj_destroy id 112: interface link id 111 ==> id 84
[  104.372161] omap3isp 480bc000.isp: media_gobj_destroy id 88: data link id 86 ==> id 82
[  104.372283] omap3isp 480bc000.isp: media_gobj_destroy id 87: data link id 86 ==> id 82
[  104.372375] omap3isp 480bc000.isp: media_gobj_destroy id 91: data link id 90 ==> id 85
[  104.372467] omap3isp 480bc000.isp: media_gobj_destroy id 92: data link id 90 ==> id 85
[  104.372589] omap3isp 480bc000.isp: media_gobj_destroy id 85: sink pad 'jt8ew9 binner 1-0010':0
[  104.372680] omap3isp 480bc000.isp: media_gobj_destroy id 86: source pad 'jt8ew9 binner 1-0010':1
[  104.372772] omap3isp 480bc000.isp: media_gobj_destroy id 84: entity 'jt8ew9 binner 1-0010'
[  104.387878] omap3isp 480bc000.isp: media_gobj_destroy id 111: intf_devnode v4l-subdev - major: 81, minor: 15
[  104.388061] omap3isp 480bc000.isp: media_gobj_destroy id 114: interface link id 113 ==> id 89
[  104.388183] omap3isp 480bc000.isp: media_gobj_destroy id 90: source pad 'jt8ew9 pixel_array 1-0010':0
[  104.388275] omap3isp 480bc000.isp: media_gobj_destroy id 89: entity 'jt8ew9 pixel_array 1-0010'
[  104.392883] omap3isp 480bc000.isp: media_gobj_destroy id 113: intf_devnode v4l-subdev - major: 81, minor: 16
[  104.393066] omap3isp 480bc000.isp: media_gobj_destroy id 116: interface link id 115 ==> id 81
[  104.393188] omap3isp 480bc000.isp: media_gobj_destroy id 94: data link id 83 ==> id 9
[  104.393280] omap3isp 480bc000.isp: media_gobj_destroy id 93: data link id 83 ==> id 9
[  104.393371] omap3isp 480bc000.isp: media_gobj_destroy id 82: sink pad 'jt8ew9 scaler 1-0010':0
[  104.393493] omap3isp 480bc000.isp: media_gobj_destroy id 83: source pad 'jt8ew9 scaler 1-0010':1
[  104.393585] omap3isp 480bc000.isp: media_gobj_destroy id 81: entity 'jt8ew9 scaler 1-0010'
[  104.394805] omap3isp 480bc000.isp: media_gobj_destroy id 115: intf_devnode v4l-subdev - major: 81, minor: 17
[  104.439941] smiapp 1-0010: flip 0
[  104.440032] smiapp 1-0010: new pixel order GRBG
[  104.442810] smiapp 1-0010: 0x00021700 "min_frame_length_lines_bin" = 192, 0xc0
[  104.443359] smiapp 1-0010: 0x00021702 "max_frame_length_lines_bin" = 65535, 0xffff
[  104.448059] smiapp 1-0010: 0x00021704 "min_line_length_pck_bin" = 1104, 0x450
[  104.448608] smiapp 1-0010: 0x00021706 "max_line_length_pck_bin" = 16382, 0x3ffe
[  104.449127] smiapp 1-0010: 0x00021708 "min_line_blanking_pck_bin" = 200, 0xc8
[  104.449584] smiapp 1-0010: 0x0002170a "fine_integration_time_min_bin" = 0, 0x0
[  104.450073] smiapp 1-0010: 0x0002170c "fine_integration_time_max_margin_bin" = 0, 0x0
[  104.450225] smiapp 1-0010: vblank		40
[  104.450286] smiapp 1-0010: hblank		200
[  104.450347] smiapp 1-0010: real timeperframe	100/837
[  104.463836] smiapp 1-0010: lanes 2
[  104.463958] smiapp 1-0010: nvm 1024, clk 9600000, csi 2
[  104.464019] smiapp 1-0010: freq 0: 199200000
[  104.464080] smiapp 1-0010: freq 1: 210000000
[  104.464141] smiapp 1-0010: freq 2: 499200000
[  104.465606] smiapp 1-0010: GPIO lookup for consumer xshutdown
[  104.465698] smiapp 1-0010: using device tree for GPIO lookup
[  104.465789] of_get_named_gpiod_flags: can't parse 'xshutdown-gpios' property of node '/ocp@68000000/i2c@48072000/camera@10[0]'
[  104.465911] of_get_named_gpiod_flags: can't parse 'xshutdown-gpio' property of node '/ocp@68000000/i2c@48072000/camera@10[0]'
[  104.466003] smiapp 1-0010: using lookup tables for GPIO lookup
[  104.466156] smiapp 1-0010: lookup for GPIO xshutdown failed
[  104.504943] smiapp 1-0010: module 0x0c-0x560f
[  104.505035] smiapp 1-0010: module revision 0x03-0x04 date 11-05-31
[  104.505096] smiapp 1-0010: sensor 0x0c-0x0905
[  104.505157] smiapp 1-0010: sensor revision 0x02 firmware version 0x00
[  104.505249] smiapp 1-0010: smia version 10 smiapp version 08
[  104.505310] smiapp 1-0010: the sensor is called jt8ew9, ident 0c560f03
[  104.505767] smiapp 1-0010: 0x00020080 "analogue_gain_capability" = 0, 0x0
[  104.512725] smiapp 1-0010: 0x00020084 "analogue_gain_code_min" = 68, 0x44
[  104.513244] smiapp 1-0010: 0x00020086 "analogue_gain_code_max" = 544, 0x220
[  104.513671] smiapp 1-0010: 0x00010802 "ths_zero_min" = 104, 0x68
[  104.514984] smiapp 1-0010: 0x00010804 "tclk_trail_min" = 64, 0x40
[  104.516143] smiapp 1-0010: 0x00021000 "integration_time_capability" = 0, 0x0
[  104.521514] smiapp 1-0010: 0x00021004 "coarse_integration_time_min" = 0, 0x0
[  104.522033] smiapp 1-0010: 0x00021006 "coarse_integration_time_max_margin" = 8, 0x8
[  104.522491] smiapp 1-0010: 0x00021008 "fine_integration_time_min" = 0, 0x0
[  104.523590] smiapp 1-0010: 0x0002100a "fine_integration_time_max_margin" = 0, 0x0
[  104.524444] smiapp 1-0010: 0x00021080 "digital_gain_capability" = 1, 0x1
[  104.527923] smiapp 1-0010: 0x00021084 "digital_gain_min" = 0, 0x0
[  104.528411] smiapp 1-0010: 0x00021086 "digital_gain_max" = 1023, 0x3ff
[  104.528900] smiapp 1-0010: 0x01041100 "min_ext_clk_freq_hz" = 6000000, 0x5b8d80
[  104.529418] smiapp 1-0010: 0x01041104 "max_ext_clk_freq_hz" = 27000000, 0x19bfcc0
[  104.533569] smiapp 1-0010: 0x00021108 "min_pre_pll_clk_div" = 1, 0x1
[  104.534057] smiapp 1-0010: 0x0002110a "max_pre_pll_clk_div" = 2, 0x2
[  104.536071] smiapp 1-0010: 0x0104110c "min_pll_ip_freq_hz" = 5000000, 0x4c4b40
[  104.537994] smiapp 1-0010: 0x01041110 "max_pll_ip_freq_hz" = 27000000, 0x19bfcc0
[  104.538482] smiapp 1-0010: 0x00021114 "min_pll_multiplier" = 36, 0x24
[  104.542999] smiapp 1-0010: 0x00021116 "max_pll_multiplier" = 400, 0x190
[  104.543579] smiapp 1-0010: 0x01041118 "min_pll_op_freq_hz" = 1000000000, 0x3b9aca00
[  104.544097] smiapp 1-0010: 0x0104111c "max_pll_op_freq_hz" = 2000000000, 0x77359400
[  104.547637] smiapp 1-0010: 0x00021120 "min_vt_sys_clk_div" = 1, 0x1
[  104.548156] smiapp 1-0010: 0x00021122 "max_vt_sys_clk_div" = 12, 0xc
[  104.548675] smiapp 1-0010: 0x01041124 "min_vt_sys_clk_freq_hz" = 83329994, 0x4f783ca
[  104.549194] smiapp 1-0010: 0x01041128 "max_vt_sys_clk_freq_hz" = 2000000000, 0x77359400
[  104.549713] smiapp 1-0010: 0x0104112c "min_vt_pix_clk_freq_hz" = 40000000, 0x2625a00
[  104.550262] smiapp 1-0010: 0x01041130 "max_vt_pix_clk_freq_hz" = 262000000, 0xf9dcd80
[  104.550720] smiapp 1-0010: 0x00021134 "min_vt_pix_clk_div" = 2, 0x2
[  104.551177] smiapp 1-0010: 0x00021136 "max_vt_pix_clk_div" = 12, 0xc
[  104.551605] smiapp 1-0010: 0x00021140 "min_frame_length_lines" = 192, 0xc0
[  104.553192] smiapp 1-0010: 0x00021142 "max_frame_length_lines" = 65535, 0xffff
[  104.553680] smiapp 1-0010: 0x00021144 "min_line_length_pck" = 2008, 0x7d8
[  104.554138] smiapp 1-0010: 0x00021146 "max_line_length_pck" = 16382, 0x3ffe
[  104.561035] smiapp 1-0010: 0x00021148 "min_line_blanking_pck" = 200, 0xc8
[  104.561645] smiapp 1-0010: 0x0002114a "min_frame_blanking_lines" = 40, 0x28
[  104.562164] smiapp 1-0010: 0x0001114c "min_line_length_pck_step_size" = 2, 0x2
[  104.562622] smiapp 1-0010: 0x00021160 "min_op_sys_clk_div" = 1, 0x1
[  104.563140] smiapp 1-0010: 0x00021162 "max_op_sys_clk_div" = 12, 0xc
[  104.563659] smiapp 1-0010: 0x01041164 "min_op_sys_clk_freq_hz" = 400000000, 0x17d78400
[  104.564239] smiapp 1-0010: 0x01041168 "max_op_sys_clk_freq_hz" = 2000000000, 0x77359400
[  104.564697] smiapp 1-0010: 0x0002116c "min_op_pix_clk_div" = 6, 0x6
[  104.565155] smiapp 1-0010: 0x0002116e "max_op_pix_clk_div" = 10, 0xa
[  104.565734] smiapp 1-0010: 0x01041170 "min_op_pix_clk_freq_hz" = 50000000, 0x2faf080
[  104.567718] smiapp 1-0010: 0x01041174 "max_op_pix_clk_freq_hz" = 250000000, 0xee6b280
[  104.568267] smiapp 1-0010: 0x00021180 "x_addr_min" = 0, 0x0
[  104.568695] smiapp 1-0010: 0x00021182 "y_addr_min" = 0, 0x0
[  104.570556] smiapp 1-0010: 0x00021184 "x_addr_max" = 3599, 0xe0f
[  104.571044] smiapp 1-0010: 0x00021186 "y_addr_max" = 2463, 0x99f
[  104.571472] smiapp 1-0010: 0x00021188 "min_x_output_size" = 184, 0xb8
[  104.573181] smiapp 1-0010: 0x0002118a "min_y_output_size" = 152, 0x98
[  104.577911] smiapp 1-0010: 0x0002118c "max_x_output_size" = 3576, 0xdf8
[  104.579193] smiapp 1-0010: 0x0002118e "max_y_output_size" = 2464, 0x9a0
[  104.579681] smiapp 1-0010: 0x000211c0 "min_even_inc" = 1, 0x1
[  104.580230] smiapp 1-0010: 0x000211c2 "max_even_inc" = 1, 0x1
[  104.580688] smiapp 1-0010: 0x000211c4 "min_odd_inc" = 1, 0x1
[  104.581176] smiapp 1-0010: 0x000211c6 "max_odd_inc" = 1, 0x1
[  104.581604] smiapp 1-0010: 0x00021200 "scaling_capability" = 2, 0x2
[  104.584808] smiapp 1-0010: 0x00021204 "scaler_m_min" = 16, 0x10
[  104.585327] smiapp 1-0010: 0x00021206 "scaler_m_max" = 255, 0xff
[  104.585754] smiapp 1-0010: 0x00021208 "scaler_n_min" = 16, 0x10
[  104.586212] smiapp 1-0010: 0x0002120a "scaler_n_max" = 16, 0x10
[  104.588195] smiapp 1-0010: 0x0002120c "spatial_sampling_capability" = 3, 0x3
[  104.588775] smiapp 1-0010: 0x0001120e "digital_crop_capability" = 1, 0x1
[  104.589202] smiapp 1-0010: 0x00021300 "compression_capability" = 1, 0x1
[  104.589630] smiapp 1-0010: 0x00011502 "fifo_support_capability" = 1, 0x1
[  104.590057] smiapp 1-0010: 0x00011600 "dphy_ctrl_capability" = 30, 0x1e
[  104.591125] smiapp 1-0010: 0x00011601 "csi_lane_mode_capability" = 3, 0x3
[  104.591552] smiapp 1-0010: 0x00011602 "csi_signalling_mode_capability" = 7, 0x7
[  104.592010] smiapp 1-0010: 0x00011603 "fast_standby_capability" = 1, 0x1
[  104.593170] smiapp 1-0010: 0x00011604 "cci_address_control_capability" = 1, 0x1
[  104.611785] smiapp 1-0010: 0x00041608 "max_per_lane_bitrate_1_lane_mode_mbps" = 65536000, 0x3e80000
[  104.612396] smiapp 1-0010: 0x0004160c "max_per_lane_bitrate_2_lane_mode_mbps" = 65536000, 0x3e80000
[  104.612976] smiapp 1-0010: 0x00041610 "max_per_lane_bitrate_3_lane_mode_mbps" = 0, 0x0
[  104.613555] smiapp 1-0010: 0x00041614 "max_per_lane_bitrate_4_lane_mode_mbps" = 0, 0x0
[  104.614105] smiapp 1-0010: 0x00011618 "temp_sensor_capability" = 0, 0x0
[  104.614624] smiapp 1-0010: 0x00021700 "min_frame_length_lines_bin" = 192, 0xc0
[  104.615142] smiapp 1-0010: 0x00021702 "max_frame_length_lines_bin" = 65535, 0xffff
[  104.615661] smiapp 1-0010: 0x00021704 "min_line_length_pck_bin" = 1104, 0x450
[  104.618011] smiapp 1-0010: 0x00021706 "max_line_length_pck_bin" = 16382, 0x3ffe
[  104.618652] smiapp 1-0010: 0x00021708 "min_line_blanking_pck_bin" = 200, 0xc8
[  104.619171] smiapp 1-0010: 0x0002170a "fine_integration_time_min_bin" = 0, 0x0
[  104.619689] smiapp 1-0010: 0x0002170c "fine_integration_time_max_margin_bin" = 0, 0x0
[  104.620239] smiapp 1-0010: 0x00011710 "binning_capability" = 1, 0x1
[  104.620758] smiapp 1-0010: 0x00011711 "binning_weighting_capability" = 5, 0x5
[  104.621276] smiapp 1-0010: 0x00011800 "data_transfer_if_capability" = 13, 0xd
[  104.621795] smiapp 1-0010: 0x00011900 "shading_correction_capability" = 0, 0x0
[  104.622344] smiapp 1-0010: 0x00011901 "green_imbalance_capability" = 0, 0x0
[  104.622863] smiapp 1-0010: 0x00011902 "black_level_capability" = 0, 0x0
[  104.623382] smiapp 1-0010: 0x00011903 "module_specific_correction_capability" = 0, 0x0
[  104.623901] smiapp 1-0010: 0x00021904 "defect_correction_capability" = 865, 0x361
[  104.624450] smiapp 1-0010: 0x00021906 "defect_correction_capability_2" = 0, 0x0
[  104.624969] smiapp 1-0010: 0x00011980 "edof_capability" = 0, 0x0
[  104.625488] smiapp 1-0010: 0x00011987 "colour_feedback_capability" = 0, 0x0
[  104.626007] smiapp 1-0010: 0x000119c0 "estimation_mode_capability" = 0, 0x0
[  104.628265] smiapp 1-0010: 0x000119c1 "estimation_zone_capability" = 0, 0x0
[  104.628814] smiapp 1-0010: 0x00021a00 "capability_trdy_min" = 0, 0x0
[  104.629333] smiapp 1-0010: 0x00011a02 "flash_mode_capability" = 3, 0x3
[  104.629852] smiapp 1-0010: 0x00011b04 "actuator_capability" = 4, 0x4
[  104.630340] smiapp 1-0010: 0x00011c00 "bracketing_lut_capability_1" = 3, 0x3
[  104.630859] smiapp 1-0010: 0x00011c01 "bracketing_lut_capability_2" = 0, 0x0
[  104.631378] smiapp 1-0010: 0x00020088 "analogue_gain_code_step" = 1, 0x1
[  104.632324] smiapp 1-0010: format_model_type 2 byte
[  104.632843] smiapp 1-0010: 0x00020042 visible pixels: 3576 columns (pixelcode 5)
[  104.633361] smiapp 1-0010: 0x00020044 embedded pixels: 2 rows (pixelcode 1)
[  104.633880] smiapp 1-0010: 0x00020046 visible pixels: 2464 rows (pixelcode 5)
[  104.633972] smiapp 1-0010: embedded data from lines 0 to 2
[  104.634033] smiapp 1-0010: image data starts at line 2
[  104.634094] smiapp 1-0010: quirk: 0x00020084 "analogue_gain_code_min" = 59, 0x3b
[  104.634185] smiapp 1-0010: quirk: 0x00020086 "analogue_gain_code_max" = 6000, 0x1770
[  104.635162] smiapp 1-0010: binning 2x1
[  104.635650] smiapp 1-0010: binning 3x1
[  104.636138] smiapp 1-0010: binning 4x1
[  104.638305] smiapp 1-0010: binning 5x1
[  104.638824] smiapp 1-0010: binning 6x1
[  104.639312] smiapp 1-0010: binning 7x1
[  104.639801] smiapp 1-0010: binning 8x1
[  104.640289] smiapp 1-0010: binning 1x2
[  104.640777] smiapp 1-0010: binning 2x2
[  104.641296] smiapp 1-0010: binning 3x2
[  104.641784] smiapp 1-0010: binning 4x2
[  104.642272] smiapp 1-0010: binning 5x2
[  104.642791] smiapp 1-0010: binning 6x2
[  104.643280] smiapp 1-0010: binning 7x2
[  104.643768] smiapp 1-0010: binning 8x2
[  104.644073] smiapp 1-0010: profile 2
[  104.645080] smiapp 1-0010: data_format_model_type 1
[  104.645599] smiapp 1-0010: pixel order 0 (GRBG)
[  104.646118] smiapp 1-0010: 0: bpp 8, compressed 8
[  104.647705] smiapp 1-0010: jolly good! 20
[  104.648284] smiapp 1-0010: 1: bpp 10, compressed 10
[  104.648345] smiapp 1-0010: jolly good! 12
[  104.648864] smiapp 1-0010: 2: bpp 10, compressed 8
[  104.648925] smiapp 1-0010: jolly good! 16
[  104.649414] smiapp 1-0010: 3: bpp 10, compressed 6
[  104.649902] smiapp 1-0010: 4: bpp 0, compressed 0
[  104.650421] smiapp 1-0010: 5: bpp 0, compressed 0
[  104.650909] smiapp 1-0010: 6: bpp 0, compressed 0
[  104.651397] smiapp 1-0010: 7: bpp 0, compressed 0
[  104.651519] smiapp 1-0010: link freq 199200000 Hz, bpp 10 ok
[  104.651580] smiapp 1-0010: link freq 210000000 Hz, bpp 10 ok
[  104.651672] smiapp 1-0010: link freq 499200000 Hz, bpp 10 ok
[  104.651733] smiapp 1-0010: link freq 199200000 Hz, bpp 8 ok
[  104.651824] smiapp 1-0010: link freq 210000000 Hz, bpp 8 ok
[  104.651885] smiapp 1-0010: link freq 499200000 Hz, bpp 8 ok
[  104.651947] smiapp 1-0010: link freq 199200000 Hz, bpp 8 ok
[  104.652038] smiapp 1-0010: link freq 210000000 Hz, bpp 8 ok
[  104.652099] smiapp 1-0010: link freq 499200000 Hz, bpp 8 ok
[  104.652160] smiapp 1-0010: flip 0
[  104.652221] smiapp 1-0010: new pixel order GRBG
[  104.653167] smiapp 1-0010: 0x00021700 "min_frame_length_lines_bin" = 192, 0xc0
[  104.653717] smiapp 1-0010: 0x00021702 "max_frame_length_lines_bin" = 65535, 0xffff
[  104.654235] smiapp 1-0010: 0x00021704 "min_line_length_pck_bin" = 1104, 0x450
[  104.654754] smiapp 1-0010: 0x00021706 "max_line_length_pck_bin" = 16382, 0x3ffe
[  104.655303] smiapp 1-0010: 0x00021708 "min_line_blanking_pck_bin" = 200, 0xc8
[  104.655792] smiapp 1-0010: 0x0002170a "fine_integration_time_min_bin" = 0, 0x0
[  104.658355] smiapp 1-0010: 0x0002170c "fine_integration_time_max_margin_bin" = 0, 0x0
[  104.659240] smiapp 1-0010: vblank		40
[  104.659332] smiapp 1-0010: hblank		200
[  104.659362] smiapp 1-0010: real timeperframe	100/837
[  104.662078] omap3isp 480bc000.isp: media_gobj_destroy id 98: interface link id 97 ==> id 8
[  104.662231] omap3isp 480bc000.isp: media_gobj_destroy id 52: data link id 10 ==> id 12
[  104.662322] omap3isp 480bc000.isp: media_gobj_destroy id 51: data link id 10 ==> id 12
[  104.662414] omap3isp 480bc000.isp: media_gobj_destroy id 66: data link id 10 ==> id 16
[  104.662536] omap3isp 480bc000.isp: media_gobj_destroy id 65: data link id 10 ==> id 16
[  104.662628] omap3isp 480bc000.isp: media_gobj_destroy id 9: sink pad 'OMAP3 ISP CSI2a':0
[  104.662719] omap3isp 480bc000.isp: media_gobj_destroy id 10: source pad 'OMAP3 ISP CSI2a':1
[  104.662811] omap3isp 480bc000.isp: media_gobj_destroy id 8: entity 'OMAP3 ISP CSI2a'
[  104.673797] omap3isp 480bc000.isp: media_gobj_destroy id 97: intf_devnode v4l-subdev - major: 81, minor: 8
[  104.675140] omap3isp 480bc000.isp: media_gobj_destroy id 14: interface link id 13 ==> id 11
[  104.675262] omap3isp 480bc000.isp: media_gobj_destroy id 13: intf_devnode v4l-video - major: 81, minor: 1
[  104.675384] omap3isp 480bc000.isp: media_gobj_destroy id 12: sink pad 'OMAP3 ISP CSI2a output':0
[  104.675506] omap3isp 480bc000.isp: media_gobj_destroy id 11: entity 'OMAP3 ISP CSI2a output'
[  104.675628] omap3isp 480bc000.isp: media_gobj_destroy id 96: interface link id 95 ==> id 1
[  104.675720] omap3isp 480bc000.isp: media_gobj_destroy id 53: data link id 5 ==> id 2
[  104.675811] omap3isp 480bc000.isp: media_gobj_destroy id 54: data link id 5 ==> id 2
[  104.675933] omap3isp 480bc000.isp: media_gobj_destroy id 68: data link id 3 ==> id 16
[  104.676025] omap3isp 480bc000.isp: media_gobj_destroy id 67: data link id 3 ==> id 16
[  104.676116] omap3isp 480bc000.isp: media_gobj_destroy id 2: sink pad 'OMAP3 ISP CCP2':0
[  104.690277] omap3isp 480bc000.isp: media_gobj_destroy id 3: source pad 'OMAP3 ISP CCP2':1
[  104.690429] omap3isp 480bc000.isp: media_gobj_destroy id 1: entity 'OMAP3 ISP CCP2'
[  104.691741] omap3isp 480bc000.isp: media_gobj_destroy id 95: intf_devnode v4l-subdev - major: 81, minor: 7
[  104.697937] omap3isp 480bc000.isp: media_gobj_destroy id 7: interface link id 6 ==> id 4
[  104.698089] omap3isp 480bc000.isp: media_gobj_destroy id 6: intf_devnode v4l-video - major: 81, minor: 0
[  104.698211] omap3isp 480bc000.isp: media_gobj_destroy id 5: source pad 'OMAP3 ISP CCP2 input':0
[  104.698303] omap3isp 480bc000.isp: media_gobj_destroy id 4: entity 'OMAP3 ISP CCP2 input'
[  104.698425] omap3isp 480bc000.isp: media_gobj_destroy id 100: interface link id 99 ==> id 15
[  104.698547] omap3isp 480bc000.isp: media_gobj_destroy id 56: data link id 17 ==> id 20
[  104.698638] omap3isp 480bc000.isp: media_gobj_destroy id 55: data link id 17 ==> id 20
[  104.698852] omap3isp 480bc000.isp: media_gobj_destroy id 70: data link id 18 ==> id 24
[  104.698974] omap3isp 480bc000.isp: media_gobj_destroy id 69: data link id 18 ==> id 24
[  104.699066] omap3isp 480bc000.isp: media_gobj_destroy id 72: data link id 17 ==> id 35
[  104.699188] omap3isp 480bc000.isp: media_gobj_destroy id 71: data link id 17 ==> id 35
[  104.699279] omap3isp 480bc000.isp: media_gobj_destroy id 76: data link id 18 ==> id 46
[  104.699371] omap3isp 480bc000.isp: media_gobj_destroy id 75: data link id 18 ==> id 46
[  104.699462] omap3isp 480bc000.isp: media_gobj_destroy id 78: data link id 18 ==> id 48
[  104.699584] omap3isp 480bc000.isp: media_gobj_destroy id 77: data link id 18 ==> id 48
[  104.699676] omap3isp 480bc000.isp: media_gobj_destroy id 80: data link id 18 ==> id 50
[  104.699768] omap3isp 480bc000.isp: media_gobj_destroy id 79: data link id 18 ==> id 50
[  104.699859] omap3isp 480bc000.isp: media_gobj_destroy id 16: sink pad 'OMAP3 ISP CCDC':0
[  104.699981] omap3isp 480bc000.isp: media_gobj_destroy id 17: source pad 'OMAP3 ISP CCDC':1
[  104.700073] omap3isp 480bc000.isp: media_gobj_destroy id 18: source pad 'OMAP3 ISP CCDC':2
[  104.700164] omap3isp 480bc000.isp: media_gobj_destroy id 15: entity 'OMAP3 ISP CCDC'
[  104.709045] omap3isp 480bc000.isp: media_gobj_destroy id 99: intf_devnode v4l-subdev - major: 81, minor: 9
[  104.727142] omap3isp 480bc000.isp: media_gobj_destroy id 22: interface link id 21 ==> id 19
[  104.727294] omap3isp 480bc000.isp: media_gobj_destroy id 21: intf_devnode v4l-video - major: 81, minor: 2
[  104.727416] omap3isp 480bc000.isp: media_gobj_destroy id 20: sink pad 'OMAP3 ISP CCDC output':0
[  104.727539] omap3isp 480bc000.isp: media_gobj_destroy id 19: entity 'OMAP3 ISP CCDC output'
[  104.727661] omap3isp 480bc000.isp: media_gobj_destroy id 102: interface link id 101 ==> id 23
[  104.727752] omap3isp 480bc000.isp: media_gobj_destroy id 57: data link id 27 ==> id 24
[  104.727844] omap3isp 480bc000.isp: media_gobj_destroy id 58: data link id 27 ==> id 24
[  104.727966] omap3isp 480bc000.isp: media_gobj_destroy id 60: data link id 25 ==> id 31
[  104.728057] omap3isp 480bc000.isp: media_gobj_destroy id 59: data link id 25 ==> id 31
[  104.728149] omap3isp 480bc000.isp: media_gobj_destroy id 74: data link id 25 ==> id 35
[  104.728271] omap3isp 480bc000.isp: media_gobj_destroy id 73: data link id 25 ==> id 35
[  104.728363] omap3isp 480bc000.isp: media_gobj_destroy id 24: sink pad 'OMAP3 ISP preview':0
[  104.728454] omap3isp 480bc000.isp: media_gobj_destroy id 25: source pad 'OMAP3 ISP preview':1
[  104.728546] omap3isp 480bc000.isp: media_gobj_destroy id 23: entity 'OMAP3 ISP preview'
[  104.738616] omap3isp 480bc000.isp: media_gobj_destroy id 101: intf_devnode v4l-subdev - major: 81, minor: 10
[  104.743835] omap3isp 480bc000.isp: media_gobj_destroy id 29: interface link id 28 ==> id 26
[  104.743957] omap3isp 480bc000.isp: media_gobj_destroy id 28: intf_devnode v4l-video - major: 81, minor: 3
[  104.744079] omap3isp 480bc000.isp: media_gobj_destroy id 27: source pad 'OMAP3 ISP preview input':0
[  104.744201] omap3isp 480bc000.isp: media_gobj_destroy id 26: entity 'OMAP3 ISP preview input'
[  104.748077] omap3isp 480bc000.isp: media_gobj_destroy id 33: interface link id 32 ==> id 30
[  104.748199] omap3isp 480bc000.isp: media_gobj_destroy id 32: intf_devnode v4l-video - major: 81, minor: 4
[  104.748321] omap3isp 480bc000.isp: media_gobj_destroy id 31: sink pad 'OMAP3 ISP preview output':0
[  104.748413] omap3isp 480bc000.isp: media_gobj_destroy id 30: entity 'OMAP3 ISP preview output'
[  104.748535] omap3isp 480bc000.isp: media_gobj_destroy id 104: interface link id 103 ==> id 34
[  104.748657] omap3isp 480bc000.isp: media_gobj_destroy id 61: data link id 38 ==> id 35
[  104.748748] omap3isp 480bc000.isp: media_gobj_destroy id 62: data link id 38 ==> id 35
[  104.748840] omap3isp 480bc000.isp: media_gobj_destroy id 64: data link id 36 ==> id 42
[  104.748962] omap3isp 480bc000.isp: media_gobj_destroy id 63: data link id 36 ==> id 42
[  104.749053] omap3isp 480bc000.isp: media_gobj_destroy id 35: sink pad 'OMAP3 ISP resizer':0
[  104.749145] omap3isp 480bc000.isp: media_gobj_destroy id 36: source pad 'OMAP3 ISP resizer':1
[  104.749237] omap3isp 480bc000.isp: media_gobj_destroy id 34: entity 'OMAP3 ISP resizer'
[  104.760467] omap3isp 480bc000.isp: media_gobj_destroy id 103: intf_devnode v4l-subdev - major: 81, minor: 11
[  104.787139] omap3isp 480bc000.isp: media_gobj_destroy id 40: interface link id 39 ==> id 37
[  104.787292] omap3isp 480bc000.isp: media_gobj_destroy id 39: intf_devnode v4l-video - major: 81, minor: 5
[  104.787414] omap3isp 480bc000.isp: media_gobj_destroy id 38: source pad 'OMAP3 ISP resizer input':0
[  104.787506] omap3isp 480bc000.isp: media_gobj_destroy id 37: entity 'OMAP3 ISP resizer input'
[  104.794677] omap3isp 480bc000.isp: media_gobj_destroy id 44: interface link id 43 ==> id 41
[  104.794830] omap3isp 480bc000.isp: media_gobj_destroy id 43: intf_devnode v4l-video - major: 81, minor: 6
[  104.794952] omap3isp 480bc000.isp: media_gobj_destroy id 42: sink pad 'OMAP3 ISP resizer output':0
[  104.795074] omap3isp 480bc000.isp: media_gobj_destroy id 41: entity 'OMAP3 ISP resizer output'
[  104.795196] omap3isp 480bc000.isp: media_gobj_destroy id 106: interface link id 105 ==> id 45
[  104.795288] omap3isp 480bc000.isp: media_gobj_destroy id 46: sink pad 'OMAP3 ISP AEWB':0
[  104.795379] omap3isp 480bc000.isp: media_gobj_destroy id 45: entity 'OMAP3 ISP AEWB'
[  104.798339] omap3isp 480bc000.isp: media_gobj_destroy id 105: intf_devnode v4l-subdev - major: 81, minor: 12
[  104.798492] omap3isp 480bc000.isp: media_gobj_destroy id 108: interface link id 107 ==> id 47
[  104.798583] omap3isp 480bc000.isp: media_gobj_destroy id 48: sink pad 'OMAP3 ISP AF':0
[  104.798706] omap3isp 480bc000.isp: media_gobj_destroy id 47: entity 'OMAP3 ISP AF'
[  104.808898] omap3isp 480bc000.isp: media_gobj_destroy id 107: intf_devnode v4l-subdev - major: 81, minor: 13
[  104.809082] omap3isp 480bc000.isp: media_gobj_destroy id 110: interface link id 109 ==> id 49
[  104.809204] omap3isp 480bc000.isp: media_gobj_destroy id 50: sink pad 'OMAP3 ISP histogram':0
[  104.809295] omap3isp 480bc000.isp: media_gobj_destroy id 49: entity 'OMAP3 ISP histogram'
[  104.827026] omap3isp 480bc000.isp: media_gobj_destroy id 109: intf_devnode v4l-subdev - major: 81, minor: 14
[  104.827270] omap3isp 480bc000.isp: Media device unregistered
[  104.850616] omap3isp 480bc000.isp: OMAP3 ISP AEWB: all buffers were freed.
[  104.850738] omap3isp 480bc000.isp: OMAP3 ISP AF: all buffers were freed.
[  104.850830] omap3isp 480bc000.isp: OMAP3 ISP histogram: all buffers were freed.
[  104.852722] clk_unregister: unregistering prepared clock: cam_xclka
[  104.853302] iommu: Removing device 480bc000.isp from group 0
[  105.756408] Unable to handle kernel NULL pointer dereference at virtual address 00000140
[  105.756561] pgd = eda94000
[  105.756591] [00000140] *pgd=adaf8831, *pte=00000000, *ppte=00000000
[  105.756683] Internal error: Oops: 17 [#1] PREEMPT ARM
[  105.756744] Modules linked in: smiapp smiapp_pll omap3_isp videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core v4l2_common videodev media
[  105.756927] CPU: 0 PID: 2276 Comm: media-ctl Not tainted 4.9.0-rc6-00494-g9244e38-dirty #830
[  105.757019] Hardware name: Generic OMAP36xx (Flattened Device Tree)
[  105.757080] task: ed970380 task.stack: eda5e000
[  105.757141] PC is at __lock_acquire+0x94/0x1868
[  105.757202] LR is at lock_acquire+0x70/0x90
[  105.757263] pc : [<c015e9a8>]    lr : [<c01601ec>]    psr: 20000093
               sp : eda5fcc0  ip : eda5e000  fp : 00000000
[  105.757354] r10: 00000001  r9 : 00000000  r8 : 0002715c
[  105.757415] r7 : 00000140  r6 : 00000001  r5 : 60000013  r4 : ed970380
[  105.757476] r3 : 00000001  r2 : 00000001  r1 : 00000000  r0 : 00000140
[  105.757537] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  105.757629] Control: 10c5387d  Table: ada94019  DAC: 00000051
[  105.757690] Process media-ctl (pid: 2276, stack limit = 0xeda5e208)
[  105.757751] Stack: (0xeda5fcc0 to 0xeda60000)
[  105.757812] fcc0: ed970868 00000001 a409df10 c355d08b c0c75714 c01602f4 60000013 00000001
[  105.757904] fce0: ee1c9514 c0839b48 ee1c9518 effed360 ed970868 60000013 c0833e74 c0839b48
[  105.757995] fd00: effed360 effed360 c0e9166c ee1c951c ee1c9518 00000000 60000013 00000001
[  105.758087] fd20: 00000000 0002715c eda5e000 00000000 00000000 c01601ec 00000001 00000000
[  105.758178] fd40: 00000000 bf000e78 00000000 00000000 0000010c bf000e78 ed970380 c04ed214
[  105.758270] fd60: 00000001 00000000 bf000e78 c015aa50 ed9703b0 ed9703b0 c0830d50 00000000
[  105.758361] fd80: ed970848 c0830d60 ed970380 ed970380 c0830d60 c01602f4 c0e76744 00000051
[  105.758483] fda0: eda5fdd0 00000000 0002715c eda5fdd0 bf002e28 c1007c01 00000000 0002715c
[  105.758575] fdc0: eda5e000 00000000 00000000 bf000e78 00000001 50414d4f 53492033 43432050
[  105.758666] fde0: 00003250 00000000 00000000 00000000 00000000 00020000 00000000 00000000
[  105.758758] fe00: 00000000 00010002 00000000 00000000 00000000 00000000 00000051 00000007
[  105.758850] fe20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.758941] fe40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759033] fe60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759124] fe80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759216] fea0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  105.759307] fec0: 00000000 00000000 00000000 00000000 ed967c80 bf000ddc ed967c80 0002715c
[  105.759399] fee0: c1007c01 00000003 00000000 bf001808 0002715c ed967c80 00000003 ed9fece0
[  105.759490] ff00: 00000003 c01ea4c4 0002715c c01eb4a8 00000000 00000000 c01fba18 ffffffff
[  105.759582] ff20: 00000001 00000000 ee84f010 ed89e440 00000000 ee2654e8 00000010 c01dacdc
[  105.759674] ff40: 00000000 00000000 00000000 ed89e538 ed8a2b50 ed9707a0 ed970380 00000000
[  105.759765] ff60: eda5ff7c eda5ff84 ed967c80 ed967c80 0002715c c1007c01 00000003 eda5e000
[  105.759857] ff80: 00000000 c01eb560 0002715c 00027008 00000000 00000036 c0107d84 eda5e000
[  105.759948] ffa0: 00000000 c0107be0 0002715c 00027008 00000003 c1007c01 0002715c 80000000
[  105.760070] ffc0: 0002715c 00027008 00000000 00000036 00027158 00000000 b6f71000 00000000
[  105.760162] ffe0: 00026b08 be9cf85c 000126a4 b6eaaa5c 20000010 00000003 fda7fddf fdbdffba
[  105.760253] [<c015e9a8>] (__lock_acquire) from [<c01601ec>] (lock_acquire+0x70/0x90)
[  105.760375] [<c01601ec>] (lock_acquire) from [<c04ed214>] (mutex_lock_nested+0x54/0x3f4)
[  105.760528] [<c04ed214>] (mutex_lock_nested) from [<bf000e78>] (media_device_ioctl+0x9c/0x120 [media])
[  105.760681] [<bf000e78>] (media_device_ioctl [media]) from [<bf001808>] (media_ioctl+0x54/0x60 [media])
[  105.760803] [<bf001808>] (media_ioctl [media]) from [<c01ea4c4>] (vfs_ioctl+0x18/0x30)
[  105.760894] [<c01ea4c4>] (vfs_ioctl) from [<c01eb4a8>] (do_vfs_ioctl+0x90c/0x974)
[  105.760986] [<c01eb4a8>] (do_vfs_ioctl) from [<c01eb560>] (SyS_ioctl+0x50/0x6c)
[  105.761108] [<c01eb560>] (SyS_ioctl) from [<c0107be0>] (ret_fast_syscall+0x0/0x1c)
[  105.761199] Code: e59f3f58 e593300c e3530000 0a000003 (e5972000) 
[  105.761260] ---[ end trace bdb47e9a97e34f03 ]---
[  105.761322] note: media-ctl[2276] exited with preempt_count 1
[  105.762145] media: media_release: Media Release
[  105.762237] platform 480bc000.isp: Media device released
[  105.762298] media: media_devnode_release: Media Devnode Deallocated
[  106.076416] ------------[ cut here ]------------
[  106.076538] WARNING: CPU: 0 PID: 56 at drivers/clk/clk.c:2664 clk_core_disable+0x9c/0xb0
[  106.076599] Modules linked in: smiapp smiapp_pll omap3_isp videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core v4l2_common videodev media
[  106.076812] CPU: 0 PID: 56 Comm: kworker/0:1 Tainted: G      D         4.9.0-rc6-00494-g9244e38-dirty #830
[  106.076904] Hardware name: Generic OMAP36xx (Flattened Device Tree)
[  106.076995] Workqueue: pm pm_runtime_work
[  106.077087] [<c010dc8c>] (unwind_backtrace) from [<c010b6a0>] (show_stack+0x10/0x14)
[  106.077178] [<c010b6a0>] (show_stack) from [<c012a564>] (__warn+0xc8/0xf4)
[  106.077270] [<c012a564>] (__warn) from [<c012a5ac>] (warn_slowpath_null+0x1c/0x20)
[  106.077362] [<c012a5ac>] (warn_slowpath_null) from [<c02fb0ec>] (clk_core_disable+0x9c/0xb0)
[  106.077453] [<c02fb0ec>] (clk_core_disable) from [<c02fb704>] (clk_core_disable_lock+0x18/0x24)
[  106.077606] [<c02fb704>] (clk_core_disable_lock) from [<bf09296c>] (smiapp_power_off+0x44/0x70 [smiapp])
[  106.077728] [<bf09296c>] (smiapp_power_off [smiapp]) from [<c034b020>] (__rpm_callback+0x30/0x58)
[  106.077819] [<c034b020>] (__rpm_callback) from [<c034b0b4>] (rpm_callback+0x6c/0x7c)
[  106.077911] [<c034b0b4>] (rpm_callback) from [<c034b658>] (rpm_suspend+0x264/0x48c)
[  106.078033] [<c034b658>] (rpm_suspend) from [<c034c728>] (pm_runtime_work+0x7c/0x98)
[  106.078124] [<c034c728>] (pm_runtime_work) from [<c0142f90>] (process_one_work+0x214/0x43c)
[  106.078216] [<c0142f90>] (process_one_work) from [<c0143590>] (worker_thread+0x3d8/0x52c)
[  106.078308] [<c0143590>] (worker_thread) from [<c0148924>] (kthread+0xdc/0xe8)
[  106.078430] [<c0148924>] (kthread) from [<c0107c70>] (ret_from_fork+0x14/0x24)
[  106.078491] ---[ end trace bdb47e9a97e34f04 ]---
[  216.811340] systemd-logind[2167]: New session c4 of user sailus.
[  227.091491] systemd-logind[2167]: New session c5 of user sailus.
[  273.464019] systemd-logind[2167]: New session c6 of user sailus.
[  280.322326] systemd-logind[2167]: New session c7 of user sailus.
[  284.116516] systemd-logind[2167]: New session c8 of user sailus.

--gdTfX7fkYsEEjebm--
