Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55863 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaFKOJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 10:09:12 -0400
Message-ID: <1402495749.4107.169.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 08/43] imx-drm: ipu-v3: Add units required for video
 capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 16:09:09 +0200
In-Reply-To: <1402178205-22697-9-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-9-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Adds the following new IPU units:
> 
> - Camera Sensor Interface (csi)
> - Sensor Multi FIFO Controller (smfc)
> - Image Converter (ic)
> - Image Rotator (irt)
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/imx-drm/ipu-v3/Makefile     |    3 +-
>  drivers/staging/imx-drm/ipu-v3/ipu-common.c |   67 ++-
>  drivers/staging/imx-drm/ipu-v3/ipu-csi.c    |  821 ++++++++++++++++++++++++++
>  drivers/staging/imx-drm/ipu-v3/ipu-ic.c     |  835 +++++++++++++++++++++++++++
>  drivers/staging/imx-drm/ipu-v3/ipu-irt.c    |  103 ++++
>  drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |   24 +
>  drivers/staging/imx-drm/ipu-v3/ipu-smfc.c   |  348 +++++++++++
>  include/linux/platform_data/imx-ipu-v3.h    |  151 +++++

You are broadening the internal API quite a bit. For the IC and IRT that
certainly can't be helped, but the CSI could very well be completely
encapsulated in a v4l2_subdev. I wonder if it wouldn't be better to move
the CSI code into the drivers/media part.

