Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:42979 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbeJKOQK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 10:16:10 -0400
Received: by mail-io1-f68.google.com with SMTP id n18-v6so5784701ioa.9
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 23:50:18 -0700 (PDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com. [209.85.166.51])
        by smtp.gmail.com with ESMTPSA id w9-v6sm10156159iog.7.2018.10.10.23.50.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 23:50:17 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id y10-v6so5785239ioa.10
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 23:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20181011064608.37435-1-acourbot@chromium.org>
In-Reply-To: <20181011064608.37435-1-acourbot@chromium.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 11 Oct 2018 15:50:05 +0900
Message-ID: <CAPBb6MXXwCOP6w7WdAFXdbmBLWKFp9gVDUW=uE=UFGiq_jPakg@mail.gmail.com>
Subject: Re: [PATCH] media: venus: support VB2_USERPTR IO mode
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please ignore this patch - I did not notice that a similar one has
been sent before. >_<
On Thu, Oct 11, 2018 at 3:46 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> The venus codec can work just fine with USERPTR buffers. Enable this
> possibility.
>
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 4 ++--
>  drivers/media/platform/qcom/venus/venc.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 33320c5025313f..dfc2260e8d213a 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -984,7 +984,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
>         int ret;
>
>         src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -       src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +       src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>         src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>         src_vq->ops = &vdec_vb2_ops;
>         src_vq->mem_ops = &vb2_dma_sg_memops;
> @@ -999,7 +999,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
>                 return ret;
>
>         dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -       dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +       dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>         dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>         dst_vq->ops = &vdec_vb2_ops;
>         dst_vq->mem_ops = &vb2_dma_sg_memops;
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index d2805b5e28a1b2..71ca59a24991be 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -1073,7 +1073,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
>         int ret;
>
>         src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -       src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +       src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>         src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>         src_vq->ops = &venc_vb2_ops;
>         src_vq->mem_ops = &vb2_dma_sg_memops;
> @@ -1090,7 +1090,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
>                 return ret;
>
>         dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -       dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +       dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>         dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>         dst_vq->ops = &venc_vb2_ops;
>         dst_vq->mem_ops = &vb2_dma_sg_memops;
> --
> 2.19.0.605.g01d371f741-goog
>
