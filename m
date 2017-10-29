Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2W6v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 18:58:51 -0400
Date: Sun, 29 Oct 2017 23:58:47 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v16.1 24/32] v4l: fwnode: Add a helper function to obtain
 device / integer references
Message-ID: <20171029225847.vierqin6oomhiguk@earth>
References: <20171026075342.5760-25-sakari.ailus@linux.intel.com>
 <20171026150158.8118-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rqx55atvefsahwls"
Content-Disposition: inline
In-Reply-To: <20171026150158.8118-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rqx55atvefsahwls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 06:01:58PM +0300, Sakari Ailus wrote:
> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> the device's own fwnode, it will follow child fwnodes with the given
> property-value pair and return the resulting fwnode.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> since v16:
>=20
> - use const char * const *props for string arrays with property names.
>=20
>  drivers/media/v4l2-core/v4l2-fwnode.c | 287 ++++++++++++++++++++++++++++=
++++++
>  1 file changed, 287 insertions(+)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index edd2e8d983a1..f8cd88f791c4 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -578,6 +578,293 @@ static int v4l2_fwnode_reference_parse(
>  	return ret;
>  }
> =20
> +/*
> + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
> + *					arguments
> + * @fwnode: fwnode to read @prop from
> + * @notifier: notifier for @dev
> + * @prop: the name of the property
> + * @index: the index of the reference to get
> + * @props: the array of integer property names
> + * @nprops: the number of integer property names in @nprops
> + *
> + * First find an fwnode referred to by the reference at @index in @prop.
> + *
> + * Then under that fwnode, @nprops times, for each property in @props,
> + * iteratively follow child nodes starting from fwnode such that they ha=
ve the
> + * property in @props array at the index of the child node distance from=
 the
> + * root node and the value of that property matching with the integer ar=
gument
> + * of the reference, at the same index.
> + *
> + * The child fwnode reched at the end of the iteration is then returned =
to the
> + * caller.
> + *
> + * The core reason for this is that you cannot refer to just any node in=
 ACPI.
> + * So to refer to an endpoint (easy in DT) you need to refer to a device=
, then
> + * provide a list of (property name, property value) tuples where each t=
uple
> + * uniquely identifies a child node. The first tuple identifies a child =
directly
> + * underneath the device fwnode, the next tuple identifies a child node
> + * underneath the fwnode identified by the previous tuple, etc. until you
> + * reached the fwnode you need.
> + *
> + * An example with a graph, as defined in Documentation/acpi/dsd/graph.t=
xt:
> + *
> + *	Scope (\_SB.PCI0.I2C2)
> + *	{
> + *		Device (CAM0)
> + *		{
> + *			Name (_DSD, Package () {
> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> + *				Package () {
> + *					Package () {
> + *						"compatible",
> + *						Package () { "nokia,smia" }
> + *					},
> + *				},
> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> + *				Package () {
> + *					Package () { "port0", "PRT0" },
> + *				}
> + *			})
> + *			Name (PRT0, Package() {
> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> + *				Package () {
> + *					Package () { "port", 0 },
> + *				},
> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> + *				Package () {
> + *					Package () { "endpoint0", "EP00" },
> + *				}
> + *			})
> + *			Name (EP00, Package() {
> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> + *				Package () {
> + *					Package () { "endpoint", 0 },
> + *					Package () {
> + *						"remote-endpoint",
> + *						Package() {
> + *							\_SB.PCI0.ISP, 4, 0
> + *						}
> + *					},
> + *				}
> + *			})
> + *		}
> + *	}
> + *
> + *	Scope (\_SB.PCI0)
> + *	{
> + *		Device (ISP)
> + *		{
> + *			Name (_DSD, Package () {
> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> + *				Package () {
> + *					Package () { "port4", "PRT4" },
> + *				}
> + *			})
> + *
> + *			Name (PRT4, Package() {
> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> + *				Package () {
> + *					Package () { "port", 4 },
> + *				},
> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> + *				Package () {
> + *					Package () { "endpoint0", "EP40" },
> + *				}
> + *			})
> + *
> + *			Name (EP40, Package() {
> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> + *				Package () {
> + *					Package () { "endpoint", 0 },
> + *					Package () {
> + *						"remote-endpoint",
> + *						Package () {
> + *							\_SB.PCI0.I2C2.CAM0,
> + *							0, 0
> + *						}
> + *					},
> + *				}
> + *			})
> + *		}
> + *	}
> + *
> + * From the EP40 node under ISP device, you could parse the graph remote
> + * endpoint using v4l2_fwnode_reference_get_int_prop with these argument=
s:
> + *
> + *  @fwnode: fwnode referring to EP40 under ISP.
> + *  @prop: "remote-endpoint"
> + *  @index: 0
> + *  @props: "port", "endpoint"
> + *  @nprops: 2
> + *
> + * And you'd get back fwnode referring to EP00 under CAM0.
> + *
> + * The same works the other way around: if you use EP00 under CAM0 as the
> + * fwnode, you'll get fwnode referring to EP40 under ISP.
> + *
> + * The same example in DT syntax would look like this:
> + *
> + * cam: cam0 {
> + *	compatible =3D "nokia,smia";
> + *
> + *	port {
> + *		port =3D <0>;
> + *		endpoint {
> + *			endpoint =3D <0>;
> + *			remote-endpoint =3D <&isp 4 0>;
> + *		};
> + *	};
> + * };
> + *
> + * isp: isp {
> + *	ports {
> + *		port@4 {
> + *			port =3D <4>;
> + *			endpoint {
> + *				endpoint =3D <0>;
> + *				remote-endpoint =3D <&cam 0 0>;
> + *			};
> + *		};
> + *	};
> + * };
> + *
> + * Return: 0 on success
> + *	   -ENOENT if no entries (or the property itself) were found
> + *	   -EINVAL if property parsing otherwise failed
> + *	   -ENOMEM if memory allocation failed
> + */
> +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
> +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
> +	const char * const *props, unsigned int nprops)
> +{
> +	struct fwnode_reference_args fwnode_args;
> +	unsigned int *args =3D fwnode_args.args;
> +	struct fwnode_handle *child;
> +	int ret;
> +
> +	/*
> +	 * Obtain remote fwnode as well as the integer arguments.
> +	 *
> +	 * Note that right now both -ENODATA and -ENOENT may signal
> +	 * out-of-bounds access. Return -ENOENT in that case.
> +	 */
> +	ret =3D fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
> +						 index, &fwnode_args);
> +	if (ret)
> +		return ERR_PTR(ret =3D=3D -ENODATA ? -ENOENT : ret);
> +
> +	/*
> +	 * Find a node in the tree under the referred fwnode corresponding to
> +	 * the integer arguments.
> +	 */
> +	fwnode =3D fwnode_args.fwnode;
> +	while (nprops--) {
> +		u32 val;
> +
> +		/* Loop over all child nodes under fwnode. */
> +		fwnode_for_each_child_node(fwnode, child) {
> +			if (fwnode_property_read_u32(child, *props, &val))
> +				continue;
> +
> +			/* Found property, see if its value matches. */
> +			if (val =3D=3D *args)
> +				break;
> +		}
> +
> +		fwnode_handle_put(fwnode);
> +
> +		/* No property found; return an error here. */
> +		if (!child) {
> +			fwnode =3D ERR_PTR(-ENOENT);
> +			break;
> +		}
> +
> +		props++;
> +		args++;
> +		fwnode =3D child;
> +	}
> +
> +	return fwnode;
> +}
> +
> +/*
> + * v4l2_fwnode_reference_parse_int_props - parse references for async
> + *					   sub-devices
> + * @dev: struct device pointer
> + * @notifier: notifier for @dev
> + * @prop: the name of the property
> + * @props: the array of integer property names
> + * @nprops: the number of integer properties
> + *
> + * Use v4l2_fwnode_reference_get_int_prop to find fwnodes through refere=
nce in
> + * property @prop with integer arguments with child nodes matching in pr=
operties
> + * @props. Then, set up V4L2 async sub-devices for those fwnodes in the =
notifier
> + * accordingly.
> + *
> + * While it is technically possible to use this function on DT, it is on=
ly
> + * meaningful on ACPI. On Device tree you can refer to any node in the t=
ree but
> + * on ACPI the references are limited to devices.
> + *
> + * Return: 0 on success
> + *	   -ENOENT if no entries (or the property itself) were found
> + *	   -EINVAL if property parsing otherwisefailed
> + *	   -ENOMEM if memory allocation failed
> + */
> +static int v4l2_fwnode_reference_parse_int_props(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	const char *prop, const char * const *props, unsigned int nprops)
> +{
> +	struct fwnode_handle *fwnode;
> +	unsigned int index;
> +	int ret;
> +
> +	for (index =3D 0; !IS_ERR((fwnode =3D v4l2_fwnode_reference_get_int_pro=
p(
> +					 dev_fwnode(dev), prop, index, props,
> +					 nprops))); index++)
> +		fwnode_handle_put(fwnode);
> +
> +	/*
> +	 * Note that right now both -ENODATA and -ENOENT may signal
> +	 * out-of-bounds access. Return the error in cases other than that.
> +	 */
> +	if (PTR_ERR(fwnode) !=3D -ENOENT && PTR_ERR(fwnode) !=3D -ENODATA)
> +		return PTR_ERR(fwnode);
> +
> +	ret =3D v4l2_async_notifier_realloc(notifier,
> +					  notifier->num_subdevs + index);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	for (index =3D 0; !IS_ERR((fwnode =3D v4l2_fwnode_reference_get_int_pro=
p(
> +					 dev_fwnode(dev), prop, index, props,
> +					 nprops))); index++) {
> +		struct v4l2_async_subdev *asd;
> +
> +		if (WARN_ON(notifier->num_subdevs >=3D notifier->max_subdevs)) {
> +			ret =3D -EINVAL;
> +			goto error;
> +		}
> +
> +		asd =3D kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
> +		if (!asd) {
> +			ret =3D -ENOMEM;
> +			goto error;
> +		}
> +
> +		notifier->subdevs[notifier->num_subdevs] =3D asd;
> +		asd->match.fwnode.fwnode =3D fwnode;
> +		asd->match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> +		notifier->num_subdevs++;
> +	}
> +
> +	return PTR_ERR(fwnode) =3D=3D -ENOENT ? 0 : PTR_ERR(fwnode);
> +
> +error:
> +	fwnode_handle_put(fwnode);
> +	return ret;
> +}
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> --=20
> 2.11.0
>=20

