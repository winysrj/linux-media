Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33949 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdCBQcO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 11:32:14 -0500
Received: by mail-oi0-f47.google.com with SMTP id m124so42039028oig.1
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 08:30:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170302095144.32090-1-p.zabel@pengutronix.de>
References: <20170302095144.32090-1-p.zabel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Thu, 2 Mar 2017 17:30:23 +0100
Message-ID: <CAH-u=83Jib=vFPXQTsfojssrR3h8eXzm_1imufZ9NKJ=0DPdgw@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: implement encoder stop command
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>

> +       /* If there is no buffer in flight, wake up */
> +       if (ctx->qsequence == ctx->osequence) {

Not sure about this one, I would have done something like :
if (!(ctx->fh.m2m_ctx->job_flags)) {

> +               dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +                                        V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +               dst_vq->last_buffer_dequeued = true;
> +               wake_up(&dst_vq->done_wq);
> +       }
> +
> +       return 0;
> +}
> +
>  static int coda_try_decoder_cmd(struct file *file, void *fh,
>                                 struct v4l2_decoder_cmd *dc)
>  {
> @@ -1054,6 +1095,8 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
>
>         .vidioc_g_selection     = coda_g_selection,
>
> +       .vidioc_try_encoder_cmd = coda_try_encoder_cmd,
> +       .vidioc_encoder_cmd     = coda_encoder_cmd,
>         .vidioc_try_decoder_cmd = coda_try_decoder_cmd,
>         .vidioc_decoder_cmd     = coda_decoder_cmd,
>
> @@ -1330,9 +1373,13 @@ static void coda_buf_queue(struct vb2_buffer *vb)
>                 mutex_lock(&ctx->bitstream_mutex);
>                 v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
>                 if (vb2_is_streaming(vb->vb2_queue))
> +                       /* This set buf->sequence = ctx->qsequence++ */
>                         coda_fill_bitstream(ctx, true);
>                 mutex_unlock(&ctx->bitstream_mutex);
>         } else {
> +               if (ctx->inst_type == CODA_INST_ENCODER &&
> +                   vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +                       vbuf->sequence = ctx->qsequence++;
>                 v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
>         }
>  }
> --
> 2.11.0
>
