Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:55316 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0DZAmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 20:42:01 -0400
Received: by ewy20 with SMTP id 20so3501727ewy.1
        for <linux-media@vger.kernel.org>; Sun, 25 Apr 2010 17:42:00 -0700 (PDT)
Date: Mon, 26 Apr 2010 10:44:46 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org
Subject: tuner XC5000 race condition??
Message-ID: <20100426104446.01bca601@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Sometimes tuner XC5000 crashed on boot. This PC is dual-core.
It can be race condition or multi-core depend problem.

Add mutex for solve this problem is correct?

Crash boot dmesg

[   11.430108] Linux video capture interface: v2.00
[   11.503411] saa7130/34: v4l2 driver version 0.2.15 loaded
[   11.503554] saa7134 0000:04:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   11.503560] saa7133[0]: found at 0000:04:06.0, rev: 209, irq: 20, latency: 64, mmio: 0xfbfff800
[   11.503566] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[   11.503582] saa7133[0]: board init: gpio is 200000
[   11.503585] saa7134_ts_init1 start
[   11.503588] saa7134_ts_init_hw start
[   11.503589] saa7134_ts_init_hw stop
[   11.503590] saa7134_ts_init1 stop
[   11.503591] IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   11.645017] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[   11.645022] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645027] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645031] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645036] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645040] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645044] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645048] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645052] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645056] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645060] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645064] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645068] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645072] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645077] saa7133[0]: i2c eeprom e0: 72 41 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[   11.645081] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[   11.649016] saa7133[0]: i2c scan: found device @ 0x1e  [???]
[   11.655017] saa7133[0]: i2c scan: found device @ 0x5a  [remote control]
[   11.662017] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[   11.666017] saa7133[0]: i2c scan: found device @ 0xc2  [???]
[   11.696030] tuner 0-0061: chip found @ 0xc2 (saa7133[0])
[   11.991744] xc5000 0-0061: creating new instance
[   11.994016] xc5000: Successfully identified at address 0x61
[   11.994018] xc5000: Firmware has not been loaded previously

