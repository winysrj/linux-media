Return-path: <video4linux-list-bounces@redhat.com>
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <49722701.4040704@linuxtv.org>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com>
	<200901171720.03890.hverkuil@xs4all.nl>
	<1232214144.2702.77.camel@pc10.localdom.local>
	<49722701.4040704@linuxtv.org>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 20:16:03 +0100
Message-Id: <1232219763.2702.81.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, CityK <cityk@rogers.com>,
	linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 17.01.2009, 13:44 -0500 schrieb Michael Krufky:
> hermann pitton wrote:
> > Hi,
> >
> > Am Samstag, den 17.01.2009, 17:20 +0100 schrieb Hans Verkuil:
> >   
> >> On Friday 16 January 2009 04:20:02 CityK wrote:
> >>     
> >>> CityK wrote:
> >>>       
> >>>> If you had meant taking Hans' source and applying your "hack" patch
> >>>> to them, building and then proceeding with the modprobe steps, the
> >>>> answer is that I haven't tried yet. Will test -- might not be
> >>>> tonight though, as I have some other things that need attending
> >>>> too.
> >>>>         
> >>> Okay, I lied -- given that building is really a background process, I
> >>> found time ... i.e. I cleaned up in the kitchen while the system
> >>> compiled ... kneel before me world, as I am a master multi-tasker!
> >>>
> >>>       
> >>>>> Anyway, if the previous workaround works after Hans' changes, then
> >>>>> I think his changes should be merged -- even though it doesnt fix
> >>>>> ATSC115, it is indeed a step into the right direction.
> >>>>>
> >>>>> If the ATSC115 hack-fix patch doesn't apply anymore, please let me
> >>>>> know -- I'll respin it.
> >>>>>           
> >>> The "hack-fix" patch applies cleanly against Hans' sources. However,
> >>> the test results are negative -- the previous workaround ("modprobe
> >>> tuner -r and "modprobe tuner") fails to produce the desired result.
> >>>       
> >> If you try to run 'modprobe -r tuner' when the saa7134 module build from 
> >> my sources is loaded, then that should not work since saa7134 increases 
> >> the use-count of the tuner module preventing it from being unloaded.
> >>
> >> If you can do this, then that suggests that you are perhaps not using my 
> >> modified driver at all.
> >>
> >> BTW, I've asked Mauro to pull from my tree 
> >> (www.linuxtv.org/hg/~hverkuil/v4l-dvb) which contains the converted 
> >> saa7134 and saa6752hs drivers. It's definitely something that needs to 
> >> be done regardless.
> >>     
> >
> > Hans, Mauro has pulled them in already.
> >
> > For my report for the old issue with the tda9987 not loaded for the
> > md7134 card=12 with eeprom tuner detection and all the types with
> > FMD1216ME MK3 hybrid subsumed there beside the older ones with analog
> > only tuners (CTX917/918/925triple/946mpeg/921cardbus), the users must
> > just unload the saa7134 and tuner modules and then load tda9887 and
> > tuner before the saa7134 for now.
> 
> That's not possible -- tda9887 is now a sub-module of tuner-core.  
> tda9887, when modprobed alone, will not attach to any actual device 
> without also having tuner.ko loaded in memory.  tda9887 is a separate 
> module, but its interface is currently only accessed via tuner-core 
> (tuner.ko)
> 
> -Mike

Mike, please look.

You can see that the previously not loaded tda9887 is present and
initialized now.

Cheers,
Hermann

[root@pc10 ~]# modprobe -vr saa7134-dvb
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/saa7134/saa7134-dvb.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/videobuf-dvb.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/dvb/dvb-core/dvb-core.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/saa7134/saa7134.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/common/ir-common.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/tveeprom.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/videobuf-dma-sg.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/videobuf-core.ko
[root@pc10 ~]# modprobe -vr tda9887 tuner tuner-simple
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/tuner.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/v4l2-common.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/videodev.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/v4l1-compat.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/common/tuners/tuner-simple.ko
rmmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/common/tuners/tuner-types.ko
[root@pc10 ~]# modprobe -v tda9887
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/common/tuners/tda9887.ko
[root@pc10 ~]# modprobe -v tuner
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/v4l1-compat.ko
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/videodev.ko
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/v4l2-common.ko
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/tuner.ko
[root@pc10 ~]# modprobe -v saa7134
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/tveeprom.ko
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/videobuf-core.ko
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/videobuf-dma-sg.ko
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/common/ir-common.ko
insmod /lib/modules/2.6.26.6-49.fc8/kernel/drivers/media/video/saa7134/saa7134.ko latency=64 gbuffers=32
[root@pc10 ~]# dmesg
Initializing cgroup subsys cpuset
Linux version 2.6.26.6-49.fc8 (mockbuild@x86-2.fedora.phx.redhat.com) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP Fri Oct 17 15:59:36 EDT 2008
PAT disabled. Not yet verified on this CPU type.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Entering add_active_range(0, 0, 262128) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262128
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262128
On node 0 totalpages: 262128
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 256 pages used for memmap
  HighMem zone: 32496 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.2 present.
