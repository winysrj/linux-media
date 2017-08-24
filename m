Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53266 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753210AbdHXQRi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 12:17:38 -0400
Date: Thu, 24 Aug 2017 19:17:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH 4/4] v4l: async: add comment about re-probing to
 v4l2_async_notifier_unregister()
Message-ID: <20170824161735.3oa4qvdtzicjhgua@valkosipuli.retiisi.org.uk>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
 <20170730223158.14405-5-niklas.soderlund+renesas@ragnatech.se>
 <20170815160932.fizwqqkaivtz3nqu@valkosipuli.retiisi.org.uk>
 <2865661.SePdnx8dyz@avalon>
 <20170818134237.GB6304@bigcity.dyn.berto.se>
 <20170823190314.GB12099@bigcity.dyn.berto.se>
 <75ab2de0-156c-ac8a-b4db-58661e1f432c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75ab2de0-156c-ac8a-b4db-58661e1f432c@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Aug 24, 2017 at 09:59:41AM +0200, Hans Verkuil wrote:
> On 08/23/17 21:03, Niklas Söderlund wrote:
> > Hi,
> > 
> > On 2017-08-18 15:42:37 +0200, Niklas Söderlund wrote:
> >> Hi Sakari and Laurent,
> >>
> >> Thanks for your feedback.
> >>
> >> On 2017-08-18 14:20:08 +0300, Laurent Pinchart wrote:
> >>> Hello,
> >>>
> >>> On Tuesday 15 Aug 2017 19:09:33 Sakari Ailus wrote:
> >>>> On Mon, Jul 31, 2017 at 12:31:58AM +0200, Niklas Söderlund wrote:
> >>>>> The re-probing of subdevices when unregistering a notifier is tricky to
> >>>>> understand, and implemented somewhat as a hack. Add a comment trying to
> >>>>> explain why the re-probing is needed in the first place and why existing
> >>>>> helper functions can't be used in this situation.
> >>>>>
> >>>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >>>>> ---
> >>>>>
> >>>>>  drivers/media/v4l2-core/v4l2-async.c | 17 +++++++++++++++++
> >>>>>  1 file changed, 17 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> >>>>> b/drivers/media/v4l2-core/v4l2-async.c index
> >>>>> d91ff0a33fd3eaff..a3c5a1f6d4d2ab03 100644
> >>>>> --- a/drivers/media/v4l2-core/v4l2-async.c
> >>>>> +++ b/drivers/media/v4l2-core/v4l2-async.c
> >>>>> @@ -234,6 +234,23 @@ void v4l2_async_notifier_unregister(struct
> >>>>> v4l2_async_notifier *notifier)> 
> >>>>>  	mutex_unlock(&list_lock);
> >>>>>
> >>>>> +	/*
> >>>>> +	 * Try to re-probe the subdevices which where part of the notifier.
> >>>>> +	 * This is done so subdevices which where part of the notifier will
> >>>>> +	 * be re-probed to a pristine state and put back on the global
> >>>>> +	 * list of subdevices so they can once more be found and associated
> >>>>> +	 * with a new notifier.
> >>>>
> >>>> Instead of tweaking the code trying to handle unhandleable error conditions
> >>>> in notifier unregistration and adding lengthy stories on why this is done
> >>>> the way it is, could we simply get rid of the driver re-probing?
> >>>>
> >>>> I can't see why drivers shouldn't simply cope with the current interfaces
> >>>> without re-probing to which I've never seen any reasoned cause. When a
> >>>> sub-device driver is unbound, simply return the sub-device node to the list
> >>>> of async sub-devices.
> >>>
> >>> I agree, this is a hack that we should get rid of. Reprobing has been there 
> >>> from the very beginning, it's now 4 years and a half old, let's allow it to 
> >>> retire :-)
> >>
> >> I would also be happy to see this code go away :-)
> >>
> >>>
> >>>> Or can someone come up with a valid reason why the re-probing code should
> >>>> stay? :-)
> >>
> >> Hans kindly dug out the original reason talking about why this code was 
> >> added in the first place at
> >>
> >>     http://lkml.iu.edu/hypermail/linux/kernel/1210.2/00713.html
> >>
> >> I would also like record here what Laurent stated about this after 
> >> reading the above on #v4l 
> >>
> >> 13:53  pinchartl : what could happen is this
> >> 13:53  pinchartl : the master could export resources used by the subdev
> >> 13:53  pinchartl : the omap3 isp driver, for instance, is a clock source
> >> 13:54  pinchartl : and the clock can be used by sensors
> >> 13:54  pinchartl : so if you remove the omap3 isp, the clock won't be 
> >>    there anymore
> >> 13:54  pinchartl : and that's bad for the subdev

Re-probing never helped anything with omap3isp driver as the clock is
removed *after* unregistering async notifier. This means that the
re-probing sub-device driver will get the same clock which is about to be
removed and continues with that happily, only to find the clock gone in a
brief moment.

This could be fixed in the omap3isp driver but it is telling that _no-one
ever complained_.

> >>
> >>
> >> I don't claim I fully understand all the consequences of removing this 
> >> reprobing now. But maybe it's safer to lave the current behavior in for 
> >> now until the full problem is understood and move forward whit these 
> >> patches since at least they document the behavior and removes another 
> >> funky bit when trying to handle the situation where the memory 
> >> allocation fails? What do you guys think?
> > 
> > Any thoughts about how I can move forward with this? The reason I'm 
> > asking is that this is a dependency for the sub-notifier patches which 
> > in turn is dependency for the R-Car CSI-2 driver :-) If someone wants to 
> > think more about this that is fine I just don't want it to be forgotten.  
> > As I see it these are the options open to me, but as always I'm always 
> > open to other solutions which I'm to narrow minded to see :-)
> > 
> > - If after the latest discussions it feels the safest option is to keep 
> >   the re-probe logic but separating the v4l2 housekeeping from re-probe 
> >   logic move forward with this series as-is.
> 
> I prefer this. We can always remove the reprobe code later once we have
> a better understanding. I see no downside to this cleanup series and it
> doesn't block any future development.

One thing we could do is to remove the memory allocation there. After that
it couldn't fail anymore, leaving the device in an unknown state.

> 
> > - Post 1/4 separately and repost patch 2/4 -- 4/4 in a v2 to allow for 
> >   more input on what is the right thing to do here.
> 
> I'm OK with this as well, we missed the 4.14 merge window anyway.

Agreed.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
