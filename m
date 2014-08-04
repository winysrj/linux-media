Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33421 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaHDJQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 05:16:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: USB list <linux-usb@vger.kernel.org>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: 3.15.6 USB issue with pwc cam
Date: Mon, 04 Aug 2014 11:17:11 +0200
Message-ID: <2923628.39nbDsJU79@avalon>
In-Reply-To: <53DCE329.4030106@xs4all.nl>
References: <53DCE329.4030106@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Udo,

(CC'ing Hans de Goede, the pwc maintainer, and the linux-media mailing list)

On Saturday 02 August 2014 15:10:01 Udo van den Heuvel wrote:
> Hello,
> 
> I moved a PWC webcam to a USB3 port, and this happened:
> 
> [53008.911811] usb 5-2: new full-speed USB device number 2 using xhci_hcd
> [53009.213504] usb 5-2: New USB device found, idVendor=0471, idProduct=0311
> [53009.213514] usb 5-2: New USB device strings: Mfr=0, Product=0,
> SerialNumber=1
> [53009.213519] usb 5-2: SerialNumber: 01690000A5000000
> [53009.215547] pwc: Philips PCVC740K (ToUCam Pro)/PCVC840 (ToUCam II)
> USB webcam detected.
> [53009.846698] pwc: Registered as video0.
> [53009.846814] input: PWC snapshot button as
> /devices/pci0000:00/0000:00:07.0/0000:02:00.0/usb5/5-2/input/input7
> [53009.847233] xhci_hcd 0000:02:00.0: ERROR: unexpected command
> completion code 0x11.
> [53009.847242] usb 5-2: Not enough bandwidth for altsetting 1
> [53009.847275] xhci_hcd 0000:02:00.0: ERROR: unexpected command
> completion code 0x11.
> [53009.847285] usb 5-2: Not enough bandwidth for altsetting 2
> [53009.847317] xhci_hcd 0000:02:00.0: ERROR: unexpected command
> completion code 0x11.
> [53009.847323] usb 5-2: Not enough bandwidth for altsetting 3
> [53009.847355] xhci_hcd 0000:02:00.0: ERROR: unexpected command
> completion code 0x11.
> [53009.847360] usb 5-2: Not enough bandwidth for altsetting 4
> [53010.004876] xhci_hcd 0000:02:00.0: ERROR: unexpected command
> completion code 0x11.
> [53010.004890] usb 5-2: Not enough bandwidth for altsetting 1
> [53010.004896] usb 5-2: 2:1: usb_set_interface failed (-22)
> [53010.004960] xhci_hcd 0000:02:00.0: ERROR: unexpected command
> completion code 0x11.
> [53010.004988] usb 5-2: Not enough bandwidth for altsetting 1
> [53010.004992] usb 5-2: 2:1: usb_set_interface failed (-22)

[snip, same 3 messages repeated 118 times]

> [53063.286759] ------------[ cut here ]------------
> [53063.286783] WARNING: CPU: 2 PID: 3282 at
> drivers/media/v4l2-core/videobuf2-core.c:2011
> __vb2_queue_cancel+0x102/0x170 [videobuf2_core]()

This probably denotes a bug in the pwc driver. However, the problem that makes 
your webcam unusable comes from either the XCHI driver, or the interaction of 
the PWC driver with XHCI. Nonetheless, the bug causing this warning should be 
fixed.

Hans, have you tested PWC with XHCI ?

> [53063.286786] Modules linked in: bnep bluetooth fuse edac_core
> cpufreq_userspace nf_conntrack_netbios_ns nf_conntrack_broadcast
> ip6t_REJECT ipt_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
> xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter
> ip6_tables ip_tables x_tables eeprom it87 hwmon_vid ext2 ppdev kvm_amd
> kvm snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi microcode
> k10temp parport_serial pwc parport_pc videobuf2_vmalloc videobuf2_memops
> v4l2_common parport videobuf2_core i2c_piix4 snd_hda_codec_realtek
> videodev evdev cp210x snd_hda_codec_generic snd_hda_intel cdc_acm
> usbserial snd_hda_controller snd_hda_codec snd_seq snd_seq_device
> snd_pcm snd_timer snd button acpi_cpufreq nfsd auth_rpcgss oid_registry
> [53063.286844]  nfs_acl lockd binfmt_misc sunrpc autofs4 hid_generic
> usbhid radeon fbcon ehci_pci bitblit softcursor ehci_hcd font ohci_pci
> ohci_hcd cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit backlight sr_mod
> cdrom drm_kms_helper ttm drm xhci_hcd fb fbdev
> [53063.286876] CPU: 2 PID: 3282 Comm: skype Not tainted 3.15.6 #5
> [53063.286879] Hardware name: Gigabyte Technology Co., Ltd. To be filled
> by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
> [53063.286882]  0000000000000000 000000001e19c613 ffffffff814f1fd3
> 0000000000000000
> [53063.286887]  ffffffff81069fc1 0000000000000000 0000000040045613
> ffff880316167500
> [53063.286892]  ffff88042ca30300 ffff8803cf337c48 ffffffffa0446832
> ffff88042ca30000
> [53063.286897] Call Trace:
> [53063.286907]  [<ffffffff814f1fd3>] ? dump_stack+0x4a/0x75
> [53063.286914]  [<ffffffff81069fc1>] ? warn_slowpath_common+0x81/0xb0
> [53063.286924]  [<ffffffffa0446832>] ? __vb2_queue_cancel+0x102/0x170
> [videobuf2_core]
> [53063.286933]  [<ffffffffa044853d>] ? vb2_internal_streamoff+0x1d/0x50
> [videobuf2_core]
> [53063.286944]  [<ffffffffa0423163>] ? __video_do_ioctl+0x2f3/0x380
> [videodev]
> [53063.286957]  [<ffffffffa0422bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
> [53063.286967]  [<ffffffffa0422e70>] ? video_ioctl2+0x10/0x10 [videodev]
> [53063.286974]  [<ffffffff810bffbb>] ? futex_wait_queue_me+0xdb/0x140
> [53063.286983]  [<ffffffffa041e7df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
> [53063.286993]  [<ffffffffa042c7b6>] ? do_video_ioctl+0x246/0x1330
> [videodev]
> [53063.286998]  [<ffffffff810c0b9c>] ? futex_wake+0x7c/0x160
> [53063.287003]  [<ffffffff810c280c>] ? do_futex+0x12c/0xb00
> [53063.287008]  [<ffffffff814f714e>] ? _raw_spin_unlock_irq+0xe/0x30
> [53063.287013]  [<ffffffff8108e3be>] ? finish_task_switch+0x3e/0xe0
> [53063.287022]  [<ffffffffa042d922>] ? v4l2_compat_ioctl32+0x82/0xb8
> [videodev]
> [53063.287028]  [<ffffffff81185f32>] ? compat_SyS_ioctl+0x132/0x1120
> [53063.287034]  [<ffffffff810b5e1d>] ? ktime_get_ts+0x3d/0xd0
> [53063.287039]  [<ffffffff81085aa8>] ? posix_ktime_get_ts+0x8/0x10
> [53063.287043]  [<ffffffff81086960>] ? SyS_clock_gettime+0x60/0x80
> [53063.287049]  [<ffffffff814f9405>] ? cstar_dispatch+0x7/0x1a
> [53063.287052] ---[ end trace 03072f5e82f277f5 ]---
> [53063.287055] ------------[ cut here ]------------
> [53063.287063] WARNING: CPU: 2 PID: 3282 at
> drivers/media/v4l2-core/videobuf2-core.c:1095
> vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
> [53063.287066] Modules linked in: bnep bluetooth fuse edac_core
> cpufreq_userspace nf_conntrack_netbios_ns nf_conntrack_broadcast
> ip6t_REJECT ipt_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
> xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter
> ip6_tables ip_tables x_tables eeprom it87 hwmon_vid ext2 ppdev kvm_amd
> kvm snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi microcode
> k10temp parport_serial pwc parport_pc videobuf2_vmalloc videobuf2_memops
> v4l2_common parport videobuf2_core i2c_piix4 snd_hda_codec_realtek
> videodev evdev cp210x snd_hda_codec_generic snd_hda_intel cdc_acm
> usbserial snd_hda_controller snd_hda_codec snd_seq snd_seq_device
> snd_pcm snd_timer snd button acpi_cpufreq nfsd auth_rpcgss oid_registry
> [53063.287118]  nfs_acl lockd binfmt_misc sunrpc autofs4 hid_generic
> usbhid radeon fbcon ehci_pci bitblit softcursor ehci_hcd font ohci_pci
> ohci_hcd cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit backlight sr_mod
> cdrom drm_kms_helper ttm drm xhci_hcd fb fbdev
> [53063.287143] CPU: 2 PID: 3282 Comm: skype Tainted: G        W
> 3.15.6 #5
> [53063.287146] Hardware name: Gigabyte Technology Co., Ltd. To be filled
> by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
> [53063.287148]  0000000000000000 000000001e19c613 ffffffff814f1fd3
> 0000000000000000
> [53063.287153]  ffffffff81069fc1 0000000000000000 ffff88040cc27c00
> ffff88042ca30300
> [53063.287157]  0000000000000003 ffff8803cf337c48 ffffffffa04460af
> 0000000000000000
> [53063.287161] Call Trace:
> [53063.287167]  [<ffffffff814f1fd3>] ? dump_stack+0x4a/0x75
> [53063.287172]  [<ffffffff81069fc1>] ? warn_slowpath_common+0x81/0xb0
> [53063.287181]  [<ffffffffa04460af>] ? vb2_buffer_done+0x17f/0x1a0
> [videobuf2_core]
> [53063.287189]  [<ffffffffa044686e>] ? __vb2_queue_cancel+0x13e/0x170
> [videobuf2_core]
> [53063.287197]  [<ffffffffa044853d>] ? vb2_internal_streamoff+0x1d/0x50
> [videobuf2_core]
> [53063.287207]  [<ffffffffa0423163>] ? __video_do_ioctl+0x2f3/0x380
> [videodev]
> [53063.287219]  [<ffffffffa0422bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
> [53063.287229]  [<ffffffffa0422e70>] ? video_ioctl2+0x10/0x10 [videodev]
> [53063.287234]  [<ffffffff810bffbb>] ? futex_wait_queue_me+0xdb/0x140
> [53063.287244]  [<ffffffffa041e7df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
> [53063.287253]  [<ffffffffa042c7b6>] ? do_video_ioctl+0x246/0x1330
> [videodev]
> [53063.287259]  [<ffffffff810c0b9c>] ? futex_wake+0x7c/0x160
> [53063.287263]  [<ffffffff810c280c>] ? do_futex+0x12c/0xb00
> [53063.287268]  [<ffffffff814f714e>] ? _raw_spin_unlock_irq+0xe/0x30
> [53063.287272]  [<ffffffff8108e3be>] ? finish_task_switch+0x3e/0xe0
> [53063.287281]  [<ffffffffa042d922>] ? v4l2_compat_ioctl32+0x82/0xb8
> [videodev]
> [53063.287286]  [<ffffffff81185f32>] ? compat_SyS_ioctl+0x132/0x1120
> [53063.287291]  [<ffffffff810b5e1d>] ? ktime_get_ts+0x3d/0xd0
> [53063.287295]  [<ffffffff81085aa8>] ? posix_ktime_get_ts+0x8/0x10
> [53063.287299]  [<ffffffff81086960>] ? SyS_clock_gettime+0x60/0x80
> [53063.287305]  [<ffffffff814f9405>] ? cstar_dispatch+0x7/0x1a
> [53063.287308] ---[ end trace 03072f5e82f277f6 ]---
> 
> 
> 
> At the end I checked the video settings in skype.
> What went wrong?
> How to fix?

-- 
Regards,

Laurent Pinchart

