Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51574 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbeKTURF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:17:05 -0500
Date: Tue, 20 Nov 2018 10:48:39 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v5 01/11] media: ov5640: Adjust the clock based on the
 expected rate
Message-ID: <20181120094839.su7riqxbi576u5rd@flea>
References: <20181113130325.28975-1-maxime.ripard@bootlin.com>
 <20181113130325.28975-2-maxime.ripard@bootlin.com>
 <20181114194847.GE19257@w540>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5ufsny5gerj7lgdu"
Content-Disposition: inline
In-Reply-To: <20181114194847.GE19257@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5ufsny5gerj7lgdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jacopo,

On Wed, Nov 14, 2018 at 08:48:47PM +0100, jacopo mondi wrote:
> On Tue, Nov 13, 2018 at 02:03:15PM +0100, Maxime Ripard wrote:
> > The clock structure for the PCLK is quite obscure in the documentation,=
 and
> > was hardcoded through the bytes array of each and every mode.
> >
> > This is troublesome, since we cannot adjust it at runtime based on other
> > parameters (such as the number of bytes per pixel), and we can't support
> > either framerates that have not been used by the various vendors, since=
 we
> > don't have the needed initialization sequence.
> >
> > We can however understand how the clock tree works, and then implement =
some
> > functions to derive the various parameters from a given rate. And now t=
hat
> > those parameters are calculated at runtime, we can remove them from the
> > initialization sequence.
> >
> > The modes also gained a new parameter which is the clock that they are
> > running at, from the register writes they were doing, so for now the sw=
itch
> > to the new algorithm should be transparent.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>=20
> As you've squashed in my MIPI CSI-2 fixes, do you think it is
> appropriate adding my So-b tag here?

Yeah, I'll add your co-developped-by tag as well, if that's ok.

