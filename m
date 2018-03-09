Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38610 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750883AbeCILQ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 06:16:27 -0500
Date: Fri, 9 Mar 2018 13:16:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH 08/12] media: ov5640: Adjust the clock based on the
 expected rate
Message-ID: <20180309111624.hexk74upa6s53r3t@valkosipuli.retiisi.org.uk>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
 <20180302143500.32650-9-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302143500.32650-9-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Fri, Mar 02, 2018 at 03:34:56PM +0100, Maxime Ripard wrote:
...
> @@ -902,6 +920,246 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
>  	return ov5640_write_reg(sensor, reg, val);
>  }
>  
> +/*
> + * After spending way too much time trying the various combinations, I
> + * believe the clock tree is as follows:

Wow! I've never heard of anyone doing this on non-SMIA compliant sensors.

> + *
> + *   +--------------+
> + *   |  Oscillator  |

I wonder if this should be simply called external clock, that's what the
sensor uses.

> + *   +------+-------+
> + *          |
> + *   +------+-------+
> + *   | System clock | - reg 0x3035, bits 4-7
> + *   +------+-------+
> + *          |
> + *   +------+-------+ - reg 0x3036, for the multiplier
> + *   |     PLL      | - reg 0x3037, bits 4 for the root divider
> + *   +------+-------+ - reg 0x3037, bits 0-3 for the pre-divider
> + *          |
> + *   +------+-------+
> + *   |     SCLK     | - reg 0x3108, bits 0-1 for the root divider
> + *   +------+-------+
> + *          |
> + *   +------+-------+
> + *   |    PCLK      | - reg 0x3108, bits 4-5 for the root divider
> + *   +--------------+
> + *
> + * This is deviating from the datasheet at least for the register
> + * 0x3108, since it's said here that the PCLK would be clocked from
> + * the PLL. However, changing the SCLK divider value has a direct
> + * effect on the PCLK rate, which wouldn't be the case if both PCLK
> + * and SCLK were to be sourced from the PLL.
> + *
> + * These parameters also match perfectly the rate that is output by
> + * the sensor, so we shouldn't have too much factors missing (or they
> + * would be set to 1).
> + */
> +
> +/*
> + * FIXME: This is supposed to be ranging from 1 to 16, but the value
> + * is always set to either 1 or 2 in the vendor kernels.

There could be limits for the clock rates after the first divider. In
practice the clock rates are mostly one of the common frequencies (9,6; 12;
19,2 or 24 MHz) so there's no need to use the other values.

> + */
> +#define OV5640_SYSDIV_MIN	1
> +#define OV5640_SYSDIV_MAX	2
> +
> +static unsigned long ov5640_calc_sysclk(struct ov5640_dev *sensor,
> +					unsigned long rate,
> +					u8 *sysdiv)
> +{
> +	unsigned long best = ~0;
> +	u8 best_sysdiv = 1;
> +	u8 _sysdiv;
> +
> +	for (_sysdiv = OV5640_SYSDIV_MIN;
> +	     _sysdiv <= OV5640_SYSDIV_MAX;
> +	     _sysdiv++) {
> +		unsigned long tmp;
> +
> +		tmp = sensor->xclk_freq / _sysdiv;
> +		if (abs(rate - tmp) < abs(rate - best)) {
> +			best = tmp;
> +			best_sysdiv = _sysdiv;
> +		}
> +
> +		if (tmp == rate)
> +			goto out;
> +	}
> +
> +out:
> +	*sysdiv = best_sysdiv;
> +	return best;
> +}
> +
> +/*
> + * FIXME: This is supposed to be ranging from 1 to 8, but the value is
> + * always set to 3 in the vendor kernels.
> + */
> +#define OV5640_PLL_PREDIV_MIN	3
> +#define OV5640_PLL_PREDIV_MAX	3


Same reasoning here than above. I might leave a comment documenting the
values the hardware supports, removing FIXME as this isn't really an issue
as far as I see.

