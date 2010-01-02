Return-path: <linux-media-owner@vger.kernel.org>
Received: from 58.204.54.77.rev.vodafone.pt ([77.54.204.58]:48186 "EHLO
	linux-wpcs.site" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751678Ab0ABL14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jan 2010 06:27:56 -0500
From: Armando Baia <armbaia@gmail.com>
To: linux-media@vger.kernel.org
Subject: [248.815294] DVB: adapter 0 frontend 0 symbol rate 4800000 out of range (5000000..45000000)
Date: Sat, 2 Jan 2010 11:21:02 +0000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001021121.03197.armbaia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry if some phrases in the text does not make sense, I Portuguese do not 
speak English, this text is translated by google.
I am not a expert with computers, so it is natural that does not do things 
well, but this is my problem!

Using openSUSE 11.2 with kernel 2.6.31.5-0.1-desktop. I have installed a card 
Technotrend budget dvb-s 3200, which in windows is to scan all frequencies, 
but Linux does not scan the frequencies SymbolRate less than 5000! I leave you 
with the information that within my limited knowledge of the system,may lead 
to solving the problem.


linux-o2b8:~ # dmesg                                                                                                                                                               
[    0.000000] Linux version 2.6.31.5-0.1-desktop (geeko@buildhost) (gcc 
version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #1 SMP PREEMPT 
2009-10-26 15:49:03 +0100    
[    0.000000] KERNEL supported cpus:                                                                                                                                              
[    0.000000]   Intel GenuineIntel                                                                                                                                                
[    0.000000]   AMD AuthenticAMD                                                                                                                                                  
[    0.000000]   NSC Geode by NSC                                                                                                                                                  
[    0.000000]   Cyrix CyrixInstead                                                                                                                                                
[    0.000000]   Centaur CentaurHauls                                                                                                                                              
[    0.000000]   Transmeta GenuineTMx86                                                                                                                                            
[    0.000000]   Transmeta TransmetaCPU                                                                                                                                            
[    0.000000]   UMC UMC UMC UMC                                                                                                                                                   
[    0.000000] BIOS-provided physical RAM map:                                                                                                                                     
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)                                                                                                            
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)                                                                                                          
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)                                                                                                          
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f7a0000 (usable)                                                                                                            
[    0.000000]  BIOS-e820: 000000003f7a0000 - 000000003f7ae000 (ACPI data)                                                                                                         
[    0.000000]  BIOS-e820: 000000003f7ae000 - 000000003f7e0000 (ACPI NVS)                                                                                                          
[    0.000000]  BIOS-e820: 000000003f7e0000 - 000000003f800000 (reserved)                                                                                                          
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)                                                                                                          
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)                                                                                                          
[    0.000000] DMI 2.4 present.                                                                                                                                                    
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.                                                                                                     
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)                                                                                      
[    0.000000] last_pfn = 0x3f7a0 max_arch_pfn = 0x1000000                                                                                                                         
[    0.000000] MTRR default type: uncachable                                                                                                                                       
[    0.000000] MTRR fixed ranges enabled:                                                                                                                                          
[    0.000000]   00000-9FFFF write-back                                                                                                                                            
[    0.000000]   A0000-DFFFF uncachable                                                                                                                                            
[    0.000000]   E0000-EFFFF write-through                                                                                                                                         
[    0.000000]   F0000-FFFFF write-protect                                                                                                                                         
[    0.000000] MTRR variable ranges enabled:                                                                                                                                       
[    0.000000]   0 base 000000000 mask FC0000000 write-back                                                                                                                        
[    0.000000]   1 base 03F800000 mask FFF800000 uncachable                                                                                                                        
[    0.000000]   2 disabled                                                                                                                                                        
[    0.000000]   3 disabled                                                                                                                                                        
[    0.000000]   4 disabled                                                                                                                                                        
[    0.000000]   5 disabled                                                                                                                                                        
[    0.000000]   6 disabled                                                                                                                                                        
[    0.000000]   7 disabled                                                                                                                                                        
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106                                                                                                    
[    0.000000] Scanning 0 areas for low memory corruption                                                                                                                          
[    0.000000] modified physical RAM map:                                                                                                                                          
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)                                                                                                           
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)                                                                                                             
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)                                                                                                           
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)                                                                                                           
[    0.000000]  modified: 0000000000100000 - 000000003f7a0000 (usable)                                                                                                             
[    0.000000]  modified: 000000003f7a0000 - 000000003f7ae000 (ACPI data)                                                                                                          
[    0.000000]  modified: 000000003f7ae000 - 000000003f7e0000 (ACPI NVS)                                                                                                           
[    0.000000]  modified: 000000003f7e0000 - 000000003f800000 (reserved)                                                                                                           
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)                                                                                                           
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)                                                                                                           
[    0.000000] initial memory mapped : 0 - 01000000                                                                                                                                
[    0.000000] init_memory_mapping: 0000000000000000-0000000036ffe000                                                                                                              
[    0.000000] NX (Execute Disable) protection: active                                                                                                                             
[    0.000000]  0000000000 - 0000200000 page 4k                                                                                                                                    
[    0.000000]  0000200000 - 0036e00000 page 2M                                                                                                                                    
[    0.000000]  0036e00000 - 0036ffe000 page 4k                                                                                                                                    
[    0.000000] kernel direct mapping tables up to 36ffe000 @ 10000-1b000                                                                                                           
[    0.000000] RAMDISK: 379aa000 - 37feff0f                                                                                                                                        
[    0.000000] Allocated new RAMDISK: 00af7000 - 0113cf0f                                                                                                                          
[    0.000000] Move RAMDISK from 00000000379aa000 - 0000000037feff0e to 
00af7000 - 0113cf0e                                                                                        
[    0.000000] ACPI: RSDP 000fb030 00014 (v00 ACPIAM)                                                                                                                              
[    0.000000] ACPI: RSDT 3f7a0000 0003C (v01 ?????? ???????? 08000701 MSFT 
00000097)                                                                                              
[    0.000000] ACPI: FACP 3f7a0200 00084 (v02 A_M_I_ OEMFACP  08000701 MSFT 
00000097)                                                                                              
[    0.000000] ACPI: DSDT 3f7a05c0 0682B (v01  A0798 A0798000 00000000 INTL 
20051117)                                                                                              
[    0.000000] ACPI: FACS 3f7ae000 00040                                                                                                                                           
[    0.000000] ACPI: APIC 3f7a0390 0006C (v01 A_M_I_ OEMAPIC  08000701 MSFT 
00000097)                                                                                              
[    0.000000] ACPI: MCFG 3f7a0400 0003C (v01 A_M_I_ OEMMCFG  08000701 MSFT 
00000097)                                                                                              
[    0.000000] ACPI: SLIC 3f7a0440 00176 (v01 ?????? ???????? 08000701 MSFT 
00000097)                                                                                              
[    0.000000] ACPI: OEMB 3f7ae040 00080 (v01 A_M_I_ AMI_OEM  08000701 MSFT 
00000097)                                                                                              
[    0.000000] ACPI: HPET 3f7a6df0 00038 (v01 A_M_I_ OEMHPET  08000701 MSFT 
00000097)                                                                                              
[    0.000000] ACPI: Local APIC address 0xfee00000                                                                                                                                 
[    0.000000] could not find any ACPI SRAT memory areas.                                                                                                                          
[    0.000000] failed to get NUMA memory information from SRAT table                                                                                                               
[    0.000000] NUMA - single node, flat memory mode                                                                                                                                
[    0.000000] Node: 0, start_pfn: 0, end_pfn: 3f7a0                                                                                                                               
[    0.000000]   Setting physnode_map array to node 0 for pfns:                                                                                                                    
[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000 
2c000 30000 34000 38000 3c000                                                                          
[    0.000000] node 0 pfn: [0 - 3f7a0]                                                                                                                                             
[    0.000000] Reserving 2048 pages of KVA for lmem_map of node 0 at 3ee00                                                                                                         
[    0.000000] remove_active_range (0, 257536, 259584)                                                                                                                             
[    0.000000] Reserving total of 800 pages for numa KVA remap                                                                                                                     
[    0.000000] kva_start_pfn ~ 36600 max_low_pfn ~ 36ffe                                                                                                                           
[    0.000000] max_pfn = 3f7a0                                                                                                                                                     
[    0.000000] 135MB HIGHMEM available.                                                                                                                                            
[    0.000000] 879MB LOWMEM available.                                                                                                                                             
[    0.000000] max_low_pfn = 36ffe, highstart_pfn = 36ffe                                                                                                                          
[    0.000000] Low memory ends at vaddr f6ffe000                                                                                                                                   
[    0.000000] node 0 will remap to vaddr f6600000 - f6e00000                                                                                                                      
[    0.000000] allocate_pgdat: node 0 NODE_DATA f6600000                                                                                                                           
[    0.000000] remap_numa_kva: node 0                                                                                                                                              
[    0.000000] remap_numa_kva: f6600000 to pfn 0003ee00                                                                                                                            
[    0.000000] remap_numa_kva: f6800000 to pfn 0003f000                                                                                                                            
[    0.000000] remap_numa_kva: f6a00000 to pfn 0003f200                                                                                                                            
[    0.000000] remap_numa_kva: f6c00000 to pfn 0003f400                                                                                                                            
[    0.000000] High memory starts at vaddr f6ffe000                                                                                                                                
[    0.000000]   mapped low ram: 0 - 36ffe000                                                                                                                                      
[    0.000000]   low ram: 0 - 36ffe000                                                                                                                                             
[    0.000000]   node 0 low ram: 00000000 - 36ffe000                                                                                                                               
[    0.000000]   node 0 bootmap 00018000 - 0001ee00                                                                                                                                
[    0.000000] (11 early reservations) ==> bootmem [0000000000 - 0036ffe000]                                                                                                       
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]                                                                                       
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 
- 0000002000]                                                                                       
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 
- 0000007000]                                                                                       
[    0.000000]   #3 [0000200000 - 0000aeda90]    TEXT DATA BSS ==> [0000200000 
- 0000aeda90]                                                                                       
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 
- 0000100000]                                                                                       
[    0.000000]   #5 [0000aee000 - 0000af6210]              BRK ==> [0000aee000 
- 0000af6210]                                                                                       
[    0.000000]   #6 [0000010000 - 0000018000]          PGTABLE ==> [0000010000 
- 0000018000]                                                                                       
[    0.000000]   #7 [0000af7000 - 000113cf0f]      NEW RAMDISK ==> [0000af7000 
- 000113cf0f]                                                                                       
[    0.000000]   #8 [003ee00000 - 003f600000]          KVA RAM                                                                                                                     
[    0.000000]   #9 [0036600000 - 0036e00000]           KVA PG ==> [0036600000 
- 0036e00000]                                                                                       
[    0.000000]   #10 [0000018000 - 000001f000]          BOOTMAP ==> 
[0000018000 - 000001f000]                                                                                      
[    0.000000] found SMP MP-table at [c00ff780] ff780                                                                                                                              
[    0.000000] Zone PFN ranges:                                                                                                                                                    
[    0.000000]   DMA      0x00000010 -> 0x00001000                                                                                                                                 
[    0.000000]   Normal   0x00001000 -> 0x00036ffe                                                                                                                                 
[    0.000000]   HighMem  0x00036ffe -> 0x0003f7a0                                                                                                                                 
[    0.000000] Movable zone start PFN for each node                                                                                                                                
[    0.000000] early_node_map[3] active PFN ranges                                                                                                                                 
[    0.000000]     0: 0x00000010 -> 0x0000009f                                                                                                                                     
[    0.000000]     0: 0x00000100 -> 0x0003ee00                                                                                                                                     
[    0.000000]     0: 0x0003f600 -> 0x0003f7a0                                                                                                                                     
[    0.000000] On node 0 totalpages: 257839                                                                                                                                        
[    0.000000] free_area_init_node: node 0, pgdat f6600000, node_mem_map 
f6602200                                                                                                  
[    0.000000]   DMA zone: 32 pages used for memmap                                                                                                                                
[    0.000000]   DMA zone: 0 pages reserved                                                                                                                                        
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0                                                                                                                                
[    0.000000]   Normal zone: 1728 pages used for memmap                                                                                                                           
[    0.000000]   Normal zone: 219454 pages, LIFO batch:31                                                                                                                          
[    0.000000]   HighMem zone: 272 pages used for memmap                                                                                                                           
[    0.000000]   HighMem zone: 32402 pages, LIFO batch:7                                                                                                                           
[    0.000000] Using APIC driver default                                                                                                                                           
[    0.000000] ACPI: PM-Timer IO Port: 0x808                                                                                                                                       
[    0.000000] ACPI: Local APIC address 0xfee00000                                                                                                                                 
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)                                                                                                                  
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)                                                                                                                  
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)                                                                                                                 
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)                                                                                                                 
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])                                                                                                             
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23                                                                                                      
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                                                                                                            
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)                                                                                                         
[    0.000000] ACPI: IRQ0 used by override.                                                                                                                                        
[    0.000000] ACPI: IRQ2 used by override.                                                                                                                                        
[    0.000000] ACPI: IRQ9 used by override.                                                                                                                                        
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs                                                                                                                       
[    0.000000] Using ACPI (MADT) for SMP configuration information                                                                                                                 
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000                                                                                                                          
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs                                                                                                                                
[    0.000000] nr_irqs_gsi: 24                                                                                                                                                     
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000                                                                                                   
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e4000                                                                                                   
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 
0000000000100000                                                                                                   
[    0.000000] Allocating PCI resources starting at 3f800000 (gap: 
3f800000:bf600000)                                                                                              
[    0.000000] NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:8                                                                                                          
[    0.000000] PERCPU: Embedded 14 pages at c1142000, static data 34204 bytes                                                                                                      
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 255807                                                                                         
[    0.000000] Policy zone: HighMem                                                                                                                                                
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-
Hitachi_HDS721680PLAT80_PV6805Z8S9RMEN-part2 resume=/dev/disk/by-id/ata-
Hitachi_HDS721680PLAT80_PV6805Z8S9RMEN-part3 splash=silent quiet vga=0x31a                                                                                                                                                        
[    0.000000] bootsplash: silent mode.                                                                                                                                            
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)                                                                                                               
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)                                                                                                    
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)                                                                                                      
[    0.000000] Enabling fast FPU save and restore... done.                                                                                                                         
[    0.000000] Enabling unmasked SIMD FPU exception support... done.                                                                                                               
[    0.000000] Initializing CPU#0                                                                                                                                                  
[    0.000000] Initializing HighMem for node 0 (00036ffe:0003f7a0)                                                                                                                 
[    0.000000] Memory: 1006476k/1040000k available (4719k kernel code, 24880k 
reserved, 2944k data, 464k init, 130696k highmem)                                                    
[    0.000000] virtual kernel memory layout:                                                                                                                                       
[    0.000000]     fixmap  : 0xff5b5000 - 0xfffff000   (10536 kB)                                                                                                                  
[    0.000000]     pkmap   : 0xff000000 - 0xff200000   (2048 kB)                                                                                                                   
[    0.000000]     vmalloc : 0xf77fe000 - 0xfeffe000   ( 120 MB)                                                                                                                   
[    0.000000]     lowmem  : 0xc0000000 - 0xf6ffe000   ( 879 MB)                                                                                                                   
[    0.000000]       .init : 0xc097d000 - 0xc09f1000   ( 464 kB)                                                                                                                   
[    0.000000]       .data : 0xc069bd42 - 0xc097c008   (2944 kB)                                                                                                                   
[    0.000000]       .text : 0xc0200000 - 0xc069bd42   (4719 kB)                                                                                                                   
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.                                                                                         
[    0.000000] Hierarchical RCU implementation.                                                                                                                                    
[    0.000000] NR_IRQS:2304 nr_irqs:440                                                                                                                                            
[    0.000000] Fast TSC calibration using PIT                                                                                                                                      
[    0.000000] Detected 1600.042 MHz processor.                                                                                                                                    
[    0.000117] Console: colour dummy device 80x25                                                                                                                                  
[    0.000122] console [tty0] enabled                                                                                                                                              
[    0.000344] hpet clockevent registered                                                                                                                                          
[    0.000349] HPET: 3 timers in total, 0 timers will be used for per-cpu 
timer                                                                                                    
[    0.000356] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 3200.08 BogoMIPS (lpj=1600042)                                                           
[    0.021203] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, 
All Rights Reserved                                                                                   
[    0.021300] Security Framework initialized                                                                                                                                      
[    0.021325] AppArmor: AppArmor initialized                                                                                                                                      
[    0.021355] Mount-cache hash table entries: 512                                                                                                                                 
[    0.021558] CPU: L1 I cache: 32K, L1 D cache: 32K                                                                                                                               
[    0.021563] CPU: L2 cache: 1024K                                                                                                                                                
[    0.021566] CPU: Physical Processor ID: 0                                                                                                                                       
[    0.021569] CPU: Processor Core ID: 0                                                                                                                                           
[    0.021574] mce: CPU supports 6 MCE banks                                                                                                                                       
[    0.021585] CPU0: Thermal monitoring enabled (TM2)                                                                                                                              
[    0.021590] using mwait in idle threads.                                                                                                                                        
[    0.021598] Performance Counters: Core2 events, Intel PMU driver.                                                                                                               
[    0.021606] ... version:                 2                                                                                                                                      
[    0.021608] ... bit width:               40                                                                                                                                     
[    0.021610] ... generic counters:        2                                                                                                                                      
[    0.021613] ... value mask:              000000ffffffffff                                                                                                                       
[    0.021616] ... max period:              000000007fffffff                                                                                                                       
[    0.021618] ... fixed-purpose counters:  3                                                                                                                                      
[    0.021621] ... counter mask:            0000000700000003                                                                                                                       
[    0.021628] Checking 'hlt' instruction... OK.                                                                                                                                   
[    0.026536] ACPI: Core revision 20090521                                                                                                                                        
[    0.039222] Mapping cpu 0 to node 0                                                                                                                                             
[    0.039401] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                                                                                                                
[    0.049737] CPU0: Intel(R) Pentium(R) Dual  CPU  E2140  @ 1.60GHz stepping 
0d                                                                                                   
[    0.049992] Booting processor 1 APIC 0x1 ip 0x6000                                                                                                                              
[    0.000999] Initializing CPU#1                                                                                                                                                  
[    0.000999] Mapping cpu 1 to node 0                                                                                                                                             
[    0.000999] Calibrating delay using timer specific routine.. 3199.78 
BogoMIPS (lpj=1599893)                                                                                     
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K                                                                                                                               
[    0.000999] CPU: L2 cache: 1024K                                                                                                                                                
[    0.000999] CPU: Physical Processor ID: 0                                                                                                                                       
[    0.000999] CPU: Processor Core ID: 1                                                                                                                                           
[    0.000999] mce: CPU supports 6 MCE banks                                                                                                                                       
[    0.000999] CPU1: Thermal monitoring enabled (TM2)                                                                                                                              
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106                                                                                                    
[    0.121778] CPU1: Intel(R) Pentium(R) Dual  CPU  E2140  @ 1.60GHz stepping 
0d                                                                                                   
[    0.121794] checking TSC synchronization [CPU#0 -> CPU#1]: passed.                                                                                                              
[    0.122020] Brought up 2 CPUs                                                                                                                                                   
[    0.122020] Total of 2 processors activated (6399.87 BogoMIPS).                                                                                                                 
[    0.122092] CPU0 attaching sched-domain:                                                                                                                                        
[    0.122095]  domain 0: span 0-1 level MC                                                                                                                                        
[    0.122099]   groups: 0 1                                                                                                                                                       
[    0.122106]   domain 1: span 0-1 level NODE                                                                                                                                     
[    0.122110]    groups: 0-1                                                                                                                                                      
[    0.122117] CPU1 attaching sched-domain:                                                                                                                                        
[    0.122120]  domain 0: span 0-1 level MC                                                                                                                                        
[    0.122124]   groups: 1 0                                                                                                                                                       
[    0.122130]   domain 1: span 0-1 level NODE                                                                                                                                     
[    0.122133]    groups: 0-1                                                                                                                                                      
[    0.125059] devtmpfs: initialized                                                                                                                                               
[    0.126024] Booting paravirtualized kernel on bare hardware                                                                                                                     
[    0.126264] regulator: core version 0.5                                                                                                                                         
[    0.126264] Time: 13:57:42  Date: 12/30/09                                                                                                                                      
[    0.126264] NET: Registered protocol family 16                                                                                                                                  
[    0.126324] ACPI: bus type pci registered                                                                                                                                       
[    0.126414] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63                                                                                                     
[    0.126414] PCI: Not using MMCONFIG.                                                                                                                                            
[    0.126414] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=3                                                                                                            
[    0.126414] PCI: Using configuration type 1 for base access                                                                                                                     
[    0.128088] bio: create slab <bio-0> at 0                                                                                                                                       
[    0.130366] ACPI: EC: Look up EC in DSDT                                                                                                                                        
[    0.144101] ACPI: Interpreter enabled                                                                                                                                           
[    0.144112] ACPI: (supports S0 S1 S3 S4 S5)                                                                                                                                     
[    0.144155] ACPI: Using IOAPIC for interrupt routing                                                                                                                            
[    0.144233] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63                                                                                                     
[    0.149739] PCI: MCFG area at f0000000 reserved in ACPI motherboard 
resources                                                                                                   
[    0.149743] PCI: Using MMCONFIG for extended config space                                                                                                                       
[    0.161377] ACPI Warning: Incorrect checksum in table [OEMB] - 99, should 
be 8C 20090521 tbutils-246                                                                            
[    0.161619] ACPI: No dock devices found.                                                                                                                                        
[    0.161777] ACPI: PCI Root Bridge [PCI0] (0000:00)                                                                                                                              
[    0.161913] pci 0000:00:02.0: reg 10 32bit mmio: [0xdfd00000-0xdfd7ffff]                                                                                                        
[    0.161921] pci 0000:00:02.0: reg 14 io port: [0x8800-0x8807]                                                                                                                   
[    0.161928] pci 0000:00:02.0: reg 18 32bit mmio: [0xe0000000-0xefffffff]                                                                                                        
[    0.161935] pci 0000:00:02.0: reg 1c 32bit mmio: [0xdfd80000-0xdfdbffff]                                                                                                        
[    0.162043] pci 0000:00:1b.0: reg 10 64bit mmio: [0xdfdf8000-0xdfdfbfff]                                                                                                        
[    0.162096] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold                                                                                                               
[    0.162102] pci 0000:00:1b.0: PME# disabled                                                                                                                                     
[    0.162177] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold                                                                                                               
[    0.162183] pci 0000:00:1c.0: PME# disabled                                                                                                                                     
[    0.162258] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold                                                                                                               
[    0.162264] pci 0000:00:1c.1: PME# disabled                                                                                                                                     
[    0.162327] pci 0000:00:1d.0: reg 20 io port: [0x9000-0x901f]                                                                                                                   
[    0.162386] pci 0000:00:1d.1: reg 20 io port: [0x9400-0x941f]                                                                                                                   
[    0.162447] pci 0000:00:1d.2: reg 20 io port: [0x9800-0x981f]                                                                                                                   
[    0.162509] pci 0000:00:1d.3: reg 20 io port: [0xa000-0xa01f]                                                                                                                   
[    0.162575] pci 0000:00:1d.7: reg 10 32bit mmio: [0xdfdffc00-0xdfdfffff]                                                                                                        
[    0.162636] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold                                                                                                               
[    0.162642] pci 0000:00:1d.7: PME# disabled                                                                                                                                     
[    0.162786] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 
ACPI/GPIO/TCO                                                                                             
[    0.162792] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO                                                                                                      
[    0.162799] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 
(mask 0007)                                                                                              
[    0.162849] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]                                                                                                                       
[    0.162858] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]                                                                                                                       
[    0.162866] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]                                                                                                                       
[    0.162875] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]                                                                                                                       
[    0.162884] pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]                                                                                                                   
[    0.162935] pci 0000:00:1f.2: reg 10 io port: [0xb800-0xb807]                                                                                                                   
[    0.162944] pci 0000:00:1f.2: reg 14 io port: [0xb400-0xb403]                                                                                                                   
[    0.162952] pci 0000:00:1f.2: reg 18 io port: [0xb000-0xb007]                                                                                                                   
[    0.162960] pci 0000:00:1f.2: reg 1c io port: [0xa800-0xa803]                                                                                                                   
[    0.162968] pci 0000:00:1f.2: reg 20 io port: [0xa400-0xa40f]                                                                                                                   
[    0.163004] pci 0000:00:1f.2: PME# supported from D3hot                                                                                                                         
[    0.163009] pci 0000:00:1f.2: PME# disabled                                                                                                                                     
[    0.163063] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]                                                                                                                     
[    0.163144] pci 0000:00:1c.0: bridge io port: [0xe000-0xefff]                                                                                                                   
[    0.163215] pci 0000:02:00.0: reg 10 64bit mmio: [0xdffc0000-0xdfffffff]                                                                                                        
[    0.163253] pci 0000:02:00.0: reg 30 32bit mmio: [0xdffa0000-0xdffbffff]                                                                                                        
[    0.163293] pci 0000:02:00.0: PME# supported from D3hot D3cold                                                                                                                  
[    0.163300] pci 0000:02:00.0: PME# disabled                                                                                                                                     
[    0.163334] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You 
can enable it with 'pcie_aspm=force'                                                                  
[    0.163416] pci 0000:00:1c.1: bridge io port: [0xd000-0xdfff]                                                                                                                   
[    0.163421] pci 0000:00:1c.1: bridge 32bit mmio: [0xdff00000-0xdfffffff]                                                                                                        
[    0.163455] pci 0000:01:00.0: reg 10 32bit mmio: [0xdfeffc00-0xdfeffdff]                                                                                                        
[    0.163549] pci 0000:00:1e.0: transparent bridge                                                                                                                                
[    0.163555] pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]                                                                                                                   
[    0.163560] pci 0000:00:1e.0: bridge 32bit mmio: [0xdfe00000-0xdfefffff]                                                                                                        
[    0.163588] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                                                                                                 
[    0.163816] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]                                                                                                            
[    0.163948] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]                                                                                                            
[    0.164048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]                                                                                                            
[    0.169401] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 
15)                                                                                                    
[    0.169579] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 
15)                                                                                                    
[    0.169754] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 
15)                                                                                                    
[    0.169929] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 
15)                                                                                                    
[    0.170111] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 
15)                                                                                                    
[    0.170287] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) 
*0, disabled.                                                                                       
[    0.170464] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) 
*0, disabled.                                                                                       
[    0.170640] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 
15)                                                                                                    
[    0.170942] SCSI subsystem initialized                                                                                                                                          
[    0.171989] libata version 3.00 loaded.                                                                                                                                         
[    0.172051] usbcore: registered new interface driver usbfs                                                                                                                      
[    0.172051] usbcore: registered new interface driver hub                                                                                                                        
[    0.172990] usbcore: registered new device driver usb                                                                                                                           
[    0.173042] PCI: Using ACPI for IRQ routing                                                                                                                                     
[    0.174997] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0                                                                                                                             
[    0.175008] hpet0: 3 comparators, 64-bit 14.318180 MHz counter                                                                                                                  
[    0.180535] AppArmor: AppArmor Filesystem Enabled                                                                                                                               
[    0.182857] pnp: PnP ACPI init                                                                                                                                                  
[    0.182882] ACPI: bus type pnp registered                                                                                                                                       
[    0.189782] pnp: PnP ACPI: found 18 devices                                                                                                                                     
[    0.189785] ACPI: ACPI bus type pnp unregistered                                                                                                                                
[    0.189802] system 00:01: iomem range 0xfed13000-0xfed19fff has been 
reserved                                                                                                   
[    0.189815] system 00:08: ioport range 0x290-0x297 has been reserved                                                                                                            
[    0.189824] system 00:09: ioport range 0x4d0-0x4d1 has been reserved                                                                                                            
[    0.189829] system 00:09: ioport range 0x800-0x87f has been reserved                                                                                                            
[    0.189833] system 00:09: ioport range 0x480-0x4bf has been reserved                                                                                                            
[    0.189837] system 00:09: ioport range 0x900-0x91f has been reserved                                                                                                            
[    0.189848] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been 
reserved                                                                                                   
[    0.189853] system 00:09: iomem range 0xfed20000-0xfed8ffff has been 
reserved                                                                                                   
[    0.189858] system 00:09: iomem range 0xffb00000-0xffbfffff has been 
reserved                                                                                                   
[    0.189863] system 00:09: iomem range 0xfff00000-0xffffffff could not be 
reserved                                                                                               
[    0.189873] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be 
reserved                                                                                               
[    0.189878] system 00:0c: iomem range 0xfee00000-0xfee00fff has been 
reserved                                                                                                   
[    0.189888] system 00:0f: iomem range 0xffc00000-0xfff7ffff has been 
reserved                                                                                                   
[    0.189896] system 00:10: iomem range 0xf0000000-0xf3ffffff has been 
reserved                                                                                                   
[    0.189905] system 00:11: iomem range 0x0-0x9ffff could not be reserved                                                                                                         
[    0.189910] system 00:11: iomem range 0xc0000-0xdffff could not be reserved                                                                                                     
[    0.189914] system 00:11: iomem range 0xe0000-0xfffff could not be reserved                                                                                                     
[    0.189919] system 00:11: iomem range 0x100000-0x3f7fffff could not be 
reserved                                                                                                 
[    0.224864] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03                                                                                                                 
[    0.224870] pci 0000:00:1c.0:   IO window: 0xe000-0xefff                                                                                                                        
[    0.224876] pci 0000:00:1c.0:   MEM window: disabled                                                                                                                            
[    0.224881] pci 0000:00:1c.0:   PREFETCH window: disabled                                                                                                                       
[    0.224887] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02                                                                                                                 
[    0.224892] pci 0000:00:1c.1:   IO window: 0xd000-0xdfff                                                                                                                        
[    0.224899] pci 0000:00:1c.1:   MEM window: 0xdff00000-0xdfffffff                                                                                                               
[    0.224904] pci 0000:00:1c.1:   PREFETCH window: disabled                                                                                                                       
[    0.224910] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01                                                                                                                 
[    0.224915] pci 0000:00:1e.0:   IO window: 0xc000-0xcfff                                                                                                                        
[    0.224922] pci 0000:00:1e.0:   MEM window: 0xdfe00000-0xdfefffff                                                                                                               
[    0.224927] pci 0000:00:1e.0:   PREFETCH window: disabled                                                                                                                       
[    0.224944]   alloc irq_desc for 16 on node 0                                                                                                                                   
[    0.224947]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.224955] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                        
[    0.224963] pci 0000:00:1c.0: setting latency timer to 64                                                                                                                       
[    0.224972]   alloc irq_desc for 17 on node 0                                                                                                                                   
[    0.224975]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.224980] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                                                        
[    0.224986] pci 0000:00:1c.1: setting latency timer to 64                                                                                                                       
[    0.224995] pci 0000:00:1e.0: setting latency timer to 64                                                                                                                       
[    0.225001] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                                                                                                      
[    0.225006] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                                                                                                      
[    0.225010] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]                                                                                                                    
[    0.225013] pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]                                                                                                                    
[    0.225017] pci_bus 0000:02: resource 1 mem: [0xdff00000-0xdfffffff]                                                                                                            
[    0.225021] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]                                                                                                                    
[    0.225025] pci_bus 0000:01: resource 1 mem: [0xdfe00000-0xdfefffff]                                                                                                            
[    0.225029] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]                                                                                                                      
[    0.225033] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]                                                                                                      
[    0.225135] NET: Registered protocol family 2                                                                                                                                   
[    0.225295] IP route cache hash table entries: 32768 (order: 5, 131072 
bytes)                                                                                                   
[    0.225782] TCP established hash table entries: 131072 (order: 8, 1048576 
bytes)                                                                                                
[    0.226331] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)                                                                                                         
[    0.226679] TCP: Hash tables configured (established 131072 bind 65536)                                                                                                         
[    0.226683] TCP reno registered                                                                                                                                                 
[    0.226947] NET: Registered protocol family 1                                                                                                                                   
[    0.227043] Unpacking initramfs...                                                                                                                                              
[    0.418647] Freeing initrd memory: 6423k freed                                                                                                                                  
[    0.422727] Scanning for low memory corruption every 60 seconds                                                                                                                 
[    0.423009] audit: initializing netlink socket (disabled)                                                                                                                       
[    0.423032] type=2000 audit(1262181462.422:1): initialized                                                                                                                      
[    0.427158] highmem bounce pool size: 64 pages                                                                                                                                  
[    0.427166] HugeTLB registered 2 MB page size, pre-allocated 0 pages                                                                                                            
[    0.427321] VFS: Disk quotas dquot_6.5.2                                                                                                                                        
[    0.427383] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)                                                                                                          
[    0.427575] msgmni has been set to 430                                                                                                                                          
[    0.427718] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)                                                                                                
[    0.427723] io scheduler noop registered                                                                                                                                        
[    0.427726] io scheduler anticipatory registered                                                                                                                                
[    0.427729] io scheduler deadline registered                                                                                                                                    
[    0.427754] io scheduler cfq registered (default)                                                                                                                               
[    0.427874] pci 0000:00:02.0: Boot video device                                                                                                                                 
[    0.428156]   alloc irq_desc for 24 on node 0                                                                                                                                   
[    0.428160]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.428173] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X                                                                                                                  
[    0.428184] pcieport-driver 0000:00:1c.0: setting latency timer to 64                                                                                                           
[    0.428382]   alloc irq_desc for 25 on node 0                                                                                                                                   
[    0.428386]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.428396] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X                                                                                                                  
[    0.428406] pcieport-driver 0000:00:1c.1: setting latency timer to 64                                                                                                           
[    0.428533] pci-stub: invalid id string ""                                                                                                                                      
[    0.428703] vesafb: framebuffer at 0xe0000000, mapped to 0xf7880000, using 
5120k, total 7872k                                                                                   
[    0.428707] vesafb: mode is 1280x1024x16, linelength=2560, pages=2                                                                                                              
[    0.428710] vesafb: scrolling: redraw                                                                                                                                           
[    0.428714] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0                                                                                                                     
[    0.428962] bootsplash 3.1.6-2004/03/31: looking for picture...                                                                                                                 
[    0.450815] bootsplash: silentjpeg size 130564 bytes                                                                                                                            
[    0.483105] bootsplash: ...found (1280x1024, 29083 bytes, v3).                                                                                                                  
[    0.500834] Switched to high resolution mode on CPU 1                                                                                                                           
[    0.500975] Switched to high resolution mode on CPU 0                                                                                                                           
[    0.557334] Console: switching to colour frame buffer device 156x60                                                                                                             
[    0.630990] fb0: VESA VGA frame buffer device                                                                                                                                   
[    0.633266] Non-volatile memory driver v1.3                                                                                                                                     
[    0.633270] Linux agpgart interface v0.103                                                                                                                                      
[    0.633311] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled                                                                                                            
[    0.633421] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A                                                                                                                
[    0.634168] 00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A                                                                                                                     
[    0.634490] ata_piix 0000:00:1f.1: version 2.13                                                                                                                                 
[    0.634510]   alloc irq_desc for 22 on node 0                                                                                                                                   
[    0.634513]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.634523] ata_piix 0000:00:1f.1: PCI INT A -> GSI 22 (level, low) -> IRQ 
22                                                                                                   
[    0.634575] ata_piix 0000:00:1f.1: setting latency timer to 64                                                                                                                  
[    0.634654] scsi0 : ata_piix                                                                                                                                                    
[    0.634785] scsi1 : ata_piix                                                                                                                                                    
[    0.637040] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14                                                                                                     
[    0.637045] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15                                                                                                     
[    0.637282]   alloc irq_desc for 23 on node 0                                                                                                                                   
[    0.637285]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.637293] ata_piix 0000:00:1f.2: PCI INT B -> GSI 23 (level, low) -> IRQ 
23                                                                                                   
[    0.637300] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]                                                                                                                          
[    0.637350] ata_piix 0000:00:1f.2: setting latency timer to 64                                                                                                                  
[    0.637411] scsi2 : ata_piix                                                                                                                                                    
[    0.637489] scsi3 : ata_piix                                                                                                                                                    
[    0.639363] ata3: SATA max UDMA/133 cmd 0xb800 ctl 0xb400 bmdma 0xa400 irq 
23                                                                                                   
[    0.639367] ata4: SATA max UDMA/133 cmd 0xb000 ctl 0xa800 bmdma 0xa408 irq 
23                                                                                                   
[    0.639459] Fixed MDIO Bus: probed                                                                                                                                              
[    0.639468] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                                                                                                          
[    0.639618]   alloc irq_desc for 20 on node 0                                                                                                                                   
[    0.639621]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.639629] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 
20                                                                                                   
[    0.639648] ehci_hcd 0000:00:1d.7: setting latency timer to 64                                                                                                                  
[    0.639652] ehci_hcd 0000:00:1d.7: EHCI Host Controller                                                                                                                         
[    0.639691] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 1                                                                                                
[    0.643608] ehci_hcd 0000:00:1d.7: debug port 1                                                                                                                                 
[    0.643616] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported                                                                                                       
[    0.643634] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdfdffc00                                                                                                                    
[    0.653023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00                                                                                                                   
[    0.653074] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                                                                                                       
[    0.653079] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                                                                                  
[    0.653084] usb usb1: Product: EHCI Host Controller                                                                                                                             
[    0.653088] usb usb1: Manufacturer: Linux 2.6.31.5-0.1-desktop ehci_hcd                                                                                                         
[    0.653092] usb usb1: SerialNumber: 0000:00:1d.7                                                                                                                                
[    0.653218] usb usb1: configuration #1 chosen from 1 choice                                                                                                                     
[    0.653259] hub 1-0:1.0: USB hub found                                                                                                                                          
[    0.653269] hub 1-0:1.0: 8 ports detected                                                                                                                                       
[    0.653368] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver                                                                                                              
[    0.653390] uhci_hcd: USB Universal Host Controller Interface driver                                                                                                            
[    0.654167] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20                                                                                                   
[    0.654178] uhci_hcd 0000:00:1d.0: setting latency timer to 64                                                                                                                  
[    0.654184] uhci_hcd 0000:00:1d.0: UHCI Host Controller                                                                                                                         
[    0.654200] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 2                                                                                                
[    0.654230] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00009000                                                                                                                   
[    0.654286] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                       
[    0.654291] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                                                                                  
[    0.654296] usb usb2: Product: UHCI Host Controller                                                                                                                             
[    0.654300] usb usb2: Manufacturer: Linux 2.6.31.5-0.1-desktop uhci_hcd                                                                                                         
[    0.654305] usb usb2: SerialNumber: 0000:00:1d.0                                                                                                                                
[    0.654411] usb usb2: configuration #1 chosen from 1 choice                                                                                                                     
[    0.654449] hub 2-0:1.0: USB hub found                                                                                                                                          
[    0.654461] hub 2-0:1.0: 2 ports detected                                                                                                                                       
[    0.655159] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 
17                                                                                                   
[    0.655167] uhci_hcd 0000:00:1d.1: setting latency timer to 64                                                                                                                  
[    0.655172] uhci_hcd 0000:00:1d.1: UHCI Host Controller                                                                                                                         
[    0.655184] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 3                                                                                                
[    0.655220] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00009400                                                                                                                   
[    0.655261] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                       
[    0.655265] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                                                                                  
[    0.655269] usb usb3: Product: UHCI Host Controller                                                                                                                             
[    0.655272] usb usb3: Manufacturer: Linux 2.6.31.5-0.1-desktop uhci_hcd                                                                                                         
[    0.655275] usb usb3: SerialNumber: 0000:00:1d.1                                                                                                                                
[    0.655364] usb usb3: configuration #1 chosen from 1 choice                                                                                                                     
[    0.655401] hub 3-0:1.0: USB hub found                                                                                                                                          
[    0.655410] hub 3-0:1.0: 2 ports detected                                                                                                                                       
[    0.656163]   alloc irq_desc for 18 on node 0                                                                                                                                   
[    0.656167]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.656177] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18                                                                                                   
[    0.656187] uhci_hcd 0000:00:1d.2: setting latency timer to 64                                                                                                                  
[    0.656193] uhci_hcd 0000:00:1d.2: UHCI Host Controller                                                                                                                         
[    0.656208] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 4                                                                                                
[    0.656250] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009800                                                                                                                   
[    0.656305] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                       
[    0.656310] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                                                                                  
[    0.656314] usb usb4: Product: UHCI Host Controller                                                                                                                             
[    0.656319] usb usb4: Manufacturer: Linux 2.6.31.5-0.1-desktop uhci_hcd                                                                                                         
[    0.656323] usb usb4: SerialNumber: 0000:00:1d.2                                                                                                                                
[    0.656427] usb usb4: configuration #1 chosen from 1 choice                                                                                                                     
[    0.656465] hub 4-0:1.0: USB hub found                                                                                                                                          
[    0.656474] hub 4-0:1.0: 2 ports detected                                                                                                                                       
[    0.657158]   alloc irq_desc for 19 on node 0                                                                                                                                   
[    0.657161]   alloc kstat_irqs on node 0                                                                                                                                        
[    0.657168] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 
19                                                                                                   
[    0.657177] uhci_hcd 0000:00:1d.3: setting latency timer to 64                                                                                                                  
[    0.657181] uhci_hcd 0000:00:1d.3: UHCI Host Controller                                                                                                                         
[    0.657195] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus 
number 5                                                                                                
[    0.657231] uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000a000                                                                                                                   
[    0.657272] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001                                                                                                       
[    0.657275] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                                                                                  
[    0.657279] usb usb5: Product: UHCI Host Controller                                                                                                                             
[    0.657282] usb usb5: Manufacturer: Linux 2.6.31.5-0.1-desktop uhci_hcd                                                                                                         
[    0.657285] usb usb5: SerialNumber: 0000:00:1d.3                                                                                                                                
[    0.657380] usb usb5: configuration #1 chosen from 1 choice                                                                                                                     
[    0.657417] hub 5-0:1.0: USB hub found                                                                                                                                          
[    0.657426] hub 5-0:1.0: 2 ports detected                                                                                                                                       
[    0.657511] Initializing USB Mass Storage driver...                                                                                                                             
[    0.657555] usbcore: registered new interface driver usb-storage                                                                                                                
[    0.657559] USB Mass Storage support registered.                                                                                                                                
[    0.657598] usbcore: registered new interface driver libusual                                                                                                                   
[    0.657616] usbcore: registered new interface driver ums-alauda                                                                                                                 
[    0.657632] usbcore: registered new interface driver ums-cypress                                                                                                                
[    0.657650] usbcore: registered new interface driver ums-datafab                                                                                                                
[    0.657667] usbcore: registered new interface driver ums-freecom                                                                                                                
[    0.657684] usbcore: registered new interface driver ums-isd200                                                                                                                 
[    0.657700] usbcore: registered new interface driver ums-jumpshot                                                                                                               
[    0.657717] usbcore: registered new interface driver ums-karma                                                                                                                  
[    0.657736] usbcore: registered new interface driver ums-onetouch                                                                                                               
[    0.657754] usbcore: registered new interface driver ums-sddr09                                                                                                                 
[    0.657772] usbcore: registered new interface driver ums-sddr55                                                                                                                 
[    0.657789] usbcore: registered new interface driver ums-usbat                                                                                                                  
[    0.657867] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1                                                                                                              
[    0.657870] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp                                                                      
[    0.658306] serio: i8042 KBD port at 0x60,0x64 irq 1                                                                                                                            
[    0.658393] mice: PS/2 mouse device common for all mice                                                                                                                         
[    0.658520] rtc_cmos 00:03: RTC can wake from S4                                                                                                                                
[    0.658574] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0                                                                                                               
[    0.658602] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs                                                                                                            
[    0.658624] cpuidle: using governor ladder                                                                                                                                      
[    0.658627] cpuidle: using governor menu                                                                                                                                        
[    0.659011] usbcore: registered new interface driver hiddev                                                                                                                     
[    0.659032] usbcore: registered new interface driver usbhid                                                                                                                     
[    0.659036] usbhid: v2.6:USB HID core driver                                                                                                                                    
[    0.745414] TCP cubic registered                                                                                                                                                
[    0.745498] NET: Registered protocol family 10                                                                                                                                  
[    0.746179] lo: Disabled Privacy Extensions                                                                                                                                     
[    0.746693] lib80211: common routines for IEEE802.11 drivers                                                                                                                    
[    0.746696] lib80211_crypt: registered algorithm 'NULL'                                                                                                                         
[    0.746716] Using IPI No-Shortcut mode                                                                                                                                          
[    0.746832] PM: Checking image partition /dev/disk/by-id/ata-
Hitachi_HDS721680PLAT80_PV6805Z8S9RMEN-part3                                                                       
[    0.820784] ata1: clearing spurious IRQ                                                                                                                                         
[    0.823434] ata1: clearing spurious IRQ                                                                                                                                         
[    0.826546] ata1.00: ATA-7: Hitachi HDS721680PLAT80, P21OA8BA, max UDMA/133                                                                                                     
[    0.826552] ata1.00: 156301488 sectors, multi 16: LBA48                                                                                                                         
[    0.826615] ata1.01: ATAPI: ASUS    DRW-1608P3S, 1.06, max UDMA/66                                                                                                              
[    0.826754] ata1: clearing spurious IRQ                                                                                                                                         
[    0.829130] ata1: clearing spurious IRQ                                                                                                                                         
[    0.832459] ata1.00: configured for UDMA/100                                                                                                                                    
[    0.832534] ata1: clearing spurious IRQ                                                                                                                                         
[    0.835130] ata1: clearing spurious IRQ                                                                                                                                         
[    0.838289] ata1.01: configured for UDMA/66                                                                                                                                     
[    0.844861] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72168 P21O 
PQ: 0 ANSI: 5                                                                                        
[    0.851506] scsi 0:0:1:0: CD-ROM            ASUS     DRW-1608P3S      1.06 
PQ: 0 ANSI: 5                                                                                        
[    0.851674] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 
GB/74.5 GiB)                                                                                             
[    0.851743] sd 0:0:0:0: [sda] Write Protect is off                                                                                                                              
[    0.851747] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                                                                                           
[    0.851780] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                                                                             
[    0.851959]  sda: sda1 sda2 sda3                                                                                                                                                
[    0.886582] sd 0:0:0:0: [sda] Attached SCSI disk                                                                                                                                
[    0.886593] PM: Resume from disk failed.                                                                                                                                        
[    0.886613] registered taskstats version 1                                                                                                                                      
[    0.886773]   Magic number: 5:114:990                                                                                                                                           
[    0.886854] rtc_cmos 00:03: setting system clock to 2009-12-30 13:57:43 UTC 
(1262181463)                                                                                        
[    0.886983] Freeing unused kernel memory: 464k freed                                                                                                                            
[    0.887227] Write protecting the kernel text: 4720k                                                                                                                             
[    0.887396] Write protecting the kernel read-only data: 2704k                                                                                                                   
[    0.961082] Uniform Multi-Platform E-IDE driver                                                                                                                                 
[    0.972919] ACPI: SSDT 3f7ae0c0 001D2 (v01    AMI   CPU1PM 00000001 INTL 
20051117)                                                                                              
[    0.973526] processor LNXCPU:00: registered as cooling_device0                                                                                                                  
[    0.973532] ACPI: Processor [CPU0] (supports 8 throttling states)                                                                                                               
[    0.974021] ACPI: SSDT 3f7ae2a0 00143 (v01    AMI   CPU2PM 00000001 INTL 
20051117)                                                                                              
[    0.974571] processor LNXCPU:01: registered as cooling_device1                                                                                                                  
[    0.974577] ACPI: Processor [CPU1] (supports 8 throttling states)                                                                                                               
[    0.984982] udev: starting version 146                                                                                                                                          
[    1.108097] usb 1-3: new high speed USB device using ehci_hcd and address 4                                                                                                     
[    1.484143] usb 1-3: New USB device found, idVendor=058f, idProduct=6387                                                                                                        
[    1.484149] usb 1-3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3                                                                                                   
[    1.484153] usb 1-3: Product: USB2.0                                                                                                                                            
[    1.484156] usb 1-3: Manufacturer: Generic                                                                                                                                      
[    1.484159] usb 1-3: SerialNumber: 73BDB33F                                                                                                                                     
[    1.484312] usb 1-3: configuration #1 chosen from 1 choice                                                                                                                      
[    1.486908] scsi4 : SCSI emulation for USB Mass Storage devices                                                                                                                 
[    1.489421] usb-storage: device found at 4                                                                                                                                      
[    1.489425] usb-storage: waiting for device to settle before scanning                                                                                                           
[    1.497726] PM: Marking nosave pages: 000000000009f000 - 0000000000100000                                                                                                       
[    1.497735] PM: Basic memory bitmaps created                                                                                                                                    
[    1.509690] PM: Basic memory bitmaps freed                                                                                                                                      
[    1.520536] PM: Starting manual resume from disk                                                                                                                                
[    1.520541] PM: Resume from partition 8:3                                                                                                                                       
[    1.520544] PM: Checking hibernation image.                                                                                                                                     
[    1.520748] PM: Resume from disk failed.                                                                                                                                        
[    1.591028] usb 1-4: new high speed USB device using ehci_hcd and address 5                                                                                                     
[    1.620960] EXT4-fs (sda2): barriers enabled                                                                                                                                    
[    1.644501] kjournald2 starting: pid 236, dev sda2:8, commit interval 5 
seconds                                                                                                 
[    1.644856] EXT4-fs (sda2): internal journal on sda2:8                                                                                                                          
[    1.644864] EXT4-fs (sda2): delayed allocation enabled                                                                                                                          
[    1.644871] EXT4-fs: file extents enabled                                                                                                                                       
[    1.646560] EXT4-fs: mballoc enabled                                                                                                                                            
[    1.646582] EXT4-fs (sda2): mounted filesystem with ordered data mode                                                                                                           
[    1.705886] usb 1-4: New USB device found, idVendor=0930, idProduct=6540                                                                                                        
[    1.705891] usb 1-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3                                                                                                   
[    1.705895] usb 1-4: Product: TransMemory                                                                                                                                       
[    1.705898] usb 1-4: Manufacturer: TOSHIBA                                                                                                                                      
[    1.705901] usb 1-4: SerialNumber: 0640377110910964                                                                                                                             
[    1.706037] usb 1-4: configuration #1 chosen from 1 choice                                                                                                                      
[    1.706496] scsi5 : SCSI emulation for USB Mass Storage devices                                                                                                                 
[    1.706752] usb-storage: device found at 5                                                                                                                                      
[    1.706756] usb-storage: waiting for device to settle before scanning                                                                                                           
[    1.912033] usb 2-1: new full speed USB device using uhci_hcd and address 2                                                                                                     
[    2.090237] usb 2-1: New USB device found, idVendor=0a12, idProduct=0001                                                                                                        
[    2.090243] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0                                                                                                   
[    2.090380] usb 2-1: configuration #1 chosen from 1 choice                                                                                                                      
[    2.300037] usb 2-2: new low speed USB device using uhci_hcd and address 3                                                                                                      
[    2.471213] usb 2-2: New USB device found, idVendor=045e, idProduct=009d                                                                                                        
[    2.471220] usb 2-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0                                                                                                   
[    2.471226] usb 2-2: Product: Microsoft Wireless Optical Desktop® 2.10                                                                                                          
[    2.471231] usb 2-2: Manufacturer: Microsoft                                                                                                                                    
[    2.471370] usb 2-2: configuration #1 chosen from 1 choice                                                                                                                      
[    2.488607] input: Microsoft Microsoft Wireless Optical Desktop® 2.10 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input0                                         
[    2.488715] microsoft 0003:045E:009D.0001: input,hidraw0: USB HID v1.11 
Keyboard [Microsoft Microsoft Wireless Optical Desktop® 2.10] on 
usb-0000:00:1d.0-2/input0              
[    2.489899] scsi 4:0:0:0: Direct-Access     Generic  USB2.0           8.07 
PQ: 0 ANSI: 2                                                                                        
[    2.491489] sd 4:0:0:0: [sdb] 2057216 512-byte logical blocks: (1.05 
GB/1004 MiB)                                                                                               
[    2.491984] sd 4:0:0:0: [sdb] Write Protect is off                                                                                                                              
[    2.491989] sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00                                                                                                                           
[    2.491994] sd 4:0:0:0: [sdb] Assuming drive cache: write through                                                                                                               
[    2.492386] usb-storage: device scan complete                                                                                                                                   
[    2.494110] sd 4:0:0:0: [sdb] Assuming drive cache: write through                                                                                                               
[    2.494127]  sdb:                                                                                                                                                               
[    2.578864] input: Microsoft Microsoft Wireless Optical Desktop® 2.10 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input1                                         
[    2.579015] microsoft 0003:045E:009D.0002: input,hidraw1: USB HID v1.11 
Mouse [Microsoft Microsoft Wireless Optical Desktop® 2.10] on 
usb-0000:00:1d.0-2/input1                 
[    2.706640] scsi 5:0:0:0: Direct-Access     TOSHIBA  TransMemory      6.50 
PQ: 0 ANSI: 0 CCS                                                                                    
[    2.707486] sd 5:0:0:0: [sdc] 3903487 512-byte logical blocks: (1.99 
GB/1.86 GiB)                                                                                               
[    2.707978] sd 5:0:0:0: [sdc] Write Protect is off                                                                                                                              
[    2.707984] sd 5:0:0:0: [sdc] Mode Sense: 45 00 00 08                                                                                                                           
[    2.707989] sd 5:0:0:0: [sdc] Assuming drive cache: write through                                                                                                               
[    2.709256] usb-storage: device scan complete                                                                                                                                   
[    2.709731] sd 5:0:0:0: [sdc] Assuming drive cache: write through                                                                                                               
[    2.709750]  sdc: sdc1                                                                                                                                                          
[    2.712104] sd 5:0:0:0: [sdc] Assuming drive cache: write through                                                                                                               
[    2.712118] sd 5:0:0:0: [sdc] Attached SCSI removable disk                                                                                                                      
[    2.714479]  sdb1                                                                                                                                                               
[    2.721729] sd 4:0:0:0: [sdb] Assuming drive cache: write through                                                                                                               
[    2.721746] sd 4:0:0:0: [sdb] Attached SCSI removable disk                                                                                                                      
[    3.263568] preloadtrace: systemtap: 0.9.9/0.142, base: f7f8f000, memory: 
34052+77432+22160+13600 data+text+ctx+net, probes: 34                                                 
[    4.827763] udev: starting version 146                                                                                                                                          
[    4.868857] agpgart-intel 0000:00:00.0: Intel 945G Chipset                                                                                                                      
[    4.869370] agpgart-intel 0000:00:00.0: detected 7932K stolen memory                                                                                                            
[    4.871811] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000                                                                                                       
[    4.877910] Atheros(R) L2 Ethernet Driver - version 2.2.3                                                                                                                       
[    4.877915] Copyright (c) 2007 Atheros Corporation.                                                                                                                             
[    4.878039] atl2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17                                                                                                       
[    4.878053] atl2 0000:02:00.0: setting latency timer to 64                                                                                                                      
[    4.892080] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2                                                                                                
[    4.892166] ACPI: Power Button [PWRF]                                                                                                                                           
[    4.892274] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3                                                                                       
[    4.892315] ACPI: Power Button [PWRB]                                                                                                                                           
[    5.021149] Floppy drive(s): fd0 is 1.44M                                                                                                                                       
[    5.035325] sd 0:0:0:0: Attached scsi generic sg0 type 0                                                                                                                        
[    5.035371] scsi 0:0:1:0: Attached scsi generic sg1 type 5                                                                                                                      
[    5.035413] sd 4:0:0:0: Attached scsi generic sg2 type 0                                                                                                                        
[    5.035455] sd 5:0:0:0: Attached scsi generic sg3 type 0                                                                                                                        
[    5.035829] input: PC Speaker as /devices/platform/pcspkr/input/input4                                                                                                          
[    5.037190] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 
19                                                                                                  
[    5.037225] HDA Intel 0000:00:1b.0: setting latency timer to 64                                                                                                                 
[    5.039571] FDC 0 is a post-1991 82077                                                                                                                                          
[    5.053386] intel_rng: FWH not detected                                                                                                                                         
[    5.057628] parport_pc 00:07: reported by Plug and Play ACPI                                                                                                                    
[    5.057739] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]                                                                               
[    5.070800] Bluetooth: Core ver 2.15                                                                                                                                            
[    5.073605] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 
cdda tray                                                                                               
[    5.073612] Uniform CD-ROM driver Revision: 3.20                                                                                                                                
[    5.073765] sr 0:0:1:0: Attached scsi CD-ROM sr0                                                                                                                                
[    5.073853] NET: Registered protocol family 31                                                                                                                                  
[    5.073856] Bluetooth: HCI device and connection manager initialized                                                                                                            
[    5.073860] Bluetooth: HCI socket layer initialized                                                                                                                             
[    5.083315] Bluetooth: Generic Bluetooth USB driver ver 0.5                                                                                                                     
[    5.083444] usbcore: registered new interface driver btusb                                                                                                                      
[    5.143042] iTCO_vendor_support: vendor-support=0                                                                                                                               
[    5.144640] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05                                                                                                                     
[    5.144763] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, 
TCOBASE=0x0860)                                                                                              
[    5.144843] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)                                                                                                                
[    5.163075] saa7146: register extension 'budget_ci dvb'.                                                                                                                        
[    5.165599] ppdev: user-space parallel port driver                                                                                                                              
[    5.167174] budget_ci dvb 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17                                                                                              
[    5.167229] IRQ 17/: IRQF_DISABLED is not guaranteed on shared IRQs                                                                                                             
[    5.167244] saa7146: found saa7146 @ mem f881ec00 (revision 1, irq 17) 
(0x13c2,0x1019).                                                                                         
[    5.167254] saa7146 (0): dma buffer size 192512                                                                                                                                 
[    5.167258] DVB: registering new adapter (TT-Budget S2-3200 PCI)                                                                                                                
[    5.186103] adapter has MAC addr = 00:d0:5c:64:a7:3a                                                                                                                            
[    5.186913] input: Budget-CI dvb ir receiver saa7146 (0) as 
/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/input/input5                                                          
[    8.703883] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6                                                                                          
[    8.709491] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, low) -> 
IRQ 23                                                                                                 
[    9.831371] stb0899_attach: Attaching STB0899                                                                                                                                   
[    9.848076] stb6100_attach: Attaching STB6100                                                                                                                                   
[    9.872406] LNBx2x attached on addr=8                                                                                                                                           
[    9.872413] DVB: registering adapter 0 frontend 0 (STB0899 
Multistandard)...                                                                                                    
[   10.092329] Adding 10485496k swap on /dev/sda3.  Priority:-1 extents:1 
across:10485496k                                                                                         
[   10.576226] device-mapper: uevent: version 1.0.3                                                                                                                                
[   10.576425] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: 
dm-devel@redhat.com                                                                                    
[   10.777448] loop: module loaded                                                                                                                                                 
[   11.011001] fuse init (API version 7.12)                                                                                                                                        
[   12.618662] type=1505 audit(1262181475.231:2): operation="profile_load" 
pid=1047 name=/bin/ping                                                                                 
[   12.690796] type=1505 audit(1262181475.303:3): operation="profile_load" 
pid=1048 name=/sbin/klogd                                                                               
[   12.795113] type=1505 audit(1262181475.408:4): operation="profile_load" 
pid=1049 name=/sbin/syslog-ng                                                                           
[   12.897724] type=1505 audit(1262181475.510:5): operation="profile_load" 
pid=1050 name=/sbin/syslogd                                                                             
[   13.000219] type=1505 audit(1262181475.613:6): operation="profile_load" 
pid=1051 name=/usr/sbin/avahi-daemon                                                                    
[   13.105214] type=1505 audit(1262181475.718:7): operation="profile_load" 
pid=1052 name=/usr/sbin/identd                                                                          
[   13.200792] type=1505 audit(1262181475.813:8): operation="profile_load" 
pid=1053 name=/usr/sbin/mdnsd                                                                           
[   13.307549] type=1505 audit(1262181475.920:9): operation="profile_load" 
pid=1054 name=/usr/sbin/nscd                                                                            
[   13.461335] type=1505 audit(1262181476.074:10): operation="profile_load" 
pid=1055 name=/usr/sbin/ntpd                                                                           
[   13.566301] type=1505 audit(1262181476.179:11): operation="profile_load" 
pid=1056 name=/usr/sbin/traceroute                                                                     
[   15.367161] ip6_tables: (C) 2000-2006 Netfilter Core Team                                                                                                                       
[   15.457898] ip_tables: (C) 2000-2006 Netfilter Core Team                                                                                                                        
[   15.493746] nf_conntrack version 0.5.0 (15833 buckets, 63332 max)                                                                                                               
[   15.493891] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. 
Please use                                                                                                
[   15.493900] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack 
module option or
[   15.493907] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   18.005668] powernow: This module only works with AMD K7 CPUs
[   18.700370] [drm] Initialized drm 1.1.0 20060810
[   18.756021] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   18.756035] pci 0000:00:02.0: setting latency timer to 64
[   18.759542] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0
[   19.257591]   alloc irq_desc for 26 on node 0
[   19.257598]   alloc kstat_irqs on node 0
[   19.257639] atl2 0000:02:00.0: irq 26 for MSI/MSI-X
[   19.258044] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.462361] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   19.462673] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   19.613600] NET: Registered protocol family 17
[   28.104213] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[   28.595268] Bluetooth: L2CAP ver 2.13
[   28.595279] Bluetooth: L2CAP socket layer initialized
[   28.892954] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   28.892966] Bluetooth: BNEP filters: protocol multicast
[   29.484008] eth0: no IPv6 routers present
[   30.028120] Bridge firewalling registered
[   30.324679] Bluetooth: SCO (Voice Link) ver 0.6
[   30.324691] Bluetooth: SCO socket layer initialized
[   30.624625] Bluetooth: RFCOMM TTY layer initialized
[   30.624641] Bluetooth: RFCOMM socket layer initialized
[   30.624649] Bluetooth: RFCOMM ver 1.11
[   30.903840] bootsplash: status on console 0 changed to on
[   34.647778] CPU0 attaching NULL sched-domain.
[   34.647787] CPU1 attaching NULL sched-domain.
[   34.651139] CPU0 attaching sched-domain:
[   34.651146]  domain 0: span 0-1 level MC
[   34.651151]   groups: 0 1
[   34.651160]   domain 1: span 0-1 level NODE
[   34.651165]    groups: 0-1
[   34.651174] CPU1 attaching sched-domain:
[   34.651178]  domain 0: span 0-1 level MC
[   34.651183]   groups: 1 0
[   34.651191]   domain 1: span 0-1 level NODE
[   34.651196]    groups: 0-1
[  193.214449] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=10474 DF PROTO=TCP SPT=45217 DPT=80 
WINDOW=1554 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFE5EDEA072888C)
[  198.934057] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=49261 DF PROTO=TCP SPT=45220 DPT=80 
WINDOW=544 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFE7536A0728986)
[  199.501040] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=59289 DF PROTO=TCP SPT=45221 DPT=80 
WINDOW=544 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFE776DA0728986)
[  200.580046] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=37629 DF PROTO=TCP SPT=45215 DPT=80 
WINDOW=1002 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFE7BA4A072888C)
[  201.850057] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=63.245.209.93 
LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=11378 DF PROTO=TCP SPT=60031 DPT=80 
WINDOW=6948 RES=0x00 ACK FIN URGP=0
[  214.423044] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=30672 DF PROTO=TCP SPT=45218 DPT=80 
WINDOW=1002 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFEB1B7A072888C)
[  244.600050] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=212.58.226.75 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=16315 DF PROTO=TCP SPT=37020 DPT=80 
WINDOW=997 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFF2798437A8FC9)
[  248.815294] DVB: adapter 0 frontend 0 symbol rate 4800000 out of range 
(5000000..45000000)
[  249.024289] DVB: adapter 0 frontend 0 symbol rate 4800000 out of range 
(5000000..45000000)
[  259.390044] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=10475 DF PROTO=TCP SPT=45217 DPT=80 
WINDOW=1554 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFF615EA072888C)
[  274.180042] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=37630 DF PROTO=TCP SPT=45215 DPT=80 
WINDOW=1002 RES=0x00 ACK FIN URGP=0 OPT (0101080AFFFF9B24A072888C)
[  301.975042] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=30673 DF PROTO=TCP SPT=45218 DPT=80 
WINDOW=1002 RES=0x00 ACK FIN URGP=0 OPT (0101080A000007B7A072888C)
[  313.450051] SFW2-OUT-ERROR IN= OUT=eth0 SRC=192.168.2.100 DST=83.168.206.53 
LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=34625 DF PROTO=TCP SPT=45206 DPT=80 
WINDOW=1454 RES=0x00 ACK FIN URGP=0 OPT (0101080A0000348AA0728A81)
linux-o2b8:~ #


