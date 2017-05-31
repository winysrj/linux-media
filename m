Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30630 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdEaMJf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:09:35 -0400
Subject: Re: [PATCH RFC] v4l2-core: Use kvmalloc() for potentially big
 allocations
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <d10f7660-f9d0-198a-f7ed-bc789fe53acc@samsung.com>
Date: Wed, 31 May 2017 14:09:29 +0200
MIME-version: 1.0
In-reply-to: <20170531065837.30346-1-tfiga@chromium.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20170531065846epcas5p4d4cf5a7cb2bb86fe4e9d9151fc83a896@epcas5p4.samsung.com>
 <20170531065837.30346-1-tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 2017-05-31 08:58, Tomasz Figa wrote:
> There are multiple places where arrays or otherwise variable sized
> buffer are allocated through V4L2 core code, including things like
> controls, memory pages, staging buffers for ioctls and so on. Such
> allocations can potentially require an order > 0 allocation from the
> page allocator, which is not guaranteed to be fulfilled and is likely to
> fail on a system with severe memory fragmentation (e.g. a system with
> very long uptime).
>
> Since the memory being allocated is intended to be used by the CPU
> exclusively, we can consider using vmalloc() as a fallback and this is
> exactly what the recently merged kvmalloc() helpers do. A kmalloc() call
> is still attempted, even for order > 0 allocations, but it is done
> with __GFP_NORETRY and __GFP_NOWARN, with expectation of failing if
> requested memory is not available instantly. Only then the vmalloc()
> fallback is used. This should give us fast and more reliable allocations
> even on systems with higher memory pressure and/or more fragmentation,
> while still retaining the same performance level on systems not
> suffering from such conditions.
>
> While at it, replace explicit array size calculations on changed
> allocations with kvmalloc_array().
>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>   drivers/media/v4l2-core/v4l2-async.c       |  4 ++--
>   drivers/media/v4l2-core/v4l2-ctrls.c       | 25 +++++++++++++------------
>   drivers/media/v4l2-core/v4l2-event.c       |  8 +++++---
>   drivers/media/v4l2-core/v4l2-ioctl.c       |  6 +++---
>   drivers/media/v4l2-core/v4l2-subdev.c      |  7 ++++---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c |  8 ++++----

For vb2:
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

There are also a few vmalloc calls in old videobuf (v1) framework, which
might be converted to kvmalloc if you have a few spare minutes to take
a look.

