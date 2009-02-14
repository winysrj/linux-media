Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s20.bay0.hotmail.com ([65.54.246.220]:57549 "EHLO
	bay0-omc3-s20.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbZBNSFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 13:05:10 -0500
Message-ID: <BAY102-W3919BC0C2532C366EEDB1FCFB90@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_HVR-1500_tuner_seems_to_be_recognized=2C_but_wont_tu?=
 =?windows-1256?Q?rn_on.=FE?=
Date: Sat, 14 Feb 2009 12:05:09 -0600
In-Reply-To: <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>





> That looks really suspicious.  Perhaps the xc3028 tuner is being put
> to sleep and not being woken up properly.
> 
> Could you please post the full dmesg output showing the initialization
> of the device?
> 
> Devin


I turned kubuntu on, shut off the backend for mythtv and then did a scan using dvbscan.

Here is the full dmesg output, sorry it is long I wanted to include it all in case i missed anything.:


dmesg

[    0.000000] Initializing cgroup subsys cpuset                                
[    0.000000] Initializing cgroup subsys cpu                                   
[    0.000000] Linux version 2.6.27-11-generic (buildd@crested) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Thu Jan 29 19:28:32 UTC 2009 (Ubuntu 2.6.27-11.27-generic)                                                                 
[    0.000000] Command line: root=UUID=86e1e836-d4a6-436a-b0de-46e937be9a64 ro quiet splash                                                                     
[    0.000000] KERNEL supported cpus:                                           
[    0.000000]   Intel GenuineIntel                                             
[    0.000000]   AMD AuthenticAMD                                               
[    0.000000]   Centaur CentaurHauls                                           
[    0.000000] BIOS-provided physical RAM map:                                  
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)         
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)       
[    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)       
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000d7e70000 (usable)         
[    0.000000]  BIOS-e820: 00000000d7e70000 - 00000000d7e83000 (ACPI data)      
[    0.000000]  BIOS-e820: 00000000d7e83000 - 00000000d7e85000 (ACPI NVS)       
[    0.000000]  BIOS-e820: 00000000d7e85000 - 00000000f0000000 (reserved)       
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)       
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)       
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)       
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)         
[    0.000000] DMI present.                                                     
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x3ffffffff                   
[    0.000000] last_pfn = 0xd7e70 max_arch_pfn = 0x3ffffffff                    
[    0.000000] init_memory_mapping                                              
[    0.000000]  0000000000 - 00d7e00000 page 2M                                 
[    0.000000]  00d7e00000 - 00d7e70000 page 4k                                 
[    0.000000] kernel direct mapping tables up to d7e70000 @ 8000-e000          
[    0.000000] last_map_addr: d7e70000 end: d7e70000                            
[    0.000000] init_memory_mapping                                              
[    0.000000]  0100000000 - 0120000000 page 2M                                 
[    0.000000] kernel direct mapping tables up to 120000000 @ c000-12000        
[    0.000000] last_map_addr: 120000000 end: 120000000                          
[    0.000000] RAMDISK: 377a7000 - 37fef1d1                                     
[    0.000000] ACPI: RSDP 000F7260, 0024 (r2 TOSCPL)                            
[    0.000000] ACPI: XSDT D7E7AA18, 0064 (r1 TOSCPL TOSCPL00  6040000  LTP        0)                                                                            
[    0.000000] ACPI: FACP D7E828F7, 00F4 (r3 TOSCPL Herring   6040000 ATI     F4240)                                                                            
[    0.000000] ACPI: DSDT D7E7AA7C, 7E7B (r1 TOSCPL    SB600  6040000 MSFT  3000000)                                                                            
[    0.000000] ACPI: FACS D7E84FC0, 0040                                        
[    0.000000] ACPI: TCPA D7E82A5F, 0032 (r2 TOSCPL           6040000 PTEC        0)                                                                            
[    0.000000] ACPI: SLIC D7E82A91, 0176 (r1 TOSCPL TOSCPL00  6040000 LOHR        0)                                                                            
[    0.000000] ACPI: SSDT D7E82C07, 0206 (r1 PTLTD  POWERNOW  6040000  LTP        1)                                                                            
[    0.000000] ACPI: APIC D7E82E0D, 0054 (r1 PTLTD       APIC    6040000  LTP        0)                                                                         
[    0.000000] ACPI: MCFG D7E82E61, 003C (r1 PTLTD    MCFG    6040000  LTP        0)                                                                            
[    0.000000] ACPI: HPET D7E82E9D, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)                                                                            
[    0.000000] ACPI: ASF! D7E82ED5, 012B (r32    DMA AMDTBL    6040000 PTL         1)                                                                           
[    0.000000] ACPI: DMI detected: Toshiba                                      
[    0.000000] Scanning NUMA topology in Northbridge 24                         
[    0.000000] No NUMA configuration found                                      
[    0.000000] Faking a node at 0000000000000000-0000000120000000               
[    0.000000] Bootmem setup node 0 0000000000000000-0000000120000000           
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]                
[    0.000000]   bootmap [000000000000d000 -  0000000000030fff] pages 24        
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0120000000]     
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]                                                                    
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]                                                                    
[    0.000000]   #2 [0000200000 - 00008b9f5c]    TEXT DATA BSS ==> [0000200000 - 00008b9f5c]                                                                    
[    0.000000]   #3 [00377a7000 - 0037fef1d1]          RAMDISK ==> [00377a7000 - 0037fef1d1]                                                                    
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]                                                                    
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]                                                                    
[    0.000000]   #6 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]                                                                    
[    0.000000] found SMP MP-table at [ffff8800000f7300] 000f7300                
[    0.000000]  [ffffe20000000000-ffffe200047fffff] PMD -> [ffff880028200000-ffff88002bffffff] on node 0                                                        
[    0.000000] Zone PFN ranges:                                                 
[    0.000000]   DMA      0x00000000 -> 0x00001000                              
[    0.000000]   DMA32    0x00001000 -> 0x00100000                              
[    0.000000]   Normal   0x00100000 -> 0x00120000                              
[    0.000000] Movable zone start PFN for each node                             
[    0.000000] early_node_map[3] active PFN ranges                              
[    0.000000]     0: 0x00000000 -> 0x0000009d                                  
[    0.000000]     0: 0x00000100 -> 0x000d7e70                                  
[    0.000000]     0: 0x00100000 -> 0x00120000                                  
[    0.000000] On node 0 totalpages: 1015309                                    
[    0.000000]   DMA zone: 2104 pages, LIFO batch:0                             
[    0.000000]   DMA32 zone: 863920 pages, LIFO batch:31                        
[    0.000000]   Normal zone: 129024 pages, LIFO batch:31                       
[    0.000000] Detected use of extended apic ids on hypertransport bus          
[    0.000000] ACPI: PM-Timer IO Port: 0x8008                                   
[    0.000000] ACPI: Local APIC address 0xfee00000                              
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)               
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)               
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])              
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])              
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])          
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23    
[    0.000000] ACPI: IRQ9 used by override.                                     
[    0.000000] Setting APIC routing to flat                                     
[    0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000                       
[    0.000000] Using ACPI (MADT) for SMP configuration information              
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs                             
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000d7e70000 - 00000000d7e83000
[    0.000000] PM: Registered nosave memory: 00000000d7e83000 - 00000000d7e85000
[    0.000000] PM: Registered nosave memory: 00000000d7e85000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)                                                                            
[    0.000000] PERCPU: Allocating 64928 bytes of per cpu data                   
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1                        
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 995048                                                                      
[    0.000000] Policy zone: Normal                                              
[    0.000000] Kernel command line: root=UUID=86e1e836-d4a6-436a-b0de-46e937be9a64 ro quiet splash                                                              
[    0.000000] Initializing CPU#0                                               
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)            
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.                       
[    0.000000] TSC: using PMTIMER calibration value                             
[    0.000000] Detected 1895.241 MHz processor.                                 
[    0.004000] Console: colour VGA+ 80x25                                       
[    0.004000] console [tty0] enabled                                           
[    0.004000] Checking aperture...                                             
[    0.004000] No AGP bridge found                                              
[    0.004000] Node 0: aperture @ 264000000 size 32 MB                          
[    0.004000] Aperture beyond 4GB. Ignoring.                                   
[    0.004000] Your BIOS doesn't leave a aperture memory hole                   
[    0.004000] Please enable the IOMMU option in the BIOS setup                 
[    0.004000] This costs you 64 MB of RAM                                      
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000                 
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.004000] Memory: 3916464k/4718592k available (3116k kernel code, 144772k reserved, 1575k data, 540k init)                                                 
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated             
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1                                                                          
[    0.004000] hpet clockevent registered                                       
[    0.004009] Calibrating delay loop (skipped), value calculated using timer frequency.. 3790.48 BogoMIPS (lpj=7580964)                                        
[    0.004038] Security Framework initialized                                   
[    0.004045] SELinux:  Disabled at boot.                                      
[    0.004060] AppArmor: AppArmor initialized                                   
[    0.004540] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)                                                                               
[    0.007572] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes) 
[    0.008861] Mount-cache hash table entries: 256                              
[    0.009062] Initializing cgroup subsys ns                                    
[    0.009066] Initializing cgroup subsys cpuacct                               
[    0.009069] Initializing cgroup subsys memory                                
[    0.009086] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.009089] CPU: L2 Cache: 512K (64 bytes/line)                              
[    0.009092] CPU 0/0 -> Node 0                                                
[    0.009093] tseg: 00d7f00000                                                 
[    0.009095] CPU: Physical Processor ID: 0                                    
[    0.009097] CPU: Processor Core ID: 0                                        
[    0.009107] using C1E aware idle routine                                     
[    0.010608] ACPI: Core revision 20080609                                     
[    0.013584] ACPI: Checking initramfs for custom DSDT                         
[    0.408468] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1             
[    0.416026] ..MP-BIOS bug: 8254 timer not connected to IO-APIC               
[    0.416026] ...trying to set up timer (IRQ0) through the 8259A ...           
[    0.416026] ..... (found apic 0 pin 0) ...                                   
[    0.459567] ....... works.                                                   
[    0.459568] CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02   
[    0.459573] Using local APIC timer interrupts.                               
[    0.460030] APIC timer calibration result 12468700                           
[    0.460032] Detected 12.468 MHz APIC timer.                                  
[    0.460211] Booting processor 1/1 ip 6000                                    
[    0.004000] Initializing CPU#1                                               
[    0.004000] Calibrating delay using timer specific routine.. 3790.53 BogoMIPS (lpj=7581061)                                                                  
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)                              
[    0.004000] CPU 1/1 -> Node 0                                                
[    0.004000] CPU: Physical Processor ID: 0                                    
[    0.004000] CPU: Processor Core ID: 1                                        
[    0.548188] CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02   
[    0.548216] Brought up 2 CPUs                                                
[    0.548218] Total of 2 processors activated (7581.01 BogoMIPS).              
[    0.548057] System has AMD C1E enabled                                       
[    0.548068] Switch to broadcast mode on CPU1                                 
[    0.548263] CPU0 attaching sched-domain:                                     
[    0.548266]  domain 0: span 0-1 level CPU                                    
[    0.548269]   groups: 0 1                                                    
[    0.548273]   domain 1: span 0-1 level NODE                                  
[    0.548275]    groups: 0-1                                                   
[    0.548280] CPU1 attaching sched-domain:                                     
[    0.548282]  domain 0: span 0-1 level CPU                                    
[    0.548283]   groups: 1 0                                                    
[    0.548287]   domain 1: span 0-1 level NODE                                  
[    0.548289]    groups: 0-1                                                   
[    0.548388] Switch to broadcast mode on CPU0                                 
[    0.548388] net_namespace: 1552 bytes                                        
[    0.548388] Booting paravirtualized kernel on bare hardware                  
[    0.548388] Time: 11:43:50  Date: 02/14/09                                   
[    0.548411] NET: Registered protocol family 16                               
[    0.548437] node 0 link 0: io port [1000, fffff]                             
[    0.548437] TOM: 00000000e0000000 aka 3584M                                  
[    0.548437] node 0 link 0: mmio [f8300000, ffffffff]                         
[    0.548437] node 0 link 0: mmio [f8200000, f82fffff]                         
[    0.548437] node 0 link 0: mmio [f8000000, f81fffff]                         
[    0.548437] node 0 link 0: mmio [f0000000, f7ffffff]                         
[    0.548437] node 0 link 0: mmio [a0000, bffff]                               
[    0.548437] node 0 link 0: mmio [f0000000, efffffff]                         
[    0.548437] node 0 link 0: mmio [e0000000, efffffff]                         
[    0.548437] node 0 link 0: mmio [e0000000, dfffffff]                         
[    0.548437] TOM2: 0000000120000000 aka 4608M                                 
[    0.548437] bus: [00,ff] on node 0 link 0                                    
[    0.548437] bus: 00 index 0 io port: [0, ffff]                               
[    0.548437] bus: 00 index 1 mmio: [e0000000, ffffffff]                       
[    0.548437] bus: 00 index 2 mmio: [a0000, bffff]                             
[    0.548437] bus: 00 index 3 mmio: [120000000, fcffffffff]                    
[    0.548437] ACPI: bus type pci registered                                    
[    0.548437] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 29  
[    0.548437] PCI: MCFG area at e0000000 reserved in E820                      
[    0.549711] PCI: Using MMCONFIG at e0000000 - e1dfffff                       
[    0.549713] PCI: Using configuration type 1 for base access                  
[    0.552964] ACPI: EC: Look up EC in DSDT                                     
[    0.555719] ACPI Error (evregion-0315): No handler for Region [ERAM] (ffff88011fa35d80) [EmbeddedControl] [20080609]                                         
[    0.555725] ACPI Error (exfldio-0291): Region EmbeddedControl(3) has no handler [20080609]                                                                   
[    0.555731] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.HTEV] (Node ffff88011fa335c0), AE_NOT_EXIST                                      
[    0.555780] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.LPC0.EC0_._REG] (Node ffff88011fa3b960), AE_NOT_EXIST                       
[    0.558362] ACPI: BIOS _OSI(Linux) query ignored via DMI                     
[    0.560693] ACPI: Interpreter enabled                                        
[    0.560696] ACPI: (supports S0 S3 S4 S5)                                     
[    0.560713] ACPI: Using IOAPIC for interrupt routing                         
[    0.560907] ACPI: EC: non-query interrupt received, switching to interrupt mode                                                                              
[    0.636567] ACPI: EC: GPE = 0x13, I/O: command/status = 0x66, data = 0x62    
[    0.636567] ACPI: EC: driver started in interrupt mode                       
[    0.636567] ACPI: PCI Root Bridge [PCI0] (0000:00)                           
[    0.636567] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold            
[    0.636567] pci 0000:00:05.0: PME# disabled                                  
[    0.636567] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold            
[    0.636567] pci 0000:00:06.0: PME# disabled                                  
[    0.636567] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold            
[    0.636567] pci 0000:00:07.0: PME# disabled                                  
[    0.636567] PCI: 0000:00:12.0 reg 10 io port: [8440, 8447]                   
[    0.636567] PCI: 0000:00:12.0 reg 14 io port: [8434, 8437]                   
[    0.636567] PCI: 0000:00:12.0 reg 18 io port: [8438, 843f]                   
[    0.636567] PCI: 0000:00:12.0 reg 1c io port: [8430, 8433]                   
[    0.636567] PCI: 0000:00:12.0 reg 20 io port: [8400, 840f]                   
[    0.636567] PCI: 0000:00:12.0 reg 24 32bit mmio: [f8909000, f89093ff]        
[    0.636567] pci 0000:00:12.0: set SATA to AHCI mode                          
[    0.636567] PCI: 0000:00:13.0 reg 10 32bit mmio: [f8904000, f8904fff]        
[    0.636567] PCI: 0000:00:13.1 reg 10 32bit mmio: [f8905000, f8905fff]        
[    0.636567] PCI: 0000:00:13.2 reg 10 32bit mmio: [f8906000, f8906fff]        
[    0.636567] PCI: 0000:00:13.3 reg 10 32bit mmio: [f8907000, f8907fff]        
[    0.636567] PCI: 0000:00:13.4 reg 10 32bit mmio: [f8908000, f8908fff]        
[    0.636599] PCI: 0000:00:13.5 reg 10 32bit mmio: [f8909400, f89094ff]        
[    0.636647] pci 0000:00:13.5: supports D1                                    
[    0.636649] pci 0000:00:13.5: supports D2                                    
[    0.636651] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot             
[    0.636656] pci 0000:00:13.5: PME# disabled                                  
[    0.636687] PCI: 0000:00:14.0 reg 10 io port: [8410, 841f]                   
[    0.636748] PCI: 0000:00:14.1 reg 10 io port: [1f0, 1f7]                     
[    0.636755] PCI: 0000:00:14.1 reg 14 io port: [3f4, 3f7]                     
[    0.636762] PCI: 0000:00:14.1 reg 18 io port: [0, 7]                         
[    0.636769] PCI: 0000:00:14.1 reg 1c io port: [0, 3]                         
[    0.636776] PCI: 0000:00:14.1 reg 20 io port: [8420, 842f]                   
[    0.636830] PCI: 0000:00:14.2 reg 10 64bit mmio: [f8900000, f8903fff]        
[    0.636871] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold            
[    0.636875] pci 0000:00:14.2: PME# disabled                                  
[    0.637058] PCI: 0000:01:05.0 reg 10 64bit mmio: [f0000000, f7ffffff]        
[    0.637064] PCI: 0000:01:05.0 reg 18 64bit mmio: [f8300000, f830ffff]        
[    0.637068] PCI: 0000:01:05.0 reg 20 io port: [9000, 90ff]                   
[    0.637072] PCI: 0000:01:05.0 reg 24 32bit mmio: [f8200000, f82fffff]        
[    0.637081] pci 0000:01:05.0: supports D1                                    
[    0.637083] pci 0000:01:05.0: supports D2                                    
[    0.637097] PCI: bridge 0000:00:01.0 io port: [9000, 9fff]                   
[    0.637100] PCI: bridge 0000:00:01.0 32bit mmio: [f8200000, f83fffff]        
[    0.637104] PCI: bridge 0000:00:01.0 64bit mmio pref: [f0000000, f7ffffff]   
[    0.637155] PCI: 0000:0b:00.0 reg 10 64bit mmio: [f8000000, f81fffff]        
[    0.637231] pci 0000:0b:00.0: supports D1                                    
[    0.637233] pci 0000:0b:00.0: supports D2                                    
[    0.637235] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot             
[    0.637241] pci 0000:0b:00.0: PME# disabled                                  
[    0.637288] PCI: bridge 0000:00:05.0 32bit mmio: [f8000000, f81fffff]        
[    0.637336] PCI: 0000:11:00.0 reg 10 io port: [a000, a0ff]                   
[    0.637354] PCI: 0000:11:00.0 reg 18 64bit mmio: [f8500000, f8500fff]        
[    0.637372] PCI: 0000:11:00.0 reg 30 32bit mmio: [0, 1ffff]                  
[    0.637390] pci 0000:11:00.0: supports D1                                    
[    0.637391] pci 0000:11:00.0: supports D2                                    
[    0.637393] pci 0000:11:00.0: PME# supported from D1 D2 D3hot D3cold         
[    0.637398] pci 0000:11:00.0: PME# disabled                                  
[    0.637444] PCI: bridge 0000:00:06.0 io port: [a000, afff]                   
[    0.637447] PCI: bridge 0000:00:06.0 32bit mmio: [f8500000, f85fffff]        
[    0.637489] PCI: 0000:17:00.0 reg 10 64bit mmio: [f8400000, f840ffff]        
[    0.637579] PCI: bridge 0000:00:07.0 32bit mmio: [f8400000, f84fffff]        
[    0.637633] PCI: 0000:1d:04.0 reg 10 32bit mmio: [f8604000, f8604fff]        
[    0.637653] pci 0000:1d:04.0: supports D1                                    
[    0.637655] pci 0000:1d:04.0: supports D2                                    
[    0.637657] pci 0000:1d:04.0: PME# supported from D0 D1 D2 D3hot D3cold      
[    0.637663] pci 0000:1d:04.0: PME# disabled                                  
[    0.637702] PCI: 0000:1d:04.1 reg 10 32bit mmio: [f8606000, f86067ff]        
[    0.637712] PCI: 0000:1d:04.1 reg 14 32bit mmio: [f8600000, f8603fff]        
[    0.637766] pci 0000:1d:04.1: supports D1                                    
[    0.637767] pci 0000:1d:04.1: supports D2                                    
[    0.637769] pci 0000:1d:04.1: PME# supported from D0 D1 D2 D3hot             
[    0.637775] pci 0000:1d:04.1: PME# disabled                                  
[    0.637814] PCI: 0000:1d:04.2 reg 10 32bit mmio: [f8605000, f8605fff]        
[    0.637872] pci 0000:1d:04.2: supports D1                                    
[    0.637873] pci 0000:1d:04.2: supports D2                                    
[    0.637875] pci 0000:1d:04.2: PME# supported from D0 D1 D2 D3hot             
[    0.637881] pci 0000:1d:04.2: PME# disabled                                  
[    0.637919] PCI: 0000:1d:04.3 reg 10 32bit mmio: [f8606800, f86068ff]        
[    0.637978] pci 0000:1d:04.3: supports D1                                    
[    0.637979] pci 0000:1d:04.3: supports D2                                    
[    0.637981] pci 0000:1d:04.3: PME# supported from D0 D1 D2 D3hot             
[    0.637987] pci 0000:1d:04.3: PME# disabled                                  
[    0.638039] pci 0000:00:14.4: transparent bridge                             
[    0.638046] PCI: bridge 0000:00:14.4 32bit mmio: [f8600000, f86fffff]        
[    0.638091] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]              
[    0.638401] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]         
[    0.638597] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]         
[    0.638650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB7_._PRT]         
[    0.638650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BB5_._PRT]         
[    0.638650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]         
[    0.638650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]         
[    0.644278] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.       
[    0.644401] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.       
[    0.644549] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.       
[    0.644549] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.       
[    0.644549] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.       
[    0.644654] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.       
[    0.644844] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.       
[    0.645035] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.       
[    0.648178] Linux Plug and Play Support v0.97 (c) Adam Belay                 
[    0.648205] pnp: PnP ACPI init                                               
[    0.648205] ACPI: bus type pnp registered                                    
[    0.680261] pnp: PnP ACPI: found 11 devices                                  
[    0.680263] ACPI: ACPI bus type pnp unregistered                             
[    0.684066] PCI: Using ACPI for IRQ routing                                  
[    0.692042] NET: Registered protocol family 8                                
[    0.692044] NET: Registered protocol family 20                               
[    0.696041] NetLabel: Initializing                                           
[    0.696041] NetLabel:  domain hash size = 128                                
[    0.696041] NetLabel:  protocols = UNLABELED CIPSOv4                         
[    0.696056] NetLabel:  unlabeled traffic allowed by default                  
[    0.696202] PCI-DMA: Disabling AGP.                                          
[    0.696355] PCI-DMA: aperture base @ 20000000 size 65536 KB                  
[    0.696355] PCI-DMA: using GART IOMMU.                                       
[    0.696355] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture        
[    0.696714] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0                       
[    0.696722] hpet0: 4 32-bit timers, 14318180 Hz                              
[    0.699086] tracer: 1286 pages allocated for 65536 entries of 80 bytes       
[    0.699089]    actual entries 65586                                          
[    0.699219] AppArmor: AppArmor Filesystem Enabled                            
[    0.699250] ACPI: RTC can wake from S4                                       
[    0.700051] Switched to high resolution mode on CPU 0                        
[    0.700065] Switched to high resolution mode on CPU 1                        
[    0.709050] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved                                                                            
[    0.709053] system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved                                                                            
[    0.709066] system 00:08: ioport range 0x1080-0x1080 has been reserved       
[    0.709069] system 00:08: ioport range 0x220-0x22f has been reserved         
[    0.709072] system 00:08: ioport range 0x40b-0x40b has been reserved         
[    0.709075] system 00:08: ioport range 0x4d0-0x4d1 has been reserved         
[    0.709077] system 00:08: ioport range 0x4d6-0x4d6 has been reserved         
[    0.709080] system 00:08: ioport range 0x530-0x537 has been reserved         
[    0.709083] system 00:08: ioport range 0xc00-0xc01 has been reserved         
[    0.709085] system 00:08: ioport range 0xc14-0xc14 has been reserved         
[    0.709088] system 00:08: ioport range 0xc50-0xc52 has been reserved         
[    0.709091] system 00:08: ioport range 0xc6c-0xc6c has been reserved         
[    0.709094] system 00:08: ioport range 0xc6f-0xc6f has been reserved         
[    0.709097] system 00:08: ioport range 0xcd0-0xcd1 has been reserved         
[    0.709100] system 00:08: ioport range 0xcd2-0xcd3 has been reserved         
[    0.709103] system 00:08: ioport range 0xcd4-0xcd5 has been reserved         
[    0.709106] system 00:08: ioport range 0xcd6-0xcd7 has been reserved         
[    0.709109] system 00:08: ioport range 0xcd8-0xcdf has been reserved         
[    0.709112] system 00:08: ioport range 0x8000-0x805f has been reserved       
[    0.709115] system 00:08: ioport range 0xf40-0xf47 has been reserved         
[    0.709118] system 00:08: ioport range 0x87f-0x87f has been reserved         
[    0.709121] system 00:08: ioport range 0xfd60-0xfddf has been reserved       
[    0.709128] system 00:09: iomem range 0xe0000-0xfffff could not be reserved  
[    0.709131] system 00:09: iomem range 0xfff00000-0xffffffff could not be reserved                                                                            
[    0.714635] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01              
[    0.714638] pci 0000:00:01.0:   IO window: 0x9000-0x9fff                     
[    0.714642] pci 0000:00:01.0:   MEM window: 0xf8200000-0xf83fffff            
[    0.714645] pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff                                                                           
[    0.714650] pci 0000:00:05.0: PCI bridge, secondary bus 0000:0b              
[    0.714651] pci 0000:00:05.0:   IO window: disabled                          
[    0.714655] pci 0000:00:05.0:   MEM window: 0xf8000000-0xf81fffff            
[    0.714657] pci 0000:00:05.0:   PREFETCH window: disabled                    
[    0.714662] pci 0000:00:06.0: PCI bridge, secondary bus 0000:11              
[    0.714664] pci 0000:00:06.0:   IO window: 0xa000-0xafff                     
[    0.714668] pci 0000:00:06.0:   MEM window: 0xf8500000-0xf85fffff            
[    0.714671] pci 0000:00:06.0:   PREFETCH window: 0x000000f8700000-0x000000f87fffff                                                                           
[    0.714675] pci 0000:00:07.0: PCI bridge, secondary bus 0000:17              
[    0.714677] pci 0000:00:07.0:   IO window: disabled                          
[    0.714680] pci 0000:00:07.0:   MEM window: 0xf8400000-0xf84fffff            
[    0.714683] pci 0000:00:07.0:   PREFETCH window: disabled                    
[    0.714690] pci 0000:1d:04.0: CardBus bridge, secondary bus 0000:1e          
[    0.714692] pci 0000:1d:04.0:   IO window: 0x002000-0x0020ff                 
[    0.714700] pci 0000:1d:04.0:   IO window: 0x002400-0x0024ff                 
[    0.714706] pci 0000:1d:04.0:   PREFETCH window: 0x120000000-0x123ffffff     
[    0.714711] pci 0000:1d:04.0:   MEM window: 0x124000000-0x127ffffff          
[    0.714717] pci 0000:00:14.4: PCI bridge, secondary bus 0000:1d              
[    0.714720] pci 0000:00:14.4:   IO window: 0x2000-0x2fff                     
[    0.714726] pci 0000:00:14.4:   MEM window: 0xf8600000-0xf86fffff            
[    0.714731] pci 0000:00:14.4:   PREFETCH window: 0x00000120000000-0x00000123ffffff                                                                           
[    0.714747] pci 0000:00:05.0: setting latency timer to 64                    
[    0.714752] pci 0000:00:06.0: setting latency timer to 64                    
[    0.714757] pci 0000:00:07.0: setting latency timer to 64                    
[    0.714778] pci 0000:1d:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20     
[    0.714785] bus: 00 index 0 io port: [0, ffff]                               
[    0.714787] bus: 00 index 1 mmio: [0, ffffffffffffffff]                      
[    0.714789] bus: 01 index 0 io port: [9000, 9fff]                            
[    0.714791] bus: 01 index 1 mmio: [f8200000, f83fffff]                       
[    0.714793] bus: 01 index 2 mmio: [f0000000, f7ffffff]                       
[    0.714795] bus: 01 index 3 mmio: [0, 0]                                     
[    0.714797] bus: 0b index 0 mmio: [0, 0]                                     
[    0.714799] bus: 0b index 1 mmio: [f8000000, f81fffff]                       
[    0.714801] bus: 0b index 2 mmio: [0, 0]                                     
[    0.714802] bus: 0b index 3 mmio: [0, 0]                                     
[    0.714804] bus: 11 index 0 io port: [a000, afff]                            
[    0.714807] bus: 11 index 1 mmio: [f8500000, f85fffff]                       
[    0.714809] bus: 11 index 2 mmio: [f8700000, f87fffff]                       
[    0.714811] bus: 11 index 3 mmio: [0, 0]                                     
[    0.714812] bus: 17 index 0 mmio: [0, 0]                                     
[    0.714814] bus: 17 index 1 mmio: [f8400000, f84fffff]                       
[    0.714816] bus: 17 index 2 mmio: [0, 0]                                     
[    0.714818] bus: 17 index 3 mmio: [0, 0]                                     
[    0.714820] bus: 1d index 0 io port: [2000, 2fff]                            
[    0.714822] bus: 1d index 1 mmio: [f8600000, f86fffff]                       
[    0.714824] bus: 1d index 2 mmio: [120000000, 123ffffff]                     
[    0.714826] bus: 1d index 3 io port: [0, ffff]                               
[    0.714828] bus: 1d index 4 mmio: [0, ffffffffffffffff]                      
[    0.714830] bus: 1e index 0 io port: [2000, 20ff]                            
[    0.714832] bus: 1e index 1 io port: [2400, 24ff]                            
[    0.714835] bus: 1e index 2 mmio: [120000000, 123ffffff]                     
[    0.714837] bus: 1e index 3 mmio: [124000000, 127ffffff]                     
[    0.714853] NET: Registered protocol family 2                                
[    0.753209] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)                                                                              
[    0.754909] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)                                                                            
[    0.759678] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)     
[    0.760309] TCP: Hash tables configured (established 524288 bind 65536)      
[    0.760312] TCP reno registered                                              
[    0.769128] NET: Registered protocol family 1                                
[    0.769267] checking if image is initramfs... it is                          
[    1.232025] ACPI: EC: missing confirmations, switch off interrupt mode.      
[    1.535727] Freeing initrd memory: 8480k freed                               
[    1.542513] audit: initializing netlink socket (disabled)                    
[    1.542527] type=2000 audit(1234611829.540:1): initialized                   
[    1.548922] HugeTLB registered 2 MB page size, pre-allocated 0 pages         
[    1.552824] VFS: Disk quotas dquot_6.5.1                                     
[    1.552947] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)        
[    1.553108] msgmni has been set to 7665                                      
[    1.553260] io scheduler noop registered                                     
[    1.553263] io scheduler anticipatory registered                             
[    1.553265] io scheduler deadline registered                                 
[    1.553425] io scheduler cfq registered (default)                            
[    1.553537] pci 0000:01:05.0: Boot video device                              
[    1.553690] pcieport-driver 0000:00:05.0: setting latency timer to 64        
[    1.553711] pcieport-driver 0000:00:05.0: found MSI capability               
[    1.553736] pci_express 0000:00:05.0:pcie00: allocate port service           
[    1.553797] pci_express 0000:00:05.0:pcie02: allocate port service           
[    1.553850] pci_express 0000:00:05.0:pcie03: allocate port service           
[    1.553933] pcieport-driver 0000:00:06.0: setting latency timer to 64        
[    1.553952] pcieport-driver 0000:00:06.0: found MSI capability               
[    1.553972] pci_express 0000:00:06.0:pcie00: allocate port service           
[    1.554037] pci_express 0000:00:06.0:pcie03: allocate port service           
[    1.554121] pcieport-driver 0000:00:07.0: setting latency timer to 64        
[    1.554141] pcieport-driver 0000:00:07.0: found MSI capability               
[    1.554161] pci_express 0000:00:07.0:pcie00: allocate port service           
[    1.554218] pci_express 0000:00:07.0:pcie03: allocate port service           
[    1.609902] hpet_resources: 0xfed00000 is busy                               
[    1.610003] Linux agpgart interface v0.103                                   
[    1.610008] Serial: 8250/16550 driver4 ports, IRQ sharing enabled            
[    1.613471] brd: module loaded                                               
[    1.613579] input: Macintosh mouse button emulation as /devices/virtual/input/input0                                                                         
[    1.613764] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12                                                                           
[    1.654378] serio: i8042 KBD port at 0x60,0x64 irq 1                         
[    1.654387] serio: i8042 AUX port at 0x60,0x64 irq 12                        
[    1.664201] mice: PS/2 mouse device common for all mice                      
[    1.664407] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0            
[    1.664435] rtc0: alarms up to one month, hpet irqs                          
[    1.664502] cpuidle: using governor ladder                                   
[    1.664504] cpuidle: using governor menu                                     
[    1.664912] TCP cubic registered                                             
[    1.665242] registered taskstats version 1                                   
[    1.665421]   Magic number: 13:874:731                                       
[    1.665581] rtc_cmos 00:04: setting system clock to 2009-02-14 11:43:51 UTC (1234611831)                                                                     
[    1.665584] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found             
[    1.665586] EDD information not available.                                   
[    1.665642] Freeing unused kernel memory: 540k freed                         
[    1.665925] Write protecting the kernel read-only data: 4352k                
[    1.687801] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1                                                               
[    1.865063] fuse init (API version 7.9)                                      
[    1.911172] ACPI: processor limited to max C-state 1                         
[    1.911291] processor ACPI0007:00: registered as cooling_device0             
[    1.911297] ACPI: Processor [CPU0] (supports 8 throttling states)            
[    1.911411] processor ACPI0007:01: registered as cooling_device1             
[    2.245527] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded                  
[    2.245557] r8169 0000:11:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18   
[    2.245580] r8169 0000:11:00.0: setting latency timer to 64                  
[    2.246062] eth0: RTL8101e at 0xffffc20000644000, 00:1e:ec:00:9e:6a, XID 34200000 IRQ 2300                                                                   
[    2.313010] usbcore: registered new interface driver usbfs                   
[    2.313040] usbcore: registered new interface driver hub                     
[    2.324737] usbcore: registered new device driver usb                        
[    2.324970] No dock devices found.                                           
[    2.329920] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.329938] ehci_hcd 0000:00:13.5: EHCI Host Controller                      
[    2.329998] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1                                                                             
[    2.330046] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround                                                                            
[    2.330067] ehci_hcd 0000:00:13.5: debug port 1                              
[    2.330090] ehci_hcd 0000:00:13.5: irq 19, io mem 0xf8909400                 
[    2.332101] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver                                                                            
[    2.345605] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004                                                                            
[    2.345781] usb usb1: configuration #1 chosen from 1 choice                  
[    2.345810] hub 1-0:1.0: USB hub found                                       
[    2.345821] hub 1-0:1.0: 10 ports detected                                   
[    2.346275] SCSI subsystem initialized                                       
[    2.362676] libata version 3.00 loaded.                                      
[    2.552556] ahci 0000:00:12.0: version 3.0                                   
[    2.552582] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22    
[    2.552615] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit  
[    2.552708] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode                                                                     
[    2.552712] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pmp pio slum part                                                                             
[    2.553126] scsi0 : ahci                                                     
[    2.553269] scsi1 : ahci                                                     
[    2.553340] scsi2 : ahci                                                     
[    2.553404] scsi3 : ahci                                                     
[    2.553536] ata1: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909100 irq 22                                                                             
[    2.553541] ata2: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909180 irq 22                                                                             
[    2.553544] ata3: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909200 irq 22                                                                             
[    2.553548] ata4: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909280 irq 22                                                                             
[    2.665047] usb 1-1: new high speed USB device using ehci_hcd and address 2  
[    2.914987] usb 1-1: configuration #1 chosen from 1 choice                   
[    3.261033] ata1: softreset failed (device not ready)                        
[    3.261040] ata1: failed due to HW bug, retry pmp=0                          
[    3.424045] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)           
[    3.817070] ata1.00: ATA-8: TOSHIBA MK1646GSX, LB113M, max UDMA/100          
[    3.817074] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)    
[    3.817085] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd             
[    3.817965] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd             
[    3.817968] ata1.00: configured for UDMA/100                                 
[    4.152048] ata2: SATA link down (SStatus 0 SControl 300)                    
[    4.488047] ata3: SATA link down (SStatus 0 SControl 300)                    
[    4.824051] ata4: SATA link down (SStatus 0 SControl 300)                    
[    4.840148] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5                                                                     
[    4.840305] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.840325] ohci_hcd 0000:00:13.0: OHCI Host Controller                      
[    4.840375] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2                                                                             
[    4.840409] ohci_hcd 0000:00:13.0: irq 16, io mem 0xf8904000                 
[    4.896211] usb usb2: configuration #1 chosen from 1 choice                  
[    4.896249] hub 2-0:1.0: USB hub found                                       
[    4.896265] hub 2-0:1.0: 2 ports detected                                    
[    5.000329] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.000348] ohci_hcd 0000:00:13.1: OHCI Host Controller                      
[    5.000376] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3                                                                             
[    5.000406] ohci_hcd 0000:00:13.1: irq 17, io mem 0xf8905000                 
[    5.056161] usb usb3: configuration #1 chosen from 1 choice                  
[    5.056196] hub 3-0:1.0: USB hub found                                       
[    5.056211] hub 3-0:1.0: 2 ports detected                                    
[    5.160307] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.160326] ohci_hcd 0000:00:13.2: OHCI Host Controller                      
[    5.160355] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4                                                                             
[    5.160386] ohci_hcd 0000:00:13.2: irq 18, io mem 0xf8906000                 
[    5.216217] usb usb4: configuration #1 chosen from 1 choice                  
[    5.216249] hub 4-0:1.0: USB hub found                                       
[    5.216266] hub 4-0:1.0: 2 ports detected                                    
[    5.426232] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.426252] ohci_hcd 0000:00:13.3: OHCI Host Controller                      
[    5.426305] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5                                                                             
[    5.426330] ohci_hcd 0000:00:13.3: irq 17, io mem 0xf8907000                 
[    5.480217] usb usb5: configuration #1 chosen from 1 choice                  
[    5.480256] hub 5-0:1.0: USB hub found                                       
[    5.480272] hub 5-0:1.0: 2 ports detected                                    
[    5.560047] usb 4-1: new full speed USB device using ohci_hcd and address 2  
[    5.688304] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.688325] ohci_hcd 0000:00:13.4: OHCI Host Controller                      
[    5.688362] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6                                                                             
[    5.688385] ohci_hcd 0000:00:13.4: irq 18, io mem 0xf8908000                 
[    5.735214] usb 4-1: configuration #1 chosen from 1 choice                   
[    5.748156] usb usb6: configuration #1 chosen from 1 choice                  
[    5.748192] hub 6-0:1.0: USB hub found                                       
[    5.748207] hub 6-0:1.0: 2 ports detected                                    
[    5.849753] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                             
[    5.849790] pata_atiixp 0000:00:14.1: setting latency timer to 64            
[    5.849911] scsi4 : pata_atiixp                                              
[    5.851320] scsi5 : pata_atiixp                                              
[    5.852443] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8420 irq 14  
[    5.852446] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8428 irq 15  
[    5.873034] usb 5-1: new low speed USB device using ohci_hcd and address 2   
[    6.016513] ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WT03, max UDMA/33      
[    6.032472] ata5.00: configured for UDMA/33                                  
[    6.041073] usb 5-1: configuration #1 chosen from 1 choice                   
[    6.044554] usbcore: registered new interface driver libusual                
[    6.050338] Initializing USB Mass Storage driver...                          
[    6.052627] scsi6 : SCSI emulation for USB Mass Storage devices              
[    6.054388] usb-storage: device found at 2                                   
[    6.054392] usb-storage: waiting for device to settle before scanning        
[    6.054441] usbcore: registered new interface driver usb-storage             
[    6.054446] USB Mass Storage support registered.                             
[    6.059962] scsi 0:0:0:0: Attached scsi generic sg0 type 0                   
[    6.191693] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WT03 PQ: 0 ANSI: 5                                                                     
[    6.191899] scsi 4:0:0:0: Attached scsi generic sg1 type 5                   
[    6.195192] ohci1394 0000:1d:04.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.256490] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[f8606000-f86067ff]  Max Packet=[2048]  IR/IT contexts=[4/8]                             
[    6.293484] usbcore: registered new interface driver hiddev                  
[    6.298106] Driver 'sd' needs updating - please use bus_type methods         
[    6.298239] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    6.298257] sd 0:0:0:0: [sda] Write Protect is off                           
[    6.298260] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                        
[    6.298289] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                          
[    6.298387] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    6.298403] sd 0:0:0:0: [sda] Write Protect is off                           
[    6.298405] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                        
[    6.298432] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                          
[    6.298438]  sda:input: Logitech Optical USB Mouse as /devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/input/input2                                      
[    6.303077] Driver 'sr' needs updating - please use bus_type methods         
[    6.317231] input,hidraw0: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:13.3-1                                                            
[    6.317256] usbcore: registered new interface driver usbhid                  
[    6.317260] usbhid: v2.6:USB HID core driver                                 
[    6.411522]  sda1 sda2 sda3 < sda5 sda6>                                    
[    6.446614] sd 0:0:0:0: [sda] Attached SCSI disk                             
[    6.465889] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray                                                                            
[    6.465896] Uniform CD-ROM driver Revision: 3.20                             
[    6.466026] sr 4:0:0:0: Attached scsi CD-ROM sr0                             
[    6.893986] PM: Starting manual resume from disk                             
[    6.893990] PM: Resume from partition 8:6                                    
[    6.893992] PM: Checking hibernation image.                                  
[    6.894234] PM: Resume from disk failed.                                     
[    6.911936] EXT3-fs: INFO: recovery required on readonly filesystem.         
[    6.911941] EXT3-fs: write access will be enabled during recovery.           
[    7.528509] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f81c2404ccc]  
[   11.053236] usb-storage: device scan complete                                
[   11.088849] scsi 6:0:0:0: Direct-Access     WDC WD80 0VE-00HDT0       09.0 PQ: 0 ANSI: 0                                                                     
[   11.092179] sd 6:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB) 
[   11.093045] sd 6:0:0:0: [sdb] Write Protect is off                           
[   11.093048] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00                        
[   11.093051] sd 6:0:0:0: [sdb] Assuming drive cache: write through            
[   11.093801] sd 6:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB) 
[   11.098443] sd 6:0:0:0: [sdb] Write Protect is off                           
[   11.098447] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00                        
[   11.098449] sd 6:0:0:0: [sdb] Assuming drive cache: write through            
[   11.098456]  sdb: sdb1                                                       
[   11.426403] sd 6:0:0:0: [sdb] Attached SCSI disk                             
[   11.426541] sd 6:0:0:0: Attached scsi generic sg2 type 0                     
[   14.040019] kjournald starting.  Commit interval 5 seconds                   
[   14.040048] EXT3-fs: sda5: orphan cleanup on readonly fs                     
[   14.040060] ext3_orphan_cleanup: deleting unreferenced inode 663557          
[   14.072758] ext3_orphan_cleanup: deleting unreferenced inode 672961          
[   14.079902] ext3_orphan_cleanup: deleting unreferenced inode 648052          
[   14.079922] EXT3-fs: sda5: 3 orphan inodes deleted                           
[   14.079924] EXT3-fs: recovery complete.                                      
[   14.176993] EXT3-fs: mounted filesystem with ordered data mode.              
[   20.669740] udevd version 124 started                                        
[   20.981632] pci_hotplug: PCI Hot Plug PCI Core version: 0.5                  
[   21.031735] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4     
[   21.081274] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3                                                                        
[   21.104058] ACPI: Power Button (FF) [PWRF]                                   
[   21.104210] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4                                                                      
[   21.104318] ACPI: Lid Switch [LID]                                           
[   21.104390] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5                                                               
[   21.136035] ACPI: Power Button (CM) [PWRB]                                   
[   21.281984] ACPI: AC Adapter [ACAD] (on-line)                                
[   21.411440] acpi device:29: registered as cooling_device2                    
[   21.411695] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:26/device:27/input/input6                                                   
[   21.433031] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)    
[   21.556529] ath_hal: module license 'Proprietary' taints kernel.             
[   21.560067] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)                                                                       
[   21.595531] wlan: 0.9.4                                                      
[   21.601927] ACPI: Battery Slot [BAT1] (battery present)                      
[   21.602061] ath_pci: 0.9.4                                                   
[   21.602121] ath_pci 0000:17:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19 
[   21.602131] ath_pci 0000:17:00.0: setting latency timer to 64                
[   21.626538] wifi%d: unable to attach hardware: 'Hardware revision not supported' (HAL status 13)                                                             
[   21.626559] ath_pci 0000:17:00.0: PCI INT A disabled                         
[   21.810141] Linux video capture interface: v2.00                             
[   22.032403] lirc_dev: IR Remote Control driver registered, major 61          
[   22.110919]                                                                  
[   22.110922] lirc_mceusb2: Philips eHome USB IR Transceiver and Microsoft MCE 2005 Remote Control driver for LIRC $Revision: 1.44 $                           
[   22.110926] lirc_mceusb2: Daniel Melander , Martin Blatter                                                      
[   22.153148] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8410, revision 0                                                                            
[   22.305060] usb 4-1: reset full speed USB device using ohci_hcd and address 2
[   22.456613] Yenta: CardBus bridge found at 0000:1d:04.0 [1179:ff00]          
[   22.456639] Yenta: Enabling burst memory read transactions                   
[   22.456644] Yenta: Using CSCINT to route CSC interrupts to PCI               
[   22.456646] Yenta: Routing CardBus interrupts to PCI                         
[   22.456652] Yenta TI: socket 0000:1d:04.0, mfunc 0x10a01b22, devctl 0x64     
[   22.470082] lirc_dev: lirc_register_plugin: sample_rate: 0                   
[   22.474075] lirc_mceusb2[2]:   BB+ Dongle(e.d) on usb4:2                     
[   22.474131] usbcore: registered new interface driver lirc_mceusb2            
[   22.632207] sdhci: Secure Digital Host Controller Interface driver           
[   22.632211] sdhci: Copyright(c) Pierre Ossman                                
[   22.686445] Yenta: ISA IRQ mask 0x0cf8, PCI irq 20                           
[   22.686453] Socket status: 30000006                                          
[   22.686456] Yenta: Raising subordinate bus# of parent bus (#1d) from #1e to #21                                                                              
[   22.686463] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff            
[   22.686491] pcmcia: parent PCI bridge Memory window: 0xf8600000 - 0xf86fffff 
[   22.686494] pcmcia: parent PCI bridge Memory window: 0x120000000 - 0x123ffffff                                                                               
[   22.687056] tifm_7xx1 0000:1d:04.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22                                                                               
[   22.760391] input: PC Speaker as /devices/platform/pcspkr/input/input7       
[   22.799693] cx23885 driver version 0.0.1 loaded                              
[   22.799759] cx23885 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17 
[   22.799891] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge WinTV-HVR1500 [card=6,autodetected]                                                      
[   22.945298] tveeprom 1-0050: Hauppauge model 77001, rev D4C0, serial# 2396878
[   22.945303] tveeprom 1-0050: MAC address is 00-0D-FE-24-92-CE                
[   22.945306] tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71) 
[   22.945309] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)                                                                             
[   22.945312] tveeprom 1-0050: audio processor is CX23885 (idx 39)             
[   22.945314] tveeprom 1-0050: decoder processor is CX23885 (idx 33)           
[   22.945317] tveeprom 1-0050: has no radio                                    
[   22.945319] cx23885[0]: hauppauge eeprom: model=77001                        
[   22.945323] cx23885_dvb_register() allocating 1 frontend(s)                  
[   22.945904] cx23885[0]: cx23885 based dvb card                               
[   23.144538] xc2028 2-0061: creating new instance                             
[   23.144542] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner            
[   23.144550] DVB: registering new adapter (cx23885[0])                        
[   23.144554] DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...                                                                     
[   23.145057] cx23885_dev_checkrevision() Hardware revision = 0xb0             
[   23.145066] cx23885[0]/0: found at 0000:0b:00.0, rev: 2, irq: 17, latency: 0, mmio: 0xf8000000                                                               
[   23.145075] cx23885 0000:0b:00.0: setting latency timer to 64                
[   23.145127] sdhci-pci 0000:1d:04.3: SDHCI controller found [104c:803c] (rev 0)                                                                               
[   23.145145] sdhci-pci 0000:1d:04.3: PCI INT C -> GSI 22 (level, low) -> IRQ 22                                                                               
[   23.145229] mmc0: SDHCI controller on PCI [0000:1d:04.3] using DMA           
[   23.308787] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                               
[   23.344407] hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...                                                                              
[   23.924548] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x9280b1, caps: 0xa04713/0x204000                                                                     
[   24.016943] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8                                                                 
[   24.685574] lp: driver loaded but no devices found                           
[   24.903015] Adding 2072344k swap on /dev/sda6.  Priority:-1 extents:1 across:2072344k                                                                        
[   25.466330] EXT3 FS on sda5, internal journal                                
[   26.656372] type=1505 audit(1234633456.195:2): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=4403                       
[   26.656615] type=1505 audit(1234633456.195:3): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4403                                      
[   26.765265] type=1505 audit(1234633456.306:4): operation="profile_load" name="/usr/sbin/mysqld" name2="default" pid=4407                                     
[   26.917955] ip_tables: (C) 2000-2006 Netfilter Core Team                     
[   27.598540] ACPI: WMI: Mapper loaded                                         
[   28.017531] powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-58 processors (2 cpu cores) (version 2.20.00)                                     
[   28.018300] powernow-k8:    0 : fid 0xb (1900 MHz), vid 0x12                 
[   28.018305] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x13                 
[   28.018307] powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x14                 
[   28.018310] powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e                  
[   28.904174] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)                                                                         
[   31.624633] ppdev: user-space parallel port driver                           
[   32.503239] NET: Registered protocol family 10                               
[   32.504277] lo: Disabled Privacy Extensions                                  
[   34.000036] Clocksource tsc unstable (delta = -79004051 ns)                  
[   37.039504] Bluetooth: Core ver 2.13                                         
[   37.039751] NET: Registered protocol family 31                               
[   37.039756] Bluetooth: HCI device and connection manager initialized         
[   37.039765] Bluetooth: HCI socket layer initialized                          
[   37.103482] Bluetooth: L2CAP ver 2.11
[   37.103501] Bluetooth: L2CAP socket layer initialized
[   37.138066] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   37.138083] Bluetooth: BNEP filters: protocol multicast
[   37.181868] Bridge firewalling registered
[   37.201780] Bluetooth: RFCOMM socket layer initialized
[   37.202267] Bluetooth: RFCOMM TTY layer initialized
[   37.202280] Bluetooth: RFCOMM ver 1.10
[   37.236415] Bluetooth: SCO (Voice Link) ver 0.6
[   37.236429] Bluetooth: SCO socket layer initialized
[   38.862567] pci 0000:01:05.0: power state changed by ACPI to D0
[   38.862613] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   39.235680] [drm] Initialized drm 1.1.0 20060810
[   39.260631] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   39.907354] [drm] Setting GART location based on new memory map
[   39.908321] [drm] Loading RS690 Microcode
[   39.908355] [drm] Num pipes: 1
[   39.908366] [drm] writeback test succeeded in 1 usecs
[   41.454939] r8169: eth0: link down
[   41.457636] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   98.917005] APIC error on CPU0: 00(40)
[   98.917012] APIC error on CPU1: 00(40)
[  108.794611] hda-intel: Invalid position buffer, using LPIB read method instead.
[  249.501067] r8169: eth0: link up
[  249.502994] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  249.618943] NET: Registered protocol family 17
[  259.588033] eth0: no IPv6 routers present
[  396.495543] firmware: requesting xc3028-v27.fw
[  396.577488] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  396.776074] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[  397.938088] xc2028 2-0061: Loading firmware for type=D2633 DTV6 ATSC (10030), id 0000000000000000.


_________________________________________________________________
Windows Live™: Keep your life in sync. 
http://windowslive.com/explore?ocid=TXT_TAGLM_WL_t1_allup_explore_022009
