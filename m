Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4140 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaHLPjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 11:39:12 -0400
Message-ID: <53EA350F.2040403@xs4all.nl>
Date: Tue, 12 Aug 2014 17:38:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Udo van den Heuvel <udovdh@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: USB list <linux-usb@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: 3.15.6 USB issue with pwc cam
References: <53DCE329.4030106@xs4all.nl> <2923628.39nbDsJU79@avalon> <53E391E3.2050808@xs4all.nl> <53EA2DA2.4060605@redhat.com>
In-Reply-To: <53EA2DA2.4060605@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2014 05:07 PM, Hans de Goede wrote:
> Hi Udo,
> 
> On 08/07/2014 04:49 PM, Udo van den Heuvel wrote:
>> On 2014-08-04 11:17, Laurent Pinchart wrote:
>>> (CC'ing Hans de Goede, the pwc maintainer, and the linux-media mailing list)
> 
> Thanks for the bug report. I've been looking into this, and there
> seem to be 2 problems:
> 
> 1: xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code 0x11.
> 
> This seems to be what is causing things to not work with a usb-3 port
> for you. Might be fixed by this commit:
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host?h=usb-next&id=3213b151387df0b95f4eada104f68eb1c1409cb3
> 
> Can you please do "lspci -nn", and then copy and paste the output here,
> so that we can see what sort of xhci controller you've (and try to reproduce
> the problem).
> 
> 2: The triggering of a WARN_ON in __vb2_queue_cancel() when called on
> streamoff. I've been looking at the code and I cannot figure out why this
> is triggering I'm afraid.

You can ignore this one.

The uvc driver is doing messy things with vb2 which causes this warning. That
said, it will not break things for you. It is just a warning that the driver
needs to be improved.

Regards,

	Hans

> 
> Regards,
> 
> Hans
> 
> 
> 
> 
>>>
>>> On Saturday 02 August 2014 15:10:01 Udo van den Heuvel wrote:
>>>> Hello,
>>>>
>>>> I moved a PWC webcam to a USB3 port, and this happened:
>>
>> I get similar stuff when trying to use a Logitech C615 cam.
>> See attachment for full dmesg of errors but excerpt below:
>>
>> [80346.835015] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [80346.835027] usb 6-2: Not enough bandwidth for altsetting 11
>> [80346.835137] ------------[ cut here ]------------
>> [80346.835155] WARNING: CPU: 3 PID: 20594 at
>> drivers/media/v4l2-core/videobuf2-core.c:2011
>> __vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
>> [80346.835158] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse
>> edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns
>> nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE
>> xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4
>> nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables
>> ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2
>> snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc
>> videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common
>> videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev
>> snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq
>> snd_seq_device microcode snd_pcm parport_serial parport_pc parport
>> snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd
>> auth_rpcgss oid_registry
>> [80346.835218]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic
>> usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon
>> bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit
>> xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
>> [80346.835250] CPU: 3 PID: 20594 Comm: skype Tainted: G        W
>> 3.15.8 #6
>> [80346.835254] Hardware name: Gigabyte Technology Co., Ltd. To be filled
>> by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
>> [80346.835257]  0000000000000000 0000000079d580f4 ffffffff814f2373
>> 0000000000000000
>> [80346.835262]  ffffffff81069fe1 0000000000000000 ffff88040ec532e8
>> 0000000000000000
>> [80346.835267]  ffff88040ec530d8 ffff8803f0c46f00 ffffffffa041d832
>> ffff88040ec530d8
>> [80346.835272] Call Trace:
>> [80346.835283]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
>> [80346.835289]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
>> [80346.835299]  [<ffffffffa041d832>] ? __vb2_queue_cancel+0x102/0x170
>> [videobuf2_core]
>> [80346.835307]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50
>> [videobuf2_core]
>> [80346.835314]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
>> [80346.835321]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0
>> [uvcvideo]
>> [80346.835327]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580
>> [uvcvideo]
>> [80346.835339]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
>> [80346.835345]  [<ffffffffa06150b0>] ?
>> uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
>> [80346.835352]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
>> [80346.835356]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
>> [80346.835360]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
>> [80346.835367]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
>> [80346.835376]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
>> [80346.835386]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330
>> [videodev]
>> [80346.835392]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
>> [80346.835402]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8
>> [videodev]
>> [80346.835408]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
>> [80346.835414]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
>> [80346.835421]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
>> [80346.835424] ---[ end trace 44e3d272b6c91a71 ]---
>> [80346.835427] ------------[ cut here ]------------
>>
>>
>> What is wrong here?
>>
>> Kind regards,
>> Udo
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

