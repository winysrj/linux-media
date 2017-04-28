Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33568 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756382AbdD1Lrx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:47:53 -0400
Received: by mail-lf0-f42.google.com with SMTP id 88so32511863lfr.0
        for <linux-media@vger.kernel.org>; Fri, 28 Apr 2017 04:47:52 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 28 Apr 2017 13:47:48 +0200
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l2-async: add subnotifier registration for subdevices
Message-ID: <20170428114748.GC1532@bigcity.dyn.berto.se>
References: <20170427223035.13164-1-niklas.soderlund+renesas@ragnatech.se>
 <20170428102817.GF7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170428102817.GF7456@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your feedback.

On 2017-04-28 13:28:17 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> Do you happen to have a driver that would use this, to see some example of
> how the code is to be used?

Yes, the latest R-Car CSI-2 series make use of this, see:

https://www.spinics.net/lists/linux-renesas-soc/msg13693.html

> 
> Could you update the documentation in
> Documentation/media/kapi/v4l2-subdev.rst, too?

Yes will do so for the next version, thanks for reminding me.

> 
> On Fri, Apr 28, 2017 at 12:30:35AM +0200, Niklas Söderlund wrote:
> > When registered() of v4l2_subdev_internal_ops is called the subdevice
> > have access to the master devices v4l2_dev and it's called with the
> > async frameworks list_lock held. In this context the subdevice can
> > register its own notifiers to allow for incremental discovery of
> > subdevices.
> > 
> > The master device registers the subdevices closest to itself in its
> > notifier while the subdevice(s) themself register notifiers for there
> > closest neighboring devices when they are registered. Using this
> > incremental approach two problems can be solved.
> > 
> > 1. The master device no longer have to care how many subdevices exist in
> 
> s/subdevices/devices/ ?
> 
> A single sub-device driver can expose multiple sub-devices for a single
> device.

Thanks.

> 
> >    the pipeline. It only needs to care about its closest subdevice and
> >    arbitrary long pipelines can be created without having to adapt the
> >    master device for each case.
> > 
> > 2. Subdevices which are represented as a single DT node but register
> >    more then one subdevice can use this to further the pipeline
> >    discovery. Since the subdevice driver is the only one who knows which
> >    of its subdevices is linked with which subdevice of a neighboring DT
> >    node.
> > 
> > To enable subdevices to register/unregister notifiers from the
> > registered()/unregistered() callback v4l2_async_subnotifier_register()
> > and v4l2_async_subnotifier_unregister() are added. These new notifier
> > register functions are similar to the master device equivalent functions
> > but run without taking the v4l2-async list_lock which already are held
> > when he registered()/unregistered() callbacks are called.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 91 +++++++++++++++++++++++++++++-------
> >  include/media/v4l2-async.h           | 22 +++++++++
> >  2 files changed, 95 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 96cc733f35ef72b0..d4a676a2935eb058 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -136,12 +136,13 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> >  	sd->dev = NULL;
> >  }
> >  
> > -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > -				 struct v4l2_async_notifier *notifier)
> > +static int v4l2_async_do_notifier_register(struct v4l2_device *v4l2_dev,
> > +					   struct v4l2_async_notifier *notifier,
> > +					   bool subnotifier)
> >  {
> >  	struct v4l2_subdev *sd, *tmp;
> >  	struct v4l2_async_subdev *asd;
> > -	int i;
> > +	int found, i;
> 
> If you need a boolean value, you could use bool type.

Will update to use bool in next version.

> 
> >  
> >  	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> >  		return -EINVAL;
> > @@ -168,32 +169,69 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  		list_add_tail(&asd->list, &notifier->waiting);
> >  	}
> >  
> > -	mutex_lock(&list_lock);
> > +	if (!subnotifier)
> > +		mutex_lock(&list_lock);
> 
> Just to be sure, I'd verify the mutex is indeed acquired.
> lockdep_assert_held(mutex) ?

Neat, was not aware of this function. Will use in next version.

