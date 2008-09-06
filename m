Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1Kc5H5-0008SV-Lv
	for linux-dvb@linuxtv.org; Sat, 06 Sep 2008 23:24:57 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1052007wfd.17
	for <linux-dvb@linuxtv.org>; Sat, 06 Sep 2008 14:24:50 -0700 (PDT)
Message-ID: <e32e0e5d0809061424t5ff14414pe5a2357b9b6f983@mail.gmail.com>
Date: Sat, 6 Sep 2008 14:24:50 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "linux dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <e32e0e5d0809050731h17e18aeao786011bc8775e12c@mail.gmail.com>
MIME-Version: 1.0
References: <e32e0e5d0809050731h17e18aeao786011bc8775e12c@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1324749260=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1324749260==
Content-Type: multipart/alternative;
	boundary="----=_Part_103097_10939733.1220736290542"

------=_Part_103097_10939733.1220736290542
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Did you get this message?  I didn't know if you or anyone else had any
insight into this problem.

On Fri, Sep 5, 2008 at 7:31 AM, Tim Lucas <lucastim@gmail.com> wrote:

> > Why doesn't the driver load if you force it with card=X? What does dmesg
> show?
> >
> > - Steve
>
> I followed your instructions modprobe cx23885 debug=1 says operation not
> permitted
> Then I tried sudo modprobe cx23885 debug=1 and it says the process was
> killed
> This is the output from dmeg.
>
> 589.243831] cx23885: no version for "snd_pcm_new" found: kernel tainted.
> [  589.245284] cx23885 driver version 0.0.1 loaded
> [  589.245628] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
> [  589.245632] ACPI: PCI Interrupt 0000:08:00.0[A] -> Link [APC6] -> GSI 16
> (level, low) -> IRQ 16
> [  589.245750] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe
> bridge type 885
> [  589.245752] cx23885[0]/0: cx23885_init_tsport(portno=2)
> [  589.245759] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge
> WinTV-HVR1500 [card=6,insmod option]
> [  589.245761] cx23885[0]/0: cx23885_pci_quirks()
> [  589.245763] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x47
> tuner_addr = 0x61
> [  589.245765] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0
> radio_addr = 0x0
> [  589.245766] cx23885[0]/0: cx23885_reset()
> [  589.345825] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
> channel [VID A]
> [  589.345837] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
> [ch2]
> [  589.345838] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
> channel [TS1 B]
> [  589.345850] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
> [ch4]
> [  589.345852] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
> [ch5]
> [  589.345853] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
> channel [TS2 C]
> 589.345866] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel
> [TV Audio]
> [  589.345880] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
> [ch8]
> [  589.345882] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
> [ch9]
> [  589.355776] cx23885[0]: i2c bus 0 registered
> [  589.355793] cx23885[0]: i2c bus 1 registered
> [  589.355810] cx23885[0]: i2c bus 2 registered
> [  589.382427] tveeprom 5-0050: Encountered bad packet header [ff]. Corrupt
> or not a Hauppauge eeprom.
> [  589.382431] cx23885[0]: warning: unknown hauppauge model #0
> [  589.382432] cx23885[0]: hauppauge eeprom: model=0
> [  589.388510] cx25840' 7-0044: cx25  0-21 found @ 0x88 (cx23885[0])
> [  589.395552] tuner' 5-0064: chip found @ 0xc8 (cx23885[0])
> [  589.398231] tuner' 6-0064: chip found @ 0xc8 (cx23885[0])
> [  589.400298] cx23885[0]/0: registered device video0 [v4l2]
> [  589.400351] Unable to handle kernel NULL pointer dereference at
> 0000000000000008 RIP:
> [  589.400353]  [<ffffffff881f5f89>] :snd:snd_device_new+0x59/0xb0
> [  589.400363] PGD 7105a067 PUD 7c727067 PMD 0
> [  589.400366] Oops: 0002 [1] SMP
> [  589.400368] CPU 0
> [  589.400369] Modules linked in: tuner cx25840 cx23885(F) af_packet ipv6
> cpufreq_ondemand cpufreq_stats cpuf
> q_userspace freq_table cpufreq_powersave cpufreq_conservative video output
> container dock sbs sbshc battery ipt
> able_filter ip_tables x_tables ac sbp2 lp compat_ioctl32 nvidia(P) videodev
> v4l1_compat cx2341x videobuf_dma_sg
>  v4l2_common btcx_risc tveeprom videobuf_dvb dvb_core videobuf_core
> snd_hda_intel snd_pcm_oss snd_mixer_oss snd
> _pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi
> snd_rawmidi snd_seq_midi_event snd_seq ser
> io_raw snd_timer snd_seq_device psmouse snd button i2c_nforce2 i2c_core
> parport_pc parport shpchp pci_hotplug e
> vdev soundcore pcspkr ext3 jbd mbcache usbhid hid sd_mod sg sr_mod cdrom
> sata_nv ehci_hcd ohci1394 ohci_hcd pat
> a_acpi pata_amd usbcore ieee1394 forcedeth ata_generic libata scsi_mod
> thermal processor fan fbcon tileblit fon
> t bitblit softcursor fuse
> [  589.400408] Pid: 17811, comm: modprobe Tainted: PF
> 2.6.24-21-generic #1
> [  589.400409] RIP: 0010:[<ffffffff881f5f89>]  [<ffffffff881f5f89>]
> :snd:snd_device_new+0x59/0xb0
> [  589.400416] RSP: 0018:ffff810073235aa8  EFLAGS: 00010282
> [  589.400417] RAX: 0000000000000000 RBX: ffffffff88c7dd20 RCX:
> 0000000000000000
> [  589.400418] RDX: ffff810071048e40 RSI: 0000000000000000 RDI:
> ffff810071048e80
> [  589.400420] RBP: 0000000000001003 R08: 0000000000000000 R09:
> ffff810071048e40
> [  589.400421] R10: 0000000000000000 R11: ffffffff803bcc30 R12:
> ffff81007212d000
> [  589.400423] R13: ffffffff8821a620 R14: ffff810073235b20 R15:
> ffffffff88265e48
> [  589.400424] FS:  00007f379fe496e0(0000) GS:ffffffff805b9000(0000)
> knlGS:0000000000000000
> [  589.400426] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  589.400427] CR2: 0000000000000008 CR3: 0000000073137000 CR4:
> 00000000000006e0
> [  589.400429] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  589.400430] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  589.400432] Process modprobe (pid: 17811, threadinfo ffff810073234000,
> task ffff81007c53c7e0)
> [  589.400433] Stack:  ffff81007212d000 ffff81007212d000 ffff810073235b08
> ffffffff88c7dd20
> [  589.400436]  ffffffff88266648 ffffffff88215128 ffff81007b6d1e58
> ffff81007212d400
> [  589.400439]  0000000000000018 ffff81007212d458 0000000000000001
> ffffffff88264c12
> [  589.400441] Call Trace:
> [  589.400448]  [<ffffffff88215128>] :snd_timer:snd_timer_new+0x128/0x180
> [  589.400457]  [<ffffffff88264c12>] :snd_pcm:snd_pcm_timer_init+0x52/0x1a0
> [  589.400465]  [<ffffffff8825b7dd>]
> :snd_pcm:snd_pcm_dev_register+0xfd/0x220
> [  589.400470]  [<ffffffff802f88a8>] create_proc_entry+0x58/0xa0
> [  589.400480]  [<ffffffff881f5c9f>] :snd:snd_device_register_all+0x2f/0x60
> [  589.400487]  [<ffffffff881f0b8b>] :snd:snd_card_register+0x3b/0x390
> [  589.400493]  [<ffffffff8825b9e3>] :snd_pcm:snd_pcm_new+0xe3/0x140
> [  589.400505]  [<ffffffff88c6f306>]
> :cx23885:cx23885_audio_initdev+0x156/0x1d0
> [  589.400512]  [<ffffffff88c66a52>]
> :cx23885:cx23885_video_register+0x1d2/0x2f0
> [  589.400520]  [<ffffffff88c644d0>]
> :cx23885:cx23885_tuner_callback+0x0/0xf0
> [  589.400526]  [<ffffffff881e1f8a>]
> :i2c_core:i2c_clients_command+0x2a/0xe0
> [  589.400534]  [<ffffffff88c6aef7>] :cx23885:cx23885_initdev+0x927/0xb00
> [  589.400537]  [<ffffffff8034a172>] kobject_get+0x12/0x20
> [  589.400542]  [<ffffffff8035e4b8>] pci_device_probe+0xf8/0x170
> [  589.400548]  [<ffffffff803bfd7c>] driver_probe_device+0x9c/0x1b0
> [  589.400552]  [<ffffffff803c0049>] __driver_attach+0xc9/0xd0
> [  589.400556]  [<ffffffff803bff80>] __driver_attach+0x0/0xd0
> [  589.400558]  [<ffffffff803befbd>] bus_for_each_dev+0x4d/0x80
> [  589.400564]  [<ffffffff803bf3cc>] bus_add_driver+0xac/0x220
> [  589.400567]  [<ffffffff8035e739>] __pci_register_driver+0x69/0xb0
> [  589.400572]  [<ffffffff80263e0e>] sys_init_module+0x18e/0x1a90
> [  589.400586]  [<ffffffff882f2550>]
> :videobuf_core:videobuf_mmap_free+0x0/0x40
> [  589.400593]  [<ffffffff8020c37e>] system_call+0x7e/0x83
> [  589.400600]
> [  589.400600]
> [  589.400601] Code: 48 89 50 08 48 89 02 48 8d 83 50 01 00 00 48 89 93 50
> 01 00
> [  589.400607] RIP  [<ffffffff881f5f89>] :snd:snd_device_new+0x59/0xb0
> [  589.400613]  RSP <ffff810073235aa8>
> [  589.400614] CR2: 0000000000000008
> [  589.400615] ---[ end trace 5a3db5147eff6869 ]---
>
>
> --
> --Tim
>



