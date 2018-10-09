Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53758 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeJIWRU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 18:17:20 -0400
Received: by mail-wm1-f66.google.com with SMTP id y11-v6so2213943wma.3
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 08:00:00 -0700 (PDT)
Subject: Re: [PATCH] media: venus: handle peak bitrate set property
To: Malathi Gottam <mgottam@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1539071483-1371-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <274a112a-604c-82b4-130a-c3718abcf141@linaro.org>
Date: Tue, 9 Oct 2018 17:59:55 +0300
MIME-Version: 1.0
In-Reply-To: <1539071483-1371-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

Thanks for the patch!

On 10/09/2018 10:51 AM, Malathi Gottam wrote:
> Max bitrate property is not supported for venus version 4xx.
> Add a version check for the same.

I'd like to avoid version checks in this layer of the driver. Could just
black-list this property in pkt_session_set_property_4xx? Hint, see
HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE in the same function.

> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index ef11495..3f50cd0 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -757,18 +757,20 @@ static int venc_set_properties(struct venus_inst *inst)
>  	if (ret)
>  		return ret;
>  
> -	if (!ctr->bitrate_peak)
> -		bitrate *= 2;
> -	else
> -		bitrate = ctr->bitrate_peak;
> +	if (!IS_V4(inst->core)) {
> +		if (!ctr->bitrate_peak)
> +			bitrate *= 2;
> +		else
> +			bitrate = ctr->bitrate_peak;
>  
> -	ptype = HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE;
> -	brate.bitrate = bitrate;
> -	brate.layer_id = 0;
> +		ptype = HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE;
> +		brate.bitrate = bitrate;
> +		brate.layer_id = 0;
>  
> -	ret = hfi_session_set_property(inst, ptype, &brate);
> -	if (ret)
> -		return ret;
> +		ret = hfi_session_set_property(inst, ptype, &brate);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
>  		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> 

-- 
regards,
Stan
