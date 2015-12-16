Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42942 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbbLPHsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 02:48:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Wed, 16 Dec 2015 09:47:58 +0200
Message-ID: <290053152.GcUooHzFZY@avalon>
In-Reply-To: <1450104113-6392-3-git-send-email-mpa@pengutronix.de>
References: <1450104113-6392-1-git-send-email-mpa@pengutronix.de> <1450104113-6392-3-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Thank you for the patch.

On Monday 14 December 2015 15:41:53 Markus Pargmann wrote:
> This patch adds V4L2 controls for Auto Exposure Control and Auto Gain
> Control settings. These settings include low pass filter, update
> frequency of these settings and the update interval for those units.
> 
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>

Please see below for a few comments. If you agree about them there's no need 
to resubmit, I'll fix the patch when applying.

> ---
>  drivers/media/i2c/mt9v032.c | 153 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 152 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index cc16acf001de..6cbc3b87eda9 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c

[snip]

>  enum mt9v032_model {
> @@ -162,6 +169,8 @@ struct mt9v032_model_data {
>  	unsigned int min_shutter;
>  	unsigned int max_shutter;
>  	unsigned int pclk_reg;
> +	unsigned int aec_max_shutter_reg;
> +	const struct v4l2_ctrl_config * const aec_max_shutter_v4l2_ctrl;
>  };
> 
>  struct mt9v032_model_info {
> @@ -175,6 +184,9 @@ static const struct mt9v032_model_version
> mt9v032_versions[] = { { MT9V034_CHIP_ID_REV1, "MT9V024/MT9V034 rev1" },
>  };
> 
> +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width;
> +static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_width;

We can avoid forward declarations by moving the mt9v032_model_data array 
further down in the driver.

>  static const struct mt9v032_model_data mt9v032_model_data[] = {
>  	{
>  		/* MT9V022, MT9V032 revisions 1/2/3 */

[snip]

> @@ 647,6 +663,33 @@ static int mt9v032_set_selection(struct v4l2_subdev
> *subdev, */
> 
>  #define V4L2_CID_TEST_PATTERN_COLOR	(V4L2_CID_USER_BASE | 0x1001)
> +/*
> + * Value between 1 and 64 to set the desired bin. This is effectively a
> measure + * of how bright the image is supposed to be. Both AGC and AEC try
> to reach + * this.
> + */
> +#define V4L2_CID_AEGC_DESIRED_BIN		(V4L2_CID_USER_BASE | 0x1002)
> +/*
> + * LPF is the low pass filter capability of the chip. Both AEC and AGC have
> + * this setting. This limits the speed in which AGC/AEC adjust their
> settings.
> + * Possible values are 0-2. 0 means no LPF. For 1 and 2 this equation is
> used:
> + * 	if |(Calculated new exp - current exp)| > (current exp / 4)
> + * 		next exp = Calculated new exp
> + * 	else
> + * 		next exp = Current exp + ((Calculated new exp - current exp) / 
2^LPF)

Over 80 columns, you can fix it by just reducing the indentation by one tab.

> + */
> +#define V4L2_CID_AEC_LPF		(V4L2_CID_USER_BASE | 0x1003)
> +#define V4L2_CID_AGC_LPF		(V4L2_CID_USER_BASE | 0x1004)
> +/*
> + * Value between 0 and 15. This is the number of frames being skipped
> before
> + * updating the auto exposure/gain.
> + */
> +#define V4L2_CID_AEC_UPDATE_INTERVAL	(V4L2_CID_USER_BASE | 0x1005)
> +#define V4L2_CID_AGC_UPDATE_INTERVAL	(V4L2_CID_USER_BASE | 0x1006)
> +/*
> + * Maximum shutter width used for AEC.
> + */
> +#define V4L2_CID_AEC_MAX_SHUTTER_WIDTH	(V4L2_CID_USER_BASE | 0x1007)

[snip]

> @@ -745,6 +810,84 @@ static const struct v4l2_ctrl_config
> mt9v032_test_pattern_color = { .flags		= 0,
>  };
> 
> +static const struct v4l2_ctrl_config mt9v032_aegc_controls[] = {
> +	{
> +		.ops		= &mt9v032_ctrl_ops,
> +		.id		= V4L2_CID_AEGC_DESIRED_BIN,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "aec_agc_desired_bin",

I forgot to reply to your e-mail asking what proper controls names would be, 
sorry.

V4L2 control names contain spaces and use uppercase as needed. This one could 
be "AEC/AGC Desired Bin" for instance.

> +		.min		= 1,
> +		.max		= 64,
> +		.step		= 1,
> +		.def		= 58,
> +		.flags		= 0,
> +	}, {
> +		.ops		= &mt9v032_ctrl_ops,
> +		.id		= V4L2_CID_AEC_LPF,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "aec_lpf",
> +		.min		= 0,
> +		.max		= 2,
> +		.step		= 1,
> +		.def		= 0,
> +		.flags		= 0,
> +	}, {
> +		.ops		= &mt9v032_ctrl_ops,
> +		.id		= V4L2_CID_AGC_LPF,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "agc_lpf",
> +		.min		= 0,
> +		.max		= 2,
> +		.step		= 1,
> +		.def		= 2,
> +		.flags		= 0,
> +	}, {
> +		.ops		= &mt9v032_ctrl_ops,
> +		.id		= V4L2_CID_AEC_UPDATE_INTERVAL,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "aec_update_interval",
> +		.min		= 0,
> +		.max		= 16,
> +		.step		= 1,
> +		.def		= 2,
> +		.flags		= 0,
> +	}, {
> +		.ops		= &mt9v032_ctrl_ops,
> +		.id		= V4L2_CID_AGC_UPDATE_INTERVAL,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "agc_update_interval",
> +		.min		= 0,
> +		.max		= 16,
> +		.step		= 1,
> +		.def		= 2,
> +		.flags		= 0,
> +	}
> +};
> +
> +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "aec_max_shutter_width",
> +	.min		= 1,
> +	.max		= MT9V032_TOTAL_SHUTTER_WIDTH_MAX,

According the the MT9V032 datasheet I have, the maximum value is 2047 while 
MT9V032_TOTAL_SHUTTER_WIDTH_MAX is defined as 32767. Do you have any 
information that would hint for an error in the datasheet ?

> +	.step		= 1,
> +	.def		= MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> +	.flags		= 0,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_width = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "aec_max_shutter_width",
> +	.min		= 1,
> +	.max		= MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
> +	.step		= 1,
> +	.def		= MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> +	.flags		= 0,
> +};

[snip]

-- 
Regards,

Laurent Pinchart

