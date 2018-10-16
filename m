Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:38607 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbeJQAqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 20:46:14 -0400
Date: Tue, 16 Oct 2018 18:54:50 +0200
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
Subject: Re: [PATCH v4 01/12] media: ov5640: Adjust the clock based on the
 expected rate
Message-ID: <20181016165450.GB11703@w540>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <20181011092107.30715-2-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Maxime,
   a few comments I have collected while testing the series.

Please see below.

On Thu, Oct 11, 2018 at 11:20:56AM +0200, Maxime Ripard wrote:
> The clock structure for the PCLK is quite obscure in the documentation, a=
nd
> was hardcoded through the bytes array of each and every mode.
>
> This is troublesome, since we cannot adjust it at runtime based on other
> parameters (such as the number of bytes per pixel), and we can't support
> either framerates that have not been used by the various vendors, since we
> don't have the needed initialization sequence.
>
> We can however understand how the clock tree works, and then implement so=
me
> functions to derive the various parameters from a given rate. And now that
> those parameters are calculated at runtime, we can remove them from the
> initialization sequence.
>
> The modes also gained a new parameter which is the clock that they are
> running at, from the register writes they were doing, so for now the swit=
ch
> to the new algorithm should be transparent.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/i2c/ov5640.c | 289 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 288 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 30b15e91d8be..88fb16341466 100644
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
> @@ -700,6 +701,7 @@ static const struct reg_value ov5640_setting_15fps_QS=
XGA_2592_1944[] =3D {
>  /* power-on sensor init reg table */
>  static const struct ov5640_mode_info ov5640_mode_init_data =3D {
>  	0, SUBSAMPLING, 640, 1896, 480, 984,
> +	56000000,
>  	ov5640_init_setting_30fps_VGA,
>  	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
>  };
> @@ -709,74 +711,91 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_=
MODES] =3D {
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
> @@ -909,6 +928,255 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor=
, u16 reg,
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
> + *  - PCLK >=3D SCLK * 2 in YUV, >=3D SCLK in Raw or JPEG
> + *  - MIPI SCLK =3D (bpp / lanes) / PCLK

This last line probably wrong...

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
> +#define OV5640_SYSDIV_MIN	1
> +#define OV5640_SYSDIV_MAX	2
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
> +#define OV5640_PLL_ROOT_DIV	2
> +
> +/*
> + * This is supposed to be either 1, 2 or 2.5, but the value is always
> + * set to 2 in the vendor kernels.
> + */
> +#define OV5640_BIT_DIV		2
> +
> +/*
> + * This is supposed to be ranging from 1 to 8, but the value is always
> + * set to 2 in the vendor kernels.
> + */
> +#define OV5640_SCLK_ROOT_DIV	2
> +
> +/*
> + * This is hardcoded so that the consistency is maintained between SCLK =
and
> + * SCLK 2x.
> + */
> +#define OV5640_SCLK2X_ROOT_DIV (OV5640_SCLK_ROOT_DIV / 2)
> +
> +/*
> + * This is supposed to be ranging from 1 to 8, but the value is always
> + * set to 1 in the vendor kernels.
> + */
> +#define OV5640_PCLK_ROOT_DIV	1
> +
> +static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
> +					    u8 pll_prediv, u8 pll_mult,
> +					    u8 sysdiv)
> +{
> +	unsigned long rate =3D clk_get_rate(sensor->xclk);

The clock rate is stored in sensor->xclk at probe time, no need to
query it every iteration.

> +
> +	return rate / pll_prediv * pll_mult / sysdiv;
> +}
> +
> +static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> +					 unsigned long rate,
> +					 u8 *pll_prediv, u8 *pll_mult,
> +					 u8 *sysdiv)
> +{
> +	unsigned long best =3D ~0;
> +	u8 best_sysdiv =3D 1, best_mult =3D 1;
> +	u8 _sysdiv, _pll_mult;
> +
> +	for (_sysdiv =3D OV5640_SYSDIV_MIN;
> +	     _sysdiv <=3D OV5640_SYSDIV_MAX;
> +	     _sysdiv++) {
> +		for (_pll_mult =3D OV5640_PLL_MULT_MIN;
> +		     _pll_mult <=3D OV5640_PLL_MULT_MAX;
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
> +			_rate =3D ov5640_compute_sys_clk(sensor,
> +						       OV5640_PLL_PREDIV,
> +						       _pll_mult, _sysdiv);

I'm under the impression a system clock slower than the requested one, even
if more accurate is not good.

I'm still working on understanding how all CSI-2 related timing
parameters play together, but since the system clock is calculated
=66rom the pixel clock (which comes from the frame dimensions, bpp, and
rate), and it is then used to calculate the MIPI BIT clock frequency,
I think it would be better to be a little faster than a bit slower,
otherwise the serial lane clock wouldn't be fast enough to output
frames generated by the sensor core (or maybe it would just decrease
the frame rate and that's it, but I don't think it is just this).

What do you think of adding the following here:

                if (_rate < rate)
                        continue


> +			if (abs(rate - _rate) < abs(rate - best)) {
> +				best =3D _rate;
> +				best_sysdiv =3D _sysdiv;
> +				best_mult =3D _pll_mult;
> +			}
> +
> +			if (_rate =3D=3D rate)
> +				goto out;
> +		}
> +	}
> +
> +out:
> +	*sysdiv =3D best_sysdiv;
> +	*pll_prediv =3D OV5640_PLL_PREDIV;
> +	*pll_mult =3D best_mult;
> +	return best;
> +}

