Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56053 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753948AbdHWM7F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 08:59:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/3] v4l: fwnode: Support generic parsing of graph endpoints in a device
Date: Wed, 23 Aug 2017 15:59:35 +0300
Message-ID: <7848458.ASShLhbEvA@avalon>
In-Reply-To: <20170823090123.ztqz6usu7l5qdwkj@valkosipuli.retiisi.org.uk>
References: <20170818112317.30933-1-sakari.ailus@linux.intel.com> <2804301.TqBigdGaBJ@avalon> <20170823090123.ztqz6usu7l5qdwkj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday, 23 August 2017 12:01:24 EEST Sakari Ailus wrote:
> On Tue, Aug 22, 2017 at 03:52:33PM +0300, Laurent Pinchart wrote:
> > On Friday, 18 August 2017 14:23:16 EEST Sakari Ailus wrote:
> >> The current practice is that drivers iterate over their endpoints and
> >> parse each endpoint separately. This is very similar in a number of
> >> drivers, implement a generic function for the job. Driver specific
> >> matters can be taken into account in the driver specific callback.
> >> 
> >> Convert the omap3isp as an example.
> > 
> > It would be nice to convert at least two drivers to show that the code can
> > indeed be shared between multiple drivers. Even better, you could convert
> > all drivers.
> 
> That's the intent in the long run. There's still no definite need to do
> this in a single, big, hot patchset.

You don't need to convert them all in a single patch, but I'd still prefer 
converting them all in a single patch series (and I'd split this patch in two 
to make backporting easier). Otherwise we'll likely end up with multiple 
competing implementations.

> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> drivers/media/platform/omap3isp/isp.c | 116 ++++++++++------------------
> >> drivers/media/v4l2-core/v4l2-fwnode.c | 125 +++++++++++++++++++++++++
> >> include/media/v4l2-async.h            |   4 +-
> >> include/media/v4l2-fwnode.h           |   9 +++
> >> 4 files changed, 173 insertions(+), 81 deletions(-)
> > 
> > [snip]
> > 
> >> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> >> b/drivers/media/v4l2-core/v4l2-fwnode.c index 5cd2687310fe..cb0fc4b4e3bf
> >> 100644
> >> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> >> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> >> @@ -26,6 +26,7 @@
> >>  #include <linux/string.h>
> >>  #include <linux/types.h>
> >> 
> >> +#include <media/v4l2-async.h>
> >>  #include <media/v4l2-fwnode.h>
> >>  
> >>  enum v4l2_fwnode_bus_type {
> >> @@ -383,6 +384,130 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link
> >> *link) }
> >> 
> >>  EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
> >> 
> >> +static int notifier_realloc(struct device *dev,
> >> +			    struct v4l2_async_notifier *notifier,
> >> +			    unsigned int max_subdevs)
> > 
> > It looks like you interpret the variable as an increment. You shouldn't
> > call it max_subdevs in that case. I would however keep the name and pass
> > the total number of subdevs instead of an increment, to mimic the realloc
> > API.
> 
> Works for me.
> 
> >> +{
> >> +	struct v4l2_async_subdev **subdevs;
> >> +	unsigned int i;
> >> +
> >> +	if (max_subdevs + notifier->num_subdevs <= notifier->max_subdevs)
> >> +		return 0;
> >> +
> >> +	subdevs = devm_kcalloc(
> >> +		dev, max_subdevs + notifier->num_subdevs,
> >> +		sizeof(*notifier->subdevs), GFP_KERNEL);
> > 
> > We know that we'll have to move away from devm_* allocation to fix object
> > lifetime management, so we could as well start now.
> 
> The memory is in practice allocated using devm_() interface in existing
> drivers.

Yes, and that's bad :-)

> The fact that it's in a single location makes it much easier getting rid of
> it.

Great, so let's get rid of it :-)

> I'd rather get rid of memory allocation here in the first place, to be
> replaced by a linked list. But first the user of notifier->subdevs in
> drivers need to go. The framework interface doesn't need to change as a
> result.

How are you going to allocate and free the linked list entries ?

> >> +	if (!subdevs)
> >> +		return -ENOMEM;
> >> +
> >> +	if (notifier->subdevs) {
> >> +		for (i = 0; i < notifier->num_subdevs; i++)
> >> +			subdevs[i] = notifier->subdevs[i];
> > 
> > Is there a reason to use a loop here instead of a memcpy() covering the
> > whole array ?
> 
> You could do that, yes, although I'd think this looks nicer. Performance is
> hardly a concern here.

It's certainly not a performance issue, I would find the code easier to read.

> >> +		devm_kfree(dev, notifier->subdevs);
> >> +	}
> >> +
> >> +	notifier->subdevs = subdevs;
> >> +	notifier->max_subdevs = max_subdevs + notifier->num_subdevs;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int __v4l2_fwnode_endpoint_parse(
> >> +	struct device *dev, struct v4l2_async_notifier *notifier,
> >> +	struct fwnode_handle *endpoint, struct v4l2_async_subdev *asd,
> >> +	int (*parse_single)(struct device *dev,
> >> +			    struct v4l2_fwnode_endpoint *vep,
> >> +			    struct v4l2_async_subdev *asd))
> >> +{
> >> +	struct v4l2_fwnode_endpoint *vep;
> >> +	int ret;
> >> +
> >> +	/* Ignore endpoints the parsing of which failed. */
> > 
> > Silently ignoring invalid DT sounds bad, I'd rather catch errors and
> > return with an error code to make sure that DT gets fixed.
> 
> That would mean that if a single node is bad, none of the correct ones can
> be used either. I'm not sure everyone would be happy about it.

We should be tolerant towards hardware failures and make as much of the device 
usable as possible, but be very pedantic when parsing DT to catch errors as 
early as possible.

> >> +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> >> +	if (IS_ERR(vep))
> >> +		return 0;
> >> +
> >> +	notifier->subdevs[notifier->num_subdevs] = asd;
> >> +
> >> +	ret = parse_single(dev, vep, asd);
> >> +	v4l2_fwnode_endpoint_free(vep);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	asd->match.fwnode.fwnode =
> >> +		fwnode_graph_get_remote_port_parent(endpoint);
> >> +	if (!asd->match.fwnode.fwnode) {
> >> +		dev_warn(dev, "bad remote port parent\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> >> +	notifier->num_subdevs++;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * v4l2_fwnode_endpoint_parse - Parse V4L2 fwnode endpoints in a device
> >> node
> > 
> > This doesn't match the function name.
> 
> Will fix.
> 
> >> + * @dev: local struct device
> > 
> > Based on the documentation only and without a priori knowledge of the API,
> > local struct device is very vague.
> 
> What would you use then?
> 
> Write a fairytale about it? :-)

Just explain which struct device is expected, and how it relates to the 
purpose of the function and its other parameters. If you find that hard to 
explain, imagine how confused someone trying to use the API without any a 
priori knowledge of the subsystem will feel.

> >> + * @notifier: async notifier related to @dev
> > 
> > Ditto. You need more documentation, especially given that this is the
> > first function in the core that fills a notifier from DT. You might also
> > want to reflect that fact in the function name.
> 
> I can add more documentation.
> 
> >> + * @asd_struct_size: size of the driver's async sub-device struct,
> >> including
> >> + *		     sizeof(struct v4l2_async_subdev)
> >> + * @parse_single: driver's callback function called on each V4L2 fwnode
> >> endpoint
> > 
> > The parse_single return values should be documented.
> 
> Agreed.
> 
> >> + * Parse all V4L2 fwnode endpoints related to the device.
> >> + *
> >> + * Note that this function is intended for drivers to replace the
> >> existing
> >> + * implementation that loops over all ports and endpoints. It is NOT
> >> INTENDED TO
> >> + * BE USED BY NEW DRIVERS.
> > 
> > You should document what the preferred way is. And I'd much rather convert
> > drivers to the preferred way instead of adding a helper function that is
> > already deprecated.
> 
> The preferred way is not a part of this patch but the second one. This is
> intended for moving the existing copies of the same code away from drivers.

You remove the code from a single driver here. How many drivers do we need to 
convert ?

> The preferred way would be to explicitly check ports and endpoints in them
> for connections. I'm not sure if the existing DT documentation is enough to
> cover this for it does not generally document endpoint numbering.
> 
> >> + */
> >> +int v4l2_fwnode_endpoints_parse(
> > 
> > v4l2_fwnode_parse_endpoints() would sound more natural.
> 
> We'll need to think more about naming this. v4l2_fwnode_endpoint_parse()
> will parse a single endpoint and is entirely unaware of the notifier.
> 
> How about v4l2_async_notifier_parse_endpoints()? It's a big lengthy though.

And it's missing fwnode in the name :-)

> >> +	struct device *dev, struct v4l2_async_notifier *notifier,
> >> +	size_t asd_struct_size,
> >> +	int (*parse_single)(struct device *dev,
> >> +			    struct v4l2_fwnode_endpoint *vep,
> >> +			    struct v4l2_async_subdev *asd))
> >> +{
> >> +	struct fwnode_handle *fwnode = NULL;
> >> +	unsigned int max_subdevs = notifier->max_subdevs;
> >> +	int ret;
> >> +
> >> +	if (asd_struct_size < sizeof(struct v4l2_async_subdev))
> >> +		return -EINVAL;
> >> +
> >> +	while ((fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev),
> >> +							fwnode)))
> >> +		max_subdevs++;
> >> +
> >> +	ret = notifier_realloc(dev, notifier, max_subdevs);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> >> +				     dev_fwnode(dev), fwnode)) &&
> >> +		     !WARN_ON(notifier->num_subdevs >= notifier->max_subdevs);
> > 
> > It's nice to warn that the kernel will crash, but it would be even nicer
> > to prevent the crash by returning an error instead of continuing parsing
> > endpoints :-)
> 
> I'm not quite sure what do you mean. If the number of sub-devices reaches
> what's allocated for them in the array, this will stop with a warning.

Oops, my bad, I've misread the code. Your for loop is not very readable :-/ 
How about moving the num_subdevs test inside the loop with

		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs))
			break;

That should make it more readable.

> >> +		) {
> >> +		struct v4l2_async_subdev *asd;
> >> +
> >> +		asd = devm_kzalloc(dev, asd_struct_size, GFP_KERNEL);
> >> +		if (!asd) {
> >> +			ret = -ENOMEM;
> >> +			goto error;
> >> +		}
> >> +
> >> +		ret = __v4l2_fwnode_endpoint_parse(dev, notifier, fwnode, asd,
> >> +						   parse_single);
> >> +		if (ret < 0)
> >> +			goto error;
> >> +	}
> >> +
> >> +error:
> >> +	fwnode_handle_put(fwnode);
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoints_parse);

[snip]

-- 
Regards,

Laurent Pinchart
