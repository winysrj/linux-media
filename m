Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43961 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbeKUDW3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 22:22:29 -0500
Date: Tue, 20 Nov 2018 17:51:58 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Maxime Ripard <maxime.ripard@bootlin.com>
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
Message-ID: <20181120165158.GE28299@w540>
References: <20181113130325.28975-1-maxime.ripard@bootlin.com>
 <20181113130325.28975-2-maxime.ripard@bootlin.com>
 <20181114194847.GE19257@w540>
 <20181120094839.su7riqxbi576u5rd@flea>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="27ZtN5FSuKKSZcBU"
Content-Disposition: inline
In-Reply-To: <20181120094839.su7riqxbi576u5rd@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--27ZtN5FSuKKSZcBU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Maxime,

On Tue, Nov 20, 2018 at 10:48:39AM +0100, Maxime Ripard wrote:
> Hi Jacopo,
>
> On Wed, Nov 14, 2018 at 08:48:47PM +0100, jacopo mondi wrote:
> > On Tue, Nov 13, 2018 at 02:03:15PM +0100, Maxime Ripard wrote:
> > > The clock structure for the PCLK is quite obscure in the documentation, and
> > > was hardcoded through the bytes array of each and every mode.
> > >
> > > This is troublesome, since we cannot adjust it at runtime based on other
> > > parameters (such as the number of bytes per pixel), and we can't support
> > > either framerates that have not been used by the various vendors, since we
> > > don't have the needed initialization sequence.
> > >
> > > We can however understand how the clock tree works, and then implement some
> > > functions to derive the various parameters from a given rate. And now that
> > > those parameters are calculated at runtime, we can remove them from the
> > > initialization sequence.
> > >
> > > The modes also gained a new parameter which is the clock that they are
> > > running at, from the register writes they were doing, so for now the switch
> > > to the new algorithm should be transparent.
> > >
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >
> > As you've squashed in my MIPI CSI-2 fixes, do you think it is
> > appropriate adding my So-b tag here?
>
> Yeah, I'll add your co-developped-by tag as well, if that's ok.
>

Yeah, whatever works for you here... Thanks ;)

