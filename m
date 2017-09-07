Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60972 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751398AbdIGHet (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 03:34:49 -0400
Date: Thu, 7 Sep 2017 10:34:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v8 06/21] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170907073446.ajxsscekwrbfbtgk@valkosipuli.retiisi.org.uk>
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-7-sakari.ailus@linux.intel.com>
 <dd3a2e55-8de0-c30e-04a7-cb26b519689c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd3a2e55-8de0-c30e-04a7-cb26b519689c@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Sep 06, 2017 at 09:41:40AM +0200, Hans Verkuil wrote:
> On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> > The current practice is that drivers iterate over their endpoints and
> > parse each endpoint separately. This is very similar in a number of
> > drivers, implement a generic function for the job. Driver specific matters
> > can be taken into account in the driver specific callback.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c  |  19 +++++
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 140 ++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-async.h            |  24 +++++-
> >  include/media/v4l2-fwnode.h           |  53 +++++++++++++
> >  4 files changed, 234 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 3d81ff6a496f..7bd595c4094a 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -22,6 +22,7 @@
> >  
> >  #include <media/v4l2-async.h>
> >  #include <media/v4l2-device.h>
> > +#include <media/v4l2-fwnode.h>
> >  #include <media/v4l2-subdev.h>
> >  
> >  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> > @@ -224,6 +225,24 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  }
> >  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> >  
> > +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier)
> > +{
> > +	unsigned int i;
> > +
> > +	if (!notifier->max_subdevs)
> > +		return;
> > +
> > +	for (i = 0; i < notifier->num_subdevs; i++)
> > +		kfree(notifier->subdevs[i]);
> > +
> > +	notifier->max_subdevs = 0;
> > +	notifier->num_subdevs = 0;
> > +
> > +	kvfree(notifier->subdevs);
> > +	notifier->subdevs = NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_release);
> > +
> >  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  {
> >  	struct v4l2_async_notifier *notifier;
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> > index 706f9e7b90f1..e6932d7d47b6 100644
> > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > @@ -19,6 +19,7 @@
> >   */
> >  #include <linux/acpi.h>
> >  #include <linux/kernel.h>
> > +#include <linux/mm.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/property.h>
> > @@ -26,6 +27,7 @@
> >  #include <linux/string.h>
> >  #include <linux/types.h>
> >  
> > +#include <media/v4l2-async.h>
> >  #include <media/v4l2-fwnode.h>
> >  
> >  enum v4l2_fwnode_bus_type {
> > @@ -313,6 +315,144 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
> >  
> > +static int v4l2_async_notifier_realloc(struct v4l2_async_notifier *notifier,
> > +				       unsigned int max_subdevs)
> > +{
> > +	struct v4l2_async_subdev **subdevs;
> > +
> > +	if (max_subdevs <= notifier->max_subdevs)
> > +		return 0;
> > +
> > +	subdevs = kvmalloc_array(
> > +		max_subdevs, sizeof(*notifier->subdevs),
> > +		GFP_KERNEL | __GFP_ZERO);
> > +	if (!subdevs)
> > +		return -ENOMEM;
> > +
> > +	if (notifier->subdevs) {
> > +		memcpy(subdevs, notifier->subdevs,
> > +		       sizeof(*subdevs) * notifier->num_subdevs);
> > +
> > +		kvfree(notifier->subdevs);
> > +	}
> > +
> > +	notifier->subdevs = subdevs;
> > +	notifier->max_subdevs = max_subdevs;
> > +
> > +	return 0;
> > +}
> > +
> > +static int v4l2_async_notifier_fwnode_parse_endpoint(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct v4l2_async_subdev *asd;
> > +	struct v4l2_fwnode_endpoint *vep;
> > +	struct fwnode_endpoint ep;
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
> > +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> > +	if (IS_ERR(vep)) {
> > +		ret = PTR_ERR(vep);
> > +		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
> > +			 ret);
> > +		goto out_err;
> > +	}
> > +
> > +	ep = vep->base;
> > +
> > +	ret = parse_endpoint ? parse_endpoint(dev, vep, asd) : 0;
> > +	v4l2_fwnode_endpoint_free(vep);
> > +	if (ret == -ENOTCONN) {
> > +		dev_dbg(dev, "ignoring endpoint %u,%u\n", ep.port, ep.id);
> > +		kfree(asd);
> 
> Shouldn't there be a call to fwnode_handle_put()?

Actually no. But your hunch is right in the sense that I think there are
issues. The fwnode_endpoint (as of_endpoint) contains the fwnode which is
referenced, but no reference is taken here. One couldn't be released either
later on, as the fwnode field is const.

I guess this is almost fine as long as the fwnode field is used for pointer
comparison and nothing else but you can never be sure what drivers actually
do.

This actually should be addressed for both OF and fwnode but it's mostly
independent of this patchset. Luckily there are not *that* many users of
this. The V4L2 fwnode interface that allocates and releases endpoints makes
this quite a bit easier actually.

> 
> > +		return 0;
> > +	} else if (ret < 0) {
> > +		dev_warn(dev, "driver could not parse endpoint %u,%u (%d)\n",
> > +			 ep.port, ep.id, ret);
> > +		goto out_err;
> > +	}
> 
> I think this would be better and it avoids the need for the ep local variable:
> 
> 	ret = parse_endpoint ? parse_endpoint(dev, vep, asd) : 0;
> 	if (ret == -ENOTCONN)
> 		dev_dbg(dev, "ignoring endpoint %u,%u\n", vep->base.port, vep->base.id);
> 	else if (ret < 0)
> 		dev_warn(dev, "driver could not parse endpoint %u,%u (%d)\n",
> 			 vep->base.port, vep->base.id, ret);
> 	v4l2_fwnode_endpoint_free(vep);
> 	if (ret < 0)
> 		goto out_err;
> 
> And the 'return ret;' below would become:
> 
> 	return ret == -ENOTCONN ? 0 : ret;

Looks good to me, I'll use it.

> 
> > +
> > +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> > +	notifier->subdevs[notifier->num_subdevs] = asd;
> > +	notifier->num_subdevs++;
> > +
> > +	return 0;
> > +
> > +out_err:
> > +	fwnode_handle_put(asd->match.fwnode.fwnode);
> > +	kfree(asd);
> > +
> > +	return ret;
> > +}
> > +
> > +int v4l2_async_notifier_parse_fwnode_endpoints(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	struct fwnode_handle *fwnode = NULL;
> > +	unsigned int max_subdevs = notifier->max_subdevs;
> > +	int ret;
> > +
> > +	if (asd_struct_size < sizeof(struct v4l2_async_subdev))
> 
> I think this can be a WARN_ON or a WARN_ON_ONCE. Up to you, though.

It'd be a driver bug, so either seems appropriate. I'll use WARN_ON().

> 
> > +		return -EINVAL;
> > +
> > +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> > +				     dev_fwnode(dev), fwnode)); )
> > +		if (fwnode_device_is_available(
> > +			    fwnode_graph_get_port_parent(fwnode)))
> > +			max_subdevs++;
> 
> I think I would prefer this as a simple for (;;):
> 
> 	for (;;) {

I think for (;;) is misuse of the for loop. :-D

> 		fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev), fwnode));
> 		if (fwnode == NULL)
> 			break;
> 		...
> 	}
> 
> Or alternatively as a do...while:
> 
> 	do {
> 		fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev), fwnode));
> 		if (fwnode && fwnode_device_is_available(
> 			    fwnode_graph_get_port_parent(fwnode)))
> 			max_subdevs++;
> 	} while (fwnode);
> 
> Both are IMHO a bit more readable. I leave it up to you, though.
> 
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
> 
> Same comment as above.

