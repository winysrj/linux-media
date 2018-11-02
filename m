Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51263 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbeKBWJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 18:09:51 -0400
Date: Fri, 2 Nov 2018 15:02:38 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com, Chao C Li <chao.c.li@intel.com>
Subject: Re: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
Message-ID: <20181102130237.yotr2y7ddrrzqphn@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-4-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540851790-1777-4-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Thanks for the update! I went through this again... a few comments below
but I'd say they're mostly pretty minor issues.

On Mon, Oct 29, 2018 at 03:22:57PM -0700, Yong Zhi wrote:
> These meta formats are used on Intel IPU3 ImgU video queues
> to carry 3A statistics and ISP pipeline parameters.
> 
> V4L2_META_FMT_IPU3_3A
> V4L2_META_FMT_IPU3_PARAMS
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Chao C Li <chao.c.li@intel.com>
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
>  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  181 ++
>  include/uapi/linux/intel-ipu3.h                    | 2819 ++++++++++++++++++++
>  3 files changed, 3001 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
>  create mode 100644 include/uapi/linux/intel-ipu3.h
> 
> diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
> index cf971d5..eafc534 100644
> --- a/Documentation/media/uapi/v4l/meta-formats.rst
> +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> @@ -12,6 +12,7 @@ These formats are used for the :ref:`metadata` interface only.
>  .. toctree::
>      :maxdepth: 1
>  
> +    pixfmt-meta-intel-ipu3
>      pixfmt-meta-d4xx
>      pixfmt-meta-uvc
>      pixfmt-meta-vsp1-hgo
> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> new file mode 100644
> index 0000000..23b945b
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> @@ -0,0 +1,181 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _intel-ipu3:

Instead, to avoid a warning from Sphinx, replace the line with these:

.. _v4l2-meta-fmt-ipu3-params:
.. _v4l2-meta-fmt-ipu3-stat-3a:

> +
> +******************************************************************
> +V4L2_META_FMT_IPU3_PARAMS ('ip3p'), V4L2_META_FMT_IPU3_3A ('ip3s')
> +******************************************************************
> +
> +.. c:type:: ipu3_uapi_stats_3a
> +
> +3A statistics
> +=============
> +
> +For IPU3 ImgU, the 3A statistics accelerators collect different statistics over
> +an input bayer frame. Those statistics, defined in data struct
> +:c:type:`ipu3_uapi_stats_3a`, are meta output obtained from "ipu3-imgu 3a stat"
> +video node, which are then passed to user space for statistics analysis
> +using :c:type:`v4l2_meta_format` interface.
> +
> +The statistics collected are AWB (Auto-white balance) RGBS (Red, Green, Blue and 

Extra whitespace at the end of the line.

> +Saturation measure) cells, AWB filter response, AF (Auto-focus) filter response,
> +and AE (Auto-exposure) histogram.
> +
> +struct :c:type:`ipu3_uapi_4a_config` saves configurable parameters for all above.
> +
> +
> +.. code-block:: c
> +
> +
> +     struct ipu3_uapi_stats_3a {
> +	struct ipu3_uapi_awb_raw_buffer awb_raw_buffer
> +		 __attribute__((aligned(32)));
> +	struct ipu3_uapi_ae_raw_buffer_aligned
> +			ae_raw_buffer[IPU3_UAPI_MAX_STRIPES];
> +	struct ipu3_uapi_af_raw_buffer af_raw_buffer;
> +	struct ipu3_uapi_awb_fr_raw_buffer awb_fr_raw_buffer;
> +	struct ipu3_uapi_4a_config stats_4a_config;
> +	__u32 ae_join_buffers;
> +	__u8 padding[28];
> +	struct ipu3_uapi_stats_3a_bubble_info_per_stripe
> +			stats_3a_bubble_per_stripe;

I think you could just unwrap these, even if it causes them to be over 80
characters per line. They display better in a web browser that way. Or
alternatively align the wrapped lines to the same column.

> +	struct ipu3_uapi_ff_status stats_3a_status;
> +     } __packed;
> +
> +
> +.. c:type:: ipu3_uapi_params
> +
> +Pipeline parameters
> +===================
> +
> +IPU3 pipeline has a number of image processing stages, each of which takes a
> +set of parameters as input. The major stages of pipelines are shown here:
> +
> +Raw pixels -> Bayer Downscaling -> Optical Black Correction ->
> +
> +Linearization -> Lens Shading Correction -> White Balance / Exposure /
> +
> +Focus Apply -> Bayer Noise Reduction -> ANR -> Demosaicing -> Color
> +
> +Correction Matrix -> Gamma correction -> Color Space Conversion ->
> +
> +Chroma Down Scaling -> Chromatic Noise Reduction -> Total Color
> +
> +Correction -> XNR3 -> TNR -> DDR
> +
> +The table below presents a description of the above algorithms.
> +
> +======================== =======================================================
> +Name			 Description
> +======================== =======================================================
> +Optical Black Correction Optical Black Correction block subtracts a pre-defined
> +			 value from the respective pixel values to obtain better
> +			 image quality.
> +			 Defined in :c:type:`ipu3_uapi_obgrid_param`.
> +Linearization		 This algo block uses linearization parameters to
> +			 address non-linearity sensor effects. The Lookup table
> +			 table is defined in
> +			 :c:type:`ipu3_uapi_isp_lin_vmem_params`.
> +SHD			 Lens shading correction is used to correct spatial
> +			 non-uniformity of the pixel response due to optical
> +			 lens shading. This is done by applying a different gain
> +			 for each pixel. The gain, black level etc are
> +			 configured in :c:type:`ipu3_uapi_shd_config_static`.
> +BNR			 Bayer noise reduction block removes image noise by
> +			 applying a bilateral filter.
> +			 See :c:type:`ipu3_uapi_bnr_static_config` for details.
> +ANR			 Advanced Noise Reduction is a block based algorithm
> +			 that performs noise reduction in the Bayer domain. The
> +			 convolution matrix etc can be found in
> +			 :c:type:`ipu3_uapi_anr_config`.
> +Demosaicing		 Demosaicing converts raw sensor data in Bayer format
> +			 into RGB (Red, Green, Blue) presentation. Then add
> +			 outputs of estimation of Y channel for following stream
> +			 processing by Firmware. The struct is defined as
> +			 :c:type:`ipu3_uapi_dm_config`.
> +Color Correction	 Color Correction algo transforms sensor specific color
> +			 space to the standard "sRGB" color space. This is done
> +			 by applying 3x3 matrix defined in
> +			 :c:type:`ipu3_uapi_ccm_mat_config`.
> +Gamma correction	 Gamma correction :c:type:`ipu3_uapi_gamma_config` is a
> +			 basic non-linear tone mapping correction that is
> +			 applied per pixel for each pixel component.
> +CSC			 Color space conversion transforms each pixel from the
> +			 RGB primary presentation to YUV (Y - brightness,
> +			 UV - Luminance) presentation. This is done by applying
> +			 a 3x3 matrix defined in
> +			 :c:type:`ipu3_uapi_csc_mat_config`
> +CDS			 Chroma down sampling
> +			 After the CSC is performed, the Chroma Down Sampling
> +			 is applied for a UV plane down sampling by a factor
> +			 of 2 in each direction for YUV 4:2:0 using a 4x2
> +			 configurable filter :c:type:`ipu3_uapi_cds_params`.
> +CHNR			 Chroma noise reduction
> +			 This block processes only the chrominance pixels and
> +			 performs noise reduction by cleaning the high
> +			 frequency noise.
> +			 See struct :c:type:`ipu3_uapi_yuvp1_chnr_config`.
> +TCC			 Total color correction as defined in struct
> +			 :c:type:`ipu3_uapi_yuvp2_tcc_static_config`.
> +XNR3			 eXtreme Noise Reduction V3 is the third revision of
> +			 noise reduction algorithm used to improve image
> +			 quality. This removes the low frequency noise in the
> +			 captured image. Two related structs are  being defined,
> +			 :c:type:`ipu3_uapi_isp_xnr3_params` for ISP data memory
> +			 and :c:type:`ipu3_uapi_isp_xnr3_vmem_params` for vector
> +			 memory.
> +TNR			 Temporal Noise Reduction block compares successive
> +			 frames in time to remove anomalies / noise in pixel
> +			 values. :c:type:`ipu3_uapi_isp_tnr3_vmem_params` and
> +			 :c:type:`ipu3_uapi_isp_tnr3_params` are defined for ISP
> +			 vector and data memory respectively.
> +======================== =======================================================
> +
> +A few stages of the pipeline will be executed by firmware running on the ISP
> +processor, while many others will use a set of fixed hardware blocks also
> +called accelerator cluster (ACC) to crunch pixel data and produce statistics.
> +
> +ACC parameters as defined by :c:type:`ipu3_uapi_acc_param`, can be selectively
> +enabled / disabled by the user space through struct :c:type:`ipu3_uapi_flags`
> +embedded in :c:type:`ipu3_uapi_params` structure. For parameters that are not
> +enabled by the user space, corresponding structs are ignored by the ISP.

I presume the "enabled" here means enabling the use of the new parameter
values. How about this:

ACC parameters of individual algorithms, as defined by
:c:type:`ipu3_uapi_acc_param`, can be chosen to be applied by the user
space through struct :c:type:`ipu3_uapi_flags` embedded in
:c:type:`ipu3_uapi_params` structure. For parameters that are configured as
not enabled by the user space, the corresponding structs are ignored by the
driver, in which case the existing configuration of the algorithm will be
preserved.

