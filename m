Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52816 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757320AbaKUIkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 03:40:14 -0500
Date: Fri, 21 Nov 2014 09:35:55 +0100
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
Message-ID: <20141121083555.GK24143@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-2-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KjSGHOmKKB2VUiQn"
Content-Disposition: inline
In-Reply-To: <1416498928-1300-2-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KjSGHOmKKB2VUiQn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Thu, Nov 20, 2014 at 04:55:20PM +0100, Hans de Goede wrote:
> Before this commit sunxi_factors_register uses of_iomap(node, 0) to get
> the clk registers. The sun6i prcm has factor clocks, for which we want to
> use sunxi_factors_register, but of_iomap(node, 0) does not work for the p=
rcm
> factor clocks, because the prcm uses the mfd framework, so the registers
> are not part of the dt-node, instead they are added to the platform_devic=
e,
> as platform_device resources.
>=20
> This commit makes getting the registers the callers duty, so that
> sunxi_factors_register can be used with mfd instantiated platform device =
too.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Funny, I was thinking of doing exactly the same thing for MMC clocks :)

> ---
>  drivers/clk/sunxi/clk-factors.c    | 10 ++++------
>  drivers/clk/sunxi/clk-factors.h    |  7 ++++---
>  drivers/clk/sunxi/clk-mod0.c       |  6 ++++--
>  drivers/clk/sunxi/clk-sun8i-mbus.c |  2 +-
>  drivers/clk/sunxi/clk-sunxi.c      |  3 ++-
>  5 files changed, 15 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-fact=
ors.c
> index f83ba09..fc4f4b5 100644
> --- a/drivers/clk/sunxi/clk-factors.c
> +++ b/drivers/clk/sunxi/clk-factors.c
> @@ -156,9 +156,10 @@ static const struct clk_ops clk_factors_ops =3D {
>  	.set_rate =3D clk_factors_set_rate,
>  };
> =20
> -struct clk * __init sunxi_factors_register(struct device_node *node,
> -					   const struct factors_data *data,
> -					   spinlock_t *lock)
> +struct clk *sunxi_factors_register(struct device_node *node,
> +				   const struct factors_data *data,
> +				   spinlock_t *lock,
> +				   void __iomem *reg)
>  {
>  	struct clk *clk;
>  	struct clk_factors *factors;
> @@ -168,11 +169,8 @@ struct clk * __init sunxi_factors_register(struct de=
vice_node *node,
>  	struct clk_hw *mux_hw =3D NULL;
>  	const char *clk_name =3D node->name;
>  	const char *parents[FACTORS_MAX_PARENTS];
> -	void __iomem *reg;
>  	int i =3D 0;
> =20
> -	reg =3D of_iomap(node, 0);
> -
>  	/* if we have a mux, we will have >1 parents */
>  	while (i < FACTORS_MAX_PARENTS &&
>  	       (parents[i] =3D of_clk_get_parent_name(node, i)) !=3D NULL)
> diff --git a/drivers/clk/sunxi/clk-factors.h b/drivers/clk/sunxi/clk-fact=
ors.h
> index 9913840..1f5526d 100644
> --- a/drivers/clk/sunxi/clk-factors.h
> +++ b/drivers/clk/sunxi/clk-factors.h
> @@ -37,8 +37,9 @@ struct clk_factors {
>  	spinlock_t *lock;
>  };
> =20
> -struct clk * __init sunxi_factors_register(struct device_node *node,
> -					   const struct factors_data *data,
> -					   spinlock_t *lock);
> +struct clk *sunxi_factors_register(struct device_node *node,
> +				   const struct factors_data *data,
> +				   spinlock_t *lock,
> +				   void __iomem *reg);

Why are you dropping the __init there?

> =20
>  #endif
> diff --git a/drivers/clk/sunxi/clk-mod0.c b/drivers/clk/sunxi/clk-mod0.c
> index 4a56385..9530833 100644
> --- a/drivers/clk/sunxi/clk-mod0.c
> +++ b/drivers/clk/sunxi/clk-mod0.c
> @@ -78,7 +78,8 @@ static DEFINE_SPINLOCK(sun4i_a10_mod0_lock);
> =20
>  static void __init sun4i_a10_mod0_setup(struct device_node *node)
>  {
> -	sunxi_factors_register(node, &sun4i_a10_mod0_data, &sun4i_a10_mod0_lock=
);
> +	sunxi_factors_register(node, &sun4i_a10_mod0_data,
> +			       &sun4i_a10_mod0_lock, of_iomap(node, 0));

As of_iomap can fail, I'd rather check the returned value before
calling sunxi_factors_register.

I know it wasn't done before, but it's the right thing to do, as it
would lead to an instant crash if that fails.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--KjSGHOmKKB2VUiQn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbvlrAAoJEBx+YmzsjxAggycQAK5zmjWkRP6ZhQWMJCTDroFC
B7FtShdKg4YdOS6m8ZCb/IV+astUyMHQsqMcs1BEyKGJcJOpkDR6S2cEZBhighE7
pIwPom3Vy6AHCGcXpgkRzyimtfXiwRvTAwFVeIAGvmkv0+kRsgl7bd5iv2o5ibTj
AKvzjGEL5tmV2CbfYlajTjbTeA9qMQ+TcMgzF0eTIzrejC2hs3wJXy3wCVwa3FdY
QKghYL8E9ztP5sgwiaBMR4izQ8M60KEBUFLsDqR/cw0qWBHF35sU1DoTZq3MQ5uK
Jj19HbqYv1+EUbNzM1z6EfFjFqiUVA/VaaBlL2b0NRyzkF1vceok6MGo/Op5DWwP
v+rMxEQxsxQJqk8sbIG4AftBcKSE41c9IkdSR4GUACHmDDETCmITS8ynltzOuSvL
oMvEUJjATSI8G9fe0Ni2i4JSc7fRQ+JgIk5pGrqTISOTPpnK5dCUHbM5/eqzmzac
hs+X0tnjjnTnxII1+RUe8z4mrQsZ9bbqDPB0OoNz2HW4IfZamNLEij/jjH0oVzyj
iJT/l7LBBmJdt7cQPy+2AL5CNSq7Q1wBE2uawn2OkENaNdhfwu0Lz7p+4b5xs4F+
WoT6M6PDSRrnkkyGnMXIBkqX+cSrNq77EemwMw0hTYknO4SJLukdDUIy+eo3jPM/
SKMDag7n7csPzMFimmMb
=iMgp
-----END PGP SIGNATURE-----

--KjSGHOmKKB2VUiQn--
