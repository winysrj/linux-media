Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53337 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750709AbdHRG53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 02:57:29 -0400
Subject: Re: [PATCH] media: venus: fix duplicated code for different branches
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170817231234.GA6674@embeddedgus>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d50b28cb-8430-d1a2-c1a8-98a436582bf7@xs4all.nl>
Date: Fri, 18 Aug 2017 08:57:23 +0200
MIME-Version: 1.0
In-Reply-To: <20170817231234.GA6674@embeddedgus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stanimir, please review this! I suspect that this is the wrong fix and
that the first v4l2_m2m_src_buf_remove_by_buf should be
v4l2_m2m_dst_buf_remove_by_buf instead.

Regards,

	Hans

On 08/18/2017 01:12 AM, Gustavo A. R. Silva wrote:
> Refactor code in order to avoid identical code for different branches.
> 
> This issue was detected with the help of Coccinelle.
> 
> Addresses-Coverity-ID: 1415317
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> This code was reported by Coverity and it was tested by compilation only.
> Please, verify if this is an actual bug.
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
> -
> +	v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
>  	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>  }
>  
> 
