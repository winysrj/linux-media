Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from angel.comcen.com.au ([203.23.236.69])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rock_on_the_web@comcen.com.au>) id 1Lb4D6-0002If-Qu
	for linux-dvb@linuxtv.org; Sun, 22 Feb 2009 03:36:58 +0100
Received: from [192.168.0.192] (unknown [202.172.126.254])
	by angel.comcen.com.au (Postfix) with ESMTP id 0864A5C2E93D
	for <linux-dvb@linuxtv.org>; Sun, 22 Feb 2009 13:38:00 +1100 (EST)
From: Da Rock <rock_on_the_web@comcen.com.au>
To: linux-dvb@linuxtv.org
Date: Sun, 22 Feb 2009 12:36:34 +1000
Message-Id: <1235270194.17024.40.camel@laptop1.herveybayaustralia.com.au>
Mime-Version: 1.0
Subject: [linux-dvb] Dvico Dual 4 DVB tuner Rev 2 - refusing to work since
	new year
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I picked up 2 of these cards because I read up on them at linuxtv.org,
and found them to be supported reasonably well. Installed them and got
them going before the end of the year.

Around the time of the new year coming in, some updates occurred and I
lost them again. ls /dev/dvb showed on the one adapter when there should
have been 5 (leadtek hybrid is also installed). I tried reinstalling
drivers from linuxtv mercurial sources, but after 3 attempts and several
kernel updates its a no go.

I can run modprobe and load the modules, lsmod shows them there and
loaded, but after reboot (which is the only way to get them working once
modules have been loaded- they're dual tuners running off a usb
controller on the board; obviously I have no way of unplugging and
replugging in as usb) they're gone again.

This is (was) a fresh install of F10 when I first got them working, but
since updates forget it.

I have tried different modules to attempt to get these to work- I ran
modprobe -v -a dvb-usb-cxusb dvb-usb-dibusb-common dib0070 dib7000p
dib7000m dib3000mc tuner-xc2028 zl10353 dibx000-common, just to see if I
could get at least something to stick. I've tried different firmware,
and extracted my own xc3028 firmware.

Any help here guys?


