Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47790 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751071AbdIKJOI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:14:08 -0400
Subject: Re: [PATCH v10 17/24] v4l: fwnode: Add a helper function for parsing
 generic references
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-18-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e71bb2d0-d68d-0c9a-4234-482a2898a5fb@xs4all.nl>
Date: Mon, 11 Sep 2017 11:14:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170911080008.21208-18-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 10:00 AM, Sakari Ailus wrote:
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

This paragraph appears to be out-of-date.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 47 +++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index d978f2d714ca..4821c4989119 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -449,6 +449,53 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
>  
> +static int v4l2_fwnode_reference_parse(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	const char *prop)
> +{
> +	struct fwnode_reference_args args;
> +	unsigned int index = 0;
> +	int ret;
> +
> +	for (; !fwnode_property_get_reference_args(
> +		     dev_fwnode(dev), prop, NULL, 0, index, &args); index++)
> +		fwnode_handle_put(args.fwnode);
> +

If nothing is found (i.e. index == 0), shouldn't you just return here?

> +	ret = v4l2_async_notifier_realloc(notifier,
> +					  notifier->num_subdevs + index);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	for (ret = -ENOENT, index = 0;

There is no reason for the 'ret = -ENOENT' to be in the for(), just set it before
the 'for' statement.

> +	     !fwnode_property_get_reference_args(
> +		     dev_fwnode(dev), prop, NULL, 0, index, &args);
> +	     index++) {
> +		struct v4l2_async_subdev *asd;
> +
> +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
> +			ret = -EINVAL;
> +			goto error;
> +		}
> +
> +		asd = kzalloc(sizeof(*asd), GFP_KERNEL);
> +		if (!asd) {
> +			ret = -ENOMEM;
> +			goto error;
> +		}
> +
> +		notifier->subdevs[notifier->num_subdevs] = asd;
> +		asd->match.fwnode.fwnode = args.fwnode;
> +		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		notifier->num_subdevs++;
> +	}

If the loop doesn't find anything, then it still returns 0, not -ENOENT.
So why set ret to ENOENT? Something weird going on here.

I think you should also add a comment explaining this function.

> +
> +	return 0;
> +
> +error:
> +	fwnode_handle_put(args.fwnode);
> +	return ret;
> +}
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> 

Regards,

	Hans
