Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:30214 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965970AbdIZILT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 04:11:19 -0400
Date: Tue, 26 Sep 2017 11:11:11 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v14 05/28] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170926081111.lu6efij4uagjepwh@paasikivi.fi.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-6-sakari.ailus@linux.intel.com>
 <0afab3ba-23fc-556e-1db6-f168fdea3be6@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0afab3ba-23fc-556e-1db6-f168fdea3be6@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 26, 2017 at 10:06:52AM +0200, Hans Verkuil wrote:
> On 26/09/17 00:25, Sakari Ailus wrote:
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
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I have two small comments below. After fixing that you can add my:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks; fixed the issues below.

> 
> Regards,
> 
> 	Hans
> 
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c  |  30 ++++++
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 196 ++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-async.h            |  24 ++++-
> >  include/media/v4l2-fwnode.h           | 118 ++++++++++++++++++++
> >  4 files changed, 366 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 60ac2f4fc69e..dd2559316ccd 100644
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
> > @@ -221,6 +222,35 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >  }
> >  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> >  
> > +void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
> > +{
> > +	unsigned int i;
> > +
> > +	if (!notifier->max_subdevs)
> > +		return;
> > +
> > +	for (i = 0; i < notifier->num_subdevs; i++) {
> > +		struct v4l2_async_subdev *asd = notifier->subdevs[i];
> > +
> > +		switch (asd->match_type) {
> > +		case V4L2_ASYNC_MATCH_FWNODE:
> > +			fwnode_handle_put(asd->match.fwnode.fwnode);
> > +			break;
> > +		default:
> > +			WARN_ON_ONCE(true);
> 
> Missing break.
> 
> > +		}
> > +
> > +		kfree(asd);
> > +	}
> > +
> > +	notifier->max_subdevs = 0;
> > +	notifier->num_subdevs = 0;
> > +
> > +	kvfree(notifier->subdevs);
> > +	notifier->subdevs = NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
> > +
> >  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  {
> >  	struct v4l2_async_notifier *notifier;
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> > index 706f9e7b90f1..ea67d673c4a8 100644
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
> > @@ -313,6 +315,200 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
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
> > +	int ret = 0;
> > +
> > +	asd = kzalloc(asd_struct_size, GFP_KERNEL);
> > +	if (!asd)
> > +		return -ENOMEM;
> > +
> > +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> > +	asd->match.fwnode.fwnode =
> > +		fwnode_graph_get_remote_port_parent(endpoint);
> > +	if (!asd->match.fwnode.fwnode) {
> > +		dev_warn(dev, "bad remote port parent\n");
> > +		ret = -EINVAL;
> > +		goto out_err;
> > +	}
> > +
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
> > +		dev_dbg(dev, "ignoring port@%u/endpoint@%u\n", vep->base.port,
> > +			vep->base.id);
> > +	else if (ret < 0)
> > +		dev_warn(dev,
> > +			 "driver could not parse port@%u/endpoint@%u (%d)\n",
> > +			 vep->base.port, vep->base.id, ret);
> > +	v4l2_fwnode_endpoint_free(vep);
> > +	if (ret < 0)
> > +		goto out_err;
> > +
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
> 
> You can drop the = NULL since the for-loop initializes it anyway.
> 
> > +	unsigned int max_subdevs = notifier->max_subdevs;
> > +	int ret;
> > +
> > +	if (WARN_ON(asd_struct_size < sizeof(struct v4l2_async_subdev)))
> > +		return -EINVAL;
> > +
> > +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> > +				     dev_fwnode(dev), fwnode)); ) {
> > +		struct fwnode_handle *dev_fwnode;
> > +		bool is_available;
> > +
> > +		dev_fwnode = fwnode_graph_get_port_parent(fwnode);
> > +		is_available = fwnode_device_is_available(dev_fwnode);
> > +		fwnode_handle_put(dev_fwnode);
> > +		if (!is_available)
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
> > +		struct fwnode_handle *dev_fwnode;
> > +		bool is_available;
> > +
> > +		dev_fwnode = fwnode_graph_get_port_parent(fwnode);
> > +		is_available = fwnode_device_is_available(dev_fwnode);
> > +		fwnode_handle_put(dev_fwnode);
> > +
> > +		if (!fwnode_device_is_available(dev_fwnode))
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
> > +
> > +int v4l2_async_notifier_parse_fwnode_endpoints(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	return __v4l2_async_notifier_parse_fwnode_endpoints(
> > +		dev, notifier, asd_struct_size, 0, false, parse_endpoint);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
> > +
> > +int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size, unsigned int port,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			    struct v4l2_fwnode_endpoint *vep,
> > +			    struct v4l2_async_subdev *asd))
> > +{
> > +	return __v4l2_async_notifier_parse_fwnode_endpoints(
> > +		dev, notifier, asd_struct_size, port, true, parse_endpoint);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
> > +
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
> >  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index c69d8c8a66d0..329aeebd1a80 100644
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
> > + * the driver specific struct shall contain the &struct
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
> > + * v4l2_async_notifier_cleanup - clean up notifier resources
> > + * @notifier: the notifier the resources of which are to be cleaned up
> > + *
> > + * Release memory resources related to a notifier, including the async
> > + * sub-devices allocated for the purposes of the notifier but not the notifier
> > + * itself. The user is responsible for calling this function to clean up the
> > + * notifier after calling @v4l2_async_notifier_parse_fwnode_endpoints.
> > + *
> > + * There is no harm from calling v4l2_async_notifier_cleanup in other
> > + * cases as long as its memory has been zeroed after it has been
> > + * allocated.
> > + */
> > +void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier);
> > +
> > +/**
> >   * v4l2_async_register_subdev - registers a sub-device to the asynchronous
> >   * 	subdevice framework
> >   *
> > diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > index 68eb22ba571b..add721695fbd 100644
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
> > @@ -201,4 +203,120 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
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
> > + * a notifier only once.
> > + *
> > + * Do not change the notifier's subdevs array, take references to the subdevs
> > + * array itself or change the notifier's num_subdevs field. This is because this
> > + * function allocates and reallocates the subdevs array based on parsing
> > + * endpoints.
> > + *
> > + * The &struct v4l2_fwnode_endpoint passed to the callback function
> > + * @parse_endpoint is released once the function is finished. If there is a need
> > + * to retain that configuration, the user needs to allocate memory for it.
> > + *
> > + * Any notifier populated using this function must be released with a call to
> > + * v4l2_async_notifier_cleanup() after it has been unregistered and the async
> > + * sub-devices are no longer in use, even if the function returned an error.
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
> > + * @dev: the device the endpoints of which are to be parsed
> > + * @notifier: notifier for @dev
> > + * @asd_struct_size: size of the driver's async sub-device struct, including
> > + *		     sizeof(struct v4l2_async_subdev). The &struct
> > + *		     v4l2_async_subdev shall be the first member of
> > + *		     the driver's async sub-device struct, i.e. both
> > + *		     begin at the same memory address.
> > + * @port: port number where endpoints are to be parsed
> > + * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
> > + *		    endpoint. Optional.
> > + *		    Return: %0 on success
> > + *			    %-ENOTCONN if the endpoint is to be skipped but this
> > + *				       should not be considered as an error
> > + *			    %-EINVAL if the endpoint configuration is invalid
> > + *
> > + * This function is just like v4l2_async_notifier_parse_fwnode_endpoints() with
> > + * the exception that it only parses endpoints in a given port. This is useful
> > + * on devices that have both sinks and sources: the async sub-devices connected
> > + * to sources have already been configured by another driver (on capture
> > + * devices). In this case the driver must know which ports to parse.
> > + *
> > + * Parse the fwnode endpoints of the @dev device on a given @port and populate
> > + * the async sub-devices array of the notifier. The @parse_endpoint callback
> > + * function is called for each endpoint with the corresponding async sub-device
> > + * pointer to let the caller initialize the driver-specific part of the async
> > + * sub-device structure.
> > + *
> > + * The notifier memory shall be zeroed before this function is called on the
> > + * notifier the first time.
> > + *
> > + * This function may not be called on a registered notifier and may be called on
> > + * a notifier only once per port.
> > + *
> > + * Do not change the notifier's subdevs array, take references to the subdevs
> > + * array itself or change the notifier's num_subdevs field. This is because this
> > + * function allocates and reallocates the subdevs array based on parsing
> > + * endpoints.
> > + *
> > + * The &struct v4l2_fwnode_endpoint passed to the callback function
> > + * @parse_endpoint is released once the function is finished. If there is a need
> > + * to retain that configuration, the user needs to allocate memory for it.
> > + *
> > + * Any notifier populated using this function must be released with a call to
> > + * v4l2_async_notifier_cleanup() after it has been unregistered and the async
> > + * sub-devices are no longer in use, even if the function returned an error.
> > + *
> > + * Return: %0 on success, including when no async sub-devices are found
> > + *	   %-ENOMEM if memory allocation failed
> > + *	   %-EINVAL if graph or endpoint parsing failed
> > + *	   Other error codes as returned by @parse_endpoint
> > + */
> > +int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	size_t asd_struct_size, unsigned int port,
> > +	int (*parse_endpoint)(struct device *dev,
> > +			      struct v4l2_fwnode_endpoint *vep,
> > +			      struct v4l2_async_subdev *asd));
> > +
> >  #endif /* _V4L2_FWNODE_H */
> > 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
