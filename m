Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33278 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbeKLVoM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 16:44:12 -0500
Received: by mail-wr1-f66.google.com with SMTP id u9-v6so9012882wrr.0
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 03:51:16 -0800 (PST)
Subject: Re: [PATCH] media: venus: change the default value of GOP size
To: Malathi Gottam <mgottam@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1542013562-18968-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <fe5d4fc2-94bb-2224-fea2-91490e28aed0@linaro.org>
Date: Mon, 12 Nov 2018 13:51:11 +0200
MIME-Version: 1.0
In-Reply-To: <1542013562-18968-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

Thanks for the patch!

On 11/12/18 11:06 AM, Malathi Gottam wrote:
> When the client doesn't explicitly set any GOP size, current
> default value is low and overshoots bitrate beyond  tolerance.
> Hence default value is modified so as to have intra period of 1sec.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc_ctrls.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Sounds reasonable :

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> index 45910172..e6a43e9 100644
> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> @@ -295,7 +295,7 @@ int venc_ctrl_init(struct venus_inst *inst)
>  		0, INTRA_REFRESH_MBS_MAX, 1, 0);
>  
>  	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
> -		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, (1 << 16) - 1, 1, 12);
> +		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, (1 << 16) - 1, 1, 30);
>  
>  	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
>  		V4L2_CID_MPEG_VIDEO_VPX_MIN_QP, 1, 128, 1, 1);
> 

-- 
regards,
Stan
