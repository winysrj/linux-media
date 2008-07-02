Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from av8-1-sn3.vrr.skanova.net ([81.228.9.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <romek@rb-tech.net>) id 1KEAK0-0002vW-QZ
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 23:57:09 +0200
Received: from smtp3-1-sn3.vrr.skanova.net (smtp3-1-sn3.vrr.skanova.net
	[81.228.9.101])
	by av8-1-sn3.vrr.skanova.net (Postfix) with ESMTP id 08B9C38512
	for <linux-dvb@linuxtv.org>; Wed,  2 Jul 2008 23:56:24 +0200 (CEST)
Received: from bigburken (217-210-186-36-no38.tbcn.telia.com [217.210.186.36])
	by smtp3-1-sn3.vrr.skanova.net (Postfix) with SMTP id 45F9A37E42
	for <linux-dvb@linuxtv.org>; Wed,  2 Jul 2008 23:56:24 +0200 (CEST)
Message-ID: <D5C85BFC6A704F71BB8D2A4BFE3E182C@bigburken>
From: "Romek." <romek@rb-tech.net>
To: <linux-dvb@linuxtv.org>
References: <mailman.10.1215033730.872.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.10.1215033730.872.linux-dvb@linuxtv.org>
Date: Wed, 2 Jul 2008 23:55:29 +0200
MIME-Version: 1.0
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 42, Issue 6
Reply-To: "Romek." <romek@rb-tech.net>
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

please unsubscribe me


----- Original Message ----- 
From: <linux-dvb-request@linuxtv.org>
To: <linux-dvb@linuxtv.org>
Sent: Wednesday, July 02, 2008 11:22 PM
Subject: linux-dvb Digest, Vol 42, Issue 6


> Send linux-dvb mailing list submissions to
> linux-dvb@linuxtv.org
>
> To subscribe or unsubscribe via the World Wide Web, visit
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> or, via email, send a message with subject or body 'help' to
> linux-dvb-request@linuxtv.org
>
> You can reach the person managing the list at
> linux-dvb-owner@linuxtv.org
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of linux-dvb digest..."
>
>
> Today's Topics:
>
>   1. [PATCH] Shrink saa7134 mmio mapped size (Andy Burns)
>   2. Re: [PATCH] Shrink saa7134 mmio mapped size (Matthias Schwarzott)
>   3. Re: [PATCH] Shrink saa7134 mmio mapped size (Andy Burns)
>   4. Re: [PATCH] Shrink saa7134 mmio mapped size (Andy Burns)
>   5. Re: [PATCH] Shrink saa7134 mmio mapped size (hermann pitton)
>   6. "Slave RACK Fail" on Technisat CableStar HD2 (Sebastian Wolf)
>   7. NXP saa7164 support (Steven Toth)
>   8. Re: [PATCH] Shrink saa7134 mmio mapped size (Andy Burns)
>   9. Re: NXP saa7164 support (Craig Whitmore)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Wed, 02 Jul 2008 15:52:32 +0100
> From: Andy Burns <linux-dvb@adslpipe.co.uk>
> Subject: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
> To: Linux DVB List <linux-dvb@linuxtv.org>
> Message-ID: <486B9630.1080100@adslpipe.co.uk>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
> The saa7134 driver attempts to map 4K starting from the base address of
> its mmio area, although lspci shows the size of the area is only 1K. The
> excessive mapping goes un-noticed on bare-metal, but is detected and
> denied when the card is used with pci passthrough to a xen domU. If
> shared IRQ is used the "pollirq" kernel option may be required in dom0.
>
> Signed-off-by: Andy Burns <andy@burns.net>
> --- drivers/media/video/saa7134/saa7134-core.c.orig     2008-07-01
> 16:46:49.000000000 +0100
> +++ drivers/media/video/saa7134/saa7134-core.c  2008-07-01
> 16:47:10.000000000 +0100
> @@ -908,7 +908,7 @@
>                        dev->name,(unsigned long
> long)pci_resource_start(pci_dev,0));
>                 goto fail1;
>         }
> -       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
> +       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x400);
>         dev->bmmio = (__u8 __iomem *)dev->lmmio;
>         if (NULL == dev->lmmio) {
>                 err = -EIO;
>
>
>
>
>
> ------------------------------
>
> Message: 2
> Date: Wed, 2 Jul 2008 17:12:53 +0200
> From: Matthias Schwarzott <zzam@gentoo.org>
> Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
> To: linux-dvb@linuxtv.org
> Message-ID: <200807021712.53659.zzam@gentoo.org>
> Content-Type: text/plain;  charset="iso-8859-1"
>
> On Mittwoch, 2. Juli 2008, Andy Burns wrote:
>> The saa7134 driver attempts to map 4K starting from the base address of
>> its mmio area, although lspci shows the size of the area is only 1K. The
>> excessive mapping goes un-noticed on bare-metal, but is detected and
>> denied when the card is used with pci passthrough to a xen domU. If
>> shared IRQ is used the "pollirq" kernel option may be required in dom0.
>>
>
> I have no real insight into the saa7134 core, but at least my card does 
> have a
> memory region of 2K.
>
> lspci -vvnn:
> 00:0b.0 Multimedia controller [0480]: Philips Semiconductors 
> SAA7133/SAA7135
> Video Broadcast Decoder [1131:7133] (rev d1)
>        Subsystem: Avermedia Technologies Inc Device [1461:a7a1]
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32 (63750ns min, 63750ns max)
>        Interrupt: pin A routed to IRQ 19
>        Region 0: Memory at dfffb800 (32-bit, non-prefetchable) [size=2K]
>        Capabilities: [40] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=3 PME-
>        Kernel driver in use: saa7134
>        Kernel modules: saa7134
>
> Regards
> Matthias
>
>
>
> ------------------------------
>
> Message: 3
> Date: Wed, 02 Jul 2008 16:35:25 +0100
> From: Andy Burns <linux-dvb@adslpipe.co.uk>
> Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
> To: Linux DVB List <linux-dvb@linuxtv.org>
> Message-ID: <486BA03D.4040904@adslpipe.co.uk>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
> On 02/07/2008 16:12, Matthias Schwarzott wrote:
>
>> I have no real insight into the saa7134 core, but at least my card does 
>> have a
>> memory region of 2K.
>
> Thanks, I only have one type of card, I'll try to investigate the best
> way to programatically determine the size of the memory region and use
> that instead of a hard-coded value, then resubmit a new patch.
>
>
>
>
>
> ------------------------------
>
> Message: 4
> Date: Wed, 02 Jul 2008 16:50:06 +0100
> From: Andy Burns <linux-dvb@adslpipe.co.uk>
> Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
> To: Linux DVB List <linux-dvb@linuxtv.org>
> Message-ID: <486BA3AE.1020808@adslpipe.co.uk>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
> The saa7134 driver attempts to map a fixed 4K starting from the base
> address of its mmio area, regardless of the actual size of the area.
> Any excessive mapping may extend past the end of a page, which goes
> un-noticed on bare-metal, but is detected and denied when the card is
> used with pci passthrough to a xen domU. If shared IRQ is used the
> "pollirq" kernel option may be required in dom0.
>
> Signed-off-by: Andy Burns <andy@burns.net>
> ---- drivers/media/video/saa7134/saa7134-core.c.orig     2008-07-01
> 16:46:49.000000000 +0100
> +++ drivers/media/video/saa7134/saa7134-core.c  2008-07-02
> 16:41:37.000000000 +0100
> @@ -908,7 +908,8 @@
>                        dev->name,(unsigned long
> long)pci_resource_start(pci_dev,0));
>                 goto fail1;
>         }
> -       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
> +       dev->lmmio = ioremap(pci_resource_start(pci_dev,0),
> +                             pci_resource_len(pci_dev,0));
>         dev->bmmio = (__u8 __iomem *)dev->lmmio;
>         if (NULL == dev->lmmio) {
>                 err = -EIO;
>
>
>
>
> ------------------------------
>
> Message: 5
> Date: Wed, 02 Jul 2008 22:39:35 +0200
> From: hermann pitton <hermann-pitton@arcor.de>
> Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
> To: Andy Burns <linux-dvb@adslpipe.co.uk>
> Cc: video4linux-list@redhat.com, Linux DVB List
> <linux-dvb@linuxtv.org>
> Message-ID: <1215031175.2624.7.camel@pc10.localdom.local>
> Content-Type: text/plain
>
> Hello,
>
> Am Mittwoch, den 02.07.2008, 16:50 +0100 schrieb Andy Burns:
>> The saa7134 driver attempts to map a fixed 4K starting from the base
>> address of its mmio area, regardless of the actual size of the area.
>> Any excessive mapping may extend past the end of a page, which goes
>> un-noticed on bare-metal, but is detected and denied when the card is
>> used with pci passthrough to a xen domU. If shared IRQ is used the
>> "pollirq" kernel option may be required in dom0.
>
> just a note.
>
> We have some recent remotes sampling from IRQs triggered by a gpio pin
> without any additional IR chip.
>
> There are some reports that "pollirq" makes them unusable, since
> sensible timings are lost.
>
> No such reports from xen stuff yet, but the same might happen with
> shared IRQs and "pollirq" there too.
>
> Cheers,
> Hermann
>
>
>> Signed-off-by: Andy Burns <andy@burns.net>
>> ---- drivers/media/video/saa7134/saa7134-core.c.orig     2008-07-01
>> 16:46:49.000000000 +0100
>> +++ drivers/media/video/saa7134/saa7134-core.c  2008-07-02
>> 16:41:37.000000000 +0100
>> @@ -908,7 +908,8 @@
>>                         dev->name,(unsigned long
>> long)pci_resource_start(pci_dev,0));
>>                  goto fail1;
>>          }
>> -       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
>> +       dev->lmmio = ioremap(pci_resource_start(pci_dev,0),
>> +                             pci_resource_len(pci_dev,0));
>>          dev->bmmio = (__u8 __iomem *)dev->lmmio;
>>          if (NULL == dev->lmmio) {
>>                  err = -EIO;
>>
>>
>
>
>
>
>
> ------------------------------
>
> Message: 6
> Date: Wed, 2 Jul 2008 22:57:55 +0200
> From: Sebastian Wolf <sebastian@ygriega.de>
> Subject: [linux-dvb] "Slave RACK Fail" on Technisat CableStar HD2
> To: linux-dvb@linuxtv.org
> Message-ID: <200807022257.55589.sebastian@ygriega.de>
> Content-Type: text/plain; charset="us-ascii"
>
> Hi all,
>
> some days ago I bought the DVB-C Card 'Technisat CableStar HD2'. After 
> I've
> installed it I did a short test on Win XP SP3 - the card is working 
> properly
> there.
>
> In order to make it work under Linux, I compiled and installed the latest
> mantis sources (downloaded from http://jusst.de/hg/mantis). The 
> compilation
> was successful after I've patched the sources with
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/fix-jdelvare-i2c-i2c-constify-client-address-data.patch
> and after I've deactivated the option KS0127.
>
> The modes are now loaded successfully (at least it seems so) during boot.
> However, a channel search is never successful, no matter which transponder
> list or frontend application (or directly dvbscan) I use.
>
> dmesg shows after the failed scan:
>
> mantis_ack_wait (0): Slave RACK Fail !
>
> I did a search and only found a few comments and linux-dvb mails on the 
> web,
> but no solution to this problem, so I'm contacting you directly.
>
> Here is some information about my system:
>
> - openSUSE 11.0
> - uname -r: 2.6.25.5-1.1-pae
>
> dmesg shows (on module load):
>
> ACPI: PCI Interrupt 0000:02:07.0[A] -> GSI 22 (level, low) -> IRQ 22
> irq: 22, latency: 64
> memory: 0xf8fff000, mmio: 0xf9652000
> found a VP-2040 PCI DVB-C device on (02:07.0),
>    Mantis Rev 1 [1ae4:0002], irq: 22, latency: 64
>    memory: 0xf8fff000, mmio: 0xf9652000
>    MAC Address=[00:08:c9:d0:11:98]
> mantis_alloc_buffers (0): DMA=0x36810000 cpu=0xf6810000 size=65536
> mantis_alloc_buffers (0): RISC=0x37f94000 cpu=0xf7f94000 size=1000
> DVB: registering new adapter (Mantis dvb adapter)
> mantis_frontend_init (0): Probing for CU1216 (DVB-C)
> mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @
> 0x0c
> mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach 
> success
> DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
> mantis_ca_init (0): Registering EN50221 device
> mantis_ca_init (0): Registered EN50221 device
> mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
>
> /dev/dvb/adapter0 contains:
> -ca0
> -demux0
> -dvr0
> -frontend0
> -net0
>
> lsmod output is attached...
>
> If I can provide more information in order to solve the problem, I will
> definitely do so, just give me some hints. ;-)
>
> Thanks in advance and best regards,
>
> Sebastian
> -------------- next part --------------
> Module                  Size  Used by
> iptable_filter         19840  0
> ip_tables              30224  1 iptable_filter
> snd_pcm_oss            64256  0
> snd_mixer_oss          33408  1 snd_pcm_oss
> snd_seq_midi           26112  0
> ip6table_filter        19712  0
> ip6_tables             31376  1 ip6table_filter
> snd_emu10k1_synth      24832  0
> x_tables               33668  2 ip_tables,ip6_tables
> snd_emux_synth         54272  1 snd_emu10k1_synth
> ipv6                  281064  22
> snd_seq_virmidi        23680  1 snd_emux_synth
> snd_seq_midi_event     23936  2 snd_seq_midi,snd_seq_virmidi
> snd_seq_midi_emul      22784  1 snd_emux_synth
> snd_seq                73664  5 
> snd_seq_midi,snd_emux_synth,snd_seq_virmidi,snd_seq_midi_event,snd_seq_midi_emul
> af_packet              38656  0
> cpufreq_conservative    24456  0
> cpufreq_userspace      22660  0
> cpufreq_powersave      18176  0
> powernow_k8            31748  0
> sha256_generic         28800  0
> aes_i586               24704  2
> aes_generic            44072  1 aes_i586
> cbc                    20736  1
> uhci_hcd               40848  0
> dm_crypt               32132  1
> crypto_blkcipher       36356  3 cbc,dm_crypt
> fuse                   66332  3
> loop                   35332  0
> dm_mod                 78676  3 dm_crypt
> snd_emu10k1           162948  3 snd_emu10k1_synth
> snd_rawmidi            42496  3 snd_seq_midi,snd_seq_virmidi,snd_emu10k1
> firmware_class         25984  1 snd_emu10k1
> snd_ac97_codec        120868  1 snd_emu10k1
> mantis                 59396  0
> ac97_bus               18304  1 snd_ac97_codec
> lnbp21                 18560  1 mantis
> snd_pcm               100100  3 snd_pcm_oss,snd_emu10k1,snd_ac97_codec
> mb86a16                36096  1 mantis
> snd_seq_device         25100  6 
> snd_seq_midi,snd_emu10k1_synth,snd_emux_synth,snd_seq,snd_emu10k1,snd_rawmidi
> stb6100                24196  1 mantis
> tda10021               22788  1 mantis
> snd_timer              40712  3 snd_seq,snd_emu10k1,snd_pcm
> tda10023               22788  1 mantis
> snd_page_alloc         27400  2 snd_emu10k1,snd_pcm
> i2c_piix4              25484  0
> snd_util_mem           21632  2 snd_emux_synth,snd_emu10k1
> stb0899                52352  1 mantis
> usbhid                 60260  0
> 8139too                43008  0
> stv0299                27016  1 mantis
> rtc_cmos               27168  0
> snd_hwdep              26372  2 snd_emux_synth,snd_emu10k1
> 8139cp                 39808  0
> dvb_core              104296  2 mantis,stv0299
> nvidia               7121088  24
> sr_mod                 33320  0
> ati_agp                25484  0
> snd                    79544  20 
> snd_pcm_oss,snd_mixer_oss,snd_seq_midi,snd_emu10k1_synth,snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq,snd_emu10k1,snd_rawmidi,snd_ac97_codec,snd_pcm,snd_seq_device,snd_timer,snd_util_mem,snd_hwdep
> rtc_core               37148  1 rtc_cmos
> ohci1394               48432  0
> hid                    53708  1 usbhid
> emu10k1_gp             20224  0
> ieee1394              107016  1 ohci1394
> rtc_lib                19328  1 rtc_core
> gameport               31500  2 emu10k1_gp
> cdrom                  50588  1 sr_mod
> button                 25360  0
> mii                    21888  2 8139too,8139cp
> i2c_core               41108  10 
> mantis,lnbp21,mb86a16,stb6100,tda10021,tda10023,i2c_piix4,stb0899,stv0299,nvidia
> agpgart                50868  2 nvidia,ati_agp
> soundcore              24264  1 snd
> ff_memless             21896  1 usbhid
> sg                     52020  0
> ehci_hcd               52492  0
> ohci_hcd               39940  0
> sd_mod                 45208  5
> usbcore               164684  5 uhci_hcd,usbhid,ehci_hcd,ohci_hcd
> edd                    26440  0
> ext3                  155784  2
> mbcache                25348  1 ext3
> jbd                    73376  1 ext3
> fan                    22660  0
> ahci                   45960  4
> pata_atiixp            24320  0
> libata                176220  2 ahci,pata_atiixp
> scsi_mod              168308  4 sr_mod,sg,sd_mod,libata
> dock                   27536  1 libata
> thermal                39452  0
> processor              67504  2 powernow_k8,thermal
>
> ------------------------------
>
> Message: 7
> Date: Wed, 02 Jul 2008 16:58:04 -0400
> From: Steven Toth <stoth@linuxtv.org>
> Subject: [linux-dvb] NXP saa7164 support
> To: linux-dvb <linux-dvb@linuxtv.org>, Linux and Kernel Video
> <video4linux-list@redhat.com>
> Message-ID: <486BEBDC.9010107@linuxtv.org>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
> Hey,
>
> I've started a new driver project for the saa7164 PCIe bridge based
> boards, which is used in the Hauppauge HVR2200 and HVR2250 dual tuner
> products.
>
> If anyone else is already working on this then please email me.
>
> Regards,
>
> Steve
>
>
>
> ------------------------------
>
> Message: 8
> Date: Wed, 02 Jul 2008 22:00:00 +0100
> From: Andy Burns <linux-dvb@adslpipe.co.uk>
> Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
> To: Linux DVB List <linux-dvb@linuxtv.org>
> Message-ID: <486BEC50.2080009@adslpipe.co.uk>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
> On 02/07/2008 21:39, hermann pitton wrote:
>
>> We have some recent remotes sampling from IRQs triggered by a gpio pin
>> without any additional IR chip.
>>
>> There are some reports that "pollirq" makes them unusable, since
>> sensible timings are lost.
>
> Thanks for the info, not relevant for me though, the whole point of
> virtualising my mythtv backend with xen is to stuff all the noisy bits
> is a cupboard and have a separate frontend which does have a LiRC device.
>
>> No such reports from xen stuff yet, but the same might happen with
>> shared IRQs and "pollirq" there too.
>
> After I'd sorted the mmio mapping issue, the driver loaded under xen,
> but crashed after 40 seconds or so due to shared interrupt routing, so I
> added the pollirq, I understand this might cause performance issues as
> IRQs have to be delivered to multiple drivers in different xen domains,
> particularly one of my PCI slots shares with a PCI-X slot which has my
> 8xSATA card in it, so I've avoided that slot for now, but would like to
> have dual tuner again.
>
> The driver is now working fairly well under xen, with a single tuner
> mythbckend can record three concurrent streams from a mux, with under
> 10% CPU.
>
> I have one remaining issue, which I will try to track down, every now
> and then I seem to get a DMA error causing a kernel panic, my feeling is
> it happens when retuning;  perhaps some DMA transfer is in-flight when
> something changes on the card and causes a problem? Or like the
> ioremap() it might be something xen is more sensitive to than a
> bare-metal machine.
>
> Do I need to send my patch direct to Harmut Hackmann, or will he pick it
> up from the list if he likes it?
>
>
>
>
>
> ------------------------------
>
> Message: 9
> Date: Thu, 03 Jul 2008 09:21:54 +1200
> From: Craig Whitmore <lennon@orcon.net.nz>
> Subject: Re: [linux-dvb] NXP saa7164 support
> To: Steven Toth <stoth@linuxtv.org>
> Cc: Linux and Kernel Video <video4linux-list@redhat.com>, linux-dvb
> <linux-dvb@linuxtv.org>
> Message-ID: <1215033714.24804.3.camel@localhost>
> Content-Type: text/plain
>
>
> On Wed, 2008-07-02 at 16:58 -0400, Steven Toth wrote:
>> Hey,
>>
>> I've started a new driver project for the saa7164 PCIe bridge based
>> boards, which is used in the Hauppauge HVR2200 and HVR2250 dual tuner
>> products.
>>
>> If anyone else is already working on this then please email me.
>>
>> Regards,
>>
>
> I've been waiting (and alot of other people in NZ using mythtv for
> drivers for this). If you have any initial drivers started to be wirrten
> I would be very helpful in getting it working correctly
>
> Thanks
>
>
>
>
>
> ------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> End of linux-dvb Digest, Vol 42, Issue 6
> **************************************** 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
