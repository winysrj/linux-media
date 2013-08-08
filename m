Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19949 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab3HHPwC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 11:52:02 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR700F1RYQFC000@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Aug 2013 16:52:01 +0100 (BST)
Message-id: <5203BEA0.4040208@samsung.com>
Date: Thu, 08 Aug 2013 17:52:00 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2] v4l: async: Make it safe to unregister unregistered
 notifier
References: <1375974259-2807-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1375974259-2807-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2013 05:04 PM, Laurent Pinchart wrote:
> Calling v4l2_async_notifier_unregister() on a notifier that hasn't been
> registered leads to a crash. To simplify drivers, make it safe to
> unregister a notifier that has not been registered.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Compared to v1, I've modified the NULL check to match the coding style used in
> the rest of the file (!... instead of ... != NULL).
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index b350ab9..10bb62c 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -192,6 +192,9 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	struct device *dev[n_subdev];
>  	int i = 0;
>  
> +	if (!notifier->v4l2_dev)
> +		return;
> +
>  	mutex_lock(&list_lock);
>  
>  	list_del(&notifier->list);
> @@ -225,6 +228,9 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  		}
>  		put_device(d);
>  	}
> +
> +	notifier->v4l2_dev = NULL;
> +
>  	/*
>  	 * Don't care about the waiting list, it is initialised and populated
>  	 * upon notifier registration.
> 

Regards,
Sylwester
