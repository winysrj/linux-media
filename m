Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1KTFkV-0005Nu-Mu
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 14:46:54 +0200
From: Jonathan Hummel <jhhummel@bigpond.com>
To: stev391@email.com
In-Reply-To: <20080811235939.257DA1CE825@ws1-6.us4.outblaze.com>
References: <20080811235939.257DA1CE825@ws1-6.us4.outblaze.com>
Content-Type: multipart/mixed; boundary="=-6KJWY1zr/SvBY5aNXqej"
Date: Wed, 13 Aug 2008 22:46:05 +1000
Message-Id: <1218631565.7990.13.camel@mistress>
Mime-Version: 1.0
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
	H - DVB	Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-6KJWY1zr/SvBY5aNXqej
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-08-12 at 09:59 +1000, stev391@email.com wrote:
> > ----- Original Message -----
> > From: "Jonathan Hummel" <jhhummel@bigpond.com>
> > To: stev391@email.com
> > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB	Only support
> > Date: Mon, 11 Aug 2008 23:36:25 +1000
> > 
> > 
> > On Sun, 2008-08-10 at 11:42 +1000, stev391@email.com wrote:
> > >
> > >
> > >         ----- Original Message -----
> > >         From: "Jonathan Hummel"         To: stev391@email.com
> > >         Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
> > >         3200 H - DVB Only support
> > >         Date: Sat, 09 Aug 2008 21:48:21 +1000
> > >
> > >
> > >         Hi All,
> > >
> > >         Finnaly got some time to give the patch a go. I used the
> > >         pacakges
> > >         Stephen, sent the link to, not Mark's. I cant't get past the
> > >         attached
> > >         problem. The dmesg output is attached. I tried setting the
> > >         card like
> > >         this:
> > >         /etc/modprobe.d/options file and add the line: options cx88xx
> > >         card=11
> > >         I also tried the following two varients:
> > >         cx23885 card=11
> > >         cx23885 card=12
> > >
> > >         I also got what looked like an error message when applying the
> > >         first
> > >         patch, something like "strip count 1 is not a
> > >         number" (although 1 not
> > >         being a number would explain my difficulties with maths!)
> > >
> > >         Cheers
> > >
> > >         Jon
> > >
> > >         On Wed, 2008-08-06 at 07:33 +1000, stev391@email.com wrote:
> > >         > Mark, Jon,
> > >         >
> > >         > The patches I made were not against the v4l-dvb tip that is
> > >         referenced
> > >         > in Mark's email below. I did this on purpose because there
> > >         is a small
> > >         > amount of refactoring (recoding to make it better) being
> > >         performed by
> > >         > Steven Toth and others.
> > >         >
> > >         > To get the version I used for the patch download (This is
> > >         for the
> > >         > first initial patch [you can tell it is this one as the
> > >         patch file
> > >         > mentions cx23885-sram in the path]):
> > >         > http://linuxtv.org/hg/~stoth/cx23885-sram/archive/tip.tar.gz
> > >         >
> > >         > For the second patch that emailed less then 12 hours ago
> > >         download this
> > >         > version of drivers:
> > >         > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.gz
> > >         > and then apply my patch (this patch mentions v4l-dvb). This
> > >         version is
> > >         > a cleanup of the previous and uses the generic callback
> > >         function.
> > >         >
> > >         > Other then that you are heading in the correct direction...
> > >         >
> > >         > Do either of you have the same issue I have that when the
> > >         computer is
> > >         > first turned on the autodetect card feature doesn't work due
> > >         to
> > >         > subvendor sub product ids of 0000? Or is just a faulty card
> > >         that I
> > >         > have?
> > >         >
> > >         > Regards,
> > >         >
> > >         > Stephen.
> > >         > ----- Original Message -----
> > >         > From: "Mark Carbonaro" To: "Jonathan Hummel"         > Subject: Re: 
> > > [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
> > >         > 3200 H - DVB Only support
> > >         > Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)
> > >         >
> > >         >
> > >         > Hi Mark,
> > >         >
> > >         > Forgive my ignorance/ newbie-ness, but what do I do with
> > >         that
> > >         > patch code
> > >         > below? is there a tutorial or howto or something somewhere
> > >         > that will
> > >         > introduce me to this. I have done some programming, but
> > >         > nothing of this
> > >         > level.
> > >         >
> > >         > cheers
> > >         >
> > >         > Jon
> > >         >
> > >         > ----- Original Message -----
> > >         > From: "Jonathan Hummel" To: "Mark Carbonaro"         > Cc: stev391@email.com, 
> > > linux-dvb@linuxtv.org
> > >         > Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000)
> > >         > Auto-Detected
> > >         > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
> > >         > 3200 H - DVB Only support
> > >         >
> > >         > Hi Jon,
> > >         >
> > >         > Not a problem at all, I'm new to this myself, below is what
> > >         > went through and I may not be doing it the right         > way either. So if anyone 
> > > would like to point out what I         > am doing wrong I would
> > >         > really appreciate it.
> > >         >
> > >         > The file that I downloaded was called
> > >         > v4l-dvb-2bade2ed7ac8.tar.bz2 which I downloaded         > from         > 
> > > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I
> > >         > also saved the patch to the same location as the download.
> > >         >
> > >         > The patch didn't apply for me, so I manually patched applied
> > >         > the patches and created a new diff that should         > hopefully work for
> > >         > you also (attached and inline below). From what I         > could see the offsets in 
> > > Stephens patch were a little off         > for this code
> > >         > snapshot but otherwise it is all good.
> > >         >
> > >         > I ran the following using the attached diff...
> > >         >
> > >         > tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2
> > >         > cd v4l-dvb-2bade2ed7ac8
> > >         > patch -p1 < ../Leadtek.Winfast.PxDVR.3200.H.2.diff
> > >         >
> > >         > Once the patch was applied I was then able to build and
> > >         > install the modules as per the instructions in         > the INSTALL file. I ran
> > >         > the following...
> > >         >
> > >         > make all
> > >         > sudo make install
> > >         >
> > >         > From there I could load the modules and start testing.
> > >         >
> > >         > I hope this helps you get started.
> > >         >
> > >         > Regards,
> > >         > Mark
> > >         >
> > >         >
> > >         >
> > >         >
> > >         >
> > >         >
> > >
> > >
> > > Jon,
> > >
> > > The patch did not apply correctly as the dmesg should list an extra
> > > entry in card list (number 12), and it should have autodetected.
> > >
> > > Attached is the newest copy of the patch (save this in the same
> > > directory that you use the following commands from), just to avoid
> > > confusion. Following the following:
> > > wget http://linuxtv.org/hg/~stoth/v4l-dvb/archive/2bade2ed7ac8.tar.gz
> > > tar -xf 2bade2ed7ac8.tar.gz
> > > cd v4l-dvb-2bade2ed7ac8
> > > patch -p1 <../Leadtek_Winfast_PxDVR3200_H.diff
> > > make
> > > sudo make install
> > > sudo make unload
> > > sudo modprobe cx23885
> > >
> > > Now the card should have been detected and you should
> > > have /dev/adapterN/ (where N is a number). If it hasn't been detected
> > > properly you should see a list of cards in dmesg with the card as
> > > number 12. Unload the module (sudo rmmod cx23885) and then load it
> > > with the option card=12 (sudo modprobe cx23885 card=12)
> > >
> > > For further instructions on how to watch digital tv look at the wiki
> > > page (you need to create a channels.conf).
> > >
> > > Regards,
> > > Stephen
> > >
> > > P.S.
> > > Please make sure you cc the linux dvb mailing list, so if anyone else
> > > has the same issue we can work together to solve it.
> > > Also the convention is to post your message at the bottom (I got
> > > caught by this one until recently).
> > >
> > >
> > > -- Be Yourself @ mail.com!
> > > Choose From 200+ Email Addresses
> > > Get a Free Account at www.mail.com!
> > 
> > Hi Stevhen, Mark,
> > 
> > 
> > So you write your post at the bottom of the email?! well that does
> > explain a lot, and does kinda make sense if your intending someone to
> > pick it up halfway through. I just normaly read backwards when that
> > happens to me.
> > 
> > As for the patch. I realised that it is patch -p1 (as in one) not -pl
> > (as in bLoody &*^^* i can't believe i was using the wrong character)
> > which explains why my patches never worked.
> > So the patch applied all fine and that, and dmesg looks great, but I
> > can't find anything by scanning. On my other card, the DTV2000H (rev J)
> > it can scan in MythTV to find channels, and with me-TV, I think it just
> > has a list which it picks from or something, tunes to that frequency to
> > see if there is anything there. Can't do that with this card so far.
> > Attached is the output from scan (or DVB scan) I don't know if it would
> > be useful, but I don't know what is useful for such a problem.
> > 
> > cheers
> > 
> > Jon
> 
> Jon,
> 
> I'm sorry that I'm going to have to ask some silly questions:
> * Does this card tune in windows to these frequencies?
> * If so what signal level does it report?
> * If you cannot do the above, can you double check that the aerial cable is connected correctly to your Antenna.
> 
> Can you load the following modules with debug=1:
> tuner_xc2028
> zl10353
> cx23885
> 
> and attach the dmesg sections for registering the card, and any output while scanning.
> 
> I will try this afternoon with MythTV, but my card was able to scan with the DVB scan.
> I had not heard of Me TV prior to your email, I might install that as well and see how it works.
> 
> I have a DTV1000T in the same system, from past experience this card requires a strong DVB signal while my PxDVR3200H gets drowned out with the same signal. So I have to install a 6dB or more attenuator before the card (This is due to a powered splitter installed in the roof providing too much signal, which if I remove my DTV1000T gets patchy reception). I wonder if this is the same in your case with the DTV2000H? (But if it works in windows reliably it should work in Linux).
> 
> Regards,
> Stephen.
> 

Hi Stephen,

I tired the above to no avail. The card works fine under windows (well
as fine as anything can work under windows, as in, windows keeps
stealing resources away from it resulting in jerky viewing in HD mode)
and I can scan in windows too. I still cannot scan in Linux. I've
atached the dmesg and scan outputs. (My appologies for no grep on the
dmesg, I wasn't sure what to grep for). Is there a way to grab a
frequency out of windows then dump that frequency into linux and see if
the card recieves? just a thought that it might help to debug things.

Cheers

Jon

--=-6KJWY1zr/SvBY5aNXqej
Content-Disposition: attachment; filename=tvdmesg.txt
Content-Type: text/plain; name=tvdmesg.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

sudo modprobe tuner-xc2028 debug=1
sudo modprobe zl10353  debug=1
sudo modprobe cx23885 debug=1


 sudo dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.24-20-generic (buildd@yellow) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Mon Jul 28 13:06:07 UTC 2008 (Ubuntu 2.6.24-20.38-generic)
[    0.000000] Command line: root=UUID=cbb8e362-3b0d-4a6c-8a6d-8d28288ebdf5 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfde0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfde0000 - 00000000bfde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfde3000 - 00000000bfdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfdf0000 - 00000000bfe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 785888) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 3200 used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP signature @ 0xFFFF8100000F70C0 checksum 0
[    0.000000] ACPI: RSDP 000F70C0, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT BFDE3000, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: FACP BFDE3040, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: DSDT BFDE30C0, 6550 (r1 GBT    GBTUACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS BFDE0000, 0040
[    0.000000] ACPI: SSDT BFDE9700, 030E (r1 PTLTD  POWERNOW        1  LTP        1)
[    0.000000] ACPI: HPET BFDE9A40, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
[    0.000000] ACPI: MCFG BFDE9A80, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: APIC BFDE9640, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] CPU has 2 num_cores
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 785888) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   785888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 982399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1222 pages reserved
[    0.000000]   DMA zone: 2721 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000bfde0000 - 00000000bfde3000
[    0.000000] swsusp: Registered nosave memory region: 00000000bfde3000 - 00000000bfdf0000
[    0.000000] swsusp: Registered nosave memory region: 00000000bfdf0000 - 00000000bfe00000
[    0.000000] swsusp: Registered nosave memory region: 00000000bfe00000 - 00000000e0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000e0000000 - 00000000f0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000f0000000 - 00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: bfe00000:20200000)
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PERCPU: Allocating 34656 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 964153
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=cbb8e362-3b0d-4a6c-8a6d-8d28288ebdf5 ro quiet splash
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   70.044046] Marking TSC unstable due to TSCs unsynchronized
[   70.044047] time.c: Detected 3006.395 MHz processor.
[   70.045003] Console: colour VGA+ 80x25
[   70.045005] console [tty0] enabled
[   70.045017] Checking aperture...
[   70.045019] CPU 0: aperture @ f872000000 size 32 MB
[   70.045020] Aperture too small (32 MB)
[   70.054201] No AGP bridge found
[   70.054202] Your BIOS doesn't leave a aperture memory hole
[   70.054203] Please enable the IOMMU option in the BIOS setup
[   70.054204] This costs you 64 MB of RAM
[   70.075019] Mapping aperture over 65536 KB of RAM @ 4000000
[   70.075023] swsusp: Registered nosave memory region: 0000000004000000 - 0000000008000000
[   70.099510] Memory: 3782756k/4980736k available (2489k kernel code, 146840k reserved, 1318k data, 320k init)
[   70.099535] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[   70.177791] Calibrating delay using timer specific routine.. 6017.24 BogoMIPS (lpj=12034494)
[   70.177812] Security Framework initialized
[   70.177816] SELinux:  Disabled at boot.
[   70.177825] AppArmor: AppArmor initialized
[   70.177828] Failure registering capabilities with primary security module.
[   70.178033] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   70.179750] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   70.180638] Mount-cache hash table entries: 256
[   70.180729] Initializing cgroup subsys ns
[   70.180731] Initializing cgroup subsys cpuacct
[   70.180740] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   70.180741] CPU: L2 Cache: 1024K (64 bytes/line)
[   70.180743] CPU 0/0 -> Node 0
[   70.180744] CPU: Physical Processor ID: 0
[   70.180745] CPU: Processor Core ID: 0
[   70.180761] SMP alternatives: switching to UP code
[   70.181170] Early unpacking initramfs... done
[   70.393954] ACPI: Core revision 20070126
[   70.393993] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   70.444226] Using local APIC timer interrupts.
[   70.477433] APIC timer calibration result 12526652
[   70.477435] Detected 12.526 MHz APIC timer.
[   70.477498] SMP alternatives: switching to SMP code
[   70.477804] Booting processor 1/2 APIC 0x1
[   70.487953] Initializing CPU#1
[   70.565375] Calibrating delay using timer specific routine.. 6012.80 BogoMIPS (lpj=12025613)
[   70.565379] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   70.565380] CPU: L2 Cache: 1024K (64 bytes/line)
[   70.565382] CPU 1/1 -> Node 0
[   70.565383] CPU: Physical Processor ID: 0
[   70.565384] CPU: Processor Core ID: 1
[   70.565464] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   70.565437] Brought up 2 CPUs
[   70.565549] CPU0 attaching sched-domain:
[   70.565551]  domain 0: span 03
[   70.565552]   groups: 01 02
[   70.565554]   domain 1: span 03
[   70.565555]    groups: 03
[   70.565556] CPU1 attaching sched-domain:
[   70.565557]  domain 0: span 03
[   70.565558]   groups: 02 01
[   70.565559]   domain 1: span 03
[   70.565560]    groups: 03
[   70.565702] net_namespace: 120 bytes
[   70.565969] Time: 12:23:38  Date: 08/13/08
[   70.565988] NET: Registered protocol family 16
[   70.566100] ACPI: bus type pci registered
[   70.566144] PCI: Using configuration type 1
[   70.567015] ACPI: EC: Look up EC in DSDT
[   70.570787] ACPI: Interpreter enabled
[   70.570791] ACPI: (supports S0 S1 S4 S5)
[   70.570806] ACPI: Using IOAPIC for interrupt routing
[   70.574162] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   70.575495] PCI: Transparent bridge - 0000:00:14.4
[   70.575519] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   70.575700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[   70.575773] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[   70.575832] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[   70.575888] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[   70.587702] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.587770] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.587837] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.587904] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.587972] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.588039] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.588106] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.588174] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[   70.588248] Linux Plug and Play Support v0.97 (c) Adam Belay
[   70.588264] pnp: PnP ACPI init
[   70.588269] ACPI: bus type pnp registered
[   70.590237] pnp: PnP ACPI: found 13 devices
[   70.590238] ACPI: ACPI bus type pnp unregistered
[   70.590371] PCI: Using ACPI for IRQ routing
[   70.590373] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   70.601249] NET: Registered protocol family 8
[   70.601251] NET: Registered protocol family 20
[   70.601296] PCI-DMA: Disabling AGP.
[   70.601584] PCI-DMA: aperture base @ 4000000 size 65536 KB
[   70.601587] PCI-DMA: using GART IOMMU.
[   70.601593] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   70.601730] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[   70.601733] hpet0: 4 32-bit timers, 14318180 Hz
[   70.602779] AppArmor: AppArmor Filesystem Enabled
[   70.605215] Time: hpet clocksource has been installed.
[   70.605228] Switched to high resolution mode on CPU 0
[   70.605415] Switched to high resolution mode on CPU 1
[   70.613241] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   70.613243] system 00:01: ioport range 0x220-0x225 has been reserved
[   70.613245] system 00:01: ioport range 0x290-0x294 has been reserved
[   70.613250] system 00:02: ioport range 0x4100-0x411f has been reserved
[   70.613251] system 00:02: ioport range 0x228-0x22f has been reserved
[   70.613253] system 00:02: ioport range 0x238-0x23f has been reserved
[   70.613254] system 00:02: ioport range 0x40b-0x40b has been reserved
[   70.613256] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[   70.613258] system 00:02: ioport range 0xc00-0xc01 has been reserved
[   70.613259] system 00:02: ioport range 0xc14-0xc14 has been reserved
[   70.613261] system 00:02: ioport range 0xc50-0xc52 has been reserved
[   70.613262] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[   70.613264] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[   70.613265] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[   70.613267] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[   70.613269] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[   70.613270] system 00:02: ioport range 0x4000-0x40fe has been reserved
[   70.613272] system 00:02: ioport range 0x4210-0x4217 has been reserved
[   70.613273] system 00:02: ioport range 0xb00-0xb0f has been reserved
[   70.613275] system 00:02: ioport range 0xb10-0xb1f has been reserved
[   70.613277] system 00:02: ioport range 0xb20-0xb3f has been reserved
[   70.613286] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[   70.613290] system 00:0c: iomem range 0xd1a00-0xd3fff has been reserved
[   70.613292] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[   70.613294] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[   70.613295] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[   70.613297] system 00:0c: iomem range 0xbfde0000-0xbfdfffff could not be reserved
[   70.613299] system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
[   70.613301] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   70.613303] system 00:0c: iomem range 0x100000-0xbfddffff could not be reserved
[   70.613304] system 00:0c: iomem range 0xbfef0000-0xcfeeffff has been reserved
[   70.613306] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[   70.613308] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[   70.613309] system 00:0c: iomem range 0xfff80000-0xfffeffff has been reserved
[   70.613586] PCI: Bridge: 0000:00:01.0
[   70.613588]   IO window: e000-efff
[   70.613590]   MEM window: fd900000-fdafffff
[   70.613592]   PREFETCH window: d0000000-dfffffff
[   70.613595] PCI: Bridge: 0000:00:04.0
[   70.613596]   IO window: d000-dfff
[   70.613598]   MEM window: fd600000-fd7fffff
[   70.613600]   PREFETCH window: fdf00000-fdffffff
[   70.613603] PCI: Bridge: 0000:00:0a.0
[   70.613605]   IO window: c000-cfff
[   70.613607]   MEM window: fde00000-fdefffff
[   70.613608]   PREFETCH window: fdd00000-fddfffff
[   70.613611] PCI: Bridge: 0000:00:14.4
[   70.613613]   IO window: b000-bfff
[   70.613618]   MEM window: fdc00000-fdcfffff
[   70.613621]   PREFETCH window: fdb00000-fdbfffff
[   70.613646] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
[   70.613649] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   70.613659] ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
[   70.613662] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   70.613677] NET: Registered protocol family 2
[   70.649203] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   70.650060] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[   70.653228] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   70.653718] TCP: Hash tables configured (established 524288 bind 65536)
[   70.653720] TCP reno registered
[   70.665199] checking if image is initramfs... it is
[   71.087597] Freeing initrd memory: 7968k freed
[   71.091666] audit: initializing netlink socket (disabled)
[   71.091674] audit(1218630219.016:1): initialized
[   71.093015] VFS: Disk quotas dquot_6.5.1
[   71.093059] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   71.093143] io scheduler noop registered
[   71.093144] io scheduler anticipatory registered
[   71.093146] io scheduler deadline registered
[   71.093213] io scheduler cfq registered (default)
[   71.232213] Boot video device is 0000:01:05.0
[   71.232338] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   71.232358] assign_interrupt_mode Found MSI capability
[   71.232380] Allocate Port Service[0000:00:04.0:pcie00]
[   71.232428] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   71.232447] assign_interrupt_mode Found MSI capability
[   71.232464] Allocate Port Service[0000:00:0a.0:pcie00]
[   71.249628] Real Time Clock Driver v1.12ac
[   71.249751] hpet_resources: 0xfed00000 is busy
[   71.249772] Linux agpgart interface v0.102
[   71.249773] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   71.249898] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   71.250299] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   71.250763] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   71.250805] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[   71.250886] PNP: No PS/2 controller found. Probing ports directly.
[   71.251338] serio: i8042 KBD port at 0x60,0x64 irq 1
[   71.251345] serio: i8042 AUX port at 0x60,0x64 irq 12
[   71.268653] mice: PS/2 mouse device common for all mice
[   71.268683] cpuidle: using governor ladder
[   71.268685] cpuidle: using governor menu
[   71.268780] NET: Registered protocol family 1
[   71.268851] registered taskstats version 1
[   71.268937]   Magic number: 4:84:380
[   71.269025] /build/buildd/linux-2.6.24/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   71.269027] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   71.269028] EDD information not available.
[   71.269036] Freeing unused kernel memory: 320k freed
[   72.382614] fuse init (API version 7.9)
[   72.394681] ACPI Exception (processor_core-0822): AE_NOT_FOUND, Processor Device is not present [20070126]
[   72.394689] ACPI Exception (processor_core-0822): AE_NOT_FOUND, Processor Device is not present [20070126]
[   72.586902] SCSI subsystem initialized
[   72.644149] usbcore: registered new interface driver usbfs
[   72.644164] usbcore: registered new interface driver hub
[   72.644812] usbcore: registered new device driver usb
[   72.644868] r8169 Gigabit Ethernet driver 2.2LK loaded
[   72.644887] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[   72.644903] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   72.645077] eth0: RTL8168c/8111c at 0xffffc20001032000, 00:1f:d0:59:0e:66, XID 3c4000c0 IRQ 509
[   72.649330] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   72.649334] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   72.649759] libata version 3.00 loaded.
[   72.649801] ATIIXP: IDE controller (0x1002:0x439c rev 0x00) at  PCI slot 0000:00:14.1
[   72.649813] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   72.649821] ATIIXP: not 100% native mode: will probe irqs later
[   72.649828]     ide0: BM-DMA at 0xfa00-0xfa07, BIOS settings: hda:pio, hdb:pio
[   72.649846] ATIIXP: simplex device: DMA disabled
[   72.649847] ide1: ATIIXP Bus-Master DMA disabled (BIOS)
[   72.649850] Probing IDE interface ide0...
[   72.665729] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   72.681674] Floppy drive(s): fd0 is 1.44M
[   72.701204] FDC 0 is a post-1991 82077
[   73.216429] Probing IDE interface ide1...
[   73.776969] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
[   73.777197] ohci_hcd 0000:00:12.0: OHCI Host Controller
[   73.777390] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 1
[   73.777411] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[   73.835374] usb usb1: configuration #1 chosen from 1 choice
[   73.835389] hub 1-0:1.0: USB hub found
[   73.835397] hub 1-0:1.0: 3 ports detected
[   73.939150] ACPI: PCI Interrupt 0000:00:12.1[A] -> GSI 16 (level, low) -> IRQ 16
[   73.939339] ohci_hcd 0000:00:12.1: OHCI Host Controller
[   73.939389] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 2
[   73.939404] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[   73.999064] usb usb2: configuration #1 chosen from 1 choice
[   73.999078] hub 2-0:1.0: USB hub found
[   73.999085] hub 2-0:1.0: 3 ports detected
[   74.102845] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 18 (level, low) -> IRQ 18
[   74.103015] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   74.103064] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 3
[   74.103087] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[   74.162768] usb usb3: configuration #1 chosen from 1 choice
[   74.162782] hub 3-0:1.0: USB hub found
[   74.162789] hub 3-0:1.0: 3 ports detected
[   74.266534] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 18 (level, low) -> IRQ 18
[   74.266709] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   74.266761] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 4
[   74.266777] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[   74.326463] usb usb4: configuration #1 chosen from 1 choice
[   74.326477] hub 4-0:1.0: USB hub found
[   74.326485] hub 4-0:1.0: 3 ports detected
[   74.418214] usb 2-1: new low speed USB device using ohci_hcd and address 2
[   74.430239] ACPI: PCI Interrupt 0000:00:14.5[C] -> GSI 18 (level, low) -> IRQ 18
[   74.430411] ohci_hcd 0000:00:14.5: OHCI Host Controller
[   74.430460] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 5
[   74.430476] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[   74.490164] usb usb5: configuration #1 chosen from 1 choice
[   74.490179] hub 5-0:1.0: USB hub found
[   74.490186] hub 5-0:1.0: 2 ports detected
[   74.594007] ahci 0000:00:11.0: version 3.0
[   74.594035] ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 22 (level, low) -> IRQ 22
[   74.594255] ahci 0000:00:11.0: controller can't do PMP, turning off CAP_PMP
[   74.639049] usb 2-1: configuration #1 chosen from 1 choice
[   74.949329] usb 2-2: new full speed USB device using ohci_hcd and address 3
[   75.170118] usb 2-2: configuration #1 chosen from 1 choice
[   75.172052] usbcore: registered new interface driver hiddev
[   75.177168] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb2/2-1/2-1:1.0/input/input1
[   75.205388] input,hidraw0: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-1
[   75.211983] Fixing up Logitech keyboard report descriptor
[   75.212331] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb2/2-1/2-1:1.1/input/input2
[   75.241318] input,hiddev96,hidraw1: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-1
[   75.241333] usbcore: registered new interface driver usbhid
[   75.241336] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   75.241267] usbcore: registered new interface driver libusual
[   75.244185] Initializing USB Mass Storage driver...
[   75.244279] scsi0 : SCSI emulation for USB Mass Storage devices
[   75.244317] usbcore: registered new interface driver usb-storage
[   75.244319] USB Mass Storage support registered.
[   75.244388] usb-storage: device found at 3
[   75.244390] usb-storage: waiting for device to settle before scanning
[   75.596095] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   75.596099] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pio slum part
[   75.596404] scsi1 : ahci
[   75.596452] scsi2 : ahci
[   75.596476] scsi3 : ahci
[   75.596499] scsi4 : ahci
[   75.596522] scsi5 : ahci
[   75.596545] scsi6 : ahci
[   75.596604] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 508
[   75.596606] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 508
[   75.596609] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 508
[   75.596612] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 508
[   75.596615] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 508
[   75.596618] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 508
[   76.071180] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   76.083918] ata1.00: HPA unlocked: 1465147055 -> 1465149168, native 1465149168
[   76.083922] ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[   76.083924] ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   76.090297] ata1.00: configured for UDMA/133
[   76.562278] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   76.568701] ata2.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[   76.568703] ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   76.575085] ata2.00: configured for UDMA/133
[   77.049381] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   77.055800] ata3.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[   77.055802] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   77.062180] ata3.00: configured for UDMA/133
[   77.372782] ata4: SATA link down (SStatus 0 SControl 300)
[   77.847911] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   78.003987] ata5.00: ATAPI: ASUS    DRW-2014L1T, 1.00, max UDMA/66, ATAPI AN
[   78.159716] ata5.00: configured for UDMA/66
[   78.470762] ata6: SATA link down (SStatus 0 SControl 300)
[   78.470834] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   78.470899] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   78.470956] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   78.471350] scsi 5:0:0:0: CD-ROM            ASUS     DRW-2014L1T      1.00 PQ: 0 ANSI: 5
[   78.471536] ACPI: PCI Interrupt 0000:00:12.2[B] -> GSI 17 (level, low) -> IRQ 17
[   78.471774] ehci_hcd 0000:00:12.2: EHCI Host Controller
[   78.471820] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 6
[   78.471855] ehci_hcd 0000:00:12.2: debug port 1
[   78.471871] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[   78.471918] usb 2-1: USB disconnect, address 2
[   78.477058] Driver 'sd' needs updating - please use bus_type methods
[   78.483015] Driver 'sr' needs updating - please use bus_type methods
[   78.483329] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   78.483412] usb usb6: configuration #1 chosen from 1 choice
[   78.483428] hub 6-0:1.0: USB hub found
[   78.483434] hub 6-0:1.0: 6 ports detected
[   78.487275] sd 1:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[   78.487284] sd 1:0:0:0: [sda] Write Protect is off
[   78.487286] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   78.487295] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   78.487331] sd 1:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[   78.487336] sd 1:0:0:0: [sda] Write Protect is off
[   78.487337] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   78.487345] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   78.487348]  sda: sda1 sda2 sda3
[   78.497363] sd 1:0:0:0: [sda] Attached SCSI disk
[   78.497404] sd 2:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[   78.497412] sd 2:0:0:0: [sdb] Write Protect is off
[   78.497414] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   78.497424] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   78.497454] sd 2:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[   78.497460] sd 2:0:0:0: [sdb] Write Protect is off
[   78.497461] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   78.497477] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   78.497479]  sdb: sdb1
[   78.510716] sd 2:0:0:0: [sdb] Attached SCSI disk
[   78.510741] sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
[   78.510747] sd 3:0:0:0: [sdc] Write Protect is off
[   78.510749] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   78.510758] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   78.510778] sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
[   78.510784] sd 3:0:0:0: [sdc] Write Protect is off
[   78.510785] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   78.510796] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   78.510798]  sdc: sdc1
[   78.519943] sd 3:0:0:0: [sdc] Attached SCSI disk
[   78.524321] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   78.524336] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   78.524350] sd 3:0:0:0: Attached scsi generic sg2 type 0
[   78.524361] sr 5:0:0:0: Attached scsi generic sg3 type 5
[   78.528372] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   78.528377] Uniform CD-ROM driver Revision: 3.20
[   78.528406] sr 5:0:0:0: Attached scsi CD-ROM sr0
[   78.587221] ACPI: PCI Interrupt 0000:00:13.2[B] -> GSI 19 (level, low) -> IRQ 19
[   78.587462] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   78.587513] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 7
[   78.587548] ehci_hcd 0000:00:13.2: debug port 1
[   78.587564] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[   78.599112] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   78.599203] usb usb7: configuration #1 chosen from 1 choice
[   78.599219] hub 7-0:1.0: USB hub found
[   78.599225] hub 7-0:1.0: 6 ports detected
[   78.682965] usb 2-2: USB disconnect, address 3
[   78.702963] ACPI: PCI Interrupt 0000:04:0e.0[A] -> GSI 22 (level, low) -> IRQ 22
[   78.753037] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fdcff000-fdcff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   78.799753] kjournald starting.  Commit interval 5 seconds
[   78.799761] EXT3-fs: mounted filesystem with ordered data mode.
[   79.237945] usb 6-5: new high speed USB device using ehci_hcd and address 3
[   79.373001] usb 6-5: configuration #1 chosen from 1 choice
[   79.373122] scsi7 : SCSI emulation for USB Mass Storage devices
[   79.373195] usb-storage: device found at 3
[   79.373197] usb-storage: waiting for device to settle before scanning
[   79.689105] usb 2-1: new low speed USB device using ohci_hcd and address 4
[   79.908836] usb 2-1: configuration #1 chosen from 1 choice
[   79.915901] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb2/2-1/2-1:1.0/input/input3
[   79.924687] input,hidraw0: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-1
[   79.931733] Fixing up Logitech keyboard report descriptor
[   79.932071] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb2/2-1/2-1:1.1/input/input4
[   79.968629] input,hiddev96,hidraw1: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-1
[   80.024570] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007196ad00001fd0]
[   84.293537] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   84.411658] shpchp: HPC vendor_id 1022 device_id 9602 ss_vid 0 ss_did 0
[   84.411662] shpchp: shpc_init: cannot reserve MMIO region
[   84.411681] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   84.420503] usb-storage: device scan complete
[   84.421591] scsi 7:0:0:0: Direct-Access     Imation  Nano             PMAP PQ: 0 ANSI: 0 CCS
[   84.423698] sd 7:0:0:0: [sdd] 4028416 512-byte hardware sectors (2063 MB)
[   84.424363] sd 7:0:0:0: [sdd] Write Protect is off
[   84.424365] sd 7:0:0:0: [sdd] Mode Sense: 23 00 00 00
[   84.424367] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[   84.426971] sd 7:0:0:0: [sdd] 4028416 512-byte hardware sectors (2063 MB)
[   84.427596] sd 7:0:0:0: [sdd] Write Protect is off
[   84.427597] sd 7:0:0:0: [sdd] Mode Sense: 23 00 00 00
[   84.427599] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[   84.427601]  sdd: sdd1
[   84.428873] sd 7:0:0:0: [sdd] Attached SCSI removable disk
[   84.429133] sd 7:0:0:0: Attached scsi generic sg4 type 0
[   84.445807] parport_pc 00:0a: reported by Plug and Play ACPI
[   84.445865] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   84.452161] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   84.619194] input: Power Button (FF) as /devices/virtual/input/input6
[   84.661039] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[   84.671974] ACPI: Power Button (FF) [PWRF]
[   84.672015] input: Power Button (CM) as /devices/virtual/input/input7
[   84.735876] ACPI: Power Button (CM) [PWRB]
[   84.735934] ACPI: WMI-Acer: Mapper loaded
[   84.905432] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   84.941971] [fglrx] Maximum main memory to use for locked dma buffers: 3544 MBytes.
[   84.941993] [fglrx] ASYNCIO init succeed!
[   84.942270] [fglrx] PAT is enabled successfully!
[   84.942289] [fglrx] module loaded - fglrx 8.47.3 [Feb 25 2008] on minor 0
[   85.166061] Linux video capture interface: v2.00
[   85.221436] cx23885 driver version 0.0.1 loaded
[   85.221502] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   85.221514] CORE cx23885[0]: subsystem: 107d:6681, board: Leadtek Winfast PxDVR3200 H [card=11,autodetected]
[   85.408979] cx23885[0]: i2c bus 0 registered
[   85.408999] cx23885[0]: i2c bus 1 registered
[   85.409020] cx23885[0]: i2c bus 2 registered
[   85.477712] cx25840' 3-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   85.478082] cx23885[0]: cx23885 based dvb card
[   85.555823] xc2028 2-0061: creating new instance
[   85.555827] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   85.555830] DVB: registering new adapter (cx23885[0])
[   85.555833] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   85.555994] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   85.556000] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfd600000
[   85.556007] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   85.556114] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
[   85.589034] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[   85.624431] ACPI: PCI Interrupt 0000:01:05.1[B] -> GSI 19 (level, low) -> IRQ 19
[   85.624615] PCI: Setting latency timer of device 0000:01:05.1 to 64
[   86.685659] lp0: using parport0 (interrupt-driven).
[   86.779958] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   86.781434] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   86.781437] cx88/2: registering cx8802 driver, type: dvb access: shared
[   86.818959] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   87.376100] EXT3 FS on sda1, internal journal
[   87.460263] device-mapper: uevent: version 1.0.3
[   87.460286] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[   88.571761] ip_tables: (C) 2000-2006 Netfilter Core Team
[   88.796846] No dock devices found.
[   89.058971] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[   89.059023] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   89.059026] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   89.059027] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   89.059029] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   89.059030] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   89.059031] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   89.059032] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   89.059033] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   91.390948] ppdev: user-space parallel port driver
[   91.674553] audit(1218630240.063:2): type=1503 operation="inode_permission" requested_mask="a::" denied_mask="a::" name="/dev/tty" pid=5632 profile="/usr/sbin/cupsd"namespace="default"
[   92.421456] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   92.421462] vboxdrv: Successfully done.
[   92.421502] vboxdrv: TSC mode is 'asynchronous', kernel timer mode is 'normal'.
[   92.421504] vboxdrv: Successfully loaded version 1.5.6_OSE (interface 0x00050002).
[   93.205729] NET: Registered protocol family 10
[   93.205896] lo: Disabled Privacy Extensions
[   93.346422] Clocksource tsc unstable (delta = -189094048 ns)
[   93.901648] r8169: eth0: link up
[   93.901636] r8169: eth0: link up
[   94.374573] Bluetooth: Core ver 2.11
[   94.374739] NET: Registered protocol family 31
[   94.374741] Bluetooth: HCI device and connection manager initialized
[   94.374744] Bluetooth: HCI socket layer initialized
[   94.390951] Bluetooth: L2CAP ver 2.9
[   94.390954] Bluetooth: L2CAP socket layer initialized
[   94.437901] Bluetooth: RFCOMM socket layer initialized
[   94.438026] Bluetooth: RFCOMM TTY layer initialized
[   94.438028] Bluetooth: RFCOMM ver 1.8
[   94.653135] NET: Registered protocol family 17
[   95.447834] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 18 (level, low) -> IRQ 18
[   95.914757] [fglrx] GART Table is not in FRAME_BUFFER range
[   95.914762] [fglrx] Reserve Block - 0 offset =  0Xfffc000 length = 0X4000
[   95.914764] [fglrx] Reserve Block - 1 offset =  0X0 length = 0X1000000
[   95.967853] [fglrx] interrupt source ff000034 successfully enabled
[   95.967857] [fglrx] enable ID = 0x00000006
[   95.967862] [fglrx] Receive enable interrupt message with irqEnableMask: ff000034
[   95.967898] [fglrx] interrupt source 10000000 successfully enabled
[   95.967899] [fglrx] enable ID = 0x00000007
[   95.967902] [fglrx] Receive enable interrupt message with irqEnableMask: 10000000
[   99.585971] eth0: no IPv6 routers present
[  115.370780] hda-intel: Invalid position buffer, using LPIB read method instead.
--=-6KJWY1zr/SvBY5aNXqej
Content-Disposition: attachment; filename="tv scan.txt"
Content-Type: text/plain; name="tv scan.txt"; charset=utf-8
Content-Transfer-Encoding: 7bit

:/usr/share/doc/dvb-utils/examples/scan/dvb-t$ sudo scan au-Sydney_North_Shore
scanning au-Sydney_North_Shore
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 2 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 571500000 1 2 9 3 1 2 0
initial transponder 578500000 1 2 9 3 1 0 0
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 578500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 578500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.
--=-6KJWY1zr/SvBY5aNXqej
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-6KJWY1zr/SvBY5aNXqej--
