Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:37585 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752307AbcKNLR4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 06:17:56 -0500
Subject: Re: [PATCH v4 5/8] media: adv7180: implement g_parm
To: Steve Longerbeam <slongerbeam@gmail.com>, lars@metafoo.de
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <1470247430-11168-6-git-send-email-steve_longerbeam@mentor.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4c463b74-6156-53f9-fbaf-48d2fda59481@xs4all.nl>
Date: Mon, 14 Nov 2016 12:17:50 +0100
MIME-Version: 1.0
In-Reply-To: <1470247430-11168-6-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2016 08:03 PM, Steve Longerbeam wrote:
> Implement g_parm to return the current standard's frame period.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Tested-by: Tim Harvey <tharvey@gateworks.com>
> Acked-by: Tim Harvey <tharvey@gateworks.com>
> 
> ---
> v4: no changes
> v3: no changes
> v2: no changes
> ---
>  drivers/media/i2c/adv7180.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index b2df181..9705e24 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -764,6 +764,27 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> +static int adv7180_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> +{
> +	struct adv7180_state *state = to_state(sd);
> +	struct v4l2_captureparm *cparm = &a->parm.capture;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	memset(a, 0, sizeof(*a));
> +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

Don't memset this, it is the responsibility of the caller to do that,
not of the subdev.

The caller may have set other fields in the struct that the memset would
wipe out.

Regards,

	Hans

> +	if (state->curr_norm & V4L2_STD_525_60) {
> +		cparm->timeperframe.numerator = 1001;
> +		cparm->timeperframe.denominator = 30000;
> +	} else {
> +		cparm->timeperframe.numerator = 1;
> +		cparm->timeperframe.denominator = 25;
> +	}
> +
> +	return 0;
> +}
> +
>  static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
>  {
>  	struct adv7180_state *state = to_state(sd);
> @@ -822,6 +843,7 @@ static int adv7180_subscribe_event(struct v4l2_subdev *sd,
>  static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>  	.s_std = adv7180_s_std,
>  	.g_std = adv7180_g_std,
> +	.g_parm = adv7180_g_parm,
>  	.querystd = adv7180_querystd,
>  	.g_input_status = adv7180_g_input_status,
>  	.s_routing = adv7180_s_routing,
> 
