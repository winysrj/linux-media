Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:4333 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751476AbdISMNP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:13:15 -0400
Date: Tue, 19 Sep 2017 15:13:11 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 11/25] v4l: async: Introduce helpers for calling
 async ops callbacks
Message-ID: <20170919121311.n2fvoo7tebywsc5d@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-12-sakari.ailus@linux.intel.com>
 <1751597.tWjkEME5YS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1751597.tWjkEME5YS@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 03:01:14PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 17:17:10 EEST Sakari Ailus wrote:
> > Add three helper functions to call async operations callbacks. Besides
> > simplifying callbacks, this allows async notifiers to have no ops set,
> > i.e. it can be left NULL.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 49 ++++++++++++++++++++++++--------
> >  include/media/v4l2-async.h           |  1 +
> >  2 files changed, 37 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index 7b2125b3d62f..c35d04b9122f
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -25,6 +25,34 @@
> >  #include <media/v4l2-fwnode.h>
> >  #include <media/v4l2-subdev.h>
> > 
> > +static int v4l2_async_notifier_call_bound(struct v4l2_async_notifier *n,
> > +					  struct v4l2_subdev *subdev,
> > +					  struct v4l2_async_subdev *asd)
> > +{
> > +	if (!n->ops || !n->ops->bound)
> > +		return 0;
> > +
> > +	return n->ops->bound(n, subdev, asd);
> > +}
> > +
> > +static void v4l2_async_notifier_call_unbind(struct v4l2_async_notifier *n,
> > +					    struct v4l2_subdev *subdev,
> > +					    struct v4l2_async_subdev *asd)
> > +{
> > +	if (!n->ops || !n->ops->unbind)
> > +		return;
> > +
> > +	n->ops->unbind(n, subdev, asd);
> > +}
> > +
> > +static int v4l2_async_notifier_call_complete(struct v4l2_async_notifier *n)
> > +{
> > +	if (!n->ops || !n->ops->complete)
> > +		return 0;
> > +
> > +	return n->ops->complete(n);
> > +}
> > +
> 
> Wouldn't it be enough to add a single v4l2_async_notifier_call() macro ?
> 
> #define v4l2_async_notifier_call(n, op, args...) \
> 	((n)->ops && (n)->ops->op ? (n)->ops->op(n, ##args) : 0)

I actually had that in an earlier version but I changed it based on review
comments from Hans. A single macro isn't enough: some functions have int
return type. I think the way it is now is nicer.

> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> >  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev
> > *asd) {
> >  #if IS_ENABLED(CONFIG_I2C)
> > @@ -102,16 +130,13 @@ static int v4l2_async_match_notify(struct
> > v4l2_async_notifier *notifier, {
> >  	int ret;
> > 
> > -	if (notifier->ops->bound) {
> > -		ret = notifier->ops->bound(notifier, sd, asd);
> > -		if (ret < 0)
> > -			return ret;
> > -	}
> > +	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
> > +	if (ret < 0)
> > +		return ret;
> > 
> >  	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> >  	if (ret < 0) {
> > -		if (notifier->ops->unbind)
> > -			notifier->ops->unbind(notifier, sd, asd);
> > +		v4l2_async_notifier_call_unbind(notifier, sd, asd);
> >  		return ret;
> >  	}
> > 
> > @@ -123,8 +148,8 @@ static int v4l2_async_match_notify(struct
> > v4l2_async_notifier *notifier, /* Move from the global subdevice list to
> > notifier's done */
> >  	list_move(&sd->async_list, &notifier->done);
> > 
> > -	if (list_empty(&notifier->waiting) && notifier->ops->complete)
> > -		return notifier->ops->complete(notifier);
> > +	if (list_empty(&notifier->waiting))
> > +		return v4l2_async_notifier_call_complete(notifier);
> > 
> >  	return 0;
> >  }
> > @@ -210,8 +235,7 @@ void v4l2_async_notifier_unregister(struct
> > v4l2_async_notifier *notifier) list_for_each_entry_safe(sd, tmp,
> > &notifier->done, async_list) { v4l2_async_cleanup(sd);
> > 
> > -		if (notifier->ops->unbind)
> > -			notifier->ops->unbind(notifier, sd, sd->asd);
> > +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> >  	}
> > 
> >  	mutex_unlock(&list_lock);
> > @@ -300,8 +324,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev
> > *sd)
> > 
> >  	v4l2_async_cleanup(sd);
> > 
> > -	if (notifier->ops->unbind)
> > -		notifier->ops->unbind(notifier, sd, sd->asd);
> > +	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> > 
> >  	mutex_unlock(&list_lock);
> >  }
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index 3c48f8b66d12..3bc8a7c0d83f 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -164,4 +164,5 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd);
> >   * @sd: pointer to &struct v4l2_subdev
> >   */
> >  void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
> > +
> >  #endif
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