linux-o2b8:~ # lsmod
Module                  Size  Used by
ip6t_LOG                6468  6     
xt_tcpudp               3136  2     
xt_pkttype              1632  3     
xt_physdev              2384  2     
ipt_LOG                 6276  6     
xt_limit                2692  12    
rfcomm                 75312  4     
sco                    20004  2     
bridge                 63476  1     
stp                     2532  1 bridge
llc                     7020  2 bridge,stp
bnep                   18624  2          
l2cap                  43168  16 rfcomm,bnep
snd_pcm_oss            51616  0            
snd_mixer_oss          19072  1 snd_pcm_oss
snd_seq                64752  0            
snd_seq_device          8620  1 snd_seq    
edd                    10472  0            
af_packet              23424  0            
i915                  248968  1            
drm                   184896  2 i915       
i2c_algo_bit            6884  1 i915       
video                  24600  1 i915       
cpufreq_conservative     8396  0           
cpufreq_userspace       3332  0            
cpufreq_powersave       1568  0            
acpi_cpufreq            9452  0            
speedstep_lib           5092  0            
ip6t_REJECT             5472  3            
nf_conntrack_ipv6      22036  4            
ip6table_raw            3008  1            
xt_NOTRACK              1632  4            
ipt_REJECT              3168  3
xt_state                2208  8
iptable_raw             2848  1
iptable_filter          3616  1
ip6table_mangle         4160  0
nf_conntrack_netbios_ns     2560  0
nf_conntrack_ipv4      11688  4
nf_conntrack           85660  5 
nf_conntrack_ipv6,xt_NOTRACK,xt_state,nf_conntrack_netbios_ns,nf_conntrack_ipv4
nf_defrag_ipv4          2112  1 nf_conntrack_ipv4
ip_tables              13392  2 iptable_raw,iptable_filter
ip6table_filter         3616  1
ip6_tables             14832  4 
ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter
x_tables               19524  12 
ip6t_LOG,xt_tcpudp,xt_pkttype,xt_physdev,ipt_LOG,xt_limit,ip6t_REJECT,xt_NOTRACK,ipt_REJECT,xt_state,ip_tables,ip6_tables
fuse                   74268  3
loop                   17228  0
dm_mod                 84804  0
lnbp21                  2816  1
stb6100                 7780  1
stb0899                37252  1
snd_hda_codec_realtek   233604  1
ppdev                  10276  0
budget_ci              25240  0
budget_core            10628  1 budget_ci
iTCO_wdt               12164  0
iTCO_vendor_support     3876  1 iTCO_wdt
dvb_core               98692  2 budget_ci,budget_core
saa7146                19880  2 budget_ci,budget_core
ttpci_eeprom            2144  1 budget_core
btusb                  16916  2
bluetooth             103524  9 rfcomm,sco,bnep,l2cap,btusb
parport_pc             40356  0
serio_raw               6276  0
sr_mod                 17572  0
cdrom                  40768  1 sr_mod
ir_common              49284  1 budget_ci
pcspkr                  2784  0
sg                     32884  0
joydev                 11232  0
i2c_i801               12788  0
parport                39948  2 ppdev,parport_pc
floppy                 61220  0
rfkill                 22772  1 bluetooth
snd_hda_intel          31584  2
snd_hda_codec          94688  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               8708  1 snd_hda_codec
snd_pcm                96324  3 snd_pcm_oss,snd_hda_intel,snd_hda_codec
snd_timer              25960  2 snd_seq,snd_pcm
snd                    75236  14 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
asus_atk0110           13888  0
button                  6608  0
atl2                   30264  0
snd_page_alloc         10600  2 snd_hda_intel,snd_pcm
intel_agp              31012  1
ext4                  359524  1
jbd2                   95584  1 ext4
crc16                   1952  1 ext4
fan                     5028  0
processor              50576  1 acpi_cpufreq
ide_pci_generic         4036  0
piix                    6760  0
ide_core              122572  2 ide_pci_generic,piix
ata_generic             4836  0
thermal                21084  0
thermal_sys            18344  4 video,fan,processor,thermal
linux-o2b8:~ #