-- 
--Tim

------=_Part_103097_10939733.1220736290542
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Did you get this message? &nbsp;I didn&#39;t know if you or anyone else had any insight into this problem.<br><br><div class="gmail_quote">On Fri, Sep 5, 2008 at 7:31 AM, Tim Lucas <span dir="ltr">&lt;<a href="mailto:lucastim@gmail.com">lucastim@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;"><div dir="ltr"><span style="border-collapse:collapse;font-family:Times;font-size:16px"><div class="Ih2E3d"><div><span style="font-family:arial;font-size:13px">&gt; Why doesn&#39;t the driver load if you force it with card=X? What does dmesg show?<br>

&gt;&nbsp;<br>&gt; - Steve</span><br></div><div><br></div></div><div class="Ih2E3d"><div>I followed your instructions&nbsp;<span style="font-family:Times;font-size:16px">modprobe cx23885 debug=1 says operation not permitted<br>Then I tried sudo&nbsp;</span><span style="font-family:Times;font-size:16px"><span style="font-family:Times;font-size:16px">modprobe cx23885 debug=1</span></span>&nbsp;and it says the process was killed<br>

</div></div><div>This is the output from dmeg.</div><div><div></div><div class="Wj3C7c"><div><br></div>589.243831] cx23885: no version for &quot;snd_pcm_new&quot; found: kernel tainted.<br>[&nbsp; 589.245284] cx23885 driver version 0.0.1 loaded<br>
[&nbsp; 589.245628] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16<br>
[&nbsp; 589.245632] ACPI: PCI Interrupt 0000:08:00.0[A] -&gt; Link [APC6] -&gt; GSI 16 (level, low) -&gt; IRQ 16<br>[&nbsp; 589.245750] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 885<br>[&nbsp; 589.245752] cx23885[0]/0: cx23885_init_tsport(portno=2)<br>

