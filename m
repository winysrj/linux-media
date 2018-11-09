Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54640 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbeKITjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 14:39:46 -0500
Received: by mail-wm1-f65.google.com with SMTP id r63-v6so1419805wma.4
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 01:59:55 -0800 (PST)
Subject: Re: [PATCH v1 3/5] media: venus: do not destroy video session during
 queue setup
To: Srinu Gorle <sgorle@codeaurora.org>, stanimir.varbanov@linaro.org,
        hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
 <1538222432-25894-4-git-send-email-sgorle@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <d8cb0c47-a3f7-314b-c65d-3c8eca724e6a@linaro.org>
Date: Fri, 9 Nov 2018 11:59:49 +0200
MIME-Version: 1.0
In-Reply-To: <1538222432-25894-4-git-send-email-sgorle@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Srinu,

On 9/29/18 3:00 PM, Srinu Gorle wrote:
> - open and close video sessions for plane properties is incorrect.

Could you rephrase this statement? I really don't understand what you mean.

> - add check to ensure, same instance persist from driver open to close.

This assumption is wrong. The v4l client can change the codec by SFMT
without close the device node, in that case we have to destroy and
create a new session with new codec.

> 
> Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/hfi.c  | 3 +++
>  drivers/media/platform/qcom/venus/vdec.c | 2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
> index 36a4784..59c34ba 100644
> --- a/drivers/media/platform/qcom/venus/hfi.c
> +++ b/drivers/media/platform/qcom/venus/hfi.c
> @@ -207,6 +207,9 @@ int hfi_session_init(struct venus_inst *inst, u32 pixfmt)
>  	const struct hfi_ops *ops = core->ops;
>  	int ret;
>  
> +	if (inst->state >= INST_INIT && inst->state < INST_STOP)
> +		return 0;

In fact you want to be able to call session_init multiple times but
deinit the session only once? The hfi.c layer is designed to follow the
states as they are expected by the firmware side, if you want to call
session_init multiple times just make a wrapper in the vdec.c with
reference counting.

> +
>  	inst->hfi_codec = to_codec_type(pixfmt);
>  	reinit_completion(&inst->done);
>  
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index afe3b36..0035cf2 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -700,6 +700,8 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
>  
>  	*out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
>  
> +	return 0;

OK in present implementation I decided that the codec is settled when
streamon on both queues is called (i.e. the final session_init is made
in streamon). IMO the correct one is to init the session in
reqbuf(output) and deinit session in reqbuf(output, count=0)?

The problem I see when you skip session_deinit is that the codec cannot
be changed without closing the video node.

> +
>  deinit:
>  	hfi_session_deinit(inst);
>  
> 

-- 
regards,
Stan
