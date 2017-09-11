Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:58461 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751005AbdIKJrQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:47:16 -0400
Subject: Re: [PATCH v10 19/24] v4l: fwnode: Add convenience function for
 parsing common external refs
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-20-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c57c3f6b-aeb9-dc00-645b-0da2edad77b0@xs4all.nl>
Date: Mon, 11 Sep 2017 11:47:11 +0200
MIME-Version: 1.0
In-Reply-To: <20170911080008.21208-20-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 10:00 AM, Sakari Ailus wrote:
> Add v4l2_fwnode_parse_reference_sensor_common for parsing common
> sensor properties that refer to adjacent devices such as flash or lens
> driver chips.
> 
> As this is an association only, there's little a regular driver needs to
> know about these devices as such.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 35 +++++++++++++++++++++++++++++++++++
>  include/media/v4l2-fwnode.h           | 13 +++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 56eee5bbd3b5..b9e60a0e8f86 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -589,6 +589,41 @@ static int v4l2_fwnode_reference_parse_int_props(
>  	return ret;
>  }
>  
> +int v4l2_fwnode_reference_parse_sensor_common(
> +	struct device *dev, struct v4l2_async_notifier *notifier)
> +{
> +	static const char *led_props[] = { "led" };
> +	static const struct {
> +		const char *name;
> +		const char **props;
> +		unsigned int nprops;
> +	} props[] = {
> +		{ "flash-leds", led_props, ARRAY_SIZE(led_props) },
> +		{ "lens-focus", NULL, 0 },
> +	};
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(props); i++) {
> +		int ret;
> +
> +		if (props[i].props && is_acpi_node(dev_fwnode(dev)))
> +			ret = v4l2_fwnode_reference_parse_int_props(
> +				dev, notifier, props[i].name,
> +				props[i].props, props[i].nprops);
> +		else
> +			ret = v4l2_fwnode_reference_parse(
> +				dev, notifier, props[i].name);
> +		if (ret) {
> +			dev_warn(dev, "parsing property \"%s\" failed (%d)\n",
> +				 props[i].name, ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse_sensor_common);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 3819a73c3c8a..bcec1ce101dc 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -257,4 +257,17 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>  			      struct v4l2_fwnode_endpoint *vep,
>  			      struct v4l2_async_subdev *asd));
>  
> +/**
> + * v4l2_fwnode_reference_parse_sensor_common - parse common references on
> + *					       sensors for async sub-devices
> + * @dev: the device node the properties of which are parsed for references
> + * @notifier: the async notifier where the async subdevs will be added
> + *

I think you should add a note that if this function returns 0 the
caller should remember to call v4l2_async_notifier_release. That is not
immediately obvious.

Regards,

	Hans

> + * Return: 0 on success
> + *	   -ENOMEM if memory allocation failed
> + *	   -EINVAL if property parsing failed
> + */
> +int v4l2_fwnode_reference_parse_sensor_common(
> +	struct device *dev, struct v4l2_async_notifier *notifier);
> +
>  #endif /* _V4L2_FWNODE_H */
> 
