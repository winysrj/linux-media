Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:48106 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751031AbdIMH55 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 03:57:57 -0400
Subject: Re: [PATCH v12 19/26] v4l: fwnode: Add a helper function to obtain
 device / interger references
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
 <20170912134200.19556-20-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f92245da-0823-c95e-2208-b038f1bbb869@xs4all.nl>
Date: Wed, 13 Sep 2017 09:57:52 +0200
MIME-Version: 1.0
In-Reply-To: <20170912134200.19556-20-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The subject still has the 'interger' typo.

On 09/12/2017 03:41 PM, Sakari Ailus wrote:
> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> the device's own fwnode, it will follow child fwnodes with the given
> property -- value pair and return the resulting fwnode.

As suggested before: 'property-value' is easier to read than ' -- '.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 145 ++++++++++++++++++++++++++++++++++
>  1 file changed, 145 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index a32473f95be1..a07599a8f647 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -567,6 +567,151 @@ static int v4l2_fwnode_reference_parse(
>  	return ret;
>  }
>  
> +/*
> + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
> + *					arguments
> + * @dev: struct device pointer
> + * @notifier: notifier for @dev
> + * @prop: the name of the property

@index is not documented.

> + * @props: the array of integer property names
> + * @nprops: the number of integer properties

properties -> property names in @props

> + *
> + * Find fwnodes referred to by a property @prop, then under that iteratively
> + * follow each child node which has a property the value matches the integer

"the value" -> "whose value" or "with a value that"

At least, I think that's what you mean here.

How is @props/@nprops used?

> + * argument at an index.

I assume this should be "the @index"?

> + *
> + * Return: 0 on success
> + *	   -ENOENT if no entries (or the property itself) were found
> + *	   -EINVAL if property parsing otherwisefailed

Missing space before "failed"

> + *	   -ENOMEM if memory allocation failed
> + */
> +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
> +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
> +	const char **props, unsigned int nprops)
> +{
> +	struct fwnode_reference_args fwnode_args;
> +	unsigned int *args = fwnode_args.args;
> +	struct fwnode_handle *child;
> +	int ret;
> +
> +	/*
> +	 * Obtain remote fwnode as well as the integer arguments.
> +	 *
> +	 * To-do: handle -ENODATA when "device property: Align return
> +	 * codes of acpi_fwnode_get_reference_with_args" is merged.
> +	 */
> +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
> +						 index, &fwnode_args);
> +	if (ret)
> +		return ERR_PTR(ret == -ENODATA ? -ENOENT : ret);
> +
> +	/*
> +	 * Find a node in the tree under the referred fwnode corresponding the

the -> to the

> +	 * integer arguments.
> +	 */
> +	fwnode = fwnode_args.fwnode;
> +	while (nprops) {

This can be 'while (nprops--) {'.

> +		u32 val;
> +
> +		/* Loop over all child nodes under fwnode. */
> +		fwnode_for_each_child_node(fwnode, child) {
> +			if (fwnode_property_read_u32(child, *props, &val))
> +				continue;
> +
> +			/* Found property, see if its value matches. */
> +			if (val == *args)
> +				break;
> +		}
> +
> +		fwnode_handle_put(fwnode);
> +
> +		/* No property found; return an error here. */
> +		if (!child) {
> +			fwnode = ERR_PTR(-ENOENT);
> +			break;
> +		}
> +
> +		props++;
> +		args++;
> +		fwnode = child;
> +		nprops--;
> +	}
> +
> +	return fwnode;
> +}

You really need to add an ACPI example as comment for this source code.

I still don't understand the code. I know you pointed me to an example,
but I can't remember/find what it was. Either copy the example here or
point to the file containing the example (copying is best IMHO).

Regards,

	Hans

> +
> +/*
> + * v4l2_fwnode_reference_parse_int_props - parse references for async sub-devices
> + * @dev: struct device pointer
> + * @notifier: notifier for @dev
> + * @prop: the name of the property
> + * @props: the array of integer property names
> + * @nprops: the number of integer properties
> + *
> + * Use v4l2_fwnode_reference_get_int_prop to find fwnodes through reference in
> + * property @prop with integer arguments with child nodes matching in properties
> + * @props. Then, set up V4L2 async sub-devices for those fwnodes in the notifier
> + * accordingly.
> + *
> + * While it is technically possible to use this function on DT, it is only
> + * meaningful on ACPI. On Device tree you can refer to any node in the tree but
> + * on ACPI the references are limited to devices.
> + *
> + * Return: 0 on success
> + *	   -ENOENT if no entries (or the property itself) were found
> + *	   -EINVAL if property parsing otherwisefailed
> + *	   -ENOMEM if memory allocation failed
> + */
> +static int v4l2_fwnode_reference_parse_int_props(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	const char *prop, const char **props, unsigned int nprops)
> +{
> +	struct fwnode_handle *fwnode;
> +	unsigned int index;
> +	int ret;
> +
> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> +					 dev_fwnode(dev), prop, index, props,
> +					 nprops))); index++)
> +		fwnode_handle_put(fwnode);
> +
> +	if (PTR_ERR(fwnode) != -ENOENT)
> +		return PTR_ERR(fwnode);
> +
> +	ret = v4l2_async_notifier_realloc(notifier,
> +					  notifier->num_subdevs + index);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> +					 dev_fwnode(dev), prop, index, props,
> +					 nprops))); index++) {
> +		struct v4l2_async_subdev *asd;
> +
> +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
> +			ret = -EINVAL;
> +			goto error;
> +		}
> +
> +		asd = kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
> +		if (!asd) {
> +			ret = -ENOMEM;
> +			goto error;
> +		}
> +
> +		notifier->subdevs[notifier->num_subdevs] = asd;
> +		asd->match.fwnode.fwnode = fwnode;
> +		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		notifier->num_subdevs++;
> +	}
> +
> +	return PTR_ERR(fwnode) == -ENOENT ? 0 : PTR_ERR(fwnode);
> +
> +error:
> +	fwnode_handle_put(fwnode);
> +	return ret;
> +}
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> 
