Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55289 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbdFTI3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 04:29:36 -0400
Date: Tue, 20 Jun 2017 10:29:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Shawn Guo: your attetion is needed here Re: [PATCH v8 00/34] i.MX
 Media Driver
Message-ID: <20170620082933.GA31799@amd>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
 <e7e4669c-2963-b9e1-edd7-02731a6e0f9c@xs4all.nl>
 <c0b69c93-b9cd-25e8-ea36-fc0600efdb69@gmail.com>
 <e4f152de-6e75-7654-178e-e6dcf9ad12f3@xs4all.nl>
 <43887f25-bb73-9020-0909-d275c319aaad@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <43887f25-bb73-9020-0909-d275c319aaad@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> But as Pavel pointed out, in fact we are missing many
> >> Acks still, for all of the dts source changes (patches
> >> 4-14), as well as really everything else (imx-media staging
> >> driver patches).
> >=20
> > No Acks needed for the staging part. It's staging, so not held
> > to the same standards as non-staging parts. That doesn't mean
> > Acks aren't welcome, of course.
>=20
> Acks are wanted for particular i.MX DTS changes including device
> tree binding descriptions.
>=20
> Shawn, please bless the series.

Hmm. I changed the subject to grab Shawn's attetion.

But his acks should not be needed for forward progress. Yes, it would
be good, but he does not react -- so just reorder the series so that
dts changes come last, then apply the parts you can apply: driver can
go in.

And actually... if maintainer does not respond at all, there are ways
to deal with that, too...

Best regards,
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

iEYEARECAAYFAllI3OwACgkQMOfwapXb+vJsUwCeN0FaxtsVSviD6RVvAtcJrxe/
1e0An1zHdVdNIngiC+NTdrKsV/VOnJeu
=g3WY
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
