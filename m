Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39819 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391AbbEOJ6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 05:58:19 -0400
Message-ID: <5555C32D.4020006@xs4all.nl>
Date: Fri, 15 May 2015 11:58:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 1/4] v4l2-dv-timings: Add interlace support in detect
 cvt/gtf
References: <1429779591-26134-1-git-send-email-prladdha@cisco.com> <1429779591-26134-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1429779591-26134-2-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prashant,

Sorry for the very late review, I finally have time today to go through
my pending patches.

I have one question, see below:

On 04/23/2015 10:59 AM, Prashant Laddha wrote:
> Extended detect_cvt/gtf API to indicate the format type (interlaced
> or progressive). In case of interlaced, the vertical front and back
> porch and vsync values for both (odd,even) fields are considered to
> derive image height. Populated vsync, verical front, back porch
> values in bt timing structure for even and odd fields and updated
> the flags appropriately.
> 
> Also modified the functions calling the detect_cvt/gtf(). As of now
> these functions are calling detect_cvt/gtf() with interlaced flag
> set to false.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Martin Bugge <marbugge@cisco.com>
> Cc: Mats Randgaard <matrandg@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
> ---
>  drivers/media/i2c/adv7604.c                  |  4 +--
>  drivers/media/i2c/adv7842.c                  |  4 +--
>  drivers/media/platform/vivid/vivid-vid-cap.c |  5 ++--
>  drivers/media/v4l2-core/v4l2-dv-timings.c    | 39 +++++++++++++++++++++++-----
>  include/media/v4l2-dv-timings.h              |  6 +++--
>  5 files changed, 44 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 60ffcf0..74abfd4 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1304,12 +1304,12 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
>  	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
>  			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
>  			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
> -			timings))
> +			false, timings))
>  		return 0;
>  	if (v4l2_detect_gtf(stdi->lcf + 1, hfreq, stdi->lcvs,
>  			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
>  			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
> -			state->aspect_ratio, timings))
> +			false, state->aspect_ratio, timings))
>  		return 0;
>  
>  	v4l2_dbg(2, debug, sd,
> diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
> index b5a37fe..90cbead 100644
> --- a/drivers/media/i2c/adv7842.c
> +++ b/drivers/media/i2c/adv7842.c
> @@ -1333,12 +1333,12 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
>  	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
>  			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
>  			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
> -			    timings))
> +			false, timings))
>  		return 0;
>  	if (v4l2_detect_gtf(stdi->lcf + 1, hfreq, stdi->lcvs,
>  			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
>  			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
> -			    state->aspect_ratio, timings))
> +			false, state->aspect_ratio, timings))
>  		return 0;
>  
>  	v4l2_dbg(2, debug, sd,
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index be10b72..a3b19dc 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -1623,7 +1623,7 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
>  
>  	if (bt->standards == 0 || (bt->standards & V4L2_DV_BT_STD_CVT)) {
>  		if (v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync,
> -				    bt->polarities, timings))
> +				    bt->polarities, false, timings))
>  			return true;
>  	}
>  
> @@ -1634,7 +1634,8 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
>  				  &aspect_ratio.numerator,
>  				  &aspect_ratio.denominator);
>  		if (v4l2_detect_gtf(total_v_lines, h_freq, bt->vsync,
> -				    bt->polarities, aspect_ratio, timings))
> +				    bt->polarities, false,
> +				    aspect_ratio, timings))
>  			return true;
>  	}
>  	return false;
> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
> index 37f0d6f..86e11d1 100644
> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
> @@ -338,6 +338,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
>   * @vsync - the height of the vertical sync in lines.
>   * @polarities - the horizontal and vertical polarities (same as struct
>   *		v4l2_bt_timings polarities).
> + * @interlaced - if this flag is true, it indicates interlaced format
>   * @fmt - the resulting timings.
>   *
>   * This function will attempt to detect if the given values correspond to a
> @@ -349,7 +350,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
>   * detection function.
>   */
>  bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
> -		u32 polarities, struct v4l2_dv_timings *fmt)
> +		u32 polarities, bool interlaced, struct v4l2_dv_timings *fmt)
>  {
>  	int  v_fp, v_bp, h_fp, h_bp, hsync;
>  	int  frame_width, image_height, image_width;
> @@ -384,7 +385,11 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
>  		if (v_bp < CVT_MIN_V_BPORCH)
>  			v_bp = CVT_MIN_V_BPORCH;
>  	}
> -	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
> +
> +	if (interlaced)
> +		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp) & ~0x1;
> +	else
> +		image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
>  
>  	if (image_height < 0)
>  		return false;
> @@ -457,11 +462,20 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
>  	fmt->bt.hsync = hsync;
>  	fmt->bt.vsync = vsync;
>  	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
> -	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
> +	fmt->bt.vbackporch = v_bp;
>  	fmt->bt.pixelclock = pix_clk;
>  	fmt->bt.standards = V4L2_DV_BT_STD_CVT;
>  	if (reduced_blanking)
>  		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
> +	if (interlaced) {
> +		fmt->bt.interlaced = V4L2_DV_INTERLACED;
> +		fmt->bt.il_vfrontporch = v_fp;
> +		fmt->bt.il_vsync = vsync;
> +		fmt->bt.il_vbackporch = v_bp + 1;
> +		fmt->bt.flags |= V4L2_DV_FL_HALF_LINE;
> +	} else {
> +		fmt->bt.interlaced = V4L2_DV_PROGRESSIVE;
> +	}
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
> @@ -500,6 +514,7 @@ EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
>   * @vsync - the height of the vertical sync in lines.
>   * @polarities - the horizontal and vertical polarities (same as struct
>   *		v4l2_bt_timings polarities).
> + * @interlaced - if this flag is true, it indicates interlaced format
>   * @aspect - preferred aspect ratio. GTF has no method of determining the
>   *		aspect ratio in order to derive the image width from the
>   *		image height, so it has to be passed explicitly. Usually
> @@ -515,6 +530,7 @@ bool v4l2_detect_gtf(unsigned frame_height,
>  		unsigned hfreq,
>  		unsigned vsync,
>  		u32 polarities,
> +		bool interlaced,
>  		struct v4l2_fract aspect,
>  		struct v4l2_dv_timings *fmt)
>  {
> @@ -539,9 +555,11 @@ bool v4l2_detect_gtf(unsigned frame_height,
>  
>  	/* Vertical */
>  	v_fp = GTF_V_FP;
> -
>  	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 500000) / 1000000 - vsync;
> -	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
> +	if (interlaced)
> +		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp) & ~0x1;
> +	else
> +		image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
>  
>  	if (image_height < 0)
>  		return false;
> @@ -586,11 +604,20 @@ bool v4l2_detect_gtf(unsigned frame_height,
>  	fmt->bt.hsync = hsync;
>  	fmt->bt.vsync = vsync;
>  	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
> -	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
> +	fmt->bt.vbackporch = v_bp;

Is this change correct? My main concern comes from the earlier image_height calculation
in the chunk above. The image_height value is rounded to an even value, but if the value
is actually changed due to rounding, then one of the v_fp, vsync or v_bp values must
change by one as well. After all, the frame_height is fixed and image_height must be
even. And frame_height can be even or odd, both are possible. So that one line of rounding
difference must go somewhere in the blanking timings.

Regards,

	Hans

>  	fmt->bt.pixelclock = pix_clk;
>  	fmt->bt.standards = V4L2_DV_BT_STD_GTF;
>  	if (!default_gtf)
>  		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
> +	if (interlaced) {
> +		fmt->bt.interlaced = V4L2_DV_INTERLACED;
> +		fmt->bt.il_vfrontporch = v_fp;
> +		fmt->bt.il_vsync = vsync;
> +		fmt->bt.il_vbackporch = v_bp + 1;
> +		fmt->bt.flags |= V4L2_DV_FL_HALF_LINE;
> +	} else {
> +		fmt->bt.interlaced = V4L2_DV_PROGRESSIVE;
> +	}
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_detect_gtf);
> diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
> index 4becc67..eecd310 100644
> --- a/include/media/v4l2-dv-timings.h
> +++ b/include/media/v4l2-dv-timings.h
> @@ -117,6 +117,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
>   * @vsync - the height of the vertical sync in lines.
>   * @polarities - the horizontal and vertical polarities (same as struct
>   *		v4l2_bt_timings polarities).
> + * @interlaced - if this flag is true, it indicates interlaced format
>   * @fmt - the resulting timings.
>   *
>   * This function will attempt to detect if the given values correspond to a
> @@ -124,7 +125,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
>   * in with the found CVT timings.
>   */
>  bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
> -		u32 polarities, struct v4l2_dv_timings *fmt);
> +		u32 polarities, bool interlaced, struct v4l2_dv_timings *fmt);
>  
>  /** v4l2_detect_gtf - detect if the given timings follow the GTF standard
>   * @frame_height - the total height of the frame (including blanking) in lines.
> @@ -132,6 +133,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
>   * @vsync - the height of the vertical sync in lines.
>   * @polarities - the horizontal and vertical polarities (same as struct
>   *		v4l2_bt_timings polarities).
> + * @interlaced - if this flag is true, it indicates interlaced format
>   * @aspect - preferred aspect ratio. GTF has no method of determining the
>   *		aspect ratio in order to derive the image width from the
>   *		image height, so it has to be passed explicitly. Usually
> @@ -144,7 +146,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
>   * in with the found GTF timings.
>   */
>  bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
> -		u32 polarities, struct v4l2_fract aspect,
> +		u32 polarities, bool interlaced, struct v4l2_fract aspect,
>  		struct v4l2_dv_timings *fmt);
>  
>  /** v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
> 

