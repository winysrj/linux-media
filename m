Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:35239 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967354AbcHBPbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 11:31:50 -0400
Subject: Re: [PATCHv2 7/7] [PATCHv5] media: adv7180: fix field type
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-8-niklas.soderlund+renesas@ragnatech.se>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
	Steve Longerbeam <steve_longerbeam@mentor.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <3bb2b375-a4a9-00c4-1466-7b1ba8e3bfd8@metafoo.de>
Date: Tue, 2 Aug 2016 17:00:07 +0200
MIME-Version: 1.0
In-Reply-To: <20160802145107.24829-8-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[...]
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index a8b434b..c6fed71 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -680,10 +680,13 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
>  	switch (format->format.field) {
>  	case V4L2_FIELD_NONE:
>  		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
> -			format->format.field = V4L2_FIELD_INTERLACED;
> +			format->format.field = V4L2_FIELD_ALTERNATE;
>  		break;
>  	default:
> -		format->format.field = V4L2_FIELD_INTERLACED;
> +		if (state->chip_info->flags & ADV7180_FLAG_I2P)
> +			format->format.field = V4L2_FIELD_INTERLACED;

I'm not convinced this is correct. As far as I understand it when the I2P
feature is enabled the core outputs full progressive frames at the full
framerate. If it is bypassed it outputs half-frames. So we have the option
of either V4L2_FIELD_NONE or V4L2_FIELD_ALTERNATE, but never interlaced. I
think this branch should setup the field format to be ALTERNATE regardless
of whether the I2P feature is available.

> +		else
> +			format->format.field = V4L2_FIELD_ALTERNATE;
>  		break;
>  	}
>  

