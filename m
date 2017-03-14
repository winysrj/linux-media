Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58750 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbdCNS0n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 14:26:43 -0400
Date: Tue, 14 Mar 2017 19:26:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
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
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170314182635.GA3744@amd>
References: <20170310130733.GU21222@n2100.armlinux.org.uk>
 <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
 <20170310140124.GV21222@n2100.armlinux.org.uk>
 <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
 <20170310125342.7f047acf@vento.lan>
 <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170311231456.GH21222@n2100.armlinux.org.uk>
 <20170312212904.GA7995@amd>
 <20170312193745.636df0bf@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20170312193745.636df0bf@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Mid-layer is difficult... there are _hundreds_ of possible
> > pipeline setups. If it should live in kernel or in userspace is a
> > question... but I don't think having it in kernel helps in any way.
>=20
> Mid-layer is difficult, because we either need to feed some
> library with knowledge for all kernel drivers or we need to improve
> the MC API to provide more details.
>=20
> For example, several drivers used to expose entities via the
> generic MEDIA_ENT_T_DEVNODE to represent entities of different
> types. See, for example, entities 1, 5 and 7 (and others) at:
>
> > https://mchehab.fedorapeople.org/mc-next-gen/igepv2_omap3isp.png

Well... we provide enough information, so that device-specific code
does not have to be in kernel.

There are few types of ENT_T_DEVNODE there. "ISP CCP2" does not really
provide any functionality to the user. It just has to be there,
because the pipeline needs to be connected. "ISP Preview" provides
format conversion. "ISP Resizer" provides rescaling.

I'm not sure if it ever makes sense to use "ISP Preview
output". Normally you take data for display from "ISP Resizer
output". (Would there be some power advantage from that?)

> A device-specific code could either be hardcoding the entity number
> or checking for the entity strings to add some logic to setup
> controls on those "unknown" entities, a generic app won't be able=20
> to do anything with them, as it doesn't know what function(s) such
> entity provide.

Generic app should know if it wants RGGB10 data, then it can use "ISP
CCDC output", or if it wants "cooked" data suitable for display, then
it wants to use "ISP Resizer output". Once application knows what
output it wants, there's just one path through the system. So being
able to tell the ENT_T_DEVNODEs apart does not seem to be critical.

OTOH, for useful camera application, different paths are needed at
different phases.
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

iEYEARECAAYFAljINdsACgkQMOfwapXb+vLsJgCfTHi3WWXopxgQDoVYKBFeNCsX
1pIAoJCLkkQ1XeTTlDPgVbzaLaRyJWY5
=pshM
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
