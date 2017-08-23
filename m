Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32806 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753445AbdHWJB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 05:01:27 -0400
Date: Wed, 23 Aug 2017 12:01:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/3] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170823090123.ztqz6usu7l5qdwkj@valkosipuli.retiisi.org.uk>
References: <20170818112317.30933-1-sakari.ailus@linux.intel.com>
 <20170818112317.30933-3-sakari.ailus@linux.intel.com>
 <2804301.TqBigdGaBJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2804301.TqBigdGaBJ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the critique.

On Tue, Aug 22, 2017 at 03:52:33PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 18 August 2017 14:23:16 EEST Sakari Ailus wrote:
> > The current practice is that drivers iterate over their endpoints and
> > parse each endpoint separately. This is very similar in a number of
> > drivers, implement a generic function for the job. Driver specific matters
> > can be taken into account in the driver specific callback.
> > 
> > Convert the omap3isp as an example.
> 
> It would be nice to convert at least two drivers to show that the code can 
> indeed be shared between multiple drivers. Even better, you could convert all 
> drivers.

That's the intent in the long run. There's still no definite need to do
this in a single, big, hot patchset.

>  
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > drivers/media/platform/omap3isp/isp.c | 116 ++++++++++---------------------
> > drivers/media/v4l2-core/v4l2-fwnode.c | 125 ++++++++++++++++++++++++++++++++
> > include/media/v4l2-async.h            |   4 +-
> > include/media/v4l2-fwnode.h           |   9 +++
> > 4 files changed, 173 insertions(+), 81 deletions(-)
> 
> [snip]
> 
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> > b/drivers/media/v4l2-core/v4l2-fwnode.c index 5cd2687310fe..cb0fc4b4e3bf
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/string.h>
> >  #include <linux/types.h>
> > 
> > +#include <media/v4l2-async.h>
> >  #include <media/v4l2-fwnode.h>
> > 
> >  enum v4l2_fwnode_bus_type {
> > @@ -383,6 +384,130 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link
> > *link) }
> >  EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
> > 
> > +static int notifier_realloc(struct device *dev,
> > +			    struct v4l2_async_notifier *notifier,
> > +			    unsigned int max_subdevs)
> 
> It looks like you interpret the variable as an increment. You shouldn't call 
> it max_subdevs in that case. I would however keep the name and pass the total 
> number of subdevs instead of an increment, to mimic the realloc API.

Works for me.

> 
> > +{
> > +	struct v4l2_async_subdev **subdevs;
> > +	unsigned int i;
> > +
> > +	if (max_subdevs + notifier->num_subdevs <= notifier->max_subdevs)
> > +		return 0;
> > +
> > +	subdevs = devm_kcalloc(
> > +		dev, max_subdevs + notifier->num_subdevs,
> > +		sizeof(*notifier->subdevs), GFP_KERNEL);
> 
> We know that we'll have to move away from devm_* allocation to fix object 
> lifetime management, so we could as well start now.

The memory is in practice allocated using devm_() interface in existing
drivers. The fact that it's in a single location makes it much easier
getting rid of it.

I'd rather get rid of memory allocation here in the first place, to be
replaced by a linked list. But first the user of notifier->subdevs in
drivers need to go. The framework interface doesn't need to change as a
result.

> 
> > +	if (!subdevs)
> > +		return -ENOMEM;
> > +
> > +	if (notifier->subdevs) {
> > +		for (i = 0; i < notifier->num_subdevs; i++)
> > +			subdevs[i] = notifier->subdevs[i];
> 
> Is there a reason to use a loop here instead of a memcpy() covering the whole 
> array ?

You could do that, yes, although I'd think this looks nicer. Performance is
hardly a concern here.

> 
> > +		devm_kfree(dev, notifier->subdevs);
> > +	}
> > +
> > +	notifier->subdevs = subdevs;
> > +	notifier->max_subdevs = max_subdevs + notifier->num_subdevs;
> > +
> > +	return 0;
> > +}
> > +
> > +static int __v4l2_fwnode_endpoint_parse(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	struct fwnode_handle *endpoint, struct v4l2_async_subdev *asd,
> > +	int (*parse_single)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct v4l2_fwnode_endpoint *vep;
> > +	int ret;
> > +
> > +	/* Ignore endpoints the parsing of which failed. */
> 
> Silently ignoring invalid DT sounds bad, I'd rather catch errors and return 
> with an error code to make sure that DT gets fixed.

That would mean that if a single node is bad, none of the correct ones can
be used either. I'm not sure everyone would be happy about it.

> 
> > +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> > +	if (IS_ERR(vep))
> > +		return 0;
> > +
> > +	notifier->subdevs[notifier->num_subdevs] = asd;
> > +
> > +	ret = parse_single(dev, vep, asd);
> > +	v4l2_fwnode_endpoint_free(vep);
> > +	if (ret)
> > +		return ret;
> > +
> > +	asd->match.fwnode.fwnode =
> > +		fwnode_graph_get_remote_port_parent(endpoint);
> > +	if (!asd->match.fwnode.fwnode) {
> > +		dev_warn(dev, "bad remote port parent\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> > +	notifier->num_subdevs++;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * v4l2_fwnode_endpoint_parse - Parse V4L2 fwnode endpoints in a device
> > node
> 
> This doesn't match the function name.

Will fix.

> 
> > + * @dev: local struct device
> 
> Based on the documentation only and without a priori knowledge of the API, 
> local struct device is very vague.

What would you use then?

Write a fairytale about it? :-)

> 
> > + * @notifier: async notifier related to @dev
> 
> Ditto. You need more documentation, especially given that this is the first 
> function in the core that fills a notifier from DT. You might also want to 
> reflect that fact in the function name.

I can add more documentation.

> 
> > + * @asd_struct_size: size of the driver's async sub-device struct,
> > including
> > + *		     sizeof(struct v4l2_async_subdev)
> > + * @parse_single: driver's callback function called on each V4L2 fwnode
> > endpoint
> 
> The parse_single return values should be documented.

Agreed.

> 
> > + * Parse all V4L2 fwnode endpoints related to the device.
> > + *
> > + * Note that this function is intended for drivers to replace the existing
> > + * implementation that loops over all ports and endpoints. It is NOT
> > INTENDED TO
> > + * BE USED BY NEW DRIVERS.
> 
> You should document what the preferred way is. And I'd much rather convert 
> drivers to the preferred way instead of adding a helper function that is 
> already deprecated.

The preferred way is not a part of this patch but the second one. This is
intended for moving the existing copies of the same code away from drivers.

The preferred way would be to explicitly check ports and endpoints in them
for connections. I'm not sure if the existing DT documentation is enough to
cover this for it does not generally document endpoint numbering.

> 
> > + */
> > +int v4l2_fwnode_endpoints_parse(
> 
> v4l2_fwnode_parse_endpoints() would sound more natural.

We'll need to think more about naming this. v4l2_fwnode_endpoint_parse()
will parse a single endpoint and is entirely unaware of the notifier.

How about v4l2_async_notifier_parse_endpoints()? It's a big lengthy though.

> 
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size,
> > +	int (*parse_single)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct fwnode_handle *fwnode = NULL;
> > +	unsigned int max_subdevs = notifier->max_subdevs;
> > +	int ret;
> > +
> > +	if (asd_struct_size < sizeof(struct v4l2_async_subdev))
> > +		return -EINVAL;
> > +
> > +	while ((fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev),
> > +							fwnode)))
> > +		max_subdevs++;
> > +
> > +	ret = notifier_realloc(dev, notifier, max_subdevs);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> > +				     dev_fwnode(dev), fwnode)) &&
> > +		     !WARN_ON(notifier->num_subdevs >= notifier->max_subdevs);
> 
> It's nice to warn that the kernel will crash, but it would be even nicer to 
> prevent the crash by returning an error instead of continuing parsing 
> endpoints :-)

