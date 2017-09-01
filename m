Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41588 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbdIAIzJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 04:55:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 4/5] v4l: fwnode: Support generic parsing of graph endpoints in a device
Date: Fri, 01 Sep 2017 11:55:43 +0300
Message-ID: <4764194.MvKE5XMHvq@avalon>
In-Reply-To: <20170829143121.6sjdx3lgcoxm6mva@valkosipuli.retiisi.org.uk>
References: <20170829110313.19538-1-sakari.ailus@linux.intel.com> <2739432.dQ1BSg1MPy@avalon> <20170829143121.6sjdx3lgcoxm6mva@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 29 August 2017 17:31:21 EEST Sakari Ailus wrote:
> On Tue, Aug 29, 2017 at 05:02:54PM +0300, Laurent Pinchart wrote:
> > On Tuesday, 29 August 2017 14:03:12 EEST Sakari Ailus wrote:
> >> The current practice is that drivers iterate over their endpoints and
> >> parse each endpoint separately. This is very similar in a number of
> >> drivers, implement a generic function for the job. Driver specific
> >> matters can be taken into account in the driver specific callback.
> >> 
> >> Convert the omap3isp as an example.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> 
> >>  drivers/media/platform/omap3isp/isp.c | 115 ++++++++++-----------------
> >>  drivers/media/platform/omap3isp/isp.h |   5 +-
> >>  drivers/media/v4l2-core/v4l2-async.c  |  16 +++++
> >>  drivers/media/v4l2-core/v4l2-fwnode.c | 132 ++++++++++++++++++++++++++++
> >>  include/media/v4l2-async.h            | > 20 +++++-
> >>  include/media/v4l2-fwnode.h           |  39 ++++++++++
> >>  6 files changed, 242 insertions(+), 85 deletions(-)

[snip]

> >> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> >> b/drivers/media/v4l2-core/v4l2-fwnode.c index 706f9e7b90f1..39a587c6992a
> >> 100644
> >> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> >> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c

[snip]

> >> +static int parse_endpoint(
> >> +	struct device *dev, struct v4l2_async_notifier *notifier,
> >> +	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
> >> +	int (*parse_single)(struct device *dev,
> >> +			    struct v4l2_fwnode_endpoint *vep,
> >> +			    struct v4l2_async_subdev *asd))
> >> +{
> >> +	struct v4l2_async_subdev *asd;
> >> +	struct v4l2_fwnode_endpoint *vep;
> >> +	int ret = 0;
> >> +
> >> +	asd = kzalloc(asd_struct_size, GFP_KERNEL);
> >> +	if (!asd)
> >> +		return -ENOMEM;
> >> +
> >> +	asd->match.fwnode.fwnode =
> >> +		fwnode_graph_get_remote_port_parent(endpoint);
> >> +	if (!asd->match.fwnode.fwnode) {
> >> +		dev_warn(dev, "bad remote port parent\n");
> >> +		ret = -EINVAL;
> >> +		goto out_err;
> >> +	}
> >> +
> >> +	/* Ignore endpoints the parsing of which failed. */
> > 
> > You don't ignore them anymore, the comment should be updated.
> 
> Hmm. I actually intended to do something else about this. :-) As there's a
> single error code, handling that would need to be done a little bit
> differently right now.
> 
> I'd print a warning and proceed. What do you think?
> 
> Even if there's a bad DT endpoint, that shouldn't prevent the rest from
> working, right?

I think it should, to make sure we catch DT issues. We both know how many 
vendors don't care about warnings, so I'd rather fail completely to ensure DT 
will be fixed (and even ten I wouldn't be surprised if some vendors patched 
the code to remove the check instead of fixing their DT ;-)).

> >> +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> >> +	if (IS_ERR(vep)) {
> >> +		ret = PTR_ERR(vep);
> >> +		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
> >> +			 ret);
> >> +		goto out_err;
> >> +	}
> >> +
> >> +	ret = parse_single(dev, vep, asd);
> >> +	v4l2_fwnode_endpoint_free(vep);
> >> +	if (ret) {
> >> +		dev_warn(dev, "driver could not parse endpoint (%d)\n", ret);
> >> +		goto out_err;
> >> +	}
> >> +
> >> +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> >> +	notifier->subdevs[notifier->num_subdevs] = asd;
> >> +	notifier->num_subdevs++;
> >> +
> >> +	return 0;
> >> +
> >> +out_err:
> >> +	fwnode_handle_put(asd->match.fwnode.fwnode);
> >> +	kfree(asd);
> >> +
> >> +	return ret;
> >> +}

[snip]

> >> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> >> index c69d8c8a66d0..4a44ab47ab04 100644
> >> --- a/include/media/v4l2-async.h
> >> +++ b/include/media/v4l2-async.h


