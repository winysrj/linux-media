Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43222 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbeKAVkz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 17:40:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id t10-v6so19909947wrn.10
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 05:38:07 -0700 (PDT)
Subject: Re: [PATCH] media: venus: add support for USERPTR to queue
To: Malathi Gottam <mgottam@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1539071557-1500-1-git-send-email-mgottam@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <eef03e29-0057-0101-6188-f91715a9eb06@linaro.org>
Date: Thu, 1 Nov 2018 14:38:04 +0200
MIME-Version: 1.0
In-Reply-To: <1539071557-1500-1-git-send-email-mgottam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

Thanks for the patch!

On 10/9/18 10:52 AM, Malathi Gottam wrote:
> Add USERPTR to queue access methods by adding this
> support to io_modes on both the planes.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index 754c19a..b86994c 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -1096,7 +1096,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
>  	int ret;
>  
>  	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>  	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	src_vq->ops = &venc_vb2_ops;
>  	src_vq->mem_ops = &vb2_dma_sg_memops;
> @@ -1112,7 +1112,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
>  		return ret;
>  
>  	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>  	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->ops = &venc_vb2_ops;
>  	dst_vq->mem_ops = &vb2_dma_sg_memops;
> 

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
