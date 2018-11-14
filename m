Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:42173 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725756AbeKOFxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 00:53:34 -0500
Date: Wed, 14 Nov 2018 20:48:47 +0100
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
Message-ID: <20181114194847.GE19257@w540>
References: <20181113130325.28975-1-maxime.ripard@bootlin.com>
 <20181113130325.28975-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HnQK338I3UIa/qiP"
Content-Disposition: inline
In-Reply-To: <20181113130325.28975-2-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HnQK338I3UIa/qiP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Maxime,
   many thanks for re-sending this updated version

On Tue, Nov 13, 2018 at 02:03:15PM +0100, Maxime Ripard wrote:
> The clock structure for the PCLK is quite obscure in the documentation, and
> was hardcoded through the bytes array of each and every mode.
>
> This is troublesome, since we cannot adjust it at runtime based on other
> parameters (such as the number of bytes per pixel), and we can't support
> either framerates that have not been used by the various vendors, since we
> don't have the needed initialization sequence.
>
> We can however understand how the clock tree works, and then implement some
> functions to derive the various parameters from a given rate. And now that
> those parameters are calculated at runtime, we can remove them from the
> initialization sequence.
>
> The modes also gained a new parameter which is the clock that they are
> running at, from the register writes they were doing, so for now the switch
> to the new algorithm should be transparent.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

As you've squashed in my MIPI CSI-2 fixes, do you think it is
appropriate adding my So-b tag here?

