Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38716 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935913AbdGTPMB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:12:01 -0400
Date: Thu, 20 Jul 2017 18:11:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 14/23] camss: vfe: Format conversion support using PIX
 interface
Message-ID: <20170720151157.2eeo6lcd2zlrx3es@valkosipuli.retiisi.org.uk>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-15-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500287629-23703-15-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Are you trying to get acks by posting drivers so big and complex that it'd
be unwieldy to meaningfully review them? :-)

On Mon, Jul 17, 2017 at 01:33:40PM +0300, Todor Tomov wrote:
> Use VFE PIX input interface and do format conversion in VFE.
> 
> Supported input format is UYVY (single plane YUV 4:2:2) and
> its different sample order variations.
> 
> Supported output formats are:
> - NV12/NV21 (two plane YUV 4:2:0)
> - NV16/NV61 (two plane YUV 4:2:2)
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  .../media/platform/qcom/camss-8x16/camss-ispif.c   |   2 +
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 673 ++++++++++++++++++---
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  13 +-
>  .../media/platform/qcom/camss-8x16/camss-video.c   | 332 +++++++---
>  .../media/platform/qcom/camss-8x16/camss-video.h   |   8 +-
>  5 files changed, 875 insertions(+), 153 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
> index cc32085..04918c0 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
> @@ -969,6 +969,8 @@ static enum ispif_intf ispif_get_intf(enum vfe_line_id line_id)
>  		return RDI1;
>  	case (VFE_LINE_RDI2):
>  		return RDI2;
> +	case (VFE_LINE_PIX):
> +		return PIX0;
>  	default:
>  		return RDI0;
>  	}
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> index b6dd29b..bef0209 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> @@ -19,6 +19,7 @@
>  #include <linux/completion.h>
>  #include <linux/interrupt.h>
>  #include <linux/iommu.h>
> +#include <linux/iopoll.h>
>  #include <linux/mutex.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> @@ -52,29 +53,53 @@
>  #define VFE_0_GLOBAL_RESET_CMD_BUS_MISR	(1 << 7)
>  #define VFE_0_GLOBAL_RESET_CMD_TESTGEN	(1 << 8)
>  
> +#define VFE_0_MODULE_CFG		0x018
> +#define VFE_0_MODULE_CFG_DEMUX			(1 << 2)
> +#define VFE_0_MODULE_CFG_CHROMA_UPSAMPLE	(1 << 3)
> +#define VFE_0_MODULE_CFG_SCALE_ENC		(1 << 23)
> +
> +#define VFE_0_CORE_CFG			0x01c
> +#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
> +#define VFE_0_CORE_CFG_PIXEL_PATTERN_YCRYCB	0x5
> +#define VFE_0_CORE_CFG_PIXEL_PATTERN_CBYCRY	0x6
> +#define VFE_0_CORE_CFG_PIXEL_PATTERN_CRYCBY	0x7
> +
>  #define VFE_0_IRQ_CMD			0x024
>  #define VFE_0_IRQ_CMD_GLOBAL_CLEAR	(1 << 0)
>  
>  #define VFE_0_IRQ_MASK_0		0x028
> +#define VFE_0_IRQ_MASK_0_CAMIF_SOF			(1 << 0)
> +#define VFE_0_IRQ_MASK_0_CAMIF_EOF			(1 << 1)
>  #define VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n)		(1 << ((n) + 5))
> +#define VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(n)		\
> +	((n) == VFE_LINE_PIX ? (1 << 4) : VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(n))
>  #define VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(n)	(1 << ((n) + 8))
> +#define VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(n)	(1 << ((n) + 25))
>  #define VFE_0_IRQ_MASK_0_RESET_ACK			(1 << 31)
>  #define VFE_0_IRQ_MASK_1		0x02c
> +#define VFE_0_IRQ_MASK_1_CAMIF_ERROR			(1 << 0)
>  #define VFE_0_IRQ_MASK_1_VIOLATION			(1 << 7)
>  #define VFE_0_IRQ_MASK_1_BUS_BDG_HALT_ACK		(1 << 8)
>  #define VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(n)	(1 << ((n) + 9))
> +#define VFE_0_IRQ_MASK_1_RDIn_SOF(n)			(1 << ((n) + 29))
>  
>  #define VFE_0_IRQ_CLEAR_0		0x030
>  #define VFE_0_IRQ_CLEAR_1		0x034
>  
>  #define VFE_0_IRQ_STATUS_0		0x038
> +#define VFE_0_IRQ_STATUS_0_CAMIF_SOF			(1 << 0)
>  #define VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n)		(1 << ((n) + 5))
> +#define VFE_0_IRQ_STATUS_0_line_n_REG_UPDATE(n)		\
> +	((n) == VFE_LINE_PIX ? (1 << 4) : VFE_0_IRQ_STATUS_0_RDIn_REG_UPDATE(n))
>  #define VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG(n)	(1 << ((n) + 8))
> +#define VFE_0_IRQ_STATUS_0_IMAGE_COMPOSITE_DONE_n(n)	(1 << ((n) + 25))
>  #define VFE_0_IRQ_STATUS_0_RESET_ACK			(1 << 31)
>  #define VFE_0_IRQ_STATUS_1		0x03c
>  #define VFE_0_IRQ_STATUS_1_VIOLATION			(1 << 7)
>  #define VFE_0_IRQ_STATUS_1_BUS_BDG_HALT_ACK		(1 << 8)
> +#define VFE_0_IRQ_STATUS_1_RDIn_SOF(n)			(1 << ((n) + 29))
>  
> +#define VFE_0_IRQ_COMPOSITE_MASK_0	0x40
>  #define VFE_0_VIOLATION_STATUS		0x48
>  
>  #define VFE_0_BUS_CMD			0x4c
> @@ -83,7 +108,10 @@
>  #define VFE_0_BUS_CFG			0x050
>  
>  #define VFE_0_BUS_XBAR_CFG_x(x)		(0x58 + 0x4 * ((x) / 2))
> +#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN			(1 << 1)
> +#define VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA	(0x3 << 4)
>  #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT		8
> +#define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA		0
>  #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI0	5
>  #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI1	6
>  #define VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_VAL_RDI2	7
> @@ -99,6 +127,8 @@
>  
>  #define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG(n)		(0x07c + 0x24 * (n))
>  #define VFE_0_BUS_IMAGE_MASTER_n_WR_UB_CFG_OFFSET_SHIFT	16
> +#define VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(n)	(0x080 + 0x24 * (n))
> +#define VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(n)	(0x084 + 0x24 * (n))
>  #define VFE_0_BUS_IMAGE_MASTER_n_WR_FRAMEDROP_PATTERN(n)	\
>  							(0x088 + 0x24 * (n))
>  #define VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(n)	\
> @@ -128,8 +158,41 @@
>  #define VFE_0_RDI_CFG_x_MIPI_EN_BITS		0x3
>  #define VFE_0_RDI_CFG_x_RDI_Mr_FRAME_BASED_EN(r)	(1 << (16 + (r)))
>  
> +#define VFE_0_CAMIF_CMD				0x2f4
> +#define VFE_0_CAMIF_CMD_DISABLE_FRAME_BOUNDARY	0
> +#define VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY	1
> +#define VFE_0_CAMIF_CMD_CLEAR_CAMIF_STATUS	(1 << 2)
> +#define VFE_0_CAMIF_CFG				0x2f8
> +#define VFE_0_CAMIF_CFG_VFE_OUTPUT_EN		(1 << 6)
> +#define VFE_0_CAMIF_FRAME_CFG			0x300
> +#define VFE_0_CAMIF_WINDOW_WIDTH_CFG		0x304
> +#define VFE_0_CAMIF_WINDOW_HEIGHT_CFG		0x308
> +#define VFE_0_CAMIF_SUBSAMPLE_CFG_0		0x30c
> +#define VFE_0_CAMIF_IRQ_SUBSAMPLE_PATTERN	0x314
> +#define VFE_0_CAMIF_STATUS			0x31c
> +#define VFE_0_CAMIF_STATUS_HALT			(1 << 31)
> +
>  #define VFE_0_REG_UPDATE			0x378
>  #define VFE_0_REG_UPDATE_RDIn(n)		(1 << (1 + (n)))
> +#define VFE_0_REG_UPDATE_line_n(n)		\
> +			((n) == VFE_LINE_PIX ? 1 : VFE_0_REG_UPDATE_RDIn(n))
> +
> +#define VFE_0_DEMUX_CFG				0x424
> +#define VFE_0_DEMUX_GAIN_0			0x428
> +#define VFE_0_DEMUX_GAIN_1			0x42c
> +#define VFE_0_DEMUX_EVEN_CFG			0x438
> +#define VFE_0_DEMUX_ODD_CFG			0x43c
> +
> +#define VFE_0_SCALE_ENC_CBCR_CFG		0x778
> +#define VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE	0x77c
> +#define VFE_0_SCALE_ENC_CBCR_H_PHASE		0x780
> +#define VFE_0_SCALE_ENC_CBCR_H_PAD		0x78c
> +#define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x790
> +#define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x794
> +#define VFE_0_SCALE_ENC_CBCR_V_PAD		0x7a0
> +
> +#define VFE_0_CLAMP_ENC_MAX_CFG			0x874
> +#define VFE_0_CLAMP_ENC_MIN_CFG			0x878
>  
>  #define VFE_0_CGC_OVERRIDE_1			0x974
>  #define VFE_0_CGC_OVERRIDE_1_IMAGE_Mx_CGC_OVERRIDE(x)	(1 << (x))
> @@ -143,6 +206,11 @@
>  /* Frame drop value. NOTE: VAL + UPDATES should not exceed 31 */
>  #define VFE_FRAME_DROP_VAL 20
>  
> +#define VFE_NEXT_SOF_MS 500
> +
> +#define CAMIF_TIMEOUT_SLEEP_US 1000
> +#define CAMIF_TIMEOUT_ALL_US 1000000
> +
>  static const u32 vfe_formats[] = {
>  	MEDIA_BUS_FMT_UYVY8_2X8,
>  	MEDIA_BUS_FMT_VYUY8_2X8,
> @@ -211,6 +279,32 @@ static void vfe_wm_frame_based(struct vfe_device *vfe, u8 wm, u8 enable)
>  			1 << VFE_0_BUS_IMAGE_MASTER_n_WR_CFG_FRM_BASED_SHIFT);
>  }
>  
> +static void vfe_wm_line_based(struct vfe_device *vfe, u32 wm,
> +			      u16 width, u16 height, u32 enable)
> +{
> +	u32 reg;
> +
> +	if (enable) {
> +		reg = height - 1;
> +		reg |= (width / 16 - 1) << 16;
> +
> +		writel_relaxed(reg, vfe->base +
> +			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
> +
> +		reg = 0x3;
> +		reg |= (height - 1) << 4;
> +		reg |= (width / 8) << 16;
> +
> +		writel_relaxed(reg, vfe->base +
> +			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
> +	} else {
> +		writel_relaxed(0, vfe->base +
> +			       VFE_0_BUS_IMAGE_MASTER_n_WR_IMAGE_SIZE(wm));
> +		writel_relaxed(0, vfe->base +
> +			       VFE_0_BUS_IMAGE_MASTER_n_WR_BUFFER_CFG(wm));
> +	}
> +}
> +
>  static void vfe_wm_set_framedrop_period(struct vfe_device *vfe, u8 wm, u8 per)
>  {
>  	u32 reg;
> @@ -314,7 +408,10 @@ static void vfe_bus_connect_wm_to_rdi(struct vfe_device *vfe, u8 wm,
>  		reg <<= 16;
>  
>  	vfe_reg_set(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
> +}
>  
> +static void vfe_wm_set_subsample(struct vfe_device *vfe, u8 wm)
> +{
>  	writel_relaxed(VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN_DEF,
>  	       vfe->base +
>  	       VFE_0_BUS_IMAGE_MASTER_n_WR_IRQ_SUBSAMPLE_PATTERN(wm));
> @@ -353,6 +450,38 @@ static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
>  	vfe_reg_clr(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
>  }
>  
> +static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
> +			     u8 enable)
> +{
> +	struct vfe_line *line = container_of(output, struct vfe_line, output);
> +	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
> +	u32 reg;
> +	unsigned int i;
> +
> +	for (i = 0; i < output->wm_num; i++) {
> +		if (i == 0) {
> +			reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA <<
> +				VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
> +		} else if (i == 1) {
> +			reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
> +			if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
> +				reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
> +		}
> +
> +		if (output->wm_idx[i] % 2 == 1)
> +			reg <<= 16;
> +
> +		if (enable)
> +			vfe_reg_set(vfe,
> +				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
> +				    reg);
> +		else
> +			vfe_reg_clr(vfe,
> +				    VFE_0_BUS_XBAR_CFG_x(output->wm_idx[i]),
> +				    reg);
> +	}
> +}
> +
>  static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
>  {
>  	vfe_reg_clr(vfe, VFE_0_RDI_CFG_x(id),
> @@ -364,7 +493,7 @@ static void vfe_set_rdi_cid(struct vfe_device *vfe, enum vfe_line_id id, u8 cid)
>  
>  static void vfe_reg_update(struct vfe_device *vfe, enum vfe_line_id line_id)
>  {
> -	vfe->reg_update |= VFE_0_REG_UPDATE_RDIn(line_id);
> +	vfe->reg_update |= VFE_0_REG_UPDATE_line_n(line_id);
>  	wmb();
>  	writel_relaxed(vfe->reg_update, vfe->base + VFE_0_REG_UPDATE);
>  	wmb();
> @@ -374,8 +503,9 @@ static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
>  				   enum vfe_line_id line_id, u8 enable)
>  {
>  	u32 irq_en0 = VFE_0_IRQ_MASK_0_IMAGE_MASTER_n_PING_PONG(wm) |
> -		      VFE_0_IRQ_MASK_0_RDIn_REG_UPDATE(line_id);
> -	u32 irq_en1 = VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(wm);
> +		      VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(line_id);
> +	u32 irq_en1 = VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(wm) |
> +		      VFE_0_IRQ_MASK_1_RDIn_SOF(line_id);
>  
>  	if (enable) {
>  		vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
> @@ -386,6 +516,37 @@ static void vfe_enable_irq_wm_line(struct vfe_device *vfe, u8 wm,
>  	}
>  }
>  
> +static void vfe_enable_irq_pix_line(struct vfe_device *vfe, u8 comp,
> +				    enum vfe_line_id line_id, u8 enable)
> +{
> +	struct vfe_output *output = &vfe->line[line_id].output;
> +	unsigned int i;
> +	u32 irq_en0;
> +	u32 irq_en1;
> +	u32 comp_mask = 0;
> +
> +	irq_en0 = VFE_0_IRQ_MASK_0_CAMIF_SOF;
> +	irq_en0 |= VFE_0_IRQ_MASK_0_CAMIF_EOF;
> +	irq_en0 |= VFE_0_IRQ_MASK_0_IMAGE_COMPOSITE_DONE_n(comp);
> +	irq_en0 |= VFE_0_IRQ_MASK_0_line_n_REG_UPDATE(line_id);
> +	irq_en1 = VFE_0_IRQ_MASK_1_CAMIF_ERROR;
> +	for (i = 0; i < output->wm_num; i++) {
> +		irq_en1 |= VFE_0_IRQ_MASK_1_IMAGE_MASTER_n_BUS_OVERFLOW(
> +							output->wm_idx[i]);
> +		comp_mask |= (1 << output->wm_idx[i]) << comp * 8;
> +	}
> +
> +	if (enable) {
> +		vfe_reg_set(vfe, VFE_0_IRQ_MASK_0, irq_en0);
> +		vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
> +		vfe_reg_set(vfe, VFE_0_IRQ_COMPOSITE_MASK_0, comp_mask);
> +	} else {
> +		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_0, irq_en0);
> +		vfe_reg_clr(vfe, VFE_0_IRQ_MASK_1, irq_en1);
> +		vfe_reg_clr(vfe, VFE_0_IRQ_COMPOSITE_MASK_0, comp_mask);
> +	}
> +}
> +
>  static void vfe_enable_irq_common(struct vfe_device *vfe)
>  {
>  	u32 irq_en0 = VFE_0_IRQ_MASK_0_RESET_ACK;
> @@ -396,6 +557,83 @@ static void vfe_enable_irq_common(struct vfe_device *vfe)
>  	vfe_reg_set(vfe, VFE_0_IRQ_MASK_1, irq_en1);
>  }
>  
> +static void vfe_set_demux_cfg(struct vfe_device *vfe, struct vfe_line *line)
> +{
> +	u32 even_cfg, odd_cfg;
> +
> +	writel_relaxed(0x3, vfe->base + VFE_0_DEMUX_CFG);
> +	writel_relaxed(0x800080, vfe->base + VFE_0_DEMUX_GAIN_0);
> +	writel_relaxed(0x800080, vfe->base + VFE_0_DEMUX_GAIN_1);
> +
> +	switch (line->fmt[MSM_VFE_PAD_SINK].code) {
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +		even_cfg = 0x9cac;
> +		odd_cfg = 0x9cac;

#Defines, please? Same below.

> +		break;
> +	case MEDIA_BUS_FMT_YVYU8_2X8:
> +		even_cfg = 0xac9c;
> +		odd_cfg = 0xac9c;
> +		break;
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	default:
> +		even_cfg = 0xc9ca;
> +		odd_cfg = 0xc9ca;
> +		break;
> +	case MEDIA_BUS_FMT_VYUY8_2X8:
> +		even_cfg = 0xcac9;
> +		odd_cfg = 0xcac9;
> +		break;
> +	}
> +
> +	writel_relaxed(even_cfg, vfe->base + VFE_0_DEMUX_EVEN_CFG);
> +	writel_relaxed(odd_cfg, vfe->base + VFE_0_DEMUX_ODD_CFG);
> +}
> +
> +static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
> +{
> +	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
> +	u32 reg;
> +	u16 input, output;
> +	u8 interp_reso;
> +	u32 phase_mult;
> +
> +	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_CBCR_CFG);
> +
> +	input = line->fmt[MSM_VFE_PAD_SINK].width;
> +	output = line->fmt[MSM_VFE_PAD_SRC].width / 2;
> +	reg = (output << 16) | input;
> +	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE);
> +
> +	interp_reso = 3;
> +	phase_mult = input * (1 << (13 + interp_reso)) / output;
> +	reg = (interp_reso << 20) | phase_mult;
> +	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PHASE);
> +
> +	reg = input;
> +	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PAD);
> +
> +	input = line->fmt[MSM_VFE_PAD_SINK].height;
> +	output = line->fmt[MSM_VFE_PAD_SRC].height;
> +	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21)
> +		output = line->fmt[MSM_VFE_PAD_SRC].height / 2;
> +	reg = (output << 16) | input;
> +	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE);
> +
> +	interp_reso = 3;
> +	phase_mult = input * (1 << (13 + interp_reso)) / output;
> +	reg = (interp_reso << 20) | phase_mult;
> +	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PHASE);
> +
> +	reg = input;
> +	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PAD);
> +}
> +
> +static void vfe_set_clamp_cfg(struct vfe_device *vfe)
> +{
> +	writel_relaxed(0x00ffffff, vfe->base + VFE_0_CLAMP_ENC_MAX_CFG);
> +	writel_relaxed(0x0, vfe->base + VFE_0_CLAMP_ENC_MIN_CFG);

Ditto.

> +}
> +
>  /*
>   * vfe_reset - Trigger reset on VFE module and wait to complete
>   * @vfe: VFE device

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
