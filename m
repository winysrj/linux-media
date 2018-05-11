Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37097 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750852AbeEKKUf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 06:20:35 -0400
Date: Fri, 11 May 2018 12:20:33 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florent Revest <florent.revest@free-electrons.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Randy Li <ayaka@soulik.info>
Subject: Re: [PATCH v3 02/14] drivers: soc: sunxi: Add dedicated compatibles
 for the A13, A20 and A33
Message-ID: <20180511102033.i6jtzljbvkg47wz3@flea>
References: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
 <20180507124500.20434-3-paul.kocialkowski@bootlin.com>
 <CAGb2v67An8RSCKEDSgW_jY7m8iw22K4rRHb02q67decmCBcjhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ropnmmpiqwyci4ux"
Content-Disposition: inline
In-Reply-To: <CAGb2v67An8RSCKEDSgW_jY7m8iw22K4rRHb02q67decmCBcjhg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ropnmmpiqwyci4ux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 10, 2018 at 10:05:33PM -0700, Chen-Yu Tsai wrote:
> On Mon, May 7, 2018 at 5:44 AM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > This introduces platform-specific compatibles for the A13, A20 and A33
> > SRAM driver. No particular adaptation for these platforms is required at
> > this point, although this might become the case in the future.
> >
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  drivers/soc/sunxi/sunxi_sram.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_s=
ram.c
> > index 74cb81f37bd6..43ebc3bd33f2 100644
> > --- a/drivers/soc/sunxi/sunxi_sram.c
> > +++ b/drivers/soc/sunxi/sunxi_sram.c
> > @@ -315,6 +315,9 @@ static int sunxi_sram_probe(struct platform_device =
*pdev)
> >
> >  static const struct of_device_id sunxi_sram_dt_match[] =3D {
> >         { .compatible =3D "allwinner,sun4i-a10-sram-controller" },
> > +       { .compatible =3D "allwinner,sun5i-a13-sram-controller" },
> > +       { .compatible =3D "allwinner,sun7i-a20-sram-controller" },
> > +       { .compatible =3D "allwinner,sun8i-a33-sram-controller" },
>=20
> We should probably name these "system-controller". Maxime?

This would make sense yes, but we don't really need to add the A20 one
to the driver, it's exactly the same than the A10.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--ropnmmpiqwyci4ux
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlr1bnAACgkQ0rTAlCFN
r3RGSxAAioGxVMYYKKP7EpsOvbcLiyJu90l6vMcfmB01xdWSxl+0TlQ713l3g6cU
gcFQgm6W5tdJ0i3ps84bGi3H6SqZJhc/S6so/zgS/sI9FNLSq5ztjLw0gAgaaJL5
/pc3Z5HR5hKKWZ3Knho1NG1GYnpTPR2YcN1Wa0GZfrgMgsZkeduW3iJTSC/wOnWF
8+c512DMqND1tq2TRgIAG99pisRh3mHFfKxaTOy7xI5eufZNSqn/an5Doz25wbIZ
HoE53kw1+ALSvxoQwHGtfbiyAf4GjK/qQygiFvb3veFYDyIQpq8FOYjjDbaE/LLr
KOIGIcHmPoQzo3o8CEupTW98volKFo33WY/Q/+FJn2RXoT8+ZCdObEIBJA3Za8+T
wEG5EfuKmw2zUSqiALZlDTz3W7gHYQKlOLmZRNje4TDoeNIOu63D/xTB+2OhRWix
bj7FOvRoO5n/ERwMNJgfZmic2xh7mBD2+x7vvYib2+cRguEl6bEqtpP5i4rcCKH3
l5gBKmS0+hr39Qasi5NbiRHK4IVceZ8WgVHLLUuhSQXRoGijZMZygiITE+Ql4wop
WR8yhAjwlIReRwkpDe46iU8ep51A0sTIyQ3zfGwv6pv+xLmW+lC7wdXIjKuU19DL
EB9+WAZc/J3M92BSw8KZ+SFWL35/orGB5s24sgKegg7GzMI8oR0=
=SzVX
-----END PGP SIGNATURE-----

--ropnmmpiqwyci4ux--
