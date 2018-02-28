Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57281 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751634AbeB1BmE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 20:42:04 -0500
Message-ID: <1519782112.2617.354.camel@decadent.org.uk>
Subject: Re: [PATCH for v3.16 00/14] v4l2-compat-ioctl32.c: remove
 set_fs(KERNEL_DS)
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>, stable@vger.kernel.org
Cc: linux-media@vger.kernel.org
Date: Wed, 28 Feb 2018 01:41:52 +0000
In-Reply-To: <20180214115938.28296-1-hverkuil@xs4all.nl>
References: <20180214115938.28296-1-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-WT/4z6RsoePt5F1bPV4b"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-WT/4z6RsoePt5F1bPV4b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-02-14 at 12:59 +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This patch series fixes a number of bugs and culminates in the removal
> of the set_fs(KERNEL_DS) call in v4l2-compat-ioctl32.c.
>=20
> This was tested with a VM running 3.16, the vivi driver (a poor substitut=
e for
> the much improved vivid driver that's available in later kernels, but it'=
s the
> best I had) since that emulates the more common V4L2 ioctls that need to =
pass
> through v4l2-compat-ioctl32.c) and the 32-bit v4l2-compliance + 32-bit v4=
l2-ctl
> utilities that together exercised the most common ioctls.
>=20
> Most of the v4l2-compat-ioctl32.c do cleanups and fix subtle issues that
> v4l2-compliance complained about. The purpose is to 1) make it easy to
> verify that the final patch didn't introduce errors by first eliminating
> errors caused by other known bugs, and 2) keep the final patch at least
> somewhat readable.
>=20
> While compiling the media drivers for 3.16 I also came across a bug
> introduced in the 3.16 stable series that caused a compile error in the
> adv7604 driver. That's fixed in the first patch. Call it a bonus patch :-=
)

Thanks, I've queued up all of these.  However, I rebased these on top
of some earlier fixes to v4l2-compat-ioctl32.c which you incorporated
into your backports.

Ben.

--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.


--=-WT/4z6RsoePt5F1bPV4b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlqWCOAACgkQ57/I7JWG
EQkwqRAAyNqypiE2mdXjUD5a8ptPuhqX/M+ijNxO637pghmttxkgTT2fU2xIjQn9
cXP2uLpy7Ge7KlQYdphimq48ibW25dZmLUQB3iCZZaYAlYDJmxqmb6jhgA/D+cGs
Pv0BYYedhG78mruysibntilTgnMKaWWniOJwcGIDvkiOytrA2aBshUEO9AJ7T1m4
fsxpkR0KPX1SlAt0+b3r+aA6AY8431dNGPpLOtOK6kfJpPHLN7tSEY5Ij6F9Cc8w
0uULls2xcNDehym8rbngaouooS4EWBzWwGEuO2JBxU655SJPWGV1s4RXc+CV1Coz
wccpQkpYH7FoqJqBoyNWAatdhc7hCJkLFznt8kYvxHcnbhrDtQu1jyO2btECB3Zb
JZgPyN96AKgeuvHsUbYI32ZNjTUXo33CV50X+F75i88D6m4PJyfBf6awI2t2TH+B
uUv2BSUhIuuR1KDNj8Yzn8DngW1laQ+Ozg8mVm+fyX44eD83Om6UhHhzUk54riU7
kefxpaAwiBrmp+V4e+7+Zs+4nCSPME0ysq8DRkka8djBuzhOjYQtm7BC/wlLnStz
jquTZ+QC0taIalbpLCJvzGEd6gf92oNrUbBx93V16TkDviwG1tHbrGtEQznfKxah
qSqYyE+6cSPXcQjrLYCvVyBIktC4aV63Lp/pplKubjFBcBzPUfc=
=pvvZ
-----END PGP SIGNATURE-----

--=-WT/4z6RsoePt5F1bPV4b--
