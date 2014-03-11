Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20818 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaCKMFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:05:36 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2900CQZTLBGC10@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 12:05:35 +0000 (GMT)
Message-id: <531EFC0A.5020505@samsung.com>
Date: Tue, 11 Mar 2014 13:05:30 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 01/48] v4l: of: Support empty port nodes
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1394493359-14115-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/03/14 00:15, Laurent Pinchart wrote:
> Empty port nodes are allowed but currently unsupported as the
> v4l2_of_get_next_endpoint() function assumes that all port nodes have at
> least an endpoint. Fix this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/v4l2-core/v4l2-of.c | 52 +++++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index 42e3e8a..4c07343 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -166,43 +166,51 @@ struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
>  					struct device_node *prev)
>  {
>  	struct device_node *endpoint;
> -	struct device_node *port = NULL;
> +	struct device_node *port;
>  
>  	if (!parent)
>  		return NULL;
>  
> +	/*
> +	 * Start by locating the port node. If no previous endpoint is specified
> +	 * search for the first port node, otherwise get the previous endpoint
> +	 * parent port node.
> +	 */
>  	if (!prev) {
>  		struct device_node *node;
> -		/*
> -		 * It's the first call, we have to find a port subnode
> -		 * within this node or within an optional 'ports' node.
> -		 */
> +
>  		node = of_get_child_by_name(parent, "ports");
>  		if (node)
>  			parent = node;
>  
>  		port = of_get_child_by_name(parent, "port");
> +		of_node_put(node);
>  
> -		if (port) {
> -			/* Found a port, get an endpoint. */
> -			endpoint = of_get_next_child(port, NULL);
> -			of_node_put(port);
> -		} else {
> -			endpoint = NULL;
> -		}
> -
> -		if (!endpoint)
> -			pr_err("%s(): no endpoint nodes specified for %s\n",
> +		if (!port) {
> +			pr_err("%s(): no port node found in %s\n",
>  			       __func__, parent->full_name);
> -		of_node_put(node);
> +			return NULL;
> +		}
>  	} else {
>  		port = of_get_parent(prev);
> -		if (!port)
> +		if (!port) {
>  			/* Hm, has someone given us the root node ?... */
>  			return NULL;
> +		}
>  
> -		/* Avoid dropping prev node refcount to 0. */
> +		/*
> +		 * Avoid dropping prev node refcount to 0 when getting the next
> +		 * child below.
> +		 */
>  		of_node_get(prev);
> +	}
> +
> +	while (1) {
> +		/*
> +		 * Now that we have a port node, get the next endpoint by
> +		 * getting the next child. If the previous endpoint is NULL this
> +		 * will return the first child.
> +		 */
>  		endpoint = of_get_next_child(port, prev);
>  		if (endpoint) {
>  			of_node_put(port);
> @@ -210,18 +218,14 @@ struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
>  		}
>  
>  		/* No more endpoints under this port, try the next one. */
> +		prev = NULL;
> +
>  		do {
>  			port = of_get_next_child(parent, port);
>  			if (!port)
>  				return NULL;
>  		} while (of_node_cmp(port->name, "port"));
> -
> -		/* Pick up the first endpoint in this port. */
> -		endpoint = of_get_next_child(port, NULL);
> -		of_node_put(port);
>  	}
> -
> -	return endpoint;
>  }
>  EXPORT_SYMBOL(v4l2_of_get_next_endpoint);
>  

-- 
Regards,
Sylwester
