Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36205 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRI5f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 04:57:35 -0400
Date: Tue, 18 Jul 2017 10:57:31 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pavel@ucw.cz, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/7] omap3isp: Parse CSI1 configuration from the device
 tree
Message-ID: <20170718085731.jizljcu77sg6txx6@earth>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2likafikjcbvsyfb"
Content-Disposition: inline
In-Reply-To: <20170717220116.17886-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2likafikjcbvsyfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 18, 2017 at 01:01:11AM +0300, Sakari Ailus wrote:
> From: Pavel Machek <pavel@ucw.cz>
>=20
> Add support for parsing CSI1 configuration.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/platform/omap3isp/isp.c      | 106 +++++++++++++++++++++--=
------
>  drivers/media/platform/omap3isp/omap3isp.h |   1 +
>  2 files changed, 80 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 441eba1e02eb..80ed5a5f862a 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2017,6 +2017,7 @@ static int isp_fwnode_parse(struct device *dev, str=
uct fwnode_handle *fwnode,
>  	struct v4l2_fwnode_endpoint vep;
>  	unsigned int i;
>  	int ret;
> +	bool csi1 =3D false;
> =20
>  	ret =3D v4l2_fwnode_endpoint_parse(fwnode, &vep);
>  	if (ret)
> @@ -2045,41 +2046,92 @@ static int isp_fwnode_parse(struct device *dev, s=
truct fwnode_handle *fwnode,
> =20
>  	case ISP_OF_PHY_CSIPHY1:
>  	case ISP_OF_PHY_CSIPHY2:
> -		/* FIXME: always assume CSI-2 for now. */
> +		switch (vep.bus_type) {
> +		case V4L2_MBUS_CCP2:
> +		case V4L2_MBUS_CSI1:
> +			dev_dbg(dev, "csi1/ccp2 configuration\n");
> +			csi1 =3D true;
> +			break;
> +		case V4L2_MBUS_CSI2:
> +			dev_dbg(dev, "csi2 configuration\n");
> +			csi1 =3D false;
> +			break;
> +		default:
> +			dev_err(dev, "unsupported bus type %u\n",
> +				vep.bus_type);
> +			return -EINVAL;
> +		}
> +
>  		switch (vep.base.port) {
>  		case ISP_OF_PHY_CSIPHY1:
> -			buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
> +			if (csi1)
> +				buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY1;
> +			else
> +				buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
>  			break;
>  		case ISP_OF_PHY_CSIPHY2:
> -			buscfg->interface =3D ISP_INTERFACE_CSI2A_PHY2;
> +			if (csi1)
> +				buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY2;
> +			else
> +				buscfg->interface =3D ISP_INTERFACE_CSI2A_PHY2;
>  			break;
>  		}
> -		buscfg->bus.csi2.lanecfg.clk.pos =3D vep.bus.mipi_csi2.clock_lane;
> -		buscfg->bus.csi2.lanecfg.clk.pol =3D
> -			vep.bus.mipi_csi2.lane_polarities[0];
> -		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> -			buscfg->bus.csi2.lanecfg.clk.pol,
> -			buscfg->bus.csi2.lanecfg.clk.pos);
> -
> -		buscfg->bus.csi2.num_data_lanes =3D
> -			vep.bus.mipi_csi2.num_data_lanes;
> -
> -		for (i =3D 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
> -			buscfg->bus.csi2.lanecfg.data[i].pos =3D
> -				vep.bus.mipi_csi2.data_lanes[i];
> -			buscfg->bus.csi2.lanecfg.data[i].pol =3D
> -				vep.bus.mipi_csi2.lane_polarities[i + 1];
> +		if (csi1) {
> +			buscfg->bus.ccp2.lanecfg.clk.pos =3D
> +				vep.bus.mipi_csi1.clock_lane;
> +			buscfg->bus.ccp2.lanecfg.clk.pol =3D
> +				vep.bus.mipi_csi1.lane_polarity[0];
> +			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> +				buscfg->bus.ccp2.lanecfg.clk.pol,
> +				buscfg->bus.ccp2.lanecfg.clk.pos);
> +
> +			buscfg->bus.ccp2.lanecfg.data[0].pos =3D
> +				vep.bus.mipi_csi1.data_lane;
> +			buscfg->bus.ccp2.lanecfg.data[0].pol =3D
> +				vep.bus.mipi_csi1.lane_polarity[1];
> +
>  			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> -				buscfg->bus.csi2.lanecfg.data[i].pol,
> -				buscfg->bus.csi2.lanecfg.data[i].pos);
> +				buscfg->bus.ccp2.lanecfg.data[0].pol,
> +				buscfg->bus.ccp2.lanecfg.data[0].pos);
> +
> +			buscfg->bus.ccp2.strobe_clk_pol =3D
> +				vep.bus.mipi_csi1.clock_inv;
> +			buscfg->bus.ccp2.phy_layer =3D vep.bus.mipi_csi1.strobe;
> +			buscfg->bus.ccp2.ccp2_mode =3D
> +				vep.bus_type =3D=3D V4L2_MBUS_CCP2;
> +			buscfg->bus.ccp2.vp_clk_pol =3D 1;
> +
> +			buscfg->bus.ccp2.crc =3D 1;
> +		} else {
> +			buscfg->bus.csi2.lanecfg.clk.pos =3D
> +				vep.bus.mipi_csi2.clock_lane;
> +			buscfg->bus.csi2.lanecfg.clk.pol =3D
> +				vep.bus.mipi_csi2.lane_polarities[0];
> +			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> +				buscfg->bus.csi2.lanecfg.clk.pol,
> +				buscfg->bus.csi2.lanecfg.clk.pos);
> +
> +			buscfg->bus.csi2.num_data_lanes =3D
> +				vep.bus.mipi_csi2.num_data_lanes;
> +
> +			for (i =3D 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
> +				buscfg->bus.csi2.lanecfg.data[i].pos =3D
> +					vep.bus.mipi_csi2.data_lanes[i];
> +				buscfg->bus.csi2.lanecfg.data[i].pol =3D
> +					vep.bus.mipi_csi2.lane_polarities[i + 1];
> +				dev_dbg(dev,
> +					"data lane %u polarity %u, pos %u\n", i,
> +					buscfg->bus.csi2.lanecfg.data[i].pol,
> +					buscfg->bus.csi2.lanecfg.data[i].pos);
> +			}
> +			/*
> +			 * FIXME: now we assume the CRC is always there.
> +			 * Implement a way to obtain this information from the
> +			 * sensor. Frame descriptors, perhaps?
> +			 */
> +
> +			buscfg->bus.csi2.crc =3D 1;
>  		}
> -
> -		/*
> -		 * FIXME: now we assume the CRC is always there.
> -		 * Implement a way to obtain this information from the
> -		 * sensor. Frame descriptors, perhaps?
> -		 */
> -		buscfg->bus.csi2.crc =3D 1;
>  		break;
> =20
>  	default:
> diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/p=
latform/omap3isp/omap3isp.h
> index 3c26f9a3f508..672a9cf5aa4d 100644
> --- a/drivers/media/platform/omap3isp/omap3isp.h
> +++ b/drivers/media/platform/omap3isp/omap3isp.h
> @@ -108,6 +108,7 @@ struct isp_ccp2_cfg {
>  	unsigned int ccp2_mode:1;
>  	unsigned int phy_layer:1;
>  	unsigned int vpclk_div:2;
> +	unsigned int vp_clk_pol:1;
>  	struct isp_csiphy_lanes_cfg lanecfg;
>  };
> =20
> --=20
> 2.11.0
>=20

