Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33784 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdGFLIu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 07:08:50 -0400
Date: Thu, 6 Jul 2017 13:08:47 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pavel@ucw.cz,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 5/8] v4l: Add support for CSI-1 and CCP2 busses
Message-ID: <20170706110846.spzmyvalu5j27z6e@earth>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
 <20170705230019.5461-6-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nfgq4oafl76a5fci"
Content-Disposition: inline
In-Reply-To: <20170705230019.5461-6-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nfgq4oafl76a5fci
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 06, 2017 at 02:00:16AM +0300, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
>=20
> CCP2 and CSI-1, are older single data lane serial busses.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/platform/pxa_camera.c              |  3 ++
>  drivers/media/platform/soc_camera/soc_mediabus.c |  3 ++
>  drivers/media/v4l2-core/v4l2-fwnode.c            | 58 ++++++++++++++++++=
+-----
>  include/media/v4l2-fwnode.h                      | 19 ++++++++
>  include/media/v4l2-mediabus.h                    |  4 ++
>  5 files changed, 76 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform=
/pxa_camera.c
> index 399095170b6e..17e797c9559f 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -638,6 +638,9 @@ static unsigned int pxa_mbus_config_compatible(const =
struct v4l2_mbus_config *cf
>  		mipi_clock =3D common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
>  					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
>  		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
> +	default:
> +		__WARN();
> +		return -EINVAL;
>  	}
>  	return 0;
>  }
> diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/m=
edia/platform/soc_camera/soc_mediabus.c
> index 57581f626f4c..43192d80beef 100644
> --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> @@ -508,6 +508,9 @@ unsigned int soc_mbus_config_compatible(const struct =
v4l2_mbus_config *cfg,
>  		mipi_clock =3D common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
>  					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
>  		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
> +	default:
> +		__WARN();
> +		return -EINVAL;
>  	}
>  	return 0;
>  }
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index d71dd3913cd9..76a88f210cb6 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -154,6 +154,31 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
> =20
>  }
> =20
> +void v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
> +					 struct v4l2_fwnode_endpoint *vep,
> +					 u32 bus_type)
> +{
> +       struct v4l2_fwnode_bus_mipi_csi1 *bus =3D &vep->bus.mipi_csi1;
> +       u32 v;
> +
> +       if (!fwnode_property_read_u32(fwnode, "clock-inv", &v))
> +               bus->clock_inv =3D v;
> +
> +       if (!fwnode_property_read_u32(fwnode, "strobe", &v))
> +               bus->strobe =3D v;
> +
> +       if (!fwnode_property_read_u32(fwnode, "data-lanes", &v))
> +               bus->data_lane =3D v;
> +
> +       if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v))
> +               bus->clock_lane =3D v;
> +
> +       if (bus_type =3D=3D V4L2_FWNODE_BUS_TYPE_CCP2)
> +	       vep->bus_type =3D V4L2_MBUS_CCP2;
> +       else
> +	       vep->bus_type =3D V4L2_MBUS_CSI1;
> +}
> +
>  /**
>   * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
>   * @fwnode: pointer to the endpoint's fwnode handle
> @@ -187,17 +212,28 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle=
 *fwnode,
> =20
>  	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
> =20
> -	rval =3D v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
> -	if (rval)
> -		return rval;
> -	/*
> -	 * Parse the parallel video bus properties only if none
> -	 * of the MIPI CSI-2 specific properties were found.
> -	 */
> -	if (vep->bus.mipi_csi2.flags =3D=3D 0)
> -		v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
> -
> -	return 0;
> +	switch (bus_type) {
> +	case V4L2_FWNODE_BUS_TYPE_GUESS:
> +		rval =3D v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
> +		if (rval)
> +			return rval;
> +		/*
> +		 * Parse the parallel video bus properties only if none
> +		 * of the MIPI CSI-2 specific properties were found.
> +		 */
> +		if (vep->bus.mipi_csi2.flags =3D=3D 0)
> +			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep);
> +
> +		return 0;
> +	case V4L2_FWNODE_BUS_TYPE_CCP2:
> +	case V4L2_FWNODE_BUS_TYPE_CSI1:
> +		v4l2_fwnode_endpoint_parse_csi1_bus(fwnode, vep, bus_type);
> +
> +		return 0;
> +	default:
> +		pr_warn("unsupported bus type %u\n", bus_type);
> +		return -EINVAL;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_parse);
> =20
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index ecc1233a873e..29ae22bbbbaf 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -56,6 +56,24 @@ struct v4l2_fwnode_bus_parallel {
>  };
> =20
>  /**
> + * struct v4l2_fwnode_bus_mipi_csi1 - CSI-1/CCP2 data bus structure
> + * @clock_inv: polarity of clock/strobe signal
> + *	       false - not inverted, true - inverted
> + * @strobe: false - data/clock, true - data/strobe
> + * @lane_polarity: the polarities of the clock (index 0) and data lanes
> +		   index (1)
> + * @data_lane: the number of the data lane
> + * @clock_lane: the number of the clock lane
> + */
> +struct v4l2_fwnode_bus_mipi_csi1 {
> +	bool clock_inv;
> +	bool strobe;
> +	bool lane_polarity[2];
> +	unsigned char data_lane;
> +	unsigned char clock_lane;
> +};
> +
> +/**
>   * struct v4l2_fwnode_endpoint - the endpoint data structure
>   * @base: fwnode endpoint of the v4l2_fwnode
>   * @bus_type: bus type
> @@ -72,6 +90,7 @@ struct v4l2_fwnode_endpoint {
>  	enum v4l2_mbus_type bus_type;
>  	union {
>  		struct v4l2_fwnode_bus_parallel parallel;
> +		struct v4l2_fwnode_bus_mipi_csi1 mipi_csi1;
>  		struct v4l2_fwnode_bus_mipi_csi2 mipi_csi2;
>  	} bus;
>  	u64 *link_frequencies;
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 34cc99e093ef..315c167a95dc 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -69,11 +69,15 @@
>   * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
>   * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, c=
an
>   *			also be used for BT.1120
> + * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
> + * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
>   * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
>   */
>  enum v4l2_mbus_type {
>  	V4L2_MBUS_PARALLEL,
>  	V4L2_MBUS_BT656,
> +	V4L2_MBUS_CSI1,
> +	V4L2_MBUS_CCP2,
>  	V4L2_MBUS_CSI2,
>  };
> =20
> --=20
> 2.11.0
>=20

