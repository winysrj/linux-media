Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbeHMRrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:47:42 -0400
Date: Mon, 13 Aug 2018 12:05:01 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 30/34] vim2m: use workqueue
Message-ID: <20180813120501.2e630010@coco.lan>
In-Reply-To: <20180804124526.46206-31-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-31-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:22 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> v4l2_ctrl uses mutexes, so we can't setup a ctrl_handler in
> interrupt context. Switch to a workqueue instead and drop the timer.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Shouldn't this come earlier at the series (before adding request API
support to m2m) in order to avoid regressions?

> ---
>  drivers/media/platform/vim2m.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 462099a141e4..6f87ef025ff1 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -3,7 +3,8 @@
>   *
>   * This is a virtual device driver for testing mem-to-mem videobuf framework.
>   * It simulates a device that uses memory buffers for both source and
> - * destination, processes the data and issues an "irq" (simulated by a timer).
> + * destination, processes the data and issues an "irq" (simulated by a delayed
> + * workqueue).
>   * The device is capable of multi-instance, multi-buffer-per-transaction
>   * operation (via the mem2mem framework).
>   *
> @@ -19,7 +20,6 @@
>  #include <linux/module.h>
>  #include <linux/delay.h>
>  #include <linux/fs.h>
> -#include <linux/timer.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  
> @@ -148,7 +148,7 @@ struct vim2m_dev {
>  	struct mutex		dev_mutex;
>  	spinlock_t		irqlock;
>  
> -	struct timer_list	timer;
> +	struct delayed_work	work_run;
>  
>  	struct v4l2_m2m_dev	*m2m_dev;
>  };
> @@ -336,12 +336,6 @@ static int device_process(struct vim2m_ctx *ctx,
>  	return 0;
>  }
>  
> -static void schedule_irq(struct vim2m_dev *dev, int msec_timeout)
> -{
> -	dprintk(dev, "Scheduling a simulated irq\n");
> -	mod_timer(&dev->timer, jiffies + msecs_to_jiffies(msec_timeout));
> -}
> -
>  /*
>   * mem2mem callbacks
>   */
> @@ -387,13 +381,14 @@ static void device_run(void *priv)
>  
>  	device_process(ctx, src_buf, dst_buf);
>  
> -	/* Run a timer, which simulates a hardware irq  */
> -	schedule_irq(dev, ctx->transtime);
> +	/* Run delayed work, which simulates a hardware irq  */
> +	schedule_delayed_work(&dev->work_run, msecs_to_jiffies(ctx->transtime));
>  }
>  
> -static void device_isr(struct timer_list *t)
> +static void device_work(struct work_struct *w)
>  {
> -	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t, timer);
> +	struct vim2m_dev *vim2m_dev =
> +		container_of(w, struct vim2m_dev, work_run.work);
>  	struct vim2m_ctx *curr_ctx;
>  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
>  	unsigned long flags;
> @@ -805,6 +800,7 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
>  	struct vb2_v4l2_buffer *vbuf;
>  	unsigned long flags;
>  
> +	flush_scheduled_work();
>  	for (;;) {
>  		if (V4L2_TYPE_IS_OUTPUT(q->type))
>  			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> @@ -1015,6 +1011,7 @@ static int vim2m_probe(struct platform_device *pdev)
>  	vfd = &dev->vfd;
>  	vfd->lock = &dev->dev_mutex;
>  	vfd->v4l2_dev = &dev->v4l2_dev;
> +	INIT_DELAYED_WORK(&dev->work_run, device_work);
>  
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  	if (ret) {
> @@ -1026,7 +1023,6 @@ static int vim2m_probe(struct platform_device *pdev)
>  	v4l2_info(&dev->v4l2_dev,
>  			"Device registered as /dev/video%d\n", vfd->num);
>  
> -	timer_setup(&dev->timer, device_isr, 0);
>  	platform_set_drvdata(pdev, dev);
>  
>  	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
> @@ -1083,7 +1079,6 @@ static int vim2m_remove(struct platform_device *pdev)
>  	media_device_cleanup(&dev->mdev);
>  #endif
>  	v4l2_m2m_release(dev->m2m_dev);
> -	del_timer_sync(&dev->timer);
>  	video_unregister_device(&dev->vfd);
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  



Thanks,
Mauro
