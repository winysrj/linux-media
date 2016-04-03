Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50812 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbcDCRuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 13:50:50 -0400
Subject: Re: [PATCH 3/3] [media] adv7180: Add g_tvnorms operation
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-renesas-soc@vger.kernel.org, lars@metafoo.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
References: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <1459618940-8170-4-git-send-email-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <570157F2.5010902@xs4all.nl>
Date: Sun, 3 Apr 2016 10:50:42 -0700
MIME-Version: 1.0
In-Reply-To: <1459618940-8170-4-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/02/2016 10:42 AM, Niklas Söderlund wrote:
> The ADV7180 supports NTSC, PAL and SECAM.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans


> ---
>   drivers/media/i2c/adv7180.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 80ded70..51a92b3 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -741,6 +741,12 @@ static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
>   	return 0;
>   }
>
> +static int adv7180_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
> +{
> +	*norm = V4L2_STD_ALL;
> +	return 0;
> +}
> +
>   static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>   	.s_std = adv7180_s_std,
>   	.g_std = adv7180_g_std,
> @@ -749,9 +755,9 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>   	.s_routing = adv7180_s_routing,
>   	.g_mbus_config = adv7180_g_mbus_config,
>   	.cropcap = adv7180_cropcap,
> +	.g_tvnorms = adv7180_g_tvnorms,
>   };
>
> -
>   static const struct v4l2_subdev_core_ops adv7180_core_ops = {
>   	.s_power = adv7180_s_power,
>   };
>
