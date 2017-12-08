Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47443 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdLHKTp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 05:19:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 20/28] rcar-vin: prepare for media controller mode initialization
Date: Fri, 08 Dec 2017 12:20:03 +0200
Message-ID: <2652701.gWqqUxWku6@avalon>
In-Reply-To: <20171208010842.20047-21-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-21-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:34 EET Niklas S=F6derlund wrote:
> When running in media controller mode a media pad is needed, register
> one. Also set the media bus format to CSI-2.

This sounds a bit unclear to me. We don't need a pad for the sake of it, wh=
at=20
we need to do is to initialize the entity of the device device. I'd rephras=
e=20
the commit message accordingly.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 24 ++++++++++++++++++++++--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  4 ++++
>  2 files changed, 26 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 61f48ecc1ab815ec..45de4079fd835759 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -46,6 +46,10 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int
> direction) return -EINVAL;
>  }
>=20
> +/* ---------------------------------------------------------------------=
=2D--
> + * Digital async notifier
> + */
> +
>  static int rvin_digital_notify_complete(struct v4l2_async_notifier
> *notifier) {
>  	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> @@ -226,6 +230,20 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin) return 0;
>  }
>=20
> +/* ---------------------------------------------------------------------=
=2D--
> + * Group async notifier

The function below isn't related to async notifiers. This might change in=20
latter patches, but I'd make the section name consistent with the=20
implementation here, and change it later if needed.

> + */
> +
> +static int rvin_group_init(struct rvin_dev *vin)
> +{
> +	/* All our sources are CSI-2 */
> +	vin->mbus_cfg.type =3D V4L2_MBUS_CSI2;
> +	vin->mbus_cfg.flags =3D 0;
> +
> +	vin->pad.flags =3D MEDIA_PAD_FL_SINK;
> +	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> +}
> +
>  /* ---------------------------------------------------------------------=
=2D--
>   * Platform Device Driver
>   */
> @@ -314,8 +332,10 @@ static int rcar_vin_probe(struct platform_device *pd=
ev)
> return ret;
>=20
>  	platform_set_drvdata(pdev, vin);
> -
> -	ret =3D rvin_digital_graph_init(vin);
> +	if (vin->info->use_mc)
> +		ret =3D rvin_group_init(vin);
> +	else
> +		ret =3D rvin_digital_graph_init(vin);
>  	if (ret < 0)
>  		goto error;
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> fd3cd781be0ab1cf..07d270a976893cdb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -103,6 +103,8 @@ struct rvin_info {
>   * @notifier:		V4L2 asynchronous subdevs notifier
>   * @digital:		entity in the DT for local digital subdevice
>   *
> + * @pad:		pad for media controller

I'd rephrase this too based on the comment I made regarding the commit=20
message.

>   * @lock:		protects @queue
>   * @queue:		vb2 buffers queue
>   *
> @@ -132,6 +134,8 @@ struct rvin_dev {
>  	struct v4l2_async_notifier notifier;
>  	struct rvin_graph_entity *digital;
>=20
> +	struct media_pad pad;
> +
>  	struct mutex lock;
>  	struct vb2_queue queue;

=2D-=20
Regards,

Laurent Pinchart
