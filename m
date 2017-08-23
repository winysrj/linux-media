Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35318 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753948AbdHWM72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 08:59:28 -0400
Received: by mail-wm0-f44.google.com with SMTP id r187so354903wma.0
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 05:59:28 -0700 (PDT)
Subject: Re: [PATCH v2] venus: fix copy/paste error in return_buf_error
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170818160719.GA4899@embeddedgus>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <83ce1aaf-9d12-6a32-aa33-e962f7c4e3c4@linaro.org>
Date: Wed, 23 Aug 2017 15:59:23 +0300
MIME-Version: 1.0
In-Reply-To: <20170818160719.GA4899@embeddedgus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gustavo,

could you resend the patch with the Acked-by and Cc stable kernel.

On 08/18/2017 07:07 PM, Gustavo A. R. Silva wrote:
> Call function v4l2_m2m_dst_buf_remove_by_buf() instead of
> v4l2_m2m_src_buf_remove_by_buf()
> 
> Addresses-Coverity-ID: 1415317
> Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> Changes in v2:
>  Stanimir Varbanov confirmed this is a bug. The correct fix is to call
>  function v4l2_m2m_dst_buf_remove_by_buf instead of function
>  v4l2_m2m_src_buf_remove_by_buf in the _else_ branch.
> 
>  drivers/media/platform/qcom/venus/helpers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 5f4434c..2d61879 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -243,7 +243,7 @@ static void return_buf_error(struct venus_inst *inst,
>  	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>  		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
>  	else
> -		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
> +		v4l2_m2m_dst_buf_remove_by_buf(m2m_ctx, vbuf);
>  
>  	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>  }
> 

-- 
regards,
Stan
