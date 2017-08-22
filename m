Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51673 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932720AbdHVMwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:52:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/3] v4l: fwnode: Support generic parsing of graph endpoints in a device
Date: Tue, 22 Aug 2017 15:52:33 +0300
Message-ID: <2804301.TqBigdGaBJ@avalon>
In-Reply-To: <20170818112317.30933-3-sakari.ailus@linux.intel.com>
References: <20170818112317.30933-1-sakari.ailus@linux.intel.com> <20170818112317.30933-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 18 August 2017 14:23:16 EEST Sakari Ailus wrote:
> The current practice is that drivers iterate over their endpoints and
> parse each endpoint separately. This is very similar in a number of
> drivers, implement a generic function for the job. Driver specific matters
> can be taken into account in the driver specific callback.
> 
> Convert the omap3isp as an example.

It would be nice to convert at least two drivers to show that the code can 
indeed be shared between multiple drivers. Even better, you could convert all 
drivers.
 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> drivers/media/platform/omap3isp/isp.c | 116 ++++++++++---------------------
> drivers/media/v4l2-core/v4l2-fwnode.c | 125 ++++++++++++++++++++++++++++++++
> include/media/v4l2-async.h            |   4 +-
> include/media/v4l2-fwnode.h           |   9 +++
> 4 files changed, 173 insertions(+), 81 deletions(-)

[snip]

> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c
> b/drivers/media/v4l2-core/v4l2-fwnode.c index 5cd2687310fe..cb0fc4b4e3bf
> 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -26,6 +26,7 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
> 
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
> 
>  enum v4l2_fwnode_bus_type {
> @@ -383,6 +384,130 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link
> *link) }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
> 
> +static int notifier_realloc(struct device *dev,
> +			    struct v4l2_async_notifier *notifier,
> +			    unsigned int max_subdevs)

It looks like you interpret the variable as an increment. You shouldn't call 
it max_subdevs in that case. I would however keep the name and pass the total 
number of subdevs instead of an increment, to mimic the realloc API.

> +{
> +	struct v4l2_async_subdev **subdevs;
> +	unsigned int i;
> +
> +	if (max_subdevs + notifier->num_subdevs <= notifier->max_subdevs)
> +		return 0;
> +
> +	subdevs = devm_kcalloc(
> +		dev, max_subdevs + notifier->num_subdevs,
> +		sizeof(*notifier->subdevs), GFP_KERNEL);

We know that we'll have to move away from devm_* allocation to fix object 
lifetime management, so we could as well start now.

> +	if (!subdevs)
> +		return -ENOMEM;
> +
> +	if (notifier->subdevs) {
> +		for (i = 0; i < notifier->num_subdevs; i++)
> +			subdevs[i] = notifier->subdevs[i];

Is there a reason to use a loop here instead of a memcpy() covering the whole 
array ?

> +		devm_kfree(dev, notifier->subdevs);
> +	}
> +
> +	notifier->subdevs = subdevs;
> +	notifier->max_subdevs = max_subdevs + notifier->num_subdevs;
> +
> +	return 0;
> +}
> +
> +static int __v4l2_fwnode_endpoint_parse(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	struct fwnode_handle *endpoint, struct v4l2_async_subdev *asd,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd))
> +{
> +	struct v4l2_fwnode_endpoint *vep;
> +	int ret;
> +
> +	/* Ignore endpoints the parsing of which failed. */

Silently ignoring invalid DT sounds bad, I'd rather catch errors and return 
with an error code to make sure that DT gets fixed.

> +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> +	if (IS_ERR(vep))
> +		return 0;
> +
> +	notifier->subdevs[notifier->num_subdevs] = asd;
> +
> +	ret = parse_single(dev, vep, asd);
> +	v4l2_fwnode_endpoint_free(vep);
> +	if (ret)
> +		return ret;
> +
> +	asd->match.fwnode.fwnode =
> +		fwnode_graph_get_remote_port_parent(endpoint);
> +	if (!asd->match.fwnode.fwnode) {
> +		dev_warn(dev, "bad remote port parent\n");
> +		return -EINVAL;
> +	}
> +
> +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> +	notifier->num_subdevs++;
> +
> +	return 0;
> +}
> +
> +/**
> + * v4l2_fwnode_endpoint_parse - Parse V4L2 fwnode endpoints in a device
> node

This doesn't match the function name.

> + * @dev: local struct device

Based on the documentation only and without a priori knowledge of the API, 
local struct device is very vague.

> + * @notifier: async notifier related to @dev

Ditto. You need more documentation, especially given that this is the first 
function in the core that fills a notifier from DT. You might also want to 
reflect that fact in the function name.

> + * @asd_struct_size: size of the driver's async sub-device struct,
> including
> + *		     sizeof(struct v4l2_async_subdev)
> + * @parse_single: driver's callback function called on each V4L2 fwnode
> endpoint

The parse_single return values should be documented.

> + * Parse all V4L2 fwnode endpoints related to the device.
> + *
> + * Note that this function is intended for drivers to replace the existing
> + * implementation that loops over all ports and endpoints. It is NOT
> INTENDED TO
> + * BE USED BY NEW DRIVERS.

You should document what the preferred way is. And I'd much rather convert 
drivers to the preferred way instead of adding a helper function that is 
already deprecated.

> + */
> +int v4l2_fwnode_endpoints_parse(

v4l2_fwnode_parse_endpoints() would sound more natural.

> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd))
> +{
> +	struct fwnode_handle *fwnode = NULL;
> +	unsigned int max_subdevs = notifier->max_subdevs;
> +	int ret;
> +
> +	if (asd_struct_size < sizeof(struct v4l2_async_subdev))
> +		return -EINVAL;
> +
> +	while ((fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev),
> +							fwnode)))
> +		max_subdevs++;
> +
> +	ret = notifier_realloc(dev, notifier, max_subdevs);
> +	if (ret)
> +		return ret;
> +
> +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> +				     dev_fwnode(dev), fwnode)) &&
> +		     !WARN_ON(notifier->num_subdevs >= notifier->max_subdevs);

