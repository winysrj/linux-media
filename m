Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52214 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756376AbdDRJFJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 05:05:09 -0400
Date: Tue, 18 Apr 2017 11:05:05 +0200
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
Message-ID: <20170418090505.GA25414@amd>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-18-git-send-email-steve_longerbeam@mentor.com>
 <20170404124732.GD3288@valkosipuli.retiisi.org.uk>
 <1492091578.2383.39.camel@pengutronix.de>
 <20170414203216.GA10920@amd>
 <1492502989.2432.23.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1492502989.2432.23.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> That self-referencing mux-controls property looks a bit superfluous:
>=20
> 	mux: video-multiplexer {
> 		mux-controls =3D <&mux>;
> 	};
>=20
> Other than that, I'm completely fine with splitting the compatible into
> something like video-mux-gpio and video-mux-mmio and reusing the
> mux-gpios property for video-mux-gpio.

Agreed, I overseen that.

> > You should be able to use code in drivers/mux as a library...
>=20
> This is a good idea in principle, but this requires some rework of the
> mux subsystem, and that subsystem hasn't even landed yet. For now I'd
> like to focus on getting the DT bindings right.
>=20
> I'd honestly prefer to not add this rework as a requirement for the i.MX
> media drivers to get into staging.

Hmm. staging/ normally accepts code with bigger design problems than
that.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj11sEACgkQMOfwapXb+vJbDwCgopEMFgzPpbEIC0BHU9TwyS1c
NWYAnjd4KGUl40C8oLHre+PEbMM25sc+
=pmAS
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
