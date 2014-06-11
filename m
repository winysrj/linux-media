Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58562 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaFKGS6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 02:18:58 -0400
Date: Wed, 11 Jun 2014 08:18:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH 08/43] imx-drm: ipu-v3: Add units required for video
 capture
Message-ID: <20140611061856.GC664@pengutronix.de>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
 <1402178205-22697-9-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402178205-22697-9-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 07, 2014 at 02:56:10PM -0700, Steve Longerbeam wrote:
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
> @@ -915,8 +923,44 @@ static int ipu_submodules_init(struct ipu_soc *ipu,
>  	struct device *dev = &pdev->dev;
>  	const struct ipu_devtype *devtype = ipu->devtype;
>  
> +	ret = ipu_csi_init(ipu, dev, 0, ipu_base + devtype->csi0_ofs,
> +			   IPU_CONF_CSI0_EN, ipu_clk);
> +	if (ret) {
> +		unit = "csi0";
> +		goto err_csi_0;
> +	}

Please be nice to other SoCs. You set csi0_ofs for i.MX6, but not for
i.MX5. For i.MX5 you silently initialize the CSI with bogus register
offsets. Either test for _ofs == 0 before initializing it or add the
correct values for i.MX51/53 (preferred).

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

This is not a property of the IPU but how the IPU is integrated into the
SoC. I'm unsure this should be integrated like this, it sounds more like
a job for mediactrl.

> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/spinlock.h>
> +#include <linux/videodev2.h>
> +#include <linux/bitrev.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>

Please clean up the include list. There is nothing used from
clk-provider.h for example.

> +static int init_csc(struct ipu_ic *ic,
> +		    enum ipu_color_space in_format,
> +		    enum ipu_color_space out_format,
> +		    int csc_index);
> +static int calc_resize_coeffs(struct ipu_ic *ic,
> +			      u32 in_size, u32 out_size,
> +			      u32 *resize_coeff,
> +			      u32 *downsize_coeff);

Please reorder functions to get rid of static function declarations.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
