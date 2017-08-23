Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36418 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932498AbdHWTDU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 15:03:20 -0400
Received: by mail-lf0-f49.google.com with SMTP id l137so4441263lfg.3
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 12:03:20 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 23 Aug 2017 21:03:14 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH 4/4] v4l: async: add comment about re-probing to
 v4l2_async_notifier_unregister()
Message-ID: <20170823190314.GB12099@bigcity.dyn.berto.se>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
 <20170730223158.14405-5-niklas.soderlund+renesas@ragnatech.se>
 <20170815160932.fizwqqkaivtz3nqu@valkosipuli.retiisi.org.uk>
 <2865661.SePdnx8dyz@avalon>
 <20170818134237.GB6304@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170818134237.GB6304@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 2017-08-18 15:42:37 +0200, Niklas Söderlund wrote:
> Hi Sakari and Laurent,
> 
> Thanks for your feedback.
> 
> On 2017-08-18 14:20:08 +0300, Laurent Pinchart wrote:
> > Hello,
> > 
> > On Tuesday 15 Aug 2017 19:09:33 Sakari Ailus wrote:
> > > On Mon, Jul 31, 2017 at 12:31:58AM +0200, Niklas Söderlund wrote:
> > > > The re-probing of subdevices when unregistering a notifier is tricky to
> > > > understand, and implemented somewhat as a hack. Add a comment trying to
> > > > explain why the re-probing is needed in the first place and why existing
> > > > helper functions can't be used in this situation.
> > > > 
> > > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > > ---
> > > > 
> > > >  drivers/media/v4l2-core/v4l2-async.c | 17 +++++++++++++++++
> > > >  1 file changed, 17 insertions(+)
> > > > 
> > > > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > > > b/drivers/media/v4l2-core/v4l2-async.c index
> > > > d91ff0a33fd3eaff..a3c5a1f6d4d2ab03 100644
> > > > --- a/drivers/media/v4l2-core/v4l2-async.c
> > > > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > > > @@ -234,6 +234,23 @@ void v4l2_async_notifier_unregister(struct
> > > > v4l2_async_notifier *notifier)> 
> > > >  	mutex_unlock(&list_lock);
> > > > 
> > > > +	/*
> > > > +	 * Try to re-probe the subdevices which where part of the notifier.
> > > > +	 * This is done so subdevices which where part of the notifier will
> > > > +	 * be re-probed to a pristine state and put back on the global
> > > > +	 * list of subdevices so they can once more be found and associated
> > > > +	 * with a new notifier.
> > > 
> > > Instead of tweaking the code trying to handle unhandleable error conditions
> > > in notifier unregistration and adding lengthy stories on why this is done
> > > the way it is, could we simply get rid of the driver re-probing?
> > > 
> > > I can't see why drivers shouldn't simply cope with the current interfaces
> > > without re-probing to which I've never seen any reasoned cause. When a
> > > sub-device driver is unbound, simply return the sub-device node to the list
> > > of async sub-devices.
> > 
> > I agree, this is a hack that we should get rid of. Reprobing has been there 
> > from the very beginning, it's now 4 years and a half old, let's allow it to 
> > retire :-)
> 
> I would also be happy to see this code go away :-)
> 
> > 
> > > Or can someone come up with a valid reason why the re-probing code should
> > > stay? :-)
> 
> Hans kindly dug out the original reason talking about why this code was 
> added in the first place at
> 
>     http://lkml.iu.edu/hypermail/linux/kernel/1210.2/00713.html
> 
> I would also like record here what Laurent stated about this after 
> reading the above on #v4l 
> 
> 13:53  pinchartl : what could happen is this
> 13:53  pinchartl : the master could export resources used by the subdev
> 13:53  pinchartl : the omap3 isp driver, for instance, is a clock source
> 13:54  pinchartl : and the clock can be used by sensors
> 13:54  pinchartl : so if you remove the omap3 isp, the clock won't be 
>    there anymore
> 13:54  pinchartl : and that's bad for the subdev
> 
> 
> I don't claim I fully understand all the consequences of removing this 
> reprobing now. But maybe it's safer to lave the current behavior in for 
> now until the full problem is understood and move forward whit these 
> patches since at least they document the behavior and removes another 
> funky bit when trying to handle the situation where the memory 
> allocation fails? What do you guys think?

Any thoughts about how I can move forward with this? The reason I'm 
asking is that this is a dependency for the sub-notifier patches which 
in turn is dependency for the R-Car CSI-2 driver :-) If someone wants to 
think more about this that is fine I just don't want it to be forgotten.  
As I see it these are the options open to me, but as always I'm always 
open to other solutions which I'm to narrow minded to see :-)

- If after the latest discussions it feels the safest option is to keep 
  the re-probe logic but separating the v4l2 housekeeping from re-probe 
  logic move forward with this series as-is.

- Post 1/4 separately and repost patch 2/4 -- 4/4 in a v2 to allow for 
  more input on what is the right thing to do here.

- Post 1/4 separately, drop patch 2/4 -- 4/4 and create a new patch 
  which removes all re-probe related code and post that as a new patch.  
  I would feel a but uneasy about this without a consensus from all you 
  guys since I don't understand all the ramifications in doing so.

- Post 1/4 separately, drop patch 2/4 -- 4/4 and try to rework the 
  sub-notifier code to work the intertwined v4l2 and re-probe portions 
  of the code.

> 
> > > 
> > > > +	 *
> > > > +	 * One might be tempted to use device_reprobe() to handle the re-
> > > > +	 * probing. Unfortunately this is not possible since some video
> > > > +	 * device drivers call v4l2_async_notifier_unregister() from
> > > > +	 * there remove function leading to a dead lock situation on
> > > > +	 * device_lock(dev->parent). This lock is held when video device
> > > > +	 * drivers remove function is called and device_reprobe() also
> > > > +	 * tries to take the same lock, so using it here could lead to a
> > > > +	 * dead lock situation.
> > > > +	 */
> > > > +
> > > >  	for (i = 0; i < count; i++) {
> > > >  	
> > > >  		/* If we handled USB devices, we'd have to lock the parent too 
> > */
> > > >  		device_release_driver(dev[i]);
> > 
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> 
> -- 
> Regards,
> Niklas Söderlund

-- 
Regards,
Niklas Söderlund
