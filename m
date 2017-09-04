Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42055 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753740AbdIDO6S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 10:58:18 -0400
Subject: Re: [PATCH v7 16/18] v4l2-fwnode: Add convenience function for
 parsing common external refs
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-17-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4900fc41-1b57-deb6-2041-26a6333f2033@xs4all.nl>
Date: Mon, 4 Sep 2017 16:58:13 +0200
MIME-Version: 1.0
In-Reply-To: <20170903174958.27058-17-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> Add v4l2_fwnode_parse_reference_sensor_common for parsing common
> sensor properties that refer to adjacent devices such as flash or lens
> driver chips.
> 
> As this is an association only, there's little a regular driver needs to
> know about these devices as such.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 27 +++++++++++++++++++++++++++
>  include/media/v4l2-fwnode.h           |  3 +++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 24f8020caf28..f28be3b751d3 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -530,6 +530,33 @@ int v4l2_fwnode_reference_parse(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse);
>  
> +int v4l2_fwnode_reference_parse_sensor_common(
> +	struct device *dev, struct v4l2_async_notifier *notifier)
> +{
> +	static const struct {
> +		char *name;
> +		char *cells;
> +		unsigned int nr_cells;
> +	} props[] = {
> +		{ "flash", NULL, 0 },
> +		{ "lens-focus", NULL, 0 },
> +	};
> +	unsigned int i;
> +	int rval;
> +
> +	for (i = 0; i < ARRAY_SIZE(props); i++) {
> +		rval = v4l2_fwnode_reference_parse(
> +			dev, notifier, props[i].name, props[i].cells,
> +			props[i].nr_cells, sizeof(struct v4l2_async_subdev),
> +			NULL);
> +		if (rval < 0 && rval != -ENOENT)
> +			return rval;
> +	}
> +
> +	return rval;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse_sensor_common);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 52f528162818..fd14f1d38966 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -282,4 +282,7 @@ int v4l2_fwnode_reference_parse(
>  			    struct fwnode_reference_args *args,
>  			    struct v4l2_async_subdev *asd));
>  
> +int v4l2_fwnode_reference_parse_sensor_common(
> +	struct device *dev, struct v4l2_async_notifier *notifier);
> +
>  #endif /* _V4L2_FWNODE_H */
> 
