Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57825 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbeILT4L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 15:56:11 -0400
Date: Wed, 12 Sep 2018 16:51:07 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH v2 07/23] v4l: fwnode: Let the caller provide V4L2 fwnode
 endpoint
Message-ID: <20180912145107.GA11509@w540>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
 <20180827093000.29165-8-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20180827093000.29165-8-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Mon, Aug 27, 2018 at 12:29:44PM +0300, Sakari Ailus wrote:
> Instead of allocating the V4L2 fwnode endpoint in
> v4l2_fwnode_endpoint_alloc_parse, let the caller to do this. This allows
> setting default parameters for the endpoint which is a very common need
> for drivers.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/ov2659.c             | 14 +++++-----
>  drivers/media/i2c/smiapp/smiapp-core.c | 26 +++++++++---------
>  drivers/media/i2c/tc358743.c           | 26 +++++++++---------
>  drivers/media/v4l2-core/v4l2-fwnode.c  | 49 +++++++++++++---------------------
>  include/media/v4l2-fwnode.h            | 10 ++++---
>  5 files changed, 60 insertions(+), 65 deletions(-)
>

[snip]

> -struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
> -	struct fwnode_handle *fwnode)
> +int v4l2_fwnode_endpoint_alloc_parse(
> +	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)

Looking at the resulting implementation of
"v4l2_fwnode_endpoint_alloc_parse" and "v4l2_fwnode_endpoint_parse" I
wonder if there's still value in keeping them separate... Now that in
both cases the caller has to provide an v4l2_fwnode_endpoint, isn't it
worth making a single function out of them, that behaves like
"alloc_parse" is doing nowadays (allocates vep->link_frequencies
conditionally on the presence of the "link-frequencies" property) ?

Or is the size of the allocated vep relevant in the async subdevice
matching or registration process? I guess not, but I might be missing
something...

Thanks
   j


