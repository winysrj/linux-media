Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36600 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbdECWub (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 18:50:31 -0400
Received: by mail-lf0-f42.google.com with SMTP id h4so1881528lfj.3
        for <linux-media@vger.kernel.org>; Wed, 03 May 2017 15:50:30 -0700 (PDT)
Date: Thu, 4 May 2017 00:50:28 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l2-async: add subnotifier registration for subdevices
Message-ID: <20170503225028.GV1532@bigcity.dyn.berto.se>
References: <20170427223035.13164-1-niklas.soderlund+renesas@ragnatech.se>
 <20170428102817.GF7456@valkosipuli.retiisi.org.uk>
 <20170428114748.GC1532@bigcity.dyn.berto.se>
 <20170503195146.GP7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170503195146.GP7456@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Sakari,

Tack för dina kommentarer.

On 2017-05-03 22:51:46 +0300, Sakari Ailus wrote:
> Hejssan!
> 
> On Fri, Apr 28, 2017 at 01:47:48PM +0200, Niklas Söderlund wrote:
> > On 2017-04-28 13:28:17 +0300, Sakari Ailus wrote:
> > > Hi Niklas,
> > > 
> > > Thank you for the patch.
> > > 
> > > Do you happen to have a driver that would use this, to see some example of
> > > how the code is to be used?
> > 
> > Yes, the latest R-Car CSI-2 series make use of this, see:
> > 
> > https://www.spinics.net/lists/linux-renesas-soc/msg13693.html
> 
> Ah, thanks. I'll take a look at that --- which should do for other reasons
> as well...
> 
> ...
> 
> > > > +
> > > > +	/*
> > > > +	 * This function can be called recursively so the list
> > > > +	 * might be modified in a recursive call. Start from the
> > > > +	 * top of the list each iteration.
> > > > +	 */
> > > > +	found = 1;
> > > > +	while (found) {
> > > > +		found = 0;
> > > >  
> > > > -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > > > -		int ret;
> > > > +		list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > > > +			int ret;
> > > >  
> > > > -		asd = v4l2_async_belongs(notifier, sd);
> > > > -		if (!asd)
> > > > -			continue;
> > > > +			asd = v4l2_async_belongs(notifier, sd);
> > > > +			if (!asd)
> > > > +				continue;
> > > >  
> > > > -		ret = v4l2_async_test_notify(notifier, sd, asd);
> > > > -		if (ret < 0) {
> > > > -			mutex_unlock(&list_lock);
> > > > -			return ret;
> > > > +			ret = v4l2_async_test_notify(notifier, sd, asd);
> > > > +			if (ret < 0) {
> > > > +				if (!subnotifier)
> > > > +					mutex_unlock(&list_lock);
> > > > +				return ret;
> > > > +			}
> > > > +
> > > > +			found = 1;
> > > > +			break;
> > > >  		}
> > > >  	}
> > > >  
> > > >  	/* Keep also completed notifiers on the list */
> > > >  	list_add(&notifier->list, &notifier_list);
> > > >  
> > > > -	mutex_unlock(&list_lock);
> > > > +	if (!subnotifier)
> > > > +		mutex_unlock(&list_lock);
> > > >  
> > > >  	return 0;
> > > >  }
> > > > +
> > > > +int v4l2_async_subnotifier_register(struct v4l2_subdev *sd,
> > > > +				    struct v4l2_async_notifier *notifier)
> > > > +{
> > > > +	if (!sd->v4l2_dev) {
> > > > +		dev_err(sd->dev ? sd->dev : NULL,
> 
> sd->dev is enough.

Thanks, but I think i will drop the dev_err() all together and just 
return -EINVAL once i move this to what will be called 
v4l2_async_do_notifier_register() as you suggest bellow.

> 
> > > > +			"Can't register subnotifier for without v4l2_dev\n");
> > > > +		return -EINVAL;
> > > 
> > > When did this start happening? :-)
> > 
> > What do you mean? I'm not sure I understand this comment.
> 
> Uh, right. So the caller simply needs to specify v4l2_dev? The same applies
> to v4l2_async_notifier_register() which does not test that --- but it
> should.
> 
> How about adding this change in a separate patch to what will be called
> v4l2_async_do_notifier_register()?

I agree, I will do this in a separate patch before I add the 
v4l2_async_subnotifier_register().

> 
> > 
> > > 
> > > > +	}
> > > > +
> > > > +	return v4l2_async_do_notifier_register(sd->v4l2_dev, notifier, true);
> > > > +}
> > > > +EXPORT_SYMBOL(v4l2_async_subnotifier_register);
> > > > +
> > > > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > > > +				 struct v4l2_async_notifier *notifier)
> > > > +{
> > > > +	return v4l2_async_do_notifier_register(v4l2_dev, notifier, false);
> > > > +}
> > > >  EXPORT_SYMBOL(v4l2_async_notifier_register);
> > > >  
> > > > -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > > > +static void
> > > > +v4l2_async_do_notifier_unregister(struct v4l2_async_notifier *notifier,
> > > > +				  bool subnotifier)
> > > >  {
> > > >  	struct v4l2_subdev *sd, *tmp;
> > > >  	unsigned int notif_n_subdev = notifier->num_subdevs;
> > > > @@ -210,7 +248,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > > >  			"Failed to allocate device cache!\n");
> > > >  	}
> > > >  
> > > > -	mutex_lock(&list_lock);
> > > > +	if (!subnotifier)
> > > > +		mutex_lock(&list_lock);
> > > >  
> > > >  	list_del(&notifier->list);
> > > >  
> > > > @@ -237,15 +276,20 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > > >  			put_device(d);
> > > >  	}
> > > >  
> > > > -	mutex_unlock(&list_lock);
> > > > +	if (!subnotifier)
> > > > +		mutex_unlock(&list_lock);
> > > >  
> > > >  	/*
> > > >  	 * Call device_attach() to reprobe devices
> > > >  	 *
> > > >  	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
> > > >  	 * executed.
> > > > +	 * TODO: If we are unregistering a subdevice notifier we can't reprobe
> > > > +	 * since the lock_list is held by the master device and attaching that
> > > > +	 * device would call v4l2_async_register_subdev() and end in a deadlock
> > > > +	 * on list_lock.
> > > >  	 */
> > > > -	while (i--) {
> > > > +	while (i-- && !subnotifier) {
> > > 
> > > Why is this not done for sub-notifiers?
> > > 
> > > That said, the code here looks really dubious. But that's out of scope of
> > > the patchset.
> > 
> > I try to explain this in the comment above :-)
> > 
> > If this is called for sub-notifiers it will result in the probe function 
> > of the subdevices it contained to be called. And as most drivers call 
> > v4l2_async_register_subdev() in there probe functions this will result 
> > in a dead lock since v4l2_async_register_subdev() will try to lock the 
> > list_lock (which for sub-notifiers already is held).
> > 
> > This is not optimal of course and I agree with you that this code is 
> > dubious. It calls remove and then probe on all subdevices of the 
> > notifier that is unregistered.
> 
> Ack. Let's address this one later.

Thanks, I also think this part should be addressed but separately.

> 
> -- 
> Trevliga hälsningar,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Regards,
Niklas Söderlund
