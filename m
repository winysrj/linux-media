Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41700 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab1IAVXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 17:23:13 -0400
Received: by fxh19 with SMTP id 19so1055982fxh.19
        for <linux-media@vger.kernel.org>; Thu, 01 Sep 2011 14:23:12 -0700 (PDT)
Message-ID: <4E5FF7BC.3040108@gmail.com>
Date: Thu, 01 Sep 2011 23:23:08 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
Subject: Re: [PATCH v2 4/8] davinci: vpfe: add support for CCDC hardware for
 dm365
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com> <1314630439-1122-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1314630439-1122-5-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

few more comments below..

On 08/29/2011 05:07 PM, Manjunath Hadli wrote:
> add support for ccdc on dm365 SoC. ccdc is responsible for
> capturing video data- both raw bayer through sync seperate
> signals and through BT656/1120 interfaces. This driver implements
> the hardware functionality. Mainly- setting of hardware, validation
> of parameters, and isr configuration.
> 
> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Signed-off-by: Nagabhushana Netagunte<nagabhushana.netagunte@ti.com>
> ---
>   drivers/media/video/davinci/ccdc_types.h      |   43 +
>   drivers/media/video/davinci/dm365_ccdc.c      | 1519 +++++++++++++++++++++++++
>   drivers/media/video/davinci/dm365_ccdc.h      |   88 ++
>   drivers/media/video/davinci/dm365_ccdc_regs.h |  309 +++++
>   include/linux/dm365_ccdc.h                    |  664 +++++++++++
>   5 files changed, 2623 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/davinci/ccdc_types.h
>   create mode 100644 drivers/media/video/davinci/dm365_ccdc.c
>   create mode 100644 drivers/media/video/davinci/dm365_ccdc.h
>   create mode 100644 drivers/media/video/davinci/dm365_ccdc_regs.h
>   create mode 100644 include/linux/dm365_ccdc.h
...
> +#define CCDC_LINEAR_LUT0_ADDR			0x1c7c000
> +#define CCDC_LINEAR_LUT1_ADDR			0x1c7c400
> +
> +/* Masks&  Shifts below */
> +#define START_PX_HOR_MASK			(0x7fff)
> +#define NUM_PX_HOR_MASK				(0x7fff)
> +#define START_VER_ONE_MASK			(0x7fff)
> +#define START_VER_TWO_MASK			(0x7fff)
> +#define NUM_LINES_VER				(0x7fff)
> +
> +/* gain - offset masks */
> +#define GAIN_INTEGER_MASK			(0x7)
> +#define GAIN_INTEGER_SHIFT			(0x9)
> +#define GAIN_DECIMAL_MASK			(0x1ff)
> +#define OFFSET_MASK				(0xfff)
> +#define GAIN_SDRAM_EN_SHIFT			(12)
> +#define GAIN_IPIPE_EN_SHIFT			(13)
> +#define GAIN_H3A_EN_SHIFT			(14)
> +#define OFST_SDRAM_EN_SHIFT			(8)
> +#define OFST_IPIPE_EN_SHIFT			(9)
> +#define OFST_H3A_EN_SHIFT			(10)
> +#define GAIN_OFFSET_EN_MASK			(0x7700)
> +
> +/* Culling */
> +#define CULL_PAT_EVEN_LINE_SHIFT		(8)
> +
> +/* CCDCFG register */
> +#define CCDC_YCINSWP_RAW			(0x00<<  4)
> +#define CCDC_YCINSWP_YCBCR			(0x01<<  4)
> +#define CCDC_CCDCFG_FIDMD_LATCH_VSYNC		(0x00<<  6)
> +#define CCDC_CCDCFG_WENLOG_AND			(0x00<<  8)
> +#define CCDC_CCDCFG_TRGSEL_WEN			(0x00<<  9)
> +#define CCDC_CCDCFG_EXTRG_DISABLE		(0x00<<  10)
> +#define CCDC_LATCH_ON_VSYNC_DISABLE		(0x01<<  15)
> +#define CCDC_LATCH_ON_VSYNC_ENABLE		(0x00<<  15)
> +#define CCDC_DATA_PACK_MASK			(0x03)
> +#define CCDC_DATA_PACK16			(0x0)
> +#define CCDC_DATA_PACK12			(0x1)
> +#define CCDC_DATA_PACK8				(0x2)
> +#define CCDC_PIX_ORDER_SHIFT			(11)
> +#define CCDC_PIX_ORDER_MASK			(0x01)
> +#define CCDC_BW656_ENABLE			(0x01<<  5)
> +
> +/* MODESET registers */
> +#define CCDC_VDHDOUT_INPUT			(0x00<<  0)
> +#define CCDC_INPUT_MASK				(0x03)
> +#define CCDC_INPUT_SHIFT			(12)
> +#define CCDC_RAW_INPUT_MODE			(0x00)
> +#define CCDC_FID_POL_MASK			(0x01)
> +#define CCDC_FID_POL_SHIFT			(4)
> +#define CCDC_HD_POL_MASK			(0x01)
> +#define CCDC_HD_POL_SHIFT			(3)
> +#define CCDC_VD_POL_MASK			(0x01)
> +#define CCDC_VD_POL_SHIFT			(2)
> +#define CCDC_DATAPOL_NORMAL			(0x00)
> +#define CCDC_DATAPOL_MASK			(0x01)
> +#define CCDC_DATAPOL_SHIFT			(6)
> +#define CCDC_EXWEN_DISABLE			(0x00)
> +#define CCDC_EXWEN_MASK				(0x01)
> +#define CCDC_EXWEN_SHIFT			(5)
> +#define CCDC_FRM_FMT_MASK			(0x01)
> +#define CCDC_FRM_FMT_SHIFT			(7)
> +#define CCDC_DATASFT_MASK			(0x07)
> +#define CCDC_DATASFT_SHIFT			(8)
> +#define CCDC_LPF_SHIFT				(14)
> +#define CCDC_LPF_MASK				(0x1)
> +
> +/* GAMMAWD registers */
> +#define CCDC_ALAW_GAMA_WD_MASK			(0xf)
> +#define CCDC_ALAW_GAMA_WD_SHIFT			(1)
> +#define CCDC_ALAW_ENABLE			(0x01)
> +#define CCDC_GAMMAWD_CFA_MASK			(0x01)
> +#define CCDC_GAMMAWD_CFA_SHIFT			(5)
> +
> +/* HSIZE registers */
> +#define CCDC_HSIZE_FLIP_MASK			(0x01)
> +#define CCDC_HSIZE_FLIP_SHIFT			(12)
> +#define CCDC_LINEOFST_MASK			(0xfff)
> +
> +/* MISC registers */
> +#define CCDC_DPCM_EN_SHIFT			(12)
> +#define CCDC_DPCM_EN_MASK			(1)
> +#define CCDC_DPCM_PREDICTOR_SHIFT		(13)
> +#define CCDC_DPCM_PREDICTOR_MASK		(1)
> +
> +/* Black clamp related */
> +#define CCDC_BC_DCOFFSET_MASK			(0x1fff)
> +#define CCDC_BC_MODE_COLOR_MASK			(1)
> +#define CCDC_BC_MODE_COLOR_SHIFT		(4)
> +#define CCDC_HORZ_BC_MODE_MASK			(3)
> +#define CCDC_HORZ_BC_MODE_SHIFT			(1)
> +#define CCDC_HORZ_BC_WIN_COUNT_MASK		(0x1f)
> +#define CCDC_HORZ_BC_WIN_SEL_SHIFT		(5)
> +#define CCDC_HORZ_BC_PIX_LIMIT_SHIFT		(6)
> +#define CCDC_HORZ_BC_WIN_H_SIZE_MASK		(3)
> +#define CCDC_HORZ_BC_WIN_H_SIZE_SHIFT		(8)
> +#define CCDC_HORZ_BC_WIN_V_SIZE_MASK		(3)
> +#define CCDC_HORZ_BC_WIN_V_SIZE_SHIFT		(12)
> +#define CCDC_HORZ_BC_WIN_START_H_MASK		(0x1fff)
> +#define CCDC_HORZ_BC_WIN_START_V_MASK		(0x1fff)
> +#define CCDC_VERT_BC_OB_H_SZ_MASK		(7)
> +#define CCDC_VERT_BC_RST_VAL_SEL_MASK		(3)
> +#define	CCDC_VERT_BC_RST_VAL_SEL_SHIFT		(4)
> +#define CCDC_VERT_BC_LINE_AVE_COEF_SHIFT	(8)
> +#define	CCDC_VERT_BC_OB_START_HORZ_MASK		(0x1fff)
> +#define CCDC_VERT_BC_OB_START_VERT_MASK		(0x1fff)
> +#define CCDC_VERT_BC_OB_VERT_SZ_MASK		(0x1fff)
> +#define CCDC_VERT_BC_RST_VAL_MASK		(0xfff)
> +#define CCDC_BC_VERT_START_SUB_V_MASK		(0x1fff)
> +
> +/* VDFC registers */
> +#define CCDC_VDFC_EN_SHIFT			(4)
> +#define CCDC_VDFC_CORR_MOD_MASK			(3)
> +#define CCDC_VDFC_CORR_MOD_SHIFT		(5)
> +#define CCDC_VDFC_CORR_WHOLE_LN_SHIFT		(7)
> +#define CCDC_VDFC_LEVEL_SHFT_MASK		(7)
> +#define CCDC_VDFC_LEVEL_SHFT_SHIFT		(8)
> +#define CCDC_VDFC_SAT_LEVEL_MASK		(0xfff)
> +#define CCDC_VDFC_POS_MASK			(0x1fff)
> +#define CCDC_DFCMEMCTL_DFCMARST_SHIFT		(2)
> +
> +/* CSC registers */
> +#define CCDC_CSC_COEF_INTEG_MASK		(7)
> +#define CCDC_CSC_COEF_DECIMAL_MASK		(0x1f)
> +#define CCDC_CSC_COEF_INTEG_SHIFT		(5)
> +#define CCDC_CSCM_MSB_SHIFT			(8)
> +#define CCDC_DF_CSC_SPH_MASK			(0x1fff)
> +#define CCDC_DF_CSC_LNH_MASK			(0x1fff)
> +#define CCDC_DF_CSC_SLV_MASK			(0x1fff)
> +#define CCDC_DF_CSC_LNV_MASK			(0x1fff)
> +#define CCDC_DF_NUMLINES			(0x7fff)
> +#define CCDC_DF_NUMPIX				(0x1fff)
> +
> +/* Offsets for LSC/DFC/Gain */
> +#define CCDC_DATA_H_OFFSET_MASK			(0x1fff)
> +#define CCDC_DATA_V_OFFSET_MASK			(0x1fff)
> +
> +/* Linearization */
> +#define CCDC_LIN_CORRSFT_MASK			(7)
> +#define CCDC_LIN_CORRSFT_SHIFT			(4)
> +#define CCDC_LIN_SCALE_FACT_INTEG_SHIFT		(10)
> +#define CCDC_LIN_SCALE_FACT_DECIMAL_MASK	(0x3ff)
> +#define CCDC_LIN_ENTRY_MASK			(0x3ff)
> +
> +#define CCDC_DF_FMTRLEN_MASK			(0x1fff)
> +#define CCDC_DF_FMTHCNT_MASK			(0x1fff)
> +
> +/* Pattern registers */
> +#define CCDC_PG_EN				(1<<  3)
> +#define CCDC_SEL_PG_SRC				(3<<  4)
> +#define CCDC_PG_VD_POL_SHIFT			(0)
> +#define CCDC_PG_HD_POL_SHIFT			(1)
> +
> +/*masks and shifts*/
> +#define CCDC_SYNCEN_VDHDEN_MASK			(1<<  0)
> +#define CCDC_SYNCEN_WEN_MASK			(1<<  1)
> +#define CCDC_SYNCEN_WEN_SHIFT			1
> +
> +#endif
> diff --git a/include/linux/dm365_ccdc.h b/include/linux/dm365_ccdc.h
> new file mode 100644
> index 0000000..4e50529
> --- /dev/null
> +++ b/include/linux/dm365_ccdc.h
> @@ -0,0 +1,664 @@
...
> +#define VPFE_CMD_S_CCDC_RAW_PARAMS _IOW('V', 1, \
> +					struct ccdc_config_params_raw)
> +#define VPFE_CMD_G_CCDC_RAW_PARAMS _IOR('V', 2, \
> +					struct ccdc_config_params_raw)
> +/**
> + * ccdc float type S8Q8/U8Q8
> + */
> +struct ccdc_float_8 {
> +	/* 8 bit integer part */
> +	unsigned char integer;
> +	/* 8 bit decimal part */
> +	unsigned char decimal;
> +};

