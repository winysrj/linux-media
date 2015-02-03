Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:41294 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbbBCUp5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 15:45:57 -0500
Message-ID: <54D13383.7010603@butterbrot.org>
Date: Tue, 03 Feb 2015 21:45:55 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <64652239.MTTlcOgNK2@avalon> <54BE5204.3020600@xs4all.nl> <6025823.veVKIskIW2@avalon> <54BFA989.4090405@butterbrot.org> <54BFA9D6.1040201@xs4all.nl> <54CAA786.2040908@butterbrot.org>
In-Reply-To: <54CAA786.2040908@butterbrot.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uvVgu0CLjXT3t8NTKhCWsMC5X3qJPP73s"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uvVgu0CLjXT3t8NTKhCWsMC5X3qJPP73s
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sorry to bring this up again, but would it be acceptable to simply use
dma-contig after all? Since the GFP_DMA flag is gone, this shouldn't be
too big of an issue IMHO, and I was kind of hoping the patch could still
be part of 3.20.

Best, Florian

On 29.01.2015 22:35, Florian Echtler wrote:
> I'm still having a couple of issues sorting out the correct way to
> provide DMA access for my driver. I've integrated most of your
> suggestions, but I still can't switch from dma-contig to dma-sg.
> As far as I understood it, there is no further initialization required
> besides using vb2_dma_sg_memops, vb2_dma_sg_init_ctx and
> vb2_dma_sg_cleanup_ctx instead of the respective -contig- calls, correc=
t?
> However, as soon as I swap the relevant function calls, the video image=

> stays black and in dmesg, I get the following warning:
>
> Call Trace:
> [<ffffffff817c4584>] dump_stack+0x45/0x57
> [<ffffffff81076df7>] warn_slowpath_common+0x97/0xe0
> [<ffffffff81076ef6>] warn_slowpath_fmt+0x46/0x50
> [<ffffffff815aff0b>] usb_hcd_map_urb_for_dma+0x4eb/0x500
> [<ffffffff817d03b4>] ? schedule_timeout+0x124/0x210
> [<ffffffff815b0bd5>] usb_hcd_submit_urb+0x135/0x1c0
> [<ffffffff815b20a6>] usb_submit_urb.part.8+0x1f6/0x580
> [<ffffffff811bb542>] ? vmap_pud_range+0x122/0x1c0
> [<ffffffff815b2465>] usb_submit_urb+0x35/0x80
> [<ffffffff815b339a>] usb_start_wait_urb+0x6a/0x170
> [<ffffffff815b1cce>] ? usb_alloc_urb+0x1e/0x50
> [<ffffffff815b1cce>] ? usb_alloc_urb+0x1e/0x50
> [<ffffffff815b3570>] usb_bulk_msg+0xd0/0x1a0
> [<ffffffffc059a841>] sur40_poll+0x561/0x5e0 [sur40]
>
> Moreover, I'm getting the following test failure from v4l2-compliance:
>=20
> Streaming ioctls:
> 	test read/write: OK
> 	test MMAP: OK
> 		fail: v4l2-test-buffers.cpp(951): buf.qbuf(node)
> 		fail: v4l2-test-buffers.cpp(994): setupUserPtr(node, q)
> 	test USERPTR: FAIL
> 	test DMABUF: Cannot test, specify --expbuf-device
>=20
> Total: 45, Succeeded: 44, Failed: 1, Warnings: 0


--=20
SENT FROM MY DEC VT50 TERMINAL


--uvVgu0CLjXT3t8NTKhCWsMC5X3qJPP73s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTRM4MACgkQ7CzyshGvathu7gCgvPpZ95r5KXEXa1oGBgOmeG7N
vvIAn1OVn2LcyFy/xDPEXfw7HYoclvCK
=NCb6
-----END PGP SIGNATURE-----

--uvVgu0CLjXT3t8NTKhCWsMC5X3qJPP73s--
