Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46616 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752971AbdIRMMZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 08:12:25 -0400
Date: Mon, 18 Sep 2017 15:12:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH v2] media: ov13858: Calculate pixel-rate at runtime, use
 mode
Message-ID: <20170918121219.eczq4s2desflgkxb@valkosipuli.retiisi.org.uk>
References: <1504655098-39951-1-git-send-email-rajmohan.mani@intel.com>
 <ac8d16fed1d466c3381532b627e7dde5737650ec.1504721789.git.chiranjeevi.rapolu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8d16fed1d466c3381532b627e7dde5737650ec.1504721789.git.chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

On Wed, Sep 06, 2017 at 11:26:33AM -0700, Chiranjeevi Rapolu wrote:
> Calculate pixel-rate at run time instead of compile time.
> 
> Instead of using hardcoded pixels-per-line, extract it from current sensor
> mode.
> 
> Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> ---
> Changes in v2:
> 	- Removed pixel-rate from struct definition.
> 	- Used pixel-rate formula wherever needed.
> 	- Changed commit message to reflect above changes.
>  drivers/media/i2c/ov13858.c | 42 ++++++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
> index af7af0d..77f256e 100644
> --- a/drivers/media/i2c/ov13858.c
> +++ b/drivers/media/i2c/ov13858.c
> @@ -104,7 +104,6 @@ struct ov13858_reg_list {
>  
>  /* Link frequency config */
>  struct ov13858_link_freq_config {
> -	u32 pixel_rate;
>  	u32 pixels_per_line;
>  
>  	/* PLL registers for this link frequency */
> @@ -958,8 +957,6 @@ struct ov13858_mode {
>  static const struct ov13858_link_freq_config
>  			link_freq_configs[OV13858_NUM_OF_LINK_FREQS] = {
>  	{
> -		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
> -		.pixel_rate = (OV13858_LINK_FREQ_540MHZ * 2 * 4) / 10,
>  		.pixels_per_line = OV13858_PPL_540MHZ,
>  		.reg_list = {
>  			.num_of_regs = ARRAY_SIZE(mipi_data_rate_1080mbps),
> @@ -967,8 +964,6 @@ struct ov13858_mode {
>  		}
>  	},
>  	{
> -		/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
> -		.pixel_rate = (OV13858_LINK_FREQ_270MHZ * 2 * 4) / 10,
>  		.pixels_per_line = OV13858_PPL_270MHZ,
>  		.reg_list = {
>  			.num_of_regs = ARRAY_SIZE(mipi_data_rate_540mbps),
> @@ -1385,6 +1380,7 @@ static int ov13858_get_pad_format(struct v4l2_subdev *sd,
>  	s32 vblank_def;
>  	s32 vblank_min;
>  	s64 h_blank;
> +	s64 pixel_rate;
>  
>  	mutex_lock(&ov13858->mutex);
>  
> @@ -1400,9 +1396,9 @@ static int ov13858_get_pad_format(struct v4l2_subdev *sd,
>  	} else {
>  		ov13858->cur_mode = mode;
>  		__v4l2_ctrl_s_ctrl(ov13858->link_freq, mode->link_freq_index);
> -		__v4l2_ctrl_s_ctrl_int64(
> -			ov13858->pixel_rate,
> -			link_freq_configs[mode->link_freq_index].pixel_rate);
> +		pixel_rate =
> +		(link_freq_menu_items[mode->link_freq_index] * 2 * 4) / 10;

You should indent what falls on the next line, and add subsequent line
wraps if needed.

> +		__v4l2_ctrl_s_ctrl_int64(ov13858->pixel_rate, pixel_rate);
>  		/* Update limits and set FPS to default */
>  		vblank_def = ov13858->cur_mode->vts_def -
>  			     ov13858->cur_mode->height;
> @@ -1617,6 +1613,10 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
>  	s64 exposure_max;
>  	s64 vblank_def;
>  	s64 vblank_min;
> +	s64 hblank;
> +	s64 pixel_rate_min;
> +	s64 pixel_rate_max;
> +	const struct ov13858_mode *mode;
>  	int ret;
>  
>  	ctrl_hdlr = &ov13858->ctrl_handler;
> @@ -1634,29 +1634,31 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
>  				link_freq_menu_items);
>  	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  
> +	/* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
> +	pixel_rate_max = (link_freq_menu_items[0] * 2 * 4) / 10;
> +	pixel_rate_min = (link_freq_menu_items[1] * 2 * 4) / 10;

You're using the same, some could say non-trivial, formula in three places.

Could you add a macro for it? E.g.

/* double data rate => 2; four lanes => four; 10 bits per pixel => 10 */
#define link_freq_to_pixel_rate(f) ((f) * 2 * 4 / 10)

>  	/* By default, PIXEL_RATE is read only */
>  	ov13858->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops,
> -					V4L2_CID_PIXEL_RATE, 0,
> -					link_freq_configs[0].pixel_rate, 1,
> -					link_freq_configs[0].pixel_rate);
> +						V4L2_CID_PIXEL_RATE,
> +						pixel_rate_min, pixel_rate_max,
> +						1, pixel_rate_max);
>  
> -	vblank_def = ov13858->cur_mode->vts_def - ov13858->cur_mode->height;
> -	vblank_min = ov13858->cur_mode->vts_min - ov13858->cur_mode->height;
> +	mode = ov13858->cur_mode;
> +	vblank_def = mode->vts_def - mode->height;
> +	vblank_min = mode->vts_min - mode->height;
>  	ov13858->vblank = v4l2_ctrl_new_std(
>  				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_VBLANK,
> -				vblank_min,
> -				OV13858_VTS_MAX - ov13858->cur_mode->height, 1,
> +				vblank_min, OV13858_VTS_MAX - mode->height, 1,
>  				vblank_def);
>  
> +	hblank = link_freq_configs[mode->link_freq_index].pixels_per_line -
> +		 mode->width;
>  	ov13858->hblank = v4l2_ctrl_new_std(
>  				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_HBLANK,
> -				OV13858_PPL_540MHZ - ov13858->cur_mode->width,
> -				OV13858_PPL_540MHZ - ov13858->cur_mode->width,
> -				1,
> -				OV13858_PPL_540MHZ - ov13858->cur_mode->width);
> +				hblank, hblank, 1, hblank);
>  	ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  
> -	exposure_max = ov13858->cur_mode->vts_def - 8;
> +	exposure_max = mode->vts_def - 8;
>  	ov13858->exposure = v4l2_ctrl_new_std(
>  				ctrl_hdlr, &ov13858_ctrl_ops,
>  				V4L2_CID_EXPOSURE, OV13858_EXPOSURE_MIN,

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
