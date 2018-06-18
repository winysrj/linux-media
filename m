Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:43829 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753758AbeFRGJT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 02:09:19 -0400
Received: by mail-yw0-f195.google.com with SMTP id r19-v6so5257731ywc.10
        for <linux-media@vger.kernel.org>; Sun, 17 Jun 2018 23:09:19 -0700 (PDT)
Received: from mail-yb0-f171.google.com (mail-yb0-f171.google.com. [209.85.213.171])
        by smtp.gmail.com with ESMTPSA id n204-v6sm5583032ywb.72.2018.06.17.23.09.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Jun 2018 23:09:17 -0700 (PDT)
Received: by mail-yb0-f171.google.com with SMTP id d123-v6so5551460ybh.9
        for <linux-media@vger.kernel.org>; Sun, 17 Jun 2018 23:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-3-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-3-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 18 Jun 2018 15:09:05 +0900
Message-ID: <CAAFQd5A8wQVTdnwOM6X-P3J=TUv2RHOCZdWWjBd=MA7fTp5tDA@mail.gmail.com>
Subject: Re: [PATCH v6 02/12] intel-ipu3: Add user space API definitions
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
>
> Define the structures and macros to be used by public.
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  include/uapi/linux/intel-ipu3.h | 1403 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 1403 insertions(+)
>  create mode 100644 include/uapi/linux/intel-ipu3.h
>

Since we'll need 1 more resend with latest fixes from Chromium tree
and recently posted documentation anyway, let me do some more
nitpicking inline, so we can end up with slightly cleaner code. :)

> diff --git a/include/uapi/linux/intel-ipu3.h b/include/uapi/linux/intel-ipu3.h
> new file mode 100644
> index 000000000000..694ef0c8d7a7
> --- /dev/null
> +++ b/include/uapi/linux/intel-ipu3.h
> @@ -0,0 +1,1403 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */
> +
> +#ifndef __IPU3_UAPI_H
> +#define __IPU3_UAPI_H
> +
> +#include <linux/types.h>
> +
> +#define IPU3_UAPI_ISP_VEC_ELEMS                                64
> +
> +#define IMGU_ABI_PAD   __aligned(IPU3_UAPI_ISP_WORD_BYTES)

This seems unused.

> +#define IPU3_ALIGN     __attribute__((aligned(IPU3_UAPI_ISP_WORD_BYTES)))

Any reason to mix both __aligned() and  __attribute__((aligned()))?

> +
> +#define IPU3_UAPI_ISP_WORD_BYTES                       32

It would make sense to define this above IPU3_ALIGN(), which references it.

> +#define IPU3_UAPI_MAX_STRIPES                          2
> +
> +/******************* ipu3_uapi_stats_3a *******************/
> +
> +#define IPU3_UAPI_MAX_BUBBLE_SIZE                      10
> +
> +#define IPU3_UAPI_AE_COLORS                            4
> +#define IPU3_UAPI_AE_BINS                              256
> +
> +#define IPU3_UAPI_AWB_MD_ITEM_SIZE                     8
> +#define IPU3_UAPI_AWB_MAX_SETS                         60
> +#define IPU3_UAPI_AWB_SET_SIZE                         0x500

Why not just decimal 1280?

> +#define IPU3_UAPI_AWB_SPARE_FOR_BUBBLES \
> +       (IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> +        IPU3_UAPI_AWB_MD_ITEM_SIZE)
> +#define IPU3_UAPI_AWB_MAX_BUFFER_SIZE \
> +       (IPU3_UAPI_AWB_MAX_SETS * \
> +        (IPU3_UAPI_AWB_SET_SIZE + IPU3_UAPI_AWB_SPARE_FOR_BUBBLES))
> +
> +#define IPU3_UAPI_AF_MAX_SETS                          24
> +#define IPU3_UAPI_AF_MD_ITEM_SIZE                      4
> +#define IPU3_UAPI_AF_SPARE_FOR_BUBBLES \
> +       (IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> +        IPU3_UAPI_AF_MD_ITEM_SIZE)
> +#define IPU3_UAPI_AF_Y_TABLE_SET_SIZE                  0x80

Why not just decimal 128?

> +#define IPU3_UAPI_AF_Y_TABLE_MAX_SIZE \
> +       (IPU3_UAPI_AF_MAX_SETS * \
> +        (IPU3_UAPI_AF_Y_TABLE_SET_SIZE + IPU3_UAPI_AF_SPARE_FOR_BUBBLES) * \
> +        IPU3_UAPI_MAX_STRIPES)
> +
> +#define IPU3_UAPI_AWB_FR_MAX_SETS                      24
> +#define IPU3_UAPI_AWB_FR_MD_ITEM_SIZE                  8
> +#define IPU3_UAPI_AWB_FR_BAYER_TBL_SIZE                        0x100

