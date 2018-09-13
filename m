Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:60029 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbeIMOXc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 10:23:32 -0400
Date: Thu, 13 Sep 2018 11:14:52 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3 09/23] v4l: fwnode: Make use of newly specified bus
 types
Message-ID: <20180913091452.GQ20333@w540>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
 <20180912212942.19641-10-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rG09A39trvEtf3rB"
Content-Disposition: inline
In-Reply-To: <20180912212942.19641-10-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rG09A39trvEtf3rB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Thu, Sep 13, 2018 at 12:29:28AM +0300, Sakari Ailus wrote:
> Add support for parsing CSI-2 D-PHY, parallel or Bt.656 bus explicitly.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 53 ++++++++++++++++++++++++++++-------
>  1 file changed, 43 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index aa3d28c4a50b..74c2f4e03e52 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -123,8 +123,16 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
>  	return 0;
>  }
>
> +#define PARALLEL_MBUS_FLAGS (V4L2_MBUS_HSYNC_ACTIVE_HIGH |	\
> +			     V4L2_MBUS_HSYNC_ACTIVE_LOW |	\
> +			     V4L2_MBUS_VSYNC_ACTIVE_HIGH |	\
> +			     V4L2_MBUS_VSYNC_ACTIVE_LOW |	\
> +			     V4L2_MBUS_FIELD_EVEN_HIGH |	\
> +			     V4L2_MBUS_FIELD_EVEN_LOW)
> +
>  static void v4l2_fwnode_endpoint_parse_parallel_bus(
> -	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)
> +	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep,
> +	enum v4l2_fwnode_bus_type bus_type)
>  {
>  	struct v4l2_fwnode_bus_parallel *bus = &vep->bus.parallel;
>  	unsigned int flags = 0;
> @@ -189,16 +197,28 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
>  		pr_debug("data-enable-active %s\n", v ? "high" : "low");
>  	}
>
> -	bus->flags = flags;
> -	if (flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> -		     V4L2_MBUS_HSYNC_ACTIVE_LOW |
> -		     V4L2_MBUS_VSYNC_ACTIVE_HIGH |
> -		     V4L2_MBUS_VSYNC_ACTIVE_LOW |
> -		     V4L2_MBUS_FIELD_EVEN_HIGH |
> -		     V4L2_MBUS_FIELD_EVEN_LOW))
> +	switch (bus_type) {
> +	default:
> +		bus->flags = flags;
> +		if (flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> +			     V4L2_MBUS_HSYNC_ACTIVE_LOW |
> +			     V4L2_MBUS_VSYNC_ACTIVE_HIGH |
> +			     V4L2_MBUS_VSYNC_ACTIVE_LOW |
> +			     V4L2_MBUS_FIELD_EVEN_HIGH |
> +			     V4L2_MBUS_FIELD_EVEN_LOW))

I guess you could use V4L2_MBUS_PARALLEL here.

Apart from this:
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
   j

> +			vep->bus_type = V4L2_MBUS_PARALLEL;
> +		else
> +			vep->bus_type = V4L2_MBUS_BT656;
> +		break;
> +	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
>  		vep->bus_type = V4L2_MBUS_PARALLEL;
> -	else
> +		bus->flags = flags;
> +		break;
> +	case V4L2_FWNODE_BUS_TYPE_BT656:
>  		vep->bus_type = V4L2_MBUS_BT656;
> +		bus->flags = flags & ~PARALLEL_MBUS_FLAGS;
> +		break;
> +	}
>  }
>
>  static void
> @@ -258,7 +278,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
>  			return rval;
>
>  		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
> -			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
> +			v4l2_fwnode_endpoint_parse_parallel_bus(
> +				fwnode, vep, V4L2_MBUS_UNKNOWN);
>
>  		break;
>  	case V4L2_FWNODE_BUS_TYPE_CCP2:
> @@ -266,6 +287,18 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
>  		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
>
>  		break;
> +	case V4L2_FWNODE_BUS_TYPE_CSI2_DPHY:
> +		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
> +		rval = v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
> +		if (rval)
> +			return rval;
> +
> +		break;
> +	case V4L2_FWNODE_BUS_TYPE_PARALLEL:
> +	case V4L2_FWNODE_BUS_TYPE_BT656:
> +		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep, bus_type);
> +
> +		break;
>  	default:
>  		pr_warn("unsupported bus type %u\n", bus_type);
>  		return -EINVAL;
> --
> 2.11.0
>

--rG09A39trvEtf3rB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbmiqMAAoJEHI0Bo8WoVY8CRwQAJGw2aOfTznbuMiXIwuclnyn
rEALu1uhxnzSci53s01IOMaEcxuJ1Ui4JLxSjCMnzLTKzTtRlMEQJDO92O1JRSay
6i/tjS3hK8FzK9iGIMYk+yFBsYRLUHHkV0+Uslj3jV0X0WC3uTq5CT65/7vG1Wj7
h4FNpVs/wgsCcJCFF3II0c/AWziOwmU3a4ddcMo3yDo5rboOpFmWmZj80+tLiz+i
uHeRA7gjdKJtSNMcKq1Bv2Vaei8gCvmTDCMVrh3sHMp047k4W0kHavV2Aq7Yit8O
ShbVSEY18CUVSN7dUB28Xf5kz+SOruVucqSPG9RdOkes+7NAex3MYkhdpf35fx8Q
J/QrVyJaDW9qYR7ezukMJgSmPRt4oxx7Uxh28BpuEDSCI3V2bKV946hxaV/GOrQj
nT2z4y7WjyLhdRE1YnFR7/3qoROZWrAnSgGYuSX7vhVcuorE/9grquTLXohNCapY
xSDo0QLkJ827i2P3Plm7s6Ky0eD6Tpkc05iSNOj35jjovvXXeFzby1ya84b5Gvmd
CDsnVqNPq+GPdY49UCW/dy9V3CaDYeKRLz1tEssZ9SbxON07doRYXnE3OJZmLbci
I87UfQrwfrFBBLVyhPCaV6sDX2W0EZTJM7aFNkp/vkWS3mMsvSYqWI51uXd2QeXw
oEEZD9Gc5msqlM5oISHA
=s+IB
-----END PGP SIGNATURE-----

--rG09A39trvEtf3rB--
