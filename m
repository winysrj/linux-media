Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55200 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3HCVvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 17:51:08 -0400
Message-ID: <51FD7B48.9040305@gmail.com>
Date: Sat, 03 Aug 2013 23:51:04 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v3 12/13] V4L: s5k6a3: Change sensor min/max resolutions
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-13-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-13-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 08/02/2013 05:02 PM, Arun Kumar K wrote:
> s5k6a3 sensor has actual pixel resolution of 1408x1402 against
> the active resolution 1392x1392. The real resolution is needed
> when raw sensor SRGB data is dumped to memory by fimc-lite.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   drivers/media/i2c/s5k6a3.c |   14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
> index ccbb4fc..d81638d 100644
> --- a/drivers/media/i2c/s5k6a3.c
> +++ b/drivers/media/i2c/s5k6a3.c
> @@ -30,6 +30,9 @@
>   #define S5K6A3_SENSOR_MIN_WIDTH		32
>   #define S5K6A3_SENSOR_MIN_HEIGHT	32
>
> +#define S5K6A3_WIDTH_PADDING		16
> +#define S5K6A3_HEIGHT_PADDING		10

How about instead defining MAX and ACTIVE sizes, e.g.

#define S5K6A3_SENSOR_MAX_WIDTH			1408
#define S5K6A3_SENSOR_MAX_HEIGHT		1402

#define S5K6A3_SENSOR_ACTIVE_WIDTH		1392	
#define S5K6A3_SENSOR_ACTIVE_HEIGHT		1392

>   #define S5K6A3_DEF_PIX_WIDTH		1296
>   #define S5K6A3_DEF_PIX_HEIGHT		732

I'm going to remove "_PIX" from those macros in next iteration.

> @@ -107,10 +110,13 @@ static void s5k6a3_try_format(struct v4l2_mbus_framefmt *mf)
>
>   	fmt = find_sensor_format(mf);
>   	mf->code = fmt->code;
> -	v4l_bound_align_image(&mf->width, S5K6A3_SENSOR_MIN_WIDTH,
> -			      S5K6A3_SENSOR_MAX_WIDTH, 0,
> -			&mf->height, S5K6A3_SENSOR_MIN_HEIGHT,
> -			      S5K6A3_SENSOR_MAX_HEIGHT, 0, 0);
> +	v4l_bound_align_image(&mf->width,
> +			S5K6A3_SENSOR_MIN_WIDTH + S5K6A3_WIDTH_PADDING,
> +			S5K6A3_SENSOR_MAX_WIDTH + S5K6A3_WIDTH_PADDING, 0,
> +			&mf->height,
> +			S5K6A3_SENSOR_MIN_HEIGHT + S5K6A3_HEIGHT_PADDING,
> +			S5K6A3_SENSOR_MAX_HEIGHT + S5K6A3_HEIGHT_PADDING, 0,
> +			0);

Then this would become:

	v4l_bound_align_image(&mf->width,
			S5K6A3_SENSOR_MIN_WIDTH + S5K6A3_WIDTH_PADDING,
			S5K6A3_SENSOR_MAX_WIDTH, 0,
			&mf->height,
			S5K6A3_SENSOR_MIN_HEIGHT + S5K6A3_HEIGHT_PADDING,
			S5K6A3_SENSOR_MAX_HEIGHT, 0,
			0);

I'm not sure about minimal width/height, perhaps we could just define it as:

#define S5K6A3_SENSOR_MIN_WIDTH		(32 + 10)
#define S5K6A3_SENSOR_MIN_HEIGHT	(32 + 8)

? I'll also double check with the documentation if the original 32x23 value
is really correct.

--
Regards,
Sylwester
