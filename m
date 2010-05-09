Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3445 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0EIPTI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 11:19:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v2 2/10] V4L2 patches for Intel Moorestown Camera Imaging Drivers - part 2
Date: Sun, 9 May 2010 17:20:37 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>
References: <33AB447FBD802F4E932063B962385B351D6D536F@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351D6D536F@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005091720.37755.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 28 March 2010 16:42:42 Zhang, Xiaolin wrote:
> From a40f7d1da1cd78f2614c19610fe14bb3af2b55f4 Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Sun, 28 Mar 2010 21:34:04 +0800
> Subject: [PATCH 2/10] This patch is second part of intel moorestown isp driver and c files collection which is hardware componnet functionality.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  drivers/media/video/mrstci/mrstisp/mrstisp_dp.c  | 1224 ++++++++++++++
>  drivers/media/video/mrstci/mrstisp/mrstisp_hw.c  | 1360 +++++++++++++++
>  drivers/media/video/mrstci/mrstisp/mrstisp_isp.c | 1913 ++++++++++++++++++++++
>  drivers/media/video/mrstci/mrstisp/mrstisp_jpe.c |  569 +++++++
>  drivers/media/video/mrstci/mrstisp/mrstisp_mif.c |  703 ++++++++
>  5 files changed, 5769 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrstisp_dp.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrstisp_hw.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrstisp_isp.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrstisp_jpe.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrstisp_mif.c
> 
> diff --git a/drivers/media/video/mrstci/mrstisp/mrstisp_dp.c b/drivers/media/video/mrstci/mrstisp/mrstisp_dp.c
> new file mode 100644
> index 0000000..c0e404b
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/mrstisp_dp.c
> @@ -0,0 +1,1224 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include "mrstisp_stdinc.h"
> +
> +/* mask for all chroma subsampling settings */
> +#define CI_ISP_DPD_CSS_MASK  (CI_ISP_DPD_CSS_H_MASK | CI_ISP_DPD_CSS_V_MASK)
> +#define SCALER_COFFS_COSITED 0x400
> +#define FIXEDPOINT_ONE 0x1000
> +
> +/* limitations of main and self scaler */
> +#define MAIN_SCALER_WIDTH_MAX 2600
> +#define SELF_SCALER_WIDTH_MAX 640
> +#define SCALER_MIN 16
> +
> +#define SELF_UPSCALE_FACTOR_MAX 5
> +#define MAIN_UPSCALE_FACTOR_MAX 5
> +
> +/*
> + * upscale lookup table for smooth edges
> + * (linear interpolation between pixels)
> + */
> +
> +/* smooth edges */
> +static const struct ci_isp_rsz_lut isp_rsz_lut_smooth_lin = {
> +       {
> +       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +       0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
> +       0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
> +       0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
> +       0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
> +       0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
> +       0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
> +       0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
> +       }
> +};
> +
> +/*
> + * upscale lookup table for sharp edges
> + * (no interpolation, just duplicate pixels)
> + */
> +
> +/* sharp edges */
> +static const struct ci_isp_rsz_lut isp_rsz_lut_sharp = {
> +       {
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
> +       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
> +       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
> +       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F
> +       }
> +};
> +
> +/* structure combining virtual ISP windows settings */
> +struct ci_isp_virtual_isp_wnds {
> +       struct ci_isp_window wnd_blacklines;
> +       struct ci_isp_window wnd_zoom_crop;
> +};
> +
> +/* static storage to remember last applied virtual ISP window settings */
> +static struct ci_isp_virtual_isp_wnds last_isp_wnds;
> +
> +/*
> + * Calculates the value to program into the struct ci_isp_scale or
> + * tsMrvSScale structures to scale from in pixels to out pixels.
> + *
> + * The formulas are taken from the MARVIN / MARVIN3PLUS user
> + * manuals (fixed-point calculation using 32 bit during
> + * processing, will overflow at an output size of 1048575 pixels).
> + */
> +static u32 ci_get_scale_reg(u16 in, u16 out)
> +{
> +       if (in > out) {
> +               /* downscaling */
> +               return (u32) (((((u32) out - 1) * RSZ_SCALER_BYPASS) /
> +                                 (u32) (in - 1)) + 1);
> +       } else if (in < out) {
> +               /* upscaling */
> +               return (u32) (((((u32) in - 1) * RSZ_SCALER_BYPASS) /
> +                                 (u32) (out - 1)) | (u32) RSZ_UPSCALE_ENABLE);
> +       }
> +
> +       /* no scaling */
> +       return RSZ_SCALER_BYPASS;
> +}
> +
> +/*
> + * Calculates the values of the ci_isp_scale structure for the
> + * given input size and data path descriptor.
> + */
> +static u32 ci_calc_scale_factors(const struct ci_isp_datapath_desc *source,
> +                                const struct ci_isp_datapath_desc *path,
> +                                struct ci_isp_scale *scale, int implementation)
> +{
> +       u32 scaler_output_format;
> +       u32 cssflags;
> +       u32 scaler_input_format;
> +
> +       u16 chroma_in_w;
> +       u16 chroma_in_h;
> +       u16 chroma_out_wcr;
> +       u16 chroma_out_wcb;
> +       u16 chroma_out_h;
> +
> +       memset(scale, 0, sizeof(struct ci_isp_scale));
> +       dprintk(1, "srcw %d, srch %d;", source->out_w, source->out_h);
> +       dprintk(1, "dstw %d, dsth %d", path->out_w, path->out_h);
> +
> +       /* calculate Y scale factors */
> +       scale->scale_hy = ci_get_scale_reg(source->out_w, path->out_w);
> +       scale->scale_vy = ci_get_scale_reg(source->out_h, path->out_h);
> +
> +       /* figure out the color input format of the scaler */
> +       switch (path->flags & CI_ISP_DPD_MODE_MASK) {
> +       case CI_ISP_DPD_MODE_DMAYC_DIRECT:
> +       case CI_ISP_DPD_MODE_DMAYC_ISP:
> +       case CI_ISP_DPD_MODE_DMAJPEG_DIRECT:
> +       case CI_ISP_DPD_MODE_DMAJPEG_ISP:
> +               scaler_input_format = path->flags & CI_ISP_DPD_DMA_IN_MASK;
> +               break;
> +       default:
> +               scaler_input_format = CI_ISP_DPD_DMA_IN_422;
> +               break;
> +       }
> +
> +       dprintk(1, "scaler_input_format is 0x%x", scaler_input_format);
> +
> +       switch (scaler_input_format) {
> +       case CI_ISP_DPD_DMA_IN_422:
> +               chroma_in_w = source->out_w / 2;
> +               chroma_in_h = source->out_h;
> +               chroma_out_wcr = path->out_w / 2;
> +               chroma_out_wcb = (path->out_w + 1) / 2;
> +               chroma_out_h = path->out_h;
> +               break;
> +       case CI_ISP_DPD_DMA_IN_420:
> +               chroma_in_w = source->out_w / 2;
> +               chroma_in_h = source->out_h / 2;
> +               chroma_out_wcr = path->out_w / 2;
> +               chroma_out_wcb = (path->out_w + 1) / 2;
> +               chroma_out_h = path->out_h / 2;
> +               break;
> +       case CI_ISP_DPD_DMA_IN_411:
> +               chroma_in_w = source->out_w / 4;
> +               chroma_in_h = source->out_h;
> +               chroma_out_wcr = path->out_w / 4;
> +               chroma_out_wcb = (path->out_w + 2) / 4;
> +               chroma_out_h = path->out_h;
> +               break;
> +       case CI_ISP_DPD_DMA_IN_444:
> +       default:
> +               chroma_in_w = source->out_w;
> +               chroma_in_h = source->out_h;
> +               chroma_out_wcb = chroma_out_wcr = path->out_w;
> +               chroma_out_h = path->out_h;
> +               break;
> +       }
> +
> +       /* calculate chrominance scale factors */
> +       switch (path->flags & CI_ISP_DPD_CSS_H_MASK) {
> +       case CI_ISP_DPD_CSS_H2:
> +               chroma_out_wcb /= 2;
> +               chroma_out_wcr /= 2;
> +               break;
> +       case CI_ISP_DPD_CSS_H4:
> +               chroma_out_wcb /= 4;
> +               chroma_out_wcr /= 4;
> +               break;
> +       case CI_ISP_DPD_CSS_HUP2:
> +               chroma_out_wcb *= 2;
> +               chroma_out_wcr *= 2;
> +               break;
> +       case CI_ISP_DPD_CSS_HUP4:
> +               chroma_out_wcb *= 4;
> +               chroma_out_wcr *= 4;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       scale->scale_hcr = ci_get_scale_reg(chroma_in_w, chroma_out_wcr);
> +       scale->scale_hcb = ci_get_scale_reg(chroma_in_w, chroma_out_wcb);
> +       scale->scale_hcb = scale->scale_hcr;
> +
> +       switch (path->flags & CI_ISP_DPD_CSS_V_MASK) {
> +       case CI_ISP_DPD_CSS_V2:
> +               chroma_out_h /= 2;
> +               break;
> +       case CI_ISP_DPD_CSS_V4:
> +               chroma_out_h /= 4;
> +               break;
> +       case CI_ISP_DPD_CSS_VUP2:
> +               chroma_out_h *= 2;
> +               break;
> +       case CI_ISP_DPD_CSS_VUP4:
> +               chroma_out_h *= 4;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       scale->scale_vc = ci_get_scale_reg(chroma_in_h, chroma_out_h);
> +
> +       /* additional chrominance phase shifts */
> +       if (path->flags & CI_ISP_DPD_CSS_HSHIFT)
> +               scale->phase_hc = SCALER_COFFS_COSITED;
> +       if (path->flags & CI_ISP_DPD_CSS_VSHIFT)
> +               scale->phase_vc = SCALER_COFFS_COSITED;
> +
> +       /* additional luminance phase shifts */
> +       if (path->flags & CI_ISP_DPD_LUMA_HSHIFT)
> +               scale->phase_hy = SCALER_COFFS_COSITED;
> +       if (path->flags & CI_ISP_DPD_LUMA_VSHIFT)
> +               scale->phase_vy = SCALER_COFFS_COSITED;
> +
> +       /* try to figure out the outcoming YCbCr format */
> +       cssflags = path->flags & CI_ISP_DPD_CSS_MASK;
> +       if (cssflags == (CI_ISP_DPD_CSS_H_OFF | CI_ISP_DPD_CSS_V_OFF)) {
> +               /* trivial case: the output format is not changed */
> +               scaler_output_format = scaler_input_format;
> +       } else {
> +               /* output format gets changed by the scaler setting */
> +               /* assume invalid format by default */
> +               scaler_output_format = (u32) (-1);
> +               switch (scaler_input_format) {
> +               case CI_ISP_DPD_DMA_IN_444:
> +                       if (cssflags == (CI_ISP_DPD_CSS_H2
> +                                        | CI_ISP_DPD_CSS_V_OFF)) {
> +                               /* conversion 444 -> 422 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_H4
> +                                               | CI_ISP_DPD_CSS_V_OFF)) {
> +                               /* conversion 444 -> 411 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_H2
> +                                               | CI_ISP_DPD_CSS_V2)) {
> +                               /* conversion 444 -> 420 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
> +                       }
> +                       break;
> +
> +               case CI_ISP_DPD_DMA_IN_422:
> +                       if (cssflags == (CI_ISP_DPD_CSS_HUP2
> +                                        | CI_ISP_DPD_CSS_V_OFF)) {
> +                               /* conversion 422 -> 444 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_H2
> +                                               | CI_ISP_DPD_CSS_V_OFF)) {
> +                               /* conversion 422 -> 411 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_H_OFF
> +                                               | CI_ISP_DPD_CSS_V2)) {
> +                               /* conversion 422 -> 420 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
> +                       }
> +                       break;
> +
> +               case CI_ISP_DPD_DMA_IN_420:
> +                       if (cssflags == (CI_ISP_DPD_CSS_HUP2
> +                                        | CI_ISP_DPD_CSS_VUP2)) {
> +                               /* conversion 420 -> 444 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_H2
> +                                               | CI_ISP_DPD_CSS_VUP2)) {
> +                               /* conversion 420 -> 411 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_H_OFF
> +                                               | CI_ISP_DPD_CSS_VUP2)) {
> +                               /* conversion 420 -> 422 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
> +                       }
> +                       break;
> +
> +               case CI_ISP_DPD_DMA_IN_411:
> +                       if (cssflags == (CI_ISP_DPD_CSS_HUP4
> +                                        | CI_ISP_DPD_CSS_V_OFF)) {
> +                               /* conversion 411 -> 444 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_HUP2
> +                                               | CI_ISP_DPD_CSS_V_OFF)) {
> +                               /* conversion 411 -> 422 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
> +                       } else if (cssflags == (CI_ISP_DPD_CSS_HUP2
> +                                               | CI_ISP_DPD_CSS_V2)) {
> +                               /* conversion 411 -> 420 */
> +                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
> +                       }
> +                       break;
> +
> +               default:
> +                       break;
> +               }
> +       }
> +
> +       return scaler_output_format;
> +}
> +
> +/*
> + * Returns the address of up-scaling lookup table to use for
> + * the given data path flags.
> + */
> +static const struct ci_isp_rsz_lut *ci_get_rsz_lut(u32 flags)
> +{
> +       const struct ci_isp_rsz_lut *ret_val;
> +       switch (flags & CI_ISP_DPD_UPSCALE_MASK) {
> +       case CI_ISP_DPD_UPSCALE_SHARP:
> +               ret_val = &isp_rsz_lut_sharp;
> +               break;
> +       default:
> +               ret_val = &isp_rsz_lut_smooth_lin;
> +               break;
> +       }
> +       return ret_val;
> +}
> +
> +/*
> + * Fills in scale factors and MI configuration for the main path.
> + * Note that only self path related settings will be written into
> + * the MI configuration struct, so this routine can be used for
> + * both ISP and DMA originated data path setups.
> + *
> + * Following fields are being filled in:
> + * scale_main: [all fields]
> + * mrv_mi_ctrl: mrv_mif_mp_pic_form main_path
> + */
> +static int ci_calc_main_path_settings(const struct ci_isp_datapath_desc *source,
> +                                     const struct ci_isp_datapath_desc  *main,
> +                                     struct ci_isp_scale *scale_main,
> +                                     struct ci_isp_mi_ctrl *mrv_mi_ctrl)
> +{
> +       u32 main_flag;
> +
> +       WARN_ON(!(source != NULL));
> +       WARN_ON(!(scale_main != NULL));
> +       WARN_ON(!(mrv_mi_ctrl != NULL));
> +
> +       /* assume datapath deactivation if no selfpath pointer is given) */
> +       if (main)
> +               main_flag = main->flags;
> +       else
> +               main_flag = 0;
> +
> +       /* initialize the given parameters */
> +       memset(scale_main, 0, sizeof(struct ci_isp_scale));
> +       scale_main->scale_hy = RSZ_SCALER_BYPASS;
> +       scale_main->scale_hcb = RSZ_SCALER_BYPASS;
> +       scale_main->scale_hcr = RSZ_SCALER_BYPASS;
> +       scale_main->scale_vy = RSZ_SCALER_BYPASS;
> +       scale_main->scale_vc = RSZ_SCALER_BYPASS;
> +
> +       if (main_flag & CI_ISP_DPD_ENABLE) {
> +               switch (main_flag & CI_ISP_DPD_MODE_MASK) {
> +               case CI_ISP_DPD_MODE_ISPYC:
> +               case CI_ISP_DPD_MODE_DMAYC_ISP:
> +                       mrv_mi_ctrl->main_path = CI_ISP_PATH_ON;
> +                       break;
> +               case CI_ISP_DPD_MODE_ISPJPEG:
> +               case CI_ISP_DPD_MODE_DMAJPEG_DIRECT:
> +               case CI_ISP_DPD_MODE_DMAJPEG_ISP:
> +                       mrv_mi_ctrl->main_path = CI_ISP_PATH_JPE;
> +                       break;
> +               case CI_ISP_DPD_MODE_ISPRAW:
> +                       mrv_mi_ctrl->main_path = CI_ISP_PATH_RAW8;
> +                       break;
> +               case CI_ISP_DPD_MODE_ISPRAW_16B:
> +                       mrv_mi_ctrl->main_path = CI_ISP_PATH_RAW816;
> +                       break;
> +               default:
> +                       eprintk("unsupported mode for main path");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +               if (main_flag & (CI_ISP_DPD_H_FLIP | CI_ISP_DPD_V_FLIP |
> +                       CI_ISP_DPD_90DEG_CCW)) {
> +                       eprintk("not supported for main path");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +               if (main_flag & CI_ISP_DPD_NORESIZE) {
> +                       if (main_flag & CI_ISP_DPD_CSS_MASK) {
> +                               eprintk("main path needs rezizer");
> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +                       if (main_flag &
> +                           (CI_ISP_DPD_LUMA_HSHIFT | CI_ISP_DPD_LUMA_VSHIFT)) {
> +                               eprintk("main path needs rezizer");
> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +               } else {
> +                       if ((mrv_mi_ctrl->main_path == CI_ISP_PATH_RAW8)
> +                           || (mrv_mi_ctrl->main_path == CI_ISP_PATH_RAW8)) {
> +                               eprintk("scaler not in RAW mode");
> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +                       /* changed to avoid LINT warnings (Warning 613) */
> +                       if (main != NULL) {
> +                               if ((((u32) (source->out_w) *
> +                                     MAIN_UPSCALE_FACTOR_MAX) < main->out_w)
> +                                   ||
> +                                   (((u32) (source->out_h) *
> +                                     MAIN_UPSCALE_FACTOR_MAX) <
> +                                    main->out_h)) {
> +                                       eprintk("main upscaling exceeded");
> +                                       return CI_STATUS_NOTSUPP;
> +                               }
> +                               if ((main->out_w >
> +                                    MAIN_SCALER_WIDTH_MAX)
> +                                   || (main->out_w < SCALER_MIN)
> +                                   || (main->out_h < SCALER_MIN)) {
> +                                       eprintk("main scaler ange exceeded");
> +                                       return CI_STATUS_NOTSUPP;
> +                               }
> +                       } else {
> +                               WARN_ON(main == NULL);
> +                       }
> +
> +                       if (source->out_w & 0x01) {
> +                               eprintk("input width must be even!");
> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +
> +                       /* calculate scale factors. */
> +                       (void)ci_calc_scale_factors(source, main, scale_main,
> +                                                   3 /*MARVIN_FEATURE_MSCALE_FACTORCALC*/);
> +               }
> +       } else {
> +               mrv_mi_ctrl->main_path = CI_ISP_PATH_OFF;
> +       }
> +
> +       /* hardcoded MI settings */
> +       dprintk(1, "main_flag is 0x%x", main_flag);
> +       if (main_flag & CI_ISP_DPD_HWRGB_MASK) {
> +               switch (main_flag & CI_ISP_DPD_HWRGB_MASK) {
> +               case CI_ISP_DPD_YUV_420:
> +               case CI_ISP_DPD_YUV_422:
> +                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +                       break;
> +               case CI_ISP_DPD_YUV_NV12:
> +                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_SEMI_PLANAR;
> +                       break;
> +               case CI_ISP_DPD_YUV_YUYV:
> +                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_INTERLEAVED;
> +                       break;
> +               default:
> +                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +               }
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Fills in scale factors and MI configuration for the self
> + * path.  Note that only self path related settings will be written into
> + * the MI config struct, so this routine can be used for both ISP and DMA
> + * originated datapath setups.
> + *
> + * Following fields are being filled in:
> + *           scale_flag :
> + *              [all fields]
> + *           mrv_mi_ctrl :
> + *              mrv_mif_sp_out_form
> + *              mrv_mif_sp_in_form
> + *              mrv_mif_sp_pic_form
> + *              mrv_mif_sp_mode
> + *              self_path
> + */
> +static int ci_calc_self_path_settings(const struct ci_isp_datapath_desc *source,
> +                                     const struct ci_isp_datapath_desc *self,
> +                                     struct ci_isp_scale *scale_flag,
> +                                     struct ci_isp_mi_ctrl *mrv_mi_ctrl)
> +{
> +       u32 scaler_out_col_format;
> +       u32 self_flag;
> +
> +       WARN_ON(!(source != NULL));
> +       WARN_ON(!(scale_flag != NULL));
> +       WARN_ON(!(mrv_mi_ctrl != NULL));
> +
> +       /* assume datapath deactivation if no selfpath pointer is given) */
> +       if (self)
> +               self_flag = self->flags;
> +       else
> +               self_flag = 0;
> +
> +       /* initialize the given parameters */
> +       memset(scale_flag, 0, sizeof(struct ci_isp_scale));
> +       scale_flag->scale_hy = RSZ_SCALER_BYPASS;
> +       scale_flag->scale_hcb = RSZ_SCALER_BYPASS;
> +       scale_flag->scale_hcr = RSZ_SCALER_BYPASS;
> +       scale_flag->scale_vy = RSZ_SCALER_BYPASS;
> +       scale_flag->scale_vc = RSZ_SCALER_BYPASS;
> +
> +       if (self_flag & CI_ISP_DPD_ENABLE) {
> +               switch (self_flag & CI_ISP_DPD_MODE_MASK) {
> +               case CI_ISP_DPD_MODE_ISPYC:
> +                       mrv_mi_ctrl->self_path = CI_ISP_PATH_ON;
> +                       scaler_out_col_format = CI_ISP_DPD_DMA_IN_422;
> +                       break;
> +               case CI_ISP_DPD_MODE_DMAYC_ISP:
> +               case CI_ISP_DPD_MODE_DMAYC_DIRECT:
> +                       mrv_mi_ctrl->self_path = CI_ISP_PATH_ON;
> +                       scaler_out_col_format =
> +                           self_flag & CI_ISP_DPD_DMA_IN_MASK;
> +                       break;
> +               default:
> +                       eprintk("unsupported mode for self path");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +
> +               if (self_flag & CI_ISP_DPD_NORESIZE) {
> +                       if (self_flag & CI_ISP_DPD_CSS_MASK) {
> +                               eprintk("in self path needs rezizer");
> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +                       if (self_flag &
> +                           (CI_ISP_DPD_LUMA_HSHIFT | CI_ISP_DPD_LUMA_VSHIFT)) {
> +                               eprintk("n self path needs rezizer");

Typo: rezizer -> resizer

> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +                       /* changed to avoid LINT warnings (Warning 613) */
> +                       if (self != NULL) {
> +                               if ((source->out_w != self->out_w) ||
> +                                   (source->out_h != self->out_h)) {
> +                                       eprintk("sizes needs resizer");
> +                                       return CI_STATUS_NOTSUPP;
> +                               }
> +                       } else {
> +                               WARN_ON(self == NULL);
> +                       }
> +               } else {
> +                       /* changed to avoid LINT warnings (Warning 613) */
> +                       if (self != NULL) {
> +                               /* upscaling only to factor
> +                                * SELF_UPSCALE_FACTOR_MAX possible
> +                                */
> +                               if ((((u32) (source->out_w) *
> +                                     SELF_UPSCALE_FACTOR_MAX) <
> +                                    self->out_w)
> +                                   ||
> +                                   (((u32) (source->out_h) *
> +                                     SELF_UPSCALE_FACTOR_MAX) <
> +                                    self->out_h)) {
> +                                       eprintk("apability exceeded");
> +                                       return CI_STATUS_NOTSUPP;
> +                               }
> +                               if ((self->out_w >
> +                                    SELF_SCALER_WIDTH_MAX)
> +                                   || (self->out_w < SCALER_MIN)
> +                                   || (self->out_h < SCALER_MIN)) {
> +                                       eprintk("out range exceeded");
> +                                       return CI_STATUS_NOTSUPP;
> +                               }
> +                       } else {
> +                               WARN_ON(self == NULL);
> +                       }
> +
> +                       /*
> +                        * Remember that the input picture width should be
> +                        * even if the scaler is used otherwise the scaler may
> +                        * show unexpected behaviour in some rare cases)
> +                        */
> +                       if (source->out_w & 0x01) {
> +                               eprintk("width must be even!");
> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +
> +                       /* calculate scale factors. */
> +                       scaler_out_col_format =
> +                           ci_calc_scale_factors(source, self, scale_flag,
> +                                                 3 /*MARVIN_FEATURE_SSCALE_FACTORCALC*/);
> +               }
> +
> +               /* figure out the input format setting */
> +               switch (scaler_out_col_format) {
> +               case CI_ISP_DPD_DMA_IN_444:
> +                       mrv_mi_ctrl->mrv_mif_sp_in_form =
> +                           CI_ISP_MIF_COL_FORMAT_YCBCR_444;
> +                       break;
> +               case CI_ISP_DPD_DMA_IN_422:
> +                       mrv_mi_ctrl->mrv_mif_sp_in_form =
> +                           CI_ISP_MIF_COL_FORMAT_YCBCR_422;
> +                       break;
> +               case CI_ISP_DPD_DMA_IN_420:
> +                       mrv_mi_ctrl->mrv_mif_sp_in_form =
> +                           CI_ISP_MIF_COL_FORMAT_YCBCR_420;
> +                       break;
> +               case CI_ISP_DPD_DMA_IN_411:
> +               default:
> +                       eprintk("input color format not supported");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +
> +               /* figure out the output format setting */
> +               dprintk(2, "step2, self_flag is 0x%x", self_flag);
> +
> +               switch (self_flag & CI_ISP_DPD_HWRGB_MASK) {
> +               case CI_ISP_DPD_HWRGB_565:
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                           CI_ISP_MIF_COL_FORMAT_RGB_565;
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +                       break;
> +               case CI_ISP_DPD_HWRGB_666:
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                           CI_ISP_MIF_COL_FORMAT_RGB_666;
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +                       break;
> +               case CI_ISP_DPD_HWRGB_888:
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                           CI_ISP_MIF_COL_FORMAT_RGB_888;
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +                       break;
> +               case CI_ISP_DPD_YUV_420:
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                               CI_ISP_MIF_COL_FORMAT_YCBCR_420;
> +                       break;
> +               case CI_ISP_DPD_YUV_422:
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                               CI_ISP_MIF_COL_FORMAT_YCBCR_422;
> +                       break;
> +               case CI_ISP_DPD_YUV_NV12:
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_SEMI_PLANAR;
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                               CI_ISP_MIF_COL_FORMAT_YCBCR_420;
> +                       break;
> +               case CI_ISP_DPD_YUV_YUYV:
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_INTERLEAVED;
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                               CI_ISP_MIF_COL_FORMAT_YCBCR_422;
> +                       break;
> +
> +               case CI_ISP_DPD_HWRGB_OFF:
> +                       mrv_mi_ctrl->mrv_mif_sp_out_form =
> +                           mrv_mi_ctrl->mrv_mif_sp_in_form;
> +                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
> +                               CI_ISP_MIF_PIC_FORM_PLANAR;
> +                       break;
> +               default:
> +                       eprintk("output color format not supported");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +
> +               /* picture flipping / rotation */
> +               dprintk(2, "step3");
> +
> +               switch (self_flag &
> +                       (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP |
> +                        CI_ISP_DPD_H_FLIP)) {
> +               case (CI_ISP_DPD_H_FLIP):

Why the '(' ')' around the case label?

> +                       mrv_mi_ctrl->mrv_mif_sp_mode =
> +                       CI_ISP_MIF_SP_HORIZONTAL_FLIP;
> +                       break;
> +               case (CI_ISP_DPD_V_FLIP):
> +                       mrv_mi_ctrl->mrv_mif_sp_mode =
> +                       CI_ISP_MIF_SP_VERTICAL_FLIP;
> +                       break;
> +               case (CI_ISP_DPD_V_FLIP | CI_ISP_DPD_H_FLIP):
> +                       mrv_mi_ctrl->mrv_mif_sp_mode =
> +                       CI_ISP_MIF_SP_ROTATION_180_DEG;
> +                       break;
> +               case (CI_ISP_DPD_90DEG_CCW):
> +                       mrv_mi_ctrl->mrv_mif_sp_mode =
> +                       CI_ISP_MIF_SP_ROTATION_090_DEG;
> +                       break;
> +               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_H_FLIP):
> +                       mrv_mi_ctrl->mrv_mif_sp_mode =
> +                       CI_ISP_MIF_SP_ROT_270_V_FLIP;
> +                       break;
> +               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP):
> +                       mrv_mi_ctrl->mrv_mif_sp_mode =
> +                       CI_ISP_MIF_SP_ROT_090_V_FLIP;
> +                       break;
> +               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP |
> +                       CI_ISP_DPD_H_FLIP):
> +                       mrv_mi_ctrl->mrv_mif_sp_mode =
> +                       CI_ISP_MIF_SP_ROTATION_270_DEG;
> +                       break;
> +               default:
> +                       mrv_mi_ctrl->mrv_mif_sp_mode = CI_ISP_MIF_SP_ORIGINAL;
> +                       break;
> +               }
> +
> +       } else {
> +               mrv_mi_ctrl->self_path = CI_ISP_PATH_OFF;
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Translates the given memory interface configuration struct
> + * into appropriate values to program the data path multiplexers.
> + */
> +static int ci_calc_dp_mux_settings(const struct ci_isp_mi_ctrl *mi_ctrl,
> +                                  enum ci_isp_ycs_chn_mode *peYcsChnMode,
> +                                  enum ci_isp_dp_switch *peDpSwitch)
> +{
> +       switch (mi_ctrl->main_path) {
> +       case CI_ISP_PATH_RAW8:
> +       case CI_ISP_PATH_RAW816:
> +               *peDpSwitch = CI_ISP_DP_RAW;
> +               *peYcsChnMode = CI_ISP_YCS_MVRaw;

camelCase

> +               if (mi_ctrl->self_path != CI_ISP_PATH_OFF) {
> +                       eprintk("ombined with RAW mode of main path");

typo: 'combined'

> +                       return CI_STATUS_NOTSUPP;
> +               }
> +               break;
> +
> +       case CI_ISP_PATH_JPE:
> +               *peDpSwitch = CI_ISP_DP_JPEG;
> +               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
> +                       *peYcsChnMode = CI_ISP_YCS_MV_SP;
> +               else
> +                       *peYcsChnMode = CI_ISP_YCS_MV;
> +               break;
> +
> +       case CI_ISP_PATH_ON:
> +               *peDpSwitch = CI_ISP_DP_MV;
> +               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
> +                       *peYcsChnMode = CI_ISP_YCS_MV_SP;
> +               else
> +                       *peYcsChnMode = CI_ISP_YCS_MV;
> +               break;
> +
> +       case CI_ISP_PATH_OFF:
> +               *peDpSwitch = CI_ISP_DP_MV;
> +               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
> +                       *peYcsChnMode = CI_ISP_YCS_SP;
> +               else
> +                       *peYcsChnMode = CI_ISP_YCS_OFF;
> +               break;
> +
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +#define ISPWND_COMBINE_WNDS    0x00000001
> +#define ISPWND_APPLY_OUTFORM   0x00000002
> +#define ISPWND_APPLY_ISCONF    0x00000004
> +#define ISPWND_NO_CROPPING     0x00000008
> +
> +/*
> + * Returns information about how to combine black pixel and
> + * zoom/crop windows for programming the ISP output formatter and the image
> + * stabilization unit for the given marvin derivative and ISP path.
> + */
> +static u32 ci_get_isp_wnd_style(enum ci_isp_path isp_path)
> +{
> +       u32 res = 0;
> +
> +       /* image stabilization in both bayer and YCbCr paths */
> +       if ((isp_path == CI_ISP_PATH_BAYER) ||
> +           (isp_path == CI_ISP_PATH_YCBCR))
> +               res = ISPWND_APPLY_OUTFORM | ISPWND_APPLY_ISCONF;
> +       else
> +               res = ISPWND_COMBINE_WNDS | ISPWND_APPLY_OUTFORM;
> +
> +       return res;
> +}
> +
> +/*
> + *  the given windows for cutting away blacklines coming from
> + *  the image sensor and further cropping of the image for other
> + *  purposes like e.g. digital zoom to the output formatter and/or
> + *  image stabilisation modules of Marvins ISP.
> + */
> +static int ci_set_isp_windows(const struct ci_sensor_config *isi_sensor_config,
> +                             const struct ci_isp_window *wnd_blackline,
> +                             const struct ci_isp_window *wnd_zoom_crop)
> +{
> +       struct ci_isp_window wnd_out_form;
> +       struct ci_isp_is_config is_conf;
> +       enum ci_isp_path isp_path;
> +       u32 wnd_style;
> +
> +       memset(&wnd_out_form, 0, sizeof(wnd_out_form));
> +       memset(&is_conf, 0, sizeof(is_conf));
> +
> +       /*
> +        * figure out the path through the ISP to process the data from the
> +        * image sensor
> +        */
> +       isp_path = ci_isp_select_path(isi_sensor_config, NULL);
> +       if (isp_path == CI_ISP_PATH_UNKNOWN) {
> +               eprintk("detect marvin ISP path to use");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       /*
> +        * get the recommended way to configure output formatter and/or
> +        * image stabilization
> +        */
> +       wnd_style = ci_get_isp_wnd_style(isp_path);
> +       if (wnd_style & ISPWND_NO_CROPPING) {
> +               /*
> +                * cropping not possible -> make sure that it is *not*
> +                * supposed to be used
> +                */
> +               u16 isi_x;
> +               u16 isi_y;
> +               ci_sensor_res2size(isi_sensor_config->res, &isi_x, &isi_y);
> +               if ((wnd_zoom_crop->hsize != isi_x)
> +                   || (wnd_zoom_crop->vsize != isi_y)
> +                   || (wnd_zoom_crop->hoffs != 0)
> +                   || (wnd_zoom_crop->voffs != 0)) {
> +                       eprintk("in selected ISP data path");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +               if ((wnd_blackline->hsize != isi_x) ||
> +                   (wnd_blackline->vsize != isi_y) ||
> +                   (wnd_blackline->hoffs != 0) ||
> +                   (wnd_blackline->voffs != 0)) {
> +                       eprintk("supported in selected ISP data path");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +       }
> +
> +       /*
> +        * The image stabilization is allowed to move the window in both
> +        * directions by the same amount of pixels we have calculated for
> +        * the offsets. The initial image stabilization window is equal to
> +        * the zoom/crop window
> +        */
> +       is_conf.max_dx = wnd_zoom_crop->hoffs;
> +       is_conf.max_dy = wnd_zoom_crop->voffs;
> +       is_conf.mrv_is_window = *wnd_zoom_crop;
> +
> +       /* combine both blackline and zoom/crop window */
> +       if (wnd_style & ISPWND_COMBINE_WNDS) {
> +               wnd_out_form = *wnd_zoom_crop;
> +               wnd_out_form.voffs += wnd_blackline->voffs;
> +               wnd_out_form.hoffs += wnd_blackline->hoffs;
> +               is_conf.mrv_is_window = wnd_out_form;
> +               if (wnd_style & ISPWND_APPLY_OUTFORM) {
> +                       /*
> +                        * if the output formatter is to be used, offsets
> +                        * are cut away there, so
> +                        * we don't need additional ones in the imags
> +                        * stabilization unit
> +                        */
> +                       is_conf.mrv_is_window.hoffs = 0;
> +                       is_conf.mrv_is_window.voffs = 0;
> +               }
> +       } else {
> +               /*
> +                * do not combine windows --> blacklines done with output
> +                * formatter, zoom/cropping done with image stabilization
> +                */
> +               wnd_out_form = *wnd_blackline;
> +               is_conf.mrv_is_window = *wnd_zoom_crop;
> +       }
> +
> +       /* finally, apply the settings to marvin */
> +       if (wnd_style & ISPWND_APPLY_OUTFORM) {
> +               ci_isp_set_output_formatter(&wnd_out_form,
> +                                           CI_ISP_CFG_UPDATE_IMMEDIATE);
> +       }
> +       if (wnd_style & ISPWND_APPLY_ISCONF) {
> +               int res = ci_isp_is_set_config(&is_conf);
> +               if (res != CI_STATUS_SUCCESS) {
> +                       eprintk("set image stabilization config");
> +                       return res;
> +               }
> +       }
> +
> +       /* success - remember our virtual settings */
> +       last_isp_wnds.wnd_blacklines = *wnd_blackline;
> +       last_isp_wnds.wnd_zoom_crop = *wnd_zoom_crop;
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/* sets extended YCbCr mode */
> +static int ci_ext_ycb_cr_mode(const struct ci_isp_datapath_desc *path)
> +{
> +       u32 main_flag;
> +
> +       WARN_ON(!(path != NULL));
> +
> +       /* assume datapath deactivation if no selfpath pointer is given) */
> +       if (path)
> +               main_flag = path->flags;
> +       else
> +               main_flag = 0;
> +
> +       /* if flag CI_ISP_DPD_YCBCREXT is set set extended YCbCr mode */
> +       if (main_flag & CI_ISP_DPD_ENABLE) {
> +               if (main_flag & CI_ISP_DPD_YCBCREXT)
> +                       ci_isp_set_ext_ycmode();
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Configures main and self data pathes and scaler for data coming from the ISP.
> + *
> + * Following MARVIN subsystems are programmed:
> + * - ISP output formatter
> + * - Image stabilization module
> + * - YC-Splitter
> + * - Self path DMA-read multiplexer
> + * - Main path multiplexer
> + * - Main & Self path resizer
> + * - Small output unit
> + * - Memory Interface (MI) input source, en/disable and data format
> + *
> + * Following MARVIN subsystems are *NOT* programmed:
> + * - All ISP functionality but the output formatter & image stabilization module
> + * - color Processing block
> + * - JPEG encode subsystem (quantisation tables etc.)
> + * - Memory Interface (MI) output buffer addresses and sizes
> + */
> +int ci_datapath_isp(const struct ci_pl_system_config *sys_conf,
> +                   const struct ci_sensor_config *isi_config,
> +                   const struct ci_isp_datapath_desc *main,
> +                   const struct ci_isp_datapath_desc *self, int zoom)
> +{
> +       int res;
> +
> +       u32 main_flag;
> +       u32 self_flag;
> +       u16 isi_x;
> +       u16 isi_y;
> +       struct ci_isp_scale scale_main;
> +       struct ci_isp_scale scale_flag;
> +       enum ci_isp_ycs_chn_mode chn_mode = 0;
> +       enum ci_isp_dp_switch dp_switch = 0;
> +       struct ci_isp_mi_ctrl mrv_mi_ctrl;
> +       struct ci_isp_datapath_desc source;
> +       struct ci_isp_window wnd_blackline;
> +       struct ci_isp_window wnd_zoom_crop;
> +
> +       const struct ci_isp_datapath_desc *target = NULL;
> +
> +       /* assume dapapath deactivation for not provided descriptors */

typo: datapath

> +       main_flag = 0;
> +       self_flag = 0;
> +       if (main)
> +               main_flag = main->flags;
> +
> +       if (self)
> +               self_flag = self->flags;
> +
> +       /* initialize variables on the stack */
> +       res = CI_STATUS_SUCCESS;
> +       (void)ci_sensor_res2size(isi_config->res, &isi_x, &isi_y);
> +       memset(&mrv_mi_ctrl, 0, sizeof(struct ci_isp_mi_ctrl));
> +       memset(&wnd_blackline, 0, sizeof(wnd_blackline));
> +       memset(&wnd_zoom_crop, 0, sizeof(wnd_zoom_crop));
> +
> +       /* no cropping, no offset */
> +       wnd_blackline.hsize = isi_x;
> +       wnd_blackline.vsize = isi_y;
> +       wnd_zoom_crop = wnd_blackline;
> +
> +       /* output channel */
> +       if ((main_flag & CI_ISP_DPD_ENABLE) &&
> +           (main_flag & CI_ISP_DPD_KEEPRATIO)) {
> +               target = main;
> +       }
> +       if ((self_flag & CI_ISP_DPD_ENABLE) &&
> +           (self_flag & CI_ISP_DPD_KEEPRATIO)) {
> +               if (target) {
> +                       eprintk("only allowed for one path");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +               target = self;
> +       }
> +
> +       /* if so, calculate the cropping */
> +       if (target) {
> +               u32 aspect_cam = (0x1000 * ((u32) isi_x)) / isi_y;
> +               u32 aspect_target = (0x1000 * ((u32) (target->out_w))) /
> +                   target->out_h;
> +               if (aspect_cam < aspect_target) {
> +                       /*
> +                        * camera aspect is more 'portrait-like' as
> +                        * target aspect. We have to crop the
> +                        * camera picture by cutting off a bit of
> +                        * the top & bottom changed to avoid LINT
> +                        * warnings (Info 734)
> +                        */
> +                       wnd_zoom_crop.vsize = (u16) (((u32) isi_x *
> +                                      (u32) (target->out_h)) / target->out_w);
> +               } else  {
> +                       /* camera aspect is more 'landscape-like'
> +                        * as target aspect. We have to crop the
> +                        * camera picture by cutting off a bit of
> +                        * the left and right changed to avoid LINT
> +                        * warnings (Info 734) */
> +                       wnd_zoom_crop.hsize = (u16) (((u32) isi_y *
> +                                      (u32) (target->out_w)) / target->out_h);
> +               }
> +       }
> +
> +       /*
> +        * now, we may also want to do digital zoom. If so, we need
> +        * to shrink the ISP window by the desired zoom factor.
> +        */
> +       if (zoom > 0) {
> +               wnd_zoom_crop.vsize = (u16) (((u32) (wnd_zoom_crop.vsize) *
> +                              1024) / (1024 + (u32) zoom));
> +               wnd_zoom_crop.hsize = (u16) (((u32) (wnd_zoom_crop.hsize) *
> +                              1024) / (1024 + (u32) zoom));
> +       }
> +
> +       /*
> +        * Remember that the output formatter h_size should be
> +        * even if the scaler is used
> +        * (otherwise the scaler may show unexpected behaviour in
> +        * some rare cases)
> +        */
> +       wnd_zoom_crop.hsize &= ~0x01;
> +
> +       /*
> +        * At last, we care about the offset of the ISP window. We
> +        * want it centered on the image data delivered by the
> +        * sensor (not counting possible black lines)
> +        */
> +       wnd_zoom_crop.hoffs = (isi_x - wnd_zoom_crop.hsize) / 2;
> +       wnd_zoom_crop.voffs = (isi_y - wnd_zoom_crop.vsize) / 2;
> +
> +       /*
> +        * If the image sensor delivers blacklines, we cut them
> +        * away with moving wnd_blackline window by the given
> +        * amount of lines
> +        */
> +       switch (isi_config->bls) {
> +       case SENSOR_BLS_OFF:
> +               break;
> +       case SENSOR_BLS_TWO_LINES:
> +               wnd_blackline.voffs += 2;
> +               break;
> +       case SENSOR_BLS_FOUR_LINES:
> +               wnd_blackline.voffs += 2;
> +               break;
> +       default:
> +               eprintk("config");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +       /*
> +        * if we are instructed to show the blacklines and the
> +        * sensor generates them,
> +        * we have to move the ISP windows to the upper border of
> +        * the whole sensor, and deny the image stabilization to
> +        * move around the window in vertical direction.
> +        */
> +       if (isi_config->bls != SENSOR_BLS_OFF) {
> +               if (((main_flag & CI_ISP_DPD_ENABLE)
> +                    && (main_flag & CI_ISP_DPD_BLACKLINES_TOP))
> +                   || ((self_flag & CI_ISP_DPD_ENABLE)
> +                       && (self_flag & CI_ISP_DPD_BLACKLINES_TOP))) {
> +                       if ((main_flag & CI_ISP_DPD_ENABLE)
> +                           && (self_flag & CI_ISP_DPD_ENABLE)
> +                           && ((main_flag & CI_ISP_DPD_BLACKLINES_TOP)
> +                               != (self_flag & CI_ISP_DPD_BLACKLINES_TOP))) {
> +                               eprintk("and self path");
> +                               return CI_STATUS_NOTSUPP;
> +                       }
> +                       wnd_blackline.voffs = 0;
> +                       wnd_zoom_crop.voffs = 0;
> +               }
> +       }
> +
> +       source.out_w = wnd_zoom_crop.hsize;
> +       source.out_h = wnd_zoom_crop.vsize;
> +       source.flags = CI_ISP_DPD_DMA_IN_422;
> +
> +       /*to use crop set crop_flag first*/
> +       if (crop_flag) {
> +               wnd_zoom_crop.hsize = main->out_w;
> +               wnd_zoom_crop.vsize = main->out_h;
> +       }
> +
> +       dprintk(1, "source.out_w %d, source.out_h %d",
> +               source.out_w, source.out_h);
> +       if (main)
> +               dprintk(1, "main.out_w %d, main.out_h %d",
> +                       main->out_w, main->out_h);
> +       if (self)
> +               dprintk(1, "self.out_w %d, self.out_h %d",
> +                       self->out_w, self->out_h);
> +
> +       res = ci_calc_main_path_settings(&source, main, &scale_main,
> +                                        &mrv_mi_ctrl);
> +       if (res != CI_STATUS_SUCCESS)
> +               return res;
> +
> +       /* additional settings specific for main path fed from ISP */
> +       if (main_flag & CI_ISP_DPD_ENABLE) {
> +               switch (main_flag & CI_ISP_DPD_MODE_MASK) {
> +               case CI_ISP_DPD_MODE_ISPYC:
> +               case CI_ISP_DPD_MODE_ISPRAW:
> +               case CI_ISP_DPD_MODE_ISPRAW_16B:
> +               case CI_ISP_DPD_MODE_ISPJPEG:
> +                       break;
> +               default:
> +                       eprintk("data coming from the ISP");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +       }
> +
> +       /* basic selfpath settings */
> +       res = ci_calc_self_path_settings(&source, self, &scale_flag,
> +                                        &mrv_mi_ctrl);
> +       if (res != CI_STATUS_SUCCESS)
> +               return res;
> +
> +       if (sys_conf->isp_cfg.flags.ycbcr_non_cosited)
> +               mrv_mi_ctrl.mrv_mif_sp_in_phase = mrv_mif_col_phase_non_cosited;
> +       else
> +               mrv_mi_ctrl.mrv_mif_sp_in_phase = mrv_mif_col_phase_cosited;
> +       if (sys_conf->isp_cfg.flags.ycbcr_full_range)
> +               mrv_mi_ctrl.mrv_mif_sp_in_range = mrv_mif_col_range_full;
> +       else
> +               mrv_mi_ctrl.mrv_mif_sp_in_range = mrv_mif_col_range_std;
> +       if (self_flag & CI_ISP_DPD_ENABLE) {
> +               switch (self_flag & CI_ISP_DPD_MODE_MASK) {
> +               case CI_ISP_DPD_MODE_ISPYC:
> +                       break;
> +               default:
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +       }
> +
> +       /* Datapath multiplexers */
> +       res = ci_calc_dp_mux_settings(&mrv_mi_ctrl, &chn_mode, &dp_switch);
> +       if (res != CI_STATUS_SUCCESS)
> +               return res;
> +
> +       /* hardcoded global settings of the memory interface */
> +       mrv_mi_ctrl.byte_swap_enable = false;
> +
> +       mrv_mi_ctrl.init_vals = CI_ISP_MIF_INIT_OFFSAndBase;
> +
> +       /*to use crop set crop_flag first*/
> +       if (crop_flag) {
> +               wnd_blackline.hsize = main->out_w;
> +               wnd_blackline.vsize = main->out_h;
> +       }
> +
> +       res = ci_set_isp_windows(isi_config, &wnd_blackline,
> +                                &wnd_zoom_crop);
> +       if (res != CI_STATUS_SUCCESS) {
> +               eprintk("failed to set ISP window configuration");
> +               return res;
> +       }
> +       res = ci_isp_set_data_path(chn_mode, dp_switch);
> +       if (res != CI_STATUS_SUCCESS)
> +               return res;
> +
> +       res = ci_isp_set_mipi_smia(isi_config->mode);
> +       if (res != CI_STATUS_SUCCESS)
> +               return res;
> +
> +       if (mrv_mi_ctrl.self_path != CI_ISP_PATH_OFF)
> +               ci_isp_res_set_self_resize(&scale_flag,
> +                                          CI_ISP_CFG_UPDATE_IMMEDIATE,
> +                                          ci_get_rsz_lut(self_flag));
> +
> +       if (mrv_mi_ctrl.main_path != CI_ISP_PATH_OFF)
> +               ci_isp_res_set_main_resize(&scale_main,
> +                                          CI_ISP_CFG_UPDATE_IMMEDIATE,
> +                                          ci_get_rsz_lut(main_flag));
> +
> +       res = ci_isp_mif_set_path_and_orientation(&mrv_mi_ctrl);
> +       if (res != CI_STATUS_SUCCESS) {
> +               eprintk("failed to set MI path and orientation");
> +               return res;
> +       }
> +
> +       /* here the extended YCbCr mode is configured */
> +       if (sys_conf->isp_cfg.flags.ycbcr_full_range)
> +               res = ci_ext_ycb_cr_mode(main);
> +       else
> +               (void)ci_isp_set_yc_mode();
> +
> +       if (res != CI_STATUS_SUCCESS) {
> +               eprintk("failed to set ISP YCbCr extended mode");
> +               return res;
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> diff --git a/drivers/media/video/mrstci/mrstisp/mrstisp_hw.c b/drivers/media/video/mrstci/mrstisp/mrstisp_hw.c
> new file mode 100644
> index 0000000..ece0145
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/mrstisp_hw.c
> @@ -0,0 +1,1360 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include "mrstisp_stdinc.h"
> +
> +static unsigned long jiffies_start;
> +
> +void mrst_timer_start(void)
> +{
> +       jiffies_start = jiffies;
> +}
> +
> +void mrst_timer_stop(void)
> +{
> +       jiffies_start = 0;
> +}
> +
> +unsigned long mrst_get_micro_sec(void)
> +{
> +       unsigned long time_diff = 0;
> +
> +       time_diff = jiffies - jiffies_start;
> +
> +       return jiffies_to_msecs(time_diff);
> +}
> +
> +/*
> + * Returns the ISP hardware ID.
> + */
> +static u32 ci_isp_get_ci_isp_id(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 result = 0;
> +
> +       result = REG_GET_SLICE(mrv_reg->vi_id, MRV_REV_ID);
> +
> +       return result;
> +}
> +
> +/*
> + * Gets the hardware ID and compares it with the expected one.
> + */
> +static int ci_isp_verify_chip_id(void)
> +{
> +       u32 mrv_id = ci_isp_get_ci_isp_id();
> +       dprintk(1, "HW-Id: 0x%08X", mrv_id);
> +
> +       if (mrv_id != 0x20453010) {
> +         /* marvin5_v4_r20 */
> +               eprintk("HW-Id does not match! read:0x%08X, expected:0x%08X",
> +                       mrv_id, 0x20453010);
> +               return CI_STATUS_FAILURE;
> +       }
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Triggers an entire reset of MARVIN (equaling an asynchronous
> + * hardware reset).
> + * Checks the hardware ID. A debug warning is issued if the
> + * module ID does not match the expected ID.
> + * Enables all clocks of all sub-modules.
> + * MARVIN is in idle state afterwards.
> + */
> +void ci_isp_init(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       (void)ci_isp_verify_chip_id();
> +
> +       /* enable main clock */
> +       REG_SET_SLICE(mrv_reg->vi_ccl, MRV_VI_CCLFDIS, MRV_VI_CCLFDIS_ENABLE);
> +
> +       /*
> +        * enable all clocks to make sure that all submodules will be able to
> +        * perform the reset correctly
> +        */
> +       REG_SET_SLICE(mrv_reg->vi_iccl, MRV_VI_ALL_CLK_ENABLE, ENABLE);
> +       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_MARVIN_RST, ON);
> +       msleep(CI_ISP_DELAY_AFTER_RESET);
> +}
> +
> +void ci_isp_off(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       REG_SET_SLICE(mrv_reg->vi_ccl, MRV_VI_CCLFDIS,
> +                     MRV_VI_CCLFDIS_DISABLE);
> +       REG_SET_SLICE(mrv_reg->vi_iccl, MRV_VI_ALL_CLK_ENABLE, DISABLE);
> +}
> +
> +u32 ci_isp_get_frame_end_irq_mask_isp(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       switch (REG_GET_SLICE(mrv_reg->vi_dpcl, MRV_VI_DMA_SWITCH)) {
> +       case MRV_VI_DMA_SWITCH_IE:
> +               return 0;
> +       case MRV_VI_DMA_SWITCH_SELF:
> +       case MRV_VI_DMA_SWITCH_SI:
> +       case MRV_VI_DMA_SWITCH_JPG:
> +       default:
> +               {
> +                       switch (REG_GET_SLICE
> +                               (mrv_reg->vi_dpcl, MRV_VI_CHAN_MODE)) {
> +                       case MRV_VI_CHAN_MODE_MP:
> +                               return MRV_MI_MP_FRAME_END_MASK;
> +                       case MRV_VI_CHAN_MODE_SP:
> +                               return MRV_MI_SP_FRAME_END_MASK;
> +                       case MRV_VI_CHAN_MODE_MP_SP:
> +                               return MRV_MI_MP_FRAME_END_MASK |
> +                                   MRV_MI_SP_FRAME_END_MASK;
> +                       default:
> +                               return 0;
> +                       }
> +               }
> +       }
> +
> +}
> +
> +/*
> + * Programs the number of frames to capture. Clears frame end
> + * interrupt to allow waiting in ci_isp_wait_for_frame_end().
> + * Enables the ISP input acquisition and output formatter.
> + * If immediate=false, the hardware assures that enabling is
> + * done frame synchronously.
> + */
> +void ci_isp_start(u16 number_of_frames,
> +                 enum ci_isp_conf_update_time update_time)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
> +       u32 eof_irq_mask = ci_isp_get_frame_end_irq_mask_isp();
> +
> +       /* max. 10 bits allowed */
> +       WARN_ON(!(number_of_frames <= MRV_ISP_ACQ_NR_FRAMES_MAX));
> +       REG_SET_SLICE(mrv_reg->isp_acq_nr_frames, MRV_ISP_ACQ_NR_FRAMES,
> +                     number_of_frames);
> +
> +       /* clear frame end interrupt */
> +       REG_WRITE(mrv_reg->mi_icr, eof_irq_mask);
> +
> +       /*
> +        * Input Acquisition is always enabled synchronous to the image sensor
> +        * (no configuration update required). As soon as the input
> +        * acquisition is started bit in_enable_shd in the register
> +        * isp_flags_shd is set by hardware. In the following a frame end
> +        * recognized by the input acquisition unit leads to
> +        * ris_in_frame_end=1 in isp_ris. However a recognized frame end and
> +        * no signaled errors are no guarantee for a valid configuration.
> +        */
> +
> +       /*
> +        * The output formatter is enabled frame synchronously according to
> +        * the internal sync signals. Bit MRV_GEN_CFG_UPD has to be set. Bit
> +        * isp_on_shd in isp_flags_shd is set when the output formatter is
> +        * started. A recognized frame end is signaled with ris_out_frame_end
> +        * in isp_ris.
> +        */
> +
> +       /*
> +        * The configuration of the input acquisition and the output
> +        * formatter has to be correct to generate proper internal sync
> +        * signals and thus a proper frame-synchronous update signal.
> +        */
> +
> +       /* If the output formatter does not start check the following:
> +        * sync polarities
> +        * sample edge
> +        * mode in register isp_ctrl
> +        * sampling window of input acquisition <= picture size of image
> +        * sensor
> +        * output formatter window <= sampling window of input
> +        * acquisition
> +        */
> +
> +       /*
> +        * If problems with the window sizes are suspected preferably add some
> +        * offsets and reduce the window sizes, so that the above relations
> +        * are true by all means.
> +        */
> +
> +       switch (update_time) {
> +       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ENABLE);
> +               break;
> +       case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CFG_UPD, ENABLE);
> +               break;
> +       case CI_ISP_CFG_UPDATE_LATER:
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_INFORM_ENABLE, ENABLE);
> +       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_ENABLE, ENABLE);
> +       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
> +
> +       dprintk(3, "ISP_CTRL  = 0x%08X", mrv_reg->isp_ctrl);
> +}
> +
> +/*
> + * Clear frame end interrupt to allow waiting in
> + * ci_isp_wait_for_frame_end(). Disable output formatter (frame
> + * synchronously).
> + */
> +void ci_isp_stop(enum ci_isp_conf_update_time update_time)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
> +       u32 eof_irq_mask = ci_isp_get_frame_end_irq_mask_isp();
> +
> +       /* clear frame end interrupt */
> +       REG_WRITE(mrv_reg->mi_icr, eof_irq_mask);
> +       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_ENABLE, DISABLE);
> +
> +       switch (update_time) {
> +       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ENABLE);
> +               break;
> +       case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CFG_UPD, ENABLE);
> +               break;
> +       case CI_ISP_CFG_UPDATE_LATER:
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
> +}
> +
> +/*
> + * Changes the data path settings.
> + */
> +int ci_isp_set_data_path(enum ci_isp_ycs_chn_mode ycs_chn_mode,
> +                        enum ci_isp_dp_switch dp_switch)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 vi_dpcl = REG_READ(mrv_reg->vi_dpcl);
> +       u32 vi_chan_mode;
> +       u32 vi_mp_mux;
> +
> +       /* get desired setting for ycs_chan_mode (or vi_chan_mode) bits */
> +       switch (ycs_chn_mode) {
> +       case CI_ISP_YCS_OFF:
> +               vi_chan_mode = MRV_VI_CHAN_MODE_OFF;
> +               break;
> +       case CI_ISP_YCS_Y:
> +               vi_chan_mode = MRV_VI_CHAN_MODE_Y;
> +               break;
> +       case CI_ISP_YCS_MVRaw:
> +               vi_chan_mode = MRV_VI_CHAN_MODE_MP_RAW;
> +               break;
> +       case CI_ISP_YCS_MV:
> +               vi_chan_mode = MRV_VI_CHAN_MODE_MP;
> +               break;
> +       case CI_ISP_YCS_SP:
> +               vi_chan_mode = MRV_VI_CHAN_MODE_SP;
> +               break;
> +       case CI_ISP_YCS_MV_SP:
> +               vi_chan_mode = MRV_VI_CHAN_MODE_MP_SP;
> +               break;
> +       default:
> +               eprintk("unknown value for ycs_chn_mode");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       if (vi_chan_mode & ~(MRV_VI_CHAN_MODE_MASK >> MRV_VI_CHAN_MODE_SHIFT)) {
> +               eprintk("enum ci_isp_ycs_chn_mode not supported");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       /* get desired setting for vi_dp_switch (or vi_dp_mux) bits */
> +       switch (dp_switch) {
> +       case CI_ISP_DP_RAW:
> +               vi_mp_mux = MRV_VI_MP_MUX_RAW;
> +               break;
> +       case CI_ISP_DP_JPEG:
> +               vi_mp_mux = MRV_VI_MP_MUX_JPEG;
> +               break;
> +       case CI_ISP_DP_MV:
> +               vi_mp_mux = MRV_VI_MP_MUX_MP;
> +               break;
> +       default:
> +               eprintk("unknown value for dp_switch");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       if (vi_mp_mux & ~MRV_VI_MP_MUX_MASK) {
> +               eprintk("dp_switch value not supported");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       /* program settings into MARVIN vi_dpcl register */
> +       REG_SET_SLICE(vi_dpcl, MRV_VI_CHAN_MODE, vi_chan_mode);
> +       REG_SET_SLICE(vi_dpcl, MRV_VI_MP_MUX, vi_mp_mux);
> +       REG_WRITE(mrv_reg->vi_dpcl, vi_dpcl);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Changes the data path settings to SMIA or MIPI.
> + */
> +int ci_isp_set_mipi_smia(u32 mode)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 if_select;
> +
> +       /* get desired setting for if_select bits */
> +       switch (mode) {
> +       case SENSOR_MODE_SMIA:
> +               if_select = MRV_IF_SELECT_SMIA;
> +               break;
> +       case SENSOR_MODE_MIPI:
> +               if_select = MRV_IF_SELECT_MIPI;
> +               break;
> +       case SENSOR_MODE_BAYER:
> +       case SENSOR_MODE_BT601:
> +       case SENSOR_MODE_BT656:
> +       case SENSOR_MODE_PICT:
> +       case SENSOR_MODE_DATA:
> +       case SENSOR_MODE_BAY_BT656:
> +       case SENSOR_MODE_RAW_BT656:
> +               if_select = MRV_IF_SELECT_PAR;
> +               break;
> +       default:
> +               eprintk("unknown value for mode");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       /* program settings into MARVIN vi_dpcl register */
> +       REG_SET_SLICE(mrv_reg->vi_dpcl, MRV_IF_SELECT, if_select);
> +
> +       if (if_select == MRV_IF_SELECT_MIPI)
> +               REG_WRITE(mrv_reg->mipi_ctrl, 0x1001);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Waits until the specified bits becomes signaled in the mi_ris
> + * register.
> + */
> +static int ci_isp_wait_for_mi(struct mrst_isp_device *intel, u32 bit_mask)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 irq;
> +       static int err_frame_cnt;
> +       mrst_timer_start();
> +       /*
> +        * Wait for the curr BitMask. If the BitMask is zero, then it's no
> +        * waiting.
> +        */
> +       while ((mrv_reg->mi_ris & bit_mask) != bit_mask) {
> +
> +               irq = REG_READ(mrv_reg->isp_ris);
> +               if (irq & (MRV_ISP_RIS_DATA_LOSS_MASK
> +                          | MRV_ISP_RIS_PIC_SIZE_ERR_MASK)){
> +                       err_frame_cnt++;
> +                       dprintk(1, "irq = 0x%x, err rumber = %d", irq,
> +                               err_frame_cnt);
> +               }
> +               if (mrst_get_micro_sec() > 1000) {
> +                       dprintk(1, "time out");
> +                       mrst_timer_stop();
> +                       /*
> +                        * Try to recover. Softreset of submodules (but not
> +                        * entire marvin) resets processing and status
> +                        * information, but not configuration register
> +                        * content. Bits are sticky. So we have to clear them.
> +                        * Reset affects the MARVIN 1..2 clock cycles after
> +                        * the bits are set to high. So we don't have to wait
> +                        * in software before clearing them.
> +                        */
> +                       REG_SET_SLICE(mrv_reg->vi_ircl,
> +                                     MRV_VI_ALL_SOFT_RST, ON);
> +                       REG_SET_SLICE(mrv_reg->vi_ircl,
> +                                     MRV_VI_ALL_SOFT_RST, OFF);
> +                       msleep(CI_ISP_DELAY_AFTER_RESET);
> +                       REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_CFG_UPD,
> +                                     ON);
> +                       return CI_STATUS_FAILURE;
> +               }
> +       }
> +
> +       mrst_timer_stop();
> +       if (REG_GET_SLICE(mrv_reg->isp_ris, MRV_ISP_RIS_DATA_LOSS))
> +               dprintk(1, "no failure, but MRV_ISPINT_DATA_LOSS");
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Waits until a frame is written to memory (frame end
> + * interrupt occurs).
> + * Waits for the frame end interrupt of the memory
> + * interface.
> + */
> +int ci_isp_wait_for_frame_end(struct mrst_isp_device *intel)
> +{
> +       return ci_isp_wait_for_mi(intel, ci_isp_get_frame_end_irq_mask_isp());
> +}
> +
> +void ci_isp_reset_interrupt_status(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       /* ISP interrupt clear register */
> +       REG_SET_SLICE(mrv_reg->isp_icr, MRV_ISP_ICR_ALL, ON);
> +       REG_SET_SLICE(mrv_reg->isp_err_clr, MRV_ISP_ALL_ERR, ON);
> +       REG_SET_SLICE(mrv_reg->mi_icr, MRV_MI_ALLIRQS, ON);
> +       /* JPEG error interrupt clear register */
> +       REG_SET_SLICE(mrv_reg->jpe_error_icr, MRV_JPE_ALL_ERR, ON);
> +       /* JPEG status interrupt clear register */
> +       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ALL_STAT, ON);
> +
> +       REG_WRITE(mrv_reg->mipi_icr, 0xffffffff);
> +}
> +
> +void mrst_isp_disable_interrupt(struct mrst_isp_device *isp)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
> +       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_ALL, OFF);
> +       REG_SET_SLICE(mrv_reg->mi_imsc, MRV_MI_ALLIRQS, OFF);
> +       REG_SET_SLICE(mrv_reg->jpe_error_imr, MRV_JPE_ALL_ERR, OFF);
> +       REG_SET_SLICE(mrv_reg->jpe_status_imr, MRV_JPE_ALL_STAT, OFF);
> +       REG_WRITE(mrv_reg->mipi_imsc, 0x00000000);
> +}
> +
> +void mrst_isp_enable_interrupt(struct mrst_isp_device *isp)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
> +
> +       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_DATA_LOSS, ON);
> +       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_PIC_SIZE_ERR, ON);
> +       REG_WRITE(mrv_reg->mi_imsc, MRV_MI_MP_FRAME_END_MASK);
> +       REG_SET_SLICE(mrv_reg->mi_imsc, MRV_MI_MBLK_LINE, ON);
> +       REG_SET_SLICE(mrv_reg->jpe_error_imr, MRV_JPE_ALL_ERR, ON);
> +       REG_SET_SLICE(mrv_reg->jpe_status_imr, MRV_JPE_ALL_STAT, ON);
> +       REG_WRITE(mrv_reg->mipi_imsc, 0x00f00000);
> +
> +       ci_isp_reset_interrupt_status();
> +}
> +
> +/*
> + * Set extended mode with unrestricted values for YCbCr
> + * Y (0-255) CbCr (0-255)
> + */
> +void ci_isp_set_ext_ycmode(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
> +
> +       /* modify isp_ctrl register */
> +       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_C_RANGE,
> +                     MRV_ISP_ISP_CSM_C_RANGE_FULL);
> +       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_Y_RANGE,
> +                     MRV_ISP_ISP_CSM_Y_RANGE_FULL);
> +       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
> +
> +       /* program RGB to YUV color conversion with extended range */
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0, 0x0026);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1, 0x004B);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2, 0x000F);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3, 0x01EA);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4, 0x01D6);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5, 0x0040);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6, 0x0040);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7, 0x01CA);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8, 0x01F6);
> +}
> +
> +void ci_isp_set_yc_mode(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
> +       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
> +
> +       /* modify isp_ctrl register */
> +       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_C_RANGE,
> +               MRV_ISP_ISP_CSM_Y_RANGE_BT601);
> +       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_Y_RANGE,
> +               MRV_ISP_ISP_CSM_Y_RANGE_BT601);
> +       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
> +
> +       /* program RGB to YUV color conversion with extended range */
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0, 0x0021);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1, 0x0040);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2, 0x000D);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3, 0x01ED);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4, 0x01DB);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5, 0x0038);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6, 0x0038);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7, 0x01D1);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8, 0x01F7);
> +}
> +
> +/*
> + * writes the color values for contrast, brightness,
> + * saturation and hue into the appropriate Marvin
> + * registers
> + */
> +void ci_isp_col_set_color_processing(
> +       const struct ci_isp_color_settings *col)
> +{
> +       struct isp_register *mrv_reg =
> +           (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (col == NULL)
> +               mrv_reg->c_proc_ctrl = 0;
> +       else {
> +               mrv_reg->c_proc_contrast = col->contrast;
> +               mrv_reg->c_proc_brightness = col->brightness;
> +               mrv_reg->c_proc_saturation = col->saturation;
> +               mrv_reg->c_proc_hue = col->hue;
> +
> +               if (col->flags & CI_ISP_CPROC_C_OUT_RANGE) {
> +                       mrv_reg->c_proc_ctrl =
> +                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_C_OUT_RANGE;
> +               }
> +
> +               if (col->flags & CI_ISP_CPROC_Y_IN_RANGE) {
> +                       mrv_reg->c_proc_ctrl =
> +                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_Y_IN_RANGE;
> +               }
> +
> +               if (col->flags & CI_ISP_CPROC_Y_OUT_RANGE) {
> +                       mrv_reg->c_proc_ctrl =
> +                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_Y_OUT_RANGE;
> +               }
> +
> +               if (col->flags & CI_ISP_CPROC_ENABLE) {
> +                       mrv_reg->c_proc_ctrl =
> +                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_ENABLE;
> +               }
> +       }
> +}
> +
> +/*
> + * Translates a chrominance component value from usual
> + * representation (range 16..240, 128=neutral grey)
> + * to the one used by the ie_tint register
> + * The value is returned as 32 bit unsigned to support shift
> + * operation without explicit cast.
> + * The translation formular implemented here is taken from
> + * the image effects functional specification document,
> + * Doc-ID 30-001-481.130, revision 1.1 from november, 21st. 2005
> + */
> +static u32 ci_isp_ie_tint_cx2_reg_val(u8 cx)
> +{
> +       s32 temp;
> +       u32 reg_val;
> +
> +       temp = 128 - (s32) cx;
> +       temp = ((temp * 64) / 110);
> +
> +       /* convert from two's complement to sign/value */
> +       if (temp < 0) {
> +               reg_val = 0x80;
> +               temp *= (-1);
> +       } else
> +               reg_val = 0;
> +
> +       /* saturate at 7 bits */
> +       if (temp > 0x7F)
> +               temp = 0x7F;
> +
> +       /* combine sign and value to build the regiter value */
> +       reg_val |= (u32) temp;
> +
> +       return reg_val;
> +}
> +
> +/*
> + * Translates usual (decimal) matrix coefficient into the
> + * 4 bit  register representation (used in the ie_mat_X registers).
> + * for unsupported decimal numbers, a supported replacement is
> + * selected automatically.
> + * The value is returned as 32 bit unsigned to support shift
> + * operation without explicit cast.
> + * The translation formular implemented here is taken from
> + * the image effects functional specification document,
> + * Doc-ID 30-001-481.130, revision 1.1 from november, 21st. 2005
> + */
> +static u32 ci_isp_ie_mx_dec2_reg_val(s8 dec)
> +{
> +       if (dec <= (-6)) {
> +               /* equivlent to -8 */

typo: equivalent

> +               return 0x0f;
> +       } else if (dec <= (-3)) {
> +               /* equivlent to -4 */
> +               return 0x0e;
> +       } else if (dec == (-2)) {
> +               /* equivlent to -2 */
> +               return 0x0d;
> +       } else if (dec == (-1)) {
> +               /* equivlent to -1 */
> +               return 0x0c;
> +       } else if (dec == 0) {
> +               /* equivlent to 0 (entry not used) */
> +               return 0x00;
> +       } else if (dec == 1) {
> +               /* equivlent to 1 */
> +               return 0x08;
> +       } else if (dec == 2) {
> +               /* equivlent to 2 */
> +               return 0x09;
> +       } else if (dec < 6) {

Huh? This is already handled by the first 'if'!

> +               /* equivlent to 4 */
> +               return 0x0a;
> +       } else {
> +               /* equivlent to 8 */
> +               return 0x0b;
> +       }

Use a switch instead and have the default case handle the < and > cases.

> +}
> +
> +/*
> + * translates the values of the given configuration
> + * structure into register settings for the image effects
> + * submodule and loads the registers.
> + */
> +int ci_isp_ie_set_config(const struct ci_isp_ie_config *ie_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (!ie_config) {
> +               REG_SET_SLICE(mrv_reg->img_eff_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                             MRV_IMGEFF_BYPASS_MODE_BYPASS);
> +       } else {
> +               /* apply the given settings */
> +               u32 ul_ie_ctrl = REG_READ(mrv_reg->img_eff_ctrl);
> +               u32 ul_ie_csel = REG_READ(mrv_reg->img_eff_color_sel);
> +               u32 ul_ie_tint = REG_READ(mrv_reg->img_eff_tint);
> +               u32 ul_ie_mat1 = REG_READ(mrv_reg->img_eff_mat_1);
> +               u32 ul_ie_mat2 = REG_READ(mrv_reg->img_eff_mat_2);
> +               u32 ul_ie_mat3 = REG_READ(mrv_reg->img_eff_mat_3);
> +               u32 ul_ie_mat4 = REG_READ(mrv_reg->img_eff_mat_4);
> +               u32 ul_ie_mat5 = REG_READ(mrv_reg->img_eff_mat_5);
> +
> +               /* overall operation mode */
> +               switch (ie_config->mode) {
> +               case CI_ISP_IE_MODE_OFF:
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                                     MRV_IMGEFF_BYPASS_MODE_BYPASS);
> +                       break;
> +               case CI_ISP_IE_MODE_GRAYSCALE:
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
> +                                     MRV_IMGEFF_EFFECT_MODE_GRAY);
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
> +                       break;
> +               case CI_ISP_IE_MODE_NEGATIVE:
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
> +                                     MRV_IMGEFF_EFFECT_MODE_NEGATIVE);
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
> +                       break;
> +               case CI_ISP_IE_MODE_SEPIA:
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
> +                                     MRV_IMGEFF_EFFECT_MODE_SEPIA);
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
> +                       break;
> +               case CI_ISP_IE_MODE_COLOR_SEL:
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
> +                                     MRV_IMGEFF_EFFECT_MODE_COLOR_SEL);
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
> +                       break;
> +               case CI_ISP_IE_MODE_EMBOSS:
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
> +                                     MRV_IMGEFF_EFFECT_MODE_EMBOSS);
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
> +                       break;
> +               case CI_ISP_IE_MODE_SKETCH:
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
> +                                     MRV_IMGEFF_EFFECT_MODE_SKETCH);
> +                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
> +                                     MRV_IMGEFF_BYPASS_MODE_PROCESS);
> +                       break;
> +               default:
> +                       return CI_STATUS_OUTOFRANGE;
> +               }
> +
> +               /* use next frame sync update */
> +               REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_CFG_UPD, ON);
> +
> +               /* color selection settings */
> +               REG_SET_SLICE(ul_ie_csel, MRV_IMGEFF_COLOR_THRESHOLD,
> +                             (u32) (ie_config->color_thres));
> +               REG_SET_SLICE(ul_ie_csel, MRV_IMGEFF_COLOR_SELECTION,
> +                             (u32) (ie_config->color_sel));
> +
> +               /* tint color settings */
> +               REG_SET_SLICE(ul_ie_tint, MRV_IMGEFF_INCR_CB,
> +                             ci_isp_ie_tint_cx2_reg_val(ie_config->tint_cb));
> +               REG_SET_SLICE(ul_ie_tint, MRV_IMGEFF_INCR_CR,
> +                             ci_isp_ie_tint_cx2_reg_val(ie_config->tint_cr));
> +
> +               /* matrix coefficients */
> +               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_11_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_11));
> +               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_12_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_12));
> +               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_13_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_13));
> +               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_21_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_21));
> +               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_22_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_22));
> +               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_23_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_23));
> +               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_31_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_31));
> +               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_32_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_32));
> +               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_EMB_COEF_33_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
> +                   coeff_33));
> +               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_11_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_11));
> +               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_12_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_12));
> +               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_13_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_13));
> +               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_21_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_21));
> +               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_22_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_22));
> +               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_23_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_23));
> +               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_31_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_31));
> +               REG_SET_SLICE(ul_ie_mat5, MRV_IMGEFF_SKET_COEF_32_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_32));
> +               REG_SET_SLICE(ul_ie_mat5, MRV_IMGEFF_SKET_COEF_33_4,
> +                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
> +                   coeff_33));
> +
> +               /* write changed values back to registers */
> +               REG_WRITE(mrv_reg->img_eff_ctrl, ul_ie_ctrl);
> +               REG_WRITE(mrv_reg->img_eff_color_sel, ul_ie_csel);
> +               REG_WRITE(mrv_reg->img_eff_tint, ul_ie_tint);
> +               REG_WRITE(mrv_reg->img_eff_mat_1, ul_ie_mat1);
> +               REG_WRITE(mrv_reg->img_eff_mat_2, ul_ie_mat2);
> +               REG_WRITE(mrv_reg->img_eff_mat_3, ul_ie_mat3);
> +               REG_WRITE(mrv_reg->img_eff_mat_4, ul_ie_mat4);
> +               REG_WRITE(mrv_reg->img_eff_mat_5, ul_ie_mat5);
> +
> +               /* frame synchronous update of shadow registers */
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ON);
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Applies the new image stabilisation settings to the module.
> + */
> +int ci_isp_is_set_config(const struct ci_isp_is_config *is_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (!is_config) {
> +               eprintk("is_config NULL");
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       /* set maximal margin distance for X */
> +       if (is_config->max_dx > MRV_IS_IS_MAX_DX_MAX) {
> +               REG_SET_SLICE(mrv_reg->isp_is_max_dx, MRV_IS_IS_MAX_DX,
> +                             (u32) (MRV_IS_IS_MAX_DX_MAX));
> +       } else {
> +               REG_SET_SLICE(mrv_reg->isp_is_max_dx, MRV_IS_IS_MAX_DX,
> +                             (u32) (is_config->max_dx));
> +       }
> +
> +       /* set maximal margin distance for Y */
> +       if (is_config->max_dy > MRV_IS_IS_MAX_DY_MAX) {
> +               REG_SET_SLICE(mrv_reg->isp_is_max_dy, MRV_IS_IS_MAX_DY,
> +                             (u32) (MRV_IS_IS_MAX_DY_MAX));
> +       } else {
> +               REG_SET_SLICE(mrv_reg->isp_is_max_dy, MRV_IS_IS_MAX_DY,
> +                             (u32) (is_config->max_dy));
> +       }
> +
> +       REG_SET_SLICE(mrv_reg->isp_is_h_offs, MRV_IS_IS_H_OFFS,
> +                     (u32) (is_config->mrv_is_window.hoffs));
> +       REG_SET_SLICE(mrv_reg->isp_is_v_offs, MRV_IS_IS_V_OFFS,
> +                     (u32) (is_config->mrv_is_window.voffs));
> +       REG_SET_SLICE(mrv_reg->isp_is_h_size, MRV_IS_IS_H_SIZE,
> +                     (u32) (is_config->mrv_is_window.hsize));
> +       REG_SET_SLICE(mrv_reg->isp_is_v_size, MRV_IS_IS_V_SIZE,
> +                     (u32) (is_config->mrv_is_window.vsize));
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +static int ci_isp_bls_set_fixed_values(const struct ci_isp_bls_subtraction
> +                                      *bls_subtraction)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (!bls_subtraction)
> +               return CI_STATUS_NULL_POINTER;
> +
> +       if ((bls_subtraction->fixed_a > MRV_ISP_BLS_FIX_SUB_MAX) ||
> +           (bls_subtraction->fixed_b > MRV_ISP_BLS_FIX_SUB_MAX) ||
> +           (bls_subtraction->fixed_c > MRV_ISP_BLS_FIX_SUB_MAX) ||
> +           (bls_subtraction->fixed_d > MRV_ISP_BLS_FIX_SUB_MAX) ||
> +           (bls_subtraction->fixed_a < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
> +           (bls_subtraction->fixed_b < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
> +           (bls_subtraction->fixed_c < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
> +           (bls_subtraction->fixed_d < (s16) MRV_ISP_BLS_FIX_SUB_MIN)) {
> +               return CI_STATUS_OUTOFRANGE;
> +       } else {
> +               REG_SET_SLICE(mrv_reg->isp_bls_a_fixed, MRV_BLS_BLS_A_FIXED,
> +                             bls_subtraction->fixed_a);
> +               REG_SET_SLICE(mrv_reg->isp_bls_b_fixed, MRV_BLS_BLS_B_FIXED, \
> +                             bls_subtraction->fixed_b);
> +               REG_SET_SLICE(mrv_reg->isp_bls_c_fixed, MRV_BLS_BLS_C_FIXED,
> +                             bls_subtraction->fixed_c);
> +               REG_SET_SLICE(mrv_reg->isp_bls_d_fixed, MRV_BLS_BLS_D_FIXED,
> +                             bls_subtraction->fixed_d);
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Sets the desired configuration values to the BLS registers,
> + * if possible. In the case the parameter (bls_config == NULL)
> + * the BLS module will be deactivated.
> + */
> +int ci_isp_bls_set_config(const struct ci_isp_bls_config *bls_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_bls_ctrl = 0;
> +
> +       int error = CI_STATUS_FAILURE;
> +
> +       if (!bls_config) {
> +               REG_SET_SLICE(mrv_reg->isp_bls_ctrl,
> +                       MRV_BLS_BLS_ENABLE, DISABLE);
> +               return CI_STATUS_SUCCESS;
> +       }
> +
> +       /* measurement window 2, enable_window =0 */
> +       if (bls_config->isp_bls_window2.enable_window) {
> +               if ((bls_config->isp_bls_window2.start_h >
> +                    MRV_BLS_BLS_H2_START_MAX)
> +                   || (bls_config->isp_bls_window2.stop_h >
> +                       MRV_BLS_BLS_H2_STOP_MAX)
> +                   || (bls_config->isp_bls_window2.start_v >
> +                       MRV_BLS_BLS_V2_START_MAX)
> +                   || (bls_config->isp_bls_window2.stop_v >
> +                       MRV_BLS_BLS_V2_STOP_MAX)) {
> +                       return CI_STATUS_OUTOFRANGE;
> +               } else {
> +                       REG_SET_SLICE(mrv_reg->isp_bls_h2_start,
> +                                     MRV_BLS_BLS_H2_START,
> +                                     bls_config->isp_bls_window2.start_h);
> +                       REG_SET_SLICE(mrv_reg->isp_bls_h2_stop,
> +                                     MRV_BLS_BLS_H2_STOP,
> +                                     bls_config->isp_bls_window2.stop_h);
> +                       REG_SET_SLICE(mrv_reg->isp_bls_v2_start,
> +                                     MRV_BLS_BLS_V2_START,
> +                                     bls_config->isp_bls_window2.start_v);
> +                       REG_SET_SLICE(mrv_reg->isp_bls_v2_stop,
> +                                     MRV_BLS_BLS_V2_STOP,
> +                                     bls_config->isp_bls_window2.stop_v);
> +               }
> +       }
> +
> +       /* measurement window 1, enable_window=0 */
> +       if (bls_config->isp_bls_window1.enable_window) {
> +               if ((bls_config->isp_bls_window1.start_h >
> +                    MRV_BLS_BLS_H1_START_MAX)
> +                   || (bls_config->isp_bls_window1.stop_h >
> +                       MRV_BLS_BLS_H1_STOP_MAX)
> +                   || (bls_config->isp_bls_window1.start_v >
> +                       MRV_BLS_BLS_V1_START_MAX)
> +                   || (bls_config->isp_bls_window1.stop_v >
> +                       MRV_BLS_BLS_V1_STOP_MAX)) {
> +                       return CI_STATUS_OUTOFRANGE;
> +               } else {
> +                       REG_SET_SLICE(mrv_reg->isp_bls_h1_start,
> +                                     MRV_BLS_BLS_H1_START,
> +                                     bls_config->isp_bls_window1.start_h);
> +                       REG_SET_SLICE(mrv_reg->isp_bls_h1_stop,
> +                                     MRV_BLS_BLS_H1_STOP,
> +                                     bls_config->isp_bls_window1.stop_h);
> +                       REG_SET_SLICE(mrv_reg->isp_bls_v1_start,
> +                                     MRV_BLS_BLS_V1_START,
> +                                     bls_config->isp_bls_window1.start_v);
> +                       REG_SET_SLICE(mrv_reg->isp_bls_v1_stop,
> +                                     MRV_BLS_BLS_V1_STOP,
> +                                     bls_config->isp_bls_window1.stop_v);
> +               }
> +       }
> +
> +       if (bls_config->bls_samples > MRV_BLS_BLS_SAMPLES_MAX) {
> +               return CI_STATUS_OUTOFRANGE;
> +       } else {
> +               REG_SET_SLICE(mrv_reg->isp_bls_samples, MRV_BLS_BLS_SAMPLES,
> +                             bls_config->bls_samples);
> +       }
> +
> +       /* fixed subtraction values, enable_automatic=0 */
> +       if (!bls_config->enable_automatic) {
> +               error = ci_isp_bls_set_fixed_values(
> +                   &(bls_config->bls_subtraction));
> +               if (error != CI_STATUS_SUCCESS)
> +                       return error;
> +       }
> +
> +       if ((bls_config->disable_h) || (bls_config->disable_v))
> +               return CI_STATUS_OUTOFRANGE;
> +
> +       isp_bls_ctrl = REG_READ(mrv_reg->isp_bls_ctrl);
> +
> +       /* enable measurement window(s) */
> +       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_WINDOW_ENABLE,
> +                     ((bls_config->isp_bls_window1.enable_window)
> +                     ? MRV_BLS_WINDOW_ENABLE_WND1 : 0) |
> +                     ((bls_config->isp_bls_window2.enable_window)
> +                     ? MRV_BLS_WINDOW_ENABLE_WND2 : 0));
> +
> +       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_BLS_MODE,
> +                     (bls_config->enable_automatic) ? MRV_BLS_BLS_MODE_MEAS :
> +                     MRV_BLS_BLS_MODE_FIX);
> +
> +       /* enable module */
> +       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_BLS_ENABLE, ENABLE);
> +
> +       /* write into register */
> +       REG_WRITE(mrv_reg->isp_bls_ctrl, isp_bls_ctrl);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +#define RSZ_FLAGS_MASK (RSZ_UPSCALE_ENABLE | RSZ_SCALER_BYPASS)
> +
> +/*
> + * writes the scaler values to the appropriate Marvin registers.
> + */
> +void ci_isp_res_set_main_resize(const struct ci_isp_scale *scale,
> +                               enum ci_isp_conf_update_time update_time,
> +                               const struct ci_isp_rsz_lut *rsz_lut)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 mrsz_ctrl = REG_READ(mrv_reg->mrsz_ctrl);
> +       u32 i;
> +       int upscaling = false;
> +
> +       /* flags must be "outside" scaler value */
> +       WARN_ON(!((RSZ_FLAGS_MASK & MRV_RSZ_SCALE_MASK) == 0));
> +       WARN_ON(!((scale->scale_hy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_hcb & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_hcr & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_vy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_vc & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +
> +       /* horizontal luminance scale factor */
> +       dprintk(1, "scale_hy = %d( %x )", scale->scale_hy, scale->scale_hy);
> +
> +       if (scale->scale_hy & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_ENABLE, DISABLE);
> +       } else {
> +               /* enable scaler */
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_ENABLE, ENABLE);
> +               /* program scale factor and phase */
> +               REG_SET_SLICE(mrv_reg->mrsz_scale_hy, MRV_MRSZ_SCALE_HY,
> +                             (u32) scale->scale_hy);
> +               REG_SET_SLICE(mrv_reg->mrsz_phase_hy, MRV_MRSZ_PHASE_HY,
> +                             (u32) scale->phase_hy);
> +
> +               if (scale->scale_hy & RSZ_UPSCALE_ENABLE) {
> +                       /* enable upscaling mode */
> +                       dprintk(1, "enable up scale");
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_UP,
> +                                     MRV_MRSZ_SCALE_HY_UP_UPSCALE);
> +                       /* scaler and upscaling enabled */
> +                       upscaling = true;
> +               } else
> +                       /* disable upscaling mode */
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_UP,
> +                                     MRV_MRSZ_SCALE_HY_UP_DOWNSCALE);
> +       }
> +
> +       /* horizontal chrominance scale factors */
> +       WARN_ON(!((scale->scale_hcb & RSZ_FLAGS_MASK) == (scale->scale_hcr &
> +                                                         RSZ_FLAGS_MASK)));
> +       dprintk(1, "scale_hcb  = %d( %x )", scale->scale_hcb, scale->scale_hcb);
> +
> +       if (scale->scale_hcb & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_ENABLE, DISABLE);
> +       } else {
> +               /* enable scaler */
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_ENABLE, ENABLE);
> +               /* program scale factor and phase */
> +               REG_SET_SLICE(mrv_reg->mrsz_scale_hcb, MRV_MRSZ_SCALE_HCB,
> +                             (u32) scale->scale_hcb);
> +               REG_SET_SLICE(mrv_reg->mrsz_scale_hcr, MRV_MRSZ_SCALE_HCB,
> +                             (u32) scale->scale_hcr);
> +               REG_SET_SLICE(mrv_reg->mrsz_phase_hc, MRV_MRSZ_PHASE_HC,
> +                             (u32) scale->phase_hc);
> +
> +               if (scale->scale_hcb & RSZ_UPSCALE_ENABLE) {
> +                       /* enable upscaling mode */
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_UP,
> +                                     MRV_MRSZ_SCALE_HC_UP_UPSCALE);
> +                       /* scaler and upscaling enabled */
> +                       upscaling = true;
> +               } else {
> +                       /* disable upscaling mode */
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_UP,
> +                                     MRV_MRSZ_SCALE_HC_UP_DOWNSCALE);
> +               }
> +       }
> +
> +       /* vertical luminance scale factor */
> +       dprintk(1, "scale_vy = %d ( %x )", scale->scale_vy, scale->scale_vy);
> +
> +       if (scale->scale_vy & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_ENABLE,
> +                             DISABLE);
> +       } else {
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_ENABLE, ENABLE);
> +               REG_SET_SLICE(mrv_reg->mrsz_scale_vy, MRV_MRSZ_SCALE_VY,
> +                   (u32) scale->scale_vy);
> +               REG_SET_SLICE(mrv_reg->mrsz_phase_vy, MRV_MRSZ_PHASE_VY,
> +                   (u32) scale->phase_vy);
> +
> +               if (scale->scale_vy & RSZ_UPSCALE_ENABLE) {
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_UP,
> +                                     MRV_MRSZ_SCALE_VY_UP_UPSCALE);
> +                       upscaling = true;
> +               } else {
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_UP,
> +                                     MRV_MRSZ_SCALE_VY_UP_DOWNSCALE);
> +               }
> +       }
> +
> +       /* vertical chrominance scale factor */
> +       dprintk(1, "scale_vc = %d( %x )", scale->scale_vc, scale->scale_vc);
> +
> +       if (scale->scale_vc & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_ENABLE,
> +                             DISABLE);
> +       } else {
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_ENABLE, ENABLE);
> +               REG_SET_SLICE(mrv_reg->mrsz_scale_vc, MRV_MRSZ_SCALE_VC,
> +                             (u32) scale->scale_vc);
> +               REG_SET_SLICE(mrv_reg->mrsz_phase_vc, MRV_MRSZ_PHASE_VC,
> +                             (u32) scale->phase_vc);
> +
> +               if (scale->scale_vc & RSZ_UPSCALE_ENABLE) {
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_UP,
> +                                     MRV_MRSZ_SCALE_VC_UP_UPSCALE);
> +                       upscaling = true;
> +               } else {
> +                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_UP,
> +                                     MRV_MRSZ_SCALE_VC_UP_DOWNSCALE);
> +               }
> +       }
> +
> +       /* apply upscaling lookup table */
> +       if (rsz_lut) {
> +               for (i = 0; i <= MRV_MRSZ_SCALE_LUT_ADDR_MASK; i++) {
> +                       REG_SET_SLICE(mrv_reg->mrsz_scale_lut_addr,
> +                                     MRV_MRSZ_SCALE_LUT_ADDR, i);
> +                       REG_SET_SLICE(mrv_reg->mrsz_scale_lut,
> +                                     MRV_MRSZ_SCALE_LUT,
> +                                     rsz_lut->rsz_lut[i]);
> +               }
> +       } else if (upscaling) {
> +               eprintk("Upscaling requires lookup table!");
> +               WARN_ON(1);
> +       }
> +
> +       /* handle immediate update flag and write mrsz_ctrl */
> +       switch (update_time) {
> +       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +               /* frame synchronous update of shadow registers */
> +               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ON);
> +               break;
> +       case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +               /* immediate update of shadow registers */
> +               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_CFG_UPD, ON);
> +               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
> +               break;
> +       case CI_ISP_CFG_UPDATE_LATER:
> +       default:
> +               /* no update from within this function */
> +               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
> +               break;
> +       }
> +}
> +
> +/*
> + * writes the scaler values to the appropriate Marvin registers.
> + */
> +void ci_isp_res_set_self_resize(const struct ci_isp_scale *scale,
> +                               enum ci_isp_conf_update_time update_time,
> +                               const struct ci_isp_rsz_lut *rsz_lut)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 srsz_ctrl = REG_READ(mrv_reg->srsz_ctrl);
> +       u32 i;
> +       int upscaling = false;
> +
> +       /* flags must be "outside" scaler value */
> +       WARN_ON(!((RSZ_FLAGS_MASK & MRV_RSZ_SCALE_MASK) == 0));
> +       WARN_ON(!((scale->scale_hy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_hcb & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_hcr & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_vy & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +       WARN_ON(!((scale->scale_vc & ~RSZ_FLAGS_MASK) <= MRV_RSZ_SCALE_MAX));
> +
> +       /* horizontal luminance scale factor */
> +       dprintk(1, "scale_hy = %d,%x", scale->scale_hy, scale->scale_hy);
> +
> +       if (scale->scale_hy & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_ENABLE,
> +                             DISABLE);
> +       } else {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_ENABLE, ENABLE);
> +               REG_SET_SLICE(mrv_reg->srsz_scale_hy, MRV_SRSZ_SCALE_HY,
> +                             (u32) scale->scale_hy);
> +               REG_SET_SLICE(mrv_reg->srsz_phase_hy, MRV_SRSZ_PHASE_HY,
> +                             (u32) scale->phase_hy);
> +
> +               if (scale->scale_hy & RSZ_UPSCALE_ENABLE) {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_UP,
> +                                     MRV_SRSZ_SCALE_HY_UP_UPSCALE);
> +                       upscaling = true;
> +               } else {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_UP,
> +                                     MRV_SRSZ_SCALE_HY_UP_DOWNSCALE);
> +               }
> +       }
> +
> +       /* horizontal chrominance scale factors */
> +       WARN_ON(!((scale->scale_hcb & RSZ_FLAGS_MASK) == (scale->scale_hcr &
> +                                                         RSZ_FLAGS_MASK)));
> +
> +       dprintk(1, "scale_hcb  = %d,%x", scale->scale_hcb, scale->scale_hcb);
> +
> +       if (scale->scale_hcb & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_ENABLE,
> +                             DISABLE);
> +       } else {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_ENABLE, ENABLE);
> +               REG_SET_SLICE(mrv_reg->srsz_scale_hcb, MRV_SRSZ_SCALE_HCB,
> +                             (u32) scale->scale_hcb);
> +               REG_SET_SLICE(mrv_reg->srsz_scale_hcr, MRV_SRSZ_SCALE_HCB,
> +                             (u32) scale->scale_hcr);
> +
> +               REG_SET_SLICE(mrv_reg->srsz_phase_hc, MRV_SRSZ_PHASE_HC,
> +                   (u32) scale->phase_hc);
> +
> +               if (scale->scale_hcb & RSZ_UPSCALE_ENABLE) {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_UP,
> +                                     MRV_SRSZ_SCALE_HC_UP_UPSCALE);
> +                       upscaling = true;
> +               } else {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_UP,
> +                                     MRV_SRSZ_SCALE_HC_UP_DOWNSCALE);
> +               }
> +       }
> +
> +       /* vertical luminance scale factor */
> +       dprintk(1, "scale_vy = %d,%x", scale->scale_vy, scale->scale_vy);
> +
> +       if (scale->scale_vy & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_ENABLE,
> +                             DISABLE);
> +       } else {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_ENABLE, ENABLE);
> +               REG_SET_SLICE(mrv_reg->srsz_scale_vy, MRV_SRSZ_SCALE_VY,
> +                             (u32) scale->scale_vy);
> +               REG_SET_SLICE(mrv_reg->srsz_phase_vy, MRV_SRSZ_PHASE_VY,
> +                             (u32) scale->phase_vy);
> +
> +               if (scale->scale_vy & RSZ_UPSCALE_ENABLE) {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_UP,
> +                                     MRV_SRSZ_SCALE_VY_UP_UPSCALE);
> +                       upscaling = true;
> +               } else {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_UP,
> +                                     MRV_SRSZ_SCALE_VY_UP_DOWNSCALE);
> +               }
> +       }
> +
> +       /* vertical chrominance scale factor */
> +       dprintk(1, "scale_vc = %d,%x", scale->scale_vc, scale->scale_vc);
> +
> +       if (scale->scale_vc & RSZ_SCALER_BYPASS) {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_ENABLE,
> +                             DISABLE);
> +       } else {
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_ENABLE, ENABLE);
> +               REG_SET_SLICE(mrv_reg->srsz_scale_vc, MRV_SRSZ_SCALE_VC,
> +                             (u32) scale->scale_vc);
> +               REG_SET_SLICE(mrv_reg->srsz_phase_vc, MRV_SRSZ_PHASE_VC,
> +                             (u32) scale->phase_vc);
> +
> +               if (scale->scale_vc & RSZ_UPSCALE_ENABLE) {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_UP,
> +                                     MRV_SRSZ_SCALE_VC_UP_UPSCALE);
> +                       upscaling = true;
> +               } else {
> +                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_UP,
> +                                     MRV_SRSZ_SCALE_VC_UP_DOWNSCALE);
> +               }
> +       }
> +
> +       /* apply upscaling lookup table */
> +       if (rsz_lut) {
> +               for (i = 0; i <= MRV_SRSZ_SCALE_LUT_ADDR_MASK; i++) {
> +                       REG_SET_SLICE(mrv_reg->srsz_scale_lut_addr,
> +                                     MRV_SRSZ_SCALE_LUT_ADDR, i);
> +                       REG_SET_SLICE(mrv_reg->srsz_scale_lut,
> +                                     MRV_SRSZ_SCALE_LUT,
> +                                     rsz_lut->rsz_lut[i]);
> +               }
> +       } else if (upscaling) {
> +               eprintk("Upscaling requires lookup table!");
> +               WARN_ON(1);
> +       }
> +
> +       /* handle immediate update flag and write mrsz_ctrl */
> +       switch (update_time) {
> +       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +               /* frame synchronous update of shadow registers */
> +               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
> +                             ON);
> +               break;
> +       case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +               /* immediate update of shadow registers */
> +               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_CFG_UPD, ON);
> +               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
> +               break;
> +       case CI_ISP_CFG_UPDATE_LATER:
> +       default:
> +               /* no update from within this function */
> +               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
> +               break;
> +       }
> +}
> +
> +/* bad pixel table */
> +static struct ci_sensor_bp_table bp_table = { 0 };
> +
> +/*
> + * Initialization of the Bad Pixel Detection and Correction.
> + */
> +int ci_bp_init(const struct ci_isp_bp_corr_config *bp_corr_config,
> +              const struct ci_isp_bp_det_config *bp_det_config)
> +{
> +       int error = CI_STATUS_SUCCESS;
> +
> +       #define MRVSLS_BPINIT_MAX_TABLE 2048
> +
> +       /* check the parameters */
> +       if (!bp_corr_config || !bp_det_config)
> +               return CI_STATUS_NULL_POINTER;
> +
> +       if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_TABLE) {
> +               error |= ci_isp_set_bp_correction(bp_corr_config);
> +               error |= ci_isp_set_bp_detection(bp_det_config);
> +               bp_table.bp_number = 0;
> +               if (!bp_table.bp_table_elem) {
> +                       bp_table.bp_table_elem =
> +                           (struct ci_sensor_bp_table_elem *)
> +                           kmalloc((sizeof(struct ci_sensor_bp_table_elem)*
> +                                    MRVSLS_BPINIT_MAX_TABLE), GFP_KERNEL);
> +                       if (!bp_table.bp_table_elem)
> +                               error |= CI_STATUS_FAILURE;
> +               }
> +
> +               bp_table.bp_table_elem_num = MRVSLS_BPINIT_MAX_TABLE;
> +               error |= ci_isp_clear_bp_int();
> +       } else {
> +               if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_DIRECT) {
> +                       error |= ci_isp_set_bp_correction(bp_corr_config);
> +                       error |= ci_isp_set_bp_detection(NULL);
> +               } else {
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +       }
> +       return error;
> +}
> +
> +/*
> + *  Disable the Bad Pixel Detection and Correction.
> + */
> +int ci_bp_end(const struct ci_isp_bp_corr_config *bp_corr_config)
> +{
> +       int result = CI_STATUS_SUCCESS;
> +
> +       /* check the parameter */
> +       if (!bp_corr_config)
> +               return CI_STATUS_NULL_POINTER;
> +
> +       result |= ci_isp_set_bp_correction(NULL);
> +       result |= ci_isp_set_bp_detection(NULL);
> +
> +       if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_TABLE) {
> +               result |= ci_isp_clear_bp_int();
> +               /* deallocate BP Table */
> +               kfree(bp_table.bp_table_elem);
> +               bp_table.bp_table_elem = NULL;
> +       }
> +       return result;
> +}
> diff --git a/drivers/media/video/mrstci/mrstisp/mrstisp_isp.c b/drivers/media/video/mrstci/mrstisp/mrstisp_isp.c
> new file mode 100644
> index 0000000..6c13115
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/mrstisp_isp.c
> @@ -0,0 +1,1913 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include "mrstisp_stdinc.h"
> +
> +int mrst_isp_set_color_conversion_ex(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0, 0x00001021);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1, 0x00001040);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2, 0x0000100D);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3, 0x00000FED);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4, 0x00000FDB);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5, 0x00001038);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6, 0x00001038);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7, 0x00000FD1);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8, 0x00000FF7);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Selects the ISP path that will become active while processing
> + * data coming from an image sensor configured by the given ISI
> + * configuration struct.
> + */
> +enum ci_isp_path ci_isp_select_path(const struct ci_sensor_config *isi_cfg,
> +                                   u8 *words_per_pixel)
> +{
> +       u8 words;
> +       enum ci_isp_path ret_val;
> +
> +       switch (isi_cfg->mode) {
> +       case SENSOR_MODE_DATA:
> +               ret_val = CI_ISP_PATH_RAW;
> +               words = 1;
> +               break;
> +       case SENSOR_MODE_PICT:
> +               ret_val = CI_ISP_PATH_RAW;
> +               words = 1;
> +               break;
> +       case SENSOR_MODE_RGB565:
> +               ret_val = CI_ISP_PATH_RAW;
> +               words = 2;
> +               break;
> +       case SENSOR_MODE_BT601:
> +               ret_val = CI_ISP_PATH_YCBCR;
> +               words = 2;
> +               break;
> +       case SENSOR_MODE_BT656:
> +               ret_val = CI_ISP_PATH_YCBCR;
> +               words = 2;
> +               break;
> +       case SENSOR_MODE_BAYER:
> +               ret_val = CI_ISP_PATH_BAYER;
> +               words = 1;
> +               break;
> +
> +       case SENSOR_MODE_SMIA:
> +               switch (isi_cfg->smia_mode) {
> +               case SENSOR_SMIA_MODE_RAW_12:
> +               case SENSOR_SMIA_MODE_RAW_10:
> +               case SENSOR_SMIA_MODE_RAW_8:
> +               case SENSOR_SMIA_MODE_RAW_8_TO_10_DECOMP:
> +                       ret_val = CI_ISP_PATH_BAYER;
> +                       words = 1;
> +                       break;
> +               case SENSOR_SMIA_MODE_YUV_422:
> +                       ret_val = CI_ISP_PATH_YCBCR;
> +                       words = 2;
> +                       break;
> +               case SENSOR_SMIA_MODE_YUV_420:
> +               case SENSOR_SMIA_MODE_RGB_444:
> +               case SENSOR_SMIA_MODE_RGB_565:
> +               case SENSOR_SMIA_MODE_RGB_888:
> +               case SENSOR_SMIA_MODE_COMPRESSED:
> +               case SENSOR_SMIA_MODE_RAW_7:
> +               case SENSOR_SMIA_MODE_RAW_6:
> +               default:
> +                       ret_val = CI_ISP_PATH_RAW;
> +                       words = 1;
> +                       break;
> +               }
> +               break;
> +
> +       case SENSOR_MODE_MIPI:
> +               switch (isi_cfg->mipi_mode) {
> +               case SENSOR_MIPI_MODE_RAW_12:
> +               case SENSOR_MIPI_MODE_RAW_10:
> +               case SENSOR_MIPI_MODE_RAW_8:
> +                       ret_val = CI_ISP_PATH_BAYER;
> +                       words = 1;
> +                       break;
> +               case SENSOR_MIPI_MODE_YUV422_8:
> +               case SENSOR_MIPI_MODE_YUV422_10:
> +                       ret_val = CI_ISP_PATH_YCBCR;
> +                       words = 2;
> +                       break;
> +               case SENSOR_MIPI_MODE_YUV420_8:
> +               case SENSOR_MIPI_MODE_YUV420_10:
> +               case SENSOR_MIPI_MODE_LEGACY_YUV420_8:
> +               case SENSOR_MIPI_MODE_YUV420_CSPS_8:
> +               case SENSOR_MIPI_MODE_YUV420_CSPS_10:
> +               case SENSOR_MIPI_MODE_RGB444:
> +               case SENSOR_MIPI_MODE_RGB555:
> +               case SENSOR_MIPI_MODE_RGB565:
> +               case SENSOR_MIPI_MODE_RGB666:
> +               case SENSOR_MIPI_MODE_RGB888:
> +               case SENSOR_MIPI_MODE_RAW_7:
> +               case SENSOR_MIPI_MODE_RAW_6:
> +               default:
> +                       ret_val = CI_ISP_PATH_RAW;
> +                       words = 1;
> +                       break;
> +               }
> +               break;
> +       case SENSOR_MODE_BAY_BT656:
> +               ret_val = CI_ISP_PATH_BAYER;
> +               words = 1;
> +               break;
> +       case SENSOR_MODE_RAW_BT656:
> +               ret_val = CI_ISP_PATH_RAW;
> +               words = 1;
> +               break;
> +       default:
> +               ret_val = CI_ISP_PATH_UNKNOWN;
> +               words = 1;
> +       }
> +
> +       if (words_per_pixel)
> +               *words_per_pixel = words ;
> +       return ret_val;
> +}
> +
> +/*
> + * configures the input acquisition according to the
> + * given config structure
> + */
> +int ci_isp_set_input_aquisition(const struct ci_sensor_config *isi_cfg)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
> +       u32 isp_acq_prop = REG_READ(mrv_reg->isp_acq_prop);
> +       u8 sample_factor;
> +       u8 black_lines;
> +
> +       if (ci_isp_select_path(isi_cfg, &sample_factor)
> +           == CI_ISP_PATH_UNKNOWN) {
> +               eprintk("failed to select path");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->mode) {
> +       case SENSOR_MODE_DATA:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_DATA);
> +               break;
> +       case SENSOR_MODE_PICT:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_RAW);
> +               break;
> +       case SENSOR_MODE_RGB565:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_RAW);
> +               break;
> +       case SENSOR_MODE_BT601:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_601);
> +               break;
> +       case SENSOR_MODE_BT656:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_656);
> +               break;
> +       case SENSOR_MODE_BAYER:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_RGB);
> +               break;
> +       case SENSOR_MODE_BAY_BT656:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_RGB656);
> +               break;
> +       case SENSOR_MODE_RAW_BT656:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_RAW656);
> +               break;
> +
> +       case SENSOR_MODE_SMIA:
> +               switch (isi_cfg->smia_mode) {
> +               case SENSOR_SMIA_MODE_RAW_12:
> +               case SENSOR_SMIA_MODE_RAW_10:
> +               case SENSOR_SMIA_MODE_RAW_8:
> +               case SENSOR_SMIA_MODE_RAW_8_TO_10_DECOMP:
> +               case SENSOR_SMIA_MODE_RAW_7:
> +               case SENSOR_SMIA_MODE_RAW_6:
> +               case SENSOR_SMIA_MODE_YUV_422:
> +               case SENSOR_SMIA_MODE_YUV_420:
> +               case SENSOR_SMIA_MODE_RGB_888:
> +               case SENSOR_SMIA_MODE_RGB_565:
> +               case SENSOR_SMIA_MODE_RGB_444:
> +               case SENSOR_SMIA_MODE_COMPRESSED:
> +                       return CI_STATUS_SUCCESS;
> +                       break;
> +               default:
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +               break;
> +
> +       case SENSOR_MODE_MIPI:
> +               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
> +                             MRV_ISP_ISP_MODE_RGB);
> +               REG_WRITE(mrv_reg->mipi_img_data_sel, 0x02b);
> +               break;
> +
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->bus_width) {
> +       case SENSOR_BUSWIDTH_12BIT:
> +               /* 000- 12Bit external Interface */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
> +                             MRV_ISP_INPUT_SELECTION_12EXT);
> +               break;
> +       case SENSOR_BUSWIDTH_10BIT_ZZ:
> +               /* 001- 10Bit Interface, append 2 zeroes as LSBs */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
> +                             MRV_ISP_INPUT_SELECTION_10ZERO);
> +               break;
> +       case SENSOR_BUSWIDTH_10BIT_EX:
> +               /* 010- 10Bit Interface, append 2 MSBs as LSBs */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
> +                             MRV_ISP_INPUT_SELECTION_10MSB);
> +               break;
> +       case SENSOR_BUSWIDTH_8BIT_ZZ:
> +               /* 011- 8Bit Interface, append 4 zeroes as LSBs */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
> +                             MRV_ISP_INPUT_SELECTION_8ZERO);
> +               break;
> +       case SENSOR_BUSWIDTH_8BIT_EX:
> +               /* 100- 8Bit Interface, append 4 MSBs as LSBs */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
> +                             MRV_ISP_INPUT_SELECTION_8MSB);
> +               break;
> +               /* 101...111 reserved */
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->field_sel) {
> +       case SENSOR_FIELDSEL_ODD:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
> +                             MRV_ISP_FIELD_SELECTION_ODD);
> +               break;
> +       case SENSOR_FIELDSEL_EVEN:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
> +                             MRV_ISP_FIELD_SELECTION_EVEN);
> +               break;
> +       case SENSOR_FIELDSEL_BOTH:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
> +                             MRV_ISP_FIELD_SELECTION_BOTH);
> +               break;
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->ycseq) {
> +       case SENSOR_YCSEQ_CRYCBY:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
> +                             MRV_ISP_CCIR_SEQ_CRYCBY);
> +               break;
> +       case SENSOR_YCSEQ_CBYCRY:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
> +                             MRV_ISP_CCIR_SEQ_CBYCRY);
> +               break;
> +       case SENSOR_YCSEQ_YCRYCB:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
> +                             MRV_ISP_CCIR_SEQ_YCRYCB);
> +               break;
> +       case SENSOR_YCSEQ_YCBYCR:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
> +                             MRV_ISP_CCIR_SEQ_YCBYCR);
> +               break;
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->conv422) {
> +       case SENSOR_CONV422_INTER:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
> +                       MRV_ISP_CONV_422_INTER);
> +               break;
> +
> +       case SENSOR_CONV422_NOCOSITED:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
> +                     MRV_ISP_CONV_422_NONCO);
> +               break;
> +       case SENSOR_CONV422_COSITED:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
> +                     MRV_ISP_CONV_422_CO);
> +               break;
> +       default:
> +       return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->bpat) {
> +       case SENSOR_BPAT_BGBGGRGR:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
> +                     MRV_ISP_BAYER_PAT_BG);
> +               break;
> +       case SENSOR_BPAT_GBGBRGRG:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
> +                     MRV_ISP_BAYER_PAT_GB);
> +               break;
> +       case SENSOR_BPAT_GRGRBGBG:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
> +                     MRV_ISP_BAYER_PAT_GR);
> +               break;
> +       case SENSOR_BPAT_RGRGGBGB:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
> +                     MRV_ISP_BAYER_PAT_RG);
> +               break;
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->vpol) {
> +       case SENSOR_VPOL_POS:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_VSYNC_POL, 1);
> +               break;
> +       case SENSOR_VPOL_NEG:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_VSYNC_POL, 0);
> +               break;
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->hpol) {
> +       /* vsync_pol = 1 triggers on positive edge whereas */
> +       /* hsync_pol = 1 triggers on negative edge and vice versa */
> +       case SENSOR_HPOL_SYNCPOS:
> +               /* trigger on negative edge */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 1);
> +               break;
> +       case SENSOR_HPOL_SYNCNEG:
> +               /* trigger on positive edge */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 0);
> +               break;
> +       case SENSOR_HPOL_REFPOS:
> +               /* trigger on positive edge */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 0);
> +               break;
> +       case SENSOR_HPOL_REFNEG:
> +               /* trigger on negative edge */
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 1);
> +               break;
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       switch (isi_cfg->edge) {
> +       case SENSOR_EDGE_RISING:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_SAMPLE_EDGE, 1);
> +               break;
> +       case SENSOR_EDGE_FALLING:
> +               REG_SET_SLICE(isp_acq_prop, MRV_ISP_SAMPLE_EDGE, 0);
> +               break;
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +       dprintk(2, "isp_acq_prop = 0x%x", isp_acq_prop);
> +
> +       /* now write values to registers */
> +       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
> +       REG_WRITE(mrv_reg->isp_acq_prop, isp_acq_prop);
> +
> +       /* number of additional black lines at frame start */
> +       switch (isi_cfg->bls) {
> +       case SENSOR_BLS_OFF:
> +               black_lines = 0;
> +               break;
> +       case SENSOR_BLS_TWO_LINES:
> +               black_lines = 2;
> +               break;
> +       case SENSOR_BLS_FOUR_LINES:
> +               black_lines = 4;
> +               break;
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       REG_SET_SLICE(mrv_reg->isp_acq_h_offs, MRV_ISP_ACQ_H_OFFS,
> +                     0 * sample_factor);
> +       REG_SET_SLICE(mrv_reg->isp_acq_v_offs, MRV_ISP_ACQ_V_OFFS, 0);
> +
> +       dprintk(2, "res = %x", isi_cfg->res);
> +       switch (isi_cfg->res) {
> +       /* 88x72 */
> +       case SENSOR_RES_QQCIF:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QQCIF_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QQCIF_SIZE_V + black_lines);
> +               break;
> +       /* 160x120 */
> +       case SENSOR_RES_QQVGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QQVGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QQVGA_SIZE_V + black_lines);
> +               break;
> +       /* 176x144 */
> +       case SENSOR_RES_QCIF:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QCIF_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QCIF_SIZE_V + black_lines);
> +               break;
> +       /* 320x240 */
> +       case SENSOR_RES_QVGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QVGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QVGA_SIZE_V + black_lines);
> +               break;
> +       /* 352x288 */
> +       case SENSOR_RES_CIF:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             CIF_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             CIF_SIZE_V + black_lines);
> +               break;
> +       /* 640x480 */
> +       case SENSOR_RES_VGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             VGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             VGA_SIZE_V + black_lines);
> +               break;
> +       /* 800x600 */
> +       case SENSOR_RES_SVGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             SVGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             SVGA_SIZE_V + black_lines);
> +               break;
> +       /* 1024x768 */
> +       case SENSOR_RES_XGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             XGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             XGA_SIZE_V + black_lines);
> +               break;
> +       case SENSOR_RES_720P:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             RES_720P_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             RES_720P_SIZE_V + black_lines);
> +               break;
> +       /* 1280x960 */
> +       case SENSOR_RES_XGA_PLUS:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             XGA_PLUS_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             XGA_PLUS_SIZE_V + black_lines);
> +               break;
> +       /* 1280x1024 */
> +       case SENSOR_RES_SXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             SXGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             SXGA_SIZE_V + black_lines);
> +               break;
> +       /* 1600x1200 */
> +       case SENSOR_RES_UXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QSVGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QSVGA_SIZE_V + black_lines);
> +               break;
> +       /* 1920x1280 */
> +       case SENSOR_RES_1080P:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             1920 * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             1080 + black_lines);
> +               break;
> +       /* 2048x1536 */
> +       case SENSOR_RES_QXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QXGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QXGA_SIZE_V + black_lines);
> +               break;
> +       /* 2586x2048 */
> +       case SENSOR_RES_QSXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QSXGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QSXGA_SIZE_V + black_lines);
> +               break;
> +       /* 2600x2048 */
> +       case SENSOR_RES_QSXGA_PLUS:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QSXGA_PLUS_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QSXGA_PLUS_SIZE_V + black_lines);
> +               break;
> +       /* 2600x1950 */
> +       case SENSOR_RES_QSXGA_PLUS2:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QSXGA_PLUS2_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QSXGA_PLUS2_SIZE_V + black_lines);
> +               break;
> +       /* 2686x2048,  5.30M */
> +       case SENSOR_RES_QSXGA_PLUS3:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QSXGA_PLUS3_SIZE_V * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QSXGA_PLUS3_SIZE_V + black_lines);
> +               break;
> +       /* 2592*1944 5M */
> +       case SENSOR_RES_QXGA_PLUS:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                               QXGA_PLUS_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QXGA_PLUS_SIZE_V + black_lines);
> +               break;
> +       /* 3200x2048,  6.56M */
> +       case SENSOR_RES_WQSXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             WQSXGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             WQSXGA_SIZE_V + black_lines);
> +               break;
> +       /* 3200x2400,  7.68M */
> +       case SENSOR_RES_QUXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             QUXGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             QUXGA_SIZE_V + black_lines);
> +               break;
> +       /* 3840x2400,  9.22M */
> +       case SENSOR_RES_WQUXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             WQUXGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             WQUXGA_SIZE_V + black_lines);
> +               break;
> +       /* 4096x3072, 12.59M */
> +       case SENSOR_RES_HXGA:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             HXGA_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             HXGA_SIZE_V + black_lines);
> +               break;
> +       /* 4080x1024 */
> +       case SENSOR_RES_YUV_HMAX:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             YUV_HMAX_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             YUV_HMAX_SIZE_V);
> +               break;
> +       /* 1024x4080 */
> +       case SENSOR_RES_YUV_VMAX:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             YUV_VMAX_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             YUV_VMAX_SIZE_V);
> +               break;
> +       /* 4096x2048 */
> +       case SENSOR_RES_RAWMAX:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             RAWMAX_SIZE_H);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             RAWMAX_SIZE_V);
> +               break;
> +       /* 352x240 */
> +       case SENSOR_RES_BP1:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             BP1_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             BP1_SIZE_V);
> +               break;
> +       /* 720x480 */
> +       case SENSOR_RES_L_AFM:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             L_AFM_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             L_AFM_SIZE_V);
> +               break;
> +       /* 128x96 */
> +       case SENSOR_RES_M_AFM:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             M_AFM_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             M_AFM_SIZE_V);
> +               break;
> +       /* 64x32 */
> +       case SENSOR_RES_S_AFM:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             S_AFM_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             S_AFM_SIZE_V);
> +               break;
> +       /* 1304x980 */
> +       case SENSOR_RES_VGA_PLUS:
> +               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
> +                             VGA_PLUS_SIZE_H * sample_factor);
> +               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
> +                             VGA_PLUS_SIZE_V);
> +               break;
> +
> +       default:
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * sets output window
> + */
> +void ci_isp_set_output_formatter(const struct ci_isp_window *window,
> +                                enum ci_isp_conf_update_time update_time)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (window) {
> +               REG_SET_SLICE(mrv_reg->isp_out_h_offs, MRV_IS_IS_H_OFFS,
> +                       window->hoffs);
> +               REG_SET_SLICE(mrv_reg->isp_out_v_offs, MRV_IS_IS_V_OFFS,
> +                       window->voffs);
> +               REG_SET_SLICE(mrv_reg->isp_out_h_size, MRV_IS_IS_H_SIZE,
> +                       window->hsize);
> +               REG_SET_SLICE(mrv_reg->isp_out_v_size, MRV_IS_IS_V_SIZE,
> +                       window->vsize);
> +
> +               REG_SET_SLICE(mrv_reg->isp_is_h_offs, MRV_IS_IS_H_OFFS, 0);
> +               REG_SET_SLICE(mrv_reg->isp_is_v_offs, MRV_IS_IS_V_OFFS, 0);
> +               REG_SET_SLICE(mrv_reg->isp_is_h_size, MRV_IS_IS_H_SIZE,
> +                       window->hsize);
> +               REG_SET_SLICE(mrv_reg->isp_is_v_size, MRV_IS_IS_V_SIZE,
> +                       window->vsize);
> +
> +               switch (update_time) {
> +               case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +                       /* frame synchronous update of shadow registers */
> +                       REG_SET_SLICE(mrv_reg->isp_ctrl,
> +                               MRV_ISP_ISP_GEN_CFG_UPD, ON);
> +                       break;
> +               case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +                       /* immediate update of shadow registers */
> +                       REG_SET_SLICE(mrv_reg->isp_ctrl,
> +                               MRV_ISP_ISP_CFG_UPD, ON);
> +                       break;
> +               case CI_ISP_CFG_UPDATE_LATER:
> +                       /* no update from within this function */
> +                       break;
> +               default:
> +                       break;
> +               }
> +       }
> +}
> +
> +/*
> + * programs the given Bayer pattern demosaic parameters
> + */
> +void ci_isp_set_demosaic(enum ci_isp_demosaic_mode demosaic_mode,
> +                        u8 demosaic_th)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_demosaic = REG_READ(mrv_reg->isp_demosaic);
> +
> +       switch (demosaic_mode) {
> +       case CI_ISP_DEMOSAIC_STANDARD:
> +               REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_MODE,
> +                             MRV_ISP_DEMOSAIC_MODE_STD);
> +               break;
> +       case CI_ISP_DEMOSAIC_ENHANCED:
> +               REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_MODE,
> +                             MRV_ISP_DEMOSAIC_MODE_ENH);
> +               break;
> +       default:
> +               WARN_ON(!(false));
> +       }
> +
> +       REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_TH, demosaic_th);
> +       REG_WRITE(mrv_reg->isp_demosaic, isp_demosaic);
> +}
> +
> +/*
> + * Sets the dedicated AWB block mode.
> + */
> +int ci_isp_set_wb_mode(enum ci_isp_awb_mode wb_mode)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       switch (wb_mode) {
> +       case CI_ISP_AWB_COMPLETELY_OFF:
> +               /* manual WB, no measurements*/
> +               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
> +                             MRV_ISP_AWB_MODE_NOMEAS);
> +               /* switch ABW block off */
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
> +                             DISABLE);
> +               break;
> +       case CI_ISP_AWB_MAN_MEAS:
> +       case CI_ISP_AWB_AUTO:
> +       case CI_ISP_AWB_MAN_PUSH_AUTO:
> +       case CI_ISP_AWB_ONLY_MEAS:
> +               /* manual white balance, measure YCbCr means */
> +               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
> +                       MRV_ISP_AWB_MODE_MEAS);
> +               /* switch ABW block on */
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
> +                       ENABLE);
> +               break;
> +       case CI_ISP_AWB_MAN_NOMEAS:
> +               /* manual white balance, no measurements */
> +               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
> +                       MRV_ISP_AWB_MODE_NOMEAS);
> +               /* switch ABW block on */
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
> +                             ENABLE);
> +               break;
> +       default:
> +               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MODE,
> +                       MRV_ISP_AWB_MODE_NOMEAS);
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE,
> +                       DISABLE);
> +               return CI_STATUS_FAILURE;
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_get_wb_mode(enum ci_isp_awb_mode *wb_mode)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (!wb_mode)
> +               return CI_STATUS_NULL_POINTER;
> +
> +       if (REG_GET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_AWB_ENABLE) ==
> +               DISABLE) {
> +               *wb_mode = CI_ISP_AWB_COMPLETELY_OFF;
> +       } else {
> +
> +               switch (REG_GET_SLICE(mrv_reg->isp_awb_prop,
> +                       MRV_ISP_AWB_MODE)) {
> +               case MRV_ISP_AWB_MODE_MEAS:
> +                       *wb_mode = CI_ISP_AWB_MAN_MEAS;
> +                       break;
> +               case MRV_ISP_AWB_MODE_NOMEAS:
> +                       *wb_mode = CI_ISP_AWB_MAN_NOMEAS;
> +                       break;
> +               default:
> +                       *wb_mode = CI_ISP_AWB_COMPLETELY_OFF;
> +                       return CI_STATUS_FAILURE;
> +               }
> +       }
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_set_wb_meas_config(const struct ci_isp_wb_meas_config
> +                             *wb_meas_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_awb_thresh = REG_READ(mrv_reg->isp_awb_thresh);
> +
> +       if (!wb_meas_config)
> +               return CI_STATUS_NULL_POINTER;
> +
> +       /* measurement window */
> +       REG_SET_SLICE(mrv_reg->isp_awb_h_size, MRV_ISP_AWB_H_SIZE,
> +               (u32) wb_meas_config->awb_window.hsize);
> +       REG_SET_SLICE(mrv_reg->isp_awb_v_size, MRV_ISP_AWB_V_SIZE,
> +               (u32) wb_meas_config->awb_window.vsize);
> +       REG_SET_SLICE(mrv_reg->isp_awb_h_offs, MRV_ISP_AWB_H_OFFS,
> +               (u32) wb_meas_config->awb_window.hoffs);
> +       REG_SET_SLICE(mrv_reg->isp_awb_v_offs, MRV_ISP_AWB_V_OFFS,
> +               (u32) wb_meas_config->awb_window.voffs);
> +
> +       /* adjust awb properties (Y_MAX compare) */
> +       if (wb_meas_config->max_y == 0) {
> +               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MAX_EN,
> +                       DISABLE);
> +       } else {
> +               REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MAX_EN,
> +                       ENABLE);
> +       }
> +
> +       /* measurement thresholds */
> +       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MAX_Y,
> +                     (u32) wb_meas_config->max_y);
> +       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MIN_Y__MAX_G,
> +                     (u32) wb_meas_config->min_y_max_g);
> +       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MAX_CSUM,
> +                     (u32) wb_meas_config->max_csum);
> +       REG_SET_SLICE(isp_awb_thresh, MRV_ISP_AWB_MIN_C,
> +                     (u32) wb_meas_config->min_c);
> +       REG_WRITE(mrv_reg->isp_awb_thresh, isp_awb_thresh);
> +       REG_SET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CR__MAX_R,
> +                     (u32)(wb_meas_config->ref_cr_max_r));
> +       REG_SET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CB__MAX_B,
> +                     (u32)(wb_meas_config->ref_cb_max_b));
> +
> +       /* amount of measurement frames */
> +       REG_SET_SLICE(mrv_reg->isp_awb_frames, MRV_ISP_AWB_FRAMES,
> +                     (u32) wb_meas_config->frames);
> +
> +       /* set measurement mode */
> +       REG_SET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MEAS_MODE,
> +                     (u32)(wb_meas_config->meas_mode));
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_get_wb_meas_config(struct ci_isp_wb_meas_config *wb_meas_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (!wb_meas_config)
> +               return CI_STATUS_NULL_POINTER;
> +
> +       /* measurement window */
> +       wb_meas_config->awb_window.hsize =
> +           (u16) REG_GET_SLICE(mrv_reg->isp_awb_h_size, MRV_ISP_AWB_H_SIZE);
> +       wb_meas_config->awb_window.vsize =
> +           (u16) REG_GET_SLICE(mrv_reg->isp_awb_v_size, MRV_ISP_AWB_V_SIZE);
> +       wb_meas_config->awb_window.hoffs =
> +           (u16) REG_GET_SLICE(mrv_reg->isp_awb_h_offs, MRV_ISP_AWB_H_OFFS);
> +       wb_meas_config->awb_window.voffs =
> +           (u16) REG_GET_SLICE(mrv_reg->isp_awb_v_offs, MRV_ISP_AWB_V_OFFS);
> +
> +       /* measurement thresholds */
> +       wb_meas_config->min_c =
> +           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh, MRV_ISP_AWB_MIN_C);
> +       wb_meas_config->max_csum =
> +           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh, MRV_ISP_AWB_MAX_CSUM);
> +       wb_meas_config->min_y_max_g =
> +           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh,
> +                              MRV_ISP_AWB_MIN_Y__MAX_G);
> +       wb_meas_config->max_y =
> +           (u8) REG_GET_SLICE(mrv_reg->isp_awb_thresh, MRV_ISP_AWB_MAX_Y);
> +       wb_meas_config->ref_cb_max_b =
> +           (u8)REG_GET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CB__MAX_B);
> +       wb_meas_config->ref_cr_max_r =
> +           (u8)REG_GET_SLICE(mrv_reg->isp_awb_ref, MRV_ISP_AWB_REF_CR__MAX_R);
> +
> +       /* amount of measurement frames */
> +       wb_meas_config->frames =
> +           (u8) REG_GET_SLICE(mrv_reg->isp_awb_frames, MRV_ISP_AWB_FRAMES);
> +
> +       /* overwrite max_y if the feature is disabled */
> +       if (REG_GET_SLICE(mrv_reg->isp_awb_prop, MRV_ISP_AWB_MAX_EN) ==
> +           DISABLE) {
> +               wb_meas_config->max_y = 0;
> +       }
> +
> +       /* get measurement mode */
> +       wb_meas_config->meas_mode = REG_GET_SLICE(mrv_reg->isp_awb_prop,
> +                                                 MRV_ISP_AWB_MEAS_MODE);
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_get_wb_meas(struct ci_sensor_awb_mean *awb_mean)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (awb_mean == NULL)
> +               return CI_STATUS_NULL_POINTER;
> +
> +       awb_mean->white = REG_GET_SLICE(mrv_reg->isp_awb_white_cnt,
> +                                       MRV_ISP_AWB_WHITE_CNT);
> +       awb_mean->mean_y_g = (u8) REG_GET_SLICE(mrv_reg->isp_awb_mean,
> +                                                MRV_ISP_AWB_MEAN_Y__G);
> +       awb_mean->mean_cb_b = (u8) REG_GET_SLICE(mrv_reg->isp_awb_mean,
> +                                                 MRV_ISP_AWB_MEAN_CB__B);
> +       awb_mean->mean_cr_r = (u8) REG_GET_SLICE(mrv_reg->isp_awb_mean,
> +                                                 MRV_ISP_AWB_MEAN_CR__R);
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * calculates left-top and right-bottom register values
> + * for a given AF measurement window
> + */
> +static int ci_isp_afm_wnd2_regs(const struct ci_isp_window *wnd, u32 *lt,
> +                               u32 *rb)
> +{
> +       WARN_ON(!((wnd != NULL) && (lt != NULL) && (rb != NULL)));
> +
> +       if (wnd->hsize && wnd->vsize) {
> +               u32 left = wnd->hoffs;
> +               u32 top = wnd->voffs;
> +               u32 right = left + wnd->hsize - 1;
> +               u32 bottom = top + wnd->vsize - 1;
> +
> +               if ((left < MRV_AFM_A_H_L_MIN)
> +                   || (left > MRV_AFM_A_H_L_MAX)
> +                   || (top < MRV_AFM_A_V_T_MIN)
> +                   || (top > MRV_AFM_A_V_T_MAX)
> +                   || (right < MRV_AFM_A_H_R_MIN)
> +                   || (right > MRV_AFM_A_H_R_MAX)
> +                   || (bottom < MRV_AFM_A_V_B_MIN)
> +                   || (bottom > MRV_AFM_A_V_B_MAX)) {
> +                       return CI_STATUS_OUTOFRANGE;
> +               }
> +
> +               /* combine the values and return */
> +               REG_SET_SLICE(*lt, MRV_AFM_A_H_L, left);
> +               REG_SET_SLICE(*lt, MRV_AFM_A_V_T, top);
> +               REG_SET_SLICE(*rb, MRV_AFM_A_H_R, right);
> +               REG_SET_SLICE(*rb, MRV_AFM_A_V_B, bottom);
> +       } else {
> +               *lt = 0;
> +               *rb = 0;
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_set_auto_focus(const struct ci_isp_af_config *af_config)
> +{
> +
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 result = CI_STATUS_SUCCESS;
> +
> +       /* disable measurement module */
> +       REG_SET_SLICE(mrv_reg->isp_afm_ctrl, MRV_AFM_AFM_EN, DISABLE);
> +
> +       if (af_config) {

Suggest rewriting this as:

	if (!af_config)
		return CI_STATUS_SUCCESS;

	...

That saves you an extra indentation.

> +               u32 lt;
> +               u32 rb;
> +               result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_a),
> +                                             &lt, &rb);
> +               /* set measurement window boundaries */
> +               if (result != CI_STATUS_SUCCESS)
> +                       return result;
> +
> +               REG_WRITE(mrv_reg->isp_afm_lt_a, lt);
> +               REG_WRITE(mrv_reg->isp_afm_rb_a, rb);
> +
> +               result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_b),
> +                                             &lt, &rb);
> +
> +               if (result != CI_STATUS_SUCCESS)
> +                       return result;
> +
> +               REG_WRITE(mrv_reg->isp_afm_lt_b, lt);
> +               REG_WRITE(mrv_reg->isp_afm_rb_b, rb);
> +
> +               result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_c),
> +                                             &lt, &rb);
> +
> +               if (result != CI_STATUS_SUCCESS)
> +                       return result;
> +
> +               REG_WRITE(mrv_reg->isp_afm_lt_c, lt);
> +               REG_WRITE(mrv_reg->isp_afm_rb_c, rb);
> +
> +               /* set other af measurement paraneters */
> +               REG_SET_SLICE(mrv_reg->isp_afm_thres, MRV_AFM_AFM_THRES,
> +                             af_config->threshold);
> +               REG_SET_SLICE(mrv_reg->isp_afm_var_shift, MRV_AFM_LUM_VAR_SHIFT,
> +                       (af_config->var_shift >> 16));
> +               REG_SET_SLICE(mrv_reg->isp_afm_var_shift, MRV_AFM_AFM_VAR_SHIFT,
> +                       (af_config->var_shift >> 0));
> +
> +               /* enable measurement module */
> +               REG_SET_SLICE(mrv_reg->isp_afm_ctrl, MRV_AFM_AFM_EN, ENABLE);
> +       }
> +
> +       return result;
> +}
> +
> +
> +void ci_isp_get_auto_focus_meas(struct ci_isp_af_meas *af_meas)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       WARN_ON(!(af_meas != NULL));
> +
> +       af_meas->afm_sum_a =
> +           REG_GET_SLICE(mrv_reg->isp_afm_sum_a, MRV_AFM_AFM_SUM_A);
> +       af_meas->afm_sum_b =
> +           REG_GET_SLICE(mrv_reg->isp_afm_sum_b, MRV_AFM_AFM_SUM_B);
> +       af_meas->afm_sum_c =
> +           REG_GET_SLICE(mrv_reg->isp_afm_sum_c, MRV_AFM_AFM_SUM_C);
> +       af_meas->afm_lum_a =
> +           REG_GET_SLICE(mrv_reg->isp_afm_lum_a, MRV_AFM_AFM_LUM_A);
> +       af_meas->afm_lum_b =
> +           REG_GET_SLICE(mrv_reg->isp_afm_lum_b, MRV_AFM_AFM_LUM_B);
> +       af_meas->afm_lum_c =
> +           REG_GET_SLICE(mrv_reg->isp_afm_lum_c, MRV_AFM_AFM_LUM_C);
> +}
> +
> +int ci_isp_set_ls_correction(struct ci_sensor_ls_corr_config *ls_corr_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 i, n;
> +       u32 data = 0;
> +       int enabled = false;
> +
> +       if (!ls_corr_config) {
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, DISABLE);

Similar case: just return here and you can remove the 'else' statement and shift
the 'else' body one tab to the left.

> +       } else {
> +               if (REG_GET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN)) {
> +                       REG_SET_SLICE(mrv_reg->isp_lsc_ctrl,
> +                                     MRV_LSC_LSC_EN, DISABLE);
> +                       msleep(1000);
> +                       enabled = true;
> +               }
> +
> +               /* clear address counters */
> +               REG_WRITE(mrv_reg->isp_lsc_r_table_addr, 0);
> +               REG_WRITE(mrv_reg->isp_lsc_g_table_addr, 0);
> +               REG_WRITE(mrv_reg->isp_lsc_b_table_addr, 0);
> +
> +               WARN_ON(!(((CI_ISP_MAX_LSC_SECTORS + 1) *
> +                       ((CI_ISP_MAX_LSC_SECTORS + 2) / 2)) ==
> +                       (MRV_LSC_R_RAM_ADDR_MAX + 1)));
> +
> +               /* 17 steps */
> +               for (n = 0;
> +               n < ((CI_ISP_MAX_LSC_SECTORS + 1) *
> +                    (CI_ISP_MAX_LSC_SECTORS + 1));
> +               n += CI_ISP_MAX_LSC_SECTORS + 1) {
> +                       for (i = 0; i < (CI_ISP_MAX_LSC_SECTORS); i += 2) {
> +                               REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_0,
> +                                       ls_corr_config->ls_rdata_tbl[n + i]);
> +                               REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_1,
> +                                       ls_corr_config->ls_rdata_tbl
> +                                       [n + i + 1]);
> +                               REG_WRITE(mrv_reg->isp_lsc_r_table_data, data);
> +                               REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_0,
> +                                       ls_corr_config->ls_gdata_tbl
> +                                       [n + i]);
> +                               REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_1,
> +                                       ls_corr_config->ls_gdata_tbl
> +                                       [n + i + 1]);
> +                               REG_WRITE(mrv_reg->isp_lsc_g_table_data, data);
> +                               REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_0,
> +                                       ls_corr_config->ls_bdata_tbl[n + i]);
> +                               REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_1,
> +                                       ls_corr_config->ls_bdata_tbl
> +                                       [n + i + 1]);
> +                               REG_WRITE(mrv_reg->isp_lsc_b_table_data, data);
> +                       }
> +
> +                       REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_0,
> +                               ls_corr_config->ls_rdata_tbl
> +                               [n + CI_ISP_MAX_LSC_SECTORS]);
> +                       REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_1, 0);
> +                       REG_WRITE(mrv_reg->isp_lsc_r_table_data, data);
> +                       REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_0,
> +                               ls_corr_config->ls_gdata_tbl
> +                               [n + CI_ISP_MAX_LSC_SECTORS]);
> +                       REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_1, 0);
> +                       REG_WRITE(mrv_reg->isp_lsc_g_table_data, data);
> +                       REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_0,
> +                               ls_corr_config->ls_bdata_tbl
> +                               [n + CI_ISP_MAX_LSC_SECTORS]);
> +                       REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_1, 0);
> +                       REG_WRITE(mrv_reg->isp_lsc_b_table_data, data);
> +               }
> +
> +               /* program x size tables */
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_01, MRV_LSC_X_SECT_SIZE_0,
> +                             ls_corr_config->ls_xsize_tbl[0]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_01, MRV_LSC_X_SECT_SIZE_1,
> +                             ls_corr_config->ls_xsize_tbl[1]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_23, MRV_LSC_X_SECT_SIZE_2,
> +                             ls_corr_config->ls_xsize_tbl[2]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_23, MRV_LSC_X_SECT_SIZE_3,
> +                             ls_corr_config->ls_xsize_tbl[3]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_45, MRV_LSC_X_SECT_SIZE_4,
> +                             ls_corr_config->ls_xsize_tbl[4]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_45, MRV_LSC_X_SECT_SIZE_5,
> +                             ls_corr_config->ls_xsize_tbl[5]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_67, MRV_LSC_X_SECT_SIZE_6,
> +                             ls_corr_config->ls_xsize_tbl[6]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_67, MRV_LSC_X_SECT_SIZE_7,
> +                             ls_corr_config->ls_xsize_tbl[7]);
> +
> +               /* program y size tables */
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_01, MRV_LSC_Y_SECT_SIZE_0,
> +                             ls_corr_config->ls_ysize_tbl[0]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_01, MRV_LSC_Y_SECT_SIZE_1,
> +                             ls_corr_config->ls_ysize_tbl[1]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_23, MRV_LSC_Y_SECT_SIZE_2,
> +                             ls_corr_config->ls_ysize_tbl[2]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_23, MRV_LSC_Y_SECT_SIZE_3,
> +                             ls_corr_config->ls_ysize_tbl[3]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_45, MRV_LSC_Y_SECT_SIZE_4,
> +                             ls_corr_config->ls_ysize_tbl[4]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_45, MRV_LSC_Y_SECT_SIZE_5,
> +                             ls_corr_config->ls_ysize_tbl[5]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_67, MRV_LSC_Y_SECT_SIZE_6,
> +                             ls_corr_config->ls_ysize_tbl[6]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_67, MRV_LSC_Y_SECT_SIZE_7,
> +                             ls_corr_config->ls_ysize_tbl[7]);
> +
> +               /* program x grad tables */
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_01, MRV_LSC_XGRAD_0,
> +                             ls_corr_config->ls_xgrad_tbl[0]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_01, MRV_LSC_XGRAD_1,
> +                             ls_corr_config->ls_xgrad_tbl[1]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_23, MRV_LSC_XGRAD_2,
> +                             ls_corr_config->ls_xgrad_tbl[2]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_23, MRV_LSC_XGRAD_3,
> +                             ls_corr_config->ls_xgrad_tbl[3]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_45, MRV_LSC_XGRAD_4,
> +                             ls_corr_config->ls_xgrad_tbl[4]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_45, MRV_LSC_XGRAD_5,
> +                             ls_corr_config->ls_xgrad_tbl[5]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_67, MRV_LSC_XGRAD_6,
> +                             ls_corr_config->ls_xgrad_tbl[6]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_67, MRV_LSC_XGRAD_7,
> +                             ls_corr_config->ls_xgrad_tbl[7]);
> +
> +               /* program y grad tables */
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_01, MRV_LSC_YGRAD_0,
> +                             ls_corr_config->ls_ygrad_tbl[0]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_01, MRV_LSC_YGRAD_1,
> +                             ls_corr_config->ls_ygrad_tbl[1]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_23, MRV_LSC_YGRAD_2,
> +                             ls_corr_config->ls_ygrad_tbl[2]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_23, MRV_LSC_YGRAD_3,
> +                             ls_corr_config->ls_ygrad_tbl[3]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_45, MRV_LSC_YGRAD_4,
> +                             ls_corr_config->ls_ygrad_tbl[4]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_45, MRV_LSC_YGRAD_5,
> +                             ls_corr_config->ls_ygrad_tbl[5]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_67, MRV_LSC_YGRAD_6,
> +                             ls_corr_config->ls_ygrad_tbl[6]);
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_67, MRV_LSC_YGRAD_7,
> +                             ls_corr_config->ls_ygrad_tbl[7]);
> +
> +               if (enabled) {
> +                       /* switch on lens chading correction */
> +                       REG_SET_SLICE(mrv_reg->isp_lsc_ctrl,
> +                                     MRV_LSC_LSC_EN, ENABLE);
> +               }
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_ls_correction_on_off(int ls_corr_on_off)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (ls_corr_on_off) {
> +               /* switch on lens chading correction */
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, ENABLE);
> +       } else {
> +               /* switch off lens chading correction */
> +               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, DISABLE);
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Sets the Bad Pixel Correction configuration
> + */
> +int ci_isp_set_bp_correction(const struct ci_isp_bp_corr_config
> +                             *bp_corr_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_bp_ctrl = REG_READ(mrv_reg->isp_bp_ctrl);
> +
> +       if (!bp_corr_config) {
> +               /* disable correction module */
> +               REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, DISABLE);
> +               REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, DISABLE);
> +       } else {
> +               if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_DIRECT) {
> +                       u32 isp_bp_cfg1 = REG_READ(mrv_reg->isp_bp_cfg1);
> +                       u32 isp_bp_cfg2 = REG_READ(mrv_reg->isp_bp_cfg2);
> +
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_COR_TYPE,
> +                                     MRV_BP_COR_TYPE_DIRECT);
> +
> +                       WARN_ON(!(!REG_GET_SLICE(mrv_reg->isp_bp_ctrl,
> +                                                MRV_BP_BP_DET_EN)));
> +
> +                       /* threshold register only used for direct mode */
> +                       REG_SET_SLICE(isp_bp_cfg1, MRV_BP_HOT_THRES,
> +                                     bp_corr_config->bp_abs_hot_thres);
> +                       REG_SET_SLICE(isp_bp_cfg1, MRV_BP_DEAD_THRES,
> +                                     bp_corr_config->bp_abs_dead_thres);
> +                       REG_WRITE(mrv_reg->isp_bp_cfg1, isp_bp_cfg1);
> +                       REG_SET_SLICE(isp_bp_cfg2, MRV_BP_DEV_HOT_THRES,
> +                                     bp_corr_config->bp_dev_hot_thres);
> +                       REG_SET_SLICE(isp_bp_cfg2, MRV_BP_DEV_DEAD_THRES,
> +                                     bp_corr_config->bp_dev_dead_thres);
> +                       REG_WRITE(mrv_reg->isp_bp_cfg2, isp_bp_cfg2);
> +               } else {
> +                       /* use bad pixel table */
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_COR_TYPE,
> +                                     MRV_BP_COR_TYPE_TABLE);
> +               }
> +
> +               if (bp_corr_config->bp_corr_rep == CI_ISP_BP_CORR_REP_LIN) {
> +                       /* use linear approch */
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_REP_APPR,
> +                                     MRV_BP_REP_APPR_INTERPOL);
> +               } else {
> +                       /* use best neighbour */
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_REP_APPR,
> +                                     MRV_BP_REP_APPR_NEAREST);
> +               }
> +
> +               switch (bp_corr_config->bp_corr_mode) {
> +               case CI_ISP_BP_CORR_HOT_EN:
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, ENABLE);
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, DISABLE);
> +                       break;
> +               case CI_ISP_BP_CORR_DEAD_EN:
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, DISABLE);
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, ENABLE);
> +                       break;
> +               case CI_ISP_BP_CORR_HOT_DEAD_EN:
> +               default:
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, ENABLE);
> +                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, ENABLE);
> +                       break;
> +               }
> +       }
> +
> +       REG_WRITE(mrv_reg->isp_bp_ctrl, isp_bp_ctrl);
> +
> +       return CI_STATUS_SUCCESS;
> +
> +}
> +
> +/*
> + * Sets the Bad Pixel configuration for detection
> + */
> +int ci_isp_set_bp_detection(const struct ci_isp_bp_det_config *bp_det_config)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (!bp_det_config) {
> +               REG_SET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_BP_DET_EN, DISABLE);
> +       } else {
> +               WARN_ON(!(REG_GET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_COR_TYPE)
> +                         == MRV_BP_COR_TYPE_TABLE));
> +
> +               /* set dead threshold for bad pixel detection */
> +               REG_SET_SLICE(mrv_reg->isp_bp_cfg1, MRV_BP_DEAD_THRES,
> +                             bp_det_config->bp_dead_thres);
> +
> +               /* enable measurement module */
> +               REG_SET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_BP_DET_EN, ENABLE);
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_clear_bp_int(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       /* clear bp_det irq (only if it is signalled to prevent loss of irqs) */
> +       if (REG_GET_SLICE(mrv_reg->isp_ris, MRV_ISP_RIS_BP_DET))
> +               REG_SET_SLICE(mrv_reg->isp_icr, MRV_ISP_ICR_BP_DET, 1);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Initializes Isp filter registers with default reset values.
> + */
> +static int ci_isp_initialize_filter_registers(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       mrv_reg->isp_filt_mode = 0x00000000;
> +       mrv_reg->isp_filt_fac_sh1 = 0x00000010;
> +       mrv_reg->isp_filt_fac_sh0 = 0x0000000C;
> +       mrv_reg->isp_filt_fac_mid = 0x0000000A;
> +       mrv_reg->isp_filt_fac_bl0 = 0x00000006;
> +       mrv_reg->isp_filt_fac_bl1 = 0x00000002;
> +       mrv_reg->isp_filt_thresh_bl0 = 0x0000000D;
> +       mrv_reg->isp_filt_thresh_bl1 = 0x00000005;
> +       mrv_reg->isp_filt_thresh_sh0 = 0x0000001A;
> +       mrv_reg->isp_filt_thresh_sh1 = 0x0000002C;
> +       mrv_reg->isp_filt_lum_weight = 0x00032040;
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_isp_activate_filter(int activate_filter)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       int retval = CI_STATUS_SUCCESS;
> +
> +       /* Initialize ISP filter control registers first */
> +       retval = ci_isp_initialize_filter_registers();
> +       if (retval != CI_STATUS_SUCCESS)
> +               return retval;
> +
> +       /* Activate or deactivate filter algorythm */
> +       REG_SET_SLICE(mrv_reg->isp_filt_mode, MRV_FILT_FILT_ENABLE,
> +               (activate_filter) ? ENABLE : DISABLE);
> +
> +       return retval;
> +}
> +
> +/*
> + * Write coefficient and threshold values into Isp filter
> + * registers for noise, sharpness and blurring filtering.
> + */
> +int ci_isp_set_filter_params(u8 noise_reduc_level, u8 sharp_level)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 isp_filt_mode = 0;
> +
> +       if (!REG_GET_SLICE(mrv_reg->isp_filt_mode, MRV_FILT_FILT_ENABLE))
> +               return CI_STATUS_CANCELED;
> +
> +       REG_WRITE(mrv_reg->isp_filt_mode, isp_filt_mode);
> +
> +       if (((noise_reduc_level <= 10) || (noise_reduc_level == 99))
> +           && (sharp_level <= 10)) {

Handle the 'else' case first, saves a whole indentation for the rest.

> +               switch (noise_reduc_level) {
> +               case 99:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 0x000003FF);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 0x000003FF);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 0x000003FF);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 0x000003FF);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 0);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_BYPASS);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_BYPASS);
> +                       break;
> +
> +               case 0:
> +                       /* NoiseReductionLevel = 0 */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 0x000000);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 0x000000);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 0x000000);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 0x000000);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 6);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC8);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_BYPASS);
> +                       break;
> +
> +               case 1:
> +                       /* NoiseReductionLevel = 1; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 33);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 18);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 8);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 2);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 6);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 2:
> +                       /* NoiseReductionLevel = 2; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 44);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 26);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 13);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 5);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 4);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 3:
> +                       /* NoiseReductionLevel = 3; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 51);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 36);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 23);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 10);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 4);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 4:
> +                       /* NoiseReductionLevel = 4; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 67);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 41);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 26);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 15);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 3);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 5:
> +                       /* NoiseReductionLevel = 5; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 100);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 75);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 50);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 20);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 3);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 6:
> +                       /* NoiseReductionLevel = 6; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 120);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 90);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 60);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 26);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 2);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 7:
> +                       /* NoiseReductionLevel = 7; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 150);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 120);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 80);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 51);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 2);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 8:
> +                       /* NoiseReductionLevel = 8; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 200);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 170);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 140);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 100);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 2);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 9:
> +                       /* NoiseReductionLevel = 9; */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 300);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 250);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 180);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 150);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
> +                                     (sharp_level > 3) ? 2 : 1);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               case 10:
> +                       /* NoiseReductionLevel = 10; extrem noise */
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                     MRV_FILT_FILT_THRESH_SH1, 1023);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 1023);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
> +                                     MRV_FILT_FILT_THRESH_BL0, 1023);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
> +                                     MRV_FILT_FILT_THRESH_BL1, 1023);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
> +                                     (sharp_level > 5) ? 2 :
> +                                     ((sharp_level > 3) ? 1 : 0));
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
> +                                     MRV_FILT_FILT_CHR_V_MODE_STATIC12);
> +                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
> +                                     MRV_FILT_FILT_CHR_H_MODE_DYN_2);
> +                       break;
> +
> +               default:
> +                       return CI_STATUS_OUTOFRANGE;
> +               }

