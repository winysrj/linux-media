Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:44303 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbbA2VfF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 16:35:05 -0500
Message-ID: <54CAA786.2040908@butterbrot.org>
Date: Thu, 29 Jan 2015 22:35:02 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <64652239.MTTlcOgNK2@avalon> <54BE5204.3020600@xs4all.nl> <6025823.veVKIskIW2@avalon> <54BFA989.4090405@butterbrot.org> <54BFA9D6.1040201@xs4all.nl>
In-Reply-To: <54BFA9D6.1040201@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gA3E0mERPULd0qOKrRuWOg3u0jFtn52lT"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gA3E0mERPULd0qOKrRuWOg3u0jFtn52lT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello again,

On 21.01.2015 14:29, Hans Verkuil wrote:
> On 01/21/15 14:28, Florian Echtler wrote:
>> On 20.01.2015 14:06, Laurent Pinchart wrote:
>>> That depends on the platform and whether it can DMA to vmalloc'ed mem=
ory :-)=20
>>> To be totally safe I think vb2-dma-sg would be better, but I'm not su=
re it's=20
>>> worth the trouble. uvcvideo uses vb2-vmalloc as it performs a memcpy =
anyway.
>> The SUR40 sends raw video data without any headers over the bulk
>> endpoint in blocks of 16k, so I'm assuming that in this specific case,=

>> vb2-dma-sg would be the most efficient choice?
I'm still having a couple of issues sorting out the correct way to
provide DMA access for my driver. I've integrated most of your
suggestions, but I still can't switch from dma-contig to dma-sg.

As far as I understood it, there is no further initialization required
besides using vb2_dma_sg_memops, vb2_dma_sg_init_ctx and
vb2_dma_sg_cleanup_ctx instead of the respective -contig- calls, correct?=


However, as soon as I swap the relevant function calls, the video image
stays black and in dmesg, I get the following warning:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 37 at
/home/kernel/COD/linux/drivers/usb/core/hcd.c:1504
usb_hcd_map_urb_for_dma+0x4eb/0x500()
transfer buffer not dma capable
Modules linked in: sur40(OE) videobuf2_dma_contig videobuf2_dma_sg
videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev
media dm_crypt joydev input_polldev wl(POE) snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel
snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq_midi
snd_seq_midi_event snd_rawmidi cfg80211 kvm_amd snd_seq kvm edac_core
serio_raw snd_seq_device btusb snd_timer edac_mce_amd snd ipmi_si
ipmi_msghandler k10temp sp5100_tco i2c_piix4 soundcore bnep 8250_fintek
shpchp tpm_infineon rfcomm bluetooth mac_hid parport_pc ppdev lp parport
hid_apple usbhid hid pata_acpi uas usb_storage amdkfd amd_iommu_v2
radeon psmouse pata_atiixp i2c_algo_bit ttm drm_kms_helper drm ahci
libahci r8169 mii [last unloaded: sur40]
CPU: 1 PID: 37 Comm: kworker/1:1 Tainted: P           OE
3.19.0-031900rc6-generic #201501261152
Hardware name: Samsung SUR40/SDNE-R78BA2-20, BIOS SDNE-R78BA2-2000
11/04/2011
Workqueue: events_freezable input_polled_device_work [input_polldev]
00000000000005e0 ffff8801320c3aa8 ffffffff817c4584 0000000000000007
ffff8801320c3af8 ffff8801320c3ae8 ffffffff81076df7 0000000000000000
ffff8800a71fa6c0 ffff88013243f800 0000000000000010 0000000000000002
Call Trace:
[<ffffffff817c4584>] dump_stack+0x45/0x57
[<ffffffff81076df7>] warn_slowpath_common+0x97/0xe0
[<ffffffff81076ef6>] warn_slowpath_fmt+0x46/0x50
[<ffffffff815aff0b>] usb_hcd_map_urb_for_dma+0x4eb/0x500
[<ffffffff817d03b4>] ? schedule_timeout+0x124/0x210
[<ffffffff815b0bd5>] usb_hcd_submit_urb+0x135/0x1c0
[<ffffffff815b20a6>] usb_submit_urb.part.8+0x1f6/0x580
[<ffffffff811bb542>] ? vmap_pud_range+0x122/0x1c0
[<ffffffff815b2465>] usb_submit_urb+0x35/0x80
[<ffffffff815b339a>] usb_start_wait_urb+0x6a/0x170
[<ffffffff815b1cce>] ? usb_alloc_urb+0x1e/0x50
[<ffffffff815b1cce>] ? usb_alloc_urb+0x1e/0x50
[<ffffffff815b3570>] usb_bulk_msg+0xd0/0x1a0
[<ffffffffc059a841>] sur40_poll+0x561/0x5e0 [sur40]
[<ffffffffc016134b>] input_polled_device_work+0x1b/0x30 [input_polldev]
[<ffffffff8108f6dd>] process_one_work+0x14d/0x460
[<ffffffff810900bb>] worker_thread+0x11b/0x3f0
[<ffffffff8108ffa0>] ? create_worker+0x1e0/0x1e0
[<ffffffff81095cc9>] kthread+0xc9/0xe0
[<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[<ffffffff817d17fc>] ret_from_fork+0x7c/0xb0
[<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
---[ end trace 30eaf6524fd028d3 ]---

Moreover, I'm getting the following test failure from v4l2-compliance:

Streaming ioctls:
	test read/write: OK
	test MMAP: OK
		fail: v4l2-test-buffers.cpp(951): buf.qbuf(node)
		fail: v4l2-test-buffers.cpp(994): setupUserPtr(node, q)
	test USERPTR: FAIL
	test DMABUF: Cannot test, specify --expbuf-device

Total: 45, Succeeded: 44, Failed: 1, Warnings: 0

Any suggestions how to deal with this?

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--gA3E0mERPULd0qOKrRuWOg3u0jFtn52lT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTKp4YACgkQ7CzyshGvathPWgCeLB1gw3eNiPEUUUzh8yp+qgmW
XPYAoI5LVDMrxJLn1teFEnDyhRHynisY
=FHIa
-----END PGP SIGNATURE-----

--gA3E0mERPULd0qOKrRuWOg3u0jFtn52lT--
