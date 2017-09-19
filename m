Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:60136 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751648AbdISMMN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:12:13 -0400
Date: Tue, 19 Sep 2017 15:11:32 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 05/25] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170919121131.6m4cf4ftzhq7vpnc@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-6-sakari.ailus@linux.intel.com>
 <2463205.SWm3RcFI57@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2463205.SWm3RcFI57@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 02:35:01PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.

Thanks for the review!

> 
> On Friday, 15 September 2017 17:17:04 EEST Sakari Ailus wrote:
> > Add two functions for parsing devices graph endpoints:
> > v4l2_async_notifier_parse_fwnode_endpoints and
> > v4l2_async_notifier_parse_fwnode_endpoints_by_port. The former iterates
> > over all endpoints whereas the latter only iterates over the endpoints in
> > a given port.
> > 
> > The former is mostly useful for existing drivers that currently implement
> > the iteration over all the endpoints themselves whereas the latter is
> > especially intended for devices with both sinks and sources: async
> > sub-devices for external devices connected to the device's sources will
> > have already been set up, or they are part of the master device.
> 
> Did you mean s/or they/as they/ ?

No. There are two options here: either the sub-devices a sub-device is
connected to (through a graph endpoint) is instantiated through the async
framework *or* through the master device driver. But not by both of them at
the same time.

> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c  |  30 ++++++
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 185 +++++++++++++++++++++++++++++++
> >  include/media/v4l2-async.h            |  24 ++++-
> >  include/media/v4l2-fwnode.h           | 117 +++++++++++++++++++++
> >  4 files changed, 354 insertions(+), 2 deletions(-)
> 
> [snip]
> 
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> > b/drivers/media/v4l2-core/v4l2-fwnode.c index 706f9e7b90f1..44ee35f6aad5
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> 
> [snip]
> 
> > +static int v4l2_async_notifier_fwnode_parse_endpoint(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct v4l2_async_subdev *asd;
> > +	struct v4l2_fwnode_endpoint *vep;
> > +	int ret = 0;
> > +
> > +	asd = kzalloc(asd_struct_size, GFP_KERNEL);
> > +	if (!asd)
> > +		return -ENOMEM;
> > +
> > +	asd->match.fwnode.fwnode =
> > +		fwnode_graph_get_remote_port_parent(endpoint);
> > +	if (!asd->match.fwnode.fwnode) {
> > +		dev_warn(dev, "bad remote port parent\n");
> > +		ret = -EINVAL;
> > +		goto out_err;
> > +	}
> > +
> > +	/* Ignore endpoints the parsing of which failed. */
> 
> I think this comment is outdated.

Hmm. Yes. I'll remove it.

> 
> > +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> > +	if (IS_ERR(vep)) {
> > +		ret = PTR_ERR(vep);
> > +		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
> > +			 ret);
> > +		goto out_err;
> > +	}
> > +
> > +	ret = parse_endpoint ? parse_endpoint(dev, vep, asd) : 0;
> > +	if (ret == -ENOTCONN)
> > +		dev_dbg(dev, "ignoring endpoint %u,%u\n", vep->base.port,
> > +			vep->base.id);
> 
> How about "ignoring port@%u/endpoint@%u\n" ? It would make the message more 
> explicit.

Works for me.

> 
> > +	else if (ret < 0)
> > +		dev_warn(dev, "driver could not parse endpoint %u,%u (%d)\n",
> 
> Same here.
> 
> > +			 vep->base.port, vep->base.id, ret);
> > +	v4l2_fwnode_endpoint_free(vep);
> > +	if (ret < 0)
> > +		goto out_err;
> > +
> > +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> 
> I'd move this line right before setting asd->match.fwnode.fwnode.

I'll move it.

