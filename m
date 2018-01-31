Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48868 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbeAaKen (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:34:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, hverkuil@xs4all.nl,
        mchehab@kernel.org, festevam@gmail.com, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com, pombredanne@nexb.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/11] media: i2c: ov772x: Support frame interval handling
Date: Wed, 31 Jan 2018 12:34:59 +0200
Message-ID: <34502970.Ll86D7ehED@avalon>
In-Reply-To: <1517306302-27957-8-git-send-email-jacopo+renesas@jmondi.org>
References: <1517306302-27957-1-git-send-email-jacopo+renesas@jmondi.org> <1517306302-27957-8-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Tuesday, 30 January 2018 11:58:18 EET Jacopo Mondi wrote:
> Add support to ov772x driver for frame intervals handling and enumeration.
> Tested with 10MHz and 24MHz input clock at VGA and QVGA resolutions for
> 10, 15 and 30 frame per second rates.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/ov772x.c | 210 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 193 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 23106d7..28de254 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c

[snip]

> @@ -373,6 +378,19 @@
>  #define VERSION(pid, ver) ((pid<<8)|(ver&0xFF))
> 
>  /*
> + * Frame size (including blanking lines)
> + */
> +#define VGA_FRAME_SIZE		(510 * 748)
> +#define QVGA_FRAME_SIZE		(278 * 576)

Those two macros are not used, you can drop them.

> +/*
> + * Input clock frequencies
> + */
> +static const u8 ov772x_com4_vals[] = { PLL_BYPASS, PLL_4x, PLL_6x, PLL_8x
> };
> +static const unsigned int ov772x_pll_mult[] = { 1, 4, 6, 8 };
> +#define OV772X_PLL_N_MULT ARRAY_SIZE(ov772x_pll_mult)

I think it would be clearer if you used ARRAY_SIZE(ov772x_pll_mult) directly 
in the code.

Maybe nitpicking a bit, but I wouldgroup the com4 values and multipliers in a 
structure:

static const struct {
	unsigned int mult;
	u8 com4;
} ov772x_pll_mult[] = {
	{ 1, PLL_BYPASS },
	{ 4, PLL_4x },
	{ 6, PLL_6x },
	{ 8, PLL_8x },
};

That ensures that the two arrays stay in sync as there's only one array left.

> +/*
>   * struct
>   */
> 
> @@ -388,6 +406,7 @@ struct ov772x_color_format {
>  struct ov772x_win_size {
>  	char                     *name;
>  	unsigned char             com7_bit;
> +	unsigned int		  sizeimage;
>  	struct v4l2_rect	  rect;
>  };
> 
> @@ -404,6 +423,7 @@ struct ov772x_priv {
>  	unsigned short                    flag_hflip:1;
>  	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
>  	unsigned short                    band_filter;
> +	unsigned int			  fps;
>  };
> 
>  /*
> @@ -487,27 +507,35 @@ static const struct ov772x_color_format ov772x_cfmts[]
> = {
> 
>  static const struct ov772x_win_size ov772x_win_sizes[] = {
>  	{
> -		.name     = "VGA",
> -		.com7_bit = SLCT_VGA,
> +		.name		= "VGA",
> +		.com7_bit	= SLCT_VGA,
> +		.sizeimage	= 381480,

I'd write this 510 * 748.

>  		.rect = {
> -			.left = 140,
> -			.top = 14,
> -			.width = VGA_WIDTH,
> -			.height = VGA_HEIGHT,
> +			.left	= 140,
> +			.top	= 14,
> +			.width	= VGA_WIDTH,
> +			.height	= VGA_HEIGHT,
>  		},
>  	}, {
> -		.name     = "QVGA",
> -		.com7_bit = SLCT_QVGA,
> +		.name		= "QVGA",
> +		.com7_bit	= SLCT_QVGA,
> +		.sizeimage	= 160128,

And this 278 * 576. It makes the value less magic.

>  		.rect = {
> -			.left = 252,
> -			.top = 6,
> -			.width = QVGA_WIDTH,
> -			.height = QVGA_HEIGHT,
> +			.left	= 252,
> +			.top	= 6,
> +			.width	= QVGA_WIDTH,
> +			.height	= QVGA_HEIGHT,
>  		},
>  	},
>  };
> 
>  /*
> + * frame rate settings lists
> + */
> +unsigned int ov772x_frame_intervals[] = { 5, 10, 15, 20, 30, 60 };
> +#define OV772X_N_FRAME_INTERVALS ARRAY_SIZE(ov772x_frame_intervals)
> +
> +/*
>   * general function
>   */
> 
> @@ -574,6 +602,124 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int
> enable) return 0;
>  }
> 
> +static int ov772x_set_frame_rate(struct ov772x_priv *priv,
> +				 struct v4l2_fract *tpf,
> +				 const struct ov772x_color_format *cfmt,
> +				 const struct ov772x_win_size *win)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> +	unsigned int fps = tpf->denominator / tpf->numerator;

tpf->numerator could be 0.

> +	unsigned int fin = clk_get_rate(priv->clk);

Clock rates are unsigned long.

> +	unsigned int rate_prev;
> +	unsigned int fsize;
> +	unsigned int pclk;
> +	unsigned int rate;
> +	unsigned int idx;
> +	unsigned int i;
> +	u8 clkrc = 0;
> +	u8 com4 = 0;
> +	int ret;
> +
> +	/* Approximate to the closest supported frame interval. */
> +	rate_prev = ~0L;
> +	for (i = 0, idx = 0; i < OV772X_N_FRAME_INTERVALS; i++) {
> +		rate = abs(fps - ov772x_frame_intervals[i]);
> +		if (rate < rate_prev) {
> +			idx = i;
> +			rate_prev = rate;

I'd call the rate_prev and rate variables best_diff and diff respectively.

> +		}
> +	}
> +	fps = ov772x_frame_intervals[idx];
> +
> +	/* Use image size (with blankings) to calculate desired pixel clock. */
> +	if ((cfmt->com7 & OFMT_RGB) == OFMT_RGB ||
> +	    (cfmt->com7 & OFMT_YUV) == OFMT_YUV)
> +		fsize = win->sizeimage * 2;
> +	else if ((cfmt->com7 & OFMT_BRAW) == OFMT_BRAW)