> ---
>  drivers/media/i2c/ov5640.c | 366 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 365 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index eaefdb58653b..8476f85bb8e7 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -175,6 +175,7 @@ struct ov5640_mode_info {
>  	u32 htot;
>  	u32 vact;
>  	u32 vtot;
> +	u32 pixel_clock;
>  	const struct reg_value *reg_data;
>  	u32 reg_data_size;
>  };
> @@ -700,6 +701,7 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
>  /* power-on sensor init reg table */
>  static const struct ov5640_mode_info ov5640_mode_init_data = {
>  	0, SUBSAMPLING, 640, 1896, 480, 984,
> +	56000000,
>  	ov5640_init_setting_30fps_VGA,
>  	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
>  };
> @@ -709,74 +711,91 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
>  	{
>  		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
>  		 176, 1896, 144, 984,
> +		 28000000,
>  		 ov5640_setting_15fps_QCIF_176_144,
>  		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
>  		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
>  		 320, 1896, 240, 984,
> +		 28000000,
>  		 ov5640_setting_15fps_QVGA_320_240,
>  		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
>  		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
>  		 640, 1896, 480, 1080,
> +		 28000000,
>  		 ov5640_setting_15fps_VGA_640_480,
>  		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
>  		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
>  		 720, 1896, 480, 984,
> +		 28000000,
>  		 ov5640_setting_15fps_NTSC_720_480,
>  		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
>  		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
>  		 720, 1896, 576, 984,
> +		 28000000,
>  		 ov5640_setting_15fps_PAL_720_576,
>  		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
>  		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
>  		 1024, 1896, 768, 1080,
> +		 28000000,
>  		 ov5640_setting_15fps_XGA_1024_768,
>  		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
>  		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
>  		 1280, 1892, 720, 740,
> +		 21000000,
>  		 ov5640_setting_15fps_720P_1280_720,
>  		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
>  		{OV5640_MODE_1080P_1920_1080, SCALING,
>  		 1920, 2500, 1080, 1120,
> +		 42000000,
>  		 ov5640_setting_15fps_1080P_1920_1080,
>  		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
>  		{OV5640_MODE_QSXGA_2592_1944, SCALING,
>  		 2592, 2844, 1944, 1968,
> +		 84000000,
>  		 ov5640_setting_15fps_QSXGA_2592_1944,
>  		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
>  	}, {
>  		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
>  		 176, 1896, 144, 984,
> +		 56000000,
>  		 ov5640_setting_30fps_QCIF_176_144,
>  		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
>  		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
>  		 320, 1896, 240, 984,
> +		 56000000,
>  		 ov5640_setting_30fps_QVGA_320_240,
>  		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
>  		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
>  		 640, 1896, 480, 1080,
> +		 56000000,
>  		 ov5640_setting_30fps_VGA_640_480,
>  		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
>  		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
>  		 720, 1896, 480, 984,
> +		 56000000,
>  		 ov5640_setting_30fps_NTSC_720_480,
>  		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
>  		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
>  		 720, 1896, 576, 984,
> +		 56000000,
>  		 ov5640_setting_30fps_PAL_720_576,
>  		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
>  		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
>  		 1024, 1896, 768, 1080,
> +		 56000000,
>  		 ov5640_setting_30fps_XGA_1024_768,
>  		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
>  		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
>  		 1280, 1892, 720, 740,
> +		 42000000,
>  		 ov5640_setting_30fps_720P_1280_720,
>  		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
>  		{OV5640_MODE_1080P_1920_1080, SCALING,
>  		 1920, 2500, 1080, 1120,
> +		 84000000,
>  		 ov5640_setting_30fps_1080P_1920_1080,
>  		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
> -		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
> +		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, 0, NULL, 0},
>  	},
>  };
>
> @@ -909,6 +928,334 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
>  	return ov5640_write_reg(sensor, reg, val);
>  }
>
> +/*
> + * After trying the various combinations, reading various
> + * documentations spreaded around the net, and from the various
> + * feedback, the clock tree is probably as follows:
> + *
> + *   +--------------+
> + *   |  Ext. Clock  |
> + *   +-+------------+
> + *     |  +----------+
> + *     +->|   PLL1   | - reg 0x3036, for the multiplier
> + *        +-+--------+ - reg 0x3037, bits 0-3 for the pre-divider
> + *          |  +--------------+
> + *          +->| System Clock |  - reg 0x3035, bits 4-7
> + *             +-+------------+
> + *               |  +--------------+
> + *               +->| MIPI Divider | - reg 0x3035, bits 0-3
> + *               |  +-+------------+
> + *               |    +----------------> MIPI SCLK
> + *               |    +  +-----+
> + *               |    +->| / 2 |-------> MIPI BIT CLK
> + *               |       +-----+
> + *               |  +--------------+
> + *               +->| PLL Root Div | - reg 0x3037, bit 4
> + *                  +-+------------+
> + *                    |  +---------+
> + *                    +->| Bit Div | - reg 0x3035, bits 0-3
> + *                       +-+-------+
> + *                         |  +-------------+
> + *                         +->| SCLK Div    | - reg 0x3108, bits 0-1
> + *                         |  +-+-----------+
> + *                         |    +---------------> SCLK
> + *                         |  +-------------+
> + *                         +->| SCLK 2X Div | - reg 0x3108, bits 2-3
> + *                         |  +-+-----------+
> + *                         |    +---------------> SCLK 2X
> + *                         |  +-------------+
> + *                         +->| PCLK Div    | - reg 0x3108, bits 4-5
> + *                            +-+-----------+
> + *                              +---------------> PCLK
> + *
> + * This is deviating from the datasheet at least for the register
> + * 0x3108, since it's said here that the PCLK would be clocked from
> + * the PLL.
> + *
> + * There seems to be also (unverified) constraints:
> + *  - the PLL pre-divider output rate should be in the 4-27MHz range
> + *  - the PLL multiplier output rate should be in the 500-1000MHz range
> + *  - PCLK >= SCLK * 2 in YUV, >= SCLK in Raw or JPEG
> + *  - MIPI SCLK = (bpp / lanes) / PCLK
> + *
> + * In the two latter cases, these constraints are met since our
> + * factors are hardcoded. If we were to change that, we would need to
> + * take this into account. The only varying parts are the PLL
> + * multiplier and the system clock divider, which are shared between
> + * all these clocks so won't cause any issue.
> + */
> +
> +/*
> + * This is supposed to be ranging from 1 to 8, but the value is always
> + * set to 3 in the vendor kernels.
> + */
> +#define OV5640_PLL_PREDIV	3
> +
> +#define OV5640_PLL_MULT_MIN	4
> +#define OV5640_PLL_MULT_MAX	252
> +
> +/*
> + * This is supposed to be ranging from 1 to 16, but the value is
> + * always set to either 1 or 2 in the vendor kernels.
> + */

I forgot to fix this comment in my patches you squahed in here (the
value now ranges from 1 to 16)

