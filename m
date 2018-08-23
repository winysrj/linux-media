Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53348 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726246AbeHWO7b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 10:59:31 -0400
Date: Thu, 23 Aug 2018 14:30:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: aptina-pll: allow approximating the requested
 pix_clock
Message-ID: <20180823113012.u4dm4zbulpksemdi@valkosipuli.retiisi.org.uk>
References: <20180814084026.be4fpbhrppdnx2a3@laureti-dev>
 <20180823075208.mqjctv4ax4dakfws@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180823075208.mqjctv4ax4dakfws@laureti-dev>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helmut,

On Thu, Aug 23, 2018 at 09:52:09AM +0200, Helmut Grohne wrote:
> Clock frequencies are not exact values, but rather imprecise, physical
> properties. The present pll computation however, treats them as exact.
> It tries to compute parameters that attain the requested pix_clock
> exactly. Failing that, it gives up.
> 
> The new implementation approximates the requested pix_clock and reports
> the actual value resulting from the computed parameters. If the
> requested pix_clock can be attained, the original behaviour of
> maximizing p1 is retained.
> 
> Experiments with the algorithm in userspace on an arm device show that
> the computational cost is negligible compared to executing a binary for
> all practical inputs.
> 
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
> ---
>  drivers/media/i2c/aptina-pll.c | 263 ++++++++++++++++++++++++-----------------
>  drivers/media/i2c/mt9m032.c    |  15 ++-
>  2 files changed, 165 insertions(+), 113 deletions(-)
> 
> I tried using aptina_pll_calculate in a driver for a similar image sensor.
> Using it, I was unable to find a pix_clock value such that the computation was
> successful. Most of the practical parameters result in a non-integer pix_clock,
> something that struct pll cannot represent.

Knowing the formula, the limits as well as the external clock frequency, it
should be relatively straightforward to come up with a functional pixel
clock value. Was there a practical problem in coming up with such a value?

You can't pick a value at random; it needs to be one that actually works.
The purpose of having an exact frequency is that the typical systems where
these devices are being used, as I explained earlier, is that having a
random frequency, albeit with which the sensor could possibly work, the
other devices in the system may not do so.

The importantce of the calculator is more apparent for devices that use
serial busses with a variable number of lanes etc. where the pixel format
affects the pixel rate whereas the link frequency stays unchanged.