[   22.441412] input: i2c IR (BeholdTV) as /devices/virtual/irrcv/irrcv0/input5
[   22.441530] irrcv0: i2c IR (BeholdTV) as /devices/virtual/irrcv/irrcv0
[   22.441532] ir-kbd-i2c: i2c IR (BeholdTV) detected at i2c-0/0-002d/ir0 [saa7133[0]]
[   22.441869] saa7133[0]: registered device video0 [v4l2]
[   22.441882] saa7133[0]: registered device vbi0
[   22.441895] saa7133[0]: registered device radio0
[   22.495864] saa7134 ALSA driver for DMA sound loaded
[   22.495872] IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   22.495886] saa7133[0]/alsa: saa7133[0] at 0xfbfff800 irq 20 registered as card -2
[   22.634022] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[   22.634026] saa7134 0000:04:06.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[   22.638556] xc5000 I2C read failed (len=2)
[   22.669356] xc5000: I2C read failed
[   22.669904] xc5000: I2C read failed
[   22.669905] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[   22.669908] saa7134 0000:04:06.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[   22.669915] ------------[ cut here ]------------
[   22.669920] WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xd3/0xeb()
[   22.669921] Hardware name: System Product Name
[   22.669923] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:14.4/0000:04:06.0/firmware/0000:04:06.0'
[   22.669924] Modules linked in: dvb_core saa7134_alsa ir_kbd_i2c snd_hda_codec_atihdmi ipv6 snd_hda_codec_via snd_hda_intel snd_hda_codec snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi xc5000 snd_rawmidi snd_seq_midi_event snd_seq tuner snd_timer saa7134 snd_seq_device ir_common v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core snd ir_core soundcore shpchp tveeprom lirc_mceusb pci_hotplug snd_page_alloc i2c_piix4 fglrx(P) k10temp i2c_core lirc_dev iptable_filter lp ip_tables psmouse parport processor serio_raw x_tables asus_atk0110 evdev ext4 mbcache jbd2 crc16 fan fuse usb_storage ide_cd_mod sg cdrom usbhid hid ata_generic sd_mod pata_acpi pata_atiixp ide_pci_generic ahci ohci1394 atiixp thermal thermal_sys libata ieee1394 button r8169 mii ide_core ehci_hcd ohci_hcd scsi_mod
[   22.669959] Pid: 1852, comm: hald-probe-vide Tainted: P           2.6.33.1-skopa #3
[   22.669961] Call Trace:
[   22.669966]  [<ffffffff8103b718>] ? warn_slowpath_common+0x76/0x8c
[   22.669969]  [<ffffffff8103b780>] ? warn_slowpath_fmt+0x40/0x45
[   22.669971]  [<ffffffff81128c4e>] ? sysfs_add_one+0xd3/0xeb
[   22.669973]  [<ffffffff8112940e>] ? create_dir+0x4f/0x89
[   22.669976]  [<ffffffff8112947d>] ? sysfs_create_dir+0x35/0x46
[   22.669978]  [<ffffffff811719b0>] ? kobject_get+0x12/0x17
[   22.669980]  [<ffffffff81171ae1>] ? kobject_add_internal+0xc7/0x180
[   22.669982]  [<ffffffff81171d29>] ? kobject_add+0x66/0x6b
[   22.669984]  [<ffffffff811719b0>] ? kobject_get+0x12/0x17
[   22.669987]  [<ffffffff811efa37>] ? get_device_parent+0xfc/0x175
[   22.669988]  [<ffffffff811f08ed>] ? device_add+0xb8/0x4d7
[   22.669990]  [<ffffffff811f04e4>] ? device_private_init+0x97/0xa2
[   22.669992]  [<ffffffff811717b7>] ? kobject_init+0x42/0x82
[   22.669995]  [<ffffffff811f79be>] ? _request_firmware+0x325/0x4e4
[   22.669999]  [<ffffffffa00885a7>] ? xc_load_fw_and_init_tuner+0x60/0x24f [xc5000]
[   22.670001]  [<ffffffffa00881ed>] ? xc5000_readreg+0x81/0xa2 [xc5000]
[   22.670005]  [<ffffffff810b0000>] ? shmem_swp_map+0x1b/0x41
[   22.670007]  [<ffffffff810b0800>] ? shmem_getpage+0x1cc/0x637
[   22.670009]  [<ffffffffa0088aea>] ? xc5000_set_analog_params+0x2f/0x295 [xc5000]
[   22.670012]  [<ffffffff810b6398>] ? zone_statistics+0x3c/0x5d
[   22.670015]  [<ffffffffa00689c6>] ? set_radio_freq+0x15a/0x163 [tuner]
[   22.670018]  [<ffffffffa0068bd0>] ? set_freq+0x9f/0x281 [tuner]
[   22.670022]  [<ffffffffa05252f8>] ? saa_dsp_writel+0x108/0x160 [saa7134]
[   22.670024]  [<ffffffffa0069029>] ? tuner_s_radio+0xd3/0xda [tuner]
[   22.670028]  [<ffffffffa05294a9>] ? video_open+0x259/0x29f [saa7134]
[   22.670030]  [<ffffffff811f476b>] ? kobj_lookup+0x164/0x19e
[   22.670034]  [<ffffffffa04ed373>] ? v4l2_open+0x7c/0x99 [videodev]
[   22.670036]  [<ffffffff810dbae9>] ? chrdev_open+0x18f/0x1b0
[   22.670039]  [<ffffffff810db95a>] ? chrdev_open+0x0/0x1b0
[   22.670041]  [<ffffffff810d7742>] ? __dentry_open+0x18e/0x2c8
[   22.670043]  [<ffffffff810e0e94>] ? inode_permission+0x82/0xa1
[   22.670046]  [<ffffffff810e40e4>] ? do_filp_open+0x53a/0xaf1
[   22.670048]  [<ffffffff810bb21f>] ? handle_mm_fault+0x3b4/0x7c7
[   22.670051]  [<ffffffff8104aad1>] ? do_sigaction+0x11d/0x165
[   22.670053]  [<ffffffff810ec438>] ? alloc_fd+0x69/0x10a
[   22.670055]  [<ffffffff810d74d4>] ? do_sys_open+0x56/0xf9
[   22.670058]  [<ffffffff81002a02>] ? system_call_fastpath+0x16/0x1b
[   22.670060] ---[ end trace 52750182930514a3 ]---
[   22.670062] kobject_add_internal failed for 0000:04:06.0 with -EEXIST, don't try to register things with the same name in the same directory.
[   22.670065] Pid: 1852, comm: hald-probe-vide Tainted: P        W  2.6.33.1-skopa #3
[   22.670067] Call Trace:
[   22.670068]  [<ffffffff81171b70>] ? kobject_add_internal+0x156/0x180
[   22.670071]  [<ffffffff81171d29>] ? kobject_add+0x66/0x6b
[   22.670072]  [<ffffffff811719b0>] ? kobject_get+0x12/0x17
[   22.670074]  [<ffffffff811efa37>] ? get_device_parent+0xfc/0x175
[   22.670076]  [<ffffffff811f08ed>] ? device_add+0xb8/0x4d7
[   22.670078]  [<ffffffff811f04e4>] ? device_private_init+0x97/0xa2
[   22.670080]  [<ffffffff811717b7>] ? kobject_init+0x42/0x82
[   22.670082]  [<ffffffff811f79be>] ? _request_firmware+0x325/0x4e4
[   22.670093]  [<ffffffffa00885a7>] ? xc_load_fw_and_init_tuner+0x60/0x24f [xc5000]
[   22.670097]  [<ffffffffa00881ed>] ? xc5000_readreg+0x81/0xa2 [xc5000]
[   22.670100]  [<ffffffff810b0000>] ? shmem_swp_map+0x1b/0x41
[   22.670102]  [<ffffffff810b0800>] ? shmem_getpage+0x1cc/0x637
[   22.670104]  [<ffffffffa0088aea>] ? xc5000_set_analog_params+0x2f/0x295 [xc5000]
[   22.670106]  [<ffffffff810b6398>] ? zone_statistics+0x3c/0x5d
[   22.670109]  [<ffffffffa00689c6>] ? set_radio_freq+0x15a/0x163 [tuner]
[   22.670112]  [<ffffffffa0068bd0>] ? set_freq+0x9f/0x281 [tuner]
[   22.670116]  [<ffffffffa05252f8>] ? saa_dsp_writel+0x108/0x160 [saa7134]
[   22.670119]  [<ffffffffa0069029>] ? tuner_s_radio+0xd3/0xda [tuner]
[   22.670123]  [<ffffffffa05294a9>] ? video_open+0x259/0x29f [saa7134]
[   22.670126]  [<ffffffff811f476b>] ? kobj_lookup+0x164/0x19e
[   22.670128]  [<ffffffffa04ed373>] ? v4l2_open+0x7c/0x99 [videodev]
[   22.670131]  [<ffffffff810dbae9>] ? chrdev_open+0x18f/0x1b0
[   22.670134]  [<ffffffff810db95a>] ? chrdev_open+0x0/0x1b0
[   22.670136]  [<ffffffff810d7742>] ? __dentry_open+0x18e/0x2c8
[   22.670139]  [<ffffffff810e0e94>] ? inode_permission+0x82/0xa1
[   22.670141]  [<ffffffff810e40e4>] ? do_filp_open+0x53a/0xaf1
[   22.670144]  [<ffffffff810bb21f>] ? handle_mm_fault+0x3b4/0x7c7
[   22.670146]  [<ffffffff8104aad1>] ? do_sigaction+0x11d/0x165
[   22.670149]  [<ffffffff810ec438>] ? alloc_fd+0x69/0x10a
[   22.670151]  [<ffffffff810d74d4>] ? do_sys_open+0x56/0xf9
[   22.670154]  [<ffffffff81002a02>] ? system_call_fastpath+0x16/0x1b
[   22.670156] saa7134 0000:04:06.0: fw_register_device: device_register failed
[   22.670162] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
[   22.670165] IP: [<ffffffff811f6f12>] fw_dev_release+0x25/0x5b
[   22.670167] PGD 3768d067 PUD 5e56c067 PMD 0 
[   22.670170] Oops: 0000 [#1] SMP 
[   22.670172] last sysfs file: /sys/devices/pci0000:00/0000:00:14.4/0000:04:06.0/video4linux/radio0/index
[   22.670175] CPU 1 
[   22.670178] Pid: 1852, comm: hald-probe-vide Tainted: P        W  2.6.33.1-skopa #3 M4A785G-HTPC/System Product Name
[   22.670181] RIP: 0010:[<ffffffff811f6f12>]  [<ffffffff811f6f12>] fw_dev_release+0x25/0x5b
[   22.670184] RSP: 0018:ffff88005d7a5a38  EFLAGS: 00010246
[   22.670186] RAX: 0000000000000000 RBX: ffff8800379c1e00 RCX: 0000000000000016
[   22.670188] RDX: ffffffff81532c01 RSI: 0000000000000040 RDI: ffff8800379c1e00
[   22.670189] RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000005
[   22.670191] R10: 0000000000000000 R11: 0000000000000078 R12: 0000000000000000
[   22.670193] R13: ffff880037a70b40 R14: ffff88005f197b80 R15: ffff88005d7a5b70
[   22.670196] FS:  00007f9946b0e6f0(0000) GS:ffff880001640000(0000) knlGS:0000000000000000
[   22.670197] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.670200] CR2: 0000000000000080 CR3: 000000005dba9000 CR4: 00000000000006e0
[   22.670201] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.670204] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   22.670205] Process hald-probe-vide (pid: 1852, threadinfo ffff88005d7a4000, task ffff88005cc20480)
[   22.670208] Stack:
[   22.670208]  0000000000000000 ffff880037b9e6c0 ffffffff81458cf0 ffffffff811efe94
[   22.670211] <0> ffff8800379c1e10 ffffffff81171988 ffff8800379c1e48 ffffffff81171940
[   22.670214] <0> 00000000ffffffef ffffffff811726e1 0000000000000002 ffff8800379c1e00
[   22.670217] Call Trace:
[   22.670219]  [<ffffffff811efe94>] ? device_release+0x41/0x6a
[   22.670222]  [<ffffffff81171988>] ? kobject_release+0x48/0x5e
[   22.670224]  [<ffffffff81171940>] ? kobject_release+0x0/0x5e
[   22.670226]  [<ffffffff811726e1>] ? kref_put+0x41/0x4a
[   22.670229]  [<ffffffff811f79f8>] ? _request_firmware+0x35f/0x4e4
[   22.670232]  [<ffffffffa00885a7>] ? xc_load_fw_and_init_tuner+0x60/0x24f [xc5000]
[   22.670236]  [<ffffffffa00881ed>] ? xc5000_readreg+0x81/0xa2 [xc5000]
[   22.670238]  [<ffffffff810b0000>] ? shmem_swp_map+0x1b/0x41
[   22.670240]  [<ffffffff810b0800>] ? shmem_getpage+0x1cc/0x637
[   22.670243]  [<ffffffffa0088aea>] ? xc5000_set_analog_params+0x2f/0x295 [xc5000]
[   22.670246]  [<ffffffff810b6398>] ? zone_statistics+0x3c/0x5d
[   22.670248]  [<ffffffffa00689c6>] ? set_radio_freq+0x15a/0x163 [tuner]
[   22.670251]  [<ffffffffa0068bd0>] ? set_freq+0x9f/0x281 [tuner]
[   22.670255]  [<ffffffffa05252f8>] ? saa_dsp_writel+0x108/0x160 [saa7134]
[   22.670258]  [<ffffffffa0069029>] ? tuner_s_radio+0xd3/0xda [tuner]
[   22.670262]  [<ffffffffa05294a9>] ? video_open+0x259/0x29f [saa7134]
[   22.670265]  [<ffffffff811f476b>] ? kobj_lookup+0x164/0x19e
[   22.670268]  [<ffffffffa04ed373>] ? v4l2_open+0x7c/0x99 [videodev]
[   22.670270]  [<ffffffff810dbae9>] ? chrdev_open+0x18f/0x1b0
[   22.670273]  [<ffffffff810db95a>] ? chrdev_open+0x0/0x1b0
[   22.670275]  [<ffffffff810d7742>] ? __dentry_open+0x18e/0x2c8
[   22.670278]  [<ffffffff810e0e94>] ? inode_permission+0x82/0xa1
[   22.670281]  [<ffffffff810e40e4>] ? do_filp_open+0x53a/0xaf1
[   22.670284]  [<ffffffff810bb21f>] ? handle_mm_fault+0x3b4/0x7c7
[   22.670286]  [<ffffffff8104aad1>] ? do_sigaction+0x11d/0x165
[   22.670288]  [<ffffffff810ec438>] ? alloc_fd+0x69/0x10a
[   22.670290]  [<ffffffff810d74d4>] ? do_sys_open+0x56/0xf9
[   22.670292]  [<ffffffff81002a02>] ? system_call_fastpath+0x16/0x1b
[   22.670293] Code: f8 ff 5b 48 98 c3 41 54 45 31 e4 55 53 48 89 fb e8 b5 b8 ff ff 48 89 c5 eb 11 49 63 c4 31 f6 41 ff c4 48 8b 3c c7 e8 37 1b eb ff <44> 3b a5 80 00 00 00 48 8b 7d 78 7c e2 e8 71 b1 ed ff 48 8b 7d 
[   22.670309] RIP  [<ffffffff811f6f12>] fw_dev_release+0x25/0x5b
[   22.670311]  RSP <ffff88005d7a5a38>
[   22.670312] CR2: 0000000000000080
[   22.670314] ---[ end trace 52750182930514a4 ]---
[   22.739108] xc5000: I2C write failed (len=4)
[   22.741977] xc5000: I2C read failed
[   22.741987] xc5000: I2C read failed
[   22.741988] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[   22.741990] saa7134 0000:04:06.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[   22.741997] ------------[ cut here ]------------
[   22.742005] WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xd3/0xeb()
[   22.742006] Hardware name: System Product Name
[   22.742008] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:14.4/0000:04:06.0/firmware/0000:04:06.0'
[   22.742009] Modules linked in: videobuf_dvb dvb_core saa7134_alsa ir_kbd_i2c snd_hda_codec_atihdmi ipv6 snd_hda_codec_via snd_hda_intel snd_hda_codec snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi xc5000 snd_rawmidi snd_seq_midi_event snd_seq tuner snd_timer saa7134 snd_seq_device ir_common v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core snd ir_core soundcore shpchp tveeprom lirc_mceusb pci_hotplug snd_page_alloc i2c_piix4 fglrx(P) k10temp i2c_core lirc_dev iptable_filter lp ip_tables psmouse parport processor serio_raw x_tables asus_atk0110 evdev ext4 mbcache jbd2 crc16 fan fuse usb_storage ide_cd_mod sg cdrom usbhid hid ata_generic sd_mod pata_acpi pata_atiixp ide_pci_generic ahci ohci1394 atiixp thermal thermal_sys libata ieee1394 button r8169 mii ide_core ehci_hcd ohci_hcd scsi_mod
[   22.742043] Pid: 1870, comm: hald-probe-vide Tainted: P      D W  2.6.33.1-skopa #3
[   22.742044] Call Trace:
[   22.742048]  [<ffffffff8103b718>] ? warn_slowpath_common+0x76/0x8c
[   22.742051]  [<ffffffff8103b780>] ? warn_slowpath_fmt+0x40/0x45
[   22.742053]  [<ffffffff81128c4e>] ? sysfs_add_one+0xd3/0xeb
[   22.742055]  [<ffffffff8112940e>] ? create_dir+0x4f/0x89
[   22.742058]  [<ffffffff8112947d>] ? sysfs_create_dir+0x35/0x46
[   22.742060]  [<ffffffff811719b0>] ? kobject_get+0x12/0x17
[   22.742062]  [<ffffffff81171ae1>] ? kobject_add_internal+0xc7/0x180
[   22.742064]  [<ffffffff81171d29>] ? kobject_add+0x66/0x6b
[   22.742066]  [<ffffffff811719b0>] ? kobject_get+0x12/0x17
[   22.742068]  [<ffffffff811efa37>] ? get_device_parent+0xfc/0x175
[   22.742070]  [<ffffffff811f08ed>] ? device_add+0xb8/0x4d7
[   22.742072]  [<ffffffff811f04e4>] ? device_private_init+0x97/0xa2
[   22.742074]  [<ffffffff811717b7>] ? kobject_init+0x42/0x82
[   22.742076]  [<ffffffff811f79be>] ? _request_firmware+0x325/0x4e4
[   22.742079]  [<ffffffffa00885a7>] ? xc_load_fw_and_init_tuner+0x60/0x24f [xc5000]
[   22.742082]  [<ffffffffa00881ed>] ? xc5000_readreg+0x81/0xa2 [xc5000]
[   22.742094]  [<ffffffff810b0000>] ? shmem_swp_map+0x1b/0x41
[   22.742097]  [<ffffffff810b0800>] ? shmem_getpage+0x1cc/0x637
[   22.742100]  [<ffffffffa0088aea>] ? xc5000_set_analog_params+0x2f/0x295 [xc5000]
[   22.742102]  [<ffffffff810b6398>] ? zone_statistics+0x3c/0x5d
[   22.742105]  [<ffffffffa0068d6b>] ? set_freq+0x23a/0x281 [tuner]
[   22.742107]  [<ffffffffa00696ca>] ? tuner_s_std+0x69a/0x6a5 [tuner]
[   22.742112]  [<ffffffffa0527087>] ? saa7134_set_tvnorm_hw+0x256/0x301 [saa7134]
[   22.742116]  [<ffffffffa0527e6d>] ? video_mux+0x63/0x84 [saa7134]
[   22.742120]  [<ffffffffa05294de>] ? video_open+0x28e/0x29f [saa7134]
[   22.742124]  [<ffffffff811f476b>] ? kobj_lookup+0x164/0x19e
[   22.742127]  [<ffffffffa04ed373>] ? v4l2_open+0x7c/0x99 [videodev]
[   22.742130]  [<ffffffff810dbae9>] ? chrdev_open+0x18f/0x1b0
[   22.742133]  [<ffffffff810db95a>] ? chrdev_open+0x0/0x1b0
[   22.742135]  [<ffffffff810d7742>] ? __dentry_open+0x18e/0x2c8
[   22.742138]  [<ffffffff810e0e94>] ? inode_permission+0x82/0xa1
[   22.742141]  [<ffffffff810e40e4>] ? do_filp_open+0x53a/0xaf1
[   22.742144]  [<ffffffff810bb21f>] ? handle_mm_fault+0x3b4/0x7c7
[   22.742147]  [<ffffffff8104aad1>] ? do_sigaction+0x11d/0x165
[   22.742150]  [<ffffffff810ec438>] ? alloc_fd+0x69/0x10a
[   22.742152]  [<ffffffff810d74d4>] ? do_sys_open+0x56/0xf9
[   22.742155]  [<ffffffff81002a02>] ? system_call_fastpath+0x16/0x1b
[   22.742157] ---[ end trace 52750182930514a5 ]---
[   22.742159] kobject_add_internal failed for 0000:04:06.0 with -EEXIST, don't try to register things with the same name in the same directory.
[   22.742163] Pid: 1870, comm: hald-probe-vide Tainted: P      D W  2.6.33.1-skopa #3
[   22.742164] Call Trace:
[   22.742167]  [<ffffffff81171b70>] ? kobject_add_internal+0x156/0x180
[   22.742169]  [<ffffffff81171d29>] ? kobject_add+0x66/0x6b
[   22.742172]  [<ffffffff811719b0>] ? kobject_get+0x12/0x17
[   22.742174]  [<ffffffff811efa37>] ? get_device_parent+0xfc/0x175
[   22.742177]  [<ffffffff811f08ed>] ? device_add+0xb8/0x4d7
[   22.742179]  [<ffffffff811f04e4>] ? device_private_init+0x97/0xa2
[   22.742181]  [<ffffffff811717b7>] ? kobject_init+0x42/0x82
[   22.742183]  [<ffffffff811f79be>] ? _request_firmware+0x325/0x4e4
[   22.742187]  [<ffffffffa00885a7>] ? xc_load_fw_and_init_tuner+0x60/0x24f [xc5000]
[   22.742190]  [<ffffffffa00881ed>] ? xc5000_readreg+0x81/0xa2 [xc5000]
[   22.742193]  [<ffffffff810b0000>] ? shmem_swp_map+0x1b/0x41
[   22.742195]  [<ffffffff810b0800>] ? shmem_getpage+0x1cc/0x637
[   22.742198]  [<ffffffffa0088aea>] ? xc5000_set_analog_params+0x2f/0x295 [xc5000]
[   22.742201]  [<ffffffff810b6398>] ? zone_statistics+0x3c/0x5d
[   22.742203]  [<ffffffffa0068d6b>] ? set_freq+0x23a/0x281 [tuner]
[   22.742206]  [<ffffffffa00696ca>] ? tuner_s_std+0x69a/0x6a5 [tuner]
[   22.742210]  [<ffffffffa0527087>] ? saa7134_set_tvnorm_hw+0x256/0x301 [saa7134]
[   22.742214]  [<ffffffffa0527e6d>] ? video_mux+0x63/0x84 [saa7134]
[   22.742217]  [<ffffffffa05294de>] ? video_open+0x28e/0x29f [saa7134]
[   22.742220]  [<ffffffff811f476b>] ? kobj_lookup+0x164/0x19e
[   22.742224]  [<ffffffffa04ed373>] ? v4l2_open+0x7c/0x99 [videodev]
[   22.742226]  [<ffffffff810dbae9>] ? chrdev_open+0x18f/0x1b0
[   22.742229]  [<ffffffff810db95a>] ? chrdev_open+0x0/0x1b0
[   22.742232]  [<ffffffff810d7742>] ? __dentry_open+0x18e/0x2c8
[   22.742234]  [<ffffffff810e0e94>] ? inode_permission+0x82/0xa1
[   22.742236]  [<ffffffff810e40e4>] ? do_filp_open+0x53a/0xaf1
[   22.742240]  [<ffffffff810bb21f>] ? handle_mm_fault+0x3b4/0x7c7
[   22.742242]  [<ffffffff8104aad1>] ? do_sigaction+0x11d/0x165
[   22.742245]  [<ffffffff810ec438>] ? alloc_fd+0x69/0x10a
[   22.742247]  [<ffffffff810d74d4>] ? do_sys_open+0x56/0xf9
[   22.742249]  [<ffffffff81002a02>] ? system_call_fastpath+0x16/0x1b
[   22.742252] saa7134 0000:04:06.0: fw_register_device: device_register failed
[   22.742256] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
[   22.742259] IP: [<ffffffff811f6f12>] fw_dev_release+0x25/0x5b
[   22.742262] PGD 378a5067 PUD 5c65c067 PMD 0 
[   22.742264] Oops: 0000 [#2] SMP 
[   22.742267] last sysfs file: /sys/devices/pci0000:00/0000:00:14.4/0000:04:06.0/video4linux/vbi0/index
[   22.742269] CPU 1 
[   22.742271] Pid: 1870, comm: hald-probe-vide Tainted: P      D W  2.6.33.1-skopa #3 M4A785G-HTPC/System Product Name
[   22.742274] RIP: 0010:[<ffffffff811f6f12>]  [<ffffffff811f6f12>] fw_dev_release+0x25/0x5b
[   22.742277] RSP: 0018:ffff88005d49ba38  EFLAGS: 00010246
[   22.742278] RAX: 0000000000000000 RBX: ffff8800379c1c00 RCX: 0000000000000016
[   22.742280] RDX: ffffffff81532c01 RSI: 0000000000000040 RDI: ffff8800379c1c00
[   22.742282] RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000005
[   22.742283] R10: 0000000000000000 R11: 0000000000000064 R12: 0000000000000000
[   22.742285] R13: ffff880037b9e6a0 R14: ffff88005f197b80 R15: ffff88005d49bb70
[   22.742287] FS:  00007fd00fda86f0(0000) GS:ffff880001640000(0000) knlGS:0000000000000000
[   22.742289] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.742290] CR2: 0000000000000080 CR3: 000000005d62f000 CR4: 00000000000006e0
[   22.742292] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.742293] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   22.742295] Process hald-probe-vide (pid: 1870, threadinfo ffff88005d49a000, task ffff88005cc20480)
[   22.742297] Stack:
[   22.742297]  0000000000000000 ffff880037b9e660 ffffffff81458cf0 ffffffff811efe94
[   22.742300] <0> ffff8800379c1c10 ffffffff81171988 ffff8800379c1c48 ffffffff81171940
[   22.742302] <0> 00000000ffffffef ffffffff811726e1 0000000000000002 ffff8800379c1c00
[   22.742305] Call Trace:
[   22.742307]  [<ffffffff811efe94>] ? device_release+0x41/0x6a
[   22.742309]  [<ffffffff81171988>] ? kobject_release+0x48/0x5e
[   22.742311]  [<ffffffff81171940>] ? kobject_release+0x0/0x5e
[   22.742313]  [<ffffffff811726e1>] ? kref_put+0x41/0x4a
[   22.742315]  [<ffffffff811f79f8>] ? _request_firmware+0x35f/0x4e4
[   22.742317]  [<ffffffffa00885a7>] ? xc_load_fw_and_init_tuner+0x60/0x24f [xc5000]
[   22.742320]  [<ffffffffa00881ed>] ? xc5000_readreg+0x81/0xa2 [xc5000]
[   22.742322]  [<ffffffff810b0000>] ? shmem_swp_map+0x1b/0x41
[   22.742324]  [<ffffffff810b0800>] ? shmem_getpage+0x1cc/0x637
[   22.742327]  [<ffffffffa0088aea>] ? xc5000_set_analog_params+0x2f/0x295 [xc5000]
[   22.742330]  [<ffffffff810b6398>] ? zone_statistics+0x3c/0x5d
[   22.742332]  [<ffffffffa0068d6b>] ? set_freq+0x23a/0x281 [tuner]
[   22.742335]  [<ffffffffa00696ca>] ? tuner_s_std+0x69a/0x6a5 [tuner]
[   22.742339]  [<ffffffffa0527087>] ? saa7134_set_tvnorm_hw+0x256/0x301 [saa7134]
[   22.742343]  [<ffffffffa0527e6d>] ? video_mux+0x63/0x84 [saa7134]
[   22.742346]  [<ffffffffa05294de>] ? video_open+0x28e/0x29f [saa7134]
[   22.742350]  [<ffffffff811f476b>] ? kobj_lookup+0x164/0x19e
[   22.742353]  [<ffffffffa04ed373>] ? v4l2_open+0x7c/0x99 [videodev]
[   22.742356]  [<ffffffff810dbae9>] ? chrdev_open+0x18f/0x1b0
[   22.742358]  [<ffffffff810db95a>] ? chrdev_open+0x0/0x1b0
[   22.742361]  [<ffffffff810d7742>] ? __dentry_open+0x18e/0x2c8
[   22.742363]  [<ffffffff810e0e94>] ? inode_permission+0x82/0xa1
[   22.742366]  [<ffffffff810e40e4>] ? do_filp_open+0x53a/0xaf1
[   22.742368]  [<ffffffff810bb21f>] ? handle_mm_fault+0x3b4/0x7c7
[   22.742371]  [<ffffffff8104aad1>] ? do_sigaction+0x11d/0x165
[   22.742373]  [<ffffffff810ec438>] ? alloc_fd+0x69/0x10a
[   22.742376]  [<ffffffff810d74d4>] ? do_sys_open+0x56/0xf9
[   22.742378]  [<ffffffff81002a02>] ? system_call_fastpath+0x16/0x1b
[   22.742380] Code: f8 ff 5b 48 98 c3 41 54 45 31 e4 55 53 48 89 fb e8 b5 b8 ff ff 48 89 c5 eb 11 49 63 c4 31 f6 41 ff c4 48 8b 3c c7 e8 37 1b eb ff <44> 3b a5 80 00 00 00 48 8b 7d 78 7c e2 e8 71 b1 ed ff 48 8b 7d 
[   22.742398] RIP  [<ffffffff811f6f12>] fw_dev_release+0x25/0x5b
[   22.742401]  RSP <ffff88005d49ba38>
[   22.742402] CR2: 0000000000000080
[   22.742404] ---[ end trace 52750182930514a6 ]---
[   22.762206] dvb_init() allocating 1 frontend
[   22.793092] zl10353_read_register: readreg error (reg=127, ret==-5)
[   22.793124] saa7133[0]/dvb: frontend initialization failed
[   22.852534] xc5000: firmware read 12401 bytes.
[   22.852536] xc5000: firmware uploading...

