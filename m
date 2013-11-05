Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:43837 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3KELge (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 06:36:34 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVS00BFGG8VEN50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Nov 2013 06:36:32 -0500 (EST)
Date: Tue, 05 Nov 2013 09:36:28 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCHv2 22/29] v4l2-async: Don't use dynamic static allocation
Message-id: <20131105093628.6da1a600@samsung.com>
In-reply-to: <52779DD8.3080401@xs4all.nl>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
 <1383399097-11615-23-git-send-email-m.chehab@samsung.com>
 <52779DD8.3080401@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 04 Nov 2013 14:15:04 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 11/02/2013 02:31 PM, Mauro Carvalho Chehab wrote:
> > Dynamic static allocation is evil, as Kernel stack is too low, and
> > compilation complains about it on some archs:
> > 
> > 	drivers/media/v4l2-core/v4l2-async.c:238:1: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]
> > 
> > Instead, let's enforce a limit for the buffer.
> > 
> > In this specific case, there's a hard limit imposed by V4L2_MAX_SUBDEVS,
> > with is currently 128. That means that the buffer size can be up to
> > 128x8 = 1024 bytes (on a 64bits kernel), with is too big for stack.
> > 
> > Worse than that, someone could increase it and cause real troubles.
> > 
> > So, let's use dynamically allocated data, instead.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index c85d69da35bd..071596869036 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -189,12 +189,14 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  	struct v4l2_subdev *sd, *tmp;
> >  	unsigned int notif_n_subdev = notifier->num_subdevs;
> >  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> > -	struct device *dev[n_subdev];
> > +	struct device **dev;
> >  	int i = 0;
> >  
> >  	if (!notifier->v4l2_dev)
> >  		return;
> >  
> > +	dev = kmalloc(sizeof(*dev) * n_subdev, GFP_KERNEL);
> > +
> 
> No check for dev == NULL?

Well, what should be done in this case?

We could do the changes below:

 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
        struct v4l2_subdev *sd, *tmp;
        unsigned int notif_n_subdev = notifier->num_subdevs;
        unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
-       struct device *dev[n_subdev];
+       struct device **dev;
        int i = 0;
 
        if (!notifier->v4l2_dev)
                return;
 
+       dev = kmalloc(sizeof(*dev) * n_subdev, GFP_KERNEL);
+       if (!dev) {
+               WARN_ON(true);
+               return;
+       }
+
        mutex_lock(&list_lock);
 
        list_del(&notifier->list);
 
        list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
                dev[i] = get_device(sd->dev);
 
                v4l2_async_cleanup(sd);
 
                /* If we handled USB devices, we'd have to lock the parent too */
                device_release_driver(dev[i++]);
 
                if (notifier->unbind)
                        notifier->unbind(notifier, sd, sd->asd);
        }
 
        mutex_unlock(&list_lock);
 
        while (i--) {
                struct device *d = dev[i];
 
                if (d && device_attach(d) < 0) {
                        const char *name = "(none)";
                        int lock = device_trylock(d);
 
                        if (lock && d->driver)
                                name = d->driver->name;
                        dev_err(d, "Failed to re-probe to %s\n", name);
                        if (lock)
                                device_unlock(d);
                }
                put_device(d);
        }
+       kfree(dev);
 
        notifier->v4l2_dev = NULL;
 
        /*
         * Don't care about the waiting list, it is initialised and populated
         * upon notifier registration.
         */
 }
 EXPORT_SYMBOL(v4l2_async_notifier_unregister);

But I suspect that this will cause an OOPS anyway, as the device will be
only half-removed. So, it would likely OOPS at device removal or if the
device got probed again, at probing time.

So, IMHO, we should have at least a WARN_ON() for this case.

Do you have a better idea?

Regards,
Mauro
