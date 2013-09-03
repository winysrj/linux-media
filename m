Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICGeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 02:34:31 -0400
Date: Tue, 3 Sep 2013 08:34:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/3] V4L2: fix em28xx ov2640 support
In-Reply-To: <5224DBB8.1010601@googlemail.com>
Message-ID: <Pine.LNX.4.64.1309030821050.14776@axis700.grange>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
 <5224DBB8.1010601@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank

Thanks for testing! Let's have a look then:

On Mon, 2 Sep 2013, Frank Schäfer wrote:

> Am 28.08.2013 15:28, schrieb Guennadi Liakhovetski:
> > This patch series adds a V4L2 clock support to em28xx with an ov2640 
> > sensor. Only compile tested, might need fixing, please, test.
> >
> > Guennadi Liakhovetski (3):
> >   V4L2: add v4l2-clock helpers to register and unregister a fixed-rate
> >     clock
> >   V4L2: add a v4l2-clk helper macro to produce an I2C device ID
> >   V4L2: em28xx: register a V4L2 clock source
> >
> >  drivers/media/usb/em28xx/em28xx-camera.c |   41 ++++++++++++++++++++++-------
> >  drivers/media/usb/em28xx/em28xx-cards.c  |    3 ++
> >  drivers/media/usb/em28xx/em28xx.h        |    1 +
> >  drivers/media/v4l2-core/v4l2-clk.c       |   39 ++++++++++++++++++++++++++++
> >  include/media/v4l2-clk.h                 |   17 ++++++++++++
> >  5 files changed, 91 insertions(+), 10 deletions(-)
> >
> 
> Tested a few minutes ago:
> 
> ...
> [  103.564065] usb 1-8: new high-speed USB device number 10 using ehci-pci
> [  103.678554] usb 1-8: config 1 has an invalid interface number: 3 but
> max is 2
> [  103.678559] usb 1-8: config 1 has no interface number 2
> [  103.678566] usb 1-8: New USB device found, idVendor=1ae7, idProduct=9004
> [  103.678569] usb 1-8: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [  103.797040] em28xx audio device (1ae7:9004): interface 0, class 1
> [  103.797054] em28xx audio device (1ae7:9004): interface 1, class 1
> [  103.797064] em28xx: New device   @ 480 Mbps (1ae7:9004, interface 3,
> class 3)
> [  103.797066] em28xx: Video interface 3 found: bulk
> [  103.933941] em28xx: chip ID is em2765
> [  104.043811] em2765 #0: i2c eeprom 0000: 26 00 01 00 02 0d ea c2 ee 30
> fa 02 d2 0a 32 02
> [  104.043821] em2765 #0: i2c eeprom 0010: 0d c3 c2 04 12 00 33 c2 04 12
> 00 4b 12 0e 1f d2
> [  104.043828] em2765 #0: i2c eeprom 0020: 04 12 00 33 12 0e 1f d2 04 12
> 00 4b 02 0e 1f 80
> [  104.043835] em2765 #0: i2c eeprom 0030: 00 a2 85 22 02 0b cb a2 04 92
> 84 22 02 0c 78 00
> [  104.043841] em2765 #0: i2c eeprom 0040: 02 0d 69 7b 1f 7d 40 7f 32 02
> 0c 44 02 00 03 a2
> [  104.043847] em2765 #0: i2c eeprom 0050: 04 92 85 22 00 00 00 00 e7 1a
> 04 90 00 00 00 00
> [  104.043854] em2765 #0: i2c eeprom 0060: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043860] em2765 #0: i2c eeprom 0070: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043866] em2765 #0: i2c eeprom 0080: 00 00 00 00 00 00 1e 40 1e 72
> 00 20 01 01 00 01
> [  104.043873] em2765 #0: i2c eeprom 0090: 01 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043879] em2765 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043885] em2765 #0: i2c eeprom 00b0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043891] em2765 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043898] em2765 #0: i2c eeprom 00d0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043904] em2765 #0: i2c eeprom 00e0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043910] em2765 #0: i2c eeprom 00f0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [  104.043917] em2765 #0: i2c eeprom 0100: ... (skipped)
> [  104.043921] em2765 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5c22c624
> [  104.043922] em2765 #0: EEPROM info:
> [  104.043924] em2765 #0:       microcode start address = 0x0004, boot
> configuration = 0x01
> [  104.069818] em2765 #0:       no hardware configuration dataset found
> in eeprom
> [  104.080693] em2765 #0: sensor OV2640 detected
> [  104.080715] em2765 #0: Identified as SpeedLink Vicious And Devine
> Laplace webcam (card=90)
> [  104.159699] ov2640 11-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
> [  104.173836] i2c i2c-11: OV2640 Probed