I'm not quite sure what do you mean. If the number of sub-devices reaches
what's allocated for them in the array, this will stop with a warning.

> 
> > +		) {
> > +		struct v4l2_async_subdev *asd;
> > +
> > +		asd = devm_kzalloc(dev, asd_struct_size, GFP_KERNEL);
> > +		if (!asd) {
> > +			ret = -ENOMEM;
> > +			goto error;
> > +		}
> > +
> > +		ret = __v4l2_fwnode_endpoint_parse(dev, notifier, fwnode, asd,
> > +						   parse_single);
> > +		if (ret < 0)
> > +			goto error;
> > +	}
> > +
> > +error:
> > +	fwnode_handle_put(fwnode);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoints_parse);
> > +
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
> >  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index c69d8c8a66d0..067f3687774b 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -78,7 +78,8 @@ struct v4l2_async_subdev {
> >  /**
> >   * struct v4l2_async_notifier - v4l2_device notifier data
> >   *
> > - * @num_subdevs: number of subdevices
> > + * @num_subdevs: number of subdevices used in subdevs array
> > + * @max_subdevs: number of subdevices allocated in subdevs array
> >   * @subdevs:	array of pointers to subdevice descriptors
> >   * @v4l2_dev:	pointer to struct v4l2_device
> >   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> > @@ -90,6 +91,7 @@ struct v4l2_async_subdev {
> >   */
> >  struct v4l2_async_notifier {
> >  	unsigned int num_subdevs;
> > +	unsigned int max_subdevs;
> >  	struct v4l2_async_subdev **subdevs;
> >  	struct v4l2_device *v4l2_dev;
> >  	struct list_head waiting;
> > diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > index cb34dcb0bb65..c75a768d4ef7 100644
> > --- a/include/media/v4l2-fwnode.h
> > +++ b/include/media/v4l2-fwnode.h
> > @@ -25,6 +25,8 @@
> >  #include <media/v4l2-mediabus.h>
> > 
> >  struct fwnode_handle;
> > +struct v4l2_async_notifier;
> > +struct v4l2_async_subdev;
> > 
> >  #define MAX_DATA_LANES	4
> > 
> > @@ -122,4 +124,11 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> > *fwnode, struct v4l2_fwnode_link *link);
> >  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> > 
> > +int v4l2_fwnode_endpoints_parse(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size,
> > +	int (*parse_single)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd));
> > +
> >  #endif /* _V4L2_FWNODE_H */
> 
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
