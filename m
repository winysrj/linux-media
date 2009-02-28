Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s27.bay0.hotmail.com ([65.54.246.227]:53054 "EHLO
	bay0-omc3-s27.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbZB1Pyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 10:54:52 -0500
Message-ID: <BAY102-W320C816E2DAE91A8CCD8DBCFAB0@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: RE: HVR 1500 tuner seems to be recognized
Date: Sat, 28 Feb 2009 09:54:49 -0600
In-Reply-To: <BAY102-W8F2C3C600D87A1F2E6759CFAB0@phx.gbl>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
  	 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
  	 <BAY102-W54F614817092361870868DCFB40@phx.gbl>
  	 <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
  	 <BAY102-W41AFA57978CB8940FABF84CFB40@phx.gbl>
  	 <412bdbff0902171021l6bcfc1f4o6d4903949da70b0d@mail.gmail.com>
  	 <BAY102-W289218AB686D66E1F3BD4ACFB40@phx.gbl>
  	 <412bdbff0902171245m5e6a8deerfcd14a340f65fa4f@mail.gmail.com>
  	 <BAY102-W2159CF565B5E47F670249DCFB40@phx.gbl>
  <412bdbff0902171256y6545d970n6f7bd347f446ad7c@mail.gmail.com>
 <BAY102-W8F2C3C600D87A1F2E6759CFAB0@phx.gbl>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



I had forgotten to stop the myth-backend.  Here is the dmesg output after doing that.


dmesg
                                                                                                                                                          
thomas@toshiba:~$ dmesg                                                                                                                                                                                    
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
[    0.000000] TSC: Unable to calibrate against PIT                                                                                                                                                        
[    0.000000] TSC: using PMTIMER reference calibration                                                                                                                                                    
[    0.000000] Detected 1895.246 MHz processor.                                                                                                                                                            
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
[    0.004009] Calibrating delay loop (skipped), value calculated using timer frequency.. 3790.49 BogoMIPS (lpj=7580984)                                                                                   
[    0.004038] Security Framework initialized                                                                                                                                                              
[    0.004045] SELinux:  Disabled at boot.                                                                                                                                                                 
[    0.004061] AppArmor: AppArmor initialized                                                                                                                                                              
[    0.004540] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)                                                                                                                          
[    0.007566] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)                                                                                                                            
[    0.008859] Mount-cache hash table entries: 256                                                                                                                                                         
[    0.009062] Initializing cgroup subsys ns                                                                                                                                                               
[    0.009066] Initializing cgroup subsys cpuacct                                                                                                                                                          
[    0.009068] Initializing cgroup subsys memory                                                                                                                                                           
[    0.009086] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)                                                                                                                           
[    0.009088] CPU: L2 Cache: 512K (64 bytes/line)                                                                                                                                                         
[    0.009091] CPU 0/0 -> Node 0                                                                                                                                                                           
[    0.009092] tseg: 00d7f00000                                                                                                                                                                            
[    0.009094] CPU: Physical Processor ID: 0                                                                                                                                                               
[    0.009096] CPU: Processor Core ID: 0                                                                                                                                                                   
[    0.009105] using C1E aware idle routine                                                                                                                                                                
[    0.010605] ACPI: Core revision 20080609                                                                                                                                                                
[    0.013578] ACPI: Checking initramfs for custom DSDT                                                                                                                                                    
[    0.408464] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1                                                                                                                                        
[    0.412025] ..MP-BIOS bug: 8254 timer not connected to IO-APIC                                                                                                                                          
[    0.412025] ...trying to set up timer (IRQ0) through the 8259A ...                                                                                                                                      
[    0.412025] ..... (found apic 0 pin 0) ...                                                                                                                                                              
[    0.454768] ....... works.                                                                                                                                                                              
[    0.454769] CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02                                                                                                                              
[    0.454773] Using local APIC timer interrupts.                                                                                                                                                          
[    0.456030] APIC timer calibration result 12468736                                                                                                                                                      
[    0.456031] Detected 12.468 MHz APIC timer.                                                                                                                                                             
[    0.456210] Booting processor 1/1 ip 6000                                                                                                                                                               
[    0.004000] Initializing CPU#1                                                                                                                                                                          
[    0.004000] Calibrating delay using timer specific routine.. 3790.54 BogoMIPS (lpj=7581093)                                                                                                             
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)                                                                                                                           
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)                                                                                                                                                         
[    0.004000] CPU 1/1 -> Node 0                                                                                                                                                                           
[    0.004000] CPU: Physical Processor ID: 0                                                                                                                                                               
[    0.004000] CPU: Processor Core ID: 1                                                                                                                                                                   
[    0.544188] CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02                                                                                                                              
[    0.544215] Brought up 2 CPUs                                                                                                                                                                           
[    0.544218] Total of 2 processors activated (7581.03 BogoMIPS).                                                                                                                                         
[    0.544056] System has AMD C1E enabled                                                                                                                                                                  
[    0.544067] Switch to broadcast mode on CPU1                                                                                                                                                            
[    0.544263] CPU0 attaching sched-domain:                                                                                                                                                                
[    0.544266]  domain 0: span 0-1 level CPU                                                                                                                                                               
[    0.544269]   groups: 0 1                                                                                                                                                                               
[    0.544273]   domain 1: span 0-1 level NODE                                                                                                                                                             
[    0.544275]    groups: 0-1                                                                                                                                                                              
[    0.544280] CPU1 attaching sched-domain:                                                                                                                                                                
[    0.544282]  domain 0: span 0-1 level CPU                                                                                                                                                               
[    0.544284]   groups: 1 0                                                                                                                                                                               
[    0.544287]   domain 1: span 0-1 level NODE                                                                                                                                                             
[    0.544289]    groups: 0-1                                                                                                                                                                              
[    0.544387] Switch to broadcast mode on CPU0                                                                                                                                                            
[    0.544387] net_namespace: 1552 bytes                                                                                                                                                                   
[    0.544387] Booting paravirtualized kernel on bare hardware                                                                                                                                             
[    0.544387] Time:  9:43:17  Date: 02/28/09                                                                                                                                                              
[    0.544412] NET: Registered protocol family 16                                                                                                                                                          
[    0.544437] node 0 link 0: io port [1000, fffff]                                                                                                                                                        
[    0.544437] TOM: 00000000e0000000 aka 3584M                                                                                                                                                             
[    0.544437] node 0 link 0: mmio [f8300000, ffffffff]                                                                                                                                                    
[    0.544437] node 0 link 0: mmio [f8200000, f82fffff]                                                                                                                                                    
[    0.544437] node 0 link 0: mmio [f8000000, f81fffff]                                                                                                                                                    
[    0.544437] node 0 link 0: mmio [f0000000, f7ffffff]                                                                                                                                                    
[    0.544437] node 0 link 0: mmio [a0000, bffff]                                                                                                                                                          
[    0.544437] node 0 link 0: mmio [f0000000, efffffff]                                                                                                                                                    
[    0.544437] node 0 link 0: mmio [e0000000, efffffff]                                                                                                                                                    
[    0.544437] node 0 link 0: mmio [e0000000, dfffffff]                                                                                                                                                    
[    0.544437] TOM2: 0000000120000000 aka 4608M                                                                                                                                                            
[    0.544437] bus: [00,ff] on node 0 link 0                                                                                                                                                               
[    0.544437] bus: 00 index 0 io port: [0, ffff]                                                                                                                                                          
[    0.544437] bus: 00 index 1 mmio: [e0000000, ffffffff]                                                                                                                                                  
[    0.544437] bus: 00 index 2 mmio: [a0000, bffff]                                                                                                                                                        
[    0.544437] bus: 00 index 3 mmio: [120000000, fcffffffff]                                                                                                                                               
[    0.544437] ACPI: bus type pci registered                                                                                                                                                               
[    0.544437] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 29                                                                                                                             
[    0.544437] PCI: MCFG area at e0000000 reserved in E820                                                                                                                                                 
[    0.545710] PCI: Using MMCONFIG at e0000000 - e1dfffff                                                                                                                                                  
[    0.545713] PCI: Using configuration type 1 for base access                                                                                                                                             
[    0.548966] ACPI: EC: Look up EC in DSDT                                                                                                                                                                
[    0.551719] ACPI Error (evregion-0315): No handler for Region [ERAM] (ffff88011fa35d80) [EmbeddedControl] [20080609]                                                                                    
[    0.551725] ACPI Error (exfldio-0291): Region EmbeddedControl(3) has no handler [20080609]                                                                                                              
[    0.551731] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.HTEV] (Node ffff88011fa335c0), AE_NOT_EXIST                                                                                 
[    0.551780] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.LPC0.EC0_._REG] (Node ffff88011fa3b960), AE_NOT_EXIST                                                                  
[    0.554361] ACPI: BIOS _OSI(Linux) query ignored via DMI                                                                                                                                                
[    0.556693] ACPI: Interpreter enabled                                                                                                                                                                   
[    0.556696] ACPI: (supports S0 S3 S4 S5)                                                                                                                                                                
[    0.556713] ACPI: Using IOAPIC for interrupt routing                                                                                                                                                    
[    0.556907] ACPI: EC: non-query interrupt received, switching to interrupt mode                                                                                                                         
[    0.628565] ACPI: EC: GPE = 0x13, I/O: command/status = 0x66, data = 0x62                                                                                                                               
[    0.628565] ACPI: EC: driver started in interrupt mode                                                                                                                                                  
[    0.628565] ACPI: PCI Root Bridge [PCI0] (0000:00)                                                                                                                                                      
[    0.628565] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold                                                                                                                                       
[    0.628565] pci 0000:00:05.0: PME# disabled                                                                                                                                                             
[    0.628565] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold                                                                                                                                       
[    0.628565] pci 0000:00:06.0: PME# disabled                                                                                                                                                             
[    0.628565] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold                                                                                                                                       
[    0.628565] pci 0000:00:07.0: PME# disabled                                                                                                                                                             
[    0.628565] PCI: 0000:00:12.0 reg 10 io port: [8440, 8447]                                                                                                                                              
[    0.628565] PCI: 0000:00:12.0 reg 14 io port: [8434, 8437]                                                                                                                                              
[    0.628565] PCI: 0000:00:12.0 reg 18 io port: [8438, 843f]                                                                                                                                              
[    0.628565] PCI: 0000:00:12.0 reg 1c io port: [8430, 8433]                                                                                                                                              
[    0.628565] PCI: 0000:00:12.0 reg 20 io port: [8400, 840f]                                                                                                                                              
[    0.628565] PCI: 0000:00:12.0 reg 24 32bit mmio: [f8909000, f89093ff]                                                                                                                                   
[    0.628565] pci 0000:00:12.0: set SATA to AHCI mode                                                                                                                                                     
[    0.628565] PCI: 0000:00:13.0 reg 10 32bit mmio: [f8904000, f8904fff]                                                                                                                                   
[    0.628565] PCI: 0000:00:13.1 reg 10 32bit mmio: [f8905000, f8905fff]                                                                                                                                   
[    0.628565] PCI: 0000:00:13.2 reg 10 32bit mmio: [f8906000, f8906fff]                                                                                                                                   
[    0.628565] PCI: 0000:00:13.3 reg 10 32bit mmio: [f8907000, f8907fff]                                                                                                                                   
[    0.628565] PCI: 0000:00:13.4 reg 10 32bit mmio: [f8908000, f8908fff]                                                                                                                                   
[    0.628601] PCI: 0000:00:13.5 reg 10 32bit mmio: [f8909400, f89094ff]                                                                                                                                   
[    0.628650] pci 0000:00:13.5: supports D1                                                                                                                                                               
[    0.628651] pci 0000:00:13.5: supports D2                                                                                                                                                               
[    0.628654] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot                                                                                                                                        
[    0.628658] pci 0000:00:13.5: PME# disabled                                                                                                                                                             
[    0.628689] PCI: 0000:00:14.0 reg 10 io port: [8410, 841f]                                                                                                                                              
[    0.628750] PCI: 0000:00:14.1 reg 10 io port: [1f0, 1f7]                                                                                                                                                
[    0.628758] PCI: 0000:00:14.1 reg 14 io port: [3f4, 3f7]                                                                                                                                                
[    0.628765] PCI: 0000:00:14.1 reg 18 io port: [0, 7]                                                                                                                                                    
[    0.628772] PCI: 0000:00:14.1 reg 1c io port: [0, 3]                                                                                                                                                    
[    0.628779] PCI: 0000:00:14.1 reg 20 io port: [8420, 842f]                                                                                                                                              
[    0.628833] PCI: 0000:00:14.2 reg 10 64bit mmio: [f8900000, f8903fff]                                                                                                                                   
[    0.628874] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold                                                                                                                                       
[    0.628878] pci 0000:00:14.2: PME# disabled                                                                                                                                                             
[    0.629060] PCI: 0000:01:05.0 reg 10 64bit mmio: [f0000000, f7ffffff]                                                                                                                                   
[    0.629065] PCI: 0000:01:05.0 reg 18 64bit mmio: [f8300000, f830ffff]                                                                                                                                   
[    0.629069] PCI: 0000:01:05.0 reg 20 io port: [9000, 90ff]                                                                                                                                              
[    0.629073] PCI: 0000:01:05.0 reg 24 32bit mmio: [f8200000, f82fffff]                                                                                                                                   
[    0.629083] pci 0000:01:05.0: supports D1                                                                                                                                                               
[    0.629084] pci 0000:01:05.0: supports D2                                                                                                                                                               
[    0.629099] PCI: bridge 0000:00:01.0 io port: [9000, 9fff]                                                                                                                                              
[    0.629102] PCI: bridge 0000:00:01.0 32bit mmio: [f8200000, f83fffff]                                                                                                                                   
[    0.629106] PCI: bridge 0000:00:01.0 64bit mmio pref: [f0000000, f7ffffff]                                                                                                                              
[    0.629157] PCI: 0000:0b:00.0 reg 10 64bit mmio: [f8000000, f81fffff]                                                                                                                                   
[    0.629233] pci 0000:0b:00.0: supports D1                                                                                                                                                               
[    0.629235] pci 0000:0b:00.0: supports D2                                                                                                                                                               
[    0.629237] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot                                                                                                                                        
[    0.629243] pci 0000:0b:00.0: PME# disabled                                                                                                                                                             
[    0.629289] PCI: bridge 0000:00:05.0 32bit mmio: [f8000000, f81fffff]                                                                                                                                   
[    0.629337] PCI: 0000:11:00.0 reg 10 io port: [a000, a0ff]                                                                                                                                              
[    0.629355] PCI: 0000:11:00.0 reg 18 64bit mmio: [f8500000, f8500fff]                                                                                                                                   
[    0.629373] PCI: 0000:11:00.0 reg 30 32bit mmio: [0, 1ffff]                                                                                                                                             
[    0.629390] pci 0000:11:00.0: supports D1                                                                                                                                                               
[    0.629392] pci 0000:11:00.0: supports D2                                                                                                                                                               
[    0.629394] pci 0000:11:00.0: PME# supported from D1 D2 D3hot D3cold                                                                                                                                    
[    0.629399] pci 0000:11:00.0: PME# disabled                                                                                                                                                             
[    0.629445] PCI: bridge 0000:00:06.0 io port: [a000, afff]                                                                                                                                              
[    0.629448] PCI: bridge 0000:00:06.0 32bit mmio: [f8500000, f85fffff]                                                                                                                                   
[    0.629490] PCI: 0000:17:00.0 reg 10 64bit mmio: [f8400000, f840ffff]                                                                                                                                   
[    0.629579] PCI: bridge 0000:00:07.0 32bit mmio: [f8400000, f84fffff]                                                                                                                                   
[    0.629633] PCI: 0000:1d:04.0 reg 10 32bit mmio: [f8604000, f8604fff]                                                                                                                                   
[    0.629654] pci 0000:1d:04.0: supports D1                                                                                                                                                               
[    0.629655] pci 0000:1d:04.0: supports D2                                                                                                                                                               
[    0.629657] pci 0000:1d:04.0: PME# supported from D0 D1 D2 D3hot D3cold                                                                                                                                 
[    0.629663] pci 0000:1d:04.0: PME# disabled                                                                                                                                                             
[    0.629703] PCI: 0000:1d:04.1 reg 10 32bit mmio: [f8606000, f86067ff]                                                                                                                                   
[    0.629712] PCI: 0000:1d:04.1 reg 14 32bit mmio: [f8600000, f8603fff]                                                                                                                                   
[    0.629766] pci 0000:1d:04.1: supports D1                                                                                                                                                               
[    0.629768] pci 0000:1d:04.1: supports D2                                                                                                                                                               
[    0.629770] pci 0000:1d:04.1: PME# supported from D0 D1 D2 D3hot                                                                                                                                        
[    0.629775] pci 0000:1d:04.1: PME# disabled                                                                                                                                                             
[    0.629814] PCI: 0000:1d:04.2 reg 10 32bit mmio: [f8605000, f8605fff]                                                                                                                                   
[    0.629872] pci 0000:1d:04.2: supports D1                                                                                                                                                               
[    0.629874] pci 0000:1d:04.2: supports D2                                                                                                                                                               
[    0.629876] pci 0000:1d:04.2: PME# supported from D0 D1 D2 D3hot                                                                                                                                        
[    0.629881] pci 0000:1d:04.2: PME# disabled                                                                                                                                                             
[    0.629920] PCI: 0000:1d:04.3 reg 10 32bit mmio: [f8606800, f86068ff]                                                                                                                                   
[    0.629979] pci 0000:1d:04.3: supports D1                                                                                                                                                               
[    0.629980] pci 0000:1d:04.3: supports D2                                                                                                                                                               
[    0.629982] pci 0000:1d:04.3: PME# supported from D0 D1 D2 D3hot                                                                                                                                        
[    0.629987] pci 0000:1d:04.3: PME# disabled                                                                                                                                                             
[    0.630040] pci 0000:00:14.4: transparent bridge                                                                                                                                                        
[    0.630047] PCI: bridge 0000:00:14.4 32bit mmio: [f8600000, f86fffff]                                                                                                                                   
[    0.630092] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                                                                                                                         
[    0.630400] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]                                                                                                                                    
[    0.630595] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]                                                                                                                                    
[    0.630655] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB7_._PRT]                                                                                                                                    
[    0.630655] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BB5_._PRT]                                                                                                                                    
[    0.630655] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]                                                                                                                                    
[    0.630655] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]                                                                                                                                    
[    0.636274] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.636401] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.636592] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.636694] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.636694] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.636694] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.636695] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.636886] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.                                                                                                                                  
[    0.640177] Linux Plug and Play Support v0.97 (c) Adam Belay                                                                                                                                            
[    0.640203] pnp: PnP ACPI init                                                                                                                                                                          
[    0.640203] ACPI: bus type pnp registered                                                                                                                                                               
[    0.672262] pnp: PnP ACPI: found 11 devices                                                                                                                                                             
[    0.672265] ACPI: ACPI bus type pnp unregistered                                                                                                                                                        
[    0.676067] PCI: Using ACPI for IRQ routing                                                                                                                                                             
[    0.684052] NET: Registered protocol family 8                                                                                                                                                           
[    0.684052] NET: Registered protocol family 20                                                                                                                                                          
[    0.688042] NetLabel: Initializing                                                                                                                                                                      
[    0.688042] NetLabel:  domain hash size = 128                                                                                                                                                           
[    0.688042] NetLabel:  protocols = UNLABELED CIPSOv4                                                                                                                                                    
[    0.688057] NetLabel:  unlabeled traffic allowed by default                                                                                                                                             
[    0.688200] PCI-DMA: Disabling AGP.                                                                                                                                                                     
[    0.688347] PCI-DMA: aperture base @ 20000000 size 65536 KB                                                                                                                                             
[    0.688347] PCI-DMA: using GART IOMMU.                                                                                                                                                                  
[    0.688347] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture                                                                                                                                   
[    0.688713] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0                                                                                                                                                  
[    0.688720] hpet0: 4 32-bit timers, 14318180 Hz                                                                                                                                                         
[    0.691092] tracer: 1286 pages allocated for 65536 entries of 80 bytes                                                                                                                                  
[    0.691094]    actual entries 65586                                                                                                                                                                     
[    0.691225] AppArmor: AppArmor Filesystem Enabled                                                                                                                                                       
[    0.691256] ACPI: RTC can wake from S4                                                                                                                                                                  
[    0.692051] Switched to high resolution mode on CPU 0                                                                                                                                                   
[    0.692065] Switched to high resolution mode on CPU 1                                                                                                                                                   
[    0.701056] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved                                                                                                                       
[    0.701060] system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved                                                                                                                       
[    0.701072] system 00:08: ioport range 0x1080-0x1080 has been reserved                                                                                                                                  
[    0.701076] system 00:08: ioport range 0x220-0x22f has been reserved                                                                                                                                    
[    0.701078] system 00:08: ioport range 0x40b-0x40b has been reserved                                                                                                                                    
[    0.701081] system 00:08: ioport range 0x4d0-0x4d1 has been reserved                                                                                                                                    
[    0.701084] system 00:08: ioport range 0x4d6-0x4d6 has been reserved                                                                                                                                    
[    0.701087] system 00:08: ioport range 0x530-0x537 has been reserved                                                                                                                                    
[    0.701089] system 00:08: ioport range 0xc00-0xc01 has been reserved                                                                                                                                    
[    0.701092] system 00:08: ioport range 0xc14-0xc14 has been reserved                                                                                                                                    
[    0.701095] system 00:08: ioport range 0xc50-0xc52 has been reserved                                                                                                                                    
[    0.701098] system 00:08: ioport range 0xc6c-0xc6c has been reserved                                                                                                                                    
[    0.701101] system 00:08: ioport range 0xc6f-0xc6f has been reserved                                                                                                                                    
[    0.701104] system 00:08: ioport range 0xcd0-0xcd1 has been reserved                                                                                                                                    
[    0.701107] system 00:08: ioport range 0xcd2-0xcd3 has been reserved                                                                                                                                    
[    0.701110] system 00:08: ioport range 0xcd4-0xcd5 has been reserved                                                                                                                                    
[    0.701113] system 00:08: ioport range 0xcd6-0xcd7 has been reserved                                                                                                                                    
[    0.701116] system 00:08: ioport range 0xcd8-0xcdf has been reserved                                                                                                                                    
[    0.701118] system 00:08: ioport range 0x8000-0x805f has been reserved                                                                                                                                  
[    0.701122] system 00:08: ioport range 0xf40-0xf47 has been reserved                                                                                                                                    
[    0.701124] system 00:08: ioport range 0x87f-0x87f has been reserved                                                                                                                                    
[    0.701127] system 00:08: ioport range 0xfd60-0xfddf has been reserved                                                                                                                                  
[    0.701135] system 00:09: iomem range 0xe0000-0xfffff could not be reserved                                                                                                                             
[    0.701138] system 00:09: iomem range 0xfff00000-0xffffffff could not be reserved                                                                                                                       
[    0.706566] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01                                                                                                                                         
[    0.706569] pci 0000:00:01.0:   IO window: 0x9000-0x9fff                                                                                                                                                
[    0.706574] pci 0000:00:01.0:   MEM window: 0xf8200000-0xf83fffff                                                                                                                                       
[    0.706577] pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff                                                                                                                      
[    0.706582] pci 0000:00:05.0: PCI bridge, secondary bus 0000:0b                                                                                                                                         
[    0.706584] pci 0000:00:05.0:   IO window: disabled                                                                                                                                                     
[    0.706587] pci 0000:00:05.0:   MEM window: 0xf8000000-0xf81fffff                                                                                                                                       
[    0.706590] pci 0000:00:05.0:   PREFETCH window: disabled                                                                                                                                               
[    0.706595] pci 0000:00:06.0: PCI bridge, secondary bus 0000:11                                                                                                                                         
[    0.706598] pci 0000:00:06.0:   IO window: 0xa000-0xafff                                                                                                                                                
[    0.706601] pci 0000:00:06.0:   MEM window: 0xf8500000-0xf85fffff                                                                                                                                       
[    0.706605] pci 0000:00:06.0:   PREFETCH window: 0x000000f8700000-0x000000f87fffff                                                                                                                      
[    0.706609] pci 0000:00:07.0: PCI bridge, secondary bus 0000:17                                                                                                                                         
[    0.706611] pci 0000:00:07.0:   IO window: disabled                                                                                                                                                     
[    0.706615] pci 0000:00:07.0:   MEM window: 0xf8400000-0xf84fffff                                                                                                                                       
[    0.706618] pci 0000:00:07.0:   PREFETCH window: disabled                                                                                                                                               
[    0.706625] pci 0000:1d:04.0: CardBus bridge, secondary bus 0000:1e                                                                                                                                     
[    0.706628] pci 0000:1d:04.0:   IO window: 0x002000-0x0020ff                                                                                                                                            
[    0.706636] pci 0000:1d:04.0:   IO window: 0x002400-0x0024ff                                                                                                                                            
[    0.706642] pci 0000:1d:04.0:   PREFETCH window: 0x120000000-0x123ffffff                                                                                                                                
[    0.706648] pci 0000:1d:04.0:   MEM window: 0x124000000-0x127ffffff                                                                                                                                     
[    0.706653] pci 0000:00:14.4: PCI bridge, secondary bus 0000:1d                                                                                                                                         
[    0.706657] pci 0000:00:14.4:   IO window: 0x2000-0x2fff                                                                                                                                                
[    0.706663] pci 0000:00:14.4:   MEM window: 0xf8600000-0xf86fffff                                                                                                                                       
[    0.706668] pci 0000:00:14.4:   PREFETCH window: 0x00000120000000-0x00000123ffffff                                                                                                                      
[    0.706686] pci 0000:00:05.0: setting latency timer to 64                                                                                                                                               
[    0.706692] pci 0000:00:06.0: setting latency timer to 64                                                                                                                                               
[    0.706698] pci 0000:00:07.0: setting latency timer to 64                                                                                                                                               
[    0.706720] pci 0000:1d:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20                                                                                                                                
[    0.706727] bus: 00 index 0 io port: [0, ffff]                                                                                                                                                          
[    0.706729] bus: 00 index 1 mmio: [0, ffffffffffffffff]                                                                                                                                                 
[    0.706731] bus: 01 index 0 io port: [9000, 9fff]                                                                                                                                                       
[    0.706733] bus: 01 index 1 mmio: [f8200000, f83fffff]                                                                                                                                                  
[    0.706736] bus: 01 index 2 mmio: [f0000000, f7ffffff]                                                                                                                                                  
[    0.706738] bus: 01 index 3 mmio: [0, 0]                                                                                                                                                                
[    0.706740] bus: 0b index 0 mmio: [0, 0]                                                                                                                                                                
[    0.706742] bus: 0b index 1 mmio: [f8000000, f81fffff]                                                                                                                                                  
[    0.706744] bus: 0b index 2 mmio: [0, 0]                                                                                                                                                                
[    0.706746] bus: 0b index 3 mmio: [0, 0]                                                                                                                                                                
[    0.706748] bus: 11 index 0 io port: [a000, afff]                                                                                                                                                       
[    0.706750] bus: 11 index 1 mmio: [f8500000, f85fffff]                                                                                                                                                  
[    0.706752] bus: 11 index 2 mmio: [f8700000, f87fffff]                                                                                                                                                  
[    0.706754] bus: 11 index 3 mmio: [0, 0]                                                                                                                                                                
[    0.706756] bus: 17 index 0 mmio: [0, 0]                                                                                                                                                                
[    0.706758] bus: 17 index 1 mmio: [f8400000, f84fffff]                                                                                                                                                  
[    0.706761] bus: 17 index 2 mmio: [0, 0]                                                                                                                                                                
[    0.706763] bus: 17 index 3 mmio: [0, 0]                                                                                                                                                                
[    0.706765] bus: 1d index 0 io port: [2000, 2fff]                                                                                                                                                       
[    0.706767] bus: 1d index 1 mmio: [f8600000, f86fffff]                                                                                                                                                  
[    0.706769] bus: 1d index 2 mmio: [120000000, 123ffffff]                                                                                                                                                
[    0.706772] bus: 1d index 3 io port: [0, ffff]                                                                                                                                                          
[    0.706774] bus: 1d index 4 mmio: [0, ffffffffffffffff]                                                                                                                                                 
[    0.706776] bus: 1e index 0 io port: [2000, 20ff]                                                                                                                                                       
[    0.706778] bus: 1e index 1 io port: [2400, 24ff]                                                                                                                                                       
[    0.706780] bus: 1e index 2 mmio: [120000000, 123ffffff]                                                                                                                                                
[    0.706783] bus: 1e index 3 mmio: [124000000, 127ffffff]                                                                                                                                                
[    0.706798] NET: Registered protocol family 2                                                                                                                                                           
[    0.745196] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)                                                                                                                         
[    0.746800] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)                                                                                                                       
[    0.751570] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)                                                                                                                                
[    0.752189] TCP: Hash tables configured (established 524288 bind 65536)                                                                                                                                 
[    0.752192] TCP reno registered                                                                                                                                                                         
[    0.761128] NET: Registered protocol family 1                                                                                                                                                           
[    0.761264] checking if image is initramfs... it is                                                                                                                                                     
[    1.526141] Freeing initrd memory: 8480k freed                                                                                                                                                          
[    1.532904] audit: initializing netlink socket (disabled)                                                                                                                                               
[    1.532919] type=2000 audit(1235814196.532:1): initialized                                                                                                                                              
[    1.539308] HugeTLB registered 2 MB page size, pre-allocated 0 pages                                                                                                                                    
[    1.543076] VFS: Disk quotas dquot_6.5.1                                                                                                                                                                
[    1.543199] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)                                                                                                                                   
[    1.543346] msgmni has been set to 7665                                                                                                                                                                 
[    1.543513] io scheduler noop registered                                                                                                                                                                
[    1.543515] io scheduler anticipatory registered                                                                                                                                                        
[    1.543517] io scheduler deadline registered                                                                                                                                                            
[    1.543701] io scheduler cfq registered (default)                                                                                                                                                       
[    1.543810] pci 0000:01:05.0: Boot video device                                                                                                                                                         
[    1.543973] pcieport-driver 0000:00:05.0: setting latency timer to 64                                                                                                                                   
[    1.543994] pcieport-driver 0000:00:05.0: found MSI capability                                                                                                                                          
[    1.544073] pci_express 0000:00:05.0:pcie00: allocate port service                                                                                                                                      
[    1.544150] pci_express 0000:00:05.0:pcie02: allocate port service                                                                                                                                      
[    1.544219] pci_express 0000:00:05.0:pcie03: allocate port service                                                                                                                                      
[    1.544320] pcieport-driver 0000:00:06.0: setting latency timer to 64                                                                                                                                   
[    1.544340] pcieport-driver 0000:00:06.0: found MSI capability                                                                                                                                          
[    1.544361] pci_express 0000:00:06.0:pcie00: allocate port service                                                                                                                                      
[    1.544434] pci_express 0000:00:06.0:pcie03: allocate port service                                                                                                                                      
[    1.544535] pcieport-driver 0000:00:07.0: setting latency timer to 64                                                                                                                                   
[    1.544558] pcieport-driver 0000:00:07.0: found MSI capability                                                                                                                                          
[    1.544581] pci_express 0000:00:07.0:pcie00: allocate port service                                                                                                                                      
[    1.544651] pci_express 0000:00:07.0:pcie03: allocate port service                                                                                                                                      
[    1.598630] hpet_resources: 0xfed00000 is busy                                                                                                                                                          
[    1.598732] Linux agpgart interface v0.103                                                                                                                                                              
[    1.598737] Serial: 8250/16550 driver4 ports, IRQ sharing enabled                                                                                                                                       
[    1.602155] brd: module loaded                                                                                                                                                                          
[    1.602247] input: Macintosh mouse button emulation as /devices/virtual/input/input0                                                                                                                    
[    1.602413] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12                                                                                                                      
[    1.638924] serio: i8042 KBD port at 0x60,0x64 irq 1                                                                                                                                                    
[    1.638933] serio: i8042 AUX port at 0x60,0x64 irq 12                                                                                                                                                   
[    1.657199] mice: PS/2 mouse device common for all mice                                                                                                                                                 
[    1.657379] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0                                                                                                                                       
[    1.657407] rtc0: alarms up to one month, hpet irqs                                                                                                                                                     
[    1.657467] cpuidle: using governor ladder                                                                                                                                                              
[    1.657469] cpuidle: using governor menu                                                                                                                                                                
[    1.657882] TCP cubic registered                                                                                                                                                                        
[    1.658192] registered taskstats version 1                                                                                                                                                              
[    1.658366]   Magic number: 13:715:728                                                                                                                                                                  
[    1.658528] rtc_cmos 00:04: setting system clock to 2009-02-28 09:43:18 UTC (1235814198)                                                                                                                
[    1.658531] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found                                                                                                                                        
[    1.658533] EDD information not available.                                                                                                                                                              
[    1.658591] Freeing unused kernel memory: 540k freed                                                                                                                                                    
[    1.658870] Write protecting the kernel read-only data: 4352k                                                                                                                                           
[    1.678797] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1                                                                                                          
[    1.853115] fuse init (API version 7.9)                                                                                                                                                                 
[    1.897149] ACPI: processor limited to max C-state 1                                                                                                                                                    
[    1.897251] processor ACPI0007:00: registered as cooling_device0                                                                                                                                        
[    1.897255] ACPI: Processor [CPU0] (supports 8 throttling states)                                                                                                                                       
[    1.897344] processor ACPI0007:01: registered as cooling_device1                                                                                                                                        
[    2.238104] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded                                                                                                                                             
[    2.238132] r8169 0000:11:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                                                                                                                              
[    2.238154] r8169 0000:11:00.0: setting latency timer to 64                                                                                                                                             
[    2.238510] eth0: RTL8101e at 0xffffc20000644000, 00:1e:ec:00:9e:6a, XID 34200000 IRQ 2300                                                                                                              
[    2.256859] No dock devices found.                                                                                                                                                                      
[    2.353360] SCSI subsystem initialized                                                                                                                                                                  
[    2.393330] libata version 3.00 loaded.                                                                                                                                                                 
[    2.409127] usbcore: registered new interface driver usbfs                                                                                                                                              
[    2.409155] usbcore: registered new interface driver hub                                                                                                                                                
[    2.409202] usbcore: registered new device driver usb                                                                                                                                                   
[    2.420064] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                        
[    2.420112] pata_atiixp 0000:00:14.1: setting latency timer to 64                                                                                                                                       
[    2.427360] scsi0 : pata_atiixp                                                                                                                                                                         
[    2.427664] scsi1 : pata_atiixp                                                                                                                                                                         
[    2.429043] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8420 irq 14                                                                                                                             
[    2.429047] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8428 irq 15                                                                                                                             
[    2.435347] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver                                                                                                                       
[    2.593568] ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WT03, max UDMA/33                                                                                                                                 
[    2.609472] ata1.00: configured for UDMA/33                                                                                                                                                             
[    2.768687] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WT03 PQ: 0 ANSI: 5                                                                                                                
[    2.769081] ahci 0000:00:12.0: version 3.0                                                                                                                                                              
[    2.769107] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22                                                                                                                               
[    2.769137] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit                                                                                                                             
[    2.769231] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode                                                                                                                
[    2.769234] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pmp pio slum part                                                                                                                        
[    2.769846] scsi2 : ahci                                                                                                                                                                                
[    2.769978] scsi3 : ahci                                                                                                                                                                                
[    2.770054] scsi4 : ahci                                                                                                                                                                                
[    2.770129] scsi5 : ahci                                                                                                                                                                                
[    2.770272] ata3: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909100 irq 22                                                                                                                        
[    2.770276] ata4: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909180 irq 22                                                                                                                        
[    2.770279] ata5: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909200 irq 22                                                                                                                        
[    2.770283] ata6: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909280 irq 22                                                                                                                        
[    3.476036] ata3: softreset failed (device not ready)                                                                                                                                                   
[    3.476043] ata3: failed due to HW bug, retry pmp=0                                                                                                                                                     
[    3.640044] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)                                                                                                                                      
[    4.030818] ata3.00: ATA-8: TOSHIBA MK1646GSX, LB113M, max UDMA/100                                                                                                                                     
[    4.030821] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)                                                                                                                               
[    4.030832] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd                                                                                                                                        
[    4.031669] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd                                                                                                                                        
[    4.031672] ata3.00: configured for UDMA/100                                                                                                                                                            
[    4.364053] ata4: SATA link down (SStatus 0 SControl 300)                                                                                                                                               
[    4.701045] ata5: SATA link down (SStatus 0 SControl 300)                                                                                                                                               
[    5.036045] ata6: SATA link down (SStatus 0 SControl 300)                                                                                                                                               
[    5.052129] scsi 2:0:0:0: Direct-Access     ATA      TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5                                                                                                                
[    5.052318] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                           
[    5.052338] ohci_hcd 0000:00:13.0: OHCI Host Controller                                                                                                                                                 
[    5.052393] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1                                                                                                                        
[    5.052428] ohci_hcd 0000:00:13.0: irq 16, io mem 0xf8904000                                                                                                                                            
[    5.108199] usb usb1: configuration #1 chosen from 1 choice                                                                                                                                             
[    5.108230] hub 1-0:1.0: USB hub found                                                                                                                                                                  
[    5.108245] hub 1-0:1.0: 2 ports detected                                                                                                                                                               
[    5.214942] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                                                                           
[    5.214963] ohci_hcd 0000:00:13.1: OHCI Host Controller                                                                                                                                                 
[    5.216777] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2                                                                                                                        
[    5.216820] ohci_hcd 0000:00:13.1: irq 17, io mem 0xf8905000                                                                                                                                            
[    5.268225] usb usb2: configuration #1 chosen from 1 choice                                                                                                                                             
[    5.268258] hub 2-0:1.0: USB hub found                                                                                                                                                                  
[    5.268274] hub 2-0:1.0: 2 ports detected                                                                                                                                                               
[    5.372332] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18                                                                                                                           
[    5.372352] ohci_hcd 0000:00:13.2: OHCI Host Controller                                                                                                                                                 
[    5.372379] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3                                                                                                                        
[    5.372410] ohci_hcd 0000:00:13.2: irq 18, io mem 0xf8906000                                                                                                                                            
[    5.428195] usb usb3: configuration #1 chosen from 1 choice                                                                                                                                             
[    5.428227] hub 3-0:1.0: USB hub found                                                                                                                                                                  
[    5.428244] hub 3-0:1.0: 2 ports detected                                                                                                                                                               
[    5.637486] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17                                                                                                                           
[    5.637505] ohci_hcd 0000:00:13.3: OHCI Host Controller                                                                                                                                                 
[    5.637541] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4                                                                                                                        
[    5.637564] ohci_hcd 0000:00:13.3: irq 17, io mem 0xf8907000                                                                                                                                            
[    5.692161] usb usb4: configuration #1 chosen from 1 choice                                                                                                                                             
[    5.692191] hub 4-0:1.0: USB hub found                                                                                                                                                                  
[    5.692206] hub 4-0:1.0: 2 ports detected                                                                                                                                                               
[    5.772035] usb 3-1: new low speed USB device using ohci_hcd and address 2                                                                                                                              
[    5.801641] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18                                                                                                                           
[    5.801660] ohci_hcd 0000:00:13.4: OHCI Host Controller                                                                                                                                                 
[    5.801696] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 5                                                                                                                        
[    5.801719] ohci_hcd 0000:00:13.4: irq 18, io mem 0xf8908000                                                                                                                                            
[    5.856248] usb usb5: configuration #1 chosen from 1 choice                                                                                                                                             
[    5.856281] hub 5-0:1.0: USB hub found                                                                                                                                                                  
[    5.856297] hub 5-0:1.0: 2 ports detected                                                                                                                                                               
[    5.940032] usb 3-1: configuration #1 chosen from 1 choice                                                                                                                                              
[    5.960320] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19                                                                                                                           
[    5.960338] ehci_hcd 0000:00:13.5: EHCI Host Controller                                                                                                                                                 
[    5.960368] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 6                                                                                                                        
[    5.960404] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround                                                                                                                       
[    5.960424] ehci_hcd 0000:00:13.5: debug port 1                                                                                                                                                         
[    5.960447] ehci_hcd 0000:00:13.5: irq 19, io mem 0xf8909400                                                                                                                                            
[    5.972035] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004                                                                                                                       
[    5.972167] usb usb6: configuration #1 chosen from 1 choice                                                                                                                                             
[    5.972199] hub 6-0:1.0: USB hub found                                                                                                                                                                  
[    5.972208] hub 6-0:1.0: 10 ports detected                                                                                                                                                              
[    6.104070] usb 3-1: USB disconnect, address 2                                                                                                                                                          
[    6.182302] ohci1394 0000:1d:04.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21                                                                                                                           
[    6.232104] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[f8606000-f86067ff]  Max Packet=[2048]  IR/IT contexts=[4/8]                                                                        
[    6.233502] scsi 0:0:0:0: Attached scsi generic sg0 type 5                                                                                                                                              
[    6.233551] scsi 2:0:0:0: Attached scsi generic sg1 type 0                                                                                                                                              
[    6.270402] Driver 'sd' needs updating - please use bus_type methods                                                                                                                                    
[    6.270545] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)                                                                                                                           
[    6.270563] sd 2:0:0:0: [sda] Write Protect is off                                                                                                                                                      
[    6.270566] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                                                                                                                   
[    6.270594] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                                                                     
[    6.270682] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)                                                                                                                           
[    6.270698] sd 2:0:0:0: [sda] Write Protect is off                                                                                                                                                      
[    6.270700] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                                                                                                                   
[    6.270727] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                                                                     
[    6.270732]  sda:Driver 'sr' needs updating - please use bus_type methods                                                                                                                            
[    6.306975] usbcore: registered new interface driver hiddev                                                                                                                                             
[    6.306997] usbcore: registered new interface driver usbhid                                                                                                                                             
[    6.307000] usbhid: v2.6:USB HID core driver                                                                                                                                                            
[    6.314135] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray                                                                                                                       
[    6.314142] Uniform CD-ROM driver Revision: 3.20                                                                                                                                                        
[    6.314283] sr 0:0:0:0: Attached scsi CD-ROM sr0                                                                                                                                                        
[    6.380771]  sda1 sda2 sda3 < sda5 sda6>                                                                                                                                                               
[    6.415874] sd 2:0:0:0: [sda] Attached SCSI disk                                                                                                                                                        
[    6.617056] usb 3-1: new low speed USB device using ohci_hcd and address 3                                                                                                                              
[    6.784230] usb 3-1: configuration #1 chosen from 1 choice                                                                                                                                              
[    6.791903] input: Logitech Optical USB Mouse as /devices/pci0000:00/0000:00:13.2/usb3/3-1/3-1:1.0/input/input2                                                                                         
[    6.792457] PM: Starting manual resume from disk                                                                                                                                                        
[    6.792461] PM: Resume from partition 8:6                                                                                                                                                               
[    6.792463] PM: Checking hibernation image.                                                                                                                                                             
[    6.792652] PM: Resume from disk failed.                                                                                                                                                                
[    6.816260] input,hidraw0: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:13.2-1                                                                                                       
[    6.852133] kjournald starting.  Commit interval 5 seconds                                                                                                                                              
[    6.852162] EXT3-fs: mounted filesystem with ordered data mode.                                                                                                                                         
[    7.505171] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f81c2404ccc]                                                                                                                             
[   13.549817] udevd version 124 started                                                                                                                                                                   
[   13.858482] pci_hotplug: PCI Hot Plug PCI Core version: 0.5                                                                                                                                             
[   13.908266] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4                                                                                                                                
[   13.952680] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3                                                                                                                   
[   13.972072] ACPI: Power Button (FF) [PWRF]                                                                                                                                                              
[   13.972218] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4                                                                                                                 
[   13.972325] ACPI: Lid Switch [LID]                                                                                                                                                                      
[   13.972404] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5                                                                                                          
[   14.004052] ACPI: Power Button (CM) [PWRB]                                                                                                                                                              
[   14.115772] acpi device:29: registered as cooling_device2                                                                                                                                               
[   14.116091] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:26/device:27/input/input6                                                                                              
[   14.137044] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)                                                                                                                               
[   14.141806] ACPI: AC Adapter [ACAD] (on-line)                                                                                                                                                           
[   14.443957] ACPI: Battery Slot [BAT1] (battery present)                                                                                                                                                 
[   14.515155] ath_hal: module license 'Proprietary' taints kernel.                                                                                                                                        
[   14.532335] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)                                                                                                                  
[   14.560218] wlan: 0.9.4                                                                                                                                                                                 
[   14.596225] ath_pci: 0.9.4                                                                                                                                                                              
[   14.596282] ath_pci 0000:17:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19                                                                                                                            
[   14.596292] ath_pci 0000:17:00.0: setting latency timer to 64                                                                                                                                           
[   14.620711] wifi%d: unable to attach hardware: 'Hardware revision not supported' (HAL status 13)                                                                                                        
[   14.620729] ath_pci 0000:17:00.0: PCI INT A disabled                                                                                                                                                    
[   14.816201] Linux video capture interface: v2.00                                                                                                                                                        
[   15.056242] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8410, revision 0                                                                                                                       
[   15.208910] tifm_7xx1 0000:1d:04.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22                                                                                                                          
[   15.231021] Yenta: CardBus bridge found at 0000:1d:04.0 [1179:ff00]                                                                                                                                     
[   15.231048] Yenta: Enabling burst memory read transactions                                                                                                                                              
[   15.231054] Yenta: Using CSCINT to route CSC interrupts to PCI                                                                                                                                          
[   15.231056] Yenta: Routing CardBus interrupts to PCI                                                                                                                                                    
[   15.231062] Yenta TI: socket 0000:1d:04.0, mfunc 0x10a01b22, devctl 0x64                                                                                                                                
[   15.298922] input: PC Speaker as /devices/platform/pcspkr/input/input7                                                                                                                                  
[   15.336567] sdhci: Secure Digital Host Controller Interface driver                                                                                                                                      
[   15.336571] sdhci: Copyright(c) Pierre Ossman                                                                                                                                                           
[   15.390929] cx23885 driver version 0.0.1 loaded                                                                                                                                                         
[   15.465174] Yenta: ISA IRQ mask 0x0cf8, PCI irq 20                                                                                                                                                      
[   15.465183] Socket status: 30000006                                                                                                                                                                     
[   15.465186] Yenta: Raising subordinate bus# of parent bus (#1d) from #1e to #21                                                                                                                         
[   15.465192] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff                                                                                                                                       
[   15.465312] pcmcia: parent PCI bridge Memory window: 0xf8600000 - 0xf86fffff                                                                                                                            
[   15.465315] pcmcia: parent PCI bridge Memory window: 0x120000000 - 0x123ffffff                                                                                                                          
[   15.466069] cx23885 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17                                                                                                                            
[   15.466201] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge WinTV-HVR1500 [card=6,autodetected]                                                                                                 
[   15.566080] sdhci-pci 0000:1d:04.3: SDHCI controller found [104c:803c] (rev 0)                                                                                                                          
[   15.566098] sdhci-pci 0000:1d:04.3: PCI INT C -> GSI 22 (level, low) -> IRQ 22                                                                                                                          
[   15.566200] mmc0: SDHCI controller on PCI [0000:1d:04.3] using DMA                                                                                                                                      
[   15.607799] tveeprom 1-0050: Hauppauge model 77001, rev D4C0, serial# 2396878                                                                                                                           
[   15.607804] tveeprom 1-0050: MAC address is 00-0D-FE-24-92-CE                                                                                                                                           
[   15.607807] tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)                                                                                                                            
[   15.607810] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)                                                                                                                        
[   15.607812] tveeprom 1-0050: audio processor is CX23885 (idx 39)                                                                                                                                        
[   15.607815] tveeprom 1-0050: decoder processor is CX23885 (idx 33)                                                                                                                                      
[   15.607817] tveeprom 1-0050: has no radio                                                                                                                                                               
[   15.607819] cx23885[0]: hauppauge eeprom: model=77001                                                                                                                                                   
[   15.607823] cx23885_dvb_register() allocating 1 frontend(s)                                                                                                                                             
[   15.615346] cx23885[0]: cx23885 based dvb card                                                                                                                                                          
[   15.902455] xc2028 2-0061: creating new instance                                                                                                                                                        
[   15.902460] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner                                                                                                                                       
[   15.902467] DVB: registering new adapter (cx23885[0])                                                                                                                                                   
[   15.902471] DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...                                                                                                                
[   15.902931] cx23885_dev_checkrevision() Hardware revision = 0xb0                                                                                                                                        
[   15.902940] cx23885[0]/0: found at 0000:0b:00.0, rev: 2, irq: 17, latency: 0, mmio: 0xf8000000                                                                                                          
[   15.902948] cx23885 0000:0b:00.0: setting latency timer to 64                                                                                                                                           
[   16.103474] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                                                          
[   16.140472] hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...                                                                                                                         
[   16.413769] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x9280b1, caps: 0xa04713/0x204000                                                                                                                
[   16.503236] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8                                                                                                            
[   17.533244] lp: driver loaded but no devices found                                                                                                                                                      
[   17.794171] Adding 2072344k swap on /dev/sda6.  Priority:-1 extents:1 across:2072344k                                                                                                                   
[   18.357736] EXT3 FS on sda5, internal journal                                                                                                                                                           
[   19.636176] type=1505 audit(1235835816.295:2): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=4312                                                                  
[   19.636416] type=1505 audit(1235835816.295:3): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4312                                                                                 
[   19.746071] type=1505 audit(1235835816.406:4): operation="profile_load" name="/usr/sbin/mysqld" name2="default" pid=4316                                                                                
[   19.920286] ip_tables: (C) 2000-2006 Netfilter Core Team                                                                                                                                                
[   20.611198] ACPI: WMI: Mapper loaded                                                                                                                                                                    
[   21.030969] powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-58 processors (2 cpu cores) (version 2.20.00)                                                                                
[   21.031723] powernow-k8:    0 : fid 0xb (1900 MHz), vid 0x12                                                                                                                                            
[   21.031727] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x13                                                                                                                                            
[   21.031730] powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x14                                                                                                                                            
[   21.031732] powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e                                                                                                                                             
[   21.883971] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)                                                                                                                    
[   24.737977] ppdev: user-space parallel port driver                                                                                                                                                      
[   25.714086] NET: Registered protocol family 10                                                                                                                                                          
[   25.714587] lo: Disabled Privacy Extensions                                                                                                                                                             
[   27.004030] Clocksource tsc unstable (delta = -89458750 ns)                                                                                                                                             
[   30.375035] Bluetooth: Core ver 2.13                                                                                                                                                                    
[   30.378036] NET: Registered protocol family 31                                                                                                                                                          
[   30.378048] Bluetooth: HCI device and connection manager initialized                                                                                                                                    
[   30.378057] Bluetooth: HCI socket layer initialized                                                                                                                                                     
[   30.426231] Bluetooth: L2CAP ver 2.11                                                                                                                                                                   
[   30.426247] Bluetooth: L2CAP socket layer initialized                                                                                                                                                   
[   30.474015] Bluetooth: BNEP (Ethernet Emulation) ver 1.3                                                                                                                                                
[   30.474032] Bluetooth: BNEP filters: protocol multicast                                                                                                                                                 
[   30.544634] Bridge firewalling registered                                                                                                                                                               
[   30.567272] Bluetooth: SCO (Voice Link) ver 0.6                                                                                                                                                         
[   30.567290] Bluetooth: SCO socket layer initialized
[   30.722214] Bluetooth: RFCOMM socket layer initialized
[   30.722270] Bluetooth: RFCOMM TTY layer initialized
[   30.722275] Bluetooth: RFCOMM ver 1.10
[   32.293561] pci 0000:01:05.0: power state changed by ACPI to D0
[   32.293599] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   32.671169] [drm] Initialized drm 1.1.0 20060810
[   32.700337] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   33.321106] [drm] Setting GART location based on new memory map
[   33.323344] [drm] Loading RS690 Microcode
[   33.323395] [drm] Num pipes: 1
[   33.323406] [drm] writeback test succeeded in 1 usecs
[   34.913930] r8169: eth0: link up
[   34.913962] r8169: eth0: link up
[   35.147251] NET: Registered protocol family 17
[   45.452057] eth0: no IPv6 routers present
[   84.131948] [drm] Num pipes: 1
[   84.870309] [drm] Setting GART location based on new memory map
[   84.871357] [drm] Loading RS690 Microcode
[   84.871389] [drm] Num pipes: 1
[   84.871401] [drm] writeback test succeeded in 1 usecs
[   90.499863] [drm] Num pipes: 1
[   91.241423] [drm] Setting GART location based on new memory map
[   91.243761] [drm] Loading RS690 Microcode
[   91.243811] [drm] Num pipes: 1
[   91.243822] [drm] writeback test succeeded in 1 usecs
[   97.047847] [drm] Num pipes: 1
[   97.782101] [drm] Setting GART location based on new memory map
[   97.783691] [drm] Loading RS690 Microcode
[   97.783721] [drm] Num pipes: 1
[   97.783733] [drm] writeback test succeeded in 1 usecs
[  142.465836] hda-intel: Invalid position buffer, using LPIB read method instead.
[  247.268961] firmware: requesting xc3028-v27.fw
[  247.340353] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  247.539041] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[  248.061922] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
[  248.061930] xc2028 2-0061: -5 returned from send
[  248.061934] xc2028 2-0061: Error -22 while loading base firmware
[  248.314577] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[  248.837402] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
[  248.837410] xc2028 2-0061: -5 returned from send
[  248.837413] xc2028 2-0061: Error -22 while loading base firmware
[  250.037857] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[  251.194103] xc2028 2-0061: Loading firmware for type=D2633 DTV6 ATSC (10030), id 0000000000000000.
thomas@toshiba:~$

