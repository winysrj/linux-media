Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:53803 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752147AbeDJIhH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 04:37:07 -0400
Date: Tue, 10 Apr 2018 11:37:02 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        tfiga@chromium.org, hans.verkuil@cisco.com, mchehab@kernel.org,
        jerry.w.hu@intel.com, laurent.pinchart@ideasonboard.com,
        Chao C Li <chao.c.li@intel.com>
Subject: Re: [RFC PATCH]: intel-ipu3: Add uAPI documentation
Message-ID: <20180410083702.xxtswuhfp6bvp6yn@paasikivi.fi.intel.com>
References: <1522803145-5199-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1522803145-5199-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Thanks for the patch.

On Tue, Apr 03, 2018 at 07:52:25PM -0500, Yong Zhi wrote:
> This is a preliminary effort to add documentation for the
> following BNR(bayer noise reduction) structs:
> 
> ipu3_uapi_bnr_static_config_wb_gains_config
> ipu3_uapi_bnr_static_config_wb_gains_thr_config
> ipu3_uapi_bnr_static_config_thr_coeffs_config
> ipu3_uapi_bnr_static_config_thr_ctrl_shd_config
> ipu3_uapi_bnr_static_config_opt_center_sqr_config
> ipu3_uapi_bnr_static_config_bp_ctrl_config
> ipu3_uapi_bnr_static_config_dn_detect_ctrl_config
> ipu3_uapi_bnr_static_config_opt_center_sqr_config
> ipu3_uapi_bnr_static_config_green_disparity
> 
> The feedback on this patch will be used towards the
> documentation of reset of the uAPI in intel-ipu3.h.
> 
> Link to v6 IPU3 ImgU patchset:
> 
> <URL:https://patchwork.kernel.org/patch/10316725/>
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Chao C Li <chao.c.li@intel.com>
> ---
>  Documentation/media/media_uapi.rst      |    1 +
>  Documentation/media/uapi/intel-ipu3.rst |    8 +
>  include/uapi/linux/intel-ipu3.h         | 1520 +++++++++++++++++++++++++++++++
>  3 files changed, 1529 insertions(+)
>  create mode 100644 Documentation/media/uapi/intel-ipu3.rst
>  create mode 100644 include/uapi/linux/intel-ipu3.h
> 
> diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
> index 28eb35a1f965..edfa674b49c3 100644
> --- a/Documentation/media/media_uapi.rst
> +++ b/Documentation/media/media_uapi.rst
> @@ -31,3 +31,4 @@ License".
>      uapi/cec/cec-api
>      uapi/gen-errors
>      uapi/fdl-appendix
> +    uapi/intel-ipu3
> diff --git a/Documentation/media/uapi/intel-ipu3.rst b/Documentation/media/uapi/intel-ipu3.rst
> new file mode 100644
> index 000000000000..d4d9b2806fe9
> --- /dev/null
> +++ b/Documentation/media/uapi/intel-ipu3.rst
> @@ -0,0 +1,8 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _intel-ipu3:
> +
> +Intel IPU3 ImgU uAPI headers
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +.. kernel-doc:: include/uapi/linux/intel-ipu3.h

This should be located in the same file documenting the format. See also
e.g. Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst .

Have you built the documentation?

> diff --git a/include/uapi/linux/intel-ipu3.h b/include/uapi/linux/intel-ipu3.h
> new file mode 100644
> index 000000000000..34b071524beb
> --- /dev/null
> +++ b/include/uapi/linux/intel-ipu3.h
> @@ -0,0 +1,1520 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */

2017--2018 ?

...

> +/******************* ipu3_uapi_acc_param *******************/
> +
> +#define IPU3_UAPI_BNR_LUT_SIZE				32
> +
> +/* number of elements in gamma correction LUT */
> +#define IPU3_UAPI_GAMMA_CORR_LUT_ENTRIES		256
> +
> +#define IPU3_UAPI_SHD_MAX_CELLS_PER_SET			146
> +/* largest grid is 73x56 */
> +#define IPU3_UAPI_SHD_MAX_CFG_SETS			28
> +
> +#define IPU3_UAPI_YUVP2_YTM_LUT_ENTRIES			256
> +#define IPU3_UAPI_YUVP2_TCC_MACC_TABLE_ELEMENTS		16
> +#define IPU3_UAPI_YUVP2_TCC_INV_Y_LUT_ELEMENTS		14
> +#define IPU3_UAPI_YUVP2_TCC_GAIN_PCWL_LUT_ELEMENTS	258
> +#define IPU3_UAPI_YUVP2_TCC_R_SQR_LUT_ELEMENTS		24
> +
> +#define IPU3_UAPI_BDS_SAMPLE_PATTERN_ARRAY_SIZE		8
> +#define IPU3_UAPI_BDS_PHASE_COEFFS_ARRAY_SIZE		32
> +
> +#define IPU3_UAPI_ANR_LUT_SIZE				26
> +#define IPU3_UAPI_ANR_PYRAMID_SIZE			22
> +
> +#define IPU3_UAPI_AE_WEIGHTS				96
> +
> +/* Bayer Noise Reduction related structs */
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_wb_gains_config - White balance gains
> + * @gr:	white balance gain for Gr channel.
> + * @r:	white balance gain for R channel.
> + * @b:	white balance gain for B channel.
> + * @gb:	white balance gain for Gb channel.

