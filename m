Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44730 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934210AbeBMQgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 11:36:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 11/30] rcar-vin: move media bus configuration to struct rvin_info
Date: Tue, 13 Feb 2018 18:37:22 +0200
Message-ID: <6625933.P5Vfd3WINF@avalon>
In-Reply-To: <20180129163435.24936-12-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-12-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:16 EET Niklas S=F6derlund wrote:
> Bus configuration will once the driver is extended to support Gen3
> contain information not specific to only the directly connected parallel
> subdevice. Move it to struct rvin_dev to show it's not always coupled
> to the parallel subdevice.

The subject line still mentions rvin_info instead of rvin_dev.

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 18 +++++++++---------
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 11 ++++++-----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  2 +-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  9 ++++-----
>  4 files changed, 20 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> cc863e4ec9a4d4b3..ce1c90405c6002eb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -65,10 +65,10 @@ static int rvin_digital_subdevice_attach(struct rvin_=
dev
> *vin, vin->digital->sink_pad =3D ret < 0 ? 0 : ret;
>=20
>  	/* Find compatible subdevices mbus format */
> -	vin->digital->code =3D 0;
> +	vin->code =3D 0;
>  	code.index =3D 0;
>  	code.pad =3D vin->digital->source_pad;
> -	while (!vin->digital->code &&
> +	while (!vin->code &&
>  	       !v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
>  		code.index++;
>  		switch (code.code) {
> @@ -76,16 +76,16 @@ static int rvin_digital_subdevice_attach(struct rvin_=
dev
> *vin, case MEDIA_BUS_FMT_UYVY8_2X8:
>  		case MEDIA_BUS_FMT_UYVY10_2X10:
>  		case MEDIA_BUS_FMT_RGB888_1X24:
> -			vin->digital->code =3D code.code;
> +			vin->code =3D code.code;
>  			vin_dbg(vin, "Found media bus format for %s: %d\n",
> -				subdev->name, vin->digital->code);
> +				subdev->name, vin->code);
>  			break;
>  		default:
>  			break;
>  		}
>  	}
>=20
> -	if (!vin->digital->code) {
> +	if (!vin->code) {
>  		vin_err(vin, "Unsupported media bus format for %s\n",
>  			subdev->name);
>  		return -EINVAL;
> @@ -190,16 +190,16 @@ static int rvin_digital_parse_v4l2(struct device *d=
ev,
> if (vep->base.port || vep->base.id)
>  		return -ENOTCONN;
>=20
> -	rvge->mbus_cfg.type =3D vep->bus_type;
> +	vin->mbus_cfg.type =3D vep->bus_type;
>=20
> -	switch (rvge->mbus_cfg.type) {
> +	switch (vin->mbus_cfg.type) {
>  	case V4L2_MBUS_PARALLEL:
>  		vin_dbg(vin, "Found PARALLEL media bus\n");
> -		rvge->mbus_cfg.flags =3D vep->bus.parallel.flags;
> +		vin->mbus_cfg.flags =3D vep->bus.parallel.flags;
>  		break;
>  	case V4L2_MBUS_BT656:
>  		vin_dbg(vin, "Found BT656 media bus\n");
> -		rvge->mbus_cfg.flags =3D 0;
> +		vin->mbus_cfg.flags =3D 0;
>  		break;
>  	default:
>  		vin_err(vin, "Unknown media bus type\n");
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> c8831e189d362c8b..561500f65cfa2e74 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -633,7 +633,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  	/*
>  	 * Input interface
>  	 */
> -	switch (vin->digital->code) {
> +	switch (vin->code) {
>  	case MEDIA_BUS_FMT_YUYV8_1X16:
>  		/* BT.601/BT.1358 16bit YCbCr422 */
>  		vnmc |=3D VNMC_INF_YUV16;
> @@ -641,7 +641,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> -		vnmc |=3D vin->digital->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
> +		vnmc |=3D vin->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
>  			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
>  		input_is_yuv =3D true;
>  		break;
> @@ -650,7 +650,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	case MEDIA_BUS_FMT_UYVY10_2X10:
>  		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> -		vnmc |=3D vin->digital->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
> +		vnmc |=3D vin->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
>  			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
>  		input_is_yuv =3D true;
>  		break;
> @@ -662,11 +662,11 @@ static int rvin_setup(struct rvin_dev *vin)
>  	dmr2 =3D VNDMR2_FTEV | VNDMR2_VLV(1);
>=20
>  	/* Hsync Signal Polarity Select */
> -	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> +	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
>  		dmr2 |=3D VNDMR2_HPS;
>=20
>  	/* Vsync Signal Polarity Select */
> -	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> +	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
>  		dmr2 |=3D VNDMR2_VPS;
>=20
>  	/*
> @@ -875,6 +875,7 @@ static void rvin_capture_stop(struct rvin_dev *vin)
>  	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
>  }
>=20
> +
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * DMA Functions
>   */
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 9f7902d29c62e205..c606942e59b5d934 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -185,7 +185,7 @@ static int __rvin_try_format_source(struct rvin_dev
> *vin,
>=20
>  	sd =3D vin_to_source(vin);
>=20
> -	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
> +	v4l2_fill_mbus_format(&format.format, pix, vin->code);
>=20
>  	pad_cfg =3D v4l2_subdev_alloc_pad_config(sd);
>  	if (pad_cfg =3D=3D NULL)
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 39051da31650bd79..b852e7f4fa3db017 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -62,8 +62,6 @@ struct rvin_video_format {
>   * struct rvin_graph_entity - Video endpoint from async framework
>   * @asd:	sub-device descriptor for async framework
>   * @subdev:	subdevice matched using async framework
> - * @code:	Media bus format from source
> - * @mbus_cfg:	Media bus format from DT
>   * @source_pad:	source pad of remote subdevice
>   * @sink_pad:	sink pad of remote subdevice
>   */
> @@ -71,9 +69,6 @@ struct rvin_graph_entity {
>  	struct v4l2_async_subdev asd;
>  	struct v4l2_subdev *subdev;
>=20
> -	u32 code;
> -	struct v4l2_mbus_config mbus_cfg;
> -
>  	unsigned int source_pad;
>  	unsigned int sink_pad;
>  };
> @@ -114,6 +109,8 @@ struct rvin_info {
>   * @sequence:		V4L2 buffers sequence number
>   * @state:		keeps track of operation state
>   *
> + * @mbus_cfg:		media bus configuration from DT
> + * @code:		media bus format code

In a global context those field names are confusing, especially the code=20
field. It's not clear what code it refers to. Furthermore it's interesting =
how=20
you dropped the cached source format in a previous patch, and now cache the=
=20
source pixel code in the same structure :-)

>   * @format:		active V4L2 pixel format
>   *
>   * @crop:		active cropping
> @@ -140,6 +137,8 @@ struct rvin_dev {
>  	unsigned int sequence;
>  	enum rvin_dma_state state;
>=20
> +	struct v4l2_mbus_config mbus_cfg;
> +	u32 code;
>  	struct v4l2_pix_format format;
>=20
>  	struct v4l2_rect crop;

The pixel code and bus config are specific to a source, and yet you move th=
em=20
from rvin_graph_entity, which is source-specific, to rvin_dev, which is=20
global. Am I missing something ?

=2D-=20
Regards,

Laurent Pinchart
