Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28209 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753808AbdHUNaX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 09:30:23 -0400
Subject: Re: [PATCH] device property: preserve usecount for node passed to
 of_fwnode_graph_get_port_parent()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
References: <20170821125107.20746-1-niklas.soderlund+renesas@ragnatech.se>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <282c50da-8927-d1fc-27e5-39b75f3ba564@linux.intel.com>
Date: Mon, 21 Aug 2017 16:30:17 +0300
MIME-Version: 1.0
In-Reply-To: <20170821125107.20746-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Niklas Söderlund wrote:
> Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
> node being passed to of_fwnode_graph_get_port_parent(). Preserve the
> usecount just like it is done in of_graph_get_port_parent().

The of_fwnode_graph_get_port_parent() is called by 
fwnode_graph_get_port_parent() which obtains the port node through 
fwnode_get_parent(). If you take a reference here, calling 
fwnode_graph_get_port_parent() will end up incrementing the port node's 
use count. In other words, my understanding is that dropping the 
reference to the port node isn't a problem but intended behaviour here.

I wonder if I miss something.

>
> Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/of/property.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/of/property.c b/drivers/of/property.c
> index 067f9fab7b77c794..637dcb4833e2af60 100644
> --- a/drivers/of/property.c
> +++ b/drivers/of/property.c
> @@ -922,6 +922,12 @@ of_fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
>  {
>  	struct device_node *np;
>
> +	/*
> +	 * Preserve usecount for passed in node as of_get_next_parent()
> +	 * will do of_node_put() on it.
> +	 */
> +	of_node_get(to_of_node(fwnode));
> +
>  	/* Get the parent of the port */
>  	np = of_get_next_parent(to_of_node(fwnode));
>  	if (!np)
>


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