> +#define OV5640_SYSDIV_MIN	1
> +#define OV5640_SYSDIV_MAX	16
> +
> +/*
> + * This is supposed to be ranging from 1 to 16, but the value is always
> + * set to 2 in the vendor kernels.
> + */
> +#define OV5640_MIPI_DIV		2
> +
> +/*
> + * This is supposed to be ranging from 1 to 2, but the value is always
> + * set to 2 in the vendor kernels.
> + */
> +#define OV5640_PLL_ROOT_DIV			2
> +#define OV5640_PLL_CTRL3_PLL_ROOT_DIV_2		BIT(4)
> +
> +/*
> + * We only supports 8-bit formats at the moment
> + */
> +#define OV5640_BIT_DIV				2
> +#define OV5640_PLL_CTRL0_MIPI_MODE_8BIT		0x08
> +
> +/*
> + * This is supposed to be ranging from 1 to 8, but the value is always
> + * set to 2 in the vendor kernels.
> + */
> +#define OV5640_SCLK_ROOT_DIV	2
> +
> +/*
> + * This is hardcoded so that the consistency is maintained between SCLK and
> + * SCLK 2x.
> + */
> +#define OV5640_SCLK2X_ROOT_DIV (OV5640_SCLK_ROOT_DIV / 2)
> +
> +/*
> + * This is supposed to be ranging from 1 to 8, but the value is always
> + * set to 1 in the vendor kernels.
> + */
> +#define OV5640_PCLK_ROOT_DIV			1
> +#define OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS	0x00
> +
> +static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
> +					    u8 pll_prediv, u8 pll_mult,
> +					    u8 sysdiv)
> +{
> +	unsigned long sysclk = sensor->xclk_freq / pll_prediv * pll_mult;
> +
> +	/* PLL1 output cannot exceed 1GHz. */
> +	if (sysclk / 1000000 > 1000)
> +		return 0;
> +
> +	return sysclk / sysdiv;
> +}

