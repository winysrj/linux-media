Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc2-s10.col0.hotmail.com ([65.55.34.84]:22119 "EHLO
	col0-omc2-s10.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZKPIoR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 03:44:17 -0500
Message-ID: <COL124-W64E6CB59ACEFAC6DDE8018B2A50@phx.gbl>
From: Marco Berizzi <pupilla@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: hauppauge hvr 2200: lost FE_HAS_LOCK
Date: Mon, 16 Nov 2009 09:43:49 +0100
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Folks,

I have found a problem with the hauppauge wintv hvr 2200
on linux 2.6.32-rc7 x86-64.
When I initialize the second tuner with tzap the first
lose the FE_HAS_LOCK, and viceversa. Here is an example:

tzap -a 1 "LA7(MBone)"                                     
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'            
reading channels from file '/root/.tzap/channels.conf'                        
tuning to 826000000 Hz                                                        
video pid 0x0101, audio pid 0x0102                                            
status 00 | signal d5d5 | snr 0044 | ber 0000ffff | unc 00000000 |            
status 1f | signal fdfd | snr 00d7 | ber 00000617 | unc 00000045 | FE_HAS_LOCK
status 1f | signal fcfc | snr 00c6 | ber 0000094e | unc 00000000 | FE_HAS_LOCK
status 1f | signal fafa | snr 00a8 | ber 000009db | unc 00000046 | FE_HAS_LOCK
status 01 | signal 0000 | snr 0005 | ber 0000ffff | unc 00000000 |            
status 1f | signal fdfd | snr 00c6 | ber 000007d8 | unc 00000000 | FE_HAS_LOCK
status 1f | signal fcfc | snr 00c6 | ber 00000750 | unc 00000000 | FE_HAS_LOCK
status 1f | signal fcfc | snr 00d7 | ber 0000082c | unc 00000000 | FE_HAS_LOCK
status 1f | signal fcfc | snr 00b9 | ber 00000898 | unc 00000000 | FE_HAS_LOCK

'status 01' happened when running 'tzap MTV'.
I have discovered this behaviour while watching tv with
both vlc and kaffeine: when one of the two application are
opened or closed, the image is garbled for about 1 seconds.
Any feedback are welcome.

TIA

This is my full dmesg:

Linux version 2.6.32-rc7 (root@Challenger) (gcc version 4.3.3 (GCC) ) #1 SMP Sat Nov 14 17:48:19 CET 2009                                                             
Command line: BOOT_IMAGE=Linux ro root=802 vt.default_utf8=0                       
KERNEL supported cpus:                                                             
  Intel GenuineIntel                                                               
  AMD AuthenticAMD                                                                 
  Centaur CentaurHauls                                                             
BIOS-provided physical RAM map:                                                    
 BIOS-e820: 0000000000000000 - 000000000009e400 (usable)                           
 BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)                         
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)                         
 BIOS-e820: 0000000000100000 - 00000000bfe90000 (usable)                           
 BIOS-e820: 00000000bfe90000 - 00000000bfee3000 (ACPI NVS)                         
 BIOS-e820: 00000000bfee3000 - 00000000bfef0000 (ACPI data)                        
 BIOS-e820: 00000000bfef0000 - 00000000bff00000 (reserved)                         
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)                         
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)                         
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)                           
DMI 2.5 present.                                                                   
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.                
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)     
last_pfn = 0x140000 max_arch_pfn = 0x400000000                                     
last_pfn = 0xbfe90 max_arch_pfn = 0x400000000                                      
initial memory mapped : 0 - 20000000                                               
init_memory_mapping: 0000000000000000-00000000bfe90000                             
 0000000000 - 00bfe00000 page 2M                                                   
 00bfe00000 - 00bfe90000 page 4k                                                   
kernel direct mapping tables up to bfe90000 @ 10000-15000                          
init_memory_mapping: 0000000100000000-0000000140000000                             
 0100000000 - 0140000000 page 2M                                                   
