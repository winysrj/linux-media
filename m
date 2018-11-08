Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40961 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbeKHTvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 14:51:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id v18-v6so1286712wrt.8
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 02:16:14 -0800 (PST)
Subject: Re: [PATCH v1 5/5] media: venus: update number of bytes used field
 properly for EOS frames
To: Srinu Gorle <sgorle@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
 <1538222432-25894-6-git-send-email-sgorle@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <a331a717-199d-6d6c-c88d-54f911b942d4@linaro.org>
Date: Thu, 8 Nov 2018 12:16:10 +0200
MIME-Version: 1.0
In-Reply-To: <1538222432-25894-6-git-send-email-sgorle@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 9/29/18 3:00 PM, Srinu Gorle wrote:
> - In video decoder session, update number of bytes used for
>   yuv buffers appropriately for EOS buffers.
> 
> Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

NACK, that was already discussed see:

https://patchwork.kernel.org/patch/10630411/

> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 311f209..a48eed1 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -978,7 +978,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  
>  		if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
>  			const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
> -
> +			vb->planes[0].bytesused = bytesused;
>  			v4l2_event_queue_fh(&inst->fh, &ev);
>  		}
>  	} else {
> 

-- 
regards,
Stan
