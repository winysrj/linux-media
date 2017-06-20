Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60587 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdFTMDG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 08:03:06 -0400
Date: Tue, 20 Jun 2017 14:03:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        sakari.ailus@linux.intel.com, Nick Dyer <nick@shmanahar.org>,
        songjun.wu@microchip.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        devel@driverdev.osuosl.org, markus.heiser@darmarit.de,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        shuah@kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, mchehab@kernel.org,
        bparrot@ti.com, "robh+dt@kernel.org" <robh+dt@kernel.org>,
        horms+renesas@verge.net.au, Tiffany Lin <tiffany.lin@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        niklas.soderlund+renesas@ragnatech.se,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jean-Christophe TROTIN <jean-christophe.trotin@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: Shawn Guo: your attetion is needed here Re: [PATCH v8 00/34]
 i.MX Media Driver
Message-ID: <20170620120302.GA12948@amd>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
 <e7e4669c-2963-b9e1-edd7-02731a6e0f9c@xs4all.nl>
 <c0b69c93-b9cd-25e8-ea36-fc0600efdb69@gmail.com>
 <e4f152de-6e75-7654-178e-e6dcf9ad12f3@xs4all.nl>
 <43887f25-bb73-9020-0909-d275c319aaad@mentor.com>
 <20170620082933.GA31799@amd>
 <CAOMZO5A_LjYzzDTG9KmEHxb2F0=1Pj2Wm8s5maKS8pxce-HX3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <CAOMZO5A_LjYzzDTG9KmEHxb2F0=1Pj2Wm8s5maKS8pxce-HX3A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-06-20 08:05:05, Fabio Estevam wrote:
> On Tue, Jun 20, 2017 at 5:29 AM, Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > Hmm. I changed the subject to grab Shawn's attetion.
> >
> > But his acks should not be needed for forward progress. Yes, it would
> > be good, but he does not react -- so just reorder the series so that
> > dts changes come last, then apply the parts you can apply: driver can
> > go in.
> >
> > And actually... if maintainer does not respond at all, there are ways
> > to deal with that, too...
>=20
> Shawn has already applied the dts part of the series and they show up
> in linux-next.

Aha, sorry about the noise. I see videomux parts being merged by
Mauro. Good :-).
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllJDvYACgkQMOfwapXb+vIMJwCeOO8NrCm0dwZEl20Frwwc7JQb
tXsAn2J65ZwNrU0Jg+qLr1nNVg59KNzr
=I8wH
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
