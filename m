Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:44411 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3KEMDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 07:03:25 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVS003ATHHE2Q30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Nov 2013 07:03:24 -0500 (EST)
Date: Tue, 05 Nov 2013 10:03:18 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCHv2 22/29] v4l2-async: Don't use dynamic static allocation
Message-id: <20131105100318.31da034b@samsung.com>
In-reply-to: <5278D99F.5050508@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
 <1383399097-11615-23-git-send-email-m.chehab@samsung.com>
 <52779DD8.3080401@xs4all.nl> <20131105093628.6da1a600@samsung.com>
 <5278D99F.5050508@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 05 Nov 2013 12:42:23 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> On 05/11/13 12:36, Mauro Carvalho Chehab wrote:
> >>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> >>> > > index c85d69da35bd..071596869036 100644
> >>> > > --- a/drivers/media/v4l2-core/v4l2-async.c
> >>> > > +++ b/drivers/media/v4l2-core/v4l2-async.c
> >>> > > @@ -189,12 +189,14 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >>> > >  	struct v4l2_subdev *sd, *tmp;
> >>> > >  	unsigned int notif_n_subdev = notifier->num_subdevs;
> >>> > >  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> >>> > > -	struct device *dev[n_subdev];
> >>> > > +	struct device **dev;
> >>> > >  	int i = 0;
> >>> > >  
> >>> > >  	if (!notifier->v4l2_dev)
> >>> > >  		return;
> >>> > >  
> >>> > > +	dev = kmalloc(sizeof(*dev) * n_subdev, GFP_KERNEL);
> >>> > > +
> >> > 
> >> > No check for dev == NULL?
> > Well, what should be done in this case?
> > 
> > We could do the changes below:
> > 
> >  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  {
> >         struct v4l2_subdev *sd, *tmp;
> >         unsigned int notif_n_subdev = notifier->num_subdevs;
> >         unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> > -       struct device *dev[n_subdev];
> > +       struct device **dev;
> >         int i = 0;
> >  
> >         if (!notifier->v4l2_dev)
> >                 return;
> >  
> > +       dev = kmalloc(sizeof(*dev) * n_subdev, GFP_KERNEL);
> > +       if (!dev) {
> > +               WARN_ON(true);
> > +               return;
> > +       }
> > +
> >         mutex_lock(&list_lock);
> >  
> >         list_del(&notifier->list);
> >  
> >         list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> >                 dev[i] = get_device(sd->dev);
> >  
> >                 v4l2_async_cleanup(sd);
> >  
> >                 /* If we handled USB devices, we'd have to lock the parent too */
> >                 device_release_driver(dev[i++]);
> >  
> >                 if (notifier->unbind)
> >                         notifier->unbind(notifier, sd, sd->asd);
> >         }
> >  
> >         mutex_unlock(&list_lock);
> >  
> >         while (i--) {
> >                 struct device *d = dev[i];
> >  
> >                 if (d && device_attach(d) < 0) {
> >                         const char *name = "(none)";
> >                         int lock = device_trylock(d);
> >  
> >                         if (lock && d->driver)
> >                                 name = d->driver->name;
> >                         dev_err(d, "Failed to re-probe to %s\n", name);
> >                         if (lock)
> >                                 device_unlock(d);
> >                 }
> >                 put_device(d);
> >         }
> > +       kfree(dev);
> >  
> >         notifier->v4l2_dev = NULL;
> >  
> >         /*
> >          * Don't care about the waiting list, it is initialised and populated
> >          * upon notifier registration.
> >          */
> >  }
> >  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> > 
> > But I suspect that this will cause an OOPS anyway, as the device will be
> > only half-removed. So, it would likely OOPS at device removal or if the
> > device got probed again, at probing time.
> > 
> > So, IMHO, we should have at least a WARN_ON() for this case.
> > 
> > Do you have a better idea?
> 
> This is how Guennadi's patch looked like when it used dynamic allocation:
> 
> http://www.spinics.net/lists/linux-sh/msg18194.html

Thanks for the tip!

The following patch should do the trick (generated with -U10, in order
to show the entire function):

[PATCHv3] v4l2-async: Don't use dynamic static allocation

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/v4l2-core/v4l2-async.c:238:1: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer.

In this specific case, there's a hard limit imposed by V4L2_MAX_SUBDEVS,
with is currently 128. That means that the buffer size can be up to
128x8 = 1024 bytes (on a 64bits kernel), with is too big for stack.

Worse than that, someone could increase it and cause real troubles.

So, let's use dynamically allocated data, instead.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index c85d69da35bd..b56c9f300ecb 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -182,59 +182,84 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_subdev *sd, *tmp;
 	unsigned int notif_n_subdev = notifier->num_subdevs;
 	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
-	struct device *dev[n_subdev];
+	struct device **dev;
 	int i = 0;
 
 	if (!notifier->v4l2_dev)
 		return;
 
+	dev = kmalloc(n_subdev * sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(notifier->v4l2_dev->dev,
+			"Failed to allocate device cache!\n");
+	}
+
 	mutex_lock(&list_lock);
 
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		dev[i] = get_device(sd->dev);
+		struct device *d;
+
+		d = get_device(sd->dev);
 
 		v4l2_async_cleanup(sd);
 
 		/* If we handled USB devices, we'd have to lock the parent too */
-		device_release_driver(dev[i++]);
+		device_release_driver(d);
+
+
+		/*
+		 * Store device at the device cache, in order to call
+		 * put_device() on the final step
+		 */
+		if (dev)
+			dev[i++] = d;
+		else
+			put_device(d);
 
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, sd->asd);
 	}
 
 	mutex_unlock(&list_lock);
 
+	/*
+	 * Call device_attach() to reprobe devices
+	 *
+	 * NOTE: If dev allocation fails, i is 0, and the hole loop won't be
+	 * executed.
+	 */
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
+	kfree(dev);
 
 	notifier->v4l2_dev = NULL;
 
 	/*
 	 * Don't care about the waiting list, it is initialised and populated
 	 * upon notifier registration.
 	 */
 }
 EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
Regards,
Mauro
