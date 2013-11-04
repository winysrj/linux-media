Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1913 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3KDNPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 08:15:45 -0500
Message-ID: <52779DD8.3080401@xs4all.nl>
Date: Mon, 04 Nov 2013 14:15:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCHv2 22/29] v4l2-async: Don't use dynamic static allocation
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com> <1383399097-11615-23-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-23-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/02/2013 02:31 PM, Mauro Carvalho Chehab wrote:
> Dynamic static allocation is evil, as Kernel stack is too low, and
> compilation complains about it on some archs:
> 
> 	drivers/media/v4l2-core/v4l2-async.c:238:1: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]
> 
> Instead, let's enforce a limit for the buffer.
> 
> In this specific case, there's a hard limit imposed by V4L2_MAX_SUBDEVS,
> with is currently 128. That means that the buffer size can be up to
> 128x8 = 1024 bytes (on a 64bits kernel), with is too big for stack.
> 
> Worse than that, someone could increase it and cause real troubles.
> 
> So, let's use dynamically allocated data, instead.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index c85d69da35bd..071596869036 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -189,12 +189,14 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	struct v4l2_subdev *sd, *tmp;
>  	unsigned int notif_n_subdev = notifier->num_subdevs;
>  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> -	struct device *dev[n_subdev];
> +	struct device **dev;
>  	int i = 0;
>  
>  	if (!notifier->v4l2_dev)
>  		return;
>  
> +	dev = kmalloc(sizeof(*dev) * n_subdev, GFP_KERNEL);
> +

No check for dev == NULL?

Regards,

	Hans

>  	mutex_lock(&list_lock);
>  
>  	list_del(&notifier->list);
> @@ -228,6 +230,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  		}
>  		put_device(d);
>  	}
> +	kfree(dev);
>  
>  	notifier->v4l2_dev = NULL;
>  
> 