Why not just decimal 256?

> +#define IPU3_UAPI_AWB_FR_SPARE_FOR_BUBBLES \
> +       (IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> +        IPU3_UAPI_AWB_FR_MD_ITEM_SIZE)
> +#define IPU3_UAPI_AWB_FR_BAYER_TABLE_MAX_SIZE \
> +       (IPU3_UAPI_AWB_FR_MAX_SETS * \
> +       (IPU3_UAPI_AWB_FR_BAYER_TBL_SIZE + \
> +        IPU3_UAPI_AWB_FR_SPARE_FOR_BUBBLES) * IPU3_UAPI_MAX_STRIPES)
[snip]
> +struct ipu3_uapi_af_filter_config {
> +       struct {
> +               __u8 a1;
> +               __u8 a2;
> +               __u8 a3;
> +               __u8 a4;
> +       } y1_coeff_0;
> +       struct {
> +               __u8 a5;
> +               __u8 a6;
> +               __u8 a7;
> +               __u8 a8;
> +       } y1_coeff_1;
> +       struct {
> +               __u8 a9;
> +               __u8 a10;
> +               __u8 a11;
> +               __u8 a12;
> +       } y1_coeff_2;

Why these aren't just __u8 y1_coeff[12]?

> +
> +       __u32 y1_sign_vec;
> +
> +       struct {
> +               __u8 a1;
> +               __u8 a2;
> +               __u8 a3;
> +               __u8 a4;
> +       } y2_coeff_0;
> +       struct {
> +               __u8 a5;
> +               __u8 a6;
> +               __u8 a7;
> +               __u8 a8;
> +       } y2_coeff_1;
> +       struct {
> +               __u8 a9;
> +               __u8 a10;
> +               __u8 a11;
> +               __u8 a12;
> +       } y2_coeff_2;

Ditto.

> +
> +       __u32 y2_sign_vec;
> +
> +       struct {
> +               __u8 y_gen_rate_gr;     /* 6 bits */
> +               __u8 y_gen_rate_r;
> +               __u8 y_gen_rate_b;
> +               __u8 y_gen_rate_gb;
> +       } y_calc;

Why not just call the struct "y_gen_rate" and then fields "gr", "r",
"b", "gb"? It would make any code referencing them much shorter.

> +
> +       struct {
> +               __u32 __reserved0:8;
> +               __u32 y1_nf:4;
> +               __u32 __reserved1:4;
> +               __u32 y2_nf:4;
> +               __u32 __reserved2:12;
> +       } nf;

Similarly here, is there any need to repeat "nf" inside the struct?

> +} __packed;
> +
> +struct ipu3_uapi_af_meta_data {
> +       __u8 y_table[IPU3_UAPI_AF_Y_TABLE_MAX_SIZE] IPU3_ALIGN;
> +} __packed;
[snip]
> +/******************* ipu3_uapi_acc_param *******************/
> +
> +#define IPU3_UAPI_BNR_LUT_SIZE                         32
> +
> +/* number of elements in gamma correction LUT */
> +#define IPU3_UAPI_GAMMA_CORR_LUT_ENTRIES               256
> +
> +#define IPU3_UAPI_SHD_MAX_CELLS_PER_SET                        146
> +/* largest grid is 73x56 */

The relation between the comment above and the values defined here is
not clear to me.