What I like in the original code is that managing looping over all
endpoints takes place directly in the for () statement and does not spill
over to where the individual endpoints are being handled.

What would you think of adding a macro to do this? Say, we could write
this as:

fwnode_graph_for_each_endpoint(dev_fwnode(dev), fwnode) {
	...
}

That'd have to go through linux-pm tree though, and we could change the
code here later on.

> 
> > +		if (!fwnode_device_is_available(
> > +			    fwnode_graph_get_port_parent(fwnode)))
> > +			continue;
> > +
> > +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
> > +			ret = -EINVAL;
> > +			break;
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
> > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
> > +
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
> >  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
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
> > @@ -121,6 +126,21 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
> >  
> >  /**
> > + * v4l2_async_notifier_release - release notifier resources
> > + * @notifier: the notifier the resources of which are to be released
> > + *
> > + * Release memory resources related to a notifier, including the async
> > + * sub-devices allocated for the purposes of the notifier. The user is
> > + * responsible for releasing the notifier's resources after calling
> > + * @v4l2_async_notifier_parse_fwnode_endpoints.
> > + *
> > + * There is no harm from calling v4l2_async_notifier_release in other
> > + * cases as long as its memory has been zeroed after it has been
> > + * allocated.
> > + */
> > +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier);
> > +
> > +/**
> >   * v4l2_async_register_subdev - registers a sub-device to the asynchronous
> >   * 	subdevice framework
> >   *
> > diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > index 68eb22ba571b..6d125f26ec84 100644
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
> > @@ -201,4 +203,55 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
> >   */
> >  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> >  
> > +/**
> > + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints in a
> > + *						device node
> > + * @dev: the device the endpoints of which are to be parsed
> > + * @notifier: notifier for @dev
> > + * @asd_struct_size: size of the driver's async sub-device struct, including
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
> > + * Parse the fwnode endpoints of the @dev device and populate the async sub-
> > + * devices array of the notifier. The @parse_endpoint callback function is
> > + * called for each endpoint with the corresponding async sub-device pointer to
> > + * let the caller initialize the driver-specific part of the async sub-device
> > + * structure.
> > + *
> > + * The notifier memory shall be zeroed before this function is called on the
> > + * notifier.
> > + *
> > + * This function may not be called on a registered notifier and may be called on
> > + * a notifier only once. When using this function, the user may not access the
> > + * notifier's subdevs array nor change notifier's num_subdevs field, these are
> > + * reserved for the framework's internal use only.
> 
> The rvin_digital_graph_init() function accesses the subdevs array.
> 
> I still don't like this sentence, and I still think it should be dropped. Either that
> or completely rewritten.

How about:

When using this function on a notifier, the user is not allowed to change
the notifier's subdevs array, take references to the subdevs array itself
nor change the notifier's num_subdevs field. This is because the function
allocates and reallocates the subdevs array based on parsing endpoints.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
