Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:44016 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbeD3EyE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 00:54:04 -0400
Received: by mail-qt0-f177.google.com with SMTP id l11-v6so9560636qtj.10
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2018 21:54:04 -0700 (PDT)
To: linux-media@vger.kernel.org
Cc: alexandrexavier@live.ca
From: =?UTF-8?Q?Alexandre-Xavier_Labont=c3=a9-Lamoureux?=
        <axdoomer@gmail.com>
Subject: "BUG: unable to handle kernel NULL pointer dereference" in em28xx
 driver
Message-ID: <5619cde3-5051-67aa-3229-1519c000f0ec@gmail.com>
Date: Mon, 30 Apr 2018 00:54:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is another report for a crash that happened right after I disconnected a device. It froze the computer with the call trace displayed on the screen and the message "BUG: unable to handle kernel NULL pointer dereference at 0000000000000139". The call trace shows that it happened inside of "media_remove_intf_links". All the relevant information from /var/log/kern.log can be found below:

Apr 29 23:10:53 limus kernel: [    0.000000] Linux version 4.9.0-6-amd64 (debian-kernel@lists.debian.org) (gcc version 6.3.0 20170516 (Debian 6.3.0-18+deb9u1) ) #1 SMP Debian 4.9.82-1+deb9u3 (2018-03-02)

