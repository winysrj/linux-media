Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52239 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdLHUhe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 15:37:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 22/28] rcar-vin: add chsel information to rvin_info
Date: Fri, 08 Dec 2017 22:37:32 +0200
Message-ID: <3365456.tkQHTjy9nj@avalon>
In-Reply-To: <20171208010842.20047-23-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-23-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:36 EET Niklas S=F6derlund wrote:
> Each Gen3 SoC has a limited set of predefined routing possibilities for
> which CSI-2 device and virtual channel can be routed to which VIN
> instance. Prepare to store this information in the struct rvin_info.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-vin.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 5f736a3500b6e10f..41bf24aa8a1a0aed 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -35,6 +35,9 @@
>  /* Max number on VIN instances that can be in a system */
>  #define RCAR_VIN_NUM 8
>=20
> +/* Max number of CHSEL values for any Gen3 SoC */
> +#define RCAR_CHSEL_MAX 6
> +
>  enum chip_id {
>  	RCAR_H1,
>  	RCAR_M1,
> @@ -91,6 +94,22 @@ struct rvin_graph_entity {
>=20
>  struct rvin_group;
>=20
> +/** struct rvin_group_chsel - Map a CSI-2 receiver and channel to a CHSEL
> value
> + * @csi:		VIN internal number for CSI-2 device
> + * @chan:		Output channel of the CSI-2 receiver. Each R-Car CSI-2
> + *			receiver has four output channels facing the VIN
> + *			devices, each channel can carry one CSI-2 Virtual
> + *			Channel (VC) and there are no correlation between
> + *			output channel number and CSI-2 VC. It's up to the
> + *			CSI-2 receiver driver to configure which VC is
> + *			outputted on which channel, the VIN devices only
> + *			cares about output channels.
> + */
> +struct rvin_group_chsel {
> +	enum rvin_csi_id csi;
> +	unsigned int chan;
> +};
> +
>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @chip:		type of VIN chip
> @@ -98,6 +117,9 @@ struct rvin_group;
>   *
>   * max_width:		max input width the VIN supports
>   * max_height:		max input height the VIN supports
> + *
> + * num_chsels:		number of possible chsel values for this VIN
> + * chsels:		routing table VIN <-> CSI-2 for the chsel values
>   */
>  struct rvin_info {
>  	enum chip_id chip;
> @@ -105,6 +127,9 @@ struct rvin_info {
>=20
>  	unsigned int max_width;
>  	unsigned int max_height;
> +
> +	unsigned int num_chsels;
> +	struct rvin_group_chsel chsels[RCAR_VIN_NUM][RCAR_CHSEL_MAX];

That will result in a quite sparse array. I wonder whether we couldn't inst=
ead=20
have an array of num_chsels elements storing the CSI receiver ID, the CSI=20
receiver output channel, and the VIN ID.

=46urthermore, shouldn't the CSI receiver ID be specified in DT using the=20
renesas,id property like we do for the VIN instances, instead of through th=
e=20
endpoint number ? I know this will require a bit of refactoring, but I thin=
k=20
it would stimplify both the DT bindings and the code as we wouldn't hardcod=
e a=20
fixed set of CSI receivers.

>  };
>=20
>  /**

=2D-=20
Regards,

Laurent Pinchart
