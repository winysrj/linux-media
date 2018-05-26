Return-path: <linux-media-owner@vger.kernel.org>
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:51012 "EHLO
        mail.osadl.at" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754475AbeEZOpy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 10:45:54 -0400
Date: Sat, 26 May 2018 14:38:34 +0000
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        ldv-project@linuxtesting.org, sil2review@lists.osadl.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        linux-media@vger.kernel.org
Subject: Re: [SIL2review] [PATCH] media: tc358743: release device_node in
 tc358743_probe_of()
Message-ID: <20180526143834.GA28325@osadl.at>
References: <1527285240-12762-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527285240-12762-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 26, 2018 at 12:54:00AM +0300, Alexey Khoroshilov wrote:
> of_graph_get_next_endpoint() returns device_node with refcnt increased,
> but these is no of_node_put() for it.

I think this is correct - but would it not be simpler to do

   endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
   of_node_put(ep);
   if (IS_ERR(endpoint)) {
   ....

As the of_node_put(np) actually is unconditional anyway I think this
should be semantically equivalent.

> 
> The patch adds one on error and normal paths.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/media/i2c/tc358743.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index 393bbbbbaad7..44c41933415a 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1918,7 +1918,8 @@ static int tc358743_probe_of(struct tc358743_state *state)
>  	endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
>  	if (IS_ERR(endpoint)) {
>  		dev_err(dev, "failed to parse endpoint\n");
> -		return PTR_ERR(endpoint);
> +		ret = PTR_ERR(endpoint);
> +		goto put_node;
>  	}
>  
>  	if (endpoint->bus_type != V4L2_MBUS_CSI2 ||
> @@ -2013,6 +2014,8 @@ static int tc358743_probe_of(struct tc358743_state *state)
>  	clk_disable_unprepare(refclk);
>  free_endpoint:
>  	v4l2_fwnode_endpoint_free(endpoint);
> +put_node:
> +	of_node_put(ep);
>  	return ret;
>  }
>  #else
> -- 
> 2.7.4
> 
> _______________________________________________
> SIL2review mailing list
> SIL2review@lists.osadl.org
> https://lists.osadl.org/mailman/listinfo/sil2review
