Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbdJ0Oq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:46:58 -0400
Date: Fri, 27 Oct 2017 16:46:55 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 09/32] omap3isp: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20171027144655.nqjtxbsmjzxkv3f5@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-10-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iyy54ps7th2sam26"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-10-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iyy54ps7th2sam26
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:19AM +0300, Sakari Ailus wrote:
> Instead of using a custom driver implementation, use
> v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
> of the device.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/platform/omap3isp/isp.c | 121 +++++++++++-----------------=
------
>  drivers/media/platform/omap3isp/isp.h |   5 +-
>  2 files changed, 40 insertions(+), 86 deletions(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 1a428fe9f070..97a5206b6ddc 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2001,6 +2001,7 @@ static int isp_remove(struct platform_device *pdev)
>  	__omap3isp_put(isp, false);
> =20
>  	media_entity_enum_cleanup(&isp->crashed);
> +	v4l2_async_notifier_cleanup(&isp->notifier);
> =20
>  	return 0;
>  }
> @@ -2011,44 +2012,41 @@ enum isp_of_phy {
>  	ISP_OF_PHY_CSIPHY2,
>  };
> =20
> -static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fw=
node,
> -			    struct isp_async_subdev *isd)
> +static int isp_fwnode_parse(struct device *dev,
> +			    struct v4l2_fwnode_endpoint *vep,
> +			    struct v4l2_async_subdev *asd)
>  {
> +	struct isp_async_subdev *isd =3D
> +		container_of(asd, struct isp_async_subdev, asd);
>  	struct isp_bus_cfg *buscfg =3D &isd->bus;
> -	struct v4l2_fwnode_endpoint vep;
> -	unsigned int i;
> -	int ret;
>  	bool csi1 =3D false;
> -
> -	ret =3D v4l2_fwnode_endpoint_parse(fwnode, &vep);
> -	if (ret)
> -		return ret;
> +	unsigned int i;
> =20
>  	dev_dbg(dev, "parsing endpoint %pOF, interface %u\n",
> -		to_of_node(fwnode), vep.base.port);
> +		to_of_node(vep->base.local_fwnode), vep->base.port);
> =20
> -	switch (vep.base.port) {
> +	switch (vep->base.port) {
>  	case ISP_OF_PHY_PARALLEL:
>  		buscfg->interface =3D ISP_INTERFACE_PARALLEL;
>  		buscfg->bus.parallel.data_lane_shift =3D
> -			vep.bus.parallel.data_shift;
> +			vep->bus.parallel.data_shift;
>  		buscfg->bus.parallel.clk_pol =3D
> -			!!(vep.bus.parallel.flags
> +			!!(vep->bus.parallel.flags
>  			   & V4L2_MBUS_PCLK_SAMPLE_FALLING);
>  		buscfg->bus.parallel.hs_pol =3D
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
>  		buscfg->bus.parallel.vs_pol =3D
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
>  		buscfg->bus.parallel.fld_pol =3D
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
>  		buscfg->bus.parallel.data_pol =3D
> -			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> -		buscfg->bus.parallel.bt656 =3D vep.bus_type =3D=3D V4L2_MBUS_BT656;
> +			!!(vep->bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
> +		buscfg->bus.parallel.bt656 =3D vep->bus_type =3D=3D V4L2_MBUS_BT656;
>  		break;
> =20
>  	case ISP_OF_PHY_CSIPHY1:
>  	case ISP_OF_PHY_CSIPHY2:
> -		switch (vep.bus_type) {
> +		switch (vep->bus_type) {
>  		case V4L2_MBUS_CCP2:
>  		case V4L2_MBUS_CSI1:
>  			dev_dbg(dev, "CSI-1/CCP-2 configuration\n");
> @@ -2060,11 +2058,11 @@ static int isp_fwnode_parse(struct device *dev, s=
truct fwnode_handle *fwnode,
>  			break;
>  		default:
>  			dev_err(dev, "unsupported bus type %u\n",
> -				vep.bus_type);
> +				vep->bus_type);
>  			return -EINVAL;
>  		}
> =20
> -		switch (vep.base.port) {
> +		switch (vep->base.port) {
>  		case ISP_OF_PHY_CSIPHY1:
>  			if (csi1)
>  				buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY1;
> @@ -2080,47 +2078,47 @@ static int isp_fwnode_parse(struct device *dev, s=
truct fwnode_handle *fwnode,
>  		}
>  		if (csi1) {
>  			buscfg->bus.ccp2.lanecfg.clk.pos =3D
> -				vep.bus.mipi_csi1.clock_lane;
> +				vep->bus.mipi_csi1.clock_lane;
>  			buscfg->bus.ccp2.lanecfg.clk.pol =3D
> -				vep.bus.mipi_csi1.lane_polarity[0];
> +				vep->bus.mipi_csi1.lane_polarity[0];
>  			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
>  				buscfg->bus.ccp2.lanecfg.clk.pol,
>  				buscfg->bus.ccp2.lanecfg.clk.pos);
> =20
>  			buscfg->bus.ccp2.lanecfg.data[0].pos =3D
> -				vep.bus.mipi_csi1.data_lane;
> +				vep->bus.mipi_csi1.data_lane;
>  			buscfg->bus.ccp2.lanecfg.data[0].pol =3D
> -				vep.bus.mipi_csi1.lane_polarity[1];
> +				vep->bus.mipi_csi1.lane_polarity[1];
> =20
>  			dev_dbg(dev, "data lane polarity %u, pos %u\n",
>  				buscfg->bus.ccp2.lanecfg.data[0].pol,
>  				buscfg->bus.ccp2.lanecfg.data[0].pos);
> =20
>  			buscfg->bus.ccp2.strobe_clk_pol =3D
> -				vep.bus.mipi_csi1.clock_inv;
> -			buscfg->bus.ccp2.phy_layer =3D vep.bus.mipi_csi1.strobe;
> +				vep->bus.mipi_csi1.clock_inv;
> +			buscfg->bus.ccp2.phy_layer =3D vep->bus.mipi_csi1.strobe;
>  			buscfg->bus.ccp2.ccp2_mode =3D
> -				vep.bus_type =3D=3D V4L2_MBUS_CCP2;
> +				vep->bus_type =3D=3D V4L2_MBUS_CCP2;
>  			buscfg->bus.ccp2.vp_clk_pol =3D 1;
> =20
>  			buscfg->bus.ccp2.crc =3D 1;
>  		} else {
>  			buscfg->bus.csi2.lanecfg.clk.pos =3D
> -				vep.bus.mipi_csi2.clock_lane;
> +				vep->bus.mipi_csi2.clock_lane;
>  			buscfg->bus.csi2.lanecfg.clk.pol =3D
> -				vep.bus.mipi_csi2.lane_polarities[0];
> +				vep->bus.mipi_csi2.lane_polarities[0];
>  			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
>  				buscfg->bus.csi2.lanecfg.clk.pol,
>  				buscfg->bus.csi2.lanecfg.clk.pos);
> =20
>  			buscfg->bus.csi2.num_data_lanes =3D
> -				vep.bus.mipi_csi2.num_data_lanes;
> +				vep->bus.mipi_csi2.num_data_lanes;
> =20
>  			for (i =3D 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
>  				buscfg->bus.csi2.lanecfg.data[i].pos =3D
> -					vep.bus.mipi_csi2.data_lanes[i];
> +					vep->bus.mipi_csi2.data_lanes[i];
>  				buscfg->bus.csi2.lanecfg.data[i].pol =3D
> -					vep.bus.mipi_csi2.lane_polarities[i + 1];
> +					vep->bus.mipi_csi2.lane_polarities[i + 1];
>  				dev_dbg(dev,
>  					"data lane %u polarity %u, pos %u\n", i,
>  					buscfg->bus.csi2.lanecfg.data[i].pol,
> @@ -2137,57 +2135,13 @@ static int isp_fwnode_parse(struct device *dev, s=
truct fwnode_handle *fwnode,
> =20
>  	default:
>  		dev_warn(dev, "%pOF: invalid interface %u\n",
> -			 to_of_node(fwnode), vep.base.port);
> +			 to_of_node(vep->base.local_fwnode), vep->base.port);
>  		return -EINVAL;
>  	}
> =20
>  	return 0;
>  }
> =20
> -static int isp_fwnodes_parse(struct device *dev,
> -			     struct v4l2_async_notifier *notifier)
> -{
> -	struct fwnode_handle *fwnode =3D NULL;
> -
> -	notifier->subdevs =3D devm_kcalloc(
> -		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> -	if (!notifier->subdevs)
> -		return -ENOMEM;
> -
> -	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
> -	       (fwnode =3D fwnode_graph_get_next_endpoint(
> -			of_fwnode_handle(dev->of_node), fwnode))) {
> -		struct isp_async_subdev *isd;
> -
> -		isd =3D devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> -		if (!isd)
> -			goto error;
> -
> -		if (isp_fwnode_parse(dev, fwnode, isd)) {
> -			devm_kfree(dev, isd);
> -			continue;
> -		}
> -
> -		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
> -
> -		isd->asd.match.fwnode.fwnode =3D
> -			fwnode_graph_get_remote_port_parent(fwnode);
> -		if (!isd->asd.match.fwnode.fwnode) {
> -			dev_warn(dev, "bad remote port parent\n");
> -			goto error;
> -		}
> -
> -		isd->asd.match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> -		notifier->num_subdevs++;
> -	}
> -
> -	return notifier->num_subdevs;
> -
> -error:
> -	fwnode_handle_put(fwnode);
> -	return -EINVAL;
> -}
> -
>  static int isp_subdev_notifier_complete(struct v4l2_async_notifier *asyn=
c)
>  {
>  	struct isp_device *isp =3D container_of(async, struct isp_device,
> @@ -2256,15 +2210,17 @@ static int isp_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
> =20
> -	ret =3D isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> -	if (ret < 0)
> -		return ret;
> -
>  	isp->autoidle =3D autoidle;
> =20
>  	mutex_init(&isp->isp_mutex);
>  	spin_lock_init(&isp->stat_lock);
> =20
> +	ret =3D v4l2_async_notifier_parse_fwnode_endpoints(
> +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> +		isp_fwnode_parse);
> +	if (ret < 0)
> +		goto error;
> +
>  	isp->dev =3D &pdev->dev;
>  	isp->ref_count =3D 0;
> =20
> @@ -2406,6 +2362,7 @@ static int isp_probe(struct platform_device *pdev)
>  	isp_xclk_cleanup(isp);
>  	__omap3isp_put(isp, false);
>  error:
> +	v4l2_async_notifier_cleanup(&isp->notifier);
>  	mutex_destroy(&isp->isp_mutex);
> =20
>  	return ret;
> diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platfo=
rm/omap3isp/isp.h
> index e528df6efc09..8b9043db94b3 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -220,14 +220,11 @@ struct isp_device {
> =20
>  	unsigned int sbl_resources;
>  	unsigned int subclk_resources;
> -
> -#define ISP_MAX_SUBDEVS		8
> -	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
>  };
> =20
>  struct isp_async_subdev {
> -	struct isp_bus_cfg bus;
>  	struct v4l2_async_subdev asd;
> +	struct isp_bus_cfg bus;
>  };
> =20
>  #define v4l2_subdev_to_bus_cfg(sd) \
> --=20
> 2.11.0
>=20

--iyy54ps7th2sam26
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnzRt4ACgkQ2O7X88g7
+ppjvQ//YMv546+MWKGxq2wd5p92YZq154iPzGeBPIiWTzy8alWfpe1AlT6TMaZF
SQOvbd1BH52lw0CMVrRIx9VxdsgTReyT1NsXroMtbAl4hbSHxcsVWwaL1AgIYK2k
vAMY8GTW1OJaIan+6Csg3L6rVDcoAOJ4Bk8fipFl84ZqHL/otcmOfCT89W8hJp/6
bPF4NuzEGRVQVwE0lSw0DI819klagXjr3pl2hPu7Kuux+dswGGJFxdQp4cSCXTXI
/9hJUMv1nzNHWMi4bK5Jud2Xs4RiLxG0QoKkGx+/Hyu6dkIaqRvJtqhJBiQTep/d
+pFhk5tc5rRP1o8H2dZUAlNJvUyC0nkzinvzuRZpGbq+tWBis4zbDAwP7EaoLOqH
gfv6oYbfoj7z1OPwBYhOWCeFpwNhaVvrhI0kRtvqPgmTh5I7cP6eigICjFfm9qUH
188vd7G6LMMqUJenvZ1dfihSqmuBhf4U/pAUguVCSy2sshKmHYy3M8ATiBCaBqLG
36aNquEcdXKJgxHK6skrKmxWsj8d83ttR+Dm+d/Sy7oOG6ftbr/j8Sy6ytBjCXJt
Tkf+Tr2eRx76MGBMaSjbzqv9xSZUour1HIDq6j9LQHQSzvWf1TMM8iJ/grdDvQPm
KkaOMqmOZ2+RSZ7KB9GzAHX+9fVMIZJRL3cY9woY8/WLYONbpzo=
=I/iz
-----END PGP SIGNATURE-----

--iyy54ps7th2sam26--