What's the format of these numbers? u8.u8 fixed point for instance?

> + */
> +struct ipu3_uapi_bnr_static_config_wb_gains_config {
> +	__u16 gr;
> +	__u16 r;
> +	__u16 b;
> +	__u16 gb;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_wb_gains_thr_config - Threshold config
> + * @gr:	white balance threshold gain for Gr channel.
> + * @r: 	white balance threshold gain for R channel.
> + * @b: 	white balance threshold gain for B channel.
> + * @gb:	white balance threshold gain for Gb channel.

Same for these, and below.

> + */
> +struct ipu3_uapi_bnr_static_config_wb_gains_thr_config {
> +	__u8 gr;
> +	__u8 r;
> +	__u8 b;
> +	__u8 gb;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_thr_coeffs_config - Threshold coeffs
> + * @cf:	Free coefficient for threshold calculation
> + * @__reserved0:	reserved
> + * @cg:	Gain coefficient for threshold calculation
> + * @ci:	Intensity coefficient for threshold calculation
> + * @__reserved1:	reserved
> + * @r_nf:	Number of frames
> + */
> +struct ipu3_uapi_bnr_static_config_thr_coeffs_config {
> +	__u32 cf:13;
> +	__u32 __reserved0:3;
> +	__u32 cg:5;
> +	__u32 ci:5;
> +	__u32 __reserved1:1;
> +	__u32 r_nf:5;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_thr_ctrl_shd_config - SHD config
> + * @gr:	Coefficient defines lens shading gain approximation for gr channel
> + * @r:	Coefficient defines lens shading gain approximation for r channel
> + * @b:	Coefficient defines lens shading gain approximation for b channel
> + * @gb:	Coefficient defines lens shading gain approximation for gb channel
> + */
> +struct ipu3_uapi_bnr_static_config_thr_ctrl_shd_config {
> +	__u8 gr;
> +	__u8 r;
> +	__u8 b;
> +	__u8 gb;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_opt_center_config
> + * @x_reset:	Reset value of X (col start - X center) for r*r calculation
> + * @__reserved0:	reserved
> + * @y_reset:	Reset value of Y (row start - Y center) for r*r calculation
> + * @__reserved2:	reserved
> + */
> +struct ipu3_uapi_bnr_static_config_opt_center_config {
> +	__s32 x_reset:13;
> +	__u32 __reserved0:3;
> +	__s32 y_reset:13;
> +	__u32 __reserved2:3;
> +} __packed;
> +
> +struct ipu3_uapi_bnr_static_config_lut_config {
> +	__u8 values[IPU3_UAPI_BNR_LUT_SIZE];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_bp_ctrl_config
> + * @bp_thr_gain:	Defines the threshold that specifies how different a
> + *			defect pixel can be from its neighbors. Threshold is
> + *			dependent on de-noise threshold calculated by algorithm.
> + * @__reserved0:	reserved
> + * @defect_mode:	Mode of addressed defect pixels, 0 – single defect pixel
> + *			is expected, 2@ adjacent defect pixels are expected.
> + * @bp_gain:	Defines how 2nd derivation that passes through a defect pixel is
> + *	 	different from 2nd derivations that pass through neighbor pixels.
> + * @__reserved1:	reserved
> + * @w0_coeff:	Blending coefficient of defect pixel correction
> + * @__reserved2:	reserved
> + * @w1_coeff:	Blending coefficient of defect pixel correction
> + * @__reserved3:	reserved
> + */
> +struct ipu3_uapi_bnr_static_config_bp_ctrl_config {
> +	__u32 bp_thr_gain:5;
> +	__u32 __reserved0:2;
> +	__u32 defect_mode:1;
> +	__u32 bp_gain:6;
> +	__u32 __reserved1:18;
> +	__u32 w0_coeff:4;
> +	__u32 __reserved2:4;
> +	__u32 w1_coeff:4;
> +	__u32 __reserved3:20;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_dn_detect_ctrl_config
> + * @alpha:	Weight of central element of smoothing filter range: [0..0xF]
> + * @beta:	Weight of peripheral elements of smoothing filter in: [0..0xF]
> + * @gamma:	Weight of diagonal elements of smoothing filter range: [0..0xF]
> + * @__reserved0:	reserved
> + * @max_inf:	Maximum increase of peripheral or diagonal element influence
> + *		relative to the pre-defined value range: [0x5..0xA]
> + * @__reserved1:	reserved
> + * @gd_enable:	Green Disparity enable control, 0 - disable, 1 - enable.
> + * @bpc_enable:	Bad Pixel Correction enable control, 0 - disable, 1 - enable.
> + * @bnr_enable:	Bayer Noise Removal enable control, 0 - disable, 1 - enable.
> + * @ff_enable:	Fixed function enable control, 0 - disable, 1 - enable.
> + * @__reserved2:	reserved
> + */
> +struct ipu3_uapi_bnr_static_config_dn_detect_ctrl_config {
> +	__u32 alpha:4;
> +	__u32 beta:4;
> +	__u32 gamma:4;
> +	__u32 __reserved0:4;
> +	__u32 max_inf:4;
> +	__u32 __reserved1:7;
> +	/* aka 'green disparity enable' */
> +	__u32 gd_enable:1;
> +	__u32 bpc_enable:1;
> +	__u32 bnr_enable:1;
> +	__u32 ff_enable:1;
> +	__u32 __reserved2:1;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_opt_center_sqr_config
> + * @x_sqr_reset:	Reset value X*X of  for r*r
> + * @y_sqr_reset:	Reset value of Y*Y  for r*r
> + */
> +struct ipu3_uapi_bnr_static_config_opt_center_sqr_config {
> +	__u32 x_sqr_reset;
> +	__u32 y_sqr_reset;
> +} __packed;
> +
> +struct ipu3_uapi_bnr_static_config {
> +	struct ipu3_uapi_bnr_static_config_wb_gains_config wb_gains;
> +	struct ipu3_uapi_bnr_static_config_wb_gains_thr_config wb_gains_thr;
> +	struct ipu3_uapi_bnr_static_config_thr_coeffs_config thr_coeffs;
> +	struct ipu3_uapi_bnr_static_config_thr_ctrl_shd_config thr_ctrl_shd;
> +	struct ipu3_uapi_bnr_static_config_opt_center_config opt_center;
> +	struct ipu3_uapi_bnr_static_config_lut_config lut;
> +	struct ipu3_uapi_bnr_static_config_bp_ctrl_config bp_ctrl;
> +	struct ipu3_uapi_bnr_static_config_dn_detect_ctrl_config dn_detect_ctrl;
> +	__u32 column_size;	/* 0x44 */
> +	struct ipu3_uapi_bnr_static_config_opt_center_sqr_config opt_center_sqr;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_green_disparity
> + * @gd_red:	Shading gain coeff for gr disparity LVL in bright red region.

LVL is for level?

> + * @__reserved0:	reserved
> + * @gd_green:	Shading gain coeff for gr disparity LVL in bright green region.
> + * @__reserved1:	reserved
> + * @gd_blue:	Shading gain coeff for gr disparity LVL in bright blue region.
> + * @__reserved2:	reserved
> + * @gd_black:	Maximal green disparity level in dark region
> + *		(stronger disparity assumed to be image detail).
> + * @__reserved3:	reserved
> + * @gd_shading:	Change maximal green disparity level according to square
> + *		distance from image center.
> + * @__reserved4:	reserved
> + * @gd_support:	Lower bound for the number of second green color pixels in
> + *		current pixel neighborhood with less than Threshold difference
> + *		from it.
> + * @__reserved5:	reserved
> +* @gd_clip:	Green disparity clip on/off bit.
> + * @gd_central_weight:	Central pixel weight in 9 pixels weighted sum.
> + */
> +struct ipu3_uapi_bnr_static_config_green_disparity {
> +	__u32 gd_red:6;
> +	__u32 __reserved0:2;
> +	__u32 gd_green:6;
> +	__u32 __reserved1:2;
> +	__u32 gd_blue:6;
> +	__u32 __reserved2:10;
> +	__u32 gd_black:14;
> +	__u32 __reserved3:2;
> +	__u32 gd_shading:7;
> +	__u32 __reserved4:1;
> +	__u32 gd_support:2;
> +	__u32 __reserved5:1;
> +	__u32 gd_clip:1;			/* central weights variables */
> +	__u32 gd_central_weight:4;
> +} __packed;

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
