Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44511 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758195AbdLRJYt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 04:24:49 -0500
Date: Mon, 18 Dec 2017 10:24:37 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: wens@csie.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
Subject: Re: [linux-sunxi] [PATCH v3 2/3] dt-bindings: media: Add Allwinner
 V3s Camera Sensor Interface (CSI)
Message-ID: <20171218092437.ksczam5h7hirmpcv@flea.lan>
References: <1510558344-45402-1-git-send-email-yong.deng@magewell.com>
 <CAGb2v67JhMfba8Ao7WyrYikkxvTxX8WaBRqu3GkrhOCWndresg@mail.gmail.com>
 <20171218164921.227b82349c778283f5e5eba8@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ttyz7lvubhfzshpr"
Content-Disposition: inline
In-Reply-To: <20171218164921.227b82349c778283f5e5eba8@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ttyz7lvubhfzshpr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 18, 2017 at 04:49:21PM +0800, Yong wrote:
> > > +               compatible =3D "allwinner,sun8i-v3s-csi";
> > > +               reg =3D <0x01cb4000 0x1000>;
> > > +               interrupts =3D <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > > +               clocks =3D <&ccu CLK_BUS_CSI>,
> > > +                        <&ccu CLK_CSI1_SCLK>,
> >=20
> > CSI also has an MCLK. Do you need that one?
>=20
> MCLK is not needed if the front end is not a sensor (like adv7611).
> I will add it as an option.

I guess this should always be needed then. And the driver will make
the decision to enable it or not.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--ttyz7lvubhfzshpr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlo3iVIACgkQ0rTAlCFN
r3SxjQ//YcyVgwGuhYuFsoAlon6vOBQHpas5+2ahvwcZcwVy+G4pY/jNIu7HwT2r
jd8BViZaI3fS7M6BzZDsflnFHBdXD6qGjhOfmDAvPRq3wDReDX15xvxn2C1gStql
mob+nBCRD1P1FMluyEjJhh8V4R+9DihpxEAp/DkCL4sVnY71uglBrjzKssshO3lE
WLC9K1Vk2mjMoK8M3rJ6twVpa8oQHTlGzxdzFDJsFxLXa9gTN+qMpivvihWBcahx
CEqCZGM764sKvTrwvEzAcD5bs39JrdpiflXo1WbjMYOyitdSn6T4d41EeBwc8E60
rrZa+2l84jE1qIyZoznGM2YVAi3qwHqZXGbSDmAp8ZNiTHHjvza8CiKfeV075TWi
a37OM0nlksK0kMMdJK/6VvDHGjif6pUy1og7Ti8pxBoFWyml53djJVjZAAP7IpGL
85g0mRaoyo9pVtv+adgpOL1mavv29VX+4aVk54f+xNMDeaTNjSug4aW2yauA0Vix
XJZLmbS2GYQebVbtem/Om4ZW07+H8xZKCMmWAgIBDAerBbExcSKc1Yq6BtIsr7ZV
HrDHKQVKeDFHJqVi2vATnaTdX61lP/eE/t1KM16MRAPxfp7EawJsMSYtouOzm6XW
WAhH1gHpnjvsLlsYN7XH5jQD/SQynM6qa5w7tNf2ixA2stJoppM=
=24S6
-----END PGP SIGNATURE-----

--ttyz7lvubhfzshpr--