I presume, this is good.

> [  104.306698] em2765 #0: Config register raw data: 0x00
> [  104.306717] em2765 #0: v4l2 driver version 0.2.0
> [  104.321152] em2765 #0: V4L2 video device registered as video1

This is good too.

> [  104.321167] ------------[ cut here ]------------
> [  104.321216] WARNING: CPU: 0 PID: 517 at
> drivers/media/v4l2-core/v4l2-clk.c:131 v4l2_clk_disable+0x83/0x90
> [videodev]()
> [  104.321221] Unbalanced v4l2_clk_disable() on 11-0030:mclk!

Ok, this is because em28xx_init_dev() calls

	/* Save some power by putting tuner to sleep */
	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);

without turning the subdevice on before. Are those subdevices on by 
default? In principle, this warning is harmless and it should still work 
afterwards, but we should still clean this up - by either removing the 
warning, or adding a power-on before a power-off in em28xx_init_dev(), or 
somehow else. In fact, I think, this should indeed be done: 
em28xx_card_setup() performs i2c accesses, right? So, we have to power up 
the subdev before that.

> [  104.321226] Modules linked in: ov2640 soc_camera soc_mediabus
> em28xx(+) videobuf2_core videobuf2_vmalloc videobuf2_memops xt_tcpudp
> xt_pkttype xt_LOG af_packet xt_limit snd_hda_codec_hdmi
> snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
> snd_seq arc4 rtl8187 rc_hauppauge ir_kbd_i2c tuner_simple tuner_types
> mac80211 tda9887 snd_timer tda8290 tuner cfg80211 snd_seq_device msp3400
> snd bttv usb_storage usblp firewire_ohci shpchp sg firewire_core sr_mod
> rfkill v4l2_common eeprom_93cx6 videodev crc_itu_t ppdev pci_hotplug
> serio_raw videobuf_dma_sg soundcore videobuf_core parport_pc parport
> i2c_nforce2 forcedeth k8temp snd_page_alloc btcx_risc rc_core tveeprom
> mperf asus_atk0110 pcspkr powernow_k8 button cdrom floppy autofs4
> radeon ttm drm_kms_helper drm i2c_algo_bit thermal fan processor
> thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh
> ata_generic pata_amd pata_jmicron sata_nv
> [  104.321353] CPU: 0 PID: 517 Comm: udevd Not tainted
> 3.11.0-rc2-0.1-desktop+ #19
> [  104.321358] Hardware name: System manufacturer System Product
> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
> [  104.321363]  00000000 00000000 f52dbb70 c0743834 f52dbbb0 f52dbba0
> c023f5ef f7bde565
> [  104.321375]  f52dbbcc 00000205 f7bdf620 00000083 f7bd9f03 f7bd9f03
> eb112c40 eb112c58
> [  104.321386]  00000000 f52dbbb8 c023f68e 00000009 f52dbbb0 f7bde565
> f52dbbcc f52dbbe0
> [  104.321397] Call Trace:
> [  104.321411]  [<c0743834>] dump_stack+0x4b/0x72
> [  104.321420]  [<c023f5ef>] warn_slowpath_common+0x7f/0xa0
> [  104.321446]  [<f7bd9f03>] ? v4l2_clk_disable+0x83/0x90 [videodev]
> [  104.321466]  [<f7bd9f03>] ? v4l2_clk_disable+0x83/0x90 [videodev]
> [  104.321473]  [<c023f68e>] warn_slowpath_fmt+0x2e/0x30
> [  104.321494]  [<f7bd9f03>] v4l2_clk_disable+0x83/0x90 [videodev]
> [  104.321511]  [<f8d2b821>] soc_camera_power_off+0x31/0x60 [soc_camera]
> [  104.321530]  [<f8d46f13>] ?
> em28xx_register_analog_devices+0x653/0x6c0 [em28xx]
> [  104.321539]  [<f8d33284>] ov2640_s_power+0x34/0x60 [ov2640]
> [  104.321555]  [<f8d492c2>] em28xx_usb_probe+0xef2/0x1330 [em28xx]
> [  104.321564]  [<c03a31f5>] ? __sysfs_add_one+0x55/0xf0
> [  104.321574]  [<c057f5f8>] ? __pm_runtime_set_status+0xf8/0x210
> [  104.321581]  [<c057f4b1>] ? __pm_runtime_resume+0x41/0x50
> [  104.321590]  [<c05df477>] usb_probe_interface+0x187/0x2c0
> [  104.321598]  [<c05745aa>] ? driver_sysfs_add+0x6a/0x90
> [  104.321604]  [<c0574a44>] driver_probe_device+0x74/0x360
> [  104.321610]  [<c05ded31>] ? usb_match_id+0x41/0x60
> [  104.321617]  [<c05ded9e>] ? usb_device_match+0x4e/0x90
> [  104.321623]  [<c0574db9>] __driver_attach+0x89/0x90
> [  104.321630]  [<c0574d30>] ? driver_probe_device+0x360/0x360
> [  104.321639]  [<c0572f92>] bus_for_each_dev+0x42/0x80
> [  104.321645]  [<c0574539>] driver_attach+0x19/0x20
> [  104.321652]  [<c0574d30>] ? driver_probe_device+0x360/0x360
> [  104.321658]  [<c05740c4>] bus_add_driver+0xe4/0x260
> [  104.321665]  [<c0575375>] driver_register+0x65/0x160
> [  104.321673]  [<c029beed>] ? smp_call_function+0x2d/0x50
> [  104.321681]  [<c0236870>] ? __cpa_process_fault+0x80/0x80
> [  104.321688]  [<c05ddf22>] usb_register_driver+0x62/0x150
> [  104.321695]  [<c023752a>] ? change_page_attr_set_clr+0x2da/0x380
> [  104.321707]  [<f8d5c000>] ? 0xf8d5bfff
> [  104.321724]  [<f8d5c017>] em28xx_usb_driver_init+0x17/0x1000 [em28xx]
> [  104.321732]  [<c02003fa>] do_one_initcall+0xaa/0x160
> [  104.321741]  [<c02d0ab4>] ? tracepoint_module_notify+0xc4/0x180
> [  104.321752]  [<f8d5c000>] ? 0xf8d5bfff
> [  104.321758]  [<c0237797>] ? set_memory_nx+0x57/0x60
> [  104.321772]  [<c0740c14>] ? set_section_ro_nx+0x4f/0x54
> [  104.321781]  [<c02a1388>] load_module+0x1ba8/0x2510
> [  104.321792]  [<c02a1d87>] SyS_init_module+0x97/0x100
> [  104.321801]  [<c030f463>] ? vm_mmap_pgoff+0x83/0xb0
> [  104.321811]  [<c074fc3a>] sysenter_do_call+0x12/0x22
> [  104.321816] ---[ end trace ce95bae000cad89a ]---
> [  104.321823] em2765 #0: analog set to bulk mode.
> [  104.322214] usbcore: registered new interface driver em28xx
> [  104.373835] ------------[ cut here ]------------
> [  104.373886] WARNING: CPU: 0 PID: 2087 at
> drivers/media/v4l2-core/v4l2-clk.c:131 v4l2_clk_disable+0x83/0x90
> [videodev]()
> [  104.373892] Unbalanced v4l2_clk_disable() on 11-0030:mclk!

