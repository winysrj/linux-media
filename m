Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:60352 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbbBTVqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 16:46:08 -0500
Message-ID: <54E7AB1E.3000401@butterbrot.org>
Date: Fri, 20 Feb 2015 22:46:06 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: laurent.pinchart@ideasonboard.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl>
In-Reply-To: <54E1D71C.2000003@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="dt3S3316JM7ed6J72tBOcR52sXwKMqIXG"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dt3S3316JM7ed6J72tBOcR52sXwKMqIXG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 16.02.2015 12:40, Hans Verkuil wrote:
> On 02/11/2015 12:52 PM, Florian Echtler wrote:
>> does anyone have any suggestions why USERPTR still fails with dma-sg?
>>
>> Could I just disable the corresponding capability for the moment so th=
at
>> the patch could perhaps be merged, and investigate this separately?
>=20
> I prefer to dig into this a little bit more, as I don't really understa=
nd
> it. Set the videobuf2-core debug level to 1 and see what the warnings a=
re.
>=20
> Since 'buf.qbuf' fails in v4l2-compliance, it's something in the VIDIOC=
_QBUF
> sequence that returns an error, so you need to pinpoint that.
OK, I don't currently have access to the hardware, but I will try this
as soon as possible.

> If push comes to shove I can also merge the patch without USERPTR suppo=
rt,
> but I really prefer not to do that.
How long until the next merge window closes?

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--dt3S3316JM7ed6J72tBOcR52sXwKMqIXG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTnqx4ACgkQ7CzyshGvathpAgCfWI++UdZUS9VFmEEBiclpEUkL
Ph4An1LGTGQcYHBlmDqbJIRVbC9MMkvo
=Kex2
-----END PGP SIGNATURE-----

--dt3S3316JM7ed6J72tBOcR52sXwKMqIXG--
