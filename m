Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49844 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdAPUO2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 15:14:28 -0500
Date: Mon, 16 Jan 2017 21:13:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 1/5] [media] ir-rx51: port to rc-core
Message-ID: <20170116201358.GA29381@amd>
References: <cover.1482255894.git.sean@mess.org>
 <f5262cc638a494f238ef96a80d8f45265ca2fd02.1482255894.git.sean@mess.org>
 <5878d916-6a60-d5c3-b912-948b5b970661@gmail.com>
 <20161230130752.GA7377@gofer.mess.org>
 <20161230133030.GA7861@gofer.mess.org>
 <1e4fa726-5dec-028e-9f0f-1c53d58df981@gmail.com>
 <20170116101053.GA24265@gofer.mess.org>
 <750f3570-8acb-1707-c929-421518a38516@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <750f3570-8acb-1707-c929-421518a38516@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On 16.01.2017 12:10, Sean Young wrote:
> >
> >Have you had a chance to test the ir-rx51 changes?
> >
> >Thanks
> >Sean
> >
>=20
> Still no, and afaik there are issues booting n900 with current kernel. Wi=
ll
> try to find time over the weekend.

v4.10-rc3 (?) works for me on n900. Do you want a working .config?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlh9KYYACgkQMOfwapXb+vK4jQCfeI1Yb8EzwHHS77S+ScDolZWU
JEoAn0DK30OfjTWqgWxGFq+mG1OT//Zc
=3RRi
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
