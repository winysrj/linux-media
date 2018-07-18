Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34960 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729251AbeGRMIl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 08:08:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id y22-v6so2522597wma.0
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2018 04:31:12 -0700 (PDT)
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, acourbot@chromium.org
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org>
Date: Wed, 18 Jul 2018 14:31:10 +0300
MIME-Version: 1.0
In-Reply-To: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 07/02/2018 10:44 AM, Vikash Garodia wrote:
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
>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index d079aeb..ada1d2f 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  
>  		vb = &vbuf->vb2_buf;
>  		vb->planes[0].bytesused =
> -			max_t(unsigned int, opb_sz, bytesused);
> +			min_t(unsigned int, opb_sz, bytesused);

Most probably my intension was to avoid bytesused == 0, but that is
allowed from v4l2 driver -> userspace direction

Could you drop min/max_t macros at all and use bytesused directly i.e.

vb2_set_plane_payload(vb, 0, bytesused)

-- 
regards,
Stan
