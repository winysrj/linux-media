Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47105 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752736AbdLHI2O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 03:28:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 08/28] rcar-vin: move functions regarding scaling
Date: Fri, 08 Dec 2017 10:28:32 +0200
Message-ID: <4205444.UPmIWaK9Tz@avalon>
In-Reply-To: <20171208010842.20047-9-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-9-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:22 EET Niklas S=F6derlund wrote:
> In preparation of refactoring the scaling code move the code regarding
> scaling to to the top of the file to avoid the need to add forward
> declarations. No code is changed in this commit only whole functions
> moved inside the same file.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

The patch is awful to review from the e-mail as git has done a very bad job=
=20
formatting it. If you have to resend it, use --patience for this patch, it=
=20
will help a lot.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 806 ++++++++++++++---------=
=2D--
>  1 file changed, 405 insertions(+), 401 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> d701b52d198243b5..a7cda3922cb74baa 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -138,305 +138,6 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offs=
et)
> return ioread32(vin->base + offset);
>  }
>=20
> -static int rvin_setup(struct rvin_dev *vin)
> -{
> -	u32 vnmc, dmr, dmr2, interrupts;
> -	v4l2_std_id std;
> -	bool progressive =3D false, output_is_yuv =3D false, input_is_yuv =3D f=
alse;
> -
> -	switch (vin->format.field) {
> -	case V4L2_FIELD_TOP:
> -		vnmc =3D VNMC_IM_ODD;
> -		break;
> -	case V4L2_FIELD_BOTTOM:
> -		vnmc =3D VNMC_IM_EVEN;
> -		break;
> -	case V4L2_FIELD_INTERLACED:
> -		/* Default to TB */
> -		vnmc =3D VNMC_IM_FULL;
> -		/* Use BT if video standard can be read and is 60 Hz format */
> -		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> -			if (std & V4L2_STD_525_60)
> -				vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> -		}
> -		break;
> -	case V4L2_FIELD_INTERLACED_TB:
> -		vnmc =3D VNMC_IM_FULL;
> -		break;
> -	case V4L2_FIELD_INTERLACED_BT:
> -		vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> -		break;
> -	case V4L2_FIELD_ALTERNATE:
> -	case V4L2_FIELD_NONE:
> -		if (vin->continuous) {
> -			vnmc =3D VNMC_IM_ODD_EVEN;
> -			progressive =3D true;
> -		} else {
> -			vnmc =3D VNMC_IM_ODD;
> -		}
> -		break;
> -	default:
> -		vnmc =3D VNMC_IM_ODD;
> -		break;
> -	}
> -
> -	/*
> -	 * Input interface
> -	 */
> -	switch (vin->digital->code) {
> -	case MEDIA_BUS_FMT_YUYV8_1X16:
> -		/* BT.601/BT.1358 16bit YCbCr422 */
> -		vnmc |=3D VNMC_INF_YUV16;
> -		input_is_yuv =3D true;
> -		break;
> -	case MEDIA_BUS_FMT_UYVY8_2X8:
> -		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> -		vnmc |=3D vin->digital->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
> -			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> -		input_is_yuv =3D true;
> -		break;
> -	case MEDIA_BUS_FMT_RGB888_1X24:
> -		vnmc |=3D VNMC_INF_RGB888;
> -		break;
> -	case MEDIA_BUS_FMT_UYVY10_2X10:
> -		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> -		vnmc |=3D vin->digital->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
> -			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
> -		input_is_yuv =3D true;
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	/* Enable VSYNC Field Toogle mode after one VSYNC input */
> -	dmr2 =3D VNDMR2_FTEV | VNDMR2_VLV(1);
> -
> -	/* Hsync Signal Polarity Select */
> -	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> -		dmr2 |=3D VNDMR2_HPS;
> -
> -	/* Vsync Signal Polarity Select */
> -	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> -		dmr2 |=3D VNDMR2_VPS;
> -
> -	/*
> -	 * Output format
> -	 */
> -	switch (vin->format.pixelformat) {
> -	case V4L2_PIX_FMT_NV16:
> -		rvin_write(vin,
> -			   ALIGN(vin->format.width * vin->format.height, 0x80),
> -			   VNUVAOF_REG);
> -		dmr =3D VNDMR_DTMD_YCSEP;
> -		output_is_yuv =3D true;
> -		break;
> -	case V4L2_PIX_FMT_YUYV:
> -		dmr =3D VNDMR_BPSM;
> -		output_is_yuv =3D true;
> -		break;
> -	case V4L2_PIX_FMT_UYVY:
> -		dmr =3D 0;
> -		output_is_yuv =3D true;
> -		break;
> -	case V4L2_PIX_FMT_XRGB555:
> -		dmr =3D VNDMR_DTMD_ARGB1555;
> -		break;
> -	case V4L2_PIX_FMT_RGB565:
> -		dmr =3D 0;
> -		break;
> -	case V4L2_PIX_FMT_XBGR32:
> -		/* Note: not supported on M1 */
> -		dmr =3D VNDMR_EXRGB;
> -		break;
> -	default:
> -		vin_err(vin, "Invalid pixelformat (0x%x)\n",
> -			vin->format.pixelformat);
> -		return -EINVAL;
> -	}
> -
> -	/* Always update on field change */
> -	vnmc |=3D VNMC_VUP;
> -
> -	/* If input and output use the same colorspace, use bypass mode */
> -	if (input_is_yuv =3D=3D output_is_yuv)
> -		vnmc |=3D VNMC_BPS;
> -
> -	/* Progressive or interlaced mode */
> -	interrupts =3D progressive ? VNIE_FIE : VNIE_EFE;
> -
> -	/* Ack interrupts */
> -	rvin_write(vin, interrupts, VNINTS_REG);
> -	/* Enable interrupts */
> -	rvin_write(vin, interrupts, VNIE_REG);
> -	/* Start capturing */
> -	rvin_write(vin, dmr, VNDMR_REG);
> -	rvin_write(vin, dmr2, VNDMR2_REG);
> -
> -	/* Enable module */
> -	rvin_write(vin, vnmc | VNMC_ME, VNMC_REG);
> -
> -	return 0;
> -}
> -
> -static void rvin_disable_interrupts(struct rvin_dev *vin)
> -{
> -	rvin_write(vin, 0, VNIE_REG);
> -}
> -
> -static u32 rvin_get_interrupt_status(struct rvin_dev *vin)
> -{
> -	return rvin_read(vin, VNINTS_REG);
> -}
> -
> -static void rvin_ack_interrupt(struct rvin_dev *vin)
> -{
> -	rvin_write(vin, rvin_read(vin, VNINTS_REG), VNINTS_REG);
> -}
> -
> -static bool rvin_capture_active(struct rvin_dev *vin)
> -{
> -	return rvin_read(vin, VNMS_REG) & VNMS_CA;
> -}
> -
> -static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
> -{
> -	if (vin->continuous)
> -		return (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
> -
> -	return 0;
> -}
> -
> -static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32
> vnms) -{
> -	if (vin->format.field =3D=3D V4L2_FIELD_ALTERNATE) {
> -		/* If FS is set it's a Even field */
> -		if (vnms & VNMS_FS)
> -			return V4L2_FIELD_BOTTOM;
> -		return V4L2_FIELD_TOP;
> -	}
> -
> -	return vin->format.field;
> -}
> -
> -static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t
> addr) -{
> -	const struct rvin_video_format *fmt;
> -	int offsetx, offsety;
> -	dma_addr_t offset;
> -
> -	fmt =3D rvin_format_from_pixel(vin->format.pixelformat);
> -
> -	/*
> -	 * There is no HW support for composition do the beast we can
> -	 * by modifying the buffer offset
> -	 */
> -	offsetx =3D vin->compose.left * fmt->bpp;
> -	offsety =3D vin->compose.top * vin->format.bytesperline;
> -	offset =3D addr + offsetx + offsety;
> -
> -	/*
> -	 * The address needs to be 128 bytes aligned. Driver should never accept
> -	 * settings that do not satisfy this in the first place...
> -	 */
> -	if (WARN_ON((offsetx | offsety | offset) & HW_BUFFER_MASK))
> -		return;
> -
> -	rvin_write(vin, offset, VNMB_REG(slot));
> -}
> -
> -/* Moves a buffer from the queue to the HW slots */
> -static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
> -{
> -	struct rvin_buffer *buf;
> -	struct vb2_v4l2_buffer *vbuf;
> -	dma_addr_t phys_addr_top;
> -
> -	if (vin->queue_buf[slot] !=3D NULL)
> -		return true;
> -
> -	if (list_empty(&vin->buf_list))
> -		return false;
> -
> -	vin_dbg(vin, "Filling HW slot: %d\n", slot);
> -
> -	/* Keep track of buffer we give to HW */
> -	buf =3D list_entry(vin->buf_list.next, struct rvin_buffer, list);
> -	vbuf =3D &buf->vb;
> -	list_del_init(to_buf_list(vbuf));
> -	vin->queue_buf[slot] =3D vbuf;
> -
> -	/* Setup DMA */
> -	phys_addr_top =3D vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
> -	rvin_set_slot_addr(vin, slot, phys_addr_top);
> -
> -	return true;
> -}
> -
> -static bool rvin_fill_hw(struct rvin_dev *vin)
> -{
> -	int slot, limit;
> -
> -	limit =3D vin->continuous ? HW_BUFFER_NUM : 1;
> -
> -	for (slot =3D 0; slot < limit; slot++)
> -		if (!rvin_fill_hw_slot(vin, slot))
> -			return false;
> -	return true;
> -}
> -
> -static void rvin_capture_on(struct rvin_dev *vin)
> -{
> -	vin_dbg(vin, "Capture on in %s mode\n",
> -		vin->continuous ? "continuous" : "single");
> -
> -	if (vin->continuous)
> -		/* Continuous Frame Capture Mode */
> -		rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
> -	else
> -		/* Single Frame Capture Mode */
> -		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
> -}
> -
> -static int rvin_capture_start(struct rvin_dev *vin)
> -{
> -	struct rvin_buffer *buf, *node;
> -	int bufs, ret;
> -
> -	/* Count number of free buffers */
> -	bufs =3D 0;
> -	list_for_each_entry_safe(buf, node, &vin->buf_list, list)
> -		bufs++;
> -
> -	/* Continuous capture requires more buffers then there are HW slots */
> -	vin->continuous =3D bufs > HW_BUFFER_NUM;
> -
> -	if (!rvin_fill_hw(vin)) {
> -		vin_err(vin, "HW not ready to start, not enough buffers available\n");
> -		return -EINVAL;
> -	}
> -
> -	rvin_crop_scale_comp(vin);
> -
> -	ret =3D rvin_setup(vin);
> -	if (ret)
> -		return ret;
> -
> -	rvin_capture_on(vin);
> -
> -	vin->state =3D RUNNING;
> -
> -	return 0;
> -}
> -
> -static void rvin_capture_stop(struct rvin_dev *vin)
> -{
> -	/* Set continuous & single transfer off */
> -	rvin_write(vin, 0, VNFC_REG);
> -
> -	/* Disable module */
> -	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
> -}
> -
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * Crop and Scaling Gen2
>   */
> @@ -757,139 +458,442 @@ static const struct vin_coeff vin_coeff_set[] =3D=
 {
>  			  0x0370e83b, 0x0310d439, 0x03a0f83d,
>  			  0x0370e83c, 0x0300d438, 0x03b0fc3c },
>  	}
> -};
> +};
> +
> +static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
> +{
> +	int i;
> +	const struct vin_coeff *p_prev_set =3D NULL;
> +	const struct vin_coeff *p_set =3D NULL;
> +
> +	/* Look for suitable coefficient values */
> +	for (i =3D 0; i < ARRAY_SIZE(vin_coeff_set); i++) {
> +		p_prev_set =3D p_set;
> +		p_set =3D &vin_coeff_set[i];
> +
> +		if (xs < p_set->xs_value)
> +			break;
> +	}
> +
> +	/* Use previous value if its XS value is closer */
> +	if (p_prev_set && p_set &&
> +	    xs - p_prev_set->xs_value < p_set->xs_value - xs)
> +		p_set =3D p_prev_set;
> +
> +	/* Set coefficient registers */
> +	rvin_write(vin, p_set->coeff_set[0], VNC1A_REG);
> +	rvin_write(vin, p_set->coeff_set[1], VNC1B_REG);
> +	rvin_write(vin, p_set->coeff_set[2], VNC1C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[3], VNC2A_REG);
> +	rvin_write(vin, p_set->coeff_set[4], VNC2B_REG);
> +	rvin_write(vin, p_set->coeff_set[5], VNC2C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[6], VNC3A_REG);
> +	rvin_write(vin, p_set->coeff_set[7], VNC3B_REG);
> +	rvin_write(vin, p_set->coeff_set[8], VNC3C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[9], VNC4A_REG);
> +	rvin_write(vin, p_set->coeff_set[10], VNC4B_REG);
> +	rvin_write(vin, p_set->coeff_set[11], VNC4C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[12], VNC5A_REG);
> +	rvin_write(vin, p_set->coeff_set[13], VNC5B_REG);
> +	rvin_write(vin, p_set->coeff_set[14], VNC5C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[15], VNC6A_REG);
> +	rvin_write(vin, p_set->coeff_set[16], VNC6B_REG);
> +	rvin_write(vin, p_set->coeff_set[17], VNC6C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[18], VNC7A_REG);
> +	rvin_write(vin, p_set->coeff_set[19], VNC7B_REG);
> +	rvin_write(vin, p_set->coeff_set[20], VNC7C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[21], VNC8A_REG);
> +	rvin_write(vin, p_set->coeff_set[22], VNC8B_REG);
> +	rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
> +}
> +
> +void rvin_crop_scale_comp(struct rvin_dev *vin)
> +{
> +	u32 xs, ys;
> +
> +	/* Set Start/End Pixel/Line Pre-Clip */
> +	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
> +	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
> +		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
> +			   VNELPRC_REG);
> +		break;
> +	default:
> +		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
> +		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
> +			   VNELPRC_REG);
> +		break;
> +	}
> +
> +	/* Set scaling coefficient */
> +	ys =3D 0;
> +	if (vin->crop.height !=3D vin->compose.height)
> +		ys =3D (4096 * vin->crop.height) / vin->compose.height;
> +	rvin_write(vin, ys, VNYS_REG);
> +
> +	xs =3D 0;
> +	if (vin->crop.width !=3D vin->compose.width)
> +		xs =3D (4096 * vin->crop.width) / vin->compose.width;
> +
> +	/* Horizontal upscaling is up to double size */
> +	if (xs > 0 && xs < 2048)
> +		xs =3D 2048;
> +
> +	rvin_write(vin, xs, VNXS_REG);
> +
> +	/* Horizontal upscaling is done out by scaling down from double size */
> +	if (xs < 4096)
> +		xs *=3D 2;
> +
> +	rvin_set_coeff(vin, xs);
> +
> +	/* Set Start/End Pixel/Line Post-Clip */
> +	rvin_write(vin, 0, VNSPPOC_REG);
> +	rvin_write(vin, 0, VNSLPOC_REG);
> +	rvin_write(vin, vin->format.width - 1, VNEPPOC_REG);
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		rvin_write(vin, vin->format.height / 2 - 1, VNELPOC_REG);
> +		break;
> +	default:
> +		rvin_write(vin, vin->format.height - 1, VNELPOC_REG);
> +		break;
> +	}
> +
> +	if (vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16)
> +		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> +	else
> +		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> +
> +	vin_dbg(vin,
> +		"Pre-Clip: %ux%u@%u:%u YS: %d XS: %d Post-Clip: %ux%u@%u:%u\n",
> +		vin->crop.width, vin->crop.height, vin->crop.left,
> +		vin->crop.top, ys, xs, vin->format.width, vin->format.height,
> +		0, 0);
> +}
> +
> +void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
> +		    u32 width, u32 height)
> +{
> +	/* All VIN channels on Gen2 have scalers */
> +	pix->width =3D width;
> +	pix->height =3D height;
> +}
> +
> +/*
> -------------------------------------------------------------------------=
=2D-
> -- + * Hardware setup
> + */
> +
> +static int rvin_setup(struct rvin_dev *vin)
> +{
> +	u32 vnmc, dmr, dmr2, interrupts;
> +	v4l2_std_id std;
> +	bool progressive =3D false, output_is_yuv =3D false, input_is_yuv =3D f=
alse;
> +
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_TOP:
> +		vnmc =3D VNMC_IM_ODD;
> +		break;
> +	case V4L2_FIELD_BOTTOM:
> +		vnmc =3D VNMC_IM_EVEN;
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +		/* Default to TB */
> +		vnmc =3D VNMC_IM_FULL;
> +		/* Use BT if video standard can be read and is 60 Hz format */
> +		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> +			if (std & V4L2_STD_525_60)
> +				vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> +		}
> +		break;
> +	case V4L2_FIELD_INTERLACED_TB:
> +		vnmc =3D VNMC_IM_FULL;
> +		break;
> +	case V4L2_FIELD_INTERLACED_BT:
> +		vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> +		break;
> +	case V4L2_FIELD_ALTERNATE:
> +	case V4L2_FIELD_NONE:
> +		if (vin->continuous) {
> +			vnmc =3D VNMC_IM_ODD_EVEN;
> +			progressive =3D true;
> +		} else {
> +			vnmc =3D VNMC_IM_ODD;
> +		}
> +		break;
> +	default:
> +		vnmc =3D VNMC_IM_ODD;
> +		break;
> +	}
> +
> +	/*
> +	 * Input interface
> +	 */
> +	switch (vin->digital->code) {
> +	case MEDIA_BUS_FMT_YUYV8_1X16:
> +		/* BT.601/BT.1358 16bit YCbCr422 */
> +		vnmc |=3D VNMC_INF_YUV16;
> +		input_is_yuv =3D true;
> +		break;
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> +		vnmc |=3D vin->digital->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
> +			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> +		input_is_yuv =3D true;
> +		break;
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +		vnmc |=3D VNMC_INF_RGB888;
> +		break;
> +	case MEDIA_BUS_FMT_UYVY10_2X10:
> +		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> +		vnmc |=3D vin->digital->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
> +			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
> +		input_is_yuv =3D true;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* Enable VSYNC Field Toogle mode after one VSYNC input */
> +	dmr2 =3D VNDMR2_FTEV | VNDMR2_VLV(1);
> +
> +	/* Hsync Signal Polarity Select */
> +	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> +		dmr2 |=3D VNDMR2_HPS;
> +
> +	/* Vsync Signal Polarity Select */
> +	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> +		dmr2 |=3D VNDMR2_VPS;
> +
> +	/*
> +	 * Output format
> +	 */
> +	switch (vin->format.pixelformat) {
> +	case V4L2_PIX_FMT_NV16:
> +		rvin_write(vin,
> +			   ALIGN(vin->format.width * vin->format.height, 0x80),
> +			   VNUVAOF_REG);
> +		dmr =3D VNDMR_DTMD_YCSEP;
> +		output_is_yuv =3D true;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		dmr =3D VNDMR_BPSM;
> +		output_is_yuv =3D true;
> +		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		dmr =3D 0;
> +		output_is_yuv =3D true;
> +		break;
> +	case V4L2_PIX_FMT_XRGB555:
> +		dmr =3D VNDMR_DTMD_ARGB1555;
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		dmr =3D 0;
> +		break;
> +	case V4L2_PIX_FMT_XBGR32:
> +		/* Note: not supported on M1 */
> +		dmr =3D VNDMR_EXRGB;
> +		break;
> +	default:
> +		vin_err(vin, "Invalid pixelformat (0x%x)\n",
> +			vin->format.pixelformat);
> +		return -EINVAL;
> +	}
>=20
> -static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
> +	/* Always update on field change */
> +	vnmc |=3D VNMC_VUP;
> +
> +	/* If input and output use the same colorspace, use bypass mode */
> +	if (input_is_yuv =3D=3D output_is_yuv)
> +		vnmc |=3D VNMC_BPS;
> +
> +	/* Progressive or interlaced mode */
> +	interrupts =3D progressive ? VNIE_FIE : VNIE_EFE;
> +
> +	/* Ack interrupts */
> +	rvin_write(vin, interrupts, VNINTS_REG);
> +	/* Enable interrupts */
> +	rvin_write(vin, interrupts, VNIE_REG);
> +	/* Start capturing */
> +	rvin_write(vin, dmr, VNDMR_REG);
> +	rvin_write(vin, dmr2, VNDMR2_REG);
> +
> +	/* Enable module */
> +	rvin_write(vin, vnmc | VNMC_ME, VNMC_REG);
> +
> +	return 0;
> +}
> +
> +static void rvin_disable_interrupts(struct rvin_dev *vin)
>  {
> -	int i;
> -	const struct vin_coeff *p_prev_set =3D NULL;
> -	const struct vin_coeff *p_set =3D NULL;
> +	rvin_write(vin, 0, VNIE_REG);
> +}
>=20
> -	/* Look for suitable coefficient values */
> -	for (i =3D 0; i < ARRAY_SIZE(vin_coeff_set); i++) {
> -		p_prev_set =3D p_set;
> -		p_set =3D &vin_coeff_set[i];
> +static u32 rvin_get_interrupt_status(struct rvin_dev *vin)
> +{
> +	return rvin_read(vin, VNINTS_REG);
> +}
>=20
> -		if (xs < p_set->xs_value)
> -			break;
> +static void rvin_ack_interrupt(struct rvin_dev *vin)
> +{
> +	rvin_write(vin, rvin_read(vin, VNINTS_REG), VNINTS_REG);
> +}
> +
> +static bool rvin_capture_active(struct rvin_dev *vin)
> +{
> +	return rvin_read(vin, VNMS_REG) & VNMS_CA;
> +}
> +
> +static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
> +{
> +	if (vin->continuous)
> +		return (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
> +
> +	return 0;
> +}
> +
> +static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32
> vnms) +{
> +	if (vin->format.field =3D=3D V4L2_FIELD_ALTERNATE) {
> +		/* If FS is set it's a Even field */
> +		if (vnms & VNMS_FS)
> +			return V4L2_FIELD_BOTTOM;
> +		return V4L2_FIELD_TOP;
>  	}
>=20
> -	/* Use previous value if its XS value is closer */
> -	if (p_prev_set && p_set &&
> -	    xs - p_prev_set->xs_value < p_set->xs_value - xs)
> -		p_set =3D p_prev_set;
> +	return vin->format.field;
> +}
>=20
> -	/* Set coefficient registers */
> -	rvin_write(vin, p_set->coeff_set[0], VNC1A_REG);
> -	rvin_write(vin, p_set->coeff_set[1], VNC1B_REG);
> -	rvin_write(vin, p_set->coeff_set[2], VNC1C_REG);
> +static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t
> addr) +{
> +	const struct rvin_video_format *fmt;
> +	int offsetx, offsety;
> +	dma_addr_t offset;
>=20
> -	rvin_write(vin, p_set->coeff_set[3], VNC2A_REG);
> -	rvin_write(vin, p_set->coeff_set[4], VNC2B_REG);
> -	rvin_write(vin, p_set->coeff_set[5], VNC2C_REG);
> +	fmt =3D rvin_format_from_pixel(vin->format.pixelformat);
>=20
> -	rvin_write(vin, p_set->coeff_set[6], VNC3A_REG);
> -	rvin_write(vin, p_set->coeff_set[7], VNC3B_REG);
> -	rvin_write(vin, p_set->coeff_set[8], VNC3C_REG);
> +	/*
> +	 * There is no HW support for composition do the beast we can
> +	 * by modifying the buffer offset
> +	 */
> +	offsetx =3D vin->compose.left * fmt->bpp;
> +	offsety =3D vin->compose.top * vin->format.bytesperline;
> +	offset =3D addr + offsetx + offsety;
>=20
> -	rvin_write(vin, p_set->coeff_set[9], VNC4A_REG);
> -	rvin_write(vin, p_set->coeff_set[10], VNC4B_REG);
> -	rvin_write(vin, p_set->coeff_set[11], VNC4C_REG);
> +	/*
> +	 * The address needs to be 128 bytes aligned. Driver should never accept
> +	 * settings that do not satisfy this in the first place...
> +	 */
> +	if (WARN_ON((offsetx | offsety | offset) & HW_BUFFER_MASK))
> +		return;
>=20
> -	rvin_write(vin, p_set->coeff_set[12], VNC5A_REG);
> -	rvin_write(vin, p_set->coeff_set[13], VNC5B_REG);
> -	rvin_write(vin, p_set->coeff_set[14], VNC5C_REG);
> +	rvin_write(vin, offset, VNMB_REG(slot));
> +}
>=20
> -	rvin_write(vin, p_set->coeff_set[15], VNC6A_REG);
> -	rvin_write(vin, p_set->coeff_set[16], VNC6B_REG);
> -	rvin_write(vin, p_set->coeff_set[17], VNC6C_REG);
> +/* Moves a buffer from the queue to the HW slots */
> +static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
> +{
> +	struct rvin_buffer *buf;
> +	struct vb2_v4l2_buffer *vbuf;
> +	dma_addr_t phys_addr_top;
>=20
> -	rvin_write(vin, p_set->coeff_set[18], VNC7A_REG);
> -	rvin_write(vin, p_set->coeff_set[19], VNC7B_REG);
> -	rvin_write(vin, p_set->coeff_set[20], VNC7C_REG);
> +	if (vin->queue_buf[slot] !=3D NULL)
> +		return true;
>=20
> -	rvin_write(vin, p_set->coeff_set[21], VNC8A_REG);
> -	rvin_write(vin, p_set->coeff_set[22], VNC8B_REG);
> -	rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
> +	if (list_empty(&vin->buf_list))
> +		return false;
> +
> +	vin_dbg(vin, "Filling HW slot: %d\n", slot);
> +
> +	/* Keep track of buffer we give to HW */
> +	buf =3D list_entry(vin->buf_list.next, struct rvin_buffer, list);
> +	vbuf =3D &buf->vb;
> +	list_del_init(to_buf_list(vbuf));
> +	vin->queue_buf[slot] =3D vbuf;
> +
> +	/* Setup DMA */
> +	phys_addr_top =3D vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
> +	rvin_set_slot_addr(vin, slot, phys_addr_top);
> +
> +	return true;
>  }
>=20
> -void rvin_crop_scale_comp(struct rvin_dev *vin)
> +static bool rvin_fill_hw(struct rvin_dev *vin)
>  {
> -	u32 xs, ys;
> +	int slot, limit;
>=20
> -	/* Set Start/End Pixel/Line Pre-Clip */
> -	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
> -	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
> -	switch (vin->format.field) {
> -	case V4L2_FIELD_INTERLACED:
> -	case V4L2_FIELD_INTERLACED_TB:
> -	case V4L2_FIELD_INTERLACED_BT:
> -		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
> -		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
> -			   VNELPRC_REG);
> -		break;
> -	default:
> -		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
> -		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
> -			   VNELPRC_REG);
> -		break;
> -	}
> +	limit =3D vin->continuous ? HW_BUFFER_NUM : 1;
>=20
> -	/* Set scaling coefficient */
> -	ys =3D 0;
> -	if (vin->crop.height !=3D vin->compose.height)
> -		ys =3D (4096 * vin->crop.height) / vin->compose.height;
> -	rvin_write(vin, ys, VNYS_REG);
> +	for (slot =3D 0; slot < limit; slot++)
> +		if (!rvin_fill_hw_slot(vin, slot))
> +			return false;
> +	return true;
> +}
>=20
> -	xs =3D 0;
> -	if (vin->crop.width !=3D vin->compose.width)
> -		xs =3D (4096 * vin->crop.width) / vin->compose.width;
> +static void rvin_capture_on(struct rvin_dev *vin)
> +{
> +	vin_dbg(vin, "Capture on in %s mode\n",
> +		vin->continuous ? "continuous" : "single");
>=20
> -	/* Horizontal upscaling is up to double size */
> -	if (xs > 0 && xs < 2048)
> -		xs =3D 2048;
> +	if (vin->continuous)
> +		/* Continuous Frame Capture Mode */
> +		rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
> +	else
> +		/* Single Frame Capture Mode */
> +		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
> +}
>=20
> -	rvin_write(vin, xs, VNXS_REG);
> +static int rvin_capture_start(struct rvin_dev *vin)
> +{
> +	struct rvin_buffer *buf, *node;
> +	int bufs, ret;
>=20
> -	/* Horizontal upscaling is done out by scaling down from double size */
> -	if (xs < 4096)
> -		xs *=3D 2;
> +	/* Count number of free buffers */
> +	bufs =3D 0;
> +	list_for_each_entry_safe(buf, node, &vin->buf_list, list)
> +		bufs++;
>=20
> -	rvin_set_coeff(vin, xs);
> +	/* Continuous capture requires more buffers then there are HW slots */
> +	vin->continuous =3D bufs > HW_BUFFER_NUM;
>=20
> -	/* Set Start/End Pixel/Line Post-Clip */
> -	rvin_write(vin, 0, VNSPPOC_REG);
> -	rvin_write(vin, 0, VNSLPOC_REG);
> -	rvin_write(vin, vin->format.width - 1, VNEPPOC_REG);
> -	switch (vin->format.field) {
> -	case V4L2_FIELD_INTERLACED:
> -	case V4L2_FIELD_INTERLACED_TB:
> -	case V4L2_FIELD_INTERLACED_BT:
> -		rvin_write(vin, vin->format.height / 2 - 1, VNELPOC_REG);
> -		break;
> -	default:
> -		rvin_write(vin, vin->format.height - 1, VNELPOC_REG);
> -		break;
> +	if (!rvin_fill_hw(vin)) {
> +		vin_err(vin, "HW not ready to start, not enough buffers available\n");
> +		return -EINVAL;
>  	}
>=20
> -	if (vin->format.pixelformat =3D=3D V4L2_PIX_FMT_NV16)
> -		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> -	else
> -		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> +	rvin_crop_scale_comp(vin);
>=20
> -	vin_dbg(vin,
> -		"Pre-Clip: %ux%u@%u:%u YS: %d XS: %d Post-Clip: %ux%u@%u:%u\n",
> -		vin->crop.width, vin->crop.height, vin->crop.left,
> -		vin->crop.top, ys, xs, vin->format.width, vin->format.height,
> -		0, 0);
> +	ret =3D rvin_setup(vin);
> +	if (ret)
> +		return ret;
> +
> +	rvin_capture_on(vin);
> +
> +	vin->state =3D RUNNING;
> +
> +	return 0;
>  }
>=20
> -void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
> -		    u32 width, u32 height)
> +static void rvin_capture_stop(struct rvin_dev *vin)
>  {
> -	/* All VIN channels on Gen2 have scalers */
> -	pix->width =3D width;
> -	pix->height =3D height;
> +	/* Set continuous & single transfer off */
> +	rvin_write(vin, 0, VNFC_REG);
> +
> +	/* Disable module */
> +	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
>  }
>=20
>  /*
> -------------------------------------------------------------------------=
=2D-
> --


=2D-=20
Regards,

Laurent Pinchart