--rqx55atvefsahwls
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2XScACgkQ2O7X88g7
+pqTvw/+OcjD3yYF0wYNVhcoHk57nTYFo6eDPWWA/A0WsZQJdpW+DzMUukFXIAvy
7sNx1OTwmNijyd2rFT8zGffi2RlsFEfh7eZ7FOxjcfWED72DjkT2Pk1Qhn5th4rl
jxuKYHb2MFckCa6F9DGY4L462NxIAFIyCxQdpcdzvR+4QTZjmw9s6/6Q8614mXgw
QtF235Zl2sefQJTfrrnrzdMppUibVl1lIEqHQ9dnjU4Y6aHvyEoHzteREhK/Y2tM
NmMqaCbvj/jYeb1bzKybnrmt7JrVdNO2MZtGbPwvI+2iPdYrhvIGmGBvYZmHCuER
PnKtPrOEK9Y+68/BNVpzmgp6Xw0AxbWQD2zchruABp+UO2muf0UnvV3UgWZz72Hp
a70QQbFmk+pb6IqbRI6O50FF3lucZ8xt/z7opD/+LOwdO30EMvowGw+5s4zHd8kB
VZQh7cL+VWSvWHr416ilwFZ1T3S4Mk+pNYAj+kvZQwdbcmPg1kRW7jwVbsDRCYFE
+KI0ZTmpLBFJInXVbkHYHKw93/cVcPRLwmU0VMrzE7LQ0uzM8/GUfbFNOQnS8gxV
nzRRXlvuzm/2xncW5HRH6/o9deaXSfia6xufBKAv76scw1Ia1V0Yv6iVSE6j3A5h
GQqu9c91ePuLfReppT25hHlFRod1pP3z4s0lQLONQt/OmTxnI1k=
=QxUd
-----END PGP SIGNATURE-----

--rqx55atvefsahwls--
