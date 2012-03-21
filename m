Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:52371 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760034Ab2CUUJr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 16:09:47 -0400
Date: Wed, 21 Mar 2012 21:09:36 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: gennarone@gmail.com
Cc: Hans-Frieder Vogt <hfvogt@gmx.net>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] Fitipower fc0011 driver
Message-ID: <20120321210936.546be51e@milhouse>
In-Reply-To: <4F6A2803.40208@gmail.com>
References: <20120321160237.02193470@milhouse>
	<20120321165645.37ea9246@milhouse>
	<4F6A2803.40208@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2ZwUHjRuRimvUej0r=YqIbs"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/2ZwUHjRuRimvUej0r=YqIbs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Mar 2012 20:12:03 +0100
Gianluca Gennari <gennarone@gmail.com> wrote:

> > +#if 0 //TODO 3.3
> > +	struct dtv_frontend_properties *p =3D &fe->dtv_property_cache;
> > +	u32 freq =3D p->frequency / 1000;
> > +	u32 delsys =3D p->delivery_system;
>=20
> The "delsys" variable is unused, you can delete it.

Thanks for your review. I fixed this.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/2ZwUHjRuRimvUej0r=YqIbs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPajWAAAoJEPUyvh2QjYsO+8sQALW4aJV1/rv8t8FYxhITacYC
n/dL6/ogoVXMjNbewDy18E+fegk7lU7O5NEEkxz9xvEh3DZyoF/mDcYdGRJBPC7b
W5Qsa6qDDnXYwvM+xY80wWFTnwuQ5dMeIvhDZRmoBCQv+oqBgadFpjQdcvvYh0+Y
y2oE8v2a6XNwnHMb+5V6o4bRgJ3W8X67/HY3xkfszxDwYhTq0nl6FhsHWN6pWN8X
O2sinA/wckarU/0wpfsG2A/hsfMvuPDFZuEnAW1DdskaexPgDKIK0J6wdDhVOEjq
+BGucvW4oDqklhRzG40mxXZiu83Oh2zelCdhjDciyS/+Wg1Ft0VI4xBGAMFE52rg
zunC0mNzNqcnM4jl2lGiNu/tofsZ/hzoSP16DuOgOhZ03aU/iaK6sF9codu6UCSK
uUy1XMM8ylZALIwQDaKTJXiMOqO5rz4EphNyZDkUlrsrDFG1d3ffV8Nb1ZX+Xuzw
RfoQmvCUdfSll9UGn7Y2wRwCgWK3dIV/3kmQp10mVR8fM3TTyktcNSJG0qKYhFdo
OC4CHfHJo++y9gxv75hgiuGWSOPehcyxZtN35DeQm1jk7VLCNuJlG2xZt08ONjXa
qkZ5t2WESCRHg1U9O+u4j0E0iu47UI8phMg1EejylsHXniF3YDfSuCetUDcKduj1
lMp5gN6QNR1YETrrhVlM
=rMEH
-----END PGP SIGNATURE-----

--Sig_/2ZwUHjRuRimvUej0r=YqIbs--
