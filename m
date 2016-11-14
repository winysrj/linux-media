Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42935 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933871AbcKNLTJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 06:19:09 -0500
Subject: Re: [PATCH v4 1/8] media: adv7180: fix field type
To: Steve Longerbeam <slongerbeam@gmail.com>, lars@metafoo.de
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <1470247430-11168-2-git-send-email-steve_longerbeam@mentor.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4c546073-218d-0b77-c650-c39533b6b1d6@xs4all.nl>
Date: Mon, 14 Nov 2016 12:19:04 +0100
MIME-Version: 1.0
In-Reply-To: <1470247430-11168-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2016 08:03 PM, Steve Longerbeam wrote:
> From: Steve Longerbeam <slongerbeam@gmail.com>
> 
> The ADV7180 and ADV7182 transmit whole fields, bottom field followed
> by top (or vice-versa, depending on detected video standard). So
> for chips that do not have support for explicitly setting the field
> mode via I2P, set the field mode to V4L2_FIELD_ALTERNATE.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> ---
> 
> v4:
> - switch V4L2_FIELD_SEQ_TB/V4L2_FIELD_SEQ_BT to V4L2_FIELD_ALTERNATE.
>   This is from Niklas Söderlund.
> - remove checks for ADV7180_FLAG_I2P when setting field mode, since I2P
>   support is planned to be removed.
> - move init of state->curr_norm back to its original location, since
>   state->field init is no longer dependent on state->curr_norm.
> 
> v3: no changes
> 
> v2:
> - the init of state->curr_norm in probe needs to be moved up, ahead
>   of the init of state->field.
> ---
>  drivers/media/i2c/adv7180.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 95cbc85..192eeae 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -679,10 +679,10 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
>  	switch (format->format.field) {
>  	case V4L2_FIELD_NONE:
>  		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
> -			format->format.field = V4L2_FIELD_INTERLACED;
> +			format->format.field = V4L2_FIELD_ALTERNATE;
>  		break;

I'd change this to:

  		if (state->chip_info->flags & ADV7180_FLAG_I2P)
			break;
		/* fall through */

>  	default:
> -		format->format.field = V4L2_FIELD_INTERLACED;
> +		format->format.field = V4L2_FIELD_ALTERNATE;
>  		break;
>  	}
>  
> @@ -1251,7 +1251,7 @@ static int adv7180_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	state->client = client;
> -	state->field = V4L2_FIELD_INTERLACED;
> +	state->field = V4L2_FIELD_ALTERNATE;
>  	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
>  
>  	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
> 

Regards,

	Hans