This code suggests a table lookup, or a switch where you just set some variables
and do the actual register settings after the switch.

> +
> +               switch (sharp_level) {
> +               case 0:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x00000004);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x00000004);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x00000004);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x00000002);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000000);
> +                       break;
> +
> +               /* SharpLevel = 1; */
> +               case 1:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x00000008);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x00000007);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x00000006);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x00000002);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000000);
> +                       break;
> +
> +               /* SharpLevel = 2; */
> +               case 2:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x0000000C);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x0000000A);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x00000008);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x00000004);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000000);
> +                       break;
> +
> +               /* SharpLevel = 3; */
> +               case 3:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x00000010);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x0000000C);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x0000000A);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x00000006);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000002);
> +                       break;
> +
> +               /* SharpLevel = 4; */
> +               case 4:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x00000016);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x00000010);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x0000000C);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x00000008);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000004);
> +                       break;
> +
> +               /* SharpLevel = 5; */
> +               case 5:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x0000001B);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x00000014);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x00000010);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x0000000A);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000004);
> +                       break;
> +
> +               /* SharpLevel = 6; */
> +               case 6:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x00000020);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x0000001A);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x00000013);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x0000000C);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000006);
> +                       break;
> +
> +               /* SharpLevel = 7; */
> +               case 7:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x00000026);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x0000001E);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x00000017);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x00000010);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000008);
> +                       break;
> +
> +               /* SharpLevel = 8; */
> +               case 8:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 0x00000013);
> +                       if (REG_GET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                            MRV_FILT_FILT_THRESH_SH1) > 0x0000008A) {
> +                               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                             MRV_FILT_FILT_THRESH_SH1,
> +                                             0x0000008A);
> +                       }
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x0000002C);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x00000024);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x0000001D);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x00000015);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x0000000D);
> +                       break;
> +
> +               /* SharpLevel = 9; */
> +               case 9:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
> +                                     MRV_FILT_FILT_THRESH_SH0, 0x00000013);
> +                       if (REG_GET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                               MRV_FILT_FILT_THRESH_SH1) > 0x0000008A) {
> +                               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
> +                                             MRV_FILT_FILT_THRESH_SH1,
> +                                             0x0000008A);
> +                       }
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                                     MRV_FILT_FILT_FAC_SH1, 0x00000030);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                                     MRV_FILT_FILT_FAC_SH0, 0x0000002A);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                                     MRV_FILT_FILT_FAC_MID, 0x00000022);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                     MRV_FILT_FILT_FAC_BL0, 0x0000001A);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                     MRV_FILT_FILT_FAC_BL1, 0x00000014);
> +                       break;
> +
> +               /* SharpLevel = 10; */
> +               case 10:
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
> +                               MRV_FILT_FILT_FAC_SH1, 0x0000003F);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
> +                               MRV_FILT_FILT_FAC_SH0, 0x00000030);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
> +                               MRV_FILT_FILT_FAC_MID, 0x00000028);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                               MRV_FILT_FILT_FAC_BL0, 0x00000024);
> +                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                               MRV_FILT_FILT_FAC_BL1, 0x00000020);
> +                       break;
> +
> +               default:
> +                       return CI_STATUS_OUTOFRANGE;
> +               }