linux-o2b8:~ # lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 82945G/GZ/P/PL Memory Controller 
Hub [8086:2770] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation 82945G/GZ 
Integrated Graphics Controller [8086:2772] (rev 02)
00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller [8086:27d8] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 [8086:27d0] (rev 01)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 2 [8086:27d2] (rev 01)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #1 [8086:27c8] (rev 01)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #2 [8086:27c9] (rev 01)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #3 [8086:27ca] (rev 01)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #4 [8086:27cb] (rev 01)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 
EHCI Controller [8086:27cc] (rev 01)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 
e1)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GB/GR (ICH7 Family) LPC 
Interface Bridge [8086:27b8] (rev 01)
00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE 
Controller [8086:27df] (rev 01)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GB/GR/GH (ICH7 Family) 
SATA IDE Controller [8086:27c0] (rev 01)
00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
[8086:27da] (rev 01)
01:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 
[1131:7146] (rev 01)
02:00.0 Ethernet controller [0200]: Attansic Technology Corp. L2 100 Mbit 
Ethernet Adapter [1969:2048] (rev a0)
linux-o2b8:~ #

I also want to communicate, I tried installing the v4l-dvb drivers and do not 
work. The computer does not start, if you take the card starts. If way to get 
a log of the boot of the computer that can display the error, even if the 
interest is mine, I will be the provision. Thanks

