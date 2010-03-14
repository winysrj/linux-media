Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.aster.pl ([212.76.33.56]:42057 "EHLO smtp2.aster.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752732Ab0CNTek (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 15:34:40 -0400
Message-ID: <4B9D3A4A.7000803@aster.pl>
Date: Sun, 14 Mar 2010 20:34:34 +0100
From: Daro <ghost-rider@aster.pl>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135   variants
References: <E1Nl2po-000877-Di@services.gcu-squad.org>	<20100312103835.79b26455@hyperion.delvare>	<4B9C4C13.1010801@aster.pl> <20100314092635.63c4a1b3@hyperion.delvare>
In-Reply-To: <20100314092635.63c4a1b3@hyperion.delvare>
Content-Type: multipart/mixed;
 boundary="------------050500070502000907090604"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050500070502000907090604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

W dniu 14.03.2010 09:26, Jean Delvare pisze:
> Hi Daro,
>
> On Sun, 14 Mar 2010 03:38:11 +0100, Daro wrote:
>    
>> Hi Jean,
>>
>> I am back and ready to go :)
>> As I am not much experienced Linux user I would apprieciate some more
>> details:
>>
>> I have few linux kernels installed; which one should I test or it does
>> not matter?
>> 2.6.31-14-generic
>> 2.6.31-16-generic
>> 2.6.31-17-generic
>> 2.6.31-19-generic
>> 2.6.31-20-generic
>>
>> and one I compiled myself
>> 2.6.32.2
>>
>> I assume that to proceed with a test I should patch the certain version
>> of kernel and compile it or could it be done other way?
>>      
> It will be easier with the kernel you compiled yourself. First of all,
> download the patch from:
> http://patchwork.kernel.org/patch/75883/raw/
>
> Then, move to the source directory of your 2.6.32.2 kernel and apply
> the patch:
>
> $ cd ~/src/linux-2.6.32
> $ patch -p2<  ~/download/saa7134-Fix-IR-support-of-some-ASUS-TV-FM-7135-variants.patch
>
> Adjust the path in each command to match your own setup. Then just
> build and install the kernel:
>
> $ make
> $ sudo make modules_install
> $ sudo make install
>
> Or whatever method you use to install your self-compiled kernels. Then
> reboot to kernel 2.6.32.2 and test that the remote control works even
> when _not_ passing any card parameter to the driver.
>
> If you ever need to remove the patch, use:
>
> $ cd ~/src/linux-2.6.32
> $ patch -p2 -R<  ~/download/saa7134-Fix-IR-support-of-some-ASUS-TV-FM-7135-variants.patch
>
> I hope my instructions are clear enough, if you have any problem, just
> ask.
>
> Thanks,
>    

Hi Jean!

