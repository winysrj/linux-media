Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60011 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbcECVjP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 17:39:15 -0400
Date: Tue, 3 May 2016 23:38:59 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160503233859.0f6506fa@mir>
In-Reply-To: <20160315080552.3cc5d146@recife.lan>
References: <20160315080552.3cc5d146@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 2016-03-15, Mauro Carvalho Chehab wrote:
[...]
> The following changes since commit b562e44f507e863c6792946e4e1b1449fbbac85d:
> 
>   Linux 4.5 (2016-03-13 21:28:54 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-1
> 
> for you to fetch changes up to 8331c055b23c4155b896a2c3791704ae68992d2b:
> 
>   Merge commit '840f5b0572ea' into v4l_for_linus (2016-03-15 07:48:28 -0300)
> 
> ----------------------------------------------------------------
> media updates for v4.6-rc1
[...]
> Mauro Carvalho Chehab (95):
[...]
>       [media] use v4l2_mc_usb_media_device_init() on most USB devices
[...]

This change, as part of v4.6-rc6-85-g1248ded, breaks two systems, each 
equipped with a TeVii s480 (dvb_usb_dw2102) DVB-S2 card, for me (kernel
v4.5.3-rc1 is fine):

sandy-bridge:
- TeVii s480 (dvb_usb_dw2102)
- Trekstor Terres 2.0 (dvb_usb_rtl28xxu)
- x10/ 433 MHz radio remote (ati_remote)

[    2.058727] usb 5-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
[    2.059839] usb 5-1: New USB device found, idVendor=9022, idProduct=d660
[    2.059843] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.059845] usb 5-1: Product: DVBS2BOX
[    2.059847] usb 5-1: Manufacturer: TBS-Tech
[    2.062754] usb 6-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
[    2.064002] usb 6-1: New USB device found, idVendor=9022, idProduct=d660
[    2.064004] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.064006] usb 6-1: Product: DVBS2BOX
[    2.064008] usb 6-1: Manufacturer: TBS-Tech
[...]
[    2.315642] usb 3-1.1: new low-speed USB device number 3 using ehci-pci
[    2.396709] usb 3-1.1: New USB device found, idVendor=0bc7, idProduct=0006
[    2.396714] usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.396717] usb 3-1.1: Product: USB Receiver
[    2.396719] usb 3-1.1: Manufacturer: X10 Wireless Technology Inc
[...]
[    2.473623] usb 3-1.4: new high-speed USB device number 4 using ehci-pci
[    2.563465] usb 3-1.4: New USB device found, idVendor=1f4d, idProduct=c803
[    2.563470] usb 3-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.563472] usb 3-1.4: Product: RTL2838UHIDIR
[    2.563474] usb 3-1.4: Manufacturer: Realtek
[    2.563476] usb 3-1.4: SerialNumber: 00000001
[...]
[    4.984409] media: Linux media interface: v0.10
[    4.987674] dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware
[    4.988892] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    4.988894] dw2102: start downloading DW210X firmware
[    5.010246] usb 3-1.4: dvb_usb_v2: found a 'Trekstor DVB-T Stick Terres 2.0' in warm state
[    5.025627] iTCO_vendor_support: vendor-support=0
[    5.026049] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    5.026076] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    5.026181] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.027427] gpio_ich: GPIO from 436 to 511 on gpio_ich
[    5.041801] usb 3-1.4: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[    5.041811] DVB: registering new adapter (Trekstor DVB-T Stick Terres 2.0)
[    5.041814] usb 3-1.4: media controller created
[    5.041915] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    5.041921] IP: [<ffffffffa0017b18>] media_gobj_create+0xb8/0x100 [media]
[    5.041928] PGD 0 
[    5.041930] Oops: 0002 [#1] PREEMPT SMP 
[    5.041934] Modules linked in: vfat irqbypass fat crct10dif_pclmul crc32_pclmul ghash_clmulni_intel gpio_ich iTCO_wdt iTCO_vendor_support evdev dvb_usb_rtl28xxu(+) dvb_usb_v2 sha256_ssse3 dvb_usb_dw2102(+) dvb_usb sha256_generic dvb_core media drbg ansi_cprng i915 aesni_intel aes_x86_64 ath9k(+) lrw snd_hda_codec_realtek(+) gf128mul ath9k_common glue_helper ath9k_hw snd_hda_codec_generic ablk_helper cryptd video ath i2c_algo_bit pcspkr serio_raw snd_hda_intel drm_kms_helper mac80211 snd_hda_codec sg drm i2c_i801 lpc_ich cfg80211 snd_hda_core snd_hwdep rfkill i2c_core snd_pcm intel_gtt snd_timer syscopyarea sysfillrect snd mei_me sysimgblt soundcore fb_sys_fops mei 8250_fintek floppy(+) nuvoton_cir rc_core processor button w83627ehf hwmon_vid parport_pc ppdev lp parport autofs4 ext4 crc16 jbd2 mbcache
[    5.041996]  dm_mod hid_generic usbhid hid sr_mod cdrom sd_mod ohci_pci crc32c_intel ahci libahci psmouse libata scsi_mod xhci_pci xhci_hcd r8169 ohci_hcd ehci_pci ehci_hcd e100 mii e1000e usbcore usb_common ptp pps_core fjes
[    5.042018] CPU: 4 PID: 309 Comm: systemd-udevd Not tainted 4.6.0-rc6-aptosid-amd64 #1 aptosid 4.6~rc6-1~git72.slh.1
[    5.042022] Hardware name:                  /DH67CL, BIOS BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[    5.042027] task: ffff88000c2d0d80 ti: ffff880409b20000 task.ti: ffff880409b20000
[    5.042032] RIP: 0010:[<ffffffffa0017b18>]  [<ffffffffa0017b18>] media_gobj_create+0xb8/0x100 [media]
[    5.042043] RSP: 0018:ffff880409b238d8  EFLAGS: 00010297
[    5.042048] RAX: 0000000000000000 RBX: ffff88040ba90000 RCX: ffff88040ba90010
[    5.042053] RDX: ffff88040ba90000 RSI: ffff88040a54c420 RDI: ffff88040a54c000
[    5.042059] RBP: ffff88040a54c000 R08: 0000000000017d80 R09: ffffffff8128fa3f
[    5.042064] R10: ffffea00102ea600 R11: 000000000000003d R12: ffff88040a54c470
[    5.042069] R13: 0000000000000000 R14: ffffffffa00bca00 R15: ffff88040ba90000
[    5.042074] FS:  00007f77a1af68c0(0000) GS:ffff88041f300000(0000) knlGS:0000000000000000
[    5.042081] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.042086] CR2: 0000000000000000 CR3: 00000004098cc000 CR4: 00000000000406e0
[    5.042090] Stack:
[    5.042094]  ffffffffa0015239 0000000000000001 ffff8800024002c2 00000000f11d1c21
[    5.042102]  ffff880036b56c9f ffff880409b239d8 000000000000000f ffffffffa00bc9e1
[    5.042109]  ffff880036b56c9d ffffffffa00bc9df ffffffff8129975e ffff880036b56c90
[    5.042116] Call Trace:
[    5.042122]  [<ffffffffa0015239>] ? media_device_register_entity+0xc9/0x230 [media]
[    5.042132]  [<ffffffff8129975e>] ? vsnprintf+0x3ae/0x5a0
[    5.042137]  [<ffffffff8129c92b>] ? kvasprintf+0x7b/0xd0
[    5.042143]  [<ffffffff8129c9ce>] ? kasprintf+0x4e/0x70
[    5.042149]  [<ffffffffa00ac687>] ? dvb_create_tsout_entity+0x127/0x150 [dvb_core]
[    5.042158]  [<ffffffffa00acb44>] ? dvb_register_device+0x414/0x610 [dvb_core]
[    5.042165]  [<ffffffffa00ade9c>] ? dvb_dmxdev_init+0xec/0x140 [dvb_core]
[    5.042171]  [<ffffffffa0125029>] ? dvb_usbv2_probe+0x499/0xcb0 [dvb_usb_v2]
[    5.042182]  [<ffffffffa003fbc4>] ? usb_probe_interface+0x194/0x290 [usbcore]
[    5.042189]  [<ffffffff813ab5dd>] ? driver_probe_device+0x1ed/0x2b0
[    5.042195]  [<ffffffff813ab72f>] ? __driver_attach+0x8f/0xa0
[    5.042200]  [<ffffffff813ab6a0>] ? driver_probe_device+0x2b0/0x2b0
[    5.042206]  [<ffffffff813a9622>] ? bus_for_each_dev+0x62/0xb0
[    5.042212]  [<ffffffff813aa9da>] ? bus_add_driver+0x19a/0x210
[    5.042217]  [<ffffffff813abdc2>] ? driver_register+0x52/0xc0
[    5.042225]  [<ffffffffa003e7d8>] ? usb_register_driver+0x78/0x120 [usbcore]
[    5.042231]  [<ffffffffa0140000>] ? 0xffffffffa0140000
[    5.042237]  [<ffffffff810020f0>] ? do_one_initcall+0x90/0x1e0
[    5.042243]  [<ffffffff8111a0d4>] ? do_init_module+0x51/0x1bd
[    5.042250]  [<ffffffff810d8270>] ? load_module+0x1d40/0x2300
[    5.042255]  [<ffffffff810d59a0>] ? __symbol_put+0x80/0x80
[    5.042262]  [<ffffffff812241ec>] ? security_capable+0x3c/0x50
[    5.042267]  [<ffffffff810d8a32>] ? SYSC_finit_module+0xc2/0xd0
[    5.042274]  [<ffffffff8152d732>] ? entry_SYSCALL_64_fastpath+0x1a/0xa4
[    5.042278] Code: 89 08 83 87 e0 03 00 00 01 c3 48 8b 87 28 04 00 00 48 8d 4a 10 48 8d b7 20 04 00 00 48 89 8f 28 04 00 00 48 89 72 10 48 89 42 18 <48> 89 08 83 87 e0 03 00 00 01 c3 48 8b 87 48 04 00 00 48 8d 4a 
[    5.042311] RIP  [<ffffffffa0017b18>] media_gobj_create+0xb8/0x100 [media]
[    5.042318]  RSP <ffff880409b238d8>
[    5.042322] CR2: 0000000000000000
[    5.042327] ---[ end trace c1eead83d05cfb48 ]---