That's better, but Sam's version is even better. I plan to pick some
part of his patch and apply them on top of this (for this and a few
other things I'm pointing out a here below). How would you like to
have those updates? Incremental patches on top of this series once it
gets merged (and it can now be merged, since it works for both CSI-2
and DVP), or would you like to receive those patches, squash them in
and re-send?

> +
> +static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> +					 unsigned long rate,
> +					 u8 *pll_prediv, u8 *pll_mult,
> +					 u8 *sysdiv)
> +{
> +	unsigned long best = ~0;
> +	u8 best_sysdiv = 1, best_mult = 1;
> +	u8 _sysdiv, _pll_mult;
> +
> +	for (_sysdiv = OV5640_SYSDIV_MIN;
> +	     _sysdiv <= OV5640_SYSDIV_MAX;
> +	     _sysdiv++) {
> +		for (_pll_mult = OV5640_PLL_MULT_MIN;
> +		     _pll_mult <= OV5640_PLL_MULT_MAX;
> +		     _pll_mult++) {
> +			unsigned long _rate;
> +
> +			/*
> +			 * The PLL multiplier cannot be odd if above
> +			 * 127.
> +			 */
> +			if (_pll_mult > 127 && (_pll_mult % 2))
> +				continue;
> +
> +			_rate = ov5640_compute_sys_clk(sensor,
> +						       OV5640_PLL_PREDIV,
> +						       _pll_mult, _sysdiv);
> +
> +			/*
> +			 * We have reached the maximum allowed PLL1 output,
> +			 * increase sysdiv.
> +			 */
> +			if (!rate)
> +				break;
> +
> +			/*
> +			 * Prefer rates above the expected clock rate than
> +			 * below, even if that means being less precise.
> +			 */
> +			if (_rate < rate)
> +				continue;
> +
> +			if (abs(rate - _rate) < abs(rate - best)) {
> +				best = _rate;
> +				best_sysdiv = _sysdiv;
> +				best_mult = _pll_mult;
> +			}
> +
> +			if (_rate == rate)
> +				goto out;
> +		}
> +	}
> +
> +out:
> +	*sysdiv = best_sysdiv;
> +	*pll_prediv = OV5640_PLL_PREDIV;
> +	*pll_mult = best_mult;
> +
> +	return best;
> +}
> +
> +/*
> + * ov5640_set_mipi_pclk() - Calculate the clock tree configuration values
> + *			    for the MIPI CSI-2 output.
> + *
> + * @rate: The requested bandwidth in bytes per second.
> + *	  It is calculated as: HTOT * VTOT * FPS * bpp
> + *

Almost. This is actually the bandwidth per lane. My bad, I need to update
this whole comment block.

> + * This function use the requested bandwidth to calculate:
> + * - sample_rate = bandwidth / bpp;
> + * - mipi_clk = bandwidth / num_lanes / 2; ( / 2 for CSI-2 DDR)
> + *
> + * The bandwidth corresponds to the SYSCLK frequency generated by the
> + * PLL pre-divider, the PLL multiplier and the SYS divider (see the clock
> + * tree documented here above).
> + *
> + * From the SYSCLK frequency, the MIPI CSI-2 clock tree generates the
> + * pixel clock and the MIPI BIT clock as follows:
> + *
> + * MIPI_BIT_CLK = SYSCLK / MIPI_DIV / 2;
> + * PIXEL_CLK = SYSCLK / PLL_RDVI / BIT_DIVIDER / PCLK_DIV / MIPI_DIV
> + *
> + * with this fixed parameters:
> + * PLL_RDIV	= 2;
> + * BIT_DIVIDER	= 2; (MIPI_BIT_MODE == 8 ? 2 : 2,5);
> + * PCLK_DIV	= 1;
> + *
> + * With these values we have:
> + *
> + * pixel_clock = bandwidth / bpp
> + * 	       = bandwidth / 4 / MIPI_DIV;
> + *
> + * And so we can calculate MIPI_DIV as:
> + * MIPI_DIV = bpp / 4;
> + */
> +static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor,
> +				unsigned long rate)
> +{
> +	const struct ov5640_mode_info *mode = sensor->current_mode;
> +	u8 mipi_div = OV5640_MIPI_DIV;
> +	u8 prediv, mult, sysdiv;
> +	int ret;
> +
> +	/* FIXME:
> +	 * Practical experience shows we get a correct frame rate by
> +	 * halving the bandwidth rate by 2, to slow down SYSCLK frequency.
> +	 * Divide both SYSCLK and MIPI_DIV by two (with OV5640_MIPI_DIV
> +	 * currently fixed at value '2', while according to the above
> +	 * formula it should have been = bpp / 4 = 4).
> +	 *
> +	 * So that:
> +	 * pixel_clock = bandwidth / 2 / bpp
> +	 * 	       = bandwidth / 2 / 4 / MIPI_DIV;
> +	 * MIPI_DIV = bpp / 4 / 2;
> +	 */
> +	rate /= 2;
> +
> +	/* FIXME:
> +	 * High resolution modes (1280x720, 1920x1080) requires an higher
> +	 * clock speed. Half the MIPI_DIVIDER value to double the output
> +	 * pixel clock and MIPI_CLK speeds.
> +	 */
> +	if (mode->hact > 1024)
> +		mipi_div /= 2;

Sam patches are better here. He found out the reason for this, as
'high resolutions modes' use the scaler, and a ration between pixel
clock and scaler clock has to be respected. My patches you squahsed in
here use this rather sub-optimal "hact > 1024" check, I would rather use his
"does the mode use the scaler?" way instead. That's something else
that could be squashed in a forthcoming version, or fixed with
incremental patches.

> +
> +	ov5640_calc_sys_clk(sensor, rate, &prediv, &mult, &sysdiv);
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL0,
> +			     0x0f, OV5640_PLL_CTRL0_MIPI_MODE_8BIT);
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> +			     0xff, sysdiv << 4 | mipi_div);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2, 0xff, mult);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
> +			     0x1f, OV5640_PLL_CTRL3_PLL_ROOT_DIV_2 | prediv);
> +	if (ret)
> +		return ret;
> +
> +	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER,
> +			      0x30, OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS);

Again, there might be something to bring in from Sam patches here
(programming register 0x4837 with the pixel clock in particular).
Again, let me know how would you like to receive updates.

> +}
> +
> +static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
> +				      unsigned long rate,
> +				      u8 *pll_prediv, u8 *pll_mult, u8 *sysdiv,
> +				      u8 *pll_rdiv, u8 *bit_div, u8 *pclk_div)
> +{
> +	unsigned long _rate = rate * OV5640_PLL_ROOT_DIV * OV5640_BIT_DIV *
> +				OV5640_PCLK_ROOT_DIV;
> +
> +	_rate = ov5640_calc_sys_clk(sensor, _rate, pll_prediv, pll_mult,
> +				    sysdiv);
> +	*pll_rdiv = OV5640_PLL_ROOT_DIV;
> +	*bit_div = OV5640_BIT_DIV;
> +	*pclk_div = OV5640_PCLK_ROOT_DIV;
> +
> +	return _rate / *pll_rdiv / *bit_div / *pclk_div;
> +}