> +#define IPU3_UAPI_SHD_MAX_CFG_SETS                     28
[snip]
> +struct ipu3_uapi_bnr_static_config {
> +       struct ipu3_uapi_bnr_static_config_wb_gains_config wb_gains;
> +       struct ipu3_uapi_bnr_static_config_wb_gains_thr_config wb_gains_thr;
> +       struct ipu3_uapi_bnr_static_config_thr_coeffs_config thr_coeffs;
> +       struct ipu3_uapi_bnr_static_config_thr_ctrl_shd_config thr_ctrl_shd;
> +       struct ipu3_uapi_bnr_static_config_opt_center_config opt_center;
> +       struct ipu3_uapi_bnr_static_config_lut_config lut;
> +       struct ipu3_uapi_bnr_static_config_bp_ctrl_config bp_ctrl;
> +       struct ipu3_uapi_bnr_static_config_dn_detect_ctrl_config dn_detect_ctrl;
> +       __u32 column_size;      /* 0x44 */

What's the meaning of this number?

> +       struct ipu3_uapi_bnr_static_config_opt_center_sqr_config opt_center_sqr;
> +} __packed;
> +
> +struct ipu3_uapi_bnr_static_config_green_disparity {
> +       __u32 gd_red:6;
> +       __u32 __reserved0:2;
> +       __u32 gd_green:6;
> +       __u32 __reserved1:2;
> +       __u32 gd_blue:6;
> +       __u32 __reserved2:10;
> +       __u32 gd_black:14;
> +       __u32 __reserved3:2;
> +       __u32 gd_shading:7;
> +       __u32 __reserved4:1;
> +       __u32 gd_support:2;
> +       __u32 __reserved5:1;
> +       __u32 gd_clip:1;                        /* central weights variables */
> +       __u32 gd_central_weight:4;
> +} __packed;
> +
> +struct ipu3_uapi_dm_config {
> +       /* DWORD0 */

Is there any meaning behind this comment?

> +       __u32 dm_en:1;
> +       __u32 ch_ar_en:1;
> +       __u32 fcc_en:1;
> +       __u32 __reserved0:13;
> +       __u32 frame_width:16;
> +
> +       /* DWORD1 */

Ditto.

> +       __u32 gamma_sc:5;
> +       __u32 __reserved1:3;
> +       __u32 lc_ctrl:5;
> +       __u32 __reserved2:3;
> +       __u32 cr_param1:5;
> +       __u32 __reserved3:3;
> +       __u32 cr_param2:5;
> +       __u32 __reserved4:3;
> +
> +       /* DWORD2 */

Ditto.

> +       __u32 coring_param:5;
> +       __u32 __reserved5:27;
> +} __packed;
[snip]
> +/* Bayer shading correction */
> +
> +struct ipu3_uapi_shd_grid_config {
> +       /* reg 0 */

What's the meaning behind this comment?

> +       __u8 width;
> +       __u8 height;
> +       __u8 block_width_log2:3;
> +       __u8 __reserved0:1;
> +       __u8 block_height_log2:3;
> +       __u8 __reserved1:1;
> +       __u8 grid_height_per_slice;
> +       /* reg 1 */

Ditto.

> +       __s16 x_start;                  /* 13 bits */
> +       __s16 y_start;
> +} __packed;
> +
> +struct ipu3_uapi_shd_general_config {
> +       __u32 init_set_vrt_offst_ul:8;
> +       __u32 shd_enable:1;
> +       /* aka 'gf' */

What's the meaning of this comment?

> +       __u32 gain_factor:2;
> +       __u32 __reserved:21;
> +} __packed;
> +
> +struct ipu3_uapi_shd_black_level_config {
> +       __s16 bl_r;                     /* 12 bits */
> +       __s16 bl_gr;
> +#define IPU3_UAPI_SHD_BLGR_NF_SHIFT    13      /* Normalization shift aka nf */
> +#define IPU3_UAPI_SHD_BLGR_NF_MASK     0x7
> +       __s16 bl_gb;                    /* 12 bits */
> +       __s16 bl_b;
> +} __packed;
> +
> +struct ipu3_uapi_shd_config_static {
> +       /* B0: Fixed order: one transfer to GAC */

It's not clear to me what this comment means.

> +       struct ipu3_uapi_shd_grid_config grid;
> +       struct ipu3_uapi_shd_general_config general;
> +       struct ipu3_uapi_shd_black_level_config black_level;
> +} __packed;
> +
> +struct ipu3_uapi_shd_lut {
> +       struct {
> +               struct {
> +                       __u16 r;
> +                       __u16 gr;
> +               } r_and_gr[IPU3_UAPI_SHD_MAX_CELLS_PER_SET];
> +               __u8 __reserved1[24];
> +               struct {
> +                       __u16 gb;
> +                       __u16 b;
> +               } gb_and_b[IPU3_UAPI_SHD_MAX_CELLS_PER_SET];
> +               __u8 __reserved2[24];
> +       } sets[IPU3_UAPI_SHD_MAX_CFG_SETS];
> +} __packed;
> +
> +struct ipu3_uapi_shd_config {
> +       struct ipu3_uapi_shd_config_static shd IPU3_ALIGN;
> +       struct ipu3_uapi_shd_lut shd_lut IPU3_ALIGN;
> +} __packed;
> +
> +/* Image Enhancement Filter and Denoise */
> +
> +struct ipu3_uapi_iefd_cux2 {
> +       __u32 x0:9;
> +       __u32 x1:9;
> +       __u32 a01:9;
> +       __u32 b01:5;                            /* NOTE: hardcoded to zero */

No need for such long spacing to the comment.

> +} __packed;
[snip]
> +struct ipu3_uapi_unsharp_coef0 {
> +       __u32 c00:9;                    /* Coeff11 */
> +       __u32 c01:9;                    /* Coeff12 */
> +       __u32 c02:9;                    /* Coeff13 */

No need for such wide spacing.

> +       __u32 __reserved:5;
> +} __packed;
> +
> +struct ipu3_uapi_unsharp_coef1 {
> +       __u32 c11:9;                    /* Coeff22 */
> +       __u32 c12:9;                    /* Coeff23 */
> +       __u32 c22:9;                    /* Coeff33 */

Ditto.

> +       __u32 __reserved:5;
> +} __packed;
[snip]
> +struct ipu3_uapi_bds_hor_ctrl1 {
> +       __u32 hor_crop_start:13;
> +       __u32 __reserved0:3;
> +       __u32 hor_crop_end:13;
> +       __u32 __reserved1:1;
> +       __u32 hor_crop_en:1;
> +       __u32 __reserved2:1;
> +} __packed;

