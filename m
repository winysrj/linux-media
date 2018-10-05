Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38863 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbeJEWZ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 18:25:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id a13-v6so13963610wrt.5
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2018 08:26:15 -0700 (PDT)
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org
References: <1538566221-21369-1-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <68f15b8b-3121-3412-2ad1-6647e9afc264@linaro.org>
Date: Fri, 5 Oct 2018 18:26:11 +0300
MIME-Version: 1.0
In-Reply-To: <1538566221-21369-1-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

please, increment the version of the patch next time. This one must be v2.

On 10/03/2018 02:30 PM, Vikash Garodia wrote:
> Exisiting code returns the max of the decoded size and buffer size.

s/Exisiting/Existing

> It turns out that buffer size is always greater due to hardware
> alignment requirement. As a result, payload size given to client
> is incorrect. This change ensures that the bytesused is assigned
> to actual payload size, when available.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 991e158..189ec97 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -888,8 +888,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  		unsigned int opb_sz = venus_helper_get_opb_size(inst);
>  
>  		vb = &vbuf->vb2_buf;
> -		vb->planes[0].bytesused =
> -			max_t(unsigned int, opb_sz, bytesused);
> +		vb2_set_plane_payload(vb, 0, bytesused ? : opb_sz);
>  		vb->planes[0].data_offset = data_offset;
>  		vb->timestamp = timestamp_us * NSEC_PER_USEC;
>  		vbuf->sequence = inst->sequence_cap++;
> 

-- 
regards,
Stan