> +
> +Both 3A statistics and pipeline parameters described here are closely tied to
> +the underlying camera sub-system (CSS) APIs. They are usually consumed and
> +produced by dedicated user space libraries that comprise the important tuning
> +tools, thus freeing the developers from being bothered with the low level
> +hardware and algorithm details.
> +
> +It should be noted that IPU3 DMA operations require the addresses of all data
> +structures (that includes both input and output) to be aligned on 32 byte
> +boundaries.
> +
> +The meta data :c:type:`ipu3_uapi_params` will be sent to "ipu3-imgu parameters"
> +video node in ``V4L2_BUF_TYPE_META_CAPTURE`` format.
> +
> +.. code-block:: c
> +
> +    struct ipu3_uapi_params {
> +	/* Flags which of the settings below are to be applied */
> +	struct ipu3_uapi_flags use __attribute__((aligned(32)));
> +
> +	/* Accelerator cluster parameters */
> +	struct ipu3_uapi_acc_param acc_param;
> +
> +	/* ISP vector address space parameters */
> +	struct ipu3_uapi_isp_lin_vmem_params lin_vmem_params;
> +	struct ipu3_uapi_isp_tnr3_vmem_params tnr3_vmem_params;
> +	struct ipu3_uapi_isp_xnr3_vmem_params xnr3_vmem_params;
> +
> +	/* ISP data memory (DMEM) parameters */
> +	struct ipu3_uapi_isp_tnr3_params tnr3_dmem_params;
> +	struct ipu3_uapi_isp_xnr3_params xnr3_dmem_params;
> +
> +	/* Optical black level compensation */
> +	struct ipu3_uapi_obgrid_param obgrid_param;
> +    } __packed;
> +
> +Intel IPU3 ImgU uAPI data types
> +===============================
> +
> +.. kernel-doc:: include/uapi/linux/intel-ipu3.h
> diff --git a/include/uapi/linux/intel-ipu3.h b/include/uapi/linux/intel-ipu3.h
> new file mode 100644
> index 0000000..c2608b6
> --- /dev/null
> +++ b/include/uapi/linux/intel-ipu3.h
> @@ -0,0 +1,2819 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2017 - 2018 Intel Corporation */
> +
> +#ifndef __IPU3_UAPI_H
> +#define __IPU3_UAPI_H
> +
> +#include <linux/types.h>
> +
> +/********************* Key Acronyms *************************/
> +/*
> + * ACC - Accelerator cluster
> + * ANR - Adaptive noise reduction
> + * AWB_FR- Auto white balance filter response statistics
> + * BNR - Bayer noise reduction parameters
> + * BDS - Bayer downscaler parameters
> + * CCM - Color correction matrix coefficients
> + * CDS - Chroma down sample
> + * CHNR - Chroma noise reduction
> + * CSC - Color space conversion
> + * DM - De-mosaic
> + * IEFd - Image enhancement filter directed
> + * Obgrid - Optical black level compensation
> + * OSYS - Output system configuration
> + * ROI - Region of interest
> + * SHD - Lens shading correction table
> + * TCC - Total color correction
> + * YDS - Y down sampling
> + * YTM - Y-tone mapping
> + */
> +
> +/*
> + * IPU3 DMA operations require buffers to be aligned at
> + * 32 byte boundaries
> + */
> +
> +/******************* ipu3_uapi_stats_3a *******************/
> +
> +#define IPU3_UAPI_MAX_STRIPES				2
> +#define IPU3_UAPI_MAX_BUBBLE_SIZE			10
> +
> +#define IPU3_UAPI_GRID_START_MASK			((1 << 12) - 1)
> +#define IPU3_UAPI_GRID_Y_START_EN			(1 << 15)
> +
> +/* controls generation of meta_data (like FF enable/disable) */
> +#define IPU3_UAPI_AWB_RGBS_THR_B_EN			(1 << 14)
> +#define IPU3_UAPI_AWB_RGBS_THR_B_INCL_SAT		(1 << 15)
> +
> +/**
> + * struct ipu3_uapi_grid_config - Grid plane config
> + *
> + * @width:	Grid horizontal dimensions, in number of grid blocks(cells).
> + * @height:	Grid vertical dimensions, in number of grid cells.
> + * @block_width_log2:	Log2 of the width of each cell in pixels.
> + *			for (2^3, 2^4, 2^5, 2^6, 2^7), values [3, 7].
> + * @block_height_log2:	Log2 of the height of each cell in pixels.
> + *			for (2^3, 2^4, 2^5, 2^6, 2^7), values [3, 7].
> + * @height_per_slice:	The number of blocks in vertical axis per slice.
> + *			Default 2.
> + * @x_start: X value of top left corner of Region of Interest(ROI).
> + * @y_start: Y value of top left corner of ROI
> + * @x_end: X value of bottom right corner of ROI
> + * @y_end: Y value of bottom right corner of ROI
> + *
> + * Due to the size of total amount of collected data, most statistics
> + * create a grid-based output, and the data is then divided into "slices".
> + */
> +struct ipu3_uapi_grid_config {
> +	__u8 width;
> +	__u8 height;
> +	__u16 block_width_log2:3;
> +	__u16 block_height_log2:3;
> +	__u16 height_per_slice:8;
> +	__u16 x_start;
> +	__u16 y_start;
> +	__u16 x_end;
> +	__u16 y_end;
> +} __packed;
> +
> +/*
> + * The grid based data is divided into "slices" called set, each slice of setX
> + * refers to ipu3_uapi_grid_config width * height_per_slice.
> + */
> +#define IPU3_UAPI_AWB_MAX_SETS				60
> +/* Based on grid size 80 * 60 and cell size 16 x 16 */
> +#define IPU3_UAPI_AWB_SET_SIZE				1280
> +#define IPU3_UAPI_AWB_MD_ITEM_SIZE			8
> +#define IPU3_UAPI_AWB_SPARE_FOR_BUBBLES \
> +	(IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> +	 IPU3_UAPI_AWB_MD_ITEM_SIZE)
> +#define IPU3_UAPI_AWB_MAX_BUFFER_SIZE \
> +	(IPU3_UAPI_AWB_MAX_SETS * \
> +	 (IPU3_UAPI_AWB_SET_SIZE + IPU3_UAPI_AWB_SPARE_FOR_BUBBLES))
> +/**
> + * struct ipu3_uapi_awb_meta_data - AWB meta data
> + *
> + * @meta_data_buffer:	Average values for each color channel
> + */
> +struct ipu3_uapi_awb_meta_data {
> +	__u8 meta_data_buffer[IPU3_UAPI_AWB_MAX_BUFFER_SIZE];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_awb_raw_buffer - AWB raw buffer
> + *
> + * @meta_data: buffer to hold auto white balance meta data.
> + */
> +struct ipu3_uapi_awb_raw_buffer {
> +	struct ipu3_uapi_awb_meta_data meta_data;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_awb_config_s - AWB config
> + *
> + * @rgbs_thr_gr: gr threshold value.
> + * @rgbs_thr_r: Red threshold value.
> + * @rgbs_thr_gb: gb threshold value.
> + * @rgbs_thr_b: Blue threshold value.
> + * @grid: &ipu3_uapi_grid_config, the default grid resolution is 16x16 cells.
> + *
> + * The threshold is a saturation measure range [0, 8191], 8191 is default.
> + * Values over threshold may be optionally rejected for averaging.
> + */
> +struct ipu3_uapi_awb_config_s {
> +	__u16 rgbs_thr_gr;
> +	__u16 rgbs_thr_r;
> +	__u16 rgbs_thr_gb;
> +	__u16 rgbs_thr_b;
> +	struct ipu3_uapi_grid_config grid;
> +} __attribute__((aligned(32))) __packed;
> +
> +/**
> + * struct ipu3_uapi_awb_config - AWB config wrapper
> + *
> + * @config: config for auto white balance as defined by &ipu3_uapi_awb_config_s
> + */
> +struct ipu3_uapi_awb_config {
> +	struct ipu3_uapi_awb_config_s config __attribute__((aligned(32)));
> +} __packed;
> +
> +#define IPU3_UAPI_AE_COLORS				4	/* R, G, B, Y */
> +#define IPU3_UAPI_AE_BINS				256
> +#define IPU3_UAPI_AE_WEIGHTS				96
> +
> +/**
> + * struct ipu3_uapi_ae_raw_buffer - AE global weighted histogram
> + *
> + * @vals: Sum of IPU3_UAPI_AE_COLORS in cell
> + *
> + * Each histogram contains IPU3_UAPI_AE_BINS bins. Each bin has 24 bit unsigned
> + * for counting the number of the pixel.
> + */
> +struct ipu3_uapi_ae_raw_buffer {
> +	__u32 vals[IPU3_UAPI_AE_BINS * IPU3_UAPI_AE_COLORS];

What's the order of the colour components? Do the components for the same
bin come together, or all bins for a given component?

Could this be written instead as:

	struct {
		__u32 gr;
		__u32 g;
		__u32 b;
		__u32 gb;
	} vals[IPU3_UAPI_AE_BINS] __packed __attribute__((aligned(32)));

> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_ae_raw_buffer_aligned - AE raw buffer
> + *
> + * @buff: &ipu3_uapi_ae_raw_buffer to hold full frame meta data.
> + */
> +struct ipu3_uapi_ae_raw_buffer_aligned {
> +	struct ipu3_uapi_ae_raw_buffer buff __attribute__((aligned(32)));

Please use struct ipu3_uapi_ae_raw_buffer directly.

> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_ae_grid_config - AE weight grid
> + *
> + * @width: Grid horizontal dimensions. Value: [16, 32], default 16.
> + * @height: Grid vertical dimensions. Value: [16, 24], default 16.
> + * @block_width_log2: Log2 of the width of the grid cell, 2^3 = 16.
> + * @block_height_log2: Log2 of the height of the grid cell, 2^3 = 16.

2^3 == 16? Is the example wrong or the description of the field?

> + * @__reserved0: reserved
> + * @ae_en: 0: does not write to meta-data array, 1: write normally.

Is the meta-data array here the AE raw buffer, as defined above? If so,
please align the terms used.

> + * @rst_hist_array: write 1 to trigger histogram array reset.
> + * @done_rst_hist_array: flag for histogram array reset done.
> + * @x_start: X value of top left corner of ROI, default 0.
> + * @y_start: Y value of top left corner of ROI, default 0.
> + * @x_end: X value of bottom right corner of ROI
> + * @y_end: Y value of bottom right corner of ROI
> + *
> + * The AE block accumulates 4 global weighted histograms(R, G, B, Y) over
> + * a defined ROI within the frame. The contribution of each pixel into the
> + * histogram, defined by &ipu3_uapi_ae_weight_elem LUT, is indexed by a grid.
> + */
> +struct ipu3_uapi_ae_grid_config {
> +	__u8 width;
> +	__u8 height;
> +	__u8 block_width_log2:4;
> +	__u8 block_height_log2:4;
> +	__u8 __reserved0:5;
> +	__u8 ae_en:1;
> +	__u8 rst_hist_array:1;
> +	__u8 done_rst_hist_array:1;
> +	__u16 x_start;
> +	__u16 y_start;
> +	__u16 x_end;
> +	__u16 y_end;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_ae_weight_elem - AE weights LUT
> + *
> + * @cell0: weighted histogram grid value.
> + * @cell1: weighted histogram grid value.
> + * @cell2: weighted histogram grid value.
> + * @cell3: weighted histogram grid value.
> + * @cell4: weighted histogram grid value.
> + * @cell5: weighted histogram grid value.
> + * @cell6: weighted histogram grid value.
> + * @cell7: weighted histogram grid value.
> + *
> + * Use weighted grid value to give a different contribution factor to each cell.
> + * Precision u4, range [0, 15].
> + */
> +struct ipu3_uapi_ae_weight_elem {
> +	__u32 cell0:4;
> +	__u32 cell1:4;
> +	__u32 cell2:4;
> +	__u32 cell3:4;
> +	__u32 cell4:4;
> +	__u32 cell5:4;
> +	__u32 cell6:4;
> +	__u32 cell7:4;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_ae_ccm - AE coefficients for WB and CCM
> + *
> + * @gain_gr: WB gain factor for the gr channels. Default 256.
> + * @gain_r: WB gain factor for the r channel. Default 256.
> + * @gain_b: WB gain factor for the b channel. Default 256.
> + * @gain_gb: WB gain factor for the gb channels. Default 256.
> + * @mat: 4x4 matrix that transforms Bayer quad output from WB to RGB+Y.
> + *
> + * Default:
> + *	128, 0, 0, 0,
> + *	0, 128, 0, 0,
> + *	0, 0, 128, 0,
> + *	0, 0, 0, 128,
> + *
> + * As part of the raw frame pre-process stage, the WB and color conversion need
> + * to be applied to expose the impact of these gain operations.
> + */
> +struct ipu3_uapi_ae_ccm {
> +	__u16 gain_gr;
> +	__u16 gain_r;
> +	__u16 gain_b;
> +	__u16 gain_gb;
> +	__s16 mat[16];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_ae_config - AE config
> + *
> + * @grid_cfg:	config for auto exposure statistics grid. See struct
> + *		&ipu3_uapi_ae_grid_config
> + * @weights:	&IPU3_UAPI_AE_WEIGHTS is based on 32x24 blocks in the grid.
> + *		Each grid cell has a corresponding value in weights LUT called
> + *		grid value, global histogram is updated based on grid value and
> + *		pixel value.
> + * @ae_ccm:	Color convert matrix pre-processing block.
> + *
> + * Calculate AE grid from image resolution, resample ae weights.
> + */
> +struct ipu3_uapi_ae_config {
> +	struct ipu3_uapi_ae_grid_config grid_cfg __attribute__((aligned(32)));
> +	struct ipu3_uapi_ae_weight_elem weights[
> +						IPU3_UAPI_AE_WEIGHTS] __attribute__((aligned(32)));

Over 80 characters per line.

> +	struct ipu3_uapi_ae_ccm ae_ccm __attribute__((aligned(32)));
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_af_filter_config - AF 2D filter for contrast measurements
> + *
> + * @y1_coeff_0:	filter Y1, structure: 3x11, support both symmetry and
> + *		anti-symmetry type. A12 is center, A1-A11 are neighbours.
> + *		for analyzing low frequency content, used to calculate sum
> + *		of gradients in x direction.
> + * @y1_coeff_0.a1:	filter1 coefficients A1, u8, default 0.
> + * @y1_coeff_0.a2:	filter1 coefficients A2, u8, default 0.
> + * @y1_coeff_0.a3:	filter1 coefficients A3, u8, default 0.
> + * @y1_coeff_0.a4:	filter1 coefficients A4, u8, default 0.
> + * @y1_coeff_1:		Struct
> + * @y1_coeff_1.a5:	filter1 coefficients A5, u8, default 0.
> + * @y1_coeff_1.a6:	filter1 coefficients A6, u8, default 0.
> + * @y1_coeff_1.a7:	filter1 coefficients A7, u8, default 0.
> + * @y1_coeff_1.a8:	filter1 coefficients A8, u8, default 0.
> + * @y1_coeff_2:		Struct
> + * @y1_coeff_2.a9:	filter1 coefficients A9, u8, default 0.
> + * @y1_coeff_2.a10:	filter1 coefficients A10, u8, default 0.
> + * @y1_coeff_2.a11:	filter1 coefficients A11, u8, default 0.
> + * @y1_coeff_2.a12:	filter1 coefficients A12, u8, default 128.
> + * @y1_sign_vec:	Each bit corresponds to one coefficient sign bit,
> + *			0: positive, 1: negative, default 0.
> + * @y2_coeff_0:	Y2, same structure as Y1. For analyzing high frequency content.
> + * @y2_coeff_0.a1:	filter2 coefficients A1, u8, default 0.
> + * @y2_coeff_0.a2:	filter2 coefficients A2, u8, default 0.
> + * @y2_coeff_0.a3:	filter2 coefficients A3, u8, default 0.
> + * @y2_coeff_0.a4:	filter2 coefficients A4, u8, default 0.
> + * @y2_coeff_1:	Struct
> + * @y2_coeff_1.a5:	filter2 coefficients A5, u8, default 0.
> + * @y2_coeff_1.a6:	filter2 coefficients A6, u8, default 0.
> + * @y2_coeff_1.a7:	filter2 coefficients A7, u8, default 0.
> + * @y2_coeff_1.a8:	filter2 coefficients A8, u8, default 0.
> + * @y2_coeff_2:	Struct
> + * @y2_coeff_2.a9:	filter1 coefficients A9, u8, default 0.
> + * @y2_coeff_2.a10:	filter1 coefficients A10, u8, default 0.
> + * @y2_coeff_2.a11:	filter1 coefficients A11, u8, default 0.
> + * @y2_coeff_2.a12:	filter1 coefficients A12, u8, default 128.
> + * @y2_sign_vec:	Each bit corresponds to one coefficient sign bit,
> + *			0: positive, 1: negative, default 0.
> + * @y_calc:	Pre-processing that converts Bayer quad to RGB+Y values to be
> + *		used for building histogram. Range [0, 32], default 8.
> + * Rule:
> + *		y_gen_rate_gr + y_gen_rate_r + y_gen_rate_b + y_gen_rate_gb = 32
> + *		A single Y is calculated based on sum of Gr/R/B/Gb based on
> + *		their contribution ratio.
> + * @y_calc.y_gen_rate_gr:	Contribution ratio Gr for Y
> + * @y_calc.y_gen_rate_r:	Contribution ratio R for Y
> + * @y_calc.y_gen_rate_b:	Contribution ratio B for Y
> + * @y_calc.y_gen_rate_gb:	Contribution ratio Gb for Y
> + * @nf:	The shift right value that should be applied during the Y1/Y2 filter to
> + *	make sure the total memory needed is 2 bytes per grid cell.
> + * @nf.__reserved0:	reserved
> + * @nf.y1_nf:	Normalization factor for the convolution coeffs of y1,
> + *		should be log2 of the sum of the abs values of the filter
> + *		coeffs, default 7 (2^7 = 128).
> + * @nf.__reserved1:	reserved
> + * @nf.y2_nf:	Normalization factor for y2, should be log2 of the sum of the
> + *		abs values of the filter coeffs.
> + * @nf.__reserved2:	reserved
> + */
> +struct ipu3_uapi_af_filter_config {
> +	struct {
> +		__u8 a1;
> +		__u8 a2;
> +		__u8 a3;
> +		__u8 a4;
> +	} y1_coeff_0;
> +	struct {
> +		__u8 a5;
> +		__u8 a6;
> +		__u8 a7;
> +		__u8 a8;
> +	} y1_coeff_1;
> +	struct {
> +		__u8 a9;
> +		__u8 a10;
> +		__u8 a11;
> +		__u8 a12;
> +	} y1_coeff_2;
> +
> +	__u32 y1_sign_vec;
> +
> +	struct {
> +		__u8 a1;
> +		__u8 a2;
> +		__u8 a3;
> +		__u8 a4;
> +	} y2_coeff_0;
> +	struct {
> +		__u8 a5;
> +		__u8 a6;
> +		__u8 a7;
> +		__u8 a8;
> +	} y2_coeff_1;
> +	struct {
> +		__u8 a9;
> +		__u8 a10;
> +		__u8 a11;
> +		__u8 a12;
> +	} y2_coeff_2;
> +
> +	__u32 y2_sign_vec;
> +
> +	struct {
> +		__u8 y_gen_rate_gr;
> +		__u8 y_gen_rate_r;
> +		__u8 y_gen_rate_b;
> +		__u8 y_gen_rate_gb;
> +	} y_calc;
> +
> +	struct {
> +		__u32 __reserved0:8;
> +		__u32 y1_nf:4;
> +		__u32 __reserved1:4;
> +		__u32 y2_nf:4;
> +		__u32 __reserved2:12;
> +	} nf;
> +} __packed;
> +
> +#define IPU3_UAPI_AF_MAX_SETS				24
> +#define IPU3_UAPI_AF_MD_ITEM_SIZE			4
> +#define IPU3_UAPI_AF_SPARE_FOR_BUBBLES \
> +	(IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> +	 IPU3_UAPI_AF_MD_ITEM_SIZE)
> +#define IPU3_UAPI_AF_Y_TABLE_SET_SIZE			128
> +#define IPU3_UAPI_AF_Y_TABLE_MAX_SIZE \
> +	(IPU3_UAPI_AF_MAX_SETS * \
> +	 (IPU3_UAPI_AF_Y_TABLE_SET_SIZE + IPU3_UAPI_AF_SPARE_FOR_BUBBLES) * \
> +	 IPU3_UAPI_MAX_STRIPES)
> +
> +/**
> + * struct ipu3_uapi_af_meta_data - AF meta data
> + *
> + * @y_table:	Each color component will be convolved separately with filter1
> + *		and filter2 and the result will be summed out and averaged for
> + *		each cell.
> + */
> +struct ipu3_uapi_af_meta_data {
> +	__u8 y_table[IPU3_UAPI_AF_Y_TABLE_MAX_SIZE] __attribute__((aligned(32)));
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_af_raw_buffer - AF raw buffer
> + *
> + * @meta_data: raw buffer &ipu3_uapi_af_meta_data for auto focus meta data.
> + */
> +struct ipu3_uapi_af_raw_buffer {
> +	struct ipu3_uapi_af_meta_data meta_data __attribute__((aligned(32)));

How about:

	__u8 y_table[IPU3_UAPI_AF_Y_TABLE_MAX_SIZE]
		__attribute__((aligned(32)));

> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_af_config_s - AF config
> + *
> + * @filter_config: AF uses Y1 and Y2 filters as configured in
> + *		   &ipu3_uapi_af_filter_config
> + * @padding: paddings
> + * @grid_cfg: See &ipu3_uapi_grid_config, default resolution 16x16. Use large
> + *	      grid size for large image and vice versa.
> + */
> +struct ipu3_uapi_af_config_s {
> +	struct ipu3_uapi_af_filter_config filter_config __attribute__((aligned(32)));
> +	__u8 padding[4];
> +	struct ipu3_uapi_grid_config grid_cfg __attribute__((aligned(32)));
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_af_config - AF config wrapper
> + *
> + * @config: config for auto focus as defined by &ipu3_uapi_af_config_s
> + */
> +struct ipu3_uapi_af_config {

Could you drop struct ipu3_uapi_af_config and use ipu3_uapi_af_config_s
instead?

> +	struct ipu3_uapi_af_config_s config;
> +} __packed;
> +
> +#define IPU3_UAPI_AWB_FR_MAX_SETS			24
> +#define IPU3_UAPI_AWB_FR_MD_ITEM_SIZE			8
> +#define IPU3_UAPI_AWB_FR_BAYER_TBL_SIZE			256
> +#define IPU3_UAPI_AWB_FR_SPARE_FOR_BUBBLES \
> +	(IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> +	 IPU3_UAPI_AWB_FR_MD_ITEM_SIZE)
> +#define IPU3_UAPI_AWB_FR_BAYER_TABLE_MAX_SIZE \
> +	(IPU3_UAPI_AWB_FR_MAX_SETS * \
> +	(IPU3_UAPI_AWB_FR_BAYER_TBL_SIZE + \
> +	 IPU3_UAPI_AWB_FR_SPARE_FOR_BUBBLES) * IPU3_UAPI_MAX_STRIPES)
> +
> +/**
> + * struct ipu3_uapi_awb_fr_meta_data - AWB filter response meta data
> + *
> + * @bayer_table: Statistics output on the grid after convolving with 1D filter.
> + */
> +struct ipu3_uapi_awb_fr_meta_data {
> +	__u8 bayer_table[IPU3_UAPI_AWB_FR_BAYER_TABLE_MAX_SIZE] __attribute__((aligned(32)));
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_awb_fr_raw_buffer - AWB filter response raw buffer
> + *
> + * @meta_data: See &ipu3_uapi_awb_fr_meta_data.
> + */
> +struct ipu3_uapi_awb_fr_raw_buffer {

Same here, please use ipu3_uapi_awb_fr_meta_data instead.

> +	struct ipu3_uapi_awb_fr_meta_data meta_data;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_awb_fr_config_s - AWB filter response config
> + *
> + * @grid_cfg:	grid config, default 16x16.
> + * @bayer_coeff:	1D Filter 1x11 center symmetry/anti-symmetry.
> + *			coeffcients defaults { 0, 0, 0, 0, 0, 128 }.
> + *			Applied on whole image for each Bayer channel separately
> + *			by a weighted sum of its 11x1 neighbors.
> + * @__reserved1:	reserved
> + * @bayer_sign:	sign of filter coeffcients, default 0.
> + * @bayer_nf:	normalization factor for the convolution coeffs, to make sure
> + *		total memory needed is within pre-determined range.
> + *		NF should be the log2 of the sum of the abs values of the
> + *		filter coeffs, range [7, 14], default 7.
> + * @__reserved2:	reserved
> + */
> +struct ipu3_uapi_awb_fr_config_s {
> +	struct ipu3_uapi_grid_config grid_cfg;
> +	__u8 bayer_coeff[6];
> +	__u16 __reserved1;
> +	__u32 bayer_sign;
> +	__u8 bayer_nf;
> +	__u8 __reserved2[3];
> +} __attribute__((aligned(32))) __packed;
> +
> +/**
> + * struct ipu3_uapi_awb_fr_config - AWB filter response config wrapper
> + *
> + * @config:	See &ipu3_uapi_awb_fr_config_s.
> + */
> +struct ipu3_uapi_awb_fr_config {

Ditto.

> +	struct ipu3_uapi_awb_fr_config_s config;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_4a_config - 4A config
> + *
> + * @awb_config: &ipu3_uapi_awb_config_s, default resolution 16x16
> + * @ae_grd_config: auto exposure statistics &ipu3_uapi_ae_grid_config
> + * @padding: paddings
> + * @af_config: auto focus config &ipu3_uapi_af_config_s
> + * @awb_fr_config: &ipu3_uapi_awb_fr_config_s, default resolution 16x16
> + */
> +struct ipu3_uapi_4a_config {
> +	struct ipu3_uapi_awb_config_s awb_config __attribute__((aligned(32)));
> +	struct ipu3_uapi_ae_grid_config ae_grd_config;
> +	__u8 padding[20];
> +	struct ipu3_uapi_af_config_s af_config;
> +	struct ipu3_uapi_awb_fr_config_s awb_fr_config;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bubble_info - Bubble info for host side debugging
> + *
> + * @num_of_stripes: A single frame is divided into several parts called stripes
> + *		    due to limitation on line buffer memory.
> + *		    The separation between the stripes is vertical. Each such
> + *		    stripe is processed as a single frame by the ISP pipe.
> + * @padding: padding bytes.
> + * @num_sets: number of sets.
> + * @padding1: padding bytes.
> + * @size_of_set: set size.
> + * @padding2: padding bytes.
> + * @bubble_size: is the amount of padding in the bubble expressed in "sets".
> + * @padding3: padding bytes.
> + */
> +struct ipu3_uapi_bubble_info {
> +	__u32 num_of_stripes __attribute__((aligned(32)));
> +	__u8 padding[28];
> +	__u32 num_sets;
> +	__u8 padding1[28];
> +	__u32 size_of_set;
> +	__u8 padding2[28];
> +	__u32 bubble_size;
> +	__u8 padding3[28];
> +} __packed;
> +
> +/*
> + * struct ipu3_uapi_stats_3a_bubble_info_per_stripe
> + */
> +struct ipu3_uapi_stats_3a_bubble_info_per_stripe {
> +	struct ipu3_uapi_bubble_info awb[IPU3_UAPI_MAX_STRIPES];
> +	struct ipu3_uapi_bubble_info af[IPU3_UAPI_MAX_STRIPES];
> +	struct ipu3_uapi_bubble_info awb_fr[IPU3_UAPI_MAX_STRIPES];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_ff_status - Enable bits for each 3A fixed function
> + *
> + * @awb_en: auto white balance enable
> + * @padding: padding config
> + * @ae_en: auto exposure enable
> + * @padding1: padding config
> + * @af_en: auto focus enable
> + * @padding2: padding config
> + * @awb_fr_en: awb filter response enable bit
> + * @padding3: padding config
> + */
> +struct ipu3_uapi_ff_status {
> +	__u32 awb_en __attribute__((aligned(32)));
> +	__u8 padding[28];
> +	__u32 ae_en;
> +	__u8 padding1[28];
> +	__u32 af_en;
> +	__u8 padding2[28];
> +	__u32 awb_fr_en;
> +	__u8 padding3[28];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_stats_3a - 3A statistics
> + *
> + * @awb_raw_buffer: auto white balance meta data &ipu3_uapi_awb_raw_buffer
> + * @ae_raw_buffer: auto exposure raw data &ipu3_uapi_ae_raw_buffer_aligned
> + * @af_raw_buffer: &ipu3_uapi_af_raw_buffer for auto focus meta data
> + * @awb_fr_raw_buffer: value as specified by &ipu3_uapi_awb_fr_raw_buffer
> + * @stats_4a_config: 4a statistics config as defined by &ipu3_uapi_4a_config.
> + * @ae_join_buffers: 1 to use ae_raw_buffer.
> + * @padding: padding config
> + * @stats_3a_bubble_per_stripe: a &ipu3_uapi_stats_3a_bubble_info_per_stripe
> + * @stats_3a_status: 3a statistics status set in &ipu3_uapi_ff_status
> + */
> +struct ipu3_uapi_stats_3a {
> +	struct ipu3_uapi_awb_raw_buffer awb_raw_buffer __attribute__((aligned(32)));
> +	struct ipu3_uapi_ae_raw_buffer_aligned
> +			ae_raw_buffer[IPU3_UAPI_MAX_STRIPES];
> +	struct ipu3_uapi_af_raw_buffer af_raw_buffer;
> +	struct ipu3_uapi_awb_fr_raw_buffer awb_fr_raw_buffer;
> +	struct ipu3_uapi_4a_config stats_4a_config;
> +	__u32 ae_join_buffers;
> +	__u8 padding[28];
> +	struct ipu3_uapi_stats_3a_bubble_info_per_stripe
> +			stats_3a_bubble_per_stripe;
> +	struct ipu3_uapi_ff_status stats_3a_status;
> +} __packed;
> +
> +/******************* ipu3_uapi_acc_param *******************/
> +
> +#define IPU3_UAPI_ISP_VEC_ELEMS				64
> +#define IPU3_UAPI_ISP_TNR3_VMEM_LEN			9
> +
> +#define IPU3_UAPI_BNR_LUT_SIZE				32
> +
> +/* number of elements in gamma correction LUT */
> +#define IPU3_UAPI_GAMMA_CORR_LUT_ENTRIES		256
> +
> +/* largest grid is 73x56, for grid_height_per_slice of 2, 73x2 = 146 */
> +#define IPU3_UAPI_SHD_MAX_CELLS_PER_SET			146
> +#define IPU3_UAPI_SHD_MAX_CFG_SETS			28
> +/* Normalization shift aka nf */
> +#define IPU3_UAPI_SHD_BLGR_NF_SHIFT			13
> +#define IPU3_UAPI_SHD_BLGR_NF_MASK			7
> +
> +#define IPU3_UAPI_YUVP2_TCC_MACC_TABLE_ELEMENTS		16
> +#define IPU3_UAPI_YUVP2_TCC_INV_Y_LUT_ELEMENTS		14
> +#define IPU3_UAPI_YUVP2_TCC_GAIN_PCWL_LUT_ELEMENTS	258
> +#define IPU3_UAPI_YUVP2_TCC_R_SQR_LUT_ELEMENTS		24
> +
> +#define IPU3_UAPI_ANR_LUT_SIZE				26
> +#define IPU3_UAPI_ANR_PYRAMID_SIZE			22
> +
> +#define IPU3_UAPI_LIN_LUT_SIZE				64
> +
> +/* Bayer Noise Reduction related structs */
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_wb_gains_config - White balance gains
> + *
> + * @gr:	white balance gain for Gr channel.
> + * @r:	white balance gain for R channel.
> + * @b:	white balance gain for B channel.
> + * @gb:	white balance gain for Gb channel.
> + *
> + * Precision u3.13, range [0, 8]. White balance correction is done by applying

[0, 8[

(or [0, 8), but the same notation needs to be used everywhere).

> + * a multiplicative gain to each color channels prior to BNR.
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
> + *
> + * @gr:	white balance threshold gain for Gr channel.
> + * @r:	white balance threshold gain for R channel.
> + * @b:	white balance threshold gain for B channel.
> + * @gb:	white balance threshold gain for Gb channel.
> + *
> + * Defines the threshold that specifies how different a defect pixel can be from
> + * its neighbors.(used by dynamic defect pixel correction sub block)
> + * Precision u4.4 range [0, 8].
> + */
> +struct ipu3_uapi_bnr_static_config_wb_gains_thr_config {
> +	__u8 gr;
> +	__u8 r;
> +	__u8 b;
> +	__u8 gb;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_thr_coeffs_config - Noise model
> + *				coefficients that controls noise threshold
> + *
> + * @cf:	Free coefficient for threshold calculation, range [0, 8191], default 0.
> + * @__reserved0:	reserved
> + * @cg:	Gain coefficient for threshold calculation, [0, 31], default 8.
> + * @ci:	Intensity coefficient for threshold calculation. range [0, 0x1f]
> + *	default 6.
> + * 	format: u3.2 (3 most significant bits represent whole number,
> + *	2 least significant bits represent the fractional part
> + *	with each count representing 0.25)
> + *	e.g 6 in binary format is 00110, that translates to 1.5
> + * @__reserved1:	reserved
> + * @r_nf:	Normalization shift value for r^2 calculation, range [12, 20]
> + *		where r is a radius of pixel [row, col] from centor of sensor.
> + *		default 14.
> + *
> + * Threshold used to distinguish between noise and details.
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
> + * struct ipu3_uapi_bnr_static_config_thr_ctrl_shd_config - Shading config
> + *
> + * @gr:	Coefficient defines lens shading gain approximation for gr channel
> + * @r:	Coefficient defines lens shading gain approximation for r channel
> + * @b:	Coefficient defines lens shading gain approximation for b channel
> + * @gb:	Coefficient defines lens shading gain approximation for gb channel
> + *
> + * Parameters for noise model (NM) adaptation of BNR due to shading correction.
> + * All above have precision of u3.3, default to 0.
> + */
> +struct ipu3_uapi_bnr_static_config_thr_ctrl_shd_config {
> +	__u8 gr;
> +	__u8 r;
> +	__u8 b;
> +	__u8 gb;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_opt_center_config - Optical center config
> + *
> + * @x_reset:	Reset value of X (col start - X center). Precision s12.0.
> + * @__reserved0:	reserved
> + * @y_reset:	Reset value of Y (row start - Y center). Precision s12.0.
> + * @__reserved2:	reserved
> + *
> + * Distance from corner to optical center for NM adaptation due to shading
> + * correction (should be calculated based on shading tables)
> + */
> +struct ipu3_uapi_bnr_static_config_opt_center_config {
> +	__s32 x_reset:13;
> +	__u32 __reserved0:3;
> +	__s32 y_reset:13;
> +	__u32 __reserved2:3;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_lut_config - BNR square root lookup table
> + *
> + * @values: pre-calculated values of square root function.
> + *
> + * LUT implementation of square root operation.
> + */
> +struct ipu3_uapi_bnr_static_config_lut_config {
> +	__u8 values[IPU3_UAPI_BNR_LUT_SIZE];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_bp_ctrl_config - Detect bad pixels (bp)
> + *
> + * @bp_thr_gain:	Defines the threshold that specifies how different a
> + *			defect pixel can be from its neighbors. Threshold is
> + *			dependent on de-noise threshold calculated by algorithm.
> + *			Range [4, 31], default 4.
> + * @__reserved0:	reserved
> + * @defect_mode:	Mode of addressed defect pixels,
> + *			0 - single defect pixel is expected,
> + *			1 - 2 adjacent defect pixels are expected, default 1.
> + * @bp_gain:	Defines how 2nd derivation that passes through a defect pixel
> + *		is different from 2nd derivations that pass through
> + *		neighbor pixels. u4.2, range [0, 256], default 8.
> + * @__reserved1:	reserved
> + * @w0_coeff:	Blending coefficient of defect pixel correction.
> + *		Precision u4, range [0, 8], default 8.
> + * @__reserved2:	reserved
> + * @w1_coeff:	Enable influence of incorrect defect pixel correction to be
> + *		avoided. Precision u4, range [1, 8], default 8.
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
> + * struct ipu3_uapi_bnr_static_config_dn_detect_ctrl_config - Denoising config
> + *
> + * @alpha:	Weight of central element of smoothing filter.
> + * @beta:	Weight of peripheral elements of smoothing filter, default 4.
> + * @gamma:	Weight of diagonal elements of smoothing filter, default 4.
> + *
> + * beta and gamma parameter define the strength of the noise removal filter.
> + *		All above has precision u0.4, range [0, 0xf]
> + *		format: u0.4 (no / zero bits represent whole number,
> + *		4 bits represent the fractional part
> + *		with each count representing 0.0625)
> + *		e.g 0xf translates to 0.0625x15 = 0.9375
> + *
> + * @__reserved0:	reserved
> + * @max_inf:	Maximum increase of peripheral or diagonal element influence
> + *		relative to the pre-defined value range: [0x5, 0xa]
> + * @__reserved1:	reserved
> + * @gd_enable:	Green disparity enable control, 0 - disable, 1 - enable.
> + * @bpc_enable:	Bad pixel correction enable control, 0 - disable, 1 - enable.
> + * @bnr_enable:	Bayer noise removal enable control, 0 - disable, 1 - enable.
> + * @ff_enable:	Fixed function enable, 0 - disable, 1 - enable.
> + * @__reserved2:	reserved
> + */
> +struct ipu3_uapi_bnr_static_config_dn_detect_ctrl_config {
> +	__u32 alpha:4;
> +	__u32 beta:4;
> +	__u32 gamma:4;
> +	__u32 __reserved0:4;
> +	__u32 max_inf:4;
> +	__u32 __reserved1:7;
> +	__u32 gd_enable:1;
> +	__u32 bpc_enable:1;
> +	__u32 bnr_enable:1;
> +	__u32 ff_enable:1;
> +	__u32 __reserved2:1;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_opt_center_sqr_config - BNR optical square
> + *
> + * @x_sqr_reset: Reset value of X^2.
> + * @y_sqr_reset: Reset value of Y^2.
> + *
> + * Please note:
> + *
> + *    #. X and Y ref to
> + *       &ipu3_uapi_bnr_static_config_opt_center_config
> + *    #. Both structs are used in threshold formula to calculate r^2, where r
> + *       is a radius of pixel [row, col] from centor of sensor.
> + */
> +struct ipu3_uapi_bnr_static_config_opt_center_sqr_config {
> +	__u32 x_sqr_reset;
> +	__u32 y_sqr_reset;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config - BNR static config
> + *
> + * @wb_gains:	white balance gains &ipu3_uapi_bnr_static_config_wb_gains_config
> + * @wb_gains_thr:	white balance gains threshold as defined by
> + *			&ipu3_uapi_bnr_static_config_wb_gains_thr_config
> + * @thr_coeffs:	coefficients of threshold
> + *		&ipu3_uapi_bnr_static_config_thr_coeffs_config
> + * @thr_ctrl_shd:	control of shading threshold
> + *			&ipu3_uapi_bnr_static_config_thr_ctrl_shd_config
> + * @opt_center:	optical center &ipu3_uapi_bnr_static_config_opt_center_config
> + *
> + * Above parameters and opt_center_sqr are used for white balance and shading.
> + *
> + * @lut:	lookup table &ipu3_uapi_bnr_static_config_lut_config
> + * @bp_ctrl:	detect and remove bad pixels as defined in struct
> + *		&ipu3_uapi_bnr_static_config_bp_ctrl_config
> + * @dn_detect_ctrl:	detect and remove noise.
> + *			&ipu3_uapi_bnr_static_config_dn_detect_ctrl_config
> + * @column_size:	The number of pixels in column.
> + * @opt_center_sqr:	Reset value of r^2 to optical center, see
> + *			&ipu3_uapi_bnr_static_config_opt_center_sqr_config.
> + */
> +struct ipu3_uapi_bnr_static_config {
> +	struct ipu3_uapi_bnr_static_config_wb_gains_config wb_gains;
> +	struct ipu3_uapi_bnr_static_config_wb_gains_thr_config wb_gains_thr;
> +	struct ipu3_uapi_bnr_static_config_thr_coeffs_config thr_coeffs;
> +	struct ipu3_uapi_bnr_static_config_thr_ctrl_shd_config thr_ctrl_shd;
> +	struct ipu3_uapi_bnr_static_config_opt_center_config opt_center;
> +	struct ipu3_uapi_bnr_static_config_lut_config lut;
> +	struct ipu3_uapi_bnr_static_config_bp_ctrl_config bp_ctrl;
> +	struct ipu3_uapi_bnr_static_config_dn_detect_ctrl_config dn_detect_ctrl;
> +	__u32 column_size;
> +	struct ipu3_uapi_bnr_static_config_opt_center_sqr_config opt_center_sqr;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_bnr_static_config_green_disparity - Correct green disparity
> + *
> + * @gd_red:	Shading gain coeff for gr disparity level in bright red region.
> + *		Precision u0.6, default 4(0.0625).
> + * @__reserved0:	reserved
> + * @gd_green:	Shading gain coeff for gr disparity level in bright green
> + *		region. Precision u0.6, default 4(0.0625).
> + * @__reserved1:	reserved
> + * @gd_blue:	Shading gain coeff for gr disparity level in bright blue region.
> + *		Precision u0.6, default 4(0.0625).
> + * @__reserved2:	reserved
> + * @gd_black:	Maximal green disparity level in dark region (stronger disparity
> + *		assumed to be image detail). Precision u14, default 80.
> + * @__reserved3:	reserved
> + * @gd_shading:	Change maximal green disparity level according to square
> + *		distance from image center.
> + * @__reserved4:	reserved
> + * @gd_support:	Lower bound for the number of second green color pixels in
> + *		current pixel neighborhood with less than threshold difference
> + *		from it.
> + *
> + * The shading gain coeff of red, green, blue and black are used to calculate
> + * threshold given a pixel's color value and its coordinates in the image.
> + *
> + * @__reserved5:	reserved
> + * @gd_clip:	Turn green disparity clip on/off, [0, 1], default 1.
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
> +	__u32 gd_clip:1;
> +	__u32 gd_central_weight:4;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_dm_config - De-mosaic parameters
> + *
> + * @dm_en:	de-mosaic enable.
> + * @ch_ar_en:	Checker artifacts removal enable flag. Default 0.
> + * @fcc_en:	False color correction (FCC) enable flag. Default 0.
> + * @__reserved0:	reserved
> + * @frame_width:	do not care
> + * @gamma_sc:	Sharpening coefficient (coefficient of 2-d derivation of
> + *		complementary color in Hamilton-Adams interpolation).
> + *		u5, range [0, 31], default 8.
> + * @__reserved1:	reserved
> + * @lc_ctrl:	Parameter that controls weights of Chroma Homogeneity metric
> + *		in calculation of final homogeneity metric.
> + *		u5, range [0, 31], default 7.
> + * @__reserved2:	reserved
> + * @cr_param1:	First parameter that defines Checker artifact removal
> + *		feature gain.Precision u5, range [0, 31], default 8.
> + * @__reserved3:	reserved
> + * @cr_param2:	Second parameter that defines Checker artifact removal
> + *		feature gain. Precision u5, range [0, 31], default 8.
> + * @__reserved4:	reserved
> + * @coring_param:	Defines power of false color correction operation.
> + *			low for preserving edge colors, high for preserving gray
> + *			edge artifacts. u1.4, range [0, 1.9375], default 4(0.25).
> + * @__reserved5:	reserved
> + *
> + * The demosaic fixed function block is responsible to covert Bayer(mosaiced)
> + * images into color images based on demosaicing algorithm.
> + */
> +struct ipu3_uapi_dm_config {
> +	__u32 dm_en:1;
> +	__u32 ch_ar_en:1;
> +	__u32 fcc_en:1;
> +	__u32 __reserved0:13;
> +	__u32 frame_width:16;
> +
> +	__u32 gamma_sc:5;
> +	__u32 __reserved1:3;
> +	__u32 lc_ctrl:5;
> +	__u32 __reserved2:3;
> +	__u32 cr_param1:5;
> +	__u32 __reserved3:3;
> +	__u32 cr_param2:5;
> +	__u32 __reserved4:3;
> +
> +	__u32 coring_param:5;
> +	__u32 __reserved5:27;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_ccm_mat_config - Color correction matrix
> + *
> + * @coeff_m11: CCM 3x3 coefficient, range [-65536, 65535]
> + * @coeff_m12: CCM 3x3 coefficient, range [-8192, 8191]
> + * @coeff_m13: CCM 3x3 coefficient, range [-32768, 32767]
> + * @coeff_o_r: Bias 3x1 coefficient, range [-8191, 8181]
> + * @coeff_m21: CCM 3x3 coefficient, range [-32767, 32767]
> + * @coeff_m22: CCM 3x3 coefficient, range [-8192, 8191]
> + * @coeff_m23: CCM 3x3 coefficient, range [-32768, 32767]
> + * @coeff_o_g: Bias 3x1 coefficient, range [-8191, 8181]
> + * @coeff_m31: CCM 3x3 coefficient, range [-32768, 32767]
> + * @coeff_m32: CCM 3x3 coefficient, range [-8192, 8191]
> + * @coeff_m33: CCM 3x3 coefficient, range [-32768, 32767]
> + * @coeff_o_b: Bias 3x1 coefficient, range [-8191, 8181]
> + *
> + * Transform sensor specific color space to standard sRGB by applying 3x3 matrix
> + * and adding a bias vector O. The transformation is basically a rotation and
> + * translation in the 3-dimensional color spaces. Here are the defaults:
> + *
> + *	9775,	-2671,	1087,	0
> + *	-1071,	8303,	815,	0
> + *	-23,	-7887,	16103,	0
> + */
> +struct ipu3_uapi_ccm_mat_config {
> +	__s16 coeff_m11;
> +	__s16 coeff_m12;
> +	__s16 coeff_m13;
> +	__s16 coeff_o_r;
> +	__s16 coeff_m21;
> +	__s16 coeff_m22;
> +	__s16 coeff_m23;
> +	__s16 coeff_o_g;
> +	__s16 coeff_m31;
> +	__s16 coeff_m32;
> +	__s16 coeff_m33;
> +	__s16 coeff_o_b;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_gamma_corr_ctrl - Gamma correction
> + *
> + * @enable: gamma correction enable.
> + * @__reserved: reserved
> + */
> +struct ipu3_uapi_gamma_corr_ctrl {
> +	__u32 enable:1;
> +	__u32 __reserved:31;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_gamma_corr_lut - Per-pixel tone mapping implemented as LUT.
> + *
> + * @lut:	256 tabulated values of the gamma function. LUT[1].. LUT[256]
> + *		format u13.0, range [0, 8191].
> + *
> + * The tone mapping operation is done by a Piece wise linear graph
> + * that is implemented as a lookup table(LUT). The pixel component input
> + * intensity is the X-axis of the graph which is the table entry.
> + */
> +struct ipu3_uapi_gamma_corr_lut {
> +	__u16 lut[IPU3_UAPI_GAMMA_CORR_LUT_ENTRIES];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_gamma_config - Gamma config
> + *
> + * @gc_ctrl: control of gamma correction &ipu3_uapi_gamma_corr_ctrl
> + * @gc_lut: lookup table of gamma correction &ipu3_uapi_gamma_corr_lut
> + */
> +struct ipu3_uapi_gamma_config {
> +	struct ipu3_uapi_gamma_corr_ctrl gc_ctrl __attribute__((aligned(32)));
> +	struct ipu3_uapi_gamma_corr_lut gc_lut __attribute__((aligned(32)));
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_csc_mat_config - Color space conversion matrix config
> + *
> + * @coeff_c11:	Conversion matrix value, format s0.14, range [-1, 1], default 1.

You can't represent 1; it's 8191/8192. How about [-1, 1[ ?

Is the default 1 or 8191? The numerical value is used elsewhere but here
it seems that this might not be the case. The same for other cases below.

> + * @coeff_c12:	Conversion matrix value, format s0.14, range [-1, 1], default 0.
> + * @coeff_c13:	Conversion matrix value, format s0.14, range [-1, 1], default 0.
> + * @coeff_b1:	Bias 3x1 coefficient, s13,0 range [-8191, 8181], default 0.
> + * @coeff_c21:	Conversion matrix value, format s0.14, range [-1, 1], default 0.
> + * @coeff_c22:	Conversion matrix value, format s0.14, range [-1, 1], default 1.
> + * @coeff_c23:	Conversion matrix value, format s0.14, range [-1, 1], default 0.
> + * @coeff_b2:	Bias 3x1 coefficient, s13,0 range [-8191, 8181], default 0.
> + * @coeff_c31:	Conversion matrix value, format s0.14, range [-1, 1], default 0.
> + * @coeff_c32:	Conversion matrix value, format s0.14, range [-1, 1], default 0.
> + * @coeff_c33:	Conversion matrix value, format s0.14, range [-1, 1], default 1.
> + * @coeff_b3:	Bias 3x1 coefficient, s13,0 range [-8191, 8181], default 0.
> + *
> + * To transform each pixel from RGB to YUV (Y - brightness/luminance,
> + * UV -chroma) by applying the pixel's values by a 3x3 matrix and adding an
> + * optional bias 3x1 vector.
> + */
> +struct ipu3_uapi_csc_mat_config {
> +	__s16 coeff_c11;
> +	__s16 coeff_c12;
> +	__s16 coeff_c13;
> +	__s16 coeff_b1;
> +	__s16 coeff_c21;
> +	__s16 coeff_c22;
> +	__s16 coeff_c23;
> +	__s16 coeff_b2;
> +	__s16 coeff_c31;
> +	__s16 coeff_c32;
> +	__s16 coeff_c33;
> +	__s16 coeff_b3;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_cds_params - Chroma down-scaling
> + *
> + * @ds_c00:	range [0, 3]
> + * @ds_c01:	range [0, 3]
> + * @ds_c02:	range [0, 3]
> + * @ds_c03:	range [0, 3]
> + * @ds_c10:	range [0, 3]
> + * @ds_c11:	range [0, 3]
> + * @ds_c12:	range [0, 3]
> + * @ds_c13:	range [0, 3]
> + *
> + * In case user does not provide, above 4x2 filter will use following defaults:
> + *	1, 3, 3, 1,
> + *	1, 3, 3, 1,
> + *
> + * @ds_nf:	Normalization factor for Chroma output downscaling filter,
> + *		range 0,4, default 2.
> + * @__reserved0:	reserved
> + * @csc_en:	Color space conversion enable
> + * @uv_bin_output:	0: output YUV 4.2.0, 1: output YUV 4.2.2(default).
> + * @__reserved1:	reserved
> + */
> +struct ipu3_uapi_cds_params {
> +	__u32 ds_c00:2;
> +	__u32 ds_c01:2;
> +	__u32 ds_c02:2;
> +	__u32 ds_c03:2;
> +	__u32 ds_c10:2;
> +	__u32 ds_c11:2;
> +	__u32 ds_c12:2;
> +	__u32 ds_c13:2;
> +	__u32 ds_nf:5;
> +	__u32 __reserved0:3;
> +	__u32 csc_en:1;
> +	__u32 uv_bin_output:1;
> +	__u32 __reserved1:6;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_shd_grid_config - Bayer shading(darkening) correction
> + *
> + * @width:	Grid horizontal dimensions, u8, [8, 128], default 73
> + * @height:	Grid vertical dimensions, u8, [8, 128], default 56
> + * @block_width_log2:	Log2 of the width of the grid cell in pixel count
> + *			u4, [0, 15], default value 5.
> + * @__reserved0:	reserved
> + * @block_height_log2:	Log2 of the height of the grid cell in pixel count
> + *			u4, [0, 15], default value 6.
> + * @__reserved1:	reserved
> + * @grid_height_per_slice:	SHD_MAX_CELLS_PER_SET/width.
> + *				(with SHD_MAX_CELLS_PER_SET = 146).
> + * @x_start:	X value of top left corner of sensor relative to ROI
> + *		u12, [-4096, 0]. default 0, only negative values.
> + * @y_start:	Y value of top left corner of sensor relative to ROI
> + *		u12, [-4096, 0]. default 0, only negative values.

I suppose u12 is incorrect here, if the value is signed --- and negative
(sign bit) if not 0?

> + */
> +struct ipu3_uapi_shd_grid_config {
> +	/* reg 0 */
> +	__u8 width;
> +	__u8 height;
> +	__u8 block_width_log2:3;
> +	__u8 __reserved0:1;
> +	__u8 block_height_log2:3;
> +	__u8 __reserved1:1;
> +	__u8 grid_height_per_slice;
> +	/* reg 1 */
> +	__s16 x_start;
> +	__s16 y_start;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_shd_general_config - Shading general config
> + *
> + * @init_set_vrt_offst_ul: set vertical offset,
> + *			y_start >> block_height_log2 % grid_height_per_slice.
> + * @shd_enable: shading enable.
> + * @gain_factor: Gain factor. Shift calculated anti shading value. Precision u2.
> + *		0x0 - gain factor [1, 5], means no shift interpolated value.
> + *		0x1 - gain factor [1, 9], means shift interpolated by 1.
> + *		0x2 - gain factor [1, 17], means shift interpolated by 2.
> + * @__reserved: reserved
> + *
> + * Correction is performed by multiplying a gain factor for each of the 4 Bayer
> + * channels as a function of the pixel location in the sensor.
> + */
> +struct ipu3_uapi_shd_general_config {
> +	__u32 init_set_vrt_offst_ul:8;
> +	__u32 shd_enable:1;
> +	__u32 gain_factor:2;
> +	__u32 __reserved:21;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_shd_black_level_config - Black level correction
> + *
> + * @bl_r:	Bios values for green red. s11 range [-2048, 2047].
> + * @bl_gr:	Bios values for green blue. s11 range [-2048, 2047].
> + * @bl_gb:	Bios values for red. s11 range [-2048, 2047].
> + * @bl_b:	Bios values for blue. s11 range [-2048, 2047].
> + */
> +struct ipu3_uapi_shd_black_level_config {
> +	__s16 bl_r;
> +	__s16 bl_gr;
> +	__s16 bl_gb;
> +	__s16 bl_b;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_shd_config_static - Shading config static
> + *
> + * @grid:	shading grid config &ipu3_uapi_shd_grid_config
> + * @general:	shading general config &ipu3_uapi_shd_general_config
> + * @black_level:	black level config for shading correction as defined by
> + *			&ipu3_uapi_shd_black_level_config
> + */
> +struct ipu3_uapi_shd_config_static {
> +	struct ipu3_uapi_shd_grid_config grid;
> +	struct ipu3_uapi_shd_general_config general;
> +	struct ipu3_uapi_shd_black_level_config black_level;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_shd_lut - Shading gain factor lookup table.
> + *
> + * @sets: array
> + * @sets.r_and_gr: Red and GreenR Lookup table.
> + * @sets.r_and_gr.r: Red shading factor.
> + * @sets.r_and_gr.gr: GreenR shading factor.
> + * @sets.__reserved1: reserved
> + * @sets.gb_and_b: GreenB and Blue Lookup table.
> + * @sets.gb_and_b.gb: GreenB shading factor.
> + * @sets.gb_and_b.b: Blue shading factor.
> + * @sets.__reserved2: reserved
> + *
> + * Map to shading correction LUT register set.
> + */
> +struct ipu3_uapi_shd_lut {
> +	struct {
> +		struct {
> +			__u16 r;
> +			__u16 gr;
> +		} r_and_gr[IPU3_UAPI_SHD_MAX_CELLS_PER_SET];
> +		__u8 __reserved1[24];
> +		struct {
> +			__u16 gb;
> +			__u16 b;
> +		} gb_and_b[IPU3_UAPI_SHD_MAX_CELLS_PER_SET];
> +		__u8 __reserved2[24];
> +	} sets[IPU3_UAPI_SHD_MAX_CFG_SETS];
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_shd_config - Shading config
> + *
> + * @shd:	shading static config, see &ipu3_uapi_shd_config_static
> + * @shd_lut:	shading lookup table &ipu3_uapi_shd_lut
> + */
> +struct ipu3_uapi_shd_config {
> +	struct ipu3_uapi_shd_config_static shd __attribute__((aligned(32)));
> +	struct ipu3_uapi_shd_lut shd_lut __attribute__((aligned(32)));
> +} __packed;
> +
> +/* Image Enhancement Filter directed */
> +
> +/**
> + * struct ipu3_uapi_iefd_cux2 - IEFd Config Unit 2 parameters
> + *
> + * @x0:		X0 point of Config Unit, u9.0, default 0.
> + * @x1:		X1 point of Config Unit, u9.0, default 0.
> + * @a01:	Slope A of Config Unit, s4.4, default 0.
> + * @b01:	Always 0.
> + *
> + * Calculate weight for blending directed and non-directed denoise elements
> + *
> + * Note:
> + * Each instance of Config Unit needs X coordinate of n points and
> + * slope A factor between points calculated by driver based on calibration
> + * parameters.
> + */
> +struct ipu3_uapi_iefd_cux2 {
> +	__u32 x0:9;
> +	__u32 x1:9;
> +	__u32 a01:9;
> +	__u32 b01:5;	/* NOTE: hardcoded to zero */
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_iefd_cux6_ed - Calculate power of non-directed sharpening
> + *				   element, Config Unit 6 for edge detail (ED).
> + *
> + * @x0:	X coordinate of point 0, u9.0, default 0.
> + * @x1:	X coordinate of point 1, u9.0, default 0.
> + * @x2:	X coordinate of point 2, u9.0, default 0.
> + * @__reserved0:	reserved
> + * @x3:	X coordinate of point 3, u9.0, default 0.
> + * @x4:	X coordinate of point 4, u9.0, default 0.
> + * @x5:	X coordinate of point 5, u9.0, default 0.
> + * @__reserved1:	reserved
> + * @a01:	slope A points 01, s4.4, default 0.
> + * @a12:	slope A points 12, s4.4, default 0.
> + * @a23:	slope A points 23, s4.4, default 0.
> + * @__reserved2:	reserved
> + * @a34:	slope A points 34, s4.4, default 0.
> + * @a45:	slope A points 45, s4.4, default 0.
> + * @__reserved3:	reserved
> + * @b01:	slope B points 01, s4.4, default 0.
> + * @b12:	slope B points 12, s4.4, default 0.
> + * @b23:	slope B points 23, s4.4, default 0.
> + * @__reserved4:	reserved
> + * @b34:	slope B points 34, s4.4, default 0.
> + * @b45:	slope B points 45, s4.4, default 0.
> + * @__reserved5:	reserved
> + */
> +struct ipu3_uapi_iefd_cux6_ed {
> +	__u32 x0:9;
> +	__u32 x1:9;
> +	__u32 x2:9;
> +	__u32 __reserved0:5;
> +
> +	__u32 x3:9;
> +	__u32 x4:9;
> +	__u32 x5:9;
> +	__u32 __reserved1:5;
> +
> +	__u32 a01:9;
> +	__u32 a12:9;
> +	__u32 a23:9;
> +	__u32 __reserved2:5;
> +
> +	__u32 a34:9;
> +	__u32 a45:9;
> +	__u32 __reserved3:14;
> +
> +	__u32 b01:9;
> +	__u32 b12:9;
> +	__u32 b23:9;
> +	__u32 __reserved4:5;
> +
> +	__u32 b34:9;
> +	__u32 b45:9;
> +	__u32 __reserved5:14;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_iefd_cux2_1 - Calculate power of non-directed denoise
> + *				  element apply.
> + * @x0: X0 point of Config Unit, u9.0, default 0.
> + * @x1: X1 point of Config Unit, u9.0, default 0.
> + * @a01: Slope A of Config Unit, s4.4, default 0.

The field is marked unsigned below. Which one is correct?

> + * @__reserved1: reserved
> + * @b01: offset B0 of Config Unit, u7.0, default 0.
> + * @__reserved2: reserved
> + */
> +struct ipu3_uapi_iefd_cux2_1 {
> +	__u32 x0:9;
> +	__u32 x1:9;
> +	__u32 a01:9;
> +	__u32 __reserved1:5;
> +
> +	__u32 b01:8;
> +	__u32 __reserved2:24;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_iefd_cux4 - Calculate power of non-directed sharpening
> + *				element.
> + *
> + * @x0:	X0 point of Config Unit, u9.0, default 0.
> + * @x1:	X1 point of Config Unit, u9.0, default 0.
> + * @x2:	X2 point of Config Unit, u9.0, default 0.
> + * @__reserved0:	reserved
> + * @x3:	X3 point of Config Unit, u9.0, default 0.
> + * @a01:	Slope A0 of Config Unit, s4.4, default 0.
> + * @a12:	Slope A1 of Config Unit, s4.4, default 0.

Same here, suggest __s32 below if this is signed.

> + * @__reserved1:	reserved
> + * @a23:	Slope A2 of Config Unit, s4.4, default 0.
> + * @b01:	Offset B0 of Config Unit, s7.0, default 0.
> + * @b12:	Offset B1 of Config Unit, s7.0, default 0.
> + * @__reserved2:	reserved
> + * @b23:	Offset B2 of Config Unit, s7.0, default 0.
> + * @__reserved3: reserved
> + */
> +struct ipu3_uapi_iefd_cux4 {
> +	__u32 x0:9;
> +	__u32 x1:9;
> +	__u32 x2:9;
> +	__u32 __reserved0:5;
> +
> +	__u32 x3:9;
> +	__u32 a01:9;
> +	__u32 a12:9;
> +	__u32 __reserved1:5;
> +
> +	__u32 a23:9;
> +	__u32 b01:8;
> +	__u32 b12:8;
> +	__u32 __reserved2:7;
> +
> +	__u32 b23:8;
> +	__u32 __reserved3:24;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_iefd_cux6_rad - Radial Config Unit (CU)
> + *
> + * @x0:	x0 points of Config Unit radial, u8.0
> + * @x1:	x1 points of Config Unit radial, u8.0
> + * @x2:	x2 points of Config Unit radial, u8.0
> + * @x3:	x3 points of Config Unit radial, u8.0
> + * @x4:	x4 points of Config Unit radial, u8.0
> + * @x5:	x5 points of Config Unit radial, u8.0
> + * @__reserved1: reserved
> + * @a01:	Slope A of Config Unit radial, s7.8
> + * @a12:	Slope A of Config Unit radial, s7.8
> + * @a23:	Slope A of Config Unit radial, s7.8
> + * @a34:	Slope A of Config Unit radial, s7.8
> + * @a45:	Slope A of Config Unit radial, s7.8
> + * @__reserved2: reserved
> + * @b01:	Slope B of Config Unit radial, s9.0
> + * @b12:	Slope B of Config Unit radial, s9.0
> + * @b23:	Slope B of Config Unit radial, s9.0
> + * @__reserved4: reserved
> + * @b34:	Slope B of Config Unit radial, s9.0
> + * @b45:	Slope B of Config Unit radial, s9.0
> + * @__reserved5: reserved
> + */
> +struct ipu3_uapi_iefd_cux6_rad {
> +	__u32 x0:8;
> +	__u32 x1:8;
> +	__u32 x2:8;
> +	__u32 x3:8;
> +
> +	__u32 x4:8;
> +	__u32 x5:8;
> +	__u32 __reserved1:16;
> +
> +	__u32 a01:16;
> +	__u32 a12:16;
> +
> +	__u32 a23:16;
> +	__u32 a34:16;
> +
> +	__u32 a45:16;
> +	__u32 __reserved2:16;
> +
> +	__u32 b01:10;
> +	__u32 b12:10;
> +	__u32 b23:10;
> +	__u32 __reserved4:2;
> +
> +	__u32 b34:10;
> +	__u32 b45:10;
> +	__u32 __reserved5:12;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_yuvp1_iefd_cfg_units - IEFd Config Units parameters
> + *
> + * @cu_1: calculate weight for blending directed and
> + *	  non-directed denoise elements. See &ipu3_uapi_iefd_cux2
> + * @cu_ed: calculate power of non-directed sharpening element, see
> + *	   &ipu3_uapi_iefd_cux6_ed
> + * @cu_3: calculate weight for blending directed and
> + *	  non-directed denoise elements. A &ipu3_uapi_iefd_cux2
> + * @cu_5: calculate power of non-directed denoise element apply, use
> + *	  &ipu3_uapi_iefd_cux2_1
> + * @cu_6: calculate power of non-directed sharpening element. See
> + *	  &ipu3_uapi_iefd_cux4
> + * @cu_7: calculate weight for blending directed and
> + *	  non-directed denoise elements. Use &ipu3_uapi_iefd_cux2
> + * @cu_unsharp: Config Unit of unsharp &ipu3_uapi_iefd_cux4
> + * @cu_radial: Config Unit of radial &ipu3_uapi_iefd_cux6_rad
> + * @cu_vssnlm: Config Unit of vssnlm &ipu3_uapi_iefd_cux2
> + */
> +struct ipu3_uapi_yuvp1_iefd_cfg_units {
> +	struct ipu3_uapi_iefd_cux2 cu_1;
> +	struct ipu3_uapi_iefd_cux6_ed cu_ed;
> +	struct ipu3_uapi_iefd_cux2 cu_3;
> +	struct ipu3_uapi_iefd_cux2_1 cu_5;
> +	struct ipu3_uapi_iefd_cux4 cu_6;
> +	struct ipu3_uapi_iefd_cux2 cu_7;
> +	struct ipu3_uapi_iefd_cux4 cu_unsharp;
> +	struct ipu3_uapi_iefd_cux6_rad cu_radial;
> +	struct ipu3_uapi_iefd_cux2 cu_vssnlm;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_yuvp1_iefd_config_s - IEFd config
> + *
> + * @horver_diag_coeff: Gradiant compensation, coefficient that compensates for
> + *		       different distance for vertical / horizontal and diagonal
> + *		       * gradient calculation (~1/sqrt(2)).
> + * @__reserved0: reserved
> + * @clamp_stitch: Slope to stitch between clamped and unclamped edge values
> + * @__reserved1: reserved
> + * @direct_metric_update: Update coeff for direction metric
> + * @__reserved2: reserved
> + * @ed_horver_diag_coeff: Radial Coefficient that compensates for
> + *			  different distance for vertical/horizontal and
> + *			  diagonal gradient calculation (~1/sqrt(2))
> + * @__reserved3: reserved
> + */
> +struct ipu3_uapi_yuvp1_iefd_config_s {
> +	__u32 horver_diag_coeff:7;
> +	__u32 __reserved0:1;
> +	__u32 clamp_stitch:6;
> +	__u32 __reserved1:2;
> +	__u32 direct_metric_update:5;
> +	__u32 __reserved2:3;
> +	__u32 ed_horver_diag_coeff:7;
> +	__u32 __reserved3:1;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_yuvp1_iefd_control - IEFd control
> + *
> + * @iefd_en:	Enable IEFd
> + * @denoise_en:	Enable denoise
> + * @direct_smooth_en:	Enable directional smooth
> + * @rad_en:	Enable radial update
> + * @vssnlm_en:	Enable VSSNLM output filter
> + * @__reserved:	reserved
> + */
> +struct ipu3_uapi_yuvp1_iefd_control {
> +	__u32 iefd_en:1;
> +	__u32 denoise_en:1;
> +	__u32 direct_smooth_en:1;
> +	__u32 rad_en:1;
> +	__u32 vssnlm_en:1;
> +	__u32 __reserved:27;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_sharp_cfg - Sharpening config
> + *
> + * @nega_lmt_txt: Sharpening limit for negative overshoots for texture.
> + * @__reserved0: reserved
> + * @posi_lmt_txt: Sharpening limit for positive overshoots for texture.
> + * @__reserved1: reserved
> + * @nega_lmt_dir: Sharpening limit for negative overshoots for direction (edge).
> + * @__reserved2: reserved
> + * @posi_lmt_dir: Sharpening limit for positive overshoots for direction (edge).
> + * @__reserved3: reserved
> + *
> + * Fixed point type u13.0, range [0, 8191].
> + */
> +struct ipu3_uapi_sharp_cfg {
> +	__u32 nega_lmt_txt:13;
> +	__u32 __reserved0:19;
> +	__u32 posi_lmt_txt:13;
> +	__u32 __reserved1:19;
> +	__u32 nega_lmt_dir:13;
> +	__u32 __reserved2:19;
> +	__u32 posi_lmt_dir:13;
> +	__u32 __reserved3:19;
> +} __packed;
> +
> +/**
> + * struct struct ipu3_uapi_far_w - Sharpening config for far sub-group
> + *
> + * @dir_shrp:	Weight of wide direct sharpening, u1.6, range [0, 64], default 64.
> + * @__reserved0:	reserved
> + * @dir_dns:	Weight of wide direct denoising, u1.6, range [0, 64], default 0.
> + * @__reserved1:	reserved
> + * @ndir_dns_powr:	Power of non-direct denoising,
> + *			Precision u1.6, range [0, 64], default 64.
> + * @__reserved2:	reserved
> + */
> +struct ipu3_uapi_far_w {
> +	__u32 dir_shrp:7;
> +	__u32 __reserved0:1;
> +	__u32 dir_dns:7;
> +	__u32 __reserved1:1;
> +	__u32 ndir_dns_powr:7;
> +	__u32 __reserved2:9;
> +} __packed;
> +
> +/**
> + * struct struct ipu3_uapi_unsharp_cfg - Unsharp config
> + *
> + * @unsharp_weight: Unsharp mask blending weight.
> + *		    u1.6, range [0, 64], default 16.
> + *		    0 - disabled, 64 - use only unsharp.
> + * @__reserved0: reserved
> + * @unsharp_amount: Unsharp mask amount, u4.5, range [0, 511], default 0.
> + * @__reserved1: reserved
> + */
> +struct ipu3_uapi_unsharp_cfg {
> +	__u32 unsharp_weight:7;
> +	__u32 __reserved0:1;
> +	__u32 unsharp_amount:9;
> +	__u32 __reserved1:15;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_yuvp1_iefd_shrp_cfg - IEFd sharpness config
> + *
> + * @cfg: sharpness config &ipu3_uapi_sharp_cfg
> + * @far_w: wide range config, value as specified by &ipu3_uapi_far_w:
> + *	The 5x5 environment is separated into 2 sub-groups, the 3x3 nearest
> + *	neighbors (8 pixels called Near), and the second order neighborhood
> + *	around them (16 pixels called Far).
> + * @unshrp_cfg: unsharpness config. &ipu3_uapi_unsharp_cfg
> + */
> +struct ipu3_uapi_yuvp1_iefd_shrp_cfg {
> +	struct ipu3_uapi_sharp_cfg cfg;
> +	struct ipu3_uapi_far_w far_w;
> +	struct ipu3_uapi_unsharp_cfg unshrp_cfg;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_unsharp_coef0 - Unsharp mask coefficients
> + *
> + * @c00: Coeff11, s0.8, range [-255, 255], default 1.
> + * @c01: Coeff12, s0.8, range [-255, 255], default 5.
> + * @c02: Coeff13, s0.8, range [-255, 255], default 9.
> + * @__reserved: reserved
> + *
> + * Configurable registers for common sharpening support.
> + */
> +struct ipu3_uapi_unsharp_coef0 {
> +	__u32 c00:9;
> +	__u32 c01:9;
> +	__u32 c02:9;
> +	__u32 __reserved:5;

__s32?

> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_unsharp_coef1 - Unsharp mask coefficients
> + *
> + * @c11: Coeff22, s0.8, range [-255, 255], default 29.
> + * @c12: Coeff23, s0.8, range [-255, 255], default 55.
> + * @c22: Coeff33, s0.8, range [-255, 255], default 96.
> + * @__reserved: reserved
> + */
> +struct ipu3_uapi_unsharp_coef1 {
> +	__u32 c11:9;
> +	__u32 c12:9;
> +	__u32 c22:9;

__s32?

> +	__u32 __reserved:5;
> +} __packed;
> +
> +/**
> + * struct ipu3_uapi_yuvp1_iefd_unshrp_cfg - Unsharp mask config
> + *
> + * @unsharp_coef0: unsharp coefficient 0 config. See &ipu3_uapi_unsharp_coef0
> + * @unsharp_coef1: unsharp coefficient 1 config. See &ipu3_uapi_unsharp_coef1
> + */
> +struct ipu3_uapi_yuvp1_iefd_unshrp_cfg {
> +	struct ipu3_uapi_unsharp_coef0 unsharp_coef0;
> +	struct ipu3_uapi_unsharp_coef1 unsharp_coef1;
> +} __packed;
> +

...

> +/**
> + * struct ipu3_uapi_isp_lin_vmem_params - Linearization parameters
> + *
> + * @lin_lutlow_gr: linearization look-up table for GR channel interpolation.
> + * @lin_lutlow_r: linearization look-up table for R channel interpolation.
> + * @lin_lutlow_b: linearization look-up table for B channel interpolation.
> + * @lin_lutlow_gb: linearization look-up table for GB channel interpolation.
> + *			lin_lutlow_gr / lin_lutlow_gr / lin_lutlow_gr /

Copy & paste issue here? Should the postfixes be gr, r, b and gb instead?

> + *			lin_lutlow_gr <= LIN_MAX_VALUE - 1.
> + * @lin_lutdif_gr:	lin_lutlow_gr[i+1] - lin_lutlow_gr[i].
> + * @lin_lutdif_r:	lin_lutlow_r[i+1] - lin_lutlow_r[i].
> + * @lin_lutdif_b:	lin_lutlow_b[i+1] - lin_lutlow_b[i].
> + * @lin_lutdif_gb:	lin_lutlow_gb[i+1] - lin_lutlow_gb[i].
> + */
> +struct ipu3_uapi_isp_lin_vmem_params {
> +	__s16 lin_lutlow_gr[IPU3_UAPI_LIN_LUT_SIZE];
> +	__s16 lin_lutlow_r[IPU3_UAPI_LIN_LUT_SIZE];
> +	__s16 lin_lutlow_b[IPU3_UAPI_LIN_LUT_SIZE];
> +	__s16 lin_lutlow_gb[IPU3_UAPI_LIN_LUT_SIZE];
> +	__s16 lin_lutdif_gr[IPU3_UAPI_LIN_LUT_SIZE];
> +	__s16 lin_lutdif_r[IPU3_UAPI_LIN_LUT_SIZE];
> +	__s16 lin_lutdif_b[IPU3_UAPI_LIN_LUT_SIZE];
> +	__s16 lin_lutdif_gb[IPU3_UAPI_LIN_LUT_SIZE];
> +} __packed;

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
