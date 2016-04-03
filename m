Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58950 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbcDCRue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 13:50:34 -0400
Subject: Re: [PATCH 2/3] [media] adv7180: Add cropcap operation
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-renesas-soc@vger.kernel.org, lars@metafoo.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
References: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <1459618940-8170-3-git-send-email-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <570157E2.10607@xs4all.nl>
Date: Sun, 3 Apr 2016 10:50:26 -0700
MIME-Version: 1.0
In-Reply-To: <1459618940-8170-3-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/02/2016 10:42 AM, Niklas Söderlund wrote:
> Add support to get the pixel aspect ratio depending on the current
> standard (50 vs 60 Hz).
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>   drivers/media/i2c/adv7180.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index d680d76..80ded70 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -726,6 +726,21 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
>   	return 0;
>   }
>
> +static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
> +{
> +	struct adv7180_state *state = to_state(sd);
> +
> +	if (state->curr_norm & V4L2_STD_525_60) {
> +		cropcap->pixelaspect.numerator = 11;
> +		cropcap->pixelaspect.denominator = 10;
> +	} else {
> +		cropcap->pixelaspect.numerator = 54;
> +		cropcap->pixelaspect.denominator = 59;
> +	}
> +
> +	return 0;
> +}
> +
>   static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>   	.s_std = adv7180_s_std,
>   	.g_std = adv7180_g_std,
> @@ -733,6 +748,7 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>   	.g_input_status = adv7180_g_input_status,
>   	.s_routing = adv7180_s_routing,
>   	.g_mbus_config = adv7180_g_mbus_config,
> +	.cropcap = adv7180_cropcap,
>   };
>
>
>
