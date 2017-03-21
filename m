Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51525 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756790AbdCULLJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 07:11:09 -0400
Date: Tue, 21 Mar 2017 12:11:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170321111104.GA22939@amd>
References: <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
 <20170310125342.7f047acf@vento.lan>
 <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
 <20170314004533.3b3cd44b@vento.lan>
 <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
 <20170317114203.GZ21222@n2100.armlinux.org.uk>
 <44161453-02f9-0019-3868-7501967a6a82@linux.intel.com>
 <20170317102410.18c966ae@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20170317102410.18c966ae@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Making use of the full potential of the hardware requires using a more
> > expressive interface.=20
>=20
> That's the core of the problem: most users don't need "full potential
> of the hardware". It is actually worse than that: several boards
> don't allow "full potential" of the SoC capabilities.

Well, in kernel we usually try to support "full hardware" potential.

And we are pretty sure users would like to take still photos, even if
common v4l2 applications can not do it.

> > That's what the kernel interface must provide. If
> > we decide to limit ourselves to a small sub-set of that potential on the
> > level of the kernel interface, we have made a wrong decision. It's as
> > simple as that. This is why the functionality (and which requires taking
> > a lot of policy decisions) belongs to the user space. We cannot have
> > multiple drivers providing multiple kernel interfaces for the same hard=
ware.
>=20
> I strongly disagree. Looking only at the hardware capabilities without
> having a solution to provide what the user wants is *wrong*.

Hardware manufacturers already did this kind of research for us. They
don't usually include features noone wants...

> Another case: the cx25821 hardware supports 12 video streams,=20
> consuming almost all available bandwidth of an ePCI bus. Each video=20
> stream connector can either be configured to be capture or output, in
> runtime. The hardware vendor chose to hardcode the driver to provide
> 8 inputs and 4 outputs. Their decision was based in the fact that
> the driver is already very complex, and it satisfies their customer's=20
> needs. The cost/efforts of make the driver to be reconfigured in
> runtime were too high for almost no benefit.

Well, it is okay to provide 'limited' driver -- there's possibility to
fix the driver. But IMO it is not okay to provide 'limited' kernel
interface -- because if you try to fix it, you'll suddenly have
regressions.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljRCkgACgkQMOfwapXb+vKizwCggX0/6rJpBlyJuPet4dFev351
N+wAn07A9DStt2j0i8snJ1LcFXd24fdY
=tE3k
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
