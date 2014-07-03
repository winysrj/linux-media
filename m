Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41849 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaGXLMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 07:12:21 -0400
Received: by mail-pa0-f48.google.com with SMTP id et14so3728208pad.35
        for <linux-media@vger.kernel.org>; Thu, 24 Jul 2014 04:12:20 -0700 (PDT)
Date: Fri, 4 Jul 2014 00:00:51 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: regression: (repost) firmware loading for dvico dual digital 4
Message-ID: <20140703140051.GA65555@shambles.windy>
References: <CAEsFdVOLAE+VzZ0pQv33Ga-vEN4D3=0ktcFjn4ejZ1rR=nww7w@mail.gmail.com>
 <20140630115633.6c5b5d95.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630115633.6c5b5d95.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
thanks for taking the time to look at this.

On Mon, Jun 30, 2014 at 11:56:33AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 30 Jun 2014 23:19:46 +1000
> Vincent McIntyre <vincent.mcintyre@gmail.com> escreveu:
> 
> > Hi,
> > 
> > I am reposting this since it got ignored/missed last time around...
> > 
> > On 5/14/14, Vincent McIntyre <vincent.mcintyre@gmail.com> wrote:
> > > Hi,
> > >
> > > Antti asked me to report this.
> > >
> > > I built the latest media_build git on Ubuntu 12.04, with 3.8.0 kernel,
> > > using './build --main-git'.
> > > The attached tarball has the relvant info.
> > >
> > > Without the media_build modules, firmware loads fine (file dmesg.1)
> > > Once I build and install the media_build modules, the firmware no
> > > longer loads. (dmesg.2)
> > >
> > > The firmware loading issue appears to have been reported to ubuntu (a
> > > later kernel, 3.11)  with a possible fix proposed, see
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1291459
> > >
> > > I can post lspci etc details if people want.
> > >
> > 
> > An updated version of the tar file is attached.
> > 
> > dmesg.1 is from 3.8.0-38 plus media-build modules and shows the
> > firmware loading issue.
> > The media-build HEAD revision was
> >   commit e4a8d40f63afa8b0276ea7758d9b4d32e64a964d
> >   Author: Hans Verkuil <hans.verkuil@cisco.com>
> >   Date:   Wed Jun 18 10:27:51 2014 +0200
> > 
> > dmesg.2 is from 3.8.0-42 with the ubuntu-provided modules and does not
> > show the issue.
> > 
> > The issue occurs in later ubuntu kernels, 3.11 as noted previously
> > and 3.13.0-30.
> > 
> > The OS is ubuntu 12.04 LTS, amd64.
> > 
> > I looked into bisecting this but could not figure out a procedure
> > since the 'build' script tries really hard to use the latest
> > media-build and kernel sources. It looks like one has to run the
> > media-build 'make' against a checkout of the vanilla kernel that
> > roughly corresponds in time (or at least is not from a time later than
> > the current media-build revision that is checked out).
> 
> > 
> > 
> > Please respond this time
> 
> Next time, please add the logs directly at the email, as this makes
> clearer about what's the problem and what driver has the issues.
> 

Ok. I wanted to ensure it did not get mangled into unreadability
by the journey through various email systems.

> Anyway, based on this:
> 
> [   16.332247] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> [   16.344378] cxusb: i2c wr: len=64 is too big!
> 
> I suspect that the enclosed patch should fix your issue. Please test. If it
> works, please reply to this email with:
> 	Tested-by: your name <your@email>
> 

The patch is working for me. My tested-by is inline below.
Test procedure:
- git checkout git://linuxtv.org/media_build.git
- cd media_build
- ./build --main-git
- grep "define MAX_XFER_SIZE" media/drivers/media/usb/dvb-usb/cxusb.c
#define MAX_XFER_SIZE  64
- vi media/drivers/media/usb/dvb-usb/cxusb.c
- grep "define MAX_XFER_SIZE" media/drivers/media/usb/dvb-usb/cxusb.c
#define MAX_XFER_SIZE  80
- cd media; make -C ../v4l; cd ..
- sudo make install
- sudo halt
- (after boot) dmesg
- try to tune one of the receivers - works ok
- dmesg

The final dmesg output is inline below.

> Cheers,
> Mauro
> 
> -
> 
> cxusb: increase buffer lenght to 80 bytes
> 
> As reported by Vincent:
> 	[   16.332247] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> 	[   16.344378] cxusb: i2c wr: len=64 is too big!
> 
> 64 bytes is too short for firmware load on this device. So, increase it
> to 80 bytes.
> 
> Reported-by: Vincent McIntyre <vincent.mcintyre@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Tested-by: Vincent McIntyre <vincent.mcintyre@gmail.com>

> 
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index 6acde5ee4324..a22726ccca64 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -44,7 +44,7 @@
>  #include "atbm8830.h"
>  
>  /* Max transfer size done by I2C transfer functions */
> -#define MAX_XFER_SIZE  64
> +#define MAX_XFER_SIZE  80
>  
>  /* debug */
>  static int dvb_usb_cxusb_debug;
> 

