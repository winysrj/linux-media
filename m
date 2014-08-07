Return-path: <linux-media-owner@vger.kernel.org>
Received: from pindarots.xs4all.nl ([82.161.210.87]:48536 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaHGPZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 11:25:31 -0400
Message-ID: <53E391E3.2050808@xs4all.nl>
Date: Thu, 07 Aug 2014 16:49:07 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: USB list <linux-usb@vger.kernel.org>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: 3.15.6 USB issue with pwc cam
References: <53DCE329.4030106@xs4all.nl> <2923628.39nbDsJU79@avalon>
In-Reply-To: <2923628.39nbDsJU79@avalon>
Content-Type: multipart/mixed;
 boundary="------------010407000400080405070705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010407000400080405070705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 2014-08-04 11:17, Laurent Pinchart wrote:
> (CC'ing Hans de Goede, the pwc maintainer, and the linux-media mailing list)
> 
> On Saturday 02 August 2014 15:10:01 Udo van den Heuvel wrote:
>> Hello,
>>
>> I moved a PWC webcam to a USB3 port, and this happened:

I get similar stuff when trying to use a Logitech C615 cam.
See attachment for full dmesg of errors but excerpt below:

[80346.835015] xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11.
[80346.835027] usb 6-2: Not enough bandwidth for altsetting 11
[80346.835137] ------------[ cut here ]------------
[80346.835155] WARNING: CPU: 3 PID: 20594 at
drivers/media/v4l2-core/videobuf2-core.c:2011
__vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
[80346.835158] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse
edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns
nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE
xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables
ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2
snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc
videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common
videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev
snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq
snd_seq_device microcode snd_pcm parport_serial parport_pc parport
snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd
auth_rpcgss oid_registry
[80346.835218]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic
usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon
bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit
xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80346.835250] CPU: 3 PID: 20594 Comm: skype Tainted: G        W
3.15.8 #6
[80346.835254] Hardware name: Gigabyte Technology Co., Ltd. To be filled
by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80346.835257]  0000000000000000 0000000079d580f4 ffffffff814f2373
0000000000000000
[80346.835262]  ffffffff81069fe1 0000000000000000 ffff88040ec532e8
0000000000000000
[80346.835267]  ffff88040ec530d8 ffff8803f0c46f00 ffffffffa041d832
ffff88040ec530d8
[80346.835272] Call Trace:
[80346.835283]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80346.835289]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80346.835299]  [<ffffffffa041d832>] ? __vb2_queue_cancel+0x102/0x170
[videobuf2_core]
[80346.835307]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50
[videobuf2_core]
[80346.835314]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80346.835321]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0
[uvcvideo]
[80346.835327]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580
[uvcvideo]
[80346.835339]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80346.835345]  [<ffffffffa06150b0>] ?
uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80346.835352]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80346.835356]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80346.835360]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80346.835367]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80346.835376]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80346.835386]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330
[videodev]
[80346.835392]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80346.835402]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8
[videodev]
[80346.835408]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80346.835414]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80346.835421]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80346.835424] ---[ end trace 44e3d272b6c91a71 ]---
[80346.835427] ------------[ cut here ]------------


What is wrong here?

Kind regards,
Udo


--------------010407000400080405070705
Content-Type: text/plain; charset=UTF-8;
 name="dmesguvc.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesguvc.txt"