>   6 files changed, 31 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 96cc733f35ef..2d2d9f1f8831 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -204,7 +204,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>   	if (!notifier->v4l2_dev)
>   		return;
>   
> -	dev = kmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
> +	dev = kvmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
>   	if (!dev) {
>   		dev_err(notifier->v4l2_dev->dev,
>   			"Failed to allocate device cache!\n");
> @@ -260,7 +260,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>   		}
>   		put_device(d);
>   	}
> -	kfree(dev);
> +	kvfree(dev);
>   
>   	notifier->v4l2_dev = NULL;
>   
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ec42872d11cf..88025527c67e 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1745,8 +1745,9 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
>   	INIT_LIST_HEAD(&hdl->ctrls);
>   	INIT_LIST_HEAD(&hdl->ctrl_refs);
>   	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
> -	hdl->buckets = kcalloc(hdl->nr_of_buckets, sizeof(hdl->buckets[0]),
> -			       GFP_KERNEL);
> +	hdl->buckets = kvmalloc_array(hdl->nr_of_buckets,
> +				      sizeof(hdl->buckets[0]),
> +				      GFP_KERNEL | __GFP_ZERO);
>   	hdl->error = hdl->buckets ? 0 : -ENOMEM;
>   	return hdl->error;
>   }
> @@ -1773,9 +1774,9 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>   		list_del(&ctrl->node);
>   		list_for_each_entry_safe(sev, next_sev, &ctrl->ev_subs, node)
>   			list_del(&sev->node);
> -		kfree(ctrl);
> +		kvfree(ctrl);
>   	}
> -	kfree(hdl->buckets);
> +	kvfree(hdl->buckets);
>   	hdl->buckets = NULL;
>   	hdl->cached = NULL;
>   	hdl->error = 0;
> @@ -2022,7 +2023,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>   		 is_array)
>   		sz_extra += 2 * tot_ctrl_size;
>   
> -	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
> +	ctrl = kvzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
>   	if (ctrl == NULL) {
>   		handler_set_err(hdl, -ENOMEM);
>   		return NULL;
> @@ -2071,7 +2072,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>   	}
>   
>   	if (handler_new_ref(hdl, ctrl)) {
> -		kfree(ctrl);
> +		kvfree(ctrl);
>   		return NULL;
>   	}
>   	mutex_lock(hdl->lock);
> @@ -2824,8 +2825,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>   		return class_check(hdl, cs->which);
>   
>   	if (cs->count > ARRAY_SIZE(helper)) {
> -		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
> -					GFP_KERNEL);
> +		helpers = kvmalloc_array(cs->count, sizeof(helper[0]),
> +					 GFP_KERNEL);
>   		if (helpers == NULL)
>   			return -ENOMEM;
>   	}
> @@ -2877,7 +2878,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>   	}
>   
>   	if (cs->count > ARRAY_SIZE(helper))
> -		kfree(helpers);
> +		kvfree(helpers);
>   	return ret;
>   }
>   EXPORT_SYMBOL(v4l2_g_ext_ctrls);
> @@ -3079,8 +3080,8 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>   		return class_check(hdl, cs->which);
>   
>   	if (cs->count > ARRAY_SIZE(helper)) {
> -		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
> -					GFP_KERNEL);
> +		helpers = kvmalloc_array(cs->count, sizeof(helper[0]),
> +					 GFP_KERNEL);
>   		if (!helpers)
>   			return -ENOMEM;
>   	}
> @@ -3157,7 +3158,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>   	}
>   
>   	if (cs->count > ARRAY_SIZE(helper))
> -		kfree(helpers);
> +		kvfree(helpers);
>   	return ret;
>   }
>   
> diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
> index a75df6cb141f..5f072ef8ff57 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -24,6 +24,7 @@
>   #include <linux/sched.h>
>   #include <linux/slab.h>
>   #include <linux/export.h>
> +#include <linux/mm.h>
>   
>   static unsigned sev_pos(const struct v4l2_subscribed_event *sev, unsigned idx)
>   {
> @@ -214,7 +215,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>   	if (elems < 1)
>   		elems = 1;
>   
> -	sev = kzalloc(sizeof(*sev) + sizeof(struct v4l2_kevent) * elems, GFP_KERNEL);
> +	sev = kvzalloc(sizeof(*sev) + sizeof(struct v4l2_kevent) * elems,
> +		       GFP_KERNEL);
>   	if (!sev)
>   		return -ENOMEM;
>   	for (i = 0; i < elems; i++)
> @@ -232,7 +234,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>   	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>   
>   	if (found_ev) {
> -		kfree(sev);
> +		kvfree(sev);
>   		return 0; /* Already listening */
>   	}
>   
> @@ -304,7 +306,7 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>   	if (sev && sev->ops && sev->ops->del)
>   		sev->ops->del(sev);
>   
> -	kfree(sev);
> +	kvfree(sev);
>   
>   	return 0;
>   }
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index e5a2187381db..098e8be36ea6 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2811,7 +2811,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>   			parg = sbuf;
>   		} else {
>   			/* too big to allocate from stack */
> -			mbuf = kmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
> +			mbuf = kvmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
>   			if (NULL == mbuf)
>   				return -ENOMEM;
>   			parg = mbuf;
> @@ -2858,7 +2858,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>   		 * array) fits into sbuf (so that mbuf will still remain
>   		 * unused up to here).
>   		 */
> -		mbuf = kmalloc(array_size, GFP_KERNEL);
> +		mbuf = kvmalloc(array_size, GFP_KERNEL);
>   		err = -ENOMEM;
>   		if (NULL == mbuf)
>   			goto out_array_args;
> @@ -2901,7 +2901,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>   	}
>   
>   out:
> -	kfree(mbuf);
> +	kvfree(mbuf);
>   	return err;
>   }
>   EXPORT_SYMBOL(video_usercopy);
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index da78497ae5ed..053d06bb407d 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -577,13 +577,14 @@ v4l2_subdev_alloc_pad_config(struct v4l2_subdev *sd)
>   	if (!sd->entity.num_pads)
>   		return NULL;
>   
> -	cfg = kcalloc(sd->entity.num_pads, sizeof(*cfg), GFP_KERNEL);
> +	cfg = kvmalloc_array(sd->entity.num_pads, sizeof(*cfg),
> +			     GFP_KERNEL | __GFP_ZERO);
>   	if (!cfg)
>   		return NULL;
>   
>   	ret = v4l2_subdev_call(sd, pad, init_cfg, cfg);
>   	if (ret < 0 && ret != -ENOIOCTLCMD) {
> -		kfree(cfg);
> +		kvfree(cfg);
>   		return NULL;
>   	}
>   
> @@ -593,7 +594,7 @@ EXPORT_SYMBOL_GPL(v4l2_subdev_alloc_pad_config);
>   
>   void v4l2_subdev_free_pad_config(struct v4l2_subdev_pad_config *cfg)
>   {
> -	kfree(cfg);
> +	kvfree(cfg);
>   }
>   EXPORT_SYMBOL_GPL(v4l2_subdev_free_pad_config);
>   #endif /* CONFIG_MEDIA_CONTROLLER */
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 8e8798a74760..5defa1f22ca2 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -120,8 +120,8 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
>   	buf->num_pages = size >> PAGE_SHIFT;
>   	buf->dma_sgt = &buf->sg_table;
>   
> -	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
> -			     GFP_KERNEL);
> +	buf->pages = kvmalloc_array(buf->num_pages, sizeof(struct page *),
> +				    GFP_KERNEL | __GFP_ZERO);
>   	if (!buf->pages)
>   		goto fail_pages_array_alloc;
>   
> @@ -165,7 +165,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
>   	while (num_pages--)
>   		__free_page(buf->pages[num_pages]);
>   fail_pages_alloc:
> -	kfree(buf->pages);
> +	kvfree(buf->pages);
>   fail_pages_array_alloc:
>   	kfree(buf);
>   	return ERR_PTR(-ENOMEM);
> @@ -187,7 +187,7 @@ static void vb2_dma_sg_put(void *buf_priv)
>   		sg_free_table(buf->dma_sgt);
>   		while (--i >= 0)
>   			__free_page(buf->pages[i]);
> -		kfree(buf->pages);
> +		kvfree(buf->pages);
>   		put_device(buf->dev);
>   		kfree(buf);
>   	}

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
