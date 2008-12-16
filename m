Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGGbMT3012061
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 11:37:22 -0500
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBGGbFO8000814
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 11:37:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 16 Dec 2008 17:37:06 +0100
References: <A24693684029E5489D1D202277BE894415E6E199@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894415E6E199@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161737.07416.hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 05/14] OMAP: CAM: Add ISP Back end
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

More review comments...

On Thursday 11 December 2008 21:37:58 Aguirre Rodriguez, Sergio Alberto wrote:
> >From bb9b326cfb06b79f6e919e9d43ddbf041e493178 Mon Sep 17 00:00:00 2001
> From: Sergio Aguirre <saaguirre@ti.com>
> Date: Thu, 11 Dec 2008 13:35:50 -0600
> Subject: [PATCH] OMAP: CAM: Add ISP Back end
> 
> This adds the OMAP ISP Back end modules to the kernel. Includes:
> * ISP Preview Driver
> * ISP Resizer Driver
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/isp/isppreview.c | 1971 ++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/isppreview.h |  356 ++++++
>  drivers/media/video/isp/ispresizer.c |  895 +++++++++++++++
>  drivers/media/video/isp/ispresizer.h |  153 +++
>  4 files changed, 3375 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/isp/isppreview.c
>  create mode 100644 drivers/media/video/isp/isppreview.h
>  create mode 100644 drivers/media/video/isp/ispresizer.c
>  create mode 100644 drivers/media/video/isp/ispresizer.h
> 
> diff --git a/drivers/media/video/isp/isppreview.c b/drivers/media/video/isp/isppreview.c
> new file mode 100644
> index 0000000..ae69784
> --- /dev/null
> +++ b/drivers/media/video/isp/isppreview.c
> @@ -0,0 +1,1971 @@
> +/*
> + * drivers/media/video/isp/isppreview.c
> + *
> + * Driver Library for Preview module in TI's OMAP3 Camera ISP
> + *
> + * Copyright (C) 2008 Texas Instruments, Inc.
> + *
> + * Contributors:
> + *     Senthilvadivu Guruswamy <svadivu@ti.com>
> + *     Pallavi Kulkarni <p-kulkarni@ti.com>
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
> +#include <linux/io.h>
> +#include <linux/errno.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +
> +#include "isp.h"
> +#include "ispreg.h"
> +#include "isppreview.h"
> +
> +static struct ispprev_nf prev_nf_t;
> +static struct ispprev_csc prev_csc_t;
> +static struct prev_params *params;
> +static int RG_update, GG_update, BG_update, NF_enable, NF_update;
> +static int CSC_update;
> +
> +/* Structure for saving/restoring preview module registers */
> +static struct isp_reg ispprev_reg_list[] = {
> +       {ISPPRV_HORZ_INFO, 0x0000},
> +       {ISPPRV_VERT_INFO, 0x0000},
> +       {ISPPRV_RSDR_ADDR, 0x0000},
> +       {ISPPRV_RADR_OFFSET, 0x0000},
> +       {ISPPRV_DSDR_ADDR, 0x0000},
> +       {ISPPRV_DRKF_OFFSET, 0x0000},
> +       {ISPPRV_WSDR_ADDR, 0x0000},
> +       {ISPPRV_WADD_OFFSET, 0x0000},
> +       {ISPPRV_AVE, 0x0000},
> +       {ISPPRV_HMED, 0x0000},
> +       {ISPPRV_NF, 0x0000},
> +       {ISPPRV_WB_DGAIN, 0x0000},
> +       {ISPPRV_WBGAIN, 0x0000},
> +       {ISPPRV_WBSEL, 0x0000},
> +       {ISPPRV_CFA, 0x0000},
> +       {ISPPRV_BLKADJOFF, 0x0000},
> +       {ISPPRV_RGB_MAT1, 0x0000},
> +       {ISPPRV_RGB_MAT2, 0x0000},
> +       {ISPPRV_RGB_MAT3, 0x0000},
> +       {ISPPRV_RGB_MAT4, 0x0000},
> +       {ISPPRV_RGB_MAT5, 0x0000},
> +       {ISPPRV_RGB_OFF1, 0x0000},
> +       {ISPPRV_RGB_OFF2, 0x0000},
> +       {ISPPRV_CSC0, 0x0000},
> +       {ISPPRV_CSC1, 0x0000},
> +       {ISPPRV_CSC2, 0x0000},
> +       {ISPPRV_CSC_OFFSET, 0x0000},
> +       {ISPPRV_CNT_BRT, 0x0000},
> +       {ISPPRV_CSUP, 0x0000},
> +       {ISPPRV_SETUP_YC, 0x0000},
> +       {ISPPRV_CDC_THR0, 0x0000},
> +       {ISPPRV_CDC_THR1, 0x0000},
> +       {ISPPRV_CDC_THR2, 0x0000},
> +       {ISPPRV_CDC_THR3, 0x0000},
> +       {ISPPRV_PCR, 0x0000},
> +       {ISP_TOK_TERM, 0x0000}
> +};
> +
> +
> +/* Default values in Office Flourescent Light for RGBtoRGB Blending */
> +static struct ispprev_rgbtorgb flr_rgb2rgb = {
> +       {       /* RGB-RGB Matrix */
> +               {0x01E2, 0x0F30, 0x0FEE},
> +               {0x0F9B, 0x01AC, 0x0FB9},
> +               {0x0FE0, 0x0EC0, 0x0260}
> +       },      /* RGB Offset */
> +       {0x0000, 0x0000, 0x0000}
> +};
> +
> +/* Default values in Office Flourescent Light for RGB to YUV Conversion*/
> +static struct ispprev_csc flr_prev_csc[] = {
> +       {
> +               {       /* CSC Coef Matrix */
> +                       {66, 129, 25},
> +                       {-38, -75, 112},
> +                       {112, -94 , -18}
> +               },      /* CSC Offset */
> +               {0x0, 0x0, 0x0}
> +       },
> +       {
> +               {       /* CSC Coef Matrix Sepia */
> +                       {19, 38, 7},
> +                       {0, 0, 0},
> +                       {0, 0, 0}
> +               },      /* CSC Offset */
> +               {0x0, 0xE7, 0x14}
> +       },
> +       {
> +               {       /* CSC Coef Matrix BW */
> +                       {66, 129, 25},
> +                       {0, 0, 0},
> +                       {0, 0, 0}
> +               },      /* CSC Offset */
> +               {0x0, 0x0, 0x0}
> +       }
> +};
> +
> +
> +/* Default values in Office Flourescent Light for CFA Gradient*/
> +#define FLR_CFA_GRADTHRS_HORZ  0x28
> +#define FLR_CFA_GRADTHRS_VERT  0x28
> +
> +/* Default values in Office Flourescent Light for Chroma Suppression*/
> +#define FLR_CSUP_GAIN          0x0D
> +#define FLR_CSUP_THRES         0xEB
> +
> +/* Default values in Office Flourescent Light for Noise Filter*/
> +#define FLR_NF_STRGTH          0x03
> +
> +/* Default values in Office Flourescent Light for White Balance*/
> +#define FLR_WBAL_DGAIN         0x100
> +#define FLR_WBAL_COEF0         0x68
> +#define FLR_WBAL_COEF1         0x5c
> +#define FLR_WBAL_COEF2         0x5c
> +#define FLR_WBAL_COEF3         0x94
> +
> +#define FLR_WBAL_COEF0_ES1     0x23
> +#define FLR_WBAL_COEF1_ES1     0x20
> +#define FLR_WBAL_COEF2_ES1     0x20
> +#define FLR_WBAL_COEF3_ES1     0x39
> +
> +/* Default values in Office Flourescent Light for Black Adjustment*/
> +#define FLR_BLKADJ_BLUE                0x0
> +#define FLR_BLKADJ_GREEN       0x0
> +#define FLR_BLKADJ_RED         0x0
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
> +       u8 prev_inuse;
> +       u32 prevout_w;
> +       u32 prevout_h;
> +       u32 previn_w;
> +       u32 previn_h;
> +       enum preview_input prev_inpfmt;
> +       enum preview_output prev_outfmt;
> +       u8 hmed_en;
> +       u8 nf_en;
> +       u8 dcor_en;
> +       u8 cfa_en;
> +       u8 csup_en;
> +       u8 yenh_en;
> +       u8 fmtavg;
> +       u8 brightness;
> +       u8 contrast;
> +       int stream_on;
> +       enum preview_color_effect color;
> +       enum cfa_fmt cfafmt;
> +       struct mutex ispprev_mutex; /* For checking/modifying prev_inuse */
> +       spinlock_t ispprev_lock;
> +       u32 sph;
> +       u32 slv;
> +} ispprev_obj;
> +
> +/* Saved parameters */
> +struct prev_params *prev_config_params;
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
> +       struct ispprev_hmed prev_hmed_t;
> +       struct ispprev_cfa prev_cfa_t;
> +       struct ispprev_csup csup_t;
> +       struct ispprev_wbal prev_wbal_t;
> +       struct ispprev_blkadj prev_blkadj_t;
> +       struct ispprev_rgbtorgb rgb2rgb_t;
> +       struct ispprev_yclimit yclimit_t;
> +       struct ispprev_dcor prev_dcor_t;
> +       struct ispprv_update_config *preview_struct;
> +       struct isptables_update isp_table_update;
> +       int yen_t[128];
> +
> +       if (userspace_add == NULL)
> +               return -EINVAL;
> +
> +       preview_struct = (struct ispprv_update_config *)userspace_add;
> +
> +       if ((ISP_ABS_PREV_LUMAENH & preview_struct->flag) ==
> +                                                       ISP_ABS_PREV_LUMAENH) {
> +               if ((ISP_ABS_PREV_LUMAENH & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_LUMAENH) {
> +                       if (copy_from_user(yen_t, preview_struct->yen,
> +                                                               sizeof(yen_t)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_luma_enhancement(yen_t);
> +               }
> +               params->features |= PREV_LUMA_ENHANCE;
> +       } else if ((ISP_ABS_PREV_LUMAENH & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_LUMAENH)
> +                       params->features &= ~PREV_LUMA_ENHANCE;
> +
> +       if ((ISP_ABS_PREV_INVALAW & preview_struct->flag) ==
> +                                                       ISP_ABS_PREV_INVALAW) {
> +               isppreview_enable_invalaw(1);
> +               params->features |= PREV_INVERSE_ALAW;
> +       } else {
> +               isppreview_enable_invalaw(0);
> +               params->features &= ~PREV_INVERSE_ALAW;
> +       }
> +
> +       if ((ISP_ABS_PREV_HRZ_MED & preview_struct->flag) ==
> +                                                       ISP_ABS_PREV_HRZ_MED) {

Same comment as before, just test for the bit, no need to add '== ...'.

> +               if ((ISP_ABS_PREV_HRZ_MED & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_HRZ_MED) {
> +                       if (copy_from_user(&prev_hmed_t,
> +                                               (struct ispprev_hmed *)
> +                                               (preview_struct->prev_hmed),
> +                                               sizeof(struct ispprev_hmed)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_hmed(prev_hmed_t);
> +               }
> +               isppreview_enable_hmed(1);
> +               params->features |= PREV_HORZ_MEDIAN_FILTER;
> +       } else if ((ISP_ABS_PREV_HRZ_MED & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_HRZ_MED) {
> +               isppreview_enable_hmed(0);
> +               params->features &= ~PREV_HORZ_MEDIAN_FILTER;
> +       }
> +
> +       if ((ISP_ABS_PREV_CFA & preview_struct->flag) == ISP_ABS_PREV_CFA) {
> +               if ((ISP_ABS_PREV_CFA & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_CFA) {
> +                       if (copy_from_user(&prev_cfa_t,
> +                                               (struct ispprev_cfa *)
> +                                               (preview_struct->prev_cfa),
> +                                               sizeof(struct ispprev_cfa)))
> +                               goto err_copy_from_user;
> +
> +                       isppreview_config_cfa(prev_cfa_t);
> +               }
> +               isppreview_enable_cfa(1);
> +               params->features |= PREV_CFA;
> +       } else if ((ISP_ABS_PREV_CFA & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_CFA) {
> +               isppreview_enable_cfa(0);
> +               params->features &= ~PREV_CFA;
> +       }
> +
> +       if ((ISP_ABS_PREV_CHROMA_SUPP & preview_struct->flag) ==
> +                                               ISP_ABS_PREV_CHROMA_SUPP) {
> +               if ((ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) ==
> +                                               ISP_ABS_PREV_CHROMA_SUPP) {
> +                       if (copy_from_user(&csup_t,
> +                                               (struct ispprev_csup *)
> +                                               (preview_struct->csup),
> +                                               sizeof(struct ispprev_csup)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_chroma_suppression(csup_t);
> +               }
> +               isppreview_enable_chroma_suppression(1);
> +               params->features |= PREV_CHROMA_SUPPRESS;
> +       } else if ((ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) ==
> +                                               ISP_ABS_PREV_CHROMA_SUPP) {
> +               isppreview_enable_chroma_suppression(0);
> +               params->features &= ~PREV_CHROMA_SUPPRESS;
> +       }
> +
> +       if ((ISP_ABS_PREV_WB & preview_struct->update) == ISP_ABS_PREV_WB) {
> +               if (copy_from_user(&prev_wbal_t, (struct ispprev_wbal *)
> +                                               (preview_struct->prev_wbal),
> +                                               sizeof(struct ispprev_wbal)))
> +                       goto err_copy_from_user;
> +               isppreview_config_whitebalance(prev_wbal_t);
> +       }
> +
> +       if ((ISP_ABS_PREV_BLKADJ & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_BLKADJ) {
> +               if (copy_from_user(&prev_blkadj_t, (struct ispprev_blkadjl *)
> +                                       (preview_struct->prev_blkadj),
> +                                       sizeof(struct ispprev_blkadj)))
> +                       goto err_copy_from_user;
> +               isppreview_config_blkadj(prev_blkadj_t);
> +       }
> +
> +       if ((ISP_ABS_PREV_RGB2RGB & preview_struct->update) ==
> +                                                       ISP_ABS_PREV_RGB2RGB) {
> +               if (copy_from_user(&rgb2rgb_t, (struct ispprev_rgbtorgb *)
> +                                       (preview_struct->rgb2rgb),
> +                                       sizeof(struct ispprev_rgbtorgb)))
> +                       goto err_copy_from_user;
> +               isppreview_config_rgb_blending(rgb2rgb_t);
> +       }
> +
> +       if ((ISP_ABS_PREV_COLOR_CONV & preview_struct->update) ==
> +                                               ISP_ABS_PREV_COLOR_CONV) {
> +               if (copy_from_user(&prev_csc_t, (struct ispprev_csc *)
> +                                               (preview_struct->prev_csc),
> +                                               sizeof(struct ispprev_csc)))
> +                       goto err_copy_from_user;
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               if (ispprev_obj.stream_on == 0) {
> +                       isppreview_config_rgb_to_ycbcr(prev_csc_t);
> +                       CSC_update = 0;
> +               } else
> +                       CSC_update = 1;
> +
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +       } else
> +               CSC_update = 0;
> +
> +       if ((ISP_ABS_PREV_YC_LIMIT & preview_struct->update) ==
> +               ISP_ABS_PREV_YC_LIMIT) {
> +               if (copy_from_user(&yclimit_t, (struct ispprev_yclimit *)
> +                                       (preview_struct->yclimit),
> +                                       sizeof(struct ispprev_yclimit)))
> +                       goto err_copy_from_user;
> +               isppreview_config_yc_range(yclimit_t);
> +       }
> +
> +       if ((ISP_ABS_PREV_DEFECT_COR & preview_struct->flag) ==
> +                                               ISP_ABS_PREV_DEFECT_COR) {
> +               if ((ISP_ABS_PREV_DEFECT_COR & preview_struct->update) ==
> +                                               ISP_ABS_PREV_DEFECT_COR) {
> +                       if (copy_from_user(&prev_dcor_t,
> +                                               (struct ispprev_dcor *)
> +                                               (preview_struct->prev_dcor),
> +                                               sizeof(struct ispprev_dcor)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_dcor(prev_dcor_t);
> +               }
> +               isppreview_enable_dcor(1);
> +               params->features |= PREV_DEFECT_COR;
> +       } else if ((ISP_ABS_PREV_DEFECT_COR & preview_struct->update) ==
> +                                               ISP_ABS_PREV_DEFECT_COR) {
> +               isppreview_enable_dcor(0);
> +               params->features &= ~PREV_DEFECT_COR;
> +       }
> +
> +       if ((ISP_ABS_PREV_GAMMABYPASS & preview_struct->flag) ==
> +                                               ISP_ABS_PREV_GAMMABYPASS) {
> +               isppreview_enable_gammabypass(1);
> +               params->features |= PREV_GAMMA_BYPASS;
> +       } else {
> +               isppreview_enable_gammabypass(0);
> +               params->features &= ~PREV_GAMMA_BYPASS;
> +       }
> +
> +       isp_table_update.update = preview_struct->update;
> +       isp_table_update.flag = preview_struct->flag;
> +       isp_table_update.prev_nf = preview_struct->prev_nf;
> +       isp_table_update.red_gamma = preview_struct->red_gamma;
> +       isp_table_update.green_gamma = preview_struct->green_gamma;
> +       isp_table_update.blue_gamma = preview_struct->blue_gamma;
> +
> +       if (omap34xx_isp_tables_update(&isp_table_update))
> +               goto err_copy_from_user;
> +
> +       return 0;
> +
> +err_copy_from_user:
> +       printk(KERN_ERR "Preview Config: Copy From User Error");
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL(omap34xx_isp_preview_config);
> +
> +/**
> + * omap34xx_isp_tables_update - Abstraction layer Tables update.
> + * @isptables_struct: Pointer from Userspace to structure with flags and table
> + *                 data to update.
> + **/
> +int omap34xx_isp_tables_update(struct isptables_update *isptables_struct)
> +{
> +       int ctr;
> +
> +       if ((ISP_ABS_TBL_NF & isptables_struct->flag) == ISP_ABS_TBL_NF) {
> +               NF_enable = 1;
> +               params->features |= (PREV_NOISE_FILTER);
> +               if ((ISP_ABS_TBL_NF & isptables_struct->update) ==
> +                                                       ISP_ABS_TBL_NF) {
> +                       if (copy_from_user(&prev_nf_t, (struct ispprev_nf *)
> +                                               (isptables_struct->prev_nf),
> +                                               sizeof(struct ispprev_nf)))
> +                               goto err_copy_from_user;
> +
> +                       spin_lock(&ispprev_obj.ispprev_lock);
> +                       if (ispprev_obj.stream_on == 0) {
> +                               NF_update = 0;
> +                               isppreview_config_noisefilter(prev_nf_t);
> +                               isppreview_enable_noisefilter(NF_enable);
> +                       } else
> +                               NF_update = 1;
> +
> +                       spin_unlock(&ispprev_obj.ispprev_lock);
> +               } else
> +                       NF_update = 0;
> +       } else {
> +               NF_enable = 0;
> +               params->features &= ~(PREV_NOISE_FILTER);
> +               if ((ISP_ABS_TBL_NF & isptables_struct->update) ==
> +                                                               ISP_ABS_TBL_NF)
> +                       NF_update = 1;
> +               else
> +                       NF_update = 0;
> +       }
> +
> +       if ((ISP_ABS_TBL_REDGAMMA & isptables_struct->update) ==
> +                                                       ISP_ABS_TBL_REDGAMMA) {
> +               if (copy_from_user(redgamma_table, isptables_struct->red_gamma,
> +                                               sizeof(redgamma_table))) {
> +                       goto err_copy_from_user;
> +               }
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               if (ispprev_obj.stream_on == 0) {
> +                       RG_update = 0;
> +                       omap_writel(ISPPRV_TBL_ADDR_RED_G_START,
> +                                                       ISPPRV_SET_TBL_ADDR);
> +                       for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                               omap_writel(redgamma_table[ctr],
> +                                                       ISPPRV_SET_TBL_DATA);
> +               } else
> +                       RG_update = 1;
> +
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +       } else
> +               RG_update = 0;
> +
> +       if ((ISP_ABS_TBL_GREENGAMMA & isptables_struct->update) ==
> +                                               ISP_ABS_TBL_GREENGAMMA) {
> +               if (copy_from_user(greengamma_table,
> +                                               isptables_struct->green_gamma,
> +                                               sizeof(greengamma_table)))
> +                       goto err_copy_from_user;
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               if (ispprev_obj.stream_on == 0) {
> +                       GG_update = 0;
> +                       omap_writel(ISPPRV_TBL_ADDR_GREEN_G_START,
> +                                                       ISPPRV_SET_TBL_ADDR);
> +                       for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                               omap_writel(greengamma_table[ctr],
> +                                               ISPPRV_SET_TBL_DATA);
> +               } else
> +                       GG_update = 1;
> +
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +       } else
> +               GG_update = 0;
> +
> +       if ((ISP_ABS_TBL_BLUEGAMMA & isptables_struct->update) ==
> +                                       ISP_ABS_TBL_BLUEGAMMA) {
> +               if (copy_from_user(bluegamma_table, (isptables_struct->
> +                                               blue_gamma),
> +                                               sizeof(bluegamma_table))) {

Weird usage of brackets. Why not write:

		if (copy_from_user(bluegamma_table,
			isptables_struct->blue_gamma, sizeof(bluegamma_table))) {

It's very ugly to break up a line before or after the '->'.

Also note that the 80-char limit is a recommendation. If the code becomes
more unreadable by breaking it up, then it's better to use a bit more than
80 chars. In this case using two instead of three lines is IMHO more readable
then using three lines, even though the two-line version uses 82 chars.

> +                       goto err_copy_from_user;
> +               }
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               if (ispprev_obj.stream_on == 0) {
> +                       BG_update = 0;
> +                       omap_writel(ISPPRV_TBL_ADDR_BLUE_G_START,
> +                                                       ISPPRV_SET_TBL_ADDR);
> +                       for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                               omap_writel(bluegamma_table[ctr],
> +                                               ISPPRV_SET_TBL_DATA);
> +               } else
> +                       BG_update = 1;
> +
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +       } else
> +               BG_update = 0;
> +
> +       return 0;
> +
> +err_copy_from_user:
> +       printk(KERN_ERR "Preview Tables:Copy From User Error");
> +       return -EINVAL;
> +}
> +
> +/**
> + * isppreview_config_shadow_registers - Program shadow registers for preview.
> + *
> + * Allows user to program shadow registers associated with preview module.
> + **/
> +void isppreview_config_shadow_registers()
> +{
> +       u8 current_brightness_contrast;
> +       int ctr, prv_disabled;
> +
> +       isppreview_query_brightness(&current_brightness_contrast);
> +       if (current_brightness_contrast != ((ispprev_obj.brightness) *
> +                                                       ISPPRV_BRIGHT_UNITS)) {

Why the extra brackets? Why not just this:

      if (current_brightness_contrast !=
		ispprev_obj.brightness * ISPPRV_BRIGHT_UNITS) {

This is done in more places.

> +               DPRINTK_ISPPREV(" Changing Brightness level to %d\n",
> +                                               ispprev_obj.brightness);
> +               isppreview_config_brightness((ispprev_obj.brightness) *
> +                                                       ISPPRV_BRIGHT_UNITS);
> +       }
> +
> +       isppreview_query_contrast(&current_brightness_contrast);
> +       if (current_brightness_contrast != ((ispprev_obj.contrast) *
> +                                               ISPPRV_CONTRAST_UNITS)) {
> +               DPRINTK_ISPPREV(" Changing Contrast level to %d\n",
> +                                                       ispprev_obj.contrast);
> +               isppreview_config_contrast((ispprev_obj.contrast) *
> +                                                       ISPPRV_CONTRAST_UNITS);
> +       }
> +       if (update_color_matrix) {
> +               isppreview_config_rgb_to_ycbcr(flr_prev_csc[ispprev_obj.
> +                                                               color]);

Just make this one line. Breaking off after the '.' also makes it much
harder to read.

> +               update_color_matrix = 0;
> +       }
> +       if (GG_update || RG_update || BG_update || NF_update || CSC_update) {
> +               isppreview_enable(0);
> +               prv_disabled = 1;
> +       }
> +
> +       if (CSC_update) {
> +               isppreview_config_rgb_to_ycbcr(prev_csc_t);
> +               CSC_update = 0;
> +       }
> +
> +       if (GG_update) {
> +               omap_writel(ISPPRV_TBL_ADDR_GREEN_G_START, ISPPRV_SET_TBL_ADDR);
> +
> +               for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++) {
> +                       omap_writel(greengamma_table[ctr],
> +                                                       ISPPRV_SET_TBL_DATA);

Also one line.

> +               }
> +               GG_update = 0;
> +       }
> +
> +       if (RG_update) {
> +               omap_writel(ISPPRV_TBL_ADDR_RED_G_START, ISPPRV_SET_TBL_ADDR);
> +
> +               for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                       omap_writel(redgamma_table[ctr], ISPPRV_SET_TBL_DATA);
> +               RG_update = 0;
> +       }
> +
> +       if (BG_update) {
> +               omap_writel(ISPPRV_TBL_ADDR_BLUE_G_START, ISPPRV_SET_TBL_ADDR);
> +
> +               for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                       omap_writel(bluegamma_table[ctr], ISPPRV_SET_TBL_DATA);
> +               BG_update = 0;
> +       }
> +
> +       if (NF_update && NF_enable) {
> +               omap_writel(0xC00, ISPPRV_SET_TBL_ADDR);
> +               omap_writel(prev_nf_t.spread, ISPPRV_NF);
> +               for (ctr = 0; ctr < 64; ctr++)
> +                       omap_writel(prev_nf_t.table[ctr],
> +                                                       ISPPRV_SET_TBL_DATA);

Ditto.

> +               isppreview_enable_noisefilter(1);
> +               NF_update = 0;
> +       }
> +
> +       if (~NF_update && NF_enable)
> +               isppreview_enable_noisefilter(1);
> +
> +       if (NF_update && ~NF_enable)
> +               isppreview_enable_noisefilter(0);
> +
> +       if (prv_disabled) {
> +               isppreview_enable(1);
> +               prv_disabled = 0;
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_config_shadow_registers);
> +
> +/**
> + * isppreview_request - Reserves the preview module.
> + *
> + * Returns 0 if successful, or -EBUSY if the module was already reserved.
> + **/
> +int isppreview_request()
> +{
> +       mutex_lock(&ispprev_obj.ispprev_mutex);
> +       if (!(ispprev_obj.prev_inuse)) {
> +               ispprev_obj.prev_inuse = 1;
> +               mutex_unlock(&ispprev_obj.ispprev_mutex);
> +               omap_writel((omap_readl(ISP_CTRL)) | ISPCTRL_PREV_RAM_EN |
> +                                                       ISPCTRL_PREV_CLK_EN |
> +                                                       ISPCTRL_SBL_WR1_RAM_EN,
> +                                                       ISP_CTRL);
> +               return 0;
> +       } else {

No need for the 'else' if the 'if' always exits.

> +               mutex_unlock(&ispprev_obj.ispprev_mutex);
> +               printk(KERN_ERR "ISP_ERR : Preview Module Busy\n");
> +               return -EBUSY;
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_request);
> +
> +/**
> + * isppreview_free - Frees the preview module.
> + *
> + * Returns 0 if successful, or -EINVAL if the module was already freed.
> + **/
> +int isppreview_free()
> +{
> +       mutex_lock(&ispprev_obj.ispprev_mutex);
> +       if (ispprev_obj.prev_inuse) {
> +               ispprev_obj.prev_inuse = 0;
> +               mutex_unlock(&ispprev_obj.ispprev_mutex);
> +               omap_writel(omap_readl(ISP_CTRL) & ~(ISPCTRL_PREV_CLK_EN |
> +                                       ISPCTRL_PREV_RAM_EN |
> +                                       ISPCTRL_SBL_WR1_RAM_EN), ISP_CTRL);
> +               return 0;
> +       } else {
> +               mutex_unlock(&ispprev_obj.ispprev_mutex);
> +               DPRINTK_ISPPREV("ISP_ERR : Preview Module already freed\n");
> +               return -EINVAL;
> +       }
> +
> +}
> +EXPORT_SYMBOL(isppreview_free);
> +
> +/** isppreview_config_datapath - Specifies input and output modules for Preview
> + * @input: Indicates the module that gives the image to preview.
> + * @output: Indicates the module to which the preview outputs to.
> + *
> + * Configures the default configuration for the CCDC to work with.
> + *
> + * The valid values for the input are PRV_RAW_CCDC (0), PRV_RAW_MEM (1),
> + * PRV_RGBBAYERCFA (2), PRV_COMPCFA (3), PRV_CCDC_DRKF (4), PRV_OTHERS (5).
> + *
> + * The valid values for the output are PREVIEW_RSZ (0), PREVIEW_MEM (1).
> + *
> + * Returns 0 if successful, or -EINVAL if wrong input or output values are
> + * specified.
> + **/
> +int isppreview_config_datapath(enum preview_input input,
> +                                               enum preview_output output)
> +{
> +       u32 pcr = 0;
> +       u8 enable = 0;
> +       struct prev_params *params = prev_config_params;
> +       struct ispprev_yclimit yclimit;
> +
> +       pcr = omap_readl(ISPPRV_PCR);
> +
> +       switch (input) {
> +       case PRV_RAW_CCDC:
> +               pcr &= ~(ISPPRV_PCR_SOURCE);
> +               pcr &= ~(ISPPRV_PCR_ONESHOT);
> +               ispprev_obj.prev_inpfmt = PRV_RAW_CCDC;
> +               break;
> +       case PRV_RAW_MEM:
> +               pcr |= ISPPRV_PCR_SOURCE;
> +               pcr |= ISPPRV_PCR_ONESHOT;
> +               ispprev_obj.prev_inpfmt = PRV_RAW_MEM;
> +               break;
> +       case PRV_CCDC_DRKF:
> +               pcr |= ISPPRV_PCR_DRKFCAP;
> +               pcr |= ISPPRV_PCR_ONESHOT;
> +               ispprev_obj.prev_inpfmt = PRV_CCDC_DRKF;
> +               break;
> +       case PRV_COMPCFA:
> +               ispprev_obj.prev_inpfmt = PRV_COMPCFA;
> +               break;
> +       case PRV_OTHERS:
> +               ispprev_obj.prev_inpfmt = PRV_OTHERS;
> +               break;
> +       case PRV_RGBBAYERCFA:
> +               ispprev_obj.prev_inpfmt = PRV_RGBBAYERCFA;
> +               break;
> +       default:
> +               printk(KERN_ERR "ISP_ERR : Wrong Input\n");
> +               return -EINVAL;
> +       };
> +
> +       if (output == PREVIEW_RSZ) {
> +               pcr |= ISPPRV_PCR_RSZPORT;
> +               pcr &= ~ISPPRV_PCR_SDRPORT;
> +               ispprev_obj.prev_outfmt = PREVIEW_RSZ;
> +       } else if (output == PREVIEW_MEM) {
> +               pcr &= ~ISPPRV_PCR_RSZPORT;
> +               pcr |= ISPPRV_PCR_SDRPORT;
> +               ispprev_obj.prev_outfmt = PREVIEW_MEM;
> +       } else {
> +               printk(KERN_ERR "ISP_ERR : Wrong Output\n");
> +               return -EINVAL;
> +       }
> +       omap_writel(pcr, ISPPRV_PCR);
> +
> +       isppreview_config_ycpos(params->pix_fmt);
> +
> +       if (params->cfa.cfa_table != NULL)
> +               isppreview_config_cfa(params->cfa);
> +       if (params->csup.hypf_en == 1)
> +               isppreview_config_chroma_suppression(params->csup);
> +       if (params->ytable != NULL)
> +               isppreview_config_luma_enhancement(params->ytable);
> +
> +       if (params->gtable.redtable != NULL)
> +               isppreview_config_gammacorrn(params->gtable);
> +
> +       enable = ((params->features & PREV_CFA) == PREV_CFA) ? 1 : 0;
> +       isppreview_enable_cfa(enable);
> +
> +       enable = ((params->features & PREV_CHROMA_SUPPRESS) ==
> +                                               PREV_CHROMA_SUPPRESS) ? 1 : 0;
> +       isppreview_enable_chroma_suppression(enable);
> +
> +       enable = ((params->features & PREV_LUMA_ENHANCE) ==
> +                                               PREV_LUMA_ENHANCE) ? 1 : 0;
> +       isppreview_enable_luma_enhancement(enable);
> +
> +       enable = ((params->features & PREV_NOISE_FILTER) ==
> +                                               PREV_NOISE_FILTER) ? 1 : 0;
> +       if (enable)
> +               isppreview_config_noisefilter(params->nf);
> +       isppreview_enable_noisefilter(enable);
> +
> +       enable = ((params->features & PREV_DEFECT_COR) ==
> +                                               PREV_DEFECT_COR) ? 1 : 0;
> +       if (enable)
> +               isppreview_config_dcor(params->dcor);
> +       isppreview_enable_dcor(enable);
> +
> +       enable = ((params->features & PREV_GAMMA_BYPASS) ==
> +                                               PREV_GAMMA_BYPASS) ? 1 : 0;
> +       isppreview_enable_gammabypass(enable);
> +
> +       isppreview_config_whitebalance(params->wbal);
> +       isppreview_config_blkadj(params->blk_adj);
> +       isppreview_config_rgb_blending(params->rgb2rgb);
> +       isppreview_config_rgb_to_ycbcr(params->rgb2ycbcr);
> +
> +       isppreview_config_contrast(params->contrast * ISPPRV_CONTRAST_UNITS);
> +       isppreview_config_brightness(params->brightness * ISPPRV_BRIGHT_UNITS);
> +
> +       yclimit.minC = ISPPRV_YC_MIN;
> +       yclimit.maxC = ISPPRV_YC_MAX;
> +       yclimit.minY = ISPPRV_YC_MIN;
> +       yclimit.maxY = ISPPRV_YC_MAX;
> +       isppreview_config_yc_range(yclimit);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_config_datapath);
> +
> +/**
> + * isppreview_set_skip - Set the number of rows/columns that should be skipped.
> + *  h - Start Pixel Horizontal.
> + *  v - Start Line Vertical.
> + **/
> +void isppreview_set_skip(u32 h, u32 v)
> +{
> +       ispprev_obj.sph = h;
> +       ispprev_obj.slv = v;
> +}
> +EXPORT_SYMBOL(isppreview_set_skip);
> +
> +/**
> + * isppreview_config_ycpos - Configure byte layout of YUV image.
> + * @mode: Indicates the required byte layout.
> + **/
> +void isppreview_config_ycpos(enum preview_ycpos_mode mode)
> +{
> +       u32 pcr = omap_readl(ISPPRV_PCR);
> +       pcr &= ~ISPPRV_PCR_YCPOS_CrYCbY;
> +       pcr |= (mode << ISPPRV_PCR_YCPOS_SHIFT);
> +       omap_writel(pcr, ISPPRV_PCR);
> +}
> +EXPORT_SYMBOL(isppreview_config_ycpos);
> +
> +/**
> + * isppreview_config_averager - Enable / disable / configure averager
> + * @average: Average value to be configured.
> + **/
> +void isppreview_config_averager(u8 average)
> +{
> +       int reg = 0;
> +
> +       reg = AVE_ODD_PIXEL_DIST | AVE_EVEN_PIXEL_DIST | average;
> +       omap_writel(reg, ISPPRV_AVE);
> +}
> +EXPORT_SYMBOL(isppreview_config_averager);
> +
> +/**
> + * isppreview_enable_invalaw - Enable/Disable Inverse A-Law module in Preview.
> + * @enable: 1 - Reverse the A-Law done in CCDC.
> + **/
> +void isppreview_enable_invalaw(u8 enable)
> +{
> +       u32 pcr_val = 0;
> +       pcr_val = omap_readl(ISPPRV_PCR);
> +
> +       if (enable) {
> +               omap_writel(pcr_val | ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW,
> +                                                               ISPPRV_PCR);
> +       } else {
> +               omap_writel(pcr_val & ~(ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW),
> +                                                               ISPPRV_PCR);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_invalaw);
> +
> +/**
> + * isppreview_enable_drkframe - Enable/Disable of the darkframe subtract.
> + * @enable: 1 - Acquires memory bandwidth since the pixels in each frame is
> + *          subtracted with the pixels in the current frame.
> + *
> + * The proccess is applied for each captured frame.
> + **/
> +void isppreview_enable_drkframe(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel(omap_readl(ISPPRV_PCR) | ISPPRV_PCR_DRKFEN,
> +                                                               ISPPRV_PCR);
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_DRKFEN,
> +                                                               ISPPRV_PCR);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_drkframe);
> +
> +/**
> + * isppreview_enable_shadcomp - Enables/Disables the shading compensation.
> + * @enable: 1 - Enables the shading compensation.
> + *
> + * If dark frame subtract won't be used, then enable this shading
> + * compensation.
> + **/
> +void isppreview_enable_shadcomp(u8 enable)
> +{
> +
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_SCOMP_EN,
> +                                                               ISPPRV_PCR);
> +               isppreview_enable_drkframe(1);
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_SCOMP_EN,
> +                                                               ISPPRV_PCR);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_shadcomp);
> +
> +/**
> + * isppreview_config_drkf_shadcomp - Configures shift value in shading comp.
> + * @scomp_shtval: 3bit value of shift used in shading compensation.
> + **/
> +void isppreview_config_drkf_shadcomp(u8 scomp_shtval)
> +{
> +       u32 pcr_val = omap_readl(ISPPRV_PCR);
> +
> +       pcr_val &= ISPPRV_PCR_SCOMP_SFT_MASK;
> +       omap_writel(pcr_val | (scomp_shtval << ISPPRV_PCR_SCOMP_SFT_SHIFT),
> +                                                               ISPPRV_PCR);
> +}
> +EXPORT_SYMBOL(isppreview_config_drkf_shadcomp);
> +
> +/**
> + * isppreview_enable_hmed - Enables/Disables of the Horizontal Median Filter.
> + * @enable: 1 - Enables Horizontal Median Filter.
> + **/
> +void isppreview_enable_hmed(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_HMEDEN,
> +                       ISPPRV_PCR);
> +               ispprev_obj.hmed_en = 1;
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_HMEDEN,
> +                       ISPPRV_PCR);
> +               ispprev_obj.hmed_en = 0;
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_hmed);
> +
> +/**
> + * isppreview_config_hmed - Configures the Horizontal Median Filter.
> + * @prev_hmed: Structure containing the odd and even distance between the
> + *             pixels in the image along with the filter threshold.
> + **/
> +void isppreview_config_hmed(struct ispprev_hmed prev_hmed)
> +{
> +
> +       u32 odddist = 0;
> +       u32 evendist = 0;
> +
> +       if (prev_hmed.odddist == 1)
> +               odddist = ~ISPPRV_HMED_ODDDIST;
> +       else
> +               odddist = ISPPRV_HMED_ODDDIST;
> +
> +       if (prev_hmed.evendist == 1)
> +               evendist = ~ISPPRV_HMED_EVENDIST;
> +       else
> +               evendist = ISPPRV_HMED_EVENDIST;
> +
> +       omap_writel(odddist | evendist | (prev_hmed.thres <<
> +                                               ISPPRV_HMED_THRESHOLD_SHIFT),
> +                                               ISPPRV_HMED);
> +
> +}
> +EXPORT_SYMBOL(isppreview_config_hmed);
> +
> +/**
> + * isppreview_config_noisefilter - Configures the Noise Filter.
> + * @prev_nf: Structure containing the noisefilter table, strength to be used
> + *           for the noise filter and the defect correction enable flag.
> + **/
> +void isppreview_config_noisefilter(struct ispprev_nf prev_nf)
> +{
> +       int i = 0;
> +
> +       omap_writel(prev_nf.spread, ISPPRV_NF);
> +       omap_writel(ISPPRV_NF_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 64; i++)
> +               omap_writel(prev_nf.table[i], ISPPRV_SET_TBL_DATA);
> +}
> +EXPORT_SYMBOL(isppreview_config_noisefilter);
> +
> +/**
> + * isppreview_config_dcor - Configures the defect correction
> + * @prev_nf: Structure containing the defect correction structure
> + **/
> +void isppreview_config_dcor(struct ispprev_dcor prev_dcor)
> +{
> +       if (prev_dcor.couplet_mode_en) {
> +               omap_writel(prev_dcor.detect_correct[0], ISPPRV_CDC_THR0);
> +               omap_writel(prev_dcor.detect_correct[1], ISPPRV_CDC_THR1);
> +               omap_writel(prev_dcor.detect_correct[2], ISPPRV_CDC_THR2);
> +               omap_writel(prev_dcor.detect_correct[3], ISPPRV_CDC_THR3);
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_DCCOUP,
> +                                                               ISPPRV_PCR);
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_DCCOUP,
> +                                                               ISPPRV_PCR);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_config_dcor);
> +
> +/**
> + * isppreview_config_cfa - Configures the CFA Interpolation parameters.
> + * @prev_cfa: Structure containing the CFA interpolation table, CFA format
> + *            in the image, vertical and horizontal gradient threshold.
> + **/
> +void isppreview_config_cfa(struct ispprev_cfa prev_cfa)
> +{
> +       int i = 0;
> +
> +       ispprev_obj.cfafmt = prev_cfa.cfafmt;
> +
> +       omap_writel((omap_readl(ISPPRV_PCR)) | (prev_cfa.cfafmt <<
> +                                       ISPPRV_PCR_CFAFMT_SHIFT), ISPPRV_PCR);
> +
> +       omap_writel((prev_cfa.cfa_gradthrs_vert <<
> +                                               ISPPRV_CFA_GRADTH_VER_SHIFT) |
> +                                               (prev_cfa.cfa_gradthrs_horz <<
> +                                               ISPPRV_CFA_GRADTH_HOR_SHIFT),
> +                                               ISPPRV_CFA);
> +
> +       omap_writel(ISPPRV_CFA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
> +
> +       for (i = 0; i < 576; i++)
> +               omap_writel(prev_cfa.cfa_table[i], ISPPRV_SET_TBL_DATA);
> +}
> +EXPORT_SYMBOL(isppreview_config_cfa);
> +
> +/**
> + * isppreview_config_gammacorrn - Configures the Gamma Correction table values
> + * @gtable: Structure containing the table for red, blue, green gamma table.
> + **/
> +void isppreview_config_gammacorrn(struct ispprev_gtable gtable)
> +{
> +       int i = 0;
> +
> +       omap_writel(ISPPRV_REDGAMMA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 1024; i++)
> +               omap_writel(gtable.redtable[i], ISPPRV_SET_TBL_DATA);
> +
> +       omap_writel(ISPPRV_GREENGAMMA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 1024; i++)
> +               omap_writel(gtable.greentable[i], ISPPRV_SET_TBL_DATA);
> +
> +       omap_writel(ISPPRV_BLUEGAMMA_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 1024; i++)
> +               omap_writel(gtable.bluetable[i], ISPPRV_SET_TBL_DATA);
> +}
> +EXPORT_SYMBOL(isppreview_config_gammacorrn);
> +
> +/**
> + * isppreview_config_luma_enhancement - Sets the Luminance Enhancement table.
> + * @ytable: Structure containing the table for Luminance Enhancement table.
> + **/
> +void isppreview_config_luma_enhancement(u32 *ytable)
> +{
> +       int i = 0;
> +
> +       omap_writel(ISPPRV_YENH_TABLE_ADDR, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 128; i++)
> +               omap_writel(ytable[i], ISPPRV_SET_TBL_DATA);
> +}
> +EXPORT_SYMBOL(isppreview_config_luma_enhancement);
> +
> +/**
> + * isppreview_config_chroma_suppression - Configures the Chroma Suppression.
> + * @csup: Structure containing the threshold value for suppression
> + *        and the hypass filter enable flag.
> + **/
> +void isppreview_config_chroma_suppression(struct ispprev_csup csup)
> +{
> +       omap_writel(csup.gain | (csup.thres << ISPPRV_CSUP_THRES_SHIFT) |
> +                               (csup.hypf_en << ISPPRV_CSUP_HPYF_SHIFT),
> +                               ISPPRV_CSUP);
> +}
> +EXPORT_SYMBOL(isppreview_config_chroma_suppression);
> +
> +/**
> + * isppreview_enable_noisefilter - Enables/Disables the Noise Filter.
> + * @enable: 1 - Enables the Noise Filter.
> + **/
> +void isppreview_enable_noisefilter(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_NFEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.nf_en = 1;
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_NFEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.nf_en = 0;
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_noisefilter);
> +
> +/**
> + * isppreview_enable_dcor - Enables/Disables the defect correction.
> + * @enable: 1 - Enables the defect correction.
> + **/
> +void isppreview_enable_dcor(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_DCOREN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.dcor_en = 1;
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_DCOREN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.dcor_en = 0;
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_dcor);
> +
> +/**
> + * isppreview_enable_cfa - Enable/Disable the CFA Interpolation.
> + * @enable: 1 - Enables the CFA.
> + **/
> +void isppreview_enable_cfa(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_CFAEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.cfa_en = 1;
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_CFAEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.cfa_en = 0;
> +       }
> +
> +}
> +EXPORT_SYMBOL(isppreview_enable_cfa);
> +
> +/**
> + * isppreview_enable_gammabypass - Enables/Disables the GammaByPass
> + * @enable: 1 - Bypasses Gamma - 10bit input is cropped to 8MSB.
> + *          0 - Goes through Gamma Correction. input and output is 10bit.
> + **/
> +void isppreview_enable_gammabypass(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_GAMMA_BYPASS,
> +                                                               ISPPRV_PCR);
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) &
> +                                               ~ISPPRV_PCR_GAMMA_BYPASS,
> +                                               ISPPRV_PCR);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_gammabypass);
> +
> +/**
> + * isppreview_enable_luma_enhancement - Enables/Disables Luminance Enhancement
> + * @enable: 1 - Enable the Luminance Enhancement.
> + **/
> +void isppreview_enable_luma_enhancement(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_YNENHEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.yenh_en = 1;
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_YNENHEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.yenh_en = 0;
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_luma_enhancement);
> +
> +/**
> + * isppreview_enable_chroma_suppression - Enables/Disables Chrominance Suppr.
> + * @enable: 1 - Enable the Chrominance Suppression.
> + **/
> +void isppreview_enable_chroma_suppression(u8 enable)
> +{
> +       if (enable) {
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_SUPEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.csup_en = 1;
> +       } else {
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_SUPEN,
> +                                                               ISPPRV_PCR);
> +               ispprev_obj.csup_en = 0;
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable_chroma_suppression);
> +
> +/**
> + * isppreview_config_whitebalance - Configures the White Balance parameters.
> + * @prev_wbal: Structure containing the digital gain and white balance
> + *             coefficient.
> + *
> + * Coefficient matrix always with default values.
> + **/
> +void isppreview_config_whitebalance(struct ispprev_wbal prev_wbal)
> +{
> +
> +       omap_writel(prev_wbal.dgain, ISPPRV_WB_DGAIN);
> +       omap_writel(prev_wbal.coef0 |
> +                               prev_wbal.coef1 << ISPPRV_WBGAIN_COEF1_SHIFT |
> +                               prev_wbal.coef2 << ISPPRV_WBGAIN_COEF2_SHIFT |
> +                               prev_wbal.coef3 << ISPPRV_WBGAIN_COEF3_SHIFT,
> +                               ISPPRV_WBGAIN);
> +
> +       omap_writel((ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N0_0_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N0_1_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N0_2_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N0_3_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N1_0_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N1_1_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N1_2_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N1_3_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N2_0_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N2_1_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N2_2_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N2_3_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N3_0_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N3_1_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N3_2_SHIFT) |
> +                       (ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N3_3_SHIFT),
> +                       ISPPRV_WBSEL);
> +
> +}
> +EXPORT_SYMBOL(isppreview_config_whitebalance);
> +
> +/**
> + * isppreview_config_whitebalance2 - Configures the White Balance parameters.
> + * @prev_wbal: Structure containing the digital gain and white balance
> + *             coefficient.
> + *
> + * Coefficient matrix can be changed.
> + **/
> +void isppreview_config_whitebalance2(struct prev_white_balance prev_wbal)
> +{
> +       omap_writel(prev_wbal.wb_dgain, ISPPRV_WB_DGAIN);
> +       omap_writel(prev_wbal.wb_gain[0] |
> +                       (prev_wbal.wb_gain[1] << ISPPRV_WBGAIN_COEF1_SHIFT) |
> +                       (prev_wbal.wb_gain[2] << ISPPRV_WBGAIN_COEF2_SHIFT) |
> +                       (prev_wbal.wb_gain[3] << ISPPRV_WBGAIN_COEF3_SHIFT),
> +                       ISPPRV_WBGAIN);
> +
> +       omap_writel(prev_wbal.wb_coefmatrix[0][0] << ISPPRV_WBSEL_N0_0_SHIFT |
> +               prev_wbal.wb_coefmatrix[0][1] << ISPPRV_WBSEL_N0_1_SHIFT |
> +               prev_wbal.wb_coefmatrix[0][2] << ISPPRV_WBSEL_N0_2_SHIFT |
> +               prev_wbal.wb_coefmatrix[0][3] << ISPPRV_WBSEL_N0_3_SHIFT |
> +               prev_wbal.wb_coefmatrix[1][0] << ISPPRV_WBSEL_N1_0_SHIFT |
> +               prev_wbal.wb_coefmatrix[1][1] << ISPPRV_WBSEL_N1_1_SHIFT |
> +               prev_wbal.wb_coefmatrix[1][2] << ISPPRV_WBSEL_N1_2_SHIFT |
> +               prev_wbal.wb_coefmatrix[1][3] << ISPPRV_WBSEL_N1_3_SHIFT |
> +               prev_wbal.wb_coefmatrix[2][0] << ISPPRV_WBSEL_N2_0_SHIFT |
> +               prev_wbal.wb_coefmatrix[2][1] << ISPPRV_WBSEL_N2_1_SHIFT |
> +               prev_wbal.wb_coefmatrix[2][2] << ISPPRV_WBSEL_N2_2_SHIFT |
> +               prev_wbal.wb_coefmatrix[2][3] << ISPPRV_WBSEL_N2_3_SHIFT |
> +               prev_wbal.wb_coefmatrix[3][0] << ISPPRV_WBSEL_N3_0_SHIFT |
> +               prev_wbal.wb_coefmatrix[3][1] << ISPPRV_WBSEL_N3_1_SHIFT |
> +               prev_wbal.wb_coefmatrix[3][2] << ISPPRV_WBSEL_N3_2_SHIFT |
> +               prev_wbal.wb_coefmatrix[3][3] << ISPPRV_WBSEL_N3_3_SHIFT,
> +               ISPPRV_WBSEL);
> +}
> +EXPORT_SYMBOL(isppreview_config_whitebalance2);
> +
> +/**
> + * isppreview_config_blkadj - Configures the Black Adjustment parameters.
> + * @prev_blkadj: Structure containing the black adjustment towards red, green,
> + *               blue.
> + **/
> +void isppreview_config_blkadj(struct ispprev_blkadj prev_blkadj)
> +{
> +       omap_writel(prev_blkadj.blue | (prev_blkadj.green <<
> +                                       ISPPRV_BLKADJOFF_G_SHIFT) |
> +                                       (prev_blkadj.red <<
> +                                       ISPPRV_BLKADJOFF_R_SHIFT),
> +                                       ISPPRV_BLKADJOFF);
> +}
> +EXPORT_SYMBOL(isppreview_config_blkadj);
> +
> +/**
> + * isppreview_config_rgb_blending - Configures the RGB-RGB Blending matrix.
> + * @rgb2rgb: Structure containing the rgb to rgb blending matrix and the rgb
> + *           offset.
> + **/
> +void isppreview_config_rgb_blending(struct ispprev_rgbtorgb rgb2rgb)
> +{
> +       omap_writel((rgb2rgb.matrix[0][0] << ISPPRV_RGB_MAT1_MTX_RR_SHIFT) |
> +                                               (rgb2rgb.matrix[0][1] <<
> +                                               ISPPRV_RGB_MAT1_MTX_GR_SHIFT),
> +                                               ISPPRV_RGB_MAT1);
> +       omap_writel((rgb2rgb.matrix[0][2] << ISPPRV_RGB_MAT2_MTX_BR_SHIFT) |
> +                                               (rgb2rgb.matrix[1][0] <<
> +                                               ISPPRV_RGB_MAT2_MTX_RG_SHIFT),
> +                                               ISPPRV_RGB_MAT2);
> +
> +       omap_writel((rgb2rgb.matrix[1][1] << ISPPRV_RGB_MAT3_MTX_GG_SHIFT) |
> +                                               (rgb2rgb.matrix[1][2] <<
> +                                               ISPPRV_RGB_MAT3_MTX_BG_SHIFT),
> +                                               ISPPRV_RGB_MAT3);
> +
> +       omap_writel((rgb2rgb.matrix[2][0] << ISPPRV_RGB_MAT4_MTX_RB_SHIFT) |
> +                                               (rgb2rgb.matrix[2][1] <<
> +                                               ISPPRV_RGB_MAT4_MTX_GB_SHIFT),
> +                                               ISPPRV_RGB_MAT4);
> +
> +       omap_writel((rgb2rgb.matrix[2][2] << ISPPRV_RGB_MAT5_MTX_BB_SHIFT),
> +                                               ISPPRV_RGB_MAT5);
> +
> +       omap_writel((rgb2rgb.offset[0] << ISPPRV_RGB_OFF1_MTX_OFFG_SHIFT) |
> +                                       (rgb2rgb.offset[1] <<
> +                                       ISPPRV_RGB_OFF1_MTX_OFFR_SHIFT),
> +                                       ISPPRV_RGB_OFF1);
> +
> +       omap_writel(rgb2rgb.offset[2] << ISPPRV_RGB_OFF2_MTX_OFFB_SHIFT,
> +                                               ISPPRV_RGB_OFF2);
> +
> +}
> +EXPORT_SYMBOL(isppreview_config_rgb_blending);
> +
> +/**
> + * Configures the RGB-YCbYCr conversion matrix
> + * @prev_csc: Structure containing the RGB to YCbYCr matrix and the
> + *            YCbCr offset.
> + **/
> +void isppreview_config_rgb_to_ycbcr(struct ispprev_csc prev_csc)
> +{
> +       omap_writel(prev_csc.matrix[0][0] << ISPPRV_CSC0_RY_SHIFT |
> +                               prev_csc.matrix[0][1] << ISPPRV_CSC0_GY_SHIFT |
> +                               prev_csc.matrix[0][2] << ISPPRV_CSC0_BY_SHIFT,
> +                               ISPPRV_CSC0);
> +
> +       omap_writel(prev_csc.matrix[1][0] << ISPPRV_CSC1_RCB_SHIFT |
> +                       prev_csc.matrix[1][1] << ISPPRV_CSC1_GCB_SHIFT |
> +                       prev_csc.matrix[1][2] << ISPPRV_CSC1_BCB_SHIFT,
> +                       ISPPRV_CSC1);
> +
> +       omap_writel(prev_csc.matrix[2][0] << ISPPRV_CSC2_RCR_SHIFT |
> +                       prev_csc.matrix[2][1] << ISPPRV_CSC2_GCR_SHIFT |
> +                       prev_csc.matrix[2][2] << ISPPRV_CSC2_BCR_SHIFT,
> +                       ISPPRV_CSC2);
> +
> +       omap_writel(prev_csc.offset[0] << ISPPRV_CSC_OFFSET_CR_SHIFT |
> +                       prev_csc.offset[1] << ISPPRV_CSC_OFFSET_CB_SHIFT |
> +                       prev_csc.offset[2] << ISPPRV_CSC_OFFSET_Y_SHIFT,
> +                       ISPPRV_CSC_OFFSET);
> +}
> +EXPORT_SYMBOL(isppreview_config_rgb_to_ycbcr);
> +
> +/**
> + * isppreview_query_contrast - Query the contrast.
> + * @contrast: Pointer to hold the current programmed contrast value.
> + **/
> +void isppreview_query_contrast(u8 *contrast)
> +{
> +       u32 brt_cnt_val = 0;
> +
> +       brt_cnt_val = omap_readl(ISPPRV_CNT_BRT);
> +       *contrast = (brt_cnt_val >> ISPPRV_CNT_BRT_CNT_SHIFT) & 0xFF;
> +       DPRINTK_ISPPREV(" Current brt cnt value in hw is %x\n", brt_cnt_val);
> +}
> +EXPORT_SYMBOL(isppreview_query_contrast);
> +
> +/**
> + * isppreview_update_contrast - Updates the contrast.
> + * @contrast: Pointer to hold the current programmed contrast value.
> + *
> + * Value should be programmed before enabling the module.
> + **/
> +void isppreview_update_contrast(u8 *contrast)
> +{
> +       ispprev_obj.contrast = *contrast;
> +}
> +EXPORT_SYMBOL(isppreview_update_contrast);
> +
> +/**
> + * isppreview_config_contrast - Configures the Contrast.
> + * @contrast: 8 bit value in U8Q4 format.
> + *
> + * Value should be programmed before enabling the module.
> + **/
> +void isppreview_config_contrast(u8 contrast)
> +{
> +       u32 brt_cnt_val = 0;
> +
> +       brt_cnt_val = omap_readl(ISPPRV_CNT_BRT);
> +       brt_cnt_val &= ~(0xFF << ISPPRV_CNT_BRT_CNT_SHIFT);
> +       contrast &= 0xFF;
> +       omap_writel(brt_cnt_val | (contrast << ISPPRV_CNT_BRT_CNT_SHIFT),
> +                                                       ISPPRV_CNT_BRT);
> +}
> +EXPORT_SYMBOL(isppreview_config_contrast);
> +
> +/**
> + * isppreview_get_contrast_range - Gets the range contrast value.
> + * @min_contrast: Pointer to hold the minimum Contrast value.
> + * @max_contrast: Pointer to hold the maximum Contrast value.
> + **/
> +void isppreview_get_contrast_range(u8 *min_contrast, u8 *max_contrast)
> +{
> +       *min_contrast = ISPPRV_CONTRAST_MIN;
> +       *max_contrast = ISPPRV_CONTRAST_MAX;
> +}
> +EXPORT_SYMBOL(isppreview_get_contrast_range);
> +
> +/**
> + * isppreview_update_brightness - Updates the brightness in preview module.
> + * @brightness: Pointer to hold the current programmed brightness value.
> + *
> + **/
> +void isppreview_update_brightness(u8 *brightness)
> +{
> +       ispprev_obj.brightness = *brightness;
> +}
> +EXPORT_SYMBOL(isppreview_update_brightness);
> +
> +/**
> + * isppreview_config_brightness - Configures the brightness.
> + * @contrast: 8bitvalue in U8Q0 format.
> + **/
> +void isppreview_config_brightness(u8 brightness)
> +{
> +       u32 brt_cnt_val = 0;
> +
> +       DPRINTK_ISPPREV("\tConfiguring brightness in ISP: %d\n", brightness);
> +       brt_cnt_val = omap_readl(ISPPRV_CNT_BRT);
> +       brt_cnt_val &= ~(0xFF << ISPPRV_CNT_BRT_BRT_SHIFT);
> +       brightness &= 0xFF;
> +       omap_writel(brt_cnt_val | (brightness << ISPPRV_CNT_BRT_BRT_SHIFT),
> +                                                       ISPPRV_CNT_BRT);
> +}
> +EXPORT_SYMBOL(isppreview_config_brightness);
> +
> +/**
> + * isppreview_query_brightness - Query the brightness.
> + * @brightness: Pointer to hold the current programmed brightness value.
> + **/
> +void isppreview_query_brightness(u8 *brightness)
> +{
> +       *brightness = omap_readl(ISPPRV_CNT_BRT);
> +}
> +EXPORT_SYMBOL(isppreview_query_brightness);
> +
> +/**
> + * isppreview_get_brightness_range - Gets the range brightness value
> + * @min_brightness: Pointer to hold the minimum brightness value
> + * @max_brightness: Pointer to hold the maximum brightness value
> + **/
> +void isppreview_get_brightness_range(u8 *min_brightness, u8 *max_brightness)
> +{
> +       *min_brightness = ISPPRV_BRIGHT_MIN;
> +       *max_brightness = ISPPRV_BRIGHT_MAX;
> +}
> +EXPORT_SYMBOL(isppreview_get_brightness_range);
> +
> +/**
> + * isppreview_set_color - Sets the color effect.
> + * @mode: Indicates the required color effect.
> + **/
> +void isppreview_set_color(u8 *mode)
> +{
> +       ispprev_obj.color = *mode;
> +       update_color_matrix = 1;
> +}
> +EXPORT_SYMBOL(isppreview_set_color);
> +
> +/**
> + * isppreview_get_color - Gets the current color effect.
> + * @mode: Indicates the current color effect.
> + **/
> +void isppreview_get_color(u8 *mode)
> +{
> +       *mode = ispprev_obj.color;
> +}
> +EXPORT_SYMBOL(isppreview_get_color);
> +
> +/**
> + * isppreview_config_yc_range - Configures the max and min Y and C values.
> + * @yclimit: Structure containing the range of Y and C values.
> + **/
> +void isppreview_config_yc_range(struct ispprev_yclimit yclimit)
> +{
> +       omap_writel(((yclimit.maxC << ISPPRV_SETUP_YC_MAXC_SHIFT) |
> +                               (yclimit.maxY << ISPPRV_SETUP_YC_MAXY_SHIFT) |
> +                               (yclimit.minC << ISPPRV_SETUP_YC_MINC_SHIFT) |
> +                               (yclimit.minY << ISPPRV_SETUP_YC_MINY_SHIFT)),
> +                               ISPPRV_SETUP_YC);
> +}
> +EXPORT_SYMBOL(isppreview_config_yc_range);
> +
> +/**
> + * isppreview_try_size - Calculates output dimensions with the modules enabled.
> + * @input_w: input width for the preview in number of pixels per line
> + * @input_h: input height for the preview in number of lines
> + * @output_w: output width from the preview in number of pixels per line
> + * @output_h: output height for the preview in number of lines
> + *
> + * Calculates the number of pixels cropped in the submodules that are enabled,
> + * Fills up the output width height variables in the isp_prev structure.
> + **/
> +int isppreview_try_size(u32 input_w, u32 input_h, u32 *output_w, u32 *output_h)
> +{
> +       u32 prevout_w = input_w;
> +       u32 prevout_h = input_h;
> +       u32 div = 0;
> +       int max_out;
> +
> +       ispprev_obj.previn_w = input_w;
> +       ispprev_obj.previn_h = input_h;
> +
> +       if (input_w < 32 || input_h < 32) {
> +               printk(KERN_ERR "ISP_ERR : preview does not support "
> +                               "width < 16 or height < 32 \n");
> +               return -EINVAL;
> +       }
> +       if (omap_rev() == OMAP3430_REV_ES1_0)
> +               max_out = ISPPRV_MAXOUTPUT_WIDTH;
> +       else
> +               max_out = ISPPRV_MAXOUTPUT_WIDTH_ES2;
> +
> +       ispprev_obj.fmtavg = 0;
> +
> +       if (input_w > max_out) {
> +               div = (input_w/max_out);
> +               if (div >= 2 && div < 4) {
> +                       ispprev_obj.fmtavg = 1;
> +                       prevout_w /= 2;
> +               } else if (div >= 4 && div < 8) {
> +                       ispprev_obj.fmtavg = 2;
> +                       prevout_w /= 4;
> +               } else if (div >= 8) {
> +                       ispprev_obj.fmtavg = 3;
> +                       prevout_w /= 8;
> +               }
> +       }
> +
> +       if (ispprev_obj.hmed_en)
> +               prevout_w -= 4;
> +       if (ispprev_obj.nf_en) {
> +               prevout_w -= 4;
> +               prevout_h -= 4;
> +       }
> +       if (ispprev_obj.cfa_en) {
> +               switch (ispprev_obj.cfafmt) {
> +               case CFAFMT_BAYER:
> +               case CFAFMT_SONYVGA:
> +                       prevout_w -= 4;
> +                       prevout_h -= 4;
> +                       break;
> +               case CFAFMT_RGBFOVEON:
> +               case CFAFMT_RRGGBBFOVEON:
> +               case CFAFMT_DNSPL:
> +               case CFAFMT_HONEYCOMB:
> +                       prevout_h -= 2;
> +                       break;
> +               };
> +       }
> +       if ((ispprev_obj.yenh_en) || (ispprev_obj.csup_en))
> +               prevout_w -= 2;
> +
> +       /* Start at the correct row/column by skipping
> +        * a Sensor specific amount.
> +        */
> +       prevout_w -= ispprev_obj.sph;
> +       prevout_h -= ispprev_obj.slv;
> +
> +
> +       if (prevout_w % 2)
> +               prevout_w -= 1;
> +
> +       if (ispprev_obj.prev_outfmt == PREVIEW_MEM) {
> +               if (((prevout_w * 2) & ISP_32B_BOUNDARY_OFFSET) != (prevout_w *
> +                                                                       2)) {
> +                       prevout_w = ((prevout_w * 2) &
> +                                               ISP_32B_BOUNDARY_OFFSET) / 2;
> +               }
> +       }
> +       *output_w = prevout_w;
> +       ispprev_obj.prevout_w = prevout_w;
> +       *output_h = prevout_h;
> +       ispprev_obj.prevout_h = prevout_h;
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_try_size);
> +
> +/**
> + * isppreview_config_size - Sets the size of ISP preview output.
> + * @input_w: input width for the preview in number of pixels per line
> + * @input_h: input height for the preview in number of lines
> + * @output_w: output width from the preview in number of pixels per line
> + * @output_h: output height for the preview in number of lines
> + *
> + * Configures the appropriate values stored in the isp_prev structure to
> + * HORZ/VERT_INFO. Configures PRV_AVE if needed for downsampling as calculated
> + * in trysize.
> + **/
> +int isppreview_config_size(u32 input_w, u32 input_h, u32 output_w,
> +                                                               u32 output_h)
> +{
> +       u32 prevsdroff;
> +
> +       if ((output_w != ispprev_obj.prevout_w) ||
> +                                       (output_h != ispprev_obj.prevout_h)) {
> +               printk(KERN_ERR "ISP_ERR : isppreview_try_size should "
> +                                       "be called before config size\n");
> +               return -EINVAL;
> +       }
> +
> +       omap_writel((ispprev_obj.sph << ISPPRV_HORZ_INFO_SPH_SHIFT) |
> +                                               (ispprev_obj.previn_w - 1),
> +                                               ISPPRV_HORZ_INFO);
> +       omap_writel((ispprev_obj.slv << ISPPRV_VERT_INFO_SLV_SHIFT) |
> +                                               (ispprev_obj.previn_h - 1),
> +                                               ISPPRV_VERT_INFO);
> +
> +       if (ispprev_obj.cfafmt == CFAFMT_BAYER)
> +               omap_writel(ISPPRV_AVE_EVENDIST_2 <<
> +                                       ISPPRV_AVE_EVENDIST_SHIFT |
> +                                       ISPPRV_AVE_ODDDIST_2 <<
> +                                       ISPPRV_AVE_ODDDIST_SHIFT |
> +                                       ispprev_obj.fmtavg,
> +                                       ISPPRV_AVE);
> +
> +       if (ispprev_obj.prev_outfmt == PREVIEW_MEM) {
> +               prevsdroff = ispprev_obj.prevout_w * 2;
> +               if ((prevsdroff & ISP_32B_BOUNDARY_OFFSET) != prevsdroff) {
> +                       DPRINTK_ISPPREV("ISP_WARN: Preview output buffer line"
> +                                               " size is truncated"
> +                                               " to 32byte boundary\n");
> +                       prevsdroff &= ISP_32B_BOUNDARY_BUF ;
> +               }
> +               isppreview_config_outlineoffset(prevsdroff);
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_config_size);
> +
> +/**
> + * isppreview_config_inlineoffset - Configures the Read address line offset.
> + * @offset: Line Offset for the input image.
> + **/
> +int isppreview_config_inlineoffset(u32 offset)
> +{
> +       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset)
> +               omap_writel(offset & 0xFFFF, ISPPRV_RADR_OFFSET);
> +       else {
> +               printk(KERN_ERR "ISP_ERR : Offset should be in 32 byte "
> +                                                               "boundary\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_config_inlineoffset);
> +
> +/**
> + * isppreview_set_inaddr - Sets memory address of input frame.
> + * @addr: 32bit memory address aligned on 32byte boundary.
> + *
> + * Configures the memory address from which the input frame is to be read.
> + **/
> +int isppreview_set_inaddr(u32 addr)
> +{
> +       if ((addr & ISP_32B_BOUNDARY_BUF) == addr)
> +               omap_writel(addr, ISPPRV_RSDR_ADDR);
> +       else {
> +               printk(KERN_ERR "ISP_ERR: Address should be in 32 byte "
> +                                                               "boundary\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_set_inaddr);
> +
> +/**
> + * isppreview_config_outlineoffset - Configures the Write address line offset.
> + * @offset: Line Offset for the preview output.
> + **/
> +int isppreview_config_outlineoffset(u32 offset)
> +{
> +       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset) {
> +               omap_writel(offset & 0xFFFF, ISPPRV_WADD_OFFSET);
> +       } else {
> +               printk(KERN_ERR "ISP_ERR : Offset should be in 32 byte "
> +                                                               "boundary\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}

Looks a bit awkward. This is simpler:

int isppreview_config_outlineoffset(u32 offset)
{
       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset) {
               omap_writel(offset & 0xFFFF, ISPPRV_WADD_OFFSET);
	       return 0;
       }
       printk(KERN_ERR "ISP_ERR : Offset should be in 32 byte boundary\n");
       return -EINVAL;
}

The same is true for the functions below.

Regards,

	Hans

> +EXPORT_SYMBOL(isppreview_config_outlineoffset);
> +
> +/**
> + * isppreview_set_outaddr - Sets the memory address to store output frame
> + * @addr: 32bit memory address aligned on 32byte boundary.
> + *
> + * Configures the memory address to which the output frame is written.
> + **/
> +int isppreview_set_outaddr(u32 addr)
> +{
> +       if ((addr & ISP_32B_BOUNDARY_BUF) == addr) {
> +               omap_writel(addr, ISPPRV_WSDR_ADDR);
> +       } else {
> +               printk(KERN_ERR "ISP_ERR: Address should be in 32 byte "
> +                                                               "boundary\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_set_outaddr);
> +
> +/**
> + * isppreview_config_darklineoffset - Sets the Dark frame address line offset.
> + * @offset: Line Offset for the Darkframe.
> + **/
> +int isppreview_config_darklineoffset(u32 offset)
> +{
> +       if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset)
> +               omap_writel(offset & 0xFFFF, ISPPRV_DRKF_OFFSET);
> +       else {
> +               printk(KERN_ERR "ISP_ERR : Offset should be in 32 byte "
> +                                                               "boundary\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_config_darklineoffset);
> +
> +/**
> + * isppreview_set_darkaddr - Sets the memory address to store Dark frame.
> + * @addr: 32bit memory address aligned on 32 bit boundary.
> + **/
> +int isppreview_set_darkaddr(u32 addr)
> +{
> +       if ((addr & ISP_32B_BOUNDARY_BUF) == addr)
> +               omap_writel(addr, ISPPRV_DSDR_ADDR);
> +       else {
> +               printk(KERN_ERR "ISP_ERR : Address should be in 32 byte "
> +                                                               "boundary\n");
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(isppreview_set_darkaddr);
> +
> +/**
> + * isppreview_enable - Enables the Preview module.
> + * @enable: 1 - Enables the preview module.
> + *
> + * Client should configure all the sub modules in Preview before this.
> + **/
> +void isppreview_enable(u8 enable)
> +{
> +
> +       if (enable) {
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               ispprev_obj.stream_on = 1;
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +               omap_writel((omap_readl(ISPPRV_PCR)) | ISPPRV_PCR_EN,
> +                                                               ISPPRV_PCR);
> +       } else {
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               ispprev_obj.stream_on = 0;
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +               omap_writel((omap_readl(ISPPRV_PCR)) & ~ISPPRV_PCR_EN,
> +                                                               ISPPRV_PCR);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_enable);
> +
> +/**
> + * isppreview_busy - Gets busy state of preview module.
> + **/
> +int isppreview_busy(void)
> +{
> +       return omap_readl(ISPPRV_PCR) & ISPPRV_PCR_BUSY;
> +}
> +EXPORT_SYMBOL(isppreview_busy);
> +
> +/**
> + * isppreview_get_config - Gets parameters of preview module.
> + **/
> +struct prev_params *isppreview_get_config(void)
> +{
> +       return prev_config_params;
> +}
> +EXPORT_SYMBOL(isppreview_get_config);
> +
> +/**
> + * isppreview_save_context - Saves the values of the preview module registers.
> + **/
> +void isppreview_save_context(void)
> +{
> +       DPRINTK_ISPPREV("Saving context\n");
> +       isp_save_context(ispprev_reg_list);
> +}
> +EXPORT_SYMBOL(isppreview_save_context);
> +
> +/**
> + * isppreview_restore_context - Restores the values of preview module registers
> + **/
> +void isppreview_restore_context(void)
> +{
> +       DPRINTK_ISPPREV("Restoring context\n");
> +       isp_restore_context(ispprev_reg_list);
> +}
> +EXPORT_SYMBOL(isppreview_restore_context);
> +
> +/**
> + * isppreview_print_status - Prints the values of the Preview Module registers.
> + *
> + * Also prints other debug information stored in the preview moduel.
> + **/
> +void isppreview_print_status(void)
> +{
> +#ifdef OMAP_ISPPREV_DEBUG
> +       printk("Module in use =%d\n", ispprev_obj.prev_inuse);
> +       DPRINTK_ISPPREV("Preview Input format =%d, Output Format =%d\n",
> +                                               ispprev_obj.prev_inpfmt,
> +                                               ispprev_obj.prev_outfmt);
> +       DPRINTK_ISPPREV("Accepted Preview Input (width = %d,Height = %d)\n",
> +                                               ispprev_obj.previn_w,
> +                                               ispprev_obj.previn_h);
> +       DPRINTK_ISPPREV("Accepted Preview Output (width = %d,Height = %d)\n",
> +                                               ispprev_obj.prevout_w,
> +                                               ispprev_obj.prevout_h);
> +       DPRINTK_ISPPREV("###ISP_CTRL in preview =0x%x\n",
> +                                               omap_readl(ISP_CTRL));
> +       DPRINTK_ISPPREV("###ISP_IRQ0ENABLE in preview =0x%x\n",
> +                                               omap_readl(ISP_IRQ0ENABLE));
> +       DPRINTK_ISPPREV("###ISP_IRQ0STATUS in preview =0x%x\n",
> +                                               omap_readl(ISP_IRQ0STATUS));
> +       DPRINTK_ISPPREV("###PRV PCR =0x%x\n", omap_readl(ISPPRV_PCR));
> +       DPRINTK_ISPPREV("###PRV HORZ_INFO =0x%x\n",
> +                                               omap_readl(ISPPRV_HORZ_INFO));
> +       DPRINTK_ISPPREV("###PRV VERT_INFO =0x%x\n",
> +                                               omap_readl(ISPPRV_VERT_INFO));
> +       DPRINTK_ISPPREV("###PRV WSDR_ADDR =0x%x\n",
> +                                               omap_readl(ISPPRV_WSDR_ADDR));
> +       DPRINTK_ISPPREV("###PRV WADD_OFFSET =0x%x\n",
> +                                       omap_readl(ISPPRV_WADD_OFFSET));
> +       DPRINTK_ISPPREV("###PRV AVE =0x%x\n", omap_readl(ISPPRV_AVE));
> +       DPRINTK_ISPPREV("###PRV HMED =0x%x\n", omap_readl(ISPPRV_HMED));
> +       DPRINTK_ISPPREV("###PRV NF =0x%x\n", omap_readl(ISPPRV_NF));
> +       DPRINTK_ISPPREV("###PRV WB_DGAIN =0x%x\n",
> +                                               omap_readl(ISPPRV_WB_DGAIN));
> +       DPRINTK_ISPPREV("###PRV WBGAIN =0x%x\n", omap_readl(ISPPRV_WBGAIN));
> +       DPRINTK_ISPPREV("###PRV WBSEL =0x%x\n", omap_readl(ISPPRV_WBSEL));
> +       DPRINTK_ISPPREV("###PRV CFA =0x%x\n", omap_readl(ISPPRV_CFA));
> +       DPRINTK_ISPPREV("###PRV BLKADJOFF =0x%x\n",
> +                                               omap_readl(ISPPRV_BLKADJOFF));
> +       DPRINTK_ISPPREV("###PRV RGB_MAT1 =0x%x\n",
> +                                               omap_readl(ISPPRV_RGB_MAT1));
> +       DPRINTK_ISPPREV("###PRV RGB_MAT2 =0x%x\n",
> +                                               omap_readl(ISPPRV_RGB_MAT2));
> +       DPRINTK_ISPPREV("###PRV RGB_MAT3 =0x%x\n",
> +                                               omap_readl(ISPPRV_RGB_MAT3));
> +       DPRINTK_ISPPREV("###PRV RGB_MAT4 =0x%x\n",
> +                                               omap_readl(ISPPRV_RGB_MAT4));
> +       DPRINTK_ISPPREV("###PRV RGB_MAT5 =0x%x\n",
> +                                               omap_readl(ISPPRV_RGB_MAT5));
> +       DPRINTK_ISPPREV("###PRV RGB_OFF1 =0x%x\n",
> +                                               omap_readl(ISPPRV_RGB_OFF1));
> +       DPRINTK_ISPPREV("###PRV RGB_OFF2 =0x%x\n",
> +                                               omap_readl(ISPPRV_RGB_OFF2));
> +       DPRINTK_ISPPREV("###PRV CSC0 =0x%x\n", omap_readl(ISPPRV_CSC0));
> +       DPRINTK_ISPPREV("###PRV CSC1 =0x%x\n", omap_readl(ISPPRV_CSC1));
> +       DPRINTK_ISPPREV("###PRV CSC2 =0x%x\n", omap_readl(ISPPRV_CSC2));
> +       DPRINTK_ISPPREV("###PRV CSC_OFFSET =0x%x\n",
> +                                               omap_readl(ISPPRV_CSC_OFFSET));
> +       DPRINTK_ISPPREV("###PRV CNT_BRT =0x%x\n", omap_readl(ISPPRV_CNT_BRT));
> +       DPRINTK_ISPPREV("###PRV CSUP =0x%x\n", omap_readl(ISPPRV_CSUP));
> +       DPRINTK_ISPPREV("###PRV SETUP_YC =0x%x\n",
> +                                               omap_readl(ISPPRV_SETUP_YC));
> +#endif
> +}
> +EXPORT_SYMBOL(isppreview_print_status);
> +
> +/**
> + * isp_preview_init - Module Initialization.
> + **/
> +int __init isp_preview_init(void)
> +{
> +       int i = 0;
> +
> +       prev_config_params = kmalloc(sizeof(*prev_config_params), GFP_KERNEL);
> +       if (prev_config_params == NULL) {
> +               printk(KERN_ERR "Can't get memory for isp_preview params!\n");
> +               return -ENOMEM;
> +       }
> +       params = prev_config_params;
> +
> +       ispprev_obj.prev_inuse = 0;
> +       mutex_init(&ispprev_obj.ispprev_mutex);
> +       spin_lock_init(&ispprev_obj.ispprev_lock);
> +
> +       /* Init values */
> +       ispprev_obj.sph = 2;
> +       ispprev_obj.slv = 0;
> +       ispprev_obj.color = PREV_DEFAULT_COLOR;
> +       ispprev_obj.contrast = ISPPRV_CONTRAST_DEF;
> +       params->contrast = ISPPRV_CONTRAST_DEF;
> +       ispprev_obj.brightness = ISPPRV_BRIGHT_DEF;
> +       params->brightness = ISPPRV_BRIGHT_DEF;
> +       params->average = NO_AVE;
> +       params->lens_shading_shift = 0;
> +       params->pix_fmt = YCPOS_YCrYCb;
> +       params->cfa.cfafmt = CFAFMT_BAYER;
> +       params->cfa.cfa_table = cfa_coef_table;
> +       params->cfa.cfa_gradthrs_horz = FLR_CFA_GRADTHRS_HORZ;
> +       params->cfa.cfa_gradthrs_vert = FLR_CFA_GRADTHRS_VERT;
> +       params->csup.gain = FLR_CSUP_GAIN;
> +       params->csup.thres = FLR_CSUP_THRES;
> +       params->csup.hypf_en = 0;
> +       params->ytable = luma_enhance_table;
> +       params->nf.spread = FLR_NF_STRGTH;
> +       memcpy(params->nf.table, noise_filter_table, sizeof(params->nf.table));
> +       params->dcor.couplet_mode_en = 1;
> +       for (i = 0; i < 4; i++)
> +               params->dcor.detect_correct[i] = 0xE;
> +       params->gtable.bluetable = bluegamma_table;
> +       params->gtable.greentable = greengamma_table;
> +       params->gtable.redtable = redgamma_table;
> +       params->wbal.dgain = FLR_WBAL_DGAIN;
> +       if (omap_rev() > OMAP3430_REV_ES1_0) {
> +               params->wbal.coef0 = FLR_WBAL_COEF0_ES1;
> +               params->wbal.coef1 = FLR_WBAL_COEF1_ES1;
> +               params->wbal.coef2 = FLR_WBAL_COEF2_ES1;
> +               params->wbal.coef3 = FLR_WBAL_COEF3_ES1;
> +       } else {
> +               params->wbal.coef0 = FLR_WBAL_COEF0;
> +               params->wbal.coef1 = FLR_WBAL_COEF1;
> +               params->wbal.coef2 = FLR_WBAL_COEF2;
> +               params->wbal.coef3 = FLR_WBAL_COEF3;
> +       }
> +       params->blk_adj.red = FLR_BLKADJ_RED;
> +       params->blk_adj.green = FLR_BLKADJ_GREEN;
> +       params->blk_adj.blue = FLR_BLKADJ_BLUE;
> +       params->rgb2rgb = flr_rgb2rgb;
> +       params->rgb2ycbcr = flr_prev_csc[ispprev_obj.color];
> +
> +       params->features = PREV_CFA | PREV_CHROMA_SUPPRESS | PREV_LUMA_ENHANCE
> +                               | PREV_DEFECT_COR | PREV_NOISE_FILTER;
> +       params->features &= ~(PREV_AVERAGER | PREV_INVERSE_ALAW |
> +                                               PREV_HORZ_MEDIAN_FILTER |
> +                                               PREV_GAMMA_BYPASS |
> +                                               PREV_DARK_FRAME_SUBTRACT |
> +                                               PREV_LENS_SHADING |
> +                                               PREV_DARK_FRAME_CAPTURE);
> +       return 0;
> +}
> +
> +/**
> + * isp_preview_cleanup - Module Cleanup.
> + **/
> +void __exit isp_preview_cleanup(void)
> +{
> +       kfree(prev_config_params);
> +       prev_config_params = NULL;
> +}
> diff --git a/drivers/media/video/isp/isppreview.h b/drivers/media/video/isp/isppreview.h
> new file mode 100644
> index 0000000..630295c
> --- /dev/null
> +++ b/drivers/media/video/isp/isppreview.h
> @@ -0,0 +1,356 @@
> +/*
> + * drivers/media/video/isp/isppreview.h
> + *
> + * Driver header file for Preview module in TI's OMAP3 Camera ISP
> + *
> + * Copyright (C) 2008 Texas Instruments, Inc.
> + *
> + * Contributors:
> + *     Senthilvadivu Guruswamy <svadivu@ti.com>
> + *     Pallavi Kulkarni <p-kulkarni@ti.com>
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
> +#ifndef OMAP_ISP_PREVIEW_H
> +#define OMAP_ISP_PREVIEW_H
> +
> +#include <mach/isp_user.h>
> +/* Isp query control structure */
> +
> +#define ISPPRV_BRIGHT_STEP             0x1
> +#define ISPPRV_BRIGHT_DEF              0x1
> +#define ISPPRV_BRIGHT_LOW              0x0
> +#define ISPPRV_BRIGHT_HIGH             0xF
> +#define ISPPRV_BRIGHT_UNITS            0x7
> +
> +#define ISPPRV_CONTRAST_STEP           0x1
> +#define ISPPRV_CONTRAST_DEF            0x2
> +#define ISPPRV_CONTRAST_LOW            0x0
> +#define ISPPRV_CONTRAST_HIGH           0xF
> +#define ISPPRV_CONTRAST_UNITS          0x5
> +
> +#define NO_AVE                         0x0
> +#define AVE_2_PIX                      0x1
> +#define AVE_4_PIX                      0x2
> +#define AVE_8_PIX                      0x3
> +#define AVE_ODD_PIXEL_DIST             (1 << 4) /* For Bayer Sensors */
> +#define AVE_EVEN_PIXEL_DIST            (1 << 2)
> +
> +#define WB_GAIN_MAX                    4
> +
> +/* Features list */
> +#define PREV_AVERAGER                  (1 << 0)
> +#define PREV_INVERSE_ALAW              (1 << 1)
> +#define PREV_HORZ_MEDIAN_FILTER                (1 << 2)
> +#define PREV_NOISE_FILTER              (1 << 3)
> +#define PREV_CFA                       (1 << 4)
> +#define PREV_GAMMA_BYPASS              (1 << 5)
> +#define PREV_LUMA_ENHANCE              (1 << 6)
> +#define PREV_CHROMA_SUPPRESS           (1 << 7)
> +#define PREV_DARK_FRAME_SUBTRACT       (1 << 8)
> +#define PREV_LENS_SHADING              (1 << 9)
> +#define PREV_DARK_FRAME_CAPTURE                (1 << 10)
> +#define PREV_DEFECT_COR                        (1 << 11)
> +
> +
> +#define ISP_NF_TABLE_SIZE              (1 << 10)
> +
> +#define ISP_GAMMA_TABLE_SIZE           (1 << 10)
> +
> +/* Table addresses */
> +#define ISPPRV_TBL_ADDR_RED_G_START  0x00
> +#define ISPPRV_TBL_ADDR_BLUE_G_START  0x800
> +#define ISPPRV_TBL_ADDR_GREEN_G_START  0x400
> +
> +/*
> + *Enumeration Constants for input and output format
> + */
> +enum preview_input {
> +       PRV_RAW_CCDC,
> +       PRV_RAW_MEM,
> +       PRV_RGBBAYERCFA,
> +       PRV_COMPCFA,
> +       PRV_CCDC_DRKF,
> +       PRV_OTHERS
> +};
> +enum preview_output {
> +       PREVIEW_RSZ,
> +       PREVIEW_MEM
> +};
> +/*
> + * Configure byte layout of YUV image
> + */
> +enum preview_ycpos_mode {
> +       YCPOS_YCrYCb = 0,
> +       YCPOS_YCbYCr = 1,
> +       YCPOS_CbYCrY = 2,
> +       YCPOS_CrYCbY = 3
> +};
> +
> +enum preview_color_effect {
> +       PREV_DEFAULT_COLOR = 0,
> +       PREV_SEPIA_COLOR = 1,
> +       PREV_BW_COLOR = 2
> +};
> +
> +
> +/**
> + * struct ispprev_gtable - Structure for Gamma Correction.
> + * @redtable: Pointer to the red gamma table.
> + * @greentable: Pointer to the green gamma table.
> + * @bluetable: Pointer to the blue gamma table.
> + */
> +struct ispprev_gtable {
> +       u32 *redtable;
> +       u32 *greentable;
> +       u32 *bluetable;
> +};
> +
> +/**
> + * struct prev_white_balance - Structure for White Balance 2.
> + * @wb_dgain: White balance common gain.
> + * @wb_gain: Individual color gains.
> + * @wb_coefmatrix: Coefficient matrix
> + */
> +struct prev_white_balance {
> +       u16 wb_dgain; /* white balance common gain */
> +       u8 wb_gain[WB_GAIN_MAX]; /* individual color gains */
> +       u8 wb_coefmatrix[WB_GAIN_MAX][WB_GAIN_MAX];
> +};
> +
> +/**
> + * struct prev_size_params - Structure for size parameters.
> + * @hstart: Starting pixel.
> + * @vstart: Starting line.
> + * @hsize: Width of input image.
> + * @vsize: Height of input image.
> + * @pixsize: Pixel size of the image in terms of bits.
> + * @in_pitch: Line offset of input image.
> + * @out_pitch: Line offset of output image.
> + */
> +struct prev_size_params {
> +       unsigned int hstart;
> +       unsigned int vstart;
> +       unsigned int hsize;
> +       unsigned int vsize;
> +       unsigned char pixsize;
> +       unsigned short in_pitch;
> +       unsigned short out_pitch;
> +};
> +
> +/**
> + * struct prev_rgb2ycbcr_coeffs - Structure RGB2YCbCr parameters.
> + * @coeff: Color conversion gains in 3x3 matrix.
> + * @offset: Color conversion offsets.
> + */
> +struct prev_rgb2ycbcr_coeffs {
> +       short coeff[RGB_MAX][RGB_MAX];
> +       short offset[RGB_MAX];
> +};
> +
> +/**
> + * struct prev_darkfrm_params - Structure for Dark frame suppression.
> + * @addr: Memory start address.
> + * @offset: Line offset.
> + */
> +struct prev_darkfrm_params {
> +       u32 addr;
> +       u32 offset;
> +};
> +
> +/**
> + * struct prev_params - Structure for all configuration
> + * @features: Set of features enabled.
> + * @pix_fmt: Output pixel format.
> + * @cfa: CFA coefficients.
> + * @csup: Chroma suppression coefficients.
> + * @ytable: Pointer to Luma enhancement coefficients.
> + * @nf: Noise filter coefficients.
> + * @dcor: Noise filter coefficients.
> + * @gtable: Gamma coefficients.
> + * @wbal: White Balance parameters.
> + * @blk_adj: Black adjustment parameters.
> + * @rgb2rgb: RGB blending parameters.
> + * @rgb2ycbcr: RGB to ycbcr parameters.
> + * @hmf_params: Horizontal median filter.
> + * @size_params: Size parameters.
> + * @drkf_params: Darkframe parameters.
> + * @lens_shading_shift:
> + * @average: Downsampling rate for averager.
> + * @contrast: Contrast.
> + * @brightness: Brightness.
> + */
> +struct prev_params {
> +       u16 features;
> +       enum preview_ycpos_mode pix_fmt;
> +       struct ispprev_cfa cfa;
> +       struct ispprev_csup csup;
> +       u32 *ytable;
> +       struct ispprev_nf nf;
> +       struct ispprev_dcor dcor;
> +       struct ispprev_gtable gtable;
> +       struct ispprev_wbal wbal;
> +       struct ispprev_blkadj blk_adj;
> +       struct ispprev_rgbtorgb rgb2rgb;
> +       struct ispprev_csc rgb2ycbcr;
> +       struct ispprev_hmed hmf_params;
> +       struct prev_size_params size_params;
> +       struct prev_darkfrm_params drkf_params;
> +       u8 lens_shading_shift;
> +       u8 average;
> +       u8 contrast;
> +       u8 brightness;
> +};
> +
> +/**
> + * struct isptables_update - Structure for Table Configuration.
> + * @update: Specifies which tables should be updated.
> + * @flag: Specifies which tables should be enabled.
> + * @prev_nf: Pointer to structure for Noise Filter
> + * @lsc: Pointer to LSC gain table. (currently not used)
> + * @red_gamma: Pointer to red gamma correction table.
> + * @green_gamma: Pointer to green gamma correction table.
> + * @blue_gamma: Pointer to blue gamma correction table.
> + */
> +struct isptables_update {
> +       u16 update;
> +       u16 flag;
> +       struct ispprev_nf *prev_nf;
> +       u32 *lsc;
> +       u32 *red_gamma;
> +       u32 *green_gamma;
> +       u32 *blue_gamma;
> +};
> +
> +void isppreview_config_shadow_registers(void);
> +
> +int isppreview_request(void);
> +
> +int isppreview_free(void);
> +
> +int isppreview_config_datapath(enum preview_input input,
> +                                       enum preview_output output);
> +
> +void isppreview_config_ycpos(enum preview_ycpos_mode mode);
> +
> +void isppreview_config_averager(u8 average);
> +
> +void isppreview_enable_invalaw(u8 enable);
> +
> +void isppreview_enable_drkframe(u8 enable);
> +
> +void isppreview_enable_shadcomp(u8 enable);
> +
> +void isppreview_config_drkf_shadcomp(u8 scomp_shtval);
> +
> +void isppreview_enable_gammabypass(u8 enable);
> +
> +void isppreview_enable_hmed(u8 enable);
> +
> +void isppreview_config_hmed(struct ispprev_hmed);
> +
> +void isppreview_enable_noisefilter(u8 enable);
> +
> +void isppreview_config_noisefilter(struct ispprev_nf prev_nf);
> +
> +void isppreview_enable_dcor(u8 enable);
> +
> +void isppreview_config_dcor(struct ispprev_dcor prev_dcor);
> +
> +
> +void isppreview_config_cfa(struct ispprev_cfa);
> +
> +void isppreview_config_gammacorrn(struct ispprev_gtable);
> +
> +void isppreview_config_chroma_suppression(struct ispprev_csup csup);
> +
> +void isppreview_enable_cfa(u8 enable);
> +
> +void isppreview_config_luma_enhancement(u32 *ytable);
> +
> +void isppreview_enable_luma_enhancement(u8 enable);
> +
> +void isppreview_enable_chroma_suppression(u8 enable);
> +
> +void isppreview_config_whitebalance(struct ispprev_wbal);
> +
> +void isppreview_config_blkadj(struct ispprev_blkadj);
> +
> +void isppreview_config_rgb_blending(struct ispprev_rgbtorgb);
> +
> +void isppreview_config_rgb_to_ycbcr(struct ispprev_csc);
> +
> +void isppreview_update_contrast(u8 *contrast);
> +
> +void isppreview_query_contrast(u8 *contrast);
> +
> +void isppreview_config_contrast(u8 contrast);
> +
> +void isppreview_get_contrast_range(u8 *min_contrast, u8 *max_contrast);
> +
> +void isppreview_update_brightness(u8 *brightness);
> +
> +void isppreview_config_brightness(u8 brightness);
> +
> +void isppreview_get_brightness_range(u8 *min_brightness, u8 *max_brightness);
> +
> +void isppreview_set_color(u8 *mode);
> +
> +void isppreview_get_color(u8 *mode);
> +
> +void isppreview_query_brightness(u8 *brightness);
> +
> +void isppreview_config_yc_range(struct ispprev_yclimit yclimit);
> +
> +int isppreview_try_size(u32 input_w, u32 input_h, u32 *output_w,
> +                               u32 *output_h);
> +
> +int isppreview_config_size(u32 input_w, u32 input_h, u32 output_w,
> +                       u32 output_h);
> +
> +int isppreview_config_inlineoffset(u32 offset);
> +
> +int isppreview_set_inaddr(u32 addr);
> +
> +int isppreview_config_outlineoffset(u32 offset);
> +
> +int isppreview_set_outaddr(u32 addr);
> +
> +int isppreview_config_darklineoffset(u32 offset);
> +
> +int isppreview_set_darkaddr(u32 addr);
> +
> +void isppreview_enable(u8 enable);
> +
> +int isppreview_busy(void);
> +
> +struct prev_params *isppreview_get_config(void);
> +
> +void isppreview_print_status(void);
> +
> +#ifndef CONFIG_ARCH_OMAP3410
> +void isppreview_save_context(void);
> +#else
> +static inline void isppreview_save_context(void) {}
> +#endif
> +
> +#ifndef CONFIG_ARCH_OMAP3410
> +void isppreview_restore_context(void);
> +#else
> +static inline void isppreview_restore_context(void) {}
> +#endif
> +
> +int omap34xx_isp_preview_config(void *userspace_add);
> +
> +int omap34xx_isp_tables_update(struct isptables_update *isptables_struct);
> +
> +void isppreview_set_skip(u32 h, u32 v);
> +
> +#endif/* OMAP_ISP_PREVIEW_H */
> diff --git a/drivers/media/video/isp/ispresizer.c b/drivers/media/video/isp/ispresizer.c
> new file mode 100644
> index 0000000..3dfef88
> --- /dev/null
> +++ b/drivers/media/video/isp/ispresizer.c
> @@ -0,0 +1,895 @@
> +/*
> + * drivers/media/video/isp/ispresizer.c
> + *
> + * Driver Library for Resizer module in TI's OMAP3 Camera ISP
> + *
> + * Copyright (C)2008 Texas Instruments, Inc.
> + *
> + * Contributors:
> + *     Sameer Venkatraman <sameerv@ti.com>
> + *     Mohit Jalori
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
> +#include <linux/io.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/semaphore.h>
> +
> +#include "isp.h"
> +#include "ispreg.h"
> +#include "ispresizer.h"
> +
> +#if ISP_WORKAROUND
> +dma_addr_t buff_addr_lsc_wa;
> +#endif
> +
> +/* Default configuration of resizer,filter coefficients,yenh for camera isp */
> +static struct isprsz_yenh ispreszdefaultyenh = {0, 0, 0, 0};
> +static struct isprsz_coef ispreszdefcoef = {
> +       {
> +               0x0027, 0x00B2, 0x00B2, 0x0027,
> +               0x0027, 0x00B2, 0x0027, 0x00B2,
> +               0x0027, 0x00B2, 0x0027, 0x00B2,
> +               0x0027, 0x00B2, 0x0027, 0x00B2,
> +               0x0027, 0x00B2, 0x0027, 0x00B2,
> +               0x0027, 0x00B2, 0x0027, 0x00B2,
> +               0x0027, 0x00B2, 0x0027, 0x00B2,
> +               0x0027, 0x00B2, 0x0027, 0x00B2,
> +       },
> +       {
> +               0x0000, 0x0100, 0x0000, 0x0000,
> +               0x03FA, 0x00F6, 0x0010, 0x0000,
> +               0x03F9, 0x00DB, 0x002C, 0x0000,
> +               0x03FB, 0x00B3, 0x0053, 0x03FF,
> +               0x03FD, 0x0082, 0x0084, 0x03FD,
> +               0x03FF, 0x0053, 0x00B3, 0x03FB,
> +               0x0000, 0x002C, 0x00DB, 0x03F9,
> +               0x0000, 0x0010, 0x00F6, 0x03FA
> +       },
> +       {
> +               0x0004, 0x0023, 0x0023, 0x005A,
> +               0x005A, 0x0058, 0x0058, 0x0004,
> +               0x0023, 0x0023, 0x005A, 0x005A,
> +               0x0058, 0x0058, 0x0004, 0x0023,
> +               0x0023, 0x005A, 0x005A, 0x0058,
> +               0x0058, 0x0004, 0x0023, 0x0023,
> +               0x005A, 0x005A, 0x0058, 0x0058
> +       },
> +       {
> +               0x0004, 0x0023, 0x005A, 0x0058,
> +               0x0023, 0x0004, 0x0000, 0x0002,
> +               0x0018, 0x004d, 0x0060, 0x0031,
> +               0x0008, 0x0000, 0x0001, 0x000f,
> +               0x003f, 0x0062, 0x003f, 0x000f,
> +               0x0001, 0x0000, 0x0008, 0x0031,
> +               0x0060, 0x004d, 0x0018, 0x0002
> +       }
> +};
> +
> +/**
> + * struct isp_res - Structure for the resizer module to store its information.
> + * @res_inuse: Indicates if resizer module has been reserved. 1 - Reserved,
> + *             0 - Freed.
> + * @h_startphase: Horizontal starting phase.
> + * @v_startphase: Vertical starting phase.
> + * @h_resz: Horizontal resizing value.
> + * @v_resz: Vertical resizing value.
> + * @outputwidth: Output Image Width in pixels.
> + * @outputheight: Output Image Height in pixels.
> + * @inputwidth: Input Image Width in pixels.
> + * @inputheight: Input Image Height in pixels.
> + * @algo: Algorithm select. 0 - Disable, 1 - [-1 2 -1]/2 high-pass filter,
> + *        2 - [-1 -2 6 -2 -1]/4 high-pass filter.
> + * @ipht_crop: Vertical start line for cropping.
> + * @ipwd_crop: Horizontal start pixel for cropping.
> + * @cropwidth: Crop Width.
> + * @cropheight: Crop Height.
> + * @resinput: Resizer input.
> + * @coeflist: Register configuration for Resizer.
> + * @ispres_mutex: Mutex for isp resizer.
> + */
> +static struct isp_res {
> +       u8 res_inuse;
> +       u8 h_startphase;
> +       u8 v_startphase;
> +       u16 h_resz;
> +       u16 v_resz;
> +       u32 outputwidth;
> +       u32 outputheight;
> +       u32 inputwidth;
> +       u32 inputheight;
> +       u8 algo;
> +       u32 ipht_crop;
> +       u32 ipwd_crop;
> +       u32 cropwidth;
> +       u32 cropheight;
> +       enum ispresizer_input resinput;
> +       struct isprsz_coef coeflist;
> +       struct mutex ispres_mutex; /* For checking/modifying res_inuse */
> +} ispres_obj;
> +
> +/* Structure for saving/restoring resizer module registers */
> +static struct isp_reg isprsz_reg_list[] = {
> +       {ISPRSZ_CNT, 0x0000},
> +       {ISPRSZ_OUT_SIZE, 0x0000},
> +       {ISPRSZ_IN_START, 0x0000},
> +       {ISPRSZ_IN_SIZE, 0x0000},
> +       {ISPRSZ_SDR_INADD, 0x0000},
> +       {ISPRSZ_SDR_INOFF, 0x0000},
> +       {ISPRSZ_SDR_OUTADD, 0x0000},
> +       {ISPRSZ_SDR_OUTOFF, 0x0000},
> +       {ISPRSZ_HFILT10, 0x0000},
> +       {ISPRSZ_HFILT32, 0x0000},
> +       {ISPRSZ_HFILT54, 0x0000},
> +       {ISPRSZ_HFILT76, 0x0000},
> +       {ISPRSZ_HFILT98, 0x0000},
> +       {ISPRSZ_HFILT1110, 0x0000},
> +       {ISPRSZ_HFILT1312, 0x0000},
> +       {ISPRSZ_HFILT1514, 0x0000},
> +       {ISPRSZ_HFILT1716, 0x0000},
> +       {ISPRSZ_HFILT1918, 0x0000},
> +       {ISPRSZ_HFILT2120, 0x0000},
> +       {ISPRSZ_HFILT2322, 0x0000},
> +       {ISPRSZ_HFILT2524, 0x0000},
> +       {ISPRSZ_HFILT2726, 0x0000},
> +       {ISPRSZ_HFILT2928, 0x0000},
> +       {ISPRSZ_HFILT3130, 0x0000},
> +       {ISPRSZ_VFILT10, 0x0000},
> +       {ISPRSZ_VFILT32, 0x0000},
> +       {ISPRSZ_VFILT54, 0x0000},
> +       {ISPRSZ_VFILT76, 0x0000},
> +       {ISPRSZ_VFILT98, 0x0000},
> +       {ISPRSZ_VFILT1110, 0x0000},
> +       {ISPRSZ_VFILT1312, 0x0000},
> +       {ISPRSZ_VFILT1514, 0x0000},
> +       {ISPRSZ_VFILT1716, 0x0000},
> +       {ISPRSZ_VFILT1918, 0x0000},
> +       {ISPRSZ_VFILT2120, 0x0000},
> +       {ISPRSZ_VFILT2322, 0x0000},
> +       {ISPRSZ_VFILT2524, 0x0000},
> +       {ISPRSZ_VFILT2726, 0x0000},
> +       {ISPRSZ_VFILT2928, 0x0000},
> +       {ISPRSZ_VFILT3130, 0x0000},
> +       {ISPRSZ_YENH, 0x0000},
> +       {ISP_TOK_TERM, 0x0000}
> +};
> +
> +/**
> + * ispresizer_config_shadow_registers - Configure shadow registers.
> + **/
> +void ispresizer_config_shadow_registers()
> +{
> +       return;
> +}
> +EXPORT_SYMBOL(ispresizer_config_shadow_registers);
> +
> +/**
> + * ispresizer_trycrop - Validate crop dimensions.
> + * @left: Left distance to start position of crop.
> + * @top: Top distance to start position of crop.
> + * @width: Width of input image.
> + * @height: Height of input image.
> + * @ow: Width of output image.
> + * @oh: Height of output image.
> + **/
> +void ispresizer_trycrop(u32 left, u32 top, u32 width, u32 height, u32 ow,
> +                                                                       u32 oh)
> +{
> +       ispres_obj.cropwidth = width + 6;
> +       ispres_obj.cropheight = height + 6;
> +       ispresizer_try_size(&ispres_obj.cropwidth, &ispres_obj.cropheight, &ow,
> +                                                                       &oh);
> +       ispres_obj.ipht_crop = top;
> +       ispres_obj.ipwd_crop = left;
> +}
> +EXPORT_SYMBOL(ispresizer_trycrop);
> +
> +/**
> + * ispresizer_applycrop - Apply crop to input image.
> + **/
> +void ispresizer_applycrop()
> +{
> +       ispresizer_config_size(ispres_obj.cropwidth, ispres_obj.cropheight,
> +                                               ispres_obj.outputwidth,
> +                                               ispres_obj.outputheight);
> +       return;
> +}
> +EXPORT_SYMBOL(ispresizer_applycrop);
> +
> +/**
> + * ispresizer_request - Reserves the Resizer module.
> + *
> + * Allows only one user at a time.
> + *
> + * Returns 0 if successful, or -EBUSY if resizer module was already requested.
> + **/
> +int ispresizer_request()
> +{
> +       mutex_lock(&ispres_obj.ispres_mutex);
> +       if (!ispres_obj.res_inuse) {
> +               ispres_obj.res_inuse = 1;
> +               mutex_unlock(&ispres_obj.ispres_mutex);
> +               omap_writel(omap_readl(ISP_CTRL) | ISPCTRL_SBL_WR0_RAM_EN |
> +                                               ISPCTRL_RSZ_CLK_EN, ISP_CTRL);
> +               return 0;
> +       } else {
> +               mutex_unlock(&ispres_obj.ispres_mutex);
> +               printk(KERN_ERR "ISP_ERR : Resizer Module Busy\n");
> +               return -EBUSY;
> +       }
> +}
> +EXPORT_SYMBOL(ispresizer_request);
> +
> +/**
> + * ispresizer_free - Makes Resizer module free.
> + *
> + * Returns 0 if successful, or -EINVAL if resizer module was already freed.
> + **/
> +int ispresizer_free()
> +{
> +       mutex_lock(&ispres_obj.ispres_mutex);
> +       if (ispres_obj.res_inuse) {
> +               ispres_obj.res_inuse = 0;
> +               mutex_unlock(&ispres_obj.ispres_mutex);
> +               omap_writel(omap_readl(ISP_CTRL) & ~(ISPCTRL_RSZ_CLK_EN |
> +                                       ISPCTRL_SBL_WR0_RAM_EN), ISP_CTRL);
> +               return 0;
> +       } else {
> +               mutex_unlock(&ispres_obj.ispres_mutex);
> +               DPRINTK_ISPRESZ("ISP_ERR : Resizer Module already freed\n");
> +               return -EINVAL;
> +       }
> +}
> +EXPORT_SYMBOL(ispresizer_free);
> +
> +/**
> + * ispresizer_config_datapath - Specifies which input to use in resizer module
> + * @input: Indicates the module that gives the image to resizer.
> + *
> + * Sets up the default resizer configuration according to the arguments.
> + *
> + * Returns 0 if successful, or -EINVAL if an unsupported input was requested.
> + **/
> +int ispresizer_config_datapath(enum ispresizer_input input)
> +{
> +       u32 cnt = 0;
> +       DPRINTK_ISPRESZ("ispresizer_config_datapath()+\n");
> +       ispres_obj.resinput = input;
> +       switch (input) {
> +       case RSZ_OTFLY_YUV:
> +               cnt &= ~ISPRSZ_CNT_INPTYP;
> +               cnt &= ~ISPRSZ_CNT_INPSRC;
> +               ispresizer_set_inaddr(0);
> +               ispresizer_config_inlineoffset(0);
> +               break;
> +       case RSZ_MEM_YUV:
> +               cnt |= ISPRSZ_CNT_INPSRC;
> +               cnt &= ~ISPRSZ_CNT_INPTYP;
> +               break;
> +       case RSZ_MEM_COL8:
> +               cnt |= ISPRSZ_CNT_INPSRC;
> +               cnt |= ISPRSZ_CNT_INPTYP;
> +               break;
> +       default:
> +               printk(KERN_ERR "ISP_ERR : Wrong Input\n");
> +               return -EINVAL;
> +       }
> +       omap_writel(omap_readl(ISPRSZ_CNT) | cnt, ISPRSZ_CNT);
> +       ispresizer_config_ycpos(0);
> +       ispresizer_config_filter_coef(&ispreszdefcoef);
> +       ispresizer_enable_cbilin(0);
> +       ispresizer_config_luma_enhance(&ispreszdefaultyenh);
> +       DPRINTK_ISPRESZ("ispresizer_config_datapath()-\n");
> +       return 0;
> +}
> +EXPORT_SYMBOL(ispresizer_config_datapath);
> +
> +/**
> + * ispresizer_try_size - Validates input and output images size.
> + * @input_w: input width for the resizer in number of pixels per line
> + * @input_h: input height for the resizer in number of lines
> + * @output_w: output width from the resizer in number of pixels per line
> + *            resizer when writing to memory needs this to be multiple of 16.
> + * @output_h: output height for the resizer in number of lines, must be even.
> + *
> + * Calculates the horizontal and vertical resize ratio, number of pixels to
> + * be cropped in the resizer module and checks the validity of various
> + * parameters. Formula used for calculation is:-
> + *
> + * 8-phase 4-tap mode :-
> + * inputwidth = (32 * sph + (ow - 1) * hrsz + 16) >> 8 + 7
> + * inputheight = (32 * spv + (oh - 1) * vrsz + 16) >> 8 + 4
> + * endpahse for width = ((32 * sph + (ow - 1) * hrsz + 16) >> 5) % 8
> + * endphase for height = ((32 * sph + (oh - 1) * hrsz + 16) >> 5) % 8
> + *
> + * 4-phase 7-tap mode :-
> + * inputwidth = (64 * sph + (ow - 1) * hrsz + 32) >> 8 + 7
> + * inputheight = (64 * spv + (oh - 1) * vrsz + 32) >> 8 + 7
> + * endpahse for width = ((64 * sph + (ow - 1) * hrsz + 32) >> 6) % 4
> + * endphase for height = ((64 * sph + (oh - 1) * hrsz + 32) >> 6) % 4
> + *
> + * Where:
> + * sph = Start phase horizontal
> + * spv = Start phase vertical
> + * ow = Output width
> + * oh = Output height
> + * hrsz = Horizontal resize value
> + * vrsz = Vertical resize value
> + *
> + * Fills up the output/input widht/height, horizontal/vertical resize ratio,
> + * horizontal/vertical crop variables in the isp_res structure.
> + **/
> +int ispresizer_try_size(u32 *input_width, u32 *input_height, u32 *output_w,
> +                                                               u32 *output_h)
> +{
> +       u32 rsz, rsz_7, rsz_4;
> +       u32 sph;
> +       u32 input_w, input_h;
> +       int max_in_otf, max_out_7tap;
> +       input_w = *input_width;
> +       input_h = *input_height;
> +
> +       if (input_w < 32 || input_h < 32) {
> +               DPRINTK_ISPCCDC("ISP_ERR: RESIZER cannot handle input width"
> +                               " less than 32 pixels or height less than"
> +                               " 32\n");
> +               return -EINVAL;
> +       }
> +       input_w -= 6;
> +       input_h -= 6;
> +
> +       if (input_h > MAX_IN_HEIGHT)
> +               return -EINVAL;
> +
> +       if (*output_w < 16)
> +               *output_w = 16;
> +
> +       if (*output_h < 2)
> +               *output_h = 2;
> +
> +       if (omap_rev() == OMAP3430_REV_ES1_0) {
> +               max_in_otf = MAX_IN_WIDTH_ONTHEFLY_MODE;
> +               max_out_7tap = MAX_7TAP_VRSZ_OUTWIDTH;
> +       } else {
> +               max_in_otf = MAX_IN_WIDTH_ONTHEFLY_MODE_ES2;
> +               max_out_7tap = MAX_7TAP_VRSZ_OUTWIDTH_ES2;
> +       }
> +
> +       if (ispres_obj.resinput == RSZ_OTFLY_YUV) {
> +               if (input_w > max_in_otf)
> +                       return -EINVAL;
> +       } else {
> +               if (input_w > MAX_IN_WIDTH_MEMORY_MODE)
> +                       return -EINVAL;
> +       }
> +
> +       *output_h &= 0xfffffffe;
> +       sph = DEFAULTSTPHASE;
> +
> +       rsz_7 = ((input_h - 7) * 256) / (*output_h - 1);
> +       rsz_4 = ((input_h - 4) * 256) / (*output_h - 1);
> +
> +       rsz = (input_h * 256) / *output_h;
> +
> +       if (rsz <= MID_RESIZE_VALUE) {
> +               rsz = rsz_4;
> +               if (rsz < MINIMUM_RESIZE_VALUE) {
> +                       rsz = MINIMUM_RESIZE_VALUE;
> +                       *output_h = (((input_h - 4) * 256) / rsz) + 1;
> +                       printk(KERN_INFO "%s: using output_h %d instead\n",
> +                                                       __func__, *output_h);
> +               }
> +       } else {
> +               rsz = rsz_7;
> +               if (*output_w > max_out_7tap)
> +                       *output_w = max_out_7tap;
> +               if (rsz > MAXIMUM_RESIZE_VALUE) {
> +                       rsz = MAXIMUM_RESIZE_VALUE;
> +                       *output_h = (((input_h - 7) * 256) / rsz) + 1;
> +                       printk(KERN_INFO "%s: using output_h %d instead\n",
> +                                                       __func__, *output_h);
> +               }
> +       }
> +
> +       if (rsz > MID_RESIZE_VALUE) {
> +               input_h =
> +                       (((64 * sph) + ((*output_h - 1) * rsz) + 32) / 256) + 7;
> +       } else {
> +               input_h =
> +                       (((32 * sph) + ((*output_h - 1) * rsz) + 16) / 256) + 4;
> +       }
> +
> +       ispres_obj.outputheight = *output_h;
> +       ispres_obj.v_resz = rsz;
> +       ispres_obj.inputheight = input_h;
> +       ispres_obj.ipht_crop = DEFAULTSTPIXEL;
> +       ispres_obj.v_startphase = sph;
> +
> +       *output_w &= 0xfffffff0;
> +       sph = DEFAULTSTPHASE;
> +
> +       rsz_7 = ((input_w - 7) * 256) / (*output_w - 1);
> +       rsz_4 = ((input_w - 4) * 256) / (*output_w - 1);
> +
> +       rsz = (input_w * 256) / *output_w;
> +       if (rsz > MID_RESIZE_VALUE) {
> +               rsz = rsz_7;
> +               if (rsz > MAXIMUM_RESIZE_VALUE) {
> +                       rsz = MAXIMUM_RESIZE_VALUE;
> +                       *output_w = (((input_w - 7) * 256) / rsz) + 1;
> +                       *output_w = (*output_w + 0xf) & 0xfffffff0;
> +                       printk(KERN_INFO "%s: using output_w %d instead\n",
> +                                                       __func__, *output_w);
> +               }
> +       } else {
> +               rsz = rsz_4;
> +               if (rsz < MINIMUM_RESIZE_VALUE) {
> +                       rsz = MINIMUM_RESIZE_VALUE;
> +                       *output_w = (((input_w - 4) * 256) / rsz) + 1;
> +                       *output_w = (*output_w + 0xf) & 0xfffffff0;
> +                       printk(KERN_INFO "%s: using output_w %d instead\n",
> +                                                       __func__, *output_w);
> +               }
> +       }
> +
> +       /* Recalculate input based on TRM equations */
> +       if (rsz > MID_RESIZE_VALUE) {
> +               input_w =
> +                       (((64 * sph) + ((*output_w - 1) * rsz) + 32) / 256) + 7;
> +       } else {
> +               input_w =
> +                       (((32 * sph) + ((*output_w - 1) * rsz) + 16) / 256) + 7;
> +       }
> +
> +       ispres_obj.outputwidth = *output_w;
> +       ispres_obj.h_resz = rsz;
> +       ispres_obj.inputwidth = input_w;
> +       ispres_obj.ipwd_crop = DEFAULTSTPIXEL;
> +       ispres_obj.h_startphase = sph;
> +
> +       *input_height = input_h;
> +       *input_width = input_w;
> +       return 0;
> +}
> +EXPORT_SYMBOL(ispresizer_try_size);
> +
> +/**
> + * ispresizer_config_size - Configures input and output image size.
> + * @input_w: input width for the resizer in number of pixels per line.
> + * @input_h: input height for the resizer in number of lines.
> + * @output_w: output width from the resizer in number of pixels per line.
> + * @output_h: output height for the resizer in number of lines.
> + *
> + * Configures the appropriate values stored in the isp_res structure in the
> + * resizer registers.
> + *
> + * Returns 0 if successful, or -EINVAL if passed values haven't been verified
> + * with ispresizer_try_size() previously.
> + **/
> +int ispresizer_config_size(u32 input_w, u32 input_h, u32 output_w,
> +                                                               u32 output_h)
> +{
> +       int i, j;
> +       u32 res;
> +       DPRINTK_ISPRESZ("ispresizer_config_size()+, input_w = %d,input_h ="
> +                                               " %d, output_w = %d, output_h"
> +                                               " = %d,hresz = %d,vresz = %d,"
> +                                               " hcrop = %d, vcrop = %d,"
> +                                               " hstph = %d, vstph = %d\n",
> +                                               ispres_obj.inputwidth,
> +                                               ispres_obj.inputheight,
> +                                               ispres_obj.outputwidth,
> +                                               ispres_obj.outputheight,
> +                                               ispres_obj.h_resz,
> +                                               ispres_obj.v_resz,
> +                                               ispres_obj.ipwd_crop,
> +                                               ispres_obj.ipht_crop,
> +                                               ispres_obj.h_startphase,
> +                                               ispres_obj.v_startphase);
> +       if ((output_w != ispres_obj.outputwidth)
> +                               || (output_h != ispres_obj.outputheight)) {
> +               printk(KERN_ERR "Output parameters passed do not match the"
> +                                               " values calculated by the"
> +                                               " trysize passed w %d, h %d"
> +                                               " \n", output_w , output_h);
> +               return -EINVAL;
> +       }
> +
> +#if ISP_WORKAROUND
> +       buff_addr_lsc_wa = isp_buf_get();
> +       if (buff_addr_lsc_wa) {
> +               /* Set Resizer input address and offset adderss */
> +               ispresizer_set_inaddr(buff_addr_lsc_wa);
> +               ispresizer_config_inlineoffset(omap_readl(ISPPRV_WADD_OFFSET));
> +       }
> +#endif
> +
> +       res = omap_readl(ISPRSZ_CNT) & (~(ISPRSZ_CNT_HSTPH_MASK |
> +                                                       ISPRSZ_CNT_VSTPH_MASK));
> +       omap_writel(res | (ispres_obj.h_startphase << ISPRSZ_CNT_HSTPH_SHIFT) |
> +                                               (ispres_obj.v_startphase <<
> +                                               ISPRSZ_CNT_VSTPH_SHIFT),
> +                                               ISPRSZ_CNT);
> +#if ISP_WORKAROUND
> +       omap_writel((0x00 << ISPRSZ_IN_START_HORZ_ST_SHIFT) |
> +                                       (0x00 << ISPRSZ_IN_START_VERT_ST_SHIFT),
> +                                       ISPRSZ_IN_START);
> +
> +#else
> +       omap_writel(((ispres_obj.ipwd_crop * 2) <<
> +                                               ISPRSZ_IN_START_HORZ_ST_SHIFT) |
> +                                               (ispres_obj.ipht_crop <<
> +                                               ISPRSZ_IN_START_VERT_ST_SHIFT),
> +                                               ISPRSZ_IN_START);
> +#endif
> +
> +       omap_writel((ispres_obj.inputwidth << ISPRSZ_IN_SIZE_HORZ_SHIFT) |
> +                                               (ispres_obj.inputheight <<
> +                                               ISPRSZ_IN_SIZE_VERT_SHIFT),
> +                                               ISPRSZ_IN_SIZE);
> +       if (!ispres_obj.algo) {
> +               omap_writel((output_w << ISPRSZ_OUT_SIZE_HORZ_SHIFT) |
> +                                               (output_h <<
> +                                               ISPRSZ_OUT_SIZE_VERT_SHIFT),
> +                                               ISPRSZ_OUT_SIZE);
> +       } else {
> +               omap_writel(((output_w - 4) << ISPRSZ_OUT_SIZE_HORZ_SHIFT) |
> +                                               (output_h <<
> +                                               ISPRSZ_OUT_SIZE_VERT_SHIFT),
> +                                               ISPRSZ_OUT_SIZE);
> +       }
> +
> +       res = omap_readl(ISPRSZ_CNT) & (~(ISPRSZ_CNT_HRSZ_MASK |
> +                                               ISPRSZ_CNT_VRSZ_MASK));
> +       omap_writel(res | ((ispres_obj.h_resz - 1) << ISPRSZ_CNT_HRSZ_SHIFT) |
> +                                               ((ispres_obj.v_resz - 1) <<
> +                                               ISPRSZ_CNT_VRSZ_SHIFT),
> +                                               ISPRSZ_CNT);
> +       if (ispres_obj.h_resz <= MID_RESIZE_VALUE) {
> +               j = 0;
> +               for (i = 0; i < 16; i++) {
> +                       omap_writel((ispres_obj.coeflist.
> +                                               h_filter_coef_4tap[j] <<
> +                                               ISPRSZ_HFILT10_COEF0_SHIFT) |
> +                                               (ispres_obj.coeflist.
> +                                               h_filter_coef_4tap[j + 1] <<
> +                                               ISPRSZ_HFILT10_COEF1_SHIFT),
> +                                               ISPRSZ_HFILT10 + (i * 0x04));
> +                       j += 2;
> +               }
> +       } else {
> +               j = 0;
> +               for (i = 0; i < 16; i++) {
> +                       if ((i + 1) % 4 == 0) {
> +                               omap_writel((ispres_obj.coeflist.
> +                                               h_filter_coef_7tap[j] <<
> +                                               ISPRSZ_HFILT10_COEF0_SHIFT),
> +                                               ISPRSZ_HFILT10 + (i * 0x04));
> +                               j += 1;
> +                       } else {
> +                               omap_writel((ispres_obj.coeflist.
> +                                               h_filter_coef_7tap[j] <<
> +                                               ISPRSZ_HFILT10_COEF0_SHIFT) |
> +                                               (ispres_obj.coeflist.
> +                                               h_filter_coef_7tap[j+1] <<
> +                                               ISPRSZ_HFILT10_COEF1_SHIFT),
> +                                               ISPRSZ_HFILT10 + (i * 0x04));
> +                               j += 2;
> +                       }
> +               }
> +       }
> +       if (ispres_obj.v_resz <= MID_RESIZE_VALUE) {
> +               j = 0;
> +               for (i = 0; i < 16; i++) {
> +                       omap_writel((ispres_obj.coeflist.
> +                                               v_filter_coef_4tap[j] <<
> +                                               ISPRSZ_VFILT10_COEF0_SHIFT) |
> +                                               (ispres_obj.coeflist.
> +                                               v_filter_coef_4tap[j + 1] <<
> +                                               ISPRSZ_VFILT10_COEF1_SHIFT),
> +                                               ISPRSZ_VFILT10 + (i * 0x04));
> +                       j += 2;
> +               }
> +       } else {
> +               j = 0;
> +               for (i = 0; i < 16; i++) {
> +                       if ((i + 1) % 4 == 0) {
> +                               omap_writel((ispres_obj.coeflist.
> +                                               v_filter_coef_7tap[j] <<
> +                                               ISPRSZ_VFILT10_COEF0_SHIFT),
> +                                               ISPRSZ_VFILT10 + (i * 0x04));
> +                               j += 1;
> +                       } else {
> +                               omap_writel((ispres_obj.coeflist.
> +                                               v_filter_coef_7tap[j] <<
> +                                               ISPRSZ_VFILT10_COEF0_SHIFT) |
> +                                               (ispres_obj.coeflist.
> +                                               v_filter_coef_7tap[j+1] <<
> +                                               ISPRSZ_VFILT10_COEF1_SHIFT),
> +                                               ISPRSZ_VFILT10 + (i * 0x04));
> +                               j += 2;
> +                       }
> +               }
> +       }
> +
> +       ispresizer_config_outlineoffset(output_w*2);
> +       DPRINTK_ISPRESZ("ispresizer_config_size()-\n");
> +       return 0;
> +}
> +EXPORT_SYMBOL(ispresizer_config_size);
> +
> +/**
> + * ispresizer_enable - Enables the resizer module.
> + * @enable: 1 - Enable, 0 - Disable
> + *
> + * Client should configure all the sub modules in resizer before this.
> + **/
> +void ispresizer_enable(u8 enable)
> +{
> +       int val;
> +       DPRINTK_ISPRESZ("+ispresizer_enable()+\n");
> +       if (enable)
> +               val = (((omap_readl(ISPRSZ_PCR)) & 0x2) | ISPRSZ_PCR_ENABLE);
> +       else
> +               val = (omap_readl(ISPRSZ_PCR) & ~ISPRSZ_PCR_ENABLE);
> +       omap_writel(val, ISPRSZ_PCR);
> +       DPRINTK_ISPRESZ("+ispresizer_enable()-\n");
> +}
> +EXPORT_SYMBOL(ispresizer_enable);
> +
> +/**
> + * ispresizer_busy - Checks if ISP resizer is busy.
> + *
> + * Returns busy field from ISPRSZ_PCR register.
> + **/
> +int ispresizer_busy(void)
> +{
> +       return omap_readl(ISPRSZ_PCR) & ISPPRV_PCR_BUSY;
> +}
> +EXPORT_SYMBOL(ispresizer_busy);
> +
> +/**
> + * ispresizer_config_startphase - Sets the horizontal and vertical start phase.
> + * @hstartphase: horizontal start phase (0 - 7).
> + * @vstartphase: vertical startphase (0 - 7).
> + *
> + * This API just updates the isp_res struct. Actual register write happens in
> + * ispresizer_config_size.
> + **/
> +void ispresizer_config_startphase(u8 hstartphase, u8 vstartphase)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_config_startphase()+\n");
> +       ispres_obj.h_startphase = hstartphase;
> +       ispres_obj.v_startphase = vstartphase;
> +       DPRINTK_ISPRESZ("ispresizer_config_startphase()-\n");
> +}
> +EXPORT_SYMBOL(ispresizer_config_startphase);
> +
> +/**
> + * ispresizer_config_ycpos - Specifies if output should be in YC or CY format.
> + * @yc: 0 - YC format, 1 - CY format
> + **/
> +void ispresizer_config_ycpos(u8 yc)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_config_ycpos()+\n");
> +       if (yc) {
> +               omap_writel((omap_readl(ISPRSZ_CNT)) |
> +                                       (ISPRSZ_CNT_YCPOS), ISPRSZ_CNT);
> +       } else {
> +               omap_writel((omap_readl(ISPRSZ_CNT)) &
> +                                       (~ISPRSZ_CNT_YCPOS), ISPRSZ_CNT);
> +       }
> +       DPRINTK_ISPRESZ("ispresizer_config_ycpos()-\n");
> +}
> +EXPORT_SYMBOL(ispresizer_config_ycpos);
> +
> +/**
> + * Sets the chrominance algorithm
> + * @cbilin: 0 - chrominance uses same processing as luminance,
> + *          1 - bilinear interpolation processing
> + **/
> +void ispresizer_enable_cbilin(u8 enable)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_enable_cbilin()+\n");
> +       if (enable) {
> +               omap_writel(omap_readl(ISPRSZ_CNT) | ISPRSZ_CNT_CBILIN,
> +                                                               ISPRSZ_CNT);
> +       } else {
> +               omap_writel(omap_readl(ISPRSZ_CNT) & ~ISPRSZ_CNT_CBILIN,
> +                                                               ISPRSZ_CNT);
> +       }
> +       DPRINTK_ISPRESZ("ispresizer_enable_cbilin()-\n");
> +}
> +EXPORT_SYMBOL(ispresizer_enable_cbilin);
> +
> +/**
> + * ispresizer_config_luma_enhance - Configures luminance enhancer parameters.
> + * @yenh: Pointer to structure containing desired values for core, slope, gain
> + *        and algo parameters.
> + **/
> +void ispresizer_config_luma_enhance(struct isprsz_yenh *yenh)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_config_luma_enhance()+\n");
> +       ispres_obj.algo = yenh->algo;
> +       omap_writel((yenh->algo << ISPRSZ_YENH_ALGO_SHIFT) |
> +                               (yenh->gain << ISPRSZ_YENH_GAIN_SHIFT) |
> +                               (yenh->slope << ISPRSZ_YENH_SLOP_SHIFT) |
> +                               (yenh->coreoffset << ISPRSZ_YENH_CORE_SHIFT),
> +                               ISPRSZ_YENH);
> +       DPRINTK_ISPRESZ("ispresizer_config_luma_enhance()-\n");
> +}
> +EXPORT_SYMBOL(ispresizer_config_luma_enhance);
> +
> +/**
> + * ispresizer_config_filter_coef - Sets filter coefficients for 4 & 7-tap mode.
> + * This API just updates the isp_res struct.Actual register write happens in
> + * ispresizer_config_size.
> + * @coef: Structure containing horizontal and vertical filter coefficients for
> + *        both 4-tap and 7-tap mode.
> + **/
> +void ispresizer_config_filter_coef(struct isprsz_coef *coef)
> +{
> +       int i;
> +       DPRINTK_ISPRESZ("ispresizer_config_filter_coef()+\n");
> +       for (i = 0; i < 32; i++) {
> +               ispres_obj.coeflist.h_filter_coef_4tap[i] =
> +                                               coef->h_filter_coef_4tap[i];
> +               ispres_obj.coeflist.v_filter_coef_4tap[i] =
> +                                               coef->v_filter_coef_4tap[i];
> +       }
> +       for (i = 0; i < 28; i++) {
> +               ispres_obj.coeflist.h_filter_coef_7tap[i] =
> +                                               coef->h_filter_coef_7tap[i];
> +               ispres_obj.coeflist.v_filter_coef_7tap[i] =
> +                                               coef->v_filter_coef_7tap[i];
> +       }
> +       DPRINTK_ISPRESZ("ispresizer_config_filter_coef()-\n");
> +}
> +EXPORT_SYMBOL(ispresizer_config_filter_coef);
> +
> +/**
> + * ispresizer_config_inlineoffset - Configures the read address line offset.
> + * @offset: Line Offset for the input image.
> + *
> + * Returns 0 if successful, or -EINVAL if offset is not 32 bits aligned.
> + **/
> +int ispresizer_config_inlineoffset(u32 offset)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_config_inlineoffset()+\n");
> +       if (offset % 32)
> +               return -EINVAL;
> +       omap_writel(offset << ISPRSZ_SDR_INOFF_OFFSET_SHIFT, ISPRSZ_SDR_INOFF);
> +       DPRINTK_ISPRESZ("ispresizer_config_inlineoffset()-\n");
> +       return 0;
> +}
> +EXPORT_SYMBOL(ispresizer_config_inlineoffset);
> +
> +/**
> + * ispresizer_set_inaddr - Sets the memory address of the input frame.
> + * @addr: 32bit memory address aligned on 32byte boundary.
> + *
> + * Returns 0 if successful, or -EINVAL if address is not 32 bits aligned.
> + **/
> +int ispresizer_set_inaddr(u32 addr)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_set_inaddr()+\n");
> +       if (addr % 32)
> +               return -EINVAL;
> +       omap_writel(addr << ISPRSZ_SDR_INADD_ADDR_SHIFT, ISPRSZ_SDR_INADD);
> +       DPRINTK_ISPRESZ("ispresizer_set_inaddr()-\n");
> +       return 0;
> +}
> +EXPORT_SYMBOL(ispresizer_set_inaddr);
> +
> +/**
> + * ispresizer_config_outlineoffset - Configures the write address line offset.
> + * @offset: Line offset for the preview output.
> + *
> + * Returns 0 if successful, or -EINVAL if address is not 32 bits aligned.
> + **/
> +int ispresizer_config_outlineoffset(u32 offset)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_config_outlineoffset()+\n");
> +       if (offset % 32)
> +               return -EINVAL;
> +       omap_writel(offset << ISPRSZ_SDR_OUTOFF_OFFSET_SHIFT,
> +                                                       ISPRSZ_SDR_OUTOFF);
> +       DPRINTK_ISPRESZ("ispresizer_config_outlineoffset()-\n");
> +       return 0;
> +}
> +EXPORT_SYMBOL(ispresizer_config_outlineoffset);
> +
> +/**
> + * Configures the memory address to which the output frame is written.
> + * @addr: 32bit memory address aligned on 32byte boundary.
> + **/
> +int ispresizer_set_outaddr(u32 addr)
> +{
> +       DPRINTK_ISPRESZ("ispresizer_set_outaddr()+\n");
> +       if (addr % 32)
> +               return -EINVAL;
> +       omap_writel(addr << ISPRSZ_SDR_OUTADD_ADDR_SHIFT, ISPRSZ_SDR_OUTADD);
> +       DPRINTK_ISPRESZ("ispresizer_set_outaddr()-\n");
> +       return 0;
> +}
> +EXPORT_SYMBOL(ispresizer_set_outaddr);
> +
> +/**
> + * ispresizer_save_context - Saves the values of the resizer module registers.
> + **/
> +void ispresizer_save_context(void)
> +{
> +       DPRINTK_ISPRESZ("Saving context\n");
> +       isp_save_context(isprsz_reg_list);
> +}
> +EXPORT_SYMBOL(ispresizer_save_context);
> +
> +/**
> + * ispresizer_restore_context - Restores resizer module register values.
> + **/
> +void ispresizer_restore_context(void)
> +{
> +       DPRINTK_ISPRESZ("Restoring context\n");
> +       isp_restore_context(isprsz_reg_list);
> +}
> +EXPORT_SYMBOL(ispresizer_restore_context);
> +
> +/**
> + * ispresizer_print_status - Prints the values of the resizer module registers.
> + **/
> +void ispresizer_print_status()
> +{
> +       if (!is_ispresz_debug_enabled())
> +               return;
> +       DPRINTK_ISPRESZ("###ISP_CTRL inresizer =0x%x\n", omap_readl(ISP_CTRL));
> +
> +       DPRINTK_ISPRESZ("###ISP_IRQ0ENABLE in resizer =0x%x\n",
> +                                               omap_readl(ISP_IRQ0ENABLE));
> +       DPRINTK_ISPRESZ("###ISP_IRQ0STATUS in resizer =0x%x\n",
> +                                               omap_readl(ISP_IRQ0STATUS));
> +       DPRINTK_ISPRESZ("###RSZ PCR =0x%x\n", omap_readl(ISPRSZ_PCR));
> +       DPRINTK_ISPRESZ("###RSZ CNT =0x%x\n", omap_readl(ISPRSZ_CNT));
> +       DPRINTK_ISPRESZ("###RSZ OUT SIZE =0x%x\n",
> +                                               omap_readl(ISPRSZ_OUT_SIZE));
> +       DPRINTK_ISPRESZ("###RSZ IN START =0x%x\n",
> +                                               omap_readl(ISPRSZ_IN_START));
> +       DPRINTK_ISPRESZ("###RSZ IN SIZE =0x%x\n", omap_readl(ISPRSZ_IN_SIZE));
> +       DPRINTK_ISPRESZ("###RSZ SDR INADD =0x%x\n",
> +                                               omap_readl(ISPRSZ_SDR_INADD));
> +       DPRINTK_ISPRESZ("###RSZ SDR INOFF =0x%x\n",
> +                                               omap_readl(ISPRSZ_SDR_INOFF));
> +       DPRINTK_ISPRESZ("###RSZ SDR OUTADD =0x%x\n",
> +                                               omap_readl(ISPRSZ_SDR_OUTADD));
> +       DPRINTK_ISPRESZ("###RSZ SDR OTOFF =0x%x\n",
> +                                               omap_readl(ISPRSZ_SDR_OUTOFF));
> +       DPRINTK_ISPRESZ("###RSZ YENH =0x%x\n", omap_readl(ISPRSZ_YENH));
> +}
> +EXPORT_SYMBOL(ispresizer_print_status);
> +
> +/**
> + * isp_resizer_init - Module Initialisation.
> + *
> + * Always returns 0.
> + **/
> +int __init isp_resizer_init(void)
> +{
> +       mutex_init(&ispres_obj.ispres_mutex);
> +       return 0;
> +}
> +
> +/**
> + * isp_resizer_cleanup - Module Cleanup.
> + **/
> +void __exit isp_resizer_cleanup(void)
> +{
> +}
> diff --git a/drivers/media/video/isp/ispresizer.h b/drivers/media/video/isp/ispresizer.h
> new file mode 100644
> index 0000000..cd447ea
> --- /dev/null
> +++ b/drivers/media/video/isp/ispresizer.h
> @@ -0,0 +1,153 @@
> +/*
> + * drivers/media/video/isp/ispresizer.h
> + *
> + * Driver header file for Resizer module in TI's OMAP3 Camera ISP
> + *
> + * Copyright (C) 2008 Texas Instruments, Inc.
> + *
> + * Contributors:
> + *     Sameer Venkatraman <sameerv@ti.com>
> + *     Mohit Jalori
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
> +#ifndef OMAP_ISP_RESIZER_H
> +#define OMAP_ISP_RESIZER_H
> +
> +/*
> + * Resizer Constants
> + */
> +#define MAX_IN_WIDTH_MEMORY_MODE       4095
> +
> +#define MAX_IN_WIDTH_ONTHEFLY_MODE     1280
> +#define MAX_IN_WIDTH_ONTHEFLY_MODE_ES2 4095
> +#define MAX_IN_HEIGHT                  4095
> +#define MINIMUM_RESIZE_VALUE           64
> +#define MAXIMUM_RESIZE_VALUE           1024
> +#define MID_RESIZE_VALUE               512
> +
> +#define MAX_7TAP_HRSZ_OUTWIDTH         1280
> +#define MAX_7TAP_VRSZ_OUTWIDTH         640
> +
> +#define MAX_7TAP_HRSZ_OUTWIDTH_ES2     3300
> +#define MAX_7TAP_VRSZ_OUTWIDTH_ES2     1650
> +
> +#define DEFAULTSTPIXEL                 0
> +#define DEFAULTSTPHASE                 1
> +#define DEFAULTHSTPIXEL4TAPMODE                3
> +#define FOURPHASE                      4
> +#define EIGHTPHASE                     8
> +#define RESIZECONSTANT                 256
> +#define SHIFTER4TAPMODE                        0
> +#define SHIFTER7TAPMODE                        1
> +#define DEFAULTOFFSET                  7
> +#define OFFSETVERT4TAPMODE             4
> +#define OPWDALIGNCONSTANT              0xFFFFFFF0
> +
> +/*
> + * The client is supposed to call resizer API in the following sequence:
> + *     - request()
> + *     - config_datatpath()
> + *     - optionally config/enable sub modules
> + *     - try/config size
> + *     - setup callback
> + *     - setup in/out memory offsets and ptrs
> + *     - enable()
> + *     ...
> + *     - disable()
> + *     - free()
> + */
> +
> +enum ispresizer_input {
> +       RSZ_OTFLY_YUV,
> +       RSZ_MEM_YUV,
> +       RSZ_MEM_COL8
> +};
> +
> +/**
> + * struct isprsz_coef - Structure for resizer filter coeffcients.
> + * @h_filter_coef_4tap: Horizontal filter coefficients for 8-phase/4-tap
> + *                     mode (.5x-4x)
> + * @v_filter_coef_4tap: Vertical filter coefficients for 8-phase/4-tap
> + *                     mode (.5x-4x)
> + * @h_filter_coef_7tap: Horizontal filter coefficients for 4-phase/7-tap
> + *                     mode (.25x-.5x)
> + * @v_filter_coef_7tap: Vertical filter coefficients for 4-phase/7-tap
> + *                     mode (.25x-.5x)
> + */
> +struct isprsz_coef {
> +       u16 h_filter_coef_4tap[32];
> +       u16 v_filter_coef_4tap[32];
> +       u16 h_filter_coef_7tap[28];
> +       u16 v_filter_coef_7tap[28];
> +};
> +
> +/**
> + * struct isprsz_yenh - Structure for resizer luminance enhancer parameters.
> + * @algo: Algorithm select.
> + * @gain: Maximum gain.
> + * @slope: Slope.
> + * @coreoffset: Coring offset.
> + */
> +struct isprsz_yenh {
> +       u8 algo;
> +       u8 gain;
> +       u8 slope;
> +       u8 coreoffset;
> +};
> +
> +void ispresizer_config_shadow_registers(void);
> +
> +int ispresizer_request(void);
> +
> +int ispresizer_free(void);
> +
> +int ispresizer_config_datapath(enum ispresizer_input input);
> +
> +void ispresizer_enable_cbilin(u8 enable);
> +
> +void ispresizer_config_ycpos(u8 yc);
> +
> +void ispresizer_config_startphase(u8 hstartphase, u8 vstartphase);
> +
> +void ispresizer_config_filter_coef(struct isprsz_coef *coef);
> +
> +void ispresizer_config_luma_enhance(struct isprsz_yenh *yenh);
> +
> +int ispresizer_try_size(u32 *input_w, u32 *input_h, u32 *output_w,
> +                                                               u32 *output_h);
> +
> +void ispresizer_applycrop(void);
> +
> +void ispresizer_trycrop(u32 left, u32 top, u32 width, u32 height, u32 ow,
> +                                                               u32 oh);
> +
> +int ispresizer_config_size(u32 input_w, u32 input_h, u32 output_w,
> +                                                               u32 output_h);
> +
> +int ispresizer_config_inlineoffset(u32 offset);
> +
> +int ispresizer_set_inaddr(u32 addr);
> +
> +int ispresizer_config_outlineoffset(u32 offset);
> +
> +int ispresizer_set_outaddr(u32 addr);
> +
> +void ispresizer_enable(u8 enable);
> +
> +int ispresizer_busy(void);
> +
> +void ispresizer_save_context(void);
> +
> +void ispresizer_restore_context(void);
> +
> +void ispresizer_print_status(void);
> +
> +#endif         /* OMAP_ISP_RESIZER_H */
> --
> 1.5.6.5
> 
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
