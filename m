Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50158 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbcFPQwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 12:52:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
	Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 5/8] [media] rcar-vin: add Gen3 HW registers
Date: Thu, 16 Jun 2016 19:52:49 +0300
Message-ID: <3671721.tOcqacdeeF@avalon>
In-Reply-To: <1464203409-1279-6-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se> <1464203409-1279-6-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday 25 May 2016 21:10:06 Niklas Söderlund wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Add the register needed to work with Gen3 hardware. This patch just adds
> the logic for how to work with the Gen3 hardware. More work is required
> to enable the subdevice structure needed to support capturing.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 99 ++++++++++++++++----------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 15 ++++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
>  3 files changed, 80 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index b3d3c5e..5196395 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -33,21 +33,23 @@
>  #define VNELPRC_REG	0x10	/* Video n End Line Pre-Clip Register */
>  #define VNSPPRC_REG	0x14	/* Video n Start Pixel Pre-Clip Register */
>  #define VNEPPRC_REG	0x18	/* Video n End Pixel Pre-Clip Register */

By the way, that's not directly related to this patch, but hex constants in 
the kernel tend to use lowercase letters.

Also, feel free to give a bit more air to the register definitions even if it 
makes them cross the 80 characters per line limit, if it helps improving 
readability. If it was up to me I'd add one tab before the register address 
for instance to align them with the register fields values a bit further 
below.

Still from a readability point of view, I would extend the register address to 
4 (or just 3 if you prefer) hex digits as we have registers above the first 
0x100 bytes.

> -#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
> -#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
> -#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
> -#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
>  #define VNIS_REG	0x2C	/* Video n Image Stride Register */
>  #define VNMB_REG(m)	(0x30 + ((m) << 2)) /* Video n Memory Base m Register
> */
> #define VNIE_REG	0x40	/* Video n Interrupt Enable Register */
>  #define VNINTS_REG	0x44	/* Video n Interrupt Status Register */
>  #define VNSI_REG	0x48	/* Video n Scanline Interrupt Register */
>  #define VNMTC_REG	0x4C	/* Video n Memory Transfer Control Register */
> -#define VNYS_REG	0x50	/* Video n Y Scale Register */
> -#define VNXS_REG	0x54	/* Video n X Scale Register */
>  #define VNDMR_REG	0x58	/* Video n Data Mode Register */
>  #define VNDMR2_REG	0x5C	/* Video n Data Mode Register 2 */
>  #define VNUVAOF_REG	0x60	/* Video n UV Address Offset Register */
> +
> +/* Register offsets specific for Gen2 */
> +#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
> +#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
> +#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
> +#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
> +#define VNYS_REG	0x50	/* Video n Y Scale Register */
> +#define VNXS_REG	0x54	/* Video n X Scale Register */
>  #define VNC1A_REG	0x80	/* Video n Coefficient Set C1A Register */
>  #define VNC1B_REG	0x84	/* Video n Coefficient Set C1B Register */
>  #define VNC1C_REG	0x88	/* Video n Coefficient Set C1C Register */
> @@ -73,9 +75,13 @@
>  #define VNC8B_REG	0xF4	/* Video n Coefficient Set C8B Register */
>  #define VNC8C_REG	0xF8	/* Video n Coefficient Set C8C Register */
> 
> +/* Register offsets specific for Gen3 */
> +#define VNCSI_IFMD_REG		0x20 /* Video n CSI2 Interface Mode Register */
> 
>  /* Register bit fields for R-Car VIN */
>  /* Video n Main Control Register bits */
> +#define VNMC_DPINE		(1 << 27) /* Gen3 specific */
> +#define VNMC_SCLE		(1 << 26) /* Gen3 specific */
>  #define VNMC_FOC		(1 << 21)
>  #define VNMC_YCAL		(1 << 19)
>  #define VNMC_INF_YUV8_BT656	(0 << 16)
> @@ -118,6 +124,12 @@
>  #define VNDMR2_FTEV		(1 << 17)
>  #define VNDMR2_VLV(n)		((n & 0xf) << 12)
> 
> +/* Video n CSI2 Interface Mode Register (Gen3) */
> +#define VNCSI_IFMD_DES2		(1 << 27)
> +#define VNCSI_IFMD_DES1		(1 << 26)
> +#define VNCSI_IFMD_DES0		(1 << 25)
> +#define VNCSI_IFMD_CSI_CHSEL(n) ((n & 0xf) << 0)
> +
>  static void rvin_write(struct rvin_dev *vin, u32 value, u32 offset)
>  {
>  	iowrite32(value, vin->base + offset);
> @@ -196,7 +208,10 @@ static int rvin_setup(struct rvin_dev *vin)
>  	}
> 
>  	/* Enable VSYNC Field Toogle mode after one VSYNC input */
> -	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
> +	if (vin->chip == RCAR_GEN3)

I'm not too fond of scattering this kind of check across the code. My 
preferred approach is to add a device info structure that stores information 
about specific device models, and use it as appropriate. You can check the 
vsp1 or rcar-du driver for examples.

This being said, given that you have a limited number of such checks, there's 
no need to change this now, but please keep that in mind for the future when 
more code will be conditioned to the device model.

On a side note, I would rename the field from chip to model, and the values 
from RCAR_* to RCAR_VIN_*, as what matters is the VIN model, not the SoC.

