Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35417 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501AbcAYOor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 09:44:47 -0500
Subject: Re: [PATCH] media: i2c: adv7604: Use v4l2-dv-timings helpers
To: Jean-Michel Hautbois <jhautbois@gmail.com>,
	linux-media@vger.kernel.org
References: <1452701906-4774-1-git-send-email-jean-michel.hautbois@veo-labs.com>
Cc: hans.verkuil@cisco.com, mchehab@osg.samsung.com, lars@metafoo.de,
	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A634C9.1030709@xs4all.nl>
Date: Mon, 25 Jan 2016 15:44:25 +0100
MIME-Version: 1.0
In-Reply-To: <1452701906-4774-1-git-send-email-jean-michel.hautbois@veo-labs.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2016 05:18 PM, Jean-Michel Hautbois wrote:
> Use the helper to enumerate and set DV timings instead of a custom code.
> This will ease debugging too, as it is consistent with other drivers.
> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>

Close, but no cigar. You missed the V4L2_DV_BT_CEA_1280X720P30 exception:
that format is not supported by the adv hardware and needs to be filtered
out. See adv7842_check_dv_timings in adv7842.c and copy it over to the
adv7604. That format has a very large blanking period, exceeding the number
of bits for the corresponding ADV counter in the hardware.

Regards,

	Hans

> ---
>  drivers/media/i2c/adv7604.c | 98 +++++++++++++++++++++++----------------------
>  1 file changed, 51 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 7452862..19c1ccf 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -806,6 +806,36 @@ static inline bool is_digital_input(struct v4l2_subdev *sd)
>  	       state->selected_input == ADV7604_PAD_HDMI_PORT_D;
>  }
>  
> +static const struct v4l2_dv_timings_cap adv7604_timings_cap_analog = {
> +	.type = V4L2_DV_BT_656_1120,
> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> +	.reserved = { 0 },
> +	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
> +		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
> +			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
> +		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
> +			V4L2_DV_BT_CAP_CUSTOM)
> +};
> +
> +static const struct v4l2_dv_timings_cap adv76xx_timings_cap_digital = {
> +	.type = V4L2_DV_BT_656_1120,
> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> +	.reserved = { 0 },
> +	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
> +		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
> +			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
> +		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
> +			V4L2_DV_BT_CAP_CUSTOM)
> +};
> +
> +static inline const struct v4l2_dv_timings_cap *
> +adv76xx_get_dv_timings_cap(struct v4l2_subdev *sd)
> +{
> +	return is_digital_input(sd) ? &adv76xx_timings_cap_digital :
> +				      &adv7604_timings_cap_analog;
> +}
> +
> +
>  /* ----------------------------------------------------------------------- */
>  
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> @@ -1330,17 +1360,23 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
>  	u32 pix_clk;
>  	int i;
>  
> -	for (i = 0; adv76xx_timings[i].bt.height; i++) {
> -		if (vtotal(&adv76xx_timings[i].bt) != stdi->lcf + 1)
> +	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
> +		const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
> +
> +		if (!v4l2_valid_dv_timings(&v4l2_dv_timings_presets[i],
> +					   adv76xx_get_dv_timings_cap(sd),
> +					   NULL, NULL))
> +			continue;
> +		if (vtotal(bt) != stdi->lcf + 1)
>  			continue;
> -		if (adv76xx_timings[i].bt.vsync != stdi->lcvs)
> +		if (bt->vsync != stdi->lcvs)
>  			continue;
>  
> -		pix_clk = hfreq * htotal(&adv76xx_timings[i].bt);
> +		pix_clk = hfreq * htotal(bt);
>  
> -		if ((pix_clk < adv76xx_timings[i].bt.pixelclock + 1000000) &&
> -		    (pix_clk > adv76xx_timings[i].bt.pixelclock - 1000000)) {
> -			*timings = adv76xx_timings[i];
> +		if ((pix_clk < bt->pixelclock + 1000000) &&
> +		    (pix_clk > bt->pixelclock - 1000000)) {
> +			*timings = v4l2_dv_timings_presets[i];
>  			return 0;
>  		}
>  	}
> @@ -1431,9 +1467,8 @@ static int adv76xx_enum_dv_timings(struct v4l2_subdev *sd,
>  	if (timings->pad >= state->source_pad)
>  		return -EINVAL;
>  
> -	memset(timings->reserved, 0, sizeof(timings->reserved));
> -	timings->timings = adv76xx_timings[timings->index];
> -	return 0;
> +	return v4l2_enum_dv_timings_cap(timings,
> +		adv76xx_get_dv_timings_cap(sd), NULL, NULL);
>  }
>  
>  static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
> @@ -1444,29 +1479,7 @@ static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
>  	if (cap->pad >= state->source_pad)
>  		return -EINVAL;
>  
> -	cap->type = V4L2_DV_BT_656_1120;
> -	cap->bt.max_width = 1920;
> -	cap->bt.max_height = 1200;
> -	cap->bt.min_pixelclock = 25000000;
> -
> -	switch (cap->pad) {
> -	case ADV76XX_PAD_HDMI_PORT_A:
> -	case ADV7604_PAD_HDMI_PORT_B:
> -	case ADV7604_PAD_HDMI_PORT_C:
> -	case ADV7604_PAD_HDMI_PORT_D:
> -		cap->bt.max_pixelclock = 225000000;
> -		break;
> -	case ADV7604_PAD_VGA_RGB:
> -	case ADV7604_PAD_VGA_COMP:
> -	default:
> -		cap->bt.max_pixelclock = 170000000;
> -		break;
> -	}
> -
> -	cap->bt.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
> -			 V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT;
> -	cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
> -		V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM;
> +	*cap = *adv76xx_get_dv_timings_cap(sd);
>  	return 0;
>  }
>  
> @@ -1475,15 +1488,9 @@ static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
>  static void adv76xx_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
>  		struct v4l2_dv_timings *timings)
>  {
> -	int i;
> -
> -	for (i = 0; adv76xx_timings[i].bt.width; i++) {
> -		if (v4l2_match_dv_timings(timings, &adv76xx_timings[i],
> -				is_digital_input(sd) ? 250000 : 1000000, false)) {
> -			*timings = adv76xx_timings[i];
> -			break;
> -		}
> -	}
> +	v4l2_find_dv_timings_cap(timings, adv76xx_get_dv_timings_cap(sd),
> +			is_digital_input(sd) ? 250000 : 1000000,
> +			NULL, NULL);
>  }
>  
>  static unsigned int adv7604_read_hdmi_pixelclock(struct v4l2_subdev *sd)
> @@ -1651,12 +1658,9 @@ static int adv76xx_s_dv_timings(struct v4l2_subdev *sd,
>  
>  	bt = &timings->bt;
>  
> -	if ((is_analog_input(sd) && bt->pixelclock > 170000000) ||
> -			(is_digital_input(sd) && bt->pixelclock > 225000000)) {
> -		v4l2_dbg(1, debug, sd, "%s: pixelclock out of range %d\n",
> -				__func__, (u32)bt->pixelclock);
> +	if (!v4l2_valid_dv_timings(timings, adv76xx_get_dv_timings_cap(sd),
> +				   NULL, NULL))
>  		return -ERANGE;
> -	}
>  
>  	adv76xx_fill_optional_dv_timings_fields(sd, timings);
>  
> 