> Linux xxxxxx.xxx.xx 2.6.27.12-170.2.5.fc10.x86_64 #1 SMP Wed Jan 21
01:33:24 EST 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> lsmod
> Module                  Size  Used by
> bridge                 56224  0 
> stp                    10756  1 bridge
> bnep                   22016  2 
> sco                    19204  2 
> l2cap                  28544  3 bnep
> bluetooth              60068  5 bnep,sco,l2cap
> sunrpc                191208  3 
> ip6t_REJECT            12160  2 
> nf_conntrack_ipv6      22984  5 
> ip6table_filter        11136  1 
> ip6_tables             26128  1 ip6table_filter
> ipv6                  287272  32 ip6t_REJECT,nf_conntrack_ipv6
> cpufreq_ondemand       15504  4 
> powernow_k8            24836  0 
> freq_table             12928  2 cpufreq_ondemand,powernow_k8
> dm_multipath           23704  0 
> uinput                 16128  0 
> cx22702                14212  1 
> cx88_dvb               25604  0 
> cx88_vp3054_i2c        10880  1 cx88_dvb
> videobuf_dvb           13316  1 cx88_dvb
> dvb_core               84252  2 cx88_dvb,videobuf_dvb
> tuner_simple           20756  2 
> tuner_types            25472  1 tuner_simple
> tda9887                18564  1 
> tda8290                18820  0 
> tuner                  31820  0 
> snd_seq_dummy          11396  0 
> snd_hda_intel         478752  0 
> cx8802                 23684  1 cx88_dvb
> snd_seq_oss            39104  0 
> cx8800                 40548  0 
> cx88_alsa              20488  0 
> snd_seq_midi_event     14848  1 snd_seq_oss
> cx88xx                 74920  4 cx88_dvb,cx8802,cx8800,cx88_alsa
> snd_seq                61968  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
> snd_seq_device         15380  3 snd_seq_dummy,snd_seq_oss,snd_seq
> snd_pcm_oss            52224  0 
> snd_mixer_oss          23168  1 snd_pcm_oss
> snd_pcm                85512  3 snd_hda_intel,cx88_alsa,snd_pcm_oss
> ir_common              45060  1 cx88xx
> snd_timer              30352  2 snd_seq,snd_pcm
> i2c_algo_bit           13956  2 cx88_vp3054_i2c,cx88xx
> compat_ioctl32         16512  1 cx8800
> videodev               40704  4 tuner,cx8800,cx88xx,compat_ioctl32
> v4l1_compat            21380  1 videodev
> v4l2_common            18560  2 tuner,cx8800
> tveeprom               21508  1 cx88xx
> i2c_core               29216  10
cx22702,cx88_vp3054_i2c,tuner_simple,tda9887,tda8290,tuner,cx88xx,i2c_algo_bit,v4l2_common,tveeprom
> btcx_risc              12296  4 cx8802,cx8800,cx88_alsa,cx88xx
> videobuf_dma_sg        19972  5
cx88_dvb,cx8802,cx8800,cx88_alsa,cx88xx
> pcspkr                 11008  0 
> floppy                 66216  0 
> videobuf_core          24836  5
videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg
> firewire_ohci          30468  0 
> snd_page_alloc         16656  2 snd_hda_intel,snd_pcm
> serio_raw              14084  0 
> firewire_core          45504  1 firewire_ohci
> snd_hwdep              16392  1 snd_hda_intel
> crc_itu_t              10240  1 firewire_core
> snd                    68984  11
snd_seq_dummy,snd_hda_intel,snd_seq_oss,cx88_alsa,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer,snd_hwdep
> soundcore              14992  1 snd
> forcedeth              61840  0 
> pata_amd               21252  0 
> joydev                 19328  0 
> wmi                    14912  0 
> usb_storage           109216  0 
> ata_generic            13956  0 
> pata_acpi              13056  0 
> 
> 
> Some of dmesg:
> 
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x0007fee0
> On node 0 totalpages: 523887
>   DMA zone: 1729 pages, LIFO batch:0
>   DMA32 zone: 512795 pages, LIFO batch:31
> ACPI: PM-Timer IO Port: 0x1008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> ACPI: IRQ14 used by override.
> Setting APIC routing to flat
> ACPI: HPET id: 0x10de8201 base: 0xfeff0000
> Using ACPI (MADT) for SMP configuration information
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> Allocating PCI resources starting at 80000000 (gap: 7ff00000:70100000)
> PERCPU: Allocating 65184 bytes of per cpu data
> NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
> Built 1 zonelists in Node order, mobility grouping on.  Total pages:
514524
> Policy zone: DMA32
> Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Extended CMOS year: 2000
> TSC: PIT calibration confirmed by PMTIMER.
> TSC: using PIT calibration value
> Detected 2199.934 MHz processor.
> spurious 8259A interrupt: IRQ7.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Checking aperture...
> No AGP bridge found
> Node 0: aperture @ dc8000000 size 32 MB
> Aperture beyond 4GB. Ignoring.
> Memory: 2054096k/2096000k available (3305k kernel code, 41452k
reserved, 1837k data, 1292k init)
> CPA: page pool initialized 1 of 1 pages preallocated
> SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4,
Nodes=1
> hpet clockevent registered
> Calibrating delay loop (skipped), value calculated using timer
frequency.. 4399.86 BogoMIPS (lpj=2199931)
> Security Framework initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> Mount-cache hash table entries: 256
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys devices
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU 0/0 -> Node 0
> tseg: 007ff00000
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> using C1E aware idle routine
> ACPI: Core revision 20080609
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
> Using local APIC timer interrupts.
> APIC timer calibration result 12499617
> Detected 12.499 MHz APIC timer.
> Booting processor 1/1 ip 6000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 4400.13 BogoMIPS
(lpj=2200069)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU 1/1 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> CPU1: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> System has AMD C1E enabled
> Switch to broadcast mode on CPU1
> Booting processor 2/2 ip 6000
> Initializing CPU#2
> Calibrating delay using timer specific routine.. 4400.02 BogoMIPS
(lpj=2200014)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU 2/2 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 2
> x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
> CPU2: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
> checking TSC synchronization [CPU#0 -> CPU#2]: passed.
> Switch to broadcast mode on CPU2
> Booting processor 3/3 ip 6000
> Initializing CPU#3
> Calibrating delay using timer specific routine.. 4400.08 BogoMIPS
(lpj=2200040)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU 3/3 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 3
> x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
> CPU3: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
> checking TSC synchronization [CPU#0 -> CPU#3]: passed.
> Brought up 4 CPUs
> Total of 4 processors activated (17600.10 BogoMIPS).
> Switch to broadcast mode on CPU3
> sizeof(vma)=176 bytes
> sizeof(page)=56 bytes
> sizeof(inode)=560 bytes
> sizeof(dentry)=208 bytes
> sizeof(ext3inode)=760 bytes
> sizeof(buffer_head)=104 bytes
> sizeof(skbuff)=232 bytes
> sizeof(task_struct)=5904 bytes
> CPU0 attaching sched-domain:
>  domain 0: span 0-3 level CPU
>   groups: 0 1 2 3
>   domain 1: span 0-3 level NODE
>    groups: 0-3
> CPU1 attaching sched-domain:
>  domain 0: span 0-3 level CPU
>   groups: 1 2 3 0
>   domain 1: span 0-3 level NODE
>    groups: 0-3
> CPU2 attaching sched-domain:
>  domain 0: span 0-3 level CPU
>   groups: 2 3 0 1
>   domain 1: span 0-3 level NODE
>    groups: 0-3
> CPU3 attaching sched-domain:
>  domain 0: span 0-3 level CPU
>   groups: 3 0 1 2
>   domain 1: span 0-3 level NODE
>    groups: 0-3
> Switch to broadcast mode on CPU0
> net_namespace: 1552 bytes
> Booting paravirtualized kernel on bare hardware
> Time: 20:54:14  Date: 02/19/09
> NET: Registered protocol family 16
> No dock devices found.
> node 0 link 0: io port [a000, ffff]
> TOM: 0000000080000000 aka 2048M
> Fam 10h mmconf [f0000000, f00fffff]
> node 0 link 0: mmio [a0000, bffff]
> node 0 link 0: mmio [80000000, efffffff]
> node 0 link 0: mmio [f4000000, fe02ffff]
> node 0 link 0: mmio [f0000000, f05fffff] ==> [f0100000, f05fffff]
> bus: [00,05] on node 0 link 0
> bus: 00 index 0 io port: [0, ffff]
> bus: 00 index 1 mmio: [a0000, bffff]
> bus: 00 index 2 mmio: [80000000, efffffff]
> bus: 00 index 3 mmio: [f0600000, fcffffffff]
> bus: 00 index 4 mmio: [f0100000, f05fffff]
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
> PCI: MCFG area at f0000000 reserved in E820
> PCI: Using MMCONFIG at f0000000 - f3ffffff
> PCI: Using configuration type 1 for base access
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: 0000:00:01.1 reg 10 io port: [ff00, ff3f]
> PCI: 0000:00:01.1 reg 20 io port: [1c00, 1c3f]
> PCI: 0000:00:01.1 reg 24 io port: [1c40, 1c7f]
> pci 0000:00:01.1: PME# supported from D3hot D3cold
> pci 0000:00:01.1: PME# disabled
> PCI: 0000:00:01.3 reg 10 32bit mmio: [fdf80000, fdffffff]
> PCI: 0000:00:02.0 reg 10 32bit mmio: [fe02f000, fe02ffff]
> pci 0000:00:02.0: supports D1
> pci 0000:00:02.0: supports D2
> pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.0: PME# disabled
> PCI: 0000:00:02.1 reg 10 32bit mmio: [fe02e000, fe02e0ff]
> pci 0000:00:02.1: supports D1
> pci 0000:00:02.1: supports D2
> pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:02.1: PME# disabled
> PCI: 0000:00:04.0 reg 10 32bit mmio: [fe02d000, fe02dfff]
> pci 0000:00:04.0: supports D1
> pci 0000:00:04.0: supports D2
> pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:04.0: PME# disabled
> PCI: 0000:00:04.1 reg 10 32bit mmio: [fe02c000, fe02c0ff]
> pci 0000:00:04.1: supports D1
> pci 0000:00:04.1: supports D2
> pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:04.1: PME# disabled
> PCI: 0000:00:06.0 reg 20 io port: [fc00, fc0f]
> PCI: 0000:00:07.0 reg 10 32bit mmio: [fe020000, fe023fff]
> pci 0000:00:07.0: PME# supported from D3hot D3cold
> pci 0000:00:07.0: PME# disabled
> PCI: 0000:00:09.0 reg 10 io port: [9f0, 9f7]
> PCI: 0000:00:09.0 reg 14 io port: [bf0, bf3]
> PCI: 0000:00:09.0 reg 18 io port: [970, 977]
> PCI: 0000:00:09.0 reg 1c io port: [b70, b73]
> PCI: 0000:00:09.0 reg 20 io port: [f700, f70f]
> PCI: 0000:00:09.0 reg 24 32bit mmio: [fe026000, fe027fff]
> PCI: 0000:00:0a.0 reg 10 32bit mmio: [fe02b000, fe02bfff]
> PCI: 0000:00:0a.0 reg 14 io port: [f600, f607]
> PCI: 0000:00:0a.0 reg 18 32bit mmio: [fe02a000, fe02a0ff]
> PCI: 0000:00:0a.0 reg 1c 32bit mmio: [fe029000, fe02900f]
> pci 0000:00:0a.0: supports D1
> pci 0000:00:0a.0: supports D2
> pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.0: PME# disabled
> pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:10.0: PME# disabled
> pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:12.0: PME# disabled
> pci 0000:00:13.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:13.0: PME# disabled
> pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:14.0: PME# disabled
> PCI: 0000:01:08.0 reg 20 io port: [ec00, ec1f]
> pci 0000:01:08.0: supports D1
> pci 0000:01:08.0: supports D2
> pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:01:08.0: PME# disabled
> PCI: 0000:01:08.1 reg 20 io port: [e800, e81f]
> pci 0000:01:08.1: supports D1
> pci 0000:01:08.1: supports D2
> pci 0000:01:08.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:01:08.1: PME# disabled
> PCI: 0000:01:08.2 reg 10 32bit mmio: [fcfff000, fcfff0ff]
> pci 0000:01:08.2: supports D1
> pci 0000:01:08.2: supports D2
> pci 0000:01:08.2: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:01:08.2: PME# disabled
> PCI: 0000:01:09.0 reg 20 io port: [e400, e41f]
> pci 0000:01:09.0: supports D1
> pci 0000:01:09.0: supports D2
> pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:01:09.0: PME# disabled
> PCI: 0000:01:09.1 reg 20 io port: [e000, e01f]
> pci 0000:01:09.1: supports D1
> pci 0000:01:09.1: supports D2
> pci 0000:01:09.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:01:09.1: PME# disabled
> PCI: 0000:01:09.2 reg 10 32bit mmio: [fcffe000, fcffe0ff]
> pci 0000:01:09.2: supports D1
> pci 0000:01:09.2: supports D2
> pci 0000:01:09.2: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:01:09.2: PME# disabled
> PCI: 0000:01:0a.0 reg 10 32bit mmio: [fcffd000, fcffdfff]
> pci 0000:01:0a.0: supports D1
> pci 0000:01:0a.0: supports D2
> pci 0000:01:0a.0: PME# supported from D0 D1 D2 D3hot
> pci 0000:01:0a.0: PME# disabled
> PCI: 0000:01:0b.0 reg 10 32bit mmio: [fb000000, fbffffff]
> PCI: 0000:01:0b.1 reg 10 32bit mmio: [fa000000, faffffff]
> PCI: 0000:01:0b.2 reg 10 32bit mmio: [f9000000, f9ffffff]
> pci 0000:00:08.0: transparent bridge
> PCI: bridge 0000:00:08.0 io port: [e000, efff]
> PCI: bridge 0000:00:08.0 32bit mmio: [f9000000, fcffffff]
> PCI: bridge 0000:00:08.0 32bit mmio pref: [fde00000, fdefffff]
> PCI: 0000:02:00.0 reg 10 64bit mmio: [e0000000, efffffff]
> PCI: 0000:02:00.0 reg 18 64bit mmio: [fdde0000, fddeffff]
> PCI: 0000:02:00.0 reg 20 io port: [dc00, dcff]
> PCI: 0000:02:00.0 reg 30 32bit mmio: [fddc0000, fdddffff]
> pci 0000:02:00.0: supports D1
> pci 0000:02:00.0: supports D2
> PCI: 0000:02:00.1 reg 10 64bit mmio: [fddfc000, fddfffff]
> pci 0000:02:00.1: supports D1
> pci 0000:02:00.1: supports D2
> PCI: bridge 0000:00:10.0 io port: [d000, dfff]
> PCI: bridge 0000:00:10.0 32bit mmio: [fdd00000, fddfffff]
> PCI: bridge 0000:00:10.0 64bit mmio pref: [e0000000, efffffff]
> PCI: bridge 0000:00:12.0 io port: [c000, cfff]
> PCI: bridge 0000:00:12.0 32bit mmio: [fdc00000, fdcfffff]
> PCI: bridge 0000:00:12.0 64bit mmio pref: [fdb00000, fdbfffff]
> PCI: bridge 0000:00:13.0 io port: [b000, bfff]
> PCI: bridge 0000:00:13.0 32bit mmio: [fda00000, fdafffff]
> PCI: bridge 0000:00:13.0 64bit mmio pref: [fd900000, fd9fffff]
> PCI: bridge 0000:00:14.0 io port: [a000, afff]
> PCI: bridge 0000:00:14.0 32bit mmio: [fd800000, fd8fffff]
> PCI: bridge 0000:00:14.0 64bit mmio pref: [fd700000, fd7fffff]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
> ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 *10 11 14 15)
> ACPI: PCI Interrupt Link [LE0A] (IRQs *5 7 9 10 11 14 15)
> ACPI: PCI Interrupt Link [LE0B] (IRQs 5 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [LE0C] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE0D] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE1A] (IRQs 5 7 9 *10 11 14 15)
> ACPI: PCI Interrupt Link [LE1B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE1C] (IRQs 5 *7 9 10 11 14 15)
> ACPI: PCI Interrupt Link [LE1D] (IRQs *5 7 9 10 11 14 15)
> ACPI: PCI Interrupt Link [LE2A] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE2B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE2C] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE2D] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE3A] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE3B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE3C] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE3D] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE4A] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE4B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE4C] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE4D] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE5A] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE5B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE5C] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE5D] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE6A] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE6B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE6C] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE6D] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE7A] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE7B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE7C] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LE7D] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LIGP] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LU1B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LU2B] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 *15)
> ACPI: PCI Interrupt Link [LAZA] (IRQs 5 *7 9 10 11 14 15)
> ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
> ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
> ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
> ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
> ACPI: PCI Interrupt Link [AE0A] (IRQs 16) *0
> ACPI: PCI Interrupt Link [AE0B] (IRQs 16) *0
> ACPI: PCI Interrupt Link [AE0C] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE0D] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE1A] (IRQs 16) *0
> ACPI: PCI Interrupt Link [AE1B] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE1C] (IRQs 16) *0
> ACPI: PCI Interrupt Link [AE1D] (IRQs 16) *0
> ACPI: PCI Interrupt Link [AE2A] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE2B] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE2C] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE2D] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE3A] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE3B] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE3C] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE3D] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE4A] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE4B] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE4C] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE4D] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE5A] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE5B] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE5C] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE5D] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE6A] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE6B] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE6C] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE6D] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE7A] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE7B] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE7C] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AE7D] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [AUBA] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [AUB2] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [AU1B] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [AU2B] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
> ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 12 devices
> ACPI: ACPI bus type pnp unregistered
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
> NetLabel:  protocols = UNLABELED CIPSOv4
> NetLabel:  unlabeled traffic allowed by default
> hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 3
> Switched to high resolution mode on CPU 2
> Switched to high resolution mode on CPU 1
> tracer: 1286 pages allocated for 65536 entries of 80 bytes
>    actual entries 65586
> ACPI: RTC can wake from S4
> system 00:01: ioport range 0x1000-0x107f has been reserved
> system 00:01: ioport range 0x1080-0x10ff has been reserved
> system 00:01: ioport range 0x1400-0x147f has been reserved
> system 00:01: ioport range 0x1480-0x14ff has been reserved
> system 00:01: ioport range 0x1800-0x187f has been reserved
> system 00:01: ioport range 0x1880-0x18ff has been reserved
> system 00:01: iomem range 0xfefe1000-0xfefe10ff could not be reserved
> system 00:02: ioport range 0x4d0-0x4d1 has been reserved
> system 00:02: ioport range 0x800-0x87f has been reserved
> system 00:02: ioport range 0x290-0x297 has been reserved
> system 00:0a: iomem range 0xf0000000-0xf3ffffff could not be reserved
> system 00:0b: iomem range 0xcfa00-0xcffff has been reserved
> system 00:0b: iomem range 0xf0000-0xf7fff could not be reserved
> system 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
> system 00:0b: iomem range 0xfc000-0xfffff could not be reserved
> system 00:0b: iomem range 0xfeff0000-0xfeff00ff could not be reserved
> system 00:0b: iomem range 0x7fee0000-0x7fefffff could not be reserved
> system 00:0b: iomem range 0xffff0000-0xffffffff could not be reserved
> system 00:0b: iomem range 0x0-0x9ffff could not be reserved
> system 00:0b: iomem range 0x100000-0x7fedffff could not be reserved
> system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
> system 00:0b: iomem range 0xfee00000-0xfeefffff could not be reserved
> system 00:0b: iomem range 0xfefff000-0xfeffffff could not be reserved
> system 00:0b: iomem range 0xfff80000-0xfff80fff could not be reserved
> system 00:0b: iomem range 0xfff90000-0xfffbffff could not be reserved
> system 00:0b: iomem range 0xfffed000-0xfffeffff could not be reserved
> pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
> pci 0000:00:08.0:   IO window: 0xe000-0xefff
> pci 0000:00:08.0:   MEM window: 0xf9000000-0xfcffffff
> pci 0000:00:08.0:   PREFETCH window: 0x000000fde00000-0x000000fdefffff
> pci 0000:00:10.0: PCI bridge, secondary bus 0000:02
> pci 0000:00:10.0:   IO window: 0xd000-0xdfff
> pci 0000:00:10.0:   MEM window: 0xfdd00000-0xfddfffff
> pci 0000:00:10.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
> pci 0000:00:12.0: PCI bridge, secondary bus 0000:03
> pci 0000:00:12.0:   IO window: 0xc000-0xcfff
> pci 0000:00:12.0:   MEM window: 0xfdc00000-0xfdcfffff
> pci 0000:00:12.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
> pci 0000:00:13.0: PCI bridge, secondary bus 0000:04
> pci 0000:00:13.0:   IO window: 0xb000-0xbfff
> pci 0000:00:13.0:   MEM window: 0xfda00000-0xfdafffff
> pci 0000:00:13.0:   PREFETCH window: 0x000000fd900000-0x000000fd9fffff
> pci 0000:00:14.0: PCI bridge, secondary bus 0000:05
> pci 0000:00:14.0:   IO window: 0xa000-0xafff
> pci 0000:00:14.0:   MEM window: 0xfd800000-0xfd8fffff
> pci 0000:00:14.0:   PREFETCH window: 0x000000fd700000-0x000000fd7fffff
> pci 0000:00:08.0: setting latency timer to 64
> ACPI: PCI Interrupt Link [AE0A] enabled at IRQ 16
> pci 0000:00:10.0: PCI INT A -> Link[AE0A] -> GSI 16 (level, low) ->
IRQ 16
> pci 0000:00:10.0: setting latency timer to 64
> ACPI: PCI Interrupt Link [AE2A] enabled at IRQ 16
> pci 0000:00:12.0: PCI INT A -> Link[AE2A] -> GSI 16 (level, low) ->
IRQ 16
> pci 0000:00:12.0: setting latency timer to 64
> ACPI: PCI Interrupt Link [AE3A] enabled at IRQ 16
> pci 0000:00:13.0: PCI INT A -> Link[AE3A] -> GSI 16 (level, low) ->
IRQ 16
> pci 0000:00:13.0: setting latency timer to 64
> ACPI: PCI Interrupt Link [AE4A] enabled at IRQ 16
> pci 0000:00:14.0: PCI INT A -> Link[AE4A] -> GSI 16 (level, low) ->
IRQ 16
> pci 0000:00:14.0: setting latency timer to 64
> bus: 00 index 0 io port: [0, ffff]
> bus: 00 index 1 mmio: [0, ffffffffffffffff]
> bus: 01 index 0 io port: [e000, efff]
> bus: 01 index 1 mmio: [f9000000, fcffffff]
> bus: 01 index 2 mmio: [fde00000, fdefffff]
> bus: 01 index 3 io port: [0, ffff]
> bus: 01 index 4 mmio: [0, ffffffffffffffff]
> bus: 02 index 0 io port: [d000, dfff]
> bus: 02 index 1 mmio: [fdd00000, fddfffff]
> bus: 02 index 2 mmio: [e0000000, efffffff]
> bus: 02 index 3 mmio: [0, 0]
> bus: 03 index 0 io port: [c000, cfff]
> bus: 03 index 1 mmio: [fdc00000, fdcfffff]
> bus: 03 index 2 mmio: [fdb00000, fdbfffff]
> bus: 03 index 3 mmio: [0, 0]
> bus: 04 index 0 io port: [b000, bfff]
> bus: 04 index 1 mmio: [fda00000, fdafffff]
> bus: 04 index 2 mmio: [fd900000, fd9fffff]
> bus: 04 index 3 mmio: [0, 0]
> bus: 05 index 0 io port: [a000, afff]
> bus: 05 index 1 mmio: [fd800000, fd8fffff]
> bus: 05 index 2 mmio: [fd700000, fd7fffff]
> bus: 05 index 3 mmio: [0, 0]
> NET: Registered protocol family 2
> IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
> TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> checking if image is initramfs... it is
> Freeing initrd memory: 3853k freed
> audit: initializing netlink socket (disabled)
> type=2000 audit(1235076853.832:1): initialized
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> msgmni has been set to 4019
> SELinux:  Registering netfilter hooks
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pci 0000:00:07.0: Enabling HT MSI Mapping
> pci 0000:00:08.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Enabling HT MSI Mapping
> pci 0000:00:0a.0: Enabling HT MSI Mapping
> pci 0000:00:10.0: Enabling HT MSI Mapping
> pci 0000:00:12.0: Enabling HT MSI Mapping
> pci 0000:00:13.0: Enabling HT MSI Mapping
> pci 0000:00:14.0: Enabling HT MSI Mapping
> pci 0000:02:00.0: Boot video device
> pcieport-driver 0000:00:10.0: setting latency timer to 64
> pcieport-driver 0000:00:10.0: found MSI capability
> pci_express 0000:00:10.0:pcie00: allocate port service
> pcieport-driver 0000:00:12.0: setting latency timer to 64
> pcieport-driver 0000:00:12.0: found MSI capability
> pci_express 0000:00:12.0:pcie00: allocate port service
> pcieport-driver 0000:00:13.0: setting latency timer to 64
> pcieport-driver 0000:00:13.0: found MSI capability
> pci_express 0000:00:13.0:pcie00: allocate port service
> pcieport-driver 0000:00:14.0: setting latency timer to 64
> pcieport-driver 0000:00:14.0: found MSI capability
> pci_express 0000:00:14.0:pcie00: allocate port service
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> input: Power Button (FF)
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button (FF) [PWRF]
> input: Power Button (CM)
as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> ACPI: Power Button (CM) [PWRB]
> fan PNP0C0B:00: registered as cooling_device0
> ACPI: Fan [FAN] (on)
> processor ACPI0007:00: registered as cooling_device1
> processor ACPI0007:01: registered as cooling_device2
> processor ACPI0007:02: registered as cooling_device3
> processor ACPI0007:03: registered as cooling_device4
> ACPI: Expecting a [Reference] package element, found type 0
> thermal LNXTHERM:01: registered as thermal_zone0
> ACPI: Thermal Zone [THRM] (40 C)
> hpet_resources: 0xfeff0000 is busy
> Non-volatile memory driver v1.2
> Linux agpgart interface v0.103
> Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> brd: module loaded
> loop: module loaded
> input: Macintosh mouse button emulation
as /devices/virtual/input/input2
> Driver 'sd' needs updating - please use bus_type methods
> Driver 'sr' needs updating - please use bus_type methods
> ahci 0000:00:09.0: version 3.0
> ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
> ahci 0000:00:09.0: PCI INT A -> Link[APSI] -> GSI 23 (level, low) ->
IRQ 23
> ahci 0000:00:09.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl
IDE mode
> ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pmp pio 
> ahci 0000:00:09.0: setting latency timer to 64
> scsi0 : ahci
> scsi1 : ahci
> scsi2 : ahci
> scsi3 : ahci
> scsi4 : ahci
> scsi5 : ahci
> ata1: SATA max UDMA/133 abar m8192@0xfe026000 port 0xfe026100 irq 23
> ata2: SATA max UDMA/133 abar m8192@0xfe026000 port 0xfe026180 irq 23
> ata3: SATA max UDMA/133 abar m8192@0xfe026000 port 0xfe026200 irq 23
> ata4: SATA max UDMA/133 abar m8192@0xfe026000 port 0xfe026280 irq 23
> ata5: SATA max UDMA/133 abar m8192@0xfe026000 port 0xfe026300 irq 23
> ata6: SATA max UDMA/133 abar m8192@0xfe026000 port 0xfe026380 irq 23
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ATA-8: ST31500341AS, SD17, max UDMA/133
> ata1.00: 2930277168 sectors, multi 16: LBA48 NCQ (not used)
> ata1.00: WARNING: device requires firmware update to be fully
functional.
> ata1.00:          contact the vendor or visit
http://ata.wiki.kernel.org.
> ata1.00: configured for UDMA/133
> ata2: SATA link down (SStatus 0 SControl 300)
> ata3: SATA link down (SStatus 0 SControl 300)
> ata4: SATA link down (SStatus 0 SControl 300)
> ata5: SATA link down (SStatus 0 SControl 300)
> ata6: SATA link down (SStatus 0 SControl 300)
> scsi 0:0:0:0: Direct-Access     ATA      ST31500341AS     SD17 PQ: 0
ANSI: 5
> sd 0:0:0:0: [sda] 2930277168 512-byte hardware sectors (1500302 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
> sd 0:0:0:0: [sda] 2930277168 512-byte hardware sectors (1500302 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
>  sda: sda1 sda2
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> ACPI: PCI Interrupt Link [AUB2] enabled at IRQ 22
> ehci_hcd 0000:00:02.1: PCI INT B -> Link[AUB2] -> GSI 22 (level, low)
-> IRQ 22
> ehci_hcd 0000:00:02.1: setting latency timer to 64
> ehci_hcd 0000:00:02.1: EHCI Host Controller
> ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:02.1: debug port 1
> ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
> ehci_hcd 0000:00:02.1: irq 22, io mem 0xfe02e000
> ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 6 ports detected
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 ehci_hcd
> usb usb1: SerialNumber: 0000:00:02.1
> ACPI: PCI Interrupt Link [AU2B] disabled and referenced, BIOS bug
> ACPI: PCI Interrupt Link [AU2B] enabled at IRQ 21
> ehci_hcd 0000:00:04.1: PCI INT B -> Link[AU2B] -> GSI 21 (level, low)
-> IRQ 21
> ehci_hcd 0000:00:04.1: setting latency timer to 64
> ehci_hcd 0000:00:04.1: EHCI Host Controller
> ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
> ehci_hcd 0000:00:04.1: debug port 1
> ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
> ehci_hcd 0000:00:04.1: irq 21, io mem 0xfe02c000
> usb 1-5: new high speed USB device using ehci_hcd and address 2
> ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 6 ports detected
> hub 1-0:1.0: unable to enumerate USB device on port 5
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: EHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 ehci_hcd
> usb usb2: SerialNumber: 0000:00:04.1
> ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
> ehci_hcd 0000:01:08.2: PCI INT C -> Link[APC3] -> GSI 18 (level, low)
-> IRQ 18
> ehci_hcd 0000:01:08.2: EHCI Host Controller
> ehci_hcd 0000:01:08.2: new USB bus registered, assigned bus number 3
> ehci_hcd 0000:01:08.2: irq 18, io mem 0xfcfff000
> ehci_hcd 0000:01:08.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 4 ports detected
> usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: EHCI Host Controller
> usb usb3: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 ehci_hcd
> usb usb3: SerialNumber: 0000:01:08.2
> ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
> ehci_hcd 0000:01:09.2: PCI INT C -> Link[APC4] -> GSI 19 (level, low)
-> IRQ 19
> ehci_hcd 0000:01:09.2: EHCI Host Controller
> ehci_hcd 0000:01:09.2: new USB bus registered, assigned bus number 4
> ehci_hcd 0000:01:09.2: irq 19, io mem 0xfcffe000
> usb 3-1: new high speed USB device using ehci_hcd and address 2
> ehci_hcd 0000:01:09.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 4 ports detected
> usb 3-1: configuration #1 chosen from 1 choice
> usb 3-1: New USB device found, idVendor=0fe9, idProduct=db98
> usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=4
> usb 3-1: Product: Bluebird
> usb 3-1: Manufacturer: Dvico
> usb 3-1: SerialNumber: 0000802d
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: EHCI Host Controller
> usb usb4: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 ehci_hcd
> usb usb4: SerialNumber: 0000:01:09.2
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> ACPI: PCI Interrupt Link [AUBA] enabled at IRQ 20
> ohci_hcd 0000:00:02.0: PCI INT A -> Link[AUBA] -> GSI 20 (level, low)
-> IRQ 20
> ohci_hcd 0000:00:02.0: setting latency timer to 64
> ohci_hcd 0000:00:02.0: OHCI Host Controller
> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 5
> ohci_hcd 0000:00:02.0: irq 20, io mem 0xfe02f000
> usb 3-2: new high speed USB device using ehci_hcd and address 3
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 6 ports detected
> usb 3-2: configuration #1 chosen from 1 choice
> usb 3-2: New USB device found, idVendor=0fe9, idProduct=db98
> usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=4
> usb 3-2: Product: Bluebird
> usb 3-2: Manufacturer: Dvico
> usb 3-2: SerialNumber: 0000002d
> usb 4-1: new high speed USB device using ehci_hcd and address 2
> usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb5: Product: OHCI Host Controller
> usb usb5: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 ohci_hcd
> usb usb5: SerialNumber: 0000:00:02.0
> ACPI: PCI Interrupt Link [AU1B] enabled at IRQ 23
> ohci_hcd 0000:00:04.0: PCI INT A -> Link[AU1B] -> GSI 23 (level, low)
-> IRQ 23
> ohci_hcd 0000:00:04.0: setting latency timer to 64
> ohci_hcd 0000:00:04.0: OHCI Host Controller
> ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 6
> ohci_hcd 0000:00:04.0: irq 23, io mem 0xfe02d000
> usb usb6: configuration #1 chosen from 1 choice
> hub 6-0:1.0: USB hub found
> hub 6-0:1.0: 6 ports detected
> usb 4-1: configuration #1 chosen from 1 choice
> usb 4-1: New USB device found, idVendor=0fe9, idProduct=db98
> usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=4
> usb 4-1: Product: Bluebird
> usb 4-1: Manufacturer: Dvico
> usb 4-1: SerialNumber: 0000003d
> usb 4-2: new high speed USB device using ehci_hcd and address 3
> usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb6: Product: OHCI Host Controller
> usb usb6: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 ohci_hcd
> usb usb6: SerialNumber: 0000:00:04.0
> USB Universal Host Controller Interface driver v3.0
> ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> uhci_hcd 0000:01:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low)
-> IRQ 16
> uhci_hcd 0000:01:08.0: UHCI Host Controller
> uhci_hcd 0000:01:08.0: new USB bus registered, assigned bus number 7
> uhci_hcd 0000:01:08.0: irq 16, io base 0x0000ec00
> usb usb7: configuration #1 chosen from 1 choice
> hub 7-0:1.0: USB hub found
> hub 7-0:1.0: 2 ports detected
> usb 4-2: configuration #1 chosen from 1 choice
> usb 4-2: New USB device found, idVendor=0fe9, idProduct=db98
> usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=4
> usb 4-2: Product: Bluebird
> usb 4-2: Manufacturer: Dvico
> usb 4-2: SerialNumber: 0000003e
> usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb7: Product: UHCI Host Controller
> usb usb7: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 uhci_hcd
> usb usb7: SerialNumber: 0000:01:08.0
> ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> uhci_hcd 0000:01:08.1: PCI INT B -> Link[APC2] -> GSI 17 (level, low)
-> IRQ 17
> uhci_hcd 0000:01:08.1: UHCI Host Controller
> uhci_hcd 0000:01:08.1: new USB bus registered, assigned bus number 8
> uhci_hcd 0000:01:08.1: irq 17, io base 0x0000e800
> usb usb8: configuration #1 chosen from 1 choice
> hub 8-0:1.0: USB hub found
> hub 8-0:1.0: 2 ports detected
> usb 5-5: new full speed USB device using ohci_hcd and address 2
> usb 5-5: not running at top speed; connect to a high speed hub
> usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb8: Product: UHCI Host Controller
> usb usb8: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 uhci_hcd
> usb usb8: SerialNumber: 0000:01:08.1
> uhci_hcd 0000:01:09.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low)
-> IRQ 17
> uhci_hcd 0000:01:09.0: UHCI Host Controller
> uhci_hcd 0000:01:09.0: new USB bus registered, assigned bus number 9
> uhci_hcd 0000:01:09.0: irq 17, io base 0x0000e400
> usb usb9: configuration #1 chosen from 1 choice
> hub 9-0:1.0: USB hub found
> hub 9-0:1.0: 2 ports detected
> usb 5-5: configuration #1 chosen from 1 choice
> usb 5-5: New USB device found, idVendor=0aec, idProduct=3260
> usb 5-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 5-5: Product: USB Storage Device
> usb 5-5: Manufacturer: GENERIC
> usb 5-5: SerialNumber: 200512071558289LD
> usb 6-2: new low speed USB device using ohci_hcd and address 2
> usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb9: Product: UHCI Host Controller
> usb usb9: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 uhci_hcd
> usb usb9: SerialNumber: 0000:01:09.0
> uhci_hcd 0000:01:09.1: PCI INT B -> Link[APC3] -> GSI 18 (level, low)
-> IRQ 18
> uhci_hcd 0000:01:09.1: UHCI Host Controller
> uhci_hcd 0000:01:09.1: new USB bus registered, assigned bus number 10
> uhci_hcd 0000:01:09.1: irq 18, io base 0x0000e000
> usb usb10: configuration #1 chosen from 1 choice
> hub 10-0:1.0: USB hub found
> hub 10-0:1.0: 2 ports detected
> usb 6-2: configuration #1 chosen from 1 choice
> usb 6-2: New USB device found, idVendor=1241, idProduct=f761
> usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 6-2: Product: Wireless Keyboard/Mouse(2.4G)
> usb 6-2: Manufacturer: HOLTEK
> usb usb10: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb10: Product: UHCI Host Controller
> usb usb10: Manufacturer: Linux 2.6.27.12-170.2.5.fc10.x86_64 uhci_hcd
> usb usb10: SerialNumber: 0000:01:09.1
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> usb 6-3: new low speed USB device using ohci_hcd and address 3
> rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one year, y3k, hpet irqs
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
> cpuidle: using governor ladder
> cpuidle: using governor menu
> usb 6-3: configuration #1 chosen from 1 choice
> usb 6-3: New USB device found, idVendor=051d, idProduct=0002
> usb 6-3: New USB device strings: Mfr=3, Product=1, SerialNumber=2
> usb 6-3: Product: Back-UPS ES 550 FW:828.D2 .I USB FW:D2 
> usb 6-3: Manufacturer: APC
> usb 6-3: SerialNumber: 5B0804T22934  
> usbcore: registered new interface driver hiddev
> input: HOLTEK Wireless Keyboard/Mouse(2.4G)
as /devices/pci0000:00/0000:00:04.0/usb6/6-2/6-2:1.0/input/input3
> input,hidraw0: USB HID v1.10 Keyboard [HOLTEK Wireless
Keyboard/Mouse(2.4G)] on usb-0000:00:04.0-2
> input: HOLTEK Wireless Keyboard/Mouse(2.4G)
as /devices/pci0000:00/0000:00:04.0/usb6/6-2/6-2:1.1/input/input4
> input,hidraw1: USB HID v1.10 Mouse [HOLTEK Wireless
Keyboard/Mouse(2.4G)] on usb-0000:00:04.0-2
> hiddev96hidraw2: USB HID v1.10 Device [APC Back-UPS ES 550
FW:828.D2 .I USB FW:D2 ] on usb-0000:00:04.0-3
> usbcore: registered new interface driver usbhid
> usbhid: v2.6:USB HID core driver
> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
> nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module
option or
> sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> ip_tables: (C) 2000-2006 Netfilter Core Team
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 17
> registered taskstats version 1
>   Magic number: 13:415:953
> Freeing unused kernel memory: 1292k freed
> Write protecting the kernel read-only data: 4748k
> pata_acpi 0000:00:06.0: setting latency timer to 64
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> type=1404 audit(1235076859.996:2): enforcing=1 old_enforcing=0
auid=4294967295 ses=4294967295
> SELinux: 8192 avtab hash slots, 113806 rules.
> SELinux: 8192 avtab hash slots, 113806 rules.
> SELinux:  8 users, 11 roles, 2669 types, 120 bools, 1 sens, 1024 cats
> SELinux:  73 classes, 113806 rules
> SELinux:  Completing initialization.
> SELinux:  Setting up existing superblocks.
> SELinux: initialized (dev dm-0, type ext3), uses xattr
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
> SELinux: initialized (dev selinuxfs, type selinuxfs), uses
genfs_contexts
> SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses
genfs_contexts
> SELinux: initialized (dev devpts, type devpts), uses transition SIDs
> SELinux: initialized (dev inotifyfs, type inotifyfs), uses
genfs_contexts
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses
genfs_contexts
> SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
> SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
> SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
> SELinux: initialized (dev proc, type proc), uses genfs_contexts
> SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
> SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
> SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> type=1403 audit(1235076860.176:3): policy loaded auid=4294967295
ses=4294967295
> udevd version 127 started
> Initializing USB Mass Storage driver...
> scsi6 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> ACPI: WMI: Mapper loaded
> pata_amd 0000:00:06.0: version 0.3.10
> pata_amd 0000:00:06.0: setting latency timer to 64
> scsi7 : pata_amd
> scsi8 : pata_amd
> ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
> ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
> ata7.00: ATAPI: HL-DT-ST DVDRAM GSA-4167B, DL13, max UDMA/33
> ata7: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc0000000)
ACPI=0x701f (60:600:0x13)
> ata7.00: configured for UDMA/33
> ata8: port disabled. ignoring.
> isa bounce pool size: 16 pages
> scsi 7:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0
ANSI: 5
> sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 7:0:0:0: Attached scsi CD-ROM sr0
> sr 7:0:0:0: Attached scsi generic sg1 type 5
> forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
> ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
> forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 22 (level, low)
-> IRQ 22
> forcedeth 0000:00:0a.0: setting latency timer to 64
> Floppy drive(s): fd0 is 1.44M
> input: PC Speaker as /devices/platform/pcspkr/input/input5
> FDC 0 is a post-1991 82077
> Linux video capture interface: v2.00
> forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x1374 @ 1, addr
00:22:15:3d:f3:14
> forcedeth 0000:00:0a.0: highdma csum pwrctl mgmt timirq gbit lnktim
msi desc-v3
> firewire_ohci 0000:01:0a.0: PCI INT A -> Link[APC4] -> GSI 19 (level,
low) -> IRQ 19
> CE: hpet increasing min_delta_ns to 15000 nsec
> CE: hpet increasing min_delta_ns to 22500 nsec
> CE: hpet increasing min_delta_ns to 33750 nsec
> firewire_ohci: Added fw-ohci device 0000:01:0a.0, OHCI version 1.0
> cx2388x alsa driver version 0.0.6 loaded
> cx88_audio 0000:01:0b.1: PCI INT A -> Link[APC3] -> GSI 18 (level,
low) -> IRQ 18
> cx88[0]: subsystem: 107d:665e, board: WinFast DTV2000 H
[card=51,autodetected]
> cx88[0]: TV tuner type 63, Radio tuner type -1
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> tuner' 0-0043: chip found @ 0x86 (cx88[0])
> tda9887 0-0043: creating new instance
> tda9887 0-0043: tda988[5/6/7] found
> tuner' 0-0061: chip found @ 0xc2 (cx88[0])
> tuner' 0-0063: chip found @ 0xc6 (cx88[0])
> firewire_core: created device fw0: GUID 001e8c00015bd693, S400
> tuner-simple 0-0061: creating new instance
> tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid
Tuner)
> input: cx88 IR (WinFast DTV2000 H)
as /devices/pci0000:00/0000:00:08.0/0000:01:0b.1/input/input6
> cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
> HDA Intel 0000:00:07.0: PCI INT A -> Link[AAZA] -> GSI 21 (level, low)
-> IRQ 21
> HDA Intel 0000:00:07.0: setting latency timer to 64
> cx8800 0000:01:0b.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) ->
IRQ 18
> cx88[0]/0: found at 0000:01:0b.0, rev: 5, irq: 18, latency: 32, mmio:
0xfb000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=4
(0x14/0x15/0x16/0x17/0x0)
> ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0
(0x0/0x0/0x0/0x0/0x0)
> ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=1
(0x1b/0x0/0x0/0x0/0x0)
> ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
> ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0x18, fmic=0x19,
line=0x1a, fline=0x0, cd=0x0, aux=0x0
> cx88[0]/2: cx2388x 8802 Driver Manager
> cx88-mpeg driver manager 0000:01:0b.2: PCI INT A -> Link[APC3] -> GSI
18 (level, low) -> IRQ 18
> cx88[0]/2: found at 0000:01:0b.2, rev: 5, irq: 18, latency: 32, mmio:
0xf9000000
> ACPI: PCI Interrupt Link [AE0B] enabled at IRQ 16
> HDA Intel 0000:02:00.1: PCI INT B -> Link[AE0B] -> GSI 16 (level, low)
-> IRQ 16
> HDA Intel 0000:02:00.1: setting latency timer to 64
> cx88/2: cx2388x dvb driver version 0.0.6 loaded
> cx88/2: registering cx8802 driver, type: dvb access: shared
> cx88[0]/2: subsystem: 107d:665e, board: WinFast DTV2000 H [card=51]
> cx88[0]/2: cx2388x based DVB/ATSC card
> tuner-simple 0-0061: attaching existing instance
> tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid
Tuner)
> DVB: registering new adapter (cx88[0])
> DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
> device-mapper: multipath: version 1.0.5 loaded
> EXT3 FS on dm-0, internal journal
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux: initialized (dev sda1, type ext3), uses xattr
> SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> Adding 4095992k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1
extents:1 across:4095992k
> SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses
genfs_contexts
> powernow-k8: Found 1 AMD Phenom(tm) 9550 Quad-Core Processor
processors (4 cpu cores) (version 2.20.00)
> powernow-k8:    0 : pstate 0 (2200 MHz)
> powernow-k8:    1 : pstate 1 (1100 MHz)
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> ip6_tables: (C) 2000-2006 Netfilter Core Team
> usb-storage: device scan complete
> scsi 6:0:0:0: Direct-Access     GENERIC  USB Storage-SMC  I19B PQ: 0
ANSI: 0 CCS
> scsi 6:0:0:1: Direct-Access     GENERIC  USB Storage-CFC  I19B PQ: 0
ANSI: 0 CCS
> scsi 6:0:0:2: Direct-Access     GENERIC  USB Storage-SDC  I19B PQ: 0
ANSI: 0 CCS
> scsi 6:0:0:3: Direct-Access     GENERIC  USB Storage-MSC  I19B PQ: 0
ANSI: 0 CCS
> sd 6:0:0:0: [sdb] Attached SCSI removable disk
> sd 6:0:0:0: Attached scsi generic sg2 type 0
> sd 6:0:0:1: [sdc] Attached SCSI removable disk
> sd 6:0:0:1: Attached scsi generic sg3 type 0
> sd 6:0:0:2: [sdd] Attached SCSI removable disk
> sd 6:0:0:2: Attached scsi generic sg4 type 0
> sd 6:0:0:3: [sde] Attached SCSI removable disk
> sd 6:0:0:3: Attached scsi generic sg5 type 0
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses
genfs_contexts
> Bluetooth: Core ver 2.13
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> Bluetooth: L2CAP ver 2.11
> Bluetooth: L2CAP socket layer initialized
> Bluetooth: SCO (Voice Link) ver 0.6
> Bluetooth: SCO socket layer initialized
> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Bluetooth: BNEP filters: protocol multicast
> Bridge firewalling registered
> eth0: no IPv6 routers present



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