It works!
dmesg output is attached.
However I will have to go back to "generic" kernel as under my 
"self-built" kernels fglrx driver stops working and I did not manage to 
solve it :(
Or maybe you could give me a hint what to do with it?

Best regards
Daro

--------------050500070502000907090604
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32.2 (root@DOMOWY) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #2 SMP Sun Mar 14 14:11:25 CET 2010
[    0.000000] Command line: root=/dev/mapper/isw_bgccbabfgf_SYSTEM2 ro  
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000096c00 (usable)
[    0.000000]  BIOS-e820: 0000000000096c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff80000 (usable)
[    0.000000]  BIOS-e820: 000000007ff80000 - 000000007ff8e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff8e000 - 000000007ffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffd0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x7ff80 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000096c00 (usable)
[    0.000000]  modified: 0000000000096c00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007ff80000 (usable)
[    0.000000]  modified: 000000007ff80000 - 000000007ff8e000 (ACPI data)
[    0.000000]  modified: 000000007ff8e000 - 000000007ffd0000 (ACPI NVS)
[    0.000000]  modified: 000000007ffd0000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007ff80000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007ff80000 page 4k
[    0.000000] kernel direct mapping tables up to 7ff80000 @ 10000-14000
[    0.000000] RAMDISK: 33d1c000 - 37fef0bf
[    0.000000] ACPI: RSDP 00000000000fbbf0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 000000007ff80000 0003C (v01 A_M_I_ OEMRSDT  12000801 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007ff80200 00084 (v02 A_M_I_ OEMFACP  12000801 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007ff80440 09FDD (v01  A1032 A1032001 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 000000007ff8e000 00040
[    0.000000] ACPI: APIC 000000007ff80390 0006C (v01 A_M_I_ OEMAPIC  12000801 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007ff80400 0003C (v01 A_M_I_ OEMMCFG  12000801 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007ff8e040 00089 (v01 A_M_I_ AMI_OEM  12000801 MSFT 00000097)
[    0.000000] ACPI: HPET 000000007ff8a420 00038 (v01 A_M_I_ OEMHPET  12000801 MSFT 00000097)
[    0.000000] ACPI: OSFR 000000007ff8a460 000B0 (v01 A_M_I_ OEMOSFR  12000801 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007ff80000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007ff80000
[    0.000000]   NODE_DATA [0000000000012000 - 0000000000016fff]
[    0.000000]   bootmap [0000000000017000 -  0000000000026fef] pages 10
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 007ff80000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00019f82c4]    TEXT DATA BSS ==> [0001000000 - 00019f82c4]
[    0.000000]   #3 [0033d1c000 - 0037fef0bf]          RAMDISK ==> [0033d1c000 - 0037fef0bf]
[    0.000000]   #4 [0000096c00 - 0000100000]    BIOS reserved ==> [0000096c00 - 0000100000]
[    0.000000]   #5 [00019f9000 - 00019f9278]              BRK ==> [00019f9000 - 00019f9278]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880001e00000-ffff8800039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000096
[    0.000000]     0: 0x00000100 -> 0x0007ff80
[    0.000000] On node 0 totalpages: 524038
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 110 pages reserved
[    0.000000]   DMA zone: 3808 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7111 pages used for memmap
[    0.000000]   DMA32 zone: 512953 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000096000 - 0000000000097000
[    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ee00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880003a00000 s91288 r8192 d23400 u524288
[    0.000000] pcpu-alloc: s91288 r8192 d23400 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516761
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/mapper/isw_bgccbabfgf_SYSTEM2 ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1988188k/2096640k available (5351k kernel code, 488k absent, 107964k reserved, 3059k data, 688k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 20971520 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2330.878 MHz processor.
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4661.75 BogoMIPS (lpj=23308780)
[    0.010056] Security Framework initialized
[    0.010088] SELinux:  Disabled at boot.
[    0.010272] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.011047] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.011479] Mount-cache hash table entries: 256
[    0.011631] Initializing cgroup subsys ns
[    0.011663] Initializing cgroup subsys cpuacct
[    0.011693] Initializing cgroup subsys memory
[    0.011727] Initializing cgroup subsys freezer
[    0.011755] Initializing cgroup subsys net_cls
[    0.011800] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.011852] CPU: L2 cache: 2048K
[    0.011881] CPU 0/0x0 -> Node 0
[    0.011910] CPU: Physical Processor ID: 0
[    0.011938] CPU: Processor Core ID: 0
[    0.011967] mce: CPU supports 6 MCE banks
[    0.012001] CPU0: Thermal monitoring enabled (TM1)
[    0.012032] using mwait in idle threads.
[    0.012060] Performance Events: Core2 events, Intel PMU driver.
[    0.012137] ... version:                2
[    0.012165] ... bit width:              40
[    0.012194] ... generic registers:      2
[    0.012222] ... value mask:             000000ffffffffff
[    0.012251] ... max period:             000000007fffffff
[    0.012279] ... fixed-purpose events:   3
[    0.012307] ... event mask:             0000000700000003
[    0.014711] ACPI: Core revision 20090903
[    0.030048] Setting APIC routing to flat
[    0.030376] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.135645] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz stepping 07
[    0.140000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4661.96 BogoMIPS (lpj=23309826)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 2048K
[    0.010000] CPU 1/0x1 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU1: Thermal monitoring enabled (TM1)
[    0.290066] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz stepping 07
[    0.290364] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.300090] Booting processor 2 APIC 0x2 ip 0x6000
[    0.010000] Initializing CPU#2
[    0.010000] Calibrating delay using timer specific routine.. 4661.98 BogoMIPS (lpj=23309932)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 2048K
[    0.010000] CPU 2/0x2 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 2
[    0.010000] CPU2: Thermal monitoring enabled (TM1)
[    0.460111] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz stepping 07
[    0.460410] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.470063] Booting processor 3 APIC 0x3 ip 0x6000
[    0.010000] Initializing CPU#3
[    0.010000] Calibrating delay using timer specific routine.. 4661.98 BogoMIPS (lpj=23309902)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 2048K
[    0.010000] CPU 3/0x3 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 3
[    0.010000] CPU3: Thermal monitoring enabled (TM1)
[    0.630062] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz stepping 07
[    0.630360] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.640009] Brought up 4 CPUs
[    0.640042] Total of 4 processors activated (18647.68 BogoMIPS).
[    0.641281] CPU0 attaching sched-domain:
[    0.641284]  domain 0: span 0-1 level MC
[    0.641286]   groups: 0 1
[    0.641290]   domain 1: span 0-3 level CPU
[    0.641292]    groups: 0-1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
[    0.641299] CPU1 attaching sched-domain:
[    0.641300]  domain 0: span 0-1 level MC
[    0.641302]   groups: 1 0
[    0.641306]   domain 1: span 0-3 level CPU
[    0.641308]    groups: 0-1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
[    0.641313] CPU2 attaching sched-domain:
[    0.641314]  domain 0: span 2-3 level MC
[    0.641317]   groups: 2 3
[    0.641320]   domain 1: span 0-3 level CPU
[    0.641322]    groups: 2-3 (cpu_power = 2048) 0-1 (cpu_power = 2048)
[    0.641327] CPU3 attaching sched-domain:
[    0.641328]  domain 0: span 2-3 level MC
[    0.641330]   groups: 3 2
[    0.641333]   domain 1: span 0-3 level CPU
[    0.641336]    groups: 2-3 (cpu_power = 2048) 0-1 (cpu_power = 2048)
[    0.641470] regulator: core version 0.5
[    0.641470] Time: 20:15:57  Date: 03/14/10
[    0.641470] NET: Registered protocol family 16
[    0.641470] ACPI: bus type pci registered
[    0.641470] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.641470] PCI: Not using MMCONFIG.
[    0.641470] PCI: Using configuration type 1 for base access
[    0.641557] bio: create slab <bio-0> at 0
[    0.641557] ACPI: EC: Look up EC in DSDT
[    0.643160] ACPI: Executed 1 blocks of module-level executable AML code
[    0.656812] ACPI: Interpreter enabled
[    0.656843] ACPI: (supports S0 S1 S3 S4 S5)
[    0.657002] ACPI: Using IOAPIC for interrupt routing
[    0.657077] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.659552] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.662396] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.670091] ACPI Warning: Incorrect checksum in table [OEMB] - 2F, should be 2E (20090903/tbutils-314)
[    0.670303] ACPI: No dock devices found.
[    0.670463] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.670580] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.670610] pci 0000:00:01.0: PME# disabled
[    0.670698] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
[    0.670757] pci 0000:00:1a.1: reg 20 io port: [0xa880-0xa89f]
[    0.670815] pci 0000:00:1a.2: reg 20 io port: [0xac00-0xac1f]
[    0.670877] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe7ffc00-0xfe7fffff]
[    0.670924] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.670956] pci 0000:00:1a.7: PME# disabled
[    0.671017] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe7f8000-0xfe7fbfff]
[    0.671052] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.671083] pci 0000:00:1b.0: PME# disabled
[    0.671161] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.671192] pci 0000:00:1c.0: PME# disabled
[    0.671275] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.671306] pci 0000:00:1c.4: PME# disabled
[    0.671385] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.671416] pci 0000:00:1c.5: PME# disabled
[    0.671489] pci 0000:00:1d.0: reg 20 io port: [0xa080-0xa09f]
[    0.671547] pci 0000:00:1d.1: reg 20 io port: [0xa400-0xa41f]
[    0.671606] pci 0000:00:1d.2: reg 20 io port: [0xa480-0xa49f]
[    0.671668] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe7ff800-0xfe7ffbff]
[    0.671715] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.671746] pci 0000:00:1d.7: PME# disabled
[    0.671880] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.671915] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.671946] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.672034] pci 0000:00:1f.2: reg 10 io port: [0x9c00-0x9c07]
[    0.672039] pci 0000:00:1f.2: reg 14 io port: [0x9880-0x9883]
[    0.672043] pci 0000:00:1f.2: reg 18 io port: [0x9800-0x9807]
[    0.672048] pci 0000:00:1f.2: reg 1c io port: [0x9480-0x9483]
[    0.672053] pci 0000:00:1f.2: reg 20 io port: [0x9400-0x941f]
[    0.672058] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe7fe800-0xfe7fefff]
[    0.672084] pci 0000:00:1f.2: PME# supported from D3hot
[    0.672114] pci 0000:00:1f.2: PME# disabled
[    0.672165] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe7ff400-0xfe7ff4ff]
[    0.672177] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.672217] pci 0000:01:00.0: reg 10 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.672224] pci 0000:01:00.0: reg 18 64bit mmio: [0xfe8e0000-0xfe8effff]
[    0.672229] pci 0000:01:00.0: reg 20 io port: [0xb000-0xb0ff]
[    0.672237] pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfe8c0000-0xfe8dffff]
[    0.672253] pci 0000:01:00.0: supports D1 D2
[    0.672280] pci 0000:01:00.1: reg 10 64bit mmio: [0xfe8fc000-0xfe8fffff]
[    0.672310] pci 0000:01:00.1: supports D1 D2
[    0.672349] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.672352] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.672355] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.672394] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.672476] pci 0000:03:00.0: reg 24 32bit mmio: [0xfeafe000-0xfeafffff]
[    0.672484] pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfeae0000-0xfeaeffff]
[    0.672513] pci 0000:03:00.0: PME# supported from D3hot
[    0.672545] pci 0000:03:00.0: PME# disabled
[    0.672621] pci 0000:03:00.1: reg 10 io port: [0xdc00-0xdc07]
[    0.672629] pci 0000:03:00.1: reg 14 io port: [0xd880-0xd883]
[    0.672637] pci 0000:03:00.1: reg 18 io port: [0xd800-0xd807]
[    0.672645] pci 0000:03:00.1: reg 1c io port: [0xd480-0xd483]
[    0.672654] pci 0000:03:00.1: reg 20 io port: [0xd400-0xd40f]
[    0.672736] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    0.672739] pci 0000:00:1c.4: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.672790] pci 0000:02:00.0: reg 10 64bit mmio: [0xfe9c0000-0xfe9fffff]
[    0.672797] pci 0000:02:00.0: reg 18 io port: [0xcc00-0xcc7f]
[    0.672850] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.672882] pci 0000:02:00.0: PME# disabled
[    0.672953] pci 0000:00:1c.5: bridge io port: [0xc000-0xcfff]
[    0.672957] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
[    0.672989] pci 0000:05:00.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
[    0.673030] pci 0000:05:00.0: supports D1 D2
[    0.673050] pci 0000:05:01.0: reg 10 32bit mmio: [0xfebe0000-0xfebeffff]
[    0.673056] pci 0000:05:01.0: reg 14 io port: [0xec00-0xec1f]
[    0.673109] pci 0000:05:03.0: reg 10 32bit mmio: [0xfebfe000-0xfebfefff]
[    0.673149] pci 0000:05:03.0: supports D1 D2
[    0.673151] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
[    0.673182] pci 0000:05:03.0: PME# disabled
[    0.673247] pci 0000:00:1e.0: transparent bridge
[    0.673277] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
[    0.673280] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.673308] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.673430] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.673486] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.673592] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.673655] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.673729] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.689199] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.689606] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.690023] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.690428] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.690832] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.691285] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.691688] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.692092] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.692484] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.692522] vgaarb: loaded
[    0.692637] SCSI subsystem initialized
[    0.692695] libata version 3.00 loaded.
[    0.692695] usbcore: registered new interface driver usbfs
[    0.692695] usbcore: registered new interface driver hub
[    0.692695] usbcore: registered new device driver usb
[    0.692695] ACPI: WMI: Mapper loaded
[    0.692695] PCI: Using ACPI for IRQ routing
[    0.692695] Bluetooth: Core ver 2.15
[    0.692695] NET: Registered protocol family 31
[    0.692695] Bluetooth: HCI device and connection manager initialized
[    0.692695] Bluetooth: HCI socket layer initialized
[    0.692695] NetLabel: Initializing
[    0.692695] NetLabel:  domain hash size = 128
[    0.692695] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.692695] NetLabel:  unlabeled traffic allowed by default
[    0.692695] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.692695] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.710004] Switching to clocksource tsc
[    0.711438] pnp: PnP ACPI init
[    0.711483] ACPI: bus type pnp registered
[    0.714327] pnp: PnP ACPI: found 15 devices
[    0.714357] ACPI: ACPI bus type pnp unregistered
[    0.714393] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.714428] system 00:06: ioport range 0x290-0x29f has been reserved
[    0.714460] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.714491] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.714521] system 00:07: ioport range 0x500-0x57f could not be reserved
[    0.714552] system 00:07: iomem range 0xfed08000-0xfed08fff has been reserved
[    0.714582] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.714613] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.714643] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.714676] system 00:0a: iomem range 0xffc00000-0xffefffff has been reserved
[    0.714710] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.714744] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.714776] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.714809] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.714840] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.714871] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.714901] system 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
[    0.714935] system 00:0e: iomem range 0xe0000000-0xffffffff could not be reserved
[    0.719642] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.719673] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.719704] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe8fffff
[    0.719734] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.719769] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.719799] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    0.719831] pci 0000:00:1c.0:   MEM window: 0x80000000-0x803fffff
[    0.719862] pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.719899] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    0.719942] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    0.719974] pci 0000:00:1c.4:   MEM window: 0xfea00000-0xfeafffff
[    0.720005] pci 0000:00:1c.4:   PREFETCH window: 0x00000080400000-0x000000805fffff
[    0.720041] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
[    0.720071] pci 0000:00:1c.5:   IO window: 0xc000-0xcfff
[    0.720103] pci 0000:00:1c.5:   MEM window: 0xfe900000-0xfe9fffff
[    0.720134] pci 0000:00:1c.5:   PREFETCH window: 0x00000080600000-0x000000807fffff
[    0.720170] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.720201] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
[    0.720232] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.720263] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.720299]   alloc irq_desc for 16 on node -1
[    0.720301]   alloc kstat_irqs on node -1
[    0.720305] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.720336] pci 0000:00:01.0: setting latency timer to 64
[    0.720342] pci 0000:00:1c.0: enabling device (0106 -> 0107)
[    0.720373]   alloc irq_desc for 17 on node -1
[    0.720375]   alloc kstat_irqs on node -1
[    0.720378] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.720409] pci 0000:00:1c.0: setting latency timer to 64
[    0.720416] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.720447] pci 0000:00:1c.4: setting latency timer to 64
[    0.720453] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.720484] pci 0000:00:1c.5: setting latency timer to 64
[    0.720490] pci 0000:00:1e.0: setting latency timer to 64
[    0.720493] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.720495] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.720498] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.720500] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe8fffff]
[    0.720502] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.720504] pci_bus 0000:04: resource 0 io:  [0x1000-0x1fff]
[    0.720506] pci_bus 0000:04: resource 1 mem: [0x80000000-0x803fffff]
[    0.720508] pci_bus 0000:04: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.720510] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.720512] pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.720514] pci_bus 0000:03: resource 2 pref mem [0x80400000-0x805fffff]
[    0.720516] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.720518] pci_bus 0000:02: resource 1 mem: [0xfe900000-0xfe9fffff]
[    0.720520] pci_bus 0000:02: resource 2 pref mem [0x80600000-0x807fffff]
[    0.720522] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.720524] pci_bus 0000:05: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.720526] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.720528] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.720556] NET: Registered protocol family 2
[    0.720698] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.721315] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.722806] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.723236] TCP: Hash tables configured (established 262144 bind 65536)
[    0.723266] TCP reno registered
[    0.723396] NET: Registered protocol family 1
[    0.723551] pci 0000:01:00.0: Boot video device
[    0.723608] Trying to unpack rootfs image as initramfs...
[    2.109666] Freeing initrd memory: 68428k freed
[    2.130980] Scanning for low memory corruption every 60 seconds
[    2.131138] audit: initializing netlink socket (disabled)
[    2.131181] type=2000 audit(1268597759.130:1): initialized
[    2.139357] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.140576] VFS: Disk quotas dquot_6.5.2
[    2.140651] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.141166] fuse init (API version 7.13)
[    2.141261] msgmni has been set to 4016
[    2.141512] alg: No test for stdrng (krng)
[    2.141547] io scheduler noop registered
[    2.141576] io scheduler anticipatory registered
[    2.141605] io scheduler deadline registered
[    2.141668] io scheduler cfq registered (default)
[    2.141793]   alloc irq_desc for 24 on node -1
[    2.141795]   alloc kstat_irqs on node -1
[    2.141802] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    2.141807] pcieport 0000:00:01.0: setting latency timer to 64
[    2.141883]   alloc irq_desc for 25 on node -1
[    2.141885]   alloc kstat_irqs on node -1
[    2.141891] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    2.141897] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.141995]   alloc irq_desc for 26 on node -1
[    2.141996]   alloc kstat_irqs on node -1
[    2.142002] pcieport 0000:00:1c.4: irq 26 for MSI/MSI-X
[    2.142009] pcieport 0000:00:1c.4: setting latency timer to 64
[    2.142099]   alloc irq_desc for 27 on node -1
[    2.142100]   alloc kstat_irqs on node -1
[    2.142106] pcieport 0000:00:1c.5: irq 27 for MSI/MSI-X
[    2.142112] pcieport 0000:00:1c.5: setting latency timer to 64
[    2.142186] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.142299] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.142440] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.142475] ACPI: Power Button [PWRB]
[    2.142546] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.142579] ACPI: Power Button [PWRF]
[    2.142903] processor LNXCPU:00: registered as cooling_device0
[    2.142961] processor LNXCPU:01: registered as cooling_device1
[    2.143019] processor LNXCPU:02: registered as cooling_device2
[    2.143079] processor LNXCPU:03: registered as cooling_device3
[    2.146430] Linux agpgart interface v0.103
[    2.146461] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.146576] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.146894] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.147743] brd: module loaded
[    2.148144] loop: module loaded
[    2.148228] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    2.148334] ahci 0000:00:1f.2: version 3.0
[    2.148344]   alloc irq_desc for 19 on node -1
[    2.148346]   alloc kstat_irqs on node -1
[    2.148351] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.148400]   alloc irq_desc for 28 on node -1
[    2.148402]   alloc kstat_irqs on node -1
[    2.148408] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    2.148439] ahci: SSS flag set, parallel bus scan disabled
[    2.148496] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
[    2.148531] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems sxs 
[    2.148566] ahci 0000:00:1f.2: setting latency timer to 64
[    2.240045] scsi0 : ahci
[    2.240147] scsi1 : ahci
[    2.240223] scsi2 : ahci
[    2.240300] scsi3 : ahci
[    2.240376] scsi4 : ahci
[    2.240938] scsi5 : ahci
[    2.241105] ata1: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe900 irq 28
[    2.241139] ata2: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe980 irq 28
[    2.241173] ata3: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea00 irq 28
[    2.241206] ata4: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea80 irq 28
[    2.241240] ata5: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb00 irq 28
[    2.241274] ata6: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb80 irq 28
[    2.241342] ahci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.260032] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.260067] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.260100] ahci 0000:03:00.0: setting latency timer to 64
[    2.260225] scsi6 : ahci
[    2.260305] scsi7 : ahci
[    2.260401] ata7: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe100 irq 16
[    2.260436] ata8: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe180 irq 16
[    2.260809] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    2.260842] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.260900] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    2.260952] scsi8 : pata_jmicron
[    2.261029] scsi9 : pata_jmicron
[    2.261569] ata9: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 17
[    2.261600] ata10: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 17
[    2.262103] Fixed MDIO Bus: probed
[    2.262160] PPP generic driver version 2.4.2
[    2.262277] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.262323]   alloc irq_desc for 18 on node -1
[    2.262324]   alloc kstat_irqs on node -1
[    2.262329] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.262369] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.262372] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.262435] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.262490] ehci_hcd 0000:00:1a.7: debug port 1
[    2.266413] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.266423] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe7ffc00
[    2.280008] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.280095] usb usb1: configuration #1 chosen from 1 choice
[    2.280146] hub 1-0:1.0: USB hub found
[    2.280179] hub 1-0:1.0: 6 ports detected
[    2.280256]   alloc irq_desc for 23 on node -1
[    2.280258]   alloc kstat_irqs on node -1
[    2.280261] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.280298] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.280300] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.280352] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.280405] ehci_hcd 0000:00:1d.7: debug port 1
[    2.284328] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.284338] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe7ff800
[    2.300008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.300081] usb usb2: configuration #1 chosen from 1 choice
[    2.300130] hub 2-0:1.0: USB hub found
[    2.300162] hub 2-0:1.0: 6 ports detected
[    2.300237] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.300279] uhci_hcd: USB Universal Host Controller Interface driver
[    2.300354] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.300388] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.300390] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.300442] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.300494] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
[    2.300584] usb usb3: configuration #1 chosen from 1 choice
[    2.300632] hub 3-0:1.0: USB hub found
[    2.300665] hub 3-0:1.0: 2 ports detected
[    2.300726]   alloc irq_desc for 21 on node -1
[    2.300728]   alloc kstat_irqs on node -1
[    2.300731] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.300765] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.300767] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.300821] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.300877] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
[    2.300962] usb usb4: configuration #1 chosen from 1 choice
[    2.301013] hub 4-0:1.0: USB hub found
[    2.301046] hub 4-0:1.0: 2 ports detected
[    2.301111] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.301144] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    2.301147] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    2.301207] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    2.301260] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000ac00
[    2.301346] usb usb5: configuration #1 chosen from 1 choice
[    2.301396] hub 5-0:1.0: USB hub found
[    2.301428] hub 5-0:1.0: 2 ports detected
[    2.301491] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.301524] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.301526] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.301576] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    2.301628] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
[    2.301714] usb usb6: configuration #1 chosen from 1 choice
[    2.301762] hub 6-0:1.0: USB hub found
[    2.301794] hub 6-0:1.0: 2 ports detected
[    2.301859] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.301892] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.301895] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.301946] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    2.302002] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
[    2.302090] usb usb7: configuration #1 chosen from 1 choice
[    2.302138] hub 7-0:1.0: USB hub found
[    2.302170] hub 7-0:1.0: 2 ports detected
[    2.302236] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.302269] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.302271] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.302325] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    2.302377] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
[    2.302463] usb usb8: configuration #1 chosen from 1 choice
[    2.302518] hub 8-0:1.0: USB hub found
[    2.302550] hub 8-0:1.0: 2 ports detected
[    2.302657] PNP: No PS/2 controller found. Probing ports directly.
[    2.305210] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.305243] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.305326] mice: PS/2 mouse device common for all mice
[    2.305409] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    2.305459] rtc_cmos 00:03: RTC can wake from S4
[    2.305516] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.305564] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.305696] device-mapper: uevent: version 1.0.3
[    2.305796] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    2.305933] device-mapper: multipath: version 1.1.0 loaded
[    2.305963] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.306209] cpuidle: using governor ladder
[    2.306238] cpuidle: using governor menu
[    2.306555] TCP cubic registered
[    2.306690] NET: Registered protocol family 10
[    2.307098] lo: Disabled Privacy Extensions
[    2.307359] NET: Registered protocol family 17
[    2.307402] Bluetooth: L2CAP ver 2.14
[    2.307430] Bluetooth: L2CAP socket layer initialized
[    2.307459] Bluetooth: SCO (Voice Link) ver 0.6
[    2.307488] Bluetooth: SCO socket layer initialized
[    2.307541] Bluetooth: RFCOMM TTY layer initialized
[    2.307571] Bluetooth: RFCOMM socket layer initialized
[    2.307600] Bluetooth: RFCOMM ver 1.11
[    2.307705] PM: Resume from disk failed.
[    2.307716] registered taskstats version 1
[    2.308129]   Magic number: 2:873:295
[    2.308180] tty tty28: hash matches
[    2.308255] rtc_cmos 00:03: setting system clock to 2010-03-14 20:15:59 UTC (1268597759)
[    2.308289] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.308318] EDD information not available.
[    2.503221] ata9.00: ATA-6: ST340014A, 8.01, max UDMA/100
[    2.503252] ata9.00: 78165360 sectors, multi 0: LBA48 
[    2.540848] ata9.00: configured for UDMA/100
[    2.602509] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.612524] ata7: SATA link down (SStatus 0 SControl 300)
[    2.612580] ata8: SATA link down (SStatus 0 SControl 300)
[    2.770012] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.771754] ata1.00: ATA-8: ST3500320AS, SD1A, max UDMA/133
[    2.771785] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.773888] ata1.00: configured for UDMA/133
[    2.790135] scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD1A PQ: 0 ANSI: 5
[    2.790300] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.790336] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.790418] sd 0:0:0:0: [sda] Write Protect is off
[    2.790448] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.790468] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.790619]  sda: sda1 < > sda2
[    2.808754] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.885093] usb 1-1: configuration #1 chosen from 1 choice
[    3.120008] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.387999] usb 2-1: configuration #1 chosen from 1 choice
[    3.720010] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.721636] ata2.00: ATA-8: ST3500320AS, SD1A, max UDMA/133
[    3.721666] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.723642] ata2.00: configured for UDMA/133
[    3.740062] scsi 1:0:0:0: Direct-Access     ATA      ST3500320AS      SD1A PQ: 0 ANSI: 5
[    3.740183] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    3.740205] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.740287] sd 1:0:0:0: [sdb] Write Protect is off
[    3.740316] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.740336] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.740470]  sdb: unknown partition table
[    3.760762] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.900009] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    4.084451] usb 5-1: configuration #1 chosen from 1 choice
[    4.090013] ata3: SATA link down (SStatus 0 SControl 300)
[    4.360009] usb 7-2: new full speed USB device using uhci_hcd and address 2
[    4.460011] ata4: SATA link down (SStatus 0 SControl 300)
[    4.541211] usb 7-2: configuration #1 chosen from 1 choice
[    4.822516] usb 8-1: new low speed USB device using uhci_hcd and address 2
[    5.002613] usb 8-1: configuration #1 chosen from 1 choice
[    5.282507] usb 8-2: new low speed USB device using uhci_hcd and address 3
[    5.412510] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.412733] ata5.00: ATAPI: ASUS    DRW-20B1LT, 1.00, max UDMA/100
[    5.413420] ata5.00: configured for UDMA/100
[    5.430982] scsi 4:0:0:0: CD-ROM            ASUS     DRW-20B1LT       1.00 PQ: 0 ANSI: 5
[    5.436189] sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.436225] Uniform CD-ROM driver Revision: 3.20
[    5.436316] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    5.436356] sr 4:0:0:0: Attached scsi generic sg2 type 5
[    5.462636] usb 8-2: configuration #1 chosen from 1 choice
[    5.780011] ata6: SATA link down (SStatus 0 SControl 300)
[    5.802587] scsi 8:0:0:0: Direct-Access     ATA      ST340014A        8.01 PQ: 0 ANSI: 5
[    5.802710] sd 8:0:0:0: [sdc] 78165360 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    5.802716] sd 8:0:0:0: Attached scsi generic sg3 type 0
[    5.802855] sd 8:0:0:0: [sdc] Write Protect is off
[    5.802885] sd 8:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.802906] sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.803058]  sdc: sdc1 sdc2
[    5.822801] sd 8:0:0:0: [sdc] Attached SCSI disk
[    5.971482] Freeing unused kernel memory: 688k freed
[    5.971649] Write protecting the kernel read-only data: 7648k
[    6.057998] ATL1E 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.058048] ATL1E 0000:02:00.0: setting latency timer to 64
[    6.097374] Initializing USB Mass Storage driver...
[    6.106556] usbcore: registered new interface driver hiddev
[    6.107656] scsi10 : SCSI emulation for USB Mass Storage devices
[    6.109151] usbcore: registered new interface driver usb-storage
[    6.109266] USB Mass Storage support registered.
[    6.109581] usb-storage: device found at 2
[    6.109583] usb-storage: waiting for device to settle before scanning
[    6.111499] ohci1394 0000:05:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.112021] input: Hanvon Tablet as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input3
[    6.112143] generic-usb 0003:0B57:8502.0001: input,hiddev96,hidraw0: USB HID v1.00 Device [Hanvon Tablet] on usb-0000:00:1a.2-1/input0
[    6.124828] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/input/input4
[    6.124925] generic-usb 0003:046D:C03E.0002: input,hidraw1: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.2-1/input0
[    6.138885] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input5
[    6.138995] generic-usb 0003:046D:C315.0003: input,hidraw2: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.2-2/input0
[    6.139059] usbcore: registered new interface driver usbhid
[    6.139091] usbhid: v2.6:USB HID core driver
[    6.173289] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[febfe000-febfe7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    7.261708] PM: Starting manual resume from disk
[    7.261741] PM: Resume from partition 252:2
[    7.261742] PM: Checking hibernation image.
[    7.261966] PM: Error -22 checking image file
[    7.261968] PM: Resume from disk failed.
[    7.301756] EXT4-fs (dm-1): mounted filesystem with ordered data mode
[    7.490149] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c0001931fcb]
[   11.100144] usb-storage: device scan complete
[   11.100615] scsi 10:0:0:0: Direct-Access     Generic  Compact Flash    0.00 PQ: 0 ANSI: 2
[   11.101114] scsi 10:0:0:1: Direct-Access     Generic  SD/MMC           0.00 PQ: 0 ANSI: 2
[   11.101609] scsi 10:0:0:2: Direct-Access     Generic  microSD          0.00 PQ: 0 ANSI: 2
[   11.102110] scsi 10:0:0:3: Direct-Access     Generic  MS/MS-PRO        0.00 PQ: 0 ANSI: 2
[   11.102609] scsi 10:0:0:4: Direct-Access     Generic  SM/xD-Picture    0.00 PQ: 0 ANSI: 2
[   11.103013] sd 10:0:0:0: Attached scsi generic sg4 type 0
[   11.103129] sd 10:0:0:1: Attached scsi generic sg5 type 0
[   11.103253] sd 10:0:0:2: Attached scsi generic sg6 type 0
[   11.103375] sd 10:0:0:3: Attached scsi generic sg7 type 0
[   11.103498] sd 10:0:0:4: Attached scsi generic sg8 type 0
[   11.106725] sd 10:0:0:0: [sdd] Attached SCSI removable disk
[   11.107353] sd 10:0:0:1: [sde] Attached SCSI removable disk
[   11.107981] sd 10:0:0:2: [sdf] Attached SCSI removable disk
[   11.108604] sd 10:0:0:3: [sdg] Attached SCSI removable disk
[   11.109225] sd 10:0:0:4: [sdh] Attached SCSI removable disk
[   14.940019] udev: starting version 147
[   14.968035] Adding 3903784k swap on /dev/mapper/isw_bgccbabfgf_SYSTEM5.  Priority:-1 extents:1 across:3903784k 
[   15.681059] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.742288] lp: driver loaded but no devices found
[   15.766937]   alloc irq_desc for 29 on node -1
[   15.766946]   alloc kstat_irqs on node -1
[   15.766960] ATL1E 0000:02:00.0: irq 29 for MSI/MSI-X
[   15.767229] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.768074] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   15.768273] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.979037] Linux video capture interface: v2.00
[   16.795287] uvcvideo: Found UVC 1.00 device <unnamed> (046d:080f)
[   16.810377] input: UVC Camera (046d:080f) as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.0/input/input6
[   16.810435] usbcore: registered new interface driver uvcvideo
[   16.810438] USB Video Class driver (v0.1.0)
[   16.909748] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
[   17.002767] flexcop-pci: will use the HW PID filter.
[   17.002773] flexcop-pci: card revision 1
[   17.002782] b2c2_flexcop_pci 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   17.041288] DVB: registering new adapter (FlexCop Digital TV device)
[   17.042849] b2c2-flexcop: MAC address = 00:d0:d7:02:3d:87
[   17.043485] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
[   17.043522] CX24123: wrong demod revision: 87
[   17.254755] saa7130/34: v4l2 driver version 0.2.15 loaded
[   17.651036] b2c2-flexcop: found 'ST STV0299 DVB-S' .
[   17.651040] DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
[   17.651090] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S rev 2.6' at the 'PCI' bus controlled by a 'FlexCopII' complete
[   17.653302] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.653308] saa7133[0]: found at 0000:05:00.0, rev: 209, irq: 16, latency: 64, mmio: 0xfebff800
[   17.653314] saa7133[0]: subsystem: 1043:4845, board: ASUS TV-FM 7135 [card=53,autodetected]
[   17.653331] saa7133[0]: board init: gpio is 40000
[   17.653336] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   17.840011] saa7133[0]: i2c eeprom 00: 43 10 45 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   17.840020] saa7133[0]: i2c eeprom 10: 00 ff e2 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   17.840028] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 88 ff ff ff ff
[   17.840035] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840043] saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 ff 02 30 15 ff ff ff ff ff ff ff
[   17.840050] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840058] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840065] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840072] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840080] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840088] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840095] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840102] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840110] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840117] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840125] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   17.840134] i2c i2c-3: Invalid 7-bit address 0x7a
[   17.840617] saa7133[0]: P7131 analog only, using entry of ASUSTeK P7131 Analog
[   17.840707] input: saa7134 IR (ASUSTeK P7131 Analo as /devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input7
[   17.882211]   alloc irq_desc for 22 on node -1
[   17.882215]   alloc kstat_irqs on node -1
[   17.882221] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   17.882256] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   18.033350] hda_codec: ALC1200: BIOS auto-probing.
[   18.034772] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[   18.038564] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   18.038585] HDA Intel 0000:01:00.1: setting latency timer to 64
[   18.040272] tuner 3-004b: chip found @ 0x96 (saa7133[0])
[   18.210040] tda829x 3-004b: setting tuner address to 61
[   18.370046] tda829x 3-004b: type set to tda8290+75a
[   23.920086] saa7133[0]: registered device video1 [v4l2]
[   23.920110] saa7133[0]: registered device vbi0
[   23.920132] saa7133[0]: registered device radio0
[   23.948454] saa7134 ALSA driver for DMA sound loaded
[   23.948465] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   23.948486] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as card -2
[   25.822513] eth0: no IPv6 routers present
[   30.472960] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[   30.652814] ppdev: user-space parallel port driver

--------------050500070502000907090604--
