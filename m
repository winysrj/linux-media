Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:41267 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbeIMO0C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 10:26:02 -0400
Date: Thu, 13 Sep 2018 11:17:20 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3 15/23] v4l: fwnode: Use default parallel flags
Message-ID: <20180913091720.GR20333@w540>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
 <20180912212942.19641-16-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EmW68jKGQIhj8inv"
Content-Disposition: inline
In-Reply-To: <20180912212942.19641-16-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EmW68jKGQIhj8inv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Thu, Sep 13, 2018 at 12:29:34AM +0300, Sakari Ailus wrote:
> The caller may provide default flags for the endpoint. Change the
> configuration based on what is available through the fwnode property API.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
  j
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index bdb0a355b66b..de4a43765ac2 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -183,31 +183,44 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
>  	unsigned int flags = 0;
>  	u32 v;
>
> +	if (bus_type == V4L2_MBUS_PARALLEL || bus_type == V4L2_MBUS_BT656)
> +		flags = bus->flags;
> +
>  	if (!fwnode_property_read_u32(fwnode, "hsync-active", &v)) {
> +		flags &= ~(V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> +			   V4L2_MBUS_HSYNC_ACTIVE_LOW);
>  		flags |= v ? V4L2_MBUS_HSYNC_ACTIVE_HIGH :
>  			V4L2_MBUS_HSYNC_ACTIVE_LOW;
>  		pr_debug("hsync-active %s\n", v ? "high" : "low");
>  	}
>
>  	if (!fwnode_property_read_u32(fwnode, "vsync-active", &v)) {
> +		flags &= ~(V4L2_MBUS_VSYNC_ACTIVE_HIGH |
> +			   V4L2_MBUS_VSYNC_ACTIVE_LOW);
>  		flags |= v ? V4L2_MBUS_VSYNC_ACTIVE_HIGH :
>  			V4L2_MBUS_VSYNC_ACTIVE_LOW;
>  		pr_debug("vsync-active %s\n", v ? "high" : "low");
>  	}
>
>  	if (!fwnode_property_read_u32(fwnode, "field-even-active", &v)) {
> +		flags &= ~(V4L2_MBUS_FIELD_EVEN_HIGH |
> +			   V4L2_MBUS_FIELD_EVEN_LOW);
>  		flags |= v ? V4L2_MBUS_FIELD_EVEN_HIGH :
>  			V4L2_MBUS_FIELD_EVEN_LOW;
>  		pr_debug("field-even-active %s\n", v ? "high" : "low");
>  	}
>
>  	if (!fwnode_property_read_u32(fwnode, "pclk-sample", &v)) {
> +		flags &= ~(V4L2_MBUS_PCLK_SAMPLE_RISING |
> +			   V4L2_MBUS_PCLK_SAMPLE_FALLING);
>  		flags |= v ? V4L2_MBUS_PCLK_SAMPLE_RISING :
>  			V4L2_MBUS_PCLK_SAMPLE_FALLING;
>  		pr_debug("pclk-sample %s\n", v ? "high" : "low");
>  	}
>
>  	if (!fwnode_property_read_u32(fwnode, "data-active", &v)) {
> +		flags &= ~(V4L2_MBUS_PCLK_SAMPLE_RISING |
> +			   V4L2_MBUS_PCLK_SAMPLE_FALLING);
>  		flags |= v ? V4L2_MBUS_DATA_ACTIVE_HIGH :
>  			V4L2_MBUS_DATA_ACTIVE_LOW;
>  		pr_debug("data-active %s\n", v ? "high" : "low");
> @@ -215,8 +228,10 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
>
>  	if (fwnode_property_present(fwnode, "slave-mode")) {
>  		pr_debug("slave mode\n");
> +		flags &= ~V4L2_MBUS_MASTER;
>  		flags |= V4L2_MBUS_SLAVE;
>  	} else {
> +		flags &= ~V4L2_MBUS_SLAVE;
>  		flags |= V4L2_MBUS_MASTER;
>  	}
>
> @@ -231,12 +246,16 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
>  	}
>
>  	if (!fwnode_property_read_u32(fwnode, "sync-on-green-active", &v)) {
> +		flags &= ~(V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH |
> +			   V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW);
>  		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
>  			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
>  		pr_debug("sync-on-green-active %s\n", v ? "high" : "low");
>  	}
>
>  	if (!fwnode_property_read_u32(fwnode, "data-enable-active", &v)) {
> +		flags &= ~(V4L2_MBUS_DATA_ENABLE_HIGH |
> +			   V4L2_MBUS_DATA_ENABLE_LOW);
>  		flags |= v ? V4L2_MBUS_DATA_ENABLE_HIGH :
>  			V4L2_MBUS_DATA_ENABLE_LOW;
>  		pr_debug("data-enable-active %s\n", v ? "high" : "low");
> --
> 2.11.0
>

--EmW68jKGQIhj8inv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbmisgAAoJEHI0Bo8WoVY8+HEQAJcr9EJVT7gzYLBGjgtBGSxh
Js0Y+fuW3kRMDFfQEVJY5s6JhAu8Qr7iQicpkBZKm+2KQ9dt5rYvdv3tmi8oajR6
0l3y7SiBAYYk+rXu234PfbXc1PXcvqBkW+OPQSiVxrUfLy/VYJtLWYHhTPpfrVvg
k4kw2s0X3PtjByAQhvlUxEx12Wt8XhrMW4SzrLIOIt5OJ07IgoZpCqe6UOXxr+DE
rVz88jUD1aurM6LUPZGv8rTL6Ohe0onpeRFM3gUyIE4eohsH9nV44NdP4M6nt/jy
NTL+KN3y973xyEDG9cy1AqLKgOh1gZL6BsSjJnrel6ezzgXBfb37kWv8uQhmuz1k
7tHSuynpVrfJLR/jl60GHujKfRXk6VaOXwGomGdW6qxqYs7lgHjbC0yrA+ERqhOw
w8//ZsinIaV6mSbun+Yw2oAgFcSaEviCXD+JgWWPqPqvtxWFYL3V9Y55UbnkQuc+
Y4Nmjo0nDMoxMbkeiqNaI6YQwpcu0cuFDJBNDIIFbjrIju9PUIgrVIn6zsUBMhH3
Kwx+XCChs1xreXBn1Jc0UWMNbecQ0Xe3V1gK5yAT+buHPp19KkSE6Ws8AZE7RRUh
qHLmh/RaUrzZRgTGv2J4svQX/i98Ia6I6K6qxvGOF3azpgAJlrLqCilDTJo7Mel8
oAVW6u5U6P18Zg7ts+ox
=eJCE
-----END PGP SIGNATURE-----

--EmW68jKGQIhj8inv--
