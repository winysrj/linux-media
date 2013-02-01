Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39267 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3BAMAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:00:30 -0500
Received: by mail-wi0-f182.google.com with SMTP id hn14so482568wib.15
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 04:00:27 -0800 (PST)
Message-ID: <510BACD5.2070406@googlemail.com>
Date: Fri, 01 Feb 2013 11:53:57 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
References: <510A9A1E.9090801@googlemail.com> <CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com> <510ADB2F.4080901@googlemail.com> <510AF800.2090607@googlemail.com>
In-Reply-To: <510AF800.2090607@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------020308010408030703090401"
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020308010408030703090401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



On 01/31/13 23:02, Chris Clayton wrote:
>
>
> On 01/31/13 20:59, Chris Clayton wrote:
>> Hi Devin
>>
>> On 01/31/13 16:31, Devin Heitmueller wrote:
>>> On Thu, Jan 31, 2013 at 11:21 AM, Chris Clayton
>>> <chris2553@googlemail.com> wrote:
>>>> Hi.
>>>>
>>>> On linuxtv.org, the Hauppauge WinTV-HVR-1400 is listed as being
>>>> supported.
>>>> I've bought one, but I find that when I run the scan for dvb-t
>>>> channels,
>>>> none are found. I have tried kernels 2.6.11, 2.7.5 and 3.8.0-rc5+
>>>> (pulled
>>>> from Linus' tree today)
>>>>
>>>> I know the aerial and cable are OK because, using the same cable,
>>>> scanning
>>>> with an internal PCI dvb-t card in a desktop computer finds 117 TV
>>>> and radio
>>>> channels. I know the HVR-1400 expresscard is OK because, again using
>>>> the
>>>> same cable, on Windows 7 the Hauppauge TV viewing application also
>>>> finds all
>>>> those channels.
>>>
[snip]

I've been doing some more investigation having realised that debugging 
wasn't turned on for the xc2028 driver (because it's built-in and I'd 
put the entry in /etc/modprobe.d/hvr1400.conf. Doh!).

I've found that whilst a scan is running, errors occur in (I think) 
trying to send the firmware to the tuner. I've attached the kernel log 
that shows the laptop booting, the pciehp hotplug driver seeing the card 
when I plug it in, the modules loading when I run modprobe (see below 
for why I do it that way) and the debug output when I run scandvb.

[[ I run modprobe to load the drivers because I have blacklisted 
cx23885. I've done this because I've found that when I plug the card 
into the expresscard slot, it frequently "bounces" out again and, 
because by that time the driver is running, I get an oops that switches 
to the console and requires a reboot. "IP:[<f8e52365>] 
cx23885_video_wakeup+0x25/0x130 [cx23885]" Running modprobe when I'm 
sure the card is secure obviously avoids this problem. I can report this 
separately, if that would help. ]]

The log contains several iterations of the error, each one showing:

Feb  1 11:10:51 laptop kernel: xc2028 8-0064: checking firmware, user 
requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 
5200, scode_nr 0
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: seek_firmware called, want 
type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Found firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Loading firmware for 
type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:52 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 
(should be 4)
Feb  1 11:10:52 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:52 laptop kernel: xc2028 8-0064: Error -22 while loading 
base firmware


I have no problems with firmware load for the only other device I have 
(a USB Freecom dvb-t stick) that needs firmware loading

Let me know if I can provide any additional diagnostics.

Thanks

Chris




--------------020308010408030703090401
Content-Type: text/plain; charset=us-ascii;
 name="hvr1400-kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hvr1400-kernel.log"

