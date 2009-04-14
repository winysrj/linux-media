Return-path: <linux-media-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:57906 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZDNBor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 21:44:47 -0400
Received: from [192.168.1.106] (KRIEGER.RES.CMU.EDU [128.2.158.86])
	(user=jwatzman mech=GSSAPI (0 bits))
	by smtp.andrew.cmu.edu (8.14.3/8.13.8) with ESMTP id n3E1LcHG011510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Mon, 13 Apr 2009 21:21:39 -0400
Message-ID: <49E3E534.1030402@andrew.cmu.edu>
Date: Mon, 13 Apr 2009 21:21:56 -0400
From: Josh Watzman <jwatzman@andrew.cmu.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: BUG when unplugging EyeTV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm hitting a kernel BUG when unplugging my EyeTV on a MacBook Pro.
According to the OS X software, it has an XC5000 tuner, AU8522
demodulator, and AU0828 controller; I hear that it is the same as the
Hauppage WinTV-HVR-950Q.

I'm running Debian sid with a locally-built 2.6.29.1 kernel. The only
modifications from the kernel.org vanilla kernel are the addition of
v4l-dvb drivers grabbed from hg today and wireless-testing also current
as of today.

The text of the BUG is pasted below; the BUG is consistently
reproducible either if I unplug the device or if I try to rmmod modules
(only did this once and not sure rmmod'ing which dvb module actually
caused it). I have unfortunately not checked to see how similar the BUG
reports end up over different trials.

If you need more context, see
http://www.contrib.andrew.cmu.edu/~jwatzman/eyetv/ for various parts of
dmesg. "1" was taken right after plugging it in; "2" after waiting a few
moments for the firmware to upload; "3" after successfully watching TV
for about an hour; and "4" after unplugging the device.

Let me know if you need more information!
Thanks,
Josh Watzman



