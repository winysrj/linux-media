Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:54085 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734AbaKULUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 06:20:14 -0500
Date: Fri, 21 Nov 2014 12:15:03 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/9] clk: sunxi: Give sunxi_factors_register a registers
 parameter
Message-ID: <20141121111503.GC4752@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-2-git-send-email-hdegoede@redhat.com>
 <20141121083555.GK24143@lukather>
 <546EFB83.1020806@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <546EFB83.1020806@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 09:44:51AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 11/21/2014 09:35 AM, Maxime Ripard wrote:
> > Hi Hans,
> >=20
> > On Thu, Nov 20, 2014 at 04:55:20PM +0100, Hans de Goede wrote:
> >> Before this commit sunxi_factors_register uses of_iomap(node, 0) to get
> >> the clk registers. The sun6i prcm has factor clocks, for which we want=
 to
> >> use sunxi_factors_register, but of_iomap(node, 0) does not work for th=
e prcm
> >> factor clocks, because the prcm uses the mfd framework, so the registe=
rs
> >> are not part of the dt-node, instead they are added to the platform_de=
vice,
> >> as platform_device resources.
> >>
> >> This commit makes getting the registers the callers duty, so that
> >> sunxi_factors_register can be used with mfd instantiated platform devi=
ce too.
> >>
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >=20
> > Funny, I was thinking of doing exactly the same thing for MMC clocks :)
> >=20
> >> ---
> >>  drivers/clk/sunxi/clk-factors.c    | 10 ++++------
> >>  drivers/clk/sunxi/clk-factors.h    |  7 ++++---
> >>  drivers/clk/sunxi/clk-mod0.c       |  6 ++++--
> >>  drivers/clk/sunxi/clk-sun8i-mbus.c |  2 +-
> >>  drivers/clk/sunxi/clk-sunxi.c      |  3 ++-
> >>  5 files changed, 15 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-f=
actors.c
> >> index f83ba09..fc4f4b5 100644
> >> --- a/drivers/clk/sunxi/clk-factors.c
> >> +++ b/drivers/clk/sunxi/clk-factors.c
> >> @@ -156,9 +156,10 @@ static const struct clk_ops clk_factors_ops =3D {
> >>  	.set_rate =3D clk_factors_set_rate,
> >>  };
> >> =20
> >> -struct clk * __init sunxi_factors_register(struct device_node *node,
> >> -					   const struct factors_data *data,
> >> -					   spinlock_t *lock)
> >> +struct clk *sunxi_factors_register(struct device_node *node,
> >> +				   const struct factors_data *data,
> >> +				   spinlock_t *lock,
> >> +				   void __iomem *reg)
> >>  {
> >>  	struct clk *clk;
> >>  	struct clk_factors *factors;
> >> @@ -168,11 +169,8 @@ struct clk * __init sunxi_factors_register(struct=
 device_node *node,
> >>  	struct clk_hw *mux_hw =3D NULL;
> >>  	const char *clk_name =3D node->name;
> >>  	const char *parents[FACTORS_MAX_PARENTS];
> >> -	void __iomem *reg;
> >>  	int i =3D 0;
> >> =20
> >> -	reg =3D of_iomap(node, 0);
> >> -
> >>  	/* if we have a mux, we will have >1 parents */
> >>  	while (i < FACTORS_MAX_PARENTS &&
> >>  	       (parents[i] =3D of_clk_get_parent_name(node, i)) !=3D NULL)
> >> diff --git a/drivers/clk/sunxi/clk-factors.h b/drivers/clk/sunxi/clk-f=
actors.h
> >> index 9913840..1f5526d 100644
> >> --- a/drivers/clk/sunxi/clk-factors.h
> >> +++ b/drivers/clk/sunxi/clk-factors.h
> >> @@ -37,8 +37,9 @@ struct clk_factors {
> >>  	spinlock_t *lock;
> >>  };
> >> =20
> >> -struct clk * __init sunxi_factors_register(struct device_node *node,
> >> -					   const struct factors_data *data,
> >> -					   spinlock_t *lock);
> >> +struct clk *sunxi_factors_register(struct device_node *node,
> >> +				   const struct factors_data *data,
> >> +				   spinlock_t *lock,
> >> +				   void __iomem *reg);
> >=20
> > Why are you dropping the __init there?
>=20
> Because it is going to be used from mfd instantiation, so from a platform=
_dev
> probe function which is not __init.

Ah right. Mentionning it in the commit log would be nice.

>=20
> >=20
> >> =20
> >>  #endif
> >> diff --git a/drivers/clk/sunxi/clk-mod0.c b/drivers/clk/sunxi/clk-mod0=
=2Ec
> >> index 4a56385..9530833 100644
> >> --- a/drivers/clk/sunxi/clk-mod0.c
> >> +++ b/drivers/clk/sunxi/clk-mod0.c
> >> @@ -78,7 +78,8 @@ static DEFINE_SPINLOCK(sun4i_a10_mod0_lock);
> >> =20
> >>  static void __init sun4i_a10_mod0_setup(struct device_node *node)
> >>  {
> >> -	sunxi_factors_register(node, &sun4i_a10_mod0_data, &sun4i_a10_mod0_l=
ock);
> >> +	sunxi_factors_register(node, &sun4i_a10_mod0_data,
> >> +			       &sun4i_a10_mod0_lock, of_iomap(node, 0));
> >=20
> > As of_iomap can fail, I'd rather check the returned value before
> > calling sunxi_factors_register.
> >=20
> > I know it wasn't done before, but it's the right thing to do, as it
> > would lead to an instant crash if that fails.
>=20
> Ok, I'll wait for you to review the rest of the series and then do a v2 o=
f the
> patch-set with this fixed (as time permits).

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbx63AAoJEBx+YmzsjxAg2t0QAIh0p4GIIzXPJn+kj3bV/H3F
MQFwPrCBl6/WsbHQDoLx6TwBKCpFrNRyB0LIrQ6GdV0KtH4/6rVfLR2u/W+DnNpu
4qJ9up3Xc9ZS3gYX+Zt1ZylxAPcXGgyzdN9S5X2VY9ypagGaWsR53DJIFuNxFnN/
bqP0GTQJCqI4POfmn8Gag5gXqVL20PlPcTDytlICv0UlloWdA0oNiyGlx5udTAyB
fV1Hop3MPfiX8WeXzErktMFeI0b9jX9LwB4JTYF/k3LySSOrtyZH46qbjYkt12BN
TgShnOqMi98UjiTWPICHxYrSOi+l+nOpi0VFo747yWAiF/jquEH+mS2AXu7sY+6D
f09UUpEjXh7PzIJyivvp9I4k0yUYiqby/b6dQVc3EgVvdw2hLrrWrsW0gEA6I0/J
Jjp5LKoL76V1CbKydDljZIDvIjUhAdz+YkYGQYZVly9o0ukaeSQFOb8KNlfexJxP
+QXlXltI2z+TZcqqGOkEAY2mRuZW038oHls90MMrFxJFWEEqDx7SrW4c0kAbtig0
ids5bEwbHhnkyntPpD5+UIA9QZzMKdA3onJp7Yf90hBCSu1QXsVBXh9VythxulRU
DZIkdTsUMYoHxLhdkfGQl8Yewxt7Eud66nJpL3fNSXQJ9nyy4j3MzSpih1wdPc0Y
1QPVhWca35KR7Mr6QPhf
=dVmB
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
