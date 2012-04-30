Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:22374 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab2D3TYM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 15:24:12 -0400
Date: Mon, 30 Apr 2012 12:23:56 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jason Wu <jason.wu@frescologic.com>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	Hub Lin <hublin@frescologic.com>,
	Rex Luo <rex.luo@frescologic.com>, linux-media@vger.kernel.org
Subject: flusbfb: scheduling while atomic, was Re: dynamic ring expansion
 crashes when sending urb too fast
Message-ID: <20120430192356.GC7925@xanatos>
References: <CADNNHvXrER6WK45M_rrSjfFX0XoVzCTD9FtYm_3FSFM6bxcgpw@mail.gmail.com>
 <2A76B9D36150BE4293842BC2FE8FF1650DE417@SCYBEXDAG04.amd.com>
 <CADNNHvWSs6G7Ky1x4wMN27DvX0=_Gzj6fRbb7AC7kAeYn58sKg@mail.gmail.com>
 <CADNNHvV6X-R8BA-K8pWE-4vfGHdp22x6LMJ-gHGSCa2vRyEqrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADNNHvV6X-R8BA-K8pWE-4vfGHdp22x6LMJ-gHGSCa2vRyEqrA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jason,

That looks like a "scheduling while atomic" frame buffer driver bug.  I
don't think that's the xHCI driver's fault.  It looks like the flusbfb
driver did something (like allocate memory with the wrong flags) and the
process was swapped out.  I'm Ccing the Linux media list.  Maybe they
know about this driver bug.

Jason, I see that you're using the 3.4-rc4 kernel, but there are symbols
that I can't find in the 3.4-rc5 tree, like "fl_add_redraw_frame_count"
or "flusbfb".  Are you using an out-of-tree driver?

Also, is this a USB 3.0 device, or a USB 2.0 device under an xHCI host?
I have never seen a USB 3.0 VGA adapter before.

Sarah Sharp

