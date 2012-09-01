Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43875 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2IAB3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 21:29:07 -0400
Received: by vcbfk26 with SMTP id fk26so3931028vcb.19
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2012 18:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346419084-10879-2-git-send-email-s.hauer@pengutronix.de>
References: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de> <1346419084-10879-2-git-send-email-s.hauer@pengutronix.de>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 31 Aug 2012 18:28:20 -0700
Message-ID: <CAMm-=zCm6pN8Ty02m=9F8NjrHo6fthT89QXz7S_=MQeSWCF5rQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] media v4l2-mem2mem: Use list_first_entry
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, Pawel Osciak <p.osciak@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 31, 2012 at 6:18 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Use list_first_entry instead of list_entry which makes the intention
> of the code more clear.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---

Acked-by: Pawel Osciak <pawel@osciak.com>

Thanks for the patch Sascha!


>  drivers/media/video/v4l2-mem2mem.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
> index 975d0fa..aaa67d3 100644
> --- a/drivers/media/video/v4l2-mem2mem.c
> +++ b/drivers/media/video/v4l2-mem2mem.c
> @@ -102,7 +102,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
>                 return NULL;
>         }
>
> -       b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
> +       b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
>         spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
>         return &b->vb;
>  }
> @@ -122,7 +122,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
>                 spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
>                 return NULL;
>         }
> -       b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
> +       b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
>         list_del(&b->list);
>         q_ctx->num_rdy--;
>         spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
> @@ -175,7 +175,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
>                 return;
>         }
>
> -       m2m_dev->curr_ctx = list_entry(m2m_dev->job_queue.next,
> +       m2m_dev->curr_ctx = list_first_entry(&m2m_dev->job_queue,
>                                    struct v4l2_m2m_ctx, queue);
>         m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
>         spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