> 
> The driver is not ready for submission at this point, but the changes to
> aptina_pll_calculate are reasonable on their own, which is why I submit them
> separately now.
> 
> Helmut
> 
> diff --git a/drivers/media/i2c/aptina-pll.c b/drivers/media/i2c/aptina-pll.c
> index 224ae4e4cf8b..249018772b2b 100644
> --- a/drivers/media/i2c/aptina-pll.c
> +++ b/drivers/media/i2c/aptina-pll.c
> @@ -2,6 +2,7 @@
>   * Aptina Sensor PLL Configuration
>   *
>   * Copyright (C) 2012 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + * Copyright (C) 2018 Intenta GmbH
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -14,23 +15,84 @@
>   */
>  
>  #include <linux/device.h>
> -#include <linux/gcd.h>
>  #include <linux/kernel.h>
> -#include <linux/lcm.h>
> +#include <linux/math64.h>
>  #include <linux/module.h>
>  
>  #include "aptina-pll.h"
>  
> +/* A variant of mult_frac that works even when (x % denom) * numer produces a
> + * 32bit overflow.
> + */
> +#define mult_frac_exact(x, numer, denom) \
> +	((u32)div_u64(mul_u32_u32((x), (numer)), (denom)))
> +
> +static unsigned int absdiff(unsigned int x, unsigned int y)
> +{
> +	return x > y ? x - y : y - x;
> +}
> +
> +/* Find n_min <= *np <= n_max and d_min <= *dp <= d_max such that *np / *dp
> + * approximates n_target / d_target.
> + */
> +static int approximate_fraction(unsigned int n_min, unsigned int n_max,
> +				unsigned int d_min, unsigned int d_max,
> +				unsigned int n_target, unsigned int d_target,
> +				unsigned int *np, unsigned int *dp)
> +{
> +	unsigned int d, best_err = UINT_MAX;
> +
> +	d_min = max(d_min, mult_frac_exact(n_min, d_target, n_target));
> +	d_max = min(d_max, mult_frac_exact(n_max, d_target, n_target) + 1);
> +	if (d_min > d_max)
> +		return -EINVAL;
> +
> +	for (d = d_min; d < d_max; ++d) {
> +		unsigned int n = mult_frac_exact(d, n_target, d_target);
> +
> +		if (n >= n_min) {
> +			unsigned int err = absdiff(
> +				n_target, mult_frac_exact(n, d_target, d));
> +
> +			if (err < best_err) {
> +				best_err = err;
> +				*np = n;
> +				*dp = d;
> +			}
> +			if (err == 0)
> +				return 0;
> +		}
> +		++n;
> +		if (n <= n_max) {
> +			unsigned int err = absdiff(
> +				n_target, mult_frac_exact(n, d_target, d));
> +
> +			if (err < best_err) {
> +				best_err = err;
> +				*np = n;
> +				*dp = d;
> +			}
> +		}
> +	}
> +	return best_err == UINT_MAX ? -EINVAL : 0;
> +}
> +
> +/* Find parameters n, m, p1 such that:
> + *   n_min <= n <= n_max
> + *   m_min <= m <= m_max
> + *   p1_min <= p1 <= p1_max, even
> + *   int_clock_min <= ext_clock / n <= int_clock_max
> + *   out_clock_min <= ext_clock / n * m <= out_clock_max
> + *   pix_clock = ext_clock / n * m / p1 (approximately)
> + *   p1 is maximized
> + * Report the achieved pix_clock (input/output parameter).
> + */
>  int aptina_pll_calculate(struct device *dev,
>  			 const struct aptina_pll_limits *limits,
>  			 struct aptina_pll *pll)
>  {
> -	unsigned int mf_min;
> -	unsigned int mf_max;
> -	unsigned int p1_min;
> -	unsigned int p1_max;
> -	unsigned int p1;
> -	unsigned int div;
> +	unsigned int n_min, n_max, m_min, m_max, p1_min, p1_max, p1;
> +	unsigned int clock_err = UINT_MAX;
>  
>  	dev_dbg(dev, "PLL: ext clock %u pix clock %u\n",
>  		pll->ext_clock, pll->pix_clock);
> @@ -46,120 +108,103 @@ int aptina_pll_calculate(struct device *dev,
>  		return -EINVAL;
>  	}
>  
> -	/* Compute the multiplier M and combined N*P1 divisor. */
> -	div = gcd(pll->pix_clock, pll->ext_clock);
> -	pll->m = pll->pix_clock / div;
> -	div = pll->ext_clock / div;
> -
> -	/* We now have the smallest M and N*P1 values that will result in the
> -	 * desired pixel clock frequency, but they might be out of the valid
> -	 * range. Compute the factor by which we should multiply them given the
> -	 * following constraints:
> -	 *
> -	 * - minimum/maximum multiplier
> -	 * - minimum/maximum multiplier output clock frequency assuming the
> -	 *   minimum/maximum N value
> -	 * - minimum/maximum combined N*P1 divisor
> -	 */
> -	mf_min = DIV_ROUND_UP(limits->m_min, pll->m);
> -	mf_min = max(mf_min, limits->out_clock_min /
> -		     (pll->ext_clock / limits->n_min * pll->m));
> -	mf_min = max(mf_min, limits->n_min * limits->p1_min / div);
> -	mf_max = limits->m_max / pll->m;
> -	mf_max = min(mf_max, limits->out_clock_max /
> -		    (pll->ext_clock / limits->n_max * pll->m));
> -	mf_max = min(mf_max, DIV_ROUND_UP(limits->n_max * limits->p1_max, div));
> -
> -	dev_dbg(dev, "pll: mf min %u max %u\n", mf_min, mf_max);
> -	if (mf_min > mf_max) {
> -		dev_err(dev, "pll: no valid combined N*P1 divisor.\n");
> +	/* int_clock_min <= ext_clock / N <= int_clock_max */
> +	n_min = max(limits->n_min,
> +		    DIV_ROUND_UP(pll->ext_clock, limits->int_clock_max));
> +	n_max = min(limits->n_max,
> +		    pll->ext_clock / limits->int_clock_min);
> +
> +	if (n_min > n_max) {
> +		dev_err(dev,
> +			"pll: no divisor N results in a valid int_clock.\n");
> +		return -EINVAL;
> +	}
> +
> +	/* out_clock_min <= ext_clock / N * M <= out_clock_max */
> +	m_min = max(limits->m_min,
> +		    mult_frac(limits->out_clock_min, n_min, pll->ext_clock));
> +	m_max = min(limits->m_max,
> +		    mult_frac(limits->out_clock_max, n_max, pll->ext_clock));
> +	if (m_min > m_max) {
> +		dev_err(dev,
> +			"pll: no multiplier M results in a valid out_clock.\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Using limits of m, we can further shrink the range of n. */
> +	n_min = max(n_min,
> +		    mult_frac(pll->ext_clock, m_min, limits->out_clock_max));
> +	n_max = max(n_max,
> +		    mult_frac(pll->ext_clock, m_max, limits->out_clock_min));
> +	if (n_min > n_max) {
> +		dev_err(dev,
> +			"pll: no divisor N results in a valid out_clock.\n");
>  		return -EINVAL;
>  	}
>  
> -	/*
> -	 * We're looking for the highest acceptable P1 value for which a
> -	 * multiplier factor MF exists that fulfills the following conditions:
> -	 *
> -	 * 1. p1 is in the [p1_min, p1_max] range given by the limits and is
> -	 *    even
> -	 * 2. mf is in the [mf_min, mf_max] range computed above
> -	 * 3. div * mf is a multiple of p1, in order to compute
> -	 *	n = div * mf / p1
> -	 *	m = pll->m * mf
> -	 * 4. the internal clock frequency, given by ext_clock / n, is in the
> -	 *    [int_clock_min, int_clock_max] range given by the limits
> -	 * 5. the output clock frequency, given by ext_clock / n * m, is in the
> -	 *    [out_clock_min, out_clock_max] range given by the limits
> -	 *
> -	 * The first naive approach is to iterate over all p1 values acceptable
> -	 * according to (1) and all mf values acceptable according to (2), and
> -	 * stop at the first combination that fulfills (3), (4) and (5). This
> -	 * has a O(n^2) complexity.
> -	 *
> -	 * Instead of iterating over all mf values in the [mf_min, mf_max] range
> -	 * we can compute the mf increment between two acceptable values
> -	 * according to (3) with
> -	 *
> -	 *	mf_inc = p1 / gcd(div, p1)			(6)
> -	 *
> -	 * and round the minimum up to the nearest multiple of mf_inc. This will
> -	 * restrict the number of mf values to be checked.
> -	 *
> -	 * Furthermore, conditions (4) and (5) only restrict the range of
> -	 * acceptable p1 and mf values by modifying the minimum and maximum
> -	 * limits. (5) can be expressed as
> -	 *
> -	 *	ext_clock / (div * mf / p1) * m * mf >= out_clock_min
> -	 *	ext_clock / (div * mf / p1) * m * mf <= out_clock_max
> -	 *
> -	 * or
> -	 *
> -	 *	p1 >= out_clock_min * div / (ext_clock * m)	(7)
> -	 *	p1 <= out_clock_max * div / (ext_clock * m)
> -	 *
> -	 * Similarly, (4) can be expressed as
> -	 *
> -	 *	mf >= ext_clock * p1 / (int_clock_max * div)	(8)
> -	 *	mf <= ext_clock * p1 / (int_clock_min * div)
> -	 *
> -	 * We can thus iterate over the restricted p1 range defined by the
> -	 * combination of (1) and (7), and then compute the restricted mf range
> -	 * defined by the combination of (2), (6) and (8). If the resulting mf
> -	 * range is not empty, any value in the mf range is acceptable. We thus
> -	 * select the mf lwoer bound and the corresponding p1 value.
> -	 */
> -	if (limits->p1_min == 0) {
> -		dev_err(dev, "pll: P1 minimum value must be >0.\n");
> +	dev_dbg(dev, "pll: %u <= N <= %u\n", n_min, n_max);
> +	dev_dbg(dev, "pll: %u <= M <= %u\n", m_min, m_max);
> +
> +	/* out_clock_min <= pix_clock * P1 <= out_clock_max */
> +	p1_min = max(limits->p1_min,
> +		     DIV_ROUND_UP(limits->out_clock_min, pll->pix_clock));
> +	p1_max = min(limits->p1_max,
> +		     limits->out_clock_max / pll->pix_clock);
> +	/* pix_clock = ext_clock / N * M / P1 */
> +	p1_min = max(p1_min, DIV_ROUND_UP(pll->ext_clock * m_min,
> +					  pll->pix_clock * n_max));
> +	p1_max = min(p1_max,
> +		     pll->ext_clock * m_max / (pll->pix_clock * n_min));
> +	if (p1_min > p1_max) {
> +		dev_err(dev, "pll: no valid P1 divisor.\n");
>  		return -EINVAL;
>  	}
>  
> -	p1_min = max(limits->p1_min, DIV_ROUND_UP(limits->out_clock_min * div,
> -		     pll->ext_clock * pll->m));
> -	p1_max = min(limits->p1_max, limits->out_clock_max * div /
> -		     (pll->ext_clock * pll->m));
> +	dev_dbg(dev, "pll: %u <= P1 <= %u\n", p1_min, p1_max);
>  
>  	for (p1 = p1_max & ~1; p1 >= p1_min; p1 -= 2) {
> -		unsigned int mf_inc = p1 / gcd(div, p1);
> -		unsigned int mf_high;
> -		unsigned int mf_low;
> +		unsigned int n = 0, m = UINT_MAX, out_clock, err;
> +		const unsigned int target_out_clock = pll->pix_clock * p1;
>  
> -		mf_low = roundup(max(mf_min, DIV_ROUND_UP(pll->ext_clock * p1,
> -					limits->int_clock_max * div)), mf_inc);
> -		mf_high = min(mf_max, pll->ext_clock * p1 /
> -			      (limits->int_clock_min * div));
> +		/* target_out_clock = ext_clock / N * M */
> +		if (approximate_fraction(n_min, n_max, m_min, m_max,
> +					 pll->ext_clock, target_out_clock,
> +					 &n, &m) < 0)
> +			continue;
>  
> -		if (mf_low > mf_high)
> +		/* We must check all conditions due to possible rounding
> +		 * errors:
> +		 *   int_clock_min <= ext_clock / N <= int_clock_max
> +		 *   out_clock_min <= ext_clock / N * M <= out_clock_max
> +		 */
> +		out_clock = mult_frac(pll->ext_clock, m, n);
> +		if (pll->ext_clock < limits->int_clock_min * n ||
> +		    pll->ext_clock > limits->int_clock_max * n ||
> +		    out_clock < limits->out_clock_min ||
> +		    out_clock > limits->out_clock_max)
>  			continue;
>  
> -		pll->n = div * mf_low / p1;
> -		pll->m *= mf_low;
> -		pll->p1 = p1;
> -		dev_dbg(dev, "PLL: N %u M %u P1 %u\n", pll->n, pll->m, pll->p1);
> -		return 0;
> +		err = absdiff(out_clock / p1, pll->pix_clock);
> +		if (err < clock_err) {
> +			pll->n = n;
> +			pll->m = m;
> +			pll->p1 = p1;
> +			clock_err = err;
> +		}
> +		if (err == 0) {
> +			dev_dbg(dev, "pll: N %u M %u P1 %u exact\n",
> +				pll->n, pll->m, pll->p1);
> +			return 0;
> +		}
>  	}
> -
> -	dev_err(dev, "pll: no valid N and P1 divisors found.\n");
> -	return -EINVAL;
> +	if (clock_err == UINT_MAX) {
> +		dev_err(dev, "pll: no valid parameters found.\n");
> +		return -EINVAL;
> +	}
> +	pll->pix_clock = mult_frac(pll->ext_clock, pll->m, pll->n * pll->p1);
> +	dev_dbg(dev, "pll: N %u M %u P1 %u pix_clock %u Hz error %u Hz\n",
> +		pll->n, pll->m, pll->p1, pll->pix_clock, clock_err);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(aptina_pll_calculate);
>  
> diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
> index 6a9e068462fd..31410f40b197 100644
> --- a/drivers/media/i2c/mt9m032.c
> +++ b/drivers/media/i2c/mt9m032.c
> @@ -285,7 +285,7 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
>  	if (ret < 0)
>  		return ret;
>  
> -	sensor->pix_clock = pdata->pix_clock;
> +	sensor->pix_clock = pll.pix_clock;
>  
>  	ret = mt9m032_write(client, MT9M032_PLL_CONFIG1,
>  			    (pll.m << MT9M032_PLL_CONFIG1_MUL_SHIFT) |
> @@ -711,6 +711,7 @@ static int mt9m032_probe(struct i2c_client *client,
>  	struct mt9m032_platform_data *pdata = client->dev.platform_data;
>  	struct i2c_adapter *adapter = client->adapter;
>  	struct mt9m032 *sensor;
> +	struct v4l2_ctrl *pixel_rate_ctrl;
>  	int chip_version;
>  	int ret;
>  
> @@ -780,9 +781,10 @@ static int mt9m032_probe(struct i2c_client *client,
>  			  V4L2_CID_EXPOSURE, MT9M032_SHUTTER_WIDTH_MIN,
>  			  MT9M032_SHUTTER_WIDTH_MAX, 1,
>  			  MT9M032_SHUTTER_WIDTH_DEF);
> -	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> -			  V4L2_CID_PIXEL_RATE, pdata->pix_clock,
> -			  pdata->pix_clock, 1, pdata->pix_clock);
> +	pixel_rate_ctrl = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> +					    V4L2_CID_PIXEL_RATE,
> +					    pdata->pix_clock, pdata->pix_clock,
> +					    1, pdata->pix_clock);
>  
>  	if (sensor->ctrls.error) {
>  		ret = sensor->ctrls.error;
> @@ -810,6 +812,11 @@ static int mt9m032_probe(struct i2c_client *client,
>  		goto error_entity;
>  	usleep_range(10000, 11000);
>  
> +	ret = __v4l2_ctrl_modify_range(pixel_rate_ctrl, sensor->pix_clock,
> +				       sensor->pix_clock, 1, sensor->pix_clock);
> +	if (ret < 0)
> +		goto error_entity;
> +
>  	ret = v4l2_ctrl_handler_setup(&sensor->ctrls);
>  	if (ret < 0)
>  		goto error_entity;
> -- 
> 2.11.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