[80346.835015] xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code 0x11.
[80346.835027] usb 6-2: Not enough bandwidth for altsetting 11
[80346.835137] ------------[ cut here ]------------
[80346.835155] WARNING: CPU: 3 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
[80346.835158] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80346.835218]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80346.835250] CPU: 3 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80346.835254] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80346.835257]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80346.835262]  ffffffff81069fe1 0000000000000000 ffff88040ec532e8 0000000000000000
[80346.835267]  ffff88040ec530d8 ffff8803f0c46f00 ffffffffa041d832 ffff88040ec530d8
[80346.835272] Call Trace:
[80346.835283]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80346.835289]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80346.835299]  [<ffffffffa041d832>] ? __vb2_queue_cancel+0x102/0x170 [videobuf2_core]
[80346.835307]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80346.835314]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80346.835321]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80346.835327]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80346.835339]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80346.835345]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80346.835352]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80346.835356]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80346.835360]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80346.835367]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80346.835376]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80346.835386]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80346.835392]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80346.835402]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80346.835408]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80346.835414]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80346.835421]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80346.835424] ---[ end trace 44e3d272b6c91a71 ]---
[80346.835427] ------------[ cut here ]------------
[80346.835434] WARNING: CPU: 3 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80346.835436] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80346.835491]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80346.835516] CPU: 3 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80346.835519] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80346.835521]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80346.835526]  ffffffff81069fe1 0000000000000000 ffff8803f1ec4000 ffff88040ec530d8
[80346.835531]  0000000000000003 ffff8803f0c46f00 ffffffffa041d0af 0000000000000000
[80346.835535] Call Trace:
[80346.835541]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80346.835546]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80346.835555]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80346.835562]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80346.835570]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80346.835576]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80346.835583]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80346.835589]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80346.835600]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80346.835606]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80346.835611]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80346.835616]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80346.835619]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80346.835625]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80346.835634]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80346.835654]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80346.835659]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80346.835669]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80346.835674]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80346.835679]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80346.835685]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80346.835753] ---[ end trace 44e3d272b6c91a72 ]---
[80346.835756] ------------[ cut here ]------------
[80346.835764] WARNING: CPU: 3 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80346.835766] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80346.835821]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80346.835846] CPU: 3 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80346.835849] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80346.835851]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80346.835856]  ffffffff81069fe1 0000000000000001 ffff880395565000 ffff88040ec530d8
[80346.835861]  0000000000000003 ffff8803f0c46f00 ffffffffa041d0af 0000000000000001
[80346.835865] Call Trace:
[80346.835871]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80346.835876]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80346.835885]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80346.835892]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80346.835900]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80346.835906]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80346.835913]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80346.835918]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80346.835929]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80346.835935]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80346.835941]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80346.835945]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80346.835949]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80346.835954]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80346.835963]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80346.835972]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80346.835978]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80346.835987]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80346.835992]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80346.835998]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80346.836004]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80346.836007] ---[ end trace 44e3d272b6c91a73 ]---
[80346.836009] ------------[ cut here ]------------
[80346.836017] WARNING: CPU: 3 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80346.836019] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80346.836076]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80346.836116] CPU: 3 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80346.836118] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80346.836120]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80346.836125]  ffffffff81069fe1 0000000000000002 ffff880408402c00 ffff88040ec530d8
[80346.836129]  0000000000000003 ffff8803f0c46f00 ffffffffa041d0af 0000000000000002
[80346.836134] Call Trace:
[80346.836139]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80346.836144]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80346.836153]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80346.836160]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80346.836168]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80346.836174]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80346.836180]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80346.836186]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80346.836196]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80346.836203]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80346.836208]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80346.836212]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80346.836216]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80346.836221]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80346.836231]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80346.836240]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80346.836245]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80346.836255]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80346.836259]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80346.836265]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80346.836271]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80346.836274] ---[ end trace 44e3d272b6c91a74 ]---
[80346.836277] ------------[ cut here ]------------
[80346.836284] WARNING: CPU: 3 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80346.836286] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80346.836340]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80346.836365] CPU: 3 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80346.836367] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80346.836369]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80346.836374]  ffffffff81069fe1 0000000000000003 ffff88007c8d0c00 ffff88040ec530d8
[80346.836378]  0000000000000003 ffff8803f0c46f00 ffffffffa041d0af 0000000000000003
[80346.836383] Call Trace:
[80346.836388]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80346.836393]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80346.836401]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80346.836409]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80346.836417]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80346.836422]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80346.836429]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80346.836435]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80346.836445]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80346.836451]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80346.836457]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80346.836461]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80346.836465]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80346.836470]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80346.836479]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80346.836489]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80346.836494]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80346.836503]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80346.836508]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80346.836514]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80346.836520]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80346.836523] ---[ end trace 44e3d272b6c91a75 ]---
[80349.059300] xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code 0x11.
[80349.059315] usb 6-2: Not enough bandwidth for altsetting 11
[80349.059484] ------------[ cut here ]------------
[80349.059506] WARNING: CPU: 2 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
[80349.059509] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80349.059574]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80349.059594] CPU: 2 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80349.059596] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80349.059598]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80349.059601]  ffffffff81069fe1 0000000000000000 ffff88040ec532e8 0000000000000000
[80349.059603]  ffff88040ec530d8 ffff88041ca33a00 ffffffffa041d832 ffff88040ec530d8
[80349.059606] Call Trace:
[80349.059613]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80349.059617]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80349.059621]  [<ffffffffa041d832>] ? __vb2_queue_cancel+0x102/0x170 [videobuf2_core]
[80349.059625]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80349.059628]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80349.059630]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80349.059632]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80349.059638]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80349.059641]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80349.059643]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80349.059646]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80349.059647]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80349.059650]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80349.059654]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80349.059658]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80349.059660]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80349.059664]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80349.059667]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80349.059670]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80349.059673]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80349.059674] ---[ end trace 44e3d272b6c91a76 ]---
[80349.059676] ------------[ cut here ]------------
[80349.059678] WARNING: CPU: 2 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80349.059679] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80349.059699]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80349.059709] CPU: 2 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80349.059710] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80349.059710]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80349.059712]  ffffffff81069fe1 0000000000000000 ffff8803f3ea8800 ffff88040ec530d8
[80349.059714]  0000000000000003 ffff88041ca33a00 ffffffffa041d0af 0000000000000000
[80349.059715] Call Trace:
[80349.059718]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80349.059719]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80349.059723]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80349.059726]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80349.059728]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80349.059731]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80349.059733]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80349.059735]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80349.059739]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80349.059741]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80349.059743]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80349.059745]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80349.059746]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80349.059748]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80349.059752]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80349.059755]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80349.059757]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80349.059761]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80349.059762]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80349.059764]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80349.059766]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80349.059768] ---[ end trace 44e3d272b6c91a77 ]---
[80349.059769] ------------[ cut here ]------------
[80349.059771] WARNING: CPU: 2 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80349.059772] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80349.059792]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80349.059801] CPU: 2 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80349.059802] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80349.059803]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80349.059805]  ffffffff81069fe1 0000000000000001 ffff88037dd0f800 ffff88040ec530d8
[80349.059806]  0000000000000003 ffff88041ca33a00 ffffffffa041d0af 0000000000000001
[80349.059808] Call Trace:
[80349.059810]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80349.059812]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80349.059815]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80349.059818]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80349.059821]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80349.059823]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80349.059825]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80349.059827]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80349.059831]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80349.059834]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80349.059836]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80349.059837]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80349.059839]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80349.059840]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80349.059844]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80349.059847]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80349.059849]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80349.059853]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80349.059855]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80349.059857]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80349.059859]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80349.059860] ---[ end trace 44e3d272b6c91a78 ]---
[80349.059861] ------------[ cut here ]------------
[80349.059864] WARNING: CPU: 2 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80349.059865] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80349.059885]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80349.059894] CPU: 2 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80349.059894] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80349.059895]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80349.059897]  ffffffff81069fe1 0000000000000002 ffff88007c95d800 ffff88040ec530d8
[80349.059898]  0000000000000003 ffff88041ca33a00 ffffffffa041d0af 0000000000000002
[80349.059900] Call Trace:
[80349.059902]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80349.059904]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80349.059907]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80349.059910]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80349.059913]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80349.059915]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80349.059917]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80349.059919]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80349.059923]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80349.059925]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80349.059927]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80349.059929]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80349.059930]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80349.059932]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80349.059936]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80349.059939]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80349.059941]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80349.059945]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80349.059946]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80349.059948]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80349.059951]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80349.059952] ---[ end trace 44e3d272b6c91a79 ]---
[80349.059953] ------------[ cut here ]------------
[80349.059955] WARNING: CPU: 2 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80349.059956] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80349.059977]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80349.059986] CPU: 2 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80349.059987] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80349.059987]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80349.059989]  ffffffff81069fe1 0000000000000003 ffff8803f3ea2c00 ffff88040ec530d8
[80349.059991]  0000000000000003 ffff88041ca33a00 ffffffffa041d0af 0000000000000003
[80349.059992] Call Trace:
[80349.059994]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80349.059996]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80349.059999]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80349.060002]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80349.060005]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80349.060007]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80349.060009]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80349.060011]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80349.060015]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80349.060017]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80349.060019]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80349.060021]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80349.060022]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80349.060024]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80349.060027]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80349.060031]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80349.060033]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80349.060036]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80349.060038]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80349.060040]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80349.060042]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80349.060043] ---[ end trace 44e3d272b6c91a7a ]---
[80350.320279] xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code 0x11.
[80350.320295] usb 6-2: Not enough bandwidth for altsetting 11
[80350.320459] ------------[ cut here ]------------
[80350.320479] WARNING: CPU: 0 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
[80350.320484] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80350.320561]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80350.320597] CPU: 0 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80350.320601] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80350.320604]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80350.320609]  ffffffff81069fe1 0000000000000000 ffff88040ec532e8 0000000000000000
[80350.320614]  ffff88040ec530d8 ffff8803f1ecc300 ffffffffa041d832 ffff88040ec530d8
[80350.320619] Call Trace:
[80350.320629]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80350.320636]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80350.320646]  [<ffffffffa041d832>] ? __vb2_queue_cancel+0x102/0x170 [videobuf2_core]
[80350.320655]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80350.320662]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80350.320669]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80350.320675]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80350.320687]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80350.320693]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80350.320700]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80350.320705]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80350.320709]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80350.320715]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80350.320725]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80350.320735]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80350.320741]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80350.320751]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80350.320757]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80350.320763]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80350.320770]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80350.320774] ---[ end trace 44e3d272b6c91a7b ]---
[80350.320776] ------------[ cut here ]------------
[80350.320784] WARNING: CPU: 0 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80350.320786] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80350.320840]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80350.320866] CPU: 0 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80350.320868] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80350.320871]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80350.320876]  ffffffff81069fe1 0000000000000000 ffff880340ab0000 ffff88040ec530d8
[80350.320880]  0000000000000003 ffff8803f1ecc300 ffffffffa041d0af 0000000000000000
[80350.320884] Call Trace:
[80350.320890]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80350.320896]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80350.320904]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80350.320912]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80350.320920]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80350.320926]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80350.320932]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80350.320938]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80350.320948]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80350.320954]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80350.320960]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80350.320964]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80350.320968]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80350.320973]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80350.320983]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80350.320992]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80350.320998]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80350.321007]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80350.321012]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80350.321018]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80350.321024]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80350.321027] ---[ end trace 44e3d272b6c91a7c ]---
[80350.321030] ------------[ cut here ]------------
[80350.321037] WARNING: CPU: 0 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80350.321039] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80350.321093]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80350.321118] CPU: 0 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80350.321120] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80350.321123]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80350.321127]  ffffffff81069fe1 0000000000000001 ffff8803a111a400 ffff88040ec530d8
[80350.321132]  0000000000000003 ffff8803f1ecc300 ffffffffa041d0af 0000000000000001
[80350.321136] Call Trace:
[80350.321142]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80350.321147]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80350.321155]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80350.321162]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80350.321170]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80350.321176]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80350.321182]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80350.321188]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80350.321199]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80350.321205]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80350.321210]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80350.321215]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80350.321219]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80350.321224]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80350.321233]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80350.321242]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80350.321248]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80350.321257]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80350.321262]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80350.321268]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80350.321273]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80350.321276] ---[ end trace 44e3d272b6c91a7d ]---
[80350.321279] ------------[ cut here ]------------
[80350.321286] WARNING: CPU: 0 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80350.321288] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80350.321342]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80350.321366] CPU: 0 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80350.321369] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80350.321371]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80350.321375]  ffffffff81069fe1 0000000000000002 ffff8803a1089400 ffff88040ec530d8
[80350.321380]  0000000000000003 ffff8803f1ecc300 ffffffffa041d0af 0000000000000002
[80350.321384] Call Trace:
[80350.321389]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80350.321394]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80350.321402]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80350.321410]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80350.321418]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80350.321423]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80350.321430]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80350.321436]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80350.321446]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80350.321452]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80350.321458]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80350.321462]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80350.321466]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80350.321471]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80350.321480]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80350.321490]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80350.321495]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80350.321505]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80350.321509]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80350.321515]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80350.321521]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80350.321524] ---[ end trace 44e3d272b6c91a7e ]---
[80350.321527] ------------[ cut here ]------------
[80350.321534] WARNING: CPU: 0 PID: 20594 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
[80350.321536] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2 snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq snd_seq_device microcode snd_pcm parport_serial parport_pc parport snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd auth_rpcgss oid_registry
[80350.321590]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
[80350.321614] CPU: 0 PID: 20594 Comm: skype Tainted: G        W     3.15.8 #6
[80350.321617] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
[80350.321619]  0000000000000000 0000000079d580f4 ffffffff814f2373 0000000000000000
[80350.321623]  ffffffff81069fe1 0000000000000003 ffff880082e29c00 ffff88040ec530d8
[80350.321627]  0000000000000003 ffff8803f1ecc300 ffffffffa041d0af 0000000000000003
[80350.321632] Call Trace:
[80350.321637]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
[80350.321642]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
[80350.321650]  [<ffffffffa041d0af>] ? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
[80350.321658]  [<ffffffffa041d86e>] ? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
[80350.321665]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
[80350.321671]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
[80350.321678]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0 [uvcvideo]
[80350.321684]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580 [uvcvideo]
[80350.321694]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
[80350.321700]  [<ffffffffa06150b0>] ? uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
[80350.321706]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
[80350.321710]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
[80350.321714]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
[80350.321719]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
[80350.321728]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
[80350.321737]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330 [videodev]
[80350.321743]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
[80350.321753]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
[80350.321757]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
[80350.321763]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
[80350.321769]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
[80350.321772] ---[ end trace 44e3d272b6c91a7f ]---

--------------010407000400080405070705--
