Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57552 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbcGRIkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 04:40:07 -0400
Subject: Re: [PATCH v3 4/9] [media] vivid: code refactor for color encoding
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468665716-10178-5-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e121c9da-fea2-9610-9e52-a02b28a3a7db@xs4all.nl>
Date: Mon, 18 Jul 2016 10:40:01 +0200
MIME-Version: 1.0
In-Reply-To: <1468665716-10178-5-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2016 12:41 PM, Ricardo Ribalda Delgado wrote:
> Replace is_yuv with color_enc Which can be used by other
> color encodings such us HSV.
> 
> This change should ease the review of the following patches.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 49 +++++++++++++++--------
>  drivers/media/platform/vivid/vivid-core.h       |  2 +-
>  drivers/media/platform/vivid/vivid-vid-common.c | 52 ++++++++++++-------------
>  include/media/v4l2-tpg.h                        |  7 +++-
>  4 files changed, 66 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index 3ec3cebe62b9..e8d2bf388597 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -1889,11 +1893,24 @@ static int tpg_pattern_avg(const struct tpg_data *tpg,
>  	return -1;
>  }
>  
> +static const char *tpg_color_enc_str(enum tgp_color_enc
> +						 color_enc)
> +{
> +	switch (color_enc) {
> +	case TGP_COLOR_ENC_YUV:
> +		return "YCbCr";

Use "Y'CbCr"

> +	case TGP_COLOR_ENC_RGB:
> +	default:
> +		return "RGB";

and "R'G'B'".

That's more precise.

> +
> +	}
> +}
> +
>  void tpg_log_status(struct tpg_data *tpg)
>  {
>  	pr_info("tpg source WxH: %ux%u (%s)\n",
> -			tpg->src_width, tpg->src_height,
> -			tpg->is_yuv ? "YCbCr" : "RGB");
> +		tpg->src_width, tpg->src_height,
> +		tpg_color_enc_str(tpg->color_enc));
>  	pr_info("tpg field: %u\n", tpg->field);
>  	pr_info("tpg crop: %ux%u@%dx%d\n", tpg->crop.width, tpg->crop.height,
>  			tpg->crop.left, tpg->crop.top);
> diff --git a/include/media/v4l2-tpg.h b/include/media/v4l2-tpg.h
> index 329bebfa930c..e4da507d40e2 100644
> --- a/include/media/v4l2-tpg.h
> +++ b/include/media/v4l2-tpg.h
> @@ -87,6 +87,11 @@ enum tpg_move_mode {
>  	TPG_MOVE_POS_FAST,
>  };
>  
> +enum tgp_color_enc {
> +	TGP_COLOR_ENC_RGB,
> +	TGP_COLOR_ENC_YUV,

Rename this to YCBCR. It's the technically correct name.

Regards,

	Hans

> +};
> +
>  extern const char * const tpg_aspect_strings[];
>  
>  #define TPG_MAX_PLANES 3
> @@ -119,7 +124,7 @@ struct tpg_data {
>  	u8				saturation;
>  	s16				hue;
>  	u32				fourcc;
> -	bool				is_yuv;
> +	enum tgp_color_enc		color_enc;
>  	u32				colorspace;
>  	u32				xfer_func;
>  	u32				ycbcr_enc;
> 