The struct name includes "hor" already, so no need to include it in
fields names.

> +
> +struct ipu3_uapi_bds_hor_ctrl2 {
> +       __u32 input_frame_height:13;
> +       __u32 __reserved0:19;
> +} __packed;
> +
> +struct ipu3_uapi_bds_hor {
> +       struct ipu3_uapi_bds_hor_ctrl0 hor_ctrl0;
> +       struct ipu3_uapi_bds_ptrn_arr hor_ptrn_arr;
> +       struct ipu3_uapi_bds_phase_arr hor_phase_arr;
> +       struct ipu3_uapi_bds_hor_ctrl1 hor_ctrl1;
> +       struct ipu3_uapi_bds_hor_ctrl2 hor_ctrl2;
> +} __packed;

Same here. Code that wants to access an example field needs to do it
like "[...]bds.hor.hor_ctrl1.hor_crop_en". Without repeating "hor" at
every level, it could be just "[...]bds.hor.ctrl1.crop_en".

> +
> +struct ipu3_uapi_bds_ver_ctrl0 {
> +       __u32 sample_patrn_length:9;
> +       __u32 __reserved0:3;
> +       __u32 ver_ds_en:1;

Is there a need to include "ver" in the name?

> +       __u32 min_clip_val:1;
> +       __u32 max_clip_val:2;
> +       __u32 __reserved1:16;
> +} __packed;
> +
> +struct ipu3_uapi_bds_ver_ctrl1 {
> +       __u32 out_frame_width:13;
> +       __u32 __reserved0:3;
> +       __u32 out_frame_height:13;
> +       __u32 __reserved1:3;
> +} __packed;
> +
> +struct ipu3_uapi_bds_ver {
> +       struct ipu3_uapi_bds_ver_ctrl0 ver_ctrl0;
> +       struct ipu3_uapi_bds_ptrn_arr ver_ptrn_arr;
> +       struct ipu3_uapi_bds_phase_arr ver_phase_arr;
> +       struct ipu3_uapi_bds_ver_ctrl1 ver_ctrl1;

Is there a need to include "ver" in field names?

> +

Unnecessary blank line.

> +} __packed;
> +
[snip]
> +struct ipu3_uapi_anr_beta {
> +       __u16 beta_gr;                                  /* 11 bits */
> +       __u16 beta_r;
> +       __u16 beta_b;
> +       __u16 beta_gb;
> +} __packed;

Is there a need to include "beta" in field names?

[snip]
> +struct ipu3_uapi_isp_lin_vmem_params {
> +       __s16 lin_lutlow_gr[IPU3_UAPI_LIN_LUT_SIZE];
> +       __s16 lin_lutlow_r[IPU3_UAPI_LIN_LUT_SIZE];
> +       __s16 lin_lutlow_b[IPU3_UAPI_LIN_LUT_SIZE];
> +       __s16 lin_lutlow_gb[IPU3_UAPI_LIN_LUT_SIZE];
> +       __s16 lin_lutdif_gr[IPU3_UAPI_LIN_LUT_SIZE];
> +       __s16 lin_lutdif_r[IPU3_UAPI_LIN_LUT_SIZE];
> +       __s16 lin_lutdif_b[IPU3_UAPI_LIN_LUT_SIZE];
> +       __s16 lin_lutdif_gb[IPU3_UAPI_LIN_LUT_SIZE];

Is there a need to include "lin" in field names?

> +} __packed;
> +
> +/* Temporal Noise Reduction VMEM parameters */
> +
> +#define IPU3_UAPI_ISP_TNR3_VMEM_LEN    9
> +
> +struct ipu3_uapi_isp_tnr3_vmem_params {
> +       __u16 slope[IPU3_UAPI_ISP_TNR3_VMEM_LEN];
> +       __u16 __reserved1[IPU3_UAPI_ISP_VEC_ELEMS
> +                                               - IPU3_UAPI_ISP_TNR3_VMEM_LEN];

Something wrong with indentation here. Maybe it could make sense to
define the length of padding as a macro, in addition to
IPU3_UAPI_ISP_TNR3_VMEM_LEN?

> +       __u16 sigma[IPU3_UAPI_ISP_TNR3_VMEM_LEN];
> +       __u16 __reserved2[IPU3_UAPI_ISP_VEC_ELEMS
> +                                               - IPU3_UAPI_ISP_TNR3_VMEM_LEN];

Ditto.

Best regards,
Tomasz
