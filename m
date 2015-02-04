Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:48708 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbbBDK5A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 05:57:00 -0500
Message-ID: <54D1FAFA.3070506@butterbrot.org>
Date: Wed, 04 Feb 2015 11:56:58 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <64652239.MTTlcOgNK2@avalon> <54BE5204.3020600@xs4all.nl> <6025823.veVKIskIW2@avalon> <54BFA989.4090405@butterbrot.org> <54BFA9D6.1040201@xs4all.nl> <54CAA786.2040908@butterbrot.org> <54D13383.7010603@butterbrot.org> <54D1D37C.20701@xs4all.nl> <54D1EF91.8070805@butterbrot.org> <54D1F2CA.9020201@xs4all.nl>
In-Reply-To: <54D1F2CA.9020201@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1oUR8sUxpR977gJUR1i32XjgtUIhN3dNK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1oUR8sUxpR977gJUR1i32XjgtUIhN3dNK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04.02.2015 11:22, Hans Verkuil wrote:
> On 02/04/15 11:08, Florian Echtler wrote:
>> On 04.02.2015 09:08, Hans Verkuil wrote:
>>> You can also make a version with vmalloc and I'll merge that, and the=
n
>>> you can look more into the DMA issues. That way the driver is merged,=

>>> even if it is perhaps not yet optimal, and you can address that part =
later.
>> OK, that sounds sensible, I will try that route. When using
>> videobuf2-vmalloc, what do I pass back for alloc_ctxs in queue_setup?
> vmalloc doesn't need those, so you can just drop any alloc_ctx related =
code.
That's what I assumed, however, I'm running into the same problem as
with dma-sg when I switch to vmalloc...?

I've sent a "proper" patch submission again, which has all the other
issues from the previous submission fixed. I'm hoping you can maybe have
a closer look and see if I'm doing anything subtly wrong which causes
both vmalloc and dma-sg to fail while dma-contig works.

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--1oUR8sUxpR977gJUR1i32XjgtUIhN3dNK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTR+voACgkQ7CzyshGvathp3QCeNLKhx/eMJniRKvBU8tlxc2Vm
QLcAoNdFspB3lu6qG7BHcJT8uRmvzttP
=+zkI
-----END PGP SIGNATURE-----

--1oUR8sUxpR977gJUR1i32XjgtUIhN3dNK--