> 
> > +
> > +	/*
> > +	 * This function can be called recursively so the list
> > +	 * might be modified in a recursive call. Start from the
> > +	 * top of the list each iteration.
> > +	 */
> > +	found = 1;
> > +	while (found) {
> > +		found = 0;
> >  
> > -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > -		int ret;
> > +		list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > +			int ret;
> >  
> > -		asd = v4l2_async_belongs(notifier, sd);
> > -		if (!asd)
> > -			continue;
> > +			asd = v4l2_async_belongs(notifier, sd);
> > +			if (!asd)
> > +				continue;
> >  
> > -		ret = v4l2_async_test_notify(notifier, sd, asd);
> > -		if (ret < 0) {
> > -			mutex_unlock(&list_lock);
> > -			return ret;
> > +			ret = v4l2_async_test_notify(notifier, sd, asd);
> > +			if (ret < 0) {
> > +				if (!subnotifier)
> > +					mutex_unlock(&list_lock);
> > +				return ret;
> > +			}
> > +
> > +			found = 1;
> > +			break;
> >  		}
> >  	}
> >  
> >  	/* Keep also completed notifiers on the list */
> >  	list_add(&notifier->list, &notifier_list);
> >  
> > -	mutex_unlock(&list_lock);
> > +	if (!subnotifier)
> > +		mutex_unlock(&list_lock);
> >  
> >  	return 0;
> >  }
> > +
> > +int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
> > +				    struct v4l2_async_notifier *notifier)
> > +{
> > +	if (!sd->v4l2_dev) {
> > +		dev_err(sd->dev ? sd->dev : NULL,
> > +			"Can't register subnotifier for without v4l2_dev\n");
> > +		return -EINVAL;
> 
> When did this start happening? :-)

What do you mean? I'm not sure I understand this comment.

> 
> > +	}
> > +
> > +	return v4l2_async_do_notifier_register(sd->v4l2_dev, notifier, true);
> > +}
> > +EXPORT_SYMBOL(v4l2_async_subnotifier_register);
> > +
> > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > +				 struct v4l2_async_notifier *notifier)
> > +{
> > +	return v4l2_async_do_notifier_register(v4l2_dev, notifier, false);
> > +}
> >  EXPORT_SYMBOL(v4l2_async_notifier_register);
> >  
> > -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > +static void
> > +v4l2_async_do_notifier_unregister(struct v4l2_async_notifier *notifier,
> > +				  bool subnotifier)
> >  {
> >  	struct v4l2_subdev *sd, *tmp;
> >  	unsigned int notif_n_subdev = notifier->num_subdevs;
> > @@ -210,7 +248,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  			"Failed to allocate device cache!\n");
> >  	}
> >  
> > -	mutex_lock(&list_lock);
> > +	if (!subnotifier)
> > +		mutex_lock(&list_lock);
> >  
> >  	list_del(&notifier->list);
> >  
> > @@ -237,15 +276,20 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  			put_device(d);
> >  	}
> >  
> > -	mutex_unlock(&list_lock);
> > +	if (!subnotifier)
> > +		mutex_unlock(&list_lock);
> >  
> >  	/*
> >  	 * Call device_attach() to reprobe devices
> >  	 *
> >  	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
> >  	 * executed.
> > +	 * TODO: If we are unregistering a subdevice notifier we can't reprobe
> > +	 * since the lock_list is held by the master device and attaching that
> > +	 * device would call v4l2_async_register_subdev() and end in a deadlock
> > +	 * on list_lock.
> >  	 */
> > -	while (i--) {
> > +	while (i-- && !subnotifier) {
> 
> Why is this not done for sub-notifiers?
> 
> That said, the code here looks really dubious. But that's out of scope of
> the patchset.

I try to explain this in the comment above :-)

If this is called for sub-notifiers it will result in the probe function 
of the subdevices it contained to be called. And as most drivers call 
v4l2_async_register_subdev() in there probe functions this will result 
in a dead lock since v4l2_async_register_subdev() will try to lock the 
list_lock (which for sub-notifiers already is held).

This is not optimal of course and I agree with you that this code is 
dubious. It calls remove and then probe on all subdevices of the 
notifier that is unregistered.

> 
> >  		struct device *d = dev[i];
> >  
> >  		if (d && device_attach(d) < 0) {
> > @@ -269,6 +313,17 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  	 * upon notifier registration.
> >  	 */
> >  }
> > +
> > +void v4l2_async_subnotifier_unregister(struct v4l2_async_notifier *notifier)
> > +{
> > +	v4l2_async_do_notifier_unregister(notifier, true);
> > +}
> > +EXPORT_SYMBOL(v4l2_async_subnotifier_unregister);
> > +
> > +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > +{
> > +	v4l2_async_do_notifier_unregister(notifier, false);
> > +}
> >  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> >  
> >  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index 8e2a236a4d039df6..dee070be59f211bd 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -105,6 +105,18 @@ struct v4l2_async_notifier {
> >  };
> >  
> >  /**
> > + * v4l2_async_notifier_register - registers a subdevice asynchronous subnotifier
> > + *
> > + * @sd: pointer to &struct v4l2_subdev
> > + * @notifier: pointer to &struct v4l2_async_notifier
> > + *
> > + * This function assumes the async list_lock is already locked, allowing
> > + * it to be used from struct v4l2_subdev_internal_ops registered() callback.
> > + */
> > +int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
> > +				    struct v4l2_async_notifier *notifier);
> > +
> > +/**
> >   * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
> >   *
> >   * @v4l2_dev: pointer to &struct v4l2_device
> > @@ -114,6 +126,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  				 struct v4l2_async_notifier *notifier);
> >  
> >  /**
> > + * v4l2_async_subnotifier_unregister - unregisters a asynchronous subnotifier
> > + *
> > + * @notifier: pointer to &struct v4l2_async_notifier
> > + *
> > + * This function assumes the async list_lock is already locked, allowing
> > + * it to be used from struct v4l2_subdev_internal_ops unregistered() callback.
> > + */
> > +void v4l2_async_subnotifier_unregister(struct v4l2_async_notifier *notifier);
> > +
> > +/**
> >   * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
> >   *
> >   * @notifier: pointer to &struct v4l2_async_notifier
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Regards,
Niklas Söderlund
