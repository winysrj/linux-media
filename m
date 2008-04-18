Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goran.sterjov@gmail.com>) id 1Jmu12-0007j5-E5
	for linux-dvb@linuxtv.org; Fri, 18 Apr 2008 19:04:49 +0200
Received: by wx-out-0506.google.com with SMTP id s11so571555wxc.17
	for <linux-dvb@linuxtv.org>; Fri, 18 Apr 2008 10:04:41 -0700 (PDT)
From: Goran Sterjov <goran.sterjov@gmail.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <91649120804180932x433744dp6099008afbe78a@mail.gmail.com>
References: <91649120804171303l607caf27s6bdc6b56b2a959a9@mail.gmail.com>
	<91649120804180932x433744dp6099008afbe78a@mail.gmail.com>
Date: Sat, 19 Apr 2008 03:04:34 +1000
Message-Id: <1208538274.6271.6.camel@goran-laptop>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Twinhan 1034 (Azurewave SP-300) with Mantis from hg
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

On Fri, 2008-04-18 at 18:32 +0200, Kareem Kenawy wrote:
> i've compiled mantis from hg on Ubuntu Hardy 2.6.24-16-generic
> The card is identified and has node at /dev/dvb/ but scanning doesn't
> work (verified hardware/setup/cables using another pci the sp200 which
> worked)
>  the dmesg output after scanning:
> 
>  [  564.730156] mb86a16_write: writing to [0x08],Reg[0x2b],Data[0xad]
> [  564.730853] mb86a16_write: writing to [0x08],Reg[0x2c],Data[0x0f]
> [  564.731550] mb86a16_write: writing to [0x08],Reg[0x0c],Data[0x04]
> [  564.738460] mb86a16_set_fe: NO  -- SIGNAL
> [  564.739157] sync_chk: Status = 00,
> [  564.740550] mb86a16_set_fe: AGC = e2 CNM = 00
> [  566.173404] mantis start feed & dma
> [  566.173429] BUG: unable to handle kernel paging request at virtual
> address 08a25fff
> [  566.173435] printing eip: f8b22b59 *pde = 00000000
> [  566.173442] Oops: 0000 [#1] SMP
> [  566.173446] Modules linked in: af_packet i915 drm rfcomm l2cap
> bluetooth ppdev ipv6 acpi_cpufreq cpufreq_conservative cpufreq_stats
> cpufreq_userspace cpufreq_ondemand cpufreq_powersave freq_table dock
> video output sbs sbshc battery iptable_filter ip_tables x_tables ac lp
> snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep
> snd_seq_dummy snd_seq_oss snd_seq_midi psmouse snd_rawmidi serio_raw
> mantis snd_seq_midi_event lnbp21 mb86a16 snd_seq snd_timer
> snd_seq_device iTCO_wdt stb6100 iTCO_vendor_support container parport_pc
> parport tda10021 tda10023 stb0899 stv0299 snd button dvb_core intel_agp
> agpgart soundcore evdev i2c_core shpchp pci_hotplug pcspkr usbhid hid
> ext3 jbd mbcache sg sr_mod cdrom sd_mod pata_acpi ata_generic floppy
> ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore tg3 thermal processor
> fan fbcon tileblit font bitblit softcursor fuse
> [  566.173535]
> [  566.173539] Pid: 6975, comm: scan Not tainted (2.6.24-16-generic #1)
> [  566.173543] EIP: 0060:[<f8b22b59>] EFLAGS: 00010206 CPU: 0
> [  566.173556] EIP is at mantis_dma_start+0x129/0x200 [mantis]
> [  566.173559] EAX: 37645000 EBX: 0000003d ECX: 00000042 EDX: f8a26000
> [  566.173563] ESI: f76450f0 EDI: f7711800 EBP: 0000f800 ESP: dd0c1e08
> [  566.173566]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  566.173570] Process scan (pid: 6975, ti=dd0c0000 task=dd061680
> task.ti=dd0c0000)
> [  566.173573] Stack: 000200d2 00000163 f7711800 f7711cb4 00000000
> 00000020 f7711800 f7711cb4
> [  566.173583]        00000000 f8c01000 f8b245ce f8b28abb f8a2ab0d
> 00000002 00000163 00000012
> [  566.173592]        00000000 f8a2b875 f7711c48 f7711a70 00000000
> f8b2e03a f8b01036 f8b2e000
> [  566.173600] Call Trace:
> [  566.173612]  [<f8b245ce>] mantis_dvb_start_feed+0xae/0x110 [mantis]
> [  566.173625]  [<f8a2ab0d>] dvb_demux_feed_add+0x1d/0xb0 [dvb_core]
> [  566.173645]  [<f8a2b875>] dmx_section_feed_start_filtering+0xc5/0x160
> [dvb_core]
> [  566.173664]  [<f8a29271>] dvb_dmxdev_filter_start+0x201/0x390
> [dvb_core]
> [  566.173681]  [<c01869d6>] shmem_check_acl+0x36/0x60
> [  566.173693]  [<f8a2953c>] dvb_demux_do_ioctl+0x13c/0x3b0 [dvb_core]
> [  566.173709]  [<f8a337b5>] dvb_ringbuffer_init+0x25/0x30 [dvb_core]
> [  566.173730]  [<f8a280e7>] dvb_usercopy+0x67/0x140 [dvb_core]
> [  566.173757]  [<c018b5d5>] nameidata_to_filp+0x35/0x40
> [  566.173765]  [<c018ffc0>] chrdev_open+0x0/0x190
> [  566.173772]  [<c018b630>] do_filp_open+0x50/0x60
> [  566.173784]  [<f8a28bb8>] dvb_demux_ioctl+0x18/0x20 [dvb_core]
> [  566.173799]  [<f8a29400>] dvb_demux_do_ioctl+0x0/0x3b0 [dvb_core]
> [  566.173814]  [<c0199628>] do_ioctl+0x78/0x90
> [  566.173823]  [<c019986e>] vfs_ioctl+0x22e/0x2b0
> [  566.173828]  [<c018b6fe>] do_sys_open+0xbe/0xe0
> [  566.173836]  [<c0199946>] sys_ioctl+0x56/0x70
> [  566.173843]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
> [  566.173858]  =======================
> [  566.173860] Code: 00 03 47 40 c7 00 00 00 00 70 8b 57 44 8d 04 8d 04
> 00 00 00 03 47 40 83 c1 02 89 10 8b 57 18 8b 47 44 89 4f 34 89 42 10 8b
> 57 18 <8b> 82 ff ff ff 0f 0d 00 00 00 80 89 82 ff ff ff 0f 8b 47 18 c7
> [  566.173907] EIP: [<f8b22b59>] mantis_dma_start+0x129/0x200 [mantis]
> SS:ESP 0068:dd0c1e08
> [  566.173923] ---[ end trace ae9809f7bbd5845a ]---
> [  566.176263] vp1034_set_voltage (0): Frontend (dummy) POWERDOWN
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



i've been getting the same thing on my vp1041. the driver crashes and
becomes unusable (even rmmod). as far as i know its specifically the CAM
interface code that has been developed recently.

if you get older revisions it should work perfectly fine. i'll post a
patch if i manage to fix it


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
