Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:40535 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751459AbdIKJjD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:39:03 -0400
Subject: Re: [PATCH v10 18/24] v4l: fwnode: Add a helper function to obtain
 device / interger references
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-19-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <11c951eb-0315-0149-829e-ed73d748e783@xs4all.nl>
Date: Mon, 11 Sep 2017 11:38:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170911080008.21208-19-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Typo in subject: interger -> integer

On 09/11/2017 10:00 AM, Sakari Ailus wrote:
> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> the device's own fwnode, 

Sorry, you lost me here. Which device are we talking about?

> it will follow child fwnodes with the given
> property -- value pair and return the resulting fwnode.

property-value pair (easier readable that way).

You only describe v4l2_fwnode_reference_parse_int_prop(), not
v4l2_fwnode_reference_parse_int_props().

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 93 +++++++++++++++++++++++++++++++++++
>  1 file changed, 93 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 4821c4989119..56eee5bbd3b5 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -496,6 +496,99 @@ static int v4l2_fwnode_reference_parse(
>  	return ret;
>  }
>  
> +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
> +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
> +	const char **props, unsigned int nprops)

Need comments describing what this does.

> +{
> +	struct fwnode_reference_args fwnode_args;
> +	unsigned int *args = fwnode_args.args;
> +	struct fwnode_handle *child;
> +	int ret;
> +
> +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
> +						 index, &fwnode_args);
> +	if (ret)
> +		return ERR_PTR(ret == -EINVAL ? -ENOENT : ret);

Why map EINVAL to ENOENT? Needs a comment, either here or in the function description.

> +
> +	for (fwnode = fwnode_args.fwnode;
> +	     nprops; nprops--, fwnode = child, props++, args++) {

I think you cram too much in this for-loop: fwnode, nprops, fwnode, props, args...
It's hard to parse.

I would make this a 'while (nprops)' and write out all the other assignments,
increments and decrements.

> +		u32 val;
> +
> +		fwnode_for_each_child_node(fwnode, child) {
> +			if (fwnode_property_read_u32(child, *props, &val))
> +				continue;
> +
> +			if (val == *args)
> +				break;

I'm lost. This really needs comments and perhaps even an DT or ACPI example
so you can see what exactly it is we're doing here.

> +		}
> +
> +		fwnode_handle_put(fwnode);
> +
> +		if (!child) {
> +			fwnode = ERR_PTR(-ENOENT);
> +			break;
> +		}
> +	}
> +
> +	return fwnode;
> +}
> +
> +static int v4l2_fwnode_reference_parse_int_props(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	const char *prop, const char **props, unsigned int nprops)

Needs comments describing what this does.

> +{
> +	struct fwnode_handle *fwnode;
> +	unsigned int index = 0;
> +	int ret;
> +
> +	while (!IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> +				dev_fwnode(dev), prop, index, props,
> +				nprops)))) {
> +		fwnode_handle_put(fwnode);
> +		index++;
> +	}
> +
> +	if (PTR_ERR(fwnode) != -ENOENT)
> +		return PTR_ERR(fwnode);

Missing 'if (index == 0)'?

> +
> +	ret = v4l2_async_notifier_realloc(notifier,
> +					  notifier->num_subdevs + index);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> +					 dev_fwnode(dev), prop, index, props,
> +					 nprops))); ) {

I'd add 'index++' in this for-loop. It's weird that it is missing.

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
> +
> +		fwnode_handle_put(fwnode);
> +
> +		index++;
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

Regards,

	Hans
