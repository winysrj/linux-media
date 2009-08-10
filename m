Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:36676 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZHJNra (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 09:47:30 -0400
Message-ID: <4A8025BF.7030404@pardus.org.tr>
Date: Mon, 10 Aug 2009 16:50:55 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: NULL pointer dereference in ALSA triggered through saa7134-alsa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've finally succesfully compiled and linked saa7134-alsa driver using
an external alsa-driver and its Module.symvers file. Everything seems
okay, no undefined symbol or something else:

- An installed 2.6.30.4 kernel which only builds and brings soundcore
and sound_firmware,
- Latest alsa-driver built externally and installed,
- Latest saa7134-alsa, cx88-alsa, etc. code from linus-2.6 (seen that
they don't affected by some API/ABI changes) patched on top of the
alsa-driver tarball,

I'm copying Module.symvers file generated after building the alsa-driver
into each directory for getting rid of undefined snd_*() symbols.

When I plug a saa7134 PCI card and reboot, the -alsa driver is
automatically probed but it immediately oopses. I wonder if this could
be related to my weird-but-apparently-successful compilation experience
above?

[    6.876120] Linux video capture interface: v2.00
[    7.089550] saa7130/34: v4l2 driver version 0.2.15 loaded
[    7.089612] saa7134 0000:03:05.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[    7.089622] saa7133[0]: found at 0000:03:05.0, rev: 209, irq: 20,
latency: 64, mmio: 0xfdbff000
[    7.089631] saa7133[0]: subsystem: 1461:f11d, board: Avermedia PCI
pure analog (M135A) [card=149,autodetected]
[    7.089659] saa7133[0]: board init: gpio is 40000
[    7.089744] input: saa7134 IR (Avermedia PCI pure  as
/devices/pci0000:00/0000:00:14.4/0000:03:05.0/input/input6
[    7.089789] IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[    7.230265] saa7133[0]: i2c eeprom 00: 61 14 1d f1 54 20 1c 00 43 43
a9 1c 55 d2 b2 92
[    7.230274] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
ff ff ff ff ff ff
[    7.230282] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88 ff
00 56 ff ff ff ff
[    7.230289] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230296] saa7133[0]: i2c eeprom 40: ff 22 00 c0 96 ff 03 30 15 00
ff ff ff ff ff ff
[    7.230302] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230309] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230316] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230323] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230330] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230337] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230344] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230350] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230357] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230364] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.230371] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[    7.412095] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    7.512683] hda_codec: ALC883: BIOS auto-probing.
[    7.512886] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:14.2/input/input7
[    7.516862] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    7.689107] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[    7.724034] tda829x 1-004b: setting tuner address to 60
[    7.800011] tda829x 1-004b: type set to tda8290+75a
[    8.294455] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto
2 vid 0x04E8 pid 0x325B
[    8.294500] usbcore: registered new interface driver usblp
[   10.814379] saa7133[0]: dsp access error
[   10.845083] saa7133[0]: registered device video0 [v4l2]
[   10.845111] saa7133[0]: registered device vbi0
[   10.845130] saa7133[0]: registered device radio0
[   10.950359] EXT3 FS on sda5, internal journal
[   10.996203] saa7134 ALSA driver for DMA sound loaded
[   10.996217] IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   10.996247] saa7133[0]/alsa: saa7133[0] at 0xfdbff000 irq 20
registered as card -1  <-- /* That's interesting? */
[   10.996349] BUG: unable to handle kernel NULL pointer dereference at
00000002 <-- ********** 1st null ptr deref
[   10.996962] IP: [<f8834cd4>] snd_pcm_timer_init+0x26/0xd1 [snd_pcm]
[   10.997255] *pde = 00000000·
[   10.997255] Oops: 0000 [#1] SMP·
[   10.997255] last sysfs file: /sys/module/saa7134/initstate
[   10.997255] Modules linked in: saa7134_alsa(+) usblp tda827x tda8290
snd_hda_codec_atihdmi tuner snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss saa7134 snd_seq_m
idi_event snd_seq snd_seq_device ir_common snd_pcm_oss snd_mixer_oss
v4l2_common videodev v4l1_compat videobuf_dma_sg videobuf_core snd_pcm
tveeprom snd_timer snd i2c_piix4 shpchp k8temp soundcore snd_pa
ge_alloc pcspkr r8169 ati_agp agpgart mii brd ata_generic pata_acpi ahci
pata_atiixp libata
[   10.997255]·
[   10.997255] Pid: 1141, comm: modprobe.bin Not tainted (2.6.30.4-126
#3) Unknow
[   10.997255] EIP: 0060:[<f8834cd4>] EFLAGS: 00010246 CPU: 1
[   10.997255] EIP is at snd_pcm_timer_init+0x26/0xd1 [snd_pcm]
[   10.997255] EAX: 00000002 EBX: f65c0e0c ECX: f6b2fe98 EDX: 00000000
[   10.997255] ESI: f65c0c00 EDI: 00000018 EBP: f6b2febc ESP: f6b2fe98
[   10.997255]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   10.997255] Process modprobe.bin (pid: 1141, ti=f6b2e000
task=f6a2caa0 task.ti=f6b2e000)
[   10.997255] Stack:
[   10.997255]  00000003 00000000 c030c2e9 f6b2feb8 f87ca221 00000000
f65c0e0c f6921400
[   10.997255]  00000018 f6b2feec f882da8f 00000001 f6921438 f88358e4
436d6370 63304432
[   10.997255]  f65c0c00 f87cf9fe f69b42a0 f65c0d70 f65c0c00 f6b2fefc
f87ce0bb f65c0e0c
[   10.997255] Call Trace:
[   10.997255]  [<c030c2e9>] ? device_create_file+0x13/0x15
[   10.997255]  [<f87ca221>] ? snd_add_device_sysfs_file+0x67/0x6e [snd]
[   10.997255]  [<f882da8f>] ? snd_pcm_dev_register+0x176/0x1de [snd_pcm]
[   10.997255]  [<f87ce0bb>] ? snd_device_register_all+0x27/0x44 [snd]
[   10.997255]  [<f87cadce>] ? snd_card_register+0x4c/0x131 [snd]
[   10.997255]  [<f8d17687>] ? alsa_device_init+0x200/0x24b [saa7134_alsa]
[   10.997255]  [<f8d1773d>] ? saa7134_alsa_init+0x6b/0x93 [saa7134_alsa]
[   10.997255]  [<c0101137>] ? do_one_initcall+0x4a/0x115
[   10.997255]  [<f8d176d2>] ? saa7134_alsa_init+0x0/0x93 [saa7134_alsa]
[   10.997255]  [<c0145205>] ? __blocking_notifier_call_chain+0x40/0x4c
[   10.997255]  [<c015302d>] ? sys_init_module+0x87/0x18b
[   10.997255]  [<c01031b4>] ? sysenter_do_call+0x12/0x28
[   11.066012] Code: 00 00 5b 5d c3 55 89 e5 57 56 53 89 c3 83 ec 18 8b
53 30 c7 45 e0 00 00 00 00 8d 4d dc c7 45 dc 03 00 00 00 8b 30 83 e2 01
8b 06 <8b> 00 89 45 e4 8b 46 0c 89 45 e8 8b 43 0c 01 c0 09
c2 8d 45 f0·
[   11.066012] EIP: [<f8834cd4>] snd_pcm_timer_init+0x26/0xd1 [snd_pcm]
SS:ESP 0068:f6b2fe98
[   11.066012] CR2: 0000000000000002
[   11.066318] ---[ end trace 000b75f3b1903e42 ]---
[   14.079154] r8169: eth0: link up
[   14.095472] r8169: eth0: link up
[   14.335980] r8169: eth0: link up
[   17.074440] NET: Registered protocol family 10
[   17.074879] lo: Disabled Privacy Extensions
[   20.520592] BUG: unable to handle kernel NULL pointer dereference at
00000002 <--  ********* 2nd nullptr deref
[   20.535353] IP: [<f8830abf>] snd_pcm_info+0x2e/0xe0 [snd_pcm]
[   20.535353] *pde = 00000000·
[   20.559932] Oops: 0000 [#2] SMP·
[   20.559932] last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:03:05.0/sound/card2/pcmC2D0c/pcm_class
[   20.586971] Modules linked in: ipv6 saa7134_alsa(+) usblp tda827x
tda8290 snd_hda_codec_atihdmi tuner snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_seq_dummy snd_hwdep snd_seq_oss saa7134 snd_
seq_midi_event snd_seq snd_seq_device ir_common snd_pcm_oss
snd_mixer_oss v4l2_common videodev v4l1_compat videobuf_dma_sg
videobuf_core snd_pcm tveeprom snd_timer snd i2c_piix4 shpchp k8temp
soundcore s
nd_page_alloc pcspkr r8169 ati_agp agpgart mii brd ata_generic pata_acpi
ahci pata_atiixp libata
[   20.606741]·
[   20.606741] Pid: 1367, comm: hald Tainted: G      D    (2.6.30.4-126
#3) Unknow[   20.704561] Process hald (pid: 1367, ti=f660e000
task=f6420c70 task.ti=f660e000)
[   20.704561] Stack:
[   20.704561]  f65c0e0c f65c0c00 f6ada3f0 f642fe00 f6919ac0 f660fe34
f882e15a f65c0e0c
[   20.704561]  00000200 f6ada3f0 f6ada3c0 f6667000 f660fe3c f882e254
f660fe70 f87cb9e9
[   20.704561]  f680db00 0160fe70 ffffffff f64cb870 f6919ac0 00001000
00000020 00000020
[   20.704561] Call Trace:
[   20.704561]  [<f882e15a>] ? snd_pcm_proc_info_read+0x80/0x16c [snd_pcm]
[   20.704561]  [<f882e254>] ? snd_pcm_stream_proc_info_read+0xe/0x10
[snd_pcm]
[   20.704561]  [<f87cb9e9>] ? snd_info_entry_open+0x26b/0x2de [snd]
[   20.704561]  [<c01df157>] ? proc_reg_open+0xb6/0x122
[   20.704561]  [<f87cb6ca>] ? snd_info_entry_release+0x0/0xa7 [snd]
[   20.704561]  [<c01ac441>] ? __dentry_open+0x119/0x207
[   20.704561]  [<c01ac5c9>] ? nameidata_to_filp+0x2c/0x43
[   20.704561]  [<c01df0a1>] ? proc_reg_open+0x0/0x122
[   20.704561]  [<c01b656b>] ? do_filp_open+0x3ae/0x6c8
[   20.704561]  [<c019ff47>] ? free_pages_and_swap_cache+0x44/0x57
[   20.704561]  [<c01b6937>] ? getname+0x20/0xb7
[   20.704561]  [<c01be23c>] ? alloc_fd+0x55/0xbe
[   20.704561]  [<c01ac253>] ? do_sys_open+0x44/0xba
[   20.704561]  [<c01ac30b>] ? sys_open+0x1e/0x26
[   20.704561]  [<c01031b4>] ? sysenter_do_call+0x12/0x28
[   20.704561] Code: 00 00 00 89 e5 57 56 53 89 d3 83 ec 08 89 df 89 45
ec 8b 00 8b 55 ec 89 45 f0 31 c0 8b 72 04 f3 ab 8b 55 f0 b9 40 00 00 00
8b 02 <8b> 00 89 43 0c 8b 42 0c 8b 55 ec 89 03 8b 42 30 89 43 08 8b 42·
[   20.704561] EIP: [<f8830abf>] snd_pcm_info+0x2e/0xe0 [snd_pcm] SS:ESP
0068:f660fe04
[   21.199052] CR2: 0000000000000002
[   21.222000] ---[ end trace 000b75f3b1903e43 ]---
[   20.606741] EIP: 0060:[<f8830abf>] EFLAGS: 00010246 CPU: 1
[   20.704561] EIP is at snd_pcm_info+0x2e/0xe0 [snd_pcm]
[   20.704561] EAX: 00000002 EBX: f642fe00 ECX: 00000040 EDX: f65c0c00
[   20.704561] ESI: 00000000 EDI: f642ff20 EBP: f660fe18 ESP: f660fe04
[   20.704561]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

The first dereference is happening at:

(gdb) list *snd_pcm_timer_init+0x26
0x7cf8 is in snd_pcm_timer_init
(/var/pisi/module-alsa-driver-1.0.20_20090808-49/work/alsa-driver/acore/../alsa-kernel/core/pcm_timer.c:131).
126             struct snd_timer_id tid;
127             struct snd_timer *timer;
128
129             tid.dev_sclass = SNDRV_TIMER_SCLASS_NONE;
130             tid.dev_class = SNDRV_TIMER_CLASS_PCM;
131             tid.card = substream->pcm->card->number;        <----------
132             tid.device = substream->pcm->device;
133             tid.subdevice = (substream->number << 1) |
(substream->stream & 1);
134             if (snd_timer_new(substream->pcm->card, "PCM", &tid,
&timer) < 0)
135                     return;at the following place:

Can it be related to a race condition between the sound card and the
saa7134-alsa interface?



