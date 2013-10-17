Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37729 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab3JQRDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 13:03:45 -0400
Message-id: <5260186C.1040109@samsung.com>
Date: Thu, 17 Oct 2013 19:03:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v9 12/13] V4L: s5k6a3: Change sensor min/max resolutions
References: <1380279558-21651-1-git-send-email-arun.kk@samsung.com>
 <1380279558-21651-13-git-send-email-arun.kk@samsung.com>
In-reply-to: <1380279558-21651-13-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

My apologies for the delay.

On 27/09/13 12:59, Arun Kumar K wrote:
> s5k6a3 sensor has actual pixel resolution of 1408x1402 against
> the active resolution 1392x1392. The real resolution is needed
> when raw sensor SRGB data is dumped to memory by fimc-lite.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/i2c/s5k6a3.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
> index ccbb4fc..e70e217 100644
> --- a/drivers/media/i2c/s5k6a3.c
> +++ b/drivers/media/i2c/s5k6a3.c
> @@ -25,10 +25,12 @@
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-subdev.h>
>  
> -#define S5K6A3_SENSOR_MAX_WIDTH		1392
> -#define S5K6A3_SENSOR_MAX_HEIGHT	1392
> -#define S5K6A3_SENSOR_MIN_WIDTH		32
> -#define S5K6A3_SENSOR_MIN_HEIGHT	32
> +#define S5K6A3_SENSOR_MAX_WIDTH		1408
> +#define S5K6A3_SENSOR_MAX_HEIGHT	1402

Where these numbers come from ? I digged in the datasheet and the pixel
array size for S5K6A3YX is 1412 x 1412 pixels. I will use this value
in my updated s5k6a3 driver patch I'm going to post today. And I will
drop this patch from this series.

> +#define S5K6A3_SENSOR_ACTIVE_WIDTH	1392
> +#define S5K6A3_SENSOR_ACTIVE_HEIGHT	1392


S5K6A3_SENSOR_ACTIVE_* macros are not used anywhere ? Can they be dropped ?
Same applies to your S5K4E5 driver patch.

> +#define S5K6A3_SENSOR_MIN_WIDTH		(32 + 16)
> +#define S5K6A3_SENSOR_MIN_HEIGHT	(32 + 10)
>  
>  #define S5K6A3_DEF_PIX_WIDTH		1296
>  #define S5K6A3_DEF_PIX_HEIGHT		732
> 

Thanks,
Sylwester