[   25.061017] xc5000: firmware upload complete...


Normal boot dmesg:

[    8.173166] Linux video capture interface: v2.00
[    9.242523] pci 0000:01:05.0: setting latency timer to 64
[    9.341975] saa7130/34: v4l2 driver version 0.2.15 loaded
[    9.343390] saa7134 0000:04:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    9.343396] saa7133[0]: found at 0000:04:06.0, rev: 209, irq: 20, latency: 64, mmio: 0xfbfff800
[    9.343402] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[    9.343416] saa7133[0]: board init: gpio is 200000
[    9.343419] saa7134_ts_init1 start
[    9.343422] saa7134_ts_init_hw start
[    9.343423] saa7134_ts_init_hw stop
[    9.343424] saa7134_ts_init1 stop
[    9.343425] IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    9.484016] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[    9.484021] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484026] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484030] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484034] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484038] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484042] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484047] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484051] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484055] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484059] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484063] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484067] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484071] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484075] saa7133[0]: i2c eeprom e0: 72 41 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[    9.484079] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[    9.488016] saa7133[0]: i2c scan: found device @ 0x1e  [???]
[    9.494016] saa7133[0]: i2c scan: found device @ 0x5a  [remote control]
[    9.501016] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[    9.505016] saa7133[0]: i2c scan: found device @ 0xc2  [???]
[    9.593071] tuner 0-0061: chip found @ 0xc2 (saa7133[0])
[    9.713779] xc5000 0-0061: creating new instance
[    9.716018] xc5000: Successfully identified at address 0x61
[    9.716020] xc5000: Firmware has been loaded previously
[   10.908478] input: i2c IR (BeholdTV) as /devices/virtual/irrcv/irrcv0/input5
[   10.908507] irrcv0: i2c IR (BeholdTV) as /devices/virtual/irrcv/irrcv0
[   10.908508] ir-kbd-i2c: i2c IR (BeholdTV) detected at i2c-0/0-002d/ir0 [saa7133[0]]
[   10.910885] saa7133[0]: registered device video0 [v4l2]
[   10.910901] saa7133[0]: registered device vbi0
[   10.910914] saa7133[0]: registered device radio0
[   10.938417] saa7134 ALSA driver for DMA sound loaded
[   10.938423] IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.938438] saa7133[0]/alsa: saa7133[0] at 0xfbfff800 irq 20 registered as card -2
[   11.034091] dvb_init() allocating 1 frontend
[   11.054136] xc5000 0-0061: attaching existing instance
[   11.057099] xc5000: Successfully identified at address 0x61
[   11.057101] xc5000: Firmware has been loaded previously
[   11.057103] DVB: registering new adapter (saa7133[0])
[   11.057106] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   11.128126] xc5000: I2C write failed (len=4)
[   11.128141] xc5000: I2C write failed (len=4)
[   11.129005] xc5000: I2C write failed (len=2)
[   11.129020] zl10353: write to reg 50 failed (err = -5)!
[   11.129574] zl10353: write to reg 50 failed (err = -5)!
[   29.504215] xc5000: I2C write failed (len=4)
[   29.504228] xc5000: I2C write failed (len=4)
[   29.504897] xc5000: I2C write failed (len=2)

