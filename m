Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33594 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752991AbeDZXOr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 19:14:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: enable field toggle after a set number of lines for Gen3
Date: Fri, 27 Apr 2018 02:15:01 +0300
Message-ID: <11739225.3l7zkTrcbQ@avalon>
In-Reply-To: <20180424235652.24672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180424235652.24672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday, 25 April 2018 02:56:52 EEST Niklas S=F6derlund wrote:
> The VIN Gen3 hardware don't have Line Post-Clip capabilities as VIN Gen2
> hardware have. To protect against writing outside the capture window
> enable field toggle after a set number of lines have been captured.
>=20
> Capturing outside the allocated capture buffer where observed on R-Car

s/Capturing/Capture/
s/where/has been/

> Gen3 Salvator-XS H3 from the CVBS input if the standard is
> misconfigured. That is if a PAL source is connected to the system but
> the adv748x standard is set to NTSC. In this case the format reported by
> the adv748x is 720x480 and that is what is used for the media pipeline.
> The PAL source generates frames in the format of 720x576 and the field
> is not toggled until the VSYNC is detected and at that time data have
> already been written outside the allocated capture buffer.
>=20
> With this change the capture in the situation described above results in
> garbage frames but that is far better then writing outside the capture

s/then/than/

> buffer.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> ac07f99e3516a620..b41ba9a4a2b3ac90 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -124,7 +124,9 @@
>  #define VNDMR2_VPS		(1 << 30)
>  #define VNDMR2_HPS		(1 << 29)
>  #define VNDMR2_FTEV		(1 << 17)
> +#define VNDMR2_FTEH		(1 << 16)
>  #define VNDMR2_VLV(n)		((n & 0xf) << 12)
> +#define VNDMR2_HLV(n)		((n) & 0xfff)
>=20
>  /* Video n CSI2 Interface Mode Register (Gen3) */
>  #define VNCSI_IFMD_DES1		(1 << 26)
> @@ -612,8 +614,9 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
>=20
>  static int rvin_setup(struct rvin_dev *vin)
>  {
> -	u32 vnmc, dmr, dmr2, interrupts;
> +	u32 vnmc, dmr, dmr2, interrupts, lines;
>  	bool progressive =3D false, output_is_yuv =3D false, input_is_yuv =3D f=
alse;
> +	bool halfsize =3D false;
>=20
>  	switch (vin->format.field) {
>  	case V4L2_FIELD_TOP:
> @@ -628,12 +631,15 @@ static int rvin_setup(struct rvin_dev *vin)
>  		/* Use BT if video standard can be read and is 60 Hz format */
>  		if (!vin->info->use_mc && vin->std & V4L2_STD_525_60)
>  			vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> +		halfsize =3D true;
>  		break;
>  	case V4L2_FIELD_INTERLACED_TB:
>  		vnmc =3D VNMC_IM_FULL;
> +		halfsize =3D true;
>  		break;
>  	case V4L2_FIELD_INTERLACED_BT:
>  		vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> +		halfsize =3D true;
>  		break;
>  	case V4L2_FIELD_NONE:
>  		vnmc =3D VNMC_IM_ODD_EVEN;
> @@ -676,11 +682,15 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	}
>=20
> -	/* Enable VSYNC Field Toogle mode after one VSYNC input */
> -	if (vin->info->model =3D=3D RCAR_GEN3)
> -		dmr2 =3D VNDMR2_FTEV;
> -	else
> +	if (vin->info->model =3D=3D RCAR_GEN3) {
> +		/* Enable HSYNC Field Toggle mode after height HSYNC inputs. */
> +		lines =3D vin->format.height / (halfsize ? 2 : 1);
> +		dmr2 =3D VNDMR2_FTEH | VNDMR2_HLV(lines);
> +		vin_dbg(vin, "Field Toogle after %u lines\n", lines);
> +	} else {
> +		/* Enable VSYNC Field Toogle mode after one VSYNC input. */
>  		dmr2 =3D VNDMR2_FTEV | VNDMR2_VLV(1);
> +	}
>=20
>  	/* Hsync Signal Polarity Select */
>  	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))

=2D-=20
Regards,

Laurent Pinchart