----------------------------------------
> From: nickotym@hotmail.com
> To: devin.heitmueller@gmail.com
> CC: linux-media@vger.kernel.org
> Subject: RE: HVR 1500 tuner seems to be recognized
> Date: Sat, 28 Feb 2009 08:47:36 -0600
>
>
> Devin,
>
> I put the commands you suggested into /etc/modules as I can't seem to get the expresscard slot to hotplug. I wonder if the line I found may have something to do with both problems. In the full output of dmesg I found "Warning! ehci_hcd should always be loaded before uhci_pcd and ohci_pcd, not after."
>
> Here is the md5sum output:
> "thomas@toshiba:~$ md5sum /lib/firmware/xc*
> 293dc5e915d9a0f74a368f8a2ce3cc10 /lib/firmware/xc3028-v27.fw"
>
>
> Here is the full dmesg output after trying to scan for channels:
>
> thomas@toshiba:~$ sudo scan /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB
> [sudo] password for thomas:
> scanning /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> main:2247: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 16 Device or resource busy
> thomas@toshiba:~$ dmesg
> [ 0.000000] Initializing cgroup subsys cpuset
> [ 0.000000] Initializing cgroup subsys cpu
> [ 0.000000] Linux version 2.6.27-11-generic (buildd@crested) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Thu Jan 29 19:28:32 UTC 2009 (Ubuntu 2.6.27-11.27-generic)
> [ 0.000000] Command line: root=UUID=86e1e836-d4a6-436a-b0de-46e937be9a64 ro quiet splash
> [ 0.000000] KERNEL supported cpus:
> [ 0.000000] Intel GenuineIntel
> [ 0.000000] AMD AuthenticAMD
> [ 0.000000] Centaur CentaurHauls
> [ 0.000000] BIOS-provided physical RAM map:
> [ 0.000000] BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
> [ 0.000000] BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
> [ 0.000000] BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
> [ 0.000000] BIOS-e820: 0000000000100000 - 00000000d7e70000 (usable)
> [ 0.000000] BIOS-e820: 00000000d7e70000 - 00000000d7e83000 (ACPI data)
> [ 0.000000] BIOS-e820: 00000000d7e83000 - 00000000d7e85000 (ACPI NVS)
> [ 0.000000] BIOS-e820: 00000000d7e85000 - 00000000f0000000 (reserved)
> [ 0.000000] BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [ 0.000000] BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [ 0.000000] BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [ 0.000000] BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
> [ 0.000000] DMI present.
> [ 0.000000] last_pfn = 0x120000 max_arch_pfn = 0x3ffffffff
> [ 0.000000] last_pfn = 0xd7e70 max_arch_pfn = 0x3ffffffff
> [ 0.000000] init_memory_mapping
> [ 0.000000] 0000000000 - 00d7e00000 page 2M
> [ 0.000000] 00d7e00000 - 00d7e70000 page 4k
> [ 0.000000] kernel direct mapping tables up to d7e70000 @ 8000-e000
> [ 0.000000] last_map_addr: d7e70000 end: d7e70000
> [ 0.000000] init_memory_mapping
> [ 0.000000] 0100000000 - 0120000000 page 2M
> [ 0.000000] kernel direct mapping tables up to 120000000 @ c000-12000
> [ 0.000000] last_map_addr: 120000000 end: 120000000
> [ 0.000000] RAMDISK: 377a7000 - 37fef1d1
> [ 0.000000] ACPI: RSDP 000F7260, 0024 (r2 TOSCPL)
> [ 0.000000] ACPI: XSDT D7E7AA18, 0064 (r1 TOSCPL TOSCPL00 6040000 LTP 0)
> [ 0.000000] ACPI: FACP D7E828F7, 00F4 (r3 TOSCPL Herring 6040000 ATI F4240)
> [ 0.000000] ACPI: DSDT D7E7AA7C, 7E7B (r1 TOSCPL SB600 6040000 MSFT 3000000)
> [ 0.000000] ACPI: FACS D7E84FC0, 0040
> [ 0.000000] ACPI: TCPA D7E82A5F, 0032 (r2 TOSCPL 6040000 PTEC 0)
> [ 0.000000] ACPI: SLIC D7E82A91, 0176 (r1 TOSCPL TOSCPL00 6040000 LOHR 0)
> [ 0.000000] ACPI: SSDT D7E82C07, 0206 (r1 PTLTD POWERNOW 6040000 LTP 1)
> [ 0.000000] ACPI: APIC D7E82E0D, 0054 (r1 PTLTD APIC 6040000 LTP 0)
> [ 0.000000] ACPI: MCFG D7E82E61, 003C (r1 PTLTD MCFG 6040000 LTP 0)
> [ 0.000000] ACPI: HPET D7E82E9D, 0038 (r1 PTLTD HPETTBL 6040000 LTP 1)
> [ 0.000000] ACPI: ASF! D7E82ED5, 012B (r32 DMA AMDTBL 6040000 PTL 1)
> [ 0.000000] ACPI: DMI detected: Toshiba
> [ 0.000000] Scanning NUMA topology in Northbridge 24
> [ 0.000000] No NUMA configuration found
> [ 0.000000] Faking a node at 0000000000000000-0000000120000000
> [ 0.000000] Bootmem setup node 0 0000000000000000-0000000120000000
> [ 0.000000] NODE_DATA [0000000000001000 - 0000000000005fff]
> [ 0.000000] bootmap [000000000000d000 - 0000000000030fff] pages 24
> [ 0.000000] (7 early reservations) ==> bootmem [0000000000 - 0120000000]
> [ 0.000000] #0 [0000000000 - 0000001000] BIOS data page ==> [0000000000 - 0000001000]
> [ 0.000000] #1 [0000006000 - 0000008000] TRAMPOLINE ==> [0000006000 - 0000008000]
> [ 0.000000] #2 [0000200000 - 00008b9f5c] TEXT DATA BSS ==> [0000200000 - 00008b9f5c]
> [ 0.000000] #3 [00377a7000 - 0037fef1d1] RAMDISK ==> [00377a7000 - 0037fef1d1]
> [ 0.000000] #4 [000009dc00 - 0000100000] BIOS reserved ==> [000009dc00 - 0000100000]
> [ 0.000000] #5 [0000008000 - 000000c000] PGTABLE ==> [0000008000 - 000000c000]
> [ 0.000000] #6 [000000c000 - 000000d000] PGTABLE ==> [000000c000 - 000000d000]
> [ 0.000000] found SMP MP-table at [ffff8800000f7300] 000f7300
> [ 0.000000] [ffffe20000000000-ffffe200047fffff] PMD -> [ffff880028200000-ffff88002bffffff] on node 0
> [ 0.000000] Zone PFN ranges:
> [ 0.000000] DMA 0x00000000 -> 0x00001000
> [ 0.000000] DMA32 0x00001000 -> 0x00100000
> [ 0.000000] Normal 0x00100000 -> 0x00120000
> [ 0.000000] Movable zone start PFN for each node
> [ 0.000000] early_node_map[3] active PFN ranges
> [ 0.000000] 0: 0x00000000 -> 0x0000009d
> [ 0.000000] 0: 0x00000100 -> 0x000d7e70
> [ 0.000000] 0: 0x00100000 -> 0x00120000
> [ 0.000000] On node 0 totalpages: 1015309
> [ 0.000000] DMA zone: 2104 pages, LIFO batch:0
> [ 0.000000] DMA32 zone: 863920 pages, LIFO batch:31
> [ 0.000000] Normal zone: 129024 pages, LIFO batch:31
> [ 0.000000] Detected use of extended apic ids on hypertransport bus
> [ 0.000000] ACPI: PM-Timer IO Port: 0x8008
> [ 0.000000] ACPI: Local APIC address 0xfee00000
> [ 0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [ 0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [ 0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [ 0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [ 0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [ 0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
> [ 0.000000] ACPI: IRQ9 used by override.
> [ 0.000000] Setting APIC routing to flat
> [ 0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000
> [ 0.000000] Using ACPI (MADT) for SMP configuration information
> [ 0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [ 0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [ 0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [ 0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
> [ 0.000000] PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
> [ 0.000000] PM: Registered nosave memory: 00000000d7e70000 - 00000000d7e83000
> [ 0.000000] PM: Registered nosave memory: 00000000d7e83000 - 00000000d7e85000
> [ 0.000000] PM: Registered nosave memory: 00000000d7e85000 - 00000000f0000000
> [ 0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
> [ 0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
> [ 0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
> [ 0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [ 0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
> [ 0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
> [ 0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
> [ 0.000000] PERCPU: Allocating 64928 bytes of per cpu data
> [ 0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
> [ 0.000000] Built 1 zonelists in Node order, mobility grouping on. Total pages: 995048
> [ 0.000000] Policy zone: Normal
> [ 0.000000] Kernel command line: root=UUID=86e1e836-d4a6-436a-b0de-46e937be9a64 ro quiet splash
> [ 0.000000] Initializing CPU#0
> [ 0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [ 0.000000] TSC: Unable to calibrate against PIT
> [ 0.000000] TSC: using PMTIMER reference calibration
> [ 0.000000] Detected 1895.242 MHz processor.
> [ 0.004000] Console: colour VGA+ 80x25
> [ 0.004000] console [tty0] enabled
> [ 0.004000] Checking aperture...
> [ 0.004000] No AGP bridge found
> [ 0.004000] Node 0: aperture @ 264000000 size 32 MB
> [ 0.004000] Aperture beyond 4GB. Ignoring.
> [ 0.004000] Your BIOS doesn't leave a aperture memory hole
> [ 0.004000] Please enable the IOMMU option in the BIOS setup
> [ 0.004000] This costs you 64 MB of RAM
> [ 0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
> [ 0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
> [ 0.004000] Memory: 3916464k/4718592k available (3116k kernel code, 144772k reserved, 1575k data, 540k init)
> [ 0.004000] CPA: page pool initialized 1 of 1 pages preallocated
> [ 0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [ 0.004000] hpet clockevent registered
> [ 0.004009] Calibrating delay loop (skipped), value calculated using timer frequency.. 3790.48 BogoMIPS (lpj=7580968)
> [ 0.004039] Security Framework initialized
> [ 0.004046] SELinux: Disabled at boot.
> [ 0.004061] AppArmor: AppArmor initialized
> [ 0.004541] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [ 0.007571] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [ 0.008889] Mount-cache hash table entries: 256
> [ 0.009127] Initializing cgroup subsys ns
> [ 0.009132] Initializing cgroup subsys cpuacct
> [ 0.009135] Initializing cgroup subsys memory
> [ 0.009154] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [ 0.009157] CPU: L2 Cache: 512K (64 bytes/line)
> [ 0.009160] CPU 0/0 -> Node 0
> [ 0.009162] tseg: 00d7f00000
> [ 0.009163] CPU: Physical Processor ID: 0
> [ 0.009165] CPU: Processor Core ID: 0
> [ 0.009176] using C1E aware idle routine
> [ 0.010991] ACPI: Core revision 20080609
> [ 0.013996] ACPI: Checking initramfs for custom DSDT
> [ 0.408466] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
> [ 0.412025] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [ 0.412025] ...trying to set up timer (IRQ0) through the 8259A ...
> [ 0.412025] ..... (found apic 0 pin 0) ...
> [ 0.455153] ....... works.
> [ 0.455154] CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02
> [ 0.455158] Using local APIC timer interrupts.
> [ 0.456030] APIC timer calibration result 12468721
> [ 0.456032] Detected 12.468 MHz APIC timer.
> [ 0.456211] Booting processor 1/1 ip 6000
> [ 0.004000] Initializing CPU#1
> [ 0.004000] Calibrating delay using timer specific routine.. 3790.53 BogoMIPS (lpj=7581071)
> [ 0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [ 0.004000] CPU: L2 Cache: 512K (64 bytes/line)
> [ 0.004000] CPU 1/1 -> Node 0
> [ 0.004000] CPU: Physical Processor ID: 0
> [ 0.004000] CPU: Processor Core ID: 1
> [ 0.544188] CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-58 stepping 02
> [ 0.544216] Brought up 2 CPUs
> [ 0.544218] Total of 2 processors activated (7581.01 BogoMIPS).
> [ 0.544058] System has AMD C1E enabled
> [ 0.544068] Switch to broadcast mode on CPU1
> [ 0.544264] CPU0 attaching sched-domain:
> [ 0.544267] domain 0: span 0-1 level CPU
> [ 0.544270] groups: 0 1
> [ 0.544273] domain 1: span 0-1 level NODE
> [ 0.544275] groups: 0-1
> [ 0.544281] CPU1 attaching sched-domain:
> [ 0.544282] domain 0: span 0-1 level CPU
> [ 0.544284] groups: 1 0
> [ 0.544288] domain 1: span 0-1 level NODE
> [ 0.544290] groups: 0-1
> [ 0.544388] Switch to broadcast mode on CPU0
> [ 0.544388] net_namespace: 1552 bytes
> [ 0.544388] Booting paravirtualized kernel on bare hardware
> [ 0.544388] Time: 8:31:23 Date: 02/28/09
> [ 0.544410] NET: Registered protocol family 16
> [ 0.544436] node 0 link 0: io port [1000, fffff]
> [ 0.544436] TOM: 00000000e0000000 aka 3584M
> [ 0.544436] node 0 link 0: mmio [f8300000, ffffffff]
> [ 0.544436] node 0 link 0: mmio [f8200000, f82fffff]
> [ 0.544436] node 0 link 0: mmio [f8000000, f81fffff]
> [ 0.544436] node 0 link 0: mmio [f0000000, f7ffffff]
> [ 0.544436] node 0 link 0: mmio [a0000, bffff]
> [ 0.544436] node 0 link 0: mmio [f0000000, efffffff]
> [ 0.544436] node 0 link 0: mmio [e0000000, efffffff]
> [ 0.544436] node 0 link 0: mmio [e0000000, dfffffff]
> [ 0.544436] TOM2: 0000000120000000 aka 4608M
> [ 0.544436] bus: [00,ff] on node 0 link 0
> [ 0.544436] bus: 00 index 0 io port: [0, ffff]
> [ 0.544436] bus: 00 index 1 mmio: [e0000000, ffffffff]
> [ 0.544436] bus: 00 index 2 mmio: [a0000, bffff]
> [ 0.544436] bus: 00 index 3 mmio: [120000000, fcffffffff]
> [ 0.544436] ACPI: bus type pci registered
> [ 0.544436] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 29
> [ 0.544436] PCI: MCFG area at e0000000 reserved in E820
> [ 0.545712] PCI: Using MMCONFIG at e0000000 - e1dfffff
> [ 0.545714] PCI: Using configuration type 1 for base access
> [ 0.548966] ACPI: EC: Look up EC in DSDT
> [ 0.551720] ACPI Error (evregion-0315): No handler for Region [ERAM] (ffff88011fa35d80) [EmbeddedControl] [20080609]
> [ 0.551726] ACPI Error (exfldio-0291): Region EmbeddedControl(3) has no handler [20080609]
> [ 0.551732] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.HTEV] (Node ffff88011fa335c0), AE_NOT_EXIST
> [ 0.551780] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.LPC0.EC0_._REG] (Node ffff88011fa3b960), AE_NOT_EXIST
> [ 0.554363] ACPI: BIOS _OSI(Linux) query ignored via DMI
> [ 0.556693] ACPI: Interpreter enabled
> [ 0.556697] ACPI: (supports S0 S3 S4 S5)
> [ 0.556713] ACPI: Using IOAPIC for interrupt routing
> [ 0.560049] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [ 0.632565] ACPI: EC: GPE = 0x13, I/O: command/status = 0x66, data = 0x62
> [ 0.632565] ACPI: EC: driver started in interrupt mode
> [ 0.632565] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [ 0.632565] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
> [ 0.632565] pci 0000:00:05.0: PME# disabled
> [ 0.632565] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
> [ 0.632565] pci 0000:00:06.0: PME# disabled
> [ 0.632565] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
> [ 0.632565] pci 0000:00:07.0: PME# disabled
> [ 0.632565] PCI: 0000:00:12.0 reg 10 io port: [8440, 8447]
> [ 0.632565] PCI: 0000:00:12.0 reg 14 io port: [8434, 8437]
> [ 0.632565] PCI: 0000:00:12.0 reg 18 io port: [8438, 843f]
> [ 0.632565] PCI: 0000:00:12.0 reg 1c io port: [8430, 8433]
> [ 0.632565] PCI: 0000:00:12.0 reg 20 io port: [8400, 840f]
> [ 0.632565] PCI: 0000:00:12.0 reg 24 32bit mmio: [f8909000, f89093ff]
> [ 0.632565] pci 0000:00:12.0: set SATA to AHCI mode
> [ 0.632565] PCI: 0000:00:13.0 reg 10 32bit mmio: [f8904000, f8904fff]
> [ 0.632565] PCI: 0000:00:13.1 reg 10 32bit mmio: [f8905000, f8905fff]
> [ 0.632565] PCI: 0000:00:13.2 reg 10 32bit mmio: [f8906000, f8906fff]
> [ 0.632565] PCI: 0000:00:13.3 reg 10 32bit mmio: [f8907000, f8907fff]
> [ 0.632565] PCI: 0000:00:13.4 reg 10 32bit mmio: [f8908000, f8908fff]
> [ 0.632597] PCI: 0000:00:13.5 reg 10 32bit mmio: [f8909400, f89094ff]
> [ 0.632645] pci 0000:00:13.5: supports D1
> [ 0.632646] pci 0000:00:13.5: supports D2
> [ 0.632648] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
> [ 0.632653] pci 0000:00:13.5: PME# disabled
> [ 0.632685] PCI: 0000:00:14.0 reg 10 io port: [8410, 841f]
> [ 0.632745] PCI: 0000:00:14.1 reg 10 io port: [1f0, 1f7]
> [ 0.632752] PCI: 0000:00:14.1 reg 14 io port: [3f4, 3f7]
> [ 0.632760] PCI: 0000:00:14.1 reg 18 io port: [0, 7]
> [ 0.632767] PCI: 0000:00:14.1 reg 1c io port: [0, 3]
> [ 0.632774] PCI: 0000:00:14.1 reg 20 io port: [8420, 842f]
> [ 0.632827] PCI: 0000:00:14.2 reg 10 64bit mmio: [f8900000, f8903fff]
> [ 0.632868] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
> [ 0.632872] pci 0000:00:14.2: PME# disabled
> [ 0.633054] PCI: 0000:01:05.0 reg 10 64bit mmio: [f0000000, f7ffffff]
> [ 0.633060] PCI: 0000:01:05.0 reg 18 64bit mmio: [f8300000, f830ffff]
> [ 0.633064] PCI: 0000:01:05.0 reg 20 io port: [9000, 90ff]
> [ 0.633068] PCI: 0000:01:05.0 reg 24 32bit mmio: [f8200000, f82fffff]
> [ 0.633077] pci 0000:01:05.0: supports D1
> [ 0.633079] pci 0000:01:05.0: supports D2
> [ 0.633093] PCI: bridge 0000:00:01.0 io port: [9000, 9fff]
> [ 0.633096] PCI: bridge 0000:00:01.0 32bit mmio: [f8200000, f83fffff]
> [ 0.633100] PCI: bridge 0000:00:01.0 64bit mmio pref: [f0000000, f7ffffff]
> [ 0.633151] PCI: 0000:0b:00.0 reg 10 64bit mmio: [f8000000, f81fffff]
> [ 0.633227] pci 0000:0b:00.0: supports D1
> [ 0.633229] pci 0000:0b:00.0: supports D2
> [ 0.633231] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot
> [ 0.633237] pci 0000:0b:00.0: PME# disabled
> [ 0.633284] PCI: bridge 0000:00:05.0 32bit mmio: [f8000000, f81fffff]
> [ 0.633331] PCI: 0000:11:00.0 reg 10 io port: [a000, a0ff]
> [ 0.633349] PCI: 0000:11:00.0 reg 18 64bit mmio: [f8500000, f8500fff]
> [ 0.633368] PCI: 0000:11:00.0 reg 30 32bit mmio: [0, 1ffff]
> [ 0.633385] pci 0000:11:00.0: supports D1
> [ 0.633387] pci 0000:11:00.0: supports D2
> [ 0.633389] pci 0000:11:00.0: PME# supported from D1 D2 D3hot D3cold
> [ 0.633394] pci 0000:11:00.0: PME# disabled
> [ 0.633439] PCI: bridge 0000:00:06.0 io port: [a000, afff]
> [ 0.633442] PCI: bridge 0000:00:06.0 32bit mmio: [f8500000, f85fffff]
> [ 0.633484] PCI: 0000:17:00.0 reg 10 64bit mmio: [f8400000, f840ffff]
> [ 0.633574] PCI: bridge 0000:00:07.0 32bit mmio: [f8400000, f84fffff]
> [ 0.633627] PCI: 0000:1d:04.0 reg 10 32bit mmio: [f8604000, f8604fff]
> [ 0.633648] pci 0000:1d:04.0: supports D1
> [ 0.633649] pci 0000:1d:04.0: supports D2
> [ 0.633651] pci 0000:1d:04.0: PME# supported from D0 D1 D2 D3hot D3cold
> [ 0.633657] pci 0000:1d:04.0: PME# disabled
> [ 0.633697] PCI: 0000:1d:04.1 reg 10 32bit mmio: [f8606000, f86067ff]
> [ 0.633706] PCI: 0000:1d:04.1 reg 14 32bit mmio: [f8600000, f8603fff]
> [ 0.633760] pci 0000:1d:04.1: supports D1
> [ 0.633762] pci 0000:1d:04.1: supports D2
> [ 0.633764] pci 0000:1d:04.1: PME# supported from D0 D1 D2 D3hot
> [ 0.633770] pci 0000:1d:04.1: PME# disabled
> [ 0.633808] PCI: 0000:1d:04.2 reg 10 32bit mmio: [f8605000, f8605fff]
> [ 0.633867] pci 0000:1d:04.2: supports D1
> [ 0.633868] pci 0000:1d:04.2: supports D2
> [ 0.633870] pci 0000:1d:04.2: PME# supported from D0 D1 D2 D3hot
> [ 0.633876] pci 0000:1d:04.2: PME# disabled
> [ 0.633914] PCI: 0000:1d:04.3 reg 10 32bit mmio: [f8606800, f86068ff]
> [ 0.633973] pci 0000:1d:04.3: supports D1
> [ 0.633975] pci 0000:1d:04.3: supports D2
> [ 0.633977] pci 0000:1d:04.3: PME# supported from D0 D1 D2 D3hot
> [ 0.633982] pci 0000:1d:04.3: PME# disabled
> [ 0.634034] pci 0000:00:14.4: transparent bridge
> [ 0.634042] PCI: bridge 0000:00:14.4 32bit mmio: [f8600000, f86fffff]
> [ 0.634086] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [ 0.634395] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
> [ 0.634589] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
> [ 0.634651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB7_._PRT]
> [ 0.634651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BB5_._PRT]
> [ 0.634651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
> [ 0.634651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> [ 0.640273] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
> [ 0.640401] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
> [ 0.640592] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
> [ 0.640702] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
> [ 0.640702] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
> [ 0.640702] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
> [ 0.640702] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
> [ 0.640877] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
> [ 0.644178] Linux Plug and Play Support v0.97 (c) Adam Belay
> [ 0.644205] pnp: PnP ACPI init
> [ 0.644205] ACPI: bus type pnp registered
> [ 0.676262] pnp: PnP ACPI: found 11 devices
> [ 0.676265] ACPI: ACPI bus type pnp unregistered
> [ 0.680066] PCI: Using ACPI for IRQ routing
> [ 0.688042] NET: Registered protocol family 8
> [ 0.688045] NET: Registered protocol family 20
> [ 0.692041] NetLabel: Initializing
> [ 0.692041] NetLabel: domain hash size = 128
> [ 0.692041] NetLabel: protocols = UNLABELED CIPSOv4
> [ 0.692057] NetLabel: unlabeled traffic allowed by default
> [ 0.692200] PCI-DMA: Disabling AGP.
> [ 0.692353] PCI-DMA: aperture base @ 20000000 size 65536 KB
> [ 0.692353] PCI-DMA: using GART IOMMU.
> [ 0.692353] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> [ 0.692714] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [ 0.692722] hpet0: 4 32-bit timers, 14318180 Hz
> [ 0.695094] tracer: 1286 pages allocated for 65536 entries of 80 bytes
> [ 0.695096] actual entries 65586
> [ 0.695226] AppArmor: AppArmor Filesystem Enabled
> [ 0.695257] ACPI: RTC can wake from S4
> [ 0.696052] Switched to high resolution mode on CPU 0
> [ 0.696066] Switched to high resolution mode on CPU 1
> [ 0.705056] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
> [ 0.705059] system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
> [ 0.705071] system 00:08: ioport range 0x1080-0x1080 has been reserved
> [ 0.705075] system 00:08: ioport range 0x220-0x22f has been reserved
> [ 0.705078] system 00:08: ioport range 0x40b-0x40b has been reserved
> [ 0.705080] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [ 0.705083] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
> [ 0.705086] system 00:08: ioport range 0x530-0x537 has been reserved
> [ 0.705088] system 00:08: ioport range 0xc00-0xc01 has been reserved
> [ 0.705091] system 00:08: ioport range 0xc14-0xc14 has been reserved
> [ 0.705094] system 00:08: ioport range 0xc50-0xc52 has been reserved
> [ 0.705096] system 00:08: ioport range 0xc6c-0xc6c has been reserved
> [ 0.705099] system 00:08: ioport range 0xc6f-0xc6f has been reserved
> [ 0.705102] system 00:08: ioport range 0xcd0-0xcd1 has been reserved
> [ 0.705106] system 00:08: ioport range 0xcd2-0xcd3 has been reserved
> [ 0.705109] system 00:08: ioport range 0xcd4-0xcd5 has been reserved
> [ 0.705112] system 00:08: ioport range 0xcd6-0xcd7 has been reserved
> [ 0.705115] system 00:08: ioport range 0xcd8-0xcdf has been reserved
> [ 0.705118] system 00:08: ioport range 0x8000-0x805f has been reserved
> [ 0.705121] system 00:08: ioport range 0xf40-0xf47 has been reserved
> [ 0.705124] system 00:08: ioport range 0x87f-0x87f has been reserved
> [ 0.705127] system 00:08: ioport range 0xfd60-0xfddf has been reserved
> [ 0.705134] system 00:09: iomem range 0xe0000-0xfffff could not be reserved
> [ 0.705137] system 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
> [ 0.710566] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [ 0.710569] pci 0000:00:01.0: IO window: 0x9000-0x9fff
> [ 0.710573] pci 0000:00:01.0: MEM window: 0xf8200000-0xf83fffff
> [ 0.710576] pci 0000:00:01.0: PREFETCH window: 0x000000f0000000-0x000000f7ffffff
> [ 0.710581] pci 0000:00:05.0: PCI bridge, secondary bus 0000:0b
> [ 0.710583] pci 0000:00:05.0: IO window: disabled
> [ 0.710586] pci 0000:00:05.0: MEM window: 0xf8000000-0xf81fffff
> [ 0.710588] pci 0000:00:05.0: PREFETCH window: disabled
> [ 0.710593] pci 0000:00:06.0: PCI bridge, secondary bus 0000:11
> [ 0.710596] pci 0000:00:06.0: IO window: 0xa000-0xafff
> [ 0.710599] pci 0000:00:06.0: MEM window: 0xf8500000-0xf85fffff
> [ 0.710602] pci 0000:00:06.0: PREFETCH window: 0x000000f8700000-0x000000f87fffff
> [ 0.710606] pci 0000:00:07.0: PCI bridge, secondary bus 0000:17
> [ 0.710608] pci 0000:00:07.0: IO window: disabled
> [ 0.710611] pci 0000:00:07.0: MEM window: 0xf8400000-0xf84fffff
> [ 0.710614] pci 0000:00:07.0: PREFETCH window: disabled
> [ 0.710621] pci 0000:1d:04.0: CardBus bridge, secondary bus 0000:1e
> [ 0.710623] pci 0000:1d:04.0: IO window: 0x002000-0x0020ff
> [ 0.710632] pci 0000:1d:04.0: IO window: 0x002400-0x0024ff
> [ 0.710637] pci 0000:1d:04.0: PREFETCH window: 0x120000000-0x123ffffff
> [ 0.710642] pci 0000:1d:04.0: MEM window: 0x124000000-0x127ffffff
> [ 0.710648] pci 0000:00:14.4: PCI bridge, secondary bus 0000:1d
> [ 0.710651] pci 0000:00:14.4: IO window: 0x2000-0x2fff
> [ 0.710657] pci 0000:00:14.4: MEM window: 0xf8600000-0xf86fffff
> [ 0.710662] pci 0000:00:14.4: PREFETCH window: 0x00000120000000-0x00000123ffffff
> [ 0.710679] pci 0000:00:05.0: setting latency timer to 64
> [ 0.710684] pci 0000:00:06.0: setting latency timer to 64
> [ 0.710690] pci 0000:00:07.0: setting latency timer to 64
> [ 0.710711] pci 0000:1d:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [ 0.710717] bus: 00 index 0 io port: [0, ffff]
> [ 0.710719] bus: 00 index 1 mmio: [0, ffffffffffffffff]
> [ 0.710722] bus: 01 index 0 io port: [9000, 9fff]
> [ 0.710724] bus: 01 index 1 mmio: [f8200000, f83fffff]
> [ 0.710726] bus: 01 index 2 mmio: [f0000000, f7ffffff]
> [ 0.710728] bus: 01 index 3 mmio: [0, 0]
> [ 0.710729] bus: 0b index 0 mmio: [0, 0]
> [ 0.710731] bus: 0b index 1 mmio: [f8000000, f81fffff]
> [ 0.710733] bus: 0b index 2 mmio: [0, 0]
> [ 0.710735] bus: 0b index 3 mmio: [0, 0]
> [ 0.710737] bus: 11 index 0 io port: [a000, afff]
> [ 0.710739] bus: 11 index 1 mmio: [f8500000, f85fffff]
> [ 0.710741] bus: 11 index 2 mmio: [f8700000, f87fffff]
> [ 0.710742] bus: 11 index 3 mmio: [0, 0]
> [ 0.710744] bus: 17 index 0 mmio: [0, 0]
> [ 0.710746] bus: 17 index 1 mmio: [f8400000, f84fffff]
> [ 0.710748] bus: 17 index 2 mmio: [0, 0]
> [ 0.710750] bus: 17 index 3 mmio: [0, 0]
> [ 0.710752] bus: 1d index 0 io port: [2000, 2fff]
> [ 0.710754] bus: 1d index 1 mmio: [f8600000, f86fffff]
> [ 0.710756] bus: 1d index 2 mmio: [120000000, 123ffffff]
> [ 0.710758] bus: 1d index 3 io port: [0, ffff]
> [ 0.710759] bus: 1d index 4 mmio: [0, ffffffffffffffff]
> [ 0.710762] bus: 1e index 0 io port: [2000, 20ff]
> [ 0.710763] bus: 1e index 1 io port: [2400, 24ff]
> [ 0.710766] bus: 1e index 2 mmio: [120000000, 123ffffff]
> [ 0.710768] bus: 1e index 3 mmio: [124000000, 127ffffff]
> [ 0.710783] NET: Registered protocol family 2
> [ 0.749197] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [ 0.750802] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [ 0.755574] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [ 0.756194] TCP: Hash tables configured (established 524288 bind 65536)
> [ 0.756198] TCP reno registered
> [ 0.765128] NET: Registered protocol family 1
> [ 0.765264] checking if image is initramfs... it is
> [ 1.529642] Freeing initrd memory: 8480k freed
> [ 1.536373] audit: initializing netlink socket (disabled)
> [ 1.536388] type=2000 audit(1235809882.536:1): initialized
> [ 1.542764] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [ 1.546327] VFS: Disk quotas dquot_6.5.1
> [ 1.546453] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [ 1.546599] msgmni has been set to 7665
> [ 1.546766] io scheduler noop registered
> [ 1.546768] io scheduler anticipatory registered
> [ 1.546770] io scheduler deadline registered
> [ 1.546955] io scheduler cfq registered (default)
> [ 1.547065] pci 0000:01:05.0: Boot video device
> [ 1.547233] pcieport-driver 0000:00:05.0: setting latency timer to 64
> [ 1.547255] pcieport-driver 0000:00:05.0: found MSI capability
> [ 1.547280] pci_express 0000:00:05.0:pcie00: allocate port service
> [ 1.547356] pci_express 0000:00:05.0:pcie02: allocate port service
> [ 1.547424] pci_express 0000:00:05.0:pcie03: allocate port service
> [ 1.547525] pcieport-driver 0000:00:06.0: setting latency timer to 64
> [ 1.547545] pcieport-driver 0000:00:06.0: found MSI capability
> [ 1.547565] pci_express 0000:00:06.0:pcie00: allocate port service
> [ 1.547646] pci_express 0000:00:06.0:pcie03: allocate port service
> [ 1.547746] pcieport-driver 0000:00:07.0: setting latency timer to 64
> [ 1.547766] pcieport-driver 0000:00:07.0: found MSI capability
> [ 1.547787] pci_express 0000:00:07.0:pcie00: allocate port service
> [ 1.547858] pci_express 0000:00:07.0:pcie03: allocate port service
> [ 1.600838] hpet_resources: 0xfed00000 is busy
> [ 1.600925] Linux agpgart interface v0.103
> [ 1.600930] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> [ 1.604478] brd: module loaded
> [ 1.604586] input: Macintosh mouse button emulation as /devices/virtual/input/input0
> [ 1.604777] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
> [ 1.641664] serio: i8042 KBD port at 0x60,0x64 irq 1
> [ 1.641673] serio: i8042 AUX port at 0x60,0x64 irq 12
> [ 1.657189] mice: PS/2 mouse device common for all mice
> [ 1.657369] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> [ 1.657397] rtc0: alarms up to one month, hpet irqs
> [ 1.657460] cpuidle: using governor ladder
> [ 1.657462] cpuidle: using governor menu
> [ 1.657875] TCP cubic registered
> [ 1.658173] registered taskstats version 1
> [ 1.658351] Magic number: 13:403:524
> [ 1.658514] rtc_cmos 00:04: setting system clock to 2009-02-28 08:31:25 UTC (1235809885)
> [ 1.658517] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [ 1.658519] EDD information not available.
> [ 1.658578] Freeing unused kernel memory: 540k freed
> [ 1.658859] Write protecting the kernel read-only data: 4352k
> [ 1.682148] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [ 1.844227] fuse init (API version 7.9)
> [ 1.960304] ACPI: processor limited to max C-state 1
> [ 1.960425] processor ACPI0007:00: registered as cooling_device0
> [ 1.960431] ACPI: Processor [CPU0] (supports 8 throttling states)
> [ 1.960540] processor ACPI0007:01: registered as cooling_device1
> [ 2.277073] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [ 2.277100] r8169 0000:11:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [ 2.277121] r8169 0000:11:00.0: setting latency timer to 64
> [ 2.277470] eth0: RTL8101e at 0xffffc20000644000, 00:1e:ec:00:9e:6a, XID 34200000 IRQ 2300
> [ 2.317394] No dock devices found.
> [ 2.357129] usbcore: registered new interface driver usbfs
> [ 2.357160] usbcore: registered new interface driver hub
> [ 2.357231] usbcore: registered new device driver usb
> [ 2.359627] SCSI subsystem initialized
> [ 2.374576] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> [ 2.374622] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 2.374638] ohci_hcd 0000:00:13.0: OHCI Host Controller
> [ 2.374695] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
> [ 2.374741] ohci_hcd 0000:00:13.0: irq 16, io mem 0xf8904000
> [ 2.377241] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
> [ 2.408962] libata version 3.00 loaded.
> [ 2.429254] usb usb1: configuration #1 chosen from 1 choice
> [ 2.429287] hub 1-0:1.0: USB hub found
> [ 2.429303] hub 1-0:1.0: 2 ports detected
> [ 2.533332] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 2.533353] ohci_hcd 0000:00:13.1: OHCI Host Controller
> [ 2.533388] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
> [ 2.533423] ohci_hcd 0000:00:13.1: irq 17, io mem 0xf8905000
> [ 2.589240] usb usb2: configuration #1 chosen from 1 choice
> [ 2.589272] hub 2-0:1.0: USB hub found
> [ 2.589288] hub 2-0:1.0: 2 ports detected
> [ 2.693335] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [ 2.693356] ohci_hcd 0000:00:13.2: OHCI Host Controller
> [ 2.693388] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
> [ 2.693422] ohci_hcd 0000:00:13.2: irq 18, io mem 0xf8906000
> [ 2.749238] usb usb3: configuration #1 chosen from 1 choice
> [ 2.749269] hub 3-0:1.0: USB hub found
> [ 2.749286] hub 3-0:1.0: 2 ports detected
> [ 2.957311] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 2.957330] ohci_hcd 0000:00:13.3: OHCI Host Controller
> [ 2.957360] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
> [ 2.957383] ohci_hcd 0000:00:13.3: irq 17, io mem 0xf8907000
> [ 3.013236] usb usb4: configuration #1 chosen from 1 choice
> [ 3.013268] hub 4-0:1.0: USB hub found
> [ 3.013285] hub 4-0:1.0: 2 ports detected
> [ 3.092041] usb 3-1: new low speed USB device using ohci_hcd and address 2
> [ 3.118310] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [ 3.118328] ohci_hcd 0000:00:13.4: OHCI Host Controller
> [ 3.118359] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 5
> [ 3.118380] ohci_hcd 0000:00:13.4: irq 18, io mem 0xf8908000
> [ 3.172178] usb usb5: configuration #1 chosen from 1 choice
> [ 3.172210] hub 5-0:1.0: USB hub found
> [ 3.172225] hub 5-0:1.0: 2 ports detected
> [ 3.259839] usb 3-1: configuration #1 chosen from 1 choice
> [ 3.277250] ahci 0000:00:12.0: version 3.0
> [ 3.277274] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [ 3.277303] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
> [ 3.277391] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> [ 3.277394] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pmp pio slum part
> [ 3.277776] scsi0 : ahci
> [ 3.277922] scsi1 : ahci
> [ 3.278019] scsi2 : ahci
> [ 3.278105] scsi3 : ahci
> [ 3.278235] ata1: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909100 irq 22
> [ 3.278240] ata2: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909180 irq 22
> [ 3.278243] ata3: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909200 irq 22
> [ 3.278247] ata4: SATA max UDMA/133 abar m1024@0xf8909000 port 0xf8909280 irq 22
> [ 3.984040] ata1: softreset failed (device not ready)
> [ 3.984046] ata1: failed due to HW bug, retry pmp=0
> [ 4.148049] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 4.542078] ata1.00: ATA-8: TOSHIBA MK1646GSX, LB113M, max UDMA/100
> [ 4.542082] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [ 4.542094] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> [ 4.542933] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> [ 4.542937] ata1.00: configured for UDMA/100
> [ 4.876047] ata2: SATA link down (SStatus 0 SControl 300)
> [ 5.216052] ata3: SATA link down (SStatus 0 SControl 300)
> [ 5.552054] ata4: SATA link down (SStatus 0 SControl 300)
> [ 5.568160] scsi 0:0:0:0: Direct-Access ATA TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5
> [ 5.568380] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [ 5.568397] ehci_hcd 0000:00:13.5: EHCI Host Controller
> [ 5.568440] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 6
> [ 5.568478] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
> [ 5.568497] ehci_hcd 0000:00:13.5: debug port 1
> [ 5.568523] ehci_hcd 0000:00:13.5: irq 19, io mem 0xf8909400
> [ 5.571216] usb 3-1: USB disconnect, address 2
> [ 5.581032] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [ 5.581165] usb usb6: configuration #1 chosen from 1 choice
> [ 5.581199] hub 6-0:1.0: USB hub found
> [ 5.581211] hub 6-0:1.0: 10 ports detected
> [ 5.789882] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 5.789918] pata_atiixp 0000:00:14.1: setting latency timer to 64
> [ 5.790028] scsi4 : pata_atiixp
> [ 5.791572] scsi5 : pata_atiixp
> [ 5.792722] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x8420 irq 14
> [ 5.792725] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x8428 irq 15
> [ 5.952515] ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WT03, max UDMA/33
> [ 5.968455] ata5.00: configured for UDMA/33
> [ 6.108033] usb 3-1: new low speed USB device using ohci_hcd and address 3
> [ 6.137569] scsi 4:0:0:0: CD-ROM HL-DT-ST DVDRAM GSA-T20N WT03 PQ: 0 ANSI: 5
> [ 6.141158] ohci1394 0000:1d:04.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [ 6.190972] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21] MMIO=[f8606000-f86067ff] Max Packet=[2048] IR/IT contexts=[4/8]
> [ 6.220986] scsi 0:0:0:0: Attached scsi generic sg0 type 0
> [ 6.221038] scsi 4:0:0:0: Attached scsi generic sg1 type 5
> [ 6.268979] Driver 'sd' needs updating - please use bus_type methods
> [ 6.269126] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> [ 6.269145] sd 0:0:0:0: [sda] Write Protect is off
> [ 6.269148] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 6.269176] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [ 6.269259] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> [ 6.269275] sd 0:0:0:0: [sda] Write Protect is off
> [ 6.269277] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 6.269304] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [ 6.269308] sda:usb 3-1: configuration #1 chosen from 1 choice
> [ 6.279979] usbcore: registered new interface driver hiddev
> [ 6.280833] Driver 'sr' needs updating - please use bus_type methods
> [ 6.284432] input: Logitech Optical USB Mouse as /devices/pci0000:00/0000:00:13.2/usb3/3-1/3-1:1.0/input/input2
> [ 6.308216] input,hidraw0: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:13.2-1
> [ 6.308241] usbcore: registered new interface driver usbhid
> [ 6.308244] usbhid: v2.6:USB HID core driver
> [ 6.380907] sda1 sda2 sda3 < sda5 sda6>
> [ 6.416009] sd 0:0:0:0: [sda] Attached SCSI disk
> [ 6.435347] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [ 6.435355] Uniform CD-ROM driver Revision: 3.20
> [ 6.435486] sr 4:0:0:0: Attached scsi CD-ROM sr0
> [ 6.896145] PM: Starting manual resume from disk
> [ 6.896149] PM: Resume from partition 8:6
> [ 6.896151] PM: Checking hibernation image.
> [ 6.896377] PM: Resume from disk failed.
> [ 6.963371] kjournald starting. Commit interval 5 seconds
> [ 6.963386] EXT3-fs: mounted filesystem with ordered data mode.
> [ 7.465167] ieee1394: Host added: ID:BUS[0-00:1023] GUID[00023f81c2404ccc]
> [ 12.872155] udevd version 124 started
> [ 13.204203] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [ 13.256294] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [ 13.282596] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> [ 13.309058] ACPI: Power Button (FF) [PWRF]
> [ 13.309206] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
> [ 13.309315] ACPI: Lid Switch [LID]
> [ 13.309401] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
> [ 13.341049] ACPI: Power Button (CM) [PWRB]
> [ 13.443522] ACPI: AC Adapter [ACAD] (on-line)
> [ 13.463238] acpi device:29: registered as cooling_device2
> [ 13.463525] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:26/device:27/input/input6
> [ 13.480054] ACPI: Video Device [VGA] (multi-head: yes rom: no post: no)
> [ 13.731625] ath_hal: module license 'Proprietary' taints kernel.
> [ 13.765240] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
> [ 13.806821] ACPI: Battery Slot [BAT1] (battery present)
> [ 13.833202] wlan: 0.9.4
> [ 13.869278] ath_pci: 0.9.4
> [ 13.869335] ath_pci 0000:17:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [ 13.869345] ath_pci 0000:17:00.0: setting latency timer to 64
> [ 13.893749] wifi%d: unable to attach hardware: 'Hardware revision not supported' (HAL status 13)
> [ 13.893765] ath_pci 0000:17:00.0: PCI INT A disabled
> [ 14.078833] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8410, revision 0
> [ 14.089882] Linux video capture interface: v2.00
> [ 14.401241] cx23885 driver version 0.0.1 loaded
> [ 14.401304] cx23885 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 14.401443] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge WinTV-HVR1500 [card=6,autodetected]
> [ 14.631477] tveeprom 1-0050: Hauppauge model 77001, rev D4C0, serial# 2396878
> [ 14.631482] tveeprom 1-0050: MAC address is 00-0D-FE-24-92-CE
> [ 14.631485] tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
> [ 14.631488] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
> [ 14.631491] tveeprom 1-0050: audio processor is CX23885 (idx 39)
> [ 14.631493] tveeprom 1-0050: decoder processor is CX23885 (idx 33)
> [ 14.631495] tveeprom 1-0050: has no radio
> [ 14.631497] cx23885[0]: hauppauge eeprom: model=77001
> [ 14.631501] cx23885_dvb_register() allocating 1 frontend(s)
> [ 14.652404] cx23885[0]: cx23885 based dvb card
> [ 14.728356] input: PC Speaker as /devices/platform/pcspkr/input/input7
> [ 14.866740] sdhci: Secure Digital Host Controller Interface driver
> [ 14.866744] sdhci: Copyright(c) Pierre Ossman
> [ 15.004955] xc2028 2-0061: creating new instance
> [ 15.004960] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [ 15.004968] DVB: registering new adapter (cx23885[0])
> [ 15.004972] DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
> [ 15.005445] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [ 15.005454] cx23885[0]/0: found at 0000:0b:00.0, rev: 2, irq: 17, latency: 0, mmio: 0xf8000000
> [ 15.005462] cx23885 0000:0b:00.0: setting latency timer to 64
> [ 15.009027] tifm_7xx1 0000:1d:04.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [ 15.009519] sdhci-pci 0000:1d:04.3: SDHCI controller found [104c:803c] (rev 0)
> [ 15.009532] sdhci-pci 0000:1d:04.3: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [ 15.009605] mmc0: SDHCI controller on PCI [0000:1d:04.3] using DMA
> [ 15.012650] Yenta: CardBus bridge found at 0000:1d:04.0 [1179:ff00]
> [ 15.012672] Yenta: Enabling burst memory read transactions
> [ 15.012677] Yenta: Using CSCINT to route CSC interrupts to PCI
> [ 15.012679] Yenta: Routing CardBus interrupts to PCI
> [ 15.012685] Yenta TI: socket 0000:1d:04.0, mfunc 0x10a01b22, devctl 0x64
> [ 15.249217] Yenta: ISA IRQ mask 0x0cf8, PCI irq 20
> [ 15.249222] Socket status: 30000006
> [ 15.249225] Yenta: Raising subordinate bus# of parent bus (#1d) from #1e to #21
> [ 15.249231] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
> [ 15.249283] pcmcia: parent PCI bridge Memory window: 0xf8600000 - 0xf86fffff
> [ 15.249286] pcmcia: parent PCI bridge Memory window: 0x120000000 - 0x123ffffff
> [ 15.488961] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 15.531684] hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...
> [ 15.903817] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x9280b1, caps: 0xa04713/0x204000
> [ 15.997172] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
> [ 16.887313] lp: driver loaded but no devices found
> [ 17.127481] Adding 2072344k swap on /dev/sda6. Priority:-1 extents:1 across:2072344k
> [ 17.691536] EXT3 FS on sda5, internal journal
> [ 18.970850] type=1505 audit(1235831502.319:2): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=4309
> [ 18.971092] type=1505 audit(1235831502.319:3): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4309
> [ 19.079119] type=1505 audit(1235831502.427:4): operation="profile_load" name="/usr/sbin/mysqld" name2="default" pid=4313
> [ 19.253732] ip_tables: (C) 2000-2006 Netfilter Core Team
> [ 19.944597] ACPI: WMI: Mapper loaded
> [ 20.364382] powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-58 processors (2 cpu cores) (version 2.20.00)
> [ 20.364447] powernow-k8: 0 : fid 0xb (1900 MHz), vid 0x12
> [ 20.364451] powernow-k8: 1 : fid 0xa (1800 MHz), vid 0x13
> [ 20.364453] powernow-k8: 2 : fid 0x8 (1600 MHz), vid 0x14
> [ 20.364455] powernow-k8: 3 : fid 0x0 (800 MHz), vid 0x1e
> [ 21.273379] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
> [ 24.126362] ppdev: user-space parallel port driver
> [ 25.072852] NET: Registered protocol family 10
> [ 25.073370] lo: Disabled Privacy Extensions
> [ 26.501050] Clocksource tsc unstable (delta = -146065408 ns)
> [ 29.764250] Bluetooth: Core ver 2.13
> [ 29.767489] NET: Registered protocol family 31
> [ 29.767503] Bluetooth: HCI device and connection manager initialized
> [ 29.767512] Bluetooth: HCI socket layer initialized
> [ 29.825428] Bluetooth: L2CAP ver 2.11
> [ 29.825445] Bluetooth: L2CAP socket layer initialized
> [ 29.909958] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [ 29.909983] Bluetooth: BNEP filters: protocol multicast
> [ 29.992551] Bridge firewalling registered
> [ 30.029192] Bluetooth: SCO (Voice Link) ver 0.6
> [ 30.029208] Bluetooth: SCO socket layer initialized
> [ 30.102480] Bluetooth: RFCOMM socket layer initialized
> [ 30.102736] Bluetooth: RFCOMM TTY layer initialized
> [ 30.102742] Bluetooth: RFCOMM ver 1.10
> [ 31.783725] pci 0000:01:05.0: power state changed by ACPI to D0
> [ 31.783761] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [ 32.157643] [drm] Initialized drm 1.1.0 20060810
> [ 32.176763] [drm] Initialized radeon 1.29.0 20080528 on minor 0
> [ 32.832715] [drm] Setting GART location based on new memory map
> [ 32.833786] [drm] Loading RS690 Microcode
> [ 32.833818] [drm] Num pipes: 1
> [ 32.833829] [drm] writeback test succeeded in 1 usecs
> [ 34.365896] r8169: eth0: link up
> [ 34.365923] r8169: eth0: link up
> [ 34.547487] NET: Registered protocol family 17
> [ 44.620161] eth0: no IPv6 routers present
> [ 90.086383] hda-intel: Invalid position buffer, using LPIB read method instead.
> thomas@toshiba:~$ dmesg | grep error
> thomas@toshiba:~$ dmesg | grep warning
> [ 21.273379] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
> thomas@toshiba:~$ dmesg | grep Warning
> [ 2.377241] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
>
>
> Here is what /etc/modules looks like, the only lines I added are the tuner and cx23885 lines:
>
> # /etc/modules: kernel modules to load at boot time.
> #
> # This file contains the names of kernel modules that should be loaded
> # at boot time, one per line. Lines beginning with "#" are ignored.
>
> fuse
> lp
> rtc
> sbp2
> tuner_xc2028 no_poweroff=1 debug=1
> cx23885 i2c_scan=1
>
>
> Thanks for any help,
>
> Tom
>
>
>> Date: Tue, 17 Feb 2009 15:56:00 -0500
>> Subject: Re: HVR-1500 tuner seems to be recognized, but wont turn on.þ
>> From: devin.heitmueller@gmail.com
>> To: nickotym@hotmail.com
>> CC: linux-media@vger.kernel.org
>>
>> 2009/2/17 Thomas Nicolai :
>>>
>>> I will try those suggestions this evening. did he feel this should be done in addition to the modprobe tunerxc-2028 no_poweroff=1 debug=1 ?
>>
>> Please do both commands. That way we will get both sets of debugging
>> messages and you only have to do the capture once.
>>
>> Regards,
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>
> _________________________________________________________________
> Windows Live™: Life without walls.
> http://windowslive.com/explore?ocid=TXT_TAGLM_WL_allup_1a_explore_032009
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Windows Live™ Contacts: Organize your contact list. 
http://windowslive.com/connect/post/marcusatmicrosoft.spaces.live.com-Blog-cns!503D1D86EBB2B53C!2285.entry?ocid=TXT_TAGLM_WL_UGC_Contacts_032009