>  {
> -	struct v4l2_fwnode_endpoint *vep;
>  	int rval;
>
> -	vep = kzalloc(sizeof(*vep), GFP_KERNEL);
> -	if (!vep)
> -		return ERR_PTR(-ENOMEM);
> -
>  	rval = __v4l2_fwnode_endpoint_parse(fwnode, vep);
>  	if (rval < 0)
> -		goto out_err;
> +		return rval;
>
>  	rval = fwnode_property_read_u64_array(fwnode, "link-frequencies",
>  					      NULL, 0);
> @@ -316,18 +310,18 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
>  		vep->link_frequencies =
>  			kmalloc_array(rval, sizeof(*vep->link_frequencies),
>  				      GFP_KERNEL);
> -		if (!vep->link_frequencies) {
> -			rval = -ENOMEM;
> -			goto out_err;
> -		}
> +		if (!vep->link_frequencies)
> +			return -ENOMEM;
>
>  		vep->nr_of_link_frequencies = rval;
>
>  		rval = fwnode_property_read_u64_array(
>  			fwnode, "link-frequencies", vep->link_frequencies,
>  			vep->nr_of_link_frequencies);
> -		if (rval < 0)
> -			goto out_err;
> +		if (rval < 0) {
> +			v4l2_fwnode_endpoint_free(vep);
> +			return rval;
> +		}
>
>  		for (i = 0; i < vep->nr_of_link_frequencies; i++)
>  			pr_info("link-frequencies %u value %llu\n", i,
> @@ -336,11 +330,7 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
>
>  	pr_debug("===== end V4L2 endpoint properties\n");
>
> -	return vep;
> -
> -out_err:
> -	v4l2_fwnode_endpoint_free(vep);
> -	return ERR_PTR(rval);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_alloc_parse);
>
> @@ -392,9 +382,9 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
>  			    struct v4l2_fwnode_endpoint *vep,
>  			    struct v4l2_async_subdev *asd))
>  {
> +	struct v4l2_fwnode_endpoint vep = { .bus_type = V4L2_MBUS_UNKNOWN };
>  	struct v4l2_async_subdev *asd;
> -	struct v4l2_fwnode_endpoint *vep;
> -	int ret = 0;
> +	int ret;
>
>  	asd = kzalloc(asd_struct_size, GFP_KERNEL);
>  	if (!asd)
> @@ -409,23 +399,22 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
>  		goto out_err;
>  	}
>
> -	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
> -	if (IS_ERR(vep)) {
> -		ret = PTR_ERR(vep);
> +	ret = v4l2_fwnode_endpoint_alloc_parse(endpoint, &vep);
> +	if (ret) {
>  		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
>  			 ret);
>  		goto out_err;
>  	}
>
> -	ret = parse_endpoint ? parse_endpoint(dev, vep, asd) : 0;
> +	ret = parse_endpoint ? parse_endpoint(dev, &vep, asd) : 0;
>  	if (ret == -ENOTCONN)
> -		dev_dbg(dev, "ignoring port@%u/endpoint@%u\n", vep->base.port,
> -			vep->base.id);
> +		dev_dbg(dev, "ignoring port@%u/endpoint@%u\n", vep.base.port,
> +			vep.base.id);
>  	else if (ret < 0)
>  		dev_warn(dev,
>  			 "driver could not parse port@%u/endpoint@%u (%d)\n",
> -			 vep->base.port, vep->base.id, ret);
> -	v4l2_fwnode_endpoint_free(vep);
> +			 vep.base.port, vep.base.id, ret);
> +	v4l2_fwnode_endpoint_free(&vep);
>  	if (ret < 0)
>  		goto out_err;
>
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 8b4873c37098..4a371c3ad86c 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -161,6 +161,7 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
>  /**
>   * v4l2_fwnode_endpoint_alloc_parse() - parse all fwnode node properties
>   * @fwnode: pointer to the endpoint's fwnode handle
> + * @vep: pointer to the V4L2 fwnode data structure
>   *
>   * All properties are optional. If none are found, we don't set any flags. This
>   * means the port has a static configuration and no properties have to be
> @@ -170,6 +171,8 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
>   * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
>   * reference to @fwnode.
>   *
> + * The caller must set the bus_type field of @vep to zero.
> + *
>   * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
>   * v4l2_fwnode_endpoint_parse():
>   *
> @@ -178,11 +181,10 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
>   * 2. The memory it has allocated to store the variable size data must be freed
>   *    using v4l2_fwnode_endpoint_free() when no longer needed.
>   *
> - * Return: Pointer to v4l2_fwnode_endpoint if successful, on an error pointer
> - * on error.
> + * Return: 0 on success or a negative error code on failure.
>   */
> -struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
> -	struct fwnode_handle *fwnode);
> +int v4l2_fwnode_endpoint_alloc_parse(
> +	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep);
>
>  /**
>   * v4l2_fwnode_parse_link() - parse a link between two endpoints
> --
> 2.11.0
>

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbmSfbAAoJEHI0Bo8WoVY8syMP/3GtbvV7wndQBBXjfnfhvCsL
CgM7iH1ECxZyGSc8P7MqupUsnh6SLAErEjZY/K2+Mb+LwSGy68egI15YvabzfjGd
FVS1vPpJGFaVLrppB49qxGCx89CjamDs/Pn1kM3Dj7JhDIfwmhPqYKSmJAdbB70O
tXrQ0OXbLnnNUb37pphv7NB5arl+HntoxpfJ4C/JbE98ZpKCtGV8y5ogezLTwLT1
PUhbexDiWe08p4cBTBDc9YAEjbj5q0/sTZtohW4+VuTe2K0vg+4kfqZfeAirF9hx
VGAmgZQRULGx7AjZHS7kNT2DMiXEH46LH28+L0WpozIgUBmMKiszGToWFIJF9DEO
qpUatOWIifGvrB7Ts/1Ci6JYDYyT1ep3eU1NcaIr5q2RpOoCysSeiQxIMaZ22zge
U2lnONEV1NVtqZ03SNXVLw7HcrFE/Fpj5Qjs+lYtdOamdFJktPtfepYaUGD0zx4Z
SmVhAprKPLzg+x3kxi3ukorp+E9SYcVdz9SW+qL6t0TmRw3pdQ3gRAT3WJwGwpZL
M2sGIVitz+iNC7teERUN9UBGhEElIGLM6LiRKOTc0b2cyj4uIvxkqo8EselpTX1U
FrWCQDFGgh0NSBi/HjCVFkOfHCQi1JblOks4L9wgnuGodBxmfR3/ooHwWZw4rNqG
1gL/7YJB+vnrHswBlCnA
=BXGj
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
