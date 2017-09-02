Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47004 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdIBJm7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 05:42:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v6.1 4/5] v4l: fwnode: Support generic parsing of graph endpoints in a device
Date: Sat, 02 Sep 2017 12:42:57 +0300
Message-ID: <1974101.An4ZKHrJMZ@avalon>
In-Reply-To: <b707062c-d8df-5fb5-8099-8460f0dd7d5d@xs4all.nl>
References: <20170830114946.17743-5-sakari.ailus@linux.intel.com> <20170830124530.26176-1-sakari.ailus@linux.intel.com> <b707062c-d8df-5fb5-8099-8460f0dd7d5d@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday, 1 September 2017 14:18:55 EEST Hans Verkuil wrote:
> On 30/08/17 14:45, Sakari Ailus wrote:
> > The current practice is that drivers iterate over their endpoints and
> > parse each endpoint separately. This is very similar in a number of
> > drivers, implement a generic function for the job. Driver specific matters
> > can be taken into account in the driver specific callback.
> > 
> > Convert the omap3isp as an example.
> 
> It would be much easier to review if the omap3isp conversion was done in a
> separate patch. Ditto for the rcar conversion, and I prefer to have both
> at the end of the patch series, after the core code patches.
> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > since v6:
> > 
> > - Set notifier->subdevs NULL and notifier->num_subdevs 0 in
> > 
> >   v4l2_async_notifier_release().
> >  
> >  drivers/media/platform/omap3isp/isp.c | 115 ++++++++++-------------------
> >  drivers/media/platform/omap3isp/isp.h |   5 +-
> >  drivers/media/v4l2-core/v4l2-async.c  |  16 +++++
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 131 +++++++++++++++++++++++++++++
> >  include/media/v4l2-async.h            |  24 ++++++-
> >  include/media/v4l2-fwnode.h           |  48 +++++++++++++
> >  6 files changed, 254 insertions(+), 85 deletions(-)

[snip]

> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index c69d8c8a66d0..cf13c7311a1c 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -18,7 +18,6 @@ struct device;
> >  struct device_node;
> >  struct v4l2_device;
> >  struct v4l2_subdev;
> > -struct v4l2_async_notifier;
> > 
> >  /* A random max subdevice number, used to allocate an array on stack */
> >  #define V4L2_MAX_SUBDEVS 128U
> > @@ -50,6 +49,10 @@ enum v4l2_async_match_type {
> >   * @match:	union of per-bus type matching data sets
> >   * @list:	used to link struct v4l2_async_subdev objects, waiting to be
> >   *		probed, to a notifier->waiting list
> > + *
> > + * When the struct is used as the first member of a driver specific
> 
> Just replace "the first member" by "part"...

I'd say "When the structure is embedded in a driver-specific structure, ...".

> > + * struct, the driver specific struct shall contain the @struct
> > + * v4l2_async_subdev as its first member.
> 
> ...since you mention in the second part that it has to be the first member.
> No need to mention that twice.
> 
> >   */

[snip]

> >  /**
> > + * v4l2_async_notifier_release - release notifier resources
> > + * @notifier: the notifier the resources of which are to be released
> 
> Just say: @notifier: pointer to &struct v4l2_async_notifier

I asked Sakari to be more explicit. Documenting an argument as "pointer to 
struct foo" is quite pointless, C is a typed language so it's evident from the 
function declaration. What pointer to pass to the function is a much more 
useful piece of information. This specific case is pretty trivial anyway, but 
in other cases, such as the dev pointer passed to the parse function, we need 
more than just documenting the variable type.

> > + *
> > + * Release memory resources related to a notifier, including the async
> 
> s/a/the/
> 
> > + * sub-devices allocated for the purposes of the notifier. The user is
> > + * responsible for releasing the notifier's resources after calling
> > + * @v4l2_async_notifier_parse_fwnode_endpoints.
> > + *
> > + * There is no harm from calling v4l2_async_notifier_release in other
> > + * cases as long as its memory has been zeroed after it has been
> > + * allocated.
> > + */
> > +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier);

[snip]

-- 
Regards,

Laurent Pinchart
