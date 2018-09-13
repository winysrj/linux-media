Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:58377 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbeIMPqZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 11:46:25 -0400
Date: Thu, 13 Sep 2018 12:37:27 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 06/17] media: v4l2-fwnode: Add a convenience function
 for registering subdevs with notifiers
Message-ID: <20180913103727.GB28160@w540>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-7-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dEhLd0jN5MocHkcT"
Content-Disposition: inline
In-Reply-To: <1531175957-1973-7-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dEhLd0jN5MocHkcT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Steve,

On Mon, Jul 09, 2018 at 03:39:06PM -0700, Steve Longerbeam wrote:
> Adds v4l2_async_register_fwnode_subdev(), which is a convenience function
> for parsing a sub-device's fwnode port endpoints for connected remote
> sub-devices, registering a sub-device notifier, and then registering
> the sub-device itself.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
> Changes since v5:
> - add call to v4l2_async_notifier_init().
> Changes since v4:
> - none
> Changes since v3:
> - remove support for port sub-devices, such sub-devices will have to
>   role their own.
> Changes since v2:
> - fix error-out path in v4l2_async_register_fwnode_subdev() that forgot
>   to put device.
> Changes since v1:
> - add #include <media/v4l2-subdev.h> to v4l2-fwnode.h for
>   'struct v4l2_subdev' declaration.
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 64 +++++++++++++++++++++++++++++++++++
>  include/media/v4l2-fwnode.h           | 38 +++++++++++++++++++++
>  2 files changed, 102 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 67ad333..94d867a 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -872,6 +872,70 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
>
> +int v4l2_async_register_fwnode_subdev(

The meat of this function is to register a subdev with a notifier,
so I would make it clear in the function name which is otherwise
misleading

> +	struct v4l2_subdev *sd, size_t asd_struct_size,
> +	unsigned int *ports, unsigned int num_ports,
> +	int (*parse_endpoint)(struct device *dev,
> +			      struct v4l2_fwnode_endpoint *vep,
> +			      struct v4l2_async_subdev *asd))
> +{
> +	struct v4l2_async_notifier *notifier;
> +	struct device *dev = sd->dev;
> +	struct fwnode_handle *fwnode;
> +	int ret;
> +
> +	if (WARN_ON(!dev))
> +		return -ENODEV;
> +
> +	fwnode = dev_fwnode(dev);
> +	if (!fwnode_device_is_available(fwnode))
> +		return -ENODEV;
> +
> +	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
> +	if (!notifier)
> +		return -ENOMEM;
> +
> +	v4l2_async_notifier_init(notifier);
> +
> +	if (!ports) {
> +		ret = v4l2_async_notifier_parse_fwnode_endpoints(
> +			dev, notifier, asd_struct_size, parse_endpoint);
> +		if (ret < 0)
> +			goto out_cleanup;
> +	} else {
> +		unsigned int i;
> +
> +		for (i = 0; i < num_ports; i++) {

It's not particularly exciting to iterate on pointers received from
callers without checking for num_ports first.

Also the caller has to allocate an array of "ports" and keep track of it
just to pass it to this function and I don't see a way to set the
notifier's ops before the notifier gets registered here below.

> +			ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> +				dev, notifier, asd_struct_size,
> +				ports[i], parse_endpoint);
> +			if (ret < 0)
> +				goto out_cleanup;
> +		}
> +	}
> +
> +	ret = v4l2_async_subdev_notifier_register(sd, notifier);
> +	if (ret < 0)
> +		goto out_cleanup;
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto out_unregister;
> +
> +	sd->subdev_notifier = notifier;

This is set already by v4l2_async_subdev_notifier_register()

In general, I have doubts this function is really needed. It requires
the caller to reserve memory just to pass down a list of intergers,
and there is no way to set subdev ops.

Could you have a look at how drivers/media/platform/rcar-vin/rcar-csi2.c
registers a subdevice and an associated notifier and see if in your
opinion it can be implemented in the same way in your imx csi/csi2 driver,
or you still like this one most?

Thanks
   j
