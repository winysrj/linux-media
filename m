Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:44654 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752291AbdK0PZm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 10:25:42 -0500
Message-ID: <1511796338.25007.456.camel@linux.intel.com>
Subject: Re: [PATCH v2] [media] staging: atomisp: convert timestamps to
 ktime_t
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: y2038@lists.linaro.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Nov 2017 17:25:38 +0200
In-Reply-To: <20171127152256.2184193-1-arnd@arndb.de>
References: <20171127152256.2184193-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-11-27 at 16:21 +0100, Arnd Bergmann wrote:
> timespec overflows in 2038 on 32-bit architectures, and the
> getnstimeofday() suffers from possible time jumps, so the
> timestamps here are better done using ktime_get(), which has
> neither of those problems.
> 
> In case of ov2680, we don't seem to use the timestamp at
> all, so I just remove it.
> 

Yep,

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: use min_t() as suggested by Andy Shevchenko
> ---
>  drivers/staging/media/atomisp/i2c/ov2680.h            |  1 -
>  .../staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c | 19 ++++++++
> -----------
>  drivers/staging/media/atomisp/i2c/ov5693/ov5693.h     |  2 +-
>  3 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h
> b/drivers/staging/media/atomisp/i2c/ov2680.h
> index bf4897347df7..03f75dd80f87 100644
> --- a/drivers/staging/media/atomisp/i2c/ov2680.h
> +++ b/drivers/staging/media/atomisp/i2c/ov2680.h
> @@ -174,7 +174,6 @@ struct ov2680_format {
>  		struct mutex input_lock;
>  	struct v4l2_ctrl_handler ctrl_handler;
>  		struct camera_sensor_platform_data *platform_data;
> -		struct timespec timestamp_t_focus_abs;
>  		int vt_pix_clk_freq_mhz;
>  		int fmt_idx;
>  		int run_mode;
> diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c 
> b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> index 3e7c3851280f..9fa25bb8f1ee 100644
> --- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> +++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> @@ -973,7 +973,7 @@ static int ov5693_t_focus_abs(struct v4l2_subdev
> *sd, s32 value)
>  	if (ret == 0) {
>  		dev->number_of_steps = value - dev->focus;
>  		dev->focus = value;
> -		getnstimeofday(&(dev->timestamp_t_focus_abs));
> +		dev->timestamp_t_focus_abs = ktime_get();
>  	} else
>  		dev_err(&client->dev,
>  			"%s: i2c failed. ret %d\n", __func__, ret);
> @@ -993,16 +993,13 @@ static int ov5693_q_focus_status(struct
> v4l2_subdev *sd, s32 *value)
>  {
>  	u32 status = 0;
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
> -	struct timespec temptime;
> -	const struct timespec timedelay = {
> -		0,
> -		min((u32)abs(dev->number_of_steps) *
> DELAY_PER_STEP_NS,
> -		(u32)DELAY_MAX_PER_STEP_NS),
> -	};
> -
> -	getnstimeofday(&temptime);
> -	temptime = timespec_sub(temptime, (dev-
> >timestamp_t_focus_abs));
> -	if (timespec_compare(&temptime, &timedelay) <= 0) {
> +	ktime_t temptime;
> +	ktime_t timedelay = ns_to_ktime(min_t(u32,
> +			abs(dev->number_of_steps) *
> DELAY_PER_STEP_NS,
> +			DELAY_MAX_PER_STEP_NS));
> +
> +	temptime = ktime_sub(ktime_get(), (dev-
> >timestamp_t_focus_abs));
> +	if (ktime_compare(temptime, timedelay) <= 0) {
>  		status |= ATOMISP_FOCUS_STATUS_MOVING;
>  		status |= ATOMISP_FOCUS_HP_IN_PROGRESS;
>  	} else {
> diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> index 2ea63807c56d..68cfcb4a6c3c 100644
> --- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> +++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> @@ -221,7 +221,7 @@ struct ov5693_device {
>  	struct v4l2_ctrl_handler ctrl_handler;
>  
>  	struct camera_sensor_platform_data *platform_data;
> -	struct timespec timestamp_t_focus_abs;
> +	ktime_t timestamp_t_focus_abs;
>  	int vt_pix_clk_freq_mhz;
>  	int fmt_idx;
>  	int run_mode;

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
