Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:35419 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2HaSe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 14:34:29 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9M00LAOU9G7VE0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Sep 2012 03:34:28 +0900 (KST)
Received: from [106.210.235.55] by mmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M9M00BMHU9BZV00@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Sep 2012 03:34:28 +0900 (KST)
Message-id: <504103AE.3020305@samsung.com>
Date: Fri, 31 Aug 2012 20:34:22 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] media v4l2-mem2mem: Use list_first_entry
References: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de>
 <1346419084-10879-2-git-send-email-s.hauer@pengutronix.de>
In-reply-to: <1346419084-10879-2-git-send-email-s.hauer@pengutronix.de>
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 8/31/2012 3:18 PM, Sascha Hauer wrote:
> Use list_first_entry instead of list_entry which makes the intention
> of the code more clear.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/video/v4l2-mem2mem.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
> index 975d0fa..aaa67d3 100644
> --- a/drivers/media/video/v4l2-mem2mem.c
> +++ b/drivers/media/video/v4l2-mem2mem.c
> @@ -102,7 +102,7 @@ void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx)
>   		return NULL;
>   	}
>
> -	b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
> +	b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
>   	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
>   	return &b->vb;
>   }
> @@ -122,7 +122,7 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
>   		spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
>   		return NULL;
>   	}
> -	b = list_entry(q_ctx->rdy_queue.next, struct v4l2_m2m_buffer, list);
> +	b = list_first_entry(&q_ctx->rdy_queue, struct v4l2_m2m_buffer, list);
>   	list_del(&b->list);
>   	q_ctx->num_rdy--;
>   	spin_unlock_irqrestore(&q_ctx->rdy_spinlock, flags);
> @@ -175,7 +175,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
>   		return;
>   	}
>
> -	m2m_dev->curr_ctx = list_entry(m2m_dev->job_queue.next,
> +	m2m_dev->curr_ctx = list_first_entry(&m2m_dev->job_queue,
>   				   struct v4l2_m2m_ctx, queue);
>   	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
>   	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
>


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
