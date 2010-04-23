Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:51010 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab0DWW2u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 18:28:50 -0400
Subject: Re: Issue loading SAA7134 module
From: hermann pitton <hermann-pitton@arcor.de>
To: Donnie Bailey <donnie@apple2pl.us>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Alan McIvor <alan.mcivor@reveal.co.nz>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4BD0D7B0.1020300@apple2pl.us>
References: <4BCF2636.4010803@apple2pl.us>
	 <1271901451.3198.59.camel@pc07.localdom.local>
	 <4BD0320B.2080009@apple2pl.us>
	 <1271974292.11222.23.camel@pc07.localdom.local>
	 <4BD0D7B0.1020300@apple2pl.us>
Content-Type: text/plain
Date: Sat, 24 Apr 2010 00:25:16 +0200
Message-Id: <1272061516.4221.46.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

Am Donnerstag, den 22.04.2010, 20:11 -0300 schrieb Donnie Bailey:
> On 04/22/2010 07:11 PM, hermann pitton wrote:
> > Hi Donald,
> >
> > Am Donnerstag, den 22.04.2010, 08:24 -0300 schrieb Donnie Bailey:
> >> On 04/21/2010 10:57 PM, hermann pitton wrote:
> >>> Am Mittwoch, den 21.04.2010, 13:22 -0300 schrieb Donald Bailey:
> >>>
> >>>> I've got a couple of boxes that have two no-name 8-chip SAA713X cards.
> >>>> Both have the same issue: the kernel will only set up the first eight on
> >>>> one board and only two on the second.  It leaves the other six unusable
> >>>> with error -23.  I am unable to figure out what that means.
> >>>>
> >>>> Sample dmesg as follows.  More (/proc/ioports, /proc/interrupts, etc)
> >>>> can be posted if requested.  Tried kernels 2.6.18 and 2.6.33.2 on CentOS
> >>>> 5.4 and Fedora 11 fully updated. The module is loaded as card=0. The
> >>>> following is output for chips 11 through 16.
> >>>>
> >>>> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
> >>>> [card=0,autodetected]
> >>>> saa7130[10]: board init: gpio is 10000
> >>>> saa7130[10]: Huh, no eeprom present (err=-5)?
> >>>> saa7130[10]: can't register video device
> >>>> saa7134: probe of 0000:05:0f.0 failed with error -23
> >>>>
> >>>>
> >>> Due to some unknown bug we have ;), it likely works only perfectly with
> >>> unidentified devices with more than 128 saa713x chips in a single PCI
> >>> slot.
> >>>
> >>> Read on the wiki, about how to add a new device, and feel free to
> >>> improve it.
> >>>
> >>> China is going totally mad. (or is it from somewhere else?)
> >>>
> >>> Cheers,
> >>> Hermann
> >>>
> >>>
> >>>
> >> As I said, the first 10 (/dev/video[0-9]) are working great.  But with
> >> the rest, what would be /dev/video[10-15], the SAA7134 module fails to
> >> set the devices up with error -23.
> >>
> >> Donald
> >
> > it is really important to have some documentation about such cards
> > without eeprom, especially if they come up with eight saa7130 chips and
> > extra PCI controllers.
> >
> > If I look back, you reported such a card already in November 2006,
> > aop-8008A, but it still has no entry and documentation. If this is
> > really a new card again, we should add what we can to avoid running in
> > circles.
> >
> > You seem to hit a valid problem, but I did not come to the root cause
> > yet.
> >
> > Since this patch two years back the driver claims to support up to 32
> > PCI devices.
> > http://linuxtv.org/hg/v4l-dvb/rev/75d3289d4caa
> >
> > This is defined in MAXBOARDS in saa7134.h and saa7134-core.c has no
> > other restriction than this and will return -12 if above.
> >
> > static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
> > 				     const struct pci_device_id *pci_id)
> > {
> > 	struct saa7134_dev *dev;
> > 	struct saa7134_mpeg_ops *mops;
> > 	int err;
> >
> > 	if (saa7134_devcount == SAA7134_MAXBOARDS)
> > 		return -ENOMEM;
> >
> > ...
> >
> > In theory, the 2.6.33 should do it, but unfortunately I don't find a
> > single log from somebody with more than 8 saa713x devices during the
> > last two years, except yours now.
> >
> > With error -23 we seem to hit some max_files open restriction.
> >
> > Likely from some includes, but needs to grep through the driver too, but
> > I'm for now not aware of such limit there.
> >
> > The devices above ten do look OK in lspci and your mobo seems to be fine
> > with them?
> >
> > Maybe our PCI experts have some hint.
> >
> > Cheers,
> > Hermann
> >
> >
> I have come across somebody else that has had this problem back in 2007, 
> courtesy Google, but they never received a response:
> 
> https://answers.launchpad.net/ubuntu/+question/15105

Interesting, the patch increasing from 8 to
#define SAA7134_MAXBOARDS 32
happened only in March 2008 at development level at v4l-dvb.

But this from Okt. 2007 looks already buggy, since the count of minors
should stop, checking against SAA7134_MAXBOARDS -1, with dev7 (0-7), but
counts up to 0-8.

> Here's some further info on my config:
> 
> uname -a
> Linux localhost.localdomain 2.6.18-164.15.1.el5 #1 SMP Wed Mar 17 
> 11:30:06 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux

That 2.6.18 is also too old. (Released Sept. 20 2006)
Number of minors should be checked against SAA7134_MAXBOARDS 8.

Now this counts up minors from 0-9 and errors out on 10, strange, and
you report still the same for 2.6.33.

To be honest, when I did start ranting about such devices out of the
driver, I was quite confident some kernel must have set
SAA7134_MAXBOARDS to 10, since MAXBOARDS 32 was already added two years
back from somebody obviously in need of it without complaints for now.

Not to be able to test it and without any logs it was a little
unpleasant.

Mauro, sorry for your time, but in that rare case Donald can offer help
with testing having two such 8x saa7130 devices, should we start with
some v4l-dvb at the time MAXBOARDS 32 was added and the first kernel
using it?

Alan, if you should receive that mail, can you point us to something
where it did work for you to start regression tests?

(full logs not cut yet)

Cheers,
Hermann

> ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux localhost.localdomain 2.6.18-164.15.1.el5 #1 SMP Wed Mar 17 
> 11:30:06 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux
> 
> Gnu C                  4.1.2
> Gnu make               3.81
> binutils               2.17.50.0.6
> util-linux             2.13-pre7
> mount                  2.13-pre7
> module-init-tools      3.3-pre2
> e2fsprogs              1.39
> pcmciautils            014
> quota-tools            3.13.
> PPP                    2.4.4
> isdn4k-utils           3.9
> Linux C Library        2.5
> Dynamic linker (ldd)   2.5
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.4
> Sh-utils               5.97
> udev                   095
> wireless-tools         28
> Modules Loaded         ipt_MASQUERADE iptable_nat ip_nat bridge autofs4 
> hidp rfcomm l2cap bluetooth lockd sunrpc ip_conntrack_ftp 
> ip_conntrack_netbios_ns ipt_REJECT xt_state ip_conntrack nfnetlink 
> iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter 
> ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core 
> ib_addr iscsi_tcp bnx2i cnic uio cxgb3i cxgb3 8021q libiscsi_tcp 
> libiscsi2 scsi_transport_iscsi2 scsi_transport_iscsi cpufreq_ondemand 
> powernow_k8 freq_table dm_multipath scsi_dh video hwmon backlight sbs 
> i2c_ec button battery asus_acpi acpi_memhotplug ac ipv6 xfrm_nalgo 
> crypto_api lp snd_seq_dummy snd_hda_intel snd_seq_oss snd_seq_midi_event 
> snd_seq snd_seq_device snd_pcm_oss saa7134 shpchp snd_mixer_oss snd_pcm 
> video_buf ide_cd r8169 sg compat_ioctl32 ir_kbd_i2c mii i2c_piix4 
> i2c_core ir_common videodev serio_raw pcspkr parport_pc parport 
> snd_timer snd_page_alloc snd_hwdep v4l1_compat snd v4l2_common cdrom 
> soundcore dm_raid45 dm_message dm_region_hash dm_mem_cache dm_snapshot 
> dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_mod ext3 jbd 
> uhci_hcd ohci_hcd ehci_hcd
> 
> 
> /proc/cpuinfo
> processor    : 0
> vendor_id    : AuthenticAMD
> cpu family    : 16
> model        : 6
> model name    : AMD Athlon(tm) II X2 250 Processor
> stepping    : 2
> cpu MHz        : 800.000
> cache size    : 1024 KB
> physical id    : 0
> siblings    : 2
> core id        : 0
> cpu cores    : 2
> apicid        : 0
> fpu        : yes
> fpu_exception    : yes
> cpuid level    : 5
> wp        : yes
> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
> pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc nonstop_tsc pni cx16 
> popcnt lahf_lm cmp_legacy svm extapic cr8_legacy altmovcr8 abm sse4a 
> misalignsse 3dnowprefetch osvw
> bogomips    : 6026.85
> TLB size    : 1024 4K pages
> clflush size    : 64
> cache_alignment    : 64
> address sizes    : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate [8]
> 
> processor    : 1
> vendor_id    : AuthenticAMD
> cpu family    : 16
> model        : 6
> model name    : AMD Athlon(tm) II X2 250 Processor
> stepping    : 2
> cpu MHz        : 800.000
> cache size    : 1024 KB
> physical id    : 0
> siblings    : 2
> core id        : 1
> cpu cores    : 2
> apicid        : 1
> fpu        : yes
> fpu_exception    : yes
> cpuid level    : 5
> wp        : yes
> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
> pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc nonstop_tsc pni cx16 
> popcnt lahf_lm cmp_legacy svm extapic cr8_legacy altmovcr8 abm sse4a 
> misalignsse 3dnowprefetch osvw
> bogomips    : 6026.81
> TLB size    : 1024 4K pages
> clflush size    : 64
> cache_alignment    : 64
> address sizes    : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate [8]
> 
> /proc/modules
> ipt_MASQUERADE 36224 1 - Live 0xffffffff8884d000 (FU)
> iptable_nat 39940 1 - Live 0xffffffff88842000 (FU)
> ip_nat 51628 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffff88834000 (FU)
> bridge 84656 0 - Live 0xffffffff8881e000 (FU)
> autofs4 58120 3 - Live 0xffffffff8880e000 (FU)
> hidp 78976 2 - Live 0xffffffff887f9000 (FU)
> rfcomm 99240 0 - Live 0xffffffff887df000 (FU)
> l2cap 86272 10 hidp,rfcomm, Live 0xffffffff887c8000 (FU)
> bluetooth 112900 5 hidp,rfcomm,l2cap, Live 0xffffffff887ab000 (FU)
> lockd 96240 0 - Live 0xffffffff88792000 (FU)
> sunrpc 187336 2 lockd, Live 0xffffffff88763000 (FU)
> ip_conntrack_ftp 40272 0 - Live 0xffffffff88758000 (FU)
> ip_conntrack_netbios_ns 35968 0 - Live 0xffffffff8874e000 (FU)
> ipt_REJECT 37760 3 - Live 0xffffffff88743000 (FU)
> xt_state 35456 9 - Live 0xffffffff88739000 (FU)
> ip_conntrack 87332 6 
> ipt_MASQUERADE,iptable_nat,ip_nat,ip_conntrack_ftp,ip_conntrack_netbios_ns,xt_state, 
> Live 0xffffffff88722000 (FU)
> nfnetlink 39496 2 ip_nat,ip_conntrack, Live 0xffffffff88717000 (FU)
> iptable_filter 35840 1 - Live 0xffffffff8870d000 (FU)
> ip_tables 53600 2 iptable_nat,iptable_filter, Live 0xffffffff886fe000 (FU)
> ip6t_REJECT 37888 1 - Live 0xffffffff886f3000 (FU)
> xt_tcpudp 36352 26 - Live 0xffffffff886e9000 (FU)
> ip6table_filter 35712 1 - Live 0xffffffff886df000 (FU)
> ip6_tables 48832 1 ip6table_filter, Live 0xffffffff886d2000 (FU)
> x_tables 48392 8 
> ipt_MASQUERADE,iptable_nat,ipt_REJECT,xt_state,ip_tables,ip6t_REJECT,xt_tcpudp,ip6_tables, 
> Live 0xffffffff886c5000 (FU)
> ib_iser 67072 0 - Live 0xffffffff886b3000 (FU)
> rdma_cm 65812 1 ib_iser, Live 0xffffffff886a1000 (FU)
> ib_cm 69544 1 rdma_cm, Live 0xffffffff8868f000 (FU)
> iw_cm 42120 1 rdma_cm, Live 0xffffffff88683000 (FU)
> ib_sa 71688 2 rdma_cm,ib_cm, Live 0xffffffff88670000 (FU)
> ib_mad 68644 2 ib_cm,ib_sa, Live 0xffffffff8865e000 (FU)
> ib_core 100356 6 ib_iser,rdma_cm,ib_cm,iw_cm,ib_sa,ib_mad, Live 
> 0xffffffff88644000 (FU)
> ib_addr 40072 1 rdma_cm, Live 0xffffffff88639000 (FU)
> iscsi_tcp 48524 0 - Live 0xffffffff8862c000 (FU)
> bnx2i 71456 0 - Live 0xffffffff88619000 (FU)
> cnic 56088 1 bnx2i, Live 0xffffffff8860a000 (FU)
> uio 42768 1 cnic, Live 0xffffffff885fe000 (FU)
> cxgb3i 74352 0 - Live 0xffffffff885ea000 (FU)
> cxgb3 205296 1 cxgb3i, Live 0xffffffff885b6000 (FU)
> 8021q 52496 1 cxgb3, Live 0xffffffff885a8000 (FU)
> libiscsi_tcp 52100 2 iscsi_tcp,cxgb3i, Live 0xffffffff8859a000 (FU)
> libiscsi2 74116 5 ib_iser,iscsi_tcp,bnx2i,cxgb3i,libiscsi_tcp, Live 
> 0xffffffff88586000 (FU)
> scsi_transport_iscsi2 70424 7 ib_iser,iscsi_tcp,bnx2i,cxgb3i,libiscsi2, 
> Live 0xffffffff88573000 (FU)
> scsi_transport_iscsi 35080 1 scsi_transport_iscsi2, Live 
> 0xffffffff88569000 (FU)
> cpufreq_ondemand 40848 1 - Live 0xffffffff8855e000 (FU)
> powernow_k8 56216 1 - Live 0xffffffff8854f000 (FU)
> freq_table 40696 2 cpufreq_ondemand,powernow_k8, Live 0xffffffff88544000 
> (FU)
> dm_multipath 53656 0 - Live 0xffffffff88535000 (FU)
> scsi_dh 40576 1 dm_multipath, Live 0xffffffff8852a000 (FU)
> video 50700 0 - Live 0xffffffff8851c000 (FU)
> hwmon 35976 0 - Live 0xffffffff88512000 (FU)
> backlight 38400 1 video, Live 0xffffffff88507000 (FU)
> sbs 47424 0 - Live 0xffffffff884fa000 (FU)
> i2c_ec 37888 1 sbs, Live 0xffffffff884ef000 (FU)
> button 39072 0 - Live 0xffffffff884e4000 (FU)
> battery 41992 0 - Live 0xffffffff884d8000 (FU)
> asus_acpi 49188 0 - Live 0xffffffff884ca000 (FU)
> acpi_memhotplug 38660 0 - Live 0xffffffff884bf000 (FU)
> ac 37384 0 - Live 0xffffffff884b4000 (FU)
> ipv6 407776 34 ip6t_REJECT,cnic, Live 0xffffffff8844f000 (FU)
> xfrm_nalgo 42884 1 ipv6, Live 0xffffffff88443000 (FU)
> crypto_api 41984 1 xfrm_nalgo, Live 0xffffffff88437000 (FU)
> lp 45136 0 - Live 0xffffffff8842a000 (FU)
> snd_seq_dummy 36484 0 - Live 0xffffffff88420000 (FU)
> snd_hda_intel 579152 0 - Live 0xffffffff8838f000 (FU)
> snd_seq_oss 63872 0 - Live 0xffffffff8837e000 (FU)
> snd_seq_midi_event 40704 1 snd_seq_oss, Live 0xffffffff88373000 (FU)
> snd_seq 84384 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 
> 0xffffffff8835d000 (FU)
> snd_seq_device 40852 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 
> 0xffffffff88352000 (FU)
> snd_pcm_oss 75008 0 - Live 0xffffffff8833e000 (FU)
> saa7134 154728 0 - Live 0xffffffff88317000 (FU)
> shpchp 66220 0 - Live 0xffffffff88305000 (FU)
> snd_mixer_oss 48640 1 snd_pcm_oss, Live 0xffffffff882f8000 (FU)
> snd_pcm 113160 2 snd_hda_intel,snd_pcm_oss, Live 0xffffffff882db000 (FU)
> video_buf 57092 1 saa7134, Live 0xffffffff882cc000 (FU)
> ide_cd 69920 0 - Live 0xffffffff882b9000 (FU)
> r8169 65156 0 - Live 0xffffffff882a8000 (FU)
> sg 65960 0 - Live 0xffffffff88296000 (FU)
> compat_ioctl32 40832 1 saa7134, Live 0xffffffff8828b000 (FU)
> ir_kbd_i2c 41744 1 saa7134, Live 0xffffffff8827f000 (FU)
> mii 38656 1 r8169, Live 0xffffffff88274000 (FU)
> i2c_piix4 42636 0 - Live 0xffffffff88268000 (FU)
> i2c_core 54272 4 i2c_ec,saa7134,ir_kbd_i2c,i2c_piix4, Live 
> 0xffffffff88259000 (FU)
> ir_common 62596 2 saa7134,ir_kbd_i2c, Live 0xffffffff88248000 (FU)
> videodev 57088 1 saa7134, Live 0xffffffff88239000 (FU)
> serio_raw 38916 0 - Live 0xffffffff8822e000 (FU)
> pcspkr 35840 0 - Live 0xffffffff88224000 (FU)
> parport_pc 60072 1 - Live 0xffffffff88212000 (FU)
> parport 70540 2 lp,parport_pc, Live 0xffffffff881ff000 (FU)
> snd_timer 54280 2 snd_seq,snd_pcm, Live 0xffffffff881f0000 (FU)
> snd_page_alloc 42000 2 snd_hda_intel,snd_pcm, Live 0xffffffff881e4000 (FU)
> snd_hwdep 42120 1 snd_hda_intel, Live 0xffffffff881d8000 (FU)
> v4l1_compat 43780 2 saa7134,videodev, Live 0xffffffff881cc000 (FU)
> snd 94760 9 
> snd_hda_intel,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer,snd_hwdep, 
> Live 0xffffffff881b3000 (FU)
> v4l2_common 56704 3 saa7134,compat_ioctl32,videodev, Live 
> 0xffffffff881a4000 (FU)
> cdrom 66984 1 ide_cd, Live 0xffffffff88192000 (FU)
> soundcore 40992 1 snd, Live 0xffffffff88186000 (FU)
> dm_raid45 99657 0 - Live 0xffffffff8816c000
> dm_message 36289 1 dm_raid45, Live 0xffffffff88162000
> dm_region_hash 46145 1 dm_raid45, Live 0xffffffff88155000
> dm_mem_cache 38977 1 dm_raid45, Live 0xffffffff8814a000
> dm_snapshot 51977 0 - Live 0xffffffff8813c000
> dm_zero 35265 0 - Live 0xffffffff88132000
> dm_mirror 54609 0 - Live 0xffffffff88123000
> dm_log 44993 3 dm_raid45,dm_region_hash,dm_mirror, Live 0xffffffff88117000
> dm_mod 101521 11 
> dm_multipath,dm_raid45,dm_snapshot,dm_zero,dm_mirror,dm_log, Live 
> 0xffffffff880fd000
> ahci 69449 2 - Live 0xffffffff880eb000
> libata 209489 1 ahci, Live 0xffffffff880b6000
> sd_mod 56513 3 - Live 0xffffffff880a7000
> scsi_mod 196697 10 
> ib_iser,iscsi_tcp,bnx2i,cxgb3i,libiscsi2,scsi_transport_iscsi2,scsi_dh,sg,libata,sd_mod, 
> Live 0xffffffff88075000
> ext3 168401 2 - Live 0xffffffff8804a000
> jbd 94769 1 ext3, Live 0xffffffff88031000
> uhci_hcd 57433 0 - Live 0xffffffff88021000
> ohci_hcd 55925 0 - Live 0xffffffff88012000
> ehci_hcd 66253 0 - Live 0xffffffff88000000
> 
> /proc/ioports
> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-0060 : keyboard
> 0064-0064 : keyboard
> 0070-0077 : rtc
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 01f0-01f7 : ide0
> 0230-023f : pnp 00:0e
> 0290-029f : pnp 00:0e
> 0300-030f : pnp 00:0e
> 0378-037a : parport0
> 03c0-03df : vga+
> 03f6-03f6 : ide0
> 03f8-03ff : serial
> 0800-0803 : ACPI PM1a_EVT_BLK
> 0804-0805 : ACPI PM1a_CNT_BLK
> 0808-080b : ACPI PM_TMR
> 0810-0815 : ACPI CPU throttle
> 0820-0827 : ACPI GPE0_BLK
> 0a30-0a3f : pnp 00:0e
> 0b00-0b07 : piix4_smbus
> 0cf8-0cff : PCI conf1
> 8000-800f : 0000:00:11.0
> 9000-9003 : 0000:00:11.0
> a000-a007 : 0000:00:11.0
> b000-b003 : 0000:00:11.0
> c000-c007 : 0000:00:11.0
> d000-dfff : PCI Bus #01
>    d000-d0ff : 0000:01:05.0
> e000-efff : PCI Bus #02
>    e800-e8ff : 0000:02:00.0
>      e800-e8ff : r8169
> fe00-fefe : motherboard
> ff00-ff0f : 0000:00:14.1
>    ff00-ff07 : ide0
>    ff08-ff0f : ide1
> 
> /proc/iomem
> 00010000-0009ebff : System RAM
> 0009ec00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000cedff : Video ROM
> 000f0000-000fffff : System ROM
> 00100000-cff8ffff : System RAM
>    00200000-0047e12f : Kernel code
>    0047e130-005c180f : Kernel data
>    04000000-07ffffff : GART
> cff90000-cffa7fff : ACPI Tables
> cffa8000-cffcffff : ACPI Non-volatile Storage
> cffd0000-cfffffff : reserved
> d0000000-dfffffff : PCI Bus #01
>    d0000000-dfffffff : 0000:01:05.0
> fdf00000-fdffffff : PCI Bus #02
>    fdff8000-fdffbfff : 0000:02:00.0
>      fdff8000-fdffbfff : r8169
>    fdfff000-fdffffff : 0000:02:00.0
>      fdfff000-fdffffff : r8169
> fe6f4000-fe6f7fff : 0000:00:14.2
>    fe6f4000-fe6f7fff : ICH HD audio
> fe6fa000-fe6fafff : 0000:00:14.5
>    fe6fa000-fe6fafff : ohci_hcd
> fe6fb000-fe6fbfff : 0000:00:13.1
>    fe6fb000-fe6fbfff : ohci_hcd
> fe6fc000-fe6fcfff : 0000:00:13.0
>    fe6fc000-fe6fcfff : ohci_hcd
> fe6fd000-fe6fdfff : 0000:00:12.1
>    fe6fd000-fe6fdfff : ohci_hcd
> fe6fe000-fe6fefff : 0000:00:12.0
>    fe6fe000-fe6fefff : ohci_hcd
> fe6ff400-fe6ff4ff : 0000:00:13.2
>    fe6ff400-fe6ff4ff : ehci_hcd
> fe6ff800-fe6ff8ff : 0000:00:12.2
>    fe6ff800-fe6ff8ff : ehci_hcd
> fe6ffc00-fe6fffff : 0000:00:11.0
>    fe6ffc00-fe6fffff : ahci
> fe700000-fe8fffff : PCI Bus #01
>    fe700000-fe7fffff : 0000:01:05.0
>    fe8e8000-fe8ebfff : 0000:01:05.1
>      fe8e8000-fe8ebfff : ICH HD audio
>    fe8f0000-fe8fffff : 0000:01:05.0
> fe900000-fe9fffff : PCI Bus #02
>    fe9f0000-fe9fffff : 0000:02:00.0
> fea00000-febfffff : PCI Bus #03
>    fea00000-feafffff : PCI Bus #04
>      feafe000-feafe3ff : 0000:04:0f.0
>        feafe000-feafe3ff : saa7130[7]
>      feafe400-feafe7ff : 0000:04:0e.0
>        feafe400-feafe7ff : saa7130[6]
>      feafe800-feafebff : 0000:04:0d.0
>        feafe800-feafebff : saa7130[5]
>      feafec00-feafefff : 0000:04:0c.0
>        feafec00-feafefff : saa7130[4]
>      feaff000-feaff3ff : 0000:04:0b.0
>        feaff000-feaff3ff : saa7130[3]
>      feaff400-feaff7ff : 0000:04:0a.0
>        feaff400-feaff7ff : saa7130[2]
>      feaff800-feaffbff : 0000:04:09.0
>        feaff800-feaffbff : saa7130[1]
>      feaffc00-feafffff : 0000:04:08.0
>        feaffc00-feafffff : saa7130[0]
>    feb00000-febfffff : PCI Bus #05
>      febfe000-febfe3ff : 0000:05:0f.0
>      febfe400-febfe7ff : 0000:05:0e.0
>      febfe800-febfebff : 0000:05:0d.0
>      febfec00-febfefff : 0000:05:0c.0
>      febff000-febff3ff : 0000:05:0b.0
>      febff400-febff7ff : 0000:05:0a.0
>      febff800-febffbff : 0000:05:09.0
>        febff800-febffbff : saa7130[9]
>      febffc00-febfffff : 0000:05:08.0
>        febffc00-febfffff : saa7130[8]
> ff700000-ffffffff : reserved
> 100000000-11fffffff : System RAM
> 
> lspci -vvv
> 00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge 
> Alternate
>      Subsystem: ASUSTeK Computer Inc. Unknown device 83a2
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ >SERR- <PERR-
>      Latency: 0
>      Capabilities: [c4] HyperTransport: Slave or Primary Interface
>          Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
>          Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- 
> <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
>          Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
> DwFcInEn- LWO=16bit DwFcOutEn-
>          Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ 
> <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
>          Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit 
> DwFcInEn- LWO=8bit DwFcOutEn-
>          Revision ID: 3.00
>          Link Frequency 0: [b]
>          Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
>          Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 
> 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>          Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
>          Link Frequency 1: 200MHz
>          Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
>          Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 
> 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>          Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- 
> SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
>          Prefetchable memory behind bridge Upper: 00-00
>          Bus Number: 00
>      Capabilities: [54] HyperTransport: UnitID Clumping
>      Capabilities: [40] HyperTransport: Retry Mode
>      Capabilities: [9c] HyperTransport: #1a
>      Capabilities: [f8] HyperTransport: #1c
> 
> 00:01.0 PCI bridge: ASUSTeK Computer Inc. Unknown device 9602 (prog-if 
> 00 [Normal decode])
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64
>      Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
>      I/O behind bridge: 0000d000-0000dfff
>      Memory behind bridge: fe700000-fe8fffff
>      Prefetchable memory behind bridge: 00000000d0000000-00000000dff00000
>      Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>      BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>      Capabilities: [44] HyperTransport: MSI Mapping
>      Capabilities: [b0] #0d [0000]
> 
> 00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
> (PCIE port 5) (prog-if 00 [Normal decode])
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 0, Cache Line Size: 64 bytes
>      Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>      I/O behind bridge: 0000e000-0000efff
>      Memory behind bridge: fe900000-fe9fffff
>      Prefetchable memory behind bridge: 00000000fdf00000-00000000fdf00000
>      Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>      BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>      Capabilities: [50] Power Management version 3
>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>      Capabilities: [58] Express Root Port (Slot+) IRQ 0
>          Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
>          Device: Latency L0s <64ns, L1 <1us
>          Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>          Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>          Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>          Link: Supported Speed unknown, Width x1, ASPM L0s L1, Port 1
>          Link: Latency L0s <64ns, L1 <1us
>          Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
>          Link: Speed 2.5Gb/s, Width x1
>          Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>          Slot: Number 10, PowerLimit 25.000000
>          Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>          Slot: AttnInd Unknown, PwrInd Unknown, Power-
>          Root: Correctable- Non-Fatal- Fatal- PME-
>      Capabilities: [a0] Message Signalled Interrupts: 64bit- Queue=0/0 
> Enable+
>          Address: fee00000  Data: 40b9
>      Capabilities: [b0] #0d [0000]
>      Capabilities: [b8] HyperTransport: MSI Mapping
> 
> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA 
> Controller [IDE mode] (prog-if 01 [AHCI 1.0])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 217
>      Region 0: I/O ports at c000 [size=8]
>      Region 1: I/O ports at b000 [size=4]
>      Region 2: I/O ports at a000 [size=8]
>      Region 3: I/O ports at 9000 [size=4]
>      Region 4: I/O ports at 8000 [size=16]
>      Region 5: Memory at fe6ffc00 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [60] Power Management version 2
>          Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>      Capabilities: [70] #12 [0010]
> 
> 00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
> Controller (prog-if 10 [OHCI])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 193
>      Region 0: Memory at fe6fe000 (32-bit, non-prefetchable) [size=4K]
> 
> 00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller 
> (prog-if 10 [OHCI])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 193
>      Region 0: Memory at fe6fd000 (32-bit, non-prefetchable) [size=4K]
> 
> 00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
> Controller (prog-if 20 [EHCI])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin B routed to IRQ 201
>      Region 0: Memory at fe6ff800 (32-bit, non-prefetchable) [size=256]
>      Capabilities: [c0] Power Management version 2
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Bridge: PM- B3+
>      Capabilities: [e4] Debug port
> 
> 00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
> Controller (prog-if 10 [OHCI])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 169
>      Region 0: Memory at fe6fc000 (32-bit, non-prefetchable) [size=4K]
> 
> 00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller 
> (prog-if 10 [OHCI])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 169
>      Region 0: Memory at fe6fb000 (32-bit, non-prefetchable) [size=4K]
> 
> 00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
> Controller (prog-if 20 [EHCI])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin B routed to IRQ 209
>      Region 0: Memory at fe6ff400 (32-bit, non-prefetchable) [size=256]
>      Capabilities: [c0] Power Management version 2
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Bridge: PM- B3+
>      Capabilities: [e4] Debug port
> 
> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3c)
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort+ <MAbort- >SERR+ <PERR+
>      Capabilities: [b0] HyperTransport: MSI Mapping
> 
> 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller 
> (prog-if 8a [Master SecP PriP])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 0
>      Interrupt: pin A routed to IRQ 193
>      Region 0: I/O ports at <unassigned>
>      Region 1: I/O ports at <unassigned>
>      Region 2: I/O ports at <unassigned>
>      Region 3: I/O ports at <unassigned>
>      Region 4: I/O ports at ff00 [size=16]
>      Capabilities: [70] Message Signalled Interrupts: 64bit- Queue=0/1 
> Enable-
>          Address: 00000000  Data: 0000
> 
> 00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
>      Subsystem: ASUSTeK Computer Inc. Unknown device 836c
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin ? routed to IRQ 193
>      Region 0: Memory at fe6f4000 (64-bit, non-prefetchable) [size=16K]
>      Capabilities: [50] Power Management version 2
>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 0
> 
> 00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge 
> (prog-if 01 [Subtractive decode])
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64
>      Bus: primary=00, secondary=03, subordinate=05, sec-latency=64
>      I/O behind bridge: 0000f000-00000fff
>      Memory behind bridge: fea00000-febfffff
>      Prefetchable memory behind bridge: fff00000-000fffff
>      Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>      BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 
> 00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 
> Controller (prog-if 10 [OHCI])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 8389
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64, Cache Line Size: 64 bytes
>      Interrupt: pin C routed to IRQ 169
>      Region 0: Memory at fe6fa000 (32-bit, non-prefetchable) [size=4K]
> 
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, 
> Athlon64, Sempron] HyperTransport Configuration
>      Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Capabilities: [80] HyperTransport: Host or Secondary Interface
>          Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- 
> <EOCErr- DUL-
>          Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- 
> <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
>          Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
> DwFcInEn- LWO=16bit DwFcOutEn-
>          Revision ID: 3.00
>          Link Frequency: [b]
>          Link Error: <Prot- <Ovfl- <EOC- CTLTm-
>          Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 
> 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
>          Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- 
> ExtRS- UCnfE-
> 
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, 
> Athlon64, Sempron] Address Map
>      Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
> 
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, 
> Athlon64, Sempron] DRAM Controller
>      Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
> 
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, 
> Athlon64, Sempron] Miscellaneous Control
>      Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Capabilities: [f0] #0f [0010]
> 
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, 
> Athlon64, Sempron] Link Control
>      Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
> 
> 01:05.0 VGA compatible controller: ATI Technologies Inc Unknown device 
> 9710 (prog-if 00 [VGA controller])
>      Subsystem: ASUSTeK Computer Inc. Unknown device 83a2
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 0, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 10
>      Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
>      Region 1: I/O ports at d000 [size=256]
>      Region 2: Memory at fe8f0000 (32-bit, non-prefetchable) [size=64K]
>      Region 5: Memory at fe700000 (32-bit, non-prefetchable) [size=1M]
>      Capabilities: [50] Power Management version 3
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>      Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/0 
> Enable-
>          Address: 0000000000000000  Data: 0000
> 
> 01:05.1 Audio device: ATI Technologies Inc Unknown device 970f
>      Subsystem: ASUSTeK Computer Inc. Unknown device 83a2
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR+ <PERR-
>      Latency: 0, Cache Line Size: 64 bytes
>      Interrupt: pin B routed to IRQ 209
>      Region 0: Memory at fe8e8000 (32-bit, non-prefetchable) [size=16K]
>      Capabilities: [50] Power Management version 3
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>      Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/0 
> Enable-
>          Address: 0000000000000000  Data: 0000
> 
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
>      Subsystem: ASUSTeK Computer Inc. Unknown device 83a3
>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 0, Cache Line Size: 64 bytes
>      Interrupt: pin A routed to IRQ 225
>      Region 0: I/O ports at e800 [size=256]
>      Region 2: Memory at fdfff000 (64-bit, prefetchable) [size=4K]
>      Region 4: Memory at fdff8000 (64-bit, prefetchable) [size=16K]
>      Expansion ROM at fe9f0000 [disabled] [size=64K]
>      Capabilities: [40] Power Management version 3
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>      Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/0 
> Enable+
>          Address: 00000000fee01000  Data: 40e1
>      Capabilities: [70] Express Endpoint IRQ 1
>          Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>          Device: Latency L0s <512ns, L1 <64us
>          Device: AtnBtn- AtnInd- PwrInd-
>          Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>          Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>          Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
>          Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
>          Link: Latency L0s <512ns, L1 <64us
>          Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
>          Link: Speed 2.5Gb/s, Width x1
>      Capabilities: [ac] MSI-X: Enable- Mask- TabSize=4
>          Vector table: BAR=4 offset=00000000
>          PBA: BAR=4 offset=00000800
>      Capabilities: [cc] Vital Product Data
> 
> 03:05.0 PCI bridge: Pericom Semiconductor PCI to PCI Bridge (rev 02) 
> (prog-if 00 [Normal decode])
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR+
>      Latency: 64, Cache Line Size: 64 bytes
>      Bus: primary=03, secondary=04, subordinate=04, sec-latency=64
>      I/O behind bridge: 0000f000-00000fff
>      Memory behind bridge: fea00000-feafffff
>      Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
>      Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>      BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>      Capabilities: [dc] Power Management version 1
>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>      Capabilities: [b0] Slot ID: 0 slots, First-, chassis 00
> 
> 03:06.0 PCI bridge: Pericom Semiconductor PCI to PCI Bridge (rev 02) 
> (prog-if 00 [Normal decode])
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR+
>      Latency: 64, Cache Line Size: 64 bytes
>      Bus: primary=03, secondary=05, subordinate=05, sec-latency=64
>      I/O behind bridge: 0000f000-00000fff
>      Memory behind bridge: feb00000-febfffff
>      Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
>      Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>      BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>      Capabilities: [dc] Power Management version 1
>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>      Capabilities: [b0] Slot ID: 0 slots, First-, chassis 00
> 
> 04:08.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 233
>      Region 0: Memory at feaffc00 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:09.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 50
>      Region 0: Memory at feaff800 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:0a.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 217
>      Region 0: Memory at feaff400 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:0b.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 58
>      Region 0: Memory at feaff000 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 233
>      Region 0: Memory at feafec00 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:0d.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 50
>      Region 0: Memory at feafe800 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:0e.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 217
>      Region 0: Memory at feafe400 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:0f.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 58
>      Region 0: Memory at feafe000 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:08.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 50
>      Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:09.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 217
>      Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:0a.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 58
>      Region 0: Memory at febff400 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:0b.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 233
>      Region 0: Memory at febff000 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 50
>      Region 0: Memory at febfec00 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:0d.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 217
>      Region 0: Memory at febfe800 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:0e.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 58
>      Region 0: Memory at febfe400 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 05:0f.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
> Broadcast Decoder (rev 01)
>      Subsystem: Philips Semiconductors Unknown device 0000
>      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>      Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>      Latency: 64 (3750ns min, 9500ns max)
>      Interrupt: pin A routed to IRQ 233
>      Region 0: Memory at febfe000 (32-bit, non-prefetchable) [size=1K]
>      Capabilities: [40] Power Management version 1
>          Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>          Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> /proc/interrupts
>             CPU0       CPU1
>    0:    7723472          0    IO-APIC-edge  timer
>    1:         10          0    IO-APIC-edge  i8042
>    7:          0          0    IO-APIC-edge  parport0
>    8:          1          0    IO-APIC-edge  rtc
>    9:          0          0   IO-APIC-level  acpi
>   12:          5          0    IO-APIC-edge  i8042
>   14:        274      68449    IO-APIC-edge  ide0
>   50:          0          0   IO-APIC-level  saa7130[1], saa7130[5], 
> saa7130[8]
>   58:          0          0   IO-APIC-level  saa7130[3], saa7130[7]
> 169:          0          0   IO-APIC-level  ohci_hcd:usb5, 
> ohci_hcd:usb6, ohci_hcd:usb7
> 193:        324          0   IO-APIC-level  ohci_hcd:usb3, 
> ohci_hcd:usb4, HDA Intel
> 201:          2          0   IO-APIC-level  ehci_hcd:usb1
> 209:         18          0   IO-APIC-level  ehci_hcd:usb2, HDA Intel
> 217:      11012      11027   IO-APIC-level  ahci, saa7130[2], 
> saa7130[6], saa7130[9]
> 225:         30      10572         PCI-MSI  eth0
> 233:          0          0   IO-APIC-level  saa7130[0], saa7130[4]
> NMI:        883        571
> LOC:    7723384    7723312
> ERR:          0
> MIS:          0
>                5168:0138 4e42:0138
> 
> dmesg output after loading module
> saa7130/34: v4l2 driver version 0.2.14 loaded
> GSI 21 sharing vector 0xE9 and IRQ 21
> ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 20 (level, low) -> IRQ 233
> saa7130[0]: found at 0000:04:08.0, rev: 1, irq: 233, latency: 64, mmio: 
> 0xfeaffc00
> saa7130[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC [card=0,insmod 
> option]
> saa7130[0]: board init: gpio is 10000
> saa7130[0]: Huh, no eeprom present (err=-5)?
> saa7130[0]: registered device video0 [v4l2]
> saa7130[0]: registered device vbi0
> GSI 22 sharing vector 0x32 and IRQ 22
> ACPI: PCI Interrupt 0000:04:09.0[A] -> GSI 21 (level, low) -> IRQ 50
> saa7130[1]: found at 0000:04:09.0, rev: 1, irq: 50, latency: 64, mmio: 
> 0xfeaff800
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[1]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[1]: board init: gpio is 10000
> saa7130[1]: Huh, no eeprom present (err=-5)?
> saa7130[1]: registered device video1 [v4l2]
> saa7130[1]: registered device vbi1
> ACPI: PCI Interrupt 0000:04:0a.0[A] -> GSI 22 (level, low) -> IRQ 217
> saa7130[2]: found at 0000:04:0a.0, rev: 1, irq: 217, latency: 64, mmio: 
> 0xfeaff400
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[2]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[2]: board init: gpio is 10000
> saa7130[2]: Huh, no eeprom present (err=-5)?
> saa7130[2]: registered device video2 [v4l2]
> saa7130[2]: registered device vbi2
> GSI 23 sharing vector 0x3A and IRQ 23
> ACPI: PCI Interrupt 0000:04:0b.0[A] -> GSI 23 (level, low) -> IRQ 58
> saa7130[3]: found at 0000:04:0b.0, rev: 1, irq: 58, latency: 64, mmio: 
> 0xfeaff000
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[3]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[3]: board init: gpio is 10000
> saa7130[3]: Huh, no eeprom present (err=-5)?
> saa7130[3]: registered device video3 [v4l2]
> saa7130[3]: registered device vbi3
> ACPI: PCI Interrupt 0000:04:0c.0[A] -> GSI 20 (level, low) -> IRQ 233
> saa7130[4]: found at 0000:04:0c.0, rev: 1, irq: 233, latency: 64, mmio: 
> 0xfeafec00
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[4]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[4]: board init: gpio is 10000
> saa7130[4]: Huh, no eeprom present (err=-5)?
> saa7130[4]: registered device video4 [v4l2]
> saa7130[4]: registered device vbi4
> ACPI: PCI Interrupt 0000:04:0d.0[A] -> GSI 21 (level, low) -> IRQ 50
> saa7130[5]: found at 0000:04:0d.0, rev: 1, irq: 50, latency: 64, mmio: 
> 0xfeafe800
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[5]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[5]: board init: gpio is 10000
> saa7130[5]: Huh, no eeprom present (err=-5)?
> saa7130[5]: registered device video5 [v4l2]
> saa7130[5]: registered device vbi5
> ACPI: PCI Interrupt 0000:04:0e.0[A] -> GSI 22 (level, low) -> IRQ 217
> saa7130[6]: found at 0000:04:0e.0, rev: 1, irq: 217, latency: 64, mmio: 
> 0xfeafe400
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[6]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[6]: board init: gpio is 10000
> ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 193
> ACPI: PCI Interrupt 0000:01:05.1[B] -> GSI 19 (level, low) -> IRQ 209
> PCI: Setting latency timer of device 0000:01:05.1 to 64
> saa7130[6]: Huh, no eeprom present (err=-5)?
> saa7130[6]: registered device video6 [v4l2]
> saa7130[6]: registered device vbi6
> ACPI: PCI Interrupt 0000:04:0f.0[A] -> GSI 23 (level, low) -> IRQ 58
> saa7130[7]: found at 0000:04:0f.0, rev: 1, irq: 58, latency: 64, mmio: 
> 0xfeafe000
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[7]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[7]: board init: gpio is 10000
> saa7130[7]: Huh, no eeprom present (err=-5)?
> saa7130[7]: registered device video7 [v4l2]
> saa7130[7]: registered device vbi7
> ACPI: PCI Interrupt 0000:05:08.0[A] -> GSI 21 (level, low) -> IRQ 50
> saa7130[8]: found at 0000:05:08.0, rev: 1, irq: 50, latency: 64, mmio: 
> 0xfebffc00
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[8]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[8]: board init: gpio is 10000
> saa7130[8]: Huh, no eeprom present (err=-5)?
> saa7130[8]: registered device video8 [v4l2]
> saa7130[8]: registered device vbi8
> ACPI: PCI Interrupt 0000:05:09.0[A] -> GSI 22 (level, low) -> IRQ 217
> saa7130[9]: found at 0000:05:09.0, rev: 1, irq: 217, latency: 64, mmio: 
> 0xfebff800
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[9]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[9]: board init: gpio is 10000
> saa7130[9]: Huh, no eeprom present (err=-5)?
> saa7130[9]: registered device video9 [v4l2]
> saa7130[9]: registered device vbi9
> ACPI: PCI Interrupt 0000:05:0a.0[A] -> GSI 23 (level, low) -> IRQ 58
> saa7130[10]: found at 0000:05:0a.0, rev: 1, irq: 58, latency: 64, mmio: 
> 0xfebff400
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[10]: board init: gpio is 10000
> saa7130[10]: Huh, no eeprom present (err=-5)?
> saa7130[10]: can't register video device
> saa7134: probe of 0000:05:0a.0 failed with error -23
> ACPI: PCI Interrupt 0000:05:0b.0[A] -> GSI 20 (level, low) -> IRQ 233
> saa7130[10]: found at 0000:05:0b.0, rev: 1, irq: 233, latency: 64, mmio: 
> 0xfebff000
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[10]: board init: gpio is 10000
> saa7130[10]: Huh, no eeprom present (err=-5)?
> saa7130[10]: can't register video device
> saa7134: probe of 0000:05:0b.0 failed with error -23
> ACPI: PCI Interrupt 0000:05:0c.0[A] -> GSI 21 (level, low) -> IRQ 50
> saa7130[10]: found at 0000:05:0c.0, rev: 1, irq: 50, latency: 64, mmio: 
> 0xfebfec00
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[10]: board init: gpio is 10000
> saa7130[10]: Huh, no eeprom present (err=-5)?
> saa7130[10]: can't register video device
> saa7134: probe of 0000:05:0c.0 failed with error -23
> ACPI: PCI Interrupt 0000:05:0d.0[A] -> GSI 22 (level, low) -> IRQ 217
> saa7130[10]: found at 0000:05:0d.0, rev: 1, irq: 217, latency: 64, mmio: 
> 0xfebfe800
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[10]: board init: gpio is 10000
> saa7130[10]: Huh, no eeprom present (err=-5)?
> saa7130[10]: can't register video device
> saa7134: probe of 0000:05:0d.0 failed with error -23
> ACPI: PCI Interrupt 0000:05:0e.0[A] -> GSI 23 (level, low) -> IRQ 58
> saa7130[10]: found at 0000:05:0e.0, rev: 1, irq: 58, latency: 64, mmio: 
> 0xfebfe400
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[10]: board init: gpio is 10000
> saa7130[10]: Huh, no eeprom present (err=-5)?
> saa7130[10]: can't register video device
> saa7134: probe of 0000:05:0e.0 failed with error -23
> ACPI: PCI Interrupt 0000:05:0f.0[A] -> GSI 20 (level, low) -> IRQ 233
> saa7130[10]: found at 0000:05:0f.0, rev: 1, irq: 233, latency: 64, mmio: 
> 0xfebfe000
> saa7134: <rant>
> saa7134:  Congratulations!  Your TV card vendor saved a few
> saa7134:  cents for a eeprom, thus your pci board has no
> saa7134:  subsystem ID and I can't identify it automatically
> saa7134: </rant>
> saa7134: I feel better now.  Ok, here are the good news:
> saa7134: You can use the card=<nr> insmod option to specify
> saa7134: which board do you have.  The list:
> saa7134:   card=0 -> UNKNOWN/GENERIC
> saa7134:   card=1 -> Proteus Pro [philips reference design]   1131:2001 
> 1131:2001
> saa7134:   card=2 -> LifeView FlyVIDEO3000                    5168:0138 
> 4e42:0138
> saa7134:   card=3 -> LifeView/Typhoon FlyVIDEO2000            5168:0138 
> 4e42:0138
> saa7134:   card=4 -> EMPRESS                                  1131:6752
> saa7134:   card=5 -> SKNet Monster TV                         1131:4e85
> saa7134:   card=6 -> Tevion MD 9717
> saa7134:   card=7 -> KNC One TV-Station RDS / Typhoon TV Tune 1131:fe01 
> 1894:fe01
> saa7134:   card=8 -> Terratec Cinergy 400 TV                  153b:1142
> saa7134:   card=9 -> Medion 5044
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=11 -> Terratec Cinergy 600 TV                  153b:1143
> saa7134:   card=12 -> Medion 7134                              16be:0003
> saa7134:   card=13 -> Typhoon TV+Radio 90031
> saa7134:   card=14 -> ELSA EX-VISION 300TV                     1048:226b
> saa7134:   card=15 -> ELSA EX-VISION 500TV                     1048:226a
> saa7134:   card=16 -> ASUS TV-FM 7134                          1043:4842 
> 1043:4830 1043:4840
> saa7134:   card=17 -> AOPEN VA1000 POWER                       1131:7133
> saa7134:   card=18 -> BMK MPEX No Tuner
> saa7134:   card=19 -> Compro VideoMate TV                      185b:c100
> saa7134:   card=20 -> Matrox CronosPlus                        102b:48d0
> saa7134:   card=21 -> 10MOONS PCI TV CAPTURE CARD              1131:2001
> saa7134:   card=22 -> AverMedia M156 / Medion 2819             1461:a70b
> saa7134:   card=23 -> BMK MPEX Tuner
> saa7134:   card=24 -> KNC One TV-Station DVR                   1894:a006
> saa7134:   card=25 -> ASUS TV-FM 7133                          1043:4843
> saa7134:   card=26 -> Pinnacle PCTV Stereo (saa7134)           11bd:002b
> saa7134:   card=27 -> Manli MuchTV M-TV002/Behold TV 403 FM
> saa7134:   card=28 -> Manli MuchTV M-TV001/Behold TV 401
> saa7134:   card=29 -> Nagase Sangyo TransGear 3000TV           1461:050c
> saa7134:   card=30 -> Elitegroup ECS TVP3XP FM1216 Tuner Card( 1019:4cb4
> saa7134:   card=31 -> Elitegroup ECS TVP3XP FM1236 Tuner Card  1019:4cb5
> saa7134:   card=32 -> AVACS SmartTV
> saa7134:   card=33 -> AVerMedia DVD EZMaker                    1461:10ff
> saa7134:   card=34 -> Noval Prime TV 7133
> saa7134:   card=35 -> AverMedia AverTV Studio 305              1461:2115
> saa7134:   card=36 -> UPMOST PURPLE TV                         12ab:0800
> saa7134:   card=37 -> Items MuchTV Plus / IT-005
> saa7134:   card=38 -> Terratec Cinergy 200 TV                  153b:1152
> saa7134:   card=39 -> LifeView FlyTV Platinum Mini             5168:0212 
> 4e42:0212
> saa7134:   card=40 -> Compro VideoMate TV PVR/FM               185b:c100
> saa7134:   card=41 -> Compro VideoMate TV Gold+                185b:c100
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7134:   card=43 -> :Zolid Xpert TV7134
> saa7134:   card=44 -> Empire PCI TV-Radio LE
> saa7134:   card=45 -> Avermedia AVerTV Studio 307              1461:9715
> saa7134:   card=46 -> AVerMedia Cardbus TV/Radio (E500)        1461:d6ee
> saa7134:   card=47 -> Terratec Cinergy 400 mobile              153b:1162
> saa7134:   card=48 -> Terratec Cinergy 600 TV MK3              153b:1158
> saa7134:   card=49 -> Compro VideoMate Gold+ Pal               185b:c200
> saa7134:   card=50 -> Pinnacle PCTV 300i DVB-T + PAL           11bd:002d
> saa7134:   card=51 -> ProVideo PV952                           1540:9524
> saa7134:   card=52 -> AverMedia AverTV/305                     1461:2108
> saa7134:   card=53 -> ASUS TV-FM 7135                          1043:4845
> saa7134:   card=54 -> LifeView FlyTV Platinum FM / Gold        5168:0214 
> 1489:0214 5168:0304
> saa7134:   card=55 -> LifeView FlyDVB-T DUO                    5168:0306
> saa7134:   card=56 -> Avermedia AVerTV 307                     1461:a70a
> saa7134:   card=57 -> Avermedia AVerTV GO 007 FM               1461:f31f
> saa7134:   card=58 -> ADS Tech Instant TV (saa7135)            1421:0350 
> 1421:0351 1421:0370 1421:1370
> saa7134:   card=59 -> Kworld/Tevion V-Stream Xpert TV PVR7134
> saa7134:   card=60 -> LifeView/Typhoon FlyDVB-T Duo Cardbus    5168:0502 
> 4e42:0502
> saa7134:   card=61 -> Philips TOUGH DVB-T reference design     1131:2004
> saa7134:   card=62 -> Compro VideoMate TV Gold+II
> saa7134:   card=63 -> Kworld Xpert TV PVR7134
> saa7134:   card=64 -> FlyTV mini Asus Digimatrix               1043:0210
> saa7134:   card=65 -> V-Stream Studio TV Terminator
> saa7134:   card=66 -> Yuan TUN-900 (saa7135)
> saa7134:   card=67 -> Beholder BeholdTV 409 FM                 0000:4091
> saa7134:   card=68 -> GoTView 7135 PCI                         5456:7135
> saa7134:   card=69 -> Philips EUROPA V3 reference design       1131:2004
> saa7134:   card=70 -> Compro Videomate DVB-T300                185b:c900
> saa7134:   card=71 -> Compro Videomate DVB-T200                185b:c901
> saa7134:   card=72 -> RTD Embedded Technologies VFG7350        1435:7350
> saa7134:   card=73 -> RTD Embedded Technologies VFG7330        1435:7330
> saa7134:   card=74 -> LifeView FlyTV Platinum Mini2            14c0:1212
> saa7134:   card=75 -> AVerMedia AVerTVHD MCE A180              1461:1044
> saa7134:   card=76 -> SKNet MonsterTV Mobile                   1131:4ee9
> saa7134:   card=77 -> Pinnacle PCTV 40i/50i/110i (saa7133)     11bd:002e
> saa7134:   card=78 -> ASUSTeK P7131 Dual                       1043:4862
> saa7134:   card=79 -> Sedna/MuchTV PC TV Cardbus TV/Radio (ITO
> saa7134:   card=80 -> ASUS Digimatrix TV                       1043:0210
> saa7134:   card=81 -> Philips Tiger reference design           1131:2018
> saa7134:   card=82 -> MSI TV@Anywhere plus                     1462:6231
> saa7134:   card=83 -> Terratec Cinergy 250 PCI TV              153b:1160
> saa7134:   card=84 -> LifeView FlyDVB Trio                     5168:0319
> saa7134:   card=85 -> AverTV DVB-T 777                         1461:2c05
> saa7134:   card=86 -> LifeView FlyDVB-T / Genius VideoWonder D 5168:0301 
> 1489:0301
> saa7134:   card=87 -> ADS Instant TV Duo Cardbus PTV331        0331:1421
> saa7134:   card=88 -> Tevion/KWorld DVB-T 220RF                17de:7201
> saa7134:   card=89 -> ELSA EX-VISION 700TV                     1048:226c
> saa7134:   card=90 -> Kworld ATSC110                           17de:7350
> saa7134:   card=91 -> AVerMedia A169 B                         1461:7360
> saa7134:   card=92 -> AVerMedia A169 B1                        1461:6360
> saa7134:   card=93 -> Medion 7134 Bridge #2                    16be:0005
> saa7134:   card=94 -> LifeView FlyDVB-T Hybrid Cardbus         5168:3306 
> 5168:3502
> saa7134:   card=95 -> LifeView FlyVIDEO3000 (NTSC)             5169:0138
> saa7130[10]: subsystem: 1131:0000, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> saa7130[10]: board init: gpio is 10000
> saa7130[10]: Huh, no eeprom present (err=-5)?
> saa7130[10]: can't register video device
> saa7134: probe of 0000:05:0f.0 failed with error -23