Feb  1 10:56:40 laptop kernel: klogd 1.5.0, log source = /proc/kmsg started.
Feb  1 10:56:40 laptop kernel: Inspecting /boot/System.map-3.7.5
Feb  1 10:56:40 laptop kernel: Cannot find map file.
Feb  1 10:56:40 laptop kernel: Loaded 21464 symbols from 12 modules.
Feb  1 10:56:40 laptop kernel: Initializing cgroup subsys cpu
Feb  1 10:56:40 laptop kernel: Linux version 3.7.5 (chris@laptop) (gcc version 4.7.3 20130126 (prerelease) (GCC) ) #23 SMP PREEMPT Fri Feb 1 10:06:14 GMT 2013
Feb  1 10:56:40 laptop kernel: Disabled fast string operations
Feb  1 10:56:40 laptop kernel: e820: BIOS-provided physical RAM map:
Feb  1 10:56:40 laptop kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
Feb  1 10:56:40 laptop kernel: BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
Feb  1 10:56:40 laptop kernel: BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
Feb  1 10:56:40 laptop kernel: BIOS-e820: [mem 0x0000000000100000-0x00000000dab0efff] usable
Feb  1 10:56:40 laptop kernel: BIOS-e820: [mem 0x00000000dab0f000-0x00000000dad4efff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000dad4f000-0x00000000dad6efff] ACPI NVS
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000dad6f000-0x00000000daf1efff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000daf1f000-0x00000000daf9efff] ACPI NVS
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
Feb  1 10:56:41 laptop kernel: BIOS-e820: [mem 0x0000000100000000-0x000000021fdfffff] usable
Feb  1 10:56:41 laptop kernel: NX (Execute Disable) protection: active
Feb  1 10:56:41 laptop kernel: SMBIOS 2.6 present.
Feb  1 10:56:41 laptop kernel: DMI: FUJITSU LIFEBOOK AH531/FJNBB0F, BIOS 1.30 05/28/2012
Feb  1 10:56:41 laptop kernel: e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
Feb  1 10:56:42 laptop kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
Feb  1 10:56:42 laptop kernel: e820: last_pfn = 0x21fe00 max_arch_pfn = 0x1000000
Feb  1 10:56:42 laptop kernel: MTRR default type: uncachable
Feb  1 10:56:42 laptop kernel: MTRR fixed ranges enabled:
Feb  1 10:56:42 laptop kernel:   00000-9FFFF write-back
Feb  1 10:56:42 laptop kernel:   A0000-BFFFF uncachable
Feb  1 10:56:42 laptop kernel:   C0000-FFFFF write-protect
Feb  1 10:56:42 laptop kernel: MTRR variable ranges enabled:
Feb  1 10:56:42 laptop kernel:   0 base 0FFC00000 mask FFFC00000 write-protect
Feb  1 10:56:42 laptop kernel:   1 base 000000000 mask F80000000 write-back
Feb  1 10:56:42 laptop kernel:   2 base 080000000 mask FC0000000 write-back
Feb  1 10:56:42 laptop kernel:   3 base 0C0000000 mask FE0000000 write-back
Feb  1 10:56:42 laptop kernel:   4 base 0DC000000 mask FFC000000 uncachable
Feb  1 10:56:42 laptop kernel:   5 base 0DB000000 mask FFF000000 uncachable
Feb  1 10:56:42 laptop kernel:   6 base 100000000 mask F00000000 write-back
Feb  1 10:56:42 laptop kernel:   7 base 200000000 mask FE0000000 write-back
Feb  1 10:56:42 laptop kernel:   8 base 21FE00000 mask FFFE00000 uncachable
Feb  1 10:56:42 laptop kernel:   9 disabled
Feb  1 10:56:43 laptop kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Feb  1 10:56:43 laptop kernel: initial memory mapped: [mem 0x00000000-0x01bfffff]
Feb  1 10:56:43 laptop kernel: Base memory trampoline at [c0099000] 99000 size 16384
Feb  1 10:56:43 laptop kernel: reserving inaccessible SNB gfx pages
Feb  1 10:56:43 laptop kernel: init_memory_mapping: [mem 0x00000000-0x37bfdfff]
Feb  1 10:56:43 laptop kernel:  [mem 0x00000000-0x001fffff] page 4k
Feb  1 10:56:43 laptop kernel:  [mem 0x00200000-0x379fffff] page 2M
Feb  1 10:56:43 laptop kernel:  [mem 0x37a00000-0x37bfdfff] page 4k
Feb  1 10:56:43 laptop kernel: kernel direct mapping tables up to 0x37bfdfff @ [mem 0x01bfa000-0x01bfffff]
Feb  1 10:56:43 laptop kernel: ACPI: RSDP 000f00e0 00024 (v02 FUJ   )
Feb  1 10:56:43 laptop kernel: ACPI: XSDT daffe120 00084 (v01 FUJ    PC       00000001 FUJ  00000001)
Feb  1 10:56:43 laptop kernel: ACPI: FACP daff0000 000F4 (v03 FUJ    PC       00000001 PTL  00000001)
Feb  1 10:56:43 laptop kernel: ACPI: DSDT daff3000 0794A (v02 FUJ    FJNBB0F  00000000 INTL 20061109)
Feb  1 10:56:43 laptop kernel: ACPI: FACS daf3d000 00040
Feb  1 10:56:43 laptop kernel: ACPI: SLIC daffd000 00176 (v01 FUJ    PC       00000001 FUJ  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: SSDT daffb000 01068 (v01 FUJ    PtidDevc 00001000 INTL 20061109)
Feb  1 10:56:44 laptop kernel: ACPI: ASF! daff2000 000A5 (v32 FUJ    PC       00000001 PTL  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: HPET dafef000 00038 (v01 FUJ    PC       00000001 PTL  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: APIC dafee000 00098 (v01 FUJ    PC       00000001 PTL  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: MCFG dafed000 0003C (v01 FUJ    PC       00000001 PTL  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: SSDT dafec000 007C2 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
Feb  1 10:56:44 laptop kernel: ACPI: SSDT dafeb000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
Feb  1 10:56:44 laptop kernel: ACPI: UEFI dafea000 0003E (v01 FUJ    PC       00000001 PTL  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: UEFI dafe9000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: UEFI dafe8000 00242 (v01 FUJ    PC       00000001 PTL  00000001)
Feb  1 10:56:44 laptop kernel: ACPI: Local APIC address 0xfee00000
Feb  1 10:56:44 laptop kernel: 7810MB HIGHMEM available.
Feb  1 10:56:44 laptop kernel: 891MB LOWMEM available.
Feb  1 10:56:44 laptop kernel:   mapped low ram: 0 - 37bfe000
Feb  1 10:56:44 laptop kernel:   low ram: 0 - 37bfe000
Feb  1 10:56:44 laptop kernel: Zone ranges:
Feb  1 10:56:44 laptop kernel:   DMA      [mem 0x00010000-0x00ffffff]
Feb  1 10:56:44 laptop kernel:   Normal   [mem 0x01000000-0x37bfdfff]
Feb  1 10:56:45 laptop kernel:   HighMem  [mem 0x37bfe000-0x1fdfffff]
Feb  1 10:56:45 laptop kernel: Movable zone start for each node
Feb  1 10:56:45 laptop kernel: Early memory node ranges
Feb  1 10:56:45 laptop kernel:   node   0: [mem 0x00010000-0x0009cfff]
Feb  1 10:56:45 laptop kernel:   node   0: [mem 0x00100000-0xdab0efff]
Feb  1 10:56:45 laptop kernel:   node   0: [mem 0xdafff000-0xdaffffff]
Feb  1 10:56:45 laptop kernel:   node   0: [mem 0x00000000-0x1fdfffff]
Feb  1 10:56:45 laptop kernel: On node 0 totalpages: 2074781
Feb  1 10:56:45 laptop kernel: free_area_init_node: node 0, pgdat c156c780, node_mem_map f37fd200
Feb  1 10:56:45 laptop kernel:   DMA zone: 32 pages used for memmap
Feb  1 10:56:45 laptop kernel:   DMA zone: 0 pages reserved
Feb  1 10:56:45 laptop kernel:   DMA zone: 3949 pages, LIFO batch:0
Feb  1 10:56:45 laptop kernel:   Normal zone: 1752 pages used for memmap
Feb  1 10:56:45 laptop kernel:   Normal zone: 222502 pages, LIFO batch:31
Feb  1 10:56:45 laptop kernel:   HighMem zone: 15621 pages used for memmap
Feb  1 10:56:45 laptop kernel:   HighMem zone: 1830925 pages, LIFO batch:31
Feb  1 10:56:45 laptop kernel: Using APIC driver default
Feb  1 10:56:45 laptop kernel: ACPI: PM-Timer IO Port: 0x408
Feb  1 10:56:45 laptop kernel: ACPI: Local APIC address 0xfee00000
Feb  1 10:56:45 laptop kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Feb  1 10:56:45 laptop kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Feb  1 10:56:45 laptop kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Feb  1 10:56:45 laptop kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Feb  1 10:56:45 laptop kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
Feb  1 10:56:45 laptop kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
Feb  1 10:56:45 laptop kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
Feb  1 10:56:46 laptop kernel: ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
Feb  1 10:56:46 laptop kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Feb  1 10:56:46 laptop kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Feb  1 10:56:46 laptop kernel: ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
Feb  1 10:56:46 laptop kernel: IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
Feb  1 10:56:46 laptop kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Feb  1 10:56:46 laptop kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Feb  1 10:56:46 laptop kernel: ACPI: IRQ0 used by override.
Feb  1 10:56:46 laptop kernel: ACPI: IRQ2 used by override.
Feb  1 10:56:46 laptop kernel: ACPI: IRQ9 used by override.
Feb  1 10:56:46 laptop kernel: Using ACPI (MADT) for SMP configuration information
Feb  1 10:56:46 laptop kernel: ACPI: HPET id: 0x8086a301 base: 0xfed00000
Feb  1 10:56:46 laptop kernel: smpboot: 8 Processors exceeds NR_CPUS limit of 4
Feb  1 10:56:46 laptop kernel: smpboot: Allowing 4 CPUs, 0 hotplug CPUs
Feb  1 10:56:46 laptop kernel: nr_irqs_gsi: 40
Feb  1 10:56:46 laptop kernel: PM: Registered nosave memory: 000000000009d000 - 000000000009e000
Feb  1 10:56:46 laptop kernel: PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
Feb  1 10:56:46 laptop kernel: PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Feb  1 10:56:46 laptop kernel: PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Feb  1 10:56:46 laptop kernel: e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
Feb  1 10:56:46 laptop kernel: setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Feb  1 10:56:46 laptop kernel: PERCPU: Embedded 12 pages/cpu @f37bb000 s25792 r0 d23360 u49152
Feb  1 10:56:46 laptop kernel: pcpu-alloc: s25792 r0 d23360 u49152 alloc=12*4096
Feb  1 10:56:46 laptop kernel: pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
Feb  1 10:56:46 laptop kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2057376
Feb  1 10:56:47 laptop kernel: Kernel command line: root=/dev/sda5 pcie_ports=native pciehp.pciehp_debug=1 tuner_xc2028.debug=1 ro resume=/dev/sda6
Feb  1 10:56:47 laptop kernel: PID hash table entries: 4096 (order: 2, 16384 bytes)
Feb  1 10:56:47 laptop kernel: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Feb  1 10:56:47 laptop kernel: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Feb  1 10:56:47 laptop kernel: __ex_table already sorted, skipping sort
Feb  1 10:56:47 laptop kernel: Initializing CPU#0
Feb  1 10:56:47 laptop kernel: xsave: enabled xstate_bv 0x7, cntxt size 0x340
Feb  1 10:56:47 laptop kernel: Initializing HighMem for node 0 (00037bfe:0021fe00)
Feb  1 10:56:47 laptop kernel: Memory: 8221544k/8910848k available (4096k kernel code, 77576k reserved, 1479k data, 376k init, 7386180k highmem)
Feb  1 10:56:47 laptop kernel: virtual kernel memory layout:
Feb  1 10:56:47 laptop kernel:     fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
Feb  1 10:56:47 laptop kernel:     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
Feb  1 10:56:47 laptop kernel:     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
Feb  1 10:56:47 laptop kernel:     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
Feb  1 10:56:47 laptop kernel:       .init : 0xc1572000 - 0xc15d0000   ( 376 kB)
Feb  1 10:56:47 laptop kernel:       .data : 0xc1400010 - 0xc1571ec0   (1479 kB)
Feb  1 10:56:47 laptop kernel:       .text : 0xc1000000 - 0xc1400010   (4096 kB)
Feb  1 10:56:47 laptop kernel: Checking if this processor honours the WP bit even in supervisor mode...Ok.
Feb  1 10:56:47 laptop kernel: SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Feb  1 10:56:47 laptop kernel: Preemptible hierarchical RCU implementation.
Feb  1 10:56:48 laptop kernel: ^IDump stacks of tasks blocking RCU-preempt GP.
Feb  1 10:56:48 laptop kernel: NR_IRQS:2304 nr_irqs:712 16
Feb  1 10:56:48 laptop kernel: CPU 0 irqstacks, hard=f3008000 soft=f300a000
Feb  1 10:56:48 laptop kernel: Extended CMOS year: 2000
Feb  1 10:56:48 laptop kernel: Console: colour VGA+ 80x25
Feb  1 10:56:48 laptop kernel: console [tty0] enabled
Feb  1 10:56:48 laptop kernel: hpet clockevent registered
Feb  1 10:56:48 laptop kernel: tsc: Fast TSC calibration using PIT
Feb  1 10:56:48 laptop kernel: tsc: Detected 2494.322 MHz processor
Feb  1 10:56:48 laptop kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.64 BogoMIPS (lpj=9977288)
Feb  1 10:56:48 laptop kernel: pid_max: default: 32768 minimum: 301
Feb  1 10:56:48 laptop kernel: Mount-cache hash table entries: 512
Feb  1 10:56:48 laptop kernel: Disabled fast string operations
Feb  1 10:56:48 laptop kernel: CPU: Physical Processor ID: 0
Feb  1 10:56:48 laptop kernel: CPU: Processor Core ID: 0
Feb  1 10:56:49 laptop kernel: ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
Feb  1 10:56:49 laptop kernel: ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
Feb  1 10:56:49 laptop kernel: mce: CPU supports 7 MCE banks
Feb  1 10:56:49 laptop kernel: CPU0: Thermal monitoring enabled (TM1)
Feb  1 10:56:49 laptop kernel: process: using mwait in idle threads
Feb  1 10:56:49 laptop kernel: Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Feb  1 10:56:49 laptop kernel: Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
Feb  1 10:56:49 laptop kernel: tlb_flushall_shift: 5
Feb  1 10:56:49 laptop kernel: Freeing SMP alternatives: 16k freed
Feb  1 10:56:49 laptop kernel: ACPI: Core revision 20120913
Feb  1 10:56:49 laptop kernel: Enabling APIC mode:  Flat.  Using 1 I/O APICs
Feb  1 10:56:49 laptop kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Feb  1 10:56:49 laptop kernel: smpboot: CPU0: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz (fam: 06, model: 2a, stepping: 07)
Feb  1 10:56:49 laptop kernel: Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
Feb  1 10:56:50 laptop kernel: perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
Feb  1 10:56:50 laptop kernel: ... version:                3
Feb  1 10:56:50 laptop kernel: ... bit width:              48
Feb  1 10:56:50 laptop kernel: ... generic registers:      4
Feb  1 10:56:50 laptop kernel: ... value mask:             0000ffffffffffff
Feb  1 10:56:50 laptop kernel: ... max period:             000000007fffffff
Feb  1 10:56:50 laptop kernel: ... fixed-purpose events:   3
Feb  1 10:56:50 laptop kernel: ... event mask:             000000070000000f
Feb  1 10:56:50 laptop kernel: CPU 1 irqstacks, hard=f309a000 soft=f309c000
Feb  1 10:56:50 laptop kernel: Initializing CPU#1
Feb  1 10:56:50 laptop kernel: Disabled fast string operations
Feb  1 10:56:50 laptop kernel: smpboot: Booting Node   0, Processors  #1
Feb  1 10:56:51 laptop kernel: CPU 2 irqstacks, hard=f30b2000 soft=f30b4000
Feb  1 10:56:51 laptop kernel: Initializing CPU#2
Feb  1 10:56:51 laptop kernel: Disabled fast string operations
Feb  1 10:56:51 laptop kernel:  #2
Feb  1 10:56:51 laptop kernel: CPU 3 irqstacks, hard=f30be000 soft=f30c8000
Feb  1 10:56:51 laptop kernel:  #3 OK
Feb  1 10:56:51 laptop kernel: Initializing CPU#3
Feb  1 10:56:51 laptop kernel: Disabled fast string operations
Feb  1 10:56:51 laptop kernel: Brought up 4 CPUs
Feb  1 10:56:51 laptop kernel: smpboot: Total of 4 processors activated (19954.57 BogoMIPS)
Feb  1 10:56:51 laptop kernel: devtmpfs: initialized
Feb  1 10:56:51 laptop kernel: PM: Registering ACPI NVS region [mem 0xdad4f000-0xdad6efff] (131072 bytes)
Feb  1 10:56:51 laptop kernel: PM: Registering ACPI NVS region [mem 0xdaf1f000-0xdaf9efff] (524288 bytes)
Feb  1 10:56:51 laptop kernel: NET: Registered protocol family 16
Feb  1 10:56:51 laptop kernel: ACPI: bus type pci registered
Feb  1 10:56:51 laptop kernel: PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Feb  1 10:56:51 laptop kernel: PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
Feb  1 10:56:51 laptop kernel: PCI: Using MMCONFIG for extended config space
Feb  1 10:56:51 laptop kernel: PCI: Using configuration type 1 for base access
Feb  1 10:56:51 laptop kernel: bio: create slab <bio-0> at 0
Feb  1 10:56:51 laptop kernel: ACPI: Added _OSI(Module Device)
Feb  1 10:56:52 laptop kernel: ACPI: Added _OSI(Processor Device)
Feb  1 10:56:52 laptop kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Feb  1 10:56:52 laptop kernel: ACPI: Added _OSI(Processor Aggregator Device)
Feb  1 10:56:52 laptop kernel: ACPI: EC: Look up EC in DSDT
Feb  1 10:56:52 laptop kernel: ACPI: Executed 1 blocks of module-level executable AML code
Feb  1 10:56:52 laptop kernel: [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
Feb  1 10:56:52 laptop kernel: ACPI: SSDT dad4d718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
Feb  1 10:56:52 laptop kernel: ACPI: Dynamic OEM Table Load:
Feb  1 10:56:52 laptop kernel: ACPI: SSDT   (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
Feb  1 10:56:52 laptop kernel: ACPI: SSDT daf0fa98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
Feb  1 10:56:52 laptop kernel: ACPI: Dynamic OEM Table Load:
Feb  1 10:56:52 laptop kernel: ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
Feb  1 10:56:52 laptop kernel: ACPI: SSDT dad4cd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
Feb  1 10:56:52 laptop kernel: ACPI: Dynamic OEM Table Load:
Feb  1 10:56:52 laptop kernel: ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
Feb  1 10:56:52 laptop kernel: ACPI: Interpreter enabled
Feb  1 10:56:53 laptop kernel: ACPI: (supports S0 S3 S4 S5)
Feb  1 10:56:53 laptop kernel: ACPI: Using IOAPIC for interrupt routing
Feb  1 10:56:53 laptop kernel: ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
Feb  1 10:56:53 laptop kernel: ACPI: No dock devices found.
Feb  1 10:56:53 laptop kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Feb  1 10:56:53 laptop kernel: \_SB_.PCI0:_OSC invalid UUID
Feb  1 10:56:53 laptop kernel: _OSC request data:1 8 1f 
Feb  1 10:56:53 laptop kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
Feb  1 10:56:53 laptop kernel: PCI host bridge to bus 0000:00
Feb  1 10:56:53 laptop kernel: pci_bus 0000:00: root bus resource [bus 00-3e]
Feb  1 10:56:53 laptop kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
Feb  1 10:56:53 laptop kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Feb  1 10:56:53 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Feb  1 10:56:53 laptop kernel: pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
Feb  1 10:56:53 laptop kernel: pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
Feb  1 10:56:53 laptop kernel: pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
Feb  1 10:56:53 laptop kernel: pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
Feb  1 10:56:53 laptop kernel: pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
Feb  1 10:56:53 laptop kernel: pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
Feb  1 10:56:53 laptop kernel: pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
Feb  1 10:56:54 laptop kernel: pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
Feb  1 10:56:54 laptop kernel: pci 0000:00:16.0: reg 10: [mem 0xf1605000-0xf160500f 64bit]
Feb  1 10:56:54 laptop kernel: pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Feb  1 10:56:54 laptop kernel: pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
Feb  1 10:56:54 laptop kernel: pci 0000:00:1a.0: reg 10: [mem 0xf160a000-0xf160a3ff]
Feb  1 10:56:54 laptop kernel: pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Feb  1 10:56:54 laptop kernel: pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
Feb  1 10:56:54 laptop kernel: pci 0000:00:1b.0: reg 10: [mem 0xf1600000-0xf1603fff 64bit]
Feb  1 10:56:54 laptop kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Feb  1 10:56:54 laptop kernel: pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
Feb  1 10:56:54 laptop kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Feb  1 10:56:54 laptop kernel: pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
Feb  1 10:56:54 laptop kernel: pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Feb  1 10:56:54 laptop kernel: pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
Feb  1 10:56:54 laptop kernel: pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
Feb  1 10:56:54 laptop kernel: pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
Feb  1 10:56:54 laptop kernel: pci 0000:00:1d.0: reg 10: [mem 0xf1609000-0xf16093ff]
Feb  1 10:56:54 laptop kernel: pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: reg 14: [io  0x4094-0x4097]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: reg 1c: [io  0x4090-0x4093]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: reg 24: [mem 0xf1608000-0xf16087ff]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.2: PME# supported from D3hot
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.3: reg 10: [mem 0xf1604000-0xf16040ff 64bit]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
Feb  1 10:56:55 laptop kernel: pci 0000:01:00.0: [8086:008a] type 00 class 0x028000
Feb  1 10:56:55 laptop kernel: pci 0000:01:00.0: reg 10: [mem 0xf1500000-0xf1501fff 64bit]
Feb  1 10:56:55 laptop kernel: pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
Feb  1 10:56:55 laptop kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
Feb  1 10:56:55 laptop kernel: pci 0000:00:1c.3: PCI bridge to [bus 02-06]
Feb  1 10:56:56 laptop kernel: pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
Feb  1 10:56:56 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
Feb  1 10:56:56 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
Feb  1 10:56:56 laptop kernel: pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
Feb  1 10:56:56 laptop kernel: pci 0000:07:00.0: reg 10: [io  0x2000-0x20ff]
Feb  1 10:56:56 laptop kernel: pci 0000:07:00.0: reg 18: [mem 0xf0c04000-0xf0c04fff 64bit pref]
Feb  1 10:56:56 laptop kernel: pci 0000:07:00.0: reg 20: [mem 0xf0c00000-0xf0c03fff 64bit pref]
Feb  1 10:56:56 laptop kernel: pci 0000:07:00.0: supports D1 D2
Feb  1 10:56:56 laptop kernel: pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Feb  1 10:56:56 laptop kernel: pci 0000:00:1c.5: PCI bridge to [bus 07]
Feb  1 10:56:56 laptop kernel: pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
Feb  1 10:56:57 laptop kernel: pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
Feb  1 10:56:57 laptop kernel: pci_bus 0000:00: on NUMA node 0
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
Feb  1 10:56:57 laptop kernel: \_SB_.PCI0:_OSC invalid UUID
Feb  1 10:56:57 laptop kernel: _OSC request data:1 f 1f 
Feb  1 10:56:57 laptop kernel:  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
Feb  1 10:56:57 laptop kernel:  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14 15)
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 *11 12 14 15)
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
Feb  1 10:56:57 laptop kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
Feb  1 10:56:58 laptop kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
Feb  1 10:56:58 laptop kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14 15)
Feb  1 10:56:58 laptop kernel: vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Feb  1 10:56:58 laptop kernel: vgaarb: loaded
Feb  1 10:56:58 laptop kernel: vgaarb: bridge control possible 0000:00:02.0
Feb  1 10:56:58 laptop kernel: SCSI subsystem initialized
Feb  1 10:56:58 laptop kernel: ACPI: bus type scsi registered
Feb  1 10:56:58 laptop kernel: libata version 3.00 loaded.
Feb  1 10:56:58 laptop kernel: ACPI: bus type usb registered
Feb  1 10:56:58 laptop kernel: usbcore: registered new interface driver usbfs
Feb  1 10:56:58 laptop kernel: usbcore: registered new interface driver hub
Feb  1 10:56:58 laptop kernel: usbcore: registered new device driver usb
Feb  1 10:56:58 laptop kernel: Linux video capture interface: v2.00
Feb  1 10:56:58 laptop kernel: Advanced Linux Sound Architecture Driver Initialized.
Feb  1 10:56:58 laptop kernel: PCI: Using ACPI for IRQ routing
Feb  1 10:56:58 laptop kernel: PCI: pci_cache_line_size set to 64 bytes
Feb  1 10:56:58 laptop kernel: e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
Feb  1 10:56:58 laptop kernel: e820: reserve RAM buffer [mem 0xdab0f000-0xdbffffff]
Feb  1 10:56:58 laptop kernel: e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
Feb  1 10:56:58 laptop kernel: e820: reserve RAM buffer [mem 0x21fe00000-0x21fffffff]
Feb  1 10:56:59 laptop kernel: Switching to clocksource hpet
Feb  1 10:56:59 laptop kernel: pnp: PnP ACPI init
Feb  1 10:56:59 laptop kernel: ACPI: bus type pnp registered
Feb  1 10:56:59 laptop kernel: pnp 00:00: [bus 00-3e]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [io  0x0000-0x0cf7 window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [io  0x0cf8-0x0cff]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [io  0x0d00-0xffff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000a0000-0x000bffff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000c0000-0x000c3fff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000c4000-0x000c7fff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000c8000-0x000cbfff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000cc000-0x000cffff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000d0000-0x000d3fff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000d4000-0x000d7fff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000d8000-0x000dbfff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000dc000-0x000dffff window]
Feb  1 10:56:59 laptop kernel: pnp 00:00: [mem 0x000e0000-0x000e3fff window]
Feb  1 10:57:00 laptop kernel: pnp 00:00: [mem 0x000e4000-0x000e7fff window]
Feb  1 10:57:00 laptop kernel: pnp 00:00: [mem 0x000e8000-0x000ebfff window]
Feb  1 10:57:00 laptop kernel: pnp 00:00: [mem 0x000ec000-0x000effff window]
Feb  1 10:57:00 laptop kernel: pnp 00:00: [mem 0x000f0000-0x000fffff window]
Feb  1 10:57:00 laptop kernel: pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
Feb  1 10:57:00 laptop kernel: pnp 00:00: [mem 0xfed40000-0xfed44fff window]
Feb  1 10:57:00 laptop kernel: pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
Feb  1 10:57:00 laptop kernel: pnp 00:01: [io  0x0000-0x001f]
Feb  1 10:57:00 laptop kernel: pnp 00:01: [io  0x0081-0x0091]
Feb  1 10:57:00 laptop kernel: pnp 00:01: [io  0x0093-0x009f]
Feb  1 10:57:00 laptop kernel: pnp 00:01: [io  0x00c0-0x00df]
Feb  1 10:57:00 laptop kernel: pnp 00:01: [dma 4]
Feb  1 10:57:00 laptop kernel: pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
Feb  1 10:57:00 laptop kernel: pnp 00:02: [mem 0xff000000-0xffffffff]
Feb  1 10:57:00 laptop kernel: pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
Feb  1 10:57:00 laptop kernel: pnp 00:03: [mem 0xfed00000-0xfed003ff]
Feb  1 10:57:00 laptop kernel: pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
Feb  1 10:57:01 laptop kernel: pnp 00:04: [io  0x00f0]
Feb  1 10:57:01 laptop kernel: pnp 00:04: [irq 13]
Feb  1 10:57:01 laptop kernel: pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x002e-0x002f]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x004e-0x004f]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0061]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0063]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0065]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0067]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0070]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0080]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0092]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x00b2-0x00b3]
Feb  1 10:57:01 laptop kernel: pnp 00:05: [io  0x0680-0x069f]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0x1000-0x100f]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0xffff]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0xffff]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0x0400-0x0453]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0x0458-0x047f]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0x0500-0x057f]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0x164e-0x164f]
Feb  1 10:57:02 laptop kernel: pnp 00:05: [io  0x0068-0x0077]
Feb  1 10:57:02 laptop kernel: system 00:05: [io  0x0680-0x069f] has been reserved
Feb  1 10:57:02 laptop kernel: system 00:05: [io  0x1000-0x100f] has been reserved
Feb  1 10:57:02 laptop kernel: system 00:05: [io  0xffff] has been reserved
Feb  1 10:57:02 laptop kernel: system 00:05: [io  0xffff] has been reserved
Feb  1 10:57:02 laptop kernel: system 00:05: [io  0x0400-0x0453] has been reserved
Feb  1 10:57:02 laptop kernel: system 00:05: [io  0x0458-0x047f] has been reserved
Feb  1 10:57:02 laptop kernel: system 00:05: [io  0x0500-0x057f] has been reserved
Feb  1 10:57:03 laptop kernel: system 00:05: [io  0x164e-0x164f] has been reserved
Feb  1 10:57:03 laptop kernel: system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
Feb  1 10:57:03 laptop kernel: pnp 00:06: [io  0x0070-0x0077]
Feb  1 10:57:03 laptop kernel: pnp 00:06: [irq 8]
Feb  1 10:57:03 laptop kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
Feb  1 10:57:03 laptop kernel: pnp 00:07: [io  0x0454-0x0457]
Feb  1 10:57:03 laptop kernel: system 00:07: [io  0x0454-0x0457] has been reserved
Feb  1 10:57:03 laptop kernel: system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
Feb  1 10:57:03 laptop kernel: pnp 00:08: [io  0x0060]
Feb  1 10:57:03 laptop kernel: pnp 00:08: [io  0x0064]
Feb  1 10:57:03 laptop kernel: pnp 00:08: [irq 1]
Feb  1 10:57:03 laptop kernel: pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
Feb  1 10:57:03 laptop kernel: pnp 00:09: [irq 12]
Feb  1 10:57:03 laptop kernel: pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
Feb  1 10:57:03 laptop kernel: pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
Feb  1 10:57:03 laptop kernel: pnp 00:0a: [mem 0xfed10000-0xfed17fff]
Feb  1 10:57:03 laptop kernel: pnp 00:0a: [mem 0xfed18000-0xfed18fff]
Feb  1 10:57:03 laptop kernel: pnp 00:0a: [mem 0xfed19000-0xfed19fff]
Feb  1 10:57:04 laptop kernel: pnp 00:0a: [mem 0xf8000000-0xfbffffff]
Feb  1 10:57:04 laptop kernel: pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
Feb  1 10:57:04 laptop kernel: pnp 00:0a: [mem 0xfed90000-0xfed93fff]
Feb  1 10:57:04 laptop kernel: pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
Feb  1 10:57:04 laptop kernel: pnp 00:0a: [mem 0xff000000-0xffffffff]
Feb  1 10:57:04 laptop kernel: pnp 00:0a: [mem 0xfee00000-0xfeefffff]
Feb  1 10:57:04 laptop kernel: pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
Feb  1 10:57:04 laptop kernel: system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
Feb  1 10:57:04 laptop kernel: pnp 00:0b: [mem 0x20000000-0x201fffff]
Feb  1 10:57:05 laptop kernel: pnp 00:0b: [mem 0x40000000-0x401fffff]
Feb  1 10:57:05 laptop kernel: system 00:0b: [mem 0x20000000-0x201fffff] could not be reserved
Feb  1 10:57:05 laptop kernel: system 00:0b: [mem 0x40000000-0x401fffff] could not be reserved
Feb  1 10:57:05 laptop kernel: system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
Feb  1 10:57:05 laptop kernel: pnp: PnP ACPI: found 12 devices
Feb  1 10:57:05 laptop kernel: ACPI: ACPI bus type pnp unregistered
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.3: PCI bridge to [bus 02-06]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.5: PCI bridge to [bus 07]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
Feb  1 10:57:05 laptop kernel: pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
Feb  1 10:57:05 laptop kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Feb  1 10:57:05 laptop kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Feb  1 10:57:05 laptop kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Feb  1 10:57:05 laptop kernel: pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
Feb  1 10:57:05 laptop kernel: pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
Feb  1 10:57:05 laptop kernel: pci_bus 0000:01: resource 1 [mem 0xf1500000-0xf15fffff]
Feb  1 10:57:05 laptop kernel: pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
Feb  1 10:57:06 laptop kernel: pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
Feb  1 10:57:06 laptop kernel: pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
Feb  1 10:57:06 laptop kernel: pci_bus 0000:07: resource 0 [io  0x2000-0x2fff]
Feb  1 10:57:06 laptop kernel: pci_bus 0000:07: resource 2 [mem 0xf0c00000-0xf0cfffff 64bit pref]
Feb  1 10:57:06 laptop kernel: NET: Registered protocol family 2
Feb  1 10:57:06 laptop kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Feb  1 10:57:06 laptop kernel: TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Feb  1 10:57:06 laptop kernel: TCP: Hash tables configured (established 131072 bind 65536)
Feb  1 10:57:06 laptop kernel: TCP: reno registered
Feb  1 10:57:06 laptop kernel: UDP hash table entries: 512 (order: 2, 16384 bytes)
Feb  1 10:57:06 laptop kernel: UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
Feb  1 10:57:06 laptop kernel: NET: Registered protocol family 1
Feb  1 10:57:06 laptop kernel: pci 0000:00:02.0: Boot video device
Feb  1 10:57:06 laptop kernel: PCI: CLS 64 bytes, default 64
Feb  1 10:57:06 laptop kernel: bounce pool size: 64 pages
Feb  1 10:57:06 laptop kernel: fuse init (API version 7.20)
Feb  1 10:57:06 laptop kernel: msgmni has been set to 1631
Feb  1 10:57:06 laptop kernel: io scheduler noop registered
Feb  1 10:57:06 laptop kernel: io scheduler cfq registered (default)
Feb  1 10:57:06 laptop kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Feb  1 10:57:06 laptop kernel: pciehp 0000:00:1c.3:pcie04: Hotplug Controller:
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.3 IRQ 19
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Vendor ID            : 0x8086
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Device ID            : 0x1c16
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Subsystem ID         : 0x1610
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Subsystem Vendor ID  : 0x10cf
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   PCIe Cap offset      : 0x40
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   PCI resource [7]     : [io  0x3000-0x3fff]
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   PCI resource [8]     : [mem 0xf0d00000-0xf14fffff]
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   PCI resource [9]     : [mem 0xf0400000-0xf0bfffff 64bit pref]
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04: Slot Capabilities      : 0x001cb260
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Physical Slot Number : 3
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Attention Button     :  no
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Power Controller     :  no
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   MRL Sensor           :  no
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Attention Indicator  :  no
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Power Indicator      :  no
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Hot-Plug Surprise    : yes
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   EMI Present          :  no
Feb  1 10:57:07 laptop kernel: pciehp 0000:00:1c.3:pcie04:   Command Completed    :  no
Feb  1 10:57:08 laptop kernel: pciehp 0000:00:1c.3:pcie04: Slot Status            : 0x0000
Feb  1 10:57:08 laptop kernel: pciehp 0000:00:1c.3:pcie04: Slot Control           : 0x0008
Feb  1 10:57:08 laptop kernel: pciehp 0000:00:1c.3:pcie04: Link Active Reporting supported
Feb  1 10:57:08 laptop kernel: pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 1c16 ss_vid 10cf ss_did 1610
Feb  1 10:57:08 laptop kernel: pciehp 0000:00:1c.3:pcie04: Registering domain:bus:dev=0000:02:00 sun=3
Feb  1 10:57:08 laptop kernel: pciehp 0000:00:1c.3:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read 28
Feb  1 10:57:08 laptop kernel: pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
Feb  1 10:57:08 laptop kernel: pciehp: pcie_port_service_register = 0
Feb  1 10:57:08 laptop kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Feb  1 10:57:08 laptop kernel: ACPI: AC Adapter [ACAD] (on-line)
Feb  1 10:57:08 laptop kernel: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Feb  1 10:57:08 laptop kernel: ACPI: Power Button [PWRB]
Feb  1 10:57:08 laptop kernel: input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
Feb  1 10:57:08 laptop kernel: ACPI: Lid Switch [LID]
Feb  1 10:57:08 laptop kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Feb  1 10:57:08 laptop kernel: ACPI: Power Button [PWRF]
Feb  1 10:57:08 laptop kernel: thermal LNXTHERM:00: registered as thermal_zone0
Feb  1 10:57:08 laptop kernel: ACPI: Thermal Zone [THRM] (61 C)
Feb  1 10:57:08 laptop kernel: isapnp: Scanning for PnP cards...
Feb  1 10:57:08 laptop kernel: ACPI: Battery Slot [BAT1] (battery present)
Feb  1 10:57:08 laptop kernel: isapnp: No Plug & Play device found
Feb  1 10:57:09 laptop kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Feb  1 10:57:09 laptop kernel: Real Time Clock Driver v1.12b
Feb  1 10:57:09 laptop kernel: Linux agpgart interface v0.103
Feb  1 10:57:09 laptop kernel: [drm] Initialized drm 1.1.0 20060810
Feb  1 10:57:09 laptop kernel: pci 0000:00:00.0: Intel Sandybridge Chipset
Feb  1 10:57:09 laptop kernel: pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
Feb  1 10:57:09 laptop kernel: pci 0000:00:00.0: detected 65536K stolen memory
Feb  1 10:57:09 laptop kernel: i915 0000:00:02.0: setting latency timer to 64
Feb  1 10:57:09 laptop kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Feb  1 10:57:09 laptop kernel: [drm] Driver supports precise vblank timestamp query.
Feb  1 10:57:09 laptop kernel: vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Feb  1 10:57:09 laptop kernel: [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
Feb  1 10:57:09 laptop kernel: fbcon: inteldrmfb (fb0) is primary device
Feb  1 10:57:09 laptop kernel: tsc: Refined TSC clocksource calibration: 2494.333 MHz
Feb  1 10:57:09 laptop kernel: Switching to clocksource tsc
Feb  1 10:57:09 laptop kernel: Console: switching to colour frame buffer device 170x48
Feb  1 10:57:09 laptop kernel: fb0: inteldrmfb frame buffer device
Feb  1 10:57:09 laptop kernel: drm: registered panic notifier
Feb  1 10:57:09 laptop kernel: acpi device:31: registered as cooling_device4
Feb  1 10:57:09 laptop kernel: ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Feb  1 10:57:09 laptop kernel: input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
Feb  1 10:57:09 laptop kernel: [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Feb  1 10:57:09 laptop kernel: ahci 0000:00:1f.2: version 3.0
Feb  1 10:57:09 laptop kernel: ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x9 impl SATA mode
Feb  1 10:57:09 laptop kernel: ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
Feb  1 10:57:09 laptop kernel: ahci 0000:00:1f.2: setting latency timer to 64
Feb  1 10:57:09 laptop kernel: scsi0 : ahci
Feb  1 10:57:09 laptop kernel: scsi1 : ahci
Feb  1 10:57:09 laptop kernel: scsi2 : ahci
Feb  1 10:57:09 laptop kernel: scsi3 : ahci
Feb  1 10:57:10 laptop kernel: scsi4 : ahci
Feb  1 10:57:10 laptop kernel: scsi5 : ahci
Feb  1 10:57:10 laptop kernel: ata1: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608100 irq 19
Feb  1 10:57:10 laptop kernel: ata2: DUMMY
Feb  1 10:57:10 laptop kernel: ata3: DUMMY
Feb  1 10:57:10 laptop kernel: ata4: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608280 irq 19
Feb  1 10:57:10 laptop kernel: ata5: DUMMY
Feb  1 10:57:10 laptop kernel: ata6: DUMMY
Feb  1 10:57:10 laptop kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1a.0: setting latency timer to 64
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1a.0: EHCI Host Controller
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1a.0: debug port 2
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf160a000
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Feb  1 10:57:10 laptop kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Feb  1 10:57:10 laptop kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  1 10:57:10 laptop kernel: usb usb1: Product: EHCI Host Controller
Feb  1 10:57:10 laptop kernel: usb usb1: Manufacturer: Linux 3.7.5 ehci_hcd
Feb  1 10:57:10 laptop kernel: usb usb1: SerialNumber: 0000:00:1a.0
Feb  1 10:57:10 laptop kernel: hub 1-0:1.0: USB hub found
Feb  1 10:57:10 laptop kernel: hub 1-0:1.0: 2 ports detected
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1d.0: setting latency timer to 64
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1d.0: EHCI Host Controller
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1d.0: debug port 2
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
Feb  1 10:57:10 laptop kernel: ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf1609000
Feb  1 10:57:11 laptop kernel: ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Feb  1 10:57:11 laptop kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Feb  1 10:57:11 laptop kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  1 10:57:11 laptop kernel: usb usb2: Product: EHCI Host Controller
Feb  1 10:57:11 laptop kernel: usb usb2: Manufacturer: Linux 3.7.5 ehci_hcd
Feb  1 10:57:11 laptop kernel: usb usb2: SerialNumber: 0000:00:1d.0
Feb  1 10:57:11 laptop kernel: hub 2-0:1.0: USB hub found
Feb  1 10:57:11 laptop kernel: hub 2-0:1.0: 2 ports detected
Feb  1 10:57:11 laptop kernel: uhci_hcd: USB Universal Host Controller Interface driver
Feb  1 10:57:11 laptop kernel: i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Feb  1 10:57:11 laptop kernel: i8042: Detected active multiplexing controller, rev 1.1
Feb  1 10:57:11 laptop kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Feb  1 10:57:11 laptop kernel: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Feb  1 10:57:11 laptop kernel: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Feb  1 10:57:11 laptop kernel: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Feb  1 10:57:11 laptop kernel: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Feb  1 10:57:11 laptop kernel: mousedev: PS/2 mouse device common for all mice
Feb  1 10:57:11 laptop kernel: i2c /dev entries driver
Feb  1 10:57:11 laptop kernel: ACPI Warning: 0x0000efa0-0x0000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
Feb  1 10:57:11 laptop kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Feb  1 10:57:11 laptop kernel: IR NEC protocol handler initialized
Feb  1 10:57:11 laptop kernel: IR RC5(x) protocol handler initialized
Feb  1 10:57:11 laptop kernel: IR RC6 protocol handler initialized
Feb  1 10:57:11 laptop kernel: IR JVC protocol handler initialized
Feb  1 10:57:11 laptop kernel: IR Sony protocol handler initialized
Feb  1 10:57:11 laptop kernel: IR RC5 (streamzap) protocol handler initialized
Feb  1 10:57:11 laptop kernel: IR SANYO protocol handler initialized
Feb  1 10:57:12 laptop kernel: IR MCE Keyboard/mouse protocol handler initialized
Feb  1 10:57:12 laptop kernel: usbcore: registered new interface driver uvcvideo
Feb  1 10:57:12 laptop kernel: USB Video Class driver (1.1.1)
Feb  1 10:57:12 laptop kernel: cpuidle: using governor ladder
Feb  1 10:57:12 laptop kernel: cpuidle: using governor menu
Feb  1 10:57:12 laptop kernel: usbcore: registered new interface driver usbhid
Feb  1 10:57:12 laptop kernel: usbhid: USB HID core driver
Feb  1 10:57:12 laptop kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Feb  1 10:57:12 laptop kernel: TCP: cubic registered
Feb  1 10:57:12 laptop kernel: NET: Registered protocol family 17
Feb  1 10:57:12 laptop kernel: NET: Registered protocol family 15
Feb  1 10:57:12 laptop kernel: Using IPI No-Shortcut mode
Feb  1 10:57:12 laptop kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Feb  1 10:57:12 laptop kernel: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Feb  1 10:57:12 laptop kernel: ata4.00: ATAPI: TSSTcorp CDDVDW SN-208AB, FC01, max UDMA/100
Feb  1 10:57:12 laptop kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  1 10:57:12 laptop kernel: ata4.00: configured for UDMA/100
Feb  1 10:57:12 laptop kernel: usb 1-1: new high-speed USB device number 2 using ehci_hcd
Feb  1 10:57:12 laptop kernel: ata1.00: ATA-8: TOSHIBA MK7575GSX, GT001A, max UDMA/100
Feb  1 10:57:12 laptop kernel: ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Feb  1 10:57:12 laptop kernel: ata1.00: configured for UDMA/100
Feb  1 10:57:12 laptop kernel: scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK7575GS GT00 PQ: 0 ANSI: 5
Feb  1 10:57:12 laptop kernel: sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
Feb  1 10:57:12 laptop kernel: sd 0:0:0:0: [sda] 4096-byte physical blocks
Feb  1 10:57:12 laptop kernel: sd 0:0:0:0: [sda] Write Protect is off
Feb  1 10:57:12 laptop kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb  1 10:57:12 laptop kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  1 10:57:12 laptop kernel: scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SN-208AB  FC01 PQ: 0 ANSI: 5
Feb  1 10:57:12 laptop kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Feb  1 10:57:12 laptop kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Feb  1 10:57:13 laptop kernel: sr 3:0:0:0: Attached scsi CD-ROM sr0
Feb  1 10:57:13 laptop kernel: usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Feb  1 10:57:13 laptop kernel: usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Feb  1 10:57:13 laptop kernel: hub 1-1:1.0: USB hub found
Feb  1 10:57:13 laptop kernel: hub 1-1:1.0: 6 ports detected
Feb  1 10:57:13 laptop kernel:  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
Feb  1 10:57:13 laptop kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Feb  1 10:57:13 laptop kernel: registered taskstats version 1
Feb  1 10:57:13 laptop kernel: ALSA device list:
Feb  1 10:57:13 laptop kernel:   No soundcards found.
Feb  1 10:57:13 laptop kernel: kjournald starting.  Commit interval 5 seconds
Feb  1 10:57:13 laptop kernel: EXT3-fs (sda5): mounted filesystem with writeback data mode
Feb  1 10:57:13 laptop kernel: VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
Feb  1 10:57:13 laptop kernel: usb 2-1: new high-speed USB device number 2 using ehci_hcd
Feb  1 10:57:13 laptop kernel: devtmpfs: mounted
Feb  1 10:57:13 laptop kernel: Freeing unused kernel memory: 376k freed
Feb  1 10:57:13 laptop kernel: usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Feb  1 10:57:13 laptop kernel: usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Feb  1 10:57:13 laptop kernel: hub 2-1:1.0: USB hub found
Feb  1 10:57:13 laptop kernel: hub 2-1:1.0: 6 ports detected
Feb  1 10:57:13 laptop kernel: usb 1-1.3: new high-speed USB device number 3 using ehci_hcd
Feb  1 10:57:13 laptop kernel: usb 1-1.3: New USB device found, idVendor=04f2, idProduct=b213
Feb  1 10:57:13 laptop kernel: usb 1-1.3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
Feb  1 10:57:13 laptop kernel: usb 1-1.3: Product: FJ Camera
Feb  1 10:57:13 laptop kernel: usb 1-1.3: Manufacturer: Sonix Technology Co., Ltd.
Feb  1 10:57:13 laptop kernel: usb 1-1.3: SerialNumber: SN0001
Feb  1 10:57:13 laptop kernel: uvcvideo: Found UVC 1.00 device FJ Camera (04f2:b213)
Feb  1 10:57:14 laptop kernel: input: FJ Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input5
Feb  1 10:57:14 laptop kernel: usb 2-1.1: new low-speed USB device number 3 using ehci_hcd
Feb  1 10:57:14 laptop kernel: usb 2-1.1: New USB device found, idVendor=0461, idProduct=4d20
Feb  1 10:57:14 laptop kernel: usb 2-1.1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
Feb  1 10:57:14 laptop kernel: usb 2-1.1: Product: USB Optical Mouse
Feb  1 10:57:14 laptop kernel: input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input6
Feb  1 10:57:14 laptop kernel: hid-generic 0003:0461:4D20.0001: input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1.1/input0
Feb  1 10:57:14 laptop kernel: usb 2-1.6: new high-speed USB device number 4 using ehci_hcd
Feb  1 10:57:14 laptop kernel: usb 2-1.6: New USB device found, idVendor=0bda, idProduct=0138
Feb  1 10:57:14 laptop kernel: usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb  1 10:57:14 laptop kernel: usb 2-1.6: Product: USB2.0-CRW
Feb  1 10:57:14 laptop kernel: usb 2-1.6: Manufacturer: Generic
Feb  1 10:57:14 laptop kernel: usb 2-1.6: SerialNumber: 20090516388200000
Feb  1 10:57:14 laptop kernel: EXT3-fs (sda5): using internal journal
Feb  1 10:57:14 laptop kernel: <30>udevd[93]: starting version 182
Feb  1 10:57:15 laptop kernel: microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x26
Feb  1 10:57:15 laptop kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Feb  1 10:57:15 laptop kernel: r8169 0000:07:00.0 eth0: RTL8168e/8111e at 0xf853a000, 5c:9a:d8:5c:63:31, XID 0c200000 IRQ 17
Feb  1 10:57:15 laptop kernel: r8169 0000:07:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
Feb  1 10:57:15 laptop kernel: input: Fujitsu FUJ02B1 as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/FUJ02B1:00/input/input7
Feb  1 10:57:15 laptop kernel: fujitsu_laptop: ACPI: Fujitsu FUJ02B1 [FJEX] (on)
Feb  1 10:57:15 laptop kernel: input: Fujitsu FUJ02E3 as /devices/LNXSYSTM:00/LNXSYBUS:00/FUJ02E3:00/input/input8
Feb  1 10:57:15 laptop kernel: fujitsu_laptop: ACPI: Fujitsu FUJ02E3 [FEXT] (on)
Feb  1 10:57:15 laptop kernel: fujitsu_laptop: BTNI: [0x80001]
Feb  1 10:57:15 laptop kernel: fujitsu_laptop: driver 0.6.0 successfully loaded
Feb  1 10:57:15 laptop kernel: hda_codec: ALC269VB: SKU not ready 0x90970130
Feb  1 10:57:16 laptop kernel: microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x26
Feb  1 10:57:16 laptop kernel: microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x26
Feb  1 10:57:16 laptop kernel: microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x26
Feb  1 10:57:16 laptop kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Feb  1 10:57:16 laptop kernel: Initializing USB Mass Storage driver...
Feb  1 10:57:16 laptop kernel: scsi6 : usb-storage 2-1.6:1.0
Feb  1 10:57:16 laptop kernel: usbcore: registered new interface driver usb-storage
Feb  1 10:57:16 laptop kernel: USB Mass Storage support registered.
Feb  1 10:57:16 laptop kernel: scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
Feb  1 10:57:16 laptop kernel: sd 6:0:0:0: [sdb] Attached SCSI removable disk
Feb  1 10:57:16 laptop kernel: r8169 0000:07:00.0 eth0: link down
Feb  1 10:57:16 laptop kernel: r8169 0000:07:00.0 eth0: link down
Feb  1 10:57:16 laptop kernel: kjournald starting.  Commit interval 5 seconds
Feb  1 10:57:16 laptop kernel: EXT3-fs (sda8): warning: maximal mount count reached, running e2fsck is recommended
Feb  1 10:57:16 laptop kernel: EXT3-fs (sda8): using internal journal
Feb  1 10:57:16 laptop kernel: EXT3-fs (sda8): mounted filesystem with writeback data mode
Feb  1 10:57:16 laptop kernel: kjournald starting.  Commit interval 5 seconds
Feb  1 10:57:17 laptop kernel: EXT3-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
Feb  1 10:57:17 laptop kernel: EXT3-fs (sda9): using internal journal
Feb  1 10:57:17 laptop kernel: EXT3-fs (sda9): mounted filesystem with writeback data mode
Feb  1 10:57:17 laptop kernel: kjournald starting.  Commit interval 5 seconds
Feb  1 10:57:17 laptop kernel: EXT3-fs (sda10): using internal journal
Feb  1 10:57:17 laptop kernel: EXT3-fs (sda10): mounted filesystem with writeback data mode
Feb  1 10:57:17 laptop kernel: Adding 8191996k swap on /dev/sda6.  Priority:-1 extents:1 across:8191996k 
Feb  1 10:57:17 laptop kernel: r8169 0000:07:00.0 eth0: link up
Feb  1 10:57:17 laptop kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Feb  1 11:03:40 laptop kernel: psmouse serio2: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa44000/0xa0000, board id: 3655, fw id: 554713
Feb  1 11:03:40 laptop kernel: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input9
Feb  1 11:03:46 laptop kernel: usb 2-1.1: USB disconnect, device number 3
Feb  1 11:03:53 laptop kernel: Warning: Processor Platform Limit event detected, but not handled.
Feb  1 11:03:53 laptop kernel: Consider compiling CPUfreq support into your kernel.
Feb  1 11:03:54 laptop kernel: r8169 0000:07:00.0 eth0: link down
Feb  1 11:04:03 laptop kernel: pciehp 0000:00:1c.3:pcie04: pcie_isr: intr_loc 8
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: Presence/Notify input change
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: Surprise Removal
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: check_link_active: lnk_status = 7011
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: pciehp_check_link_status: lnk_status = 7011
Feb  1 11:04:04 laptop kernel: pci 0000:02:00.0: [14f1:8852] type 00 class 0x040000
Feb  1 11:04:04 laptop kernel: pci 0000:02:00.0: reg 10: [mem 0x00000000-0x001fffff 64bit]
Feb  1 11:04:04 laptop kernel: pci 0000:02:00.0: supports D1 D2
Feb  1 11:04:04 laptop kernel: pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
Feb  1 11:04:04 laptop kernel: pci 0000:02:00.0: BAR 0: assigned [mem 0xf0e00000-0xf0ffffff 64bit]
Feb  1 11:04:04 laptop kernel: pcieport 0000:00:1c.3: PCI bridge to [bus 02-06]
Feb  1 11:04:04 laptop kernel: pcieport 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
Feb  1 11:04:04 laptop kernel: pcieport 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
Feb  1 11:04:04 laptop kernel: pcieport 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
Feb  1 11:04:04 laptop kernel: pci 0000:02:00.0: no hotplug settings from platform
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: pcie_isr: intr_loc 8
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: Presence/Notify input change
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: Card not present on Slot(3)
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: Surprise Removal
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: Disabling domain:bus:device=0000:02:00
Feb  1 11:04:04 laptop kernel: pciehp 0000:00:1c.3:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:02:00
Feb  1 11:04:05 laptop kernel: pciehp 0000:00:1c.3:pcie04: pcie_isr: intr_loc 8
Feb  1 11:04:05 laptop kernel: pciehp 0000:00:1c.3:pcie04: Presence/Notify input change
Feb  1 11:04:05 laptop kernel: pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
Feb  1 11:04:05 laptop kernel: pciehp 0000:00:1c.3:pcie04: Surprise Removal
Feb  1 11:04:05 laptop kernel: pciehp 0000:00:1c.3:pcie04: check_link_active: lnk_status = 7011
Feb  1 11:04:05 laptop kernel: pciehp 0000:00:1c.3:pcie04: pciehp_check_link_status: lnk_status = 7011
Feb  1 11:04:05 laptop kernel: pci 0000:02:00.0: [14f1:8852] type 00 class 0x040000
Feb  1 11:04:05 laptop kernel: pci 0000:02:00.0: reg 10: [mem 0x00000000-0x001fffff 64bit]
Feb  1 11:04:05 laptop kernel: pci 0000:02:00.0: supports D1 D2
Feb  1 11:04:05 laptop kernel: pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
Feb  1 11:04:05 laptop kernel: pci 0000:02:00.0: BAR 0: assigned [mem 0xf0e00000-0xf0ffffff 64bit]
Feb  1 11:04:05 laptop kernel: pcieport 0000:00:1c.3: PCI bridge to [bus 02-06]
Feb  1 11:04:05 laptop kernel: pcieport 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
Feb  1 11:04:05 laptop kernel: pcieport 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
Feb  1 11:04:05 laptop kernel: pcieport 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
Feb  1 11:04:05 laptop kernel: pci 0000:02:00.0: no hotplug settings from platform

Feb  1 11:06:29 laptop kernel: cx23885 driver version 0.0.3 loaded
Feb  1 11:06:29 laptop kernel: cx23885 0000:02:00.0: enabling device (0000 -> 0002)
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_dev_setup() Memory configured for PCIe bridge type 885
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_init_tsport(portno=2)
Feb  1 11:06:29 laptop kernel: btcx: riscmem alloc [1] dma=3143b000 cpu=f143b000 size=64
Feb  1 11:06:29 laptop kernel: CORE cx23885[0]: subsystem: 0070:8010, board: Hauppauge WinTV-HVR1400 [card=9,autodetected]
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_pci_quirks()
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0 tuner_bus = 0
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_reset()
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Configuring channel [VID A]
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch2]
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Configuring channel [TS1 B]
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch4]
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch5]
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Configuring channel [TS2 C]
Feb  1 11:06:29 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Configuring channel [TV Audio]
Feb  1 11:06:30 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch8]
Feb  1 11:06:30 laptop kernel: cx23885[0]: cx23885_sram_channel_setup() Erasing channel [ch9]
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: full 256-byte eeprom dump:
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 00: 20 00 13 00 00 00 00 00 2c 00 05 00 70 00 10 80
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 10: 50 03 05 00 04 80 00 08 0c 03 05 80 0e 01 00 00
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 80: 84 09 00 04 20 77 00 40 2a 5b 39 f0 73 05 27 00
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: 90: 84 08 00 06 93 38 01 00 91 29 89 72 07 70 73 09
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: a0: 21 7f 73 0a f4 97 72 0b 13 72 0e 01 72 10 01 72
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: b0: 11 ff 79 0e 00 00 00 00 00 00 00 00 00 00 00 00
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: c0: 84 09 00 04 20 77 00 40 2a 5b 39 f0 73 05 27 00
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: d0: 84 08 00 06 93 38 01 00 91 29 89 72 07 70 73 09
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: e0: 21 7f 73 0a f4 97 72 0b 13 72 0e 01 72 10 01 72
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: f0: 11 ff 79 0e 00 00 00 00 00 00 00 00 00 00 00 00
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [04] + 8 bytes: 20 77 00 40 2a 5b 39 f0
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [05] + 2 bytes: 27 00
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [06] + 7 bytes: 93 38 01 00 91 29 89
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [07] + 1 bytes: 70
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [09] + 2 bytes: 21 7f
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [0a] + 2 bytes: f4 97
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [0b] + 1 bytes: 13
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [0e] + 1 bytes: 01
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [10] + 1 bytes: 01
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Not sure what to do with tag [10]
Feb  1 11:06:30 laptop kernel: tveeprom 7-0050: Tag [11] + 1 bytes: ff
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: Not sure what to do with tag [11]
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: Hauppauge model 80019, rev B2F1, serial# 3758890
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: MAC address is 00:0d:fe:39:5b:2a
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: tuner model is Xceive XC3028L (idx 151, type 4)
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: audio processor is CX23885 (idx 39)
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: decoder processor is CX23885 (idx 33)
Feb  1 11:06:31 laptop kernel: tveeprom 7-0050: has radio
Feb  1 11:06:31 laptop kernel: cx23885[0]: hauppauge eeprom: model=80019
Feb  1 11:06:31 laptop kernel: cx23885_dvb_register() allocating 1 frontend(s)
Feb  1 11:06:31 laptop kernel: cx23885[0]: cx23885 based dvb card
Feb  1 11:06:31 laptop kernel: DiB7000P: checking demod on I2C address: 18 (12)
Feb  1 11:06:31 laptop kernel: DiB7000P: gpio dir: ffff: val: 0, pwm_pos: ffff
Feb  1 11:06:31 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:06:31 laptop kernel: DiB7000P: using default timf
Feb  1 11:06:31 laptop kernel: xc2028: Xcv2028/3028 init called!
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: creating new instance
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: type set to XCeive xc2028/xc3028 tuner
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: xc2028_set_config called
Feb  1 11:06:31 laptop kernel: DVB: registering new adapter (cx23885[0])
Feb  1 11:06:31 laptop kernel: cx23885 0000:02:00.0: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
Feb  1 11:06:31 laptop kernel: cx23885_dev_checkrevision() Hardware revision = 0xb0
Feb  1 11:06:31 laptop kernel: cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xf0e00000
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: request_firmware_nowait(): OK
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: load_all_firmwares called
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: Loading 81 firmware images from xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: Reading firmware type BASE F8MHZ (3), id 0, size=9144.
Feb  1 11:06:31 laptop kernel: xc2028 8-0064: Reading firmware type BASE F8MHZ MTS (7), id 0, size=9030.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type BASE FM (401), id 0, size=9054.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type BASE FM INPUT1 (c01), id 0, size=9068.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type BASE (1), id 0, size=9132.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type BASE MTS (5), id 0, size=9006.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 7, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 7, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 7, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 7, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 7, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id e0, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id e0, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id e0, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id e0, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 200000, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 200000, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 4000000, size=161.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 4000000, size=169.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2620 DTV7 (88), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2633 DTV7 (90), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2620 DTV78 (108), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2633 DTV78 (110), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2620 DTV8 (208), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type D2633 DTV8 (210), id 0, size=149.
Feb  1 11:06:32 laptop kernel: xc2028 8-0064: Reading firmware type FM (400), id 0, size=135.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 10, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 10, size=169.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 400000, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 800000, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 8000, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type LCD (1000), id 8000, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type LCD NOGD (3000), id 8000, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id 8000, size=169.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type (0), id b700, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type LCD (1000), id b700, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type LCD NOGD (3000), id b700, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type (0), id 2000, size=161.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type MTS (4), id b700, size=169.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type MTS LCD (1004), id b700, size=169.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4560 (62000300), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type DTV6 QAM DTV7 ZARLINK456 SCODE HAS_IF_4760 (620000e0), id 0, size=192.
Feb  1 11:06:33 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id 7, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type DTV7 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000280), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_5640 (60000000), id 7, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_5740 (60000000), id 7, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id 4c000f0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id 40000e0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_6600 (60000000), id e0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id e0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
Feb  1 11:06:34 laptop kernel: xc2028 8-0064: Firmware files loaded.

