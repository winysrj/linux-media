Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53539 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1GQQzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 12:55:32 -0400
Date: Sun, 17 Jul 2011 18:55:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] mt9m111: make use of testpattern
In-Reply-To: <1310485146-27759-5-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1107171854240.13485@axis700.grange>
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
 <1310485146-27759-5-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 12 Jul 2011, Michael Grzeschik wrote:

> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
> Changes v1 -> v2
> 	* removed ifdef DEBUG
> 
>  drivers/media/video/mt9m111.c |   57 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 57 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index 7eb2e4a..a3463d9 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -87,6 +87,7 @@
>   */
>  #define MT9M111_OPER_MODE_CTRL		0x106
>  #define MT9M111_OUTPUT_FORMAT_CTRL	0x108
> +#define MT9M111_TEST_PATTERN_GEN	0x148
>  #define MT9M111_REDUCER_XZOOM_B		0x1a0
>  #define MT9M111_REDUCER_XSIZE_B		0x1a1
>  #define MT9M111_REDUCER_YZOOM_B		0x1a3
> @@ -103,6 +104,15 @@
>  #define MT9M111_OPMODE_AUTOWHITEBAL_EN	(1 << 1)
>  #define MT9M111_OUTFMT_FLIP_BAYER_COL  (1 << 9)
>  #define MT9M111_OUTFMT_FLIP_BAYER_ROW  (1 << 8)
> +#define MT9M111_TST_PATT_OFF		(0 << 0)
> +#define MT9M111_TST_PATT_1		(1 << 0)
> +#define MT9M111_TST_PATT_2		(2 << 0)
> +#define MT9M111_TST_PATT_3		(3 << 0)
> +#define MT9M111_TST_PATT_4		(4 << 0)
> +#define MT9M111_TST_PATT_5		(5 << 0)
> +#define MT9M111_TST_PATT_6		(6 << 0)
> +#define MT9M111_TST_PATT_COLORBARS	(7 << 0)
> +#define MT9M111_TST_PATT_FORCE_WB_GAIN_1 (1 << 7)
>  #define MT9M111_OUTFMT_PROCESSED_BAYER	(1 << 14)
>  #define MT9M111_OUTFMT_BYPASS_IFP	(1 << 10)
>  #define MT9M111_OUTFMT_INV_PIX_CLOCK	(1 << 9)
> @@ -138,6 +148,11 @@
>  #define MT9M111_MAX_HEIGHT	1024
>  #define MT9M111_MAX_WIDTH	1280
>  
> +static int testpattern;
> +module_param(testpattern, int, S_IRUGO);
> +MODULE_PARM_DESC(testpattern, "Test pattern: a number from 1 to 10, 0 for "
> +		"normal usage");
> +

I already replied, that I do not like using a module parameter for this.

Thanks
Guennadi

>  /* MT9M111 has only one fixed colorspace per pixelcode */
>  struct mt9m111_datafmt {
>  	enum v4l2_mbus_pixelcode	code;
> @@ -464,6 +479,7 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
>  			      enum v4l2_mbus_pixelcode code)
>  {
>  	u16 data_outfmt1 = 0, data_outfmt2 = 0, mask_outfmt1, mask_outfmt2;
> +	u16 pattern = 0;
>  	int ret = 0;
>  
>  	switch (code) {
> @@ -531,6 +547,47 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
>  	if (!ret)
>  		ret = reg_mask(OUTPUT_FORMAT_CTRL, data_outfmt1, mask_outfmt1);
>  
> +	switch (testpattern) {
> +	case 1:
> +		pattern = MT9M111_TST_PATT_1 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
> +		break;
> +	case 2:
> +		pattern = MT9M111_TST_PATT_2 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
> +		break;
> +	case 3:
> +		pattern = MT9M111_TST_PATT_3 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
> +		break;
> +	case 4:
> +		pattern = MT9M111_TST_PATT_4 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
> +		break;
> +	case 5:
> +		pattern = MT9M111_TST_PATT_5 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
> +		break;
> +	case 6:
> +		pattern = MT9M111_TST_PATT_6 | MT9M111_TST_PATT_FORCE_WB_GAIN_1;
> +		break;
> +	case 7:
> +		pattern = MT9M111_TST_PATT_COLORBARS |
> +			MT9M111_TST_PATT_FORCE_WB_GAIN_1;
> +		break;
> +	case 8:
> +		data_outfmt2 |= MT9M111_OUTFMT_TST_RAMP_COL;
> +		break;
> +	case 9:
> +		data_outfmt2 |= MT9M111_OUTFMT_TST_RAMP_ROW;
> +		break;
> +	case 10:
> +		data_outfmt2 |= MT9M111_OUTFMT_TST_RAMP_FRAME;
> +		break;
> +	}
> +
> +	dev_dbg(&client->dev, "%s: using testpattern %d\n", __func__,
> +			testpattern);
> +
> +	if (!ret)
> +		ret = mt9m111_reg_set(client,
> +				MT9M111_TEST_PATTERN_GEN, pattern);
> +
>  	if (!ret)
>  		ret = reg_mask(OUTPUT_FORMAT_CTRL2_A, data_outfmt2,
>  			mask_outfmt2);
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