--nfgq4oafl76a5fci
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlleGj4ACgkQ2O7X88g7
+poNxQ/9EET2E5PVKnVOe8DeO9quiP6YwuI7FHcg0s7aezyyIS3CGCjOg7CLiKUX
qdqHregfbdh6rhIFauZ4ghC3UWSrf3lxGyLMQq1o1hCU2JmJs7lF8ppDwl0l4PEY
dXr9aSNBCdYfjWB4pKGc1CdEO6KeJ8k6ojqyUcp+k1cJYl5HfSA5GYbzzkAJtC3O
t1BYC7E3+HiP/im4Fda3zeYVjXBcLhOGvxz/UKz7fLgk5CvrM9tBGFPwhoxOFicR
ZhaU6vy3tcMwnsvpjIvec3KrlVwuoiPqGzrIGPUuD3XrsYm722h2gLHYx4nwfqsO
we09cd1c/YrHtz0hCqcygEV8WQFYNRoXmt4nFC1Ocj6K3ElvRodxy0H5eCvCeURf
TXz88ohZtWnJvPSKRZwXHcVV8LBP+SJm9zooqTWMOAGq+p4p7fdfxfCaLWBnXvP+
46FGw6Y9mbcLlTfM83x0XDDdS4LdHYEaFPQygh5zgSpGzZ/E+NaAOq+jzlN22x0o
crdI3a9eUqV/K3cfbk7cn1Ps6PMmnGOAHSXHF/Mt5SE/sPNXezcgwBKLVjXrgY00
9BoVczVbVr0VdL2ZJoZHZb29Tx2FsQm7p3KeI/0gxSzmIAFvjQh2dJsQ/zRVyn6M
Ngrp0MU8M6ZlyJG5T6uAhl+VdiLALXclkWEWIhQKs8PzmRHx5SE=
=k+7I
-----END PGP SIGNATURE-----

--nfgq4oafl76a5fci--
