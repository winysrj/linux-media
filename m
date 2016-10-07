Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50380 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935076AbcJGQxX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:53:23 -0400
Message-ID: <1475859201.2452.19.camel@pengutronix.de>
Subject: Re: [PATCH 01/22] [media] v4l2-async: move code out of
 v4l2_async_notifier_register into v4l2_async_test_nofity_all
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Marek Vasut <marex@denx.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
Date: Fri, 07 Oct 2016 18:53:21 +0200
In-Reply-To: <9edf9ac6-8f8d-f421-5d88-604cfeaaff64@denx.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-2-p.zabel@pengutronix.de>
         <9edf9ac6-8f8d-f421-5d88-604cfeaaff64@denx.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 07.10.2016, 18:30 +0200 schrieb Marek Vasut:
> On 10/07/2016 06:00 PM, Philipp Zabel wrote:
> > This will be reused in the following patch to catch already registered,
> > newly added asynchronous subdevices from v4l2_async_register_subdev.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 38 +++++++++++++++++++++---------------
> >  1 file changed, 22 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 5bada20..c4f1930 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -134,11 +134,31 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> >  	sd->dev = NULL;
> >  }
> >  
> > +static int v4l2_async_test_notify_all(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_subdev *sd, *tmp;
> > +
> > +	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > +		struct v4l2_async_subdev *asd;
> > +		int ret;
> > +
> > +		asd = v4l2_async_belongs(notifier, sd);
> > +		if (!asd)
> > +			continue;
> > +
> > +		ret = v4l2_async_test_notify(notifier, sd, asd);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  				 struct v4l2_async_notifier *notifier)
> >  {
> > -	struct v4l2_subdev *sd, *tmp;
> >  	struct v4l2_async_subdev *asd;
> > +	int ret;
> >  	int i;
> >  
> >  	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > @@ -171,23 +191,9 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  	/* Keep also completed notifiers on the list */
> >  	list_add(&notifier->list, &notifier_list);
> >  
> > -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> > -		int ret;
> > -
> > -		asd = v4l2_async_belongs(notifier, sd);
> > -		if (!asd)
> > -			continue;
> > -
> > -		ret = v4l2_async_test_notify(notifier, sd, asd);
> > -		if (ret < 0) {
> > -			mutex_unlock(&list_lock);
> > -			return ret;
> > -		}
> > -	}
> 
> Shouldn't you call ret = v4l2_async_test_notify_all() here now instead ?

Absolutely, thanks. I've lost this in a rebase and the problem got
hidden by patch 2 replacing it again.

regards
Philipp

