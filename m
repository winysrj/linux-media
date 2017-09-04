Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:59470 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753746AbdIDOox (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 10:44:53 -0400
Subject: Re: [PATCH v7 15/18] v4l2-fwnode: Add convenience function for
 parsing generic references
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-16-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0bb75f81-cc81-a4bf-f2af-41862c1d777a@xs4all.nl>
Date: Mon, 4 Sep 2017 16:44:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170903174958.27058-16-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> Add function v4l2_fwnode_reference_count() for counting external
> references and v4l2_fwnode_reference_parse() for parsing them as async
> sub-devices.
> 
> This can be done on e.g. flash or lens async sub-devices that are not part
> of but are associated with a sensor.
> 
> struct v4l2_async_notifier.max_subdevs field is added to contain the
> maximum number of sub-devices in a notifier to reflect the memory
> allocated for the subdevs array.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 81 +++++++++++++++++++++++++++++++++++
>  include/media/v4l2-fwnode.h           | 28 ++++++++++++
>  2 files changed, 109 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index f8c7a9bc6a58..24f8020caf28 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -449,6 +449,87 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
>  
> +static void v4l2_fwnode_print_args(struct fwnode_reference_args *args)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < args->nargs; i++) {
> +		pr_cont(" %u", args->args[i]);
> +		if (i + 1 < args->nargs)
> +			pr_cont(",");
> +	}
> +}
> +
> +int v4l2_fwnode_reference_parse(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	const char *prop, const char *nargs_prop, unsigned int nargs,
> +	size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct fwnode_reference_args *args,
> +			    struct v4l2_async_subdev *asd))
> +{
> +	struct fwnode_reference_args args;
> +	unsigned int index = 0;
> +	int ret = -ENOENT;
> +
> +	if (asd_struct_size < sizeof(struct v4l2_async_subdev))
> +		return -EINVAL;
> +
> +	for (; !fwnode_property_get_reference_args(
> +		     dev_fwnode(dev), prop, nargs_prop, nargs,
> +		     index, &args); index++)
> +		fwnode_handle_put(args.fwnode);
> +
> +	ret = v4l2_async_notifier_realloc(notifier,
> +					  notifier->num_subdevs + index);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	for (ret = -ENOENT, index = 0; !fwnode_property_get_reference_args(
> +		     dev_fwnode(dev), prop, nargs_prop, nargs,
> +		     index, &args); index++) {
> +		struct v4l2_async_subdev *asd;
> +
> +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs))
> +			break;

As mentioned elsewhere: I think this should return an error.

> +
> +		asd = kzalloc(asd_struct_size, GFP_KERNEL);
> +		if (!asd) {
> +			ret = -ENOMEM;
> +			goto error;
> +		}
> +
> +		ret = parse_single ? parse_single(dev, &args, asd) : 0;
> +		if (ret == -ENOTCONN) {
> +			dev_dbg(dev,
> +				"ignoring reference prop \"%s\", nargs_prop \"%s\", nargs %u, index %u",
> +				prop, nargs_prop, nargs, index);
> +			v4l2_fwnode_print_args(&args);
> +			pr_cont("\n");

asd isn't freed.

> +			continue;
> +		} else if (ret < 0) {
> +			dev_warn(dev,
> +				 "driver could not parse reference prop \"%s\", nargs_prop \"%s\", nargs %u, index %u",
> +				 prop, nargs_prop, nargs, index);
> +			v4l2_fwnode_print_args(&args);
> +			pr_cont("\n");

Ditto.

> +			goto error;
> +		}
> +
> +		notifier->subdevs[notifier->num_subdevs] = asd;
> +		asd->match.fwnode.fwnode = args.fwnode;
> +		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		notifier->num_subdevs++;
> +	}
> +
> +	return 0;
> +
> +error:
> +	fwnode_handle_put(args.fwnode);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 6d125f26ec84..52f528162818 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -254,4 +254,32 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>  			      struct v4l2_fwnode_endpoint *vep,
>  			      struct v4l2_async_subdev *asd));
>  
> +/**
> + * v4l2_fwnode_reference_parse - parse references for async sub-devices
> + * @dev: the device node the properties of which are parsed for references

the device node whose properties are...

> + * @notifier: the async notifier where the async subdevs will be added
> + * @prop: the name of the property
> + * @nargs_prop: the name of the property in the remote node that specifies the
> + *		number of integer arguments (may be NULL, in that case nargs
> + *		will be used).
> + * @nargs: the number of integer arguments after the reference
> + * @asd_struct_size: the size of the driver's async sub-device struct, including
> + *		     @struct v4l2_async_subdev
> + * @parse_single: Driver's callback function for parsing a reference. Optional.

Driver's -> driver's

> + *		  Return: 0 on success
> + *			  %-ENOTCONN if the reference is to be skipped but this
> + *				     should not be considered as an error

skipped but this -> skipped. This

> + *
> + * Return: 0 on success
> + *	   -ENOMEM if memory allocation failed
> + *	   -EINVAL if property parsing failed
> + */
> +int v4l2_fwnode_reference_parse(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	const char *prop, const char *nargs_prop, unsigned int nargs,
> +	size_t asd_struct_size,
> +	int (*parse_single)(struct device *dev,
> +			    struct fwnode_reference_args *args,
> +			    struct v4l2_async_subdev *asd));
> +
>  #endif /* _V4L2_FWNODE_H */
> 

Regards,

	Hans
