Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40412 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754516AbdKANb0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 09:31:26 -0400
Date: Wed, 1 Nov 2017 15:31:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: v4l2-fwnode: use a typedef for a function callback
Message-ID: <20171101133123.aa2qmqjq743d56fj@valkosipuli.retiisi.org.uk>
References: <e7c1eccf22beb14262e34f47d1867dde93676a58.1509542559.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7c1eccf22beb14262e34f47d1867dde93676a58.1509542559.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

There's btw. something unexpected in the To header that mutt doesn't handle
well; the end result is that the mail, by default, will be addressed to the
sender (you) only. That has likely been the reason why the list (as well as
other recipients) have been occasionally dropped.

Please see my comments below.

On Wed, Nov 01, 2017 at 09:22:50AM -0400, Mauro Carvalho Chehab wrote:
> That allows having a kernel-doc markup for the function
> prototype. It also prevents the need of describing the
> return values twice.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-fwnode.h | 37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index ca50108dfd8f..9b04692e4fde 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -203,6 +203,27 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
>   */
>  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
>  
> +
> +/**
> + * typedef parse_endpoint_fnc - Driver's callback function to be called on
> + *	each V4L2 fwnode endpoint.
> + *
> + * @dev: pointer to &struct device
> + * @vep: pointer to &struct v4l2_fwnode_endpoint
> + * @asd: pointer to &struct v4l2_async_subdev
> + *
> + * Return:
> + * * %0 on success
> + * * %-ENOTCONN if the endpoint is to be skipped but this
> + *   should not be considered as an error
> + * * %-EINVAL if the endpoint configuration is invalid
> + */
> +
> +typedef	int (*parse_endpoint_fnc)(struct device *dev,
> +			        struct v4l2_fwnode_endpoint *vep,
> +			        struct v4l2_async_subdev *asd);
> +
> +

Extra newline. I'd call the typedef parse_endpoint_func; dropping the "u"
doesn't really shorten it much, just makes it look odd IMO.

With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>  /**
>   * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints in a
>   *						device node
> @@ -215,10 +236,6 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
>   *		     begin at the same memory address.
>   * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
>   *		    endpoint. Optional.
> - *		    Return: %0 on success
> - *			    %-ENOTCONN if the endpoint is to be skipped but this
> - *				       should not be considered as an error
> - *			    %-EINVAL if the endpoint configuration is invalid
>   *
>   * Parse the fwnode endpoints of the @dev device and populate the async sub-
>   * devices array of the notifier. The @parse_endpoint callback function is
> @@ -253,9 +270,7 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
>  int v4l2_async_notifier_parse_fwnode_endpoints(
>  	struct device *dev, struct v4l2_async_notifier *notifier,
>  	size_t asd_struct_size,
> -	int (*parse_endpoint)(struct device *dev,
> -			      struct v4l2_fwnode_endpoint *vep,
> -			      struct v4l2_async_subdev *asd));
> +	parse_endpoint_fnc parse_endpoint);
>  
>  /**
>   * v4l2_async_notifier_parse_fwnode_endpoints_by_port - Parse V4L2 fwnode
> @@ -271,10 +286,6 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>   * @port: port number where endpoints are to be parsed
>   * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
>   *		    endpoint. Optional.
> - *		    Return: %0 on success
> - *			    %-ENOTCONN if the endpoint is to be skipped but this
> - *				       should not be considered as an error
> - *			    %-EINVAL if the endpoint configuration is invalid
>   *
>   * This function is just like v4l2_async_notifier_parse_fwnode_endpoints() with
>   * the exception that it only parses endpoints in a given port. This is useful
> @@ -315,9 +326,7 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
>  int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>  	struct device *dev, struct v4l2_async_notifier *notifier,
>  	size_t asd_struct_size, unsigned int port,
> -	int (*parse_endpoint)(struct device *dev,
> -			      struct v4l2_fwnode_endpoint *vep,
> -			      struct v4l2_async_subdev *asd));
> +	parse_endpoint_fnc parse_endpoint);
>  
>  /**
>   * v4l2_fwnode_reference_parse_sensor_common - parse common references on
> -- 
> 2.13.6
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