[45664.805473] usb 1-3: USB disconnect, address 8
[45664.806201] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[45664.806209] IP: [<ffffffff802506bb>] prepare_to_wait+0x29/0x58
[45664.806222] PGD 7c9ed067 PUD 7c970067 PMD 0
[45664.806229] Oops: 0002 [#1] SMP
[45664.806234] last sysfs file: /sys/devices/platform/applesmc.768/light
[45664.806238] CPU 0
[45664.806241] Modules linked in: xc5000 tuner au8522 snd_usb_audio
snd_usb_lib snd_hwdep au0828 dvb_core videobuf_vmalloc videobuf_core
tveeprom v4l2_common radeon drm uvcvideo videodev v4l1_compat
v4l2_compat_ioctl32 ipv6 binfmt_misc cpufreq_conservative
cpufreq_userspace dm_mod cpufreq_stats cpufreq_powersave kvm_intel kvm
fuse cpufreq_ondemand acpi_cpufreq freq_table loop firewire_sbp2
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy arc4 snd_seq_oss ecb snd_seq_midi snd_rawmidi
ath9k mac80211 snd_seq_midi_event snd_seq rfkill snd_timer
snd_seq_device joydev rtc_cmos snd video i2c_i801 rtc_core cfg80211
applesmc appletouch soundcore snd_page_alloc rng_core i2c_core rtc_lib
led_class ac battery pcspkr button output evdev input_polldev ext3 jbd
mbcache ide_cd_mod cdrom sd_mod ata_generic hid_apple ata_piix libata
scsi_mod ide_pci_generic firewire_ohci firewire_core piix crc_itu_t
ide_core uhci_hcd ehci_hcd sky2 intel_agp thermal processor fan usbhid hid
[45664.806377] Pid: 151, comm: khubd Not tainted 2.6.29.1 #1 MacBookPro2,2
[45664.806382] RIP: 0010:[<ffffffff802506bb>]  [<ffffffff802506bb>]
prepare_to_wait+0x29/0x58
[45664.806391] RSP: 0018:ffff88007e0d3c00  EFLAGS: 00010046
[45664.806395] RAX: 0000000000000000 RBX: ffff88007e0d3c20 RCX:
0000000000000000
[45664.806400] RDX: ffff88007e0d3c38 RSI: 0000000000000246 RDI:
ffffffff8053b8a8
[45664.806404] RBP: ffffffff8053b8a8 R08: 0000000000000000 R09:
0000000000002451
[45664.806409] R10: 0000000000000000 R11: ffff880000000000 R12:
0000000000000002
[45664.806413] R13: ffff88004c890000 R14: ffffffffa047f6b8 R15:
0000000000000000
[45664.806418] FS:  0000000000000000(0000) GS:ffffffff80620000(0000)
knlGS:0000000000000000
[45664.806423] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[45664.806428] CR2: 0000000000000008 CR3: 0000000037841000 CR4:
00000000000026e0
[45664.806432] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[45664.806437] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[45664.806442] Process khubd (pid: 151, threadinfo ffff88007e0d2000,
task ffff88007e06f990)
[45664.806445] Stack:
[45664.806448]  ffff880074188190 ffff880074188528 ffff880037909c00
ffffffffa0468ef5
[45664.806456]  0000000000000000 ffff88007e06f990 ffffffff8025050a
ffff88007e0d3c38
[45664.806464]  ffff88007e0d3c38 ffff88007e0d3c60 ffff880000000000
ffff880074188190
[45664.806473] Call Trace:
[45664.806477]  [<ffffffffa0468ef5>] ? dvb_net_release+0x60/0xab [dvb_core]
[45664.806502]  [<ffffffff8025050a>] ? autoremove_wake_function+0x0/0x2e
[45664.806510]  [<ffffffffa0478962>] ? au0828_dvb_unregister+0x44/0xa6
[au0828]
[45664.806524]  [<ffffffffa0477036>] ? au0828_usb_disconnect+0x36/0x86
[au0828]
[45664.806537]  [<ffffffff803b24de>] ? usb_unbind_interface+0x5e/0xe5
[45664.806547]  [<ffffffff803a2148>] ? __device_release_driver+0x83/0xa6
[45664.806555]  [<ffffffff803a2243>] ? device_release_driver+0x21/0x2d
[45664.806561]  [<ffffffff803a1874>] ? bus_remove_device+0xa8/0xca
[45664.806567]  [<ffffffff803a0233>] ? device_del+0x132/0x16c
[45664.806574]  [<ffffffff803afd77>] ? usb_disable_device+0x7d/0xf4
[45664.806581]  [<ffffffff803aba24>] ? usb_disconnect+0x89/0x10e
[45664.806588]  [<ffffffff803ac971>] ? hub_thread+0x663/0x1066
[45664.806594]  [<ffffffff8020a6c9>] ? __switch_to+0xb4/0x399
[45664.806602]  [<ffffffff8025050a>] ? autoremove_wake_function+0x0/0x2e
[45664.806609]  [<ffffffff803ac30e>] ? hub_thread+0x0/0x1066
[45664.806615]  [<ffffffff80250197>] ? kthread+0x47/0x73
[45664.806621]  [<ffffffff8020d2da>] ? child_rip+0xa/0x20
[45664.806628]  [<ffffffff8044d912>] ? _spin_lock+0x5/0x7
[45664.806636]  [<ffffffff80250150>] ? kthread+0x0/0x73
[45664.806642]  [<ffffffff8020d2d0>] ? child_rip+0x0/0x20
[45664.806648] Code: 1f 00 41 54 41 89 d4 55 48 89 fd 53 48 89 f3 83 26
fe e8 a1 d1 1f 00 48 8b 53 18 48 89 c6 48 8d 43 18 48 39 c2 75 18 48 8b
45 08 <48> 89 50 08 48 89 43 18 48 8d 45 08 48 89 55 08 48 89 43 20 65
[45664.806709] RIP  [<ffffffff802506bb>] prepare_to_wait+0x29/0x58
[45664.806717]  RSP <ffff88007e0d3c00>
[45664.806720] CR2: 0000000000000008
[45664.806725] ---[ end trace 28396efb33fe235a ]---
