Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:32781 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbeKZUjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 15:39:23 -0500
Received: by mail-wm1-f68.google.com with SMTP id 79so16142563wmo.0
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 01:45:49 -0800 (PST)
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181113093048.236201-1-acourbot@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <a56320a4-c74f-54c2-a340-fa3c2c19a2a1@linaro.org>
Date: Mon, 26 Nov 2018 11:45:46 +0200
MIME-Version: 1.0
In-Reply-To: <20181113093048.236201-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thanks for the patch!

On 11/13/18 11:30 AM, Alexandre Courbot wrote:
> The last buffer is often signaled by an empty buffer with the
> V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with the
> bytesused field set to the full size of the OPB, which leads
> user-space to believe that the buffer actually contains useful data. Fix
> this by passing the number of bytes reported used by the firmware.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

> 
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 189ec975c6bb..282de21cf2e1 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -885,10 +885,8 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>  	vbuf->field = V4L2_FIELD_NONE;
>  
>  	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> -		unsigned int opb_sz = venus_helper_get_opb_size(inst);
> -
>  		vb = &vbuf->vb2_buf;
> -		vb2_set_plane_payload(vb, 0, bytesused ? : opb_sz);
> +		vb2_set_plane_payload(vb, 0, bytesused);
>  		vb->planes[0].data_offset = data_offset;
>  		vb->timestamp = timestamp_us * NSEC_PER_USEC;
>  		vbuf->sequence = inst->sequence_cap++;
> 

-- 
regards,
Stan