kernel direct mapping tables up to 140000000 @ 13000-19000                         
ACPI: RSDP 00000000000f8b10 00014 (v00 IntelR)                                     
ACPI: RSDT 00000000bfee3000 00038 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)     
ACPI: FACP 00000000bfee3080 00084 (v02 IntelR AWRDACPI 42302E31 AWRD 00000000)     
ACPI: DSDT 00000000bfee3140 041F1 (v01 INTELR AWRDACPI 00001000 MSFT 03000000)     
ACPI: FACS 00000000bfe90000 00040                                                  
ACPI: HPET 00000000bfee7400 00038 (v01 IntelR AWRDACPI 42302E31 AWRD 00000098)     
ACPI: MCFG 00000000bfee7440 0003C (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)     
ACPI: APIC 00000000bfee7340 00084 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)     
ACPI: SSDT 00000000bfee7ae0 00590 (v01  PmRef    CpuPm 00003000 INTL 20050309)     
ACPI: Local APIC address 0xfee00000                                                
(7 early reservations) ==> bootmem [0000000000 - 0140000000]                       
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]      
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]      
  #2 [0001000000 - 00013a6498]    TEXT DATA BSS ==> [0001000000 - 00013a6498]      
  #3 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 - 0000100000]      
  #4 [00013a7000 - 00013a7110]              BRK ==> [00013a7000 - 00013a7110]      
  #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]      
  #6 [0000013000 - 0000014000]          PGTABLE ==> [0000013000 - 0000014000]      
Zone PFN ranges:                                                                   
  DMA      0x00000010 -> 0x00001000                                                
  DMA32    0x00001000 -> 0x00100000                                                
  Normal   0x00100000 -> 0x00140000                                                
Movable zone start PFN for each node                                               
early_node_map[3] active PFN ranges                                                
    0: 0x00000010 -> 0x0000009e                                                    
    0: 0x00000100 -> 0x000bfe90                                                    
    0: 0x00100000 -> 0x00140000                                                    
On node 0 totalpages: 1048094                                                      
  DMA zone: 56 pages used for memmap                                               
  DMA zone: 105 pages reserved                                                     
  DMA zone: 3821 pages, LIFO batch:0                                               
  DMA32 zone: 14280 pages used for memmap                                          
  DMA32 zone: 767688 pages, LIFO batch:31                                          
  Normal zone: 3584 pages used for memmap                                          
  Normal zone: 258560 pages, LIFO batch:31                                         
