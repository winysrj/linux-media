Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51740 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1BRQwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 11:52:55 -0500
Received: by iyj8 with SMTP id 8so3691319iyj.19
        for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 08:52:55 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 18 Feb 2011 17:52:54 +0100
Message-ID: <AANLkTikEXHBBia6pUnqGaamiJWczD2Zqf_DERYhhUjrC@mail.gmail.com>
Subject: pinnacle 300i - unable to use antenna_pwr=1 on saa7134-dvb
From: Antonio Orefice <aorefice77@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I just got a pinnacle 300i i'd like to use to watch dvbt streams.

Under linux i get a very poor signal, picture/sound skips and is full
of artifacts every few seconds, while in windows it works fine.
Also, if i reboot (no shutdown) from windows to linux, it works good,
so i think this has something to do with hardware
settings/initialization.

modinfo saa7134-dvb reports an "antenna_pwr" parameter which is
supposed to give a gain to the signal, but if i set it and
rmmod/modprobe saa7134-dvb or boot with that parameter, the module
crashes:


last sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:05:02.0/subsystem_device
Modules linked in: saa7134_dvb cpufreq_userspace acpi_cpufreq
freq_table mperf tun fuse snd_usb_audio snd_usbmidi_lib snd_rawmidi
ext3 jbd saa7134_alsa nvidia(P) mt352 videobuf_dvb dvb_core
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_hda_codec_realtek mt20xx snd_pcm_oss snd_mixer_oss tea5767 tda9887
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore
snd_page_alloc tda8290 ir_sony_decoder ir_jvc_decoder tuner
ir_rc6_decoder usbhid hid ir_rc5_decoder ir_nec_decoder saa7134
v4l2_common videodev v4l1_compat videobuf_dma_sg videobuf_core
ir_common ir_core tveeprom asus_atk0110 i2c_i801 i2c_core parport_pc
floppy sr_mod cdrom processor button thermal iTCO_wdt
iTCO_vendor_support r8169 mii uhci_hcd ehci_hcd usbcore sg intel_agp
agpgart evdev ppdev lp parport rtc_cmos rtc_core rtc_lib ext4 mbcache
jbd2 crc16 pata_jmicron pata_acpi sd_mod ahci libahci libata scsi_mod
[last unloaded: saa7134_dvb]

Pid: 4470, comm: kdvb-ad-0-fe-0 Tainted: P            2.6.35-ARCH #1
P5QL-ASUS-SE/System Product Name
EIP: 0060:[<f872a0e7>] EFLAGS: 00010286 CPU: 1
EIP is at mt352_pinnacle_tuner_set_params+0x1f7/0x276 [saa7134_dvb]
EAX: f8e20c00 EBX: f623a03c ECX: 01480000 EDX: 0000684c
ESI: f623a000 EDI: f623a03c EBP: f198bec0 ESP: f198be60
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kdvb-ad-0-fe-0 (pid: 4470, ti=f198a000 task=f1874500 task.ti=f198a000)
Stack:
 f198be78 c2903e3c c2903e68 c12f2740 f623a184 f244b404 00000000 00000003
<0> 00002b20 c1002666 00000000 c2908140 f60f36c0 f198beb0 c1034d6a f1874500
<0> 00000000 00000043 c2900002 f198beb0 f1007100 f244b004 f244b404 00008d36
Call Trace:
 [<c1002666>] ? __switch_to+0xb6/0x180
 [<c1034d6a>] ? finish_task_switch+0x3a/0xa0
 [<fa507346>] ? mt352_set_parameters+0x266/0x3c0 [mt352]
 [<c1051eb6>] ? lock_timer_base.clone.26+0x26/0x50
 [<fa4cc178>] ? dvb_frontend_swzigzag_autotune+0x108/0x270 [dvb_core]
 [<fa4ccab9>] ? dvb_frontend_swzigzag+0x1c9/0x270 [dvb_core]
 [<fa4cd67f>] ? dvb_frontend_thread+0x2cf/0x540 [dvb_core]
 [<c103df8b>] ? default_wake_function+0xb/0x10
 [<c105eb30>] ? autoremove_wake_function+0x0/0x40
 [<fa4cd3b0>] ? dvb_frontend_thread+0x0/0x540 [dvb_core]
 [<c105e71c>] ? kthread+0x6c/0x80
 [<c105e6b0>] ? kthread+0x0/0x80
 [<c1003d3e>] ? kernel_thread_helper+0x6/0x18
Code: 60 25 a6 c8 8b 96 64 01 00 00 8b 82 b4 01 00 00 0d 00 00 00 10
89 82 b4 01 00 00 b8 c6 a7 00 00 e8 3f 25 a6 c8 8b 86 64 01 00 00 <8b>
98 d0 06 00 00 8b 3d 0c b9 72 f8 81 e3 00 00 00 08 85 ff 75
EIP: [<f872a0e7>] mt352_pinnacle_tuner_set_params+0x1f7/0x276
[saa7134_dvb] SS:ESP 0068:f198be60
CR2: 00000000f8e212d0
---[ end trace 3e593e27d37e843e ]---

I read another similar issue on the list where it was suggested to try
with newer v4l-dvb stuff, but more than a year ago.

Reference here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg08616.html

Can someone make some light on this issue?

Thank you very much!

--
Antonio Orefice
