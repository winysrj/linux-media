Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50835 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbeKAVXv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 17:23:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id h2-v6so1215121wmb.0
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 05:21:06 -0700 (PDT)
Subject: Re: [PATCH v2] media: venus: handle peak bitrate set property
To: Malathi Gottam <mgottam@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1540209912-24834-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <5e7de7d5-cd5b-7a88-6015-df28d45b122e@linaro.org>
Date: Thu, 1 Nov 2018 14:21:03 +0200
MIME-Version: 1.0
In-Reply-To: <1540209912-24834-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malathi, thanks for the patch!

On 10/22/18 3:05 PM, Malathi Gottam wrote:
> Max bitrate property is not supported for venus version 4xx.
> Return unsupported from packetization layer. Handle it in 
> hfi_venus layer to exit gracefully to venc layer.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/hfi_cmds.c  | 2 +-
>  drivers/media/platform/qcom/venus/hfi_venus.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
> index e8389d8..87a4414 100644
> --- a/drivers/media/platform/qcom/venus/hfi_cmds.c
> +++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
> @@ -1215,7 +1215,7 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
>  	}
>  	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
>  		/* not implemented on Venus 4xx */
> -		break;
> +		return -ENOTSUPP;
>  	default:
>  		return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
>  	}
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
> index 1240855..9d086b9 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
> @@ -1355,6 +1355,8 @@ static int venus_session_set_property(struct venus_inst *inst, u32 ptype,
>  	pkt = (struct hfi_session_set_property_pkt *)packet;
>  
>  	ret = pkt_session_set_property(pkt, inst, ptype, pdata);
> +	if (ret == -ENOTSUPP)
> +		return 0;
>  	if (ret)
>  		return ret;
>  

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