Isn't it better to use explicit width type, like u8, u16, etc. ?
Then we could just have:

+struct ccdc_float_8 {
+	u8 integer;
+	u8 decimal;
+};


> +
> +/**
> + * brief ccdc float type U16Q16/S16Q16

> + */
> +struct ccdc_float_16 {
> +	/* 16 bit integer part */
> +	unsigned short integer;
> +	/* 16 bit decimal part */
> +	unsigned short decimal;
> +};

and 

+struct ccdc_float_16 {
+	u16 integer;
+	u16 decimal;
+};

> +
> +/*
> + * ccdc image(target) window parameters
> + */
> +struct ccdc_cropwin {
> +	/* horzontal offset of the top left corner in pixels */
> +	unsigned int left;
> +	/* vertical offset of the top left corner in pixels */
> +	unsigned int top;
> +	/* width in pixels of the rectangle */
> +	unsigned int width;
> +	/* height in lines of the rectangle */
> +	unsigned int height;
> +};

How about using struct v4l2_rect instead ?

...
> +/**
> + * CCDC image data size
> + */
> +enum ccdc_data_size {
> +	/* 8 bits */
> +	CCDC_8_BITS,
> +	/* 9 bits */
> +	CCDC_9_BITS,
> +	/* 10 bits */
> +	CCDC_10_BITS,
> +	/* 11 bits */
> +	CCDC_11_BITS,
> +	/* 12 bits */
> +	CCDC_12_BITS,
> +	/* 13 bits */
> +	CCDC_13_BITS,
> +	/* 14 bits */
> +	CCDC_14_BITS,
> +	/* 15 bits */
> +	CCDC_15_BITS,
> +	/* 16 bits */
> +	CCDC_16_BITS
> +};
> +
> +/**
> + * CCDC image data shift to right
> + */
> +enum ccdc_datasft {
> +	/* No Shift */
> +	CCDC_NO_SHIFT,
> +	/* 1 bit Shift */
> +	CCDC_1BIT_SHIFT,
> +	/* 2 bit Shift */
> +	CCDC_2BIT_SHIFT,
> +	/* 3 bit Shift */
> +	CCDC_3BIT_SHIFT,
> +	/* 4 bit Shift */
> +	CCDC_4BIT_SHIFT,
> +	/* 5 bit Shift */
> +	CCDC_5BIT_SHIFT,
> +	/* 6 bit Shift */
> +	CCDC_6BIT_SHIFT
> +};
> +
> +/**
> + * MSB of image data connected to sensor port
> + */
> +enum ccdc_data_msb {
> +	/* MSB b15 */
> +	CCDC_BIT_MSB_15,
> +	/* MSB b14 */
> +	CCDC_BIT_MSB_14,
> +	/* MSB b13 */
> +	CCDC_BIT_MSB_13,
> +	/* MSB b12 */
> +	CCDC_BIT_MSB_12,
> +	/* MSB b11 */
> +	CCDC_BIT_MSB_11,
> +	/* MSB b10 */
> +	CCDC_BIT_MSB_10,
> +	/* MSB b9 */
> +	CCDC_BIT_MSB_9,
> +	/* MSB b8 */
> +	CCDC_BIT_MSB_8,
> +	/* MSB b7 */
> +	CCDC_BIT_MSB_7

Could you live without the comments in these 3 enum declarations ? 
They don't seem to add any information.


--
Regards,
Sylwester

