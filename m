Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:37114 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbeDQEhp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 00:37:45 -0400
Received: by mail-it0-f65.google.com with SMTP id 71-v6so14519309ith.2
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:37:45 -0700 (PDT)
Received: from mail-it0-f50.google.com (mail-it0-f50.google.com. [209.85.214.50])
        by smtp.gmail.com with ESMTPSA id t65sm3889369iof.88.2018.04.16.21.37.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Apr 2018 21:37:44 -0700 (PDT)
Received: by mail-it0-f50.google.com with SMTP id h143-v6so14256519ita.4
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-28-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-28-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 17 Apr 2018 04:37:33 +0000
Message-ID: <CAPBb6MXpLtTyr--_Vy3PYZJZYy--bxY87SNrAa+8f5=bA=qn9w@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 27/29] vim2m: support requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Add support for requests to vim2m.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/platform/vim2m.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)

> diff --git a/drivers/media/platform/vim2m.c
b/drivers/media/platform/vim2m.c
> index 9b18b32c255d..2dcf0ea85705 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -387,8 +387,26 @@ static void device_run(void *priv)
>          src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>          dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);

> +       /* Apply request if needed */
> +       if (src_buf->vb2_buf.req_obj.req)
> +               v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);
> +       if (dst_buf->vb2_buf.req_obj.req &&
> +           dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
> +               v4l2_ctrl_request_setup(dst_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);

This implies that we can have two different requests active at the same time
for the same device. Do we want to open that can of worms?

Valid scenarios for requests should be clearly defined. In the case of a
simple
buffer processor like vim2m, something like "request required for source
buffer,
optional and must be same as source if specified for destination", looks
simple
and sane.

> +
>          device_process(ctx, src_buf, dst_buf);

> +       /* Complete request if needed */
> +       if (src_buf->vb2_buf.req_obj.req)
> +               v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);
> +       if (dst_buf->vb2_buf.req_obj.req &&
> +           dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
> +               v4l2_ctrl_request_complete(dst_buf->vb2_buf.req_obj.req,
> +                                       &ctx->hdl);
> +
>          /* Run a timer, which simulates a hardware irq  */
>          schedule_irq(dev, ctx->transtime);
>   }
> @@ -823,6 +841,8 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
>                          vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>                  if (vbuf == NULL)
>                          return;
> +               v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> +                                          &ctx->hdl);
>                  spin_lock_irqsave(&ctx->dev->irqlock, flags);
>                  v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>                  spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
> @@ -1003,6 +1023,10 @@ static const struct v4l2_m2m_ops m2m_ops = {
>          .job_abort      = job_abort,
>   };

> +static const struct media_device_ops m2m_media_ops = {
> +       .req_queue = vb2_request_queue,
> +};
> +
>   static int vim2m_probe(struct platform_device *pdev)
>   {
>          struct vim2m_dev *dev;
> @@ -1027,6 +1051,7 @@ static int vim2m_probe(struct platform_device *pdev)
>          dev->mdev.dev = &pdev->dev;
>          strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
>          media_device_init(&dev->mdev);
> +       dev->mdev.ops = &m2m_media_ops;
>          dev->v4l2_dev.mdev = &dev->mdev;
>          dev->pad[0].flags = MEDIA_PAD_FL_SINK;
>          dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
> --
> 2.16.3