Feb  1 11:08:00 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: should set frequency 746000 kHz
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:00 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:01 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:02 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:03 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:04 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:05 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:06 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:07 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:07 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:07 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:07 laptop kernel: DiB7000P: WBD: ref: 2867, sel: 0, active: 0, alpha: 0
Feb  1 11:08:07 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:08:07 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:07 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:07 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:08:08 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:08:08 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:08:08 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:08:08 laptop kernel: xc2028 8-0064: should set frequency 746000 kHz
Feb  1 11:08:08 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:09 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:10 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:11 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:12 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:13 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:14 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:15 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:16 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:16 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:16 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:16 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:08:16 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:16 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:16 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:08:17 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: should set frequency 746000 kHz
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:17 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:18 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:19 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:20 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:21 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:22 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:23 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:24 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:24 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:08:24 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:25 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:25 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:08:26 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: should set frequency 746000 kHz
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:26 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:27 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:28 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:29 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:30 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:31 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:32 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:33 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:33 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:33 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:33 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:33 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:33 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:33 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:08:33 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:33 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:33 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:08:34 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:08:34 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:08:34 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:08:34 laptop kernel: xc2028 8-0064: should set frequency 770000 kHz
Feb  1 11:08:34 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:08:34 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:35 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:36 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:37 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:38 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:39 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:40 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:41 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:42 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:42 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:42 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:42 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:08:42 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:42 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:42 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:08:43 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: should set frequency 770000 kHz
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:43 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:44 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:45 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:46 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:47 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:48 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:49 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:50 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:51 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:08:51 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:51 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:51 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:08:52 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: should set frequency 770000 kHz
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:52 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:53 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:54 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:55 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:56 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:57 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:58 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:08:59 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:08:59 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:08:59 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:08:59 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:08:59 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:59 laptop kernel: DiB7000P: using default timf
Feb  1 11:08:59 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:09:00 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:09:00 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:09:00 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:09:00 laptop kernel: xc2028 8-0064: should set frequency 770000 kHz
Feb  1 11:09:00 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:01 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:02 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:03 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:04 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:05 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:06 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:07 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:08 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:08 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:08 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:08 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:09:08 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:08 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:08 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:09:09 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: should set frequency 778000 kHz
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:09 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:10 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:11 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:12 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:13 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:14 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:15 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:16 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:16 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:09:16 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:17 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:17 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:09:18 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: should set frequency 778000 kHz
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:18 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:19 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:19 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:19 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:19 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:19 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:19 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:19 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:20 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:21 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:22 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:23 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:24 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:25 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:25 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:25 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:25 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:25 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:25 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:25 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:09:25 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:25 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:25 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:09:26 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:09:26 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:09:26 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:09:26 laptop kernel: xc2028 8-0064: should set frequency 778000 kHz
Feb  1 11:09:26 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:09:26 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:26 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:26 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:27 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:28 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:29 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:30 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:31 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:32 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:33 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:34 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:34 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:34 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:34 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:09:34 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:34 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:34 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:09:35 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: should set frequency 778000 kHz
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:35 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:36 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:37 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:38 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:39 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:40 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:41 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:42 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:43 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:09:43 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:43 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:43 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:09:44 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: should set frequency 794000 kHz
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:44 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:45 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:46 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:47 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:48 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:49 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:50 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:51 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:51 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:51 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:51 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:09:51 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:51 laptop kernel: DiB7000P: using default timf
Feb  1 11:09:51 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:09:52 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:09:52 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:09:52 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:09:52 laptop kernel: xc2028 8-0064: should set frequency 794000 kHz
Feb  1 11:09:52 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:53 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:54 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:55 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:56 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:57 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:58 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:09:59 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:00 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:00 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:00 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:00 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:10:00 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:00 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:00 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:10:01 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: should set frequency 794000 kHz
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:01 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:02 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:03 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:04 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:05 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:06 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:07 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:08 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:08 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:10:08 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:09 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:09 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:10:10 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: should set frequency 794000 kHz
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:10 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:11 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:12 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:13 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:14 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:15 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:16 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:17 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:17 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:17 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:17 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:17 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:17 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:17 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:10:17 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:17 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:17 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:10:18 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:10:18 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:10:18 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:10:18 laptop kernel: xc2028 8-0064: should set frequency 801833 kHz
Feb  1 11:10:18 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:10:18 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:18 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:18 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:19 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:20 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:21 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:22 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:23 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:23 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:23 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:23 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:23 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:23 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:23 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:24 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:25 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:26 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:26 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:26 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:26 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:10:26 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:26 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:26 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:10:27 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:10:27 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:10:27 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:10:27 laptop kernel: xc2028 8-0064: should set frequency 801833 kHz
Feb  1 11:10:27 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:10:27 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:27 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:28 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:29 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:30 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:31 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:32 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:33 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:34 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:35 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:35 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:10:35 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:35 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:35 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:10:36 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: should set frequency 801833 kHz
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:36 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:37 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:37 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:37 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:37 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:37 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:38 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:39 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:40 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:41 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:42 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:42 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:42 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:42 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:42 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:42 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:42 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:43 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:43 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:10:43 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:43 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:43 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:10:44 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: xc2028_set_params called
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: generic_set_freq called
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: should set frequency 801833 kHz
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: check_firmware called
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:45 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:46 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:47 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:48 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:49 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:50 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Retrying firmware load
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: checking firmware, user requested type=F8MHZ D2633 DTV8 (212), id 0000000000000000, int_freq 5200, scode_nr 0
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: load_firmware called
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: seek_firmware called, want type=BASE F8MHZ D2633 DTV8 (213), id 0000000000000000.
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Found firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:51 laptop kernel: xc2028 8-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb  1 11:10:52 laptop kernel: xc2028 8-0064: i2c output error: rc = -5 (should be 4)
Feb  1 11:10:52 laptop kernel: xc2028 8-0064: -5 returned from send
Feb  1 11:10:52 laptop kernel: xc2028 8-0064: Error -22 while loading base firmware
Feb  1 11:10:52 laptop kernel: DiB7000P: setting a frequency offset of 0kHz internal freq = 60000 invert = 1
Feb  1 11:10:52 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:52 laptop kernel: DiB7000P: using default timf
Feb  1 11:10:52 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 7
Feb  1 11:10:53 laptop kernel: xc2028 8-0064: Putting xc2028/3028 into poweroff mode.
Feb  1 11:10:53 laptop kernel: xc2028 8-0064: Error on line 1293: -5
Feb  1 11:10:53 laptop kernel: DiB7000P: setting output mode for demod f212c000 to 0

--------------020308010408030703090401--
