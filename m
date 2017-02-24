Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36749 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbdBXUJI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 15:09:08 -0500
Date: Fri, 24 Feb 2017 21:09:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 15/36] platform: add video-multiplexer subdevice driver
Message-ID: <20170224200902.GA19893@amd>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-16-git-send-email-steve_longerbeam@mentor.com>
 <20170219220237.GD32327@amd>
 <1487668265.2331.23.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <1487668265.2331.23.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Plus you might want to describe which port correspond to which gpio
> > state/bitfield values...
> >=20
> > > +struct vidsw {
> >=20
> > I knew it: it is secretely a switch! :-).
>=20
> This driver started as a two-input gpio controlled bus switch.
> I changed the name when adding support for bitfield controlled
> multiplexers with more than two inputs.

We had discussion with Sakari / Rob whether gpio controlled thing is a
switch or a multiplexer :-).

> > > +	if (!pad) {
> > > +		/* Mirror the input side on the output side */
> > > +		cfg->type =3D vidsw->endpoint[vidsw->active].bus_type;
> > > +		if (cfg->type =3D=3D V4L2_MBUS_PARALLEL ||
> > > +		    cfg->type =3D=3D V4L2_MBUS_BT656)
> > > +			cfg->flags =3D vidsw->endpoint[vidsw->active].bus.parallel.flags;
> > > +	}
> >=20
> > Will this need support for other V4L2_MBUS_ values?
>=20
> To support CSI-2 multiplexers, yes.

Can you stick switch () { .... default: dev_err() } there, to help
future hackers?

Thank,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliwkt4ACgkQMOfwapXb+vKKsACfZ9eYjIrasoIKOwHZgrqYjyBK
BmcAoIrG0v1R2XhXi2Ae1RakbdbSLZIn
=Mqf9
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
