Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43964 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728491AbeHPKP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 06:15:57 -0400
Subject: Re: [PATCHv2 5/5] adv7842: enable reduced fps detection
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180815134056.98830-1-hverkuil@xs4all.nl>
 <20180815134056.98830-6-hverkuil@xs4all.nl>
Message-ID: <d4b57837-9d1d-06cb-d2ef-0f78e6434544@xs4all.nl>
Date: Thu, 16 Aug 2018 09:19:25 +0200
MIME-Version: 1.0
In-Reply-To: <20180815134056.98830-6-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/08/18 15:40, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The pixelclock detection of the adv7842 is precise enough to detect
> if the framerate is 60 Hz or 59.94 Hz (aka "reduced fps").
> 
> Implement this detection.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/adv7842.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
> index 4f8fbdd00e35..999d621f5667 100644
> --- a/drivers/media/i2c/adv7842.c
> +++ b/drivers/media/i2c/adv7842.c
> @@ -1525,6 +1525,7 @@ static void adv7842_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
>  	v4l2_find_dv_timings_cap(timings, adv7842_get_dv_timings_cap(sd),
>  			is_digital_input(sd) ? 250000 : 1000000,
>  			adv7842_check_dv_timings, NULL);
> +	timings->bt.flags |= V4L2_DV_FL_CAN_DETECT_REDUCED_FPS;
>  }
>  
>  static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
> @@ -1596,6 +1597,14 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
>  			bt->il_vbackporch = 0;
>  		}
>  		adv7842_fill_optional_dv_timings_fields(sd, timings);
> +		if ((timings->bt.flags & V4L2_DV_FL_CAN_REDUCE_FPS) &&
> +		    freq < bt->pixelclock) {
> +			u32 reduced_freq = (bt->pixelclock / 1001) * 1000;

bt->pixelclock needs to be cast to u32 to avoid a 64 bit division.

> +			u32 delta_freq = abs(freq - reduced_freq);
> +
> +			if (delta_freq < (bt->pixelclock - reduced_freq) / 2)

Ditto.

(kbuild robot complained about this.)

	Hans

> +				timings->bt.flags |= V4L2_DV_FL_REDUCED_FPS;
> +		}
>  	} else {
>  		/* find format
>  		 * Since LCVS values are inaccurate [REF_03, p. 339-340],
> 
