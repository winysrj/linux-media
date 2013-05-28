Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47189 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934279Ab3E1Odu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 10:33:50 -0400
Received: by mail-lb0-f172.google.com with SMTP id p10so7837147lbi.3
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 07:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369356108-15865-1-git-send-email-sheu@google.com>
References: <1369356108-15865-1-git-send-email-sheu@google.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 28 May 2013 07:33:02 -0700
Message-ID: <CAMm-=zCie7k3_SNpaAO3BhwUL0XRtYyN34GBFtN306Ur+6gfqQ@mail.gmail.com>
Subject: Re: [PATCH] [media] v4l2: mem2mem: save irq flags correctly
To: John Sheu <sheu@google.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

John, thanks for the patch.

On Thu, May 23, 2013 at 5:41 PM, John Sheu <sheu@google.com> wrote:
> Save flags correctly when taking spinlocks in v4l2_m2m_try_schedule.
>
> Signed-off-by: John Sheu <sheu@google.com>

Acked-by: Pawel Osciak <pawel@osciak.com>


> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 66f599f..3606ff2 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -205,7 +205,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
>  static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  {
>         struct v4l2_m2m_dev *m2m_dev;
> -       unsigned long flags_job, flags;
> +       unsigned long flags_job, flags_out, flags_cap;
>
>         m2m_dev = m2m_ctx->m2m_dev;
>         dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
> @@ -223,23 +223,26 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>                 return;
>         }
>
> -       spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
> +       spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
>         if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
> -               spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
> +               spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
> +                                       flags_out);
>                 spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>                 dprintk("No input buffers available\n");
>                 return;
>         }
> -       spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
> +       spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
>         if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
> -               spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
> -               spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
> +               spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock,
> +                                       flags_cap);
> +               spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
> +                                       flags_out);
>                 spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>                 dprintk("No output buffers available\n");
>                 return;
>         }
> -       spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
> -       spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
> +       spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
> +       spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
>
>         if (m2m_dev->m2m_ops->job_ready
>                 && (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
> --
> 1.8.2.1
>



--
Best regards,
Pawel Osciak
