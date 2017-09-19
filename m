Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39324 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdISQ1T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 12:27:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 11/25] v4l: async: Introduce helpers for calling async ops callbacks
Date: Tue, 19 Sep 2017 19:27:17 +0300
Message-ID: <7185208.IfnHDmqMaa@avalon>
In-Reply-To: <20170919145049.uivohp6qvkf7x4fc@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <2693952.YdpSRMO0xE@avalon> <20170919145049.uivohp6qvkf7x4fc@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 17:50:49 EEST Sakari Ailus wrote:
> On Tue, Sep 19, 2017 at 03:43:48PM +0300, Laurent Pinchart wrote:
> > On Tuesday, 19 September 2017 15:13:11 EEST Sakari Ailus wrote:
> >> On Tue, Sep 19, 2017 at 03:01:14PM +0300, Laurent Pinchart wrote:
> >>> On Friday, 15 September 2017 17:17:10 EEST Sakari Ailus wrote:
> >>>> Add three helper functions to call async operations callbacks.
> >>>> Besides simplifying callbacks, this allows async notifiers to have no
> >>>> ops set, i.e. it can be left NULL.
> >>>> 
> >>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> ---
> >>>> 
> >>>>  drivers/media/v4l2-core/v4l2-async.c | 49 ++++++++++++++++++--------
> >>>>  include/media/v4l2-async.h           |  1 +
> >>>>  2 files changed, 37 insertions(+), 13 deletions(-)
> >>>> 
> >>>> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> >>>> b/drivers/media/v4l2-core/v4l2-async.c index
> >>>> 7b2125b3d62f..c35d04b9122f
> >>>> 100644
> >>>> --- a/drivers/media/v4l2-core/v4l2-async.c
> >>>> +++ b/drivers/media/v4l2-core/v4l2-async.c
> >>>> @@ -25,6 +25,34 @@
> >>>> 
> >>>>  #include <media/v4l2-fwnode.h>
> >>>>  #include <media/v4l2-subdev.h>
> >>>> 
> >>>> +static int v4l2_async_notifier_call_bound(struct v4l2_async_notifier
> >>>> *n,
> >>>> +					  struct v4l2_subdev *subdev,
> >>>> +					  struct v4l2_async_subdev *asd)
> >>>> +{
> >>>> +	if (!n->ops || !n->ops->bound)
> >>>> +		return 0;
> >>>> +
> >>>> +	return n->ops->bound(n, subdev, asd);
> >>>> +}
> >>>> +
> >>>> +static void v4l2_async_notifier_call_unbind(struct
> >>>> v4l2_async_notifier
> >>>> *n,
> >>>> +					    struct v4l2_subdev *subdev,
> >>>> +					    struct v4l2_async_subdev *asd)
> >>>> +{
> >>>> +	if (!n->ops || !n->ops->unbind)
> >>>> +		return;
> >>>> +
> >>>> +	n->ops->unbind(n, subdev, asd);
> >>>> +}
> >>>> +
> >>>> +static int v4l2_async_notifier_call_complete(struct
> >>>> v4l2_async_notifier
> >>>> *n)
> >>>> +{
> >>>> +	if (!n->ops || !n->ops->complete)
> >>>> +		return 0;
> >>>> +
> >>>> +	return n->ops->complete(n);
> >>>> +}
> >>>> +
> >>> 
> >>> Wouldn't it be enough to add a single v4l2_async_notifier_call() macro
> >>> ?
> >>> 
> >>> #define v4l2_async_notifier_call(n, op, args...) \
> >>> 
> >>> 	((n)->ops && (n)->ops->op ? (n)->ops->op(n, ##args) : 0)
> >> 
> >> I actually had that in an earlier version but I changed it based on
> >> review comments from Hans. A single macro isn't enough: some functions
> >> have int return type. I think the way it is now is nicer.
> > 
> > What bothers me there is the overhead of a function call.
> 
> Overhead... of a function call?
> 
> Do you really mean what you're saying? :-) The functions will be called a
> relatively small number of times during module loading / device probing.

That's why I haven't said it's a big deal :-) There's of course no need to 
optimize that if the tradeoff is large, but if all operations had the same 
return type a macro could have been useful (although in this very specific 
case I'm more concerned about code size than about CPU cycles).

> > By the way, what's the use case for ops being NULL ?
> 
> If a driver has no need for any of the callbacks, there's no benefit from
> having to set ops struct either. This applies to devices that are
> associated to the sensor, for instance.

So in that case the subdev notifier is only registered to delay the complete() 
callback until the flash and lens controllers are available, with the sensor 
itself having no need to access the flash and lens controllers ?

-- 
Regards,

Laurent Pinchart
