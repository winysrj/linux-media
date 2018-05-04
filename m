Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49352 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751107AbeEDLet (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 07:34:49 -0400
Date: Fri, 4 May 2018 14:34:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 24/28] vim2m: use workqueue
Message-ID: <20180504113447.srfsvlgm24ttj6wr@valkosipuli.retiisi.org.uk>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-25-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503145318.128315-25-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, May 03, 2018 at 04:53:14PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> v4l2_ctrl uses mutexes, so we can't setup a ctrl_handler in
> interrupt context. Switch to a workqueue instead.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vim2m.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 9be4da3b8577..a1b0bb08668d 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -150,6 +150,7 @@ struct vim2m_dev {
>  	spinlock_t		irqlock;
>  
>  	struct timer_list	timer;
> +	struct work_struct	work_run;
>  
>  	struct v4l2_m2m_dev	*m2m_dev;
>  };
> @@ -392,9 +393,10 @@ static void device_run(void *priv)
>  	schedule_irq(dev, ctx->transtime);
>  }
>  
> -static void device_isr(struct timer_list *t)
> +static void device_work(struct work_struct *w)
>  {
> -	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t, timer);
> +	struct vim2m_dev *vim2m_dev =
> +		container_of(w, struct vim2m_dev, work_run);
>  	struct vim2m_ctx *curr_ctx;
>  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
>  	unsigned long flags;
> @@ -426,6 +428,13 @@ static void device_isr(struct timer_list *t)
>  	}
>  }
>  
> +static void device_isr(struct timer_list *t)
> +{
> +	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t, timer);
> +
> +	schedule_work(&vim2m_dev->work_run);
> +}
> +
>  /*
>   * video ioctls
>   */
> @@ -806,6 +815,7 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
>  	struct vb2_v4l2_buffer *vbuf;
>  	unsigned long flags;
>  
> +	flush_scheduled_work();
>  	for (;;) {
>  		if (V4L2_TYPE_IS_OUTPUT(q->type))
>  			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> @@ -1011,6 +1021,7 @@ static int vim2m_probe(struct platform_device *pdev)
>  	vfd = &dev->vfd;
>  	vfd->lock = &dev->dev_mutex;
>  	vfd->v4l2_dev = &dev->v4l2_dev;
> +	INIT_WORK(&dev->work_run, device_work);
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	dev->mdev.dev = &pdev->dev;

How about just removing the time and using schedule_delayed_work()
instead? That'd be quite a bit more simple.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