--2likafikjcbvsyfb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlltzXsACgkQ2O7X88g7
+prhlxAApEYHGykcoejUTr8xg05ce03Nq8aVAzmI3StiVBfRZb0/FUMxAccPZszT
Kd2/Gu0J3t4lcaDIofmDJoNnvZWtAK6TSNgbIN4eJtFU6VEu4tTgTnncl9skSnZ1
GEPeFFPQUzQP+/KjVKWnYpJnvNVmWjydJIW3J2hyUvYhIOaOmQCcKsFMG+Nh1gHJ
+z/4mDZF/iuTP1/L6ZwoZfTEpUwCzITszKhLluwxm810/FpClqFe9y5eX1xYFkZ8
gNi7IZ+fCuLQTbonuGIXvB8ubDS43M/iYRIQSKbxwmJkUw4mdJZVlJ2u4Xe+xGbb
E7MpXAljLnYf+dlYmCSE6KeHW/XUfrympBwfSDZ22NfQeD+de7vumyvrTz6XS4X9
0hZjokph0Fm+whNKy4J/2u/DRLcnQakNQzpcEIzK4rk7Gaov5FKCQX3vlThnbEsk
yME3t6pzizuhi8mtQHyR8c8TtsfwNFNwOiHJs540su/EMGxIbICgisomA6lYuLCS
TxewJmJuGFKcGs/x+OpxVGlfKLTcRvSV1QHkRuoyGp1fcpzrXbFWJU7/6hqGzpYT
ECQ1ZjZO1Enw05bDoTo9r0qu9kRhYMJvt+kqyIn59INsreTdWoaMfMycEhGxq7bd
fYVG9oVGhTtFBMXHexTtLCwnwekUIabo2Z2qUL0YIeAnVL+V+nE=
=m1v7
-----END PGP SIGNATURE-----

--2likafikjcbvsyfb--
