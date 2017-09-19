Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38325 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdISMv6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:51:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 13/25] v4l: async: Allow async notifier register call succeed with no subdevs
Date: Tue, 19 Sep 2017 15:52:02 +0300
Message-ID: <2068881.oMWDSm4mNc@avalon>
In-Reply-To: <1674305.pu9Ti8eC3U@avalon>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <20170915141724.23124-14-sakari.ailus@linux.intel.com> <1674305.pu9Ti8eC3U@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 15:04:43 EEST Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 17:17:12 EEST Sakari Ailus wrote:
> > The information on how many async sub-devices would be bindable to a
> > notifier is typically dependent on information from platform firmware and
> > it's not driver's business to be aware of that.
> > 
> > Many V4L2 main drivers are perfectly usable (and useful) without async
> > sub-devices and so if there aren't any around, just proceed call the
> > notifier's complete callback immediately without registering the notifier
> > itself.
> > 
> > If a driver needs to check whether there are async sub-devices available,
> > it can be done by inspecting the notifier's num_subdevs field which tells
> > the number of async sub-devices.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I take this back.

> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-async.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index 9895b610e2a0..4be2f16af051
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -170,14 +170,16 @@ int v4l2_async_notifier_register(struct v4l2_device
> > *v4l2_dev, struct v4l2_async_subdev *asd;
> > 
> >  	int i;
> > 
> > -	if (!v4l2_dev || !notifier->num_subdevs ||
> > -	    notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > +	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> > 
> >  		return -EINVAL;
> >  	
> >  	notifier->v4l2_dev = v4l2_dev;
> >  	INIT_LIST_HEAD(&notifier->waiting);
> >  	INIT_LIST_HEAD(&notifier->done);
> > 
> > +	if (!notifier->num_subdevs)
> > +		return v4l2_async_notifier_call_complete(notifier);
> > +

This skips adding the notifier to the notifier_list. Won't this result in an 
oops when calling list_del(&notifier->list) in 
v4l2_async_notifier_unregister() ?

> >  	for (i = 0; i < notifier->num_subdevs; i++) {
> >  	
> >  		asd = notifier->subdevs[i];

-- 
Regards,

Laurent Pinchart
