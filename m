Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36487 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdGROjj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 10:39:39 -0400
Received: by mail-lf0-f41.google.com with SMTP id d78so11548427lfg.3
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 07:39:38 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 18 Jul 2017 16:39:36 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH v4 2/3] v4l: async: do not hold list_lock when reprobing
 devices
Message-ID: <20170718143936.GC28538@bigcity.dyn.berto.se>
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
 <20170717165917.24851-3-niklas.soderlund+renesas@ragnatech.se>
 <5a184e14-b429-fd7d-fc0c-d0520e1cc3fa@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a184e14-b429-fd7d-fc0c-d0520e1cc3fa@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback.

On 2017-07-18 16:22:14 +0200, Hans Verkuil wrote:
> On 17/07/17 18:59, Niklas Söderlund wrote:
> > There is no good reason to hold the list_lock when reprobing the devices
> > and it prevents a clean implementation of subdevice notifiers. Move the
> > actual release of the devices outside of the loop which requires the
> > lock to be held.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 29 ++++++++++-------------------
> >  1 file changed, 10 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 0acf288d7227ba97..8fc84f7962386ddd 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -206,7 +206,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  	unsigned int notif_n_subdev = notifier->num_subdevs;
> >  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> >  	struct device **dev;
> > -	int i = 0;
> > +	int i, count = 0;
> >  
> >  	if (!notifier->v4l2_dev)
> >  		return;
> > @@ -222,37 +222,28 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  	list_del(&notifier->list);
> >  
> >  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> > -		struct device *d;
> > -
> > -		d = get_device(sd->dev);
> > +		if (dev)
> > +			dev[count] = get_device(sd->dev);
> > +		count++;
> >  
> >  		if (notifier->unbind)
> >  			notifier->unbind(notifier, sd, sd->asd);
> >  
> >  		v4l2_async_cleanup(sd);
> > +	}
> >  
> > -		/* If we handled USB devices, we'd have to lock the parent too */
> > -		device_release_driver(d);
> > +	mutex_unlock(&list_lock);
> >  
> > -		/*
> > -		 * Store device at the device cache, in order to call
> > -		 * put_device() on the final step
> > -		 */
> > +	for (i = 0; i < count; i++) {
> > +		/* If we handled USB devices, we'd have to lock the parent too */
> >  		if (dev)
> > -			dev[i++] = d;
> > -		else
> > -			put_device(d);
> > +			device_release_driver(dev[i]);
> 
> This changes the behavior. If the alloc failed, then at least put_device was still called.
> Now that no longer happens.

Yes, but also changes the behavior to also only call get_device() if the 
allocation was successful. So the behavior is kept the same as far as I 
understands it.

> 
> Frankly I don't understand this code, it is in desperate need of some comments explaining
> this whole reprobing thing.

I agree that the code is in need of comments, but I feel a patch that 
separates the v4l2-async work from the re-probing work is a step in the 
right direction :-)

> 
> I have this strong feeling that this function needs to be reworked.

I also strongly agree with this.

> 
> Regards,
> 
> 	Hans
> 
> >  	}
> >  
> > -	mutex_unlock(&list_lock);
> > -
> >  	/*
> >  	 * Call device_attach() to reprobe devices
> > -	 *
> > -	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
> > -	 * executed.
> >  	 */
> > -	while (i--) {
> > +	for (i = 0; dev && i < count; i++) {
> >  		struct device *d = dev[i];
> >  
> >  		if (d && device_attach(d) < 0) {
> > 
> 

-- 
Regards,
Niklas Söderlund
