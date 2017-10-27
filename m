Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:45194 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdJ0IKG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 04:10:06 -0400
Received: by mail-lf0-f65.google.com with SMTP id n69so6472930lfn.2
        for <linux-media@vger.kernel.org>; Fri, 27 Oct 2017 01:10:05 -0700 (PDT)
Date: Fri, 27 Oct 2017 10:10:02 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 17/32] v4l: async: Prepare for async sub-device
 notifiers
Message-ID: <20171027081002.GL2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-18-sakari.ailus@linux.intel.com>
 <20171026221051.GK2297@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026221051.GK2297@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 2017-10-27 00:10:51 +0200, Niklas Söderlund wrote:
> On 2017-10-26 10:53:27 +0300, Sakari Ailus wrote:
> > Refactor the V4L2 async framework a little in preparation for async
> > sub-device notifiers. This avoids making some structural changes in the
> > patch actually implementing sub-device notifiers, making that patch easier
> > to review.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

I'm sorry I acted to soon, I think I found a small issue with this 
patch, see bellow. With that fixed feel free to attach my ack.

> 
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 71 ++++++++++++++++++++++++++----------
> >  1 file changed, 52 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 1b536d68cedf..eb31d96254d1 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -125,12 +125,13 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
> >  }
> >  
> >  static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> > +				   struct v4l2_device *v4l2_dev,
> >  				   struct v4l2_subdev *sd,
> >  				   struct v4l2_async_subdev *asd)
> >  {
> >  	int ret;
> >  
> > -	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> > +	ret = v4l2_device_register_subdev(v4l2_dev, sd);
> >  	if (ret < 0)
> >  		return ret;
> >  
> > @@ -151,6 +152,31 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> >  	return 0;
> >  }
> >  
> > +/* Test all async sub-devices in a notifier for a match. */
> > +static int v4l2_async_notifier_try_all_subdevs(
> > +	struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> > +	struct v4l2_subdev *sd, *tmp;
> > +
> > +	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > +		struct v4l2_async_subdev *asd;
> > +		int ret;
> > +
> > +		asd = v4l2_async_find_match(notifier, sd);
> > +		if (!asd)
> > +			continue;
> > +
> > +		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
> > +		if (ret < 0) {
> > +			mutex_unlock(&list_lock);

The mutex should not be unlocked here, as the caller will also unlock it 
if ret is none zero. You fix this in 18/32 so the end result is OK but I 
think its better to fix this in this patch.

> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> >  {
> >  	v4l2_device_unregister_subdev(sd);
> > @@ -172,18 +198,15 @@ static void v4l2_async_notifier_unbind_all_subdevs(
> >  	}
> >  }
> >  
> > -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > -				 struct v4l2_async_notifier *notifier)
> > +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> >  {
> > -	struct v4l2_subdev *sd, *tmp;
> >  	struct v4l2_async_subdev *asd;
> >  	int ret;
> >  	int i;
> >  
> > -	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > +	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> >  		return -EINVAL;
> >  
> > -	notifier->v4l2_dev = v4l2_dev;
> >  	INIT_LIST_HEAD(&notifier->waiting);
> >  	INIT_LIST_HEAD(&notifier->done);
> >  
> > @@ -216,18 +239,10 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  
> >  	mutex_lock(&list_lock);
> >  
> > -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > -		int ret;
> > -
> > -		asd = v4l2_async_find_match(notifier, sd);
> > -		if (!asd)
> > -			continue;
> > -
> > -		ret = v4l2_async_match_notify(notifier, sd, asd);
> > -		if (ret < 0) {
> > -			mutex_unlock(&list_lock);
> > -			return ret;
> > -		}
> > +	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> > +	if (ret) {
> > +		mutex_unlock(&list_lock);
> > +		return ret;
> >  	}
> >  
> >  	if (list_empty(&notifier->waiting)) {
> > @@ -250,6 +265,23 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  
> >  	return ret;
> >  }
> > +
> > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > +				 struct v4l2_async_notifier *notifier)
> > +{
> > +	int ret;
> > +
> > +	if (WARN_ON(!v4l2_dev))
> > +		return -EINVAL;
> > +
> > +	notifier->v4l2_dev = v4l2_dev;
> > +
> > +	ret = __v4l2_async_notifier_register(notifier);
> > +	if (ret)
> > +		notifier->v4l2_dev = NULL;
> > +
> > +	return ret;
> > +}
> >  EXPORT_SYMBOL(v4l2_async_notifier_register);
> >  
> >  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> > @@ -324,7 +356,8 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  		if (!asd)
> >  			continue;
> >  
> > -		ret = v4l2_async_match_notify(notifier, sd, asd);
> > +		ret = v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
> > +					      asd);
> >  		if (ret)
> >  			goto err_unlock;
> >  
> > -- 
> > 2.11.0
> > 
> 
> -- 
> Regards,
> Niklas Söderlund

-- 
Regards,
Niklas Söderlund
