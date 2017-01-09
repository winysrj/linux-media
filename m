Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39685 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750968AbdAIMKf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 07:10:35 -0500
Subject: Re: [PATCH] [media] atmel-isc: add the isc pipeline function
To: Songjun Wu <songjun.wu@microchip.com>, nicolas.ferre@microchip.com
References: <20161223092420.30466-1-songjun.wu@microchip.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7f13689c-8944-1143-2117-6b8884b65214@xs4all.nl>
Date: Mon, 9 Jan 2017 13:10:28 +0100
MIME-Version: 1.0
In-Reply-To: <20161223092420.30466-1-songjun.wu@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2016 10:24 AM, Songjun Wu wrote:
> Image Sensor Controller has an internal image processor.
> It can convert raw format to the other formats, like
> RGB565, YUV420P. A module parameter 'sensor_preferred'
> is used to enable or disable the pipeline function.
> Some v4l2 controls are added to tuning the image when
> the pipeline function is enabled.
> 
> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
> ---
> 
>  drivers/media/platform/atmel/atmel-isc-regs.h | 102 ++++-
>  drivers/media/platform/atmel/atmel-isc.c      | 629 +++++++++++++++++++++-----
>  2 files changed, 623 insertions(+), 108 deletions(-)
> 
> diff --git a/drivers/media/platform/atmel/atmel-isc-regs.h b/drivers/media/platform/atmel/atmel-isc-regs.h
> index 00c449717cde..6936ac467609 100644
> --- a/drivers/media/platform/atmel/atmel-isc-regs.h
> +++ b/drivers/media/platform/atmel/atmel-isc-regs.h
> @@ -65,6 +65,7 @@
>  #define ISC_INTSR       0x00000034
>  
>  #define ISC_INT_DDONE		BIT(8)
> +#define ISC_INT_HISDONE		BIT(12)
>  
>  /* ISC White Balance Control Register */
>  #define ISC_WB_CTRL     0x00000058
> @@ -72,30 +73,98 @@
>  /* ISC White Balance Configuration Register */
>  #define ISC_WB_CFG      0x0000005c
>  
> +/* ISC White Balance Offset for R, GR Register */
> +#define ISC_WB_O_RGR	0x00000060
> +
> +/* ISC White Balance Offset for B, GB Register */
> +#define ISC_WB_O_BGR	0x00000064
> +
> +/* ISC White Balance Gain for R, GR Register */
> +#define ISC_WB_G_RGR	0x00000068
> +
> +/* ISC White Balance Gain for B, GB Register */
> +#define ISC_WB_G_BGR	0x0000006c
> +
>  /* ISC Color Filter Array Control Register */
>  #define ISC_CFA_CTRL    0x00000070
>  
>  /* ISC Color Filter Array Configuration Register */
>  #define ISC_CFA_CFG     0x00000074
> +#define ISC_CFA_CFG_EITPOL	BIT(4)
>  
>  #define ISC_BAY_CFG_GRGR	0x0
>  #define ISC_BAY_CFG_RGRG	0x1
>  #define ISC_BAY_CFG_GBGB	0x2
>  #define ISC_BAY_CFG_BGBG	0x3
> -#define ISC_BAY_CFG_MASK	GENMASK(1, 0)
>  
>  /* ISC Color Correction Control Register */
>  #define ISC_CC_CTRL     0x00000078
>  
> +/* ISC Color Correction RR RG Register */
> +#define ISC_CC_RR_RG	0x0000007c
> +
> +/* ISC Color Correction RB OR Register */
> +#define ISC_CC_RB_OR	0x00000080
> +
> +/* ISC Color Correction GR GG Register */
> +#define ISC_CC_GR_GG	0x00000084
> +
> +/* ISC Color Correction GB OG Register */
> +#define ISC_CC_GB_OG	0x00000088
> +
> +/* ISC Color Correction BR BG Register */
> +#define ISC_CC_BR_BG	0x0000008c
> +
> +/* ISC Color Correction BB OB Register */
> +#define ISC_CC_BB_OB	0x00000090
> +
>  /* ISC Gamma Correction Control Register */
>  #define ISC_GAM_CTRL    0x00000094
>  
> +/* ISC_Gamma Correction Blue Entry Register */
> +#define ISC_GAM_BENTRY	0x00000098
> +
> +/* ISC_Gamma Correction Green Entry Register */
> +#define ISC_GAM_GENTRY	0x00000198
> +
> +/* ISC_Gamma Correction Green Entry Register */
> +#define ISC_GAM_RENTRY	0x00000298
> +
>  /* Color Space Conversion Control Register */
>  #define ISC_CSC_CTRL    0x00000398
>  
> +/* Color Space Conversion YR YG Register */
> +#define ISC_CSC_YR_YG	0x0000039c
> +
> +/* Color Space Conversion YB OY Register */
> +#define ISC_CSC_YB_OY	0x000003a0
> +
> +/* Color Space Conversion CBR CBG Register */
> +#define ISC_CSC_CBR_CBG	0x000003a4
> +
> +/* Color Space Conversion CBB OCB Register */
> +#define ISC_CSC_CBB_OCB	0x000003a8
> +
> +/* Color Space Conversion CRR CRG Register */
> +#define ISC_CSC_CRR_CRG	0x000003ac
> +
> +/* Color Space Conversion CRB OCR Register */
> +#define ISC_CSC_CRB_OCR	0x000003b0
> +
>  /* Contrast And Brightness Control Register */
>  #define ISC_CBC_CTRL    0x000003b4
>  
> +/* Contrast And Brightness Configuration Register */
> +#define ISC_CBC_CFG	0x000003b8
> +
> +/* Brightness Register */
> +#define ISC_CBC_BRIGHT	0x000003bc
> +#define ISC_CBC_BRIGHT_MASK	GENMASK(10, 0)
> +
> +/* Contrast Register */
> +#define ISC_CBC_CONTRAST	0x000003c0
> +#define ISC_CBC_CONTRAST_MASK	GENMASK(11, 0)
> +
>  /* Subsampling 4:4:4 to 4:2:2 Control Register */
>  #define ISC_SUB422_CTRL 0x000003c4
>  
> @@ -120,6 +189,27 @@
>  #define ISC_RLP_CFG_MODE_YYCC_LIMITED   0xc
>  #define ISC_RLP_CFG_MODE_MASK           GENMASK(3, 0)
>  
> +/* Histogram Control Register */
> +#define ISC_HIS_CTRL	0x000003d4
> +
> +#define ISC_HIS_CTRL_EN			BIT(0)
> +#define ISC_HIS_CTRL_DIS		0x0
> +
> +/* Histogram Configuration Register */
> +#define ISC_HIS_CFG	0x000003d8
> +
> +#define ISC_HIS_CFG_MODE_GR		0x0
> +#define ISC_HIS_CFG_MODE_R		0x1
> +#define ISC_HIS_CFG_MODE_GB		0x2
> +#define ISC_HIS_CFG_MODE_B		0x3
> +#define ISC_HIS_CFG_MODE_Y		0x4
> +#define ISC_HIS_CFG_MODE_RAW		0x5
> +#define ISC_HIS_CFG_MODE_YCCIR656	0x6
> +
> +#define ISC_HIS_CFG_BAYSEL_SHIFT	4
> +
> +#define ISC_HIS_CFG_RAR			BIT(8)
> +
>  /* DMA Configuration Register */
>  #define ISC_DCFG        0x000003e0
>  #define ISC_DCFG_IMODE_PACKED8          0x0
> @@ -159,7 +249,13 @@
>  /* DMA Address 0 Register */
>  #define ISC_DAD0        0x000003ec
>  
> -/* DMA Stride 0 Register */
> -#define ISC_DST0        0x000003f0
> +/* DMA Address 1 Register */
> +#define ISC_DAD1        0x000003f4
> +
> +/* DMA Address 2 Register */
> +#define ISC_DAD2        0x000003fc
> +
> +/* Histogram Entry */
> +#define ISC_HIS_ENTRY	0x00000410
>  
>  #endif
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index fa68fe912c95..ff526022e103 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -29,6 +29,7 @@
>  #include <linux/clk-provider.h>
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> +#include <linux/math64.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> @@ -36,7 +37,9 @@
>  #include <linux/regmap.h>
>  #include <linux/videodev2.h>
>  
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-of.h>
> @@ -89,10 +92,12 @@ struct isc_subdev_entity {
>   * struct isc_format - ISC media bus format information
>   * @fourcc:		Fourcc code for this format
>   * @mbus_code:		V4L2 media bus format code.
> - * @bpp:		Bytes per pixel (when stored in memory)
> + * @bpp:		Bits per pixel (when stored in memory)
>   * @reg_bps:		reg value for bits per sample
>   *			(when transferred over a bus)
> - * @support:		Indicates format supported by subdev
> + * @pipeline:		pipeline switch
> + * @sd_support:		Subdev supports this format
> + * @isc_support:	ISC can convert raw format to this format
>   */
>  struct isc_format {
>  	u32	fourcc;
> @@ -100,11 +105,42 @@ struct isc_format {
>  	u8	bpp;
>  
>  	u32	reg_bps;
> +	u32	reg_bay_cfg;
>  	u32	reg_rlp_mode;
>  	u32	reg_dcfg_imode;
>  	u32	reg_dctrl_dview;
>  
> -	bool	support;
> +	u32	pipeline;
> +
> +	bool	sd_support;
> +	bool	isc_support;
> +};
> +
> +
> +#define HIST_ENTRIES		512
> +#define HIST_BAYER		(ISC_HIS_CFG_MODE_B + 1)
> +
> +enum{
> +	HIST_INIT = 0,
> +	HIST_ENABLED,
> +	HIST_DISABLED,
> +};
> +
> +struct isc_ctrls {
> +	struct v4l2_ctrl_handler handler;
> +
> +	u32 brightness;
> +	u32 contrast;
> +	u8 gamma_index;
> +	u8 awb;
> +
> +	u32 r_gain;
> +	u32 b_gain;
> +
> +	u32 hist_entry[HIST_ENTRIES];
> +	u32 hist_count[HIST_BAYER];
> +	u8 hist_id;
> +	u8 hist_stat;
>  };
>  
>  #define ISC_PIPE_LINE_NODE_NUM	11
> @@ -131,6 +167,10 @@ struct isc_device {
>  	struct isc_format	**user_formats;
>  	unsigned int		num_user_formats;
>  	const struct isc_format	*current_fmt;
> +	const struct isc_format	*raw_fmt;
> +
> +	struct isc_ctrls	ctrls;
> +	struct work_struct	awb_work;
>  
>  	struct mutex		lock;
>  
> @@ -140,51 +180,134 @@ struct isc_device {
>  	struct list_head		subdev_entities;
>  };
>  
> +#define RAW_FMT_INDEX_START	0
> +#define RAW_FMT_INDEX_END	11
> +#define ISC_FMT_INDEX_START	12
> +#define ISC_FMT_INDEX_END	14
> +
>  static struct isc_format isc_formats[] = {
> -	{ V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8,
> -	  1, ISC_PFE_CFG0_BPS_EIGHT, ISC_RLP_CFG_MODE_DAT8,
> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8,
> -	  1, ISC_PFE_CFG0_BPS_EIGHT, ISC_RLP_CFG_MODE_DAT8,
> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8,
> -	  1, ISC_PFE_CFG0_BPS_EIGHT, ISC_RLP_CFG_MODE_DAT8,
> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8,
> -	  1, ISC_PFE_CFG0_BPS_EIGHT, ISC_RLP_CFG_MODE_DAT8,
> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, false },
> -
> -	{ V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10,
> -	  2, ISC_PFG_CFG0_BPS_TEN, ISC_RLP_CFG_MODE_DAT10,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10,
> -	  2, ISC_PFG_CFG0_BPS_TEN, ISC_RLP_CFG_MODE_DAT10,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10,
> -	  2, ISC_PFG_CFG0_BPS_TEN, ISC_RLP_CFG_MODE_DAT10,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10,
> -	  2, ISC_PFG_CFG0_BPS_TEN, ISC_RLP_CFG_MODE_DAT10,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -
> -	{ V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12,
> -	  2, ISC_PFG_CFG0_BPS_TWELVE, ISC_RLP_CFG_MODE_DAT12,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12,
> -	  2, ISC_PFG_CFG0_BPS_TWELVE, ISC_RLP_CFG_MODE_DAT12,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12,
> -	  2, ISC_PFG_CFG0_BPS_TWELVE, ISC_RLP_CFG_MODE_DAT12,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -	{ V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12,
> -	  2, ISC_PFG_CFG0_BPS_TWELVE, ISC_RLP_CFG_MODE_DAT12,
> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, false },
> -
> -	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8,
> -	  2, ISC_PFE_CFG0_BPS_EIGHT, ISC_RLP_CFG_MODE_DAT8,
> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, false },
> +	{ V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8, 8,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
> +	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8, 8,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT8,
> +	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8, 8,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT8,
> +	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8, 8,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT8,
> +	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +
> +	{ V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10, 16,
> +	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT10,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10, 16,
> +	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT10,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10, 16,
> +	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT10,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10, 16,
> +	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT10,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +
> +	{ V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12, 16,
> +	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT12,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12, 16,
> +	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT12,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12, 16,
> +	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT12,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +	{ V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12, 16,
> +	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT12,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +
> +	{ V4L2_PIX_FMT_YUV420, 0x0, 12,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
> +	  ISC_DCFG_IMODE_YC420P | ISC_DCFG_YMBSIZE_BEATS8 |
> +	  ISC_DCFG_CMBSIZE_BEATS8, ISC_DCTRL_DVIEW_PLANAR, 0x7fb,
> +	  false, false },
> +	{ V4L2_PIX_FMT_YUV422P, 0x0, 16,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
> +	  ISC_DCFG_IMODE_YC422P | ISC_DCFG_YMBSIZE_BEATS8 |
> +	  ISC_DCFG_CMBSIZE_BEATS8, ISC_DCTRL_DVIEW_PLANAR, 0x3fb,
> +	  false, false },
> +	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_RGB565_2X8_LE, 16,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_RGB565,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b,
> +	  false, false },
> +
> +	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, 16,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
> +	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
> +	  false, false },
> +};
> +
> +#define GAMMA_MAX	3
> +#define GAMMA_ENTRIES	64
> +
> +/* Gamma table with gamma 1/2.2 */
> +static const u32 isc_gamma_table[GAMMA_MAX][GAMMA_ENTRIES] = {
> +	/* 0 --> gamma 1/1.8 */
> +	{      0x65,  0x66002F,  0x950025,  0xBB0020,  0xDB001D,  0xF8001A,
> +	  0x1130018, 0x12B0017, 0x1420016, 0x1580014, 0x16D0013, 0x1810012,
> +	  0x1940012, 0x1A60012, 0x1B80011, 0x1C90010, 0x1DA0010, 0x1EA000F,
> +	  0x1FA000F, 0x209000F, 0x218000F, 0x227000E, 0x235000E, 0x243000E,
> +	  0x251000E, 0x25F000D, 0x26C000D, 0x279000D, 0x286000D, 0x293000C,
> +	  0x2A0000C, 0x2AC000C, 0x2B8000C, 0x2C4000C, 0x2D0000B, 0x2DC000B,
> +	  0x2E7000B, 0x2F3000B, 0x2FE000B, 0x309000B, 0x314000B, 0x31F000A,
> +	  0x32A000A, 0x334000B, 0x33F000A, 0x349000A, 0x354000A, 0x35E000A,
> +	  0x368000A, 0x372000A, 0x37C000A, 0x386000A, 0x3900009, 0x399000A,
> +	  0x3A30009, 0x3AD0009, 0x3B60009, 0x3BF000A, 0x3C90009, 0x3D20009,
> +	  0x3DB0009, 0x3E40009, 0x3ED0009, 0x3F60009 },
> +
> +	/* 1 --> gamma 1/2 */
> +	{      0x7F,  0x800034,  0xB50028,  0xDE0021, 0x100001E, 0x11E001B,
> +	  0x1390019, 0x1520017, 0x16A0015, 0x1800014, 0x1940014, 0x1A80013,
> +	  0x1BB0012, 0x1CD0011, 0x1DF0010, 0x1EF0010, 0x200000F, 0x20F000F,
> +	  0x21F000E, 0x22D000F, 0x23C000E, 0x24A000E, 0x258000D, 0x265000D,
> +	  0x273000C, 0x27F000D, 0x28C000C, 0x299000C, 0x2A5000C, 0x2B1000B,
> +	  0x2BC000C, 0x2C8000B, 0x2D3000C, 0x2DF000B, 0x2EA000A, 0x2F5000A,
> +	  0x2FF000B, 0x30A000A, 0x314000B, 0x31F000A, 0x329000A, 0x333000A,
> +	  0x33D0009, 0x3470009, 0x350000A, 0x35A0009, 0x363000A, 0x36D0009,
> +	  0x3760009, 0x37F0009, 0x3880009, 0x3910009, 0x39A0009, 0x3A30009,
> +	  0x3AC0008, 0x3B40009, 0x3BD0008, 0x3C60008, 0x3CE0008, 0x3D60009,
> +	  0x3DF0008, 0x3E70008, 0x3EF0008, 0x3F70008 },
> +
> +	/* 2 --> gamma 1/2.2 */
> +	{      0x99,  0x9B0038,  0xD4002A,  0xFF0023, 0x122001F, 0x141001B,
> +	  0x15D0019, 0x1760017, 0x18E0015, 0x1A30015, 0x1B80013, 0x1CC0012,
> +	  0x1DE0011, 0x1F00010, 0x2010010, 0x2110010, 0x221000F, 0x230000F,
> +	  0x23F000E, 0x24D000E, 0x25B000D, 0x269000C, 0x276000C, 0x283000C,
> +	  0x28F000C, 0x29B000C, 0x2A7000C, 0x2B3000B, 0x2BF000B, 0x2CA000B,
> +	  0x2D5000B, 0x2E0000A, 0x2EB000A, 0x2F5000A, 0x2FF000A, 0x30A000A,
> +	  0x3140009, 0x31E0009, 0x327000A, 0x3310009, 0x33A0009, 0x3440009,
> +	  0x34D0009, 0x3560009, 0x35F0009, 0x3680008, 0x3710008, 0x3790009,
> +	  0x3820008, 0x38A0008, 0x3930008, 0x39B0008, 0x3A30008, 0x3AB0008,
> +	  0x3B30008, 0x3BB0008, 0x3C30008, 0x3CB0007, 0x3D20008, 0x3DA0007,
> +	  0x3E20007, 0x3E90007, 0x3F00008, 0x3F80007 },
>  };
>  
> +static unsigned int sensor_preferred = 1;
> +module_param(sensor_preferred, uint, 0644);
> +MODULE_PARM_DESC(sensor_preferred,
> +		 "Sensor is preferred to output the specified format (1-on 0-off), default 1");
> +
>  static int isc_clk_enable(struct clk_hw *hw)
>  {
>  	struct isc_clk *isc_clk = to_isc_clk(hw);
> @@ -447,27 +570,158 @@ static int isc_buffer_prepare(struct vb2_buffer *vb)
>  	return 0;
>  }
>  
> -static inline void isc_start_dma(struct regmap *regmap,
> -				  struct isc_buffer *frm, u32 dview)
> +static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
> +{
> +	if ((sensor_preferred && isc_fmt->sd_support) ||
> +	    !isc_fmt->isc_support)
> +		return true;
> +	else
> +		return false;

Just do:

	return (sensor_preferred && isc_fmt->sd_support) ||
	       !isc_fmt->isc_support;

> +}
> +
> +static void isc_start_dma(struct isc_device *isc)
>  {
> -	dma_addr_t addr;
> +	struct regmap *regmap = isc->regmap;
> +	struct v4l2_pix_format *pixfmt = &isc->fmt.fmt.pix;
> +	u32 sizeimage = pixfmt->sizeimage;
> +	u32 dctrl_dview;
> +	dma_addr_t addr0;
> +
> +	addr0 = vb2_dma_contig_plane_dma_addr(&isc->cur_frm->vb.vb2_buf, 0);
> +	regmap_write(regmap, ISC_DAD0, addr0);
> +
> +	switch (pixfmt->pixelformat) {
> +	case V4L2_PIX_FMT_YUV420:
> +		regmap_write(regmap, ISC_DAD1, addr0 + (sizeimage*2)/3);
> +		regmap_write(regmap, ISC_DAD2, addr0 + (sizeimage*5)/6);
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		regmap_write(regmap, ISC_DAD1, addr0 + sizeimage/2);
> +		regmap_write(regmap, ISC_DAD2, addr0 + (sizeimage*3)/4);

Add spaces around operators.

> +		break;
> +	default:
> +		break;
> +	}
>  
> -	addr = vb2_dma_contig_plane_dma_addr(&frm->vb.vb2_buf, 0);
> +	if (sensor_is_preferred(isc->current_fmt))
> +		dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +	else
> +		dctrl_dview = isc->current_fmt->reg_dctrl_dview;
>  
> -	regmap_write(regmap, ISC_DCTRL, dview | ISC_DCTRL_IE_IS);
> -	regmap_write(regmap, ISC_DAD0, addr);
> +	regmap_write(regmap, ISC_DCTRL, dctrl_dview | ISC_DCTRL_IE_IS);
>  	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_CAPTURE);
>  }
>  
>  static void isc_set_pipeline(struct isc_device *isc, u32 pipeline)
>  {
> -	u32 val;
> +	struct regmap *regmap = isc->regmap;
> +	struct isc_ctrls *ctrls = &isc->ctrls;
> +	u32 val, bay_cfg;
> +	const u32 *gamma;
>  	unsigned int i;
>  
> +	/* WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB422-->SUB420 */
>  	for (i = 0; i < ISC_PIPE_LINE_NODE_NUM; i++) {
>  		val = pipeline & BIT(i) ? 1 : 0;
>  		regmap_field_write(isc->pipeline[i], val);
>  	}
> +
> +	if (!pipeline)
> +		return;
> +
> +	bay_cfg = isc->raw_fmt->reg_bay_cfg;
> +
> +	regmap_write(regmap, ISC_WB_CFG, bay_cfg);
> +	regmap_write(regmap, ISC_WB_O_RGR, 0x0);
> +	regmap_write(regmap, ISC_WB_O_BGR, 0x0);
> +	regmap_write(regmap, ISC_WB_G_RGR, ctrls->r_gain | (0x1 << 25));
> +	regmap_write(regmap, ISC_WB_G_BGR, ctrls->b_gain | (0x1 << 25));
> +
> +	regmap_write(regmap, ISC_CFA_CFG, bay_cfg | ISC_CFA_CFG_EITPOL);
> +
> +	gamma = &isc_gamma_table[ctrls->gamma_index][0];
> +	regmap_bulk_write(regmap, ISC_GAM_BENTRY, gamma, GAMMA_ENTRIES);
> +	regmap_bulk_write(regmap, ISC_GAM_GENTRY, gamma, GAMMA_ENTRIES);
> +	regmap_bulk_write(regmap, ISC_GAM_RENTRY, gamma, GAMMA_ENTRIES);
> +
> +	/* Convert RGB to YUV */
> +	regmap_write(regmap, ISC_CSC_YR_YG, 0x42 | (0x81 << 16));
> +	regmap_write(regmap, ISC_CSC_YB_OY, 0x19 | (0x10 << 16));
> +	regmap_write(regmap, ISC_CSC_CBR_CBG, 0xFDA | (0xFB6 << 16));
> +	regmap_write(regmap, ISC_CSC_CBB_OCB, 0x70 | (0x80 << 16));
> +	regmap_write(regmap, ISC_CSC_CRR_CRG, 0x70 | (0xFA2 << 16));
> +	regmap_write(regmap, ISC_CSC_CRB_OCR, 0xFEE | (0x80 << 16));
> +
> +	regmap_write(regmap, ISC_CBC_BRIGHT, ctrls->brightness);
> +	regmap_write(regmap, ISC_CBC_CONTRAST, ctrls->contrast);
> +}
> +
> +static int isc_update_profile(struct isc_device *isc)
> +{
> +	struct regmap *regmap = isc->regmap;
> +	u32 sr;
> +	int counter = 100;
> +
> +	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_UPPRO);
> +
> +	regmap_read(regmap, ISC_CTRLSR, &sr);
> +	while ((sr & ISC_CTRL_UPPRO) && counter--) {
> +		usleep_range(1000, 2000);
> +		regmap_read(regmap, ISC_CTRLSR, &sr);
> +	}
> +
> +	if (counter < 0) {
> +		v4l2_warn(&isc->v4l2_dev, "Time out to update profie\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +
> +static void isc_set_histogram(struct isc_device *isc)
> +{
> +	struct regmap *regmap = isc->regmap;
> +	struct isc_ctrls *ctrls = &isc->ctrls;
> +
> +	if (ctrls->awb && (ctrls->hist_stat != HIST_ENABLED)) {
> +		regmap_write(regmap, ISC_HIS_CFG, ISC_HIS_CFG_MODE_R |
> +		      (isc->raw_fmt->reg_bay_cfg << ISC_HIS_CFG_BAYSEL_SHIFT) |
> +		      ISC_HIS_CFG_RAR);
> +		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_EN);
> +		regmap_write(regmap, ISC_INTEN, ISC_INT_HISDONE);
> +		ctrls->hist_id = ISC_HIS_CFG_MODE_R;
> +		isc_update_profile(isc);
> +		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
> +
> +		ctrls->hist_stat = HIST_ENABLED;
> +	} else if (!ctrls->awb && (ctrls->hist_stat != HIST_DISABLED)) {
> +		regmap_write(regmap, ISC_INTDIS, ISC_INT_HISDONE);
> +		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_DIS);
> +
> +		ctrls->hist_stat = HIST_DISABLED;
> +	}
> +}
> +
> +static inline void isc_get_param(const struct isc_format *fmt,
> +				     u32 *rlp_mode, u32 *dcfg_imode)
> +{
> +	switch (fmt->fourcc) {
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +	case V4L2_PIX_FMT_SBGGR12:
> +	case V4L2_PIX_FMT_SGBRG12:
> +	case V4L2_PIX_FMT_SGRBG12:
> +	case V4L2_PIX_FMT_SRGGB12:
> +		*rlp_mode = fmt->reg_rlp_mode;
> +		*dcfg_imode = fmt->reg_dcfg_imode;
> +		break;
> +	default:
> +		*rlp_mode = ISC_RLP_CFG_MODE_DAT8;
> +		*dcfg_imode = ISC_DCFG_IMODE_PACKED8;
> +		break;
> +	}
>  }
>  
>  static int isc_configure(struct isc_device *isc)
> @@ -475,39 +729,40 @@ static int isc_configure(struct isc_device *isc)
>  	struct regmap *regmap = isc->regmap;
>  	const struct isc_format *current_fmt = isc->current_fmt;
>  	struct isc_subdev_entity *subdev = isc->current_subdev;
> -	u32 val, mask;
> -	int counter = 10;
> +	u32 pfe_cfg0, rlp_mode, dcfg_imode, mask, pipeline;
> +
> +	if (sensor_is_preferred(current_fmt)) {
> +		pfe_cfg0 = current_fmt->reg_bps;
> +		pipeline = 0x0;
> +		isc_get_param(current_fmt, &rlp_mode, &dcfg_imode);
> +		isc->ctrls.hist_stat = HIST_INIT;
> +	} else {
> +		pfe_cfg0  = isc->raw_fmt->reg_bps;
> +		pipeline = current_fmt->pipeline;
> +		rlp_mode = current_fmt->reg_rlp_mode;
> +		dcfg_imode = current_fmt->reg_dcfg_imode;
> +	}
>  
> -	val = current_fmt->reg_bps | subdev->pfe_cfg0 |
> -	      ISC_PFE_CFG0_MODE_PROGRESSIVE;
> +	pfe_cfg0  |= subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
>  	mask = ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_LOW |
>  	       ISC_PFE_CFG0_VPOL_LOW | ISC_PFE_CFG0_PPOL_LOW |
>  	       ISC_PFE_CFG0_MODE_MASK;
>  
> -	regmap_update_bits(regmap, ISC_PFE_CFG0, mask, val);
> +	regmap_update_bits(regmap, ISC_PFE_CFG0, mask, pfe_cfg0);
>  
>  	regmap_update_bits(regmap, ISC_RLP_CFG, ISC_RLP_CFG_MODE_MASK,
> -			   current_fmt->reg_rlp_mode);
> +			   rlp_mode);
>  
> -	regmap_update_bits(regmap, ISC_DCFG, ISC_DCFG_IMODE_MASK,
> -			   current_fmt->reg_dcfg_imode);
> +	regmap_update_bits(regmap, ISC_DCFG, ISC_DCFG_IMODE_MASK, dcfg_imode);
>  
> -	/* Disable the pipeline */
> -	isc_set_pipeline(isc, 0x0);
> +	/* Set the pipeline */
> +	isc_set_pipeline(isc, pipeline);
>  
> -	/* Update profile */
> -	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_UPPRO);
> +	if (pipeline)
> +		isc_set_histogram(isc);
>  
> -	regmap_read(regmap, ISC_CTRLSR, &val);
> -	while ((val & ISC_CTRL_UPPRO) && counter--) {
> -		usleep_range(1000, 2000);
> -		regmap_read(regmap, ISC_CTRLSR, &val);
> -	}
> -
> -	if (counter < 0)
> -		return -ETIMEDOUT;
> -
> -	return 0;
> +	/* Update profile */
> +	return isc_update_profile(isc);
>  }
>  
>  static int isc_start_streaming(struct vb2_queue *vq, unsigned int count)
> @@ -517,7 +772,6 @@ static int isc_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	struct isc_buffer *buf;
>  	unsigned long flags;
>  	int ret;
> -	u32 val;
>  
>  	/* Enable stream on the sub device */
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 1);
> @@ -528,12 +782,6 @@ static int isc_start_streaming(struct vb2_queue *vq, unsigned int count)
>  
>  	pm_runtime_get_sync(isc->dev);
>  
> -	/* Disable all the interrupts */
> -	regmap_write(isc->regmap, ISC_INTDIS, (u32)~0UL);
> -
> -	/* Clean the interrupt status register */
> -	regmap_read(regmap, ISC_INTSR, &val);
> -
>  	ret = isc_configure(isc);
>  	if (unlikely(ret))
>  		goto err_configure;
> @@ -551,7 +799,7 @@ static int isc_start_streaming(struct vb2_queue *vq, unsigned int count)
>  					struct isc_buffer, list);
>  	list_del(&isc->cur_frm->list);
>  
> -	isc_start_dma(regmap, isc->cur_frm, isc->current_fmt->reg_dctrl_dview);
> +	isc_start_dma(isc);
>  
>  	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
>  
> @@ -620,8 +868,7 @@ static void isc_buffer_queue(struct vb2_buffer *vb)
>  	if (!isc->cur_frm && list_empty(&isc->dma_queue) &&
>  		vb2_is_streaming(vb->vb2_queue)) {
>  		isc->cur_frm = buf;
> -		isc_start_dma(isc->regmap, isc->cur_frm,
> -			isc->current_fmt->reg_dctrl_dview);
> +		isc_start_dma(isc);
>  	} else
>  		list_add_tail(&buf->list, &isc->dma_queue);
>  	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
> @@ -691,13 +938,14 @@ static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
>  }
>  
>  static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
> -			struct isc_format **current_fmt)
> +			struct isc_format **current_fmt, u32 *code)
>  {
>  	struct isc_format *isc_fmt;
>  	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
>  	struct v4l2_subdev_format format = {
>  		.which = V4L2_SUBDEV_FORMAT_TRY,
>  	};
> +	u32 mbus_code;
>  	int ret;
>  
>  	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> @@ -717,7 +965,12 @@ static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
>  	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
>  		pixfmt->height = ISC_MAX_SUPPORT_HEIGHT;
>  
> -	v4l2_fill_mbus_format(&format.format, pixfmt, isc_fmt->mbus_code);
> +	if (sensor_is_preferred(isc_fmt))
> +		mbus_code = isc_fmt->mbus_code;
> +	else
> +		mbus_code = isc->raw_fmt->mbus_code;
> +
> +	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
>  			       isc->current_subdev->config, &format);
>  	if (ret < 0)
> @@ -726,12 +979,15 @@ static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
>  	v4l2_fill_pix_format(pixfmt, &format.format);
>  
>  	pixfmt->field = V4L2_FIELD_NONE;
> -	pixfmt->bytesperline = pixfmt->width * isc_fmt->bpp;
> +	pixfmt->bytesperline = (pixfmt->width * isc_fmt->bpp) >> 3;
>  	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
>  
>  	if (current_fmt)
>  		*current_fmt = isc_fmt;
>  
> +	if (code)
> +		*code = mbus_code;
> +
>  	return 0;
>  }
>  
> @@ -741,14 +997,14 @@ static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f)
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
>  	struct isc_format *current_fmt;
> +	u32 mbus_code;
>  	int ret;
>  
> -	ret = isc_try_fmt(isc, f, &current_fmt);
> +	ret = isc_try_fmt(isc, f, &current_fmt, &mbus_code);
>  	if (ret)
>  		return ret;
>  
> -	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
> -			      current_fmt->mbus_code);
> +	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, mbus_code);
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, pad,
>  			       set_fmt, NULL, &format);
>  	if (ret < 0)
> @@ -776,7 +1032,7 @@ static int isc_try_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct isc_device *isc = video_drvdata(file);
>  
> -	return isc_try_fmt(isc, f, NULL);
> +	return isc_try_fmt(isc, f, NULL, NULL);
>  }
>  
>  static int isc_enum_input(struct file *file, void *priv,
> @@ -842,7 +1098,10 @@ static int isc_enum_framesizes(struct file *file, void *fh,
>  	if (!isc_fmt)
>  		return -EINVAL;
>  
> -	fse.code = isc_fmt->mbus_code;
> +	if (sensor_is_preferred(isc_fmt))
> +		fse.code = isc_fmt->mbus_code;
> +	else
> +		fse.code = isc->raw_fmt->mbus_code;
>  
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, enum_frame_size,
>  			       NULL, &fse);
> @@ -873,7 +1132,10 @@ static int isc_enum_frameintervals(struct file *file, void *fh,
>  	if (!isc_fmt)
>  		return -EINVAL;
>  
> -	fie.code = isc_fmt->mbus_code;
> +	if (sensor_is_preferred(isc_fmt))
> +		fie.code = isc_fmt->mbus_code;
> +	else
> +		fie.code = isc->raw_fmt->mbus_code;
>  
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, pad,
>  			       enum_frame_interval, NULL, &fie);
> @@ -911,6 +1173,10 @@ static const struct v4l2_ioctl_ops isc_ioctl_ops = {
>  	.vidioc_s_parm			= isc_s_parm,
>  	.vidioc_enum_framesizes		= isc_enum_framesizes,
>  	.vidioc_enum_frameintervals	= isc_enum_frameintervals,
> +
> +	.vidioc_log_status		= v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>  };
>  
>  static int isc_open(struct file *file)
> @@ -984,14 +1250,13 @@ static irqreturn_t isc_interrupt(int irq, void *dev_id)
>  	u32 isc_intsr, isc_intmask, pending;
>  	irqreturn_t ret = IRQ_NONE;
>  
> -	spin_lock(&isc->dma_queue_lock);
> -
>  	regmap_read(regmap, ISC_INTSR, &isc_intsr);
>  	regmap_read(regmap, ISC_INTMASK, &isc_intmask);
>  
>  	pending = isc_intsr & isc_intmask;
>  
>  	if (likely(pending & ISC_INT_DDONE)) {
> +		spin_lock(&isc->dma_queue_lock);
>  		if (isc->cur_frm) {
>  			struct vb2_v4l2_buffer *vbuf = &isc->cur_frm->vb;
>  			struct vb2_buffer *vb = &vbuf->vb2_buf;
> @@ -1007,21 +1272,144 @@ static irqreturn_t isc_interrupt(int irq, void *dev_id)
>  						     struct isc_buffer, list);
>  			list_del(&isc->cur_frm->list);
>  
> -			isc_start_dma(regmap, isc->cur_frm,
> -				      isc->current_fmt->reg_dctrl_dview);
> +			isc_start_dma(isc);
>  		}
>  
>  		if (isc->stop)
>  			complete(&isc->comp);
>  
>  		ret = IRQ_HANDLED;
> +		spin_unlock(&isc->dma_queue_lock);
>  	}
>  
> -	spin_unlock(&isc->dma_queue_lock);
> +	if (pending & ISC_INT_HISDONE) {
> +		schedule_work(&isc->awb_work);
> +		ret = IRQ_HANDLED;
> +	}
>  
>  	return ret;
>  }
>  
> +static void isc_hist_count(struct isc_device *isc)
> +{
> +	struct regmap *regmap = isc->regmap;
> +	struct isc_ctrls *ctrls = &isc->ctrls;
> +	u32 *hist_count = &ctrls->hist_count[ctrls->hist_id];
> +	u32 *hist_entry = &ctrls->hist_entry[0];
> +	u32 i;
> +
> +	regmap_bulk_read(regmap, ISC_HIS_ENTRY, hist_entry, HIST_ENTRIES);
> +
> +	*hist_count = 0;
> +	for (i = 0; i <= HIST_ENTRIES; i++)
> +		*hist_count += i * (*hist_entry++);
> +}
> +
> +static void isc_wb_update(struct isc_ctrls *ctrls)
> +{
> +	u32 *hist_count = &ctrls->hist_count[0];
> +	u64 g_count = (u64)hist_count[ISC_HIS_CFG_MODE_GB] << 9;
> +	u32 hist_r = hist_count[ISC_HIS_CFG_MODE_R];
> +	u32 hist_b = hist_count[ISC_HIS_CFG_MODE_B];
> +
> +	if (hist_r)
> +		ctrls->r_gain = div_u64(g_count, hist_r);
> +
> +	if (hist_b)
> +		ctrls->b_gain = div_u64(g_count, hist_b);
> +}
> +
> +static void isc_awb_work(struct work_struct *w)
> +{
> +	struct isc_device *isc =
> +		container_of(w, struct isc_device, awb_work);
> +	struct regmap *regmap = isc->regmap;
> +	struct isc_ctrls *ctrls = &isc->ctrls;
> +	u32 hist_id = ctrls->hist_id;
> +	u32 baysel;
> +
> +	if (ctrls->hist_stat != HIST_ENABLED)
> +		return;
> +
> +	isc_hist_count(isc);
> +
> +	if (hist_id != ISC_HIS_CFG_MODE_B) {
> +		hist_id++;
> +	} else {
> +		isc_wb_update(ctrls);
> +		hist_id = ISC_HIS_CFG_MODE_R;
> +	}
> +
> +	ctrls->hist_id = hist_id;
> +	baysel = isc->raw_fmt->reg_bay_cfg << ISC_HIS_CFG_BAYSEL_SHIFT;
> +
> +	pm_runtime_get_sync(isc->dev);
> +
> +	regmap_write(regmap, ISC_HIS_CFG, hist_id | baysel | ISC_HIS_CFG_RAR);
> +	isc_update_profile(isc);
> +	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
> +
> +	pm_runtime_put_sync(isc->dev);
> +}
> +
> +static int isc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct isc_device *isc = container_of(ctrl->handler,
> +					     struct isc_device, ctrls.handler);
> +	struct isc_ctrls *ctrls = &isc->ctrls;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		ctrls->brightness = ctrl->val & ISC_CBC_BRIGHT_MASK;
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		ctrls->contrast = (ctrl->val << 8) & ISC_CBC_CONTRAST_MASK;

