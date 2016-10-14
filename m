Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42960 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753574AbcJNPsi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 11:48:38 -0400
Message-ID: <1476460116.11834.42.camel@pengutronix.de>
Subject: Re: [PATCH 02/22] [media] v4l2-async: allow subdevices to add
 further subdevices to the notifier waiting list
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Date: Fri, 14 Oct 2016 17:48:36 +0200
In-Reply-To: <20161007224321.GC9460@valkosipuli.retiisi.org.uk>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-3-p.zabel@pengutronix.de>
         <20161007224321.GC9460@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 08.10.2016, 01:43 +0300 schrieb Sakari Ailus:
[...]
> >  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  {
> >  	struct v4l2_subdev *sd, *tmp;
> > -	unsigned int notif_n_subdev = notifier->num_subdevs;
> > -	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> > +	unsigned int notif_n_subdev = 0;
> > +	unsigned int n_subdev;
> > +	struct list_head *list;
> >  	struct device **dev;
> >  	int i = 0;
> >  
> > @@ -218,6 +273,10 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  
> >  	list_del(&notifier->list);
> >  
> > +	list_for_each(list, &notifier->done)
> > +		++notif_n_subdev;
> > +	n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> > +
> 
> Shouldn't this change go to a separate patch? It seems unrelated.

Thanks, this was intended to count the notifier done list instead of
relying on notifier->num_subdevs because of the additional asynchronous
subdevs added to the notifier that are not part of the original array.
Unfortunately this change is a few lines too late, it belongs before the
device cache is allocated. I'll fix this and add a comment.

I don't want to increment notifier->num_subdevs in
__v4l2_async_notifier_add_subdev because the caller of
v4l2_async_notifier_register might still use it to measure the original
array.

> >  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> >  		struct device *d;
> >  
> > @@ -294,8 +353,19 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  	list_for_each_entry(notifier, &notifier_list, list) {
> >  		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
> >  		if (asd) {
> > +			struct list_head *tail = notifier->waiting.prev;
> >  			int ret = v4l2_async_test_notify(notifier, sd, asd);
> > +
> > +			/*
> > +			 * If entries were added to the notifier waiting list,
> > +			 * check if the corresponding subdevices are already
> > +			 * available.
> > +			 */
> > +			if (tail != notifier->waiting.prev)
> > +				ret = v4l2_async_test_notify_all(notifier);
> > +
> >  			mutex_unlock(&list_lock);
> > +
> >  			return ret;
> >  		}
> >  	}
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index 8e2a236..e4e4b11 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -114,6 +114,18 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  				 struct v4l2_async_notifier *notifier);
> >  
> >  /**
> > + * __v4l2_async_notifier_add_subdev - adds a subdevice to the notifier waitlist
> > + *
> > + * @v4l2_notifier: notifier the calling subdev is bound to
> 
> s/v4l2_//

I'd be happy to, but why should the v4l2 prefix be removed?

regards
Philipp

