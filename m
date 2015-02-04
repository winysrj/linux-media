Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:46987 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbbBDKIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 05:08:19 -0500
Message-ID: <54D1EF91.8070805@butterbrot.org>
Date: Wed, 04 Feb 2015 11:08:17 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <64652239.MTTlcOgNK2@avalon> <54BE5204.3020600@xs4all.nl> <6025823.veVKIskIW2@avalon> <54BFA989.4090405@butterbrot.org> <54BFA9D6.1040201@xs4all.nl> <54CAA786.2040908@butterbrot.org> <54D13383.7010603@butterbrot.org> <54D1D37C.20701@xs4all.nl>
In-Reply-To: <54D1D37C.20701@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LtoVp3brI7i091GdNUFhQkAfMoOVB2dJ3"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LtoVp3brI7i091GdNUFhQkAfMoOVB2dJ3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 04.02.2015 09:08, Hans Verkuil wrote:
> I remain very skeptical about the use of dma-contig (or dma-sg for that=

> matter). Have you tried using vmalloc and check if the USB core isn't
> automatically using DMA transfers for that?
>=20
> Basically I would like to see proof that vmalloc is not an option befor=
e
> allowing dma-contig (or dma-sg if you can figure out why that isn't
> working).
>=20
> You can also make a version with vmalloc and I'll merge that, and then
> you can look more into the DMA issues. That way the driver is merged,
> even if it is perhaps not yet optimal, and you can address that part la=
ter.
OK, that sounds sensible, I will try that route. When using
videobuf2-vmalloc, what do I pass back for alloc_ctxs in queue_setup?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--LtoVp3brI7i091GdNUFhQkAfMoOVB2dJ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTR75IACgkQ7CzyshGvatjYVwCfZ4ieGe97jqGjIM+hVdYriQd2
xCsAoPNwqbfdLiEf3RENdW6XqmSBRNu9
=jhpz
-----END PGP SIGNATURE-----

--LtoVp3brI7i091GdNUFhQkAfMoOVB2dJ3--