Here's another one of the same kind.

> [  104.373896] Modules linked in: snd_rawmidi ov2640 soc_camera
> soc_mediabus em28xx videobuf2_core videobuf2_vmalloc videobuf2_memops
> xt_tcpudp xt_pkttype xt_LOG af_packet xt_limit snd_hda_codec_hdmi
> snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
> snd_seq arc4 rtl8187 rc_hauppauge ir_kbd_i2c tuner_simple tuner_types
> mac80211 tda9887 snd_timer tda8290 tuner cfg80211 snd_seq_device msp3400
> snd bttv usb_storage usblp firewire_ohci shpchp sg firewire_core sr_mod
> rfkill v4l2_common eeprom_93cx6 videodev crc_itu_t ppdev pci_hotplug
> serio_raw videobuf_dma_sg soundcore videobuf_core parport_pc parport
> i2c_nforce2 forcedeth k8temp snd_page_alloc btcx_risc rc_core tveeprom
> mperf asus_atk0110 pcspkr powernow_k8 button cdrom floppy
> autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit thermal fan processor
> thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh
> ata_generic pata_amd pata_jmicron sata_nv
> [  104.374088] CPU: 0 PID: 2087 Comm: v4l_id Tainted: G        W   
> 3.11.0-rc2-0.1-desktop+ #19
> [  104.374093] Hardware name: System manufacturer System Product
> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
> [  104.374098]  00000000 00000000 eb247e74 c0743834 eb247eb4 eb247ea4
> c023f5ef f7bde565
> [  104.374110]  eb247ed0 00000827 f7bdf620 00000083 f7bd9f03 f7bd9f03
> eb112c40 eb112c58
> [  104.374121]  00000000 eb247ebc c023f68e 00000009 eb247eb4 f7bde565
> eb247ed0 eb247ee4
> [  104.374132] Call Trace:
> [  104.374145]  [<c0743834>] dump_stack+0x4b/0x72
> [  104.374178]  [<c023f5ef>] warn_slowpath_common+0x7f/0xa0
> [  104.374208]  [<f7bd9f03>] ? v4l2_clk_disable+0x83/0x90 [videodev]
> [  104.374228]  [<f7bd9f03>] ? v4l2_clk_disable+0x83/0x90 [videodev]
> [  104.374242]  [<c023f68e>] warn_slowpath_fmt+0x2e/0x30
> [  104.374266]  [<f7bd9f03>] v4l2_clk_disable+0x83/0x90 [videodev]
> [  104.374284]  [<f8d2b821>] soc_camera_power_off+0x31/0x60 [soc_camera]
> [  104.374293]  [<f8d33284>] ov2640_s_power+0x34/0x60 [ov2640]
> [  104.374308]  [<f8d44c16>] em28xx_v4l2_close+0x86/0x150 [em28xx]
> [  104.374326]  [<f7bcf02e>] v4l2_release+0x2e/0x70 [videodev]
> [  104.374335]  [<c034558f>] __fput+0xaf/0x1d0
> [  104.374342]  [<c03456e8>] ____fput+0x8/0x10
> [  104.374352]  [<c025d189>] task_work_run+0x79/0x90
> [  104.374359]  [<c0202071>] do_notify_resume+0x41/0x70
> [  104.374368]  [<c0749a8f>] work_notifysig+0x24/0x29
> [  104.374374] ---[ end trace ce95bae000cad89b ]---
> [  104.440959] usbcore: registered new interface driver snd-usb-audio

So, above I didn't see anything bad, does the camera actually work with 
this?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