[&nbsp; 589.245759] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge WinTV-HVR1500 [card=6,insmod option]<br>[&nbsp; 589.245761] cx23885[0]/0: cx23885_pci_quirks()<br>[&nbsp; 589.245763] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x47 tuner_addr = 0x61<br>

[&nbsp; 589.245765] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0<br>[&nbsp; 589.245766] cx23885[0]/0: cx23885_reset()<br>[&nbsp; 589.345825] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]<br>

[&nbsp; 589.345837] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]<br>[&nbsp; 589.345838] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]<br>[&nbsp; 589.345850] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]<br>

[&nbsp; 589.345852] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]<br>[&nbsp; 589.345853] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]<br>589.345866] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TV Audio]<br>

[&nbsp; 589.345880] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]<br>[&nbsp; 589.345882] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]<br>[&nbsp; 589.355776] cx23885[0]: i2c bus 0 registered<br>[&nbsp; 589.355793] cx23885[0]: i2c bus 1 registered<br>

[&nbsp; 589.355810] cx23885[0]: i2c bus 2 registered<br>[&nbsp; 589.382427] tveeprom 5-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.<br>[&nbsp; 589.382431] cx23885[0]: warning: unknown hauppauge model #0<br>

[&nbsp; 589.382432] cx23885[0]: hauppauge eeprom: model=0<br>[&nbsp; 589.388510] cx25840&#39; 7-0044: cx25&nbsp; 0-21 found @ 0x88 (cx23885[0])<br>[&nbsp; 589.395552] tuner&#39; 5-0064: chip found @ 0xc8 (cx23885[0])<br>[&nbsp; 589.398231] tuner&#39; 6-0064: chip found @ 0xc8 (cx23885[0])<br>