These function gets called at s_stream time, and cycle for a while,
and I'm under the impression the MIPI state machine doesn't like
delays too much, as I see timeouts on the receiver side.

I have tried to move this function at set_fmt() time, every time a new
mode is selected, sysdiv, pll_prediv and pll_mult gets recalculated
(and stored in the ov5640_dev structure). I now have other timeouts on
missing EOF, but not anymore at startup time it seems.


On a general testing note: I have tried hardcoding all PLL
configuration paramters to their values as specified in the
initialization blob you have removed, and still, I have EOF timeouts
on the CSI-2 bus. There is something we're still missing on the MIPI
clock generation part, even if the documentation I have matches your
understandings..

> +
> +static unsigned long ov5640_calc_mipi_clk(struct ov5640_dev *sensor,
> +					  unsigned long rate,
> +					  u8 *pll_prediv, u8 *pll_mult,
> +					  u8 *sysdiv, u8 *mipi_div)
> +{
> +	unsigned long _rate =3D rate * OV5640_MIPI_DIV;
> +
> +	_rate =3D ov5640_calc_sys_clk(sensor, _rate, pll_prediv, pll_mult,
> +				    sysdiv);
> +	*mipi_div =3D OV5640_MIPI_DIV;
> +
> +	return _rate / *mipi_div;
> +}
> +
> +static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor, unsigned long=
 rate)
> +{
> +	u8 prediv, mult, sysdiv, mipi_div;
> +	int ret;
> +
> +	ov5640_calc_mipi_clk(sensor, rate, &prediv, &mult, &sysdiv, &mipi_div);

Confusingly, register PLL_CTRL0 (0x3034) controls the "MIPI bit mode",
which I'm not a 100% sure what represents, and it is not written here
in the MIPI clock configuration function.

As in the clock diagram I have it reads as:
 0x3034 MIPI BIT MODE
        0x08 =3D / 2
        0x0A =3D / 2.5

I suspect it is used to maintain a correct relationship between the
pixel clock (in samples/second) and the total bandwidth in bytes and
thus it has to be written here.

Reading the clock tree in the opposite direction I see:

 ------------------------------
|pixel clk (htot * vtot * rate)|
 -----------------------------
            |   --------------------------------------------
            |->| P_DIV: 2lanes ? MIPI_DIV : 2 * MIPI_DIV   |
                --------------------------------------------
                                   |   --------
                                   |->|PCLK_DIV|
                                       --------
                                          |   ------------
                                          |->|   BIT_DIV  |
                                              ------------
                                                    |   ----------
                                                    |->| PLL_R DIV|
                                                        ---------
                                                            |
                                                            |--------->SYSC=
LK

And I then suspect that:
   P_DIV * PCLK_DIV * BIT_DIV =3D bpp

So that, if we hardcode PLL_R div to 1, the system clock is
actually the total bandwidth in bytes.

This would be then be:
  bandwidth =3D pixel_clk * rate * bpp
            =3D pixel_clk * rate * (MIPI_DIV * PCLK_DIV * BIT_DIV)
            =3D SYSCLK

and then depending on the current format's bbp:
  PCLK_DIV =3D bpp / (BIT_DIV * num_lanes)

This matches the other part of the MIPI clock tree, the MIPI_CLK
generation part, where the SYSCLK is divided again by MIPI_DIV and
then by 2 to take into account the CSI-2 DDR.

  MIPI BIT CLK =3D bandwidth / num_lanes / 2
               =3D SYS_CLK / MIPI_DIV / 2

While this works pretty well in my head, it does not on the sensor :/

So I might have mis-intrpreted something, or we're missing some part
of the clock tree that impacts the CSI-2 bus.

I recall Sam had a pretty well understanding of this part.
I wonder if he has comments... :)

Thanks
   j