ACPI: PM-Timer IO Port: 0x408                                                      
ACPI: Local APIC address 0xfee00000                                                
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)                                 
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)                                 
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)                                
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)                                
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])                                
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])                                
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])                                
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])                                
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])                            
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23                     
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                           
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)                        
ACPI: IRQ0 used by override.                                                       
ACPI: IRQ2 used by override.                                                       
ACPI: IRQ9 used by override.                                                       
Using ACPI (MADT) for SMP configuration information                                
ACPI: HPET id: 0x8086a201 base: 0xfed00000                                         
4 Processors exceeds NR_CPUS limit of 2                                            
SMP: Allowing 2 CPUs, 0 hotplug CPUs                                               
nr_irqs_gsi: 24                                                                    
Allocating PCI resources starting at bff00000 (gap: bff00000:20100000)             
NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1                             
PERCPU: Embedded 25 pages/cpu @ffff880028200000 s70488 r8192 d23720 u1048576       
pcpu-alloc: s70488 r8192 d23720 u1048576 alloc=1*2097152                           
pcpu-alloc: [0] 0 1                                                                
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030069       
Kernel command line: BOOT_IMAGE=Linux ro root=802 vt.default_utf8=0                
PID hash table entries: 4096 (order: 3, 32768 bytes)                               
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)                 
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)                   
Initializing CPU#0                                                                 
xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240                              
Checking aperture...                                                               
No AGP bridge found                                                                
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)                          
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000           
software IO TLB at phys 0x20000000 - 0x24000000                                    
Memory: 4057888k/5242880k available (2083k kernel code, 1050504k absent, 133588k reserved, 895k data, 340k init)                                                      
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1            
Hierarchical RCU implementation.                                                   
NR_IRQS:320                                                                        
Console: colour VGA+ 80x25                                                         
console [tty0] enabled                                                             
hpet clockevent registered                                                         
HPET: 4 timers in total, 0 timers will be used for per-cpu timer                   
Fast TSC calibration using PIT                                                     
Detected 3327.688 MHz processor.                                                   
Calibrating delay loop (skipped), value calculated using timer frequency.. 6655.37 BogoMIPS (lpj=3327688)                                                             
Mount-cache hash table entries: 256                                                
CPU: L1 I cache: 32K, L1 D cache: 32K                                              
CPU: L2 cache: 6144K                                                               
CPU: Physical Processor ID: 0                                                      
CPU: Processor Core ID: 0                                                          
using mwait in idle threads.                                                       
Freeing SMP alternatives: 19k freed                                                
ACPI: Core revision 20090903                                                       
Setting APIC routing to flat                                                       
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                               
CPU0: Intel(R) Core(TM)2 Duo CPU     E8600  @ 3.33GHz stepping 0a                  
Booting processor 1 APIC 0x1 ip 0x6000                                             
Initializing CPU#1                                                                 
Calibrating delay using timer specific routine.. 6655.39 BogoMIPS (lpj=3327697)    
CPU: L1 I cache: 32K, L1 D cache: 32K                                              
CPU: L2 cache: 6144K                                                               
CPU: Physical Processor ID: 0                                                      
CPU: Processor Core ID: 1                                                          
CPU1: Intel(R) Core(TM)2 Duo CPU     E8600  @ 3.33GHz stepping 0a                  
checking TSC synchronization [CPU#0 -> CPU#1]: passed.                             
Brought up 2 CPUs                                                                  
Total of 2 processors activated (13310.77 BogoMIPS).                               
NET: Registered protocol family 16                                                 
ACPI: bus type pci registered                                                      
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255                   
PCI: MCFG area at e0000000 reserved in E820                                        
PCI: Using MMCONFIG at e0000000 - efffffff                                         
PCI: Using configuration type 1 for base access                                    
bio: create slab <bio-0> at 0                                                      
ACPI: EC: Look up EC in DSDT                                                       
ACPI: Interpreter enabled                                                          
ACPI: (supports S0 S5)                                                             
ACPI: Using IOAPIC for interrupt routing                                           
ACPI: PCI Root Bridge [PCI0] (0000:00)                                             
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold                              
pci 0000:00:01.0: PME# disabled                                                    
pci 0000:00:1a.0: reg 20 io port: [0xff00-0xff1f]                                  
pci 0000:00:1a.1: reg 20 io port: [0xfe00-0xfe1f]                                  
pci 0000:00:1a.2: reg 20 io port: [0xfd00-0xfd1f]                                  
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfdfff000-0xfdfff3ff]                       
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold                              
pci 0000:00:1a.7: PME# disabled                                                    
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfdff4000-0xfdff7fff]                       
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold                              
pci 0000:00:1b.0: PME# disabled                                                    
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold                              
pci 0000:00:1c.0: PME# disabled                                                    
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold                              
pci 0000:00:1c.2: PME# disabled                                                    
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold                              
pci 0000:00:1c.4: PME# disabled                                                    
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold                              
pci 0000:00:1c.5: PME# disabled                                                    
pci 0000:00:1d.0: reg 20 io port: [0xfc00-0xfc1f]                                  
pci 0000:00:1d.1: reg 20 io port: [0xfb00-0xfb1f]                                  
pci 0000:00:1d.2: reg 20 io port: [0xfa00-0xfa1f]                                  
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfdffe000-0xfdffe3ff]                       
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold                              
pci 0000:00:1d.7: PME# disabled                                                    
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO            
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO                     
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 003f)             
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0100 (mask 003f)             
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 000f)             
pci 0000:00:1f.2: reg 10 io port: [0xf900-0xf907]                                  
pci 0000:00:1f.2: reg 14 io port: [0xf800-0xf803]                                  
pci 0000:00:1f.2: reg 18 io port: [0xf700-0xf707]                                  
pci 0000:00:1f.2: reg 1c io port: [0xf600-0xf603]                                  
pci 0000:00:1f.2: reg 20 io port: [0xf500-0xf51f]                                  
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfdffd000-0xfdffd7ff]                       
pci 0000:00:1f.2: PME# supported from D3hot                                        
pci 0000:00:1f.2: PME# disabled                                                    
pci 0000:00:1f.3: reg 10 64bit mmio: [0xfdffc000-0xfdffc0ff]                       
pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]                                    
pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]                       
pci 0000:01:00.0: reg 14 64bit mmio pref: [0xd0000000-0xdfffffff]                  
pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]                       
pci 0000:01:00.0: reg 24 io port: [0xbf00-0xbf7f]                                  
pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x07ffff]                      
pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]                                  
pci 0000:00:01.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]                       
pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]                  
pci 0000:00:1c.0: bridge io port: [0xa000-0xafff]                                  
pci 0000:00:1c.0: bridge 32bit mmio: [0xfdb00000-0xfdbfffff]                       
pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfd800000-0xfd8fffff]                  
pci 0000:03:00.0: reg 10 64bit mmio: [0xfd000000-0xfd3fffff]                       
pci 0000:03:00.0: reg 18 64bit mmio: [0xfcc00000-0xfcffffff]                       
pci 0000:03:00.0: supports D1 D2                                                   
pci 0000:03:00.0: PME# supported from D0 D1 D2                                     
pci 0000:03:00.0: PME# disabled                                                    
pci 0000:00:1c.2: bridge io port: [0x9000-0x9fff]                                  
pci 0000:00:1c.2: bridge 32bit mmio: [0xfcc00000-0xfd3fffff]                       
pci 0000:00:1c.2: bridge 64bit mmio pref: [0xfd700000-0xfd7fffff]                  
pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]                                  
pci 0000:00:1c.4: bridge 32bit mmio: [0xfd600000-0xfd6fffff]                       
pci 0000:00:1c.4: bridge 64bit mmio pref: [0xfde00000-0xfdefffff]                  
pci 0000:05:00.0: reg 10 io port: [0xce00-0xceff]                                  
pci 0000:05:00.0: reg 18 64bit mmio: [0xfddff000-0xfddfffff]                       
pci 0000:05:00.0: reg 20 64bit mmio pref: [0xfdcf0000-0xfdcfffff]                  
pci 0000:05:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]                      
pci 0000:05:00.0: supports D1 D2                                                   
pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold                        
pci 0000:05:00.0: PME# disabled                                                    
pci 0000:00:1c.5: bridge io port: [0xc000-0xcfff]                                  
pci 0000:00:1c.5: bridge 32bit mmio: [0xfdd00000-0xfddfffff]                       
pci 0000:00:1c.5: bridge 64bit mmio pref: [0xfdc00000-0xfdcfffff]                  
pci 0000:00:1e.0: transparent bridge                                               
pci 0000:00:1e.0: bridge io port: [0x8000-0x8fff]                                  
pci 0000:00:1e.0: bridge 32bit mmio: [0xfda00000-0xfdafffff]                       
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xfd900000-0xfd9fffff]                  
pci_bus 0000:00: on NUMA node 0                                                    
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]                           
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]                           
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]                           
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]                           
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]                           
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)                   
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12 14 15)                   
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12 14 15)                   
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)                   
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.      
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 7 9 10 11 12 14 15)                   
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 *9 10 11 12 14 15)                   
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 *10 11 12 14 15)                   
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none       
vgaarb: loaded                                                                     
SCSI subsystem initialized                                                         
libata version 3.00 loaded.                                                        
PCI: Using ACPI for IRQ routing                                                    
Switching to clocksource tsc                                                       
pnp: PnP ACPI init                                                                 
ACPI: bus type pnp registered                                                      
pnp: PnP ACPI: found 15 devices                                                    
ACPI: ACPI bus type pnp unregistered                                               
system 00:01: ioport range 0x4d0-0x4d1 has been reserved                           
system 00:01: ioport range 0x800-0x87f has been reserved                           
system 00:01: ioport range 0x290-0x297 has been reserved                           
system 00:01: ioport range 0x880-0x88f has been reserved                           
system 00:0b: ioport range 0x400-0x4bf could not be reserved                       
system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved                  
system 00:0e: iomem range 0xf0000-0xfffff could not be reserved                    
system 00:0e: iomem range 0xbff00000-0xbfffffff could not be reserved              
system 00:0e: iomem range 0xfed00000-0xfed000ff has been reserved                  
system 00:0e: iomem range 0xbfe90000-0xbfefffff could not be reserved              
system 00:0e: iomem range 0x0-0x9ffff could not be reserved                        
system 00:0e: iomem range 0x100000-0xbfe8ffff could not be reserved                
system 00:0e: iomem range 0xfec00000-0xfec00fff could not be reserved              
system 00:0e: iomem range 0xfed13000-0xfed1ffff has been reserved                  
system 00:0e: iomem range 0xfed20000-0xfed9ffff has been reserved                  
system 00:0e: iomem range 0xfee00000-0xfee00fff has been reserved                  
system 00:0e: iomem range 0xffb00000-0xffb7ffff has been reserved                  
system 00:0e: iomem range 0xfff00000-0xffffffff has been reserved                  
system 00:0e: iomem range 0xe0000-0xeffff has been reserved                        
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01                                
pci 0000:00:01.0:   IO window: 0xb000-0xbfff                                       
pci 0000:00:01.0:   MEM window: 0xf8000000-0xfbffffff                              
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff             
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02                                
pci 0000:00:1c.0:   IO window: 0xa000-0xafff                                       
pci 0000:00:1c.0:   MEM window: 0xfdb00000-0xfdbfffff                              
pci 0000:00:1c.0:   PREFETCH window: 0x000000fd800000-0x000000fd8fffff             
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03                                
pci 0000:00:1c.2:   IO window: 0x9000-0x9fff                                       
pci 0000:00:1c.2:   MEM window: 0xfcc00000-0xfd3fffff                              
pci 0000:00:1c.2:   PREFETCH window: 0x000000fd700000-0x000000fd7fffff             
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04                                
pci 0000:00:1c.4:   IO window: 0xd000-0xdfff                                       
pci 0000:00:1c.4:   MEM window: 0xfd600000-0xfd6fffff                              
pci 0000:00:1c.4:   PREFETCH window: 0x000000fde00000-0x000000fdefffff             
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:05                                
pci 0000:00:1c.5:   IO window: 0xc000-0xcfff                                       
pci 0000:00:1c.5:   MEM window: 0xfdd00000-0xfddfffff                              
pci 0000:00:1c.5:   PREFETCH window: 0x000000fdc00000-0x000000fdcfffff             
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06                                
pci 0000:00:1e.0:   IO window: 0x8000-0x8fff                                       
pci 0000:00:1e.0:   MEM window: 0xfda00000-0xfdafffff                              
pci 0000:00:1e.0:   PREFETCH window: 0x000000fd900000-0x000000fd9fffff             
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                       
pci 0000:00:01.0: setting latency timer to 64                                      
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                       
pci 0000:00:1c.0: setting latency timer to 64                                      
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18                       
pci 0000:00:1c.2: setting latency timer to 64                                      
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16                       
pci 0000:00:1c.4: setting latency timer to 64                                      
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17                       
pci 0000:00:1c.5: setting latency timer to 64                                      
pci 0000:00:1e.0: setting latency timer to 64                                      
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                     
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                     
pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]                                   
pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]                           
pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]                       
pci_bus 0000:02: resource 0 io:  [0xa000-0xafff]                                   
pci_bus 0000:02: resource 1 mem: [0xfdb00000-0xfdbfffff]                           
pci_bus 0000:02: resource 2 pref mem [0xfd800000-0xfd8fffff]                       
pci_bus 0000:03: resource 0 io:  [0x9000-0x9fff]                                   
pci_bus 0000:03: resource 1 mem: [0xfcc00000-0xfd3fffff]                           
pci_bus 0000:03: resource 2 pref mem [0xfd700000-0xfd7fffff]                       
pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]                                   
pci_bus 0000:04: resource 1 mem: [0xfd600000-0xfd6fffff]                           
pci_bus 0000:04: resource 2 pref mem [0xfde00000-0xfdefffff]                       
pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]                                   
pci_bus 0000:05: resource 1 mem: [0xfdd00000-0xfddfffff]                           
pci_bus 0000:05: resource 2 pref mem [0xfdc00000-0xfdcfffff]                       
pci_bus 0000:06: resource 0 io:  [0x8000-0x8fff]                                   
pci_bus 0000:06: resource 1 mem: [0xfda00000-0xfdafffff]                           
pci_bus 0000:06: resource 2 pref mem [0xfd900000-0xfd9fffff]                       
pci_bus 0000:06: resource 3 io:  [0x00-0xffff]                                     
pci_bus 0000:06: resource 4 mem: [0x000000-0xffffffffffffffff]                     
NET: Registered protocol family 2                                                  
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)                
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)              
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)                       
TCP: Hash tables configured (established 262144 bind 65536)                        
TCP reno registered                                                                
NET: Registered protocol family 1                                                  
pci 0000:01:00.0: Boot video device                                                
SGI XFS with security attributes, large block/inode numbers, no debug enabled      
msgmni has been set to 7927                                                        
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)               
io scheduler noop registered                                                       
io scheduler cfq registered (default)                                              
pcieport 0000:00:01.0: irq 24 for MSI/MSI-X                                        
pcieport 0000:00:01.0: setting latency timer to 64                                 
pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X                                        
pcieport 0000:00:1c.0: setting latency timer to 64                                 
pcieport 0000:00:1c.2: irq 26 for MSI/MSI-X                                        
pcieport 0000:00:1c.2: setting latency timer to 64                                 
pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X                                        
pcieport 0000:00:1c.4: setting latency timer to 64                                 
pcieport 0000:00:1c.5: irq 28 for MSI/MSI-X                                        
pcieport 0000:00:1c.5: setting latency timer to 64                                 
ahci 0000:00:1f.2: version 3.0                                                     
ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19                      
ahci 0000:00:1f.2: irq 29 for MSI/MSI-X                                            
ahci: SSS flag set, parallel bus scan disabled                                     
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode      
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems 
ahci 0000:00:1f.2: setting latency timer to 64                                     
scsi0 : ahci                                                                       
scsi1 : ahci                                                                       
scsi2 : ahci                                                                       
scsi3 : ahci                                                                       
scsi4 : ahci                                                                       
scsi5 : ahci                                                                       
ata1: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd100 irq 29               
ata2: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd180 irq 29               
ata3: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd200 irq 29               
ata4: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd280 irq 29               
ata5: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd300 irq 29               
ata6: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd380 irq 29               
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1                             
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp                                                                        
serio: i8042 KBD port at 0x60,0x64 irq 1                                           
mice: PS/2 mouse device common for all mice                                        
cpuidle: using governor ladder                                                     
cpuidle: using governor menu                                                       
TCP cubic registered                                                               
NET: Registered protocol family 17                                                 
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0 
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                             
ata1.00: ATA-8: ST31000528AS, CC36, max UDMA/133                                   
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)                      
ata1.00: configured for UDMA/133                                                   
scsi 0:0:0:0: Direct-Access     ATA      ST31000528AS     CC36 PQ: 0 ANSI: 5       
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)            
sd 0:0:0:0: [sda] Write Protect is off                                             
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                          
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                                               
 sda: sda1 sda2 sda3                                                               