Final dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-38-generic (buildd@lamiak) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #56~precise1-Ubuntu SMP Thu Mar 13 16:22:48 UTC 2014 (Ubuntu 3.8.0-38.56~precise1-generic 3.8.13.19)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-38-generic root=UUID=00d24ba0-1c1a-420b-a0de-e811e8a8b90c ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ed12fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ed13000-0x000000007ed14fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007ed15000-0x000000007ee2dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ee2e000-0x000000007eee4fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007eee5000-0x000000007eee8fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007eee9000-0x000000007eef2fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007eef3000-0x000000007eef3fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007eef4000-0x000000007eefefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007eeff000-0x000000007eefffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ef00000-0x000000007effffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI:                  /DG33BU, BIOS DPP3510J.86A.0293.2007.1002.1519 10/02/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x7ef00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F000000 mask FFF000000 uncachable
[    0.000000]   2 base 07EF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2032MB, range: 16MB, type UC
[    0.000000] reg 2, base: 2031MB, range: 1MB, type UC
[    0.000000] total RAM covered: 2031M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2031MB, range: 1MB, type UC
[    0.000000] reg 2, base: 2032MB, range: 16MB, type UC
[    0.000000] found SMP MP-table at [mem 0x000fe200-0x000fe20f] mapped at [ffff8800000fe200]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x7eefffff]
[    0.000000]  [mem 0x00000000-0x7edfffff] page 2M
[    0.000000]  [mem 0x7ee00000-0x7eefffff] page 4k
[    0.000000] kernel direct mapping tables up to 0x7eefffff @ [mem 0x1fffc000-0x1fffffff]
[    0.000000] RAMDISK: [mem 0x35f4c000-0x36f9dfff]
[    0.000000] ACPI: RSDP 00000000000fe020 00014 (v00 INTEL )
[    0.000000] ACPI: RSDT 000000007eefd038 00060 (v01 INTEL  DG33BU   00000125      01000013)
[    0.000000] ACPI: FACP 000000007eefc000 00074 (v01 INTEL  DG33BU   00000125 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000007eef8000 03D05 (v01 INTEL  DG33BU   00000125 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007ee99000 00040
[    0.000000] ACPI: APIC 000000007eef7000 00078 (v01 INTEL  DG33BU   00000125 MSFT 01000013)
[    0.000000] ACPI: WDDT 000000007eef6000 00040 (v01 INTEL  DG33BU   00000125 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000007eef5000 0003C (v01 INTEL  DG33BU   00000125 MSFT 01000013)
[    0.000000] ACPI: ASF! 000000007eef4000 000A6 (v32 INTEL  DG33BU   00000125 MSFT 01000013)
[    0.000000] ACPI: DMAR 000000007eef2000 00128 (v01 INTEL  DG33BU   00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eef1000 00204 (v01 INTEL     CpuPm 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eef0000 00175 (v01 INTEL   Cpu0Ist 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eeef000 00175 (v01 INTEL   Cpu1Ist 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eeee000 00175 (v01 INTEL   Cpu2Ist 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eeed000 00175 (v01 INTEL   Cpu3Ist 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eeec000 000DD (v01 INTEL   Cpu0Cst 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eeeb000 000DD (v01 INTEL   Cpu1Cst 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eeea000 000DD (v01 INTEL   Cpu2Cst 00000125 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000007eee9000 000DD (v01 INTEL   Cpu3Cst 00000125 MSFT 01000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007eefffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7eefffff]
[    0.000000]   NODE_DATA [mem 0x7ee29000-0x7ee2dfff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007c400000-ffff88007e3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7ed12fff]
[    0.000000]   node   0: [mem 0x7ed15000-0x7ee2dfff]
[    0.000000]   node   0: [mem 0x7eee5000-0x7eee8fff]
[    0.000000]   node   0: [mem 0x7eef3000-0x7eef3fff]
[    0.000000]   node   0: [mem 0x7eeff000-0x7eefffff]
[    0.000000] On node 0 totalpages: 519616
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8060 pages used for memmap
[    0.000000]   DMA32 zone: 507574 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007ed13000 - 000000007ed15000
[    0.000000] PM: Registered nosave memory: 000000007ee2e000 - 000000007eee5000
[    0.000000] PM: Registered nosave memory: 000000007eee9000 - 000000007eef3000
[    0.000000] PM: Registered nosave memory: 000000007eef4000 - 000000007eeff000
[    0.000000] e820: [mem 0x7f000000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007ea00000 s84928 r8192 d21568 u524288
[    0.000000] pcpu-alloc: s84928 r8192 d21568 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 511486
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-38-generic root=UUID=00d24ba0-1c1a-420b-a0de-e811e8a8b90c ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /build/buildd/linux-lts-raring-3.8.0/drivers/iommu/dmar.c:481 warn_invalid_dmar+0x8f/0xa0()
[    0.000000] Hardware name:         
[    0.000000] Your BIOS is broken; DMAR reported at address feb00000 returns all ones!
[    0.000000] BIOS vendor: Intel Corp.; Ver: DPP3510J.86A.0293.2007.1002.1519; Product Version:         
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-38-generic #56~precise1-Ubuntu
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81059bef>] warn_slowpath_common+0x7f/0xc0
[    0.000000]  [<ffffffff81059c8f>] warn_slowpath_fmt_taint+0x3f/0x50
[    0.000000]  [<ffffffff81d1de43>] ? __early_set_fixmap+0x96/0x9d
[    0.000000]  [<ffffffff815bbf1f>] warn_invalid_dmar+0x8f/0xa0
[    0.000000]  [<ffffffff81d1e2ac>] ? early_iounmap+0xe4/0x12e
[    0.000000]  [<ffffffff81d46c08>] check_zero_address+0xc8/0xf7
[    0.000000]  [<ffffffff817033b1>] ? bad_to_user+0x7bb/0x7bb
[    0.000000]  [<ffffffff81d46c4e>] detect_intel_iommu+0x17/0xb8
[    0.000000]  [<ffffffff81d0f6c9>] pci_iommu_alloc+0x44/0x6e
[    0.000000]  [<ffffffff81d1dc06>] mem_init+0x19/0xec
[    0.000000]  [<ffffffff816db6fb>] ? set_nmi_gate+0x48/0x4a
[    0.000000]  [<ffffffff81d06a61>] start_kernel+0x1e3/0x3de
[    0.000000]  [<ffffffff81d067ff>] ? pass_bootoption.constprop.3+0xd3/0xd3
[    0.000000]  [<ffffffff81d06397>] x86_64_start_reservations+0x131/0x135
[    0.000000]  [<ffffffff81d06120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d06468>] x86_64_start_kernel+0xcd/0xdc
[    0.000000] ---[ end trace eed57aae45f200ef ]---
[    0.000000] Memory: 2012692k/2079744k available (7180k kernel code, 1280k absent, 65772k reserved, 6063k data, 1016k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 8388608 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2332.895 MHz processor
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4665.79 BogoMIPS (lpj=9331580)
[    0.004112] pid_max: default: 32768 minimum: 301
[    0.004192] Security Framework initialized
[    0.004260] AppArmor: AppArmor initialized
[    0.004311] Yama: becoming mindful.
[    0.008049] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009069] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.009599] Mount-cache hash table entries: 256
[    0.009872] Initializing cgroup subsys cpuacct
[    0.009927] Initializing cgroup subsys memory
[    0.009987] Initializing cgroup subsys devices
[    0.010040] Initializing cgroup subsys freezer
[    0.010093] Initializing cgroup subsys blkio
[    0.010145] Initializing cgroup subsys perf_event
[    0.010200] Initializing cgroup subsys hugetlb
[    0.010280] CPU: Physical Processor ID: 0
[    0.010331] CPU: Processor Core ID: 0
[    0.010383] mce: CPU supports 6 MCE banks
[    0.010442] CPU0: Thermal monitoring enabled (TM2)
[    0.010498] process: using mwait in idle threads
[    0.010554] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.010554] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.010554] tlb_flushall_shift: -1
[    0.010760] Freeing SMP alternatives: 24k freed
[    0.013429] ACPI: Core revision 20121018
[    0.019044] ftrace: allocating 29410 entries in 115 pages
[    0.028112] dmar: Host address width 36
[    0.028168] dmar: DRHD base: 0x000000feb00000 flags: 0x0
[    0.028230] dmar: IOMMU: failed to map dmar0
[    0.028282] dmar: parse DMAR table failure.
[    0.028682] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.070135] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz (fam: 06, model: 0f, stepping: 0b)
[    0.072000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.072000] perf_event_intel: PEBS disabled due to CPU errata
[    0.072000] ... version:                2
[    0.072000] ... bit width:              40
[    0.072000] ... generic registers:      2
[    0.072000] ... value mask:             000000ffffffffff
[    0.072000] ... max period:             000000007fffffff
[    0.072000] ... fixed-purpose events:   3
[    0.072000] ... event mask:             0000000700000003
[    0.072000] smpboot: Booting Node   0, Processors  #1
[    0.082915] Brought up 2 CPUs
[    0.083016] smpboot: Total of 2 processors activated (9331.58 BogoMIPS)
[    0.083168] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.084100] devtmpfs: initialized
[    0.085025] EVM: security.selinux
[    0.085076] EVM: security.SMACK64
[    0.085127] EVM: security.capability
[    0.085189] PM: Registering ACPI NVS region [mem 0x7ee2e000-0x7eee4fff] (749568 bytes)
[    0.085189] regulator-dummy: no parameters
[    0.085274] NET: Registered protocol family 16
[    0.085464] ACPI: bus type pci registered
[    0.088057] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.088132] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.102851] PCI: Using configuration type 1 for base access
[    0.103798] bio: create slab <bio-0> at 0
[    0.103798] ACPI: Added _OSI(Module Device)
[    0.103798] ACPI: Added _OSI(Processor Device)
[    0.103798] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.103798] ACPI: Added _OSI(Processor Aggregator Device)
[    0.103798] ACPI: EC: Look up EC in DSDT
[    0.103798] ACPI: Interpreter enabled
[    0.103798] ACPI: (supports S0 S1 S3 S4 S5)
[    0.104186] ACPI: Using IOAPIC for interrupt routing
[    0.107398] ACPI: No dock devices found.
[    0.107452] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.108119] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.108176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.109368] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.109371] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.109374] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.109376] pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000effff] (ignored)
[    0.109379] pci_root PNP0A03:00: host bridge window [mem 0xf8000000-0xfeafffff] (ignored)
[    0.109381] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xefffffff] (ignored)
[    0.109383] PCI: root bus 00: using default resources
[    0.109386] pci_root PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-7f] only partially covers this bridge
[    0.109487] PCI host bridge to bus 0000:00
[    0.109540] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.109595] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.109651] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    0.109716] pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
[    0.109756] pci 0000:00:01.0: [8086:29c1] type 01 class 0x060400
[    0.109793] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.109810] pci 0000:00:03.0: [8086:29c4] type 00 class 0x078000
[    0.109824] pci 0000:00:03.0: reg 10: [mem 0x93326100-0x9332610f 64bit]
[    0.109865] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.109906] pci 0000:00:19.0: [8086:294c] type 00 class 0x020000
[    0.109923] pci 0000:00:19.0: reg 10: [mem 0x93300000-0x9331ffff]
[    0.109931] pci 0000:00:19.0: reg 14: [mem 0x93324000-0x93324fff]
[    0.109939] pci 0000:00:19.0: reg 18: [io  0x4400-0x441f]
[    0.109996] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.110015] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.110054] pci 0000:00:1a.0: reg 20: [io  0x40e0-0x40ff]
[    0.110101] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.110140] pci 0000:00:1a.1: reg 20: [io  0x40c0-0x40df]
[    0.110187] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.110226] pci 0000:00:1a.2: reg 20: [io  0x40a0-0x40bf]
[    0.110283] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.110303] pci 0000:00:1a.7: reg 10: [mem 0x93325c00-0x93325fff]
[    0.110386] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.110410] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.110424] pci 0000:00:1b.0: reg 10: [mem 0x93320000-0x93323fff 64bit]
[    0.110485] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.110505] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.110567] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.110589] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
[    0.110651] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.110672] pci 0000:00:1c.2: [8086:2944] type 01 class 0x060400
[    0.110734] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.110755] pci 0000:00:1c.3: [8086:2946] type 01 class 0x060400
[    0.110817] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.110839] pci 0000:00:1c.4: [8086:2948] type 01 class 0x060400
[    0.110901] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.110925] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.110963] pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
[    0.111012] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.111051] pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
[    0.111099] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.111137] pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
[    0.111193] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.111213] pci 0000:00:1d.7: reg 10: [mem 0x93325800-0x93325bff]
[    0.111295] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.111316] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.111373] pci 0000:00:1f.0: [8086:2912] type 00 class 0x060100
[    0.111448] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.111521] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    0.111636] pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601
[    0.111653] pci 0000:00:1f.2: reg 10: [io  0x4428-0x442f]
[    0.111661] pci 0000:00:1f.2: reg 14: [io  0x4434-0x4437]
[    0.111668] pci 0000:00:1f.2: reg 18: [io  0x4420-0x4427]
[    0.111676] pci 0000:00:1f.2: reg 1c: [io  0x4430-0x4433]
[    0.111683] pci 0000:00:1f.2: reg 20: [io  0x4020-0x403f]
[    0.111691] pci 0000:00:1f.2: reg 24: [mem 0x93325000-0x933257ff]
[    0.111733] pci 0000:00:1f.2: PME# supported from D3hot
[    0.111750] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
[    0.111764] pci 0000:00:1f.3: reg 10: [mem 0x93326000-0x933260ff 64bit]
[    0.111783] pci 0000:00:1f.3: reg 20: [io  0x4000-0x401f]
[    0.111840] pci 0000:01:00.0: [10de:0f00] type 00 class 0x030000
[    0.111850] pci 0000:01:00.0: reg 10: [mem 0x92000000-0x92ffffff]
[    0.111860] pci 0000:01:00.0: reg 14: [mem 0x80000000-0x8fffffff 64bit pref]
[    0.111870] pci 0000:01:00.0: reg 1c: [mem 0x90000000-0x91ffffff 64bit pref]
[    0.111878] pci 0000:01:00.0: reg 24: [io  0x3000-0x307f]
[    0.111885] pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
[    0.111939] pci 0000:01:00.1: [10de:0bea] type 00 class 0x040300
[    0.111949] pci 0000:01:00.1: reg 10: [mem 0x93000000-0x93003fff]
[    0.112047] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.112102] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.112105] pci 0000:00:01.0:   bridge window [mem 0x92000000-0x930fffff]
[    0.112110] pci 0000:00:01.0:   bridge window [mem 0x80000000-0x91ffffff 64bit pref]
[    0.112145] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.112202] pci 0000:00:1c.0:   bridge window [mem 0x93400000-0x934fffff]
[    0.112258] pci 0000:03:00.0: [11ab:6101] type 00 class 0x01018f
[    0.112273] pci 0000:03:00.0: reg 10: [io  0x2018-0x201f]
[    0.112285] pci 0000:03:00.0: reg 14: [io  0x2024-0x2027]
[    0.112297] pci 0000:03:00.0: reg 18: [io  0x2010-0x2017]
[    0.112308] pci 0000:03:00.0: reg 1c: [io  0x2020-0x2023]
[    0.112320] pci 0000:03:00.0: reg 20: [io  0x2000-0x200f]
[    0.112332] pci 0000:03:00.0: reg 24: [mem 0x93200000-0x932001ff]
[    0.112394] pci 0000:03:00.0: supports D1
[    0.112396] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.112416] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.112497] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.112552] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.112556] pci 0000:00:1c.1:   bridge window [mem 0x93200000-0x932fffff]
[    0.112595] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.112652] pci 0000:00:1c.2:   bridge window [mem 0x93500000-0x935fffff]
[    0.112691] pci 0000:00:1c.3: PCI bridge to [bus 05]
[    0.112748] pci 0000:00:1c.3:   bridge window [mem 0x93600000-0x936fffff]
[    0.112786] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.112843] pci 0000:00:1c.4:   bridge window [mem 0x93700000-0x937fffff]
[    0.112875] pci 0000:07:00.0: [1106:3038] type 00 class 0x0c0300
[    0.112919] pci 0000:07:00.0: reg 20: [io  0x1040-0x105f]
[    0.112960] pci 0000:07:00.0: supports D1 D2
[    0.112962] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot
[    0.112981] pci 0000:07:00.2: [1106:3104] type 00 class 0x0c0320
[    0.112997] pci 0000:07:00.2: reg 10: [mem 0x93104900-0x931049ff]
[    0.113066] pci 0000:07:00.2: supports D1 D2
[    0.113068] pci 0000:07:00.2: PME# supported from D0 D1 D2 D3hot
[    0.113091] pci 0000:07:01.0: [1106:3038] type 00 class 0x0c0300
[    0.113135] pci 0000:07:01.0: reg 20: [io  0x1020-0x103f]
[    0.113175] pci 0000:07:01.0: supports D1 D2
[    0.113178] pci 0000:07:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113195] pci 0000:07:01.1: [1106:3038] type 00 class 0x0c0300
[    0.113239] pci 0000:07:01.1: reg 20: [io  0x1000-0x101f]
[    0.113279] pci 0000:07:01.1: supports D1 D2
[    0.113282] pci 0000:07:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113299] pci 0000:07:01.2: [1106:3104] type 00 class 0x0c0320
[    0.113315] pci 0000:07:01.2: reg 10: [mem 0x93104800-0x931048ff]
[    0.113383] pci 0000:07:01.2: supports D1 D2
[    0.113386] pci 0000:07:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113410] pci 0000:07:03.0: [104c:8023] type 00 class 0x0c0010
[    0.113427] pci 0000:07:03.0: reg 10: [mem 0x93104000-0x931047ff]
[    0.113437] pci 0000:07:03.0: reg 14: [mem 0x93100000-0x93103fff]
[    0.113502] pci 0000:07:03.0: supports D1 D2
[    0.113504] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.113545] pci 0000:00:1e.0: PCI bridge to [bus 07] (subtractive decode)
[    0.113604] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.113608] pci 0000:00:1e.0:   bridge window [mem 0x93100000-0x931fffff]
[    0.113613] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.113616] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
[    0.113646] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.113745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.113780] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.113813] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.113847] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.113883] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.113950]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.114022]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.115348] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.115763] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *9 10 11 12)
[    0.116185] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.116596] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.117006] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)
[    0.117420] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 *9 10 11 12)
[    0.117830] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
[    0.118241] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.120017] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.120090] vgaarb: loaded
[    0.120140] vgaarb: bridge control possible 0000:01:00.0
[    0.120393] SCSI subsystem initialized
[    0.120445] ACPI: bus type scsi registered
[    0.120505] libata version 3.00 loaded.
[    0.120505] ACPI: bus type usb registered
[    0.120505] usbcore: registered new interface driver usbfs
[    0.120505] usbcore: registered new interface driver hub
[    0.120505] usbcore: registered new device driver usb
[    0.120505] PCI: Using ACPI for IRQ routing
[    0.122208] PCI: pci_cache_line_size set to 64 bytes
[    0.122290] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.122295] e820: reserve RAM buffer [mem 0x7ed13000-0x7fffffff]
[    0.122297] e820: reserve RAM buffer [mem 0x7ee2e000-0x7fffffff]
[    0.122299] e820: reserve RAM buffer [mem 0x7eee9000-0x7fffffff]
[    0.122301] e820: reserve RAM buffer [mem 0x7eef4000-0x7fffffff]
[    0.122303] e820: reserve RAM buffer [mem 0x7ef00000-0x7fffffff]
[    0.122390] NetLabel: Initializing
[    0.122440] NetLabel:  domain hash size = 128
[    0.122492] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.122555] NetLabel:  unlabeled traffic allowed by default
[    0.124033] Switching to clocksource refined-jiffies
[    0.129247] AppArmor: AppArmor Filesystem Enabled
[    0.129331] pnp: PnP ACPI init
[    0.129395] ACPI: bus type pnp registered
[    0.129535] system 00:00: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.129593] system 00:00: [mem 0xfeb00000-0xfeb03fff] has been reserved
[    0.129650] system 00:00: [mem 0xfed13000-0xfed13fff] has been reserved
[    0.129707] system 00:00: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.129764] system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.129821] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.129878] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.129935] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.129992] system 00:00: [mem 0xfed45000-0xfed99fff] has been reserved
[    0.130049] system 00:00: [mem 0x000c0000-0x000dffff] could not be reserved
[    0.130107] system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.130164] system 00:00: [mem 0xffc00000-0xffffffff] could not be reserved
[    0.130223] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.130350] pnp 00:01: [dma 4]
[    0.130371] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.130406] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.130437] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.130463] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.130511] system 00:05: [io  0x0500-0x053f] has been reserved
[    0.130567] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.130623] system 00:05: [io  0x0680-0x06ff] has been reserved
[    0.130680] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.130755] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.131091] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.131142] pnp 00:08: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.131188] pnp: PnP ACPI: found 9 devices
[    0.131240] ACPI: ACPI bus type pnp unregistered
[    0.137231] Switching to clocksource acpi_pm
[    0.140001] pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
[    0.140001] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.140001] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.140001] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.140001] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.140001] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    0.140001] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 05] add_size 1000
[    0.140001] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 05] add_size 200000
[    0.140001] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 06] add_size 1000
[    0.140001] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06] add_size 200000
[    0.140001] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.140001] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.140001] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.140001] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.140001] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.140001] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.140001] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.140001] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.140001] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.140001] pci 0000:00:1c.0: BAR 15: assigned [mem 0x93800000-0x939fffff 64bit pref]
[    0.140001] pci 0000:00:1c.1: BAR 15: assigned [mem 0x93a00000-0x93bfffff 64bit pref]
[    0.140001] pci 0000:00:1c.2: BAR 15: assigned [mem 0x93c00000-0x93dfffff 64bit pref]
[    0.140001] pci 0000:00:1c.3: BAR 15: assigned [mem 0x93e00000-0x93ffffff 64bit pref]
[    0.140001] pci 0000:00:1c.4: BAR 15: assigned [mem 0x94000000-0x941fffff 64bit pref]
[    0.140001] pci 0000:00:1c.0: BAR 13: assigned [io  0x5000-0x5fff]
[    0.140001] pci 0000:00:1c.2: BAR 13: assigned [io  0x6000-0x6fff]
[    0.140001] pci 0000:00:1c.3: BAR 13: assigned [io  0x7000-0x7fff]
[    0.140001] pci 0000:00:1c.4: BAR 13: assigned [io  0x8000-0x8fff]
[    0.140001] pci 0000:01:00.0: BAR 6: assigned [mem 0x93080000-0x930fffff pref]
[    0.140001] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.140001] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.140001] pci 0000:00:01.0:   bridge window [mem 0x92000000-0x930fffff]
[    0.140001] pci 0000:00:01.0:   bridge window [mem 0x80000000-0x91ffffff 64bit pref]
[    0.140001] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.140001] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.140001] pci 0000:00:1c.0:   bridge window [mem 0x93400000-0x934fffff]
[    0.140001] pci 0000:00:1c.0:   bridge window [mem 0x93800000-0x939fffff 64bit pref]
[    0.140001] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.140001] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.140001] pci 0000:00:1c.1:   bridge window [mem 0x93200000-0x932fffff]
[    0.140001] pci 0000:00:1c.1:   bridge window [mem 0x93a00000-0x93bfffff 64bit pref]
[    0.140001] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.140001] pci 0000:00:1c.2:   bridge window [io  0x6000-0x6fff]
[    0.140001] pci 0000:00:1c.2:   bridge window [mem 0x93500000-0x935fffff]
[    0.140001] pci 0000:00:1c.2:   bridge window [mem 0x93c00000-0x93dfffff 64bit pref]
[    0.140001] pci 0000:00:1c.3: PCI bridge to [bus 05]
[    0.140001] pci 0000:00:1c.3:   bridge window [io  0x7000-0x7fff]
[    0.140001] pci 0000:00:1c.3:   bridge window [mem 0x93600000-0x936fffff]
[    0.140001] pci 0000:00:1c.3:   bridge window [mem 0x93e00000-0x93ffffff 64bit pref]
[    0.140001] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.140001] pci 0000:00:1c.4:   bridge window [io  0x8000-0x8fff]
[    0.140001] pci 0000:00:1c.4:   bridge window [mem 0x93700000-0x937fffff]
[    0.140001] pci 0000:00:1c.4:   bridge window [mem 0x94000000-0x941fffff 64bit pref]
[    0.140001] pci 0000:00:1e.0: PCI bridge to [bus 07]
[    0.140001] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.140001] pci 0000:00:1e.0:   bridge window [mem 0x93100000-0x931fffff]
[    0.140001] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.140001] pci 0000:00:1c.2: enabling device (0000 -> 0003)
[    0.140001] pci 0000:00:1c.3: enabling device (0000 -> 0003)
[    0.142722] pci 0000:00:1c.4: enabling device (0000 -> 0003)
[    0.142784] pci 0000:00:1e.0: setting latency timer to 64
[    0.142788] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.142790] pci_bus 0000:00: resource 5 [mem 0x00000000-0xfffffffff]
[    0.142793] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.142795] pci_bus 0000:01: resource 1 [mem 0x92000000-0x930fffff]
[    0.142798] pci_bus 0000:01: resource 2 [mem 0x80000000-0x91ffffff 64bit pref]
[    0.142800] pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
[    0.142802] pci_bus 0000:02: resource 1 [mem 0x93400000-0x934fffff]
[    0.142805] pci_bus 0000:02: resource 2 [mem 0x93800000-0x939fffff 64bit pref]
[    0.142807] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.142809] pci_bus 0000:03: resource 1 [mem 0x93200000-0x932fffff]
[    0.142812] pci_bus 0000:03: resource 2 [mem 0x93a00000-0x93bfffff 64bit pref]
[    0.142814] pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
[    0.142816] pci_bus 0000:04: resource 1 [mem 0x93500000-0x935fffff]
[    0.142819] pci_bus 0000:04: resource 2 [mem 0x93c00000-0x93dfffff 64bit pref]
[    0.142821] pci_bus 0000:05: resource 0 [io  0x7000-0x7fff]
[    0.142823] pci_bus 0000:05: resource 1 [mem 0x93600000-0x936fffff]
[    0.142826] pci_bus 0000:05: resource 2 [mem 0x93e00000-0x93ffffff 64bit pref]
[    0.142828] pci_bus 0000:06: resource 0 [io  0x8000-0x8fff]
[    0.142830] pci_bus 0000:06: resource 1 [mem 0x93700000-0x937fffff]
[    0.142833] pci_bus 0000:06: resource 2 [mem 0x94000000-0x941fffff 64bit pref]
[    0.142835] pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
[    0.142837] pci_bus 0000:07: resource 1 [mem 0x93100000-0x931fffff]
[    0.142840] pci_bus 0000:07: resource 4 [io  0x0000-0xffff]
[    0.142842] pci_bus 0000:07: resource 5 [mem 0x00000000-0xfffffffff]
[    0.142877] NET: Registered protocol family 2
[    0.143084] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.143269] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.143420] TCP: Hash tables configured (established 16384 bind 16384)
[    0.143513] TCP: reno registered
[    0.143568] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.143640] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.143752] NET: Registered protocol family 1
[    0.144217] pci 0000:01:00.0: Boot video device
[    0.144323] PCI: CLS 64 bytes, default 64
[    0.144366] Trying to unpack rootfs image as initramfs...
[    0.443923] Freeing initrd memory: 16712k freed
[    0.450346] Initialise module verification
[    0.450452] audit: initializing netlink socket (disabled)
[    0.450519] type=2000 audit(1404393012.447:1): initialized
[    0.480880] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.482565] VFS: Disk quotas dquot_6.5.2
[    0.483767] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.484367] fuse init (API version 7.20)
[    0.484499] msgmni has been set to 3963
[    0.484985] Key type asymmetric registered
[    0.485039] Asymmetric key parser 'x509' registered
[    0.485124] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.485225] io scheduler noop registered
[    0.485279] io scheduler deadline registered (default)
[    0.485336] io scheduler cfq registered
[    0.485528] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.485599] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.485681] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.485760] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    0.485839] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
[    0.485916] pcieport 0000:00:1c.4: irq 45 for MSI/MSI-X
[    0.485985] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.486053] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.486157] intel_idle: does not run on family 6 model 15
[    0.486233] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.486309] ACPI: Sleep Button [SLPB]
[    0.486407] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.486478] ACPI: Power Button [PWRF]
[    0.486608] ACPI: Requesting acpi_cpufreq
[    0.486869] Monitor-Mwait will be used to enter C-1 state
[    0.488984] GHES: HEST is not enabled!
[    0.489117] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.509526] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.510880] Linux agpgart interface v0.103
[    0.512307] brd: module loaded
[    0.513049] loop: module loaded
[    0.513460] libphy: Fixed MDIO Bus: probed
[    0.513579] tun: Universal TUN/TAP device driver, 1.6
[    0.513633] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.513727] PPP generic driver version 2.4.2
[    0.513833] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.513889] ehci-pci: EHCI PCI platform driver
[    0.513974] ehci-pci 0000:00:1a.7: setting latency timer to 64
[    0.513978] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    0.514038] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.514119] ehci-pci 0000:00:1a.7: debug port 1
[    0.518064] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    0.518081] ehci-pci 0000:00:1a.7: irq 17, io mem 0x93325c00
[    0.528026] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.528104] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.528162] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.528234] usb usb1: Product: EHCI Host Controller
[    0.528293] usb usb1: Manufacturer: Linux 3.8.0-38-generic ehci_hcd
[    0.528349] usb usb1: SerialNumber: 0000:00:1a.7
[    0.528492] hub 1-0:1.0: USB hub found
[    0.528547] hub 1-0:1.0: 6 ports detected
[    0.528714] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    0.528718] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    0.528775] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.528855] ehci-pci 0000:00:1d.7: debug port 1
[    0.532807] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    0.532820] ehci-pci 0000:00:1d.7: irq 23, io mem 0x93325800
[    0.544030] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.544117] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.544176] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.544253] usb usb2: Product: EHCI Host Controller
[    0.544306] usb usb2: Manufacturer: Linux 3.8.0-38-generic ehci_hcd
[    0.544362] usb usb2: SerialNumber: 0000:00:1d.7
[    0.544497] hub 2-0:1.0: USB hub found
[    0.544551] hub 2-0:1.0: 6 ports detected
[    0.544714] ehci-pci 0000:07:00.2: EHCI Host Controller
[    0.544772] ehci-pci 0000:07:00.2: new USB bus registered, assigned bus number 3
[    0.544869] ehci-pci 0000:07:00.2: irq 23, io mem 0x93104900
[    0.556031] ehci-pci 0000:07:00.2: USB 2.0 started, EHCI 1.00
[    0.556105] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.556163] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.556240] usb usb3: Product: EHCI Host Controller
[    0.556294] usb usb3: Manufacturer: Linux 3.8.0-38-generic ehci_hcd
[    0.556350] usb usb3: SerialNumber: 0000:07:00.2
[    0.556485] hub 3-0:1.0: USB hub found
[    0.556539] hub 3-0:1.0: 2 ports detected
[    0.556663] ehci-pci 0000:07:01.2: EHCI Host Controller
[    0.556721] ehci-pci 0000:07:01.2: new USB bus registered, assigned bus number 4
[    0.556824] ehci-pci 0000:07:01.2: irq 20, io mem 0x93104800
[    0.568031] ehci-pci 0000:07:01.2: USB 2.0 started, EHCI 1.00
[    0.568113] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    0.568172] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.568249] usb usb4: Product: EHCI Host Controller
[    0.568302] usb usb4: Manufacturer: Linux 3.8.0-38-generic ehci_hcd
[    0.568358] usb usb4: SerialNumber: 0000:07:01.2
[    0.568493] hub 4-0:1.0: USB hub found
[    0.568547] hub 4-0:1.0: 4 ports detected
[    0.568678] ehci-platform: EHCI generic platform driver
[    0.568739] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.568809] uhci_hcd: USB Universal Host Controller Interface driver
[    0.568881] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.568884] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.568942] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 5
[    0.569039] uhci_hcd 0000:00:1a.0: irq 18, io base 0x000040e0
[    0.569120] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.569178] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.569248] usb usb5: Product: UHCI Host Controller
[    0.569302] usb usb5: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.569358] usb usb5: SerialNumber: 0000:00:1a.0
[    0.569493] hub 5-0:1.0: USB hub found
[    0.569547] hub 5-0:1.0: 2 ports detected
[    0.569668] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.569671] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.569728] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 6
[    0.569825] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000040c0
[    0.569908] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.569965] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.570036] usb usb6: Product: UHCI Host Controller
[    0.570089] usb usb6: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.570145] usb usb6: SerialNumber: 0000:00:1a.1
[    0.570276] hub 6-0:1.0: USB hub found
[    0.570330] hub 6-0:1.0: 2 ports detected
[    0.570454] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.570458] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.570515] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 7
[    0.570604] uhci_hcd 0000:00:1a.2: irq 17, io base 0x000040a0
[    0.570687] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.570745] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.570815] usb usb7: Product: UHCI Host Controller
[    0.570869] usb usb7: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.570925] usb usb7: SerialNumber: 0000:00:1a.2
[    0.571062] hub 7-0:1.0: USB hub found
[    0.571116] hub 7-0:1.0: 2 ports detected
[    0.571235] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.571238] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.571295] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 8
[    0.571384] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    0.571466] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.571524] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.571594] usb usb8: Product: UHCI Host Controller
[    0.571648] usb usb8: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.571704] usb usb8: SerialNumber: 0000:00:1d.0
[    0.571832] hub 8-0:1.0: USB hub found
[    0.571886] hub 8-0:1.0: 2 ports detected
[    0.572017] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.572020] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.572088] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 9
[    0.572185] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    0.572266] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
[    0.572323] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.572394] usb usb9: Product: UHCI Host Controller
[    0.572447] usb usb9: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.572503] usb usb9: SerialNumber: 0000:00:1d.1
[    0.572637] hub 9-0:1.0: USB hub found
[    0.572691] hub 9-0:1.0: 2 ports detected
[    0.572813] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.572816] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.572873] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 10
[    0.572962] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    0.573043] usb usb10: New USB device found, idVendor=1d6b, idProduct=0001
[    0.573101] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.573171] usb usb10: Product: UHCI Host Controller
[    0.573225] usb usb10: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.573281] usb usb10: SerialNumber: 0000:00:1d.2
[    0.573412] hub 10-0:1.0: USB hub found
[    0.573466] hub 10-0:1.0: 2 ports detected
[    0.573587] uhci_hcd 0000:07:00.0: UHCI Host Controller
[    0.573644] uhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 11
[    0.573735] uhci_hcd 0000:07:00.0: irq 21, io base 0x00001040
[    0.573817] usb usb11: New USB device found, idVendor=1d6b, idProduct=0001
[    0.573874] usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.573945] usb usb11: Product: UHCI Host Controller
[    0.573999] usb usb11: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.574055] usb usb11: SerialNumber: 0000:07:00.0
[    0.574185] hub 11-0:1.0: USB hub found
[    0.574239] hub 11-0:1.0: 2 ports detected
[    0.574361] uhci_hcd 0000:07:01.0: UHCI Host Controller
[    0.574420] uhci_hcd 0000:07:01.0: new USB bus registered, assigned bus number 12
[    0.574519] uhci_hcd 0000:07:01.0: irq 22, io base 0x00001020
[    0.574601] usb usb12: New USB device found, idVendor=1d6b, idProduct=0001
[    0.574658] usb usb12: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.574729] usb usb12: Product: UHCI Host Controller
[    0.575893] usb usb12: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.575949] usb usb12: SerialNumber: 0000:07:01.0
[    0.576093] hub 12-0:1.0: USB hub found
[    0.576147] hub 12-0:1.0: 2 ports detected
[    0.576266] uhci_hcd 0000:07:01.1: UHCI Host Controller
[    0.576324] uhci_hcd 0000:07:01.1: new USB bus registered, assigned bus number 13
[    0.576413] uhci_hcd 0000:07:01.1: irq 21, io base 0x00001000
[    0.576495] usb usb13: New USB device found, idVendor=1d6b, idProduct=0001
[    0.576553] usb usb13: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.576623] usb usb13: Product: UHCI Host Controller
[    0.576677] usb usb13: Manufacturer: Linux 3.8.0-38-generic uhci_hcd
[    0.576733] usb usb13: SerialNumber: 0000:07:01.1
[    0.576868] hub 13-0:1.0: USB hub found
[    0.576922] hub 13-0:1.0: 2 ports detected
[    0.577093] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.580293] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.580353] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.580514] mousedev: PS/2 mouse device common for all mice
[    0.580688] rtc_cmos 00:02: RTC can wake from S4
[    0.580844] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.580918] rtc0: alarms up to one month, 114 bytes nvram
[    0.581060] device-mapper: uevent: version 1.0.3
[    0.581171] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    0.581249] cpuidle: using governor ladder
[    0.581301] cpuidle: using governor menu
[    0.581354] ledtrig-cpu: registered to indicate activity on CPUs
[    0.581409] EFI Variables Facility v0.08 2004-May-17
[    0.581649] ashmem: initialized
[    0.581811] TCP: cubic registered
[    0.581963] NET: Registered protocol family 10
[    0.582186] NET: Registered protocol family 17
[    0.582249] Key type dns_resolver registered
[    0.582492] Loading module verification certificates
[    0.583614] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: a3011e4e8f874734b1f26672fda04dadcdf86f9b'
[    0.583700] registered taskstats version 1
[    0.585890] Key type trusted registered
[    0.587739] Key type encrypted registered
[    0.590005] rtc_cmos 00:02: setting system clock to 2014-07-03 13:10:12 UTC (1404393012)
[    0.590296] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.590352] EDD information not available.
[    0.592187] Freeing unused kernel memory: 1016k freed
[    0.592488] Write protecting the kernel read-only data: 12288k
[    0.595758] Freeing unused kernel memory: 1000k freed
[    0.599067] Freeing unused kernel memory: 952k freed
[    0.614187] udevd[95]: starting version 175
[    0.665256] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    0.665317] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    0.665410] e1000e 0000:00:19.0: setting latency timer to 64
[    0.665484] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.665591] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    0.674630] scsi0 : pata_marvell
[    0.679201] scsi1 : pata_marvell
[    0.679308] ata1: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 17
[    0.679366] ata2: DUMMY
[    0.764071] firewire_ohci 0000:07:03.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[    0.900049] usb 1-2: new high-speed USB device number 3 using ehci-pci
[    0.969975] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:22:1d:46
[    0.970049] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.970126] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 6, PBA No: FFFFFF-0FF
[    0.970207] ahci 0000:00:1f.2: version 3.0
[    0.970266] ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
[    0.970344] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.970421] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part ccc ems 
[    0.970505] ahci 0000:00:1f.2: setting latency timer to 64
[    1.008545] scsi2 : ahci
[    1.008674] scsi3 : ahci
[    1.008790] scsi4 : ahci
[    1.008906] scsi5 : ahci
[    1.009021] scsi6 : ahci
[    1.009131] scsi7 : ahci
[    1.009250] ata3: SATA max UDMA/133 abar m2048@0x93325000 port 0x93325100 irq 47
[    1.009321] ata4: SATA max UDMA/133 abar m2048@0x93325000 port 0x93325180 irq 47
[    1.009392] ata5: SATA max UDMA/133 abar m2048@0x93325000 port 0x93325200 irq 47
[    1.009463] ata6: SATA max UDMA/133 abar m2048@0x93325000 port 0x93325280 irq 47
[    1.009533] ata7: SATA max UDMA/133 abar m2048@0x93325000 port 0x93325300 irq 47
[    1.009604] ata8: SATA max UDMA/133 abar m2048@0x93325000 port 0x93325380 irq 47
[    1.032438] usb 1-2: New USB device found, idVendor=0424, idProduct=2514
[    1.032497] usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.032710] hub 1-2:1.0: USB hub found
[    1.032807] hub 1-2:1.0: 4 ports detected
[    1.264102] firewire_core 0000:07:03.0: created device fw0: GUID 0090270001fd63fb, S400
[    1.328056] ata5: SATA link down (SStatus 0 SControl 300)
[    1.328125] ata6: SATA link down (SStatus 0 SControl 300)
[    1.448056] tsc: Refined TSC clocksource calibration: 2333.067 MHz
[    1.448116] Switching to clocksource tsc
[    1.500023] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.500091] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.500156] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.500660] ata7.00: ATA-9: WDC WD30EURS-73TLHY0, 80.00A80, max UDMA/133
[    1.500720] ata7.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.500837] ata3.00: ATA-9: WDC WD30EURS-73TLHY0, 80.00A80, max UDMA/133
[    1.500895] ata3.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.501319] ata7.00: configured for UDMA/133
[    1.501486] ata3.00: configured for UDMA/133
[    1.501646] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EURS-73T 80.0 PQ: 0 ANSI: 5
[    1.501856] sd 2:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    1.501881] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.501990] sd 2:0:0:0: [sda] 4096-byte physical blocks
[    1.502086] sd 2:0:0:0: [sda] Write Protect is off
[    1.502140] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.502159] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.511315] ata8.00: ATA-8: OCZ-AGILITY3, 2.15, max UDMA/133
[    1.511373] ata8.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.512036] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    1.521701] ata8.00: configured for UDMA/133
[    1.586356]  sda: sda1
[    1.586615] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.654195] usb 3-1: New USB device found, idVendor=0413, idProduct=6f12
[    1.654255] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.654315] usb 3-1: Product: WinFast DTV2000 DS Plus
[    1.654371] usb 3-1: Manufacturer: Realtek
[    1.668028] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.669485] ata4.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.13, max UDMA/66
[    1.671002] ata4.00: configured for UDMA/66 (SET_XFERMODE skipped)
[    1.695129] scsi 3:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.13 PQ: 0 ANSI: 5
[    1.713124] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.713197] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.713361] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.713420] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    1.713609] scsi 6:0:0:0: Direct-Access     ATA      WDC WD30EURS-73T 80.0 PQ: 0 ANSI: 5
[    1.713786] sd 6:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    1.713860] sd 6:0:0:0: [sdb] 4096-byte physical blocks
[    1.713940] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    1.713966] sd 6:0:0:0: [sdb] Write Protect is off
[    1.713968] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.713988] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.714218] scsi 7:0:0:0: Direct-Access     ATA      OCZ-AGILITY3     2.15 PQ: 0 ANSI: 5
[    1.714405] sd 7:0:0:0: Attached scsi generic sg3 type 0
[    1.714495] sd 7:0:0:0: [sdc] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    1.714644] sd 7:0:0:0: [sdc] Write Protect is off
[    1.714700] sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.714724] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.716464]  sdc: sdc1 sdc2
[    1.716788] sd 7:0:0:0: [sdc] Attached SCSI disk
[    1.768030] usb 3-2: new high-speed USB device number 3 using ehci-pci
[    1.796618]  sdb: sdb1
[    1.796900] sd 6:0:0:0: [sdb] Attached SCSI disk
[    1.956154] bio: create slab <bio-1> at 1
[    1.990243] usb 3-2: New USB device found, idVendor=0413, idProduct=6f12
[    1.990306] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.990367] usb 3-2: Product: WinFast DTV2000 DS Plus
[    1.990434] usb 3-2: Manufacturer: Realtek
[    2.104084] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    2.237868] usb 4-1: New USB device found, idVendor=0fe9, idProduct=db78
[    2.237933] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=4
[    2.238007] usb 4-1: Product: Bluebird
[    2.238061] usb 4-1: Manufacturer: Dvico
[    2.238115] usb 4-1: SerialNumber: 0000827b
[    2.348033] usb 4-2: new high-speed USB device number 3 using ehci-pci
[    2.522028] usb 4-2: New USB device found, idVendor=0fe9, idProduct=db78
[    2.522090] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=4
[    2.522152] usb 4-2: Product: Bluebird
[    2.522206] usb 4-2: Manufacturer: Dvico
[    2.522266] usb 4-2: SerialNumber: 0000027b
[    2.760025] usb 5-1: new low-speed USB device number 2 using uhci_hcd
[    2.936126] usb 5-1: New USB device found, idVendor=413c, idProduct=2107
[    2.937303] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.937361] usb 5-1: Product: Dell USB Entry Keyboard
[    2.937417] usb 5-1: Manufacturer: Dell
[    2.961178] usbcore: registered new interface driver usbhid
[    2.961240] usbhid: USB HID core driver
[    2.964344] input: Dell Dell USB Entry Keyboard as /devices/pci0000:00/0000:00:1a.0/usb5/5-1/5-1:1.0/input/input2
[    2.964853] hid-generic 0003:413C:2107.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Entry Keyboard] on usb-0000:00:1a.0-1/input0
[    3.180036] usb 6-2: new low-speed USB device number 2 using uhci_hcd
[    3.361915] usb 6-2: New USB device found, idVendor=045e, idProduct=0040
[    3.361976] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.362035] usb 6-2: Product: Microsoft Wheel Mouse Optical\xffffffc2\xffffffae\xffffffae
[    3.362092] usb 6-2: Manufacturer: Microsoft
[    3.380238] input: Microsoft Microsoft Wheel Mouse Optical\xffffffc2\xffffffae\xffffffae as /devices/pci0000:00/0000:00:1a.1/usb6/6-2/6-2:1.0/input/input3
[    3.380410] hid-generic 0003:045E:0040.0002: input,hidraw1: USB HID v1.00 Mouse [Microsoft Microsoft Wheel Mouse Optical\xffffffc2\xffffffae\xffffffae] on usb-0000:00:1a.1-2/input0
[    3.824028] usb 10-1: new low-speed USB device number 2 using uhci_hcd
[    3.979052] usb 10-1: New USB device found, idVendor=15c2, idProduct=ffdc
[    3.979113] usb 10-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.839872] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
[    6.943823] init: ureadahead main process (347) terminated with status 5
[    7.039423] Adding 3903484k swap on /dev/mapper/welly-swap.  Priority:-1 extents:1 across:3903484k SS
[    7.046386] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.055036] udevd[480]: starting version 175
[    7.091836] lp: driver loaded but no devices found
[    7.143105] mei 0000:00:03.0: setting latency timer to 64
[    7.143150] mei 0000:00:03.0: irq 48 for MSI/MSI-X
[    7.213541] Disabling lock debugging due to kernel taint
[    7.213910] WARNING: You are using an experimental version of the media stack.
[    7.213910] 	As the driver is backported to an older kernel, it doesn't offer
[    7.213910] 	enough quality for its usage in production.
[    7.213910] 	Use it with care.
[    7.213910] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[    7.213910] 	b5b620584b9c4644b85e932895a742e0c192d66c [media] technisat-sub2: Fix stream curruption on high bitrate
[    7.213910] 	1fe3a8fe494463cfe2556a25ae41a1499725c178 [media] au0828: don't hardcode height/width
[    7.213910] 	64ea37bbd8a5815522706f0099ad3f11c7537e15 [media] au0828: Only alt setting logic when needed
[    7.216664] input: iMON Panel, Knob and Mouse(15c2:ffdc) as /devices/pci0000:00/0000:00:1d.2/usb10/10-1/10-1:1.0/input/input4
[    7.240022] imon 10-1:1.0: 0xffdc iMON LCD, MCE IR
[    7.240026]  (id 0x9f)
[    7.264168] nvidia: module license 'NVIDIA' taints kernel.
[    7.283068] Registered IR keymap rc-imon-mce
[    7.283251] input: iMON Remote (15c2:ffdc) as /devices/pci0000:00/0000:00:1d.2/usb10/10-1/10-1:1.0/rc/rc0/input5
[    7.283303] rc0: iMON Remote (15c2:ffdc) as /devices/pci0000:00/0000:00:1d.2/usb10/10-1/10-1:1.0/rc/rc0
[    7.283732] type=1400 audit(1404393019.186:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=583 comm="apparmor_parser"
[    7.284167] type=1400 audit(1404393019.190:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=583 comm="apparmor_parser"
[    7.284398] type=1400 audit(1404393019.190:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=583 comm="apparmor_parser"
[    7.293733] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    7.294067] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  304.116  Mon Oct 28 20:39:03 PDT 2013
[    7.294708] type=1400 audit(1404393019.198:5): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=594 comm="apparmor_parser"
[    7.296981] imon 10-1:1.0: iMON device (15c2:ffdc, intf0) on usb<10:2> initialized
[    7.297028] usbcore: registered new interface driver imon
[    7.312794] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \IGPO 1 (20121018/utaddress-251)
[    7.312802] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.342291] WARNING: You are using an experimental version of the media stack.
[    7.342291] 	As the driver is backported to an older kernel, it doesn't offer
[    7.342291] 	enough quality for its usage in production.
[    7.342291] 	Use it with care.
[    7.342291] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[    7.342291] 	b5b620584b9c4644b85e932895a742e0c192d66c [media] technisat-sub2: Fix stream curruption on high bitrate
[    7.342291] 	1fe3a8fe494463cfe2556a25ae41a1499725c178 [media] au0828: don't hardcode height/width
[    7.342291] 	64ea37bbd8a5815522706f0099ad3f11c7537e15 [media] au0828: Only alt setting logic when needed
[    7.346769] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
[    7.347003] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    7.378165] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
[    7.428051] microcode: CPU0 sig=0x6fb, pf=0x1, revision=0xb3
[    7.430814] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    7.456089] hda_codec: ALC888: SKU not ready 0x411111f0
[    7.486670] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    7.487458] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    7.487961] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    7.488542] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    7.489237] input: HDA Intel Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    7.491758] hda_intel: Disabling MSI
[    7.491770] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    7.593377] usb 4-1: DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[    7.607952] xc2028 0-0061: creating new instance
[    7.607956] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[    7.608725] xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[    7.608796] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:07:01.2/usb4/4-1/input/input11
[    7.609438] dvb-usb: schedule remote query interval to 100 msecs.
[    7.609577] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initialized and connected.
[    7.609601] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
[    7.610117] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    7.639237] gpio_ich: GPIO from 195 to 255 on gpio_ich
[    7.640862] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
[    7.653863] microcode: CPU1 sig=0x6fb, pf=0x1, revision=0xb3
[    7.666506] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.688469] cxusb: No IR receiver detected on this device.
[    7.688477] usb 4-2: DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 DVB-T)...
[    7.688617] xc2028 1-0061: creating new instance
[    7.688620] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[    7.688700] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[    7.692793] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initialized and connected.
[    7.692837] usbcore: registered new interface driver dvb_usb_cxusb
[    7.696187] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    7.701327] coretemp coretemp.0: Using relative temperature scale!
[    7.701356] coretemp coretemp.0: Using relative temperature scale!
[    7.800160] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    7.800256] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.924426] EXT4-fs (sdc1): re-mounted. Opts: errors=remount-ro
[    7.961503] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    7.975619] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    7.986499] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
[    7.995089] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[    8.093133] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[    8.131774] EXT4-fs (dm-7): mounted filesystem with ordered data mode. Opts: (null)
[    8.236994] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[    8.297467] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    8.302241] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
[    8.308146] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
[    8.308360] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
[    8.308511] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
[    8.308657] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[    8.396608] init: udev-fallback-graphics main process (995) terminated with status 1
[    9.044891] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[    9.044898] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[    9.044927] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.964606] init: failsafe main process (1020) killed by TERM signal
[   11.019602] type=1400 audit(1404393022.922:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1333 comm="apparmor_parser"
[   11.020227] type=1400 audit(1404393022.926:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1333 comm="apparmor_parser"
[   11.020457] type=1400 audit(1404393022.926:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1333 comm="apparmor_parser"
[   11.024597] type=1400 audit(1404393022.930:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/libvirt/virt-aa-helper" pid=1335 comm="apparmor_parser"
[   11.025150] type=1400 audit(1404393022.930:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1332 comm="apparmor_parser"
[   11.029241] type=1400 audit(1404393022.934:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/libvirtd" pid=1336 comm="apparmor_parser"
[   11.177388] imon 10-1:1.0: Looks like you're trying to use an IR protocol this device does not support
[   11.177392] imon 10-1:1.0: Unsupported IR protocol specified, overriding to iMON IR protocol
[   11.370636] Bridge firewalling registered
[   11.430063] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.520881] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   11.563754] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   12.227377] Ebtables v2.0 registered
[   12.249522] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.276404] cgroup: libvirtd (1539) created nested cgroup for controller "memory" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   12.276407] cgroup: "memory" requires setting use_hierarchy to 1 on the root.
[   12.276452] cgroup: libvirtd (1539) created nested cgroup for controller "devices" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   12.276507] cgroup: libvirtd (1539) created nested cgroup for controller "blkio" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   13.844421] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   15.374285] init: plymouth-stop pre-start process (2749) terminated with status 1
[   15.604159] xc2028 0-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
[   15.631529] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[   15.824328] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   17.535571] xc2028 1-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
[   17.562332] xc2028 1-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[  260.268408] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[  261.988655] xc2028 0-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
[  262.015032] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
