Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51466 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965610AbeBMUTW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 15:19:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 24/30] rcar-vin: add chsel information to rvin_info
Date: Tue, 13 Feb 2018 22:19:53 +0200
Message-ID: <27633644.2B73Dt8uGP@avalon>
In-Reply-To: <20180129163435.24936-25-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-25-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:29 EET Niklas S=F6derlund wrote:
> Each Gen3 SoC has a limited set of predefined routing possibilities for
> which CSI-2 device and virtual channel can be routed to which VIN
> instance. Prepare to store this information in the struct rvin_info.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-vin.h | 30 ++++++++++++++++++++++++=
+++
>  1 file changed, 30 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 903d8fb8426a7860..ca2c2a23cef8506c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -43,6 +43,14 @@ enum model_id {
>  	RCAR_GEN3,
>  };
>=20
> +enum rvin_csi_id {
> +	RVIN_CSI20,
> +	RVIN_CSI21,
> +	RVIN_CSI40,
> +	RVIN_CSI41,
> +	RVIN_CSI_MAX,
> +};
> +
>  /**
>   * STOPPED  - No operation in progress
>   * RUNNING  - Operation in progress have buffers
> @@ -81,12 +89,33 @@ struct rvin_graph_entity {
>  	unsigned int sink_pad;
>  };
>=20
> +/** struct rvin_group_route - Map a CSI-2 receiver and channel to a CHSEL

If my understanding is correct an entry describes a route from a channel of=
 a=20
CSI-2 receiver to a VIN, and how to configure the hardware to enable that=20
route (in the mask field). Could you expand this single line of documentati=
on=20
to explain that more clearly ?

> + * @vin:		Which VIN the CSI-2 and VC describes

VC ? Is that virtual channel ? Isn't that internal to the CSI-2 receiver on=
ly=20
?

> + * @csi:		VIN internal number for CSI-2 device

Or just "CSI-2 receiver ID" ?

> + * @chan:		Output channel of the CSI-2 receiver. Each R-Car CSI-2

Would "channel" be too long ?

> + *			receiver has four output channels facing the VIN
> + *			devices, each channel can carry one CSI-2 Virtual
> + *			Channel (VC) and there are no correlation between
> + *			output channel number and CSI-2 VC. It's up to the
> + *			CSI-2 receiver driver to configure which VC is
> + *			outputted on which channel, the VIN devices only

s/outputted/output/

> + *			cares about output channels.

s/cares/care/

> + * @mask:		Bitmask of chsel values which accommodates route

s/which/that/

Reading the documentation I'm not sure to understand how this works. In=20
particular the mask field documentation isn't clear enough.

> + */
> +struct rvin_group_route {
> +	unsigned int vin;
> +	enum rvin_csi_id csi;
> +	unsigned char chan;

You can make this an unsigned int, the compiler will pad the field anyway.

I think it would be clearer to order the fields in "from -> to: configurati=
on"=20
order (csi, channel, vin, mask).

> +	unsigned int mask;
> +};
> +
>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @model:		VIN model
>   * @use_mc:		use media controller instead of controlling subdevice
>   * @max_width:		max input width the VIN supports
>   * @max_height:		max input height the VIN supports
> + * @routes:		routing table VIN <-> CSI-2 for the chsel values
>   */
>  struct rvin_info {
>  	enum model_id model;
> @@ -94,6 +123,7 @@ struct rvin_info {
>=20
>  	unsigned int max_width;
>  	unsigned int max_height;
> +	const struct rvin_group_route *routes;
>  };
>=20
>  /**

=2D-=20
Regards,

Laurent Pinchart