Apr 29 23:12:04 limus kernel: [   85.688050] usb 5-4: new high-speed USB device number 3 using ehci-pci
Apr 29 23:12:04 limus kernel: [   85.842950] usb 5-4: New USB device found, idVendor=093b, idProduct=a003
Apr 29 23:12:04 limus kernel: [   85.842953] usb 5-4: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Apr 29 23:12:04 limus kernel: [   85.842956] usb 5-4: Product: ConvertX AV100U A/V Capture
Apr 29 23:12:04 limus kernel: [   85.842958] usb 5-4: Manufacturer: Plextor
Apr 29 23:12:04 limus kernel: [   85.965017] media: Linux media interface: v0.10
Apr 29 23:12:04 limus kernel: [   85.998454] Linux video capture interface: v2.00
Apr 29 23:12:04 limus kernel: [   86.053196] em28xx: New device Plextor ConvertX AV100U A/V Capture @ 480 Mbps (093b:a003, interface 0, class 0)
Apr 29 23:12:04 limus kernel: [   86.053198] em28xx: Video interface 0 found: bulk isoc
Apr 29 23:12:04 limus kernel: [   86.053361] em28xx: chip ID is em2710/2820
Apr 29 23:12:04 limus kernel: [   86.197128] em2710/2820 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x439a4c10
Apr 29 23:12:04 limus kernel: [   86.197130] em2710/2820 #0: EEPROM info:
Apr 29 23:12:04 limus kernel: [   86.197132] em2710/2820 #0: 	AC97 audio (5 sample rates)
Apr 29 23:12:04 limus kernel: [   86.197132] em2710/2820 #0: 	500mA max power
Apr 29 23:12:04 limus kernel: [   86.197134] em2710/2820 #0: 	Table at offset 0x06, strings=0x3a7c, 0x126a, 0x0000
Apr 29 23:12:04 limus kernel: [   86.197136] em2710/2820 #0: Identified as Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U (card=9)
Apr 29 23:12:04 limus kernel: [   86.197138] em2710/2820 #0: analog set to isoc mode.
Apr 29 23:12:04 limus kernel: [   86.197241] em28xx audio device (093b:a003): interface 1, class 1
Apr 29 23:12:04 limus kernel: [   86.197254] em28xx audio device (093b:a003): interface 2, class 1
Apr 29 23:12:04 limus kernel: [   86.197272] usbcore: registered new interface driver em28xx
Apr 29 23:12:04 limus kernel: [   86.240334] em2710/2820 #0: Registering V4L2 extension
Apr 29 23:12:05 limus kernel: [   86.595315] em2710/2820 #0: failed to get i2c transfer status from bridge register (error=-5)
Apr 29 23:12:05 limus kernel: [   86.851219] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:05 limus kernel: [   87.107254] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:06 limus kernel: [   87.391293] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:06 limus kernel: [   87.647328] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:06 limus kernel: [   87.903235] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:06 limus kernel: [   88.159276] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:07 limus kernel: [   88.415303] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:07 limus kernel: [   88.671333] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:07 limus kernel: [   88.927241] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:07 limus kernel: [   89.183272] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:08 limus kernel: [   89.439180] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:08 limus kernel: [   89.695212] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:08 limus kernel: [   89.951240] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:08 limus kernel: [   90.207269] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:09 limus kernel: [   90.463300] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:09 limus kernel: [   90.719212] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:09 limus kernel: [   90.975232] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:09 limus kernel: [   91.231262] em2710/2820 #0: writing to i2c device at 0x4a failed (error=-5)
Apr 29 23:12:09 limus kernel: [   91.372480] usbcore: registered new interface driver snd-usb-audio
Apr 29 23:12:10 limus kernel: [   91.524795] em2710/2820 #0: Config register raw data: 0x10
Apr 29 23:12:10 limus kernel: [   91.556173] em2710/2820 #0: AC97 vendor ID = 0xffffffff
Apr 29 23:12:10 limus kernel: [   91.572175] em2710/2820 #0: AC97 features = 0x6a90
Apr 29 23:12:10 limus kernel: [   91.572176] em2710/2820 #0: Empia 202 AC97 audio processor detected
Apr 29 23:12:13 limus kernel: [   94.600238] em2710/2820 #0: failed to create media graph
Apr 29 23:12:13 limus kernel: [   94.600245] em2710/2820 #0: V4L2 device video0 deregistered
Apr 29 23:12:13 limus kernel: [   94.600752] em28xx: Registered (Em28xx v4l2 Extension) extension
Apr 29 23:13:07 limus kernel: [  148.762772] usb 5-4: USB disconnect, device number 3
Apr 29 23:13:07 limus kernel: [  148.762858] em2710/2820 #0: Disconnecting em2710/2820 #0
Apr 29 23:13:07 limus kernel: [  148.762948] em2710/2820 #0: Freeing device
Apr 29 23:13:09 limus kernel: [  151.120023] usb 5-4: new high-speed USB device number 4 using ehci-pci
Apr 29 23:13:09 limus kernel: [  151.274979] usb 5-4: New USB device found, idVendor=093b, idProduct=a003
Apr 29 23:13:09 limus kernel: [  151.274982] usb 5-4: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Apr 29 23:13:09 limus kernel: [  151.274984] usb 5-4: Product: ConvertX AV100U A/V Capture
Apr 29 23:13:09 limus kernel: [  151.274986] usb 5-4: Manufacturer: Plextor
Apr 29 23:13:09 limus kernel: [  151.275270] em28xx: New device Plextor ConvertX AV100U A/V Capture @ 480 Mbps (093b:a003, interface 0, class 0)
Apr 29 23:13:09 limus kernel: [  151.275272] em28xx: Video interface 0 found: bulk isoc
Apr 29 23:13:09 limus kernel: [  151.275352] em28xx: chip ID is em2710/2820
Apr 29 23:13:10 limus kernel: [  151.417088] em2710/2820 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x439a4c10
Apr 29 23:13:10 limus kernel: [  151.417089] em2710/2820 #0: EEPROM info:
Apr 29 23:13:10 limus kernel: [  151.417090] em2710/2820 #0: 	AC97 audio (5 sample rates)
Apr 29 23:13:10 limus kernel: [  151.417091] em2710/2820 #0: 	500mA max power
Apr 29 23:13:10 limus kernel: [  151.417093] em2710/2820 #0: 	Table at offset 0x06, strings=0x3a7c, 0x126a, 0x0000
Apr 29 23:13:10 limus kernel: [  151.417095] em2710/2820 #0: Identified as Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U (card=9)
Apr 29 23:13:10 limus kernel: [  151.417096] em2710/2820 #0: analog set to isoc mode.
Apr 29 23:13:10 limus kernel: [  151.417137] em2710/2820 #0: Registering V4L2 extension
Apr 29 23:13:10 limus kernel: [  151.417252] em28xx audio device (093b:a003): interface 1, class 1
Apr 29 23:13:10 limus kernel: [  151.936534] saa7115 8-0025: saa7113 found @ 0x4a (em2710/2820 #0)
Apr 29 23:13:11 limus kernel: [  152.964287] em2710/2820 #0: Config register raw data: 0x10
Apr 29 23:13:11 limus kernel: [  152.996158] em2710/2820 #0: AC97 vendor ID = 0xffffffff
Apr 29 23:13:11 limus kernel: [  153.012282] em2710/2820 #0: AC97 features = 0x6a90
Apr 29 23:13:11 limus kernel: [  153.012283] em2710/2820 #0: Empia 202 AC97 audio processor detected
Apr 29 23:13:14 limus kernel: [  156.076288] em2710/2820 #0: V4L2 video device registered as video0
Apr 29 23:13:14 limus kernel: [  156.076291] em2710/2820 #0: V4L2 extension successfully initialized
Apr 29 23:21:07 limus kernel: [  628.747954] perf: interrupt took too long (2533 > 2500), lowering kernel.perf_event_max_sample_rate to 78750
Apr 29 23:24:25 limus kernel: [  826.617031] perf: interrupt took too long (3167 > 3166), lowering kernel.perf_event_max_sample_rate to 63000
Apr 29 23:35:58 limus kernel: [ 1519.576080] perf: interrupt took too long (3961 > 3958), lowering kernel.perf_event_max_sample_rate to 50250
Apr 29 23:36:20 limus kernel: [ 1541.832993] usb 5-4: USB disconnect, device number 4
Apr 29 23:36:20 limus kernel: [ 1541.834062] usb 5-4: cannot submit urb (err = -19)
Apr 29 23:36:20 limus kernel: [ 1541.848040] usb 5-4: cannot submit urb 0, error -19: no device

[Note: Removed 566 lines that had an identical message]

Apr 29 23:36:20 limus kernel: [ 1541.872547] usb 5-4: cannot submit urb 0, error -19: no device
Apr 29 23:36:20 limus kernel: [ 1541.872564] em2710/2820 #0: Disconnecting em2710/2820 #0
Apr 29 23:36:20 limus kernel: [ 1541.872566] em2710/2820 #0: Closing video extension
Apr 29 23:36:20 limus kernel: [ 1541.872583] em2710/2820 #0: V4L2 device video0 deregistered
Apr 29 23:36:35 limus kernel: [ 1556.925936] em2710/2820 #0: Freeing device
Apr 29 23:36:35 limus kernel: [ 1556.925969] BUG: unable to handle kernel NULL pointer dereference at 0000000000000139
Apr 29 23:36:35 limus kernel: [ 1556.926019] IP: [<ffffffff98a0e8be>] mutex_lock+0xe/0x30
Apr 29 23:36:35 limus kernel: [ 1556.926048] PGD 0
Apr 29 23:36:35 limus kernel: [ 1556.926059]
Apr 29 23:36:35 limus kernel: [ 1556.926069] Oops: 0002 [#1] SMP
Apr 29 23:36:35 limus kernel: [ 1556.926084] Modules linked in: snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device saa7115 em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core em28xx tveeprom v4l2_common videodev media coretemp kvm_intel iTCO_wdt kvm iTCO_vendor_support snd_hda_codec_analog snd_hda_codec_generic evdev snd_hda_intel snd_hda_codec dcdbas irqbypass serio_raw pcspkr snd_hda_core snd_hwdep snd_pcm snd_timer snd i915 video drm_kms_helper shpchp drm sg i2c_algo_bit lpc_ich mfd_core mei_me mei soundcore button parport_pc ppdev lp parport ip_tables x_tables autofs4 ext4 crc16 jbd2 crc32c_generic fscrypto ecb glue_helper lrw gf128mul ablk_helper cryptd aes_x86_64 mbcache sr_mod cdrom sd_mod hid_generic usbhid hid psmouse ahci i2c_i801 i2c_smbus libahci ehci_pci ata_generic uhci_hcd ehci_hcd libata
Apr 29 23:36:35 limus kernel: [ 1556.926534]  usbcore scsi_mod usb_common e1000e ptp pps_core
Apr 29 23:36:35 limus kernel: [ 1556.926567] CPU: 1 PID: 1858 Comm: tvtime Not tainted 4.9.0-6-amd64 #1 Debian 4.9.82-1+deb9u3
Apr 29 23:36:35 limus kernel: [ 1556.926598] Hardware name: Dell Inc. OptiPlex 755                 /0HX555, BIOS A11 08/04/2008
Apr 29 23:36:35 limus kernel: [ 1556.926629] task: ffff8d9936781080 task.stack: ffffb544014e8000
Apr 29 23:36:35 limus kernel: [ 1556.926651] RIP: 0010:[<ffffffff98a0e8be>]  [<ffffffff98a0e8be>] mutex_lock+0xe/0x30
Apr 29 23:36:35 limus kernel: [ 1556.926684] RSP: 0018:ffffb544014ebde0  EFLAGS: 00010246
Apr 29 23:36:35 limus kernel: [ 1556.926705] RAX: 0000000000000000 RBX: 0000000000000139 RCX: ffffefb701df595f
Apr 29 23:36:35 limus kernel: [ 1556.926731] RDX: 0000000080000000 RSI: ffff8d9976e1f980 RDI: 0000000000000139
Apr 29 23:36:35 limus kernel: [ 1556.926758] RBP: ffff8d9976e1fb40 R08: 0000000000000000 R09: 0000000000002064
Apr 29 23:36:35 limus kernel: [ 1556.926784] R10: ffffffff99118c80 R11: 0000000000000001 R12: ffff8d9977616108
Apr 29 23:36:35 limus kernel: [ 1556.926811] R13: ffff8d99776162d0 R14: ffff8d9961be5c00 R15: ffff8d997739e6c8
Apr 29 23:36:35 limus kernel: [ 1556.926838] FS:  00007fd539f22780(0000) GS:ffff8d997d240000(0000) knlGS:0000000000000000
Apr 29 23:36:35 limus kernel: [ 1556.926878] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 29 23:36:35 limus kernel: [ 1556.926900] CR2: 0000000000000139 CR3: 0000000076950000 CR4: 0000000000000670
Apr 29 23:36:35 limus kernel: [ 1556.926927] Stack:
Apr 29 23:36:35 limus kernel: [ 1556.926941]  0000000000000139 ffffffffc098c041 ffff8d9976e1fb40 ffff8d9977616010
Apr 29 23:36:35 limus kernel: [ 1556.926980]  ffffffffc098c06e ffff8d99776162c0 ffffffffc0aaa8b8 ffff8d99776162d0
Apr 29 23:36:35 limus kernel: [ 1556.927017]  ffff8d99776162c0 ffff8d99761889c0 ffffffff98877b70 ffff8d9977616308
Apr 29 23:36:35 limus kernel: [ 1556.927053] Call Trace:
Apr 29 23:36:35 limus kernel: [ 1556.927072]  [<ffffffffc098c041>] ? media_remove_intf_links+0x21/0x40 [media]
Apr 29 23:36:35 limus kernel: [ 1556.927100]  [<ffffffffc098c06e>] ? media_devnode_remove+0xe/0x1f [media]
Apr 29 23:36:35 limus kernel: [ 1556.927138]  [<ffffffffc0aaa8b8>] ? v4l2_device_release+0x98/0x110 [videodev]
Apr 29 23:36:35 limus kernel: [ 1556.927166]  [<ffffffff98877b70>] ? device_release+0x30/0x90
Apr 29 23:36:35 limus kernel: [ 1556.927192]  [<ffffffff98730648>] ? kobject_release+0x68/0x190
Apr 29 23:36:35 limus kernel: [ 1556.927219]  [<ffffffffc0aa941c>] ? v4l2_release+0x4c/0x80 [videodev]
Apr 29 23:36:35 limus kernel: [ 1556.927246]  [<ffffffff98607968>] ? __fput+0xd8/0x220
Apr 29 23:36:35 limus kernel: [ 1556.927267]  [<ffffffff984955cf>] ? task_work_run+0x7f/0xa0
Apr 29 23:36:35 limus kernel: [ 1556.927289]  [<ffffffff984032c4>] ? exit_to_usermode_loop+0xa4/0xb0
Apr 29 23:36:35 limus kernel: [ 1556.927314]  [<ffffffff98403bcf>] ? do_syscall_64+0xdf/0xf0
Apr 29 23:36:35 limus kernel: [ 1556.927337]  [<ffffffff98a113b8>] ? entry_SYSCALL_64_after_swapgs+0x42/0xb0
Apr 29 23:36:35 limus kernel: [ 1556.927362] Code: 83 f8 01 0f 85 61 ff ff ff eb d5 e8 bd 8b a6 ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 48 89 fb e8 72 e4 ff ff <f0> ff 0b 79 08 48 89 df e8 b5 fe ff ff 65 48 8b 04 25 80 fb 00
Apr 29 23:36:35 limus kernel: [ 1556.927590] RIP  [<ffffffff98a0e8be>] mutex_lock+0xe/0x30
Apr 29 23:36:35 limus kernel: [ 1556.927616]  RSP <ffffb544014ebde0>
Apr 29 23:36:35 limus kernel: [ 1556.927630] CR2: 0000000000000139
Apr 29 23:36:35 limus kernel: [ 1556.931207] ---[ end trace 035f1f95c7f9f0db ]---

Thanks,
Alexandre-Xavier
