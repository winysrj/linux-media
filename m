Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52810 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeJEE4b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 00:56:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v2 4/5] i2c: adv748x: store number of CSI-2 lanes described in device tree
Date: Fri, 05 Oct 2018 01:01:23 +0300
Message-ID: <5420652.F4rqdW9J1k@avalon>
In-Reply-To: <20181004204138.2784-5-niklas.soderlund@ragnatech.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se> <20181004204138.2784-5-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 4 October 2018 23:41:37 EEST Niklas S=F6derlund wrote:
> From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> The adv748x CSI-2 transmitters TXA and TXB can use different number of
> lanes to transmit data. In order to be able to configure the device
> correctly this information need to be parsed from device tree and stored
> in each TX private data structure.
>=20
> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.

TXB doesn't really support a configurable number of lanes then, does it ? :=
=2D)=20
Should we skip the parsing for TXB ?

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> ---
> * Changes since v1
> - Use %u instead of %d to print unsigned int.
> - Fix spelling in commit message, thanks Laurent.
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 49 ++++++++++++++++++++++++
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  2 files changed, 50 insertions(+)
>=20
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index
> 41cc0cdd6a5fcef5..3836dd3025d6ffb7 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -23,6 +23,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-ioctl.h>
>=20
>  #include "adv748x.h"
> @@ -523,12 +524,55 @@ void adv748x_subdev_init(struct v4l2_subdev *sd,
> struct adv748x_state *state, sd->entity.ops =3D &adv748x_media_ops;
>  }
>=20
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
>=20
>  	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
>  		of_graph_parse_endpoint(ep_np, &ep);
> @@ -559,6 +603,11 @@ static int adv748x_parse_dt(struct adv748x_state
> *state) in_found =3D true;
>  		else
>  			out_found =3D true;
> +
> +		/* Store number of CSI-2 lanes used for TXA and TXB. */
> +		ret =3D adv748x_parse_csi2_lanes(state, ep.port, ep_np);
> +		if (ret)
> +			return ret;
>  	}
>=20
>  	return in_found && out_found ? 0 : -ENODEV;
> diff --git a/drivers/media/i2c/adv748x/adv748x.h
> b/drivers/media/i2c/adv748x/adv748x.h index
> 39c2fdc3b41667d8..b482c7fe6957eb85 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -79,6 +79,7 @@ struct adv748x_csi2 {
>  	struct v4l2_mbus_framefmt format;
>  	unsigned int page;
>  	unsigned int port;
> +	unsigned int num_lanes;
>=20
>  	struct media_pad pads[ADV748X_CSI2_NR_PADS];
>  	struct v4l2_ctrl_handler ctrl_hdl;

=2D-=20
Regards,

Laurent Pinchart
