Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53090 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753452AbeBSTEq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 14:04:46 -0500
Date: Mon, 19 Feb 2018 20:04:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, pali.rohar@gmail.com,
        sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: next-20180219: camera problems on n900
Message-ID: <20180219181715.GA19366@amd>
References: <20171227210543.GA19719@amd>
 <20171227211718.favif66afztygfje@kekkonen.localdomain>
 <20171228202453.GA20142@amd>
 <20171229093855.hz44vpssb5mufzop@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline
In-Reply-To: <20171229093855.hz44vpssb5mufzop@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > In v4.14, back camera on N900 works. On v4.15-rc1.. it works for few
> > > > seconds, but then I get repeated oopses.
> > > >=20
> > > > On v4.15-rc0.5 (commit ed30b147e1f6e396e70a52dbb6c7d66befedd786),
> > > > camera does not start.	 =20
> > > >=20
> > > > Any ideas what might be wrong there?
> > >=20
> > > What kind of oopses do you get?
> >=20
> > Hmm. bisect pointed to commit that can't be responsible.... Ideas
> > welcome.
>=20
> Hi Pavel,
>=20
> I tested N9 and capture appears to be working from the CSI-2 receiver
> (media tree master, i.e. v4.15-rc3 now).
>=20
> Which pipeline did you use?

I tested next-20180219 and camera does not work there. It leads to
nasty oops. I tried to capture the oops with dmesg > file, and that
one oopsed, too. usb networking also has problems... fun.

Camera works ok in V4.16-rc1, but if I use the camera, next shutdown
will oops. I'll try to collect more data there, too.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqLH8oACgkQMOfwapXb+vKrMwCgvQzZUCCQd86YKbYEfqyLpZyt
0lwAoLJQMkFEUbNfoS3m7W8vc2dtCyWr
=M7hn
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
