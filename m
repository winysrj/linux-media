Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:65004 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZAMLvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 06:51:45 -0500
MIME-Version: 1.0
In-Reply-To: <A24693684029E5489D1D202277BE894416429F9C@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894416429F9C@dlee02.ent.ti.com>
Date: Tue, 13 Jan 2009 17:21:44 +0530
Message-ID: <5d5443650901130351n6999044eh2e7b5fe958f385cc@mail.gmail.com>
Subject: Re: [REVIEW PATCH 06/14] OMAP: CAM: Add ISP Back end
From: Trilok Soni <soni.trilok@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

> +
> +/* Saved parameters */
> +struct prev_params *prev_config_params;
> +

static?

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

Do want this as table format only can be done like request_firmware?

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

Unnecessary casting. Please remove all the casts when source is void *.

> +
> +       if (ISP_ABS_PREV_LUMAENH & preview_struct->flag) {
> +               if (ISP_ABS_PREV_LUMAENH & preview_struct->update) {
> +                       if (copy_from_user(yen_t, preview_struct->yen,
> +                                                               sizeof(yen_t)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_luma_enhancement(yen_t);
> +               }
> +               params->features |= PREV_LUMA_ENHANCE;
> +       } else if (ISP_ABS_PREV_LUMAENH & preview_struct->update)
> +                       params->features &= ~PREV_LUMA_ENHANCE;
> +
> +       if (ISP_ABS_PREV_INVALAW & preview_struct->flag) {
> +               isppreview_enable_invalaw(1);
> +               params->features |= PREV_INVERSE_ALAW;
> +       } else {
> +               isppreview_enable_invalaw(0);
> +               params->features &= ~PREV_INVERSE_ALAW;
> +       }
> +
> +       if (ISP_ABS_PREV_HRZ_MED & preview_struct->flag) {
> +               if (ISP_ABS_PREV_HRZ_MED & preview_struct->update) {
> +                       if (copy_from_user(&prev_hmed_t,
> +                                               (struct ispprev_hmed *)
> +                                               preview_struct->prev_hmed,
> +                                               sizeof(struct ispprev_hmed)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_hmed(prev_hmed_t);
> +               }
> +               isppreview_enable_hmed(1);
> +               params->features |= PREV_HORZ_MEDIAN_FILTER;
> +       } else if (ISP_ABS_PREV_HRZ_MED & preview_struct->update) {
> +               isppreview_enable_hmed(0);
> +               params->features &= ~PREV_HORZ_MEDIAN_FILTER;
> +       }
> +
> +       if (ISP_ABS_PREV_CFA & preview_struct->flag) {
> +               if (ISP_ABS_PREV_CFA & preview_struct->update) {
> +                       if (copy_from_user(&prev_cfa_t,
> +                                               (struct ispprev_cfa *)
> +                                               preview_struct->prev_cfa,
> +                                               sizeof(struct ispprev_cfa)))
> +                               goto err_copy_from_user;
> +
> +                       isppreview_config_cfa(prev_cfa_t);
> +               }
> +               isppreview_enable_cfa(1);
> +               params->features |= PREV_CFA;
> +       } else if (ISP_ABS_PREV_CFA & preview_struct->update) {
> +               isppreview_enable_cfa(0);
> +               params->features &= ~PREV_CFA;
> +       }
> +
> +       if (ISP_ABS_PREV_CHROMA_SUPP & preview_struct->flag) {
> +               if (ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) {
> +                       if (copy_from_user(&csup_t,
> +                                               (struct ispprev_csup *)
> +                                               preview_struct->csup,
> +                                               sizeof(struct ispprev_csup)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_chroma_suppression(csup_t);
> +               }
> +               isppreview_enable_chroma_suppression(1);
> +               params->features |= PREV_CHROMA_SUPPRESS;
> +       } else if (ISP_ABS_PREV_CHROMA_SUPP & preview_struct->update) {
> +               isppreview_enable_chroma_suppression(0);
> +               params->features &= ~PREV_CHROMA_SUPPRESS;
> +       }
> +
> +       if (ISP_ABS_PREV_WB & preview_struct->update) {
> +               if (copy_from_user(&prev_wbal_t, (struct ispprev_wbal *)
> +                                               preview_struct->prev_wbal,
> +                                               sizeof(struct ispprev_wbal)))
> +                       goto err_copy_from_user;
> +               isppreview_config_whitebalance(prev_wbal_t);
> +       }
> +
> +       if (ISP_ABS_PREV_BLKADJ & preview_struct->update) {
> +               if (copy_from_user(&prev_blkadj_t, (struct ispprev_blkadjl *)
> +                                       preview_struct->prev_blkadj,
> +                                       sizeof(struct ispprev_blkadj)))
> +                       goto err_copy_from_user;
> +               isppreview_config_blkadj(prev_blkadj_t);
> +       }
> +
> +       if (ISP_ABS_PREV_RGB2RGB & preview_struct->update) {
> +               if (copy_from_user(&rgb2rgb_t, (struct ispprev_rgbtorgb *)
> +                                       preview_struct->rgb2rgb,
> +                                       sizeof(struct ispprev_rgbtorgb)))
> +                       goto err_copy_from_user;
> +               isppreview_config_rgb_blending(rgb2rgb_t);
> +       }
> +
> +       if (ISP_ABS_PREV_COLOR_CONV & preview_struct->update) {
> +               if (copy_from_user(&prev_csc_t, (struct ispprev_csc *)
> +                                               preview_struct->prev_csc,
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
> +       if (ISP_ABS_PREV_YC_LIMIT & preview_struct->update) {
> +               if (copy_from_user(&yclimit_t, (struct ispprev_yclimit *)
> +                                       preview_struct->yclimit,
> +                                       sizeof(struct ispprev_yclimit)))
> +                       goto err_copy_from_user;
> +               isppreview_config_yc_range(yclimit_t);
> +       }
> +
> +       if (ISP_ABS_PREV_DEFECT_COR & preview_struct->flag) {
> +               if (ISP_ABS_PREV_DEFECT_COR & preview_struct->update) {
> +                       if (copy_from_user(&prev_dcor_t,
> +                                               (struct ispprev_dcor *)
> +                                               preview_struct->prev_dcor,
> +                                               sizeof(struct ispprev_dcor)))
> +                               goto err_copy_from_user;
> +                       isppreview_config_dcor(prev_dcor_t);
> +               }
> +               isppreview_enable_dcor(1);
> +               params->features |= PREV_DEFECT_COR;
> +       } else if (ISP_ABS_PREV_DEFECT_COR & preview_struct->update) {
> +               isppreview_enable_dcor(0);
> +               params->features &= ~PREV_DEFECT_COR;
> +       }
> +
> +       if (ISP_ABS_PREV_GAMMABYPASS & preview_struct->flag) {
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


This function is really big and hard to review, I am sure there will
be way to break-down into smaller functions as per functionality.

> +
> +       return 0;
> +
> +err_copy_from_user:
> +       printk(KERN_ERR "Preview Config: Copy From User Error");
> +       return -EINVAL;

This should be -EFAULT.

> +}
> +EXPORT_SYMBOL(omap34xx_isp_preview_config);

If possible, please convert all the EXPORT_SYMBOLs to EXPORT_SYMBOL_GPL.

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
> +       if (ISP_ABS_TBL_NF & isptables_struct->flag) {
> +               NF_enable = 1;

CamelCAseS not allowed. Please remove them from all places.

> +               params->features |= PREV_NOISE_FILTER;
> +               if (ISP_ABS_TBL_NF & isptables_struct->update) {
> +                       if (copy_from_user(&prev_nf_t, (struct ispprev_nf *)
> +                                               isptables_struct->prev_nf,
> +                                               sizeof(struct ispprev_nf)))
> +                               goto err_copy_from_user;
> +
> +                       spin_lock(&ispprev_obj.ispprev_lock);
> +                       if (!ispprev_obj.stream_on) {
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
> +               params->features &= ~PREV_NOISE_FILTER;
> +               if (ISP_ABS_TBL_NF & isptables_struct->update)
> +                       NF_update = 1;
> +               else
> +                       NF_update = 0;
> +       }
> +
> +       if (ISP_ABS_TBL_REDGAMMA & isptables_struct->update) {
> +               if (copy_from_user(redgamma_table, isptables_struct->red_gamma,
> +                                               sizeof(redgamma_table))) {
> +                       goto err_copy_from_user;
> +               }
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               if (!ispprev_obj.stream_on) {
> +                       RG_update = 0;
> +                       isp_reg_writel(ISPPRV_TBL_ADDR_RED_G_START,
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> +                       for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                               isp_reg_writel(redgamma_table[ctr],
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> +               } else
> +                       RG_update = 1;
> +
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +       } else
> +               RG_update = 0;
> +
> +       if (ISP_ABS_TBL_GREENGAMMA & isptables_struct->update) {
> +               if (copy_from_user(greengamma_table,
> +                                               isptables_struct->green_gamma,
> +                                               sizeof(greengamma_table)))
> +                       goto err_copy_from_user;
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               if (!ispprev_obj.stream_on) {
> +                       GG_update = 0;
> +                       isp_reg_writel(ISPPRV_TBL_ADDR_GREEN_G_START,
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> +                       for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                               isp_reg_writel(greengamma_table[ctr],
> +                                               OMAP3_ISP_IOMEM_PREV,
> +                                               ISPPRV_SET_TBL_DATA);
> +               } else
> +                       GG_update = 1;
> +
> +               spin_unlock(&ispprev_obj.ispprev_lock);
> +       } else
> +               GG_update = 0;
> +
> +       if (ISP_ABS_TBL_BLUEGAMMA & isptables_struct->update) {
> +               if (copy_from_user(bluegamma_table,
> +                                       isptables_struct->blue_gamma,
> +                                       sizeof(bluegamma_table))) {
> +                       goto err_copy_from_user;
> +               }
> +               spin_lock(&ispprev_obj.ispprev_lock);
> +               if (!ispprev_obj.stream_on) {
> +                       BG_update = 0;
> +                       isp_reg_writel(ISPPRV_TBL_ADDR_BLUE_G_START,
> +                                       OMAP3_ISP_IOMEM_PREV,
> +                                       ISPPRV_SET_TBL_ADDR);
> +                       for (ctr = 0; ctr < ISP_GAMMA_TABLE_SIZE; ctr++)
> +                               isp_reg_writel(bluegamma_table[ctr],
> +                                               OMAP3_ISP_IOMEM_PREV,
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

-EFAULT please.

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
> +       isp_reg_writel(prev_nf.spread, OMAP3_ISP_IOMEM_PREV, ISPPRV_NF);
> +       isp_reg_writel(ISPPRV_NF_TABLE_ADDR, OMAP3_ISP_IOMEM_PREV,
> +                                                       ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 64; i++) {

What is 64 here?

> +               isp_reg_writel(prev_nf.table[i], OMAP3_ISP_IOMEM_PREV,
> +                                                       ISPPRV_SET_TBL_DATA);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_config_noisefilter);
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
> +       isp_reg_or(OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> +                               (prev_cfa.cfafmt << ISPPRV_PCR_CFAFMT_SHIFT));
> +
> +       isp_reg_writel(
> +               (prev_cfa.cfa_gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> +               (prev_cfa.cfa_gradthrs_horz << ISPPRV_CFA_GRADTH_HOR_SHIFT),
> +               OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA);
> +
> +       isp_reg_writel(ISPPRV_CFA_TABLE_ADDR, OMAP3_ISP_IOMEM_PREV,
> +                                                       ISPPRV_SET_TBL_ADDR);
> +
> +       for (i = 0; i < 576; i++) {

Ditto.

> +               isp_reg_writel(prev_cfa.cfa_table[i],
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> +       }
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
> +       isp_reg_writel(ISPPRV_REDGAMMA_TABLE_ADDR,
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 1024; i++) {

Ditto.

> +               isp_reg_writel(gtable.redtable[i],
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> +       }
> +
> +       isp_reg_writel(ISPPRV_GREENGAMMA_TABLE_ADDR,
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 1024; i++) {

Ditto.

> +               isp_reg_writel(gtable.greentable[i],
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> +       }
> +
> +       isp_reg_writel(ISPPRV_BLUEGAMMA_TABLE_ADDR,
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 1024; i++) {

Ditto.

> +               isp_reg_writel(gtable.bluetable[i],
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> +       }
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
> +       isp_reg_writel(ISPPRV_YENH_TABLE_ADDR,
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> +       for (i = 0; i < 128; i++) {

Ditto.

> +               isp_reg_writel(ytable[i],
> +                               OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> +       }
> +}
> +EXPORT_SYMBOL(isppreview_config_luma_enhancement);
> +

> +
> +/**
> + * isp_preview_cleanup - Module Cleanup.
> + **/
> +void __exit isp_preview_cleanup(void)
> +{
> +       kfree(prev_config_params);
> +       prev_config_params = NULL;

Is this NULL assignment needed?

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

Please update copyright too. Add 2009 :)

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