As I understand it only bits 11-8 contain the contrast in the register?

Wouldn't '(ctrl->val & ISC_CBC_CONTRAST_MASK) << 8' be more readable?

Either that or the mask should be 0xf00, not 0xfff.

> +		break;
> +	case V4L2_CID_GAMMA:
> +		ctrls->gamma_index = ctrl->val;
> +		break;
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		ctrls->awb = ctrl->val;
> +		if (ctrls->hist_stat != HIST_ENABLED) {
> +			ctrls->r_gain = 0x1 << 9;
> +			ctrls->b_gain = 0x1 << 9;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops isc_ctrl_ops = {
> +	.s_ctrl	= isc_s_ctrl,
> +};
> +
> +static int isc_ctrl_init(struct isc_device *isc)
> +{
> +	const struct v4l2_ctrl_ops *ops = &isc_ctrl_ops;
> +	struct isc_ctrls *ctrls = &isc->ctrls;
> +	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
> +	int ret;
> +
> +	ctrls->hist_stat = HIST_INIT;
> +
> +	ret = v4l2_ctrl_handler_init(hdl, 4);
> +	if (ret < 0)
> +		return ret;
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -1024, 1023, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -8, 7, 1, 1);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAMMA, 0, GAMMA_MAX - 1, 1, 2);