sd 0:0:0:0: [sda] Attached SCSI disk                                               
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)                             
ata2.00: ATAPI: HL-DT-ST DVDRAM GH22NS40, NL01, max UDMA/100                       
ata2.00: configured for UDMA/100                                                   
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH22NS40  NL01 PQ: 0 ANSI: 5       
ata3: SATA link down (SStatus 0 SControl 300)                                      
ata4: SATA link down (SStatus 0 SControl 300)                                      
ata5: SATA link down (SStatus 0 SControl 300)                                      
ata6: SATA link down (SStatus 0 SControl 300)                                      
XFS mounting filesystem sda2                                                       
Ending clean XFS mount for filesystem: sda2                                        
VFS: Mounted root (xfs filesystem) readonly on device 8:2.                         
Freeing unused kernel memory: 340k freed                                           
sd 0:0:0:0: Attached scsi generic sg0 type 0                                       
sr 1:0:0:0: Attached scsi generic sg1 type 5                                       
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray              
Uniform CD-ROM driver Revision: 3.20                                               
sr 1:0:0:0: Attached scsi CD-ROM sr0                                               
Floppy drive(s): fd0 is 1.44M                                                      
FDC 0 is a post-1991 82077                                                         
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded                                    
r8169 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17                     
r8169 0000:05:00.0: setting latency timer to 64                                    
r8169 0000:05:00.0: irq 30 for MSI/MSI-X                                           
eth0: RTL8168c/8111c at 0xffffc9001059e000, 00:01:29:a7:66:0b, XID 1c4000c0 IRQ 30 
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1    
ACPI: Power Button [PWRB]                                                          
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2               
ACPI: Power Button [PWRF]                                                          
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18                
Driver 'rtc_cmos' needs updating - please use bus_type methods                     
rtc_cmos 00:04: RTC can wake from S4                                               
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0                              
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs                           
thermal LNXTHERM:01: registered as thermal_zone0                                   
ACPI: Thermal Zone [THRM] (28 C)                                                   
ACPI: SSDT 00000000bfee74c0 0026C (v01  PmRef  Cpu0Ist 00003000 INTL 20050309)     
processor LNXCPU:00: registered as cooling_device0                                 
ACPI: SSDT 00000000bfee7980 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20050309)     
processor LNXCPU:01: registered as cooling_device1                                 
usbcore: registered new interface driver usbfs                                     
usbcore: registered new interface driver hub                                       
usbcore: registered new device driver usb                                          
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                         
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18                  
ehci_hcd 0000:00:1a.7: setting latency timer to 64                                 
ehci_hcd 0000:00:1a.7: EHCI Host Controller                                        
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1               
fan PNP0C0B:00: registered as cooling_device2                                      
ACPI: Fan [FAN] (on)                                                               
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported                      
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000                                   
saa7164 driver loaded                                                              
saa7164 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                   
CORE saa7164[0]: subsystem: 0070:8980, board: Hauppauge WinTV-HVR2200 [card=4,autodetected]                                                                           
saa7164[0]/0: found at 0000:03:00.0, rev: 129, irq: 18, latency: 0, mmio: 0xfd000000                                                                                  
saa7164 0000:03:00.0: setting latency timer to 64                                  
IRQ 18/saa7164[0]: IRQF_DISABLED is not guaranteed on shared IRQs                  
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00                                  
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                      
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb1: Product: EHCI Host Controller                                            
usb usb1: Manufacturer: Linux 2.6.32-rc7 ehci_hcd                                  
usb usb1: SerialNumber: 0000:00:1a.7                                               
usb usb1: configuration #1 chosen from 1 choice                                    
hub 1-0:1.0: USB hub found                                                         
hub 1-0:1.0: 6 ports detected                                                      
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23                  
ehci_hcd 0000:00:1d.7: setting latency timer to 64                                 
ehci_hcd 0000:00:1d.7: EHCI Host Controller                                        
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2               
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported                      
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000                                   
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00                                  
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002                      
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb2: Product: EHCI Host Controller                                            
usb usb2: Manufacturer: Linux 2.6.32-rc7 ehci_hcd                                  
usb usb2: SerialNumber: 0000:00:1d.7                                               
usb usb2: configuration #1 chosen from 1 choice                                    
hub 2-0:1.0: USB hub found                                                         
hub 2-0:1.0: 6 ports detected                                                      
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22                 
HDA Intel 0000:00:1b.0: setting latency timer to 64                                
saa7164_downloadfirmware() no first image                                          
saa7164_downloadfirmware() Waiting for firmware upload (v4l-saa7164-1.0.3.fw)   
saa7164 0000:03:00.0: firmware: requesting v4l-saa7164-1.0.3.fw                 
nvidia: module license 'NVIDIA' taints kernel.                                     
Disabling lock debugging due to kernel taint                                       
uhci_hcd: USB Universal Host Controller Interface driver                           
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                    
nvidia 0000:01:00.0: setting latency timer to 64                                   
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  190.42  Tue Oct 20 20:25:42 PDT 2009                                                                                  
hda_codec: ALC889A: BIOS auto-probing.                                             
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                  
uhci_hcd 0000:00:1a.0: setting latency timer to 64                                 
uhci_hcd 0000:00:1a.0: UHCI Host Controller                                        
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3               
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00                                  
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001                      
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb3: Product: UHCI Host Controller                                            
usb usb3: Manufacturer: Linux 2.6.32-rc7 uhci_hcd                                  
usb usb3: SerialNumber: 0000:00:1a.0                                               
usb usb3: configuration #1 chosen from 1 choice                                    
hub 3-0:1.0: USB hub found                                                         
hub 3-0:1.0: 2 ports detected                                                      
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21                  
uhci_hcd 0000:00:1a.1: setting latency timer to 64                                 
uhci_hcd 0000:00:1a.1: UHCI Host Controller                                        
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4               
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00                                  
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001                      
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb4: Product: UHCI Host Controller                                            
usb usb4: Manufacturer: Linux 2.6.32-rc7 uhci_hcd                                  
usb usb4: SerialNumber: 0000:00:1a.1                                               
usb usb4: configuration #1 chosen from 1 choice                                    
hub 4-0:1.0: USB hub found                                                         
hub 4-0:1.0: 2 ports detected                                                      
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19                  
uhci_hcd 0000:00:1a.2: setting latency timer to 64                                 
uhci_hcd 0000:00:1a.2: UHCI Host Controller                                        
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5               
uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fd00                                  
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001                      
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb5: Product: UHCI Host Controller                                            
usb usb5: Manufacturer: Linux 2.6.32-rc7 uhci_hcd                                  
usb usb5: SerialNumber: 0000:00:1a.2                                               
usb usb5: configuration #1 chosen from 1 choice                                    
hub 5-0:1.0: USB hub found                                                         
hub 5-0:1.0: 2 ports detected                                                      
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23                  
uhci_hcd 0000:00:1d.0: setting latency timer to 64                                 
uhci_hcd 0000:00:1d.0: UHCI Host Controller                                        
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6               
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00                                  
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001                      
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb6: Product: UHCI Host Controller                                            
usb usb6: Manufacturer: Linux 2.6.32-rc7 uhci_hcd                                  
usb usb6: SerialNumber: 0000:00:1d.0                                               
usb usb6: configuration #1 chosen from 1 choice                                    
hub 6-0:1.0: USB hub found                                                         
hub 6-0:1.0: 2 ports detected                                                      
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19                  
uhci_hcd 0000:00:1d.1: setting latency timer to 64                                 
uhci_hcd 0000:00:1d.1: UHCI Host Controller                                        
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7               
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00                                  
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001                      
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb7: Product: UHCI Host Controller                                            
usb usb7: Manufacturer: Linux 2.6.32-rc7 uhci_hcd                                  
usb usb7: SerialNumber: 0000:00:1d.1                                               
usb usb7: configuration #1 chosen from 1 choice                                    
hub 7-0:1.0: USB hub found                                                         
hub 7-0:1.0: 2 ports detected                                                      
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18                  
uhci_hcd 0000:00:1d.2: setting latency timer to 64                                 
uhci_hcd 0000:00:1d.2: UHCI Host Controller                                        
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8               
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00                                  
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001                      
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1                 
usb usb8: Product: UHCI Host Controller                                            
usb usb8: Manufacturer: Linux 2.6.32-rc7 uhci_hcd                                  
usb usb8: SerialNumber: 0000:00:1d.2                                               
usb usb8: configuration #1 chosen from 1 choice                                    
hub 8-0:1.0: USB hub found                                                         
hub 8-0:1.0: 2 ports detected                                                      
saa7164_downloadfirmware() firmware read 3978608 bytes.                            
saa7164_downloadfirmware() firmware loaded.                                        
Firmware file header part 1:                                                       
 .FirmwareSize = 0x0                                                               
 .BSLSize = 0x0                                                                    
 .Reserved = 0x3d0d4                                                               
 .Version = 0x3                                                                    