I think all these should test (cfmt->com7 & OFMT_MASK) == ...

> +		fsize = win->sizeimage;
> +
> +	pclk = fps * fsize;
> +
> +	/*
> +	 * Pixel clock generation circuit is pretty simple:
> +	 *
> +	 * Fin -> [ / CLKRC_div] -> [ * PLL_mult] -> pclk
> +	 *
> +	 * Try to approximate the desired pixel clock testing all available
> +	 * PLL multipliers (1x, 4x, 6x, 8x) and calculate corresponding
> +	 * divisor with:
> +	 *
> +	 * div = PLL_mult * Fin / pclk
> +	 *
> +	 * and re-calculate the pixel clock using it:
> +	 *
> +	 * pclk = Fin * PLL_mult / CLKRC_div
> +	 *
> +	 * Choose the PLL_mult and CLKRC_div pair that gives a pixel clock
> +	 * closer to the desired one.
> +	 *
> +	 * The desired pixel clock is calculated using a known frame size
> +	 * (blanking included) and FPS.
> +	 */
> +	rate_prev = ~0L;
> +	for (i = 0; i < OV772X_PLL_N_MULT; i++) {
> +		unsigned int pll_mult = ov772x_pll_mult[i];
> +		unsigned int pll_out = pll_mult * fin;
> +		unsigned int t_pclk;
> +		unsigned int div;
> +
> +		if (pll_out < pclk)
> +			continue;
> +
> +		div = DIV_ROUND_CLOSEST(pll_out, pclk);
> +		t_pclk = DIV_ROUND_CLOSEST((fin * pll_mult), div);

No need for the inner parentheses.

> +		rate = abs(pclk - t_pclk);
> +		if (rate < rate_prev) {
> +			rate_prev = rate;
> +			clkrc = CLKRC_DIV(div);
> +			com4 = ov772x_com4_vals[i];
> +		}
> +	}
> +
> +	ret = ov772x_write(client, COM4, com4 | COM4_RESERVED);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov772x_write(client, CLKRC, clkrc | CLKRC_RESERVED);
> +	if (ret < 0)
> +		return ret;
> +
> +	tpf->numerator = 1;
> +	tpf->denominator = fps;
> +	priv->fps = tpf->denominator;
> +
> +	return 0;
> +}
> +
> +static int ov772x_g_frame_interval(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_frame_interval *ival)
> +{
> +	struct ov772x_priv *priv = to_ov772x(sd);
> +	struct v4l2_fract *tpf = &ival->interval;
> +
> +	memset(ival->reserved, 0, sizeof(ival->reserved));
> +	tpf->numerator = 1;
> +	tpf->denominator = priv->fps;
> +
> +	return 0;
> +}
> +
> +static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_frame_interval *ival)
> +{
> +	struct ov772x_priv *priv = to_ov772x(sd);
> +	struct v4l2_fract *tpf = &ival->interval;
> +
> +	memset(ival->reserved, 0, sizeof(ival->reserved));
> +
> +	return ov772x_set_frame_rate(priv, tpf, priv->cfmt, priv->win);
> +}
> +
>  static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct ov772x_priv *priv = container_of(ctrl->handler,
> @@ -757,6 +903,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  			     const struct ov772x_win_size *win)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> +	struct v4l2_fract tpf;
>  	int ret;
>  	u8  val;
> 
> @@ -885,6 +1032,13 @@ static int ov772x_set_params(struct ov772x_priv *priv,
> if (ret < 0)
>  		goto ov772x_set_fmt_error;
> 
> +	/* COM4, CLKRC: Set pixel clock and framerate. */
> +	tpf.numerator = 1;
> +	tpf.denominator = priv->fps;
> +	ret = ov772x_set_frame_rate(priv, &tpf, cfmt, win);
> +	if (ret < 0)
> +		goto ov772x_set_fmt_error;
> +
>  	/*
>  	 * set COM8
>  	 */
> @@ -1043,6 +1197,24 @@ static const struct v4l2_subdev_core_ops
> ov772x_subdev_core_ops = { .s_power	= ov772x_s_power,
>  };
> 
> +static int ov772x_enum_frame_interval(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_frame_interval_enum *fie)
> +{
> +	if (fie->pad || fie->index >= OV772X_N_FRAME_INTERVALS)
> +		return -EINVAL;
> +
> +	if (fie->width != VGA_WIDTH && fie->width != QVGA_WIDTH)
> +		return -EINVAL;
> +	if (fie->height != VGA_HEIGHT && fie->height != QVGA_HEIGHT)
> +		return -EINVAL;
> +
> +	fie->interval.numerator = 1;
> +	fie->interval.denominator = ov772x_frame_intervals[fie->index];
> +
> +	return 0;
> +}

The more I think about it, the more I believe that the subdev frame interval 
enumeration operation is nonsense. This particular sensor is not restricted to 
a fixed list of frame intervals. Sensors should really expose the pixel clock 
and blanking as controls, and higher level parameters such as frame intervals 
should then be handled by the bridge driver.

I won't nack this patch due to this as I want to see this series merged, so 
with the above small issues fixed you have my

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

but we're going in the wrong direction. 

-- 
Regards,

Laurent Pinchart
