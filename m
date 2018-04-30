Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:41171 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbeD3Eji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 00:39:38 -0400
Received: by mail-qt0-f176.google.com with SMTP id g13-v6so9541255qth.8
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2018 21:39:38 -0700 (PDT)
Cc: alexandrexavier@live.ca
From: =?UTF-8?Q?Alexandre-Xavier_Labont=c3=a9-Lamoureux?=
        <axdoomer@gmail.com>
Subject: "BUG: unable to handle kernel paging request" with em28xx driver
To: linux-media@vger.kernel.org
Message-ID: <ecd3fcf8-9fe8-9121-1304-02d1b8aa3247@gmail.com>
Date: Mon, 30 Apr 2018 00:39:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I believe this happened right after I disconnected the device. It froze the computer with the call trace on the screen. All the relevant information from /var/log/kern.log can be found below:

Apr 29 23:02:32 limus kernel: [    0.000000] Linux version 4.17.0-rc1+ (ax@limus) (gcc version 6.3.0 20170516 (Debian 6.3.0-18+deb9u1)) #1 SMP Sun Apr 29 20:32:29 EDT 2018

Apr 29 23:03:18 limus kernel: [   67.898922] usb 2-4: new high-speed USB device number 3 using ehci-pci
Apr 29 23:03:18 limus kernel: [   68.062086] usb 2-4: New USB device found, idVendor=093b, idProduct=a003, bcdDevice= 1.00
Apr 29 23:03:18 limus kernel: [   68.062089] usb 2-4: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Apr 29 23:03:18 limus kernel: [   68.062091] usb 2-4: Product: ConvertX AV100U A/V Capture
Apr 29 23:03:18 limus kernel: [   68.062093] usb 2-4: Manufacturer: Plextor
Apr 29 23:03:18 limus kernel: [   68.231844] media: Linux media interface: v0.10
Apr 29 23:03:18 limus kernel: [   68.297786] Linux video capture interface: v2.00
Apr 29 23:03:18 limus kernel: [   68.358447] em28xx 2-4:1.0: New device Plextor ConvertX AV100U A/V Capture @ 480 Mbps (093b:a003, interface 0, class 0)
Apr 29 23:03:18 limus kernel: [   68.358454] em28xx 2-4:1.0: Video interface 0 found: bulk isoc
Apr 29 23:03:18 limus kernel: [   68.415713] em28xx 2-4:1.0: chip ID is em2710/2820
Apr 29 23:03:18 limus kernel: [   68.544962] em28xx 2-4:1.0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x439a4c10
Apr 29 23:03:18 limus kernel: [   68.544964] em28xx 2-4:1.0: EEPROM info:
Apr 29 23:03:18 limus kernel: [   68.544966] em28xx 2-4:1.0: 	AC97 audio (5 sample rates)
Apr 29 23:03:18 limus kernel: [   68.544967] em28xx 2-4:1.0: 	500mA max power
Apr 29 23:03:18 limus kernel: [   68.544970] em28xx 2-4:1.0: 	Table at offset 0x06, strings=0x3a7c, 0x126a, 0x0000
Apr 29 23:03:18 limus kernel: [   68.635963] em28xx 2-4:1.0: Identified as Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U (card=9)
Apr 29 23:03:18 limus kernel: [   68.635966] em28xx 2-4:1.0: analog set to isoc mode.
Apr 29 23:03:18 limus kernel: [   68.636083] em28xx 2-4:1.1: audio device (093b:a003): interface 1, class 1
Apr 29 23:03:18 limus kernel: [   68.636094] em28xx 2-4:1.2: audio device (093b:a003): interface 2, class 1
Apr 29 23:03:18 limus kernel: [   68.636109] usbcore: registered new interface driver em28xx
Apr 29 23:03:18 limus kernel: [   68.719150] em28xx 2-4:1.0: Registering V4L2 extension
Apr 29 23:03:19 limus kernel: [   68.880305] usbcore: registered new interface driver snd-usb-audio
Apr 29 23:03:19 limus kernel: [   69.265341] saa7115 8-0025: saa7113 found @ 0x4a (2-4:1.0)
Apr 29 23:03:20 limus kernel: [   70.290216] em28xx 2-4:1.0: Config register raw data: 0x10
Apr 29 23:03:20 limus kernel: [   70.322088] em28xx 2-4:1.0: AC97 vendor ID = 0xffffffff
Apr 29 23:03:20 limus kernel: [   70.338088] em28xx 2-4:1.0: AC97 features = 0x6a90
Apr 29 23:03:20 limus kernel: [   70.338090] em28xx 2-4:1.0: Empia 202 AC97 audio processor detected
Apr 29 23:03:23 limus kernel: [   73.324810] em28xx 2-4:1.0: V4L2 video device registered as video0
Apr 29 23:03:23 limus kernel: [   73.324814] em28xx 2-4:1.0: V4L2 extension successfully initialized
Apr 29 23:03:23 limus kernel: [   73.324816] em28xx: Registered (Em28xx v4l2 Extension) extension
Apr 29 23:03:39 limus kernel: [   89.068469] ehci-pci 0000:00:1d.7: fatal error
Apr 29 23:03:39 limus kernel: [   89.068480] ehci-pci 0000:00:1d.7: HC died; cleaning up
Apr 29 23:03:39 limus kernel: [   89.068514] usb 2-4: USB disconnect, device number 3
Apr 29 23:03:39 limus kernel: [   89.068613] em28xx 2-4:1.0: Disconnecting em28xx
Apr 29 23:03:39 limus kernel: [   89.068618] em28xx 2-4:1.0: Closing video extension
Apr 29 23:03:39 limus kernel: [   89.068634] em28xx 2-4:1.0: V4L2 device video0 deregistered
Apr 29 23:03:39 limus kernel: [   89.071501] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000074da52cd/456c500077ec4600 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071505] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000e58e02dd/456c900077ec8540 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071508] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000b5b2770b/77ed0480 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071511] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000bfc30709/456d400077ed33c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071513] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000089e992f3/456da00077ed9300 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071516] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000000fc56dbe/77ee1240 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071518] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000001b4d1eec/456e500077ee4180 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071521] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000002fa40aea/456ec00077eeb0c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071524] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000005ca5bfac/4568500077ec4c00 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071526] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000c2f7ebba/4568900077ec8b40 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071529] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000005f985132/77ed0a80 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071531] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000598a0c1c/4569400077ed39c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071534] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000a1f37ed0/4569a00077ed9900 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071537] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000009ead2c5e/77ee1840 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071539] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000000fedcee7/456a500077ee4780 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071542] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000031ad64b6/456ac00077eeb6c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071544] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000086b4e3a1/76d450007fdc56c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071547] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000004c43cf78/76d490007fdc9f00 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071550] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000d5d8d822/7fdd1e40 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071552] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000032e54bf2/76d540007fdd3d80 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071555] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000007bfb731/76d5a00076dd9f00 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071557] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000017b6eb28/76de1e40 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071560] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000048001ed/76d6500076de4d80 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071562] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000000b32352c/76d6c00076debcc0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071565] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000fa3293b0/26c050007fcc5cc0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071567] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000cea33755/26c090007fcc9c00 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071570] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000001667843e/7fcd1b40 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071573] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000006d8cef50/26c140007fcd3a80 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071575] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000236dac41/26c1a0007fcd99c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071578] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000007009cfde/7fce1900 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071580] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000c051ba1d/26c250007fce5840 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071583] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000009bdb8090/26c2c0007fceb780 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071585] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000007b1f83e6/76e450007fec5540 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071588] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 000000001d1fe626/76e490007fec9480 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071591] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000fc2d252c/7fed13c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071593] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000065ca79c1/76e540007fed3300 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071596] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000090c38945/76e5a0007fed9000 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071598] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 0000000024f1b99d/7fee1180 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071601] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000dc1762fc/76e650007fee5240 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.071603] ehci-pci 0000:00:1d.7: dma_pool_free ehci_itd, 00000000bd8513f7/76e6c0007feeb0c0 (bad dma)
Apr 29 23:03:39 limus kernel: [   89.337577] usb 6-2: new full-speed USB device number 2 using uhci_hcd
Apr 29 23:03:39 limus kernel: [   89.501556] usb 6-2: not running at top speed; connect to a high speed hub
Apr 29 23:03:39 limus kernel: [   89.537558] usb 6-2: New USB device found, idVendor=093b, idProduct=a003, bcdDevice= 1.00
Apr 29 23:03:39 limus kernel: [   89.537561] usb 6-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Apr 29 23:03:39 limus kernel: [   89.537564] usb 6-2: Product: ConvertX AV100U A/V Capture
Apr 29 23:03:39 limus kernel: [   89.537586] usb 6-2: Manufacturer: Plextor
Apr 29 23:03:39 limus kernel: [   89.541639] em28xx 6-2:1.0: New device Plextor ConvertX AV100U A/V Capture @ 12 Mbps (093b:a003, interface 0, class 0)
Apr 29 23:03:39 limus kernel: [   89.541645] em28xx 6-2:1.0: Device initialization failed.
Apr 29 23:03:39 limus kernel: [   89.541648] em28xx 6-2:1.0: Device must be connected to a high-speed USB 2.0 port.
Apr 29 23:03:39 limus kernel: [   89.541747] em28xx 6-2:1.1: audio device (093b:a003): interface 1, class 1
Apr 29 23:03:56 limus kernel: [  106.253096] BUG: unable to handle kernel paging request at ffffffffffffff68
Apr 29 23:03:56 limus kernel: [  106.253104] PGD 6920e067 P4D 6920e067 PUD 69210067 PMD 0
Apr 29 23:03:56 limus kernel: [  106.253109] Oops: 0000 [#1] SMP PTI
Apr 29 23:03:56 limus kernel: [  106.253112] Modules linked in: snd_usb_audio snd_usbmidi_lib snd_rawmidi saa7115 snd_seq_device em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common em28xx tveeprom v4l2_common videodev media i915 video snd_hda_codec_analog snd_hda_codec_generic drm_kms_helper coretemp kvm_intel kvm drm snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm iTCO_wdt snd_timer iTCO_vendor_support snd evdev dcdbas soundcore lpc_ich irqbypass mei_me pcspkr serio_raw sg mfd_core shpchp mei i2c_algo_bit button parport_pc ppdev lp parport ip_tables x_tables autofs4 crc32c_generic ext4 crc16 mbcache jbd2 fscrypto sr_mod cdrom sd_mod hid_generic usbhid hid psmouse ahci ata_generic libahci i2c_i801 libata uhci_hcd ehci_pci ehci_hcd e1000e scsi_mod usbcore
Apr 29 23:03:56 limus kernel: [  106.253163] CPU: 0 PID: 815 Comm: tvtime Not tainted 4.17.0-rc1+ #1
Apr 29 23:03:56 limus kernel: [  106.253165] Hardware name: Dell Inc. OptiPlex 755                 /0HX555, BIOS A11 08/04/2008
Apr 29 23:03:56 limus kernel: [  106.253172] RIP: 0010:em28xx_read_reg_req_len+0x1e/0x2a0 [em28xx]
Apr 29 23:03:56 limus kernel: [  106.253174] RSP: 0018:ffffaa3f811bfce0 EFLAGS: 00010282
Apr 29 23:03:56 limus kernel: [  106.253176] RAX: 0000000000000000 RBX: 000000000000000c RCX: ffffaa3f811bfd37
Apr 29 23:03:56 limus kernel: [  106.253178] RDX: 000000000000000c RSI: 0000000000000000 RDI: ffff9167b6c38000
Apr 29 23:03:56 limus kernel: [  106.253180] RBP: 0000000000000010 R08: 0000000000000001 R09: 0000000000000000
Apr 29 23:03:56 limus kernel: [  106.253181] R10: ffff9167a6bcf310 R11: 0000000000000000 R12: 0000000000000000
Apr 29 23:03:56 limus kernel: [  106.253183] R13: ffff9167b6c38000 R14: ffff9167b8af7840 R15: ffff916767f27130
Apr 29 23:03:56 limus kernel: [  106.253186] FS:  00007f5e8334a780(0000) GS:ffff9167bd200000(0000) knlGS:0000000000000000
Apr 29 23:03:56 limus kernel: [  106.253188] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 29 23:03:56 limus kernel: [  106.253189] CR2: ffffffffffffff68 CR3: 000000006dc08000 CR4: 00000000000006f0
Apr 29 23:03:56 limus kernel: [  106.253191] Call Trace:
Apr 29 23:03:56 limus kernel: [  106.253199]  ? release_pages+0x313/0x3c0
Apr 29 23:03:56 limus kernel: [  106.253202]  em28xx_write_reg_bits+0x3e/0x90 [em28xx]
Apr 29 23:03:56 limus kernel: [  106.253206]  em28xx_capture_start+0x280/0x300 [em28xx]
Apr 29 23:03:56 limus kernel: [  106.253211]  em28xx_stop_streaming+0x197/0x1a0 [em28xx_v4l]
Apr 29 23:03:56 limus kernel: [  106.253215]  ? arch_tlb_finish_mmu+0x55/0x70
Apr 29 23:03:56 limus kernel: [  106.253220]  __vb2_queue_cancel+0x2d/0x1d0 [videobuf2_common]
Apr 29 23:03:56 limus kernel: [  106.253224]  vb2_core_queue_release+0x1e/0x40 [videobuf2_common]
Apr 29 23:03:56 limus kernel: [  106.253229]  _vb2_fop_release+0x7d/0x90 [videobuf2_v4l2]
Apr 29 23:03:56 limus kernel: [  106.253233]  em28xx_v4l2_close+0x4a/0x1b0 [em28xx_v4l]
Apr 29 23:03:56 limus kernel: [  106.253247]  v4l2_release+0x35/0x80 [videodev]
Apr 29 23:03:56 limus kernel: [  106.253251]  __fput+0xd8/0x210
Apr 29 23:03:56 limus kernel: [  106.253255]  task_work_run+0x8a/0xb0
Apr 29 23:03:56 limus kernel: [  106.253259]  exit_to_usermode_loop+0xbd/0xc0
Apr 29 23:03:56 limus kernel: [  106.253262]  do_syscall_64+0xd2/0x100
Apr 29 23:03:56 limus kernel: [  106.253265]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Apr 29 23:03:56 limus kernel: [  106.253268] RIP: 0033:0x7f5e80df126d
Apr 29 23:03:56 limus kernel: [  106.253270] RSP: 002b:00007ffe201f5110 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
Apr 29 23:03:56 limus kernel: [  106.253272] RAX: 0000000000000000 RBX: 00005587495becb8 RCX: 00007f5e80df126d
Apr 29 23:03:56 limus kernel: [  106.253274] RDX: 00007f5e80540750 RSI: 00000000000a8c00 RDI: 0000000000000003
Apr 29 23:03:56 limus kernel: [  106.253276] RBP: 0000000000000004 R08: 00007f5e8334a780 R09: 000000000000002f
Apr 29 23:03:56 limus kernel: [  106.253277] R10: 0000000000000559 R11: 0000000000000293 R12: 00005587495bd9b0
Apr 29 23:03:56 limus kernel: [  106.253279] R13: 00000000c058560f R14: 000055874762bf40 R15: 0000558749582d20
Apr 29 23:03:56 limus kernel: [  106.253281] Code: ea 70 c0 5b 5d e9 c1 c3 dd c1 0f 1f 00 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 48 83 ec 18 48 8b 87 98 11 00 00 48 8b 40 30 <44> 8b a0 68 ff ff ff 48 8d 98 68 ff ff ff 48 89 1c 24 41 c1 e4
Apr 29 23:03:56 limus kernel: [  106.253315] RIP: em28xx_read_reg_req_len+0x1e/0x2a0 [em28xx] RSP: ffffaa3f811bfce0
Apr 29 23:03:56 limus kernel: [  106.253316] CR2: ffffffffffffff68
Apr 29 23:03:56 limus kernel: [  106.253319] ---[ end trace de75cbbf8bf88dd9 ]---

Thanks,
Alexandre-Xavier
