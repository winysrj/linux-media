Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1KTar3-0004m1-3H
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 13:19:02 +0200
From: Jonathan Hummel <jhhummel@bigpond.com>
To: stev391@email.com
In-Reply-To: <20080813214929.3126932675A@ws1-8.us4.outblaze.com>
References: <20080813214929.3126932675A@ws1-8.us4.outblaze.com>
Content-Type: multipart/mixed; boundary="=-v57m+M2SYUZvIa+86xv8"
Date: Thu, 14 Aug 2008 21:18:17 +1000
Message-Id: <1218712697.9451.2.camel@mistress>
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


--=-v57m+M2SYUZvIa+86xv8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2008-08-14 at 07:49 +1000, stev391@email.com wrote:
> > ----- Original Message -----
> > From: "Jonathan Hummel" <jhhummel@bigpond.com>
> > To: stev391@email.com
> > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB	Only support
> > Date: Wed, 13 Aug 2008 22:46:05 +1000
> > 
> > 
> > On Tue, 2008-08-12 at 09:59 +1000, stev391@email.com wrote:
> > > > ----- Original Message -----
> > > > From: "Jonathan Hummel" <jhhummel@bigpond.com>
> > > > To: stev391@email.com
> > > > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB	Only support
> > > > Date: Mon, 11 Aug 2008 23:36:25 +1000
> > > > > > On Sun, 2008-08-10 at 11:42 +1000, stev391@email.com wrote:
> > > > >
> > > > >
> > > > >         ----- Original Message -----
> > > > >         From: "Jonathan Hummel"         To: stev391@email.com
> > > > >         Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
> > > > >         3200 H - DVB Only support
> > > > >         Date: Sat, 09 Aug 2008 21:48:21 +1000
> > > > >
> > > > >
> > > > >         Hi All,
> > > > >
> > > > >         Finnaly got some time to give the patch a go. I used the
> > > > >         pacakges
> > > > >         Stephen, sent the link to, not Mark's. I cant't get past the
> > > > >         attached
> > > > >         problem. The dmesg output is attached. I tried setting the
> > > > >         card like
> > > > >         this:
> > > > >         /etc/modprobe.d/options file and add the line: options cx88xx
> > > > >         card=11
> > > > >         I also tried the following two varients:
> > > > >         cx23885 card=11
> > > > >         cx23885 card=12
> > > > >
> > > > >         I also got what looked like an error message when applying the
> > > > >         first
> > > > >         patch, something like "strip count 1 is not a
> > > > >         number" (although 1 not
> > > > >         being a number would explain my difficulties with maths!)
> > > > >
> > > > >         Cheers
> > > > >
> > > > >         Jon
> > > > >
> > > > >         On Wed, 2008-08-06 at 07:33 +1000, stev391@email.com wrote:
> > > > >         > Mark, Jon,
> > > > >         >
> > > > >         > The patches I made were not against the v4l-dvb tip that is
> > > > >         referenced
> > > > >         > in Mark's email below. I did this on purpose because there
> > > > >         is a small
> > > > >         > amount of refactoring (recoding to make it better) being
> > > > >         performed by
> > > > >         > Steven Toth and others.
> > > > >         >
> > > > >         > To get the version I used for the patch download (This is
> > > > >         for the
> > > > >         > first initial patch [you can tell it is this one as the
> > > > >         patch file
> > > > >         > mentions cx23885-sram in the path]):
> > > > >         > http://linuxtv.org/hg/~stoth/cx23885-sram/archive/tip.tar.gz
> > > > >         >
> > > > >         > For the second patch that emailed less then 12 hours ago
> > > > >         download this
> > > > >         > version of drivers:
> > > > >         > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.gz
> > > > >         > and then apply my patch (this patch mentions v4l-dvb). This
> > > > >         version is
> > > > >         > a cleanup of the previous and uses the generic callback
> > > > >         function.
> > > > >         >
> > > > >         > Other then that you are heading in the correct direction...
> > > > >         >
> > > > >         > Do either of you have the same issue I have that when the
> > > > >         computer is
> > > > >         > first turned on the autodetect card feature doesn't work due
> > > > >         to
> > > > >         > subvendor sub product ids of 0000? Or is just a faulty card
> > > > >         that I
> > > > >         > have?
> > > > >         >
> > > > >         > Regards,
> > > > >         >
> > > > >         > Stephen.
> > > > >         > ----- Original Message -----
> > > > >         > From: "Mark Carbonaro" To: "Jonathan Hummel"         > Subject: Re: > > 
> > > [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
> > > > >         > 3200 H - DVB Only support
> > > > >         > Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)
> > > > >         >
> > > > >         >
> > > > >         > Hi Mark,
> > > > >         >
> > > > >         > Forgive my ignorance/ newbie-ness, but what do I do with
> > > > >         that
> > > > >         > patch code
> > > > >         > below? is there a tutorial or howto or something somewhere
> > > > >         > that will
> > > > >         > introduce me to this. I have done some programming, but
> > > > >         > nothing of this
> > > > >         > level.
> > > > >         >
> > > > >         > cheers
> > > > >         >
> > > > >         > Jon
> > > > >         >
> > > > >         > ----- Original Message -----
> > > > >         > From: "Jonathan Hummel" To: "Mark Carbonaro"         > Cc: stev391@email.com, > 
> > > > linux-dvb@linuxtv.org
> > > > >         > Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000)
> > > > >         > Auto-Detected
> > > > >         > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
> > > > >         > 3200 H - DVB Only support
> > > > >         >
> > > > >         > Hi Jon,
> > > > >         >
> > > > >         > Not a problem at all, I'm new to this myself, below is what
> > > > >         > went through and I may not be doing it the right         > way either. So if 
> > > anyone > > would like to point out what I         > am doing wrong I would
> > > > >         > really appreciate it.
> > > > >         >
> > > > >         > The file that I downloaded was called
> > > > >         > v4l-dvb-2bade2ed7ac8.tar.bz2 which I downloaded         > from         > > > 
> > > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I
> > > > >         > also saved the patch to the same location as the download.
> > > > >         >
> > > > >         > The patch didn't apply for me, so I manually patched applied
> > > > >         > the patches and created a new diff that should         > hopefully work for
> > > > >         > you also (attached and inline below). From what I         > could see the 
> > > offsets in > > Stephens patch were a little off         > for this code
> > > > >         > snapshot but otherwise it is all good.
> > > > >         >
> > > > >         > I ran the following using the attached diff...
> > > > >         >
> > > > >         > tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2
> > > > >         > cd v4l-dvb-2bade2ed7ac8
> > > > >         > patch -p1 < ../Leadtek.Winfast.PxDVR.3200.H.2.diff
> > > > >         >
> > > > >         > Once the patch was applied I was then able to build and
> > > > >         > install the modules as per the instructions in         > the INSTALL file. I ran
> > > > >         > the following...
> > > > >         >
> > > > >         > make all
> > > > >         > sudo make install
> > > > >         >
> > > > >         > From there I could load the modules and start testing.
> > > > >         >
> > > > >         > I hope this helps you get started.
> > > > >         >
> > > > >         > Regards,
> > > > >         > Mark
> > > > >         >
> > > > >         >
> > > > >         >
> > > > >         >
> > > > >         >
> > > > >         >
> > > > >
> > > > >
> > > > > Jon,
> > > > >
> > > > > The patch did not apply correctly as the dmesg should list an extra
> > > > > entry in card list (number 12), and it should have autodetected.
> > > > >
> > > > > Attached is the newest copy of the patch (save this in the same
> > > > > directory that you use the following commands from), just to avoid
> > > > > confusion. Following the following:
> > > > > wget http://linuxtv.org/hg/~stoth/v4l-dvb/archive/2bade2ed7ac8.tar.gz
> > > > > tar -xf 2bade2ed7ac8.tar.gz
> > > > > cd v4l-dvb-2bade2ed7ac8
> > > > > patch -p1 <../Leadtek_Winfast_PxDVR3200_H.diff
> > > > > make
> > > > > sudo make install
> > > > > sudo make unload
> > > > > sudo modprobe cx23885
> > > > >
> > > > > Now the card should have been detected and you should
> > > > > have /dev/adapterN/ (where N is a number). If it hasn't been detected
> > > > > properly you should see a list of cards in dmesg with the card as
> > > > > number 12. Unload the module (sudo rmmod cx23885) and then load it
> > > > > with the option card=12 (sudo modprobe cx23885 card=12)
> > > > >
> > > > > For further instructions on how to watch digital tv look at the wiki
> > > > > page (you need to create a channels.conf).
> > > > >
> > > > > Regards,
> > > > > Stephen
> > > > >
> > > > > P.S.
> > > > > Please make sure you cc the linux dvb mailing list, so if anyone else
> > > > > has the same issue we can work together to solve it.
> > > > > Also the convention is to post your message at the bottom (I got
> > > > > caught by this one until recently).
> > > > >
> > > > >
> > > > > -- Be Yourself @ mail.com!
> > > > > Choose From 200+ Email Addresses
> > > > > Get a Free Account at www.mail.com!
> > > > > Hi Stevhen, Mark,
> > > > > > So you write your post at the bottom of the email?! well that does
> > > > explain a lot, and does kinda make sense if your intending someone to
> > > > pick it up halfway through. I just normaly read backwards when that
> > > > happens to me.
> > > > > As for the patch. I realised that it is patch -p1 (as in one) not -pl
> > > > (as in bLoody &*^^* i can't believe i was using the wrong character)
> > > > which explains why my patches never worked.
> > > > So the patch applied all fine and that, and dmesg looks great, but I
> > > > can't find anything by scanning. On my other card, the DTV2000H (rev J)
> > > > it can scan in MythTV to find channels, and with me-TV, I think it just
> > > > has a list which it picks from or something, tunes to that frequency to
> > > > see if there is anything there. Can't do that with this card so far.
> > > > Attached is the output from scan (or DVB scan) I don't know if it would
> > > > be useful, but I don't know what is useful for such a problem.
> > > > > cheers
> > > > > Jon
> > >
> > > Jon,
> > >
> > > I'm sorry that I'm going to have to ask some silly questions:
> > > * Does this card tune in windows to these frequencies?
> > > * If so what signal level does it report?
> > > * If you cannot do the above, can you double check that the aerial cable is connected 
> > > correctly to your Antenna.
> > >
> > > Can you load the following modules with debug=1:
> > > tuner_xc2028
> > > zl10353
> > > cx23885
> > >
> > > and attach the dmesg sections for registering the card, and any output while scanning.
> > >
> > > I will try this afternoon with MythTV, but my card was able to scan with the DVB scan.
> > > I had not heard of Me TV prior to your email, I might install that as well and see how it 
> > > works.
> > >
> > > I have a DTV1000T in the same system, from past experience this card requires a strong DVB 
> > > signal while my PxDVR3200H gets drowned out with the same signal. So I have to install a 6dB 
> > > or more attenuator before the card (This is due to a powered splitter installed in the roof 
> > > providing too much signal, which if I remove my DTV1000T gets patchy reception). I wonder if 
> > > this is the same in your case with the DTV2000H? (But if it works in windows reliably it 
> > > should work in Linux).
> > >
> > > Regards,
> > > Stephen.
> > >
> > 
> > Hi Stephen,
> > 
> > I tired the above to no avail. The card works fine under windows (well
> > as fine as anything can work under windows, as in, windows keeps
> > stealing resources away from it resulting in jerky viewing in HD mode)
> > and I can scan in windows too. I still cannot scan in Linux. I've
> > atached the dmesg and scan outputs. (My appologies for no grep on the
> > dmesg, I wasn't sure what to grep for). Is there a way to grab a
> > frequency out of windows then dump that frequency into linux and see if
> > the card recieves? just a thought that it might help to debug things.
> > 
> > Cheers
> > 
> > Jon
> 
> Jon,
> 
> The relevant sections of the dmesg will be everything from this line onwards:
> cx23885 driver version 0.0.1 loaded
> 
> The section I was looking for wasn't in the dmesg.  Please attempt the scan then give the dmesg output after this. (I think you gave me the reverse)
> What I'm looking for is if the firmware loads correctly and what error messages.
> 
> Also if you haven't done so already can you ensure that the modules mentioned above are loaded with debug=1.
> On ubuntu this performed in /etc/modprobe.../options with the following lines (modprobe or something similar):
> options zl10353 debug=1
> options tuner_xc2038 debug=1
> options cx23885 debug=1
> 
> The either restart or reload these modules.
> Note this will generate a lot of messages, so when not testing the card put a "#" in front of it to comment it out.
> 
> Regards,
> Stephen
> 
> 
> -- 
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com
> 
Hi Stephen

Turns out that if you use that patch that allows you to use your linux
drive from windows doesn't recognise user permisions. Made editing
modprobe options easier seeing it was already loaded :)
Yes I did think I did it in reverse, her it is in the order you wanted.
Seems to be an issue with the Zarlink chip.

Thanks

Jon

--=-v57m+M2SYUZvIa+86xv8
Content-Disposition: attachment; filename="tv dmesg2.txt"
Content-Type: text/plain; name="tv dmesg2.txt"; charset=utf-8
Content-Transfer-Encoding: 7bit

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
[  605.065809] Marking TSC unstable due to TSCs unsynchronized
[  605.065811] time.c: Detected 3006.421 MHz processor.
[  605.066764] Console: colour VGA+ 80x25
[  605.066766] console [tty0] enabled
[  605.066778] Checking aperture...
[  605.066780] CPU 0: aperture @ f072000000 size 32 MB
[  605.066781] Aperture too small (32 MB)
[  605.075962] No AGP bridge found
[  605.075963] Your BIOS doesn't leave a aperture memory hole
[  605.075964] Please enable the IOMMU option in the BIOS setup
[  605.075965] This costs you 64 MB of RAM
[  605.096776] Mapping aperture over 65536 KB of RAM @ 4000000
[  605.096780] swsusp: Registered nosave memory region: 0000000004000000 - 0000000008000000
[  605.121252] Memory: 3782756k/4980736k available (2489k kernel code, 146840k reserved, 1318k data, 320k init)
[  605.121277] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[  605.199553] Calibrating delay using timer specific routine.. 6017.21 BogoMIPS (lpj=12034427)
[  605.199578] Security Framework initialized
[  605.199582] SELinux:  Disabled at boot.
[  605.199592] AppArmor: AppArmor initialized
[  605.199595] Failure registering capabilities with primary security module.
[  605.199802] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[  605.201564] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[  605.202453] Mount-cache hash table entries: 256
[  605.202544] Initializing cgroup subsys ns
[  605.202546] Initializing cgroup subsys cpuacct
[  605.202554] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  605.202556] CPU: L2 Cache: 1024K (64 bytes/line)
[  605.202557] CPU 0/0 -> Node 0
[  605.202559] CPU: Physical Processor ID: 0
[  605.202560] CPU: Processor Core ID: 0
[  605.202575] SMP alternatives: switching to UP code
[  605.202984] Early unpacking initramfs... done
[  605.415763] ACPI: Core revision 20070126
[  605.415801] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[  605.466031] Using local APIC timer interrupts.
[  605.499239] APIC timer calibration result 12526759
[  605.499240] Detected 12.526 MHz APIC timer.
[  605.499303] SMP alternatives: switching to SMP code
[  605.499609] Booting processor 1/2 APIC 0x1
[  605.511287] Initializing CPU#1
[  605.588710] Calibrating delay using timer specific routine.. 6012.92 BogoMIPS (lpj=12025852)
[  605.588714] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  605.588716] CPU: L2 Cache: 1024K (64 bytes/line)
[  605.588717] CPU 1/1 -> Node 0
[  605.588719] CPU: Physical Processor ID: 0
[  605.588720] CPU: Processor Core ID: 1
[  605.588800] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[  605.587242] Brought up 2 CPUs
[  605.587354] CPU0 attaching sched-domain:
[  605.587355]  domain 0: span 03
[  605.587357]   groups: 01 02
[  605.587358]   domain 1: span 03
[  605.587359]    groups: 03
[  605.587360] CPU1 attaching sched-domain:
[  605.587361]  domain 0: span 03
[  605.587362]   groups: 02 01
[  605.587364]   domain 1: span 03
[  605.587364]    groups: 03
[  605.587507] net_namespace: 120 bytes
[  605.587775] Time: 10:42:09  Date: 08/14/08
[  605.587793] NET: Registered protocol family 16
[  605.587906] ACPI: bus type pci registered
[  605.587950] PCI: Using configuration type 1
[  605.588821] ACPI: EC: Look up EC in DSDT
[  605.592592] ACPI: Interpreter enabled
[  605.592597] ACPI: (supports S0 S1 S4 S5)
[  605.592612] ACPI: Using IOAPIC for interrupt routing
[  605.595969] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  605.597300] PCI: Transparent bridge - 0000:00:14.4
[  605.597324] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[  605.597505] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[  605.597579] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[  605.597638] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[  605.597693] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[  605.609509] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.609577] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.609645] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.609712] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.609779] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.609846] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.609914] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.609981] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[  605.610055] Linux Plug and Play Support v0.97 (c) Adam Belay
[  605.610072] pnp: PnP ACPI init
[  605.610076] ACPI: bus type pnp registered
[  605.612044] pnp: PnP ACPI: found 13 devices
[  605.612045] ACPI: ACPI bus type pnp unregistered
[  605.612180] PCI: Using ACPI for IRQ routing
[  605.612182] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[  605.623057] NET: Registered protocol family 8
[  605.623058] NET: Registered protocol family 20
[  605.623104] PCI-DMA: Disabling AGP.
[  605.623394] PCI-DMA: aperture base @ 4000000 size 65536 KB
[  605.623397] PCI-DMA: using GART IOMMU.
[  605.623403] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[  605.623539] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[  605.623542] hpet0: 4 32-bit timers, 14318180 Hz
[  605.624588] AppArmor: AppArmor Filesystem Enabled
[  605.627022] Time: hpet clocksource has been installed.
[  605.627036] Switched to high resolution mode on CPU 0
[  605.628752] Switched to high resolution mode on CPU 1
[  605.635049] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[  605.635051] system 00:01: ioport range 0x220-0x225 has been reserved
[  605.635053] system 00:01: ioport range 0x290-0x294 has been reserved
[  605.635058] system 00:02: ioport range 0x4100-0x411f has been reserved
[  605.635059] system 00:02: ioport range 0x228-0x22f has been reserved
[  605.635061] system 00:02: ioport range 0x238-0x23f has been reserved
[  605.635062] system 00:02: ioport range 0x40b-0x40b has been reserved
[  605.635064] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[  605.635066] system 00:02: ioport range 0xc00-0xc01 has been reserved
[  605.635067] system 00:02: ioport range 0xc14-0xc14 has been reserved
[  605.635069] system 00:02: ioport range 0xc50-0xc52 has been reserved
[  605.635070] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[  605.635072] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[  605.635073] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[  605.635075] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[  605.635077] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[  605.635078] system 00:02: ioport range 0x4000-0x40fe has been reserved
[  605.635080] system 00:02: ioport range 0x4210-0x4217 has been reserved
[  605.635081] system 00:02: ioport range 0xb00-0xb0f has been reserved
[  605.635083] system 00:02: ioport range 0xb10-0xb1f has been reserved
[  605.635084] system 00:02: ioport range 0xb20-0xb3f has been reserved
[  605.635093] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[  605.635098] system 00:0c: iomem range 0xd1a00-0xd3fff has been reserved
[  605.635099] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[  605.635101] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[  605.635102] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[  605.635104] system 00:0c: iomem range 0xbfde0000-0xbfdfffff could not be reserved
[  605.635107] system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
[  605.635108] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[  605.635110] system 00:0c: iomem range 0x100000-0xbfddffff could not be reserved
[  605.635112] system 00:0c: iomem range 0xbfef0000-0xcfeeffff has been reserved
[  605.635113] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[  605.635115] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[  605.635117] system 00:0c: iomem range 0xfff80000-0xfffeffff has been reserved
[  605.635394] PCI: Bridge: 0000:00:01.0
[  605.635395]   IO window: e000-efff
[  605.635398]   MEM window: fd900000-fdafffff
[  605.635399]   PREFETCH window: d0000000-dfffffff
[  605.635402] PCI: Bridge: 0000:00:04.0
[  605.635403]   IO window: d000-dfff
[  605.635405]   MEM window: fd600000-fd7fffff
[  605.635407]   PREFETCH window: fdf00000-fdffffff
[  605.635411] PCI: Bridge: 0000:00:0a.0
[  605.635412]   IO window: c000-cfff
[  605.635414]   MEM window: fde00000-fdefffff
[  605.635416]   PREFETCH window: fdd00000-fddfffff
[  605.635419] PCI: Bridge: 0000:00:14.4
[  605.635421]   IO window: b000-bfff
[  605.635425]   MEM window: fdc00000-fdcfffff
[  605.635428]   PREFETCH window: fdb00000-fdbfffff
[  605.635453] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
[  605.635456] PCI: Setting latency timer of device 0000:00:04.0 to 64
[  605.635467] ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
[  605.635470] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[  605.635485] NET: Registered protocol family 2
[  605.671011] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[  605.671868] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[  605.675029] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[  605.675521] TCP: Hash tables configured (established 524288 bind 65536)
[  605.675523] TCP reno registered
[  605.687006] checking if image is initramfs... it is
[  606.109406] Freeing initrd memory: 7968k freed
[  606.113462] audit: initializing netlink socket (disabled)
[  606.113470] audit(1218710529.016:1): initialized
[  606.114811] VFS: Disk quotas dquot_6.5.1
[  606.114856] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  606.114940] io scheduler noop registered
[  606.114941] io scheduler anticipatory registered
[  606.114942] io scheduler deadline registered
[  606.115009] io scheduler cfq registered (default)
[  606.968562] 0000:00:13.0 OHCI: BIOS handoff failed (BIOS bug ?) 00000184
[  607.024604] Boot video device is 0000:01:05.0
[  607.024729] PCI: Setting latency timer of device 0000:00:04.0 to 64
[  607.024750] assign_interrupt_mode Found MSI capability
[  607.024771] Allocate Port Service[0000:00:04.0:pcie00]
[  607.024819] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[  607.024838] assign_interrupt_mode Found MSI capability
[  607.024856] Allocate Port Service[0000:00:0a.0:pcie00]
[  607.042013] Real Time Clock Driver v1.12ac
[  607.042136] hpet_resources: 0xfed00000 is busy
[  607.042157] Linux agpgart interface v0.102
[  607.042158] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[  607.042282] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  607.042681] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  607.043135] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[  607.043175] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[  607.043257] PNP: No PS/2 controller found. Probing ports directly.
[  607.045221] serio: i8042 KBD port at 0x60,0x64 irq 1
[  607.045227] serio: i8042 AUX port at 0x60,0x64 irq 12
[  607.062577] mice: PS/2 mouse device common for all mice
[  607.062610] cpuidle: using governor ladder
[  607.062611] cpuidle: using governor menu
[  607.062715] NET: Registered protocol family 1
[  607.062791] registered taskstats version 1
[  607.062884]   Magic number: 4:806:729
[  607.062984] /build/buildd/linux-2.6.24/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[  607.062986] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[  607.062987] EDD information not available.
[  607.062996] Freeing unused kernel memory: 320k freed
[  608.174449] fuse init (API version 7.9)
[  608.188017] ACPI Exception (processor_core-0822): AE_NOT_FOUND, Processor Device is not present [20070126]
[  608.188026] ACPI Exception (processor_core-0822): AE_NOT_FOUND, Processor Device is not present [20070126]
[  608.362525] SCSI subsystem initialized
[  608.382237] libata version 3.00 loaded.
[  608.385820] usbcore: registered new interface driver usbfs
[  608.385835] usbcore: registered new interface driver hub
[  608.385883] r8169 Gigabit Ethernet driver 2.2LK loaded
[  608.385902] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[  608.385917] PCI: Setting latency timer of device 0000:03:00.0 to 64
[  608.386138] eth0: RTL8168c/8111c at 0xffffc20001032000, 00:1f:d0:59:0e:66, XID 3c4000c0 IRQ 509
[  608.389074] usbcore: registered new device driver usb
[  608.389113] ahci 0000:00:11.0: version 3.0
[  608.389137] ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 22 (level, low) -> IRQ 22
[  608.389399] ahci 0000:00:11.0: controller can't do PMP, turning off CAP_PMP
[  608.406749] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[  608.409284] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  608.409288] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[  608.476867] Floppy drive(s): fd0 is 1.44M
[  608.493550] FDC 0 is a post-1991 82077
[  609.388168] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[  609.388172] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pio slum part
[  609.388997] scsi0 : ahci
[  609.389159] scsi1 : ahci
[  609.389262] scsi2 : ahci
[  609.389355] scsi3 : ahci
[  609.389450] scsi4 : ahci
[  609.389545] scsi5 : ahci
[  609.389611] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 508
[  609.389614] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 508
[  609.389618] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 508
[  609.389621] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 508
[  609.389624] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 508
[  609.389627] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 508
[  609.863246] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  609.877518] ata1.00: HPA unlocked: 1465147055 -> 1465149168, native 1465149168
[  609.877523] ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[  609.877525] ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[  609.883906] ata1.00: configured for UDMA/133
[  610.354345] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  610.362296] ata2.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[  610.362298] ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[  610.368676] ata2.00: configured for UDMA/133
[  610.841449] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  610.849398] ata3.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[  610.849400] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[  610.855779] ata3.00: configured for UDMA/133
[  611.164850] ata4: SATA link down (SStatus 0 SControl 300)
[  611.639978] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  611.797598] ata5.00: ATAPI: ASUS    DRW-2014L1T, 1.00, max UDMA/66, ATAPI AN
[  611.953313] ata5.00: configured for UDMA/66
[  612.262829] ata6: SATA link down (SStatus 0 SControl 300)
[  612.262901] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[  612.263160] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[  612.263367] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[  612.265401] scsi 4:0:0:0: CD-ROM            ASUS     DRW-2014L1T      1.00 PQ: 0 ANSI: 5
[  612.264001] ACPI: PCI Interrupt 0000:00:12.2[B] -> GSI 17 (level, low) -> IRQ 17
[  612.264215] ehci_hcd 0000:00:12.2: EHCI Host Controller
[  612.264384] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[  612.264425] ehci_hcd 0000:00:12.2: debug port 1
[  612.264442] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[  612.272099] Driver 'sd' needs updating - please use bus_type methods
[  612.272628] Driver 'sr' needs updating - please use bus_type methods
[  612.274817] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  612.274895] usb usb1: configuration #1 chosen from 1 choice
[  612.274911] hub 1-0:1.0: USB hub found
[  612.274916] hub 1-0:1.0: 6 ports detected
[  612.280959] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[  612.280968] sd 0:0:0:0: [sda] Write Protect is off
[  612.280969] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  612.280979] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  612.281018] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[  612.281023] sd 0:0:0:0: [sda] Write Protect is off
[  612.281025] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  612.281033] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  612.281035]  sda: sda1 sda2 sda3
[  612.286728] sd 0:0:0:0: [sda] Attached SCSI disk
[  612.286762] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[  612.286767] sd 1:0:0:0: [sdb] Write Protect is off
[  612.286768] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[  612.286776] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  612.286795] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[  612.286800] sd 1:0:0:0: [sdb] Write Protect is off
[  612.286802] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[  612.286810] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  612.286812]  sdb: sdb1
[  612.299379] sd 1:0:0:0: [sdb] Attached SCSI disk
[  612.299405] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
[  612.299410] sd 2:0:0:0: [sdc] Write Protect is off
[  612.299412] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[  612.299420] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  612.299438] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
[  612.299444] sd 2:0:0:0: [sdc] Write Protect is off
[  612.299445] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[  612.299453] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  612.299455]  sdc: sdc1
[  612.315966] sd 2:0:0:0: [sdc] Attached SCSI disk
[  612.321598] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  612.321611] sd 1:0:0:0: Attached scsi generic sg1 type 0
[  612.321623] sd 2:0:0:0: Attached scsi generic sg2 type 0
[  612.321636] sr 4:0:0:0: Attached scsi generic sg3 type 5
[  612.322365] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[  612.322369] Uniform CD-ROM driver Revision: 3.20
[  612.322404] sr 4:0:0:0: Attached scsi CD-ROM sr0
[  612.378687] ACPI: PCI Interrupt 0000:00:13.2[B] -> GSI 19 (level, low) -> IRQ 19
[  612.378946] ehci_hcd 0000:00:13.2: EHCI Host Controller
[  612.378992] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[  612.379028] ehci_hcd 0000:00:13.2: debug port 1
[  612.379044] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[  612.390585] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  612.390647] usb usb2: configuration #1 chosen from 1 choice
[  612.390664] hub 2-0:1.0: USB hub found
[  612.390668] hub 2-0:1.0: 6 ports detected
[  612.494535] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
[  612.494802] ohci_hcd 0000:00:12.0: OHCI Host Controller
[  612.494851] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[  612.494872] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[  612.547732] kjournald starting.  Commit interval 5 seconds
[  612.547740] EXT3-fs: mounted filesystem with ordered data mode.
[  612.554384] usb usb3: configuration #1 chosen from 1 choice
[  612.554402] hub 3-0:1.0: USB hub found
[  612.554411] hub 3-0:1.0: 3 ports detected
[  612.662157] ACPI: PCI Interrupt 0000:00:12.1[A] -> GSI 16 (level, low) -> IRQ 16
[  612.662442] ohci_hcd 0000:00:12.1: OHCI Host Controller
[  612.662488] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[  612.662503] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[  612.718072] usb usb4: configuration #1 chosen from 1 choice
[  612.718088] hub 4-0:1.0: USB hub found
[  612.718096] hub 4-0:1.0: 3 ports detected
[  612.821838] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 18 (level, low) -> IRQ 18
[  612.822033] ohci_hcd 0000:00:13.0: OHCI Host Controller
[  612.822075] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[  612.822097] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[  612.881768] usb usb5: configuration #1 chosen from 1 choice
[  612.881784] hub 5-0:1.0: USB hub found
[  612.881791] hub 5-0:1.0: 3 ports detected
[  612.981572] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 18 (level, low) -> IRQ 18
[  612.981768] ohci_hcd 0000:00:13.1: OHCI Host Controller
[  612.981812] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[  612.981828] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[  613.041478] usb usb6: configuration #1 chosen from 1 choice
[  613.041496] hub 6-0:1.0: USB hub found
[  613.041504] hub 6-0:1.0: 3 ports detected
[  613.149258] ACPI: PCI Interrupt 0000:00:14.5[C] -> GSI 18 (level, low) -> IRQ 18
[  613.149498] ohci_hcd 0000:00:14.5: OHCI Host Controller
[  613.149545] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[  613.149560] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[  613.205168] usb usb7: configuration #1 chosen from 1 choice
[  613.205183] hub 7-0:1.0: USB hub found
[  613.205190] hub 7-0:1.0: 2 ports detected
[  613.217063] usb 4-1: new low speed USB device using ohci_hcd and address 2
[  613.313048] ACPI: PCI Interrupt 0000:04:0e.0[A] -> GSI 22 (level, low) -> IRQ 22
[  613.319322] ATIIXP: IDE controller (0x1002:0x439c rev 0x00) at  PCI slot 0000:00:14.1
[  613.319336] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[  613.319344] ATIIXP: not 100% native mode: will probe irqs later
[  613.319350]     ide0: BM-DMA at 0xfa00-0xfa07, BIOS settings: hda:pio, hdb:pio
[  613.319364] ATIIXP: simplex device: DMA disabled
[  613.319365] ide1: ATIIXP Bus-Master DMA disabled (BIOS)
[  613.319367] Probing IDE interface ide0...
[  613.363106] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fdcff000-fdcff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[  613.439447] usb 4-1: configuration #1 chosen from 1 choice
[  613.885966] Probing IDE interface ide1...
[  614.632675] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007196ad00001fd0]
[  618.020542] input: PC Speaker as /devices/platform/pcspkr/input/input1
[  618.094611] parport_pc 00:0a: reported by Plug and Play ACPI
[  618.094700] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[  618.116886] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  618.126661] shpchp: HPC vendor_id 1022 device_id 9602 ss_vid 0 ss_did 0
[  618.126664] shpchp: shpc_init: cannot reserve MMIO region
[  618.126679] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  618.319900] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[  618.353207] input: Power Button (FF) as /devices/virtual/input/input2
[  618.413680] ACPI: Power Button (FF) [PWRF]
[  618.413719] input: Power Button (CM) as /devices/virtual/input/input3
[  618.477555] ACPI: Power Button (CM) [PWRB]
[  618.477612] ACPI: WMI-Acer: Mapper loaded
[  618.638490] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[  618.660857] [fglrx] Maximum main memory to use for locked dma buffers: 3544 MBytes.
[  618.660879] [fglrx] ASYNCIO init succeed!
[  618.661145] [fglrx] PAT is enabled successfully!
[  618.661164] [fglrx] module loaded - fglrx 8.47.3 [Feb 25 2008] on minor 0
[  618.796772] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
[  618.830724] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[  618.862920] ACPI: PCI Interrupt 0000:01:05.1[B] -> GSI 19 (level, low) -> IRQ 19
[  618.863113] PCI: Setting latency timer of device 0000:01:05.1 to 64
[  618.877189] Linux video capture interface: v2.00
[  618.904697] cx23885 driver version 0.0.1 loaded
[  618.915437] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[  618.915454] CORE cx23885[0]: subsystem: 107d:6681, board: Leadtek Winfast PxDVR3200 H [card=11,autodetected]
[  619.055435] cx23885[0]: i2c bus 0 registered
[  619.055458] cx23885[0]: i2c bus 1 registered
[  619.055494] cx23885[0]: i2c bus 2 registered
[  619.088471] usbcore: registered new interface driver hiddev
[  619.092669] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.0/input/input4
[  619.097124] cx25840' 3-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[  619.097461] cx23885[0]: cx23885 based dvb card
[  619.144431] input,hidraw0: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-1
[  619.151586] Fixing up Logitech keyboard report descriptor
[  619.151948] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.1/input/input5
[  619.155423] xc2028 2-0061: creating new instance
[  619.155425] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[  619.155429] DVB: registering new adapter (cx23885[0])
[  619.155431] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[  619.155606] cx23885_dev_checkrevision() Hardware revision = 0xb0
[  619.155612] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfd600000
[  619.155618] PCI: Setting latency timer of device 0000:02:00.0 to 64
[  619.220198] input,hiddev96,hidraw1: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-1
[  619.220212] usbcore: registered new interface driver usbhid
[  619.220215] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[  620.351417] lp0: using parport0 (interrupt-driven).
[  620.443761] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[  620.446360] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[  620.446362] cx88/2: registering cx8802 driver, type: dvb access: shared
[  620.492913] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[  712.572112] EXT3 FS on sda1, internal journal
[  712.647928] device-mapper: uevent: version 1.0.3
[  712.647955] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[  713.535844] ip_tables: (C) 2000-2006 Netfilter Core Team
[  713.711042] No dock devices found.
[  713.956544] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[  713.955216] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[  713.955219] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[  713.955220] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[  713.955221] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[  713.955222] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[  713.955224] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[  713.955225] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[  713.955226] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[  715.974179] ppdev: user-space parallel port driver
[  716.157297] audit(1218710640.051:2): type=1503 operation="inode_permission" requested_mask="a::" denied_mask="a::" name="/dev/tty" pid=6176 profile="/usr/sbin/cupsd"namespace="default"
[  716.673548] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[  716.673553] vboxdrv: Successfully done.
[  716.673735] vboxdrv: TSC mode is 'asynchronous', kernel timer mode is 'normal'.
[  716.673737] vboxdrv: Successfully loaded version 1.5.6_OSE (interface 0x00050002).
[  717.276602] NET: Registered protocol family 10
[  717.276775] lo: Disabled Privacy Extensions
[  717.557706] Clocksource tsc unstable (delta = -333333896 ns)
[  717.959797] r8169: eth0: link up
[  717.959802] r8169: eth0: link up
[  718.366713] Bluetooth: Core ver 2.11
[  718.366938] NET: Registered protocol family 31
[  718.366941] Bluetooth: HCI device and connection manager initialized
[  718.366943] Bluetooth: HCI socket layer initialized
[  718.379945] Bluetooth: L2CAP ver 2.9
[  718.379949] Bluetooth: L2CAP socket layer initialized
[  718.401166] Bluetooth: RFCOMM socket layer initialized
[  718.401175] Bluetooth: RFCOMM TTY layer initialized
[  718.401177] Bluetooth: RFCOMM ver 1.8
[  719.014849] NET: Registered protocol family 17
[  719.608746] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 18 (level, low) -> IRQ 18
[  720.835888] [fglrx] GART Table is not in FRAME_BUFFER range
[  720.835894] [fglrx] Reserve Block - 0 offset =  0Xfffc000 length = 0X4000
[  720.835896] [fglrx] Reserve Block - 1 offset =  0X0 length = 0X1000000
[  721.003178] [fglrx] interrupt source ff000034 successfully enabled
[  721.003182] [fglrx] enable ID = 0x00000006
[  721.003431] [fglrx] Receive enable interrupt message with irqEnableMask: ff000034
[  721.003590] [fglrx] interrupt source 10000000 successfully enabled
[  721.003592] [fglrx] enable ID = 0x00000007
[  721.003743] [fglrx] Receive enable interrupt message with irqEnableMask: 10000000
[  725.219799] eth0: no IPv6 routers present
[  757.185664] hda-intel: Invalid position buffer, using LPIB read method instead.
[  834.456661] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  834.457381] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  834.469514] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  835.471081] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  835.471799] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  835.474727] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  836.258057] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  836.258585] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  836.260885] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  836.775890] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  836.776134] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  836.777962] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  837.111089] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  837.111333] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  837.112982] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  837.114795] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  837.115034] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  837.116561] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  837.450277] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  837.450520] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  837.452125] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  837.784641] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  837.784874] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  837.786454] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  838.119337] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  838.119580] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  838.121135] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  838.454548] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  838.454791] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  838.456409] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  838.458236] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  838.458472] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  838.460025] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  838.795043] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  838.795287] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  838.796868] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  839.128069] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  839.128312] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  839.130090] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  839.464120] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  839.464363] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  839.466219] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  839.797789] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  839.798032] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  839.799765] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  840.133195] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  840.133437] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  840.135325] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  840.467595] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  840.467838] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  840.469769] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  840.803826] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  840.804070] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  840.805812] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  841.137411] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  841.137655] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  841.139292] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  841.472774] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  841.473017] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  841.474850] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  841.807284] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  841.807526] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  841.809051] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  842.143038] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  842.143282] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  842.144895] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  842.477089] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  842.477332] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  842.478899] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  842.812374] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  842.812617] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  842.814238] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  843.146803] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  843.147048] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  843.148618] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.
[  843.483828] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 450560 => 0x5ae9
[  843.484073] zl10353: zl10353_calc_input_freq: if2 45600, ife 45600, adc_clock 450560 => -6633 / 0xe617
[  843.485652] xc2028 2-0061: Error: firmware xc3028-v27.fw not found.

--=-v57m+M2SYUZvIa+86xv8
Content-Disposition: attachment; filename="tv scan2.txt"
Content-Type: text/plain; name="tv scan2.txt"; charset=utf-8
Content-Transfer-Encoding: 7bit

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

--=-v57m+M2SYUZvIa+86xv8
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-v57m+M2SYUZvIa+86xv8--