It's nice to warn that the kernel will crash, but it would be even nicer to 
prevent the crash by returning an error instead of continuing parsing 
endpoints :-)

> +		) {
> +		struct v4l2_async_subdev *asd;
> +
> +		asd = devm_kzalloc(dev, asd_struct_size, GFP_KERNEL);
> +		if (!asd) {
> +			ret = -ENOMEM;
> +			goto error;
> +		}
> +
> +		ret = __v4l2_fwnode_endpoint_parse(dev, notifier, fwnode, asd,
> +						   parse_single);
> +		if (ret < 0)
> +			goto error;
> +	}
> +
> +error:
> +	fwnode_handle_put(fwnode);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoints_parse);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index c69d8c8a66d0..067f3687774b 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -78,7 +78,8 @@ struct v4l2_async_subdev {
>  /**
>   * struct v4l2_async_notifier - v4l2_device notifier data
>   *
> - * @num_subdevs: number of subdevices
> + * @num_subdevs: number of subdevices used in subdevs array
> + * @max_subdevs: number of subdevices allocated in subdevs array
>   * @subdevs:	array of pointers to subdevice descriptors
>   * @v4l2_dev:	pointer to struct v4l2_device
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> @@ -90,6 +91,7 @@ struct v4l2_async_subdev {
>   */
>  struct v4l2_async_notifier {
>  	unsigned int num_subdevs;
> +	unsigned int max_subdevs;
>  	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
>  	struct list_head waiting;
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index cb34dcb0bb65..c75a768d4ef7 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -25,6 +25,8 @@
>  #include <media/v4l2-mediabus.h>
> 
>  struct fwnode_handle;
> +struct v4l2_async_notifier;
> +struct v4l2_async_subdev;
> 
>  #define MAX_DATA_LANES	4
> 
> @@ -122,4 +124,11 @@ int v4l2_fwnode_parse_link(struct fwnode_handle
> *fwnode, struct v4l2_fwnode_link *link);
>  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> 
> +int v4l2_fwnode_endpoints_parse(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd));
> +
>  #endif /* _V4L2_FWNODE_H */


-- 
Regards,

Laurent Pinchart
