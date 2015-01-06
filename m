Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43742 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbbAFJgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jan 2015 04:36:19 -0500
Message-ID: <54ABAC8C.6020401@xs4all.nl>
Date: Tue, 06 Jan 2015 10:36:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>
CC: linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] [Patch] implement video driver for sur40
References: <5492D7E8.504@butterbrot.org> <5492E091.1060404@xs4all.nl> <54943680.3020007@butterbrot.org> <549437DA.6090601@xs4all.nl> <54943CC2.6040803@butterbrot.org> <549443C9.6090900@xs4all.nl> <alpine.DEB.2.02.1501061018580.3223@butterbrot>
In-Reply-To: <alpine.DEB.2.02.1501061018580.3223@butterbrot>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2015 10:29 AM, Florian Echtler wrote:
> On Fri, 19 Dec 2014, Hans Verkuil wrote:
>> drivers/media remains under heavy development, so for video capture drivers
>> like yours you should always patch against either the mainline linux tree
>> or (preferred) the media_tree.git repo (git://linuxtv.org/media_tree.git,
>> master branch).
> As per your suggestion, I've switched development to 3.18, and now I'm 
> nearly there in terms of v4l2-compliance (also see attachment).
> 
> There's only one failing test left, which is this one:
> 
> Streaming ioctls:
>  	test read/write: OK
>  		fail: v4l2-test-buffers.cpp(284): g_field() == V4L2_FIELD_ANY

You're not filling in the 'field' field of struct v4l2_buffer when returning a
frame. It should most likely be FIELD_NONE in your case.

>  		fail: v4l2-test-buffers.cpp(611): buf.check(q, last_seq)
>  		fail: v4l2-test-buffers.cpp(884): captureBufs(node, q, m2m_q, frame_count, false)
>  	test MMAP: FAIL
>  	test USERPTR: OK (Not Supported)
>  	test DMABUF: Cannot test, specify --expbuf-device
> 
> Total: 45, Succeeded: 44, Failed: 1, Warnings: 0
> 
> Could you give some hints on what this means?
> 
> 
> On a different note, I'm getting occasional warnings in syslog when I run 
> a regular video streaming application (e.g. cheese):
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 4995 at /home/apw/COD/linux/drivers/media/v4l2-core/videobuf2-core.c:2144 __vb2_queue_cancel+0x1d0/0x240 [videobuf2_core]()
> Modules linked in: sur40(OE) videobuf2_dma_contig videobuf2_memops videobuf2_core v4l2_common videodev media dm_crypt wl(POE) snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel rfcomm bnep joydev input_polldev snd_hda_controller snd_hda_codec snd_hwdep kvm_amd kvm snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi edac_core snd_seq snd_seq_device serio_raw snd_timer sp5100_tco k10temp edac_mce_amd i2c_piix4 snd btusb soundcore bluetooth cfg80211 ipmi_si ppdev lp parport_pc ipmi_msghandler parport tpm_infineon mac_hid shpchp hid_apple usbhid hid uas usb_storage pata_acpi radeon i2c_algo_bit ttm psmouse drm_kms_helper pata_atiixp drm r8169 ahci mii libahci [last unloaded: sur40]
> CPU: 1 PID: 4995 Comm: cheese Tainted: P           OE  3.17.1-031701-generic #201410150735
> Hardware name: Samsung SUR40/SDNE-R78BA2-20, BIOS SDNE-R78BA2-2000 11/04/2011
> 0000000000000860 ffff8800c2c1bd28 ffffffff81796c37 0000000000000007
> 0000000000000000 ffff8800c2c1bd68 ffffffff81074a3c ffff8800c2c1bd58
> fff8800c05904f8 ffff8800c05904d0 ffff8800abd65d38 ffff8800abd65d38
> Call Trace:
> [<ffffffff81796c37>] dump_stack+0x46/0x58
> [<ffffffff81074a3c>] warn_slowpath_common+0x8c/0xc0
> [<ffffffff81074a8a>] warn_slowpath_null+0x1a/0x20
> [<ffffffffc05b7a10>] __vb2_queue_cancel+0x1d0/0x240 [videobuf2_core]
> [<ffffffffc05bb3ee>] vb2_queue_release+0x1e/0x40 [videobuf2_core]
> [<ffffffffc05bb481>] _vb2_fop_release+0x71/0xb0 [videobuf2_core]
> [<ffffffffc05bb4ee>] vb2_fop_release+0x2e/0x50 [videobuf2_core]
> [<ffffffffc0c1f491>] v4l2_release+0x41/0x90 [videodev]
> [<ffffffff811eb34d>] __fput+0xbd/0x250
> [<ffffffff811eb52e>] ____fput+0xe/0x10
> [<ffffffff81091504>] task_work_run+0xc4/0xe0
> [<ffffffff810776a6>] do_exit+0x196/0x470
> [<ffffffff81082822>] ? zap_other_threads+0x82/0xa0
> [<ffffffff81077a14>] do_group_exit+0x44/0xa0
> [<ffffffff81077a87>] SyS_exit_group+0x17/0x20
> [<ffffffff817a47ad>] system_call_fastpath+0x1a/0x1f
> ---[ end trace 451ed974170f6e44 ]---
> 
> Does this mean the driver consumes too much CPU resources?

No, it means that your driver is not returning all buffers to vb2. Most
likely this is missing in the vb2 stop_streaming op. When that is called
your driver must return all buffers it has back to vb2 by calling
vb2_buffer_done with state ERROR. The same can happen in the start_streaming
op if that returns an error for some reason. In that case all buffers owned
by the driver should be returned to vb2 with state QUEUED. See also
Documentation/video4linux/v4l2-pci-skeleton.c as reference code.

Regards,

	Hans

> 
> Thanks for your help & best regards, Florian
> 

