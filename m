Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55412 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbeJEPEI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 11:04:08 -0400
Date: Fri, 5 Oct 2018 11:01:18 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 2/3] media: v4l2-fwnode: cleanup functions that parse
 endpoints
Message-ID: <20181005080118.dvw5m7z2xgruu476@paasikivi.fi.intel.com>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
 <19c5acc2b8c64b37005a6934f6f54b32cf93c0dc.1538690587.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19c5acc2b8c64b37005a6934f6f54b32cf93c0dc.1538690587.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Feel free to ignore the comments on the first patch regarding the functions
below. There are other issues there though.

On Thu, Oct 04, 2018 at 06:13:47PM -0400, Mauro Carvalho Chehab wrote:
> There is already a typedef for the parse endpoint function.
> However, instead of using it, it is redefined at the C file
> (and on one of the function headers).
> 
> Replace them by the function typedef, in order to cleanup
> several related coding style warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 64 ++++++++++++---------------
>  include/media/v4l2-fwnode.h           | 19 ++++----
>  2 files changed, 37 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 4e518d5fddd8..a7c2487154a4 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -596,12 +596,10 @@ EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
>  
>  static int
>  v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
> -		struct v4l2_async_notifier *notifier,
> -		struct fwnode_handle *endpoint,
> -		unsigned int asd_struct_size,
> -		int (*parse_endpoint)(struct device *dev,
> -				      struct v4l2_fwnode_endpoint *vep,
> -				      struct v4l2_async_subdev *asd))
> +					  struct v4l2_async_notifier *notifier,
> +					  struct fwnode_handle *endpoint,
> +					  unsigned int asd_struct_size,
> +					  parse_endpoint_func parse_endpoint)
>  {
>  	struct v4l2_fwnode_endpoint vep = { .bus_type = 0 };
>  	struct v4l2_async_subdev *asd;
> @@ -657,13 +655,12 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
>  }
>  
>  static int
> -__v4l2_async_notifier_parse_fwnode_endpoints(struct device *dev,
> -			struct v4l2_async_notifier *notifier,
> -			size_t asd_struct_size,
> -			unsigned int port, bool has_port,
> -			int (*parse_endpoint)(struct device *dev,
> -					      struct v4l2_fwnode_endpoint *vep,
> -					      struct v4l2_async_subdev *asd))
> +__v4l2_async_notifier_parse_fwnode_ep(struct device *dev,
> +				      struct v4l2_async_notifier *notifier,
> +				      size_t asd_struct_size,
> +				      unsigned int port,
> +				      bool has_port,
> +				      parse_endpoint_func parse_endpoint)
>  {
>  	struct fwnode_handle *fwnode;
>  	int ret = 0;
> @@ -708,31 +705,27 @@ __v4l2_async_notifier_parse_fwnode_endpoints(struct device *dev,
>  
>  int
>  v4l2_async_notifier_parse_fwnode_endpoints(struct device *dev,
> -		struct v4l2_async_notifier *notifier,
> -		size_t asd_struct_size,
> -		int (*parse_endpoint)(struct device *dev,
> -				      struct v4l2_fwnode_endpoint *vep,
> -				      struct v4l2_async_subdev *asd))
> +					   struct v4l2_async_notifier *notifier,
> +					   size_t asd_struct_size,
> +					   parse_endpoint_func parse_endpoint)
>  {
> -	return __v4l2_async_notifier_parse_fwnode_endpoints(dev, notifier,
> -							    asd_struct_size, 0,
> -							    false,
> -							    parse_endpoint);
> +	return __v4l2_async_notifier_parse_fwnode_ep(dev, notifier,
> +						     asd_struct_size, 0,
> +						     false, parse_endpoint);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints);
>  
>  int
>  v4l2_async_notifier_parse_fwnode_endpoints_by_port(struct device *dev,
> -			struct v4l2_async_notifier *notifier,
> -			size_t asd_struct_size, unsigned int port,
> -			int (*parse_endpoint)(struct device *dev,
> -					      struct v4l2_fwnode_endpoint *vep,
> -					      struct v4l2_async_subdev *asd))
> +						   struct v4l2_async_notifier *notifier,
> +						   size_t asd_struct_size,
> +						   unsigned int port,
> +						   parse_endpoint_func parse_endpoint)

This is still over 80 here. I think we could think of abbreviating what's
in the function name, not limiting to the endpoint. I think I'd prefer to
leave that for 4.21 as there's not much time anymore.

>  {
> -	return __v4l2_async_notifier_parse_fwnode_endpoints(dev, notifier,
> -							    asd_struct_size,
> -							    port, true,
> -							    parse_endpoint);
> +	return __v4l2_async_notifier_parse_fwnode_ep(dev, notifier,
> +						     asd_struct_size,
> +						     port, true,
> +						     parse_endpoint);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
>  
> @@ -1176,11 +1169,10 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
>  EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
>  
>  int v4l2_async_register_fwnode_subdev(struct v4l2_subdev *sd,
> -			size_t asd_struct_size,
> -			unsigned int *ports, unsigned int num_ports,
> -			int (*parse_endpoint)(struct device *dev,
> -					      struct v4l2_fwnode_endpoint *vep,
> -					      struct v4l2_async_subdev *asd))
> +				      size_t asd_struct_size,
> +				      unsigned int *ports,
> +				      unsigned int num_ports,
> +				      parse_endpoint_func parse_endpoint)
>  {
>  	struct v4l2_async_notifier *notifier;
>  	struct device *dev = sd->dev;
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 21b3f9e5c269..6d9d9f1839ac 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -346,9 +346,10 @@ v4l2_async_notifier_parse_fwnode_endpoints(struct device *dev,
>   */
>  int
>  v4l2_async_notifier_parse_fwnode_endpoints_by_port(struct device *dev,
> -				struct v4l2_async_notifier *notifier,
> -				size_t asd_struct_size, unsigned int port,
> -				parse_endpoint_func parse_endpoint);
> +						   struct v4l2_async_notifier *notifier,
> +						   size_t asd_struct_size,
> +						   unsigned int port,
> +						   parse_endpoint_func parse_endpoint);
>  
>  /**
>   * v4l2_fwnode_reference_parse_sensor_common - parse common references on
> @@ -369,7 +370,7 @@ v4l2_async_notifier_parse_fwnode_endpoints_by_port(struct device *dev,
>   *	   -EINVAL if property parsing failed
>   */
>  int v4l2_async_notifier_parse_fwnode_sensor_common(struct device *dev,
> -					struct v4l2_async_notifier *notifier);
> +						   struct v4l2_async_notifier *notifier);
>  
>  /**
>   * v4l2_async_register_fwnode_subdev - registers a sub-device to the
> @@ -403,11 +404,9 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(struct device *dev,
>   */
>  int
>  v4l2_async_register_fwnode_subdev(struct v4l2_subdev *sd,
> -			size_t asd_struct_size,
> -			unsigned int *ports,
> -			unsigned int num_ports,
> -			int (*parse_endpoint)(struct device *dev,
> -					      struct v4l2_fwnode_endpoint *vep,
> -					      struct v4l2_async_subdev *asd));
> +				  size_t asd_struct_size,
> +				  unsigned int *ports,
> +				  unsigned int num_ports,
> +				  parse_endpoint_func parse_endpoint);
>  
>  #endif /* _V4L2_FWNODE_H */

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
