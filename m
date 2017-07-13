Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33818 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdGMViI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 17:38:08 -0400
Date: Thu, 13 Jul 2017 23:38:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] OMAP3ISP CCP2 support
Message-ID: <20170713213805.GA1229@amd>
References: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
 <20170713211335.GA13502@amd>
 <20170713212651.so5aqqp5k325pb4w@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20170713212651.so5aqqp5k325pb4w@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-07-14 00:26:52, Sakari Ailus wrote:
> On Thu, Jul 13, 2017 at 11:13:35PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > I took the liberty of changing your patch a bit. I added another to e=
xtract
> > > the number of lanes from the endpoint instead as it's not really a pr=
operty
> > > of the PHY. (Not tested yet, will check with N9.)
> >=20
> > No problem.
> >=20
> > Notice that the 1/2 does not apply on top of ccp2 branch; my merge
> > resolution was this:
>=20
> The two patches are for the ccp2-prepare branches, not for ccp2; it's
> somewhat out of date right now and needs a rebase.

Yes, and 1/2 will need merge resolution when you do that. Fortunately
it is easy.

> The patches work fine on N9.

I was able to fix the userspace, and they work for me, too. For both:

Acked-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Pavel Machek <pavel@ucw.cz>

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlln6D0ACgkQMOfwapXb+vKSeQCdFISZCIiuZX3brp/wSNblVrOq
gHUAoIAQyFb2KVK092ntEDgu0lEZdO4e
=iUWI
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
