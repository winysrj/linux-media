Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39763 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeKESRQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 13:17:16 -0500
Date: Mon, 5 Nov 2018 09:58:33 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 3/4] i2c: adv748x: store number of CSI-2 lanes
 described in device tree
Message-ID: <20181105085833.GG20885@w540>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
 <20181102160009.17267-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wayzTnRSUXKNfBqd"
Content-Disposition: inline
In-Reply-To: <20181102160009.17267-4-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wayzTnRSUXKNfBqd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,
   thanks for the patches

On Fri, Nov 02, 2018 at 05:00:08PM +0100, Niklas S=C3=B6derlund wrote:
> The adv748x CSI-2 transmitters TXA and TXB can use different number of
> lanes to transmit data. In order to be able to configure the device
> correctly this information need to be parsed from device tree and stored
> in each TX private data structure.
>
> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>

Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
   j

>
> ---
> * Changes since v2
> - Rebase to latest media-tree requires the bus_type filed in struct
>   v4l2_fwnode_endpoint to be initialized, set it to V4L2_MBUS_CSI2_DPHY.
>
> * Changes since v1
> - Use %u instead of %d to print unsigned int.
> - Fix spelling in commit message, thanks Laurent.
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 50 ++++++++++++++++++++++++
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  2 files changed, 51 insertions(+)
>
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c=
/adv748x/adv748x-core.c
> index 2384f50dacb0ccff..9d80d7f3062b16bc 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -23,6 +23,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-ioctl.h>
>
>  #include "adv748x.h"
> @@ -521,12 +522,56 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, st=
ruct adv748x_state *state,
>  	sd->entity.ops =3D &adv748x_media_ops;
>  }
>
> +static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> +				    unsigned int port,
> +				    struct device_node *ep)
> +{
> +	struct v4l2_fwnode_endpoint vep;
> +	unsigned int num_lanes;
> +	int ret;
> +
> +	if (port !=3D ADV748X_PORT_TXA && port !=3D ADV748X_PORT_TXB)
> +		return 0;
> +
> +	vep.bus_type =3D V4L2_MBUS_CSI2_DPHY;
> +	ret =3D v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &vep);
> +	if (ret)
> +		return ret;
> +
> +	num_lanes =3D vep.bus.mipi_csi2.num_data_lanes;
> +
> +	if (vep.base.port =3D=3D ADV748X_PORT_TXA) {
> +		if (num_lanes !=3D 1 && num_lanes !=3D 2 && num_lanes !=3D 4) {
> +			adv_err(state, "TXA: Invalid number (%u) of lanes\n",
> +				num_lanes);
> +			return -EINVAL;
> +		}
> +
> +		state->txa.num_lanes =3D num_lanes;
> +		adv_dbg(state, "TXA: using %u lanes\n", state->txa.num_lanes);
> +	}
> +
> +	if (vep.base.port =3D=3D ADV748X_PORT_TXB) {
> +		if (num_lanes !=3D 1) {
> +			adv_err(state, "TXB: Invalid number (%u) of lanes\n",
> +				num_lanes);
> +			return -EINVAL;
> +		}
> +
> +		state->txb.num_lanes =3D num_lanes;
> +		adv_dbg(state, "TXB: using %u lanes\n", state->txb.num_lanes);
> +	}
> +
> +	return 0;
> +}
> +
>  static int adv748x_parse_dt(struct adv748x_state *state)
>  {
>  	struct device_node *ep_np =3D NULL;
>  	struct of_endpoint ep;
>  	bool out_found =3D false;
>  	bool in_found =3D false;
> +	int ret;
>
>  	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
>  		of_graph_parse_endpoint(ep_np, &ep);
> @@ -557,6 +602,11 @@ static int adv748x_parse_dt(struct adv748x_state *st=
ate)
>  			in_found =3D true;
>  		else
>  			out_found =3D true;
> +
> +		/* Store number of CSI-2 lanes used for TXA and TXB. */
> +		ret =3D adv748x_parse_csi2_lanes(state, ep.port, ep_np);
> +		if (ret)
> +			return ret;
>  	}
>
>  	return in_found && out_found ? 0 : -ENODEV;
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv7=
48x/adv748x.h
> index 39c2fdc3b41667d8..b482c7fe6957eb85 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -79,6 +79,7 @@ struct adv748x_csi2 {
>  	struct v4l2_mbus_framefmt format;
>  	unsigned int page;
>  	unsigned int port;
> +	unsigned int num_lanes;
>
>  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
>  	struct v4l2_ctrl_handler ctrl_hdl;
> --
> 2.19.1
>

--wayzTnRSUXKNfBqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb4AY5AAoJEHI0Bo8WoVY8WnYP/2QUnfQU0HbFfUKG1JWwB+aC
3TtRSxm08z6yfRnVu/KwySeQ2h/k6UNG6OBZYWNYdpu/C09tflDqrT9bOJg3YjpG
QHkkXG/HVPNLHRC3kcK8ojHHZKMryCBmIN2gSivhviiuaAmQOdo3TjsmkLOpw7wv
TPDzJkWve1ESAx32HbjMN9YmZMI+7dlfTZzF9eY7dOlpMuVRt9qsHn4mV3MF4j6h
DmZSmrxGDXNlZNzKoD6nZYyye/KZxzAAxhz/wLyHNuqJdNsMCuVx8aQqIfW5I3HZ
uRym4gJ9xQCMrNyEhLhOxZ4J5G4Mqyr0UJQYzbkG6B9BfRZBn8PCYVyvzNrtCDs2
Kr8WDRqMcWVxaILb7hlCYbdVsUdAvQJodjdlkfa6PQZJ4Qaxjv2mc9Ju2Wwmp/Yf
ZH57KKO0raAck6ETiJ2YeeuyWL9YK3e2EEniCnvZ5E0bBckJ3KuCkRTtSs2f4/kD
5w/33B7eI54RAEVyIiDkPUUd4c+AoXF/Qg4+bx2ROKtElBCPwveIiY0KL3DaVNKD
K4mbGxtfxhfsdwXyQ/jmLOkF5v7KQXd0PUxyAz5uO5DPD4eDORD+PDD2IMBd9/8V
SlK47FDFdmSqhTm38nhe4C3xU3uoYN5gGoExXNN9AeCaAluUyX8OHcwT4gGjeudw
+Wfgopf/0OPOL09dKgl2
=n9/R
-----END PGP SIGNATURE-----

--wayzTnRSUXKNfBqd--
