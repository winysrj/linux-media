Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54387 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbeFWV3F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 17:29:05 -0400
Date: Sat, 23 Jun 2018 23:29:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mario.Limonciello@dell.com, nicolas@ndufresne.ca,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        niklas.soderlund@ragnatech.se, jerry.w.hu@intel.com
Subject: Re: Software-only image processing for Intel "complex" cameras
Message-ID: <20180623212902.GA18976@amd>
References: <20180620203838.GA13372@amd>
 <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
 <20180620211144.GA16945@amd>
 <da642773adac42a6966b9716f0d53444@ausx13mpc120.AMER.DELL.COM>
 <20180622034946.2ae51f1e@vela.lan>
 <db8d91a47971417da424df7bf67a5cca@ausx13mpc120.AMER.DELL.COM>
 <20180622060850.3941d9a7@vela.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20180622060850.3941d9a7@vela.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > e. g. something like:
> > >=20
> > > 	board_vendor =3D dmi_get_system_info(DMI_BOARD_VENDOR);
> > > 	board_name =3D dmi_get_system_info(DMI_BOARD_NAME);
> > > 	board_version =3D dmi_get_system_info(DMI_BOARD_NAME);
> > > 	product_name =3D dmi_get_system_info(DMI_PRODUCT_NAME);
> > > 	product_version =3D dmi_get_system_info(DMI_PRODUCT_VERSION);
> > >=20
> > > 	sprintf(dev->cap, "%s:%s:%s:%s", board_vendor, board_name,
> > > board_version, product_name, product_version);
> > >=20
> > > (the real code should check if the values are filled, as not all BIOS=
 vendors use the
> > > same DMI fields)
> > >=20
> > > With that, the library can auto-adjust without needing to run anythin=
g as
> > > root.
> > >  =20
> > Well actually most of those fields you're interested in are already exp=
osed to userspace
> > through sysfs /sys/class/dmi/id/
> >=20
> > Can't the library just pull them from there?
>=20
> Good point. Yeah, the library could use them.

This could be done, but it would be better if libraries could query
neccessary information from v4l2 drivers.

If DMI was used, _library_ would need to know about new hardware,
which is  not desirable.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsuu54ACgkQMOfwapXb+vKSygCeOEObId7hQhN3xeDRNbrvc8Bu
6w8AnifAANVLAQsxx+iCyv3MAxt5KJV1
=wI9O
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