>  8 files changed, 2350 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-csi.c
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-ic.c
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-irt.c
>  create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-smfc.c
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/Makefile b/drivers/staging/imx-drm/ipu-v3/Makefile
> index 28ed72e..79c0c88 100644
> --- a/drivers/staging/imx-drm/ipu-v3/Makefile
> +++ b/drivers/staging/imx-drm/ipu-v3/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_DRM_IMX_IPUV3_CORE) += imx-ipu-v3.o
>  
> -imx-ipu-v3-objs := ipu-common.o ipu-dc.o ipu-di.o ipu-dp.o ipu-dmfc.o
> +imx-ipu-v3-objs := ipu-common.o ipu-csi.o ipu-dc.o ipu-di.o \
> +	ipu-dp.o ipu-dmfc.o ipu-ic.o ipu-irt.o ipu-smfc.o
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> index 1c606b5..3d7e28d 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> @@ -834,6 +834,10 @@ struct ipu_devtype {
>  	unsigned long cpmem_ofs;
>  	unsigned long srm_ofs;
>  	unsigned long tpm_ofs;
> +	unsigned long csi0_ofs;
> +	unsigned long csi1_ofs;
> +	unsigned long smfc_ofs;
> +	unsigned long ic_ofs;
>  	unsigned long disp0_ofs;
>  	unsigned long disp1_ofs;
>  	unsigned long dc_tmpl_ofs;
> @@ -873,8 +877,12 @@ static struct ipu_devtype ipu_type_imx6q = {
>  	.cpmem_ofs = 0x00300000,
>  	.srm_ofs = 0x00340000,
>  	.tpm_ofs = 0x00360000,
> +	.csi0_ofs = 0x00230000,
> +	.csi1_ofs = 0x00238000,
>  	.disp0_ofs = 0x00240000,
>  	.disp1_ofs = 0x00248000,
> +	.smfc_ofs =  0x00250000,
> +	.ic_ofs = 0x00220000,
>  	.dc_tmpl_ofs = 0x00380000,
>  	.vdi_ofs = 0x00268000,
>  	.type = IPUV3H,

This is missing the initalization for i.MX5.

[...]
> +#define GPR1_IPU_CSI_MUX_CTL_SHIFT 19
> +#define GPR13_IPUV3HDL_CSI_MUX_CTL_SHIFT 0
> +
> +int ipu_csi_set_src(struct ipu_csi *csi, u32 vc, bool select_mipi_csi2)
> +{
> +	struct ipu_soc *ipu = csi->ipu;
> +	int ipu_id = ipu_get_num(ipu);
> +	u32 val, bit;
> +
> +	/*
> +	 * Set the muxes that choose between mipi-csi2 and parallel inputs
> +	 * to the CSI's.
> +	 */
> +	if (csi->ipu->ipu_type == IPUV3HDL) {
> +		/*
> +		 * On D/L, the mux is in GPR13. The TRM is unclear,
> +		 * but it appears the mux allows selecting the MIPI
> +		 * CSI-2 virtual channel number to route to the CSIs.
> +		 */
> +		bit = GPR13_IPUV3HDL_CSI_MUX_CTL_SHIFT + csi->id * 3;
> +		val = select_mipi_csi2 ? vc << bit : 4 << bit;
> +		regmap_update_bits(ipu->gp_reg, IOMUXC_GPR13,
> +				   0x7 << bit, val);
> +	} else if (csi->ipu->ipu_type == IPUV3H) {
> +		/*
> +		 * For Q/D, the mux only exists on IPU0-CSI0 and IPU1-CSI1,
> +		 * and the routed virtual channel numbers are fixed at 0 and
> +		 * 3 respectively.
> +		 */
> +		if ((ipu_id == 0 && csi->id == 0) ||
> +		    (ipu_id == 1 && csi->id == 1)) {
> +			bit = GPR1_IPU_CSI_MUX_CTL_SHIFT + csi->ipu->id;
> +			val = select_mipi_csi2 ? 0 : 1 << bit;
> +			regmap_update_bits(ipu->gp_reg, IOMUXC_GPR1,
> +					   0x1 << bit, val);
> +		}
> +	} else {
> +		dev_err(csi->ipu->dev,
> +			"ERROR: %s: unsupported CPU version!\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * there is another mux in the IPU config register that
> +	 * must be set as well
> +	 */
> +	ipu_set_csi_src_mux(ipu, csi->id, select_mipi_csi2);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_csi_set_src);

In my opinion, this doesn't belong here. These multiplexers should be
separate subdevices described in the device tree.

[...]
> +int ipu_csi_get_sensor_protocol(struct ipu_csi *csi)
> +bool ipu_csi_is_interlaced(struct ipu_csi *csi)
> +void ipu_csi_get_window_size(struct ipu_csi *csi, u32 *width, u32 *height)
> +void ipu_csi_set_window_size(struct ipu_csi *csi, u32 width, u32 height)
> +void ipu_csi_set_window_pos(struct ipu_csi *csi, u32 left, u32 top)
> +void ipu_csi_horizontal_downsize_enable(struct ipu_csi *csi)
> +void ipu_csi_horizontal_downsize_disable(struct ipu_csi *csi)
> +void ipu_csi_vertical_downsize_enable(struct ipu_csi *csi)
> +void ipu_csi_vertical_downsize_disable(struct ipu_csi *csi)
> +void ipu_csi_set_test_generator(struct ipu_csi *csi, bool active,
> +				u32 r_value, u32 g_value, u32 b_value,
> +				u32 pix_clk)
> +int ipu_csi_set_mipi_datatype(struct ipu_csi *csi, u32 vc,
> +			      struct ipu_csi_signal_cfg *cfg)
> +int ipu_csi_set_skip_isp(struct ipu_csi *csi, u32 skip, u32 max_ratio)
> +int ipu_csi_set_skip_smfc(struct ipu_csi *csi, u32 skip,
> +			  u32 max_ratio, u32 id)
> +int ipu_csi_set_dest(struct ipu_csi *csi, bool ic)

All of these are small wrappers around register access, making them
ideal candidates for being inlined if included in the driver using
them ...

> +int ipu_csi_get_num(struct ipu_csi *csi)
> +{
> +	return csi->id;
> +}
> +EXPORT_SYMBOL_GPL(ipu_csi_get_num);

... and this could be dropped completely.

[...]
> +static int init_csc(struct ipu_ic *ic,
> +		    enum ipu_color_space in_format,
> +		    enum ipu_color_space out_format,
> +		    int csc_index)
> +{
> +	struct ipu_ic_priv *priv = ic->priv;
> +	u32 __iomem *base;
> +	u32 param;
> +
> +	base = (u32 __iomem *)
> +		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
> +
> +	if (in_format == IPUV3_COLORSPACE_YUV &&
> +	    out_format == IPUV3_COLORSPACE_RGB) {
> +		/* Init CSC (YCbCr->RGB) */
> +		param = (ycbcr2rgb_coeff[3][0] << 27) |
> +			(ycbcr2rgb_coeff[0][0] << 18) |
> +			(ycbcr2rgb_coeff[1][1] << 9) |
> +			ycbcr2rgb_coeff[2][2];
> +		writel(param, base++);
> +
> +		/* scale = 2, sat = 0 */
> +		param = (ycbcr2rgb_coeff[3][0] >> 5) |
> +			(2L << (40 - 32));
> +		writel(param, base++);
> +
> +		param = (ycbcr2rgb_coeff[3][1] << 27) |
> +			(ycbcr2rgb_coeff[0][1] << 18) |
> +			(ycbcr2rgb_coeff[1][0] << 9) |
> +			ycbcr2rgb_coeff[2][0];
> +		writel(param, base++);
> +
> +		param = (ycbcr2rgb_coeff[3][1] >> 5);
> +		writel(param, base++);
> +
> +		param = (ycbcr2rgb_coeff[3][2] << 27) |
> +			(ycbcr2rgb_coeff[0][2] << 18) |
> +			(ycbcr2rgb_coeff[1][2] << 9) |
> +			ycbcr2rgb_coeff[2][1];
> +		writel(param, base++);
> +
> +		param = (ycbcr2rgb_coeff[3][2] >> 5);
> +		writel(param, base++);

This should be split out into a helper function ...

> +	} else if (in_format == IPUV3_COLORSPACE_RGB &&
> +		   out_format == IPUV3_COLORSPACE_YUV) {
> +		/* Init CSC (RGB->YCbCr) */
> +		param = (rgb2ycbcr_coeff[3][0] << 27) |
> +			(rgb2ycbcr_coeff[0][0] << 18) |
> +			(rgb2ycbcr_coeff[1][1] << 9) |
> +			rgb2ycbcr_coeff[2][2];
> +		writel(param, base++);
> +
> +		/* scale = 1, sat = 0 */
> +		param = (rgb2ycbcr_coeff[3][0] >> 5) | (1UL << 8);
> +		writel(param, base++);
> +
> +		param = (rgb2ycbcr_coeff[3][1] << 27) |
> +			(rgb2ycbcr_coeff[0][1] << 18) |
> +			(rgb2ycbcr_coeff[1][0] << 9) |
> +			rgb2ycbcr_coeff[2][0];
> +		writel(param, base++);
> +
> +		param = (rgb2ycbcr_coeff[3][1] >> 5);
> +		writel(param, base++);
> +
> +		param = (rgb2ycbcr_coeff[3][2] << 27) |
> +			(rgb2ycbcr_coeff[0][2] << 18) |
> +			(rgb2ycbcr_coeff[1][2] << 9) |
> +			rgb2ycbcr_coeff[2][1];
> +		writel(param, base++);
> +
> +		param = (rgb2ycbcr_coeff[3][2] >> 5);
> +		writel(param, base++);

... and be reused here ...

> +	} else if (in_format == IPUV3_COLORSPACE_RGB &&
> +		   out_format == IPUV3_COLORSPACE_RGB) {
> +		/* Init CSC */
> +		param = (rgb2rgb_coeff[3][0] << 27) |
> +			(rgb2rgb_coeff[0][0] << 18) |
> +			(rgb2rgb_coeff[1][1] << 9) |
> +			rgb2rgb_coeff[2][2];
> +		writel(param, base++);
> +
> +		/* scale = 2, sat = 0 */
> +		param = (rgb2rgb_coeff[3][0] >> 5) | (2UL << 8);
> +		writel(param, base++);
> +
> +		param = (rgb2rgb_coeff[3][1] << 27) |
> +			(rgb2rgb_coeff[0][1] << 18) |
> +			(rgb2rgb_coeff[1][0] << 9) |
> +			rgb2rgb_coeff[2][0];
> +		writel(param, base++);
> +
> +		param = (rgb2rgb_coeff[3][1] >> 5);
> +		writel(param, base++);
> +
> +		param = (rgb2rgb_coeff[3][2] << 27) |
> +			(rgb2rgb_coeff[0][2] << 18) |
> +			(rgb2rgb_coeff[1][2] << 9) |
> +			rgb2rgb_coeff[2][1];
> +		writel(param, base++);
> +
> +		param = (rgb2rgb_coeff[3][2] >> 5);
> +		writel(param, base++);

... and here.

> +	} else {
> +		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
[...]
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-irt.c b/drivers/staging/imx-drm/ipu-v3/ipu-irt.c

This whole file just contains a use count and and module enable/disable
wrappers. I believe this is simple enough to be included in ipu-common.

[...]
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-smfc.c b/drivers/staging/imx-drm/ipu-v3/ipu-smfc.c

This is mostly included in drm-next already. It would be great if you
could rebase on that.

regards
Philipp