> +
> +/*
> + * FIXME: This is supposed to be ranging from 1 to 2, but the value is
> + * always set to 1 in the vendor kernels.
> + */
> +#define OV5640_PLL_ROOT_DIV_MIN	1
> +#define OV5640_PLL_ROOT_DIV_MAX	1
> +
> +#define OV5640_PLL_MULT_MIN	4
> +#define OV5640_PLL_MULT_MAX	252
> +
> +static unsigned long ov5640_calc_pll(struct ov5640_dev *sensor,
> +				     unsigned long rate,
> +				     u8 *sysdiv, u8 *prediv, u8 *rdiv, u8 *mult)
> +{
> +	unsigned long best = ~0;
> +	u8 best_sysdiv = 1, best_prediv = 1, best_mult = 1, best_rdiv = 1;
> +	u8 _prediv, _mult, _rdiv;
> +
> +	for (_prediv = OV5640_PLL_PREDIV_MIN;
> +	     _prediv <= OV5640_PLL_PREDIV_MAX;
> +	     _prediv++) {
> +		for (_mult = OV5640_PLL_MULT_MIN;
> +		     _mult <= OV5640_PLL_MULT_MAX;
> +		     _mult++) {
> +			for (_rdiv = OV5640_PLL_ROOT_DIV_MIN;
> +			     _rdiv <= OV5640_PLL_ROOT_DIV_MAX;
> +			     _rdiv++) {
> +				unsigned long pll;
> +				unsigned long sysclk;
> +				u8 _sysdiv;
> +
> +				/*
> +				 * The PLL multiplier cannot be odd if
> +				 * above 127.
> +				 */
> +				if (_mult > 127 && !(_mult % 2))
> +					continue;
> +
> +				sysclk = rate * _prediv * _rdiv / _mult;
> +				sysclk = ov5640_calc_sysclk(sensor, sysclk,
> +							    &_sysdiv);
> +
> +				pll = sysclk / _rdiv / _prediv * _mult;
> +				if (abs(rate - pll) < abs(rate - best)) {
> +					best = pll;
> +					best_sysdiv = _sysdiv;
> +					best_prediv = _prediv;
> +					best_mult = _mult;
> +					best_rdiv = _rdiv;

The smiapp PLL calculator only accepts an exact match. That hasn't been an
issue previously, I wonder if this would work here, too.

I think you could remove the inner loop, too, if put what
ov5640_calc_sysclk() does here. You know the desired clock rate so you can
calculate the total divisor (_rdiv * sysclk divider).

> +				}
> +
> +				if (pll == rate)
> +					goto out;
> +			}
> +		}
> +	}
> +
> +out:
> +	*sysdiv = best_sysdiv;
> +	*prediv = best_prediv;
> +	*mult = best_mult;
> +	*rdiv = best_rdiv;
> +
> +	return best;
> +}
> +
> +/*
> + * FIXME: This is supposed to be ranging from 1 to 8, but the value is
> + * always set to 1 in the vendor kernels.
> + */
> +#define OV5640_PCLK_ROOT_DIV_MIN	1
> +#define OV5640_PCLK_ROOT_DIV_MAX	1
> +
> +static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
> +				      unsigned long rate,
> +				      u8 *sysdiv, u8 *prediv, u8 *pll_rdiv,
> +				      u8 *mult, u8 *pclk_rdiv)
> +{
> +	unsigned long best = ~0;
> +	u8 best_sysdiv = 1, best_prediv = 1, best_mult = 1, best_pll_rdiv = 1;
> +	u8 best_pclk_rdiv = 1;
> +	u8 _pclk_rdiv;
> +
> +	for (_pclk_rdiv = OV5640_PCLK_ROOT_DIV_MIN;
> +	     _pclk_rdiv <= OV5640_PCLK_ROOT_DIV_MAX;
> +	     _pclk_rdiv <<= 1) {
> +		unsigned long pll, pclk;
> +		u8 sysdiv, prediv, mult, pll_rdiv;
> +
> +		pll = rate * OV5640_SCLK_ROOT_DIVIDER_DEFAULT * _pclk_rdiv;
> +		pll = ov5640_calc_pll(sensor, pll, &sysdiv, &prediv, &pll_rdiv,
> +				      &mult);
> +
> +		pclk = pll / OV5640_SCLK_ROOT_DIVIDER_DEFAULT / _pclk_rdiv;
> +		if (abs(rate - pclk) < abs(rate - best)) {
> +			best = pclk;
> +			best_sysdiv = sysdiv;
> +			best_prediv = prediv;
> +			best_pll_rdiv = pll_rdiv;
> +			best_pclk_rdiv = _pclk_rdiv;
> +			best_mult = mult;
> +		}
> +
> +		if (pclk == rate)
> +			goto out;
> +	}
> +
> +out:
> +	*sysdiv = best_sysdiv;
> +	*prediv = best_prediv;
> +	*pll_rdiv = best_pll_rdiv;
> +	*mult = best_mult;
> +	*pclk_rdiv = best_pclk_rdiv;
> +	return best;
> +}
> +
> +static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor, unsigned long rate)
> +{
> +	u8 sysdiv, prediv, mult, pll_rdiv, pclk_rdiv;
> +	int ret;
> +
> +	ov5640_calc_pclk(sensor, rate, &sysdiv, &prediv, &pll_rdiv, &mult,
> +			 &pclk_rdiv);
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> +			     0xf0, sysdiv << 4);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
> +			     0xff, mult);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
> +			     0xff, prediv | ((pll_rdiv - 1) << 4));
> +	if (ret)
> +		return ret;
> +
> +	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER,
> +			      0x30, ilog2(pclk_rdiv) << 4);
> +}
> +
> +static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor, unsigned long rate)
> +{
> +	u8 sysdiv, prediv, mult, pll_rdiv, pclk_rdiv;
> +	int ret;
> +
> +	ov5640_calc_pclk(sensor, rate, &sysdiv, &prediv, &pll_rdiv, &mult,
> +			 &pclk_rdiv);
> +	ret = ov5640_write_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
> +			       (sysdiv << 4) | pclk_rdiv);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
> +			     0xff, mult);
> +	if (ret)
> +		return ret;
> +
> +	return ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
> +			      0xff, prediv | ((pll_rdiv - 1) << 4));
> +}
> +
>  /* download ov5640 settings to sensor through i2c */
>  static int ov5640_load_regs(struct ov5640_dev *sensor,
>  			    const struct ov5640_mode_info *mode)
> @@ -1610,6 +1868,14 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>  	if (ret)
>  		return ret;
>  
> +	if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
> +		ret = ov5640_set_mipi_pclk(sensor, mode->clock);
> +	else
> +		ret = ov5640_set_dvp_pclk(sensor, mode->clock);
> +
> +	if (ret < 0)
> +		return 0;
> +
>  	if ((dn_mode == SUBSAMPLING && orig_dn_mode == SCALING) ||
>  	    (dn_mode == SCALING && orig_dn_mode == SUBSAMPLING)) {
>  		/*

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