[   38.832401] zl10353_dvb_bus_ctrl() acquire = 1
[   38.832403] set SAA7134_MPEG_DVB
[   38.834101] set REG done
[   39.013050] zl10353_dvb_bus_ctrl() acquire = 0
[   39.013052] set SAA7134_MPEG_EMPRESS
[   39.015015] set REG done
[   39.026039] zl10353_dvb_bus_ctrl() acquire = 1
[   39.026041] set SAA7134_MPEG_DVB
[   39.028017] set REG done
[   39.039026] zl10353_dvb_bus_ctrl() acquire = 0
[   39.039027] set SAA7134_MPEG_EMPRESS
[   39.041017] set REG done
[   39.053023] zl10353_dvb_bus_ctrl() acquire = 1
[   39.053024] set SAA7134_MPEG_DVB
[   39.056016] set REG done
[   40.435148] zl10353_dvb_bus_ctrl() acquire = 0
[   40.435150] set SAA7134_MPEG_EMPRESS
[   40.437100] set REG done
[   51.533543] zl10353_dvb_bus_ctrl() acquire = 1
[   51.533545] set SAA7134_MPEG_DVB
[   51.536017] set REG done
[   52.939682] saa7134_ts_start start
[   52.939685] TS start HERE
[   52.939686] saa7134_ts_start stop
[   52.952502] saa7134_ts_stop start
[   52.952504] saa7134_ts_stop stop
[   53.954460] saa7134_ts_start start
[   53.954464] TS start HERE
[   53.954465] saa7134_ts_start stop
[   54.509791] saa7134_ts_stop start
[   54.509794] saa7134_ts_stop stop
[   55.589915] saa7134_ts_start start
[   55.589918] TS start HERE
[   55.589919] saa7134_ts_start stop

With my best regards, Dmitry.
