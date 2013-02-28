Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:38374 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3B1PqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 10:46:05 -0500
Received: by mail-la0-f53.google.com with SMTP id fr10so1940006lab.12
        for <linux-media@vger.kernel.org>; Thu, 28 Feb 2013 07:46:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360195382-32317-2-git-send-email-sheu@google.com>
References: <1360195382-32317-1-git-send-email-sheu@google.com> <1360195382-32317-2-git-send-email-sheu@google.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 28 Feb 2013 07:45:21 -0800
Message-ID: <CAMm-=zD8TJY7XcDZ11JFWtKtk-Tmz9RRhh5-Hva4P=WeOkwCrQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media]: v4l2-mem2mem: drop rdy_queue on STREAMOFF
To: John Sheu <sheu@google.com>
Cc: LMML <linux-media@vger.kernel.org>, John Sheu <sheu@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 6, 2013 at 4:03 PM, John Sheu <sheu@google.com> wrote:
> From: John Sheu <sheu@chromium.org>
>
> When a v4l2-mem2mem context gets a STREAMOFF call on either its CAPTURE
> or OUTPUT queues, we should:
> * Drop the corresponding rdy_queue, since a subsequent STREAMON expects
>   an empty queue.
> * Deschedule the context, as it now has at least one empty queue and
>   cannot run.
>
> Signed-off-by: John Sheu <sheu@google.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index c52a2c5..c5c9d24 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -408,10 +408,35 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_streamon);
>  int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>                        enum v4l2_buf_type type)
>  {
> -       struct vb2_queue *vq;
> +       struct v4l2_m2m_dev *m2m_dev;
> +       struct v4l2_m2m_queue_ctx *q_ctx;
> +       unsigned long flags_job, flags;
> +       int ret;
>
> -       vq = v4l2_m2m_get_vq(m2m_ctx, type);
> -       return vb2_streamoff(vq, type);
> +       q_ctx = get_queue_ctx(m2m_ctx, type);
> +       ret = vb2_streamoff(&q_ctx->q, type);
> +       if (ret)
> +               return ret;
> +
> +       m2m_dev = m2m_ctx->m2m_dev;
> +       spin_lock_irqsave(&m2m_dev->job_spinlock, flags_job);
> +       /* We should not be scheduled anymore, since we're dropping a queue. */
> +       INIT_LIST_HEAD(&m2m_ctx->queue);
> +       m2m_ctx->job_flags = 0;
> +
> +       spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
> +       /* Drop queue, since streamoff returns device to the same state as after
> +        * calling reqbufs. */
> +       INIT_LIST_HEAD(&q_ctx->rdy_queue);
> +       spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
> +
> +       if (m2m_dev->curr_ctx == m2m_ctx) {
> +               m2m_dev->curr_ctx = NULL;
> +               wake_up(&m2m_ctx->finished);
> +       }
> +       spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> +
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
>
> --
> 1.8.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Best regards,
Pawel Osciak