ivy-bridge:
- TeVii s480 (dvb_usb_dw2102)
- Terratec Cinergy T USB XE (dvb_usb_af9015), module blacklisted
- mceusb IR remote

[    1.451505] usb 5-1: New USB device found, idVendor=9022, idProduct=d481
[    1.451509] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.457660] usb 6-1: New USB device found, idVendor=9022, idProduct=d482
[    1.457664] usb 6-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[...]
[    2.177819] usb 4-1.6: New USB device found, idVendor=0609, idProduct=0334
[    2.177822] usb 4-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.177824] usb 4-1.6: Product: MCE TRANCEIVR Emulator Device 2006
[    2.177826] usb 4-1.6: Manufacturer: SMK CORPORATION
[    2.177827] usb 4-1.6: SerialNumber: PA070620045513C
[...]
[    2.355897] media: Linux media interface: v0.10
[    2.363527] dvb-usb: found a 'TeVii S480.1 USB' in cold state, will try to load a firmware
[    2.364065] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    2.364067] dw2102: start downloading DW210X firmware
[    2.375828] Registered IR keymap rc-rc6-mce
[    2.375896] input: Media Center Ed. eHome Infrared Remote Transceiver (0609:0334) as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.6/4-1.6:1.0/rc/rc0/input17
[...]
[    2.376015] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (0609:0334) as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.6/4-1.6:1.0/rc/rc0
[    2.377579] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    2.377580] IR LIRC bridge handler initialized
[    2.418003] usb 5-1: USB disconnect, device number 2
[...]
[    2.497370] mceusb 4-1.6:1.0: Registered SMK CORPORATION MCE TRANCEIVR Emulator Device 2006 with mce emulator interface version 1
[    2.497371] mceusb 4-1.6:1.0: 2 tx ports (0x0 cabled) and 2 rx sensors (0x1 active)
[    2.497394] usbcore: registered new interface driver mceusb
[    2.515348] dvb-usb: found a 'TeVii S480.1 USB' in warm state.
[    2.515386] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    2.515397] DVB: registering new adapter (TeVii S480.1 USB)
[    2.515398] usb 5-1: media controller created
[    2.515508] dvb-usb: MAC address: 48:48:48:48:48:48
[    2.515596] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    2.515600] IP: [<ffffffffa066cb18>] media_gobj_create+0xb8/0x100 [media]
[    2.515601] PGD 0 
[    2.515602] Oops: 0002 [#1] PREEMPT SMP 
[    2.515621] Modules linked in: ir_lirc_codec lirc_dev iTCO_wdt eeepc_wmi iTCO_vendor_support asus_wmi sparse_keymap rfkill evdev dvb_usb_dw2102(+) dvb_usb dvb_core media rc_rc6_mce mceusb rc_core intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_hdmi sha256_ssse3 sha256_generic drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd snd_hda_codec_realtek snd_hda_codec_generic pcspkr i915 serio_raw i2c_algo_bit drm_kms_helper snd_hda_intel i2c_i801 drm snd_hda_codec snd_hda_core snd_hwdep i2c_core snd_pcm intel_gtt ie31200_edac syscopyarea snd_timer sysfillrect sysimgblt snd mei_me sg fb_sys_fops soundcore lpc_ich mei edac_core wmi battery 8250_fintek tpm_infineon video button
[    2.515640]  processor nct6775 hwmon_vid parport_pc ppdev lp parport autofs4 ext4 crc16 jbd2 mbcache btrfs xor raid6_pq dm_mod md_mod sd_mod ohci_pci crc32c_intel psmouse ahci libahci libata scsi_mod ohci_hcd ehci_pci xhci_pci xhci_hcd ehci_hcd r8169 mii usbcore usb_common fan thermal fjes
[    2.515642] CPU: 0 PID: 350 Comm: systemd-udevd Not tainted 4.6.0-rc6-aptosid-amd64 #1 aptosid 4.6~rc6-1~git72.slh.1
[    2.515642] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1505 10/17/2014
[    2.515643] task: ffff8800c7903600 ti: ffff8807f7168000 task.ti: ffff8807f7168000
[    2.515645] RIP: 0010:[<ffffffffa066cb18>]  [<ffffffffa066cb18>] media_gobj_create+0xb8/0x100 [media]
[    2.515646] RSP: 0018:ffff8807f716b8a0  EFLAGS: 00010297
[    2.515647] RAX: 0000000000000000 RBX: ffff8807f8b20000 RCX: ffff8807f8b20010
[    2.515647] RDX: ffff8807f8b20000 RSI: ffff8807f71cfc20 RDI: ffff8807f71cf800
[    2.515648] RBP: ffff8807f71cf800 R08: 0000000000017d80 R09: ffffffff8128fa3f
[    2.515648] R10: ffffea001feaf800 R11: ffff8807f77f7b7e R12: ffff8807f71cfc70
[    2.515649] R13: 0000000000000000 R14: ffffffffa0c31a00 R15: ffff8807f8b20000
[    2.515650] FS:  00007fb9565ae8c0(0000) GS:ffff88081fa00000(0000) knlGS:0000000000000000
[    2.515651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.515651] CR2: 0000000000000000 CR3: 00000007f832d000 CR4: 00000000001406f0
[    2.515652] Stack:
[    2.515653]  ffffffffa066a239 0000000000000001 ffff8800024002c2 000000008c9fd0a5
[    2.515654]  ffff8807f77f7b7f ffff8807f716b9a0 000000000000000f ffffffffa0c319e1
[    2.515656]  ffff8807f77f7b7d ffffffffa0c319df ffffffff8129975e ffff8807f77f7b70
[    2.515656] Call Trace:
[    2.515658]  [<ffffffffa066a239>] ? media_device_register_entity+0xc9/0x230 [media]
[    2.515661]  [<ffffffff8129975e>] ? vsnprintf+0x3ae/0x5a0
[    2.515663]  [<ffffffff8129c92b>] ? kvasprintf+0x7b/0xd0
[    2.515665]  [<ffffffff8129c9ce>] ? kasprintf+0x4e/0x70
[    2.515676]  [<ffffffffa0c21687>] ? dvb_create_tsout_entity+0x127/0x150 [dvb_core]
[    2.515678]  [<ffffffffa0c21b44>] ? dvb_register_device+0x414/0x610 [dvb_core]
[    2.515680]  [<ffffffffa0c22e9c>] ? dvb_dmxdev_init+0xec/0x140 [dvb_core]
[    2.515682]  [<ffffffffa0695479>] ? dvb_usb_adapter_dvb_init+0x1a9/0x250 [dvb_usb]
[    2.515683]  [<ffffffffa0694950>] ? dvb_usb_device_init+0x480/0x680 [dvb_usb]
[    2.515687]  [<ffffffffa07f8492>] ? dw2102_probe+0x282/0x3c0 [dvb_usb_dw2102]
[    2.515692]  [<ffffffffa0047bc4>] ? usb_probe_interface+0x194/0x290 [usbcore]
[    2.515694]  [<ffffffff813ab5dd>] ? driver_probe_device+0x1ed/0x2b0
[    2.515696]  [<ffffffff813ab72f>] ? __driver_attach+0x8f/0xa0
[    2.515697]  [<ffffffff813ab6a0>] ? driver_probe_device+0x2b0/0x2b0
[    2.515698]  [<ffffffff813a9622>] ? bus_for_each_dev+0x62/0xb0
[    2.515699]  [<ffffffff813aa9da>] ? bus_add_driver+0x19a/0x210
[    2.515700]  [<ffffffff813abdc2>] ? driver_register+0x52/0xc0
[    2.515703]  [<ffffffffa00467d8>] ? usb_register_driver+0x78/0x120 [usbcore]
[    2.515704]  [<ffffffffa06de000>] ? 0xffffffffa06de000
[    2.515707]  [<ffffffff810020f0>] ? do_one_initcall+0x90/0x1e0
[    2.515709]  [<ffffffff8111a0d4>] ? do_init_module+0x51/0x1bd
[    2.515711]  [<ffffffff810d8270>] ? load_module+0x1d40/0x2300
[    2.515712]  [<ffffffff810d59a0>] ? __symbol_put+0x80/0x80
[    2.515714]  [<ffffffff812241ec>] ? security_capable+0x3c/0x50
[    2.515715]  [<ffffffff810d8a32>] ? SYSC_finit_module+0xc2/0xd0
[    2.515717]  [<ffffffff8152d732>] ? entry_SYSCALL_64_fastpath+0x1a/0xa4
[    2.515731] Code: 89 08 83 87 e0 03 00 00 01 c3 48 8b 87 28 04 00 00 48 8d 4a 10 48 8d b7 20 04 00 00 48 89 8f 28 04 00 00 48 89 72 10 48 89 42 18 <48> 89 08 83 87 e0 03 00 00 01 c3 48 8b 87 48 04 00 00 48 8d 4a 
[    2.515733] RIP  [<ffffffffa066cb18>] media_gobj_create+0xb8/0x100 [media]
[    2.515733]  RSP <ffff8807f716b8a0>
[    2.515734] CR2: 0000000000000000
[    2.515735] ---[ end trace 45b644013643405a ]---

The git bisect log ends up at:

$ git bisect log
git bisect start
# bad: [33656a1f2ee5346c742d63ddd0e0970c95a56b70] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
git bisect bad 33656a1f2ee5346c742d63ddd0e0970c95a56b70
# good: [b562e44f507e863c6792946e4e1b1449fbbac85d] Linux 4.5
git bisect good b562e44f507e863c6792946e4e1b1449fbbac85d
# bad: [6b5f04b6cf8ebab9a65d9c0026c650bb2538fd0f] Merge branch 'for-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
git bisect bad 6b5f04b6cf8ebab9a65d9c0026c650bb2538fd0f
# bad: [96b9b1c95660d4bc5510c5d798d3817ae9f0b391] Merge tag 'tty-4.6-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect bad 96b9b1c95660d4bc5510c5d798d3817ae9f0b391
# good: [277edbabf6fece057b14fb6db5e3a34e00f42f42] Merge tag 'pm+acpi-4.6-rc1-1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good 277edbabf6fece057b14fb6db5e3a34e00f42f42
# bad: [bace3db5da970c4d4f80a1ffa988ec66c7f6a8f5] Merge tag 'media/v4.6-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect bad bace3db5da970c4d4f80a1ffa988ec66c7f6a8f5
# good: [8759957b77ac1b5b5bdfac5ba049789107e85190] Merge tag 'libnvdimm-for-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
git bisect good 8759957b77ac1b5b5bdfac5ba049789107e85190
# good: [eee7d353a19032b48c0f71504081de84a0ee79d8] [media] v4l2-mc: add a routine to create USB media_device
git bisect good eee7d353a19032b48c0f71504081de84a0ee79d8
# bad: [182dde7c5d4cd9fcac007c0798c9906fc5ea6889] [media] media: au0828 change to use Managed Media Controller API
git bisect bad 182dde7c5d4cd9fcac007c0798c9906fc5ea6889
# bad: [f6acfcdc5b8cdc9ddd53a459361820b9efe958c4] [media] v4l: vsp1: Set the SRU CTRL0 register when starting the stream
git bisect bad f6acfcdc5b8cdc9ddd53a459361820b9efe958c4
# bad: [3e71da19f9dc22e39a755d6ae9678661abb66adc] [media] saa7134: Fix bytesperline not being set correctly for planar formats
git bisect bad 3e71da19f9dc22e39a755d6ae9678661abb66adc
# bad: [c43875f66140f5457f90fc5f6f6840c74b2762cd] [media] tvp5150: replace MEDIA_ENT_F_CONN_TEST by a control
git bisect bad c43875f66140f5457f90fc5f6f6840c74b2762cd
# bad: [8b0a81c73326af2defaa0d8a4494c7def83928bd] [media] si2157: register as a tuner entity
git bisect bad 8b0a81c73326af2defaa0d8a4494c7def83928bd
# bad: [67873d4e751e400149df7ab61ba04cbb4cc0d449] [media] use v4l2_mc_usb_media_device_init() on most USB devices
git bisect bad 67873d4e751e400149df7ab61ba04cbb4cc0d449
# good: [bb07bd6b6851120ac9b25bb315d62d9782d2c345] [media] allow overriding the driver name
git bisect good bb07bd6b6851120ac9b25bb315d62d9782d2c345
# first bad commit: [67873d4e751e400149df7ab61ba04cbb4cc0d449] [media] use v4l2_mc_usb_media_device_init() on most USB devices

Regards
	Stefan Lippers-Hollmann
