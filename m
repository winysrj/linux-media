Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56215 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbeJHTco (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 15:32:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id 206-v6so7937191wmb.5
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 05:21:16 -0700 (PDT)
Subject: Re: [PATCH v2] venus: vdec: fix decoded data size
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org
References: <1538996944-15042-1-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <8f1b17e3-5015-3a4e-821f-8097da933f91@linaro.org>
Date: Mon, 8 Oct 2018 15:21:13 +0300
MIME-Version: 1.0
In-Reply-To: <1538996944-15042-1-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 10/08/2018 02:09 PM, Vikash Garodia wrote:
> Existing code returns the max of the decoded size and buffer size.
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

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
