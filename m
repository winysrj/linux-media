Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46045 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbZCYTlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 15:41:23 -0400
Date: Wed, 25 Mar 2009 20:41:15 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: Uri Shkolnik <uris@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for
 workarounds
Message-ID: <20090325204115.550a58b9@mjolnir.ossman.eu>
In-Reply-To: <82346.5913.qm@web110807.mail.gq1.yahoo.com>
References: <82346.5913.qm@web110807.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-30585-1238010076-0001-2"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-30585-1238010076-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2009 01:43:48 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

>=20
> Hi Pierre,
>=20
> The SDIO patches are part of (at least) dozen patches needed to upgrade t=
he Siano's offering for Linux kernel.
>=20
> The order is -
> 1) SDIO SMS interface driver and SDIO stack patch (add)
> 2) SPI interface driver (add)
> 3) USB interface driver (modify)
> 4) IR port (add)
> 5) USB v3 (modify)
> 6-15(?) ) "Core" and "Cards" modifications
>=20

I'm not sure where the separation comes in here. So far the driver has
had a common entrypoint that calls all the different interface specific
startup routines.

>=20
> The order of the patches places the SDIO among the first to be submitted =
for review (interface drivers must be patched before the "core", in order t=
o make the various commits pass bisect tests).
>=20

I take it you're referring to your internal repo? Mainline only
contains the USB interface so splitting that up into a core and
interface driver shouldn't cause any bisect problems.

> I suggest that we'll continue the submission, and I'll cc you on ALL subm=
issions. You will be able to review, and either ask for modification and/or=
 suggest your on supplementary patches at any stage.=20
>=20

I'd prefer to not build a huge monolith just to later take it apart,
but I can live with it.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-30585-1238010076-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknKiN0ACgkQ7b8eESbyJLh+VgCggwPexT++ScwWHQtIn4M/vCa9
ZSUAnRVBJ7UjRLw3qjB+cks4vfi0e/33
=VhJm
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-30585-1238010076-0001-2--
