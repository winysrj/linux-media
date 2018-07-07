Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45570 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754010AbeGGM0m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 08:26:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id u7-v6so6515720wrn.12
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2018 05:26:42 -0700 (PDT)
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, acourbot@chromium.org
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <cd1c231b-1db1-6e61-8611-51eab9248842@linaro.org>
Date: Sat, 7 Jul 2018 15:26:39 +0300
MIME-Version: 1.0
In-Reply-To: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On  2.07.2018 10:44, Vikash Garodia wrote:
> Exisiting code returns the max of the decoded
> size and buffer size. It turns out that buffer
> size is always greater due to hardware alignment
> requirement. As a result, payload size given to
> client is incorrect. This change ensures that
> the bytesused is assigned to actual payload size.
> 
> Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>   drivers/media/platform/qcom/venus/vdec.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index d079aeb..ada1d2f 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>   
>   		vb = &vbuf->vb2_buf;
>   		vb->planes[0].bytesused =
> -			max_t(unsigned int, opb_sz, bytesused);
> +			min_t(unsigned int, opb_sz, bytesused);

I cannot remember the exact reason to make it this way, might be an 
issue with vp8 or some mpeg2/4 on v1 which I workaround by this way. 
I'll test the patch on v1 & v3 and come back.

regards,
Stan
