Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58950 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbcDCRuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 13:50:16 -0400
Subject: Re: [PATCH 1/3] [media] adv7180: Add g_std operation
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-renesas-soc@vger.kernel.org, lars@metafoo.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
References: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <1459618940-8170-2-git-send-email-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <570157CF.8030400@xs4all.nl>
Date: Sun, 3 Apr 2016 10:50:07 -0700
MIME-Version: 1.0
In-Reply-To: <1459618940-8170-2-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/02/2016 10:42 AM, Niklas Söderlund wrote:
> Add support to get the standard to the adv7180 driver.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>   drivers/media/i2c/adv7180.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index ff57c1d..d680d76 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -434,6 +434,15 @@ out:
>   	return ret;
>   }
>
> +static int adv7180_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
> +{
> +	struct adv7180_state *state = to_state(sd);
> +
> +	*norm = state->curr_norm;
> +
> +	return 0;
> +}
> +
>   static int adv7180_set_power(struct adv7180_state *state, bool on)
>   {
>   	u8 val;
> @@ -719,6 +728,7 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
>
>   static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>   	.s_std = adv7180_s_std,
> +	.g_std = adv7180_g_std,
>   	.querystd = adv7180_querystd,
>   	.g_input_status = adv7180_g_input_status,
>   	.s_routing = adv7180_s_routing,
>
