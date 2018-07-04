Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59830 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932346AbeGDIEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 04:04:23 -0400
Subject: Re: [PATCH v2 2/3] s5p-g2d: Remove unrequired wait in .job_abort
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
References: <20180618043852.13293-1-ezequiel@collabora.com>
 <20180618043852.13293-3-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0c63d9ee-88c4-c09d-ec36-cc0ee3ca3d8f@xs4all.nl>
Date: Wed, 4 Jul 2018 10:04:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180618043852.13293-3-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/06/18 06:38, Ezequiel Garcia wrote:
> As per the documentation, job_abort is not required
> to wait until the current job finishes. It is redundant
> to do so, as the core will perform the wait operation.
> 
> Remove the wait infrastructure completely.

Sylwester, can you review this?

Thanks!

	Hans

> 
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kamil Debski <kamil@wypas.org>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/platform/s5p-g2d/g2d.c | 11 -----------
>  drivers/media/platform/s5p-g2d/g2d.h |  1 -
>  2 files changed, 12 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
> index 66aa8cf1d048..e98708883413 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ b/drivers/media/platform/s5p-g2d/g2d.c
> @@ -483,15 +483,6 @@ static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *c
>  
>  static void job_abort(void *prv)
>  {
> -	struct g2d_ctx *ctx = prv;
> -	struct g2d_dev *dev = ctx->dev;
> -
> -	if (dev->curr == NULL) /* No job currently running */
> -		return;
> -
> -	wait_event_timeout(dev->irq_queue,
> -			   dev->curr == NULL,
> -			   msecs_to_jiffies(G2D_TIMEOUT));
>  }
>  
>  static void device_run(void *prv)
> @@ -563,7 +554,6 @@ static irqreturn_t g2d_isr(int irq, void *prv)
>  	v4l2_m2m_job_finish(dev->m2m_dev, ctx->fh.m2m_ctx);
>  
>  	dev->curr = NULL;
> -	wake_up(&dev->irq_queue);
>  	return IRQ_HANDLED;
>  }
>  
> @@ -633,7 +623,6 @@ static int g2d_probe(struct platform_device *pdev)
>  	spin_lock_init(&dev->ctrl_lock);
>  	mutex_init(&dev->mutex);
>  	atomic_set(&dev->num_inst, 0);
> -	init_waitqueue_head(&dev->irq_queue);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  
> diff --git a/drivers/media/platform/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
> index dd812b557e87..9ffb458a1b93 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.h
> +++ b/drivers/media/platform/s5p-g2d/g2d.h
> @@ -31,7 +31,6 @@ struct g2d_dev {
>  	struct g2d_ctx		*curr;
>  	struct g2d_variant	*variant;
>  	int irq;
> -	wait_queue_head_t	irq_queue;
>  };
>  
>  struct g2d_frame {
> 