On Mon, Apr 30, 2012 at 11:30:25AM +0800, Jason Wu wrote:
> Hi Andiry,
>     Here's the log we have collected after enable flag
> "CONFGI_USB_HCD_XHCI_DEBUGGING"
>     by the way, we are currently using bulk mode, if it makes the
> difference.
> 
> [   37.586317] ERROR no room on ep ring, try ring expansion
> [   37.591627] ring expansion succeed, now has 4 segments
> [   38.197849] BUG: scheduling while atomic: Xorg/757/0x00000100
> [   38.203602] Modules linked in: lockd flusbfb(O) iTCO_wdt
> iTCO_vendor_support ppdev parport_pc parport r8169 mii xhci_hcd uinput
> pcspkr i2c_i801 coretemp microcode sunrpc crc32c_intel nouveau ttm
> drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded:
> scsi_wait_scan]
> [   38.228297] Pid: 757, comm: Xorg Tainted: G           O 3.4.0-rc4 #4
> [   38.234661] Call Trace:
> [   38.237122]  [<c0832fe7>] ? printk+0x2d/0x2f
> 
>     Yes the ring did get expand, right after first time it expands, it just
> crashes.
>     append file is the full log of error message
> Thanks
> 
> 
> 
> 2012/4/28 Jason Wu <jason.wu@frescologic.com>
> 
> > Hi Andiry,
> >     1. We are doing usb to vga dongle, which is using usb3 to output frame.
> >     we are sending like 60 frames per seconds, which size is about 6MB
> > each frame.
> >
> >     2. How can I check if the ring get expanded? I know before the ring
> > expanded patch, it shows "xhci_hcd 0000:04:00.0: ERROR no room on ep ring",
> >         but on the new patch, it just crashes out.
> >
> >     3. ok sure thanks for reply, i will enable flag
> > "CONFGI_USB_HCD_XHCI_DEBUGGING " when i can, will update result to you asap.
> >
> > Thanks
> >
> >
> > 2012/4/27 Xu, Andiry <Andiry.Xu@amd.com>
> >
> >>  Hi Jason,
> >>
> >>
> >>
> >> Thanks for the report.
> >>
> >>
> >>
> >> When you mention "a lot of usb_submit_urb()", can you tell how many is "a
> >> lot"? do you see the ring get expanded? if so, how many times does it get
> >> expanded, and how many segments does it have?
> >>
> >>
> >>
> >> If possible, you can enable the CONFGI_USB_HCD_XHCI_DEBUGGING flag, it
> >> may provide more info.
> >>
> >>
> >>
> >> Thanks,
> >>
> >> Andiry
> >>
> >> ------------------------------
> >>
> >>  *From:* Jason Wu [jason.wu@frescologic.com]
> >> *Sent:* Friday, April 27, 2012 7:34 PM
> >> *To:* linux-usb@vger.kernel.org; Sarah Sharp; Xu, Andiry; Hub Lin; Rex
> >> Luo
> >> *Subject:* dynamic ring expansion crashes when sending urb too fast
> >>
> >>    We are currently working on USB3 to VGA dongle,
> >>  now we encountered some memory issue, when I type dmesg at background
> >>  found out that x-window is sending following message repeatly.
> >>  [  328.548981] xhci_hcd 0000:04:00.0: ERROR no room on ep ring
> >>
> >>  By the way, I modified following things to enlarge TRB rings numbers
> >>  and MAX size of kmalloc function.
> >>
> >>  xhci.h
> >>  #define TRBS_PER_SEGMENT        256
> >>
> >>  mmzone.h
> >>  #define MAX_ORDER 12
> >>
> >>  How can I solve the ERROR no room on ep rings problem?
> >>
> >>  ###############################################################
> >>
> >>  Also I have tried the dynamic allocate for 3.4.0-RC2
> >>  It crashes after during doing a lot of usb_submit_urb (updating video
> >> frames),
> >>  but the same thing is working fine on 3.3.2, except the "no room on ep
> >> ring" error.
> >>
> >>  Seems like before 3.4.0-RC2 dynamic TRB rings, it shows Error message,
> >>  after I apply those patches, it just crashes.
> >>
> >>  ###############################################################
> >>
> >>  here's the crash message we have collect, please take a look, Thanks!
> >>
> >>  [    0.000000] Initializing cgroup subsys cpuset
> >> [    0.000000] Initializing cgroup subsys cpu
> >> [    0.000000] Linux version 3.4.0-rc4 (fresco@ga-p61-fc16) (gcc version
> >> 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #1 SMP Fri Apr 27 18:09:51 CST 2012
> >> [    0.000000] BIOS-provided physical RAM map:
> >> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> >> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> >> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> >> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007efa0000 (usable)
> >> [    0.000000]  BIOS-e820: 000000007efa0000 - 000000007efa3000 (ACPI NVS)
> >> [    0.000000]  BIOS-e820: 000000007efa3000 - 000000007efe0000 (ACPI data)
> >> [    0.000000]  BIOS-e820: 000000007efe0000 - 000000007f000000 (reserved)
> >> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> >> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> >> [    0.000000] NX (Execute Disable) protection: active
> >> [    0.000000] DMI 2.4 present.
> >> [    0.000000] last_pfn = 0x7efa0 max_arch_pfn = 0x1000000
> >> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> >> 0x7010600070106
> >> [    0.000000] total RAM covered: 2040M
> >> [    0.000000] Found optimal setting for mtrr clean up
> >> [    0.000000]  gran_size: 64K  chunk_size: 16M         num_reg: 2
> >>  lose cover RAM: 0G
> >> [    0.000000] found SMP MP-table at [c00f5a10] f5a10
> >> [    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
> >> [    0.000000] RAMDISK: 28cca000 - 3065d000
> >> [    0.000000] ACPI: RSDP 000f71a0 00014 (v00 GBT   )
> >> [    0.000000] ACPI: RSDT 7efa3040 0004C (v01 GBT    GBTUACPI 42302E31
> >> GBTU 01010101)
> >> [    0.000000] ACPI: FACP 7efa3100 00074 (v01 GBT    GBTUACPI 42302E31
> >> GBTU 01010101)
> >> [    0.000000] ACPI: DSDT 7efa31c0 04B37 (v01 GBT    GBTUACPI 00001000
> >> MSFT 04000000)
> >> [    0.000000] ACPI: FACS 7efa0000 00040
> >> [    0.000000] ACPI: MCFG 7efa7ec0 0003C (v01 GBT    GBTUACPI 42302E31
> >> GBTU 01010101)
> >> [    0.000000] ACPI: ASPT 7efa7f00 00034 (v07 GBT    PerfTune 312E3042
> >> UTBG 01010101)
> >> [    0.000000] ACPI: SSPT 7efa7f40 02328 (v01 GBT    SsptHead 312E3042
> >> UTBG 01010101)
> >> [    0.000000] ACPI: EUDS 7efaa270 000C0 (v01 GBT             00000000
> >>    00000000)
> >> [    0.000000] ACPI: MATS 7efaa330 00034 (v01 GBT             00000000
> >>    00000000)
> >> [    0.000000] ACPI: TAMG 7efaa390 0083A (v01 GBT    GBT   B0 5455312E
> >> BG?? 45240101)
> >> [    0.000000] ACPI: APIC 7efa7d40 000BC (v01 GBT    GBTUACPI 42302E31
> >> GBTU 01010101)
> >> [    0.000000] ACPI: SSDT 7efaac00 01DC0 (v01  INTEL PPM RCM  80000001
> >> INTL 20061109)
> >> [    0.000000] ACPI: MATS 7efac9c0 0A39F (v01        MATS RCM 80000001
> >> INTL 20061109)
> >> [    0.000000] 1145MB HIGHMEM available.
> >> [    0.000000] 885MB LOWMEM available.
> >> [    0.000000]   mapped low ram: 0 - 375fe000
> >> [    0.000000]   low ram: 0 - 375fe000
> >> [    0.000000] Zone PFN ranges:
> >> [    0.000000]   DMA      0x00000010 -> 0x00001000
> >> [    0.000000]   Normal   0x00001000 -> 0x000375fe
> >> [    0.000000]   HighMem  0x000375fe -> 0x0007efa0
> >> [    0.000000] Movable zone start PFN for each node
> >> [    0.000000] Early memory PFN ranges
> >> [    0.000000]     0: 0x00000010 -> 0x0000009f
> >> [    0.000000]     0: 0x00000100 -> 0x0007efa0
> >> [    0.000000] Using APIC driver default
> >> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
> >> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
> >> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> >> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
> >> 0-23
> >> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> >> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> >> [    0.000000] Using ACPI (MADT) for SMP configuration information
> >> [    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
> >> [    0.000000] PM: Registered nosave memory: 000000000009f000 -
> >> 00000000000a0000
> >> [    0.000000] PM: Registered nosave memory: 00000000000a0000 -
> >> 00000000000f0000
> >> [    0.000000] PM: Registered nosave memory: 00000000000f0000 -
> >> 0000000000100000
> >> [    0.000000] Allocating PCI resources starting at 7f000000 (gap:
> >> 7f000000:71000000)
> >> [    0.000000] Booting paravirtualized kernel on bare hardware
> >> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8
> >> nr_node_ids:1
> >> [    0.000000] PERCPU: Embedded 14 pages/cpu @f6400000 s33216 r0 d24128
> >> u262144
> >> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> >>  Total pages: 515919
> >> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.4.0-rc4
> >> root=UUID=81a1176f-441f-4d71-948b-c2458a3586f0 ro rd.md=0 rd.lvm=0 rd.dm=0
> >> KEYTABLE=us SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=en_US.UTF-8
> >> console=ttyS0,115200
> >> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> >> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288
> >> bytes)
> >> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144
> >> bytes)
> >> [    0.000000] Initializing CPU#0
> >> [    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
> >> [    0.000000] allocated 4160640 bytes of page_cgroup
> >> [    0.000000] please try 'cgroup_disable=memory' option if you don't
> >> want memory cgroups
> >> [    0.000000] Initializing HighMem for node 0 (000375fe:0007efa0)
> >> [    0.000000] Memory: 1925372k/2080384k available (4355k kernel code,
> >> 154560k reserved, 2553k data, 604k init, 1173128k highmem)
> >> [    0.000000] virtual kernel memory layout:
> >> [    0.000000]     fixmap  : 0xffa96000 - 0xfffff000   (5540 kB)
> >> [    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
> >> [    0.000000]     vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
> >> [    0.000000]     lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
> >> [    0.000000]       .init : 0xc0ac0000 - 0xc0b57000   ( 604 kB)
> >> [    0.000000]       .data : 0xc0840ce6 - 0xc0abf140   (2553 kB)
> >> [    0.000000]       .text : 0xc0400000 - 0xc0840ce6   (4355 kB)
> >> [    0.000000] Checking if this processor honours the WP bit even in
> >> supervisor mode...Ok.
> >> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
> >> CPUs=8, Nodes=1
> >> [    0.000000] Hierarchical RCU implementation.
> >> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> >> [    0.000000] NR_IRQS:2304 nr_irqs:744 16
> >> [    0.000000] Console: colour VGA+ 80x25
> >> [    0.000000] console [ttyS0] enabled
> >> [    0.001000] Fast TSC calibration using PIT
> >> [    0.002000] Detected 3093.154 MHz processor.
> >> [    0.000001] Calibrating delay loop (skipped), value calculated using
> >> timer frequency.. 6186.30 BogoMIPS (lpj=3093154)
> >> [    0.010624] pid_max: default: 32768 minimum: 301
> >> [    0.015260] Security Framework initialized
> >> [    0.019360] SELinux:  Initializing.
> >> [    0.022891] Mount-cache hash table entries: 512
> >> [    0.027568] Initializing cgroup subsys cpuacct
> >> [    0.032018] Initializing cgroup subsys memory
> >> [    0.036378] Initializing cgroup subsys devices
> >> [    0.040828] Initializing cgroup subsys freezer
> >> [    0.045274] Initializing cgroup subsys net_cls
> >> [    0.049718] Initializing cgroup subsys blkio
> >> [    0.053993] Initializing cgroup subsys perf_event
> >> [    0.058716] CPU: Physical Processor ID: 0
> >> [    0.062724] CPU: Processor Core ID: 0
> >> [    0.066392] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> >> [    0.066393] ENERGY_PERF_BIAS: View and update with
> >> x86_energy_perf_policy(8)
> >> [    0.079440] mce: CPU supports 7 MCE banks
> >> [    0.083457] CPU0: Thermal monitoring enabled (TM1)
> >> [    0.088243] CPU0: Core temperature above threshold, cpu clock
> >> throttled (total events = 1)
> >> [    0.096500] CPU0: Core temperature/speed normal
> >> [    0.101035] using mwait in idle threads.
> >> [    0.105354] ACPI: Core revision 20120320
> >> [    0.112220] ftrace: allocating 22341 entries in 44 pages
> >> [    0.127453] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> >> [    0.132850] CPU0: Package temperature above threshold, cpu clock
> >> throttled (total events = 1)
> >> [    0.141367] CPU0: Package temperature/speed normal
> >> [    0.146562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> >> [    0.162562] CPU0: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz stepping 07
> >> [    0.270548] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge
> >> events, Intel PMU driver.
> >> [    0.279241] PEBS disabled due to CPU errata.
> >> [    0.283513] ... version:                3
> >> [    0.287524] ... bit width:              48
> >> [    0.291615] ... generic registers:      4
> >> [    0.295627] ... value mask:             0000ffffffffffff
> >> [    0.300937] ... max period:             000000007fffffff
> >> [    0.306239] ... fixed-purpose events:   3
> >> [    0.310242] ... event mask:             000000070000000f
> >> [    0.315670] NMI watchdog: enabled, takes one hw-pmu counter.
> >> [    0.321389] Booting Node   0, Processors  #1
> >> [    0.335694] Initializing CPU#1
> >> [    0.341050] NMI watchdog: enabled, takes one hw-pmu counter.
> >> [    0.346767]  #2
> >> [    0.358667] Initializing CPU#2
> >> [    0.363989] NMI watchdog: enabled, takes one hw-pmu counter.
> >> [    0.369712]  #3
> >> [    0.381600] Initializing CPU#3
> >> [    0.386931] NMI watchdog: enabled, takes one hw-pmu counter.
> >> [    0.388171] CPU3: Package temperature above threshold, cpu clock
> >> throttled (total events = 1)
> >> [    0.389158] CPU3: Package temperature/speed normal
> >> [    0.405898] Brought up 4 CPUs
> >> [    0.408866] Total of 4 processors activated (24745.23 BogoMIPS).
> >> [    0.417829] devtmpfs: initialized
> >> [    0.421448] PM: Registering ACPI NVS region [mem
> >> 0x7efa0000-0x7efa2fff] (12288 bytes)
> >> [    0.429924] atomic64 test passed for i586+ platform with CX8 and with
> >> SSE
> >> [    0.436733] RTC time: 19:29:50, date: 04/27/12
> >> [    0.441207] NET: Registered protocol family 16
> >> [    0.445946] ACPI: bus type pci registered
> >> [    0.450001] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> >> 0xf0000000-0xf3ffffff] (base 0xf0000000)
> >> [    0.459294] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in
> >> E820
> >> [    0.466078] PCI: Using MMCONFIG for extended config space
> >> [    0.471468] PCI: Using configuration type 1 for base access
> >> [    0.477916] bio: create slab <bio-0> at 0
> >> [    0.481982] ACPI: Added _OSI(Module Device)
> >> [    0.486165] ACPI: Added _OSI(Processor Device)
> >> [    0.490608] ACPI: Added _OSI(3.0 _SCP Extensions)
> >> [    0.495314] ACPI: Added _OSI(Processor Aggregator Device)
> >> [    0.504748] ACPI: Interpreter enabled
> >> [    0.508425] ACPI: (supports S0 S1 S4 S5)
> >> [    0.512437] ACPI: Using IOAPIC for interrupt routing
> >> [    0.520051] ACPI: No dock devices found.
> >> [    0.523981] PCI: Using host bridge windows from ACPI; if necessary,
> >> use "pci=nocrs" and report a bug
> >> [    0.533140] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
> >> [    0.539357] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
> >> [    0.545968] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> >> [    0.552579] pci_root PNP0A03:00: host bridge window [mem
> >> 0x000a0000-0x000bffff]
> >> [    0.559883] pci_root PNP0A03:00: host bridge window [mem
> >> 0x000c0000-0x000dffff]
> >> [    0.567188] pci_root PNP0A03:00: host bridge window [mem
> >> 0x7f800000-0xfebfffff]
> >> [    0.574518] PCI host bridge to bus 0000:00
> >> [    0.578617] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> >> [    0.584793] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> >> [    0.590971] pci_bus 0000:00: root bus resource [mem
> >> 0x000a0000-0x000bffff]
> >> [    0.597833] pci_bus 0000:00: root bus resource [mem
> >> 0x000c0000-0x000dffff]
> >> [    0.604705] pci_bus 0000:00: root bus resource [mem
> >> 0x7f800000-0xfebfffff]
> >> [    0.614387] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> >> [    0.619657] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> >> [    0.626383] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> >> [    0.631869] pci 0000:00:1c.3: PCI bridge to [bus 04-05] (subtractive
> >> decode)
> >> [    0.639081] pci 0000:04:00.0: PCI bridge to [bus 05-05] (subtractive
> >> decode)
> >> [    0.648374] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
> >> [    0.655370] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
> >> [    0.660948]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> >> [    0.666606]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND),
> >> returned control mask: 0x1d
> >> [    0.675124] ACPI _OSC control for PCIe not granted, disabling ASPM
> >> [    0.685557] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11
> >> *12 14 15)
> >> [    0.693032] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11
> >> 12 14 15)
> >> [    0.700502] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11
> >> 12 14 15)
> >> [    0.707977] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11
> >> 12 14 15)
> >> [    0.715447] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12
> >> 14 15) *0, disabled.
> >> [    0.724069] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12
> >> 14 15) *0, disabled.
> >> [    0.732699] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12
> >> 14 15) *0, disabled.
> >> [    0.741330] ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11
> >> 12 14 15)
> >> [    0.748847] vgaarb: device added:
> >> PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> >> [    0.756928] vgaarb: loaded
> >> [    0.759637] vgaarb: bridge control possible 0000:01:00.0
> >> [    0.764994] SCSI subsystem initialized
> >> [    0.768798] usbcore: registered new interface driver usbfs
> >> [    0.774292] usbcore: registered new interface driver hub
> >> [    0.779617] usbcore: registered new device driver usb
> >> [    0.784700] PCI: Using ACPI for IRQ routing
> >> [    0.790389] NetLabel: Initializing
> >> [    0.793796] NetLabel:  domain hash size = 128
> >> [    0.798154] NetLabel:  protocols = UNLABELED CIPSOv4
> >> [    0.803123] NetLabel:  unlabeled traffic allowed by default
> >> [    0.813841] pnp: PnP ACPI init
> >> [    0.816905] ACPI: bus type pnp registered
> >> [    0.821127] system 00:01: [io  0x04d0-0x04d1] has been reserved
> >> [    0.827043] system 00:01: [io  0x0290-0x029f] has been reserved
> >> [    0.832963] system 00:01: [io  0x0800-0x087f] has been reserved
> >> [    0.838877] system 00:01: [io  0x0290-0x0294] has been reserved
> >> [    0.844795] system 00:01: [io  0x0880-0x088f] has been reserved
> >> [    0.851390] system 00:0a: [io  0x0400-0x04cf] has been reserved
> >> [    0.857310] system 00:0a: [io  0x04d2-0x04ff] has been reserved
> >> [    0.863266] system 00:0b: [io  0x1000-0x107f] has been reserved
> >> [    0.869179] system 00:0b: [io  0x1080-0x10ff] has been reserved
> >> [    0.875097] system 00:0b: [io  0x1100-0x117f] has been reserved
> >> [    0.881015] system 00:0b: [io  0x1180-0x11ff] has been reserved
> >> [    0.887085] system 00:0c: [io  0x0454-0x0457] has been reserved
> >> [    0.893043] system 00:0d: [mem 0xf0000000-0xf3ffffff] has been reserved
> >> [    0.899832] system 00:0e: [mem 0x000ce400-0x000cffff] has been reserved
> >> [    0.906436] system 00:0e: [mem 0x000f0000-0x000f7fff] could not be
> >> reserved
> >> [    0.913393] system 00:0e: [mem 0x000f8000-0x000fbfff] could not be
> >> reserved
> >> [    0.920352] system 00:0e: [mem 0x000fc000-0x000fffff] could not be
> >> reserved
> >> [    0.927309] system 00:0e: [mem 0x7efa0000-0x7efaffff] could not be
> >> reserved
> >> [    0.934267] system 00:0e: [mem 0x00000000-0x0009ffff] could not be
> >> reserved
> >> [    0.941225] system 00:0e: [mem 0x00100000-0x7ef9ffff] could not be
> >> reserved
> >> [    0.948183] system 00:0e: [mem 0x7efb0000-0x7efcffff] could not be
> >> reserved
> >> [    0.955141] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be
> >> reserved
> >> [    0.962098] system 00:0e: [mem 0xfed10000-0xfed1dfff] has been reserved
> >> [    0.968708] system 00:0e: [mem 0xfed20000-0xfed8ffff] has been reserved
> >> [    0.975311] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
> >> [    0.981922] system 00:0e: [mem 0xffb00000-0xffb7ffff] has been reserved
> >> [    0.988533] system 00:0e: [mem 0xfff00000-0xffffffff] has been reserved
> >> [    0.995137] system 00:0e: [mem 0x000e0000-0x000effff] has been reserved
> >> [    1.001749] system 00:0e: [mem 0x20000000-0x201fffff] could not be
> >> reserved
> >> [    1.008707] system 00:0e: [mem 0x40000000-0x400fffff] could not be
> >> reserved
> >> [    1.015665] system 00:0e: [mem 0x7f000000-0x7f7fffff] could not be
> >> reserved
> >> [    1.022665] pnp: PnP ACPI: found 16 devices
> >> [    1.026849] ACPI: ACPI bus type pnp unregistered
> >> [    1.067284] Switching to clocksource acpi_pm
> >> [    1.071639] pci 0000:00:1c.0: BAR 14: assigned [mem
> >> 0x7f800000-0x7f9fffff]
> >> [    1.078517] pci 0000:00:1c.0: BAR 15: assigned [mem
> >> 0x7fa00000-0x7fbfffff 64bit pref]
> >> [    1.086345] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
> >> [    1.092524] pci 0000:01:00.0: BAR 6: assigned [mem
> >> 0xf9000000-0xf901ffff pref]
> >> [    1.099740] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> >> [    1.104964] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
> >> [    1.111056] pci 0000:00:01.0:   bridge window [mem
> >> 0xf6000000-0xf9ffffff]
> >> [    1.117841] pci 0000:00:01.0:   bridge window [mem
> >> 0xe0000000-0xefffffff 64bit pref]
> >> [    1.125577] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> >> [    1.130805] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> >> [    1.136896] pci 0000:00:1c.0:   bridge window [mem
> >> 0x7f800000-0x7f9fffff]
> >> [    1.143681] pci 0000:00:1c.0:   bridge window [mem
> >> 0x7fa00000-0x7fbfffff 64bit pref]
> >> [    1.151421] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> >> [    1.156645] pci 0000:00:1c.1:   bridge window [mem
> >> 0xfbd00000-0xfbdfffff]
> >> [    1.163432] pci 0000:04:00.0: PCI bridge to [bus 05-05]
> >> [    1.168681] pci 0000:00:1c.3: PCI bridge to [bus 04-05]
> >> [    1.173919] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
> >> [    1.179145] pci 0000:00:1c.4:   bridge window [mem
> >> 0xfbc00000-0xfbcfffff]
> >> [    1.185933] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
> >> [    1.191160] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
> >> [    1.197257] pci 0000:00:1c.5:   bridge window [mem
> >> 0xfbe00000-0xfbefffff 64bit pref]
> >> [    1.205014] pci 0000:00:1c.0: enabling device (0000 -> 0003)
> >> [    1.210783] NET: Registered protocol family 2
> >> [    1.215176] IP route cache hash table entries: 32768 (order: 5, 131072
> >> bytes)
> >> [    1.222394] TCP established hash table entries: 131072 (order: 8,
> >> 1048576 bytes)
> >> [    1.229986] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> >> [    1.236691] TCP: Hash tables configured (established 131072 bind 65536)
> >> [    1.243306] TCP: reno registered
> >> [    1.246537] UDP hash table entries: 512 (order: 2, 16384 bytes)
> >> [    1.252458] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> >> [    1.258858] NET: Registered protocol family 1
> >> [    1.285738] Unpacking initramfs...
> >> [    4.078463] Freeing initrd memory: 124492k freed
> >> [    4.100285] apm: BIOS not found.
> >> [    4.103722] audit: initializing netlink socket (disabled)
> >> [    4.109130] type=2000 audit(1335554992.352:1): initialized
> >> [    4.133764] highmem bounce pool size: 64 pages
> >> [    4.138219] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> >> [    4.146022] VFS: Disk quotas dquot_6.5.2
> >> [    4.149986] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> >> [    4.156836] msgmni has been set to 1712
> >> [    4.161069] alg: No test for stdrng (krng)
> >> [    4.165178] NET: Registered protocol family 38
> >> [    4.169662] Block layer SCSI generic (bsg) driver version 0.4 loaded
> >> (major 253)
> >> [    4.177081] io scheduler noop registered
> >> [    4.181010] io scheduler deadline registered
> >> [    4.185284] io scheduler cfq registered (default)
> >> [    4.190260] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> >> [    4.195849] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> >> [    4.202464] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> >> [    4.209193] input: Power Button as
> >> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> >> [    4.217371] ACPI: Power Button [PWRB]
> >> [    4.221071] input: Power Button as
> >> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> >> [    4.228467] ACPI: Power Button [PWRF]
> >> [    4.232240] ACPI: Requesting acpi_cpufreq
> >> [    4.238498] GHES: HEST is not enabled!
> >> [    4.242262] isapnp: Scanning for PnP cards...
> >> [    4.604629] isapnp: No Plug & Play device found
> >> [    4.609229] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> >> [    4.636046] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >> [    4.662818] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >> [    4.668607] hpet_acpi_add: no address or irqs in _CRS
> >> [    4.673685] Non-volatile memory driver v1.3
> >> [    4.677870] Linux agpgart interface v0.103
> >> [    4.682586] loop: module loaded
> >> [    4.685789] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> >> [    4.842016] scsi0 : ata_piix
> >> [    4.844967] scsi1 : ata_piix
> >> [    4.848130] ata2: SATA max UDMA/133 cmd 0xff00 ctl 0xfe00 bmdma 0xfb00
> >> irq 19
> >> [    4.855265] ata3: SATA max UDMA/133 cmd 0xfd00 ctl 0xfc00 bmdma 0xfb08
> >> irq 19
> >> [    4.862406] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> >> [    4.867806] scsi2 : ata_piix
> >> [    4.870733] scsi3 : ata_piix
> >> [    4.873850] ata4: SATA max UDMA/133 cmd 0xf800 ctl 0xf700 bmdma 0xf400
> >> irq 19
> >> [    4.880979] ata5: SATA max UDMA/133 cmd 0xf600 ctl 0xf500 bmdma 0xf408
> >> irq 19
> >> [    4.888153] Fixed MDIO Bus: probed
> >> [    4.891608] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> >> [    4.898154] ehci_hcd 0000:00:1a.0: EHCI Host Controller
> >> [    4.903423] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
> >> bus number 1
> >> [    4.910828] ehci_hcd 0000:00:1a.0: debug port 2
> >> [    4.919254] ehci_hcd 0000:00:1a.0: irq 18, io mem 0xfbffe000
> >> [    4.930765] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> >> [    4.936528] usb usb1: New USB device found, idVendor=1d6b,
> >> idProduct=0002
> >> [    4.943313] usb usb1: New USB device strings: Mfr=3, Product=2,
> >> SerialNumber=1
> >> [    4.950530] usb usb1: Product: EHCI Host Controller
> >> [    4.955407] usb usb1: Manufacturer: Linux 3.4.0-rc4 ehci_hcd
> >> [    4.961064] usb usb1: SerialNumber: 0000:00:1a.0
> >> [    4.965770] hub 1-0:1.0: USB hub found
> >> [    4.969526] hub 1-0:1.0: 2 ports detected
> >> [    4.973587] ehci_hcd 0000:00:1d.0: EHCI Host Controller
> >> [    4.978848] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
> >> bus number 2
> >> [    4.986255] ehci_hcd 0000:00:1d.0: debug port 2
> >> [    4.994676] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfbffd000
> >> [    5.005748] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> >> [    5.011509] usb usb2: New USB device found, idVendor=1d6b,
> >> idProduct=0002
> >> [    5.018296] usb usb2: New USB device strings: Mfr=3, Product=2,
> >> SerialNumber=1
> >> [    5.025512] usb usb2: Product: EHCI Host Controller
> >> [    5.030392] usb usb2: Manufacturer: Linux 3.4.0-rc4 ehci_hcd
> >> [    5.036049] usb usb2: SerialNumber: 0000:00:1d.0
> >> [    5.040747] hub 2-0:1.0: USB hub found
> >> [    5.044500] hub 2-0:1.0: 2 ports detected
> >> [    5.048551] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> >> [    5.054739] uhci_hcd: USB Universal Host Controller Interface driver
> >> [    5.061114] usbcore: registered new interface driver usbserial
> >> [    5.066954] usbcore: registered new interface driver usbserial_generic
> >> [    5.073496] USB Serial support registered for generic
> >> [    5.078552] usbserial: USB Serial Driver core
> >> [    5.082939] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64
> >> irq 1
> >> [    5.089720] i8042: PNP: PS/2 appears to have AUX port disabled, if
> >> this is incorrect please boot with i8042.nopnp
> >> [    5.100109] serio: i8042 KBD port at 0x60,0x64 irq 1
> >> [    5.105079] Refined TSC clocksource calibration: 3092.974 MHz.
> >> [    5.108804] mousedev: PS/2 mouse device common for all mice
> >> [    5.108963] rtc_cmos 00:04: RTC can wake from S4
> >> [    5.109132] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> >> [    5.109164] rtc0: alarms up to one month, 242 bytes nvram
> >> [    5.109212] device-mapper: uevent: version 1.0.3
> >> [    5.109274] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
> >> initialised: dm-devel@redhat.com
> >> [    5.109380] cpuidle: using governor ladder
> >> [    5.149691] Switching to clocksource tsc
> >> [    5.149781] cpuidle: using governor menu
> >> [    5.149967] EFI Variables Facility v0.08 2004-May-17
> >> [    5.150083] usbcore: registered new interface driver usbhid
> >> [    5.150084] usbhid: USB HID core driver
> >> [    5.150186] ip_tables: (C) 2000-2006 Netfilter Core Team
> >> [    5.150199] TCP: cubic registered
> >> [    5.150200] Initializing XFRM netlink socket
> >> [    5.150304] NET: Registered protocol family 10
> >> [    5.150480] Mobile IPv6
> >> [    5.150482] NET: Registered protocol family 17
> >> [    5.150493] Registering the dns_resolver key type
> >> [    5.150629] Using IPI No-Shortcut mode
> >> [    5.150847] registered taskstats version 1
> >> [    5.151040] IMA: No TPM chip found, activating TPM-bypass!
> >> [    5.151555]   Magic number: 8:957:496
> >> [    5.205717] ata4: SATA link down (SStatus 0 SControl 300)
> >> [    5.216677] ata5: SATA link down (SStatus 0 SControl 300)
> >> [    5.228511] rtc_cmos 00:04: setting system clock to 2012-04-27
> >> 19:29:54 UTC (1335554994)
> >> [    5.237231] Initializing network drop monitor service
> >> [    5.252298] input: AT Translated Set 2 keyboard as
> >> /devices/platform/i8042/serio0/input/input2
> >> [    5.337822] usb 1-1: new high-speed USB device number 2 using ehci_hcd
> >> [    5.458123] usb 1-1: New USB device found, idVendor=8087,
> >> idProduct=0024
> >> [    5.464836] usb 1-1: New USB device strings: Mfr=0, Product=0,
> >> SerialNumber=0
> >> [    5.472285] hub 1-1:1.0: USB hub found
> >> [    5.476079] hub 1-1:1.0: 4 ports detected
> >> [    5.582686] usb 2-1: new high-speed USB device number 2 using ehci_hcd
> >> [    5.703065] usb 2-1: New USB device found, idVendor=8087,
> >> idProduct=0024
> >> [    5.709779] usb 2-1: New USB device strings: Mfr=0, Product=0,
> >> SerialNumber=0
> >> [    5.717215] hub 2-1:1.0: USB hub found
> >> [    5.721017] hub 2-1:1.0: 6 ports detected
> >> [    5.798822] usb 1-1.4: new low-speed USB device number 3 using ehci_hcd
> >> [    5.895273] usb 1-1.4: New USB device found, idVendor=046d,
> >> idProduct=c06a
> >> [    5.902161] usb 1-1.4: New USB device strings: Mfr=1, Product=2,
> >> SerialNumber=0
> >> [    5.909474] usb 1-1.4: Product: USB Optical Mouse
> >> [    5.914180] usb 1-1.4: Manufacturer: Logitech
> >> [    5.920745] input: Logitech USB Optical Mouse as
> >> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input3
> >> [    5.931863] generic-usb 0003:046D:C06A.0001: input,hidraw0: USB HID
> >> v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1.4/input0
> >> [    6.173534] ata2.01: failed to resume link (SControl 0)
> >> [    6.178838] ata3.01: failed to resume link (SControl 0)
> >> [    6.195003] ata3.00: SATA link down (SStatus 0 SControl 300)
> >> [    6.200677] ata3.01: SATA link down (SStatus 0 SControl 0)
> >> [    6.329589] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >> [    6.336057] ata2.01: SATA link down (SStatus 0 SControl 0)
> >> [    6.344941] ata2.00: ATA-8: WDC WD3200AAKS-00V1A0, 05.01D05, max
> >> UDMA/133
> >> [    6.351735] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth
> >> 0/32)
> >> [    6.362854] ata2.00: configured for UDMA/133
> >> [    6.367371] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0
> >> 05.0 PQ: 0 ANSI: 5
> >> [    6.375670] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320
> >> GB/298 GiB)
> >> [    6.375674] sd 0:0:0:0: Attached scsi generic sg0 type 0
> >> [    6.388523] sd 0:0:0:0: [sda] Write Protect is off
> >> [    6.393340] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> >> enabled, doesn't support DPO or FUA
> >> [    6.444965]  sda: sda1 sda2
> >> [    6.448269] sd 0:0:0:0: [sda] Attached SCSI disk
> >> [    6.453100] Freeing unused kernel memory: 604k freed
> >> [    6.458274] Write protecting the kernel text: 4356k
> >> [    6.463254] Write protecting the kernel read-only data: 2100k
> >> [    6.469004] NX-protecting the kernel data: 3836k
> >> [    6.705584] dracut: dracut-013-22.fc16
> >> [    6.719207] dracut: rd.luks=0: removing cryptoluks activation
> >> [    6.727814] dracut: rd.lvm=0: removing LVM activation
> >> [    6.737717] udevd[114]: starting version 173
> >> [    6.756621] wmi: Mapper loaded
> >> [    6.771672] [drm] Initialized drm 1.1.0 20060810
> >> [    6.800018] VGA switcheroo: detected Optimus DSM method \ handle
> >> [    6.806244] [drm] nouveau 0000:01:00.0: Detected an NV50 generation
> >> card (0x298200a2)
> >> [    6.815902] [drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
> >> [    6.869082] [drm] nouveau 0000:01:00.0: ... appears to be valid
> >> [    6.874998] [drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
> >> [    6.880908] [drm] nouveau 0000:01:00.0: BIT BIOS found
> >> [    6.886048] [drm] nouveau 0000:01:00.0: Bios version 62.98.42.00
> >> [    6.892052] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
> >> [    6.898005] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to
> >> do
> >> [    6.904792] [drm] nouveau 0000:01:00.0: DCB version 4.0
> >> [    6.910015] [drm] nouveau 0000:01:00.0: DCB outp 00: 02000300 00000028
> >> [    6.916538] [drm] nouveau 0000:01:00.0: DCB outp 01: 01000302 00020030
> >> [    6.923062] [drm] nouveau 0000:01:00.0: DCB outp 02: 04011310 00000028
> >> [    6.929587] [drm] nouveau 0000:01:00.0: DCB outp 03: 010223f1 00c0c080
> >> [    6.936111] [drm] nouveau 0000:01:00.0: DCB conn 00: 00001030
> >> [    6.941872] [drm] nouveau 0000:01:00.0: DCB conn 01: 00000200
> >> [    6.947635] [drm] nouveau 0000:01:00.0: DCB conn 02: 00000110
> >> [    6.953387] [drm] nouveau 0000:01:00.0: DCB conn 03: 00000111
> >> [    6.959142] [drm] nouveau 0000:01:00.0: DCB conn 04: 00000113
> >> [    6.964904] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at
> >> offset 0xD5EA
> >> [    6.997830] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at
> >> offset 0xD99C
> >> [    7.011817] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at
> >> offset 0xE24B
> >> [    7.019472] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at
> >> offset 0xE33D
> >> [    7.028188] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at
> >> offset 0xE54D
> >> [    7.035833] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at
> >> offset 0xE5B2
> >> [    7.063301] [drm] nouveau 0000:01:00.0: 0xE5B2: Condition still not
> >> met after 20ms, skipping following opcodes
> >> [    7.075062] [TTM] Zone  kernel: Available graphics memory: 438670 kiB
> >> [    7.081499] [TTM] Zone highmem: Available graphics memory: 1025234 kiB
> >> [    7.088021] [TTM] Initializing pool allocator
> >> [    7.092387] [TTM] Initializing DMA pool allocator
> >> [    7.097090] [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM (DDR2)
> >> [    7.105112] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
> >> [    7.123311] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
> >> [    7.129062] [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
> >> [    7.136668] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> >> [    7.143280] [drm] No driver support for vblank timestamp query.
> >> [    7.172164] [drm] nouveau 0000:01:00.0: 1 available performance
> >> level(s)
> >> [    7.178863] [drm] nouveau 0000:01:00.0: 3: core 567MHz shader 1400MHz
> >> memory 400MHz fanspeed 100%
> >> [    7.187725] [drm] nouveau 0000:01:00.0: c: core 566MHz shader 1400MHz
> >> memory 499MHz
> >> [    7.297194] [drm] nouveau 0000:01:00.0: allocated 1440x900 fb:
> >> 0x320000, bo efb2ca00
> >> [    7.305088] fbcon: nouveaufb (fb0) is primary device
> >> [    7.328851] Console: switching to colour frame buffer device 180x56
> >> [    7.336548] fb0: nouveaufb frame buffer device
> >> [    7.341001] drm: registered panic notifier
> >> [    7.345108] [drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0
> >> on minor 0
> >> [    7.364505] dracut: Starting plymouth daemon
> >> [    7.407549] dracut: rd.dm=0: removing DM RAID activation
> >> [    7.417941] dracut: rd.md=0: removing MD RAID activation
> >> [    7.680413] EXT4-fs (sda1): INFO: recovery required on readonly
> >> filesystem
> >> [    7.687295] EXT4-fs (sda1): write access will be enabled during
> >> recovery
> >> [    8.179441] EXT4-fs (sda1): recovery complete
> >> [    8.186283] EXT4-fs (sda1): mounted filesystem with ordered data mode.
> >> Opts: (null)
> >> [    8.281276] dracut: Checking ext4:
> >> /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0
> >> [    8.289546] dracut: issuing e2fsck -a
> >>  /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0
> >> [    8.371906] dracut:
> >> /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0: clean,
> >> 334023/19275776 files, 5620781/77094144 blocks
> >> [    8.383880] dracut: Remounting
> >> /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0 with -o ro
> >> [    8.517669] EXT4-fs (sda1): mounted filesystem with ordered data mode.
> >> Opts: (null)
> >> [    8.544121] dracut: Mounted root filesystem /dev/sda1
> >> [    8.774733] dracut: Switching root
> >> [    9.178001] SELinux:  Disabled at runtime.
> >> [    9.182626] type=1404 audit(1335554998.530:2): selinux=0
> >> auid=4294967295 ses=4294967295
> >> [    9.231638] systemd[1]: RTC configured in localtime, applying delta of
> >> 480 minutes to system time.
> >> [    9.259626] systemd[1]: systemd 37 running in system mode. (+PAM
> >> +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
> >>
> >>  Welcome to Fedora release 16 (Verne)!
> >>
> >>  [    9.286162] systemd[1]: Set hostname to <ga-p61-fc16>.
> >> Starting Replay Read-Ahead Data...
> >> Starting Collect Read-Ahead Data...
> >> Starting Syslog Kernel Log Buffer Bridge...
> >> Started Syslog Kernel Log Buffer Bridge                                [
> >>  OK  ]
> >> Started Lock Directory                                                 [
> >>  OK  ]
> >> Starting Media Directory...
> >> Starting Software RAID Monitor Takeover...
> >> Starting POSIX Message Queue File System...
> >> Starting Debug File System...
> >> Starting Security File System...
> >> Starting Huge Pages File System...
> >> Starting RPC Pip[   10.321380] systemd-readahead-replay[362]: Bumped
> >> block_nr parameter of 8:0 to 16384. This is a temporary hack and should be
> >> removed one day.
> >> e File System...
> >> Starting udev Kernel Device Manager...
> >> Starting udev Coldplug all Devices...
> >> Started Runtime Directory                                              [
> >>  OK  ]
> >> Started Collect Read-Ahead Data                                        [
> >>  OK  ]
> >> Started Software RAID Monitor Takeover                                 [
> >>  OK  ]
> >> Starting STDOUT Syslog Bridge...
> >> Started STDOUT Syslog Bridge                                           [
> >>  OK  ]
> >> Started Replay Read-Ahead Data                                         [
> >>  OK  ]
> >> Starting Load legacy module configuration...
> >> Starting Remount API VFS...
> >> Started File System Check on Root Device                               [
> >>  OK  ]
> >> Starting Remount Root FS...
> >> [   13.119541] udevd[374]: starting version 173
> >> Started Set Up Additional Binary Formats                               [
> >>  OK  ]
> >> Starting Apply Kernel Variables...
> >> [   14.427560] EXT4-fs (sda1): re-mounted. Opts: (null)
> >> Started Load Kernel Modules                                            [
> >>  OK  ]
> >> Started FUSE Control File System                                       [
> >>  OK  ]
> >> Started Configuration File System                                      [
> >>  OK  ]
> >> Starting Setup Virtual Console...
> >> Started udev Kernel Device Manager                                     [
> >>  OK  ]
> >> Started Media Directory                                                [
> >>  OK  ]
> >> Started POSIX Message Queue File System                                [
> >>  OK  ]
> >> Started Debug File System                                              [
> >>  OK  ]
> >> Started Security File System                                           [
> >>  OK  ]
> >> Started Huge Pages File System                                         [
> >>  OK  ]
> >> Started Load legacy module configuration                               [
> >>  OK  ]
> >> Started Remount API VFS                                                [
> >>  OK  ]
> >> Started Remount Root FS                                                [
> >>  OK  ]
> >> Started Apply Kernel Variables                                         [
> >>  OK  ]
> >> Started udev Coldplug all Devices                                      [
> >>  OK  ]
> >> Starting udev Wait for Complete Device Initialization...
> >> Starting Configure read-only root support...
> >> [   15.102553] RPC: Registered named UNIX socket transport module.
> >> [   15.108482] RPC: Registered udp transport module.
> >> [   15.113197] RPC: Registered tcp transport module.
> >> [   15.117902] RPC: Registered tcp NFSv4.1 backchannel transport module.
> >> Started RPC Pipe File System                                           [
> >>  OK  ]
> >> Started Setup Virtual Console                                          [
> >>  OK  ]
> >> Started Configure read-only root support                               [
> >>  OK  ]
> >> [   16.060725] mtp-probe[467]: checking bus 1, device 3:
> >> "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4"
> >> [   16.119379] mtp-probe[467]: bus: 1, device: 3 was not an MTP device
> >> [   16.150829] parport_pc 00:08: reported by Plug and Play ACPI
> >> [   16.156537] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> >> [   16.277569] ppdev: user-space parallel port driver
> >> [   17.364865] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x14
> >> [   17.373053] microcode: CPU0 updated to revision 0x25, date = 2011-10-11
> >> [   17.379685] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x14
> >> [   17.386939] microcode: CPU1 updated to revision 0x25, date = 2011-10-11
> >> [   17.393563] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x14
> >> [   17.401406] microcode: CPU2 updated to revision 0x25, date = 2011-10-11
> >> [   17.408023] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x14
> >> [   17.415090] microcode: CPU3 updated to revision 0x25, date = 2011-10-11
> >> [   17.421743] microcode: Microcode Update Driver: v2.00 <
> >> tigran@aivazian.fsnet.co.uk>, Peter Oruba
> >> [   17.440501] input: PC Speaker as /devices/platform/pcspkr/input/input4
> >> [   17.456225] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> >> [   17.457547] xhci_hcd 0000:03:00.0: xHCI Host Controller
> >> [   17.457602] xhci_hcd 0000:03:00.0: new USB bus registered, assigned
> >> bus number 3
> >> [   17.457900] xhci_hcd 0000:03:00.0: irq 17, io mem 0xfbde0000
> >> [   17.458145] usb usb3: New USB device found, idVendor=1d6b,
> >> idProduct=0002
> >> [   17.458147] usb usb3: New USB device strings: Mfr=3, Product=2,
> >> SerialNumber=1
> >> [   17.458149] usb usb3: Product: xHCI Host Controller
> >> [   17.458150] usb usb3: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> >> [   17.458151] usb usb3: SerialNumber: 0000:03:00.0
> >> [   17.458245] hub 3-0:1.0: USB hub found
> >> [   17.458259] hub 3-0:1.0: 4 ports detected
> >> [   17.458335] xhci_hcd 0000:03:00.0: xHCI Host Controller
> >> [   17.458365] xhci_hcd 0000:03:00.0: new USB bus registered, assigned
> >> bus number 4
> >> [   17.458382] usb usb4: New USB device found, idVendor=1d6b,
> >> idProduct=0003
> >> [   17.458384] usb usb4: New USB device strings: Mfr=3, Product=2,
> >> SerialNumber=1
> >> [   17.458385] usb usb4: Product: xHCI Host Controller
> >> [   17.458386] usb usb4: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> >> [   17.458387] usb usb4: SerialNumber: 0000:03:00.0
> >> [   17.458451] hub 4-0:1.0: USB hub found
> >> [   17.458467] hub 4-0:1.0: 4 ports detected
> >> [   17.566730] iTCO_vendor_support: vendor-support=0
> >> [   17.566783] r8169 0000:07:00.0: eth0: RTL8168evl/8111evl at
> >> 0xfd398000, 50:e5:49:3d:55:88, XID 0c900800 IRQ 46
> >> [   17.566786] r8169 0000:07:00.0: eth0: jumbo features [frames: 9200
> >> bytes, tx checksumming: ko]
> >> [   17.590483] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
> >> [   17.596127] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled
> >> by hardware/BIOS
> >> [   17.604324] xhci_hcd 0000:06:00.0: xHCI Host Controller
> >> [   17.609750] xhci_hcd 0000:06:00.0: new USB bus registered, assigned
> >> bus number 5
> >> [   17.609801] udevd[407]: renamed network interface eth0 to p5p1
> >> [   17.623101] xhci_hcd 0000:06:00.0: irq 16, io mem 0xfbcf8000
> >> [   17.628915] usb usb5: New USB device found, idVendor=1d6b,
> >> idProduct=0002
> >> [   17.635697] usb usb5: New USB device strings: Mfr=3, Product=2,
> >> SerialNumber=1
> >> [   17.642916] usb usb5: Product: xHCI Host Controller
> >> [   17.647793] usb usb5: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> >> [   17.653450] usb usb5: SerialNumber: 0000:06:00.0
> >> [   17.658220] hub 5-0:1.0: USB hub found
> >> [   17.661983] hub 5-0:1.0: 2 ports detected
> >> [   17.666070] xhci_hcd 0000:06:00.0: xHCI Host Controller
> >> [   17.671349] xhci_hcd 0000:06:00.0: new USB bus registered, assigned
> >> bus number 6
> >> [   17.678780] usb usb6: New USB device found, idVendor=1d6b,
> >> idProduct=0003
> >> [   17.685594] usb usb6: New USB device strings: Mfr=3, Product=2,
> >> SerialNumber=1
> >> [   17.692813] usb usb6: Product: xHCI Host Controller
> >> [   17.697690] usb usb6: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> >> [   17.703348] usb usb6: SerialNumber: 0000:06:00.0
> >> [   17.708101] hub 6-0:1.0: USB hub found
> >> [   17.711867] hub 6-0:1.0: 2 ports detected
> >> [   17.779983] usb 4-2: new SuperSpeed USB device number 2 using xhci_hcd
> >> [   17.797192] usb 4-2: Int endpoint with wBytesPerInterval of 4096 in
> >> config 1 interface 0 altsetting 0 ep 130: setting to 1
> >> [   17.808267] usb 4-2: Int endpoint with wBytesPerInterval of 4096 in
> >> config 1 interface 0 altsetting 1 ep 130: setting to 1024
> >> [   17.819582] usb 4-2: New USB device found, idVendor=1d5c,
> >> idProduct=8347
> >> [   17.826284] usb 4-2: New USB device strings: Mfr=0, Product=0,
> >> SerialNumber=0
> >> [   17.836788] mtp-probe[610]: checking bus 4, device 2:
> >> "/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/usb4/4-2"
> >> [   17.847215] mtp-probe[610]: bus: 4, device: 2 was not an MTP device
> >> [   17.866018] flusbfb: (null) (null) - serial #(null)
> >> [   17.870902] flusbfb: vid_1d5c&pid_8347&rev_0100 driver's fl_data
> >> struct at efa5a800
> >> [   17.878552] flusbfb: bLength=18
> >> [   17.881695] flusbfb: bDescriptorType=1
> >> [   17.885447] flusbfb: bcdUSB=0x0300
> >> [   17.888860] flusbfb: bDeviceClass=0
> >> [   17.892352] flusbfb: bDeviceSubClass=0
> >> [   17.896104] flusbfb: bDeviceProtocol=0
> >> [   17.899854] flusbfb: bMaxPacketSize0=9
> >> [   17.903598] flusbfb: idVendor=0x1d5c
> >> [   17.907177] flusbfb: idProduct=0x8347
> >> [   17.910844] flusbfb: bcdDevice=0x0100
> >> [   17.914509] flusbfb: iManufacturer=0
> >> [   17.918085] flusbfb: iProduct=0
> >> [   17.921230] flusbfb: iSerialNumber=0
> >> [   17.924801] flusbfb: bNumConfigurations=1
> >> [   17.928811] flusbfb: console enable=1
> >> [   17.932469] flusbfb: fb_defio enable=1
> >> [   17.936219] flusbfb: shadow enable=1
> >> [   17.940005] flusbfb: vendor descriptor not available (-32)
> >> [   17.956483] flusbfb: allocated 12 6220800 byte urbs
> >> [   17.961428] usbcore: registered new interface driver ufl
> >> [   17.964433] flusbfb: Read EDID retryIndex=0
> >> Started udev Wait for Complete Device Initializa[   17.974461] flusbfb:
> >> Read EDID retryIndex=1
> >> tion                   [  OK  ]
> >> Starting Wait for storage scan...
> >> [   17.998756] flusbfb: Read EDID retryIndex=0
> >> [   18.022004] flusbfb: Read EDID retryIndex=0
> >> [   18.045249] flusbfb: Read EDID retryIndex=0
> >> [   18.068496] flusbfb: Read EDID retryIndex=0
> >> [   18.091742] flusbfb: Read EDID retryIndex=0
> >> [   18.114981] flusbfb: Read EDID retryIndex=0
> >> [   18.138233] flusbfb: Read EDID retryIndex=0
> >> [   18.161478] flusbfb: Read EDID retryIndex=0
> >> [   18.184727] flusbfb: Read EDID retryIndex=0
> >> Started Show Plymouth Boot Screen                                      [
> >>  OK  ]
> >> Starting /dev/disk/by-uuid/e2c31c2b-73f2-4361-a5dc-0d132cb90d5a...
> >> [   18.208015] flusbfb: Read EDID retryIndex=0
> >> [   18.230587] Adding 4193276k swap on /dev/sda2.  Priority:0 extents:1
> >> across:4193276k
> >> [   18.238427] flusbfb: Read EDID retryIndex=0
> >> Started /dev/disk/by-uuid/e2c31c2b-73f2-4361-a5dc-0d132cb90d5a         [
> >> [   18.261700] flusbfb: Read EDID retryIndex=0
> >>  OK  ]
> >> [   18.285124] flusbfb: Read EDID retryIndex=0
> >> [   18.308369] flusbfb: Read EDID retryIndex=0
> >> [   18.331614] flusbfb: Read EDID retryIndex=0
> >> [   18.354853] flusbfb: Read EDID retryIndex=0
> >> [   18.378094] flusbfb: Read EDID retryIndex=0
> >> [   18.401337] flusbfb: Read EDID retryIndex=0
> >> [   18.424580] flusbfb: Read EDID retryIndex=0
> >> [   18.447826] flusbfb: Read EDID retryIndex=0
> >> [   18.471067] flusbfb: Read EDID retryIndex=0
> >> [   18.494311] flusbfb: Read EDID retryIndex=0
> >> [   18.517549] flusbfb: Read EDID retryIndex=0
> >> [   18.540788] flusbfb: Read EDID retryIndex=0
> >> [   18.554982] flusbfb: Read EDID retryIndex=1
> >> [   18.569181] flusbfb: Read EDID retryIndex=2
> >> [   18.592526] flusbfb: Read EDID retryIndex=0
> >> [   18.615767] flusbfb: Read EDID retryIndex=0
> >> [   18.639011] flusbfb: Read EDID retryIndex=0
> >> [   18.662251] flusbfb: Read EDID retryIndex=0
> >> [   18.685490] flusbfb: Read EDID retryIndex=0
> >> [   18.708729] flusbfb: Read EDID retryIndex=0
> >> [   18.731974] flusbfb: Read EDID retryIndex=0
> >> [   18.752182]
> >> [   18.753674] 00ffffffffffff00 38b81a9501010101
> >> [   18.758438] 31130103082b1a78 eac905a3574b9c25
> >> [   18.763185] 125054a54a0081c0 0101010101010101
> >> [   18.765824] 0101010101016621 56aa51001e30468f
> >> [   18.765827] 3300aeff1000001e 000000fd00384c1f
> >> [   18.765830] 5210000a20202020 2020000000fc0039
> >> [   18.765832] 354e410a20202020 20202020000000ff
> >> [   18.765835] 0039354e414e4739 34393137313000cc
> >> [   18.765842] flusbfb: 1366x768 valid mode
> >> [   18.765843] flusbfb: 720x400 valid mode
> >> [   18.765844] flusbfb: 640x480 valid mode
> >> [   18.765845] flusbfb: 640x480 valid mode
> >> [   18.765846] flusbfb: 800x600 valid mode
> >> [   18.765847] flusbfb: 800x600 valid mode
> >> [   18.765848] flusbfb: 1024x768 valid mode
> >> [   18.765849] flusbfb: 1024x768 valid mode
> >> [   18.765850] flusbfb: 1280x720 valid mode
> >> [   18.765851] flusbfb: Reallocating framebuffer. Addresses will change!
> >> [   18.766045] flusbfb: 1366x768 valid mode
> >> [   18.766046] set_par mode 1366x768
> >> [   18.766047] func=fresco_SetResolution
> >> [   18.766048] var->xres=1366, var->yres=768
> >> [   18.766048] refresh=60
> >> [   18.767203] step 1 PLL read back rbuf[0]=0x09
> >> [   18.767206] step 1 PLL read back rbuf[1]=0x01
> >> [   18.767207] step 1 PLL read back rbuf[2]=0x36
> >> [   18.767208] step 1 PLL read back rbuf[3]=0x00
> >> [   18.767607] fresco_SetResolution pass
> >> [   18.767712] flusbfb: frescologic USB device /dev/fb1 attached.
> >> 1366x768 resolution. Using 6152K framebuffer memory
> >> Started Wait for storage scan                                          [
> >>  OK  ]
> >> Starting Initialize storage subsystems (RAID, LVM, etc.)...
> >> [   19.035453] fedora-storage-init[624]: Setting up Logical Volume
> >> Management:   No volume groups found
> >> [   19.044650] fedora-storage-init[624]: [  OK  ]
> >> Started Initialize storage subsystems (RAID, LVM, etc.)                [
> >>  OK  ]
> >> Starting Initialize storage subsystems (RAID, LVM, etc.)...
> >> [   20.247858] fedora-storage-init[630]: Setting up Logical Volume
> >> Management:   No volume groups found
> >> [   20.257016] fedora-storage-init[630]: [  OK  ]
> >> Started Initialize storage subsystems (RAID, LVM, etc.)                [
> >>  OK  ]
> >> Starting Monitoring[   20.465916] lvm[636]: No volume groups found
> >>  of LVM2 mirrors, snapshots etc. using d...ogress polling...
> >> Started Monitoring of LVM2 mirrors, snapshots etc. u...rogress polling [
> >>  OK  ]
> >> Started Mark the need to relabel after reboot                          [
> >>  OK  ]
> >> Started Relabel all filesystems, if necessary                          [
> >>  OK  ]
> >> Started Reconfigure the system on administrator request                [
> >>  OK  ]
> >> Starting Tell Plymouth To Write Out Runtime Data...
> >> Starting Load Random Seed...
> >> Starting Recreate Volatile Files and Directories...
> >> Started Load Random Seed                                               [
> >>  OK  ]
> >> Started Recreate Volatile Files and Directories                        [
> >>  OK  ]
> >> Started Tell Plymouth To Write Out Runtime Data                        [
> >>  OK  ]
> >> Starting Console System Startup Logging...
> >> Starting Restore Sound Card State...                            [
> >> 21.650392] alsactl[646]: /sbin/alsactl: load_state:1686: No soundcards
> >> found...
> >>
> >>  Starting SYSV: sandbox, xguest and other apps that want to ...rate
> >> namespace...
> >> Started Load static arp entries                             [
> >> 21.671411] sandbox[649]: Starting sandbox[  OK  ]
> >>            [  OK  ]
> >> Started IPv4 firewall with iptables                                    [
> >>  OK  ]
> >> Started IPv6 firewall with ip6tabl[   21.690250] auditd[650]: Started
> >> dispatcher: /sbin/audispd pid: 655
> >> es              [   21.697866] audispd[655]: audispd initialized with
> >> q_depth=120 and 1 active plugins
> >>                 [   21.706559] auditctl[652]: No rules
> >>      [  O[   21.711426] auditctl[652]: AUDIT_STATUS: enabled=0 flag=1
> >> pid=0 rate_limit=0 backlog_limit=320 lost=0 backlog=0
> >> K  ]
> >> Starting Security Auditing Service...                [   21.728354]
> >> avahi-daemon[664]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
> >>                 [   21.736384] avahi-daemon[664]: Successfully dropped
> >> root privileges.
> >> [   21.744123] avahi-daemon[664]: avahi-daemon 0.6.30 starting up.
> >>
> >>  san[   21.750255] mcelog[665]: Hardware event. This is not a software
> >> error.
> >> dbox[649]: Start[   21.757986] mcelog[665]: MCE 0
> >> ing sandbox[  OK[   21.762438] mcelog[665]: CPU 0 THERMAL EVENT TSC
> >> 2bfc83b1b8
> >>   ]
> >> Starting M[   21.769413] mcelog[665]: TIME 1335554989 Sat Apr 28 03:29:49
> >> 2012
> >> achine Check Exc[   21.776918] mcelog[665]: Processor 0 heated above trip
> >> temperature. Throttling enabled.
> >> eption Logging D[   21.786314] mcelog[665]: Please check your system
> >> cooling. Performance will be impacted
> >> aemon...        [   21.786322] mcelog[665]: STATUS 880003c3 MCGSTATUS 0
> >> [   21.786327] mcelog[665]: MCGCAP c07 APICID 0 SOCKETID 0
> >> [   21.786332] mcelog[665]: CPUID Vendor Intel Family 6 Model 42
> >> [   21.786338] mcelog[665]: Hardware event. This is not a software error.
> >> [   21.786344] mcelog[665]: MCE 1
> >> [   21.786348] mcelog[665]: CPU 0 THERMAL EVENT TSC 2bfd59a7ac
> >> [   21.786354] mcelog[665]: TIME 1335554989 Sat Apr 28 03:29:49 2012
> >> [   21.786360] mcelog[665]: Processor 0 below trip temperature.
> >> Throttling disabled
> >> [   21.786365] mcelog[665]: STATUS 88010282 MCGSTATUS 0
> >> [   21.786370] avahi-daemon[664]: WARNING: No NSS support for mDNS
> >> detected, consider installing nss-mdns!
> >> [   21.786375] abrtd[666]: Init complete, entering main loop
> >> [   21.786380] mcelog[665]: MCGCAP c07 APICID 0 SOCKETID 0
> >> [   21.786385] mcelog[665]: CPUID Vendor Intel Family 6 Model 42
> >> [   21.792636] auditd[650]: Init complete, auditd 2.2.1 listening for
> >> events (startup state enable)
> >>
> >>  Starting Avahi mDNS/DNS-SD Stack...
> >> Starting ABRT Automated Bug Reporting Tool...
> >> Started ABRT Automated Bug Reporting Tool                              [
> >>  OK  ]
> >> Starting Harvest vmcores for ABRT...
> >> Starting irqbalance daemon...
> >> Starting SSH server keys generation....
> >> Starting Network Manager...
> >> Starting ABRT kernel log watcher...                             [
> >> 22.149982] NetworkManager[675]: <info> NetworkManager (version
> >> 0.9.4-2.git20120403.fc16) is starting...
> >> [   22.160712] NetworkManager[675]: <info> Read config file
> >> /etc/NetworkManager/NetworkManager.conf
> >>
> >>  Started ABRT kernel log watcher
> >>  [  OK  ]
> >> Starting Job spooling tools...
> >> Started Job spooling tools                                             [
> >>  OK  ]
> >> Starting Install ABRT coredump hook...                            [
> >> 22.199823] acpid[690]: starting up with netlink and the input layer
> >> [   22.206412] acpid[690]: skipping incomplete file
> >> /etc/acpi/events/videoconf
> >>
> >>  [   22.213385] acpid[690]: 1 rule loaded
> >> Starting ACPI Ev[   22.218439] acpid[690]: waiting for events: event
> >> logging is off
> >> ent Daemon...
> >> Starting System Logging Service...
> >> Started Software RAID monitoring and management                        [
> >>  OK  ]
> >> Starting System Setup Keyboard...
> >> Started System Setup Keyboard                                          [
> >>  OK  ]
> >> Starting Wait for Plymouth Boot Screen to Quit...
> >> Starting D-Bus System Message Bus...
> >> Starting Login Service...
> >> Started Console System Startup Logging                                 [
> >>  OK  ]
> >> Started Restore Sound Card State                                       [
> >>  OK  ]
> >> Started SYSV: sandbox, xguest and other apps that wa...arate namespace [
> >>  OK  ]
> >> Started Security Auditing Service                                      [
> >>  OK  ]
> >> Started Machine Check Exception Logging Daemon                         [
> >>  OK  ]
> >> Started Harvest vmcores for ABRT                                       [
> >>  OK  ]
> >> Started irqbalance daemon                                              [
> >>  OK  ]
> >> Started SSH server keys generation.                                    [
> >>  OK  ]
> >> Started Install ABRT coredump hook                                     [
> >>  OK  ]
> >> Started ACPI Event Daemon                                              [
> >>  OK  ]
> >> Starting Command Scheduler...
> >> Started Command Scheduler                                              [
> >>  OK  ]
> >> Starting LSB: Mount and unmount network filesystems....
> >> Started D-Bus System Message Bus                                       [
> >>  OK  ]
> >> Stopping Syslog Kernel Log Buffer Bridge...
> >> Stopped Syslog Kernel Log Buffer Bridge                                [
> >>  OK  ]
> >> Started System Logging Service                                         [
> >>  OK  ]
> >> Started Avahi mDNS/DNS-SD Stack                                        [
> >>  OK  ]
> >> Started Login Service                                                  [
> >>  OK  ]
> >> Started Network Manager                                                [
> >>  OK  ]
> >> Starting NFSv4 ID-name mapping daemon...
> >> [   23.980541] r8169 0000:07:00.0: p5p1: link down
> >> [   23.980586] r8169 0000:07:00.0: p5p1: link down
> >> [   23.989722] ADDRCONF(NETDEV_UP): p5p1: link is not ready
> >> Starting Sendmail Mail Transport Agent...
> >> Starting OpenSSH server daemon...
> >> Started OpenSSH server daemon                                          [
> >>  OK  ]
> >> Starting RPC bind service...
> >> Starting Samba SMB Daemon...
> >> Started LSB: Mount and unmount network filesystems.                    [
> >>  OK  ]
> >> Started NFSv4 ID-name mapping daemon                                   [
> >>  OK  ]
> >> Started RPC bind service                                               [
> >>  OK  ]
> >> Started Samba SMB Daemon                                               [
> >>  OK  ]
> >> Starting NFS file locking service....
> >> Starting Permit User Sessions...
> >> Started Permit User Sessions                                           [
> >>  OK  ]
> >> Starting Display Manager...
> >> Started Display Manager                                                [
> >>  OK  ]
> >> Starting CUPS Printing Service...
> >> Started CUPS Printing Service                                          [
> >>  OK  ]
> >> Started NFS file locking service.                                      [
> >>  OK  ]
> >> [   24.312188] func=fl_ops_open
> >> [   24.315141] flusbfb: open /dev/fb1 user=1 fb_info=efbfa000 count=1
> >> [   24.321418] flusbfb: released /dev/fb1 user=1 count=0
> >> [   24.326504] frame_buffer_auto_repeat_timer_exit
> >> [   24.331217] func=fl_ops_open
> >> [   24.334123] flusbfb: open /dev/fb1 user=1 fb_info=efbfa000 count=1
> >> [   24.340309] func=fl_ops_open
> >> [   24.343193] flusbfb: open /dev/fb1 user=1 fb_info=efbfa000 count=2
> >> [   25.326873] flusbfb: /dev/fb1 FB_BLANK mode 0 --> 0
> >> [   25.561884] r8169 0000:07:00.0: p5p1: link up
> >> [   25.566392] ADDRCONF(NETDEV_CHANGE): p5p1: link becomes ready
> >>
> >>  Fedora release 16 (Verne)
> >> Kernel 3.4.0-rc4 on an i686 (ttyS0)
> >>
> >>  ga-p61-fc16 login: [   33.455478] BUG: scheduling while atomic:
> >> swapper/0/0/0x00000100
> >> [   33.461521] Modules linked in: lockd flusbfb(O) iTCO_wdt
> >> iTCO_vendor_support xhci_hcd r8169 mii pcspkr coretemp microcode i2c_i801
> >> ppdev parport_pc parport sunrpc uinput crc32c_intel nouveau ttm
> >> drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded:
> >> scsi_wait_scan]
> >> [   33.486198] Pid: 0, comm: swapper/0 Tainted: G           O 3.4.0-rc4 #1
> >> [   33.492818] Call Trace:
> >> [   33.495279]  [<c0832fe7>] ? printk+0x2d/0x2f
> >> [   33.499554]  [<c08333fb>] __schedule_bug+0x51/0x53
> >> [   33.504346]  [<c0838e2c>] __schedule+0x5b/0x57b
> >> [   33.508885]  [<c0479fb4>] ? arch_local_irq_save+0x12/0x17
> >> [   33.514283]  [<c0839da6>] ? _raw_spin_lock_irqsave+0x10/0x2a
> >> [   33.519941]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> >> [   33.526040]  [<c0443423>] ? __mod_timer+0x105/0x110
> >> [   33.530919]  [<c083957c>] schedule+0x56/0x58
> >> [   33.535190]  [<c08384ba>] schedule_timeout+0x8a/0xb7
> >> [   33.540161]  [<c0442a88>] ? del_timer+0x61/0x61
> >> [   33.544697]  [<c0838c69>] __down_common+0x7b/0xb4
> >> [   33.549400]  [<c0838cb6>] __down_timeout+0x14/0x16
> >> [   33.554194]  [<c0453c41>] down_timeout+0x31/0x44
> >> [   33.558822]  [<f7e5a58e>] fl_get_urb+0x1d/0x85 [flusbfb]
> >> [   33.564131]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> >> [   33.570223]  [<f7e5b104>]
> >> frame_buffer_auto_repeat_timer_callback+0x45/0xf8 [flusbfb]
> >> [   33.578055]  [<c044320b>] run_timer_softirq+0x14b/0x221
> >> [   33.583281]  [<c083a209>] ? reschedule_interrupt+0x31/0x38
> >> [   33.588767]  [<f7e5b0bf>] ? fl_add_redraw_frame_count+0x10/0x10
> >> [flusbfb]
> >> [   33.595556]  [<c043d7dd>] __do_softirq+0xa2/0x17b
> >> [   33.600263]  [<c043d73b>] ?
> >> ftrace_define_fields_irq_handler_entry+0x71/0x71
> >> [   33.607313]  <IRQ>  [<c043da3d>] ? irq_exit+0x45/0x96
> >> [   33.612392]  [<c042576f>] ? smp_apic_timer_interrupt+0x69/0x76
> >> [   33.618226]  [<c041243e>] ? read_tsc+0x9/0x26
> >> [   33.622583]  [<c083aa55>] ? apic_timer_interrupt+0x31/0x38
> >> [   33.628076]  [<c04300e0>] ? free_memtype+0x63/0x154
> >> [   33.632955]  [<c0626978>] ? intel_idle+0xca/0xfa
> >> [   33.637574]  [<c0750379>] ? cpuidle_enter+0xe/0x12
> >> [   33.642371]  [<c0750803>] ? cpuidle_idle_call+0xbe/0x169
> >> [   33.647687]  [<c0414004>] ? cpu_idle+0x8f/0xb3
> >> [   33.652129]  [<c081c3b5>] ? rest_init+0x5d/0x5f
> >> [   33.656660]  [<c0ac07b5>] ? start_kernel+0x362/0x368
> >> [   33.661625]  [<c0ac01cc>] ? loglevel+0x2b/0x2b
> >> [   33.666069]  [<c0ac00ac>] ? i386_start_kernel+0x9b/0xa2
> >> [   33.671294] bad: scheduling from the idle thread!
> >> [   33.675999] Pid: 0, comm: swapper/0 Tainted: G           O 3.4.0-rc4 #1
> >> [   33.682608] Call Trace:
> >> [   33.685064]  [<c0832fe7>] ? printk+0x2d/0x2f
> >> [   33.689335]  [<c045e50c>] dequeue_task_idle+0x26/0x32
> >> [   33.694386]  [<c045a50c>] dequeue_task+0xcc/0xd4
> >> [   33.699006]  [<c045a891>] deactivate_task+0x21/0x24
> >> [   33.703884]  [<c0838ec1>] __schedule+0xf0/0x57b
> >> [   33.708416]  [<c0479fb4>] ? arch_local_irq_save+0x12/0x17
> >> [   33.713814]  [<c0839da6>] ? _raw_spin_lock_irqsave+0x10/0x2a
> >> [   33.719471]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> >> [   33.725564]  [<c0443423>] ? __mod_timer+0x105/0x110
> >> [   33.730441]  [<c083957c>] schedule+0x56/0x58
> >> [   33.734712]  [<c08384ba>] schedule_timeout+0x8a/0xb7
> >> [   33.739678]  [<c0442a88>] ? del_timer+0x61/0x61
> >> [   33.744208]  [<c0838c69>] __down_common+0x7b/0xb4
> >> [   33.748913]  [<c0838cb6>] __down_timeout+0x14/0x16
> >> [   33.753706]  [<c0453c41>] down_timeout+0x31/0x44
> >> [   33.758329]  [<f7e5a58e>] fl_get_urb+0x1d/0x85 [flusbfb]
> >> [   33.763648]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> >> [   33.769746]  [<f7e5b104>]
> >> frame_buffer_auto_repeat_timer_callback+0x45/0xf8 [flusbfb]
> >> [   33.777570]  [<c044320b>] run_timer_softirq+0x14b/0x221
> >> [   33.782792]  [<c083a209>] ? reschedule_interrupt+0x31/0x38
> >> [   33.788278]  [<f7e5b0bf>] ? fl_add_redraw_frame_count+0x10/0x10
> >> [flusbfb]
> >> [   33.795061]  [<c043d7dd>] __do_softirq+0xa2/0x17b
> >> [   33.799767]  [<c043d73b>] ?
> >> ftrace_define_fields_irq_handler_entry+0x71/0x71
> >> [   33.806813]  <IRQ>  [<c043da3d>] ? irq_exit+0x45/0x96
> >> [   33.811889]  [<c042576f>] ? smp_apic_timer_interrupt+0x69/0x76
> >> [   33.817720]  [<c041243e>] ? read_tsc+0x9/0x26
> >> [   33.822079]  [<c083aa55>] ? apic_timer_interrupt+0x31/0x38
> >> [   33.827563]  [<c04300e0>] ? free_memtype+0x63/0x154
> >> [   33.832442]  [<c0626978>] ? intel_idle+0xca/0xfa
> >> [   33.837062]  [<c0750379>] ? cpuidle_enter+0xe/0x12
> >> [   33.841852]  [<c0750803>] ? cpuidle_idle_call+0xbe/0x169
> >> [   33.847162]  [<c0414004>] ? cpu_idle+0x8f/0xb3
> >> [   33.851608]  [<c081c3b5>] ? rest_init+0x5d/0x5f
> >> [   33.856140]  [<c0ac07b5>] ? start_kernel+0x362/0x368
> >> [   33.861104]  [<c0ac01cc>] ? loglevel+0x2b/0x2b
> >> [   33.865547]  [<c0ac00ac>] ? i386_start_kernel+0x9b/0xa2
> >>
> >>
> >>
> >>
> >>
> >

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.4.0-rc4 (root@ga-p61-fc16) (gcc version 4.6.3 201                                                                                                                                20306 (Red Hat 4.6.3-2) (GCC) ) #4 SMP Mon Apr 30 10:47:54 CST 2012
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007efa0000 (usable)
> [    0.000000]  BIOS-e820: 000000007efa0000 - 000000007efa3000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000007efa3000 - 000000007efe0000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000007efe0000 - 000000007f000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x7efa0 max_arch_pfn = 0x1000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] total RAM covered: 2040M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K  chunk_size: 16M         num_reg: 2      lose cov                                                                                                                                er RAM: 0G
> [    0.000000] found SMP MP-table at [c00f5a10] f5a10
> [    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
> [    0.000000] RAMDISK: 28cc8000 - 3065c000
> [    0.000000] ACPI: RSDP 000f71a0 00014 (v00 GBT   )
> [    0.000000] ACPI: RSDT 7efa3040 0004C (v01 GBT    GBTUACPI 42302E31 GBTU 0101                                                                                                                                0101)
> [    0.000000] ACPI: FACP 7efa3100 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 0101                                                                                                                                0101)
> [    0.000000] ACPI: DSDT 7efa31c0 04B37 (v01 GBT    GBTUACPI 00001000 MSFT 0400                                                                                                                                0000)
> [    0.000000] ACPI: FACS 7efa0000 00040
> [    0.000000] ACPI: MCFG 7efa7ec0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 0101                                                                                                                                0101)
> [    0.000000] ACPI: ASPT 7efa7f00 00034 (v07 GBT    PerfTune 312E3042 UTBG 0101                                                                                                                                0101)
> [    0.000000] ACPI: SSPT 7efa7f40 02328 (v01 GBT    SsptHead 312E3042 UTBG 0101                                                                                                                                0101)
> [    0.000000] ACPI: EUDS 7efaa270 000C0 (v01 GBT             00000000      0000                                                                                                                                0000)
> [    0.000000] ACPI: MATS 7efaa330 00034 (v01 GBT             00000000      0000                                                                                                                                0000)
> [    0.000000] ACPI: TAMG 7efaa390 0083A (v01 GBT    GBT   B0 5455312E BG?? 4524                                                                                                                                0101)
> [    0.000000] ACPI: APIC 7efa7d40 000BC (v01 GBT    GBTUACPI 42302E31 GBTU 0101                                                                                                                                0101)
> [    0.000000] ACPI: SSDT 7efaac00 01DC0 (v01  INTEL PPM RCM  80000001 INTL 2006                                                                                                                                1109)
> [    0.000000] ACPI: MATS 7efac9c0 0A39F (v01        MATS RCM 80000001 INTL 2006                                                                                                                                1109)
> [    0.000000] 1145MB HIGHMEM available.
> [    0.000000] 885MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 375fe000
> [    0.000000]   low ram: 0 - 375fe000
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000375fe
> [    0.000000]   HighMem  0x000375fe -> 0x0007efa0
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] Early memory PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0007efa0
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 7f000000 (gap: 7f000000:7100                                                                                                                                0000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_                                                                                                                                ids:1
> [    0.000000] PERCPU: Embedded 14 pages/cpu @f6400000 s33216 r0 d24128 u262144
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pag                                                                                                                                es: 515919
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.4.0-rc4 root=UUID                                                                                                                                =81a1176f-441f-4d71-948b-c2458a3586f0 ro rd.md=0 rd.lvm=0 rd.dm=0 KEYTABLE=us co                                                                                                                                nsole=ttyS0,115200 SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=en_US.UTF-8
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] allocated 4160640 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memor                                                                                                                                y cgroups
> [    0.000000] Initializing HighMem for node 0 (000375fe:0007efa0)
> [    0.000000] Memory: 1925368k/2080384k available (4355k kernel code, 154564k r                                                                                                                                eserved, 2553k data, 604k init, 1173128k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffa96000 - 0xfffff000   (5540 kB)
> [    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
> [    0.000000]     vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
> [    0.000000]       .init : 0xc0ac0000 - 0xc0b57000   ( 604 kB)
> [    0.000000]       .data : 0xc0840ce6 - 0xc0abf140   (2553 kB)
> [    0.000000]       .text : 0xc0400000 - 0xc0840ce6   (4355 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor                                                                                                                                 mode...Ok.
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, N                                                                                                                                odes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:2304 nr_irqs:744 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [ttyS0] enabled
> [    0.001000] Fast TSC calibration using PIT
> [    0.002000] Detected 3092.948 MHz processor.
> [    0.000001] Calibrating delay loop (skipped), value calculated using timer fr                                                                                                                                equency.. 6185.89 BogoMIPS (lpj=3092948)
> [    0.010623] pid_max: default: 32768 minimum: 301
> [    0.015259] Security Framework initialized
> [    0.019360] SELinux:  Initializing.
> [    0.022890] Mount-cache hash table entries: 512
> [    0.027567] Initializing cgroup subsys cpuacct
> [    0.032016] Initializing cgroup subsys memory
> [    0.036378] Initializing cgroup subsys devices
> [    0.040828] Initializing cgroup subsys freezer
> [    0.045273] Initializing cgroup subsys net_cls
> [    0.049717] Initializing cgroup subsys blkio
> [    0.053992] Initializing cgroup subsys perf_event
> [    0.058716] CPU: Physical Processor ID: 0
> [    0.062731] CPU: Processor Core ID: 0
> [    0.066400] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.066400] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.079845] mce: CPU supports 7 MCE banks
> [    0.083865] CPU0: Thermal monitoring enabled (TM1)
> [    0.088660] using mwait in idle threads.
> [    0.092970] ACPI: Core revision 20120320
> [    0.099831] ftrace: allocating 22341 entries in 44 pages
> [    0.114494] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.120288] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.136289] CPU0: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz stepping 07
> [    0.244339] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events,                                                                                                                                 Intel PMU driver.
> [    0.253002] PEBS disabled due to CPU errata.
> [    0.257266] ... version:                3
> [    0.261268] ... bit width:              48
> [    0.265360] ... generic registers:      4
> [    0.269361] ... value mask:             0000ffffffffffff
> [    0.274665] ... max period:             000000007fffffff
> [    0.279968] ... fixed-purpose events:   3
> [    0.283970] ... event mask:             000000070000000f
> [    0.289398] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.295113] Booting Node   0, Processors  #1
> [    0.309508] Initializing CPU#1
> [    0.314863] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.320576]  #2
> [    0.332451] Initializing CPU#2
> [    0.337794] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.343509]  #3
> [    0.355368] Initializing CPU#3
> [    0.360722] NMI watchdog: enabled, takes one hw-pmu counter.
> [    0.366393] Brought up 4 CPUs
> [    0.369361] Total of 4 processors activated (24743.58 BogoMIPS).
> [    0.378165] devtmpfs: initialized
> [    0.381769] PM: Registering ACPI NVS region [mem 0x7efa0000-0x7efa2fff] (1228                                                                                                                                8 bytes)
> [    0.390193] atomic64 test passed for i586+ platform with CX8 and with SSE
> [    0.397002] RTC time: 11:07:54, date: 04/30/12
> [    0.401469] NET: Registered protocol family 16
> [    0.406188] ACPI: bus type pci registered
> [    0.410242] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3                                                                                                                                ffffff] (base 0xf0000000)
> [    0.419541] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
> [    0.426324] PCI: Using MMCONFIG for extended config space
> [    0.431721] PCI: Using configuration type 1 for base access
> [    0.438101] bio: create slab <bio-0> at 0
> [    0.442162] ACPI: Added _OSI(Module Device)
> [    0.446347] ACPI: Added _OSI(Processor Device)
> [    0.450783] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.455481] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.464601] ACPI: Interpreter enabled
> [    0.468271] ACPI: (supports S0 S1 S4 S5)
> [    0.472283] ACPI: Using IOAPIC for interrupt routing
> [    0.479727] ACPI: No dock devices found.
> [    0.483655] PCI: Using host bridge windows from ACPI; if necessary, use "pci=                                                                                                                                nocrs" and report a bug
> [    0.492811] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
> [    0.499026] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
> [    0.505632] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> [    0.512244] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bfff                                                                                                                                f]
> [    0.519547] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dfff                                                                                                                                f]
> [    0.526844] pci_root PNP0A03:00: host bridge window [mem 0x7f800000-0xfebffff                                                                                                                                f]
> [    0.534171] PCI host bridge to bus 0000:00
> [    0.538264] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.544442] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.550618] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.557481] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
> [    0.564351] pci_bus 0000:00: root bus resource [mem 0x7f800000-0xfebfffff]
> [    0.574184] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.579449] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    0.586181] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> [    0.591661] pci 0000:00:1c.3: PCI bridge to [bus 04-05] (subtractive decode)
> [    0.598866] pci 0000:04:00.0: PCI bridge to [bus 05-05] (subtractive decode)
> [    0.608172] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
> [    0.615168] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
> [    0.620741]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.626394]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned co                                                                                                                                ntrol mask: 0x1d
> [    0.634909] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    0.645330] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 *12 14 15                                                                                                                                )
> [    0.652794] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15                                                                                                                                )
> [    0.660270] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15                                                                                                                                )
> [    0.667730] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15                                                                                                                                )
> [    0.675190] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15)                                                                                                                                 *0, disabled.
> [    0.683812] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15)                                                                                                                                 *0, disabled.
> [    0.692433] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 14 15)                                                                                                                                 *0, disabled.
> [    0.701052] ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15                                                                                                                                )
> [    0.708552] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem                                                                                                                                ,locks=none
> [    0.716637] vgaarb: loaded
> [    0.719346] vgaarb: bridge control possible 0000:01:00.0
> [    0.724708] SCSI subsystem initialized
> [    0.728503] usbcore: registered new interface driver usbfs
> [    0.733989] usbcore: registered new interface driver hub
> [    0.739307] usbcore: registered new device driver usb
> [    0.744389] PCI: Using ACPI for IRQ routing
> [    0.750070] NetLabel: Initializing
> [    0.753467] NetLabel:  domain hash size = 128
> [    0.757816] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.762779] NetLabel:  unlabeled traffic allowed by default
> [    0.773478] pnp: PnP ACPI init
> [    0.776543] ACPI: bus type pnp registered
> [    0.780754] system 00:01: [io  0x04d0-0x04d1] has been reserved
> [    0.786673] system 00:01: [io  0x0290-0x029f] has been reserved
> [    0.792589] system 00:01: [io  0x0800-0x087f] has been reserved
> [    0.798508] system 00:01: [io  0x0290-0x0294] has been reserved
> [    0.804425] system 00:01: [io  0x0880-0x088f] has been reserved
> [    0.810996] system 00:0a: [io  0x0400-0x04cf] has been reserved
> [    0.816912] system 00:0a: [io  0x04d2-0x04ff] has been reserved
> [    0.822866] system 00:0b: [io  0x1000-0x107f] has been reserved
> [    0.828784] system 00:0b: [io  0x1080-0x10ff] has been reserved
> [    0.834699] system 00:0b: [io  0x1100-0x117f] has been reserved
> [    0.840617] system 00:0b: [io  0x1180-0x11ff] has been reserved
> [    0.846673] system 00:0c: [io  0x0454-0x0457] has been reserved
> [    0.852627] system 00:0d: [mem 0xf0000000-0xf3ffffff] has been reserved
> [    0.859409] system 00:0e: [mem 0x000ce400-0x000cffff] has been reserved
> [    0.866013] system 00:0e: [mem 0x000f0000-0x000f7fff] could not be reserved
> [    0.872963] system 00:0e: [mem 0x000f8000-0x000fbfff] could not be reserved
> [    0.879913] system 00:0e: [mem 0x000fc000-0x000fffff] could not be reserved
> [    0.886870] system 00:0e: [mem 0x7efa0000-0x7efaffff] could not be reserved
> [    0.893828] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.900786] system 00:0e: [mem 0x00100000-0x7ef9ffff] could not be reserved
> [    0.907742] system 00:0e: [mem 0x7efb0000-0x7efcffff] could not be reserved
> [    0.914693] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    0.921649] system 00:0e: [mem 0xfed10000-0xfed1dfff] has been reserved
> [    0.928252] system 00:0e: [mem 0xfed20000-0xfed8ffff] has been reserved
> [    0.934863] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.941466] system 00:0e: [mem 0xffb00000-0xffb7ffff] has been reserved
> [    0.948077] system 00:0e: [mem 0xfff00000-0xffffffff] has been reserved
> [    0.954680] system 00:0e: [mem 0x000e0000-0x000effff] has been reserved
> [    0.961291] system 00:0e: [mem 0x20000000-0x201fffff] could not be reserved
> [    0.968250] system 00:0e: [mem 0x40000000-0x400fffff] could not be reserved
> [    0.975206] system 00:0e: [mem 0x7f000000-0x7f7fffff] could not be reserved
> [    0.982195] pnp: PnP ACPI: found 16 devices
> [    0.986374] ACPI: ACPI bus type pnp unregistered
> [    1.026725] Switching to clocksource acpi_pm
> [    1.031073] pci 0000:00:1c.0: BAR 14: assigned [mem 0x7f800000-0x7f9fffff]
> [    1.037946] pci 0000:00:1c.0: BAR 15: assigned [mem 0x7fa00000-0x7fbfffff 64b                                                                                                                                it pref]
> [    1.045767] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
> [    1.051945] pci 0000:01:00.0: BAR 6: assigned [mem 0xf9000000-0xf901ffff pref                                                                                                                                ]
> [    1.059162] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    1.064388] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
> [    1.070477] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf9ffffff]
> [    1.077261] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bi                                                                                                                                t pref]
> [    1.085000] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    1.090225] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    1.096319] pci 0000:00:1c.0:   bridge window [mem 0x7f800000-0x7f9fffff]
> [    1.103475] pci 0000:00:1c.0:   bridge window [mem 0x7fa00000-0x7fbfffff 64bi                                                                                                                                t pref]
> [    1.111213] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> [    1.116438] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
> [    1.123225] pci 0000:04:00.0: PCI bridge to [bus 05-05]
> [    1.128467] pci 0000:00:1c.3: PCI bridge to [bus 04-05]
> [    1.133696] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
> [    1.138924] pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
> [    1.145711] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
> [    1.150939] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
> [    1.157034] pci 0000:00:1c.5:   bridge window [mem 0xfbe00000-0xfbefffff 64bi                                                                                                                                t pref]
> [    1.164783] pci 0000:00:1c.0: enabling device (0000 -> 0003)
> [    1.170550] NET: Registered protocol family 2
> [    1.174943] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    1.182157] TCP established hash table entries: 131072 (order: 8, 1048576 byt                                                                                                                                es)
> [    1.189748] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    1.196451] TCP: Hash tables configured (established 131072 bind 65536)
> [    1.203067] TCP: reno registered
> [    1.206298] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    1.212218] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    1.218614] NET: Registered protocol family 1
> [    1.245156] Unpacking initramfs...
> [    3.477744] Freeing initrd memory: 124496k freed
> [    3.498239] apm: BIOS not found.
> [    3.501781] audit: initializing netlink socket (disabled)
> [    3.507191] type=2000 audit(1335784075.780:1): initialized
> [    3.529860] highmem bounce pool size: 64 pages
> [    3.534305] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    3.541961] VFS: Disk quotas dquot_6.5.2
> [    3.545921] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    3.552757] msgmni has been set to 1712
> [    3.556955] alg: No test for stdrng (krng)
> [    3.561061] NET: Registered protocol family 38
> [    3.565531] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    3.572947] io scheduler noop registered
> [    3.576871] io scheduler deadline registered
> [    3.581146] io scheduler cfq registered (default)
> [    3.586115] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    3.591703] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    3.598317] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    3.605035] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> [    3.613206] ACPI: Power Button [PWRB]
> [    3.616898] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    3.624285] ACPI: Power Button [PWRF]
> [    3.628056] ACPI: Requesting acpi_cpufreq
> [    3.634631] GHES: HEST is not enabled!
> [    3.638391] isapnp: Scanning for PnP cards...
> [    4.000774] isapnp: No Plug & Play device found
> [    4.005374] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    4.032193] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    4.058973] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    4.064756] hpet_acpi_add: no address or irqs in _CRS
> [    4.069833] Non-volatile memory driver v1.3
> [    4.074018] Linux agpgart interface v0.103
> [    4.078739] loop: module loaded
> [    4.081946] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [    4.237605] scsi0 : ata_piix
> [    4.240589] scsi1 : ata_piix
> [    4.243750] ata2: SATA max UDMA/133 cmd 0xff00 ctl 0xfe00 bmdma 0xfb00 irq 19
> [    4.250884] ata3: SATA max UDMA/133 cmd 0xfd00 ctl 0xfc00 bmdma 0xfb08 irq 19
> [    4.258025] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> [    4.263421] scsi2 : ata_piix
> [    4.266349] scsi3 : ata_piix
> [    4.269459] ata4: SATA max UDMA/133 cmd 0xf800 ctl 0xf700 bmdma 0xf400 irq 19
> [    4.276591] ata5: SATA max UDMA/133 cmd 0xf600 ctl 0xf500 bmdma 0xf408 irq 19
> [    4.283764] Fixed MDIO Bus: probed
> [    4.287217] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    4.293765] ehci_hcd 0000:00:1a.0: EHCI Host Controller
> [    4.299031] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    4.306438] ehci_hcd 0000:00:1a.0: debug port 2
> [    4.314877] ehci_hcd 0000:00:1a.0: irq 18, io mem 0xfbffe000
> [    4.326328] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    4.332097] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.338879] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.346098] usb usb1: Product: EHCI Host Controller
> [    4.350976] usb usb1: Manufacturer: Linux 3.4.0-rc4 ehci_hcd
> [    4.356633] usb usb1: SerialNumber: 0000:00:1a.0
> [    4.361340] hub 1-0:1.0: USB hub found
> [    4.365093] hub 1-0:1.0: 2 ports detected
> [    4.369152] ehci_hcd 0000:00:1d.0: EHCI Host Controller
> [    4.374417] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    4.381820] ehci_hcd 0000:00:1d.0: debug port 2
> [    4.390239] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfbffd000
> [    4.401311] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    4.407068] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.413855] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.421072] usb usb2: Product: EHCI Host Controller
> [    4.425950] usb usb2: Manufacturer: Linux 3.4.0-rc4 ehci_hcd
> [    4.431610] usb usb2: SerialNumber: 0000:00:1d.0
> [    4.436334] hub 2-0:1.0: USB hub found
> [    4.440086] hub 2-0:1.0: 2 ports detected
> [    4.444146] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    4.450332] uhci_hcd: USB Universal Host Controller Interface driver
> [    4.456707] usbcore: registered new interface driver usbserial
> [    4.462547] usbcore: registered new interface driver usbserial_generic
> [    4.469089] USB Serial support registered for generic
> [    4.474143] usbserial: USB Serial Driver core
> [    4.478532] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    4.485313] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [    4.495706] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    4.500673] Refined TSC clocksource calibration: 3092.973 MHz.
> [    4.504344] mousedev: PS/2 mouse device common for all mice
> [    4.504495] rtc_cmos 00:04: RTC can wake from S4
> [    4.504661] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> [    4.504695] rtc0: alarms up to one month, 242 bytes nvram
> [    4.504737] device-mapper: uevent: version 1.0.3
> [    4.504798] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    4.504904] cpuidle: using governor ladder
> [    4.545286] Switching to clocksource tsc
> [    4.545362] cpuidle: using governor menu
> [    4.545528] EFI Variables Facility v0.08 2004-May-17
> [    4.545642] usbcore: registered new interface driver usbhid
> [    4.545643] usbhid: USB HID core driver
> [    4.545735] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    4.545747] TCP: cubic registered
> [    4.545748] Initializing XFRM netlink socket
> [    4.545844] NET: Registered protocol family 10
> [    4.546015] Mobile IPv6
> [    4.546017] NET: Registered protocol family 17
> [    4.546027] Registering the dns_resolver key type
> [    4.546153] Using IPI No-Shortcut mode
> [    4.546260] registered taskstats version 1
> [    4.546456] IMA: No TPM chip found, activating TPM-bypass!
> [    4.546931]   Magic number: 8:472:126
> [    4.546959] acpi device:01: hash matches
> [    4.603401] ata5: SATA link down (SStatus 0 SControl 300)
> [    4.614387] ata4: SATA link down (SStatus 0 SControl 300)
> [    4.628029] rtc_cmos 00:04: setting system clock to 2012-04-30 11:07:58 UTC (1335784078)
> [    4.636690] Initializing network drop monitor service
> [    4.651801] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> [    4.737354] usb 1-1: new high-speed USB device number 2 using ehci_hcd
> [    4.857623] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    4.864338] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    4.871789] hub 1-1:1.0: USB hub found
> [    4.875770] hub 1-1:1.0: 4 ports detected
> [    4.982248] usb 2-1: new high-speed USB device number 2 using ehci_hcd
> [    5.102566] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    5.109279] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    5.116721] hub 2-1:1.0: USB hub found
> [    5.120523] hub 2-1:1.0: 6 ports detected
> [    5.198307] usb 1-1.4: new low-speed USB device number 3 using ehci_hcd
> [    5.294899] usb 1-1.4: New USB device found, idVendor=046d, idProduct=c06a
> [    5.301784] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    5.309095] usb 1-1.4: Product: USB Optical Mouse
> [    5.313794] usb 1-1.4: Manufacturer: Logitech
> [    5.320372] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input3
> [    5.331505] generic-usb 0003:046D:C06A.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1.4/input0
> [    5.569101] ata2.01: failed to resume link (SControl 0)
> [    5.574406] ata3.01: failed to resume link (SControl 0)
> [    5.590580] ata3.00: SATA link down (SStatus 0 SControl 300)
> [    5.596253] ata3.01: SATA link down (SStatus 0 SControl 0)
> [    5.725153] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    5.731613] ata2.01: SATA link down (SStatus 0 SControl 0)
> [    5.740469] ata2.00: ATA-8: WDC WD3200AAKS-00V1A0, 05.01D05, max UDMA/133
> [    5.747262] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    5.757839] ata2.00: configured for UDMA/133
> [    5.762367] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0 05.0 PQ: 0 ANSI: 5
> [    5.770685] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
> [    5.770689] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    5.783565] sd 0:0:0:0: [sda] Write Protect is off
> [    5.788391] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.831743]  sda: sda1 sda2
> [    5.834797] sd 0:0:0:0: [sda] Attached SCSI disk
> [    5.839690] Freeing unused kernel memory: 604k freed
> [    5.844863] Write protecting the kernel text: 4356k
> [    5.849849] Write protecting the kernel read-only data: 2100k
> [    5.855595] NX-protecting the kernel data: 3836k
> [    6.087436] dracut: dracut-013-22.fc16
> [    6.100594] dracut: rd.luks=0: removing cryptoluks activation
> [    6.109526] dracut: rd.lvm=0: removing LVM activation
> [    6.119662] udevd[114]: starting version 173
> [    6.138556] wmi: Mapper loaded
> [    6.150624] [drm] Initialized drm 1.1.0 20060810
> [    6.177134] VGA switcheroo: detected Optimus DSM method \ handle
> [    6.183547] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x298200a2)
> [    6.193229] [drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
> [    6.248893] [drm] nouveau 0000:01:00.0: ... appears to be valid
> [    6.254816] [drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
> [    6.260737] [drm] nouveau 0000:01:00.0: BIT BIOS found
> [    6.265874] [drm] nouveau 0000:01:00.0: Bios version 62.98.42.00
> [    6.271879] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
> [    6.278039] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
> [    6.284829] [drm] nouveau 0000:01:00.0: DCB version 4.0
> [    6.290059] [drm] nouveau 0000:01:00.0: DCB outp 00: 02000300 00000028
> [    6.296582] [drm] nouveau 0000:01:00.0: DCB outp 01: 01000302 00020030
> [    6.303105] [drm] nouveau 0000:01:00.0: DCB outp 02: 04011310 00000028
> [    6.309629] [drm] nouveau 0000:01:00.0: DCB outp 03: 010223f1 00c0c080
> [    6.316154] [drm] nouveau 0000:01:00.0: DCB conn 00: 00001030
> [    6.321922] [drm] nouveau 0000:01:00.0: DCB conn 01: 00000200
> [    6.327694] [drm] nouveau 0000:01:00.0: DCB conn 02: 00000110
> [    6.333464] [drm] nouveau 0000:01:00.0: DCB conn 03: 00000111
> [    6.339237] [drm] nouveau 0000:01:00.0: DCB conn 04: 00000113
> [    6.345009] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD5EA
> [    6.377954] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD99C
> [    6.391946] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE24B
> [    6.399600] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE33D
> [    6.408333] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE54D
> [    6.415980] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xE5B2
> [    6.443456] [drm] nouveau 0000:01:00.0: 0xE5B2: Condition still not met after 20ms, skipping following opcodes
> [    6.456463] [TTM] Zone  kernel: Available graphics memory: 438670 kiB
> [    6.462904] [TTM] Zone highmem: Available graphics memory: 1025234 kiB
> [    6.469432] [TTM] Initializing pool allocator
> [    6.473804] [TTM] Initializing DMA pool allocator
> [    6.478517] [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM (DDR2)
> [    6.486521] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
> [    6.504699] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
> [    6.510449] [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
> [    6.518056] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    6.524671] [drm] No driver support for vblank timestamp query.
> [    6.553641] [drm] nouveau 0000:01:00.0: 1 available performance level(s)
> [    6.560333] [drm] nouveau 0000:01:00.0: 3: core 567MHz shader 1400MHz memory 400MHz fanspeed 100%
> [    6.569195] [drm] nouveau 0000:01:00.0: c: core 566MHz shader 1400MHz memory 499MHz
> [    6.673843] [drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x320000, bo ef9c8a00
> [    6.681729] fbcon: nouveaufb (fb0) is primary device
> [    6.705448] Console: switching to colour frame buffer device 180x56
> [    6.713136] fb0: nouveaufb frame buffer device
> [    6.717579] drm: registered panic notifier
> [    6.721681] [drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
> [    6.735234] dracut: Starting plymouth daemon
> [    6.777007] dracut: rd.dm=0: removing DM RAID activation
> [    6.787177] dracut: rd.md=0: removing MD RAID activation
> [    7.113215] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    7.226027] dracut: Checking ext4: /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0
> [    7.234300] dracut: issuing e2fsck -a  /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0
> [    7.309133] dracut: /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0: clean, 334977/19275776 files, 5631592/77094144 blocks
> [    7.321044] dracut: Remounting /dev/disk/by-uuid/81a1176f-441f-4d71-948b-c2458a3586f0 with -o ro
> [    7.357081] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    7.381078] dracut: Mounted root filesystem /dev/sda1
> [    7.561558] dracut: Switching root
> [    7.898292] SELinux:  Disabled at runtime.
> [    7.902827] type=1404 audit(1335784081.856:2): selinux=0 auid=4294967295 ses=4294967295
> [    7.951884] systemd[1]: RTC configured in localtime, applying delta of 480 minutes to system time.
> [    7.980320] systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
> 
> Welcome to Fedora release 16 (Verne)!
> 
> [    8.006443] systemd[1]: Set hostname to <ga-p61-fc16>.
> Starting Replay Read-Ahead Data...
> Starting Collect Read-Ahead Data...
> Starting Syslog Kernel Log Buffer Bridge...
> Started Syslog Kernel Log Buffer Bridge                                [  OK  ]
> Started Lock Directory                                                 [  OK  ]
> Starting Media Directory...
> Starting Software RAID Monitor Takeover...
> Starting POSIX Message Queue File System...
> Starting Debug File System...
> Starting Security File System...
> Starting Huge Pages File System...
> Starting RPC Pipe File System...
> Starting udev Kernel Device Manager...
> Starting udev Coldplug all Devices...
> Started Runtime Directory                                              [  OK  ]
> Starting STDOUT Syslog Bridge...
> Started STDOUT Syslog Bridge                                           [  OK  ]
> Started Replay Read-Ahead Data                                         [  OK  ]
> Started Collect Read-Ahead Data                                        [  OK  ]
> [    9.700342] systemd-readahead-replay[357]: Bumped block_nr parameter of 8:0 to 16384. This is a temporary hack and should be removed one day.
> Starting Load legacy module configuration...
> Starting Remount API VFS...
> Started File System Check on Root Device                               [  OK  ]
> Starting Remount Root FS...
> [   11.356479] udevd[368]: starting version 173
> Started Set Up Additional Binary Formats                               [  OK  ]
> Starting Apply Kernel Variables...
> [   14.429900] RPC: Registered named UNIX socket transport module.
> [   14.435832] RPC: Registered udp transport module.
> [   14.440541] RPC: Registered tcp transport module.
> [   14.445253] RPC: Registered tcp NFSv4.1 backchannel transport module.
> Started Load Kernel Modules                                            [  OK  ]
> Started FUSE Control File System                                       [  OK  ]
> Started Configuration File System                                      [  OK  ]
> Starting Setup Virtual Console...
> Started udev Kernel Device Manager                                     [  OK  ]
> Started Media Directory                                                [  OK  ]
> Started Software RAID Monitor Takeover                                 [  OK  ]
> Started POSIX Message Queue File[   14.529012] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x14
>  System                                [  OK  ]
> Started Debug File System                                              [  OK  ]
> Started Security File System                          [   14.553689] microcode: CPU0 updated to revision 0x25, date = 2011-10-11
> [   14.560770] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x14
>                  [  OK   microcode: CPU1 updated to revision 0x25, date = 2011-10-11
> [   14.572183] mtp-probe[492]: checking bus 1, device 3: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4"
> [0m]
> Started H[   14.585907] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x14
> uge Pages File System           [   14.594428] microcode: CPU2 updated to revision 0x25, date = 2011-10-11
>                 [   14.602487] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x14
>               [  OK  [   14.611696] microcode: CPU3 updated to revision 0x25, date = 2011-10-11
> ]
> Started RPC [   14.619133] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   14.619976] input: PC Speaker as /devices/platform/pcspkr/input/input4
> Pipe File System                                           [  OK  ]
> Started Remount API VFS                                        [   14.647111] mtp-probe[492]: bus: 1, device: 3 was not an MTP device
>         [  OK  ]
> Started Apply Kernel Variables                                         [  OK  ]
> Started udev Coldplug all Devices                                      [  OK  ]
> Starting udev Wait for Complete Device Initialization...
> Started Load legacy module configuration                               [  OK  ]
> Started Setup Virtual Console                                          [  OK  ]
> [   14.766628] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [   14.771931] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
> [   14.779396] xHCI capability registers at fcea0000:
> [   14.784187] CAPLENGTH AND HCIVERSION 0x1000080:
> [   14.788717] CAPLENGTH: 0x80
> [   14.791516] HCIVERSION: 0x100
> [   14.794489] HCSPARAMS 1: 0x8000820
> [   14.797914]   Max device slots: 32
> [   14.801327]   Max interrupters: 8
> [   14.804654]   Max ports: 8
> [   14.807363] HCSPARAMS 2: 0x84000054
> [   14.810856]   Isoc scheduling threshold: 4
> [   14.814953]   Maximum allowed segments in event ring: 5
> [   14.820171] HCSPARAMS 3 0x40001:
> [   14.823401]   Worst case U1 device exit latency: 1
> [   14.828183]   Worst case U2 device exit latency: 4
> [   14.832980] HCC PARAMS 0x200071a1:
> [   14.836380]   HC generates 64 bit addresses
> [   14.840558]   FIXME: more HCCPARAMS debugging
> [   14.844926] RTSOFF 0x2000:
> [   14.847648] xHCI operational registers at fcea0080:
> [   14.852535] USBCMD 0x0:
> [   14.854998]   HC is being stopped
> [   14.858374]   HC has finished hard reset
> [   14.862298]   Event Interrupts disabled
> [   14.866136]   Host System Error Interrupts disabled
> [   14.871014]   HC has finished light reset
> [   14.875026] USBSTS 0x11:
> [   14.877563]   Event ring is empty
> [   14.880873]   No Host System Error
> [   14.884288]   HC is halted
> [   14.884291] fcea0480 port status reg = 0xa0002a0
> [   14.884294] fcea0484 port power reg = 0x8
> [   14.884298] fcea0488 port link reg = 0x0
> [   14.884301] fcea048c port reserved reg = 0x0
> [   14.884304] fcea0490 port status reg = 0xa0002a0
> [   14.884307] fcea0494 port power reg = 0x8
> [   14.884310] fcea0498 port link reg = 0x0
> [   14.884314] fcea049c port reserved reg = 0x0
> [   14.884319] fcea04a0 port status reg = 0xa0002a0
> [   14.884321] fcea04a4 port power reg = 0x8
> [   14.884325] fcea04a8 port link reg = 0x0
> [   14.884329] fcea04ac port reserved reg = 0x0
> [   14.884332] fcea04b0 port status reg = 0xa0002a0
> [   14.884336] fcea04b4 port power reg = 0x8
> [   14.884340] fcea04b8 port link reg = 0x0
> [   14.884344] fcea04bc port reserved reg = 0x0
> [   14.884347] fcea04c0 port status reg = 0x2a0
> [   14.884351] fcea04c4 port power reg = 0x0
> [   14.884355] fcea04c8 port link reg = 0x0
> [   14.884360] fcea04cc port reserved reg = 0x0
> [   14.884364] fcea04d0 port status reg = 0x2a0
> [   14.884369] fcea04d4 port power reg = 0x0
> [   14.884373] fcea04d8 port link reg = 0x0
> [   14.884377] fcea04dc port reserved reg = 0x0
> [   14.884379] fcea04e0 port status reg = 0x1020340
> [   14.884382] fcea04e4 port power reg = 0x0
> [   14.884386] fcea04e8 port link reg = 0x0
> [   14.884391] fcea04ec port reserved reg = 0x0
> [   14.884395] fcea04f0 port status reg = 0x2a0
> [   14.884400] fcea04f4 port power reg = 0x0
> [   14.884402] fcea04f8 port link reg = 0x0
> [   14.884406] fcea04fc port reserved reg = 0x0
> [   14.884407] // Halt the HC
> [   14.884416] Resetting HCD
> [   14.884418] // Reset the HC
> [   14.884524] Wait for controller to be ready for doorbell rings
> [   14.884526] Reset complete
> [   14.884529] Enabling 64-bit DMA addresses.
> [   14.884530] Calling HCD init
> [   14.884530] xhci_init
> [   14.884531] xHCI doesn't need link TRB QUIRK
> [   14.884534] Supported page size register = 0x1
> [   14.884535] Supported page size of 4K
> [   14.884536] HCD page size set to 4K
> [   14.884538] // xHC can handle at most 32 device slots.
> [   14.884541] // Setting Max device slots reg = 0x20.
> [   14.884549] // Device context base array address = 0x2f92e000 (DMA), ef92e000 (virt)
> [   14.884554] Allocated command ring at ef84bea0
> [   14.884555] First segment DMA is 0x2f1cc000
> [   14.884560] // Setting command ring address to 0x20
> [   14.884566] // xHC command ring deq ptr low bits + flags = @00000000
> [   14.884567] // xHC command ring deq ptr high bits = @00000000
> [   14.884569] // Doorbell array is located at offset 0x3000 from cap regs base addr
> [   14.884570] // xHCI capability registers at fcea0000:
> [   14.884573] // @fcea0000 = 0x1000080 (CAPLENGTH AND HCIVERSION)
> [   14.884574] //   CAPLENGTH: 0x80
> [   14.884574] // xHCI operational registers at fcea0080:
> [   14.884578] // @fcea0018 = 0x2000 RTSOFF
> [   14.884579] // xHCI runtime registers at fcea2000:
> [   14.884581] // @fcea0014 = 0x3000 DBOFF
> [   14.884582] // Doorbell array at fcea3000:
> [   14.884583] xHCI runtime registers at fcea2000:
> [   14.884587]   fcea2000: Microframe index = 0x0
> [   14.884613] // Allocating event ring
> [   14.884616] TRB math tests passed.
> [   14.884617] // Allocated event ring segment table at 0x2fbf3000
> [   14.884618] Set ERST to 0; private num segs = 1, virt addr = efbf3000, dma addr = 0x2fbf3000
> [   14.884621] // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [   14.884622] // Set ERST entries to point to event ring.
> [   14.884623] // Set ERST base address for ir_set 0 = 0x2fbf3000
> [   14.884635] // Write event ring dequeue pointer, preserving EHB bit
> [   14.884635] Wrote ERST address to ir_set 0.
> [   14.884638] Allocating 16 scratchpad buffers
> [   14.884654] Ext Cap fcea8000, port offset = 1, count = 4, revision = 0x2
> [   14.884655] xHCI 1.0: support USB2 software lpm
> [   14.884656] xHCI 1.0: support USB2 hardware lpm
> [   14.884662] Ext Cap fcea8020, port offset = 5, count = 4, revision = 0x3
> [   14.884663] Found 4 USB 2.0 ports and 4 USB 3.0 ports.
> [   14.884664] USB 2.0 port at index 0, addr = fcea0480
> [   14.884665] USB 2.0 port at index 1, addr = fcea0490
> [   14.884666] USB 2.0 port at index 2, addr = fcea04a0
> [   14.884667] USB 2.0 port at index 3, addr = fcea04b0
> [   14.884668] USB 3.0 port at index 4, addr = fcea04c0
> [   14.884669] USB 3.0 port at index 5, addr = fcea04d0
> [   14.884670] USB 3.0 port at index 6, addr = fcea04e0
> [   14.884671] USB 3.0 port at index 7, addr = fcea04f0
> [   14.884674] Finished xhci_init
> [   14.884675] Called HCD init
> [   14.884677] Got SBRN 48
> [   14.884686] MWI active
> [   14.884686] Finished xhci_pci_reinit
> [   14.884701] xhci_hcd 0000:03:00.0: irq 17, io mem 0xfbde0000
> [   14.884702] xhci_run
> [   14.884888] Setting event ring polling timer
> [   14.884889] Command ring memory map follows:
> [   14.884891] @000000002f1cc000 00000000 00000000 00000000 00000000
> [   14.884892] @000000002f1cc010 00000000 00000000 00000000 00000000
> [   14.884893] @000000002f1cc020 00000000 00000000 00000000 00000000
> [   14.884894] @000000002f1cc030 00000000 00000000 00000000 00000000
> [   14.884895] @000000002f1cc040 00000000 00000000 00000000 00000000
> [   14.884896] @000000002f1cc050 00000000 00000000 00000000 00000000
> [   14.884897] @000000002f1cc060 00000000 00000000 00000000 00000000
> [   14.884898] @000000002f1cc070 00000000 00000000 00000000 00000000
> [   14.884899] @000000002f1cc080 00000000 00000000 00000000 00000000
> [   14.884900] @000000002f1cc090 00000000 00000000 00000000 00000000
> [   14.884901] @000000002f1cc0a0 00000000 00000000 00000000 00000000
> [   14.884902] @000000002f1cc0b0 00000000 00000000 00000000 00000000
> [   14.884903] @000000002f1cc0c0 00000000 00000000 00000000 00000000
> [   14.884905] @000000002f1cc0d0 00000000 00000000 00000000 00000000
> [   14.884906] @000000002f1cc0e0 00000000 00000000 00000000 00000000
> [   14.884907] @000000002f1cc0f0 00000000 00000000 00000000 00000000
> [   14.884908] @000000002f1cc100 00000000 00000000 00000000 00000000
> [   14.884909] @000000002f1cc110 00000000 00000000 00000000 00000000
> [   14.884910] @000000002f1cc120 00000000 00000000 00000000 00000000
> [   14.884911] @000000002f1cc130 00000000 00000000 00000000 00000000
> [   14.884912] @000000002f1cc140 00000000 00000000 00000000 00000000
> [   14.884913] @000000002f1cc150 00000000 00000000 00000000 00000000
> [   14.884914] @000000002f1cc160 00000000 00000000 00000000 00000000
> [   14.884915] @000000002f1cc170 00000000 00000000 00000000 00000000
> [   14.884916] @000000002f1cc180 00000000 00000000 00000000 00000000
> [   14.884917] @000000002f1cc190 00000000 00000000 00000000 00000000
> [   14.884918] @000000002f1cc1a0 00000000 00000000 00000000 00000000
> [   14.884920] @000000002f1cc1b0 00000000 00000000 00000000 00000000
> [   14.884921] @000000002f1cc1c0 00000000 00000000 00000000 00000000
> [   14.884922] @000000002f1cc1d0 00000000 00000000 00000000 00000000
> [   14.884923] @000000002f1cc1e0 00000000 00000000 00000000 00000000
> [   14.884924] @000000002f1cc1f0 00000000 00000000 00000000 00000000
> [   14.884925] @000000002f1cc200 00000000 00000000 00000000 00000000
> [   14.884926] @000000002f1cc210 00000000 00000000 00000000 00000000
> [   14.884927] @000000002f1cc220 00000000 00000000 00000000 00000000
> [   14.884928] @000000002f1cc230 00000000 00000000 00000000 00000000
> [   14.884929] @000000002f1cc240 00000000 00000000 00000000 00000000
> [   14.884930] @000000002f1cc250 00000000 00000000 00000000 00000000
> [   14.884931] @000000002f1cc260 00000000 00000000 00000000 00000000
> [   14.884932] @000000002f1cc270 00000000 00000000 00000000 00000000
> [   14.884933] @000000002f1cc280 00000000 00000000 00000000 00000000
> [   14.884934] @000000002f1cc290 00000000 00000000 00000000 00000000
> [   14.884936] @000000002f1cc2a0 00000000 00000000 00000000 00000000
> [   14.884937] @000000002f1cc2b0 00000000 00000000 00000000 00000000
> [   14.884938] @000000002f1cc2c0 00000000 00000000 00000000 00000000
> [   14.884939] @000000002f1cc2d0 00000000 00000000 00000000 00000000
> [   14.884940] @000000002f1cc2e0 00000000 00000000 00000000 00000000
> [   14.884941] @000000002f1cc2f0 00000000 00000000 00000000 00000000
> [   14.884942] @000000002f1cc300 00000000 00000000 00000000 00000000
> [   14.884943] @000000002f1cc310 00000000 00000000 00000000 00000000
> [   14.884944] @000000002f1cc320 00000000 00000000 00000000 00000000
> [   14.884945] @000000002f1cc330 00000000 00000000 00000000 00000000
> [   14.884946] @000000002f1cc340 00000000 00000000 00000000 00000000
> [   14.884947] @000000002f1cc350 00000000 00000000 00000000 00000000
> [   14.884948] @000000002f1cc360 00000000 00000000 00000000 00000000
> [   14.884949] @000000002f1cc370 00000000 00000000 00000000 00000000
> [   14.884950] @000000002f1cc380 00000000 00000000 00000000 00000000
> [   14.884951] @000000002f1cc390 00000000 00000000 00000000 00000000
> [   14.884953] @000000002f1cc3a0 00000000 00000000 00000000 00000000
> [   14.884954] @000000002f1cc3b0 00000000 00000000 00000000 00000000
> [   14.884955] @000000002f1cc3c0 00000000 00000000 00000000 00000000
> [   14.884956] @000000002f1cc3d0 00000000 00000000 00000000 00000000
> [   14.884957] @000000002f1cc3e0 00000000 00000000 00000000 00000000
> [   14.884958] @000000002f1cc3f0 00000000 00000000 00000000 00000000
> [   14.884959] @000000002f1cc400 00000000 00000000 00000000 00000000
> [   14.884960] @000000002f1cc410 00000000 00000000 00000000 00000000
> [   14.884961] @000000002f1cc420 00000000 00000000 00000000 00000000
> [   14.884962] @000000002f1cc430 00000000 00000000 00000000 00000000
> [   14.884963] @000000002f1cc440 00000000 00000000 00000000 00000000
> [   14.884964] @000000002f1cc450 00000000 00000000 00000000 00000000
> [   14.884966] @000000002f1cc460 00000000 00000000 00000000 00000000
> [   14.884967] @000000002f1cc470 00000000 00000000 00000000 00000000
> [   14.884968] @000000002f1cc480 00000000 00000000 00000000 00000000
> [   14.884969] @000000002f1cc490 00000000 00000000 00000000 00000000
> [   14.884970] @000000002f1cc4a0 00000000 00000000 00000000 00000000
> [   14.884971] @000000002f1cc4b0 00000000 00000000 00000000 00000000
> [   14.884972] @000000002f1cc4c0 00000000 00000000 00000000 00000000
> [   14.884973] @000000002f1cc4d0 00000000 00000000 00000000 00000000
> [   14.884974] @000000002f1cc4e0 00000000 00000000 00000000 00000000
> [   14.884975] @000000002f1cc4f0 00000000 00000000 00000000 00000000
> [   14.884976] @000000002f1cc500 00000000 00000000 00000000 00000000
> [   14.884977] @000000002f1cc510 00000000 00000000 00000000 00000000
> [   14.884978] @000000002f1cc520 00000000 00000000 00000000 00000000
> [   14.884979] @000000002f1cc530 00000000 00000000 00000000 00000000
> [   14.884980] @000000002f1cc540 00000000 00000000 00000000 00000000
> [   14.884981] @000000002f1cc550 00000000 00000000 00000000 00000000
> [   14.884983] @000000002f1cc560 00000000 00000000 00000000 00000000
> [   14.884984] @000000002f1cc570 00000000 00000000 00000000 00000000
> [   14.884994] @000000002f1cc580 00000000 00000000 00000000 00000000
> [   14.884996] @000000002f1cc590 00000000 00000000 00000000 00000000
> [   14.884997] @000000002f1cc5a0 00000000 00000000 00000000 00000000
> [   14.884998] @000000002f1cc5b0 00000000 00000000 00000000 00000000
> [   14.884999] @000000002f1cc5c0 00000000 00000000 00000000 00000000
> [   14.885000] @000000002f1cc5d0 00000000 00000000 00000000 00000000
> [   14.885001] @000000002f1cc5e0 00000000 00000000 00000000 00000000
> [   14.885002] @000000002f1cc5f0 00000000 00000000 00000000 00000000
> [   14.885003] @000000002f1cc600 00000000 00000000 00000000 00000000
> [   14.885004] @000000002f1cc610 00000000 00000000 00000000 00000000
> [   14.885005] @000000002f1cc620 00000000 00000000 00000000 00000000
> [   14.885007] @000000002f1cc630 00000000 00000000 00000000 00000000
> [   14.885008] @000000002f1cc640 00000000 00000000 00000000 00000000
> [   14.885009] @000000002f1cc650 00000000 00000000 00000000 00000000
> [   14.885010] @000000002f1cc660 00000000 00000000 00000000 00000000
> [   14.885011] @000000002f1cc670 00000000 00000000 00000000 00000000
> [   14.885012] @000000002f1cc680 00000000 00000000 00000000 00000000
> [   14.885013] @000000002f1cc690 00000000 00000000 00000000 00000000
> [   14.885014] @000000002f1cc6a0 00000000 00000000 00000000 00000000
> [   14.885015] @000000002f1cc6b0 00000000 00000000 00000000 00000000
> [   14.885016] @000000002f1cc6c0 00000000 00000000 00000000 00000000
> [   14.885017] @000000002f1cc6d0 00000000 00000000 00000000 00000000
> [   14.885018] @000000002f1cc6e0 00000000 00000000 00000000 00000000
> [   14.885019] @000000002f1cc6f0 00000000 00000000 00000000 00000000
> [   14.885020] @000000002f1cc700 00000000 00000000 00000000 00000000
> [   14.885021] @000000002f1cc710 00000000 00000000 00000000 00000000
> [   14.885023] @000000002f1cc720 00000000 00000000 00000000 00000000
> [   14.885024] @000000002f1cc730 00000000 00000000 00000000 00000000
> [   14.885025] @000000002f1cc740 00000000 00000000 00000000 00000000
> [   14.885026] @000000002f1cc750 00000000 00000000 00000000 00000000
> [   14.885027] @000000002f1cc760 00000000 00000000 00000000 00000000
> [   14.885028] @000000002f1cc770 00000000 00000000 00000000 00000000
> [   14.885029] @000000002f1cc780 00000000 00000000 00000000 00000000
> [   14.885030] @000000002f1cc790 00000000 00000000 00000000 00000000
> [   14.885031] @000000002f1cc7a0 00000000 00000000 00000000 00000000
> [   14.885032] @000000002f1cc7b0 00000000 00000000 00000000 00000000
> [   14.885033] @000000002f1cc7c0 00000000 00000000 00000000 00000000
> [   14.885034] @000000002f1cc7d0 00000000 00000000 00000000 00000000
> [   14.885035] @000000002f1cc7e0 00000000 00000000 00000000 00000000
> [   14.885036] @000000002f1cc7f0 00000000 00000000 00000000 00000000
> [   14.885038] @000000002f1cc800 00000000 00000000 00000000 00000000
> [   14.885039] @000000002f1cc810 00000000 00000000 00000000 00000000
> [   14.885040] @000000002f1cc820 00000000 00000000 00000000 00000000
> [   14.885041] @000000002f1cc830 00000000 00000000 00000000 00000000
> [   14.885042] @000000002f1cc840 00000000 00000000 00000000 00000000
> [   14.885043] @000000002f1cc850 00000000 00000000 00000000 00000000
> [   14.885044] @000000002f1cc860 00000000 00000000 00000000 00000000
> [   14.885045] @000000002f1cc870 00000000 00000000 00000000 00000000
> [   14.885046] @000000002f1cc880 00000000 00000000 00000000 00000000
> [   14.885047] @000000002f1cc890 00000000 00000000 00000000 00000000
> [   14.885048] @000000002f1cc8a0 00000000 00000000 00000000 00000000
> [   14.885049] @000000002f1cc8b0 00000000 00000000 00000000 00000000
> [   14.885050] @000000002f1cc8c0 00000000 00000000 00000000 00000000
> [   14.885051] @000000002f1cc8d0 00000000 00000000 00000000 00000000
> [   14.885053] @000000002f1cc8e0 00000000 00000000 00000000 00000000
> [   14.885054] @000000002f1cc8f0 00000000 00000000 00000000 00000000
> [   14.885055] @000000002f1cc900 00000000 00000000 00000000 00000000
> [   14.885056] @000000002f1cc910 00000000 00000000 00000000 00000000
> [   14.885057] @000000002f1cc920 00000000 00000000 00000000 00000000
> [   14.885058] @000000002f1cc930 00000000 00000000 00000000 00000000
> [   14.885059] @000000002f1cc940 00000000 00000000 00000000 00000000
> [   14.885060] @000000002f1cc950 00000000 00000000 00000000 00000000
> [   14.885061] @000000002f1cc960 00000000 00000000 00000000 00000000
> [   14.885062] @000000002f1cc970 00000000 00000000 00000000 00000000
> [   14.885063] @000000002f1cc980 00000000 00000000 00000000 00000000
> [   14.885064] @000000002f1cc990 00000000 00000000 00000000 00000000
> [   14.885065] @000000002f1cc9a0 00000000 00000000 00000000 00000000
> [   14.885066] @000000002f1cc9b0 00000000 00000000 00000000 00000000
> [   14.885067] @000000002f1cc9c0 00000000 00000000 00000000 00000000
> [   14.885069] @000000002f1cc9d0 00000000 00000000 00000000 00000000
> [   14.885070] @000000002f1cc9e0 00000000 00000000 00000000 00000000
> [   14.885071] @000000002f1cc9f0 00000000 00000000 00000000 00000000
> [   14.885072] @000000002f1cca00 00000000 00000000 00000000 00000000
> [   14.885073] @000000002f1cca10 00000000 00000000 00000000 00000000
> [   14.885074] @000000002f1cca20 00000000 00000000 00000000 00000000
> [   14.885075] @000000002f1cca30 00000000 00000000 00000000 00000000
> [   14.885076] @000000002f1cca40 00000000 00000000 00000000 00000000
> [   14.885077] @000000002f1cca50 00000000 00000000 00000000 00000000
> [   14.885078] @000000002f1cca60 00000000 00000000 00000000 00000000
> [   14.885079] @000000002f1cca70 00000000 00000000 00000000 00000000
> [   14.885080] @000000002f1cca80 00000000 00000000 00000000 00000000
> [   14.885081] @000000002f1cca90 00000000 00000000 00000000 00000000
> [   14.885082] @000000002f1ccaa0 00000000 00000000 00000000 00000000
> [   14.885084] @000000002f1ccab0 00000000 00000000 00000000 00000000
> [   14.885085] @000000002f1ccac0 00000000 00000000 00000000 00000000
> [   14.885086] @000000002f1ccad0 00000000 00000000 00000000 00000000
> [   14.885087] @000000002f1ccae0 00000000 00000000 00000000 00000000
> [   14.885088] @000000002f1ccaf0 00000000 00000000 00000000 00000000
> [   14.885089] @000000002f1ccb00 00000000 00000000 00000000 00000000
> [   14.885090] @000000002f1ccb10 00000000 00000000 00000000 00000000
> [   14.885091] @000000002f1ccb20 00000000 00000000 00000000 00000000
> [   14.885092] @000000002f1ccb30 00000000 00000000 00000000 00000000
> [   14.885093] @000000002f1ccb40 00000000 00000000 00000000 00000000
> [   14.885094] @000000002f1ccb50 00000000 00000000 00000000 00000000
> [   14.885095] @000000002f1ccb60 00000000 00000000 00000000 00000000
> [   14.885096] @000000002f1ccb70 00000000 00000000 00000000 00000000
> [   14.885098] @000000002f1ccb80 00000000 00000000 00000000 00000000
> [   14.885099] @000000002f1ccb90 00000000 00000000 00000000 00000000
> [   14.885100] @000000002f1ccba0 00000000 00000000 00000000 00000000
> [   14.885101] @000000002f1ccbb0 00000000 00000000 00000000 00000000
> [   14.885102] @000000002f1ccbc0 00000000 00000000 00000000 00000000
> [   14.885103] @000000002f1ccbd0 00000000 00000000 00000000 00000000
> [   14.885104] @000000002f1ccbe0 00000000 00000000 00000000 00000000
> [   14.885105] @000000002f1ccbf0 00000000 00000000 00000000 00000000
> [   14.885106] @000000002f1ccc00 00000000 00000000 00000000 00000000
> [   14.885107] @000000002f1ccc10 00000000 00000000 00000000 00000000
> [   14.885108] @000000002f1ccc20 00000000 00000000 00000000 00000000
> [   14.885109] @000000002f1ccc30 00000000 00000000 00000000 00000000
> [   14.885110] @000000002f1ccc40 00000000 00000000 00000000 00000000
> [   14.885112] @000000002f1ccc50 00000000 00000000 00000000 00000000
> [   14.885113] @000000002f1ccc60 00000000 00000000 00000000 00000000
> [   14.885114] @000000002f1ccc70 00000000 00000000 00000000 00000000
> [   14.885115] @000000002f1ccc80 00000000 00000000 00000000 00000000
> [   14.885116] @000000002f1ccc90 00000000 00000000 00000000 00000000
> [   14.885117] @000000002f1ccca0 00000000 00000000 00000000 00000000
> [   14.885118] @000000002f1cccb0 00000000 00000000 00000000 00000000
> [   14.885119] @000000002f1cccc0 00000000 00000000 00000000 00000000
> [   14.885120] @000000002f1cccd0 00000000 00000000 00000000 00000000
> [   14.885121] @000000002f1ccce0 00000000 00000000 00000000 00000000
> [   14.885122] @000000002f1cccf0 00000000 00000000 00000000 00000000
> [   14.885123] @000000002f1ccd00 00000000 00000000 00000000 00000000
> [   14.885124] @000000002f1ccd10 00000000 00000000 00000000 00000000
> [   14.885125] @000000002f1ccd20 00000000 00000000 00000000 00000000
> [   14.885127] @000000002f1ccd30 00000000 00000000 00000000 00000000
> [   14.885128] @000000002f1ccd40 00000000 00000000 00000000 00000000
> [   14.885129] @000000002f1ccd50 00000000 00000000 00000000 00000000
> [   14.885130] @000000002f1ccd60 00000000 00000000 00000000 00000000
> [   14.885131] @000000002f1ccd70 00000000 00000000 00000000 00000000
> [   14.885132] @000000002f1ccd80 00000000 00000000 00000000 00000000
> [   14.885133] @000000002f1ccd90 00000000 00000000 00000000 00000000
> [   14.885134] @000000002f1ccda0 00000000 00000000 00000000 00000000
> [   14.885135] @000000002f1ccdb0 00000000 00000000 00000000 00000000
> [   14.885136] @000000002f1ccdc0 00000000 00000000 00000000 00000000
> [   14.885137] @000000002f1ccdd0 00000000 00000000 00000000 00000000
> [   14.885138] @000000002f1ccde0 00000000 00000000 00000000 00000000
> [   14.885139] @000000002f1ccdf0 00000000 00000000 00000000 00000000
> [   14.885140] @000000002f1cce00 00000000 00000000 00000000 00000000
> [   14.885141] @000000002f1cce10 00000000 00000000 00000000 00000000
> [   14.885143] @000000002f1cce20 00000000 00000000 00000000 00000000
> [   14.885144] @000000002f1cce30 00000000 00000000 00000000 00000000
> [   14.885145] @000000002f1cce40 00000000 00000000 00000000 00000000
> [   14.885146] @000000002f1cce50 00000000 00000000 00000000 00000000
> [   14.885147] @000000002f1cce60 00000000 00000000 00000000 00000000
> [   14.885148] @000000002f1cce70 00000000 00000000 00000000 00000000
> [   14.885149] @000000002f1cce80 00000000 00000000 00000000 00000000
> [   14.885150] @000000002f1cce90 00000000 00000000 00000000 00000000
> [   14.885151] @000000002f1ccea0 00000000 00000000 00000000 00000000
> [   14.885152] @000000002f1cceb0 00000000 00000000 00000000 00000000
> [   14.885153] @000000002f1ccec0 00000000 00000000 00000000 00000000
> [   14.885154] @000000002f1cced0 00000000 00000000 00000000 00000000
> [   14.885155] @000000002f1ccee0 00000000 00000000 00000000 00000000
> [   14.885157] @000000002f1ccef0 00000000 00000000 00000000 00000000
> [   14.885158] @000000002f1ccf00 00000000 00000000 00000000 00000000
> [   14.885159] @000000002f1ccf10 00000000 00000000 00000000 00000000
> [   14.885160] @000000002f1ccf20 00000000 00000000 00000000 00000000
> [   14.885161] @000000002f1ccf30 00000000 00000000 00000000 00000000
> [   14.885162] @000000002f1ccf40 00000000 00000000 00000000 00000000
> [   14.885163] @000000002f1ccf50 00000000 00000000 00000000 00000000
> [   14.885164] @000000002f1ccf60 00000000 00000000 00000000 00000000
> [   14.885165] @000000002f1ccf70 00000000 00000000 00000000 00000000
> [   14.885166] @000000002f1ccf80 00000000 00000000 00000000 00000000
> [   14.885167] @000000002f1ccf90 00000000 00000000 00000000 00000000
> [   14.885168] @000000002f1ccfa0 00000000 00000000 00000000 00000000
> [   14.885169] @000000002f1ccfb0 00000000 00000000 00000000 00000000
> [   14.885170] @000000002f1ccfc0 00000000 00000000 00000000 00000000
> [   14.885172] @000000002f1ccfd0 00000000 00000000 00000000 00000000
> [   14.885173] @000000002f1ccfe0 00000000 00000000 00000000 00000000
> [   14.885174] @000000002f1ccff0 2f1cc000 00000000 00000000 00001802
> [   14.885175]   Ring has not been updated
> [   14.885176] Ring deq = ef1cc000 (virt), 0x2f1cc000 (dma)
> [   14.885177] Ring deq updated 0 times
> [   14.885178] Ring enq = ef1cc000 (virt), 0x2f1cc000 (dma)
> [   14.885179] Ring enq updated 0 times
> [   14.885184] // xHC command ring deq ptr low bits + flags = @00000000
> [   14.885184] // xHC command ring deq ptr high bits = @00000000
> [   14.885185] ERST memory map follows:
> [   14.885186] @000000002fbf3000 2fb7f000 00000000 00000100 00000000
> [   14.885187] Event ring:
> [   14.885188] @000000002fb7f000 00000000 00000000 00000000 00000000
> [   14.885189] @000000002fb7f010 00000000 00000000 00000000 00000000
> [   14.885190] @000000002fb7f020 00000000 00000000 00000000 00000000
> [   14.885191] @000000002fb7f030 00000000 00000000 00000000 00000000
> [   14.885192] @000000002fb7f040 00000000 00000000 00000000 00000000
> [   14.885193] @000000002fb7f050 00000000 00000000 00000000 00000000
> [   14.885194] @000000002fb7f060 00000000 00000000 00000000 00000000
> [   14.885196] @000000002fb7f070 00000000 00000000 00000000 00000000
> [   14.885197] @000000002fb7f080 00000000 00000000 00000000 00000000
> [   14.885198] @000000002fb7f090 00000000 00000000 00000000 00000000
> [   14.885199] @000000002fb7f0a0 00000000 00000000 00000000 00000000
> [   14.885200] @000000002fb7f0b0 00000000 00000000 00000000 00000000
> [   14.885201] @000000002fb7f0c0 00000000 00000000 00000000 00000000
> [   14.885202] @000000002fb7f0d0 00000000 00000000 00000000 00000000
> [   14.885203] @000000002fb7f0e0 00000000 00000000 00000000 00000000
> [   14.885204] @000000002fb7f0f0 00000000 00000000 00000000 00000000
> [   14.885205] @000000002fb7f100 00000000 00000000 00000000 00000000
> [   14.885206] @000000002fb7f110 00000000 00000000 00000000 00000000
> [   14.885207] @000000002fb7f120 00000000 00000000 00000000 00000000
> [   14.885208] @000000002fb7f130 00000000 00000000 00000000 00000000
> [   14.885209] @000000002fb7f140 00000000 00000000 00000000 00000000
> [   14.885210] @000000002fb7f150 00000000 00000000 00000000 00000000
> [   14.885212] @000000002fb7f160 00000000 00000000 00000000 00000000
> [   14.885213] @000000002fb7f170 00000000 00000000 00000000 00000000
> [   14.885214] @000000002fb7f180 00000000 00000000 00000000 00000000
> [   14.885215] @000000002fb7f190 00000000 00000000 00000000 00000000
> [   14.885216] @000000002fb7f1a0 00000000 00000000 00000000 00000000
> [   14.885217] @000000002fb7f1b0 00000000 00000000 00000000 00000000
> [   14.885218] @000000002fb7f1c0 00000000 00000000 00000000 00000000
> [   14.885219] @000000002fb7f1d0 00000000 00000000 00000000 00000000
> [   14.885220] @000000002fb7f1e0 00000000 00000000 00000000 00000000
> [   14.885221] @000000002fb7f1f0 00000000 00000000 00000000 00000000
> [   14.885222] @000000002fb7f200 00000000 00000000 00000000 00000000
> [   14.885223] @000000002fb7f210 00000000 00000000 00000000 00000000
> [   14.885224] @000000002fb7f220 00000000 00000000 00000000 00000000
> [   14.885226] @000000002fb7f230 00000000 00000000 00000000 00000000
> [   14.885227] @000000002fb7f240 00000000 00000000 00000000 00000000
> [   14.885228] @000000002fb7f250 00000000 00000000 00000000 00000000
> [   14.885229] @000000002fb7f260 00000000 00000000 00000000 00000000
> [   14.885230] @000000002fb7f270 00000000 00000000 00000000 00000000
> [   14.885231] @000000002fb7f280 00000000 00000000 00000000 00000000
> [   14.885232] @000000002fb7f290 00000000 00000000 00000000 00000000
> [   14.885233] @000000002fb7f2a0 00000000 00000000 00000000 00000000
> [   14.885234] @000000002fb7f2b0 00000000 00000000 00000000 00000000
> [   14.885235] @000000002fb7f2c0 00000000 00000000 00000000 00000000
> [   14.885236] @000000002fb7f2d0 00000000 00000000 00000000 00000000
> [   14.885237] @000000002fb7f2e0 00000000 00000000 00000000 00000000
> [   14.885238] @000000002fb7f2f0 00000000 00000000 00000000 00000000
> [   14.885240] @000000002fb7f300 00000000 00000000 00000000 00000000
> [   14.885241] @000000002fb7f310 00000000 00000000 00000000 00000000
> [   14.885242] @000000002fb7f320 00000000 00000000 00000000 00000000
> [   14.885243] @000000002fb7f330 00000000 00000000 00000000 00000000
> [   14.885244] @000000002fb7f340 00000000 00000000 00000000 00000000
> [   14.885245] @000000002fb7f350 00000000 00000000 00000000 00000000
> [   14.885246] @000000002fb7f360 00000000 00000000 00000000 00000000
> [   14.885247] @000000002fb7f370 00000000 00000000 00000000 00000000
> [   14.885248] @000000002fb7f380 00000000 00000000 00000000 00000000
> [   14.885249] @000000002fb7f390 00000000 00000000 00000000 00000000
> [   14.885250] @000000002fb7f3a0 00000000 00000000 00000000 00000000
> [   14.885251] @000000002fb7f3b0 00000000 00000000 00000000 00000000
> [   14.885252] @000000002fb7f3c0 00000000 00000000 00000000 00000000
> [   14.885253] @000000002fb7f3d0 00000000 00000000 00000000 00000000
> [   14.885254] @000000002fb7f3e0 00000000 00000000 00000000 00000000
> [   14.885256] @000000002fb7f3f0 00000000 00000000 00000000 00000000
> [   14.885257] @000000002fb7f400 00000000 00000000 00000000 00000000
> [   14.885258] @000000002fb7f410 00000000 00000000 00000000 00000000
> [   14.885259] @000000002fb7f420 00000000 00000000 00000000 00000000
> [   14.885260] @000000002fb7f430 00000000 00000000 00000000 00000000
> [   14.885261] @000000002fb7f440 00000000 00000000 00000000 00000000
> [   14.885262] @000000002fb7f450 00000000 00000000 00000000 00000000
> [   14.885263] @000000002fb7f460 00000000 00000000 00000000 00000000
> [   14.885264] @000000002fb7f470 00000000 00000000 00000000 00000000
> [   14.885265] @000000002fb7f480 00000000 00000000 00000000 00000000
> [   14.885266] @000000002fb7f490 00000000 00000000 00000000 00000000
> [   14.885267] @000000002fb7f4a0 00000000 00000000 00000000 00000000
> [   14.885268] @000000002fb7f4b0 00000000 00000000 00000000 00000000
> [   14.885269] @000000002fb7f4c0 00000000 00000000 00000000 00000000
> [   14.885271] @000000002fb7f4d0 00000000 00000000 00000000 00000000
> [   14.885272] @000000002fb7f4e0 00000000 00000000 00000000 00000000
> [   14.885273] @000000002fb7f4f0 00000000 00000000 00000000 00000000
> [   14.885274] @000000002fb7f500 00000000 00000000 00000000 00000000
> [   14.885275] @000000002fb7f510 00000000 00000000 00000000 00000000
> [   14.885276] @000000002fb7f520 00000000 00000000 00000000 00000000
> [   14.885277] @000000002fb7f530 00000000 00000000 00000000 00000000
> [   14.885278] @000000002fb7f540 00000000 00000000 00000000 00000000
> [   14.885279] @000000002fb7f550 00000000 00000000 00000000 00000000
> [   14.885280] @000000002fb7f560 00000000 00000000 00000000 00000000
> [   14.885281] @000000002fb7f570 00000000 00000000 00000000 00000000
> [   14.885282] @000000002fb7f580 00000000 00000000 00000000 00000000
> [   14.885284] @000000002fb7f590 00000000 00000000 00000000 00000000
> [   14.885285] @000000002fb7f5a0 00000000 00000000 00000000 00000000
> [   14.885286] @000000002fb7f5b0 00000000 00000000 00000000 00000000
> [   14.885287] @000000002fb7f5c0 00000000 00000000 00000000 00000000
> [   14.885288] @000000002fb7f5d0 00000000 00000000 00000000 00000000
> [   14.885289] @000000002fb7f5e0 00000000 00000000 00000000 00000000
> [   14.885290] @000000002fb7f5f0 00000000 00000000 00000000 00000000
> [   14.885291] @000000002fb7f600 00000000 00000000 00000000 00000000
> [   14.885292] @000000002fb7f610 00000000 00000000 00000000 00000000
> [   14.885293] @000000002fb7f620 00000000 00000000 00000000 00000000
> [   14.885294] @000000002fb7f630 00000000 00000000 00000000 00000000
> [   14.885295] @000000002fb7f640 00000000 00000000 00000000 00000000
> [   14.885296] @000000002fb7f650 00000000 00000000 00000000 00000000
> [   14.885297] @000000002fb7f660 00000000 00000000 00000000 00000000
> [   14.885299] @000000002fb7f670 00000000 00000000 00000000 00000000
> [   14.885300] @000000002fb7f680 00000000 00000000 00000000 00000000
> [   14.885301] @000000002fb7f690 00000000 00000000 00000000 00000000
> [   14.885302] @000000002fb7f6a0 00000000 00000000 00000000 00000000
> [   14.885303] @000000002fb7f6b0 00000000 00000000 00000000 00000000
> [   14.885304] @000000002fb7f6c0 00000000 00000000 00000000 00000000
> [   14.885305] @000000002fb7f6d0 00000000 00000000 00000000 00000000
> [   14.885306] @000000002fb7f6e0 00000000 00000000 00000000 00000000
> [   14.885307] @000000002fb7f6f0 00000000 00000000 00000000 00000000
> [   14.885308] @000000002fb7f700 00000000 00000000 00000000 00000000
> [   14.885309] @000000002fb7f710 00000000 00000000 00000000 00000000
> [   14.885310] @000000002fb7f720 00000000 00000000 00000000 00000000
> [   14.885311] @000000002fb7f730 00000000 00000000 00000000 00000000
> [   14.885312] @000000002fb7f740 00000000 00000000 00000000 00000000
> [   14.885314] @000000002fb7f750 00000000 00000000 00000000 00000000
> [   14.885315] @000000002fb7f760 00000000 00000000 00000000 00000000
> [   14.885316] @000000002fb7f770 00000000 00000000 00000000 00000000
> [   14.885317] @000000002fb7f780 00000000 00000000 00000000 00000000
> [   14.885318] @000000002fb7f790 00000000 00000000 00000000 00000000
> [   14.885319] @000000002fb7f7a0 00000000 00000000 00000000 00000000
> [   14.885320] @000000002fb7f7b0 00000000 00000000 00000000 00000000
> [   14.885321] @000000002fb7f7c0 00000000 00000000 00000000 00000000
> [   14.885322] @000000002fb7f7d0 00000000 00000000 00000000 00000000
> [   14.885323] @000000002fb7f7e0 00000000 00000000 00000000 00000000
> [   14.885324] @000000002fb7f7f0 00000000 00000000 00000000 00000000
> [   14.885325] @000000002fb7f800 00000000 00000000 00000000 00000000
> [   14.885326] @000000002fb7f810 00000000 00000000 00000000 00000000
> [   14.885327] @000000002fb7f820 00000000 00000000 00000000 00000000
> [   14.885329] @000000002fb7f830 00000000 00000000 00000000 00000000
> [   14.885330] @000000002fb7f840 00000000 00000000 00000000 00000000
> [   14.885331] @000000002fb7f850 00000000 00000000 00000000 00000000
> [   14.885332] @000000002fb7f860 00000000 00000000 00000000 00000000
> [   14.885333] @000000002fb7f870 00000000 00000000 00000000 00000000
> [   14.885334] @000000002fb7f880 00000000 00000000 00000000 00000000
> [   14.885335] @000000002fb7f890 00000000 00000000 00000000 00000000
> [   14.885336] @000000002fb7f8a0 00000000 00000000 00000000 00000000
> [   14.885337] @000000002fb7f8b0 00000000 00000000 00000000 00000000
> [   14.885338] @000000002fb7f8c0 00000000 00000000 00000000 00000000
> [   14.885339] @000000002fb7f8d0 00000000 00000000 00000000 00000000
> [   14.885340] @000000002fb7f8e0 00000000 00000000 00000000 00000000
> [   14.885341] @000000002fb7f8f0 00000000 00000000 00000000 00000000
> [   14.885342] @000000002fb7f900 00000000 00000000 00000000 00000000
> [   14.885343] @000000002fb7f910 00000000 00000000 00000000 00000000
> [   14.885345] @000000002fb7f920 00000000 00000000 00000000 00000000
> [   14.885346] @000000002fb7f930 00000000 00000000 00000000 00000000
> [   14.885347] @000000002fb7f940 00000000 00000000 00000000 00000000
> [   14.885348] @000000002fb7f950 00000000 00000000 00000000 00000000
> [   14.885349] @000000002fb7f960 00000000 00000000 00000000 00000000
> [   14.885350] @000000002fb7f970 00000000 00000000 00000000 00000000
> [   14.885351] @000000002fb7f980 00000000 00000000 00000000 00000000
> [   14.885352] @000000002fb7f990 00000000 00000000 00000000 00000000
> [   14.885353] @000000002fb7f9a0 00000000 00000000 00000000 00000000
> [   14.885354] @000000002fb7f9b0 00000000 00000000 00000000 00000000
> [   14.885355] @000000002fb7f9c0 00000000 00000000 00000000 00000000
> [   14.885356] @000000002fb7f9d0 00000000 00000000 00000000 00000000
> [   14.885357] @000000002fb7f9e0 00000000 00000000 00000000 00000000
> [   14.885359] @000000002fb7f9f0 00000000 00000000 00000000 00000000
> [   14.885360] @000000002fb7fa00 00000000 00000000 00000000 00000000
> [   14.885361] @000000002fb7fa10 00000000 00000000 00000000 00000000
> [   14.885362] @000000002fb7fa20 00000000 00000000 00000000 00000000
> [   14.885363] @000000002fb7fa30 00000000 00000000 00000000 00000000
> [   14.885364] @000000002fb7fa40 00000000 00000000 00000000 00000000
> [   14.885365] @000000002fb7fa50 00000000 00000000 00000000 00000000
> [   14.885366] @000000002fb7fa60 00000000 00000000 00000000 00000000
> [   14.885367] @000000002fb7fa70 00000000 00000000 00000000 00000000
> [   14.885368] @000000002fb7fa80 00000000 00000000 00000000 00000000
> [   14.885369] @000000002fb7fa90 00000000 00000000 00000000 00000000
> [   14.885370] @000000002fb7faa0 00000000 00000000 00000000 00000000
> [   14.885371] @000000002fb7fab0 00000000 00000000 00000000 00000000
> [   14.885372] @000000002fb7fac0 00000000 00000000 00000000 00000000
> [   14.885374] @000000002fb7fad0 00000000 00000000 00000000 00000000
> [   14.885375] @000000002fb7fae0 00000000 00000000 00000000 00000000
> [   14.885376] @000000002fb7faf0 00000000 00000000 00000000 00000000
> [   14.885377] @000000002fb7fb00 00000000 00000000 00000000 00000000
> [   14.885378] @000000002fb7fb10 00000000 00000000 00000000 00000000
> [   14.885379] @000000002fb7fb20 00000000 00000000 00000000 00000000
> [   14.885380] @000000002fb7fb30 00000000 00000000 00000000 00000000
> [   14.885381] @000000002fb7fb40 00000000 00000000 00000000 00000000
> [   14.885382] @000000002fb7fb50 00000000 00000000 00000000 00000000
> [   14.885383] @000000002fb7fb60 00000000 00000000 00000000 00000000
> [   14.885384] @000000002fb7fb70 00000000 00000000 00000000 00000000
> [   14.885385] @000000002fb7fb80 00000000 00000000 00000000 00000000
> [   14.885386] @000000002fb7fb90 00000000 00000000 00000000 00000000
> [   14.885388] @000000002fb7fba0 00000000 00000000 00000000 00000000
> [   14.885389] @000000002fb7fbb0 00000000 00000000 00000000 00000000
> [   14.885390] @000000002fb7fbc0 00000000 00000000 00000000 00000000
> [   14.885391] @000000002fb7fbd0 00000000 00000000 00000000 00000000
> [   14.885392] @000000002fb7fbe0 00000000 00000000 00000000 00000000
> [   14.885393] @000000002fb7fbf0 00000000 00000000 00000000 00000000
> [   14.885394] @000000002fb7fc00 00000000 00000000 00000000 00000000
> [   14.885395] @000000002fb7fc10 00000000 00000000 00000000 00000000
> [   14.885396] @000000002fb7fc20 00000000 00000000 00000000 00000000
> [   14.885397] @000000002fb7fc30 00000000 00000000 00000000 00000000
> [   14.885398] @000000002fb7fc40 00000000 00000000 00000000 00000000
> [   14.885399] @000000002fb7fc50 00000000 00000000 00000000 00000000
> [   14.885400] @000000002fb7fc60 00000000 00000000 00000000 00000000
> [   14.885401] @000000002fb7fc70 00000000 00000000 00000000 00000000
> [   14.885403] @000000002fb7fc80 00000000 00000000 00000000 00000000
> [   14.885404] @000000002fb7fc90 00000000 00000000 00000000 00000000
> [   14.885405] @000000002fb7fca0 00000000 00000000 00000000 00000000
> [   14.885406] @000000002fb7fcb0 00000000 00000000 00000000 00000000
> [   14.885407] @000000002fb7fcc0 00000000 00000000 00000000 00000000
> [   14.885408] @000000002fb7fcd0 00000000 00000000 00000000 00000000
> [   14.885409] @000000002fb7fce0 00000000 00000000 00000000 00000000
> [   14.885410] @000000002fb7fcf0 00000000 00000000 00000000 00000000
> [   14.885411] @000000002fb7fd00 00000000 00000000 00000000 00000000
> [   14.885412] @000000002fb7fd10 00000000 00000000 00000000 00000000
> [   14.885413] @000000002fb7fd20 00000000 00000000 00000000 00000000
> [   14.885414] @000000002fb7fd30 00000000 00000000 00000000 00000000
> [   14.885415] @000000002fb7fd40 00000000 00000000 00000000 00000000
> [   14.885417] @000000002fb7fd50 00000000 00000000 00000000 00000000
> [   14.885418] @000000002fb7fd60 00000000 00000000 00000000 00000000
> [   14.885419] @000000002fb7fd70 00000000 00000000 00000000 00000000
> [   14.885420] @000000002fb7fd80 00000000 00000000 00000000 00000000
> [   14.885421] @000000002fb7fd90 00000000 00000000 00000000 00000000
> [   14.885422] @000000002fb7fda0 00000000 00000000 00000000 00000000
> [   14.885423] @000000002fb7fdb0 00000000 00000000 00000000 00000000
> [   14.885424] @000000002fb7fdc0 00000000 00000000 00000000 00000000
> [   14.885425] @000000002fb7fdd0 00000000 00000000 00000000 00000000
> [   14.885426] @000000002fb7fde0 00000000 00000000 00000000 00000000
> [   14.885427] @000000002fb7fdf0 00000000 00000000 00000000 00000000
> [   14.885428] @000000002fb7fe00 00000000 00000000 00000000 00000000
> [   14.885429] @000000002fb7fe10 00000000 00000000 00000000 00000000
> [   14.885430] @000000002fb7fe20 00000000 00000000 00000000 00000000
> [   14.885432] @000000002fb7fe30 00000000 00000000 00000000 00000000
> [   14.885433] @000000002fb7fe40 00000000 00000000 00000000 00000000
> [   14.885434] @000000002fb7fe50 00000000 00000000 00000000 00000000
> [   14.885435] @000000002fb7fe60 00000000 00000000 00000000 00000000
> [   14.885436] @000000002fb7fe70 00000000 00000000 00000000 00000000
> [   14.885437] @000000002fb7fe80 00000000 00000000 00000000 00000000
> [   14.885438] @000000002fb7fe90 00000000 00000000 00000000 00000000
> [   14.885439] @000000002fb7fea0 00000000 00000000 00000000 00000000
> [   14.885440] @000000002fb7feb0 00000000 00000000 00000000 00000000
> [   14.885441] @000000002fb7fec0 00000000 00000000 00000000 00000000
> [   14.885442] @000000002fb7fed0 00000000 00000000 00000000 00000000
> [   14.885443] @000000002fb7fee0 00000000 00000000 00000000 00000000
> [   14.885444] @000000002fb7fef0 00000000 00000000 00000000 00000000
> [   14.885445] @000000002fb7ff00 00000000 00000000 00000000 00000000
> [   14.885446] @000000002fb7ff10 00000000 00000000 00000000 00000000
> [   14.885448] @000000002fb7ff20 00000000 00000000 00000000 00000000
> [   14.885449] @000000002fb7ff30 00000000 00000000 00000000 00000000
> [   14.885450] @000000002fb7ff40 00000000 00000000 00000000 00000000
> [   14.885451] @000000002fb7ff50 00000000 00000000 00000000 00000000
> [   14.885452] @000000002fb7ff60 00000000 00000000 00000000 00000000
> [   14.885453] @000000002fb7ff70 00000000 00000000 00000000 00000000
> [   14.885454] @000000002fb7ff80 00000000 00000000 00000000 00000000
> [   14.885455] @000000002fb7ff90 00000000 00000000 00000000 00000000
> [   14.885456] @000000002fb7ffa0 00000000 00000000 00000000 00000000
> [   14.885457] @000000002fb7ffb0 00000000 00000000 00000000 00000000
> [   14.885458] @000000002fb7ffc0 00000000 00000000 00000000 00000000
> [   14.885459] @000000002fb7ffd0 00000000 00000000 00000000 00000000
> [   14.885460] @000000002fb7ffe0 00000000 00000000 00000000 00000000
> [   14.885461] @000000002fb7fff0 00000000 00000000 00000000 00000000
> [   14.885462]   Ring has not been updated
> [   14.885463] Ring deq = efb7f000 (virt), 0x2fb7f000 (dma)
> [   14.885464] Ring deq updated 0 times
> [   14.885465] Ring enq = efb7f000 (virt), 0x2fb7f000 (dma)
> [   14.885466] Ring enq updated 0 times
> [   14.885471] ERST deq = 64'h2fb7f000
> [   14.885472] // Set the interrupt modulation register
> [   14.885478] // Enable interrupts, cmd = 0x4.
> [   14.885481] // Enabling event ring interrupter fcea2020 by writing 0x2 to irq_pending
> [   14.885483]   fcea2020: ir_set[0]
> [   14.885484]   fcea2020: ir_set.pending = 0x2
> [   14.885486]   fcea2024: ir_set.control = 0xa0
> [   14.885489]   fcea2028: ir_set.erst_size = 0x1
> [   14.885499]   fcea2030: ir_set.erst_base = @2fbf3000
> [   14.885504]   fcea2038: ir_set.erst_dequeue = @2fb7f000
> [   14.885505] Finished xhci_run for USB2 roothub
> [   14.885517] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [   14.885519] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   14.885520] usb usb3: Product: xHCI Host Controller
> [   14.885521] usb usb3: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> [   14.885522] usb usb3: SerialNumber: 0000:03:00.0
> [   14.885609] hub 3-0:1.0: USB hub found
> [   14.885622] hub 3-0:1.0: 4 ports detected
> [   14.885629] set port power, actual port 0 status  = 0x2a0
> [   14.885638] set port power, actual port 1 status  = 0x2a0
> [   14.885646] set port power, actual port 2 status  = 0x2a0
> [   14.885654] set port power, actual port 3 status  = 0x2a0
> [   14.885691] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [   14.885720] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
> [   14.885724] Enabling 64-bit DMA addresses.
> [   14.885727] // Turn on HC, cmd = 0x5.
> [   14.885729] Finished xhci_run for USB3 roothub
> [   14.885737] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [   14.885738] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   14.885739] usb usb4: Product: xHCI Host Controller
> [   14.885740] usb usb4: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> [   14.885741] usb usb4: SerialNumber: 0000:03:00.0
> [   14.885805] hub 4-0:1.0: USB hub found
> [   14.885816] hub 4-0:1.0: 4 ports detected
> [   14.885824] set port power, actual port 0 status  = 0x2a0
> [   14.885833] set port power, actual port 1 status  = 0x2a0
> [   14.885841] set port power, actual port 2 status  = 0x2b0
> [   14.885849] set port power, actual port 3 status  = 0x2a0
> [   14.991153] Port Status Change Event for port 7
> [   18.683951] get port status, actual port 0 status  = 0x2a0
> [   18.683953] Get port status returned 0x100
> [   18.683958] get port status, actual port 1 status  = 0x2a0
> [   18.683959] Get port status returned 0x100
> [   18.683963] get port status, actual port 2 status  = 0x2a0
> [   18.683965] Get port status returned 0x100
> [   18.683969] get port status, actual port 3 status  = 0x2a0
> [   18.683970] Get port status returned 0x100
> [   18.683976] get port status, actual port 0 status  = 0x2a0
> [   18.683978] Get port status returned 0x2a0
> [   18.683982] get port status, actual port 1 status  = 0x2a0
> [   18.683983] Get port status returned 0x2a0
> [   18.683987] get port status, actual port 2 status  = 0x221203
> [   18.683988] Get port status returned 0x110203
> [   18.683996] clear port connect change, actual port 2 status  = 0x201203
> [   18.684001] get port status, actual port 3 status  = 0x2a0
> [   18.684002] Get port status returned 0x2a0
> [   18.783141] get port status, actual port 2 status  = 0x201203
> [   18.788937] Get port status returned 0x100203
> [   18.793315] clear port reset change, actual port 2 status  = 0x1203
> [   18.799644] // Ding dong!
> [   18.800209] xhci_hcd 0000:06:00.0: xHCI Host Controller
> [   18.801025] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [   18.801379] r8169 0000:07:00.0: eth0: RTL8168evl/8111evl at 0xfce9e000, 50:e5:49:3d:55:88, XID 0c900800 IRQ 46
> [   18.801381] r8169 0000:07:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [   18.801409] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 5
> [   18.801429] xHCI capability registers at fd030000:
> [   18.801432] CAPLENGTH AND HCIVERSION 0x1000020:
> [   18.801434] CAPLENGTH: 0x20
> [   18.801435] HCIVERSION: 0x100
> [   18.801437] HCSPARAMS 1: 0x4000440
> [   18.801439]   Max device slots: 64
> [   18.801440]   Max interrupters: 4
> [   18.801440]   Max ports: 4
> [   18.801443] HCSPARAMS 2: 0x240000f9
> [   18.801444]   Isoc scheduling threshold: 9
> [   18.801446]   Maximum allowed segments in event ring: 15
> [   18.801448] HCSPARAMS 3 0x7ff0003:
> [   18.801449]   Worst case U1 device exit latency: 3
> [   18.801450]   Worst case U2 device exit latency: 2047
> [   18.801454] HCC PARAMS 0x40050af:
> [   18.801455]   HC generates 64 bit addresses
> [   18.801456]   FIXME: more HCCPARAMS debugging
> [   18.801459] RTSOFF 0x2000:
> [   18.801460] xHCI operational registers at fd030020:
> [   18.801463] USBCMD 0x0:
> [   18.801465]   HC is being stopped
> [   18.801466]   HC has finished hard reset
> [   18.801467]   Event Interrupts disabled
> [   18.801468]   Host System Error Interrupts disabled
> [   18.801469]   HC has finished light reset
> [   18.801471] USBSTS 0x1:
> [   18.801473]   Event ring is empty
> [   18.801474]   No Host System Error
> [   18.801475]   HC is halted
> [   18.801479] fd030420 port status reg = 0x2a0
> [   18.801483] fd030424 port power reg = 0x0
> [   18.801487] fd030428 port link reg = 0x0
> [   18.801491] fd03042c port reserved reg = 0x0
> [   18.801494] fd030430 port status reg = 0x2a0
> [   18.801497] fd030434 port power reg = 0x0
> [   18.801501] fd030438 port link reg = 0x0
> [   18.801504] fd03043c port reserved reg = 0x0
> [   18.801508] fd030440 port status reg = 0x2a0
> [   18.801511] fd030444 port power reg = 0x0
> [   18.801514] fd030448 port link reg = 0x0
> [   18.801517] fd03044c port reserved reg = 0x0
> [   18.801520] fd030450 port status reg = 0x2a0
> [   18.801524] fd030454 port power reg = 0x0
> [   18.801527] fd030458 port link reg = 0x0
> [   18.801530] fd03045c port reserved reg = 0x0
> [   18.801531] QUIRK: Resetting on resume
> [   18.801532] // Halt the HC
> [   18.801540] Resetting HCD
> [   18.801543] // Reset the HC
> [   18.801553] Wait for controller to be ready for doorbell rings
> [   18.801557] Reset complete
> [   18.801561] Enabling 64-bit DMA addresses.
> [   18.801562] Calling HCD init
> [   18.801563] xhci_init
> [   18.801563] xHCI doesn't need link TRB QUIRK
> [   18.801568] Supported page size register = 0x1
> [   18.801569] Supported page size of 4K
> [   18.801570] HCD page size set to 4K
> [   18.801574] // xHC can handle at most 64 device slots.
> [   18.801578] // Setting Max device slots reg = 0x40.
> [   18.801581] // Device context base array address = 0x2f9a8000 (DMA), ef9a8000 (virt)
> [   18.801585] Allocated command ring at ef07a600
> [   18.801586] First segment DMA is 0x2f983000
> [   18.801592] // Setting command ring address to 0x40
> [   18.801599] // xHC command ring deq ptr low bits + flags = @00000000
> [   18.801600] // xHC command ring deq ptr high bits = @00000000
> [   18.801603] // Doorbell array is located at offset 0x3000 from cap regs base addr
> [   18.801605] // xHCI capability registers at fd030000:
> [   18.801608] // @fd030000 = 0x1000020 (CAPLENGTH AND HCIVERSION)
> [   18.801609] //   CAPLENGTH: 0x20
> [   18.801610] // xHCI operational registers at fd030020:
> [   18.801614] // @fd030018 = 0x2000 RTSOFF
> [   18.801615] // xHCI runtime registers at fd032000:
> [   18.801619] // @fd030014 = 0x3000 DBOFF
> [   18.801620] // Doorbell array at fd033000:
> [   18.801621] xHCI runtime registers at fd032000:
> [   18.801625]   fd032000: Microframe index = 0x0
> [   18.801643] // Allocating event ring
> [   18.801648] TRB math tests passed.
> [   18.801649] // Allocated event ring segment table at 0x2f844000
> [   18.801651] Set ERST to 0; private num segs = 1, virt addr = ef844000, dma addr = 0x2f844000
> [   18.801654] // Write ERST size = 1 to ir_set 0 (some bits preserved)
> [   18.801655] // Set ERST entries to point to event ring.
> [   18.801657] // Set ERST base address for ir_set 0 = 0x2f844000
> [   18.801667] // Write event ring dequeue pointer, preserving EHB bit
> [   18.801669] Wrote ERST address to ir_set 0.
> [   18.801672] Allocating 4 scratchpad buffers
> [   18.801686] Ext Cap fd031010, port offset = 1, count = 2, revision = 0x2
> [   18.801688] xHCI 1.0: support USB2 software lpm
> [   18.801695] Ext Cap fd031020, port offset = 3, count = 2, revision = 0x3
> [   18.801696] Found 2 USB 2.0 ports and 2 USB 3.0 ports.
> [   18.801698] USB 2.0 port at index 0, addr = fd030420
> [   18.801699] USB 2.0 port at index 1, addr = fd030430
> [   18.801700] USB 3.0 port at index 2, addr = fd030440
> [   18.801701] USB 3.0 port at index 3, addr = fd030450
> [   18.801704] Finished xhci_init
> [   18.801706] Called HCD init
> [   18.801710] Got SBRN 48
> [   18.801718] MWI active
> [   18.801719] Finished xhci_pci_reinit
> [   18.801726] xhci_hcd 0000:06:00.0: irq 16, io mem 0xfbcf8000
> [   18.801727] xhci_run
> [   18.801755] Failed to enable MSI-X
> [   18.801883] Setting event ring polling timer
> [   18.801885] Command ring memory map follows:
> [   18.801886] @000000002f983000 00000000 00000000 00000000 00000000
> [   18.801888] @000000002f983010 00000000 00000000 00000000 00000000
> [   18.801889] @000000002f983020 00000000 00000000 00000000 00000000
> [   18.801891] @000000002f983030 00000000 00000000 00000000 00000000
> [   18.801892] @000000002f983040 00000000 00000000 00000000 00000000
> [   18.801894] @000000002f983050 00000000 00000000 00000000 00000000
> [   18.801895] @000000002f983060 00000000 00000000 00000000 00000000
> [   18.801896] @000000002f983070 00000000 00000000 00000000 00000000
> [   18.801898] @000000002f983080 00000000 00000000 00000000 00000000
> [   18.801899] @000000002f983090 00000000 00000000 00000000 00000000
> [   18.801901] @000000002f9830a0 00000000 00000000 00000000 00000000
> [   18.801902] @000000002f9830b0 00000000 00000000 00000000 00000000
> [   18.801904] @000000002f9830c0 00000000 00000000 00000000 00000000
> [   18.801905] @000000002f9830d0 00000000 00000000 00000000 00000000
> [   18.801906] @000000002f9830e0 00000000 00000000 00000000 00000000
> [   18.801908] @000000002f9830f0 00000000 00000000 00000000 00000000
> [   18.801909] @000000002f983100 00000000 00000000 00000000 00000000
> [   18.801911] @000000002f983110 00000000 00000000 00000000 00000000
> [   18.801912] @000000002f983120 00000000 00000000 00000000 00000000
> [   18.801914] @000000002f983130 00000000 00000000 00000000 00000000
> [   18.801915] @000000002f983140 00000000 00000000 00000000 00000000
> [   18.801916] @000000002f983150 00000000 00000000 00000000 00000000
> [   18.801918] @000000002f983160 00000000 00000000 00000000 00000000
> [   18.801919] @000000002f983170 00000000 00000000 00000000 00000000
> [   18.801921] @000000002f983180 00000000 00000000 00000000 00000000
> [   18.801922] @000000002f983190 00000000 00000000 00000000 00000000
> [   18.801924] @000000002f9831a0 00000000 00000000 00000000 00000000
> [   18.801925] @000000002f9831b0 00000000 00000000 00000000 00000000
> [   18.801927] @000000002f9831c0 00000000 00000000 00000000 00000000
> [   18.801928] @000000002f9831d0 00000000 00000000 00000000 00000000
> [   18.801930] @000000002f9831e0 00000000 00000000 00000000 00000000
> [   18.801931] @000000002f9831f0 00000000 00000000 00000000 00000000
> [   18.801932] @000000002f983200 00000000 00000000 00000000 00000000
> [   18.801934] @000000002f983210 00000000 00000000 00000000 00000000
> [   18.801935] @000000002f983220 00000000 00000000 00000000 00000000
> [   18.801937] @000000002f983230 00000000 00000000 00000000 00000000
> [   18.801938] @000000002f983240 00000000 00000000 00000000 00000000
> [   18.801940] @000000002f983250 00000000 00000000 00000000 00000000
> [   18.801941] @000000002f983260 00000000 00000000 00000000 00000000
> [   18.801942] @000000002f983270 00000000 00000000 00000000 00000000
> [   18.801944] @000000002f983280 00000000 00000000 00000000 00000000
> [   18.801945] @000000002f983290 00000000 00000000 00000000 00000000
> [   18.801947] @000000002f9832a0 00000000 00000000 00000000 00000000
> [   18.801948] @000000002f9832b0 00000000 00000000 00000000 00000000
> [   18.801950] @000000002f9832c0 00000000 00000000 00000000 00000000
> [   18.801951] @000000002f9832d0 00000000 00000000 00000000 00000000
> [   18.801953] @000000002f9832e0 00000000 00000000 00000000 00000000
> [   18.801954] @000000002f9832f0 00000000 00000000 00000000 00000000
> [   18.801955] @000000002f983300 00000000 00000000 00000000 00000000
> [   18.801957] @000000002f983310 00000000 00000000 00000000 00000000
> [   18.801958] @000000002f983320 00000000 00000000 00000000 00000000
> [   18.801960] @000000002f983330 00000000 00000000 00000000 00000000
> [   18.801961] @000000002f983340 00000000 00000000 00000000 00000000
> [   18.801963] @000000002f983350 00000000 00000000 00000000 00000000
> [   18.801964] @000000002f983360 00000000 00000000 00000000 00000000
> [   18.801966] @000000002f983370 00000000 00000000 00000000 00000000
> [   18.801967] @000000002f983380 00000000 00000000 00000000 00000000
> [   18.801968] @000000002f983390 00000000 00000000 00000000 00000000
> [   18.801970] @000000002f9833a0 00000000 00000000 00000000 00000000
> [   18.801971] @000000002f9833b0 00000000 00000000 00000000 00000000
> [   18.801973] @000000002f9833c0 00000000 00000000 00000000 00000000
> [   18.801974] @000000002f9833d0 00000000 00000000 00000000 00000000
> [   18.801976] @000000002f9833e0 00000000 00000000 00000000 00000000
> [   18.801977] @000000002f9833f0 00000000 00000000 00000000 00000000
> [   18.801979] @000000002f983400 00000000 00000000 00000000 00000000
> [   18.801980] @000000002f983410 00000000 00000000 00000000 00000000
> [   18.801981] @000000002f983420 00000000 00000000 00000000 00000000
> [   18.801983] @000000002f983430 00000000 00000000 00000000 00000000
> [   18.801984] @000000002f983440 00000000 00000000 00000000 00000000
> [   18.801986] @000000002f983450 00000000 00000000 00000000 00000000
> [   18.801987] @000000002f983460 00000000 00000000 00000000 00000000
> [   18.801989] @000000002f983470 00000000 00000000 00000000 00000000
> [   18.801990] @000000002f983480 00000000 00000000 00000000 00000000
> [   18.801992] @000000002f983490 00000000 00000000 00000000 00000000
> [   18.801993] @000000002f9834a0 00000000 00000000 00000000 00000000
> [   18.801995] @000000002f9834b0 00000000 00000000 00000000 00000000
> [   18.801996] @000000002f9834c0 00000000 00000000 00000000 00000000
> [   18.801998] @000000002f9834d0 00000000 00000000 00000000 00000000
> [   18.801999] @000000002f9834e0 00000000 00000000 00000000 00000000
> [   18.802000] @000000002f9834f0 00000000 00000000 00000000 00000000
> [   18.802002] @000000002f983500 00000000 00000000 00000000 00000000
> [   18.802003] @000000002f983510 00000000 00000000 00000000 00000000
> [   18.802005] @000000002f983520 00000000 00000000 00000000 00000000
> [   18.802006] @000000002f983530 00000000 00000000 00000000 00000000
> [   18.802008] @000000002f983540 00000000 00000000 00000000 00000000
> [   18.802009] @000000002f983550 00000000 00000000 00000000 00000000
> [   18.802011] @000000002f983560 00000000 00000000 00000000 00000000
> [   18.802012] @000000002f983570 00000000 00000000 00000000 00000000
> [   18.802014] @000000002f983580 00000000 00000000 00000000 00000000
> [   18.802015] @000000002f983590 00000000 00000000 00000000 00000000
> [   18.802016] @000000002f9835a0 00000000 00000000 00000000 00000000
> [   18.802018] @000000002f9835b0 00000000 00000000 00000000 00000000
> [   18.802019] @000000002f9835c0 00000000 00000000 00000000 00000000
> [   18.802021] @000000002f9835d0 00000000 00000000 00000000 00000000
> [   18.802022] @000000002f9835e0 00000000 00000000 00000000 00000000
> [   18.802024] @000000002f9835f0 00000000 00000000 00000000 00000000
> [   18.802025] @000000002f983600 00000000 00000000 00000000 00000000
> [   18.802026] @000000002f983610 00000000 00000000 00000000 00000000
> [   18.802028] @000000002f983620 00000000 00000000 00000000 00000000
> [   18.802029] @000000002f983630 00000000 00000000 00000000 00000000
> [   18.802031] @000000002f983640 00000000 00000000 00000000 00000000
> [   18.802032] @000000002f983650 00000000 00000000 00000000 00000000
> [   18.802034] @000000002f983660 00000000 00000000 00000000 00000000
> [   18.802035] @000000002f983670 00000000 00000000 00000000 00000000
> [   18.802036] @000000002f983680 00000000 00000000 00000000 00000000
> [   18.802038] @000000002f983690 00000000 00000000 00000000 00000000
> [   18.802039] @000000002f9836a0 00000000 00000000 00000000 00000000
> [   18.802041] @000000002f9836b0 00000000 00000000 00000000 00000000
> [   18.802042] @000000002f9836c0 00000000 00000000 00000000 00000000
> [   18.802043] @000000002f9836d0 00000000 00000000 00000000 00000000
> [   18.802045] @000000002f9836e0 00000000 00000000 00000000 00000000
> [   18.802046] @000000002f9836f0 00000000 00000000 00000000 00000000
> [   18.802048] @000000002f983700 00000000 00000000 00000000 00000000
> [   18.802049] @000000002f983710 00000000 00000000 00000000 00000000
> [   18.802051] @000000002f983720 00000000 00000000 00000000 00000000
> [   18.802052] @000000002f983730 00000000 00000000 00000000 00000000
> [   18.802054] @000000002f983740 00000000 00000000 00000000 00000000
> [   18.802055] @000000002f983750 00000000 00000000 00000000 00000000
> [   18.802056] @000000002f983760 00000000 00000000 00000000 00000000
> [   18.802058] @000000002f983770 00000000 00000000 00000000 00000000
> [   18.802059] @000000002f983780 00000000 00000000 00000000 00000000
> [   18.802061] @000000002f983790 00000000 00000000 00000000 00000000
> [   18.802062] @000000002f9837a0 00000000 00000000 00000000 00000000
> [   18.802064] @000000002f9837b0 00000000 00000000 00000000 00000000
> [   18.802065] @000000002f9837c0 00000000 00000000 00000000 00000000
> [   18.802067] @000000002f9837d0 00000000 00000000 00000000 00000000
> [   18.802068] @000000002f9837e0 00000000 00000000 00000000 00000000
> [   18.802070] @000000002f9837f0 00000000 00000000 00000000 00000000
> [   18.802071] @000000002f983800 00000000 00000000 00000000 00000000
> [   18.802072] @000000002f983810 00000000 00000000 00000000 00000000
> [   18.802074] @000000002f983820 00000000 00000000 00000000 00000000
> [   18.802075] @000000002f983830 00000000 00000000 00000000 00000000
> [   18.802077] @000000002f983840 00000000 00000000 00000000 00000000
> [   18.802078] @000000002f983850 00000000 00000000 00000000 00000000
> [   18.802080] @000000002f983860 00000000 00000000 00000000 00000000
> [   18.802081] @000000002f983870 00000000 00000000 00000000 00000000
> [   18.802082] @000000002f983880 00000000 00000000 00000000 00000000
> [   18.802084] @000000002f983890 00000000 00000000 00000000 00000000
> [   18.802085] @000000002f9838a0 00000000 00000000 00000000 00000000
> [   18.802087] @000000002f9838b0 00000000 00000000 00000000 00000000
> [   18.802088] @000000002f9838c0 00000000 00000000 00000000 00000000
> [   18.802090] @000000002f9838d0 00000000 00000000 00000000 00000000
> [   18.802091] @000000002f9838e0 00000000 00000000 00000000 00000000
> [   18.802093] @000000002f9838f0 00000000 00000000 00000000 00000000
> [   18.802094] @000000002f983900 00000000 00000000 00000000 00000000
> [   18.802095] @000000002f983910 00000000 00000000 00000000 00000000
> [   18.802097] @000000002f983920 00000000 00000000 00000000 00000000
> [   18.802098] @000000002f983930 00000000 00000000 00000000 00000000
> [   18.802100] @000000002f983940 00000000 00000000 00000000 00000000
> [   18.802101] @000000002f983950 00000000 00000000 00000000 00000000
> [   18.802103] @000000002f983960 00000000 00000000 00000000 00000000
> [   18.802104] @000000002f983970 00000000 00000000 00000000 00000000
> [   18.802106] @000000002f983980 00000000 00000000 00000000 00000000
> [   18.802107] @000000002f983990 00000000 00000000 00000000 00000000
> [   18.802109] @000000002f9839a0 00000000 00000000 00000000 00000000
> [   18.802110] @000000002f9839b0 00000000 00000000 00000000 00000000
> [   18.802111] @000000002f9839c0 00000000 00000000 00000000 00000000
> [   18.802113] @000000002f9839d0 00000000 00000000 00000000 00000000
> [   18.802114] @000000002f9839e0 00000000 00000000 00000000 00000000
> [   18.802115] @000000002f9839f0 00000000 00000000 00000000 00000000
> [   18.802117] @000000002f983a00 00000000 00000000 00000000 00000000
> [   18.802122] @000000002f983a10 00000000 00000000 00000000 00000000
> [   18.802124] @000000002f983a20 00000000 00000000 00000000 00000000
> [   18.802125] @000000002f983a30 00000000 00000000 00000000 00000000
> [   18.802127] @000000002f983a40 00000000 00000000 00000000 00000000
> [   18.802128] @000000002f983a50 00000000 00000000 00000000 00000000
> [   18.802130] @000000002f983a60 00000000 00000000 00000000 00000000
> [   18.802131] @000000002f983a70 00000000 00000000 00000000 00000000
> [   18.802133] @000000002f983a80 00000000 00000000 00000000 00000000
> [   18.802134] @000000002f983a90 00000000 00000000 00000000 00000000
> [   18.802135] @000000002f983aa0 00000000 00000000 00000000 00000000
> [   18.802137] @000000002f983ab0 00000000 00000000 00000000 00000000
> [   18.802138] @000000002f983ac0 00000000 00000000 00000000 00000000
> [   18.802140] @000000002f983ad0 00000000 00000000 00000000 00000000
> [   18.802141] @000000002f983ae0 00000000 00000000 00000000 00000000
> [   18.802143] @000000002f983af0 00000000 00000000 00000000 00000000
> [   18.802144] @000000002f983b00 00000000 00000000 00000000 00000000
> [   18.802146] @000000002f983b10 00000000 00000000 00000000 00000000
> [   18.802147] @000000002f983b20 00000000 00000000 00000000 00000000
> [   18.802149] @000000002f983b30 00000000 00000000 00000000 00000000
> [   18.802150] @000000002f983b40 00000000 00000000 00000000 00000000
> [   18.802151] @000000002f983b50 00000000 00000000 00000000 00000000
> [   18.802153] @000000002f983b60 00000000 00000000 00000000 00000000
> [   18.802154] @000000002f983b70 00000000 00000000 00000000 00000000
> [   18.802156] @000000002f983b80 00000000 00000000 00000000 00000000
> [   18.802157] @000000002f983b90 00000000 00000000 00000000 00000000
> [   18.802159] @000000002f983ba0 00000000 00000000 00000000 00000000
> [   18.802160] @000000002f983bb0 00000000 00000000 00000000 00000000
> [   18.802162] @000000002f983bc0 00000000 00000000 00000000 00000000
> [   18.802163] @000000002f983bd0 00000000 00000000 00000000 00000000
> [   18.802164] @000000002f983be0 00000000 00000000 00000000 00000000
> [   18.802166] @000000002f983bf0 00000000 00000000 00000000 00000000
> [   18.802167] @000000002f983c00 00000000 00000000 00000000 00000000
> [   18.802169] @000000002f983c10 00000000 00000000 00000000 00000000
> [   18.802170] @000000002f983c20 00000000 00000000 00000000 00000000
> [   18.802172] @000000002f983c30 00000000 00000000 00000000 00000000
> [   18.802173] @000000002f983c40 00000000 00000000 00000000 00000000
> [   18.802175] @000000002f983c50 00000000 00000000 00000000 00000000
> [   18.802176] @000000002f983c60 00000000 00000000 00000000 00000000
> [   18.802177] @000000002f983c70 00000000 00000000 00000000 00000000
> [   18.802179] @000000002f983c80 00000000 00000000 00000000 00000000
> [   18.802180] @000000002f983c90 00000000 00000000 00000000 00000000
> [   18.802182] @000000002f983ca0 00000000 00000000 00000000 00000000
> [   18.802183] @000000002f983cb0 00000000 00000000 00000000 00000000
> [   18.802185] @000000002f983cc0 00000000 00000000 00000000 00000000
> [   18.802186] @000000002f983cd0 00000000 00000000 00000000 00000000
> [   18.802188] @000000002f983ce0 00000000 00000000 00000000 00000000
> [   18.802189] @000000002f983cf0 00000000 00000000 00000000 00000000
> [   18.802190] @000000002f983d00 00000000 00000000 00000000 00000000
> [   18.802192] @000000002f983d10 00000000 00000000 00000000 00000000
> [   18.802193] @000000002f983d20 00000000 00000000 00000000 00000000
> [   18.802195] @000000002f983d30 00000000 00000000 00000000 00000000
> [   18.802196] @000000002f983d40 00000000 00000000 00000000 00000000
> [   18.802198] @000000002f983d50 00000000 00000000 00000000 00000000
> [   18.802199] @000000002f983d60 00000000 00000000 00000000 00000000
> [   18.802200] @000000002f983d70 00000000 00000000 00000000 00000000
> [   18.802202] @000000002f983d80 00000000 00000000 00000000 00000000
> [   18.802203] @000000002f983d90 00000000 00000000 00000000 00000000
> [   18.802205] @000000002f983da0 00000000 00000000 00000000 00000000
> [   18.802206] @000000002f983db0 00000000 00000000 00000000 00000000
> [   18.802207] @000000002f983dc0 00000000 00000000 00000000 00000000
> [   18.802209] @000000002f983dd0 00000000 00000000 00000000 00000000
> [   18.802210] @000000002f983de0 00000000 00000000 00000000 00000000
> [   18.802212] @000000002f983df0 00000000 00000000 00000000 00000000
> [   18.802213] @000000002f983e00 00000000 00000000 00000000 00000000
> [   18.802215] @000000002f983e10 00000000 00000000 00000000 00000000
> [   18.802216] @000000002f983e20 00000000 00000000 00000000 00000000
> [   18.802218] @000000002f983e30 00000000 00000000 00000000 00000000
> [   18.802219] @000000002f983e40 00000000 00000000 00000000 00000000
> [   18.802220] @000000002f983e50 00000000 00000000 00000000 00000000
> [   18.802222] @000000002f983e60 00000000 00000000 00000000 00000000
> [   18.802223] @000000002f983e70 00000000 00000000 00000000 00000000
> [   18.802225] @000000002f983e80 00000000 00000000 00000000 00000000
> [   18.802226] @000000002f983e90 00000000 00000000 00000000 00000000
> [   18.802228] @000000002f983ea0 00000000 00000000 00000000 00000000
> [   18.802229] @000000002f983eb0 00000000 00000000 00000000 00000000
> [   18.802230] @000000002f983ec0 00000000 00000000 00000000 00000000
> [   18.802232] @000000002f983ed0 00000000 00000000 00000000 00000000
> [   18.802233] @000000002f983ee0 00000000 00000000 00000000 00000000
> [   18.802235] @000000002f983ef0 00000000 00000000 00000000 00000000
> [   18.802236] @000000002f983f00 00000000 00000000 00000000 00000000
> [   18.802238] @000000002f983f10 00000000 00000000 00000000 00000000
> [   18.802239] @000000002f983f20 00000000 00000000 00000000 00000000
> [   18.802240] @000000002f983f30 00000000 00000000 00000000 00000000
> [   18.802242] @000000002f983f40 00000000 00000000 00000000 00000000
> [   18.802243] @000000002f983f50 00000000 00000000 00000000 00000000
> [   18.802245] @000000002f983f60 00000000 00000000 00000000 00000000
> [   18.802246] @000000002f983f70 00000000 00000000 00000000 00000000
> [   18.802248] @000000002f983f80 00000000 00000000 00000000 00000000
> [   18.802249] @000000002f983f90 00000000 00000000 00000000 00000000
> [   18.802250] @000000002f983fa0 00000000 00000000 00000000 00000000
> [   18.802252] @000000002f983fb0 00000000 00000000 00000000 00000000
> [   18.802253] @000000002f983fc0 00000000 00000000 00000000 00000000
> [   18.802255] @000000002f983fd0 00000000 00000000 00000000 00000000
> [   18.802256] @000000002f983fe0 00000000 00000000 00000000 00000000
> [   18.802258] @000000002f983ff0 2f983000 00000000 00000000 00001802
> [   18.802259]   Ring has not been updated
> [   18.802260] Ring deq = ef983000 (virt), 0x2f983000 (dma)
> [   18.802262] Ring deq updated 0 times
> [   18.802263] Ring enq = ef983000 (virt), 0x2f983000 (dma)
> [   18.802264] Ring enq updated 0 times
> [   18.802270] // xHC command ring deq ptr low bits + flags = @00000000
> [   18.802271] // xHC command ring deq ptr high bits = @00000000
> [   18.802272] ERST memory map follows:
> [   18.802273] @000000002f844000 2f846000 00000000 00000100 00000000
> [   18.802274] Event ring:
> [   18.802276] @000000002f846000 00000000 00000000 00000000 00000000
> [   18.802277] @000000002f846010 00000000 00000000 00000000 00000000
> [   18.802278] @000000002f846020 00000000 00000000 00000000 00000000
> [   18.802280] @000000002f846030 00000000 00000000 00000000 00000000
> [   18.802281] @000000002f846040 00000000 00000000 00000000 00000000
> [   18.802283] @000000002f846050 00000000 00000000 00000000 00000000
> [   18.802284] @000000002f846060 00000000 00000000 00000000 00000000
> [   18.802286] @000000002f846070 00000000 00000000 00000000 00000000
> [   18.802287] @000000002f846080 00000000 00000000 00000000 00000000
> [   18.802289] @000000002f846090 00000000 00000000 00000000 00000000
> [   18.802290] @000000002f8460a0 00000000 00000000 00000000 00000000
> [   18.802291] @000000002f8460b0 00000000 00000000 00000000 00000000
> [   18.802293] @000000002f8460c0 00000000 00000000 00000000 00000000
> [   18.802294] @000000002f8460d0 00000000 00000000 00000000 00000000
> [   18.802296] @000000002f8460e0 00000000 00000000 00000000 00000000
> [   18.802297] @000000002f8460f0 00000000 00000000 00000000 00000000
> [   18.802299] @000000002f846100 00000000 00000000 00000000 00000000
> [   18.802300] @000000002f846110 00000000 00000000 00000000 00000000
> [   18.802301] @000000002f846120 00000000 00000000 00000000 00000000
> [   18.802303] @000000002f846130 00000000 00000000 00000000 00000000
> [   18.802304] @000000002f846140 00000000 00000000 00000000 00000000
> [   18.802305] @000000002f846150 00000000 00000000 00000000 00000000
> [   18.802307] @000000002f846160 00000000 00000000 00000000 00000000
> [   18.802308] @000000002f846170 00000000 00000000 00000000 00000000
> [   18.802310] @000000002f846180 00000000 00000000 00000000 00000000
> [   18.802311] @000000002f846190 00000000 00000000 00000000 00000000
> [   18.802313] @000000002f8461a0 00000000 00000000 00000000 00000000
> [   18.802314] @000000002f8461b0 00000000 00000000 00000000 00000000
> [   18.802316] @000000002f8461c0 00000000 00000000 00000000 00000000
> [   18.802317] @000000002f8461d0 00000000 00000000 00000000 00000000
> [   18.802318] @000000002f8461e0 00000000 00000000 00000000 00000000
> [   18.802320] @000000002f8461f0 00000000 00000000 00000000 00000000
> [   18.802321] @000000002f846200 00000000 00000000 00000000 00000000
> [   18.802323] @000000002f846210 00000000 00000000 00000000 00000000
> [   18.802324] @000000002f846220 00000000 00000000 00000000 00000000
> [   18.802326] @000000002f846230 00000000 00000000 00000000 00000000
> [   18.802327] @000000002f846240 00000000 00000000 00000000 00000000
> [   18.802328] @000000002f846250 00000000 00000000 00000000 00000000
> [   18.802330] @000000002f846260 00000000 00000000 00000000 00000000
> [   18.802331] @000000002f846270 00000000 00000000 00000000 00000000
> [   18.802333] @000000002f846280 00000000 00000000 00000000 00000000
> [   18.802334] @000000002f846290 00000000 00000000 00000000 00000000
> [   18.802336] @000000002f8462a0 00000000 00000000 00000000 00000000
> [   18.802337] @000000002f8462b0 00000000 00000000 00000000 00000000
> [   18.802338] @000000002f8462c0 00000000 00000000 00000000 00000000
> [   18.802340] @000000002f8462d0 00000000 00000000 00000000 00000000
> [   18.802341] @000000002f8462e0 00000000 00000000 00000000 00000000
> [   18.802343] @000000002f8462f0 00000000 00000000 00000000 00000000
> [   18.802344] @000000002f846300 00000000 00000000 00000000 00000000
> [   18.802346] @000000002f846310 00000000 00000000 00000000 00000000
> [   18.802347] @000000002f846320 00000000 00000000 00000000 00000000
> [   18.802349] @000000002f846330 00000000 00000000 00000000 00000000
> [   18.802350] @000000002f846340 00000000 00000000 00000000 00000000
> [   18.802352] @000000002f846350 00000000 00000000 00000000 00000000
> [   18.802353] @000000002f846360 00000000 00000000 00000000 00000000
> [   18.802354] @000000002f846370 00000000 00000000 00000000 00000000
> [   18.802356] @000000002f846380 00000000 00000000 00000000 00000000
> [   18.802357] @000000002f846390 00000000 00000000 00000000 00000000
> [   18.802359] @000000002f8463a0 00000000 00000000 00000000 00000000
> [   18.802361] @000000002f8463b0 00000000 00000000 00000000 00000000
> [   18.802362] @000000002f8463c0 00000000 00000000 00000000 00000000
> [   18.802363] @000000002f8463d0 00000000 00000000 00000000 00000000
> [   18.802365] @000000002f8463e0 00000000 00000000 00000000 00000000
> [   18.802366] @000000002f8463f0 00000000 00000000 00000000 00000000
> [   18.802367] @000000002f846400 00000000 00000000 00000000 00000000
> [   18.802369] @000000002f846410 00000000 00000000 00000000 00000000
> [   18.802370] @000000002f846420 00000000 00000000 00000000 00000000
> [   18.802372] @000000002f846430 00000000 00000000 00000000 00000000
> [   18.802373] @000000002f846440 00000000 00000000 00000000 00000000
> [   18.802375] @000000002f846450 00000000 00000000 00000000 00000000
> [   18.802376] @000000002f846460 00000000 00000000 00000000 00000000
> [   18.802377] @000000002f846470 00000000 00000000 00000000 00000000
> [   18.802379] @000000002f846480 00000000 00000000 00000000 00000000
> [   18.802380] @000000002f846490 00000000 00000000 00000000 00000000
> [   18.802382] @000000002f8464a0 00000000 00000000 00000000 00000000
> [   18.802383] @000000002f8464b0 00000000 00000000 00000000 00000000
> [   18.802385] @000000002f8464c0 00000000 00000000 00000000 00000000
> [   18.802386] @000000002f8464d0 00000000 00000000 00000000 00000000
> [   18.802388] @000000002f8464e0 00000000 00000000 00000000 00000000
> [   18.802389] @000000002f8464f0 00000000 00000000 00000000 00000000
> [   18.802390] @000000002f846500 00000000 00000000 00000000 00000000
> [   18.802392] @000000002f846510 00000000 00000000 00000000 00000000
> [   18.802393] @000000002f846520 00000000 00000000 00000000 00000000
> [   18.802394] @000000002f846530 00000000 00000000 00000000 00000000
> [   18.802396] @000000002f846540 00000000 00000000 00000000 00000000
> [   18.802397] @000000002f846550 00000000 00000000 00000000 00000000
> [   18.802398] @000000002f846560 00000000 00000000 00000000 00000000
> [   18.802400] @000000002f846570 00000000 00000000 00000000 00000000
> [   18.802402] @000000002f846580 00000000 00000000 00000000 00000000
> [   18.802403] @000000002f846590 00000000 00000000 00000000 00000000
> [   18.802404] @000000002f8465a0 00000000 00000000 00000000 00000000
> [   18.802406] @000000002f8465b0 00000000 00000000 00000000 00000000
> [   18.802407] @000000002f8465c0 00000000 00000000 00000000 00000000
> [   18.802409] @000000002f8465d0 00000000 00000000 00000000 00000000
> [   18.802410] @000000002f8465e0 00000000 00000000 00000000 00000000
> [   18.802411] @000000002f8465f0 00000000 00000000 00000000 00000000
> [   18.802413] @000000002f846600 00000000 00000000 00000000 00000000
> [   18.802414] @000000002f846610 00000000 00000000 00000000 00000000
> [   18.802416] @000000002f846620 00000000 00000000 00000000 00000000
> [   18.802417] @000000002f846630 00000000 00000000 00000000 00000000
> [   18.802419] @000000002f846640 00000000 00000000 00000000 00000000
> [   18.802420] @000000002f846650 00000000 00000000 00000000 00000000
> [   18.802421] @000000002f846660 00000000 00000000 00000000 00000000
> [   18.802423] @000000002f846670 00000000 00000000 00000000 00000000
> [   18.802424] @000000002f846680 00000000 00000000 00000000 00000000
> [   18.802426] @000000002f846690 00000000 00000000 00000000 00000000
> [   18.802427] @000000002f8466a0 00000000 00000000 00000000 00000000
> [   18.802428] @000000002f8466b0 00000000 00000000 00000000 00000000
> [   18.802430] @000000002f8466c0 00000000 00000000 00000000 00000000
> [   18.802431] @000000002f8466d0 00000000 00000000 00000000 00000000
> [   18.802433] @000000002f8466e0 00000000 00000000 00000000 00000000
> [   18.802434] @000000002f8466f0 00000000 00000000 00000000 00000000
> [   18.802436] @000000002f846700 00000000 00000000 00000000 00000000
> [   18.802437] @000000002f846710 00000000 00000000 00000000 00000000
> [   18.802438] @000000002f846720 00000000 00000000 00000000 00000000
> [   18.802440] @000000002f846730 00000000 00000000 00000000 00000000
> [   18.802441] @000000002f846740 00000000 00000000 00000000 00000000
> [   18.802443] @000000002f846750 00000000 00000000 00000000 00000000
> [   18.802444] @000000002f846760 00000000 00000000 00000000 00000000
> [   18.802446] @000000002f846770 00000000 00000000 00000000 00000000
> [   18.802447] @000000002f846780 00000000 00000000 00000000 00000000
> [   18.802449] @000000002f846790 00000000 00000000 00000000 00000000
> [   18.802450] @000000002f8467a0 00000000 00000000 00000000 00000000
> [   18.802451] @000000002f8467b0 00000000 00000000 00000000 00000000
> [   18.802453] @000000002f8467c0 00000000 00000000 00000000 00000000
> [   18.802454] @000000002f8467d0 00000000 00000000 00000000 00000000
> [   18.802456] @000000002f8467e0 00000000 00000000 00000000 00000000
> [   18.802457] @000000002f8467f0 00000000 00000000 00000000 00000000
> [   18.802459] @000000002f846800 00000000 00000000 00000000 00000000
> [   18.802460] @000000002f846810 00000000 00000000 00000000 00000000
> [   18.802461] @000000002f846820 00000000 00000000 00000000 00000000
> [   18.802463] @000000002f846830 00000000 00000000 00000000 00000000
> [   18.802464] @000000002f846840 00000000 00000000 00000000 00000000
> [   18.802466] @000000002f846850 00000000 00000000 00000000 00000000
> [   18.802467] @000000002f846860 00000000 00000000 00000000 00000000
> [   18.802469] @000000002f846870 00000000 00000000 00000000 00000000
> [   18.802470] @000000002f846880 00000000 00000000 00000000 00000000
> [   18.802471] @000000002f846890 00000000 00000000 00000000 00000000
> [   18.802473] @000000002f8468a0 00000000 00000000 00000000 00000000
> [   18.802474] @000000002f8468b0 00000000 00000000 00000000 00000000
> [   18.802476] @000000002f8468c0 00000000 00000000 00000000 00000000
> [   18.802477] @000000002f8468d0 00000000 00000000 00000000 00000000
> [   18.802478] @000000002f8468e0 00000000 00000000 00000000 00000000
> [   18.802480] @000000002f8468f0 00000000 00000000 00000000 00000000
> [   18.802481] @000000002f846900 00000000 00000000 00000000 00000000
> [   18.802482] @000000002f846910 00000000 00000000 00000000 00000000
> [   18.802484] @000000002f846920 00000000 00000000 00000000 00000000
> [   18.802485] @000000002f846930 00000000 00000000 00000000 00000000
> [   18.802487] @000000002f846940 00000000 00000000 00000000 00000000
> [   18.802488] @000000002f846950 00000000 00000000 00000000 00000000
> [   18.802490] @000000002f846960 00000000 00000000 00000000 00000000
> [   18.802491] @000000002f846970 00000000 00000000 00000000 00000000
> [   18.802493] @000000002f846980 00000000 00000000 00000000 00000000
> [   18.802494] @000000002f846990 00000000 00000000 00000000 00000000
> [   18.802495] @000000002f8469a0 00000000 00000000 00000000 00000000
> [   18.802497] @000000002f8469b0 00000000 00000000 00000000 00000000
> [   18.802498] @000000002f8469c0 00000000 00000000 00000000 00000000
> [   18.802500] @000000002f8469d0 00000000 00000000 00000000 00000000
> [   18.802501] @000000002f8469e0 00000000 00000000 00000000 00000000
> [   18.802503] @000000002f8469f0 00000000 00000000 00000000 00000000
> [   18.802504] @000000002f846a00 00000000 00000000 00000000 00000000
> [   18.802505] @000000002f846a10 00000000 00000000 00000000 00000000
> [   18.802507] @000000002f846a20 00000000 00000000 00000000 00000000
> [   18.802508] @000000002f846a30 00000000 00000000 00000000 00000000
> [   18.802510] @000000002f846a40 00000000 00000000 00000000 00000000
> [   18.802511] @000000002f846a50 00000000 00000000 00000000 00000000
> [   18.802513] @000000002f846a60 00000000 00000000 00000000 00000000
> [   18.802514] @000000002f846a70 00000000 00000000 00000000 00000000
> [   18.802515] @000000002f846a80 00000000 00000000 00000000 00000000
> [   18.802517] @000000002f846a90 00000000 00000000 00000000 00000000
> [   18.802518] @000000002f846aa0 00000000 00000000 00000000 00000000
> [   18.802520] @000000002f846ab0 00000000 00000000 00000000 00000000
> [   18.802521] @000000002f846ac0 00000000 00000000 00000000 00000000
> [   18.802523] @000000002f846ad0 00000000 00000000 00000000 00000000
> [   18.802524] @000000002f846ae0 00000000 00000000 00000000 00000000
> [   18.802526] @000000002f846af0 00000000 00000000 00000000 00000000
> [   18.802527] @000000002f846b00 00000000 00000000 00000000 00000000
> [   18.802528] @000000002f846b10 00000000 00000000 00000000 00000000
> [   18.802530] @000000002f846b20 00000000 00000000 00000000 00000000
> [   18.802531] @000000002f846b30 00000000 00000000 00000000 00000000
> [   18.802533] @000000002f846b40 00000000 00000000 00000000 00000000
> [   18.802534] @000000002f846b50 00000000 00000000 00000000 00000000
> [   18.802536] @000000002f846b60 00000000 00000000 00000000 00000000
> [   18.802537] @000000002f846b70 00000000 00000000 00000000 00000000
> [   18.802538] @000000002f846b80 00000000 00000000 00000000 00000000
> [   18.802540] @000000002f846b90 00000000 00000000 00000000 00000000
> [   18.802541] @000000002f846ba0 00000000 00000000 00000000 00000000
> [   18.802543] @000000002f846bb0 00000000 00000000 00000000 00000000
> [   18.802544] @000000002f846bc0 00000000 00000000 00000000 00000000
> [   18.802545] @000000002f846bd0 00000000 00000000 00000000 00000000
> [   18.802547] @000000002f846be0 00000000 00000000 00000000 00000000
> [   18.802548] @000000002f846bf0 00000000 00000000 00000000 00000000
> [   18.802550] @000000002f846c00 00000000 00000000 00000000 00000000
> [   18.802551] @000000002f846c10 00000000 00000000 00000000 00000000
> [   18.802552] @000000002f846c20 00000000 00000000 00000000 00000000
> [   18.802554] @000000002f846c30 00000000 00000000 00000000 00000000
> [   18.802555] @000000002f846c40 00000000 00000000 00000000 00000000
> [   18.802557] @000000002f846c50 00000000 00000000 00000000 00000000
> [   18.802558] @000000002f846c60 00000000 00000000 00000000 00000000
> [   18.802559] @000000002f846c70 00000000 00000000 00000000 00000000
> [   18.802561] @000000002f846c80 00000000 00000000 00000000 00000000
> [   18.802562] @000000002f846c90 00000000 00000000 00000000 00000000
> [   18.802564] @000000002f846ca0 00000000 00000000 00000000 00000000
> [   18.802565] @000000002f846cb0 00000000 00000000 00000000 00000000
> [   18.802567] @000000002f846cc0 00000000 00000000 00000000 00000000
> [   18.802568] @000000002f846cd0 00000000 00000000 00000000 00000000
> [   18.802569] @000000002f846ce0 00000000 00000000 00000000 00000000
> [   18.802571] @000000002f846cf0 00000000 00000000 00000000 00000000
> [   18.802572] @000000002f846d00 00000000 00000000 00000000 00000000
> [   18.802574] @000000002f846d10 00000000 00000000 00000000 00000000
> [   18.802575] @000000002f846d20 00000000 00000000 00000000 00000000
> [   18.802576] @000000002f846d30 00000000 00000000 00000000 00000000
> [   18.802578] @000000002f846d40 00000000 00000000 00000000 00000000
> [   18.802579] @000000002f846d50 00000000 00000000 00000000 00000000
> [   18.802581] @000000002f846d60 00000000 00000000 00000000 00000000
> [   18.802582] @000000002f846d70 00000000 00000000 00000000 00000000
> [   18.802583] @000000002f846d80 00000000 00000000 00000000 00000000
> [   18.802585] @000000002f846d90 00000000 00000000 00000000 00000000
> [   18.802586] @000000002f846da0 00000000 00000000 00000000 00000000
> [   18.802588] @000000002f846db0 00000000 00000000 00000000 00000000
> [   18.802589] @000000002f846dc0 00000000 00000000 00000000 00000000
> [   18.802591] @000000002f846dd0 00000000 00000000 00000000 00000000
> [   18.802592] @000000002f846de0 00000000 00000000 00000000 00000000
> [   18.802593] @000000002f846df0 00000000 00000000 00000000 00000000
> [   18.802595] @000000002f846e00 00000000 00000000 00000000 00000000
> [   18.802596] @000000002f846e10 00000000 00000000 00000000 00000000
> [   18.802598] @000000002f846e20 00000000 00000000 00000000 00000000
> [   18.802599] @000000002f846e30 00000000 00000000 00000000 00000000
> [   18.802601] @000000002f846e40 00000000 00000000 00000000 00000000
> [   18.802602] @000000002f846e50 00000000 00000000 00000000 00000000
> [   18.802603] @000000002f846e60 00000000 00000000 00000000 00000000
> [   18.802605] @000000002f846e70 00000000 00000000 00000000 00000000
> [   18.802606] @000000002f846e80 00000000 00000000 00000000 00000000
> [   18.802608] @000000002f846e90 00000000 00000000 00000000 00000000
> [   18.802609] @000000002f846ea0 00000000 00000000 00000000 00000000
> [   18.802611] @000000002f846eb0 00000000 00000000 00000000 00000000
> [   18.802612] @000000002f846ec0 00000000 00000000 00000000 00000000
> [   18.802614] @000000002f846ed0 00000000 00000000 00000000 00000000
> [   18.802615] @000000002f846ee0 00000000 00000000 00000000 00000000
> [   18.802616] @000000002f846ef0 00000000 00000000 00000000 00000000
> [   18.802618] @000000002f846f00 00000000 00000000 00000000 00000000
> [   18.802619] @000000002f846f10 00000000 00000000 00000000 00000000
> [   18.802621] @000000002f846f20 00000000 00000000 00000000 00000000
> [   18.802622] @000000002f846f30 00000000 00000000 00000000 00000000
> [   18.802624] @000000002f846f40 00000000 00000000 00000000 00000000
> [   18.802625] @000000002f846f50 00000000 00000000 00000000 00000000
> [   18.802626] @000000002f846f60 00000000 00000000 00000000 00000000
> [   18.802628] @000000002f846f70 00000000 00000000 00000000 00000000
> [   18.802629] @000000002f846f80 00000000 00000000 00000000 00000000
> [   18.802631] @000000002f846f90 00000000 00000000 00000000 00000000
> [   18.802632] @000000002f846fa0 00000000 00000000 00000000 00000000
> [   18.802634] @000000002f846fb0 00000000 00000000 00000000 00000000
> [   18.802635] @000000002f846fc0 00000000 00000000 00000000 00000000
> [   18.802636] @000000002f846fd0 00000000 00000000 00000000 00000000
> [   18.802638] @000000002f846fe0 00000000 00000000 00000000 00000000
> [   18.802639] @000000002f846ff0 00000000 00000000 00000000 00000000
> [   18.802641]   Ring has not been updated
> [   18.802642] Ring deq = ef846000 (virt), 0x2f846000 (dma)
> [   18.802643] Ring deq updated 0 times
> [   18.802644] Ring enq = ef846000 (virt), 0x2f846000 (dma)
> [   18.802645] Ring enq updated 0 times
> [   18.802651] ERST deq = 64'h2f846000
> [   18.802652] // Set the interrupt modulation register
> [   18.802658] // Enable interrupts, cmd = 0x4.
> [   18.802661] // Enabling event ring interrupter fd032020 by writing 0x2 to irq_pending
> [   18.802667]   fd032020: ir_set[0]
> [   18.802668]   fd032020: ir_set.pending = 0x2
> [   18.802671]   fd032024: ir_set.control = 0xa0
> [   18.802674]   fd032028: ir_set.erst_size = 0x1
> [   18.802681]   fd032030: ir_set.erst_base = @2f844000
> [   18.802688]   fd032038: ir_set.erst_dequeue = @2f846000
> [   18.802689] Finished xhci_run for USB2 roothub
> [   18.802703] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> [   18.802705] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   18.802707] usb usb5: Product: xHCI Host Controller
> [   18.802708] usb usb5: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> [   18.802710] usb usb5: SerialNumber: 0000:06:00.0
> [   18.803048] hub 5-0:1.0: USB hub found
> [   18.803058] hub 5-0:1.0: 2 ports detected
> [   18.803068] set port power, actual port 0 status  = 0x2a0
> [   18.803079] set port power, actual port 1 status  = 0x2a0
> [   18.803132] xhci_hcd 0000:06:00.0: xHCI Host Controller
> [   18.803179] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 6
> [   18.803186] Enabling 64-bit DMA addresses.
> [   18.803190] // Turn on HC, cmd = 0x5.
> [   18.803194] Finished xhci_run for USB3 roothub
> [   18.803205] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> [   18.803207] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   18.803209] usb usb6: Product: xHCI Host Controller
> [   18.803210] usb usb6: Manufacturer: Linux 3.4.0-rc4 xhci_hcd
> [   18.803211] usb usb6: SerialNumber: 0000:06:00.0
> [   18.803300] hub 6-0:1.0: USB hub found
> [   18.803309] hub 6-0:1.0: 2 ports detected
> [   18.803319] set port power, actual port 0 status  = 0x2a0
> [   18.803330] set port power, actual port 1 status  = 0x2a0
> [   18.900143] get port status, actual port 0 status  = 0x2a0
> [   18.900145] Get port status returned 0x100
> [   18.900150] get port status, actual port 1 status  = 0x2a0
> [   18.900152] Get port status returned 0x100
> [   18.903115] get port status, actual port 0 status  = 0x2a0
> [   18.903116] Get port status returned 0x2a0
> [   18.903121] get port status, actual port 1 status  = 0x2a0
> [   18.903122] Get port status returned 0x2a0
> [   22.675294] Slot 1 output ctx = 0x2f088000 (dma)
> [   22.675984] [sched_delayed] sched: RT throttling activated
> [   22.685417] Slot 1 input ctx = 0x2f250000 (dma)
> [   22.689976] Set slot id 1 dcbaa entry ef92e008 to 0x2f088000
> [   22.695659] set port reset, actual port 2 status  = 0x1311
> [   22.695763] udevd[379]: renamed network interface eth0 to p5p1
> [   22.706966] Port Status Change Event for port 7
> [   22.718802] EXT4-fs (sda1): re-mounted. Opts: (null)
> [   22.721490] parport_pc 00:08: reported by Plug and Play ACPI
> [   22.721577] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> Started Remount Root FS                                                [  OK  ]
> Starting Configure read-only root support...
> [   22.760055] iTCO_vendor_support: vendor-support=0
> [   22.764797] get port status, actual port 2 status  = 0x201203
> [   22.765138] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
> [   22.765209] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
> [   22.784012] Get port status returned 0x100203
> Started Configure read-only root support                               [  OK  ]
> [   22.826845] ppdev: user-space parallel port driver
> [   22.838787] clear port reset change, actual port 2 status  = 0x1203
> [   22.845059] Set root hub portnum to 7
> [   22.848723] Set fake root hub portnum to 3
> [   22.852821] udev->tt =   (null)
> [   22.855965] udev->ttport = 0x0
> [   22.859023] Slot ID 1 Input Context:
> [   22.862608] @ef250000 (virt) @2f250000 (dma) 0x000000 - drop flags
> [   22.868794] @ef250004 (virt) @2f250004 (dma) 0x000003 - add flags
> [   22.874890] @ef250008 (virt) @2f250008 (dma) 0x000000 - rsvd2[0]
> [   22.874892] @ef25000c (virt) @2f25000c (dma) 0x000000 - rsvd2[1]
> [   22.874893] @ef250010 (virt) @2f250010 (dma) 0x000000 - rsvd2[2]
> [   22.874894] @ef250014 (virt) @2f250014 (dma) 0x000000 - rsvd2[3]
> [   22.874895] @ef250018 (virt) @2f250018 (dma) 0x000000 - rsvd2[4]
> [   22.874896] @ef25001c (virt) @2f25001c (dma) 0x000000 - rsvd2[5]
> [   22.874897] Slot Context:
> [   22.874898] @ef250020 (virt) @2f250020 (dma) 0x8400000 - dev_info
> [   22.874899] @ef250024 (virt) @2f250024 (dma) 0x070000 - dev_info2
> [   22.874900] @ef250028 (virt) @2f250028 (dma) 0x000000 - tt_info
> [   22.874901] @ef25002c (virt) @2f25002c (dma) 0x000000 - dev_state
> [   22.874903] @ef250030 (virt) @2f250030 (dma) 0x000000 - rsvd[0]
> [   22.874904] @ef250034 (virt) @2f250034 (dma) 0x000000 - rsvd[1]
> [   22.874905] @ef250038 (virt) @2f250038 (dma) 0x000000 - rsvd[2]
> [   22.874906] @ef25003c (virt) @2f25003c (dma) 0x000000 - rsvd[3]
> [   22.874907] Endpoint 00 Context:
> [   22.874908] @ef250040 (virt) @2f250040 (dma) 0x000000 - ep_info
> [   22.874909] @ef250044 (virt) @2f250044 (dma) 0x2000026 - ep_info2
> [   22.874910] @ef250048 (virt) @2f250048 (dma) 0x2f963001 - deq
> [   22.874912] @ef250050 (virt) @2f250050 (dma) 0x000000 - tx_info
> [   22.874913] @ef250054 (virt) @2f250054 (dma) 0x000000 - rsvd[0]
> [   22.874914] @ef250058 (virt) @2f250058 (dma) 0x000000 - rsvd[1]
> [   22.874915] @ef25005c (virt) @2f25005c (dma) 0x000000 - rsvd[2]
> [   22.874916] Endpoint 01 Context:
> [   22.874917] @ef250060 (virt) @2f250060 (dma) 0x000000 - ep_info
> [   22.874918] @ef250064 (virt) @2f250064 (dma) 0x000000 - ep_info2
> [   22.874919] @ef250068 (virt) @2f250068 (dma) 0x000000 - deq
> [   22.874920] @ef250070 (virt) @2f250070 (dma) 0x000000 - tx_info
> [   22.874922] @ef250074 (virt) @2f250074 (dma) 0x000000 - rsvd[0]
> [   22.874923] @ef250078 (virt) @2f250078 (dma) 0x000000 - rsvd[1]
> [   22.874924] @ef25007c (virt) @2f25007c (dma) 0x000000 - rsvd[2]
> [   22.874925] Endpoint 02 Context:
> [   22.874926] @ef250080 (virt) @2f250080 (dma) 0x000000 - ep_info
> [   22.874927] @ef250084 (virt) @2f250084 (dma) 0x000000 - ep_info2
> [   22.874928] @ef250088 (virt) @2f250088 (dma) 0x000000 - deq
> [   22.874929] @ef250090 (virt) @2f250090 (dma) 0x000000 - tx_info
> [   22.874930] @ef250094 (virt) @2f250094 (dma) 0x000000 - rsvd[0]
> [   22.874931] @ef250098 (virt) @2f250098 (dma) 0x000000 - rsvd[1]
> [   22.874932] @ef25009c (virt) @2f25009c (dma) 0x000000 - rsvd[2]
> [   22.874934] // Ding dong!
> [   22.874957] Successful Address Device command
> [   22.874963] Op regs DCBAA ptr = 0x0000002f92e000
> [   22.874965] Slot ID 1 dcbaa entry @ef92e008 = 0x0000002f088000
> [   22.874966] Output Context DMA address = 0x2f088000
> [   22.874966] Slot ID 1 Input Context:
> [   22.874967] @ef250000 (virt) @2f250000 (dma) 0x000000 - drop flags
> [   22.874969] @ef250004 (virt) @2f250004 (dma) 0x000003 - add flags
> [   22.874970] @ef250008 (virt) @2f250008 (dma) 0x000000 - rsvd2[0]
> [   22.874971] @ef25000c (virt) @2f25000c (dma) 0x000000 - rsvd2[1]
> [   22.874972] @ef250010 (virt) @2f250010 (dma) 0x000000 - rsvd2[2]
> [   22.874973] @ef250014 (virt) @2f250014 (dma) 0x000000 - rsvd2[3]
> [   22.874974] @ef250018 (virt) @2f250018 (dma) 0x000000 - rsvd2[4]
> [   22.874976] @ef25001c (virt) @2f25001c (dma) 0x000000 - rsvd2[5]
> [   22.874976] Slot Context:
> [   22.874977] @ef250020 (virt) @2f250020 (dma) 0x8400000 - dev_info
> [   22.874978] @ef250024 (virt) @2f250024 (dma) 0x070000 - dev_info2
> [   22.874979] @ef250028 (virt) @2f250028 (dma) 0x000000 - tt_info
> [   22.874981] @ef25002c (virt) @2f25002c (dma) 0x000000 - dev_state
> [   22.874982] @ef250030 (virt) @2f250030 (dma) 0x000000 - rsvd[0]
> [   22.874983] @ef250034 (virt) @2f250034 (dma) 0x000000 - rsvd[1]
> [   22.874984] @ef250038 (virt) @2f250038 (dma) 0x000000 - rsvd[2]
> [   22.874985] @ef25003c (virt) @2f25003c (dma) 0x000000 - rsvd[3]
> [   22.874986] Endpoint 00 Context:
> [   22.874987] @ef250040 (virt) @2f250040 (dma) 0x000000 - ep_info
> [   22.874988] @ef250044 (virt) @2f250044 (dma) 0x2000026 - ep_info2
> [   22.874989] @ef250048 (virt) @2f250048 (dma) 0x2f963001 - deq
> [   22.874990] @ef250050 (virt) @2f250050 (dma) 0x000000 - tx_info
> [   22.874991] @ef250054 (virt) @2f250054 (dma) 0x000000 - rsvd[0]
> [   22.874993] @ef250058 (virt) @2f250058 (dma) 0x000000 - rsvd[1]
> [   22.874994] @ef25005c (virt) @2f25005c (dma) 0x000000 - rsvd[2]
> [   22.874995] Endpoint 01 Context:
> [   22.874995] @ef250060 (virt) @2f250060 (dma) 0x000000 - ep_info
> [   22.874997] @ef250064 (virt) @2f250064 (dma) 0x000000 - ep_info2
> [   22.874998] @ef250068 (virt) @2f250068 (dma) 0x000000 - deq
> [   22.874999] @ef250070 (virt) @2f250070 (dma) 0x000000 - tx_info
> [   22.875000] @ef250074 (virt) @2f250074 (dma) 0x000000 - rsvd[0]
> [   22.875001] @ef250078 (virt) @2f250078 (dma) 0x000000 - rsvd[1]
> [   22.875002] @ef25007c (virt) @2f25007c (dma) 0x000000 - rsvd[2]
> [   22.875003] Endpoint 02 Context:
> [   22.875004] @ef250080 (virt) @2f250080 (dma) 0x000000 - ep_info
> [   22.875005] @ef250084 (virt) @2f250084 (dma) 0x000000 - ep_info2
> [   22.875006] @ef250088 (virt) @2f250088 (dma) 0x000000 - deq
> [   22.875007] @ef250090 (virt) @2f250090 (dma) 0x000000 - tx_info
> [   22.875008] @ef250094 (virt) @2f250094 (dma) 0x000000 - rsvd[0]
> [   22.875009] @ef250098 (virt) @2f250098 (dma) 0x000000 - rsvd[1]
> [   22.875011] @ef25009c (virt) @2f25009c (dma) 0x000000 - rsvd[2]
> [   22.875011] Slot ID 1 Output Context:
> [   22.875012] Slot Context:
> [   22.875013] @ef088000 (virt) @2f088000 (dma) 0x8400000 - dev_info
> [   22.875014] @ef088004 (virt) @2f088004 (dma) 0x070000 - dev_info2
> [   22.875015] @ef088008 (virt) @2f088008 (dma) 0x000000 - tt_info
> [   22.875016] @ef08800c (virt) @2f08800c (dma) 0x10000001 - dev_state
> [   22.875018] @ef088010 (virt) @2f088010 (dma) 0x000000 - rsvd[0]
> [   22.875019] @ef088014 (virt) @2f088014 (dma) 0x000000 - rsvd[1]
> [   22.875020] @ef088018 (virt) @2f088018 (dma) 0x000000 - rsvd[2]
> [   22.875021] @ef08801c (virt) @2f08801c (dma) 0x000000 - rsvd[3]
> [   22.875022] Endpoint 00 Context:
> [   22.875023] @ef088020 (virt) @2f088020 (dma) 0x000001 - ep_info
> [   22.875024] @ef088024 (virt) @2f088024 (dma) 0x2000026 - ep_info2
> [   22.875025] @ef088028 (virt) @2f088028 (dma) 0x2f963001 - deq
> [   22.875026] @ef088030 (virt) @2f088030 (dma) 0x000000 - tx_info
> [   22.875027] @ef088034 (virt) @2f088034 (dma) 0x000000 - rsvd[0]
> [   22.875028] @ef088038 (virt) @2f088038 (dma) 0x000000 - rsvd[1]
> [   22.875029] @ef08803c (virt) @2f08803c (dma) 0x000000 - rsvd[2]
> [   22.875030] Endpoint 01 Context:
> [   22.875031] @ef088040 (virt) @2f088040 (dma) 0x000000 - ep_info
> [   22.875032] @ef088044 (virt) @2f088044 (dma) 0x000000 - ep_info2
> [   22.875033] @ef088048 (virt) @2f088048 (dma) 0x000000 - deq
> [   22.875034] @ef088050 (virt) @2f088050 (dma) 0x000000 - tx_info
> [   22.875036] @ef088054 (virt) @2f088054 (dma) 0x000000 - rsvd[0]
> [   22.875037] @ef088058 (virt) @2f088058 (dma) 0x000000 - rsvd[1]
> [   22.875038] @ef08805c (virt) @2f08805c (dma) 0x000000 - rsvd[2]
> [   22.875039] Endpoint 02 Context:
> [   22.875040] @ef088060 (virt) @2f088060 (dma) 0x000000 - ep_info
> [   22.875041] @ef088064 (virt) @2f088064 (dma) 0x000000 - ep_info2
> [   22.875042] @ef088068 (virt) @2f088068 (dma) 0x000000 - deq
> [   22.875043] @ef088070 (virt) @2f088070 (dma) 0x000000 - tx_info
> [   22.875044] @ef088074 (virt) @2f088074 (dma) 0x000000 - rsvd[0]
> [   22.875045] @ef088078 (virt) @2f088078 (dma) 0x000000 - rsvd[1]
> [   22.875046] @ef08807c (virt) @2f08807c (dma) 0x000000 - rsvd[2]
> [   22.875047] Internal device address = 2
> [   22.875050] usb 4-3: new SuperSpeed USB device number 2 using xhci_hcd
> [   22.885987] usb 4-3: Int endpoint with wBytesPerInterval of 4096 in config 1 interface 0 altsetting 0 ep 130: setting to 1
> [   22.885991] usb 4-3: Int endpoint with wBytesPerInterval of 4096 in config 1 interface 0 altsetting 1 ep 130: setting to 1024
> [   22.885993] usb 4-3: New USB device found, idVendor=1d5c, idProduct=8347
> [   22.885995] usb 4-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [   22.886051] add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18400000
> [   22.886054] add ep 0x82, slot id 1, new drop flags = 0x0, new add flags = 0x28, new slot info = 0x28400000
> [   22.886057] add ep 0x1, slot id 1, new drop flags = 0x0, new add flags = 0x2c, new slot info = 0x28400000
> [   22.886059] xhci_check_bandwidth called for udev eff47400
> [   22.886060] New Input Control Context:
> [   22.886061] @ef250000 (virt) @2f250000 (dma) 0x000000 - drop flags
> [   22.886062] @ef250004 (virt) @2f250004 (dma) 0x00002d - add flags
> [   22.886064] @ef250008 (virt) @2f250008 (dma) 0x000000 - rsvd2[0]
> [   22.886065] @ef25000c (virt) @2f25000c (dma) 0x000000 - rsvd2[1]
> [   22.886066] @ef250010 (virt) @2f250010 (dma) 0x000000 - rsvd2[2]
> [   22.886067] @ef250014 (virt) @2f250014 (dma) 0x000000 - rsvd2[3]
> [   22.886068] @ef250018 (virt) @2f250018 (dma) 0x000000 - rsvd2[4]
> [   22.886069] @ef25001c (virt) @2f25001c (dma) 0x000000 - rsvd2[5]
> [   22.886070] Slot Context:
> [   22.886071] @ef250020 (virt) @2f250020 (dma) 0x28400000 - dev_info
> [   22.886072] @ef250024 (virt) @2f250024 (dma) 0x070000 - dev_info2
> [   22.886074] @ef250028 (virt) @2f250028 (dma) 0x000000 - tt_info
> [   22.886075] @ef25002c (virt) @2f25002c (dma) 0x000000 - dev_state
> [   22.886076] @ef250030 (virt) @2f250030 (dma) 0x000000 - rsvd[0]
> [   22.886077] @ef250034 (virt) @2f250034 (dma) 0x000000 - rsvd[1]
> [   22.886078] @ef250038 (virt) @2f250038 (dma) 0x000000 - rsvd[2]
> [   22.886079] @ef25003c (virt) @2f25003c (dma) 0x000000 - rsvd[3]
> [   22.886080] Endpoint 00 Context:
> [   22.886081] @ef250040 (virt) @2f250040 (dma) 0x000000 - ep_info
> [   22.886082] @ef250044 (virt) @2f250044 (dma) 0x2000026 - ep_info2
> [   22.886084] @ef250048 (virt) @2f250048 (dma) 0x2f963001 - deq
> [   22.886085] @ef250050 (virt) @2f250050 (dma) 0x000000 - tx_info
> [   22.886086] @ef250054 (virt) @2f250054 (dma) 0x000000 - rsvd[0]
> [   22.886087] @ef250058 (virt) @2f250058 (dma) 0x000000 - rsvd[1]
> [   22.886088] @ef25005c (virt) @2f25005c (dma) 0x000000 - rsvd[2]
> [   22.886089] Endpoint 01 Context:
> [   22.886090] @ef250060 (virt) @2f250060 (dma) 0x000000 - ep_info
> [   22.886091] @ef250064 (virt) @2f250064 (dma) 0x4000f16 - ep_info2
> [   22.886092] @ef250068 (virt) @2f250068 (dma) 0x2f0ac001 - deq
> [   22.886093] @ef250070 (virt) @2f250070 (dma) 0x000000 - tx_info
> [   22.886094] @ef250074 (virt) @2f250074 (dma) 0x000000 - rsvd[0]
> [   22.886095] @ef250078 (virt) @2f250078 (dma) 0x000000 - rsvd[1]
> [   22.886097] @ef25007c (virt) @2f25007c (dma) 0x000000 - rsvd[2]
> [   22.886098] Endpoint 02 Context:
> [   22.886098] @ef250080 (virt) @2f250080 (dma) 0x000000 - ep_info
> [   22.886100] @ef250084 (virt) @2f250084 (dma) 0x4000036 - ep_info2
> [   22.886101] @ef250088 (virt) @2f250088 (dma) 0x2f21e001 - deq
> [   22.886102] @ef250090 (virt) @2f250090 (dma) 0x000000 - tx_info
> [   22.886103] @ef250094 (virt) @2f250094 (dma) 0x000000 - rsvd[0]
> [   22.886104] @ef250098 (virt) @2f250098 (dma) 0x000000 - rsvd[1]
> [   22.886105] @ef25009c (virt) @2f25009c (dma) 0x000000 - rsvd[2]
> [   22.886106] Endpoint 03 Context:
> [   22.886107] @ef2500a0 (virt) @2f2500a0 (dma) 0x000000 - ep_info
> [   22.886108] @ef2500a4 (virt) @2f2500a4 (dma) 0x000000 - ep_info2
> [   22.886109] @ef2500a8 (virt) @2f2500a8 (dma) 0x000000 - deq
> [   22.886110] @ef2500b0 (virt) @2f2500b0 (dma) 0x000000 - tx_info
> [   22.886111] @ef2500b4 (virt) @2f2500b4 (dma) 0x000000 - rsvd[0]
> [   22.886112] @ef2500b8 (virt) @2f2500b8 (dma) 0x000000 - rsvd[1]
> [   22.886113] @ef2500bc (virt) @2f2500bc (dma) 0x000000 - rsvd[2]
> [   22.886114] Endpoint 04 Context:
> [   22.886115] @ef2500c0 (virt) @2f2500c0 (dma) 0x000000 - ep_info
> [   22.886116] @ef2500c4 (virt) @2f2500c4 (dma) 0x01003e - ep_info2
> [   22.886117] @ef2500c8 (virt) @2f2500c8 (dma) 0x2f10f001 - deq
> [   22.886119] @ef2500d0 (virt) @2f2500d0 (dma) 0x010001 - tx_info
> [   22.886120] @ef2500d4 (virt) @2f2500d4 (dma) 0x000000 - rsvd[0]
> [   22.886121] @ef2500d8 (virt) @2f2500d8 (dma) 0x000000 - rsvd[1]
> [   22.886122] @ef2500dc (virt) @2f2500dc (dma) 0x000000 - rsvd[2]
> [   22.886123] // Ding dong!
> [   22.886308] Completed config ep cmd
> [   22.886316] Output context after successful config ep cmd:
> [   22.886316] Slot Context:
> [   22.886317] @ef088000 (virt) @2f088000 (dma) 0x28400000 - dev_info
> [   22.886319] @ef088004 (virt) @2f088004 (dma) 0x070000 - dev_info2
> [   22.886320] @ef088008 (virt) @2f088008 (dma) 0x000000 - tt_info
> [   22.886321] @ef08800c (virt) @2f08800c (dma) 0x18000001 - dev_state
> [   22.886322] @ef088010 (virt) @2f088010 (dma) 0x000000 - rsvd[0]
> [   22.886323] @ef088014 (virt) @2f088014 (dma) 0x000000 - rsvd[1]
> [   22.886324] @ef088018 (virt) @2f088018 (dma) 0x000000 - rsvd[2]
> [   22.886325] @ef08801c (virt) @2f08801c (dma) 0x000000 - rsvd[3]
> [   22.886326] Endpoint 00 Context:
> [   22.886327] @ef088020 (virt) @2f088020 (dma) 0x000001 - ep_info
> [   22.886328] @ef088024 (virt) @2f088024 (dma) 0x2000026 - ep_info2
> [   22.886329] @ef088028 (virt) @2f088028 (dma) 0x2f963001 - deq
> [   22.886331] @ef088030 (virt) @2f088030 (dma) 0x000000 - tx_info
> [   22.886332] @ef088034 (virt) @2f088034 (dma) 0x000000 - rsvd[0]
> [   22.886333] @ef088038 (virt) @2f088038 (dma) 0x000000 - rsvd[1]
> [   22.886334] @ef08803c (virt) @2f08803c (dma) 0x000000 - rsvd[2]
> [   22.886335] Endpoint 01 Context:
> [   22.886336] @ef088040 (virt) @2f088040 (dma) 0x000001 - ep_info
> [   22.886337] @ef088044 (virt) @2f088044 (dma) 0x4000f16 - ep_info2
> [   22.886338] @ef088048 (virt) @2f088048 (dma) 0x2f0ac001 - deq
> [   22.886339] @ef088050 (virt) @2f088050 (dma) 0x000000 - tx_info
> [   22.886340] @ef088054 (virt) @2f088054 (dma) 0x000000 - rsvd[0]
> [   22.886341] @ef088058 (virt) @2f088058 (dma) 0x000000 - rsvd[1]
> [   22.886342] @ef08805c (virt) @2f08805c (dma) 0x000000 - rsvd[2]
> [   22.886343] Endpoint 02 Context:
> [   22.886344] @ef088060 (virt) @2f088060 (dma) 0x000001 - ep_info
> [   22.886345] @ef088064 (virt) @2f088064 (dma) 0x4000036 - ep_info2
> [   22.886346] @ef088068 (virt) @2f088068 (dma) 0x2f21e001 - deq
> [   22.886348] @ef088070 (virt) @2f088070 (dma) 0x000000 - tx_info
> [   22.886349] @ef088074 (virt) @2f088074 (dma) 0x000000 - rsvd[0]
> [   22.886350] @ef088078 (virt) @2f088078 (dma) 0x000000 - rsvd[1]
> [   22.886351] @ef08807c (virt) @2f08807c (dma) 0x000000 - rsvd[2]
> [   22.886352] Endpoint 03 Context:
> [   22.886353] @ef088080 (virt) @2f088080 (dma) 0x000000 - ep_info
> [   22.886354] @ef088084 (virt) @2f088084 (dma) 0x000000 - ep_info2
> [   22.886355] @ef088088 (virt) @2f088088 (dma) 0x000000 - deq
> [   22.886356] @ef088090 (virt) @2f088090 (dma) 0x000000 - tx_info
> [   22.886357] @ef088094 (virt) @2f088094 (dma) 0x000000 - rsvd[0]
> [   22.886358] @ef088098 (virt) @2f088098 (dma) 0x000000 - rsvd[1]
> [   22.886359] @ef08809c (virt) @2f08809c (dma) 0x000000 - rsvd[2]
> [   22.886360] Endpoint 04 Context:
> [   22.886361] @ef0880a0 (virt) @2f0880a0 (dma) 0x000001 - ep_info
> [   22.886362] @ef0880a4 (virt) @2f0880a4 (dma) 0x01003e - ep_info2
> [   22.886363] @ef0880a8 (virt) @2f0880a8 (dma) 0x2f10f001 - deq
> [   22.886364] @ef0880b0 (virt) @2f0880b0 (dma) 0x010001 - tx_info
> [   22.886365] @ef0880b4 (virt) @2f0880b4 (dma) 0x000000 - rsvd[0]
> [   22.886367] @ef0880b8 (virt) @2f0880b8 (dma) 0x000000 - rsvd[1]
> [   22.886368] @ef0880bc (virt) @2f0880bc (dma) 0x000000 - rsvd[2]
> [   22.886388] Endpoint 0x81 not halted, refusing to reset.
> [   22.886389] Endpoint 0x82 not halted, refusing to reset.
> [   22.886390] Endpoint 0x1 not halted, refusing to reset.
> [   22.890233] mtp-probe[588]: checking bus 4, device 2: "/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/usb4/4-3"
> [   22.959634] get port status, actual port 0 status  = 0x2a0
> [   22.959636] Get port status returned 0x100
> [   22.959640] get port status, actual port 1 status  = 0x2a0
> [   22.959641] Get port status returned 0x100
> [   22.959643] get port status, actual port 2 status  = 0x2a0
> [   22.959644] Get port status returned 0x100
> [   22.959647] get port status, actual port 3 status  = 0x2a0
> [   22.959648] Get port status returned 0x100
> [   22.959780] mtp-probe[588]: bus: 4, device: 2 was not an MTP device
> [   22.961726] flusbfb: (null) (null) - serial #(null)
> [   22.961729] flusbfb: vid_1d5c&pid_8347&rev_0100 driver's fl_data struct at ef124000
> [   22.961731] flusbfb: bLength=18
> [   22.961732] flusbfb: bDescriptorType=1
> [   22.961733] flusbfb: bcdUSB=0x0300
> [   22.961734] flusbfb: bDeviceClass=0
> [   22.961735] flusbfb: bDeviceSubClass=0
> [   22.961736] flusbfb: bDeviceProtocol=0
> [   22.961737] flusbfb: bMaxPacketSize0=9
> [   22.961739] flusbfb: idVendor=0x1d5c
> [   22.961740] flusbfb: idProduct=0x8347
> [   22.961741] flusbfb: bcdDevice=0x0100
> [   22.961742] flusbfb: iManufacturer=0
> [   22.961743] flusbfb: iProduct=0
> [   22.961744] flusbfb: iSerialNumber=0
> [   22.961745] flusbfb: bNumConfigurations=1
> [   22.961746] flusbfb: console enable=1
> [   22.961747] flusbfb: fb_defio enable=1
> [   22.961748] flusbfb: shadow enable=1
> [   22.961768] Stalled endpoint
> [   22.961771] Cleaning up stalled endpoint ring
> [   22.961773] Finding segment containing stopped TRB.
> [   22.961774] Finding endpoint context
> [   22.961775] Finding segment containing last TRB in TD.
> [   22.961777] Cycle state = 0x1
> [   22.961778] New dequeue segment = f573cff0 (virtual)
> [   22.961779] New dequeue pointer = 0x2f963170 (DMA)
> [   22.961780] Queueing new dequeue state
> [   22.961782] Set TR Deq Ptr cmd, new deq seg = f573cff0 (0x2f963000 dma), new deq ptr = ef963170 (0x2f963170 dma), new cycle = 1
> [   22.961783] // Ding dong!
> [   22.961787] Giveback URB f5522600, len = 0, expected = 100, status = -32
> [   22.961790] Ignoring reset ep completion code of 1
> [   22.961807] Successful Set TR Deq Ptr cmd, deq = @2f963171
> [   22.961846] Stalled endpoint
> [   22.961847] Cleaning up stalled endpoint ring
> [   22.961848] Finding segment containing stopped TRB.
> [   22.961849] Finding endpoint context
> [   22.961849] Finding segment containing last TRB in TD.
> [   22.961850] Cycle state = 0x1
> [   22.961851] New dequeue segment = f573cff0 (virtual)
> [   22.961852] New dequeue pointer = 0x2f9631a0 (DMA)
> [   22.961853] Queueing new dequeue state
> [   22.961854] Set TR Deq Ptr cmd, new deq seg = f573cff0 (0x2f963000 dma), new deq ptr = ef9631a0 (0x2f9631a0 dma), new cycle = 1
> [   22.961855] // Ding dong!
> [   22.961859] Giveback URB f5522600, len = 0, expected = 100, status = -32
> [   22.961862] Ignoring reset ep completion code of 1
> [   22.961886] Successful Set TR Deq Ptr cmd, deq = @2f9631a1
> [   22.961926] Stalled endpoint
> [   22.961928] Cleaning up stalled endpoint ring
> [   22.961929] Finding segment containing stopped TRB.
> [   22.961930] Finding endpoint context
> [   22.961931] Finding segment containing last TRB in TD.
> [   22.961932] Cycle state = 0x1
> [   22.961933] New dequeue segment = f573cff0 (virtual)
> [   22.961935] New dequeue pointer = 0x2f9631d0 (DMA)
> [   22.961936] Queueing new dequeue state
> [   22.961938] Set TR Deq Ptr cmd, new deq seg = f573cff0 (0x2f963000 dma), new deq ptr = ef9631d0 (0x2f9631d0 dma), new cycle = 1
> [   22.961940] // Ding dong!
> [   22.961945] Giveback URB f5522600, len = 0, expected = 100, status = -32
> [   22.961948] Ignoring reset ep completion code of 1
> [   22.961950] flusbfb: vendor descriptor not available (-32)
> [   22.961968] Successful Set TR Deq Ptr cmd, deq = @2f9631d1
> [   22.973018] flusbfb: allocated 12 6220800 byte urbs
> [   22.974071] usbcore: registered new interface driver ufl
> [   22.976116] flusbfb: Read EDID retryIndex=0
> [   22.986193] flusbfb: Read EDID retryIndex=1
> [   23.005270] flusbfb: Read EDID retryIndex=0
> [   23.015294] flusbfb: Read EDID retryIndex=1
> [   23.034367] flusbfb: Read EDID retryIndex=0
> [   23.044388] flusbfb: Read EDID retryIndex=1
> [   23.063451] flusbfb: Read EDID retryIndex=0
> [   23.073470] flusbfb: Read EDID retryIndex=1
> [   23.092532] flusbfb: Read EDID retryIndex=0
> [   23.102550] flusbfb: Read EDID retryIndex=1
> [   23.121616] flusbfb: Read EDID retryIndex=0
> [   23.131635] flusbfb: Read EDID retryIndex=1
> [   23.150695] flusbfb: Read EDID retryIndex=0
> [   23.160714] flusbfb: Read EDID retryIndex=1
> [   23.179776] flusbfb: Read EDID retryIndex=0
> [   23.189793] flusbfb: Read EDID retryIndex=1
> [   23.208853] flusbfb: Read EDID retryIndex=0
> [   23.218871] flusbfb: Read EDID retryIndex=1
> [   23.237941] flusbfb: Read EDID retryIndex=0
> [   23.247956] flusbfb: Read EDID retryIndex=1
> [   23.267022] flusbfb: Read EDID retryIndex=0
> [   23.277038] flusbfb: Read EDID retryIndex=1
> [   23.296101] flusbfb: Read EDID retryIndex=0
> [   23.306118] flusbfb: Read EDID retryIndex=1
> [   23.325183] flusbfb: Read EDID retryIndex=0
> [   23.335203] flusbfb: Read EDID retryIndex=1
> [   23.354264] flusbfb: Read EDID retryIndex=0
> [   23.364278] flusbfb: Read EDID retryIndex=1
> [   23.383341] flusbfb: Read EDID retryIndex=0
> [   23.393356] flusbfb: Read EDID retryIndex=1
> [   23.412418] flusbfb: Read EDID retryIndex=0
> [   23.422434] flusbfb: Read EDID retryIndex=1
> [   23.441501] flusbfb: Read EDID retryIndex=0
> [   23.451518] flusbfb: Read EDID retryIndex=1
> [   23.470579] flusbfb: Read EDID retryIndex=0
> [   23.480596] flusbfb: Read EDID retryIndex=1
> [   23.490612] flusbfb: Read EDID retryIndex=2
> [   23.500632] flusbfb: Read EDID retryIndex=3
> [   23.519692] flusbfb: Read EDID retryIndex=0
> [   23.529706] flusbfb: Read EDID retryIndex=1
> [   23.548768] flusbfb: Read EDID retryIndex=0
> [   23.558784] flusbfb: Read EDID retryIndex=1
> [   23.577851] flusbfb: Read EDID retryIndex=0
> [   23.587865] flusbfb: Read EDID retryIndex=1
> [   23.606934] flusbfb: Read EDID retryIndex=0
> [   23.616949] flusbfb: Read EDID retryIndex=1
> [   23.636017] flusbfb: Read EDID retryIndex=0
> [   23.646031] flusbfb: Read EDID retryIndex=1
> [   23.665098] flusbfb: Read EDID retryIndex=0
> [   23.675114] flusbfb: Read EDID retryIndex=1
> [   23.694175] flusbfb: Read EDID retryIndex=0
> [   23.704196] flusbfb: Read EDID retryIndex=1
> [   23.723259] flusbfb: Read EDID retryIndex=0
> [   23.733279] flusbfb: Read EDID retryIndex=1
> [   23.752338] flusbfb: Read EDID retryIndex=0
> [   23.762359] flusbfb: Read EDID retryIndex=1
> [   23.781425] flusbfb: Read EDID retryIndex=0
> [   23.791443] flusbfb: Read EDID retryIndex=1
> [   23.810503] flusbfb: Read EDID retryIndex=0
> [   23.820522] flusbfb: Read EDID retryIndex=1
> [   23.839586] flusbfb: Read EDID retryIndex=0
> [   23.849601] flusbfb: Read EDID retryIndex=1
> [   23.868664] flusbfb: Read EDID retryIndex=0
> [   23.878683] flusbfb: Read EDID retryIndex=1
> [   23.897745] flusbfb: Read EDID retryIndex=0
> [   23.907761] flusbfb: Read EDID retryIndex=1
> [   23.923793]
> [   23.923794] 00ffffffffffff00 38b81a9501010101
> [   23.923799] 31130103082b1a78 eac905a3574b9c25
> [   23.923804] 125054a54a0081c0 0101010101010101
> [   23.923808] 0101010101016621 56aa51001e30468f
> [   23.923812] 3300aeff1000001e 000000fd00384c1f
> [   23.923817] 5210000a20202020 2020000000fc0039
> [   23.923821] 354e410a20202020 20202020000000ff
> [   23.923825] 0039354e414e4739 34393137313000cc
> [   23.923835] flusbfb: 1366x768 valid mode
> [   23.923837] flusbfb: 720x400 valid mode
> [   23.923838] flusbfb: 640x480 valid mode
> [   23.923840] flusbfb: 640x480 valid mode
> [   23.923843] flusbfb: 800x600 valid mode
> [   23.923844] flusbfb: 800x600 valid mode
> [   23.923845] flusbfb: 1024x768 valid mode
> [   23.923847] flusbfb: 1024x768 valid mode
> [   23.923848] flusbfb: 1280x720 valid mode
> [   23.923850] flusbfb: Reallocating framebuffer. Addresses will change!
> [   23.924152] flusbfb: 1366x768 valid mode
> [   23.924153] set_par mode 1366x768
> [   23.924154] func=fresco_SetResolution
> [   23.924156] var->xres=1366, var->yres=768
> [   23.924157] refresh=60
> [   23.925313] step 1 PLL read back rbuf[0]=0x09
> [   23.925314] step 1 PLL read back rbuf[1]=0x01
> [   23.925316] step 1 PLL read back rbuf[2]=0x36
> [   23.925317] step 1 PLL read back rbuf[3]=0x00
> [   23.925708] fresco_SetResolution pass
> [   23.925765] flusbfb: frescologic USB device /dev/fb1 attached. 1366x768 resolution. Using 6152K framebuffer memory
> Starting /dev/disk/by-uuid/e2c31c2b-73f2-4361-a5dc-0d132cb90d5a.[   25.002808] Adding 4193276k swap on /dev/sda2.  Priority:0 extents:1 across:4193276k
> ..
> Started udev Wait for Complete Device Initialization                   [  OK  ]
> Started /dev/disk/by-uuid/e2c31c2b-73f2-4361-a5dc-0d132cb90d5a         [  OK  ]
> Starting Wait for storage scan...
> Started Show Plymouth Boot Screen                                      [  OK  ]
> Started Wait for storage scan                                          [  OK  ]
> Starting Initialize storage subsystems (RAID, LVM, etc.)...
> [   25.203830] fedora-storage-init[606]: Setting up Logical Volume Management:   No volume groups found
> [   25.213029] fedora-storage-init[606]: [  OK  ]
> Started Initialize storage subsystems (RAID, LVM, etc.)                [  OK  ]
> Starting Initialize storage subsystems (RAID, LVM, etc.)...
> [   25.432746] set port remote wake mask, actual port 0 status  = 0xe0002a0
> [   25.439458] set port remote wake mask, actual port 1 status  = 0xe0002a0
> [   25.462694] fedora-storage-init[612]: Setting up Logical Volume Management:   No volume groups found
> [   25.471871] fedora-storage-init[612]: [  OK  ]
> Started Initialize storage subsystems (RAID, LVM, etc.)                [  OK  ]
> Starting Monitoring of LVM2 mirrors, snapshots etc. using d...ogress polling...
> [   25.547351] lvm[618]: No volume groups found
> Started Monitoring of LVM2 mirrors, snapshots etc. u...rogress polling [  OK  ]
> Started Mark the need to relabel after reboot                          [  OK  ]
> Started Relabel all filesystems, if necessary                          [  OK  ]
> Started Reconfigure the system on administrator request                [  OK  ]
> Starting Tell Plymouth To Write Out Runtime Data...
> Starting Load Random Seed...
> Starting Recreate Volatile Files and Directories...
> Started Load Random Seed                                               [  OK  ]
> Sta[   25.659208] alsactl[627]: /sbin/alsactl: load_state:1686: No soundcards found...
> rted Recreate Volatile Files and Directories                        [  OK  ]
> Started Tell Plymouth To Write Out Runtime Data                        [  OK  ]
> Starting Console System Startup Logging...
> Startin[   25.690624] sandbox[630]: Starting sandbox[  OK  ]
> g Restore Sound Card State...
> Starting SYSV: sandbox, xguest and other apps that want to ...rate na[   25.707725] auditd[631]: Started dispatcher: /sbin/audispd pid: 636
> mespace...
> Sta[   25.715273] audispd[636]: audispd initialized with q_depth=120 and 1 active plugins
> rted Load static[   25.725075] auditctl[633]: No rules
>  arp entries    [   25.728933] auditctl[633]: AUDIT_STATUS: enabled=0 flag=1 pid=631 rate_limit=0 backlog_limit=320 lost=0 backlog=0
>                                     [  OK  ]
> Starte[   25.744775] avahi-daemon[645]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
> d IPv4 firewall [   25.754165] avahi-daemon[645]: Successfully dropped root privileges.
> with iptables   [   25.761809] avahi-daemon[645]: avahi-daemon 0.6.30 starting up.
>                                 [   25.770715] abrtd[646]: Init complete, entering main loop
>  [  OK  ]
> Started IPv6 firewall with ip6tables                                   [  OK  ]
> Starting Security Auditing Service...
> sandbox[63[   25.794252] avahi-daemon[645]: WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
> 0]: Starting sandbox[  OK  ]
> Starting Machine Check Exception Logging Daemon..[   25.810349] auditd[631]: Init complete, auditd 2.2.1 listening for events (startup state enable)
> .
> Starting Avahi mDNS/DNS-SD Stack...
> Starting ABRT Automated Bug Reporting Tool...
> Started ABRT Automated Bug Reporting Tool                              [  OK  ]
> Starting Harvest vmcores for ABRT...
> Starting irqbalance daemon...
> Starting SSH server keys generation....
> Starting Network Manager...
> Starting ABRT kernel log watcher...             [   26.044942] NetworkManager[656]: <info> NetworkManager (version 0.9.4-2.git20120403.fc16) is starting...
>                 [   26.054759] NetworkManager[656]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
> 
> Started ABRT kernel log watcher                                        [  OK  ]
> Starting Job spooling tools...
> Started Job spooling tools                                             [  OK  ]
> Starting Install ABRT coredump hook...
> Starting ACPI Event Daemon...                    [   26.560013] acpid[672]: starting up with netlink and the input layer
>                 [   26.566992] acpid[672]: skipping incomplete file /etc/acpi/events/videoconf
> [   26.575357] acpid[672]: 1 rule loaded
> [   26.579024] acpid[672]: waiting for events: event logging is off
> 
> Starting System Logging Service...
> Started Software RAID monitoring and management                        [  OK  ]
> Starting System Setup Keyboard...
> Started System Setup Keyboard                                          [  OK  ]
> Starting Wait for Plymouth Boot Screen to Quit...
> Starting D-Bus System Message Bus...
> Starting Login Service...
> Started Console System Startup Logging                                 [  OK  ]
> Started Restore Sound Card State                                       [  OK  ]
> Started SYSV: sandbox, xguest and other apps that wa...arate namespace [  OK  ]
> Started Security Auditing Service                                      [  OK  ]
> Started Machine Check Exception Logging Daemon                         [  OK  ]
> Started Harvest vmcores for ABRT                                       [  OK  ]
> Started irqbalance daemon                                              [  OK  ]
> Started SSH server keys generation.                                    [  OK  ]
> Started Install ABRT coredump hook                                     [  OK  ]
> Started ACPI Event Daemon                                              [  OK  ]
> Starting Command Scheduler...
> Started Command Scheduler                                              [  OK  ]
> Starting LSB: Mount and unmount network filesystems....
> Started D-Bus System Message Bus                                       [  OK  ]
> Stopping Syslog Kernel Log Buffer Bridge...
> Stopped Syslog Kernel Log Buffer Bridge                                [  OK  ]
> Started System Logging Service                                         [  OK  ]
> Started Login Service                                                  [  OK  ]
> Started Avahi mDNS/DNS-SD Stack                                        [  OK  ]
> Started Network Manager                                                [  OK  ]
> Starting NFSv4 ID-name mapping daemon...
> [   28.494953] r8169 0000:07:00.0: p5p1: link down
> Starting Sendmai[   28.499666] ADDRCONF(NETDEV_UP): p5p1: link is not ready
> l Mail Transport Agent...       [   28.507886] r8169 0000:07:00.0: p5p1: link down
>                 [   28.513568] NOHZ: local_softirq_pending 08
> 
> Starting OpenSSH server daemon...
> Started OpenSSH server daemon                                          [  OK  ]
> Starting RPC bind service...
> Starting Samba SMB Daemon...
> Started LSB: Mount and unmount network filesystems.                    [  OK  ]
> Started NFSv4 ID-name mapping daemon                                   [  OK  ]
> Started RPC bind service                                               [  OK  ]
> Starting NFS file locking service....
> Starting Permit User Sessions...
> Started Samba SMB Daemon                                               [  OK  ]
> Started Permit User Sessions                                           [  OK  ]
> Starting Display Manager...
> Started Display Manager                                                [  OK  ]
> Starting CUPS Printing Service...
> Started CUPS Printing Service                                          [  OK  ]
> Started NFS file locking service.                                      [  OK  ]
> [   28.822771] func=fl_ops_open
> [   28.825698] flusbfb: open /dev/fb1 user=1 fb_info=eff1b000 count=1
> [   28.832035] flusbfb: released /dev/fb1 user=1 count=0
> [   28.837125] frame_buffer_auto_repeat_timer_exit
> [   28.852917] get port status, actual port 0 status  = 0x2a0
> [   28.858398] Get port status returned 0x100
> [   28.862572] get port status, actual port 1 status  = 0x2a0
> [   28.868049] Get port status returned 0x100
> [   28.872216] get port status, actual port 2 status  = 0x2a0
> [   28.872264] func=fl_ops_open
> [   28.872266] flusbfb: open /dev/fb1 user=1 fb_info=eff1b000 count=1
> [   28.872274] func=fl_ops_open
> [   28.872275] flusbfb: open /dev/fb1 user=1 fb_info=eff1b000 count=2
> [   28.895784] Get port status returned 0x100
> [   28.899956] get port status, actual port 3 status  = 0x2a0
> [   28.905438] Get port status returned 0x100
> [   28.919939] get port status, actual port 0 status  = 0x2a0
> [   28.925418] Get port status returned 0x100
> [   28.929554] get port status, actual port 1 status  = 0x2a0
> [   28.935036] Get port status returned 0x100
> [   28.949901] get port status, actual port 0 status  = 0x2a0
> [   28.955391] Get port status returned 0x2a0
> [   28.959520] get port status, actual port 1 status  = 0x2a0
> [   28.964999] Get port status returned 0x2a0
> [   30.054863] flusbfb: /dev/fb1 FB_BLANK mode 0 --> 0
> [   30.065458] r8169 0000:07:00.0: p5p1: link up
> [   30.069948] ADDRCONF(NETDEV_CHANGE): p5p1: link becomes ready
> 
> Fedora release 16 (Verne)
> Kernel 3.4.0-rc4 on an i686 (ttyS0)
> 
> ga-p61-fc16 login: [   31.423398] set port remote wake mask, actual port 0 status  = 0xe0002a0
> [   31.430120] set port remote wake mask, actual port 1 status  = 0xe0002a0
> [   37.586317] ERROR no room on ep ring, try ring expansion
> [   37.591627] ring expansion succeed, now has 4 segments
> [   38.197849] BUG: scheduling while atomic: Xorg/757/0x00000100
> [   38.203602] Modules linked in: lockd flusbfb(O) iTCO_wdt iTCO_vendor_support ppdev parport_pc parport r8169 mii xhci_hcd uinput pcspkr i2c_i801 coretemp microcode sunrpc crc32c_intel nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
> [   38.228297] Pid: 757, comm: Xorg Tainted: G           O 3.4.0-rc4 #4
> [   38.234661] Call Trace:
> [   38.237122]  [<c0832fe7>] ? printk+0x2d/0x2f
> [   38.241400]  [<c08333fb>] __schedule_bug+0x51/0x53
> [   38.246215]  [<c0838e2c>] __schedule+0x5b/0x57b
> [   38.250756]  [<c0479fb4>] ? arch_local_irq_save+0x12/0x17
> [   38.256162]  [<c0839da6>] ? _raw_spin_lock_irqsave+0x10/0x2a
> [   38.261836]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> [   38.267954]  [<c0443423>] ? __mod_timer+0x105/0x110
> [   38.272841]  [<c083957c>] schedule+0x56/0x58
> [   38.277136]  [<c08384ba>] schedule_timeout+0x8a/0xb7
> [   38.282103]  [<c045fc6c>] ? check_preempt_wakeup+0x121/0x19f
> [   38.287778]  [<c0442a88>] ? del_timer+0x61/0x61
> [   38.292319]  [<c0838c69>] __down_common+0x7b/0xb4
> [   38.297034]  [<c0838cb6>] __down_timeout+0x14/0x16
> [   38.301832]  [<c0453c41>] down_timeout+0x31/0x44
> [   38.306454]  [<f7ef758e>] fl_get_urb+0x1d/0x85 [flusbfb]
> [   38.311772]  [<f7ef8104>] frame_buffer_auto_repeat_timer_callback+0x45/0xf8 [flusbfb]
> [   38.319606]  [<c0412a72>] ? native_sched_clock+0x4d/0x52
> [   38.324926]  [<c044320b>] run_timer_softirq+0x14b/0x221
> [   38.330158]  [<c049cdfc>] ? __rcu_process_callbacks+0x64/0x286
> [   38.335999]  [<f7ef80bf>] ? fl_add_redraw_frame_count+0x10/0x10 [flusbfb]
> [   38.342790]  [<c043d7dd>] __do_softirq+0xa2/0x17b
> [   38.347496]  [<c043d73b>] ? ftrace_define_fields_irq_handler_entry+0x71/0x71
> [   38.354556]  <IRQ>  [<c043da3d>] ? irq_exit+0x45/0x96
> [   38.359633]  [<c042576f>] ? smp_apic_timer_interrupt+0x69/0x76
> [   38.365470]  [<c083aa55>] ? apic_timer_interrupt+0x31/0x38
> [   38.370963]  [<c0830000>] ? powernowk8_cpu_init+0x4b1/0xc6d
> [   38.776730] BUG: scheduling while atomic: swapper/2/0/0x00000100
> [   38.782742] Modules linked in: lockd flusbfb(O) iTCO_wdt iTCO_vendor_support ppdev parport_pc parport r8169 mii xhci_hcd uinput pcspkr i2c_i801 coretemp microcode sunrpc crc32c_intel nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
> [   38.807464] Pid: 0, comm: swapper/2 Tainted: G           O 3.4.0-rc4 #4
> [   38.814079] Call Trace:
> [   38.816545]  [<c0832fe7>] ? printk+0x2d/0x2f
> [   38.820821]  [<c08333fb>] __schedule_bug+0x51/0x53
> [   38.825615]  [<c0838e2c>] __schedule+0x5b/0x57b
> [   38.830173]  [<c0479fb4>] ? arch_local_irq_save+0x12/0x17
> [   38.835585]  [<c0839da6>] ? _raw_spin_lock_irqsave+0x10/0x2a
> [   38.841244]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> [   38.847354]  [<c0443423>] ? __mod_timer+0x105/0x110
> [   38.852240]  [<c083957c>] schedule+0x56/0x58
> [   38.856520]  [<c08384ba>] schedule_timeout+0x8a/0xb7
> [   38.861493]  [<c0442a88>] ? del_timer+0x61/0x61
> [   38.866051]  [<c0838c69>] __down_common+0x7b/0xb4
> [   38.870768]  [<c0838cb6>] __down_timeout+0x14/0x16
> [   38.875583]  [<c0453c41>] down_timeout+0x31/0x44
> [   38.880222]  [<f7ef758e>] fl_get_urb+0x1d/0x85 [flusbfb]
> [   38.885575]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> [   38.891693]  [<f7ef8104>] frame_buffer_auto_repeat_timer_callback+0x45/0xf8 [flusbfb]
> [   38.899524]  [<c044320b>] run_timer_softirq+0x14b/0x221
> [   38.904758]  [<f7ef80bf>] ? fl_add_redraw_frame_count+0x10/0x10 [flusbfb]
> [   38.911558]  [<c043d7dd>] __do_softirq+0xa2/0x17b
> [   38.916271]  [<c043d73b>] ? ftrace_define_fields_irq_handler_entry+0x71/0x71
> [   38.923314]  <IRQ>  [<c043da3d>] ? irq_exit+0x45/0x96
> [   38.928393]  [<c042576f>] ? smp_apic_timer_interrupt+0x69/0x76
> [   38.934233]  [<c041243e>] ? read_tsc+0x9/0x26
> [   38.938600]  [<c083aa55>] ? apic_timer_interrupt+0x31/0x38
> [   38.944103]  [<c04300e0>] ? free_memtype+0x63/0x154
> [   38.948983]  [<c0626978>] ? intel_idle+0xca/0xfa
> [   38.953619]  [<c0750379>] ? cpuidle_enter+0xe/0x12
> [   38.958434]  [<c0750803>] ? cpuidle_idle_call+0xbe/0x169
> [   38.963755]  [<c0414004>] ? cpu_idle+0x8f/0xb3
> [   38.968200]  [<c082c36e>] ? start_secondary+0x255/0x25a
> [   38.973431] bad: scheduling from the idle thread!
> [   38.978136] Pid: 0, comm: swapper/2 Tainted: G           O 3.4.0-rc4 #4
> [   38.984746] Call Trace:
> [   38.987202]  [<c0832fe7>] ? printk+0x2d/0x2f
> [   38.991483]  [<c045e50c>] dequeue_task_idle+0x26/0x32
> [   38.996559]  [<c045a50c>] dequeue_task+0xcc/0xd4
> [   39.001195]  [<c045a891>] deactivate_task+0x21/0x24
> [   39.006081]  [<c0838ec1>] __schedule+0xf0/0x57b
> [   39.010621]  [<c0479fb4>] ? arch_local_irq_save+0x12/0x17
> [   39.016021]  [<c0839da6>] ? _raw_spin_lock_irqsave+0x10/0x2a
> [   39.021687]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> [   39.027795]  [<c0443423>] ? __mod_timer+0x105/0x110
> [   39.032673]  [<c083957c>] schedule+0x56/0x58
> [   39.036954]  [<c08384ba>] schedule_timeout+0x8a/0xb7
> [   39.041919]  [<c0442a88>] ? del_timer+0x61/0x61
> [   39.046458]  [<c0838c69>] __down_common+0x7b/0xb4
> [   39.051164]  [<c0838cb6>] __down_timeout+0x14/0x16
> [   39.055955]  [<c0453c41>] down_timeout+0x31/0x44
> [   39.060576]  [<f7ef758e>] fl_get_urb+0x1d/0x85 [flusbfb]
> [   39.065895]  [<c0839def>] ? _raw_spin_unlock_irqrestore+0x14/0x16
> [   39.072005]  [<f7ef8104>] frame_buffer_auto_repeat_timer_callback+0x45/0xf8 [flusbfb]
> [   39.079836]  [<c044320b>] run_timer_softirq+0x14b/0x221
> [   39.085071]  [<f7ef80bf>] ? fl_add_redraw_frame_count+0x10/0x10 [flusbfb]
> [   39.091870]  [<c043d7dd>] __do_softirq+0xa2/0x17b
> [   39.096584]  [<c043d73b>] ? ftrace_define_fields_irq_handler_entry+0x71/0x71
> [   39.103624]  <IRQ>  [<c043da3d>] ? irq_exit+0x45/0x96
> [   39.108704]  [<c042576f>] ? smp_apic_timer_interrupt+0x69/0x76
> [   39.114538]  [<c041243e>] ? read_tsc+0x9/0x26
> [   39.118905]  [<c083aa55>] ? apic_timer_interrupt+0x31/0x38
> [   39.124399]  [<c04300e0>] ? free_memtype+0x63/0x154
> [   39.129285]  [<c0626978>] ? intel_idle+0xca/0xfa
> [   39.133912]  [<c0750379>] ? cpuidle_enter+0xe/0x12
> [   39.138721]  [<c0750803>] ? cpuidle_idle_call+0xbe/0x169
> [   39.144041]  [<c0414004>] ? cpu_idle+0x8f/0xb3
> [   39.148486]  [<c082c36e>] ? start_secondary+0x255/0x25a