> +		dmr2 = VNDMR2_FTEV;
> +	else
> +		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
> 
>  	/* Hsync Signal Polarity Select */
>  	if (!(mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> @@ -232,7 +247,8 @@ static int rvin_setup(struct rvin_dev *vin)
>  		dmr = 0;
>  		break;
>  	case V4L2_PIX_FMT_XBGR32:
> -		if (vin->chip == RCAR_GEN2 || vin->chip == RCAR_H1) {
> +		if (vin->chip == RCAR_GEN2 || vin->chip == RCAR_H1 ||
> +		    vin->chip == RCAR_GEN3) {

If V4L2_PIX_FMT_XBGR32 isn't allowed on M1, VIDIOC_S_FMT and VIDIOC_TRY_FMT 
should disallow it. This isn't the right place for error checking.

I know the problem isn't introduced by this patch, so you can fix it in a 
separate patch. Ideally I would fix the problem first, which would get rid of 
this check, and then apply this patch with this hunk removed.

>  			dmr = VNDMR_EXRGB;
>  			break;
>  		}
> @@ -250,6 +266,14 @@ static int rvin_setup(struct rvin_dev *vin)
>  	if (input_is_yuv == output_is_yuv)
>  		vnmc |= VNMC_BPS;
> 
> +	if (vin->chip == RCAR_GEN3) {
> +		/* Select between CSI-2 and Digital input */
> +		if (mbus_cfg.type == V4L2_MBUS_CSI2)
> +			vnmc &= ~VNMC_DPINE;
> +		else
> +			vnmc |= VNMC_DPINE;
> +	}
> +
>  	/* Progressive or interlaced mode */
>  	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
> 
> @@ -740,28 +764,10 @@ static void rvin_set_coeff(struct rvin_dev *vin,
> unsigned short xs) rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
>  }
> 
> -void rvin_crop_scale_comp(struct rvin_dev *vin)
> +static void rvin_crop_scale_comp_gen2(struct rvin_dev *vin)
>  {
>  	u32 xs, ys;
> 
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
> -
>  	/* Set scaling coefficient */
>  	ys = 0;
>  	if (vin->crop.height != vin->compose.height)
> @@ -799,11 +805,6 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
>  		break;
>  	}
> 
> -	if (vin->format.pixelformat == V4L2_PIX_FMT_NV16)
> -		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> -	else
> -		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> -
>  	vin_dbg(vin,
>  		"Pre-Clip: %ux%u@%u:%u YS: %d XS: %d Post-Clip: %ux%u@%u:%u\n",
>  		vin->crop.width, vin->crop.height, vin->crop.left,
> @@ -811,9 +812,43 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
>  		0, 0);
>  }
> 
> +void rvin_crop_scale_comp(struct rvin_dev *vin)
> +{
> +	/* Set Start/End Pixel/Line Pre-Clip */
> +	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
> +	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);

Please add a blank line here.

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
> +	/* Driver do not support UDS */
> +	if (vin->chip != RCAR_GEN3)
> +		rvin_crop_scale_comp_gen2(vin);

If you reorder the chip IDs as proposed below, I think

	if (vin->chip <= RCAR_GEN2)
		rvin_crop_scale_comp_gen2(vin);

would be clearer.

> +
> +	if (vin->format.pixelformat == V4L2_PIX_FMT_NV16)
> +		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
> +	else
> +		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> +}
> +
>  void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
>  		    u32 width, u32 height)
>  {
> +	/* Driver do not support UDS */

s/do not/does not/

And I'd write it as

/* TODO: Add support for the UDS scaler. */

> +	if (vin->chip == RCAR_GEN3)
> +		return;
> +
>  	/* All VIN channels on Gen2 have scalers */
>  	pix->width = width;
>  	pix->height = height;
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index 2307f5b..f4eaef0 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -25,6 +25,8 @@
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
>  #define RVIN_MAX_WIDTH		2048
>  #define RVIN_MAX_HEIGHT		2048
> +#define RVIN_MAX_WIDTH_GEN3	4096
> +#define RVIN_MAX_HEIGHT_GEN3	4096
> 
>  /* ------------------------------------------------------------------------
>   * Format Conversions
> @@ -139,7 +141,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  			     struct rvin_source_fmt *source)
>  {
>  	const struct rvin_video_format *info;
> -	u32 rwidth, rheight, walign;
> +	u32 rwidth, rheight, walign, max_width, max_height;
> 
>  	/* Requested */
>  	rwidth = pix->width;
> @@ -173,8 +175,15 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> 
>  	/* Limit to VIN capabilities */
> -	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
> -			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
> +	if (vin->chip == RCAR_GEN3) {
> +		max_width = RVIN_MAX_WIDTH_GEN3;
> +		max_height = RVIN_MAX_HEIGHT_GEN3;
> +	} else {
> +		max_width = RVIN_MAX_WIDTH;
> +		max_height = RVIN_MAX_HEIGHT;
> +	}

This is one example where I think a device info structure would help. You 
could store there the maximum width and height, and remove the condition here.

Again, no need to change this now as long as we don't have too many such 
checks.

> +	v4l_bound_align_image(&pix->width, 2, max_width, walign,
> +			      &pix->height, 4, max_height, 2, 0);
> 
>  	switch (pix->field) {
>  	case V4L2_FIELD_NONE:
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index 81780f1..b97fa43 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -32,6 +32,7 @@
>  #define HW_BUFFER_MASK 0x7f
> 
>  enum chip_id {
> +	RCAR_GEN3,
>  	RCAR_GEN2,
>  	RCAR_H1,
>  	RCAR_M1,

Nitpicking, it looks weird to me to list them in reverse chronological order, 
I'd order them as

	RCAR_H1
	RCAR_M1
	RCAR_GEN2
	RCAR_GEN3

Another node 

-- 
Regards,

Laurent Pinchart