> > > +/*
> > > + * This is supposed to be ranging from 1 to 16, but the value is
> > > + * always set to either 1 or 2 in the vendor kernels.
> > > + */
> >
> > I forgot to fix this comment in my patches you squahed in here (the
> > value now ranges from 1 to 16
>
> Ok.
>
> > > +#define OV5640_SYSDIV_MIN	1
> > > +#define OV5640_SYSDIV_MAX	16
> > > +
> > > +/*
> > > + * This is supposed to be ranging from 1 to 16, but the value is always
> > > + * set to 2 in the vendor kernels.
> > > + */
> > > +#define OV5640_MIPI_DIV		2
> > > +
> > > +/*
> > > + * This is supposed to be ranging from 1 to 2, but the value is always
> > > + * set to 2 in the vendor kernels.
> > > + */
> > > +#define OV5640_PLL_ROOT_DIV			2
> > > +#define OV5640_PLL_CTRL3_PLL_ROOT_DIV_2		BIT(4)
> > > +
> > > +/*
> > > + * We only supports 8-bit formats at the moment
> > > + */
> > > +#define OV5640_BIT_DIV				2
> > > +#define OV5640_PLL_CTRL0_MIPI_MODE_8BIT		0x08
> > > +
> > > +/*
> > > + * This is supposed to be ranging from 1 to 8, but the value is always
> > > + * set to 2 in the vendor kernels.
> > > + */
> > > +#define OV5640_SCLK_ROOT_DIV	2
> > > +
> > > +/*
> > > + * This is hardcoded so that the consistency is maintained between SCLK and
> > > + * SCLK 2x.
> > > + */
> > > +#define OV5640_SCLK2X_ROOT_DIV (OV5640_SCLK_ROOT_DIV / 2)
> > > +
> > > +/*
> > > + * This is supposed to be ranging from 1 to 8, but the value is always
> > > + * set to 1 in the vendor kernels.
> > > + */
> > > +#define OV5640_PCLK_ROOT_DIV			1
> > > +#define OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS	0x00
> > > +
> > > +static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
> > > +					    u8 pll_prediv, u8 pll_mult,
> > > +					    u8 sysdiv)
> > > +{
> > > +	unsigned long sysclk = sensor->xclk_freq / pll_prediv * pll_mult;
> > > +
> > > +	/* PLL1 output cannot exceed 1GHz. */
> > > +	if (sysclk / 1000000 > 1000)
> > > +		return 0;
> > > +
> > > +	return sysclk / sysdiv;
> > > +}
> >
> > That's better, but Sam's version is even better. I plan to pick some
> > part of his patch and apply them on top of this (for this and a few
> > other things I'm pointing out a here below). How would you like to
> > have those updates? Incremental patches on top of this series once it
> > gets merged (and it can now be merged, since it works for both CSI-2
> > and DVP), or would you like to receive those patches, squash them in
> > and re-send?
>
> The first solution would be better, having to constantly piling up
> patches in a series is a very efficient way to not get anything
> merged.
>

I know -.-

Fine, I'll have some more patches for ov5640 for next cycle then :)
(For this and all other changes to the CSI-2 portion of this patch)

> > > +
> > > +static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> > > +					 unsigned long rate,
> > > +					 u8 *pll_prediv, u8 *pll_mult,
> > > +					 u8 *sysdiv)
> > > +{
> > > +	unsigned long best = ~0;
> > > +	u8 best_sysdiv = 1, best_mult = 1;
> > > +	u8 _sysdiv, _pll_mult;
> > > +
> > > +	for (_sysdiv = OV5640_SYSDIV_MIN;
> > > +	     _sysdiv <= OV5640_SYSDIV_MAX;
> > > +	     _sysdiv++) {
> > > +		for (_pll_mult = OV5640_PLL_MULT_MIN;
> > > +		     _pll_mult <= OV5640_PLL_MULT_MAX;
> > > +		     _pll_mult++) {
> > > +			unsigned long _rate;
> > > +
> > > +			/*
> > > +			 * The PLL multiplier cannot be odd if above
> > > +			 * 127.
> > > +			 */
> > > +			if (_pll_mult > 127 && (_pll_mult % 2))
> > > +				continue;
> > > +
> > > +			_rate = ov5640_compute_sys_clk(sensor,
> > > +						       OV5640_PLL_PREDIV,
> > > +						       _pll_mult, _sysdiv);
> > > +
> > > +			/*
> > > +			 * We have reached the maximum allowed PLL1 output,
> > > +			 * increase sysdiv.
> > > +			 */
> > > +			if (!rate)
> > > +				break;
> > > +
> > > +			/*
> > > +			 * Prefer rates above the expected clock rate than
> > > +			 * below, even if that means being less precise.
> > > +			 */
> > > +			if (_rate < rate)
> > > +				continue;
> > > +
> > > +			if (abs(rate - _rate) < abs(rate - best)) {
> > > +				best = _rate;
> > > +				best_sysdiv = _sysdiv;
> > > +				best_mult = _pll_mult;
> > > +			}
> > > +
> > > +			if (_rate == rate)
> > > +				goto out;
> > > +		}
> > > +	}
> > > +
> > > +out:
> > > +	*sysdiv = best_sysdiv;
> > > +	*pll_prediv = OV5640_PLL_PREDIV;
> > > +	*pll_mult = best_mult;
> > > +
> > > +	return best;
> > > +}
> > > +
> > > +/*
> > > + * ov5640_set_mipi_pclk() - Calculate the clock tree configuration values
> > > + *			    for the MIPI CSI-2 output.
> > > + *
> > > + * @rate: The requested bandwidth in bytes per second.
> > > + *	  It is calculated as: HTOT * VTOT * FPS * bpp
> > > + *
> >
> > Almost. This is actually the bandwidth per lane. My bad, I need to update
> > this whole comment block.
>
> Can you send a patch? I'll squash it in.
>

Ok, this one is 'easy', just have to re-write the comment block, can
be squashed in.

> > > + * This function use the requested bandwidth to calculate:
> > > + * - sample_rate = bandwidth / bpp;
> > > + * - mipi_clk = bandwidth / num_lanes / 2; ( / 2 for CSI-2 DDR)
> > > + *
> > > + * The bandwidth corresponds to the SYSCLK frequency generated by the
> > > + * PLL pre-divider, the PLL multiplier and the SYS divider (see the clock
> > > + * tree documented here above).
> > > + *
> > > + * From the SYSCLK frequency, the MIPI CSI-2 clock tree generates the
> > > + * pixel clock and the MIPI BIT clock as follows:
> > > + *
> > > + * MIPI_BIT_CLK = SYSCLK / MIPI_DIV / 2;
> > > + * PIXEL_CLK = SYSCLK / PLL_RDVI / BIT_DIVIDER / PCLK_DIV / MIPI_DIV
> > > + *
> > > + * with this fixed parameters:
> > > + * PLL_RDIV	= 2;
> > > + * BIT_DIVIDER	= 2; (MIPI_BIT_MODE == 8 ? 2 : 2,5);
> > > + * PCLK_DIV	= 1;
> > > + *
> > > + * With these values we have:
> > > + *
> > > + * pixel_clock = bandwidth / bpp
> > > + * 	       = bandwidth / 4 / MIPI_DIV;
> > > + *
> > > + * And so we can calculate MIPI_DIV as:
> > > + * MIPI_DIV = bpp / 4;
> > > + */
> > > +static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor,
> > > +				unsigned long rate)
> > > +{
> > > +	const struct ov5640_mode_info *mode = sensor->current_mode;
> > > +	u8 mipi_div = OV5640_MIPI_DIV;
> > > +	u8 prediv, mult, sysdiv;
> > > +	int ret;
> > > +
> > > +	/* FIXME:
> > > +	 * Practical experience shows we get a correct frame rate by
> > > +	 * halving the bandwidth rate by 2, to slow down SYSCLK frequency.
> > > +	 * Divide both SYSCLK and MIPI_DIV by two (with OV5640_MIPI_DIV
> > > +	 * currently fixed at value '2', while according to the above
> > > +	 * formula it should have been = bpp / 4 = 4).
> > > +	 *
> > > +	 * So that:
> > > +	 * pixel_clock = bandwidth / 2 / bpp
> > > +	 * 	       = bandwidth / 2 / 4 / MIPI_DIV;
> > > +	 * MIPI_DIV = bpp / 4 / 2;
> > > +	 */
> > > +	rate /= 2;
> > > +
> > > +	/* FIXME:
> > > +	 * High resolution modes (1280x720, 1920x1080) requires an higher
> > > +	 * clock speed. Half the MIPI_DIVIDER value to double the output
> > > +	 * pixel clock and MIPI_CLK speeds.
> > > +	 */
> > > +	if (mode->hact > 1024)
> > > +		mipi_div /= 2;
> >
> > Sam patches are better here. He found out the reason for this, as
> > 'high resolutions modes' use the scaler, and a ration between pixel
> > clock and scaler clock has to be respected. My patches you squahsed in
> > here use this rather sub-optimal "hact > 1024" check, I would rather use his
> > "does the mode use the scaler?" way instead. That's something else
> > that could be squashed in a forthcoming version, or fixed with
> > incremental patches.
> >
> > > +
> > > +	ov5640_calc_sys_clk(sensor, rate, &prediv, &mult, &sysdiv);
> > > +
> > > +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL0,
> > > +			     0x0f, OV5640_PLL_CTRL0_MIPI_MODE_8BIT);
> > > +
> > > +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> > > +			     0xff, sysdiv << 4 | mipi_div);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2, 0xff, mult);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
> > > +			     0x1f, OV5640_PLL_CTRL3_PLL_ROOT_DIV_2 | prediv);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER,
> > > +			      0x30, OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS);
> >
> > Again, there might be something to bring in from Sam patches here
> > (programming register 0x4837 with the pixel clock in particular).
> > Again, let me know how would you like to receive updates.
> >
> > > +}
> > > +
> > > +static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
> > > +				      unsigned long rate,
> > > +				      u8 *pll_prediv, u8 *pll_mult, u8 *sysdiv,
> > > +				      u8 *pll_rdiv, u8 *bit_div, u8 *pclk_div)
> > > +{
> > > +	unsigned long _rate = rate * OV5640_PLL_ROOT_DIV * OV5640_BIT_DIV *
> > > +				OV5640_PCLK_ROOT_DIV;
> > > +
> > > +	_rate = ov5640_calc_sys_clk(sensor, _rate, pll_prediv, pll_mult,
> > > +				    sysdiv);
> > > +	*pll_rdiv = OV5640_PLL_ROOT_DIV;
> > > +	*bit_div = OV5640_BIT_DIV;
> > > +	*pclk_div = OV5640_PCLK_ROOT_DIV;
> > > +
> > > +	return _rate / *pll_rdiv / *bit_div / *pclk_div;
> > > +}
> >
> > This function is now called from a single place, maybe you want to
> > remove it and inline its code.
>
> I still find it easier to understand, and the compiler will probbaly
> end up inlining it anyway.
>