> 
> > +	notifier->subdevs[notifier->num_subdevs] = asd;
> > +	notifier->num_subdevs++;
> > +
> > +	return 0;
> > +
> > +out_err:
> > +	fwnode_handle_put(asd->match.fwnode.fwnode);
> > +	kfree(asd);
> > +
> > +	return ret == -ENOTCONN ? 0 : ret;
> > +}
> > +
> > +static int __v4l2_async_notifier_parse_fwnode_endpoints(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size, unsigned int port, bool has_port,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct fwnode_handle *fwnode = NULL;
> > +	unsigned int max_subdevs = notifier->max_subdevs;
> > +	int ret;
> > +
> > +	if (WARN_ON(asd_struct_size < sizeof(struct v4l2_async_subdev)))
> > +		return -EINVAL;
> > +
> > +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> > +				     dev_fwnode(dev), fwnode)); ) {
> > +		if (!fwnode_device_is_available(
> > +			    fwnode_graph_get_port_parent(fwnode)))
> 
> Doesn't fwnode_graph_get_port_parent() increment the refcount on the parent, 
> which you should then release ?

Good catch. I'll fix this for v14.

> 
> > +			continue;
> > +
> > +		if (has_port) {
> > +			struct fwnode_endpoint ep;
> > +
> > +			ret = fwnode_graph_parse_endpoint(fwnode, &ep);
> > +			if (ret) {
> > +				fwnode_handle_put(fwnode);
> > +				return ret;
> > +			}
> > +
> > +			if (ep.port != port)
> > +				continue;
> > +		}
> > +		max_subdevs++;
> > +	}
> > +
> > +	/* No subdevs to add? Return here. */
> > +	if (max_subdevs == notifier->max_subdevs)
> > +		return 0;
> > +
> > +	ret = v4l2_async_notifier_realloc(notifier, max_subdevs);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> > +				     dev_fwnode(dev), fwnode)); ) {
> > +		if (!fwnode_device_is_available(
> > +			    fwnode_graph_get_port_parent(fwnode)))
> 
> Same here.

Yes.

> 
> > +			continue;
> > +
> > +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		if (has_port) {
> > +			struct fwnode_endpoint ep;
> > +
> > +			ret = fwnode_graph_parse_endpoint(fwnode, &ep);
> > +			if (ret)
> > +				break;
> > +
> > +			if (ep.port != port)
> > +				continue;
> > +		}
> > +
> > +		ret = v4l2_async_notifier_fwnode_parse_endpoint(
> > +			dev, notifier, fwnode, asd_struct_size, parse_endpoint);
> > +		if (ret < 0)
> > +			break;
> > +	}
> > +
> > +	fwnode_handle_put(fwnode);
> > +
> > +	return ret;
> > +}
> 
> [snip]
> 
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index c69d8c8a66d0..96fa1afc00dd 100644
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
> > + * When this struct is used as a member in a driver specific struct,
> > + * the driver specific struct shall contain the @struct
> > + * v4l2_async_subdev as its first member.
> 
> Unless I'm mistaken @ is used to refer to function arguments (sphinx typesets 
> it using <strong> in HTML). References to structures can be created with &. 
> Have you compiled the documentation ? :-)

Yes, but I've probably changed it since doing so. I'll do that again before
v14.

