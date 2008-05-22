Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [124.189.101.81] (helo=jingella.dyndns.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@blackdog.shacknet.nu>) id 1JyzgJ-0005Qi-Fr
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 03:33:26 +0200
Received: from logic3r (p4trix [10.0.0.254])
	by jingella.dyndns.org (8.13.8/8.13.8) with ESMTP id m4M1XFdL000311
	for <linux-dvb@linuxtv.org>; Thu, 22 May 2008 11:33:15 +1000
From: "Blacky" <linux-dvb@blackdog.shacknet.nu>
To: <linux-dvb@linuxtv.org>
Date: Thu, 22 May 2008 11:33:13 +1000
Message-ID: <000101c8bbab$cda34450$68e9ccf0$@shacknet.nu>
MIME-Version: 1.0
Content-Language: en-au
Subject: [linux-dvb] Building v4l-dvb on mythbuntu (kernel 2.6.24-16-generic)
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


Hi all

I've been using v4l-dvb build tree for a while, and recently installed
mythbuntu.

I pulled the latest release from the repository, and after building and
installing
the modules I get an error while booting (or specifically, while loading
module tuner_xc2028
during start-up)

For now, I've rolled back to build 7000 (hg update -r 7000) and the build is
ok, however
it puts the modules in different directories.  As a result I had duplicate
modules and had
a fair bit of cleanup to do before it all worked again.  (In fact, I'm still
cleaning it up :-( )

The reason for the change is that the tuner cards work flawlessly under
windows, and I'm
getting really poor reception and recording on the same hardware under
linux.  I'm hoping
a more recent version will help. (Also, the card, a dvico dual-digital4 is
not supported
out of the box on ubuntu or the 2.6.24 kernel)

Should the latest tree work under 2.6.24?  Is it a mythbuntu feature that it
crashes?  I've tried it
on a heavily modified centos 5.1 build, and with a custom 2.6.23 kernel, and
also have errors.

IS there a limit to which builds will work with 2.6.24?


Thanks for your help.
Blacky


Error Detail :

May 21 21:34:09 mythgella kernel: [164575.825699] dvb-usb: DViCO FusionHDTV
DVB-T USB (TH7579) successfully initialized and connected.
May 21 21:34:09 mythgella kernel: [164575.825713] dvb-usb: found a 'DViCO
FusionHDTV DVB-T Dual Digital 4' in warm state.
May 21 21:34:09 mythgella kernel: [164575.825852] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
May 21 21:34:09 mythgella kernel: [164575.856984] DVB: registering new
adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
May 21 21:34:09 mythgella kernel: [164575.937650] usb 4-2: reset full speed
USB device using uhci_hcd and address 3
May 21 21:34:09 mythgella kernel: [164576.023244] DVB: registering frontend
1 (Zarlink ZL10353 DVB-T)...
May 21 21:34:09 mythgella kernel: [164576.057055] general protection fault:
0000 [1] SMP 
May 21 21:34:09 mythgella kernel: [164576.057059] CPU 0 
May 21 21:34:09 mythgella kernel: [164576.057060] Modules linked in:
tuner_xc2028 zl10353 dvb_pll mt352 snd_hda_intel snd_pcm_oss dvb_usb_cxusb
dvb_usb lirc_mceusb2 lirc_dev dvb_core snd_mixer_oss sky2 nvidia(P) snd_pcm
snd_page_alloc snd_hwdep i2c_core snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device button snd
shpchp soundcore iTCO_wdt iTCO_vendor_support evdev pci_hotplug intel_agp
pcspkr ext3 jbd mbcache sg sr_mod sd_mod cdrom ahci libata scsi_mod r8169
ehci_hcd uhci_hcd usbcore thermal processor fan fbcon tileblit font bitblit
softcursor fuse
May 21 21:34:09 mythgella kernel: [164576.057083] Pid: 3303, comm: modprobe
Tainted: P        2.6.24-16-generic #1
May 21 21:34:09 mythgella kernel: [164576.057085] RIP:
0010:[tuner_xc2028:xc2028_attach+0x14e/0x230]
[tuner_xc2028:xc2028_attach+0x14e/0x230]
:tuner_xc2028:xc2028_attach+0x14e/0x230
May 21 21:34:09 mythgella kernel: [164576.057089] RSP: 0018:ffff81007c8a1be8
EFLAGS: 00010206
May 21 21:34:09 mythgella kernel: [164576.057090] RAX: 0020000000a08c00 RBX:
ffffffff88b4e5d0 RCX: 0000000000000080
May 21 21:34:09 mythgella kernel: [164576.057092] RDX: 00000000ffffffff RSI:
ffffffff88b4c1a0 RDI: ffff81007d344678
May 21 21:34:09 mythgella kernel: [164576.057093] RBP: ffff81007c8a1c18 R08:
ffffffff805808b0 R09: ffff81007f867258
May 21 21:34:09 mythgella kernel: [164576.057095] R10: 0000000000000000 R11:
0000000000000001 R12: ffff81007d344408
May 21 21:34:09 mythgella kernel: [164576.057096] R13: 0000000000000000 R14:
ffffffff88abdbc8 R15: ffffffff88abdaa0
May 21 21:34:09 mythgella kernel: [164576.057098] FS:
00007f926ed166e0(0000) GS:ffffffff805b0000(0000) knlGS:0000000000000000
May 21 21:34:09 mythgella kernel: [164576.057099] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
May 21 21:34:09 mythgella kernel: [164576.057101] CR2: 00007f7e9b44d000 CR3:
000000007d7ff000 CR4: 00000000000006e0
May 21 21:34:09 mythgella kernel: [164576.057102] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 21 21:34:09 mythgella kernel: [164576.057103] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 21 21:34:09 mythgella kernel: [164576.057105] Process modprobe (pid:
3303, threadinfo ffff81007c8a0000, task ffff81007d25c7c0)
May 21 21:34:09 mythgella kernel: [164576.057106] Stack:  ffffffff88abdaa0
ffff81007c93ed48 ffff81007c93e000 ffff81007c93e000
May 21 21:34:09 mythgella kernel: [164576.057109]  0000000000000000
ffffffff88ab7d58 ffff81007c93ea28 0000000000000061
May 21 21:34:09 mythgella kernel: [164576.057112]  ffff81007c93e000
0000000000000000 ffffffff88ab8400 ffff81007c93e000
May 21 21:34:09 mythgella kernel: [164576.057114] Call Trace:
May 21 21:34:09 mythgella kernel: [164576.057119]
[dvb_usb_cxusb:cxusb_dvico_xc3028_tuner_attach+0x58/0xe0]
:dvb_usb_cxusb:cxusb_dvico_xc3028_tuner_attach+0x58/0xe0
May 21 21:34:09 mythgella kernel: [164576.057123]
[dvb_usb_cxusb:dvico_bluebird_xc2028_callback+0x0/0xa0]
:dvb_usb_cxusb:dvico_bluebird_xc2028_callback+0x0/0xa0
May 21 21:34:09 mythgella kernel: [164576.057127]
[dvb_usb:dvb_usb_adapter_frontend_init+0x80/0x100]
:dvb_usb:dvb_usb_adapter_frontend_init+0x80/0x100
May 21 21:34:09 mythgella kernel: [164576.057130]
[dvb_usb:dvb_usb_device_init+0x3d7/0x640]
:dvb_usb:dvb_usb_device_init+0x3d7/0x640
May 21 21:34:09 mythgella kernel: [164576.057135]
[dvb_usb_cxusb:cxusb_probe+0xab/0x100] :dvb_usb_cxusb:cxusb_probe+0xab/0x100
May 21 21:34:09 mythgella kernel: [164576.057147]
[usbcore:usb_probe_interface+0xda/0x160]
:usbcore:usb_probe_interface+0xda/0x160
May 21 21:34:09 mythgella kernel: [164576.057153]
[driver_probe_device+0x9c/0x1b0] driver_probe_device+0x9c/0x1b0
May 21 21:34:09 mythgella kernel: [164576.057156]
[__driver_attach+0xc9/0xd0] __driver_attach+0xc9/0xd0
May 21 21:34:09 mythgella kernel: [164576.057158]
[__driver_attach+0x0/0xd0] __driver_attach+0x0/0xd0
May 21 21:34:09 mythgella kernel: [164576.057160]
[scsi_mod:bus_for_each_dev+0x4d/0x100] bus_for_each_dev+0x4d/0x80
May 21 21:34:09 mythgella kernel: [164576.057163]
[bus_add_driver+0xac/0x220] bus_add_driver+0xac/0x220
May 21 21:34:09 mythgella kernel: [164576.057172]
[usbcore:usb_register_driver+0xa9/0x120]
:usbcore:usb_register_driver+0xa9/0x120
May 21 21:34:09 mythgella kernel: [164576.057176]
[snd_seq:init_module+0x1b/0x50] :dvb_usb_cxusb:cxusb_module_init+0x1b/0x35
May 21 21:34:09 mythgella kernel: [164576.057180]
[sys_init_module+0x18e/0x1a90] sys_init_module+0x18e/0x1a90
May 21 21:34:09 mythgella kernel: [164576.057188]  [<ffffffff802479b0>]
msleep+0x0/0x30
May 21 21:34:09 mythgella kernel: [164576.057192]  [system_call+0x7e/0x83]
system_call+0x7e/0x83
May 21 21:34:09 mythgella kernel: [164576.057195] 
May 21 21:34:09 mythgella kernel: [164576.057196] 
May 21 21:34:09 mythgella kernel: [164576.057196] Code: 8b 90 a0 02 00 00 48
8b 73 28 31 c0 0f b6 c9 49 c7 c0 b5 c4 
May 21 21:34:09 mythgella kernel: [164576.057202] RIP
[tuner_xc2028:xc2028_attach+0x14e/0x230]
:tuner_xc2028:xc2028_attach+0x14e/0x230
May 21 21:34:09 mythgella kernel: [164576.057205]  RSP <ffff81007c8a1be8>
May 21 21:34:09 mythgella kernel: [164576.057207] ---[ end trace
c32b0de5ffa259f7 ]---
May 21 21:34:09 mythgella kernel: [164576.092371] lirc_dev:
lirc_register_plugin: sample_rate: 0
May 21 21:34:09 mythgella kernel: [164576.096368] lirc_mceusb2[3]: Philips
eHome Infrared Transceiver on usb4:3





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