Using APIC driver default
ACPI: RSDP 000F6D60, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF30C0, 43F8 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF74C0, 005A (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PERCPU: Allocating 41384 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260080
Kernel command line: ro root=LABEL=/ selinux=0
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c07cb000 soft=c07ab000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1829.999 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1031092k/1048512k available (2254k kernel code, 16680k reserved, 1180k data, 284k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc53000 - 0xfffff000   (3760 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0761000 - 0xc07a8000   ( 284 kB)
      .data : 0xc0633847 - 0xc075ab88   (1180 kB)
      .text : 0xc0400000 - 0xc0633847   (2254 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3662.17 BogoMIPS (lpj=1831089)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 19k freed
ACPI: Core revision 20080321
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) XP 2500+ stepping 00
APIC calibration not consistent with PM Timer: 98ms instead of 100ms
APIC delta adjusted to PM-Timer: 2079547 (2058441)
Brought up 1 CPUs
Total of 1 processors activated (3662.17 BogoMIPS).
sizeof(vma)=84 bytes
sizeof(page)=32 bytes
sizeof(inode)=340 bytes
sizeof(dentry)=132 bytes
sizeof(ext3inode)=492 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=180 bytes
sizeof(task_struct)=3188 bytes
CPU0 attaching sched-domain:
 domain 0: span 0
  groups: 0
net_namespace: 660 bytes
Booting paravirtualized kernel on bare hardware
Time: 12:32:54  Date: 01/17/09
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb4a0, last bus=3
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: nForce2 C1 Halt Disconnect fixup
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB1._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 *4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAPU] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 *4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs *16)
ACPI: PCI Interrupt Link [APC2] (IRQs *17)
ACPI: PCI Interrupt Link [APC3] (IRQs *18)
ACPI: PCI Interrupt Link [APC4] (IRQs *19)
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
system 00:00: ioport range 0x4000-0x407f has been reserved
system 00:00: ioport range 0x4080-0x40ff has been reserved
system 00:00: ioport range 0x4400-0x447f has been reserved
system 00:00: ioport range 0x4480-0x44ff has been reserved
system 00:00: ioport range 0x4200-0x427f has been reserved
system 00:00: ioport range 0x4280-0x42ff has been reserved
system 00:01: ioport range 0x5000-0x503f has been reserved
system 00:01: ioport range 0x5500-0x553f has been reserved
system 00:02: iomem range 0xd0800-0xd3fff has been reserved
system 00:02: iomem range 0xf0000-0xf7fff could not be reserved
system 00:02: iomem range 0xf8000-0xfbfff could not be reserved
system 00:02: iomem range 0xfc000-0xfffff could not be reserved
system 00:02: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:02: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:02: iomem range 0x0-0x9ffff could not be reserved
system 00:02: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:02: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:02: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:04: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:08.0
  IO window: disabled.
  MEM window: 0xe8000000-0xe8ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: d000-dfff
  MEM window: 0xe4000000-0xe5ffffff
  PREFETCH window: 0x0000000050000000-0x00000000500fffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xe6000000-0xe7ffffff
  PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2988k freed
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
type=2000 audit(1232195573.539:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1764
ksign: Installing public key data
Loading keyring
- Added public key 942ED0CAD7D49A2
- User ID: Red Hat, Inc. (Kernel Module GPG key)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:03:00.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart: Detected NVIDIA nForce2 chipset
agpgart: AGP aperture is 64M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input2
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 9:993:531
Freeing unused kernel memory: 284k freed
Write protecting the kernel text: 2256k
Write protecting the kernel read-only data: 960k
input: AT Translated Set 2 keyboard as /class/input/input3
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [APCL] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: selective suspend/wakeup unavailable
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: irq 22, io mem 0xe9081000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26.6-49.fc8 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.2
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 21, io mem 0xe9082000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26.6-49.fc8 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
ACPI: PCI Interrupt Link [APCG] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 20 (level, high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 20, io mem 0xe9080000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26.6-49.fc8 ohci_hcd
usb usb3: SerialNumber: 0000:00:02.1
USB Universal Host Controller Interface driver v3.0
input: PS/2 Generic Mouse as /class/input/input4
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
pata_amd 0000:00:09.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:09.0 to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-7: SAMSUNG SP1614N, TM100-24, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48
ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc600c000) ACPI=0x3f01f (20:600:0x13)
ata1.00: configured for UDMA/100
ata2.00: ATAPI: AOPEN   16XDVD-ROM/AMH      20021219, R17, max UDMA/33
ata2: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc600c000) ACPI=0x701f (60:600:0x13)
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SP1614N  TM10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 > sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            AOPEN    16XDVD-ROM/AMH   R17  PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 16x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x5500
input: PC Speaker as /class/input/input5
ACPI: PCI Interrupt Link [AP3C] enabled at IRQ 22
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [AP3C] -> GSI 22 (level, high) -> IRQ 22
3c59x: Donald Becker and others.
0000:02:01.0: 3Com PCI 3c920 Tornado at f88e8000.
Linux video capture interface: v2.00
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [APC4] -> GSI 19 (level, high) -> IRQ 19
NVRM: loading NVIDIA Linux x86 Kernel Module  96.43.09  Mon Oct 27 14:23:30 PST 2008
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC4] -> GSI 19 (level, high) -> IRQ 19
saa7134[0]: setting pci latency timer to 64
saa7134[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 64, mmio: 0xe8000000
saa7134[0]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
saa7134[0]: board init: gpio is 0
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [APCJ] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:06.0 to 64
saa7134[0]: i2c eeprom 00: be 16 03 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7134[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 1f 02 51 96 2b
saa7134[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8f
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 00
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 2-0061: chip found @ 0xc2 (saa7134[0])
saa7134[0] Board has DVB-T
saa7134[0] Tuner type is 63
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, high) -> IRQ 18
saa7133[1]: setting pci latency timer to 64
saa7133[1]: found at 0000:01:08.0, rev: 208, irq: 18, latency: 64, mmio: 0xe8001000
saa7133[1]: subsystem: 1043:4862, board: ASUSTeK P7131 Dual [card=78,autodetected]
saa7133[1]: board init: gpio is 0
input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input6
intel8x0_measure_ac97_clock: measured 50744 usecs
intel8x0: clocking to 47449
saa7133[1]: i2c eeprom 00: 43 10 62 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[1]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d6 ff ff ff ff
saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 3-004b: chip found @ 0x96 (saa7133[1])
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
saa7133[1]: registered device video1 [v4l2]
saa7133[1]: registered device vbi1
saa7133[1]: registered device radio1
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC2] -> GSI 17 (level, high) -> IRQ 17
saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 64, mmio: 0xe8002000
saa7133[2]: subsystem: 16be:0010, board: Medion/Creatix CTX953 Hybrid [card=134,autodetected]
saa7133[2]: board init: gpio is 0
saa7133[2]: i2c eeprom 00: be 16 10 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[2]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 2c 02 51 96 2b
saa7133[2]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[2]: i2c eeprom 40: ff 21 00 c0 96 10 03 22 15 00 fd 79 44 9f c2 8f
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 4-004b: chip found @ 0x96 (saa7133[2])
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [APC1] -> GSI 16 (level, high) -> IRQ 16
saa7134[3]: setting pci latency timer to 64
saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 16be:5000, board: Medion 7134 [card=12,autodetected]
saa7134[3]: board init: gpio is 820000
saa7134[3]: i2c eeprom 00: be 16 00 50 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[3]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7134[3]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 6c 02 51 96 2b
saa7134[3]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7134[3]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8f
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 00
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 5-0061: chip found @ 0xc2 (saa7134[3])
saa7134[3] Board has DVB-T
saa7134[3] Tuner type is 63
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2
dvb_init() allocating 1 frontend
tuner-simple 2-0061: attaching existing instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[0])
DVB: registering adapter 0 frontend -1837029187 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda4, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
tda1004x: found firmware revision 26 -- ok
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[1])
DVB: registering adapter 1 frontend 1152717138 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
Adding 1477940k swap on /dev/sda8.  Priority:-1 extents:1 across:1477940k
tda1004x: found firmware revision 29 -- ok
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[2])
DVB: registering adapter 2 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
dvb_init() allocating 1 frontend
tuner-simple 5-0061: attaching existing instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[3])
DVB: registering adapter 3 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 29 -- ok
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
eth0:  setting full-duplex.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
eth0: no IPv6 routers present
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:03:00.0 into 4x mode
tuner-simple 5-0061: destroying instance
tuner-simple 2-0061: destroying instance
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134[0]: setting pci latency timer to 64
saa7134[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 64, mmio: 0xe8000000
saa7134[0]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
saa7134[0]: board init: gpio is 0
saa7134[0]: i2c eeprom 00: ba 10 03 00 40 00 00 00 42 01 a0 00 00 40 80 02
saa7134[0]: i2c eeprom 10: 00 71 84 0c 3f 00 83 00 01 50 12 48 00 00 82 00
saa7134[0]: i2c eeprom 20: 00 40 00 00 00 01 01 00 00 50 00 1b 00 00 92 00
saa7134[0]: i2c eeprom 30: a6 48 20 05 02 8e 84 06 c2 00 00 20 00 06 a0 24
saa7134[0]: i2c eeprom 40: 9a 01 00 02 06 00 00 00 00 00 0c 01 40 9f 42 08
saa7134[0]: i2c eeprom 50: 5a 8d e2 00 00 50 02 06 00 00 08 00 00 00 08 00
saa7134[0]: i2c eeprom 60: 04 83 fa ff fc 58 5a 8d e2 00 00 50 21 5e 20 00
saa7134[0]: i2c eeprom 70: 09 7c 9f 5b 07 50 24 87 e7 00 03 4e fe 71 38 5f
saa7134[0]: i2c eeprom 80: 20 ff ff 41 c0 1d ff 67 90 58 fa 8d e7 00 00 51
saa7134[0]: i2c eeprom 90: c1 60 95 71 92 8e a7 5e da 5e 18 ff f6 a6 91 86
saa7134[0]: i2c eeprom a0: b2 5b 3a ad 7d 50 25 ae 7d 50 40 9f c4 9f fc 50
saa7134[0]: i2c eeprom b0: 14 a6 7d 31 01 41 c0 1e 41 40 9b 5b 00 8e b2 5e
saa7134[0]: i2c eeprom c0: da 5b 12 ac 95 50 16 3f 00 5b 07 41 c0 1d 6e 38
saa7134[0]: i2c eeprom d0: 7a 38 a4 ed 7a 00 00 50 81 79 01 3c a7 28 a9 50
saa7134[0]: i2c eeprom e0: 30 e7 53 00 01 50 10 26 53 71 38 a6 3e 5e da 71
saa7134[0]: i2c eeprom f0: a4 77 f0 77 95 5b 12 8c bb 50 14 26 7a ed 7a 00
tuner 2-0043: chip found @ 0x86 (saa7134[0])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner 2-0061: chip found @ 0xc2 (saa7134[0])
saa7134[0] Cant determine tuner type 123c from EEPROM
saa7134[0] Tuner type is 63
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
saa7133[1]: setting pci latency timer to 64
saa7133[1]: found at 0000:01:08.0, rev: 208, irq: 18, latency: 64, mmio: 0xe8001000
saa7133[1]: subsystem: 1043:4862, board: ASUSTeK P7131 Dual [card=78,autodetected]
saa7133[1]: board init: gpio is 0
input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input7
saa7133[1]: i2c eeprom 00: 43 10 62 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[1]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d6 ff ff ff ff
saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 3-004b: chip found @ 0x96 (saa7133[1])
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
saa7133[1]: registered device video1 [v4l2]
saa7133[1]: registered device vbi1
saa7133[1]: registered device radio1
saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 64, mmio: 0xe8002000
saa7133[2]: subsystem: 16be:0010, board: Medion/Creatix CTX953 Hybrid [card=134,autodetected]
saa7133[2]: board init: gpio is 0
saa7133[2]: i2c eeprom 00: be 16 10 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[2]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 2c 02 51 96 2b
saa7133[2]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[2]: i2c eeprom 40: ff 21 00 c0 96 10 03 22 15 00 fd 79 44 9f c2 8f
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 4-004b: chip found @ 0x96 (saa7133[2])
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
saa7134[3]: setting pci latency timer to 64
saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 16be:5000, board: Medion 7134 [card=12,autodetected]
saa7134[3]: board init: gpio is 820000
saa7134[3]: i2c eeprom 00: be 16 00 50 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[3]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7134[3]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 6c 02 51 96 2b
saa7134[3]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7134[3]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8f
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 00
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 5-0043: chip found @ 0x86 (saa7134[3])
tda9887 5-0043: creating new instance
tda9887 5-0043: tda988[5/6/7] found
tuner 5-0061: chip found @ 0xc2 (saa7134[3])
saa7134[3] Board has DVB-T
saa7134[3] Tuner type is 63
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2
dvb_init() allocating 1 frontend
tuner-simple 2-0061: attaching existing instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 26 -- ok
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[1])
DVB: registering adapter 1 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[2])
DVB: registering adapter 2 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
dvb_init() allocating 1 frontend
tuner-simple 5-0061: attaching existing instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[3])
DVB: registering adapter 3 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 29 -- ok
[root@pc10 ~]#


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
