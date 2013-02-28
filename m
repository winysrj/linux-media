Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58969 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3B1Ppg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 10:45:36 -0500
Received: by mail-lb0-f173.google.com with SMTP id gf7so1476558lbb.4
        for <linux-media@vger.kernel.org>; Thu, 28 Feb 2013 07:45:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360195382-32317-1-git-send-email-sheu@google.com>
References: <1360195382-32317-1-git-send-email-sheu@google.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 28 Feb 2013 07:44:54 -0800
Message-ID: <CAMm-=zCVOOW9quWQHm7dk27UC5X7pFJsBArDzb4yhLzOvberHg@mail.gmail.com>
Subject: Re: [PATCH 1/3] [media] v4l2-mem2mem: use CAPTURE queue lock
To: John Sheu <sheu@google.com>
Cc: LMML <linux-media@vger.kernel.org>, John Sheu <sheu@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 6, 2013 at 4:03 PM, John Sheu <sheu@google.com> wrote:
> From: John Sheu <sheu@chromium.org>
>
> In v4l2_m2m_try_schedule(), use the CAPTURE queue lock when accessing
> the CAPTURE queue, instead of relying on just holding the OUTPUT queue
> lock.
>
> Signed-off-by: John Sheu <sheu@google.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 438ea45..c52a2c5 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -230,12 +230,15 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>                 dprintk("No input buffers available\n");
>                 return;
>         }
> +       spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
>         if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
> +               spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
>                 spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
>                 spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>                 dprintk("No output buffers available\n");
>                 return;
>         }
> +       spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
>         spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
>
>         if (m2m_dev->m2m_ops->job_ready
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
