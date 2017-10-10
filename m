Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46046 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756065AbdJJM5l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 08:57:41 -0400
Date: Tue, 10 Oct 2017 15:57:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v15 04/32] v4l: async: Fix notifier complete callback
 error handling
Message-ID: <20171010125735.rl5yicxvxpx726el@valkosipuli.retiisi.org.uk>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-5-sakari.ailus@linux.intel.com>
 <c4734787-b4e3-34fb-f0e3-3866fba92e14@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4734787-b4e3-34fb-f0e3-3866fba92e14@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Oct 09, 2017 at 01:45:25PM +0200, Hans Verkuil wrote:
> On 04/10/17 23:50, Sakari Ailus wrote:
> > The notifier complete callback may return an error. This error code was
> > simply returned to the caller but never handled properly.
> > 
> > Move calling the complete callback function to the caller from
> > v4l2_async_test_notify and undo the work that was done either in async
> > sub-device or async notifier registration.
> > 
> > Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 78 +++++++++++++++++++++++++++---------
> >  1 file changed, 60 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index ca281438a0ae..4924481451ca 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -122,9 +122,6 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> >  	/* Move from the global subdevice list to notifier's done */
> >  	list_move(&sd->async_list, &notifier->done);
> >  
> > -	if (list_empty(&notifier->waiting) && notifier->complete)
> > -		return notifier->complete(notifier);
> > -
> >  	return 0;
> >  }
> >  
> > @@ -136,11 +133,27 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> >  	sd->asd = NULL;
> >  }
> >  
> > +static void v4l2_async_notifier_unbind_all_subdevs(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_subdev *sd, *tmp;
> > +
> > +	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> > +		if (notifier->unbind)
> > +			notifier->unbind(notifier, sd, sd->asd);
> > +
> > +		v4l2_async_cleanup(sd);
> > +
> > +		list_move(&sd->async_list, &subdev_list);
> > +	}
> > +}
> > +
> >  int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  				 struct v4l2_async_notifier *notifier)
> >  {
> >  	struct v4l2_subdev *sd, *tmp;
> >  	struct v4l2_async_subdev *asd;
> > +	int ret;
> >  	int i;
> >  
> >  	if (!v4l2_dev || !notifier->num_subdevs ||
> > @@ -185,19 +198,30 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  		}
> >  	}
> >  
> > +	if (list_empty(&notifier->waiting) && notifier->complete) {
> > +		ret = notifier->complete(notifier);
> > +		if (ret)
> > +			goto err_complete;
> > +	}
> > +
> >  	/* Keep also completed notifiers on the list */
> >  	list_add(&notifier->list, &notifier_list);
> >  
> >  	mutex_unlock(&list_lock);
> >  
> >  	return 0;
> > +
> > +err_complete:
> > +	v4l2_async_notifier_unbind_all_subdevs(notifier);
> > +
> > +	mutex_unlock(&list_lock);
> > +
> > +	return ret;
> >  }
> >  EXPORT_SYMBOL(v4l2_async_notifier_register);
> >  
> >  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  {
> > -	struct v4l2_subdev *sd, *tmp;
> > -
> >  	if (!notifier->v4l2_dev)
> >  		return;
> >  
> > @@ -205,14 +229,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  
> >  	list_del(&notifier->list);
> >  
> > -	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> > -		if (notifier->unbind)
> > -			notifier->unbind(notifier, sd, sd->asd);
> > -
> > -		v4l2_async_cleanup(sd);
> > -
> > -		list_move(&sd->async_list, &subdev_list);
> > -	}
> > +	v4l2_async_notifier_unbind_all_subdevs(notifier);
> >  
> >  	mutex_unlock(&list_lock);
> >  
> > @@ -223,6 +240,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> >  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  {
> >  	struct v4l2_async_notifier *notifier;
> > +	int ret;
> >  
> >  	/*
> >  	 * No reference taken. The reference is held by the device
> > @@ -238,19 +256,43 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  
> >  	list_for_each_entry(notifier, &notifier_list, list) {
> >  		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
> > -		if (asd) {
> > -			int ret = v4l2_async_test_notify(notifier, sd, asd);
> > -			mutex_unlock(&list_lock);
> > -			return ret;
> > -		}
> > +		int ret;
> > +
> > +		if (!asd)
> > +			continue;
> > +
> > +		ret = v4l2_async_test_notify(notifier, sd, asd);
> > +		if (ret)
> > +			goto err_unlock;
> > +
> > +		if (!list_empty(&notifier->waiting) || !notifier->complete)
> > +			goto out_unlock;
> > +
> > +		ret = notifier->complete(notifier);
> > +		if (ret)
> > +			goto err_cleanup;
> > +
> > +		goto out_unlock;
> >  	}
> >  
> >  	/* None matched, wait for hot-plugging */
> >  	list_add(&sd->async_list, &subdev_list);
> >  
> > +out_unlock:
> >  	mutex_unlock(&list_lock);
> >  
> >  	return 0;
> > +
> > +err_cleanup:
> > +	if (notifier->unbind)
> > +		notifier->unbind(notifier, sd, sd->asd);
> > +
> > +	v4l2_async_cleanup(sd);
> 
> I'm trying to understand this. Who will unbind all subdevs in this case?

The driver that registered them is responsible for that, as usual.

> 
> And in the general case: if complete returns an error, the bridge driver
> should be remove()d. Who will do that? Does that work at all?

The bridge driver can't do that alone, the bridge driver would need to be
unbound explicitly by the user.

This approach has the benefit that it's symmetric: on error we only tear
down the part that was added, no more. Doing otherwise would likely make
the error handling hard to understand and test properly. For instance, if a
driver's probe function calling v4l2_async_register_subdev() or
v4l2_async_notifier_register() fails, leading the driver binding to fail.
If the error is temporary for whatever reason, just retrying the operation
will help.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
