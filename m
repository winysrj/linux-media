Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:37108 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdHRHwm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 03:52:42 -0400
Received: by mail-wr0-f172.google.com with SMTP id z91so54825240wrc.4
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 00:52:41 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH] media: venus: fix duplicated code for different branches
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170817231234.GA6674@embeddedgus>
Message-ID: <99a35cad-9152-ec15-7843-de4668a9190f@linaro.org>
Date: Fri, 18 Aug 2017 10:52:38 +0300
MIME-Version: 1.0
In-Reply-To: <20170817231234.GA6674@embeddedgus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On 08/18/2017 02:12 AM, Gustavo A. R. Silva wrote:
> Refactor code in order to avoid identical code for different branches.
> 
> This issue was detected with the help of Coccinelle.
> 
> Addresses-Coverity-ID: 1415317
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> This code was reported by Coverity and it was tested by compilation only.
> Please, verify if this is an actual bug.

Yes looks like copy/paste error, and yes it is a bug.

> 
>  drivers/media/platform/qcom/venus/helpers.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 5f4434c..8a5c467 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -240,11 +240,7 @@ static void return_buf_error(struct venus_inst *inst,
>  {
>  	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
>  
> -	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
> -	else
> -		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);

the correct fix must replace the second v4l2_m2m_src_* with v4l2_m2m_dst_*.

> -
> +	v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
>  	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>  }
>  
> 

-- 
regards,
Stan