> +
> +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> +			     0xff, sysdiv << 4 | (mipi_div - 1));
> +	if (ret)
> +		return ret;
> +
> +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2, 0xff, mult);
> +	if (ret)
> +		return ret;
> +
> +	return ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3, 0xf, prediv);
> +}
> +
> +static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
> +				      unsigned long rate,
> +				      u8 *pll_prediv, u8 *pll_mult, u8 *sysdiv,
> +				      u8 *pll_rdiv, u8 *bit_div, u8 *pclk_div)
> +{
> +	unsigned long _rate =3D rate * OV5640_PLL_ROOT_DIV * OV5640_BIT_DIV *
> +				OV5640_PCLK_ROOT_DIV;
> +
> +	_rate =3D ov5640_calc_sys_clk(sensor, _rate, pll_prediv, pll_mult,
> +				    sysdiv);
> +	*pll_rdiv =3D OV5640_PLL_ROOT_DIV;
> +	*bit_div =3D OV5640_BIT_DIV;
> +	*pclk_div =3D OV5640_PCLK_ROOT_DIV;
> +
> +	return _rate / *pll_rdiv / *bit_div / *pclk_div;
> +}
> +
> +static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor, unsigned long =
rate)
> +{
> +	u8 prediv, mult, sysdiv, pll_rdiv, bit_div, pclk_div;
> +	int ret;
> +
> +	ov5640_calc_pclk(sensor, rate, &prediv, &mult, &sysdiv, &pll_rdiv,
> +			 &bit_div, &pclk_div);
> +
> +	if (bit_div =3D=3D 2)
> +		bit_div =3D 8;
> +
> +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL0,
> +			     0x0f, bit_div);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * We need to set sysdiv according to the clock, and to clear
> +	 * the MIPI divider.
> +	 */
> +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> +			     0xff, sysdiv << 4);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
> +			     0xff, mult);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
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
> @@ -1637,6 +1905,8 @@ static int ov5640_set_mode(struct ov5640_dev *senso=
r)
>  	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
>  	bool auto_gain =3D sensor->ctrls.auto_gain->val =3D=3D 1;
>  	bool auto_exp =3D  sensor->ctrls.auto_exp->val =3D=3D V4L2_EXPOSURE_AUT=
O;
> +	unsigned long rate;
> +	unsigned char bpp;
>  	int ret;
>
>  	dn_mode =3D mode->dn_mode;
> @@ -1655,6 +1925,23 @@ static int ov5640_set_mode(struct ov5640_dev *sens=
or)
>  			goto restore_auto_gain;
>  	}
>
> +	/*
> +	 * All the formats we support have 16 bits per pixel, except for JPEG
> +	 * which is 8 bits per pixel.
> +	 */
> +	bpp =3D sensor->fmt.code =3D=3D MEDIA_BUS_FMT_JPEG_1X8 ? 8 : 16;
> +	rate =3D mode->pixel_clock * bpp;
> +	if (sensor->ep.bus_type =3D=3D V4L2_MBUS_CSI2) {
> +		rate =3D rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
> +		ret =3D ov5640_set_mipi_pclk(sensor, rate);
> +	} else {
> +		rate =3D rate / sensor->ep.bus.parallel.bus_width;
> +		ret =3D ov5640_set_dvp_pclk(sensor, rate);
> +	}
> +
> +	if (ret < 0)
> +		return 0;
> +
>  	if ((dn_mode =3D=3D SUBSAMPLING && orig_dn_mode =3D=3D SCALING) ||
>  	    (dn_mode =3D=3D SCALING && orig_dn_mode =3D=3D SUBSAMPLING)) {
>  		/*
> --
> 2.19.1
>

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbxhfaAAoJEHI0Bo8WoVY8adsQAIE9m+0R8bQQIewM2vADqi5A
iSeEuMphxt7VrWlMdIr9iWarfF9o12WNXNpOqNXl0rcT11iFfptnZNwsIIxpQMqo
ZR+AdFHzeOYJMGMF3UluqB0rifbBkjXh0sP0qBDsBCXpS76p3mhKyDqxKxxXkOeF
Vq8K0Btqi8wcloh6fjpZCXAdtB1iaVS1qDgwytXmp7kV8AQJ7d12mrhR77gOicw5
ptF6MXAEnzwYo1tuBAUY6Db8DIyIpaQi5dihLUz1CGAw+NaKauY4UfkSg1Tju8HX
zmlNiZmXo3QxQgSGytEHOznhjSYrRPpNjwH/Bd5Eb2xsnPYUVi/HodrZ59n2Q96l
BcfWNrfoat11daNdlTPqKJM1Dk40nErdREalNqfxv0t7+g/harSuHiNC7uhtnZ8S
+kIqsYWSvLt0lp5KNr3Zwoxgm65Zgar2INbpzUiV0SPZtbTKpt/47Xo4ZnqAKkTx
FShuPEAfHgSD/ONeud63TiK0FiULKwRxjKXEqM0l/q1rxXtnosFjSdkKxIU/1KAW
j5NtYVzS2FZ1A1bhHCNAirFCtNPoykdei6xNeko+H6kzYQSQF7Td6k+MW/xauk4+
JQjyEUctGQoLTFeq5TJ9zDDQjGEXyGyhjSE2jGvuw8S5hPUldSjf9KpRdZVCMhK9
ABvqV139O5KTJufbDXLw
=bzQM
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
