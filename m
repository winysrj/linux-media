Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19937 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965896Ab3HHPvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 11:51:49 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR700NVCYQ64TB0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Aug 2013 16:51:47 +0100 (BST)
Message-id: <5203BE92.1020100@samsung.com>
Date: Thu, 08 Aug 2013 17:51:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: async: Make sure subdevs are stored in a list before
 being moved
References: <1375872115-32505-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1375872115-32505-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/07/2013 12:41 PM, Laurent Pinchart wrote:
> Subdevices have an async_list field used to store them in the global
> list of subdevices or in the notifier done lists. List entries are moved
> from the former to the latter in v4l2_async_test_notify() using
> list_move(). However, v4l2_async_test_notify() can be called right away
> when the subdev is registered with v4l2_async_register_subdev(), in
> which case the entry is not stored in any list.
> 
> Although this behaviour is not correct, the code doesn't crash at the
> moment as the async_list field is initialized as a list head, despite
> being a list entry.
> 
> Add the subdev to the global subdevs list a registration time before
> matching them with the notifiers to make sure the list_move() call will
> get a subdev that is stored in a list, and remove the list head
> initialization for the subdev async_list field.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>


Shouldn't we initialize the async_list field in v4l2_subdev_init() ?

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..31b2375 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -460,6 +460,7 @@ EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate);
 void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 {
        INIT_LIST_HEAD(&sd->list);
+       INIT_LIST_HEAD(&sd->async_list);
        BUG_ON(!ops);
        sd->ops = ops;
        sd->v4l2_dev = NULL;


> ---
>  drivers/media/v4l2-core/v4l2-async.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index b350ab9..4485dfe 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -122,7 +122,7 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  {
>  	v4l2_device_unregister_subdev(sd);
>  	/* Subdevice driver will reprobe and put the subdev back onto the list */
> -	list_del_init(&sd->async_list);
> +	list_del(&sd->async_list);

It is not safe to do so, since v4l2_async_cleanup() can be called multiple
times and list_del() leaves async_list in an undefined state. I'm actually
observing a crash with this change.

>  	sd->asd = NULL;
>  	sd->dev = NULL;
>  }
> @@ -238,7 +238,11 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  
>  	mutex_lock(&list_lock);
>  
> -	INIT_LIST_HEAD(&sd->async_list);
> +	/*
> +	 * Add the subdev to the global subdevs list. It will be moved to the
> +	 * notifier done list by v4l2_async_test_notify().
> +	 */
> +	list_add(&sd->async_list, &subdev_list);
>  
>  	list_for_each_entry(notifier, &notifier_list, list) {
>  		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
> @@ -249,9 +253,6 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  		}
>  	}
>  
> -	/* None matched, wait for hot-plugging */
> -	list_add(&sd->async_list, &subdev_list);
> -
>  	mutex_unlock(&list_lock);
>  
>  	return 0;
> 

Regards,
Sylwester