Up to you, this is very minor stuff.

Thanks
   j
> Thanks!
> Maxime
>
>
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com



--27ZtN5FSuKKSZcBU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb9DuuAAoJEHI0Bo8WoVY84MMP/ioeLPx625gu/oYG1nNNA436
6PYsKwWh4GdnUSDkwn6KLJmtHMRPKjTU3nWPENbSDEUZdyN/Aiid459s3gRNXngP
RS2ijA4ffflIQMxmbUaKILckUPDwthqyFTddGcS4Mprjst0uc3PJ1/owmLlTFfcL
GZrk685L7dVPjUb6WeKSBGLVhPyyiFqPc/bjbEpHK5eUECGtms7eccKtNt97LGie
9wEQFduZFs+erLR+wU0N0pxP+hUlN8XmOIs7tFRjxRHz57z/mYjVVAAbp8e1YuaX
8OMTSU0wnzrj36S568HKEA+AJVpnldhGieS1NDARZ+Hmx7A9EFeUR8w3JKsvXL1m
AaErd5AKR/soBgtF4b2BoERzWdssnLtON8Z5+APZ1Xw8bHzJWQFLc1l5Z/XXWjLt
FGCY+GSTBVmRh86oCPyeIrdssX0+wPkIOUCtfZSS/0OxdE1F0Eiyq0I+bIGFrjaW
HaEWB8EVqzWnv7Sh3RiMXgtJ6DfBTMXlb0Tj3HXDj2WBsjciD8ZGaS/eWocAz+u6
7Q0ZSoqjclOOiTfC+vH1sedBHRyEheLTRPbPkXjn8Nu62Fiib4p13Ol2ek++Dfgk
zJQ5UovUIAmpBD0h39TmIa+XB+pQbNBmDGCvaqTXqh/5+KZKpdR9sO88+UU7nLD7
8jYp0hlWwQkQ3xbfNsjh
=dSNa
-----END PGP SIGNATURE-----

--27ZtN5FSuKKSZcBU--
