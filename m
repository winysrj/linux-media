Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56590 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZCVOfm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 10:35:42 -0400
Date: Sun, 22 Mar 2009 15:35:34 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Uri Shkolnik <uris@siano-ms.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for
 workarounds
Message-ID: <20090322153534.0c64de1e@mjolnir.ossman.eu>
In-Reply-To: <20090314074201.5c4a1ce1@pedra.chehab.org>
References: <20090314074201.5c4a1ce1@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-23395-1237732537-0001-2"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-23395-1237732537-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Mar 2009 07:42:01 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Pierre,
>=20
> Uri sent me this patchset, as part of the changes for supporting some dev=
ices
> from Siano.
>=20
> The changeset looks fine, although I have no experiences with MMC. Are you
> applying it on your tree, or do you prefer if I apply here?
>=20
> If you're applying on yours, this is my ack:
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>=20

This should probably go in your tree with the patch for the Siano SDIO
driver. The problem is that that driver isn't ready yet. I was going
to do a final cleanup once the USB separations patches were done, but
those never materialised.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-23395-1237732537-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknGTLkACgkQ7b8eESbyJLiQZACg5rh/2t12LqfQhqw2kBP22Izn
qwwAoN4AVXq4f2kRKZQmERte+W/PWnA4
=St19
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-23395-1237732537-0001-2--
