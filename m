Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:55070 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbeCOJwe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 05:52:34 -0400
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH] venus: vdec: fix format enumeration
To: Alexandre Courbot <acourbot@chromium.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180313091135.145589-1-acourbot@chromium.org>
Message-ID: <20ce58ee-879d-78b6-5e68-748317b67d12@mm-sol.com>
Date: Thu, 15 Mar 2018 11:52:16 +0200
MIME-Version: 1.0
In-Reply-To: <20180313091135.145589-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thanks for the patch!

On 13.03.2018 11:11, Alexandre Courbot wrote:
> find_format_by_index() stops enumerating formats as soon as the index
> matches, and returns NULL if venus_helper_check_codec() finds out that
> the format is not supported. This prevents formats to be properly
> enumerated if a non-supported format is present, as the enumeration will
> end with it.

Please add fixes tag,

Fixes: 29f0133ec6 media: venus: use helper function to check supported
codecs

> 
> Fix this by moving the call to venus_helper_check_codec() into the loop,
> and keep enumerating when it fails.

Good catch!

> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> 
> Change-Id: I4ff66e0b85172598efa59a6f01da8cb60597a6a5

You forgot to delete gerrit id.

> ---
>   drivers/media/platform/qcom/venus/vdec.c | 13 +++++++------
>   drivers/media/platform/qcom/venus/venc.c |  9 +++++++--
>   2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index c9e9576bb08a..3677302cfe43 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -135,20 +135,21 @@ find_format_by_index(struct venus_inst *inst, unsigned int index, u32 type)
>   		return NULL;
>   
>   	for (i = 0; i < size; i++) {
> +		bool valid;
> +
>   		if (fmt[i].type != type)
>   			continue;
> -		if (k == index)
> +		valid = (type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
> +			 venus_helper_check_codec(inst, fmt[i].pixfmt));

open and close braces are not needed.

> +		if (k == index && valid)
>   			break;
> -		k++;
> +		if (valid)
> +			k++;
>   	}
>   
>   	if (i == size)
>   		return NULL;
>   
> -	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> -	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
> -		return NULL;
> -
>   	return &fmt[i];
>   }
>   
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index e3a10a852cad..5eba4c7cd52e 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -120,11 +120,16 @@ find_format_by_index(struct venus_inst *inst, unsigned int index, u32 type)
>   		return NULL;
>   
>   	for (i = 0; i < size; i++) {
> +		bool valid;
> +
>   		if (fmt[i].type != type)
>   			continue;
> -		if (k == index)
> +		valid = (type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
> +			 venus_helper_check_codec(inst, fmt[i].pixfmt));
> +		if (k == index && valid)
>   			break;
> -		k++;
> +		if (valid)
> +			k++;
>   	}
>   
>   	if (i == size)

maybe we should delete the condition:

if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
!venus_helper_check_codec(inst, fmt[i].pixfmt))

as we do for the decoder?

regards,
Stan
