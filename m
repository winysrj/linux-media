Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35744 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdHRNmM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 09:42:12 -0400
Received: by mail-lf0-f48.google.com with SMTP id t128so42956969lff.2
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 06:42:11 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 18 Aug 2017 15:42:07 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH 1/4] v4l: async: fix unbind error in
 v4l2_async_notifier_unregister()
Message-ID: <20170818134207.GA8460@bigcity.dyn.berto.se>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
 <20170730223158.14405-2-niklas.soderlund+renesas@ragnatech.se>
 <20170815161604.5qjrd3eas4tlvrt6@valkosipuli.retiisi.org.uk>
 <2638355.RUWT87hFr5@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2638355.RUWT87hFr5@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 2017-08-18 14:15:26 +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday 15 Aug 2017 19:16:14 Sakari Ailus wrote:
> > On Mon, Jul 31, 2017 at 12:31:55AM +0200, Niklas Söderlund wrote:
> > > The call to v4l2_async_cleanup() will set sd->asd to NULL so passing it
> > > to notifier->unbind() have no effect and leaves the notifier confused.
> > > Call the unbind() callback prior to cleaning up the subdevice to avoid
> > > this.
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > 
> > This is a bugfix and worthy without any other patches and so should be
> > applied separately.
> > 
> > I think it'd be safer to store sd->asd locally and call the notifier unbind
> > with that. Now you're making changes to the order in which things work, and
> > that's not necessary to achieve the objective of passing the async subdev
> > pointer to the notifier.
> 
> But on the other hand I think the unbind notification should be called before 
> the subdevice gets unbound, the same way the bound notification is called 
> after it gets bound. One of the purposes of the unbind notification is to 
> allow drivers to prepare for subdev about to be unbound, and they can't 
> prepare if the unbind happened already.

I'm not opposed to move in the direction suggested by Sakari but I agree 
with Laurent here. It makes more sens that the unbind callback is called 
before the actual unbind happens. At the same time I agree that it dose 
change the behavior, but I think it's for the better.

> 
> > With that changed,
> > 
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > > ---
> > > 
> > >  drivers/media/v4l2-core/v4l2-async.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > > b/drivers/media/v4l2-core/v4l2-async.c index
> > > 851f128eba2219ad..0acf288d7227ba97 100644
> > > --- a/drivers/media/v4l2-core/v4l2-async.c
> > > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > > @@ -226,14 +226,14 @@ void v4l2_async_notifier_unregister(struct
> > > v4l2_async_notifier *notifier)> 
> > >  		d = get_device(sd->dev);
> > > 
> > > +		if (notifier->unbind)
> > > +			notifier->unbind(notifier, sd, sd->asd);
> > > +
> > > 
> > >  		v4l2_async_cleanup(sd);
> > >  		
> > >  		/* If we handled USB devices, we'd have to lock the parent too 
> */
> > >  		device_release_driver(d);
> > > 
> > > -		if (notifier->unbind)
> > > -			notifier->unbind(notifier, sd, sd->asd);
> > > -
> > > 
> > >  		/*
> > >  		
> > >  		 * Store device at the device cache, in order to call
> > >  		 * put_device() on the final step
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
