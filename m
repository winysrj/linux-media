Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46673 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdLHHth (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 02:49:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 02/28] rcar-vin: rename poorly named initialize and cleanup functions
Date: Fri, 08 Dec 2017 09:49:55 +0200
Message-ID: <2110291.QZbtxhzeLr@avalon>
In-Reply-To: <20171208010842.20047-3-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:16 EET Niklas S=F6derlund wrote:
> The functions to initialize and cleanup the hardware and video device
> where poorly named from the start. Rename them to better describe their
> intended function.

It's interesting that you describe the functions' purpose as initialize and=
=20
cleanup here and name them register and unregister :-) It's not a big deal,=
=20
but you might want some consistency between the commit message and the code.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Either way,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 10 +++++-----
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  6 +++---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  4 ++--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  8 ++++----
>  4 files changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 108d776f32651b27..f7a4c21909da6923 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -93,7 +93,7 @@ static int rvin_digital_notify_complete(struct
> v4l2_async_notifier *notifier) return ret;
>  	}
>=20
> -	return rvin_v4l2_probe(vin);
> +	return rvin_v4l2_register(vin);
>  }
>=20
>  static void rvin_digital_notify_unbind(struct v4l2_async_notifier
> *notifier, @@ -103,7 +103,7 @@ static void
> rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier, struct
> rvin_dev *vin =3D notifier_to_vin(notifier);
>=20
>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> -	rvin_v4l2_remove(vin);
> +	rvin_v4l2_unregister(vin);
>  	vin->digital->subdev =3D NULL;
>  }
>=20
> @@ -245,7 +245,7 @@ static int rcar_vin_probe(struct platform_device *pde=
v)
>  	if (irq < 0)
>  		return irq;
>=20
> -	ret =3D rvin_dma_probe(vin, irq);
> +	ret =3D rvin_dma_register(vin, irq);
>  	if (ret)
>  		return ret;
>=20
> @@ -260,7 +260,7 @@ static int rcar_vin_probe(struct platform_device *pde=
v)
>=20
>  	return 0;
>  error:
> -	rvin_dma_remove(vin);
> +	rvin_dma_unregister(vin);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>=20
>  	return ret;
> @@ -275,7 +275,7 @@ static int rcar_vin_remove(struct platform_device *pd=
ev)
> v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>=20
> -	rvin_dma_remove(vin);
> +	rvin_dma_unregister(vin);
>=20
>  	return 0;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 23fdff7a7370842e..d701b52d198243b5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1153,14 +1153,14 @@ static const struct vb2_ops rvin_qops =3D {
>  	.wait_finish		=3D vb2_ops_wait_finish,
>  };
>=20
> -void rvin_dma_remove(struct rvin_dev *vin)
> +void rvin_dma_unregister(struct rvin_dev *vin)
>  {
>  	mutex_destroy(&vin->lock);
>=20
>  	v4l2_device_unregister(&vin->v4l2_dev);
>  }
>=20
> -int rvin_dma_probe(struct rvin_dev *vin, int irq)
> +int rvin_dma_register(struct rvin_dev *vin, int irq)
>  {
>  	struct vb2_queue *q =3D &vin->queue;
>  	int i, ret;
> @@ -1208,7 +1208,7 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
>=20
>  	return 0;
>  error:
> -	rvin_dma_remove(vin);
> +	rvin_dma_unregister(vin);
>=20
>  	return ret;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> b479b882da12f62d..178aecc94962abe2 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -839,7 +839,7 @@ static const struct v4l2_file_operations rvin_fops =
=3D {
>  	.read		=3D vb2_fop_read,
>  };
>=20
> -void rvin_v4l2_remove(struct rvin_dev *vin)
> +void rvin_v4l2_unregister(struct rvin_dev *vin)
>  {
>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
>  		  video_device_node_name(&vin->vdev));
> @@ -866,7 +866,7 @@ static void rvin_notify(struct v4l2_subdev *sd,
>  	}
>  }
>=20
> -int rvin_v4l2_probe(struct rvin_dev *vin)
> +int rvin_v4l2_register(struct rvin_dev *vin)
>  {
>  	struct video_device *vdev =3D &vin->vdev;
>  	struct v4l2_subdev *sd =3D vin_to_source(vin);
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 5382078143fb3869..85cb7ec53d2b08b5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -153,11 +153,11 @@ struct rvin_dev {
>  #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
>  #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
>=20
> -int rvin_dma_probe(struct rvin_dev *vin, int irq);
> -void rvin_dma_remove(struct rvin_dev *vin);
> +int rvin_dma_register(struct rvin_dev *vin, int irq);
> +void rvin_dma_unregister(struct rvin_dev *vin);
>=20
> -int rvin_v4l2_probe(struct rvin_dev *vin);
> -void rvin_v4l2_remove(struct rvin_dev *vin);
> +int rvin_v4l2_register(struct rvin_dev *vin);
> +void rvin_v4l2_unregister(struct rvin_dev *vin);
>=20
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);

=2D-=20
Regards,

Laurent Pinchart
