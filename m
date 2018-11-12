Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37237 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbeKLWVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 17:21:30 -0500
Received: by mail-wm1-f67.google.com with SMTP id p2-v6so7926371wmc.2
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 04:28:25 -0800 (PST)
Subject: Re: [PATCH] media: venus: amend buffer size for bitstream plane
To: Malathi Gottam <mgottam@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <48f90d4d-8ae3-65ae-2096-eebf047c1c0c@linaro.org>
Date: Mon, 12 Nov 2018 14:28:22 +0200
MIME-Version: 1.0
In-Reply-To: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

Thanks for the patch!

On 10/9/18 10:52 AM, Malathi Gottam wrote:
> For lower resolutions, incase of encoder, the compressed
> frame size is more than half of the corresponding input
> YUV. Keep the size as same as YUV considering worst case.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 2679adb..05c5423 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -649,7 +649,7 @@ u32 venus_helper_get_framesz(u32 v4l2_fmt, u32 width, u32 height)
>  	}
>  
>  	if (compressed) {
> -		sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
> +		sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2;

Could you drop this division by 2 only for lower resolutions and also
only for the encoder session? I do not want to waste memory if it is not
absolutely needed.

-- 
regards,
Stan