[&nbsp; 589.400298] cx23885[0]/0: registered device video0 [v4l2]<br>[&nbsp; 589.400351] Unable to handle kernel NULL pointer dereference at 0000000000000008 RIP:&nbsp;<br>[&nbsp; 589.400353]&nbsp; [&lt;ffffffff881f5f89&gt;] :snd:snd_device_new+0x59/0xb0<br>

[&nbsp; 589.400363] PGD 7105a067 PUD 7c727067 PMD 0&nbsp;<br>[&nbsp; 589.400366] Oops: 0002 [1] SMP&nbsp;<br>[&nbsp; 589.400368] CPU 0&nbsp;<br>[&nbsp; 589.400369] Modules linked in: tuner cx25840 cx23885(F) af_packet ipv6 cpufreq_ondemand cpufreq_stats cpuf<br>

q_userspace freq_table cpufreq_powersave cpufreq_conservative video output container dock sbs sbshc battery ipt<br>able_filter ip_tables x_tables ac sbp2 lp compat_ioctl32 nvidia(P) videodev v4l1_compat cx2341x videobuf_dma_sg<br>

&nbsp;v4l2_common btcx_risc tveeprom videobuf_dvb dvb_core videobuf_core snd_hda_intel snd_pcm_oss snd_mixer_oss snd<br>_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq ser<br>

io_raw snd_timer snd_seq_device psmouse snd button i2c_nforce2 i2c_core parport_pc parport shpchp pci_hotplug e<br>vdev soundcore pcspkr ext3 jbd mbcache usbhid hid sd_mod sg sr_mod cdrom sata_nv ehci_hcd ohci1394 ohci_hcd pat<br>

a_acpi pata_amd usbcore ieee1394 forcedeth ata_generic libata scsi_mod thermal processor fan fbcon tileblit fon<br>t bitblit softcursor fuse<br>[&nbsp; 589.400408] Pid: 17811, comm: modprobe Tainted: PF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.24-21-generic #1<br>

[&nbsp; 589.400409] RIP: 0010:[&lt;ffffffff881f5f89&gt;]&nbsp; [&lt;ffffffff881f5f89&gt;] :snd:snd_device_new+0x59/0xb0<br>[&nbsp; 589.400416] RSP: 0018:ffff810073235aa8&nbsp; EFLAGS: 00010282<br>[&nbsp; 589.400417] RAX: 0000000000000000 RBX: ffffffff88c7dd20 RCX: 0000000000000000<br>

[&nbsp; 589.400418] RDX: ffff810071048e40 RSI: 0000000000000000 RDI: ffff810071048e80<br>[&nbsp; 589.400420] RBP: 0000000000001003 R08: 0000000000000000 R09: ffff810071048e40<br>[&nbsp; 589.400421] R10: 0000000000000000 R11: ffffffff803bcc30 R12: ffff81007212d000<br>

[&nbsp; 589.400423] R13: ffffffff8821a620 R14: ffff810073235b20 R15: ffffffff88265e48<br>[&nbsp; 589.400424] FS:&nbsp; 00007f379fe496e0(0000) GS:ffffffff805b9000(0000) knlGS:0000000000000000<br>[&nbsp; 589.400426] CS:&nbsp; 0010 DS: 0000 ES: 0000 CR0: 000000008005003b<br>

[&nbsp; 589.400427] CR2: 0000000000000008 CR3: 0000000073137000 CR4: 00000000000006e0<br>[&nbsp; 589.400429] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000<br>[&nbsp; 589.400430] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400<br>

[&nbsp; 589.400432] Process modprobe (pid: 17811, threadinfo ffff810073234000, task ffff81007c53c7e0)<br>[&nbsp; 589.400433] Stack:&nbsp; ffff81007212d000 ffff81007212d000 ffff810073235b08 ffffffff88c7dd20<br>[&nbsp; 589.400436]&nbsp; ffffffff88266648 ffffffff88215128 ffff81007b6d1e58 ffff81007212d400<br>

[&nbsp; 589.400439]&nbsp; 0000000000000018 ffff81007212d458 0000000000000001 ffffffff88264c12<br>[&nbsp; 589.400441] Call Trace:<br>[&nbsp; 589.400448]&nbsp; [&lt;ffffffff88215128&gt;] :snd_timer:snd_timer_new+0x128/0x180<br>[&nbsp; 589.400457]&nbsp; [&lt;ffffffff88264c12&gt;] :snd_pcm:snd_pcm_timer_init+0x52/0x1a0<br>

