Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965313AbeBMTr0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 14:47:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 21/30] rcar-vin: prepare for media controller mode initialization
Date: Tue, 13 Feb 2018 21:47:57 +0200
Message-ID: <1559027.XcBvLPVQMx@avalon>
In-Reply-To: <20180129163435.24936-22-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-22-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:26 EET Niklas S=F6derlund wrote:
> Prepare for media controller by calling a different initialization then
> for when running in device centric mode. Add trivial configuration of

s/then for when/than when/

> the mbus and creation of the media pad for the video device entity.
>=20
> While we are at it clearly mark the digital device centric notifier
> functions with a comment.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 20 ++++++++++++++++++--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  4 ++++
>  2 files changed, 22 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 64034c96f384b3ed..0c6960756c33f86c 100644
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
>  /* The vin lock shuld be held when calling the subdevice attach and deta=
ch
> */ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
>  					 struct v4l2_subdev *subdev)
> @@ -237,6 +241,16 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin) return 0;
>  }
>=20
> +static int rvin_mc_init(struct rvin_dev *vin)
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
> @@ -325,8 +339,10 @@ static int rcar_vin_probe(struct platform_device *pd=
ev)
> return ret;
>=20
>  	platform_set_drvdata(pdev, vin);
> -
> -	ret =3D rvin_digital_graph_init(vin);
> +	if (vin->info->use_mc)
> +		ret =3D rvin_mc_init(vin);
> +	else
> +		ret =3D rvin_digital_graph_init(vin);
>  	if (ret < 0)
>  		goto error;
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 64476bc5c8abc6d0..4caef7193db09c5b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -101,6 +101,8 @@ struct rvin_info {
>   * @notifier:		V4L2 asynchronous subdevs notifier
>   * @digital:		entity in the DT for local digital subdevice
>   *
> + * @pad:		media pad for the video device entity
> + *
>   * @lock:		protects @queue
>   * @queue:		vb2 buffers queue
>   *
> @@ -130,6 +132,8 @@ struct rvin_dev {
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