Why is the maximum GAMMA_MAX - 1? I would assume that GAMMA_MAX is the maximum.

Looks weird. It's either a bug or it needs a comment.

> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
> +
> +	v4l2_ctrl_handler_setup(hdl);
> +
> +	return 0;
> +}
> +
> +
>  static int isc_async_bound(struct v4l2_async_notifier *notifier,
>  			    struct v4l2_subdev *subdev,
>  			    struct v4l2_async_subdev *asd)
> @@ -1047,10 +1435,11 @@ static void isc_async_unbind(struct v4l2_async_notifier *notifier,
>  {
>  	struct isc_device *isc = container_of(notifier->v4l2_dev,
>  					      struct isc_device, v4l2_dev);
> -
> +	cancel_work_sync(&isc->awb_work);
>  	video_unregister_device(&isc->video_dev);
>  	if (isc->current_subdev->config)
>  		v4l2_subdev_free_pad_config(isc->current_subdev->config);
> +	v4l2_ctrl_handler_free(&isc->ctrls.handler);
>  }
>  
>  static struct isc_format *find_format_by_code(unsigned int code, int *index)
> @@ -1081,7 +1470,9 @@ static int isc_formats_init(struct isc_device *isc)
>  
>  	fmt = &isc_formats[0];
>  	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
> -		fmt->support = false;
> +		fmt->isc_support = false;
> +		fmt->sd_support = false;
> +
>  		fmt++;
>  	}
>  
> @@ -1092,8 +1483,22 @@ static int isc_formats_init(struct isc_device *isc)
>  		if (!fmt)
>  			continue;
>  
> -		fmt->support = true;
> -		num_fmts++;
> +		fmt->sd_support = true;
> +
> +		if (i <= RAW_FMT_INDEX_END) {
> +			for (j = ISC_FMT_INDEX_START;
> +			     j <= ISC_FMT_INDEX_END; j++)

Just merge these two lines, easier to read.

> +				isc_formats[j].isc_support = true;
> +
> +			isc->raw_fmt = fmt;
> +		}
> +	}
> +
> +	for (i = 0, num_fmts = 0; i < ARRAY_SIZE(isc_formats); i++) {
> +		if (fmt->isc_support || fmt->sd_support)
> +			num_fmts++;
> +
> +		fmt++;
>  	}
>  
>  	if (!num_fmts)
> @@ -1110,7 +1515,7 @@ static int isc_formats_init(struct isc_device *isc)
>  
>  	fmt = &isc_formats[0];
>  	for (i = 0, j = 0; i < ARRAY_SIZE(isc_formats); i++) {
> -		if (fmt->support)
> +		if (fmt->isc_support || fmt->sd_support)
>  			isc->user_formats[j++] = fmt;
>  
>  		fmt++;
> @@ -1132,7 +1537,7 @@ static int isc_set_default_fmt(struct isc_device *isc)
>  	};
>  	int ret;
>  
> -	ret = isc_try_fmt(isc, &f, NULL);
> +	ret = isc_try_fmt(isc, &f, NULL, NULL);
>  	if (ret)
>  		return ret;
>  
> @@ -1151,6 +1556,12 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
>  	struct vb2_queue *q = &isc->vb2_vidq;
>  	int ret;
>  
> +	ret = v4l2_device_register_subdev_nodes(&isc->v4l2_dev);
> +	if (ret < 0) {
> +		v4l2_err(&isc->v4l2_dev, "Failed to register subdev nodes\n");
> +		return ret;
> +	}
> +
>  	isc->current_subdev = container_of(notifier,
>  					   struct isc_subdev_entity, notifier);
>  	sd_entity = isc->current_subdev;
> @@ -1198,6 +1609,14 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
>  		return ret;
>  	}
>  
> +	ret = isc_ctrl_init(isc);
> +	if (ret) {
> +		v4l2_err(&isc->v4l2_dev, "Init isc ctrols failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	INIT_WORK(&isc->awb_work, isc_awb_work);
> +
>  	/* Register video device */
>  	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
>  	vdev->release		= video_device_release_empty;
> @@ -1207,7 +1626,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
>  	vdev->vfl_dir		= VFL_DIR_RX;
>  	vdev->queue		= q;
>  	vdev->lock		= &isc->lock;
> -	vdev->ctrl_handler	= isc->current_subdev->sd->ctrl_handler;
> +	vdev->ctrl_handler	= &isc->ctrls.handler;
>  	vdev->device_caps	= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
>  	video_set_drvdata(vdev, isc);
>  
> 

Regards,

	Hans