> 
> >   */
> >  struct v4l2_async_subdev {
> >  	enum v4l2_async_match_type match_type;
> > @@ -78,7 +81,8 @@ struct v4l2_async_subdev {
> >  /**
> >   * struct v4l2_async_notifier - v4l2_device notifier data
> >   *
> > - * @num_subdevs: number of subdevices
> > + * @num_subdevs: number of subdevices used in the subdevs array
> > + * @max_subdevs: number of subdevices allocated in the subdevs array
> >   * @subdevs:	array of pointers to subdevice descriptors
> >   * @v4l2_dev:	pointer to struct v4l2_device
> >   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> > @@ -90,6 +94,7 @@ struct v4l2_async_subdev {
> >   */
> >  struct v4l2_async_notifier {
> >  	unsigned int num_subdevs;
> > +	unsigned int max_subdevs;
> >  	struct v4l2_async_subdev **subdevs;
> >  	struct v4l2_device *v4l2_dev;
> >  	struct list_head waiting;
> > @@ -121,6 +126,21 @@ int v4l2_async_notifier_register(struct v4l2_device
> > *v4l2_dev, void v4l2_async_notifier_unregister(struct v4l2_async_notifier
> > *notifier);
> > 
> >  /**
> > + * v4l2_async_notifier_release - release notifier resources
> > + * @notifier: the notifier the resources of which are to be released
> > + *
> > + * Release memory resources related to a notifier, including the async
> > + * sub-devices allocated for the purposes of the notifier. The user is
> > + * responsible for releasing the notifier's resources after calling
> > + * @v4l2_async_notifier_parse_fwnode_endpoints.
> 
> Don't use @. If you want sphinx to generate a link, just append () after the 
> function name.
> 
> > + *
> > + * There is no harm from calling v4l2_async_notifier_release in other
> 
> Here too.

Ack.

> 
> > + * cases as long as its memory has been zeroed after it has been
> > + * allocated.
> 
> As the function WARNs for types other than V4L2_ASYNC_MATCH_FWNODE you might 
> want to mention that in the documentation.

I wouldn't. The user would have to do something very wrong to get there.
The user isn't allowed to touch the notifier's subdevs array directly and
the existing functions only use fwnode matching. This is documented in the
user-visible parsing functions themselves.

> 
> > + */
> > +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier);
> > +
> > +/**
> >   * v4l2_async_register_subdev - registers a sub-device to the asynchronous
> >   * 	subdevice framework
> >   *
> > diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > index 68eb22ba571b..83afac48ea6b 100644
> > --- a/include/media/v4l2-fwnode.h
> > +++ b/include/media/v4l2-fwnode.h
> > @@ -25,6 +25,8 @@
> >  #include <media/v4l2-mediabus.h>
> > 
> >  struct fwnode_handle;
> > +struct v4l2_async_notifier;
> > +struct v4l2_async_subdev;
> > 
> >  #define V4L2_FWNODE_CSI2_MAX_DATA_LANES	4
> > 
> > @@ -201,4 +203,119 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> > *fwnode, */
> >  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> > 
> > +/**
> > + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints
> > in a
> > + *						device node
> > + * @dev: the device the endpoints of which are to be parsed
> > + * @notifier: notifier for @dev
> > + * @asd_struct_size: size of the driver's async sub-device struct,
> > including
> > + *		     sizeof(struct v4l2_async_subdev). The &struct
> > + *		     v4l2_async_subdev shall be the first member of
> > + *		     the driver's async sub-device struct, i.e. both
> > + *		     begin at the same memory address.
> > + * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
> > + *		    endpoint. Optional.
> > + *		    Return: %0 on success
> > + *			    %-ENOTCONN if the endpoint is to be skipped but this
> > + *				       should not be considered as an error
> > + *			    %-EINVAL if the endpoint configuration is invalid
> > + *
> > + * Parse the fwnode endpoints of the @dev device and populate the async
> > sub-
> > + * devices array of the notifier. The @parse_endpoint callback function is
> > + * called for each endpoint with the corresponding async sub-device pointer
> > to
> > + * let the caller initialize the driver-specific part of the async sub-
> > device
> > + * structure.
> > + *
> > + * The notifier memory shall be zeroed before this function is called on
> > the
> > + * notifier.
> > + *
> > + * This function may not be called on a registered notifier and may be
> > called on
> > + * a notifier only once.
> > + *
> > + * Do not change the notifier's subdevs array, take references to the
> > subdevs
> > + * array itself or change the notifier's num_subdevs field. This is because
> > this
> > + * function allocates and reallocates the subdevs array based on parsing
> > + * endpoints.
> > + *
> > + * The @struct v4l2_fwnode_endpoint passed to the callback function
> > + * @parse_endpoint is released once the function is finished. If there is a
> > need
> > + * to retain that configuration, the user needs to allocate memory for it.
> > + *
> > + * Any notifier populated using this function must be released with a call
> > to
> > + * v4l2_async_notifier_release() after it has been unregistered and the
> > async
> > + * sub-devices are no longer in use, even if the function returned an
> > error.
> > + *
> > + * Return: %0 on success, including when no async sub-devices are found
> > + *	   %-ENOMEM if memory allocation failed
> > + *	   %-EINVAL if graph or endpoint parsing failed
> > + *	   Other error codes as returned by @parse_endpoint
> > + */
> > +int v4l2_async_notifier_parse_fwnode_endpoints(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			      struct v4l2_fwnode_endpoint *vep,
> > +			      struct v4l2_async_subdev *asd));
> > +
> > +/**
> > + * v4l2_async_notifier_parse_fwnode_endpoints_by_port - Parse V4L2 fwnode
> > + *							endpoints of a port in a
> > + *							device node
> 
> This clearly shows that the function name is getting a bit long :-)

Yes. The arguments are few and the function is likely not used many times
in a driver.

If you have a better suggestion I'd be happy to have one.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
