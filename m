Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44572 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbKINV5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 08:21:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Mon, 09 Nov 2015 15:22:06 +0200
Message-ID: <2275245.3FVoKjERuu@avalon>
In-Reply-To: <1446815625-18413-3-git-send-email-mpa@pengutronix.de>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de> <1446815625-18413-3-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Thank you for the patch.

On Friday 06 November 2015 14:13:45 Markus Pargmann wrote:
> This patch adds V4L2 controls for Auto Exposure Control and Auto Gain
> Control settings. These settings include low pass filter, update
> frequency of these settings and the update interval for those units.
> 
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
>  drivers/media/i2c/mt9v032.c | 153 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 153 insertions(+)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 943c3f39ea73..978ae8cbb0cc 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -133,9 +133,16 @@
>  #define		MT9V032_TEST_PATTERN_GRAY_DIAGONAL	(3 << 11)
>  #define		MT9V032_TEST_PATTERN_ENABLE		(1 << 13)
>  #define		MT9V032_TEST_PATTERN_FLIP		(1 << 14)
> +#define MT9V032_AEC_LPF					0xa8
> +#define MT9V032_AGC_LPF					0xaa
> +#define MT9V032_DESIRED_BIN				0xa5

To better match the datasheet, could you call this MT9V032_AEGC_DESIRED_BIN ? 
Same comment for the related control name.

> +#define MT9V032_AEC_UPDATE_INTERVAL			0xa6
> +#define MT9V032_AGC_UPDATE_INTERVAL			0xa9

Simalarly I'd call these two registers MT9V032_AEC_UPDATE_FREQUENCY and 
MT9V032_AGC_UPDATE_FREQUENCY as that's how they're named in the datasheet (at 
least the version I have). It makes sense to keep using interval in the 
control names though, as that's how they operate.

Could you please keep the registers sorted numerically ?

>  #define MT9V032_AEC_AGC_ENABLE				0xaf
>  #define		MT9V032_AEC_ENABLE			(1 << 0)
>  #define		MT9V032_AGC_ENABLE			(1 << 1)
> +#define MT9V024_AEC_MAX_SHUTTER_WIDTH			0xad

As other registers specific to the MT9V024 and MT9V034 use the MT9V034 prefix, 
could you do so here as well ?

Would it make sense to add the minimum shutter width too ?

