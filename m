Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:37201 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZCCMX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 07:23:28 -0500
Subject: Re: [PATCH 5/9] omap3isp: Add ISP backend (PRV and RSZ)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	saaguirre@ti.com, tuukka.o.toivonen@nokia.com,
	dongsoo.kim@gmail.com
In-Reply-To: <1236074816-30018-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <49AD0128.5090503@maxwell.research.nokia.com>
	 <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236074816-30018-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236074816-30018-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236074816-30018-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236074816-30018-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 15:23:55 +0300
Message-Id: <1236083035.10927.36.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-03 at 12:06 +0200, Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/isp/isppreview.c | 1896 ++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/isppreview.h |  350 +++++++
>  drivers/media/video/isp/ispresizer.c |  897 ++++++++++++++++
>  drivers/media/video/isp/ispresizer.h |  154 +++
>  4 files changed, 3297 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/isp/isppreview.c
>  create mode 100644 drivers/media/video/isp/isppreview.h
>  create mode 100644 drivers/media/video/isp/ispresizer.c
>  create mode 100644 drivers/media/video/isp/ispresizer.h
> 
> diff --git a/drivers/media/video/isp/isppreview.c b/drivers/media/video/isp/isppreview.c
> new file mode 100644
> index 0000000..242b578
> --- /dev/null
> +++ b/drivers/media/video/isp/isppreview.c
> @@ -0,0 +1,1896 @@
> +/*
> + * isppreview.c
> + *
> + * Driver Library for Preview module in TI's OMAP3 Camera ISP
> + *
> + * Copyright (C) 2009 Texas Instruments, Inc.
> + *
> + * Contributors:
> + *	Senthilvadivu Guruswamy <svadivu@ti.com>
> + *	Pallavi Kulkarni <p-kulkarni@ti.com>
> + *	Sergio Aguirre <saaguirre@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + */
> +
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +
> +#include "isp.h"
> +#include "ispreg.h"
> +#include "isppreview.h"
> +
> +static struct ispprev_nf prev_nf_t;
> +static struct prev_params *params;
> +static int rg_update, gg_update, bg_update, nf_enable, nf_update;
> +
> +/* Structure for saving/restoring preview module registers */
> +static struct isp_reg ispprev_reg_list[] = {
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_HORZ_INFO, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_VERT_INFO, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RSDR_ADDR, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RADR_OFFSET, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_DSDR_ADDR, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_DRKF_OFFSET, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_WSDR_ADDR, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_WADD_OFFSET, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_HMED, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_NF, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_WB_DGAIN, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_WBGAIN, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_WBSEL, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_BLKADJOFF, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT1, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT2, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT3, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT4, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT5, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_OFF1, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_OFF2, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC0, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC1, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC2, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC_OFFSET, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CNT_BRT, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CSUP, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_SETUP_YC, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR0, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR1, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR2, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR3, 0x0000},
> +	{OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR, 0x0000},
> +	{0, ISP_TOK_TERM, 0x0000}
> +};
> +
> +
> +/* Default values in Office Flourescent Light for RGBtoRGB Blending */
> +static struct ispprev_rgbtorgb flr_rgb2rgb = {
> +	{	/* RGB-RGB Matrix */
> +		{0x01E2, 0x0F30, 0x0FEE},
> +		{0x0F9B, 0x01AC, 0x0FB9},
> +		{0x0FE0, 0x0EC0, 0x0260}
> +	},	/* RGB Offset */
> +	{0x0000, 0x0000, 0x0000}
> +};
> +
> +/* Default values in Office Flourescent Light for RGB to YUV Conversion*/
> +static struct ispprev_csc flr_prev_csc[] = {
> +	{
> +		{	/* CSC Coef Matrix */
> +			{66, 129, 25},
> +			{-38, -75, 112},
> +			{112, -94 , -18}
> +		},	/* CSC Offset */
> +		{0x0, 0x0, 0x0}
> +	},
> +	{
> +		{	/* CSC Coef Matrix BW */
> +			{66, 129, 25},
> +			{0, 0, 0},
> +			{0, 0, 0}
> +		},	/* CSC Offset */
> +		{0x0, 0x0, 0x0}
> +	},
> +	{
> +		{	/* CSC Coef Matrix Sepia */
> +			{19, 38, 7},
> +			{0, 0, 0},
> +			{0, 0, 0}
> +		},	/* CSC Offset */
> +		{0x0, 0xE7, 0x14}
> +	}
> +};
> +
> +
> +/* Default values in Office Flourescent Light for CFA Gradient*/
> +#define FLR_CFA_GRADTHRS_HORZ	0x28
> +#define FLR_CFA_GRADTHRS_VERT	0x28
> +
> +/* Default values in Office Flourescent Light for Chroma Suppression*/
> +#define FLR_CSUP_GAIN		0x0D
> +#define FLR_CSUP_THRES		0xEB
> +
> +/* Default values in Office Flourescent Light for Noise Filter*/
> +#define FLR_NF_STRGTH		0x03
> +
> +/* Default values in Office Flourescent Light for White Balance*/
> +#define FLR_WBAL_DGAIN		0x100
> +#define FLR_WBAL_COEF0		0x20
> +#define FLR_WBAL_COEF1		0x29
> +#define FLR_WBAL_COEF2		0x2d
> +#define FLR_WBAL_COEF3		0x20
> +
> +#define FLR_WBAL_COEF0_ES1	0x20
> +#define FLR_WBAL_COEF1_ES1	0x23
> +#define FLR_WBAL_COEF2_ES1	0x39
> +#define FLR_WBAL_COEF3_ES1	0x20
> +
> +/* Default values in Office Flourescent Light for Black Adjustment*/
> +#define FLR_BLKADJ_BLUE		0x0
> +#define FLR_BLKADJ_GREEN	0x0
> +#define FLR_BLKADJ_RED		0x0
> +
> +static int update_color_matrix;
> +
> +/**
> + * struct isp_prev - Structure for storing ISP Preview module information
> + * @prev_inuse: Flag to determine if CCDC has been reserved or not (0 or 1).
> + * @prevout_w: Preview output width.
> + * @prevout_h: Preview output height.
> + * @previn_w: Preview input width.
> + * @previn_h: Preview input height.
> + * @prev_inpfmt: Preview input format.
> + * @prev_outfmt: Preview output format.
> + * @hmed_en: Horizontal median filter enable.
> + * @nf_en: Noise filter enable.
> + * @dcor_en: Defect correction enable.
> + * @cfa_en: Color Filter Array (CFA) interpolation enable.
> + * @csup_en: Chrominance suppression enable.
> + * @yenh_en: Luma enhancement enable.
> + * @fmtavg: Number of horizontal pixels to average in input formatter. The
> + *          input width should be a multiple of this number.
> + * @brightness: Brightness in preview module.
> + * @contrast: Contrast in preview module.
> + * @color: Color effect in preview module.
> + * @cfafmt: Color Filter Array (CFA) Format.
> + * @ispprev_mutex: Mutex for isp preview.
> + *
> + * This structure is used to store the OMAP ISP Preview module Information.
> + */
> +static struct isp_prev {
> +	u8 prev_inuse;
> +	u32 prevout_w;
> +	u32 prevout_h;
> +	u32 previn_w;
> +	u32 previn_h;
> +	enum preview_input prev_inpfmt;
> +	enum preview_output prev_outfmt;
> +	u8 hmed_en;
> +	u8 nf_en;
> +	u8 dcor_en;
> +	u8 cfa_en;
> +	u8 csup_en;
> +	u8 yenh_en;
> +	u8 fmtavg;
> +	u8 brightness;
> +	u8 contrast;
> +	enum v4l2_colorfx color;
> +	enum cfa_fmt cfafmt;
> +	struct mutex ispprev_mutex; /* For checking/modifying prev_inuse */
> +	u32 sph;
> +	u32 slv;
> +} ispprev_obj;
> +
> +/* Saved parameters */
> +static struct prev_params *prev_config_params;
> +
> +/*
> + * Coeficient Tables for the submodules in Preview.
> + * Array is initialised with the values from.the tables text file.
> + */
> +
> +/*
> + * CFA Filter Coefficient Table
> + *
> + */
> +static u32 cfa_coef_table[] = {
> +#include "cfa_coef_table.h"
> +};
> +
> +/*
> + * Gamma Correction Table - Red
> + */
> +static u32 redgamma_table[] = {
> +#include "redgamma_table.h"
> +};
> +
> +/*
> + * Gamma Correction Table - Green
> + */
> +static u32 greengamma_table[] = {
> +#include "greengamma_table.h"
> +};
> +
> +/*
> + * Gamma Correction Table - Blue
> + */
> +static u32 bluegamma_table[] = {
> +#include "bluegamma_table.h"
> +};
> +
> +/*
> + * Noise Filter Threshold table
> + */
> +static u32 noise_filter_table[] = {
> +#include "noise_filter_table.h"
> +};
> +
> +/*
> + * Luminance Enhancement Table
> + */
> +static u32 luma_enhance_table[] = {
> +#include "luma_enhance_table.h"
> +};
> +
> +/**
> + * omap34xx_isp_preview_config - Abstraction layer Preview configuration.
> + * @userspace_add: Pointer from Userspace to structure with flags and data to
> + *                 update.
> + **/
> +int omap34xx_isp_preview_config(void *userspace_add)
> +{
> +	struct ispprev_hmed prev_hmed_t;
> +	struct ispprev_cfa prev_cfa_t;
> +	struct ispprev_csup csup_t;
> +	struct ispprev_wbal prev_wbal_t;
> +	struct ispprev_blkadj prev_blkadj_t;
> +	struct ispprev_rgbtorgb rgb2rgb_t;
> +	struct ispprev_csc prev_csc_t;
> +	struct ispprev_yclimit yclimit_t;
> +	struct ispprev_dcor prev_dcor_t;
> +	struct ispprv_update_config *preview_struct;
> +	struct isptables_update isp_table_update;
> +	int yen_t[ISPPRV_YENH_TBL_SIZE];
> +
> +	if (userspace_add == NULL)
> +		return -EINVAL;
> +
> +	preview_struct = userspace_add;
> +
> +	if (ISP_ABS_PREV_LUMAENH & preview_struct->flag) {
> +		if (ISP_ABS_PREV_LUMAENH & preview_struct->update) {
> +			if (copy_from_user(yen_t, preview_struct->yen,
> +								sizeof(yen_t)))
> +				goto err_copy_from_user;
> +			isppreview_config_luma_enhancement(yen_t);
> +		}
> +		params->features |= PREV_LUMA_ENHANCE;
> +	} else if (ISP_ABS_PREV_LUMAENH & preview_struct->update)
> +			params->features &= ~PREV_LUMA_ENHANCE;
> +
> +	if (ISP_ABS_PREV_INVALAW & preview_struct->flag) {
> +		isppreview_enable_invalaw(1);
> +		params->features |= PREV_INVERSE_ALAW;
> +	} else {
> +		isppreview_enable_invalaw(0);
> +		params->features &= ~PREV_INVERSE_ALAW;
> +	}
> +
> +	if (ISP_ABS_PREV_HRZ_MED & preview_struct->flag) {
> +		if (ISP_ABS_PREV_HRZ_MED & preview_struct->update) {
> +			if (copy_from_user(&prev_hmed_t,
> +						(struct ispprev_hmed *)
> +						preview_struct->prev_hmed,
> +						sizeof(struct ispprev_hmed)))
> +				goto err_copy_from_user;
> +			isppreview_config_hmed(prev_hmed_t);
> +		}
> +		isppreview_enable_hmed(1);
> +		params->features |= PREV_HORZ_MEDIAN_FILTER;
> +	} else if (ISP_ABS_PREV_HRZ_MED & preview_struct->update) {
> +		isppreview_enable_hmed(0);
> +		params->features &= ~PREV_HORZ_MEDIAN_FILTER;
> +	}
> +
> +	if (ISP_ABS_PREV_CFA & preview_struct->flag) {
> +		if (ISP_ABS_PREV_CFA & preview_struct->update) {
> +			if (copy_from_user(&prev_cfa_t,
> +						(struct ispprev_cfa *)
> +						preview_struct->prev_cfa,
> +						sizeof(struct ispprev_cfa)))
> +				goto err_copy_from_user;
> +
> +			isppreview_config_cfa(prev_cfa_t);
> +		}
> +		isppreview_enable_cfa(1);
> +		params->features |= PREV_CFA;
> +	} else if (ISP_ABS_PREV_CFA & preview_struct->update) {
> +		isppreview_enable_cfa(0);
> +		params->features &= ~PREV_CFA;
> +	}
> +
> +	if (ISP_ABS_PREV_CHROMA_SUPP & preview_struct->flag) {
> +		if (ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) {
> +			if (copy_from_user(&csup_t,
> +						(struct ispprev_csup *)
> +						preview_struct->csup,
> +						sizeof(struct ispprev_csup)))
> +				goto err_copy_from_user;
> +			isppreview_config_chroma_suppression(csup_t);
> +		}
> +		isppreview_enable_chroma_suppression(1);
> +		params->features |= PREV_CHROMA_SUPPRESS;
> +	} else if (ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) {
> +		isppreview_enable_chroma_suppression(0);
> +		params->features &= ~PREV_CHROMA_SUPPRESS;
> +	}
> +
> +	if (ISP_ABS_PREV_WB & preview_struct->update) {
> +		if (copy_from_user(&prev_wbal_t, (struct ispprev_wbal *)
> +						preview_struct->prev_wbal,
> +						sizeof(struct ispprev_wbal)))
> +			goto err_copy_from_user;
> +		isppreview_config_whitebalance(prev_wbal_t);
> +	}
> +
> +	if (ISP_ABS_PREV_BLKADJ & preview_struct->update) {
> +		if (copy_from_user(&prev_blkadj_t, (struct ispprev_blkadjl *)
> +					preview_struct->prev_blkadj,
> +					sizeof(struct ispprev_blkadj)))
> +			goto err_copy_from_user;
> +		isppreview_config_blkadj(prev_blkadj_t);
> +	}
> +
> +	if (ISP_ABS_PREV_RGB2RGB & preview_struct->update) {
> +		if (copy_from_user(&rgb2rgb_t, (struct ispprev_rgbtorgb *)
> +					preview_struct->rgb2rgb,
> +					sizeof(struct ispprev_rgbtorgb)))
> +			goto err_copy_from_user;
> +		isppreview_config_rgb_blending(rgb2rgb_t);
> +	}
> +
> +	if (ISP_ABS_PREV_COLOR_CONV & preview_struct->update) {
> +		if (copy_from_user(&prev_csc_t, (struct ispprev_csc *)
> +						preview_struct->prev_csc,
> +						sizeof(struct ispprev_csc)))
> +			goto err_copy_from_user;
> +		isppreview_config_rgb_to_ycbcr(prev_csc_t);
> +	}
> +
> +	if (ISP_ABS_PREV_YC_LIMIT & preview_struct->update) {
> +		if (copy_from_user(&yclimit_t, (struct ispprev_yclimit *)
> +					preview_struct->yclimit,
> +					sizeof(struct ispprev_yclimit)))
> +			goto err_copy_from_user;
> +		isppreview_config_yc_range(yclimit_t);
> +	}
> +
> +	if (ISP_ABS_PREV_DEFECT_COR & preview_struct->flag) {
> +		if (ISP_ABS_PREV_DEFECT_COR & preview_struct->update) {
> +			if (copy_from_user(&prev_dcor_t,
> +						(struct ispprev_dcor *)
> +						preview_struct->prev_dcor,
> +						sizeof(struct ispprev_dcor)))
> +				goto err_copy_from_user;
> +			isppreview_config_dcor(prev_dcor_t);
> +		}
> +		isppreview_enable_dcor(1);
> +		params->features |= PREV_DEFECT_COR;
> +	} else if (ISP_ABS_PREV_DEFECT_COR & preview_struct->update) {
> +		isppreview_enable_dcor(0);
> +		params->features &= ~PREV_DEFECT_COR;
> +	}
> +
> +	if (ISP_ABS_PREV_GAMMABYPASS & preview_struct->flag) {
> +		isppreview_enable_gammabypass(1);
> +		params->features |= PREV_GAMMA_BYPASS;
> +	} else {
> +		isppreview_enable_gammabypass(0);
> +		params->features &= ~PREV_GAMMA_BYPASS;
> +	}
> +
> +	isp_table_update.update = preview_struct->update;
> +	isp_table_update.flag = preview_struct->flag;
> +	isp_table_update.prev_nf = preview_struct->prev_nf;
> +	isp_table_update.red_gamma = preview_struct->red_gamma;
> +	isp_table_update.green_gamma = preview_struct->green_gamma;
> +	isp_table_update.blue_gamma = preview_struct->blue_gamma;
> +
> +	if (omap34xx_isp_tables_update(&isp_table_update))
> +		goto err_copy_from_user;
> +
> +	return 0;
> +
> +err_copy_from_user:
> +	printk(KERN_ERR "Preview Config: Copy From User Error");

:) "\n" right ?
And, probably it's not clear from what module this printk come from.
Please, add module name or something here and in others such printks.

<snip>

-- 
Best regards, Klimov Alexey