saa7164_downloadfirmware() SecBootLoader.FileSize = 3978608                        
saa7164_downloadfirmware() FirmwareSize = 0x1fd6                                   
saa7164_downloadfirmware() BSLSize = 0x0                                           
saa7164_downloadfirmware() Reserved = 0x0                                          
saa7164_downloadfirmware() Version = 0x11cdb                                       
usb 3-2: new low speed USB device using uhci_hcd and address 2                     
usb 3-2: New USB device found, idVendor=046d, idProduct=c03e                       
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0                  
usb 3-2: Product: USB-PS/2 Optical Mouse                                           
usb 3-2: Manufacturer: Logitech                                                    
usb 3-2: configuration #1 chosen from 1 choice                                     
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input3                                                              
generic-usb 0003:046D:C03E.0001: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-2/input0                                            
usbcore: registered new interface driver usbhid                                    
usbhid: v2.6:USB HID core driver                                                   
saa7164_downloadimage() Image downloaded, booting...                               
saa7164_downloadimage() Image booted successfully.                                 
starting firmware download(2)                                                      
saa7164_downloadimage() Image downloaded, booting...                               
saa7164_downloadimage() Image booted successfully.                                 
firmware download complete.                                                        
tveeprom 1-0000: Hauppauge model 89619, rev D2F2, serial# 6276906                  
tveeprom 1-0000: MAC address is 00-0D-FE-5F-C7-2A                                  
tveeprom 1-0000: tuner model is NXP 18271C2_716x (idx 152, type 4)                 
tveeprom 1-0000: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)                                                          
tveeprom 1-0000: audio processor is SAA7164 (idx 43)                               
tveeprom 1-0000: decoder processor is SAA7164 (idx 40)                             
tveeprom 1-0000: has radio                                                         
saa7164[0]: Hauppauge eeprom: model=89619                                          
tda18271 2-0060: creating new instance                                             
TDA18271HD/C2 detected @ 2-0060                                                    
DVB: registering new adapter (saa7164)                                             
DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...                    
tda18271 3-0060: creating new instance                                             
TDA18271HD/C2 detected @ 3-0060                                                    
tda18271: performing RF tracking filter calibration                                
tda18271: RF tracking filter calibration complete                                  
DVB: registering new adapter (saa7164)                                             
DVB: registering adapter 1 frontend 0 (NXP TDA10048HN DVB-T)...                    
r8169: eth0: link down                                                             
usb 1-3: new high speed USB device using ehci_hcd and address 3                    
usb 1-3: New USB device found, idVendor=13fe, idProduct=1e23                       
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3                  
usb 1-3: Product: STORE N GO                                                       
usb 1-3: Manufacturer: Verbatim                                                    
usb 1-3: SerialNumber: 07771F8004DB                                                
usb 1-3: configuration #1 chosen from 1 choice                                     
Initializing USB Mass Storage driver...                                            
scsi6 : SCSI emulation for USB Mass Storage devices                                
usbcore: registered new interface driver usb-storage                               
USB Mass Storage support registered.                                               
usb-storage: device found at 3                                                     
usb-storage: waiting for device to settle before scanning                          
scsi 6:0:0:0: Direct-Access     Verbatim STORE N GO       5.00 PQ: 0 ANSI: 0 CCS   
sd 6:0:0:0: Attached scsi generic sg2 type 0                                       
sd 6:0:0:0: [sdb] 16119808 512-byte logical blocks: (8.25 GB/7.68 GiB)             
sd 6:0:0:0: [sdb] Write Protect is off                                             
sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00                                          
sd 6:0:0:0: [sdb] Assuming drive cache: write through                              
usb-storage: device scan complete
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Attached SCSI removable disk
tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
saa7164 0000:03:00.0: firmware: requesting dvb-fe-tda10048-1.0.fw
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
tda10048_firmware_upload: firmware uploaded
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete
tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
saa7164 0000:03:00.0: firmware: requesting dvb-fe-tda10048-1.0.fw
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
tda10048_firmware_upload: firmware uploaded
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete
 		 	   		  
_________________________________________________________________
Windows Live: Make it easier for your friends to see what you’re up to on Facebook.
http://www.microsoft.com/middleeast/windows/windowslive/see-it-in-action/social-network-basics.aspx?ocid=PID23461::T:WLMTAGL:ON:WL:en-xm:SI_SB_2:092009