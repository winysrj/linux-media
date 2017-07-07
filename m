Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57540 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751011AbdGGIXc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 04:23:32 -0400
Subject: Re: [PATCH] [media] v4l2-mediabus: Add helper functions
To: Todor Tomov <todor.tomov@linaro.org>, hansverk@cisco.com,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1499415487-15785-1-git-send-email-todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c9d253aa-b9dd-e4d0-7c9e-a02688f8fc60@xs4all.nl>
Date: Fri, 7 Jul 2017 10:23:24 +0200
MIME-Version: 1.0
In-Reply-To: <1499415487-15785-1-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2017 10:18 AM, Todor Tomov wrote:
> Add helper functions for mbus to/from mplane pixel format conversion.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>   include/media/v4l2-mediabus.h | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 34cc99e..f97fd4a 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -113,4 +113,30 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
>   	mbus_fmt->code = code;
>   }
>   
> +static inline void v4l2_fill_pix_format_mplane(
> +				struct v4l2_pix_format_mplane *pix_fmt,
> +				const struct v4l2_mbus_framefmt *mbus_fmt)
> +{
> +	pix_fmt->width = mbus_fmt->width;
> +	pix_fmt->height = mbus_fmt->height;
> +	pix_fmt->field = mbus_fmt->field;
> +	pix_fmt->colorspace = mbus_fmt->colorspace;
> +	pix_fmt->ycbcr_enc = mbus_fmt->ycbcr_enc;
> +	pix_fmt->quantization = mbus_fmt->quantization;
> +	pix_fmt->xfer_func = mbus_fmt->xfer_func;
> +}
> +
> +static inline void v4l2_fill_mbus_format_mplane(
> +				struct v4l2_mbus_framefmt *mbus_fmt,
> +				const struct v4l2_pix_format_mplane *pix_fmt)
> +{
> +	mbus_fmt->width = pix_fmt->width;
> +	mbus_fmt->height = pix_fmt->height;
> +	mbus_fmt->field = pix_fmt->field;
> +	mbus_fmt->colorspace = pix_fmt->colorspace;
> +	mbus_fmt->ycbcr_enc = pix_fmt->ycbcr_enc;
> +	mbus_fmt->quantization = pix_fmt->quantization;
> +	mbus_fmt->xfer_func = pix_fmt->xfer_func;
> +}
> +
>   #endif
> 

Looks good. But can you rename pix_fmt to pix_mp_fmt? It makes it a bit
clearer that we're operating on the pix_mp member of struct v4l2_format.

Regards,

	Hans