> +
> +	return 0;
> +
> +out_unregister:
> +	v4l2_async_notifier_unregister(notifier);
> +out_cleanup:
> +	v4l2_async_notifier_cleanup(notifier);
> +	kfree(notifier);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_register_fwnode_subdev);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index ea7a8b2..031ebb0 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -23,6 +23,7 @@
>  #include <linux/types.h>
>
>  #include <media/v4l2-mediabus.h>
> +#include <media/v4l2-subdev.h>
>
>  struct fwnode_handle;
>  struct v4l2_async_notifier;
> @@ -360,4 +361,41 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>  int v4l2_async_notifier_parse_fwnode_sensor_common(
>  	struct device *dev, struct v4l2_async_notifier *notifier);
>
> +/**
> + * v4l2_async_register_fwnode_subdev - registers a sub-device to the
> + *					asynchronous sub-device framework
> + *					and parses fwnode endpoints
> + *
> + * @sd: pointer to struct &v4l2_subdev
> + * @asd_struct_size: size of the driver's async sub-device struct, including
> + *		     sizeof(struct v4l2_async_subdev). The &struct
> + *		     v4l2_async_subdev shall be the first member of
> + *		     the driver's async sub-device struct, i.e. both
> + *		     begin at the same memory address.
> + * @ports: array of port id's to parse for fwnode endpoints. If NULL, will
> + *	   parse all ports owned by the sub-device.
> + * @num_ports: number of ports in @ports array. Ignored if @ports is NULL.
> + * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
> + *		    endpoint. Optional.
> + *
> + * This function is just like v4l2_async_register_subdev() with the
> + * exception that calling it will also allocate a notifier for the
> + * sub-device, parse the sub-device's firmware node endpoints using
> + * v4l2_async_notifier_parse_fwnode_endpoints() or
> + * v4l2_async_notifier_parse_fwnode_endpoints_by_port(), and
> + * registers the sub-device notifier. The sub-device is similarly
> + * unregistered by calling v4l2_async_unregister_subdev().
> + *
> + * While registered, the subdev module is marked as in-use.
> + *
> + * An error is returned if the module is no longer loaded on any attempts
> + * to register it.
> + */
> +int v4l2_async_register_fwnode_subdev(
> +	struct v4l2_subdev *sd, size_t asd_struct_size,
> +	unsigned int *ports, unsigned int num_ports,
> +	int (*parse_endpoint)(struct device *dev,
> +			      struct v4l2_fwnode_endpoint *vep,
> +			      struct v4l2_async_subdev *asd));
> +
>  #endif /* _V4L2_FWNODE_H */
> --
> 2.7.4
>

--dEhLd0jN5MocHkcT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbmj3nAAoJEHI0Bo8WoVY8BBUP/0/XYjJxIOrRjAqkdTdx+SIT
CMwvzQf3VqYzUUFn1LDqcQlkovgrziZv6rDj1Aaf6I0jFFdtsPXZfqbK6CkQEaMC
tdIGlD03Jy18E5lviO+W+7lXFU1ztwALzFQFiAqX/U4OiTj3ajYC95vtKCLDMHwm
3qrTsCOcvtcDpqSMtHznzcmCri/ygBCmfa4Ts6BTC6rAdJoXmjlKRHVeXXcCLWGg
uczLqhQIkvpbMwOeCgzv3stOyUzv7Q4+/stG5f6Lhvc7MYdnFexfJzHiYawg0Lv/
DmXZRnoemsXw7I2JTuUeQhg6hIUA6TTjQXMotDa+FPcZJBscYolFXvUMBQtZI/c0
Gbj9UKeMzqXT0QKLjuZUda/uqdC4MT9cZhkn7BJlUfZSRDIZvgMK+w0ov5pv8wFc
qRZ3wEbOMxSTt4UUk+bsK0PPQLNCl1YdgJCz2re+0O/mwcwLmz5mZg2YO60kAoDO
cfmzl+IJ1c16L4yTAx1UUcZ/XkgzdUe8GAOHAfisLlwVzSGFxl7QgnqN1+QGOWMU
OuHftZehGJ0PoLUFEAx3J+5gFeVchx+sDxhpOcAy4FcHRHA3v8+ufTpFT6flkdrL
y2DUSJprhiURMDc/QzcfLLa/EOjWzwu+Wcc9S01eUnro237RFc2bv80X9a748cRh
KqBdTz6gee4q1bM1aiYK
=2SND
-----END PGP SIGNATURE-----

--dEhLd0jN5MocHkcT--
