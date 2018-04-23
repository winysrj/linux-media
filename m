Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:56921 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbeDWHOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 03:14:49 -0400
Date: Mon, 23 Apr 2018 10:14:45 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 05/13] media: v4l2-fwnode: Add a convenience function
 for registering subdevs with notifiers
Message-ID: <20180423071444.2rsqvlvlfvpoxpbu@paasikivi.fi.intel.com>
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
 <1521592649-7264-6-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1521592649-7264-6-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Tue, Mar 20, 2018 at 05:37:21PM -0700, Steve Longerbeam wrote:
> Adds v4l2_async_register_fwnode_subdev(), which is a convenience function
> for parsing a sub-device's fwnode port endpoints for connected remote
> sub-devices, registering a sub-device notifier, and then registering
> the sub-device itself.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
> Changes since v2:
> - fix error-out path in v4l2_async_register_fwnode_subdev() that forgot
>   to put device.
> Changes since v1:
> - add #include <media/v4l2-subdev.h> to v4l2-fwnode.h for
>   'struct v4l2_subdev' declaration.
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 101 ++++++++++++++++++++++++++++++++++
>  include/media/v4l2-fwnode.h           |  43 +++++++++++++++
>  2 files changed, 144 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 99198b9..d42024d 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -880,6 +880,107 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
>  
> +int v4l2_async_register_fwnode_subdev(
> +	struct v4l2_subdev *sd, size_t asd_struct_size,
> +	unsigned int *ports, unsigned int num_ports,
> +	int (*parse_endpoint)(struct device *dev,
> +			      struct v4l2_fwnode_endpoint *vep,
> +			      struct v4l2_async_subdev *asd))
> +{
> +	struct v4l2_async_notifier *notifier;
> +	struct device *dev = sd->dev;
> +	struct fwnode_handle *fwnode;
> +	unsigned int subdev_port;
> +	bool is_port;
> +	int ret;
> +
> +	if (WARN_ON(!dev))
> +		return -ENODEV;
> +
> +	fwnode = dev_fwnode(dev);
> +	if (!fwnode_device_is_available(fwnode))
> +		return -ENODEV;
> +
> +	is_port = (is_of_node(fwnode) &&
> +		   of_node_cmp(to_of_node(fwnode)->name, "port") == 0);

What's the intent of this and the code below? You may not parse the graph
data structure here, it should be done in the actual firmware
implementation instead.

Also, sub-devices generally do not match ports. How sub-devices generally
correspond to fwnodes is up to the device.

> +
> +	/*
> +	 * If the sub-device is a port, only parse fwnode endpoints from
> +	 * this sub-device's single port id.
> +	 */
> +	if (is_port) {
> +		/* verify the caller did not provide a ports array */
> +		if (ports)
> +			return -EINVAL;
> +
> +		ret = fwnode_property_read_u32(fwnode, "reg", &subdev_port);
> +		if (ret < 0)
> +			return ret;
> +
> +		/*
> +		 * the device given to the fwnode endpoint parsing
> +		 * must be the port sub-device's parent.
> +		 */
> +		dev = get_device(sd->dev->parent);
> +
> +		if (WARN_ON(!dev))
> +			return -ENODEV;
> +
> +		ports = &subdev_port;
> +		num_ports = 1;
> +	}
> +
> +	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
> +	if (!notifier) {
> +		ret = -ENOMEM;
> +		goto out_putdev;
> +	}
> +
> +	if (!ports) {
> +		ret = v4l2_async_notifier_parse_fwnode_endpoints(
> +			dev, notifier, asd_struct_size, parse_endpoint);
> +		if (ret < 0)
> +			goto out_cleanup;
> +	} else {
> +		unsigned int i;
> +
> +		for (i = 0; i < num_ports; i++) {
> +			ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> +				dev, notifier, asd_struct_size,
> +				ports[i], parse_endpoint);
> +			if (ret < 0)
> +				goto out_cleanup;
> +		}
> +	}
> +
> +	ret = v4l2_async_subdev_notifier_register(sd, notifier);
> +	if (ret < 0)
> +		goto out_cleanup;
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto out_unregister;
> +
> +	sd->subdev_notifier = notifier;
> +
> +	if (is_port)
> +		put_device(dev);
> +
> +	return 0;
> +
> +out_unregister:
> +	v4l2_async_notifier_unregister(notifier);
> +out_cleanup:
> +	v4l2_async_notifier_cleanup(notifier);
> +	kfree(notifier);
> +out_putdev:
> +	if (is_port)
> +		put_device(dev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_register_fwnode_subdev);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 9a4b3f8..4de0ac2 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -23,6 +23,7 @@
>  #include <linux/types.h>
>  
>  #include <media/v4l2-mediabus.h>
> +#include <media/v4l2-subdev.h>
>  
>  struct fwnode_handle;
>  struct v4l2_async_notifier;
> @@ -360,4 +361,46 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>  int v4l2_async_notifier_parse_fwnode_sensor_common(
>  	struct device *dev, struct v4l2_async_notifier *notifier);
>  
> +/**
> + * v4l2_async_register_fwnode_subdev - registers a sub-device to the
> + *					asynchronous sub-device framework
> + *					and parses fwnode endpoints
> + *
> + * @sd: pointer to struct &v4l2_subdev
> + * @asd_struct_size: size of the driver's async sub-device struct, including
> + *		     sizeof(struct v4l2_async_subdev). The &struct
> + *		     v4l2_async_subdev shall be the first member of
> + *		     the driver's async sub-device struct, i.e. both
> + *		     begin at the same memory address.
> + * @ports: array of port id's to parse for fwnode endpoints. If NULL, will
> + *	   parse all ports owned by the sub-device.
> + * @num_ports: number of ports in @ports array. Ignored if @ports is NULL.
> + * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
> + *		    endpoint. Optional.
> + *
> + * This function is just like v4l2_async_register_subdev() with the exception
> + * that calling it will also parse the sub-device's firmware node endpoints
> + * using v4l2_async_notifier_parse_fwnode_endpoints() or
> + * v4l2_async_notifier_parse_fwnode_endpoints_by_port(), and registers the
> + * async sub-devices. The sub-device is similarly unregistered by calling
> + * v4l2_async_unregister_subdev().
> + *
> + * This function will work as expected if the sub-device fwnode is
> + * itself a port. The endpoints of this single port are parsed using
> + * v4l2_async_notifier_parse_fwnode_endpoints_by_port(), passing the
> + * parent of the sub-device as the port's owner. The caller must not
> + * provide a @ports array, since the sub-device owns only this port.
> + *
> + * While registered, the subdev module is marked as in-use.
> + *
> + * An error is returned if the module is no longer loaded on any attempts
> + * to register it.
> + */
> +int v4l2_async_register_fwnode_subdev(
> +	struct v4l2_subdev *sd, size_t asd_struct_size,
> +	unsigned int *ports, unsigned int num_ports,
> +	int (*parse_endpoint)(struct device *dev,
> +			      struct v4l2_fwnode_endpoint *vep,
> +			      struct v4l2_async_subdev *asd));
> +
>  #endif /* _V4L2_FWNODE_H */
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