> >> @@ -121,6 +122,21 @@ int v4l2_async_notifier_register(struct v4l2_device
> >> *v4l2_dev, void v4l2_async_notifier_unregister(struct
> >> v4l2_async_notifier *notifier);
> >> 
> >>  /**
> >> + * v4l2_async_notifier_release - release notifier resources
> >> + * @notifier: pointer to &struct v4l2_async_notifier
> > 
> > That's quite obvious given the type of the argument. It would be much more
> > useful to tell which notifier pointer this function expects (although in
> > this case it should be obvious too): "(pointer to )?the notifier whose
> > resources will be released".
> 
> This fully matches to the documentation elsewhere in the same file. :-)

Feel free to fix the rest of the file :-)

> I'll replace the text with yours.
> 
> >> + *
> >> + * Release memory resources related to a notifier, including the async
> >> + * sub-devices allocated for the purposes of the notifier. The user is
> >> + * responsible for releasing the notifier's resources after calling
> >> + * @v4l2_async_notifier_parse_fwnode_endpoints.
> >> + *
> >> + * There is no harm from calling v4l2_async_notifier_release in other
> >> + * cases as long as its memory has been zeroed after it has been
> >> + * allocated.
> > 
> > Zeroing the memory is pretty much a requirement, as
> > v4l2_async_notifier_parse_fwnode_endpoints() won't operate correctly if
> > memory contains random data anyway. Maybe we should introduce
> > v4l2_async_notifier_init() and make v4l2_async_notifier_release()
> > mandatory, but that's out of scope for this patch.
> 
> Notifiers are typically allocated as part of a driver specific struct which
> is zeroed by the driver.
> 
> Registering the notifier won't work either if the rest of the struct wasn't
> zeroed.
> 
> >> + */
> >> +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier);
> >> +
> >> +/**
> >>   * v4l2_async_register_subdev - registers a sub-device to the
> >>   asynchronous
> >>   * 	subdevice framework
> >>   *
> >> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> >> index 68eb22ba571b..46521e8c8872 100644
> >> --- a/include/media/v4l2-fwnode.h
> >> +++ b/include/media/v4l2-fwnode.h

[snip]

> >> @@ -201,4 +203,41 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> >> *fwnode,
> >>  */
> >>  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> >> 
> >> +/**
> >> + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode
> >> endpoints in a
> >> + *						device node
> >> + * @dev: @struct device pointer
> > 
> > Similarly to my previous comment (and my comments to v3), you should tell
> > which device the function expects.
> 
> Will fix for the next version.
> 
> >> + * @notifier: pointer to &struct v4l2_async_notifier
> >> + * @asd_struct_size: size of the driver's async sub-device struct,
> >> including
> >> + *		     sizeof(struct v4l2_async_subdev). The &struct
> >> + *		     v4l2_async_subdev shall be the first member of
> >> + *		     the driver's async sub-device struct, i.e. both
> >> + *		     begin at the same memory address.
> > 
> > Should this be documented in the kerneldoc of the v4l2_async_subdev
> > structure ?
> 
> Yes, I'll add that. It won't hurt to make it a requirement even if the
> helper functions weren't used.
> 
> >> + * @parse_single: driver's callback function called on each V4L2 fwnode
> >> endpoint
> >> + *
> >> + * Allocate async sub-device array and sub-devices for each fwnode
> >> endpoint,
> >> + * parse the related fwnode endpoints and finally call driver's
> >> callback
> >> + * function to that V4L2 fwnode endpoint.
> > 
> > I'd document this from the notifier point of view.
> > 
> > "Parse the fwnode endpoints of the @dev device and populate the async sub-
> > devices array of the notifier. The @parse_endpoint callback function is
> > called for each endpoint with the corresponding async sub-device pointer
> > to let the caller initialize the driver-specific part of the async
> > sub-device structure."
> 
> Works for me.
> 
> > > + * The function may not be called on a registered notifier.
> > 
> > You should mention that the function may be called multiple times on an
> > unregistered notifier.
> 
> There's no point in calling it more than once as the endpoints wouldn't end
> up being different from the previous time. Actually it'd make sense to
> document this.
> 
> > "The function can be called multiple times to populate the same notifier
> > from endpoints of different @dev devices before registering the notifier.
> > It can't be called anymore once the notifier has been registered."
> 
> I don't think there's really a use case for calling this for more than one
> device, is there?

I don't have one in mind, but I was wondering. If there isn't then you don't 
need notifier_realloc(), which could be moved to the next patch.

> >> + *
> >> + * Once the user has called this function, the resources released by it
> >> need to
> >> + * be released by callin v4l2_async_notifier_release after the notifier
> >> has been
> >> + * unregistered and the sub-devices are no longer in use.
> > 
> > "Any notifier populated using this function must be released with a call
> > to v4l2_async_notifier_release() after it has been unregistered and the
> > async sub-devices are no longer in use."
> 
> Agreed.
> 
> >> + *
> >> + * A driver supporting fwnode (currently Devicetree and ACPI) should
> >> call this
> >> + * function as part of its probe function before it registers the
> >> notifier.
> >> + *
> >> + * Return: %0 on success, including when no async sub-devices are found
> >> + *	   %-ENOMEM if memory allocation failed
> >> + *	   %-EINVAL if graph or endpoint parsing failed
> >> + *	   Other error codes as returned by @parse_single
> >> + */
> >> +int v4l2_async_notifier_parse_fwnode_endpoints(
> >> +	struct device *dev, struct v4l2_async_notifier *notifier,
> >> +	size_t asd_struct_size,
> >> +	int (*parse_single)(struct device *dev,
> >> +			    struct v4l2_fwnode_endpoint *vep,
> >> +			    struct v4l2_async_subdev *asd));
> >> +
> >>  #endif /* _V4L2_FWNODE_H */

-- 
Regards,

Laurent Pinchart