This function is now called from a single place, maybe you want to
remove it and inline its code.

> +
> +static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor, unsigned long rate)
> +{
> +	u8 prediv, mult, sysdiv, pll_rdiv, bit_div, pclk_div;
> +	int ret;
> +
> +	ov5640_calc_pclk(sensor, rate, &prediv, &mult, &sysdiv, &pll_rdiv,
> +			 &bit_div, &pclk_div);
> +
> +	if (bit_div == 2)
> +		bit_div = 8;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL0,
> +			     0x0f, bit_div);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * We need to set sysdiv according to the clock, and to clear
> +	 * the MIPI divider.
> +	 */
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> +			     0xff, sysdiv << 4);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
> +			     0xff, mult);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
> +			     0x1f, prediv | ((pll_rdiv - 1) << 4));
> +	if (ret)
> +		return ret;
> +
> +	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x30,
> +			      (ilog2(pclk_div) << 4));
> +}
> +
>  /* download ov5640 settings to sensor through i2c */
>  static int ov5640_set_timings(struct ov5640_dev *sensor,
>  			      const struct ov5640_mode_info *mode)
> @@ -1637,6 +1984,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor)
>  	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
>  	bool auto_gain = sensor->ctrls.auto_gain->val == 1;
>  	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
> +	unsigned long rate;
>  	int ret;
>
>  	dn_mode = mode->dn_mode;
> @@ -1655,6 +2003,22 @@ static int ov5640_set_mode(struct ov5640_dev *sensor)
>  			goto restore_auto_gain;
>  	}
>
> +	/*
> +	 * All the formats we support have 16 bits per pixel, seems to require
> +	 * the same rate than YUV, so we can just use 16 bpp all the time.
> +	 */
> +	rate = mode->pixel_clock * 16;
> +	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
> +		rate = rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
> +		ret = ov5640_set_mipi_pclk(sensor, rate);
> +	} else {
> +		rate = rate / sensor->ep.bus.parallel.bus_width;
> +		ret = ov5640_set_dvp_pclk(sensor, rate);
> +	}
> +
> +	if (ret < 0)
> +		return 0;
> +
>  	if ((dn_mode == SUBSAMPLING && orig_dn_mode == SCALING) ||
>  	    (dn_mode == SCALING && orig_dn_mode == SUBSAMPLING)) {
>  		/*
> --
> 2.19.1
>

--HnQK338I3UIa/qiP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb7HwfAAoJEHI0Bo8WoVY8r8AQAIWx3slv+4K4eZKNjH1jW+QR
vRo1lW2oQrmWWxkbK1dqVL8/07zvWHH5G8qZmyVr6IEIKX2yvplRH5hGFuVRYW8q
jHt0eb/M/r7ZhUyqn0JX1fmp4uuwV7kkkfaqC/IoLd+OalWREoyoG9V40yR5418E
CuBQ7ZYtromRnRHOMZVyj0k6sWFQql8LIgcVDXGMj8SVj/lwPzSwapRo1VdnpHka
ma+6PyRa8IUP4iXrOvJd2Le9niR8/GneovBXHYY+bQQQuLse8uHv8tO6UvNhnkvN
YyCxolJhEcw6znJ1oZJ6FGa8nrxJc8yjR2uNK2GXfJeNV/kUScf9EYW98eplwPZ5
NhKsWsHqhteWHTHfgRkXK3YxnHU3Mkj+lqVXUmB7Vd7bFv/1h957EQLeerFYWu7h
iWhb1hIUaB8awcp1wvh/GJBiITTFZ0+cUuRiDeu/5KvrgHGPrcZmaExofOgW9kgI
Z2qP5mYV7//m8GpWXM2igmWARhHYIchF0g7PsT3eI0OOeMlqB2Pi39DLSfKf8WFD
yLjHODV5ThHNcJkoaaM8RZy2HdaP90iNpc05ABKt0AU+ZZ/MNNukzizI0Vvn9Ea6
Ck6dXJb3E994D+cTpXWr4tGdZAfvwKSqluWWTSVGC6Hk3OSnf+zUapc60GZg9QM5
pghPg9J2/URcvZlj7Yfw
=n9tO
-----END PGP SIGNATURE-----

--HnQK338I3UIa/qiP--
