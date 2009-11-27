Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out01.alice.it ([85.33.2.12]:4141 "EHLO
	smtp-out01.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZK0Ocg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 09:32:36 -0500
Date: Fri, 27 Nov 2009 15:32:30 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 3/3] pxa_camera: remove init() callback
Message-Id: <20091127153230.d042d92e.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0911271503460.4383@axis700.grange>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
	<1258495463-26029-4-git-send-email-ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911271503460.4383@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_15_32_31_+0100_rBBhvABpLdlu4X.P"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__27_Nov_2009_15_32_31_+0100_rBBhvABpLdlu4X.P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Nov 2009 15:06:53 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Tue, 17 Nov 2009, Antonio Ospite wrote:
>=20
> > pxa_camera init() callback is sometimes abused to setup MFP for PXA CIF=
, or
> > even to request GPIOs to be used by the camera *sensor*. These initiali=
zations
> > can be performed statically in machine init functions.
> >=20
> > The current semantics for this init() callback is ambiguous anyways, it=
 is
> > invoked in pxa_camera_activate(), hence at device node open, but its us=
ers use
> > it like a generic initialization to be done at module init time (config=
ure
> > MFP, request GPIOs for *sensor* control).
> >=20
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>=20
> Antonio, to make the merging easier and avoid imposing extra dependencies=
,=20
> I would postpone this to 2.6.34, and just remove uses of .init() by=20
> pxa-camera users as per your other two patches. Would this be ok with you?
>=20
> Thanks
> Guennadi
>

Perfectly fine with me.

Feel also free to anticipate me and edit the commit messages to
whatever you want in the first two patches. Now that we aren't removing
init() immediately after these it makes even more sense to change the
phrasing from a future referencing
	"init() is going to be removed"
to a more present focused
	"better not to use init() at all"
form.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__27_Nov_2009_15_32_31_+0100_rBBhvABpLdlu4X.P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksP4v8ACgkQ5xr2akVTsAGwcACgpf38kvFrTR4CcqvG1hKhvHen
dSoAnR3aW4RBBoFOFCnUQjuX3SOHkEHs
=B+Dz
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_15_32_31_+0100_rBBhvABpLdlu4X.P--