> > +/*
> > + * This is supposed to be ranging from 1 to 16, but the value is
> > + * always set to either 1 or 2 in the vendor kernels.
> > + */
>=20
> I forgot to fix this comment in my patches you squahed in here (the
> value now ranges from 1 to 16

Ok.

> > +#define OV5640_SYSDIV_MIN	1
> > +#define OV5640_SYSDIV_MAX	16
> > +
> > +/*
> > + * This is supposed to be ranging from 1 to 16, but the value is always
> > + * set to 2 in the vendor kernels.
> > + */
> > +#define OV5640_MIPI_DIV		2
> > +
> > +/*
> > + * This is supposed to be ranging from 1 to 2, but the value is always
> > + * set to 2 in the vendor kernels.
> > + */
> > +#define OV5640_PLL_ROOT_DIV			2
> > +#define OV5640_PLL_CTRL3_PLL_ROOT_DIV_2		BIT(4)
> > +
> > +/*
> > + * We only supports 8-bit formats at the moment
> > + */
> > +#define OV5640_BIT_DIV				2
> > +#define OV5640_PLL_CTRL0_MIPI_MODE_8BIT		0x08
> > +
> > +/*
> > + * This is supposed to be ranging from 1 to 8, but the value is always
> > + * set to 2 in the vendor kernels.
> > + */
> > +#define OV5640_SCLK_ROOT_DIV	2
> > +
> > +/*
> > + * This is hardcoded so that the consistency is maintained between SCL=
K and
> > + * SCLK 2x.
> > + */
> > +#define OV5640_SCLK2X_ROOT_DIV (OV5640_SCLK_ROOT_DIV / 2)
> > +
> > +/*
> > + * This is supposed to be ranging from 1 to 8, but the value is always
> > + * set to 1 in the vendor kernels.
> > + */
> > +#define OV5640_PCLK_ROOT_DIV			1
> > +#define OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS	0x00
> > +
> > +static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
> > +					    u8 pll_prediv, u8 pll_mult,
> > +					    u8 sysdiv)
> > +{
> > +	unsigned long sysclk =3D sensor->xclk_freq / pll_prediv * pll_mult;
> > +
> > +	/* PLL1 output cannot exceed 1GHz. */
> > +	if (sysclk / 1000000 > 1000)
> > +		return 0;
> > +
> > +	return sysclk / sysdiv;
> > +}
>=20
> That's better, but Sam's version is even better. I plan to pick some
> part of his patch and apply them on top of this (for this and a few
> other things I'm pointing out a here below). How would you like to
> have those updates? Incremental patches on top of this series once it
> gets merged (and it can now be merged, since it works for both CSI-2
> and DVP), or would you like to receive those patches, squash them in
> and re-send?

The first solution would be better, having to constantly piling up
patches in a series is a very efficient way to not get anything
merged.

> > +
> > +static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> > +					 unsigned long rate,
> > +					 u8 *pll_prediv, u8 *pll_mult,
> > +					 u8 *sysdiv)
> > +{
> > +	unsigned long best =3D ~0;
> > +	u8 best_sysdiv =3D 1, best_mult =3D 1;
> > +	u8 _sysdiv, _pll_mult;
> > +
> > +	for (_sysdiv =3D OV5640_SYSDIV_MIN;
> > +	     _sysdiv <=3D OV5640_SYSDIV_MAX;
> > +	     _sysdiv++) {
> > +		for (_pll_mult =3D OV5640_PLL_MULT_MIN;
> > +		     _pll_mult <=3D OV5640_PLL_MULT_MAX;
> > +		     _pll_mult++) {
> > +			unsigned long _rate;
> > +
> > +			/*
> > +			 * The PLL multiplier cannot be odd if above
> > +			 * 127.
> > +			 */
> > +			if (_pll_mult > 127 && (_pll_mult % 2))
> > +				continue;
> > +
> > +			_rate =3D ov5640_compute_sys_clk(sensor,
> > +						       OV5640_PLL_PREDIV,
> > +						       _pll_mult, _sysdiv);
> > +
> > +			/*
> > +			 * We have reached the maximum allowed PLL1 output,
> > +			 * increase sysdiv.
> > +			 */
> > +			if (!rate)
> > +				break;
> > +
> > +			/*
> > +			 * Prefer rates above the expected clock rate than
> > +			 * below, even if that means being less precise.
> > +			 */
> > +			if (_rate < rate)
> > +				continue;
> > +
> > +			if (abs(rate - _rate) < abs(rate - best)) {
> > +				best =3D _rate;
> > +				best_sysdiv =3D _sysdiv;
> > +				best_mult =3D _pll_mult;
> > +			}
> > +
> > +			if (_rate =3D=3D rate)
> > +				goto out;
> > +		}
> > +	}
> > +
> > +out:
> > +	*sysdiv =3D best_sysdiv;
> > +	*pll_prediv =3D OV5640_PLL_PREDIV;
> > +	*pll_mult =3D best_mult;
> > +
> > +	return best;
> > +}
> > +
> > +/*
> > + * ov5640_set_mipi_pclk() - Calculate the clock tree configuration val=
ues
> > + *			    for the MIPI CSI-2 output.
> > + *
> > + * @rate: The requested bandwidth in bytes per second.
> > + *	  It is calculated as: HTOT * VTOT * FPS * bpp
> > + *
>=20
> Almost. This is actually the bandwidth per lane. My bad, I need to update
> this whole comment block.

Can you send a patch? I'll squash it in.

> > + * This function use the requested bandwidth to calculate:
> > + * - sample_rate =3D bandwidth / bpp;
> > + * - mipi_clk =3D bandwidth / num_lanes / 2; ( / 2 for CSI-2 DDR)
> > + *
> > + * The bandwidth corresponds to the SYSCLK frequency generated by the
> > + * PLL pre-divider, the PLL multiplier and the SYS divider (see the cl=
ock
> > + * tree documented here above).
> > + *
> > + * From the SYSCLK frequency, the MIPI CSI-2 clock tree generates the
> > + * pixel clock and the MIPI BIT clock as follows:
> > + *
> > + * MIPI_BIT_CLK =3D SYSCLK / MIPI_DIV / 2;
> > + * PIXEL_CLK =3D SYSCLK / PLL_RDVI / BIT_DIVIDER / PCLK_DIV / MIPI_DIV
> > + *
> > + * with this fixed parameters:
> > + * PLL_RDIV	=3D 2;
> > + * BIT_DIVIDER	=3D 2; (MIPI_BIT_MODE =3D=3D 8 ? 2 : 2,5);
> > + * PCLK_DIV	=3D 1;
> > + *
> > + * With these values we have:
> > + *
> > + * pixel_clock =3D bandwidth / bpp
> > + * 	       =3D bandwidth / 4 / MIPI_DIV;
> > + *
> > + * And so we can calculate MIPI_DIV as:
> > + * MIPI_DIV =3D bpp / 4;
> > + */
> > +static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor,
> > +				unsigned long rate)
> > +{
> > +	const struct ov5640_mode_info *mode =3D sensor->current_mode;
> > +	u8 mipi_div =3D OV5640_MIPI_DIV;
> > +	u8 prediv, mult, sysdiv;
> > +	int ret;
> > +
> > +	/* FIXME:
> > +	 * Practical experience shows we get a correct frame rate by
> > +	 * halving the bandwidth rate by 2, to slow down SYSCLK frequency.
> > +	 * Divide both SYSCLK and MIPI_DIV by two (with OV5640_MIPI_DIV
> > +	 * currently fixed at value '2', while according to the above
> > +	 * formula it should have been =3D bpp / 4 =3D 4).
> > +	 *
> > +	 * So that:
> > +	 * pixel_clock =3D bandwidth / 2 / bpp
> > +	 * 	       =3D bandwidth / 2 / 4 / MIPI_DIV;
> > +	 * MIPI_DIV =3D bpp / 4 / 2;
> > +	 */
> > +	rate /=3D 2;
> > +
> > +	/* FIXME:
> > +	 * High resolution modes (1280x720, 1920x1080) requires an higher
> > +	 * clock speed. Half the MIPI_DIVIDER value to double the output
> > +	 * pixel clock and MIPI_CLK speeds.
> > +	 */
> > +	if (mode->hact > 1024)
> > +		mipi_div /=3D 2;
>=20
> Sam patches are better here. He found out the reason for this, as
> 'high resolutions modes' use the scaler, and a ration between pixel
> clock and scaler clock has to be respected. My patches you squahsed in
> here use this rather sub-optimal "hact > 1024" check, I would rather use =
his
> "does the mode use the scaler?" way instead. That's something else
> that could be squashed in a forthcoming version, or fixed with
> incremental patches.
>=20
> > +
> > +	ov5640_calc_sys_clk(sensor, rate, &prediv, &mult, &sysdiv);
> > +
> > +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL0,
> > +			     0x0f, OV5640_PLL_CTRL0_MIPI_MODE_8BIT);
> > +
> > +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> > +			     0xff, sysdiv << 4 | mipi_div);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2, 0xff, mult);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
> > +			     0x1f, OV5640_PLL_CTRL3_PLL_ROOT_DIV_2 | prediv);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER,
> > +			      0x30, OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS);
>=20
> Again, there might be something to bring in from Sam patches here
> (programming register 0x4837 with the pixel clock in particular).
> Again, let me know how would you like to receive updates.
>=20
> > +}
> > +
> > +static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
> > +				      unsigned long rate,
> > +				      u8 *pll_prediv, u8 *pll_mult, u8 *sysdiv,
> > +				      u8 *pll_rdiv, u8 *bit_div, u8 *pclk_div)
> > +{
> > +	unsigned long _rate =3D rate * OV5640_PLL_ROOT_DIV * OV5640_BIT_DIV *
> > +				OV5640_PCLK_ROOT_DIV;
> > +
> > +	_rate =3D ov5640_calc_sys_clk(sensor, _rate, pll_prediv, pll_mult,
> > +				    sysdiv);
> > +	*pll_rdiv =3D OV5640_PLL_ROOT_DIV;
> > +	*bit_div =3D OV5640_BIT_DIV;
> > +	*pclk_div =3D OV5640_PCLK_ROOT_DIV;
> > +
> > +	return _rate / *pll_rdiv / *bit_div / *pclk_div;
> > +}
>=20
> This function is now called from a single place, maybe you want to
> remove it and inline its code.

I still find it easier to understand, and the compiler will probbaly
end up inlining it anyway.

Thanks!
Maxime


--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--5ufsny5gerj7lgdu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW/PYdwAKCRDj7w1vZxhR
xVd7AP9F4DJqj6RaRN7WR3omoByxBwoRPHLUOpcfaoTx9lqzNgEAzOs0bweJOixP
dhfm52HkfZCReiEHZMGxaU/Toy7hGws=
=ZPb4
-----END PGP SIGNATURE-----

--5ufsny5gerj7lgdu--
