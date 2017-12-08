Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47344 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752723AbdLHJwj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:52:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 17/28] rcar-vin: add flag to switch to media controller mode
Date: Fri, 08 Dec 2017 11:52:56 +0200
Message-ID: <1925583.pJDgAjopo5@avalon>
In-Reply-To: <20171208010842.20047-18-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-18-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:31 EET Niklas S=F6derlund wrote:
> On Gen3 a media controller API needs to be used to allow userspace to
> configure the subdevices in the pipeline instead of directly controlling
> a single source subdevice, which is and will continue to be the mode of
> operation on Gen2.
>=20
> Prepare for these two modes of operation by adding a flag to struct
> rvin_info which will control which mode to use.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 6 +++++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 7d49904cab9cb2d9..61f48ecc1ab815ec 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -232,18 +232,21 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin)
>=20
>  static const struct rvin_info rcar_info_h1 =3D {
>  	.chip =3D RCAR_H1,
> +	.use_mc =3D false,
>  	.max_width =3D 2048,
>  	.max_height =3D 2048,
>  };
>=20
>  static const struct rvin_info rcar_info_m1 =3D {
>  	.chip =3D RCAR_M1,
> +	.use_mc =3D false,
>  	.max_width =3D 2048,
>  	.max_height =3D 2048,
>  };
>=20
>  static const struct rvin_info rcar_info_gen2 =3D {
>  	.chip =3D RCAR_GEN2,
> +	.use_mc =3D false,
>  	.max_width =3D 2048,
>  	.max_height =3D 2048,
>  };
> @@ -338,7 +341,8 @@ static int rcar_vin_remove(struct platform_device *pd=
ev)
> v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>=20
> -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +	if (!vin->info->use_mc)
> +		v4l2_ctrl_handler_free(&vin->ctrl_handler);
>=20
>  	rvin_dma_unregister(vin);
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 7819c760c2c13422..0747873c2b9cb74c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -77,12 +77,14 @@ struct rvin_graph_entity {
>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @chip:		type of VIN chip
> + * @use_mc:		use media controller instead of controlling subdevice
>   *
>   * max_width:		max input width the VIN supports
>   * max_height:		max input height the VIN supports
>   */
>  struct rvin_info {
>  	enum chip_id chip;
> +	bool use_mc;
>=20
>  	unsigned int max_width;
>  	unsigned int max_height;


=2D-=20
Regards,

Laurent Pinchart
