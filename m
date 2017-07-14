Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42757 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbdGNG4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 02:56:14 -0400
Date: Fri, 14 Jul 2017 08:56:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] OMAP3ISP CCP2 support
Message-ID: <20170714065611.GA14652@amd>
References: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
 <20170713211335.GA13502@amd>
 <20170713212651.so5aqqp5k325pb4w@valkosipuli.retiisi.org.uk>
 <20170713213805.GA1229@amd>
 <20170713220947.ntfpwkoitfadshnt@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20170713220947.ntfpwkoitfadshnt@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > The patches work fine on N9.
> >=20
> > I was able to fix the userspace, and they work for me, too. For both:
> >=20
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Tested-by: Pavel Machek <pavel@ucw.cz>
>=20
> Thanks! I've applied these on ccp2-prepare. ccp2 branch is rebased, too.

Thanks!

I rebased my patches on top of it, and pushed result to camera-fw6-2
branch.

Can you drop this patch from ccp2 branch?

https://git.linuxtv.org/sailus/media_tree.git/commit/?h=3Dccp2&id=3D27be6eb=
1f66389632a5d9dbaf0426a83f1b99b54

It is preparation for subdevices support on isp; but those will not be
needed there as we decided to move subdevices to et8ek8.

Thanks and best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlloawsACgkQMOfwapXb+vIVhACfUZDgebo3URXJTIPju2bMBXUT
dXEAn2wHJTSvd4ZWr7Bc0kt+CmUcf7KT
=GAlr
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