A table lookup should simplify this.

> +
> +               if (noise_reduc_level > 7) {
> +                       if (sharp_level > 7) {
> +                               u32 filt_fac_bl0 = REG_GET_SLICE
> +                                       (mrv_reg->isp_filt_fac_bl0,
> +                                       MRV_FILT_FILT_FAC_BL0);
> +                               u32 filt_fac_bl1 =
> +                                   REG_GET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                       MRV_FILT_FILT_FAC_BL1);
> +                               /* * 0.50 */
> +                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                       MRV_FILT_FILT_FAC_BL0,
> +                                       (filt_fac_bl0) >> 1);
> +                               /* * 0.25 */
> +                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                       MRV_FILT_FILT_FAC_BL1,
> +                                       (filt_fac_bl1) >> 2);
> +                       } else if (sharp_level > 4) {
> +                               u32 filt_fac_bl0 =
> +                                   REG_GET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                       MRV_FILT_FILT_FAC_BL0);
> +                               u32 filt_fac_bl1 =
> +                                   REG_GET_SLICE(mrv_reg->
> +                                                 isp_filt_fac_bl1,
> +                                                 MRV_FILT_FILT_FAC_BL1);
> +                               /* * 0.75 */
> +                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
> +                                       MRV_FILT_FILT_FAC_BL0,
> +                                       (filt_fac_bl0 * 3) >> 2);
> +                               /* * 0.50 */
> +                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
> +                                       MRV_FILT_FILT_FAC_BL1,
> +                                       (filt_fac_bl1) >> 1);
> +                       }
> +               }
> +
> +               /* Set ISP filter mode register values */
> +               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_MODE,
> +                             MRV_FILT_FILT_MODE_DYNAMIC);
> +
> +               /* enable filter */
> +               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_ENABLE, ENABLE);
> +               REG_WRITE(mrv_reg->isp_filt_mode, isp_filt_mode);
> +
> +               return CI_STATUS_SUCCESS;
> +       } else {
> +               /* At least one function parameter is out of range */
> +               return CI_STATUS_OUTOFRANGE;
> +       }
> +}
> +
> +int ci_isp_meas_exposure_initialize_module(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       REG_SET_SLICE(mrv_reg->isp_exp_h_size, MRV_AE_ISP_EXP_H_SIZE, 0);
> +       REG_SET_SLICE(mrv_reg->isp_exp_v_size, MRV_AE_ISP_EXP_V_SIZE, 0);
> +       REG_SET_SLICE(mrv_reg->isp_exp_h_offset, MRV_AE_ISP_EXP_H_OFFSET, 0);
> +       REG_SET_SLICE(mrv_reg->isp_exp_v_offset, MRV_AE_ISP_EXP_V_OFFSET, 0);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Configures the exposure measurement module.
> + */
> +int ci_isp_meas_exposure_set_config(const struct ci_isp_window *wnd,
> +                                   const struct ci_isp_exp_ctrl *isp_exp_ctrl)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       if (!wnd) {
> +               REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_AUTOSTOP, ON);
> +               REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_EXP_START, OFF);
> +               return CI_STATUS_SUCCESS;
> +       }
> +
> +       /* range check */
> +       if ((wnd->hoffs > MRV_AE_ISP_EXP_H_OFFSET_MAX)
> +           || (wnd->hsize > MRV_AE_ISP_EXP_H_SIZE_MAX)
> +           || (wnd->voffs > MRV_AE_ISP_EXP_V_OFFSET_MAX)
> +           || (wnd->vsize > MRV_AE_ISP_EXP_V_SIZE_MAX)
> +           || (wnd->vsize & ~MRV_AE_ISP_EXP_V_SIZE_VALID_MASK))
> +               return CI_STATUS_OUTOFRANGE;
> +
> +       /* configure measurement windows */
> +       REG_SET_SLICE(mrv_reg->isp_exp_h_size, MRV_AE_ISP_EXP_H_SIZE,
> +                     wnd->hsize);
> +       REG_SET_SLICE(mrv_reg->isp_exp_v_size, MRV_AE_ISP_EXP_V_SIZE,
> +                     wnd->vsize);
> +       REG_SET_SLICE(mrv_reg->isp_exp_h_offset, MRV_AE_ISP_EXP_H_OFFSET,
> +                     wnd->hoffs);
> +       REG_SET_SLICE(mrv_reg->isp_exp_v_offset, MRV_AE_ISP_EXP_V_OFFSET,
> +                     wnd->voffs);
> +
> +       /* set exposure measurement mode */
> +       REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_EXP_MEAS_MODE,
> +               (isp_exp_ctrl->exp_meas_mode) ? ON : OFF);
> +
> +       /* set or clear AE autostop bit */
> +       REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_AUTOSTOP,
> +                     (isp_exp_ctrl->auto_stop) ? ON : OFF);
> +       REG_SET_SLICE(mrv_reg->isp_exp_ctrl, MRV_AE_EXP_START,
> +                     (isp_exp_ctrl->exp_start) ? ON : OFF);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Programs the given gamma curve for the input gamma
> + * block. Enables or disables gamma processing for the
> + * input gamma block.
> + */
> +void ci_isp_set_gamma(const struct ci_sensor_gamma_curve *r,
> +                     const struct ci_sensor_gamma_curve *g,
> +                     const struct ci_sensor_gamma_curve *b)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
> +       const u8 shift_val = 16 - 12 /*MARVIN_FEATURE_CAMBUSWIDTH*/;
> +       const u16 round_ofs = 0 << (shift_val - 1);
> +       s32 i;
> +
> +       if (r) {
> +               REG_WRITE(mrv_reg->isp_gamma_dx_lo, r->gamma_dx0);
> +               REG_WRITE(mrv_reg->isp_gamma_dx_hi, r->gamma_dx1);
> +
> +               for (i = 0; i < MRV_ISP_GAMMA_R_Y_ARR_SIZE; i++) {
> +                       REG_SET_SLICE(mrv_reg->isp_gamma_r_y[i],
> +                             MRV_ISP_GAMMA_R_Y,
> +                             (r->isp_gamma_y[i] + round_ofs) >> shift_val);
> +                       REG_SET_SLICE(mrv_reg->isp_gamma_g_y[i],
> +                             MRV_ISP_GAMMA_G_Y,
> +                             (g->isp_gamma_y[i] + round_ofs) >> shift_val);
> +                       REG_SET_SLICE(mrv_reg->isp_gamma_b_y[i],
> +                             MRV_ISP_GAMMA_B_Y,
> +                             (b->isp_gamma_y[i] + round_ofs) >> shift_val);
> +               }
> +
> +               REG_SET_SLICE(mrv_reg->isp_ctrl,
> +               MRV_ISP_ISP_GAMMA_IN_ENABLE, ENABLE);
> +       } else {
> +               REG_SET_SLICE(mrv_reg->isp_ctrl,
> +               MRV_ISP_ISP_GAMMA_IN_ENABLE, DISABLE);
> +       }
> +}
> +
> +/*
> + * Programs the given gamma curve for the output gamma
> + * block. Enables or disables gamma processing for the
> + * output gamma block.
> + */
> +void ci_isp_set_gamma2(const struct ci_isp_gamma_out_curve *gamma)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       s32 i;
> +
> +       if (gamma) {
> +               WARN_ON(!(MRV_ISP_GAMMA_OUT_Y_ARR_SIZE ==
> +                       CI_ISP_GAMMA_OUT_CURVE_ARR_SIZE));
> +
> +               for (i = 0; i < MRV_ISP_GAMMA_OUT_Y_ARR_SIZE; i++) {
> +                       REG_SET_SLICE(mrv_reg->isp_gamma_out_y[i],
> +                                     MRV_ISP_ISP_GAMMA_OUT_Y,
> +                                     gamma->isp_gamma_y[i]);
> +               }
> +
> +               REG_SET_SLICE(mrv_reg->isp_gamma_out_mode, MRV_ISP_EQU_SEGM,
> +                             gamma->gamma_segmentation);
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GAMMA_OUT_ENABLE,
> +                             ENABLE);
> +       } else {
> +               REG_SET_SLICE(mrv_reg->isp_ctrl,
> +               MRV_ISP_ISP_GAMMA_OUT_ENABLE, DISABLE);
> +       }
> +
> +}
> diff --git a/drivers/media/video/mrstci/mrstisp/mrstisp_jpe.c b/drivers/media/video/mrstci/mrstisp/mrstisp_jpe.c
> new file mode 100644
> index 0000000..c042e06
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/mrstisp_jpe.c
> @@ -0,0 +1,569 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include "mrstisp_stdinc.h"
> +
> +int ci_isp_jpe_init_ex(u16 hsize, u16 vsize, u8 compression_ratio, u8 jpe_scale)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       /*
> +        * Reset JPEG-Encoder. In contrast to other software resets
> +        * this triggers the modules asynchronous reset resulting
> +        * in loss of all data.
> +        */
> +
> +       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_JPEG_SOFT_RST, ON);
> +       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_JPEG_SOFT_RST, OFF);
> +
> +       /* set configuration for the Jpeg capturing */
> +       ci_isp_jpe_set_config(hsize, vsize, jpe_scale);
> +
> +       /*
> +        * Sleep a while before setting up tables because of the 400
> +        * clock cycles required to initialize the table RAM after a
> +        * reset was issued. On FPGA we are running with only 30MHz,
> +        * so at least 13us are required.
> +        */
> +
> +
> +       /*
> +        * Note: this func is called when holding spin lock,
> +        * so can not change to msleep.
> +        */
> +       mdelay(15);
> +
> +       /* program tables */
> +       ci_isp_jpe_set_tables(compression_ratio);
> +
> +       /* choose tables */
> +       ci_isp_jpe_select_tables();
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * initialization of JPEG encoder
> + */
> +int ci_isp_jpe_init(u32 resolution, u8 compression_ratio, int jpe_scale)
> +{
> +       u16 hsize = 0;
> +       u16 vsize = 0;
> +
> +       switch (resolution) {
> +       case SENSOR_RES_BP1:
> +               /* 352; */
> +               hsize = BP1_SIZE_H;
> +               /* 240; */
> +               vsize = BP1_SIZE_V;
> +               break;
> +       case SENSOR_RES_S_AFM:
> +               /* 64; */
> +               hsize = S_AFM_SIZE_H;
> +               /* 32; */
> +               vsize = S_AFM_SIZE_V;
> +               break;
> +       case SENSOR_RES_M_AFM:
> +               /* 128; */
> +               hsize = M_AFM_SIZE_H;
> +               /* 96; */
> +               vsize = M_AFM_SIZE_V;
> +               break;
> +       case SENSOR_RES_L_AFM:
> +               /* 720; */
> +               hsize = L_AFM_SIZE_H;
> +               /* 480; */
> +               vsize = L_AFM_SIZE_V;
> +               break;
> +       case SENSOR_RES_QQCIF:
> +               /* 88; */
> +               hsize = QQCIF_SIZE_H;
> +               /* 72; */
> +               vsize = QQCIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_QQVGA:
> +               /* 160; */
> +               hsize = QQVGA_SIZE_H;
> +               /* 120; */
> +               vsize = QQVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QCIF:
> +               /* 176; */
> +               hsize = QCIF_SIZE_H;
> +               /* 144; */
> +               vsize = QCIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_QVGA:
> +               /* 320; */
> +               hsize = QVGA_SIZE_H;
> +               /* 240; */
> +               vsize = QVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_CIF:
> +               /* 352; */
> +               hsize = CIF_SIZE_H;
> +               /* 288; */
> +               vsize = CIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_VGA:
> +               /* 640; */
> +               hsize = VGA_SIZE_H;
> +               /* 480; */
> +               vsize = VGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_SVGA:
> +               /* 800; */
> +               hsize = SVGA_SIZE_H;
> +               /* 600; */
> +               vsize = SVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_XGA:
> +               /* 1024; */
> +               hsize = XGA_SIZE_H;
> +               /* 768; */
> +               vsize = XGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_XGA_PLUS:
> +               /* 1280; */
> +               hsize = XGA_PLUS_SIZE_H;
> +               /* 960; */
> +               vsize = XGA_PLUS_SIZE_V;
> +               break;
> +       case SENSOR_RES_SXGA:
> +               /* 1280; */
> +               hsize = SXGA_SIZE_H;
> +               /* 1024; */
> +               vsize = SXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_UXGA:
> +               /* 1600; */
> +               hsize = UXGA_SIZE_H;
> +               /* 1200; */
> +               vsize = UXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QXGA:
> +               /* 2048; */
> +               hsize = QXGA_SIZE_H;
> +               /* 1536; */
> +               vsize = QXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA:
> +               /* 2586; */
> +               hsize = QSXGA_SIZE_H;
> +               /* 2048; */
> +               vsize = QSXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS:
> +               /* 2600; */
> +               hsize = QSXGA_PLUS_SIZE_H;
> +               /* 2048; */
> +               vsize = QSXGA_PLUS_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS2:
> +               /* 2600; */
> +               hsize = QSXGA_PLUS2_SIZE_H;
> +               /* 1950; */
> +               vsize = QSXGA_PLUS2_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS3:
> +               /* 2686; */
> +               hsize = QSXGA_PLUS3_SIZE_H;
> +               /* 2048; */
> +               vsize = QSXGA_PLUS3_SIZE_V;
> +               break;
> +       case SENSOR_RES_WQSXGA:
> +               /* 3200 */
> +               hsize = WQSXGA_SIZE_H;
> +               /* 2048 */
> +               vsize = WQSXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QUXGA:
> +               /* 3200 */
> +               hsize = QUXGA_SIZE_H;
> +               /* 2400 */
> +               vsize = QUXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_WQUXGA:
> +               /* 3840 */
> +               hsize = WQUXGA_SIZE_H;
> +               /* 2400 */
> +               vsize = WQUXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_HXGA:
> +               /* 4096 */
> +               hsize = HXGA_SIZE_H;
> +               /* 3072 */
> +               vsize = HXGA_SIZE_V;
> +               break;
> +       default:
> +               eprintk("resolution not supported");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       return ci_isp_jpe_init_ex(hsize, vsize, compression_ratio, jpe_scale);
> +}
> +
> +void ci_isp_jpe_set_tables(u8 compression_ratio)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       /* required because auto-increment register */
> +       u32 jpe_table_data = 0;
> +
> +       u8 idx, size;
> +       const u8 *yqtable = NULL;
> +       const u8 *uvqtable = NULL;
> +
> +       switch (compression_ratio) {
> +       case CI_ISP_JPEG_LOW_COMPRESSION:
> +               yqtable = ci_isp_yq_table_low_comp1;
> +               uvqtable = ci_isp_uv_qtable_low_comp1;
> +               break;
> +       case CI_ISP_JPEG_01_PERCENT:
> +               yqtable = ci_isp_yq_table01_per_cent;
> +               uvqtable = ci_isp_uv_qtable01_per_cent;
> +               break;
> +       case CI_ISP_JPEG_20_PERCENT:
> +               yqtable = ci_isp_yq_table20_per_cent;
> +               uvqtable = ci_isp_uv_qtable20_per_cent;
> +               break;
> +       case CI_ISP_JPEG_30_PERCENT:
> +               yqtable = ci_isp_yq_table30_per_cent;
> +               uvqtable = ci_isp_uv_qtable30_per_cent;
> +               break;
> +       case CI_ISP_JPEG_40_PERCENT:
> +               yqtable = ci_isp_yq_table40_per_cent;
> +               uvqtable = ci_isp_uv_qtable40_per_cent;
> +               break;
> +       case CI_ISP_JPEG_50_PERCENT:
> +               yqtable = ci_isp_yq_table50_per_cent;
> +               uvqtable = ci_isp_uv_qtable50_per_cent;
> +               break;
> +       case CI_ISP_JPEG_60_PERCENT:
> +               yqtable = ci_isp_yq_table60_per_cent;
> +               uvqtable = ci_isp_uv_qtable60_per_cent;
> +               break;
> +       case CI_ISP_JPEG_70_PERCENT:
> +               yqtable = ci_isp_yq_table70_per_cent;
> +               uvqtable = ci_isp_uv_qtable70_per_cent;
> +               break;
> +       case CI_ISP_JPEG_80_PERCENT:
> +               yqtable = ci_isp_yq_table80_per_cent;
> +               uvqtable = ci_isp_uv_qtable80_per_cent;
> +               break;
> +       case CI_ISP_JPEG_90_PERCENT:
> +               yqtable = ci_isp_yq_table90_per_cent;
> +               uvqtable = ci_isp_uv_qtable90_per_cent;
> +               break;
> +       case CI_ISP_JPEG_99_PERCENT:
> +               yqtable = ci_isp_yq_table99_per_cent;
> +               uvqtable = ci_isp_uv_qtable99_per_cent;
> +               break;
> +       case CI_ISP_JPEG_HIGH_COMPRESSION:
> +       default:
> +               /*
> +                * in the case an unknown value is set,
> +                * use CI_JPEG_HIGH_COMPRESSION
> +                */
> +               yqtable = ci_isp_yq_table75_per_cent;
> +               uvqtable = ci_isp_uv_qtable75_per_cent;
> +               break;
> +       }
> +
> +       /* Y q-table 0 programming */
> +
> +       /* all possible assigned tables have same size */
> +       size = sizeof(ci_isp_yq_table75_per_cent)/
> +               sizeof(ci_isp_yq_table75_per_cent[0]);
> +       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
> +                     MRV_JPE_TABLE_ID_QUANT0);
> +       for (idx = 0; idx < (size - 1); idx += 2) {
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
> +                             yqtable[idx]);
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
> +                             yqtable[idx + 1]);
> +               /* auto-increment register! */
> +               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
> +       }
> +
> +       /* U/V q-table 0 programming */
> +
> +       /* all possible assigned tables have same size */
> +       size = sizeof(ci_isp_uv_qtable75_per_cent) /
> +               sizeof(ci_isp_uv_qtable75_per_cent[0]);
> +       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
> +                     MRV_JPE_TABLE_ID_QUANT1);
> +       for (idx = 0; idx < (size - 1); idx += 2) {
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
> +                             uvqtable[idx]);
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
> +                             uvqtable[idx + 1]);
> +               /* auto-increment register! */
> +               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
> +       }
> +
> +       /* Y AC-table 0 programming */
> +
> +       size = sizeof(ci_isp_ac_luma_table_annex_k) /
> +               sizeof(ci_isp_ac_luma_table_annex_k[0]);
> +       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
> +                     MRV_JPE_TABLE_ID_VLC_AC0);
> +       REG_SET_SLICE(mrv_reg->jpe_tac0_len, MRV_JPE_TAC0_LEN, size);
> +       for (idx = 0; idx < (size - 1); idx += 2) {
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
> +                             ci_isp_ac_luma_table_annex_k[idx]);
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
> +                             ci_isp_ac_luma_table_annex_k[idx + 1]);
> +               /* auto-increment register! */
> +               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
> +       }
> +
> +       /* U/V AC-table 1 programming */
> +
> +       size = sizeof(ci_isp_ac_chroma_table_annex_k) /
> +               sizeof(ci_isp_ac_chroma_table_annex_k[0]);
> +       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
> +                     MRV_JPE_TABLE_ID_VLC_AC1);
> +       REG_SET_SLICE(mrv_reg->jpe_tac1_len, MRV_JPE_TAC1_LEN, size);
> +       for (idx = 0; idx < (size - 1); idx += 2) {
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
> +                             ci_isp_ac_chroma_table_annex_k[idx]);
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
> +                             ci_isp_ac_chroma_table_annex_k[idx + 1]);
> +               /* auto-increment register! */
> +               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
> +       }
> +
> +       /* Y DC-table 0 programming */
> +
> +       size = sizeof(ci_isp_dc_luma_table_annex_k) /
> +               sizeof(ci_isp_dc_luma_table_annex_k[0]);
> +       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
> +                     MRV_JPE_TABLE_ID_VLC_DC0);
> +       REG_SET_SLICE(mrv_reg->jpe_tdc0_len, MRV_JPE_TDC0_LEN, size);
> +       for (idx = 0; idx < (size - 1); idx += 2) {
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
> +                             ci_isp_dc_luma_table_annex_k[idx]);
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
> +                             ci_isp_dc_luma_table_annex_k[idx + 1]);
> +               /* auto-increment register! */
> +               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
> +       }
> +
> +       /* U/V DC-table 1 programming */
> +
> +       size = sizeof(ci_isp_dc_chroma_table_annex_k) /
> +               sizeof(ci_isp_dc_chroma_table_annex_k[0]);
> +       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
> +                     MRV_JPE_TABLE_ID_VLC_DC1);
> +       REG_SET_SLICE(mrv_reg->jpe_tdc1_len, MRV_JPE_TDC1_LEN, size);
> +       for (idx = 0; idx < (size - 1); idx += 2) {
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
> +                             ci_isp_dc_chroma_table_annex_k[idx]);
> +               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
> +                             ci_isp_dc_chroma_table_annex_k[idx + 1]);
> +               /* auto-increment register! */
> +               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
> +       }
> +}
> +
> +/*
> + * selects tables to be used by encoder
> + */
> +void ci_isp_jpe_select_tables(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       /* selects quantization table for Y */
> +       REG_SET_SLICE(mrv_reg->jpe_tq_y_select, MRV_JPE_TQ0_SELECT,
> +                     MRV_JPE_TQ_SELECT_TAB0);
> +       /* selects quantization table for U */
> +       REG_SET_SLICE(mrv_reg->jpe_tq_u_select, MRV_JPE_TQ1_SELECT,
> +                     MRV_JPE_TQ_SELECT_TAB1);
> +       /* selects quantization table for V */
> +       REG_SET_SLICE(mrv_reg->jpe_tq_v_select, MRV_JPE_TQ2_SELECT,
> +                     MRV_JPE_TQ_SELECT_TAB1);
> +       /* selects Huffman DC table */
> +       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
> +                     MRV_JPE_DC_TABLE_SELECT_Y, 0);
> +       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
> +                     MRV_JPE_DC_TABLE_SELECT_U, 1);
> +       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
> +                     MRV_JPE_DC_TABLE_SELECT_V, 1);
> +       /* selects Huffman AC table */
> +       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
> +                     MRV_JPE_AC_TABLE_SELECT_Y, 0);
> +       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
> +                     MRV_JPE_AC_TABLE_SELECT_U, 1);
> +       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
> +                     MRV_JPE_AC_TABLE_SELECT_V, 1);
> +}
> +
> +/*
> + * configure JPEG encoder
> + */
> +void ci_isp_jpe_set_config(u16 hsize, u16 vsize, int jpe_scale)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       /* JPEG image size */
> +
> +       REG_SET_SLICE(mrv_reg->jpe_enc_hsize, MRV_JPE_ENC_HSIZE, hsize);
> +       REG_SET_SLICE(mrv_reg->jpe_enc_vsize, MRV_JPE_ENC_VSIZE, vsize);
> +
> +       if (jpe_scale) {
> +               /* upscaling of BT601 color space to full range 0..255 */
> +               REG_SET_SLICE(mrv_reg->jpe_y_scale_en, MRV_JPE_Y_SCALE_EN,
> +                             ENABLE);
> +               REG_SET_SLICE(mrv_reg->jpe_cbcr_scale_en,
> +                             MRV_JPE_CBCR_SCALE_EN, ENABLE);
> +       } else {
> +               /* bypass scaler */
> +               REG_SET_SLICE(mrv_reg->jpe_y_scale_en,
> +                             MRV_JPE_Y_SCALE_EN, DISABLE);
> +               REG_SET_SLICE(mrv_reg->jpe_cbcr_scale_en,
> +                             MRV_JPE_CBCR_SCALE_EN, DISABLE);
> +       }
> +
> +       /* picture format YUV 422 */
> +       REG_SET_SLICE(mrv_reg->jpe_pic_format, MRV_JPE_ENC_PIC_FORMAT,
> +                     MRV_JPE_ENC_PIC_FORMAT_422);
> +       REG_SET_SLICE(mrv_reg->jpe_table_flush, MRV_JPE_TABLE_FLUSH, 0);
> +}
> +
> +int ci_isp_jpe_generate_header(struct mrst_isp_device *intel, u8 header_mode)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       WARN_ON(!((header_mode == MRV_JPE_HEADER_MODE_JFIF)
> +           || (header_mode == MRV_JPE_HEADER_MODE_NO)));
> +
> +       /* clear jpeg gen_header_done interrupt */
> +       /* since we poll them later to detect command completion */
> +
> +       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_GEN_HEADER_DONE, 1);
> +       REG_SET_SLICE(mrv_reg->jpe_header_mode, MRV_JPE_HEADER_MODE,
> +                     header_mode);
> +
> +       /* start header generation */
> +       REG_SET_SLICE(mrv_reg->jpe_gen_header, MRV_JPE_GEN_HEADER, ON);
> +
> +       return ci_isp_jpe_wait_for_header_gen_done(intel);
> +}
> +
> +void ci_isp_jpe_prep_enc(enum ci_isp_jpe_enc_mode jpe_enc_mode)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 jpe_encode = REG_READ(mrv_reg->jpe_encode);
> +
> +       /* clear jpeg encode_done interrupt */
> +       /* since we poll them later to detect command completion */
> +
> +       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ENCODE_DONE, 1);
> +       REG_SET_SLICE(jpe_encode, MRV_JPE_ENCODE, ON);
> +
> +       switch (jpe_enc_mode) {
> +       case CI_ISP_JPE_LARGE_CONT_MODE:
> +               /* motion JPEG with header generation */
> +               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
> +                   MRV_JPE_CONT_MODE_HEADER);
> +               break;
> +       case CI_ISP_JPE_SHORT_CONT_MODE:
> +               /* motion JPEG only first frame with header */
> +               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
> +                   MRV_JPE_CONT_MODE_NEXT);
> +               break;
> +       default:
> +               /* single shot JPEG */
> +               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
> +                   MRV_JPE_CONT_MODE_STOP);
> +               break;
> +       }
> +
> +       REG_WRITE(mrv_reg->jpe_encode, jpe_encode);
> +       REG_SET_SLICE(mrv_reg->jpe_init, MRV_JPE_JP_INIT, 1);
> +}
> +
> +/*
> + * wait until JPG Header is generated (MRV_JPGINT_GEN_HEADER_DONE
> + *              interrupt occurs)
> + *              waiting for JPG Header to be generated
> + */
> +int ci_isp_jpe_wait_for_header_gen_done(struct mrst_isp_device *intel)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       mrst_timer_start();
> +
> +       while (!REG_GET_SLICE(mrv_reg->jpe_status_ris,
> +                              MRV_JPE_GEN_HEADER_DONE)) {
> +               if (mrst_get_micro_sec() > 2000000) {
> +                       mrst_timer_stop();
> +                       eprintk("timeout");
> +                       return CI_STATUS_FAILURE;
> +               }
> +       }
> +
> +       mrst_timer_stop();
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * wait until JPG Encoder is done  (MRV_JPGINT_ENCODE_DONE
> + * interrupt occurs) waiting for the JPG Encoder to be done
> + */
> +int ci_isp_jpe_wait_for_encode_done(struct mrst_isp_device *intel)
> +{
> +#if 0
> +       int ret = 0;
> +       INIT_COMPLETION(intel->jpe_complete);
> +       ret = wait_for_completion_interruptible_timeout(&intel->jpe_complete,
> +                                                       100 * HZ);
> +       if ((ret == 0) | (intel->irq_stat == IRQ_JPE_ERROR)) {
> +               eprintk("timeout");
> +               return CI_STATUS_FAILURE;
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +#endif
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       mrst_timer_start();
> +
> +       while (!REG_GET_SLICE(mrv_reg->jpe_status_ris,
> +                             MRV_JPE_ENCODE_DONE)) {
> +               if (mrst_get_micro_sec() > 200000) {
> +                       mrst_timer_stop();
> +                       eprintk("timeout");
> +                       return CI_STATUS_FAILURE;
> +               }
> +       }
> +
> +       mrst_timer_stop();
> +
> +       /* clear jpeg encode_done interrupt */
> +       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ENCODE_DONE, 1);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> diff --git a/drivers/media/video/mrstci/mrstisp/mrstisp_mif.c b/drivers/media/video/mrstci/mrstisp/mrstisp_mif.c
> new file mode 100644
> index 0000000..e88ffbc
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/mrstisp_mif.c
> @@ -0,0 +1,703 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include "mrstisp_stdinc.h"
> +
> +/*
> + * sets all main picture and self picture buffer offsets back to 0
> + */
> +void ci_isp_mif_reset_offsets(enum ci_isp_conf_update_time update_time)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       REG_SET_SLICE(mrv_reg->mi_mp_y_offs_cnt_init,
> +                     MRV_MI_MP_Y_OFFS_CNT_INIT, 0);
> +       REG_SET_SLICE(mrv_reg->mi_mp_cb_offs_cnt_init,
> +                     MRV_MI_MP_CB_OFFS_CNT_INIT, 0);
> +       REG_SET_SLICE(mrv_reg->mi_mp_cr_offs_cnt_init,
> +                     MRV_MI_MP_CR_OFFS_CNT_INIT, 0);
> +
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_offs_cnt_init,
> +                     MRV_MI_SP_Y_OFFS_CNT_INIT, 0);
> +       REG_SET_SLICE(mrv_reg->mi_sp_cb_offs_cnt_init,
> +                     MRV_MI_SP_CB_OFFS_CNT_INIT, 0);
> +       REG_SET_SLICE(mrv_reg->mi_sp_cr_offs_cnt_init,
> +                     MRV_MI_SP_CR_OFFS_CNT_INIT, 0);
> +
> +       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ON);
> +       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ON);
> +
> +       switch (update_time) {
> +       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +               break;
> +       case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
> +               break;
> +       case CI_ISP_CFG_UPDATE_LATER:
> +               break;
> +       default:
> +               break;
> +       }
> +}
> +
> +/*
> + * This function get the byte count from the last JPEG or raw data transfer
> + */
> +u32 ci_isp_mif_get_byte_cnt(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       return (u32) REG_GET_SLICE(mrv_reg->mi_byte_cnt, MRV_MI_BYTE_CNT);
> +}
> +
> +/*
> + * Sets the desired self picture orientation, if possible.
> + */
> +static int ci_isp_mif_set_self_pic_orientation(enum ci_isp_mif_sp_mode
> +                                               mrv_mif_sp_mode,
> +                                               int activate_self_path)
> +{
> +
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 mi_ctrl = REG_READ(mrv_reg->mi_ctrl);
> +
> +       u32 output_format = REG_GET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT);
> +
> +       switch (mrv_mif_sp_mode) {
> +       case CI_ISP_MIF_SP_ORIGINAL:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP, 0);
> +               break;
> +
> +       case CI_ISP_MIF_SP_HORIZONTAL_FLIP:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
> +                             MRV_MI_ROT_AND_FLIP_H_FLIP);
> +               break;
> +
> +       case CI_ISP_MIF_SP_VERTICAL_FLIP:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
> +                             MRV_MI_ROT_AND_FLIP_V_FLIP);
> +               break;
> +
> +       case CI_ISP_MIF_SP_ROTATION_090_DEG:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
> +                             MRV_MI_ROT_AND_FLIP_ROTATE);
> +               break;
> +
> +       case CI_ISP_MIF_SP_ROTATION_180_DEG:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
> +                             MRV_MI_ROT_AND_FLIP_H_FLIP |
> +                             MRV_MI_ROT_AND_FLIP_V_FLIP);
> +               break;
> +
> +       case CI_ISP_MIF_SP_ROTATION_270_DEG:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
> +                             MRV_MI_ROT_AND_FLIP_H_FLIP |
> +                             MRV_MI_ROT_AND_FLIP_V_FLIP |
> +                             MRV_MI_ROT_AND_FLIP_ROTATE);
> +               break;
> +
> +       case CI_ISP_MIF_SP_ROT_090_V_FLIP:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
> +                             MRV_MI_ROT_AND_FLIP_V_FLIP |
> +                             MRV_MI_ROT_AND_FLIP_ROTATE);
> +               break;
> +
> +       case CI_ISP_MIF_SP_ROT_270_V_FLIP:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
> +                             MRV_MI_ROT_AND_FLIP_H_FLIP |
> +                             MRV_MI_ROT_AND_FLIP_ROTATE);
> +               break;
> +
> +       default:
> +               eprintk("unknown value for mrv_mif_sp_mode");
> +               return CI_STATUS_NOTSUPP;
> +       }
> +
> +       if (REG_GET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP) &
> +           MRV_MI_ROT_AND_FLIP_ROTATE) {
> +               switch (output_format) {
> +               case MRV_MI_SP_OUTPUT_FORMAT_RGB888:
> +               case MRV_MI_SP_OUTPUT_FORMAT_RGB666:
> +               case MRV_MI_SP_OUTPUT_FORMAT_RGB565:
> +                       break;
> +               default:
> +                       eprintk("rotation is only allowed for RGB modes.");
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +       }
> +
> +       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_ENABLE,
> +                     (activate_self_path) ? ENABLE : DISABLE);
> +       REG_WRITE(mrv_reg->mi_ctrl, mi_ctrl);
> +       REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Checks the main or self picture path buffer structure.
> + */
> +static int ci_isp_mif_check_mi_path_conf(const struct ci_isp_mi_path_conf
> +                                        *isp_mi_path_conf, int main_buffer)
> +{
> +       if (!isp_mi_path_conf) {
> +               eprintk("isp_mi_path_conf is NULL");
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       if (!isp_mi_path_conf->ybuffer.pucbuffer) {
> +               eprintk("isp_mi_path_conf->ybuffer.pucbuffer is NULL");
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       if (main_buffer) {
> +               if ((((unsigned long)(isp_mi_path_conf->ybuffer.pucbuffer)
> +                     & ~(MRV_MI_MP_Y_BASE_AD_INIT_VALID_MASK)) != 0)
> +                       ||
> +                       ((isp_mi_path_conf->ybuffer.size
> +                       & ~(MRV_MI_MP_Y_SIZE_INIT_VALID_MASK)) != 0)
> +                       ||
> +                       ((isp_mi_path_conf->ybuffer.size
> +                       & (MRV_MI_MP_Y_SIZE_INIT_VALID_MASK)) == 0)
> +                       ||
> +                       ((isp_mi_path_conf->ybuffer.offs
> +                       & ~(MRV_MI_MP_Y_OFFS_CNT_INIT_VALID_MASK)) != 0)) {
> +                               return CI_STATUS_OUTOFRANGE;
> +               }
> +       } else {
> +               if ((((unsigned long) isp_mi_path_conf->ybuffer.pucbuffer
> +                       & ~(MRV_MI_SP_Y_BASE_AD_INIT_VALID_MASK)) != 0)
> +                       ||
> +                       ((isp_mi_path_conf->ybuffer.size &
> +                       ~(MRV_MI_SP_Y_SIZE_INIT_VALID_MASK)) != 0)
> +                       ||
> +                       ((isp_mi_path_conf->ybuffer.size &
> +                       (MRV_MI_SP_Y_SIZE_INIT_VALID_MASK)) == 0)
> +                       ||
> +                       ((isp_mi_path_conf->ybuffer.offs &
> +                       ~(MRV_MI_SP_Y_OFFS_CNT_INIT_VALID_MASK)) !=
> +                       0)
> +                       ||
> +                       ((isp_mi_path_conf->llength &
> +                       ~(MRV_MI_SP_Y_LLENGTH_VALID_MASK)) != 0)
> +                       ||
> +                       ((isp_mi_path_conf->
> +                       llength & (MRV_MI_SP_Y_LLENGTH_VALID_MASK)) == 0)) {
> +                       return CI_STATUS_OUTOFRANGE;
> +               }
> +       }
> +
> +       if (isp_mi_path_conf->cb_buffer.pucbuffer != 0) {
> +               if (main_buffer) {
> +                       if ((((unsigned long)
> +                               isp_mi_path_conf->cb_buffer.pucbuffer
> +                               & ~(MRV_MI_MP_CB_BASE_AD_INIT_VALID_MASK)) !=
> +                               0)
> +                               ||
> +                               ((isp_mi_path_conf->cb_buffer.size &
> +                               ~(MRV_MI_MP_CB_SIZE_INIT_VALID_MASK)) != 0)
> +                               ||
> +                               ((isp_mi_path_conf->cb_buffer.size &
> +                               (MRV_MI_MP_CB_SIZE_INIT_VALID_MASK)) == 0)
> +                               ||
> +                               ((isp_mi_path_conf->cb_buffer.offs &
> +                               ~(MRV_MI_MP_CB_OFFS_CNT_INIT_VALID_MASK)) !=
> +                               0)) {
> +                                       return CI_STATUS_OUTOFRANGE;
> +                       }
> +               } else {
> +                       if ((((unsigned long)
> +                               isp_mi_path_conf->cb_buffer.pucbuffer
> +                               & ~(MRV_MI_SP_CB_BASE_AD_INIT_VALID_MASK)) !=
> +                               0)
> +                               ||
> +                               ((isp_mi_path_conf->cb_buffer.size &
> +                               ~(MRV_MI_SP_CB_SIZE_INIT_VALID_MASK)) != 0)
> +                               ||
> +                               ((isp_mi_path_conf->cb_buffer.size &
> +                               (MRV_MI_SP_CB_SIZE_INIT_VALID_MASK)) == 0)
> +                               ||
> +                               ((isp_mi_path_conf->cb_buffer.offs &
> +                               ~(MRV_MI_SP_CB_OFFS_CNT_INIT_VALID_MASK)) !=
> +                               0)) {
> +                                       return CI_STATUS_OUTOFRANGE;
> +                       }
> +               }
> +       }
> +
> +       if (isp_mi_path_conf->cr_buffer.pucbuffer != 0) {
> +               if (main_buffer) {
> +                       if ((((unsigned long)
> +                               isp_mi_path_conf->cr_buffer.pucbuffer
> +                               & ~(MRV_MI_MP_CR_BASE_AD_INIT_VALID_MASK)) !=
> +                               0)
> +                               ||
> +                               ((isp_mi_path_conf->cr_buffer.size &
> +                               ~(MRV_MI_MP_CR_SIZE_INIT_VALID_MASK)) != 0)
> +                               ||
> +                               ((isp_mi_path_conf->cr_buffer.size &
> +                               (MRV_MI_MP_CR_SIZE_INIT_VALID_MASK)) == 0)
> +                               ||
> +                               ((isp_mi_path_conf->cr_buffer.offs &
> +                               ~(MRV_MI_MP_CR_OFFS_CNT_INIT_VALID_MASK)) !=
> +                               0)){
> +                                       return CI_STATUS_OUTOFRANGE;
> +                       }
> +               } else {
> +                       if ((((unsigned long)
> +                               isp_mi_path_conf->cr_buffer.pucbuffer
> +                               & ~(MRV_MI_SP_CR_BASE_AD_INIT_VALID_MASK))
> +                               != 0)
> +                           ||
> +                           ((isp_mi_path_conf->cr_buffer.size &
> +                             ~(MRV_MI_SP_CR_SIZE_INIT_VALID_MASK)) != 0)
> +                           ||
> +                           ((isp_mi_path_conf->cr_buffer.size &
> +                           (MRV_MI_SP_CR_SIZE_INIT_VALID_MASK)) == 0)
> +                           ||
> +                           ((isp_mi_path_conf->cr_buffer.offs &
> +                           ~(MRV_MI_SP_CR_OFFS_CNT_INIT_VALID_MASK)) != 0)) {
> +                               return CI_STATUS_OUTOFRANGE;
> +                       }
> +               }
> +       }
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +/*
> + * Configures the main picture path buffers of the MI.
> + */
> +int ci_isp_mif_set_main_buffer(const struct ci_isp_mi_path_conf
> +                              *isp_mi_path_conf,
> +                              enum ci_isp_conf_update_time update_time)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       int error = CI_STATUS_FAILURE;
> +
> +       error = ci_isp_mif_check_mi_path_conf(isp_mi_path_conf, true);
> +       if (error != CI_STATUS_SUCCESS)
> +               return error;
> +
> +       /* set register values */
> +       REG_SET_SLICE(mrv_reg->mi_mp_y_base_ad_init,
> +                     MRV_MI_MP_Y_BASE_AD_INIT,
> +                     (u32)(unsigned long)isp_mi_path_conf->ybuffer.pucbuffer);
> +       REG_SET_SLICE(mrv_reg->mi_mp_y_size_init, MRV_MI_MP_Y_SIZE_INIT,
> +                     isp_mi_path_conf->ybuffer.size);
> +       REG_SET_SLICE(mrv_reg->mi_mp_y_offs_cnt_init,
> +                     MRV_MI_MP_Y_OFFS_CNT_INIT,
> +                     isp_mi_path_conf->ybuffer.offs);
> +
> +       if (isp_mi_path_conf->cb_buffer.pucbuffer != 0) {
> +               REG_SET_SLICE(mrv_reg->mi_mp_cb_base_ad_init,
> +                             MRV_MI_MP_CB_BASE_AD_INIT,
> +                             (u32)(unsigned long) isp_mi_path_conf->cb_buffer.
> +                             pucbuffer);
> +               REG_SET_SLICE(mrv_reg->mi_mp_cb_size_init,
> +                             MRV_MI_MP_CB_SIZE_INIT,
> +                             isp_mi_path_conf->cb_buffer.size);
> +               REG_SET_SLICE(mrv_reg->mi_mp_cb_offs_cnt_init,
> +                             MRV_MI_MP_CB_OFFS_CNT_INIT,
> +                             isp_mi_path_conf->cb_buffer.offs);
> +       }
> +
> +       if (isp_mi_path_conf->cr_buffer.pucbuffer != 0) {
> +               REG_SET_SLICE(mrv_reg->mi_mp_cr_base_ad_init,
> +                             MRV_MI_MP_CR_BASE_AD_INIT,
> +                             (u32)(unsigned long) isp_mi_path_conf->cr_buffer.
> +                             pucbuffer);
> +               REG_SET_SLICE(mrv_reg->mi_mp_cr_size_init,
> +                             MRV_MI_MP_CR_SIZE_INIT,
> +                             isp_mi_path_conf->cr_buffer.size);
> +               REG_SET_SLICE(mrv_reg->mi_mp_cr_offs_cnt_init,
> +                             MRV_MI_MP_CR_OFFS_CNT_INIT,
> +                             isp_mi_path_conf->cr_buffer.offs);
> +       }
> +
> +       /*
> +        * update base and offset registers during next immediate or
> +        * automatic update request
> +        */
> +       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
> +       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
> +
> +       switch (update_time) {
> +       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ON);
> +               break;
> +       case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
> +               break;
> +       case CI_ISP_CFG_UPDATE_LATER:
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return error;
> +}
> +
> +/*
> + * Configures the self picture path buffers of the MI.
> + *
> + */
> +int ci_isp_mif_set_self_buffer(const struct ci_isp_mi_path_conf
> +                               *isp_mi_path_conf,
> +                               enum ci_isp_conf_update_time update_time)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       int error = CI_STATUS_FAILURE;
> +
> +       error = ci_isp_mif_check_mi_path_conf(isp_mi_path_conf, false);
> +       if (error != CI_STATUS_SUCCESS)
> +               return error;
> +
> +       /* set register values */
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_base_ad_init,
> +                     MRV_MI_SP_Y_BASE_AD_INIT,
> +                     (u32)(unsigned long)isp_mi_path_conf->ybuffer.pucbuffer);
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_size_init, MRV_MI_SP_Y_SIZE_INIT,
> +                     isp_mi_path_conf->ybuffer.size);
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_offs_cnt_init,
> +                     MRV_MI_SP_Y_OFFS_CNT_INIT,
> +                     isp_mi_path_conf->ybuffer.offs);
> +
> +       /*
> +        * llength is counted in pixels and this value could be stored
> +        * directly into the register
> +        */
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_llength, MRV_MI_SP_Y_LLENGTH,
> +                     isp_mi_path_conf->llength);
> +
> +       if (isp_mi_path_conf->cb_buffer.pucbuffer) {
> +               REG_SET_SLICE(mrv_reg->mi_sp_cb_base_ad_init,
> +                             MRV_MI_SP_CB_BASE_AD_INIT,
> +                             (u32) (unsigned long)isp_mi_path_conf->cb_buffer.
> +                             pucbuffer);
> +               REG_SET_SLICE(mrv_reg->mi_sp_cb_size_init,
> +                             MRV_MI_SP_CB_SIZE_INIT,
> +                             isp_mi_path_conf->cb_buffer.size);
> +               REG_SET_SLICE(mrv_reg->mi_sp_cb_offs_cnt_init,
> +                             MRV_MI_SP_CB_OFFS_CNT_INIT,
> +                             isp_mi_path_conf->cb_buffer.offs);
> +       }
> +
> +       if (isp_mi_path_conf->cr_buffer.pucbuffer) {
> +               REG_SET_SLICE(mrv_reg->mi_sp_cr_base_ad_init,
> +                             MRV_MI_SP_CR_BASE_AD_INIT,
> +                             (u32) (unsigned long)isp_mi_path_conf->cr_buffer.
> +                             pucbuffer);
> +               REG_SET_SLICE(mrv_reg->mi_sp_cr_size_init,
> +                             MRV_MI_SP_CR_SIZE_INIT,
> +                             isp_mi_path_conf->cr_buffer.size);
> +               REG_SET_SLICE(mrv_reg->mi_sp_cr_offs_cnt_init,
> +                             MRV_MI_SP_CR_OFFS_CNT_INIT,
> +                             isp_mi_path_conf->cr_buffer.offs);
> +       }
> +
> +       if ((!isp_mi_path_conf->ypic_width)
> +           || (!isp_mi_path_conf->ypic_height)) {
> +               return CI_STATUS_FAILURE;
> +       }
> +
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_width, MRV_MI_SP_Y_PIC_WIDTH,
> +                     isp_mi_path_conf->ypic_width);
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_height, MRV_MI_SP_Y_PIC_HEIGHT,
> +                     isp_mi_path_conf->ypic_height);
> +       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_size, MRV_MI_SP_Y_PIC_SIZE,
> +                     isp_mi_path_conf->ypic_height *
> +                     isp_mi_path_conf->llength);
> +
> +       /*
> +        * update base and offset registers during next immediate or
> +        * automatic update request
> +        */
> +       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
> +       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
> +
> +       switch (update_time) {
> +       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
> +               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
> +                             ON);
> +               break;
> +       case CI_ISP_CFG_UPDATE_IMMEDIATE:
> +               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
> +               break;
> +       case CI_ISP_CFG_UPDATE_LATER:
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return error;
> +}
> +
> +/*
> + * Configures the DMA path of the MI.
> + *
> + */
> +int ci_isp_mif_set_path_and_orientation(const struct ci_isp_mi_ctrl
> +                                       *mrv_mi_ctrl)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +       int error = CI_STATUS_OUTOFRANGE;
> +       u32 mi_ctrl = 0;
> +
> +       if (!mrv_mi_ctrl) {
> +               eprintk("mrv_mi_ctrl is NULL");
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       if ((mrv_mi_ctrl->irq_offs_init &
> +            ~(MRV_MI_MP_Y_IRQ_OFFS_INIT_VALID_MASK)) != 0) {
> +               eprintk("bad mrv_mi_ctrl->irq_offs_init value");
> +               return error;
> +       }
> +
> +       REG_SET_SLICE(mrv_reg->mi_mp_y_irq_offs_init,
> +                     MRV_MI_MP_Y_IRQ_OFFS_INIT, mrv_mi_ctrl->irq_offs_init);
> +
> +       /* main picture path */
> +       switch (mrv_mi_ctrl->main_path) {
> +       case CI_ISP_PATH_OFF:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_ENABLE, OFF);
> +               break;
> +       case CI_ISP_PATH_ON:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_ENABLE, ON);
> +               break;
> +       case CI_ISP_PATH_JPE:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_JPEG_ENABLE, ON);
> +               break;
> +       case CI_ISP_PATH_RAW8:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_RAW_ENABLE, ON);
> +               break;
> +       case CI_ISP_PATH_RAW816:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_RAW_ENABLE, ON);
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
> +                             MRV_MI_MP_WRITE_FORMAT_INTERLEAVED);
> +               break;
> +       default:
> +               eprintk("bad mrv_mi_ctrl->main_path value");
> +               return error;
> +       }
> +
> +       /* self picture path output format */
> +       switch (mrv_mi_ctrl->mrv_mif_sp_out_form) {
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_422:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
> +                             MRV_MI_SP_OUTPUT_FORMAT_YUV422);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_444:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
> +                             MRV_MI_SP_OUTPUT_FORMAT_YUV444);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_420:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
> +                             MRV_MI_SP_OUTPUT_FORMAT_YUV420);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_400:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
> +                             MRV_MI_SP_OUTPUT_FORMAT_YUV400);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_RGB_565:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
> +                             MRV_MI_SP_OUTPUT_FORMAT_RGB565);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_RGB_888:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
> +                             MRV_MI_SP_OUTPUT_FORMAT_RGB888);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_RGB_666:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
> +                             MRV_MI_SP_OUTPUT_FORMAT_RGB666);
> +               break;
> +
> +       default:
> +               eprintk("bad mrv_mi_ctrl->mrv_mif_sp_out_form value");
> +               return error;
> +       }
> +
> +       /* self picture path input format */
> +       switch (mrv_mi_ctrl->mrv_mif_sp_in_form) {
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_422:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
> +                             MRV_MI_SP_INPUT_FORMAT_YUV422);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_444:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
> +                             MRV_MI_SP_INPUT_FORMAT_YUV444);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_420:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
> +                             MRV_MI_SP_INPUT_FORMAT_YUV420);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_YCBCR_400:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
> +                             MRV_MI_SP_INPUT_FORMAT_YUV400);
> +               break;
> +       case CI_ISP_MIF_COL_FORMAT_RGB_565:
> +       case CI_ISP_MIF_COL_FORMAT_RGB_666:
> +       case CI_ISP_MIF_COL_FORMAT_RGB_888:
> +       default:
> +               eprintk("bad mrv_mi_ctrl->mrv_mif_sp_in_form value");
> +               return error;
> +       }
> +
> +       error = CI_STATUS_SUCCESS;
> +
> +       /* self picture path write format */
> +       switch (mrv_mi_ctrl->mrv_mif_sp_pic_form) {
> +       case CI_ISP_MIF_PIC_FORM_PLANAR:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
> +                             MRV_MI_SP_WRITE_FORMAT_PLANAR);
> +               break;
> +       case CI_ISP_MIF_PIC_FORM_SEMI_PLANAR:
> +               if ((mrv_mi_ctrl->mrv_mif_sp_out_form ==
> +                   CI_ISP_MIF_COL_FORMAT_YCBCR_422)
> +                   || (mrv_mi_ctrl->mrv_mif_sp_out_form ==
> +                   CI_ISP_MIF_COL_FORMAT_YCBCR_420)) {
> +                       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
> +                                     MRV_MI_SP_WRITE_FORMAT_SEMIPLANAR);
> +               } else {
> +                       error = CI_STATUS_NOTSUPP;
> +               }
> +               break;
> +       case CI_ISP_MIF_PIC_FORM_INTERLEAVED:
> +               if (mrv_mi_ctrl->mrv_mif_sp_out_form ==
> +                   CI_ISP_MIF_COL_FORMAT_YCBCR_422) {
> +                       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
> +                                     MRV_MI_SP_WRITE_FORMAT_INTERLEAVED);
> +               } else {
> +                       error = CI_STATUS_NOTSUPP;
> +               }
> +               break;
> +       default:
> +               error = CI_STATUS_OUTOFRANGE;
> +               break;
> +
> +       }
> +
> +       if (error != CI_STATUS_SUCCESS) {
> +               eprintk("bad mrv_mi_ctrl->mrv_mif_sp_pic_form value");
> +               return error;
> +       }
> +
> +       if (mrv_mi_ctrl->main_path == CI_ISP_PATH_ON) {
> +               /* for YCbCr mode only, permitted for raw mode */
> +               /* main picture path write format */
> +               switch (mrv_mi_ctrl->mrv_mif_mp_pic_form) {
> +               case CI_ISP_MIF_PIC_FORM_PLANAR:
> +                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
> +                                     MRV_MI_MP_WRITE_FORMAT_PLANAR);
> +                       break;
> +               case CI_ISP_MIF_PIC_FORM_SEMI_PLANAR:
> +                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
> +                                     MRV_MI_MP_WRITE_FORMAT_SEMIPLANAR);
> +                       break;
> +               case CI_ISP_MIF_PIC_FORM_INTERLEAVED:
> +                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
> +                                     MRV_MI_MP_WRITE_FORMAT_INTERLEAVED);
> +                       break;
> +               default:
> +                       error = CI_STATUS_OUTOFRANGE;
> +                       break;
> +               }
> +       }
> +
> +       if (error != CI_STATUS_SUCCESS) {
> +               eprintk("bad mrv_mi_ctrl->mrv_mif_mp_pic_form value");
> +               return error;
> +       }
> +
> +       REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_CHROM,
> +           MRV_MI_BURST_LEN_CHROM_16);
> +
> +       if (error != CI_STATUS_SUCCESS) {
> +               eprintk("bad mrv_mi_ctrl->burst_length_chrom value");
> +               return error;
> +       }
> +
> +       REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_LUM,
> +           MRV_MI_BURST_LEN_LUM_16);
> +
> +       if (error != CI_STATUS_SUCCESS) {
> +               eprintk("bad mrv_mi_ctrl->burst_length_lum value");
> +               return error;
> +       }
> +
> +       switch (mrv_mi_ctrl->init_vals) {
> +       case CI_ISP_MIF_NO_INIT_VALS:
> +               break;
> +       case CI_ISP_MIF_INIT_OFFS:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
> +               break;
> +       case CI_ISP_MIF_INIT_BASE:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
> +               break;
> +       case CI_ISP_MIF_INIT_OFFSAndBase:
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
> +               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
> +               break;
> +       default:
> +               error = CI_STATUS_OUTOFRANGE;
> +               break;
> +       }
> +
> +       if (error != CI_STATUS_SUCCESS) {
> +               eprintk("bad mrv_mi_ctrl->init_vals value");
> +               return error;
> +       }
> +
> +       /* enable change of byte order for write port */
> +       REG_SET_SLICE(mi_ctrl, MRV_MI_BYTE_SWAP,
> +           (mrv_mi_ctrl->byte_swap_enable) ? ON : OFF);
> +
> +       /* enable or disable the last pixel signalization */
> +       REG_SET_SLICE(mi_ctrl, MRV_MI_LAST_PIXEL_SIG_EN,
> +           (mrv_mi_ctrl->last_pixel_enable) ? ON : OFF);
> +
> +       /* now write settings into register */
> +       REG_WRITE(mrv_reg->mi_ctrl, mi_ctrl);
> +
> +       dprintk(2, "mi_ctrl = 0x%x", mi_ctrl);
> +
> +       /* self picture path operating mode */
> +       if ((mrv_mi_ctrl->self_path == CI_ISP_PATH_ON) ||
> +           (mrv_mi_ctrl->self_path == CI_ISP_PATH_OFF)) {
> +
> +               error = ci_isp_mif_set_self_pic_orientation(
> +                                   mrv_mi_ctrl->mrv_mif_sp_mode,
> +                                   (int) (mrv_mi_ctrl->self_path
> +                                          == CI_ISP_PATH_ON));
> +       } else {
> +               eprintk("bad mrv_mi_ctrl->self_path value");
> +               error = CI_STATUS_OUTOFRANGE;
> +       }
> +
> +       REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
> +
> +       return error;
> +}
> --
> 1.6.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Again, pretty decent code! Given the complexity I think you managed to keep
it readable, which is quite an achievement!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