> +#define MT9V032_AEC_MAX_SHUTTER_WIDTH			0xbd
>  #define MT9V032_THERMAL_INFO				0xc1
> 
>  enum mt9v032_model {
> @@ -162,6 +169,7 @@ struct mt9v032_model_data {
>  	unsigned int min_shutter;
>  	unsigned int max_shutter;
>  	unsigned int pclk_reg;
> +	unsigned int aec_max_shutter_reg;
>  };
> 
>  struct mt9v032_model_info {
> @@ -185,6 +193,7 @@ static const struct mt9v032_model_data
> mt9v032_model_data[] = { .min_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
>  		.max_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
>  		.pclk_reg = MT9V032_PIXEL_CLOCK,
> +		.aec_max_shutter_reg = MT9V032_AEC_MAX_SHUTTER_WIDTH,
>  	}, {
>  		/* MT9V024, MT9V034 */
>  		.min_row_time = 690,
> @@ -194,6 +203,7 @@ static const struct mt9v032_model_data
> mt9v032_model_data[] = { .min_shutter = MT9V034_TOTAL_SHUTTER_WIDTH_MIN,
>  		.max_shutter = MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
>  		.pclk_reg = MT9V034_PIXEL_CLOCK,
> +		.aec_max_shutter_reg = MT9V024_AEC_MAX_SHUTTER_WIDTH,
>  	},
>  };
> 
> @@ -265,6 +275,12 @@ struct mt9v032 {
>  	struct {
>  		struct v4l2_ctrl *test_pattern;
>  		struct v4l2_ctrl *test_pattern_color;
> +		struct v4l2_ctrl *desired_bin;
> +		struct v4l2_ctrl *aec_lpf;
> +		struct v4l2_ctrl *agc_lpf;
> +		struct v4l2_ctrl *aec_update_interval;
> +		struct v4l2_ctrl *agc_update_interval;
> +		struct v4l2_ctrl *aec_max_shutter_width;

You don't need to store all those controls in the mt9v032 structure as you 
don't use the pointers anywhere. The reason why the test_pattern and 
test_pattern_color controls are stored there is that they both affect the same 
register and are thus grouped into a control cluster.

>  	};
>  };
> 
> @@ -643,6 +659,33 @@ static int mt9v032_set_selection(struct v4l2_subdev
> *subdev, */
> 
>  #define V4L2_CID_TEST_PATTERN_COLOR	(V4L2_CID_USER_BASE | 0x1001)
> +/*
> + * Value between 1 and 64 to set the desired bin. This is effectively a
> measure
> + * of how bright the image is supposed to be. Both AGC and AEC try to reach
> + * this.
> + */

Do you know what the value represents exactly ? Does it have a linear 
relationship with the overall image luminance ? Is it related to image binning 
at all ?

> +#define V4L2_CID_DESIRED_BIN		(V4L2_CID_USER_BASE | 0x1002)
> +/*
> + * LPF is the low pass filter capability of the chip. Both AEC and AGC have
> + * this setting. This limits the speed in which AGC/AEC adjust their
> settings.
> + * Possible values are 0-2. 0 means no LPF. For 1 and 2 this equation is
> used:
> + * 	if |(Calculated new exp - current exp)| > (current exp / 4)
> + * 		next exp = Calculated new exp
> + * 	else
> + * 		next exp = Current exp +- (Calculated new exp / 2^LPF)

I know this comes directly from the datasheet, but it doesn't make too much 
sense to me. I wonder whether the correct formula wouldn't be

next exp = current exp + ((calculated new exp - current exp) / 2^LPF)

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
> 
>  static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> @@ -712,6 +755,28 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>  			break;
>  		}
>  		return regmap_write(map, MT9V032_TEST_PATTERN, data);
> +
> +	case V4L2_CID_DESIRED_BIN:
> +		return regmap_write(map, MT9V032_DESIRED_BIN, ctrl->val);
> +
> +	case V4L2_CID_AEC_LPF:
> +		return regmap_write(map, MT9V032_AEC_LPF, ctrl->val);
> +
> +	case V4L2_CID_AGC_LPF:
> +		return regmap_write(map, MT9V032_AGC_LPF, ctrl->val);
> +
> +	case V4L2_CID_AEC_UPDATE_INTERVAL:
> +		return regmap_write(map, MT9V032_AEC_UPDATE_INTERVAL,
> +				    ctrl->val);
> +
> +	case V4L2_CID_AGC_UPDATE_INTERVAL:
> +		return regmap_write(map, MT9V032_AGC_UPDATE_INTERVAL,
> +				    ctrl->val);
> +
> +	case V4L2_CID_AEC_MAX_SHUTTER_WIDTH:
> +		return regmap_write(map,
> +				    mt9v032->model->data->aec_max_shutter_reg,
> +				    ctrl->val);
>  	}
> 
>  	return 0;
> @@ -741,6 +806,78 @@ static const struct v4l2_ctrl_config
> mt9v032_test_pattern_color = { .flags		= 0,
>  };
> 
> +static const struct v4l2_ctrl_config mt9v032_desired_bin = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_DESIRED_BIN,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "aec_agc_desired_bin",

Please use proper controls names.

> +	.min		= 1,
> +	.max		= 64,
> +	.step		= 1,
> +	.def		= 58,
> +	.flags		= 0,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v032_aec_lpf = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_AEC_LPF,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "aec_lpf",
> +	.min		= 0,
> +	.max		= 2,
> +	.step		= 1,
> +	.def		= 0,
> +	.flags		= 0,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v032_agc_lpf = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_AGC_LPF,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "agc_lpf",
> +	.min		= 0,
> +	.max		= 2,
> +	.step		= 1,
> +	.def		= 2,
> +	.flags		= 0,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v032_aec_update_interval = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_AEC_UPDATE_INTERVAL,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "aec_update_interval",
> +	.min		= 0,
> +	.max		= 16,
> +	.step		= 1,
> +	.def		= 2,
> +	.flags		= 0,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v032_agc_update_interval = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_AGC_UPDATE_INTERVAL,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "agc_update_interval",
> +	.min		= 0,
> +	.max		= 16,
> +	.step		= 1,
> +	.def		= 2,
> +	.flags		= 0,
> +};
> +
> +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width = {
> +	.ops		= &mt9v032_ctrl_ops,
> +	.id		= V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> +	.name		= "aec_max_shutter_width",
> +	.min		= 1,
> +	.max		= MT9V034_TOTAL_SHUTTER_WIDTH_MAX,

Isn't the maximum value 2047 for the MT9V0[23]2 ?

> +	.step		= 1,
> +	.def		= MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> +	.flags		= 0,
> +};
> +
>  /*
> ---------------------------------------------------------------------------
> -- * V4L2 subdev core operations
>   */
> @@ -1010,6 +1147,22 @@ static int mt9v032_probe(struct i2c_client *client,
>  				mt9v032_test_pattern_menu);
>  	mt9v032->test_pattern_color = v4l2_ctrl_new_custom(&mt9v032->ctrls,
>  				      &mt9v032_test_pattern_color, NULL);
> +	mt9v032->desired_bin = v4l2_ctrl_new_custom(&mt9v032->ctrls,
> +						    &mt9v032_desired_bin,
> +						    NULL);
> +	mt9v032->aec_lpf = v4l2_ctrl_new_custom(&mt9v032->ctrls,
> +						&mt9v032_aec_lpf, NULL);
> +	mt9v032->agc_lpf = v4l2_ctrl_new_custom(&mt9v032->ctrls,
> +						&mt9v032_agc_lpf, NULL);
> +	mt9v032->aec_update_interval = v4l2_ctrl_new_custom(&mt9v032->ctrls,
> +						&mt9v032_aec_update_interval,
> +						NULL);
> +	mt9v032->agc_update_interval = v4l2_ctrl_new_custom(&mt9v032->ctrls,
> +						&mt9v032_agc_update_interval,
> +						NULL);
> +	mt9v032->aec_max_shutter_width = v4l2_ctrl_new_custom(&mt9v032->ctrls,
> +						&mt9v032_aec_max_shutter_width,
> +						NULL);

As there's no need to store the control pointers I would create an array of 
struct v4l2_ctrl_config above instead of defining one variable per control, 
and then loop over the array here.

        for (i = 0; i < ARRAY_SIZE(mt9v032_aegc_controls); ++i)
                v4l2_ctrl_new_custom(&mt9v032->ctrls,
                                     &mt9v032_aegc_controls[i]);

You should also update the above v4l2_ctrl_handler_init() call to take the new 
controls into account, as that will improve performances of the control 
framework.

        v4l2_ctrl_handler_init(&mt9v032->ctrls,
                               10 + ARRAY_SIZE(mt9v032_aegc_controls));

> 
>  	v4l2_ctrl_cluster(2, &mt9v032->test_pattern);

-- 
Regards,

Laurent Pinchart

