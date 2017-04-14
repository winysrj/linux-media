Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34023 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdDNUcV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 16:32:21 -0400
Date: Fri, 14 Apr 2017 22:32:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
Subject: Re: [PATCH v6 17/39] platform: add video-multiplexer subdevice driver
Message-ID: <20170414203216.GA10920@amd>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-18-git-send-email-steve_longerbeam@mentor.com>
 <20170404124732.GD3288@valkosipuli.retiisi.org.uk>
 <1492091578.2383.39.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <1492091578.2383.39.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > The MUX framework is already in linux-next. Could you use that instead =
of
> > adding new driver + bindings that are not compliant with the MUX framew=
ork?
> > I don't think it'd be much of a change in terms of code, using the MUX
> > framework appears quite simple.
>=20
> It is not quite clear to me how to design the DT bindings for this. Just
> splitting the video-multiplexer driver from the mux-mmio / mux-gpio
> would make it necessary to keep the video-multiplexer node to describe
> the of-graph bindings. But then we have two different nodes in the DT
> that describe the same hardware:
>=20
> 	mux: mux {
> 		compatible =3D "mux-gpio";
> 		mux-gpios =3D <&gpio 0>, <&gpio 1>;
> 		#mux-control-cells =3D <0>;
> 	}
>=20
> 	video-multiplexer {
> 		compatible =3D "video-multiplexer"
> 		mux-controls =3D <&mux>;
>=20
> 		ports {
> 			/* ... */
> 		}
> 	}
>=20
> It would feel more natural to have the ports in the mux node, but then
> how would the video-multiplexer driver be instanciated, and how would it
> get to the of-graph nodes?

Device tree representation and code used to implement the muxing
driver should be pretty independend, no? Yes, one piece of hardware
should have one entry in the device tree, so it should be something
like:


 	video-multiplexer {
 		compatible =3D "video-multiplexer-gpio"=09
 		mux-gpios =3D <&gpio 0>, <&gpio 1>;
 		#mux-control-cells =3D <0>;

 		mux-controls =3D <&mux>;
=20
 		ports {
 			/* ... */
 		}
 	}

You should be able to use code in drivers/mux as a library...

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljxMdAACgkQMOfwapXb+vLEHQCfWVAmS+aFu+FrMuB4vnHxF+Hg
RJ8AoJBhFp27Yf8CDq79Nr5TQe7qd1C2
=zNjt
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
