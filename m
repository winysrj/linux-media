Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42523 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3KELmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 06:42:31 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVS001ISGIIIY60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Nov 2013 11:42:29 +0000 (GMT)
Message-id: <5278D99F.5050508@samsung.com>
Date: Tue, 05 Nov 2013 12:42:23 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCHv2 22/29] v4l2-async: Don't use dynamic static allocation
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
 <1383399097-11615-23-git-send-email-m.chehab@samsung.com>
 <52779DD8.3080401@xs4all.nl> <20131105093628.6da1a600@samsung.com>
In-reply-to: <20131105093628.6da1a600@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/13 12:36, Mauro Carvalho Chehab wrote:
>>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>>> > > index c85d69da35bd..071596869036 100644
>>> > > --- a/drivers/media/v4l2-core/v4l2-async.c
>>> > > +++ b/drivers/media/v4l2-core/v4l2-async.c
>>> > > @@ -189,12 +189,14 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>>> > >  	struct v4l2_subdev *sd, *tmp;
>>> > >  	unsigned int notif_n_subdev = notifier->num_subdevs;
>>> > >  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
>>> > > -	struct device *dev[n_subdev];
>>> > > +	struct device **dev;
>>> > >  	int i = 0;
>>> > >  
>>> > >  	if (!notifier->v4l2_dev)
>>> > >  		return;
>>> > >  
>>> > > +	dev = kmalloc(sizeof(*dev) * n_subdev, GFP_KERNEL);
>>> > > +
>> > 
>> > No check for dev == NULL?
> Well, what should be done in this case?
> 
> We could do the changes below:
> 
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
>         struct v4l2_subdev *sd, *tmp;
>         unsigned int notif_n_subdev = notifier->num_subdevs;
>         unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> -       struct device *dev[n_subdev];
> +       struct device **dev;
>         int i = 0;
>  
>         if (!notifier->v4l2_dev)
>                 return;
>  
> +       dev = kmalloc(sizeof(*dev) * n_subdev, GFP_KERNEL);
> +       if (!dev) {
> +               WARN_ON(true);
> +               return;
> +       }
> +
>         mutex_lock(&list_lock);
>  
>         list_del(&notifier->list);
>  
>         list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
>                 dev[i] = get_device(sd->dev);
>  
>                 v4l2_async_cleanup(sd);
>  
>                 /* If we handled USB devices, we'd have to lock the parent too */
>                 device_release_driver(dev[i++]);
>  
>                 if (notifier->unbind)
>                         notifier->unbind(notifier, sd, sd->asd);
>         }
>  
>         mutex_unlock(&list_lock);
>  
>         while (i--) {
>                 struct device *d = dev[i];
>  
>                 if (d && device_attach(d) < 0) {
>                         const char *name = "(none)";
>                         int lock = device_trylock(d);
>  
>                         if (lock && d->driver)
>                                 name = d->driver->name;
>                         dev_err(d, "Failed to re-probe to %s\n", name);
>                         if (lock)
>                                 device_unlock(d);
>                 }
>                 put_device(d);
>         }
> +       kfree(dev);
>  
>         notifier->v4l2_dev = NULL;
>  
>         /*
>          * Don't care about the waiting list, it is initialised and populated
>          * upon notifier registration.
>          */
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> 
> But I suspect that this will cause an OOPS anyway, as the device will be
> only half-removed. So, it would likely OOPS at device removal or if the
> device got probed again, at probing time.
> 
> So, IMHO, we should have at least a WARN_ON() for this case.
> 
> Do you have a better idea?

This is how Guennadi's patch looked like when it used dynamic allocation:

http://www.spinics.net/lists/linux-sh/msg18194.html

--
Regards,
Sylwester