[&nbsp; 589.400465]&nbsp; [&lt;ffffffff8825b7dd&gt;] :snd_pcm:snd_pcm_dev_register+0xfd/0x220<br>[&nbsp; 589.400470]&nbsp; [&lt;ffffffff802f88a8&gt;] create_proc_entry+0x58/0xa0<br>[&nbsp; 589.400480]&nbsp; [&lt;ffffffff881f5c9f&gt;] :snd:snd_device_register_all+0x2f/0x60<br>

[&nbsp; 589.400487]&nbsp; [&lt;ffffffff881f0b8b&gt;] :snd:snd_card_register+0x3b/0x390<br>[&nbsp; 589.400493]&nbsp; [&lt;ffffffff8825b9e3&gt;] :snd_pcm:snd_pcm_new+0xe3/0x140<br>[&nbsp; 589.400505]&nbsp; [&lt;ffffffff88c6f306&gt;] :cx23885:cx23885_audio_initdev+0x156/0x1d0<br>

[&nbsp; 589.400512]&nbsp; [&lt;ffffffff88c66a52&gt;] :cx23885:cx23885_video_register+0x1d2/0x2f0<br>[&nbsp; 589.400520]&nbsp; [&lt;ffffffff88c644d0&gt;] :cx23885:cx23885_tuner_callback+0x0/0xf0<br>[&nbsp; 589.400526]&nbsp; [&lt;ffffffff881e1f8a&gt;] :i2c_core:i2c_clients_command+0x2a/0xe0<br>

[&nbsp; 589.400534]&nbsp; [&lt;ffffffff88c6aef7&gt;] :cx23885:cx23885_initdev+0x927/0xb00<br>[&nbsp; 589.400537]&nbsp; [&lt;ffffffff8034a172&gt;] kobject_get+0x12/0x20<br>[&nbsp; 589.400542]&nbsp; [&lt;ffffffff8035e4b8&gt;] pci_device_probe+0xf8/0x170<br>

[&nbsp; 589.400548]&nbsp; [&lt;ffffffff803bfd7c&gt;] driver_probe_device+0x9c/0x1b0<br>[&nbsp; 589.400552]&nbsp; [&lt;ffffffff803c0049&gt;] __driver_attach+0xc9/0xd0<br>[&nbsp; 589.400556]&nbsp; [&lt;ffffffff803bff80&gt;] __driver_attach+0x0/0xd0<br>
[&nbsp; 589.400558]&nbsp; [&lt;ffffffff803befbd&gt;] bus_for_each_dev+0x4d/0x80<br>
[&nbsp; 589.400564]&nbsp; [&lt;ffffffff803bf3cc&gt;] bus_add_driver+0xac/0x220<br>[&nbsp; 589.400567]&nbsp; [&lt;ffffffff8035e739&gt;] __pci_register_driver+0x69/0xb0<br>[&nbsp; 589.400572]&nbsp; [&lt;ffffffff80263e0e&gt;] sys_init_module+0x18e/0x1a90<br>

[&nbsp; 589.400586]&nbsp; [&lt;ffffffff882f2550&gt;] :videobuf_core:videobuf_mmap_free+0x0/0x40<br>[&nbsp; 589.400593]&nbsp; [&lt;ffffffff8020c37e&gt;] system_call+0x7e/0x83<br>[&nbsp; 589.400600]&nbsp;<br>[&nbsp; 589.400600]&nbsp;<br>[&nbsp; 589.400601] Code: 48 89 50 08 48 89 02 48 8d 83 50 01 00 00 48 89 93 50 01 00&nbsp;<br>

[&nbsp; 589.400607] RIP&nbsp; [&lt;ffffffff881f5f89&gt;] :snd:snd_device_new+0x59/0xb0<br>[&nbsp; 589.400613]&nbsp; RSP &lt;ffff810073235aa8&gt;<br>[&nbsp; 589.400614] CR2: 0000000000000008<br>[&nbsp; 589.400615] ---[ end trace 5a3db5147eff6869 ]---</div>
</div></span><br clear="all">
<br>-- <br> --Tim<br>
</div>
</blockquote></div><br><br clear="all"><br>-- <br> --Tim<br>
</div>

------=_Part_103097_10939733.1220736290542--


--===============1324749260==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1324749260==--
